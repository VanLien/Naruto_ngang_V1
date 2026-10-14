require("battle.models.scene")

local var_0_0 = require("app.views.city.union.tools")
local var_0_1 = class("UnionGateView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "union_gate.json"
var_0_1.RESOURCE_BINDING = {
	rankItem = "rankItem",
	rewardItem = "rewardItem",
	["leftPanel.item"] = "leftItem",
	["right.empty"] = "empty",
	["right.maskPanel"] = "maskPanel",
	["right.rightPanel"] = "rightPanel",
	centerPanel = "centerPanel",
	["right.rightPanel.textAttrNote"] = "textAttrNote",
	["right.rightPanel.textAttr"] = "textAttr",
	["right.rightPanel.listTitlePanel"] = "listTitlePanel",
	["right.rightPanel.textOpenTime"] = "textOpenTime",
	["right.ruleBtnPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleBtn")
			}
		}
	},
	["right.ruleBtnPanel.text"] = {
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
	["right.rankBtnPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRankBtn")
			}
		}
	},
	["right.rankBtnPanel.text"] = {
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
	["right.progressBtnPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onProgressBtn")
			}
		}
	},
	["right.progressBtnPanel.text"] = {
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
	["right.rewardBtnPanel"] = {
		varname = "rewardBtnPanel",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRewardBtn")
			}
		}
	},
	["right.rewardBtnPanel.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["leftPanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				data = bindHelper.self("gateDatas"),
				item = bindHelper.self("leftItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("icon", "imgSelect", "textOrder", "iconComplete", "iconLock", "imgLockBg")

					var_1_0.icon:texture(arg_1_3.icon):visible(arg_1_3.unlocked == 1)
					var_1_0.imgSelect:visible(arg_1_3.selectEffect == true)
					var_1_0.textOrder:text(arg_1_3.csvId)
					var_1_0.iconComplete:visible(arg_1_3.time > 0)
					var_1_0.iconLock:visible(arg_1_3.unlocked == 2)
					var_1_0.imgLockBg:visible(arg_1_3.unlocked == 2)
					arg_1_1:setTouchEnabled(arg_1_3.unlocked == 1)
					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.itemClick, arg_1_2, arg_1_3)
						}
					})
				end,
				preloadCenter = bindHelper.self("selectCsvId")
			},
			handlers = {
				itemClick = bindHelper.self("onGateItemClick")
			}
		}
	},
	["right.rightPanel.rewardList"] = {
		varname = "rewardList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("rewardDatas"),
				item = bindHelper.self("rewardItem"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = {
						class = "icon_key",
						props = {
							data = {
								key = arg_2_3.key,
								num = arg_2_3.num
							}
						}
					}

					bind.extend(arg_2_0, arg_2_1, var_2_0)
				end
			}
		}
	},
	["right.rightPanel.rankList"] = {
		varname = "rankList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("rankDatas"),
				item = bindHelper.self("rankItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:multiget("iconRank", "textRank1", "textRank2", "textName", "textDamage")

					var_3_0.textName:text(arg_3_3.name)
					var_3_0.textDamage:text(arg_3_3.damage)
					uiEasy.setRankIcon(arg_3_2, var_3_0.iconRank, var_3_0.textRank1, var_3_0.textRank2)
				end,
				onAfterBuild = function(arg_4_0)
					arg_4_0.afterBuild()
				end
			},
			handlers = {
				afterBuild = bindHelper.self("onAfterBuild")
			}
		}
	},
	["centerPanel.textNum"] = {
		varname = "textNum",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["centerPanel.textNumNote"] = {
		varname = "textNumNote",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["centerPanel.btnFight"] = {
		varname = "btnFight",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnFight")
			}
		}
	},
	["centerPanel.btnThreeFight"] = {
		varname = "btnThreeFight",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnThreeFight")
			}
		}
	},
	["centerPanel.textDesc"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["centerPanel.textName"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["right.rightPanel.textRewardNote"] = {
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
var_0_1.RESOURCE_STYLES = {
	full = true
}

function var_0_1.onCreate(arg_5_0)
	gGameUI.topuiManager:createView("union", arg_5_0, {
		onClose = arg_5_0:createHandler("onClose")
	}):init({
		subTitle = "CONSORTIA",
		title = "common/txt/txt_bt_zuzhifuben.png"
	})
	arg_5_0:initModel()

	arg_5_0.gateDatas = idlers.new()
	arg_5_0.selectCsvId = idler.new(1)
	arg_5_0.complete = idler.new(false)

	idlereasy.when(arg_5_0.unionFuben, function(arg_6_0, arg_6_1)
		local var_6_0 = {}
		local var_6_1 = 1
		local var_6_2 = false

		for iter_6_0, iter_6_1 in orderCsvPairs(csv.union.union_fuben) do
			local var_6_3 = csv.scene_conf[iter_6_1.gateID]
			local var_6_4 = arg_6_1[iter_6_0]

			if not var_6_4 and not var_6_2 then
				var_6_2 = true

				table.insert(var_6_0, {
					surplusHp = 0,
					unlocked = 2,
					buff = 0,
					maxHp = 0,
					damage = 0,
					time = 0,
					csvId = iter_6_0,
					icon = var_6_3.icon
				})
			elseif not itertools.isempty(var_6_4) then
				if var_6_1 < iter_6_0 then
					var_6_1 = iter_6_0
				end

				table.insert(var_6_0, {
					unlocked = 1,
					csvId = iter_6_0,
					icon = var_6_3.icon,
					buff = var_6_4.buff,
					surplusHp = math.max(var_6_4.hpmax - var_6_4.damage, 0),
					maxHp = var_6_4.hpmax,
					damage = var_6_4.damage,
					time = var_6_4.time
				})
			end
		end

		table.sort(var_6_0, function(arg_7_0, arg_7_1)
			return arg_7_0.csvId < arg_7_1.csvId
		end)
		arg_5_0.gateDatas:update(var_6_0)
		arg_5_0.selectCsvId:set(var_6_1, true)
	end)

	arg_5_0.rankDatas = idlertable.new({})
	arg_5_0.rewardDatas = idlertable.new({})

	arg_5_0.selectCsvId:addListener(function(arg_8_0, arg_8_1)
		local var_8_0 = arg_5_0.gateDatas:atproxy(arg_8_0)
		local var_8_1 = arg_5_0.gateDatas:atproxy(arg_8_1)

		if var_8_1 then
			var_8_1.selectEffect = false
		end

		var_8_0.selectEffect = true

		local var_8_2 = arg_5_0.members:read()
		local var_8_3 = {}
		local var_8_4 = arg_5_0.unionFuben:read()[arg_8_0]

		if var_8_4 then
			for iter_8_0, iter_8_1 in pairs(var_8_4.members or {}) do
				if var_8_2[iter_8_0] then
					table.insert(var_8_3, {
						name = var_8_2[iter_8_0].name,
						damage = math.max(iter_8_1, 0)
					})
				end
			end

			table.sort(var_8_3, function(arg_9_0, arg_9_1)
				return arg_9_0.damage > arg_9_1.damage
			end)
			arg_5_0.rankDatas:set(var_8_3)
		end

		arg_5_0:setCenterPanel(var_8_0)
		arg_5_0:setRightPanel(var_8_0)
	end)
	idlereasy.when(arg_5_0.unionFbTimes, function(arg_10_0, arg_10_1)
		local var_10_0 = math.max(3 - arg_10_1, 0)

		arg_5_0.textNum:text(var_10_0 .. "/3")

		local var_10_1 = var_10_0 > 0 and var_0_0.currentOpenFuben() == "open"

		uiEasy.setBtnShader(arg_5_0.btnFight, arg_5_0.btnFight:get("title"), var_10_1 and 1 or 2)
		uiEasy.setBtnShader(arg_5_0.btnThreeFight, arg_5_0.btnThreeFight:get("title"), var_10_1 and 1 or 2)

		if var_10_1 then
			text.addEffect(arg_5_0.btnFight:get("title"), {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
			text.addEffect(arg_5_0.btnThreeFight:get("title"), {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
		else
			text.deleteAllEffect(arg_5_0.btnFight:get("title"))
			text.deleteAllEffect(arg_5_0.btnThreeFight:get("title"))
		end
	end)
	idlereasy.when(arg_5_0.unionFbAward, function(arg_11_0, arg_11_1)
		local var_11_0 = arg_5_0.rewardBtnPanel:get("effect")
		local var_11_1 = dataEasy.haveUnionFubenReward()

		if not var_11_1 then
			if var_11_0 then
				var_11_0:hide()
			end
		else
			local var_11_2 = arg_5_0.rewardBtnPanel:size()

			if not var_11_0 then
				var_11_0 = widget.addAnimationByKey(arg_5_0.rewardBtnPanel, "union/huanghekelingqu.skel", "effect", "effect_loop", 5):xy(var_11_2.width / 2, var_11_2.height / 2 + 12)
			else
				var_11_0:show()
			end
		end

		uiEasy.addVibrateToNode(arg_5_0, arg_5_0.rewardBtnPanel, var_11_1)
	end)
	idlereasy.any({
		arg_5_0.roleLv,
		arg_5_0.complete
	}, function(arg_12_0, arg_12_1, arg_12_2)
		arg_5_0.btnFight:visible(not arg_12_2)
		arg_5_0.btnThreeFight:visible(not arg_12_2)

		if not arg_12_2 then
			local var_12_0 = dataEasy.isUnlock(gUnlockCsv.uinonGateThreeTimes)

			arg_5_0.btnThreeFight:visible(var_12_0)

			local var_12_1 = cc.p(170, 70)

			if not var_12_0 then
				var_12_1 = cc.p(390, 70)
			end

			arg_5_0.btnFight:xy(var_12_1)
		end
	end)
end

function var_0_1.initModel(arg_13_0)
	arg_13_0.members = gGameModel.union:getIdler("members")
	arg_13_0.unionFuben = gGameModel.union_fuben:getIdler("states")
	arg_13_0.unionFbAward = gGameModel.role:getIdler("union_fb_award")
	arg_13_0.roleId = gGameModel.role:getIdler("id")
	arg_13_0.unionFbTimes = gGameModel.daily_record:getIdler("union_fb_times")
	arg_13_0.roleLv = gGameModel.role:getIdler("level")
end

function var_0_1.setCenterPanel(arg_14_0, arg_14_1)
	local var_14_0 = csv.union.union_fuben[arg_14_1.csvId]
	local var_14_1 = gMonsterCsv[var_14_0.gateID][1]
	local var_14_2

	for iter_14_0, iter_14_1 in ipairs(var_14_1.monsters) do
		if iter_14_1 ~= 0 then
			var_14_2 = csv.unit[iter_14_1]

			break
		end
	end

	local var_14_3 = csv.scene_conf[var_14_0.gateID]
	local var_14_4 = arg_14_0.centerPanel

	var_14_4:get("textName"):text(var_14_0.name)
	var_14_4:get("iconAttr1"):texture(ui.ATTR_ICON[var_14_2.natureType])

	if var_14_2.natureType2 then
		var_14_4:get("iconAttr2"):texture(ui.ATTR_ICON[var_14_2.natureType2])
	else
		var_14_4:get("iconAttr2"):hide()
	end

	local var_14_5 = var_14_3.bg_boss_pos
	local var_14_6 = var_14_4:get("pos"):x() + var_14_5.x
	local var_14_7 = var_14_4:get("pos"):y() + var_14_5.y

	var_14_4:get("icon"):texture("common/btn/kong.png"):xy(var_14_6, var_14_7)

	if var_14_4:get("icon"):get("bgboss") then
		var_14_4:get("icon"):removeChildByName("bgboss")
	end

	widget.addAnimationByKey(var_14_4:get("icon"), var_14_3.bg_boss, "bgboss", "standby_loop", 100):xy(0, 0):scale(0.66)
	var_14_4:get("textDesc"):text(var_14_0.desc)

	local var_14_8 = arg_14_1.maxHp == 0 and 100 or arg_14_1.surplusHp / arg_14_1.maxHp * 100

	var_14_4:get("textHp"):visible(var_14_8 > 0)
	var_14_4:get("bar"):visible(var_14_8 > 0)
	var_14_4:get("textHpNote"):visible(var_14_8 > 0)
	var_14_4:get("barBg"):visible(var_14_8 > 0)
	var_14_4:get("bar"):percent(var_14_8)

	local var_14_9 = mathEasy.getPreciseDecimal(var_14_8, 2)
	local var_14_10 = math.max(var_14_9, 0.01)

	var_14_4:get("textHp"):text(var_14_10 .. "%")

	local var_14_11 = arg_14_1.surplusHp == 0 and arg_14_1.maxHp > 0

	var_14_4:get("iconComplete"):visible(var_14_11)
	itertools.invoke({
		arg_14_0.textNum,
		arg_14_0.textNumNote
	}, var_14_11 and "hide" or "show")
	arg_14_0.complete:set(var_14_11)
end

function var_0_1.setRightPanel(arg_15_0, arg_15_1)
	local var_15_0 = csv.union.union_fuben[arg_15_1.csvId]
	local var_15_1 = {}
	local var_15_2 = true
	local var_15_3 = arg_15_0.unionFbAward:read()[arg_15_1.csvId]

	if var_15_3 and var_15_3[1] ~= 0 then
		var_15_2 = false
	end

	local var_15_4 = var_15_2 and var_15_0.firstAward or var_15_0.repeatAward

	for iter_15_0, iter_15_1 in csvMapPairs(var_15_4) do
		table.insert(var_15_1, {
			key = iter_15_0,
			num = iter_15_1
		})
	end

	arg_15_0.rewardDatas:set(var_15_1)

	local var_15_5 = arg_15_1.buff > 0 and var_0_0.currentOpenFuben() == "open"

	arg_15_0.textAttrNote:visible(var_15_5)
	arg_15_0.textAttr:visible(var_15_5):text(arg_15_1.buff .. "%")
	adapt.oneLineCenterPos(cc.p(500, 395), {
		arg_15_0.textAttrNote,
		arg_15_0.textAttr
	}, cc.p(6, 0))
	arg_15_0.textOpenTime:visible(var_0_0.currentOpenFuben() ~= "open")

	if var_0_0.currentOpenFuben() == "weekError" then
		arg_15_0.textOpenTime:text(gLanguageCsv.fubenClosedOnSunday)
	end

	local var_15_6 = arg_15_0.unionFbAward:read()[arg_15_1.csvId] and gLanguageCsv.killReward or gLanguageCsv.firstPassAward

	arg_15_0.rightPanel:get("textRewardNote"):text(var_15_6)
end

function var_0_1.onGateItemClick(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	arg_16_0.selectCsvId:set(arg_16_3.csvId)
end

function var_0_1.onBtnFight(arg_17_0)
	local function var_17_0(arg_18_0)
		local var_18_0 = csv.union.union_fuben[arg_17_0.selectCsvId:read()]
		local var_18_1 = arg_17_0.gateDatas:atproxy(arg_17_0.selectCsvId:read())

		battleEntrance.battleRequest("/game/union/fuben/start", arg_17_0.selectCsvId, var_18_0.gateID):onStartOK(function(arg_19_0)
			arg_18_0:onClose()

			arg_19_0.damage = var_18_1.damage
			arg_19_0.hpMax = var_18_1.maxHp
		end):show()
	end

	gGameUI:stackUI("city.card.embattle.base", nil, {
		full = true
	}, {
		sceneType = game.SCENE_TYPE.unionFuben,
		from = game.EMBATTLE_FROM_TABLE.huodong,
		fromId = game.EMBATTLE_HOUDONG_ID.unionGate,
		fightCb = var_17_0
	})
end

function var_0_1.onBtnThreeFight(arg_20_0)
	local var_20_0 = arg_20_0.selectCsvId:read()
	local var_20_1 = arg_20_0.gateDatas:atproxy(var_20_0)
	local var_20_2 = arg_20_0.members:read()
	local var_20_3 = arg_20_0.unionFbTimes:read()
	local var_20_4 = math.max(0, 3 - var_20_3)
	local var_20_5 = var_20_1.maxHp == 0
	local var_20_6 = var_20_1.surplusHp
	local var_20_7 = csv.union.union_fuben[arg_20_0.selectCsvId:read()]
	local var_20_8 = {}

	local function var_20_9()
		battleEntrance.battleRequest("/game/union/fuben/start", arg_20_0.selectCsvId, var_20_7.gateID):onStartOK(function(arg_22_0)
			arg_22_0.damage = var_20_1.damage
			arg_22_0.hpMax = var_20_1.maxHp
		end):onResult(function(arg_23_0, arg_23_1)
			local var_23_0 = arg_23_1.serverData.view

			var_20_1 = arg_20_0.gateDatas:atproxy(var_20_0)

			local var_23_1 = var_20_1.maxHp

			var_20_6 = var_20_1.surplusHp

			local var_23_2 = math.max(var_23_0.damage, 0) / var_23_1
			local var_23_3 = math.floor(var_23_2 * 10000) / 100 .. "%"

			table.insert(var_20_8, {
				items = var_23_0.drop,
				exp = var_23_3
			})

			var_20_4 = var_20_4 - 1
			var_20_5 = false

			if (var_20_6 > 0 or var_20_5) and var_20_4 > 0 then
				var_20_9()
			else
				arg_20_0:onSweepReward(var_20_8)

				return false
			end
		end):run()
	end

	if (var_20_6 > 0 or var_20_5) and var_20_4 > 0 then
		var_20_9()
	end
end

function var_0_1.onSweepReward(arg_24_0, arg_24_1)
	if #arg_24_1 < 1 then
		return
	end

	local var_24_0 = gGameModel.capture:read("limit_sprites")

	gGameUI:stackUI("city.gate.sweep", nil, nil, {
		showType = 2,
		from = "union",
		hasExtra = false,
		sweepData = arg_24_1,
		oldRoleLv = arg_24_0.roleLv:read(),
		title1 = gLanguageCsv.guild,
		title2 = gLanguageCsv.fubenChallenge,
		oldCapture = var_24_0
	})
end

function var_0_1.onRuleBtn(arg_25_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_25_0:createHandler("getRuleContext"))
end

function var_0_1.getRuleContext(arg_26_0, arg_26_1)
	local var_26_0 = adaptContext
	local var_26_1 = {
		var_26_0.clone(arg_26_1.title),
		var_26_0.noteText(112),
		var_26_0.noteText(44001, 44099),
		var_26_0.noteText(135)
	}

	for iter_26_0, iter_26_1 in orderCsvPairs(csv.union.union_fuben_rank) do
		table.insert(var_26_1, var_26_0.clone(arg_26_1.awardItem, function(arg_27_0)
			local var_27_0 = arg_27_0:multiget("text", "list")

			if iter_26_1.range[2] - iter_26_1.range[1] == 0 then
				var_27_0.text:text(string.format(gLanguageCsv.rankSingle, iter_26_1.range[1]))
			else
				var_27_0.text:text(string.format(gLanguageCsv.rankMulti, iter_26_1.range[1], iter_26_1.range[2]))
			end

			uiEasy.createItemsToList(arg_26_1, var_27_0.list, iter_26_1.award)
		end))
	end

	return var_26_1
end

function var_0_1.onRankBtn(arg_28_0)
	gGameApp:requestServer("/game/union/fuben/progress", function(arg_29_0)
		gGameUI:stackUI("city.union.gate.rank", nil, nil, arg_29_0.view)
	end)
end

function var_0_1.onProgressBtn(arg_30_0)
	gGameUI:stackUI("city.union.gate.progress", nil, nil, {
		needConsider = true
	})
end

function var_0_1.onRewardBtn(arg_31_0)
	if not dataEasy.haveUnionFubenReward() then
		gGameUI:showTip(gLanguageCsv.noRewardAvailable)

		return
	end

	gGameUI:stackUI("city.union.gate.reward", nil, nil, arg_31_0.unionFuben:read(), arg_31_0:createHandler("onRewardCb"))
end

function var_0_1.onRewardCb(arg_32_0, arg_32_1)
	gGameUI:showGainDisplay(arg_32_1)
end

function var_0_1.onSortRank(arg_33_0, arg_33_1)
	return function(arg_34_0, arg_34_1)
		return arg_34_0.damage > arg_34_1.damage
	end
end

function var_0_1.onAfterBuild(arg_35_0)
	local var_35_0 = arg_35_0.rankList:getChildrenCount() == 0

	arg_35_0.empty:visible(var_35_0)
	arg_35_0.listTitlePanel:visible(not var_35_0)
	arg_35_0.maskPanel:visible(not var_35_0)
	uiEasy.setBottomMask(arg_35_0.rankList, arg_35_0.maskPanel)
end

return var_0_1
