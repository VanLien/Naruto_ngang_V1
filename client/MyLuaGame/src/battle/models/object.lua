local var_0_0 = math.abs
local var_0_1 = math.max
local var_0_2 = math.min
local var_0_3 = math.floor
local var_0_4 = battle.PassiveSkillTypes

globals.ObjectModel = class("ObjectModel")
ObjectModel.IDCounter = 100

for iter_0_0, iter_0_1 in pairs(ObjectAttrs.AttrsTable) do
	ObjectModel[iter_0_0] = function(arg_1_0, arg_1_1)
		if arg_1_0.multiShapeTb then
			if arg_1_1 then
				if arg_1_1 == 2 or arg_1_1 == 0 and arg_1_0.multiShapeTb[1] == 1 then
					return arg_1_0.attrs:getBase2FinalAttr(iter_0_0)
				end
			elseif arg_1_0.multiShapeTb[1] == 2 and arg_1_0.multiShapeTb[3][iter_0_0] then
				return arg_1_0.attrs:getBase2FinalAttr(iter_0_0)
			end
		end

		return arg_1_0.attrs:getFinalAttr(iter_0_0)
	end
end

function ObjectModel.ctor(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.scene = arg_2_1
	arg_2_0.view = nil
	ObjectModel.IDCounter = ObjectModel.IDCounter + 1
	arg_2_0.id = ObjectModel.IDCounter
	arg_2_0.seat = arg_2_2
	arg_2_0.realSeal = arg_2_2
	arg_2_0.attrs = ObjectAttrs.new()
	arg_2_0.skills = {}
	arg_2_0.passiveSkills = {}
	arg_2_0.skillsOrder = {}
	arg_2_0.triggerSkillsOrder = {}
	arg_2_0.passiveSkillsOrder = {}
	arg_2_0.curSkill = nil
	arg_2_0.curSelectSkill = nil
	arg_2_0.curTargetId = nil
	arg_2_0.state = battle.ObjectState.none
	arg_2_0.hpTable = table.salttable({
		0,
		0,
		0
	})
	arg_2_0.mp1Table = table.salttable({
		0,
		0,
		0
	})
	arg_2_0.buffs = arg_2_0.scene:createBuffCollection()
	arg_2_0.auraBuffs = arg_2_0.scene:createBuffMap()
	arg_2_0.buffOverlayCount = {}
	arg_2_0.changeUnitIDTb = {}
	arg_2_0.buffGroupEnchance = {
		{},
		{}
	}
	arg_2_0.speedPriority = 0
	arg_2_0.battleRound = {
		[1] = 0,
		[2] = 0
	}
	arg_2_0.battleRoundAllWave = {
		[1] = 0,
		[2] = 0
	}
	arg_2_0.closeSkillType2 = {}
	arg_2_0.ignoreDamageInBattleRound = false
	arg_2_0.ignoreToAttack = false
	arg_2_0.totalDamage = {}
	arg_2_0.totalResumeHp = {}
	arg_2_0.totalTakeDamage = {}
	arg_2_0.recordBuffDataTb = {}
	arg_2_0.extraRoundData = CList.new()
	arg_2_0.skillIdToReplaceRecord = {}
	arg_2_0.skillReplaceReocrd = {}
	arg_2_0.triggerEnv = {}
	arg_2_0.protectedEnv = battleCsv.makeProtectedEnv(arg_2_0)

	battleComponents.bind(arg_2_0, "Event")
	arg_2_0:setListenerComparer(BuffModel.BuffCmp)
end

function ObjectModel.init(arg_3_0, arg_3_1)
	arg_3_0.data = csvClone(arg_3_1)
	arg_3_0.dbID = arg_3_1.cardId
	arg_3_0.unitID = arg_3_1.roleId
	arg_3_0.orginUnitId = arg_3_1.roleId
	arg_3_0.level = arg_3_1.level
	arg_3_0.force = arg_3_0.seat <= arg_3_0.scene.play.ForceNumber and 1 or 2
	arg_3_0.fightPoint = arg_3_1.fightPoint or 0
	arg_3_0.unitCfg = csv.unit[arg_3_0.unitID]

	if not arg_3_0.unitCfg then
		error(string.format("no unit config id = %s", arg_3_0.unitID))
	end

	arg_3_0.type = arg_3_1.type or battle.ObjectType.Normal
	arg_3_0.star = arg_3_1.star or 0
	arg_3_0.starEffect = arg_3_1.starEffect or -1
	arg_3_0.attributeType = arg_3_0.unitCfg.attributeType
	arg_3_0.natureType = arg_3_0.unitCfg.natureType
	arg_3_0.natureType2 = arg_3_0.unitCfg.natureType2
	arg_3_0.rarity = arg_3_0.unitCfg.rarity
	arg_3_0.summonCalDamage = arg_3_0.unitCfg.summonCalDamage
	arg_3_0.battleFlag = {}
	arg_3_0.cardID = arg_3_0.unitCfg.cardID
	arg_3_0.cardCfg = csv.cards[arg_3_0.cardID]
	arg_3_0.markID = arg_3_0.cardCfg and arg_3_0.cardCfg.cardMarkID or 0
	arg_3_0.state = battle.ObjectState.normal
	arg_3_0.multiShapeTb = arg_3_1.role2Data and {
		1,
		{},
		{}
	} or nil

	arg_3_0:onInitAttributes()

	arg_3_0.skillInfo = arg_3_1.skills or {}
	arg_3_0.passiveSkillInfo = arg_3_1.passive_skills or {}
	arg_3_0.attackerCurSkill = {}
	arg_3_0.tagSkills = {}
	arg_3_0.skillsMap = {}

	arg_3_0:onInitSkills(arg_3_0.skillInfo, arg_3_0.passiveSkillInfo)

	arg_3_0.hpScale = arg_3_1.hpScale
	arg_3_0.mp1Scale = arg_3_1.mp1Scale

	arg_3_0:addObjViewToScene()

	arg_3_0.faceTo = arg_3_0.view:proxy():getFaceTo()

	arg_3_0.view:proxy():setActionState("standby_loop")

	arg_3_0.effectPower = csv.effect_power[arg_3_0.unitCfg.effectPowerId]

	if arg_3_0.unitCfg.battleFlag then
		for iter_3_0, iter_3_1 in csvPairs(arg_3_0.unitCfg.battleFlag) do
			arg_3_0.battleFlag[iter_3_1] = true
		end
	end

	for iter_3_2, iter_3_3 in pairs(battle.DamageFrom) do
		arg_3_0.totalDamage[iter_3_3] = battleEasy.valueTypeTable()
	end

	for iter_3_4, iter_3_5 in pairs(battle.ResumeHpFrom) do
		arg_3_0.totalResumeHp[iter_3_5] = battleEasy.valueTypeTable()
	end

	for iter_3_6, iter_3_7 in pairs(battle.TriggerEnvType) do
		arg_3_0.triggerEnv[iter_3_7] = CVector.new()
	end

	arg_3_0:onInitPassData()
	arg_3_0:setHP(arg_3_0:hpMax(), arg_3_0:hpMax())
	arg_3_0:setMP1(arg_3_0:initMp1(), arg_3_0:initMp1())
end

function ObjectModel.addObjViewToScene(arg_4_0)
	local var_4_0 = {
		type = battle.SpriteType.Normal
	}

	arg_4_0.view = gRootViewProxy:getProxy("onSceneAddObj", tostring(arg_4_0), readOnlyProxy(arg_4_0, {
		hp = function()
			return arg_4_0:hp(true)
		end,
		mp1 = function()
			return arg_4_0:mp1(true)
		end,
		setHP = function(arg_7_0, arg_7_1)
			return arg_4_0:setHP(nil, arg_7_1)
		end,
		setMP1 = function(arg_8_0, arg_8_1)
			return arg_4_0:setMP1(nil, arg_8_1)
		end
	}), var_4_0)
end

function ObjectModel.onInitPassData(arg_9_0)
	for iter_9_0 = 1, arg_9_0.scene.play.curWave do
		if not arg_9_0.totalTakeDamage[iter_9_0] then
			arg_9_0.totalTakeDamage[iter_9_0] = battleEasy.valueTypeTable()
		end
	end
end

function ObjectModel.onInitAttributes(arg_10_0)
	arg_10_0.attrs:setSceneTag(arg_10_0.scene.sceneTag)
	arg_10_0:setBaseData(arg_10_0.data)
end

function ObjectModel.setBaseData(arg_11_0, arg_11_1)
	local var_11_0 = battleEasy.ifElse(arg_11_0.force == 1, arg_11_0.scene.sceneConf.demonCorrectSelf, arg_11_0.scene.sceneConf.demonCorrect)
	local var_11_1

	if var_11_0 then
		var_11_1 = gSceneDemonCorrectCsv[var_11_0][arg_11_0.scene.play.curWave] or gSceneDemonCorrectCsv[var_11_0][1]
	end

	if var_11_1 then
		local var_11_2 = arg_11_0.scene.play:getTopCardsAttrAvg(6)
		local var_11_3 = arg_11_0.force == 1 and "self" or ""
		local var_11_4 = var_11_1.seatExtraFix[arg_11_0.seat] or 1

		for iter_11_0, iter_11_1 in pairs(var_11_2) do
			local var_11_5 = var_11_1[iter_11_0 .. var_11_3]

			if var_11_5[1] and var_11_5[2] then
				local var_11_6 = 2 - math.floor((arg_11_0.seat + 2) / 3) % 2
				local var_11_7 = battleEasy.ifElse(var_11_6 == 1, var_11_5[1], var_11_5[2])

				arg_11_1[iter_11_0] = math.floor(iter_11_1 * var_11_7 * var_11_4)

				if arg_11_1.role2Data then
					arg_11_1.role2Data[iter_11_0] = math.floor(iter_11_1 * var_11_7 * var_11_4)
				end
			end
		end
	end

	arg_11_0.attrs:setBase(arg_11_1)
end

function ObjectModel.checkSkillCheat(arg_12_0)
	if ANTI_AGENT then
		return
	end

	checkSpecificCsvCheat("skill", itertools.ikeys(itertools.chain({
		arg_12_0.skills,
		arg_12_0.passiveSkills
	})))
end

function ObjectModel.onInitPreSkills(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = {}

	for iter_13_0, iter_13_1 in pairs(maptools.extend({
		arg_13_1,
		arg_13_2
	})) do
		print(iter_13_0)

		local var_13_1 = csv.skill[iter_13_0]

		if var_13_1.skillArgs then
			for iter_13_2, iter_13_3 in csvPairs(var_13_1.skillArgs) do
				if type(iter_13_3) == "table" and iter_13_3.replaceSkill then
					var_13_0 = maptools.extend({
						var_13_0,
						iter_13_3.replaceSkill
					})
				end
			end
		end
	end

	return var_13_0
end

function ObjectModel.onInitSkills(arg_14_0, arg_14_1, arg_14_2)
	arg_14_0.skills = {}
	arg_14_0.passiveSkills = {}
	arg_14_0.tagSkills = {}

	local var_14_0 = arg_14_0:onInitPreSkills(arg_14_1, arg_14_2)

	local function var_14_1(arg_15_0)
		return var_14_0[arg_15_0] or arg_15_0
	end

	local function var_14_2(arg_16_0, arg_16_1, arg_16_2)
		if arg_16_1 and arg_16_1.skillType2 == battle.MainSkillType.TagSkill then
			arg_14_0.tagSkills[arg_16_0] = arg_16_2

			return true
		end
	end

	local function var_14_3(arg_17_0, arg_17_1, arg_17_2)
		local var_17_0 = csv.skill[arg_17_1]

		if not var_14_2(arg_17_1, var_17_0, arg_17_2) and not arg_17_0[arg_17_1] then
			arg_17_0[arg_17_1] = newSkillModel(arg_14_0.scene, arg_14_0, arg_17_1, arg_17_2)
		end
	end

	for iter_14_0, iter_14_1 in pairs(arg_14_1) do
		iter_14_0 = var_14_1(iter_14_0)

		local var_14_4 = csv.skill[iter_14_0]

		if not var_14_4 then
			return false
		end

		if var_14_4.skillType == battle.SkillType.NormalSkill then
			arg_14_0.skills[iter_14_0] = newSkillModel(arg_14_0.scene, arg_14_0, iter_14_0, iter_14_1)
		elseif var_14_4.skillType == battle.SkillType.PassiveAura or var_14_4.skillType == battle.SkillType.PassiveSkill then
			arg_14_0.passiveSkills[iter_14_0] = newSkillModel(arg_14_0.scene, arg_14_0, iter_14_0, iter_14_1)
		else
			var_14_2(iter_14_0, var_14_4, iter_14_1)
		end
	end

	for iter_14_2, iter_14_3 in ipairs(arg_14_0.unitCfg.skillList) do
		var_14_3(arg_14_0.skills, var_14_1(iter_14_3), arg_14_1[iter_14_3] or 1)
	end

	for iter_14_4, iter_14_5 in ipairs(arg_14_0.unitCfg.passiveSkillList) do
		var_14_3(arg_14_0.passiveSkills, var_14_1(iter_14_5), arg_14_1[iter_14_5] or 1)
	end

	for iter_14_6, iter_14_7 in pairs(arg_14_2) do
		var_14_3(arg_14_0.passiveSkills, var_14_1(iter_14_6), iter_14_7)
	end

	if arg_14_0.unitCfg.combinationSkillId then
		arg_14_0.passiveSkills[arg_14_0.unitCfg.combinationSkillId] = newSkillModel(arg_14_0.scene, arg_14_0, arg_14_0.unitCfg.combinationSkillId, skillLevel)
	end

	arg_14_0:updateSkillsOrder()
	arg_14_0:checkSkillCheat()
	arg_14_0:resetReplaceSkillRecord()

	for iter_14_8, iter_14_9 in arg_14_0:iterSkills() do
		iter_14_9:updateStateInfoTb()
	end
end

function ObjectModel.updateSkillsOrder(arg_18_0)
	arg_18_0.skillsOrder = itertools.keys(arg_18_0.skills)

	table.sort(arg_18_0.skillsOrder, function(arg_19_0, arg_19_1)
		return arg_19_1 < arg_19_0
	end)

	local var_18_0 = {}

	for iter_18_0, iter_18_1 in pairs(arg_18_0.passiveSkills) do
		if var_18_0[iter_18_1.skillType] == nil then
			var_18_0[iter_18_1.skillType] = {
				iter_18_0
			}
		else
			table.insert(var_18_0[iter_18_1.skillType], iter_18_0)
		end
	end

	for iter_18_2, iter_18_3 in pairs(var_18_0) do
		table.sort(iter_18_3, function(arg_20_0, arg_20_1)
			local var_20_0 = csv.skill[arg_20_0].passivePriority
			local var_20_1 = csv.skill[arg_20_1].passivePriority

			if var_20_0 and var_20_1 and var_20_0 ~= var_20_1 then
				return var_20_0 < var_20_1
			else
				return arg_20_0 < arg_20_1
			end
		end)
	end

	local var_18_1 = {
		var_18_0[battle.SkillType.PassiveAura],
		var_18_0[battle.SkillType.PassiveSkill],
		var_18_0[battle.SkillType.PassiveSummon],
		var_18_0[battle.SkillType.PassiveCombine]
	}

	arg_18_0.triggerSkillsOrder = var_18_0
	arg_18_0.passiveSkillsOrder = arraytools.merge(arraytools.compact(var_18_1))

	local var_18_2 = arg_18_0:getOverlaySpecBuffData(battle.OverlaySpecBuff.changeSkillNature)

	if var_18_2.refreshAll then
		var_18_2.refreshAll()
	end
end

function ObjectModel.onAddSkills(arg_21_0, arg_21_1)
	if not arg_21_1 or not next(arg_21_1) then
		return
	end

	local var_21_0 = {}

	for iter_21_0, iter_21_1 in pairs(arg_21_1) do
		local var_21_1 = csv.skill[iter_21_0]

		if not var_21_1 then
			return false
		end

		if var_21_1.skillType == battle.SkillType.NormalSkill then
			arg_21_0.skills[iter_21_0] = newSkillModel(arg_21_0.scene, arg_21_0, iter_21_0, iter_21_1)
			var_21_0[iter_21_0] = arg_21_0.skills[iter_21_0]
		elseif var_21_1.skillType == battle.SkillType.PassiveAura or var_21_1.skillType == battle.SkillType.PassiveSkill then
			arg_21_0.passiveSkills[iter_21_0] = newSkillModel(arg_21_0.scene, arg_21_0, iter_21_0, iter_21_1)
			var_21_0[iter_21_0] = arg_21_0.passiveSkills[iter_21_0]
		else
			insertTagSkill(iter_21_0, var_21_1, iter_21_1)
		end
	end

	arg_21_0:updateSkillsOrder()
	arg_21_0:checkSkillCheat()

	for iter_21_2, iter_21_3 in arg_21_0:iterSkills() do
		if var_21_0[iter_21_2] then
			iter_21_3:updateStateInfoTb()
		end
	end
end

function ObjectModel.cantBeAttack(arg_22_0)
	if arg_22_0:isDeath() then
		return true
	end

	return false
end

function ObjectModel.initedTriggerPassiveSkill(arg_23_0, arg_23_1)
	if not arg_23_1 then
		arg_23_0:onPassive(var_0_4.enter)
	end

	if arg_23_0:triggerOriginEnvCheck(battle.TriggerEnvType.PassiveSkill, var_0_4.enter) then
		return
	end

	arg_23_0:onPassive("Aura")

	if not arg_23_1 then
		arg_23_0:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderAfterEnter)
	end
end

function ObjectModel.hp(arg_24_0, arg_24_1)
	return arg_24_0.hpTable[arg_24_1 and 2 or 1]
end

function ObjectModel.getCurSkill(arg_25_0)
	local var_25_0 = arg_25_0.scene.play.curHero

	return var_25_0 and var_25_0.curSkill
end

function ObjectModel.getSkillType(arg_26_0)
	local var_26_0 = arg_26_0.scene.play.curHero
	local var_26_1
	local var_26_2

	if var_26_0 and var_26_0.curSkill then
		var_26_1 = var_26_0.curSkill.skillType
		var_26_2 = var_26_0.curSkill.skillType2
	end

	return var_26_1, var_26_2
end

function ObjectModel.getSkillByType2(arg_27_0, arg_27_1)
	for iter_27_0, iter_27_1 in arg_27_0:iterSkills() do
		if iter_27_1.skillType2 == arg_27_1 then
			return iter_27_1
		end
	end
end

function ObjectModel.addHp(arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0:hp() + arg_28_1

	if var_28_0 < 0 then
		arg_28_0.hpTable[3] = arg_28_0.hpTable[3] + var_28_0
	elseif arg_28_0:hp() == 0 and arg_28_1 > 0 then
		arg_28_1 = arg_28_1 + arg_28_0.hpTable[3]
		arg_28_0.hpTable[3] = math.min(arg_28_1, 0)
		var_28_0 = arg_28_0:hp() + arg_28_1
	end

	arg_28_0:setHP(var_28_0)
end

function ObjectModel.setHP(arg_29_0, arg_29_1, arg_29_2)
	logf.battle.object.setHP("setHP selfSeat= %d, hp Real= %f, hp Show= %f", arg_29_0.seat, arg_29_1 or -9999, arg_29_2 or -9999)

	local var_29_0 = arg_29_0:hpMax()
	local var_29_1 = arg_29_1 and cc.clampf(arg_29_1, 0, var_29_0)
	local var_29_2 = arg_29_2 and cc.clampf(arg_29_2, 0, var_29_0)

	arg_29_0.hpTable[1] = var_29_1 or arg_29_0.hpTable[1]
	arg_29_0.hpTable[2] = var_29_2 or arg_29_0.hpTable[2]

	if not arg_29_0:isDeath() then
		local var_29_3, var_29_4 = arg_29_0:getSkillType()

		battleEasy.deferNotify(arg_29_0.view, "updateLifebar", {
			skillType = var_29_3,
			mainSkillType = var_29_4
		})
	end

	arg_29_0:refreshShield()
end

function ObjectModel.mp1(arg_30_0, arg_30_1)
	return arg_30_0.mp1Table[arg_30_1 and 2 or 1]
end

function ObjectModel.mpOverflow(arg_31_0)
	return arg_31_0.mp1Table[3]
end

function ObjectModel.updateMp1Overflow(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5)
	local var_32_0 = arg_32_0:mpOverflow()

	if arg_32_4 and arg_32_1 then
		local var_32_1 = arg_32_4.mode

		if var_32_1 ~= 1 then
			local function var_32_2(arg_33_0)
				local var_33_0 = arg_32_1 - arg_32_2

				var_32_0 = var_32_0 + var_33_0
				arg_32_1 = arg_32_2

				if arg_33_0 then
					if var_32_0 > arg_32_4.limit then
						arg_32_1 = arg_32_1 + (var_32_0 - arg_32_4.limit)
					elseif var_32_0 < 0 then
						arg_32_1 = arg_32_1 + var_32_0
					end
				end

				var_32_0 = cc.clampf(var_32_0, 0, arg_32_4.limit)
			end

			if arg_32_0.curSkill and arg_32_0.curSkill.chargeRound and arg_32_4.extraArgs.changeMpOverflowInCharge then
				var_32_2(arg_32_4.extraArgs.affectNormalMpInCharge)
			elseif arg_32_5 then
				var_32_2(arg_32_4.extraArgs.affectNormalMpFromBuff)
			elseif arg_32_1 < arg_32_2 and var_32_1 == 3 then
				var_32_2(true)
			end
		end

		if arg_32_3 < arg_32_1 then
			var_32_0 = (arg_32_1 - arg_32_3) * (var_32_1 == 1 and 1 or arg_32_4.rate) + var_32_0
			var_32_0 = cc.clampf(var_32_0, 0, arg_32_4.limit)
		end
	end

	return arg_32_1, var_32_0
end

function ObjectModel.setMP1(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	arg_34_3 = arg_34_3 or {}

	if not arg_34_3.ignoreLockMp1Add and arg_34_0.lockMp1Add and arg_34_1 > arg_34_0:mp1() then
		return
	end

	logf.battle.object.setMP1(" setMP1 selfSeat= %d, mp Real= %f, mp Show= %f", arg_34_0.seat, arg_34_1 or -9999, arg_34_2 or -9999)

	local var_34_0 = arg_34_0:mp1()
	local var_34_1 = arg_34_0:mp1Max()
	local var_34_2 = math.max(arg_34_1 - var_34_1, 0)
	local var_34_3 = arg_34_0:getOverlaySpecBuffByIdx("mp1OverFlow")
	local var_34_4
	local var_34_5

	arg_34_1, var_34_5 = arg_34_0:updateMp1Overflow(arg_34_1, var_34_0, var_34_1, var_34_3, arg_34_3.changeMpOverflow)
	arg_34_1 = arg_34_1 and cc.clampf(arg_34_1, 0, var_34_1)
	arg_34_2 = arg_34_2 and cc.clampf(arg_34_2, 0, var_34_1)
	arg_34_0.mp1Table = table.salttable({
		arg_34_1 or arg_34_0.mp1Table[1],
		arg_34_2 or arg_34_0.mp1Table[2],
		var_34_5
	})

	battleEasy.deferNotify(arg_34_0.view, "updateLifebar", {
		mp1OverflowData = var_34_3,
		mp = arg_34_1,
		mpOverflow = arg_34_0:mpOverflow(),
		mpMax = var_34_1
	})

	if var_34_0 and var_34_0 ~= arg_34_1 then
		arg_34_0:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderMp1Change, arg_34_0)
	end

	if var_34_2 > 0 then
		arg_34_0:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderMp1Overflow, {
			resumeMpOverflow = var_34_2
		})
	end

	arg_34_0:refreshShield()
	arg_34_0.scene.play:refreshUIMp()
end

function ObjectModel.refreshShield(arg_35_0)
	local var_35_0 = arg_35_0:getOverlaySpecBuffData("shield")
	local var_35_1 = arg_35_0:shieldHp()
	local var_35_2 = math.max(var_35_0.shieldMaxTotal or 0, arg_35_0:hpMax())
	local var_35_3, var_35_4 = arg_35_0:getSkillType()

	log.battle.object.shield("seat:" .. arg_35_0.seat .. " common shieldHpMax:", var_35_2, "common shieldHp:", var_35_1)
	arg_35_0:refreshLifeBar()
end

function ObjectModel.shieldHp(arg_36_0, arg_36_1)
	if arg_36_1 then
		local var_36_0 = {}
		local var_36_1 = 0

		for iter_36_0, iter_36_1 in arg_36_0:ipairsOverlaySpecBuff("shield") do
			if itertools.include(arg_36_1, iter_36_1.cfgId) then
				var_36_1 = var_36_1 + math.max(iter_36_1.shieldHp, 0)
			end
		end

		return var_36_1
	else
		return arg_36_0:getOverlaySpecBuffData("shield").shieldTotal or 0
	end
end

function ObjectModel.specialShieldHp(arg_37_0)
	local var_37_0 = 0

	for iter_37_0, iter_37_1 in arg_37_0:ipairsOverlaySpecBuff("shield") do
		if iter_37_1.showType ~= 0 then
			var_37_0 = var_37_0 + iter_37_1.shieldHp
		end
	end

	return var_37_0
end

function ObjectModel.addShieldHp(arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = arg_38_0:getOverlaySpecBuffData("shield")
	local var_38_1 = {}
	local var_38_2 = {}

	arg_38_1 = math.floor(arg_38_1)

	local var_38_3 = arg_38_1
	local var_38_4 = arg_38_2 and arg_38_0:shieldHp(arg_38_2) or var_38_0.shieldTotal

	var_38_0.shieldTotal = math.max(var_38_0.shieldTotal + (var_38_4 + arg_38_1 > 0 and arg_38_1 or -var_38_4), 0)

	for iter_38_0, iter_38_1 in arg_38_0:ipairsOverlaySpecBuff("shield") do
		if not arg_38_2 or itertools.include(arg_38_2, iter_38_1.cfgId) then
			arg_38_1 = arg_38_1 + iter_38_1.shieldHp
			var_38_2[iter_38_1.cfgId] = 1

			if arg_38_1 <= 0 then
				iter_38_1.shieldHp = 0
				var_38_1[iter_38_1.id] = true
				var_38_2[iter_38_1.cfgId] = 2
			else
				iter_38_1.shieldHp = arg_38_1

				break
			end
		end
	end

	if var_38_3 < arg_38_1 then
		arg_38_0:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderShieldChange, {
			beAttackShield = var_38_2
		})
		arg_38_0:delBuff(var_38_1)
	end
end

function ObjectModel.refreshLifeBar(arg_39_0)
	if arg_39_0:isDeath() then
		return
	end

	local var_39_0 = arg_39_0.hpTable[1]
	local var_39_1 = arg_39_0:hpMax()
	local var_39_2 = arg_39_0:shieldHp()
	local var_39_3 = arg_39_0:specialShieldHp()
	local var_39_4 = arg_39_0:delayDamage()

	battleEasy.deferNotify(arg_39_0.view, "updateLifebar", {
		needCalc = true,
		hp = var_39_0,
		hpMax = var_39_1,
		shieldHp = var_39_2,
		specialShieldHp = var_39_3,
		delayHp = var_39_4
	})
	arg_39_0.scene.play:refreshUIHp(arg_39_0)
end

function ObjectModel.delayDamage(arg_40_0)
	local var_40_0 = 0

	for iter_40_0, iter_40_1 in arg_40_0:ipairsOverlaySpecBuff(battle.OverlaySpecBuff.delayDamage) do
		for iter_40_2, iter_40_3 in ipairs(iter_40_1.damageTb) do
			for iter_40_4, iter_40_5 in ipairs(iter_40_3) do
				var_40_0 = var_40_0 + iter_40_5
			end
		end
	end

	return var_40_0
end

local function var_0_5(arg_41_0, arg_41_1, arg_41_2)
	local var_41_0 = 0
	local var_41_1
	local var_41_2
	local var_41_3 = table.length(arg_41_1)

	return function()
		while var_41_0 < var_41_3 do
			var_41_0 = var_41_0 + 1
			var_41_1 = arg_41_2 and arg_41_2[arg_41_1[var_41_0]] or arg_41_1[var_41_0]
			var_41_2 = arg_41_0[var_41_1]

			if var_41_2 then
				return var_41_1, var_41_2
			end
		end
	end, arg_41_1, 0
end

function ObjectModel.iterSkills(arg_43_0)
	return var_0_5(arg_43_0.skills, arg_43_0.skillsOrder, arg_43_0.skillsMap)
end

local function var_0_6(arg_44_0, arg_44_1)
	return not arg_44_1.isOver
end

function ObjectModel.iterBuffs(arg_45_0)
	return arg_45_0.buffs:order_pairs()
end

function ObjectModel.iterBuffsWithEasyEffectFunc(arg_46_0, arg_46_1)
	return arg_46_0.buffs:getQuery():group("easyEffectFunc", arg_46_1):order_pairs()
end

function ObjectModel.queryBuffsWithGroup(arg_47_0, arg_47_1)
	local var_47_0 = arg_47_0.buffs:getQuery()
	local var_47_1 = arg_47_0.scene:getConvertGroupCache()

	if var_47_1 and var_47_1.convertGroup == arg_47_1 then
		for iter_47_0, iter_47_1 in pairs(var_47_1.assignGroup) do
			var_47_0:groups("+", "groupID", iter_47_0)
		end
	end

	var_47_0:groups("+", "groupID", arg_47_1)

	return var_47_0
end

function ObjectModel.onPassive(arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4)
	if table.length(arg_48_0.passiveSkillsOrder) == 0 then
		return
	end

	arg_48_0.triggerEnv[battle.TriggerEnvType.PassiveSkill]:push_back(arg_48_1)

	for iter_48_0, iter_48_1 in var_0_5(arg_48_0.passiveSkills, arg_48_0.passiveSkillsOrder) do
		arg_48_0:onOnePassiveTrigger(iter_48_1, arg_48_1, arg_48_2, arg_48_3, arg_48_4)
	end

	arg_48_0.triggerEnv[battle.TriggerEnvType.PassiveSkill]:pop_back()
end

function ObjectModel.onOnePassiveTrigger(arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4, arg_49_5)
	local var_49_0 = arg_49_0.scene.play.battleRoundTriggerId

	if var_49_0 and gExtraRoundTrigger[var_49_0] and gExtraRoundTrigger[var_49_0].forbiddenPassiveSkill[arg_49_2] then
		return
	end

	if arg_49_1.onTrigger and (arg_49_2 == arg_49_1.type or arg_49_2 == "Aura" and arg_49_1.skillType == battle.SkillType.PassiveAura or (arg_49_2 == var_0_4.roundStartAttack or arg_49_2 == var_0_4.roundEnd and arg_49_4.roundFlag == battle.PassiveRoundEndFlag.SelfBattleTurn or arg_49_2 == var_0_4.roundStart) and arg_49_1.skillType == battle.SkillType.PassiveCombine) then
		if not arg_49_3 then
			for iter_49_0, iter_49_1 in ipairs(arg_49_1.processes) do
				if iter_49_1.targetType == 0 then
					arg_49_3 = arg_49_0

					break
				else
					local var_49_1 = arg_49_0.scene.play:autoChoose(nil, 3 - arg_49_0.force)
					local var_49_2 = arg_49_0.scene.play.nowChooseID or var_49_1.seat

					arg_49_3 = arg_49_0.scene:getObjectBySeatExcludeDead(var_49_2)

					break
				end
			end
		end

		log.battle.object.onPassive("角色seat=", arg_49_0.seat, "触发了被动: 类型=", arg_49_2, "passiveSkill.id=", arg_49_1.id)
		arg_49_1:onTrigger(arg_49_2, arg_49_3 or arg_49_0, arg_49_4)
	end
end

function ObjectModel.onNewBattleTurn(arg_50_0)
	local var_50_0 = arg_50_0.scene.play.battleRoundTriggerId
	local var_50_1 = false

	if var_50_0 and gExtraRoundTrigger[var_50_0] then
		var_50_1 = gExtraRoundTrigger[var_50_0].disableBattleState == 1
	end

	local var_50_2 = arg_50_0.scene.play.curHero.id == arg_50_0.id

	if var_50_2 then
		if arg_50_0:nextExtraAttack() then
			arg_50_0:onNewExtraBattleTurn()
		elseif not var_50_1 then
			arg_50_0.battleRound[2] = arg_50_0.battleRound[2] + 1
			arg_50_0.battleRoundAllWave[2] = arg_50_0.battleRoundAllWave[2] + 1

			if arg_50_0.scene:getExtraBattleRoundMode() ~= battle.ExtraBattleRoundMode.normal then
				arg_50_0:addExRecord(battle.ExRecordEvent.extraBattleRound, 1)
			end
		end

		if not var_50_1 then
			arg_50_0:addExRecord(battle.ExRecordEvent.roundAttackTime, 1)
		end
	end

	if var_50_2 then
		arg_50_0.scene.extraRoundMode = arg_50_0:beInExtraAttack()
	end

	if arg_50_0:onNewBattleTurnInDead() then
		return
	end

	arg_50_0.flashBack = false

	arg_50_0:setHP(arg_50_0:hp(), arg_50_0:hp())
	arg_50_0:setMP1(arg_50_0:mp1(), arg_50_0:mp1())
	arg_50_0:refreshShield()
	arg_50_0:cleanEventByKey(battle.ExRecordEvent.protectTarget)

	if var_50_2 then
		arg_50_0:onPassive(var_0_4.roundStartAttack)
		arg_50_0:onPassive(var_0_4.cycleRound)
		arg_50_0:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderBattleTurnStart, arg_50_0)
	end

	arg_50_0:updateSkillState(var_50_2)
	battleEasy.queueNotifyFor(arg_50_0.view, "newBattleTurn")
end

function ObjectModel.onBattleTurnEnd(arg_51_0)
	local var_51_0 = arg_51_0.scene.play.battleRoundTriggerId
	local var_51_1 = false

	if var_51_0 and gExtraRoundTrigger[var_51_0] then
		var_51_1 = gExtraRoundTrigger[var_51_0].disableBattleState == 2
	end

	arg_51_0:onPassive(var_0_4.hpLess)
	arg_51_0:onPassive(var_0_4.dynamicHpLess, arg_51_0)

	local var_51_2 = {
		objs = arg_51_0.scene:getHerosMap(arg_51_0.force)
	}

	arg_51_0:onPassive(var_0_4.teamHpLess, arg_51_0, var_51_2)
	arg_51_0:onPassive(var_0_4.dynamicTeamHpLess, arg_51_0, var_51_2)

	arg_51_0.once = false

	local var_51_3 = arg_51_0.scene.play.curHero.id == arg_51_0.id

	if arg_51_0:beInExtraAttack() then
		arg_51_0:onExtraAttackEnd()
	elseif var_51_3 then
		if not var_51_1 then
			arg_51_0.battleRound[1] = arg_51_0.battleRound[1] + 1
			arg_51_0.battleRoundAllWave[1] = arg_51_0.battleRoundAllWave[1] + 1
		end

		arg_51_0:onPassive(var_0_4.roundEnd, arg_51_0, {
			roundFlag = battle.PassiveRoundEndFlag.SelfBattleTurn
		})
	end

	if var_51_3 then
		arg_51_0:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderBattleTurnEnd, arg_51_0)
		battleEasy.deferNotify(nil, "showNumber", {
			close = true
		})
	end

	if not var_51_1 then
		arg_51_0.ignoreDamageInBattleRound = false
	end

	arg_51_0.scene:addObjViewToBattleTurn(arg_51_0, "playBuffHolderAction")
end

function ObjectModel.onNewBattleTurnInDead(arg_52_0)
	if not arg_52_0:isFakeDeath() then
		return
	end

	if arg_52_0.scene.play.curHero.id == arg_52_0.id then
		if not arg_52_0.scene:beInExtraAttack() then
			arg_52_0:addExRecord(battle.ExRecordEvent.rebornRound, 1)
		end

		arg_52_0:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderBattleTurnStart, arg_52_0)
		arg_52_0:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderBattleTurnEnd, arg_52_0)
	end

	return arg_52_0:isDeath()
end

function ObjectModel.onNewExtraBattleTurn(arg_53_0)
	local var_53_0 = arg_53_0.extraRoundData:pop_back()

	if var_53_0 then
		arg_53_0.exAttackTargetID = var_53_0.exAttackTargetID
		arg_53_0.exAttackSkillID = var_53_0.exAttackSkillID
		arg_53_0.exAttackArgs = var_53_0.extraArgs

		arg_53_0:setExtraAttackMode(var_53_0.mode)

		arg_53_0.exAttackBattleTriggerRound = var_53_0.exAttackBattleTriggerRound
	end
end

function ObjectModel.addExtraBattleData(arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4)
	arg_54_0.extraRoundData:push_back({
		exAttackTargetID = arg_54_1,
		exAttackSkillID = arg_54_2,
		mode = arg_54_3,
		extraArgs = arg_54_4,
		exAttackBattleTriggerRound = arg_54_0.scene.play.curBattleRound
	})
end

function ObjectModel.onExtraAttackEnd(arg_55_0)
	if arg_55_0.exAttackBattleTriggerRound == arg_55_0.scene.play.curBattleRound then
		return
	end

	arg_55_0:clearExtraBattleDataByMode(arg_55_0.exAttackMode)

	arg_55_0.exAttackTargetID = nil
	arg_55_0.exAttackSkillID = nil
	arg_55_0.exAttackMode = nil
	arg_55_0.exAttackArgs = nil
end

function ObjectModel.clearExtraBattleDataByMode(arg_56_0, arg_56_1)
	if arg_56_1 == battle.ExtraAttackMode.counter then
		arg_56_0:removeSkillType2Data("counterAttack")

		if arg_56_0.curSkill and arg_56_0.curSkill.skillType2 ~= battle.MainSkillType.SmallSkill then
			arg_56_0.curSkill.spellRound = arg_56_0.curSkill.spellRound - 1
		end
	end
end

function ObjectModel.recordInfoBeforeWave(arg_57_0)
	local var_57_0 = arg_57_0.curSkill and arg_57_0.curSkill.chargeRound

	arg_57_0:addExRecord(battle.ExRecordEvent.chargeStateBeforeWave, var_57_0 and true or false)
end

function ObjectModel.onNewWave(arg_58_0)
	arg_58_0:recordInfoBeforeWave()

	arg_58_0.battleRound[1] = 0
	arg_58_0.battleRound[2] = 0

	for iter_58_0, iter_58_1 in arg_58_0:iterSkills() do
		iter_58_1:resetOnNewWave()
	end

	arg_58_0:triggerBuffOnPoint()

	arg_58_0.curSkill = nil

	for iter_58_2, iter_58_3 in arg_58_0.extraRoundData:pairs() do
		arg_58_0:clearExtraBattleDataByMode(iter_58_3.mode)
	end

	if arg_58_0.multiShapeTb then
		arg_58_0.multiShapeTb[2] = {}
	end

	arg_58_0.extraRoundData:clear()

	arg_58_0.exAttackTargetID = nil
	arg_58_0.exAttackArgs = nil
	arg_58_0.exAttackSkillID = nil
	arg_58_0.exAttackMode = nil
	arg_58_0.exAttackBattleTriggerRound = nil
	arg_58_0.totalTakeDamage[arg_58_0.scene.play.curWave] = battleEasy.valueTypeTable()

	arg_58_0:refreshShield()

	if arg_58_0.type == battle.ObjectType.Normal then
		local var_58_0 = arg_58_0.scene:getObjectBySeatExcludeDead(arg_58_0.seat, battle.ObjectType.SummonFollow)

		if var_58_0 then
			var_58_0:onNewWave()
		end
	end
end

function ObjectModel.onNewRound(arg_59_0)
	if arg_59_0:isFakeDeath() and not arg_59_0:canReborn() then
		arg_59_0.state = battle.ObjectState.realDead

		return
	end

	arg_59_0:onPassive(var_0_4.round)
	arg_59_0:onPassive(var_0_4.roundStart)

	for iter_59_0, iter_59_1 in arg_59_0:iterSkills() do
		iter_59_1:resetOnNewRound()
	end

	arg_59_0:cleanEventByKey(battle.ExRecordEvent.roundSyncAttackTime)
end

function ObjectModel.onEndRound(arg_60_0)
	gRootViewProxy:proxy():pushDeferList("onEndRound")
	arg_60_0:onPassive(var_0_4.roundEnd, arg_60_0, {
		roundFlag = battle.PassiveRoundEndFlag.Round
	})

	local var_60_0 = gRootViewProxy:proxy():popDeferList("onEndRound")

	battleEasy.queueEffect(function()
		battleEasy.queueEffect(function()
			gRootViewProxy:proxy():runDefer(var_60_0)
		end)
	end)
end

function ObjectModel.isAlreadyDead(arg_63_0)
	if arg_63_0:isDeath() then
		return true
	end

	return arg_63_0:hp() <= 0
end

function ObjectModel.isDeath(arg_64_0)
	return arg_64_0:isRealDeath() or arg_64_0:isFakeDeath()
end

function ObjectModel.isFakeDeath(arg_65_0)
	return arg_65_0.state == battle.ObjectState.dead or arg_65_0:isRebornState()
end

function ObjectModel.isRebornState(arg_66_0)
	return arg_66_0.state == battle.ObjectState.reborn
end

function ObjectModel.isRealDeath(arg_67_0)
	return arg_67_0.state == battle.ObjectState.realDead
end

function ObjectModel.spellAttack(arg_68_0)
	local var_68_0 = arg_68_0.curSkill

	if var_68_0 then
		battleEasy.deferNotify(nil, "hideAllObjsSkillTips")
		battleEasy.deferNotify(nil, "showHero", {
			typ = "showAll",
			hideLife = true
		})
		gRootViewProxy:proxy():flushCurDeferList()
		arg_68_0:onPassive(var_0_4.attack, nil, nil, var_68_0.skillType == battle.SkillType.NormalSkill and -100)
		arg_68_0:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderToAttack, arg_68_0)

		if arg_68_0.ignoreToAttack then
			arg_68_0.curSkill = nil

			return false
		end

		arg_68_0:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderBeForeSkillSpellTo, arg_68_0)
		gRootViewProxy:proxy():flushCurDeferList()

		if arg_68_0:isDeath() or not arg_68_0:canAttack() then
			return false
		end

		local var_68_1 = arg_68_0:getCurTarget()

		if arg_68_0:onProphet(var_68_0, var_68_1) then
			return false
		end

		var_68_0:spellTo(var_68_1)

		return true
	end

	return false
end

function ObjectModel.onProphet(arg_69_0, arg_69_1, arg_69_2)
	if arg_69_0:beInExtraAttack() or arg_69_0.scene.play.battleRoundTriggerId or not arg_69_0.scene:hasTypeBuff("prophet") then
		return
	end

	local var_69_0
	local var_69_1 = {}
	local var_69_2 = {}
	local var_69_3, var_69_4 = arg_69_0:getProphetTargets(arg_69_1, arg_69_2)
	local var_69_5 = {}

	for iter_69_0, iter_69_1 in ipairs(var_69_3) do
		var_69_5[iter_69_1.id] = true
	end

	local var_69_6 = arg_69_0.force == 1 and 2 or 1

	for iter_69_2, iter_69_3 in arg_69_0.scene:getHerosMap(var_69_6):order_pairs() do
		if iter_69_3:checkOverlaySpecBuffExit(battle.OverlaySpecBuff.prophet) then
			local var_69_7 = randret or ymrand.random()
			local var_69_8 = false

			for iter_69_4, iter_69_5 in iter_69_3:ipairsOverlaySpecBuff(battle.OverlaySpecBuff.prophet) do
				if var_69_7 < iter_69_5:getProb(arg_69_0) then
					var_69_8 = true

					if var_69_5[iter_69_3.id] then
						arg_69_0.scene.play.battleRoundTriggerId = arg_69_0.scene.play.battleRoundTriggerId or iter_69_5.triggerId
						var_69_0 = var_69_0 or iter_69_3.buffs:find(iter_69_5.id)

						iter_69_3:onProphetAttack(arg_69_1, arg_69_0, iter_69_5)
						iter_69_3:triggerBuffOnPoint(battle.BuffTriggerPoint.onBuffTrigger, {
							buffId = var_69_0.id,
							attacker = arg_69_0
						})
					end

					break
				end
			end

			if var_69_8 then
				if var_69_5[iter_69_3.id] then
					table.insert(var_69_1, iter_69_3.id)
				else
					table.insert(var_69_2, iter_69_3.id)
				end
			end
		end
	end

	if var_69_0 then
		local var_69_9 = {
			obj = arg_69_0,
			reset = var_69_0.id,
			buffCfgId = var_69_0.cfgId,
			targetId = arg_69_2.id,
			newSkillId = arg_69_1.id,
			mustHit = var_69_1,
			cantHit = arraytools.hash(var_69_2),
			processCfgId = var_69_4,
			mode = battle.ExtraBattleRoundMode.reset
		}

		battleEasy.resetGateAttackRecord(arg_69_0, var_69_9)
	end

	return var_69_0 ~= nil
end

function ObjectModel.getProphetTargets(arg_70_0, arg_70_1, arg_70_2)
	local var_70_0 = {}
	local var_70_1

	for iter_70_0, iter_70_1 in ipairs(arg_70_1.processes) do
		if iter_70_1.segType == battle.SkillSegType.damage then
			var_70_0 = arg_70_1:onProcessGetTargets(iter_70_1, arg_70_2)
			var_70_1 = iter_70_1.id

			break
		end
	end

	return var_70_0, var_70_1
end

function ObjectModel.getCurTarget(arg_71_0)
	return arg_71_0.curTargetId and arg_71_0.scene:getObject(arg_71_0.curTargetId) or nil
end

function ObjectModel.isSameForce(arg_72_0, arg_72_1)
	return (arg_72_1 and arg_72_1.force) == arg_72_0.force
end

function ObjectModel.isSelfInCharging(arg_73_0)
	return arg_73_0.curSkill and arg_73_0.curSkill:isChargeSkill() and arg_73_0.curSkill:isCharging()
end

function ObjectModel.isSelfChargeOK(arg_74_0)
	return arg_74_0.curSkill and arg_74_0.curSkill:isChargeSkill() and arg_74_0.curSkill:isChargeOK()
end

function ObjectModel.isSelfControled(arg_75_0)
	return arg_75_0:isLogicStateExit(battle.ObjectLogicState.cantAttack)
end

function ObjectModel.canAttack(arg_76_0)
	if not next(arg_76_0.skills) then
		return false
	end

	if arg_76_0:isSelfInCharging() then
		return false
	end

	if arg_76_0:isSelfControled() then
		return false
	end

	if arg_76_0.exAttackTargetID and not arg_76_0.scene:getFilterObject(arg_76_0.exAttackTargetID, {
		fromObj = arg_76_0
	}, battle.FilterObjectType.noAlreadyDead, battle.FilterObjectType.excludeObjLevel1) and arg_76_0.exAttackArgs and arg_76_0.exAttackArgs.isFixedForce and arg_76_0.exAttackArgs.targetForce == arg_76_0.force and table.length(arg_76_0:getCanAttackObjs(arg_76_0.force)) == 0 then
		return false
	end

	local var_76_0

	for iter_76_0, iter_76_1 in arg_76_0:iterSkills() do
		if iter_76_1:canSpell() and (not arg_76_0.exAttackSkillID or arg_76_0.exAttackSkillID == iter_76_0) then
			return true
		end
	end

	return false
end

function ObjectModel.getCanAttackObjs(arg_77_0, arg_77_1)
	local var_77_0

	if arg_77_1 == arg_77_0.force then
		var_77_0 = arg_77_0.scene:getFilterObjects(arg_77_1, {
			fromObj = arg_77_0
		}, battle.FilterObjectType.excludeEnvObj, battle.FilterObjectType.noAlreadyDead, battle.FilterObjectType.excludeObjLevel1)
	else
		var_77_0 = arg_77_0.scene:getFilterObjects(arg_77_1, {
			fromObj = arg_77_0
		}, battle.FilterObjectType.noAlreadyDead, battle.FilterObjectType.excludeObjLevel1)
	end

	return var_77_0
end

function ObjectModel.toAttack(arg_78_0, arg_78_1, arg_78_2)
	local var_78_0 = arg_78_1.skill
	local var_78_1 = arg_78_0.skills[var_78_0]

	if var_78_1 == nil then
		errorInWindows("unit:%d skill(%s) is nil", arg_78_0.unitID, var_78_0)

		return
	end

	arg_78_0.curSkill = var_78_1

	if var_78_1:isChargeSkill() and not var_78_1:isChargeOK() then
		if not arg_78_2 then
			return
		end

		var_78_1:startCharge()

		arg_78_0.chargeSkillTargetId = arg_78_2.id

		return
	end

	battleEasy.deferNotify(nil, "showSkillName", var_78_0)

	local var_78_2 = arg_78_2

	if var_78_1.cfg.damageFormula and arg_78_0:isBeInConfusion() and (not arg_78_0.exAttackArgs or not arg_78_0.exAttackArgs.isFixedForce) then
		local var_78_3, var_78_4, var_78_5, var_78_6 = arg_78_0:getConfusionCheckInfos()
		local var_78_7 = arg_78_0.force == 2 and 1 or 2
		local var_78_8 = ymrand.random()
		local var_78_9 = arg_78_0.force
		local var_78_10

		if table.length(var_78_3) == 0 and (table.length(var_78_4) == 0 or var_78_5) then
			return
		elseif table.length(var_78_3) == 0 or var_78_8 < var_78_6 then
			var_78_10 = var_78_4

			local var_78_11 = var_78_7
		else
			var_78_10 = var_78_3
		end

		if table.length(var_78_10) > 0 then
			local var_78_12 = var_78_10[ymrand.random(1, table.length(var_78_10))].id

			var_78_2 = arg_78_0.scene:getObject(var_78_12)
		end
	end

	if not var_78_2 then
		return
	end

	arg_78_0.curTargetId = var_78_2.id

	log.battle.object.toAttack(" 当前被攻击的目标 target.id =", arg_78_0.curTargetId or " no target ?")
	gRootViewProxy:proxy():flushCurDeferList()

	if var_78_1:canSpell() then
		arg_78_0:spellAttack()
	end
end

function ObjectModel.getConfusionCheckInfos(arg_79_0)
	local var_79_0 = arg_79_0:getCanAttackObjs(arg_79_0.force)
	local var_79_1 = arg_79_0.force == 2 and 1 or 2
	local var_79_2 = arg_79_0:getCanAttackObjs(var_79_1)
	local var_79_3 = math.huge
	local var_79_4

	for iter_79_0, iter_79_1 in arg_79_0:ipairsOverlaySpecBuff("confusion") do
		if var_79_3 > iter_79_1.prob then
			var_79_3 = iter_79_1.prob
			var_79_4 = iter_79_1.needSelfForce
		else
			var_79_4 = iter_79_1.prob == var_79_3 and iter_79_1.needSelfForce or var_79_4
		end
	end

	return var_79_0, var_79_2, var_79_4, var_79_3
end

function ObjectModel.resumeHp(arg_80_0, arg_80_1, arg_80_2, arg_80_3)
	local var_80_0 = battleEasy.valueTypeTable()

	if arg_80_2 < 0 then
		errorInWindows("回血类效果需配置正值 hp:%s, val:%s", arg_80_0:hp(), arg_80_2)

		return var_80_0
	end

	if arg_80_0:checkOverlaySpecBuffExit("lockResumeHp") and not arg_80_3.ignoreLockResume then
		return var_80_0
	end

	local var_80_1 = arg_80_2

	if not arg_80_3.ignoreBeHealAddRate then
		var_80_1 = var_0_3(var_80_1 * (1 + arg_80_0:beHealAdd()))

		log.battle.object.resumeHp(" 治疗加成 healAdd=", var_80_1 - arg_80_2, arg_80_0:beHealAdd())
	end

	local var_80_2 = arg_80_0:hp() + var_80_1

	var_80_0:add(var_80_1)

	if var_80_2 > arg_80_0:hpMax() then
		var_80_0:add(var_80_2 - arg_80_0:hpMax(), battle.ValueType.overFlow)

		var_80_2 = arg_80_0:hpMax()
	end

	var_80_0:add(var_80_1 - var_80_0:get(battle.ValueType.overFlow), battle.ValueType.valid)
	logf.battle.object.resumeHp(" id=%s, 当前hp:%f + 改变值:%f -> 最终hp:%f", arg_80_0.id, arg_80_0:hp(), var_80_1, var_80_2)

	if arg_80_1 then
		arg_80_1.totalResumeHp[arg_80_3.from]:addTable(var_80_0)
	end

	battleEasy.deferNotify(arg_80_0.view, "showHeadNumber", {
		typ = 1,
		num = var_80_1,
		args = arg_80_3 or {}
	})
	arg_80_0:addHp(var_80_1)
	arg_80_0:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderHpAdd, {
		resumeHp = var_80_0,
		resumeHpFrom = arg_80_3.from,
		resumeHpFromKey = arg_80_3.fromKey,
		obj = arg_80_1
	})

	return var_80_0
end

function ObjectModel.resetHp(arg_81_0, arg_81_1, arg_81_2)
	local var_81_0 = arg_81_1

	if var_81_0 - arg_81_0:hpMax() > -1e-05 then
		var_81_0 = arg_81_0:hpMax()
	end

	logf.battle.object.resetHp(" id=%s, 改变值:%f -> 最终hp:%f", arg_81_0.id, arg_81_1, var_81_0)
	battleEasy.deferNotify(arg_81_0.view, "showHeadNumber", {
		typ = 1,
		num = var_81_0,
		args = arg_81_2 or {}
	})
	arg_81_0:setHP(var_81_0, var_81_0)
end

function ObjectModel.setDead(arg_82_0, arg_82_1, arg_82_2, arg_82_3)
	if arg_82_0:isDeath() then
		return
	end

	arg_82_0:cowPreCalcRecord()

	arg_82_3 = arg_82_3 or {
		force = false
	}

	if not arg_82_3.beAttackZOrder then
		arg_82_0.scene:updateBeAttackZOrder()

		arg_82_3.beAttackZOrder = arg_82_0.scene.beAttackZOrder
	end

	arg_82_0.state = battle.ObjectState.dead
	arg_82_0.attackMeDeadObj = arg_82_1
	arg_82_0.killMeDamageValues = arg_82_2 and arg_82_2 or battleEasy.valueTypeTable()

	logf.battle.object.dead("setDead self.seat=%s attacker.id=%s", arg_82_0.seat, arg_82_1 and arg_82_1.id)

	if arg_82_0.scene.play.gateDoOnObjectDead then
		arg_82_0.scene.play:gateDoOnObjectDead(arg_82_0.seat)
	end

	arg_82_0:addAttackerMpOnSelfDead(arg_82_1)

	if not arg_82_3.noTrigger or arg_82_3.noTrigger ~= true then
		local var_82_0 = gRootViewProxy:proxy():pushDeferList(arg_82_0.id, "deathBuff")

		arg_82_0:onPassive(var_0_4.beDeathAttack)

		if arg_82_1 then
			arg_82_1:onPassive(var_0_4.kill, arg_82_1)
		end

		arg_82_0:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderDeath, {
			killerID = arg_82_0.attackMeDeadObj.seat
		})
		arg_82_0.scene:addListViewToBattleTurn(arg_82_0, gRootViewProxy:proxy():popDeferList(var_82_0))
	end

	arg_82_0:delBuffsWithSelf()

	if arg_82_3.force then
		arg_82_0:processRealDeath(arg_82_3.beAttackZOrder, arg_82_3.noTrigger)
	elseif arg_82_0:canReborn() then
		arg_82_0:processFakeDeath()
	else
		arg_82_0:processRealDeath(arg_82_3.beAttackZOrder, arg_82_3.noTrigger)
	end

	if arg_82_0.type == battle.ObjectType.Normal then
		local var_82_1 = arg_82_0.scene:getObjectBySeatExcludeDead(arg_82_0.seat, battle.ObjectType.SummonFollow)

		if var_82_1 then
			var_82_1:setDead(arg_82_1, arg_82_2, arg_82_3)
		end
	end
end

function ObjectModel.delBuffsWithSelf(arg_83_0)
	local var_83_0 = arg_83_0.force == 1 and 2 or 1

	for iter_83_0, iter_83_1 in arg_83_0.scene:getHerosMap(var_83_0):order_pairs() do
		if not iter_83_1:isAlreadyDead() and iter_83_1:isBeInSneer() and iter_83_1:getSneerObj() and iter_83_1:getSneerObj().id == arg_83_0.id then
			for iter_83_2, iter_83_3 in iter_83_1:iterBuffsWithEasyEffectFunc("sneer") do
				if iter_83_3.csvCfg.easyEffectFunc == "sneer" then
					iter_83_3:overClean()
				end
			end
		end
	end
end

function ObjectModel.processFakeDeath(arg_84_0)
	logf.battle.object.fakeDead(" seat:%d 假死", arg_84_0.seat)
	arg_84_0:onPassive(var_0_4.fakeDead)
	arg_84_0:clearBuff(function(arg_85_0)
		local var_85_0 = arg_85_0.csvCfg.noDelWhenFakeDeath == 1

		return arg_85_0.csvCfg.easyEffectFunc ~= "reborn" and not var_85_0
	end)
	arg_84_0:fakeDeathCleanData()
	arg_84_0:processReborn()
end

local var_0_7 = {
	"changeUnit",
	"changeToRandEnemyObj",
	"changeImage"
}

function ObjectModel.processRealDeath(arg_86_0, arg_86_1, arg_86_2)
	logf.battle.object.realDead(" seat:%d 真死", arg_86_0.seat)

	if arg_86_0:isRealDeath() then
		return
	end

	arg_86_0.state = battle.ObjectState.realDead

	if not arg_86_2 or arg_86_2 ~= true then
		arg_86_0:onPassive(var_0_4.realDead)

		local var_86_0 = gRootViewProxy:proxy():pushDeferList(arg_86_0.id, "realDeathBuff")

		arg_86_0:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderRealDeath, {
			killerID = arg_86_0.attackMeDeadObj.seat
		})
		arg_86_0.attackMeDeadObj:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderMakeTargetRealDeath, arg_86_0)
		arg_86_0.scene:addListViewToBattleTurn(arg_86_0, gRootViewProxy:proxy():popDeferList(var_86_0))
	end

	arg_86_0.scene.play:recordDamageStats()
	arg_86_0.scene:addObjToBeDeleted(arg_86_0)
	arg_86_0.scene:setDeathRecord(arg_86_0, arg_86_1)
	arg_86_0:realDeathCleanData()
	arg_86_0:recordRealDeadHpMaxSum()
end

function ObjectModel.processRealDeathClean(arg_87_0)
	logf.battle.object.realDead(" seat:%d 真死", arg_87_0.seat)

	if arg_87_0:isRealDeath() then
		return
	end

	arg_87_0.state = battle.ObjectState.realDead

	arg_87_0:realDeathCleanData()
end

function ObjectModel.recordRealDeadHpMaxSum(arg_88_0)
	if arg_88_0.scene.play.myDeadHpMaxSum and arg_88_0.seat <= 6 then
		arg_88_0.scene.play.myDeadHpMaxSum = arg_88_0.scene.play.myDeadHpMaxSum + arg_88_0:hpMax()
	elseif arg_88_0.scene.play.enemyDeadHpMaxSum and arg_88_0.seat > 6 then
		arg_88_0.scene.play.enemyDeadHpMaxSum = arg_88_0.scene.play.enemyDeadHpMaxSum + arg_88_0:hpMax()
	end
end

function ObjectModel.fakeDeathCleanData(arg_89_0)
	arg_89_0.killMeDamageValues = nil

	arg_89_0.scene:cleanObjInExtraRound(arg_89_0)
	arg_89_0:deleteAuraBuffs()
end

function ObjectModel.realDeathCleanData(arg_90_0)
	local var_90_0 = arg_90_0:getBuffQuery():groups_init_with_all():groups_sub_array("-", "easyEffectFunc", "+", var_0_7)

	arg_90_0:clearBuff(nil, var_90_0)
	arg_90_0:fakeDeathCleanData()
end

function ObjectModel.hasExtraBattleRound(arg_91_0)
	return false
end

function ObjectModel.triggerBuffOnPoint(arg_92_0, arg_92_1, arg_92_2)
	if not arg_92_0:effectPowerControl(battle.EffectPowerType.triggerPoint, arg_92_1) then
		return
	end

	if BuffModel.IterAllPointsMap[arg_92_1] then
		for iter_92_0, iter_92_1 in arg_92_0:iterBuffs() do
			if iter_92_1:isTrigger(arg_92_1, arg_92_2) then
				iter_92_1:updateWithTrigger(arg_92_1, arg_92_2)
			end
		end

		return
	end

	arg_92_0:dispatchEvent(arg_92_1, arg_92_2)
end

function ObjectModel.calcInternalDamage(arg_93_0, arg_93_1, arg_93_2, arg_93_3, arg_93_4)
	local var_93_0, var_93_1 = battleEasy.runDamageProcess(arg_93_2, arg_93_1, arg_93_0, arg_93_3, arg_93_4)

	return var_0_3(var_93_0), var_93_1
end

function ObjectModel.beAttack(arg_94_0, arg_94_1, arg_94_2, arg_94_3, arg_94_4)
	arg_94_0.curAttackMeObj = arg_94_1

	if not arg_94_4.processId and not arg_94_4.isDefer then
		arg_94_0.scene:updateBeAttackZOrder()
	end

	arg_94_4.beAttackZOrder = arg_94_4.beAttackZOrder or arg_94_0.scene.beAttackZOrder

	if arg_94_1 then
		for iter_94_0, iter_94_1 in arg_94_0:iterBuffs() do
			iter_94_1:refreshExtraTargets(battle.BuffExtraTargetType.holderBeAttackFrom, {
				arg_94_1
			})
		end
	end

	local var_94_0 = arg_94_1 and not arg_94_4.noDamageRecord
	local var_94_1 = arg_94_0.scene.play.curWave
	local var_94_2 = battleEasy.valueTypeTable()

	if arg_94_0:isDeath() then
		if var_94_0 then
			arg_94_1.totalDamage[arg_94_4.from]:add(arg_94_2, battle.ValueType.overFlow)
			arg_94_1.totalDamage[arg_94_4.from]:add(arg_94_2)
		end

		arg_94_0.totalTakeDamage[var_94_1]:add(arg_94_2, battle.ValueType.overFlow)
		arg_94_0.scene:setDeathRecord(arg_94_0, arg_94_4.beAttackZOrder)
		arg_94_0.scene:runBeAttackDefer(arg_94_0.id)

		return var_94_2, arg_94_4
	end

	local var_94_3, var_94_4 = arg_94_0:calcInternalDamage(arg_94_1, arg_94_2, arg_94_3, arg_94_4)
	local var_94_5 = var_0_0(arg_94_0:hp() - arg_94_0:hpMax()) < 1e-05

	var_94_2:add(var_94_3)

	if var_94_4.extraValueF then
		var_94_2:add(var_94_4.extraValueF)
	end

	local var_94_6 = 0

	for iter_94_2, iter_94_3 in pairs(arg_94_1.totalDamage) do
		var_94_6 = var_94_6 + iter_94_3:get(battle.ValueType.normal)
	end

	logf.battle.object.causeDamage(" seat:%d 伤害类型: %d, damage:%f , 总伤害:%f", arg_94_1 and arg_94_1.seat or -99, var_94_4.from, var_94_3, var_94_6)

	if var_94_0 then
		arg_94_1.totalDamage[var_94_4.from]:add(var_94_2:get(battle.ValueType.normal))
	end

	if arg_94_0:checkOverlaySpecBuffExit(battle.OverlaySpecBuff.sleepy) and var_94_4.isLastDamageSeg and var_94_4.from == battle.DamageFrom.skill and not arg_94_0.scene:beInExtraAttack() and not var_94_4.beHitNotWakeUp then
		arg_94_0:processBeHitWakeUp(arg_94_1)
	end

	if var_94_3 == 0 then
		arg_94_0.scene:runBeAttackDefer(arg_94_0.id)

		return var_94_2, var_94_4
	end

	local var_94_7 = arg_94_0:hp() - var_94_3

	if var_94_0 then
		arg_94_0.scene.play:recordScoreStats(arg_94_1, var_94_3)
	end

	var_94_2:add(var_94_7 < 0 and var_0_0(var_94_7) or 0, battle.ValueType.overFlow)
	var_94_2:add(var_94_3 - var_94_2:get(battle.ValueType.overFlow), battle.ValueType.valid)
	logf.battle.object.beAttack(" %d 攻击-> %d, 当前hp:%f - damage:%f -> 最终hp:%f", arg_94_1 and arg_94_1.seat or -99, arg_94_0.seat, arg_94_0:hp(), var_94_3, var_94_7)
	arg_94_0.totalTakeDamage[var_94_1]:addTable(var_94_2)
	arg_94_0:addHp(-var_94_3)

	if var_94_4.isLastDamageSeg then
		arg_94_0:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderHpChange, {
			lostHp = var_94_2,
			damageArgs = var_94_4,
			damageProcessId = arg_94_3
		})
	end

	arg_94_0:beAttackRecoverMp(arg_94_1, var_94_3, var_94_7)
	arg_94_0:onBeAttack(arg_94_1, var_94_4, {
		isFullHp = var_94_5
	})

	if var_94_0 then
		arg_94_1.totalDamage[var_94_4.from]:addTable(var_94_2, battle.ValueType.overFlow, battle.ValueType.valid)
	end

	if var_94_4.isLastDamageSeg then
		arg_94_0:befoceSetDead(arg_94_1, var_94_3, var_94_4, var_94_2)
		arg_94_0.scene:runBeAttackDefer(arg_94_0.id)
	end

	return var_94_2, var_94_4
end

function ObjectModel.beAttackRecoverMp(arg_95_0, arg_95_1, arg_95_2, arg_95_3)
	if not arg_95_0.cantRecoverMp then
		local var_95_0 = arg_95_0.scene:getSceneAttrCorrect(arg_95_0:serverForce())
		local var_95_1 = gCommonConfigCsv and gCommonConfigCsv.lostOnePercentHpAddMp or 1
		local var_95_2 = var_95_0.lostBloodMp1 or 1
		local var_95_3 = 1 / arg_95_0:hpMax() * 100 * var_95_1 * var_95_2
		local var_95_4 = arg_95_2 * var_95_3

		if arg_95_3 < 0 then
			var_95_4 = (arg_95_2 + arg_95_3) * var_95_3
		end

		local var_95_5 = var_95_4 * (1 + arg_95_0:mp1Recover() + arg_95_0:mpBeAttackRecover())

		arg_95_0:setMP1(arg_95_0:mp1() + var_95_5)
	end

	if arg_95_1 and arg_95_1.curSkill then
		local var_95_6 = arg_95_1.curSkill.cfg
		local var_95_7 = var_95_6.hurtMp1 and var_95_6.hurtMp1 * (1 + arg_95_0:mp1Recover()) or 0

		arg_95_0:setMP1(arg_95_0:mp1() + var_95_7)
	end
end

function ObjectModel.onBeAttack(arg_96_0, arg_96_1, arg_96_2, arg_96_3)
	if arg_96_2.from ~= battle.DamageFrom.skill or arg_96_0.once then
		return
	end

	arg_96_0:onPassive(var_0_4.beAttack, nil, arg_96_2)
	arg_96_0:onPassive(var_0_4.beDamage, arg_96_1, arg_96_2)
	arg_96_0:onPassive(var_0_4.beSpecialDamage, arg_96_1, arg_96_2)
	arg_96_0:onPassive(var_0_4.beNatureDamage, arg_96_1, arg_96_2)
	arg_96_0:onPassive(var_0_4.beNonNatureDamage, arg_96_1, arg_96_2)
	arg_96_0:onPassive(var_0_4.beSpecialNatureDamage, arg_96_1, arg_96_2)
	arg_96_0:onPassive(var_0_4.beDamageIfFullHp, arg_96_1, arg_96_3)
	arg_96_0:onPassive(var_0_4.beStrike, arg_96_1, arg_96_2)
	arg_96_0:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderBeHit, arg_96_0)

	arg_96_0.once = true
end

function ObjectModel.befoceSetDead(arg_97_0, arg_97_1, arg_97_2, arg_97_3, arg_97_4)
	if arg_97_0:hp() > 0 then
		return
	end

	arg_97_3.beAttackToDeath = true

	local var_97_0 = battleEasy.valueTypeTable()

	var_97_0:add(arg_97_4)

	if arg_97_3.from == battle.DamageFrom.skill then
		local var_97_1 = arg_97_0:getCurSkill()

		if var_97_1 then
			local var_97_2 = var_97_1:getTargetDamage(arg_97_0)

			if var_97_2 then
				var_97_0:add(-arg_97_2 + var_97_2)
			end
		end
	end

	arg_97_0:setDead(arg_97_1, var_97_0, {
		force = arg_97_3.ignoreFakeDeath,
		beAttackZOrder = arg_97_3.beAttackZOrder
	})
end

function ObjectModel.isHit(arg_98_0, arg_98_1, arg_98_2)
	local var_98_0 = arg_98_0:hit() - arg_98_1:dodge()

	log.battle.object.isHit(" 加成前目标的闪避率=", arg_98_1:dodge(), "命中率=", arg_98_0:hit())

	if var_98_0 <= 0 then
		return false
	end

	local var_98_1 = var_98_0
	local var_98_2 = arg_98_2.skillHit
	local var_98_3 = 0
	local var_98_4 = ymrand.random(1, 5)

	for iter_98_0 = 1, var_98_4 do
		var_98_3 = ymrand.random()
	end

	local var_98_5 = var_98_3 < var_98_1

	log.battle.object.isHit(" 最终命中率=", var_98_1, "本次随机值=", var_98_3, "是否命中=", var_98_5)

	return var_98_5
end

function ObjectModel.objAddBuffAttr(arg_99_0, arg_99_1, arg_99_2)
	if arg_99_0.beInImmuneAllAttrsDownState and arg_99_0.beInImmuneAllAttrsDownState > 0 then
		-- block empty
	end

	if not ObjectAttrs.AttrsTable[arg_99_1] then
		return
	end

	arg_99_0.attrs:addBuffAttr(arg_99_1, arg_99_2)
end

function ObjectModel.objAddBaseAttr(arg_100_0, arg_100_1, arg_100_2)
	if arg_100_0.beInImmuneAllAttrsDownState and arg_100_0.beInImmuneAllAttrsDownState > 0 then
		-- block empty
	end

	if not ObjectAttrs.AttrsTable[arg_100_1] then
		return
	end

	arg_100_0.attrs:addBaseAttr(arg_100_1, arg_100_2)
end

function ObjectModel.objAttrsCorrect(arg_101_0, arg_101_1)
	arg_101_0.attrs:correct(arg_101_1)
	arg_101_0:setHP(arg_101_0:hpMax(), arg_101_0:hpMax())

	for iter_101_0, iter_101_1 in ipairs(arg_101_1.buffGroup or {}) do
		local var_101_0 = {
			isSceneBuff = true,
			lifeRound = iter_101_1.lifeTime,
			prob = iter_101_1.prob,
			value = iter_101_1.value,
			buffValue1 = iter_101_1.value
		}
		local var_101_1 = addBuffToHero(iter_101_1.id, arg_101_0, nil, var_101_0)

		if var_101_1 then
			arg_101_0:onPassive(var_0_4.additional, arg_101_0, {
				buffCfgId = var_101_1.cfgId
			})
		end
	end
end

function ObjectModel.objAttrsCorrectMonster(arg_102_0, arg_102_1)
	if arg_102_0.doneMonsterCorrect then
		return
	end

	arg_102_0:objAttrsCorrect(arg_102_1)

	arg_102_0.doneMonsterCorrect = true
end

function ObjectModel.objAttrsCorrectScene(arg_103_0, arg_103_1)
	if arg_103_0.doneSceneCorrect then
		return
	end

	arg_103_0:objAttrsCorrect(arg_103_1)

	local var_103_0 = arg_103_0:mp1()

	arg_103_0:setMP1(arg_103_1.addMp1 + var_103_0, arg_103_1.addMp1 + var_103_0)

	arg_103_0.doneSceneCorrect = true
end

function ObjectModel.objAttrsCorrectCP(arg_104_0, arg_104_1, arg_104_2)
	local var_104_0 = math.min(arg_104_1, arg_104_2)
	local var_104_1 = math.max(arg_104_1, arg_104_2)

	if var_104_1 == 0 then
		return
	end

	local var_104_2 = var_104_0 / var_104_1
	local var_104_3 = {}

	for iter_104_0, iter_104_1 in orderCsvPairs(csv.combat_power_correction) do
		local var_104_4 = iter_104_1.combatPowerLimit[arg_104_0.scene.gateType] or math.huge

		if var_104_2 < iter_104_1.fightPointRate[1] and var_104_2 >= iter_104_1.fightPointRate[2] and var_104_4 <= var_104_1 then
			var_104_3 = iter_104_1.attr

			break
		end
	end

	for iter_104_2, iter_104_3 in pairs(var_104_3) do
		arg_104_0:objAddBaseAttr(iter_104_2, iter_104_3)
	end
end

function ObjectModel.onBuffEffectedHolder(arg_105_0, arg_105_1)
	local var_105_0 = arg_105_1.csvCfg.easyEffectFunc

	if arg_105_0.curSkill and arg_105_0.curSkill.chargeRound then
		local var_105_1 = arg_105_0.curSkill.chargeArgs
		local var_105_2 = arg_105_0:getOverlaySpecBuffByIdx("breakCharging")

		if not var_105_1.effectDelay and battle.ControllBuffType[var_105_0] or var_105_2 and var_105_2.mode == 1 then
			arg_105_0.view:proxy():setActionState(battle.SpriteActionTable.standby)
			arg_105_0.curSkill:interrupt(battle.SkillInterruptType.charge, arg_105_1.cfgId)
		end
	end
end

function ObjectModel.getBuffQuery(arg_106_0)
	return arg_106_0.buffs:getQuery()
end

function ObjectModel.clearBuff(arg_107_0, arg_107_1, arg_107_2)
	arg_107_1 = arg_107_1 or function(arg_108_0)
		return true
	end

	if arg_107_2 then
		for iter_107_0, iter_107_1 in arg_107_2:order_pairs() do
			if arg_107_1(iter_107_1) then
				iter_107_1:overClean()
			end
		end

		return
	end

	for iter_107_2, iter_107_3 in arg_107_0:iterBuffs() do
		if arg_107_1(iter_107_3) then
			iter_107_3:overClean()
		end
	end
end

function ObjectModel.deleteAuraBuffs(arg_109_0)
	for iter_109_0, iter_109_1 in arg_109_0.auraBuffs:order_pairs() do
		iter_109_1:overClean()
	end

	arg_109_0.auraBuffs:clear()
end

function ObjectModel.delBuff(arg_110_0, arg_110_1, arg_110_2)
	local var_110_0

	if arg_110_2 then
		var_110_0 = {
			triggerCtrlEnd = true
		}
	end

	local var_110_1

	if type(arg_110_1) == "number" then
		var_110_1 = arg_110_1
	else
		local var_110_2 = table.nums(arg_110_1)

		if var_110_2 == 0 then
			return
		elseif var_110_2 == 1 then
			var_110_1 = next(arg_110_1)
		end
	end

	if var_110_1 then
		local var_110_3 = arg_110_0.buffs:find(var_110_1)

		if var_110_3 then
			var_110_3:over(var_110_0)
		end
	else
		for iter_110_0, iter_110_1 in arg_110_0:iterBuffs() do
			if arg_110_1[iter_110_1.id] then
				iter_110_1:over(var_110_0)
			end
		end
	end
end

function ObjectModel.getBuff(arg_111_0, arg_111_1)
	return arg_111_0.buffs:getQuery():group("cfgId", arg_111_1):first(var_0_6)
end

function ObjectModel.hasBuff(arg_112_0, arg_112_1)
	return arg_112_0:getBuff(arg_112_1) ~= nil
end

function ObjectModel.hasBuffGroup(arg_113_0, arg_113_1)
	return not arg_113_0:queryBuffsWithGroup(arg_113_1):empty(var_0_6)
end

function ObjectModel.hasTypeBuff(arg_114_0, arg_114_1)
	return not arg_114_0.buffs:getQuery():group("easyEffectFunc", arg_114_1):empty()
end

function ObjectModel.getBuffOverlayCount(arg_115_0, arg_115_1)
	local var_115_0 = arg_115_0:getBuff(arg_115_1)

	if not var_115_0 then
		return 0
	end

	return var_115_0:getOverLayCount()
end

function ObjectModel.getBuffGroupArgSum(arg_116_0, arg_116_1, arg_116_2)
	local var_116_0 = 0

	if arg_116_1 == "overlayCount" then
		local var_116_1 = {}

		for iter_116_0, iter_116_1 in arg_116_0:queryBuffsWithGroup(arg_116_2):order_pairs() do
			if not iter_116_1.isOver and not var_116_1[iter_116_1.cfgId] then
				var_116_0 = var_116_0 + iter_116_1:getOverLayCount()
				var_116_1[iter_116_1.cfgId] = true
			end
		end
	else
		for iter_116_2, iter_116_3 in arg_116_0:queryBuffsWithGroup(arg_116_2):order_pairs() do
			if not iter_116_3.isOver then
				var_116_0 = var_116_0 + iter_116_3[arg_116_1]
			end
		end
	end

	return var_116_0
end

function ObjectModel.getBuffGroupFuncSum(arg_117_0, arg_117_1, arg_117_2)
	local var_117_0 = 0

	for iter_117_0, iter_117_1 in arg_117_0:queryBuffsWithGroup(arg_117_2):order_pairs() do
		if not iter_117_1.isOver then
			var_117_0 = var_117_0 + iter_117_1[arg_117_1](iter_117_1)
		end
	end

	return var_117_0
end

function ObjectModel.getSameBuffCount(arg_118_0, arg_118_1)
	return arg_118_0.buffs:getQuery():group("cfgId", arg_118_1):count()
end

function ObjectModel.getNatureType(arg_119_0, arg_119_1)
	local var_119_0 = arg_119_0:getNature(2)

	if not var_119_0 or arg_119_1 == 1 then
		return arg_119_0:getNature(1)
	else
		return var_119_0
	end
end

function ObjectModel.getNature(arg_120_0, arg_120_1)
	local var_120_0 = arg_120_0:getOverlaySpecBuffData(battle.OverlaySpecBuff.changeObjNature)

	if var_120_0.getType then
		local var_120_1 = var_120_0:getType(arg_120_1)

		if var_120_1 and var_120_1 > 0 then
			return var_120_1
		end
	end

	if arg_120_1 == 1 then
		return arg_120_0.natureType
	else
		return arg_120_0.natureType2
	end
end

function ObjectModel.getExtraRound(arg_121_0, arg_121_1)
	local var_121_0 = 0 + (arg_121_0:getEventByKey(battle.ExRecordEvent.rebornRound) or 0)

	if arg_121_1 then
		var_121_0 = var_121_0 - (arg_121_0:getEventByKey(battle.ExRecordEvent.extraBattleRound) or 0)
	end

	return var_121_0
end

function ObjectModel.getBattleRound(arg_122_0, arg_122_1, arg_122_2)
	return (arg_122_1 == 1 and arg_122_0.battleRound[1] or arg_122_0.battleRound[2]) + arg_122_0:getExtraRound(arg_122_2)
end

function ObjectModel.getBattleRoundAllWave(arg_123_0, arg_123_1, arg_123_2)
	return (arg_123_1 == 1 and arg_123_0.battleRoundAllWave[1] or arg_123_0.battleRoundAllWave[2]) + arg_123_0:getExtraRound(arg_123_2)
end

function ObjectModel.getRealPos(arg_124_0)
	return arg_124_0.seat
end

function ObjectModel.frontOrBack(arg_125_0)
	if arg_125_0.seat <= 3 or arg_125_0.seat <= 9 and arg_125_0.seat >= 7 then
		return 1
	else
		return 2
	end
end

function ObjectModel.updAttackerCurSkillTab(arg_126_0, arg_126_1, arg_126_2)
	if not arg_126_1:isNormalSkillType() then
		return
	end

	local var_126_0 = table.length(arg_126_0.attackerCurSkill)
	local var_126_1 = arg_126_0.attackerCurSkill[var_126_0]

	if arg_126_2 then
		if var_126_1 and var_126_1.id == arg_126_1.id and var_126_1.owner.id == arg_126_1.owner.id then
			table.remove(arg_126_0.attackerCurSkill, var_126_0)
		end
	elseif not var_126_1 or var_126_1 and var_126_1.id ~= arg_126_1.id and var_126_1.owner.id ~= arg_126_1.owner.id then
		table.insert(arg_126_0.attackerCurSkill, arg_126_1)
	end
end

function ObjectModel.getStar(arg_127_0)
	return arg_127_0.star
end

function ObjectModel.cantBeSelectCheck(arg_128_0, arg_128_1)
	if arg_128_0:checkOverlaySpecBuffExit("leave") then
		return true
	end

	if arg_128_0:checkOverlaySpecBuffExit("stealth") then
		for iter_128_0, iter_128_1 in arg_128_0:ipairsOverlaySpecBuffTo("stealth", arg_128_1.fromObj) do
			if battleEasy.isSameSkillType(arg_128_1.skillFormulaType, battle.SkillFormulaType.resumeHp) then
				if iter_128_1.cantBeHealHintSwitch or arg_128_1.fromObj.force ~= arg_128_0.force then
					return true
				end
			elseif arg_128_1.skillFormulaType == nil or battleEasy.isSameSkillType(arg_128_1.skillFormulaType, battle.SkillFormulaType.damage) then
				return true
			end
		end
	end

	if arg_128_0:checkOverlaySpecBuffExit("depart") then
		for iter_128_2, iter_128_3 in arg_128_0:ipairsOverlaySpecBuffTo("depart", arg_128_1.fromObj) do
			if battleEasy.isSameSkillType(arg_128_1.skillFormulaType, battle.SkillFormulaType.resumeHp) then
				if iter_128_3.cantBeHealHintSwitch then
					return true
				end
			elseif arg_128_1.skillFormulaType == nil or battleEasy.isSameSkillType(arg_128_1.skillFormulaType, battle.SkillFormulaType.damage) then
				return true
			end
		end
	end

	return false
end

function ObjectModel.cantAttackCheck(arg_129_0, arg_129_1)
	local var_129_0 = false

	if arg_129_0:checkOverlaySpecBuffExit("leave") then
		for iter_129_0, iter_129_1 in arg_129_0:ipairsOverlaySpecBuffTo("leave", arg_129_1.fromObj) do
			if not iter_129_1.canAttack then
				var_129_0 = true
			end
		end
	end

	local var_129_1 = false

	if arg_129_0:checkOverlaySpecBuffExit("depart") then
		for iter_129_2, iter_129_3 in arg_129_0:ipairsOverlaySpecBuffTo("depart", arg_129_1.fromObj) do
			if not iter_129_3.canAttack then
				var_129_0 = true
			end
		end
	end

	if arg_129_0:checkOverlaySpecBuffExit("stun") or arg_129_0:checkOverlaySpecBuffExit("changeImage") or arg_129_0:checkOverlaySpecBuffExit("freeze") or arg_129_0:checkOverlaySpecBuffExit("sleepy") or var_129_0 or var_129_1 then
		return true
	end

	return false
end

function ObjectModel.cantBeAddBuffCheck(arg_130_0, arg_130_1)
	if not arg_130_1.fromObj or arg_130_1.fromObj.id ~= arg_130_0.id then
		for iter_130_0, iter_130_1 in arg_130_0:ipairsOverlaySpecBuffTo("leave", arg_130_1.fromObj, arg_130_1) do
			return true
		end

		if arg_130_0:checkOverlaySpecBuffExit("stealth") then
			for iter_130_2, iter_130_3 in arg_130_0:ipairsOverlaySpecBuffTo("stealth", arg_130_1.fromObj, arg_130_1) do
				if iter_130_3.cantBeAttackSwitch then
					if iter_130_3.cantBeAddBuffSwitch then
						return true
					elseif not iter_130_3.cantBeAddBuffSwitch and arg_130_1.fromObj and arg_130_1.fromObj.force ~= arg_130_0.force then
						return true
					end
				end
			end
		end

		if arg_130_0:checkOverlaySpecBuffExit("depart") then
			for iter_130_4, iter_130_5 in arg_130_0:ipairsOverlaySpecBuffTo("depart", arg_130_1.fromObj, arg_130_1) do
				if iter_130_5.leaveSwitch then
					return true
				end

				if iter_130_5.cantBeAttackSwitch then
					if iter_130_5.cantBeAddBuffSwitch then
						return true
					elseif not iter_130_5.cantBeAddBuffSwitch and arg_130_1.fromObj and arg_130_1.fromObj.force ~= arg_130_0.force then
						return true
					end
				end
			end
		end
	end

	return false
end

function ObjectModel.cantBeAttackCheck(arg_131_0, arg_131_1)
	if arg_131_0:checkOverlaySpecBuffExit("leave") then
		return true
	end

	if arg_131_0:checkOverlaySpecBuffExit("stealth") then
		for iter_131_0, iter_131_1 in arg_131_0:ipairsOverlaySpecBuffTo("stealth", arg_131_1.fromObj) do
			if iter_131_1.cantBeAttackSwitch then
				return true
			end
		end
	end

	if arg_131_0:checkOverlaySpecBuffExit("depart") then
		for iter_131_2, iter_131_3 in arg_131_0:ipairsOverlaySpecBuffTo("depart", arg_131_1.fromObj) do
			if iter_131_3.cantBeAttackSwitch then
				return true
			end
		end
	end

	return false
end

function ObjectModel.cantUseSkillCheck(arg_132_0, arg_132_1)
	if arg_132_0:checkOverlaySpecBuffExit("silence") then
		for iter_132_0, iter_132_1 in arg_132_0:ipairsOverlaySpecBuff("silence") do
			if arg_132_1.skillId and iter_132_1.closeSkill[arg_132_1.skillId] then
				return true
			end

			if arg_132_1.skillType2 and iter_132_1.closeSkillType2[arg_132_1.skillType2] then
				return true
			end
		end
	end

	if arg_132_0:checkOverlaySpecBuffExit("confusion") then
		for iter_132_2, iter_132_3 in arg_132_0:ipairsOverlaySpecBuff("confusion") do
			if arg_132_1.skillType2 and iter_132_3.closeSkillType2[arg_132_1.skillType2] then
				return true
			end
		end
	end

	if arg_132_1.skillType2 and arg_132_0:isSKillType2Close(arg_132_1.skillType2) then
		return true
	end

	return false
end

local var_0_8 = {
	[battle.ObjectLogicState.cantBeSelect] = ObjectModel.cantBeSelectCheck,
	[battle.ObjectLogicState.cantAttack] = ObjectModel.cantAttackCheck,
	[battle.ObjectLogicState.cantBeAddBuff] = ObjectModel.cantBeAddBuffCheck,
	[battle.ObjectLogicState.cantBeAttack] = ObjectModel.cantBeAttackCheck,
	[battle.ObjectLogicState.cantUseSkill] = ObjectModel.cantUseSkillCheck
}

function ObjectModel.isLogicStateExit(arg_133_0, arg_133_1, arg_133_2)
	return var_0_8[arg_133_1](arg_133_0, arg_133_2 or {})
end

function ObjectModel.addExRecord(arg_134_0, arg_134_1, arg_134_2, ...)
	arg_134_0.scene.extraRecord:addExRecord(arg_134_1, arg_134_2, arg_134_0.id, ...)
end

function ObjectModel.getEventByKey(arg_135_0, arg_135_1, ...)
	return arg_135_0.scene.extraRecord:getEventByKey(arg_135_1, arg_135_0.id, ...)
end

function ObjectModel.cleanEventByKey(arg_136_0, arg_136_1, ...)
	return arg_136_0.scene.extraRecord:cleanEventByKey(arg_136_1, arg_136_0.id, ...)
end

function ObjectModel.effectPowerControl(arg_137_0, arg_137_1, arg_137_2)
	local var_137_0 = arg_137_0.effectPower[arg_137_1]

	if not var_137_0 then
		return true
	end

	if type(var_137_0) == "table" then
		if arg_137_2 and var_137_0[arg_137_2] == 0 then
			return false
		end
	elseif var_137_0 == 0 then
		return false
	end

	return true
end

function ObjectModel.serverForce(arg_138_0)
	return arg_138_0.scene.play.operateForce == 1 and arg_138_0.force or 3 - arg_138_0.force
end

function ObjectModel.serverSeat(arg_139_0)
	return arg_139_0.scene.play.operateForce == 1 and arg_139_0.seat or battleEasy.mirrorSeat(arg_139_0.seat)
end

function ObjectModel.getTakeDamageRecord(arg_140_0, arg_140_1, arg_140_2)
	local var_140_0 = 0

	if arg_140_2 then
		var_140_0 = arg_140_0.totalTakeDamage[arg_140_0.scene.play.curWave]:get(arg_140_1)
	else
		for iter_140_0, iter_140_1 in ipairs(arg_140_0.totalTakeDamage) do
			var_140_0 = var_140_0 + iter_140_1:get(arg_140_1)
		end
	end

	return var_140_0
end

function ObjectModel.needAlterForce(arg_141_0)
	if not arg_141_0.curSkill then
		return false
	end

	if arg_141_0:isSameForce(arg_141_0:getCurTarget()) and (arg_141_0:isBeInConfusion() or arg_141_0:isBeInSneer()) and arg_141_0.curSkill:isSameType(battle.SkillFormulaType.damage) then
		return true
	end

	return false
end

function ObjectModel.triggerOriginEnvCheck(arg_142_0, arg_142_1, arg_142_2)
	if arg_142_0.triggerEnv[arg_142_1]:empty() then
		return false
	end

	return arg_142_0.triggerEnv[arg_142_1]:front() == arg_142_2
end

function ObjectModel.updateSkillState(arg_143_0, arg_143_1)
	arg_143_0.skillsMap = {}

	for iter_143_0, iter_143_1 in arg_143_0:iterSkills() do
		iter_143_1:updateStateInfoTb()

		if arg_143_1 and iter_143_1.skillType2 == battle.MainSkillType.BigSkill and iter_143_1.stateInfoTb.canSpell and arg_143_0.unitCfg.combinationSkillId then
			local var_143_0 = arg_143_0.unitCfg.combinationSkillId

			if arg_143_0.passiveSkills[var_143_0] and arg_143_0.passiveSkills[var_143_0]:isCanUseCombineSkill(battle.CombineSkillType.spellBigSkill) then
				arg_143_0.skillsMap[iter_143_0] = var_143_0
				arg_143_0.skills[var_143_0] = arg_143_0.passiveSkills[var_143_0]

				arg_143_0.skills[var_143_0]:updateStateInfoTb()
			end
		end
	end
end

function ObjectModel.getBaseAttr(arg_144_0, arg_144_1)
	if arg_144_0.multiShapeTb then
		return arg_144_0.multiShapeTb[1] == 1 and arg_144_0.attrs.base[arg_144_1] or arg_144_0.attrs.base2[arg_144_1]
	end

	return arg_144_0.attrs.base[arg_144_1]
end

function ObjectModel.getRealFinalAttr(arg_145_0, arg_145_1)
	if arg_145_0.multiShapeTb then
		return arg_145_0.multiShapeTb[1] == 1 and arg_145_0.attrs.final[arg_145_1] or arg_145_0.attrs:getBase2RealFinalAttr(arg_145_1)
	end

	return arg_145_0.attrs.final[arg_145_1]
end

function ObjectModel.cowPreCalcRecord(arg_146_0)
	if arg_146_0.scene.play.preCalcLethalDatas then
		local function var_146_0(arg_147_0)
			return not arg_147_0:checkToObj() or not arg_147_0:checkCondition()
		end

		for iter_146_0, iter_146_1 in arg_146_0:ipairsOverlaySpecBuff(battle.OverlaySpecBuff.lethalProtect, var_146_0) do
			arg_146_0.scene.play.preCalcLethalDatas[1][arg_146_0.id] = true

			break
		end

		if not arg_146_0:checkOverlaySpecBuffExit(battle.OverlaySpecBuff.lethalProtect) then
			table.insert(arg_146_0.scene.play.preCalcLethalDatas[2], arg_146_0.id)
		end
	end
end

local var_0_9 = {
	[game.GATE_TYPE.crossArena] = function(arg_148_0)
		local var_148_0 = arg_148_0.scene
		local var_148_1 = var_148_0:getSceneAttrCorrect(arg_148_0:serverForce())
		local var_148_2 = 1

		if var_148_0.play.curWave == 1 or var_148_0.play.curWave == 3 then
			var_148_2 = var_148_1.slayAddMp1Fix and var_148_1.slayAddMp1Fix[1] or 1
		else
			var_148_2 = var_148_1.slayAddMp1Fix and var_148_1.slayAddMp1Fix[2] or 1
		end

		return var_148_2
	end
}

local function var_0_10(arg_149_0, arg_149_1)
	local var_149_0 = arg_149_1 * (1 + arg_149_0:mp1Recover())

	arg_149_0:setMP1(arg_149_0:mp1() + var_149_0)
end

function ObjectModel.addAttackerMpOnSelfDead(arg_150_0, arg_150_1)
	if not arg_150_1 or arg_150_1.id == arg_150_0.id or not arg_150_0:effectPowerControl(battle.EffectPowerType.killAddMp1) then
		return
	end

	local var_150_0 = var_0_9[arg_150_0.scene.gateType] and var_0_9[arg_150_0.scene.gateType](arg_150_1) or 1
	local var_150_1 = gCommonConfigCsv and gCommonConfigCsv.slayAddMp or 0

	var_0_10(arg_150_1, var_150_1 * var_150_0)
	battleEasy.deferNotify(nil, "showMP1Award", {
		mp = ":" .. tostring(var_150_1),
		key = tostring(arg_150_1)
	})

	if arg_150_1.curSkill and arg_150_1.curSkill.skillType == battle.SkillType.PassiveCombine then
		local var_150_2 = arg_150_1.combineObj

		var_0_10(var_150_2, var_150_1)
		battleEasy.deferNotify(nil, "showMP1Award", {
			mp = ":" .. tostring(var_150_1),
			key = tostring(var_150_2)
		})
	end
end

function ObjectModel.getSummonerLevel(arg_151_0)
	return arg_151_0.level
end

function ObjectModel.setCsvObject(arg_152_0, arg_152_1)
	arg_152_0.csvObject = arg_152_1
end

function ObjectModel.getCsvObject(arg_153_0)
	return arg_153_0.csvObject
end

function ObjectModel.toHumanString(arg_154_0)
	return string.format("ObjectModel: %s(%s)", arg_154_0.id, arg_154_0.seat)
end

require("battle.models.object_buff")
