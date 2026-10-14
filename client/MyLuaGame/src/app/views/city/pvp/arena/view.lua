local var_0_0 = {
	gLanguageCsv.changeEnemy,
	gLanguageCsv.pvpResetTime,
	gLanguageCsv.pvpBuyTime
}
local var_0_1 = {
	BUY = 3,
	NORMAL = 1,
	COLDDOWN = 2
}

local function var_0_2(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1:get("panel")

	var_1_0:get("textName"):text(arg_1_3.name)
	var_1_0:get("textLv"):text(arg_1_3.level)
	var_1_0:get("textFightPoint"):setString(arg_1_3.fighting_point)
	var_1_0:get("textRank2"):text(arg_1_3.rank)

	local var_1_1 = var_1_0:get("textLv"):size().width
	local var_1_2 = var_1_0:get("textLvNote"):size().width
	local var_1_3 = var_1_0:get("textLvNote"):x() - var_1_2 + (var_1_1 + var_1_2) / 2
	local var_1_4 = arg_1_3.rank <= 3

	if var_1_4 then
		var_1_0:get("imgRank"):texture(ui.RANK_ICON[arg_1_3.rank]):scale(0.85)
	else
		var_1_0:get("textRank"):text(arg_1_3.rank)
		var_1_0:get("imgRank"):texture("city/pvp/arena/box_4-9.png")
	end

	var_1_0:get("imgRank"):visible(arg_1_3.isTop)
	var_1_0:get("textRank"):visible(arg_1_3.isTop and not var_1_4)

	local var_1_5 = arg_1_3.role_db_id == arg_1_0.record:read().role_db_id
	local var_1_6 = arg_1_3.rank > arg_1_0.record:read().rank

	var_1_0:get("btnChallenge"):hide()
	var_1_0:get("passPanel.btnChallenge"):hide()
	var_1_0:get("passPanel.btnPass"):hide()
	var_1_0:get("textCostNum"):hide()
	var_1_0:get("imgIcon"):hide()

	local function var_1_7(arg_2_0, arg_2_1)
		arg_2_0:y(arg_2_0:y() + arg_2_1)
	end

	local var_1_8 = {
		"imgFightNode",
		"textLvNote",
		"textLv",
		"textFightPoint",
		"textName",
		"textRank2",
		"textRankNote",
		"textRank",
		"imgRank",
		"imgFbg"
	}
	local var_1_9 = var_1_0:get("imgFightNode"):y()

	if math.abs(var_1_9 - 170) > 1e-06 then
		for iter_1_0, iter_1_1 in ipairs(var_1_8) do
			var_1_7(var_1_0:get(iter_1_1), 180 - var_1_9)
		end
	end

	var_1_0:get("textSelf"):hide()

	local var_1_10 = arg_1_3.cost

	if var_1_5 then
		arg_1_0.myItemIdx:set(arg_1_2)
		var_1_0:get("textSelf"):show()
	elseif var_1_6 and dataEasy.isUnlock(gUnlockCsv.pvpPass) then
		var_1_0:get("passPanel.btnChallenge"):show()
		var_1_0:get("passPanel.btnPass"):show()
		text.addEffect(var_1_0:get("passPanel.btnChallenge.textNote"), {
			outline = {
				size = 1,
				color = ui.NEWCOLORS.OUTLINE.YELLOW
			}
		})
		text.addEffect(var_1_0:get("passPanel.btnPass.textNote"), {
			outline = {
				size = 1,
				color = ui.NEWCOLORS.OUTLINE.YELLOW
			}
		})

		local var_1_11 = needBuyCount

		var_1_0:get("textCostNum"):text(var_1_10):show()
		var_1_0:get("imgIcon"):show()
		adapt.oneLineCenterPos(cc.p(345, 56), {
			var_1_0:get("imgIcon"),
			var_1_0:get("textCostNum")
		})

		for iter_1_2, iter_1_3 in ipairs(var_1_8) do
			var_1_7(var_1_0:get(iter_1_3), 0)
		end
	else
		var_1_0:get("btnChallenge"):show()
		text.addEffect(var_1_0:get("btnChallenge.textNote"), {
			outline = {
				size = 3,
				color = ui.NEWCOLORS.OUTLINE.YELLOW
			}
		})
	end

	var_1_0:removeChildByName("spineNode")

	local var_1_12 = dataEasy.getUnitIdForJJC(arg_1_3.display)
	local var_1_13 = csv.unit[var_1_12]
	local var_1_14 = var_1_0:size()

	widget.addAnimationByKey(var_1_0, var_1_13.unitRes, "spineNode", "standby_loop", 3):xy(var_1_14.width / 2, var_1_14.height / 2 - 40):scale(var_1_13.scale * 0.85):setSkin(var_1_13.skin)
end

local var_0_3 = require("app.views.city.activity.month_card")
local var_0_4 = class("ArenaView", cc.load("mvc").ViewBase)

var_0_4.RESOURCE_FILENAME = "arena.json"
var_0_4.RESOURCE_BINDING = {
	["top.imgBg"] = "imgBg",
	["rightDown.ticket"] = "ticketPanel",
	["rightDown.costInfo.imgIcon"] = "imgCostIcon",
	item = "item",
	["top.imgLeftBG"] = "imgLeftBG",
	["top.imgRightBG"] = "imgRightBG",
	["rightDown.costInfo"] = "costInfo",
	["rightDown.schedule"] = "schedulePanel",
	["rightDown.leftTime"] = "leftTimePanel",
	ruleRankItem = "ruleRankItem",
	["top.leftUp.textFightPoint"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("fightPoint")
		}
	},
	["top.leftUp.head.imgTouxiang"] = {
		binds = {
			event = "texture",
			idler = bindHelper.self("logoId"),
			method = function(arg_3_0)
				local var_3_0 = dataEasy.getUnitIdForJJC(arg_3_0)

				return csv.unit[var_3_0].cardIcon
			end
		}
	},
	["top.leftUp.head"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowHeadIcon")
			}
		}
	},
	["top.leftUp.textRank"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("myRank")
		}
	},
	["top.rightUp.btnRankReward"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onShowRankReward")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					state = bindHelper.self("hasRankReward"),
					onNode = function(arg_4_0)
						arg_4_0:scale(0.66)
					end
				}
			}
		}
	},
	["top.rightUp.btnRankReward.textNote"] = {
		varname = "txtBtnRankReward",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["top.rightUp.btnScoreReward"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onShowPointReward")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					state = bindHelper.self("hasScoreReward"),
					onNode = function(arg_5_0)
						arg_5_0:scale(0.66)
					end
				}
			}
		}
	},
	["top.rightUp.btnScoreReward.textNote"] = {
		varname = "txtBtnScoreReward",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["top.rightUp.btnHonourReward"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowShop")
			}
		}
	},
	["top.rightUp.btnHonourReward.textNote"] = {
		varname = "txtBtnHonourReward",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["top.rightUp.btnFightReport"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowFightReport")
			}
		}
	},
	["top.rightUp.btnFightReport.textNote"] = {
		varname = "txtBtnFightReport",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["top.rightUp.btnRank"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowRank")
			}
		}
	},
	["top.rightUp.btnRank.textNote"] = {
		varname = "txtBtnRank",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["top.rightUp.btnRule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowRule")
			}
		}
	},
	["top.rightUp.btnRule.textNote"] = {
		varname = "txtBtnRule",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["rightDown.leftTime.textNum"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 3,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			},
			{
				event = "text",
				idler = bindHelper.self("leftTime")
			}
		}
	},
	["rightDown.schedule.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["rightDown.schedule.textTime"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 3,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			},
			{
				event = "text",
				idler = bindHelper.self("timeSchedule"),
				method = function(arg_6_0)
					local var_6_0 = math.floor(arg_6_0 / 60)
					local var_6_1 = arg_6_0 % 60

					return string.format("%02d:%02d", var_6_0, var_6_1)
				end
			}
		}
	},
	["rightDown.costInfo.textCostNum"] = {
		varname = "textCost",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["rightDown.costInfo.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["rightDown.leftTime.textNoteNum"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["rightDown.ticket.textNoteNum"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["rightDown.ticket.textNum"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["rightDown.textNote"] = {
		binds = {
			{
				event = "text",
				idler = bindHelper.self("btnText")
			},
			{
				event = "effect",
				data = {
					outline = {
						size = 1,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	},
	["leftDown.btnReset"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onResetRole")
			}
		}
	},
	["leftDown.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.BLUE
				}
			}
		}
	},
	["rightDown.btnThree"] = {
		varname = "doubleBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBuyOrResetTime")
			}
		}
	},
	["item.panel.textName"] = {
		varname = "textNameItem",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["item.panel.textLv"] = {
		varname = "textLvItem",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["item.panel.textLvNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["item.panel.textRankNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["item.panel.textRank"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["item.panel.textRank2"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["item.panel.textSelf"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["item.panel.textCostNum"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				data = bindHelper.self("myEnemys"),
				item = bindHelper.self("item"),
				record = bindHelper.self("record"),
				myItemIdx = bindHelper.self("myItemIdx"),
				itemAction = {
					isAction = true
				},
				dataOrderCmp = function(arg_7_0, arg_7_1)
					if arg_7_0.isTop == arg_7_1.isTop then
						return arg_7_0.rank < arg_7_1.rank
					end

					if arg_7_0.isTop then
						return true
					end

					if arg_7_1.isTop then
						return false
					end
				end,
				onItem = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					arg_8_1:name("item" .. arg_8_0:getIdx(arg_8_2))
					var_0_2(arg_8_0, arg_8_1, arg_8_2, arg_8_3)

					local var_8_0 = arg_8_1:get("panel")

					bind.touch(arg_8_0, var_8_0, {
						methods = {
							ended = functools.partial(arg_8_0.clickCell, arg_8_3, var_8_0)
						}
					})
					bind.touch(arg_8_0, var_8_0:get("btnChallenge"), {
						methods = {
							ended = functools.partial(arg_8_0.clickBtn, arg_8_3)
						}
					})
					bind.touch(arg_8_0, var_8_0:get("passPanel.btnChallenge"), {
						methods = {
							ended = functools.partial(arg_8_0.clickBtn, arg_8_3)
						}
					})
					bind.touch(arg_8_0, var_8_0:get("passPanel.btnPass"), {
						methods = {
							ended = functools.partial(arg_8_0.clickPassBtn, arg_8_3)
						}
					})
				end,
				preloadCenter = bindHelper.self("lastIdx")
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick"),
				clickBtn = bindHelper.self("onItemBtnClick"),
				clickPassBtn = bindHelper.self("onPassClick")
			}
		}
	},
	marqueePanel = {
		varname = "marqueePanel",
		binds = {
			event = "extend",
			class = "marquee"
		}
	}
}

function var_0_4.onCreate(arg_9_0)
	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_9_0.list,
			"width"
		},
		{
			arg_9_0.list,
			"pos",
			"left"
		},
		{
			arg_9_0.imgBg,
			"width"
		},
		{
			arg_9_0.imgLeftBG,
			"pos",
			"left"
		},
		{
			arg_9_0.imgRightBG,
			"pos",
			"right"
		}
	})
	arg_9_0:initModel()

	local var_9_0 = {
		arg_9_0.txtBtnRankReward,
		arg_9_0.txtBtnScoreReward,
		arg_9_0.txtBtnHonourReward,
		arg_9_0.txtBtnFightReport,
		arg_9_0.txtBtnRank,
		arg_9_0.txtBtnRule
	}

	for iter_9_0 = 1, #var_9_0 do
		var_9_0[iter_9_0]:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM)
		var_9_0[iter_9_0]:getVirtualRenderer():setLineSpacing(-15)
		var_9_0[iter_9_0]:y(var_9_0[iter_9_0]:y() + 25)
	end

	adapt.oneLinePos(arg_9_0.textLvItem, arg_9_0.textNameItem, cc.p(70, 0))
	gGameUI.topuiManager:createView("default", arg_9_0, {
		onClose = arg_9_0:createHandler("onClose")
	}):init({
		subTitle = "Arena",
		title = "common/txt/txt_bt_jingjichang.png"
	})

	arg_9_0.myItemIdx = idler.new(-1)
	arg_9_0.lastIdx = idler.new(1)
	arg_9_0.fightPoint = idler.new()
	arg_9_0.myRank = idler.new()
	arg_9_0.logoId = idler.new()
	arg_9_0.hasRankReward = idler.new(false)
	arg_9_0.hasScoreReward = idler.new(false)

	idlereasy.when(arg_9_0.record, function(arg_10_0, arg_10_1)
		arg_9_0.myRank:set(arg_10_1.rank)
		arg_9_0.logoId:set(arg_10_1.display)

		local var_10_0 = 0

		for iter_10_0, iter_10_1 in pairs(arg_10_1.defence_card_attrs) do
			var_10_0 = var_10_0 + iter_10_1.fighting_point
		end

		arg_9_0.fightPoint:set(var_10_0)
	end)
	idlereasy.any({
		arg_9_0.resultPointAward,
		arg_9_0.rankAward
	}, function(arg_11_0, arg_11_1, arg_11_2)
		local var_11_0 = false

		for iter_11_0, iter_11_1 in pairs(arg_11_1) do
			if iter_11_1 == 1 then
				var_11_0 = true

				break
			end
		end

		arg_9_0.hasScoreReward:set(var_11_0)

		local var_11_1 = false

		for iter_11_2, iter_11_3 in pairs(arg_11_2) do
			if iter_11_3 == 1 then
				local var_11_2, var_11_3 = csvNext(csv.pwrank_award[iter_11_2].cost)

				if not var_11_2 or var_11_3 <= dataEasy.getNumByKey(var_11_2) then
					var_11_1 = true

					break
				end
			end
		end

		arg_9_0.hasRankReward:set(var_11_1)
	end)

	arg_9_0.selectCardId = arg_9_0.record:read().display
	arg_9_0.btnText = idler.new("")
	arg_9_0.state = idler.new(0)
	arg_9_0.leftTime = idler.new()
	arg_9_0.costNum = idler.new(0)
	arg_9_0.timeSchedule = idler.new(0)

	local var_9_1 = {
		arg_9_0.pvpPwTimes,
		arg_9_0.buyPwTimes,
		arg_9_0.pvpPwLastTime,
		arg_9_0.buyPwCdTimes,
		arg_9_0.itemPwTimes,
		arg_9_0.refreshEnemyTimes,
		arg_9_0.items
	}

	idlereasy.any(var_9_1, function(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7)
		local var_12_0 = arg_9_0.freePWTimes
		local var_12_1 = math.max(0, arg_12_2 + var_12_0 + arg_12_5 - arg_12_1)

		arg_9_0.leftTime:set(string.format("%s/%s", var_12_1, var_12_0))

		local var_12_2 = arg_12_7[game.ITEM_TICKET.pvpTicket] or 0

		arg_9_0.ticketPanel:get("textNum"):text("1/" .. var_12_2)

		local var_12_3 = var_12_1 == 0 and var_12_2 > 0

		arg_9_0.ticketPanel:visible(var_12_3)
		arg_9_0.leftTimePanel:visible(not var_12_3)

		if var_12_1 == 0 and var_12_2 == 0 then
			local var_12_4 = gCostCsv.pvppw_buy_cost
			local var_12_5 = math.min(arg_12_2 + 1, table.length(var_12_4))

			arg_9_0.costNum:set(var_12_4[var_12_5])
			arg_9_0:setCost(var_12_4[var_12_5])
			adapt.oneLinePos(arg_9_0.textCost, arg_9_0.imgCostIcon, cc.p(6, 0))
			arg_9_0.state:set(var_0_1.BUY)
		else
			if not var_0_3.getPrivilegeAddition("pwNoCD") and arg_12_1 < var_12_0 then
				local var_12_6 = time.getTime() - arg_12_3
				local var_12_7 = tonumber(arg_9_0.pvpResetTime)

				if var_12_6 < var_12_7 then
					local var_12_8 = gCostCsv.pvppw_cd_buy_cost
					local var_12_9 = math.min(arg_12_4 + 1, table.length(var_12_8))

					arg_9_0.costNum:set(var_12_8[var_12_9])
					arg_9_0:setCost(var_12_8[var_12_9])
					adapt.oneLinePos(arg_9_0.textCost, arg_9_0.imgCostIcon, cc.p(6, 0))
					arg_9_0.timeSchedule:set(var_12_7 - var_12_6)
					arg_9_0.state:set(var_0_1.COLDDOWN, true)

					return
				end
			end

			local var_12_10 = gCostCsv.pvp_enermys_fresh_cost
			local var_12_11 = math.min(arg_12_6 + 1, table.length(var_12_10))

			arg_9_0.costNum:set(var_12_10[var_12_11])
			arg_9_0:setCost(var_12_10[var_12_11])
			adapt.oneLinePos(arg_9_0.textCost, arg_9_0.imgCostIcon, cc.p(6, 0))
			arg_9_0.state:set(var_0_1.NORMAL, true)
		end
	end)
	idlereasy.any({
		arg_9_0.state,
		arg_9_0.costNum
	}, function(arg_13_0, arg_13_1, arg_13_2)
		arg_9_0.costInfo:visible(arg_13_1 ~= var_0_1.NORMAL or arg_13_2 ~= 0)
		arg_9_0.schedulePanel:visible(arg_13_1 == var_0_1.COLDDOWN)
		arg_9_0.btnText:set(var_0_0[arg_13_1])

		if arg_13_1 == var_0_1.NORMAL then
			local var_13_0 = 1000

			if arg_13_2 > 0 then
				var_13_0 = 700
			end

			arg_9_0.ticketPanel:x(var_13_0)
			arg_9_0.leftTimePanel:x(var_13_0)
		elseif arg_13_1 == var_0_1.BUY then
			arg_9_0.ticketPanel:x(700)
			arg_9_0.leftTimePanel:x(700)
		elseif arg_13_1 == var_0_1.COLDDOWN then
			arg_9_0.ticketPanel:x(246)
			arg_9_0.leftTimePanel:x(246)
		end
	end)
	arg_9_0:enableSchedule():schedule(function(arg_14_0)
		if arg_9_0.state:read() == var_0_1.COLDDOWN then
			local var_14_0 = true

			arg_9_0.timeSchedule:modify(function(arg_15_0)
				local var_15_0 = arg_15_0 - 1

				if var_15_0 <= 0 then
					local var_15_1 = gCostCsv.pvp_enermys_fresh_cost
					local var_15_2 = math.min(arg_9_0.refreshEnemyTimes:read() + 1, table.length(var_15_1))

					arg_9_0.costNum:set(var_15_1[var_15_2])
					arg_9_0:setCost(var_15_1[var_15_2])
					adapt.oneLinePos(arg_9_0.textCost, arg_9_0.imgCostIcon, cc.p(6, 0))
					arg_9_0.state:set(var_0_1.NORMAL)

					var_14_0 = false
				end

				return true, var_15_0
			end)

			return var_14_0
		end
	end, 1, 0, "pvpSchedule")

	arg_9_0.myEnemys = idlers.newWithMap({})
	arg_9_0.refreshPass = idler.new(false)

	idlereasy.any({
		arg_9_0.top10,
		arg_9_0.enemys,
		arg_9_0.refreshPass
	}, function(arg_16_0, arg_16_1, arg_16_2)
		arg_9_0.lastIdx:set(#arg_16_1 + #arg_16_2)

		local var_16_0 = arg_9_0:resetEnemys(arg_16_1, arg_16_2)

		arg_9_0.myEnemys:update(var_16_0)
	end)
end

function var_0_4.initModel(arg_17_0)
	arg_17_0.rankAward = gGameModel.role:getIdler("pw_rank_award")
	arg_17_0.cards = gGameModel.role:getIdler("cards")
	arg_17_0.items = gGameModel.role:getIdler("items")

	local var_17_0 = gGameModel.role:read("vip_level")
	local var_17_1 = gGameModel.arena

	arg_17_0.top10 = var_17_1:getIdler("top10")
	arg_17_0.enemys = var_17_1:getIdler("enemys")
	arg_17_0.record = var_17_1:getIdler("record")

	local var_17_2 = gGameModel.daily_record

	arg_17_0.resultPointAward = var_17_2:getIdler("result_point_award")
	arg_17_0.refreshEnemyTimes = var_17_2:getIdler("pvp_enermys_refresh_times")
	arg_17_0.buyPwTimes = var_17_2:getIdler("buy_pw_times")
	arg_17_0.pvpPwTimes = var_17_2:getIdler("pvp_pw_times")
	arg_17_0.pvpPwLastTime = var_17_2:getIdler("pvp_pw_last_time")
	arg_17_0.buyPwCdTimes = var_17_2:getIdler("buy_pw_cd_times")
	arg_17_0.itemPwTimes = var_17_2:getIdler("item_pw_times")

	local var_17_3 = gVipCsv[var_17_0]

	arg_17_0.freePWTimes = var_17_3.freePWTimes
	arg_17_0.pvpResetTime = var_17_3.PWcoldTime
end

function var_0_4.resetEnemys(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_0:getPassCost()
	local var_18_1 = {}

	for iter_18_0, iter_18_1 in ipairs(arg_18_1) do
		local var_18_2 = clone(iter_18_1)

		var_18_2.isTop = true
		var_18_2.cost = var_18_0

		table.insert(var_18_1, var_18_2)
	end

	for iter_18_2, iter_18_3 in ipairs(arg_18_2) do
		local var_18_3 = clone(iter_18_3)

		var_18_3.isTop = false
		var_18_3.cost = var_18_0

		table.insert(var_18_1, var_18_3)
	end

	return var_18_1
end

function var_0_4.onShowHeadIcon(arg_19_0, arg_19_1, arg_19_2)
	gGameUI:stackUI("city.pvp.arena.head_icon", nil, nil, arg_19_0:createHandler("onChangeLogoID"), arg_19_0:createHandler("onChangeSpine"), arg_19_0.selectCardId)
end

function var_0_4.onItemBtnClick(arg_20_0, arg_20_1, arg_20_2)
	if arg_20_2.isTop and arg_20_0.myRank:read() > 20 then
		gGameUI:showTip(gLanguageCsv.rankNotEnough)

		return
	end

	local function var_20_0()
		gGameUI:stackUI("city.card.embattle.arena", nil, {
			full = true
		}, {
			team = true,
			from = "arena",
			fightCb = arg_20_0:createHandler("startFighting", arg_20_2)
		})
	end

	local var_20_1 = arg_20_0.state:read()

	if var_20_1 ~= var_0_1.NORMAL then
		if var_20_1 == var_0_1.COLDDOWN then
			gGameUI:showTip(gLanguageCsv.timeNotUp)
		else
			arg_20_0:onBuyOrResetTime(var_20_0)
		end

		return
	end

	var_20_0()
end

function var_0_4.startFighting(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	local var_22_0 = arg_22_0.record:read().rank
	local var_22_1 = arg_22_1.rank

	arg_22_0:disableSchedule()
	battleEntrance.battleRequest("/game/pw/battle/start", var_22_0, var_22_1, arg_22_1.role_db_id, arg_22_1.record_id):onStartOK(function(arg_23_0)
		arg_23_0.preData.rightRank = var_22_1

		if arg_22_2 then
			arg_22_2:onClose(false)

			arg_22_2 = nil
		end
	end):run():show()
end

function var_0_4.onItemClick(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	if arg_24_2.role_db_id == arg_24_0.record:read().role_db_id then
		return
	end

	gGameApp:requestServer("/game/pw/role/info", function(arg_25_0)
		gGameUI:stackUI("city.pvp.arena.personal_info", nil, nil, arg_25_0.view)
	end, arg_24_2.record_id)
end

function var_0_4.getPassCost(arg_26_0)
	local var_26_0 = arg_26_0.freePWTimes
	local var_26_1 = arg_26_0.buyPwTimes:read()
	local var_26_2 = arg_26_0.itemPwTimes:read()
	local var_26_3 = arg_26_0.pvpPwTimes:read()
	local var_26_4 = math.max(0, var_26_0 + var_26_1 + var_26_2 - var_26_3)
	local var_26_5 = arg_26_0.items:read()[game.ITEM_TICKET.pvpTicket] or 0
	local var_26_6 = math.max(0, 5 - var_26_4 - var_26_5)
	local var_26_7 = gCommonConfigCsv.pvpPassCostRmb
	local var_26_8 = gCostCsv.pvppw_buy_cost

	for iter_26_0 = 1, var_26_6 do
		var_26_7 = var_26_7 + var_26_8[math.min(var_26_1 + iter_26_0, table.length(var_26_8))]
	end

	return var_26_7
end

function var_0_4.onPassClick(arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = arg_27_0.freePWTimes
	local var_27_1 = arg_27_0.buyPwTimes:read()
	local var_27_2 = arg_27_0.itemPwTimes:read()
	local var_27_3 = arg_27_0.pvpPwTimes:read()
	local var_27_4 = math.max(0, var_27_0 + var_27_1 + var_27_2 - var_27_3)
	local var_27_5 = arg_27_0.items:read()[game.ITEM_TICKET.pvpTicket] or 0
	local var_27_6 = math.max(0, 5 - var_27_4 - var_27_5)
	local var_27_7 = arg_27_0:getPassCost()

	local function var_27_8()
		if gGameModel.role:read("rmb") < var_27_7 then
			uiEasy.showDialog("rmb")
		else
			gGameApp:requestServer("/game/pw/battle/pass", function(arg_29_0)
				gGameUI:stackUI("city.pvp.arena.pass_reward", nil, nil, arg_27_2, arg_29_0.view)
				arg_27_0.refreshPass:notify()
			end, arg_27_2.rank)
		end
	end

	local var_27_9 = gGameModel.role:read("vip_level")

	if var_27_1 + var_27_6 >= gVipCsv[var_27_9].buyPWTimes then
		gGameUI:showTip(gLanguageCsv.arenaPassLimit)

		return
	end

	gGameUI:showDialog({
		btnType = 2,
		clearFast = true,
		isRich = true,
		cb = var_27_8,
		content = string.format(gLanguageCsv.arenaPassTip, var_27_7),
		dialogParams = {
			clickClose = false
		}
	})
end

function var_0_4.onShowRankReward(arg_30_0)
	gGameUI:stackUI("city.pvp.arena.rank_reward")
end

function var_0_4.onShowPointReward(arg_31_0)
	gGameUI:stackUI("city.pvp.arena.point_reward")
end

function var_0_4.onShowFightReport(arg_32_0)
	gGameUI:stackUI("city.pvp.arena.combat_record")
end

function var_0_4.onShowRank(arg_33_0)
	gGameApp:requestServer("/game/pw/rank", function(arg_34_0)
		gGameUI:stackUI("city.pvp.arena.rank", nil, nil, arg_34_0.view)
	end, 0, 50)
end

function var_0_4.onShowRule(arg_35_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_35_0:createHandler("getRuleContext"))
end

function var_0_4.getRuleContext(arg_36_0, arg_36_1)
	local var_36_0 = arg_36_0.record:read().rank
	local var_36_1 = arg_36_0.record:read().rank_top
	local var_36_2
	local var_36_3 = adaptContext
	local var_36_4 = {
		var_36_3.clone(arg_36_1.title, function(arg_37_0)
			arg_37_0:get("text"):text(gLanguageCsv.arenaRule)
		end),
		var_36_3.clone(arg_36_0.ruleRankItem, function(arg_38_0)
			local var_38_0 = arg_38_0:multiget("highest", "textNow1", "now", "textNow2", "list")

			var_38_0.highest:text(var_36_1)

			if not var_36_2 then
				nodetools.invoke(arg_38_0, {
					"textNow1",
					"now",
					"textNow2",
					"list"
				}, "hide")
				setContentSizeOfAnchor(arg_38_0, cc.size(arg_36_0.ruleRankItem:size().width, var_36_2 and 370 or 100))
			else
				var_38_0.now:text(var_36_0)
				adapt.oneLinePos(var_38_0.textNow1, {
					var_38_0.now,
					var_38_0.textNow2
				}, cc.p(5, 0))
				uiEasy.createItemsToList(arg_36_1, var_38_0.list, var_36_2.periodAward)
				var_38_0.list:setItemAlignCenter()
			end
		end),
		var_36_3.noteText(101),
		var_36_3.noteText(10001, 10100),
		var_36_3.noteText(102),
		var_36_3.noteText(10101, 10200),
		var_36_3.noteText(103)
	}
	local var_36_5 = getVersionContainMerge("pwAwardVer")

	for iter_36_0, iter_36_1 in orderCsvPairs(csv.pwaward) do
		if iter_36_1.version == var_36_5 then
			if var_36_0 >= iter_36_1.range[1] and var_36_0 < iter_36_1.range[2] then
				var_36_2 = iter_36_1
			end

			table.insert(var_36_4, var_36_3.clone(arg_36_1.awardItem, function(arg_39_0)
				local var_39_0 = arg_39_0:multiget("text", "list")

				if iter_36_1.range[2] - iter_36_1.range[1] == 1 then
					var_39_0.text:text(string.format(gLanguageCsv.rankSingle, iter_36_1.range[1]))
				else
					var_39_0.text:text(string.format(gLanguageCsv.rankMulti, iter_36_1.range[1], iter_36_1.range[2] - 1))
				end

				uiEasy.createItemsToList(arg_36_1, var_39_0.list, iter_36_1.periodAward)
			end))
		end
	end

	return var_36_4
end

function var_0_4.onChangeLogoID(arg_40_0, arg_40_1)
	arg_40_0.logoId:set(arg_40_1)
end

function var_0_4.onChangeSpine(arg_41_0, arg_41_1)
	local var_41_0 = false

	arg_41_0.selectCardId = arg_41_1

	for iter_41_0, iter_41_1 in arg_41_0.myEnemys:ipairs() do
		if iter_41_1:proxy().role_db_id == arg_41_0.record:read().role_db_id then
			var_41_0 = true

			break
		end
	end

	if var_41_0 and arg_41_0.myItemIdx:read() > 0 then
		local var_41_1 = arg_41_0.list:getItem(arg_41_0.myItemIdx:read() - 1)

		var_41_1:get("panel"):removeChildByName("spineNode")

		local var_41_2 = dataEasy.getUnitIdForJJC(arg_41_1)
		local var_41_3 = csv.unit[var_41_2]
		local var_41_4 = var_41_1:size()

		widget.addAnimationByKey(var_41_1:get("panel"), var_41_3.unitRes, "spineNode", "standby_loop", 3):xy(var_41_4.width / 2, var_41_4.height / 2 - 40):scale(var_41_3.scale * 0.85):setSkin(var_41_3.skin)
	end
end

function var_0_4.onShowShop(arg_42_0, arg_42_1, arg_42_2)
	if not gGameUI:goBackInStackUI("city.shop") then
		gGameApp:requestServer("/game/fixshop/get", function(arg_43_0)
			gGameUI:stackUI("city.shop", nil, {
				full = true
			}, game.SHOP_INIT.PVP_SHOP)
		end)
	end
end

function var_0_4.onBuyOrResetTime(arg_44_0, arg_44_1)
	local var_44_0 = arg_44_0.state:read()
	local var_44_1 = arg_44_0.costNum:read()

	if var_44_0 == 1 then
		local function var_44_2()
			gGameApp:requestServer("/game/pw/battle/get", function(arg_46_0)
				local var_46_0 = gGameModel.arena

				arg_44_0.top10 = idlereasy.assign(var_46_0:getIdler("top10"), arg_44_0.top10)
				arg_44_0.enemys = idlereasy.assign(var_46_0:getIdler("enemys"), arg_44_0.enemys)
			end, 1)
		end

		if var_44_1 > 0 then
			local var_44_3 = {
				isRich = true,
				btnType = 2,
				cb = var_44_2,
				content = string.format(gLanguageCsv.richCostDiamond, var_44_1) .. gLanguageCsv.changeEnemy,
				dialogParams = {
					clickClose = false
				}
			}

			gGameUI:showDialog(var_44_3)
		else
			var_44_2()
		end

		return
	end

	local var_44_4 = "/game/pw/battle/cd/buy"
	local var_44_5 = string.format(gLanguageCsv.richCostDiamond, var_44_1) .. gLanguageCsv.buyTime

	if var_44_0 == 3 then
		var_44_4 = "/game/pw/battle/buy"
		var_44_5 = string.format(gLanguageCsv.richCostDiamond, var_44_1) .. gLanguageCsv.pvpBuyTime

		local var_44_6 = gGameModel.role:read("vip_level")

		if arg_44_0.buyPwTimes:read() >= gVipCsv[var_44_6].buyPWTimes then
			gGameUI:showTip(gLanguageCsv.pwBuyMax)

			return
		end
	end

	if var_44_1 > 0 then
		local var_44_7 = {
			isRich = true,
			btnType = 2,
			cb = function()
				gGameApp:requestServer(var_44_4, function(arg_48_0)
					arg_44_0.state:set(var_0_1.NORMAL)

					if var_44_0 == 3 and type(arg_44_1) == "function" then
						arg_44_1()
					end
				end)
			end,
			content = var_44_5,
			dialogParams = {
				clickClose = false
			}
		}

		gGameUI:showDialog(var_44_7)
	else
		gGameApp:requestServer(var_44_4, function(arg_49_0)
			arg_44_0.state:set(var_0_1.NORMAL)
		end)
	end
end

function var_0_4.onResetRole(arg_50_0, arg_50_1, arg_50_2)
	gGameUI:stackUI("city.card.embattle.arena", nil, {
		full = true
	}, {
		from = "arena",
		team = true
	})
end

function var_0_4.setCost(arg_51_0, arg_51_1)
	arg_51_0.textCost:text(arg_51_1)
	idlereasy.when(gGameModel.role:getIdler("rmb"), function(arg_52_0, arg_52_1)
		arg_51_0.textCost:setTextColor(arg_51_1 > 0 and arg_52_1 < arg_51_1 and ui.COLORS.NORMAL.RED or ui.COLORS.NORMAL.WHITE)
	end):anonyOnly(arg_51_0, "cost")
end

return var_0_4
