local var_0_0 = class("RandomGate", battlePlay.Gate)

battlePlay.RandomGate = var_0_0
var_0_0.OperatorArgs = {
	canHandle = true,
	isAuto = false,
	isFullManual = false,
	canSpeedAni = true,
	canPause = true,
	canSkip = true
}

local function var_0_1(arg_1_0)
	return arg_1_0.dbID
end

function var_0_0.init(arg_2_0, arg_2_1)
	arg_2_0:initStarConditions()
	battlePlay.Gate.init(arg_2_0, arg_2_1)
end

function var_0_0.newWaveAddObjsStrategy(arg_3_0)
	local var_3_0 = arg_3_0.data.gamemodel_data and arg_3_0.data.gamemodel_data.buffs or {}
	local var_3_1 = arg_3_0.data.gamemodel_data and arg_3_0.data.gamemodel_data.skill_used or {}
	local var_3_2 = arg_3_0.data.roleOut
	local var_3_3 = {}

	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		local var_3_4 = var_3_1[iter_3_1] or 0
		local var_3_5 = csv.random_tower.buffs[iter_3_1]

		if var_3_5.buffType == 4 and (var_3_5.effectTimes == 0 or var_3_4 < var_3_5.effectTimes) then
			var_3_3[var_3_5.passiveSkill] = 1
		end
	end

	for iter_3_2 = 1, 6 do
		local var_3_6 = var_3_2[iter_3_2]

		if var_3_6 then
			var_3_6.passive_skills = var_3_6.passive_skills or {}

			for iter_3_3, iter_3_4 in pairs(var_3_3) do
				var_3_6.passive_skills[iter_3_3] = iter_3_4
			end
		end
	end

	arg_3_0:addCardRoles(1, nil, var_3_2)
	arg_3_0:addCardRoles(2)
	arg_3_0:doObjsAttrsCorrect(true, true)
	battlePlay.Gate.newWaveAddObjsStrategy(arg_3_0)
	arg_3_0:setCardStates()
end

function var_0_0.setCardStates(arg_4_0)
	local var_4_0 = {
		{},
		{}
	}

	local function var_4_1(arg_5_0, arg_5_1, arg_5_2)
		local var_5_0 = arg_4_0.data.gamemodel_data[arg_5_0] or {}

		for iter_5_0, iter_5_1 in arg_5_1:pairs() do
			if arg_4_0:checkObjCanToServer(iter_5_1) then
				local var_5_1 = var_0_1(iter_5_1)
				local var_5_2 = var_5_0[tonumber(var_5_1)] or var_5_0[tostring(var_5_1)]

				if var_5_2 then
					local var_5_3 = iter_5_1:hpMax()
					local var_5_4 = iter_5_1:mp1Max()

					iter_5_1:setHP(var_5_3 * var_5_2[1])
					iter_5_1:setMP1(var_5_4 * var_5_2[2])
				end

				arg_5_2[var_5_1] = {
					0,
					0
				}
			end
		end
	end

	var_4_1("enemy_states", arg_4_0.scene:getHerosMap(2), var_4_0[2])
	var_4_1("card_states", arg_4_0.scene:getHerosMap(1), var_4_0[1])

	arg_4_0.gateStates = var_4_0
end

function var_0_0.getForceState(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.scene:getHerosMap(arg_6_1)
	local var_6_1 = arg_6_0.gateStates[arg_6_1]

	if arg_6_1 == 1 and arg_6_0.result == "win" then
		local var_6_2 = (tonumber(gCommonConfigCsv.randomTowerBattleHp) or 0) / 100
		local var_6_3 = tonumber(gCommonConfigCsv.randomTowerBattleMp) or 0

		for iter_6_0, iter_6_1 in var_6_0:pairs() do
			if arg_6_0:checkObjCanToServer(iter_6_1) then
				local var_6_4 = iter_6_1:hpMax() * var_6_2

				iter_6_1:setHP(iter_6_1:hp() + var_6_4)
				iter_6_1:setMP1(iter_6_1:mp1() + var_6_3)
			end
		end
	end

	for iter_6_2, iter_6_3 in var_6_0:pairs() do
		if arg_6_0:checkObjCanToServer(iter_6_3) then
			var_6_1[var_0_1(iter_6_3)] = {
				iter_6_3:hp() / iter_6_3:hpMax(),
				iter_6_3:mp1() / iter_6_3:mp1Max()
			}
		end
	end

	return var_6_1
end

function var_0_0.checkBattleEnd(arg_7_0)
	if arg_7_0:checkBothAllRealDead() then
		return true, "win"
	end

	return battlePlay.Gate.checkBattleEnd(arg_7_0)
end

function var_0_0.postEndResultToServer(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0:getForceState(1)
	local var_8_1 = arg_8_0:getForceState(2)
	local var_8_2 = arg_8_0:makeEndViewInfos({
		gateStar = true
	})

	gRootViewProxy:raw():postEndResultToServer("/game/random_tower/end", function(arg_9_0)
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
	end, arg_8_0.scene.battleID, arg_8_0.result, var_8_2.gateStar, var_8_0, var_8_1, arg_8_0.curRound)
end
