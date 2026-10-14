-- chunkname: @src.app.sdk.ks_i

local ks = {}

function ks.login(cb)
	print("Lua ks.login")
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

function ks.commitRoleInfo(ctype, cb)
	print("Lua ks.commitRoleInfo")

	local tmp = {
		ctype = ctype,
		area = gGameApp.serverInfo.name,
		level = tostring(gGameModel.role:read("level")),
		area_id = tostring(gGameModel.role:read("area")),
		user_name = gGameModel.role:read("name"),
		user_id = stringz.bintohex(gGameModel.role:read("id")),
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
	START_LOADING = "EVENTS_START_LOADING",
	pull_version_end = "cp_unzip_end",
	pull_version_begin = "cp_unzip_start",
	FINISHED_LOADING = "cp_init_finish",
	CDN_FINISH = "cp_hotfix_end",
	START_CDN = "cp_hotfix_start"
}

function ks.trackEvent(ctype, data)
	print("Lua ks.trackEvent")

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

function ks.logout(cb)
	print("Lua ks.logout")
	sdk.callPlatformFunc("logout", "game", function(info)
		print("logout ret = ", info)
		cb(0, "ok")
	end)
end

local defaultPrefix = {
	"com.jljxM.ios.",
	1100
}
local productPrefixTagMap = {
	com_jljxM_ios = {
		"com.jljxM.ios.",
		1100
	},
	mx = {
		"mx.",
		1100
	},
	sbhx_sydj = {
		"sbhx.sydj.",
		1100
	},
	fire_n_darkness = {
		"FnD.",
		1100
	},
	con_mcdzz_mcdzz = {
		"mcdzz.",
		1100
	},
	con_mbdmx_mbdmx = {
		"mb.",
		1100
	},
	com_gp_sblkz = {
		"sblkz.",
		1100
	},
	com_ssqy_jiban = {
		"jiban.",
		1100
	},
	com_ssjx_ios = {
		"com.ssjx.ios.",
		1100
	},
	com_ssds_ios = {
		"com.ssds.ios.",
		1100
	},
	com_sbdljx_ios = {
		"com.sbdljx.ios.",
		1100
	},
	sscq_jjt_ios = {
		"sscq.jjt.ios.",
		1100
	},
	scmyj_ios = {
		"scmyj.ios.",
		1100
	},
	com_bdsskdj_ios = {
		"com.bdsskdj.ios.",
		1100
	},
	com_chijings_ios = {
		"diamant_",
		1100
	},
	com_stwgjzz_ios = {
		"com.stwgjzz.ios.",
		1100
	},
	myd_sldj_ios = {
		"myd.sldj.ios.",
		1100
	},
	mh_yaoling_fy = {
		"mh.yaoling.fy.",
		1100
	},
	com_ssjtskdj_ios = {
		"com.ssjtskdj.io.",
		1100
	},
	com_navigation_ios = {
		"Navigation.ios.",
		1100
	},
	cs_tanxian_ios = {
		"cs.tanxian.ios.",
		1100
	},
	com_gwgjj_ios = {
		"diamant_",
		1100
	},
	com_shenniaocs_ios_yidun = {
		"diamant_",
		1100
	},
	ssjb_jinhua_ios = {
		"ssjb.jinhua.ios.",
		1100
	},
	com_skzl_ios = {
		"diamant_",
		1100
	},
	com_ldjxx_ios = {
		"com.ldjxx.ios.",
		1100
	},
	com_fyzgsycs_ios = {
		"com.fyzgsycs.ios.",
		1100
	},
	com_qikel_rujes = {
		"com.qikel.rujes.",
		1100
	},
	com_divine_realm_yidun = {
		"com.Divine.Realm.",
		1100
	},
	com_shenniaocs_ios_new_yidun = {
		"diamant_",
		1100
	},
	com_legendary_ios_yidun = {
		"com.legendary.",
		1100
	},
	com_lowquality_meld_ios_yidun = {
		"com.Lowquality.Meld.",
		1100
	},
	com_favor_ios_yidun = {
		"com.favor.",
		1100
	},
	chongshou_ios_yidun = {
		"diamant_",
		1100
	},
	mx_ios_yidun = {
		"mx.",
		1100
	},
	com_skzl_ios_yidun = {
		"diamant_",
		1100
	},
	com_fyzgsycs_ios_yidun = {
		"com.fyzgsycs.ios.",
		1100
	},
	com_shens_ysdl_ios_yidun = {
		"com.shens.ysdl.",
		1100
	},
	com_ssds_ios_yidun = {
		"com.ssds.",
		1100
	},
	xingji_hszl_ios_yidun = {
		"xingji.hszl.",
		1100
	},
	lingch_ios_yidun = {
		"diamant_",
		1100
	},
	com_xuanwen_slzz_ios_yidun = {
		"slzz",
		1100
	},
	com_yjsc_hmsj_ios_yidun = {
		"yjsc.hmsj.",
		1100
	},
	com_shenrenzd_ios_yidun = {
		"xyqm",
		1100
	},
	com_fanyu_awakening_ios_yidun_v4 = {
		"cwjxxsj",
		1100
	},
	com_ssjy_txjx_ios_yidun_newyd = {
		"diamant_",
		1100
	},
	com_csls_chongsheng_ios_yidun_v4 = {
		"diamant_",
		1100
	},
	com_lhqsl_mos_ios_yidun_v4 = {
		"diamant_",
		1100
	},
	com_sszttt_qyy_ios_yidun_v4 = {
		"diamant_",
		1100
	},
	com_sssy_mwzl_ios_yidun_v4 = {
		"diamant_",
		1100
	},
	com_ylszz_yhzc_kssdk_ios_yidun_v4 = {
		"diamant_",
		1100
	},
	com_sszt_qy_kssdk_ios_yidun_v4 = {
		"diamant_",
		1100
	},
	com_yishi_qiyue_kssdk_ios_yidun_v4 = {
		"yishi.qiyue.",
		1100
	},
	com_huawei_scly_kssdk_ios_yidun_v4 = {
		"scly",
		1100
	},
	com_shenshou_yuangu_kssdk_ios_yidun_v4 = {
		"diamant_",
		1100
	},
	com_yibang_cmtf_kssdk_ios_yidun_v4 = {
		"cmtf",
		1100
	},
	com_shouc_wxzc_kssdk_ios_yidun_v4 = {
		"diamant_",
		1100
	},
	com_cqysj_yusanjia_kssdk_ios_yidun_v4 = {
		"diamant_",
		1100
	},
	com_mofalingchong_kssdk_ios_yidun_v4 = {
		"diamant_",
		1100
	},
	com_wuxianshalu_kssdk_ios_yidun_v4 = {
		"wuxianshalu.",
		1100
	},
	com_aifang_academy_kssdk_ios_yidun_v4 = {
		"Academy",
		1100
	},
	com_xinshidai_jiahe_kssdk_ios_yidun_v4 = {
		"com.jiahe.",
		1100
	},
	com_huiyilu_mhss_kssdk_ios_yidun_v4 = {
		"com.huiyilu.",
		1100
	},
	com_shen_long_kssdk_ios_yidun_v4 = {
		"shenlong",
		1100
	},
	com_ming_yun_kssdk_ios_yidun_v4 = {
		"diamant_",
		1100
	},
	com_shenshou_qiyuan_kssdk_ios_yidun_v4 = {
		"com.shenshouqy.",
		1100
	},
	com_xysc_cc_kssdk_ios_yidun_v4 = {
		"com.xysc.",
		1100
	},
	com_yushouu_jiyuann_kssdk_ios_yidun_v4 = {
		"com.yushouu.",
		1100
	},
	com_hlqy_xqzg_kssdk_ios_yidun_v4 = {
		"com.hlqy.xqzg.",
		1100
	},
	com_jlyx_cyhg_kssdk_ios_yidun_v4 = {
		"diamant_",
		1100
	},
	com_tian_tisj_kssdk_ios_yidun_v4 = {
		"com.ling.",
		1100
	},
	com_qishou_yongheng_kssdk_ios_yidun_v4 = {
		"com.qishou.",
		1100
	},
	com_xiang_su_kssdk_ios_yidun_v4 = {
		"com.jide.",
		1100
	},
	com_tjkoudai_tian_kssdk_ios_yidun_v4 = {
		"com.tjkoudai.tian.",
		1100
	},
	com_huaqi_yuan_kssdk_ios_yidun_v4 = {
		"com.hua.",
		1100
	},
	com_ssjx_sklh_kssdk_ios_yidun_v4 = {
		"com.ssjx.sklh.",
		1100
	},
	com_cscslm_chuanshuo_kssdk_ios_yidun_v4 = {
		"com.cscslm.chuanshuo.",
		1100
	}
}
local fixProductMap = {
	com_jlyx_cyhg_kssdk_ios_yidun_v4 = {
		diamant_3 = "com.lingshou.3",
		diamant_9 = "bzxjlztbo.124",
		diamant_2 = "com.lingshou.2",
		diamant_10 = "com.lingshou.10",
		diamant_1 = "bzxjlztbo.120",
		diamant_11 = "bzxjlztbo.125",
		diamant_8 = "bzxjlztbo.123",
		diamant_12 = "bzxjlztbo.126",
		diamant_7 = "com.lingshou.7",
		diamant_13 = "bzxjlztbo.127",
		diamant_6 = "com.lingshou.6",
		diamant_5 = "bzxjlztbo.121",
		diamant_4 = "com.lingshou.4"
	},
	com_ming_yun_kssdk_ios_yidun_v4 = {
		diamant_3 = "mydj.200",
		diamant_9 = "mydj.1340",
		diamant_2 = "mydj.140",
		diamant_10 = "mydj.1740",
		diamant_1 = "mydj.66",
		diamant_11 = "mydj.1980",
		diamant_8 = "mydj.980",
		diamant_12 = "mydj.3380",
		diamant_7 = "mydj.860",
		diamant_13 = "mydj.6580",
		diamant_6 = "mydj.580",
		diamant_5 = "mydj.340",
		diamant_4 = "mydj.260"
	},
	com_cqysj_yusanjia_kssdk_ios_yidun_v4 = {
		diamant_3 = "yusanjia.299",
		diamant_9 = "yusanjia.1999",
		diamant_2 = "yusanjia.199",
		diamant_10 = "yusanjia.2599",
		diamant_1 = "yusanjia.99",
		diamant_11 = "yusanjia.2999",
		diamant_8 = "yusanjia.1499",
		diamant_12 = "yusanjia.4999",
		diamant_7 = "yusanjia.1299",
		diamant_13 = "yusanjia.9999",
		diamant_6 = "yusanjia.899",
		diamant_5 = "yusanjia.499",
		diamant_4 = "yusanjia.399"
	},
	com_chijings_ios = {
		diamant_3 = "diamant18",
		diamant_9 = "diamant128",
		diamant_2 = "diamant12",
		diamant_10 = "diamant168",
		diamant_1 = "diamant6",
		diamant_11 = "diamant198",
		diamant_8 = "diamant98",
		diamant_12 = "diamant328",
		diamant_7 = "diamant88",
		diamant_13 = "diamant648",
		diamant_6 = "diamant68",
		diamant_5 = "diamant30",
		diamant_4 = "diamant28"
	},
	com_gwgjj_ios = {
		diamant_3 = "com.gwgjj.ios.13",
		diamant_9 = "com.gwgjj.ios.8",
		diamant_2 = "com.gwgjj.ios.2",
		diamant_10 = "com.gwgjj.ios.9",
		diamant_1 = "com.gwgjj.ios.1",
		diamant_11 = "com.gwgjj.ios.10",
		diamant_8 = "com.gwgjj.ios.7",
		diamant_12 = "com.gwgjj.ios.11",
		diamant_7 = "com.gwgjj.ios.14",
		diamant_13 = "com.gwgjj.ios.12",
		diamant_6 = "com.gwgjj.ios.5",
		diamant_5 = "com.gwgjj.ios.4",
		diamant_4 = "com.gwgjj.ios.3"
	},
	com_shenniaocs_ios_yidun = {
		diamant_3 = "com.shenniaocs.ios15",
		diamant_9 = "com.shenniaocs.ios8",
		diamant_2 = "com.shenniaocs.ios2",
		diamant_10 = "com.shenniaocs.ios9",
		diamant_1 = "com.shenniaocs.ios1",
		diamant_11 = "com.shenniaocs.ios10",
		diamant_8 = "com.shenniaocs.ios7",
		diamant_12 = "com.shenniaocs.ios11",
		diamant_7 = "com.shenniaocs.ios16",
		diamant_13 = "com.shenniaocs.ios12",
		diamant_6 = "com.shenniaocs.ios5",
		diamant_5 = "com.shenniaocs.ios4",
		diamant_4 = "com.shenniaocs.ios3"
	},
	com_skzl_ios = {
		diamant_3 = "com.skzl.180",
		diamant_9 = "com.skzl.1280",
		diamant_2 = "com.skzl.120",
		diamant_10 = "com.skzl.1680",
		diamant_1 = "com.skzl.6",
		diamant_11 = "com.skzl.1980",
		diamant_8 = "com.skzl.980",
		diamant_12 = "com.skzl.3280",
		diamant_7 = "com.skzl.680",
		diamant_13 = "com.skzl.6480",
		diamant_6 = "com.skzl.600",
		diamant_5 = "com.skzl.300",
		diamant_4 = "com.skzl.250"
	},
	com_shenniaocs_ios_new_yidun = {
		diamant_3 = "com.shenniaocs.ios15",
		diamant_9 = "com.shenniaocs.ios8",
		diamant_2 = "com.shenniaocs.ios2",
		diamant_10 = "com.shenniaocs.ios9",
		diamant_1 = "com.shenniaocs.ios1",
		diamant_11 = "com.shenniaocs.ios10",
		diamant_8 = "com.shenniaocs.ios7",
		diamant_12 = "com.shenniaocs.ios11",
		diamant_7 = "com.shenniaocs.ios16",
		diamant_13 = "com.shenniaocs.ios12",
		diamant_6 = "com.shenniaocs.ios5",
		diamant_5 = "com.shenniaocs.ios4",
		diamant_4 = "com.shenniaocs.ios3"
	},
	chongshou_ios_yidun = {
		diamant_3 = "chongshou.299",
		diamant_9 = "chongshou.1999",
		diamant_2 = "chongshou.199",
		diamant_10 = "chongshou.2599",
		diamant_1 = "chongshou.99",
		diamant_11 = "chongshou.2999",
		diamant_8 = "chongshou.1499",
		diamant_12 = "chongshou.4999",
		diamant_7 = "chongshou.1299",
		diamant_13 = "chongshou.9999",
		diamant_6 = "chongshou.899",
		diamant_5 = "chongshou.499",
		diamant_4 = "chongshou.399"
	},
	com_skzl_ios_yidun = {
		diamant_3 = "com.skzl.180",
		diamant_9 = "com.skzl.1280",
		diamant_2 = "com.skzl.120",
		diamant_10 = "com.skzl.1680",
		diamant_1 = "com.skzl.6",
		diamant_11 = "com.skzl.1980",
		diamant_8 = "com.skzl.980",
		diamant_12 = "com.skzl.3280",
		diamant_7 = "com.skzl.680",
		diamant_13 = "com.skzl.6480",
		diamant_6 = "com.skzl.600",
		diamant_5 = "com.skzl.300",
		diamant_4 = "com.skzl.250"
	},
	lingch_ios_yidun = {
		diamant_3 = "lingch.299",
		diamant_9 = "lingch.1999",
		diamant_2 = "lingch.199",
		diamant_10 = "lingch.2599",
		diamant_1 = "lingch.99",
		diamant_11 = "lingch.2999",
		diamant_8 = "lingch.1499",
		diamant_12 = "lingch.4999",
		diamant_7 = "lingch.1299",
		diamant_13 = "lingch.9999",
		diamant_6 = "lingch.899",
		diamant_5 = "lingch.499",
		diamant_4 = "lingch.399"
	},
	com_ssjy_txjx_ios_yidun_newyd = {
		diamant_3 = "ssjy.txjx.299",
		diamant_9 = "ssjy.txjx.1999",
		diamant_2 = "ssjy.txjx.199",
		diamant_10 = "ssjy.txjx.2599",
		diamant_1 = "ssjy.txjx.99",
		diamant_11 = "ssjy.txjx.2999",
		diamant_8 = "ssjy.txjx.1499",
		diamant_12 = "ssjy.txjx.4999",
		diamant_7 = "ssjy.txjx.1299",
		diamant_13 = "ssjy.txjx.9999",
		diamant_6 = "ssjy.txjx.899",
		diamant_5 = "ssjy.txjx.499",
		diamant_4 = "ssjy.txjx.399"
	},
	com_csls_chongsheng_ios_yidun_v4 = {
		diamant_3 = "com.csls.299",
		diamant_9 = "com.csls.1999",
		diamant_2 = "com.csls.199",
		diamant_10 = "com.csls.2599",
		diamant_1 = "com.csls.99",
		diamant_11 = "com.csls.2999",
		diamant_8 = "com.csls.1499",
		diamant_12 = "com.csls.4999",
		diamant_7 = "com.csls.1299",
		diamant_13 = "com.csls.9999",
		diamant_6 = "com.csls.899",
		diamant_5 = "com.csls.499",
		diamant_4 = "com.csls.399"
	},
	com_lhqsl_mos_ios_yidun_v4 = {
		diamant_3 = "Singhhhh.299",
		diamant_9 = "Singhhhh.1999",
		diamant_2 = "Singhhhh.199",
		diamant_10 = "Singhhhh.2599",
		diamant_1 = "Singh.99",
		diamant_11 = "Singh.2999",
		diamant_8 = "Singhhhh.1499",
		diamant_12 = "Singhhhh.4999",
		diamant_7 = "Singh.1299",
		diamant_13 = "Singhhhh.9999",
		diamant_6 = "Singhhhh.899",
		diamant_5 = "Singh.499",
		diamant_4 = "Singhhhh.399"
	},
	com_sszttt_qyy_ios_yidun_v4 = {
		diamant_3 = "ssztt.299",
		diamant_9 = "ssztt.1999",
		diamant_2 = "ssztt.199",
		diamant_10 = "ssztt.2599",
		diamant_1 = "ssztt.99",
		diamant_11 = "ssztt.2999",
		diamant_8 = "ssztt.1499",
		diamant_12 = "ssztt.4999",
		diamant_7 = "ssztt.1299",
		diamant_13 = "ssztt.9999",
		diamant_6 = "ssztt.899",
		diamant_5 = "ssztt.499",
		diamant_4 = "ssztt.399"
	},
	com_sssy_mwzl_ios_yidun_v4 = {
		diamant_3 = "sssy.299",
		diamant_9 = "sssy.1999",
		diamant_2 = "sssy.199",
		diamant_10 = "sssy.2599",
		diamant_1 = "sssy.99",
		diamant_11 = "sssy.2999",
		diamant_8 = "sssy.1499",
		diamant_12 = "sssy.4999",
		diamant_7 = "sssy.1299",
		diamant_13 = "sssy.9999",
		diamant_6 = "sssy.899",
		diamant_5 = "sssy.499",
		diamant_4 = "sssy.399"
	},
	com_ylszz_yhzc_kssdk_ios_yidun_v4 = {
		diamant_3 = "yaol.299",
		diamant_9 = "yaol.1999",
		diamant_2 = "yaol.199",
		diamant_10 = "yaol.2599",
		diamant_1 = "yaol.99",
		diamant_11 = "yaol.2999",
		diamant_8 = "yaol.1499",
		diamant_12 = "yaol.4999",
		diamant_7 = "yaol.1299",
		diamant_13 = "yaol.9999",
		diamant_6 = "yaol.899",
		diamant_5 = "yaol.499",
		diamant_4 = "yaol.399"
	},
	com_sszt_qy_kssdk_ios_yidun_v4 = {
		diamant_3 = "sszt.299",
		diamant_9 = "sszt.1999",
		diamant_2 = "sszt.199",
		diamant_10 = "sszt.2599",
		diamant_1 = "sszt.99",
		diamant_11 = "sszt.2999",
		diamant_8 = "sszt.1499",
		diamant_12 = "sszt.4999",
		diamant_7 = "sszt.1299",
		diamant_13 = "sszt.9999",
		diamant_6 = "sszt.899",
		diamant_5 = "sszt.499",
		diamant_4 = "sszt.399"
	},
	com_shenshou_yuangu_kssdk_ios_yidun_v4 = {
		diamant_3 = "yuangu.299",
		diamant_9 = "yuangu.1999",
		diamant_2 = "yuangu.199",
		diamant_10 = "yuangu.2599",
		diamant_1 = "yuangu.99",
		diamant_11 = "yuangu.2999",
		diamant_8 = "yuangu.1499",
		diamant_12 = "yuangu.4999",
		diamant_7 = "yuangu.1299",
		diamant_13 = "yuangu.9999",
		diamant_6 = "yuangu.899",
		diamant_5 = "yuangu.499",
		diamant_4 = "yuangu.399"
	},
	com_shouc_wxzc_kssdk_ios_yidun_v4 = {
		diamant_3 = "shouc.299",
		diamant_9 = "shouc.1999",
		diamant_2 = "shouc.199",
		diamant_10 = "shouc.2599",
		diamant_1 = "shouc.99",
		diamant_11 = "shouc.2999",
		diamant_8 = "shouc.1499",
		diamant_12 = "shouc.4999",
		diamant_7 = "shouc.1299",
		diamant_13 = "shouc.9999",
		diamant_6 = "shouc.899",
		diamant_5 = "shouc.499",
		diamant_4 = "shouc.399"
	},
	com_mofalingchong_kssdk_ios_yidun_v4 = {
		diamant_3 = "com.mofa.299",
		diamant_9 = "com.mofa.7",
		diamant_2 = "com.mofa.2",
		diamant_10 = "com.mofa.8",
		diamant_1 = "com.mofa.1",
		diamant_11 = "com.mofa.9",
		diamant_8 = "com.mofa.6",
		diamant_12 = "com.mofa.10",
		diamant_7 = "com.mofa.5",
		diamant_13 = "com.mofa.11",
		diamant_6 = "com.mofa.4",
		diamant_5 = "com.mofa.3",
		diamant_4 = "com.mofa.399"
	}
}

function ks.pay(cpOrderId, extInfo, amount, rechargeId, productDesc, cb)
	print("Lua ks.pay")

	local roleInfo = gGameModel.role
	local productID
	local prefix, startID = unpack(productPrefixTagMap[APP_TAG] or defaultPrefix)

	if rechargeId >= 1100 then
		productID = prefix .. rechargeId - startID
	elseif rechargeId >= 108 then
		productID = prefix .. rechargeId - 100
	elseif rechargeId > 100 then
		productID = prefix .. rechargeId - 101
	else
		productID = prefix .. rechargeId * 2 + 3
	end

	if fixProductMap[APP_TAG] ~= nil then
		local productMap = fixProductMap[APP_TAG]

		productID = productMap[productID]
	end

	local payInfo = csv.recharges[rechargeId]
	local productType

	productType = rechargeId >= 1101 and rechargeId <= 1113 and 1 or 2

	local roleName = roleInfo:read("name")

	roleName = string.gsub(roleName, "%s+", "")

	local tmp = {
		currency = "cny",
		count = 1,
		roleId = stringz.bintohex(roleInfo:read("id")),
		roleName = roleName,
		roleLevel = tostring(roleInfo:read("level")),
		area = gGameApp.serverInfo.name,
		area_id = tostring(roleInfo:read("area")),
		rmbDisplay = payInfo.rmbDisplay,
		rmb = amount,
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

function sdk.launchUnityGame(cb)
	print("lua ks_i.launchUnityGame")
	sdk.callPlatformFunc("launchUnityGame", json.encode(tmp), function(info)
		print("launchUnityGame ret = ", info)

		if info == "ok" then
			cb(0, info)
		else
			cb(-1, "error")
		end
	end)
end

return ks
