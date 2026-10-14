local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("ZongziSelectView", Dialog)
local var_0_2 = {}

var_0_2[6358] = "effect_baoyu"
var_0_2[6362] = "effect_mizao"
var_0_2[6363] = "effect_mizao"
var_0_2[6360] = "effect_rou"
var_0_2[6361] = "effect_rou"
var_0_2[6359] = "effect_shuangpin"
var_0_1.RESOURCE_FILENAME = "activity_zongzi_select.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	rightBg = "rightBg",
	imgBg1 = "imgBg1",
	["sliderPanel.slider"] = "slider",
	["open.textNum"] = "textNum",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnOpen = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onOpen")
			}
		}
	},
	["btnSell.textNote"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("itemDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					bind.extend(arg_1_0, arg_1_1:get("panel"), {
						class = "icon_key",
						props = {
							data = {
								key = arg_1_3.key,
								num = arg_1_3.num
							},
							onNode = function(arg_2_0)
								bind.click(arg_1_0, arg_2_0, {
									method = functools.partial(arg_1_0.itemClick, arg_2_0, arg_1_2, arg_1_3)
								})
							end
						}
					})
					arg_1_1:removeChildByName("label")

					local var_1_0 = dataEasy.getCfgByKey(arg_1_3.key)
					local var_1_1 = beauty.singleTextLimitWord(var_1_0.name, {
						fontSize = 40
					}, {
						width = 240
					}):xy(125, 26):addTo(arg_1_1, 2, "label")

					text.addEffect(var_1_1, {
						color = ui.COLORS.NORMAL.DEFAULT
					})
					arg_1_1:get("choose"):visible(arg_1_3.isSel)
				end,
				onAfterBuild = function(arg_3_0)
					arg_3_0:setItemAlignCenter()
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	["sliderPanel.subBtn"] = {
		varname = "sliderSubBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_4_0, arg_4_1, arg_4_2)
				return arg_4_0:onChangeNum(arg_4_1, arg_4_2, -1)
			end)
		}
	},
	["sliderPanel.addBtn"] = {
		varname = "sliderAddBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_5_0, arg_5_1, arg_5_2)
				return arg_5_0:onChangeNum(arg_5_1, arg_5_2, 1)
			end)
		}
	},
	["btnOpen.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	}
}

function var_0_1.initModel(arg_6_0)
	arg_6_0.itemModels = gGameModel.role:getIdler("items")
	arg_6_0.choose = idler.new(1)
	arg_6_0.itemDatas = idlers.new()
	arg_6_0.num = idler.new(1)
	arg_6_0.maxNum = 0
end

function var_0_1.onCreate(arg_7_0)
	arg_7_0:initModel()
	arg_7_0:enableSchedule()
	arg_7_0.list:y(670)
	idlereasy.when(arg_7_0.itemModels, function(arg_8_0, arg_8_1)
		local var_8_0 = {}

		for iter_8_0, iter_8_1 in pairs(arg_8_1) do
			if iter_8_0 >= 6358 and iter_8_0 <= 6363 then
				table.insert(var_8_0, {
					isSel = false,
					key = iter_8_0,
					num = iter_8_1,
					quality = csv.items[iter_8_0].quality
				})
			end
		end

		if #var_8_0 > 0 then
			arg_7_0.imgBg1:hide()
			table.sort(var_8_0, function(arg_9_0, arg_9_1)
				return arg_9_0.quality > arg_9_1.quality
			end)

			local var_8_1 = arg_7_0.choose:read()

			if not var_8_0[var_8_1] or var_8_0[var_8_1].key ~= arg_7_0.lastChooseKey then
				var_8_1 = 1
			end

			arg_7_0.choose:set(var_8_1)

			var_8_0[var_8_1].isSel = true

			arg_7_0.itemDatas:update(var_8_0)

			arg_7_0.maxNum = var_8_0[var_8_1].num

			arg_7_0.num:modify(function(arg_10_0)
				return true, arg_7_0.maxNum
			end, true)
			arg_7_0.textNum:text(arg_7_0.num:read() .. "/" .. arg_7_0.maxNum)
		else
			arg_7_0.imgBg1:show()
		end

		local var_8_2 = #var_8_0

		arg_7_0.rightBg:visible(var_8_2 > 5)
		arg_7_0.list:onScroll(function(arg_11_0)
			local var_11_0 = arg_7_0.list:getIndex(arg_7_0.list:getRightmostItemInCurrentView())

			arg_7_0.rightBg:visible(var_11_0 == 4 and var_8_2 == 6)
		end)
	end)
	arg_7_0.choose:addListener(function(arg_12_0, arg_12_1)
		if arg_7_0.itemDatas:atproxy(arg_12_1) then
			arg_7_0.itemDatas:atproxy(arg_12_1).isSel = false
		end

		local var_12_0 = arg_7_0.itemDatas:atproxy(arg_12_0)

		if var_12_0 ~= nil then
			var_12_0.isSel = true
			arg_7_0.maxNum = var_12_0.num

			arg_7_0.num:modify(function(arg_13_0)
				return true, arg_7_0.maxNum
			end, true)
			arg_7_0.textNum:text(arg_7_0.num:read() .. "/" .. arg_7_0.maxNum)

			if not arg_7_0.slider:isHighlighted() then
				local var_12_1 = arg_7_0.num:read() / arg_7_0.maxNum

				arg_7_0.slider:setPercent(var_12_1 * 100)
			end
		end
	end)
	arg_7_0.slider:setPercent(0)
	idlereasy.when(arg_7_0.num, function(arg_14_0, arg_14_1)
		arg_7_0.sliderSubBtn:setTouchEnabled(arg_14_1 > 1)
		arg_7_0.sliderAddBtn:setTouchEnabled(arg_14_1 < arg_7_0.maxNum)
		cache.setShader(arg_7_0.sliderSubBtn, false, arg_14_1 > 1 and "normal" or "hsl_gray")
		cache.setShader(arg_7_0.sliderAddBtn, false, arg_14_1 < arg_7_0.maxNum and "normal" or "hsl_gray")

		if arg_14_1 <= 1 or arg_14_1 >= arg_7_0.maxNum then
			arg_7_0:unScheduleAll()
		end

		arg_7_0.textNum:text(arg_14_1 .. "/" .. arg_7_0.maxNum)

		if not arg_7_0.slider:isHighlighted() then
			local var_14_0 = arg_14_1 / arg_7_0.maxNum

			arg_7_0.slider:setPercent(var_14_0 * 100)
		end
	end)
	arg_7_0.slider:addEventListener(function(arg_15_0, arg_15_1)
		arg_7_0:unScheduleAll()

		local var_15_0 = arg_15_0:getPercent()
		local var_15_1 = cc.clampf(math.ceil(arg_7_0.maxNum * var_15_0 * 0.01), 1, arg_7_0.maxNum)

		arg_7_0.num:set(var_15_1)
	end)
	Dialog.onCreate(arg_7_0)
end

function var_0_1.onOpen(arg_16_0)
	local var_16_0 = arg_16_0.choose:read()
	local var_16_1 = arg_16_0.itemDatas:atproxy(var_16_0).key
	local var_16_2 = {
		false
	}

	gGameApp:requestServerCustom("/game/role/item/use"):params({
		[var_16_1] = arg_16_0.num:read()
	}):onResponse(function(arg_17_0)
		arg_16_0.lastChooseKey = var_16_1
		arg_16_0.animaBa = widget.addAnimation(arg_16_0, "duanwuzongzi/chizongzi.skel", var_0_2[var_16_1], 1):xy(cc.p(1280, 720)):scale(3)

		performWithDelay(arg_16_0, function()
			var_16_2[1] = true

			arg_16_0.animaBa:removeFromParent()

			arg_16_0.animaBa = nil

			gGameUI:showGainDisplay(arg_17_0)
		end, 4)
	end):wait(var_16_2):doit(function(arg_19_0)
		return
	end)
end

function var_0_1.onItemClick(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	if arg_20_0.choose:read() ~= arg_20_3 then
		arg_20_0.choose:set(arg_20_3)
	else
		gGameUI:showItemDetail(arg_20_2, arg_20_4)
	end
end

function var_0_1.onIncreaseNum(arg_21_0, arg_21_1)
	arg_21_0.num:modify(function(arg_22_0)
		return true, cc.clampf(arg_22_0 + arg_21_1, 1, arg_21_0.maxNum)
	end)
end

function var_0_1.onChangeNum(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	if arg_23_2.name == "click" then
		arg_23_0:unScheduleAll()
		arg_23_0:onIncreaseNum(arg_23_3)
	elseif arg_23_2.name == "began" then
		arg_23_0:schedule(function()
			arg_23_0:onIncreaseNum(arg_23_3)
		end, 0.05, 0, 100)
	elseif arg_23_2.name == "ended" or arg_23_2.name == "cancelled" then
		arg_23_0:unScheduleAll()
	end
end

return var_0_1
