local var_0_0 = require("app.views.city.union.tools")
local var_0_1 = class("UnionFightListReView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "union_fight_battle_review.json"
var_0_1.RESOURCE_BINDING = {
	itemBattle = "itemBattle",
	leftUnionPanel = "leftUnionPanel",
	itemRound = "itemRound",
	itemTip = "itemTip",
	list = "list",
	["itemRound.baseNode.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["itemTip.baseNode.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["itemBattle.baseNode.leftPanel.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(126, 60, 6, 255)
				}
			}
		}
	},
	["itemBattle.baseNode.leftPanel.lv"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["itemBattle.baseNode.leftPanel.level"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["itemBattle.baseNode.leftPanel.team"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["itemBattle.baseNode.leftPanel.hpText"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(238, 210, 171, 255)
				}
			}
		}
	},
	["itemBattle.baseNode.rightPanel.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(126, 60, 6, 255)
				}
			}
		}
	},
	["itemBattle.baseNode.rightPanel.lv"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["itemBattle.baseNode.rightPanel.level"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["itemBattle.baseNode.rightPanel.team"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["itemBattle.baseNode.rightPanel.hpText"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(238, 210, 171, 255)
				}
			}
		}
	},
	["itemBattle.baseNode.leftPanel.self.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(130, 45, 19, 255)
				}
			}
		}
	},
	["itemBattle.baseNode.rightPanel.self.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(130, 45, 19, 255)
				}
			}
		}
	},
	["itemBattle.baseNode.rightEmpty.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(126, 60, 6, 255)
				}
			}
		}
	},
	["itemBattle.baseNode.leftEmpty.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(126, 60, 6, 255)
				}
			}
		}
	},
	btnShowSelf = {
		varname = "btnShowSelf",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowSelf")
			}
		}
	},
	["btnShowSelf.textNote"] = {
		varname = "btnShowSelf",
		binds = {
			{
				event = "text",
				idler = bindHelper.self("showSelf"),
				method = function(arg_1_0)
					return arg_1_0 and gLanguageCsv.UFShowAll or gLanguageCsv.UFShowSelf
				end
			},
			{
				event = "effect",
				data = {
					outline = {
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.role_id = gGameModel.role:read("id")

	local var_2_0 = userDefault.getForeverLocalKey("jsShowSelf", false)

	arg_2_0.showSelf = idler.new(var_2_0)

	local var_2_1 = userDefault.setForeverLocalKey("jsShowSelf", false)

	arg_2_0.unionInfo = arg_2_2
	arg_2_0.hasSelfData = false
	arg_2_0.roundResults = {}
	arg_2_0.roundResultsIsShow = {}

	local function var_2_2(arg_3_0)
		if not arg_2_0.roundResults then
			return
		end

		for iter_3_0, iter_3_1 in pairs(arg_3_0) do
			if iter_3_0 and not arg_2_0.roundResults[iter_3_0] then
				arg_2_0.roundResults[iter_3_0] = iter_3_1
			end
		end

		arg_2_0:refreshRoundResult()
		arg_2_0:setAllBattleEnd(not arg_2_2.is_out, arg_2_2.last_role_name)
	end

	var_2_2(arg_2_1)

	local var_2_3 = arg_2_0.list:getInnerContainer()

	arg_2_0.list:setRenderHint(1)
	arg_2_0.list:onScroll(function(arg_4_0)
		if arg_2_0.inReq then
			return
		end

		if (arg_4_0.name == "AUTOSCROLL_ENDED" or var_2_3:getPositionY() == 0) and arg_2_0.minRound > 1 and (not arg_2_0.curSendRound or arg_2_0.curSendRound <= arg_2_0.minRound - 1) then
			arg_2_0.curSendRound = arg_2_0.minRound - 1
			arg_2_0.inReq = true

			gGameApp:requestServer("/game/union/fight/yesterday/battle", function(arg_5_0)
				arg_2_0.inReq = nil
				arg_2_0.curSendRound = nil

				local var_5_0 = arg_5_0.view.round_results

				var_2_2(var_5_0)
			end, arg_2_0.curSendRound)
		end
	end)
	arg_2_0.leftUnionPanel:get("icon"):texture(gUnionLogoCsv[gGameModel.union:read("logo")])
	arg_2_0.leftUnionPanel:get("name"):text(gGameModel.union:read("name"))
	arg_2_0.leftUnionPanel:get("text2"):text(arg_2_2.last_role_name)
	arg_2_0.leftUnionPanel:get("text3"):text(arg_2_2.signs .. "/" .. arg_2_2.members)
end

function var_0_1.setAllBattleEnd(arg_6_0, arg_6_1, arg_6_2)
	if not arg_6_0.lastTipItem then
		return
	end

	local var_6_0 = arg_6_0.lastTipItem:get("baseNode.text")

	if arg_6_1 then
		local var_6_1 = string.format(gLanguageCsv.unionFightBattleWinner, arg_6_2)

		var_6_0:text("")

		local var_6_2 = rich.createByStr(var_6_1, 52, nil, nil):addTo(var_6_0, 10, "privilege"):anchorPoint(cc.p(0.5, 0.5)):xy(0, 0)
	else
		var_6_0:text(gLanguageCsv.unionFightBattleLoseTip)
		text.addEffect(var_6_0, {
			color = cc.c4b(219, 212, 189, 255)
		})
	end
end

function var_0_1.refreshRoundResult(arg_7_0)
	arg_7_0.maxRound, arg_7_0.minRound = arg_7_0.maxRound or 0, arg_7_0.minRound or math.huge

	local function var_7_0(arg_8_0, arg_8_1)
		if not arg_7_0.roundResultsIsShow[arg_8_0] then
			arg_7_0.roundResultsIsShow[arg_8_0] = true

			local var_8_0

			if arg_8_0 >= arg_7_0.maxRound then
				var_8_0 = arg_7_0.showNewBattleResult
			elseif arg_8_0 <= arg_7_0.minRound then
				var_8_0 = arg_7_0.showOldBattleResult
			else
				var_8_0 = arg_7_0.showOldBattleResult
			end

			if var_8_0 then
				arg_7_0.maxRound = math.max(arg_7_0.maxRound, arg_8_0)
				arg_7_0.minRound = math.min(arg_7_0.minRound, arg_8_0)

				var_8_0(arg_7_0, arg_8_0, arg_8_1)
			end
		end
	end

	local var_7_1 = clone(arg_7_0.roundResults)

	while next(var_7_1) do
		local var_7_2 = 0
		local var_7_3

		for iter_7_0, iter_7_1 in pairs(var_7_1) do
			if iter_7_0 <= arg_7_0.minRound and var_7_2 <= iter_7_0 then
				var_7_2 = iter_7_0
				var_7_3 = iter_7_1
			end
		end

		if not var_7_3 then
			break
		end

		var_7_0(var_7_2, var_7_3)

		var_7_1[var_7_2] = nil
	end
end

function var_0_1.showOldBattleResult(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0:setRoundNum(arg_9_1, true)
	arg_9_0:roundEnd(true, arg_9_1, true)

	for iter_9_0, iter_9_1 in ipairs(arg_9_2) do
		if arg_9_0.showSelf:read() == true then
			if iter_9_1.left.role_id == arg_9_0.role_id or iter_9_1.right.role_id == arg_9_0.role_id then
				arg_9_0.hasSelfData = true

				arg_9_0:insertBattleInfo(iter_9_1, true)
			end
		else
			arg_9_0:insertBattleInfo(iter_9_1, true)
		end
	end
end

function var_0_1.showNewBattleResult(arg_10_0, arg_10_1, arg_10_2)
	arg_10_0:setRoundNum(arg_10_1)

	for iter_10_0, iter_10_1 in ipairs(arg_10_2) do
		if arg_10_0.showSelf:read() == true then
			if iter_10_1.left.role_id == arg_10_0.role_id or iter_10_1.right.role_id == arg_10_0.role_id then
				arg_10_0.hasSelfData = true

				arg_10_0:insertBattleInfo(iter_10_1)
			end
		else
			arg_10_0:insertBattleInfo(iter_10_1)
		end
	end

	arg_10_0:roundEnd(true, arg_10_1)
end

function var_0_1.roundEnd(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	arg_11_1 = arg_11_1 or true

	local var_11_0 = string.format(gLanguageCsv.unionFightBattleWinTip, arg_11_2)

	if not arg_11_1 then
		var_11_0 = gLanguageCsv.unionFightBattleLoseTip
	end

	local var_11_1 = arg_11_0:insertTip(var_11_0, arg_11_3)

	if not arg_11_0.maxRound or arg_11_2 >= arg_11_0.maxRound then
		arg_11_0.lastTipItem = var_11_1
	end
end

function var_0_1.setRoundNum(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0.itemRound:clone()

	var_12_0:get("baseNode"):multiget("text").text:text(string.format(gLanguageCsv.unionFightRound, arg_12_1))

	if arg_12_2 then
		arg_12_0.list:pushBackCustomItem(var_12_0)
	else
		arg_12_0.list:insertCustomItem(var_12_0, 0)
	end

	return var_12_0
end

function var_0_1.insertBattleInfo(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0.itemBattle:clone()
	local var_13_1 = false
	local var_13_2 = var_13_0:get("baseNode"):multiget("btnReplay", "leftPanel", "rightPanel", "leftEmpty", "rightEmpty")

	local function var_13_3(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
		if not arg_14_1.role_id then
			var_13_1 = true

			arg_14_0:hide()
			arg_14_3:show()

			return
		end

		local var_14_0 = arg_14_0:multiget("roleIcon", "level", "name", "unionName", "team", "hpText", "hpBar", "win", "self")

		bind.extend(arg_13_0, var_14_0.roleIcon, {
			event = "extend",
			class = "role_logo",
			props = {
				vip = false,
				level = false,
				logoId = arg_14_1.role_logo,
				frameId = arg_14_1.role_frame
			}
		})
		var_14_0.level:text(arg_14_1.role_level)
		var_14_0.name:text(arg_14_1.role_name)
		var_14_0.unionName:text(arg_14_1.union_name)
		var_14_0.team:text(string.format(gLanguageCsv.unionFightTeam, arg_14_1.troops))

		local var_14_1 = arg_14_1.hp > 0 and string.format(gLanguageCsv.unionFightHpText, arg_14_1.hp .. "%") or gLanguageCsv.unionFightDead

		var_14_0.hpText:text(var_14_1)
		var_14_0.self:visible(arg_14_1.role_id == gGameModel.role:read("id"))
		bind.extend(arg_13_0, var_14_0.hpBar, {
			event = "extend",
			class = "loadingbar",
			props = {
				maskImg = "city/union/union_fight/jdt_1.png",
				data = arg_14_1.hp
			}
		})
		var_14_0.hpBar:setPercent(arg_14_1.hp)
		var_14_0.win:visible(arg_14_2)
	end

	local var_13_4 = gGameModel.role:read("union_db_id")
	local var_13_5 = arg_13_1.left
	local var_13_6 = arg_13_1.right
	local var_13_7 = arg_13_1.result == "win"
	local var_13_8 = false

	if var_13_5.union_id and var_13_5.union_id ~= var_13_4 and var_13_6.union_id and var_13_6.union_id == var_13_4 then
		var_13_5 = arg_13_1.right
		var_13_6 = arg_13_1.left
		var_13_7 = not var_13_7
		var_13_8 = true
	end

	var_13_3(var_13_2.leftPanel:show(), var_13_5, var_13_7, var_13_2.leftEmpty:hide())
	var_13_3(var_13_2.rightPanel:show(), var_13_6, not var_13_7, var_13_2.rightEmpty:hide())

	if var_13_1 then
		var_13_2.btnReplay:setTouchEnabled(false)
	else
		bind.touch(arg_13_0.list, var_13_2.btnReplay, {
			methods = {
				ended = arg_13_0:createHandler("onReplayClick", arg_13_1.play_id, var_13_8)
			}
		})
	end

	if arg_13_2 then
		arg_13_0.list:pushBackCustomItem(var_13_0)
	else
		arg_13_0.list:insertCustomItem(var_13_0, 1)
	end

	return var_13_0
end

function var_0_1.insertTip(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0.itemTip:clone()

	var_15_0:get("baseNode"):multiget("text").text:text(arg_15_1)

	if arg_15_2 then
		arg_15_0.list:pushBackCustomItem(var_15_0)
	else
		arg_15_0.list:insertCustomItem(var_15_0, 1)
	end

	return var_15_0
end

function var_0_1.onReplayClick(arg_16_0, arg_16_1, arg_16_2)
	userDefault.setForeverLocalKey("jsShowSelf", arg_16_0.showSelf:read())

	arg_16_2 = arg_16_2 and 1 or 0

	local var_16_0 = "/game/union/fight/playrecord/get"

	gGameModel:playRecordBattle(arg_16_1, nil, var_16_0, arg_16_2, nil)
end

function var_0_1.onShowSelf(arg_17_0)
	local function var_17_0()
		arg_17_0.showSelf:modify(function(arg_19_0)
			return true, not arg_19_0
		end)
		arg_17_0.list:removeAllChildren()

		arg_17_0.maxRound, arg_17_0.minRound = 0, math.huge
		arg_17_0.roundResultsIsShow = {}

		arg_17_0:refreshRoundResult()
		arg_17_0:setAllBattleEnd(not arg_17_0.unionInfo.is_out, arg_17_0.unionInfo.last_role_name)
		arg_17_0.list:jumpToTop()
	end

	if not arg_17_0.hasSelfData and arg_17_0.showSelf:read() == false then
		gGameApp:requestServer("/game/union/fight/rank", function(arg_20_0)
			local var_20_0 = 0

			for iter_20_0, iter_20_1 in csvMapPairs(arg_20_0.view) do
				var_20_0 = math.max(iter_20_0, var_20_0)
			end

			if arg_20_0.view[var_20_0].my_rank[2] == 0 then
				gGameUI:showTip(gLanguageCsv.UFRecordNoSelfData)

				return
			else
				var_17_0()
			end
		end)
	else
		var_17_0()
	end
end

return var_0_1
