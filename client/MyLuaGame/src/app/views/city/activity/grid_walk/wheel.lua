local var_0_0 = 8
local var_0_1 = 2
local var_0_2 = 1
local var_0_3 = 720
local var_0_4 = require("app.views.city.activity.grid_walk.tools")
local var_0_5 = cc.load("mvc").ViewBase
local var_0_6 = class("GridWalkWheelView", var_0_5)

var_0_6.RESOURCE_FILENAME = "grid_walk_wheel.json"
var_0_6.RESOURCE_BINDING = {
	wheelPanel = "wheelPanel",
	["wheelPanel.wheel"] = "wheel",
	["wheelPanel.wheelPointer"] = {
		varname = "wheelPointer",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDraw")
			}
		}
	}
}

function var_0_6.onCreate(arg_1_0, arg_1_1)
	arg_1_0.event = arg_1_1.event
	arg_1_0.callBack = arg_1_1.callBack

	arg_1_0:initModel()
	arg_1_0:initReward()
	arg_1_0:initSkel()
end

function var_0_6.initModel(arg_2_0)
	arg_2_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_2_0.yyId = gGameModel.role:read("grid_walk").yy_id
	arg_2_0.opened = idler.new(false)
end

function var_0_6.initReward(arg_3_0)
	arg_3_0.rewardDatas = {}

	local var_3_0 = csv.yunying.yyhuodong[arg_3_0.yyId].huodongID
	local var_3_1 = var_0_4.getCfgByEventFromEvents(var_0_4.EVENTS.goodLuck, var_3_0)

	for iter_3_0, iter_3_1 in csvMapPairs(var_3_1.params.items) do
		table.insert(arg_3_0.rewardDatas, {
			key = iter_3_1[1],
			num = iter_3_1[2]
		})
	end

	for iter_3_2 = 1, var_0_0 do
		local var_3_2 = arg_3_0.wheel:get("name" .. iter_3_2)
		local var_3_3 = arg_3_0.wheel:get("icon" .. iter_3_2)

		if var_3_2 then
			var_3_2:text("")

			local var_3_4 = arg_3_0.rewardDatas[iter_3_2]

			uiEasy.setIconName(var_3_4.key, var_3_4.num, {
				node = var_3_2
			})
			adapt.setTextAdaptWithSize(var_3_2, {
				vertical = "center",
				horizontal = "center",
				size = cc.size(260, 200)
			})

			local var_3_5 = true

			if var_3_4.key == "card" then
				var_3_5 = false
			end

			bind.extend(arg_3_0, var_3_3, {
				class = "icon_key",
				props = {
					data = var_3_4,
					simpleShow = var_3_5,
					onNode = function(arg_4_0)
						arg_4_0:scale(0.9)
					end
				}
			})
		end
	end
end

function var_0_6.onDraw(arg_5_0)
	arg_5_0.wheelPointer:setTouchEnabled(false)
	arg_5_0.wheelSkel:play("effect_chou")

	local var_5_0 = 0
	local var_5_1 = 0
	local var_5_2 = 0
	local var_5_3, var_5_4, var_5_5 = arg_5_0:getAniParams()

	arg_5_0:wheelAni(var_5_3, var_5_4, var_5_5)
	performWithDelay(arg_5_0, function()
		local var_6_0 = {}
		local var_6_1 = arg_5_0.rewardDatas[arg_5_0.event.params.outcome + 1]

		var_6_0[var_6_1.key] = var_6_1.num

		if var_6_1.key == var_0_4.BADGE_ID then
			arg_5_0.badgeNum = var_6_1.num
		end

		local function var_6_2()
			arg_5_0.opened:set(true)
			arg_5_0:onClose()
		end

		gGameUI:showGainDisplay(var_6_0, {
			cb = var_6_2
		})
		arg_5_0.wheelSkel:play("effect_loop")
		arg_5_0.wheelPointer:setTouchEnabled(true)
	end, var_5_3)
end

function var_0_6.wheelAni(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	arg_8_0.wheel:setRotation(0)
	transition.executeSequence(arg_8_0.wheel, true):easeBegin("EXPONENTIALOUT"):rotateBy(arg_8_1 - var_0_2, arg_8_2 - arg_8_3):rotateBy(var_0_2, arg_8_3 + 360):easeEnd():done()
end

function var_0_6.getAniParams(arg_9_0)
	local var_9_0 = var_0_1
	local var_9_1 = var_0_3
	local var_9_2 = arg_9_0.event.params.outcome + 1
	local var_9_3 = (var_0_0 - var_9_2 + 1) / var_0_0 * 360
	local var_9_4 = var_9_1 + var_9_3

	return var_9_0, var_9_4, var_9_3
end

function var_0_6.initSkel(arg_10_0)
	arg_10_0.wheelSkel = widget.addAnimationByKey(arg_10_0.wheelPanel, "gridwalk/jianglidzp.skel", "wheelSkel", "effect_loop", 2)

	arg_10_0.wheelSkel:anchorPoint(cc.p(0.5, 0.5)):xy(arg_10_0.wheelPointer:x(), arg_10_0.wheelPointer:y() - 10):scale(2)
end

function var_0_6.onClose(arg_11_0)
	if arg_11_0.opened:read() == true then
		arg_11_0:addCallbackOnExit(functools.partial(arg_11_0.callBack, arg_11_0.badgeNum))
		var_0_5.onClose(arg_11_0)
	end
end

return var_0_6
