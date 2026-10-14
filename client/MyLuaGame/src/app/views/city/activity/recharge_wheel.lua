local var_0_0 = 8
local var_0_1 = {
	free = "free",
	all = "all",
	once = "once"
}
local var_0_2 = {
	free = 2,
	all = 3,
	once = 2
}
local var_0_3 = 1
local var_0_4 = {
	free = 720,
	all = 3600,
	once = 720
}
local var_0_5 = {
	count = 1,
	report = 2
}

local function var_0_6(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_1.message
	local var_1_1 = dataEasy.getItemData(var_1_0[2])
	local var_1_2
	local var_1_3
	local var_1_4

	if var_1_1[1].key == "card" then
		var_1_2 = csv.cards[var_1_1[1].num.id]
		var_1_4 = 1
	else
		var_1_2 = dataEasy.getCfgByKey(var_1_1[1].key)
		var_1_4 = var_1_1[1].num
	end

	local var_1_5 = arg_1_0:get("message")
	local var_1_6 = arg_1_0:height() - var_1_5:height()
	local var_1_7 = string.format(gLanguageCsv.rechargeWheelReport, var_1_0[1], var_1_2.name, var_1_4)
	local var_1_8 = beauty.textScroll({
		isRich = true,
		size = cc.size(var_1_5:width(), arg_1_0:height()),
		strs = var_1_7,
		verticalSpace = var_1_6
	})
	local var_1_9 = 1

	if var_1_8:getInnerContainerSize().height > var_1_8:height() then
		var_1_9 = 2
	end

	if not arg_1_2 then
		return var_1_9
	end

	var_1_5:hide()
	var_1_8:height(var_1_8:getInnerContainerSize().height)
	arg_1_0:height(arg_1_0:height() * var_1_9)
	var_1_8:anchorPoint(0, 0.5):xy(0, arg_1_0:height() / 2):addTo(arg_1_0)
	var_1_8:setTouchEnabled(false)
end

local var_0_7 = 8
local var_0_8 = 20
local var_0_9 = class("ActivityRechargeWheelView", Dialog)

var_0_9.RESOURCE_FILENAME = "activity_recharge_wheel.json"
var_0_9.RESOURCE_BINDING = {
	["recordPanel.totalScore"] = "totalScore",
	["recordPanel.panel404"] = "panel404",
	["recordPanel.todayScore"] = "todayScore",
	["wheelPanel.wheel"] = "wheel",
	["recordPanel.refreshNode1"] = "refreshNode1",
	["recordPanel.refreshNode3"] = "refreshNode3",
	wheelPanel = "wheelPanel",
	showItem = "showItem",
	["recordPanel.costOneTitle"] = "costOneTitle",
	["recordPanel.costOneScore"] = "costOneScore",
	recordPanel = "recordPanel",
	["recordPanel.showPanel"] = "showPanel",
	["recordPanel.todayScoreMax"] = "todayScoreMax",
	["recordPanel.refreshNode2"] = "refreshNode2",
	["wheelPanel.btnSkip.icon"] = "skipIcon",
	["recordPanel.panel404.title404"] = "title404",
	["recordPanel.todayScoreSlash"] = "todayScoreSlash",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["wheelPanel.wheelTimeTitle"] = {
		varname = "wheelTimeTitle"
	},
	["wheelPanel.time"] = {
		varname = "wheelTime"
	},
	["wheelPanel.btnSkip"] = {
		binds = {
			event = "click",
			method = bindHelper.self("onSkip")
		}
	},
	["wheelPanel.btnRules"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRules")
			}
		}
	},
	["recordPanel.btnJumpToRecharge"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("jumpToRecharge")
			}
		}
	},
	["recordPanel.btnOneDraw"] = {
		varname = "btnOneDraw",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_2_0)
						arg_2_0:onDraw(var_0_1.once)
					end)
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "rechargeWheelFree",
					listenData = {
						activityId = bindHelper.self("activityId")
					}
				}
			}
		}
	},
	["recordPanel.btnAllDraw"] = {
		varname = "btnAllDraw",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_3_0)
					arg_3_0:onDraw(var_0_1.all)
				end)
			}
		}
	},
	["wheelPanel.wheelPointer"] = {
		varname = "wheelPointer",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_4_0)
					arg_4_0:onDraw(var_0_1.once)
				end)
			}
		}
	},
	["recordPanel.showPanel.showList1"] = {
		varname = "showList1",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("showData1"),
				item = bindHelper.self("showItem"),
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					var_0_6(arg_5_1, arg_5_3, true)
				end
			}
		}
	},
	["recordPanel.showPanel.showList2"] = {
		varname = "showList2",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("showData2"),
				item = bindHelper.self("showItem"),
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					var_0_6(arg_6_1, arg_6_3, true)
				end
			}
		}
	},
	["recordPanel.btnOneDraw.txtNode"] = {
		varname = "txtOneNode",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLUE
				}
			}
		}
	},
	["recordPanel.btnAllDraw.txtNode"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["recordPanel.btnJumpToRecharge.txtNode"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["wheelPanel.btnRules.txtSkipAni"] = {
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

function var_0_9.onCreate(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_2.view.recharge_wheel_message

	arg_7_0.yyCfg = csv.yunying.yyhuodong[arg_7_1]
	arg_7_0.activityId = arg_7_1
	arg_7_0.reportMessage = idlereasy.new(var_7_0 or {})

	arg_7_0:enableSchedule()
	adapt.setTextAdaptWithSize(arg_7_0.title404, {
		vertical = "center",
		horizontal = "center",
		size = cc.size(500, 200)
	})
	arg_7_0:initModel()
	arg_7_0:initReward()
	arg_7_0:initMyInfo()
	arg_7_0:initCountTime()
	arg_7_0:initSkipAni()
	arg_7_0:initReport()
	arg_7_0:initSkel()
	Dialog.onCreate(arg_7_0, {
		blackType = 1
	})
end

function var_0_9.initMyInfo(arg_8_0)
	local var_8_0 = arg_8_0.yyCfg.paramMap

	idlereasy.when(arg_8_0.yyhuodongs, function(arg_9_0, arg_9_1)
		local var_9_0 = arg_9_1[arg_8_0.activityId]

		if var_9_0 and var_9_0.info then
			local var_9_1 = var_9_0.info
			local var_9_2 = var_9_1.total_score or 0
			local var_9_3 = var_9_1.today_score or 0
			local var_9_4 = var_9_1.free_counter or 0

			arg_8_0.scoreDrawTimes = math.floor(var_9_2 / var_8_0.costScore)

			arg_8_0.totalScore:text(var_9_2)
			arg_8_0.todayScore:text(var_9_3)

			arg_8_0.freeDrawTimes = var_8_0.free - var_9_4
		else
			arg_8_0.totalScore:text(0)
			arg_8_0.todayScore:text(0)

			arg_8_0.freeDrawTimes = var_8_0.free
			arg_8_0.scoreDrawTimes = 0
		end

		if arg_8_0.freeDrawTimes > 0 then
			arg_8_0.costOneScore:text(0)
			arg_8_0.txtOneNode:text(gLanguageCsv.freeDraw)
		else
			arg_8_0.txtOneNode:text(gLanguageCsv.onceDraw)
			arg_8_0.costOneScore:text(var_8_0.costScore)
		end

		adapt.oneLinePos(arg_8_0.todayScore, {
			arg_8_0.todayScoreSlash,
			arg_8_0.todayScoreMax
		}, {
			cc.p(5, 0),
			cc.p(5, 0)
		}, "left")
		adapt.oneLineCenterPos(cc.p(arg_8_0.btnOneDraw:x(), arg_8_0.costOneTitle:y()), {
			arg_8_0.costOneTitle,
			arg_8_0.costOneScore
		}, cc.p(10, 0))
	end)
	arg_8_0.todayScoreMax:text(var_8_0.dailyScoreMax)
	arg_8_0.refreshNode1:visible(var_8_0.free > 0)
	arg_8_0.refreshNode2:visible(var_8_0.free > 0)
	arg_8_0.refreshNode3:visible(var_8_0.free > 0)

	local var_8_1 = rich.createByStr(string.format(gLanguageCsv.rechargeWheelTip, var_8_0.recharge, var_8_0.addScore), 40):anchorPoint(0, 0.5):xy(arg_8_0.totalScore:x() - 20, arg_8_0.totalScore:y() - 50):addTo(arg_8_0.recordPanel):z(10)

	var_8_1:ignoreContentAdaptWithSize(false)
	var_8_1:setContentSize(cc.size(720, 200))
end

function var_0_9.initModel(arg_10_0)
	arg_10_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_10_0.yyEndtime = gGameModel.role:getIdler("yy_endtime")
	arg_10_0.skipAni = gGameModel.currlogin_dispatch:getIdlerOrigin("rechargeWheelSkip")
end

function var_0_9.initReward(arg_11_0)
	arg_11_0.rewardDatas = {}

	for iter_11_0, iter_11_1 in csvMapPairs(arg_11_0.yyCfg.clientParam.awards) do
		local var_11_0, var_11_1 = csvNext(iter_11_1)

		table.insert(arg_11_0.rewardDatas, {
			key = var_11_0,
			num = var_11_1
		})
	end

	for iter_11_2 = 1, var_0_0 do
		local var_11_2 = arg_11_0.wheel:get("name" .. iter_11_2)
		local var_11_3 = arg_11_0.wheel:get("icon" .. iter_11_2)

		if var_11_2 then
			var_11_2:text("")

			local var_11_4 = arg_11_0.rewardDatas[iter_11_2]

			uiEasy.setIconName(var_11_4.key, var_11_4.num, {
				node = var_11_2
			})
			adapt.setTextAdaptWithSize(var_11_2, {
				vertical = "center",
				horizontal = "center",
				size = cc.size(260, 200)
			})

			local var_11_5 = true

			if var_11_4.key == "card" then
				var_11_5 = false
			end

			bind.extend(arg_11_0, var_11_3, {
				class = "icon_key",
				props = {
					data = var_11_4,
					simpleShow = var_11_5,
					onNode = function(arg_12_0)
						arg_12_0:scale(0.9)
					end
				}
			})
		end
	end
end

function var_0_9.initSkipAni(arg_13_0)
	idlereasy.when(arg_13_0.skipAni, function(arg_14_0, arg_14_1)
		local var_14_0 = arg_14_1 and "activity/recharge_wheel/btn_gou1.png" or "activity/recharge_wheel/btn_gou0.png"

		arg_13_0.skipIcon:texture(var_14_0)
	end)
end

function var_0_9.initCountTime(arg_15_0)
	local var_15_0 = arg_15_0.activityId
	local var_15_1 = var_0_5.count
	local var_15_2 = arg_15_0.yyEndtime:read()

	arg_15_0:unSchedule(var_15_1)

	local var_15_3 = 0

	if var_15_2[var_15_0] then
		var_15_3 = var_15_2[var_15_0] - time.getTime()
	end

	arg_15_0:schedule(function()
		var_15_3 = var_15_3 - 1

		arg_15_0.wheelTime:text(time.getCutDown(var_15_3, true).str)

		if var_15_3 <= 0 then
			arg_15_0:onClose()

			return false
		end
	end, 1, 0, var_15_1)
end

function var_0_9.jumpToRecharge(arg_17_0)
	jumpEasy.jumpTo("recharge")
end

function var_0_9.onDraw(arg_18_0, arg_18_1)
	if arg_18_0.freeDrawTimes <= 0 and arg_18_0.scoreDrawTimes <= 0 then
		gGameUI:showTip(gLanguageCsv.rechargeWheelScoreNotEnough)

		return
	end

	if arg_18_1 == var_0_1.once then
		if arg_18_0.freeDrawTimes > 0 then
			arg_18_1 = var_0_1.free
		end
	elseif arg_18_1 == var_0_1.all then
		-- block empty
	else
		printWarn("wrong type", arg_18_1)

		return
	end

	local var_18_0 = {
		false
	}

	gGameApp:requestServerCustom("/game/yy/award/draw"):params(arg_18_0.activityId, arg_18_1):onResponse(function(arg_19_0)
		local var_19_0 = 0
		local var_19_1 = 0
		local var_19_2 = 0

		if not arg_18_0.skipAni:read() then
			local var_19_3, var_19_4

			var_19_0, var_19_3, var_19_4 = arg_18_0:getAniParams(arg_18_1, arg_19_0)

			arg_18_0:wheelAni(var_19_0, var_19_3, var_19_4)

			if arg_18_1 == var_0_1.all then
				arg_18_0.wheelSkel:play("effect_shilianchou")
			else
				arg_18_0.wheelSkel:play("effect_chou")
			end
		end

		performWithDelay(arg_18_0, function()
			var_18_0[1] = true
		end, var_19_0)
	end):wait(var_18_0):doit(function(arg_21_0)
		gGameUI:showGainDisplay(arg_21_0)
		arg_18_0.wheelSkel:play("effect_loop")
		gGameApp:requestServer("/game/yy/active/get", function(arg_22_0)
			arg_18_0.reportMessage:set(arg_22_0.view.recharge_wheel_message)
		end)
	end)
end

function var_0_9.initReport(arg_23_0)
	idlereasy.when(arg_23_0.reportMessage, function(arg_24_0, arg_24_1)
		arg_23_0:showReport(arg_24_1)
	end)
end

function var_0_9.showReport(arg_25_0, arg_25_1)
	local var_25_0 = {}
	local var_25_1 = 0

	for iter_25_0, iter_25_1 in ipairs(arg_25_1) do
		local var_25_2 = var_0_6(arg_25_0.showItem, {
			message = iter_25_1
		}, false)

		var_25_1 = var_25_1 + var_25_2

		table.insert(var_25_0, {
			message = iter_25_1,
			lineNums = var_25_2
		})
	end

	local var_25_3 = {}
	local var_25_4 = {}
	local var_25_5 = itertools.size(var_25_0)

	if var_25_1 <= var_0_7 then
		var_25_3 = arraytools.first(var_25_0, var_25_5)
	else
		var_25_3 = arraytools.first(var_25_0, var_25_5)
		var_25_4 = arraytools.first(var_25_0, var_25_5)
	end

	arg_25_0.panel404:visible(var_25_1 == 0)

	if not arg_25_0.showData1 then
		arg_25_0.showData1 = idlers.newWithMap(var_25_3)
	else
		arg_25_0.showData1:update(var_25_3)
	end

	if not arg_25_0.showData2 then
		arg_25_0.showData2 = idlers.newWithMap(var_25_4)
	else
		arg_25_0.showData2:update(var_25_4)
	end

	local var_25_6 = 0
	local var_25_7 = 0
	local var_25_8 = arg_25_0.showItem:height()
	local var_25_9 = arg_25_0.showPanel:height()

	for iter_25_2, iter_25_3 in ipairs(var_25_3) do
		var_25_6 = var_25_6 + var_25_8 * iter_25_3.lineNums
	end

	for iter_25_4, iter_25_5 in ipairs(var_25_4) do
		var_25_7 = var_25_7 + var_25_8 * iter_25_5.lineNums
	end

	arg_25_0.showList1:height(var_25_6)
	arg_25_0.showList1:y(var_25_9 - var_25_6)
	arg_25_0.showList2:height(var_25_7)
	arg_25_0.showList2:y(var_25_9 - var_25_6 - var_25_7)

	if var_25_7 > 0 then
		local var_25_10 = var_0_5.report

		arg_25_0:unSchedule(4)
		arg_25_0:schedule(function()
			if arg_25_0.showList1:y() >= var_25_8 * var_0_7 then
				arg_25_0.showList1:y(arg_25_0.showList2:y() - arg_25_0.showList1:height())
			end

			if arg_25_0.showList2:y() >= var_25_8 * var_0_7 then
				arg_25_0.showList2:y(arg_25_0.showList1:y() - arg_25_0.showList2:height())
			end

			local var_26_0 = arg_25_0.showList1:y() + var_25_8
			local var_26_1 = arg_25_0.showList2:y() + var_25_8

			transition.executeSequence(arg_25_0.showList1):moveTo(0.1, 0, var_26_0):done()
			transition.executeSequence(arg_25_0.showList2):moveTo(0.1, 0, var_26_1):done()
		end, 1, 1, 4)
	end
end

function var_0_9.wheelAni(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	arg_27_0.wheel:setRotation(0)
	transition.executeSequence(arg_27_0.wheel, true):easeBegin("EXPONENTIALOUT"):rotateBy(arg_27_1 - var_0_3, arg_27_2 - arg_27_3):rotateBy(var_0_3, arg_27_3 + 360):easeEnd():done()
end

function var_0_9.onSkip(arg_28_0)
	arg_28_0.skipAni:modify(function(arg_29_0)
		return true, not arg_29_0
	end)
end

function var_0_9.getAniParams(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = var_0_2[arg_30_1]
	local var_30_1 = var_0_4[arg_30_1]
	local var_30_2 = dataEasy.mergeRawDate(arg_30_2)[1]
	local var_30_3
	local var_30_4
	local var_30_5

	for iter_30_0, iter_30_1 in ipairs(arg_30_0.rewardDatas) do
		if iter_30_1.key == var_30_2.key then
			if iter_30_1.num == var_30_2.num then
				var_30_3 = iter_30_0
			end

			if not var_30_5 then
				var_30_4 = iter_30_0
				var_30_5 = iter_30_1.num
			elseif var_30_5 > iter_30_1.num then
				var_30_4 = iter_30_0
				var_30_5 = iter_30_1.num
			end
		end
	end

	var_30_4 = var_30_4 or 1
	var_30_3 = var_30_3 or var_30_4

	local var_30_6 = (var_0_0 - var_30_3 + 1) / var_0_0 * 360
	local var_30_7 = var_30_1 + var_30_6

	return var_30_0, var_30_7, var_30_6
end

function var_0_9.initSkel(arg_31_0)
	arg_31_0.wheelSkel = widget.addAnimationByKey(arg_31_0.wheelPanel, "zhuanpan/zhuanpan.skel", "wheelSkel", "effect_loop", 2)

	arg_31_0.wheelSkel:anchorPoint(cc.p(0.5, 0.5)):xy(arg_31_0.wheelPointer:x() + 8, arg_31_0.wheelPointer:y() - 14):scale(2)
end

function var_0_9.onRules(arg_32_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_32_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_9.getRuleContext(arg_33_0, arg_33_1)
	local var_33_0 = adaptContext

	return {
		var_33_0.clone(arg_33_1.title, function(arg_34_0)
			arg_34_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_33_0.noteText(122),
		var_33_0.noteText(69001, 69008)
	}
end

return var_0_9
