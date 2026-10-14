local var_0_0 = class("HandbookSkillView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "handbook_skill.json"
var_0_0.RESOURCE_BINDING = {
	skillItem = "skillItem",
	panel = "panel",
	["panel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("skillDatas"),
				item = bindHelper.self("skillItem"),
				itemAction = {
					isAction = true,
					alwaysShow = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("textLVNum"):text(arg_1_3.skillLevel)
					uiEasy.setSkillInfoToItems({
						name = arg_1_1:get("textSkillName"),
						icon = arg_1_1:get("imgIcon"),
						type1 = arg_1_1:get("imgFlag")
					}, arg_1_3.skillId)
					bind.touch(arg_1_0, arg_1_1:get("btnInfo"), {
						methods = {
							ended = functools.partial(arg_1_0.clickItem, arg_1_3)
						}
					})
					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.clickItem, arg_1_3)
						}
					})
				end
			},
			handlers = {
				clickItem = bindHelper.self("onShowSkillInfo")
			}
		}
	}
}

function var_0_0.onCreate(arg_2_0, arg_2_1)
	arg_2_0.cardIdIdler = arg_2_1.selCardId()
	arg_2_0.skillDatas = idlertable.new({})

	idlereasy.when(arg_2_0.cardIdIdler, function(arg_3_0, arg_3_1)
		if arg_3_1 == 0 then
			return
		end

		local var_3_0 = {}
		local var_3_1 = csv.cards[arg_3_1]

		for iter_3_0, iter_3_1 in csvPairs(var_3_1.skillList) do
			local var_3_2 = 1

			if csv.skill[iter_3_1].skillType2 == battle.MainSkillType.PassiveSkill then
				var_3_2 = 2
			end

			table.insert(var_3_0, {
				skillLevel = 1,
				skillId = iter_3_1,
				skillPassive = var_3_2
			})
		end

		table.sort(var_3_0, function(arg_4_0, arg_4_1)
			if arg_4_0.skillPassive ~= arg_4_1.skillPassive then
				return arg_4_0.skillPassive < arg_4_1.skillPassive
			end

			return arg_4_0.skillId < arg_4_1.skillId
		end)
		arg_2_0.skillDatas:set(var_3_0)

		local var_3_3 = csv.unit[var_3_1.unitID]
		local var_3_4 = {}

		table.insert(var_3_4, var_3_3.natureType)

		if var_3_3.natureType2 then
			table.insert(var_3_4, var_3_3.natureType2)
		end
	end)
end

function var_0_0.onShowSkillInfo(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = gGameUI:stackUI("common.skill_detail", nil, {
		clickClose = true,
		dispatchNodes = arg_5_0.list
	}, {
		skillId = arg_5_2.skillId,
		skillLevel = arg_5_2.skillLevel,
		cardId = arg_5_0.cardIdIdler:read(),
		star = uiEasy.getMaxStar(arg_5_0.cardIdIdler:read())
	}, "handbook"):getResourceNode()
	local var_5_1, var_5_2 = var_5_0:xy()

	var_5_0:x(var_5_1 - 165)
end

return var_0_0
