local var_0_0 = require("app.views.city.zawake.tools")
local var_0_1 = 3120
local var_0_2 = -1000
local var_0_3 = 1300
local var_0_4 = cc.load("mvc").ViewBase
local var_0_5 = class("ZawakeView", var_0_4)

var_0_5.RESOURCE_FILENAME = "zawake.json"
var_0_5.RESOURCE_BINDING = {
	["bgMap.mainPanel"] = "mainPanel",
	bgMap = "bgMap",
	["bgMap.mainPanel.topPanel"] = "topPanel",
	["bgMap.mainPanel.cardIcon"] = {
		varname = "cardIcon",
		binds = {
			event = "click",
			method = bindHelper.self("onReplaceClick")
		}
	},
	["rightPanel.btnRule.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["rightPanel.btnPreview.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["rightPanel.btnReset.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["bgMap.npcPanel"] = {
		varname = "npcPanel",
		binds = {
			event = "click",
			method = bindHelper.self("onAwakeClick")
		}
	},
	["rightPanel.btnRule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleClick")
			}
		}
	},
	["rightPanel.btnPreview"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPreviewClick")
			}
		}
	},
	["rightPanel.btnReset"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onResetClick")
			}
		}
	},
	["rightPanel.toLastStageBtn.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c3b(236, 78, 87)
				}
			}
		}
	},
	["leftPanel.toLeftBtn.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c3b(236, 78, 87)
				}
			}
		}
	},
	["rightPanel.toLastStageBtn"] = {
		varname = "toLastStageBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onJumpToLastStageClick")
			}
		}
	},
	["leftPanel.toLeftBtn"] = {
		varname = "toLeftBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onJumpToLeftClick")
			}
		}
	},
	["bgMap.mainPanel.btnReplace"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onReplaceClick")
			}
		}
	},
	["bgMap.mainPanel.btnReplace.txt"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	}
}

function var_0_5.onCreate(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_1 or {}

	arg_1_0.params = var_1_0

	local var_1_1 = var_1_0.zawakeID or var_0_0.getFightPointMaxCard()

	arg_1_0.zawakeID = idler.new(var_1_1)

	arg_1_0:initModel()
	arg_1_0:initStagePanel()
	arg_1_0:initBgMap()
	gGameUI.topuiManager:createView("default", arg_1_0, {
		onClose = arg_1_0:createHandler("onClose")
	}):init({
		subTitle = "ZAWAKE",
		title = gLanguageCsv.zawake
	})
	arg_1_0.zawakeID:addListener(function(arg_2_0, arg_2_1)
		local var_2_0 = var_0_0.getCardByZawakeID(arg_2_0)
		local var_2_1 = csv.unit[var_2_0.cfg.unitID]
		local var_2_2 = arg_1_0.topPanel:multiget("icon", "name")

		var_2_2.icon:texture(ui.RARITY_ICON[var_2_1.rarity])
		var_2_2.name:text(var_2_0.cfg.name)
		arg_1_0.cardIcon:removeAllChildren()

		local var_2_3 = widget.addAnimation(arg_1_0.cardIcon, var_2_1.unitRes, "standby_loop", 5):xy(arg_1_0.cardIcon:width() / 2, 0):scale(var_2_1.scaleU * 2.3):setSkin(var_2_1.skin)

		arg_1_0:updateAllStage()

		if arg_2_0 ~= arg_2_1 then
			arg_1_0:updateMainSpine(true)
		end
	end)
	idlereasy.when(arg_1_0.zawake, function(arg_3_0, arg_3_1)
		arg_3_1 = arg_3_1 or {}

		arg_1_0:updateAllStage(arg_3_1)
	end)
	arg_1_0.showStageID:addListener(function(arg_4_0, arg_4_1)
		arg_1_0.npcPanel:stopAllActions()

		local var_4_0 = arg_1_0.npcPanel:x()
		local var_4_1 = arg_1_0.npcPanel:y()
		local var_4_2 = arg_1_0.stagPanels[arg_4_0]:x() + 20
		local var_4_3 = math.abs(var_4_0 - var_4_2)
		local var_4_4 = var_4_3 / var_0_3
		local var_4_5 = var_0_1 - 500
		local var_4_6 = var_4_5 < var_4_3 and 2 or 1

		var_4_4 = var_4_5 < var_4_3 and var_4_4 / 2 or var_4_4

		local var_4_7 = transition.sequence({
			cc.MoveTo:create(var_4_4, cc.p(var_4_2, var_4_1)),
			cc.CallFunc:create(function()
				arg_1_0:updateNpcSpine("standby_loop")
			end)
		})

		arg_1_0:updateNpcSpine("run_loop", arg_4_0 < arg_4_1, var_4_6)
		arg_1_0.npcPanel:runAction(var_4_7)
	end)
end

function var_0_5.initModel(arg_6_0)
	arg_6_0.zawake = gGameModel.role:getIdler("zawake")
	arg_6_0.showStageID = idler.new(1)
	arg_6_0.npcIsMove = false
	arg_6_0.npcWidth = arg_6_0.npcPanel:width()
end

function var_0_5.initBgMap(arg_7_0)
	arg_7_0.bgMap:setScrollBarEnabled(false)
	arg_7_0.bgMap:width(display.sizeInViewRect.width)

	local var_7_0 = arg_7_0.bgMap:getInnerContainer()

	arg_7_0.bgMap:onScroll(function(arg_8_0)
		if arg_8_0.name == "CONTAINER_MOVED" then
			arg_7_0.toLastStageBtn:visible(var_7_0:x() > var_0_2)
			arg_7_0.toLeftBtn:visible(var_7_0:x() <= var_0_2)
			arg_7_0:setShowStageID(var_7_0:x())
		end
	end)
	arg_7_0:onJumpToLeftClick()
	arg_7_0:updateLianjieSpine(arg_7_0.bgMap)
	arg_7_0:updateMainSpine()
end

function var_0_5.initStagePanel(arg_9_0)
	arg_9_0.stagPanels = {}
	arg_9_0.stagPanelsPosX = {}

	for iter_9_0 = 1, var_0_0.MAXSTAGE do
		local var_9_0 = arg_9_0.bgMap:get("stagePanel" .. iter_9_0)

		table.insert(arg_9_0.stagPanels, var_9_0)
		table.insert(arg_9_0.stagPanelsPosX, var_9_0:x())

		local var_9_1 = var_9_0:get("infoPanel")

		text.addEffect(var_9_1:get("textStage"), {
			outline = {
				color = ui.COLORS.OUTLINE.DEFAULT
			}
		})
		text.addEffect(var_9_1:get("textLevel0"), {
			outline = {
				color = ui.COLORS.OUTLINE.DEFAULT
			}
		})
		text.addEffect(var_9_1:get("textLevel1"), {
			outline = {
				color = ui.COLORS.OUTLINE.DEFAULT
			}
		})
		text.addEffect(var_9_1:get("textLevel2"), {
			outline = {
				color = ui.COLORS.OUTLINE.DEFAULT
			}
		})

		local var_9_2 = var_9_0:get("closePanel")

		text.addEffect(var_9_2:get("txt"), {
			outline = {
				color = cc.c4b(71, 66, 71, 255)
			}
		})
		var_9_2:get("bg"):width(var_9_2:get("txt"):width() + 50)
		bind.click(arg_9_0, var_9_0:get("spineNode"), {
			method = function()
				arg_9_0:onStageClick(iter_9_0)
			end
		})
	end
end

function var_0_5.updateMainSpine(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_1 and "qiehuan" or "standby_loop"
	local var_11_1 = 65
	local var_11_2 = widget.addAnimationByKey(arg_11_0.mainPanel, "zawake/jixiebi.skel", "effectBottom", var_11_0 .. "_hou", 5)

	var_11_2:scale(2)
	var_11_2:xy(arg_11_0.mainPanel:width() / 2, var_11_1)
	var_11_2:play(var_11_0 .. "_hou")

	local var_11_3 = widget.addAnimationByKey(arg_11_0.mainPanel, "zawake/jixiebi.skel", "effectTop", var_11_0 .. "_qian", 15)

	var_11_3:scale(2)
	var_11_3:xy(arg_11_0.mainPanel:width() / 2, var_11_1)
	var_11_3:play(var_11_0 .. "_qian")

	if arg_11_1 then
		arg_11_0.cardIcon:hide()
		performWithDelay(arg_11_0.cardIcon, function()
			arg_11_0.cardIcon:show()
		end, 0.75)
		var_11_2:setTimeScale(2)
		var_11_2:setSpriteEventHandler(function(arg_13_0, arg_13_1)
			var_11_2:play("standby_loop_hou")
			var_11_2:setTimeScale(1)
		end, sp.EventType.ANIMATION_COMPLETE)
		var_11_3:setTimeScale(2)
		var_11_3:setSpriteEventHandler(function(arg_14_0, arg_14_1)
			var_11_3:play("standby_loop_qian")
			var_11_3:setTimeScale(1)
		end, sp.EventType.ANIMATION_COMPLETE)
	end
end

function var_0_5.setShowStageID(arg_15_0, arg_15_1)
	if arg_15_0.npcIsMove then
		return
	end

	arg_15_0.npcIsMove = true
	arg_15_1 = math.abs(arg_15_1)

	local var_15_0 = arg_15_0.stagPanelsPosX[arg_15_0.showStageID:read()]

	if var_15_0 < arg_15_1 or var_15_0 > arg_15_1 + display.sizeInViewRect.width - arg_15_0.npcWidth then
		local var_15_1 = 1

		for iter_15_0 = 1, var_0_0.MAXSTAGE do
			if arg_15_1 < arg_15_0.stagPanelsPosX[iter_15_0] then
				var_15_1 = iter_15_0

				break
			end
		end

		if var_15_1 ~= arg_15_0.showStageID:read() then
			arg_15_0.showStageID:set(var_15_1)
		end
	end

	arg_15_0.npcIsMove = false
end

function var_0_5.updateAllStage(arg_16_0, arg_16_1)
	arg_16_1 = arg_16_1 or arg_16_0.zawake:read() or {}

	local var_16_0 = arg_16_1[arg_16_0.zawakeID:read()] or {}

	for iter_16_0 = 1, var_0_0.MAXSTAGE do
		arg_16_0:updateStagePanel(iter_16_0, var_16_0[iter_16_0] or 0)

		local var_16_1 = arg_16_0.stagPanels[iter_16_0]:get("infoPanel")

		bind.extend(arg_16_0, var_16_1, {
			class = "red_hint",
			props = {
				specialTag = "canZawakeByStage",
				listenData = {
					stageID = iter_16_0,
					zawakeID = arg_16_0.zawakeID:read()
				},
				onNode = function(arg_17_0)
					arg_17_0:xy(340, 110)
				end
			}
		})
	end
end

function var_0_5.updateNpcSpine(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = arg_18_3 or 1
	local var_18_1 = widget.addAnimationByKey(arg_18_0.npcPanel, "zawake/meilutan.skel", "effect", arg_18_1, 2)

	var_18_1:scaleX(arg_18_2 and -2 or 2)
	var_18_1:setTimeScale(var_18_0)
	var_18_1:scaleY(2)
	var_18_1:play(arg_18_1)
	var_18_1:xy(arg_18_0.npcWidth / 2, 0)
end

function var_0_5.updateStageSpine(arg_19_0, arg_19_1, arg_19_2)
	arg_19_1:removeChildByName("img")

	local var_19_0 = ((arg_19_0.zawake:read() or {})[arg_19_0.zawakeID:read()] or {})[arg_19_2] or 0
	local var_19_1 = string.format("zawake/jiqi_%s.skel", arg_19_2)
	local var_19_2 = "effect_posun_loop"

	if var_19_0 > 0 then
		var_19_2 = "effect_xiufu_loop" .. var_19_0
	end

	local var_19_3 = widget.addAnimationByKey(arg_19_1, var_19_1, "effect", var_19_2, 5)

	var_19_3:scale(2)
	var_19_3:play(var_19_2)
	var_19_3:xy(arg_19_1:width() / 2, 0)

	if arg_19_2 == 4 then
		local var_19_4 = widget.addAnimationByKey(arg_19_1, var_19_1, "houEffect", "effect_hou_loop", 2)

		var_19_4:scale(2)
		var_19_4:play("effect_hou_loop")
		var_19_4:xy(arg_19_1:width() / 2, 0)
	elseif arg_19_2 == 7 then
		local var_19_5 = widget.addAnimationByKey(arg_19_1, "zawake/jiqi_7_hou.skel", "houEffect", var_19_2, 2)

		var_19_5:scale(2)
		var_19_5:play(var_19_2)
		var_19_5:xy(arg_19_1:width() / 2, 0)
	end
end

function var_0_5.updateLianjieSpine(arg_20_0, arg_20_1, arg_20_2)
	if arg_20_2 == 4 then
		arg_20_0:updateLianjieSpine(arg_20_1, 3)
	elseif arg_20_2 == 6 then
		arg_20_0:updateLianjieSpine(arg_20_1, 5)
	end

	local var_20_0 = {
		{
			500,
			215
		},
		{
			733,
			23
		},
		{
			-480,
			37
		},
		{
			647,
			141
		},
		{
			-530,
			177
		},
		{
			420,
			95
		},
		{
			488,
			112
		},
		{
			370,
			169
		}
	}
	local var_20_1 = "effect_boliguandao_kaiqi_loop"

	if arg_20_2 then
		local var_20_2 = ((arg_20_0.zawake:read() or {})[arg_20_0.zawakeID:read()] or {})[arg_20_2] or 0

		var_20_1 = string.format("effect_chuansongdai_%d_guanbi_loop", arg_20_2)

		if var_20_2 == var_0_0.MAXLEVEL then
			var_20_1 = string.format("effect_chuansongdai_%d_kaiqi_loop", arg_20_2)
		end
	end

	local var_20_3 = widget.addAnimationByKey(arg_20_1, "zawake/lianjie_1.skel", "chuansongdai" .. (arg_20_2 or 0), var_20_1, 3)

	var_20_3:scale(2)
	var_20_3:play(var_20_1)

	if arg_20_2 then
		var_20_3:xy(var_20_0[arg_20_2][1], var_20_0[arg_20_2][2])
	else
		var_20_3:xy(1260, 405)
	end
end

function var_0_5.onJumpToLeftClick(arg_21_0)
	local var_21_0 = math.max((var_0_1 - display.sizeInViewRect.width) / 2, 0) / (arg_21_0.bgMap:getInnerContainerSize().width - display.sizeInViewRect.width) * 100

	arg_21_0.bgMap:scrollToPercentHorizontal(var_21_0, 0.5, true)
	arg_21_0.toLastStageBtn:show()
	arg_21_0.toLeftBtn:hide()
end

function var_0_5.onJumpToLastStageClick(arg_22_0)
	local var_22_0 = (arg_22_0.zawake:read() or {})[arg_22_0.zawakeID:read()] or {}
	local var_22_1 = {}

	for iter_22_0, iter_22_1 in pairs(var_22_0) do
		table.insert(var_22_1, {
			stage = iter_22_0,
			level = iter_22_1
		})
	end

	table.sort(var_22_1, function(arg_23_0, arg_23_1)
		return arg_23_0.stage > arg_23_1.stage
	end)

	local var_22_2 = 1

	if #var_22_1 > 0 then
		var_22_2 = var_22_1[1].stage
	end

	arg_22_0:moveToByStage(var_22_2)
end

function var_0_5.onStageClick(arg_24_0, arg_24_1)
	local var_24_0, var_24_1 = var_0_0.getStagesCfg(arg_24_0.zawakeID:read(), arg_24_1)

	if var_24_0.isOpen ~= var_0_0.STAGE_OPEN_STATE.open then
		gGameUI:showTip(gLanguageCsv.comingSoon)

		return
	end

	local var_24_2, var_24_3 = var_0_0.isUnlockByStage(var_24_0, arg_24_0.zawakeID:read())

	if var_24_2 then
		gGameUI:stackUI("city.zawake.stage", nil, {
			backGlass = true
		}, {
			stage = arg_24_1,
			zawakeID = arg_24_0.zawakeID:read()
		})

		return
	end

	gGameUI:stackUI("city.zawake.unlock_tips", nil, nil, {
		labelDatas = var_24_3,
		stageID = arg_24_1
	})
end

function var_0_5.moveToByStage(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_0.stagPanels[arg_25_1]
	local var_25_1 = arg_25_0.bgMap:getInnerContainerSize().width
	local var_25_2 = math.max(var_25_0:x() + var_25_0:width() / 2 - display.sizeInViewRect.width / 2, 0) / (var_25_1 - display.sizeInViewRect.width) * 100

	if arg_25_2 then
		arg_25_0.bgMap:jumpToPercentHorizontal(var_25_2)
	else
		arg_25_0.bgMap:scrollToPercentHorizontal(var_25_2, 0.5, true)
	end
end

function var_0_5.updateStagePanel(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_0.stagPanels[arg_26_1]
	local var_26_1 = var_26_0:get("infoPanel")

	if arg_26_2 == var_0_0.MAXLEVEL then
		text.addEffect(var_26_1:get("textLevel1"), {
			color = ui.COLORS.NORMAL.WHITE
		})
	else
		text.addEffect(var_26_1:get("textLevel1"), {
			color = ui.COLORS.NORMAL.RED
		})
	end

	var_26_1:get("textLevel1"):text(arg_26_2)
	var_26_1:get("textStage"):text(string.format("%s%s", gLanguageCsv.effortAdvance, gLanguageCsv["symbolRome" .. arg_26_1]))
	adapt.oneLineCenterPos(cc.p(var_26_1:width() / 2, var_26_1:height() / 2), {
		var_26_1:get("textStage"),
		var_26_1:get("textLevel0"),
		var_26_1:get("textLevel1"),
		var_26_1:get("textLevel2")
	}, cc.p(3, 0))
	var_26_1:get("bg"):width(var_26_1:get("textStage"):width() + var_26_1:get("textLevel0"):width() + var_26_1:get("textLevel1"):width() + var_26_1:get("textLevel2"):width() + 70)

	if var_0_0.isOpenByStage(arg_26_0.zawakeID:read(), arg_26_1) then
		arg_26_0:updateStageSpine(var_26_0:get("spineNode"), arg_26_1)
		var_26_1:show()
	else
		var_26_1:hide()
	end

	local var_26_2 = var_26_0:get("lockPanel")
	local var_26_3, var_26_4 = var_0_0.getStagesCfg(arg_26_0.zawakeID:read(), arg_26_1)

	arg_26_0.stagPanels[arg_26_1].isOpen = var_26_3.isOpen

	var_26_0:get("closePanel"):visible(var_26_3.isOpen ~= var_0_0.STAGE_OPEN_STATE.open)
	var_26_2:hide()

	if var_26_3.isOpen == var_0_0.STAGE_OPEN_STATE.open then
		local var_26_5, var_26_6 = var_0_0.isUnlockByStage(var_26_3, arg_26_0.zawakeID:read())

		arg_26_0.stagPanels[arg_26_1].isUnlock = var_26_5
		arg_26_0.stagPanels[arg_26_1].labelDatas = var_26_6

		var_26_2:visible(not var_26_5)
	end

	if arg_26_1 == 3 or arg_26_1 == 5 then
		return
	end

	arg_26_0:updateLianjieSpine(var_26_0:get("spineNode"), arg_26_1)
end

function var_0_5.onAwakeClick(arg_27_0)
	gGameUI:stackUI("city.zawake.force")
end

function var_0_5.onPreviewClick(arg_28_0)
	local var_28_0 = arg_28_0.zawakeID:read()

	if not (gGameModel.role:read("zawake") or {})[var_28_0] then
		local var_28_1 = {}
	end

	local var_28_2 = {}

	for iter_28_0 = 1, var_0_0.MAXSTAGE do
		for iter_28_1 = 1, var_0_0.MAXLEVEL do
			local var_28_3 = var_0_0.getLevelCfg(var_28_0, iter_28_0, iter_28_1)

			if var_28_3 and var_28_3.skillID > 0 and var_0_0.getSkillCfg(var_28_0, var_28_3.skillID) then
				gGameUI:stackUI("city.zawake.preview", nil, nil, var_28_0)

				return
			end
		end
	end

	gGameUI:showTip(gLanguageCsv.zawakeNoPreviewSkill)
end

function var_0_5.onResetClick(arg_29_0)
	local var_29_0 = (arg_29_0.zawake:read() or {})[arg_29_0.zawakeID:read()] or {}

	for iter_29_0, iter_29_1 in pairs(var_29_0) do
		if iter_29_1 > 0 then
			gGameUI:stackUI("city.zawake.reset", nil, nil, arg_29_0.zawakeID:read())

			return
		end
	end

	gGameUI:showTip(gLanguageCsv.zawakeResetTips)
end

function var_0_5.onReplaceClick(arg_30_0)
	gGameUI:stackUI("city.zawake.replace", nil, nil, {
		zawakeID = arg_30_0.zawakeID
	})
end

function var_0_5.onRuleClick(arg_31_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_31_0:createHandler("getRuleContext"), {
		width = 1500
	})
end

function var_0_5.getRuleContext(arg_32_0, arg_32_1)
	local var_32_0 = adaptContext

	return {
		var_32_0.clone(arg_32_1.title, function(arg_33_0)
			arg_33_0:get("text"):text(gLanguageCsv.zawake)
		end),
		var_32_0.noteText(124001, 124051)
	}
end

function var_0_5.onClose(arg_34_0)
	local var_34_0 = arg_34_0.params.cb

	if var_34_0 and arg_34_0.params.zawakeID ~= arg_34_0.zawakeID:read() then
		local var_34_1 = var_0_0.getCardByZawakeID(arg_34_0.zawakeID:read())

		if var_34_1.dbId then
			var_34_0(var_34_1.dbId)
		end
	end

	gGameApp:requestServer("/game/card/zawake/quit")
	var_0_4.onClose(arg_34_0)
end

return var_0_5
