local var_0_0 = {
	sellout = 3,
	refresh = 2,
	canbuy = 1
}
local var_0_1 = class("CouponShop", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "coupon_shop.json"
var_0_1.RESOURCE_BINDING = {
	time = "time",
	["singlePanel.subList"] = "singleSublist",
	["couponPanel.text"] = "couponText",
	singlePanel = "singlePanel",
	["singlePanel.item"] = "singleItem",
	["singlePanel.centerList"] = {
		varname = "singleList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 4,
				asyncPreload = 12,
				data = bindHelper.self("singleDatas"),
				item = bindHelper.self("singleSublist"),
				cell = bindHelper.self("singleItem"),
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
				onCell = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_3.cfg
					local var_2_1 = arg_2_1:multiget("title", "tip", "mask", "item", "icon", "num", "btnBuy")
					local var_2_2, var_2_3 = uiEasy.setIconName(arg_2_3.id, arg_2_3.num)

					var_2_1.title:text(var_2_2)

					if matchLanguage({
						"en",
						"kr"
					}) then
						adapt.setTextAdaptWithSize(var_2_1.title, {
							margin = -5,
							vertical = "center",
							horizontal = "center",
							maxLine = 2,
							size = cc.size(arg_2_1:width() - 150, 120)
						})
					end

					text.addEffect(var_2_1.title, var_2_3)

					if var_2_0.refresh then
						var_2_1.tip:text(string.format(gLanguageCsv.directBuyGiftDailyBuy, arg_2_3.leftTimes, var_2_0.buyMax))
					else
						var_2_1.tip:text(string.format(gLanguageCsv.directBuyGiftOnetimeBuy, arg_2_3.leftTimes, var_2_0.buyMax))
						text.addEffect(var_2_1.tip, {
							color = ui.COLORS.QUALITY[4]
						})
					end

					bind.extend(arg_2_0, var_2_1.icon, {
						class = "icon_key",
						props = {
							simpleShow = true,
							data = {
								key = arg_2_3.id,
								num = arg_2_3.id == "card" and arg_2_3.num or nil
							},
							onNode = function(arg_3_0)
								arg_3_0:scale(1.2)
							end
						}
					})

					if arg_2_3.id ~= "card" then
						var_2_1.num:text("x" .. arg_2_3.num):show()
					else
						var_2_1.num:hide()
					end

					local var_2_4 = var_2_1.btnBuy
					local var_2_5 = var_2_1.btnBuy:get("text")
					local var_2_6 = var_2_1.btnBuy:get("coupon")

					var_2_4:setTouchEnabled(false)
					cache.setShader(var_2_4, false, "normal")
					var_2_5:text(arg_2_3.costNum)

					local var_2_7 = var_2_6:getBoundingBox()
					local var_2_8 = var_2_5:size()

					var_2_6:x(var_2_4:width() / 2 - var_2_7.width - var_2_8.width / 2 + 20)
					adapt.oneLinePos(var_2_6, var_2_5, cc.p(10, 0), "left")

					if arg_2_3.state == var_0_0.canbuy then
						var_2_1.mask:hide()
						var_2_4:setTouchEnabled(true)
						bind.touch(arg_2_0, var_2_4, {
							clicksafe = true,
							methods = {
								ended = functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3)
							}
						})
						text.addEffect(var_2_5, {
							outline = {
								size = 10,
								color = cc.c4b(129, 61, 45, 25)
							},
							color = ui.COLORS.NORMAL.WHITE,
							glow = {
								color = ui.COLORS.GLOW.WHITE
							}
						})
					else
						var_2_1.mask:show()
						cache.setShader(var_2_4, false, "hsl_gray")
						text.deleteAllEffect(var_2_5)
						text.addEffect(var_2_5, {
							color = ui.COLORS.DISABLED.WHITE
						})

						if arg_2_3.state == var_0_0.sellout then
							var_2_1.mask:get("label"):text(gLanguageCsv.sellout)
						else
							var_2_1.mask:get("label"):text(gLanguageCsv.nextDayRefresh5)
						end
					end

					arg_2_0:setRenderHint(0)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onBuyClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_4_0, arg_4_1)
	arg_4_0.activityId = arg_4_1

	arg_4_0:initTitle()
	arg_4_0:initModel()
	arg_4_0:initCountDown()
	arg_4_0:initData()

	arg_4_0.couponNum = 0

	local var_4_0 = csv.yunying.yyhuodong[arg_4_0.activityId].huodongID

	arg_4_0.clientBuyTimes = idler.new(true)

	idlereasy.any({
		arg_4_0.yyhuodongs,
		arg_4_0.clientBuyTimes
	}, function(arg_5_0, arg_5_1, arg_5_2)
		local var_5_0 = (arg_5_1[arg_4_0.activityId] or {}).stamps or {}
		local var_5_1 = {}

		for iter_5_0, iter_5_1 in csvPairs(csv.yunying.itembuy2) do
			if iter_5_1.huodongID == var_4_0 then
				local var_5_2 = var_0_0.canbuy
				local var_5_3 = math.max(0, iter_5_1.buyMax - (var_5_0[iter_5_0] or 0))

				if var_5_3 == 0 then
					if iter_5_1.refresh then
						var_5_2 = var_0_0.refresh
					else
						var_5_2 = var_0_0.sellout
					end
				end

				local var_5_4, var_5_5 = csvNext(iter_5_1.item)
				local var_5_6, var_5_7 = csvNext(iter_5_1.costMap)

				table.insert(var_5_1, {
					csvId = iter_5_0,
					id = var_5_4,
					num = var_5_5,
					costId = var_5_6,
					costNum = var_5_7,
					cfg = iter_5_1,
					state = var_5_2,
					leftTimes = var_5_3
				})
			end
		end

		table.sort(var_5_1, function(arg_6_0, arg_6_1)
			if arg_6_0.state ~= arg_6_1.state then
				return arg_6_0.state < arg_6_1.state
			end

			return arg_6_0.csvId < arg_6_1.csvId
		end)
		dataEasy.tryCallFunc(arg_4_0.singleList, "updatePreloadCenterIndex")
		arg_4_0.singleDatas:update(var_5_1)

		local var_5_8 = dataEasy.getNumByKey(arg_4_0.itemID)

		arg_4_0.couponNum = var_5_8

		arg_4_0.couponText:text(arg_4_0.couponNum)
	end)
end

function var_0_1.initModel(arg_7_0)
	arg_7_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_7_0.yyOpen = gGameModel.role:getIdler("yy_open")
	arg_7_0.singleDatas = idlers.new()
end

function var_0_1.initData(arg_8_0)
	arg_8_0.itemID = 6393
end

function var_0_1.initTitle(arg_9_0)
	gGameUI.topuiManager:createView("title", arg_9_0, {
		onClose = arg_9_0:createHandler("onClose")
	}):init({
		subTitle = "ACTIVITY SHOP",
		title = gLanguageCsv.couponShop
	})
end

function var_0_1.onBuyClick(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if arg_10_0.couponNum < arg_10_3.cfg.costMap[arg_10_3.costId] then
		uiEasy.showDialog(arg_10_0.itemID)

		return
	end

	gGameUI:stackUI("common.buy_info", nil, nil, arg_10_3.cfg.costMap, {
		id = arg_10_3.id,
		num = arg_10_3.num
	}, {
		contentType = "slider",
		style = 2,
		maxNum = arg_10_3.leftTimes
	}, arg_10_0:createHandler("getBuyInfoCb", arg_10_3.csvId))
end

function var_0_1.getBuyInfoCb(arg_11_0, arg_11_1, arg_11_2)
	gGameApp:requestServer("/game/yy/award/get", function(arg_12_0)
		gGameUI:showGainDisplay(arg_12_0)
	end, arg_11_0.activityId, arg_11_1, arg_11_2)
end

function var_0_1.initCountDown(arg_13_0)
	local var_13_0 = arg_13_0.time
	local var_13_1 = gGameModel.role:read("yy_endtime")[arg_13_0.activityId] or 0

	bind.extend(arg_13_0, var_13_0, {
		class = "cutdown_label",
		props = {
			endTime = var_13_1,
			endFunc = function()
				arg_13_0.time:text(gLanguageCsv.activityOver)
			end
		}
	})
end

return var_0_1
