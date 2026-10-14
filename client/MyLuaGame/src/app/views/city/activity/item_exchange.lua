local var_0_0 = {
	noReach = 2,
	canExchange = 1,
	exchanged = 3
}
local var_0_1 = class("ActivityItemExchangeView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "activity_item_exchange.json"
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
					local var_2_1 = arg_2_1:multiget("list", "item", "img", "checkPanel", "exchangebtn", "exchanged", "times")

					var_2_1.list:size(1100, 200)
					uiEasy.createItemsToList(arg_2_0, var_2_1.list, arg_2_3.costMap, {
						padding = 5
					})

					local var_2_2 = cc.p(100, 100)
					local var_2_3, var_2_4 = var_2_1.list:xy()
					local var_2_5 = var_2_3 + math.min(var_2_1.list:getInnerItemSize().width, var_2_1.list:size().width)

					var_2_1.img:x(var_2_5 + 150)
					bind.extend(arg_2_0, arg_2_1, {
						class = "icon_key",
						props = {
							data = {
								key = arg_2_3.key,
								num = arg_2_3.num
							},
							onNode = function(arg_3_0)
								arg_3_0:xy(var_2_5 + 300 + var_2_2.x, var_2_4 + var_2_2.y):z(5)
							end
						}
					})
					itertools.invoke({
						var_2_1.checkPanel,
						var_2_1.exchangebtn,
						var_2_1.times
					}, "visible", arg_2_3.state ~= var_0_0.exchanged)
					var_2_1.exchanged:visible(arg_2_3.state == var_0_0.exchanged)
					var_2_1.checkPanel:get("checkBox"):setSelectedState(arg_2_3.remind)
					var_2_1.checkPanel:onClick(functools.partial(arg_2_0.remindClick, arg_2_2, arg_2_3))
					var_2_1.times:text(string.format(gLanguageCsv.canExchangeTImes, var_2_0.exchangeTimes - arg_2_3.cnt, var_2_0.exchangeTimes))

					if matchLanguage({
						"en"
					}) then
						var_2_1.times:x(var_2_1.times:x() - 60)
					end

					if arg_2_3.state == var_0_0.canExchange then
						cache.setShader(var_2_1.exchangebtn, false, "normal")
						text.addEffect(var_2_1.exchangebtn:get("label"), {
							color = ui.COLORS.NORMAL.YELLOW,
							outline = {
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							}
						})
					elseif arg_2_3.state == var_0_0.noReach then
						cache.setShader(var_2_1.exchangebtn, false, "hsl_gray")
						text.deleteAllEffect(var_2_1.exchangebtn:get("label"))
						text.addEffect(var_2_1.exchangebtn:get("label"), {
							color = ui.COLORS.DISABLED.WHITE
						})
					end

					bind.touch(arg_2_0, var_2_1.exchangebtn, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3)
						}
					})
				end
			},
			handlers = {
				remindClick = bindHelper.self("onRemindClick"),
				clickCell = bindHelper.self("onExchangeClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_4_0, arg_4_1)
	arg_4_0.activityId = arg_4_1

	arg_4_0:initModel()

	local var_4_0 = csv.yunying.yyhuodong[arg_4_1].huodongID

	arg_4_0.datas = idlers.new()
	arg_4_0.remind = idler.new(false)

	idlereasy.any({
		arg_4_0.yyhuodongs,
		arg_4_0.remind
	}, function(arg_5_0, arg_5_1)
		local var_5_0 = userDefault.getForeverLocalKey("activityItemExchange", {})

		arg_4_0.remindData = var_5_0[arg_4_1] or {}

		local var_5_1 = (arg_5_1[arg_4_1] or {}).stamps or {}
		local var_5_2 = {}

		for iter_5_0, iter_5_1 in csvPairs(csv.yunying.itemexchange) do
			if iter_5_1.huodongID == var_4_0 then
				local var_5_3 = var_0_0.noReach
				local var_5_4 = var_5_1[iter_5_0] or 0
				local var_5_5 = true
				local var_5_6 = {}

				for iter_5_2, iter_5_3 in csvMapPairs(iter_5_1.costMap) do
					local var_5_7 = dataEasy.getNumByKey(iter_5_2)

					table.insert(var_5_6, {
						key = iter_5_2,
						num = var_5_7,
						targetNum = iter_5_3
					})

					if var_5_7 < iter_5_3 then
						var_5_5 = false
					end
				end

				if var_5_4 >= iter_5_1.exchangeTimes then
					var_5_3 = var_0_0.exchanged
				elseif var_5_5 then
					var_5_3 = var_0_0.canExchange
				end

				local var_5_8, var_5_9 = csvNext(iter_5_1.items)

				table.insert(var_5_2, {
					csvId = iter_5_0,
					cfg = iter_5_1,
					key = var_5_8,
					num = var_5_9,
					state = var_5_3,
					cnt = var_5_4,
					cost = iter_5_1.costMap,
					costMap = var_5_6,
					remind = arg_4_0.remindData[iter_5_0] or false
				})
			end
		end

		dataEasy.tryCallFunc(arg_4_0.list, "updatePreloadCenterIndex")
		arg_4_0.datas:update(var_5_2)
	end)
end

function var_0_1.initModel(arg_6_0)
	arg_6_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
end

function var_0_1.onRemindClick(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = not arg_7_3.remind
	local var_7_1 = userDefault.getForeverLocalKey("activityItemExchange", {})

	arg_7_0.remindData[arg_7_3.csvId] = var_7_0
	var_7_1[arg_7_0.activityId] = arg_7_0.remindData

	gGameModel.forever_dispatch:getIdlerOrigin("activityItemExchange"):set(var_7_1, true)

	arg_7_0.datas:atproxy(arg_7_2).remind = var_7_0
end

function var_0_1.onExchangeClick(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if arg_8_3.state == var_0_0.canExchange then
		local var_8_0 = arg_8_3.cfg.exchangeTimes - arg_8_3.cnt

		gGameUI:stackUI("common.buy_info", nil, nil, arg_8_3.cost, {
			id = arg_8_3.key,
			num = arg_8_3.num
		}, {
			flag = "exchange",
			contentType = "num",
			maxNum = var_8_0
		}, arg_8_0:createHandler("getBuyInfoCb", arg_8_3.csvId))
	elseif arg_8_3.state == var_0_0.noReach then
		gGameUI:showTip(gLanguageCsv.exchangeItemNotEnough)
	end
end

function var_0_1.getBuyInfoCb(arg_9_0, arg_9_1, arg_9_2)
	gGameApp:requestServer("/game/yy/award/get", function(arg_10_0)
		gGameUI:showGainDisplay(arg_10_0)
	end, arg_9_0.activityId, arg_9_1, arg_9_2)
end

function var_0_1.remindUpdata(arg_11_0)
	arg_11_0.remind:set(true, true)
end

return var_0_1
