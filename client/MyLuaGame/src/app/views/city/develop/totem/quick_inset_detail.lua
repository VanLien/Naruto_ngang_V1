local var_0_0 = class("QuickInsertDetailView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "totem_quick_inset_detail.json"
var_0_0.RESOURCE_BINDING = {
	subList = "subList",
	item = "item",
	icon = "icon",
	previewPanel = "previewPanel",
	["previewPanel.addPanel.iconList"] = {
		varname = "iconList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 0,
				padding = 0,
				data = bindHelper.self("iconListData"),
				item = bindHelper.self("icon"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1.texture(arg_1_1, ui.ATTR_ICON[arg_1_3])
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_2_0, arg_2_1)
	arg_2_0.iconListData = idlers.new({})

	local var_2_0 = csv.totem.symbol[arg_2_1.id]

	arg_2_0.previewPanel:get("title"):text(var_2_0.name)

	local var_2_1 = 0

	for iter_2_0, iter_2_1 in ipairs(arg_2_1.totems) do
		if iter_2_1.isAbleToActive then
			var_2_1 = var_2_1 + 1
		end
	end

	arg_2_0.previewPanel:get("num"):text(string.format("%d/%d", var_2_1, arg_2_1.totemsNum - arg_2_1.activeNum))
	arg_2_0.previewPanel:get("tip"):visible(arg_2_1.limitToActiveNum == 0)
	arg_2_0:setItem(var_2_0.attrType1, var_2_0.attrNum1, 1)
	arg_2_0:setItem(var_2_0.attrType2, var_2_0.attrNum2, 2)

	if itertools.size(var_2_0.nature) > 0 then
		if var_2_0.attrType2 == 0 then
			arg_2_0.previewPanel:get("addPanel"):y(arg_2_0.previewPanel:get("item2"):y() - 80)
		end

		arg_2_0.previewPanel:get("addPanel"):show()
		arg_2_0:setItem(var_2_0.extraAttrsType1, var_2_0.extraAttrNum1, 11)
		arg_2_0:setItem(var_2_0.extraAttrsType2, var_2_0.extraAttrNum2, 12)
		arg_2_0.iconListData:update(var_2_0.nature)
	else
		arg_2_0.previewPanel:get("addPanel"):hide()
	end
end

function var_0_0.setItem(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	if arg_3_1 > 0 then
		local var_3_0

		if arg_3_3 < 10 then
			var_3_0 = arg_3_0.item:clone():addTo(arg_3_0.previewPanel:get("item" .. arg_3_3), 5, "item" .. arg_3_3):xy(arg_3_0.previewPanel:get("item" .. arg_3_3):width() / 2, arg_3_0.previewPanel:get("item" .. arg_3_3):height() / 2):show()
		else
			var_3_0 = arg_3_0.item:clone():addTo(arg_3_0.previewPanel:get("addPanel"):get("item" .. arg_3_3), 5, "item" .. arg_3_3):xy(arg_3_0.previewPanel:get("addPanel"):get("item" .. arg_3_3):width() / 2, arg_3_0.previewPanel:get("addPanel"):get("item" .. arg_3_3):height() / 2):show()
		end

		local var_3_1 = ui.ATTR_LOGO[game.ATTRDEF_TABLE[arg_3_1]]

		if var_3_1 then
			var_3_0:get("icon"):texture(var_3_1):show()
		else
			var_3_0:get("icon"):hide()
		end

		var_3_0:get("name"):text(gLanguageCsv["attr" .. string.caption(game.ATTRDEF_TABLE[arg_3_1])])
		var_3_0:get("num"):text("+" .. dataEasy.getAttrValueString(arg_3_1, arg_3_2))
		adapt.oneLinePos(var_3_0:get("anchor"), {
			var_3_0:get("icon"),
			var_3_0:get("name")
		}, cc.p(15, 0), "left")
	end
end

return var_0_0
