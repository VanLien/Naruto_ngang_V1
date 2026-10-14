local var_0_0 = class("GemDetailsView", cc.load("mvc").ViewBase)
local var_0_1 = require("app.views.city.card.gem.tools")

var_0_0.RESOURCE_FILENAME = "common_details.json"
var_0_0.RESOURCE_BINDING = {
	["baseNode.bg2"] = "bg2",
	["baseNode.panelLab"] = "panelLab",
	["baseNode.txt"] = "txt",
	baseNode = "baseNode",
	["baseNode.property"] = "property",
	["baseNode.list"] = "list",
	["baseNode.item"] = "item",
	["baseNode.name"] = "name",
	["baseNode.quality"] = "quality",
	["baseNode.icon"] = "icon",
	["baseNode.quile"] = "quile",
	["baseNode.inlay"] = {
		varname = "inlay",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("inlayFunc")
			}
		}
	},
	["baseNode.bg"] = {
		varname = "bg",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["confirm.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0, arg_1_1)
	local var_1_0
	local var_1_1

	if arg_1_1.dbId then
		local var_1_2 = gGameModel.gems:find(arg_1_1.dbId)

		var_1_0 = var_1_2:read("gem_id")
		var_1_1 = var_1_2:read("level")
	else
		var_1_0 = arg_1_1.key
		var_1_1 = 1
	end

	local var_1_3 = {}
	local var_1_4 = dataEasy.getCfgByKey(var_1_0)

	arg_1_0.item:visible(false)

	local var_1_5 = var_1_4.quality
	local var_1_6 = "qualityNum" .. var_1_5

	arg_1_0.quality:text(csv.gem.quality[var_1_1][var_1_6])
	arg_1_0.name:text(var_1_4.name)
	text.addEffect(arg_1_0.name, {
		color = ui.COLORS.QUALITY_DARK[var_1_5]
	})

	if csv.gem.gem[var_1_0] then
		arg_1_0.property:text(csv.gem.gem[var_1_0].gemDescribe)
	else
		arg_1_0.property:visible(false)
		arg_1_0.quile:y(arg_1_0.property:y())
		arg_1_0.quality:y(arg_1_0.property:y())
	end

	arg_1_0.list:setScrollBarEnabled(false)
	bind.extend(arg_1_0, arg_1_0.icon, {
		class = "icon_key",
		props = {
			noListener = true,
			data = {
				key = var_1_0
			},
			specialKey = {
				leftTopLv = var_1_1
			},
			onNode = function(arg_2_0)
				return
			end
		}
	})

	local var_1_7 = 0
	local var_1_8 = 0

	for iter_1_0 = 1, math.huge do
		if var_1_4["attrType" .. iter_1_0] and var_1_4["attrType" .. iter_1_0] ~= 0 and var_1_4["attrNum" .. iter_1_0] and var_1_4["attrNum" .. iter_1_0][var_1_1] then
			local var_1_9 = game.ATTRDEF_TABLE[var_1_4["attrType" .. iter_1_0]]
			local var_1_10 = "attr" .. var_1_9:gsub("^%l", string.upper)
			local var_1_11 = arg_1_0.txt:clone()

			var_1_11:get("txt"):text(gLanguageCsv[var_1_10])
			var_1_11:get("number"):text("+" .. dataEasy.getAttrValueString(var_1_4["attrType" .. iter_1_0], var_1_4["attrNum" .. iter_1_0][var_1_1]))
			var_1_11:get("number"):x(var_1_11:get("txt"):width() + 10)
			dataEasy.tryCallFunc(arg_1_0.list, "updatePreloadCenterIndex")

			var_1_7 = var_1_7 + arg_1_0.txt:height()

			arg_1_0.list:pushBackCustomItem(var_1_11)
		else
			break
		end
	end

	local var_1_12 = csv.gem.gem[var_1_0].suitID
	local var_1_13 = gGemSuitCsv[var_1_12] and gGemSuitCsv[var_1_12][var_1_5]
	local var_1_14 = "#C0xB7B09E#"

	if var_1_13 then
		local var_1_15 = arg_1_0.item:clone():show()

		arg_1_0.list:pushBackCustomItem(var_1_15)

		for iter_1_1 = 1, 9 do
			if var_1_13[iter_1_1] then
				local var_1_16 = string.format(gLanguageCsv.numSuit, var_1_13[iter_1_1].suitNum)
				local var_1_17 = var_1_13[iter_1_1].suitName .. string.format("%s(%s)%s", var_1_16, gLanguageCsv[ui.QUALITY_COLOR_TEXT[var_1_5]], gLanguageCsv.symbolColon)
				local var_1_18

				for iter_1_2 = 1, math.huge do
					if var_1_13[iter_1_1]["attrType" .. iter_1_2] and var_1_13[iter_1_1]["attrType" .. iter_1_2] ~= 0 then
						local var_1_19 = game.ATTRDEF_TABLE[var_1_13[iter_1_1]["attrType" .. iter_1_2]]
						local var_1_20 = gLanguageCsv["attr" .. string.caption(var_1_19)]

						if var_1_18 then
							var_1_18 = var_1_18 .. "  " .. var_1_20 .. "+" .. dataEasy.getAttrValueString(var_1_13[iter_1_1]["attrType" .. iter_1_2], var_1_13[iter_1_1]["attrNum" .. iter_1_2])
						else
							var_1_18 = var_1_20 .. "+" .. dataEasy.getAttrValueString(var_1_13[iter_1_1]["attrType" .. iter_1_2], var_1_13[iter_1_1]["attrNum" .. iter_1_2])
						end
					else
						break
					end
				end

				local var_1_21 = arg_1_0.panelLab:clone():show()
				local var_1_22 = rich.createWithWidth(var_1_14 .. var_1_17 .. var_1_18 .. var_1_14, 40, cc.size(700, 90), 700, 0):anchorPoint(0, 1)

				var_1_21:height(var_1_22:height())
				var_1_22:addTo(var_1_21):y(var_1_21:height()):z(2)

				var_1_8 = var_1_8 + var_1_22:height()

				arg_1_0.list:pushBackCustomItem(var_1_21)
			end
		end
	end

	local var_1_23 = var_1_7 + var_1_8 + 50

	if var_1_23 > arg_1_0.list:height() then
		local var_1_24 = var_1_23 - arg_1_0.list:height()

		arg_1_0.list:height(var_1_23 + 10)
		arg_1_0.list:y(arg_1_0.list:y() - var_1_24)
		arg_1_0.bg:height(arg_1_0.bg:height() + var_1_24 + 20)
		arg_1_0.baseNode:height(arg_1_0.baseNode:height() + var_1_24 + 10)
		arg_1_0.bg2:height(var_1_23 + 20)
		arg_1_0.bg2:y(arg_1_0.list:y() + var_1_23 + 10)
	end

	arg_1_0.txt:visible(false)
	arg_1_0.panelLab:visible(false)
end

return var_0_0
