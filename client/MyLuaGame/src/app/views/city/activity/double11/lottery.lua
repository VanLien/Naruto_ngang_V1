local var_0_0 = class("Double11Lottery", Dialog)
local var_0_1 = {
	OPENED = 2,
	GOTTEN_AWARD = -1,
	CAN_OPEN = 1
}

var_0_0.RESOURCE_FILENAME = "double_11_lottery.json"
var_0_0.RESOURCE_BINDING = {
	["rightPanel1.list2"] = "innerList",
	rightPanel1 = "rightPanel1",
	leftItem = "leftItem",
	["rightPanel2.item"] = "recordItem",
	["rightPanel1.item"] = "item",
	rightPanel2 = "rightPanel2",
	["rightPanel1.list1"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 2,
				data = bindHelper.self("lotteryData"),
				item = bindHelper.self("innerList"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("textName"):text(arg_1_3.name)
					arg_1_1:get("textProbability"):text("(" .. gLanguageCsv.double11Probability .. arg_1_3.weight .. "%)")
					arg_1_1:get("textNum"):text(string.format(gLanguageCsv.double11Num, arg_1_3.num))
					uiEasy.createItemsToList(arg_1_0, arg_1_1:get("awardList"), arg_1_3.award, {
						scale = 0.9
					})
				end
			}
		}
	},
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	leftList = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				padding = 5,
				data = bindHelper.self("btnsAttr"),
				item = bindHelper.self("leftItem"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:get("normal")
					local var_2_1 = arg_2_1:get("selected")
					local var_2_2

					if arg_2_3.select then
						var_2_0:hide()

						var_2_2 = var_2_1:show()

						var_2_2:get("txt"):getVirtualRenderer():setLineSpacing(-10)
					else
						var_2_1:hide()

						var_2_2 = var_2_0:show()

						var_2_2:get("txt"):getVirtualRenderer():setLineSpacing(-10)
					end

					local var_2_3 = var_2_2:size().height - 20

					adapt.setAutoText(var_2_2:get("txt"), arg_2_3.name, var_2_3)
					var_2_1:setTouchEnabled(false)
					bind.touch(arg_2_0, var_2_0, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onLeftButtonClick")
			}
		}
	},
	["rightPanel2.list1"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				padding = 10,
				data = bindHelper.self("record"),
				item = bindHelper.self("recordItem"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					arg_3_1:get("textName"):text(string.format(gLanguageCsv.double11IndexAward, arg_3_3.index))
					arg_3_1:get("textProbability"):text("")

					local var_3_0 = ""

					if arg_3_3.num and arg_3_3.awardName then
						var_3_0 = string.format(gLanguageCsv.double11AwardTips1, arg_3_3.num, arg_3_3.num, arg_3_3.awardName)
					elseif arg_3_3.num then
						var_3_0 = string.format(gLanguageCsv.double11AwardTips2, arg_3_3.num)
					else
						var_3_0 = string.format(gLanguageCsv.double11AwardTips3)
					end

					local var_3_1 = rich.createByStr(string.format(var_3_0, 40)):addTo(arg_3_1, 10):xy(arg_3_1:get("textProbability"):x(), arg_3_1:get("textProbability"):y()):anchorPoint(cc.p(0.5, 0.5)):formatText()
				end,
				dataOrderCmp = function(arg_4_0, arg_4_1)
					return arg_4_0.index > arg_4_1.index
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	Dialog.onCreate(arg_5_0)

	arg_5_0.nowGameIndex = arg_5_2
	arg_5_0.activityId = arg_5_3
	arg_5_0.csvId = arg_5_5

	arg_5_0:initGameCfg()
	arg_5_0:initData(arg_5_1, arg_5_4)
	arg_5_0:initModel()
	arg_5_0:showScratch()
end

function var_0_0.initGameCfg(arg_6_0)
	arg_6_0.gameCfg = {}

	for iter_6_0, iter_6_1 in orderCsvPairs(csv.yunying.double11_game) do
		if iter_6_1.huodongID == csv.yunying.yyhuodong[arg_6_0.activityId].huodongID then
			arg_6_0.gameCfg[iter_6_1.game] = {
				itemId = iter_6_1.itemID,
				csvId = iter_6_0
			}
		end
	end
end

function var_0_0.initModel(arg_7_0)
	arg_7_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_7_0.record = idlers.new()
	arg_7_0.tabIndex = idler.new(1)
	arg_7_0.cardNum = nil
	arg_7_0.win = false
	arg_7_0.btnsAttr = idlers.newWithMap({
		{
			select = true,
			name = gLanguageCsv.double11Award
		},
		{
			select = false,
			name = gLanguageCsv.double11Record
		}
	})

	arg_7_0.tabIndex:addListener(function(arg_8_0, arg_8_1, arg_8_2)
		arg_7_0.btnsAttr:atproxy(arg_8_1).select = false
		arg_7_0.btnsAttr:atproxy(arg_8_0).select = true

		if arg_8_0 == 1 and arg_8_1 == 1 then
			arg_7_0.rightPanel2:hide()
			arg_7_0.rightPanel1:show()
		else
			arg_7_0["rightPanel" .. arg_8_1]:hide()
			arg_7_0["rightPanel" .. arg_8_0]:show()
		end
	end)
	idlereasy.when(arg_7_0.yyhuodongs, function(arg_9_0, arg_9_1)
		local var_9_0 = {}
		local var_9_1 = arg_9_1[arg_7_0.activityId] and arg_9_1[arg_7_0.activityId].double11

		if var_9_1 then
			if var_9_1[arg_7_0.csvId] and var_9_1[arg_7_0.csvId].card_num then
				arg_7_0.cardNum = var_9_1[arg_7_0.csvId].card_num
			end

			if var_9_1[arg_7_0.csvId] and var_9_1[arg_7_0.csvId].lottery_csv_id > 0 then
				arg_7_0.win = true
			end

			for iter_9_0 = 1, #arg_7_0.gameCfg do
				local var_9_2 = arg_7_0.gameCfg[iter_9_0].csvId

				if iter_9_0 <= arg_7_0.nowGameIndex then
					if var_9_1[var_9_2] then
						local var_9_3 = var_9_1[var_9_2].lottery_csv_id

						if var_9_1[var_9_2].card_status ~= var_0_1.CAN_OPEN and csv.yunying.double11_lottery[var_9_3] then
							table.insert(var_9_0, {
								index = iter_9_0,
								awardName = csv.yunying.double11_lottery[var_9_3].name,
								num = var_9_1[var_9_2].card_num
							})
						else
							table.insert(var_9_0, {
								index = iter_9_0,
								num = var_9_1[var_9_2].card_num
							})
						end
					else
						table.insert(var_9_0, {
							index = iter_9_0
						})
					end
				end
			end
		else
			for iter_9_1 = 1, #arg_7_0.gameCfg do
				if iter_9_1 < arg_7_0.nowGameIndex then
					table.insert(var_9_0, {
						index = iter_9_1
					})
				end
			end
		end

		arg_7_0:initUI()
		arg_7_0.record:update(var_9_0)
		arg_7_0.rightPanel2:get("duckPanel"):setVisible(#var_9_0 == 0)
	end)
end

function var_0_0.initData(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = csv.yunying.double11_lottery

	arg_10_0.lotteryData = {}

	if arg_10_2 then
		for iter_10_0, iter_10_1 in orderCsvPairs(var_10_0) do
			if iter_10_1.huodongID == arg_10_1 then
				local var_10_1 = table.shallowcopy(iter_10_1)

				var_10_1.num = arg_10_2[iter_10_0]

				table.insert(arg_10_0.lotteryData, var_10_1)
			end
		end
	end

	local var_10_2 = csv.yunying.yyhuodong[arg_10_0.activityId].paramMap.gameTime
	local var_10_3 = 0

	for iter_10_2, iter_10_3 in orderCsvPairs(var_10_2) do
		var_10_3 = var_10_3 + 1
	end

	local var_10_4 = arg_10_0.nowGameIndex % var_10_3 == 0 and var_10_3 or arg_10_0.nowGameIndex % var_10_3
	local var_10_5, var_10_6 = time.getHourAndMin(var_10_2[var_10_4][2])

	arg_10_0.timeStr = var_10_5 .. ":" .. var_10_6
end

function var_0_0.initUI(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0.rightPanel1:get("imgTicket")
	local var_11_1 = arg_11_0.rightPanel1:get("imgNoTicket")
	local var_11_2 = arg_11_0.rightPanel1:get("textTip1")
	local var_11_3 = arg_11_0.rightPanel1:get("textTip2")
	local var_11_4 = arg_11_0.rightPanel1:get("textTip3")
	local var_11_5 = arg_11_0.rightPanel1:get("textTip4")

	if arg_11_0.cardNum then
		var_11_0:show()
		var_11_0:get("textNote"):text(string.format(gLanguageCsv.double11Num, arg_11_0.cardNum))
		var_11_1:hide()
		var_11_2:hide()

		if arg_11_0.win then
			var_11_3:hide()
			var_11_4:show()
			var_11_5:show():text(string.format(gLanguageCsv.doubleAwardTime, arg_11_0.timeStr))
		else
			var_11_3:show()
			var_11_4:hide()
			var_11_5:hide()
		end
	else
		var_11_0:hide()
		var_11_1:show()
		var_11_2:show()
		var_11_3:hide()
		var_11_4:hide()
		var_11_5:hide()
	end
end

function var_0_0.showScratch(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0.yyhuodongs:read()[arg_12_0.activityId] and arg_12_0.yyhuodongs:read()[arg_12_0.activityId].double11
	local var_12_1 = arg_12_0.nowGameIndex

	if arg_12_0.nowGameIndex > #arg_12_0.gameCfg then
		var_12_1 = #arg_12_0.gameCfg
	end

	local var_12_2 = arg_12_0.gameCfg[var_12_1].csvId

	if var_12_0 and var_12_0[var_12_2] and var_12_0[var_12_2].card_status == var_0_1.CAN_OPEN then
		local var_12_3 = var_12_0[var_12_2].card_num

		gGameUI:stackUI("city.activity.double11.scratch", nil, nil, arg_12_0.activityId, var_12_2, var_12_3)
	end
end

function var_0_0.onLeftButtonClick(arg_13_0, arg_13_1, arg_13_2)
	arg_13_0.tabIndex:set(arg_13_2)
end

return var_0_0
