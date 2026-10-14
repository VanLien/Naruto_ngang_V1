-- chunkname: @src.app.sdk.init

require("app.sdk.helper")

sdk.ORDER_URL = "http://123.207.108.22:28081"
sdk.ORDER_SIGN_SECRET = "tianji"

local AgeCached, UserTypeCached, yidun

function sdk.login(cb)
	if not sdk.spec then
		return cb()
	end

	AgeCached, UserTypeCached = nil

	return sdk.spec.login(function(code, info)
		cb(code, info)

		if code == 0 then
			sdk.getUserTypeAndIdentity()
		end
	end)
end

function sdk.onLogin(accountName)
	do return end

	local flag = userDefault.getForeverLocalKey(accountName .. "_guestDisable", "no", {
		rawKey = true
	})

	if flag == os.date("%Y%m%d") then
		printWarn("you was guest, plz register and identify yourself")
		gGameUI:showTip("you was guest, plz register and identify yourself")
		performWithDelay(gGameUI.scene, function()
			gGameApp:onBackLogin()
		end, 1)
	end
end

function sdk.commitRoleInfo(ctype, cb)
	if not sdk.spec then
		return cb()
	end

	return sdk.spec.commitRoleInfo(ctype, cb)
end

function sdk.trackEvent(ctype, data)
	if device.platform == "windows" then
		return
	end

	if not sdk.spec or not sdk.spec.trackEvent then
		return
	end

	return sdk.spec.trackEvent(ctype, data)
end

local function getCpOrderId()
	local roleId = stringz.bintohex(gGameModel.role:read("id"))

	return string.format("%s%s", roleId, os.time())
end

local function getUserRechargeLimit(typ, age)
	if typ == 0 or age <= 8 then
		return 0
	end

	if age < 16 then
		return 50
	end

	if age < 18 then
		return 100
	end

	return 1e+99
end

function sdk.pay(params, cb)
	cb = cb or function()
		return
	end

	if not sdk.spec then
		return cb()
	end

	local rechargeId = params.rechargeId
	local yyID = params.yyID or 0
	local csvID = params.csvID or 0
	local accountId = stringz.bintohex(gGameModel.role:read("account_id"))
	local roleId = stringz.bintohex(gGameModel.role:read("id"))
	local payInfo = csv.recharges[rechargeId]
	local extInfo = json.encode({
		accountId,
		roleId,
		gGameApp.serverInfo.key,
		rechargeId,
		yyID,
		csvID
	})

	display.director:setDirtyDrawEnable(false)

	local productName = params.name or payInfo.name

	if string.len(productName) == 0 then
		productName = "礼包"
	end

	return sdk.spec.pay(getCpOrderId(), extInfo, tonumber(payInfo.rmb), rechargeId, productName, cb, params)
end

function sdk.logout(cb)
	if not sdk.spec then
		return cb()
	end

	return sdk.spec.logout(cb)
end

function sdk.switch(cb)
	if not sdk.spec then
		return cb()
	end

	return sdk.spec.switch(cb)
end

function sdk.getSdkConfig(cb)
	if not sdk.spec or not sdk.spec.getSdkConfig then
		return cb(-1, "")
	end

	return sdk.spec.getSdkConfig(cb)
end

function sdk.exit(cb)
	if not sdk.spec then
		return cb()
	end

	display.director:endToLua()
end

function sdk.getChannel(cb)
	if not sdk.spec or not sdk.spec.getChannel then
		return APP_CHANNEL
	end

	return sdk.spec.getChannel(cb)
end

sdk.LP_SDK_CHANNEL = {
	onestore = "4",
	leidian = "0",
	qd_5 = "5",
	lunplay = "2"
}
sdk.TC_SDK_CHANNEL = {
	rongyao = "315"
}
sdk.sdkChannel = "-1"

function sdk.getSDKChannel(cb)
	if not sdk.spec or not sdk.spec.getSDKChannel then
		return cb(sdk.sdkChannel)
	end

	return sdk.spec.getSDKChannel(cb)
end

function sdk.isShowUnBinding(cb)
	if not sdk.spec or not sdk.spec.isShowUnBinding then
		return cb("error")
	end

	return sdk.spec.isShowUnBinding(cb)
end

function sdk.unBinding(cb)
	if not sdk.spec or not sdk.spec.unBinding then
		return cb("error")
	end

	return sdk.spec.unBinding(cb)
end

local MaxAge = 999

function sdk.queryIdentity(cb)
	if AgeCached then
		return cb(AgeCached)
	end

	if not sdk.spec or not sdk.spec.queryIdentity then
		return cb(MaxAge)
	end

	return sdk.spec.queryIdentity(function(age)
		if age and age > 0 then
			AgeCached = age
		end

		return cb(AgeCached)
	end)
end

function sdk.queryUserType(cb)
	if UserTypeCached then
		return cb(UserTypeCached)
	end

	if not sdk.spec or not sdk.spec.queryUserType then
		UserTypeCached = 1

		return cb(UserTypeCached)
	end

	return sdk.spec.queryUserType(function(typ)
		do return cb(UserTypeCached) end

		UserTypeCached = typ or 1

		if UserTypeCached == 0 then
			performWithDelay(gGameUI.scene, function()
				sdk.spec.queryUserType(function(typ)
					UserTypeCached = typ or 1

					if UserTypeCached == 0 then
						local accountName = gGameModel.account:read("name")

						userDefault.setForeverLocalKey(accountName .. "_guestDisable", os.date("%Y%m%d"), {
							rawKey = true
						})
						printWarn("you was guest, plz register and identify yourself")
						gGameUI:showTip("you was guest, plz register and identify yourself")
						performWithDelay(gGameUI.scene, function()
							gGameApp:onBackLogin()
						end, 5)
					end
				end)
			end, 3000)
		end

		return cb(UserTypeCached)
	end)
end

function sdk.getUserTypeAndIdentity()
	if UserTypeCached == nil then
		sdk.queryUserType(function()
			return
		end)
	end

	if AgeCached == nil then
		sdk.queryIdentity(function()
			return
		end)
	end

	return UserTypeCached, AgeCached
end

function sdk.openCustomerService(vip)
	if not sdk.spec or not sdk.spec.openCustomerService then
		return
	end

	return sdk.spec.openCustomerService(vip)
end

function sdk.accountCenter(cb)
	if not sdk.spec or not sdk.spec.accountCenter then
		return
	end

	return sdk.spec.accountCenter(cb)
end

function sdk.openPrivacyProtocols()
	if not sdk.spec or not sdk.spec.openPrivacyProtocols then
		return
	end

	return sdk.spec.openPrivacyProtocols()
end

function sdk.openPermissionSetting()
	if not sdk.spec or not sdk.spec.openPermissionSetting then
		return
	end

	return sdk.spec.openPermissionSetting()
end

function sdk.isSupportSubscribe(cb)
	if not sdk.spec or not sdk.spec.isSupportSubscribe then
		return
	end

	return sdk.spec.isSupportSubscribe(cb)
end

function sdk.isBuySubscribe(cb)
	if not sdk.supportSubscribe or not sdk.spec or not sdk.spec.isBuySubscribe or sdk.buySubscribeInfoCb == false then
		return
	end

	sdk.buySubscribeInfoCb = false

	display.director:setDirtyDrawEnable(false)

	return sdk.spec.isBuySubscribe(function(info)
		sdk.buySubscribeInfoCb = true
		sdk.buySubscribeInfo = info

		if cb then
			cb(info)
		end
	end)
end

function sdk.launchUnityGame(cb)
	if not sdk.spec then
		return cb()
	end

	return sdk.spec.launchUnityGame(cb)
end

function sdk.getLocaleInfo(cb)
	print("sdk.getLocaleInfo")
	sdk.callPlatformFunc("getLocaleInfo", "", function(info)
		if info ~= "error" then
			cb(info)
		end
	end)
end

function sdk.getpackageName(cb)
	print("sdk.getpackageName")
	sdk.callPlatformFunc("getpackageName", "", function(info)
		cb(info)
	end)
end

function sdk.getPrivacyPolicy(cb)
	print("sdk.getPrivacyPolicy")
	sdk.callPlatformFunc("getPrivacyPolicy", "", function(info)
		cb(info)
	end)
end

function sdk.initYD()
	sdk.callPlatformFunc("initYD", "", function(info)
		if info == "true" then
			yidun = require("app.sdk.yidun")
		end
	end)
end

function sdk.getYiDun()
	return yidun
end

function sdk.setRoleInfoYD(cb)
	if not yidun or not yidun.setRoleInfo then
		return cb()
	end

	return yidun.setRoleInfo(cb)
end

function sdk.getYDToken(cb)
	if not yidun or not yidun.getToken then
		return cb("")
	end

	return yidun.getToken(cb)
end

function sdk.getTokenAsyncYD(cb)
	if not yidun or not yidun.getTokenAsync then
		return cb()
	end

	return yidun.getTokenAsync(cb)
end

function sdk.ioctlYD(request, data, cb)
	if not yidun or not yidun.ioctl then
		return cb()
	end

	return yidun.ioctl(request, data, cb)
end

function sdk.safeCommToServerYD(data, cb)
	if not yidun or not yidun.safeCommToServer then
		return cb()
	end

	return yidun.safeCommToServer(data, cb)
end

function sdk.safeCommToServerByteYD(data, cb)
	if not yidun or not yidun.safeCommToServerByteYD then
		return cb()
	end

	return yidun.safeCommToServerByteYD(data, cb)
end

function sdk.safeCommFromServerYD(data, cb)
	if not yidun or not yidun.safeCommFromServer then
		return cb()
	end

	return yidun.safeCommFromServer(data, cb)
end

function sdk.safeCommFromServerByteYD(data, cb)
	if not yidun or not yidun.safeCommFromServerByte then
		return cb()
	end

	return yidun.safeCommFromServerByte(data, cb)
end

function sdk.localSaveEncodeYD(data, cb)
	if not yidun or not yidun.localSaveEncode then
		return cb()
	end

	return yidun.localSaveEncode(data, cb)
end

function sdk.localSaveDecodeYD(data, cb)
	if not yidun or not yidun.localSaveEncode then
		return cb()
	end

	return yidun.localSaveEncode(data, cb)
end

function sdk.localSaveBytesEncodeYD(data, cb)
	if not yidun or not yidun.localSaveBytesEncode then
		return cb()
	end

	return yidun.localSaveBytesEncode(data, cb)
end

function sdk.localSaveBytesDecodeYD(data, cb)
	if not yidun or not yidun.localSaveBytesDecode then
		return cb()
	end

	return yidun.localSaveBytesDecode(data, cb)
end

local function init()
	if device.platform ~= "windows" and device.platform ~= "mac" then
		sdk.isHasNotchScreen(function(info)
			if info == 1 then
				local flag = cc.UserDefault:getInstance():getBoolForKey("isNotchScreen", false)

				if flag then
					display.notchSceenSafeArea = display.fullScreenSafeArea
					display.notchSceenDiffX = display.fullScreenDiffX
				else
					display.notchSceenSafeArea = 0
					display.notchSceenDiffX = 0
				end

				printInfo("# display.notchSceenSafeArea changed   = %d", display.notchSceenSafeArea)
				printInfo("# display.notchSceenDiffX changed      = %d", display.notchSceenDiffX)
			end
		end)
	end

	if APP_CHANNEL == nil then
		return
	end

	local channel = string.lower(APP_CHANNEL)

	if channel == "bare" then
		channel = "none"
	end

	local ok, ret = pcall(require, "app.sdk." .. channel)

	if ok then
		sdk.spec = ret

		printInfo("%s sdk inited", channel)

		if device.platform ~= "windows" and device.platform ~= "mac" then
			sdk.isSupportSubscribe(function(info)
				if info == 1 then
					sdk.supportSubscribe = true
				end
			end)
		end
	else
		printWarn(ret)
	end

	local targetPlatform = cc.Application:getInstance():getTargetPlatform()

	if cc.PLATFORM_OS_OHOS == targetPlatform then
		sdk.windowSizeChange()
	end
end

init()
