/****************************************************************************
 Copyright (c) 2011-2012 cocos2d-x.org
 Copyright (c) 2013-2014 Chukong Technologies Inc.
 
 http://www.cocos2d-x.org
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#include "CCLuaStack.h"


extern "C" {
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

#include "tolua++.h"
}

#include "Cocos2dxLuaLoader.h"
#include "lua_rand.h"
#include "libprofile/luaprofiler.h"
#include <time.h>
#include <string.h>
#include <map>

#define CCLOG printf

std::map <lua_State*, LuaStack*> mapLuaStack;

namespace {
int lua_err_happend(lua_State * luastate)
{
	CCLOG("error happend!!\n");
	LuaStack* stack = LuaStack::getInstance(luastate);
	return 0;
}

int lua_print(lua_State * luastate)
{
    int nargs = lua_gettop(luastate);

    std::string t;
    for (int i=1; i <= nargs; i++)
    {
        if (lua_istable(luastate, i))
            t += "table";
        else if (lua_isnone(luastate, i))
            t += "none";
        else if (lua_isnil(luastate, i))
            t += "nil";
        else if (lua_isboolean(luastate, i))
        {
            if (lua_toboolean(luastate, i) != 0)
                t += "true";
            else
                t += "false";
        }
		else if (lua_istable(luastate, i))
		{
			char buf[111];
			sprintf(buf, "table %p", lua_topointer(luastate, i));
			t += buf;
		}
        else if (lua_isfunction(luastate, i))
		{
			char buf[111];
			sprintf(buf, "function %p", lua_topointer(luastate, i));
			t += buf;
		}
        else if (lua_islightuserdata(luastate, i))
		{
			char buf[111];
			sprintf(buf, "lightuserdata %p", lua_topointer(luastate, i));
			t += buf;
		}
        else if (lua_isthread(luastate, i))
            t += "thread";
        else
        {
            const char * str = lua_tostring(luastate, i);
            if (str)
                t += lua_tostring(luastate, i);
            else
                t += lua_typename(luastate, lua_type(luastate, i));
        }
        if (i!=nargs)
            t += "\t";
    }

	long t_;
	time(&t_);
	struct tm tm_ = *localtime(&t_);
	//CCLOG("%02d:%02d:%02d [LUA %p] %s\n", tm_.tm_hour, tm_.tm_min, tm_.tm_sec, luastate, t.c_str());
	CCLOG("[LUA] %s\n", t.c_str());

    return 0;
}
}  // namespace {



#if __cplusplus
extern "C" {
#endif

static luaL_Reg luax_exts[] = {
	{"ymrand", luaopen_random},
	{"profiler", luaopen_profiler},
	{NULL, NULL}
};

void luaopen_lua_extensions(lua_State *L)
{
	// load extensions
	luaL_Reg* lib = luax_exts;
	lua_getglobal(L, "package");
	lua_getfield(L, -1, "preload");
	for (; lib->func; lib++)
	{
		lua_pushcfunction(L, lib->func);
		lua_setfield(L, -2, lib->name);
	}
	lua_pop(L, 2);
}

void luaclose_lua_extensions(lua_State *L)
{
	luaclose_random(L);
}

#if __cplusplus
}
#endif

LuaStack::~LuaStack()
{
    if (nullptr != _state)
    {
        lua_close(_state);
    }
}

LuaStack *LuaStack::create(void)
{
    LuaStack *stack = new LuaStack();
    stack->init();
    //stack->autorelease();
    return stack;
}

LuaStack *LuaStack::attach(lua_State *L)
{
    LuaStack *stack = new LuaStack();
    stack->initWithLuaState(L);
    //stack->autorelease();
    return stack;
}

bool LuaStack::init(void)
{
    _state = lua_open();
    luaL_openlibs(_state);

    // Register our version of the global "print" function
    const luaL_reg global_functions [] = {
        {"print", lua_print},
		{"err_happend", lua_err_happend},
        {NULL, NULL}
    };
    luaL_register(_state, "_G", global_functions);

	luaopen_lua_extensions(_state);

    // add cocos2dx loader
    addLuaLoader(cocos2dx_lua_loader);

	mapLuaStack[_state] = this;

    return true;
}

bool LuaStack::initWithLuaState(lua_State *L)
{
    _state = L;
    return true;
}

void LuaStack::addSearchPath(const char* path)
{
    lua_getglobal(_state, "package");                                  /* L: package */
    lua_getfield(_state, -1, "path");                /* get package.path, L: package path */
    const char* cur_path =  lua_tostring(_state, -1);
    lua_pushfstring(_state, "%s;%s/?.lua", cur_path, path);            /* L: package path newpath */
    lua_setfield(_state, -3, "path");          /* package.path = newpath, L: package path */
    lua_pop(_state, 2);                                                /* L: - */
}

void LuaStack::addLuaLoader(lua_CFunction func)
{
    if (!func) return;
    
    // stack content after the invoking of the function
    // get loader table
    lua_getglobal(_state, "package");                                  /* L: package */
    lua_getfield(_state, -1, "loaders");                               /* L: package, loaders */
    
    // insert loader into index 2
    lua_pushcfunction(_state, func);                                   /* L: package, loaders, func */
    for (int i = (int)(lua_objlen(_state, -2) + 1); i > 2; --i)
    {
        lua_rawgeti(_state, -2, i - 1);                                /* L: package, loaders, func, function */
        // we call lua_rawgeti, so the loader table now is at -3
        lua_rawseti(_state, -3, i);                                    /* L: package, loaders, func */
    }
    lua_rawseti(_state, -2, 2);                                        /* L: package, loaders */
    
    // set loaders into package
    lua_setfield(_state, -2, "loaders");                               /* L: package */
    
    lua_pop(_state, 1);
}



int LuaStack::executeString(const char *codes)
{
    luaL_loadstring(_state, codes);
    return executeFunction(0, 1);
}

int LuaStack::executeScriptFile(const char* filename)
{
    std::string code("require \"");
    code.append(filename);
    code.append("\"");
    return executeString(code.c_str());
}

int LuaStack::executeGlobalFunction(const char* functionName)
{
    lua_getglobal(_state, functionName);       /* query function by name, stack: function */
    if (!lua_isfunction(_state, -1))
    {
        CCLOG("[LUA ERROR] name '%s' does not represent a Lua function", functionName);
        lua_pop(_state, 1);
        return 0;
    }
    return executeFunction(0, 1);
}


int LuaStack::prepareGlobalFunction(const char* functionName)
{
	lua_getglobal(_state, functionName);       /* query function by name, stack: function */
	if (!lua_isfunction(_state, -1))
	{
		CCLOG("[LUA ERROR] name '%s' does not represent a Lua function", functionName);
		lua_pop(_state, 1);
		return 0;
	}
	return 1;
}


void LuaStack::clean(void)
{
    lua_settop(_state, 0);
}

void LuaStack::pushInt(int intValue)
{
    lua_pushinteger(_state, intValue);
}

void LuaStack::pushFloat(float floatValue)
{
    lua_pushnumber(_state, floatValue);
}

void LuaStack::pushLong(long longValue)
{
    lua_pushnumber(_state, longValue);
}

void LuaStack::pushBoolean(bool boolValue)
{
    lua_pushboolean(_state, boolValue);
}

void LuaStack::pushString(const char* stringValue)
{
    lua_pushstring(_state, stringValue);
}

void LuaStack::pushString(const char* stringValue, int length)
{
    lua_pushlstring(_state, stringValue, length);
}

void LuaStack::pushNil(void)
{
    lua_pushnil(_state);
}

int LuaStack::executeFunction(int numArgs, int numResults, GetRetFunc func /*= NULL*/, ErrRetFunc errFunc /*= nullptr*/)
{
    int functionIndex = -(numArgs + 1);
    if (!lua_isfunction(_state, functionIndex))
    {
        CCLOG("value at stack [%d] is not function\n", functionIndex);
        lua_pop(_state, numArgs + 1); // remove function and arguments
        return 0;
    }

    int traceback = 0;
    lua_getglobal(_state, "__G__TRACKBACK__");                         /* L: ... func arg1 arg2 ... G */
    if (!lua_isfunction(_state, -1))
    {
        lua_pop(_state, 1);                                            /* L: ... func arg1 arg2 ... */
    }
    else
    {
        lua_insert(_state, functionIndex - 1);                         /* L: ... G func arg1 arg2 ... */
        traceback = functionIndex - 1;
    }
    
    int error = 0;
    ++_callFromLua;
    error = lua_pcall(_state, numArgs, numResults, traceback);                  /* L: ... [G] ret */
    --_callFromLua;
    if (error)
    {
        if (traceback == 0)
        {
            CCLOG("[LUA ERROR] %s\n", lua_tostring(_state, - 1));        /* L: ... error */
            lua_pop(_state, 1); // remove error message from stack
        }
        else                                                            /* L: ... G error */
        {
            if (errFunc)
				errFunc(_state);
			lua_pop(_state, 2); // remove __G__TRACKBACK__ and error message from stack
        }
        return 0;
    }
    
    // get return value
    int ret = 0;
    if (lua_isnumber(_state, -1))
    {
        ret = (int)lua_tointeger(_state, -1);
    }
    else if (lua_isboolean(_state, -1))
    {
        ret = (int)lua_toboolean(_state, -1);
    }

	if (func)
	{
		ret = func(_state);
	}
	// remove return value from stack
	lua_pop(_state, numResults);                                                /* L: ... [G] */
    
    if (traceback)
    {
        lua_pop(_state, 1); // remove __G__TRACKBACK__ from stack      /* L: ... */
    }
    
    return ret;
}



bool LuaStack::handleAssert(const char *msg)
{
    if (_callFromLua == 0) return false;
    
    lua_pushfstring(_state, "ASSERT FAILED ON LUA EXECUTE: %s", msg ? msg : "unknown");
    lua_error(_state);
    return true;
}

int LuaStack::reload(const char* moduleFileName)
{
    if (nullptr == moduleFileName || strlen(moduleFileName) == 0)
    {
        CCLOG("moudulFileName is null");
        return 1;
    }

    lua_getglobal(_state, "package");                         /* L: package */
    lua_getfield(_state, -1, "loaded");                       /* L: package loaded */
    lua_pushstring(_state, moduleFileName);
    lua_gettable(_state, -2);                                 /* L:package loaded module */
    if (!lua_isnil(_state, -1))
    {
        lua_pushstring(_state, moduleFileName);               /* L:package loaded module name */
        lua_pushnil(_state);                                  /* L:package loaded module name nil*/
        lua_settable(_state, -4);                             /* L:package loaded module */
    }
    lua_pop(_state, 3);
    
    std::string name = moduleFileName;
    std::string require = "require \'" + name + "\'";
    return executeString(require.c_str());
}


int LuaStack::lua_loadbuffer(const char *chunk, int chunkSize, const char *chunkName)
{
	int r = 0;
	r = luaL_loadbuffer(_state, chunk, chunkSize, chunkName);

#if defined(COCOS2D_DEBUG) && COCOS2D_DEBUG > 0
	if (r)
	{
		switch (r)
		{
		case LUA_ERRSYNTAX:
			CCLOG("[LUA ERROR] load \"%s\", error: syntax error during pre-compilation.", chunkName);
			break;

		case LUA_ERRMEM:
			CCLOG("[LUA ERROR] load \"%s\", error: memory allocation error.", chunkName);
			break;

		case LUA_ERRFILE:
			CCLOG("[LUA ERROR] load \"%s\", error: cannot open/read file.", chunkName);
			break;

		default:
			CCLOG("[LUA ERROR] load \"%s\", error: unknown.", chunkName);
		}
	}
#endif
	return r;
}

LuaStack * LuaStack::getInstance(lua_State *L)
{
	auto it = mapLuaStack.find(L);
	if (it == mapLuaStack.end())
		return nullptr;
	return it->second;
}


