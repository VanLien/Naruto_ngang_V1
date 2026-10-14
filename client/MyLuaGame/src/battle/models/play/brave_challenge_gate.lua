local var_0_0 = class("BraveChallengeGate", battlePlay.Gate)

battlePlay.BraveChallengeGate = var_0_0
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
var_0_0.SpecEndRuleCheck = {
	battle.EndSpecialCheck.DirectWin
}

local function var_0_1(arg_1_0)
	return arg_1_0.dbID
end

function var_0_0.init(arg_2_0, arg_2_1)
	arg_2_0:initStarConditions()
	battlePlay.Gate.init(arg_2_0, arg_2_1)
end

function var_0_0.makeEndViewInfos(arg_3_0, arg_3_1)
	local var_3_0 = battlePlay.Gate.makeEndViewInfos(arg_3_0, arg_3_1)

	var_3_0.round = arg_3_0.curRound

	return var_3_0
end

function var_0_0.sendParams(arg_4_0)
	local var_4_0 = arg_4_0:getForceState(1)
	local var_4_1 = arg_4_0:getForceState(2)
	local var_4_2 = arg_4_0.scene.extraRecord:getEvent(battle.ExRecordEvent.campDamage)
	local var_4_3 = var_4_2 and var_4_2[1]

	return arg_4_0.scene.battleID, arg_4_0.data.floorID, arg_4_0.result, var_4_0, var_4_1, arg_4_0.curRound, var_4_3, battlePlay.Gate.sendActionParams(arg_4_0)
end

function var_0_0.newWaveAddObjsStrategy(arg_5_0)
	local var_5_0 = arg_5_0.data.roleOut

	arg_5_0:addCardRoles(1, nil, var_5_0)
	arg_5_0:addCardRoles(2)
	arg_5_0:doObjsAttrsCorrect(true, true)
	battlePlay.Gate.newWaveAddObjsStrategy(arg_5_0)
	arg_5_0:setCardStates()
end

function var_0_0.setCardStates(arg_6_0)
	local var_6_0 = {
		{},
		{}
	}
	local var_6_1 = arg_6_0.data.gamemodel_data or {}

	local function var_6_2(arg_7_0, arg_7_1, arg_7_2)
		local var_7_0 = var_6_1[arg_7_0] or {}

		for iter_7_0, iter_7_1 in arg_7_1:pairs() do
			if arg_6_0:checkObjCanToServer(iter_7_1) then
				local var_7_1 = var_0_1(iter_7_1)
				local var_7_2 = var_7_0[tonumber(var_7_1)] or var_7_0[tostring(var_7_1)]

				if var_7_2 then
					local var_7_3 = iter_7_1:hpMax()
					local var_7_4 = iter_7_1:mp1Max()

					iter_7_1:setHP(var_7_3 * var_7_2[1])
					iter_7_1:setMP1(var_7_4 * var_7_2[2])
				end

				arg_7_2[var_7_1] = {
					0,
					0
				}
			end
		end
	end

	var_6_2("monsters", arg_6_0.scene:getHerosMap(2), var_6_0[2])
	var_6_2("cards", arg_6_0.scene:getHerosMap(1), var_6_0[1])

	arg_6_0.gateStates = var_6_0
end

function var_0_0.getForceState(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.scene:getHerosMap(arg_8_1)
	local var_8_1 = arg_8_0.gateStates[arg_8_1]

	for iter_8_0, iter_8_1 in var_8_0:pairs() do
		if arg_8_0:checkObjCanToServer(iter_8_1) then
			var_8_1[var_0_1(iter_8_1)] = {
				iter_8_1:hp() / iter_8_1:hpMax(),
				iter_8_1:mp1() / iter_8_1:mp1Max()
			}
		end
	end

	return var_8_1
end

function var_0_0.needExtraRound(arg_9_0)
	if arg_9_0.curRound > arg_9_0.roundLimit then
		return false
	end

	for iter_9_0, iter_9_1 in arg_9_0.scene:ipairsHeros() do
		if iter_9_1:isFakeDeath() then
			return true
		end
	end

	return false
end

function var_0_0.checkBattleEnd(arg_10_0)
	if arg_10_0:checkBothAllRealDead() then
		return true, "win"
	end

	if arg_10_0:needExtraRound() then
		return false
	end

	return battlePlay.Gate.checkBattleEnd(arg_10_0)
end

function var_0_0.postEndResultToServer(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0:makeEndViewInfos({
		gateStar = true
	})

	gRootViewProxy:raw():postEndResultToServer(arg_11_0.data.battleEndUrl, function(arg_12_0)
		arg_11_1(var_11_0, arg_12_0)
	end, arg_11_0:sendParams())
end

local var_0_2 = class("BraveChallengeGateRecord", var_0_0)

battlePlay.BraveChallengeGateRecord = var_0_2
var_0_2.OperatorArgs = {
	canSkipInstant = true,
	isAuto = true,
	isFullManual = false,
	canSpeedAni = true,
	canHandle = false,
	canPause = true,
	canSkip = true
}
