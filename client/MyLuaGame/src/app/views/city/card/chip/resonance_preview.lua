local var_0_0 = require("app.views.city.card.chip.tools")
local var_0_1 = {
	{
		name = gLanguageCsv.chipResonanceDetail03,
		getStrFunc = function(arg_1_0, arg_1_1, arg_1_2)
			arg_1_2 = "        " .. string.format(gLanguageCsv.chipResonanceDetail01, arg_1_0, arg_1_1[1], ui.QUALITYCOLOR[arg_1_1[2]], gLanguageCsv[ui.QUALITY_COLOR_TEXT[arg_1_1[2]]], arg_1_2)

			return arg_1_2
		end
	},
	{
		name = gLanguageCsv.chipResonanceDetail04,
		getStrFunc = function(arg_2_0, arg_2_1, arg_2_2)
			arg_2_2 = "        " .. string.format(gLanguageCsv.chipResonanceDetail02, arg_2_0, arg_2_1[1], arg_2_1[2], arg_2_2)

			return arg_2_2
		end
	}
}
local var_0_2 = class("ChipResonancePreviewView", Dialog)

var_0_2.RESOURCE_FILENAME = "chip_resonance_detail.json"
var_0_2.RESOURCE_BINDING = {
	list = "list",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	titleTxt1 = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	titleTxt2 = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	}
}

function var_0_2.onCreate(arg_3_0)
	local var_3_0 = {}

	table.insert(var_3_0, "")

	for iter_3_0, iter_3_1 in pairs(gChipResonanceCsv) do
		if var_0_1[iter_3_0] then
			table.insert(var_3_0, var_0_1[iter_3_0].name)

			for iter_3_2, iter_3_3 in pairs(iter_3_1) do
				local var_3_1 = {}

				for iter_3_4, iter_3_5 in ipairs(iter_3_3) do
					table.insert(var_3_1, iter_3_5)
				end

				table.sort(var_3_1, function(arg_4_0, arg_4_1)
					return arg_4_0.priority < arg_4_1.priority
				end)

				for iter_3_6, iter_3_7 in ipairs(var_3_1) do
					local var_3_2 = {}

					for iter_3_8 = 1, math.huge do
						local var_3_3 = iter_3_7["attrType" .. iter_3_8]

						if var_3_3 and var_3_3 ~= 0 then
							local var_3_4 = dataEasy.getAttrValueString(var_3_3, iter_3_7["attrNum" .. iter_3_8])
							local var_3_5 = {
								key = var_3_3,
								val = var_3_4
							}

							table.insert(var_3_2, var_3_5)
						else
							break
						end
					end

					local var_3_6 = var_0_0.getBaseAttr(var_3_2)

					table.sort(var_3_6, function(arg_5_0, arg_5_1)
						return arg_5_0.key < arg_5_1.key
					end)

					local var_3_7 = ""

					for iter_3_9, iter_3_10 in ipairs(var_3_6) do
						local var_3_8 = var_0_0.getAttrName(iter_3_10.key)

						var_3_7 = var_3_7 .. string.format("#C0x5B545B##F36#%s#C0x5C9970##F44#+%s", var_3_8, iter_3_10.val)

						if var_3_6[iter_3_9 + 1] then
							var_3_7 = var_3_7 .. "#C0x5B545B##F36#, "
						end
					end

					local var_3_9 = var_0_1[iter_3_0].getStrFunc(iter_3_6, iter_3_7.param, var_3_7)

					table.insert(var_3_0, var_3_9)
				end
			end

			table.insert(var_3_0, "")
		end
	end

	beauty.textScroll({
		isRich = true,
		list = arg_3_0.list,
		strs = var_3_0
	})
	Dialog.onCreate(arg_3_0)
end

return var_0_2
