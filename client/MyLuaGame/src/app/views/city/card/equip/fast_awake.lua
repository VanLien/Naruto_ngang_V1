local var_0_0 = 1
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("CardAwakeOneKeyView", Dialog)

var_0_2.RESOURCE_FILENAME = "card_equip_fast_strengthen.json"
var_0_2.RESOURCE_BINDING = {
	["top.nameMax"] = "nameMax",
	item = "item",
	title = "title",
	subList = "subList",
	["top.cashNum"] = "cashNum",
	["top.cashIcon"] = "cashIcon",
	["top.name"] = "cardName",
	["top.cashNote"] = "cashNote",
	titleTxt1 = {
		varname = "titleTxt1",
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
		varname = "titleTxt2",
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
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
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
				ended = bindHelper.self("onSureClick")
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
	arg_4_0.title:hide()
	arg_4_0.titleTxt2:text(gLanguageCsv.awake)

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

	local var_4_5 = var_4_0.awakeAbilityMax

	arg_4_0.currLevelLimit = var_4_5

	local var_4_6 = arg_4_0.equipData.awake_ability or 0
	local var_4_7 = arg_4_0.equipData.equip_id
	local var_4_8 = var_4_6 + 1
	local var_4_9 = {}
	local var_4_10 = 0
	local var_4_11 = true

	for iter_4_0 = var_4_6, arg_4_0.currLevelLimit - 1 do
		local var_4_12 = csv.base_attribute.equip_awake_ability[iter_4_0]["costItemMap" .. var_4_0.awakeAbilitySeqID]

		for iter_4_1, iter_4_2 in csvMapPairs(var_4_12) do
			if iter_4_1 == "gold" then
				if arg_4_0.gold < var_4_10 + iter_4_2 then
					var_4_11 = false

					break
				else
					var_4_10 = var_4_10 + iter_4_2
				end
			elseif dataEasy.getNumByKey(iter_4_1) < (var_4_9[iter_4_1] or 0) + iter_4_2 then
				var_4_11 = false

				break
			else
				var_4_9[iter_4_1] = (var_4_9[iter_4_1] or 0) + iter_4_2
			end
		end

		if var_4_11 then
			var_4_8 = iter_4_0 + 1
		else
			break
		end
	end

	arg_4_0.selectLv = idler.new(var_4_8)
	arg_4_0.itemData = idlertable.new({})

	idlereasy.when(arg_4_0.selectLv, function(arg_5_0, arg_5_1)
		local var_5_0 = 0

		var_4_9 = {}
		arg_4_0.isEnoughItem = true

		for iter_5_0 = var_4_6, arg_5_1 - 1 do
			local var_5_1 = csv.base_attribute.equip_awake_ability[iter_5_0]["costItemMap" .. var_4_0.awakeAbilitySeqID]

			for iter_5_1, iter_5_2 in csvMapPairs(var_5_1) do
				if iter_5_1 == "gold" then
					var_5_0 = var_5_0 + iter_5_2
				else
					var_4_9[iter_5_1] = var_4_9[iter_5_1] or {
						orderKey = 1,
						targetNum = 0,
						id = iter_5_1,
						num = dataEasy.getNumByKey(iter_5_1)
					}
					var_4_9[iter_5_1].targetNum = var_4_9[iter_5_1].targetNum + iter_5_2

					if dataEasy.getNumByKey(iter_5_1) < var_4_9[iter_5_1].targetNum then
						var_4_9[iter_5_1].orderKey = 2
						arg_4_0.isEnoughItem = false
					end
				end
			end
		end

		if var_5_0 == 0 then
			itertools.invoke({
				arg_4_0.cashNote,
				arg_4_0.cashNum,
				arg_4_0.cashIcon
			}, "hide")
		else
			itertools.invoke({
				arg_4_0.cashNote,
				arg_4_0.cashNum,
				arg_4_0.cashIcon
			}, "show")
		end

		arg_4_0.isEnoughGold = var_5_0 <= dataEasy.getNumByKey("gold")

		arg_4_0.itemData:set(var_4_9)
		arg_4_0.nameMax:text(arg_5_1)
		arg_4_0.cashNum:text(var_5_0)

		local var_5_2 = arg_4_0.isEnoughGold and ui.COLORS.NORMAL.WHITE or ui.COLORS.NORMAL.RED

		text.addEffect(arg_4_0.cashNum, {
			color = var_5_2
		})
		adapt.oneLinePos(arg_4_0.cashNum, arg_4_0.cashIcon, cc.p(12, 0))
		cache.setShader(arg_4_0.addBtn, false, arg_5_1 >= var_4_5 and "hsl_gray" or "normal")
		arg_4_0.addBtn:setTouchEnabled(arg_5_1 < var_4_5)
		cache.setShader(arg_4_0.subBtn, false, arg_5_1 <= var_4_6 + 1 and "hsl_gray" or "normal")
		arg_4_0.subBtn:setTouchEnabled(arg_5_1 > var_4_6 + 1)
	end)
	Dialog.onCreate(arg_4_0)
end

function var_0_2.initModel(arg_6_0)
	local var_6_0 = gGameModel.cards:find(arg_6_0.selectDbId)

	arg_6_0.fight = var_6_0:getIdler("fighting_point")
	arg_6_0.equips = var_6_0:getIdler("equips")
	arg_6_0.roleLv = gGameModel.role:getIdler("level")
	arg_6_0.gold = gGameModel.role:read("gold")
end

function var_0_2.onAddClick(arg_7_0)
	arg_7_0.selectLv:set(math.min(arg_7_0.currLevelLimit, arg_7_0.selectLv:read() + var_0_0))
end

function var_0_2.onReduceClick(arg_8_0)
	arg_8_0.selectLv:set(math.max(arg_8_0.equipData.awake_ability + 1, arg_8_0.selectLv:read() - var_0_0))
end

function var_0_2.onSureClick(arg_9_0)
	local var_9_0 = csv.equips[arg_9_0.equipId]

	if not arg_9_0.isEnoughItem then
		gGameUI:showTip(gLanguageCsv.equipNotEnoughAwakeItems)

		return
	end

	if not arg_9_0.isEnoughGold then
		gGameUI:showTip(gLanguageCsv.strengthGoldNotEnough)

		return
	end

	local var_9_1 = {
		false
	}

	gGameApp:requestServerCustom("/game/equip/awake/ability"):params(arg_9_0.selectDbId, var_9_0.part, arg_9_0.selectLv:read() - arg_9_0.equipData.awake_ability):onResponse(function(arg_10_0)
		var_9_1[1] = true
	end):wait(var_9_1):doit(function(arg_11_0)
		arg_9_0:addCallbackOnExit(functools.partial(arg_9_0.cb))
		var_0_1.onClose(arg_9_0)
	end)
end

function var_0_2.onItemClick(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	gGameUI:stackUI("common.gain_way", nil, nil, arg_12_3.id, arg_12_0:createHandler("refreshUI"), arg_12_3.num)
end

function var_0_2.refreshUI(arg_13_0)
	arg_13_0.selectLv:notify()
end

function var_0_2.onSortRank(arg_14_0, arg_14_1)
	return function(arg_15_0, arg_15_1)
		if arg_15_0.orderKey ~= arg_15_1.orderKey then
			return arg_15_0.orderKey > arg_15_1.orderKey
		end

		return arg_15_0.id < arg_15_1.id
	end
end

return var_0_2
