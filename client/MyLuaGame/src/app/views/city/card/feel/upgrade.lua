local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("CardFeelView", Dialog)

var_0_1.RESOURCE_FILENAME = "card_upgrade.json"
var_0_1.RESOURCE_BINDING = {
	["btnSelectItem.note"] = "note",
	item = "upGradeItem",
	titleTxt1 = "titleTxt1",
	txt = "titleTxt",
	["btnSelectItem.img"] = "img",
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

								if arg_1_3.selectEffect then
									if arg_1_3.state and arg_1_3.num > 0 then
										if arg_1_3.selectEffect:parent() then
											arg_1_3.selectEffect:removeSelf()
										end

										arg_2_0:add(arg_1_3.selectEffect, 10)
									elseif arg_1_3.selectEffect:parent() then
										arg_1_3.selectEffect:removeSelf()
									end
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
				end,
				onAfterBuild = function(arg_3_0)
					arg_3_0:setItemAlignCenter()
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
				color = ui.COLORS.NORMAL.YELLOW,
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
				color = ui.COLORS.NORMAL.YELLOW,
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
			method = bindHelper.defer(function(arg_4_0, arg_4_1, arg_4_2)
				return arg_4_0:onChangeNum(arg_4_1, arg_4_2, -1)
			end)
		}
	},
	addBtn = {
		varname = "addBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_5_0, arg_5_1, arg_5_2)
				return arg_5_0:onChangeNum(arg_5_1, arg_5_2, 1)
			end)
		}
	},
	subBtn10 = {
		varname = "subBtn10",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_6_0, arg_6_1, arg_6_2)
				return arg_6_0:onChangeNum(arg_6_1, arg_6_2, -10)
			end)
		}
	},
	addBtn10 = {
		varname = "addBtn10",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_7_0, arg_7_1, arg_7_2)
				return arg_7_0:onChangeNum(arg_7_1, arg_7_2, 10)
			end)
		}
	},
	subBtns = {
		varname = "subBtnMax",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_8_0, arg_8_1, arg_8_2)
				return arg_8_0:onChangeNum(arg_8_1, arg_8_2, -10000)
			end)
		}
	},
	addBtnl = {
		varname = "addBtnMax",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_9_0, arg_9_1, arg_9_2)
				return arg_9_0:onChangeNum(arg_9_1, arg_9_2, 1000)
			end)
		}
	},
	sureBtn = {
		varname = "sureBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSureClick")
			}
		}
	},
	cancelBtn = {
		varname = "cancelBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnSelectItem = {
		varname = "btnSelectItem",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnSelectItem")
			}
		}
	}
}

function var_0_1.onCreate(arg_10_0, arg_10_1)
	if arg_10_1.type == 1 then
		arg_10_0.btnSelectItem:hide()
	end

	arg_10_0.selectSetState = arg_10_1.selectState

	arg_10_0.titleTxt:text(gLanguageCsv.feelOneKeyTitleText)
	arg_10_0.titleTxt1:text(gLanguageCsv.quickText)

	arg_10_0.cardMarkID = arg_10_1.cardMarkID
	arg_10_0.cardId = arg_10_1.cardId

	local var_10_0 = csv.cards[arg_10_0.cardId]
	local var_10_1 = gGoodFeelCsv[var_10_0.feelType]

	arg_10_0:enableSchedule()
	arg_10_0:initModel()

	arg_10_0.selectItems = {}
	arg_10_0.upGradeData1 = {}
	arg_10_0.upGradeData = idlers.newWithMap(arg_10_0.upGradeData1)

	idlereasy.when(arg_10_0.items, function(arg_11_0, arg_11_1)
		for iter_11_0, iter_11_1 in orderCsvPairs(var_10_0.feelItems) do
			table.insert(arg_10_0.upGradeData1, {
				id = iter_11_1,
				num = arg_11_1[iter_11_1] or 0,
				cfg = csv.items[iter_11_1]
			})
		end

		arg_10_0.upGradeData:update(arg_10_0.upGradeData1)
	end)
	arg_10_0.note:text(gLanguageCsv.cardFeelViewtext)

	if arg_10_1.type == 2 then
		arg_10_0.sureBtn:y(485)
		arg_10_0.cancelBtn:y(485)
	end

	adapt.oneLineCenterPos(cc.p(160, 40), {
		arg_10_0.img,
		arg_10_0.note
	}, cc.p(5, 0))

	for iter_10_0, iter_10_1 in ipairs(arg_10_0.upGradeData1) do
		arg_10_0.selectEffect = ccui.ImageView:create("common/icon/icon_selected_big.png")

		arg_10_0.selectEffect:align(cc.p(1, 0), 180, 20)
		arg_10_0.selectEffect:retain()

		arg_10_0.upGradeData:atproxy(iter_10_0).selectEffect = arg_10_0.selectEffect
		arg_10_0.upGradeData:atproxy(iter_10_0).state = true
	end

	arg_10_0.myAllExp = idler.new(0)

	local var_10_2 = {}

	for iter_10_2, iter_10_3 in ipairs(arg_10_0.upGradeData1) do
		if selectSetState == true then
			if iter_10_3.cfg.specialArgsMap.special == true then
				table.insert(var_10_2, false)
			else
				table.insert(var_10_2, true)
			end
		else
			table.insert(var_10_2, true)
		end
	end

	arg_10_0.selectState = idlertable.new(var_10_2)

	idlereasy.when(arg_10_0.selectState, function(arg_12_0, arg_12_1)
		local var_12_0 = 0

		for iter_12_0, iter_12_1 in ipairs(arg_10_0.upGradeData1) do
			arg_10_0.upGradeData:atproxy(iter_12_0).state = arg_12_1[iter_12_0]

			if arg_12_1[iter_12_0] and (arg_10_0.selectSetState:read() ~= true or iter_12_1.cfg.specialArgsMap.special ~= true) then
				var_12_0 = var_12_0 + iter_12_1.cfg.specialArgsMap.feel_exp * iter_12_1.num
			end
		end

		arg_10_0.myAllExp:set(var_12_0)
	end)
	idlereasy.any({
		arg_10_0.selectSetState,
		arg_10_0.upGradeData
	}, function(arg_13_0, arg_13_1, arg_13_2)
		local var_13_0 = arg_13_1 and "common/icon/radio_selected.png" or "common/icon/radio_normal.png"

		arg_10_0.btnSelectItem:get("img"):texture(var_13_0)
	end)

	arg_10_0.canMaxLv = idler.new(0)
	arg_10_0.selectLevel = idler.new(0)
	arg_10_0.sliderNum = idler.new("")

	idlereasy.any({
		arg_10_0.cardFeels,
		arg_10_0.myAllExp
	}, function(arg_14_0, arg_14_1, arg_14_2)
		local var_14_0 = arg_14_1[var_10_0.cardMarkID] or {}
		local var_14_1 = var_14_0.level or 0
		local var_14_2 = var_14_0.level_exp or 0
		local var_14_3 = 0
		local var_14_4 = 0
		local var_14_5 = table.length(var_10_1)

		for iter_14_0 = var_14_1 + 1, var_14_5 do
			var_14_3 = var_14_3 + var_10_1[iter_14_0].needExp

			if var_14_3 > arg_14_2 + var_14_2 or var_14_5 == iter_14_0 then
				if var_14_5 == iter_14_0 then
					var_14_4 = iter_14_0

					break
				else
					var_14_4 = iter_14_0 - 1

					break
				end
			end
		end

		arg_10_0.canMaxLv:set(math.max(var_14_4, var_14_1))

		local var_14_6 = math.min(arg_10_0.selectLevel:read(), var_14_4 - var_14_1)

		arg_10_0.selectLevel:set(var_14_6)
	end)
	idlereasy.any({
		arg_10_0.selectLevel,
		arg_10_0.cardFeels,
		arg_10_0.canMaxLv,
		arg_10_0.selectState
	}, function(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
		local var_15_0 = arg_15_2[var_10_0.cardMarkID] or {}
		local var_15_1 = var_15_0.level or 0
		local var_15_2 = var_15_0.level_exp or 0

		arg_10_0.canLvUp = arg_15_3 - var_15_1

		arg_10_0.sliderNum:set(math.min(var_15_1 + arg_15_1, arg_15_3) .. "/" .. table.length(var_10_1))

		local var_15_3 = 0

		for iter_15_0 = var_15_1 + 1, var_15_1 + arg_15_1 do
			if iter_15_0 <= table.length(var_10_1) then
				var_15_3 = var_15_3 + var_10_1[iter_15_0].needExp
			end
		end

		local var_15_4 = var_15_2
		local var_15_5 = {}

		arg_10_0.overflowExp = 0
		arg_10_0.selectItems = {}

		for iter_15_1, iter_15_2 in ipairs(arg_10_0.upGradeData1) do
			if arg_15_4[iter_15_1] and iter_15_2.num > 0 then
				local var_15_6 = var_15_4 + iter_15_2.cfg.specialArgsMap.feel_exp * iter_15_2.num

				if var_15_3 <= var_15_6 then
					local var_15_7 = math.ceil((var_15_3 - var_15_4) / iter_15_2.cfg.specialArgsMap.feel_exp)

					if arg_15_1 ~= 0 then
						var_15_5[iter_15_1] = var_15_7
						arg_10_0.selectItems[iter_15_2.id] = var_15_7
					end

					if var_15_1 + arg_15_1 >= table.length(var_10_1) then
						var_15_4 = var_15_4 + iter_15_2.cfg.specialArgsMap.feel_exp * var_15_7
						arg_10_0.overflowExp = var_15_4 - var_15_3
					end

					break
				elseif arg_15_1 ~= 0 then
					var_15_5[iter_15_1] = iter_15_2.num
					arg_10_0.selectItems[iter_15_2.id] = iter_15_2.num
				end

				var_15_4 = var_15_6
			end
		end

		for iter_15_3 = 1, #arg_10_0.upGradeData1 do
			arg_10_0.upGradeData:atproxy(iter_15_3).canUse = var_15_5[iter_15_3] or 0
		end

		cache.setShader(arg_10_0.addBtn, false, arg_15_3 <= arg_15_1 + var_15_1 and "hsl_gray" or "normal")
		cache.setShader(arg_10_0.subBtn, false, arg_15_1 <= 0 and "hsl_gray" or "normal")
		arg_10_0.addBtn:setTouchEnabled(arg_15_3 > arg_15_1 + var_15_1)
		arg_10_0.subBtn:setTouchEnabled(arg_15_1 > 0)
		cache.setShader(arg_10_0.addBtn10, false, arg_15_3 <= arg_15_1 + var_15_1 and "hsl_gray" or "normal")
		cache.setShader(arg_10_0.subBtn10, false, arg_15_1 <= 0 and "hsl_gray" or "normal")
		arg_10_0.addBtn10:setTouchEnabled(arg_15_3 > arg_15_1 + var_15_1)
		arg_10_0.subBtn10:setTouchEnabled(arg_15_1 > 0)
		cache.setShader(arg_10_0.addBtnMax, false, arg_15_3 <= arg_15_1 + var_15_1 and "hsl_gray" or "normal")
		cache.setShader(arg_10_0.subBtnMax, false, arg_15_1 <= 0 and "hsl_gray" or "normal")
		arg_10_0.addBtnMax:setTouchEnabled(arg_15_3 > arg_15_1 + var_15_1)
		arg_10_0.subBtnMax:setTouchEnabled(arg_15_1 > 0)
	end)

	if arg_10_0.selectSetState:read() == true then
		for iter_10_4, iter_10_5 in ipairs(arg_10_0.upGradeData1) do
			if iter_10_5.cfg.specialArgsMap.special == true then
				arg_10_0.selectState:proxy()[iter_10_4] = false
			end
		end
	else
		for iter_10_6, iter_10_7 in ipairs(arg_10_0.upGradeData1) do
			if iter_10_7.cfg.specialArgsMap.special == true then
				arg_10_0.selectState:proxy()[iter_10_6] = true
			end
		end
	end

	Dialog.onCreate(arg_10_0)
end

function var_0_1.initModel(arg_16_0)
	arg_16_0.roleLv = gGameModel.role:getIdler("level")
	arg_16_0.items = gGameModel.role:getIdler("items")
	arg_16_0.cardFeels = gGameModel.role:getIdler("card_feels")
	arg_16_0.gold = gGameModel.role:getIdler("gold")
end

function var_0_1.onItemClick(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	if arg_17_3.num <= 0 then
		gGameUI:showTip(gLanguageCsv.selectedMaterialsNotEnough)

		return
	end

	if arg_17_0.selectSetState:read() == true and arg_17_0.upGradeData1[arg_17_2].cfg.specialArgsMap.special == true then
		gGameUI:showTip(gLanguageCsv.feelOneKeyText)

		return
	end

	arg_17_0.selectState:proxy()[arg_17_2] = not arg_17_0.selectState:proxy()[arg_17_2]
end

function var_0_1.onAddClick(arg_18_0)
	arg_18_0.selectLevel:set(arg_18_0.selectLevel:read() + 1)
end

function var_0_1.onReduceClick(arg_19_0)
	arg_19_0.selectLevel:set(arg_19_0.selectLevel:read() - 1)
end

function var_0_1.onIncreaseNum(arg_20_0, arg_20_1)
	arg_20_0.selectLevel:modify(function(arg_21_0)
		return true, cc.clampf(arg_21_0 + arg_20_1, 0, arg_20_0.canLvUp)
	end)
end

function var_0_1.onChangeNum(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	if arg_22_2.name == "click" then
		arg_22_0:unScheduleAll()
		arg_22_0:onIncreaseNum(arg_22_3)
	elseif arg_22_2.name == "began" then
		arg_22_0:schedule(function()
			arg_22_0:onIncreaseNum(arg_22_3)
		end, 0.05, 0, 100)
	elseif arg_22_2.name == "ended" or arg_22_2.name == "cancelled" then
		arg_22_0:unScheduleAll()
	end
end

function var_0_1.onClose(arg_24_0)
	Dialog.onClose(arg_24_0)
end

function var_0_1.onCleanup(arg_25_0)
	if arg_25_0.selectEffect then
		arg_25_0.selectEffect:release()

		arg_25_0.selectEffect = nil
	end

	Dialog.onCleanup(arg_25_0)
end

function var_0_1.onSureClick(arg_26_0)
	if arg_26_0.myAllExp:read() == 0 then
		gGameUI:showTip(gLanguageCsv.pleaseSelectMaterials)

		return
	end

	if next(arg_26_0.selectItems) == nil or arg_26_0.selectLevel:read() <= 0 then
		gGameUI:showTip(gLanguageCsv.pleaseSelectTargetLevel)

		return
	end

	local var_26_0 = csv.cards[arg_26_0.cardId]
	local var_26_1 = table.deepcopy(arg_26_0.selectItems, true)

	if arg_26_0.overflowExp > 0 then
		local var_26_2 = arg_26_0.overflowExp

		for iter_26_0 = #arg_26_0.upGradeData1, 1, -1 do
			local var_26_3 = arg_26_0.upGradeData1[iter_26_0].id

			if var_26_1[var_26_3] then
				local var_26_4 = arg_26_0.upGradeData1[iter_26_0].cfg.specialArgsMap.feel_exp

				if var_26_2 >= var_26_1[var_26_3] * var_26_4 then
					var_26_2 = var_26_2 - var_26_1[var_26_3] * var_26_4
					var_26_1[var_26_3] = nil
				end
			end
		end
	end

	gGameApp:requestServer("/game/card/feel/use_items", function(arg_27_0)
		var_0_0.onClose(arg_26_0)
	end, arg_26_0.cardMarkID, var_26_1)
end

function var_0_1.onBtnSelectItem(arg_28_0)
	userDefault.setForeverLocalKey("CardFeelView", not arg_28_0.selectSetState:read())
	arg_28_0.selectSetState:set(not arg_28_0.selectSetState:read())

	if arg_28_0.selectSetState:read() == true then
		for iter_28_0, iter_28_1 in ipairs(arg_28_0.upGradeData1) do
			if iter_28_1.cfg.specialArgsMap.special == true then
				arg_28_0.selectState:proxy()[iter_28_0] = false
			end
		end
	else
		for iter_28_2, iter_28_3 in ipairs(arg_28_0.upGradeData1) do
			if iter_28_3.cfg.specialArgsMap.special == true then
				arg_28_0.selectState:proxy()[iter_28_2] = true
			end
		end
	end
end

return var_0_1
