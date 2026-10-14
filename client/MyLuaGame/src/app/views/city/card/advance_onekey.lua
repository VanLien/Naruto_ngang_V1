local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("CardAdvanceOneKeyView", Dialog)

var_0_1.RESOURCE_FILENAME = "card_advance_onekey.json"
var_0_1.RESOURCE_BINDING = {
	["top.cashNum"] = "cashNum",
	subList = "subList",
	["top.nameMax"] = "nameMax",
	["top.name"] = "cardName",
	item = "item",
	closeBtn = {
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
	["top.subBtn"] = {
		varname = "subBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onReduceClick")
			}
		}
	},
	["top.addBtn"] = {
		varname = "addBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAddClick")
			}
		}
	},
	sureBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onOneKeyAdvanceClick")
			}
		}
	},
	cancelBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["cancelBtn.title"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["sureBtn.title"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	card = {
		binds = {
			event = "extend",
			class = "card_icon",
			props = {
				cardId = bindHelper.self("cardId"),
				advance = bindHelper.self("advance")
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 12,
				columnSize = 6,
				data = bindHelper.self("itemData"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:size()
					local var_1_1 = {
						class = "icon_key",
						props = {
							data = {
								key = arg_1_3.id,
								num = arg_1_3.num
							}
						}
					}

					bind.extend(arg_1_0, arg_1_1, var_1_1)
				end
			}
		}
	}
}

function var_0_1.onCreate(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.selectDbId = arg_2_1
	arg_2_0.cb = arg_2_2

	arg_2_0:initModel()

	arg_2_0.itemData = idlertable.new({})

	local var_2_0 = arg_2_0.advance:read()
	local var_2_1 = arg_2_0.cardId:read()
	local var_2_2 = arg_2_0.cardLv:read()
	local var_2_3 = {}
	local var_2_4 = {}
	local var_2_5 = var_2_0 + 1
	local var_2_6 = {}
	local var_2_7 = csv.cards[var_2_1]
	local var_2_8 = var_2_7.advanceLevelReq
	local var_2_9 = gCardAdvanceCsv[var_2_7.advanceTypeID]

	for iter_2_0 = var_2_0, csvSize(var_2_9) do
		var_2_5 = iter_2_0

		for iter_2_1, iter_2_2 in pairs(var_2_6) do
			if not var_2_4[iter_2_0] then
				var_2_4[iter_2_0] = {}
			end

			table.insert(var_2_4[iter_2_0], {
				id = iter_2_1,
				num = iter_2_2
			})
		end

		local var_2_10 = csv.cards[var_2_1].advanceMax

		if var_2_2 < var_2_8[iter_2_0] or var_2_10 <= iter_2_0 then
			break
		end

		var_2_3[iter_2_0 + 1] = (var_2_3[iter_2_0] or 0) + var_2_9[iter_2_0].gold

		if dataEasy.getNumByKey("gold") < var_2_3[iter_2_0 + 1] then
			break
		end

		local var_2_11 = false

		for iter_2_3, iter_2_4 in csvPairs(var_2_9[iter_2_0].itemMap) do
			var_2_6[iter_2_3] = (var_2_6[iter_2_3] or 0) + iter_2_4

			if dataEasy.getNumByKey(iter_2_3) < var_2_6[iter_2_3] then
				var_2_11 = true

				break
			end
		end

		if var_2_11 then
			break
		end
	end

	arg_2_0.selectAdvance = idler.new(var_2_5)

	idlereasy.when(arg_2_0.selectAdvance, function(arg_3_0, arg_3_1)
		local var_3_0 = var_2_4[arg_3_1] or {}

		if next(var_3_0) then
			table.sort(var_3_0, function(arg_4_0, arg_4_1)
				return arg_4_0.id < arg_4_1.id
			end)
		end

		arg_2_0.itemData:set(var_3_0)
		arg_2_0.cashNum:text(var_2_3[arg_3_1])
		cache.setShader(arg_2_0.addBtn, false, arg_3_1 >= var_2_5 and "hsl_gray" or "normal")
		arg_2_0.addBtn:setTouchEnabled(arg_3_1 < var_2_5)
		uiEasy.setIconName("card", var_2_1, {
			space = true,
			node = arg_2_0.nameMax,
			name = ui.QUALITY_COLOR_TEXT,
			advance = arg_3_1
		})
		cache.setShader(arg_2_0.subBtn, false, arg_3_1 <= var_2_0 + 1 and "hsl_gray" or "normal")
		arg_2_0.subBtn:setTouchEnabled(arg_3_1 > var_2_0 + 1)
	end)
	uiEasy.setIconName("card", var_2_1, {
		space = true,
		node = arg_2_0.cardName,
		name = ui.QUALITY_COLOR_TEXT,
		advance = var_2_0
	})
	Dialog.onCreate(arg_2_0)
end

function var_0_1.initModel(arg_5_0)
	local var_5_0 = gGameModel.cards:find(arg_5_0.selectDbId)

	arg_5_0.advance = var_5_0:getIdler("advance")
	arg_5_0.cardId = var_5_0:getIdler("card_id")
	arg_5_0.cardLv = var_5_0:getIdler("level")
	arg_5_0.fight = var_5_0:getIdler("fighting_point")
end

function var_0_1.onAddClick(arg_6_0)
	arg_6_0.selectAdvance:set(arg_6_0.selectAdvance:read() + 1)
end

function var_0_1.onReduceClick(arg_7_0)
	arg_7_0.selectAdvance:set(arg_7_0.selectAdvance:read() - 1)
end

function var_0_1.onOneKeyAdvanceClick(arg_8_0)
	gGameApp:requestServer("/game/card/advance", function(arg_9_0)
		arg_8_0:addCallbackOnExit(arg_8_0.cb)
		var_0_0.onClose(arg_8_0)
	end, arg_8_0.selectDbId, arg_8_0.selectAdvance:read() - arg_8_0.advance:read())
end

return var_0_1
