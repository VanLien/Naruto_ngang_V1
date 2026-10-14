-- chunkname: @src.app.sdk.ks_kr_i

local ks_kr_i = {}

function ks_kr_i.login(cb)
	print("Lua ks_kr_i.login")
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
	"enter",
	"levelup",
	"exitGame",
	"create",
	nil,
	nil,
	nil,
	"ChangeName"
}

function ks_kr_i.commitRoleInfo(ctype, cb)
	print("Lua ks_kr_i.commitRoleInfo  ctype:" .. ctype)

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

function ks_kr_i.trackEvent(ctype, data)
	print("Lua ks_kr_i.trackEvent  ctype:", tostring(ctype))

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

function ks_kr_i.logout(cb)
	print("Lua ks_kr_i.logout")
	sdk.callPlatformFunc("logout", "game", function(info)
		print("logout ret = ", info)
		cb(0, "ok")
	end)
end

function ks_kr_i.getSdkConfig(cb)
	print("Lua ks_kr_i.getsdkConfig")
	sdk.callPlatformFunc("getsdkConfig", "", function(info)
		print("getsdkConfig ret = ", info)
		cb(0, info)
	end)
end

local prefixInfo = {
	"499",
	"1299",
	[113] = "9999",
	[4112] = "4999",
	[4104] = "399",
	[112] = "4999",
	[108] = "1499",
	[104] = "299",
	[111] = "2999",
	[4102] = "199",
	[4105] = "499",
	[102] = "99",
	[110] = "2599",
	[4106] = "899",
	[4107] = "1299",
	[103] = "199",
	[109] = "1999",
	[4108] = "1499",
	[4109] = "1999",
	[4110] = "2599",
	[4103] = "299",
	[4111] = "2999",
	[4101] = "99",
	[4113] = "9999",
	[107] = "899",
	[106] = "499",
	[105] = "399"
}
local prefixInfo_2 = {
	"5",
	"7",
	[113] = "13",
	[4112] = "12",
	[4104] = "4",
	[112] = "12",
	[108] = "8",
	[104] = "3",
	[111] = "11",
	[4102] = "2",
	[4105] = "5",
	[102] = "1",
	[110] = "10",
	[4106] = "6",
	[4107] = "7",
	[103] = "2",
	[109] = "9",
	[4108] = "8",
	[4109] = "9",
	[4110] = "10",
	[4103] = "3",
	[4111] = "11",
	[4101] = "1",
	[4113] = "13",
	[107] = "6",
	[106] = "5",
	[105] = "4"
}
local defaultPrefix = {
	"com.koudaimeng.",
	4100,
	prefixInfo
}
local productPrefixTagMap = {
	com_zhs_cqwy_yidun_v4 = {
		"com.koudaimeng.",
		4100,
		prefixInfo
	},
	com_zheng_guotian_yidun_v4 = {
		"com.hantj.",
		4100,
		prefixInfo_2
	}
}

function ks_kr_i.pay(cpOrderId, extInfo, amount, rechargeId, productDesc, cb)
	print("Lua ks_kr_i.pay")

	local roleInfo = gGameModel.role
	local productID
	local payInfo = csv.recharges[rechargeId]
	local prefix, startID, prefixInfo = unpack(productPrefixTagMap[APP_TAG] or defaultPrefix)

	if prefixInfo[rechargeId] then
		productID = prefix .. prefixInfo[rechargeId]
	else
		print("未获取到对应商品id映射 rechargeId:" .. rechargeId)

		productID = prefix .. tostring(rechargeId)
	end

	local productType = 1

	productType = rechargeId >= 4101 and rechargeId <= 4113 and 1 or 2

	local tmp = {
		count = 1,
		currency = "cny",
		roleId = stringz.bintohex(roleInfo:read("id")),
		roleName = roleInfo:read("name"),
		roleLevel = tostring(roleInfo:read("level")),
		area = gGameApp.serverInfo.name,
		area_id = tostring(roleInfo:read("area")),
		rmb = amount,
		rmbDisplay = payInfo.rmbDisplay,
		amount = amount,
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

return ks_kr_i
