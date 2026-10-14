AUTOMAKE_OPTIONS=foreign subdir-objects
AM_CPPFLAGS=-I libmsgpack -I luajit/include -I tolua
bin_PROGRAMS=agent
agent_SOURCES=agent.cpp CCFileUtils.cpp CCLuaStack.cpp Cocos2dxLuaLoader.cpp libmsgpack/gcc_atomic.cpp libmsgpack/object.cpp libmsgpack/objectc.c libmsgpack/unpack.c libmsgpack/version.c libmsgpack/vrefbuffer.c libmsgpack/zone.c libprofile/clocks.c libprofile/core_profiler.c libprofile/function_meter.c libprofile/lua50_profiler.c libprofile/stack.c linux/CCFileUtilsLinux.cpp linux/CCStdC.cpp lua_rand.cpp Rand.cpp runner.cpp tolua/tolua_event.c tolua/tolua_is.c tolua/tolua_map.c tolua/tolua_push.c tolua/tolua_to.c
agent_CXXFLAGS=-std=c++11
agent_LDADD=-Lluajit -lluajit