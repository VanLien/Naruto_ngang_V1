local var_0_0 = require("app.views.city.activity.month_card")

local function var_0_1(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_1:get("imgIcon"):hide()
	arg_1_1:get("imgFrag"):hide()
	bind.extend(arg_1_0, arg_1_1, {
		class = "icon_key",
		props = {
			simpleShow = true,
			data = {
				key = arg_1_3.itemId
			},
			specialKey = {
				maxStar = true
			},
			onNode = function(arg_2_0)
				arg_2_0:setTouchEnabled(false)
				arg_2_0:xy(arg_1_1:get("imgIcon"):xy()):z(2)
			end
		}
	})

	local var_1_0 = csv.mystery_shop[arg_1_3.csvId]
	local var_1_1 = var_1_0.itemCount

	arg_1_1:get("textNum"):text("x" .. var_1_1)

	local var_1_2, var_1_3 = csvNext(var_1_0.costMap)
	local var_1_4 = 1 - (var_0_0.getPrivilegeAddition("mysteryShopDiscount") or 0)
	local var_1_5 = dataEasy.getIconResByKey(var_1_2)

	arg_1_1:get("btnBuy.icon"):texture(var_1_5)
	arg_1_1:get("btnBuy.txt"):text(math.ceil(tonumber(var_1_3) * var_1_4))
	uiEasy.setIconName(arg_1_3.itemId, var_1_0.itemCount, {
		node = arg_1_1:get("textName")
	})
	text.addEffect(arg_1_1:get("btnBuy.txt"), {
		outline = {
			size = 3,
			color = ui.NEWCOLORS.OUTLINE.YELLOW
		}
	})

	local var_1_6 = var_1_0.limitTimes
	local var_1_7 = arg_1_3.leftNum

	if var_1_6 > 0 then
		arg_1_1:get("textLimiteNum"):text(var_1_7 .. "/" .. var_1_6)

		local var_1_8 = ui.COLORS.NORMAL.FRIEND_GREEN

		if var_1_7 == 0 then
			var_1_8 = ui.COLORS.NORMAL.ALERT_ORANGE
		end

		text.addEffect(arg_1_1:get("textLimiteNum"), {
			color = var_1_8
		})
	end

	arg_1_1:get("textLimiteNote"):visible(var_1_6 > 0)
	arg_1_1:get("textLimiteNum"):visible(var_1_6 > 0)

	local var_1_9 = var_1_0.discountDesc or ""

	if var_1_9 == "" and var_1_4 < 1 then
		if matchLanguage({
			"kr",
			"en"
		}) then
			var_1_9 = string.format(gLanguageCsv.discount, tostring((1 - var_1_4) * 100))
		else
			var_1_9 = string.format(gLanguageCsv.discount, var_1_4 * 10)
		end
	end

	arg_1_1:get("flag"):visible(string.len(var_1_9) > 0)
	arg_1_1:get("flag.textVal"):text(var_1_9)

	if matchLanguage({
		"kr",
		"en"
	}) then
		adapt.setTextScaleWithWidth(arg_1_1:get("flag.textVal"), nil, 90)
	end

	local var_1_10 = var_1_0.vipStart
	local var_1_11 = var_1_0.levelRange

	arg_1_1:get("lock"):visible(var_1_7 == 0)
	arg_1_1:setTouchEnabled(true)

	if var_1_7 == 0 then
		arg_1_1:setTouchEnabled(false)
		arg_1_1:get("lock.textLock"):text(gLanguageCsv.sellout)
		arg_1_1:get("lock.textLock"):x(207)
		arg_1_1:get("lock.imgLock"):visible(false)
		arg_1_1:get("lock.textTip"):visible(false)
	elseif var_1_10 > arg_1_0.vip():read() or var_1_11[1] > arg_1_0.roleLv():read() then
		arg_1_1:setTouchEnabled(false)
		arg_1_1:get("lock.imgLock"):visible(true)
		arg_1_1:get("lock.textLock"):text(gLanguageCsv.notUnlock)
		adapt.oneLinePos(arg_1_1:get("lock.imgLock"), arg_1_1:get("lock.textLock"))
		arg_1_1:get("lock.textTip"):text(string.format(gLanguageCsv.levelAndVip, var_1_11[1], var_1_10))
	end
end

local var_0_2 = cc.load("mvc").ViewBase
local var_0_3 = class("MysteryShopView", var_0_2)

var_0_3.RESOURCE_FILENAME = "mystery_shop.json"
var_0_3.RESOURCE_BINDING = {
	innerList = "innerList",
	item = "item",
	slider = "slider",
	["info.imgIcon"] = "imgIcon",
	["item.textName"] = "textName",
	["info.textCostNum"] = "textCostNum",
	["time.textTime"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("leftTime")
		}
	},
	["info.textRefreshNum"] = {
		varname = "refreshLabel",
		binds = {
			event = "text",
			idler = bindHelper.self("refreshNum")
		}
	},
	["info.btnRefresh"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRefreshItems")
			}
		}
	},
	["info.btnRefresh.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 10,
				columnSize = 4,
				data = bindHelper.self("itemsData"),
				item = bindHelper.self("innerList"),
				cell = bindHelper.self("item"),
				sliderBg = bindHelper.self("slider"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					var_0_1(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					bind.touch(arg_3_0, arg_3_1, {
						methods = {
							ended = functools.partial(arg_3_0.itemClick, arg_3_0:getIdx(arg_3_2), arg_3_3)
						}
					})
				end,
				onBeforeBuild = function(arg_4_0)
					local var_4_0, var_4_1 = arg_4_0:xy()
					local var_4_2 = arg_4_0:size()
					local var_4_3, var_4_4 = arg_4_0.sliderBg:xy()
					local var_4_5 = arg_4_0.sliderBg:size()

					arg_4_0:setScrollBarEnabled(true)
					arg_4_0:setScrollBarColor(cc.c3b(245, 156, 2))
					arg_4_0:setScrollBarOpacity(255)
					arg_4_0:setScrollBarAutoHideEnabled(false)
					arg_4_0:setScrollBarPositionFromCorner(cc.p(var_4_0 + var_4_2.width - var_4_3, (var_4_2.height - var_4_5.height) / 2 + 5))
					arg_4_0:setScrollBarWidth(var_4_5.width)
					arg_4_0:refreshView()
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick"),
				roleLv = bindHelper.self("roleLv"),
				vip = bindHelper.self("vip")
			}
		}
	}
}

function var_0_3.onCreate(arg_5_0)
	arg_5_0.itemsData = idlers.newWithMap({})
	arg_5_0.leftTime = idler.new("")
	arg_5_0.refreshNum = idler.new("")

	arg_5_0:initModel()
	arg_5_0:refreshDatas()
	adapt.setTextAdaptWithSize(arg_5_0.textName, {
		margin = -4,
		vertical = "center",
		horizontal = "center",
		maxLine = 2,
		size = cc.size(370, 80)
	})
	gGameUI.topuiManager:createView("default", arg_5_0, {
		onClose = arg_5_0:createHandler("onClose")
	}):init({
		subTitle = "MYSTERYSHOP",
		title = "common/txt/txt_bt_shenmishangdian.png"
	})
	arg_5_0:enableSchedule():schedule(function()
		local var_6_0, var_6_1 = uiEasy.isOpenMystertShop()

		if not var_6_0 then
			gGameUI:showTip(gLanguageCsv.mysteryShopClose)
			performWithDelay(arg_5_0, function()
				arg_5_0:onClose()
			end, 0.016666666666666666)

			return false
		else
			local var_6_2 = time.getCutDown(var_6_1)

			arg_5_0.leftTime:set(var_6_2.str)
		end
	end, 1, 0, 1)
	idlereasy.any({
		arg_5_0.refreshItems,
		arg_5_0.vip
	}, function(arg_8_0, arg_8_1, arg_8_2)
		local var_8_0 = gCostCsv.mysteryshop_refresh_cost
		local var_8_1 = math.min(arg_8_1 + 1, table.length(var_8_0))
		local var_8_2 = arg_5_0:getCostNum(arg_8_1)

		arg_5_0.textCostNum:text(var_8_2)
		adapt.oneLinePos(arg_5_0.textCostNum, arg_5_0.imgIcon, nil, "left")

		local var_8_3 = gVipCsv[arg_8_2].mysteryRefresh
		local var_8_4 = var_8_3 - arg_8_1

		arg_5_0.refreshNum:set(var_8_4 .. "/" .. var_8_3)

		local var_8_5 = ui.COLORS.NORMAL.FRIEND_GREEN

		if var_8_4 == 0 then
			var_8_5 = ui.COLORS.NORMAL.ALERT_ORANGE
		end

		text.addEffect(arg_5_0.refreshLabel, {
			color = var_8_5
		})
	end)
end

function var_0_3.getCostNum(arg_9_0, arg_9_1)
	arg_9_1 = arg_9_1 or arg_9_0.refreshItems:read()

	local var_9_0 = gCostCsv.mysteryshop_refresh_cost

	return var_9_0[math.min(arg_9_1 + 1, table.length(var_9_0))]
end

function var_0_3.initModel(arg_10_0)
	arg_10_0.mysteryShopLastTime = gGameModel.mystery_shop:getIdler("last_active_time")
	arg_10_0.items = gGameModel.mystery_shop:getIdler("items")
	arg_10_0.refreshItems = gGameModel.mystery_shop:getIdler("refresh_times")
	arg_10_0.buy = gGameModel.mystery_shop:getIdler("buy")
	arg_10_0.lastTimes = gGameModel.mystery_shop:getIdler("last_times")
	arg_10_0.vip = gGameModel.role:getIdler("vip_level")
	arg_10_0.roleLv = gGameModel.role:getIdler("level")
end

function var_0_3.refreshDatas(arg_11_0)
	local var_11_0 = {}

	for iter_11_0, iter_11_1 in pairs(arg_11_0.items:read()) do
		local var_11_1 = csv.mystery_shop[iter_11_1[1]]
		local var_11_2 = arg_11_0.buy:read()[iter_11_0] and 1 or 0

		table.insert(var_11_0, {
			pos = iter_11_0,
			csvId = iter_11_1[1],
			itemId = iter_11_1[2],
			leftNum = 1 - var_11_2
		})
	end

	table.sort(var_11_0, function(arg_12_0, arg_12_1)
		return arg_12_0.pos < arg_12_1.pos
	end)
	arg_11_0.itemsData:update(var_11_0)
end

function var_0_3.onRefreshItems(arg_13_0)
	if gVipCsv[arg_13_0.vip:read()].mysteryRefresh - arg_13_0.refreshItems:read() <= 0 then
		gGameUI:showTip(gLanguageCsv.refreshTimesNotEnough)

		return
	end

	local var_13_0 = string.format(gLanguageCsv.shopRefreshCommonBox, arg_13_0:getCostNum())

	gGameUI:showDialog({
		btnType = 2,
		isRich = true,
		strs = "#C0x5B545B#" .. var_13_0,
		cb = function()
			gGameApp:requestServer("/game/mystery/refresh", function()
				dataEasy.tryCallFunc(arg_13_0.list, "setItemAction", {
					isAction = true
				})
				arg_13_0:refreshDatas()
				gGameUI:showTip(gLanguageCsv.refreshSuccessful)
			end)
		end,
		dialogParams = {
			clickClose = false
		}
	})
end

function var_0_3.onItemClick(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	if arg_16_3.leftNum <= 0 then
		return
	end

	local var_16_0 = csv.mystery_shop[arg_16_3.csvId]
	local var_16_1 = 1 - (var_0_0.getPrivilegeAddition("mysteryShopDiscount") or 0)

	gGameUI:stackUI("common.buy_info", nil, nil, var_16_0.costMap, {
		id = arg_16_3.itemId,
		num = var_16_0.itemCount
	}, {
		discount = var_16_1
	}, arg_16_0:createHandler("buyItemCallBack", var_16_0, arg_16_2, arg_16_3))
end

function var_0_3.buyItemCallBack(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	gGameApp:requestServer("/game/mystery/buy", function(arg_18_0)
		gGameUI:showGainDisplay({
			{
				arg_17_3.itemId,
				arg_17_1.itemCount
			}
		}, {
			raw = false
		})

		arg_17_0.itemsData:atproxy(arg_17_2.k).leftNum = arg_17_0.itemsData:atproxy(arg_17_2.k).leftNum - 1
	end, arg_17_3.pos, arg_17_3.csvId, arg_17_3.itemId)
end

return var_0_3
