-- chunkname: @src.app.sdk.xy51

local xy51 = {}

function xy51.login(cb)
	sdk.callPlatformFunc("login", "", function(info)
		print("login ret = ", info)

		if info == "error" then
			cb(-1, info)
		elseif info == "cancel" then
			cb(-1, info)
		else
			cb(0, info)
			sdk.callPlatformFunc("logout", "assist", function(info)
				print("logout in assist ret = ", info)
				gGameApp:onBackLogin()
			end)
		end
	end)
end

local roleInfoMap = {
	"EnterServer",
	"LevelUp",
	"ExitGame",
	"CreateRole",
	nil,
	nil,
	nil,
	"ChangeName"
}

function xy51.commitRoleInfo(ctype, cb)
	local tmp = {
		ctype = ctype,
		area = gGameApp.serverInfo.name,
		level = tostring(gGameModel.role:read("level")),
		area_id = tostring(gGameModel.role:read("area")),
		user_name = gGameModel.role:read("name"),
		user_id = tostring(gGameModel.role:read("uid")),
		vip = tostring(gGameModel.role:read("vip_level")),
		created_time = tostring(gGameModel.role:read("created_time")),
		upload_type = roleInfoMap[ctype]
	}

	if tmp.upload_type == nil then
		return cb(0, "ok")
	end

	sdk.callPlatformFunc("commitRoleInfo", json.encode(tmp), function(info)
		print("commitRoleInfo ret = ", info)
		cb(0, "ok")
	end)
end

local eventMap = {
	FINISHED_LOADING = "EVENTS_FINISHED_LOADING",
	START_LOADING = "EVENTS_START_LOADING"
}

function xy51.trackEvent(ctype, data)
	if eventMap[ctype] == nil then
		return
	end

	if type(data) ~= "table" then
		data = {
			data = data
		}
	end

	data.ctype = ctype
	data.event = eventMap[ctype] or ""

	sdk.callPlatformFunc("trackEvent", json.encode(data), function(info)
		print("trackEvent ret = ", info)
	end)
end

function xy51.logout(cb)
	sdk.callPlatformFunc("logout", "game", function(info)
		print("logout ret = ", info)
		cb(0, "ok")
	end)
end

local defaultPrefix = {
	"com.mccjh.mccjh.",
	3
}
local productPrefixTagMap = {
	com_mccjh_mccjh_1 = defaultPrefix,
	com_jiaowan_kdjx = {
		"com.jiaowan.kdjx.",
		3
	},
	com_xy51_koudaijuexing = {
		"com.xy51.koudaijuexing.",
		3
	}
}
local specialProductTagMap = {}

local function specialProductID(rechargeId)
	local special = specialProductTagMap[APP_TAG]

	if special == nil then
		return
	end

	return special[rechargeId]
end

function xy51.pay(cpOrderId, extInfo, amount, rechargeId, productDesc, cb)
	if APP_TAG == "xy51_test" then
		cb(-1, "error")

		return
	end

	local roleInfo = gGameModel.role
	local prefix, startID = unpack(productPrefixTagMap[APP_TAG] or defaultPrefix)
	local productID = specialProductID(rechargeId)
	local desc = productDesc

	if productID == nil then
		if rechargeId >= 101 then
			productID = prefix .. rechargeId
		elseif rechargeId >= 3 then
			productID = prefix .. startID + 9 - rechargeId
		else
			productID = prefix .. rechargeId
		end
	end

	local tmp = {
		currency = "cny",
		count = 1,
		roleId = tostring(roleInfo:read("uid")),
		roleName = roleInfo:read("name"),
		roleLevel = tostring(roleInfo:read("level")),
		vip = tostring(roleInfo:read("vip_level")),
		area = gGameApp.serverInfo.name,
		area_id = tostring(roleInfo:read("area")),
		rmb = amount,
		amount = amount / 10,
		extInfo = extInfo,
		productDesc = desc,
		productName = productDesc,
		productID = productID
	}

	sdk.callPlatformFunc("pay", json.encode(tmp), function(info)
		print("pay ret = ", info)

		if info == "ok" then
			cb(0, info)
		else
			cb(-1, "error")
		end
	end)
end

local SkipIdentityTag = {
	android_10054 = true,
	android_10054_20191230 = true,
	android_17849_20200218 = true
}

function xy51.queryIdentity(cb, count)
	if SkipIdentityTag[APP_TAG] or device.platform ~= "android" then
		return cb(nil)
	end

	count = (count or 0) + 1

	if count > 3 then
		return cb(0)
	end

	sdk.callPlatformFunc("queryIdentity", "", function(age)
		print("queryIdentity ret = ", age)

		if age == "error" then
			performWithDelay(gGameUI.scene, function()
				xy51.queryIdentity(cb, count)
			end, 60)
		elseif age == "closed" then
			cb(nil)
		else
			cb(tonumber(age))
		end
	end)
end

function xy51.queryUserType(cb, count)
	if SkipIdentityTag[APP_TAG] or device.platform ~= "android" then
		return cb(nil)
	end

	count = (count or 0) + 1

	if count > 3 then
		return cb(0)
	end

	sdk.callPlatformFunc("queryUserType", "", function(typ)
		print("queryUserType ret = ", typ)

		if typ == "error" then
			performWithDelay(gGameUI.scene, function()
				xy51.queryUserType(cb, count)
			end, 60)
		elseif typ == "closed" then
			cb(nil)
		else
			cb(tonumber(typ))
		end
	end)
end

function xy51.openCustomerService()
	sdk.callPlatformFunc("openCustomerService", "", function(info)
		print("openCustomerService ret = ", info)
	end)
end

function xy51.openPrivacyProtocols()
	sdk.callPlatformFunc("openPrivacyProtocols", "", function(info)
		print("openPrivacyProtocols ret = ", info)
	end)
end

function xy51.openPermissionSetting()
	sdk.callPlatformFunc("openPermissionSetting", "", function(info)
		print("openPermissionSetting ret = ", info)
	end)
end

if APP_TAG ~= "xy51_test" then
	globals.VERSION_CONF_URL = "http://124.71.138.126:18080/version"
	globals.SERVER_CONF_URL = "http://124.71.138.126:18080/servers"
	globals.NOTICE_CONF_URL = "http://124.71.138.126:18080/notice"
	globals.LOGIN_SERVRE_HOSTS_TABLE = {
		"124.71.138.126:16666"
	}

	if next(LOGIN_SERVRE_HOSTS_TABLE) then
		globals.IPV6_TEST_HOST = string.gmatch(LOGIN_SERVRE_HOSTS_TABLE[1], "([-a-z0-9A-Z.]+):(%d+)")()
	end
end

return xy51
