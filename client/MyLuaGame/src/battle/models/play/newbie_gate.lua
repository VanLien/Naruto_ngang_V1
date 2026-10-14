local var_0_0 = {
	{
		{
			fixSpeedrank = true,
			speedrank = {
				1,
				3,
				8,
				9,
				5,
				6,
				10,
				11
			},
			input = {
				{
					targetId = 7,
					skillId = 60040812
				},
				[3] = {
					targetId = 9,
					skillId = 60049312
				},
				[8] = {
					targetId = 2,
					skillId = 60030712
				},
				[9] = {
					targetId = 3,
					skillId = 60031212
				},
				[5] = {
					targetId = 8,
					skillId = 60030612
				},
				[6] = {
					targetId = 7,
					skillId = 60030513
				},
				[10] = {
					targetId = 1,
					skillId = 60031513
				},
				[11] = {
					targetId = 3,
					skillId = 60041112
				}
			}
		},
		{
			fixSpeedrank = true,
			speedrank = {
				1,
				3,
				9,
				7,
				2,
				12,
				4,
				8,
				11,
				5
			},
			input = {
				{
					targetId = 8,
					skillId = 60040813
				},
				[3] = {
					targetId = 7,
					skillId = 60049313
				},
				[9] = {
					targetId = 2,
					skillId = 60031213
				},
				[7] = {
					targetId = 3,
					skillId = 60031313
				},
				{
					targetId = 8,
					skillId = 60041013
				},
				[12] = {
					targetId = 2,
					skillId = 60044313
				},
				[4] = {
					targetId = 11,
					skillId = 60030213
				},
				[8] = {
					targetId = 2,
					skillId = 60030713
				},
				[11] = {
					targetId = 2,
					skillId = 60041113
				},
				[5] = {
					targetId = 8,
					skillId = 60030613
				}
			}
		},
		{
			fixSpeedrank = true,
			speedrank = {
				5
			},
			input = {
				[5] = {
					endingSpine = true
				}
			}
		}
	}
}
local var_0_1 = class("NewbieGate", battlePlay.Gate)

battlePlay.NewbieGate = var_0_1
var_0_1.OperatorArgs = {
	canHandle = true,
	isAuto = false,
	isFullManual = false,
	speedNum = 2,
	canSpeedAni = false,
	canPause = false,
	canSkip = false
}

function var_0_1.ctor(arg_1_0, arg_1_1)
	battlePlay.Gate.ctor(arg_1_0, arg_1_1)

	if APP_CHANNEL == "none" or APP_CHANNEL == "luo" or dataEasy.isSkipNewbieBattle() then
		arg_1_0.OperatorArgs = clone(var_0_1.OperatorArgs)
		arg_1_0.OperatorArgs.canSkip = true
	end

	arg_1_0.fixOperatorData = {}
end

function var_0_1.getSortOrderTb(arg_2_0)
	if arg_2_0.fixOperatorData.speedrank then
		return arg_2_0.fixOperatorData.speedrank
	end

	return battlePlay.Gate.getSortOrderTb(arg_2_0)
end

function var_0_1.newWaveAddObjsStrategy(arg_3_0)
	arg_3_0:addCardRoles(1)
	arg_3_0:addCardRoles(2)
	arg_3_0:doObjsAttrsCorrect(true, true)
	battlePlay.Gate.newWaveAddObjsStrategy(arg_3_0)
end

function var_0_1.onNewWavePlayAni(arg_4_0)
	arg_4_0.curWave = arg_4_0.curWave + 1
	arg_4_0.curRound = 0
	arg_4_0.totalRoundBattleTurn = 0

	gRootViewProxy:notify("setWaveNumber", arg_4_0.curWave, arg_4_0.waveCount)
	battleEasy.queueEffect("delay", {
		lifetime = 300
	})
	arg_4_0.scene:waitNewWaveAniDone()
end

function var_0_1.onNewRound(arg_5_0)
	if var_0_0[arg_5_0.curWave] then
		arg_5_0.fixOperatorData = var_0_0[arg_5_0.curWave][arg_5_0.curRound + 1] or {}
	else
		arg_5_0.fixOperatorData = {}
	end

	battlePlay.Gate.onNewRound(arg_5_0)
end

function var_0_1.speedRankSort(arg_6_0)
	if arg_6_0.fixOperatorData.fixSpeedrank then
		local var_6_0 = {}
		local var_6_1 = arraytools.hash(arg_6_0.fixOperatorData.speedrank, true)
		local var_6_2 = itertools.filter(arg_6_0.roundLeftHeros, function(arg_7_0, arg_7_1)
			local var_7_0 = arg_7_1.obj

			if not var_7_0 or var_7_0:isRealDeath() or not var_6_1[var_7_0.seat] then
				table.insert(var_6_0, arg_7_0)

				return nil
			end

			return arg_7_1
		end)

		for iter_6_0 = table.length(var_6_0), 1, -1 do
			table.remove(arg_6_0.roundLeftHeros, var_6_0[iter_6_0])
		end

		table.sort(var_6_2, function(arg_8_0, arg_8_1)
			local var_8_0 = arg_8_0.obj
			local var_8_1 = arg_8_1.obj

			return var_6_1[var_8_0.seat] < var_6_1[var_8_1.seat]
		end)

		local var_6_3 = {}

		for iter_6_1, iter_6_2 in ipairs(var_6_2) do
			table.insert(var_6_3, iter_6_2.obj)
		end

		local var_6_4 = var_6_2[1]

		arg_6_0:setLeftHerosIndex(var_6_4)

		arg_6_0.attackerArray = var_6_3

		do return true end
		return
	end

	return battlePlay.Gate.speedRankSort(arg_6_0)
end

function var_0_1.triggerAllPassiveSkills(arg_9_0)
	arg_9_0.scene:onAllPassive(battle.PassiveSkillTypes.enter)

	for iter_9_0, iter_9_1 in arg_9_0:ipairsByGateOrder() do
		local var_9_0 = arg_9_0.scene:getObjectBySeatExcludeDead(iter_9_1)

		if var_9_0 then
			var_9_0:initedTriggerPassiveSkill(true)
		end
	end

	arg_9_0.scene:updateBuffByNode(battle.BuffTriggerPoint.onHolderAfterEnter)
end

function var_0_1.onceBattle(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0.fixOperatorData.input or {}

	if var_10_0[arg_10_0.curHero.seat] then
		if var_10_0[arg_10_0.curHero.seat].endingSpine then
			arg_10_0:onOver()

			return
		end

		local var_10_1

		if arg_10_0:beginBattleTurn() then
			arg_10_1 = var_10_0[arg_10_0.curHero.seat].targetId
			arg_10_2 = var_10_0[arg_10_0.curHero.seat].skillId
			var_10_1 = arg_10_0.scene:getObjectBySeatExcludeDead(arg_10_1)
			arg_10_0.curHero.handleChooseTarget = var_10_1

			arg_10_0:runBattleTurn({
				skill = arg_10_2
			}, var_10_1)
			battleEasy.queueNotify("autoSelectSkill", arg_10_1, arg_10_2)
		end

		arg_10_0:endBattleTurn(var_10_1)
	else
		battlePlay.Gate.onceBattle(arg_10_0, arg_10_1, arg_10_2)
	end
end

function var_0_1.postEndResultToServer(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0:makeEndViewInfos()

	gRootViewProxy:raw():postEndResultToServer("/game/role/guide/newbie", function(arg_12_0)
		arg_11_1(var_11_0, arg_12_0)
	end, -1)
end

function var_0_1.onOver(arg_13_0)
	if arg_13_0.isOver then
		return
	end

	arg_13_0.isOver = true

	battleEasy.queueEffect(function()
		arg_13_0.scene.autoFight = false

		gRootViewProxy:proxy():newbieEndPlayAni()
	end)
	arg_13_0.scene:playEnd()
end
