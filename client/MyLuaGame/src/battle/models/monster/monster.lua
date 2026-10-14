globals.MonsterModel = class("MonsterModel", ObjectModel)

function MonsterModel.ctor(arg_1_0, arg_1_1, arg_1_2)
	ObjectModel.ctor(arg_1_0, arg_1_1, arg_1_2)
end

function MonsterModel.init(arg_2_0, arg_2_1)
	arg_2_0:initMonsterSkillData(arg_2_1)

	arg_2_0.isMonster = arg_2_1.isMonster
	arg_2_0.isBoss = arg_2_1.isBoss
	arg_2_0.showLevel = arg_2_1.showLevel
	arg_2_0.monsterCfg = gMonsterCsv[arg_2_0.scene.sceneID][arg_2_0.scene.play.curWave]

	ObjectModel.init(arg_2_0, arg_2_1)

	arg_2_0.star = arg_2_0.data.star or arg_2_0.unitCfg.star or 0
end

function MonsterModel.initMonsterSkillData(arg_3_0, arg_3_1)
	arg_3_1.skills = {}

	local var_3_0 = arg_3_1.skills
	local var_3_1 = csv.unit[arg_3_1.roleId]

	for iter_3_0, iter_3_1 in ipairs(var_3_1.skillList) do
		if not var_3_0[iter_3_1] then
			var_3_0[iter_3_1] = arg_3_1.skillLevel
		end
	end

	for iter_3_2, iter_3_3 in ipairs(var_3_1.passiveSkillList) do
		if not var_3_0[iter_3_3] then
			var_3_0[iter_3_3] = arg_3_1.skillLevel
		end
	end
end

function MonsterModel.onInitAttributes(arg_4_0)
	if arg_4_0.type == battle.ObjectType.Summon or arg_4_0.type == battle.ObjectType.SummonFollow then
		return ObjectModel.onInitAttributes(arg_4_0)
	end

	arg_4_0:setBaseData(arg_4_0:getMonsterData())
end

function MonsterModel.checkUnitCheat(arg_5_0)
	if ANTI_AGENT then
		return
	end

	checkSpecificCsvCheat("unit", itertools.ivalues({
		arg_5_0.unitID
	}))
end

function MonsterModel.getMonsterData(arg_6_0)
	arg_6_0:checkUnitCheat()

	local var_6_0 = csvClone(csv.base_attribute[arg_6_0.attributeType].base_attribute[arg_6_0.level])

	for iter_6_0, iter_6_1 in ipairs(game.ATTRDEF_TABLE) do
		if not var_6_0[iter_6_1] then
			var_6_0[iter_6_1] = 0
		end

		local var_6_1 = arg_6_0.unitCfg[iter_6_1 .. "C"] or 1

		var_6_0[iter_6_1] = var_6_0[iter_6_1] * var_6_1

		local var_6_2 = arg_6_0.unitCfg[iter_6_1 .. "Grow"] or 0

		var_6_0[iter_6_1] = var_6_0[iter_6_1] + var_6_2 * arg_6_0.level
	end

	return var_6_0
end

function MonsterModel.getSummonerLevel(arg_7_0)
	return arg_7_0.showLevel
end
