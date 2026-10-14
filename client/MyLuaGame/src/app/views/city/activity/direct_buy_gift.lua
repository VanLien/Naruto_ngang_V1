local var_0_0 = {
	sellout = 3,
	refresh = 2,
	canbuy = 1
}
local var_0_1 = require("app.views.city.activity.view")
local var_0_2 = class("ActivityDirectBuyGiftView", cc.load("mvc").ViewBase)

var_0_2.RESOURCE_FILENAME = "activity_direct_buy_gift.json"
var_0_2.RESOURCE_BINDING = {
	icon404 = "icon404",
	item = "item",
	bg404 = "bg404",
	listitem = "listitem",
	rightBg = "rightBg",
	time = "time",
	["rightPanel.item"] = "rightItem",
	icon = "icon",
	rightPanel = "rightPanel",
	["rightPanel.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("rightData"),
				item = bindHelper.self("rightItem"),
				showTab = bindHelper.self("showTab"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("normal")
					local var_1_1 = arg_1_1:get("selected")
					local var_1_2
					local var_1_3

					if arg_1_3.select then
						var_1_0:hide()

						var_1_2 = var_1_1:show()
						var_1_3 = "name"
					else
						var_1_1:hide()

						var_1_2 = var_1_0:show()
						var_1_3 = "normal.name"
					end

					var_1_2:get(var_1_3):text(arg_1_3.desc)

					if matchLanguage({
						"kr"
					}) then
						adapt.setTextScaleWithWidth(var_1_2:get(var_1_3), nil, 250)
					elseif matchLanguage({
						"en"
					}) then
						adapt.setTextAdaptWithSize(var_1_2:get(var_1_3), {
							margin = -5,
							vertical = "center",
							horizontal = "center",
							maxLine = 2,
							size = cc.size(255, 70)
						})
					end

					bind.extend(arg_1_0, arg_1_1, {
						class = "red_hint",
						props = {
							specialTag = "activityDirectBuyGiftExternal",
							state = arg_1_0.showTab:read() ~= arg_1_2,
							listenData = {
								id = arg_1_3.id,
								huodongID = csv.yunying.yyhuodong[arg_1_3.id].huodongID
							},
							onNode = function(arg_2_0)
								arg_2_0:xy(280, 120)
							end
						}
					})
					bind.touch(arg_1_0, var_1_0, {
						methods = {
							ended = functools.partial(arg_1_0.clickCellItem, arg_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				clickCellItem = bindHelper.self("onLeftItemClick")
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 9,
				data = bindHelper.self("datas"),
				item = bindHelper.self("listitem"),
				cell = bindHelper.self("item"),
				columnSize = bindHelper.self("rightColumnSize"),
				itemAction = {
					isAction = true
				},
				dataOrderCmp = function(arg_3_0, arg_3_1)
					if arg_3_0.state ~= arg_3_1.state then
						return arg_3_0.state < arg_3_1.state
					end

					if arg_3_0.sort ~= arg_3_1.sort then
						return arg_3_0.sort < arg_3_1.sort
					end

					return arg_3_0.csvId < arg_3_1.csvId
				end,
				onCell = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_3.cfg
					local var_4_1 = arg_4_1:multiget("title", "times", "bottomPanel", "mask", "list", "item", "icon")

					var_4_1.title:text(var_4_0.name)
					var_4_1.title:x(arg_4_1:width() / 2)
					var_4_1.title:y(625)
					adapt.setTextAdaptWithSize(var_4_1.title, {
						margin = -8,
						vertical = "top",
						horizontal = "center",
						maxLine = 2,
						size = cc.size(330, 70)
					})
					var_4_1.icon:texture(var_4_0.icon)

					if var_4_0.refresh then
						var_4_1.times:text(string.format(gLanguageCsv.directBuyGiftDailyBuy, arg_4_3.leftTimes, var_4_0.limit))
						text.addEffect(var_4_1.times, {
							color = ui.COLORS.DISABLED.YELLOW
						})
					else
						local var_4_2 = gLanguageCsv.directBuyGiftOnetimeBuy

						if arg_4_3.status == 1 then
							var_4_2 = gLanguageCsv.directBuyGiftWeek
						elseif arg_4_3.status == 2 then
							var_4_2 = gLanguageCsv.directBuyGiftMonth
						end

						var_4_1.times:text(string.format(var_4_2, arg_4_3.leftTimes, var_4_0.limit))
						text.addEffect(var_4_1.times, {
							color = ui.COLORS.QUALITY[4]
						})
					end

					var_4_1.list:removeAllChildren()
					var_4_1.list:setScrollBarEnabled(false)
					var_4_1.list:setGravity(ccui.ListViewGravity.bottom)

					local var_4_3 = 0
					local var_4_4 = csvSize(var_4_0.item)
					local var_4_5 = 0

					for iter_4_0, iter_4_1 in ipairs(dataEasy.getItemData(var_4_0.item)) do
						local var_4_6 = iter_4_1.key
						local var_4_7 = iter_4_1.num
						local var_4_8 = var_4_1.item:clone():show()
						local var_4_9 = var_4_8:size()

						bind.extend(arg_4_0, var_4_8, {
							class = "icon_key",
							props = {
								data = {
									key = var_4_6,
									num = var_4_7
								},
								onNode = function(arg_5_0)
									arg_5_0:xy(var_4_9.width / 2 + var_4_5, var_4_9.height / 2):scale(0.8)
								end
							}
						})
						var_4_1.list:pushBackCustomItem(var_4_8)
					end

					var_4_1.list:adaptTouchEnabled():setItemAlignCenter()

					local var_4_10 = var_4_1.bottomPanel:get("btn")
					local var_4_11 = var_4_1.bottomPanel:get("panel")
					local var_4_12 = var_4_1.bottomPanel:get("panel"):get("price")
					local var_4_13 = var_4_1.bottomPanel:get("panel"):get("rmb")

					var_4_10:setTouchEnabled(false)
					var_4_13:visible(false)
					cache.setShader(var_4_10, false, "normal")

					if arg_4_3.rmb then
						local var_4_14 = 40

						var_4_12:text(arg_4_3.rmb)

						if type(arg_4_3.rmb) ~= "string" then
							var_4_13:visible(true)
							var_4_12:x(var_4_13:width() / 2 + var_4_12:width() / 2 + var_4_13:x())

							var_4_14 = 70
						end

						var_4_1.bottomPanel:get("panel"):width(var_4_12:width() + var_4_13:width())
						var_4_1.bottomPanel:get("panel"):x(var_4_10:x() - var_4_14)
					elseif arg_4_3.price then
						var_4_12:text(string.format(gLanguageCsv.symbolMoney, arg_4_3.price))
					end

					local var_4_15 = arg_4_3.rmb and type(arg_4_3.rmb) == "string" and true or false

					if arg_4_3.state == var_0_0.canbuy then
						var_4_1.mask:hide()
						var_4_10:setTouchEnabled(true)
						bind.touch(arg_4_0, var_4_10, {
							clicksafe = true,
							methods = {
								ended = functools.partial(arg_4_0.clickCell, arg_4_2, arg_4_3)
							}
						})
						text.addEffect(var_4_12, {
							outline = {
								size = 1,
								color = ui.NEWCOLORS.OUTLINE.YELLOW1
							}
						})
					else
						var_4_1.mask:show()

						var_4_15 = false

						cache.setShader(var_4_10, false, "hsl_gray")
						text.deleteAllEffect(var_4_12)
						text.addEffect(var_4_12, {
							color = ui.COLORS.DISABLED.WHITE
						})

						if arg_4_3.state == var_0_0.sellout then
							var_4_1.mask:get("label"):text(gLanguageCsv.sellout)
						else
							var_4_1.mask:get("label"):text(gLanguageCsv.nextDayRefresh5)
						end
					end

					if matchLanguage({
						"en"
					}) then
						var_4_12:anchorPoint(0.5, 0.5)
						var_4_11:x(var_4_10:size().width / 2)
						var_4_1.mask:get("img"):size(var_4_1.mask:get("label"):size().width + 45, var_4_1.mask:get("img"):size().height)
					end

					local var_4_16 = {
						class = "red_hint",
						props = {
							state = var_4_15,
							onNode = function(arg_6_0)
								arg_6_0:xy(340, 110)
							end
						}
					}

					bind.extend(arg_4_0, var_4_1.bottomPanel, var_4_16)
					arg_4_0:setRenderHint(0)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onBuyClick")
			}
		}
	}
}

function var_0_2.onCreate(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_2 and arg_7_2.yyId or -1

	gGameUI.topuiManager:createView("default", arg_7_0, {
		onClose = arg_7_0:createHandler("onClose")
	}):init({
		subTitle = "SPECIAL GIFT BAG",
		title = "common/txt/txt_bt_tehuilibao.png"
	})

	arg_7_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_7_0.yyOpen = gGameModel.role:getIdler("yy_open")
	arg_7_0.level = gGameModel.role:read("level")

	local var_7_1 = {}
	local var_7_2 = false
	local var_7_3

	for iter_7_0, iter_7_1 in ipairs(arg_7_0.yyOpen:read()) do
		local var_7_4 = csv.yunying.yyhuodong[iter_7_1]

		if var_7_4.type == game.YYHUODONG_TYPE_ENUM_TABLE.directBuyGift and (var_7_4.independent == 1 or var_7_4.independent == 2) and not var_7_4.clientParam.double11 and not var_7_4.clientParam.xdlb then
			table.insert(var_7_1, {
				desc = var_7_4.desc,
				id = iter_7_1,
				sortWeight = var_7_4.sortWeight
			})

			if var_7_4.clientParam.mh then
				var_7_2 = true

				if var_7_0 == -1 then
					var_7_0 = iter_7_1
				end

				var_7_3 = var_7_4.clientParam.icon
			end
		end
	end

	table.sort(var_7_1, function(arg_8_0, arg_8_1)
		if arg_8_0.sortWeight ~= arg_8_1.sortWeight then
			return arg_8_0.sortWeight < arg_8_1.sortWeight
		end

		return arg_8_0.id < arg_8_1.id
	end)

	local var_7_5

	for iter_7_2, iter_7_3 in ipairs(var_7_1) do
		if var_7_0 == iter_7_3.id then
			var_7_5 = iter_7_2

			break
		end
	end

	var_7_5 = var_7_5 or 1

	arg_7_0:initModel(var_7_5)

	local var_7_6 = var_7_1[var_7_5].id

	if var_7_2 then
		arg_7_0.icon:texture(var_7_3 or "activity/direct_gift/img_mh.png")
	else
		arg_7_0.icon:texture("activity/direct_gift/img_hb.png")
	end

	arg_7_0.time:hide()

	if var_7_6 then
		arg_7_0.icon404:visible(false)
		arg_7_0.bg404:visible(false)
		arg_7_0.rightData:update(var_7_1)
		arg_7_0.activityId:set(var_7_6)

		arg_7_0.rightColumnSize = 3

		arg_7_0.showTab:addListener(function(arg_9_0, arg_9_1, arg_9_2)
			arg_7_0.rightData:atproxy(arg_9_1).select = false
			arg_7_0.rightData:atproxy(arg_9_0).select = true

			if csv.yunying.yyhuodong[arg_7_0.activityId:read()].clientParam.isShowCountDown ~= false then
				arg_7_0.time:show()

				local var_9_0 = arg_7_0.time:get("icon")
				local var_9_1 = arg_7_0.time:get("title")
				local var_9_2 = arg_7_0.time:get("time")

				var_0_1.setCountdown(arg_7_0, arg_7_0.activityId:read(), var_9_1, var_9_2, {
					tag = 1,
					labelChangeCb = function()
						adapt.oneLinePos(var_9_2, {
							var_9_1,
							var_9_0
						}, cc.p(5, 0), "right")
					end
				})
			else
				arg_7_0.time:hide()
			end
		end)

		local var_7_7 = csv.yunying.yyhuodong[var_7_6].clientParam

		arg_7_0.time:visible(var_7_7.isShowCountDown ~= false)
		gGameModel.currday_dispatch:getIdlerOrigin("activityDirectBuyGift"):set(true)

		arg_7_0.clientBuyTimes = idler.new(true)

		idlereasy.any({
			arg_7_0.yyhuodongs,
			arg_7_0.clientBuyTimes,
			arg_7_0.activityId
		}, function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
			local var_11_0 = csv.yunying.yyhuodong[arg_11_3].huodongID
			local var_11_1 = (arg_11_1[arg_11_3] or {}).stamps or {}
			local var_11_2 = {}

			for iter_11_0, iter_11_1 in csvPairs(csv.yunying.directbuygift) do
				if iter_11_1.huodongID == var_11_0 and arg_7_0.level >= iter_11_1.levelLimit then
					local var_11_3 = var_0_0.canbuy
					local var_11_4 = var_11_1[iter_11_0] or 0
					local var_11_5 = dataEasy.getPayClientBuyTimes("directBuyData", arg_11_3, iter_11_0, var_11_4)
					local var_11_6 = math.max(0, iter_11_1.limit - var_11_5)
					local var_11_7 = iter_11_1.status

					if var_11_6 == 0 then
						if iter_11_1.refresh then
							var_11_3 = var_0_0.refresh
						else
							var_11_3 = var_0_0.sellout
						end
					end

					local var_11_8
					local var_11_9

					if iter_11_1.rmbCost == 0 then
						var_11_8 = gLanguageCsv.freeToReceive
					elseif iter_11_1.rmbCost >= 1 then
						var_11_8 = iter_11_1.rmbCost
					else
						var_11_9 = csv.recharges[iter_11_1.rechargeID].rmbDisplay
					end

					table.insert(var_11_2, {
						csvId = iter_11_0,
						cfg = iter_11_1,
						state = var_11_3,
						buyTimes = var_11_5,
						leftTimes = var_11_6,
						price = var_11_9,
						rmb = var_11_8,
						status = var_11_7,
						sort = iter_11_1.sort
					})
				end
			end

			if not arg_7_0.isTabChange then
				dataEasy.tryCallFunc(arg_7_0.list, "updatePreloadCenterIndex")
			else
				arg_7_0.isTabChange = false
			end

			arg_7_0.datas:update(var_11_2)
		end)
	else
		arg_7_0.rightBg:visible(false)
	end
end

function var_0_2.initModel(arg_12_0, arg_12_1)
	arg_12_0.activityId = idler.new()
	arg_12_0.rightData = idlers.new()
	arg_12_0.datas = idlers.new()
	arg_12_0.showTab = idler.new(arg_12_1)

	arg_12_0.rightItem:visible(false)
end

function var_0_2.onLeftItemClick(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if arg_13_0.activityId:read() ~= arg_13_3.id then
		dataEasy.tryCallFunc(arg_13_0.list, "setItemAction", {
			isAction = true
		})

		arg_13_0.isTabChange = true

		arg_13_0.activityId:set(arg_13_3.id)
		arg_13_0.showTab:set(arg_13_2)
	end
end

function var_0_2.onBuyClick(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = arg_14_0.activityId:read()

	if not arg_14_3.rmb then
		gGameApp:payDirect(arg_14_0, {
			rechargeId = arg_14_3.cfg.rechargeID,
			yyID = var_14_0,
			csvID = arg_14_3.csvId,
			name = arg_14_3.cfg.name,
			buyTimes = arg_14_3.buyTimes
		}, arg_14_0.clientBuyTimes):serverCb(function()
			local var_15_0 = csv.yunying.directbuygift[arg_14_3.csvId]

			gGameUI:showGainDisplay(var_15_0.item, {
				raw = false
			})
		end):doit()
	else
		gGameApp:requestServer("/game/yy/award/get", function(arg_16_0)
			arg_14_0.clientBuyTimes:notify()

			local var_16_0 = csv.yunying.directbuygift[arg_14_3.csvId]

			gGameUI:showGainDisplay(var_16_0.item, {
				raw = false
			})
		end, var_14_0, arg_14_3.csvId)
	end
end

return var_0_2
