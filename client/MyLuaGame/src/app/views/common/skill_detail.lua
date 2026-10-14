local var_0_0 = class("SkillDetailView", Dialog)

var_0_0.RESOURCE_FILENAME = "common_skill_detail.json"
var_0_0.RESOURCE_BINDING = {
	panel = "panel",
	["panel.textLevel"] = "skillLv",
	["panel.textName"] = "skillName",
	["panel.imgType"] = "imgType",
	["panel.imgIcon"] = "imgIcon",
	["panel.textNote"] = "skillType",
	["panel.textNoteType"] = "attackType",
	["panel.textSkillPower"] = "textSkillPower",
	imgBg = "imgBg",
	["panel.textNum"] = "powerNum",
	list = "list"
}

function var_0_0.onCreate(arg_1_0, arg_1_1, arg_1_2)
	arg_1_1.skillLevel = arg_1_1.skillLevel or 1

	local var_1_0 = csv.skill[arg_1_1.skillId]

	if arg_1_1.hideSkillLevel then
		arg_1_0.skillLv:hide()
	else
		arg_1_0.skillLv:text("Lv." .. arg_1_1.skillLevel)
	end

	itertools.invoke({
		arg_1_0.textSkillPower,
		arg_1_0.powerNum
	}, "hide")
	uiEasy.setSkillInfoToItems({
		name = arg_1_0.skillName,
		icon = arg_1_0.imgIcon,
		type1 = arg_1_0.imgType,
		type2 = arg_1_0.skillType,
		target = arg_1_0.attackType
	}, var_1_0)

	if arg_1_1.skillIcon then
		arg_1_0.imgIcon:texture(arg_1_1.skillIcon)
	end

	if arg_1_1.isZawake then
		ccui.ImageView:create("city/drawcard/draw/txt_up.png"):scale(1.2):align(cc.p(1, 1), 200, 190):addTo(arg_1_0.imgIcon, 1, "zawakeUp")

		local var_1_1 = csv.skill[arg_1_1.skillId].zawakeEffect[1]

		arg_1_0.skillName:text(csv.skill[var_1_1].skillName .. arg_1_0.skillName:text())
	end

	local var_1_2 = var_1_0.describe

	if arg_1_1.isZawake and var_1_0.zawakeEffect[1] and var_1_0.zawakeEffect[2] ~= 1 then
		var_1_2 = var_1_0.zawakeEffectDesc
	end

	local var_1_3 = arg_1_1.ignoreStar and "" or uiEasy.getStarSkillDesc(arg_1_1, arg_1_2)
	local var_1_4 = string.gsub(var_1_2, "#C0x5B545B#", "#C0xFFFFFF#")
	local var_1_5, var_1_6 = beauty.textScroll({
		isRich = true,
		fontSize = 40,
		list = arg_1_0.list,
		strs = "#C0xFFFFFF#" .. eval.doMixedFormula(var_1_4, {
			skillLevel = arg_1_1.skillLevel,
			math = math
		}, nil) .. var_1_3
	})
	local var_1_7 = cc.clampf(var_1_6, 250, 750) - 250

	arg_1_0.imgBg:size(arg_1_0.imgBg:size().width, arg_1_0.imgBg:size().height + var_1_7)
	arg_1_0.panel:y(arg_1_0.panel:y() + var_1_7 / 2)
	var_1_5:size(var_1_5:size().width, 250 + var_1_7)
	var_1_5:y(var_1_5:y() - var_1_7 / 2)
	Dialog.onCreate(arg_1_0, {
		clickClose = false,
		noBlackLayer = true
	})
end

return var_0_0
