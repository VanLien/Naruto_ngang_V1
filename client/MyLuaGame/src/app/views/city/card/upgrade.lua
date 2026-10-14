local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("CardUpgradeView", Dialog)

var_0_1.RESOURCE_FILENAME = "card_upgrade.json"
var_0_1.RESOURCE_BINDING = {
	item = "upGradeItem",
	btnSelectItem = "btnSelectItem",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	list = {
		varname = "upGradeList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				data = bindHelper.self("upGradeData"),
				item = bindHelper.self("upGradeItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("icon"):size()
					local var_1_1 = {
						class = "icon_key",
						props = {
							data = {
								key = arg_1_3.id
							},
							grayState = arg_1_3.num <= 0 and 1 or 0,
							onNode = function(arg_2_0)
								arg_2_0:setTouchEnabled(false)

								if arg_1_3.state and arg_1_3.num > 0 then
									if arg_1_3.selectEffect:parent() then
										arg_1_3.selectEffect:removeSelf()
									end

									arg_2_0:add(arg_1_3.selectEffect, 10)
								elseif arg_1_3.selectEffect:parent() then
									arg_1_3.selectEffect:removeSelf()
								end
							end
						}
					}

					bind.extend(arg_1_0, arg_1_1:get("icon"), var_1_1)

					local var_1_2 = arg_1_3.canUse or 0

					arg_1_1:get("txt"):setString(var_1_2 .. "/" .. arg_1_3.num)
					bind.touch(arg_1_0, arg_1_1:get("icon"), {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	},
	sliderNum = {
		binds = {
			event = "text",
			idler = bindHelper.self("sliderNum")
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
	subBtn = {
		varname = "subBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_3_0, arg_3_1, arg_3_2)
				return arg_3_0:onChangeNum(arg_3_1, arg_3_2, -1)
			end)
		}
	},
	addBtn = {
		varname = "addBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_4_0, arg_4_1, arg_4_2)
				return arg_4_0:onChangeNum(arg_4_1, arg_4_2, 1)
			end)
		}
	},
	subBtn10 = {
		varname = "subBtn10",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_5_0, arg_5_1, arg_5_2)
				return arg_5_0:onChangeNum(arg_5_1, arg_5_2, -10)
			end)
		}
	},
	addBtn10 = {
		varname = "addBtn10",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_6_0, arg_6_1, arg_6_2)
				return arg_6_0:onChangeNum(arg_6_1, arg_6_2, 10)
			end)
		}
	},
	subBtns = {
		varname = "subBtnMax",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_7_0, arg_7_1, arg_7_2)
				return arg_7_0:onChangeNum(arg_7_1, arg_7_2, -10000)
			end)
		}
	},
	addBtnl = {
		varname = "addBtnMax",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_8_0, arg_8_1, arg_8_2)
				return arg_8_0:onChangeNum(arg_8_1, arg_8_2, 10000)
			end)
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
	}
}

function var_0_1.onCreate(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if arg_9_1.type == 1 then
		arg_9_0.btnSelectItem:hide()
	end

	arg_9_0.selectDbId = arg_9_1.selectDbId
	arg_9_0.cb = arg_9_2

	arg_9_0:enableSchedule()
	arg_9_0:initModel()

	arg_9_0.selectItems = {}
	arg_9_0.upGradeData1 = {
		{},
		{},
		{},
		{},
		{},
		{}
	}
	arg_9_0.upGradeData = idlers.newWithMap(arg_9_0.upGradeData1)

	idlereasy.when(arg_9_0.items, function(arg_10_0, arg_10_1)
		for iter_10_0, iter_10_1 in ipairs(gCardExpItemCsv) do
			local var_10_0 = iter_10_1.id

			arg_9_0.upGradeData:at(iter_10_0):modify(function(arg_11_0)
				arg_11_0.num = arg_10_1[var_10_0] or 0
				arg_11_0.id = var_10_0
				arg_11_0.cfg = iter_10_1
			end, true)
		end
	end)

	for iter_9_0, iter_9_1 in pairs(arg_9_0.upGradeData1) do
		arg_9_0.selectEffect = ccui.ImageView:create("common/icon/icon_selected_big.png")

		arg_9_0.selectEffect:align(cc.p(1, 0), 180, 20)
		arg_9_0.selectEffect:retain()

		arg_9_0.upGradeData:atproxy(iter_9_0).selectEffect = arg_9_0.selectEffect
		arg_9_0.upGradeData:atproxy(iter_9_0).state = true
	end

	arg_9_0.myAllExp = idler.new(0)
	arg_9_0.selectState = idlertable.new({
		true,
		true,
		true,
		true,
		true,
		true
	})

	idlereasy.when(arg_9_0.selectState, function(arg_12_0, arg_12_1)
		local var_12_0 = 0

		for iter_12_0, iter_12_1 in ipairs(arg_9_0.upGradeData1) do
			arg_9_0.upGradeData:atproxy(iter_12_0).state = arg_12_1[iter_12_0]

			if arg_12_1[iter_12_0] then
				var_12_0 = var_12_0 + iter_12_1.cfg.specialArgsMap.exp * iter_12_1.num
			end
		end

		arg_9_0.myAllExp:set(var_12_0)
	end)

	arg_9_0.canMaxLv = idler.new(0)
	arg_9_0.selectLevel = idler.new(0)
	arg_9_0.sliderNum = idler.new("")

	idlereasy.any({
		arg_9_0.roleLv,
		arg_9_0.cardId,
		arg_9_0.cardLv,
		arg_9_0.currExp,
		arg_9_0.myAllExp
	}, function(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
		local var_13_0 = 0
		local var_13_1 = 0
		local var_13_2 = csvSize(csv.base_attribute.card_level)

		for iter_13_0 = arg_13_3, var_13_2 do
			var_13_0 = var_13_0 + csv.base_attribute.card_level[iter_13_0]["levelExp" .. csv.cards[arg_13_2].levelExpID]

			if var_13_0 > arg_13_5 + arg_13_4 or var_13_2 == iter_13_0 then
				var_13_1 = iter_13_0

				break
			end
		end

		local var_13_3 = math.min(var_13_1, arg_13_1)

		arg_9_0.canMaxLv:set(var_13_3)

		local var_13_4 = math.min(arg_9_0.selectLevel:read(), math.min(var_13_3, arg_13_1) - arg_13_3)

		arg_9_0.selectLevel:set(var_13_4)
	end)
	idlereasy.any({
		arg_9_0.selectLevel,
		arg_9_0.roleLv,
		arg_9_0.currExp,
		arg_9_0.cardLv,
		arg_9_0.canMaxLv,
		arg_9_0.selectState
	}, function(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
		arg_14_1 = arg_14_2 >= arg_14_4 + arg_14_1 and arg_14_1 or arg_14_5 - arg_14_4

		arg_9_0.sliderNum:set(arg_14_4 + arg_14_1 .. "/" .. arg_14_2)

		local var_14_0 = 0

		for iter_14_0 = arg_14_4, arg_14_4 + arg_14_1 - 1 do
			var_14_0 = var_14_0 + csv.base_attribute.card_level[iter_14_0]["levelExp" .. csv.cards[arg_9_0.cardId:read()].levelExpID]
		end

		local var_14_1 = arg_14_3
		local var_14_2 = {}
		local var_14_3 = false

		arg_9_0.selectItems = {}

		for iter_14_1, iter_14_2 in ipairs(arg_9_0.upGradeData1) do
			if arg_14_6[iter_14_1] then
				for iter_14_3 = 1, iter_14_2.num do
					if var_14_0 <= var_14_1 then
						var_14_3 = true

						break
					end

					if arg_14_1 ~= 0 then
						var_14_2[iter_14_1] = iter_14_3
						arg_9_0.selectItems[iter_14_2.id] = iter_14_3
					end

					var_14_1 = var_14_1 + iter_14_2.cfg.specialArgsMap.exp
				end
			end

			if var_14_3 then
				break
			end
		end

		for iter_14_4 = 1, 6 do
			arg_9_0.upGradeData:atproxy(iter_14_4).canUse = var_14_2[iter_14_4] or 0
		end

		cache.setShader(arg_9_0.addBtn, false, arg_14_5 <= arg_14_1 + arg_14_4 and "hsl_gray" or "normal")
		cache.setShader(arg_9_0.subBtn, false, arg_14_1 <= 0 and "hsl_gray" or "normal")
		cache.setShader(arg_9_0.addBtn10, false, arg_14_5 <= arg_14_1 + arg_14_4 and "hsl_gray" or "normal")
		cache.setShader(arg_9_0.subBtn10, false, arg_14_1 <= 0 and "hsl_gray" or "normal")
		cache.setShader(arg_9_0.addBtnMax, false, arg_14_5 <= arg_14_1 + arg_14_4 and "hsl_gray" or "normal")
		cache.setShader(arg_9_0.subBtnMax, false, arg_14_1 <= 0 and "hsl_gray" or "normal")
		arg_9_0.addBtn:setTouchEnabled(arg_14_5 > arg_14_1 + arg_14_4)
		arg_9_0.subBtn:setTouchEnabled(arg_14_1 > 0)
		arg_9_0.addBtn10:setTouchEnabled(arg_14_5 > arg_14_1 + arg_14_4)
		arg_9_0.subBtn10:setTouchEnabled(arg_14_1 > 0)
		arg_9_0.addBtnMax:setTouchEnabled(arg_14_5 > arg_14_1 + arg_14_4)
		arg_9_0.subBtnMax:setTouchEnabled(arg_14_1 > 0)
	end)
	Dialog.onCreate(arg_9_0)
end

function var_0_1.initModel(arg_15_0)
	arg_15_0.roleLv = gGameModel.role:getIdler("level")
	arg_15_0.items = gGameModel.role:getIdler("items")

	local var_15_0 = gGameModel.cards:find(arg_15_0.selectDbId)

	arg_15_0.cardId = var_15_0:getIdler("card_id")
	arg_15_0.cardLv = var_15_0:getIdler("level")
	arg_15_0.currExp = var_15_0:getIdler("level_exp")
end

function var_0_1.onItemClick(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	if arg_16_3.num <= 0 then
		gGameUI:showTip(gLanguageCsv.selectedMaterialsNotEnough)

		return
	end

	arg_16_0.selectState:proxy()[arg_16_2] = not arg_16_0.selectState:proxy()[arg_16_2]
end

function var_0_1.onAddClick(arg_17_0)
	arg_17_0.selectLevel:set(arg_17_0.selectLevel:read() + 1)
end

function var_0_1.onReduceClick(arg_18_0)
	arg_18_0.selectLevel:set(arg_18_0.selectLevel:read() - 1)
end

function var_0_1.onIncreaseNum(arg_19_0, arg_19_1)
	arg_19_0.selectLevel:modify(function(arg_20_0)
		return true, cc.clampf(arg_20_0 + arg_19_1, 0, arg_19_0.canMaxLv:read() - arg_19_0.cardLv:read())
	end)
end

function var_0_1.onChangeNum(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	arg_21_0:onIncreaseNum(arg_21_3)
end

function var_0_1.onClose(arg_22_0)
	Dialog.onClose(arg_22_0)
end

function var_0_1.onCleanup(arg_23_0)
	if arg_23_0.selectEffect then
		arg_23_0.selectEffect:release()

		arg_23_0.selectEffect = nil
	end

	Dialog.onCleanup(arg_23_0)
end

function var_0_1.onSureClick(arg_24_0)
	if arg_24_0.myAllExp:read() == 0 then
		gGameUI:showTip(gLanguageCsv.pleaseSelectMaterials)

		return
	end

	if next(arg_24_0.selectItems) == nil or arg_24_0.selectLevel:read() <= 0 then
		gGameUI:showTip(gLanguageCsv.pleaseSelectTargetLevel)

		return
	end

	gGameApp:requestServer("/game/card/exp/use_items", function(arg_25_0)
		arg_24_0.selectLevel:set(0)
		arg_24_0:addCallbackOnExit(arg_24_0.cb)
		var_0_0.onClose(arg_24_0)
	end, arg_24_0.selectDbId, arg_24_0.selectItems)
end

return var_0_1
