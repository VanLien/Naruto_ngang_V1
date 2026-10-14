local var_0_0 = {
	sellout = 3,
	refresh = 2,
	canbuy = 1
}
local var_0_1 = class("ActivityBuyGiftView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "direct_buy_gift.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				data = bindHelper.self("datas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				dataOrderCmp = function(arg_1_0, arg_1_1)
					if arg_1_0.state ~= arg_1_1.state then
						return arg_1_0.state < arg_1_1.state
					end

					if arg_1_0.sort ~= arg_1_1.sort then
						return arg_1_0.sort < arg_1_1.sort
					end

					return arg_1_0.csvId < arg_1_1.csvId
				end,
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_3.cfg
					local var_2_1 = arg_2_1:multiget("title", "times", "bottomPanel", "mask", "list", "subList", "item")

					var_2_1.title:text(var_2_0.name)

					if var_2_0.refresh then
						var_2_1.times:text(string.format(gLanguageCsv.directBuyGiftDailyBuy, arg_2_3.leftTimes, var_2_0.limit))
						text.addEffect(var_2_1.times, {
							color = ui.COLORS.QUALITY[5]
						})
					else
						local var_2_2 = gLanguageCsv.directBuyGiftOnetimeBuy

						if arg_2_3.status == 1 then
							var_2_2 = gLanguageCsv.directBuyGiftWeek
						elseif arg_2_3.status == 2 then
							var_2_2 = gLanguageCsv.directBuyGiftMonth
						end

						var_2_1.times:text(string.format(var_2_2, arg_2_3.leftTimes, var_2_0.limit))
						text.addEffect(var_2_1.times, {
							color = ui.COLORS.QUALITY[4]
						})
					end

					var_2_1.list:removeAllChildren()
					var_2_1.list:setScrollBarEnabled(false)
					var_2_1.list:setGravity(ccui.ListViewGravity.bottom)

					local var_2_3
					local var_2_4 = 0
					local var_2_5 = csvSize(var_2_0.item) == 1 and var_2_1.item:size().width / 2 or 0

					for iter_2_0, iter_2_1 in ipairs(dataEasy.getItemData(var_2_0.item)) do
						local var_2_6 = iter_2_1.key
						local var_2_7 = iter_2_1.num

						var_2_4 = var_2_4 + 1

						if var_2_4 % 2 == 1 then
							var_2_3 = var_2_1.subList:clone():show():tag(math.floor(var_2_4 / 2 + 1))

							var_2_3:setScrollBarEnabled(false)
							var_2_3:setTouchEnabled(false)
							var_2_1.list:pushBackCustomItem(var_2_3)
						end

						local var_2_8 = var_2_1.item:clone():show()
						local var_2_9 = var_2_8:size()

						bind.extend(arg_2_0, var_2_8, {
							class = "icon_key",
							props = {
								data = {
									key = var_2_6,
									num = var_2_7
								},
								onNode = function(arg_3_0)
									arg_3_0:xy(var_2_9.width / 2 + var_2_5, var_2_9.height / 2):scale(0.9)
								end
							}
						})
						var_2_3:pushBackCustomItem(var_2_8)
					end

					var_2_1.list:adaptTouchEnabled():setItemAlignCenter()

					local var_2_10 = var_2_1.bottomPanel:get("btn")
					local var_2_11 = var_2_1.bottomPanel:get("panel"):get("price")
					local var_2_12 = var_2_1.bottomPanel:get("panel"):get("rmb")

					var_2_12:visible(false)
					var_2_10:setTouchEnabled(false)
					cache.setShader(var_2_10, false, "normal")

					if arg_2_3.rmb then
						var_2_11:text(arg_2_3.rmb)

						local var_2_13 = 40

						if type(arg_2_3.rmb) ~= "string" then
							var_2_12:visible(true)
							var_2_11:x(var_2_12:width() / 2 + var_2_11:width() / 2 + var_2_12:x())

							var_2_13 = 70
						end

						var_2_1.bottomPanel:get("panel"):width(var_2_11:width() + var_2_12:width())
						var_2_1.bottomPanel:get("panel"):x(var_2_10:x() - var_2_13)
					elseif arg_2_3.price then
						var_2_11:text(string.format(gLanguageCsv.symbolMoney, arg_2_3.price))
					end

					local var_2_14 = arg_2_3.rmb and type(arg_2_3.rmb) == "string" and true or false

					if arg_2_3.state == var_0_0.canbuy then
						var_2_1.mask:hide()
						var_2_10:setTouchEnabled(true)
						bind.touch(arg_2_0, var_2_10, {
							clicksafe = true,
							methods = {
								ended = functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3)
							}
						})
						text.addEffect(var_2_11, {
							outline = {
								size = 1,
								color = ui.NEWCOLORS.OUTLINE.YELLOW1
							}
						})
					else
						var_2_1.mask:show()

						var_2_14 = false

						cache.setShader(var_2_10, false, "hsl_gray")
						text.deleteAllEffect(var_2_11)
						text.addEffect(var_2_11, {
							color = ui.COLORS.DISABLED.WHITE
						})

						if arg_2_3.state == var_0_0.sellout then
							var_2_1.mask:get("label"):text(gLanguageCsv.sellout)
						else
							var_2_1.mask:get("label"):text(gLanguageCsv.nextDayRefresh5)
						end
					end

					local var_2_15 = {
						class = "red_hint",
						props = {
							state = var_2_14,
							onNode = function(arg_4_0)
								arg_4_0:xy(330, 100)
							end
						}
					}

					bind.extend(arg_2_0, var_2_1.bottomPanel, var_2_15)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onBuyClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_5_0, arg_5_1)
	arg_5_0.activityId = arg_5_1

	arg_5_0:initModel()
	gGameModel.currday_dispatch:getIdlerOrigin("activityDirectBuyGift"):set(true)

	local var_5_0 = csv.yunying.yyhuodong[arg_5_1].huodongID

	arg_5_0.datas = idlers.new()
	arg_5_0.clientBuyTimes = idler.new(true)

	idlereasy.any({
		arg_5_0.yyhuodongs,
		arg_5_0.clientBuyTimes
	}, function(arg_6_0, arg_6_1)
		local var_6_0 = (arg_6_1[arg_5_1] or {}).stamps or {}
		local var_6_1 = {}

		for iter_6_0, iter_6_1 in csvPairs(csv.yunying.directbuygift) do
			if iter_6_1.huodongID == var_5_0 and arg_5_0.level >= iter_6_1.levelLimit then
				local var_6_2 = var_0_0.canbuy
				local var_6_3 = var_6_0[iter_6_0] or 0
				local var_6_4 = dataEasy.getPayClientBuyTimes("directBuyData", arg_5_1, iter_6_0, var_6_3)
				local var_6_5 = math.max(0, iter_6_1.limit - var_6_4)

				if var_6_5 == 0 then
					if iter_6_1.refresh then
						var_6_2 = var_0_0.refresh
					else
						var_6_2 = var_0_0.sellout
					end
				end

				local var_6_6
				local var_6_7
				local var_6_8
				local var_6_9 = iter_6_1.status

				if iter_6_1.rmbCost == 0 then
					var_6_6 = gLanguageCsv.freeToReceive
				elseif iter_6_1.rmbCost >= 1 then
					var_6_6 = iter_6_1.rmbCost
				else
					var_6_7 = csv.recharges[iter_6_1.rechargeID].rmbDisplay
				end

				table.insert(var_6_1, {
					csvId = iter_6_0,
					cfg = iter_6_1,
					state = var_6_2,
					buyTimes = var_6_4,
					leftTimes = var_6_5,
					price = var_6_7,
					rmb = var_6_6,
					status = var_6_9,
					sort = iter_6_1.sort
				})
			end
		end

		dataEasy.tryCallFunc(arg_5_0.list, "updatePreloadCenterIndex")
		arg_5_0.datas:update(var_6_1)
	end)
end

function var_0_1.initModel(arg_7_0)
	arg_7_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_7_0.level = gGameModel.role:read("level")
end

function var_0_1.onBuyClick(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if not arg_8_3.rmb then
		gGameApp:payDirect(arg_8_0, {
			rechargeId = arg_8_3.cfg.rechargeID,
			yyID = arg_8_0.activityId,
			csvID = arg_8_3.csvId,
			name = arg_8_3.cfg.name,
			buyTimes = arg_8_3.buyTimes
		}, arg_8_0.clientBuyTimes):serverCb(function()
			local var_9_0 = csv.yunying.directbuygift[arg_8_3.csvId]

			gGameUI:showGainDisplay(var_9_0.item, {
				raw = false
			})
		end):doit()
	else
		gGameApp:requestServer("/game/yy/award/get", function(arg_10_0)
			arg_8_0.clientBuyTimes:notify()

			local var_10_0 = csv.yunying.directbuygift[arg_8_3.csvId]

			gGameUI:showGainDisplay(var_10_0.item, {
				raw = false
			})
		end, arg_8_0.activityId, arg_8_3.csvId)
	end
end

return var_0_1
