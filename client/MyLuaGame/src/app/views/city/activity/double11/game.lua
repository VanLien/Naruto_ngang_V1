local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("Double11Game", var_0_0)

var_0_1.RESOURCE_FILENAME = "double_11_game.json"
var_0_1.RESOURCE_BINDING = {
	redPacketItem = "redPacketItem",
	panelCountDown = "panelCountDown",
	panelGame = {
		varname = "panelGame",
		binds = {
			res = "shuang11/diaohongbao.skel",
			name = "effectDiaohongbao",
			action = "effect_loop",
			event = "animation",
			pos = {
				x = 1560,
				y = 720
			}
		}
	},
	["panelGame.textCountDown"] = {
		varname = "textCountDown",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 8,
					color = cc.c3b(148, 31, 36)
				}
			}
		}
	},
	["panelGame.textNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("count"),
			method = function(arg_1_0)
				return "x" .. arg_1_0
			end
		}
	}
}

function var_0_1.onCreate(arg_2_0, arg_2_1, arg_2_2)
	gGameUI.topuiManager:createView("title", arg_2_0, {
		onClose = arg_2_0:createHandler("onClose")
	}):init({
		title = gLanguageCsv.double11,
		subTitle = gLanguageCsv.double11Subtitle
	})
	arg_2_0.panelCountDown:globalZ(1)

	arg_2_0.activityId = arg_2_1
	arg_2_0.nowIndex = arg_2_2

	arg_2_0:startCount()

	arg_2_0.count = idler.new(0)
	arg_2_0.gaming = false

	arg_2_0:initUI()
end

function var_0_1.initUI(arg_3_0)
	local var_3_0 = {}

	for iter_3_0, iter_3_1 in orderCsvPairs(csv.yunying.double11_game) do
		if iter_3_1.huodongID == csv.yunying.yyhuodong[arg_3_0.activityId].huodongID then
			var_3_0[iter_3_1.game] = iter_3_1.itemID
		end
	end

	arg_3_0.panelGame:get("imgRedPacket"):texture(dataEasy.getCfgByKey(var_3_0[arg_3_0.nowIndex]).icon)
	arg_3_0.redPacketItem:get("imgRedPacket"):texture(dataEasy.getCfgByKey(var_3_0[arg_3_0.nowIndex]).icon)
end

function var_0_1.gameStart(arg_4_0)
	gGameApp:requestServer("/game/yy/double11/game/start", function(arg_5_0)
		arg_4_0.gaming = true

		arg_4_0.panelCountDown:hide()
		arg_4_0.panelGame:show()
		arg_4_0:initCountDown()
		arg_4_0:initRedPacketAction()
	end, arg_4_0.activityId)
end

function var_0_1.startCount(arg_6_0)
	arg_6_0.panelCountDown:show()
	arg_6_0.panelGame:hide()

	local var_6_0 = 3

	arg_6_0:enableSchedule():schedule(function(arg_7_0)
		if var_6_0 > 0 then
			arg_6_0.panelCountDown:get("textNum"):text(var_6_0)
			adapt.oneLineCenterPos(cc.p(arg_6_0.panelCountDown:width() / 2, arg_6_0.panelCountDown:height() / 2), {
				arg_6_0.panelCountDown:get("textNote"),
				arg_6_0.panelCountDown:get("textNum")
			})

			var_6_0 = var_6_0 - 1
		else
			arg_6_0:gameStart()

			return false
		end
	end, 1, 0, 666)
end

function var_0_1.initCountDown(arg_8_0)
	local var_8_0 = csv.yunying.yyhuodong[arg_8_0.activityId].paramMap.playTime

	bind.extend(arg_8_0, arg_8_0.textCountDown, {
		class = "cutdown_label",
		props = {
			str_key = "short_clock_str",
			endTime = time.getTime() + var_8_0,
			endFunc = function()
				arg_8_0.gaming = false

				gGameApp:requestServer("/game/yy/double11/game/end", function(arg_10_0)
					local var_10_0 = gGameUI:stackUI("common.gain_display", nil, nil, arg_10_0, {
						cb = arg_8_0:createHandler("onClose")
					})

					rich.createByStr(gLanguageCsv.double11GainDisplayTitle, 40):addTo(var_10_0:getResourceNode(), 10):xy(var_10_0:getResourceNode():width() / 2, 900):anchorPoint(cc.p(0.5, 0.5)):formatText()
					arg_8_0.panelGame:get("effectDiaohongbao"):hide()
				end, arg_8_0.activityId, arg_8_0.count:read())
			end
		}
	})
end

function var_0_1.initRedPacketAction(arg_11_0)
	local var_11_0 = csv.yunying.yyhuodong[arg_11_0.activityId]
	local var_11_1 = var_11_0.paramMap.redPacketMax
	local var_11_2 = var_11_0.paramMap.playTime
	local var_11_3 = var_11_0.paramMap.timeMax
	local var_11_4 = var_11_0.paramMap.timeMin

	for iter_11_0 = 1, var_11_1 do
		local var_11_5 = math.random(var_11_4, var_11_3) / 1000
		local var_11_6 = arg_11_0.redPacketItem:clone():addTo(arg_11_0.panelGame):hide():scale(1.7)
		local var_11_7 = math.random(1, (var_11_2 - var_11_5) * 10) / 10
		local var_11_8 = math.random(arg_11_0.panelCountDown:width() / 2 - 800, arg_11_0.panelCountDown:width() / 2 + 800)

		var_11_6:xy(var_11_8, 1000)

		local var_11_9 = cc.DelayTime:create(var_11_7)
		local var_11_10 = cc.MoveTo:create(var_11_5, cc.p(var_11_8, -200))

		var_11_6:runAction(cc.Sequence:create(var_11_9, cc.Show:create(), var_11_10, cc.RemoveSelf:create()))
		var_11_6:addClickEventListener(function()
			var_11_6:setTouchEnabled(false)
			arg_11_0.count:modify(function(arg_13_0)
				return true, arg_13_0 + 1
			end, true)
			var_11_6:get("imgRedPacket"):hide()

			local var_12_0 = widget.addAnimationByKey(var_11_6, "shuang11/diaohongbao.skel", "effect1", "effect", 3):xy(var_11_6:size().width / 2, var_11_6:size().height / 2):scale(0.8)

			performWithDelay(var_11_6, function()
				var_11_6:stopAllActions()
				var_11_6:removeFromParent()
			end, 0.5)
		end)
	end
end

function var_0_1.onClose(arg_15_0)
	if not arg_15_0.gaming then
		var_0_0.onClose(arg_15_0)
	end
end

return var_0_1
