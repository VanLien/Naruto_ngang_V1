local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("TotemInfo", var_0_0)

local function var_0_2(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1.multiget(arg_1_1, "attr", "icon", "num")
	local var_1_1 = gLanguageCsv["attr" .. string.caption(game.ATTRDEF_TABLE[arg_1_3.attr])]
	local var_1_2 = ui.ATTR_LOGO[game.ATTRDEF_TABLE[arg_1_3.attr]]

	if var_1_2 then
		var_1_0.icon:texture(var_1_2)
	else
		var_1_0.attr:xy(110, 31)
		var_1_0.icon:hide()
	end

	var_1_0.attr:text(var_1_1)
	var_1_0.num:text("+" .. dataEasy.getAttrValueString(arg_1_3.attr, arg_1_3.num))
	adapt.oneLinePos(var_1_0.attr, var_1_0.num, cc.p(10, 0), "left")
end

var_0_1.RESOURCE_FILENAME = "totem_info.json"
var_0_1.RESOURCE_BINDING = {
	["node.name"] = "panelName",
	["node.canTxt"] = "canTxt",
	["node.attrItem"] = "attrItem",
	["node.bg"] = "bg",
	["node.tips"] = "tips",
	["node.canNum"] = "canNum",
	node = {
		varname = "node",
		binds = {
			event = "click",
			method = bindHelper.self("onClose")
		}
	},
	["node.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("totemsData"),
				item = bindHelper.self("attrItem"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1.multiget(arg_2_1, "attrTxt", "icon", "attr", "num", "list", "imgItem")

					if arg_2_3.show then
						var_2_0.attrTxt:show()
					else
						var_2_0.attrTxt:hide()
					end

					if arg_2_3.type == 2 and arg_2_3.show then
						itertools.invoke({
							var_2_0.icon,
							var_2_0.attr,
							var_2_0.num
						}, "hide")
						var_2_0.list:show()
						bind.extend(arg_2_0, var_2_0.list, {
							class = "listview",
							props = {
								data = arg_2_3.nature,
								item = var_2_0.imgItem,
								onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
									arg_3_1:get("img"):texture(ui.ATTR_ICON[arg_3_3])
								end
							}
						})
					else
						var_2_0.list:hide()
						var_0_2(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					end
				end
			}
		}
	}
}

function var_0_1.onCreate(arg_4_0, arg_4_1)
	arg_4_0.initModel(arg_4_0)

	arg_4_0.types = arg_4_1.type

	if arg_4_0.types == 1 then
		arg_4_0.totemInfo(arg_4_0, arg_4_1)
	end
end

function var_0_1.initModel(arg_5_0)
	arg_5_0.totemsData = idlers.new({})
end

function var_0_1.totemInfo(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_1.csvId
	local var_6_1 = arg_6_1.can
	local var_6_2 = arg_6_1.need
	local var_6_3 = csv.totem.symbol[var_6_0]

	if var_6_2 <= var_6_1 then
		arg_6_0.tips:show()
	else
		arg_6_0.tips:hide()
	end

	arg_6_0.panelName:text(var_6_3.name)
	arg_6_0.canNum:text(var_6_1 .. "/" .. var_6_2)

	local var_6_4 = {}
	local var_6_5 = var_6_3.nature or {}
	local var_6_6 = 0

	for iter_6_0 = 1, 2 do
		if var_6_3["attrType" .. iter_6_0] > 0 then
			var_6_6 = var_6_6 + 1

			table.insert(var_6_4, {
				type = 1,
				show = var_6_6 == 1,
				attr = var_6_3["attrType" .. iter_6_0],
				num = var_6_3["attrNum" .. iter_6_0]
			})
		end
	end

	local var_6_7 = 0

	for iter_6_1 = 1, 2 do
		if var_6_3["extraAttrsType" .. iter_6_1] > 0 then
			var_6_7 = var_6_7 + 1

			if var_6_7 == 1 then
				table.insert(var_6_4, {
					show = true,
					type = 2,
					nature = var_6_5
				})
			end

			table.insert(var_6_4, {
				show = false,
				type = 2,
				attr = var_6_3["extraAttrsType" .. iter_6_1],
				num = var_6_3["extraAttrNum" .. iter_6_1]
			})
		end
	end

	arg_6_0.totemsData:update(var_6_4)
	arg_6_0.bg:size(679, 330 + 60 * itertools.size(var_6_4))
	arg_6_0.tips:show()
	arg_6_0.tips:xy(345.5, 400 - 60 * itertools.size(var_6_4))
	arg_6_0.canTxt:text(gLanguageCsv.totemCanInsert)
	arg_6_0.tips:text(gLanguageCsv.totemTips)
end

return var_0_1
