local var_0_0 = {
	CAN_NOT_GOTTEN = 2,
	CAN_GOTTEN = 1,
	GOTTEN = 0
}

local function var_0_1(arg_1_0, arg_1_1)
	arg_1_0:setTouchEnabled(arg_1_1)
	cache.setShader(arg_1_0, false, arg_1_1 and "normal" or "hsl_gray")

	if arg_1_1 then
		text.addEffect(arg_1_0:get("txt"), {
			glow = {
				color = ui.COLORS.GLOW.WHITE
			}
		})
	else
		text.deleteAllEffect(arg_1_0:get("txt"))
	end
end

local var_0_2 = class("GridWalkTask", Dialog)

var_0_2.RESOURCE_FILENAME = "grid_walk_task.json"
var_0_2.RESOURCE_BINDING = {
	tabItem = "tabItem",
	item = "item",
	label = "label",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	tabList = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("tabItem"),
				showTab = bindHelper.self("showTab"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("normal", "selected", "txt")

					var_2_0.txt:text(arg_2_3.name)
					var_2_0.normal:visible(not arg_2_3.selected)
					var_2_0.selected:visible(arg_2_3.selected)
					arg_2_1:setTouchEnabled(not arg_2_3.selected)
					text.deleteAllEffect(var_2_0.txt)

					if arg_2_3.selected then
						text.addEffect(var_2_0.txt, {
							color = ui.COLORS.NORMAL.WHITE,
							glow = {
								color = ui.COLORS.GLOW.WHITE
							}
						})
					else
						text.addEffect(var_2_0.txt, {
							color = ui.COLORS.NORMAL.RED
						})
					end

					if arg_2_3.redHint then
						bind.extend(arg_2_0, arg_2_1, {
							class = "red_hint",
							props = {
								state = arg_2_0.showTab:read() ~= arg_2_2,
								specialTag = arg_2_3.redHint,
								onNode = function(arg_3_0)
									arg_3_0:xy(arg_2_1:width(), arg_2_1:height())
								end
							}
						})
					end

					bind.touch(arg_2_0, arg_2_1, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				padding = 4,
				data = bindHelper.self("taskData"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				dataOrderCmpGen = bindHelper.self("onSortCards", true),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:multiget("desc", "imgReceived", "num", "btnReceive", "itemsList", "btnGoto")

					if next(arg_4_3.award) ~= nil then
						uiEasy.createItemsToList(arg_4_0, var_4_0.itemsList, arg_4_3.award, {
							scale = 0.7,
							margin = 20
						})
					end

					var_4_0.desc:text(arg_4_3.desc)

					local var_4_1 = arg_4_3.val or 0

					var_4_0.num:text(var_4_1 .. "/" .. arg_4_3.taskParam)

					if arg_4_3.goTo == "" and arg_4_3.get ~= var_0_0.CAN_GOTTEN then
						var_4_0.num:y(arg_4_1:height() / 2)
					end

					var_4_0.num:visible(arg_4_3.get ~= var_0_0.GOTTEN)
					var_4_0.btnGoto:visible((not arg_4_3.get or arg_4_3.get == var_0_0.CAN_NOT_GOTTEN) and arg_4_3.goTo ~= "")
					var_4_0.btnReceive:visible(arg_4_3.get == var_0_0.CAN_GOTTEN)
					var_4_0.imgReceived:visible(arg_4_3.get == var_0_0.GOTTEN)
					text.addEffect(var_4_0.num, {
						color = var_4_1 >= arg_4_3.taskParam and ui.COLORS.NORMAL.FRIEND_GREEN or ui.COLORS.NORMAL.ALERT_ORANGE
					})
					text.addEffect(var_4_0.btnReceive:get("txt"), {
						glow = {
							color = ui.COLORS.GLOW.WHITE
						}
					})
					text.addEffect(var_4_0.btnGoto:get("txt"), {
						glow = {
							color = ui.COLORS.GLOW.WHITE
						}
					})
					bind.touch(arg_4_0, var_4_0.btnReceive, {
						methods = {
							ended = functools.partial(arg_4_0.clickCell, arg_4_3.csvId)
						}
					})
					bind.touch(arg_4_0, var_4_0.btnGoto, {
						methods = {
							ended = functools.partial(arg_4_0.clickGotoCell, arg_4_3.goTo)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onGetBtn"),
				clickGotoCell = bindHelper.self("onGotoBtn")
			}
		}
	},
	btnOneKey = {
		varname = "btnOneKey",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onOneKey")
			}
		}
	},
	["btnOneKey.txt"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	}
}

function var_0_2.onCreate(arg_5_0, arg_5_1)
	arg_5_0.callBack = arg_5_1.callBack

	arg_5_0:initModel()
	idlereasy.when(arg_5_0.yyhuodongs, function(arg_6_0, arg_6_1)
		local var_6_0 = arg_6_1[arg_5_0.yyID] or {}

		arg_5_0.yydata = var_6_0

		arg_5_0:initRight()
	end)
	arg_5_0.showTab:addListener(function(arg_7_0, arg_7_1)
		arg_5_0.tabDatas:atproxy(arg_7_1).selected = false
		arg_5_0.tabDatas:atproxy(arg_7_0).selected = true

		arg_5_0.label:visible(arg_7_0 == 1)
		arg_5_0:initRight()
	end)
	Dialog.onCreate(arg_5_0)
end

function var_0_2.initModel(arg_8_0)
	arg_8_0.yyID = gGameModel.role:read("grid_walk").yy_id
	arg_8_0.showTab = idler.new(1)
	arg_8_0.taskData = idlers.newWithMap({})
	arg_8_0.tabDatas = idlers.newWithMap({
		{
			selected = true,
			redHint = "gridWalkTask",
			name = gLanguageCsv.dailyTasks
		},
		{
			selected = false,
			redHint = "gridWalkAchievements",
			name = gLanguageCsv.treasureAchievements
		}
	})
	arg_8_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
end

function var_0_2.onTabClick(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0.showTab:set(arg_9_2)
end

function var_0_2.initRight(arg_10_0)
	local var_10_0 = {}
	local var_10_1 = {}
	local var_10_2 = false
	local var_10_3 = csv.yunying.yyhuodong[arg_10_0.yyID].huodongID
	local var_10_4 = arg_10_0.yydata.stamps or {}
	local var_10_5 = arg_10_0.yydata.valsums or {}

	for iter_10_0, iter_10_1 in csvPairs(csv.yunying.grid_walk_tasks) do
		if iter_10_1.huodongID == var_10_3 then
			local var_10_6 = table.shallowcopy(iter_10_1)

			var_10_6.csvId = iter_10_0
			var_10_6.get = var_10_4[iter_10_0]
			var_10_6.val = var_10_5[iter_10_0]

			if var_10_6.get == 1 then
				var_10_2 = true
			end

			if iter_10_1.taskType == 0 then
				table.insert(var_10_1, var_10_6)
			else
				table.insert(var_10_0, var_10_6)
			end
		end
	end

	if arg_10_0.showTab:read() == 1 then
		arg_10_0.taskData:update(var_10_0)
	elseif arg_10_0.showTab:read() == 2 then
		arg_10_0.taskData:update(var_10_1)
	end

	var_0_1(arg_10_0.btnOneKey, var_10_2)
end

function var_0_2.onSortCards(arg_11_0, arg_11_1)
	return function(arg_12_0, arg_12_1)
		local var_12_0 = arg_12_0.get or 0.5
		local var_12_1 = arg_12_1.get or 0.5

		if var_12_0 ~= var_12_1 then
			return var_12_1 < var_12_0
		end

		return arg_12_0.csvId < arg_12_1.csvId
	end
end

function var_0_2.onGetBtn(arg_13_0, arg_13_1, arg_13_2)
	gGameApp:requestServer("/game/yy/award/get", function(arg_14_0)
		gGameUI:showGainDisplay(arg_14_0)
		arg_13_0.callBack()
	end, arg_13_0.yyID, arg_13_2)
end

function var_0_2.onOneKey(arg_15_0)
	gGameApp:requestServer("/game/yy/award/get/onekey", function(arg_16_0)
		gGameUI:showGainDisplay(arg_16_0)
		arg_15_0.callBack()
	end, arg_15_0.yyID)
end

function var_0_2.onGotoBtn(arg_17_0, arg_17_1, arg_17_2)
	jumpEasy.jumpTo(arg_17_2)
end

return var_0_2
