local var_0_0 = {
	CAN_NOT_GOTTEN = 2,
	CAN_GOTTEN = 1,
	GOTTEN = 0
}
local var_0_1 = {
	GET = 2,
	BUY = 1
}
local var_0_2 = class("ActivityWeeklyCardDialog", Dialog)

var_0_2.RESOURCE_FILENAME = "activity_weekly_card.json"
var_0_2.RESOURCE_BINDING = {
	atlasLabel1 = "atlasLabel1",
	item = "item",
	imgAward2 = "imgAward2",
	imgAward1 = "imgAward1",
	imgGift = "imgGift",
	textTitle = "textTitle",
	imgTitle = "imgTitle",
	iconItem = "iconItem",
	atlasLabel2 = "atlasLabel2",
	btnBuy = {
		varname = "btnBuy",
		binds = {
			{
				clicksafe = true,
				event = "touch",
				methods = {
					ended = bindHelper.self("buyWeeklyCard")
				}
			},
			{
				event = "visible",
				idler = bindHelper.self("notbuy")
			}
		}
	},
	btnBought = {
		varname = "btnBought",
		binds = {
			event = "visible",
			idler = bindHelper.self("buy")
		}
	},
	["btnBought.textBought"] = {
		binds = {
			{
				event = "effect",
				data = {
					color = ui.COLORS.NORMAL.YELLOW,
					outline = {
						size = 3,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	},
	["btnBuy.textPrice"] = {
		binds = {
			{
				event = "effect",
				data = {
					color = ui.COLORS.NORMAL.YELLOW,
					outline = {
						size = 3,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	},
	text1 = {
		varname = "text1"
	},
	textCountDown = {
		varname = "textCountDown"
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("itemsData"),
				item = bindHelper.self("item"),
				preloadCenter = bindHelper.self("preloadCenter"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_0.initItem(arg_1_1, arg_1_2, arg_1_3)
				end
			},
			handlers = {
				initItem = bindHelper.self("initItem")
			}
		}
	}
}

function var_0_2.onCreate(arg_2_0, arg_2_1)
	arg_2_0.activityId = arg_2_1

	arg_2_0:initModel()
	arg_2_0:initData()
	arg_2_0:initTitle()
	gGameModel.currday_dispatch:getIdlerOrigin("newPlayerWeffare"):set(true)
end

function var_0_2.initModel(arg_3_0)
	arg_3_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_3_0.itemsData = idlertable.new({})
	arg_3_0.date = idler.new("")
	arg_3_0.buy = idler.new()
	arg_3_0.notbuy = idler.new()
end

function var_0_2.initData(arg_4_0)
	local var_4_0 = {}
	local var_4_1 = csv.yunying.yyhuodong[arg_4_0.activityId].huodongID

	for iter_4_0, iter_4_1 in csvPairs(csv.yunying.weeklycard) do
		if iter_4_1.huodongID == var_4_1 then
			var_4_0[iter_4_1.day] = {
				award = iter_4_1.award,
				id = iter_4_0
			}
		end
	end

	arg_4_0.clientBuyTimes = idler.new(true)

	idlereasy.any({
		arg_4_0.yyhuodongs,
		arg_4_0.clientBuyTimes
	}, function(arg_5_0, arg_5_1)
		local var_5_0 = arg_5_1[arg_4_0.activityId] or {}
		local var_5_1 = {}

		for iter_5_0, iter_5_1 in pairs(var_4_0) do
			if var_5_0.stamps == nil then
				var_5_1[iter_5_0] = {
					award = iter_5_1.award,
					id = iter_5_1.id,
					getType = var_0_0.CAN_NOT_GOTTEN
				}
			elseif var_5_0.stamps[iter_5_1.id] == nil then
				var_5_1[iter_5_0] = {
					award = iter_5_1.award,
					id = iter_5_1.id,
					getType = var_0_0.CAN_NOT_GOTTEN
				}
			else
				var_5_1[iter_5_0] = {
					award = iter_5_1.award,
					id = iter_5_1.id,
					getType = var_5_0.stamps[iter_5_1.id]
				}

				if not arg_4_0.preloadCenter and var_5_1[iter_5_0].getType == var_0_0.CAN_GOTTEN then
					arg_4_0.preloadCenter = iter_5_0
				end
			end
		end

		arg_4_0.itemsData:set(var_5_1)

		if dataEasy.getPayClientBuyTimes("directBuyData", arg_4_0.activityId, 0, 0) == 0 and var_5_0.buy == nil then
			arg_4_0.buy:set(false)
			arg_4_0.notbuy:set(true)
			arg_4_0:initCountDown(var_0_1.BUY)
		else
			arg_4_0.buy:set(true)
			arg_4_0.notbuy:set(false)
			arg_4_0:initCountDown(var_0_1.GET)
		end
	end)
end

function var_0_2.initTitle(arg_6_0)
	local var_6_0 = csv.yunying.yyhuodong[arg_6_0.activityId]

	arg_6_0.imgTitle:texture(var_6_0.clientParam.titleRes)

	if var_6_0.clientParam.iconRes then
		arg_6_0.imgGift:texture(var_6_0.clientParam.iconRes)
	end

	if matchLanguage({
		"en"
	}) then
		adapt.setTextScaleWithWidth(arg_6_0.textTitle, nil, 580)
		adapt.setTextScaleWithWidth(arg_6_0.textCountDown, nil, 230)
	end

	arg_6_0.imgAward1:texture(var_6_0.clientParam.award1.res)
	arg_6_0.imgAward2:texture(var_6_0.clientParam.award2.res)
	arg_6_0.atlasLabel1:text(var_6_0.clientParam.award1.count)
	arg_6_0.atlasLabel2:text(var_6_0.clientParam.award2.count)
	arg_6_0.atlasLabel1:scale(var_6_0.clientParam.award1.scale)
	arg_6_0.atlasLabel2:scale(var_6_0.clientParam.award2.scale)

	local var_6_1 = var_6_0.paramMap.recharge
	local var_6_2 = csv.recharges[var_6_1]

	arg_6_0.btnBuy:get("textPrice"):text(string.format(gLanguageCsv.symbolMoney, var_6_2.rmbDisplay))
end

function var_0_2.initCountDown(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.textCountDown
	local var_7_1 = csv.yunying.yyhuodong[arg_7_0.activityId]
	local var_7_2 = 0

	if arg_7_1 == var_0_1.BUY then
		arg_7_0.text1:text(gLanguageCsv.sellCountDown)

		local var_7_3, var_7_4 = time.getHourAndMin(var_7_1.beginTime)
		local var_7_5 = var_7_1.paramMap.buyDay

		var_7_2 = time.getNumTimestamp(var_7_1.beginDate, var_7_3, var_7_4) + var_7_5 * 24 * 60 * 60

		arg_7_0.text1:show()
		arg_7_0.textCountDown:show()
	else
		if var_7_1.clientParam.isShowCountDown == false then
			arg_7_0.text1:hide()
			arg_7_0.textCountDown:hide()
		end

		arg_7_0.text1:text(gLanguageCsv.getCountDown)

		local var_7_6, var_7_7 = time.getHourAndMin(var_7_1.endTime)

		var_7_2 = time.getNumTimestamp(var_7_1.endDate, var_7_6, var_7_7)
	end

	local function var_7_8()
		local var_8_0 = time.getCutDown(var_7_2 - time.getTime())

		var_7_0:text(var_8_0.str)

		if var_7_2 - time.getTime() <= 0 then
			var_7_0:text(gLanguageCsv.activityOver)
			arg_7_0:unSchedule(1)

			return false
		end

		return true
	end

	arg_7_0:enableSchedule()
	arg_7_0:schedule(function(arg_9_0)
		if not var_7_8() then
			return false
		end
	end, 1, 0, 1)
end

function var_0_2.initItem(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = arg_10_2:multiget("textDay", "btnGet", "list", "imgBg", "imgDayBg", "imgGotten")
	local var_10_1 = var_10_0.textDay:setString(arg_10_3)
	local var_10_2 = arg_10_4.award
	local var_10_3 = {}

	uiEasy.createItemsToList(arg_10_1, var_10_0.list, var_10_2, var_10_3)

	if arg_10_4.getType == var_0_0.CAN_NOT_GOTTEN then
		adapt.setTextScaleWithWidth(var_10_0.btnGet:get("textGet"), gLanguageCsv.notReach, 200)
		var_10_0.btnGet:setEnabled(false)
		cache.setShader(var_10_0.btnGet, false, "hsl_gray")
		var_10_0.btnGet:get("textGet"):setTextColor(cc.c4b(255, 252, 237, 255))
		var_10_0.imgGotten:hide()
	elseif arg_10_4.getType == var_0_0.CAN_GOTTEN then
		adapt.setTextScaleWithWidth(var_10_0.btnGet:get("textGet"), gLanguageCsv.spaceReceive, 200)
		var_10_0.btnGet:get("textGet"):setTextColor(cc.c4b(255, 252, 237, 255))
		text.addEffect(var_10_0.btnGet:get("textGet"), {
			color = ui.COLORS.NORMAL.YELLOW,
			outline = {
				size = 4,
				color = ui.NEWCOLORS.OUTLINE.YELLOW
			}
		})
		var_10_0.btnGet:setEnabled(true)
		var_10_0.imgGotten:hide()
	elseif arg_10_4.getType == var_0_0.GOTTEN then
		var_10_0.btnGet:hide()
		var_10_0.imgGotten:show()
	end

	bind.touch(arg_10_0, var_10_0.btnGet, {
		methods = {
			ended = functools.partial(arg_10_0.sendGetAward, arg_10_0, arg_10_4.id)
		}
	})
end

function var_0_2.sendGetAward(arg_11_0, arg_11_1)
	gGameApp:requestServer("/game/yy/award/get", function(arg_12_0)
		gGameUI:showGainDisplay(arg_12_0)
	end, arg_11_0.activityId, arg_11_1)
end

function var_0_2.buyWeeklyCard(arg_13_0)
	local var_13_0 = csv.yunying.yyhuodong[arg_13_0.activityId].paramMap.recharge

	gGameApp:payDirect(arg_13_0, {
		csvID = 0,
		buyTimes = 0,
		rechargeId = var_13_0,
		yyID = arg_13_0.activityId
	}, arg_13_0.clientBuyTimes):sdkLongTimeCb():serverCb(function()
		arg_13_0.buy:set(true)
		arg_13_0.notbuy:set(false)
	end):doit()
end

return var_0_2
