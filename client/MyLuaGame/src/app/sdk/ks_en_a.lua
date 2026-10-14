-- chunkname: @src.app.sdk.ks_en_a

local ks_en_a = {}

function ks_en_a.login(cb)
	print("Lua ks_en_a.login")
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
	nil,
	"SUBMIT_TYPE_CREATE",
	nil,
	nil,
	nil,
	"SUBMIT_TYPE_UPDATE"
}

function ks_en_a.commitRoleInfo(ctype, cb)
	print("Lua ks_en_a.commitRoleInfo")

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
	FINISHED_LOADING = "EVENTS_FINISHED_LOADING",
	START_LOADING = "EVENTS_START_LOADING"
}

function ks_en_a.trackEvent(ctype, data)
	print("Lua ks_en_a.trackEvent")

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

function ks_en_a.logout(cb)
	print("Lua ks_en_a.logout")
	sdk.callPlatformFunc("logout", "game", function(info)
		print("logout ret = ", info)
		cb(0, "ok")
	end)
end

function ks_en_a.getSdkConfig(cb)
	print("Lua ks_en_a.getsdkConfig")
	sdk.callPlatformFunc("getsdkConfig", "", function(info)
		print("getsdkConfig ret = ", info)
		cb(0, info)
	end)
end

local defaultPrefix = {
	"com.rise.google",
	1384
}
local productPrefixTagMap = {
	com_rise_google = {
		"com.rise.google",
		1384
	},
	com_songs_google = {
		"com.songs.google",
		1449
	},
	com_adventure_google = {
		"com.adventure.google",
		1488
	},
	com_story_google = {
		"com.story.google",
		1549
	},
	com_elftrainer_google = {
		"com.elftrainer.google",
		1592
	},
	com_eas_google = {
		"com.eas.google",
		1621
	},
	com_battle_google = {
		"com.battle.google",
		1683
	},
	mec_crush_google = {
		"mec.crush.google",
		1811
	},
	bts_beast_old = {
		"bts.beast.old",
		1798
	},
	bc_chapter_google = {
		"bc.chapter.google",
		1837
	},
	sla_awaken_google = {
		"sla.awaken.google",
		1824
	},
	elfa_battle_google = {
		"elfa.battle.google",
		1864
	},
	ea_elves_google = {
		"ea.elves.google",
		1877
	},
	com_mirof_google = {
		"com.mirof.google",
		1916
	},
	myea_wlktao_google = {
		"myea.wlktao.google",
		1890
	},
	com_fight_google = {
		"com.fight.google",
		1903
	},
	com_roeaw_google = {
		"com.roeaw.google",
		1990
	},
	com_leagueof_google = {
		"com.leagueof.google",
		2211
	},
	com_realmof_google = {
		"com.realmof.google",
		2172
	},
	com_elvestw_google = {
		"com.elvestw.google",
		2224
	},
	com_battleoc_google = {
		"com.battleoc.google",
		2185
	},
	com_eest_google = {
		"com.eest.google",
		2356
	},
	com_elflg_google = {
		"com.elflg.google",
		2369
	},
	com_elfas_google = {
		"com.elfas.google",
		2395
	},
	com_elvcon_google = {
		"com.elvcon.google",
		2421
	},
	com_fies_google = {
		"com.fies.google",
		2436
	},
	com_sss_google = {
		"com.sss.google",
		2462
	},
	com_cfttt_google = {
		"com.cfttt.google",
		2523
	},
	com_elfma_google = {
		"com.elfma.google",
		2609
	},
	com_jnedm_google = {
		"com.jnedm.google",
		2622
	},
	com_pbec_google = {
		"com.pbec.google",
		2716
	},
	com_adva_google = {
		"com.adva.google",
		2826
	},
	com_sbesh_google = {
		"com.sbesh.google",
		2839
	},
	com_riseoe_huawei = {
		"com.riseoe.huawei",
		3291
	},
	com_selfw_google = {
		"com.selfw.google",
		3525
	},
	com_elfbg_google = {
		"com.elfbg.google",
		3641
	},
	com_elbm_google = {
		"com.elbm.google",
		3627
	},
	com_elfba_google = {
		"com.elfba.google",
		3654
	},
	com_elbna_google = {
		"com.elbna.google",
		3602
	},
	com_elbev_google = {
		"com.elbev.google",
		3964
	},
	com_efat_google = {
		"com.efat.google",
		4075
	},
	com_elfqlr_google = {
		"com.elfqlr.google",
		4115
	},
	com_emex_google = {
		"com.emex.google",
		4163
	},
	com_petle_google = {
		"com.petle.google",
		4263
	},
	com_efdu_google = {
		"com.efdu.google",
		4289
	},
	com_efod_google = {
		"com.efod.google",
		4317
	},
	com_elpc_google = {
		"com.elpc.google",
		4428
	},
	com_fame_google = {
		"com.fame.google",
		4456
	},
	com_enea_google = {
		"com.enea.google",
		4496
	},
	com_myea_google = {
		"com.myea.google",
		4632
	},
	com_efdu_google_yidun = {
		"com.efdu.google",
		4289
	},
	com_elfsaga_google_yidun = {
		"com.elfsaga.google",
		4778
	},
	com_myvo_google_yidun = {
		"com.myvo.google",
		4868
	},
	com_gamon_google_yidun = {
		"com.gamon.google",
		4855
	},
	com_stqu_google_yidun = {
		"com.stqu.google",
		5082
	},
	com_trma_google_yidun = {
		"com.trma.google",
		5225
	},
	com_mtnw_google_yidun = {
		"com.mtnw.google",
		5415
	},
	com_mocac_google_yidun = {
		"com.mocac.google",
		5415
	},
	com_riseoe_amz_yidun = {
		"com.riseoe.amz",
		5633
	},
	com_riseoe_samsung_yidun = {
		"com.riseoe.samsung",
		5646
	},
	com_bane_google_yidun = {
		"com.bane.google",
		5686
	},
	com_riseoe_huawei_yidun = {
		"com.riseoe.huawei",
		3291
	},
	com_pokemon_google_yidun = {
		"com.pokemon.google",
		4996
	},
	com_eleu_google_yidun = {
		"com.eleu.google",
		5901
	},
	com_ptra_google_yidun = {
		"com.ptra.google",
		5952
	},
	com_batmaster_google_yidun = {
		"com.batmaster.google",
		6067
	},
	com_myspsh_google_yidun = {
		"com.myspsh.google",
		6152
	},
	com_eleco_google_yidun = {
		"com.eleco.google",
		6513
	},
	com_enpj_google_yidun_v4 = {
		"com.enpj.google",
		6574
	},
	com_whimsy_woods_yidun_v4 = {
		"com.wwe.google",
		6674
	},
	com_enpj_googlenew_yidun_v4 = {
		"com.enpj.google",
		6574
	},
	com_batmaster_google_yidun_v4 = {
		"com.batmaster.google",
		6067
	},
	com_mysticba_google_kssdk_yidun_v4 = {
		"com.mysticba.google",
		6093
	},
	com_eqwww_google_kssdk_yidun_v4 = {
		"eqw.",
		6827
	},
	com_riseoe_sq_kssdk_yidun_v4 = {
		"com.riseoe.sq",
		8343
	},
	com_wildflu_sostabib_kssdk_yidun_v4 = {
		"com.myjo.google",
		8360
	},
	com_riseoe_yeshen_kssdk_yidun_v4 = {
		"com.riseoe.yeshen",
		8644
	},
	com_my_chathlimi_kssdk_yidun_v4 = {
		"com.e3l.han",
		8850
	},
	com_appclick_sostabib_kssdk_yidun_v4 = {
		"com.appclick.sos",
		9145
	},
	com_fwrun_shiping_kssdk_yidun_v4 = {
		"com.fle.tou",
		9369
	},
	com_egtaz_smartpharmacy_kssdk_yidun_v4 = {
		"com.eg.sma",
		9554
	},
	com_app2021_mobcontrol_kssdk_yidun_v4 = {
		"com.app.mob",
		9969
	},
	com_petad_huawei_kssdk_yidun_v4 = {
		"com.petad.huawei",
		10019
	},
	com_toofive_slicemonsters_kssdk_yidun_v4 = {
		"com.cha.chcl",
		10109
	},
	com_softwinbd_vtr_kssdk_yidun_v4 = {
		"com.myta.adv",
		10212
	},
	com_pokego_google_kssdk_yidun_v4 = {
		"com.pokego.google",
		10548
	},
	com_petad_huawei2_kssdk_yidun_v4 = {
		"com.petad.huawei",
		10019
	},
	com_human_body_secrets_kssdk_yidun_v4 = {
		"com.ees.moal",
		10831
	},
	com_moneli_conq_kssdk_yidun_v4 = {
		"com.moneli.conq",
		10969
	},
	com_evo_leg_kssdk_yidun_v4 = {
		"com.evo.leg",
		11532
	},
	com_prc_chr_kssdk_yidun_v4 = {
		"com.prc.chr",
		11805
	},
	com_mas_aec_kssdk_yidun_v4 = {
		"com.mas.aec",
		11966
	},
	com_shofaktar_mydj_kssdk_yidun_v4 = {
		"com.evm.pet",
		12120
	},
	com_gma_pet_kssdk_yidun_v4 = {
		"com.gma.pet",
		12420
	},
	com_roe_rustore_kssdk_yidun_v4 = {
		"com.roe.rustore",
		12391
	},
	com_mgpw_ars_kssdk_yidun_v4 = {
		"com.mgpw.ars",
		12880
	},
	com_pss_pen_kssdk_yidun_v4 = {
		"com.pss.pen",
		12919
	}
}

function ks_en_a.pay(cpOrderId, extInfo, amount, rechargeId, productDesc, cb)
	print("Lua ks_en_a.pay")

	local roleInfo = gGameModel.role
	local productID
	local payInfo = csv.recharges[rechargeId]
	local prefix, startID = unpack(productPrefixTagMap[APP_TAG] or defaultPrefix)

	if rechargeId >= 2100 then
		productID = rechargeId - 2100 + startID
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

return ks_en_a
