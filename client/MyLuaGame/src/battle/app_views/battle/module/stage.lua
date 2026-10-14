local var_0_0 = class("Stage", battleModule.CBase)

function var_0_0.ctor(arg_1_0, arg_1_1)
	battleModule.CBase.ctor(arg_1_0, arg_1_1)

	arg_1_0.frontStageLayer = arg_1_0.parent.frontStageLayer
	arg_1_0.stageLayer = arg_1_0.parent.stageLayer
	arg_1_0.stage = nil
end

function var_0_0.setStage(arg_2_0, arg_2_1, arg_2_2)
	if arg_2_0.stage then
		arg_2_0.stage:removeFromParent()
	end

	local var_2_0 = newCSprite(arg_2_1)

	var_2_0:setAnchorPoint(cc.p(0, 0))
	var_2_0:setPosition(display.center)

	if arg_2_2 == 2 then
		arg_2_0.frontStageLayer:add(var_2_0)
	else
		arg_2_0.stageLayer:add(var_2_0)
	end

	arg_2_0.stage = var_2_0

	return var_2_0
end

function var_0_0.onAddGround(arg_3_0, arg_3_1)
	local var_3_0 = cc.p(arg_3_1.x, arg_3_1.y)

	for iter_3_0 = 1, arg_3_1.xtileSize do
		var_3_0.y = arg_3_1.y

		for iter_3_1 = 1, arg_3_1.ytileSize do
			local var_3_1 = arg_3_0:setStage(arg_3_1.config.res, arg_3_1.config.resType):scale(arg_3_1.config.scale)
			local var_3_2, var_3_3 = var_3_1:getPosition()

			var_3_1:setPosition(cc.pAdd(cc.p(var_3_2, var_3_3), var_3_0))

			if var_3_1:isSpine() then
				if arg_3_1.config.aniName then
					var_3_1:play(arg_3_1.config.aniName)
					var_3_1:addPlay("effect_loop")
				else
					var_3_1:play("effect_loop")
				end

				var_3_1:setAnimationSpeedScale(arg_3_1.config.frameScale, true)
			end

			var_3_1:setName(arg_3_1.id .. iter_3_0 * arg_3_1.ytileSize + iter_3_1)
		end

		var_3_0.x = var_3_0.x + arg_3_1.xlength
	end
end

function var_0_0.onMoveGround(arg_4_0, arg_4_1)
	local var_4_0 = cc.p(arg_4_1.x, arg_4_1.y)

	for iter_4_0 = 1, arg_4_1.xtileSize do
		var_4_0.y = arg_4_1.y

		for iter_4_1 = 1, arg_4_1.ytileSize do
			local var_4_1 = arg_4_1.id .. iter_4_0 * arg_4_1.ytileSize + iter_4_1
			local var_4_2

			if arg_4_1.config.resType == 2 then
				var_4_2 = arg_4_0.frontStageLayer:get(var_4_1)
			else
				var_4_2 = arg_4_0.stageLayer:get(var_4_1)
			end

			var_4_2:setPosition(var_4_0)

			var_4_0.y = var_4_0.y + arg_4_1.ylength
		end

		var_4_0.x = var_4_0.x + arg_4_1.xlength
	end
end

function var_0_0.onUltSkillPreAni1(arg_5_0)
	arg_5_0.parent.subModuleNotify:notify("showMain", false)
	arg_5_0.parent.subModuleNotify:notify("showSpec", false)
	arg_5_0.parent.subModuleNotify:notify("showLinkEffect", false)
end

function var_0_0.onSkillPreAni(arg_6_0, arg_6_1)
	(function()
		for iter_7_0, iter_7_1 in pairs(arg_6_1) do
			arg_6_0.parent:onEventEffect(iter_7_1, "show", {
				show = {
					{
						hide = true
					}
				}
			})
		end
	end)()
end

function var_0_0.onUltSkillPreAni2(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = newCSprite(battle.StageRes.kaiping)
	local var_8_1 = newCSprite(battle.StageRes.kaiping)
	local var_8_2 = newCSprite(arg_8_2.effectBigName[1])

	var_8_2:play("texie")

	local var_8_3 = newCSprite(arg_8_2.effectBigName[1])

	var_8_3:play("zi")

	local var_8_4
	local var_8_5
	local var_8_6
	local var_8_7 = arg_8_2.skillType == battle.SkillType.PassiveCombine

	if var_8_7 then
		var_8_5 = newCSprite(arg_8_2.effectBigName[2])
		var_8_6 = cc.Node:create()
	end

	local var_8_8 = cc.Node:create()
	local var_8_9 = cc.Node:create()
	local var_8_10 = arg_8_0.parent:onViewProxyCall("getSceneObj", arg_8_1).faceTo
	local var_8_11 = false

	local function var_8_12()
		if var_8_11 then
			return
		end

		var_8_11 = true

		for iter_9_0, iter_9_1 in pairs(arg_8_3) do
			arg_8_0.parent:onEventEffect(iter_9_1, "show", {
				show = {
					{
						hide = true
					}
				}
			})
		end
	end

	local var_8_13

	var_8_13 = var_8_7 and "htj_effect" or "effect"

	var_8_0:play("kaiping")
	var_8_0:setSpriteEventHandler(function(arg_10_0, arg_10_1)
		if arg_10_0 == sp.EventType.ANIMATION_COMPLETE then
			removeCSprite(var_8_0)
			removeCSprite(var_8_1)
			removeCSprite(var_8_2)
			removeCSprite(var_8_3)

			if var_8_7 then
				removeCSprite(var_8_5)
			end

			var_8_12()
			var_8_9:removeFromParent()
			arg_8_0:skillStageEffect(arg_8_1, arg_8_2)
		end
	end)
	var_8_0:scale(var_8_10 * 1.42, 1.2):setPositionY(-20)

	local var_8_14 = cc.Node:create()

	var_8_2:setPositionY(0)

	local var_8_15 = 1

	if arg_8_2.effectBigFlip then
		var_8_15 = -1
	end

	local var_8_16 = arg_8_2.effectBigPos

	if var_8_16.x ~= 0 then
		var_8_2:setPositionX(var_8_2:getPositionX() + var_8_16.x)
	end

	if var_8_16.y ~= 0 then
		var_8_2:setPositionY(var_8_2:getPositionY() + var_8_16.y)
	end

	local var_8_17 = 0.65

	var_8_2:scale(var_8_15 * 1.35 * var_8_17, 1.35 * var_8_17)
	var_8_3:scale(var_8_15 * 1.35 * var_8_17, 1.35 * var_8_17)
	var_8_14:add(var_8_2, 2):xy(0, 0)

	local var_8_18 = 0
	local var_8_19 = 0

	if var_8_10 < 0 then
		var_8_18 = 950
	end

	var_8_3:scale(var_8_10 * 1, 1):xy(var_8_18, var_8_19)
	var_8_14:add(var_8_3, 2):xy(0, 0)
	var_8_8:scale(var_8_10 * 1.2, 1.2)
	var_8_8:add(var_8_14)
	var_8_2:xy(0, 0)
	var_8_1:play("shang")
	var_8_1:setScaleX(var_8_10)

	local var_8_20 = 2

	if display.uiOrigin.y ~= 0 then
		local var_8_21 = display.sizeInPixels.height

		var_8_20 = var_8_20 * ((var_8_21 + display.uiOrigin.y) / var_8_21)
	end

	var_8_9:add(var_8_0, 1):add(var_8_8, 2):add(var_8_1, 3):scale(var_8_20):setPosition(display.center)
	var_8_9:x(var_8_9:x() - var_8_10 * display.uiOrigin.x)

	if var_8_7 then
		local var_8_22 = cc.Node:create()
		local var_8_23 = cc.Node:create()

		var_8_5:setPositionX(600)
		var_8_6:setPositionX(-510)
		var_8_5:setPositionY(0)
		var_8_6:setPositionY(0)

		if var_8_16.combX and var_8_16.combX ~= 0 then
			var_8_5:setPositionX(var_8_5:getPositionX() + var_8_16.combX)
			var_8_6:setPositionX(var_8_6:getPositionX() + var_8_16.combX)
		end

		if var_8_16.combY and var_8_16.combY ~= 0 then
			var_8_5:setPositionY(var_8_5:getPositionY() + var_8_16.combY)
			var_8_6:setPositionY(var_8_6:getPositionY() + var_8_16.combY)
		end

		var_8_5:scale(var_8_15 * 1.35, -1.35)
		var_8_6:scale(var_8_15 * 1.4, -1.4)
		var_8_6:setGLProgram("color"):setUniformVec3("color", cc.Vertex3F(0.93, 0.07, 0.41))
		var_8_23:add(var_8_6, 1):add(var_8_5, 2):xy(0, 0)
		var_8_22:scale(-1 * var_8_10 * 1.2, -1.2)
		var_8_22:add(var_8_23)
		var_8_9:add(var_8_22, 2)
	end

	arg_8_0.parent.layer:add(var_8_9)
end

function var_0_0.skillStageEffect(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0.parent:onViewProxyCall("getSceneObj", arg_11_1)

	if var_11_0 == nil then
		return
	end

	local var_11_1 = arg_11_2.blankTime
	local var_11_2 = arg_11_2.scaleArgs

	if arg_11_2.cameraNear == 1 or arg_11_2.cameraNear == 2 then
		var_11_1 = arg_11_2.cameraNear_blankTime
		var_11_2 = arg_11_2.cameraNear_scaleArgs
	end

	if not var_11_1 or var_11_1 <= 0 then
		return
	end

	if var_11_2.scale and var_11_2.scale ~= 1 then
		var_11_0:objToBlank(var_11_2)
	end

	local var_11_3 = arg_11_0.parent
	local var_11_4 = {
		aniName = "dazhao_bj",
		aniloop = false,
		delay = 0,
		offsetX = 0,
		zorder = 0,
		addTolayer = 0,
		offsetY = 0,
		screenPos = 0,
		scale = 2,
		lastTime = var_11_1
	}
	local var_11_5 = arg_11_0.parent:onEventEffect(nil, "effect", {
		effectType = 1,
		faceTo = 1,
		effectRes = battle.StageRes.daZhaoBJ,
		effectArgs = var_11_4,
		onComplete = function()
			return
		end
	})

	table.insert(arg_11_0.parent.effectJumpCache, var_11_5)
end

function var_0_0.onSkillStartStageMove(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_1 == 2 and 1.15 or 0.85

	transition.executeParallel(arg_13_0.stageLayer):scaleTo(0.8, var_13_0)
	transition.executeParallel(arg_13_0.parent.gameLayer):scaleTo(0.8, var_13_0)
	transition.executeParallel(arg_13_0.parent.effectLayer):scaleTo(0.8, var_13_0)
end

function var_0_0.onSkillEndStageMoveBack(arg_14_0)
	transition.executeParallel(arg_14_0.stageLayer):moveTo(0.3, 0, 0):scaleTo(0.3, 1)
	transition.executeParallel(arg_14_0.parent.gameLayer):moveTo(0.3, 0, display.fightLower):scaleTo(0.3, 1)
	transition.executeParallel(arg_14_0.parent.effectLayer):moveTo(0.3, 0, display.fightLower):scaleTo(0.3, 1)
end

function var_0_0.onAlterBattleScene(arg_15_0, arg_15_1)
	if not arg_15_0.bgSprGroup then
		arg_15_0.bgSprGroup = {}
	end

	if arg_15_0.bgSprGroup[arg_15_1.buffId] then
		arg_15_0.bgSprGroup[arg_15_1.buffId]:removeSelf()

		arg_15_0.bgSprGroup[arg_15_1.buffId] = nil
	end

	if not arg_15_1.restore then
		for iter_15_0, iter_15_1 in pairs(arg_15_0.bgSprGroup) do
			iter_15_1:hide()
		end

		if arg_15_1.aniName then
			local var_15_0 = newCSprite(arg_15_1.resPath)

			arg_15_0.parent.stageLayer:add(var_15_0, 9999)
			var_15_0:setPosition(display.center)

			local var_15_1, var_15_2 = var_15_0:getPosition()

			var_15_0:setPosition(var_15_1 + arg_15_1.x, var_15_2 + arg_15_1.y):scale(2)
			var_15_0:play(arg_15_1.aniName .. "_loop")

			arg_15_0.bgSprGroup[arg_15_1.buffId] = var_15_0
		else
			local var_15_3 = cc.Sprite:create(arg_15_1.resPath)

			var_15_3:xy(display.center):scale(2)
			arg_15_0.parent.stageLayer:add(var_15_3, 9999)

			arg_15_0.bgSprGroup[arg_15_1.buffId] = var_15_3
		end
	else
		local var_15_4 = -1

		for iter_15_2, iter_15_3 in pairs(arg_15_0.bgSprGroup) do
			if var_15_4 < iter_15_2 then
				var_15_4 = iter_15_2
			end
		end

		if var_15_4 ~= -1 then
			arg_15_0.bgSprGroup[var_15_4]:show()
		end
	end
end

return var_0_0
