local var_0_0 = class("UnionBetView", Dialog)
local var_0_1 = {
	"city/union/union_fight/part3/icon_1.png",
	"city/union/union_fight/part3/icon_2.png",
	"city/union/union_fight/part3/icon_3.png"
}

local function var_0_2()
	local var_1_0 = time.getNowDate().wday

	var_1_0 = var_1_0 == 1 and 7 or var_1_0 - 1

	return var_1_0
end

var_0_0.RESOURCE_FILENAME = "union_bet.json"
var_0_0.RESOURCE_BINDING = {
	item = "item",
	list = {
		varname = "betList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("betData"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				dataOrderCmp = function(arg_2_0, arg_2_1)
					return arg_2_0.rank < arg_2_1.rank
				end,
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:multiget("bg", "rank", "icon", "iconbg2", "rankTxt", "name", "jf", "pl", "txt", "icon1", "txt2", "icon2", "btnOk", "gold2", "gold", "txt1", "level")
					local var_3_1 = arg_3_3.union

					var_3_0.icon:texture(csv.union.union_logo[var_3_1.logo].icon)
					var_3_0.icon:scale(1.9)

					if arg_3_3.rank <= 3 then
						var_3_0.rank:texture(var_0_1[arg_3_3.rank])
						var_3_0.rankTxt:hide()
					else
						var_3_0.rank:hide()
						var_3_0.rankTxt:text(arg_3_3.rank)
						text.addEffect(var_3_0.rankTxt, {
							outline = {
								color = cc.c4b(59, 51, 59, 255)
							}
						})
					end

					local var_3_2 = arg_3_3.rank % 2 == 1 and 153 or 77

					var_3_0.bg:setOpacity(var_3_2)
					var_3_0.iconbg2:setOpacity(178)
					var_3_0.name:text(var_3_1.name)
					var_3_0.jf:text(arg_3_3.point)
					var_3_0.pl:text(mathEasy.getPreciseDecimal(arg_3_3.rate, 2))
					var_3_0.level:text(var_3_1.level)
					var_3_0.level:x(var_3_0.level:x() - var_3_0.level:width() / 2)
					var_3_0.txt1:x(var_3_0.txt1:x() - var_3_0.level:width() / 2)
					text.addEffect(var_3_0.level, {
						outline = {
							color = cc.c4b(108, 82, 49, 255)
						}
					})
					text.addEffect(var_3_0.txt1, {
						outline = {
							color = cc.c4b(108, 82, 49, 255)
						}
					})
					text.addEffect(var_3_0.txt, {
						outline = {
							color = cc.c4b(59, 51, 59, 255)
						}
					})
					text.addEffect(var_3_0.txt2, {
						outline = {
							color = cc.c4b(59, 51, 59, 255)
						}
					})
					var_3_0.bg:setTouchEnabled(false)
					bind.touch(arg_3_0, var_3_0.icon1, {
						methods = {
							ended = functools.partial(arg_3_0.clickBet, var_3_1.union_id, gCommonConfigCsv.unionFightBetNormalGold)
						}
					})
					bind.touch(arg_3_0, var_3_0.icon2, {
						methods = {
							ended = functools.partial(arg_3_0.clickBet, var_3_1.union_id, gCommonConfigCsv.unionFightBetAdvanceGold)
						}
					})

					if itertools.size(arg_3_3.craft_bets) ~= 0 or arg_3_3.round ~= "signup" then
						var_3_0.icon1:setOpacity(127)
						var_3_0.icon2:setOpacity(127)
						var_3_0.gold:setOpacity(127)
						var_3_0.gold2:setOpacity(127)
						var_3_0.txt:setOpacity(127)
						var_3_0.txt2:setOpacity(127)
					end

					local var_3_3 = mathEasy.getShortNumber(gCommonConfigCsv.unionFightBetNormalGold, 2)
					local var_3_4 = mathEasy.getShortNumber(gCommonConfigCsv.unionFightBetAdvanceGold, 2)

					var_3_0.txt:text(var_3_3)
					var_3_0.txt2:text(var_3_4)

					local var_3_5
					local var_3_6 = false

					if arg_3_3.craft_bets.rank1 then
						if var_3_1.union_id == arg_3_3.craft_bets.rank1[1] and arg_3_3.craft_bets.rank1[2] == gCommonConfigCsv.unionFightBetNormalGold then
							var_3_6 = true

							var_3_0.txt:text(var_3_3)
							var_3_0.txt:setOpacity(255)
							var_3_0.gold:setOpacity(255)
						end

						if var_3_1.union_id == arg_3_3.craft_bets.rank1[1] and arg_3_3.craft_bets.rank1[2] == gCommonConfigCsv.unionFightBetAdvanceGold then
							var_3_6 = true

							var_3_0.txt:text(var_3_4)
							var_3_0.txt:setOpacity(255)
							var_3_0.gold:setOpacity(255)
						end
					end

					var_3_0.btnOk:visible(var_3_6)
					var_3_0.icon1:visible(not var_3_6)
					var_3_0.icon2:visible(not var_3_6)
					var_3_0.txt2:visible(not var_3_6)
					var_3_0.gold2:visible(not var_3_6)
				end
			},
			handlers = {
				clickBet = bindHelper.self("onClickBet")
			}
		}
	},
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["up.rank"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["up.union"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["up.jf"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["up.pl"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["up.xz"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	bg = {
		binds = {
			event = "click",
			method = bindHelper.self("interceptFunc")
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

	Dialog.onCreate(arg_4_0)
end

function var_0_0.initModel(arg_5_0)
	arg_5_0.round = gGameModel.union_fight:getIdler("round")
	arg_5_0.craft_bets = gGameModel.daily_record:getIdler("union_fight_bets")
	arg_5_0.gold = gGameModel.role:getIdler("gold")
	arg_5_0.id = gGameModel.role:read("id")

	arg_5_0.item:visible(false)
end

function var_0_0.onClickBet(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = gGameModel.union_fight:read("round")

	if var_0_2() == 6 and var_6_0 == "battle" then
		gGameUI:showTip(gLanguageCsv.unionBattleBegin)

		return
	end

	if var_0_2() ~= 6 or var_6_0 ~= "signup" then
		gGameUI:showTip(gLanguageCsv.union_bet)

		return
	end

	if itertools.size(arg_6_0.craft_bets:read()) > 0 then
		gGameUI:showTip(gLanguageCsv.craftBetAlready)

		return
	end

	if arg_6_3 > arg_6_0.gold:read() then
		gGameUI:showTip(gLanguageCsv.craftBetGoldNone)

		return
	end

	gGameApp:requestServer("/game/union/fight/bet", function()
		gGameApp:requestServer("/game/union/fight/bet/info", function(arg_8_0)
			local var_8_0 = {}

			for iter_8_0, iter_8_1 in pairs(arg_8_0.view) do
				iter_8_1.round = arg_6_0.round:read()
				iter_8_1.craft_bets = arg_6_0.craft_bets:read()

				table.insert(var_8_0, iter_8_1)
			end

			dataEasy.tryCallFunc(arg_6_0.betList, "updatePreloadCenterIndex")
			arg_6_0.betData:update(var_8_0)
		end)
	end, arg_6_2, arg_6_3)
end

function var_0_0.interceptFunc(arg_9_0, ...)
	return
end

return var_0_0
