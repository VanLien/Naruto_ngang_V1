-- chunkname: @src.app.sdk.zd

local zd = {}

function zd.login(cb)
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
	"NewbieGuideEnd",
	nil,
	"ChangeName"
}

function zd.commitRoleInfo(ctype, cb)
	print("cctest ctype is %d", ctype)

	local tmp = {
		area_id = 999,
		ctype = ctype,
		area = gGameApp.serverInfo.name,
		level = tostring(gGameModel.role:read("level")),
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

function zd.trackEvent(ctype, data)
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

function zd.logout(cb)
	sdk.callPlatformFunc("logout", "game", function(info)
		print("logout ret = ", info)
		cb(0, "ok")
	end)
end

local defaultPrefix = {
	"com.tiji.kd.",
	3
}
local productPrefixTagMap = {
	zd_en = defaultPrefix
}

function zd.pay(cpOrderId, extInfo, amount, rechargeId, productDesc, cb)
	local roleInfo = gGameModel.role
	local productID
	local prefix, startID = unpack(productPrefixTagMap[APP_TAG] or defaultPrefix)

	if rechargeId >= 101 then
		productID = prefix .. "zg" .. rechargeId - 101
	elseif rechargeId == 1 then
		productID = prefix .. "mc"
	elseif rechargeId == 2 then
		productID = prefix .. "mc1"
	else
		productID = prefix .. amount
	end

	print("!!!zd.pay:", rechargeId, "|", productID)

	local tmp = {
		count = 1,
		currency = "cny",
		roleId = tostring(roleInfo:read("uid")),
		roleName = roleInfo:read("name"),
		roleLevel = tostring(roleInfo:read("level")),
		area = gGameApp.serverInfo.name,
		area_id = tostring(roleInfo:read("area")),
		rmb = amount,
		amount = amount / 10,
		extInfo = extInfo,
		productDesc = productDesc,
		productName = productDesc,
		OrderId = cpOrderId,
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

return zd
