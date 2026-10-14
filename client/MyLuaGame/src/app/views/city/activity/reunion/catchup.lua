local var_0_0 = {
	times = 2,
	days = 1
}
local var_0_1 = {
	finished = 2,
	goJump = 1
}
local var_0_2 = class("ReunionCatchUpView", cc.load("mvc").ViewBase)

var_0_2.RESOURCE_FILENAME = "reunion_catch.json"
var_0_2.RESOURCE_BINDING = {
	item = "item",
	["item.goPanel.label"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
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
				asyncPreload = 3,
				data = bindHelper.self("datas"),
				item = bindHelper.self("item"),
				dataOrderCmp = function(arg_1_0, arg_1_1)
					return arg_1_0.csvId < arg_1_1.csvId
				end,
				itemAction = {
					isAction = true
				},
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_3.cfg
					local var_2_1 = arg_2_1:multiget("list", "title", "label1", "time", "bodyList", "remarkList", "goPanel", "completed")

					var_2_1.completed:visible(arg_2_3.state == var_0_1.finished)
					var_2_1.goPanel:visible(arg_2_3.state == var_0_1.goJump)

					if var_2_0.goTo == "" then
						var_2_1.goPanel:visible(false)
					end

					bind.touch(arg_2_0, var_2_1.goPanel, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, var_2_0.goTo)
						}
					})
					var_2_1.title:text(var_2_0.title)

					if var_2_0.addType == var_0_0.days then
						var_2_1.label1:text(gLanguageCsv.reunionCatchUpCutdown)

						local var_2_2 = time.getNumTimestamp(arg_2_3.finishTimes, time.getRefreshHour()) - time.getTime()

						var_0_2.setCountdown(arg_2_0, var_2_2, var_2_1.time, var_2_1.completed, var_2_1.goPanel, {
							tag = arg_2_2,
							v = arg_2_3
						})
					elseif var_2_0.addType == var_0_0.times then
						var_2_1.label1:text(gLanguageCsv.reunionCatchUpTimes)
						var_2_1.time:text(string.format(gLanguageCsv.reunionCatchUpText, var_2_0.addNum, arg_2_3.finishTimes))
					end

					beauty.textScroll({
						isRich = true,
						fontSize = 36,
						list = var_2_1.bodyList,
						strs = "#C0xFF57472E#" .. var_2_0.desc
					})
					beauty.textScroll({
						fontSize = 36,
						isRich = true,
						verticalSpace = 10,
						list = var_2_1.remarkList,
						strs = "#C0xFF57472E#" .. var_2_0.remark
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onJumpTo")
			}
		}
	}
}

function var_0_2.onCreate(arg_3_0, arg_3_1)
	local var_3_0 = csv.yunying.yyhuodong[arg_3_1]

	arg_3_0:initModel()

	arg_3_0.datas = idlers.new()

	idlereasy.when(arg_3_0.reunion, function(arg_4_0, arg_4_1)
		local var_4_0 = arg_4_1.catchup or {}
		local var_4_1 = {}

		for iter_4_0, iter_4_1 in csvPairs(csv.yunying.reunion_catchup) do
			if iter_4_1.huodongID == var_3_0.huodongID then
				local var_4_2 = var_0_1.goJump
				local var_4_3 = 0

				if iter_4_1.addType == var_0_0.times and var_4_0[iter_4_0] then
					if var_4_0[iter_4_0] >= iter_4_1.addNum then
						var_4_2 = var_0_1.finished
					end

					var_4_3 = var_4_0[iter_4_0]
				elseif iter_4_1.addType == var_0_0.days then
					local var_4_4 = tonumber(arg_3_0:getStrInClock(math.floor(arg_4_1.info.reunion_time))) + iter_4_1.addNum

					if var_4_4 <= tonumber(time.getTodayStrInClock()) then
						var_4_2 = var_0_1.finished
					end

					var_4_3 = var_4_4
				end

				table.insert(var_4_1, {
					csvId = iter_4_0,
					cfg = iter_4_1,
					state = var_4_2,
					finishTimes = var_4_3
				})
			end
		end

		arg_3_0.datas:update(var_4_1)
	end)
end

function var_0_2.getStrInClock(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_1 and time.getDate(arg_5_1) or time.getTimeTable()
	local var_5_1 = time.getRefreshHour()
	local var_5_2 = 0

	if var_5_0.hour * 100 + var_5_0.min < var_5_1 * 100 + var_5_2 then
		local var_5_3 = arg_5_1 - 86400

		var_5_0 = time.getDate(var_5_3)
	end

	return string.format("%04d%02d%02d", var_5_0.year, var_5_0.month, var_5_0.day)
end

function var_0_2.initModel(arg_6_0)
	arg_6_0.reunion = gGameModel.role:getIdler("reunion")
end

function var_0_2.onJumpTo(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_2 ~= "" then
		jumpEasy.jumpTo(arg_7_2)
	end
end

function var_0_2.setCountdown(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	arg_8_5 = arg_8_5 or {}

	local var_8_0 = arg_8_5.tag or 1

	arg_8_0:enableSchedule():unSchedule(var_8_0)

	arg_8_1 = arg_8_1 > 0 and arg_8_1 or 0

	bind.extend(arg_8_0, arg_8_2, {
		class = "cutdown_label",
		props = {
			time = arg_8_1,
			tag = var_8_0,
			strFunc = function(arg_9_0)
				return arg_9_0.str
			end,
			callFunc = function()
				return
			end,
			endFunc = function()
				arg_8_1 = arg_8_5.v.finishTimes + arg_8_5.v.cfg.addNum * 86400 - time.getTime()

				if arg_8_1 > 0 then
					performWithDelay(arg_8_0, function()
						var_0_2.setCountdown(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
					end, 1)
				else
					arg_8_2:text(gLanguageCsv.activityOver)
					arg_8_3:visible(true)
					arg_8_4:visible(false)
				end
			end,
			onNode = function(arg_13_0)
				return
			end
		}
	})
end

return var_0_2
