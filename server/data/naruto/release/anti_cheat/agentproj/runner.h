/**
 *
 * Copyright (c) 2014 YouMi Information Technology Inc.
 *
 * May you do good and not evil.
 * May you find forgiveness for yourself and forgive others.
 * May you share freely, never taking more than you give.
 */
#ifndef _RUNNER_
#define _RUNNER_

#include <map>
#include <list>
#include <tuple>
#include <string>
#include <vector>
#include <thread>

class LuaStack;

typedef std::map<std::string, std::vector<float>> HPStatesMap;

class Record
{
public:
	std::string identify;
	int type; // 1 pvp, 2 craft
	char *packData;
	int packDataLength;
	std::string result;
	int point1;
	int point2;
	HPStatesMap states;
	std::string trackback; // error trackback

	Record();
};

class RealtimeRequest
{
public:
	const char *id;
	const char *data;
	int length;
};

class RealtimeResponse
{
public:
	const char *id;
	int next;
	std::string result;
	bool wonderful;
	std::string status;
	int randCnt;
	std::string trackback; // error trackback
};

class Runner
{
public:
	void run(Record* record);
	void start();
	void stop();
	bool isRunning() {return running;};
	RealtimeResponse realtime_start(RealtimeRequest *request);
	RealtimeResponse realtime_input(RealtimeRequest *request);
	RealtimeResponse realtime_close(RealtimeRequest *request);

	Runner(int idx_);
	Runner(int idx_, std::vector<std::string> searchPaths);
	virtual ~Runner();

protected:
	int idx;
	int num;
	bool running;
	LuaStack *lua;
	std::vector<std::string> searchPaths;
};

#endif // _RUNNER_