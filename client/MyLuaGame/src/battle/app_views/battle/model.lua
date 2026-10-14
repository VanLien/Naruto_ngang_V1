require("battle.models.include")

local var_0_0 = class("BattleModel")

function var_0_0.ctor(arg_1_0)
	arg_1_0.scene = nil
	arg_1_0.updateFrame = nil
	arg_1_0.updateDelta = nil
	arg_1_0.battleData = nil
	arg_1_0.battleSceneID = nil
	arg_1_0.modelEnable = true
	arg_1_0.modelPause = false
end

function var_0_0.init(arg_2_0)
	cow.battleModelInit()
end

function var_0_0.cleanUp(arg_3_0)
	arg_3_0.scene = nil
	arg_3_0.battleData = nil
	arg_3_0.battleSceneID = nil
	arg_3_0.updateFrame = nil
	arg_3_0.updateDelta = nil

	cow.battleModelDestroy()
end

function var_0_0.reset(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	arg_4_0:cleanUp()
	cow.battleModelInit()

	arg_4_0.scene = cow.proxyObject("scene", SceneModel.new())
	arg_4_0.updateDelta = 0
	arg_4_0.updateFrame = 0
	arg_4_0.modelPause = false
	arg_4_0.modelEnable = true
	arg_4_0.battleData = arg_4_1
	arg_4_0.battleSceneID = arg_4_2
	arg_4_0.battleIsRecord = arg_4_3
end

function var_0_0.onInitInUpdate(arg_5_0)
	local var_5_0 = arg_5_0.battleData
	local var_5_1 = arg_5_0.battleSceneID
	local var_5_2 = arg_5_0.battleIsRecord

	arg_5_0.battleData = nil
	arg_5_0.battleSceneID = nil
	arg_5_0.battleIsRecord = nil

	local var_5_3 = string.format("\n\n\t\tbattle %s start - seed=%s, scene=%s\n\n", var_5_2 and "record" or "", var_5_0.randSeed, var_5_1)

	printInfo(var_5_3)
	log.battle(var_5_3)
	ymrand.randomseed(var_5_0.randSeed)

	ymrand.randCount = 0

	arg_5_0.scene:init(var_5_1, var_5_0, var_5_2)
end

function var_0_0.update(arg_6_0, arg_6_1)
	if not arg_6_0.modelEnable or arg_6_0.modelPause then
		return
	end

	if arg_6_0.scene.isBattleAllEnd then
		return
	end

	arg_6_0.updateDelta = arg_6_0.updateDelta + arg_6_1
	arg_6_0.updateFrame = arg_6_0.updateFrame + 1

	if arg_6_0.updateFrame == 1 then
		arg_6_0:onInitInUpdate()
	end

	if arg_6_0.updateFrame <= 5 then
		return
	end

	local var_6_0 = game.FRAME_TICK

	if var_6_0 > arg_6_0.updateDelta then
		return
	end

	local var_6_1 = math.floor(arg_6_0.updateDelta / var_6_0)

	for iter_6_0 = 1, var_6_1 do
		if not arg_6_0.modelEnable or arg_6_0.modelPause then
			break
		end

		arg_6_0.scene:update(var_6_0)

		arg_6_0.updateDelta = arg_6_0.updateDelta - var_6_0
	end
end

function var_0_0.setModelEnable(arg_7_0, arg_7_1)
	arg_7_0.modelEnable = arg_7_1
end

function var_0_0.runUntilEnd(arg_8_0)
	arg_8_0.modelPause = false
	arg_8_0.modelEnable = true

	ViewProxy.allModelOnly()
	arg_8_0.scene:setAutoFight(true)

	while true do
		if arg_8_0.scene.isBattleAllEnd then
			break
		end

		arg_8_0:update(game.FRAME_TICK)
	end

	arg_8_0.modelEnable = false
end

function var_0_0.runUnitlNextWave(arg_9_0)
	arg_9_0.modelPause = false
	arg_9_0.modelEnable = true
	arg_9_0.updateDelta = 0

	ViewProxy.allModelOnly()

	local var_9_0 = arg_9_0.scene.autoFight

	arg_9_0.scene:setAutoFight(true)

	while true do
		if arg_9_0.scene.isBattleAllEnd then
			arg_9_0.modelEnable = false

			break
		end

		if arg_9_0.scene.play.isWaveEnd then
			arg_9_0.scene:setAutoFight(var_9_0)
			ViewProxy.allModelResum()

			break
		end

		arg_9_0:update(game.FRAME_TICK)
	end
end

local var_0_1 = {
	[battle.OperateTable.skill] = function(arg_10_0, arg_10_1)
		if arg_10_0.scene.gateType == game.GATE_TYPE.arena then
			return
		end

		local var_10_0 = arg_10_0.scene.heros:find(arg_10_1)

		if var_10_0 and var_10_0:isCanHandSkill() and not arg_10_0.scene.inMainSkill then
			var_10_0:handSkill()
		end
	end,
	[battle.OperateTable.attack] = function(arg_11_0, arg_11_1, arg_11_2)
		arg_11_0.scene.play:setAttack(arg_11_1, arg_11_2)
	end,
	[battle.OperateTable.noAttack] = function(arg_12_0)
		arg_12_0.scene:setNoAttackFlag()
	end,
	[battle.OperateTable.autoFight] = function(arg_13_0, arg_13_1)
		arg_13_0.scene:setAutoFight(arg_13_1)
	end,
	[battle.OperateTable.pass] = function(arg_14_0)
		arg_14_0:runUntilEnd()
	end,
	[battle.OperateTable.passOneWave] = function(arg_15_0)
		arg_15_0.scene.play:onPassOneWave(function()
			arg_15_0:runUnitlNextWave()
		end)
	end,
	[battle.OperateTable.fullManual] = function(arg_17_0)
		arg_17_0.scene:setFullManual(arg_17_0.battleData.moduleType == 2)
	end
}

function var_0_0.handleOperation(arg_18_0, arg_18_1, ...)
	if arg_18_0.scene == nil then
		return
	end

	local var_18_0 = var_0_1[arg_18_1]

	if var_18_0 then
		return var_18_0(arg_18_0, ...)
	end
end

return var_0_0
