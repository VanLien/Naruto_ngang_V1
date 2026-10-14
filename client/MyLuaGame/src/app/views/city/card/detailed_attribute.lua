local var_0_0 = class("CardDetailedAttributeView", Dialog)

var_0_0.RESOURCE_FILENAME = "card_detailed_attribute.json"
var_0_0.RESOURCE_BINDING = {
	list = "list",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0)
	local var_1_0 = {}

	for iter_1_0 = 1, 100 do
		if not csv.note[iter_1_0] then
			break
		end

		local var_1_1 = csv.note[iter_1_0].fmt or ""
		local var_1_2
		local var_1_3
		local var_1_4
		local var_1_5 = string.find(var_1_1, "|") or 1
		local var_1_6 = string.sub(var_1_1, 0, var_1_5 - 1)
		local var_1_7 = string.sub(var_1_1, var_1_5 + 1, string.len(var_1_1))

		table.insert(var_1_0, {
			str = "#C0x5B545B##L10#" .. var_1_6 .. "#L00#" .. var_1_7
		})
	end

	beauty.textScroll({
		margin = 21,
		align = "left",
		isRich = true,
		list = arg_1_0.list,
		strs = var_1_0
	})
	Dialog.onCreate(arg_1_0)
end

function var_0_0.onClose(arg_2_0)
	Dialog.onClose(arg_2_0)
end

return var_0_0
