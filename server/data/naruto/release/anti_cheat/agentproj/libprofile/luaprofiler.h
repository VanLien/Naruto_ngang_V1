/*
** LuaProfiler
** Copyright Kepler Project 2005-2007 (http://www.keplerproject.org/luaprofiler)
** $Id: luaprofiler.h,v 1.4 2007/08/22 19:23:53 carregal Exp $
*/

/*****************************************************************************
luaprofiler.h:
    Must be included by your main module, in order to profile Lua programs
*****************************************************************************/


/**
 * Export thread safe random to LUA
 *
 * Copyright (c) 2014 YouMi Information Technology Inc.
 *
 * May you do good and not evil.
 * May you find forgiveness for yourself and forgive others.
 * May you share freely, never taking more than you give.
 */

#ifndef _PROFILE_
#define _PROFILE_

#if __cplusplus
extern "C" {
#endif 

#include "lua.h"
#include "lauxlib.h"

#if __cplusplus
}
#endif 

#ifndef LUAPROFILE_API
#if __cplusplus
#define LUAPROFILE_API extern "C"
#else
#define LUAPROFILE_API extern 
#endif 
#endif

LUAPROFILE_API int luaopen_profiler(lua_State *L);

#endif // _PROFILE_
