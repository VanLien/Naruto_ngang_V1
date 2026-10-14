local var_0_0 = class("SkillTestGate", battlePlay.Gate)

battlePlay.SkillTestGate = var_0_0
var_0_0.OperatorArgs = {
	canHandle = false,
	isAuto = false,
	isFullManual = false,
	canSpeedAni = true,
	canPause = false,
	canSkip = true
}

function var_0_0.ctor(arg_1_0, arg_1_1)
	battlePlay.Gate.ctor(arg_1_0, arg_1_1)

	arg_1_0.usedSkillList = {}
	arg_1_0.allTested = false
	arg_1_0.skillCount = 0
end

function var_0_0.init(arg_2_0, arg_2_1)
	arg_2_0:initStarConditions()
	print("!!!!!!!!!! 自动技能测试开始")
	battlePlay.Gate.init(arg_2_0, arg_2_1)
end

function var_0_0.newWaveAddObjsStrategy(arg_3_0)
	arg_3_0:addCardRoles(1)
	arg_3_0:addCardRoles(2)
	arg_3_0:doObjsAttrsCorrect(true, true)
	battlePlay.Gate.newWaveAddObjsStrategy(arg_3_0)
end

function var_0_0.autoAttack(arg_4_0)
	gRootViewProxy:notify("selectedHero")

	local var_4_0

	var_4_0 = arg_4_0:isMyTurn() and 2 or 1

	local var_4_1 = 0
	local var_4_2 = "main"
	local var_4_3 = "mid"
	local var_4_4 = "normal"

	for iter_4_0, iter_4_1 in arg_4_0.curHero:iterSkills() do
		if iter_4_1:canSpell() and not arg_4_0.usedSkillList[iter_4_0] then
			var_4_1 = iter_4_0
		end
	end

	if var_4_1 == 0 then
		arg_4_0.allTested = true
		var_4_1 = 11
	else
		arg_4_0.usedSkillList[var_4_1] = true
		arg_4_0.skillCount = arg_4_0.skillCount + 1

		print("# 使用过主动技能的数量", arg_4_0.skillCount)
	end

	local var_4_5 = arg_4_0:autoChoose(var_4_1)

	printDebug("# autoAttack, choose skillId= %d, attackId= %d", var_4_1 or 999999, var_4_5 and var_4_5.id or 999999)

	return {
		skill = var_4_1
	}, var_4_5
end

function var_0_0.checkBattleEnd(arg_5_0)
	if arg_5_0.allTested then
		print("!!!!!!!!!! 自动技能测试通过")

		return true, "fail"
	end

	if arg_5_0:checkForceAllRealDead(1) then
		print("!!!!!!!!!! 己方死光 测试中止")

		return true, "fail"
	end

	if arg_5_0:checkForceAllRealDead(2) then
		print("!!!!!!!!!! 对方死光 测试中止")

		return true, "fail"
	end

	return false
end

function var_0_0.onRoundEndSupply(arg_6_0)
	for iter_6_0 = 1, battlePlay.Gate.ObjectNumber do
		local var_6_0 = arg_6_0.scene:getObjectBySeatExcludeDead(iter_6_0)

		if var_6_0 then
			var_6_0:setHP(var_6_0:hpMax())

			if arg_6_0.curRound % 99 == 0 then
				var_6_0:clearBuff()
			end
		end
	end
end
