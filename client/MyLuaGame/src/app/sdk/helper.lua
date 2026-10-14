-- chunkname: @src.app.sdk.helper

local targetPlatform = cc.Application:getInstance():getTargetPlatform()
local specialTagMap = {
	mega_ehue_ios = {
		"MegaElf",
		"proxy"
	},
	com_cutegame_tumsprite_ios_yidun_v4 = {
		"CutegameTumsprite",
		"proxy"
	},
	cn_celve_zhandai_ios_yidun_v4 = {
		"CelveZhandai",
		"proxy"
	},
	com_aifang_academy_kssdk_ios_yidun_v4 = {
		"AifangAcademy",
		"proxy"
	},
	com_jour_champ_kssdk_ios_yidun_v4 = {
		"JourChamp",
		"proxy"
	},
	chukai_wuling_cn_ios_yidun_v4 = {
		"ChukaiWuling",
		"proxy"
	},
	com_zqawe_certjm_ios_yidun_v4 = {
		"ZqaweDelegate",
		"ZqaweProxy"
	},
	com_yangdong_kdjx_ios_yidun_v4 = {
		"YangdongDelegate",
		"Yangdong"
	},
	com_wuxianshalu_kssdk_ios_yidun_v4 = {
		"wuxianshalu",
		"WXSLSDKImpl"
	}
}

function sdk.callPlatformFunc(funcName, bundle, callback)
	if cc.PLATFORM_OS_IPHONE == targetPlatform or cc.PLATFORM_OS_IPAD == targetPlatform then
		local luaoc = require("cocos.cocos2d.luaoc")
		local clsName = "SDKDelegate"
		local fname = "proxy"

		if specialTagMap[APP_TAG] ~= nil then
			clsName, fname = unpack(specialTagMap[APP_TAG])
		end

		luaoc.callStaticMethod(clsName, fname, {
			funcName = funcName,
			bundle = bundle,
			callback = callback
		})
	elseif cc.PLATFORM_OS_OHOS == targetPlatform then
		local luaArkTs = require("cocos.cocos2d.luaArkTs")
		local clsName = "SDKTools"
		local ok, ret = luaArkTs.callStaticMethod(clsName, funcName, {
			funcName = funcName,
			bundle = bundle,
			callback = callback
		})
	else
		local luaj = require("cocos.cocos2d.luaj")

		luaj.callStaticMethod("org/cocos2dx/lua/MessageHandler", "msgFromLua", {
			funcName,
			bundle,
			callback
		})
	end
end

function sdk.callbackFromSDK(cb)
	performWithDelay(gGameUI.scene, cb, 0)
end

function sdk.getBattery(cb)
	if cc.PLATFORM_OS_WINDOWS == targetPlatform or cc.PLATFORM_OS_IPHONE == targetPlatform or cc.PLATFORM_OS_IPAD == targetPlatform then
		return cb()
	end

	sdk.callPlatformFunc("getBattery", "data", function(info)
		printInfo("sdk.getBattery back info = %s", info)
		cb(info)
	end)
end

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

function sdk.isHiddenLoginButton()
	sdk.callPlatformFunc("isHiddenLoginButton", "", function(info)
		if info == "true" then
			-- block empty
		end
	end)
end

function sdk.notification(data, cb)
	local jsonStr = json.encode(data)

	sdk.callPlatformFunc("notification", jsonStr, function(info)
		printInfo("sdk.notification back info = %s", info)

		if cb then
			cb(tonumber(info))
		end
	end)
end

function sdk.windowSizeChange()
	printInfo("sdk.windowSizeChange-----")
	sdk.callPlatformFunc("windowSizeChange", "", function(data)
		printInfo("windowSizeChange info = %s", data)

		local info = json.decode(data)

		gGameUI:resizeScreenHOS(info.width, info.height)
	end)
end
