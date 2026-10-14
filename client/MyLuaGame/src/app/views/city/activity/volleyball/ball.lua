local var_0_0 = class("ballModel")

function var_0_0.ctor(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.netPos = arg_1_1
	arg_1_0.netSize = arg_1_2
	arg_1_0.radius = 40
	arg_1_0.floorY = 200
	arg_1_0.gravity = -0.2
	arg_1_0.dropY = 650
	arg_1_0.collisionForce = 7
	arg_1_0.pos = cc.p(0, 0)
	arg_1_0.speed = cc.p(0, 0)
	arg_1_0.initPos = cc.p(0, 0)
	arg_1_0.image = nil
	arg_1_0.shadow = nil
end

function var_0_0.createImage(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.initPos = arg_2_2
	arg_2_0.serveAction = true

	local var_2_0 = arg_2_0.initPos[1].x + 1.3 * arg_2_0.radius
	local var_2_1 = arg_2_0.dropY

	arg_2_0.image = widget.addAnimationByKey(arg_2_1, "volleyball_qiu/paiqiutexiao.skel", "volleyBall", "effect_xuanzhuan_loop", 11):xy(var_2_0, var_2_1):scale(2.1):anchorPoint(0.5, 0.5)
	arg_2_0.pos = cc.p(var_2_0, var_2_1)
	arg_2_0.shadow = ccui.ImageView:create("activity/volleyball/yinying.png"):addTo(arg_2_1, 4, "yinying"):xy(var_2_0, 170):scale(0.7):anchorPoint(0.5, 0.5)
end

function var_0_0.deleteImage(arg_3_0)
	arg_3_0.image:removeSelf()
	arg_3_0.shadow:removeSelf()
end

function var_0_0.reset(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_1 == 1 and 1 or -1

	arg_4_0.pos = cc.p(arg_4_0.initPos[arg_4_1].x + var_4_0 * 1.3 * arg_4_0.radius, arg_4_0.dropY)
	arg_4_0.serveAction = true
	arg_4_0.speed = cc.p(0, 0)

	arg_4_0.image:play("effect_xuanzhuan_loop")
end

function var_0_0.updateView(arg_5_0)
	arg_5_0.image:xy(arg_5_0.pos)
	arg_5_0.shadow:x(arg_5_0.pos.x)
end

function var_0_0.move(arg_6_0)
	local var_6_0 = arg_6_0.pos.x
	local var_6_1 = arg_6_0.pos.y

	arg_6_0.speed.y = arg_6_0.speed.y + arg_6_0.gravity

	local var_6_2 = var_6_0 + arg_6_0.speed.x
	local var_6_3 = var_6_1 + arg_6_0.speed.y

	if var_6_3 < arg_6_0.floorY then
		var_6_3 = arg_6_0.floorY
		arg_6_0.speed.x = 0
		arg_6_0.speed.y = 0
	end

	local var_6_4 = arg_6_0.netPos.x
	local var_6_5 = arg_6_0.netSize.width

	if var_6_3 <= arg_6_0.netPos.y + arg_6_0.netSize.height / 2 then
		if var_6_2 + arg_6_0.radius >= var_6_4 - var_6_5 / 4 and var_6_2 + arg_6_0.radius <= var_6_4 + var_6_5 * 3 / 4 and arg_6_0.speed.x > 0 then
			arg_6_0.speed.x = -0.5
		elseif var_6_2 - arg_6_0.radius >= var_6_4 - var_6_5 / 2 and var_6_2 - arg_6_0.radius <= var_6_4 + var_6_5 / 4 and arg_6_0.speed.x < 0 then
			local var_6_6 = math.random(0, 400) / 100

			arg_6_0.speed.x = var_6_6
		end
	end

	arg_6_0.pos = cc.p(var_6_2, var_6_3)
end

function var_0_0.calBallFallCoordinate(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.pos.x
	local var_7_1 = arg_7_0.pos.y
	local var_7_2 = arg_7_1 - var_7_1
	local var_7_3 = arg_7_0.speed.y * arg_7_0.speed.y + 2 * arg_7_0.gravity * var_7_2
	local var_7_4 = (-arg_7_0.speed.y + math.sqrt(var_7_3)) / arg_7_0.gravity
	local var_7_5 = (-arg_7_0.speed.y - math.sqrt(var_7_3)) / arg_7_0.gravity

	if var_7_3 < 0 or var_7_5 < 0 then
		return
	end

	local var_7_6 = math.floor(var_7_5)

	return var_7_0 + arg_7_0.speed.x * var_7_6, var_7_1 + arg_7_0.speed.y * var_7_6 + 0.5 * arg_7_0.gravity * var_7_6 * var_7_6
end

function var_0_0.calReturnBallSpeedX(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_1.optimalFallArea
	local var_8_1 = arg_8_0.pos.x
	local var_8_2 = arg_8_0.pos.y
	local var_8_3 = arg_8_0.collisionForce + arg_8_1.power + arg_8_1.stockpileForce
	local var_8_4 = arg_8_0.floorY - var_8_2
	local var_8_5 = (-var_8_3 + math.sqrt(var_8_3 * var_8_3 + 2 * arg_8_0.gravity * var_8_4)) / arg_8_0.gravity
	local var_8_6 = (-var_8_3 - math.sqrt(var_8_3 * var_8_3 + 2 * arg_8_0.gravity * var_8_4)) / arg_8_0.gravity
	local var_8_7 = math.floor(var_8_6)
	local var_8_8 = {}

	for iter_8_0 = 1, 2 do
		var_8_8[iter_8_0] = math.abs(arg_8_0.netPos.x - var_8_0[iter_8_0] - var_8_1) / var_8_7
	end

	return math.random(var_8_8[1], var_8_8[2])
end

function var_0_0.onEvent_collision(arg_9_0, arg_9_1, arg_9_2)
	if arg_9_1.force == 2 and arg_9_1.slowSpeedRate == 0 then
		return
	end

	local var_9_0 = arg_9_0.pos.x - arg_9_1.headCenterPos.x
	local var_9_1 = arg_9_0.pos.y - arg_9_1.headCenterPos.y
	local var_9_2 = (arg_9_0.radius + arg_9_1.hitRadius) * (arg_9_0.radius + arg_9_1.hitRadius) - var_9_0 * var_9_0 - var_9_1 * var_9_1

	if var_9_2 > 0 and math.sqrt(var_9_2) > 10 then
		if var_9_1 <= 0 then
			local var_9_3 = var_9_0 / math.abs(var_9_0)

			arg_9_0.pos.x = arg_9_0.pos.x + var_9_3 / 2
		else
			local var_9_4 = var_9_1 / math.abs(var_9_1)
			local var_9_5 = var_9_4 * ((var_9_0 * var_9_1 < 0 and -1 or 1) * math.min(math.abs(var_9_0 / var_9_1), 1))

			arg_9_0.pos.y = arg_9_0.pos.y + var_9_4 / 2
			arg_9_0.pos.x = arg_9_0.pos.x + var_9_5 / 2
		end

		arg_9_0:onEvent_collision(arg_9_1, arg_9_2)
	end

	local var_9_6 = arg_9_1.force == 2
	local var_9_7 = arg_9_1.turn

	if (var_9_0 < -1 and -1 or 1) ~= var_9_7 then
		if var_9_6 then
			var_9_0 = (math.random(-10, 10) + 100) / 100 * var_9_1
		else
			if math.abs(var_9_1 / var_9_0) >= 1 and var_9_1 > 0 then
				var_9_0 = var_9_1
			end

			var_9_7 = var_9_0 < 0 and -1 or 1
		end
	end

	local var_9_8 = arg_9_0.collisionForce
	local var_9_9 = var_9_7 * math.min(math.abs(var_9_8 * var_9_0 / var_9_1), var_9_8)
	local var_9_10 = var_9_8 + arg_9_1.power + arg_9_1.stockpileForce

	if var_9_6 then
		var_9_9 = var_9_7 * arg_9_0:calReturnBallSpeedX(arg_9_1)
	elseif arg_9_0.serveAction then
		var_9_10 = math.min(1.5 * var_9_10, 10)
	end

	arg_9_0.speed.x = var_9_9
	arg_9_0.speed.y = var_9_10
end

function var_0_0.onEvent_playSkillAni(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = {
		"effect_bing",
		"effect_chaoneng",
		"effect_dian",
		"effect_yanshi"
	}
	local var_10_1 = arg_10_1.slowSpeedRate == 0 and 2 or 1

	if arg_10_2.reset == true then
		arg_10_1.skillHitTimes[var_10_1] = arg_10_1.skillHitTimes[var_10_1] + 1

		arg_10_0.image:play("effect_xuanzhuan_loop")
	else
		local var_10_2 = var_10_0[arg_10_1.data.skillType] .. var_10_1 .. "_loop"

		arg_10_0.image:play(var_10_2)
	end
end

return var_0_0
