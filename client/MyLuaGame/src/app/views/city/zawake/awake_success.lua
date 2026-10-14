local var_0_0 = 0.08
local var_0_1 = require("app.views.city.zawake.tools")
local var_0_2 = cc.load("mvc").ViewBase
local var_0_3 = class("ZawakeAwakeSuccessView", var_0_2)

var_0_3.RESOURCE_FILENAME = "zawake_awake_success.json"
var_0_3.RESOURCE_BINDING = {
	centerPos = "centerPos",
	name11 = "name11",
	item = "item",
	jiqi2 = "jiqi2",
	pos = "pos",
	name21 = "name21",
	jiqi1 = "jiqi1",
	name2 = "name2",
	txt1 = "txt1",
	name1 = "name1",
	skillPanel = "skillPanel",
	innerList = "innerList",
	cardImg = "cardImg",
	bg = {
		binds = {
			event = "click",
			method = bindHelper.self("onClose")
		}
	},
	["skillPanel.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = ui.COLORS.NORMAL.ALERT_ORANGE
				}
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 3,
				data = bindHelper.self("lableDatas"),
				item = bindHelper.self("innerList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("keyText"):text(arg_1_3.key)
					arg_1_1:get("valText"):text(arg_1_3.val)
					adapt.oneLinePos(arg_1_1:get("keyText"), arg_1_1:get("valText"))

					local var_1_0 = arg_1_0:getIdx(arg_1_2).k
					local var_1_1 = var_0_0 * (1 + var_1_0)

					uiEasy.setExecuteSequence({
						arg_1_1:get("keyText"),
						arg_1_1:get("valText")
					}, {
						delayTime = var_1_1
					})
				end
			}
		}
	}
}

function var_0_3.onCreate(arg_2_0, arg_2_1)
	arg_2_0.stageID = arg_2_1.stageID

	local var_2_0 = arg_2_1.level

	arg_2_0.cb = arg_2_1.cb

	local var_2_1 = arg_2_1.cfg
	local var_2_2 = arg_2_1.zawakeID

	uiEasy.setTitleEffect(arg_2_0.centerPos, "xjiesuan_juexingzi")

	local var_2_3 = {}

	for iter_2_0 = 1, math.huge do
		local var_2_4 = var_2_1["attrType" .. iter_2_0]
		local var_2_5 = var_2_1["attrNum" .. iter_2_0]

		if var_2_4 == nil or var_2_4 == 0 then
			break
		end

		table.insert(var_2_3, {
			key = getLanguageAttr(var_2_4),
			val = "+" .. dataEasy.getAttrValueString(var_2_4, var_2_5)
		})
	end

	arg_2_0.lableDatas = idlers.newWithMap(var_2_3)

	arg_2_0:updateSpine(arg_2_0.jiqi1, var_2_0)
	arg_2_0:updateSpine(arg_2_0.jiqi2, var_2_0 + 1)

	if var_2_0 == 0 then
		arg_2_0.name1:text(gLanguageCsv.noAwake)
		arg_2_0.name11:hide()
	else
		arg_2_0.name1:text(string.format(gLanguageCsv.zawakeStageLevel, gLanguageCsv["symbolRome" .. arg_2_0.stageID]))
		arg_2_0.name11:show()
		arg_2_0.name11:text("- " .. var_2_0)
		adapt.oneLinePos(arg_2_0.name1, arg_2_0.name11, cc.p(-4, 0))
	end

	arg_2_0.name2:text(string.format(gLanguageCsv.zawakeStageLevel, gLanguageCsv["symbolRome" .. arg_2_0.stageID]))
	arg_2_0.name21:text("- " .. var_2_0 + 1)
	adapt.oneLinePos(arg_2_0.name2, arg_2_0.name21, cc.p(-4, 0))
	arg_2_0.skillPanel:hide()

	local var_2_6 = var_0_1.getSkillCfg(var_2_2, var_2_1.skillID)

	if var_2_6 then
		for iter_2_1, iter_2_2 in ipairs(var_2_6) do
			local var_2_7 = arg_2_0.skillPanel:clone()
			local var_2_8 = var_2_7:multiget("skill", "skillText", "name", "iconUp")

			uiEasy.setSkillInfoToItems({
				name = var_2_8.name,
				icon = var_2_8.skill,
				type1 = var_2_8.skillText
			}, iter_2_2.cfg)
			var_2_8.name:text(csv.skill[var_2_1.skillID].skillName .. var_2_8.name:text())
			adapt.oneLinePos(var_2_8.skill, var_2_8.skillText, cc.p(60, 0))
			adapt.oneLinePos(var_2_8.skillText, var_2_8.name, cc.p(20, 0))
			var_2_8.iconUp:x(var_2_8.skill:x() + 60)
			uiEasy.setExecuteSequence(var_2_7, {
				delayTime = 10 * var_0_0
			})
			var_2_7:addTo(arg_2_0.skillPanel:parent(), arg_2_0.skillPanel:z()):xy(arg_2_0.skillPanel:x(), arg_2_0.skillPanel:y() - (iter_2_1 - 1) * arg_2_0.skillPanel:height())
		end
	end

	uiEasy.setExecuteSequence(arg_2_0.cardImg)
	uiEasy.setExecuteSequence(arg_2_0.jiqi2, {
		delayTime = var_0_0
	})
	uiEasy.setExecuteSequence(arg_2_0.name2, {
		delayTime = var_0_0
	})
	uiEasy.setExecuteSequence(arg_2_0.name21, {
		delayTime = var_0_0
	})
end

function var_0_3.updateSpine(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = string.format("zawake/jiqi_%s.skel", arg_3_0.stageID)
	local var_3_1 = "effect_posun_loop"

	if arg_3_2 > 0 then
		var_3_1 = "effect_xiufu_loop" .. arg_3_2
	end

	local var_3_2 = widget.addAnimationByKey(arg_3_1, var_3_0, "effect", var_3_1, 5)

	var_3_2:scale(0.6)
	var_3_2:play(var_3_1)
	var_3_2:xy(arg_3_1:width() / 2, 0)

	if arg_3_0.stageID == 4 then
		local var_3_3 = widget.addAnimationByKey(arg_3_1, var_3_0, "houEffect", "effect_hou_loop", 2)

		var_3_3:scale(0.6)
		var_3_3:play("effect_hou_loop")
		var_3_3:xy(arg_3_1:width() / 2, 0)
	elseif arg_3_0.stageID == 7 then
		local var_3_4 = widget.addAnimationByKey(arg_3_1, "zawake/jiqi_7_hou.skel", "houEffect", var_3_1, 2)

		var_3_4:scale(0.6)
		var_3_4:play(var_3_1)
		var_3_4:xy(arg_3_1:width() / 2, 0)
	end
end

function var_0_3.onClose(arg_4_0)
	arg_4_0:addCallbackOnExit(arg_4_0.cb)
	var_0_2.onClose(arg_4_0)
end

return var_0_3
