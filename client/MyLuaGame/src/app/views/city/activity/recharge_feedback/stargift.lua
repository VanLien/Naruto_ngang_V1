local var_0_0 = {
	CAN_NOT_GOTTEN = 0,
	CAN_GOTTEN = 1,
	GOTTEN = 2
}
local var_0_1 = 105
local var_0_2 = 450
local var_0_3 = 130
local var_0_4 = 70
local var_0_5 = 60
local var_0_6 = {
	{
		x = var_0_4,
		y = var_0_5
	},
	{
		x = var_0_4 + var_0_3,
		y = var_0_5
	},
	{
		x = var_0_4,
		y = var_0_5 + var_0_3
	},
	{
		x = var_0_4 + var_0_3,
		y = var_0_5 + var_0_3
	}
}
local var_0_7 = class("ActivityStarGiftDialog", Dialog)

var_0_7.RESOURCE_FILENAME = "activity_star_gift.json"
var_0_7.RESOURCE_BINDING = {
	time = "time",
	item = "item",
	light_item = "lightItem",
	iconItem = "iconItem",
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("itemsData"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_0.initItem(arg_1_1, arg_1_2, arg_1_3)
				end
			},
			handlers = {
				initItem = bindHelper.self("initItem")
			}
		}
	}
}

function var_0_7.onCreate(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	gGameUI.topuiManager:createView("default", arg_2_0, {
		onClose = arg_2_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = "common/txt/txt_bt_sxhl.png"
	})
	Dialog.onCreate(arg_2_0, {
		blackType = 1
	})

	arg_2_0.huodongID = arg_2_1
	arg_2_0.aniArgs = arg_2_3
	arg_2_0.yyID = arg_2_2

	arg_2_0:initModel()
	arg_2_0:initUI()
	gGameModel.currday_dispatch:getIdlerOrigin("newPlayerWeffare"):set(true)
end

function var_0_7.initModel(arg_3_0)
	arg_3_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_3_0.itemsData = idlers.new()

	idlereasy.when(arg_3_0.yyhuodongs, function(arg_4_0, arg_4_1)
		local var_4_0 = {}
		local var_4_1 = arg_4_1[arg_3_0.yyID] and arg_4_1[arg_3_0.yyID].valinfo or {}

		for iter_4_0, iter_4_1 in csvPairs(csv.yunying.stargift) do
			if iter_4_1.huodongID == arg_3_0.huodongID then
				iter_4_1.csvID = iter_4_0
				iter_4_1.free = var_4_1[iter_4_0] and var_4_1[iter_4_0].free or var_0_0.CAN_NOT_GOTTEN
				iter_4_1.buy = var_4_1[iter_4_0] and var_4_1[iter_4_0].pay or var_0_0.CAN_NOT_GOTTEN

				table.insert(var_4_0, iter_4_1)
			end
		end

		arg_3_0.itemsData:update(var_4_0)
	end)
end

function var_0_7.initUI(arg_5_0)
	arg_5_0:initLeftSprite()
end

function var_0_7.initLeftSprite(arg_6_0)
	local var_6_0 = csv.yunying.yyhuodong[arg_6_0.yyID]
	local var_6_1 = "naruto_naruto03/naruto03_ui.skel"

	if arg_6_0.aniArgs and arg_6_0.aniArgs.res then
		var_6_1 = string.gsub(arg_6_0.aniArgs.res, ".skel", "_ui.skel")
	end

	if var_6_0.clientParam.spine then
		var_6_1 = var_6_0.clientParam.spine
	end

	local var_6_2 = arg_6_0.lightItem:get("renwudonghua"):size()
	local var_6_3 = widget.addAnimationByKey(arg_6_0.lightItem:get("renwudonghua"), var_6_1, "spine", "standby_loop"):xy(var_6_2.width / 2, 200):scale(1.2)
end

function var_0_7.initItem(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = arg_7_2:multiget("title", "list", "bg", "bottomPanel", "bottomPanel_1")
	local var_7_1 = arg_7_4.freeAward
	local var_7_2 = itertools.size(var_7_1)
	local var_7_3 = 0

	var_7_0.bg:removeAllChildren()

	local var_7_4 = csv.recharges[arg_7_4.rechargeID]

	var_7_0.title:text(string.format(gLanguageCsv.manyStars, arg_7_4.star))

	for iter_7_0, iter_7_1 in pairs(var_7_1) do
		var_7_3 = var_7_3 + 1

		local var_7_5 = cc.p(var_0_1, var_0_2)
		local var_7_6 = cc.Node:create()

		var_7_6:addTo(var_7_0.bg)
		var_7_6:show()
		var_7_6:xy(var_7_5.x, var_7_5.y)

		local var_7_7 = {
			class = "icon_key",
			props = {
				data = {
					key = iter_7_0,
					num = iter_7_1
				},
				onNode = function(arg_8_0)
					arg_8_0:scale(0.6):z(100)
				end
			}
		}

		bind.extend(arg_7_0, var_7_6, var_7_7)
	end

	local var_7_8 = var_7_0.bottomPanel_1:get("btn")
	local var_7_9 = var_7_0.bottomPanel_1:get("panel"):get("price")

	bind.touch(arg_7_0, var_7_8, {
		methods = {
			ended = function()
				arg_7_0:drawAward(var_7_8, var_7_9, arg_7_4.csvID)
			end
		}
	})

	local var_7_10 = 0

	for iter_7_2, iter_7_3 in pairs(arg_7_4.buyAward) do
		var_7_10 = var_7_10 + 1

		local var_7_11 = var_0_6[var_7_10]
		local var_7_12 = cc.Node:create()

		var_7_12:addTo(var_7_0.list)
		var_7_12:show()
		var_7_12:xy(var_7_11.x, var_7_11.y)

		local var_7_13 = {
			class = "icon_key",
			props = {
				data = {
					key = iter_7_2,
					num = iter_7_3
				},
				onNode = function(arg_10_0)
					arg_10_0:scale(0.7):z(100)
				end
			}
		}

		bind.extend(arg_7_0, var_7_12, var_7_13)
	end

	if arg_7_4.free == var_0_0.CAN_NOT_GOTTEN then
		var_7_8:setTouchEnabled(false)
		cache.setShader(var_7_8, false, "hsl_gray")
		var_7_9:text(gLanguageCsv.freeToReceive)
	elseif arg_7_4.free == var_0_0.CAN_GOTTEN then
		var_7_8:setTouchEnabled(true)
		cache.setShader(var_7_8, false, "normal")
		var_7_9:text(gLanguageCsv.freeToReceive)
	elseif arg_7_4.free == var_0_0.GOTTEN then
		var_7_8:setTouchEnabled(false)
		cache.setShader(var_7_8, false, "hsl_gray")
		var_7_9:text(gLanguageCsv.received)
	end

	local var_7_14 = var_7_0.bottomPanel:get("btn")
	local var_7_15 = var_7_0.bottomPanel:get("panel"):get("price")

	bind.touch(arg_7_0, var_7_0.bottomPanel:get("btn"), {
		methods = {
			ended = function()
				arg_7_0:sendGetAward(var_7_0.bottomPanel, arg_7_4)
			end
		}
	})

	if arg_7_4.buy == var_0_0.CAN_NOT_GOTTEN then
		var_7_14:setTouchEnabled(false)
		cache.setShader(var_7_14, false, "hsl_gray")
		var_7_15:text(string.format(gLanguageCsv.symbolMoney, var_7_4.rmbDisplay))
	elseif arg_7_4.buy == var_0_0.CAN_GOTTEN then
		var_7_14:setTouchEnabled(true)
		cache.setShader(var_7_14, false, "normal")
		var_7_15:text(string.format(gLanguageCsv.symbolMoney, var_7_4.rmbDisplay))
	elseif arg_7_4.buy == var_0_0.GOTTEN then
		var_7_14:setTouchEnabled(false)
		cache.setShader(var_7_14, false, "hsl_gray")
		var_7_15:text(gLanguageCsv.received)
	end
end

function var_0_7.sendGetAward(arg_12_0, arg_12_1, arg_12_2)
	gGameApp:payDirect(arg_12_0, {
		buyTimes = 0,
		rechargeId = arg_12_2.rechargeID,
		yyID = arg_12_0.yyID,
		csvID = arg_12_2.csvID,
		name = arg_12_2.desc
	}):serverCb(function()
		gGameUI:showGainDisplay(arg_12_2.buyAward, {
			raw = false
		})
	end):doit(function()
		arg_12_1:get("btn"):setTouchEnabled(false)
		cache.setShader(arg_12_1:get("btn"), false, "hsl_gray")
		arg_12_1:get("panel"):get("price"):text(gLanguageCsv.hasBuy)
	end)
end

function var_0_7.drawAward(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	gGameApp:requestServer("/game/yy/star/free/draw", function(arg_16_0)
		gGameUI:showGainDisplay(arg_16_0)
		arg_15_1:setTouchEnabled(false)
		cache.setShader(arg_15_1, false, "hsl_gray")
		arg_15_2:text(gLanguageCsv.received)
	end, arg_15_0.yyID, arg_15_3)
end

return var_0_7
