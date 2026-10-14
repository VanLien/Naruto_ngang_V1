local var_0_0 = {
	GO = 1,
	GET = 0,
	GOT = 3,
	NONE = 2
}

local function var_0_1(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_3.cfg

	if var_1_0.vipReq then
		arg_1_1:get("bg2"):visible(var_1_0.vipReq > 0)
	end

	local var_1_1 = arg_1_1:multiget("textName", "textDesc", "list", "btnGet", "btnGo", "textNum", "imgGot", "imgIcon")

	var_1_1.textName:text(var_1_0.title)
	var_1_1.textDesc:text(var_1_0.desc)
	uiEasy.createItemsToList(arg_1_0, var_1_1.list, arg_1_3.data, {
		scale = 0.8
	})
	var_1_1.imgIcon:texture(var_1_0.icon)
	var_1_1.btnGet:visible(arg_1_3.state == var_0_0.GET)
	var_1_1.btnGo:visible(arg_1_3.state == var_0_0.GO)
	var_1_1.imgGot:visible(arg_1_3.state == var_0_0.GOT)
	var_1_1.textNum:visible(arg_1_3.state ~= var_0_0.GOT)
	text.addEffect(var_1_1.btnGet:get("title"), {
		outline = {
			size = 1,
			color = ui.NEWCOLORS.OUTLINE.YELLOW
		}
	})
	text.addEffect(var_1_1.btnGo:get("title"), {
		outline = {
			size = 1,
			color = ui.NEWCOLORS.OUTLINE.BLUE
		}
	})
	bind.touch(arg_1_0, var_1_1.btnGet, {
		methods = {
			ended = functools.partial(arg_1_0.clickCellGet, arg_1_2, arg_1_1)
		}
	})
	bind.touch(arg_1_0, var_1_1.btnGo, {
		methods = {
			ended = functools.partial(arg_1_0.clickCellGo, arg_1_2)
		}
	})
	var_1_1.textDesc:text(var_1_0.desc)

	if arg_1_3.progressCurr then
		local var_1_2 = tonumber(arg_1_3.progressCurr) >= tonumber(var_1_0.targetDisplay) and ui.NEWCOLORS.GREENLIGHT or ui.NEWCOLORS.RED1
		local var_1_3 = string.format("%s/%s", arg_1_3.progressCurr, var_1_0.targetDisplay)

		var_1_1.textNum:text(var_1_3)
		text.addEffect(var_1_1.textNum, {
			color = var_1_2
		})
	end
end

local var_0_2 = class("TaskView", cc.load("mvc").ViewBase)

var_0_2.RESOURCE_FILENAME = "task.json"
var_0_2.RESOURCE_BINDING = {
	["rightPanel.dailyPanel.txt"] = "liveness",
	itemBox = "itemBox",
	["rightPanel.dailyPanel.heart"] = "heart",
	["leftPanel.item"] = "leftItem",
	["rightPanel.dailyPanel.btnAll.title"] = "oneKeyTxt",
	leftPanel = "leftPanel",
	["rightPanel.dailyPanel.num"] = "currLiveness",
	["rightPanel.dailyPanel.bg"] = "livenessBg",
	itemTask = "itemTask",
	["rightPanel.dailyPanel"] = "dailyPanel",
	rightPanel = "rightPanel",
	["leftPanel.item.normal.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.BLUE
				}
			}
		}
	},
	["leftPanel.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("leftDatas"),
				item = bindHelper.self("leftItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:get("normal")
					local var_2_1 = arg_2_1:get("selected")
					local var_2_2

					if arg_2_3.select then
						var_2_0:hide()

						var_2_2 = var_2_1:show()
					else
						var_2_1:hide()

						var_2_2 = var_2_0:show()

						var_2_2:get("subTxt"):text(arg_2_3.subName)
					end

					var_2_2:get("txt"):text(arg_2_3.name)
					var_2_2:get("txt"):text(arg_2_3.name)
					uiEasy.updateUnlockRes(arg_2_3.unlockKey, var_2_2, {
						scale = 0.5,
						justRemove = not arg_2_3.unlockKey,
						pos = cc.p(180, 66)
					}):anonyOnly(arg_2_0, arg_2_0:getIdx(arg_2_2))
					bind.extend(arg_2_0, var_2_2, {
						class = "red_hint",
						props = {
							state = arg_2_3.select ~= true,
							specialTag = arg_2_2 == 1 and "cityTaskDaily" or "cityTaskMain",
							onNode = function(arg_3_0)
								arg_3_0:xy(368, 130)
							end
						}
					})
					var_2_1:setTouchEnabled(false)
					bind.touch(arg_2_0, var_2_0, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onLeftItemClick")
			}
		}
	},
	["rightPanel.dailyPanel.btnAll"] = {
		varname = "btnAll",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onOneKeyClick")
			}
		}
	},
	["rightPanel.dailyPanel.dailyList"] = {
		varname = "dailyList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				data = bindHelper.self("dailyData"),
				item = bindHelper.self("itemTask"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					var_0_1(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				end
			},
			handlers = {
				clickCellGet = bindHelper.self("onBtnGetDailyClick"),
				clickCellGo = bindHelper.self("onBtnGoDailyClick")
			}
		}
	},
	["rightPanel.mainList.mainList"] = {
		varname = "mainList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				data = bindHelper.self("mainData"),
				item = bindHelper.self("itemTask"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					var_0_1(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				end
			},
			handlers = {
				clickCellGet = bindHelper.self("onBtnGetMainClick"),
				clickCellGo = bindHelper.self("onBtnGoMainClick")
			}
		}
	},
	["rightPanel.dailyPanel.boxList"] = {
		varname = "boxList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				padding = 111,
				backupCached = false,
				data = bindHelper.self("boxData"),
				item = bindHelper.self("itemBox"),
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					local var_6_0 = arg_6_3.scoreEnough == true
					local var_6_1 = arg_6_3.boxGet == true
					local var_6_2 = arg_6_1:get("icon")

					var_6_2:texture("common/icon/icon_box" .. arg_6_2 .. (var_6_1 and "_open.png" or ".png"))
					bind.touch(arg_6_0, var_6_2, {
						methods = {
							ended = functools.partial(arg_6_0.clickBoxGet, arg_6_2, var_6_2)
						}
					})
					arg_6_1:get("bg"):texture(var_6_0 and "city/task/bg_huoyuedu1.png" or "city/task/bg_huoyuedu2.png")

					local var_6_3 = var_6_0 and not var_6_1

					if var_6_3 then
						local var_6_4 = widget.addAnimation(arg_6_1, "effect/jiedianjiangli.skel", "effect_loop", var_6_2:z() - 1)
						local var_6_5 = var_6_2:size()
						local var_6_6 = arg_6_1:size()
						local var_6_7 = math.max(var_6_5.width / var_6_6.width, var_6_5.height / var_6_6.height)
						local var_6_8 = math.min(var_6_7, 0.5)

						var_6_4:scale(var_6_8):x(var_6_2:x()):y(var_6_2:y() - 30)

						arg_6_1.effectBox = var_6_4
					elseif arg_6_1.effectBox then
						arg_6_1.effectBox:hide()
						arg_6_1.effectBox:removeFromParent()

						arg_6_1.effectBox = nil
					end

					uiEasy.addVibrateToNode(arg_6_0, var_6_2, var_6_3, arg_6_1:getName() .. arg_6_2 .. "vibrate")
					arg_6_1:get("num"):text(arg_6_3.cfg.needPoint)
				end
			},
			handlers = {
				clickBoxGet = bindHelper.self("onBoxGetClick")
			}
		}
	},
	["rightPanel.dailyPanel.bar"] = {
		varname = "bar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				maskImg = "common/icon/mask_bar_red.png",
				data = bindHelper.self("livenessPoint1")
			}
		}
	}
}

function var_0_2.onCreate(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.rightPanel:get("dailyPanel"):multiget("btnAll", "icon", "bg", "txt", "num", "barBg", "bar", "heart")

	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_7_0.leftPanel,
			"pos",
			"left"
		},
		{
			var_7_0,
			"pos",
			"right"
		},
		{
			arg_7_0.boxList,
			"pos",
			"right"
		},
		{
			arg_7_0.dailyList,
			"width"
		},
		{
			arg_7_0.mainList,
			"width"
		},
		{
			arg_7_0.mainList,
			"pos",
			"left"
		},
		{
			arg_7_0.itemTask,
			"width"
		},
		{
			arg_7_0.dailyList,
			"pos",
			"left"
		}
	})

	arg_7_1 = arg_7_1 or 1

	dataEasy.getListenUnlock(gUnlockCsv.dailyTask, function(arg_8_0)
		if not arg_8_0 then
			arg_7_1 = 2
		end
	end)
	arg_7_0:initModel()
	gGameUI.topuiManager:createView("default", arg_7_0, {
		onClose = arg_7_0:createHandler("onClose")
	}):init({
		subTitle = "TASK",
		title = "common/txt/txt_bt_renwu.png"
	})

	arg_7_0.dailyData = idlertable.new({})
	arg_7_0.mainData = idlertable.new({})
	arg_7_0.btnOneKeyGray = idler.new(false)

	idlereasy.when(arg_7_0.btnOneKeyGray, function(arg_9_0, arg_9_1)
		arg_7_0.btnAll:setTouchEnabled(arg_9_1)
		cache.setShader(arg_7_0.btnAll, false, arg_9_1 and "normal" or "hsl_gray")

		if arg_9_1 then
			text.addEffect(arg_7_0.oneKeyTxt, {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				},
				color = ui.COLORS.NORMAL.YELLOW
			})
		else
			text.deleteAllEffect(arg_7_0.oneKeyTxt)
			text.addEffect(arg_7_0.oneKeyTxt, {
				color = ui.COLORS.DISABLED.YELLOW
			})
		end
	end)
	idlereasy.any({
		arg_7_0.tasksDaily,
		arg_7_0.roleLv,
		arg_7_0.vipLevel
	}, function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
		local var_10_0 = {}
		local var_10_1 = false

		for iter_10_0, iter_10_1 in pairs(arg_10_1) do
			local var_10_2 = csv.tasks[iter_10_1.id]

			if arg_10_3 >= var_10_2.vipReq and arg_10_2 >= var_10_2.levelReq then
				local var_10_3 = {}

				for iter_10_2, iter_10_3 in csvMapPairs(var_10_2.awardArgs) do
					var_10_3[iter_10_2] = iter_10_3
				end

				if var_10_2.point > 0 then
					var_10_3[399] = var_10_2.point
				end

				local var_10_4 = var_0_0.NONE

				if iter_10_1.flag == 0 and var_10_2.goToPanel then
					var_10_4 = var_0_0.GO
				elseif iter_10_1.flag == 1 then
					var_10_4 = var_0_0.GET
					var_10_1 = true
				elseif iter_10_1.flag == 2 then
					var_10_4 = var_0_0.GOT
				end

				table.insert(var_10_0, {
					id = iter_10_1.id,
					progressCurr = iter_10_1.arg,
					data = var_10_3,
					state = var_10_4,
					cfg = var_10_2
				})
			end
		end

		arg_7_0.btnOneKeyGray:set(var_10_1)
		table.sort(var_10_0, function(arg_11_0, arg_11_1)
			if arg_11_0.state == arg_11_1.state and arg_11_0.state ~= 3 then
				return arg_11_0.cfg.sortWeight > arg_11_1.cfg.sortWeight
			else
				return arg_11_0.state < arg_11_1.state
			end
		end)
		dataEasy.tryCallFunc(arg_7_0.dailyList, "updatePreloadCenterIndex")
		arg_7_0.dailyData:set(var_10_0)

		return true
	end)
	idlereasy.any({
		arg_7_0.tasksMain,
		arg_7_0.roleLv,
		arg_7_0.vipLevel
	}, function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
		local var_12_0 = {}

		for iter_12_0, iter_12_1 in pairs(arg_12_1) do
			local var_12_1 = csv.tasks[iter_12_1.id]

			if iter_12_1.flag ~= 2 and arg_12_3 >= var_12_1.vipReq and arg_12_2 >= var_12_1.levelReq then
				local var_12_2 = var_0_0.NONE

				if iter_12_1.flag == 0 and var_12_1.goToPanel then
					var_12_2 = var_0_0.GO
				elseif iter_12_1.flag == 0 or iter_12_1.flag == 2 then
					var_12_2 = var_0_0.NONE
				else
					var_12_2 = var_0_0.GET
				end

				local var_12_3 = {}

				for iter_12_2, iter_12_3 in csvMapPairs(var_12_1.awardArgs) do
					var_12_3[iter_12_2] = iter_12_3
				end

				table.insert(var_12_0, {
					id = iter_12_1.id,
					progressCurr = iter_12_1.arg,
					data = var_12_3,
					state = var_12_2,
					cfg = var_12_1
				})
			end
		end

		table.sort(var_12_0, function(arg_13_0, arg_13_1)
			if arg_13_0.state == arg_13_1.state and arg_13_0.state ~= 3 then
				return arg_13_0.cfg.sortWeight > arg_13_0.cfg.sortWeight
			else
				return arg_13_0.state < arg_13_1.state
			end
		end)
		arg_7_0.mainData:set(var_12_0)

		return true
	end)

	local var_7_1 = {
		{
			unlockKey = "dailyTask",
			subName = "Daily",
			name = gLanguageCsv.spaceDaily
		},
		{
			subName = "Main",
			name = gLanguageCsv.spaceMainLine
		}
	}

	arg_7_0.leftDatas = idlers.newWithMap(var_7_1)
	arg_7_0.showTab = idler.new(arg_7_1)

	arg_7_0.showTab:addListener(function(arg_14_0, arg_14_1, arg_14_2)
		arg_7_0.leftDatas:atproxy(arg_14_1).select = false
		arg_7_0.leftDatas:atproxy(arg_14_0).select = true

		arg_7_0.dailyPanel:visible(arg_14_0 == 1)
		arg_7_0.mainList:visible(arg_14_0 ~= 1)
	end)

	local var_7_2 = {}
	local var_7_3 = {}

	for iter_7_0, iter_7_1 in orderCsvPairs(csv.livenessaward) do
		local var_7_4 = {
			cfg = iter_7_1
		}

		table.insert(var_7_2, var_7_4)
		table.insert(var_7_3, iter_7_1.needPoint)
	end

	arg_7_0.livenessPoint1 = idler.new(0)
	arg_7_0.boxData = idlertable.new(var_7_2)

	idlereasy.when(arg_7_0.boxAward, function(arg_15_0, arg_15_1)
		for iter_15_0, iter_15_1 in ipairs(arg_15_1) do
			if iter_15_1 == 2 then
				arg_7_0.boxData:proxy()[iter_15_0].boxGet = true
			end
		end

		return true
	end)

	local var_7_5 = {
		20,
		40,
		60,
		80,
		100
	}

	idlereasy.when(arg_7_0.livenessPoint, function(arg_16_0, arg_16_1)
		arg_7_0.livenessPoint1:set(mathEasy.showProgress(var_7_5, var_7_3, arg_16_1))

		local var_16_0 = 0

		for iter_16_0, iter_16_1 in ipairs(var_7_3) do
			if iter_16_1 <= arg_16_1 then
				var_16_0 = var_16_0 + 1
			else
				break
			end
		end

		for iter_16_2 = 1, var_16_0 do
			arg_7_0.boxData:proxy()[iter_16_2].scoreEnough = true
		end

		arg_7_0.currLiveness:text(arg_16_1)
	end)

	arg_7_0.params = {}

	arg_7_0.roleLv:addListener(function(arg_17_0, arg_17_1)
		if arg_17_0 == arg_17_1 then
			return
		end

		function arg_7_0.params.cb()
			gGameUI:stackUI("common.upgrade_notice", nil, nil, arg_17_1)
		end
	end, true)

	if arg_7_0.dailyPanel:get("privilege") then
		arg_7_0.dailyPanel:get("privilege"):removeSelf()
	end

	uiEasy.setPrivilegeRichText(game.PRIVILEGE_TYPE.DailyTaskExpRate, arg_7_0.dailyPanel, gLanguageCsv.exps, cc.p(7, 100))
end

function var_0_2.initModel(arg_19_0)
	arg_19_0.tasksDaily = gGameModel.tasks:getIdler("daily")
	arg_19_0.tasksMain = gGameModel.tasks:getIdler("main")
	arg_19_0.livenessPoint = gGameModel.daily_record:getIdler("liveness_point")
	arg_19_0.boxAward = gGameModel.daily_record:getIdler("liveness_stage_award")
	arg_19_0.roleLv = gGameModel.role:getIdler("level")
	arg_19_0.vipLevel = gGameModel.role:getIdler("vip_level")
end

function var_0_2.onBtnGoMainClick(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_0.mainData:proxy()[arg_20_2]
	local var_20_1 = csv.tasks[var_20_0.id]

	jumpEasy.jumpTo(var_20_1.goToPanel)
end

function var_0_2.onBtnGetMainClick(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = arg_21_0.mainData:proxy()[arg_21_2].id

	gGameApp:requestServer("/game/role/main_task/gain", function()
		local var_22_0 = arg_21_3:get("effect")

		if var_22_0 then
			var_22_0:removeFromParent()
		end

		local var_22_1 = {}

		for iter_22_0, iter_22_1 in csvMapPairs(csv.tasks[var_21_0].awardArgs) do
			table.insert(var_22_1, {
				iter_22_0,
				iter_22_1
			})
		end

		arg_21_0:showGainDisplayThenLevel(var_22_1, {
			raw = false
		})
	end, var_21_0)
end

function var_0_2.onBtnGoDailyClick(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_0.dailyData:proxy()[arg_23_2]
	local var_23_1 = csv.tasks[var_23_0.id]

	jumpEasy.jumpTo(var_23_1.goToPanel)
end

function var_0_2.onBoxGetClick(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = arg_24_0.boxData:proxy()[arg_24_2]

	if arg_24_0.livenessPoint:read() >= var_24_0.cfg.needPoint and not var_24_0.boxGet then
		local var_24_1 = {
			false
		}

		gGameApp:requestServerCustom("/game/role/liveness/stageaward"):params(arg_24_2):onResponse(function(arg_25_0)
			arg_24_3:texture("common/icon/icon_box" .. arg_24_2 .. "_open.png")
			uiEasy.setBoxEffect(arg_24_3, 0.5, function()
				var_24_1[1] = true
			end, -15, 10)
		end):wait(var_24_1):doit(function(arg_27_0)
			arg_24_0:showGainDisplayThenLevel(arg_27_0)

			var_24_0.boxGet = true
		end)
	else
		gGameUI:showBoxDetail({
			data = var_24_0.cfg.award,
			content = string.format(gLanguageCsv.totalLivenessCanGetBox, var_24_0.cfg.needPoint),
			state = var_24_0.boxGet == true and 0 or 1
		})
	end
end

function var_0_2.onBtnGetDailyClick(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	local var_28_0 = arg_28_0.dailyData:proxy()[arg_28_2].id

	gGameApp:requestServer("/game/role/daily_task/gain", function(arg_29_0)
		local var_29_0 = arg_28_3:get("effect")

		if var_29_0 then
			var_29_0:removeFromParent()
		end

		local var_29_1 = csv.tasks[var_28_0]
		local var_29_2 = {}

		for iter_29_0, iter_29_1 in pairs(arg_29_0.view.result) do
			var_29_2[iter_29_0] = iter_29_1
		end

		if var_29_1.point > 0 then
			var_29_2[399] = var_29_1.point
		end

		arg_28_0:showGainDisplayThenLevel(var_29_2, {
			raw = false
		})
	end, var_28_0)
end

function var_0_2.onOneKeyClick(arg_30_0)
	local var_30_0 = {}
	local var_30_1 = arg_30_0.dailyData:read()
	local var_30_2 = 0

	for iter_30_0, iter_30_1 in ipairs(var_30_1) do
		if iter_30_1.state == var_0_0.GET then
			var_30_2 = var_30_2 + csv.tasks[iter_30_1.id].point
		end
	end

	if var_30_2 > 0 then
		var_30_0[399] = var_30_2
	end

	gGameApp:requestServer("/game/role/daily_task/allgain", function(arg_31_0)
		for iter_31_0, iter_31_1 in pairs(arg_31_0.view.result) do
			if var_30_0[iter_31_0] then
				var_30_0[iter_31_0] = var_30_0[iter_31_0] + iter_31_1
			else
				var_30_0[iter_31_0] = iter_31_1
			end
		end

		arg_30_0:showGainDisplayThenLevel(var_30_0, {
			raw = false
		})
	end)
end

function var_0_2.onLeftItemClick(arg_32_0, arg_32_1, arg_32_2)
	if not dataEasy.isUnlock(gUnlockCsv.dailyTask) and arg_32_2 == 1 then
		gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.dailyTask))
	else
		arg_32_0.showTab:set(arg_32_2)
	end
end

function var_0_2.showGainDisplayThenLevel(arg_33_0, arg_33_1, arg_33_2)
	if arg_33_2 then
		for iter_33_0, iter_33_1 in pairs(arg_33_2) do
			arg_33_0.params[iter_33_0] = iter_33_1
		end
	end

	gGameUI:showGainDisplay(arg_33_1, arg_33_0.params)

	arg_33_0.params = {}
end

return var_0_2
