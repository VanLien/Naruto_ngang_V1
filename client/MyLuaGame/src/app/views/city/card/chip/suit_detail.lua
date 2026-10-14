local var_0_0 = require("app.views.city.card.chip.tools")
local var_0_1 = class("ChipSuitAttrView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "chip_suit_attr.json"
var_0_1.RESOURCE_BINDING = {
	txtTip = "txtTip",
	item01 = "item",
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("showDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("imgChip", "txtName")

					var_1_0.txtName:text(arg_1_3.name)

					local var_1_1 = rich.createWithWidth(arg_1_3.twoStr, 40, nil, 1240, nil, cc.p(0, 0)):anchorPoint(cc.p(0, 1)):xy(280, 210):addTo(arg_1_1)
					local var_1_2 = rich.createWithWidth(arg_1_3.fourStr, 40, nil, 1240, nil, cc.p(0, 0)):anchorPoint(cc.p(0, 1)):xy(280, 150):addTo(arg_1_1)

					if not arg_1_3.fourSign then
						var_1_2:setOpacity(130)
					end

					var_1_0.imgChip:texture(arg_1_3.icon)
				end,
				onAfterBuild = function(arg_2_0)
					local var_2_0 = arg_2_0:getInnerContainerSize()
					local var_2_1 = arg_2_0:getContentSize()

					if var_2_0.height <= var_2_1.height then
						arg_2_0:setTouchEnabled(false)
					end
				end
			}
		}
	}
}
var_0_1.RESOURCE_STYLES = {
	backGlass = true,
	blackLayer = true,
	clickClose = true
}

function var_0_1.onCreate(arg_3_0, arg_3_1)
	arg_3_0.cardDBID = arg_3_1
	arg_3_0.showDatas = idlertable.new({})

	local var_3_0 = {}
	local var_3_1 = var_0_0.getComplateSuitAttrByCard(arg_3_0.cardDBID)

	for iter_3_0, iter_3_1 in pairs(var_3_1) do
		local var_3_2 = {}
		local var_3_3 = iter_3_1.suitId

		var_3_2.icon = var_0_0.getSuitRes(var_3_3, iter_3_1.data)

		for iter_3_2, iter_3_3 in ipairs(iter_3_1.data) do
			local var_3_4 = gChipSuitCsv[var_3_3][iter_3_3[2]][iter_3_3[1]]

			var_3_2.name = var_3_4.suitName

			local var_3_5 = string.format("%s(%s)", ui.QUALITY_DARK_COLOR[iter_3_3[2]], gLanguageCsv[ui.QUALITY_COLOR_TEXT[iter_3_3[2]]])
			local var_3_6 = string.format(gLanguageCsv.chipSuitCount, iter_3_3[1], var_3_5)

			if var_3_4.skillID == 0 then
				for iter_3_4 = 1, 3 do
					local var_3_7 = var_3_4["attrType" .. iter_3_4]

					if var_3_7 and var_3_7 ~= 0 then
						local var_3_8 = dataEasy.getAttrValueString(var_3_7, var_3_4["attrNum" .. iter_3_4])

						var_3_6 = var_3_6 .. string.format(gLanguageCsv.chipSuit01, getLanguageAttr(var_3_7), var_3_8)
					end

					local var_3_9 = var_3_4["attrType" .. iter_3_4 + 1]

					if var_3_9 and var_3_9 ~= 0 then
						var_3_6 = var_3_6 .. "#C0xFFFCED#, "
					end
				end

				var_3_2.twoStr = var_3_6
				var_3_2.twoSign = iter_3_3[3]
			else
				local var_3_10 = var_3_6 .. "#C0xFFFCED#" .. string.gsub(csv.skill[var_3_4.skillID].describe, "#C0x5B545B#", "#C0xFFFCED#")

				var_3_2.fourStr = string.gsub(var_3_10, "#C0x5c9970#", "#C0x91e1b1#")
				var_3_2.fourSign = iter_3_3[3]
			end
		end

		table.insert(var_3_0, var_3_2)
	end

	if #var_3_0 == 0 then
		arg_3_0.txtTip:show()
		arg_3_0.list:hide()
	else
		arg_3_0.showDatas:set(var_3_0)
	end
end

return var_0_1
