local var_0_0 = class("ActivityRecordPassportView", Dialog)

var_0_0.RESOURCE_FILENAME = "activity_record_passport.json"
var_0_0.RESOURCE_BINDING = {
	["rewardPanel.rmbText"] = "rewardText",
	rewardItem = "rewardItem",
	["rewardPanel.textNode2"] = "txtNode2",
	bg = "bg",
	["rewardPanel.scroll"] = "rewardScroll",
	["rewardPanel.timePanel.txtNode"] = "rewardTimeTxtNode",
	rewardPanel = "rewardPanel",
	["rewardPanel.timePanel.endTime"] = "rewardEndTime",
	["rewardPanel.line"] = "rewardLine",
	["rewardPanel.highMask"] = "highMask",
	["rewardPanel.imgLvMax"] = "imgLvMax",
	["rewardPanel.nameText"] = "nameText",
	["rewardPanel.highLock"] = "highLock",
	["rewardPanel.nameText1"] = "nameText1",
	["bg.numPanel"] = "numPanel",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["rewardPanel.btnBuy"] = {
		varname = "btnBuy",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnBuy")
			}
		}
	},
	["rewardPanel.txtNormal"] = {
		varname = "rewardTxtNormal",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	},
	["rewardPanel.txtHigh"] = {
		varname = "rewardTxtHigh",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0, arg_1_1)
	arg_1_0.activityId = arg_1_1

	arg_1_0:initModel()

	local var_1_0 = csv.yunying.yyhuodong[arg_1_0.activityId]

	arg_1_0.dailyBuyTimes = var_1_0.paramMap.dailyBuyTimes
	arg_1_0.days = var_1_0.paramMap.levelLimit
	arg_1_0.endDate = var_1_0.endDate

	arg_1_0:initData()

	local var_1_1 = arg_1_0.numPanel:get("icon"):x()

	arg_1_0.numPanel:get("icon"):x(var_1_1 - 109 * var_1_0.paramMap.levelLimit)

	local var_1_2 = csv.yunying.playpassport_recharge

	for iter_1_0, iter_1_1 in csvMapPairs(var_1_2) do
		if iter_1_1.huodongID == var_1_0.huodongID then
			arg_1_0.csvId = iter_1_0
		end
	end

	local var_1_3 = csv.recharges[var_1_2[arg_1_0.csvId].rechargeID].rmbDisplay

	arg_1_0.btnBuy:get("txtNode"):text(string.format(gLanguageCsv.symbolMoney, var_1_3))

	arg_1_0.clientBuyTimes = idler.new(true)

	idlereasy.any({
		arg_1_0.yyhuodongs,
		arg_1_0.clientBuyTimes
	}, function(arg_2_0, arg_2_1)
		local var_2_0 = arg_2_1[arg_1_0.activityId] or {
			stamps = {},
			info = {
				elite_buy = 0,
				exp = 0,
				buy_level = 0,
				buy_times = 0,
				last_time = 0,
				level = 0
			},
			stamps1 = {}
		}
		local var_2_1 = 0
		local var_2_2 = {}

		arg_1_0.currentPassportLv = var_2_0.info.level
		arg_1_0.isMaxLv = arg_1_0.max == var_2_0.info.level
		arg_1_0.buyHigh = var_2_0.info.elite_buy > 0
		arg_1_0.curRewardIdx = nil

		local var_2_3 = 1

		for iter_2_0, iter_2_1 in ipairs(arg_1_0.awardCfg) do
			local var_2_4 = iter_2_1.cfg
			local var_2_5 = iter_2_1.custom

			if var_2_4.level <= var_2_0.info.level then
				var_2_1 = var_2_1 + var_2_4.needExp
			end

			if var_2_4.level == var_2_0.info.level + 1 then
				local var_2_6 = iter_2_1
			end

			local var_2_7 = var_2_0.stamps[var_2_5.csvId]

			if var_2_7 and var_2_5.normalAwardState ~= var_2_7 then
				var_2_5.normalAwardState = var_2_7

				if not arg_1_0.isReset then
					arg_1_0:modifyItem(iter_2_0)
				end
			end

			local var_2_8 = var_2_0.stamps1[var_2_5.csvId]

			if var_2_8 and var_2_5.eliteAwardState ~= var_2_8 then
				var_2_5.eliteAwardState = var_2_8

				if not arg_1_0.isReset then
					arg_1_0:modifyItem(iter_2_0)
				end
			end

			if not arg_1_0.curRewardIdx then
				if not arg_1_0.buyHigh then
					if var_2_5.normalAwardState == 1 then
						arg_1_0.curRewardIdx = iter_2_0
					elseif var_2_5.normalAwardState == 0 then
						var_2_3 = iter_2_0
					end
				elseif var_2_5.normalAwardState == 1 or var_2_5.eliteAwardState == 1 then
					arg_1_0.curRewardIdx = iter_2_0
				elseif var_2_5.normalAwardState == 0 and var_2_5.eliteAwardState == 0 then
					var_2_3 = iter_2_0
				end
			end
		end

		arg_1_0.curRewardIdx = arg_1_0.curRewardIdx or var_2_3

		arg_1_0.btnBuy:visible(not arg_1_0.buyHigh)
		arg_1_0.highMask:visible(not arg_1_0.buyHigh)
		arg_1_0.highLock:visible(not arg_1_0.buyHigh)

		if dataEasy.getPayClientBuyTimes("directBuyData", arg_1_1, arg_1_0.csvId, 0) > 0 then
			arg_1_0.btnBuy:hide()
		end

		arg_1_0.imgLvMax:visible(arg_1_0.buyHigh)
	end)

	if not arg_1_0.buyHigh then
		arg_1_0.rewardText:visible(var_1_2[arg_1_0.csvId].originalPrice ~= 0)
		arg_1_0.rewardLine:visible(var_1_2[arg_1_0.csvId].originalPrice ~= 0)

		if var_1_2[arg_1_0.csvId].originalPrice ~= 0 then
			arg_1_0.rewardText:text(string.format(gLanguageCsv.recordPassportRmbShow, var_1_2[arg_1_0.csvId].originalPrice))
		end
	else
		arg_1_0.rewardText:hide()
		arg_1_0.rewardLine:hide()
	end

	local var_1_4 = gGameModel.role:read("yy_endtime")[arg_1_0.activityId]
	local var_1_5 = time.getDate(math.floor(var_1_4 + 100))

	arg_1_0.rewardEndTime:text(string.format(gLanguageCsv.recordPassportShowDay, var_1_5.year, var_1_5.month, var_1_5.day, var_1_5.hour))

	local var_1_6 = rich.createWithWidth(gLanguageCsv.recordPassportTitle1, 40, nil, 1250):addTo(arg_1_0.nameText, 10):anchorPoint(cc.p(0, 0.5)):formatText()
	local var_1_7 = rich.createWithWidth(gLanguageCsv.recordPassportTitle2, 50, nil, 1250):addTo(arg_1_0.nameText1, 10):anchorPoint(cc.p(0, 0.5)):formatText()

	if arg_1_0.isReset then
		arg_1_0:resetScroll()
	end

	Dialog.onCreate(arg_1_0, {
		blackType = 1
	})
end

function var_0_0.initModel(arg_3_0)
	arg_3_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
end

function var_0_0.initData(arg_4_0)
	local var_4_0 = csv.yunying.yyhuodong[arg_4_0.activityId]

	arg_4_0.awardCfg = {}

	for iter_4_0, iter_4_1 in orderCsvPairs(csv.yunying.playpassport_award) do
		if iter_4_1.huodongID == var_4_0.huodongID and iter_4_1.level <= arg_4_0.days then
			table.insert(arg_4_0.awardCfg, {
				cfg = iter_4_1,
				custom = {
					csvId = iter_4_0
				}
			})
		end
	end

	arg_4_0.recharge = csv.yunying.playpassport_recharge
	arg_4_0.max = #arg_4_0.awardCfg
	arg_4_0.currentPassportLv = arg_4_0.yyhuodongs:read()[arg_4_0.activityId] and arg_4_0.yyhuodongs:read()[arg_4_0.activityId].info.level or 1
	arg_4_0.buyHigh = arg_4_0.yyhuodongs:read()[arg_4_0.activityId] and arg_4_0.yyhuodongs:read()[arg_4_0.activityId].info.elite_buy > 0 or false
	arg_4_0.isReset = true

	local var_4_1 = var_4_0.paramMap.taskHuodongID

	arg_4_0.startHideLevel = var_4_0.paramMap.startHideLevel or 0

	if not arg_4_0.clock then
		arg_4_0.clock = 1
	end

	arg_4_0.items = gGameModel.role:getIdler("items")
end

function var_0_0.onBtnRule(arg_5_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_5_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_0.onBtnBuy(arg_6_0)
	local var_6_0 = time.getNumTimestamp(arg_6_0.endDate) - time.getTime()
	local var_6_1, var_6_2 = math.modf(var_6_0 / 86400)
	local var_6_3 = gLanguageCsv.passwordTitleTip
	local var_6_4 = gLanguageCsv.passwordBuyVipNote
	local var_6_5 = gCommonConfigCsv.signinPassportTipDays
	local var_6_6 = csv.yunying.playpassport_recharge

	local function var_6_7()
		gGameApp:payDirect(arg_6_0, {
			buyTimes = 0,
			rechargeId = var_6_6[arg_6_0.csvId].rechargeID,
			yyID = arg_6_0.activityId,
			csvID = arg_6_0.csvId,
			name = var_6_6[arg_6_0.csvId].name
		}, arg_6_0.clientBuyTimes):sdkLongTimeCb():serverCb(function()
			arg_6_0:onClose()
		end):doit()
	end

	if var_6_0 < var_6_5 * 24 * 3600 then
		local var_6_8 = string.format(gLanguageCsv.SigninPasswordBuyVipTips, var_6_1)

		if var_6_1 < 1 then
			var_6_8 = gLanguageCsv.passwordLastdayNote
		end

		local var_6_9 = {
			isRich = false,
			btnType = 2,
			title = var_6_3,
			cb = var_6_7,
			content = var_6_8,
			dialogParams = {
				clickClose = false
			}
		}

		gGameUI:showDialog(var_6_9)
	else
		var_6_7()
	end
end

function var_0_0.getRuleContext(arg_9_0, arg_9_1)
	local var_9_0 = adaptContext

	return {
		var_9_0.clone(arg_9_1.title, function(arg_10_0)
			arg_10_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_9_0.noteText(116),
		var_9_0.noteText(63001, 63006)
	}
end

function var_0_0.onBtnGetClick(arg_11_0, arg_11_1)
	gGameApp:requestServer("/game/yy/award/get", function(arg_12_0)
		gGameUI:showGainDisplay(arg_12_0)
	end, arg_11_0.activityId, arg_11_1.custom.csvId)
end

function var_0_0.checkRefresh(arg_13_0, arg_13_1)
	if arg_13_0.awardCfg[arg_13_1].cfg.specialAward == 1 then
		if arg_13_1 ~= arg_13_0.rigthRewardIndex then
			arg_13_0.rigthRewardIndex = arg_13_1
		end

		return true
	end

	return false
end

function var_0_0.buildScroll(arg_14_0)
	arg_14_0.rewardScroll:setScrollBarEnabled(false)

	local var_14_0 = arg_14_0.rewardItem:width()
	local var_14_1 = arg_14_0.rewardScroll:size()
	local var_14_2 = arg_14_0.rewardScroll:getInnerContainer()
	local var_14_3 = 0
	local var_14_4 = 0

	if arg_14_0.currentPassportLv < arg_14_0.startHideLevel then
		var_14_3, var_14_4 = var_14_0 * arg_14_0.startHideLevel, var_14_1.height
	else
		var_14_3, var_14_4 = var_14_0 * arg_14_0.max, var_14_1.height
	end

	var_14_2:size(var_14_3, var_14_4)

	arg_14_0.itemCreateNum = math.ceil(var_14_1.width / var_14_0)
	arg_14_0.itemCreateNum = arg_14_0.itemCreateNum + 5 >= arg_14_0.max and arg_14_0.itemCreateNum or arg_14_0.itemCreateNum + 5
	arg_14_0.itemCreateNum = arg_14_0.itemCreateNum > arg_14_0.max and arg_14_0.itemCreateNum or arg_14_0.max

	local var_14_5 = arg_14_0.itemCreateNum
	local var_14_6 = var_14_0 * var_14_5
	local var_14_7 = arg_14_0.curRewardIdx
	local var_14_8 = arg_14_0.curRewardIdx - 1 + arg_14_0.itemCreateNum

	if var_14_8 > arg_14_0.max then
		var_14_7 = var_14_7 - (var_14_8 - arg_14_0.max)

		local var_14_9 = arg_14_0.max
	end

	local var_14_10 = var_14_7 % var_14_5 == 0 and var_14_5 or var_14_7 % var_14_5
	local var_14_11 = var_14_10 - 1 == 0 and var_14_5 or var_14_10 - 1
	local var_14_12
	local var_14_13

	arg_14_0.percent = -1

	local function var_14_14()
		local var_15_0 = arg_14_0.rewardScroll:getScrolledPercentHorizontal()

		if var_15_0 < arg_14_0.percent then
			var_14_12 = "right"
			var_14_13 = var_14_11
			arg_14_0.percent = var_15_0
		elseif var_15_0 > arg_14_0.percent then
			var_14_12 = "left"
			var_14_13 = var_14_10
			arg_14_0.percent = var_15_0
		end

		local var_15_1 = math.abs(var_14_2:x())
		local var_15_2 = var_15_1 + var_14_1.width
		local var_15_3 = arg_14_0.rewardScroll:getChildByName("reward" .. var_14_13)
		local var_15_4 = math.ceil(var_15_2 / var_14_0)

		if arg_14_0.currentPassportLv >= arg_14_0.startHideLevel then
			for iter_15_0 = var_15_4, arg_14_0.max do
				if arg_14_0:checkRefresh(iter_15_0) then
					break
				end
			end
		else
			for iter_15_1 = var_15_4, arg_14_0.startHideLevel do
				if arg_14_0:checkRefresh(iter_15_1) then
					break
				end
			end
		end

		local function var_15_5(arg_16_0, arg_16_1)
			local var_16_0 = arg_16_1

			if arg_16_0 ~= "left" then
				var_16_0 = var_14_5 - arg_16_1
			end

			var_14_10 = (var_16_0 + var_14_10 - 1) % var_14_5 + 1
			var_14_11 = (var_16_0 + var_14_11 - 1) % var_14_5 + 1
		end

		local function var_15_6(arg_17_0)
			for iter_17_0 = 1, arg_17_0 do
				local var_17_0 = var_14_12 == "left" and (var_14_13 + iter_17_0 - 1) % var_14_5 or (var_14_13 - iter_17_0 + 1) % var_14_5

				var_17_0 = var_17_0 == 0 and var_14_5 or var_17_0

				local var_17_1 = arg_14_0.rewardScroll:getChildByName("reward" .. var_17_0)

				if var_17_1 then
					if var_14_12 == "left" then
						var_17_1:x(var_17_1:x() + var_14_6)
					else
						var_17_1:x(var_17_1:x() - var_14_6)
					end

					arg_14_0:modifyItem(var_17_1:x() / var_14_0 + 1)
				end
			end
		end

		if var_15_3 then
			local var_15_7 = var_15_3:x()

			if var_14_12 == "left" and var_15_1 > var_15_7 + var_14_0 then
				local var_15_8 = arg_14_0.rewardScroll:getChildByName("reward" .. (var_14_11 == 0 and var_14_5 or var_14_11))
				local var_15_9 = (var_14_3 - var_15_8:x()) / var_14_0 - 1
				local var_15_10 = math.min(math.ceil((var_15_1 - (var_15_7 + var_14_0)) / var_14_0), var_15_9)

				var_15_5(var_14_12, var_15_10)
				var_15_6(var_15_10)

				var_14_13 = var_14_10
			elseif var_14_12 == "right" and var_15_2 < var_15_7 then
				local var_15_11 = arg_14_0.rewardScroll:getChildByName("reward" .. (var_14_10 == 0 and var_14_5 or var_14_10)):x() / var_14_0
				local var_15_12 = math.min(math.ceil((var_15_7 - var_14_0 - var_15_2) / var_14_0), var_15_11)

				var_15_5(var_14_12, var_15_12)
				var_15_6(var_15_12)

				var_14_13 = var_14_11
			end

			local var_15_13 = var_14_0 * arg_14_0.startHideLevel

			if arg_14_0.currentPassportLv < arg_14_0.startHideLevel and var_14_12 == "left" and var_15_2 >= var_15_13 - 1 then
				gGameUI:showTip(string.format(gLanguageCsv.upPasswordLevelToGet, arg_14_0.startHideLevel))
			end
		end
	end

	var_14_14()
	arg_14_0.rewardScroll:onEvent(function(arg_18_0)
		if arg_18_0.name == "CONTAINER_MOVED" then
			var_14_14()
		elseif arg_18_0.name == "SCROLLING_BEGAN" then
			arg_14_0:refreshNoClick(true)
		elseif arg_18_0.name == "AUTOSCROLL_ENDED" then
			arg_14_0:refreshNoClick(false)
		elseif arg_18_0.name == "SCROLLING_ENDED" then
			-- block empty
		end
	end)
end

function var_0_0.buildItem(arg_19_0)
	local var_19_0 = arg_19_0.curRewardIdx
	local var_19_1 = arg_19_0.curRewardIdx - 1 + arg_19_0.itemCreateNum

	if var_19_1 > arg_19_0.max then
		var_19_0 = var_19_0 - (var_19_1 - arg_19_0.max)
		var_19_1 = arg_19_0.max
	end

	for iter_19_0 = var_19_0, var_19_1 do
		arg_19_0:addItem(iter_19_0)
	end
end

function var_0_0.addItem(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0.awardCfg[arg_20_1]
	local var_20_1 = arg_20_0.rewardItem:clone()
	local var_20_2 = arg_20_1 % arg_20_0.itemCreateNum == 0 and arg_20_0.itemCreateNum or arg_20_1 % arg_20_0.itemCreateNum
	local var_20_3 = arg_20_0.rewardItem:width()
	local var_20_4 = (arg_20_1 - 1) * var_20_3

	var_20_1:xy(var_20_4, 0)
	arg_20_0:refreshRewardItem(var_20_1, arg_20_1)
	arg_20_0.rewardScroll:addChild(var_20_1, var_20_2, "reward" .. var_20_2)
	var_20_1:show()

	return var_20_1
end

function var_0_0.modifyItem(arg_21_0, arg_21_1)
	for iter_21_0 = 1, arg_21_0.itemCreateNum do
		local var_21_0 = arg_21_0.rewardScroll:getChildByName("reward" .. iter_21_0)

		if var_21_0:x() == (arg_21_1 - 1) * arg_21_0.rewardItem:width() then
			arg_21_0:refreshRewardItem(var_21_0, arg_21_1)
		end
	end
end

function var_0_0.refreshRewardItem(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0.awardCfg[arg_22_2]
	local var_22_1 = var_22_0.cfg.specialAward == 1
	local var_22_2 = arg_22_1:multiget("lv", "normalPanel1", "normalPanel2", "normalPanel3", "normalPanel4", "highPanel1", "highPanel2", "topMask", "bottomMask", "btnGet", "noClick", "bg")
	local var_22_3 = math.modf(var_22_0.cfg.level / 10)
	local var_22_4 = var_22_0.cfg.level % 10
	local var_22_5 = ""

	if var_22_3 > 0 then
		if var_22_4 > 0 then
			var_22_5 = gLanguageCsv["symbolNumber" .. var_22_3] .. gLanguageCsv["symbolNumber" .. 10] .. gLanguageCsv["symbolNumber" .. var_22_4]
		else
			var_22_5 = gLanguageCsv["symbolNumber" .. var_22_3] .. gLanguageCsv["symbolNumber" .. 10]
		end
	else
		var_22_5 = gLanguageCsv["symbolNumber" .. var_22_4]
	end

	var_22_2.lv:text(string.format(gLanguageCsv.recordPassportDay, var_22_5))

	local var_22_6 = {}

	for iter_22_0, iter_22_1 in csvMapPairs(var_22_0.cfg.normalAward) do
		table.insert(var_22_6, {
			key = iter_22_0,
			num = iter_22_1,
			state = var_22_0.custom.normalAwardState
		})
	end

	for iter_22_2, iter_22_3 in ipairs(var_22_6) do
		arg_22_0:onBindIcon(arg_22_0.rewardScroll, var_22_2["normalPanel" .. iter_22_2], iter_22_3, var_22_1)
	end

	local var_22_7 = {}

	for iter_22_4, iter_22_5 in csvMapPairs(var_22_0.cfg.eliteAward) do
		table.insert(var_22_7, {
			key = iter_22_4,
			num = iter_22_5,
			state = var_22_0.custom.eliteAwardState
		})
	end

	arg_22_0:onBindIcon(arg_22_0.rewardScroll, var_22_2.highPanel1, var_22_7[1], var_22_1)

	if var_22_7[2] then
		arg_22_0:onBindIcon(arg_22_0.rewardScroll, var_22_2.highPanel2, var_22_7[2], var_22_1)
		var_22_2.highPanel2:show()
	else
		var_22_2.highPanel2:hide()
	end

	var_22_2.btnGet:visible(var_22_0.custom.normalAwardState == 1 or var_22_0.custom.eliteAwardState == 1)

	if var_22_0.custom.normalAwardState == 1 or var_22_0.custom.eliteAwardState == 1 then
		var_22_2.bg:texture("activity/luxury_record/panle_list_2.png")
	else
		var_22_2.bg:texture("activity/luxury_record/panle_list_1.png")
	end

	bind.touch(arg_22_0, var_22_2.btnGet, {
		methods = {
			ended = function(arg_23_0, arg_23_1, arg_23_2)
				arg_22_0:onBtnGetClick(var_22_0)
			end
		}
	})
	var_22_2.topMask:visible(arg_22_0.currentPassportLv < var_22_0.cfg.level)
	var_22_2.bottomMask:visible(arg_22_0.currentPassportLv < var_22_0.cfg.level or not arg_22_0.buyHigh)
	bind.click(arg_22_0, var_22_2.noClick, {
		method = function()
			arg_22_0:onRewardNoClick()
		end
	})
end

function var_0_0.onRewardNoClick(arg_25_0)
	arg_25_0:refreshNoClick(false)
end

function var_0_0.onBindIcon(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	bind.extend(arg_26_0, arg_26_2, {
		class = "icon_key",
		props = {
			data = arg_26_3,
			onNode = function(arg_27_0)
				arg_27_0:scale(0.9)

				local var_27_0 = arg_26_2:get("img")

				if var_27_0 then
					var_27_0:visible(arg_26_3.state == 0)
				else
					local var_27_1 = ccui.ImageView:create("common/icon/radio_selected.png"):addTo(arg_26_2, 1000, "img"):xy(140, 140):visible(arg_26_3.state == 0)
				end
			end
		}
	})

	local var_26_0 = arg_26_2:getChildByName("wupinshanguang")

	if var_26_0 then
		var_26_0:removeFromParent()
	end

	if arg_26_4 then
		widget.addAnimationByKey(arg_26_2, "wupinshanguang/saoguang.skel", "wupinshanguang", "effect_loop", 999):xy(arg_26_2:size().width / 2, arg_26_2:size().height / 2):scale(0.5)
	end
end

function var_0_0.jumpScroll(arg_28_0)
	local var_28_0 = arg_28_0.itemCreateNum
	local var_28_1 = arg_28_0.curRewardIdx % var_28_0 == 0 and var_28_0 or arg_28_0.curRewardIdx % var_28_0
	local var_28_2 = arg_28_0.rewardScroll:getChildByName("reward" .. var_28_1)

	if not var_28_2 then
		return
	end

	local var_28_3 = var_28_2:x()
	local var_28_4 = arg_28_0.rewardScroll:getInnerContainer():size()
	local var_28_5 = arg_28_0.rewardScroll:size().width
	local var_28_6 = cc.clampf(var_28_3 / (var_28_4.width - var_28_5) * 100, 0, 100)

	arg_28_0.rewardScroll:scrollToPercentHorizontal(var_28_6, 0.01, false)

	arg_28_0.percent = var_28_6
end

function var_0_0.resetScroll(arg_29_0)
	arg_29_0.rewardScroll:removeAllChildren()
	arg_29_0:buildScroll()
	arg_29_0:buildItem()
	arg_29_0:refreshNoClick(false)
	arg_29_0:jumpScroll()

	arg_29_0.isReset = false
end

function var_0_0.refreshNoClick(arg_30_0, arg_30_1)
	for iter_30_0 = 1, arg_30_0.itemCreateNum do
		arg_30_0.rewardScroll:getChildByName("reward" .. iter_30_0):getChildByName("noClick"):visible(arg_30_1)
	end
end

function var_0_0.updateTime(arg_31_0)
	local var_31_0 = gGameModel.role:read("yy_endtime")[arg_31_0.activityId] - time.getTime()

	bind.extend(arg_31_0, arg_31_0.rewardEndTime, {
		class = "cutdown_label",
		props = {
			time = var_31_0,
			endFunc = function()
				arg_31_0.rewardEndTime:text(gLanguageCsv.activityOver)
			end
		}
	})
end

return var_0_0
