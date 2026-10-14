local var_0_0 = class("ChipSuitPreView", Dialog)

var_0_0.RESOURCE_FILENAME = "chip_suit_preview.json"
var_0_0.RESOURCE_BINDING = {
	name = "name",
	item = "item",
	suit1 = "suit1",
	icon = "icon",
	suit3 = "suit3",
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
	},
	downList = {
		varname = "downList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("suitData"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("icon"):texture(arg_1_3.icon)
					arg_1_1:get("select"):visible(arg_1_3.select)
					arg_1_1:onTouch(functools.partial(arg_1_0.clickCell, arg_1_1, arg_1_2, arg_1_3))
				end
			},
			handlers = {
				clickCell = bindHelper.self("btnSuitFunc")
			}
		}
	},
	icon1 = {
		varname = "icon1",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_2_0)
					arg_2_0:atrributeBtn(2)
				end)
			}
		}
	},
	icon2 = {
		varname = "icon2",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_3_0)
					arg_3_0:atrributeBtn(3)
				end)
			}
		}
	},
	icon3 = {
		varname = "icon3",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_4_0)
					arg_4_0:atrributeBtn(4)
				end)
			}
		}
	},
	icon4 = {
		varname = "icon4",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_5_0)
					arg_5_0:atrributeBtn(5)
				end)
			}
		}
	},
	icon5 = {
		varname = "icon5",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_6_0)
					arg_6_0:atrributeBtn(6)
				end)
			}
		}
	},
	suitList = {
		varname = "suitList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("suitAttrDatas"),
				item = bindHelper.self("suit3"),
				item01 = bindHelper.self("suit1"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					local var_7_0 = arg_7_0:size().width

					arg_7_1:removeAllChildren()

					if arg_7_3.sign == 1 then
						arg_7_1:size(cc.size(var_7_0, 80))
						arg_7_0.item01:clone():anchorPoint(cc.p(0, 0.5)):xy(0, 40):addTo(arg_7_1):show():get("txt"):text(arg_7_3.str)
					else
						arg_7_1:size(cc.size(var_7_0, 80))

						local var_7_1 = rich.createWithWidth(arg_7_3.str, 40, nil, 1039, nil, cc.p(0, 0)):anchorPoint(cc.p(0, 1)):xy(10, 70):addTo(arg_7_1)
					end
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_8_0)
	arg_8_0.suitID = idler.new(1)
	arg_8_0.quality = idler.new(2)
	arg_8_0.suitData = idlers.new({})
	arg_8_0.suitAttrDatas = idlertable.new({})

	arg_8_0:onSetSuitData()
	arg_8_0.suitID:addListener(function(arg_9_0, arg_9_1)
		arg_8_0.suitData:atproxy(arg_9_1).select = false
		arg_8_0.suitData:atproxy(arg_9_0).select = true

		arg_8_0:initSelectUI(arg_9_0)
		arg_8_0:updateSuitAttrs()
	end)
	arg_8_0.quality:addListener(function(arg_10_0, arg_10_1)
		arg_8_0:updateQualityBtn(arg_10_0)
		arg_8_0:updateSuitAttrs()
	end)
	Dialog.onCreate(arg_8_0)
end

function var_0_0.onSetSuitData(arg_11_0)
	local var_11_0 = arg_11_0.suitID:read()
	local var_11_1 = {}

	for iter_11_0, iter_11_1 in ipairs(csv.chip.suits) do
		local var_11_2 = {}

		if not var_11_1[iter_11_1.suitID] then
			var_11_2.id = iter_11_1.suitID
			var_11_2.icon = iter_11_1.suitIcon
			var_11_2.name = iter_11_1.suitName
			var_11_2.select = var_11_0 == iter_11_1.suitID
			var_11_1[iter_11_1.suitID] = var_11_2
		end
	end

	arg_11_0.suitData:update(var_11_1)
end

function var_0_0.initSelectUI(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0.suitData:atproxy(arg_12_1)

	arg_12_0.name:text(var_12_0.name)
	arg_12_0.icon:texture(var_12_0.icon)
end

function var_0_0.updateQualityBtn(arg_13_0, arg_13_1)
	for iter_13_0 = 2, 6 do
		arg_13_0["icon" .. iter_13_0 - 1]:get("select"):visible(iter_13_0 == arg_13_1)
	end
end

function var_0_0.updateSuitAttrs(arg_14_0)
	local var_14_0 = arg_14_0.suitID:read()
	local var_14_1 = arg_14_0.quality:read()
	local var_14_2 = gChipSuitCsv[var_14_0][var_14_1]
	local var_14_3 = {}

	for iter_14_0, iter_14_1 in pairs(var_14_2) do
		table.insert(var_14_3, {
			sign = 1,
			str = string.format("%s%s", gLanguageCsv["symbolNumber" .. iter_14_0], gLanguageCsv.emboitement)
		})

		local var_14_4 = ""

		if iter_14_1.skillID and iter_14_1.skillID ~= 0 then
			var_14_4 = "#C0x8A5B0C#" .. csv.skill[iter_14_1.skillID].describe
		else
			for iter_14_2 = 1, math.huge do
				local var_14_5 = iter_14_1["attrType" .. iter_14_2]

				if var_14_5 and var_14_5 ~= 0 then
					local var_14_6 = dataEasy.getAttrValueString(var_14_5, iter_14_1["attrNum" .. iter_14_2])

					var_14_4 = var_14_4 .. string.format(gLanguageCsv.chipSuit02, getLanguageAttr(var_14_5), var_14_6)
					var_14_4 = string.gsub(var_14_4, "#C0x5B545B#", "#C0x8A5B0C#")
				end

				local var_14_7 = iter_14_1["attrType" .. iter_14_2 + 1]

				if var_14_7 and var_14_7 ~= 0 then
					var_14_4 = var_14_4 .. "#C0x8A5B0C#, "
				else
					break
				end
			end
		end

		table.insert(var_14_3, {
			sign = 2,
			str = var_14_4
		})
	end

	arg_14_0.suitAttrDatas:set(var_14_3)
end

function var_0_0.atrributeBtn(arg_15_0, arg_15_1)
	arg_15_0.quality:set(arg_15_1)
end

function var_0_0.btnSuitFunc(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	arg_16_0.suitID:set(arg_16_4.id)
end

return var_0_0
