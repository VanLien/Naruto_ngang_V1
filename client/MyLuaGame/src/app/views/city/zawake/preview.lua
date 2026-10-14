local var_0_0 = itertools.map(battle.MainSkillType, function(arg_1_0, arg_1_1)
	return arg_1_1, arg_1_0
end)
local var_0_1 = require("app.views.city.zawake.tools")
local var_0_2 = cc.load("mvc").ViewBase
local var_0_3 = class("ZawakePreviewView", Dialog)
local var_0_4 = {
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	-35
}
local var_0_5 = {
	15,
	15,
	5,
	15,
	10,
	30,
	10,
	10
}
local var_0_6 = {
	0.6,
	0.5,
	0.6,
	0.7,
	0.6,
	0.7,
	0.6,
	0.5
}

local function var_0_7(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = string.format("zawake/jiqi_%s.skel", arg_2_1)
	local var_2_1 = "effect_posun_loop"

	if arg_2_2 > 0 then
		var_2_1 = "effect_xiufu_loop" .. arg_2_2
	end

	local var_2_2 = widget.addAnimationByKey(arg_2_0, var_2_0, "effect", var_2_1, 5)

	var_2_2:scale(var_0_6[arg_2_1])
	var_2_2:play(var_2_1)
	var_2_2:xy(arg_2_0:width() / 2 + var_0_4[arg_2_1], var_0_5[arg_2_1])

	if arg_2_1 == 4 then
		local var_2_3 = widget.addAnimationByKey(arg_2_0, var_2_0, "houEffect", "effect_hou_loop", 2)

		var_2_3:scale(var_0_6[arg_2_1])
		var_2_3:play("effect_hou_loop")
		var_2_3:xy(arg_2_0:width() / 2 + var_0_4[arg_2_1], var_0_5[arg_2_1])
	elseif arg_2_1 == 7 then
		local var_2_4 = widget.addAnimationByKey(arg_2_0, "zawake/jiqi_7_hou.skel", "houEffect", var_2_1, 2)

		var_2_4:scale(var_0_6[arg_2_1])
		var_2_4:play(var_2_1)
		var_2_4:xy(arg_2_0:width() / 2 + var_0_4[arg_2_1], var_0_5[arg_2_1])
	end
end

var_0_3.RESOURCE_FILENAME = "zawake_preview.json"
var_0_3.RESOURCE_BINDING = {
	item = "item",
	["bgPanel.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	list = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				backupCached = false,
				data = bindHelper.self("listDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onBeforeBuild = function(arg_3_0)
					arg_3_0:setRenderHint(0)
				end,
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:multiget("bg1", "name", "fullAwake", "ruleBtn", "attrPanel", "skillPanel", "emptyPanel", "icon")

					var_4_0.name:text(string.format("%s%s- %s", gLanguageCsv.effortAdvance, gLanguageCsv["symbolRome" .. arg_4_3.stageID], arg_4_3.cfg.level))
					var_4_0.name:setFontSize(40)

					local var_4_1 = arg_4_3.level >= arg_4_3.cfg.level
					local var_4_2 = var_4_1 and ui.COLORS.NORMAL.ALERT_ORANGE or ui.COLORS.NORMAL.DEFAULT

					text.addEffect(var_4_0.name, {
						color = var_4_2
					})
					itertools.invoke({
						var_4_0.bg1,
						var_4_0.fullAwake,
						var_4_0.attrPanel,
						var_4_0.skillPanel,
						var_4_0.emptyPanel,
						var_4_0.ruleBtn
					}, "hide")

					if arg_4_3.isOpen == var_0_1.STAGE_OPEN_STATE.open then
						var_0_7(var_4_0.icon, arg_4_3.stageID, arg_4_3.level)

						if var_4_1 then
							itertools.invoke({
								var_4_0.bg1,
								var_4_0.fullAwake
							}, "show")
						end

						if not itertools.isempty(arg_4_3.labelDatas) then
							var_4_0.ruleBtn:show()

							local var_4_3 = arg_4_0:box()
							local var_4_4 = arg_4_0:parent():convertToWorldSpace(cc.p(var_4_3.x, var_4_3.y))
							local var_4_5 = {
								x = var_4_4.x + var_4_0.ruleBtn:x() - var_4_0.ruleBtn:width() / 2
							}

							bind.touch(arg_4_0, var_4_0.ruleBtn, {
								methods = {
									ended = functools.partial(arg_4_0.clickUnlock, arg_4_2, arg_4_3, var_4_5)
								}
							})
						end
					else
						local var_4_6 = ccui.ImageView:create(string.format("city/zawake/img_jq%d.png", arg_4_3.stageID))

						var_4_6:anchorPoint(0.5, 0)
						var_4_6:xy(var_4_0.icon:width() / 2 + var_0_4[arg_4_3.stageID], var_0_5[arg_4_3.stageID])
						var_4_6:scale(var_0_6[arg_4_3.stageID])
						var_4_6:addTo(var_4_0.icon, 5, "img")
						cache.setColor2Shader(var_4_6, false, cc.vec4(0.75, 0.75, 0.75, 1))

						if arg_4_3.isOpen == var_0_1.STAGE_OPEN_STATE.close then
							var_4_0.emptyPanel:show()
						end
					end

					if arg_4_3.isOpen ~= var_0_1.STAGE_OPEN_STATE.close then
						local function var_4_7(arg_5_0, arg_5_1, arg_5_2)
							arg_5_0:removeChildByName("noActiveTip")

							local var_5_0
							local var_5_1 = 30
							local var_5_2 = ui.COLORS.NORMAL.RED

							if arg_4_3.isOpen ~= var_0_1.STAGE_OPEN_STATE.open then
								var_5_0 = gLanguageCsv.zawakeNotOpen
								var_5_1 = 40
								var_5_2 = ui.COLORS.NORMAL.ALERT_ORANGE
							elseif not arg_4_3.active then
								var_5_0 = gLanguageCsv.zawakeNoActiveTip
							end

							if var_5_0 then
								if arg_5_2 then
									arg_5_2()
								end

								local var_5_3 = label.create(var_5_0, {
									fontPath = "font/youmi.ttf",
									color = var_5_2,
									fontSize = var_5_1
								})
								local var_5_4 = arg_5_1:box()

								var_5_3:addTo(arg_5_0, 10, "noActiveTip"):anchorPoint(0, 0):xy(var_5_4.x + var_5_4.width, var_5_4.y)

								return true
							end

							return false
						end

						if arg_4_3.skillID > 0 then
							var_4_0.skillPanel:show()

							local var_4_8 = var_4_0.skillPanel:multiget("title", "list", "skill", "skillText", "name", "iconUp")
							local var_4_9 = arg_4_3.skillCfg.cfg

							uiEasy.setSkillInfoToItems({
								name = var_4_8.name,
								icon = var_4_8.skill,
								type1 = var_4_8.skillText
							}, var_4_9)
							var_4_8.name:text(csv.skill[arg_4_3.skillID].skillName .. var_4_8.name:text())
							adapt.setTextScaleWithWidth(var_4_8.name, nil, 600)
							adapt.oneLinePos(var_4_8.title, var_4_8.skill, cc.p(5, 0))
							adapt.oneLinePos(var_4_8.skill, var_4_8.skillText, cc.p(60, 0))
							adapt.oneLinePos(var_4_8.skillText, var_4_8.name, cc.p(20, 0))
							var_4_8.iconUp:x(var_4_8.skill:x() + 60)

							local var_4_10 = var_4_9.zawakeEffect[2] == 1
							local var_4_11 = var_4_10 and var_4_9.describe or var_4_9.zawakeEffectDesc
							local var_4_12 = uiEasy.getStarSkillDesc({
								isZawake = true,
								star = 12,
								skillId = arg_4_3.skillCfg.id,
								cardId = arg_4_3.skillCfg.cardId
							})
							local var_4_13 = eval.doMixedFormula(var_4_11, {
								skillLevel = 1,
								math = math
							}, nil) .. var_4_12

							if var_4_9.zawakeSimpleDesc and var_4_9.zawakeSimpleDesc ~= "" then
								local var_4_14 = var_0_0[var_4_9.skillType2]
								local var_4_15 = ""

								if var_4_14 then
									var_4_15 = gLanguageCsv["zawake" .. var_4_14]
								end

								local var_4_16 = var_4_9.zawakeSimpleType == 1 and gLanguageCsv.zawakeSimpleType1 or gLanguageCsv.zawakeSimpleType2
								local var_4_17 = var_4_9.zawakeSimpleType == 1 and "#C0x5c9970#" or "#C0x5B545B#"

								var_4_13 = string.format("#C0xE69900#[%s%s%s]:\n#F20# \n#F40#\t%s%s", var_4_15, var_4_10 and gLanguageCsv.star or "", var_4_16, var_4_17, var_4_9.zawakeSimpleDesc)
							end

							beauty.textScroll({
								isRich = true,
								fontSize = 40,
								list = var_4_8.list,
								strs = "#C0x5B545B#" .. var_4_13
							})
							var_4_7(var_4_0.skillPanel, var_4_8.name, function()
								adapt.setTextScaleWithWidth(var_4_8.name, nil, 400)
							end)
						else
							var_4_0.attrPanel:show()

							local var_4_18 = var_4_0.attrPanel:get("list")
							local var_4_19 = var_4_0.attrPanel:get("title")
							local var_4_20 = ""

							if arg_4_3.cfg.extraScene[1] == 0 then
								var_4_19:text(gLanguageCsv.zawakeExtraAttr)
							else
								var_4_19:text(gLanguageCsv.zawakeExtraScene)

								local var_4_21 = {}

								for iter_4_0, iter_4_1 in ipairs(arg_4_3.cfg.extraScene) do
									table.insert(var_4_21, gLanguageCsv[game.SCENE_TYPE_STRING_TABLE[iter_4_1]])
								end

								var_4_20 = table.concat(var_4_21, gLanguageCsv.symbolComma) .. "\n"
							end

							local var_4_22 = {}

							for iter_4_2, iter_4_3 in csvMapPairs(arg_4_3.cfg.extraAttrs) do
								table.insert(var_4_22, getLanguageAttr(iter_4_2) .. "+" .. dataEasy.getAttrValueString(iter_4_2, iter_4_3))
							end

							local var_4_23 = "#C0xF76B45#" .. var_4_20 .. table.concat(var_4_22, "  ")

							beauty.textScroll({
								isRich = true,
								fontSize = 40,
								list = var_4_18,
								strs = var_4_23
							})
							var_4_7(var_4_0.attrPanel, var_4_19)
						end
					end
				end
			},
			handlers = {
				clickUnlock = bindHelper.self("onUnlockInfoClick")
			}
		}
	}
}

function var_0_3.onCreate(arg_7_0, arg_7_1)
	Dialog.onCreate(arg_7_0)

	arg_7_0.zawakeID = arg_7_1

	arg_7_0:initModel()

	local var_7_0 = (arg_7_0.zawake or {})[arg_7_1] or {}
	local var_7_1 = {}

	for iter_7_0 = 1, var_0_1.MAXSTAGE do
		for iter_7_1 = 1, var_0_1.MAXLEVEL do
			local var_7_2 = var_0_1.getLevelCfg(arg_7_1, iter_7_0, iter_7_1)

			if var_7_2 and (csvSize(var_7_2.extraAttrs) > 0 or var_7_2.skillID > 0) then
				local var_7_3 = var_0_1.getStagesCfg(arg_7_1, iter_7_0)
				local var_7_4 = var_7_0[iter_7_0] or 0
				local var_7_5, var_7_6 = var_0_1.getActiveCondition(arg_7_1, iter_7_0, var_7_2)

				if var_7_2.skillID > 0 then
					local var_7_7 = var_0_1.getSkillCfg(arg_7_1, var_7_2.skillID)

					if var_7_7 then
						for iter_7_2, iter_7_3 in ipairs(var_7_7) do
							table.insert(var_7_1, {
								cfg = var_7_2,
								stageID = iter_7_0,
								level = var_7_4,
								skillID = var_7_2.skillID,
								skillCfg = iter_7_3,
								isOpen = var_7_3.isOpen,
								showUnlockBtn = showUnlockBtn,
								active = var_7_5,
								labelDatas = var_7_6
							})
						end
					end
				else
					table.insert(var_7_1, {
						cfg = var_7_2,
						stageID = iter_7_0,
						level = var_7_4,
						skillID = var_7_2.skillID,
						isOpen = var_7_3.isOpen,
						showUnlockBtn = showUnlockBtn,
						active = var_7_5,
						labelDatas = var_7_6
					})
				end
			end
		end
	end

	arg_7_0.listDatas:update(var_7_1)
end

function var_0_3.initModel(arg_8_0)
	arg_8_0.zawake = gGameModel.role:read("zawake")
	arg_8_0.listDatas = idlers.newWithMap({})
end

function var_0_3.onUnlockInfoClick(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	if itertools.isempty(arg_9_3.labelDatas) then
		return
	end

	local var_9_0 = "left"

	gGameUI:stackUI("city.zawake.unlock_tips", nil, nil, {
		title = gLanguageCsv.zawakeStageLevelAwake,
		labelDatas = arg_9_3.labelDatas,
		align = var_9_0,
		pos = arg_9_4,
		stageID = arg_9_3.stageID
	})
end

return var_0_3
