local var_0_0 = math.min
local var_0_1 = math.max
local var_0_2 = class("SegShow", battleEffect.EventEffect)

battleEffect.SegShow = var_0_2

function var_0_2.onPlay(arg_1_0)
	arg_1_0.idx = 1
	arg_1_0.model = arg_1_0.view.model
	arg_1_0.viewKey = arg_1_0.view.key
	arg_1_0.segs = arg_1_0.args.damageSeg or arg_1_0.args.hpSeg
	arg_1_0.intervals = arg_1_0.args.segInterval
	arg_1_0.waitTick = arg_1_0.intervals[1]

	if not arg_1_0.args.processArgs or not arg_1_0.args.processArgs.values[arg_1_0.model.id] then
		local var_1_0 = arg_1_0.args.processArgs and arg_1_0.args.processArgs.process and arg_1_0.args.processArgs.process.id or -1
		local var_1_1 = arg_1_0.model and arg_1_0.model.unitID or -1

		errorInWindows("SegShow Args valueArgs nil,unitId = %s,processCfg id = %s", var_1_1, var_1_0)

		return arg_1_0:free()
	end

	arg_1_0.valueArgs = arg_1_0.args.processArgs.values[arg_1_0.model.id]

	if arg_1_0.args.processArgs.buffTb then
		arg_1_0.buffArgs = arg_1_0.args.processArgs.buffTb[arg_1_0.model.id]
	end

	arg_1_0.type = arg_1_0.args.processArgs.process.segType
	arg_1_0.numShow = arg_1_0.type == arg_1_0.args.processArgs.showType

	if arg_1_0.type == battle.SkillSegType.damage then
		arg_1_0.view:beHit(0, 0, arg_1_0.args.exhit)
	end
end

function var_0_2.onUpdate(arg_2_0, arg_2_1)
	local var_2_0 = gRootViewProxy:raw()

	if not gRootViewProxy:call("isObjExisted", arg_2_0.viewKey) then
		return arg_2_0:free()
	end

	local var_2_1 = table.length(arg_2_0.segs)

	if arg_2_0.type == battle.SkillSegType.damage then
		arg_2_0.view:beHit(arg_2_1, nil, arg_2_0.args.exhit)
	end

	if arg_2_0.tick >= arg_2_0.waitTick and var_2_0 then
		local var_2_2 = arg_2_0.valueArgs[arg_2_0.idx] or {}

		if not assertInWindows(var_2_2, "effect_event seg is missed!!") then
			local var_2_3 = var_2_2.value and var_2_2.value:get() or 0

			if arg_2_0.idx == 1 and arg_2_0.buffArgs then
				var_2_0:runDefer(arg_2_0.buffArgs)
			end

			if var_2_3 > 0 then
				var_2_0:runDefer(var_2_2 and var_2_2.deferList)
			end

			if arg_2_0.numShow and var_2_3 > 0 then
				gRootViewProxy:notify("showNumber", {
					delta = var_2_3,
					skillId = arg_2_0.args.processArgs.skillId,
					typ = arg_2_0.type
				})
			end

			if arg_2_0.type == battle.SkillSegType.damage then
				arg_2_0.view:beHit(0, 600, arg_2_0.args.exhit)
			end
		end

		arg_2_0.idx = arg_2_0.idx + 1

		if var_2_1 < arg_2_0.idx or not arg_2_0.valueArgs[arg_2_0.idx] then
			if arg_2_0.type == battle.SkillSegType.damage then
				battleEasy.effect(arg_2_0.view.model, function()
					if not gRootViewProxy:call("isObjExisted", arg_2_0.viewKey) then
						return
					end

					if string.find(arg_2_0.view.actionState, "hit") ~= nil then
						arg_2_0.view:setActionState(battle.SpriteActionTable.standby)
					end
				end, {
					delay = arg_2_0.view:getLeftBeHitTime()
				})
			end

			return arg_2_0:stop()
		end

		arg_2_0.waitTick = arg_2_0.waitTick + arg_2_0.intervals[arg_2_0.idx] or 0
	end
end

function var_0_2.onFree(arg_4_0)
	return
end

function var_0_2.onStop(arg_5_0)
	return
end

local var_0_3 = class("Sound", battleEffect.EventEffect)

battleEffect.Sound = var_0_3

function var_0_3.onPlay(arg_6_0)
	local var_6_0 = arg_6_0.args.music and arg_6_0.args.music or arg_6_0.args.sound
	local var_6_1 = var_6_0.loop > 0
	local var_6_2 = gRootViewProxy:raw()

	if var_6_0.bgmChanged then
		audio.pauseMusic()

		var_6_2.bgmChanged = true
	end

	arg_6_0.handle = audio.playEffectWithWeekBGM(var_6_0.res, var_6_1)

	if not var_6_1 then
		arg_6_0:free()
	end
end

function var_0_3.onStop(arg_7_0)
	if arg_7_0.handle then
		audio.stopSound(arg_7_0.handle)

		arg_7_0.handle = nil
	end
end

function var_0_3.debugString(arg_8_0)
	local var_8_0 = arg_8_0.args.music and arg_8_0.args.music or arg_8_0.args.sound

	return string.format("Sound: %s", var_8_0.res)
end

local var_0_4 = class("Music", battleEffect.OnceEventEffect)

battleEffect.Music = var_0_4

local var_0_5 = {
	play = audio.playMusic,
	stop = audio.stopMusic,
	pause = audio.pauseMusic,
	resume = audio.resumeMusic
}

function var_0_4.onPlay(arg_9_0)
	local var_9_0 = arg_9_0.args.music
	local var_9_1 = gRootViewProxy:raw()

	if var_9_0.res then
		var_0_5[var_9_0.op](var_9_0.res, var_9_0.isLoop or false)
	else
		var_0_5[var_9_0.op]()
	end

	if var_9_0.bgmChanged then
		var_9_1.bgmChanged = true
	end
end

function var_0_4.debugString(arg_10_0)
	local var_10_0 = arg_10_0.args.music

	return string.format("Music: %s", var_10_0.res)
end

local var_0_6 = class("ShowCards", battleEffect.EventEffect)

battleEffect.ShowCards = var_0_6

function var_0_6.onPlay(arg_11_0)
	if arg_11_0.args.showCards == 1 then
		for iter_11_0 = 1, SELF_HERO_COUNT do
			if arg_11_0.showCardIDs[iter_11_0] then
				local var_11_0 = arg_11_0.showCardIDs[iter_11_0]

				if var_11_0 then
					gRootViewProxy:notify("processSkillTargetHide", tostring(var_11_0), false)
				end
			end
		end
	elseif arg_11_0.args.showCards == 2 then
		for iter_11_1 = 1, SELF_HERO_COUNT do
			local var_11_1 = arg_11_0.showCardIDs[iter_11_1]
			local var_11_2 = var_11_1 and not var_11_1:isDeath() and var_11_1.id ~= arg_11_0.owner.id

			if var_11_2 then
				for iter_11_2, iter_11_3 in pairs(arg_11_0.sputteringTargets) do
					if var_11_1.id == iter_11_3.id then
						var_11_2 = false
					end
				end
			end

			if var_11_2 then
				gRootViewProxy:notify("processSkillTargetHide", tostring(var_11_1), true)
			else
				gRootViewProxy:notify("processSkillTargetHide", tostring(var_11_1), false)
			end
		end
	end
end

function var_0_6.onStop(arg_12_0)
	return
end

local var_0_7 = class("Shaker", battleEffect.EventEffect)

battleEffect.Shaker = var_0_7

function var_0_7.onPlay(arg_13_0)
	arg_13_0.view = gRootViewProxy:raw()
	arg_13_0.target = arg_13_0.view

	local var_13_0 = arg_13_0.args.shaker

	arg_13_0:resetShaker()

	arg_13_0.disx = var_13_0.disx or 0
	arg_13_0.disy = var_13_0.disy or 0
	arg_13_0.isRepeat = var_13_0.isRepeat

	if arg_13_0.isRepeat and arg_13_0.args.segInterval then
		arg_13_0.timeList = arg_13_0.args.segInterval
		arg_13_0.timer = 0
		arg_13_0.seg = 1
	end

	if arg_13_0:shakerCountOver() then
		arg_13_0:stop()
	end
end

function var_0_7.onStop(arg_14_0)
	arg_14_0.target:setPosition(0, 0)
end

function var_0_7.resetShaker(arg_15_0)
	local var_15_0 = arg_15_0.args.shaker

	arg_15_0.lastTime = var_15_0.lastTime or var_15_0.endT - var_15_0.beginT
	arg_15_0.count = var_15_0.count or 1
	arg_15_0.dur = 0
	arg_15_0.wait = var_15_0.beginT or 0
	arg_15_0.interval = var_15_0.interval or 0
end

function var_0_7.waiting(arg_16_0)
	return arg_16_0.wait >= 0
end

function var_0_7.shakerIng(arg_17_0)
	return arg_17_0.dur > 0
end

function var_0_7.shakerCountOver(arg_18_0)
	return arg_18_0.count <= 0
end

function var_0_7.needRepeat(arg_19_0)
	if not arg_19_0.timeList or not arg_19_0.seg then
		return false
	end

	return arg_19_0.timeList[arg_19_0.seg + 1]
end

function var_0_7.repeatWaiting(arg_20_0)
	return arg_20_0.timeList[arg_20_0.seg + 1] > arg_20_0.timer
end

function var_0_7.onUpdate(arg_21_0, arg_21_1)
	if arg_21_0.timer then
		arg_21_0.timer = arg_21_0.timer + arg_21_1
	end

	if arg_21_0:shakerIng() then
		arg_21_0.dur = arg_21_0.dur - arg_21_1

		if arg_21_0.dur > 0 then
			local var_21_0 = math.random(-arg_21_0.disx, arg_21_0.disx)
			local var_21_1 = math.random(-arg_21_0.disy, arg_21_0.disy)

			arg_21_0.target:setPosition(var_21_0, var_21_1)
		else
			arg_21_0.target:setPosition(0, 0)
		end
	elseif arg_21_0:shakerCountOver() then
		if arg_21_0:needRepeat() then
			if not arg_21_0:repeatWaiting() then
				arg_21_0.seg = arg_21_0.seg + 1
				arg_21_0.timer = 0

				arg_21_0.target:setPosition(0, 0)
				arg_21_0:resetShaker()
			end
		else
			return arg_21_0:stop()
		end
	elseif arg_21_0:waiting() then
		arg_21_0.wait = arg_21_0.wait - arg_21_1

		if arg_21_0.wait < 0 then
			if arg_21_0.count > 0 then
				arg_21_0.dur = arg_21_0.lastTime
				arg_21_0.wait = arg_21_0.interval
			end

			arg_21_0.count = arg_21_0.count - 1
		end
	else
		return arg_21_0:stop()
	end
end

function var_0_7.onStop(arg_22_0)
	arg_22_0.target:setPosition(0, 0)
end

function var_0_7.debugString(arg_23_0)
	local var_23_0 = arg_23_0.dur or 0
	local var_23_1 = ""

	if arg_23_0.seg then
		var_23_1 = string.format("%s/%s", arg_23_0.seg, table.length(arg_23_0.timeList))
	end

	return string.format("Shaker: %5.2f %s", var_23_0, var_23_1)
end

local var_0_8 = class("Move", battleEffect.OnceEventEffect)

battleEffect.Move = var_0_8

function var_0_8.onPlay(arg_24_0)
	log.battle.event_effect.move("受击目标表现！！！")

	arg_24_0.targets = arg_24_0.args.targets or {}

	local var_24_0 = 1

	if arg_24_0.args.faceTo then
		var_24_0 = arg_24_0.args.faceTo == 1 and 1 or -1
	end

	local var_24_1 = arg_24_0:adaptArgs(var_24_0)
	local var_24_2 = 0
	local var_24_3 = 0

	for iter_24_0, iter_24_1 in ipairs(var_24_1) do
		if iter_24_1.t == nil then
			break
		end

		local var_24_4 = iter_24_1.t / 1000
		local var_24_5 = var_0_1(var_24_4, 0.01)
		local var_24_6 = 0
		local var_24_7 = 0

		local function var_24_8()
			local var_25_0 = transition.executeSpawn(arg_24_0.target)

			var_25_0:delay(var_24_5)

			if iter_24_1.rot then
				var_25_0:rotateTo(var_24_5, iter_24_1.rot * var_24_0)
			end

			if iter_24_1.scale then
				var_25_0:scaleTo(var_24_5, iter_24_1.scale)
			end

			if iter_24_1.x or iter_24_1.y then
				iter_24_1.x = iter_24_1.x and iter_24_1.x * var_24_0 or var_24_2
				iter_24_1.y = iter_24_1.y or var_24_3
				var_24_6, var_24_7 = iter_24_1.x - var_24_2, iter_24_1.y - var_24_3
				var_24_2, var_24_3 = iter_24_1.x, iter_24_1.y

				var_25_0:moveBy(var_24_5, var_24_6, var_24_7)
			end

			var_25_0:done()
		end

		local function var_24_9()
			local var_26_0, var_26_1 = arg_24_0.target:getCurPos()

			log.battle.event_effect.move("seat= , before:", arg_24_0.target.seat, var_26_0, var_26_1)

			local var_26_2, var_26_3 = var_26_0 + var_24_6, var_26_1 + var_24_7

			arg_24_0.target:setCurPos(cc.p(var_26_2, var_26_3))
			log.battle.event_effect.move("seat= , after:", arg_24_0.target.seat, var_26_2, var_26_3)
		end

		local var_24_10 = transition.executeSequence(arg_24_0.target)

		if iter_24_1.delay then
			var_24_10:delay(iter_24_1.delay / 1000)
		end

		var_24_10:func(var_24_8):func(var_24_9):done()
	end
end

local function var_0_9(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	arg_27_3 = 1 - arg_27_3

	local var_27_0 = -math.huge
	local var_27_1 = -math.huge
	local var_27_2 = math.huge
	local var_27_3 = math.huge

	for iter_27_0, iter_27_1 in pairs(arg_27_1) do
		var_27_0 = var_0_1(var_27_0, iter_27_1.x)
		var_27_2 = var_0_0(var_27_2, iter_27_1.x)
		var_27_1 = var_0_1(var_27_1, iter_27_1.y)
		var_27_3 = var_0_0(var_27_3, iter_27_1.y)
	end

	local var_27_4 = cc.p((var_27_0 + var_27_2) / 2, (var_27_1 + var_27_3) / 2)
	local var_27_5 = var_27_4.x - arg_27_2.x
	local var_27_6 = var_27_4.y - arg_27_2.y

	return var_27_5 * arg_27_3, var_27_6 * arg_27_3
end

function var_0_8.adaptArgs(arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0.target

	if not var_28_0 then
		return
	end

	arg_28_1 = arg_28_1 or 1

	local var_28_1, var_28_2 = var_28_0:getPosition()
	local var_28_3 = var_28_0:getParent():convertToWorldSpace(cc.p(var_28_1, var_28_2))
	local var_28_4 = gGameUI.uiRoot:convertToNodeSpace(var_28_3)
	local var_28_5 = var_28_4.x
	local var_28_6 = var_28_4.y
	local var_28_7 = clone(arg_28_0.args.move)

	for iter_28_0, iter_28_1 in ipairs(var_28_7) do
		if iter_28_1.absX or iter_28_1.absY then
			iter_28_1.absX = iter_28_1.absX and (arg_28_1 == 1 and iter_28_1.absX or display.width - iter_28_1.absX)

			local var_28_8 = iter_28_1.absX and arg_28_1 * (iter_28_1.absX - var_28_5)
			local var_28_9 = iter_28_1.absY and iter_28_1.absY - var_28_6

			if var_28_8 then
				iter_28_1.x = iter_28_1.x and iter_28_1.x + var_28_8 or var_28_8
			end

			if var_28_9 then
				iter_28_1.y = iter_28_1.y and iter_28_1.y + var_28_9 or var_28_9
			end
		end

		if iter_28_1.teamClose then
			iter_28_1.delay = iter_28_1.delay and iter_28_1.delay + 20

			if not arg_28_0.objPosTb then
				local var_28_10 = {}
				local var_28_11

				for iter_28_2, iter_28_3 in pairs(arg_28_0.targets) do
					if iter_28_3 then
						local var_28_12, var_28_13 = iter_28_3:getCurPos()

						var_28_12 = arg_28_1 == 1 and var_28_12 or display.width - var_28_12
						var_28_10[iter_28_3.id] = cc.p(var_28_12, var_28_13)

						if iter_28_3.id == var_28_0.id then
							var_28_11 = cc.p(var_28_12, var_28_13)
						end
					end
				end

				arg_28_0.objPosTb = var_28_10
				arg_28_0.selfPos = var_28_11
			end

			local var_28_14, var_28_15 = var_0_9(arg_28_0.targets, arg_28_0.objPosTb, arg_28_0.selfPos, iter_28_1.teamClose)

			iter_28_1.x = iter_28_1.x and iter_28_1.x + var_28_14 or var_28_14
			iter_28_1.y = iter_28_1.y and iter_28_1.y + var_28_15 or var_28_15
		end
	end

	return var_28_7
end

local var_0_10 = class("Show", battleEffect.OnceEventEffect)

battleEffect.Show = var_0_10

function var_0_10.onPlay(arg_29_0)
	local var_29_0 = arg_29_0.args.show

	for iter_29_0, iter_29_1 in ipairs(var_29_0) do
		if iter_29_1.hide == nil then
			break
		end

		local var_29_1 = transition.executeSequence(arg_29_0.view)

		if iter_29_1.delay then
			var_29_1:delay(iter_29_1.delay / 1000)
		end

		local function var_29_2()
			arg_29_0.view:setVisible(not iter_29_1.hide)
		end

		local function var_29_3()
			arg_29_0.view:setVisible(iter_29_1.hide)
		end

		var_29_1:func(var_29_2)

		if iter_29_1.lastTime then
			var_29_1:delay(iter_29_1.lastTime / 1000)
			var_29_1:func(var_29_3)
		end

		var_29_1:done()
	end
end

local var_0_11 = class("Delay", battleEffect.EventEffect)

battleEffect.Delay = var_0_11

function var_0_11.onUpdate(arg_32_0, arg_32_1)
	return
end

function var_0_11.debugString(arg_33_0)
	return string.format("Delay: %5.2f", arg_33_0.lifetime - (arg_33_0.tick or 0))
end

local var_0_12 = class("SpriteEffect", battleEffect.EventEffect)

battleEffect.SpriteEffect = var_0_12

function var_0_12.onPlay(arg_34_0)
	local var_34_0 = arg_34_0.args.effectType or 0
	local var_34_1 = arg_34_0.args.effectRes or arg_34_0.args.action
	local var_34_2 = arg_34_0.args.effectArgs or {}
	local var_34_3 = gRootViewProxy:raw()

	arg_34_0.onComplete = arg_34_0.args.onComplete

	if arg_34_0.onComplete then
		local var_34_4 = arg_34_0.onComplete

		function arg_34_0.onComplete()
			if arg_34_0.onComplete then
				arg_34_0.onComplete = nil

				var_34_4()
				arg_34_0:stop()
			end
		end
	end

	local function var_34_5()
		if var_34_0 == 0 then
			arg_34_0.view:setActionState(var_34_1, arg_34_0.onComplete)
		elseif var_34_0 == 1 then
			local var_36_0 = arg_34_0.args.faceTo
			local var_36_1 = 3
			local var_36_2 = cc.p(0, 0)

			if var_34_2.offsetX and var_34_2.offsetY then
				var_36_2 = cc.p(var_36_0 * var_34_2.offsetX, var_34_2.offsetY)
			end

			arg_34_0.sprite = newCSpriteWithOption(var_34_1)

			assert(arg_34_0.sprite, "ERROR!!! effectArgs add res error, not find the res:", var_34_1)
			arg_34_0.sprite:setAnchorPoint(cc.p(0.5, 0.5))

			var_34_2.scale = var_34_2.scale or 1

			arg_34_0.sprite:setScaleX(var_36_0 * var_36_1 * var_34_2.scale)
			arg_34_0.sprite:setScaleY(var_36_1 * var_34_2.scale)

			if var_34_2.screenPos then
				if var_34_2.screenPos == 0 then
					var_36_2 = cc.pAdd(var_36_2, display.center)
				elseif var_34_2.screenPos == 1 then
					local var_36_3, var_36_4 = arg_34_0.target:getCurPos()
					local var_36_5 = cc.p(var_36_3, var_36_4)

					var_36_2 = cc.pAdd(var_36_2, var_36_5)
				end

				arg_34_0.sprite:setPosition(var_36_2)

				if var_34_2.addTolayer == 1 then
					var_34_3.effectLayerUpper:add(arg_34_0.sprite, var_34_2.zorder or 0)
				elseif var_34_2.addTolayer == 0 then
					var_34_3.stageLayer:add(arg_34_0.sprite, var_34_2.zorder or 0)
				else
					var_34_3.effectLayerLower:add(arg_34_0.sprite, var_34_2.zorder or 0)
				end
			else
				arg_34_0.sprite:setPosition(var_36_2)
				arg_34_0.view:add(arg_34_0.sprite, var_34_2.zorder or 0)
			end

			if arg_34_0.sprite:isSpine() then
				if var_34_2.aniName then
					arg_34_0.sprite:play(var_34_2.aniName)
				else
					var_34_2.aniLoop = arg_34_0.sprite:play("effect_loop")

					if not var_34_2.aniLoop then
						arg_34_0.sprite:play("effect")
					end
				end
			end

			local function var_36_6()
				arg_34_0:stop()
			end

			if var_34_2.aniLoop then
				if var_34_2.flytime and var_34_2.flyX and var_34_2.flyY then
					transition.executeSequence(arg_34_0.sprite):moveBy(var_34_2.flytime / 1000, var_34_2.flyX * var_36_0, var_34_2.flyY):func(var_36_6):done()
				else
					transition.executeSequence(arg_34_0.sprite):delay(var_34_2.lastTime and var_34_2.lastTime / 1000 or 1):func(var_36_6):done()
				end
			elseif var_34_2.lastTime then
				transition.executeSequence(arg_34_0.sprite):delay(var_34_2.lastTime / 1000):func(var_36_6):done()
			else
				arg_34_0.sprite:setSpriteEventHandler(function(arg_38_0, arg_38_1)
					if arg_38_0 == sp.EventType.ANIMATION_COMPLETE then
						removeCSprite(arg_34_0.sprite)
					end
				end)
			end
		end
	end

	local var_34_6 = transition.executeSequence(arg_34_0.view)

	if var_34_2.delay then
		var_34_6:delay(var_34_2.delay / 1000)
	end

	var_34_6:func(var_34_5):done()

	if not arg_34_0.onComplete then
		arg_34_0:stop()
	end
end

function var_0_12.onUpdate(arg_39_0, arg_39_1)
	return
end

function var_0_12.onStop(arg_40_0)
	if arg_40_0.onComplete then
		if arg_40_0.view.actionCompleteCallback == arg_40_0.onComplete then
			arg_40_0.view.actionCompleteCallback = nil
		end

		arg_40_0.onComplete()
	end
end

function var_0_12.stop(arg_41_0)
	if arg_41_0.sprite then
		arg_41_0.sprite:stopAllActions()
		removeCSprite(arg_41_0.sprite)

		arg_41_0.sprite = nil
	end

	battleEffect.EventEffect.stop(arg_41_0)
end

function var_0_12.debugString(arg_42_0)
	local var_42_0 = arg_42_0.args.effectArgs or {}
	local var_42_1 = arg_42_0.args.effectRes or arg_42_0.args.action

	if var_42_0.aniName then
		var_42_1 = string.format("%s#%s", var_42_1, var_42_0.aniName)
	end

	local var_42_2 = toDebugString(arg_42_0.view)

	return string.format("SpriteEffect: %s -> %s", var_42_1, var_42_2)
end

local var_0_13 = class("ZOrder", battleEffect.OnceEventEffect)

battleEffect.ZOrder = var_0_13

function var_0_13.onPlay(arg_43_0)
	local var_43_0 = arg_43_0.args.zOrder

	for iter_43_0, iter_43_1 in ipairs(var_43_0) do
		local var_43_1 = iter_43_1.zorder

		if not var_43_1 then
			break
		end

		local var_43_2 = transition.executeSequence(arg_43_0.view)

		if iter_43_1.delay then
			var_43_2:delay(iter_43_1.delay / 1000)
		end

		local var_43_3 = arg_43_0.view:getLocalZOrder()

		local function var_43_4()
			var_43_3 = arg_43_0.view:getLocalZOrder()

			arg_43_0.view:setLocalZOrder(var_43_3 + var_43_1)
		end

		local function var_43_5()
			arg_43_0.view:setLocalZOrder(var_43_3)
		end

		var_43_2:func(var_43_4)

		if iter_43_1.lastTime then
			var_43_2:delay(iter_43_1.lastTime / 1000)
			var_43_2:func(var_43_5)
		end

		var_43_2:done()
	end
end
