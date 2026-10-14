local function var_0_0(arg_1_0)
	local var_1_0 = 0

	for iter_1_0, iter_1_1 in ipairs(arg_1_0) do
		if not iter_1_1.isFixAwards then
			var_1_0 = var_1_0 + 1
		end
	end

	return var_1_0
end

local function var_0_1(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	bind.extend(arg_2_0, arg_2_1:get("pic"), {
		class = "icon_key",
		props = {
			data = arg_2_2,
			onNode = function(arg_3_0)
				arg_3_0:setTouchEnabled(arg_2_3)
				arg_2_1:scale(0.9)
			end
		}
	})
end

local function var_0_2(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	arg_4_3:visible(true)

	if arg_4_4.isFixAwards then
		arg_4_3:get("add"):hide()
		arg_4_3:get("select"):hide()
		var_0_1(arg_4_0, arg_4_3, dataEasy.getItemData(arg_4_4.showAwards)[1], true)
	elseif arg_4_4.choose and arg_4_4.choose > 0 then
		arg_4_3:get("add"):hide()
		arg_4_3:get("select"):visible(arg_4_1.isCanBuy)

		local var_4_0 = arg_4_4.showAwards[arg_4_4.choose]

		var_0_1(arg_4_0, arg_4_3, dataEasy.getItemData(var_4_0)[1], not arg_4_1.isCanBuy)

		if arg_4_1.isCanBuy then
			bind.touch(arg_4_0, arg_4_3:get("pic"), {
				clicksafe = false,
				methods = {
					ended = functools.partial(arg_4_0.clickCell, arg_4_1, arg_4_2, arg_4_4.optionSlotNum, arg_4_4.showAwards, arg_4_4.choose)
				}
			})
		end
	else
		arg_4_3:get("add"):show()
		arg_4_3:get("select"):hide()
		arg_4_3:get("pic"):hide()
		bind.touch(arg_4_0, arg_4_3:get("add"), {
			clicksafe = false,
			methods = {
				ended = functools.partial(arg_4_0.clickCell, arg_4_1, arg_4_2, arg_4_4.optionSlotNum, arg_4_4.showAwards, 0)
			}
		})
	end
end

local var_0_3 = class("ActivityCustomizeGiftDialog", Dialog)

var_0_3.RESOURCE_FILENAME = "activity_customize_gift.json"
var_0_3.RESOURCE_BINDING = {
	panel = "panel",
	item = "item",
	icon = "icon",
	close = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	tip = {
		varname = "tip"
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 0,
				paddings = 10,
				asyncPreload = 4,
				data = bindHelper.self("itemsData"),
				item = bindHelper.self("panel"),
				itemAction = {
					isAction = false
				},
				dataOrderCmp = function(arg_5_0, arg_5_1)
					if arg_5_0.isCanBuy ~= arg_5_1.isCanBuy then
						return arg_5_0.isCanBuy
					end

					if arg_5_0.rmb ~= arg_5_1.rmb then
						return arg_5_0.rmb < arg_5_1.rmb
					end
				end,
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					local var_6_0 = arg_6_1:multiget("name", "icon1", "icon2", "icon3", "icon4", "textContent", "btn")

					var_6_0.name:text(arg_6_3.name)
					var_6_0.textContent:get("bg"):visible(not arg_6_3.isCanBuy)
					var_6_0.textContent:get("btn"):visible(arg_6_3.isCanBuy)
					var_6_0.textContent:get("btn"):get("red"):show()
					var_6_0.textContent:get("limitLabel"):text(string.format(gLanguageCsv.foreverLimit, arg_6_3.hasBoughtNum, arg_6_3.buyTimes))

					if arg_6_3.hasAllChoose then
						text.addEffect(var_6_0.textContent:get("btn"):get("title"), {
							color = ui.COLORS.NORMAL.YELLOW
						})
						cache.setShader(var_6_0.textContent:get("btn"):get("red"), false, "normal")
					else
						text.addEffect(var_6_0.textContent:get("btn"):get("title"), {
							color = cc.c4b(222, 218, 209, 255)
						})
						cache.setShader(var_6_0.textContent:get("btn"):get("red"), false, "hsl_gray")
					end

					var_6_0.textContent:get("btn"):get("title"):text(string.format(gLanguageCsv.symbolMoney, arg_6_3.rmbDisplay))
					bind.touch(arg_6_0, var_6_0.textContent:get("btn"), {
						clicksafe = false,
						methods = {
							ended = functools.partial(arg_6_0.clickBuy, arg_6_3)
						}
					})

					local var_6_1 = itertools.size(arg_6_3.awards)

					for iter_6_0 = 1, 4 do
						local var_6_2 = arg_6_1:get("icon" .. iter_6_0)

						var_6_2:visible(false)

						if iter_6_0 <= var_6_1 then
							var_0_2(arg_6_0, arg_6_3, var_0_0(arg_6_3.awards), var_6_2, arg_6_3.awards[iter_6_0])
						end
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("pushView"),
				clickBuy = bindHelper.self("clickBuy")
			}
		}
	},
	timeLabel = {
		varname = "timeLabel"
	},
	["panel.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_3.onCreate(arg_7_0, arg_7_1)
	gGameModel.forever_dispatch:getIdlerOrigin("customizeGiftClick"):set(true)

	arg_7_0.activityId = arg_7_1
	arg_7_0.huodongID = csv.yunying.yyhuodong[arg_7_0.activityId].huodongID
	arg_7_0.timeout = false

	arg_7_0:initModel()
	arg_7_0:initData()
	arg_7_0:initUI()
	Dialog.onCreate(arg_7_0, {
		blackType = 1
	})
end

function var_0_3.initModel(arg_8_0)
	arg_8_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_8_0.itemsData = idlers.new()
	arg_8_0.clientBuyTimes = idler.new(true)
end

function var_0_3.initData(arg_9_0)
	idlereasy.any({
		arg_9_0.yyhuodongs
	}, function(arg_10_0, arg_10_1)
		local var_10_0 = {}
		local var_10_1 = arg_9_0:initCsv(arg_10_1[arg_9_0.activityId])

		arg_9_0.itemsData:update(var_10_1, function(arg_11_0)
			return arg_11_0.rechargeID
		end)
		dataEasy.tryCallFunc(arg_9_0.list, "filterSortItems", true)
	end)
end

function var_0_3.initCsv(arg_12_0, arg_12_1)
	local var_12_0 = {}
	local var_12_1 = csv.yunying.customize_gift
	local var_12_2 = {}
	local var_12_3 = {}

	local function var_12_4(arg_13_0, arg_13_1)
		return arg_12_1 and arg_12_1.choose and arg_12_1.choose[arg_13_0] and arg_12_1.choose[arg_13_0][arg_13_1]
	end

	local function var_12_5(arg_14_0)
		return arg_12_1 and arg_12_1.stamps and arg_12_1.stamps[arg_14_0] and arg_12_1.stamps[arg_14_0] > 0 and arg_12_1.stamps[arg_14_0]
	end

	local function var_12_6(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
		if itertools.size(arg_15_1) > 0 then
			table.insert(arg_15_0, {
				showAwards = arg_15_1,
				isFixAwards = arg_15_2,
				optionSlotNum = arg_15_3,
				choose = arg_15_4
			})

			if not arg_15_4 or arg_15_4 == 0 then
				return false
			else
				return true
			end
		end

		return true
	end

	for iter_12_0, iter_12_1 in pairs(var_12_1) do
		if iter_12_1.huodongID == arg_12_0.huodongID then
			local var_12_7 = {}
			local var_12_8 = {}
			local var_12_9 = true
			local var_12_10 = {
				iter_12_1.optionalAwards1,
				iter_12_1.optionalAwards2,
				iter_12_1.optionalAwards3,
				iter_12_1.optionalAwards4
			}

			var_12_6(var_12_7, iter_12_1.awards, true)

			for iter_12_2, iter_12_3 in ipairs(var_12_10) do
				if not var_12_6(var_12_7, iter_12_3, false, iter_12_2, var_12_4(iter_12_0, iter_12_2)) then
					var_12_9 = false
				end
			end

			local var_12_11 = iter_12_1.buyTimes - (var_12_5(iter_12_0) or 0)

			table.insert(var_12_0, {
				awards = var_12_7,
				buyTimes = iter_12_1.buyTimes,
				name = iter_12_1.name,
				rechargeID = iter_12_1.rechargeID,
				rmbDisplay = csv.recharges[iter_12_1.rechargeID].rmbDisplay,
				rmb = csv.recharges[iter_12_1.rechargeID].rmb,
				hasBoughtNum = var_12_5(iter_12_0) or 0,
				isCanBuy = var_12_11 > 0,
				icon = iter_12_1.icon,
				csvId = iter_12_0,
				hasAllChoose = var_12_9
			})
		end
	end

	return var_12_0
end

function var_0_3.initUI(arg_16_0)
	arg_16_0:setTimeLabel()
end

function var_0_3.setTimeLabel(arg_17_0)
	arg_17_0.endTime = gGameModel.role:read("yy_endtime")[arg_17_0.activityId]

	local var_17_0 = arg_17_0.endTime - time.getTime()

	if var_17_0 < 0 then
		arg_17_0.timeLabel:text(gLanguageCsv.activityOver)
	end

	arg_17_0:enableSchedule():schedule(function()
		var_17_0 = arg_17_0.endTime - time.getTime()

		local var_18_0 = time.getCutDown(var_17_0)

		if var_17_0 <= 0 then
			arg_17_0.timeout = true

			arg_17_0.timeLabel:text(gLanguageCsv.activityOver)

			return false
		else
			local var_18_1 = ""

			if var_18_0.day >= 1 then
				var_18_1 = var_18_0.str
			else
				var_18_1 = var_18_0.clock_str
			end

			arg_17_0.timeLabel:text(gLanguageCsv.exclusiveRestrictionClose .. var_18_1)

			return true
		end
	end, 1, 0)
end

function var_0_3.pushView(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
	gGameUI:stackUI("city.activity.customize_gift_select", nil, nil, arg_19_0.activityId, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
end

function var_0_3.clickBuy(arg_20_0, arg_20_1, arg_20_2)
	if arg_20_0.timeout then
		gGameUI:showTip(gLanguageCsv.activityOver)

		return
	end

	if not arg_20_2.hasAllChoose then
		gGameUI:showTip(gLanguageCsv.selectGiftTip)

		return
	end

	local var_20_0 = {}

	for iter_20_0, iter_20_1 in pairs(arg_20_2.awards) do
		if iter_20_1.isFixAwards then
			table.insert(var_20_0, iter_20_1.showAwards)
		else
			table.insert(var_20_0, iter_20_1.showAwards[iter_20_1.choose])
		end
	end

	gGameApp:payDirect(arg_20_0, {
		rechargeId = arg_20_2.rechargeID,
		yyID = arg_20_0.activityId,
		csvID = arg_20_2.csvId,
		buyTimes = arg_20_2.hasBoughtNum,
		name = arg_20_2.name
	}, arg_20_0.clientBuyTimes):serverCb(function()
		return
	end):doit()
end

return var_0_3
