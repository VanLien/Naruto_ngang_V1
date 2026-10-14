local var_0_0 = {
	null = 0,
	buy = 1,
	max = 2
}
local var_0_1 = 8617
local var_0_2 = class("ActivityMonthCardView", cc.load("mvc").ViewBase)

var_0_2.RESOURCE_FILENAME = "activity_month_card.json"
var_0_2.RESOURCE_BINDING = {
	panel2 = "panel2",
	panel1 = "panel1",
	["panel1.icon"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_1_0)
					return arg_1_0:onDetailClick(1)
				end)
			}
		}
	},
	["panel1.btn"] = {
		binds = {
			clicksafe = true,
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_2_0)
					return arg_2_0:onBtnClick(1)
				end)
			}
		}
	},
	["panel2.icon"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_3_0)
					return arg_3_0:onDetailClick(2)
				end)
			}
		}
	},
	["panel2.btn"] = {
		binds = {
			clicksafe = true,
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_4_0)
					return arg_4_0:onBtnClick(2)
				end)
			}
		}
	}
}

function var_0_2.onCreate(arg_5_0)
	userDefault.setCurrDayKey("notShowMonthCardRedhint", true)
	arg_5_0:initModel()

	local var_5_0 = var_0_2.getActivityIds()

	arg_5_0.data = {}

	for iter_5_0, iter_5_1 in ipairs(var_5_0) do
		local var_5_1 = iter_5_1.rechargeId
		local var_5_2 = iter_5_1.activityId
		local var_5_3 = {
			rechargeId = var_5_1,
			activityId = var_5_2,
			state = idler.new(var_0_0.null),
			day = idler.new(0)
		}

		arg_5_0.data[iter_5_0] = var_5_3

		local var_5_4 = csv.recharges[var_5_1]
		local var_5_5 = csv.yunying.yyhuodong[var_5_2]
		local var_5_6 = arg_5_0["panel" .. iter_5_0]
		local var_5_7 = var_5_6:get("list")
		local var_5_8 = var_5_5.paramMap.award
		local var_5_9 = var_5_5.paramMap.most
		local var_5_10 = {}

		for iter_5_2, iter_5_3 in csvMapPairs(var_5_8) do
			table.insert(var_5_10, {
				key = iter_5_2,
				num = iter_5_3
			})
		end

		var_5_3.privilegeId = var_5_5.paramMap.privilege
		var_5_3.list = var_5_7

		uiEasy.createItemsToList(arg_5_0, var_5_7, var_5_10, {
			scale = 0.85
		})
		var_5_6:get("item4.num"):text(string.format(gLanguageCsv.day, var_5_4.param.days))
		idlereasy.any({
			var_5_3.state,
			var_5_3.day
		}, function(arg_6_0, arg_6_1, arg_6_2)
			local var_6_0 = var_5_6:get("btn")
			local var_6_1 = var_5_6:get("btn.label")
			local var_6_2 = var_5_6:get("label")
			local var_6_3 = var_5_6:get("num")

			cache.setShader(var_6_0, false, "normal")
			var_6_0:setTouchEnabled(true)
			text.addEffect(var_6_1, {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})

			if arg_6_1 == var_0_0.buy then
				var_6_1:text(string.format(gLanguageCsv.symbolMoney, var_5_4.rmbDisplay))
				var_6_1:alignCenter(var_6_0:size())

				if arg_6_2 <= 0 then
					var_6_2:text(gLanguageCsv.monthCardNotHave)
					var_6_3:text("")
				else
					var_6_2:text(gLanguageCsv.reveiveLeftDay)
					var_6_3:text(string.format(gLanguageCsv.day, var_5_3.day:read()))
				end

				text.addEffect(var_5_6:get("textHasNum"), {
					color = cc.c4b(92, 153, 112, 255)
				})
			elseif arg_6_1 == var_0_0.max then
				var_6_2:text(gLanguageCsv.reveiveLeftDay)
				var_6_3:text(string.format(gLanguageCsv.day, var_5_3.day:read()))
				text.addEffect(var_5_6:get("textHasNum"), {
					color = cc.c4b(92, 153, 112, 255)
				})
				var_6_1:text(gLanguageCsv.alreadyMax)
				var_6_1:setFontSize(35)
				var_6_1:alignCenter(var_6_0:size())
				var_6_0:setTouchEnabled(false)
				cache.setShader(var_6_0, false, "hsl_gray")
				text.deleteAllEffect(var_6_1)
				text.addEffect(var_6_1, {
					color = ui.COLORS.NORMAL.WHITE
				})
				text.addEffect(var_5_6:get("textHasNum"), {
					color = cc.c4b(230, 92, 92, 255)
				})
			end

			local var_6_4 = var_5_3.day:read()
			local var_6_5 = math.ceil(var_6_4 / 30)

			if var_6_4 <= 0 then
				var_6_5 = 0
			end

			var_5_6:get("textHasNum"):text(var_6_5 .. "/" .. var_5_9)
			adapt.oneLinePos(var_6_2, var_6_3, cc.p(5, 0), "left")

			local var_6_6

			if var_6_5 == 0 then
				var_5_6:get("textHas"):hide()
				var_5_6:get("textHasNum"):hide()

				var_6_6 = gLanguageCsv.monthCardAward1
			else
				var_5_6:get("textHas"):show()
				var_5_6:get("textHasNum"):show()

				var_6_6 = gLanguageCsv.monthCardAwardNoToday
			end

			var_5_6:removeChildByName("richText1")

			local var_6_7 = rich.createWithWidth(string.format(var_6_6, var_5_4.rmb), 34, nil, 660):addTo(var_5_6, 2, "richText1"):anchorPoint(0, 0.5):xy(cc.p(100, 565))

			var_5_6:removeChildByName("richText2")

			local var_6_8 = rich.createWithWidth(string.format(gLanguageCsv.monthCardAward2, var_5_8[8617]), 34, nil, 660):addTo(var_5_6, 2, "richText2"):anchorPoint(0, 0.5):xy(cc.p(100, var_6_7:y() - var_6_7:height() - 5))

			if not matchLanguage({
				"cn",
				"tw"
			}) then
				var_6_8:xy(cc.p(75, var_6_7:y() - var_6_7:height() - 15))
			end
		end)
	end

	idlereasy.when(arg_5_0.yyhuodongs, function(arg_7_0, arg_7_1)
		for iter_7_0, iter_7_1 in ipairs(arg_5_0.data) do
			if arg_7_1[iter_7_1.activityId] then
				local var_7_0 = arg_7_1[iter_7_1.activityId].lastday
				local var_7_1 = arg_7_1[iter_7_1.activityId].enddate
				local var_7_2 = tonumber(time.getTodayStrInClock())

				iter_7_1.day:set(math.max(0, 1 + math.floor((time.getNumTimestamp(var_7_1) - time.getNumTimestamp(var_7_2)) / 24 / 3600)))

				local var_7_3 = csv.recharges[iter_7_1.rechargeId]
				local var_7_4 = csv.yunying.yyhuodong[iter_7_1.activityId].paramMap.most

				if iter_7_1.day:read() > var_7_3.param.days * (var_7_4 - 1) then
					iter_7_1.state:set(var_0_0.max)
				else
					iter_7_1.state:set(var_0_0.buy)
				end
			else
				iter_7_1.state:set(var_0_0.buy)
			end
		end
	end)
end

function var_0_2.initModel(arg_8_0)
	arg_8_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_8_0.clientBuyTimes = idler.new(true)
end

function var_0_2.onDetailClick(arg_9_0, arg_9_1)
	gGameUI:stackUI("city.activity.month_card_privilege", nil, nil, arg_9_0.data[arg_9_1])
end

function var_0_2.onBtnClick(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.data[arg_10_1]
	local var_10_1 = var_10_0.state:read()
	local var_10_2 = csv.yunying.yyhuodong[var_10_0.activityId]
	local var_10_3 = csv.recharges[var_10_0.rechargeId]

	if var_10_1 == var_0_0.buy then
		gGameApp:payDirect(arg_10_0, {
			buyTimes = 0,
			rechargeId = var_10_0.rechargeId,
			yyID = var_10_0.activityId,
			csvID = arg_10_1,
			name = var_10_3.name
		}, arg_10_0.clientBuyTimes):serverCb(function()
			gGameUI:showGainDisplay({
				rmb = var_10_3.rmb
			}, {
				raw = false
			})
			gGameUI:showTip(gLanguageCsv.monthCardBuySuccess)
		end):doit()
	end
end

function var_0_2.getActivityIds()
	local var_12_0 = gGameModel.role:read("yy_open")
	local var_12_1 = {}

	for iter_12_0, iter_12_1 in ipairs(var_12_0) do
		local var_12_2 = csv.yunying.yyhuodong[iter_12_1]

		if var_12_2.type == game.YYHUODONG_TYPE_ENUM_TABLE.monthlyCard and not var_12_2.clientParam.type then
			table.insert(var_12_1, {
				rechargeId = var_12_2.paramMap.rechargeID,
				activityId = iter_12_1
			})
		end
	end

	table.sort(var_12_1, function(arg_13_0, arg_13_1)
		return arg_13_0.rechargeId < arg_13_1.rechargeId
	end)

	return var_12_1
end

function var_0_2.getPrivilegeAddition(arg_14_0)
	local var_14_0 = var_0_2.getActivityIds()
	local var_14_1
	local var_14_2 = gGameModel.role:read("yyhuodongs")

	for iter_14_0, iter_14_1 in ipairs(var_14_0) do
		local var_14_3 = var_14_2[iter_14_1.activityId]

		if var_14_3 then
			local var_14_4 = csv.yunying.yyhuodong[iter_14_1.activityId]
			local var_14_5, var_14_6 = time.getHourAndMin(var_14_4.beginTime, true)

			if tonumber(time.getTodayStrInClock(var_14_5, var_14_6)) <= var_14_3.enddate then
				local var_14_7 = csv.month_card_privilege[var_14_4.paramMap.privilege]

				if arg_14_0 == "pwNoCD" then
					if var_14_7[arg_14_0] then
						return true
					end
				else
					var_14_1 = (var_14_1 or 0) + (tonumber(var_14_7[arg_14_0]) or 0)
				end
			end
		end
	end

	return var_14_1
end

return var_0_2
