local var_0_0 = class("GemDetailsView", cc.load("mvc").ViewBase)
local var_0_1 = require("app.views.city.card.gem.tools")

var_0_0.RESOURCE_FILENAME = "common_gem_details.json"
var_0_0.RESOURCE_BINDING = {
	baseNode = "baseNode",
	["baseNode.name"] = "name",
	["baseNode.panelLab"] = "panelLab",
	["baseNode.txt"] = "txt",
	["baseNode.property"] = "property",
	["baseNode.list"] = "list",
	["baseNode.item"] = "item",
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
	["baseNode.confirm"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("confirmClick")
			}
		}
	},
	["baseNode.confirm.text"] = {
		varname = "confirmText",
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

function var_0_0.onCreate(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0
	local var_1_1
	local var_1_2 = gGameModel.gems:find(arg_1_1.dbId)

	arg_1_0.dbid = arg_1_1.dbId
	arg_1_0.dissatisfy = arg_1_1.dissatisfy

	local var_1_3 = var_1_2:read("gem_id")
	local var_1_4 = var_1_2:read("level")

	arg_1_0.cb = arg_1_2

	local var_1_5 = {}
	local var_1_6 = dataEasy.getCfgByKey(var_1_3)

	arg_1_0.item:visible(false)

	local var_1_7 = var_1_6.quality
	local var_1_8 = "qualityNum" .. var_1_7

	arg_1_0.quality:text(csv.gem.quality[var_1_4][var_1_8])
	arg_1_0.name:text(var_1_6.name)
	text.addEffect(arg_1_0.name, {
		color = ui.COLORS.QUALITY_DARK[var_1_7]
	})

	if csv.gem.gem[var_1_3] then
		arg_1_0.property:text(csv.gem.gem[var_1_3].gemDescribe)
	else
		arg_1_0.property:visible(false)
		arg_1_0.quile:y(arg_1_0.property:y())
		arg_1_0.quality:y(arg_1_0.property:y())
	end

	local var_1_9 = gLanguageCsv.gemPlac
	local var_1_10 = arg_1_1.pos
	local var_1_11 = arg_1_0:getResourceNode():convertToNodeSpace(cc.p(var_1_10.x, 0)).x + 35
	local var_1_12 = var_1_10.y - 85

	if arg_1_1.align == "left" then
		var_1_9 = gLanguageCsv.discharge
		var_1_12 = var_1_10.y + 65
	end

	arg_1_0.confirmText:text(var_1_9)
	arg_1_0.baseNode:xy(var_1_11, var_1_12)

	arg_1_0.align = arg_1_1.align

	arg_1_0.list:setScrollBarEnabled(false)
	bind.extend(arg_1_0, arg_1_0.icon, {
		class = "icon_key",
		props = {
			noListener = true,
			data = {
				key = var_1_3
			},
			specialKey = {
				leftTopLv = var_1_4
			},
			onNode = function(arg_2_0)
				return
			end
		}
	})

	for iter_1_0 = 1, math.huge do
		if var_1_6["attrType" .. iter_1_0] and var_1_6["attrType" .. iter_1_0] ~= 0 and var_1_6["attrNum" .. iter_1_0] and var_1_6["attrNum" .. iter_1_0][var_1_4] then
			local var_1_13 = game.ATTRDEF_TABLE[var_1_6["attrType" .. iter_1_0]]
			local var_1_14 = "attr" .. var_1_13:gsub("^%l", string.upper)
			local var_1_15 = arg_1_0.txt:clone()

			var_1_15:get("txt"):text(gLanguageCsv[var_1_14])
			var_1_15:get("number"):text("+" .. dataEasy.getAttrValueString(var_1_6["attrType" .. iter_1_0], var_1_6["attrNum" .. iter_1_0][var_1_4]))
			var_1_15:get("number"):x(var_1_15:get("txt"):width() + 10)
			dataEasy.tryCallFunc(arg_1_0.list, "updatePreloadCenterIndex")
			arg_1_0.list:pushBackCustomItem(var_1_15)
		else
			break
		end
	end

	local var_1_16 = csv.gem.gem[var_1_3].suitID
	local var_1_17 = gGemSuitCsv[var_1_16] and gGemSuitCsv[var_1_16][var_1_7]
	local var_1_18 = "#C0xB7B09E#"

	if var_1_17 then
		local var_1_19 = arg_1_0.item:clone():show()

		arg_1_0.list:pushBackCustomItem(var_1_19)

		for iter_1_1 = 1, 9 do
			if var_1_17[iter_1_1] then
				local var_1_20 = string.format(gLanguageCsv.numSuit, var_1_17[iter_1_1].suitNum)
				local var_1_21 = var_1_17[iter_1_1].suitName .. string.format("%s(%s)%s", var_1_20, gLanguageCsv[ui.QUALITY_COLOR_TEXT[var_1_7]], gLanguageCsv.symbolColon)
				local var_1_22

				for iter_1_2 = 1, math.huge do
					if var_1_17[iter_1_1]["attrType" .. iter_1_2] and var_1_17[iter_1_1]["attrType" .. iter_1_2] ~= 0 then
						local var_1_23 = game.ATTRDEF_TABLE[var_1_17[iter_1_1]["attrType" .. iter_1_2]]
						local var_1_24 = gLanguageCsv["attr" .. string.caption(var_1_23)]

						if var_1_22 then
							var_1_22 = var_1_22 .. "  " .. var_1_24 .. "+" .. dataEasy.getAttrValueString(var_1_17[iter_1_1]["attrType" .. iter_1_2], var_1_17[iter_1_1]["attrNum" .. iter_1_2])
						else
							var_1_22 = var_1_24 .. "+" .. dataEasy.getAttrValueString(var_1_17[iter_1_1]["attrType" .. iter_1_2], var_1_17[iter_1_1]["attrNum" .. iter_1_2])
						end
					else
						break
					end
				end

				local var_1_25 = arg_1_0.panelLab:clone():show()
				local var_1_26 = rich.createWithWidth(var_1_18 .. var_1_21 .. var_1_22 .. var_1_18, 40, cc.size(700, 90), 700, 0):anchorPoint(0, 1)

				var_1_25:height(var_1_26:height())
				var_1_26:addTo(var_1_25):y(var_1_25:height()):z(2)
				arg_1_0.list:pushBackCustomItem(var_1_25)
			end
		end
	end

	arg_1_0.txt:visible(false)
	arg_1_0.panelLab:visible(false)
end

function var_0_0.confirmClick(arg_3_0)
	if not arg_3_0.dissatisfy then
		gGameUI:showTip(gLanguageCsv.gemUpperLimit)

		return
	end

	if arg_3_0.cb then
		arg_3_0.cb(arg_3_0.dbid, arg_3_0.align)
	end

	arg_3_0:onClose()
end

return var_0_0
