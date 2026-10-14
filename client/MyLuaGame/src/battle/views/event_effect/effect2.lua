local var_0_0 = class("MoveByDis", battleEffect.EventEffect)

battleEffect.MoveByDis = var_0_0

function var_0_0.onPlay(arg_1_0)
	local var_1_0 = arg_1_0.args
	local var_1_1 = var_1_0.speed
	local var_1_2 = math.max(var_1_1, 1)
	local var_1_3 = var_1_0.a
	local var_1_4 = cc.pGetLength(cc.p(var_1_0.x, var_1_0.y))
	local var_1_5 = math.max(var_1_4, 1)
	local var_1_6

	if var_1_3 == 0 then
		var_1_6 = var_1_5 / var_1_2
	else
		local var_1_7 = var_1_2 * var_1_2 + 2 * var_1_3 * var_1_5
		local var_1_8 = math.max(var_1_7, 0)

		var_1_6 = (math.sqrt(var_1_8) - var_1_2) / var_1_3
	end

	local var_1_9 = cc.MoveBy:create(var_1_6, cc.p(var_1_0.x, var_1_0.y))
	local var_1_10

	var_1_10 = transition.speed(arg_1_0.target, {
		speed = 1,
		action = transition.spawnEx():sequenceBegin():action(var_1_9):func(function()
			arg_1_0.target:runAction(var_1_9:reverse())
		end):sequenceEnd():func(function()
			var_1_10:setSpeed(1 + var_1_3 * var_1_9:getDuration())
		end):done()
	})

	arg_1_0.target:runAction(var_1_10)
	arg_1_0.view:setActionState(battle.SpriteActionTable.run)
end

function var_0_0.onUpdate(arg_4_0, arg_4_1)
	return
end

function var_0_0.onStop(arg_5_0, arg_5_1)
	arg_5_0.view:setActionState(battle.SpriteActionTable.standby)
end

local var_0_1 = class("MoveByTime", battleEffect.EventEffect)

battleEffect.MoveByTime = var_0_1

function var_0_1.onPlay(arg_6_0)
	local var_6_0 = arg_6_0.args
	local var_6_1 = var_6_0.speed
	local var_6_2 = var_6_0.a
	local var_6_3 = var_6_0.t
	local var_6_4 = var_6_0.angle
	local var_6_5 = var_6_1 * var_6_3 + var_6_2 * var_6_3 * var_6_3 / 2
	local var_6_6 = math.cos(math.rad(var_6_4)) * var_6_5
	local var_6_7 = math.sin(math.rad(var_6_4)) * var_6_5
	local var_6_8 = cc.Speed:create(cc.MoveBy:create(var_6_3, cc.p(var_6_6, var_6_7)), 2)

	arg_6_0.target:runAction(var_6_8)
	arg_6_0.view:setActionState(battle.SpriteActionTable.run)
end

function var_0_1.onUpdate(arg_7_0, arg_7_1)
	return
end

function var_0_1.onStop(arg_8_0, arg_8_1)
	arg_8_0.view:setActionState(battle.SpriteActionTable.standby)
end

local var_0_2 = class("MoveTo", battleEffect.EventEffect)

battleEffect.MoveTo = var_0_2

function var_0_2.onPlay(arg_9_0)
	local var_9_0 = arg_9_0.args
	local var_9_1 = var_9_0.speed
	local var_9_2 = var_9_0.a
	local var_9_3 = var_9_0.x
	local var_9_4 = var_9_0.y
	local var_9_5, var_9_6 = arg_9_0.target:getCurPos()
	local var_9_7 = cc.pGetLength(cc.p(var_9_3 - var_9_5, var_9_4 - var_9_6))
	local var_9_8
	local var_9_9 = 0
	local var_9_10 = var_9_0.turnBack
	local var_9_11 = var_9_0.knockUp
	local var_9_12 = var_9_0.knockUpBack

	if var_9_2 == 0 then
		var_9_8 = var_9_7 / var_9_1
	else
		local var_9_13 = var_9_1 * var_9_1 + 2 * var_9_2 * var_9_7
		local var_9_14 = math.max(var_9_13, 0)

		var_9_8 = (math.sqrt(var_9_14) - var_9_1) / var_9_2
	end

	if var_9_0.costTime and var_9_0.costTime >= 0 then
		var_9_8 = var_9_0.costTime / 1000
	end

	if var_9_0.delayMove then
		var_9_9 = var_9_0.delayMove / 1000
	end

	if var_9_0.timeScale then
		var_9_8 = var_9_8 * var_9_0.timeScale
	end

	local var_9_15

	if var_9_11 then
		local var_9_16

		if arg_9_0.target.force == 1 then
			var_9_16 = 1
		elseif arg_9_0.target.force == 2 then
			var_9_16 = -1
		end

		local function var_9_17()
			var_9_16 = var_9_16 * -1

			arg_9_0.target:setShowFaceTo(var_9_16)
		end

		var_9_15 = cc.Spawn:create(cc.EaseIn:create(cc.MoveTo:create(var_9_8, cc.p(var_9_3, var_9_4)), 2), cc.Repeat:create(cc.Sequence:create(cc.DelayTime:create(0.25), cc.CallFunc:create(var_9_17)), 4))
	else
		var_9_15 = cc.EaseIn:create(cc.MoveTo:create(var_9_8, cc.p(var_9_3, var_9_4)), 2)

		if var_9_8 == 0 then
			var_9_15 = cc.CallFunc:create(function()
				arg_9_0.target:setPosition(cc.p(var_9_3, var_9_4))
			end)
		end
	end

	local var_9_18 = false

	if var_9_10 then
		if arg_9_0.target.force == 1 and var_9_3 < var_9_5 then
			var_9_18 = true
		elseif arg_9_0.target.force == 2 and var_9_5 < var_9_3 then
			var_9_18 = true
		end
	end

	local var_9_19 = var_9_18 and -1 or 1

	local function var_9_20()
		if var_9_0.changeFaceTo then
			arg_9_0.target:setShowFaceTo(var_9_19 * var_9_0.changeFaceTo)

			var_9_19 = 1
		end
	end

	local var_9_21 = cc.Sequence:create(cc.CallFunc:create(var_9_20), cc.DelayTime:create(var_9_9), var_9_15, cc.CallFunc:create(var_9_20), cc.CallFunc:create(handler(arg_9_0, arg_9_0.stop)))

	arg_9_0.target:runAction(var_9_21)

	if not var_9_11 and not var_9_12 then
		arg_9_0.view:setActionState(battle.SpriteActionTable.run)
	end

	if var_9_11 then
		arg_9_0.target:isComeBacking(true)
	elseif var_9_12 then
		arg_9_0.target:isComeBacking(false)
	end
end

function var_0_2.onUpdate(arg_13_0, arg_13_1)
	return
end

function var_0_2.onStop(arg_14_0, arg_14_1)
	arg_14_0.view:setCurPos(cc.p(arg_14_0.args.x, arg_14_0.args.y))
	arg_14_0.view:setActionState(battle.SpriteActionTable.standby)
end

local var_0_3 = class("ComeBack", battleEffect.MoveTo)

battleEffect.ComeBack = var_0_3

function var_0_3.onPlay(arg_15_0)
	local var_15_0, var_15_1 = arg_15_0.target:getSelfPos()

	arg_15_0.args = {
		a = 2000,
		speed = 1500,
		turnBack = true,
		costTime = arg_15_0.args.costTime,
		delayMove = arg_15_0.args.delayMove,
		x = var_15_0,
		y = var_15_1,
		changeFaceTo = arg_15_0.target.forceFaceTo
	}

	battleEffect.MoveTo.onPlay(arg_15_0)
	arg_15_0.target:isComeBacking(true)
end

function var_0_3.onStop(arg_16_0, arg_16_1)
	battleEffect.MoveTo.onStop(arg_16_0, arg_16_1)
	arg_16_0.target:resetPos()
	arg_16_0.target:isComeBacking(false)
end

function var_0_3.debugString(arg_17_0)
	return string.format("ComeBack: %s", toDebugString(arg_17_0.target))
end

local var_0_4 = class("Callback", battleEffect.OnceEventEffect)

battleEffect.Callback = var_0_4

function var_0_4.onPlay(arg_18_0)
	arg_18_0.args.func()
end

local var_0_5 = class("OnceEffect", battleEffect.EventEffect)

battleEffect.OnceEffect = var_0_5

function var_0_5.onPlay(arg_19_0)
	local var_19_0 = arg_19_0.args

	arg_19_0.view:onViewProxyCall("onBuffPlayOnceEffect", var_19_0.tostrModel, var_19_0.resPath, var_19_0.aniName, var_19_0.pos, var_19_0.offsetPos, var_19_0.assignLayer, var_19_0.wait)
end

local var_0_6 = class("Wait", battleEffect.EventEffect)

battleEffect.Wait = var_0_6

function var_0_6.onUpdate(arg_20_0, arg_20_1)
	return
end

local var_0_7 = class("Jump", battleEffect.OnceEventEffect)

battleEffect.Jump = var_0_7

function var_0_7.onPlay(arg_21_0)
	if arg_21_0.args.jumpFlag and arg_21_0.view.skillJumpSwitchOnce then
		gRootViewProxy:raw():closeEffectEventEnable()
		arg_21_0.view:onCleanEffectCache()
	end
end

local var_0_8 = {}

var_0_8.__index = var_0_8
var_0_8.__targes = {
	"stageLayer",
	"gameLayer",
	"effectLayerNum"
}
var_0_8.__fmap = {
	getRotation = "setRotation",
	getPosition = "setPosition",
	getScaleX = "setScaleX",
	getScaleY = "setScaleY"
}

function var_0_8.new()
	local var_22_0 = setmetatable({}, var_0_8)

	var_22_0:ctor()

	return var_22_0
end

function var_0_8.ctor(arg_23_0)
	arg_23_0.view = gRootViewProxy:raw()
	arg_23_0.scaleX = 1
	arg_23_0.scaleY = 1
	arg_23_0.backups = {}
end

function var_0_8.runAction(arg_24_0, arg_24_1)
	return arg_24_0.view:runAction(arg_24_1)
end

function var_0_8.stopAction(arg_25_0, arg_25_1)
	return arg_25_0.view:stopAction(arg_25_1)
end

function var_0_8.revert(arg_26_0)
	for iter_26_0, iter_26_1 in pairs(arg_26_0.backups) do
		for iter_26_2, iter_26_3 in pairs(iter_26_1) do
			local var_26_0 = arg_26_0.view[iter_26_2]
			local var_26_1 = var_26_0[arg_26_0.__fmap[iter_26_0]]

			if type(iter_26_3) == "table" then
				var_26_1(var_26_0, unpack(iter_26_3))
			else
				var_26_1(var_26_0, iter_26_3)
			end
		end
	end

	arg_26_0.backups = {}
end

function var_0_8._backup(arg_27_0, arg_27_1, arg_27_2)
	if arg_27_0.backups[arg_27_1] then
		return
	end

	arg_27_2 = arg_27_2 or 1

	local var_27_0 = {}

	for iter_27_0, iter_27_1 in ipairs(arg_27_0.__targes) do
		local var_27_1 = arg_27_0.view[iter_27_1]

		if var_27_1 then
			local var_27_2 = var_27_1[arg_27_1]

			if var_27_2 then
				if arg_27_2 == 1 then
					var_27_0[iter_27_1] = var_27_2(var_27_1)
				else
					var_27_0[iter_27_1] = {
						var_27_2(var_27_1)
					}
				end
			end
		end
	end

	arg_27_0.backups[arg_27_1] = var_27_0
end

function var_0_8._do(arg_28_0, arg_28_1, ...)
	for iter_28_0, iter_28_1 in ipairs(arg_28_0.__targes) do
		local var_28_0 = arg_28_0.view[iter_28_1]

		if var_28_0 then
			local var_28_1 = var_28_0[arg_28_1]

			if var_28_1 then
				var_28_1(var_28_0, ...)
			end
		end
	end
end

function var_0_8.setPosition(arg_29_0, arg_29_1, arg_29_2)
	arg_29_0:_backup("getPosition", 2)

	local var_29_0 = -(arg_29_1 - display.cx)
	local var_29_1 = -(arg_29_2 - display.cy)

	return arg_29_0:_do("setPosition", var_29_0 * arg_29_0.scaleX, var_29_1 * arg_29_0.scaleY)
end

function var_0_8.setRotation(arg_30_0, arg_30_1)
	arg_30_0:_backup("getRotation")

	return arg_30_0:_do("setRotation", arg_30_1)
end

function var_0_8.setScaleX(arg_31_0, arg_31_1)
	arg_31_0:_backup("getScaleX")

	arg_31_0.scaleX = 1 / arg_31_1

	return arg_31_0:_do("setScaleX", arg_31_0.scaleX)
end

function var_0_8.setScaleY(arg_32_0, arg_32_1)
	arg_32_0:_backup("getScaleY")

	arg_32_0.scaleY = 1 / arg_32_1

	return arg_32_0:_do("setScaleY", arg_32_0.scaleY)
end

local var_0_9 = class("Follow", battleEffect.EventEffect)

battleEffect.Follow = var_0_9

function var_0_9.onPlay(arg_33_0)
	local var_33_0 = arg_33_0.args.faceTo

	if arg_33_0.args.follow.scene then
		var_33_0 = 1
	end

	local var_33_1 = arg_33_0.args.follow.bones
	local var_33_2 = arg_33_0.args.processArgs.viewTargets
	local var_33_3 = arg_33_0.args.index
	local var_33_4 = math.random(1, table.length(var_33_1))

	if table.length(var_33_2) > 1 and table.length(var_33_1) > 1 then
		local var_33_5 = itertools.first(var_33_2, function(arg_34_0)
			return arg_34_0.id == arg_33_0.target.id
		end)

		if var_33_5 then
			var_33_4 = (var_33_5 - 1) % table.length(var_33_1) + 1
		end
	end

	arg_33_0.boneName = var_33_1[var_33_4]
	arg_33_0.boneSprite = arg_33_0.args.fromSprite

	if arg_33_0.boneSprite == nil then
		return
	end

	if arg_33_0.args.follow.scene then
		arg_33_0.target = var_0_8.new()
		arg_33_0.view = arg_33_0.target
	else
		arg_33_0.oldX, arg_33_0.oldY = arg_33_0.target:getPosition()
		arg_33_0.oldRotation = arg_33_0.target:getRotation()
		arg_33_0.oldScaleX = arg_33_0.target:getScaleX()
		arg_33_0.oldScaleY = arg_33_0.target:getScaleY()
	end

	local var_33_6 = arg_33_0.boneName
	local var_33_7 = arg_33_0.boneSprite.sprite

	arg_33_0.boneSprite:addActionCompleteListener(function(arg_35_0, arg_35_1)
		arg_33_0:stop()
	end)

	if arg_33_0.args.follow.scene and var_33_3 > 1 then
		return
	end

	local function var_33_8()
		local var_36_0, var_36_1 = arg_33_0.boneSprite:getPosition()
		local var_36_2 = var_33_7:getScaleX()
		local var_36_3 = var_33_7:getScaleY()
		local var_36_4 = var_33_7:getBonePosition(var_33_6)
		local var_36_5 = var_33_7:getBoneRotation(var_33_6)
		local var_36_6 = var_33_7:getBoneScaleX(var_33_6)
		local var_36_7 = var_33_7:getBoneScaleY(var_33_6)

		if var_36_6 > 1000 then
			var_36_6 = (var_36_6 - 1000) * -1
		end

		var_36_4.x = var_36_4.x * var_36_2 + var_36_0
		var_36_4.y = var_36_4.y * var_36_3 + var_36_1

		arg_33_0.target:setRotation(var_36_5 * var_33_0)
		arg_33_0.target:setScaleX(var_36_6 * var_33_0, true)
		arg_33_0.target:setScaleY(var_36_7, true)
		arg_33_0.target:setPosition(var_36_4.x, var_36_4.y)
	end

	arg_33_0.action = cc.RepeatForever:create(cc.Sequence:create(cc.CallFunc:create(var_33_8)))

	arg_33_0.target:runAction(arg_33_0.action)
end

function var_0_9.onUpdate(arg_37_0, arg_37_1)
	return
end

function var_0_9.onStop(arg_38_0)
	arg_38_0.target:stopAction(arg_38_0.action)

	local var_38_0 = arg_38_0.args.follow.notback

	if arg_38_0.args.follow.scene then
		arg_38_0.target:revert()
	elseif not var_38_0 then
		arg_38_0.target:setPosition(arg_38_0.oldX, arg_38_0.oldY)
		arg_38_0.target:setRotation(arg_38_0.oldRotation)
		arg_38_0.target:setScaleX(arg_38_0.oldScaleX)
		arg_38_0.target:setScaleY(arg_38_0.oldScaleY)
	else
		arg_38_0.target:isComeBacking(true)
	end
end

local var_0_10 = class("Control", battleEffect.OnceEventEffect)

battleEffect.Control = var_0_10

function var_0_10.onPlay(arg_39_0)
	local var_39_0 = gRootViewProxy:raw()
	local var_39_1 = arg_39_0.args.lifeBar

	if not var_39_0 then
		errorInWindows("Control:onPlay battleView is nil")

		return
	end

	local var_39_2 = var_39_0:onViewProxyCall("getSceneObjs")

	for iter_39_0, iter_39_1 in maptools.order_pairs(var_39_2) do
		if iter_39_1 and iter_39_1.model and not iter_39_1.model:isRealDeath() and var_39_1 then
			iter_39_1.lifebar:setVisible(var_39_1.show or false)
			iter_39_1:onAttacting(false)
		end
	end
end
