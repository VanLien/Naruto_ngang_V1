-- chunkname: @src.app.sdk.lp_x7_en

local lp_x7_en = {}

function lp_x7_en.login(cb)
	print("Lua lp_x7_en.login")
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

function lp_x7_en.switch(cb)
	print("Lua lp_x7_en.switchAccount")
	sdk.callPlatformFunc("switchAccount", "", function(info)
		print("logout ret = ", info)
		cb(0, "ok")
	end)
end

function lp_x7_en.openCustomerService(vip)
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

function lp_x7_en.commitRoleInfo(ctype, cb)
	print("Lua lp_x7_en.commitRoleInfo")

	local funcType = 1

	if sdk.sdkChannel ~= "-1" then
		funcType = 2
	end

	local accountName = gGameModel.account:read("name")
	local game_guid = string.gsub(accountName, "lp_x7_en_", "")

	print("game_guid", game_guid)

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
		funcType = funcType,
		guid = game_guid
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
	set_motto = "set_motto",
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
	dispatch_diaref = "dispatch_diaref",
	dia_48h_10K = "10kdia_48h",
	element_chest = "element_chest",
	dia_48h_8k = "8kdia_48h",
	dispatch_diaquick = "dispatch_diaquick",
	dia_24h_5k = "5kdia_24h",
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
	myst_refre = "myst_refre",
	bidwar_10x = "10x_bidwar",
	bidwar_single = "bidwar_single",
	dia_24h_1k = "1kdia_24h",
	limitedraw_10x = "10x_limitedraw",
	dia_24h_2k = "2kdia_24h",
	timedraw_10x = "10x_timedraw",
	dia_24h_3k = "3kdia_24h",
	selctype_10x = "10x_selctype",
	trinket_10x = "10x_trinket",
	gold_10x = "10x_gold",
	diamond_10x = "10x_diamond",
	buy_skillpt = "buy_skillpt",
	buy_stamina = "buy_stamina",
	female_char = "female_char",
	male_char = "male_char",
	starter_water = "starter_water",
	starter_fire = "starter_fire",
	starter_grass = "starter_grass",
	challenge_hardfail = "challenge_hardfail",
	check_monsub = "check_monsub",
	check_powerrank = "check_powerrank",
	check_arenarank = "check_arenarank",
	check_advroadrank = "check_advroadrank",
	check_exprank = "check_exprank",
	check_goldrank = "check_goldrank",
	arenawin_replay = "arenawin_replay",
	fail_trinketenhance = "fail_trinketenhance",
	fail_pokeenhance = "fail_pokeenhance",
	fail_again = "fail_again",
	fail_draw = "fail_draw",
	check_aetherrank = "check_aetherrank",
	tap_diaplus = "tap_diaplus",
	check_vippack = "check_vippack",
	tap_buypass = "tap_buypass",
	use_raid50 = "use_raid50",
	event_powerrank = "event_powerrank",
	dismantle_confirm = "dismantle_confirm",
	check_bidchest = "check_bidchest",
	check_bidpoint = "check_bidpoint",
	check_allpack = "check_allpack",
	check_pokedex = "check_pokedex",
	tap_10xpts = "tap_10xpts",
	preview_limitedraw = "preview_limitedraw",
	preview_diadraw = "preview_diadraw",
	preview_timedraw = "preview_timedraw",
	check_allfirst = "check_allfirst",
	pay_13 = "pay_99.99",
	pay_12 = "pay_49.99",
	pay_11 = "pay_29.99",
	pay_10 = "pay_25.99",
	pay_9 = "pay_19.99",
	pay_8 = "pay_14.99",
	pay_7 = "pay_12.99",
	pay_6 = "pay_8.99",
	pay_5 = "pay_4.99",
	pay_4 = "pay_3.99",
	pay_3 = "pay_2.99",
	pay_2 = "pay_1.99",
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
	free_devicedraw = "free_devicedraw",
	challenge_arena = "challenge_arena",
	claim_hoopa = "claim_hoopa",
	claim_stamina = "claim_stamina",
	check_gameannou = "check_gameannou",
	edit_annou = "edit_annou",
	free_goldsingle = "free_goldsingle",
	free_diasingle = "free_diasingle",
	claim_mail = "claim_mail"
}

function lp_x7_en.trackEvent(ctype, data)
	print("Lua lp_x7_en.trackEvent")

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

function lp_x7_en.logout(cb)
	print("Lua lp_x7_en.logout")
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
	xiao7_gold_ios_yidun_v4 = {
		"trialssaga_gold_",
		2100
	}
}

function lp_x7_en.pay(cpOrderId, extInfo, amount, rechargeId, productDesc, cb)
	print("Lua lp.pay")

	local roleInfo = gGameModel.role
	local account = gGameModel.account
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

	local accountName = gGameModel.account:read("name")
	local game_guid = string.gsub(accountName, "lp_x7_en_", "")

	print("game_guid:" .. game_guid)

	local tmp = {
		sdkversion = "7.98",
		sign = "",
		notify_id = "-1",
		currency = "USD",
		count = 1,
		roleId = stringz.bintohex(roleInfo:read("id")),
		roleName = roleInfo:read("name"),
		roleLevel = tostring(roleInfo:read("level")),
		area = gGameApp.serverInfo.name,
		area_id = tostring(roleInfo:read("area")),
		rmb = tostring(string.format("%.2f", amount / 10)),
		rmbDisplay = tostring(string.format("%.2f", payInfo.rmbDisplay)),
		amount = amount,
		extInfo = extInfo,
		productDesc = productDesc,
		productName = productDesc,
		orderId = cpOrderId,
		productID = productID,
		guid = game_guid
	}
	local vipSum = gGameModel.role:read("vip_sum")
	local params = string.format("extends_info_data=%s&game_access_version=%s&game_area=%s&game_currency=%s&game_guid=%s&game_level=%s&game_orderid=%s&game_price=%s&game_role_id=%s&game_role_name=%s&notify_id=%s&subject=%s", tmp.extInfo, tmp.sdkversion, tmp.area_id, tmp.currency, game_guid, tmp.roleLevel, cpOrderId, tmp.rmbDisplay, tmp.roleId, tmp.roleName, tmp.notify_id, tmp.productName)
	local base64 = require("3rd.base64")

	gGameApp.net:sendHttpRequest("POST", "http://94.74.92.71:28081/lp_x7_en/create", base64.enc(params), cc.XMLHTTPREQUEST_RESPONSE_STRING, function(xhr)
		if xhr.status == 200 then
			local t = json.decode(xhr.response)

			tmp.sign = t.sign

			sdk.callPlatformFunc("pay", json.encode(tmp), function(info)
				print("pay ret = ", info)

				if info == "ok" then
					cb(0, info)
				else
					cb(-1, "error")
				end
			end)
		else
			print("POST game_sign order Error", APP_CHANNEL, xhr.status, xhr.statusText)
			cb(-1, "error")
		end
	end)
end

return lp_x7_en
