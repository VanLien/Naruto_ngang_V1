-- chunkname: @src.app.sdk.lp_eu

local lp_eu = {}

function lp_eu.login(cb)
	print("Lua lp_eu.login")
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

function lp_eu.switch(cb)
	print("Lua lp_eu.switchAccount")
	sdk.callPlatformFunc("switchAccount", "", function(info)
		print("logout ret = ", info)
		cb(0, "ok")
	end)
end

function lp_eu.openCustomerService(vip)
	print("openCustomerService:", vip)

	local tmp = {
		vip = vip
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

function lp_eu.commitRoleInfo(ctype, cb)
	print("Lua lp_eu.commitRoleInfo")

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
	aether_chest = "aether_chest",
	diarefr_union = "diarefr_union",
	lvl_2 = "lvl_2",
	dia_24h_5k = "5kdia_24h",
	dispatch_diaquick = "dispatch_diaquick",
	trinket_10x = "10x_trinket",
	check_bidpoint = "check_bidpoint",
	discount_7d1 = "discount_7d1",
	diamond_10x = "10x_diamond",
	add_friends60 = "add_friends60",
	reclaim_stamina = "reclaim_stamina",
	fail_again = "fail_again",
	check_allfirst = "check_allfirst",
	pay_1 = "pay_0.99",
	limitedraw_10x = "10x_limitedraw",
	use_raid50 = "use_raid50",
	starter_grass = "starter_grass",
	create_union = "create_union",
	tap_buypass = "tap_buypass",
	online_10 = "online_10",
	fail_draw = "fail_draw",
	online_60 = "online_60",
	pay_12 = "pay_49.99",
	dia_pokename = "dia_pokename",
	staminapuff_4 = "staminapuff_4",
	growth_plan = "growth_plan",
	check_arenarank = "check_arenarank",
	activity_100 = "activity_100",
	set_motto = "set_motto",
	START_CDN = "START_CDN",
	join_union = "join_union",
	check_allpack = "check_allpack",
	preview_diadraw = "preview_diadraw",
	online_30 = "online_30",
	pay_10 = "pay_25.99",
	tap_diaplus = "tap_diaplus",
	first_pay = "first_pay",
	arenawin_replay = "arenawin_replay",
	pay_11 = "pay_29.99",
	pay_monthsub_1 = "pay_monthsub_1",
	grand_union = "grand_union",
	bidwar_single = "bidwar_single",
	check_powerrank = "check_powerrank",
	gold_10x = "10x_gold",
	pay_13 = "pay_99.99",
	union_text = "union_text",
	fail_trinketenhance = "fail_trinketenhance",
	arena_cd5time = "arena_cd5time",
	share_arenawin = "share_arenawin",
	change_name = "change_name",
	claim_gift40 = "claim_gift40",
	train_spot3 = "train_spot3",
	claim_mail = "claim_mail",
	free_goldsingle = "free_goldsingle",
	claim_hoopa = "claim_hoopa",
	preview_timedraw = "preview_timedraw",
	check_gameannou = "check_gameannou",
	edit_annou = "edit_annou",
	challenge_arena = "challenge_arena",
	free_devicedraw = "free_devicedraw",
	START_GAME = "START_GAME",
	claim_gift20 = "claim_gift20",
	aether_refre = "aether_refre",
	battle_demo = "battle_demo",
	online_15 = "online_15",
	check_advroadrank = "check_advroadrank",
	CDN_30 = "CDN_30",
	pay_8 = "pay_14.99",
	dia_gold = "dia_gold",
	timedraw_10x = "10x_timedraw",
	claim_uniondaily = "claim_uniondaily",
	claim_stamina = "claim_stamina",
	pay_7 = "pay_12.99",
	check_aetherrank = "check_aetherrank",
	dia_device1 = "dia_device1",
	PULL_VERSION = "PULL_VERSION",
	staminapuff_1 = "staminapuff_1",
	staminapuff_2 = "staminapuff_2",
	check_goldrank = "check_goldrank",
	lvl_6 = "lvl_6",
	pay_9 = "pay_19.99",
	dia_arenaattempt = "dia_arenaattempt",
	staminapuff_3 = "staminapuff_3",
	pay_2 = "pay_1.99",
	claim_redpack = "claim_redpack",
	dia_attribute = "dia_attribute",
	event_powerrank = "event_powerrank",
	pay_4 = "pay_3.99",
	selctype_10x = "10x_selctype",
	online_5 = "online_5",
	check_monsub = "check_monsub",
	element_chest = "element_chest",
	pay_3 = "pay_2.99",
	male_char = "male_char",
	dia_48h_8k = "8kdia_48h",
	draw_10x = "10x_draw",
	activity_115 = "activity_115",
	lvl_28 = "lvl_28",
	pay_5 = "pay_4.99",
	dia_alexa = "dia_alexa",
	diarefr_shard = "diarefr_shard",
	START_LOGIN = "START_LOGIN",
	dia_48h_10K = "10kdia_48h",
	op_diamond = "op_diamond",
	halfdia_singledraw = "halfdia_singledraw",
	check_exprank = "check_exprank",
	myst_refre = "myst_refre",
	redeem_code = "redeem_code",
	starter_water = "starter_water",
	lvl_24 = "lvl_24",
	PULL_GAMESHOW = "PULL_GAMESHOW",
	buy_skillpt = "buy_skillpt",
	fail_pokeenhance = "fail_pokeenhance",
	CLICK_OK = "CLICK_OK",
	check_pokedex = "check_pokedex",
	buy_stamina = "buy_stamina",
	pass_friend = "pass_friend",
	dia_backpack = "dia_backpack",
	preview_limitedraw = "preview_limitedraw",
	supreme_union = "supreme_union",
	check_bidchest = "check_bidchest",
	myst_master = "myst_master",
	dia_24h_1k = "1kdia_24h",
	op_pack = "op_pack",
	challenge_hardfail = "challenge_hardfail",
	pay_6 = "pay_8.99",
	add_friends = "add_friends",
	train_spot2 = "train_spot2",
	add_friends20 = "add_friends20",
	dia_24h_2k = "2kdia_24h",
	free_diasingle = "free_diasingle",
	tap_discord = "tap_discord",
	create_role = "create_role",
	check_vippack = "check_vippack",
	dispatch_diaref = "dispatch_diaref",
	NOTNETWORK_CLICK = "NOTNETWORK_CLICK",
	bidwar_10x = "10x_bidwar",
	check_recom = "check_recom",
	dia_24h_3k = "3kdia_24h",
	dia_gold10x = "dia_gold10x",
	CDN_60 = "CDN_60",
	add_friends40 = "add_friends40",
	priv_text = "priv_text",
	world_text = "world_text",
	dismantle_confirm = "dismantle_confirm",
	activity_40 = "activity_40",
	dia_device5 = "dia_device5",
	starter_fire = "starter_fire",
	female_char = "female_char",
	tap_10xpts = "tap_10xpts",
	discount_7d2 = "discount_7d2",
	dia_vippack = "dia_vippack",
	CDN_5 = "CDN_5",
	CDN_FINISH = "CDN_FINISH",
	pay_monthsub_2 = "pay_monthsub_2",
	train_spot1 = "train_spot1"
}

function lp_eu.trackEvent(ctype, data)
	print("Lua lp_eu.trackEvent")

	if eventMap[ctype] == nil then
		return
	end

	if ctype == "join_union" then
		local unionIdRecord = userDefault.getForeverLocalKey("unionIdRecord_lp_eu", nil)

		if not unionIdRecord then
			userDefault.setForeverLocalKey("unionIdRecord_lp_eu", 1)
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

function lp_eu.logout(cb)
	print("Lua lp_eu.logout")
	sdk.callPlatformFunc("logout", "game", function(info)
		print("logout ret = ", info)
		cb(0, "ok")
	end)
end

local defaultPrefix = {
	"pieuexcevo_gold_",
	2100
}
local productPrefixTagMap = {
	as_pieuexcevo_gold_aos = {
		"pieuexcevo_gold_",
		2100
	},
	as_evoumastan_gold_aos = {
		"evoumastan_gold_",
		2100
	},
	as_isanevedaned_gold_aos = {
		"isanevedaned_gold_",
		2100
	},
	as_ulegexadroanr_gold_aos = {
		"ulegexadroanr_gold_",
		2100
	},
	as_pieuiosmob_gold_ios = {
		"pieuiosmob_gold_",
		2100
	},
	as_bealeguttlosmo_gold_ios = {
		"bealeguttlosmo_gold_",
		2100
	},
	as_advgenoscimpa_gold_ios = {
		"advgenoscimpa_gold_",
		2100
	}
}

function lp_eu.pay(cpOrderId, extInfo, amount, rechargeId, productDesc, cb)
	print("Lua lp_eu.pay")

	local roleInfo = gGameModel.role
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

	local tmp = {
		count = 1,
		currency = "usd",
		roleId = stringz.bintohex(roleInfo:read("id")),
		roleName = roleInfo:read("name"),
		roleLevel = tostring(roleInfo:read("level")),
		area = gGameApp.serverInfo.name,
		area_id = tostring(roleInfo:read("area")),
		rmb = amount / 10,
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

return lp_eu
