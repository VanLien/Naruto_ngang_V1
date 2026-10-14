#include "runner.h"
#include "CCLuaStack.h"

#include <stdio.h>
// #include <sys/sysinfo.h>
#include <time.h>
// #include <pthread.h>

#ifdef WIN32
#include <windows.h>
#else
#include <unistd.h>
#endif

extern "C"
{
#include "lauxlib.h"
}

void PRINTF(const char *format, ...)
{
	va_list arglist;
	int buffing;
	int retval;
	char buff[128];

	time_t t = time(NULL);
	struct tm *tt = localtime(&t);
	strftime(buff, sizeof(buff), "%y%m%d %H:%M:%S", tt);
	printf("[%s] ", buff);

	va_start(arglist, format);
	vprintf(format, arglist);
}

template <class T>
bool luaval_to(lua_State *L, int lo, T *p)
{
	if (lua_isnumber(L, lo))
	{
		*p = lua_tonumber(L, lo);
		return true;
	}
	else if (lua_isstring(L, lo))
	{
		*p = *lua_tostring(L, lo);
		return true;
	}
	return false;
}

template <>
bool luaval_to(lua_State *L, int lo, int *n)
{
	if (lua_isnumber(L, lo))
	{
		*n = int(lua_tonumber(L, lo));
		return true;
	}
	return false;
}

template <>
bool luaval_to(lua_State* L, int lo, std::string* s)
{
	if (lua_isstring(L, lo))
	{
		size_t length;
		const char *sz = lua_tolstring(L, lo, &length);
		s->assign(sz, length);
		return true;
	}
	return false;
}

template <class T>
bool luaval_to(lua_State *L, int lo, std::vector<T> *v)
{
	bool ok = true;
	if (!lua_istable(L, lo))
	{
		ok = false;
	}

	if (ok)
	{
		lo += 1 + lua_gettop(L);
		lua_pushnil(L);				 /* first key L: lotable ..... nil */
		while (0 != lua_next(L, lo)) /* L: lotable ..... key value */
		{
			// value
			T val;
			luaval_to(L, -1, &val);
			lua_pop(L, 1); /* L: lotable ..... key */

			v->push_back(val);
		}
	}
	return ok;
}

template <class KT, class VT>
bool luaval_to(lua_State *L, int lo, std::map<KT, VT> *m)
{
	bool ok = true;
	if (!lua_istable(L, lo))
	{
		ok = false;
	}

	if (ok)
	{
		lo += 1 + lua_gettop(L);
		lua_pushnil(L);				 /* first key L: lotable ..... nil */
		while (0 != lua_next(L, lo)) /* L: lotable ..... key value */
		{
			// key
			KT key;
			luaval_to(L, -2, &key);

			// value
			VT val;
			luaval_to(L, -1, &val);
			lua_pop(L, 1); /* L: lotable ..... key */

			(*m)[key] = val;
		}
	}
	return ok;
}
//
// template <>
// bool luaval_to(lua_State* L, int lo, HPStatesMap* m)
// {
// 	bool ok = true;
// 	if (!lua_istable(L, lo))
// 	{
// 		ok = false;
// 	}
//
// 	if (ok)
// 	{
// 		lua_pushnil(L);                                             /* first key L: lotable ..... nil */
// 		while ( 0 != lua_next(L, lo ) )                             /* L: lotable ..... key value */
// 		{
// 			// key
// 			int key;
// 			luaval_to(L, -2, &key);
//
// 			// value
// 			std::map<std::string, float> val;
// 			luaval_to(L, -1, &val);
// 			lua_pop(L, 2);                                          /* L: lotable ..... key */
//
// 			(*m)[key] = val;
// 		}
// 	}
// 	return ok;
// }

void printLuaStack(lua_State *L){
	PRINTF("========= content of stack from top to bottom: ===========");
	int size = lua_gettop(L);
	for (int i = size; i > 0; i--) {
		PRINTF("%d [%d]\t", i, -1 - (size - i));
		int t = lua_type(L, i);
		switch (t)
		{
		case LUA_TNUMBER:
			PRINTF("%s: \t%.2f\n", lua_typename(L, t), lua_tonumber(L, i));
			break;
		case LUA_TBOOLEAN:
			PRINTF("%s: \t%d\n", lua_typename(L, t), lua_toboolean(L, i));
			break;
		case LUA_TSTRING:
			PRINTF("%s: \t%s\n", lua_typename(L, t), lua_tostring(L, i));
			break;
		default:
			// LUA_TTABLE
			// LUA_TTHREAD
			// LUA_TFUNCTION
			// LUA_TLIGHTUSERDATA
			// LUA_TUSERDATA
			// LUA_TNIL
			PRINTF("%s\n", lua_typename(L, t));
			break;
		}
	}
	PRINTF("Stack Size: %d\n", size);
}

std::string get_last_traceback(lua_State *L)
{
	lua_getglobal(L, "last_traceback");
	if (!lua_isstring(L, -1)) {
		PRINTF("not string, is %s\n", lua_typename(L, -1));
		return std::string("no trackback");
	}
	size_t len;
	const char *sz = lua_tolstring(L, -1, &len);
	std::string trackback;
	trackback.assign(sz, len);
	return trackback;
}

Record::Record()
	: packData(nullptr),
	  packDataLength(0),
	  point1(0),
	  point2(0)
{
}

Runner::Runner(int idx_)
: lua(nullptr),
	idx(idx_),
	num(0),
	running(false),
	searchPaths(NULL)
{
}

Runner::Runner(int idx_, std::vector<std::string> searchPaths_)
: lua(nullptr),
	idx(idx_),
	num(0),
	running(false),
	searchPaths(searchPaths_)
{
}

Runner::~Runner()
{
	if (lua)
	{
		PRINTF("%d Runner %p LUA %p Destroy\n", this->idx, this, this->lua->getLuaState());
		delete lua;
		lua = nullptr;
	}
}

void Runner::start()
{
	this->lua = LuaStack::create();
	std::vector<std::string>::iterator it;
	for (it = this->searchPaths.begin(); it != this->searchPaths.end(); it++)
	{
		this->lua->addSearchPath((*it).c_str());
	}

	// this->lua->addSearchPath("./game_scripts");
	// this->lua->addSearchPath("./game_scripts/application/src");
	// this->lua->addSearchPath("./game_scripts/framework/MyLuaGame");
	// this->lua->addSearchPath("./game_scripts/framework/MyLuaGame/src");
	this->lua->executeScriptFile("anti_main");
	running = true;
}

void Runner::stop()
{
	running = false;
}

void Runner::run(Record* record)
{
	if (!running) {
		PRINTF("%d Runner not running.\n", this->idx);
		return;
	}

	struct timespec time1 = {0, 0};
	struct timespec time2 = {0, 0};
	unsigned int vmm, rss;

	// clock_gettime(CLOCK_THREAD_CPUTIME_ID, &time1);
	{
		switch (record->type)
		{
		case 1: // arena
			this->lua->prepareGlobalFunction("startArena");
			this->lua->pushString(record->packData, record->packDataLength);
			this->lua->executeFunction(1, 1, [record, this](lua_State *L) {
				size_t len;
				const char *sz = lua_tolstring(L, -1, &len);
				std::string result;
				result.assign(sz, len);

				std::swap(record->result, result);
				return 1;
			}, [record, this](lua_State *L) {
				std::string result("error");
				std::swap(record->result, result);
				std::string trackback = get_last_traceback(L);
				std::swap(record->trackback, trackback);
			});
			break;

		case 2: // craft
			this->lua->prepareGlobalFunction("startCraft");
			this->lua->pushString(record->packData, record->packDataLength);
			this->lua->executeFunction(1, 3, [record, this](lua_State *L) {
				size_t len;
				const char *sz = lua_tolstring(L, -3, &len);
				std::string result;
				result.assign(sz, len);
				int point1 = lua_tonumber(L, -2);
				int point2 = lua_tonumber(L, -1);

				std::swap(record->result, result);
				record->point1 = point1;
				record->point2 = point2;
				return 3;
			}, [record, this](lua_State *L) {
				std::string result("error");
				std::swap(record->result, result);
				std::string trackback = get_last_traceback(L);
				std::swap(record->trackback, trackback);
			});
			break;

		case 3: // union_fight
			this->lua->prepareGlobalFunction("startUnionFight");
			this->lua->pushString(record->packData, record->packDataLength);
			this->lua->executeFunction(1, 2, [record, this](lua_State *L) {
				size_t len;
				const char *sz = lua_tolstring(L, -2, &len);
				std::string result;
				result.assign(sz, len);

				HPStatesMap states;
				luaval_to(L, -1, &states);

				std::swap(record->result, result);
				std::swap(record->states, states);
				return 2;
			}, [record, this](lua_State *L) {
				std::string result("error");
				std::swap(record->result, result);
				std::string trackback = get_last_traceback(L);
				std::swap(record->trackback, trackback);
			});
			break;

		case 4: // cross craft
			this->lua->prepareGlobalFunction("startCrossCraft");
			this->lua->pushString(record->packData, record->packDataLength);
			this->lua->executeFunction(1, 3, [record, this](lua_State *L) {
				size_t len;
				const char *sz = lua_tolstring(L, -3, &len);
				std::string result;
				result.assign(sz, len);
				int point1 = lua_tonumber(L, -2);
				int point2 = lua_tonumber(L, -1);

				std::swap(record->result, result);
				record->point1 = point1;
				record->point2 = point2;
				return 3;
			}, [record, this](lua_State *L) {
				std::string result("error");
				std::swap(record->result, result);
				std::string trackback = get_last_traceback(L);
				std::swap(record->trackback, trackback);
			});
			break;

		case 5: // endless
			this->lua->prepareGlobalFunction("startEndlessBattle");
			this->lua->pushString(record->packData, record->packDataLength);
			this->lua->executeFunction(1, 1, [record, this](lua_State *L) {
				size_t len;
				const char *sz = lua_tolstring(L, -1, &len);
				std::string result;
				result.assign(sz, len);

				std::swap(record->result, result);
				return 1;
			}, [record, this](lua_State *L) {
				std::string result("error");
				std::swap(record->result, result);
				std::string trackback = get_last_traceback(L);
				std::swap(record->trackback, trackback);
			});
			break;

		case 101: // onlinefight // cross_online_fight play record
			this->lua->prepareGlobalFunction("startCrossOnlineFightRecord");
			this->lua->pushString(record->packData, record->packDataLength);
			this->lua->executeFunction(1, 1, [record, this](lua_State *L) {
				size_t len;
				const char *sz = lua_tolstring(L, -1, &len);
				std::string result;
				result.assign(sz, len);

				std::swap(record->result, result);
				return 1;
			}, [record, this](lua_State *L) {
				std::string result("error");
				std::swap(record->result, result);
				std::string trackback = get_last_traceback(L);
				std::swap(record->trackback, trackback);
			});
			break;

		case 999: // gate
			this->lua->prepareGlobalFunction("startGateBattle");
			this->lua->pushString(record->packData, record->packDataLength);
			this->lua->executeFunction(1, 1, [record, this](lua_State *L) {
				size_t len;
				const char *sz = lua_tolstring(L, -1, &len);
				std::string result;
				result.assign(sz, len);

				std::swap(record->result, result);
				return 1;
			}, [record, this](lua_State *L) {
				std::string result("error");
				std::swap(record->result, result);
				std::string trackback = get_last_traceback(L);
				std::swap(record->trackback, trackback);
			});
			break;

		default:
			PRINTF("%d Runner unknown type %d.\n", record->type);
			break;
		}
	}
}

RealtimeResponse Runner::realtime_start(RealtimeRequest *request)
{
	RealtimeResponse response;
	if (!running) {
		PRINTF("%d Runner not running.\n", this->idx);
		return response;
	}
	response.id = request->id;
	this->lua->prepareGlobalFunction("startCrossOnlineFightBattle");
	this->lua->pushString(request->id, 12);
	this->lua->pushString(request->data, request->length);
	this->lua->executeFunction(2, 5, [&](lua_State *L) {
		int next = lua_tonumber(L, -5);
		size_t len;
		const char *sz = lua_tolstring(L, -4, &len);
		std::string result;
		result.assign(sz, len);
		bool wonderful = lua_toboolean(L, -3);
		std::string status;
		sz = lua_tolstring(L, -2, &len);
		status.assign(sz, len);
		int randcnt = lua_tonumber(L, -1);

		std::swap(response.result, result);
		std::swap(response.status, status);
		response.wonderful = wonderful;
		response.next = next;
		response.randCnt = randcnt;
		return 5;
	}, [&](lua_State *L) {
		std::string result("error");
		std::swap(response.result, result);
		response.wonderful = false;
		response.next = 0;
		std::string trackback = get_last_traceback(L);
		response.trackback = trackback;
	});

	return response;
}

RealtimeResponse Runner::realtime_input(RealtimeRequest *request)
{
	RealtimeResponse response;
	if (!running) {
		PRINTF("%d Runner not running.\n", this->idx);
		return response;
	}
	response.id = request->id;
	this->lua->prepareGlobalFunction("inputCrossOnlineFightBattle");
	this->lua->pushString(request->id, 12);
	this->lua->pushString(request->data, request->length);
	this->lua->executeFunction(2, 5, [&](lua_State *L) {
		int next = lua_tonumber(L, -5);
		size_t len;
		const char *sz = lua_tolstring(L, -4, &len);
		std::string result;
		result.assign(sz, len);
		bool wonderful = lua_toboolean(L, -3);
		std::string status;
		sz = lua_tolstring(L, -2, &len);
		status.assign(sz, len);
		int randcnt = lua_tonumber(L, -1);

		std::swap(response.result, result);
		std::swap(response.status, status);
		response.wonderful = wonderful;
		response.next = next;
		response.randCnt = randcnt;
		return 5;
	}, [&](lua_State *L) {
		std::string result("error");
		std::swap(response.result, result);
		response.wonderful = false;
		response.next = 0;
		response.randCnt = 0;
		std::string trackback = get_last_traceback(L);
		response.trackback = trackback;
	});

	return response;
}

RealtimeResponse Runner::realtime_close(RealtimeRequest *request)
{
	RealtimeResponse response;
	if (!running) {
		PRINTF("%d Runner not running.\n", this->idx);
		return response;
	}
	response.id = request->id;
	this->lua->prepareGlobalFunction("closeCrossOnlineFightBattle");
	this->lua->pushString(request->id, 12);
	this->lua->executeFunction(1, 0, [&](lua_State *L) {
		response.result = "";
		response.wonderful = false;
		response.next = 0;
		response.randCnt = 0;
		return 0;
	}, [&](lua_State *L) {
		response.result = "";
		response.wonderful = false;
		response.next = 0;
		response.randCnt = 0;
		std::string trackback = get_last_traceback(L);
		response.trackback = trackback;
	});
	return response;
}