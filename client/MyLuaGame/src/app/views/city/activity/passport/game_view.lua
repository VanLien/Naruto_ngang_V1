local var_0_0 = {
	[2] = {
		117001,
		117050
	},
	[3] = {
		118001,
		118050
	},
	[4] = {
		119001,
		119050
	}
}
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("ActivityGamePassportView", var_0_1)

var_0_2.RESOURCE_FILENAME = "activity_game_passport.json"
var_0_2.RESOURCE_BINDING = {
	["rewardPanel.target.highPanel2"] = "targetHighPanel2",
	["rewardPanel.iconNormal"] = "iconNormal",
	["rewardPanel.bg"] = "rewardPanelBg",
	["rewardPanel.textNode2"] = "txtNode2",
	["rewardPanel.scroll"] = "rewardScroll",
	["rewardPanel.highMask"] = "highMask",
	["rewardPanel.exp"] = "rewardExp",
	["rewardPanel.target"] = "target",
	bg = "bg",
	["rewardPanel.highLock"] = "highLock",
	["rewardPanel.nameText1"] = "nameText1",
	rewardItem = "rewardItem",
	rewardPanel = "rewardPanel",
	["rewardPanel.target.noClick"] = "targetNoClick",
	["rewardPanel.expBar"] = "rewardExpBar",
	["rewardPanel.target.normalPanel"] = "targetNormalPanel",
	["rewardPanel.iconHigh"] = "iconHigh",
	["rewardPanel.target.highPanel1"] = "targetHighPanel1",
	["rewardPanel.nameText"] = "nameText",
	["rewardPanel.txtNode"] = {
		varname = "rewardTimeTxtNode"
	},
	["rewardPanel.endTime"] = {
		varname = "rewardEndTime"
	},
	["rewardPanel.name"] = {
		varname = "rewardName"
	},
	["rewardPanel.lvName"] = {
		varname = "rewardLvName"
	},
	["rewardPanel.lv"] = {
		varname = "rewardLv"
	},
	["rewardPanel.btnRule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnRule")
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
	["rewardPanel.btnBuy.txtNode"] = {
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
	["rewardPanel.btnOneKeyGet.txtNode"] = {
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
	["rewardPanel.btnBuyExp.txtNode"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE
				}
			}
		}
	},
	["rewardItem.btnGet.txtNode"] = {
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
	["rewardPanel.btnBuyExp"] = {
		varname = "btnBuyExp",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnBuyExp")
			}
		}
	},
	["rewardPanel.btnOneKeyGet"] = {
		varname = "btnOneKeyGet",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnOneKeyGet")
			}
		}
	},
	["rewardPanel.txtNormal"] = {
		varname = "rewardTxtNormal",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(255, 255, 255, 255)
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
					size = 3,
					color = cc.c4b(255, 255, 255, 255)
				}
			}
		}
	}
}

function var_0_2.onCreate(arg_1_0, arg_1_1)
	arg_1_0.activityId = arg_1_1

	arg_1_0:initModel()
	arg_1_0:initData()

	local var_1_0 = csv.yunying.yyhuodong[arg_1_0.activityId]

	arg_1_0.type = var_1_0.paramMap.type

	arg_1_0.rewardLvName:text(gLanguageCsv["gamePassportNowText" .. arg_1_0.type])

	arg_1_0.dailyBuyTimes = var_1_0.paramMap.dailyBuyTimes
	arg_1_0.endDate = var_1_0.endDate

	arg_1_0.target:visible(var_1_0.clientParam.showLastUnlock)
	arg_1_0.bg:texture(var_1_0.clientParam.res)
	arg_1_0.rewardPanelBg:texture(var_1_0.clientParam.banner)
	arg_1_0.iconNormal:texture(var_1_0.clientParam.icon .. ".png")
	arg_1_0.iconHigh:texture(var_1_0.clientParam.icon .. "1" .. ".png")

	arg_1_0.topView = gGameUI.topuiManager:createView(arg_1_0.exchangeShop == 1 and "passport" or "default", arg_1_0, {
		onClose = arg_1_0:createHandler("onClose")
	}):init({
		title = var_1_0.name,
		subTitle = var_1_0.clientParam.topText
	})
	arg_1_0.clientBuyTimes = idler.new(true)

	idlereasy.any({
		arg_1_0.yyhuodongs,
		arg_1_0.clientBuyTimes
	}, function(arg_2_0, arg_2_1)
		local var_2_0 = arg_2_1[arg_1_0.activityId]
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

		arg_1_0.rewardLv:text(mathEasy.getShortNumber(var_2_0.info.exp, 2))
		adapt.oneLinePos(arg_1_0.rewardLvName, arg_1_0.rewardLv, cc.p(15, 0))
		arg_1_0.rewardName:text(var_1_0.name)
		arg_1_0.rewardExp:text(var_2_0.info.exp - var_2_1 + arg_1_0.awardCfg[var_2_0.info.level].cfg.needExp .. "/" .. arg_1_0.awardCfg[var_2_0.info.level].cfg.needExp)

		if var_2_0.info.level == arg_1_0.max then
			arg_1_0.rewardExp:text(gLanguageCsv.levelMax)
		end

		arg_1_0.rewardExpBar:setPercent((var_2_0.info.exp - var_2_1 + arg_1_0.awardCfg[var_2_0.info.level].cfg.needExp) / arg_1_0.awardCfg[var_2_0.info.level].cfg.needExp * 100)
		arg_1_0.btnBuy:visible(not arg_1_0.buyHigh)
		arg_1_0.highMask:visible(not arg_1_0.buyHigh)
		arg_1_0.highLock:visible(not arg_1_0.buyHigh)

		for iter_2_2, iter_2_3 in csvMapPairs(csv.yunying.playpassport_recharge) do
			if iter_2_3.huodongID == var_1_0.huodongID and dataEasy.getPayClientBuyTimes("directBuyData", arg_1_1, iter_2_2, 0) > 0 then
				arg_1_0.btnBuy:hide()
			end
		end

		local var_2_9 = arg_1_0.rewardName:x()
		local var_2_10 = arg_1_0.rewardName:size().width

		arg_1_0.nameText:x(var_2_9 + var_2_10 + 50)
		arg_1_0.nameText1:x(var_2_9 + var_2_10 + 50)
	end)

	local var_1_1 = gGameModel.role:read("yy_endtime")[arg_1_0.activityId]
	local var_1_2 = time.getDate(mathEasy.getPreciseDecimal(var_1_1 + 1, 0, true))

	arg_1_0.rewardEndTime:text(string.format(gLanguageCsv.recordPassportShowDay, var_1_2.year, var_1_2.month, var_1_2.day, var_1_2.hour))

	local var_1_3 = rich.createWithWidth(gLanguageCsv["gamePassportTitle" .. arg_1_0.type], 70, nil, 1250):addTo(arg_1_0.nameText, 10):anchorPoint(cc.p(0, 0.5)):formatText()
	local var_1_4 = rich.createWithWidth(gLanguageCsv["gamePassportNextTitle" .. arg_1_0.type], 70, nil, 1250):addTo(arg_1_0.nameText1, 10):anchorPoint(cc.p(0, 0.5)):formatText()

	if arg_1_0.isReset then
		arg_1_0:resetScroll()
	end
end

function var_0_2.initModel(arg_3_0)
	arg_3_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
end

function var_0_2.initData(arg_4_0)
	local var_4_0 = csv.yunying.yyhuodong[arg_4_0.activityId]

	arg_4_0.awardCfg = {}

	local var_4_1 = 0

	for iter_4_0, iter_4_1 in orderCsvPairs(csv.yunying.playpassport_award) do
		if iter_4_1.huodongID == var_4_0.huodongID then
			table.insert(arg_4_0.awardCfg, {
				cfg = iter_4_1,
				custom = {
					csvId = iter_4_0
				},
				expNum = var_4_1
			})

			var_4_1 = iter_4_1.needExp + var_4_1
		end
	end

	arg_4_0.recharge = csv.yunying.playpassport_recharge
	arg_4_0.max = #arg_4_0.awardCfg
	arg_4_0.currentPassportLv = arg_4_0.yyhuodongs:read()[arg_4_0.activityId].info.level
	arg_4_0.buyHigh = arg_4_0.yyhuodongs:read()[arg_4_0.activityId].info.elite_buy > 0
	arg_4_0.isReset = true

	local var_4_2 = var_4_0.paramMap.taskHuodongID

	arg_4_0.startHideLevel = var_4_0.paramMap.startHideLevel or 0

	if not arg_4_0.clock then
		arg_4_0.clock = 1
	end

	arg_4_0.items = gGameModel.role:getIdler("items")

	arg_4_0.btnBuyExp:hide()

	local var_4_3 = (gGameModel.role:read("yy_endtime")[arg_4_0.activityId] or 0) - time.getTime()

	if var_4_0.paramMap.buyUnlock or var_4_0.clientParam.buyExpShowDay and var_4_0.clientParam.buyExpShowDay > 0 and var_4_3 <= var_4_0.clientParam.buyExpShowDay * 24 * 3600 then
		arg_4_0.btnBuyExp:show()
	end
end

function var_0_2.onBtnRule(arg_5_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_5_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_2.onBtnBuy(arg_6_0)
	arg_6_0.rewardScroll:stopAutoScroll()
	gGameUI:stackUI("city.activity.passport.game_buy", nil, nil, arg_6_0.activityId, arg_6_0:createHandler("onBtnBuyCb"))
end

function var_0_2.onBtnBuyCb(arg_7_0)
	arg_7_0.clientBuyTimes:notify()
end

function var_0_2.onBtnBuyExp(arg_8_0)
	arg_8_0.rewardScroll:stopAutoScroll()

	if arg_8_0.isMaxLv then
		gGameUI:showTip(gLanguageCsv.gamePassportShowTip)

		return
	end

	if arg_8_0.yyhuodongs:read()[arg_8_0.activityId].info.buy_times == arg_8_0.dailyBuyTimes then
		gGameUI:showTip(gLanguageCsv.gamePassportShowTipFull)

		return
	end

	gGameUI:stackUI("city.activity.passport.game_buy_exp", nil, nil, arg_8_0.activityId)
end

function var_0_2.getRuleContext(arg_9_0, arg_9_1)
	local var_9_0 = adaptContext

	return {
		var_9_0.clone(arg_9_1.title, function(arg_10_0)
			arg_10_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_9_0.noteText(var_0_0[arg_9_0.type][1], var_0_0[arg_9_0.type][2])
	}
end

function var_0_2.onBtnGetClick(arg_11_0, arg_11_1)
	gGameApp:requestServer("/game/yy/award/get", function(arg_12_0)
		gGameUI:showGainDisplay(arg_12_0)
	end, arg_11_0.activityId, arg_11_1.custom.csvId)
end

function var_0_2.onBtnOneKeyGet(arg_13_0)
	local var_13_0 = false
	local var_13_1 = arg_13_0.yyhuodongs:read()[arg_13_0.activityId]

	for iter_13_0, iter_13_1 in pairs(var_13_1.stamps) do
		if iter_13_1 == 1 then
			var_13_0 = true

			break
		end
	end

	for iter_13_2, iter_13_3 in pairs(var_13_1.stamps1) do
		if iter_13_3 == 1 then
			var_13_0 = true

			break
		end
	end

	if not var_13_0 then
		gGameUI:showTip(gLanguageCsv.noRewardGet)

		return
	end

	gGameApp:requestServer("/game/yy/award/get/onekey", function(arg_14_0)
		gGameUI:showGainDisplay(arg_14_0)
		arg_13_0:resetScroll()
	end, arg_13_0.activityId)
end

function var_0_2.checkRefresh(arg_15_0, arg_15_1)
	if arg_15_0.awardCfg[arg_15_1].cfg.specialAward == 1 then
		if arg_15_1 ~= arg_15_0.rigthRewardIndex then
			arg_15_0.rigthRewardIndex = arg_15_1

			arg_15_0:refreshTarget()
		end

		return true
	end

	return false
end

function var_0_2.buildScroll(arg_16_0)
	arg_16_0.rewardScroll:setScrollBarEnabled(false)

	local var_16_0 = arg_16_0.rewardItem:width()
	local var_16_1 = arg_16_0.rewardScroll:size()
	local var_16_2 = arg_16_0.rewardScroll:getInnerContainer()
	local var_16_3 = 0
	local var_16_4 = 0

	if arg_16_0.currentPassportLv < arg_16_0.startHideLevel then
		var_16_3, var_16_4 = var_16_0 * arg_16_0.startHideLevel, var_16_1.height
	else
		var_16_3, var_16_4 = var_16_0 * arg_16_0.max, var_16_1.height
	end

	var_16_2:size(var_16_3, var_16_4)

	arg_16_0.itemCreateNum = math.ceil(var_16_1.width / var_16_0)
	arg_16_0.itemCreateNum = arg_16_0.itemCreateNum + 5 >= arg_16_0.max and arg_16_0.itemCreateNum or arg_16_0.itemCreateNum + 5
	arg_16_0.itemCreateNum = arg_16_0.itemCreateNum > arg_16_0.max and arg_16_0.itemCreateNum or arg_16_0.max

	local var_16_5 = arg_16_0.itemCreateNum
	local var_16_6 = var_16_0 * var_16_5
	local var_16_7 = arg_16_0.curRewardIdx
	local var_16_8 = arg_16_0.curRewardIdx - 1 + arg_16_0.itemCreateNum

	if var_16_8 > arg_16_0.max then
		var_16_7 = var_16_7 - (var_16_8 - arg_16_0.max)

		local var_16_9 = arg_16_0.max
	end

	local var_16_10 = var_16_7 % var_16_5 == 0 and var_16_5 or var_16_7 % var_16_5
	local var_16_11 = var_16_10 - 1 == 0 and var_16_5 or var_16_10 - 1
	local var_16_12
	local var_16_13

	arg_16_0.percent = -1

	local function var_16_14()
		local var_17_0 = arg_16_0.rewardScroll:getScrolledPercentHorizontal()

		if var_17_0 < arg_16_0.percent then
			var_16_12 = "right"
			var_16_13 = var_16_11
			arg_16_0.percent = var_17_0
		elseif var_17_0 > arg_16_0.percent then
			var_16_12 = "left"
			var_16_13 = var_16_10
			arg_16_0.percent = var_17_0
		end

		local var_17_1 = math.abs(var_16_2:x())
		local var_17_2 = var_17_1 + var_16_1.width
		local var_17_3 = arg_16_0.rewardScroll:getChildByName("reward" .. var_16_13)
		local var_17_4 = math.ceil(var_17_2 / var_16_0)

		if arg_16_0.currentPassportLv >= arg_16_0.startHideLevel then
			for iter_17_0 = var_17_4, arg_16_0.max do
				if arg_16_0:checkRefresh(iter_17_0) then
					break
				end
			end
		else
			for iter_17_1 = var_17_4, arg_16_0.startHideLevel do
				if arg_16_0:checkRefresh(iter_17_1) then
					break
				end
			end
		end

		local function var_17_5(arg_18_0, arg_18_1)
			local var_18_0 = arg_18_1

			if arg_18_0 ~= "left" then
				var_18_0 = var_16_5 - arg_18_1
			end

			var_16_10 = (var_18_0 + var_16_10 - 1) % var_16_5 + 1
			var_16_11 = (var_18_0 + var_16_11 - 1) % var_16_5 + 1
		end

		local function var_17_6(arg_19_0)
			for iter_19_0 = 1, arg_19_0 do
				local var_19_0 = var_16_12 == "left" and (var_16_13 + iter_19_0 - 1) % var_16_5 or (var_16_13 - iter_19_0 + 1) % var_16_5

				var_19_0 = var_19_0 == 0 and var_16_5 or var_19_0

				local var_19_1 = arg_16_0.rewardScroll:getChildByName("reward" .. var_19_0)

				if var_19_1 then
					if var_16_12 == "left" then
						var_19_1:x(var_19_1:x() + var_16_6)
					else
						var_19_1:x(var_19_1:x() - var_16_6)
					end

					arg_16_0:modifyItem(var_19_1:x() / var_16_0 + 1)
				end
			end
		end

		if var_17_3 then
			local var_17_7 = var_17_3:x()

			if var_16_12 == "left" and var_17_1 > var_17_7 + var_16_0 then
				local var_17_8 = arg_16_0.rewardScroll:getChildByName("reward" .. (var_16_11 == 0 and var_16_5 or var_16_11))
				local var_17_9 = (var_16_3 - var_17_8:x()) / var_16_0 - 1
				local var_17_10 = math.min(math.ceil((var_17_1 - (var_17_7 + var_16_0)) / var_16_0), var_17_9)

				var_17_5(var_16_12, var_17_10)
				var_17_6(var_17_10)

				var_16_13 = var_16_10
			elseif var_16_12 == "right" and var_17_2 < var_17_7 then
				local var_17_11 = arg_16_0.rewardScroll:getChildByName("reward" .. (var_16_10 == 0 and var_16_5 or var_16_10)):x() / var_16_0
				local var_17_12 = math.min(math.ceil((var_17_7 - var_16_0 - var_17_2) / var_16_0), var_17_11)

				var_17_5(var_16_12, var_17_12)
				var_17_6(var_17_12)

				var_16_13 = var_16_11
			end

			local var_17_13 = var_16_0 * arg_16_0.startHideLevel

			if arg_16_0.currentPassportLv < arg_16_0.startHideLevel and var_16_12 == "left" and var_17_2 >= var_17_13 - 1 then
				gGameUI:showTip(string.format(gLanguageCsv.upPasswordLevelToGet, arg_16_0.startHideLevel))
			end
		end
	end

	var_16_14()
	arg_16_0.rewardScroll:onEvent(function(arg_20_0)
		if arg_20_0.name == "CONTAINER_MOVED" then
			var_16_14()
		elseif arg_20_0.name == "SCROLLING_BEGAN" then
			arg_16_0:refreshNoClick(true)
		elseif arg_20_0.name == "AUTOSCROLL_ENDED" then
			arg_16_0:refreshNoClick(false)
		elseif arg_20_0.name == "SCROLLING_ENDED" then
			-- block empty
		end
	end)
end

function var_0_2.buildItem(arg_21_0)
	local var_21_0 = arg_21_0.curRewardIdx
	local var_21_1 = arg_21_0.curRewardIdx - 1 + arg_21_0.itemCreateNum

	if var_21_1 > arg_21_0.max then
		var_21_0 = var_21_0 - (var_21_1 - arg_21_0.max)
		var_21_1 = arg_21_0.max
	end

	for iter_21_0 = var_21_0, var_21_1 do
		arg_21_0:addItem(iter_21_0)
	end
end

function var_0_2.addItem(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0.awardCfg[arg_22_1]
	local var_22_1 = arg_22_0.rewardItem:clone()
	local var_22_2 = arg_22_1 % arg_22_0.itemCreateNum == 0 and arg_22_0.itemCreateNum or arg_22_1 % arg_22_0.itemCreateNum
	local var_22_3 = arg_22_0.rewardItem:width()
	local var_22_4 = (arg_22_1 - 1) * var_22_3

	var_22_1:xy(var_22_4, 0)
	arg_22_0:refreshRewardItem(var_22_1, arg_22_1)
	arg_22_0.rewardScroll:addChild(var_22_1, var_22_2, "reward" .. var_22_2)
	var_22_1:show()

	return var_22_1
end

function var_0_2.modifyItem(arg_23_0, arg_23_1)
	for iter_23_0 = 1, arg_23_0.itemCreateNum do
		local var_23_0 = arg_23_0.rewardScroll:getChildByName("reward" .. iter_23_0)

		if var_23_0:x() == (arg_23_1 - 1) * arg_23_0.rewardItem:width() then
			arg_23_0:refreshRewardItem(var_23_0, arg_23_1)
		end
	end
end

function var_0_2.refreshRewardItem(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0.awardCfg[arg_24_2]
	local var_24_1 = var_24_0.cfg.specialAward == 1
	local var_24_2 = arg_24_1:multiget("lv", "normalPanel", "highPanel1", "highPanel2", "topMask", "bottomMask", "btnGet", "noClick", "lv1")

	var_24_2.lv:text(string.format(gLanguageCsv["gamePassportItemText" .. arg_24_0.type], var_24_0.expNum))
	var_24_2.lv1:text("Lv." .. var_24_0.cfg.level)
	text.addEffect(var_24_2.lv, {
		outline = {
			size = 3,
			color = ui.NEWCOLORS.OUTLINE.YELLOW
		}
	})
	text.addEffect(var_24_2.lv1, {
		outline = {
			size = 3,
			color = ui.NEWCOLORS.OUTLINE.YELLOW
		}
	})

	local var_24_3 = {}

	for iter_24_0, iter_24_1 in csvMapPairs(var_24_0.cfg.normalAward) do
		var_24_3.key = iter_24_0
		var_24_3.num = iter_24_1
		var_24_3.state = var_24_0.custom.normalAwardState
	end

	arg_24_0:onBindIcon(arg_24_0.rewardScroll, var_24_2.normalPanel, var_24_3, var_24_1)

	local var_24_4 = {}

	for iter_24_2, iter_24_3 in csvMapPairs(var_24_0.cfg.eliteAward) do
		table.insert(var_24_4, {
			key = iter_24_2,
			num = iter_24_3,
			state = var_24_0.custom.eliteAwardState
		})
	end

	arg_24_0:onBindIcon(arg_24_0.rewardScroll, var_24_2.highPanel1, var_24_4[1], var_24_1)

	if var_24_4[2] then
		arg_24_0:onBindIcon(arg_24_0.rewardScroll, var_24_2.highPanel2, var_24_4[2], var_24_1)
		var_24_2.highPanel2:show()
	else
		var_24_2.highPanel2:hide()
	end

	var_24_2.btnGet:visible(var_24_0.custom.normalAwardState == 1 or var_24_0.custom.eliteAwardState == 1)
	var_24_2.lv:visible(var_24_0.custom.normalAwardState ~= 1 and var_24_0.custom.eliteAwardState ~= 1)
	var_24_2.lv1:visible(var_24_0.custom.normalAwardState ~= 1 and var_24_0.custom.eliteAwardState ~= 1)
	bind.touch(arg_24_0, var_24_2.btnGet, {
		methods = {
			ended = function(arg_25_0, arg_25_1, arg_25_2)
				arg_24_0:onBtnGetClick(var_24_0)
			end
		}
	})
	var_24_2.topMask:visible(arg_24_0.currentPassportLv < var_24_0.cfg.level)
	var_24_2.bottomMask:visible(arg_24_0.currentPassportLv < var_24_0.cfg.level or not arg_24_0.buyHigh)
	bind.click(arg_24_0, var_24_2.noClick, {
		method = function()
			arg_24_0:onRewardNoClick()
		end
	})
end

function var_0_2.onRewardNoClick(arg_27_0)
	arg_27_0:refreshNoClick(false)
end

function var_0_2.onBindIcon(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	bind.extend(arg_28_0, arg_28_2, {
		class = "icon_key",
		props = {
			data = arg_28_3,
			onNode = function(arg_29_0)
				arg_29_0:scale(0.9)

				local var_29_0 = arg_28_2:get("img")

				if var_29_0 then
					var_29_0:visible(arg_28_3.state == 0)
				else
					local var_29_1 = ccui.ImageView:create("common/icon/radio_selected.png"):addTo(arg_28_2, 1000, "img"):xy(140, 140):visible(arg_28_3.state == 0)
				end
			end
		}
	})

	local var_28_0 = arg_28_2:getChildByName("wupinshanguang")

	if var_28_0 then
		var_28_0:removeFromParent()
	end

	if arg_28_4 then
		widget.addAnimationByKey(arg_28_2, "wupinshanguang/saoguang.skel", "wupinshanguang", "effect_loop", 999):xy(arg_28_2:size().width / 2, arg_28_2:size().height / 2):scale(0.7)
	end
end

function var_0_2.jumpScroll(arg_30_0)
	local var_30_0 = arg_30_0.itemCreateNum
	local var_30_1 = arg_30_0.curRewardIdx % var_30_0 == 0 and var_30_0 or arg_30_0.curRewardIdx % var_30_0
	local var_30_2 = arg_30_0.rewardScroll:getChildByName("reward" .. var_30_1)

	if not var_30_2 then
		return
	end

	local var_30_3 = var_30_2:x()
	local var_30_4 = arg_30_0.rewardScroll:getInnerContainer():size()
	local var_30_5 = arg_30_0.rewardScroll:size().width
	local var_30_6 = cc.clampf(var_30_3 / (var_30_4.width - var_30_5) * 100, 0, 100)

	arg_30_0.rewardScroll:scrollToPercentHorizontal(var_30_6, 0.01, false)

	arg_30_0.percent = var_30_6
end

function var_0_2.resetScroll(arg_31_0)
	arg_31_0.rewardScroll:removeAllChildren()
	arg_31_0:buildScroll()
	arg_31_0:buildItem()
	arg_31_0:refreshNoClick(false)
	arg_31_0:jumpScroll()

	arg_31_0.isReset = false
end

function var_0_2.refreshTarget(arg_32_0)
	local var_32_0 = arg_32_0.awardCfg[arg_32_0.rigthRewardIndex]

	arg_32_0.target:getChildByName("lv"):text(string.format(gLanguageCsv["gamePassportItemText" .. arg_32_0.type], var_32_0.expNum))
	arg_32_0.target:getChildByName("lv1"):text("Lv." .. var_32_0.cfg.level)
	text.addEffect(arg_32_0.target:getChildByName("lv"), {
		outline = {
			size = 3,
			color = ui.NEWCOLORS.OUTLINE.YELLOW
		}
	})
	text.addEffect(arg_32_0.target:getChildByName("lv1"), {
		outline = {
			size = 3,
			color = ui.NEWCOLORS.OUTLINE.YELLOW
		}
	})

	if matchLanguage({
		"kr"
	}) then
		adapt.setTextAdaptWithSize(arg_32_0.target:getChildByName("lv"), {
			size = cc.size(228, 100)
		})
	end

	local var_32_1 = {}

	for iter_32_0, iter_32_1 in csvMapPairs(var_32_0.cfg.normalAward) do
		var_32_1.key = iter_32_0
		var_32_1.num = iter_32_1
		var_32_1.state = var_32_0.custom.normalAwardState
	end

	local var_32_2 = {}

	for iter_32_2, iter_32_3 in csvMapPairs(var_32_0.cfg.eliteAward) do
		table.insert(var_32_2, {
			key = iter_32_2,
			num = iter_32_3,
			state = var_32_0.custom.eliteAwardState
		})
	end

	arg_32_0:onBindIcon(arg_32_0.rewardScroll, arg_32_0.targetNormalPanel, var_32_1, true)
	arg_32_0:onBindIcon(arg_32_0.rewardScroll, arg_32_0.targetHighPanel1, var_32_2[1], true)

	if var_32_2[2] then
		arg_32_0:onBindIcon(arg_32_0.rewardScroll, arg_32_0.targetHighPanel2, var_32_2[2], true)
		arg_32_0.targetHighPanel2:show()
	else
		arg_32_0.targetHighPanel2:hide()
	end
end

function var_0_2.refreshNoClick(arg_33_0, arg_33_1)
	for iter_33_0 = 1, arg_33_0.itemCreateNum do
		arg_33_0.rewardScroll:getChildByName("reward" .. iter_33_0):getChildByName("noClick"):visible(arg_33_1)
	end

	arg_33_0.targetNoClick:visible(arg_33_1)
end

function var_0_2.updateTime(arg_34_0)
	local var_34_0 = gGameModel.role:read("yy_endtime")[arg_34_0.activityId] - time.getTime()

	bind.extend(arg_34_0, arg_34_0.rewardEndTime, {
		class = "cutdown_label",
		props = {
			time = var_34_0,
			endFunc = function()
				arg_34_0.rewardEndTime:text(gLanguageCsv.activityOver)
			end
		}
	})
end

return var_0_2
