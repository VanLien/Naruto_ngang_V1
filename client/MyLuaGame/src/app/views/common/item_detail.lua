local var_0_0 = class("ItemDetailView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "common_item_detail.json"
var_0_0.RESOURCE_BINDING = {
	["baseNode.textNum"] = "textNum",
	["baseNode.content"] = "contentLabel",
	baseNode = "baseNode",
	["baseNode.name"] = "nodeName",
	["baseNode.list"] = "list",
	["baseNode.icon"] = {
		binds = {
			event = "extend",
			class = "icon_key",
			props = {
				noListener = true,
				data = bindHelper.self("data"),
				onNode = function(arg_1_0)
					local var_1_0 = arg_1_0:size()

					arg_1_0:alignCenter(var_1_0)
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_2_0, arg_2_1)
	arg_2_0:getResourceNode():setTouchEnabled(false)

	local var_2_0 = arg_2_1.key
	local var_2_1 = arg_2_1.num

	arg_2_0.data = {
		key = var_2_0,
		num = var_2_1
	}

	local var_2_2 = true

	if game.ITEM_EXP_HASH[var_2_0] then
		var_2_2 = false
	elseif csv.items[var_2_0] and csv.items[var_2_0].type == game.ITEM_TYPE_ENUM_TABLE.aptitude then
		var_2_2 = false
	end

	local var_2_3, var_2_4 = uiEasy.setIconName(var_2_0, var_2_1, {
		node = arg_2_0.nodeName
	})

	arg_2_0.nodeName:setFontName(ui.FONT_PATH)
	arg_2_0.nodeName:setTextColor(var_2_4.color)

	if matchLanguage({
		"en"
	}) then
		adapt.setTextAdaptWithSize(arg_2_0.nodeName, {
			vertical = "center",
			size = cc.size(425, 144)
		})
	else
		adapt.setTextScaleWithWidth(arg_2_0.nodeName, nil, 410)
	end

	arg_2_0.textNum:visible(var_2_2)

	if not var_2_2 then
		arg_2_0.nodeName:y(arg_2_0.nodeName:y() - 50)
	else
		arg_2_0.textNum:text(gLanguageCsv.have .. ": " .. mathEasy.getShortNumber(dataEasy.getNumByKey(var_2_0), 2))
	end

	beauty.textScroll({
		isRich = true,
		list = arg_2_0.list,
		strs = "#C0xFFFFFF#" .. uiEasy.getIconDesc(var_2_0, var_2_1)
	})
end

function var_0_0.hitTestPanel(arg_3_0, arg_3_1)
	if arg_3_0.list:isTouchEnabled() then
		local var_3_0 = arg_3_0.baseNode
		local var_3_1 = var_3_0:box()
		local var_3_2 = var_3_0:parent():convertToWorldSpace(cc.p(var_3_1.x, var_3_1.y))

		var_3_1.x = var_3_2.x
		var_3_1.y = var_3_2.y

		return cc.rectContainsPoint(var_3_1, arg_3_1)
	end

	return false
end

return var_0_0
