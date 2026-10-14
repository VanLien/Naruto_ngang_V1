local var_0_0 = {
	sellout = 3,
	refresh = 2,
	canbuy = 1
}
local var_0_1 = require("app.views.city.activity.view")
local var_0_2 = class("ActivityFocusBuyGiftView", Dialog)
local var_0_3 = -60
local var_0_4 = -50
local var_0_5 = 130
local var_0_6 = {
	{
		x = var_0_3,
		y = var_0_4
	},
	{
		x = var_0_3 + var_0_5,
		y = var_0_4
	},
	{
		x = var_0_3,
		y = var_0_4 + var_0_5
	},
	{
		x = var_0_3 + var_0_5,
		y = var_0_4 + var_0_5
	}
}

var_0_2.RESOURCE_FILENAME = "activity_xdlb.json"
var_0_2.RESOURCE_BINDING = {
	ybgm_item = "itemYb",
	lbgm_item = "itemLb",
	item = "iconItem",
	time = "time",
	["right_item.list_dajiang"] = "listReward",
	right_item = "rightItem",
	listitem = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("datasYb"),
				item = bindHelper.self("itemYb"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("title", "times", "bottomPanel")

					var_1_0.times:text(gLanguageCsv.limitBuy .. arg_1_3.buyTimes .. "/" .. arg_1_3.cfg.limit)
					var_1_0.title:text(arg_1_3.cfg.name)

					local var_1_1 = var_1_0.bottomPanel
					local var_1_2 = var_1_1:get("btn")

					bind.touch(arg_1_0, var_1_2, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3)
						}
					})
					var_1_1:get("panel"):get("price"):text(arg_1_3.rmb)

					if type(arg_1_3.rmb) == "string" then
						var_1_1:get("panel"):get("rmb"):hide()
					else
						var_1_1:get("panel"):get("rmb"):show()
					end

					if arg_1_3.state == var_0_0.canbuy then
						var_1_2:setTouchEnabled(true)
						cache.setShader(var_1_2, false, "normal")
					else
						var_1_2:setTouchEnabled(false)
						cache.setShader(var_1_2, false, "hsl_gray")
					end

					for iter_1_0, iter_1_1 in pairs(arg_1_3.cfg.item) do
						bind.extend(arg_1_0, arg_1_1, {
							class = "icon_key",
							props = {
								data = {
									key = iter_1_0,
									num = iter_1_1
								},
								onNode = function(arg_2_0)
									local var_2_0 = arg_2_0:box()

									arg_2_0:alignCenter(var_2_0):xy(var_2_0.width - 4, var_2_0.height + 101)
								end
							}
						})

						break
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onBuyClick")
			}
		}
	},
	list = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = -10,
				data = bindHelper.self("datasRmb"),
				item = bindHelper.self("itemLb"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:multiget("times", "bottomPanel")

					var_3_0.times:text(gLanguageCsv.limitBuy .. arg_3_3.buyTimes .. "/" .. arg_3_3.cfg.limit)

					local var_3_1 = var_3_0.bottomPanel
					local var_3_2 = var_3_1:get("btn")

					bind.touch(arg_3_0, var_3_2, {
						methods = {
							ended = functools.partial(arg_3_0.clickCell, arg_3_2, arg_3_3)
						}
					})

					local var_3_3 = csv.recharges[arg_3_3.cfg.rechargeID]

					var_3_1:get("panel"):get("price"):text(string.format(gLanguageCsv.symbolMoney, var_3_3.rmbDisplay))

					if arg_3_3.state == var_0_0.canbuy then
						var_3_2:setTouchEnabled(true)
						cache.setShader(var_3_2, false, "normal")
					else
						var_3_2:setTouchEnabled(false)
						cache.setShader(var_3_2, false, "hsl_gray")
					end

					arg_3_0.initItem(arg_3_1, arg_3_2, arg_3_3)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onBuyClick"),
				initItem = bindHelper.self("initItem")
			}
		}
	},
	close = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	}
}

function var_0_2.onCreate(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:initModel()

	local var_4_0 = arg_4_1
	local var_4_1 = csv.yunying.yyhuodong[arg_4_1]

	if var_4_1 and var_4_1.clientParam.xdlb then
		var_4_0 = var_4_1.clientParam.xdlb
	end

	arg_4_0.datas = arg_4_2

	arg_4_0.time:hide()

	if var_4_0 then
		arg_4_0.activityId:set(var_4_0)
		arg_4_0.time:show()

		local var_4_2 = arg_4_0.time:get("icon")
		local var_4_3 = arg_4_0.time:get("title")
		local var_4_4 = arg_4_0.time:get("time")

		var_0_1.setCountdown(arg_4_0, arg_4_0.activityId:read(), var_4_3, var_4_4, {
			tag = 1,
			labelChangeCb = function()
				adapt.oneLinePos(var_4_4, {
					var_4_3,
					var_4_2
				}, cc.p(5, 0), "right")
			end
		})
		gGameModel.currday_dispatch:getIdlerOrigin("activityDirectBuyGift"):set(true)

		arg_4_0.clientBuyTimes = idler.new(true)

		idlereasy.any({
			arg_4_0.yyhuodongs,
			arg_4_0.clientBuyTimes,
			arg_4_0.activityId
		}, function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
			local var_6_0 = csv.yunying.yyhuodong[arg_6_3].huodongID
			local var_6_1 = (arg_6_1[arg_6_3] or {}).stamps or {}
			local var_6_2 = {}
			local var_6_3 = {}

			for iter_6_0, iter_6_1 in csvPairs(csv.yunying.directbuygift) do
				if iter_6_1.huodongID == var_6_0 and arg_4_0.level >= iter_6_1.levelLimit then
					local var_6_4 = var_0_0.canbuy
					local var_6_5 = var_6_1[iter_6_0] or 0
					local var_6_6 = dataEasy.getPayClientBuyTimes("directBuyData", arg_6_3, iter_6_0, var_6_5)
					local var_6_7 = math.max(0, iter_6_1.limit - var_6_6)
					local var_6_8 = iter_6_1.status

					if var_6_7 == 0 then
						if iter_6_1.refresh then
							var_6_4 = var_0_0.refresh
						else
							var_6_4 = var_0_0.sellout
						end
					end

					local var_6_9
					local var_6_10

					if iter_6_1.rmbCost == 0 then
						var_6_9 = gLanguageCsv.freeToReceive
					elseif iter_6_1.rmbCost >= 1 then
						var_6_9 = iter_6_1.rmbCost
					else
						var_6_10 = csv.recharges[iter_6_1.rechargeID].rmbDisplay
					end

					if string.sub(iter_6_1.icon, -5) == ".skel" then
						arg_4_0.goodData = {
							csvId = iter_6_0,
							cfg = iter_6_1,
							state = var_6_4,
							buyTimes = var_6_6,
							leftTimes = var_6_7,
							price = var_6_10,
							rmb = var_6_9,
							status = var_6_8,
							sort = iter_6_1.sort
						}
					elseif iter_6_1.rmbCost >= 0 then
						table.insert(var_6_3, {
							csvId = iter_6_0,
							cfg = iter_6_1,
							state = var_6_4,
							buyTimes = var_6_6,
							leftTimes = var_6_7,
							price = var_6_10,
							rmb = var_6_9,
							status = var_6_8,
							sort = iter_6_1.sort
						})
					else
						table.insert(var_6_2, {
							csvId = iter_6_0,
							cfg = iter_6_1,
							state = var_6_4,
							buyTimes = var_6_6,
							leftTimes = var_6_7,
							price = var_6_10,
							rmb = var_6_9,
							status = var_6_8,
							sort = iter_6_1.sort
						})
					end
				end
			end

			table.sort(var_6_2, function(arg_7_0, arg_7_1)
				return arg_7_0.csvId < arg_7_1.csvId
			end)
			arg_4_0.datasRmb:update(var_6_2)
			table.sort(var_6_3, function(arg_8_0, arg_8_1)
				return arg_8_0.csvId < arg_8_1.csvId
			end)
			arg_4_0.datasYb:update(var_6_3)
			arg_4_0:updateRightItem()
		end)
	end

	Dialog.onCreate(arg_4_0)
end

function var_0_2.initModel(arg_9_0)
	arg_9_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_9_0.yyOpen = gGameModel.role:getIdler("yy_open")
	arg_9_0.level = gGameModel.role:read("level")
	arg_9_0.activityId = idler.new()
	arg_9_0.datasRmb = idlers.new()
	arg_9_0.datasYb = idlers.new()
end

function var_0_2.updateRightItem(arg_10_0)
	if not arg_10_0.goodData then
		return
	end

	uiEasy.createItemsToList(arg_10_0, arg_10_0.rightItem:get("list_dajiang"), arg_10_0.goodData.cfg.item, {
		scale = 0.92
	})
	arg_10_0.rightItem:get("times_0"):text(gLanguageCsv.limitBuy .. arg_10_0.goodData.buyTimes .. "/" .. arg_10_0.goodData.cfg.limit)

	local var_10_0 = arg_10_0.rightItem:get("bottomPanel_0")
	local var_10_1 = arg_10_0.rightItem:get("renwudonghua"):size()

	if arg_10_0.datas then
		for iter_10_0, iter_10_1 in pairs(arg_10_0.datas) do
			if arg_10_0.rightItem:get("renwudonghua"):get("spine" .. iter_10_0) then
				arg_10_0.rightItem:get("renwudonghua"):removeChildByName("spine" .. iter_10_0)
			end

			local var_10_2 = widget.addAnimationByKey(arg_10_0.rightItem:get("renwudonghua"), string.gsub(iter_10_1, ".skel", "_ui.skel"), "spine" .. iter_10_0, "standby_loop"):xy(100 + var_10_1.width / 2 * (iter_10_0 - 1), 0):scale(0.9)
		end
	else
		if arg_10_0.rightItem:get("renwudonghua"):get("spine") then
			arg_10_0.rightItem:get("renwudonghua"):removeChildByName("spine")
		end

		local var_10_3 = widget.addAnimationByKey(arg_10_0.rightItem:get("renwudonghua"), arg_10_0.goodData.cfg.icon, "spine", "standby_loop"):xy(var_10_1.width / 2, 0)
	end

	local var_10_4 = var_10_0:get("btn")
	local var_10_5 = var_10_0:get("panel"):get("price")
	local var_10_6 = csv.recharges[arg_10_0.goodData.cfg.rechargeID]

	var_10_5:text(string.format(gLanguageCsv.symbolMoney, var_10_6.rmbDisplay))

	if arg_10_0.goodData.state == var_0_0.canbuy then
		var_10_4:setTouchEnabled(true)
		cache.setShader(var_10_4, false, "normal")
	else
		var_10_4:setTouchEnabled(false)
		cache.setShader(var_10_4, false, "hsl_gray")
	end

	bind.touch(var_10_0, var_10_4, {
		methods = {
			ended = function()
				arg_10_0:onBuyClick(var_10_4, k, arg_10_0.goodData)
			end
		}
	})
end

function var_0_2.initItem(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = 0

	for iter_12_0, iter_12_1 in pairs(arg_12_4.cfg.item) do
		var_12_0 = var_12_0 + 1

		local var_12_1 = ccui.Button:create("common/btn/kong.png")

		var_12_1:addTo(arg_12_2):xy(var_0_6[var_12_0].x, var_0_6[var_12_0].y):z(10)
		var_12_1:show()
		bind.touch(arg_12_2, var_12_1, {
			methods = {
				ended = function()
					return
				end
			}
		})
		bind.extend(arg_12_1, var_12_1, {
			class = "icon_key",
			props = {
				data = {
					key = iter_12_0,
					num = iter_12_1
				},
				onNode = function(arg_14_0)
					local var_14_0 = arg_14_0:box()

					arg_14_0:alignCenter(var_14_0):xy(var_14_0.width - 4, var_14_0.height + 101):scale(0.7)
				end
			}
		})
	end
end

function var_0_2.onBuyClick(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	if arg_15_3.buyTimes >= arg_15_3.cfg.limit then
		gGameUI:showTip(gLanguageCsv.cardCapacityBuyMax)

		return
	end

	local var_15_0 = arg_15_0.activityId:read()

	if not arg_15_3.rmb then
		gGameApp:payDirect(arg_15_0, {
			rechargeId = arg_15_3.cfg.rechargeID,
			yyID = var_15_0,
			csvID = arg_15_3.csvId,
			name = arg_15_3.cfg.name,
			buyTimes = arg_15_3.buyTimes
		}, arg_15_0.clientBuyTimes):serverCb(function()
			local var_16_0 = csv.yunying.directbuygift[arg_15_3.csvId]

			gGameUI:showGainDisplay(var_16_0.item, {
				raw = false
			})
		end):doit()
	else
		gGameApp:requestServer("/game/yy/award/get", function(arg_17_0)
			arg_15_0.clientBuyTimes:notify()

			local var_17_0 = csv.yunying.directbuygift[arg_15_3.csvId]

			gGameUI:showGainDisplay(var_17_0.item, {
				raw = false
			})
		end, var_15_0, arg_15_3.csvId)
	end
end

return var_0_2
