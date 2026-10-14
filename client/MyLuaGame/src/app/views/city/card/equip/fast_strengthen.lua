local var_0_0 = 5
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("CardAdvanceOneKeyView", Dialog)

var_0_2.RESOURCE_FILENAME = "card_equip_fast_strengthen.json"
var_0_2.RESOURCE_BINDING = {
	["top.nameMax"] = "nameMax",
	["top.cashIcon"] = "cashIcon",
	["top.cashNum"] = "cashNum",
	subList = "subList",
	item = "item",
	["top.name"] = "cardName",
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
			class = "equip_icon",
			props = {
				selected = false,
				data = bindHelper.self("equipData"),
				onNode = function(arg_1_0)
					arg_1_0:setTouchEnabled(false)
					arg_1_0:get("imgArrow"):hide()
				end
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
				dataOrderCmpGen = bindHelper.self("onSortRank", true),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:size()
					local var_2_1 = {
						class = "icon_key",
						props = {
							data = {
								key = arg_2_3.id,
								num = arg_2_3.num,
								targetNum = arg_2_3.targetNum
							},
							grayState = arg_2_3.num < arg_2_3.targetNum and 1 or 0,
							onNode = function(arg_3_0)
								arg_3_0:setTouchEnabled(false)

								local var_3_0 = arg_3_0:size()
								local var_3_1 = arg_3_0:get("addIcon")

								if arg_2_3.targetNum > arg_2_3.num then
									if not var_3_1 then
										ccui.ImageView:create("common/btn/btn_add_icon.png"):xy(var_3_0.width / 2, var_3_0.height / 2):addTo(arg_3_0, 600, "addIcon")
									else
										var_3_1:show()
									end
								elseif var_3_1 then
									var_3_1:hide()
								end
							end
						}
					}

					bind.extend(arg_2_0, arg_2_1, var_2_1)
					bind.touch(arg_2_0, arg_2_1, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	}
}

function var_0_2.onCreate(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	arg_4_0.selectDbId = arg_4_1
	arg_4_0.equipId = arg_4_2
	arg_4_0.cb = arg_4_3

	arg_4_0:initModel()

	local var_4_0 = csv.equips[arg_4_0.equipId]

	arg_4_0.equipData = arg_4_0.equips:read()[var_4_0.part]

	local var_4_1 = var_4_0.name0

	if arg_4_0.equipData.awake ~= 0 then
		var_4_1 = var_4_0.name1 .. gLanguageCsv["symbolRome" .. arg_4_0.equipData.awake]
	end

	local var_4_2, var_4_3 = dataEasy.getQuality(arg_4_0.equipData.advance)

	text.addEffect(arg_4_0.cardName, {
		color = var_4_2 == 1 and ui.COLORS.NORMAL.WHITE or ui.COLORS.QUALITY[var_4_2]
	})

	local var_4_4 = var_4_1 .. var_4_3

	arg_4_0.cardName:text(var_4_4)

	local var_4_5 = 0

	for iter_4_0, iter_4_1 in orderCsvPairs(var_4_0.roleLevelMax) do
		if iter_4_1 <= arg_4_0.roleLv:read() and var_4_5 < iter_4_0 then
			var_4_5 = iter_4_0
		end
	end

	local var_4_6 = var_4_0.strengthMax[math.min(var_4_0.advanceMax, var_4_5 + 1)]
	local var_4_7 = arg_4_0.equipData.advance or 0
	local var_4_8 = arg_4_0.equipData.equip_id
	local var_4_9 = arg_4_0.equipData.level

	arg_4_0.isLvMax = var_4_6 <= var_4_9
	arg_4_0.currLevelLimit = var_4_6

	local var_4_10 = itertools.map(var_4_0.strengthMax, function(arg_5_0, arg_5_1)
		return arg_5_1, arg_5_0
	end)
	local var_4_11 = var_4_9 + 1
	local var_4_12 = {}
	local var_4_13 = 0
	local var_4_14 = true

	for iter_4_2 = var_4_11, var_4_6 do
		if var_4_10[iter_4_2] and var_4_7 <= var_4_10[iter_4_2] then
			local var_4_15 = gEquipAdvanceCsv[var_4_8][var_4_10[iter_4_2]]

			for iter_4_3, iter_4_4 in csvPairs(var_4_15.costItemMap) do
				var_4_12[iter_4_3] = (var_4_12[iter_4_3] or 0) + iter_4_4
				var_4_13 = var_4_13 + var_4_15.costGold

				if var_4_13 > arg_4_0.gold or dataEasy.getNumByKey(iter_4_3) < var_4_12[iter_4_3] then
					var_4_14 = false
				end
			end

			if not var_4_14 then
				var_4_11 = var_4_0.strengthMax[math.min(var_4_0.advanceMax, var_4_10[iter_4_2])]

				break
			end
		end

		var_4_11 = iter_4_2
	end

	arg_4_0.selectLv = idler.new(var_4_11)
	arg_4_0.itemData = idlertable.new({})

	idlereasy.when(arg_4_0.selectLv, function(arg_6_0, arg_6_1)
		local var_6_0 = 0

		var_4_12 = {}
		arg_4_0.isEnoughItem = true

		for iter_6_0 = var_4_9, arg_6_1 - 1 do
			var_6_0 = var_6_0 + csv.base_attribute.equip_strength[iter_6_0]["costGold" .. var_4_0.strengthSeqID]

			if var_4_10[iter_6_0] and var_4_10[iter_6_0] >= var_4_7 then
				local var_6_1 = gEquipAdvanceCsv[var_4_8][var_4_10[iter_6_0]]

				var_6_0 = var_6_0 + var_6_1.costGold

				for iter_6_1, iter_6_2 in csvPairs(var_6_1.costItemMap) do
					var_4_12[iter_6_1] = var_4_12[iter_6_1] or {
						orderKey = 1,
						targetNum = 0,
						id = iter_6_1,
						num = dataEasy.getNumByKey(iter_6_1)
					}
					var_4_12[iter_6_1].targetNum = var_4_12[iter_6_1].targetNum + iter_6_2

					if dataEasy.getNumByKey(iter_6_1) < var_4_12[iter_6_1].targetNum then
						var_4_12[iter_6_1].orderKey = 2
						arg_4_0.isEnoughItem = false
					end
				end
			end
		end

		arg_4_0.isEnoughGoldStrengthen = var_6_0 <= dataEasy.getNumByKey("gold")

		arg_4_0.itemData:set(var_4_12)
		arg_4_0.nameMax:text(arg_6_1)
		arg_4_0.cashNum:text(var_6_0)

		local var_6_2 = arg_4_0.isEnoughGoldStrengthen and ui.COLORS.NORMAL.YELLOW or ui.COLORS.NORMAL.RED

		text.addEffect(arg_4_0.cashNum, {
			color = var_6_2
		})
		adapt.oneLinePos(arg_4_0.cashNum, arg_4_0.cashIcon, cc.p(12, 0))
		cache.setShader(arg_4_0.addBtn, false, arg_6_1 >= var_4_6 and "hsl_gray" or "normal")
		arg_4_0.addBtn:setTouchEnabled(arg_6_1 < var_4_6)
		cache.setShader(arg_4_0.subBtn, false, arg_6_1 <= var_4_9 + 1 and "hsl_gray" or "normal")
		arg_4_0.subBtn:setTouchEnabled(arg_6_1 > var_4_9 + 1)
	end)
	Dialog.onCreate(arg_4_0)
end

function var_0_2.initModel(arg_7_0)
	local var_7_0 = gGameModel.cards:find(arg_7_0.selectDbId)

	arg_7_0.fight = var_7_0:getIdler("fighting_point")
	arg_7_0.equips = var_7_0:getIdler("equips")
	arg_7_0.roleLv = gGameModel.role:getIdler("level")
	arg_7_0.gold = gGameModel.role:read("gold")
end

function var_0_2.onAddClick(arg_8_0)
	arg_8_0.selectLv:set(math.min(arg_8_0.currLevelLimit, arg_8_0.selectLv:read() + var_0_0))
end

function var_0_2.onReduceClick(arg_9_0)
	arg_9_0.selectLv:set(math.max(arg_9_0.equipData.level + 1, arg_9_0.selectLv:read() - var_0_0))
end

function var_0_2.onOneKeyAdvanceClick(arg_10_0)
	local var_10_0 = csv.equips[arg_10_0.equipId]

	if not arg_10_0.isEnoughItem then
		gGameUI:showTip(gLanguageCsv.equipNotEnoughAdvanceItems)

		return
	end

	if arg_10_0.isLvMax then
		gGameUI:showTip(gLanguageCsv.currentLevelNotAvailable)

		return
	end

	if not arg_10_0.isEnoughGoldStrengthen then
		gGameUI:showTip(gLanguageCsv.strengthGoldNotEnough)

		return
	end

	local var_10_1 = {
		false
	}

	gGameApp:requestServerCustom("/game/equip/strength"):params(arg_10_0.selectDbId, var_10_0.part, arg_10_0.selectLv, true):onResponse(function(arg_11_0)
		var_10_1[1] = true
	end):wait(var_10_1):doit(function(arg_12_0)
		local var_12_0 = arg_10_0.itemData:size() > 0

		arg_10_0:addCallbackOnExit(functools.partial(arg_10_0.cb, var_12_0))
		var_0_1.onClose(arg_10_0)
	end)
end

function var_0_2.onItemClick(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	gGameUI:stackUI("common.gain_way", nil, nil, arg_13_3.id, arg_13_0:createHandler("refreshUI"), arg_13_3.num)
end

function var_0_2.refreshUI(arg_14_0)
	arg_14_0.selectLv:notify()
end

function var_0_2.onSortRank(arg_15_0, arg_15_1)
	return function(arg_16_0, arg_16_1)
		if arg_16_0.orderKey ~= arg_16_1.orderKey then
			return arg_16_0.orderKey > arg_16_1.orderKey
		end

		return arg_16_0.id < arg_16_1.id
	end
end

return var_0_2
