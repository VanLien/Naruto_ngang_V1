require("battle.app_views.battle.stage")
require("battle.app_views.battle.module.include")
require("battle.views.sprite")
require("battle.views.sprite_possess")
require("battle.views.sprite_follower")
require("battle.views.event_effect.include")

local var_0_0 = 5
local var_0_1 = cc.load("mvc").ViewBase

globals.BattleView = class("BattleView", var_0_1)

local var_0_2 = require("battle.app_views.battle.model")
local var_0_3 = {}

var_0_3.RESOURCE_FILENAME = "battle.json"
var_0_3.RESOURCE_BINDING = {
	leftGroupPanel = "leftGroupPanel",
	rightGroupPanel = "rightGroupPanel",
	midPanel = "midPanel",
	topLeftPanel = "topLeftPanel",
	bottomLeftPanel = "bottomLeftPanel",
	bottomRightPanel = "bottomRightPanel",
	topRightPanel = "topRightPanel",
	["bottomLeftPanel.skip.text"] = {
		binds = {
			event = "effect",
			data = {
				color = cc.c4b(253, 224, 16, 255),
				glow = {
					color = cc.c4b(246, 194, 88, 255)
				}
			}
		}
	},
	["bottomLeftPanel.speedUp.speed"] = {
		binds = {
			event = "effect",
			data = {
				color = cc.c4b(253, 224, 16, 255),
				glow = {
					color = cc.c4b(246, 194, 88, 255)
				}
			}
		}
	},
	["midPanel.widgetPanel.wavePanel.wave"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(218, 114, 51, 255)
				}
			}
		}
	},
	["topLeftPanel.infoPVP.line"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(92, 84, 92, 255)
				}
			}
		}
	},
	["topRightPanel.infoPVP.line"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(92, 84, 92, 255)
				}
			}
		}
	}
}

local var_0_4 = {
	clickClose = true
}

function BattleView.onCreate(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0._model = nil
	arg_1_0._scene = nil
	arg_1_0._play = nil
	arg_1_0.modelWaitType = nil
	arg_1_0.stage = nil
	arg_1_0.stageLayer = nil
	arg_1_0.effectLayerLower = nil
	arg_1_0.gameLayer = nil
	arg_1_0.effectLayer = nil
	arg_1_0.effectLayerNum = nil
	arg_1_0.frontStageLayer = nil
	arg_1_0.weatherLayer = nil
	arg_1_0.layer = nil
	arg_1_0.sceneID = nil
	arg_1_0.isGuideScene = nil
	arg_1_0.gateType = nil
	arg_1_0.tick = 0
	arg_1_0.deathCache = {}
	arg_1_0.modes = arg_1_3 or clone(battle.DefaultModes)
	arg_1_0.timeScale = battle.SpeedTimeScale.single
	arg_1_0.ultAccEnable = false
	arg_1_0.inUltAcc = false
	arg_1_0.effectManager = cow.proxyObject("effectManager", battleEffect.Manager.new("BattleView"))
	arg_1_0.guideManager = require("battle.app_views.battle.guide").new(arg_1_0)
	arg_1_0.subModuleNotify = cow.proxyObject("subModuleNotify", battleModule.CNotify.new(arg_1_0))
	arg_1_0.effectDebug = {}
	arg_1_0.buffEffectsMap = {}
	arg_1_0.buffEffectsSelfMap = {}
	arg_1_0.buffEffectsEnemyMap = {}
	arg_1_0.buffEffectsRef = {}
	arg_1_0.buffEffectsSelfRef = {}
	arg_1_0.buffEffectsEnemyRef = {}
	arg_1_0.buffEffectsToHide = {}
	arg_1_0.deferListMap = CVector.new()
	arg_1_0.curDeferList = nil
	arg_1_0.filterMap = {}
	arg_1_0.effectJumpCache = {}
	arg_1_0.effectEventEnable = true

	arg_1_0:initBattle(arg_1_1, arg_1_2, arg_1_0.modes.isRecord)

	arg_1_0.modelPauseTimer = {}
	arg_1_0.onceEffectWaitCount = 0
	arg_1_0.entrance = arg_1_4
	arg_1_0.fpsSum = 0
	arg_1_0.fpsCount = 0
	arg_1_0.lastLowFPSCount = 0
	arg_1_0.fpsMax = userDefault.getForeverLocalKey("fps", 60, {
		rawKey = true
	})

	if arg_1_0.fpsMax > 30 then
		-- block empty
	end
end

function BattleView.onClose(arg_2_0)
	arg_2_0:cleanUp()

	arg_2_0._model = nil
	arg_2_0._scene = nil
	arg_2_0._play = nil

	battleComponents.clearAll()

	if arg_2_0.guideManager:isInGuiding() then
		arg_2_0.guideManager:onClose()
	end

	gGameUI:removeAllDelayTouchDispatch()
	cache.onBattleClear(arg_2_0.sceneID == 1)
	cache.texturePreload("common_ui")
	battleEntrance.unloadConfig()
	var_0_1.onClose(arg_2_0)
	display.director:resume()
	display.director:getScheduler():setTimeScale(1)

	local var_2_0 = userDefault.getForeverLocalKey("fps", 60, {
		rawKey = true
	})

	display.director:setAnimationInterval(1 / var_2_0)

	if display.director.isSpineThreadDrawEnabled then
		display.director:setSpineThreadDrawEnabled(false)
	end
end

function BattleView.cleanUp(arg_3_0)
	if arg_3_0._model then
		arg_3_0._model:cleanUp()
	end
end

function BattleView.reset(arg_4_0)
	arg_4_0:cleanUp()

	arg_4_0._model = var_0_2.new()
	arg_4_0._scene = nil
	arg_4_0._play = nil
	arg_4_0.tick = 0
end

function BattleView.initBattle(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_0:reset()

	arg_5_0.data = arg_5_1
	arg_5_0.sceneID = arg_5_2 or arg_5_1.sceneID
	arg_5_0.gateType = arg_5_1.gateType or csv.scene_conf[arg_5_2].gateType

	arg_5_0:add(arg_5_0:createLayerStage()):add(arg_5_0:createLayerBelowGameLayer()):add(arg_5_0:createLayerGame()):add(arg_5_0:createLayerUpGameLayer()):add(arg_5_0:createLayerEffect()):add(arg_5_0:createWeatherLayer()):add(arg_5_0:createUILayer()):add(arg_5_0:createEffectLayerNum()):add(arg_5_0:createFrontLayerStage()):add(arg_5_0:createDeleteObjLayer())
	arg_5_0.subModuleNotify:init()
	arg_5_0:showMainUI(false)

	arg_5_0.deferListMap = CVector.new()
	arg_5_0.curDeferList = nil

	arg_5_0:pushDeferList()
	arg_5_0:initStage()
	arg_5_0._model:reset(arg_5_1, arg_5_2, arg_5_3)
	arg_5_0:onViewProxyNotify("initBattle")

	arg_5_0.timeScale = battle.SpeedTimeScale.single

	display.director:resume()
	display.director:getScheduler():setTimeScale(arg_5_0.timeScale)

	if display.director.isSpineThreadDrawEnabled then
		display.director:setSpineThreadDrawEnabled(false)
	end

	collectgarbage("stop")
end

local var_0_5 = {
	[game.GATE_TYPE.test] = function(arg_6_0)
		return gMonsterCsv[arg_6_0.sceneID][1].bkCsv
	end,
	[game.GATE_TYPE.randomTower] = function(arg_7_0)
		local var_7_0 = arg_7_0.data.gamemodel_data and arg_7_0.data.gamemodel_data.room_info
		local var_7_1 = var_7_0 and var_7_0.enemy[var_7_0.board_id].id or 1001

		return csv.random_tower.monsters[var_7_1].backGround
	end,
	[game.GATE_TYPE.braveChallenge] = function(arg_8_0)
		return csv.brave_challenge.floor[arg_8_0.data.floorID].scene
	end,
	[game.GATE_TYPE.hunting] = function(arg_9_0)
		local var_9_0 = arg_9_0.data.gateID

		return csv.cross.hunting.gate[var_9_0].backGround
	end,
	[game.GATE_TYPE.summerChallenge] = function(arg_10_0)
		local var_10_0 = arg_10_0.data.gateID

		return csv.summer_challenge.gates[var_10_0].scene
	end
}

function BattleView.initStage(arg_11_0)
	local var_11_0 = var_0_5[arg_11_0.gateType] or var_0_5[game.GATE_TYPE.test]

	if arg_11_0.modes.fromRecordFile then
		var_11_0 = var_0_5[game.GATE_TYPE.test]
	end

	arg_11_0.stage = CStageModel.new(arg_11_0)

	arg_11_0.stage:init(var_11_0(arg_11_0))
end

function BattleView.createLayerStage(arg_12_0)
	local var_12_0 = cc.Layer:create()

	var_12_0:name("stageLayer")

	arg_12_0.stageLayer = var_12_0

	return var_12_0
end

function BattleView.createFrontLayerStage(arg_13_0)
	local var_13_0 = cc.Layer:create()

	var_13_0:name("frontStageLayer")

	arg_13_0.frontStageLayer = var_13_0

	return var_13_0
end

function BattleView.createDeleteObjLayer(arg_14_0)
	local var_14_0 = cc.Layer:create()

	var_14_0:name("deleteObjLayer"):setVisible(false)

	arg_14_0.deleteObjLayer = var_14_0

	return var_14_0
end

function BattleView.createLayerBelowGameLayer(arg_15_0)
	local var_15_0 = cc.Layer:create()

	var_15_0:name("effectLayerLower")

	arg_15_0.effectLayerLower = var_15_0

	return var_15_0
end

function BattleView.createLayerGame(arg_16_0)
	local var_16_0 = cc.Layer:create()

	var_16_0:name("gameLayer")
	var_16_0:setPosition(cc.p(0, display.fightLower))

	arg_16_0.gameLayer = var_16_0

	return var_16_0
end

function BattleView.createLayerUpGameLayer(arg_17_0)
	local var_17_0 = cc.Layer:create()

	var_17_0:name("effectLayerUpper")

	arg_17_0.effectLayerUpper = var_17_0

	return var_17_0
end

function BattleView.createLayerEffect(arg_18_0)
	local var_18_0 = cc.Layer:create()

	var_18_0:name("effectLayer")
	var_18_0:setPosition(cc.p(0, display.fightLower))

	arg_18_0.effectLayer = var_18_0

	return var_18_0
end

function BattleView.createWeatherLayer(arg_19_0)
	local var_19_0 = cc.Layer:create()

	var_19_0:name("weatherLayer")

	arg_19_0.weatherLayer = var_19_0

	return var_19_0
end

function BattleView.createEffectLayerNum(arg_20_0)
	local var_20_0 = cc.Layer:create()

	var_20_0:name("effectLayerNum")
	var_20_0:setPosition(cc.p(0, display.fightLower))

	arg_20_0.effectLayerNum = var_20_0

	return var_20_0
end

function BattleView.createUILayer(arg_21_0)
	arg_21_0.layer = cc.Layer:create()

	arg_21_0.layer:name("UILayer")

	arg_21_0.UIWidget = gGameUI:createSimpleView(var_0_3, arg_21_0.layer):init(arg_21_0)
	arg_21_0.UIWidgetLeft = arg_21_0.UIWidget.topLeftPanel
	arg_21_0.UIWidgetRight = arg_21_0.UIWidget.topRightPanel
	arg_21_0.UIWidgetMid = arg_21_0.UIWidget.midPanel
	arg_21_0.UIWidgetBottomLeft = arg_21_0.UIWidget.bottomLeftPanel
	arg_21_0.UIWidgetBottomRight = arg_21_0.UIWidget.bottomRightPanel
	arg_21_0.UIWidgetGroupLeft = arg_21_0.UIWidget.leftGroupPanel
	arg_21_0.UIWidgetGroupRight = arg_21_0.UIWidget.rightGroupPanel

	arg_21_0.UIWidgetMid:get("widgetPanel.speedRank"):setVisible(false)
	arg_21_0.UIWidgetBottomRight:setVisible(false)

	if arg_21_0:isPVEScene() then
		arg_21_0.UIWidgetLeft:get("infoPVP"):setVisible(false)
		arg_21_0.UIWidgetRight:get("infoPVP"):setVisible(false)
	elseif arg_21_0:isPVPScene() then
		arg_21_0.UIWidgetMid:get("widgetPanel.wavePanel"):setVisible(false)

		if arg_21_0:isSepcPVPScene() then
			arg_21_0.UIWidgetLeft:get("infoPVP"):setVisible(false)
			arg_21_0.UIWidgetRight:get("infoPVP"):setVisible(false)
		end
	end

	if arg_21_0.gateType == game.GATE_TYPE.dailyGold or arg_21_0.gateType == game.GATE_TYPE.dailyExp or arg_21_0:getGymDeployType() == game.DEPLOY_TYPE.OneByOneType then
		arg_21_0.UIWidgetMid:get("widgetPanel.wavePanel"):setVisible(false)
	end

	if arg_21_0.gateType ~= game.GATE_TYPE.crossArena and arg_21_0.gateType ~= game.GATE_TYPE.crossMine or arg_21_0:getGymDeployType() == game.DEPLOY_TYPE.WheelType then
		arg_21_0.UIWidgetGroupLeft:hide()
		arg_21_0.UIWidgetGroupRight:hide()
	end

	arg_21_0.objAttrPanel = gGameUI:createView("battle.attr_panel", arg_21_0.layer):init(arg_21_0)

	arg_21_0.objAttrPanel:hide():z(999)

	return arg_21_0.layer
end

function BattleView.showMainUI(arg_22_0, arg_22_1)
	arg_22_0.UIWidget:setVisible(arg_22_1)
end

function BattleView.clearDeleteObjLayer(arg_23_0)
	arg_23_0.deleteObjLayer:removeAllChildren()
end

function BattleView.showSpeedRank(arg_24_0, arg_24_1)
	arg_24_0.UIWidgetMid:get("widgetPanel.speedRank"):setVisible(arg_24_1)
end

local var_0_6 = {
	[game.GATE_TYPE.normal] = true,
	[game.GATE_TYPE.dailyGold] = true,
	[game.GATE_TYPE.dailyExp] = true,
	[game.GATE_TYPE.unionFuben] = true,
	[game.GATE_TYPE.endlessTower] = true,
	[game.GATE_TYPE.gift] = true,
	[game.GATE_TYPE.fragment] = true,
	[game.GATE_TYPE.simpleActivity] = true,
	[game.GATE_TYPE.friendFight] = true,
	[game.GATE_TYPE.randomTower] = true,
	[game.GATE_TYPE.clone] = true,
	[game.GATE_TYPE.worldBoss] = true,
	[game.GATE_TYPE.huoDongBoss] = true,
	[game.GATE_TYPE.gym] = true,
	[game.GATE_TYPE.crossMineBoss] = true,
	[game.GATE_TYPE.braveChallenge] = true,
	[game.GATE_TYPE.hunting] = true,
	[game.GATE_TYPE.summerChallenge] = true,
	[game.GATE_TYPE.mimicry] = true
}

function BattleView.isPVEScene(arg_25_0)
	return var_0_6[arg_25_0.gateType]
end

local var_0_7 = {
	[game.GATE_TYPE.dailyGold] = true,
	[game.GATE_TYPE.worldBoss] = true,
	[game.GATE_TYPE.unionFuben] = true,
	[game.GATE_TYPE.mimicry] = true
}

function BattleView.isBossScene(arg_26_0)
	return var_0_7[arg_26_0.gateType]
end

local var_0_8 = {
	[game.GATE_TYPE.newbie] = true,
	[game.GATE_TYPE.test] = true,
	[game.GATE_TYPE.arena] = true,
	[game.GATE_TYPE.crossArena] = true,
	[game.GATE_TYPE.unionFight] = true,
	[game.GATE_TYPE.crossUnionFight] = true,
	[game.GATE_TYPE.crossOnlineFight] = true,
	[game.GATE_TYPE.gymLeader] = true,
	[game.GATE_TYPE.crossGym] = true,
	[game.GATE_TYPE.crossMine] = true
}

function BattleView.isPVPScene(arg_27_0)
	return var_0_8[arg_27_0.gateType] or arg_27_0:isSepcPVPScene()
end

local var_0_9 = {
	[game.GATE_TYPE.craft] = true,
	[game.GATE_TYPE.crossCraft] = true
}

function BattleView.isSepcPVPScene(arg_28_0)
	if arg_28_0.gateType == game.GATE_TYPE.crossUnionFight then
		return arg_28_0.data.battleType == 3
	end

	return var_0_9[arg_28_0.gateType]
end

function BattleView.onModelWait(arg_29_0, arg_29_1)
	log.battle.battleView.wait(arg_29_1)

	arg_29_0.modelWaitType = arg_29_1

	arg_29_0._model:setModelEnable(false)

	arg_29_0.modelPauseTimer[1] = os.clock()
end

function BattleView.onModelResume(arg_30_0)
	arg_30_0.modelWaitType = nil

	arg_30_0._model:setModelEnable(true)

	arg_30_0.modelPauseTimer = {}
end

function BattleView.onCheckFPS(arg_31_0)
	local var_31_0 = 1 / display.director:getSecondsPerFrame()

	arg_31_0.fpsSum = arg_31_0.fpsSum + var_31_0
	arg_31_0.fpsCount = arg_31_0.fpsCount + 1

	if arg_31_0.fpsCount >= var_0_0 then
		local var_31_1 = arg_31_0.fpsSum / arg_31_0.fpsCount

		arg_31_0.fpsCount = 0
		arg_31_0.fpsSum = 0

		local var_31_2 = 60

		if var_31_1 < 30 and arg_31_0.lastLowFPSCount < 3 then
			var_31_2 = 40
			arg_31_0.lastLowFPSCount = arg_31_0.lastLowFPSCount + 1
		else
			arg_31_0.lastLowFPSCount = 0
		end

		display.director:setAnimationInterval(1 / math.min(var_31_2, arg_31_0.fpsMax))
	end
end

local var_0_10
local var_0_11
local var_0_12

function BattleView.onUpdate(arg_32_0, arg_32_1)
	if not arg_32_0.gameLayer then
		return
	end

	updateSaltNumber(arg_32_1)

	arg_32_1 = arg_32_1 * 1000

	if arg_32_0.modelWaitType then
		arg_32_0.modelPauseTimer[2] = os.clock()

		if arg_32_0.modelPauseTimer[2] - arg_32_0.modelPauseTimer[1] > 1000 and var_0_10 ~= arg_32_0.modelWaitType then
			var_0_10 = arg_32_0.modelWaitType

			printWarn("Model Disable Time too Long, modelWaitType:" .. arg_32_0.modelWaitType)
		end

		if arg_32_0.effectManager:queueSize() == 0 and arg_32_0.onceEffectWaitCount <= 0 then
			log.battle.battleView.resume(arg_32_0.modelWaitType)

			if arg_32_0.modelWaitType == "guiding" then
				arg_32_0.guideManager:update(arg_32_1)
			else
				arg_32_0:onModelResume()
			end
		elseif device.platform == "windows" and (var_0_11 ~= arg_32_0.effectManager.queHeadID or var_0_12 ~= arg_32_0.effectManager.queTailID) then
			lazylog.battle.battleView.wait(arg_32_0.modelWaitType, function()
				return dumps(arg_32_0.effectManager:queueInfo())
			end)

			var_0_11 = arg_32_0.effectManager.queHeadID
			var_0_12 = arg_32_0.effectManager.queTailID
		end
	end

	arg_32_0.tick = arg_32_0.tick + arg_32_1

	cache.onBattleUpdate(arg_32_1)
	arg_32_0.effectManager:update(arg_32_1)
	arg_32_0:onViewProxyNotify("update", arg_32_1)
	arg_32_0._model:update(arg_32_1)
	arg_32_0:onViewProxyNotify("updateOver", arg_32_1)
	collectgarbage("step", 10)
end

function BattleView.getSceneModel(arg_34_0)
	if not arg_34_0._scene then
		arg_34_0._scene = readOnlyProxy(arg_34_0._model.scene)
	end

	return arg_34_0._scene
end

function BattleView.getPlayModel(arg_35_0)
	if not arg_35_0._play then
		arg_35_0._play = readOnlyProxy(arg_35_0._model.scene.play)
	end

	return arg_35_0._play
end

local var_0_13 = {
	[battle.OperateTable.timeScale] = function(arg_36_0, arg_36_1)
		arg_36_0.timeScale = battle.SpeedTimeScale[arg_36_1]

		display.director:getScheduler():setTimeScale(arg_36_0.timeScale)
	end,
	[battle.OperateTable.ultAcc] = function(arg_37_0)
		arg_37_0.inUltAcc = true

		display.director:getScheduler():setTimeScale(battle.SpeedTimeScale.ultAcc)
	end,
	[battle.OperateTable.ultAccEnd] = function(arg_38_0)
		arg_38_0.inUltAcc = false

		display.director:getScheduler():setTimeScale(arg_38_0.timeScale)
	end,
	[battle.OperateTable.pass] = function(arg_39_0, ...)
		arg_39_0:stopAllActions()
		arg_39_0:disableUpdate()

		return arg_39_0._model:handleOperation(battle.OperateTable.pass, ...)
	end
}

function BattleView.handleOperation(arg_40_0, arg_40_1, ...)
	local var_40_0 = var_0_13[arg_40_1]

	if var_40_0 then
		return var_40_0(arg_40_0, ...)
	else
		return arg_40_0._model:handleOperation(arg_40_1, ...)
	end
end

function BattleView.setGuideData(arg_41_0, arg_41_1)
	arg_41_0.guideManager:setData(arg_41_1)
end

function BattleView.setGuideClickCall(arg_42_0, arg_42_1)
	arg_42_0.guideManager:setChoicesFunc(arg_42_1)
end

function BattleView.bulletTimeShow(arg_43_0)
	battleEasy.queueEffect("delay", {
		lifetime = 200
	})
	gRootViewProxy:notify("fightOver")
	battleEasy.queueEffect("delay", {
		lifetime = 200
	})
	display.director:getScheduler():setTimeScale(battle.SpeedTimeScale.single * 0.25)
	performWithDelay(arg_43_0, function()
		display.director:getScheduler():setTimeScale(1)
	end, 0.25)
end

function BattleView._onShowArenaEndView(arg_45_0, arg_45_1)
	if arg_45_0.modes.noShowEndRewards or arg_45_0.modes.isRecord then
		if arg_45_1.result == "win" and not arg_45_0.modes.isRecord then
			gGameUI:stackUI("battle.battle_end.pvp_win", nil, var_0_4, arg_45_0.sceneID, arg_45_0.data, arg_45_1):z(999)
		else
			gGameUI:stackUI("battle.battle_end.pvp_fail", nil, var_0_4, arg_45_0.sceneID, arg_45_0.data, arg_45_1):z(999):initModes(arg_45_0.modes)
		end
	else
		arg_45_0.modes.noShowEndRewards = true

		gGameUI:stackUI("battle.battle_end.pvp_reward", {
			showEndView = arg_45_0:createHandler("_onShowArenaEndView", arg_45_1, true)
		}, var_0_4, arg_45_1):z(999)
	end
end

function BattleView._onShowCrossArenaEndView(arg_46_0, arg_46_1)
	arg_46_1.flag = "crossArena"

	if arg_46_1.serverData == nil then
		gGameUI:stackUI("battle.battle_end.pvp_fail", nil, var_0_4, arg_46_0.sceneID, arg_46_0.data, arg_46_1):z(999):initModes(arg_46_0.modes)

		return
	end

	local var_46_0 = arg_46_1.result == "win"
	local var_46_1 = arg_46_1.serverData.view
	local var_46_2 = var_46_1.rank
	local var_46_3 = var_46_2 + var_46_1.rank_move
	local var_46_4 = dataEasy.getCrossArenaStageByRank(var_46_3)
	local var_46_5 = dataEasy.getCrossArenaStageByRank(var_46_2)
	local var_46_6 = gGameModel.cross_arena:read("csvID")
	local var_46_7 = csv.cross.service[var_46_6].version

	if var_46_0 and not arg_46_0.modes.isRecord then
		if not arg_46_0.modes.nextShowStageUp then
			if var_46_5.stageName == var_46_4.stageName then
				gGameUI:stackUI("battle.battle_end.pvp_win", nil, var_0_4, arg_46_0.sceneID, arg_46_0.data, arg_46_1):z(999)

				arg_46_1.backCity = true
			else
				gGameUI:stackUI("battle.battle_end.pvp_win", {
					showEndView = arg_46_0:createHandler("_onShowCrossArenaEndView", arg_46_1, true)
				}, var_0_4, arg_46_0.sceneID, arg_46_0.data, arg_46_1):z(999)

				arg_46_0.modes.nextShowStageUp = true
			end
		else
			gGameUI:stackUI("battle.battle_end.pvp_stage_up", nil, var_0_4, arg_46_0.sceneID, arg_46_0.data, arg_46_1):z(999)
		end
	else
		gGameUI:stackUI("battle.battle_end.pvp_fail", nil, var_0_4, arg_46_0.sceneID, arg_46_0.data, arg_46_1):z(999):initModes(arg_46_0.modes)
	end
end

function BattleView._onShowGymLeaderEndView(arg_47_0, arg_47_1)
	if arg_47_0.modes.isRecord then
		gGameUI:switchUI("city.view")

		return
	end

	arg_47_1.flag = "gymLeader"
	arg_47_1.gymName = csv.gym.gym[gGameModel.battle.gym_id].name

	if arg_47_1.result == "win" then
		gGameUI:stackUI("battle.battle_end.pvp_win", nil, var_0_4, arg_47_0.sceneID, arg_47_0.data, arg_47_1):z(999)
	else
		gGameUI:stackUI("battle.battle_end.pvp_fail", nil, var_0_4, arg_47_0.sceneID, arg_47_0.data, arg_47_1):z(999):initModes(arg_47_0.modes)
	end
end

local var_0_14 = {
	[game.GATE_TYPE.newbie] = function(arg_48_0, arg_48_1)
		gGameUI:switchUI("new_character.view")
	end,
	[game.GATE_TYPE.test] = function(arg_49_0, arg_49_1)
		gGameUI:switchUI("city.view")
	end,
	[game.GATE_TYPE.normal] = function(arg_50_0, arg_50_1)
		if arg_50_1.result == "win" then
			gGameUI:stackUI("battle.battle_end.win", nil, var_0_4, arg_50_0, arg_50_1):z(999)
			arg_50_0:showCaptureTips(arg_50_1.oldCapture)
		else
			arg_50_0:jumpToPveFailView(arg_50_0.data, arg_50_1, 1)
		end
	end,
	[game.GATE_TYPE.arena] = function(arg_51_0, arg_51_1)
		return arg_51_0:_onShowArenaEndView(arg_51_1)
	end,
	[game.GATE_TYPE.crossArena] = function(arg_52_0, arg_52_1)
		return arg_52_0:_onShowCrossArenaEndView(arg_52_1)
	end,
	[game.GATE_TYPE.friendFight] = function(arg_53_0, arg_53_1)
		gGameUI:stackUI("battle.battle_end.pvp_fail", nil, var_0_4, arg_53_0.sceneID, arg_53_0.data, arg_53_1):z(999):initModes(arg_53_0.modes)
	end,
	[game.GATE_TYPE.randomTower] = function(arg_54_0, arg_54_1)
		if arg_54_1.result == "win" then
			gGameUI:stackUI("battle.battle_end.random_win", nil, var_0_4, arg_54_0, arg_54_1):z(999)
		else
			arg_54_0:jumpToPveFailView(arg_54_0.data, arg_54_1, 3)
		end
	end,
	[game.GATE_TYPE.dailyGold] = function(arg_55_0, arg_55_1)
		gGameUI:stackUI("battle.battle_end.daily_activity", nil, var_0_4, arg_55_0.sceneID, arg_55_1, arg_55_0.data):z(999)
	end,
	[game.GATE_TYPE.endlessTower] = function(arg_56_0, arg_56_1)
		if arg_56_0.modes.noShowEndRewards or arg_56_0.modes.isRecord then
			gGameUI:switchUI("city.view")
		elseif arg_56_1.result == "win" then
			gGameUI:stackUI("battle.battle_end.endless_win", nil, var_0_4, arg_56_0.sceneID, arg_56_0.data, arg_56_1):z(999)
		else
			gGameUI:stackUI("battle.battle_end.endless_fail", nil, var_0_4, arg_56_0, arg_56_0.data, arg_56_1, 1):z(999)
		end
	end,
	[game.GATE_TYPE.unionFuben] = function(arg_57_0, arg_57_1)
		gGameUI:stackUI("battle.battle_end.daily_activity", nil, var_0_4, arg_57_0.sceneID, arg_57_1, arg_57_0.data):z(999)
	end,
	[game.GATE_TYPE.gift] = function(arg_58_0, arg_58_1)
		if arg_58_1.result == "win" then
			gGameUI:stackUI("battle.battle_end.simple_activity_win", nil, var_0_4, arg_58_0.sceneID, arg_58_0.data, arg_58_1):z(999)
		else
			arg_58_0:jumpToPveFailView(arg_58_0.data, arg_58_1, 3)
		end
	end,
	[game.GATE_TYPE.clone] = function(arg_59_0, arg_59_1)
		if arg_59_1.result == "win" then
			gGameUI:stackUI("battle.battle_end.clone_win", nil, nil, arg_59_0.sceneID, arg_59_0.data, arg_59_1):z(999)
		else
			arg_59_0:jumpToPveFailView(arg_59_0.data, arg_59_1, 3)
		end
	end,
	[game.GATE_TYPE.worldBoss] = function(arg_60_0, arg_60_1)
		gGameUI:stackUI("battle.battle_end.world_boss_win", nil, var_0_4, arg_60_0.sceneID, arg_60_0.data, arg_60_1):z(999)
	end,
	[game.GATE_TYPE.crossOnlineFight] = function(arg_61_0, arg_61_1)
		if arg_61_1.showReward then
			gGameUI:stackUI("battle.battle_end.reward", nil, var_0_4, arg_61_0:createHandler("_onShowRewardEndView", arg_61_1), arg_61_1):z(999)

			return
		end

		if arg_61_1.result == "win" then
			if arg_61_1.showMvpView then
				gGameUI:stackUI("battle.battle_end.pvp_win", nil, var_0_4, arg_61_0.sceneID, arg_61_0.data, arg_61_1):z(999)
			else
				gGameUI:stackUI("battle.battle_end.jf", nil, var_0_4, arg_61_0.sceneID, arg_61_0.data, arg_61_1):z(999)
			end
		else
			gGameUI:stackUI("battle.battle_end.jf", nil, var_0_4, arg_61_0.sceneID, arg_61_0.data, arg_61_1):z(999)
		end
	end,
	[game.GATE_TYPE.gym] = function(arg_62_0, arg_62_1)
		if gGameModel.battle.gym_id and csv.gym.gate[gGameModel.battle.gate_id].npc then
			arg_62_0.data.actions = arg_62_1.actions

			return arg_62_0:_onShowGymLeaderEndView(arg_62_1)
		end

		if arg_62_1.result == "win" then
			arg_62_1.flag = "gym"

			gGameUI:stackUI("battle.battle_end.simple_activity_win", nil, var_0_4, arg_62_0.sceneID, arg_62_0.data, arg_62_1):z(999)
		else
			arg_62_0:jumpToPveFailView(arg_62_0.data, arg_62_1, 3)
		end
	end,
	[game.GATE_TYPE.gymLeader] = function(arg_63_0, arg_63_1)
		return arg_63_0:_onShowGymLeaderEndView(arg_63_1)
	end,
	[game.GATE_TYPE.crossGym] = function(arg_64_0, arg_64_1)
		local var_64_0 = gGameModel.gym:getIdler("crossGymRoles"):read()
		local var_64_1 = var_64_0 and var_64_0[gGameModel.battle.gym_id][1]

		if not var_64_1 or var_64_1.record_id ~= gGameModel.battle.defence_record_id then
			arg_64_1.gymMember = true
		end

		return arg_64_0:_onShowGymLeaderEndView(arg_64_1)
	end,
	[game.GATE_TYPE.crossMine] = function(arg_65_0, arg_65_1)
		arg_65_1.flag = "crossMine"

		if arg_65_1.result == "win" then
			if arg_65_0.modes.isRecord then
				gGameUI:stackUI("battle.battle_end.pvp_fail", nil, var_0_4, arg_65_0.sceneID, arg_65_0.data, arg_65_1):z(999):initModes(arg_65_0.modes)
			else
				gGameUI:stackUI("battle.battle_end.pvp_win", nil, var_0_4, arg_65_0.sceneID, arg_65_0.data, arg_65_1):z(999)
			end
		else
			gGameUI:stackUI("battle.battle_end.pvp_fail", nil, var_0_4, arg_65_0.sceneID, arg_65_0.data, arg_65_1):z(999):initModes(arg_65_0.modes)
		end
	end,
	[game.GATE_TYPE.crossMineBoss] = function(arg_66_0, arg_66_1)
		gGameUI:stackUI("battle.battle_end.daily_activity", nil, var_0_4, arg_66_0.sceneID, arg_66_1):z(999)
	end,
	[game.GATE_TYPE.braveChallenge] = function(arg_67_0, arg_67_1)
		if arg_67_1.result == "win" then
			gGameUI:stackUI("battle.battle_end.brave_challenge_win", nil, var_0_4, arg_67_0.sceneID, arg_67_0.data, arg_67_1):z(999)
		else
			arg_67_0:jumpToPveFailView(arg_67_0.data, arg_67_1, 3)
		end
	end,
	[game.GATE_TYPE.summerChallenge] = function(arg_68_0, arg_68_1)
		if arg_68_1.result == "win" then
			gGameUI:stackUI("battle.battle_end.activity_challenge_win", nil, var_0_4, arg_68_0.sceneID, arg_68_0.data, arg_68_1):z(999)
		else
			gGameUI:stackUI("battle.battle_end.pvp_fail", nil, var_0_4, arg_68_0.sceneID, arg_68_0.data, arg_68_1):z(999):initModes(arg_68_0.modes)
		end
	end,
	[game.GATE_TYPE.hunting] = function(arg_69_0, arg_69_1)
		if arg_69_1.result == "win" then
			gGameUI:stackUI("battle.battle_end.hunting_win", nil, var_0_4, arg_69_0, arg_69_0.sceneID, arg_69_0.data, arg_69_1):z(999)
		else
			arg_69_0:jumpToPveFailView(arg_69_0.data, arg_69_1, 3)
		end
	end,
	[game.GATE_TYPE.mimicry] = function(arg_70_0, arg_70_1)
		gGameUI:stackUI("battle.battle_end.mimicry_win", nil, var_0_4, arg_70_0.sceneID, arg_70_1):z(999)
	end
}

var_0_14[game.GATE_TYPE.dailyExp] = var_0_14[game.GATE_TYPE.dailyGold]
var_0_14[game.GATE_TYPE.fragment] = var_0_14[game.GATE_TYPE.gift]
var_0_14[game.GATE_TYPE.simpleActivity] = var_0_14[game.GATE_TYPE.gift]
var_0_14[game.GATE_TYPE.huoDongBoss] = var_0_14[game.GATE_TYPE.gift]

local var_0_15 = {
	backToView = function()
		gGameUI:switchUI("city.view")
	end
}

function BattleView._onShowRewardEndView(arg_72_0, arg_72_1)
	arg_72_1.showReward = false

	var_0_14[arg_72_0.gateType](arg_72_0, arg_72_1)
end

function BattleView.postEndResultToServer(arg_73_0, arg_73_1, arg_73_2, ...)
	checkGGCheat()

	if type(arg_73_2) == "function" then
		local var_73_0 = arg_73_2

		return gGameApp:requestServer(arg_73_1, function(arg_74_0)
			var_73_0(arg_74_0)
		end, ...)
	end

	local var_73_1 = gGameApp:requestServerCustom(arg_73_1):params(...)
	local var_73_2 = arg_73_2.cb

	arg_73_2.cb = nil
	arg_73_2.onErrClose = arg_73_2.onErrClose or var_0_15.backToView

	for iter_73_0, iter_73_1 in pairs(arg_73_2) do
		var_73_1[iter_73_0](var_73_1, iter_73_1)
	end

	return var_73_1:doit(var_73_2)
end

function BattleView.showEndView(arg_75_0, arg_75_1)
	display.director:getScheduler():setTimeScale(1)
	audio.stopMusic()
	arg_75_0:showMainUI(false)
	arg_75_0.gameLayer:setVisible(false)
	arg_75_0.effectLayer:setVisible(false)
	arg_75_0:onViewProxyNotify("showSpec", false)
	arg_75_0:disableUpdate()
	performWithDelay(arg_75_0, function()
		if var_0_14[arg_75_0.gateType] and not arg_75_0.modes.fromRecordFile then
			var_0_14[arg_75_0.gateType](arg_75_0, arg_75_1)
		else
			var_0_14[game.GATE_TYPE.test](arg_75_0, arg_75_1)
		end
	end, 0.5)
end

function BattleView.showCaptureTips(arg_77_0, arg_77_1)
	if not dataEasy.isUnlock(gUnlockCsv.limitCapture) then
		return
	end

	local var_77_0 = gGameModel.capture:read("limit_sprites")

	for iter_77_0, iter_77_1 in pairs(var_77_0) do
		if not itertools.equal(iter_77_1, arg_77_1[iter_77_0]) then
			gGameUI:stackUI("common.capture_tips")

			break
		end
	end
end

function BattleView.newbieEndPlayAni(arg_78_0)
	display.director:getScheduler():setTimeScale(1)
	arg_78_0:showMainUI(false)

	local function var_78_0(arg_79_0, arg_79_1, arg_79_2)
		return widget.addAnimationByKey(arg_78_0.frontStageLayer, arg_79_0, "effect" .. arg_79_2, arg_79_1, arg_79_2):xy(display.center):scale(2)
	end
end

function BattleView.getEffectEventEnable(arg_80_0)
	return arg_80_0.effectEventEnable
end

function BattleView.closeEffectEventEnable(arg_81_0)
	arg_81_0.effectEventEnable = false

	return arg_81_0.effectEventEnable
end

function BattleView.resetEffectEventEnable(arg_82_0)
	arg_82_0.effectEventEnable = true

	return arg_82_0.effectEventEnable
end

function BattleView.hasGuide(arg_83_0)
	if arg_83_0.isGuideScene ~= nil then
		return arg_83_0.isGuideScene
	end

	local var_83_0 = gMonsterCsv[arg_83_0.sceneID][1]

	arg_83_0.isGuideScene = battleEasy.ifElse(var_83_0.storys, true, false)

	return arg_83_0.isGuideScene
end

function BattleView.getGymDeployType(arg_84_0)
	if arg_84_0.gymDeployType then
		return arg_84_0.gymDeployType
	end

	arg_84_0.gymDeployType = -1

	if arg_84_0.gateType == game.GATE_TYPE.gym then
		local var_84_0 = csv.gym.gate[arg_84_0.sceneID]

		arg_84_0.gymDeployType = var_84_0 and var_84_0.deployType
	end

	return arg_84_0.gymDeployType
end

function BattleView.jumpToPveFailView(arg_85_0, arg_85_1, arg_85_2, arg_85_3)
	gGameUI:stackUI("battle.battle_end.pve_fail", nil, var_0_4, arg_85_0, arg_85_1, arg_85_2, arg_85_3):z(999)
end

function BattleView.getAssignLayer(arg_86_0, arg_86_1)
	return ({
		[battle.AssignLayer.stageLayer] = arg_86_0.stageLayer,
		[battle.AssignLayer.gameLayer] = arg_86_0.gameLayer,
		[battle.AssignLayer.effectLayerLower] = arg_86_0.effectLayerLower,
		[battle.AssignLayer.effectLayer] = arg_86_0.effectLayer,
		[battle.AssignLayer.frontStageLayer] = arg_86_0.frontStageLayer
	})[arg_86_1]
end

function BattleView.onPassOneWaveClean(arg_87_0)
	arg_87_0:flushAllDeferList()

	for iter_87_0, iter_87_1 in ipairs(arg_87_0.effectJumpCache) do
		arg_87_0:onEventEffectCancel(iter_87_1)
	end

	arg_87_0.effectJumpCache = {}

	arg_87_0.effectManager:passOneWaveClear()
end

function BattleView.forceClearBuffEffects(arg_88_0)
	local var_88_0 = {
		arg_88_0.buffEffectsSelfMap,
		arg_88_0.buffEffectsEnemyMap,
		arg_88_0.buffEffectsMap
	}

	for iter_88_0, iter_88_1 in ipairs(var_88_0) do
		for iter_88_2, iter_88_3 in pairs(iter_88_1) do
			iter_88_3.buffUseSameResCount = 0

			removeCSprite(iter_88_3)
		end

		iter_88_1 = {}
	end

	arg_88_0.buffEffectsRef = {}
	arg_88_0.buffEffectsSelfRef = {}
	arg_88_0.buffEffectsEnemyRef = {}
end

require("battle.app_views.battle.view_effect")
require("battle.app_views.battle.view_proxy")

return BattleView
