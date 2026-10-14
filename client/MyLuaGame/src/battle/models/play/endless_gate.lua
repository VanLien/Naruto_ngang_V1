local var_0_0 = class("EndlessGate", battlePlay.Gate)

battlePlay.EndlessGate = var_0_0
var_0_0.OperatorArgs = {
	canHandle = true,
	isAuto = false,
	isFullManual = false,
	canSpeedAni = true,
	canPause = true,
	canSkip = true
}
var_0_0.CommonArgs = {
	AntiMode = battle.GateAntiMode.Operate
}

function var_0_0.ctor(arg_1_0, arg_1_1)
	battlePlay.Gate.ctor(arg_1_0, arg_1_1)
end

function var_0_0.createObjectModel(arg_2_0, arg_2_1, arg_2_2)
	return (arg_2_1 == 1 and ObjectModel or MonsterModel).new(arg_2_0.scene, arg_2_2)
end

function var_0_0.newWaveAddObjsStrategy(arg_3_0)
	if arg_3_0.curWave == 1 then
		arg_3_0:addCardRoles(1)
		arg_3_0:addCardRoles(2, 1, arg_3_0:getEnemyRoleOutT(1))
		arg_3_0:doObjsAttrsCorrect(true, true)
	else
		arg_3_0:addCardRoles(2, arg_3_0.curWave, arg_3_0:getEnemyRoleOutT(arg_3_0.curWave))
		arg_3_0:doObjsAttrsCorrect(false, true)
	end

	battlePlay.Gate.newWaveAddObjsStrategy(arg_3_0)
end

function var_0_0.makeEndViewInfos(arg_4_0)
	local var_4_0, var_4_1 = arg_4_0:whoHighestDamageFromStats(1)

	return {
		result = arg_4_0.result,
		gateIdx = arg_4_0.scene.sceneID - 100000,
		gateId = arg_4_0.scene.sceneID,
		mvpPosId = var_4_1,
		battleCards = arg_4_0.scene.data.battleCards
	}
end

function var_0_0.sendParams(arg_5_0)
	if arg_5_0.scene.sceneID > gGameModel.role:read("endless_tower_max_gate") and arg_5_0.result == "win" then
		return arg_5_0.scene.battleID, arg_5_0.scene.sceneID, arg_5_0.result, arg_5_0.curRound, battlePlay.Gate.sendActionParams(arg_5_0)
	end

	return arg_5_0.scene.battleID, arg_5_0.scene.sceneID, arg_5_0.result, arg_5_0.curRound
end

function var_0_0.postEndResultToServer(arg_6_0, arg_6_1)
	gRootViewProxy:raw():postEndResultToServer("/game/endless/battle/end", function(arg_7_0)
		arg_6_1(arg_6_0:makeEndViewInfos(), arg_7_0)
	end, arg_6_0:sendParams())
end

function var_0_0.onceBattle(arg_8_0, arg_8_1, arg_8_2)
	if arg_8_2 then
		table.set(arg_8_0.actionSend, arg_8_0.curRound, arg_8_0.curBattleRound, {
			arg_8_0.curHero.seat,
			arg_8_1,
			arg_8_2
		})
	end

	battlePlay.Gate.onceBattle(arg_8_0, arg_8_1, arg_8_2)
end

local var_0_1 = class("EndlessGateRecord", var_0_0)

battlePlay.EndlessGateRecord = var_0_1
var_0_1.OperatorArgs = {
	canHandle = false,
	isAuto = true,
	isFullManual = false,
	canSpeedAni = true,
	canPause = true,
	canSkip = true
}

function var_0_1.init(arg_9_0, arg_9_1)
	if not arg_9_1.actions and not arg_9_1.endlessAttrFix then
		arg_9_0.OperatorArgs = var_0_0.OperatorArgs
	end

	battlePlay.Gate.init(arg_9_0, arg_9_1)

	arg_9_0.actionRecv = arg_9_1.actions
	arg_9_0.endlessAttrFix = arg_9_1.endlessAttrFix
end

function var_0_1.getActionRecv(arg_10_0)
	local var_10_0 = table.get(arg_10_0.actionRecv, arg_10_0.curRound, arg_10_0.curBattleRound)

	if var_10_0 == nil then
		return
	end

	if var_10_0[1] == 0 then
		return
	end

	return unpack(var_10_0)
end

function var_0_1.sendParams(arg_11_0)
	return arg_11_0.scene.battleID, arg_11_0.scene.sceneID, arg_11_0.result, arg_11_0.curRound
end

function var_0_1.checkBattleEnd(arg_12_0)
	if arg_12_0.scene.isBattleAllEnd then
		return true, arg_12_0.result
	end

	return battlePlay.Gate.checkBattleEnd(arg_12_0)
end

function var_0_1.onceBattle(arg_13_0, arg_13_1, arg_13_2)
	if arg_13_0.endlessAttrFix then
		battlePlay.Gate.onceBattle(arg_13_0)

		return
	end

	local var_13_0, var_13_1, var_13_2 = arg_13_0:getActionRecv()

	if (var_13_0 or 0) ~= 0 and var_13_0 ~= arg_13_0.curHero.seat then
		printWarn("EndlessGateRecord战斗和战报不一致")

		arg_13_0.result = "fail"
		arg_13_0.scene.isBattleAllEnd = true

		arg_13_0:onOver()

		return
	end

	if (var_13_2 or 0) ~= 0 then
		arg_13_0.scene.autoFight = false

		battlePlay.Gate.onceBattle(arg_13_0, var_13_1, var_13_2)

		arg_13_0.scene.autoFight = true

		if arg_13_0.waitInput then
			error("why input be wait in record")
		end

		return
	end

	battlePlay.Gate.onceBattle(arg_13_0, arg_13_1, arg_13_2)
end
