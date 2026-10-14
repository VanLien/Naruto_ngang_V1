local var_0_0 = 4
local var_0_1 = {
	sellout = 3,
	refresh = 2,
	canbuy = 1
}
local var_0_2 = {
	[0] = {
		logo = "common/icon/sign_blue.png",
		name = gLanguageCsv.discount
	},
	{
		logo = "common/icon/sign_orange.png",
		name = gLanguageCsv.hotness
	},
	{
		logo = "common/icon/sign_purple.png",
		name = gLanguageCsv.limit
	},
	{
		logo = "common/icon/sign_green.png",
		name = gLanguageCsv.new
	}
}
local var_0_3 = class("ActivityItemBuyView", cc.load("mvc").ViewBase)

var_0_3.RESOURCE_FILENAME = "activity_item_buy.json"
var_0_3.RESOURCE_BINDING = {
	subList = "subList",
	item = "item",
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 8,
				data = bindHelper.self("datas"),
				columnSize = var_0_0,
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_3.cfg
					local var_1_1 = arg_1_1:multiget("title", "times", "bottomPanel", "mask", "logo", "logoDesc", "oldPrice")
					local var_1_2 = uiEasy.setIconName(arg_1_3.id, arg_1_3.num)

					var_1_1.title:text(var_1_2)
					adapt.setTextAdaptWithSize(var_1_1.title, {
						margin = -8,
						vertical = "center",
						horizontal = "center",
						maxLine = 2,
						size = cc.size(330, 75)
					})

					local var_1_3 = arg_1_1:size()

					bind.extend(arg_1_0, arg_1_1, {
						class = "icon_key",
						props = {
							data = {
								key = arg_1_3.id,
								num = arg_1_3.num
							},
							onNode = function(arg_2_0)
								arg_2_0:xy(var_1_3.width / 2, var_1_3.height / 2 + 75)
							end
						}
					})
					arg_1_1:removeChildByName("logoLabel")

					if var_1_0.logo then
						var_1_1.logo:show():texture(var_0_2[var_1_0.logo].logo):show()
						var_1_1.logoDesc:show()

						if var_1_0.logo == 0 then
							local var_1_4 = string.format(gLanguageCsv.discount, mathEasy.getPreciseDecimal(var_1_0.rmbCost / var_1_0.rmbShow * 10, 0, true))

							if matchLanguage({
								"kr"
							}) then
								var_1_4 = string.format(gLanguageCsv.discount, (mathEasy.getPreciseDecimal((var_1_0.rmbShow - var_1_0.rmbCost) / var_1_0.rmbShow * 100, 0, true)))

								var_1_1.logoDesc:scale(0.6)
								var_1_1.logo:scale(1.15)
							end

							if matchLanguage({
								"en"
							}) then
								var_1_4 = string.format(gLanguageCsv.discount, (mathEasy.getPreciseDecimal((var_1_0.rmbShow - var_1_0.rmbCost) / var_1_0.rmbShow * 100, 0, true)))

								var_1_1.logoDesc:scale(1.1)
								var_1_1.logo:scale(1.15)
								var_1_1.logoDesc:setTextAreaSize(cc.size(80, 80))
							end

							var_1_1.logoDesc:text(var_1_4)
						else
							var_1_1.logoDesc:text(var_0_2[var_1_0.logo].name)
						end
					else
						var_1_1.logo:hide()
						var_1_1.logoDesc:hide()
					end

					if var_1_0.refresh then
						var_1_1.times:text(string.format(gLanguageCsv.directBuyGiftDailyBuy, arg_1_3.leftTimes, var_1_0.buyMax))
						text.addEffect(var_1_1.times, {
							color = ui.COLORS.QUALITY[5]
						})
					else
						var_1_1.times:text(string.format(gLanguageCsv.directBuyGiftOnetimeBuy, arg_1_3.leftTimes, var_1_0.buyMax))
						text.addEffect(var_1_1.times, {
							color = ui.COLORS.QUALITY[4]
						})
					end

					var_1_1.oldPrice:text(var_1_0.rmbShow)

					local var_1_5 = var_1_1.bottomPanel:get("btn")
					local var_1_6 = var_1_1.bottomPanel:get("price")

					var_1_5:setTouchEnabled(false)
					cache.setShader(var_1_5, false, "normal")
					var_1_6:text(var_1_0.rmbCost)

					if arg_1_3.state == var_0_1.canbuy then
						var_1_1.mask:hide()
						var_1_5:setTouchEnabled(true)
						bind.touch(arg_1_0, var_1_5, {
							methods = {
								ended = functools.partial(arg_1_0.clickCell, t, arg_1_3)
							}
						})
						text.addEffect(var_1_6, {
							color = ui.COLORS.NORMAL.YELLOW,
							outline = {
								color = ui.NEWCOLORS.OUTLINE.YELLOW1
							}
						})
					else
						var_1_1.mask:show()
						cache.setShader(var_1_5, false, "hsl_gray")
						text.deleteAllEffect(var_1_6)
						text.addEffect(var_1_6, {
							color = ui.COLORS.DISABLED.WHITE
						})

						if arg_1_3.state == var_0_1.sellout then
							var_1_1.mask:get("label"):text(gLanguageCsv.sellout)
						else
							var_1_1.mask:get("label"):text(gLanguageCsv.nextDayRefresh5)
						end
					end

					adapt.oneLineCenterPos(cc.p(125, 50), {
						var_1_1.bottomPanel:get("icon"),
						var_1_6
					}, cc.p(15, -5))
				end
			},
			handlers = {
				clickCell = bindHelper.self("onBuyClick")
			}
		}
	}
}

function var_0_3.onCreate(arg_3_0, arg_3_1)
	arg_3_0.activityId = arg_3_1

	arg_3_0:initModel()

	local var_3_0 = csv.yunying.yyhuodong[arg_3_1].huodongID

	arg_3_0.datas = idlers.new()

	idlereasy.when(arg_3_0.yyhuodongs, function(arg_4_0, arg_4_1)
		local var_4_0 = (arg_4_1[arg_3_1] or {}).stamps or {}
		local var_4_1 = {}

		for iter_4_0, iter_4_1 in csvPairs(csv.yunying.itembuy) do
			if iter_4_1.huodongID == var_3_0 then
				local var_4_2 = var_0_1.canbuy
				local var_4_3 = math.max(0, iter_4_1.buyMax - (var_4_0[iter_4_0] or 0))

				if var_4_3 == 0 then
					if iter_4_1.refresh then
						var_4_2 = var_0_1.refresh
					else
						var_4_2 = var_0_1.sellout
					end
				end

				local var_4_4, var_4_5 = csvNext(iter_4_1.item)

				table.insert(var_4_1, {
					csvId = iter_4_0,
					id = var_4_4,
					num = var_4_5,
					cfg = iter_4_1,
					state = var_4_2,
					leftTimes = var_4_3
				})
			end
		end

		table.sort(var_4_1, function(arg_5_0, arg_5_1)
			if arg_5_0.state ~= arg_5_1.state then
				return arg_5_0.state < arg_5_1.state
			end

			return arg_5_0.csvId < arg_5_1.csvId
		end)
		dataEasy.tryCallFunc(arg_3_0.list, "updatePreloadCenterIndex")
		arg_3_0.datas:update(var_4_1)
	end)
end

function var_0_3.initModel(arg_6_0)
	arg_6_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_6_0.rmb = gGameModel.role:getIdler("rmb")
end

function var_0_3.onBuyClick(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_0.rmb:read()
	local var_7_1 = arg_7_3.cfg.rmbCost

	if var_7_0 < var_7_1 then
		uiEasy.showDialog("rmb")
	else
		gGameUI:stackUI("common.buy_info", nil, nil, {
			rmb = var_7_1
		}, {
			id = arg_7_3.id,
			num = arg_7_3.num
		}, {
			contentType = "num",
			maxNum = arg_7_3.leftTimes
		}, arg_7_0:createHandler("getBuyInfoCb", arg_7_3.csvId))
	end
end

function var_0_3.getBuyInfoCb(arg_8_0, arg_8_1, arg_8_2)
	gGameApp:requestServer("/game/yy/award/get", function(arg_9_0)
		gGameUI:showGainDisplay(arg_9_0)
	end, arg_8_0.activityId, arg_8_1, arg_8_2)
end

return var_0_3
