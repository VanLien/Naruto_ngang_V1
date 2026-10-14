-- chunkname: @src.app.sdk.ks_a

local ks_a = {}

function ks_a.login(cb)
	print("Lua ks_a.login")
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

function ks_a.commitRoleInfo(ctype, cb)
	print("Lua ks_a.commitRoleInfo  ctype:" .. ctype)

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
	FINISHED_LOADING = "cp_init_finish",
	CDN_FINISH = "cp_hotfix_end",
	pull_version_end = "cp_unzip_end",
	START_CDN = "cp_hotfix_start",
	pull_version_begin = "cp_unzip_start",
	START_LOADING = "EVENTS_START_LOADING"
}

function ks_a.trackEvent(ctype, data)
	print("Lua ks_a.trackEvent  ctype:", tostring(ctype))

	if eventMap[ctype] == nil then
		return
	end

	if not string.find(APP_TAG, "_kssdk") then
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

function ks_a.logout(cb)
	print("Lua ks_a.logout")
	sdk.callPlatformFunc("logout", "game", function(info)
		print("logout ret = ", info)
		cb(0, "ok")
	end)
end

function ks_a.getSdkConfig(cb)
	print("Lua ks_a.getsdkConfig")
	sdk.callPlatformFunc("getsdkConfig", "", function(info)
		print("getsdkConfig ret = ", info)
		cb(0, info)
	end)
end

local defaultPrefix = {
	"com.jljxm.google",
	538
}
local productPrefixTagMap = {
	com_jljxm_google = {
		"com.jljxm.google",
		538
	},
	com_sbhx_google = {
		"com.sbhx.google",
		700
	},
	com_mcdzz_google = {
		"com.mcdzz.google",
		713
	},
	com_mbdmx_google = {
		"com.mbdmx.google",
		823
	},
	com_magiclk_google = {
		"com.magiclk.google",
		853
	},
	com_ssjxsmash_google = {
		"com.ssjxsmash.google",
		866
	},
	com_sbxxs_google = {
		"com.sbxxs.google",
		879
	},
	com_ssqyjb_google = {
		"com.ssqyjb.google",
		905
	},
	com_sbcnd_google = {
		"com.sbcnd.google",
		918
	},
	com_sbdljx_google = {
		"com.sbdljx.google",
		947
	},
	com_ssdsstorm_google = {
		"com.ssdsstorm.google",
		961
	},
	com_ssjfz_google = {
		"com.ssjfz.google",
		1021
	},
	com_ssj_google = {
		"com.ssjfz.google",
		1021
	},
	com_ssj11_google = {
		"com.ssjfz.google",
		1021
	},
	com_sbqsl_google = {
		"com.sbqsl.google",
		1073
	},
	com_sbq_google = {
		"com.sbqsl.google",
		1073
	},
	com_ssayqj_google = {
		"com.ssayqj.google",
		1099
	},
	com_scmyj_google = {
		"com.scmyj.google",
		1113
	},
	com_scmyj_google_a = {
		"com.scmyj.google",
		1113
	},
	com_hxlegend_google = {
		"com.hxlegend.google",
		1257
	},
	com_skdj_google = {
		"com.skdj.google",
		1257
	},
	com_sblmwlzz_google = {
		"com.sblmwlzz.google",
		1371
	},
	com_ssjjskdj_google = {
		"com.ssjjskdj.google",
		1397
	},
	com_stwguanjun_google = {
		"com.stwguanjun.google",
		2198
	},
	com_stwguanjun_google_two = {
		"com.stwguanjun.google",
		2198
	},
	com_sczj_google = {
		"com.sczj.google",
		2250
	},
	com_ylslcs_google = {
		"com.ylslcs.google",
		2382
	},
	com_mydsldj_google = {
		"com.mydsldj.google",
		2449
	},
	com_chaoneng_google = {
		"com.chaoneng.google",
		2635
	},
	com_mengcjh_google = {
		"com.mengcjh.google",
		2865
	},
	com_mocchuans_google = {
		"com.mocchuans.google",
		3278
	},
	com_yjguodus_google = {
		"com.yjguodus.google",
		3669
	},
	com_qmcw_google = {
		"com.qmcw.google",
		3589
	},
	com_mxcsqc_google = {
		"com.mxcsqc.google",
		3785
	},
	com_sbmxt_google = {
		"com.sbmxt.google",
		3831
	},
	com_sblmwlzz_google_two = {
		"com.sblmwlzz.google",
		1371
	},
	com_sblmwlzz_google_two_yidun = {
		"com.sblmwlzz.google",
		1371
	},
	com_shenbird_google_yidun = {
		"com.shenbird.google",
		5112
	},
	com_sncs_google_yidun = {
		"com.sncs.google",
		5175
	},
	com_hslcheng_google_yidun = {
		"com.hslcheng.google",
		5290
	},
	com_lzjuexing_google_yidun = {
		"com.lzjuexing.google",
		4907
	},
	com_mcjizhanpx_google_yidun = {
		"com.mcjizhanpx.google",
		5620
	},
	com_sbwjb_google_yidun = {
		"com.sbwjb.google",
		5818
	},
	com_mhyyxk_google_yidun = {
		"com.mhyyxk.google",
		5786
	},
	com_ssjfz_google_yidun = {
		"com.ssjfz.google",
		1021
	},
	com_sbhx_google_yidun = {
		"com.sbhx.google",
		700
	},
	com_hxmjyycs_google_yidun = {
		"com.hxmjyycs.google",
		6023
	},
	com_ylszz_yhzc_kssdk_yidun_v4 = {
		"ylszz.",
		6866
	},
	com_xjss_qy_kssdk_yidun_v4 = {
		"xjss.",
		6853
	},
	com_sbqyxsd_google_kssdk_yidun_v4 = {
		"sbqyxsd.",
		9132
	},
	com_amr_hegazy_google_kssdk_yidun_v4 = {
		"scgjzl.",
		9538
	},
	com_ssqy_jhh_google_kssdk_yidun_v4 = {
		"com.ssqy.jhh.",
		13061
	}
}

function ks_a.pay(cpOrderId, extInfo, amount, rechargeId, productDesc, cb)
	print("Lua ks_a.pay")

	local roleInfo = gGameModel.role
	local productID
	local payInfo = csv.recharges[rechargeId]
	local prefix, startID = unpack(productPrefixTagMap[APP_TAG] or defaultPrefix)

	if rechargeId >= 1100 then
		productID = rechargeId - 1100 + startID
	elseif rechargeId >= 108 then
		productID = rechargeId - 100 + startID
	elseif rechargeId > 100 then
		productID = rechargeId - 101 + startID
	else
		productID = rechargeId * 2 + 3 + startID
	end

	local productType = 1

	productType = rechargeId >= 2101 and rechargeId <= 2113 and 1 or 2

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

return ks_a
