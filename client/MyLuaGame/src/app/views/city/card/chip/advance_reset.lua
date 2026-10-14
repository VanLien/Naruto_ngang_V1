local var_0_0 = class("ChipAdvanceResetView", Dialog)
local var_0_1 = require("app.views.city.card.chip.tools")

var_0_0.RESOURCE_FILENAME = "chip_advance_reset.json"
var_0_0.RESOURCE_BINDING = {
	subList = "subList",
	item = "item",
	descList = "descList",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnOK = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClickOK")
			}
		}
	},
	btnCancel = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onCancel")
			}
		}
	},
	list = {
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 2,
				data = bindHelper.self("resetData"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = getLanguageAttr(arg_1_3.key)
					local var_1_1 = var_0_1.getAttrName(arg_1_3.key)

					arg_1_1:get("name"):text(var_1_1)
					arg_1_1:get("value"):text(arg_1_3.val)
					arg_1_1:get("arrow"):visible(arg_1_2 % 2 == 1)
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_2_0, arg_2_1)
	arg_2_0.cb = arg_2_1.cb

	beauty.textScroll({
		isRich = true,
		list = arg_2_0.descList,
		strs = string.format(gLanguageCsv.chipAdvanceReset, gCommonConfigCsv.chipResetCost)
	})

	arg_2_0.resetData = {}

	local var_2_0, var_2_1 = var_0_1.getAttr(arg_2_1.dbId, nil, true)
	local var_2_2 = gGameModel.chips:find(arg_2_1.dbId)
	local var_2_3 = var_2_2:read("first") or {}
	local var_2_4 = var_2_2:read("now") or {}
	local var_2_5 = {}

	for iter_2_0, iter_2_1 in ipairs(var_2_3) do
		var_0_1.setAttrAddition(var_2_5, csv.chip.libs[iter_2_1], var_2_4[iter_2_0][3], true)
	end

	for iter_2_2, iter_2_3 in ipairs(var_2_1) do
		local var_2_6 = iter_2_3.key

		if not var_0_1.ignoreAttr(var_2_6) then
			table.insert(arg_2_0.resetData, iter_2_3)
			table.insert(arg_2_0.resetData, var_2_5[iter_2_2])
		end
	end

	Dialog.onCreate(arg_2_0)
end

function var_0_0.onClickOK(arg_3_0)
	arg_3_0:addCallbackOnExit(arg_3_0.cb)
	Dialog.onCloseFast(arg_3_0)

	return arg_3_0
end

function var_0_0.onCancel(arg_4_0)
	arg_4_0:onClose()
end

return var_0_0
