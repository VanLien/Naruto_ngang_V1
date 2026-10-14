local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("CrossArenaView", var_0_0)

var_0_1.RESOURCE_FILENAME = "cross_arena.json"
var_0_1.RESOURCE_BINDING = {
	["serverPanel.subList"] = "serverSubList",
	["serverPanel.item"] = "serverItem",
	bgPanel = "bgPanel",
	noServerPanel = "noServerPanel",
	serverPanel = "serverPanel",
	["serverPanel.textNote"] = {
		varname = "serverTextNote",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["serverPanel.textTime"] = {
		varname = "textTime",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["serverPanel.item.textServer"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["serverPanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 4,
				data = bindHelper.self("servers"),
				item = bindHelper.self("serverSubList"),
				cell = bindHelper.self("serverItem"),
				title = bindHelper.self("title"),
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("textServer"):text(string.format(gLanguageCsv.brackets, getServerArea(arg_1_3, nil, true)))
				end,
				onAfterBuild = function(arg_2_0)
					for iter_2_0, iter_2_1 in pairs(arg_2_0:getChildren()) do
						iter_2_1:setItemAlignCenter()
					end
				end
			}
		}
	},
	["downPanel.rankReward"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onRankRewardClick")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = {
						"crossArenaPointAward",
						"crossArenaRankAward"
					}
				}
			}
		}
	},
	["downPanel.rankReward.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["downPanel.rule"] = {
		varname = "rulePanel",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleClick")
			}
		}
	},
	["downPanel.rule.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["downPanel.defend"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDefendArrayClick")
			}
		}
	},
	["downPanel.defend.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["downPanel.rank"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRankClick")
			}
		}
	},
	["downPanel.rank.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["downPanel.record"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRecordClick")
			}
		}
	},
	["downPanel.record.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["downPanel.shop"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShopClick")
			}
		}
	},
	["downPanel.shop.name"] = {
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

function var_0_1.onCreate(arg_3_0, arg_3_1)
	gGameUI.topuiManager:createView("default", arg_3_0, {
		onClose = arg_3_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = "common/txt/txt_bt_kuafujingjichang.png"
	})

	arg_3_0.data = arg_3_1

	arg_3_0:initModel()

	arg_3_0.subView = {}
	arg_3_0.subViewFunc = {
		selectEnemy = function(...)
			return gGameUI:createView("city.pvp.cross_arena.select_enemy", arg_3_0):init(...)
		end,
		over = function(...)
			return gGameUI:createView("city.pvp.cross_arena.over", arg_3_0):init(...)
		end
	}

	idlereasy.when(arg_3_0.round, function(arg_6_0, arg_6_1)
		local var_6_0 = false
		local var_6_1

		if arg_6_1 == "start" then
			arg_3_0.noServerPanel:hide()
			arg_3_0.serverPanel:hide()

			var_6_1 = "selectEnemy"

			arg_3_0:removeChildByName("paomingbg")
			arg_3_0:removeChildByName("kufujinjichang1")
			arg_3_0:removeChildByName("kufujinjichang2")
		elseif arg_6_1 == "closed" then
			local var_6_2 = arg_3_0:getCloseState()

			if var_6_2 == "showResult" then
				arg_3_0.noServerPanel:hide()
				arg_3_0.serverPanel:hide()

				var_6_1 = "over"

				arg_3_0:removeChildByName("kfjjc_bj")
				arg_3_0:removeChildByName("kufujinjichang1")
				arg_3_0:removeChildByName("kufujinjichang2")
			elseif var_6_2 == "showService" then
				arg_3_0.noServerPanel:hide()
				arg_3_0.serverPanel:show()
				arg_3_0:initServerPanel()
				arg_3_0:removeChildByName("kfjjc_bj")
				arg_3_0:removeChildByName("paomingbj")
				arg_3_0:removeChildByName("kufujinjichang2")
			else
				arg_3_0.noServerPanel:show()
				arg_3_0.serverPanel:hide()
				arg_3_0:removeChildByName("kfjjc_bj")
				arg_3_0:removeChildByName("paomingbj")
				arg_3_0:removeChildByName("kufujinjichang1")
			end
		end

		arg_3_0:showSubView(var_6_1)
	end)
end

function var_0_1.getCloseState(arg_7_0)
	local var_7_0 = dataEasy.getCrossServiceData("crossarena")

	if var_7_0 then
		local var_7_1 = csv.cross.service[var_7_0]

		arg_7_0.date = var_7_1.date

		local var_7_2 = time.getNumTimestamp(var_7_1.date, 5) - 172800
		local var_7_3 = time.getNumTimestamp(var_7_1.date, 10)

		if var_7_2 <= time.getTime() and time.getTime() < var_7_3 + 1123200 then
			arg_7_0.servers:update(getMergeServers(var_7_1.servers))
			arg_7_0:countToStart(var_7_3 - time.getTime())

			game.crossArenaCsvId = var_7_0

			return "showService"
		end
	end

	if itertools.size(arg_7_0.lastRanks:read()) > 0 then
		return "showResult"
	end
end

function var_0_1.countToStart(arg_8_0, arg_8_1)
	if arg_8_0.round:read() ~= "closed" then
		return
	end

	if arg_8_1 < 0 then
		arg_8_1 = 10
	end

	performWithDelay(arg_8_0, function()
		gGameApp:requestServer("/game/cross/arena/battle/main", functools.handler(arg_8_0, "countToStart", 10))
	end, arg_8_1)
end

function var_0_1.initServerPanel(arg_10_0)
	local var_10_0 = time.getNumTimestamp(arg_10_0.date)
	local var_10_1 = time.getDate(var_10_0)
	local var_10_2 = string.formatex(gLanguageCsv.timeMonthDay, {
		month = var_10_1.month,
		day = var_10_1.day
	}) .. "10:00"
	local var_10_3 = time.getNumTimestamp(arg_10_0.date) + 1123200
	local var_10_4 = time.getDate(var_10_3)
	local var_10_5 = string.formatex(gLanguageCsv.timeMonthDay, {
		month = var_10_4.month,
		day = var_10_4.day
	}) .. "22:00"

	arg_10_0.textTime:text(var_10_2 .. "--" .. var_10_5)
	adapt.oneLineCenterPos(cc.p(750, 750), {
		arg_10_0.serverTextNote,
		arg_10_0.textTime
	}, cc.p(40, 0))
end

function var_0_1.initModel(arg_11_0)
	arg_11_0.round = gGameModel.cross_arena:getIdler("round")
	arg_11_0.lastRanks = gGameModel.cross_arena:getIdler("lastRanks")
	arg_11_0.servers = idlers.newWithMap({})
	game.crossArenaCsvId = gGameModel.cross_arena:read("csvID")
end

function var_0_1.showSubView(arg_12_0, arg_12_1, ...)
	if arg_12_0.subView.name ~= arg_12_1 then
		if arg_12_0.subView.view then
			arg_12_0.subView.view:onClose()
		end

		if arg_12_1 == nil then
			arg_12_0.subView = {}
		else
			arg_12_0.subView = {
				name = arg_12_1,
				view = arg_12_0.subViewFunc[arg_12_1](...)
			}
		end
	end
end

function var_0_1.onRankRewardClick(arg_13_0)
	if arg_13_0.round:read() == "closed" and not arg_13_0:getCloseState() then
		gGameUI:showTip(gLanguageCsv.crossCraftFirstPrepare)
	else
		gGameUI:stackUI("city.pvp.cross_arena.point_reward")
	end
end

function var_0_1.onRuleClick(arg_14_0)
	if not arg_14_0.rulePanel:get("ruleItem") then
		ccui.Layout:create():hide():addTo(arg_14_0.rulePanel, 1, "ruleItem")
	end

	gGameUI:stackUI("common.rule", nil, nil, arg_14_0:createHandler("getRuleContext"), {
		width = 1500
	})
end

function var_0_1.getRuleContext(arg_15_0, arg_15_1)
	local var_15_0 = adaptContext
	local var_15_1 = {
		var_15_0.clone(arg_15_1.title, function(arg_16_0)
			arg_16_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_15_0.noteText(144),
		var_15_0.noteText(86001, 86010),
		var_15_0.noteText(145),
		var_15_0.noteText(87001, 87010),
		var_15_0.noteText(146),
		var_15_0.noteText(88001, 88010)
	}

	if arg_15_0.round:read() == "start" then
		local var_15_2 = gGameModel.cross_arena:read("servers")

		if var_15_2 then
			local var_15_3 = arraytools.map(getMergeServers(var_15_2), function(arg_17_0, arg_17_1)
				return string.format(gLanguageCsv.brackets, getServerArea(arg_17_1, nil, true))
			end)

			table.insert(var_15_1, 2, "#C0xFFFFFF#" .. gLanguageCsv.currentServers .. table.concat(var_15_3, ","))
		end

		local var_15_4 = gGameModel.cross_arena:read("role")

		if var_15_4.top_rank then
			local var_15_5 = arg_15_0.rulePanel:get("ruleItem")
			local var_15_6 = arg_15_1.list:width()
			local var_15_7 = dataEasy.getCrossArenaStageByRank(var_15_4.top_rank)
			local var_15_8 = var_15_7.stageName .. " " .. var_15_7.rank

			table.insert(var_15_1, 2, var_15_0.clone(var_15_5, function(arg_18_0)
				local var_18_0, var_18_1 = beauty.textScroll({
					isRich = true,
					align = "center",
					size = cc.size(var_15_6, 0),
					strs = string.format(gLanguageCsv.crossArenaRankHighest .. var_15_8)
				})

				var_18_0:height(var_18_1)
				arg_18_0:size(var_15_6, var_18_1):add(var_18_0)
			end))
		end
	end

	return var_15_1
end

function var_0_1.onDefendArrayClick(arg_19_0)
	if arg_19_0.round:read() == "start" then
		gGameUI:stackUI("city.pvp.cross_arena.embattle", nil, {
			full = true
		}, {
			type = "defence"
		})
	else
		gGameUI:showTip(gLanguageCsv.crossArenaNotStart)
	end
end

function var_0_1.onRankClick(arg_20_0)
	if arg_20_0.round:read() == "start" or arg_20_0:getCloseState() == "showResult" then
		gGameApp:requestServer("/game/cross/arena/rank", function(arg_21_0)
			gGameUI:stackUI("city.pvp.cross_arena.rank", nil, nil, arg_21_0.view)
		end, 0, 10)
	else
		gGameUI:showTip(gLanguageCsv.crossArenaNoRank)
	end
end

function var_0_1.onRecordClick(arg_22_0)
	gGameUI:stackUI("city.pvp.cross_arena.combat_record")
end

function var_0_1.onShopClick(arg_23_0)
	gGameUI:showTip(gLanguageCsv.comingSoon)
end

return var_0_1
