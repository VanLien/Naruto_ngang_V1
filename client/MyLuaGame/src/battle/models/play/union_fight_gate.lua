local var_0_0 = class("UnionFightGate", battlePlay.Gate)

battlePlay.UnionFightGate = var_0_0
var_0_0.OperatorArgs = {
	canHandle = false,
	isAuto = true,
	isFullManual = false,
	canSpeedAni = true,
	canPause = false,
	canSkip = true
}
var_0_0.SpecEndRuleCheck = {
	battle.EndSpecialCheck.TotalHpCheck,
	battle.EndSpecialCheck.ForceNum,
	battle.EndSpecialCheck.FightPoint
}

function var_0_0.init(arg_1_0, arg_1_1)
	battlePlay.Gate.init(arg_1_0, arg_1_1)

	arg_1_0.dbIDtb = {}
	arg_1_0.endAnimation = {
		aniName = "",
		res = "xianshipvp/jinjichang.skel"
	}

	arg_1_0:playStartAni()
end

function var_0_0.playStartAni(arg_2_0)
	gRootViewProxy:notify("showVsPvpView", 1)
end

function var_0_0.newWaveAddObjsStrategy(arg_3_0)
	arg_3_0:addCardRoles(1)
	arg_3_0:addCardRoles(2)
	arg_3_0:doObjsAttrsCorrect(true, true)
	battlePlay.Gate.newWaveAddObjsStrategy(arg_3_0)
end

function var_0_0.doObjsAttrsCorrect(arg_4_0, arg_4_1, arg_4_2)
	battlePlay.Gate.doObjsAttrsCorrect(arg_4_0, arg_4_1, arg_4_2)

	for iter_4_0 = 1, arg_4_0.ObjectNumber do
		local var_4_0 = arg_4_0.scene:getObjectBySeatExcludeDead(iter_4_0)

		if var_4_0 then
			var_4_0:setHP(var_4_0:hpMax() * var_4_0.hpScale, var_4_0:hpMax() * var_4_0.hpScale)
			var_4_0:setMP1(var_4_0:mp1Max() * var_4_0.mp1Scale + var_4_0:initMp1(), var_4_0:mp1Max() * var_4_0.mp1Scale + var_4_0:initMp1())
		end
	end

	arg_4_0.states = {}

	arg_4_0:setdbidTb()
end

function var_0_0.checkBattleEnd(arg_5_0)
	if arg_5_0:checkHaveFakeDead() then
		return false
	end

	return battlePlay.Gate.checkBattleEnd(arg_5_0)
end

function var_0_0.checkWaveEnd(arg_6_0)
	if arg_6_0:checkHaveFakeDead() then
		return false
	end

	if arg_6_0.curRound >= arg_6_0.roundLimit and arg_6_0:checkRoundEnd() or arg_6_0:checkForceAllRealDead(1) or arg_6_0:checkForceAllRealDead(2) then
		return true
	end

	return false
end

function var_0_0.onBattleEndSupply(arg_7_0)
	local var_7_0, var_7_1 = arg_7_0:checkBattleEnd()

	if var_7_1 == "win" then
		arg_7_0.endAnimation.aniName = "effect_l"
	elseif var_7_1 == "fail" then
		arg_7_0.endAnimation.aniName = "effect_r"
	end
end

function var_0_0.checkHaveFakeDead(arg_8_0)
	for iter_8_0 = 1, arg_8_0.ObjectNumber do
		local var_8_0 = arg_8_0.scene:getObjectBySeat(iter_8_0)

		if var_8_0 and var_8_0:isFakeDeath() then
			return true
		end
	end

	return false
end

function var_0_0.setdbidTb(arg_9_0)
	for iter_9_0 = 1, arg_9_0.ObjectNumber do
		local var_9_0 = arg_9_0.scene:getObjectBySeat(iter_9_0)

		if var_9_0 and arg_9_0:checkObjCanToServer(var_9_0) then
			arg_9_0.dbIDtb[iter_9_0] = var_9_0.dbID
		end
	end
end

function var_0_0.setCardStates(arg_10_0)
	local var_10_0 = 2

	if arg_10_0.result == "win" then
		var_10_0 = 1
	end

	for iter_10_0 = 1, arg_10_0.ObjectNumber do
		local var_10_1 = arg_10_0.scene:getObjectBySeat(iter_10_0)

		if var_10_1 and arg_10_0:checkObjCanToServer(var_10_1) then
			if not arg_10_0.states[var_10_1.dbID] then
				arg_10_0.states[var_10_1.dbID] = {}
			end

			local var_10_2 = var_10_1:hp() / var_10_1:hpMax()
			local var_10_3 = var_10_1:mp1() / var_10_1:mp1Max()

			if var_10_1.force ~= var_10_0 then
				var_10_2, var_10_3 = 0, 0
			end

			arg_10_0.states[var_10_1.dbID][1] = var_10_2
			arg_10_0.states[var_10_1.dbID][2] = var_10_3
		elseif arg_10_0.dbIDtb[iter_10_0] then
			if not arg_10_0.states[arg_10_0.dbIDtb[iter_10_0]] then
				arg_10_0.states[arg_10_0.dbIDtb[iter_10_0]] = {}
			end

			arg_10_0.states[arg_10_0.dbIDtb[iter_10_0]][1] = 0
			arg_10_0.states[arg_10_0.dbIDtb[iter_10_0]][2] = 0
		end
	end
end

function var_0_0.makeEndViewInfos(arg_11_0)
	arg_11_0:setCardStates()

	return {
		result = arg_11_0.result,
		states = arg_11_0.states
	}
end
