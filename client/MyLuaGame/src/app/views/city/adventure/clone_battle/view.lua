local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("CloneBattleCityView", var_0_0)

var_0_1.RESOURCE_FILENAME = "clone_battle_city.json"
var_0_1.RESOURCE_BINDING = {
	["mainPanel.natureItem"] = "natureItem",
	["mainPanel.showItem"] = "showItem",
	["cdPanel.textTime"] = "textCd",
	allPanel = "allPanel",
	txt = "kickTxt",
	["cdPanel.textNote"] = "timeNote",
	kickBg = "kickBg",
	text = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	btnRule = {
		varname = "btnRule",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleShow")
			}
		}
	},
	["btnRule.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				},
				glow = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	btnShowList = {
		varname = "btnShowList",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("showSprList")
			}
		}
	},
	["btnShowList.text"] = {
		varname = "txtBtnShowList",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				},
				glow = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	mainPanel = {
		varname = "mainPanel",
		binds = {
			event = "click",
			method = bindHelper.self("onSpaceClick")
		}
	},
	["mainPanel.natureItem.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["mainPanel.showItem.btnRoom"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onCreateRoom")
			}
		}
	},
	["mainPanel.showItem.btnJoin"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onFastJoin")
			}
		}
	},
	["mainPanel.showItem.btnRoom.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["mainPanel.showItem.btnJoin.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["mainPanel.showItem.spr1.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["mainPanel.showItem.spr2.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["mainPanel.showItem.spr3.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	}
}

local var_0_2 = "effect2_%s_loop"
local var_0_3 = "effect_%s_loop"

function var_0_1.onCreate(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.data = arg_1_1
	arg_1_0.curItemIdx = nil
	arg_1_0.baseView = arg_1_2
	arg_1_0.kickNum = gGameModel.role:read("clone_daily_be_kicked_num")

	local var_1_0 = userDefault.getForeverLocalKey("cloneBattleBeKickedNum", 0)

	userDefault.setForeverLocalKey("cloneBattleBeKickedNum", arg_1_0.kickNum, {
		new = true
	})

	if arg_1_0.data.beKicked and arg_1_0.kickNum < gCommonConfigCsv.cloneDailyBeKickedMax and var_1_0 < arg_1_0.kickNum then
		gGameUI:showDialog({
			btnType = 1,
			title = "",
			isRich = true,
			content = string.format("#C0x5b545b#" .. gLanguageCsv.cloneBattleRecord8, gCommonConfigCsv.cloneDailyBeKickedMax - arg_1_0.kickNum)
		})
	end

	arg_1_0.pokedex = gGameModel.role:getIdler("pokedex")

	arg_1_0.txtBtnShowList:getVirtualRenderer():setLineSpacing(-15)
	arg_1_0.txtBtnShowList:y(arg_1_0.txtBtnShowList:y() + 10)
	idlereasy.when(arg_1_0.pokedex, function(arg_2_0, arg_2_1)
		local var_2_0 = {}

		for iter_2_0, iter_2_1 in pairs(arg_2_1) do
			var_2_0[csv.cards[iter_2_0].cardMarkID] = true
		end

		arg_1_0.pokedexMarks = var_2_0
	end)

	local var_1_1 = {}

	for iter_1_0, iter_1_1 in pairs(arg_1_1.nature) do
		if iter_1_0 > 5 then
			break
		end

		local var_1_2 = {}

		for iter_1_2, iter_1_3 in pairs(iter_1_1[2]) do
			local var_1_3 = iter_1_3

			if csv.clone.monster[iter_1_3] ~= nil then
				var_1_3 = csv.clone.monster[iter_1_3].cardID
			end

			local var_1_4 = csv.cards[var_1_3]
			local var_1_5 = var_1_4.unitID
			local var_1_6 = var_1_4.cardMarkID
			local var_1_7 = csv.unit[var_1_5] or csv.unit[1]
			local var_1_8 = arg_1_0.pokedexMarks[var_1_6]

			var_1_2[iter_1_2] = {
				cardId = var_1_3,
				unitId = var_1_5,
				markId = var_1_6,
				config = var_1_7,
				inBox = var_1_8
			}
		end

		var_1_1[iter_1_0] = {
			natureId = iter_1_1[1],
			spriteTb = var_1_2
		}
	end

	arg_1_0.natureMap = var_1_1

	arg_1_0:initNatureItem()
	arg_1_0:initCountDown()
	arg_1_0:showKickTip()
end

function var_0_1.showKickTip(arg_3_0)
	if arg_3_0.kickNum and arg_3_0.kickNum >= gCommonConfigCsv.cloneDailyBeKickedMax then
		local var_3_0 = ccui.Layout:create()

		var_3_0:size(display.sizeInView)
		var_3_0:xy(display.board_left, 0)
		var_3_0:addTo(arg_3_0.allPanel, 1, "__black_layer__")
		var_3_0:setBackGroundColorType(1)
		var_3_0:setBackGroundColor(cc.c3b(91, 84, 91))
		var_3_0:setBackGroundColorOpacity(0)
		var_3_0:setBackGroundColorOpacity(204)
		arg_3_0.allPanel:show()
		arg_3_0.kickBg:show()
		arg_3_0.kickTxt:text(gLanguageCsv.cloneBattleRecord9)
	else
		arg_3_0.allPanel:hide()
		arg_3_0.kickBg:hide()
		arg_3_0.kickTxt:hide()
	end
end

function var_0_1.onSpaceClick(arg_4_0)
	arg_4_0.showItem:hide()

	arg_4_0.curItemIdx = nil

	if arg_4_0.aniTb then
		arg_4_0.aniTb.ani:play(string.format(var_0_3, arg_4_0.aniTb.natureId))

		arg_4_0.aniTb = nil

		arg_4_0.baseView:playBgAni(nil)
	end
end

function var_0_1.onItemClick(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_0.showItem
	local var_5_1 = arg_5_1:size()

	var_5_0:retain()
	var_5_0:removeFromParent()
	arg_5_1:add(var_5_0, 999)
	var_5_0:xy(var_5_1.width / 2, var_5_1.height / 2 - 50)
	var_5_0:show()

	local var_5_2 = var_5_0:multiget("spr1", "spr2", "spr3")
	local var_5_3 = 0

	for iter_5_0 = 1, 3 do
		local var_5_4 = arg_5_3.spriteTb[iter_5_0]
		local var_5_5 = var_5_2["spr" .. iter_5_0]

		var_5_5:visible(var_5_4 and true or false)

		if var_5_4 then
			local var_5_6 = var_5_5:get("img")

			var_5_6:texture(var_5_4.config.iconSimple)

			local var_5_7 = var_5_4.inBox and "normal" or "hsl_gray"

			if var_5_4.inBox then
				var_5_3 = var_5_3 + 1
			end

			cache.setShader(var_5_6, false, var_5_7)
			cache.setShader(var_5_5, false, var_5_7)
			var_5_5:get("text"):text(var_5_4.config.name)
		end
	end

	arg_5_0.curItemCount = var_5_3
	arg_5_0.curItemIdx = arg_5_2

	if arg_5_0.aniTb then
		arg_5_0.aniTb.ani:play(string.format(var_0_3, arg_5_0.aniTb.natureId))
	end

	arg_5_0.aniTb = arg_5_1.aniTb

	arg_5_0.aniTb.ani:play(string.format(var_0_2, arg_5_0.aniTb.natureId))
	arg_5_0.baseView:playBgAni(arg_5_0.aniTb.natureId)
end

function var_0_1.onCreateRoom(arg_6_0)
	if not arg_6_0.curItemCount or arg_6_0.curItemCount <= 0 then
		gGameUI:showTip(gLanguageCsv.noNature)

		return
	end

	gGameApp:requestServer("/game/clone/room/create", function(arg_7_0)
		arg_6_0.baseView:refreshView()
	end, arg_6_0.natureMap[arg_6_0.curItemIdx].natureId)
end

function var_0_1.onFastJoin(arg_8_0)
	if not arg_8_0.curItemCount or arg_8_0.curItemCount <= 0 then
		gGameUI:showTip(gLanguageCsv.noNature)

		return
	end

	gGameApp:requestServer("/game/clone/room/join/fast", function(arg_9_0)
		arg_8_0.baseView:refreshView()
	end, arg_8_0.natureMap[arg_8_0.curItemIdx].natureId)
end

local var_0_4 = {
	cc.p(1735, 710),
	cc.p(1599, 255),
	cc.p(1020, 255),
	cc.p(877, 710),
	(cc.p(1300, 1010))
}

function var_0_1.initNatureItem(arg_10_0)
	local var_10_0 = #var_0_4

	for iter_10_0, iter_10_1 in pairs(var_0_4) do
		local var_10_1 = arg_10_0.natureItem:clone()

		arg_10_0.mainPanel:add(var_10_1, var_10_0 - iter_10_0)
		var_10_1:xy(iter_10_1)

		local var_10_2 = arg_10_0.natureMap[iter_10_0]

		if var_10_2 and csv.clone.nature[var_10_2.natureId] then
			local var_10_3 = var_10_2.natureId
			local var_10_4 = var_10_1:size()
			local var_10_5 = csv.clone.nature[var_10_2.natureId].spine
			local var_10_6 = 1.3
			local var_10_7 = widget.addAnimation(var_10_1, var_10_5, string.format(var_0_3, var_10_3), 1):scale(var_10_6):xy(var_10_4.width / 2, 10)

			var_10_1.aniTb = {
				ani = var_10_7,
				natureId = var_10_3
			}

			local var_10_8 = var_10_1:get("text")

			var_10_8:text(gLanguageCsv[game.NATURE_TABLE[var_10_3]] .. gLanguageCsv.talentElement)
			text.addEffect(var_10_8, {
				color = ui.COLORS.ATTR[var_10_3]
			})
			bind.touch(arg_10_0, var_10_1, {
				methods = {
					ended = functools.partial(arg_10_0.onItemClick, arg_10_0, var_10_1, iter_10_0, var_10_2)
				}
			})
		else
			var_10_1:hide()
		end
	end
end

function var_0_1.showSprList(arg_11_0)
	local var_11_0, var_11_1 = arg_11_0.btnShowList:xy()

	gGameUI:stackUI("city.adventure.clone_battle.spr_list", nil, nil, arg_11_0.natureMap, var_11_0, var_11_1)
end

function var_0_1.onRuleShow(arg_12_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_12_0:createHandler("getRuleContext"))
end

function var_0_1.getRuleContext(arg_13_0, arg_13_1)
	local var_13_0 = adaptContext

	return {
		var_13_0.clone(arg_13_1.title, function(arg_14_0)
			arg_14_0:get("text"):text(gLanguageCsv.cloneBattleRuleTitle)
		end),
		var_13_0.noteText(111),
		var_13_0.noteText(62001, 62010)
	}
end

function var_0_1.initCountDown(arg_15_0)
	local var_15_0 = arg_15_0.textCd
	local var_15_1 = time.getTodayStrInClock(12)
	local var_15_2 = time.getNumTimestamp(var_15_1, 12) + 86400

	local function var_15_3()
		local var_16_0 = time.getCutDown(var_15_2 - time.getTime())

		var_15_0:text(var_16_0.str)
		adapt.oneLinePos(arg_15_0.timeNote, var_15_0, cc.p(5, 0))

		if var_15_2 - time.getTime() <= 0 then
			arg_15_0.baseView:refresh()

			var_15_1 = time.getTodayStrInClock(12)
		end

		return true
	end

	arg_15_0:enableSchedule()
	arg_15_0:schedule(function(arg_17_0)
		if not var_15_3() then
			return false
		end
	end, 1, 0, 1)
end

return var_0_1
