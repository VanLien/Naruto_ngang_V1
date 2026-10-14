local var_0_0 = battle.PassiveSkillTypes
local var_0_1 = class("SummonSkillModel", battleSkill.SkillModel)

battleSkill.SummonSkillModel = var_0_1

function var_0_1.ctor(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	battleSkill.PassiveSkillModel.ctor(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)

	arg_1_0.summonNum = arg_1_3.skillArgs[5] or 1
	arg_1_0.summonUnitId = arg_1_3.skillArgs[1]
	arg_1_0.summonPos = battleEasy.ifElse(arg_1_3.skillArgs[2] ~= -1 and arg_1_0.summonNum > 1, 0, arg_1_3.skillArgs[2])
	arg_1_0.summonLevel = battleEasy.ifElse(arg_1_3.skillArgs[3] > 0, arg_1_3.skillArgs[3], arg_1_2:getSummonerLevel())
	arg_1_0.summonAttrRate = arg_1_3.skillArgs[4]
	arg_1_0.summonBackStage = arg_1_0.summonPos == -1
	arg_1_0.summonSpecialRate = arg_1_3.skillArgs[6] or {}
	arg_1_0.isFollowMode = arg_1_3.skillArgs[7] == 1 and true or false
	arg_1_0.followArgs = arg_1_3.skillArgs[8] or {}
	arg_1_0.summonUnitData = csv.unit[arg_1_0.summonUnitId]
end

function var_0_1.canSpell(arg_2_0)
	if arg_2_0.owner:isDeath() then
		return false
	end

	if arg_2_0.summonBackStage then
		return true
	end

	if arg_2_0.scene:getForceNumIncludeDead(arg_2_0.owner.force) == 6 then
		return false
	end

	if arg_2_0.summonPos ~= 0 and arg_2_0.scene:getObjectBySeat(arg_2_0.summonPos) and arg_2_0.summonNum == 1 then
		return false
	end

	return true
end

function var_0_1.onTrigger(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	if arg_3_0.skillType ~= battle.SkillType.PassiveSummon then
		return
	end

	if arg_3_0:canSpell() and battleSkill.PassiveSkillModel.trigger(arg_3_0, arg_3_2, arg_3_3) then
		arg_3_0:spellTo(arg_3_2, arg_3_3)
	end
end

function var_0_1.processPlay(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_1.processArgs
	local var_4_1 = arg_4_1.noMissTargetsArray
	local var_4_2 = arg_4_1.allDamagedOrder

	for iter_4_0, iter_4_1 in arg_4_0:ipairsProcess() do
		local var_4_3 = arg_4_0.allProcessesTargets[iter_4_1.id]
		local var_4_4
		local var_4_5 = arg_4_0:getProcessArg(iter_4_0 - 1)

		if iter_4_0 > 1 and var_4_5 and arg_4_0.allProcessesTargets[var_4_5.id] then
			var_4_4 = arg_4_0.allProcessesTargets[var_4_5.id]
		end

		var_4_0[iter_4_0].buffTb = arg_4_0:processAddBuff(iter_4_1, var_4_3, var_4_4, battle.SkillAddBuffType.InPlay)
	end
end

function var_0_1.processTarget(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_1.processArgs
	local var_5_1 = {}
	local var_5_2 = arg_5_0.summonPos
	local var_5_3 = arg_5_0.owner
	local var_5_4 = var_5_3.force == 1 and 0 or arg_5_0.scene.play.ForceNumber
	local var_5_5
	local var_5_6
	local var_5_7
	local var_5_8 = var_5_3.summonGroup
	local var_5_9

	if arg_5_0.summonBackStage then
		var_5_9 = var_5_3.force
	end

	if not var_5_8 then
		ObjectModel.IDCounter = ObjectModel.IDCounter + 1
		var_5_8 = ObjectModel.IDCounter
		var_5_3.summonGroup = var_5_8
	end

	for iter_5_0 = 1, arg_5_0.summonNum do
		if var_5_2 == 0 then
			for iter_5_1 = 1 + var_5_4, arg_5_0.scene.play.ForceNumber + var_5_4 do
				if not arg_5_0.scene:getObjectBySeatExcludeDead(iter_5_1) then
					var_5_2 = iter_5_1

					break
				end
			end
		end

		if var_5_2 ~= 0 then
			local var_5_10 = arg_5_0:getSummonRoleOut()
			local var_5_11 = arg_5_0.scene.play:addCardRole(var_5_2, var_5_10, false, var_5_9)

			if arg_5_0.summonBackStage then
				var_5_11.summonGroup = var_5_8
			else
				table.insert(arg_5_0.scene.play.roundLeftHeros, {
					obj = var_5_11
				})
				var_5_11:initedTriggerPassiveSkill()
				arg_5_0.scene:tirggerFieldBuffs(var_5_11)
			end

			table.insert(var_5_1, var_5_11)

			if not arg_5_0.summonBackStage then
				var_5_2 = 0
			end
		end
	end

	for iter_5_2, iter_5_3 in arg_5_0:ipairsProcess() do
		local var_5_12 = var_5_0[iter_5_2]

		if iter_5_2 == 1 and arg_5_0.isFollowMode then
			var_5_1 = arg_5_0:getFollowTargets(iter_5_3, arg_5_1.target)
		end

		if iter_5_3.skillTarget == 24 then
			var_5_12.targets = var_5_1
			arg_5_0.allProcessesTargets[iter_5_3.id] = var_5_12.targets
		end

		battleEasy.queueNotifyFor(arg_5_0.owner.view, "processArgs", iter_5_3.id, var_5_12)
	end

	arg_5_1.summonTargets = var_5_1
end

function var_0_1.getFollowTargets(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = {}
	local var_6_1 = arg_6_0:onProcess(arg_6_1, arg_6_2)
	local var_6_2
	local var_6_3

	for iter_6_0, iter_6_1 in ipairs(var_6_1.targets) do
		if iter_6_1.seat >= 1 and iter_6_1.seat <= arg_6_0.scene.play.ObjectNumber then
			local var_6_4 = arg_6_0:getSummonRoleOut()

			var_6_4.type = battle.ObjectType.SummonFollow

			local var_6_5 = arg_6_0.scene.play:addCardRole(iter_6_1.seat, var_6_4, false, iter_6_1.force)

			if var_6_5 then
				table.insert(var_6_0, var_6_5)
				var_6_5:initedTriggerPassiveSkill()
				arg_6_0.scene:tirggerFieldBuffs(var_6_5)
			end
		end
	end

	return var_6_0
end

function var_0_1.isAttackSkill(arg_7_0)
	return false
end

function var_0_1._spellTo(arg_8_0, arg_8_1)
	local var_8_0 = {
		skillCfg = arg_8_0.cfg,
		target = arg_8_1
	}

	arg_8_0:processBefore(var_8_0)
	arg_8_0:processPlay(var_8_0)
	arg_8_0:processTarget(var_8_0)
	arg_8_0:processAfter(var_8_0)
	arg_8_0:onSpellView(var_8_0)
end

function var_0_1.getSummonRoleOut(arg_9_0)
	local var_9_0 = arg_9_0.summonUnitData
	local var_9_1 = {
		skills = {},
		passiveSkills = {},
		cardId = var_9_0.cardID,
		roleId = arg_9_0.summonUnitId,
		level = arg_9_0.summonLevel,
		skillLevel = arg_9_0.summonLevel,
		fightPoint = arg_9_0.owner.fightPoint,
		star = arg_9_0.owner.star,
		starEffect = arg_9_0.owner.starEffect,
		type = battle.ObjectType.Summon,
		isFollowMode = arg_9_0.isFollowMode,
		followArgs = arg_9_0.followArgs
	}
	local var_9_2 = arg_9_0.owner.attrs:cloneFinalAttr()

	for iter_9_0, iter_9_1 in pairs(var_9_2) do
		var_9_1[iter_9_0] = iter_9_1

		if arg_9_0.summonSpecialRate[iter_9_0] then
			var_9_1[iter_9_0] = var_9_1[iter_9_0] * arg_9_0.summonSpecialRate[iter_9_0]
		elseif ObjectAttrs.SixDimensionAttrs[iter_9_0] then
			var_9_1[iter_9_0] = var_9_1[iter_9_0] * arg_9_0.summonAttrRate
		elseif arg_9_0.summonSpecialRate.specialDefault then
			var_9_1[iter_9_0] = var_9_1[iter_9_0] * arg_9_0.summonSpecialRate.specialDefault
		end
	end

	var_9_1.hp = var_9_1.hpMax
	var_9_1.mp1 = var_9_1.mp1Max

	for iter_9_2, iter_9_3 in ipairs(var_9_0.skillList) do
		var_9_1.skills[iter_9_3] = arg_9_0.level
	end

	for iter_9_4, iter_9_5 in ipairs(var_9_0.passiveSkillList) do
		var_9_1.passiveSkills[iter_9_5] = arg_9_0.level
	end

	return var_9_1
end

function var_0_1.onSpellView(arg_10_0, arg_10_1)
	if table.length(arg_10_1.summonTargets) == 0 then
		return
	end

	local var_10_0 = arg_10_0.scene
	local var_10_1 = arg_10_0.owner.view
	local var_10_2 = arg_10_0.cfg
	local var_10_3 = arg_10_1.summonTargets
	local var_10_4 = arg_10_0.owner.view
	local var_10_5 = var_10_2.actionTime

	battleEasy.effect(nil, function()
		for iter_11_0, iter_11_1 in ipairs(var_10_3) do
			iter_11_1.view:proxy():setVisible(false)
			iter_11_1.view:proxy():setVisibleEnable(false)
		end
	end)
	battleEasy.queueEffect(function()
		battleEasy.queueEffect(function()
			for iter_13_0, iter_13_1 in ipairs(var_10_3) do
				iter_13_1.view:proxy():setVisibleEnable(true)
			end
		end)
	end)
	battleEasy.queueNotifyFor(var_10_4, "skillBefore", arg_10_0.disposeDatasOnSkillStart, arg_10_0.skillType)
	battleEasy.queueNotifyFor(var_10_4, "playAction", var_10_2.spineAction, var_10_5)
	battleEasy.queueNotifyFor(var_10_4, "objSkillEnd", arg_10_0.disposeDatasOnSkillEnd, arg_10_0.skillType)
	battleEasy.queueNotifyFor(var_10_4, "objSkillOver")
end
