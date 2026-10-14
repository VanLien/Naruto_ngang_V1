local var_0_0 = class("HuntingGate", battlePlay.Gate)

battlePlay.HuntingGate = var_0_0
var_0_0.OperatorArgs = {
	canHandle = true,
	isAuto = false,
	isFullManual = false,
	canSpeedAni = true,
	canPause = true,
	canSkip = true
}
var_0_0.SpecEndRuleCheck = {
	battle.EndSpecialCheck.EnemyOnlySummonOrAllDead
}

local function var_0_1(arg_1_0)
	return arg_1_0.dbID
end

function var_0_0.newWaveAddObjsStrategy(arg_2_0)
	local var_2_0 = (arg_2_0.data.gamemodel_data and arg_2_0.data.gamemodel_data.route_info or {}).buffs
	local var_2_1 = arg_2_0.data.roleOut
	local var_2_2 = {}

	for iter_2_0, iter_2_1 in pairs(var_2_0) do
		var_2_2[csv.cross.hunting.buffs[iter_2_1].skillID] = 1
	end

	for iter_2_2 = 1, 6 do
		local var_2_3 = var_2_1[iter_2_2]

		if var_2_3 then
			var_2_3.passive_skills = var_2_3.passive_skills or {}

			for iter_2_3, iter_2_4 in pairs(var_2_2) do
				var_2_3.passive_skills[iter_2_3] = iter_2_4
			end
		end
	end

	arg_2_0:addCardRoles(1, nil, var_2_1)
	arg_2_0:addCardRoles(2)
	arg_2_0:doObjsAttrsCorrect(true, true)
	battlePlay.Gate.newWaveAddObjsStrategy(arg_2_0)
	arg_2_0:setCardStates()
end

function var_0_0.setCardStates(arg_3_0)
	local var_3_0 = {
		{},
		{}
	}
	local var_3_1 = arg_3_0.data.gamemodel_data and arg_3_0.data.gamemodel_data.route_info or {}

	local function var_3_2(arg_4_0, arg_4_1, arg_4_2)
		local var_4_0 = var_3_1[arg_4_0] or {}

		for iter_4_0, iter_4_1 in arg_4_1:pairs() do
			if arg_3_0:checkObjCanToServer(iter_4_1) then
				local var_4_1 = var_0_1(iter_4_1)
				local var_4_2 = var_4_0[tonumber(var_4_1)] or var_4_0[tostring(var_4_1)]

				if var_4_2 then
					local var_4_3 = iter_4_1:hpMax()
					local var_4_4 = iter_4_1:mp1Max()

					iter_4_1:setHP(var_4_3 * var_4_2[1])
					iter_4_1:setMP1(var_4_4 * var_4_2[2])
				end

				arg_4_2[var_4_1] = {
					0,
					0
				}
			end
		end
	end

	var_3_2("enemy_states", arg_3_0.scene:getHerosMap(2), var_3_0[2])
	var_3_2("card_states", arg_3_0.scene:getHerosMap(1), var_3_0[1])

	arg_3_0.gateStates = var_3_0
end

function var_0_0.getForceState(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.scene:getHerosMap(arg_5_1)
	local var_5_1 = arg_5_0.gateStates[arg_5_1]

	for iter_5_0, iter_5_1 in var_5_0:pairs() do
		if arg_5_0:checkObjCanToServer(iter_5_1) then
			var_5_1[var_0_1(iter_5_1)] = {
				iter_5_1:hp() / iter_5_1:hpMax(),
				iter_5_1:mp1() / iter_5_1:mp1Max()
			}
		end
	end

	return var_5_1
end

function var_0_0.needExtraRound(arg_6_0)
	if arg_6_0.curRound > arg_6_0.roundLimit then
		return false
	end

	for iter_6_0, iter_6_1 in arg_6_0.scene:ipairsHeros() do
		if iter_6_1:isFakeDeath() then
			return true
		end
	end

	return false
end

function var_0_0.checkBattleEnd(arg_7_0)
	if arg_7_0:checkBothAllRealDead() then
		return true, "win"
	end

	if arg_7_0:needExtraRound() then
		return false
	end

	return battlePlay.Gate.checkBattleEnd(arg_7_0)
end

function var_0_0.postEndResultToServer(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0:getForceState(1)
	local var_8_1 = arg_8_0:getForceState(2)
	local var_8_2 = arg_8_0:makeEndViewInfos({
		gateStar = true
	})
	local var_8_3 = arg_8_0.scene.extraRecord:getEvent(battle.ExRecordEvent.campDamage)
	local var_8_4 = var_8_3 and var_8_3[1]

	gRootViewProxy:raw():postEndResultToServer("/game/hunting/battle/end", function(arg_9_0)
		local var_9_0 = arg_9_0.view or {}

		if next(var_9_0) then
			var_8_2.cardStates = var_8_0
			var_8_2.enemyStates = var_8_1

			arg_8_1(var_8_2, var_9_0)
		else
			gGameUI:cleanStash()
			gGameUI:switchUI("city.view")
			gGameUI:showTip(gLanguageCsv.randomTimeOver)
		end
	end, arg_8_0.scene.battleID, arg_8_0.result, var_8_0, var_8_1, var_8_4)
end
