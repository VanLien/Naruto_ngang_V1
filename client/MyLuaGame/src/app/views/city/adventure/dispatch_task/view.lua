local var_0_0 = require("app.views.city.adventure.dispatch_task.tools")
local var_0_1 = {
	"common/icon/icon_rarity1.png",
	"common/icon/icon_rarity2.png",
	"common/icon/icon_rarity3.png",
	"common/icon/icon_rarity4.png",
	"common/icon/icon_rarity5.png"
}
local var_0_2 = gCommonConfigCsv.dispatchTaskRefreshCostRMB
local var_0_3 = gCommonConfigCsv.dispatchTaskDoneAtOnceCostRMB
local var_0_4 = gCommonConfigCsv.dispatchTaskDoneAtOnceSecond

local function var_0_5(arg_1_0)
	local var_1_0 = ""
	local var_1_1 = time.getCutDown(arg_1_0 * 60)

	if var_1_1.day > 0 then
		var_1_0 = var_1_0 .. string.format(gLanguageCsv.day, var_1_1.day)
	end

	if var_1_1.hour > 0 then
		var_1_0 = var_1_0 .. string.format(gLanguageCsv.hour, var_1_1.hour)
	end

	if var_1_1.min > 0 then
		var_1_0 = var_1_0 .. string.format(gLanguageCsv.minute, var_1_1.min)
	end

	return var_1_0
end

local function var_0_6(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = arg_2_0:get("cost")

	if arg_2_3 then
		local var_2_1 = dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.DispatchTaskFreeRefreshTimes)

		arg_2_2 = string.format("%s(%s/%s)", gLanguageCsv.free, var_2_1 - arg_2_4, var_2_1)
	end

	var_2_0:text(arg_2_2)

	local var_2_2 = ui.COLORS.NORMAL.WHITE

	if arg_2_3 then
		var_2_2 = ui.NEWCOLORS.GREEN2
	elseif arg_2_1 < arg_2_2 then
		var_2_2 = ui.NEWCOLORS.REDLIGHT
	end

	text.addEffect(var_2_0, {
		color = var_2_2
	})
	adapt.oneLinePos(arg_2_0:get("costIcon"), {
		var_2_0,
		arg_2_0:get("costNote")
	}, cc.p(20, 0), "right")
	adapt.oneLinePos(arg_2_0:get("costNote"), {
		arg_2_0:get("taskNum"),
		arg_2_0:get("taskNumNote")
	}, {
		cc.p(80, 0),
		cc.p(5, 0)
	}, "right")
end

local function var_0_7(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_2.subTime

	arg_3_0:enableSchedule():schedule(function()
		var_3_0 = var_3_0 - 1

		if var_3_0 <= 0 then
			if arg_3_2.status == 3 then
				gGameApp:requestServer("/game/dispatch/task/refresh", nil, false)
				arg_3_1.btnReward:show()
				arg_3_1.imgCanGet:show()
				arg_3_1.btnComplete:hide()
				arg_3_1.timePanel:hide()
			end

			arg_3_0:unSchedule(arg_3_3)
		else
			arg_3_1.timePanel:get("textTime"):text(time.getCutDown(var_3_0).str)
		end
	end, 1, 0, "item" .. arg_3_3)
end

local function var_0_8(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0:get("effect")
	local var_5_1 = arg_5_0:size()
	local var_5_2 = arg_5_1 == 1 and "effect" or "effect" .. arg_5_1 - 1

	if not var_5_0 then
		var_5_0 = widget.addAnimationByKey(arg_5_0, "diban/diban.skel", "effect", var_5_2, -1):xy(var_5_1.width / 2 + 5, var_5_1.height / 2 + 20):scale(2)
	else
		var_5_0:play(var_5_2)
	end
end

local var_0_9 = class("DispatchTaskView", cc.load("mvc").ViewBase)

var_0_9.RESOURCE_FILENAME = "dispatch_task.json"
var_0_9.RESOURCE_BINDING = {
	item = "item",
	["bottomPanel.costIcon"] = "costIcon",
	bottomPanel = "bottomPanel",
	attrItem = "attrItem",
	["item.btnComplete.textNote"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				padding = 38,
				data = bindHelper.self("taskDatas"),
				item = bindHelper.self("item"),
				attrItem = bindHelper.self("attrItem"),
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					arg_6_1:stopAllActions()
					arg_6_1:removeChildByName("effect")
					arg_6_1:setName("item" .. arg_6_0:getIdx(arg_6_2))

					local var_6_0 = arg_6_0.attrItem
					local var_6_1 = arg_6_1:multiget("imgCanGet", "timePanel", "iconCompleted", "textTitle", "imgQuality", "timeNote", "time", "conditionPanel", "rewardPanel", "btnReward", "btnComplete", "timeNote")

					var_0_7(arg_6_0, var_6_1, arg_6_3, arg_6_2)
					var_0_0.setRewardPanel(arg_6_0, var_6_1.rewardPanel, arg_6_3.cfg.award, "icon", "main")
					var_0_0.setRewardPanel(arg_6_0, var_6_1.rewardPanel, arg_6_3.cfg.extraAward, "extraIcon", "main")
					var_0_0.setItemCondition(var_6_1.conditionPanel, arg_6_3, var_6_0, "main")
					var_6_1.textTitle:text(arg_6_3.cfg.name)
					var_6_1.imgQuality:texture(var_0_1[arg_6_3.quality])
					var_6_1.time:text(var_0_5(arg_6_3.cfg.duration))
					adapt.oneLinePos(var_6_1.timeNote, var_6_1.time)
					text.addEffect(var_6_1.btnReward:get("textNote"), {
						outline = {
							size = 4,
							color = ui.NEWCOLORS.OUTLINE.YELLOW
						},
						color = ui.COLORS.NORMAL.YELLOW
					})
					itertools.invoke(var_6_1, "hide")
					performWithDelay(arg_6_1, function()
						var_0_8(arg_6_1, arg_6_3.quality)

						local var_7_0 = arg_6_1:get("effect")

						var_7_0:setSpriteEventHandler(function(arg_8_0, arg_8_1)
							itertools.invoke(var_6_1, "show")
							var_6_1.imgCanGet:visible(arg_6_3.status == 1)
							var_6_1.iconCompleted:visible(arg_6_3.status == 4)
							var_6_1.btnReward:visible(arg_6_3.status == 1)
							var_6_1.btnComplete:visible(arg_6_3.status == 3)
							var_6_1.timePanel:visible(arg_6_3.status == 3)
							var_7_0:setSpriteEventHandler()
						end, sp.EventType.ANIMATION_COMPLETE)
					end, 0.2)
					performWithDelay(arg_6_1, function()
						var_6_1.btnReward:visible(arg_6_3.status == 1)
						var_6_1.btnComplete:visible(arg_6_3.status == 3)
					end, 0.5)
					bind.touch(arg_6_0, arg_6_1, {
						methods = {
							ended = functools.partial(arg_6_0.clickCell, arg_6_2, arg_6_3)
						}
					})
					bind.touch(arg_6_0, var_6_1.btnReward, {
						methods = {
							ended = functools.partial(arg_6_0.btnReward, arg_6_2, arg_6_3)
						}
					})
					bind.touch(arg_6_0, var_6_1.btnComplete, {
						methods = {
							ended = functools.partial(arg_6_0.btnComplete, arg_6_2, arg_6_3)
						}
					})
				end,
				onAfterBuild = function(arg_10_0)
					arg_10_0.afterBuild()
				end
			},
			handlers = {
				afterBuild = bindHelper.self("onAfterBuild"),
				clickCell = bindHelper.self("onItemClick"),
				btnReward = bindHelper.self("onBtnReward"),
				btnComplete = bindHelper.self("onBtnComplete")
			}
		}
	},
	["bottomPanel.btn"] = {
		varname = "bottomBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRefresh")
			}
		}
	},
	["bottomPanel.btn.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["bottomPanel.costNote"] = {
		varname = "costNote"
	},
	["bottomPanel.cost"] = {
		varname = "cost"
	},
	["bottomPanel.taskNumNote"] = {
		varname = "taskNumNote"
	},
	["bottomPanel.taskNum"] = {
		varname = "taskNum"
	},
	["bottomPanel.taskTimeNote"] = {
		varname = "taskTimeNote"
	},
	["bottomPanel.taskTime"] = {
		varname = "taskTime"
	}
}

function var_0_9.onCreate(arg_11_0, arg_11_1)
	arg_11_0:initModel()
	gGameUI.topuiManager:createView("default", arg_11_0, {
		onClose = arg_11_0:createHandler("onClose")
	}):init({
		subTitle = "SEND",
		title = "common/txt/txt_bt_paiqian.png"
	})
	adapt.centerWithScreen({
		"left",
		nil,
		false
	}, {
		"right",
		nil,
		false
	}, nil, {
		{
			arg_11_0.taskTimeNote,
			"pos",
			"left"
		},
		{
			arg_11_0.taskTime,
			"pos",
			"left"
		},
		{
			arg_11_0.taskNum,
			"pos",
			"right"
		},
		{
			arg_11_0.taskNumNote,
			"pos",
			"right"
		},
		{
			arg_11_0.cost,
			"pos",
			"right"
		},
		{
			arg_11_0.costNote,
			"pos",
			"right"
		},
		{
			arg_11_0.costIcon,
			"pos",
			"right"
		},
		{
			arg_11_0.bottomBtn,
			"pos",
			"right"
		},
		{
			arg_11_0.list,
			"width"
		},
		{
			arg_11_0.list,
			"pos",
			"left"
		}
	})
	arg_11_0.item:get("conditionPanel.attrList"):setScrollBarEnabled(false)
	adapt.oneLinePos(arg_11_0.item:get("conditionPanel.extraCondition2"), arg_11_0.item:get("conditionPanel.attrList"))

	arg_11_0.taskDatas = idlertable.new({})
	arg_11_0.accessibleNum = idler.new(0)

	idlereasy.any({
		arg_11_0.dispatchTasks,
		arg_11_0.vipLevel
	}, function(arg_12_0, arg_12_1, arg_12_2)
		local var_12_0 = time.getTime()
		local var_12_1 = time.getTimeTable()
		local var_12_2

		if var_12_1.hour < 5 then
			var_12_2 = 4 - var_12_1.hour
		elseif var_12_1.hour >= 18 then
			var_12_2 = 28 - var_12_1.hour
		else
			var_12_2 = 17 - var_12_1.hour
		end

		local var_12_3 = var_12_0 + var_12_2 * 3600 + (59 - var_12_1.min) * 60 + (59 - var_12_1.sec) + 1

		gGameModel.forever_dispatch:getIdlerOrigin("dispatchTasksNextAutoTime"):set(var_12_3)

		arg_11_0.canGetNum = 0
		arg_11_0.selectIdx = 1

		local var_12_4 = {}
		local var_12_5 = 0
		local var_12_6 = 0

		for iter_12_0, iter_12_1 in ipairs(arg_12_1) do
			local var_12_7 = csv.dispatch_task.tasks[iter_12_1.csvID]
			local var_12_8 = iter_12_1.status
			local var_12_9 = (iter_12_1.ending_time or 0) - time.getTime()

			if var_12_8 == 1 then
				var_12_8 = 4
			end

			if var_12_8 == 3 and var_12_9 <= 0 then
				var_12_8 = 1
			end

			if var_12_8 == 2 then
				var_12_5 = var_12_5 + 1
			end

			if var_12_8 == 1 then
				var_12_6 = var_12_6 + 1
			end

			table.insert(var_12_4, {
				dbid = iter_12_0,
				csvID = iter_12_1.csvID,
				fightingPoint = iter_12_1.fighting_point,
				status = var_12_8,
				cardIDs = iter_12_1.cardIDs or {},
				endingTime = iter_12_1.ending_time,
				subTime = var_12_9,
				extraAwardPoint = iter_12_1.extra_award_point or 0,
				cfg = var_12_7,
				quality = var_12_7.quality,
				taskData = iter_12_1
			})
		end

		arg_11_0.accessibleNum:set(var_12_5)

		arg_11_0.canGetNum = var_12_6

		arg_11_0.bottomPanel:get("taskNum"):text(var_12_5 .. "/" .. gVipCsv[arg_12_2].dispatchTaskCount)

		local var_12_10 = var_12_5 == 0 and ui.COLORS.NORMAL.WHITE or ui.NEWCOLORS.GREEN2

		text.addEffect(arg_11_0.bottomPanel:get("taskNum"), {
			color = var_12_10
		})
		table.sort(var_12_4, function(arg_13_0, arg_13_1)
			if arg_13_0.status ~= arg_13_1.status then
				return arg_13_0.status < arg_13_1.status
			end

			return arg_13_0.quality > arg_13_1.quality
		end)

		if arg_11_0.showAcceptPos then
			for iter_12_2, iter_12_3 in ipairs(var_12_4) do
				if iter_12_3.status == 2 then
					arg_11_0.selectIdx = iter_12_2 + 1

					break
				end
			end
		end

		arg_11_0.taskDatas:set(var_12_4)
	end)
	idlereasy.any({
		arg_11_0.rmb,
		arg_11_0.accessibleNum,
		arg_11_0.freeRefreshTimes
	}, function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
		local var_14_0 = arg_14_3 < dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.DispatchTaskFreeRefreshTimes)

		arg_11_0.costIcon:visible(not var_14_0)
		var_0_6(arg_11_0.bottomPanel, arg_14_1, arg_14_2 * var_0_2, var_14_0, arg_14_3)
	end)
	var_0_9.setRefreshTime(arg_11_0, arg_11_0.taskTime, {
		tag = "DispatchTaskView",
		sendGameProtocol = true,
		cb = function()
			arg_11_0.showAcceptPos = true
		end
	})
end

function var_0_9.initModel(arg_16_0)
	arg_16_0.dispatchTasks = gGameModel.role:getIdler("dispatch_tasks")
	arg_16_0.rmb = gGameModel.role:getIdler("rmb")
	arg_16_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_16_0.last_time = gGameModel.role:getIdler("dispatch_task_last_time")
	arg_16_0.freeRefreshTimes = gGameModel.daily_record:getIdler("dispatch_refresh_free_times")
end

function var_0_9.onItemClick(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	arg_17_0.showAcceptPos = true

	local var_17_0 = (arg_17_3.endingTime or 0) - time.getTime()

	if arg_17_3.status == 3 and var_17_0 > 0 then
		gGameUI:showTip(gLanguageCsv.currentTaskDispatched)

		return
	end

	if arg_17_3.status == 4 then
		gGameUI:showTip(gLanguageCsv.currentTaskCompleted)

		return
	end

	if arg_17_3.status ~= 2 then
		return
	end

	if arg_17_0.canGetNum >= 24 then
		gGameUI:showTip(gLanguageCsv.pleaseCollectCompletedReward)

		return
	end

	gGameUI:stackUI("city.adventure.dispatch_task.sprite_select", nil, {
		full = true
	}, arg_17_3)
end

function var_0_9.onBtnReward(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	arg_18_0.showAcceptPos = false

	gGameApp:requestServer("/game/dispatch/task/award", function(arg_19_0)
		gGameUI:showGainDisplay(arg_19_0)
	end, arg_18_3.dbid, false)
end

function var_0_9.onBtnComplete(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	arg_20_0.showAcceptPos = false

	local var_20_0 = math.max(math.ceil(arg_20_3.subTime / var_0_4) - 1, 0) * var_0_3

	gGameUI:stackUI("city.develop.talent.reset", nil, {
		clickClose = true
	}, {
		from = "dispatch_task",
		typ = "end",
		cost = var_20_0,
		title = gLanguageCsv.tips,
		txt1 = gLanguageCsv.consumptionOrNot,
		txt2 = gLanguageCsv.completeTheTaskImmediately,
		requestParams = {
			arg_20_3.dbid,
			true
		},
		cb = arg_20_0:createHandler("onBtnCompleteCb")
	})
end

function var_0_9.onBtnCompleteCb(arg_21_0, arg_21_1)
	gGameUI:showGainDisplay(arg_21_1)
end

function var_0_9.onRefresh(arg_22_0)
	local var_22_0 = dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.DispatchTaskFreeRefreshTimes)

	if arg_22_0.accessibleNum:read() <= 0 then
		gGameUI:showTip(gLanguageCsv.currentlyNoTasksRefresh)

		return
	end

	if var_22_0 > arg_22_0.freeRefreshTimes:read() then
		arg_22_0.showAcceptPos = true

		gGameApp:requestServer("/game/dispatch/task/refresh", nil, true)

		return
	end

	if arg_22_0.accessibleNum:read() * var_0_2 > arg_22_0.rmb:read() then
		gGameUI:showTip(gLanguageCsv.yuanzhengShopRefreshRMBNotEnough)

		return
	end

	arg_22_0.showAcceptPos = true

	gGameUI:stackUI("city.develop.talent.reset", nil, {
		clickClose = true
	}, {
		from = "dispatch_task",
		cost = arg_22_0.accessibleNum:read() * var_0_2,
		title = gLanguageCsv.tips,
		txt1 = gLanguageCsv.consumptionOrNot,
		txt2 = gLanguageCsv.refreshTaskQuality
	})
end

function var_0_9.onSortCards(arg_23_0, arg_23_1)
	return function(arg_24_0, arg_24_1)
		if arg_24_0.status ~= arg_24_1.status then
			return arg_24_0.status < arg_24_1.status
		end

		return arg_24_0.quality > arg_24_1.quality
	end
end

function var_0_9.onAfterBuild(arg_25_0)
	if arg_25_0.selectIdx ~= nil then
		arg_25_0.list:jumpToItem(arg_25_0.selectIdx, cc.p(1, 0), cc.p(1, 0))
	end
end

function var_0_9.setRefreshTime(arg_26_0, arg_26_1, arg_26_2)
	arg_26_0:enableSchedule():schedule(function()
		local var_27_0 = time.getTimeTable()
		local var_27_1

		if var_27_0.hour < 5 then
			var_27_1 = 4 - var_27_0.hour
		elseif var_27_0.hour >= 18 then
			var_27_1 = 28 - var_27_0.hour
		else
			var_27_1 = 17 - var_27_0.hour
		end

		if (var_27_0.hour == 5 or var_27_0.hour == 18) and var_27_0.min == 0 and var_27_0.sec == 0 then
			if arg_26_2.cb then
				arg_26_2.cb()
			end

			if arg_26_2.sendGameProtocol then
				gGameApp:requestServer("/game/dispatch/task/refresh", nil, false)
			end
		end

		if arg_26_1 then
			local var_27_2 = string.format("%02d:%02d:%02d", var_27_1, 59 - var_27_0.min, 59 - var_27_0.sec)

			arg_26_1:text(var_27_2)
		end
	end, 1, 0, arg_26_2.flag)
end

return var_0_9
