local var_0_0 = class("PersonalSkillChooseView", Dialog)
local var_0_1 = {
	ALL = 1,
	UNLOCKED = 2,
	NOT_UNLOCK = 4,
	CAN_UNLOCK = 3
}

var_0_0.RESOURCE_FILENAME = "personal_skill_choose.json"
var_0_0.RESOURCE_BINDING = {
	subList = "skillSubList",
	conditionList = "conditionList",
	descList = "descList",
	itemSkill = "skillItem",
	skillPanel = "skillPanel",
	skillName = "skillName",
	conditionRemove = "conditionRemove",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	title = {
		varname = "title",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	title1 = {
		varname = "title1",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	["btnSave.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	btnSave = {
		varname = "btnSave",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSaveClick")
			}
		}
	},
	["btnRemove.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	btnRemove = {
		varname = "btnRemove",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRemoveClick")
			}
		}
	},
	leftList = {
		varname = "skillList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 4,
				data = bindHelper.self("skillDatas"),
				item = bindHelper.self("skillSubList"),
				cell = bindHelper.self("skillItem"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = csv.skill[arg_1_3.skillIdx]

					arg_1_1:get("icon"):texture(var_1_0.iconRes)
					arg_1_1:get("selected"):hide()
					arg_1_1:get("used"):visible(arg_1_3.inUse or arg_1_3.isUse)
					arg_1_1:get("locked"):visible(arg_1_3.unlocked ~= var_0_1.UNLOCKED)

					if arg_1_3.isUse then
						arg_1_1:get("used"):get("txt"):text(gLanguageCsv.haveUse)
					end

					arg_1_1:get("selected"):visible(arg_1_3.selectSign or false)
					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onClickCell")
			}
		}
	}
}

function var_0_0.onCreate(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0.selectFigureId = arg_2_1
	arg_2_0.num = arg_2_3
	arg_2_0.selectSkill = idler.new(arg_2_2)
	arg_2_0.curfigureId = idler.new(arg_2_2)
	arg_2_0.skillDatas = idlers.new()

	arg_2_0:initModel()
	idlereasy.any({
		arg_2_0.figures,
		arg_2_0.figure,
		arg_2_0.skillFigure,
		arg_2_0.curfigureId
	}, function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		local var_3_0 = {}
		local var_3_1 = {}
		local var_3_2 = arg_3_3[arg_2_1] or {
			arg_2_1
		}

		for iter_3_0, iter_3_1 in pairs(var_3_2) do
			var_3_1[iter_3_1] = true
		end

		local var_3_3 = true
		local var_3_4 = arg_2_0.selectSkill:read()

		for iter_3_2, iter_3_3 in csvPairs(gRoleFigureCsv) do
			if iter_3_3.skills[1] and iter_3_3.hide == 0 then
				local var_3_5 = arg_3_1[iter_3_2] and var_0_1.UNLOCKED or var_0_1.NOT_UNLOCK
				local var_3_6 = iter_3_2 == arg_3_4
				local var_3_7 = var_3_1[iter_3_2] or false

				if var_3_6 then
					var_3_7 = false
				end

				if iter_3_2 == var_3_4 then
					var_3_3 = false
				end

				table.insert(var_3_0, {
					id = iter_3_2,
					unlocked = var_3_5,
					inUse = var_3_6,
					isUse = var_3_7,
					showIdx = iter_3_3.showIdx,
					skillIdx = iter_3_3.skills[1]
				})
			end
		end

		table.sort(var_3_0, function(arg_4_0, arg_4_1)
			if arg_4_0.unlocked ~= arg_4_1.unlocked then
				return arg_4_0.unlocked < arg_4_1.unlocked
			end

			if arg_4_0.showIdx ~= arg_4_1.showIdx then
				return arg_4_0.showIdx > arg_4_1.showIdx
			end

			return arg_4_0.id < arg_4_1.id
		end)

		if var_3_3 then
			arg_2_0.selectSkill:set(var_3_0[1].id)
		end

		arg_2_0.skillDatas:update(var_3_0)
	end)
	arg_2_0.selectSkill:addListener(function(arg_5_0, arg_5_1)
		local var_5_0

		for iter_5_0, iter_5_1 in arg_2_0.skillDatas:ipairs() do
			local var_5_1 = iter_5_1:proxy()

			if var_5_1.id == arg_5_1 then
				var_5_1.selectSign = false
			end

			if var_5_1.id == arg_5_0 then
				var_5_1.selectSign = true
				var_5_0 = var_5_1
			end
		end

		arg_2_0.skillDatas:notify()
		arg_2_0:setSkillInfo(var_5_0)
	end)
	Dialog.onCreate(arg_2_0)
end

function var_0_0.initModel(arg_6_0)
	arg_6_0.figure = gGameModel.role:getIdler("figure")
	arg_6_0.figures = gGameModel.role:getIdler("figures")
	arg_6_0.skillFigure = gGameModel.role:getIdler("skill_figures")
end

function var_0_0.setSkillInfo(arg_7_0, arg_7_1)
	local var_7_0 = gRoleFigureCsv[arg_7_1.id]
	local var_7_1 = csv.skill[arg_7_1.skillIdx]
	local var_7_2 = var_7_0.name
	local var_7_3

	if arg_7_1.unlocked == var_0_1.UNLOCKED then
		var_7_3 = string.format(gLanguageCsv.skillUseTip, var_7_2)
	else
		var_7_3 = string.format(gLanguageCsv.skillActiveTip, var_7_2)
	end

	arg_7_0.skillName:text(var_7_1.skillName)
	beauty.textScroll({
		isRich = true,
		list = arg_7_0.descList,
		strs = "#C0x5B545B#" .. var_7_1.describe
	})
	beauty.textScroll({
		isRich = true,
		align = "center",
		list = arg_7_0.conditionList,
		strs = "#C0x57472e#" .. var_7_3
	})
	arg_7_0.skillPanel:get("icon"):texture(var_7_1.iconRes)
	arg_7_0.btnSave:visible(not arg_7_1.isUse and arg_7_1.unlocked == var_0_1.UNLOCKED)
	arg_7_0.btnRemove:visible(arg_7_1.inUse)
	arg_7_0.conditionRemove:visible(false)
end

function var_0_0.onSaveClick(arg_8_0)
	local var_8_0 = arg_8_0.selectSkill:read()

	gGameApp:requestServer("/game/role/figure/skill/switch", function(arg_9_0)
		if arg_9_0 then
			arg_8_0.curfigureId:set(var_8_0)
		end

		arg_8_0:onClose()
	end, arg_8_0.selectFigureId, var_8_0, arg_8_0.num - 1)
end

function var_0_0.onRemoveClick(arg_10_0)
	gGameApp:requestServer("/game/role/figure/skill/switch", function(arg_11_0)
		if arg_11_0 then
			arg_10_0.curfigureId:set(-1)
		end

		arg_10_0:onClose()
	end, arg_10_0.selectFigureId, -1, arg_10_0.num - 1)
end

function var_0_0.onClickCell(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	arg_12_0.selectSkill:set(arg_12_3.id)
end

return var_0_0
