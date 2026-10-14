local var_0_0 = {
	finished = 1,
	geted = 0,
	unfinished = 0.5
}
local var_0_1 = {
	covered = 1,
	gain = 2
}
local var_0_2 = {
	event = "effect",
	data = {
		outline = {
			size = 3,
			color = cc.c4b(130, 33, 30, 255)
		}
	}
}
local var_0_3 = {
	notGet = 1,
	get = 2
}
local var_0_4 = 4
local var_0_5 = 16
local var_0_6 = class("ActivityNewYearFlipCardView", Dialog)

var_0_6.RESOURCE_FILENAME = "activity_new_year_flip_card.json"
var_0_6.RESOURCE_BINDING = {
	["leftPanel.item"] = "itemSmall",
	["rightPanel.itemTask"] = "itemTask",
	leftPanel = "leftPanel",
	["leftPanel.list2"] = "subList",
	coverPanel = "coverPanel",
	rightPanel = "rightPanel",
	["bg.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["leftPanel.rulePanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRules")
			}
		}
	},
	["rightPanel.taskText"] = {
		varname = "taskText",
		binds = var_0_2
	},
	["rightPanel.taskTextNum"] = {
		varname = "taskTextNum",
		binds = var_0_2
	},
	["rightPanel.taskBar"] = {
		varname = "taskBar",
		binds = var_0_2
	},
	["rightPanel.title"] = {
		varname = "title",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 8,
					color = cc.c4b(255, 248, 230, 255)
				}
			}
		}
	},
	["rightPanel.title1"] = {
		varname = "title1",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 8,
					color = cc.c4b(255, 248, 230, 255)
				}
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
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("text", "icon", "itemList", "btn", "downIcon", "textBar")

					bind.touch(arg_1_0, var_1_0.btn, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3)
						}
					})
					uiEasy.createItemsToList(arg_1_0, var_1_0.itemList, arg_1_3.award, {
						scale = 0.75,
						margin = 6
					})
					text.addEffect(var_1_0.icon:get("num"), {
						outline = {
							size = 3,
							color = cc.c4b(130, 33, 30, 255)
						}
					})
					var_1_0.icon:get("num"):text(arg_1_3.id)
					var_1_0.text:text(arg_1_3.text)
					var_1_0.downIcon:visible(arg_1_3.state == var_0_0.geted)
					var_1_0.textBar:visible(arg_1_3.state ~= var_0_0.geted)
					var_1_0.btn:visible(arg_1_3.state ~= var_0_0.geted)
					var_1_0.textBar:text(arg_1_3.num .. "/" .. arg_1_3.allNum)

					if arg_1_3.state == var_0_0.finished then
						text.addEffect(var_1_0.textBar, {
							color = cc.c4b(96, 196, 86, 255)
						})
						var_1_0.btn:get("text"):text(gLanguageCsv.commonTextGet)
					elseif arg_1_3.jumpTo == "" then
						var_1_0.btn:hide()
						var_1_0.textBar:y(100)
					else
						var_1_0.btn:get("text"):text(gLanguageCsv.goTo)
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
				margin = 0,
				preloadCenter = 5,
				data = bindHelper.self("showdata"),
				columnSize = var_0_4,
				item = bindHelper.self("subList"),
				cell = bindHelper.self("itemSmall"),
				onCell = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					bind.touch(arg_2_0, arg_2_1, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_3)
						}
					})

					local var_2_0 = arg_2_1:multiget("bg", "bg1", "frame")

					var_2_0.bg1:texture(arg_2_3.res)
					var_2_0.bg:get("num"):text(arg_2_3.id)
					var_2_0.frame:visible(arg_2_3.isFrame)
					text.addEffect(var_2_0.bg:get("num"), {
						outline = {
							size = 3,
							color = cc.c4b(130, 33, 30, 255)
						}
					})

					if arg_2_3.isSelected == true and arg_2_3.state ~= var_0_1.covered then
						local var_2_1 = arg_2_0:getIdx(arg_2_2)

						var_2_0.bg1:visible(false)
						gGameUI:disableTouchDispatch(nil, false)
						arg_2_1:runAction(cc.Sequence:create(cc.CallFunc:create(function()
							var_2_0.bg:visible(true)
							var_2_0.bg1:visible(false)
						end), cc.ScaleTo:create(0.3, 0.01, 1), cc.CallFunc:create(function()
							var_2_0.bg:visible(false)
						end), cc.CallFunc:create(function()
							var_2_0.bg:visible(false)
							var_2_0.bg1:visible(true)
						end), cc.ScaleTo:create(0.1, 1, 1)))
						var_2_0.bg:visible(false)
					elseif arg_2_3.state == var_0_1.covered then
						var_2_0.bg1:show()
						var_2_0.bg:hide()
						arg_2_1:setTouchEnabled(false)
					else
						arg_2_1:setTouchEnabled(true)
						var_2_0.bg:show()
						var_2_0.bg1:hide()
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("getTaskNum")
			}
		}
	}
}

function var_0_6.onCreate(arg_6_0, arg_6_1)
	arg_6_0:initModel()

	arg_6_0.yyCfg = csv.yunying.yyhuodong[arg_6_1]
	arg_6_0.huodongID = arg_6_0.yyCfg.huodongID
	arg_6_0.activityId = arg_6_1
	arg_6_0.teskDatas = idlers.new()
	arg_6_0.showdata = idlers.newWithMap({})
	arg_6_0.taskData = csv.yunying.jifu_task

	local var_6_0 = csv.yunying.jifu_award
	local var_6_1 = {}

	for iter_6_0, iter_6_1 in csvMapPairs(arg_6_0.yyCfg.paramMap.maxAward) do
		if iter_6_0 == "cards" then
			for iter_6_2, iter_6_3 in ipairs(iter_6_1) do
				table.insert(var_6_1, {
					key = "card",
					num = iter_6_3
				})
			end
		else
			table.insert(var_6_1, {
				key = iter_6_0,
				num = iter_6_1
			})
		end
	end

	for iter_6_4 = 1, 4 do
		if var_6_1[iter_6_4].key == "card" then
			bind.extend(arg_6_0, arg_6_0.rightPanel:get("itemBg" .. iter_6_4), {
				class = "icon_key",
				props = {
					data = var_6_1[iter_6_4],
					onNode = function(arg_7_0)
						arg_7_0:scale(0.6)
					end
				}
			})
		else
			bind.extend(arg_6_0, arg_6_0.rightPanel:get("itemBg" .. iter_6_4), {
				class = "icon_key",
				props = {
					simpleShow = true,
					data = {
						key = var_6_1[iter_6_4].key
					},
					onNode = function(arg_8_0)
						arg_8_0:scale(0.8)
					end
				}
			})
		end
	end

	arg_6_0:updateTime()
	idlereasy.when(arg_6_0.yyhuodongs, function(arg_9_0, arg_9_1)
		arg_6_0.yyData = arg_9_1[arg_6_1] or {}

		local var_9_0 = false

		for iter_9_0, iter_9_1 in csvPairs(arg_6_0.taskData) do
			if arg_6_0.yyData.stamps and arg_6_0.yyData.stamps[iter_9_0] == 0 then
				var_9_0 = true
			else
				var_9_0 = false

				break
			end
		end

		if var_9_0 and arg_6_0.yyData.link_award[0] == 1 then
			arg_6_0:showEnd()
		else
			arg_6_0.coverPanel:hide()
		end

		for iter_9_2, iter_9_3 in csvPairs(var_6_0) do
			if iter_9_3.huodongID == arg_6_0.huodongID then
				arg_6_0.leftPanel:get("btn" .. iter_9_3.awardID):setTouchEnabled(true)
				bind.touch(arg_6_0.leftPanel, arg_6_0.leftPanel:get("btn" .. iter_9_3.awardID), {
					methods = {
						ended = functools.partial(arg_6_0.getLinkGift, arg_6_0, iter_9_2, iter_9_3)
					}
				})

				if arg_6_0.yyData.link_award and arg_6_0.yyData.link_award[iter_9_3.awardID] == 0 then
					cache.setShader(arg_6_0.leftPanel:get("btn" .. iter_9_3.awardID), false, "gray")
					arg_6_0.leftPanel:get("btn" .. iter_9_3.awardID):get("icon"):texture(iter_9_3.icon .. var_0_3.notGet .. ".png")
				else
					cache.setShader(arg_6_0.leftPanel:get("btn" .. iter_9_3.awardID), false, "normal")
					arg_6_0.leftPanel:get("btn" .. iter_9_3.awardID):get("icon"):texture(iter_9_3.icon .. var_0_3.get .. ".png")

					if arg_6_0.yyData.link_award and arg_6_0.yyData.link_award[iter_9_3.awardID] == 1 then
						widget.addAnimationByKey(arg_6_0.leftPanel:get("btn" .. iter_9_3.awardID), "effect/jiedianjiangli.skel", "rewardEffect" .. iter_9_3.awardID, "effect_loop", 1):xy(62, 30):scale(0.45)
					else
						arg_6_0.leftPanel:get("btn" .. iter_9_3.awardID):get("icon"):texture(iter_9_3.icon .. var_0_3.notGet .. ".png")

						if arg_6_0.leftPanel:get("btn" .. iter_9_3.awardID):getChildByName("rewardEffect" .. iter_9_3.awardID) then
							arg_6_0.leftPanel:get("btn" .. iter_9_3.awardID):getChildByName("rewardEffect" .. iter_9_3.awardID):removeSelf()
						end
					end
				end
			end
		end

		arg_6_0:updateTask()
	end)
	arg_6_0:updateFlipCard()
	Dialog.onCreate(arg_6_0)
end

function var_0_6.initModel(arg_10_0)
	arg_10_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_10_0.rmb = gGameModel.role:getIdler("rmb")
	arg_10_0.clickId = 0
	arg_10_0.task = {}
	arg_10_0.jumpPos = 0
end

function var_0_6.showEnd(arg_11_0)
	arg_11_0.coverPanel:show()
	arg_11_0.coverPanel:get("icon"):texture(arg_11_0.yyCfg.paramMap.maxAwardRes .. var_0_3.get .. ".png")
	widget.addAnimationByKey(arg_11_0.coverPanel, "effect/jiedianjiangli.skel", "rewardEffect", "effect_loop", 1):xy(510, 370):scale(1)
	arg_11_0.coverPanel:onClick(functools.partial(arg_11_0.getLinkGift, arg_11_0, nil, {
		awardID = 0
	}))
end

function var_0_6.getTaskNum(arg_12_0, arg_12_1, arg_12_2)
	if arg_12_0.clickId ~= 0 then
		arg_12_0.showdata:atproxy(arg_12_0.clickId).isFrame = false
	end

	arg_12_0.showdata:atproxy(arg_12_2.id).isFrame = true
	arg_12_0.clickId = arg_12_2.id

	for iter_12_0, iter_12_1 in ipairs(arg_12_0.task) do
		if iter_12_1.id == arg_12_2.id then
			arg_12_0.taskList:jumpToItem(iter_12_0 - 1, cc.p(0, 1), cc.p(0, 1))

			return
		end
	end
end

function var_0_6.getLinkGift(arg_13_0, arg_13_1, arg_13_2)
	if arg_13_0.yyData.link_award and arg_13_0.yyData.link_award[arg_13_2.awardID] == 1 then
		gGameApp:requestServer("/game/yy/link/award/get", function(arg_14_0)
			if arg_13_0.leftPanel:get("btn" .. arg_13_2.awardID) then
				if arg_13_0.leftPanel:get("btn" .. arg_13_2.awardID):getChildByName("rewardEffect" .. arg_13_2.awardID) then
					arg_13_0.leftPanel:get("btn" .. arg_13_2.awardID):getChildByName("rewardEffect" .. arg_13_2.awardID):removeSelf()
				end
			elseif arg_13_0.coverPanel:getChildByName("rewardEffect") then
				arg_13_0.coverPanel:getChildByName("rewardEffect"):removeSelf()
			end

			gGameUI:showGainDisplay(arg_14_0)
		end, arg_13_0.activityId, arg_13_2.awardID)
	elseif arg_13_0.yyData.link_award and arg_13_0.yyData.link_award[arg_13_2.awardID] == 0 then
		gGameUI:showBoxDetail({
			state = 0,
			data = arg_13_2.award,
			content = gLanguageCsv.newYearFlipCardText
		})
	else
		gGameUI:showBoxDetail({
			state = 1,
			data = arg_13_2.award,
			content = gLanguageCsv.newYearFlipCardText
		})
	end
end

function var_0_6.onRules(arg_15_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_15_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_6.getRuleContext(arg_16_0, arg_16_1)
	local var_16_0 = adaptContext

	return {
		var_16_0.clone(arg_16_1.title, function(arg_17_0)
			arg_17_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_16_0.noteText(161),
		var_16_0.noteText(115001, 115015)
	}
end

function var_0_6.onJump(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	if arg_18_3.state == var_0_0.finished then
		arg_18_0.jumpPos = 0

		gGameApp:requestServer("/game/yy/award/get", function(arg_19_0)
			arg_18_0.showdata:atproxy(arg_18_3.id).isSelected = true
			arg_18_0.showdata:atproxy(arg_18_3.id).isFrame = false

			performWithDelay(arg_18_0, function()
				gGameUI:disableTouchDispatch(nil, true)

				arg_18_0.showdata:atproxy(arg_18_3.id).state = var_0_1.covered

				gGameUI:showGainDisplay(arg_19_0)
			end, 0.7)
		end, arg_18_0.activityId, arg_18_3.csvId)
	else
		arg_18_0.jumpPos = arg_18_3.id

		if arg_18_3.jumpTo ~= nil then
			jumpEasy.jumpTo(arg_18_3.jumpTo)
		end
	end
end

function var_0_6.updateTime(arg_21_0)
	local var_21_0 = gGameModel.role:read("yy_endtime")[arg_21_0.activityId] - time.getTime()

	bind.extend(arg_21_0, arg_21_0.taskTextNum, {
		class = "cutdown_label",
		props = {
			time = var_21_0,
			endFunc = function()
				arg_21_0.taskTextNum:text(gLanguageCsv.activityOver)
			end
		}
	})
end

function var_0_6.updateTask(arg_23_0)
	local var_23_0 = {}
	local var_23_1 = gGameModel.role:getYYHuoDongTasksProgress(arg_23_0.activityId) or {}
	local var_23_2 = arg_23_0.yyData.stamps or {}
	local var_23_3 = 0
	local var_23_4 = 0

	for iter_23_0, iter_23_1 in csvPairs(arg_23_0.taskData) do
		if iter_23_1.huodongID == arg_23_0.huodongID then
			var_23_3 = var_23_3 + 1

			local var_23_5 = var_23_1[iter_23_0][1] or 0
			local var_23_6 = var_23_2[iter_23_0] or 0.5

			table.insert(var_23_0, {
				csvId = iter_23_0,
				text = iter_23_1.desc,
				award = iter_23_1.award,
				jumpTo = iter_23_1.goTo,
				num = var_23_5,
				state = var_23_6,
				id = iter_23_1.boardID,
				allNum = iter_23_1.taskParam
			})

			if var_23_2[iter_23_0] then
				var_23_4 = var_23_4 + 1
			end
		end
	end

	table.sort(var_23_0, function(arg_24_0, arg_24_1)
		if arg_24_0.state ~= arg_24_1.state then
			return arg_24_0.state > arg_24_1.state
		end

		return arg_24_0.csvId < arg_24_1.csvId
	end)

	arg_23_0.task = var_23_0

	arg_23_0.teskDatas:update(var_23_0)

	for iter_23_2, iter_23_3 in ipairs(arg_23_0.task) do
		if iter_23_3.id == arg_23_0.jumpPos then
			arg_23_0.taskList:jumpToItem(iter_23_2 - 1, cc.p(0, 1), cc.p(0, 1))

			break
		end
	end

	arg_23_0.taskBar:text(string.format(gLanguageCsv.taskRate, var_23_4, var_23_3))
end

function var_0_6.updateFlipCard(arg_25_0)
	local var_25_0 = {}
	local var_25_1 = arg_25_0.yyData.stamps or {}

	if arg_25_0.task[1].state ~= var_0_0.geted then
		arg_25_0.clickId = arg_25_0.task[1].id
	end

	for iter_25_0 = 1, var_0_5 do
		local var_25_2 = arg_25_0:getCsvId(iter_25_0)

		if var_25_1[var_25_2] == var_0_0.geted then
			table.insert(var_25_0, {
				isSelected = true,
				id = iter_25_0,
				csvId = var_25_2,
				state = var_0_1.covered,
				res = arg_25_0.yyCfg.paramMap.cardRes .. iter_25_0 .. ".png",
				isFrame = iter_25_0 == arg_25_0.clickId
			})
		else
			table.insert(var_25_0, {
				isSelected = false,
				id = iter_25_0,
				csvId = var_25_2,
				state = var_0_1.gain,
				res = arg_25_0.yyCfg.paramMap.cardRes .. iter_25_0 .. ".png",
				isFrame = iter_25_0 == arg_25_0.clickId
			})
		end
	end

	arg_25_0.detail = var_25_0

	arg_25_0.showdata:update(var_25_0)
end

function var_0_6.getCsvId(arg_26_0, arg_26_1)
	for iter_26_0, iter_26_1 in csvPairs(arg_26_0.taskData) do
		if arg_26_1 == iter_26_1.boardID then
			return iter_26_0
		end
	end
end

return var_0_6
