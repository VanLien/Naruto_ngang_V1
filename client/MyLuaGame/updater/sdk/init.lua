--
-- Copyright (c) 2014 YouMi Information Technology Inc.
-- Copyright (c) 2017 TianJi Information Technology Inc.
--
-- sdk相关
--

-- 当前运行平台
local targetPlatform = cc.Application:getInstance():getTargetPlatform()

local eventMap = {
	[1] = "EVENTS_START_LOADING",
	[2] = "EVENTS_FINISHED_LOADING",
	[11] = "PULL_VERSION",
	[12] = "START_CDN",
	[13] = "CDN_30",
	[14] = "CDN_60",
	[15] = "CDN_FINISH",
	[16] = "NOTNETWORK_CLICK",
	[17] = "PULL_GAMESHOW",
	[18] = "CLICK_OK",
	[19] = "START_LOGIN",
	[20] = "START_GAME",
}

function sdk.trackEvent(ctype, data)
	if type(data) ~= "table" then
		data = {data = data}
	end
	data.ctype = ctype
	data.event = eventMap[ctype] or ""
	sdk.callPlatformFunc("trackEvent", json.encode(data), function(info)
		print("trackEvent ret = ", info)
	end)
end

function sdk.callPlatformFunc(funcName, bundle, callback)
	if ((cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform)) then
		local luaoc = require "cocos.cocos2d.luaoc"
		luaoc.callStaticMethod("SDKDelegate", "proxy",{
			funcName = funcName,
			bundle = bundle,
			callback = callback
		})
	else
		if device.platform == "windows" then
			if callback then
				callback("ok")
			end
			return
		end
		local luaj = require "cocos.cocos2d.luaj"
		luaj.callStaticMethod("www/tianji/finalsdk/MessageHandler","msgFromLua",{
			[1] = funcName,
			[2] = bundle,
			[3] = callback
		})
	end
end

-- @desc 是否是刘海屏 1是 0否
function sdk.isHasNotchScreen(cb)
	if display.isNotchSceen ~= nil then
		cb(display.isNotchSceen)
		return
	end
	sdk.callPlatformFunc("isHasNotchScreen", "data", function(info)
		printInfo("sdk.isHasNotchScreen back info = %s | %s", type(info), info)
		display.isNotchSceen = tonumber(info)
		cb(tonumber(info))
	end)
end

local function init()
	if device.platform ~= "windows" then
		sdk.isHasNotchScreen(function(info)
			if info == 1 then
				display.notchSceenSafeArea = display.fullScreenSafeArea
				display.notchSceenDiffX = display.fullScreenDiffX
				printInfo("# display.notchSceenSafeArea changed   = %d", display.notchSceenSafeArea)
				printInfo("# display.notchSceenDiffX changed      = %d", display.notchSceenDiffX)
			end
		end)
	end
end

init()
