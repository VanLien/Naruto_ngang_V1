local var_0_0 = 10
local var_0_1 = {
	free = "liveness_wheel_free1",
	five = "liveness_wheel5",
	once = "liveness_wheel1"
}
local var_0_2 = 1
local var_0_3 = 34
local var_0_4 = {
	count = 1,
	wheel = 2
}
local var_0_5 = {
	stage3Nums = 3,
	dt = 0.1,
	stage1Time = 0.5,
	stage2Time = 0.1,
	stage3Time = 0.5,
	showTime = 0.5,
	stage1Nums = 3,
	stage2Nums = var_0_0 * 2
}
local var_0_6 = class("ActivityLivenessWheelView", Dialog)

var_0_6.RESOURCE_FILENAME = "activity_liveness_wheel.json"
var_0_6.RESOURCE_BINDING = {
	selected = "selectedItem",
	["taskPanel.todayGetTitle"] = "todayGetTitle",
	["taskPanel.todayGetTotal"] = "todayGetTotal",
	taskPanel = "taskPanel",
	["taskPanel.todayGetTimes"] = "todayGetTimes",
	wheelPanel = "wheelPanel",
	["btnSkip.icon"] = "skipIcon",
	taskItem = "taskItem",
	time = "wheelTime",
	["wheelPanel.lessNums"] = "lessNums",
	["btnOnceDraw.freeIcon"] = "onceFreeIcon",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnSkip = {
		binds = {
			event = "click",
			method = bindHelper.self("onSkip")
		}
	},
	["taskPanel.taskList"] = {
		varname = "taskList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("taskDatas"),
				item = bindHelper.self("taskItem"),
				margin = var_0_3,
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("content", "curState", "totalState")

					var_1_0.content:text(arg_1_3.cfg.desc)
					var_1_0.curState:text(arg_1_3.progress[1])
					var_1_0.totalState:text("/" .. arg_1_3.progress[2])

					if arg_1_3.state == 1 then
						var_1_0.curState:hide()
						var_1_0.totalState:text(gLanguageCsv.complete)
						var_1_0.totalState:setTextColor(cc.c3b(66, 167, 56))
					end

					adapt.oneLinePos(var_1_0.totalState, var_1_0.curState, cc.p(0, 0), "right")
				end
			}
		}
	},
	btnOnceDraw = {
		varname = "btnOnceDraw",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_2_0)
					arg_2_0:onDraw(var_0_1.once)
				end)
			}
		}
	},
	["btnOnceDraw.txtNode"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.BLUE
				}
			}
		}
	},
	btnFiveDraw = {
		varname = "btnFiveDraw",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_3_0)
					arg_3_0:onDraw(var_0_1.five)
				end)
			}
		}
	},
	["btnFiveDraw.txtNode"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.ORANGE
				}
			}
		}
	},
	btnRules = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRules")
			}
		}
	}
}

function var_0_6.onCreate(arg_4_0, arg_4_1)
	arg_4_0.yyCfg = csv.yunying.yyhuodong[arg_4_1]
	arg_4_0.activityId = arg_4_1

	arg_4_0:enableSchedule()
	arg_4_0:initModel()
	arg_4_0:initReward()
	arg_4_0:initData()
	arg_4_0:initCountTime()
	arg_4_0:initSkipAni()
	arg_4_0:initSkel()
	arg_4_0:setSelectedReward(1)
	Dialog.onCreate(arg_4_0, {
		blackType = 1
	})
end

function var_0_6.initModel(arg_5_0)
	arg_5_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_5_0.yyEndtime = gGameModel.role:getIdler("yy_endtime")
	arg_5_0.skipAni = gGameModel.currlogin_dispatch:getIdlerOrigin("livenessWheelSkip")
end

function var_0_6.initReward(arg_6_0)
	arg_6_0.rewardDatas = {}

	for iter_6_0, iter_6_1 in csvMapPairs(arg_6_0.yyCfg.clientParam.awards) do
		local var_6_0, var_6_1 = csvNext(iter_6_1)

		table.insert(arg_6_0.rewardDatas, {
			key = var_6_0,
			num = var_6_1
		})
	end

	for iter_6_2 = 1, var_0_0 do
		local var_6_2 = arg_6_0.wheelPanel:get("reward" .. iter_6_2)

		if var_6_2 then
			local var_6_3 = var_6_2:multiget("name", "icon", "num", "numBg", "normal")
			local var_6_4 = arg_6_0.rewardDatas[iter_6_2]
			local var_6_5, var_6_6 = uiEasy.setIconName(var_6_4.key, var_6_4.num, {
				node = var_6_3.name
			})

			var_6_3.name:hide()

			local var_6_7 = beauty.singleTextLimitWord(var_6_3.name:text(), {
				fontSize = var_6_3.name:getFontSize()
			}, {
				width = 240
			}):xy(var_6_3.name:xy()):addTo(var_6_2, var_6_3.name:z()):color(var_6_6.color)
			local var_6_8 = true
			local var_6_9 = {
				key = var_6_4.key
			}

			if var_6_4.key == "card" then
				var_6_8 = false
				var_6_9 = var_6_4

				var_6_3.num:hide()
				var_6_3.numBg:hide()
			else
				var_6_3.num:text(var_6_4.num)

				if string.utf8len(var_6_4.num) > 2 then
					var_6_3.numBg:width(var_6_3.num:width() + 18)
				end

				var_6_3.num:x(var_6_3.numBg:x() - var_6_3.numBg:width() / 2 + var_6_3.num:width() / 2)
			end

			bind.extend(arg_6_0, var_6_3.icon, {
				class = "icon_key",
				props = {
					data = var_6_9,
					simpleShow = var_6_8,
					onNode = function(arg_7_0)
						arg_7_0:scale(0.8)
					end
				}
			})
		end
	end
end

function var_0_6.initData(arg_8_0)
	local var_8_0 = arg_8_0.yyCfg.paramMap

	arg_8_0.taskDatas = idlers.newWithMap({})

	idlereasy.when(arg_8_0.yyhuodongs, function(arg_9_0, arg_9_1)
		local var_9_0 = arg_9_1[arg_8_0.activityId] or {}
		local var_9_1 = var_9_0.info or {}
		local var_9_2 = var_9_1.free_counter or 0
		local var_9_3 = var_9_1.gain_times or 0

		arg_8_0.drawTimes = var_9_1.total_times or 0
		arg_8_0.freeDrawTimes = var_0_2 - var_9_2

		arg_8_0.lessNums:text(arg_8_0.drawTimes)
		arg_8_0.onceFreeIcon:visible(arg_8_0.freeDrawTimes > 0)
		arg_8_0.todayGetTimes:text(math.min(var_9_3, var_8_0.maxGainTimes))

		local var_9_4 = arg_8_0.yyCfg.huodongID

		if var_9_0 then
			local var_9_5 = var_9_0.stamps or {}
			local var_9_6 = gGameModel.role:getYYHuoDongTasksProgress(arg_8_0.activityId) or {}
			local var_9_7 = {}

			for iter_9_0, iter_9_1 in csvPairs(csv.yunying.generaltask) do
				if iter_9_1.huodongID == var_9_4 then
					table.insert(var_9_7, {
						csvId = iter_9_0,
						cfg = iter_9_1,
						state = var_9_5[iter_9_0],
						progress = var_9_6[iter_9_0]
					})
				end
			end

			arg_8_0.taskDatas:update(var_9_7)
		end
	end)
	arg_8_0.todayGetTotal:text("/" .. var_8_0.maxGainTimes .. ")")
	adapt.oneLineCenterPos(cc.p(arg_8_0.taskPanel:width() / 2, arg_8_0.todayGetTitle:y()), {
		arg_8_0.todayGetTitle,
		arg_8_0.todayGetTimes,
		arg_8_0.todayGetTotal
	})
end

function var_0_6.initSkipAni(arg_10_0)
	idlereasy.when(arg_10_0.skipAni, function(arg_11_0, arg_11_1)
		local var_11_0 = arg_11_1 and "activity/liveness_wheel/radio_selected.png" or "activity/liveness_wheel/radio_normal.png"

		arg_10_0.skipIcon:texture(var_11_0)
	end)
end

function var_0_6.initCountTime(arg_12_0)
	local var_12_0 = arg_12_0.activityId
	local var_12_1 = var_0_4.count
	local var_12_2 = arg_12_0.yyEndtime:read()

	arg_12_0:unSchedule(var_12_1)

	local var_12_3 = 0

	if var_12_2[var_12_0] then
		var_12_3 = var_12_2[var_12_0] - time.getTime()
	end

	bind.extend(arg_12_0, arg_12_0.wheelTime, {
		class = "cutdown_label",
		props = {
			tag = var_12_1,
			time = var_12_3,
			endFunc = function()
				arg_12_0:onClose()
			end
		}
	})
end

function var_0_6.onDraw(arg_14_0, arg_14_1)
	if arg_14_1 == var_0_1.once then
		if arg_14_0.freeDrawTimes <= 0 and arg_14_0.drawTimes <= 0 then
			gGameUI:showTip(gLanguageCsv.livenessWheelTimesNotEnough)

			return
		end

		if arg_14_0.freeDrawTimes > 0 then
			arg_14_1 = var_0_1.free
		end
	elseif arg_14_1 == var_0_1.five and arg_14_0.drawTimes < 5 then
		gGameUI:showTip(gLanguageCsv.livenessWheelTimesNotEnough)

		return
	end

	local var_14_0 = {
		false
	}

	gGameApp:requestServerCustom("/game/yy/award/draw"):params(arg_14_0.activityId, arg_14_1):onResponse(function(arg_15_0)
		local var_15_0 = 0
		local var_15_1 = 1

		if not arg_14_0.skipAni:read() then
			local var_15_2

			var_15_2, var_15_0 = arg_14_0:getAniParams(arg_14_1, arg_15_0)

			arg_14_0:wheelAni(var_15_2)
		end

		performWithDelay(arg_14_0, function()
			var_14_0[1] = true
		end, var_15_0)
	end):wait(var_14_0):doit(function(arg_17_0)
		gGameUI:showGainDisplay(arg_17_0)
		arg_14_0.wheelSkel:play("effect_loop")
	end)
end

function var_0_6.wheelAni(arg_18_0, arg_18_1)
	arg_18_0.wheelSkel:play("effect")

	local var_18_0 = var_0_5.dt
	local var_18_1 = var_0_5.stage1Nums
	local var_18_2 = var_0_5.stage3Nums
	local var_18_3 = var_0_5.stage2Nums + arg_18_1 - (var_0_5.stage1Nums + var_0_5.stage3Nums) - 1
	local var_18_4 = var_0_5.stage1Time
	local var_18_5 = var_0_5.stage2Time
	local var_18_6 = var_0_5.stage3Time

	arg_18_0:unSchedule(var_0_4.wheel)

	local var_18_7 = 0
	local var_18_8 = 1
	local var_18_9 = var_18_1 * var_18_4 / var_18_0
	local var_18_10 = var_18_3 * var_18_5 / var_18_0
	local var_18_11 = var_18_2 * var_18_6 / var_18_0

	arg_18_0:setSelectedReward(var_18_8)
	arg_18_0:schedule(function(arg_19_0)
		var_18_7 = var_18_7 + 1

		local var_19_0 = false
		local var_19_1 = 0
		local var_19_2 = 1

		if var_18_7 <= var_18_9 then
			var_19_2 = var_18_4 / var_18_0
			var_19_1 = var_18_7
		elseif var_18_7 > var_18_9 and var_18_7 <= var_18_9 + var_18_10 then
			var_19_2 = var_18_5 / var_18_0
			var_19_1 = var_18_7 - var_18_9
		elseif var_18_7 > var_18_9 + var_18_10 and var_18_7 <= var_18_9 + var_18_10 + var_18_11 then
			var_19_2 = var_18_6 / var_18_0
			var_19_1 = var_18_7 - var_18_9 - var_18_10
		else
			arg_18_0:unSchedule(var_0_4.wheel)
		end

		if var_18_7 <= var_18_9 + var_18_10 + var_18_11 then
			var_19_0 = var_19_1 / var_19_2 == math.floor(var_19_1 / var_19_2)
		end

		if var_19_0 then
			var_18_8 = var_18_8 + 1

			if var_18_8 > var_0_0 then
				var_18_8 = 1
			end

			arg_18_0:setSelectedReward(var_18_8)
		end
	end, var_18_0, var_18_0, var_0_4.wheel)
end

function var_0_6.onSkip(arg_20_0)
	arg_20_0.skipAni:modify(function(arg_21_0)
		return true, not arg_21_0
	end)
end

function var_0_6.getAniParams(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = dataEasy.mergeRawDate(arg_22_2)[1]
	local var_22_1
	local var_22_2
	local var_22_3

	for iter_22_0, iter_22_1 in ipairs(arg_22_0.rewardDatas) do
		if iter_22_1.key == var_22_0.key then
			if iter_22_1.num == var_22_0.num then
				var_22_1 = iter_22_0
			end

			if not var_22_3 then
				var_22_2 = iter_22_0
				var_22_3 = iter_22_1.num
			elseif var_22_3 > iter_22_1.num then
				var_22_2 = iter_22_0
				var_22_3 = iter_22_1.num
			end
		end
	end

	var_22_2 = var_22_2 or 1
	var_22_1 = var_22_1 or var_22_2

	local var_22_4 = var_0_5.dt * (var_0_5.stage2Nums + var_22_1 - (var_0_5.stage1Nums + var_0_5.stage3Nums)) + var_0_5.stage1Time * var_0_5.stage1Nums + var_0_5.stage3Time * var_0_5.stage3Nums + var_0_5.showTime

	return var_22_1, var_22_4
end

function var_0_6.initSkel(arg_23_0)
	local var_23_0 = arg_23_0:getResourceNode()

	arg_23_0.wheelSkel = widget.addAnimationByKey(var_23_0, "huoyueduobao/huoyueduobao.skel", "wheelSkel", "effect_loop", 2)

	arg_23_0.wheelSkel:anchorPoint(cc.p(0.5, 0.5)):xy(display.sizeInView.width / 2, display.sizeInView.height / 2 + 15):scale(2)

	arg_23_0.selectedSkel = widget.addAnimationByKey(arg_23_0.wheelPanel, "huoyueduobao/huoyueduobao.skel", "selectedSkel", "effect_kuang_loop", 10)

	arg_23_0.selectedSkel:anchorPoint(cc.p(0.5, 0.5)):xy(arg_23_0.wheelPanel:get("reward1"):x(), arg_23_0.wheelPanel:get("reward1"):y()):scale(2)
end

function var_0_6.onRules(arg_24_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_24_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_6.getRuleContext(arg_25_0, arg_25_1)
	local var_25_0 = adaptContext

	return {
		var_25_0.clone(arg_25_1.title, function(arg_26_0)
			arg_26_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_25_0.noteText(121),
		var_25_0.noteText(68001, 68006)
	}
end

function var_0_6.setSelectedReward(arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0.selectedItem:clone()

	var_27_0:show()

	if arg_27_0.wheelSelected then
		arg_27_0.wheelSelected:removeFromParent()
	end

	arg_27_0.wheelSelected = var_27_0

	arg_27_0.wheelSelected:addTo(arg_27_0.wheelPanel:get("reward" .. arg_27_1), 1):xy(arg_27_0.selectedItem:width() / 2, arg_27_0.selectedItem:height() / 2)
	arg_27_0.selectedSkel:xy(arg_27_0.wheelPanel:get("reward" .. arg_27_1):x(), arg_27_0.wheelPanel:get("reward" .. arg_27_1):y())
end

return var_0_6
