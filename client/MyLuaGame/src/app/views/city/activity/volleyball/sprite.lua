local var_0_0 = 20
local var_0_1 = class("spriteModel")

function var_0_1.ctor(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0.netPos = arg_1_1
	arg_1_0.netSize = arg_1_2
	arg_1_0.image = nil
	arg_1_0.tick = var_0_0
	arg_1_0.updateRate = 0
	arg_1_0.turn = arg_1_4 == 1 and 1 or -1
	arg_1_0.force = arg_1_4
	arg_1_0.floorY = 170
	arg_1_0.hitBallY = 350
	arg_1_0.speed = cc.p(0, 0)
	arg_1_0.optimalFallArea = {
		350,
		500
	}
	arg_1_0.slowSpeedSign = false
	arg_1_0.slowSpeedRate = 1
	arg_1_0.stockpileSign = false
	arg_1_0.stockpileForce = 0
	arg_1_0.skillHitTimes = {
		0,
		0
	}
	arg_1_0.batSign = false
	arg_1_0.batTimes = 0
	arg_1_0.spikeSwitch = false
	arg_1_0.pos = cc.p(0, 0)
	arg_1_0.offset = cc.p(arg_1_0.turn * arg_1_3.hitOffsetPos.x, arg_1_3.hitOffsetPos.y)
	arg_1_0.headCenterPos = cc.pAdd(arg_1_0.pos, arg_1_0.offset)
	arg_1_0.data = arg_1_3
	arg_1_0.res = arg_1_3.res
	arg_1_0.scale = arg_1_3.scale
	arg_1_0.power = arg_1_3.power
	arg_1_0.gravity = arg_1_3.gravity
	arg_1_0.hitRadius = arg_1_3.hitRadius
	arg_1_0.lrSpeedDelta = arg_1_3.lrSpeedDelta
	arg_1_0.udSpeedDelta = arg_1_3.udSpeedDelta
	arg_1_0.failRate = arg_1_3.failRate
	arg_1_0.operateAni = "run_loop"
end

function var_0_1.createImage(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0.force == 1 and 9 or 7
	local var_2_1 = arg_2_0.netPos.x - arg_2_0.turn * 800
	local var_2_2 = arg_2_0.floorY

	arg_2_0.originPos = cc.p(var_2_1, var_2_2)
	arg_2_0.image = widget.addAnimationByKey(arg_2_1, arg_2_0.res, arg_2_0.force .. "image", "run_loop", var_2_0):xy(var_2_1, var_2_2):scaleX(arg_2_0.turn * arg_2_0.scale):scaleY(arg_2_0.scale):anchorPoint(0.5, 0.5)
	arg_2_0.pos = cc.p(var_2_1, var_2_2)
	arg_2_0.headCenterPos = cc.pAdd(arg_2_0.pos, arg_2_0.offset)
	arg_2_0.stockPile = arg_2_2
	arg_2_0.stockPilePro = arg_2_3
	arg_2_0.stockPileEffect = widget.addAnimationByKey(arg_2_1, "volleyball_xuli/xuli.skel", arg_2_0.force .. "stockEffect", "xuli_loop", 10):xy(arg_2_0.pos.x, arg_2_0.floorY):scale(1.5):anchorPoint(0.5, 0.5):hide()
	arg_2_0.controlEffect = widget.addAnimationByKey(arg_2_1, "volleyball_buff/buff.skel", arg_2_0.force .. "controlEffect", "jiansu_loop", 15):xy(arg_2_0.pos.x, arg_2_0.floorY):scale(1.5):anchorPoint(0.5, 0.5):hide()
end

function var_0_1.deleteImage(arg_3_0)
	arg_3_0.image:removeSelf()
	arg_3_0.stockPile:hide()
end

function var_0_1.reset(arg_4_0)
	arg_4_0.pos = cc.p(arg_4_0.initPos.x, arg_4_0.initPos.y)
	arg_4_0.headCenterPos = cc.pAdd(arg_4_0.pos, arg_4_0.offset)
	arg_4_0.speed = cc.p(0, 0)
	arg_4_0.batTimes = 0
	arg_4_0.hitRadius = arg_4_0.data.hitRadius
	arg_4_0.slowSpeedRate = 1
	arg_4_0.slowSpeedSign = false
	arg_4_0.stockpileForce = 0
	arg_4_0.stockpileSign = false

	arg_4_0.controlEffect:hide()
	arg_4_0.stockPileEffect:hide()
end

function var_0_1.stockpile(arg_5_0)
	if arg_5_0.stockpileSign then
		arg_5_0.stockPile:show()
		arg_5_0.stockPileEffect:show()

		arg_5_0.stockpileForce = math.min(math.max(arg_5_0.stockpileForce, 0) + 0.1, 4)
	else
		arg_5_0.stockpileForce = math.max(arg_5_0.stockpileForce - 0.03, 0)

		if arg_5_0.stockpileForce == 0 then
			arg_5_0.stockPile:hide()
			arg_5_0.stockPileEffect:hide()
		end
	end
end

function var_0_1.resetSpike(arg_6_0)
	if not arg_6_0.spikeSwitch then
		arg_6_0.spikeSwitch = true
		arg_6_0.lrSpeedDelta = 8
		arg_6_0.udSpeedDelta = 24
		arg_6_0.hitBallY = 525
	else
		arg_6_0.spikeSwitch = false
		arg_6_0.lrSpeedDelta = arg_6_0.data.lrSpeedDelta
		arg_6_0.udSpeedDelta = arg_6_0.data.udSpeedDelta
		arg_6_0.hitBallY = arg_6_0.data.hitBallY
	end
end

function var_0_1.updateView(arg_7_0)
	arg_7_0.headCenterPos = cc.pAdd(arg_7_0.pos, arg_7_0.offset)

	if arg_7_0.force == 1 then
		arg_7_0.image:x(arg_7_0.pos.x)
	else
		arg_7_0.image:xy(arg_7_0.pos)
	end

	arg_7_0.stockPilePro:set(arg_7_0.stockpileForce / 4 * 100)
	arg_7_0.stockPile:setPosition(cc.p(arg_7_0.headCenterPos.x, arg_7_0.headCenterPos.y + 100))
	arg_7_0.stockPileEffect:xy(arg_7_0.pos.x, arg_7_0.floorY)
	arg_7_0.controlEffect:xy(arg_7_0.pos.x, arg_7_0.followSelf and arg_7_0.pos.y or arg_7_0.floorY)
end

function var_0_1.move(arg_8_0)
	local var_8_0 = arg_8_0.force
	local var_8_1 = arg_8_0.pos.x
	local var_8_2 = arg_8_0.pos.y
	local var_8_3 = 1

	if arg_8_0.stockpileSign then
		var_8_3 = 0.5
	end

	if var_8_0 == 2 then
		var_8_3 = arg_8_0.slowSpeedRate
	end

	local var_8_4 = var_8_1 + var_8_3 * arg_8_0.speed.x
	local var_8_5 = var_8_2 + arg_8_0.speed.y

	if var_8_0 == 1 then
		local var_8_6 = arg_8_0.image:getBonePosition("tou").y - arg_8_0.initBonePos.y

		var_8_6 = var_8_6 > 0 and var_8_6 or 0
		var_8_5 = arg_8_0.initPos.y + 1.45 * var_8_6
	else
		arg_8_0.speed.y = arg_8_0.speed.y + arg_8_0.gravity
	end

	if var_8_2 <= arg_8_0.floorY and arg_8_0.speed.y < 0 then
		var_8_5 = arg_8_0.floorY
		arg_8_0.speed.y = 0
	end

	local var_8_7 = (var_8_0 == 1 and 0 or 1560) + arg_8_0.turn * 100

	if var_8_0 == 1 then
		if var_8_4 <= var_8_7 then
			var_8_4 = var_8_7 + 1
			arg_8_0.speed.x = 0
		elseif var_8_4 >= arg_8_0.netPos.x - arg_8_0.netSize.width / 2 - 2 * arg_8_0.hitRadius then
			var_8_4 = arg_8_0.netPos.x - arg_8_0.netSize.width / 2 - 2 * arg_8_0.hitRadius - 1
			arg_8_0.speed.x = 0
		end
	elseif var_8_7 <= var_8_4 then
		var_8_4 = var_8_7 - 1
		arg_8_0.speed.x = 0
	elseif var_8_4 <= arg_8_0.netPos.x + arg_8_0.netSize.width / 2 + 2 * arg_8_0.hitRadius then
		var_8_4 = arg_8_0.netPos.x + arg_8_0.netSize.width / 2 + 2 * arg_8_0.hitRadius + 1
		arg_8_0.speed.x = 0
	end

	arg_8_0.pos = cc.p(var_8_4, var_8_5)
	arg_8_0.headCenterPos = cc.pAdd(arg_8_0.pos, arg_8_0.offset)

	if var_8_0 == 2 and not arg_8_0.isHideState then
		arg_8_0:moveAuto()
	end
end

function var_0_1.moveAuto(arg_9_0)
	arg_9_0.updateRate = arg_9_0.updateRate + 1

	if arg_9_0.updateRate < arg_9_0.tick then
		return
	end

	arg_9_0.updateRate = 0

	if arg_9_0.lastUpdateFunc then
		local var_9_0 = arg_9_0.lastUpdateFunc

		if arg_9_0:lastUpdateFunc(arg_9_0) == false and var_9_0 == arg_9_0.lastUpdateFunc then
			arg_9_0.lastUpdateFunc = nil
			arg_9_0.tick = var_0_0
		end
	else
		arg_9_0:randomMove()
	end
end

function var_0_1.randomMove(arg_10_0)
	if math.random(3) == 1 and arg_10_0.speed.y == 0 then
		arg_10_0.speed.y = arg_10_0.udSpeedDelta / 1.5
	end

	if math.random(3) == 1 then
		arg_10_0.speed.x = arg_10_0.lrSpeedDelta / 5
	else
		arg_10_0.speed.x = -arg_10_0.lrSpeedDelta / 5
	end
end

function var_0_1.runUntil(arg_11_0, arg_11_1)
	arg_11_0.tick = 0
	arg_11_0.lastUpdateFunc = arg_11_1
end

function var_0_1.calJumpUpTime(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0.headCenterPos.y
	local var_12_1 = arg_12_0.udSpeedDelta / -arg_12_0.gravity
	local var_12_2 = var_12_0 + arg_12_0.udSpeedDelta * var_12_1 + 0.5 * arg_12_0.gravity * var_12_1 * var_12_1
	local var_12_3 = arg_12_1 - var_12_0

	return (-arg_12_0.udSpeedDelta + math.sqrt(arg_12_0.udSpeedDelta * arg_12_0.udSpeedDelta + 2 * arg_12_0.gravity * var_12_3)) / arg_12_0.gravity
end

function var_0_1.onEvent_hit(arg_13_0, arg_13_1, arg_13_2)
	if arg_13_0.force == 2 and arg_13_0.slowSpeedRate == 0 then
		return
	end

	if arg_13_0.speed.y > 0 then
		return arg_13_0:runUntil(function()
			if arg_13_0.speed.y <= 0 then
				arg_13_0.speed.y = 0

				arg_13_0:onEvent_hit(arg_13_1, arg_13_2)

				return false
			end
		end)
	end

	local var_13_0, var_13_1 = arg_13_1:calBallFallCoordinate(arg_13_0.hitBallY)

	if not var_13_0 then
		var_13_0, var_13_1 = arg_13_1:calBallFallCoordinate(arg_13_0.data.hitBallY)

		if not var_13_0 then
			return
		end

		if arg_13_2.hitForce == 2 then
			arg_13_0:resetSpike()
		end
	end

	if var_13_0 < arg_13_0.netPos.x then
		return
	end

	local var_13_2 = var_13_0 - arg_13_0.headCenterPos.x

	arg_13_0.speed.x = (var_13_2 < 0 and -1 or 1) * arg_13_0.lrSpeedDelta

	local var_13_3 = arg_13_0:calJumpUpTime(var_13_1 - (arg_13_0.hitRadius + arg_13_1.radius))

	if var_13_3 then
		local var_13_4 = math.floor(var_13_3 + 0.5)
		local var_13_5 = math.random(0, 100) < arg_13_0.failRate and arg_13_0.batTimes >= 1 and 200 or 0
		local var_13_6 = var_13_0 - var_13_4 * arg_13_1.speed.x - var_13_5

		arg_13_0:runUntil(function()
			if math.abs(arg_13_0.headCenterPos.x - var_13_0) < arg_13_0.lrSpeedDelta then
				arg_13_0.headCenterPos.x = var_13_0
				arg_13_0.pos.x = arg_13_0.headCenterPos.x - arg_13_0.offset.x
				arg_13_0.speed.x = 0
			end

			if math.abs(arg_13_1.pos.x - var_13_6) < arg_13_0.lrSpeedDelta then
				arg_13_0.speed.x = 0
				arg_13_0.speed.y = arg_13_0.udSpeedDelta

				return false
			end
		end)
	end
end

function var_0_1.opAniAction(arg_16_0, arg_16_1)
	if tolua.isnull(arg_16_0.image) then
		return
	end

	if arg_16_0.operateAni == "effect_daqiu1" then
		if arg_16_1 == "run_loop" then
			arg_16_0.image:play(arg_16_1)

			arg_16_0.operateAni = arg_16_1
		end
	elseif arg_16_1 ~= arg_16_0.operateAni then
		arg_16_0.image:play(arg_16_1)

		arg_16_0.operateAni = arg_16_1
	end
end

function var_0_1.onEvent_playPreHitAni(arg_17_0, arg_17_1, arg_17_2)
	if arg_17_0.stockpileSign and arg_17_0.operateAni ~= "effect_daqiu2" then
		arg_17_0:opAniAction("effect_daqiu2")
		performWithDelay(arg_17_2.node, function()
			arg_17_0:opAniAction("run_loop")
		end, 0.8)
	end
end

function var_0_1.onEvent_playHitAni(arg_19_0, arg_19_1, arg_19_2)
	if not arg_19_0.stockpileSign and arg_19_1.speed.x * arg_19_0.turn < 0 then
		arg_19_0:opAniAction("hit")
		performWithDelay(arg_19_2.node, function()
			arg_19_0:opAniAction("run_loop")
		end, 0.6)
	end
end

function var_0_1.onEvent_playJumpAni(arg_21_0, arg_21_1, arg_21_2)
	if arg_21_0.operateAni ~= "effect_daqiu1" then
		arg_21_0:opAniAction("effect_daqiu1")
		performWithDelay(arg_21_2.node, function()
			arg_21_0:opAniAction("run_loop")
		end, 0.7)
	end
end

function var_0_1.onEvent_playSkillAni(arg_23_0, arg_23_1, arg_23_2)
	if arg_23_0.slowSpeedRate == 0 then
		arg_23_0.controlEffect:play("shufu_loop")

		arg_23_0.followSelf = true
	else
		arg_23_0.controlEffect:play("jiansu_loop")

		arg_23_0.followSelf = false
	end

	arg_23_0.controlEffect:show()
end

function var_0_1.onEvent_palsy(arg_24_0, arg_24_1, arg_24_2)
	if arg_24_0.batTimes >= 6 then
		arg_24_0.batTimes = 0
		arg_24_0.slowSpeedRate = 0
	elseif arg_24_0.batTimes >= 3 then
		arg_24_0.batTimes = arg_24_0.batTimes - 3
		arg_24_0.slowSpeedRate = 0.25
	end
end

return var_0_1
