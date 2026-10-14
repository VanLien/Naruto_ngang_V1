local var_0_0 = class("TimeSpeederIcon", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "common_time_speeder_icon.json"
var_0_0.RESOURCE_BINDING = {
	icon = "icon"
}

function var_0_0.onCreate(arg_1_0)
	arg_1_0:enableSchedule()
	arg_1_0.icon:onTouch(functools.partial(arg_1_0.iconTouch, arg_1_0))
	performWithDelay(arg_1_0, function()
		local var_2_0 = {
			x = display.sizeInViewRect.width * 2 / 5,
			y = display.sizeInViewRect.height * 3 / 5
		}
		local var_2_1 = userDefault.getForeverLocalKey("timeSpeederPos", var_2_0, {
			rawKey = true
		})

		arg_1_0.icon:xy(arg_1_0:getEdgePos(var_2_1)[1])
	end, 0)
end

function var_0_0.iconTouch(arg_3_0, arg_3_1)
	if arg_3_1.name == "began" then
		arg_3_0.touchBeganPos = arg_3_1
		arg_3_0.isMoved = false

		arg_3_0.icon:scale(1.2)
		arg_3_0.icon:xy(arg_3_1)
		arg_3_0:stopAllActions()
		arg_3_0.icon:stopAllActions()
		arg_3_0.icon:unscheduleUpdate()
	elseif arg_3_1.name == "moved" then
		arg_3_0.icon:scale(1.2)

		arg_3_1.x = math.max(display.sizeInViewRect.x, math.min(arg_3_1.x, display.sizeInViewRect.x + display.sizeInViewRect.width))
		arg_3_1.y = math.max(display.sizeInViewRect.y, math.min(arg_3_1.y, display.sizeInViewRect.y + display.sizeInViewRect.height))

		if math.abs(arg_3_1.x - arg_3_0.touchBeganPos.x) > ui.TOUCH_MOVED_THRESHOLD or math.abs(arg_3_1.y - arg_3_0.touchBeganPos.y) > ui.TOUCH_MOVED_THRESHOLD then
			arg_3_0.isMoved = true
		end

		arg_3_0.icon:xy(arg_3_1)
	elseif arg_3_1.name == "ended" or arg_3_1.name == "cancelled" then
		arg_3_0.touchEndTime = socket.gettime()

		arg_3_0.icon:scheduleUpdate(function()
			if socket.gettime() - arg_3_0.touchEndTime >= 2 then
				arg_3_0:iconMoveToEdge(arg_3_1)

				return false
			end
		end)

		if arg_3_1.name == "ended" and not arg_3_0.isMoved then
			arg_3_0:showTimeSpeeder()
		end
	end
end

function var_0_0.getEdgePos(arg_5_0, arg_5_1)
	local var_5_0 = {
		{
			l = arg_5_1.x - display.sizeInViewRect.x,
			pos = cc.p(display.sizeInViewRect.x, arg_5_1.y),
			prePos = cc.p(display.sizeInViewRect.x + 300, arg_5_1.y)
		},
		{
			l = display.sizeInViewRect.x + display.sizeInViewRect.width - arg_5_1.x,
			pos = cc.p(display.sizeInViewRect.x + display.sizeInViewRect.width, arg_5_1.y),
			prePos = cc.p(display.sizeInViewRect.x + display.sizeInViewRect.width - 300, arg_5_1.y)
		},
		{
			l = arg_5_1.y - display.sizeInViewRect.y,
			pos = cc.p(arg_5_1.x, display.sizeInViewRect.y),
			prePos = cc.p(arg_5_1.x, display.sizeInViewRect.y + 200)
		},
		{
			l = display.sizeInViewRect.y + display.sizeInViewRect.height - arg_5_1.y,
			pos = cc.p(arg_5_1.x, display.sizeInViewRect.y + display.sizeInViewRect.height),
			prePos = cc.p(arg_5_1.x, display.sizeInViewRect.y + display.sizeInViewRect.height - 200)
		}
	}
	local var_5_1 = 1

	for iter_5_0 = 2, 4 do
		if var_5_0[iter_5_0].l < var_5_0[var_5_1].l then
			var_5_1 = iter_5_0
		end
	end

	return var_5_0[var_5_1].pos, var_5_0[var_5_1].prePos
end

function var_0_0.iconMoveToEdge(arg_6_0, arg_6_1)
	arg_6_0:stopAllActions()
	arg_6_0.icon:stopAllActions()
	arg_6_0.icon:unscheduleUpdate()

	local var_6_0 = arg_6_0:getEdgePos(arg_6_1)

	arg_6_0.icon:runAction(cc.EaseSineInOut:create(cc.MoveTo:create(0.3 * gGameUI:getTimeScale(true), var_6_0)))
	arg_6_0.icon:scale(1)
	userDefault.setForeverLocalKey("timeSpeederPos", {
		x = var_6_0.x,
		y = var_6_0.y
	}, {
		rawKey = true
	})
end

function var_0_0.showAni(arg_7_0)
	arg_7_0:stopAllActions()
	arg_7_0.icon:stopAllActions()
	arg_7_0.icon:unscheduleUpdate()

	local var_7_0 = cc.p(arg_7_0.icon:xy())
	local var_7_1, var_7_2 = arg_7_0:getEdgePos(var_7_0)

	arg_7_0.icon:xy(var_7_2)
	arg_7_0.icon:show()
	performWithDelay(arg_7_0, function()
		arg_7_0:iconMoveToEdge(var_7_0)
	end, 1 * gGameUI:getTimeScale(true))
end

function var_0_0.showTimeSpeeder(arg_9_0)
	if gGameUI.timeSpeederManager.isYield() then
		gGameUI:showTip(gLanguageCsv.speedUpForbidden)

		return
	end

	gGameUI:showTimeSpeeder()
end

return var_0_0
