-- chunkname: @src.app.sdk.ks_kr_a

local ks_kr_a = {}

function ks_kr_a.login(cb)
	print("Lua ks_kr_a.login")
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
	"SUBMIT_TYPE_ENTER",
	"SUBMIT_TYPE_UPGRADE",
	"SUBMIT_TYPE_EXIT_GAME",
	"SUBMIT_TYPE_CREATE",
	nil,
	nil,
	nil,
	"SUBMIT_TYPE_UPDATE"
}

function ks_kr_a.commitRoleInfo(ctype, cb)
	print("Lua ks_kr_a.commitRoleInfo  ctype:" .. ctype)

	local tmp = {
		ctype = ctype,
		area = gGameApp.serverInfo.name,
		level = tostring(gGameModel.role:read("level")),
		area_id = tostring(gGameModel.role:read("area")),
		role_id = stringz.bintohex(gGameModel.role:read("id")),
		role_name = gGameModel.role:read("name"),
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
	START_CDN = "cp_hotfix_start",
	pull_version_end = "cp_unzip_end",
	START_LOADING = "EVENTS_START_LOADING",
	FINISHED_LOADING = "cp_init_finish",
	pull_version_begin = "cp_unzip_start",
	CDN_FINISH = "cp_hotfix_end"
}

function ks_kr_a.trackEvent(ctype, data)
	print("Lua ks_kr_a.trackEvent  ctype:", tostring(ctype))

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

function ks_kr_a.logout(cb)
	print("Lua ks_kr_a.logout")
	sdk.callPlatformFunc("logout", "game", function(info)
		print("logout ret = ", info)
		cb(0, "ok")
	end)
end

function ks_kr_a.getSdkConfig(cb)
	print("Lua ks_kr_a.getsdkConfig")
	sdk.callPlatformFunc("getsdkConfig", "", function(info)
		print("getsdkConfig ret = ", info)
		cb(0, info)
	end)
end

local prefixInfo = {
	"5",
	"7",
	[113] = "13",
	[104] = "3",
	[108] = "8",
	[112] = "12",
	[111] = "11",
	[110] = "10",
	[107] = "6",
	[105] = "4",
	[102] = "1",
	[106] = "5",
	[103] = "2",
	[109] = "9"
}
local defaultPrefix = {
	"com.zhs.cqwy",
	12047,
	prefixInfo
}
local productPrefixTagMap = {
	com_zhs_cqwy_yidun_v4 = {
		"com.zhs.cqwy",
		12047,
		prefixInfo
	},
	com_gwds_qc_yidun_v4 = {
		"com.gwds.qc",
		13074,
		prefixInfo
	},
	com_hw_wjb_yidun_v4 = {
		"com.hw.wjb",
		13100,
		prefixInfo
	}
}

function ks_kr_a.pay(cpOrderId, extInfo, amount, rechargeId, productDesc, cb)
	print("Lua ks_kr_a.pay")

	local roleInfo = gGameModel.role
	local productID
	local payInfo = csv.recharges[rechargeId]
	local prefix, startID, prefixInfo = unpack(productPrefixTagMap[APP_TAG] or defaultPrefix)

	if rechargeId >= 4100 then
		productID = rechargeId - 4100 + startID
	elseif prefixInfo[rechargeId] then
		productID = tonumber(prefixInfo[rechargeId]) + startID
	else
		print("未获取到对应商品id映射 rechargeId:" .. rechargeId)

		productID = rechargeId
	end

	local productType = 1

	productType = rechargeId >= 4101 and rechargeId <= 4113 and 1 or 2

	local tmp = {
		currency = "cny",
		count = 1,
		roleId = stringz.bintohex(roleInfo:read("id")),
		roleName = roleInfo:read("name"),
		roleLevel = tostring(roleInfo:read("level")),
		area = gGameApp.serverInfo.name,
		area_id = tostring(roleInfo:read("area")),
		rmb = amount,
		rmbDisplay = payInfo.rmbDisplay,
		amount = amount / 10,
		extInfo = extInfo,
		productDesc = productDesc,
		productName = productDesc,
		productID = productID,
		productType = productType
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

return ks_kr_a
