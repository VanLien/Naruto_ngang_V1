local var_0_0 = {
	CAN_NOT_GOTTEN = 2,
	CAN_GOTTEN = 1,
	GOTTEN = 0
}
local var_0_1 = class("ActitivyDispatchTask", Dialog)

var_0_1.RESOURCE_FILENAME = "activity_dispatch_task.json"
var_0_1.RESOURCE_BINDING = {
	rankItem = "rankItem",
	rewardPanel1 = "rewardPanel1",
	["leftPanel.tabItem"] = "tabItem",
	["topPanel.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnOneKeyGet = {
		varname = "btnOneKeyGet",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onOneKeyGetBtn")
			}
		}
	},
	["btnOneKeyGet.text"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["leftPanel.tabList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatasIdlers"),
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
									activityId = arg_1_3.id,
									type = arg_1_3.type
								},
								onNode = function(arg_2_0)
									arg_2_0:xy(arg_1_1:width(), arg_1_1:height())
								end
							}
						})
					end

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
	["rankItem.btnGet.text"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
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
					local var_3_0 = arg_3_1:multiget("achvDesc", "btnGet", "list", "got", "txt", "btnGoto")

					var_3_0.achvDesc:text(arg_3_3.desc)

					if next(arg_3_3.award) ~= nil then
						uiEasy.createItemsToList(arg_3_0, var_3_0.list, arg_3_3.award, {
							scale = 0.8
						})
					end

					var_3_0.list:setScrollBarEnabled(false)
					bind.touch(arg_3_0, var_3_0.btnGet, {
						methods = {
							ended = functools.partial(arg_3_0.clickCell, arg_3_3.csvId)
						}
					})
					bind.touch(arg_3_0, var_3_0.btnGoto, {
						methods = {
							ended = functools.partial(arg_3_0.clickGotoCell, arg_3_3.goTo)
						}
					})
					var_3_0.txt:text(arg_3_3.progress .. "/" .. arg_3_3.taskParam)

					if arg_3_3.achType == 1 then
						var_3_0.txt:hide()
						var_3_0.btnGet:y(120)
					end

					if arg_3_3.get == var_0_0.GOTTEN then
						var_3_0.btnGoto:hide()
						var_3_0.btnGet:get("txt"):text(gLanguageCsv.received)
						var_3_0.txt:setTextColor(cc.c4b(98, 197, 88, 255))
					elseif arg_3_3.get == var_0_0.CAN_GOTTEN then
						var_3_0.btnGoto:hide()
						var_3_0.btnGet:get("txt"):text(gLanguageCsv.spaceReceive)
						var_3_0.txt:setTextColor(cc.c4b(98, 197, 88, 255))
					else
						var_3_0.btnGoto:hide()
						var_3_0.btnGet:get("txt"):text(gLanguageCsv.spaceReceive)
						var_3_0.txt:setTextColor(cc.c4b(247, 115, 78, 255))

						if arg_3_3.achType == 5 then
							if arg_3_3.goTo == "" then
								var_3_0.btnGet:show()
								var_3_0.btnGoto:hide()
							else
								var_3_0.btnGet:hide()
								var_3_0.btnGoto:show()
							end
						end
					end

					uiEasy.setBtnShader(var_3_0.btnGet, var_3_0.btnGet:get("txt"), arg_3_3.get)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onGetBtn"),
				clickGotoCell = bindHelper.self("onGotoBtn")
			}
		}
	}
}

function var_0_1.onCreate(arg_4_0, arg_4_1)
	arg_4_0.activityId = arg_4_1

	arg_4_0.rewardPanel1:show()

	local var_4_0 = 0

	for iter_4_0, iter_4_1 in orderCsvPairs(csv.yunying.dispatch_task) do
		var_4_0 = iter_4_1.type

		break
	end

	arg_4_0.showTab = idler.new(var_4_0)

	arg_4_0:initModel()
	Dialog.onCreate(arg_4_0)
end

function var_0_1.initModel(arg_5_0)
	arg_5_0.achvDatas1 = idlers.new()
	arg_5_0.tabDatasIdlers = idlers.new()

	local var_5_0 = {
		{
			redHint = "dispatchTaskType",
			type = 1,
			name = gLanguageCsv.dispatchTaskType1,
			id = arg_5_0.activityId
		},
		{
			redHint = "dispatchTaskType",
			type = 2,
			name = gLanguageCsv.dispatchTaskType2,
			id = arg_5_0.activityId
		},
		{
			redHint = "dispatchTaskType",
			type = 3,
			name = gLanguageCsv.dispatchTaskType3,
			id = arg_5_0.activityId
		},
		{
			redHint = "dispatchTaskType",
			type = 4,
			name = gLanguageCsv.dispatchTaskType4,
			id = arg_5_0.activityId
		},
		{
			redHint = "dispatchTaskType",
			type = 5,
			name = gLanguageCsv.dispatchTaskType5,
			id = arg_5_0.activityId
		}
	}

	arg_5_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")

	idlereasy.when(arg_5_0.yyhuodongs, function(arg_6_0, arg_6_1)
		local var_6_0 = arg_6_1[arg_5_0.activityId] or {}
		local var_6_1 = var_6_0.valsums or {}
		local var_6_2 = {}

		arg_5_0.datas = {}

		local var_6_3 = false

		for iter_6_0, iter_6_1 in orderCsvPairs(csv.yunying.dispatch_task) do
			local var_6_4 = table.shallowcopy(iter_6_1)

			var_6_4.csvId = iter_6_0
			var_6_4.get = (var_6_0.stamps or {})[iter_6_0]
			var_6_4.progress = var_6_1[iter_6_0] or 0
			var_6_4.achType = iter_6_1.type
			arg_5_0.datas[iter_6_1.type] = arg_5_0.datas[iter_6_1.type] or {}
			var_6_2[iter_6_1.type] = var_6_2[iter_6_1.type] or var_5_0[iter_6_1.type]

			table.insert(arg_5_0.datas[iter_6_1.type], var_6_4)

			if var_6_4.get == var_0_0.CAN_GOTTEN then
				var_6_3 = true
			end
		end

		uiEasy.setBtnShader(arg_5_0.btnOneKeyGet, arg_5_0.btnOneKeyGet:get("txt"), var_6_3 == false and 2 or 1)
		arg_5_0.achvDatas1:update(arg_5_0.datas[arg_5_0.showTab:read()])
		arg_5_0.tabDatasIdlers:update(var_6_2)
	end)
	arg_5_0.showTab:addListener(function(arg_7_0, arg_7_1)
		arg_5_0.tabDatasIdlers:atproxy(arg_7_1).select = false
		arg_5_0.tabDatasIdlers:atproxy(arg_7_0).select = true

		arg_5_0.achvDatas1:update(arg_5_0.datas[arg_7_0])
	end)
end

function var_0_1.onTabClick(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0.showTab:set(arg_8_2)
end

function var_0_1.onGetBtn(arg_9_0, arg_9_1, arg_9_2)
	gGameApp:requestServer("/game/yy/award/get", function(arg_10_0)
		gGameUI:showGainDisplay(arg_10_0)
	end, arg_9_0.activityId, arg_9_2)
end

function var_0_1.onOneKeyGetBtn(arg_11_0, arg_11_1)
	gGameApp:requestServer("/game/yy/award/get/onekey", function(arg_12_0)
		gGameUI:showGainDisplay(arg_12_0)
	end, arg_11_0.activityId)
end

function var_0_1.onGotoBtn(arg_13_0, arg_13_1, arg_13_2)
	jumpEasy.jumpTo(arg_13_2)
end

function var_0_1.onSortCards(arg_14_0, arg_14_1)
	return function(arg_15_0, arg_15_1)
		local var_15_0 = arg_15_0.get or 0.5
		local var_15_1 = arg_15_1.get or 0.5

		if var_15_0 ~= var_15_1 then
			return var_15_1 < var_15_0
		end

		return arg_15_0.csvId < arg_15_1.csvId
	end
end

return var_0_1
