local var_0_0 = gCommonConfigCsv.chipUpLimit
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("ChipSelectSuitView", var_0_1)

var_0_2.RESOURCE_FILENAME = "chip_select_suit.json"
var_0_2.RESOURCE_BINDING = {
	txtVal = "txtVal",
	item01 = "item01",
	item02 = "item02",
	slider = "slider",
	btnDelete = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnDelete")
			}
		}
	},
	btnSure = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnSure")
			}
		}
	},
	["btnSure.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["btnDelete.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	listView = {
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 2,
				leftPadding = 5,
				data = bindHelper.self("suitData"),
				item = bindHelper.self("item01"),
				cell = bindHelper.self("item02"),
				sliderBg = bindHelper.self("slider"),
				dataOrderCmp = function(arg_1_0, arg_1_1)
					return arg_1_0.id < arg_1_1.id
				end,
				itemAction = {
					isAction = true
				},
				onCell = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("imgSuit", "txtSuitName", "txtSuitVal", "suitStatus", "panelInfo")

					var_2_0.imgSuit:texture(arg_2_3.icon)
					var_2_0.txtSuitName:text(arg_2_3.name)
					var_2_0.txtSuitVal:text(string.format(gLanguageCsv.chipSuitHaveNum, arg_2_3.count))
					var_2_0.suitStatus:setSelectedState(arg_2_3.select)
					var_2_0.panelInfo:removeAllChildren()

					local var_2_1 = var_2_0.panelInfo:size().height
					local var_2_2 = ""

					for iter_2_0, iter_2_1 in pairs(arg_2_3.str) do
						var_2_2 = var_2_2 .. iter_2_1 .. "\n"
					end

					local var_2_3 = rich.createWithWidth(var_2_2, 40, nil, 900, nil, cc.p(0, 0.5)):anchorPoint(cc.p(0, 1)):xy(10, var_2_1 + 20):addTo(var_2_0.panelInfo)

					bind.touch(arg_2_0, arg_2_1, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3)
						}
					})
				end,
				onBeforeBuild = function(arg_3_0)
					local var_3_0, var_3_1 = arg_3_0:xy()
					local var_3_2 = arg_3_0:size()
					local var_3_3, var_3_4 = arg_3_0.sliderBg:xy()
					local var_3_5 = arg_3_0.sliderBg:size()

					arg_3_0:setScrollBarEnabled(true)
					arg_3_0:setScrollBarColor(cc.c3b(245, 156, 2))
					arg_3_0:setScrollBarOpacity(255)
					arg_3_0:setScrollBarAutoHideEnabled(false)
					arg_3_0:setScrollBarPositionFromCorner(cc.p(var_3_0 + var_3_2.width - var_3_3, (var_3_2.height - var_3_5.height) / 2 + 5))
					arg_3_0:setScrollBarWidth(var_3_5.width)
					arg_3_0:refreshView()
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	}
}
var_0_2.RESOURCE_STYLES = {
	backGlass = true
}

function var_0_2.onCreate(arg_4_0, arg_4_1)
	arg_4_0:initModel()

	arg_4_0.suitData = idlers.new({})
	arg_4_0.selectUpSuitID = {}
	arg_4_0.callBack = arg_4_1.callBack
	arg_4_0.suitCount = {}

	arg_4_0:getSelectSuitID()
	arg_4_0:calculateSuitCount()
	arg_4_0:onSetSuitData()

	local var_4_0 = ccui.Layout:create():size(display.sizeInView):xy(display.board_left, 0):addTo(arg_4_0, -99, "__black_")

	var_4_0:setBackGroundColorType(1)
	var_4_0:setBackGroundColor(cc.c3b(0, 0, 0))
	var_4_0:setBackGroundColorOpacity(204)
	var_4_0:setTouchEnabled(true)
end

function var_0_2.initModel(arg_5_0)
	arg_5_0.roleChips = gGameModel.role:getIdler("chips")
end

function var_0_2.getSelectSuitID(arg_6_0)
	local var_6_0 = userDefault.getForeverLocalKey("selectUpSuitID", {})

	for iter_6_0, iter_6_1 in ipairs(var_6_0) do
		if iter_6_1 ~= 0 then
			table.insert(arg_6_0.selectUpSuitID, iter_6_1)
		end
	end

	arg_6_0:setSelectUI()
end

function var_0_2.calculateSuitCount(arg_7_0)
	local var_7_0 = arg_7_0.roleChips:read()

	for iter_7_0, iter_7_1 in pairs(var_7_0) do
		local var_7_1 = gGameModel.chips:find(iter_7_1)
		local var_7_2 = csv.chip.chips[var_7_1:read("chip_id")]

		arg_7_0.suitCount[var_7_2.suitID] = (arg_7_0.suitCount[var_7_2.suitID] or 0) + 1
	end
end

function var_0_2.onSetSuitData(arg_8_0)
	local var_8_0 = {}

	for iter_8_0, iter_8_1 in ipairs(arg_8_0.selectUpSuitID) do
		var_8_0[iter_8_1] = true
	end

	local var_8_1 = {}

	for iter_8_2, iter_8_3 in ipairs(csv.chip.suits) do
		local var_8_2 = {}

		if not var_8_1[iter_8_3.suitID] then
			var_8_2.id = iter_8_3.suitID
			var_8_2.icon = iter_8_3.suitIcon
			var_8_2.name = iter_8_3.suitName
			var_8_2.select = var_8_0[iter_8_3.suitID] or false
			var_8_2.count = arg_8_0.suitCount[iter_8_3.suitID] or 0

			local var_8_3 = gChipSuitCsv[iter_8_3.suitID][6]
			local var_8_4 = {}
			local var_8_5 = 1

			for iter_8_4, iter_8_5 in pairs(var_8_3) do
				local var_8_6 = string.format(gLanguageCsv.chipSuitCount, iter_8_4, "")
				local var_8_7 = string.gsub(var_8_6, "#C0xF3895B#", "#C0xEB580E#")

				if iter_8_5.skillID and iter_8_5.skillID ~= 0 then
					var_8_7 = var_8_7 .. "#C0x57472E#" .. string.gsub(csv.skill[iter_8_5.skillID].describe, "#C0x5B545B#", "#C0x57472E#")
					var_8_7 = string.gsub(var_8_7, "#C0x5c9970#", "#C0x01A001#")
				else
					for iter_8_6 = 1, math.huge do
						local var_8_8 = iter_8_5["attrType" .. iter_8_6]

						if var_8_8 and var_8_8 ~= 0 then
							local var_8_9 = dataEasy.getAttrValueString(var_8_8, iter_8_5["attrNum" .. iter_8_6])

							var_8_7 = var_8_7 .. string.format(gLanguageCsv.chipSuit01, getLanguageAttr(var_8_8), var_8_9)
							var_8_7 = string.gsub(var_8_7, "#C0x3CFF3C#", "#C0x01A001#")
							var_8_7 = string.gsub(var_8_7, "#C0xFFFCED#", "#C0x57472E#")
						end

						local var_8_10 = iter_8_5["attrType" .. iter_8_6 + 1]

						if var_8_10 and var_8_10 ~= 0 then
							var_8_7 = var_8_7 .. "#C0x57472E#,"
						else
							break
						end
					end
				end

				var_8_2.str = var_8_2.str or {}
				var_8_2.str[var_8_5] = var_8_7
				var_8_5 = var_8_5 + 1
			end

			var_8_1[iter_8_3.suitID] = var_8_2
		end
	end

	arg_8_0.suitData:update(var_8_1)
end

function var_0_2.onBtnDelete(arg_9_0)
	var_0_1.onClose(arg_9_0)
end

function var_0_2.onBtnSure(arg_10_0)
	local var_10_0 = {}

	for iter_10_0 = 1, var_0_0 do
		var_10_0[iter_10_0] = arg_10_0.selectUpSuitID[iter_10_0] or 0
	end

	userDefault.setForeverLocalKey("selectUpSuitID", var_10_0)

	if arg_10_0.callBack then
		arg_10_0.callBack()
	end

	var_0_1.onClose(arg_10_0)
end

function var_0_2.setSelectUI(arg_11_0)
	local var_11_0, var_11_1 = arg_11_0.txtVal:xy()
	local var_11_2 = arg_11_0.txtVal:parent()

	arg_11_0.txtVal:visible(false)

	local var_11_3 = var_11_2:get("txtval2")
	local var_11_4 = string.format(gLanguageCsv.chipSuitHasSelect, #arg_11_0.selectUpSuitID, var_0_0)

	if var_11_3 then
		var_11_3:removeFromParent()
	end

	local var_11_5 = rich.createWithWidth(var_11_4, 40, nil, 1039, nil, cc.p(0, 0.5)):anchorPoint(cc.p(0, 0.5)):xy(var_11_0, var_11_1):addTo(var_11_2, 10, "txtval2")
end

function var_0_2.onItemClick(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = 0

	for iter_12_0, iter_12_1 in ipairs(arg_12_0.selectUpSuitID) do
		if iter_12_1 == arg_12_3.id then
			var_12_0 = iter_12_0
		end
	end

	if var_12_0 > 0 then
		table.remove(arg_12_0.selectUpSuitID, var_12_0)

		arg_12_0.suitData:atproxy(arg_12_3.id).select = false
	elseif #arg_12_0.selectUpSuitID >= var_0_0 then
		gGameUI:showTip(gLanguageCsv.chipSuitTip01)
	else
		table.insert(arg_12_0.selectUpSuitID, arg_12_3.id)

		arg_12_0.suitData:atproxy(arg_12_3.id).select = true
	end

	arg_12_0:setSelectUI()
end

return var_0_2
