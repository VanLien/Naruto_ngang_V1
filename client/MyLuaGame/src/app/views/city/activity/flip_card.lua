local var_0_0 = {
	finished = 2,
	unfinished = 1
}
local var_0_1 = {
	covered = 1,
	gain = 2
}
local var_0_2 = {}
local var_0_3 = 4
local var_0_4 = 16
local var_0_5 = 8
local var_0_6 = class("ActivityFlipCardView", Dialog)

var_0_6.RESOURCE_FILENAME = "activity_flip_card.json"
var_0_6.RESOURCE_BINDING = {
	["rightPanel.dailyTimes"] = "dailyTimes",
	["rightPanel.textChallenge"] = "textChallenge",
	["rightPanel.itemTask"] = "itemTask",
	["leftPanel.list2"] = "subList",
	["leftPanel.item"] = "itemSmall",
	icon = "iconTJ",
	["rightPanel.itemTJHX"] = "itemTJHX",
	coverPanel = "coverPanel",
	["rightPanel.noneItem"] = "noneItem",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["bg.text"] = {
		binds = var_0_2
	},
	["leftPanel.time"] = {
		varname = "time",
		binds = var_0_2
	},
	["leftPanel.time1"] = {
		varname = "timeText",
		binds = var_0_2
	},
	["leftPanel.freeTextSy"] = {
		varname = "freeTextSy",
		binds = var_0_2
	},
	["leftPanel.text"] = {
		varname = "text",
		binds = var_0_2
	},
	["leftPanel.freeTextNum"] = {
		varname = "freeTextNum",
		binds = var_0_2
	},
	["rightPanel.taskTextNum"] = {
		varname = "taskTextNum",
		binds = var_0_2
	},
	["rightPanel.taskText"] = {
		varname = "taskText",
		binds = var_0_2
	},
	["coverPanel.finish"] = {
		varname = "finishText",
		binds = var_0_2
	},
	["leftPanel.btnRule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRules")
			}
		}
	},
	["coverPanel.btnNextRound"] = {
		varname = "btnNextRound",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onNextRound")
			}
		}
	},
	["rightPanel.listHX"] = {
		varname = "listHX",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("itemDatas"),
				item = bindHelper.self("itemTJHX"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					bind.extend(arg_1_0, arg_1_1, {
						class = "icon_key",
						props = {
							data = {
								key = arg_1_3.key,
								num = arg_1_3.num
							}
						}
					})
				end
			}
		}
	},
	["rightPanel.taskList"] = {
		varname = "taskList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("teskDatas"),
				item = bindHelper.self("itemTask"),
				dataOrderCmp = function(arg_2_0, arg_2_1)
					if arg_2_0.state ~= arg_2_1.state then
						return arg_2_0.state < arg_2_1.state
					end

					return arg_2_0.csvId < arg_2_1.csvId
				end,
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:multiget("text", "textNum1", "finish", "go", "bar")

					var_3_0.text:text(arg_3_3.text)
					var_3_0.textNum1:text("+" .. arg_3_3.award)

					if arg_3_3.state == var_0_0.finished then
						var_3_0.go:visible(false)
						var_3_0.bar:visible(false)
						var_3_0.finish:visible(true)
					else
						if arg_3_3.jumpTo == "" then
							var_3_0.go:visible(false)
						else
							var_3_0.go:visible(true)
							bind.touch(arg_3_0, arg_3_1, {
								methods = {
									ended = functools.partial(arg_3_0.clickCell, arg_3_3.jumpTo)
								}
							})
						end

						var_3_0.bar:visible(true)
						var_3_0.finish:visible(false)
						var_3_0.bar:text(arg_3_3.cnt .. "/" .. arg_3_3.taskTimes)
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onJump")
			}
		}
	},
	["leftPanel.list"] = {
		varname = "listCenter",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				preloadCenter = 5,
				data = bindHelper.self("showdata"),
				columnSize = var_0_3,
				item = bindHelper.self("subList"),
				cell = bindHelper.self("itemSmall"),
				onCell = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					if arg_4_3.isSelected == true then
						local var_4_0 = arg_4_0:getIdx(arg_4_2)
						local var_4_1 = arg_4_1:multiget("bg", "itemPanel")

						;({})[arg_4_3.key] = arg_4_3.num

						arg_4_1:get("itemPanel"):visible(false)
						gGameUI:disableTouchDispatch(nil, false)
						arg_4_1:runAction(cc.Sequence:create(cc.CallFunc:create(function()
							var_4_1.bg:texture(arg_4_3.res)
							var_4_1.bg:visible(true)
							var_4_1.itemPanel:visible(false)
						end), cc.ScaleTo:create(0.3, 0.01, 1), cc.CallFunc:create(function()
							var_4_1.bg:visible(false)
						end), bind.extend(arg_4_0, var_4_1.itemPanel, {
							class = "icon_key",
							props = {
								data = {
									key = arg_4_3.key,
									num = arg_4_3.num or 0
								},
								onNode = function(arg_7_0)
									arg_7_0:scale(1.1)
								end
							}
						}), cc.CallFunc:create(function()
							var_4_1.itemPanel:visible(true)
							widget.addAnimation(arg_4_1, "xingyunlefantian/fanpai_gy.skel", "effect", 20):xy(107, 107)
						end), cc.ScaleTo:create(0.1, 1, 1)))
						var_4_1.bg:visible(false)
					elseif arg_4_3.state == var_0_1.covered then
						arg_4_1:get("bg"):texture(arg_4_3.res)

						local var_4_2 = arg_4_0:getIdx(arg_4_2)

						arg_4_1:get("itemPanel"):setTouchEnabled(false)
						bind.touch(arg_4_0, arg_4_1, {
							methods = {
								ended = functools.partial(arg_4_0.clickGet, arg_4_1, var_4_2.k)
							}
						})
					elseif arg_4_3.state == var_0_1.gain and arg_4_3.isSelected ~= true then
						local var_4_3 = arg_4_1:multiget("bg", "itemPanel")

						var_4_3.bg:visible(false)
						bind.extend(arg_4_0, var_4_3.itemPanel, {
							class = "icon_key",
							props = {
								data = {
									key = arg_4_3.key,
									num = arg_4_3.num
								},
								onNode = function(arg_9_0)
									arg_9_0:scale(1.1)
								end
							}
						})
					end
				end
			},
			handlers = {
				clickGet = bindHelper.self("flipCard")
			}
		}
	}
}

function var_0_6.onCreate(arg_10_0, arg_10_1)
	arg_10_0:initModel()

	local var_10_0 = csv.yunying.yyhuodong[arg_10_1]
	local var_10_1 = var_10_0.huodongID

	arg_10_0.huodongID = var_10_1
	arg_10_0.yyCfg = var_10_0
	arg_10_0.cloneIcon = nil
	arg_10_0.activityId = arg_10_1
	arg_10_0.teskDatas = idlers.new()
	arg_10_0.itemDatas = idlers.newWithMap({})
	arg_10_0.showdata = idlers.newWithMap({})

	local var_10_2 = 0

	for iter_10_0, iter_10_1 in csvPairs(csv.yunying.flop_rounds) do
		if iter_10_1.huodongID == var_10_1 and iter_10_1.type == 1 then
			var_10_2 = var_10_2 + 1
		end
	end

	arg_10_0.roundMax = var_10_2
	arg_10_0.lastRoundId = (arg_10_0.yyhuodongs:read()[arg_10_1] or {}).info.roundID

	arg_10_0:updateTime()
	idlereasy.when(arg_10_0.yyhuodongs, function(arg_11_0, arg_11_1)
		local var_11_0 = arg_11_1[arg_10_1] or {}

		arg_10_0.yyData = var_11_0

		arg_10_0:updateFirstAward()

		local var_11_1 = {}
		local var_11_2 = 0

		if arg_10_0.yyData.info.roundID + var_0_5 > arg_10_0.roundMax then
			var_11_2 = arg_10_0.roundMax
		else
			var_11_2 = arg_10_0.yyData.info.roundID + var_0_5
		end

		for iter_11_0 = var_11_0.info.roundID + 1, var_11_2 do
			for iter_11_1, iter_11_2 in csvPairs(csv.yunying.flop_rounds) do
				if iter_11_2.type == 1 and iter_11_2.huodongID == var_10_1 then
					for iter_11_3, iter_11_4 in csvMapPairs(iter_11_2.rounds) do
						if iter_11_4 == iter_11_0 then
							local var_11_3, var_11_4 = next(iter_11_2.award)

							table.insert(var_11_1, {
								id = iter_11_0,
								key = var_11_3,
								num = var_11_4
							})
						end
					end
				end
			end
		end

		arg_10_0.itemTask:visible(false)

		if arg_10_0.lastRoundId == var_11_0.info.roundID then
			arg_10_0.itemDatas:update(var_11_1)
		end

		arg_10_0.noneItem:visible(false)

		if #var_11_1 == 0 and arg_10_0.lastRoundId == var_11_0.info.roundID then
			arg_10_0.noneItem:visible(true)
		end

		arg_10_0:updateTask()
		arg_10_0:updateFlipCard()
		arg_10_0.itemSmall:visible(false)
		arg_10_0.listCenter:xy(335, 60)
		arg_10_0:gameOver()
	end)
	Dialog.onCreate(arg_10_0)
end

function var_0_6.initModel(arg_12_0)
	arg_12_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_12_0.rmb = gGameModel.role:getIdler("rmb")
	arg_12_0.clickId = idler.new(0)
end

function var_0_6.onRules(arg_13_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_13_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_6.getRuleContext(arg_14_0, arg_14_1)
	local var_14_0 = adaptContext

	return {
		var_14_0.clone(arg_14_1.title, function(arg_15_0)
			arg_15_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_14_0.noteText(149),
		var_14_0.noteText(104001, 104010)
	}
end

function var_0_6.flipCard(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	arg_16_0.id = arg_16_3

	if arg_16_0.freeTextNum:text() == "0" and arg_16_0.taskTextNum:text() == "0" then
		gGameUI:showTip(gLanguageCsv.flipCardNoTimes)

		return
	end

	gGameApp:requestServer("/game/yy/award/get", function(arg_17_0)
		performWithDelay(arg_16_0, function()
			gGameUI:disableTouchDispatch(nil, true)
			gGameUI:showGainDisplay(arg_17_0)
		end, 1)

		for iter_17_0 = 1, var_0_4 do
			arg_16_0.detail[iter_17_0].isSelected = false
		end

		local var_17_0 = dataEasy.getItemData(arg_17_0.view.result)[1]

		arg_16_0.detail[arg_16_3] = {
			isSelected = true,
			id = arg_16_3,
			key = var_17_0.key,
			num = var_17_0.num,
			state = var_0_1.gain,
			res = arg_16_0.yyCfg.clientParam.res .. arg_16_3 .. ".png"
		}

		arg_16_0.showdata:update(arg_16_0.detail)

		arg_16_0.lastRoundId = arg_16_0.yyData.info.roundID
	end, arg_16_0.activityId, arg_16_0.huodongID, arg_16_3)
end

function var_0_6.onJump(arg_19_0, arg_19_1, arg_19_2)
	if arg_19_2 ~= nil then
		jumpEasy.jumpTo(arg_19_2)
	end
end

function var_0_6.updateTime(arg_20_0)
	local var_20_0 = gGameModel.role:read("yy_endtime")[arg_20_0.activityId] - time.getTime()

	bind.extend(arg_20_0, arg_20_0.time, {
		class = "cutdown_label",
		props = {
			time = var_20_0,
			endFunc = function()
				arg_20_0:gameOver()
				arg_20_0.time:text(gLanguageCsv.activityOver)
			end
		}
	})
end

function var_0_6.updateFirstAward(arg_22_0)
	if arg_22_0.lastRoundId == arg_22_0.yyData.info.roundID then
		for iter_22_0, iter_22_1 in orderCsvPairs(csv.yunying.flop_rounds) do
			if iter_22_1.huodongID == arg_22_0.huodongID and iter_22_1.type == 1 then
				local var_22_0, var_22_1 = next(iter_22_1.rounds)

				if var_22_1 == arg_22_0.yyData.info.roundID then
					if arg_22_0.cloneIcon then
						arg_22_0.cloneIcon:removeFromParent()

						arg_22_0.cloneIcon = nil
					end

					arg_22_0.cloneIcon = arg_22_0.iconTJ:clone():addTo(arg_22_0.iconTJ:getParent())

					arg_22_0.cloneIcon:xy(arg_22_0.iconTJ:xy())
					bind.extend(arg_22_0, arg_22_0.cloneIcon, {
						class = "icon_key",
						props = {
							data = dataEasy.getItemData(iter_22_1.award)[1]
						}
					})

					if arg_22_0.lastRoundId == 0 and arg_22_0.lastRoundId == arg_22_0.yyData.info.roundID - 1 then
						arg_22_0.bigAward = iter_22_1.award
					elseif arg_22_0.lastRoundId == arg_22_0.yyData.info.roundID then
						arg_22_0.bigAward = iter_22_1.award
					end

					return
				end
			end
		end
	end
end

function var_0_6.updateSecondAward(arg_23_0)
	local var_23_0 = {}
	local var_23_1 = 0

	if arg_23_0.yyData.info.roundID + var_0_5 > arg_23_0.roundMax then
		var_23_1 = arg_23_0.roundMax
	else
		var_23_1 = arg_23_0.yyData.info.roundID + var_0_5
	end

	for iter_23_0 = arg_23_0.yyData.info.roundID + 1, var_23_1 do
		for iter_23_1, iter_23_2 in csvPairs(csv.yunying.flop_rounds) do
			if iter_23_2.type == 1 and iter_23_2.huodongID == arg_23_0.huodongID then
				for iter_23_3, iter_23_4 in csvMapPairs(iter_23_2.rounds) do
					local var_23_2, var_23_3 = next(iter_23_2.award)

					if iter_23_4 == iter_23_0 then
						local var_23_4 = dataEasy.getItemData(iter_23_2.award)[1]

						table.insert(var_23_0, {
							id = iter_23_0,
							key = var_23_2,
							num = var_23_3
						})
					end
				end
			end
		end
	end

	arg_23_0.itemDatas:update(var_23_0)
end

function var_0_6.updateTask(arg_24_0)
	arg_24_0.freeTextNum:text(arg_24_0.yyCfg.paramMap.free - arg_24_0.yyData.info.cost_free_times)
	adapt.oneLinePos(arg_24_0.freeTextSy, {
		arg_24_0.freeTextNum,
		arg_24_0.text
	}, {
		cc.p(5, 0),
		cc.p(10, 0)
	})
	arg_24_0.taskTextNum:text(arg_24_0.yyData.info.task_times - arg_24_0.yyData.info.cost_task_times)
	adapt.oneLinePos(arg_24_0.taskText, arg_24_0.taskTextNum, cc.p(3, 0))

	local var_24_0 = "#C0xFFFFFF#(" .. gLanguageCsv.dailyTaskTimes .. "#C0x36AB27#"
	local var_24_1 = {}
	local var_24_2 = gGameModel.role:getYYHuoDongTasksProgress(arg_24_0.activityId) or {}
	local var_24_3 = arg_24_0.yyData.valinfo or {}
	local var_24_4 = 0
	local var_24_5 = 0

	for iter_24_0, iter_24_1 in csvPairs(csv.yunying.flop_task) do
		if iter_24_1.huodongID == arg_24_0.huodongID then
			local var_24_6 = var_0_0.unfinished
			local var_24_7 = var_24_2[iter_24_0][1] or 0
			local var_24_8 = var_24_3[iter_24_0] and var_24_3[iter_24_0].count or 0
			local var_24_9 = iter_24_1.taskParam

			var_24_4 = var_24_4 + iter_24_1.times
			var_24_5 = var_24_5 + var_24_8

			if iter_24_1.times > 1 then
				var_24_9 = iter_24_1.times

				if var_24_9 <= var_24_8 then
					var_24_6 = var_0_0.finished
				end

				var_24_7 = var_24_8
			end

			if iter_24_1.times == 1 and var_24_9 <= var_24_7 then
				var_24_6 = var_0_0.finished
			end

			table.insert(var_24_1, {
				csvId = iter_24_0,
				text = iter_24_1.desc,
				award = iter_24_1.award,
				jumpTo = iter_24_1.jumpTo,
				taskTimes = var_24_9,
				state = var_24_6,
				cnt = var_24_7
			})
		end
	end

	arg_24_0.teskDatas:update(var_24_1)

	local var_24_10 = var_24_0 .. var_24_5 .. "/" .. "#C0xFFFFFF#" .. var_24_4 .. ")"

	arg_24_0.dailyTimes:removeChildByName("richText")

	local var_24_11 = rich.createWithWidth(var_24_10, 40, nil, 1100):xy(-20, 15):anchorPoint(0, 0.5):addTo(arg_24_0.dailyTimes, 1, "richText")
end

function var_0_6.gameOver(arg_25_0)
	if arg_25_0.yyData.info.roundID > arg_25_0.roundMax and arg_25_0.lastRoundId == arg_25_0.roundMax then
		performWithDelay(arg_25_0, function()
			arg_25_0.coverPanel:visible(true)
			bind.click(arg_25_0, arg_25_0.coverPanel, {
				method = function()
					gGameUI:showTip(gLanguageCsv.flipCardFinishedClickTip)
				end
			})
			arg_25_0.taskList:setTouchEnabled(false)

			for iter_26_0, iter_26_1 in pairs(arg_25_0.taskList:getChildren()) do
				iter_26_1:setTouchEnabled(false)
			end

			arg_25_0.btnNextRound:visible(false)
			arg_25_0.noneItem:visible(true)
			arg_25_0.finishText:text(gLanguageCsv.flipCardFinished)
		end, 1)
	end

	if arg_25_0.yyData.info.roundID > arg_25_0.roundMax and arg_25_0.lastRoundId == arg_25_0.yyData.info.roundID then
		arg_25_0.coverPanel:visible(true)
		bind.click(arg_25_0, arg_25_0.coverPanel, {
			method = function()
				gGameUI:showTip(gLanguageCsv.flipCardFinishedClickTip)
			end
		})
		arg_25_0.noneItem:visible(true)
		arg_25_0.btnNextRound:visible(false)
		arg_25_0.finishText:text(gLanguageCsv.flipCardFinished)
		arg_25_0.taskList:visible(false)
		arg_25_0.textChallenge:visible(false)
		arg_25_0.dailyTimes:visible(false)
		arg_25_0.taskTextNum:visible(false)
		arg_25_0.taskText:visible(false)
		arg_25_0.freeTextNum:visible(false)
		arg_25_0.freeTextSy:visible(false)
		arg_25_0.text:visible(false)
	end
end

function var_0_6.onNextRound(arg_29_0)
	local var_29_0 = {}

	for iter_29_0 = 1, var_0_4 do
		var_29_0[iter_29_0] = {
			isSelected = false,
			id = iter_29_0,
			state = var_0_1.covered,
			res = arg_29_0.yyCfg.clientParam.res .. iter_29_0 .. ".png"
		}
	end

	arg_29_0.coverPanel:visible(false)
	arg_29_0.showdata:update(var_29_0)

	arg_29_0.detail = var_29_0

	arg_29_0:updateFirstAward()
	arg_29_0:updateSecondAward()
end

function var_0_6.updateFlipCard(arg_30_0)
	local var_30_0 = {}

	for iter_30_0 = 1, var_0_4 do
		if arg_30_0.yyData.info.roundID <= arg_30_0.roundMax then
			if arg_30_0.yyData.stamps and arg_30_0.yyData.stamps[iter_30_0] ~= nil then
				for iter_30_1, iter_30_2 in csvPairs(csv.yunying.flop_rounds) do
					if iter_30_2.huodongID == arg_30_0.huodongID and iter_30_1 == arg_30_0.yyData.stamps[iter_30_0] then
						for iter_30_3, iter_30_4 in csvMapPairs(iter_30_2.award) do
							var_30_0[iter_30_0] = {
								id = iter_30_0,
								key = iter_30_3,
								num = iter_30_4,
								state = var_0_1.gain,
								res = arg_30_0.yyCfg.clientParam.res .. iter_30_0 .. ".png"
							}
						end
					end
				end
			else
				var_30_0[iter_30_0] = {
					id = iter_30_0,
					state = var_0_1.covered,
					res = arg_30_0.yyCfg.clientParam.res .. iter_30_0 .. ".png"
				}
			end
		else
			var_30_0[iter_30_0] = {
				id = iter_30_0,
				state = var_0_1.covered,
				res = arg_30_0.yyCfg.clientParam.res .. iter_30_0 .. ".png"
			}
		end
	end

	if arg_30_0.lastRoundId == arg_30_0.yyData.info.roundID and arg_30_0.yyData.info.roundID <= arg_30_0.roundMax then
		arg_30_0.showdata:update(var_30_0)

		arg_30_0.detail = var_30_0

		arg_30_0.coverPanel:visible(false)
	elseif arg_30_0.lastRoundId < arg_30_0.yyData.info.roundID and arg_30_0.yyData.info.roundID == arg_30_0.roundMax then
		performWithDelay(arg_30_0, function()
			arg_30_0.coverPanel:visible(true)
			arg_30_0.btnNextRound:visible(true)
		end, 1)
	elseif arg_30_0.lastRoundId < arg_30_0.yyData.info.roundID and arg_30_0.yyData.info.roundID < arg_30_0.roundMax then
		performWithDelay(arg_30_0, function()
			arg_30_0.coverPanel:visible(true)
			arg_30_0.btnNextRound:visible(true)
		end, 1)
	elseif arg_30_0.lastRoundId == arg_30_0.yyData.info.roundID and arg_30_0.yyData.info.roundID > arg_30_0.roundMax then
		arg_30_0.showdata:update(var_30_0)

		arg_30_0.detail = var_30_0
	end
end

return var_0_6
