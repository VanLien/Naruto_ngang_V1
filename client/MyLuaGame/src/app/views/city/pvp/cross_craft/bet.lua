local function var_0_0(arg_1_0, arg_1_1, arg_1_2)
	arg_1_1:removeChildByName("_lock_res_")

	if not arg_1_0 then
		return
	end

	local var_1_0 = arg_1_1:size()
	local var_1_1 = cc.p(var_1_0.width * 0.5, var_1_0.height * 0.5)

	arg_1_2 = arg_1_2 or {}

	return (ccui.ImageView:create(arg_1_2.res or "common/btn/btn_lock1.png"):xy(arg_1_2.pos or var_1_1):scale(arg_1_2.scale or 1):addTo(arg_1_1, arg_1_2.zOrder or 10, "_lock_res_"))
end

local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("CrossCraftBetView", var_0_1)

var_0_2.RESOURCE_FILENAME = "cross_craft_bet.json"
var_0_2.RESOURCE_BINDING = {
	noBetPanel = "noBetPanel",
	betPanel = "betPanel",
	["leftPanel.tabItem"] = "tabItem",
	["betPanel.betItem"] = "betItem",
	["betPanel.btnRule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleClick")
			}
		}
	},
	["betPanel.btnRule.textRule"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["betPanel.list"] = {
		varname = "betList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("betDatas"),
				canBet = bindHelper.self("canBet"),
				dataOrderCmp = function(arg_2_0, arg_2_1)
					if arg_2_1.role.point and arg_2_0.role.point then
						if arg_2_1.role.point < arg_2_0.role.point then
							return arg_2_1.role.point < arg_2_0.role.point
						elseif arg_2_1.role.point == arg_2_0.role.point then
							return arg_2_1.role.fighting_point < arg_2_0.role.fighting_point
						else
							return false
						end
					elseif arg_2_1.fighting_point and arg_2_0.fighting_point then
						return arg_2_1.fighting_point < arg_2_0.fighting_point
					else
						return false
					end
				end,
				item = bindHelper.self("betItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:get("imgBg")

					if arg_3_3.betType == 1 then
						var_3_0:setTouchEnabled(true)
						var_3_0:onClick(functools.partial(arg_3_0.clickHead, arg_3_2, arg_3_3.role))
					else
						var_3_0:setTouchEnabled(false)
					end

					local var_3_1 = arg_3_1:multiget("trainerIcon", "txtName", "txtLv", "txtNormal", "imgNormal", "txtHigh", "imgHigh", "btnNormal", "btnHigh", "imgBets")

					bind.extend(arg_3_0, var_3_1.trainerIcon, {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_3_3.role.logo,
							frameId = arg_3_3.role.frame,
							onNode = function(arg_4_0)
								arg_4_0:xy(96, 100):z(6):scale(0.8)
							end
						}
					})
					var_3_1.txtName:text(arg_3_3.role.name)
					var_3_1.txtLv:text(arg_3_3.role.level)

					local var_3_2 = gGameModel.cross_craft:read("servers")

					bind.touch(arg_3_0, var_3_1.btnNormal, {
						methods = {
							ended = functools.partial(arg_3_0.clickBet, var_3_2[1], arg_3_3.role.id or arg_3_3.role.role_db_id, "gold")
						}
					})
					cache.setShader(var_3_1.btnNormal, false, arg_3_0.canBet:read() and "normal" or "hsl_gray")

					if arg_3_0.canBet:read() then
						text.addEffect(var_3_1.btnNormal:getChildByName("txtNode"), {
							outline = {
								color = ui.NEWCOLORS.OUTLINE.BLUE
							}
						})
					end

					bind.touch(arg_3_0, var_3_1.btnHigh, {
						methods = {
							ended = functools.partial(arg_3_0.clickBet, var_3_2[1], arg_3_3.role.id or arg_3_3.role.role_db_id, "coin8")
						}
					})
					cache.setShader(var_3_1.btnHigh, false, arg_3_0.canBet:read() and "normal" or "hsl_gray")

					if arg_3_0.canBet:read() then
						text.addEffect(var_3_1.btnHigh:getChildByName("txtNode"), {
							outline = {
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							}
						})
					end

					local var_3_3 = {
						{
							gold = csv.cross.craft.base[1].preBetGold,
							coin8 = csv.cross.craft.base[1].preBetCoin
						},
						{
							gold = csv.cross.craft.base[1].top4BetGold,
							coin8 = csv.cross.craft.base[1].top4BetCoin
						},
						{
							gold = csv.cross.craft.base[1].championBetGold,
							coin8 = csv.cross.craft.base[1].championBetCoin
						}
					}

					if arg_3_0.checkPreResult() == true and arg_3_3.betType == 1 then
						nodetools.invoke(arg_3_1, {
							"btnNormal",
							"btnHigh",
							"txtNormal",
							"txtHigh",
							"imgNormal",
							"imgHigh",
							"imgBets",
							"imgBet",
							"txtBet"
						}, "hide")
					elseif arg_3_3.coinType then
						nodetools.invoke(arg_3_1, {
							"imgBets",
							"imgBet",
							"txtBet"
						}, "show")

						if arg_3_3.coinType == "gold" then
							arg_3_1:get("imgBet"):texture("common/icon/icon_gold.png")
							arg_3_1:get("txtBet"):text(mathEasy.getShortNumber(var_3_3[arg_3_3.betType].gold, 2))
						else
							arg_3_1:get("imgBet"):texture("common/icon/icon_kfsydhdb1.png")
							arg_3_1:get("txtBet"):text(mathEasy.getShortNumber(var_3_3[arg_3_3.betType].coin8, 2))
						end

						nodetools.invoke(arg_3_1, {
							"btnNormal",
							"btnHigh",
							"txtNormal",
							"txtHigh",
							"imgNormal",
							"imgHigh"
						}, "hide")
					else
						nodetools.invoke(arg_3_1, {
							"imgBets",
							"imgBet",
							"txtBet"
						}, "hide")
						nodetools.invoke(arg_3_1, {
							"btnNormal",
							"btnHigh",
							"txtNormal",
							"txtHigh",
							"imgNormal",
							"imgHigh"
						}, "show")
					end

					var_3_1.txtNormal:text(mathEasy.getShortNumber(var_3_3[arg_3_3.betType].gold, 2))
					var_3_1.txtHigh:text(mathEasy.getShortNumber(var_3_3[arg_3_3.betType].coin8, 2))

					if arg_3_3.betType == 1 then
						arg_3_1:get("top4Panel"):hide()
						arg_3_1:get("championPanel"):hide()

						if arg_3_0.checkPreResult() == true then
							local var_3_4 = arg_3_1:get("preResultPanel"):show()

							arg_3_1:get("prePanel"):hide()

							if arg_3_2 <= 3 then
								local var_3_5 = {
									"icon_jp.png",
									"icon_yp.png",
									"icon_tp.png"
								}

								var_3_4:get("txtRank"):hide()
								var_3_4:get("imgRank"):show():texture("city/rank/" .. var_3_5[arg_3_2])
							else
								var_3_4:get("txtRank"):show():text(arg_3_2)
								var_3_4:get("imgRank"):hide()
							end

							arg_3_1:get("trainerIcon"):x(420)
							arg_3_1:get("txtName"):xy(533, 94)
							arg_3_1:get("txtLv"):hide()
							arg_3_1:get("txtNode"):hide()
							var_3_4:get("txtPoint"):text(arg_3_3.role.point or "--")
							var_3_4:get("txtFight"):text(arg_3_3.role.fighting_point or arg_3_3.fighting_point)
							var_3_4:get("txtLv"):text(arg_3_3.role.level)
						else
							arg_3_1:get("preResultPanel"):hide()
							arg_3_1:get("trainerIcon"):x(106)
							arg_3_1:get("txtName"):y(94)
							arg_3_1:get("txtNode"):hide()
							arg_3_1:get("txtLv"):hide()

							local var_3_6 = arg_3_1:get("prePanel"):show()

							arg_3_1:get("top4Panel"):hide()
							arg_3_1:get("championPanel"):hide()
							var_3_6:get("txtFight"):text(arg_3_3.fighting_point)
							var_3_6:get("txtLv"):text(arg_3_3.role.level)
						end
					elseif arg_3_3.betType == 2 then
						arg_3_1:get("preResultPanel"):hide()
						arg_3_1:get("prePanel"):hide()

						local var_3_7 = arg_3_1:get("top4Panel"):show()

						arg_3_1:get("trainerIcon"):x(126)
						arg_3_1:get("txtName"):xy(264, 127)
						arg_3_1:get("championPanel"):hide()
						var_3_7:get("txtFight"):text(arg_3_3.fighting_point)
						var_3_7:get("txtServer"):text(getServerArea(arg_3_3.role.game_key, true))
					else
						arg_3_1:get("preResultPanel"):hide()
						arg_3_1:get("prePanel"):hide()
						arg_3_1:get("top4Panel"):hide()
						arg_3_1:get("trainerIcon"):x(126)
						arg_3_1:get("txtName"):xy(264, 127)

						local var_3_8 = arg_3_1:get("championPanel"):show()
						local var_3_9 = var_3_8:get("txtNormal")
						local var_3_10 = var_3_8:get("txtHigh")
						local var_3_11 = var_3_8:get("imgNormal")
						local var_3_12 = var_3_8:get("imgHigh")

						var_3_8:get("txtFight"):text(arg_3_3.fighting_point)
						var_3_8:get("txtServer"):text(getServerArea(arg_3_3.role.game_key, true))
						var_3_9:text(mathEasy.getPreciseDecimal(arg_3_3.gold_rate, 2, false))
						var_3_10:text(mathEasy.getPreciseDecimal(arg_3_3.coin_rate, 2, false))

						if arg_3_3.coinType then
							if arg_3_3.coinType == "gold" then
								var_3_12:hide()
								var_3_10:hide()
								var_3_11:show():x(1201)
								var_3_9:show():x(1201)
							else
								var_3_11:hide()
								var_3_9:hide()
								var_3_12:show():x(1201)
								var_3_10:show():x(1201)
							end

							nodetools.invoke(arg_3_1, {
								"btnNormal",
								"btnHigh",
								"txtNormal",
								"txtHigh",
								"imgNormal",
								"imgHigh"
							}, "hide")
						else
							var_3_11:show():x(1152)
							var_3_9:show():x(1152)
							var_3_12:show():x(1261)
							var_3_10:show():x(1261)
						end
					end
				end
			},
			handlers = {
				clickHead = bindHelper.self("onHeadClick"),
				clickBet = bindHelper.self("onClickBet"),
				checkPreResult = bindHelper.self("checkPreResult")
			}
		}
	},
	["leftPanel.tabList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatas"),
				betType = bindHelper.self("betType"),
				item = bindHelper.self("tabItem"),
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					local var_5_0 = arg_5_1:get("normal")
					local var_5_1 = arg_5_1:get("selected")
					local var_5_2

					if arg_5_3.select then
						var_5_0:hide()

						var_5_2 = var_5_1:show()
					else
						var_5_1:hide()

						var_5_2 = var_5_0:show()

						var_5_2:get("txt2"):text(arg_5_3.subName)
					end

					adapt.setTextScaleWithWidth(var_5_2:get("txt"), arg_5_3.name, 300)
					var_5_1:setTouchEnabled(false)
					bind.touch(arg_5_0, var_5_0, {
						methods = {
							ended = functools.partial(arg_5_0.clickCell, arg_5_2, arg_5_3)
						}
					})
					var_0_0(arg_5_3.isLocked and not arg_5_3.select, var_5_0, {
						pos = cc.p(290, 120)
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabItemClick")
			}
		}
	},
	["leftBottomPanel.text2"] = {
		varname = "textTime"
	},
	["betPanel.textJC"] = {
		varname = "textJC"
	},
	["betPanel.rolePanel1"] = {
		varname = "rolePanel1",
		binds = {
			event = "visible",
			idler = bindHelper.self("betType"),
			method = function(arg_6_0)
				return arg_6_0 ~= 3
			end
		}
	},
	["betPanel.rolePanel2"] = {
		varname = "rolePanel2"
	},
	["betPanel.rolePanel3"] = {
		varname = "rolePanel3",
		binds = {
			event = "visible",
			idler = bindHelper.self("betType"),
			method = function(arg_7_0)
				return arg_7_0 ~= 3
			end
		}
	}
}

function var_0_2.checkPreResult(arg_8_0)
	local var_8_0 = arg_8_0.round:read()

	if var_8_0 == "closed" then
		return true
	end

	local var_8_1 = 0
	local var_8_2 = 0

	for iter_8_0, iter_8_1 in ipairs(game.CROSS_CRAFT_ROUNDS) do
		if iter_8_1 == var_8_0 then
			var_8_1 = iter_8_0
		elseif iter_8_1 == "top64" then
			var_8_2 = iter_8_0
		end
	end

	return var_8_2 <= var_8_1
end

function var_0_2.checkFinalResult(arg_9_0)
	return arg_9_0.round:read() == "closed"
end

function var_0_2.checkCanPreBet(arg_10_0)
	return arg_10_0.round:read() == "signup"
end

function var_0_2.checkCanFinalBet(arg_11_0)
	return arg_11_0.round:read() == "halftime"
end

function var_0_2.initRoleData(arg_12_0, arg_12_1, arg_12_2)
	if arg_12_1 then
		arg_12_2:get("txtName"):text(arg_12_1.role.name)
		arg_12_2:get("txtLv"):text("Lv" .. arg_12_1.role.level)

		local var_12_0 = arg_12_2:get("imgBets")

		var_12_0:ignoreContentAdaptWithSize(true)

		local var_12_1 = false

		if arg_12_0.betType:read() == 1 then
			if arg_12_0:checkPreResult() == false then
				var_12_0:texture("city/pvp/cross_craft/txt/txt_yxz.png")
			elseif arg_12_1.success == false then
				var_12_0:texture("city/pvp/cross_craft/txt/txt_jcsb.png")

				var_12_1 = true
			elseif arg_12_1.success == true then
				var_12_0:texture("city/pvp/cross_craft/txt/txt_jccg.png")
			end
		elseif arg_12_0.betType:read() == 2 then
			if arg_12_0:checkFinalResult() == false then
				var_12_0:texture("city/pvp/cross_craft/txt/txt_yxz.png")
			elseif arg_12_1.success == false then
				var_12_0:texture("city/pvp/cross_craft/txt/txt_jcsb.png")

				var_12_1 = true
			elseif arg_12_1.success == true then
				var_12_0:texture("city/pvp/cross_craft/txt/txt_jccg.png")
			end
		elseif arg_12_0.betType:read() == 3 then
			if arg_12_0:checkFinalResult() == false then
				var_12_0:texture("city/pvp/cross_craft/txt/txt_yxz.png")
			else
				local var_12_2 = gGameModel.cross_craft:read("last_top8_plays").final.champion

				if (var_12_2.result == "win" and var_12_2.role1 or var_12_2.role2).role_db_id ~= arg_12_1.role.role_db_id then
					var_12_0:texture("city/pvp/cross_craft/txt/txt_jcsb.png")

					var_12_1 = true
				else
					var_12_0:texture("city/pvp/cross_craft/txt/txt_jccg.png")
				end
			end
		end

		bind.extend(arg_12_0, arg_12_2:get("trainerIcon"), {
			class = "role_logo",
			props = {
				vip = false,
				level = false,
				logoId = arg_12_1.role.logo,
				frameId = arg_12_1.role.frame,
				onNode = function(arg_13_0)
					arg_13_0:xy(96, 100):z(6)

					if var_12_1 then
						local var_13_0 = cc.c3b(128, 128, 128)

						arg_13_0:get("logoClipping"):get("logo"):color(var_13_0)
					end
				end
			}
		})
	else
		arg_12_2:get("txtName"):text("")
		arg_12_2:get("txtLv"):text("")

		local var_12_3 = arg_12_2:get("imgBets")

		var_12_3:ignoreContentAdaptWithSize(true)

		if arg_12_0.betType:read() == 1 then
			if arg_12_0:checkCanPreBet() == false then
				var_12_3:texture("city/pvp/cross_craft/txt/txt_wxz.png")
			else
				var_12_3:texture("city/pvp/cross_craft/txt/txt_ddxz.png"):show()
			end
		elseif arg_12_0:checkCanFinalBet() == false then
			var_12_3:texture("city/pvp/cross_craft/txt/txt_wxz.png")
		else
			var_12_3:texture("city/pvp/cross_craft/txt/txt_ddxz.png"):show()
		end

		bind.extend(arg_12_0, arg_12_2:get("trainerIcon"), {
			class = "role_logo",
			props = {
				vip = false,
				level = false,
				logoId = gGameModel.role:getIdler("logo"),
				frameId = gGameModel.role:getIdler("frame"),
				onNode = function(arg_14_0)
					arg_14_0:x(96)
					arg_14_0:removeChildByName("frameSpine")
					arg_14_0:get("frame"):texture("city/pvp/craft/mainschedule/panel_head_blue.png"):show()
					arg_14_0:get("logoClipping"):get("logo"):hide()
					ccui.ImageView:create("city/pvp/cross_craft/txt/txt_wh.png"):alignCenter(arg_14_0:size()):addTo(arg_14_0, 3)
				end
			}
		})
	end
end

function var_0_2.initBettedRole(arg_15_0, arg_15_1)
	local var_15_0 = true

	if arg_15_0.betType:read() == 2 or arg_15_0.betType:read() == 1 then
		for iter_15_0 = 1, 3 do
			local var_15_1 = arg_15_0["rolePanel" .. iter_15_0]:show()
			local var_15_2 = arg_15_1[iter_15_0]

			arg_15_0:initRoleData(var_15_2, var_15_1)

			if var_15_2 == nil or var_15_2.success == false then
				var_15_0 = false
			end
		end

		local var_15_3 = userDefault.getForeverLocalKey("crossCraftHasShowed" .. arg_15_0.betType:read(), 0)

		if var_15_0 and var_15_3 == 0 and arg_15_0.round:read() == "closed" then
			gGameUI:stackUI("city.pvp.cross_craft.extra_award", nil, {
				clickClose = true
			}, {
				type = arg_15_0.betType:read(),
				roleData = arg_15_1
			})
			userDefault.setForeverLocalKey("crossCraftHasShowed" .. arg_15_0.betType:read(), 1)
		end
	else
		local var_15_4 = arg_15_0.rolePanel2:show()
		local var_15_5 = arg_15_1[1]

		arg_15_0:initRoleData(var_15_5, var_15_4)
	end
end

function var_0_2.onCreate(arg_16_0, arg_16_1)
	gGameUI.topuiManager:createView("cross_craft", arg_16_0, {
		onClose = arg_16_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = "common/txt/txt_bt_kuafurenzhedasai.png"
	})

	local var_16_0 = arg_16_0.betPanel:get("imgBg"):size()

	arg_16_0:initData(arg_16_1[1], arg_16_1[2])
	arg_16_0:addTabListClipping()
	arg_16_0:initModel()

	arg_16_0.betDatas = idlers.newWithMap({})

	local var_16_1 = {
		{
			isLocked = false,
			select = false,
			subName = "Preliminary",
			name = gLanguageCsv.preBet,
			strJc = gLanguageCsv.preBetTips
		},
		{
			isLocked = false,
			select = false,
			subName = "Top 4",
			name = gLanguageCsv.fourBet,
			strJc = gLanguageCsv.fourBetTips
		},
		{
			isLocked = false,
			select = false,
			subName = "Champion",
			name = gLanguageCsv.champtionBet,
			strJc = gLanguageCsv.champtionBetTips
		}
	}

	arg_16_0.tabDatas = idlers.newWithMap(var_16_1)
	arg_16_0.betType = idler.new(1)

	idlereasy.any({
		arg_16_0.betType,
		arg_16_0.round
	}, function(arg_17_0, arg_17_1, arg_17_2)
		local var_17_0 = false

		if arg_17_2 == "closed" or arg_17_2 == "prepare" or arg_17_2 == "prepare2" then
			var_17_0 = false
		elseif arg_17_1 == 1 then
			if arg_17_2 == "signup" then
				var_17_0 = #arg_16_0.data.bettedData[arg_17_1] < 3
			end
		elseif arg_17_1 == 2 then
			if arg_17_2 == "halftime" then
				var_17_0 = #arg_16_0.data.bettedData[arg_17_1] < 3
			end
		elseif arg_17_2 == "halftime" then
			var_17_0 = #arg_16_0.data.bettedData[arg_17_1] < 1
		end

		arg_16_0.canBet:set(var_17_0)

		local var_17_1 = tonumber(time.getTodayStrInClock(10))

		if arg_17_2 == "signup" or arg_17_2 == "prepare" or string.find(arg_17_2, "pre1") or string.find(arg_17_2, "pre2") then
			arg_16_0.tabDatas:atproxy(2).isLocked = true
			arg_16_0.tabDatas:atproxy(3).isLocked = true
		elseif arg_17_2 == "halftime" then
			arg_16_0.tabDatas:atproxy(2).isLocked = false
			arg_16_0.tabDatas:atproxy(3).isLocked = false
		end

		arg_16_0:initBettedRole(arg_16_0.data.bettedData[arg_17_1])
	end)
	arg_16_0.round:addListener(function(arg_18_0, arg_18_1)
		if arg_18_0 == "closed" and arg_18_1 == "final3_lock" or arg_18_0 == "top64" and arg_18_1 == "pre34_lock" then
			gGameApp:requestServer("/game/cross/craft/bet/info", function(arg_19_0)
				arg_16_0:initData(arg_19_0.view, nil)
				arg_16_0:initBettedRole(arg_16_0.data.bettedData[arg_16_0.betType:read()])
			end)
		end
	end)
	arg_16_0.betType:addListener(function(arg_20_0, arg_20_1)
		arg_16_0.tabDatas:atproxy(arg_20_1).select = false
		arg_16_0.tabDatas:atproxy(arg_20_0).select = true

		local var_20_0 = 0
		local var_20_1 = arg_20_0 == 1 and arg_16_0:checkPreResult() and 0 or arg_20_0

		for iter_20_0 = 0, 3 do
			arg_16_0.betPanel:get("imgBg"):get("panel" .. iter_20_0):setVisible(var_20_1 == iter_20_0)
		end

		local var_20_2 = {
			"txt_yxjc.png",
			"txt_4qjc.png",
			"txt_gjjc.png"
		}

		arg_16_0.betPanel:get("imgBg"):get("imgJC"):texture("city/pvp/cross_craft/txt/" .. var_20_2[arg_20_0])
		arg_16_0.betDatas:update(arg_16_0.data.canBetData[arg_20_0])
		arg_16_0.textJC:text(var_16_1[arg_20_0].strJc)

		if matchLanguage({
			"en"
		}) then
			arg_16_0.textJC:height(85)
			arg_16_0.textJC:ignoreContentAdaptWithSize(false)
			arg_16_0.textJC:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		end

		if arg_20_0 == 1 and arg_16_0:checkPreResult() then
			arg_16_0.textJC:text(gLanguageCsv.crossCraftPreResult)
		end

		if arg_20_0 == 1 then
			arg_16_0.textTime:text(gLanguageCsv.battleFirstDay)
		else
			arg_16_0.textTime:text(gLanguageCsv.battleSecondDay)
		end
	end)

	local var_16_2 = arg_16_0.round:read()

	if arg_16_0.round:read() ~= "closed" then
		local var_16_3 = time.getNumTimestamp(arg_16_0.craftDate) + 122400 - time.getTime()

		if var_16_3 >= 0 then
			performWithDelay(arg_16_0, function()
				arg_16_0.tabDatas:atproxy(2).isLocked = false
				arg_16_0.tabDatas:atproxy(3).isLocked = false
			end, var_16_3)
		end
	end

	if arg_16_0.round:read() ~= "closed" then
		for iter_16_0 = 1, 3 do
			userDefault.setForeverLocalKey("crossCraftHasShowed" .. iter_16_0, 0)
		end
	end
end

function var_0_2.initData(arg_22_0, arg_22_1, arg_22_2)
	if arg_22_2 ~= nil then
		arg_22_0.rankData = arg_22_2.rank
	else
		arg_22_0.rankData = arg_22_0.rankData or {}
	end

	local var_22_0 = {
		bettedData = {
			{},
			{},
			{}
		},
		canBetData = {
			{},
			{},
			{}
		}
	}

	for iter_22_0, iter_22_1 in ipairs(arg_22_1.pre_bet) do
		table.insert(var_22_0.bettedData[1], iter_22_1)
	end

	for iter_22_2, iter_22_3 in ipairs(arg_22_1.top4_bet) do
		table.insert(var_22_0.bettedData[2], iter_22_3)
	end

	if arg_22_1.mychampion_bet[2] ~= "" then
		var_22_0.bettedData[3][1] = {
			role = {
				role_db_id = arg_22_1.mychampion_bet[1]
			},
			coin = arg_22_1.mychampion_bet[2]
		}
	end

	for iter_22_4, iter_22_5 in pairs(arg_22_0.rankData) do
		iter_22_5.betType = 1

		table.insert(var_22_0.canBetData[1], iter_22_5)
	end

	for iter_22_6, iter_22_7 in pairs(arg_22_1.champion_bet) do
		iter_22_7.betType = 2

		table.insert(var_22_0.canBetData[2], iter_22_7)

		local var_22_1 = clone(iter_22_7)

		var_22_1.betType = 3

		table.insert(var_22_0.canBetData[3], var_22_1)
	end

	for iter_22_8 = 1, 3 do
		for iter_22_9, iter_22_10 in pairs(var_22_0.bettedData[iter_22_8]) do
			for iter_22_11, iter_22_12 in pairs(var_22_0.canBetData[iter_22_8]) do
				if iter_22_10.role.role_db_id == iter_22_12.role.id or iter_22_10.role.role_db_id == iter_22_12.role.role_db_id then
					var_22_0.canBetData[iter_22_8][iter_22_11].coinType = iter_22_10.coin

					if iter_22_8 == 3 then
						var_22_0.bettedData[3][iter_22_9].role = iter_22_12.role
					end

					break
				end
			end
		end
	end

	arg_22_0.data = var_22_0
end

function var_0_2.initModel(arg_23_0)
	arg_23_0.round = gGameModel.cross_craft:getIdler("round")
	arg_23_0.gold = gGameModel.role:getIdler("gold")
	arg_23_0.coin8 = gGameModel.role:getIdler("coin8")
	arg_23_0.canBet = idler.new(false)
	arg_23_0.craftDate = gGameModel.cross_craft:read("date")
end

function var_0_2.onHeadClick(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	local var_24_0 = arg_24_3.role_db_id or arg_24_3.id

	if gGameModel.role:read("id") == var_24_0 then
		return
	end

	local var_24_1 = arg_24_4.target
	local var_24_2, var_24_3 = var_24_1:xy()
	local var_24_4 = var_24_1:getParent():convertToWorldSpace(cc.p(var_24_2, var_24_3))
	local var_24_5 = {
		role = {
			level = arg_24_3.level,
			id = var_24_0,
			vip = arg_24_3.vip_level,
			name = arg_24_3.name,
			logo = arg_24_3.logo,
			frame = arg_24_3.frame
		}
	}

	gGameUI:stackUI("city.chat.personal_info", nil, {
		clickClose = true,
		dispatchNodes = arg_24_1
	}, var_24_4, var_24_5, {
		speical = "rank",
		disableTouch = true,
		target = arg_24_1.item:get("imgBg")
	})
end

function var_0_2.onClickBet(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	local var_25_0 = arg_25_0.betType:read()
	local var_25_1 = arg_25_0.round:read()

	if var_25_1 == "closed" then
		gGameUI:showTip(gLanguageCsv.craftCanNotBet)

		return
	end

	local var_25_2 = arg_25_0.tabDatas:atproxy(var_25_0).isLocked

	if var_25_0 == 1 then
		if var_25_1 == "signup" then
			if #arg_25_0.data.bettedData[var_25_0] >= 3 then
				gGameUI:showTip(gLanguageCsv.betTimesUseUp)

				return
			end
		else
			gGameUI:showTip(gLanguageCsv.craftCanNotBet)

			return
		end
	elseif var_25_0 == 2 then
		local var_25_3 = time.getNowDate()
		local var_25_4 = tonumber(var_25_3.year .. var_25_3.month .. var_25_3.day)

		if var_25_1 == "halftime" and not var_25_2 then
			if #arg_25_0.data.bettedData[var_25_0] >= 3 then
				gGameUI:showTip(gLanguageCsv.betTimesUseUp)

				return
			end
		else
			gGameUI:showTip(gLanguageCsv.craftCanNotBet)

			return
		end
	else
		local var_25_5 = time.getNowDate()
		local var_25_6 = tonumber(var_25_5.year .. var_25_5.month .. var_25_5.day)

		if var_25_1 == "halftime" and not var_25_2 then
			if #arg_25_0.data.bettedData[var_25_0] >= 1 then
				gGameUI:showTip(gLanguageCsv.betTimesUseUp)

				return
			end
		else
			gGameUI:showTip(gLanguageCsv.craftCanNotBet)

			return
		end
	end

	local var_25_7 = {
		{
			gold = "preBetGold",
			coin = "preBetCoin"
		},
		{
			gold = "top4BetGold",
			coin = "top4BetCoin"
		},
		{
			gold = "championBetGold",
			coin = "championBetCoin"
		}
	}

	if arg_25_4 == "gold" then
		if arg_25_0.gold:read() < csv.cross.craft.base[1][var_25_7[var_25_0].gold] then
			uiEasy.showDialog("gold")

			return
		end
	elseif arg_25_0.coin8:read() < csv.cross.craft.base[1][var_25_7[var_25_0].coin] then
		uiEasy.showDialog("coin8")

		return
	end

	local var_25_8 = false

	if arg_25_0.betType:read() == 2 then
		for iter_25_0, iter_25_1 in pairs(arg_25_0.data.bettedData[3]) do
			if arg_25_3 == iter_25_1.role.id or arg_25_3 == iter_25_1.role.role_db_id then
				var_25_8 = true
			end
		end
	elseif arg_25_0.betType:read() == 3 then
		for iter_25_2, iter_25_3 in pairs(arg_25_0.data.bettedData[2]) do
			if arg_25_3 == iter_25_3.role.id or arg_25_3 == iter_25_3.role.role_db_id then
				var_25_8 = true
			end
		end
	end

	if var_25_8 == true then
		gGameUI:showTip(gLanguageCsv.fourBetSameAsChampion)

		return
	end

	if arg_25_0.betType:read() == 2 or arg_25_0.betType:read() == 3 then
		local var_25_9 = "crossCraftBetTips" .. arg_25_0.craftDate
		local var_25_10 = userDefault.getForeverLocalKey(var_25_9, "first")

		if var_25_10 == "first" or var_25_10 == "true" then
			gGameUI:showDialog({
				btnType = 2,
				title = gLanguageCsv.spaceTips,
				content = gLanguageCsv.fourBetSameAsChampionTips,
				selectKey = var_25_9,
				cb = function()
					arg_25_0:requsetBet(arg_25_2, arg_25_3, arg_25_4)
				end
			})
		else
			arg_25_0:requsetBet(arg_25_2, arg_25_3, arg_25_4)
		end
	else
		arg_25_0:requsetBet(arg_25_2, arg_25_3, arg_25_4)
	end
end

function var_0_2.requsetBet(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	local var_27_0 = arg_27_0.betType:read()

	gGameApp:requestServer("/game/cross/craft/bet", function(arg_28_0)
		arg_27_0.data.bettedData[1] = {}
		arg_27_0.data.bettedData[2] = {}
		arg_27_0.data.bettedData[3] = {}

		for iter_28_0, iter_28_1 in ipairs(arg_28_0.view.pre_bet) do
			table.insert(arg_27_0.data.bettedData[1], iter_28_1)
		end

		for iter_28_2, iter_28_3 in ipairs(arg_28_0.view.top4_bet) do
			table.insert(arg_27_0.data.bettedData[2], iter_28_3)
		end

		if arg_28_0.view.mychampion_bet[2] ~= "" then
			arg_27_0.data.bettedData[3][1] = {
				role = {
					role_db_id = arg_28_0.view.mychampion_bet[1]
				},
				coin = arg_28_0.view.mychampion_bet[2]
			}
		end

		for iter_28_4 = 1, 3 do
			for iter_28_5, iter_28_6 in pairs(arg_27_0.data.bettedData[iter_28_4]) do
				for iter_28_7, iter_28_8 in pairs(arg_27_0.data.canBetData[iter_28_4]) do
					if iter_28_6.role.role_db_id == iter_28_8.role.id or iter_28_6.role.role_db_id == iter_28_8.role.role_db_id then
						arg_27_0.data.canBetData[iter_28_4][iter_28_7].coinType = iter_28_6.coin

						if iter_28_4 == 3 then
							arg_27_0.data.bettedData[3][iter_28_5].role = iter_28_8.role
						end

						break
					end
				end
			end
		end

		if var_27_0 == 1 or var_27_0 == 2 then
			arg_27_0.canBet:set(#arg_27_0.data.bettedData[var_27_0] < 3)
		else
			arg_27_0.canBet:set(#arg_27_0.data.bettedData[var_27_0] < 1)
		end

		dataEasy.tryCallFunc(arg_27_0.betList, "updatePreloadCenterIndexAdaptFirst")
		arg_27_0.betDatas:update(clone(arg_27_0.data.canBetData[var_27_0]))
		arg_27_0:initBettedRole(arg_27_0.data.bettedData[var_27_0])
	end, arg_27_0.betType:read(), arg_27_1, arg_27_2, arg_27_3)
end

function var_0_2.onTabItemClick(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	if arg_29_3.isLocked then
		gGameUI:showTip(gLanguageCsv.crossCraftBetTip)

		return
	end

	dataEasy.tryCallFunc(arg_29_0.betList, "setItemAction", {
		isAction = true
	})
	arg_29_0.betType:set(arg_29_2)
end

function var_0_2.onRuleClick(arg_30_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_30_0:createHandler("getRuleContext"), {
		width = 1500
	})
end

function var_0_2.getRuleContext(arg_31_0, arg_31_1)
	local var_31_0 = adaptContext
	local var_31_1 = {
		{
			start = 80001,
			title = 138,
			_end = 80100
		},
		{
			start = 81001,
			title = 139,
			_end = 81100
		},
		{
			start = 82001,
			title = 140,
			_end = 82100
		}
	}

	return {
		var_31_0.clone(arg_31_1.title, function(arg_32_0)
			arg_32_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_31_0.noteText(var_31_1[arg_31_0.betType:read()].title),
		var_31_0.noteText(var_31_1[arg_31_0.betType:read()].start, var_31_1[arg_31_0.betType:read()]._end)
	}
end

function var_0_2.addTabListClipping(arg_33_0)
	local var_33_0 = arg_33_0.betList

	var_33_0:retain()
	var_33_0:removeFromParent()

	local var_33_1 = var_33_0:size()
	local var_33_2 = ccui.Scale9Sprite:create()

	var_33_2:initWithFile(cc.rect(48, 0, var_33_1.width, var_33_1.height), "city/pvp/cross_craft/bet/img_zz.png")
	var_33_2:size(var_33_1):anchorPoint(0, 0):xy(var_33_0:xy())
	cc.ClippingNode:create(var_33_2):setAlphaThreshold(0.1):add(var_33_0):addTo(arg_33_0.betPanel, var_33_0:z())
	var_33_0:release()
end

return var_0_2
