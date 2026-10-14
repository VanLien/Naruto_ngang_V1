#include <iostream>
#include <vector>
#include <map>
#include <thread>
#include <cstdlib>
#include <csignal>
#include <sstream>
#ifdef WIN32
#include <windows.h>
#else
#include <unistd.h>
#endif

#include "msgpack.hpp"
#include "runner.h"

using namespace std;

string args_name(string name)
{
	if (name == "-i")
		return "id";
	else if (name == "-p")
		return "path";
	else if (name == "-m")
		return "model";
	return "";
}

map<string, string> parse_args(int argc, char *argv[])
{
	map<string, string> ret{
		{"id", "1"},
		{"model", "normal"},
	};
	string param;
	for (int i = 1; i < argc; i++)
	{
		if (param.empty())
		{
			if (argv[i][0] == '-')
				param = argv[i];
			else
				ret["record"] = argv[i];
		}
		else
		{
			ret[args_name(param)] = argv[i];
			param.clear();
		}
	}
	return ret;
}

Runner *g_runner;

void signal_handler(int signum)
{
	printf("Interrupt signal (%d) received.\n", signum);
	g_runner->stop();
	exit(0);
}

void realtime_model(std::FILE *in)
{
	fflush(stdout);
	fflush(stderr);

	while (!feof(in))
	{
		size_t code;
		int length;
		char name[25];
		char id[12];
		length = 0;
		memset(&id, 0, sizeof(id));
		memset(&name, 0, sizeof(name));
		fscanf(stdin, "%s", &name); fgetc(stdin); // swallow
		code = fread(id, 12, 1, stdin); fgetc(stdin); // swallow
		// printf("code %d\n", code);
		fscanf(stdin, "%d", &length); fgetc(stdin); // swallow
		if (feof(stdin))
			break;

		char *buffer = (char *)malloc(length);
		memset(buffer, 0, length);
		code = fread(buffer, length, 1, stdin);
		// printf("code %d\n", code);
		fgetc(stdin); // swallow \n

		RealtimeRequest request;
		request.id = id;
		request.length = length;
		request.data = buffer;

		RealtimeResponse response;

		if (std::string(name) == "start")
		{
			response = g_runner->realtime_start(&request);
		}
		else if (std::string(name) == "input")
		{
			response = g_runner->realtime_input(&request);
		}
		else if (std::string(name) == "close")
		{
			response = g_runner->realtime_close(&request);
		}
		else
		{
			printf("unknwon");
		}

		std::stringstream stream;
		msgpack::packer<std::stringstream> pack(stream);
		pack.pack_array(7);
		pack.pack_raw(12);
		pack.pack_raw_body(response.id, 12);
		pack.pack_int(response.next);
		pack << response.result;
		pack << response.wonderful;
		pack << response.status;
		pack << response.randCnt;
		pack << response.trackback;
		std::string sbuf = stream.str();
		// printf("response %d\n", sbuf.size());

		const char *buf = sbuf.c_str();
		fwrite(buf, sbuf.size(), 1, stderr);
		fflush(stdout);
		fflush(stderr);

		free(buffer);
	}
}

int main(int argc, char *argv[])
{
	printf("%d hardware concurrent threads are supported.\n", std::thread::hardware_concurrency());

	auto args = parse_args(argc, argv);

	std::vector<std::string> searchPaths;
	std::string path = "game_scripts";
	if (args.find("path") != args.end())
	{
		path = args["path"];
	}
	searchPaths.push_back(path);
	searchPaths.push_back(path + "/application");
	searchPaths.push_back(path + "/application/src");
	searchPaths.push_back(path + "/framework/MyLuaGame");
	searchPaths.push_back(path + "/framework/MyLuaGame/src");

	g_runner = new Runner(std::atoi(args["id"].c_str()), searchPaths);
	g_runner->start();

	signal(SIGINT, signal_handler);
	signal(SIGTERM, signal_handler);

	if (args.find("record") != args.end())
	{
		const char *filename = args["record"].c_str();
		std::string data;
		FILE *fp = fopen(filename, "rb");
		fseek(fp, 0, SEEK_END);
		int size = ftell(fp);
		data.resize(size);
		fseek(fp, 0, SEEK_SET);
		fread(&data[0], size, 1, fp);
		fclose(fp);

		msgpack::unpacked msg;
		msgpack::unpack(&msg, data.data(), data.size());
		msgpack::object obj = msg.get();
		std::vector<msgpack::object> protocol = obj.as<std::vector<msgpack::object>>();
		std::string name = protocol[0].as<std::string>();
		data = protocol[1].as<std::string>();
		int type;
		if (name == "arena")
		{
			type = 1;
		}
		else if (name == "craft")
		{
			type = 2;
		}
		else if (name == "union_fight")
		{
			type = 3;
		}
		else if (name == "cross_craft" || name == "crosscraft")
		{
			type = 4;
		}
		else if (name == "endless")
		{
			type = 5;
		}
		else if (name == "onlinefight") // cross_online_fight play record
		{
			type = 101;
		}
		else if (name == "gate")
		{
			type = 999;
		}
		Record *record = new Record;
		record->identify = std::string(filename);
		record->type = type;
		record->packData = (char *)data.c_str();
		record->packDataLength = data.size();

		g_runner->run(record);
		printf("!!! record %s result %s %d %d\n", record->identify.c_str(), record->result.c_str(), record->point1, record->point2);
		printf("!!! %s\n", record->trackback.c_str());
		g_runner->stop();

		delete record;
		return 0;
	}

	if (args["model"] != "normal")
	{
		printf("in realtime model\n");
		realtime_model(stdin);
		return 0;
	}

	while (!feof(stdin))
	{
		int type, length;
		char id[25];
		type = 0;
		length = 0;
		memset(&id, 0, sizeof(id));
		fscanf(stdin, "%s %d %d ", &id, &type, &length);
		if (feof(stdin))
			break;
		std::string identify = std::string(id);
		// printf("play %s type %d length %d\n", identify.c_str(), type, length);

		char *buffer = (char *)malloc(length);
		memset(buffer, 0, length);
		size_t code = fread(buffer, length, 1, stdin);
		// printf("code %d\n", code);
		fgetc(stdin); // swallow \n

		Record *record = new Record;
		record->identify = identify;
		record->type = type;
		record->packData = buffer;
		record->packDataLength = length;
		g_runner->run(record);
		free(buffer);
		// printf("!!! record %s result %s %d %d\n", record->identify.c_str(), record->result.c_str(), record->point1, record->point2);
		// printf("!!! %s\n", record->trackback.c_str());

		std::stringstream stream;
		msgpack::packer<std::stringstream> pack(stream);
		pack.pack_array(5);
		pack << record->result;
		pack.pack_int(record->point1);
		pack.pack_int(record->point2);
		pack << record->states;
		pack << record->trackback;
		std::string sbuf = stream.str();
		const char *buf = sbuf.c_str();
		fwrite(buf, sbuf.size(), 1, stderr);
		fflush(stdout);
		fflush(stderr);
		delete record;
	}

	g_runner->stop();
	return 0;
}