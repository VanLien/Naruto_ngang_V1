local var_0_0 = {
	received = 3,
	noReach = 2,
	canReceive = 1
}
local var_0_1 = class("ActivityGeneralTaskView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "activity_general_task.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("datas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				dataOrderCmp = function(arg_1_0, arg_1_1)
					if arg_1_0.state ~= arg_1_1.state then
						return arg_1_0.state < arg_1_1.state
					end

					return arg_1_0.csvId < arg_1_1.csvId
				end,
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_3.cfg
					local var_2_1 = arg_2_1:multiget("list", "num", "receivebtn", "received", "desc", "img")

					uiEasy.createItemsToList(arg_2_0, var_2_1.list, var_2_0.award)

					local var_2_2 = var_2_0.desc

					var_2_1.desc:text(var_2_2)
					var_2_1.num:text("")
					text.addEffect(var_2_1.num, {
						color = ui.COLORS.NORMAL.FRIEND_GREEN
					})

					if arg_2_3.progress then
						var_2_1.num:text(string.format("%d/%d", arg_2_3.progress[1], arg_2_3.progress[2]))
					end

					local var_2_3 = var_2_1.num:width()
					local var_2_4 = var_2_1.desc:width()

					if var_2_3 + var_2_4 > 350 then
						var_2_1.desc:x(var_2_1.num:box().x - 25 - var_2_4)
						var_2_1.img:width(var_2_3 + var_2_4 + 70)
					else
						var_2_1.desc:x(1436)
						var_2_1.img:width(455)
					end

					var_2_1.receivebtn:visible(arg_2_3.state ~= var_0_0.received)
					var_2_1.received:visible(arg_2_3.state == var_0_0.received)
					var_2_1.receivebtn:setTouchEnabled(false)
					cache.setShader(var_2_1.receivebtn, false, "normal")

					local var_2_5 = var_2_1.receivebtn:get("label")

					if arg_2_3.state == var_0_0.canReceive then
						var_2_1.receivebtn:setTouchEnabled(true)
						text.addEffect(var_2_5, {
							color = ui.COLORS.NORMAL.YELLOW,
							outline = {
								size = 4,
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							}
						})
						bind.touch(arg_2_0, var_2_1.receivebtn, {
							methods = {
								ended = functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3)
							}
						})
					elseif arg_2_3.state == var_0_0.noReach then
						text.addEffect(var_2_1.num, {
							color = ui.COLORS.NORMAL.ALERT_ORANGE
						})
						cache.setShader(var_2_1.receivebtn, false, "hsl_gray")
						text.deleteAllEffect(var_2_5)
						text.addEffect(var_2_5, {
							color = ui.COLORS.DISABLED.WHITE
						})
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onReceiveClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1)
	arg_3_0.activityId = arg_3_1

	arg_3_0:initModel()

	local var_3_0 = csv.yunying.yyhuodong[arg_3_1].huodongID

	arg_3_0.datas = idlers.new()

	idlereasy.when(arg_3_0.yyhuodongs, function(arg_4_0, arg_4_1)
		local var_4_0 = (arg_4_1[arg_3_1] or {}).stamps or {}
		local var_4_1 = gGameModel.role:getYYHuoDongTasksProgress(arg_3_1) or {}
		local var_4_2 = {}

		for iter_4_0, iter_4_1 in csvPairs(csv.yunying.generaltask) do
			if iter_4_1.huodongID == var_3_0 then
				local var_4_3 = var_0_0.noReach

				if var_4_0[iter_4_0] == 1 then
					var_4_3 = var_0_0.canReceive
				elseif var_4_0[iter_4_0] == 0 then
					var_4_3 = var_0_0.received
				end

				table.insert(var_4_2, {
					csvId = iter_4_0,
					cfg = iter_4_1,
					state = var_4_3,
					progress = var_4_1[iter_4_0]
				})
			end
		end

		dataEasy.tryCallFunc(arg_3_0.list, "updatePreloadCenterIndex")
		arg_3_0.datas:update(var_4_2)
	end)
end

function var_0_1.initModel(arg_5_0)
	arg_5_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
end

function var_0_1.onReceiveClick(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if arg_6_3.state == var_0_0.canReceive then
		gGameApp:requestServer("/game/yy/award/get", function(arg_7_0)
			gGameUI:showGainDisplay(arg_7_0)
		end, arg_6_0.activityId, arg_6_3.csvId)
	elseif arg_6_3.state == var_0_0.noReach then
		gGameUI:showTip(gLanguageCsv.notReachedCannotGet)
	end
end

return var_0_1
