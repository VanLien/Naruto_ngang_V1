local var_0_0 = class("ZongZiBagView", Dialog)
local var_0_1 = {}

var_0_1[6358] = "effect_baoyu"
var_0_1[6362] = "effect_mizao"
var_0_1[6363] = "effect_mizao"
var_0_1[6360] = "effect_rou"
var_0_1[6361] = "effect_rou"
var_0_1[6359] = "effect_shuangpin"
var_0_0.RESOURCE_FILENAME = "activity_zongzi_bag.json"
var_0_0.RESOURCE_BINDING = {
	item = "item",
	innweList = "innweList",
	["right.num"] = "itemNum",
	["right.item"] = "itemIcon",
	["right.desc"] = "desc",
	["right.sliderPanel.slider"] = "slider",
	right = "right",
	["left.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 5,
				data = bindHelper.self("itemData"),
				item = bindHelper.self("innweList"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("imgSel"):visible(arg_1_3.isSel)
					bind.extend(arg_1_0, arg_1_1, {
						class = "icon_key",
						props = {
							data = {
								key = arg_1_3.key,
								num = arg_1_3.num
							},
							onNode = function(arg_2_0)
								local var_2_0 = arg_1_0:getIdx(arg_1_2)

								bind.click(arg_1_0, arg_2_0, {
									method = functools.partial(arg_1_0.clickCell, var_2_0, arg_1_3)
								})
							end
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	},
	["left.title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["right.sliderPanel.subBtn"] = {
		varname = "sliderSubBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_3_0, arg_3_1, arg_3_2)
				return arg_3_0:onChangeNum(arg_3_1, arg_3_2, -1)
			end)
		}
	},
	["right.sliderPanel.addBtn"] = {
		varname = "sliderAddBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_4_0, arg_4_1, arg_4_2)
				return arg_4_0:onChangeNum(arg_4_1, arg_4_2, 1)
			end)
		}
	}
}

function var_0_0.onCreate(arg_5_0, arg_5_1)
	arg_5_0.activityId = arg_5_1

	arg_5_0.item:visible(false)

	arg_5_0.num = idler.new(1)
	arg_5_0.selIdx = idler.new(1)
	arg_5_0.maxNum = 1

	arg_5_0:enableSchedule()

	arg_5_0.itemData = idlers.newWithMap({})

	idlereasy.when(gGameModel.role:getIdler("items"), function(arg_6_0, arg_6_1)
		local var_6_0 = {}

		for iter_6_0 = 6358, 6363 do
			if arg_6_1[iter_6_0] then
				table.insert(var_6_0, {
					isSel = false,
					key = iter_6_0,
					num = arg_6_1[iter_6_0]
				})
			end
		end

		arg_5_0.onCloseInfo = csvSize(var_6_0)

		arg_5_0.itemData:update(var_6_0)
		arg_5_0:onItemClick(arg_5_0, {
			k = 1
		}, var_6_0[1])
	end)
	arg_5_0.selIdx:addListener(function(arg_7_0, arg_7_1)
		if arg_5_0.itemData:atproxy(arg_7_1) then
			arg_5_0.itemData:atproxy(arg_7_1).isSel = false
		end

		arg_5_0.itemData:atproxy(arg_7_0).isSel = true
	end)

	local var_5_0 = {
		arg_5_0.num
	}

	idlereasy.any(var_5_0, function(arg_8_0, arg_8_1)
		arg_5_0.itemNum:text(arg_8_1 .. "/" .. arg_5_0.maxNum)
		adapt.oneLineCenterPos(cc.p(arg_5_0.right:get("btnDress"):x(), 400), {
			arg_5_0.right:get("txt1"),
			arg_5_0.itemNum,
			arg_5_0.right:get("txt2")
		})
		arg_5_0.sliderAddBtn:setTouchEnabled(arg_8_1 < arg_5_0.maxNum)
		arg_5_0.sliderSubBtn:setTouchEnabled(arg_8_1 > 1)
		cache.setShader(arg_5_0.sliderSubBtn, false, arg_8_1 > 1 and "normal" or "hsl_gray")
		cache.setShader(arg_5_0.sliderAddBtn, false, arg_8_1 < arg_5_0.maxNum and "normal" or "hsl_gray")

		if not arg_5_0.slider:isHighlighted() then
			local var_8_0 = arg_8_1 / arg_5_0.maxNum

			arg_5_0.slider:setPercent(var_8_0 * 100)
		end
	end)
	arg_5_0.slider:addEventListener(function(arg_9_0, arg_9_1)
		arg_5_0:unScheduleAll()

		local var_9_0 = arg_9_0:getPercent()
		local var_9_1 = cc.clampf(math.ceil(arg_5_0.maxNum * var_9_0 * 0.01), 1, math.max(arg_5_0.maxNum, 1))

		arg_5_0.num:set(var_9_1)
	end)
	Dialog.onCreate(arg_5_0)
end

function var_0_0.onItemClick(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if arg_10_3 and arg_10_3.key then
		bind.extend(arg_10_0, arg_10_0.itemIcon, {
			class = "icon_key",
			props = {
				noListener = true,
				data = {
					key = arg_10_3.key,
					num = arg_10_3.num
				}
			}
		})

		local var_10_0 = csv.items

		arg_10_0.right:get("textName"):text(var_10_0[arg_10_3.key].name)
		arg_10_0.right:get("textLv"):text(string.format(gLanguageCsv.possessIngredient, arg_10_3.num))
		arg_10_0.desc:text(var_10_0[arg_10_3.key].desc)

		arg_10_0.maxNum = gGameModel.role:read("items")[arg_10_3.key] or 0

		arg_10_0.num:set(arg_10_0.maxNum, true)
		arg_10_0.selIdx:set(arg_10_2.k, true)
		arg_10_0.right:get("btnDress"):onClick(function()
			local var_11_0 = {
				false
			}

			gGameApp:requestServerCustom("/game/role/item/use"):params({
				[arg_10_3.key] = arg_10_0.num:read()
			}):onResponse(function(arg_12_0)
				arg_10_0.animaBa = widget.addAnimation(arg_10_0, "duanwuzongzi/chizongzi.skel", var_0_1[arg_10_3.key], 1):xy(cc.p(1280, 720)):scale(3)

				performWithDelay(arg_10_0, function()
					var_11_0[1] = true

					arg_10_0.animaBa:removeFromParent()

					arg_10_0.animaBa = nil

					gGameUI:showGainDisplay(arg_12_0, {
						cb = function()
							if arg_10_0.onCloseInfo and arg_10_0.onCloseInfo == 0 then
								arg_10_0:onClose()
							end
						end
					})
				end, 4)
			end):wait(var_11_0):doit(function(arg_15_0)
				return
			end)
		end)
	end
end

function var_0_0.onIncreaseNum(arg_16_0, arg_16_1)
	arg_16_0.num:modify(function(arg_17_0)
		return true, cc.clampf(arg_17_0 + arg_16_1, 1, math.max(arg_16_0.maxNum, 1))
	end)
end

function var_0_0.onChangeNum(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	if arg_18_2.name == "click" then
		arg_18_0:unScheduleAll()
		arg_18_0:onIncreaseNum(arg_18_3)
	elseif arg_18_2.name == "began" then
		arg_18_0:schedule(function()
			arg_18_0:onIncreaseNum(arg_18_3)
		end, 0.05, 0, 1)
	elseif arg_18_2.name == "ended" or arg_18_2.name == "cancelled" then
		arg_18_0:unScheduleAll()
	end
end

return var_0_0
