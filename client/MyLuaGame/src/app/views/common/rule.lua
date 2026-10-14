local var_0_0 = class("RuleView", Dialog)

var_0_0.RESOURCE_FILENAME = "common_rule.json"
var_0_0.RESOURCE_BINDING = {
	panelChip = "panelChip",
	list = "list",
	bg = "bg",
	title = "title",
	rateTips = "rateTips",
	awardItem = "awardItem"
}

function var_0_0.onCreate(arg_1_0, arg_1_1, arg_1_2)
	Dialog.onCreate(arg_1_0)
	arg_1_0.list:setScrollBarEnabled(false)

	arg_1_2 = arg_1_2 or {}

	if arg_1_2.width then
		local var_1_0 = arg_1_0.bg:width() - arg_1_2.width

		arg_1_0.bg:width(arg_1_2.width)
		arg_1_0.list:width(arg_1_0.list:width() - var_1_0):x(arg_1_0.list:x() + var_1_0 / 2)
		setContentSizeOfAnchor(arg_1_0.title, cc.size(arg_1_0.title:width() - var_1_0, arg_1_0.title:height()))
	end

	adaptContext.setToList(arg_1_0, arg_1_0.list, arg_1_1(arg_1_0), 16, nil, function()
		arg_1_0.list:refreshView()

		local var_2_0 = cc.clampf(arg_1_2.height or arg_1_0.list:getInnerItemSize().height, 400, arg_1_0.list:height())
		local var_2_1 = arg_1_0.list:height() - var_2_0

		arg_1_0.bg:height(arg_1_0.bg:height() - var_2_1)
		arg_1_0.list:height(arg_1_0.list:height() - var_2_1):y(arg_1_0.list:y() + var_2_1 / 2)
	end)
	arg_1_0:quickFor()
end

return var_0_0
