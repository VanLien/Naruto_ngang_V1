local var_0_0 = require("app.views.city.develop.totem.tools")
local var_0_1 = require("app.views.common.item_detail")
local var_0_2 = class("TotemItemDetailView", var_0_1)

var_0_2.RESOURCE_FILENAME = "totem_item_detail.json"
var_0_2.RESOURCE_BINDING = {
	["baseNode.textNum"] = "textNum",
	["baseNode.bg"] = "imgBg",
	["baseNode.content"] = "contentLabel",
	["baseNode.name"] = "nodeName",
	baseNode = "baseNode",
	["baseNode.status"] = "status",
	["baseNode.list"] = "list",
	["baseNode.icon"] = {
		varname = "icon",
		binds = {
			event = "extend",
			class = "icon_key",
			props = {
				noListener = true,
				data = bindHelper.self("data"),
				onNode = function(arg_1_0)
					local var_1_0 = arg_1_0.size(arg_1_0)

					arg_1_0.alignCenter(arg_1_0, var_1_0)
				end
			}
		}
	}
}

function var_0_2.onCreate(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_1.status

	if var_2_0 then
		arg_2_0.status:show()
		arg_2_0.status:text(var_2_0 == 1 and gLanguageCsv.totemInserted or gLanguageCsv.totemNotInsert)
	else
		arg_2_0.status:hide()
	end

	arg_2_0.status:y(arg_2_0.textNum:y())

	local var_2_1 = gGameModel.totem:read("totem_insetted")
	local var_2_2 = var_0_0.getActivateTotemEnergy(var_2_1)
	local var_2_3 = {}
	local var_2_4 = {}

	for iter_2_0, iter_2_1 in orderCsvPairs(csv.totem.symbol) do
		local var_2_5 = iter_2_1.symbolGroupType

		if var_2_2 >= csv.totem.symbol_group[var_2_5].unlockEnergy and var_2_2 >= csv.totem.symbol_group[var_2_5].showEnergy and csv.totem.symbol_group[var_2_5] then
			for iter_2_2, iter_2_3 in pairs(iter_2_1.totemGroup1) do
				if iter_2_3 == arg_2_1.key then
					var_2_4[var_2_5] = (var_2_4[var_2_5] or 0) + 1

					if var_2_1[iter_2_0] and var_2_1[iter_2_0][iter_2_2] then
						var_2_3[var_2_5] = (var_2_3[var_2_5] or 0) + 1
					end
				end
			end
		end
	end

	local var_2_6 = 0
	local var_2_7 = 0
	local var_2_8 = ""

	for iter_2_4, iter_2_5 in pairs(var_2_4) do
		var_2_6 = (var_2_3[iter_2_4] or 0) + var_2_6
		var_2_7 = (var_2_4[iter_2_4] or 0) + var_2_7

		if iter_2_5 ~= 0 then
			local var_2_9 = string.format("%s (%d/%d)", csv.totem.symbol_group[iter_2_4].name, var_2_3[iter_2_4] or 0, iter_2_5)

			if string.len(var_2_8) ~= 0 then
				var_2_8 = var_2_8 .. gLanguageCsv.pauseMark
			end

			var_2_8 = var_2_8 .. var_2_9
		end
	end

	local var_2_10 = string.format(gLanguageCsv.totemInfo, var_2_6, var_2_7)

	arg_2_0.info = "#C0xF76B45#" .. var_2_10 .. var_2_8

	var_0_1.onCreate(arg_2_0, arg_2_1)
end

function var_0_2.initText(arg_3_0)
	local var_3_0, var_3_1 = beauty.textScroll({
		isRich = true,
		list = arg_3_0.list,
		strs = "#C0x5B545B#" .. uiEasy.getIconDesc(arg_3_0.data.key, arg_3_0.data.num) .. arg_3_0.info
	})
	local var_3_2 = cc.clampf(var_3_1, 250, 750) - 130

	arg_3_0.imgBg:size(arg_3_0.imgBg:size().width, arg_3_0.imgBg:size().height + var_3_2)
	var_3_0:size(var_3_0:size().width, 250 + var_3_2)
	var_3_0:y(var_3_0:y() - var_3_2 - 100)
end

return var_0_2
