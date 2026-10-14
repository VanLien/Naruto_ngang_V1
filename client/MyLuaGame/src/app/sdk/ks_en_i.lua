-- chunkname: @src.app.sdk.ks_en_i

local ks_en_i = {}

function ks_en_i.login(cb)
	print("Lua ks_en_i.login")
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

function ks_en_i.commitRoleInfo(ctype, cb)
	print("Lua ks_en_i.commitRoleInfo")

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
	pull_version_end = "cp_unzip_end",
	START_LOADING = "EVENTS_START_LOADING",
	FINISHED_LOADING = "cp_init_finish",
	pull_version_begin = "cp_unzip_start",
	CDN_FINISH = "cp_hotfix_end",
	START_CDN = "cp_hotfix_start"
}

function ks_en_i.trackEvent(ctype, data)
	print("Lua ks_en_i.trackEvent")

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

function ks_en_i.logout(cb)
	print("Lua ks_en_i.logout")
	sdk.callPlatformFunc("logout", "game", function(info)
		print("logout ret = ", info)
		cb(0, "ok")
	end)
end

local defaultPrefix = {
	"com.rise.ios.",
	2100
}
local productPrefixTagMap = {
	com_rise_ios = {
		"com.rise.ios.",
		2100
	},
	com_songs_fire = {
		"com.songs.fire.",
		2100
	},
	com_warmonster_ios = {
		"com.WarOfMonster.ios.",
		2100
	},
	com_adventureofelves_ios = {
		"com.AdventureofElves.ios.",
		2100
	},
	com_stranger_beasts = {
		"com.stranger.beasts.",
		2100
	},
	eas_qyhffx_new = {
		"eas.qyhffx.new.",
		2100
	},
	motb_sdfee_new = {
		"motb.sdfee.new.",
		2100
	},
	mega_ehue_ios = {
		"mega.ehue.ios.",
		2100
	},
	com_mythi_beasts = {
		"com.mythi.beasts.",
		2100
	},
	bos_battle_sprite = {
		"bos.battle.sprite.",
		2100
	},
	bc_chapter_old = {
		"bc.chapter.old.",
		2100
	},
	jc_qyhx_new = {
		"jc.qyhx.new.",
		2100
	},
	elas_assem_ios = {
		"elas.assem.ios.",
		2100
	},
	ios_cnysj_ios = {
		"ios.cnysj.ios.",
		2100
	},
	com_loe_ios = {
		"com.loe.ios.",
		2100
	},
	com_qlejd_oekkn = {
		"com.qlejd.oekkn.",
		2100
	},
	fall_bkb_ios = {
		"fall.bkb.ios",
		2100
	},
	com_oledw_ujecs = {
		"com.oledw.ujecs.",
		2100
	},
	com_elf_war = {
		"diamant_",
		2100
	},
	com_super_beast = {
		"com.super.beast.",
		2100
	},
	com_elflegiwar_ios = {
		"diamant_",
		2100
	},
	com_path_ios = {
		"com.Path.",
		2100
	},
	com_journey_ios = {
		"diamant_",
		2100
	},
	com_mystic_ios = {
		"com.mystic.",
		2100
	},
	com_mirelf_oekkn = {
		"com.mirelf.oekkn.",
		2100
	},
	com_clash_ios = {
		"com.Clash.",
		2100
	},
	com_battmast_advent = {
		"battmast",
		2100
	},
	com_battle_blaze_yidun = {
		"com.blaze.",
		2100
	},
	com_myc_cores_yidun = {
		"diamant_",
		2100
	},
	com_coeq_yidun = {
		"com.coeq.",
		2100
	},
	com_epw_petwar_yidun = {
		"epw.petwar.",
		2100
	},
	com_clash_ios_yidun = {
		"com.Clash.",
		2100
	},
	com_mythical_ios_yidun = {
		"com.Mythical.",
		2100
	},
	com_path_ios_yidun = {
		"com.Path.",
		2100
	},
	journey_com_ios_yidun = {
		"diamant_",
		2100
	},
	com_battmast_advent_ios_yidun = {
		"battmast",
		2100
	},
	com_loe_ios_yidun = {
		"com.qlejd.oekkn.",
		2100
	},
	evolut_ios_yidun = {
		"diamant_",
		2100
	},
	motb_sdfee_new_ios_yidun = {
		"motb.sdfee.new.",
		2100
	},
	com_gacha_ios_yidun = {
		"com.Gacha.",
		2100
	},
	com_mystic_ios_yidun = {
		"com.mystic.",
		2100
	},
	com_rise_ios_yidun = {
		"com.rise.ios.",
		2100
	},
	pettrain_ios_yidun = {
		"pettrain.",
		2100
	},
	rise_of_ios_yidun = {
		"diamant_",
		2100
	},
	arcane_ios_yidun = {
		"arcane",
		2100
	},
	com_sqxx_tej_ios_yidun = {
		"TEJ",
		2100
	},
	com_qiqiang_elemental_ios_yidun = {
		"Elemental",
		2100
	},
	com_changgeng_odyssey_ios_yidun = {
		"com.Odyssey.",
		2100
	},
	com_chaji_enchanted_ios_yidun = {
		"Enchanted",
		2100
	},
	com_xiaoying_realm_ios_yidun = {
		"Xiaoying.Realm",
		2100
	},
	com_evolutclash_ios_yidun = {
		"evolutclash.",
		2100
	},
	com_enchanted_epj_ios_yidun = {
		"diamant_",
		2100
	},
	com_xxpp_mythical_ios_yidun = {
		"diamant_",
		2100
	},
	com_megafighter_mfl_ios_yidun = {
		"megafi.",
		2100
	},
	com_feixiong_mr_ios_yidun_v4 = {
		"MRyst",
		2100
	},
	com_fulu_dream_ios_yidun_v4 = {
		"Dream",
		2100
	},
	com_quest_realm_kssdk_ios_yidun_v4 = {
		"diamant_",
		2100
	},
	com_jljh_jj_kssdk_ios_yidun_v4 = {
		"diamant_",
		2100
	},
	com_huihe_blitz_kssdk_ios_yidun_v4 = {
		"Huihe",
		2100
	},
	com_sup_sum_kssdk_ios_yidun_v4 = {
		"sup.sum.",
		2100
	},
	com_sped_elf_kssdk_ios_yidun_v4 = {
		"diamant_",
		2100
	},
	com_qingcheng_trek_kssdk_ios_yidun_v4 = {
		"Trek",
		2100
	},
	com_jour_champ_kssdk_ios_yidun_v4 = {
		"champ.",
		2100
	},
	com_mega_google_kssdk_ios_yidun_v4 = {
		"diamant_",
		2100
	},
	com_lanbowang_mysticmon_kssdk_ios_yidun_v4 = {
		"MysticMon",
		2100
	},
	com_legen_mc_kssdk_ios_yidun_v4 = {
		"Arena",
		2100
	},
	com_fet_flameelf_kssdk_ios_yidun_v4 = {
		"flameelf.",
		2100
	},
	com_oudisheng_gyms_kssdk_ios_yidun_v4 = {
		"Gyms",
		2100
	},
	com_evoquest_eqtr_kssdk_ios_yidun_v4 = {
		"diamant_",
		2100
	},
	com_mingwei_chaser_kssdk_ios_yidun_v4 = {
		"Chaser",
		2100
	},
	com_monstrun_cha_kssdk_ios_yidun_v4 = {
		"com.monstrun.",
		2100
	},
	com_ltqq_legendary_kssdk_ios_yidun_v4 = {
		"diamant_",
		2100
	},
	com_legenunite_kssdk_ios_yidun_v4 = {
		"legenunite.",
		2100
	},
	com_leg_qumyth_kssdk_ios_yidun_v4 = {
		"diamant_",
		2100
	},
	com_kelaien_evo_kssdk_ios_yidun_v4 = {
		"Tactics.",
		2100
	},
	com_mysti_creatu_kssdk_ios_yidun_v4 = {
		"diamant_",
		2100
	},
	com_yushen_tamer_kssdk_ios_yidun_v4 = {
		"Tamer.",
		2100
	},
	com_elmr_elemental_kssdk_ios_yidun_v4 = {
		"diamant_",
		2100
	},
	com_quet_questevo_kssdk_ios_yidun_v4 = {
		"diamant_",
		2100
	},
	com_tian_ying_kssdk_ios_yidun_v4 = {
		"diamant_",
		2100
	},
	com_pengyi_crush_kssdk_ios_yidun_v4 = {
		"Burst.",
		2100
	},
	com_zhidewei_fortress_kssdk_ios_yidun_v4 = {
		"Unveiled.",
		2100
	},
	com_weihao_turret_kssdk_ios_yidun_v4 = {
		"Turret.",
		2100
	},
	com_ggoollden_twwaarr_kssdk_ios_yidun_v4 = {
		"diamant_",
		2100
	},
	com_tianmon_nevercry_kssdk_ios_yidun_v4 = {
		"diamant_",
		2100
	},
	com_pirate_era_kssdk_ios_yidun_v4 = {
		"com.maec.",
		2100
	},
	com_wozh_sanq_kssdk_ios_yidun_v4 = {
		"com.lbub.",
		2100
	},
	com_pspe_prim_kssdk_ios_yidun_v4 = {
		"diamant_",
		2100
	},
	com_evolv_champ_kssdk_ios_yidun_v4 = {
		"diamant_",
		2100
	},
	com_tianji_elf_kssdk_ios_yidun_v4 = {
		"diamant_",
		2100
	},
	com_mrpe_monreal_kssdk_ios_yidun_v4 = {
		"com.mrpe.monreal.",
		2100
	},
	com_evoelites_eepm_kssdk_ios_yidun_v4 = {
		"diamant_",
		2100
	},
	com_meng_baoyou_kssdk_ios_yidun_v4 = {
		"com.ptme.",
		2100
	},
	com_evoelites_eepm132_kssdk_ios_yidun_v4 = {
		"com.evoelites.",
		2100
	}
}
local fixProductMap = {
	com_evoelites_eepm_kssdk_ios_yidun_v4 = {
		diamant_9 = "com.summonbat.sba_13",
		diamant_4 = "com.summonbat.sba_04",
		diamant_10 = "com.summonbat.sba_14",
		diamant_3 = "com.summonbat.sba_03",
		diamant_11 = "com.summonbat.sba_15",
		diamant_2 = "com.summonbat.sba_02",
		diamant_12 = "com.summonbat.sba_16",
		diamant_1 = "com.summonbat.sba_01",
		diamant_13 = "com.summonbat.sba_17",
		diamant_8 = "com.summonbat.sba_12",
		diamant_7 = "com.summonbat.sba_11",
		diamant_6 = "com.summonbat.sba_09",
		diamant_5 = "com.summonbat.sba_05"
	},
	com_tianji_elf_kssdk_ios_yidun_v4 = {
		diamant_9 = "com.aop.1999",
		diamant_4 = "com.aop.399",
		diamant_10 = "com.aop.2599",
		diamant_3 = "com.aop.299",
		diamant_11 = "com.aop.2999",
		diamant_2 = "com.aop.199",
		diamant_12 = "com.aop.4999",
		diamant_1 = "com.aop.99",
		diamant_13 = "com.aop.9999",
		diamant_8 = "com.aop.1499",
		diamant_7 = "com.aop.1299",
		diamant_6 = "com.aop.899",
		diamant_5 = "com.aop.499"
	},
	com_evolv_champ_kssdk_ios_yidun_v4 = {
		diamant_9 = "com.evolv.champ_13",
		diamant_4 = "com.evolv.champ_04",
		diamant_10 = "com.evolv.champ_14",
		diamant_3 = "com.evolv.champ_03",
		diamant_11 = "com.evolv.champ_15",
		diamant_2 = "com.evolv.champ_02",
		diamant_12 = "com.evolv.champ_16",
		diamant_1 = "com.evolv.champ_01",
		diamant_13 = "com.evolv.champ_17",
		diamant_8 = "com.evolv.champ_12",
		diamant_7 = "com.evolv.champ_11",
		diamant_6 = "com.evolv.champ_09",
		diamant_5 = "com.evolv.champ_05"
	},
	com_pspe_prim_kssdk_ios_yidun_v4 = {
		diamant_9 = "com.pspe.prim.1999",
		diamant_4 = "com.pspe.prim.399",
		diamant_10 = "com.pspe.prim.2599",
		diamant_3 = "com.pspe.prim.299",
		diamant_11 = "com.pspe.prim.2999",
		diamant_2 = "com.pspe.prim.199",
		diamant_12 = "com.pspe.prim.4999",
		diamant_1 = "com.pspe.prim.99",
		diamant_13 = "com.pspe.prim.9999",
		diamant_8 = "com.pspe.prim.1499",
		diamant_7 = "com.pspe.prim.1299",
		diamant_6 = "com.pspe.prim.899",
		diamant_5 = "com.pspe.prim.499"
	},
	com_tianmon_nevercry_kssdk_ios_yidun_v4 = {
		diamant_9 = "com.tianmon.1999",
		diamant_4 = "com.tianmon.399",
		diamant_10 = "com.tianmon.2599",
		diamant_3 = "com.tianmon.299",
		diamant_11 = "com.tianmon.2999",
		diamant_2 = "com.tianmon.199",
		diamant_12 = "com.tianmon.4999",
		diamant_1 = "com.tianmon.99",
		diamant_13 = "com.tianmon.9999",
		diamant_8 = "com.tianmon.1499",
		diamant_7 = "com.tianmon.1299",
		diamant_6 = "com.tianmon.899",
		diamant_5 = "com.tianmon.499"
	},
	com_ggoollden_twwaarr_kssdk_ios_yidun_v4 = {
		diamant_9 = "com.ggoollden.1999",
		diamant_4 = "com.ggoollden.399",
		diamant_10 = "com.ggoollden.2599",
		diamant_3 = "com.ggoollden.299",
		diamant_11 = "com.ggoollden.2999",
		diamant_2 = "com.ggoollden.199",
		diamant_12 = "com.ggoollden.4999",
		diamant_1 = "com.ggoollden.99",
		diamant_13 = "com.ggoollden.9999",
		diamant_8 = "com.ggoollden.1499",
		diamant_7 = "com.ggoollden.1299",
		diamant_6 = "com.ggoollden.899",
		diamant_5 = "com.ggoollden.499"
	},
	com_tian_ying_kssdk_ios_yidun_v4 = {
		diamant_9 = "com.tian.1999",
		diamant_4 = "com.tian.399",
		diamant_10 = "com.tian.2599",
		diamant_3 = "com.tian.299",
		diamant_11 = "com.tian.2999",
		diamant_2 = "com.tian.199",
		diamant_12 = "com.tian.4999",
		diamant_1 = "com.tian.99",
		diamant_13 = "com.tian.9999",
		diamant_8 = "com.tian.1499",
		diamant_7 = "com.tian.1299",
		diamant_6 = "com.tian.899",
		diamant_5 = "com.tian.499"
	},
	com_quet_questevo_kssdk_ios_yidun_v4 = {
		diamant_9 = "com.quet.1999",
		diamant_4 = "com.quet.399",
		diamant_10 = "com.quet.2599",
		diamant_3 = "com.quet.299",
		diamant_11 = "com.quet.2999",
		diamant_2 = "com.quet.199",
		diamant_12 = "com.quet.4999",
		diamant_1 = "com.quet.99",
		diamant_13 = "com.quet.9999",
		diamant_8 = "com.quet.1499",
		diamant_7 = "com.quet.1299",
		diamant_6 = "com.quet.899",
		diamant_5 = "com.quet.499"
	},
	com_elmr_elemental_kssdk_ios_yidun_v4 = {
		diamant_9 = "com.elmr.1999",
		diamant_4 = "com.elmr.399",
		diamant_10 = "com.elmr.2599",
		diamant_3 = "com.elmr.299",
		diamant_11 = "com.elmr.2999",
		diamant_2 = "com.elmr.199",
		diamant_12 = "com.elmr.4999",
		diamant_1 = "com.elmr.99",
		diamant_13 = "com.elmr.9999",
		diamant_8 = "com.elmr.1499",
		diamant_7 = "com.elmr.1299",
		diamant_6 = "com.elmr.899",
		diamant_5 = "com.elmr.499"
	},
	com_mysti_creatu_kssdk_ios_yidun_v4 = {
		diamant_9 = "com.mysti.1999",
		diamant_4 = "com.mysti.399",
		diamant_10 = "com.mysti.2599",
		diamant_3 = "com.mysti.299",
		diamant_11 = "com.mysti.2999",
		diamant_2 = "com.mysti.199",
		diamant_12 = "com.mysti.4999",
		diamant_1 = "com.mysti.99",
		diamant_13 = "com.mysti.9999",
		diamant_8 = "com.mysti.1499",
		diamant_7 = "com.mysti.1299",
		diamant_6 = "com.mysti.899",
		diamant_5 = "com.mysti.499"
	},
	com_leg_qumyth_kssdk_ios_yidun_v4 = {
		diamant_9 = "qumyth.1999",
		diamant_4 = "qumyth.399",
		diamant_10 = "qumyth.2599",
		diamant_3 = "qumyth.299",
		diamant_11 = "qumyth.2999",
		diamant_2 = "qumyth.199",
		diamant_12 = "qumyth.4999",
		diamant_1 = "qumyth.99",
		diamant_13 = "qumyth.9999",
		diamant_8 = "qumyth.1499",
		diamant_7 = "qumyth.1299",
		diamant_6 = "qumyth.899",
		diamant_5 = "qumyth.499"
	},
	com_ltqq_legendary_kssdk_ios_yidun_v4 = {
		diamant_9 = "com.ltqq.1999",
		diamant_4 = "com.ltqq.399",
		diamant_10 = "com.ltqq.2599",
		diamant_3 = "com.ltqq.299",
		diamant_11 = "com.ltqq.2999",
		diamant_2 = "com.ltqq.199",
		diamant_12 = "com.ltqq.4999",
		diamant_1 = "com.ltqq.99",
		diamant_13 = "com.ltqq.9999",
		diamant_8 = "com.ltqq.1499",
		diamant_7 = "com.ltqq.1299",
		diamant_6 = "com.ltqq.899",
		diamant_5 = "com.ltqq.499"
	},
	com_evoquest_eqtr_kssdk_ios_yidun_v4 = {
		diamant_9 = "com.evoquest.1999",
		diamant_4 = "com.evoquest.399",
		diamant_10 = "com.evoquest.2599",
		diamant_3 = "com.evoquest.299",
		diamant_11 = "com.evoquest.2999",
		diamant_2 = "com.evoquest.199",
		diamant_12 = "com.evoquest.4999",
		diamant_1 = "com.evoquest.99",
		diamant_13 = "com.evoquest.9999",
		diamant_8 = "com.evoquest.1499",
		diamant_7 = "com.evoquest.1299",
		diamant_6 = "com.evoquest.899",
		diamant_5 = "com.evoquest.499"
	},
	com_elf_war = {
		diamant_9 = "com.Elf.War.19.99",
		diamant_4 = "com.Elf.War.3.99",
		diamant_10 = "com.Elf.War.25.99",
		diamant_3 = "com.Elf.War.2.99",
		diamant_11 = "com.Elf.War.29.99",
		diamant_2 = "com.Elf.War.1.99",
		diamant_12 = "com.Elf.War.49.99",
		diamant_1 = "com.Elf.War.0.99",
		diamant_13 = "com.Elf.War.99.99",
		diamant_8 = "com.Elf.War.14.99",
		diamant_7 = "com.Elf.War.12.99",
		diamant_6 = "com.Elf.War.8.99",
		diamant_5 = "com.Elf.War.4.99"
	},
	com_elflegiwar_ios = {
		diamant_9 = "elflegiwar.19.99",
		diamant_4 = "elflegiwar.3.99",
		diamant_10 = "elflegiwar.25.99",
		diamant_3 = "elflegiwar.2.99",
		diamant_11 = "elflegiwar.29.99",
		diamant_2 = "elflegiwar.1.99",
		diamant_12 = "elflegiwar.49.99",
		diamant_1 = "elflegiwar.0.99",
		diamant_13 = "elflegiwar.99.99",
		diamant_8 = "elflegiwar.14.99",
		diamant_7 = "elflegiwar.12.99",
		diamant_6 = "elflegiwar.8.99",
		diamant_5 = "elflegiwar.4.99"
	},
	com_journey_ios = {
		diamant_9 = "journey.com.1999",
		diamant_4 = "journey.com.399",
		diamant_10 = "journey.com.2599",
		diamant_3 = "journey.com.299",
		diamant_11 = "journey.com.2999",
		diamant_2 = "journey.com.199",
		diamant_12 = "journey.com.4999",
		diamant_1 = "journey.com.99",
		diamant_13 = "journey.com.9999",
		diamant_8 = "journey.com.1499",
		diamant_7 = "journey.com.1299",
		diamant_6 = "journey.com.899",
		diamant_5 = "journey.com.499"
	},
	com_myc_cores_yidun = {
		diamant_9 = "cores.1999",
		diamant_4 = "cores.399",
		diamant_10 = "cores.2599",
		diamant_3 = "cores.299",
		diamant_11 = "cores.2999",
		diamant_2 = "cores.199",
		diamant_12 = "cores.4999",
		diamant_1 = "cores.99",
		diamant_13 = "cores.9999",
		diamant_8 = "cores.1499",
		diamant_7 = "cores.1299",
		diamant_6 = "cores.899",
		diamant_5 = "cores.499"
	},
	journey_com_ios_yidun = {
		diamant_9 = "journey.com.1999",
		diamant_4 = "journey.com.399",
		diamant_10 = "journey.com.2599",
		diamant_3 = "journey.com.299",
		diamant_11 = "journey.com.2999",
		diamant_2 = "journey.com.199",
		diamant_12 = "journey.com.4999",
		diamant_1 = "journey.com.99",
		diamant_13 = "journey.com.9999",
		diamant_8 = "journey.com.1499",
		diamant_7 = "journey.com.1299",
		diamant_6 = "journey.com.899",
		diamant_5 = "journey.com.499"
	},
	evolut_ios_yidun = {
		diamant_9 = "evolut.1999",
		diamant_4 = "evolut.399",
		diamant_10 = "evolut.2599",
		diamant_3 = "evolut.299",
		diamant_11 = "evolut.2999",
		diamant_2 = "evolut.199",
		diamant_12 = "evolut.4999",
		diamant_1 = "evolut.99",
		diamant_13 = "evolut.9999",
		diamant_8 = "evolut.1499",
		diamant_7 = "evolut.1299",
		diamant_6 = "evolut.899",
		diamant_5 = "evolut.499"
	},
	rise_of_ios_yidun = {
		diamant_9 = "rise.of.1999",
		diamant_4 = "rise.of.399",
		diamant_10 = "rise.of.2599",
		diamant_3 = "rise.of.299",
		diamant_11 = "rise.of.2999",
		diamant_2 = "rise.of.199",
		diamant_12 = "rise.of.4999",
		diamant_1 = "rise.of.99",
		diamant_13 = "rise.of.9999",
		diamant_8 = "rise.of.1499",
		diamant_7 = "rise.of.1299",
		diamant_6 = "rise.of.899",
		diamant_5 = "rise.of.499"
	},
	com_enchanted_epj_ios_yidun = {
		diamant_9 = "enchanted.1999",
		diamant_4 = "enchanted.399",
		diamant_10 = "enchanted.2599",
		diamant_3 = "enchanted.299",
		diamant_11 = "enchanted.2999",
		diamant_2 = "enchanted.199",
		diamant_12 = "enchanted.4999",
		diamant_1 = "enchanted.99",
		diamant_13 = "enchanted.9999",
		diamant_8 = "enchanted.1499",
		diamant_7 = "enchanted.1299",
		diamant_6 = "enchanted.899",
		diamant_5 = "enchanted.499"
	},
	com_xxpp_mythical_ios_yidun = {
		diamant_9 = "safari.1999",
		diamant_4 = "safari.399",
		diamant_10 = "safari.2599",
		diamant_3 = "safari.299",
		diamant_11 = "safari.2999",
		diamant_2 = "safari.199",
		diamant_12 = "safari.4999",
		diamant_1 = "safari.99",
		diamant_13 = "safari.9999",
		diamant_8 = "safari.1499",
		diamant_7 = "safari.1299",
		diamant_6 = "safari.899",
		diamant_5 = "safari.499"
	},
	com_quest_realm_kssdk_ios_yidun_v4 = {
		diamant_9 = "quest.1999",
		diamant_4 = "quest.399",
		diamant_10 = "quest.2599",
		diamant_3 = "quest.299",
		diamant_11 = "quest.2999",
		diamant_2 = "quest.199",
		diamant_12 = "quest.4999",
		diamant_1 = "quest.99",
		diamant_13 = "quest.9999",
		diamant_8 = "quest.1499",
		diamant_7 = "quest.1299",
		diamant_6 = "quest.899",
		diamant_5 = "quest.499"
	},
	com_jljh_jj_kssdk_ios_yidun_v4 = {
		diamant_9 = "tfs.1999",
		diamant_4 = "tfs.399",
		diamant_10 = "tfs.2599",
		diamant_3 = "tfs.299",
		diamant_11 = "tfs.2999",
		diamant_2 = "tfs.199",
		diamant_12 = "tfs.4999",
		diamant_1 = "tfs.99",
		diamant_13 = "tfs.9999",
		diamant_8 = "tfs.1499",
		diamant_7 = "tfs.1299",
		diamant_6 = "tfs.899",
		diamant_5 = "tfs.499"
	},
	com_sped_elf_kssdk_ios_yidun_v4 = {
		diamant_9 = "ssed.2999",
		diamant_4 = "ssed.399",
		diamant_10 = "ssed.2599",
		diamant_3 = "ssed.299",
		diamant_11 = "ssed.29999",
		diamant_2 = "ssed.199",
		diamant_12 = "ssed.4999",
		diamant_1 = "ssed.99",
		diamant_13 = "ssed.9999",
		diamant_8 = "ssed.1499",
		diamant_7 = "ssed.1299",
		diamant_6 = "ssed.899",
		diamant_5 = "ssed.499"
	},
	com_mega_google_kssdk_ios_yidun_v4 = {
		diamant_9 = "mega.1999",
		diamant_4 = "mega.399",
		diamant_10 = "mega.2599",
		diamant_3 = "mega.299",
		diamant_11 = "mega.2999",
		diamant_2 = "mega.199",
		diamant_12 = "mega.4999",
		diamant_1 = "mega.99",
		diamant_13 = "mega.9999",
		diamant_8 = "mega.1499",
		diamant_7 = "mega.1299",
		diamant_6 = "mega.899",
		diamant_5 = "mega.499"
	}
}
local ksAppleSubscribeProductMap = {
	com_mystic_ios = {
		[1] = "mystic.1",
		[2] = "mystic.4"
	},
	com_battmast_advent = {
		[1] = "battmast14",
		[2] = "battmast15"
	},
	com_battle_blaze_yidun = {
		[1] = "com.blaze.ios.1",
		[2] = "com.blaze.ios.22"
	},
	com_coeq_yidun = {
		[1] = "coeq.2",
		[2] = "coeq.22"
	},
	com_battmast_advent_ios_yidun = {
		[1] = "battmast14",
		[2] = "battmast15"
	},
	com_mystic_ios_yidun = {
		[1] = "mystic.1",
		[2] = "mystic.4"
	}
}

function ks_en_i.pay(cpOrderId, extInfo, amount, rechargeId, productDesc, cb, params)
	print("Lua ks_en_i.pay")

	local roleInfo = gGameModel.role
	local productID
	local prefix, startID = unpack(productPrefixTagMap[APP_TAG] or defaultPrefix)

	if rechargeId >= 2100 then
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

	local productType

	productType = rechargeId >= 2101 and rechargeId <= 2113 and 1 or 2
	params = params or {}

	local subscribeProductID = ksAppleSubscribeProductMap[APP_TAG]

	if sdk.supportSubscribe and params.subscribe and subscribeProductID[rechargeId] then
		productID = subscribeProductID[rechargeId]
	end

	local payInfo = csv.recharges[rechargeId]
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
	print("lua ks_en_i.launchUnityGame")
	sdk.callPlatformFunc("launchUnityGame", json.encode(tmp), function(info)
		print("launchUnityGame ret = ", info)

		if info == "ok" then
			cb(0, info)
		else
			cb(-1, "error")
		end
	end)
end

function ks_en_i.isSupportSubscribe(cb)
	sdk.callPlatformFunc("isSupportSubscribe", "data", function(info)
		print("isSupportSubscribe ret = ", info)
		cb(tonumber(info))
	end)
end

function ks_en_i.isBuySubscribe(cb)
	sdk.callPlatformFunc("isBuySubscribe", "", function(info)
		print("isBuySubscribe ret = ", info)

		local t = json.decode(info)
		local ret = {}
		local subscribeProductID = ksAppleSubscribeProductMap[APP_TAG]

		for _, v in ipairs(t) do
			for rechargeId, _ in pairs(subscribeProductID) do
				local productID = subscribeProductID[rechargeId]

				if v.productID == productID then
					ret[rechargeId] = v
				end
			end
		end

		cb(ret)
	end)
end

return ks_en_i
