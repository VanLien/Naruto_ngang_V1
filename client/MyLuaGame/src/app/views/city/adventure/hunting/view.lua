local var_0_0 = {
	elite = 2,
	normal = 1
}
local var_0_1 = {
	event = "effect",
	data = {
		outline = {
			size = 4,
			color = ui.NEWCOLORS.OUTLINE.BLACK
		}
	}
}
local var_0_2 = {
	event = "effect",
	data = {
		outline = {
			size = 4,
			color = ui.NEWCOLORS.OUTLINE.RED1
		}
	}
}
local var_0_3 = {
	event = "effect",
	data = {
		outline = {
			size = 4,
			color = ui.NEWCOLORS.OUTLINE.BLACK
		}
	}
}
local var_0_4 = cc.load("mvc").ViewBase
local var_0_5 = class("HuntingView", var_0_4)

var_0_5.RESOURCE_FILENAME = "hunting.json"
var_0_5.RESOURCE_BINDING = {
	["centerPanel.elitePanel.btnElite.lock"] = "eliteLock",
	leftBottomPanel = "leftBottomPanel",
	["centerPanel.normalPanel"] = "normalPanel",
	centerPanel = "centerPanel",
	bg = "bg",
	["centerPanel.elitePanel"] = "elitePanel",
	tip = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["centerPanel.normalPanel.btnNormal"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onNormalRouteClick")
			}
		}
	},
	["centerPanel.normalPanel.btnNormal.text"] = {
		binds = var_0_2
	},
	["centerPanel.normalPanel.playing.txt1"] = {
		binds = var_0_2
	},
	["centerPanel.normalPanel.playing.txt2"] = {
		binds = var_0_2
	},
	["centerPanel.elitePanel.btnElite"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onEliteRouteClick")
			}
		}
	},
	["centerPanel.elitePanel.btnElite.text"] = {
		binds = var_0_2
	},
	["centerPanel.elitePanel.playing.txt1"] = {
		binds = var_0_2
	},
	["centerPanel.elitePanel.playing.txt2"] = {
		binds = var_0_2
	},
	["leftBottomPanel.shopBtn.name"] = {
		binds = var_0_3
	},
	["leftBottomPanel.ruleBtn.name"] = {
		binds = var_0_3
	},
	["leftBottomPanel.ruleBtn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleClick")
			}
		}
	},
	["leftBottomPanel.shopBtn"] = {
		varname = "shopBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnShop")
			}
		}
	}
}

function var_0_5.onCreate(arg_1_0, arg_1_1)
	gGameUI.topuiManager:createView("hunting", arg_1_0, {
		onClose = arg_1_0:createHandler("onClose")
	}):init({
		subTitle = "HUNTINGAREA",
		title = "common/txt/txt_bt_renzheyuanzheng.png"
	})
	arg_1_0:initModel()

	local var_1_0 = csv.cross.hunting.base

	arg_1_0.specialHuntingSign = dataEasy.isUnlock(gUnlockCsv.specialHunting)

	idlereasy.any({
		arg_1_0.normalTimes,
		arg_1_0.eliteTimes,
		arg_1_0.routeInfo
	}, function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		arg_1_0:initPanel()

		arg_1_0.endTime1 = time.getNumTimestamp(arg_1_0.routeInfo:read()[var_0_0.normal].last_date, 5, 0, 0) + 86400 * var_1_0[var_0_0.normal].refreshDay

		if arg_1_0.specialHuntingSign then
			arg_1_0.endTime2 = time.getNumTimestamp(arg_1_0.routeInfo:read()[var_0_0.elite].last_date, 5, 0, 0) + 86400 * var_1_0[var_0_0.elite].refreshDay
		end
	end)
	arg_1_0:initCountDown1()

	if arg_1_0.specialHuntingSign then
		arg_1_0:initCountDown2()
	end

	performWithDelay(arg_1_0, function()
		if gGameUI.guideManager:isInGuiding() and arg_1_0.normalTimes:read() == 0 and arg_1_0.routeInfo:read()[var_0_0.normal].status == "closed" then
			gGameUI.guideManager:forceClose(nil, "city.adventure.hunting.view")
		end
	end, 0)
end

function var_0_5.initModel(arg_4_0)
	arg_4_0.normalTimes = gGameModel.hunting:getIdler("battle_times")
	arg_4_0.eliteTimes = gGameModel.hunting:getIdler("special_battle_times")
	arg_4_0.routeInfo = gGameModel.hunting:getIdler("hunting_route")

	arg_4_0.eliteLock:visible(not dataEasy.isUnlock(gUnlockCsv.specialHunting))
end

function var_0_5.initPanel(arg_5_0)
	local var_5_0 = csv.cross.hunting.base

	arg_5_0.normalPanel:get("playing"):visible(arg_5_0.routeInfo:read()[var_0_0.normal].status == "starting")

	local var_5_1 = arg_5_0.normalTimes:read() == 0 and "#C0xFC8628#" or "#C0x52D661#"
	local var_5_2 = string.format(gLanguageCsv.huntingTimes, var_5_1, arg_5_0.normalTimes:read(), var_5_0[var_0_0.normal].battleLimit)

	arg_5_0.normalPanel:get("times"):hide()
	arg_5_0.normalPanel:removeChildByName("richText")

	local var_5_3 = rich.createByStr(var_5_2, 56, nil):xy(210, arg_5_0.normalPanel:get("times"):y()):anchorPoint(0, 0.5):addTo(arg_5_0.normalPanel, 100, "richText"):formatText()

	arg_5_0.elitePanel:get("playing"):visible(arg_5_0.routeInfo:read()[var_0_0.elite].status == "starting")

	local var_5_4 = arg_5_0.eliteTimes:read() == 0 and "#C0xFC8628#" or "#C0x52D661#"
	local var_5_5 = string.format(gLanguageCsv.huntingTimes, var_5_4, arg_5_0.eliteTimes:read(), var_5_0[var_0_0.elite].battleLimit)

	if arg_5_0.specialHuntingSign then
		arg_5_0.elitePanel:get("times"):hide()
		arg_5_0.elitePanel:removeChildByName("richText")

		local var_5_6 = rich.createByStr(var_5_5, 56, nil):xy(210, arg_5_0.elitePanel:get("times"):y()):anchorPoint(0, 0.5):addTo(arg_5_0.elitePanel, 100, "richText"):formatText()
	else
		local var_5_7 = csv.unlock[gUnlockCsv.specialHunting]

		arg_5_0.elitePanel:get("times"):text(string.format(gLanguageCsv.huntingLimitTip, var_5_7.startLevel))

		local var_5_8, var_5_9 = arg_5_0.elitePanel:get("times"):xy()

		arg_5_0.elitePanel:get("times"):xy(var_5_8, var_5_9 - 20)
	end
end

function var_0_5.onNormalRouteClick(arg_6_0)
	if arg_6_0.routeInfo:read()[var_0_0.normal].status == "starting" then
		arg_6_0:startRoute(var_0_0.normal)
	elseif arg_6_0.normalTimes:read() <= 0 then
		gGameUI:showTip(gLanguageCsv.huntingGameTimesNotEnough)

		return
	else
		arg_6_0:startRoute(var_0_0.normal)
	end
end

function var_0_5.onEliteRouteClick(arg_7_0)
	if not arg_7_0.specialHuntingSign then
		gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.specialHunting))

		return
	elseif arg_7_0.routeInfo:read()[var_0_0.elite].status == "starting" then
		arg_7_0:startRoute(var_0_0.elite)
	elseif arg_7_0.eliteTimes:read() <= 0 then
		gGameUI:showTip(gLanguageCsv.huntingGameTimesNotEnough)

		return
	else
		arg_7_0:startRoute(var_0_0.elite)
	end
end

function var_0_5.startRoute(arg_8_0, arg_8_1)
	if arg_8_0.routeInfo:read()[arg_8_1].status == "closed" then
		gGameApp:requestServer("/game/hunting/route/begin", function(arg_9_0)
			gGameUI:stackUI("city.adventure.hunting.route", nil, nil, arg_8_1)
		end, arg_8_1)
	else
		gGameUI:stackUI("city.adventure.hunting.route", nil, nil, arg_8_1)
	end
end

function var_0_5.onBtnShop(arg_10_0)
	if not gGameUI:goBackInStackUI("city.shop") then
		gGameApp:requestServer("/game/fixshop/get", function(arg_11_0)
			gGameUI:stackUI("city.shop", nil, {
				full = true
			}, game.SHOP_INIT.HUNTING_SHOP)
		end)
	end
end

function var_0_5.onEquipClick(arg_12_0)
	return
end

function var_0_5.onRuleClick(arg_13_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_13_0:createHandler("getRuleContext"))
end

function var_0_5.getRuleContext(arg_14_0, arg_14_1)
	local var_14_0 = adaptContext

	return {
		var_14_0.clone(arg_14_1.title, function(arg_15_0)
			arg_15_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_14_0.noteText(124301, 124310)
	}
end

function var_0_5.initCountDown1(arg_16_0)
	local var_16_0 = csv.cross.hunting.base[var_0_0.normal].battleLimit

	local function var_16_1()
		arg_16_0.normalPanel:removeChildByName("richTextTime")

		if arg_16_0.normalTimes:read() >= var_16_0 then
			return true
		end

		local var_17_0 = string.format(gLanguageCsv.huntingReplyGameTimes, time.getCutDown(arg_16_0.endTime1 - time.getTime()).str)
		local var_17_1 = rich.createByStr(var_17_0, 40, nil):xy(330, 45):anchorPoint(0.5, 0.5):addTo(arg_16_0.normalPanel, 100, "richTextTime"):formatText()

		if arg_16_0.endTime1 - time.getTime() <= 0 then
			gGameApp:requestServer("/game/hunting/main", function(arg_18_0)
				return
			end)
		end

		return true
	end

	arg_16_0:enableSchedule()
	arg_16_0:schedule(function(arg_19_0)
		return var_16_1()
	end, 1, 0, 1)
end

function var_0_5.initCountDown2(arg_20_0)
	local var_20_0 = csv.cross.hunting.base[var_0_0.elite].battleLimit

	local function var_20_1()
		arg_20_0.elitePanel:removeChildByName("richTextTime")

		if arg_20_0.eliteTimes:read() >= var_20_0 then
			return true
		end

		local var_21_0 = string.format(gLanguageCsv.huntingReplyGameTimes, time.getCutDown(arg_20_0.endTime2 - time.getTime()).str)
		local var_21_1 = rich.createByStr(var_21_0, 40, nil):xy(330, 45):anchorPoint(0.5, 0.5):addTo(arg_20_0.elitePanel, 100, "richTextTime"):formatText()

		if arg_20_0.endTime2 - time.getTime() <= 0 then
			gGameApp:requestServer("/game/hunting/main", function(arg_22_0)
				return
			end)
		end

		return true
	end

	arg_20_0:enableSchedule()
	arg_20_0:schedule(function(arg_23_0)
		return var_20_1()
	end, 1, 0, 2)
end

return var_0_5
