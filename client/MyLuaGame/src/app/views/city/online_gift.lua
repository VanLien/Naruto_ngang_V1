local function var_0_0(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = time.getTime()

	return csv.online_gift[arg_1_2 + 1].periods * 60 - (var_1_0 - arg_1_1 + arg_1_0)
end

local var_0_1 = class("OnlineGiftView", Dialog)

var_0_1.RESOURCE_FILENAME = "online_gift.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	bg = "bg",
	labelTime = {
		varname = "labelTime",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(250, 240, 208, 255)
				}
			}
		}
	},
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	}
}

local var_0_2 = 730
local var_0_3 = 930
local var_0_4 = 300
local var_0_5 = 400

local function var_0_6(arg_2_0, arg_2_1)
	return {
		{
			x = arg_2_0,
			y = arg_2_1
		},
		{
			x = arg_2_0 + var_0_4,
			y = arg_2_1
		},
		{
			x = arg_2_0 + 2 * var_0_4,
			y = arg_2_1
		},
		{
			x = arg_2_0 + 3 * var_0_4,
			y = arg_2_1
		},
		{
			x = arg_2_0,
			y = arg_2_1 - var_0_5
		},
		{
			x = arg_2_0 + 1 * var_0_4,
			y = arg_2_1 - var_0_5
		},
		{
			x = arg_2_0 + 2 * var_0_4,
			y = arg_2_1 - var_0_5
		},
		{
			x = arg_2_0 + 3 * var_0_4,
			y = arg_2_1 - var_0_5
		},
		{
			x = arg_2_0 + 4 * var_0_4,
			y = arg_2_1 - var_0_5 / 2
		}
	}
end

function var_0_1.onCreate(arg_3_0, arg_3_1)
	var_0_2 = arg_3_0.bg:x() - 50

	local var_3_0 = var_0_6(var_0_2, var_0_3)

	arg_3_0.onlineGift = gGameModel.daily_record:getIdler("online_gift")

	local var_3_1 = arg_3_0.onlineGift:read()

	arg_3_0.giftData = {}

	arg_3_0:enableSchedule()

	local var_3_2 = time.getTime() - var_3_1.starttime
	local var_3_3 = var_3_1.totaltime + var_3_2

	arg_3_0.labelTime:text(time.getCutDown(var_3_3).short_clock_str)

	local var_3_4 = var_3_1.ids
	local var_3_5 = {}

	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		local var_3_6 = csv.online_gift[iter_3_0]
		local var_3_7 = {}
		local var_3_8
		local var_3_9

		for iter_3_2, iter_3_3 in csvMapPairs(var_3_6.award) do
			var_3_8 = iter_3_2
			var_3_9 = iter_3_3

			break
		end

		local var_3_10 = var_3_6.periods
		local var_3_11 = arg_3_0.item:clone():xy(iter_3_1.x, iter_3_1.y):addTo(arg_3_0:getResourceNode(), 100):setAnchorPoint(1, 0.5)

		var_3_5[iter_3_0] = var_3_11

		local var_3_12 = var_3_11:multiget("wp_di", "time", "btnDraw", "yilinqu")
		local var_3_13 = var_3_11:get("btnDraw.txtDraw")
		local var_3_14 = var_3_12.wp_di:size()

		bind.extend(arg_3_0, var_3_12.wp_di, {
			class = "icon_key",
			props = {
				data = {
					key = var_3_8,
					num = var_3_9
				},
				onNode = function(arg_4_0)
					arg_4_0:xy(var_3_14.width / 2, var_3_14.height / 2 + 20)
					arg_4_0:scale(1)
				end
			}
		})
		var_3_12.time:text(string.format(gLanguageCsv.minute, var_3_10))

		local var_3_15 = var_3_6.periods * 60

		bind.touch(arg_3_0, var_3_12.btnDraw, {
			methods = {
				ended = function()
					arg_3_0:onDraw(var_3_12, var_3_13, iter_3_0)
				end
			}
		})

		if var_3_15 <= var_3_3 then
			var_3_12.btnDraw:setTouchEnabled(true)
			var_3_12.yilinqu:hide()
		else
			var_3_13:text(gLanguageCsv.notReach)
			var_3_12.btnDraw:setTouchEnabled(false)
			cache.setShader(var_3_12.btnDraw, false, "hsl_gray")
			var_3_12.yilinqu:hide()
		end

		for iter_3_4, iter_3_5 in pairs(var_3_4) do
			if iter_3_5 == iter_3_0 then
				var_3_13:text(gLanguageCsv.received)
				var_3_12.btnDraw:setTouchEnabled(false)
				cache.setShader(var_3_12.btnDraw, false, "hsl_gray")
				var_3_12.yilinqu:show()

				break
			end
		end
	end

	arg_3_0.totaltime = var_3_3

	arg_3_0:schedule(function(arg_6_0)
		arg_3_0.totaltime = arg_3_0.totaltime + 1

		for iter_6_0, iter_6_1 in pairs(var_3_0) do
			local var_6_0 = var_3_5[iter_6_0]

			arg_3_0:updateDraw(var_6_0, arg_3_0.totaltime, iter_6_0)
		end

		arg_3_0.labelTime:text(time.getCutDown(arg_3_0.totaltime).short_clock_str)
	end, 1, 1, 1)

	local var_3_16 = arg_3_0:getResourceNode()

	widget.addAnimationByKey(var_3_16, "hupazaixianlibao/hupazaixianlibao.skel", "hupazaixianlibao", "effect_loop", 1):anchorPoint(cc.p(0.5, 0.5)):scale(2):xy(var_3_16:width() / 2, var_3_16:height() / 2)
	var_0_1.setCountdown(arg_3_1.view, arg_3_1.uiTime, {
		data = var_3_1,
		tag = arg_3_1.tag,
		cb = arg_3_1.cb
	})
	Dialog.onCreate(arg_3_0, {
		blackType = 1
	})
end

function var_0_1.onDraw(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	gGameApp:requestServer("/game/role/online_gift/award", function(arg_8_0)
		gGameUI:showGainDisplay(arg_8_0)
		arg_7_2:text(gLanguageCsv.received)
		arg_7_1.btnDraw:setTouchEnabled(false)
		cache.setShader(arg_7_1.btnDraw, false, "hsl_gray")
		arg_7_1.yilinqu:show()
	end, {
		idx = arg_7_3
	})
end

function var_0_1.onClose(arg_9_0)
	arg_9_0:unSchedule(1)
	Dialog.onClose(arg_9_0)
end

function var_0_1.updateDraw(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if arg_10_2 >= csv.online_gift[arg_10_3].periods * 60 then
		local var_10_0 = arg_10_1:multiget("time", "wp_kuang", "daoju", "btnDraw", "yilinqu")
		local var_10_1 = arg_10_1:get("btnDraw.txtDraw")
		local var_10_2 = var_10_0.btnDraw:isTouchEnabled()
		local var_10_3 = var_10_1:text()

		if var_10_2 == false and var_10_3 == gLanguageCsv.notReach then
			var_10_0.btnDraw:setTouchEnabled(true)
			var_10_1:text(gLanguageCsv.spaceReceive)
		end
	end
end

function var_0_1.setCountdown(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_2.data
	local var_11_1 = arg_11_2.tag or 1
	local var_11_2 = var_11_0.starttime or 0
	local var_11_3 = var_11_0.totaltime or 0

	if not var_11_0.idx then
		local var_11_4 = 0
	end

	local var_11_5 = time.getTime()
	local var_11_6 = 0

	for iter_11_0, iter_11_1 in orderCsvPairs(csv.online_gift) do
		var_11_6 = csv.online_gift[iter_11_0].periods * 60

		if var_11_3 < var_11_6 then
			break
		end
	end

	local var_11_7 = var_11_6 + var_11_2 - var_11_3

	bind.extend(arg_11_0, arg_11_1, {
		class = "cutdown_label",
		props = {
			delay = 1,
			endTime = var_11_7 + 1,
			tag = var_11_1,
			endFunc = function()
				if arg_11_2.cb then
					arg_11_2.cb()
				else
					arg_11_1:text(time.getCutDown(0).str)
				end
			end
		}
	})
end

return var_0_1
