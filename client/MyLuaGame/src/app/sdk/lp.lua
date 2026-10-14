-- chunkname: @src.app.sdk.lp

local lp = {}

function lp.login(cb)
	print("Lua lp.login")
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

function lp.commitRoleInfo(ctype, cb)
	print("Lua lp.commitRoleInfo")

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

function lp.trackEvent(ctype, data)
	print("Lua lp.trackEvent")

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

function lp.logout(cb)
	print("Lua lp.logout")
	sdk.callPlatformFunc("logout", "game", function(info)
		print("logout ret = ", info)
		cb(0, "ok")
	end)
end

local defaultPrefix = {
	"com.de.dgf",
	3
}
local productPrefixTagMap = {
	lp_vn = {
		"vnkdjx_money_",
		3100
	},
	com_de_dgf = {
		"mcdbz",
		1100
	}
}

function lp.pay(cpOrderId, extInfo, amount, rechargeId, productDesc, cb)
	print("Lua lp.pay")

	local roleInfo = gGameModel.role
	local productID
	local prefix, startID = unpack(productPrefixTagMap[APP_TAG] or defaultPrefix)

	if APP_TAG == "com_de_dgf" then
		if rechargeId >= 1100 then
			if rechargeId - startID > 9 then
				productID = prefix .. rechargeId - startID
			else
				productID = prefix .. "0" .. rechargeId - startID
			end
		elseif rechargeId - startID > 9 then
			productID = prefix .. rechargeId
		else
			productID = prefix .. "0" .. rechargeId
		end
	elseif rechargeId >= 1100 then
		productID = prefix .. rechargeId - startID
	else
		productID = prefix .. rechargeId
	end

	local tmp = {
		count = 1,
		currency = "cny",
		roleId = stringz.bintohex(roleInfo:read("id")),
		roleName = roleInfo:read("name"),
		roleLevel = tostring(roleInfo:read("level")),
		area = gGameApp.serverInfo.name,
		area_id = tostring(roleInfo:read("area")),
		rmb = amount,
		amount = amount / 10,
		extInfo = extInfo,
		productDesc = productDesc,
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

return lp
