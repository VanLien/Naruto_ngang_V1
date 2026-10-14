local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("ActivityGamePassportBuyExpView", Dialog)

var_0_1.RESOURCE_FILENAME = "activity_game_passport_buy_level.json"
var_0_1.RESOURCE_BINDING = {
	subList = "subList",
	text3 = "text3",
	["barPanel.needFrags"] = "needFrags",
	text1 = "text1",
	text4 = "text4",
	text2 = "text2",
	item = "item",
	["barPanel.bar"] = "slider",
	barPanel = "barPanel",
	["barPanel.myFrags"] = "myFrags",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				xMargin = 6,
				yMargin = 0,
				data = bindHelper.self("itemDatas1"),
				columnSize = bindHelper.self("midColumnSize"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					bind.extend(arg_1_0, arg_1_1, {
						class = "icon_key",
						props = {
							data = {
								key = arg_1_3.key,
								num = arg_1_3.num
							}
						}
					})
				end
			}
		}
	},
	btn = {
		varname = "btn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBuyClick")
			}
		}
	},
	["btn.txt"] = {
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
	text = {
		varname = "name",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 6,
					color = ui.NEWCOLORS.OUTLINE.BLUE1
				}
			}
		}
	},
	["barPanel.subBtn"] = {
		varname = "subBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_2_0, arg_2_1, arg_2_2)
				return arg_2_0:onChangeNum(arg_2_1, arg_2_2, -1)
			end)
		}
	},
	["barPanel.addBtn"] = {
		varname = "addBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_3_0, arg_3_1, arg_3_2)
				return arg_3_0:onChangeNum(arg_3_1, arg_3_2, 1)
			end)
		}
	}
}

function var_0_1.onCreate(arg_4_0, arg_4_1)
	arg_4_0:initModel()
	arg_4_0:enableSchedule()

	local var_4_0 = csv.yunying.yyhuodong[arg_4_1]
	local var_4_1 = var_4_0.paramMap.dailyBuyTimes

	arg_4_0.activityId = arg_4_1
	arg_4_0.itemDatas1 = idlers.newWithMap({})
	arg_4_0.midColumnSize = 8

	local var_4_2 = var_4_0.paramMap.type
	local var_4_3 = arg_4_0.yyhuodongs:read()[arg_4_0.activityId].info.level or 0
	local var_4_4 = arg_4_0.yyhuodongs:read()[arg_4_0.activityId].info.buy_times or 0
	local var_4_5 = arg_4_0.yyhuodongs:read()[arg_4_0.activityId].info.buy_level or 0
	local var_4_6 = arg_4_0.yyhuodongs:read()[arg_4_0.activityId].info.elite_buy == 1
	local var_4_7 = csv.yunying.playpassport_award
	local var_4_8 = globals.gCostCsv["play_passport_buy_cost" .. var_4_2]

	arg_4_0.selectNum = idler.new(1)

	idlereasy.when(arg_4_0.selectNum, function(arg_5_0, arg_5_1)
		local var_5_0 = {}
		local var_5_1 = false

		arg_4_0.canMaxNum = 0

		for iter_5_0, iter_5_1 in csvPairs(var_4_7) do
			if iter_5_1.huodongID == var_4_0.huodongID then
				if iter_5_1.level > var_4_3 and iter_5_1.level <= var_4_3 + arg_5_1 then
					for iter_5_2, iter_5_3 in csvMapPairs(iter_5_1.normalAward) do
						for iter_5_4, iter_5_5 in ipairs(var_5_0) do
							if iter_5_5.key == iter_5_2 then
								iter_5_5.num = iter_5_5.num + iter_5_3
								var_5_1 = true

								break
							end
						end

						if var_5_1 == false then
							table.insert(var_5_0, {
								key = iter_5_2,
								num = iter_5_3
							})
						else
							var_5_1 = false
						end
					end

					if var_4_6 then
						for iter_5_6, iter_5_7 in csvMapPairs(iter_5_1.eliteAward) do
							for iter_5_8, iter_5_9 in ipairs(var_5_0) do
								if iter_5_9.key == iter_5_6 then
									iter_5_9.num = iter_5_9.num + iter_5_7
									var_5_1 = true

									break
								end
							end

							if var_5_1 == false then
								table.insert(var_5_0, {
									key = iter_5_6,
									num = iter_5_7
								})
							else
								var_5_1 = false
							end
						end
					end
				end

				arg_4_0.canMaxNum = arg_4_0.canMaxNum + 1
			end
		end

		arg_4_0.canMaxNum = arg_4_0.canMaxNum - var_4_3
		arg_4_0.canMaxNum = math.min(arg_4_0.canMaxNum, var_4_1 - var_4_4)

		arg_4_0.itemDatas1:update(var_5_0)

		if not arg_4_0.slider:isHighlighted() then
			local var_5_2 = math.ceil(arg_5_1 / arg_4_0.canMaxNum * 100)

			arg_4_0.slider:setPercent(var_5_2)
		end

		uiEasy.setBtnShader(arg_4_0.addBtn, nil, arg_5_1 < arg_4_0.canMaxNum and 1 or 2)
		uiEasy.setBtnShader(arg_4_0.subBtn, nil, arg_5_1 > 1 and 1 or 2)
		arg_4_0.text2:text("Lv." .. var_4_3 + arg_5_1)
		arg_4_0.text1:text(gLanguageCsv.gamePassportBuyExpText1)
		arg_4_0.text3:text(gLanguageCsv.gamePassportBuyExpText2)
		adapt.oneLineCenterPos(cc.p(1575, 1130), {
			arg_4_0.text1,
			arg_4_0.text2,
			arg_4_0.text3
		}, cc.p(2, 0))

		if arg_4_0.richText then
			arg_4_0.richText:removeSelf()
		end

		arg_4_0.richText = rich.createWithWidth(string.format(gLanguageCsv.gamePassportBuyExpText, arg_5_1, var_4_4, var_4_1), 40, nil, 1250):addTo(arg_4_0.text4, 10):anchorPoint(cc.p(0.5, 0.5)):xy(350, 5):formatText()

		local var_5_3 = 0
		local var_5_4 = table.length(var_4_8)

		for iter_5_10 = 1, arg_5_1 do
			var_5_3 = var_5_3 + var_4_8[math.min(iter_5_10 + var_4_5, var_5_4)]
		end

		arg_4_0.cost = var_5_3

		arg_4_0.btn:get("txt"):text(var_5_3)
	end)
	arg_4_0.slider:addEventListener(function(arg_6_0, arg_6_1)
		arg_4_0:unScheduleAll()

		local var_6_0 = arg_6_0:getPercent()
		local var_6_1 = cc.clampf(math.ceil(arg_4_0.canMaxNum * var_6_0 * 0.01), 1, arg_4_0.canMaxNum)

		arg_4_0.selectNum:set(var_6_1)
	end)
	Dialog.onCreate(arg_4_0)
end

function var_0_1.initModel(arg_7_0)
	arg_7_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_7_0.rmb = gGameModel.role:getIdler("rmb")
end

function var_0_1.onBuyClick(arg_8_0)
	if arg_8_0.rmb:read() < arg_8_0.cost then
		uiEasy.showDialog("rmb", nil, {
			dialog = false
		})

		return
	else
		local var_8_0 = gLanguageCsv.passwordTitleTip

		local function var_8_1()
			gGameApp:requestServer("/game/yy/playpassport/exp/buy", function(arg_10_0)
				gGameUI:showTip(gLanguageCsv.buySuccess)
				arg_8_0:onClose()
			end, arg_8_0.activityId, arg_8_0.selectNum:read())
		end

		local var_8_2 = {
			isRich = true,
			btnType = 2,
			title = var_8_0,
			cb = var_8_1,
			content = string.format(gLanguageCsv.passportRmbCheck, arg_8_0.cost),
			dialogParams = {
				clickClose = false
			}
		}

		gGameUI:showDialog(var_8_2)
	end
end

function var_0_1.onChangeNum(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	if arg_11_2.name == "click" then
		arg_11_0:unScheduleAll()
		arg_11_0:onIncreaseNum(arg_11_3)
	elseif arg_11_2.name == "began" then
		arg_11_0:schedule(function()
			arg_11_0:onIncreaseNum(arg_11_3)
		end, 0.05, 0, 100)
	elseif arg_11_2.name == "ended" or arg_11_2.name == "cancelled" then
		arg_11_0:unScheduleAll()
	end
end

function var_0_1.onIncreaseNum(arg_13_0, arg_13_1)
	arg_13_0.selectNum:modify(function(arg_14_0)
		return true, cc.clampf(arg_14_0 + arg_13_1, 1, arg_13_0.canMaxNum)
	end)
end

return var_0_1
