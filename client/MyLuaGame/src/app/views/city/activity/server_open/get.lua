local var_0_0 = {
	received = 3,
	noReach = 2,
	canReceive = 1
}
local var_0_1 = {
	vacation = {
		iconBg = "activity/server_open/summer_vacation/btn_sqqtl_1.png"
	}
}

local function var_0_2(arg_1_0)
	local var_1_0 = arg_1_0.num:x()
	local var_1_1 = arg_1_0.num:size().width + arg_1_0.desc:size().width

	if var_1_1 > 400 then
		arg_1_0.desc:x(var_1_0 - var_1_1 - 10)
		arg_1_0.img:size(var_1_1 + 54, 45)
	else
		arg_1_0.desc:x(var_1_0 - var_1_1 - 10)
		arg_1_0.img:size(440, 45)
	end
end

local var_0_3 = class("ServerOpenGetView", cc.load("mvc").ViewBase)

var_0_3.RESOURCE_FILENAME = "activity_server_open_get.json"
var_0_3.RESOURCE_BINDING = {
	item = "item",
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				data = bindHelper.self("datas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true,
					alwaysShow = true
				},
				dataOrderCmp = function(arg_2_0, arg_2_1)
					if arg_2_0.state ~= arg_2_1.state then
						return arg_2_0.state < arg_2_1.state
					end

					return arg_2_0.id < arg_2_1.id
				end,
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_3.cfg
					local var_3_1 = arg_3_1:multiget("list", "num", "receivebtn", "received", "desc", "img")

					uiEasy.createItemsToList(arg_3_0, var_3_1.list, var_3_0.award)
					var_3_1.desc:text(var_3_0.desc)
					var_3_1.num:text("")
					text.addEffect(var_3_1.num, {
						color = ui.COLORS.NORMAL.FRIEND_GREEN
					})

					if arg_3_3.progress then
						var_3_1.num:text(string.format("%d/%d", arg_3_3.progress[1], arg_3_3.progress[2]))
					end

					var_0_2(var_3_1)

					if arg_3_3.clientType then
						for iter_3_0, iter_3_1 in pairs(var_0_1) do
							if iter_3_0 == arg_3_3.clientType then
								var_3_1.receivebtn:loadTextureNormal(iter_3_1.iconBg)
								var_3_1.receivebtn:scale(2)
								var_3_1.receivebtn:size(135, 55)
								var_3_1.receivebtn:get("label"):scale(0.5)
								var_3_1.receivebtn:get("label"):xy(67, 27)
							end
						end
					end

					var_3_1.receivebtn:visible(arg_3_3.state ~= var_0_0.received)
					var_3_1.received:visible(arg_3_3.state == var_0_0.received)
					var_3_1.receivebtn:setTouchEnabled(false)
					cache.setShader(var_3_1.receivebtn, false, "normal")

					local var_3_2 = var_3_1.receivebtn:get("label")

					if arg_3_3.state == var_0_0.canReceive then
						var_3_1.receivebtn:setTouchEnabled(true)
						text.addEffect(var_3_2, {
							color = ui.COLORS.NORMAL.BROWN,
							outline = {
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							}
						})
						bind.touch(arg_3_0, var_3_1.receivebtn, {
							methods = {
								ended = functools.partial(arg_3_0.clickCell, arg_3_2, arg_3_3)
							}
						})
					elseif arg_3_3.state == var_0_0.noReach then
						text.addEffect(var_3_1.num, {
							color = ui.COLORS.NORMAL.ALERT_ORANGE
						})
						cache.setShader(var_3_1.receivebtn, false, "hsl_gray")
						text.deleteAllEffect(var_3_2)
						text.addEffect(var_3_2, {
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

function var_0_3.onCreate(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	arg_4_0:initModel()

	arg_4_0.data = arg_4_2
	arg_4_0.currDay, arg_4_0.showTab, arg_4_0.tabIndex = arg_4_3()

	local var_4_0 = csv.yunying.yyhuodong[arg_4_1].huodongID

	if not arg_4_0.datas then
		arg_4_0.datas = idlers.new()
	end

	arg_4_0.activityId = arg_4_1
	arg_4_0.clientType = csv.yunying.yyhuodong[arg_4_1].clientParam.type

	idlereasy.any({
		arg_4_0.yyhuodongs,
		arg_4_0.currDay,
		arg_4_0.showTab,
		arg_4_0.tabIndex
	}, function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		if arg_5_4 == -1 then
			return
		end

		local var_5_0 = (arg_5_1[arg_4_0.activityId] or {}).stamps or {}
		local var_5_1 = clone(arg_4_0.data[arg_5_3][arg_5_4])

		if var_5_1 then
			local var_5_2 = gGameModel.role:getYYHuoDongTasksProgress(arg_4_0.activityId) or {}

			for iter_5_0 = 1, #var_5_1 do
				local var_5_3 = var_0_0.noReach

				if var_5_1[iter_5_0].cfg.taskType == game.TARGET_TYPE.CompleteImmediate then
					if arg_5_2 < arg_5_3 then
						var_5_1[iter_5_0].progress = {
							0,
							1
						}
					else
						var_5_1[iter_5_0].progress = {
							1,
							1
						}
					end
				elseif var_5_2[var_5_1[iter_5_0].id] then
					var_5_1[iter_5_0].progress = var_5_2[var_5_1[iter_5_0].id]
				end

				if not var_5_0[var_5_1[iter_5_0].id] then
					var_5_1[iter_5_0].state = var_0_0.noReach
				elseif var_5_0[var_5_1[iter_5_0].id] == 1 then
					var_5_1[iter_5_0].state = var_0_0.canReceive
				elseif var_5_0[var_5_1[iter_5_0].id] == 0 then
					var_5_1[iter_5_0].state = var_0_0.received
				end

				var_5_1[iter_5_0].clientType = arg_4_0.clientType
			end

			arg_4_0.datas:update(var_5_1)
		end
	end)
end

function var_0_3.initModel(arg_6_0)
	arg_6_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
end

function var_0_3.onReceiveClick(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	if arg_7_3.state == var_0_0.canReceive then
		dataEasy.tryCallFunc(arg_7_0.list, "setItemAction", {
			isAction = false
		})
		gGameApp:requestServer("/game/yy/award/get", function(arg_8_0)
			gGameUI:showGainDisplay(arg_8_0, {
				cb = function()
					performWithDelay(arg_7_0, function()
						dataEasy.tryCallFunc(arg_7_0.list, "setItemAction", {
							isAction = true,
							alwaysShow = true
						})
					end, 0.1)
				end
			})
		end, arg_7_0.activityId, arg_7_3.id)
	elseif arg_7_3.state == var_0_0.noReach then
		gGameUI:showTip(gLanguageCsv.notReachedCannotGet)
	end
end

return var_0_3
