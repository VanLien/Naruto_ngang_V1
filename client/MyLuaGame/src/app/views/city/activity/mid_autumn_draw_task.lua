local var_0_0 = {
	CAN_NOT_GOTTEN = 2,
	CAN_GOTTEN = 1,
	GOTTEN = 0
}
local var_0_1 = class("MidAutumnTask", Dialog)

var_0_1.RESOURCE_FILENAME = "activity_midautumn_task.json"
var_0_1.RESOURCE_BINDING = {
	rankItem = "rankItem",
	["rewardPanel1.tips"] = "tips",
	rewardPanel2 = "rewardPanel2",
	["rewardPanel1.btnGetAll.txt"] = "txtGetAll",
	["topPanel.txt1"] = "txt1",
	["rewardPanel2.noAward"] = "noAward",
	infoItem = "infoItem",
	["leftPanel.tabItem"] = "tabItem",
	rewardPanel1 = "rewardPanel1",
	["topPanel.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["leftPanel.tabList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("tabItem"),
				showTab = bindHelper.self("showTab"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("normal")
					local var_1_1 = arg_1_1:get("selected")
					local var_1_2

					if arg_1_3.select then
						var_1_0:hide()

						var_1_2 = var_1_1:show()
					else
						var_1_1:hide()

						var_1_2 = var_1_0:show()
					end

					if arg_1_3.redHint then
						bind.extend(arg_1_0, arg_1_1, {
							class = "red_hint",
							props = {
								state = arg_1_0.showTab:read() ~= arg_1_2,
								specialTag = arg_1_3.redHint,
								listenData = {
									activityId = arg_1_3.id
								},
								onNode = function(arg_2_0)
									arg_2_0:xy(arg_1_1:width() - 60, arg_1_1:height() - 5)
								end
							}
						})
					end

					var_1_2:get("txt"):getVirtualRenderer():setLineSpacing(-5)
					var_1_2:get("txt"):text(arg_1_3.name)
					var_1_1:setTouchEnabled(false)
					bind.touch(arg_1_0, var_1_0, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	["rewardPanel1.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("achvDatas1"),
				item = bindHelper.self("rankItem"),
				dataOrderCmpGen = bindHelper.self("onSortCards", true),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:multiget("achvDesc", "btnGet", "list", "got", "icon", "txtTimes")

					var_3_0.txtTimes:text(arg_3_3.addTimes)
					text.addEffect(var_3_0.txtTimes, {
						outline = {
							color = ui.COLORS.QUALITY_OUTLINE[5]
						}
					})
					var_3_0.achvDesc:text(arg_3_3.desc)
					bind.touch(arg_3_0, var_3_0.btnGet, {
						methods = {
							ended = functools.partial(arg_3_0.clickCell, arg_3_3.csvId)
						}
					})
					var_3_0.got:visible(arg_3_3.get == var_0_0.GOTTEN)
					var_3_0.btnGet:visible(arg_3_3.get ~= var_0_0.GOTTEN)
					var_3_0.btnGet:get("txt"):text(arg_3_3.get == var_0_0.GOTTEN and gLanguageCsv.received or gLanguageCsv.spaceReceive)

					if arg_3_3.get ~= var_0_0.GOTTEN and arg_3_3.get ~= var_0_0.CAN_GOTTEN then
						var_3_0.btnGet:get("txt"):setFontSize(40)

						if arg_3_3.taskParam then
							var_3_0.btnGet:get("txt"):text(arg_3_3.progress .. "/" .. arg_3_3.taskParam)
						else
							local var_3_1, var_3_2 = next(arg_3_3.taskSpecialParam)
							local var_3_3 = arg_3_3.progress .. "/" .. var_3_1

							var_3_0.btnGet:get("txt"):text(var_3_3)
						end
					end

					uiEasy.setBtnShader(var_3_0.btnGet, var_3_0.btnGet:get("txt"), arg_3_3.get)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onGetBtn")
			}
		}
	},
	["rewardPanel2.list"] = {
		varname = "list2",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("achvDatas2"),
				item = bindHelper.self("infoItem"),
				dataOrderCmpGen = bindHelper.self("onSortNotes", true),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:multiget("txtTimes", "txtInfo", "get", "list")
					local var_4_1 = rich.createByStr(string.format(gLanguageCsv.midAutumnDrawTime, arg_4_3.id), 43):xy(0, 80):anchorPoint(0, 0.5):addTo(var_4_0.txtInfo, 5)
					local var_4_2 = arg_4_3.hit == 1 and gLanguageCsv.midAutumnGetBestNote or gLanguageCsv.midAutumnGetNote

					rich.createByStr(var_4_2, 40):xy(0, 20):anchorPoint(0, 0.5):addTo(var_4_0.txtInfo, 5)
					uiEasy.createItemsToList(arg_4_0, var_4_0.list, arg_4_3.stamps, {
						scale = 0.8
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onGetBtn")
			}
		}
	},
	["rewardPanel1.btnGetAll"] = {
		varname = "btnGetAll",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_5_0)
					gGameApp:requestServer("/game/yy/mid_autumn_draw/task_award/get/onekey", function(arg_6_0)
						gGameUI:showTip(string.format(gLanguageCsv.midAutumnGetTimes, arg_6_0.view))
					end, arg_5_0.activityId)
				end)
			}
		}
	}
}

function var_0_1.onCreate(arg_7_0, arg_7_1)
	arg_7_0:initModel()

	arg_7_0.activityId = arg_7_1
	arg_7_0.showTab = idler.new(1)
	arg_7_0.achvDatas1 = idlers.new()
	arg_7_0.achvDatas2 = idlers.new()
	arg_7_0.tabDatas = idlers.newWithMap({
		{
			redHint = "midAutumnTaskAward",
			type = 1,
			name = gLanguageCsv.midAutumnTask,
			id = arg_7_0.activityId
		},
		{
			type = 2,
			name = gLanguageCsv.midAutumnBlessNote,
			id = arg_7_0.activityId
		}
	})

	local var_7_0 = {
		gLanguageCsv.task,
		gLanguageCsv.midAutumnNote
	}

	idlereasy.when(arg_7_0.yyhuodongs, function(arg_8_0, arg_8_1)
		local var_8_0 = arg_8_1[arg_7_0.activityId] or {}
		local var_8_1 = csv.yunying.yyhuodong[arg_7_0.activityId]

		arg_7_0.huodongID = var_8_1.huodongID

		local var_8_2 = var_8_0.valsums or {}
		local var_8_3 = {}
		local var_8_4 = {}

		uiEasy.setBtnShader(arg_7_0.btnGetAll, arg_7_0.txtGetAll, 2)

		for iter_8_0, iter_8_1 in pairs(var_8_0.stamps or {}) do
			if iter_8_1 == var_0_0.CAN_GOTTEN then
				uiEasy.setBtnShader(arg_7_0.btnGetAll, arg_7_0.txtGetAll, 1)

				break
			end
		end

		for iter_8_2, iter_8_3 in orderCsvPairs(csv.yunying.mid_autumn_draw_tasks) do
			if iter_8_3.huodongID == arg_7_0.huodongID then
				local var_8_5 = table.shallowcopy(iter_8_3)

				var_8_5.csvId = iter_8_2
				var_8_5.progress = var_8_2[iter_8_2] or 0
				var_8_5.get = (var_8_0.stamps or {})[iter_8_2]

				table.insert(var_8_3, var_8_5)
			end
		end

		local var_8_6 = var_8_0.mid_autumn_draw or {}

		if itertools.size(var_8_6) <= 0 then
			arg_7_0.noAward:show()
		else
			arg_7_0.noAward:hide()
		end

		for iter_8_4, iter_8_5 in pairs(var_8_6) do
			local var_8_7 = table.deepcopy(iter_8_5, true)

			var_8_7.hit = nil

			table.insert(var_8_4, {
				stamps = var_8_7,
				hit = iter_8_5.hit,
				id = iter_8_4
			})
		end

		table.sort(var_8_4, function(arg_9_0, arg_9_1)
			return arg_9_0.id > arg_9_1.id
		end)
		arg_7_0.achvDatas1:update(var_8_3)
		arg_7_0.achvDatas2:update(var_8_4)
	end)
	arg_7_0.showTab:addListener(function(arg_10_0, arg_10_1)
		arg_7_0.tabDatas:atproxy(arg_10_1).select = false
		arg_7_0.tabDatas:atproxy(arg_10_0).select = true

		arg_7_0.txt1:text(var_7_0[arg_10_0])

		if arg_7_0["rewardPanel" .. arg_10_1] then
			arg_7_0["rewardPanel" .. arg_10_1]:hide()
		end

		arg_7_0["rewardPanel" .. arg_10_0]:show()
	end)
	arg_7_0.rewardPanel1:show()
	arg_7_0.tips:text(string.format(gLanguageCsv.resetTask, time.getRefreshHour()))
	Dialog.onCreate(arg_7_0)
end

function var_0_1.initModel(arg_11_0)
	arg_11_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
end

function var_0_1.onTabClick(arg_12_0, arg_12_1, arg_12_2)
	arg_12_0.showTab:set(arg_12_2)
end

function var_0_1.onGetBtn(arg_13_0, arg_13_1, arg_13_2)
	gGameApp:requestServer("/game/yy/mid_autumn_draw/task_award/get", function(arg_14_0)
		gGameUI:showTip(string.format(gLanguageCsv.midAutumnGetTimes, arg_14_0.view))
	end, arg_13_0.activityId, arg_13_2)
end

function var_0_1.onSortCards(arg_15_0, arg_15_1)
	return function(arg_16_0, arg_16_1)
		local var_16_0 = arg_16_0.get or 0.5
		local var_16_1 = arg_16_1.get or 0.5

		if var_16_0 ~= var_16_1 then
			return var_16_1 < var_16_0
		end

		return arg_16_0.csvId < arg_16_1.csvId
	end
end

return var_0_1
