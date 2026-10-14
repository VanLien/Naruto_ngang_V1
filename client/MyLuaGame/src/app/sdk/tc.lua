-- chunkname: @src.app.sdk.tc

local none = require("app.sdk.none")
local tc = {}

function tc.login(cb)
	sdk.callPlatformFunc("login", "", function(info)
		print("login ret = ", info)

		sdk.loginInfo = info

		if info == "error" then
			cb(-1, info)
		elseif info == "cancel" then
			cb(-1, info)
		else
			cb(0, info)
			sdk.callPlatformFunc("logout", "assist", function(info)
				print("logout in assist ret = ", info)

				if info == "ok" then
					gGameApp:onBackLogin()
				end
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

function tc.commitRoleInfo(ctype, cb)
	local tmp = {
		roleType = "0",
		ctype = ctype,
		area = gGameApp.serverInfo.name,
		level = tostring(gGameModel.role:read("level")),
		area_id = tostring(gGameModel.role:read("area")),
		user_name = gGameModel.role:read("name"),
		user_id = tostring(gGameModel.role:read("uid")),
		vip = tostring(gGameModel.role:read("vip_level")),
		created_time = tostring(gGameModel.role:read("created_time")),
		upload_type = roleInfoMap[ctype],
		powerNum = gGameModel.role:read("top6_fighting_point"),
		partyName = gGameModel.union:read("name") or "",
		gameMoney = gGameModel.role:read("gold")
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

function tc.trackEvent(ctype, data)
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

function tc.logout(cb)
	sdk.callPlatformFunc("logout", "game", function(info)
		print("logout ret = ", info)
		cb(0, "ok")
	end)
end

function tc.accountCenter(cb)
	sdk.callPlatformFunc("accountCenter", "sdk", function(info)
		print("accountCenter ret = ", info)
		cb(0, "ok")
	end)
end

local defaultPrefix = {
	"com.mccjh.mccjh.",
	3
}
local productPrefixTagMap = {
	com_mccjh_mccjh_1 = defaultPrefix,
	com_meng_jingying_1 = {
		"com.meng.jingying.",
		1
	},
	com_meng_chongjy_1 = {
		"com.meng.chongjy.",
		1
	},
	com_yg_xsd_spass = {
		"com.yg.xsd.spass.",
		1
	},
	com_lzl_jxjjb = {
		"com.lzl.jxjjb.",
		1
	},
	com_kkdd_mmxx = {
		"com.kkdd.mmxx.",
		1
	},
	com_xiaoyg_damx = {
		"com.xiaoyg.damx.",
		1
	},
	com_zdzdba_yaoguai = {
		"com.zdzdba.yaoguai.",
		1
	},
	com_gfrgfh_ygjh = {
		"com.gfrgfh.ygjh.",
		1
	},
	com_jlcsd_jlcsd = {
		"com.jlcsd.jlcsd.",
		1
	},
	com_yishan_ysysljj = {
		"com.yishan.ysysljj.",
		1
	},
	com_wdhbb_wdhbb = {
		"com.wdhbb.wdhbb.",
		1
	},
	com_kdygdj_kdygdj = {
		"com.kdygdj.kdygdj.",
		1
	},
	com_chaojh_chaojh = {
		"com.chaojh.chaojh.",
		1
	},
	com_kdsqmc_kdsqmc = {
		"com.kdsqmc.kdsqmc.",
		1
	},
	com_mengjldz_mengjldz = {
		"com.mengjldz.mengjldz.",
		1
	},
	com_sqkdjl_sqkdjl = {
		"com.sqkdjl.sqkdjl.",
		1
	},
	com_qgka_mcjl = {
		"com.qgka.mcjl.",
		1
	},
	com_jlzhs_jlzhs = {
		"com.jlzhs.jlzhs.",
		1
	},
	com_koudaiwp_koudaiwp = {
		"com.koudaiwp.koudaiwp.",
		1
	},
	com_jldmx_jldmx = {
		"com.jldmx.jldmx.",
		1
	},
	com_kdmcqy_kdmcqy = {
		"com.kdmcqy.kdmcqy.",
		1
	},
	com_shenqimc_shenqimc = {
		"com.shenqimc.shenqimc.",
		1
	},
	com_mengcjljh_mengcjljh = {
		"com.mengcjljh.mengcjljh.",
		1
	},
	com_sqdmcm_sqdmcm = {
		"com.sqdmcm.sqdmcm.",
		1
	},
	com_mmdcw_mmdcw = {
		"com.mmdcw.mmdcw.",
		1
	},
	com_sqkdmc_sqkdmc = {
		"com.sqkdmc.sqkdmc.",
		1
	},
	com_wdhbb_wdhbb_new = {
		"com.wdhbb.wdhbb.",
		1
	},
	com_mcwy_mcwy = {
		"com.mcwy.mcwy.",
		1
	},
	com_mcqiyue_mcqiyue = {
		"com.mcqiyue.mcqiyue.",
		1
	},
	com_sqmc_duijue = {
		"com.sqmc.duijue.",
		1
	},
	com_kdmc_dalu = {
		"com.kdmc.dalu.",
		1
	},
	com_sqjljh_sqjljh = {
		"com.sqjljh.sqjljh.",
		1
	},
	com_kdmcdmx_kdmcdmx = {
		"com.kdmcdmx.kdmcdmx.",
		1
	},
	com_kdmcxls_kdmcxls = {
		"com.kdmcxls.kdmcxls.",
		1
	},
	com_mengchongxsd_mengchongxsd = {
		"com.mengchongxsd.mengchongxsd.",
		1
	},
	com_shenqijljh_shenqijljh = {
		"com.shenqijljh.shenqijljh.",
		1
	},
	com_mcxdl_mcxdl = {
		"com.mcxdl.mcxdl.",
		1
	},
	com_sqjljuexing_sqjljuexing = {
		"com.sqjljuexing.sqjljuexing.",
		1
	},
	com_shenqimc_mcsqmx = {
		"com.shenqimc.mcsqmx.",
		1
	},
	com_xunliankd_kdxlj = {
		"com.xunliankd.kdxlj.",
		1
	},
	com_kdbaby_kdbblm = {
		"com.kdbaby.kdbblm.",
		1
	},
	com_jingjingqy_jingjingqy = {
		"com.jingjingqy.jingjingqy.",
		1
	},
	com_shenchong_xunlianshi = {
		"com.shenchong.xunlianshi.",
		1
	},
	com_scqiyuan_kdscqy = {
		"com.scqiyuan.kdscqy.",
		1
	},
	com_mcdldou_mcdldou = {
		"com.mcdldou.mcdldou.",
		1
	},
	com_scxjyuan_scxjyuan = {
		"com.scxjyuan.scxjyuan.",
		1
	},
	com_dazuozhan_dazuozhan = {
		"com.dazuozhan.dazuozhan.",
		1
	},
	com_xinjiyuan_kdxjy = {
		"com.xinjiyuan.kdxjy.",
		1
	},
	com_kdxss_kdxss = {
		"com.kdxss.kdxss.",
		1
	},
	com_scdj_kdscdj = {
		"com.scdj.kdscdj.",
		1
	},
	com_kdbaob_jinhua = {
		"com.kdbaob.jinhua.",
		1
	},
	com_wdscbb_scqybb = {
		"com.wdscbb.scqybb.",
		1
	},
	com_newjiyuan_kdxjy = {
		"com.newjiyuan.kdxjy.",
		1
	},
	com_mengchongxsd_mengchongxsd_new = {
		"com.mengchongxsd.mengchongxsd.",
		1
	},
	com_ycgsb_ycgsb = {
		"com.ycgsb.ycgsb.",
		1
	},
	com_xlsdzc_xlsdzc = {
		"com.xlsdzc.xlsdzc.",
		1
	},
	com_zhsda_zhsda = {
		"com.zhsda.zhsda.",
		1
	},
	com_jhbjl_jhbjl = {
		"com.jhbjl.jhbjl.",
		1
	},
	com_sqxlj_sqxlj = {
		"com.sqxlj.sqxlj.",
		1
	},
	com_jljhfk_jljhfk = {
		"com.jljhfk.jljhfk.",
		1
	},
	com_sqjldj_sqjldj = {
		"com.sqjldj.sqjldj.",
		1
	},
	com_kdmxj_kdmxj = {
		"com.kdmxj.kdmxj.",
		1
	},
	com_sqjlqy_sqjlqy = {
		"com.sqjlqy.sqjlqy.",
		1
	},
	com_koudaixss_koudaixss = {
		"com.koudaixss.koudaixss.",
		1
	},
	com_jxbxjl_jxbxjl = {
		"com.jxbxjl.jxbxjl.",
		1
	},
	com_jlxjy_jlxjy_yidun = {
		"com.jlxjy.jlxjy.",
		1
	},
	com_xljmxzl_xljmxzl_yidun = {
		"com.xljmxzl.xljmxzl.",
		1
	},
	com_jlrydj_jlrydj_yidun = {
		"com.jlrydj.jlrydj.",
		1
	},
	com_kdsqmc_kdsqmc_yidun = {
		"com.kdsqmc.kdsqmc.",
		1
	},
	com_kdwangp_kdwangp_yidun = {
		"com.kdwangp.kdwangp.",
		1
	},
	com_baobei_plan_yidun = {
		"com.baobei.plan.",
		1
	},
	com_csdxlj_csdxlj_yidun = {
		"com.csdxlj.csdxlj.",
		1
	},
	com_rongydj_rongydj_yidun = {
		"com.rongydj.rongydj.",
		1
	},
	com_xssdmx_xssdmx_yidun = {
		"com.xssdmx.xssdmx.",
		1
	},
	com_sqbb_bbqy_yidun = {
		"com.sqbb.bbqy.",
		1
	},
	com_qiyue_mengjing_yidun = {
		"com.qiyue.mengjing.",
		1
	},
	com_shengbao_juelink_yidun = {
		"com.shengbao.juelink.",
		1
	},
	com_csdai_csdai_yidun = {
		"com.csdai.csdai.",
		1
	},
	com_dzzhan_dzzhan_yidun = {
		"com.dzzhan.dzzhan.",
		1
	},
	com_xlshi_xlshi_yidun = {
		"com.xlshi.xlshi.",
		1
	},
	com_bigmx_bigmx_yidun = {
		"com.bigmx.bigmx.",
		1
	},
	com_xjlsd_xjlsd_yidun = {
		"com.xjlsd.xjlsd.",
		1
	},
	com_magic_jinhua_yidun = {
		"com.magic.jinhua.",
		1
	},
	com_newdl_newdl_yidun = {
		"com.newdl.newdl.",
		1
	},
	com_kdmc_mcqy_yidun = {
		"com.kdmc.mcqy.",
		1
	},
	com_kdbaob_jinhua_yidun = {
		"com.kdbaob.jinhua.",
		1
	},
	com_kdmcxls_kdmcxls_yidun = {
		"com.kdmcxls.kdmcxls.",
		1
	},
	com_kdsq_sqmc2_yidun = {
		"com.kdsq.sqmc2.",
		1
	},
	com_zdba_yguai_yidun = {
		"com.zdba.yguai.",
		1
	},
	com_sqqiyuan_sqqiyuan_ios_yidun = {
		"com.sqqiyuan.sqqiyuan.",
		1
	},
	com_dianfeng_chongjue_yidun_v4 = {
		"com.dianfeng.chongjue.",
		1
	},
	com_mcxls_xlshi_yidun_v4 = {
		"com.mcxls.xlshi.",
		1
	},
	com_kdxls_kdxls_yidun_v4 = {
		"com.kdxls.kdxls.",
		1
	},
	com_meng_djue_ios_yidun_v4 = {
		"com.meng.djue.",
		1
	},
	com_kdmcjh_sqmcjh_ios_yidun_v4 = {
		"com.kdmcjh.sqmcjh.",
		1
	},
	com_evidence_mori_ios_yidun_v4 = {
		"com.evidence.mori.",
		1
	},
	com_cutegame_tumsprite_ios_yidun_v4 = {
		"com.cutegame.tumsprite.",
		1
	},
	cn_celve_zhandai_ios_yidun_v4 = {
		"cn.celve.zhandai.",
		1
	},
	chukai_wuling_cn_ios_yidun_v4 = {
		"chukai.wuling.cn.",
		1
	},
	com_zqawe_certjm_ios_yidun_v4 = {
		"com.zqawe.certjm.",
		1
	},
	com_yangdong_kdjx_ios_yidun_v4 = {
		"com.yangdong.kdjx.",
		1
	},
	com_qianzhi_jibo_ios_yidun_v4 = {
		"com.qianzhi.jibo.",
		1
	},
	com_mhqjs_cjyqw_ios_yidun_v4 = {
		"com.Qysqt.Zynuc.",
		1
	},
	com_kaixin_jingyi_ios_yidun_v4 = {
		"com.kaixin.jingyi.",
		1
	},
	com_jiangdream_gemstone_ios_yidun_v4 = {
		"com.jiangdream.gemstone.",
		1
	},
	com_adventurezone_babylegend_ios_yidun_v4 = {
		"com.adventureZone.babyLegend.",
		1
	},
	com_leisong_qiankun_ios_yidun_v4 = {
		"com.leisong.qiankun.",
		1
	},
	com_yiding_spritehelp_ios_yidun_v4 = {
		"com.yiding.spritehelp.",
		1
	},
	com_gamesprite_defenseattack_ios_yidun_v4 = {
		"com.gamesprite.defenseattack.",
		1
	},
	com_jingque_yuanxian_ios_yidun_v4 = {
		"com.jingque.yuanxian.",
		1
	},
	com_sprite_rawfighting_ios_yidun_v4 = {
		"com.sprite.rawfighting.",
		1
	},
	com_alliance_spritepet_ios_yidun_v4 = {
		"com.alliance.spritepet.",
		1
	},
	com_jljjh_jljjh_ios_yidun_v4 = {
		"com.gaofei.jiehao.",
		1
	},
	com_jljjh_jljjh_tc_ios_yidun_v4 = {
		"com.qs.jimi.",
		1
	},
	com_evolution_fantasy_ios_yidun_v4 = {
		"com.evolution.fantasy.",
		1
	},
	com_greenclound_fightkucchi_ios_yidun_v4 = {
		"com.greenClound.fightKucchi.",
		1
	}
}
local specialProductTagMap = {
	com_kdbaob_jinhua_yidun = "com.kdbaob.jinhua.",
	com_kdsqmc_kdsqmc_yidun = "com.kdsqmc.kdsqmc.",
	com_kdmc_mcqy_yidun = "com.kdmc.mcqy.",
	com_kdmcqy_kdmcqy = "com.kdmcqy.kdmcqy.",
	com_newdl_newdl_yidun = "com.newdl.newdl.",
	com_kdmcxls_kdmcxls_yidun = "com.kdmcxls.kdmcxls.",
	com_magic_jinhua_yidun = "com.magic.jinhua.",
	com_mcxls_xlshi_yidun_v4 = "com.mcxls.xlshi.",
	com_xjlsd_xjlsd_yidun = "com.xjlsd.xjlsd.",
	com_kdxls_kdxls_yidun_v4 = "com.kdxls.kdxls.",
	com_bigmx_bigmx_yidun = "com.bigmx.bigmx.",
	com_meng_djue_ios_yidun_v4 = "com.meng.djue.",
	com_xlshi_xlshi_yidun = "com.xlshi.xlshi.",
	com_sqkdjl_sqkdjl = "com.sqkdjl.sqkdjl.",
	com_kdmcjh_sqmcjh_ios_yidun_v4 = "com.kdmcjh.sqmcjh.",
	com_evidence_mori_ios_yidun_v4 = "com.evidence.mori.",
	com_cutegame_tumsprite_ios_yidun_v4 = "com.cutegame.tumsprite.",
	com_kdsqmc_kdsqmc = "com.kdsqmc.kdsqmc.",
	com_dzzhan_dzzhan_yidun = "com.dzzhan.dzzhan.",
	cn_celve_zhandai_ios_yidun_v4 = "cn.celve.zhandai.",
	com_csdai_csdai_yidun = "com.csdai.csdai.",
	com_kdygdj_kdygdj = "com.kdygdj.kdygdj.",
	com_shengbao_juelink_yidun = "com.shengbao.juelink.",
	com_wdhbb_wdhbb = "com.wdhbb.wdhbb.",
	com_qiyue_mengjing_yidun = "com.qiyue.mengjing.",
	chukai_wuling_cn_ios_yidun_v4 = "chukai.wuling.cn.",
	com_sqbb_bbqy_yidun = "com.sqbb.bbqy.",
	com_jlcsd_jlcsd = "com.jlcsd.jlcsd.",
	com_xssdmx_xssdmx_yidun = "com.xssdmx.xssdmx.",
	com_gfrgfh_ygjh = "com.gfrgfh.ygjh.",
	com_rongydj_rongydj_yidun = "com.rongydj.rongydj.",
	com_zdzdba_yaoguai = "com.zdzdba.yaoguai.",
	com_csdxlj_csdxlj_yidun = "com.csdxlj.csdxlj.",
	com_xiaoyg_damx = "com.xiaoyg.damx.",
	com_baobei_plan_yidun = "com.baobei.plan.",
	com_kkdd_mmxx = "com.kkdd.mmxx.",
	com_kdwangp_kdwangp_yidun = "com.kdwangp.kdwangp.",
	com_lzl_jxjjb = "com.lzl.jxjjb.",
	com_zqawe_certjm_ios_yidun_v4 = "com.zqawe.certjm.",
	com_jlrydj_jlrydj_yidun = "com.jlrydj.jlrydj.",
	com_yangdong_kdjx_ios_yidun_v4 = "com.yangdong.kdjx.",
	com_xljmxzl_xljmxzl_yidun = "com.xljmxzl.xljmxzl.",
	com_qianzhi_jibo_ios_yidun_v4 = "com.qianzhi.jibo.",
	com_jlxjy_jlxjy_yidun = "com.jlxjy.jlxjy.",
	com_mhqjs_cjyqw_ios_yidun_v4 = "com.Qysqt.Zynuc.",
	com_jxbxjl_jxbxjl = "com.jxbxjl.jxbxjl.",
	com_kaixin_jingyi_ios_yidun_v4 = "com.kaixin.jingyi.",
	com_koudaixss_koudaixss = "com.koudaixss.koudaixss.",
	com_jiangdream_gemstone_ios_yidun_v4 = "com.jiangdream.gemstone.",
	com_sqjlqy_sqjlqy = "com.sqjlqy.sqjlqy.",
	com_adventurezone_babylegend_ios_yidun_v4 = "com.adventureZone.babyLegend.",
	com_kdmxj_kdmxj = "com.kdmxj.kdmxj.",
	com_leisong_qiankun_ios_yidun_v4 = "com.leisong.qiankun.",
	com_sqjldj_sqjldj = "com.sqjldj.sqjldj.",
	com_yiding_spritehelp_ios_yidun_v4 = "com.yiding.spritehelp.",
	com_jljhfk_jljhfk = "com.jljhfk.jljhfk.",
	com_gamesprite_defenseattack_ios_yidun_v4 = "com.gamesprite.defenseattack.",
	com_sqxlj_sqxlj = "com.sqxlj.sqxlj.",
	com_jingque_yuanxian_ios_yidun_v4 = "com.jingque.yuanxian.",
	com_jhbjl_jhbjl = "com.jhbjl.jhbjl.",
	com_sprite_rawfighting_ios_yidun_v4 = "com.sprite.rawfighting.",
	com_zhsda_zhsda = "com.zhsda.zhsda.",
	com_alliance_spritepet_ios_yidun_v4 = "com.alliance.spritepet.",
	com_xlsdzc_xlsdzc = "com.xlsdzc.xlsdzc.",
	com_jljjh_jljjh_ios_yidun_v4 = "com.gaofei.jiehao.",
	com_ycgsb_ycgsb = "com.ycgsb.ycgsb.",
	com_jljjh_jljjh_tc_ios_yidun_v4 = "com.qs.jimi.",
	com_evolution_fantasy_ios_yidun_v4 = "com.evolution.fantasy.",
	com_newjiyuan_kdxjy = "com.newjiyuan.kdxjy.",
	com_greenclound_fightkucchi_ios_yidun_v4 = "com.greenClound.fightKucchi.",
	com_wdscbb_scqybb = "com.wdscbb.scqybb.",
	com_kdbaob_jinhua = "com.kdbaob.jinhua.",
	com_scdj_kdscdj = "com.scdj.kdscdj.",
	com_kdxss_kdxss = "com.kdxss.kdxss.",
	com_xinjiyuan_kdxjy = "com.xinjiyuan.kdxjy.",
	com_dazuozhan_dazuozhan = "com.dazuozhan.dazuozhan.",
	com_scxjyuan_scxjyuan = "com.scxjyuan.scxjyuan.",
	com_mcdldou_mcdldou = "com.mcdldou.mcdldou.",
	com_scqiyuan_kdscqy = "com.scqiyuan.kdscqy.",
	com_shenchong_xunlianshi = "com.shenchong.xunlianshi.",
	com_jingjingqy_jingjingqy = "com.jingjingqy.jingjingqy.",
	com_kdbaby_kdbblm = "com.kdbaby.kdbblm.",
	com_xunliankd_kdxlj = "com.xunliankd.kdxlj.",
	com_shenqimc_mcsqmx = "com.shenqimc.mcsqmx.",
	com_sqjljuexing_sqjljuexing = "com.sqjljuexing.sqjljuexing.",
	com_mcxdl_mcxdl = "com.mcxdl.mcxdl.",
	com_shenqijljh_shenqijljh = "com.shenqijljh.shenqijljh.",
	com_mengchongxsd_mengchongxsd = "com.mengchongxsd.mengchongxsd.",
	com_kdmcxls_kdmcxls = "com.kdmcxls.kdmcxls.",
	com_kdmcdmx_kdmcdmx = "com.kdmcdmx.kdmcdmx.",
	com_sqjljh_sqjljh = "com.sqjljh.sqjljh.",
	com_kdmc_dalu = "com.kdmc.dalu.",
	com_sqmc_duijue = "com.sqmc.duijue.",
	com_mcqiyue_mcqiyue = "com.mcqiyue.mcqiyue.",
	com_mcwy_mcwy = "com.mcwy.mcwy.",
	com_wdhbb_wdhbb_new = "com.wdhbb.wdhbb.",
	com_dianfeng_chongjue_yidun_v4 = "com.dianfeng.chongjue.",
	com_sqkdmc_sqkdmc = "com.sqkdmc.sqkdmc.",
	com_mmdcw_mmdcw = "com.mmdcw.mmdcw.",
	com_sqdmcm_sqdmcm = "com.sqdmcm.sqdmcm.",
	com_mengcjljh_mengcjljh = "com.mengcjljh.mengcjljh."
}

local function specialProductID(rechargeId)
	local specialPrefix = specialProductTagMap[APP_TAG]

	if specialPrefix == nil then
		return
	end

	local special = {
		specialPrefix .. "2",
		specialPrefix .. "12",
		[102] = specialPrefix .. "1",
		[106] = specialPrefix .. "2",
		[107] = specialPrefix .. "3",
		[108] = specialPrefix .. "4",
		[111] = specialPrefix .. "5",
		[112] = specialPrefix .. "6",
		[113] = specialPrefix .. "7",
		[101] = specialPrefix .. "101",
		[103] = specialPrefix .. "103",
		[104] = specialPrefix .. "104",
		[105] = specialPrefix .. "105",
		[109] = specialPrefix .. "109",
		[110] = specialPrefix .. "110"
	}

	return special[rechargeId]
end

local tcHuweiProductTagMap = {
	[1] = 10001,
	[2] = 10003
}
local targetPlatform = cc.Application:getInstance():getTargetPlatform()

if cc.PLATFORM_OS_OHOS == targetPlatform then
	tcHuweiProductTagMap[2] = 10004
end

function tc.pay(cpOrderId, extInfo, amount, rechargeId, productDesc, cb, params)
	if sdk.loginInfo then
		local t = json.decode(sdk.loginInfo)

		if t and t.channelId == "21" then
			cb(-1, "error")
			gGameUI:showDialog({
				isRich = true,
				strs = "#C0x5B545B#支付已关闭，请下载新的客户端，咨询请联系客服QQ：3008086559\n#C0x45B1FF##L10100##LULhttps://game-union.cdn.bcebos.com/apk/202412/com.happytoo.kdjx.g.baidu_v3.1.0.111168_60018.apk#【新包链接】#L0##C0x5B545B#",
				dialogParams = {
					clickClose = false
				}
			})

			return
		end
	end

	if string.find(APP_TAG, "^tiyan_test") or string.find(APP_TAG, "tiyan_") then
		cb(-1, "error")

		return
	end

	params = params or {}

	local function callFunc()
		local prefix, startID = unpack(productPrefixTagMap[APP_TAG] or defaultPrefix)
		local productID = specialProductID(rechargeId)
		local rechargeCfg = csv.recharges[rechargeId]
		local productType = 0

		if sdk.supportSubscribe and params.subscribe and tcHuweiProductTagMap[rechargeId] then
			productID = prefix .. tcHuweiProductTagMap[rechargeId]
			productType = 2
		end

		if productID == nil then
			if rechargeId >= 101 then
				productID = prefix .. rechargeId
			elseif rechargeId >= 3 then
				productID = prefix .. startID + 9 - rechargeId
			else
				productID = prefix .. rechargeId
			end
		end

		local desc = productDesc

		if specialProductTagMap[APP_TAG] ~= nil then
			desc = rechargeId >= 3 and rechargeId <= 10 and "gem" or "gift"
		end

		local roleInfo = gGameModel.role
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
			productDesc = desc,
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

	local num402 = gGameModel.role:read("items")[402] or 0

	if num402 > 0 and amount <= num402 then
		none.pay(cpOrderId, extInfo, amount, rechargeId, productDesc, cb, {
			use402 = true,
			errCb = callFunc
		})

		return
	end

	callFunc()
end

local SkipIdentityTag = {
	android_10054_20191230 = true,
	android_17849_20200218 = true,
	android_10054 = true
}

function tc.queryIdentity(cb, count)
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
				tc.queryIdentity(cb, count)
			end, 60)
		elseif age == "closed" then
			cb(nil)
		else
			cb(tonumber(age))
		end
	end)
end

function tc.queryUserType(cb, count)
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
				tc.queryUserType(cb, count)
			end, 60)
		elseif typ == "closed" then
			cb(nil)
		else
			cb(tonumber(typ))
		end
	end)
end

function tc.openCustomerService()
	sdk.callPlatformFunc("openCustomerService", "", function(info)
		print("openCustomerService ret = ", info)
	end)
end

function tc.openPrivacyProtocols()
	sdk.callPlatformFunc("openPrivacyProtocols", "", function(info)
		print("openPrivacyProtocols ret = ", info)
	end)
end

function tc.openPermissionSetting()
	sdk.callPlatformFunc("openPermissionSetting", "", function(info)
		print("openPermissionSetting ret = ", info)
	end)
end

function tc.isSupportSubscribe(cb)
	sdk.callPlatformFunc("isSupportSubscribe", "data", function(info)
		print("isSupportSubscribe ret = ", info)
		cb(tonumber(info))
	end)
end

function tc.isBuySubscribe(cb)
	sdk.callPlatformFunc("isBuySubscribe", "", function(info)
		print("isBuySubscribe ret = ", info)

		local t = json.decode(info)
		local prefix, startID = unpack(productPrefixTagMap[APP_TAG] or defaultPrefix)
		local ret = {}

		for _, v in ipairs(t) do
			for rechargeId, _ in pairs(tcHuweiProductTagMap) do
				local productID = prefix .. tcHuweiProductTagMap[rechargeId]

				if v.productID == productID then
					ret[rechargeId] = v
				end
			end
		end

		cb(ret)
	end)
end

function tc.getSDKChannel(cb)
	print("Lua tc.getChannel")
	sdk.callPlatformFunc("getSDKChannel", "", function(info)
		print("Lua tc.getChannel:" .. info)
		cb(info)
	end)
end

function tc.isShowUnBinding(cb)
	sdk.callPlatformFunc("isShowUnBinding", "", function(info)
		cb(info)
	end)
end

function tc.unBinding(cb)
	sdk.callPlatformFunc("unBinding", "", function(info)
		cb(info)
	end)
end

return tc
