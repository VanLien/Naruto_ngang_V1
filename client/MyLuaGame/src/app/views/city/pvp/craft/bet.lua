local var_0_0 = class("CraftBetView", Dialog)

var_0_0.RESOURCE_FILENAME = "craft_bet.json"
var_0_0.RESOURCE_BINDING = {
	["betPanel.betItem"] = "betItem",
	betPanel = "betPanel",
	noBetPanel = "noBetPanel",
	["topPanel.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["topPanel.txtNode"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	["topPanel.txtNode2"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
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
				asyncPreload = 10,
				data = bindHelper.self("betData"),
				dataOrderCmp = function(arg_1_0, arg_1_1)
					return arg_1_0.rank < arg_1_1.rank
				end,
				item = bindHelper.self("betItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_3.role
					local var_2_1 = arg_2_1:multiget("imgBg", "txtRank", "trainerIcon", "rankIcon", "txtName", "txtLv", "txtOdds", "txtFight", "txtNormal", "imgNormal", "txtHigh", "imgHigh", "btnNormal", "btnHigh", "txtBets", "imgBets")
					local var_2_2 = {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = var_2_0.logo,
							frameId = var_2_0.frame,
							onNode = function(arg_3_0)
								arg_3_0:xy(104, 95):z(6):scale(0.9)
							end
						}
					}

					bind.extend(arg_2_0, var_2_1.trainerIcon, var_2_2)
					var_2_1.txtName:text(var_2_0.name)
					var_2_1.txtLv:text(var_2_0.level)
					var_2_1.txtOdds:text(mathEasy.getPreciseDecimal(arg_2_3.rate, 2))
					var_2_1.txtFight:text(arg_2_3.fighting_point)
					var_2_1.txtNormal:text(mathEasy.getShortNumber(gCommonConfigCsv.craftBetNormalGold, 2))
					var_2_1.txtHigh:text(mathEasy.getShortNumber(gCommonConfigCsv.craftBetAdvanceGold, 2))

					local var_2_3 = arg_2_3.rank

					var_2_1.txtRank:visible(var_2_3 > 3)
					var_2_1.txtRank:text(var_2_3)
					var_2_1.rankIcon:visible(var_2_3 < 4)

					if var_2_3 <= 3 then
						var_2_1.imgBg:texture("city/pvp/craft/dialog_icon/iten_" .. var_2_3 .. ".png")
						var_2_1.rankIcon:texture("city/pvp/craft/img_xz" .. var_2_3 .. ".png")
					end

					var_2_1.imgBg:setTouchEnabled(true)
					var_2_1.imgBg:onClick(functools.partial(arg_2_0.clickHead, arg_2_2, var_2_0, var_2_3))
					bind.touch(arg_2_0, var_2_1.btnNormal, {
						methods = {
							ended = functools.partial(arg_2_0.clickBet, var_2_0.role_db_id, gCommonConfigCsv.craftBetNormalGold)
						}
					})
					cache.setShader(var_2_1.btnNormal, false, itertools.size(arg_2_3.craft_bets) == 0 and arg_2_3.round == "signup" and "normal" or "hsl_gray")

					if itertools.size(arg_2_3.craft_bets) == 0 and arg_2_3.round == "signup" then
						text.addEffect(var_2_1.btnNormal:getChildByName("txtNode"), {
							outline = {
								size = 3,
								color = ui.NEWCOLORS.OUTLINE.BLUE
							}
						})
					end

					bind.touch(arg_2_0, var_2_1.btnHigh, {
						methods = {
							ended = functools.partial(arg_2_0.clickBet, var_2_0.role_db_id, gCommonConfigCsv.craftBetAdvanceGold)
						}
					})
					cache.setShader(var_2_1.btnHigh, false, itertools.size(arg_2_3.craft_bets) == 0 and arg_2_3.round == "signup" and "normal" or "hsl_gray")

					if itertools.size(arg_2_3.craft_bets) == 0 and arg_2_3.round == "signup" then
						text.addEffect(var_2_1.btnHigh:getChildByName("txtNode"), {
							outline = {
								size = 3,
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							}
						})
					end

					local var_2_4 = itertools.size(arg_2_3.craft_bets) > 0 and var_2_0.role_db_id == arg_2_3.craft_bets.rank1[1]

					var_2_1.txtBets:visible(var_2_4)
					var_2_1.imgBets:visible(var_2_4)
					var_2_1.btnNormal:visible(not var_2_4)
					var_2_1.btnHigh:visible(not var_2_4)
					var_2_1.txtNormal:visible(not var_2_4)
					var_2_1.txtHigh:visible(not var_2_4)
					var_2_1.imgNormal:visible(not var_2_4)
					var_2_1.imgHigh:visible(not var_2_4)

					if itertools.size(arg_2_3.craft_bets) > 0 and var_2_0.role_db_id == arg_2_3.craft_bets.rank1[1] then
						var_2_1.txtBets:text(mathEasy.getShortNumber(arg_2_3.craft_bets.rank1[2], 2))
					end
				end
			},
			handlers = {
				clickHead = bindHelper.self("onHeadClick"),
				clickBet = bindHelper.self("onClickBet")
			}
		}
	}
}

function var_0_0.onCreate(arg_4_0, arg_4_1)
	arg_4_0:initModel()

	local var_4_0 = {}

	for iter_4_0, iter_4_1 in pairs(arg_4_1) do
		iter_4_1.round = arg_4_0.round:read()
		iter_4_1.craft_bets = arg_4_0.craft_bets:read()

		table.insert(var_4_0, iter_4_1)
	end

	arg_4_0.betData = idlers.newWithMap(var_4_0)

	local var_4_1 = itertools.size(arg_4_1)

	arg_4_0.noBetPanel:visible(var_4_1 == 0)
	arg_4_0.betPanel:visible(var_4_1 > 0)
	Dialog.onCreate(arg_4_0)
end

function var_0_0.initModel(arg_5_0)
	local var_5_0 = gGameModel.daily_record

	arg_5_0.round = gGameModel.craft:getIdler("round")
	arg_5_0.craft_bets = var_5_0:getIdler("craft_bets")
	arg_5_0.gold = gGameModel.role:getIdler("gold")
	arg_5_0.id = gGameModel.role:read("id")
end

function var_0_0.onHeadClick(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	if arg_6_0.id == arg_6_3.role_db_id then
		return
	end

	local var_6_0 = arg_6_5.target
	local var_6_1, var_6_2 = var_6_0:xy()
	local var_6_3 = var_6_0:getParent():convertToWorldSpace(cc.p(var_6_1, var_6_2))
	local var_6_4 = {
		role = {
			level = arg_6_3.level,
			id = arg_6_3.role_db_id,
			vip = arg_6_3.vip,
			name = arg_6_3.name,
			logo = arg_6_3.logo,
			frame = arg_6_3.frame
		}
	}

	gGameUI:stackUI("city.chat.personal_info", nil, nil, var_6_3, var_6_4, {
		speical = "rank",
		target = arg_6_1.item:get("imgBg")
	})
end

function var_0_0.onClickBet(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	if itertools.size(arg_7_0.craft_bets:read()) > 0 then
		gGameUI:showTip(gLanguageCsv.craftBetAlready)

		return
	end

	if itertools.size(arg_7_0.craft_bets:read()) == 0 and arg_7_0.round:read() ~= "signup" then
		gGameUI:showTip(gLanguageCsv.craftBetCanNot)

		return
	end

	if arg_7_3 > arg_7_0.gold:read() then
		gGameUI:showTip(gLanguageCsv.craftBetGoldNone)

		return
	end

	gGameApp:requestServer("/game/craft/bet", function()
		gGameApp:requestServer("/game/craft/bet/info", function(arg_9_0)
			local var_9_0 = {}

			for iter_9_0, iter_9_1 in pairs(arg_9_0.view) do
				iter_9_1.round = arg_7_0.round:read()
				iter_9_1.craft_bets = arg_7_0.craft_bets:read()

				table.insert(var_9_0, iter_9_1)
			end

			dataEasy.tryCallFunc(arg_7_0.betList, "updatePreloadCenterIndex")
			arg_7_0.betData:update(var_9_0)
		end)
	end, arg_7_2, arg_7_3)
end

return var_0_0
