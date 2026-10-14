-- chunkname: @src.app.sdk.lp_en

local lp_en = {}

function lp_en.login(cb)
	print("Lua lp_en.login")
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

function lp_en.switch(cb)
	print("Lua lp_en.switchAccount")
	sdk.callPlatformFunc("switchAccount", "", function(info)
		print("logout ret = ", info)
		cb(0, "ok")
	end)
end

function lp_en.openCustomerService(vip)
	print("openCustomerService:", vip)

	local funcType = 1

	if sdk.sdkChannel ~= "-1" then
		funcType = 2
	end

	local tmp = {
		area_id = "",
		level = "",
		area = "",
		created_time = "",
		role_id = "",
		user_id = "",
		user_name = "",
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

function lp_en.commitRoleInfo(ctype, cb)
	print("Lua lp_en.commitRoleInfo")

	local funcType = 1

	if sdk.sdkChannel ~= "-1" then
		funcType = 2
	end

	local tmp = {
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

local eventMap = {
	world_text = "world_text",
	union_text = "union_text",
	tap_discord = "tap_discord",
	pass_friend = "pass_friend",
	add_friends = "add_friends",
	myst_master = "myst_master",
	halfdia_singledraw = "halfdia_singledraw",
	dia_attribute = "dia_attribute",
	dia_alexa = "dia_alexa",
	dia_backpack = "dia_backpack",
	dia_pokename = "dia_pokename",
	dia_vippack = "dia_vippack",
	dia_device5 = "dia_device5",
	dia_device1 = "dia_device1",
	dia_gold10x = "dia_gold10x",
	dia_gold = "dia_gold",
	aether_refre = "aether_refre",
	aether_chest = "aether_chest",
	check_vippack = "check_vippack",
	dia_48h_10K = "10kdia_48h",
	tap_buypass = "tap_buypass",
	dia_48h_8k = "8kdia_48h",
	use_raid50 = "use_raid50",
	dia_24h_5k = "5kdia_24h",
	event_powerrank = "event_powerrank",
	dia_24h_3k = "3kdia_24h",
	dismantle_confirm = "dismantle_confirm",
	dia_24h_2k = "2kdia_24h",
	check_bidchest = "check_bidchest",
	dia_24h_1k = "1kdia_24h",
	element_chest = "element_chest",
	myst_refre = "myst_refre",
	dispatch_diaquick = "dispatch_diaquick",
	dispatch_diaref = "dispatch_diaref",
	dia_arenaattempt = "dia_arenaattempt",
	train_spot3 = "train_spot3",
	train_spot2 = "train_spot2",
	train_spot1 = "train_spot1",
	supreme_union = "supreme_union",
	grand_union = "grand_union",
	diarefr_shard = "diarefr_shard",
	diarefr_union = "diarefr_union",
	create_union = "create_union",
	discount_7d2 = "discount_7d2",
	discount_7d1 = "discount_7d1",
	growth_plan = "growth_plan",
	arena_cd5time = "arena_cd5time",
	reclaim_stamina = "reclaim_stamina",
	check_gameannou = "check_gameannou",
	bidwar_10x = "10x_bidwar",
	check_pokedex = "check_pokedex",
	tap_10xpts = "tap_10xpts",
	preview_limitedraw = "preview_limitedraw",
	preview_diadraw = "preview_diadraw",
	preview_timedraw = "preview_timedraw",
	check_allfirst = "check_allfirst",
	selctype_10x = "10x_selctype",
	pay_13 = "pay_99.99",
	trinket_10x = "10x_trinket",
	pay_12 = "pay_49.99",
	gold_10x = "10x_gold",
	pay_11 = "pay_29.99",
	diamond_10x = "10x_diamond",
	pay_10 = "pay_25.99",
	buy_stamina = "buy_stamina",
	pay_9 = "pay_19.99",
	male_char = "male_char",
	pay_8 = "pay_14.99",
	starter_fire = "starter_fire",
	pay_7 = "pay_12.99",
	challenge_hardfail = "challenge_hardfail",
	check_monsub = "check_monsub",
	check_powerrank = "check_powerrank",
	pay_5 = "pay_4.99",
	check_advroadrank = "check_advroadrank",
	pay_4 = "pay_3.99",
	check_goldrank = "check_goldrank",
	pay_3 = "pay_2.99",
	fail_trinketenhance = "fail_trinketenhance",
	pay_2 = "pay_1.99",
	fail_again = "fail_again",
	pay_1 = "pay_0.99",
	pay_monthsub_2 = "pay_monthsub_2",
	pay_monthsub_1 = "pay_monthsub_1",
	first_pay = "first_pay",
	op_pack = "op_pack",
	op_diamond = "op_diamond",
	online_60 = "online_60",
	online_30 = "online_30",
	online_15 = "online_15",
	online_10 = "online_10",
	online_5 = "online_5",
	staminapuff_4 = "staminapuff_4",
	staminapuff_3 = "staminapuff_3",
	staminapuff_2 = "staminapuff_2",
	staminapuff_1 = "staminapuff_1",
	join_union = "join_union",
	activity_100 = "activity_100",
	activity_40 = "activity_40",
	check_allpack = "check_allpack",
	draw_10x = "10x_draw",
	lvl_28 = "lvl_28",
	lvl_24 = "lvl_24",
	lvl_6 = "lvl_6",
	lvl_2 = "lvl_2",
	create_role = "create_role",
	battle_demo = "battle_demo",
	pull_version_end = "pull_version_end",
	pull_version_begin = "pull_version_begin",
	SHOW_SERVER = "SHOW_SERVER",
	REQ_LOGIN_ERR = "REQ_LOGIN_ERR",
	SDK_LOGIN_ERR = "SDK_LOGIN_ERR",
	SDK_LOGIN_SUC = "SDK_LOGIN_SUC",
	PLAY_IN_CITY = "PLAY_IN_CITY",
	GAME_LOGIN_SUC = "GAME_LOGIN_SUC",
	ENTER_SEVER_SUCCESS = "ENTER_SEVER_SUCCESS",
	ENTER_SEVER_ERR = "ENTER_SEVER_ERR",
	START_GAME = "START_GAME",
	START_LOGIN = "START_LOGIN",
	CLICK_OK = "CLICK_OK",
	PULL_GAMESHOW = "PULL_GAMESHOW",
	NOTNETWORK_CLICK = "NOTNETWORK_CLICK",
	CDN_FINISH = "CDN_FINISH",
	CDN_60 = "CDN_60",
	CDN_30 = "CDN_30",
	CDN_5 = "CDN_5",
	START_CDN = "START_CDN",
	PULL_VERSION = "PULL_VERSION",
	tap_diaplus = "tap_diaplus",
	check_aetherrank = "check_aetherrank",
	fail_draw = "fail_draw",
	fail_pokeenhance = "fail_pokeenhance",
	arenawin_replay = "arenawin_replay",
	check_exprank = "check_exprank",
	check_arenarank = "check_arenarank",
	female_char = "female_char",
	timedraw_10x = "10x_timedraw",
	bidwar_single = "bidwar_single",
	limitedraw_10x = "10x_limitedraw",
	buy_skillpt = "buy_skillpt",
	starter_water = "starter_water",
	starter_grass = "starter_grass",
	pay_6 = "pay_8.99",
	claim_mail = "claim_mail",
	free_diasingle = "free_diasingle",
	free_goldsingle = "free_goldsingle",
	edit_annou = "edit_annou",
	check_bidpoint = "check_bidpoint",
	claim_stamina = "claim_stamina",
	claim_hoopa = "claim_hoopa",
	challenge_arena = "challenge_arena",
	free_devicedraw = "free_devicedraw",
	claim_uniondaily = "claim_uniondaily",
	claim_gift40 = "claim_gift40",
	claim_gift20 = "claim_gift20",
	claim_redpack = "claim_redpack",
	activity_115 = "activity_115",
	change_name = "change_name",
	check_recom = "check_recom",
	redeem_code = "redeem_code",
	share_arenawin = "share_arenawin",
	add_friends60 = "add_friends60",
	add_friends40 = "add_friends40",
	add_friends20 = "add_friends20",
	priv_text = "priv_text",
	set_motto = "set_motto"
}

function lp_en.trackEvent(ctype, data)
	print("Lua lp_en.trackEvent")

	if eventMap[ctype] == nil then
		return
	end

	if ctype == "join_union" then
		local unionIdRecord = userDefault.getForeverLocalKey("unionIdRecord_lp_en", nil)

		if not unionIdRecord then
			userDefault.setForeverLocalKey("unionIdRecord_lp_en", 1)
		else
			return
		end
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

function lp_en.logout(cb)
	print("Lua lp_en.logout")
	sdk.callPlatformFunc("logout", "game", function(info)
		print("logout ret = ", info)
		cb(0, "ok")
	end)
end

local defaultPrefix = {
	"com.kjdedew_",
	2100
}
local productPrefixTagMap = {
	com_doyea_uekas = {
		"jxqqfc_money_",
		2100
	},
	com_pisxas_luwuf = {
		"qyywfc_money_",
		2100
	},
	com_male_pices = {
		"com.male.pices_",
		2100
	},
	com_hueka_uejsd = {
		"com.hueka.uejsd_",
		2100
	},
	com_hongling_luo = {
		"com.hongling.luo_",
		2100
	},
	com_kjdedew = {
		"com.kjdedew_",
		2100
	},
	com_lianglixue = {
		"com.lianglixue_",
		2100
	},
	com_fq_ch = {
		"com.fq.ch_",
		2100
	},
	com_fengc_hen = {
		"com.fengc.hen_",
		2100
	},
	com_xinshuaisun = {
		"com.xinshuaisun_",
		2100
	},
	com_zenzuozuo = {
		"com.zenzuozuo_",
		2100
	},
	com_changjishu = {
		"com.changjishu_",
		2100
	},
	com_xchaniaobing = {
		"com.xchaniaobing_",
		2100
	},
	com_weixiongguo = {
		"com.weixiongguo_",
		2100
	},
	com_pocketworld = {
		"com.pocketworld_",
		2100
	},
	com_pocketsmash = {
		"com.lulushi_",
		2100
	},
	com_changjishu = {
		"com.changjishu_",
		2100
	},
	com_changhuailong = {
		"com.changhuailong_",
		2100
	},
	com_xiaohuiguo = {
		"com.xiaohuiguo_",
		2100
	},
	com_wenchangdeng = {
		"com.wenchangdeng_",
		2100
	},
	com_lvxinglin = {
		"com.lvxinglin_",
		2100
	},
	com_weinong_liang = {
		"com.weinong.liang_",
		2100
	},
	com_ming_weiliang = {
		"com.ming.weiliang_",
		2100
	},
	com_song_liang = {
		"com.song.liang_",
		2100
	},
	com_su_jing = {
		"com.su.jing_",
		2100
	},
	com_jieneilin = {
		"com.jieneilin_",
		2100
	},
	com_dake_wang = {
		"com.dake.wang_",
		2100
	},
	com_huan_xinli = {
		"com.huan.xinli_",
		2100
	},
	com_iosapp_kdname = {
		"com.iosapp.kdname_",
		2100
	},
	as_com_awkapp_wrldk = {
		"com.awkapp.wrldk_",
		2100
	},
	as_com_impact_iospet = {
		"com.impact.iospet_",
		2100
	},
	as_com_peten_originios = {
		"com.peten.originios_",
		2100
	},
	as_com_compact_petios = {
		"com.compact.petios_",
		2100
	},
	as_com_petleague_iosen = {
		"com.petleague.iosen_",
		2100
	},
	as_com_iosmaster_peten = {
		"com.iosmaster.peten_",
		2100
	},
	as_com_raidios_enmonster = {
		"com.raidios.enmonster_",
		2100
	},
	as_com_hypemasten_gold = {
		"hypemasten_gold_",
		2100
	},
	as_msttriiosevo_gold = {
		"msttriiosevo_gold_",
		2100
	},
	as_newworlden_gold = {
		"newworlden_gold_",
		2100
	},
	as_elfbuddy_gold_yidun = {
		"elfbuddy_gold_",
		2100
	},
	wfiosgame_woafoa_com_yidun = {
		"trainercohorts_gold_",
		2100
	},
	reriosgame_loarer_com_yidun = {
		"petevoquest_gold_",
		2100
	},
	elemental_gold_ios_yidun = {
		"elemental_gold_",
		2100
	},
	warfield_gold_ios_yidun = {
		"warfield_gold_",
		2100
	},
	questland_gold_ios_yidun = {
		"questland_gold_",
		2100
	},
	monstropolis_gold_ios_yidun = {
		"monstropolis_gold_",
		2100
	},
	tamingrealm_gold_ios_yidun = {
		"tamingrealm_gold_",
		2100
	},
	mancerparadise_gold_ios_yidun = {
		"mancerparadise_gold_",
		2100
	},
	evobeast_gold_ios_yidun = {
		"evobeast_gold_",
		2100
	},
	charmers_gold_ios_yidun = {
		"charmers_gold_",
		2100
	},
	chronicle_gold_ios_yidun = {
		"chronicle_gold_",
		2100
	},
	as_petworlde_gold_ios_yidun_v4 = {
		"petworlde_gold_",
		2100
	},
	as_traintactics_gold_ios_yidun_v4 = {
		"traintactics_gold_",
		2100
	},
	as_revivalduel_gold_ios_yidun_v4 = {
		"revivalduel_gold_",
		2100
	},
	com_manorlife_retireman_ios_yidun_v4 = {
		"tpetcard_gold_",
		2100
	},
	beastredux_gold_b54_ios_yidun_v4 = {
		"beastredux_gold_",
		2100
	},
	com_tankbattle_plans_ios_yidun_v4 = {
		"cardbash_gold_",
		2100
	},
	xiao7_gold_ios_yidun_v4 = {
		"trialssaga_gold_",
		2100
	},
	petallies_gold_ios_yidun_v4 = {
		"petallies_gold_",
		2100
	},
	championduel_gold_ios_yidun_v4 = {
		"championduel_gold_",
		2100
	},
	com_fkdjxen_id204_ios_yidun_v4 = {
		"pokemon_gold_",
		2100
	},
	com_fengc_hen_aos = {
		"com.fengc.hen_",
		2100
	},
	com_weixiongguo_aos = {
		"com.weixiongguo_",
		2100
	},
	com_dake_wang_aos = {
		"com.dake.wang_",
		2100
	},
	com_huan_xinli_aos = {
		"com.huan.xinli_",
		2100
	},
	com_jieneilin_aos = {
		"com.jieneilin_",
		2100
	},
	com_kjdx_five_qlyr_aos = {
		"com.kjdx.five.qlyr_",
		2100
	},
	com_pyjx_six_lhyq_aos = {
		"com.pyjx.six.lhyq_",
		2100
	},
	kdjxbseven_gold_aos = {
		"kdjxbseven_gold_",
		2100
	},
	com_myre_ight_myrp_aos = {
		"com.myre.ight.myrp_",
		2100
	},
	com_bylp_nine_bytl_aos = {
		"com.bylp.nine.bytl_",
		2100
	},
	com_wrty_teny_avbm_aos = {
		"com.wrty.teny.avbm_",
		2100
	},
	as_bkju_elev_enlp_aos = {
		"com.bkju.elev.enlp_",
		2100
	},
	as_sfgy_twel_veck_aos = {
		"com.sfgy.twel.veck_",
		2100
	},
	as_thir_teen_jukp_aos = {
		"com.thir.teen.jukp_",
		2100
	},
	as_qkny_four_teen_aos = {
		"com.qkny.four.teen_",
		2100
	},
	as_b142_four_teen_aos = {
		"com.qkny.four.teen_",
		2100
	},
	as_kzoq_zfif_teen_aos = {
		"com.kzoq.zfif.teen_",
		2100
	},
	as_mrpq_zsix_teen_aos = {
		"com.mrpq.zsix.teen_",
		2100
	},
	as_jxhfden_bzcsqi_aos = {
		"com.jxhfden.bzcsqi_",
		2100
	},
	as_ptfts_gold_aos = {
		"ptfts_gold_",
		2100
	},
	as_monsaga_gold_aos = {
		"monsaga_gold_",
		2100
	},
	as_mobilemon_gold_aos = {
		"mobilemon_gold_",
		2100
	},
	as_islandmon_gold_aos = {
		"islandmon_gold_",
		2100
	},
	as_monmaster_gold_aos = {
		"monmaster_gold_",
		2100
	},
	as_evomonlve_gold_aos = {
		"evomonlve_gold_",
		2100
	},
	as_mondashster_gold_aos = {
		"mondashster_gold_",
		2100
	},
	as_moelflegend_gold_aos = {
		"moelflegend_gold_",
		2100
	},
	as_risemongen_gold_aos = {
		"risemongen_gold_",
		2100
	},
	as_hypevoadv_gold_aos = {
		"hypevoadv_gold_",
		2100
	},
	as_mobimastevo_gold_aos = {
		"mobimastevo_gold_",
		2100
	},
	as_gradadvpok_gold_aos = {
		"gradadvpok_gold_",
		2100
	},
	as_matrascdanorg_gold_aos = {
		"matrascdanorg_gold_",
		2100
	},
	as_agorapacelvoh_gold_aos = {
		"agorapacelvoh_gold_",
		2100
	},
	as_elfisland_gold_aos = {
		"elfIsland_gold_",
		2100
	},
	as_elfisland_gold_aos_two = {
		"elfIsland_gold_",
		2100
	},
	as_contest_gold_aos = {
		"contest_gold_",
		2100
	},
	as_safariex_gold_aos = {
		"safariex_gold_",
		2100
	},
	as_battleelf_gold_aos = {
		"battleelf_gold_",
		2100
	},
	as_pettamer_gold_aos = {
		"pettamer_gold_",
		2100
	},
	as_mjourney_gold_aos_yidun = {
		"mjourney_gold_",
		2100
	},
	as_petparadise_gold_aos_yidun = {
		"petparadise_gold_",
		2100
	},
	as_lndonesia_gold_aos_yidun = {
		"lndonesia_gold_",
		2100
	},
	as_advtales_gold_aos_yidun = {
		"advtales_gold_",
		2100
	},
	as_chronicle_gold_aos_yidun = {
		"chronicle_gold_",
		2100
	},
	as_com_nftq_mnqt_tap_yidun = {
		"chronicle_gold_",
		2100
	},
	as_petrealm_gold_aos_yidun = {
		"petrealm_gold_",
		2100
	},
	as_petventure_gold_aos_yidun = {
		"petventure_gold_",
		2100
	},
	as_petrealm_huawei_aos_yidun = {
		"petrealm_gold_",
		2100
	},
	as_petrealm_oppo_aos_yidun = {
		"petrealm_gold_",
		2100
	},
	as_petrealm_vivo_aos_yidun = {
		"petrealm_gold_",
		2100
	},
	as_petworld_gold_aos_yidun = {
		"petworld_gold_",
		2100
	},
	as_monstropolis_gold_aos_yidun = {
		"monstropolis_gold_",
		2100
	},
	as_petmancer_gold_aos_yidun = {
		"petmancer_gold_",
		2100
	},
	as_mentormasters_gold_aos_yidun = {
		"mentormasters_gold_",
		2100
	},
	as_agorapacelvoh_gold_aos_yidun = {
		"agorapacelvoh_gold_",
		2100
	},
	as_com_myre_ight_myrp_aos_yidun = {
		"newpetarena_gold_",
		2100
	},
	as_bkju_elev_enlp_aos_yidun = {
		"newcompact_gold_",
		2100
	},
	as_kdjxbseven_gold_aos_yidun = {
		"kdjxbseven_gold_",
		2100
	},
	as_trialssaga_gold_aos_yidun = {
		"trialssaga_gold_",
		2100
	},
	as_com_kdjxen_id67_aos_yidun = {
		"trialssaga_gold_",
		2100
	},
	as_com_kdjxen_id21_aos_yidun = {
		"trialssaga_gold_",
		2100
	},
	as_com_kdjxen_id15_aos_yidun = {
		"trialssaga_gold_",
		2100
	},
	as_com_kdjxen_id15qd_aos_yidun = {
		"trialssaga_gold_",
		2100
	},
	as_com_kdjxen_beiyong1_aos_yidun = {
		"trialssaga_gold_",
		2100
	},
	as_com_kdjxen_beiyong2_aos_yidun = {
		"trialssaga_gold_",
		2100
	},
	as_com_kdjxen_beiyong3_aos_yidun = {
		"trialssaga_gold_",
		2100
	},
	as_com_kdjxen_id04_aos_yidun = {
		"newpetarena_gold_",
		2100
	},
	as_com_kdjxen_id15qdsmall_aos_yidun = {
		"trialssaga_gold_",
		2100
	},
	as_com_kdjxen_id67small_aos_yidun = {
		"trialssaga_gold_",
		2100
	},
	as_com_derf_asqw_fgty_aos_yidun = {
		"elementalq_gold_",
		2100
	},
	as_com_bkju_elev_enlp_aos_yidun = {
		"newcompact_gold_",
		2100
	},
	as_com_fjzj_fji_hang_two_aos_yidun = {
		"hyperpet_gold_",
		2100
	},
	as_com_kzoq_zfif_teen_yidun_v4 = {
		"petraid_gold_",
		2100
	},
	as_com_mrpq_zsix_teen_yidun_v4 = {
		"elfislandad_gold_",
		2100
	},
	as_com_fkdjxen_id10_ld_yidun_v4 = {
		"trialssaga_gold_",
		2100
	},
	as_trialssaga_gold_new49_yidun_v4 = {
		"trialssaga_gold_",
		2100
	},
	as_trialssaga_gold_small49_yidun_v4 = {
		"trialssaga_gold_",
		2100
	},
	as_com_kdjxen_base_yidun_v4 = {
		"trialssaga_gold_",
		2100
	},
	as_com_yarq_jkqr_hhqp_yidun_v4 = {
		"petclash_gold_",
		2100
	},
	as_com_lznt_jaqp_lpmq_yidun_v4 = {
		"safariduel_gold_",
		2100
	},
	as_com_pjka_njy_nbvc_yidun_v4 = {
		"puzzlepets_gold_",
		2100
	},
	as_com_jipt_seven_plnr_yidun_v4 = {
		"pettourney_gold_",
		2100
	},
	as_togagame_com_kdjxen_base_yidun_v4 = {
		"trialssaga_gold_",
		2100
	},
	as_240902_com_kdjxen_base_yidun_v4 = {
		"trialssaga_gold_",
		2100
	},
	as_com_erdf_rftg_uhbr_yidun_v4 = {
		"trialtrek_gold_",
		2100
	},
	as_240910_com_kdjxen_base_yidun_v4 = {
		"trialssaga_gold_",
		2100
	},
	as_b58_championduel_gold_yidun_v4 = {
		"championduel_gold_",
		2100
	},
	as_com_wrty_teny_avbm_yidun_v4 = {
		"tacticsace_gold_",
		2100
	},
	as_com_fkdue_sh_android_yidun_v4 = {
		"pawventure_gold_",
		2100
	},
	as_com_kd_en_fkdjxen_android_yidun_v4 = {
		"petpioneers_gold_",
		2100
	}
}

function lp_en.pay(cpOrderId, extInfo, amount, rechargeId, productDesc, cb)
	print("Lua lp.pay")

	local roleInfo = gGameModel.role
	local payInfo = csv.recharges[rechargeId]
	local productID
	local prefix, startID = unpack(productPrefixTagMap[APP_TAG] or defaultPrefix)
	local suffix = 1

	if rechargeId >= 2100 then
		suffix = rechargeId - startID
		productID = prefix .. suffix
	elseif rechargeId >= 108 then
		suffix = rechargeId - 100
		productID = prefix .. suffix
	elseif rechargeId > 100 then
		suffix = rechargeId - 101
		productID = prefix .. suffix
	else
		suffix = 2 * rechargeId + 3
		productID = prefix .. suffix
	end

	local _roleLevel = tostring(roleInfo:read("level"))

	if APP_TAG == "as_petrealm_gold_aos_yidun" then
		_roleLevel = extInfo
	end

	local tmp = {
		currency = "usd",
		count = 1,
		roleId = stringz.bintohex(roleInfo:read("id")),
		roleName = roleInfo:read("name"),
		roleLevel = _roleLevel,
		area = gGameApp.serverInfo.name,
		area_id = tostring(roleInfo:read("area")),
		rmb = amount / 10,
		rmbDisplay = tostring(string.format("%.2f", payInfo.rmbDisplay)),
		amount = amount,
		extInfo = extInfo,
		productDesc = productDesc,
		productName = productDesc,
		productID = productID
	}
	local vipSum = gGameModel.role:read("vip_sum")

	sdk.callPlatformFunc("pay", json.encode(tmp), function(info)
		print("pay ret = ", info)

		if info == "ok" then
			cb(0, info)

			local eventId = "pay_" .. suffix

			sdk.trackEvent(eventId)

			if vipSum == 0 then
				sdk.trackEvent("first_pay")
			end
		else
			cb(-1, "error")
		end
	end)
end

function lp_en.getSDKChannel(cb)
	print("Lua lp_en.getChannel")
	sdk.callPlatformFunc("getSDKChannel", "", function(info)
		print("Lua lp_en.getChannel:" .. info)
		cb(info)
	end)
end

return lp_en
