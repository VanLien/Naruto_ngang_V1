local var_0_0 = class("ChipDetailsView", cc.load("mvc").ViewBase)
local var_0_1 = require("app.views.city.card.chip.tools")

var_0_0.RESOURCE_FILENAME = "common_chip_details.json"
var_0_0.RESOURCE_BINDING = {
	["baseNode.panel.level"] = "level",
	["baseNode.panel"] = "panel",
	["baseNode.panel.icon"] = "icon",
	["baseNode.panel.attrPanel"] = "attrPanel",
	["baseNode.panel.linePanel"] = "linePanel",
	baseNode = "baseNode",
	["baseNode.panel.suitPanel"] = "suitPanel",
	["baseNode.panel.bg2"] = "bg2",
	["baseNode.panel.name"] = "name",
	["baseNode.panel.list"] = "list",
	["baseNode.panel.bg"] = {
		varname = "bg",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0, arg_1_1)
	local var_1_0
	local var_1_1

	if arg_1_1.dbId then
		local var_1_2 = gGameModel.chips:find(arg_1_1.dbId)

		var_1_0 = var_1_2:read("chip_id")
		var_1_1 = var_1_2:read("level")
	else
		var_1_0 = arg_1_1.key
		var_1_1 = 1
	end

	local var_1_3 = {}
	local var_1_4 = csv.chip.chips[var_1_0]

	bind.extend(arg_1_0, arg_1_0.icon, {
		class = "icon_key",
		props = {
			noListener = true,
			data = {
				key = var_1_0
			},
			specialKey = {
				lv = var_1_1
			},
			onNode = function(arg_2_0)
				arg_2_0:get("defaultLv"):hide()
			end
		}
	})
	uiEasy.setIconName(var_1_0, 0, {
		node = arg_1_0.name
	})
	arg_1_0.level:text("Lv" .. var_1_1)

	local var_1_5 = 0
	local var_1_6 = 0
	local var_1_7 = 0

	arg_1_0.list:removeAllChildren()
	arg_1_0.list:setScrollBarEnabled(false)

	local var_1_8, var_1_9 = var_0_1.getAttrByChipId(var_1_0)

	if arg_1_1.dbId then
		var_1_8, var_1_9 = var_0_1.getAttr(arg_1_1.dbId, var_1_1, true, true)
	end

	local var_1_10 = false

	for iter_1_0, iter_1_1 in ipairs(var_1_8) do
		local var_1_11 = iter_1_1.key

		if not var_0_1.ignoreAttr(var_1_11) then
			var_1_10 = true

			local var_1_12 = iter_1_1.val
			local var_1_13 = arg_1_0.attrPanel:clone():show()
			local var_1_14 = var_0_1.getAttrName(var_1_11)

			var_1_13:get("key"):text(var_1_14)
			var_1_13:get("val"):text("+" .. var_1_12)
			arg_1_0.list:pushBackCustomItem(var_1_13)

			var_1_5 = var_1_5 + 1
		end
	end

	if var_1_10 then
		local var_1_15 = arg_1_0.linePanel:clone():show()

		arg_1_0.list:pushBackCustomItem(var_1_15)

		var_1_6 = var_1_6 + 1
	end

	local var_1_16 = false

	for iter_1_2, iter_1_3 in ipairs(var_1_9) do
		local var_1_17 = iter_1_3.key

		var_1_16 = true

		if not var_1_17 then
			local var_1_18 = arg_1_0.attrPanel:clone():show()

			var_1_18:get("key"):text(iter_1_3.name)
			var_1_18:get("val"):text(iter_1_3.val)
			text.addEffect(var_1_18:get("key"), {
				color = ui.COLORS.NORMAL.GRAY
			})
			text.addEffect(var_1_18:get("val"), {
				color = ui.COLORS.NORMAL.GRAY
			})
			arg_1_0.list:pushBackCustomItem(var_1_18)

			var_1_5 = var_1_5 + 1
		elseif not var_0_1.ignoreAttr(var_1_17) then
			local var_1_19 = iter_1_3.val
			local var_1_20 = arg_1_0.attrPanel:clone():show()
			local var_1_21 = var_0_1.getAttrName(var_1_17)

			var_1_20:get("key"):text(var_1_21)
			var_1_20:get("val"):text("+" .. var_1_19)
			arg_1_0.list:pushBackCustomItem(var_1_20)

			var_1_5 = var_1_5 + 1
		end
	end

	if var_1_16 then
		local var_1_22 = arg_1_0.linePanel:clone():show()

		arg_1_0.list:pushBackCustomItem(var_1_22)

		var_1_6 = var_1_6 + 1
	end

	local var_1_23 = {}
	local var_1_24 = gChipSuitCsv[var_1_4.suitID][var_1_4.quality]
	local var_1_25 = {}

	for iter_1_4, iter_1_5 in pairs(var_1_24) do
		table.insert(var_1_25, {
			iter_1_5.suitNum,
			iter_1_5.suitQuality,
			false
		})
	end

	for iter_1_6, iter_1_7 in ipairs(var_1_25) do
		local var_1_26 = var_0_1.getSuitAttrStr(var_1_4.suitID, iter_1_7)

		table.insert(var_1_23, {
			str = var_1_26
		})
	end

	local var_1_27 = arg_1_0.suitPanel:clone():show()
	local var_1_28, var_1_29 = beauty.textScroll({
		margin = 10,
		isRich = true,
		list = var_1_27:get("list"),
		strs = var_1_23
	})
	local var_1_30 = var_1_5 * arg_1_0.attrPanel:size().height + var_1_6 * arg_1_0.linePanel:size().height + var_1_29

	var_1_28:height(var_1_29)
	var_1_28:setTouchEnabled(false)
	var_1_27:height(var_1_29)
	arg_1_0.list:pushBackCustomItem(var_1_27)
	arg_1_0.bg2:size(cc.size(arg_1_0.bg2:size().width, var_1_30 + 30))
	arg_1_0.bg:size(cc.size(arg_1_0.bg:size().width, var_1_30 + 305))
	arg_1_0.baseNode:size(cc.size(arg_1_0.bg:size().width, var_1_30 + 400))
	arg_1_0.panel:xy(arg_1_0.baseNode:size().width / 2, arg_1_0.baseNode:size().height)
end

return var_0_0
