local var_0_0 = {
	scale = {
		[0] = 1,
		1,
		0.9,
		0.85,
		0.85
	},
	opacity = {
		[0] = 0,
		255,
		178.5,
		102,
		0
	},
	y = {
		[0] = -570,
		-12,
		142,
		250,
		200
	},
	z = {
		[0] = 6,
		5,
		4,
		3,
		2
	}
}
local var_0_1 = {
	event = 4,
	box = 3,
	monster = 1,
	buff = 2
}
local var_0_2 = {
	cc.c4b(94, 235, 169, 255),
	cc.c4b(86, 229, 255, 255),
	cc.c4b(254, 159, 255, 255),
	(cc.c4b(253, 189, 89, 255))
}

local function var_0_3(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = csv.random_tower.board[arg_1_1]
	local var_1_1 = arg_1_0:multiget("item", "icon", "iconBg", "name", "desc", "pos")

	var_1_1.name:text(var_1_0.name)

	local var_1_2 = var_1_0.desc
	local var_1_3 = var_1_0.icon

	var_1_1.iconBg:hide()

	if var_1_0.type == var_0_1.monster then
		local var_1_4 = csv.random_tower.monsters[var_1_0.monster]

		text.addEffect(var_1_1.name, {
			color = var_0_2[var_1_0.monsterType]
		})

		if var_1_4 and var_1_3 == "" then
			var_1_3 = var_1_4.res
		end

		var_1_1.icon:y(var_1_1.iconBg:y() - 34)
	elseif var_1_0.type == var_0_1.buff and arg_1_2.buff then
		local var_1_5 = csv.random_tower.buffs[arg_1_2.buff[arg_1_1]]

		if var_1_5 then
			var_1_2 = var_1_5.desc
			var_1_3 = var_1_5.icon

			var_1_1.iconBg:show():texture(var_1_5.iconBg)
		end

		var_1_1.icon:y(var_1_1.iconBg:y())
	elseif var_1_0.type == var_0_1.box then
		var_1_1.icon:scale(1)
		var_1_1.icon:y(var_1_1.iconBg:y())
	end

	var_1_1.icon:texture(var_1_3)
	beauty.textScroll({
		align = "center",
		effect = {
			color = ui.NEWCOLORS.BLACK,
			outline = {
				color = ui.NEWCOLORS.OUTLINE.YELLOW1
			}
		},
		list = var_1_1.desc,
		strs = var_1_2,
		fontSize = matchLanguage({
			"kr"
		}) and 36 or ui.FONT_SIZE
	})
	var_1_1.desc:setItemAlignCenter()
end

local var_0_4 = require("app.views.city.adventure.random_tower.tools")

local function var_0_5()
	if not dataEasy.isUnlock(gUnlockCsv.randomTowerJump) then
		local var_2_0 = var_0_4.getCanPassMaxRoom()

		if var_2_0 <= 1 then
			return ""
		end

		local var_2_1 = csv.random_tower.tower[var_2_0]

		return string.format(gLanguageCsv.randomTowerCanPassTip, var_2_1.floor, var_2_1.roomIdx)
	else
		local var_2_2 = var_0_4.getCanJumpMaxRoom()
		local var_2_3 = var_0_4.getCanPassMaxRoom()

		if var_2_2 <= 1 and var_2_3 <= 1 then
			return ""
		end

		if var_2_3 > 1 and var_2_2 <= 1 then
			local var_2_4 = csv.random_tower.tower[var_2_3]

			return string.format(gLanguageCsv.randomTowerCanPassTip2, var_2_4.floor, var_2_4.roomIdx)
		elseif var_2_3 <= 1 and var_2_2 > 1 then
			local var_2_5 = csv.random_tower.tower[var_2_2]

			return string.format(gLanguageCsv.randomTowerCanJumpTips3, var_2_5.floor, var_2_5.roomIdx)
		elseif var_2_3 > 1 and var_2_2 > 1 then
			local var_2_6 = csv.random_tower.tower[var_2_3]
			local var_2_7 = csv.random_tower.tower[var_2_2]

			return string.format(gLanguageCsv.randomTowerCanJumpTips1, var_2_6.floor, var_2_6.roomIdx, var_2_7.floor, var_2_7.roomIdx)
		end
	end
end

local var_0_6 = cc.load("mvc").ViewBase
local var_0_7 = class("RandomTowerView", var_0_6)

var_0_7.RESOURCE_FILENAME = "random_tower.json"
var_0_7.RESOURCE_BINDING = {
	panel = "panel",
	ruleRankItem = "ruleRankItem",
	startPanel = "startPanel",
	item = "item",
	endPanel = "endPanel",
	["startPanel.jump.name"] = {
		varname = "jumpName",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.RED1
				}
			}
		}
	},
	["startPanel.item.name"] = {
		varname = "startName",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.RED1
				}
			}
		}
	},
	["startPanel.item"] = {
		binds = {
			event = "click",
			method = bindHelper.self("onStartClick")
		}
	},
	["startPanel.jump"] = {
		binds = {
			event = "click",
			method = bindHelper.self("onJumpClick")
		}
	},
	["leftBottomPanel.floorTitle"] = {
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
	["leftBottomPanel.floor"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 1,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			},
			{
				event = "text",
				idler = bindHelper.self("room"),
				method = function(arg_3_0)
					local var_3_0 = csv.random_tower.tower[arg_3_0].roomIdx

					if arg_3_0 == 1 then
						return ""
					end

					return string.format(gLanguageCsv.randomTowerSomeFloor, csv.random_tower.tower[arg_3_0].floor)
				end
			}
		}
	},
	["leftBottomPanel.roomTitle"] = {
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
	["leftBottomPanel.room"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 1,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			},
			{
				event = "text",
				idler = bindHelper.self("room"),
				method = function(arg_4_0)
					local var_4_0 = csv.random_tower.tower[arg_4_0].floor
					local var_4_1 = csv.random_tower.tower[arg_4_0].roomIdx

					if var_4_1 == 0 then
						return ""
					end

					return var_4_1 .. "/" .. gRandomTowerFloorMax[var_4_0]
				end
			}
		}
	},
	["leftBottomPanel.pointPanel.point"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("dayPoint")
		}
	},
	["leftBottomPanel.tip"] = {
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
	["rightBottomPanel.enbattleBtn"] = {
		varname = "enbattleBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onEnbattle")
			}
		}
	},
	["rightBottomPanel.enbattleBtn.name"] = {
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
	["rightBottomPanel.buffBtn"] = {
		varname = "buffBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBuff")
			}
		}
	},
	["rightBottomPanel.buffBtn.name"] = {
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
	["rightBottomPanel.shopBtn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShop")
			}
		}
	},
	["rightBottomPanel.shopBtn.name"] = {
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
	["rightBottomPanel.rankBtn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRank")
			}
		}
	},
	["rightBottomPanel.rankBtn.name"] = {
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
	["rightBottomPanel.pointBtn"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onPoint")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "randomTowerPoint"
				}
			}
		}
	},
	["rightBottomPanel.pointBtn.name"] = {
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
	["rightBottomPanel.ruleBtn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRule")
			}
		}
	},
	["rightBottomPanel.ruleBtn.name"] = {
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
	bg = {
		binds = {
			event = "click",
			method = bindHelper.self("onBgClick")
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

function var_0_7.onCreate(arg_5_0)
	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_5_0.panel,
			"width"
		}
	})
	gGameModel.currday_dispatch:getIdlerOrigin("randomTower"):set(true)
	gGameUI.topuiManager:createView("random_tower", arg_5_0, {
		onClose = arg_5_0:createHandler("onClose")
	}):init({
		subTitle = "AETHER PARADISE",
		title = "common/txt/txt_bt_anbutexun.png"
	})
	arg_5_0:initModel()
	adapt.setTextScaleWithWidth(arg_5_0.startName, nil, 400)
	adapt.setTextScaleWithWidth(arg_5_0.jumpName, nil, 400)

	arg_5_0.data = {}
	arg_5_0.state = idler.new(arg_5_0:getState())
	arg_5_0.itemX = arg_5_0.startPanel:get("item"):x()

	idlereasy.when(arg_5_0.state, function(arg_6_0, arg_6_1)
		local var_6_0 = arg_5_0.room:read()
		local var_6_1 = csv.random_tower.tower[var_6_0].floor

		arg_5_0.endPanel:visible(arg_6_1 == "end")

		if arg_6_1 == "start" then
			arg_5_0.startPanel:show()

			arg_5_0.canStart = true

			local var_6_2 = var_0_5()

			if var_6_2 ~= "" and var_6_1 <= 1 then
				gGameUI:showDialog({
					btnType = 1,
					title = "",
					isRich = true,
					content = var_6_2
				})
			end

			local var_6_3 = arg_5_0.startPanel:get("item"):show()
			local var_6_4 = arg_5_0.startPanel:get("jump"):show()

			arg_5_0.startPanel:removeChildByName("effect")

			if dataEasy.isUnlock(gUnlockCsv.randomTowerJump) and var_6_1 <= 1 then
				var_6_3:x(arg_5_0.itemX)
				var_0_4.setEffect(var_6_3, "effect_loop", "random_tower/kaishishilian.skel", 100)
				var_0_4.setEffect(var_6_4, "effect_loop", "random_tower/kaishishilian.skel", 100)
			else
				var_0_4.setEffect(var_6_3, "effect_loop", "random_tower/kaishishilian.skel", 100)
				var_6_3:x(arg_5_0.startPanel:width() / 2)

				local var_6_5 = gLanguageCsv.randomTowerStart

				if var_6_1 > 1 then
					var_6_5 = gLanguageCsv.randomTowerEnterNext
				end

				var_6_3:get("name"):text(var_6_5):show()
				var_6_4:hide()
			end

			arg_5_0:clearPanel()
		elseif arg_6_1 == "end" then
			arg_5_0.startPanel:hide()

			local var_6_6 = arg_5_0.boards:read()

			arg_5_0:initPanel(1, var_6_6[var_6_0])
			arg_5_0:refreshPanel()
		elseif arg_6_1 == "jump" then
			arg_5_0.startPanel:hide()

			if arg_5_0.clickToJump ~= true then
				if arg_5_0.jumpStep:read() == game.RANDOM_TOWER_JUMP_STATE.POINT then
					gGameApp:requestServer("/game/random_tower/jump/next", function(arg_7_0)
						gGameUI:stackUI("city.adventure.random_tower.jump", nil, nil, nil, arg_5_0:createHandler("jumpOver"))
					end)
				else
					gGameUI:stackUI("city.adventure.random_tower.jump", nil, nil, nil, arg_5_0:createHandler("jumpOver"))
				end
			end
		else
			arg_5_0.startPanel:hide()

			local var_6_7 = arg_5_0.boards:read()

			for iter_6_0 = 1, 3 do
				local var_6_8 = var_6_0 + iter_6_0 - 1
				local var_6_9 = csv.random_tower.tower[var_6_8]

				if var_6_9 and var_6_9.floor ~= var_6_1 then
					break
				end

				arg_5_0:initPanel(iter_6_0, var_6_7[var_6_8])
			end

			arg_5_0:refreshPanel(true)
		end
	end)

	local var_5_0 = time.getNumTimestamp(tonumber(time.getTodayStrInClock()), 5) + 86400 - time.getTime() + 1

	performWithDelay(arg_5_0, function()
		local var_8_0 = {
			false
		}

		gGameApp:requestServerCustom("/game/random_tower/prepare"):params({}):onResponse(function(arg_9_0)
			var_8_0[1] = true
		end):wait(var_8_0):doit(function(arg_10_0)
			gGameUI:showTip(gLanguageCsv.randomTowerNextDay)
			arg_5_0.state:set("start", true)
		end)
	end, var_5_0)
end

function var_0_7.initModel(arg_11_0)
	arg_11_0.historyRoom = gGameModel.random_tower:getIdler("history_room")
	arg_11_0.lastRoom = gGameModel.random_tower:getIdler("lastRoom")
	arg_11_0.room = gGameModel.random_tower:getIdler("room")
	arg_11_0.boards = gGameModel.random_tower:getIdler("boards")
	arg_11_0.roomInfo = gGameModel.random_tower:getIdler("room_info")
	arg_11_0.dayPoint = gGameModel.random_tower:getIdler("day_point")
	arg_11_0.dayRank = gGameModel.random_tower:getIdler("day_rank")
	arg_11_0.jumpStep = gGameModel.random_tower:getIdler("jump_step")
	arg_11_0.cardStates = gGameModel.random_tower:getIdler("card_states")
	arg_11_0.cards = gGameModel.role:getIdler("cards")
end

function var_0_7.initPanel(arg_12_0, arg_12_1, arg_12_2)
	arg_12_2 = table.deepcopy(arg_12_2 or {}, true)

	local var_12_0 = arg_12_0.panel:clone()

	arg_12_0.data[arg_12_1] = {
		panel = var_12_0,
		board = arg_12_2
	}

	for iter_12_0, iter_12_1 in ipairs(arg_12_2) do
		local var_12_1 = arg_12_0.item:clone()
		local var_12_2, var_12_3 = arg_12_0:getItemPos(arg_12_1, iter_12_0)

		var_12_1:xy(var_12_2, var_12_3):setCascadeOpacityEnabled(true):setCascadeColorEnabled(true):opacity(var_0_0.opacity[arg_12_1]):scale(var_0_0.scale[arg_12_1]):show():addTo(var_12_0, 1, iter_12_0)
		var_0_3(var_12_1, iter_12_1, arg_12_0.roomInfo:read())
	end

	local var_12_4, var_12_5 = arg_12_0.panel:xy()

	var_12_0:z(var_0_0.z[arg_12_1]):xy(var_12_4, var_12_5 + var_0_0.y[arg_12_1]):show():addTo(arg_12_0:getResourceNode())
	var_12_0:setEnabled(false)

	return var_12_0
end

function var_0_7.refreshPanel(arg_13_0, arg_13_1)
	if arg_13_0.data[1] == nil then
		return
	end

	local var_13_0 = arg_13_0.data[1].panel
	local var_13_1 = arg_13_0.roomInfo:read()

	for iter_13_0, iter_13_1 in pairs(var_13_0:getChildren()) do
		local var_13_2 = true
		local var_13_3 = iter_13_1:getTag()

		var_0_3(iter_13_1, arg_13_0.data[1].board[var_13_3], var_13_1)

		if var_13_1.board_id then
			var_13_2 = arg_13_0.data[1].board[var_13_3] == var_13_1.board_id
		elseif var_13_3 < var_13_1.next_room_scope[1] or var_13_3 > var_13_1.next_room_scope[2] then
			var_13_2 = false
		end

		iter_13_1:setTouchEnabled(var_13_2 == true)

		if var_13_2 then
			bind.touch(arg_13_0, iter_13_1, {
				scaletype = 0,
				longtouch = 0.2,
				method = function(arg_14_0, arg_14_1, arg_14_2)
					arg_13_0:onItemClick(arg_14_2, var_13_3)
				end
			})
		else
			cache.setShader(iter_13_1:get("bg"), false, "hsl_gray_white")
			text.addEffect(iter_13_1:get("name"), {
				color = ui.COLORS.NORMAL.WHITE
			})
			cache.setShader(iter_13_1:get("name"), false, "hsl_gray_white")
			cache.setShader(iter_13_1:get("icon"), false, "hsl_gray_white")
			cache.setShader(iter_13_1:get("iconBg"), false, "hsl_gray_white")
		end
	end

	if arg_13_1 then
		var_13_0:setEnabled(arg_13_1)
	end
end

function var_0_7.clearPanel(arg_15_0, arg_15_1)
	if arg_15_1 then
		arg_15_0.data[arg_15_1].panel:removeSelf()

		arg_15_0.data[arg_15_1] = nil
	else
		for iter_15_0, iter_15_1 in pairs(arg_15_0.data) do
			iter_15_1.panel:removeSelf()
		end

		arg_15_0.data = {}
	end
end

function var_0_7.getState(arg_16_0)
	local var_16_0 = arg_16_0.room:read()
	local var_16_1 = arg_16_0.roomInfo:read()
	local var_16_2 = csv.random_tower.tower[var_16_0].roomIdx
	local var_16_3 = arg_16_0.jumpStep:read()

	if var_16_1.pass then
		return "end"
	end

	if var_16_2 == 0 then
		if var_16_3 > game.RANDOM_TOWER_JUMP_STATE.BEGIN and var_16_3 < game.RANDOM_TOWER_JUMP_STATE.OVER then
			return "jump"
		else
			return "start"
		end
	end

	return "board"
end

function var_0_7.onItemClick(arg_17_0, arg_17_1, arg_17_2)
	if arg_17_0.isPlaying then
		return
	end

	if arg_17_1.name == "click" then
		if not arg_17_0.selectId or arg_17_0.selectId ~= arg_17_2 then
			if arg_17_0.selectId then
				arg_17_0:onPlayLongTouch(arg_17_0.selectId, false)
			end

			arg_17_0.selectId = arg_17_2

			arg_17_0:onPlayLongTouch(arg_17_2, true)

			return
		end

		local var_17_0 = arg_17_0.data[1].board[arg_17_2]
		local var_17_1 = csv.random_tower.board[var_17_0]

		if var_17_1.type == var_0_1.monster then
			gGameUI:stackUI("city.adventure.random_tower.gate_detail", nil, nil, var_17_0, arg_17_0:createHandler("startFighting", arg_17_2), arg_17_0:createHandler("startPassing", arg_17_2))
		elseif var_17_1.type == var_0_1.buff then
			local var_17_2 = arg_17_0.roomInfo:read().buff[var_17_0]
			local var_17_3 = csv.random_tower.buffs[var_17_2]

			if var_17_3.buffType == 2 and not arg_17_0:isNeedSupply(var_17_3.condition, var_17_3.supplyTarget) then
				local var_17_4 = gLanguageCsv.recover

				if var_17_3.supplyType == 3 then
					var_17_4 = gLanguageCsv.revive
				end

				gGameUI:showDialog({
					isRich = true,
					btnType = 2,
					title = "",
					content = string.format(gLanguageCsv.noCardSupply, var_17_4),
					cb = function()
						local var_18_0 = {
							false
						}

						gGameApp:requestServerCustom("/game/random_tower/board"):params(var_17_0):onResponse(function(arg_19_0)
							var_18_0[1] = true
						end):wait(var_18_0):doit(function(arg_20_0)
							var_18_0[1] = false

							gGameApp:requestServerCustom("/game/random_tower/buff/used"):params({}):onResponse(function(arg_21_0)
								var_18_0[1] = true
							end):wait(var_18_0):doit(function(arg_22_0)
								arg_17_0:refreshPanel()
								arg_17_0:onPlayClick(arg_17_2)
							end)
						end)
					end,
					dialogParams = {
						clickClose = false
					}
				})

				return
			end

			local var_17_5 = {
				false
			}

			gGameApp:requestServerCustom("/game/random_tower/board"):params(var_17_0):onResponse(function(arg_23_0)
				var_17_5[1] = true
			end):wait(var_17_5):doit(function(arg_24_0)
				arg_17_0:refreshPanel()

				if var_17_3.buffType == 2 then
					if var_17_3.supplyTarget == 1 then
						gGameUI:stackUI("city.adventure.random_tower.use_buff", nil, nil, var_17_0, arg_17_0:createHandler("onPlayClick", arg_17_2))
					else
						var_17_5[1] = false

						gGameApp:requestServerCustom("/game/random_tower/buff/used"):params({}):onResponse(function(arg_25_0)
							var_17_5[1] = true
						end):wait(var_17_5):doit(function(arg_26_0)
							arg_17_0:onPlayClick(arg_17_2)
							var_0_4.setEffect(arg_17_0.buffBtn:get("icon"), var_17_3.buffColor, "random_tower/jiacheng.skel")
							arg_17_0.buffBtn:get("icon"):get("effect"):setSpriteEventHandler(function(arg_27_0, arg_27_1)
								performWithDelay(arg_17_0.buffBtn:get("icon"), function()
									arg_17_0.buffBtn:get("icon"):get("effect"):removeSelf()
								end, 0)
							end, sp.EventType.ANIMATION_COMPLETE)
						end)
					end
				else
					arg_17_0:onPlayClick(arg_17_2)
					var_0_4.setEffect(arg_17_0.buffBtn:get("icon"), var_17_3.buffColor, "random_tower/jiacheng.skel")
					arg_17_0.buffBtn:get("icon"):get("effect"):setSpriteEventHandler(function(arg_29_0, arg_29_1)
						performWithDelay(arg_17_0.buffBtn:get("icon"), function()
							arg_17_0.buffBtn:get("icon"):get("effect"):removeSelf()
						end, 0)
					end, sp.EventType.ANIMATION_COMPLETE)
				end
			end)
		elseif var_17_1.type == var_0_1.box then
			local var_17_6 = {
				false
			}

			gGameApp:requestServerCustom("/game/random_tower/board"):params(var_17_0):onResponse(function(arg_31_0)
				var_17_6[1] = true
			end):wait(var_17_6):doit(function(arg_32_0)
				arg_17_0:refreshPanel()
				gGameUI:stackUI("city.adventure.random_tower.open_box", nil, {
					clickClose = true
				}, var_17_0, arg_17_0:createHandler("onPlayClick", arg_17_2))
			end)
		elseif var_17_1.type == var_0_1.event then
			local var_17_7 = arg_17_0.roomInfo:read().event[var_17_0]
			local var_17_8 = {
				false
			}

			gGameApp:requestServerCustom("/game/random_tower/board"):params(var_17_0):onResponse(function(arg_33_0)
				var_17_8[1] = true
			end):wait(var_17_8):doit(function(arg_34_0)
				arg_17_0:refreshPanel()

				if csv.random_tower.event[var_17_7].choice1 == "" then
					gGameUI:stackUI("city.adventure.random_tower.event_reward", nil, {
						clickClose = true
					}, {
						boardID = var_17_0,
						eventId = var_17_7,
						tb = arg_34_0,
						cb = arg_17_0:createHandler("onPlayClick", arg_17_2)
					})
				else
					gGameUI:stackUI("city.adventure.random_tower.select_event", nil, {
						clickClose = true
					}, var_17_0, arg_17_0:createHandler("onPlayClick", arg_17_2))
				end
			end)
		end
	end
end

function var_0_7.isNeedSupply(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = var_0_4.getCards(arg_35_2)

	for iter_35_0, iter_35_1 in pairs(var_35_0) do
		local var_35_1 = arg_35_0.cardStates:read()[iter_35_1]

		if var_0_4.reachCondition(arg_35_1, var_35_1, iter_35_1) then
			return true
		end
	end

	return false
end

function var_0_7.getItemPos(arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = arg_36_0.data[arg_36_1].panel
	local var_36_1 = #arg_36_0.data[arg_36_1].board
	local var_36_2 = var_0_0.scale[arg_36_1]
	local var_36_3 = (arg_36_0.item:width() * var_36_2 + 20 * (1 - var_36_2)) * (display.sizeInViewRect.width / display.width)
	local var_36_4 = var_36_0:width() / 2 - (var_36_1 - 1) / 2 * var_36_3 + (arg_36_2 - 1) * var_36_3
	local var_36_5 = var_36_0:height() / 2

	return var_36_4, var_36_5
end

function var_0_7.onItemAnimation(arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = arg_37_0.data[arg_37_1].panel
	local var_37_1 = arg_37_2.t
	local var_37_2 = var_0_0.scale[arg_37_1]
	local var_37_3 = var_0_0.opacity[arg_37_1]

	for iter_37_0, iter_37_1 in pairs(var_37_0:getChildren()) do
		if iter_37_1:getTag() == arg_37_2.choose then
			transition.executeSpawn(iter_37_1, true):fadeTo(1, var_37_3):done()
			widget.addAnimation(iter_37_1, "random_tower/shilianta_dianji.skel", "effect", 99):xy(iter_37_1:width() / 2, iter_37_1:height() / 2):scale(2):play("effect")
		else
			local var_37_4, var_37_5 = arg_37_0:getItemPos(arg_37_1, iter_37_1:getTag())

			transition.executeSpawn(iter_37_1, true):scaleTo(var_37_1, var_37_2):moveTo(var_37_1, var_37_4, var_37_5 + (arg_37_2.dx or 0)):fadeTo(var_37_1, var_37_3):done()
		end
	end
end

function var_0_7.onBgClick(arg_38_0)
	if arg_38_0.selectId then
		arg_38_0:onPlayLongTouch(arg_38_0.selectId, false)

		arg_38_0.selectId = nil
	end
end

function var_0_7.onPlayClick(arg_39_0, arg_39_1)
	arg_39_0:onBgClick()

	arg_39_0.isPlaying = true

	if arg_39_0.data[1] then
		arg_39_0.data[1].panel:setEnabled(false)
	end

	local var_39_0 = arg_39_0.room:read()
	local var_39_1 = csv.random_tower.tower[math.max(var_39_0 - 1, 1)].floor
	local var_39_2 = csv.random_tower.tower[var_39_0 + 2]

	if var_39_2 and var_39_2.floor == var_39_1 then
		local var_39_3 = arg_39_0.boards:read()

		arg_39_0:initPanel(4, var_39_3[var_39_0 + 2])
	end

	local var_39_4 = table.maxn(arg_39_0.data) - 1

	if var_39_4 < 1 then
		arg_39_0.isPlaying = false

		arg_39_0.state:set(arg_39_0:getState())

		return
	end

	local var_39_5 = {}
	local var_39_6 = 0

	for iter_39_0 = 0, var_39_4 do
		local var_39_7 = arg_39_0.data[iter_39_0 + 1]

		if var_39_7 then
			var_39_5[var_39_6] = var_39_7

			var_39_7.panel:z(var_0_0.z[iter_39_0])

			var_39_6 = var_39_6 + 1
		end
	end

	arg_39_0.data = var_39_5

	local var_39_8 = var_39_6 - 1

	arg_39_0:refreshPanel()

	local function var_39_9(arg_40_0)
		if var_39_8 == arg_40_0 then
			arg_39_0.isPlaying = false

			if arg_39_0.data[1] then
				arg_39_0.data[1].panel:setEnabled(true)
			end

			arg_39_0:clearPanel(0)
			arg_39_0.state:set(arg_39_0:getState())
		end
	end

	local var_39_10, var_39_11 = arg_39_0.panel:xy()
	local var_39_12 = 1
	local var_39_13 = 0.2

	transition.executeSequence(arg_39_0.data[0].panel, true):func(functools.partial(arg_39_0.onItemAnimation, arg_39_0, 0, {
		t = var_39_12 / 2,
		choose = arg_39_1,
		dx = var_0_0.y[0]
	})):delay(var_39_12):hide():func(functools.partial(var_39_9, 0)):done()

	for iter_39_1 = 1, math.min(var_39_8, 2) do
		transition.executeSequence(arg_39_0.data[iter_39_1].panel, true):delay(var_39_12 + var_39_13 * (iter_39_1 - 1)):easeBegin("OUT"):moveTo(var_39_13, var_39_10, var_39_11 + var_0_0.y[iter_39_1 + 1] + 50):easeEnd():func(functools.partial(arg_39_0.onItemAnimation, arg_39_0, iter_39_1, {
			t = var_39_13 * 2
		})):easeBegin("OUT"):moveTo(var_39_13 * 2, var_39_10, var_39_11 + var_0_0.y[iter_39_1]):easeEnd():func(functools.partial(var_39_9, iter_39_1)):done()
	end

	if var_39_8 >= 3 then
		transition.executeSequence(arg_39_0.data[3].panel, true):delay(var_39_12 + var_39_13 * 3):func(functools.partial(arg_39_0.onItemAnimation, arg_39_0, 3, {
			t = var_39_13 * 2
		})):easeBegin("OUT"):moveTo(var_39_13 * 2, var_39_10, var_39_11 + var_0_0.y[3]):easeEnd():func(functools.partial(var_39_9, 3)):done()
	end
end

function var_0_7.onPlayLongTouch(arg_41_0, arg_41_1, arg_41_2)
	local var_41_0 = 0.4

	if arg_41_0.data[1] then
		local var_41_1 = arg_41_0.data[1].panel
		local var_41_2 = var_0_0.opacity[1]

		for iter_41_0, iter_41_1 in pairs(var_41_1:getChildren()) do
			local var_41_3 = iter_41_1:getTag()
			local var_41_4, var_41_5 = arg_41_0:getItemPos(1, var_41_3)

			if arg_41_2 then
				if var_41_3 == arg_41_1 then
					transition.executeSpawn(iter_41_1, true):easeBegin("EXPONENTIALOUT"):moveTo(var_41_0, var_41_4, var_41_5 + 50):easeEnd():done()
					widget.addAnimationByKey(iter_41_1, "random_tower/slt_xuanzhong.skel", "effect", "effect_loop", 99):xy(iter_41_1:width() / 2, iter_41_1:height() / 2):scale(2):show()
				else
					transition.executeSpawn(iter_41_1, true):easeBegin("BACKOUT"):moveTo(2 * var_41_0, var_41_4, var_41_5):easeEnd():done()

					if iter_41_1:get("effect") then
						iter_41_1:get("effect"):hide()
					end
				end
			else
				transition.executeSpawn(iter_41_1, true):easeBegin("OUT"):moveTo(var_41_0, var_41_4, var_41_5):easeEnd():done()

				if iter_41_1:get("effect") then
					iter_41_1:get("effect"):hide()
				end
			end
		end
	end

	if arg_41_0.data[2] then
		local var_41_6 = arg_41_0.data[2].panel
		local var_41_7 = var_0_0.opacity[2]

		for iter_41_2, iter_41_3 in pairs(var_41_6:getChildren()) do
			local var_41_8 = iter_41_3:getTag()
			local var_41_9, var_41_10 = arg_41_0:getItemPos(2, var_41_8)

			if arg_41_2 then
				if arg_41_0:isLongTouchHighLight(arg_41_1, var_41_8) then
					var_41_10 = var_41_10 + 35

					widget.addAnimationByKey(iter_41_3, "random_tower/slt_xuanzhong.skel", "effect", "effect_loop", 99):xy(iter_41_3:width() / 2, iter_41_3:height() / 2):scale(2):show()
				end

				transition.executeSpawn(iter_41_3, true):easeBegin("OUT"):moveTo(2 * var_41_0, var_41_9, var_41_10):easeEnd():done()
			else
				transition.executeSpawn(iter_41_3, true):easeBegin("OUT"):moveTo(var_41_0, var_41_9, var_41_10):easeEnd():done()

				if arg_41_0:isLongTouchHighLight(arg_41_1, var_41_8) and iter_41_3:get("effect") then
					iter_41_3:get("effect"):hide()
				end
			end
		end
	end
end

function var_0_7.isLongTouchHighLight(arg_42_0, arg_42_1, arg_42_2)
	local var_42_0 = #arg_42_0.data[1].board
	local var_42_1 = #arg_42_0.data[2].board

	if var_42_0 == 1 or var_42_1 == 1 then
		return true
	end

	local var_42_2 = (var_42_1 - var_42_0) / 2

	return arg_42_2 >= var_42_2 + arg_42_1 - 1 and arg_42_2 <= var_42_2 + arg_42_1 + 1
end

function var_0_7.onStartClick(arg_43_0)
	if arg_43_0.canStart == true then
		local var_43_0 = {
			false
		}

		gGameApp:requestServerCustom("/game/random_tower/board"):params({}):onResponse(function(arg_44_0)
			arg_43_0.startPanel:get("jump"):hide()

			local var_44_0 = arg_43_0.startPanel:get("item"):x(arg_43_0.startPanel:width() / 2)

			var_44_0:get("name"):hide()
			var_0_4.setEffect(arg_43_0.startPanel, "bj", "random_tower/kaishishilian.skel")
			var_0_4.setEffect(var_44_0, "effect", "random_tower/kaishishilian.skel")

			arg_43_0.selectId = nil

			performWithDelay(arg_43_0, function()
				arg_43_0.canStart = false
				var_43_0[1] = true
			end, 1)
		end):wait(var_43_0):doit(function(arg_46_0)
			arg_43_0.state:set(arg_43_0:getState(), true)
		end)
	end
end

function var_0_7.onJumpClick(arg_47_0)
	if arg_47_0.canStart == true then
		local var_47_0 = {
			false
		}

		gGameApp:requestServerCustom("/game/random_tower/jump/next"):params({}):onResponse(function(arg_48_0)
			arg_47_0.startPanel:get("item"):hide()

			local var_48_0 = arg_47_0.startPanel:get("jump"):x(arg_47_0.startPanel:width() / 2)

			var_48_0:get("name"):hide()
			var_0_4.setEffect(arg_47_0.startPanel, "bj", "random_tower/kaishishilian.skel")
			var_0_4.setEffect(var_48_0, "effect", "random_tower/kaishishilian.skel")

			arg_47_0.selectId = nil

			performWithDelay(arg_47_0, function()
				arg_47_0.canStart = false
				var_47_0[1] = true
			end, 1)
		end):wait(var_47_0):doit(function(arg_50_0)
			arg_47_0.clickToJump = true

			arg_47_0.state:set(arg_47_0:getState(), true)
			gGameUI:stackUI("city.adventure.random_tower.jump", nil, nil, arg_50_0.view, arg_47_0:createHandler("jumpOver"))
		end)
	end
end

function var_0_7.onEnbattle(arg_51_0)
	gGameUI:stackUI("city.card.embattle.random", nil, {
		full = true
	}, {
		from = "huodong",
		fromId = game.EMBATTLE_HOUDONG_ID.randomTower
	})
end

function var_0_7.onBuff(arg_52_0)
	gGameUI:stackUI("city.adventure.random_tower.look_buff", nil, {
		backGlass = true,
		clickClose = true
	})
end

function var_0_7.onShop(arg_53_0)
	if not gGameUI:goBackInStackUI("city.shop") then
		local var_53_0 = {
			false
		}

		gGameApp:requestServerCustom("/game/random_tower/shop/get"):params({}):onResponse(function(arg_54_0)
			var_53_0[1] = true
		end):wait(var_53_0):doit(function(arg_55_0)
			gGameUI:stackUI("city.shop", nil, {
				full = true
			}, game.SHOP_INIT.RANDOM_TOWER_SHOP)
		end)
	end
end

function var_0_7.onRank(arg_56_0)
	local var_56_0 = {
		false
	}

	gGameApp:requestServerCustom("/game/rank"):params("random_tower", 0, 50):onResponse(function(arg_57_0)
		var_56_0[1] = true
	end):wait(var_56_0):doit(function(arg_58_0)
		gGameUI:stackUI("city.adventure.random_tower.rank", nil, nil, arg_58_0.view)
	end)
end

function var_0_7.onPoint(arg_59_0)
	gGameUI:stackUI("city.adventure.random_tower.point_reward")
end

function var_0_7.onRule(arg_60_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_60_0:createHandler("getRuleContext"))
end

function var_0_7.getRuleContext(arg_61_0, arg_61_1)
	local var_61_0 = arg_61_0.dayRank:read()
	local var_61_1
	local var_61_2 = adaptContext
	local var_61_3 = {
		var_61_2.clone(arg_61_1.title, function(arg_62_0)
			arg_62_0:get("text"):text(gLanguageCsv.randomTowerRule)
		end),
		var_61_2.clone(arg_61_0.ruleRankItem, function(arg_63_0)
			local var_63_0 = arg_63_0:multiget("textNow1", "now", "textNow2", "list")

			if not var_61_1 then
				nodetools.invoke(arg_63_0, {
					"textNow1",
					"now",
					"textNow2",
					"list"
				}, "hide")
				setContentSizeOfAnchor(arg_63_0, cc.size(arg_61_0.ruleRankItem:size().width, var_61_1 and 320 or 0))
			else
				var_63_0.now:text(var_61_0)
				adapt.oneLinePos(var_63_0.textNow1, {
					var_63_0.now,
					var_63_0.textNow2
				}, cc.p(5, 0))
				uiEasy.createItemsToList(arg_61_1, var_63_0.list, var_61_1.periodAward)
				var_63_0.list:setItemAlignCenter()
			end
		end),
		var_61_2.noteText(110),
		var_61_2.noteText(2001, 2010),
		var_61_2.noteText(108),
		var_61_2.noteText(2011, 2020),
		var_61_2.noteText(103)
	}
	local var_61_4 = getVersionContainMerge("randomTowerAwardVer")

	for iter_61_0, iter_61_1 in orderCsvPairs(csv.random_tower.rank_award) do
		if iter_61_1.version == var_61_4 then
			if var_61_0 >= iter_61_1.range[1] and var_61_0 < iter_61_1.range[2] then
				var_61_1 = iter_61_1
			end

			table.insert(var_61_3, var_61_2.clone(arg_61_1.awardItem, function(arg_64_0)
				local var_64_0 = arg_64_0:multiget("text", "list")

				if iter_61_1.range[2] - iter_61_1.range[1] == 1 then
					var_64_0.text:text(string.format(gLanguageCsv.rankSingle, iter_61_1.range[1]))
				else
					var_64_0.text:text(string.format(gLanguageCsv.rankMulti, iter_61_1.range[1], iter_61_1.range[2] - 1))
				end

				uiEasy.createItemsToList(arg_61_1, var_64_0.list, iter_61_1.periodAward)
			end))
		end
	end

	return var_61_3
end

function var_0_7.startFighting(arg_65_0, arg_65_1)
	local var_65_0 = arg_65_0.data[1].board[arg_65_1]
	local var_65_1 = table.deepcopy(gGameModel.role:read("huodong_cards")[game.EMBATTLE_HOUDONG_ID.randomTower], true)

	battleEntrance.battleRequest("/game/random_tower/start", var_65_1, var_65_0):onStartOK(function(arg_66_0)
		arg_65_0.selectId = nil

		gGameUI:goBackInStackUI("city.adventure.random_tower.view")
	end):show()
end

function var_0_7.startPassing(arg_67_0, arg_67_1)
	local var_67_0 = arg_67_0.data[1].board[arg_67_1]
	local var_67_1 = {
		false
	}

	gGameApp:requestServerCustom("/game/random_tower/pass"):params(var_67_0):onResponse(function(arg_68_0)
		var_67_1[1] = true
	end):wait(var_67_1):doit(function(arg_69_0)
		gGameUI:goBackInStackUI("city.adventure.random_tower.view")

		local var_69_0 = clone(arg_69_0.view.award) or {}

		if arg_69_0.view.point then
			table.insert(var_69_0, {
				[417] = arg_69_0.view.point
			})
		end

		gGameUI:showGainDisplay(var_69_0, {
			cb = function()
				arg_67_0:onPlayClick(arg_67_1)
			end
		})
	end)
end

function var_0_7.jumpOver(arg_71_0)
	arg_71_0:clearPanel()
	performWithDelay(arg_71_0, function()
		arg_71_0.state:set(arg_71_0:getState(), true)
	end, 0)
end

return var_0_7
