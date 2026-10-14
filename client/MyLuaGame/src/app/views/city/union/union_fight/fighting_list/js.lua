local var_0_0 = require("app.views.city.union.tools")
local var_0_1 = class("UnionFightListJSView", cc.load("mvc").ViewBase)
local var_0_2 = 5

var_0_1.RESOURCE_FILENAME = "union_fight_fighting_list_dialog.json"
var_0_1.RESOURCE_BINDING = {
	itemBattle = "itemBattle",
	["leftUnionPanel.union1"] = "union1",
	leftUnionPanel = "leftUnionPanel",
	["leftUnionPanel.union2"] = "union2",
	itemRound = "itemRound",
	itemTip = "itemTip",
	list = "list",
	["itemRound.baseNode.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(59, 51, 59, 255)
				}
			}
		}
	},
	["itemTip.baseNode.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(59, 51, 59, 255)
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
					color = cc.c4b(59, 51, 59, 255)
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
					color = cc.c4b(59, 51, 59, 255)
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
	["leftUnionPanel.union1.lv"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(72, 2, 1, 255)
				}
			}
		}
	},
	["leftUnionPanel.union1.level"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(72, 2, 1, 255)
				}
			}
		}
	},
	["leftUnionPanel.union2.lv"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(72, 2, 1, 255)
				}
			}
		}
	},
	["leftUnionPanel.union2.level"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(72, 2, 1, 255)
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

local var_0_3 = ""

function var_0_1.onCreate(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0.role_id = gGameModel.role:read("id")

	local var_2_0 = userDefault.getForeverLocalKey("jsShowSelf", false)

	arg_2_0.showSelf = idler.new(var_2_0)

	local var_2_1 = userDefault.setForeverLocalKey("jsShowSelf", false)
	local var_2_2 = gGameModel.role:read("union_db_id")

	if arg_2_2.left.id ~= var_2_2 and arg_2_2.right.id ~= var_2_2 then
		arg_2_0.btnShowSelf:hide()
	end

	arg_2_0.data = arg_2_1
	arg_2_0.insertItemsTb = {}

	local var_2_3 = arg_2_0:checkAniOpen(arg_2_2.right.name)

	if arg_2_3 then
		var_2_3 = false
	end

	if var_2_3 then
		arg_2_0:showAllBattleResultWithAni(arg_2_1)
		arg_2_0:startRefreshTime()
	else
		arg_2_0:showAllBattleResult(arg_2_1)
	end

	local function var_2_4(arg_3_0, arg_3_1)
		arg_3_1:get("icon"):texture(gUnionLogoCsv[arg_3_0.icon])
		arg_3_1:get("name"):text(arg_3_0.name)
		arg_3_1:get("win"):visible(arg_3_0.isWin)
		arg_3_1:get("level"):text(arg_3_0.level)
	end

	var_2_4(arg_2_2.left, arg_2_0.union1)
	var_2_4(arg_2_2.right, arg_2_0.union2)

	local var_2_5 = arg_2_0.list:getInnerContainer()

	arg_2_0.list:onScroll(function(arg_4_0)
		if arg_4_0.name == "AUTOSCROLL_ENDED" or var_2_5:getPositionY() == 0 then
			if var_2_3 then
				return
			end

			if arg_2_0.minRound and arg_2_0.minRound > 0 then
				arg_2_0:showAllBattleResult(arg_2_1)
			end
		end
	end)
end

function var_0_1.checkAniOpen(arg_5_0, arg_5_1)
	if var_0_3 == arg_5_1 then
		return false
	end

	var_0_3 = arg_5_1

	return true
end

function var_0_1.showAllBattleResult(arg_6_0, arg_6_1)
	arg_6_0.minRound = arg_6_0.minRound or math.huge

	local var_6_0 = 0

	for iter_6_0, iter_6_1 in ipairs(arg_6_1) do
		var_6_0 = math.max(var_6_0, iter_6_0)
	end

	arg_6_0.minRound = math.min(arg_6_0.minRound, var_6_0)

	if not arg_6_0.roundEndItem then
		local var_6_1 = arg_6_1[var_6_0]
		local var_6_2 = var_6_1.left
		local var_6_3 = var_6_1.right
		local var_6_4 = var_6_1.result == "win"
		local var_6_5 = var_6_4 and var_6_2 or var_6_3
		local var_6_6 = var_6_4 and var_6_3 or var_6_2

		arg_6_0:roundEnd(var_6_5, var_6_6)
	end

	local var_6_7 = math.huge

	for iter_6_2 = arg_6_0.minRound, arg_6_0.minRound - var_0_2, -1 do
		local var_6_8 = arg_6_1[iter_6_2]

		if var_6_8 then
			arg_6_0:insertBattleInfo(var_6_8, nil, true)

			var_6_7 = math.min(var_6_7, iter_6_2)
		else
			break
		end
	end

	arg_6_0.minRound = var_6_7 - 1
end

function var_0_1.showAllBattleResultWithAni(arg_7_0, arg_7_1)
	local var_7_0 = 0
	local var_7_1 = 1

	local function var_7_2(arg_8_0, arg_8_1, arg_8_2)
		local var_8_0 = arg_7_0.itemRound:clone():retain()
		local var_8_1 = arg_8_2 and arg_8_0 or arg_8_0 - 1

		var_8_0:get("baseNode"):get("text"):text(string.format(gLanguageCsv.roundNumber, var_8_1))

		var_7_1 = arg_8_0

		table.insert(arg_7_0.insertItemsTb, {
			delay = 0.4,
			index = 0,
			item = var_8_0
		})

		if not arg_8_2 then
			var_7_0 = math.max(var_7_0, arg_8_1)
		end
	end

	for iter_7_0, iter_7_1 in ipairs(arg_7_1) do
		if iter_7_1.top8_3v3_round ~= var_7_1 then
			var_7_2(iter_7_1.top8_3v3_round, iter_7_0)
		end

		table.insert(arg_7_0.insertItemsTb, {
			delay = 0.4,
			index = 0,
			item = arg_7_0:insertBattleInfo(iter_7_1, true):retain()
		})

		var_7_0 = math.max(var_7_0, iter_7_0)
	end

	var_7_2(var_7_1, nil, true)

	local var_7_3 = arg_7_1[var_7_0]
	local var_7_4 = var_7_3.left
	local var_7_5 = var_7_3.right
	local var_7_6 = var_7_3.result == "win"
	local var_7_7 = var_7_6 and var_7_4 or var_7_5
	local var_7_8 = var_7_6 and var_7_5 or var_7_4

	table.insert(arg_7_0.insertItemsTb, {
		delay = 0.3,
		index = 0,
		item = arg_7_0:roundEnd(var_7_7, var_7_8, true):retain()
	})
end

function var_0_1.roundEnd(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = gGameModel.role:read("union_db_id")
	local var_9_1

	if arg_9_1.union_id == var_9_0 then
		var_9_1 = true
	elseif arg_9_2.union_id == var_9_0 then
		var_9_1 = false
	end

	local var_9_2 = ""
	local var_9_3

	if var_9_1 == true then
		var_9_2 = gLanguageCsv.unionFightFinalWin
	elseif var_9_1 == false then
		var_9_3 = cc.c4b(219, 212, 189, 255)
		var_9_2 = gLanguageCsv.unionFightFinalLose
	else
		var_9_2 = string.format(gLanguageCsv.unionFightOtherBattle, arg_9_2.union_name, arg_9_1.union_name)
	end

	local var_9_4 = arg_9_0:insertTip(var_9_2, var_9_3, arg_9_3)

	arg_9_0.roundEndItem = var_9_4

	return var_9_4
end

function var_0_1.insertBattleInfo(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	arg_10_0.resultTop8 = arg_10_0.resultTop8 or arg_10_1.top8_3v3_round and arg_10_0.resultTop8

	local var_10_0 = true

	if arg_10_0.showSelf:read() and arg_10_0.role_id ~= arg_10_1.left.role_id and arg_10_0.role_id ~= arg_10_1.right.role_id then
		var_10_0 = false
	end

	local var_10_1 = arg_10_0.itemBattle:clone()
	local var_10_2 = false
	local var_10_3 = var_10_1:get("baseNode"):multiget("btnReplay", "leftPanel", "rightPanel", "leftEmpty", "rightEmpty")

	local function var_10_4(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
		if not arg_11_1.role_id then
			var_10_2 = true

			arg_11_0:hide()
			arg_11_3:show()

			return
		end

		local var_11_0 = arg_11_0:multiget("roleIcon", "level", "name", "unionName", "team", "hpText", "hpBar", "win", "self")

		bind.extend(arg_10_0, var_11_0.roleIcon, {
			event = "extend",
			class = "role_logo",
			props = {
				vip = false,
				level = false,
				logoId = arg_11_1.role_logo,
				frameId = arg_11_1.role_frame
			}
		})
		var_11_0.level:text(arg_11_1.role_level)
		var_11_0.name:text(arg_11_1.role_name)
		var_11_0.unionName:text(arg_11_1.union_name)
		var_11_0.team:text(string.format(gLanguageCsv.unionFightTeam, arg_11_1.troops))

		local var_11_1 = arg_11_1.hp > 0 and string.format(gLanguageCsv.unionFightHpText, arg_11_1.hp .. "%") or gLanguageCsv.unionFightDead

		var_11_0.hpText:text(var_11_1)
		var_11_0.self:visible(arg_11_1.role_id == gGameModel.role:read("id"))
		bind.extend(arg_10_0, var_11_0.hpBar, {
			event = "extend",
			class = "loadingbar",
			props = {
				maskImg = "city/union/union_fight/jdt_1.png",
				data = arg_11_1.hp
			}
		})
		var_11_0.hpBar:setPercent(arg_11_1.hp)
		var_11_0.win:visible(arg_11_2)
	end

	local var_10_5 = gGameModel.role:read("union_db_id")
	local var_10_6 = arg_10_1.left
	local var_10_7 = arg_10_1.right
	local var_10_8 = arg_10_1.result == "win"
	local var_10_9 = false

	if var_10_6.union_id and var_10_6.union_id ~= var_10_5 and var_10_7.union_id and var_10_7.union_id == var_10_5 then
		var_10_6 = arg_10_1.right
		var_10_7 = arg_10_1.left
		var_10_8 = not var_10_8
		var_10_9 = true
	end

	var_10_4(var_10_3.leftPanel:show(), var_10_6, var_10_8, var_10_3.leftEmpty:hide())
	var_10_4(var_10_3.rightPanel:show(), var_10_7, not var_10_8, var_10_3.rightEmpty:hide())

	if var_10_2 then
		var_10_3.btnReplay:setTouchEnabled(false)
	else
		bind.touch(arg_10_0.list, var_10_3.btnReplay, {
			methods = {
				ended = arg_10_0:createHandler("onReplayClick", arg_10_1.play_id, var_10_9)
			}
		})
	end

	if not arg_10_2 then
		if arg_10_3 then
			if arg_10_0.resultTop8 ~= arg_10_1.top8_3v3_round then
				local var_10_10 = arg_10_0.itemRound:clone()

				var_10_10:get("baseNode"):get("text"):text(string.format(gLanguageCsv.roundNumber, arg_10_1.top8_3v3_round))
				arg_10_0.list:pushBackCustomItem(var_10_10)

				arg_10_0.resultTop8 = arg_10_1.top8_3v3_round
			end

			if var_10_0 then
				arg_10_0.list:pushBackCustomItem(var_10_1)
			end
		elseif var_10_0 then
			arg_10_0.list:insertCustomItem(var_10_1, 0)
		end
	end

	return var_10_1
end

function var_0_1.insertTip(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_0.itemTip:clone()
	local var_12_1 = var_12_0:get("baseNode"):multiget("text")

	var_12_1.text:text(arg_12_1)

	if arg_12_2 then
		text.addEffect(var_12_1.text, {
			color = arg_12_2
		})
	end

	arg_12_0.lastTipItem = var_12_0

	if not arg_12_3 then
		arg_12_0.list:insertCustomItem(var_12_0, 0)
	end

	return var_12_0
end

function var_0_1.onReplayClick(arg_13_0, arg_13_1, arg_13_2)
	userDefault.setForeverLocalKey("jsShowSelf", arg_13_0.showSelf:read())

	arg_13_2 = arg_13_2 and 1 or 0

	local var_13_0 = "/game/union/fight/playrecord/get"

	gGameModel:playRecordBattle(arg_13_1, nil, var_13_0, arg_13_2, nil)
end

function var_0_1.addNewBattleInfo(arg_14_0)
	if arg_14_0.inAni then
		return false
	end

	if not arg_14_0.insertItemsTb or not next(arg_14_0.insertItemsTb) then
		arg_14_0.inAni = false

		return true
	end

	local var_14_0 = arg_14_0.insertItemsTb[1]

	table.remove(arg_14_0.insertItemsTb, 1)

	local function var_14_1(arg_15_0, arg_15_1, arg_15_2)
		arg_15_2 = math.min(arg_15_2, 0.3)

		local var_15_0 = arg_15_0:size().height
		local var_15_1 = false

		if arg_15_1 >= arg_14_0.list:getChildrenCount() then
			arg_14_0.list:insertCustomItem(arg_15_0, arg_15_1)

			arg_14_0.inAni = false

			return
		end

		for iter_15_0, iter_15_1 in pairs(arg_14_0.list:getChildren()) do
			if arg_15_1 < iter_15_0 then
				local var_15_2 = iter_15_1:get("baseNode")
				local var_15_3, var_15_4 = var_15_2:xy()

				var_15_2:setTouchEnabled(false)
				transition.executeSequence(var_15_2, true):moveTo(arg_15_2, var_15_3, var_15_4 - var_15_0):func(function()
					var_15_2:xy(var_15_3, var_15_4)
					var_15_2:setTouchEnabled(true)

					if not var_15_1 then
						arg_14_0.list:insertCustomItem(arg_15_0, arg_15_1)

						arg_14_0.inAni = false
						var_15_1 = true
					end
				end):done()
			end
		end
	end

	arg_14_0.inAni = true

	var_14_1(var_14_0.item, var_14_0.index, var_14_0.delay)

	return false
end

function var_0_1.startRefreshTime(arg_17_0)
	local var_17_0 = 3031825
	local var_17_1 = 0.5

	arg_17_0:enableSchedule():unSchedule(var_17_0)
	arg_17_0:enableSchedule():schedule(function(arg_18_0)
		if arg_17_0:addNewBattleInfo() then
			arg_17_0:enableSchedule():unSchedule(var_17_0)
		else
			return
		end
	end, var_17_1, 0, var_17_0)
end

function var_0_1.onShowSelf(arg_19_0)
	local var_19_0 = false

	for iter_19_0, iter_19_1 in ipairs(arg_19_0.data) do
		if iter_19_1.left.role_id == arg_19_0.role_id or iter_19_1.right.role_id == arg_19_0.role_id then
			var_19_0 = true
		end
	end

	if not var_19_0 then
		gGameUI:showTip(gLanguageCsv.UFRecordNoSelfData)

		return
	end

	arg_19_0.showSelf:modify(function(arg_20_0)
		return true, not arg_20_0
	end)
	arg_19_0:enableSchedule():unScheduleAll()

	arg_19_0.insertItemsTb = {}

	arg_19_0.list:removeAllChildren()

	arg_19_0.minRound = math.huge

	arg_19_0:showAllBattleResult(arg_19_0.data)
	arg_19_0.list:jumpToTop()
end

return var_0_1
