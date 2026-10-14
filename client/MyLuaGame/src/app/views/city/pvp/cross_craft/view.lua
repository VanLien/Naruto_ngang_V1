local var_0_0 = 12
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("CrossCraftView", var_0_1)

var_0_2.RESOURCE_FILENAME = "cross_craft.json"
var_0_2.RESOURCE_BINDING = {
	["signupPanel.title"] = "title",
	countdownPanel = "countdownPanel",
	rightBtn = "rightBtn",
	["signupPanel.bg"] = "bg",
	["signupPanel.item"] = "signupItem",
	["signupPanel.signed"] = "signedPanel",
	overPanel = "overPanel",
	leftBtn2 = "leftBtn2",
	bgPanel = "bgPanel",
	firstPanel = "firstPanel",
	signupPanel = "signupPanel",
	leftBtn1 = "leftBtn1",
	["signupPanel.subList"] = "signupSubList",
	["firstPanel.tipTime"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["signupPanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 5,
				data = bindHelper.self("servers"),
				item = bindHelper.self("signupSubList"),
				cell = bindHelper.self("signupItem"),
				bg = bindHelper.self("bg"),
				title = bindHelper.self("title"),
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("server"):text(string.format(gLanguageCsv.brackets, getServerArea(arg_1_3, nil, true)))
					text.addEffect(arg_1_1:get("server"), {
						outline = {
							size = 3,
							color = cc.c4b(72, 74, 133, 255)
						}
					})
				end,
				onAfterBuild = function(arg_2_0)
					local var_2_0 = arg_2_0:getChildrenCount()

					if var_2_0 == 1 then
						for iter_2_0, iter_2_1 in pairs(arg_2_0:getChildren()) do
							iter_2_1:setItemAlignCenter()
						end

						arg_2_0:setItemAlignCenter()
					else
						local var_2_1 = arg_2_0.item:height()

						arg_2_0:height(var_2_1 * var_2_0)
						arg_2_0.bg:height(128 + var_2_1 * (var_2_0 - 1))
						arg_2_0.title:y(486 + var_2_1 * (var_2_0 - 1))
					end
				end
			}
		}
	},
	["signupPanel.btn"] = {
		varname = "signupBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSignupClick")
			}
		}
	},
	["signupPanel.btn.txt"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.YELLOW,
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["signupPanel.signed.timeText"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["signupPanel.signed.time"] = {
		varname = "signedTime",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["signupPanel.tipTime"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["signupPanel.vipShow"] = {
		varname = "vipShow",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["countdownPanel.tip"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["countdownPanel.time"] = {
		varname = "otherTime",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["leftBtn2.mainSchedule.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["leftBtn2.mySchedule.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["leftBtn2.myTeam.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["leftBtn1.myTeam.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["overPanel.top1"] = {
		binds = {
			event = "click",
			method = bindHelper.defer(function(arg_3_0)
				return arg_3_0:onShowInfo(1)
			end)
		}
	},
	["overPanel.top2"] = {
		binds = {
			event = "click",
			method = bindHelper.defer(function(arg_4_0)
				return arg_4_0:onShowInfo(2)
			end)
		}
	},
	["overPanel.top3"] = {
		binds = {
			event = "click",
			method = bindHelper.defer(function(arg_5_0)
				return arg_5_0:onShowInfo(3)
			end)
		}
	},
	["overPanel.tip"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["leftBtn1.myTeam"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onMyTeamClick")
			}
		}
	},
	["leftBtn2.myTeam"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onMyTeamClick")
			}
		}
	},
	["leftBtn2.mySchedule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onMyScheduleClick")
			}
		}
	},
	["leftBtn2.mainSchedule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onMainScheduleClick")
			}
		}
	},
	["rightBtn.rule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleClick")
			}
		}
	},
	["rightBtn.rule.name"] = {
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
	["rightBtn.rankReward"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRankRewardClick")
			}
		}
	},
	["rightBtn.rankReward.name"] = {
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
	["rightBtn.record"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRecordClick")
			}
		}
	},
	["rightBtn.record.name"] = {
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
	["rightBtn.bet"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBetClick")
			}
		}
	},
	["rightBtn.bet.name"] = {
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
	["rightBtn.shop"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShopClick")
			}
		}
	},
	["rightBtn.shop.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	}
}

function var_0_2.onCleanup(arg_6_0)
	arg_6_0._topuiState = arg_6_0.topuiState:read()

	var_0_1.onCleanup(arg_6_0)
end

function var_0_2.onCreate(arg_7_0)
	arg_7_0:initModel()
	arg_7_0:enableSchedule()

	arg_7_0.topuiState = idler.new(arg_7_0._topuiState or 1)
	arg_7_0.subView = {}

	local var_7_0 = {
		arg_7_0.firstPanel,
		arg_7_0.signupPanel,
		arg_7_0.overPanel,
		arg_7_0.countdownPanel,
		arg_7_0.leftBtn1,
		arg_7_0.leftBtn2,
		arg_7_0.signupBtn,
		arg_7_0.signedPanel,
		arg_7_0.vipShow
	}

	arg_7_0.subViewFunc = {
		battleMessages = function(...)
			return gGameUI:createView("city.pvp.cross_craft.battle_messages", arg_7_0:getResourceNode()):init(...):x(display.uiOrigin.x)
		end,
		mySchedule = function(...)
			return gGameUI:createView("city.pvp.cross_craft.myschedule", arg_7_0:getResourceNode()):init(...):x(display.uiOrigin.x)
		end,
		mainSchedule = function(...)
			return gGameUI:createView("city.pvp.cross_craft.main_schedule_final", arg_7_0:getResourceNode()):init(...):x(display.uiOrigin.x)
		end
	}

	idlereasy.when(arg_7_0.topuiState, function()
		arg_7_0:resetTopuiView()
	end)
	idlereasy.any({
		arg_7_0.round,
		arg_7_0.signupDate,
		arg_7_0.topuiState
	}, function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
		local var_12_0 = var_0_2.isSigned()

		for iter_12_0, iter_12_1 in ipairs(var_7_0) do
			iter_12_1:hide()
		end

		local var_12_1 = false
		local var_12_2

		if arg_12_1 == "closed" then
			local var_12_3 = gGameModel.cross_craft:read("last_top8_plays")

			if itertools.isempty(var_12_3) then
				arg_7_0.firstPanel:show()

				local var_12_4 = true
			else
				arg_7_0.overPanel:show()

				local var_12_5 = var_12_3.final.champion
				local var_12_6 = var_12_3.final.third

				arg_7_0.topData = {
					var_12_5.result == "win" and var_12_5.role1 or var_12_5.role2,
					var_12_5.result == "win" and var_12_5.role2 or var_12_5.role1,
					var_12_6.result == "win" and var_12_6.role1 or var_12_6.role2
				}

				for iter_12_2 = 1, 3 do
					arg_7_0:setTopInfo(iter_12_2)
				end
			end
		elseif arg_12_1 == "signup" then
			local var_12_7 = true

			arg_7_0.signupPanel:show()

			if var_12_0 then
				arg_7_0.signedPanel:show()
				arg_7_0.leftBtn1:show()
				arg_7_0:setCountdown(arg_7_0.signedTime, var_0_2.getNextStateTime("prepare"), 1)
			else
				arg_7_0.signupBtn:show()
				arg_7_0.vipShow:show()
				arg_7_0.vipShow:text(string.format(gLanguageCsv.vipSignupShow, csv.cross.craft.base[1].autoSignVIP))
			end
		else
			local var_12_8 = gGameModel.cross_craft:read("info")
			local var_12_9 = var_12_8 and var_12_8.isout
			local var_12_10 = false

			if var_12_0 then
				arg_7_0.leftBtn2:show()

				var_12_10 = (not var_12_9 or false) and true

				if arg_12_3 == 2 then
					var_12_10 = not var_12_10
				end

				arg_7_0.leftBtn2:get("mySchedule"):visible(not var_12_10)
				arg_7_0.leftBtn2:get("mainSchedule"):visible(var_12_10)
			end

			if not var_12_10 then
				if arg_12_1 == "prepare" then
					arg_7_0:setCountdown(arg_7_0.otherTime, var_0_2.getNextStateTime("prepare"), 2)
					arg_7_0.countdownPanel:show()
				elseif string.find(arg_12_1, "^pre%d") or arg_12_1 == "halftime" or arg_12_1 == "prepare2" then
					var_12_2 = "battleMessages"
				elseif string.find(arg_12_1, "^top") then
					var_12_2 = "mainSchedule"
				elseif string.find(arg_12_1, "^final") then
					var_12_2 = "mainSchedule"
				end
			else
				var_12_2 = "mySchedule"
			end
		end

		arg_7_0:showSubView(var_12_2)
	end)

	local var_7_1 = 0

	arg_7_0:schedule(function()
		if arg_7_0.round:read() == "closed" then
			return
		end

		if var_0_2.getNextStateTime(nil, true) <= 0 and time.getTime() - var_7_1 > 10 then
			var_7_1 = time.getTime()

			gGameApp:requestServer("/game/cross/craft/battle/main")
		end
	end, 1, 0)
end

function var_0_2.initModel(arg_14_0)
	arg_14_0.round = gGameModel.cross_craft:getIdler("round")
	arg_14_0.signupDate = gGameModel.role:getIdler("cross_craft_sign_up_date")
	arg_14_0.cards = gGameModel.cross_craft:getIdler("cards")
	arg_14_0.servers = getMergeServers(gGameModel.cross_craft:read("servers"))
	arg_14_0.lastTop8 = gGameModel.cross_craft:getIdler("last_top8_plays")
end

function var_0_2.showSubView(arg_15_0, arg_15_1, ...)
	if arg_15_0.subView.name ~= arg_15_1 then
		if arg_15_0.subView.view then
			arg_15_0.subView.view:onClose()
		end

		if arg_15_1 == nil then
			arg_15_0.subView = {}
		else
			arg_15_0.subView = {
				name = arg_15_1,
				view = arg_15_0.subViewFunc[arg_15_1](...)
			}
		end
	end
end

function var_0_2.onSignupClick(arg_16_0)
	local var_16_0 = false

	for iter_16_0, iter_16_1 in pairs(arg_16_0.cards:read()) do
		if not gGameModel.cards:find(iter_16_1) then
			var_16_0 = true

			break
		end
	end

	if var_16_0 or itertools.size(arg_16_0.cards:read()) < var_0_0 then
		local var_16_1 = false
		local var_16_2 = gGameModel.role:read("cards")
		local var_16_3 = {}

		if itertools.size(var_16_2) >= var_0_0 then
			local var_16_4 = {}

			for iter_16_2, iter_16_3 in ipairs(var_16_2) do
				local var_16_5 = gGameModel.cards:find(iter_16_3):read("card_id", "fighting_point")
				local var_16_6 = csv.cards[var_16_5.card_id]
				local var_16_7 = csv.unit[var_16_6.unitID]

				table.insert(var_16_4, {
					id = iter_16_3,
					fighting_point = var_16_5.fighting_point,
					rarity = var_16_7.rarity
				})
			end

			table.sort(var_16_4, function(arg_17_0, arg_17_1)
				if arg_17_0.fighting_point ~= arg_17_1.fighting_point then
					return arg_17_0.fighting_point > arg_17_1.fighting_point
				end

				return arg_17_0.rarity > arg_17_1.rarity
			end)

			local var_16_8 = dataEasy.getInMeteorCardsHash()
			local var_16_9 = {}
			local var_16_10 = 0

			for iter_16_4, iter_16_5 in ipairs(var_16_4) do
				local var_16_11 = iter_16_5.id
				local var_16_12 = gGameModel.cards:find(var_16_11):read("card_id")
				local var_16_13 = csv.cards[var_16_12].cardMarkID

				if not var_16_9[var_16_13] and not var_16_8[var_16_11] then
					var_16_9[var_16_13] = true

					table.insert(var_16_3, var_16_11)

					var_16_10 = var_16_10 + 1
				end

				if var_16_10 >= var_0_0 then
					var_16_1 = true

					break
				end
			end
		end

		if not var_16_1 then
			gGameUI:showTip(gLanguageCsv.crossCraftNotSignup)

			return
		end

		local var_16_14 = "/game/cross/craft/battle/deploy"
		local var_16_15 = gLanguageCsv.battleResetSuccess

		if not var_0_2.isSigned() then
			var_16_14 = "/game/cross/craft/signup"
			var_16_15 = gLanguageCsv.signUpSuccess
		end

		gGameApp:requestServer(var_16_14, function(arg_18_0)
			gGameUI:stackUI("city.pvp.cross_craft.embattle", nil, {
				full = true
			})
			gGameUI:showTip(var_16_15)
		end, var_16_3)

		return
	end

	if not var_0_2.isSigned() then
		gGameApp:requestServer("/game/cross/craft/signup", function()
			gGameUI:stackUI("city.pvp.cross_craft.embattle", nil, {
				full = true
			})
			gGameUI:showTip(gLanguageCsv.signUpSuccess)
		end, arg_16_0.cards)

		return
	end

	gGameUI:stackUI("city.pvp.cross_craft.embattle", nil, {
		full = true
	})
end

function var_0_2.onMyTeamClick(arg_20_0)
	local var_20_0 = gGameModel.cross_craft:read("info")

	if var_20_0 and var_20_0.isout then
		gGameUI:showTip(gLanguageCsv.isOutCantEnterEmbattle)
	else
		gGameUI:stackUI("city.pvp.cross_craft.embattle", nil, {
			full = true
		})
	end
end

function var_0_2.onMyScheduleClick(arg_21_0)
	arg_21_0.topuiState:modify(function(arg_22_0)
		return true, 3 - arg_22_0
	end)
end

function var_0_2.onMainScheduleClick(arg_23_0)
	arg_23_0.topuiState:modify(function(arg_24_0)
		return true, 3 - arg_24_0
	end)
end

function var_0_2.onRuleClick(arg_25_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_25_0:createHandler("getRuleContext"), {
		width = 1500
	})
end

function var_0_2.getRuleContext(arg_26_0, arg_26_1)
	local var_26_0 = adaptContext

	return {
		var_26_0.clone(arg_26_1.title, function(arg_27_0)
			arg_27_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_26_0.noteText(124),
		var_26_0.noteText(74001, 74100),
		var_26_0.noteText(125),
		var_26_0.noteText(75001, 75100),
		var_26_0.noteText(126),
		var_26_0.noteText(76001, 76100),
		var_26_0.noteText(127),
		var_26_0.noteText(77001, 77100),
		var_26_0.noteText(136),
		var_26_0.noteText(78001, 78100),
		var_26_0.noteText(137),
		var_26_0.noteText(79001, 79100)
	}
end

function var_0_2.onRankRewardClick(arg_28_0)
	gGameApp:requestServer("/game/cross/craft/rank", function(arg_29_0)
		gGameUI:stackUI("city.pvp.cross_craft.rank", nil, nil, arg_29_0.view)
	end)
end

function var_0_2.onRecordClick(arg_30_0)
	if arg_30_0.round:read() ~= "over" and arg_30_0.round:read() ~= "closed" and arg_30_0.round:read() ~= "signup" then
		gGameUI:showTip(gLanguageCsv.craftRankGaming)

		return
	end

	if itertools.isempty(arg_30_0.lastTop8:read()) then
		gGameUI:showTip(gLanguageCsv.crossCraftFirstPrepare)

		return
	end

	gGameUI:stackUI("city.pvp.cross_craft.main_schedule_final", nil, {
		full = true
	}, true)
end

function var_0_2.onBetClick(arg_31_0)
	if arg_31_0.round:read() == "closed" and itertools.isempty(arg_31_0.lastTop8:read()) then
		gGameUI:showTip(gLanguageCsv.crossCraftFirstPrepare)

		return
	end

	local function var_31_0()
		local var_32_0 = arg_31_0.round:read()

		if var_32_0 == "closed" then
			return true
		end

		local var_32_1 = 0
		local var_32_2 = 0

		for iter_32_0, iter_32_1 in ipairs(game.CROSS_CRAFT_ROUNDS) do
			if iter_32_1 == var_32_0 then
				var_32_1 = iter_32_0
			elseif iter_32_1 == "top64" then
				var_32_2 = iter_32_0
			end
		end

		return var_32_2 <= var_32_1
	end

	gGameApp:requestServer("/game/cross/craft/bet/info", function(arg_33_0)
		if var_31_0() == false then
			gGameApp:requestServer("/game/rank", function(arg_34_0)
				gGameUI:stackUI("city.pvp.cross_craft.bet", nil, {
					full = true
				}, {
					arg_33_0.view,
					arg_34_0.view
				})
			end, "fight", 0, 50)
		else
			gGameApp:requestServer("/game/cross/craft/pre/point/rank", function(arg_35_0)
				if #arg_35_0.view.rank > 0 then
					local var_35_0 = {
						rank = {}
					}

					for iter_35_0, iter_35_1 in ipairs(arg_35_0.view.rank) do
						var_35_0.rank[iter_35_0] = {
							role = clone(iter_35_1)
						}
					end

					gGameUI:stackUI("city.pvp.cross_craft.bet", nil, {
						full = true
					}, {
						arg_33_0.view,
						var_35_0
					})
				else
					gGameApp:requestServer("/game/rank", function(arg_36_0)
						gGameUI:stackUI("city.pvp.cross_craft.bet", nil, {
							full = true
						}, {
							arg_33_0.view,
							arg_36_0.view
						})
					end, "fight", 0, 50)
				end
			end, 0, 50)
		end
	end)
end

function var_0_2.onShopClick(arg_37_0)
	if not gGameUI:goBackInStackUI("city.shop") then
		gGameApp:requestServer("/game/fixshop/get", function(arg_38_0)
			gGameUI:stackUI("city.shop", nil, {
				full = true
			}, game.SHOP_INIT.CROSS_CRAFT_SHOP)
		end)
	end
end

function var_0_2.onShowInfo(arg_39_0, arg_39_1)
	if not arg_39_0.topData or not arg_39_0.topData[arg_39_1] then
		return
	end

	gGameApp:requestServer("/game/cross/craft/battle/enemy/get", function(arg_40_0)
		gGameUI:stackUI("city.pvp.cross_craft.array_info", nil, nil, arg_40_0.view)
	end, arg_39_0.topData[arg_39_1].game_key, arg_39_0.topData[arg_39_1].role_db_id, arg_39_0.topData[arg_39_1].record_db_id)
end

function var_0_2.setTopInfo(arg_41_0, arg_41_1)
	local var_41_0 = arg_41_0.topData[arg_41_1]
	local var_41_1 = arg_41_0.overPanel:get("top" .. arg_41_1)
	local var_41_2 = var_41_1:get("down"):multiget("name", "level", "server", "fightPointText", "fightPoint", "vip")

	var_41_2.name:text(var_41_0.name)

	if var_41_0.vip > 0 then
		var_41_2.vip:texture(ui.VIP_ICON[var_41_0.vip]):show()
	else
		var_41_2.vip:hide()
	end

	var_41_2.level:text("Lv" .. var_41_0.level)
	var_41_2.server:text(string.format(gLanguageCsv.brackets, getServerArea(var_41_0.game_key, true)))
	var_41_2.fightPoint:text(var_41_0.display.fighting_point)
	text.addEffect(var_41_2.level, {
		color = color1,
		outline = {
			size = 3,
			color = ui.NEWCOLORS.OUTLINE.WHITE2
		}
	})
	text.addEffect(var_41_2.server, {
		color = color1,
		outline = {
			size = 3,
			color = ui.NEWCOLORS.OUTLINE.WHITE2
		}
	})
	text.addEffect(var_41_2.fightPoint, {
		color = color1,
		outline = {
			size = 3,
			color = ui.NEWCOLORS.OUTLINE.WHITE2
		}
	})
	text.addEffect(var_41_2.fightPointText, {
		color = color1,
		outline = {
			size = 3,
			color = ui.NEWCOLORS.OUTLINE.WHITE2
		}
	})
	text.addEffect(var_41_2.name, {
		color = color1,
		outline = {
			size = 3,
			color = ui.NEWCOLORS.OUTLINE.WHITE2
		}
	})
	adapt.oneLinePos(var_41_2.name, var_41_2.vip, cc.p(15, 0))
	adapt.oneLinePos(var_41_2.level, var_41_2.server, cc.p(15, 0))
	adapt.oneLinePos(var_41_2.fightPointText, var_41_2.fightPoint, cc.p(10, 0))
	var_41_1:get("role"):removeChildByName("card")
	var_41_1:get("role"):removeChildByName("figure")

	local var_41_3 = dataEasy.getUnitCsv(var_41_0.display.top_card, var_41_0.display.skin_id)
	local var_41_4 = gRoleFigureCsv[var_41_0.figure]
	local var_41_5 = var_41_1:size()

	if var_41_4.resSpine ~= "" then
		widget.addAnimationByKey(var_41_1:get("role"), var_41_4.resSpine, "figure", "standby_loop", 4):xy(var_41_5.width / 2 + 200, var_41_5.height / 4 + 60):scale(1)
	end

	if var_41_0.title > 0 then
		bind.extend(arg_41_0, var_41_1, {
			event = "extend",
			class = "role_title",
			props = {
				data = var_41_0.title,
				onNode = function(arg_42_0)
					arg_42_0:xy(var_41_5.width / 2 + 50, var_41_5.height + 50):scale(2):z(5)
				end
			}
		})
	end
end

function var_0_2.setCountdown(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	arg_43_0:unSchedule(arg_43_3)
	arg_43_1:text(time.getCutDown(arg_43_2).str)
	arg_43_0:schedule(function()
		arg_43_2 = arg_43_2 - 1

		if arg_43_2 < 0 then
			return false
		end

		arg_43_1:text(time.getCutDown(arg_43_2).str)
	end, 1, 1, arg_43_3)
end

function var_0_2.resetTopuiView(arg_45_0)
	local var_45_0 = arg_45_0.topuiState:read()

	if arg_45_0.topuiView then
		gGameUI.topuiManager:removeView(arg_45_0.topuiView)
	end

	if var_45_0 == 1 then
		arg_45_0.topuiView = gGameUI.topuiManager:createView("default", arg_45_0, {
			onClose = arg_45_0:createHandler("onClose")
		}):init({
			subTitle = "",
			title = "common/txt/txt_bt_kuafurenzhedasai.png"
		})
	else
		arg_45_0.topuiView = gGameUI.topuiManager:createView("default", arg_45_0, {
			onClose = arg_45_0:createHandler("onCloseSubView")
		}):init({
			subTitle = "",
			title = "common/txt/txt_bt_kuafurenzhedasai.png"
		})
	end
end

function var_0_2.onCloseSubView(arg_46_0)
	arg_46_0.topuiState:set(1)
end

function var_0_2.isSigned()
	local var_47_0 = gGameModel.cross_craft:read("date")

	if var_47_0 == 0 then
		return false
	end

	return var_47_0 == gGameModel.role:read("cross_craft_sign_up_date")
end

function var_0_2.getNextStateTime(arg_48_0, arg_48_1)
	local var_48_0 = gGameModel.cross_craft:read("round")
	local var_48_1 = game.CROSS_CRAFT_ROUND_STATE[var_48_0]

	if var_48_1 and var_48_1.time then
		local var_48_2 = gGameModel.cross_craft:read("time") - time.getTime() + 1
		local var_48_3, var_48_4 = dataEasy.getTimeStrByKey("crossCraft", "signUpEnd", true)

		if var_48_0 == "signup" then
			local var_48_5 = gGameModel.cross_craft:read("date")

			if var_48_5 ~= 0 then
				var_48_2 = time.getNumTimestamp(tonumber(var_48_5), var_48_3, var_48_4) - time.getTime()
			end
		elseif var_48_0 == "halftime" then
			local var_48_6 = gGameModel.cross_craft:read("date")

			if var_48_6 ~= 0 then
				var_48_2 = time.getNumTimestamp(tonumber(var_48_6), var_48_3, var_48_4) + 86400 - time.getTime()
			end
		else
			var_48_2 = var_48_2 + var_48_1.time
		end

		if arg_48_0 then
			local var_48_7

			for iter_48_0, iter_48_1 in ipairs(game.CROSS_CRAFT_ROUNDS) do
				var_48_7 = iter_48_1 == var_48_0 and 0 or var_48_7 and var_48_7 + (game.CROSS_CRAFT_ROUND_STATE[iter_48_1].time or 0)

				if var_48_7 and iter_48_1 == arg_48_0 then
					break
				end
			end

			var_48_2 = var_48_2 + var_48_7
		end

		if var_48_2 >= 0 then
			return var_48_2
		end
	end

	return arg_48_1 and 0 or 10
end

function var_0_2.getArrayRoundIdx(arg_49_0)
	if arg_49_0 == "closed" then
		return 5
	end

	if arg_49_0 == "prepare2" then
		return 0
	end

	local var_49_0 = 0
	local var_49_1 = string.find(arg_49_0, "_lock$")

	if var_49_1 then
		arg_49_0 = string.sub(arg_49_0, 1, var_49_1 - 1)
	end

	if arg_49_0 == "top64" then
		var_49_0 = 1
	elseif arg_49_0 == "top32" then
		var_49_0 = 2
	elseif arg_49_0 == "top16" then
		var_49_0 = 3
	elseif string.find(arg_49_0, "%d$") then
		var_49_0 = string.sub(arg_49_0, #arg_49_0, #arg_49_0)
	end

	return (tonumber(var_49_0))
end

function var_0_2.getRoundHistory(arg_50_0, arg_50_1, arg_50_2)
	local function var_50_0(arg_51_0)
		if string.find(arg_50_1, "^pre%d") or arg_50_1 == "signup" or arg_50_1 == "prepare" or arg_50_1 == "halftime" or arg_50_1 == "prepare2" then
			local var_51_0 = string.sub(arg_50_1, 4, 4)

			if arg_50_1 == "signup" or arg_50_1 == "prepare" then
				var_51_0 = 1
			elseif arg_50_1 == "halftime" or arg_50_1 == "prepare2" then
				var_51_0 = 3
			end

			if arg_51_0 == "pre" .. var_51_0 .. arg_50_0 then
				return true
			end
		end

		if (string.find(arg_50_1, "^final") or arg_50_1 == "closed") and arg_51_0 == "final" .. arg_50_0 then
			return true
		end

		if string.find(arg_50_1, "^top") then
			if arg_51_0 == "top64" and arg_50_0 == 1 then
				return true
			end

			if arg_51_0 == "top32" and arg_50_0 == 2 then
				return true
			end

			if arg_51_0 == "top16" and arg_50_0 == 3 then
				return true
			end
		end
	end

	for iter_50_0, iter_50_1 in ipairs(arg_50_2) do
		if var_50_0(iter_50_1.round) then
			return iter_50_1
		end
	end
end

function var_0_2.getArrayRoundResult(arg_52_0, arg_52_1, arg_52_2)
	local var_52_0 = var_0_2.getArrayRoundIdx(arg_52_1)

	if var_52_0 < arg_52_0 then
		return
	end

	if var_52_0 == arg_52_0 then
		if string.find(arg_52_1, "_lock$") then
			return "inBattle"
		end

		return "inPrepare"
	end

	local var_52_1 = var_0_2.getRoundHistory(arg_52_0, arg_52_1, arg_52_2)

	if not var_52_1 then
		return "isOut"
	end

	return var_52_1.result
end

function var_0_2.getArrayRoundRes(arg_53_0, arg_53_1, arg_53_2)
	local var_53_0 = "txt_d" .. arg_53_0 .. "c"

	if string.find(arg_53_1, "^top") then
		if arg_53_0 == 1 then
			var_53_0 = "txt_32qs"
		elseif arg_53_0 == 2 then
			var_53_0 = "txt_16qs"
		elseif arg_53_0 == 3 then
			var_53_0 = "txt_8qs"
		else
			var_53_0 = nil
		end
	elseif string.find(arg_53_1, "^final") or arg_53_1 == "closed" then
		if arg_53_0 == 1 then
			var_53_0 = "txt_4qs"
		elseif arg_53_0 == 2 then
			var_53_0 = "txt_bjs"
		elseif arg_53_0 == 3 then
			var_53_0 = "txt_gjs"

			for iter_53_0, iter_53_1 in ipairs(arg_53_2) do
				if iter_53_1.round == "final2" and iter_53_1.result == "fail" then
					var_53_0 = "txt_jjs0"

					break
				end
			end
		else
			var_53_0 = nil
		end
	end

	if var_53_0 then
		return "city/pvp/cross_craft/txt/" .. var_53_0 .. ".png"
	end
end

return var_0_2
