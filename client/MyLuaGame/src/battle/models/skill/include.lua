local var_0_0 = {}

globals.battleSkill = var_0_0

require("battle.models.skill.skill")
require("battle.models.skill.passive_skill")
require("battle.models.skill.immediate_skill")
require("battle.models.skill.summon_skill")
require("battle.models.skill.combine_skill")
require("battle.models.skill.helper")

local var_0_1 = {
	[battle.SkillType.NormalSkill] = var_0_0.SkillModel,
	[battle.SkillType.PassiveAura] = var_0_0.BuffSkillModel,
	[battle.SkillType.PassiveSkill] = var_0_0.PassiveSkillModel,
	[battle.SkillType.PassiveSummon] = var_0_0.SummonSkillModel,
	[battle.SkillType.PassiveCombine] = var_0_0.CombineSkillModel
}

function globals.newSkillModel(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = csv.skill[arg_1_2]
	local var_1_1 = var_0_1[var_1_0.skillType]

	if var_1_1 == nil then
		error(string.format("skill type %d not existed", var_1_0.skillType))
	end

	return var_1_1.new(arg_1_0, arg_1_1, var_1_0, arg_1_3, arg_1_4)
end
