-- chunkname: @src.app.sdk.lp_kr

local lp_kr = {}

function lp_kr.login(cb)
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

function lp_kr.switch(cb)
	print("Lua lp_kr.switchAccount")
	sdk.callPlatformFunc("switchAccount", "", function(info)
		print("logout ret = ", info)
		cb(0, "ok")
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

function lp_kr.commitRoleInfo(ctype, cb)
	print("Lua lp.commitRoleInfo")

	local funcType = 1

	if sdk.sdkChannel ~= "-1" then
		funcType = 2
	end

	local tmp = {}

	tmp = {
		ctype = ctype,
		area = gGameApp.serverInfo.name,
		level = tostring(gGameModel.role:read("level")),
		area_id = tostring(gGameModel.role:read("area")),
		user_name = gGameModel.role:read("name"),
		user_id = tostring(gGameModel.role:read("uid")),
		role_id = stringz.bintohex(gGameModel.role:read("id")),
		vip = tostring(gGameModel.role:read("vip_level")),
		created_time = tostring(gGameModel.role:read("created_time")),
		upload_type = roleInfoMap[ctype],
		funcType = funcType
	}

	if tmp.upload_type == nil then
		return cb(0, "ok")
	end

	sdk.callPlatformFunc("commitRoleInfo", json.encode(tmp), function(info)
		print("commitRoleInfo ret = ", info)
		cb(0, "ok")
	end)
end

function lp_kr.openCustomerService(vip)
	print("openCustomerService:", vip)

	local funcType = 1

	if sdk.sdkChannel ~= "-1" then
		funcType = 2
	end

	local tmp = {
		role_id = "",
		user_id = "",
		user_name = "",
		area_id = "",
		level = "",
		area = "",
		created_time = "",
		vip = vip,
		funcType = funcType
	}

	if device.platform == "android" then
		sdk.callPlatformFunc("openCustomerService", json.encode(tmp), function(info)
			print("openCustomerService ret = ", info)
		end)
	else
		sdk.callPlatformFunc("openSupport", json.encode(tmp), function(info)
			print("openCustomerService ret = ", info)
		end)
	end
end

local eventMap = {
	FINISHED_LOADING = "EVENTS_FINISHED_LOADING",
	START_LOADING = "EVENTS_START_LOADING",
	CDN_5 = "CDN_5",
	START_GAME = "START_GAME",
	START_LOGIN = "START_LOGIN",
	CLICK_OK = "CLICK_OK",
	PULL_GAMESHOW = "PULL_GAMESHOW",
	NOTNETWORK_CLICK = "NOTNETWORK_CLICK",
	CDN_FINISH = "CDN_FINISH",
	CDN_60 = "CDN_60",
	CDN_30 = "CDN_30",
	START_CDN = "START_CDN",
	PULL_VERSION = "PULL_VERSION"
}

function lp_kr.trackEvent(ctype, data)
	print("Lua lp_kr.trackEvent")

	if eventMap[ctype] == nil then
		return
	end

	if ctype == 2 or ctype == 1 then
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

function lp_kr.logout(cb)
	print("Lua lp.logout")
	sdk.callPlatformFunc("logout", "game", function(info)
		print("logout ret = ", info)
		cb(0, "ok")
	end)
end

local defaultPrefix = {
	"jxkrfc_money_",
	1
}
local productPrefixTagMap = {
	com_mccjh_mccjh_1 = defaultPrefix,
	lp_kr = {
		"jxkrfc_money_",
		1
	},
	com_jka_jxkr_first = {
		"com.jka.jxkr.first_",
		1
	},
	com_ptjx_krmp_two = {
		"com.ptjx.krmp.two_",
		1
	},
	as_ptjx_krmp_two = {
		"com.ptjx.krmp.two_",
		1
	},
	as_ptjx_dev_two = {
		"com.ptjx.krmp.two_",
		1
	},
	as_jka_jxkr_first = {
		"com.jka.jxkr.first_",
		1
	},
	as_0323_krmp_two = {
		"com.ptjx.krmp.two_",
		1
	},
	as_jxry_krlt_hree = {
		"com.jxry.krlt.hree_",
		1
	},
	as_jxry_krlt_four = {
		"com.jxry.krlt.four_",
		1
	},
	as_jxtrkr_bzvxwu = {
		"com.jxtrkr.bzvxwu_",
		1
	},
	as_jxqy_six = {
		"com.jxqy.krtq.six_",
		1
	},
	as_monster = {
		"monster_",
		1
	},
	as_emaster = {
		"emaster_",
		1
	},
	as_naikr = {
		"naikr_",
		1
	},
	as_tenkr = {
		"tenkr_",
		1
	},
	as_elevenkr = {
		"elevenkr_",
		1
	},
	as_twelvekr = {
		"twelvekr_",
		1
	},
	as_thirteenkr = {
		"thirteenkr_",
		1
	},
	as_fourteenkr = {
		"fourteenkr_",
		1
	},
	as_fifteenkr = {
		"fifteenkr_",
		1
	},
	as_sixteenkr = {
		"sixteenkr_",
		1
	},
	as_seventeenkr = {
		"seventeenkr_",
		1
	},
	as_eighteenkr_yidun = {
		"eighteenkr_",
		1
	},
	as_nineteenkr_yidun = {
		"nineteenkr_",
		1
	},
	as_com_xdft_hjnm_oijk_yidun = {
		"jxkrfc_money_",
		1
	},
	as_pkmatkr_yidun = {
		"pkmatkr_",
		1
	},
	as_pmgmpd_yidun = {
		"pmgmpd_",
		1
	},
	as_ghjnadvt_yidun = {
		"ghjnadvt_",
		1
	},
	as_jsdnfjitem_yidun = {
		"jsdnfjitem_",
		1
	},
	as_com_cyzq_cyan_aert_yidun = {
		"elmttrprd_",
		1
	},
	as_com_fkdjxkr_id11_yidun_v4 = {
		"elmttrprd_",
		1
	},
	as_com_fkdjxkr_id10_ld_yidun_v4 = {
		"pmgmpd_",
		1
	},
	as_com_fkdjxkr_base_yidun_v4 = {
		"elmttrprd_",
		1
	},
	as_com_fkdjxkr_base_yidun_v4_shenhe = {
		"elmttrprd_",
		1
	},
	as_com_fkdjxkr_base_yidun_v4_shenhe1 = {
		"elmttrprd_",
		1
	},
	as_com_fkdjxkr_base_yidun_v4_onestore2 = {
		"elmttrprd_",
		1
	},
	as_com_fkdjxkr_base_yidun_v4_onestore3 = {
		"elmttrprd_",
		1
	},
	as_com_fkdjxkr_base_yidun_v4_qd5 = {
		"elmttrprd_",
		1
	},
	as_240903_com_fkdjxkr_base_yidun_v4 = {
		"elmttrprd_",
		1
	},
	as_com_fkdjxkr_base_yidun_v4_onestore4 = {
		"elmttrprd_",
		1
	},
	as_com_fkdjxkr_id01_yidun_v4_samsung = {
		"kdjxkrsx_",
		1
	},
	as_com_may_ioskr = {
		"com.may.ioskr_",
		1
	},
	as_com_poture_ioskr = {
		"com.poture.ioskr_",
		1
	},
	as_com_apthreekr_ioskr = {
		"apthreekr_",
		1
	},
	as_com_apfourkr_ioskr = {
		"apfourkr_",
		1
	},
	as_pocketfight_ioskr_yidun = {
		"pocketfight_",
		1
	},
	as_com_awakening_krelementary_yidun = {
		"elmawpro_",
		1
	},
	com_evolution_gachaios_yidun = {
		"Evolite_",
		1
	},
	com_evolution_gacha_ios_yidun_v4 = {
		"elmttrprd_",
		1
	}
}

function lp_kr.pay(cpOrderId, extInfo, amount, rechargeId, productDesc, cb)
	print("Lua lp.pay")

	local roleInfo = gGameModel.role
	local productID
	local prefix, startID = unpack(productPrefixTagMap[APP_TAG] or defaultPrefix)

	if rechargeId >= 4100 then
		productID = prefix .. rechargeId - 4100
	elseif rechargeId >= 108 then
		productID = prefix .. rechargeId - 100
	elseif rechargeId > 100 then
		productID = prefix .. rechargeId - 101
	elseif rechargeId >= 3 then
		productID = prefix .. startID + 9 - rechargeId
	else
		productID = prefix .. 2 * rechargeId + 3
	end

	local _roleLevel = tostring(roleInfo:read("level"))

	if APP_TAG == "as_pkmatkr_yidun" then
		_roleLevel = extInfo
	end

	local tmp = {
		count = 1,
		currency = "₩",
		roleId = stringz.bintohex(roleInfo:read("id")),
		roleName = roleInfo:read("name"),
		roleLevel = _roleLevel,
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

function lp_kr.getSDKChannel(cb)
	print("Lua lp_kr.getChannel")
	sdk.callPlatformFunc("getSDKChannel", "", function(info)
		print("Lua lp_kr.getChannel:" .. info)
		cb(info)
	end)
end

return lp_kr
