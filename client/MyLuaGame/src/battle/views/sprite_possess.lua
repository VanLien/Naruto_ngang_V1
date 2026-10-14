globals.BattlePossessSprite = class("BattlePossessSprite", BattleSprite)

function BattlePossessSprite.loadSprite(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	if arg_1_0.args.res then
		arg_1_0.sprite = newCSprite(arg_1_0.args.res)

		arg_1_0.sprite:setPosition(cc.p(0, 0))
		arg_1_0.sprite:setSpriteEventHandler(handler(arg_1_0, arg_1_0.onSpriteEvent))
		arg_1_0:add(arg_1_0.sprite, arg_1_2)
		arg_1_0:setScale(1)
	end
end

function BattlePossessSprite.init(arg_2_0)
	BattleSprite.init(arg_2_0)

	arg_2_0.holderView = gRootViewProxy:call("getSceneObj", arg_2_0.args.targetKey)

	arg_2_0.holderView:addFollowSpr(arg_2_0)

	arg_2_0.casterView = gRootViewProxy:call("getSceneObj", arg_2_0.args.casterKey)

	arg_2_0.casterView:addReplaceView(arg_2_0)

	arg_2_0.isDirty = false
	arg_2_0._holderPos = cc.p(arg_2_0.holderView:getPosition())
	arg_2_0._holderVis = arg_2_0.holderView:isVisible()
	arg_2_0._holderZOrder = arg_2_0.holderView:getLocalZOrder()

	arg_2_0:setActionState(battle.SpriteActionTable.standby)
end

function BattlePossessSprite.getHolderVisible(arg_3_0)
	return arg_3_0.holderView:isVisible() and arg_3_0.holderView:getSpriteVisible()
end

function BattlePossessSprite.onFixedUpdate(arg_4_0, arg_4_1)
	if arg_4_0.isDirty then
		return
	end

	if arg_4_0._holderVis ~= arg_4_0:getHolderVisible() then
		arg_4_0._holderVis = arg_4_0:getHolderVisible()

		arg_4_0:setVisible(arg_4_0._holderVis)
	end

	if arg_4_0._holderPos.x ~= arg_4_0.holderView:getPositionX() or arg_4_0._holderPos.y == arg_4_0.holderView:getPositionY() then
		arg_4_0._holderPos.x, arg_4_0._holderPos.y = arg_4_0.holderView:getPosition()

		local var_4_0 = arg_4_0:getPosAdjust()
		local var_4_1 = arg_4_0._holderPos.x + var_4_0.x
		local var_4_2 = arg_4_0._holderPos.y + var_4_0.y

		arg_4_0:setPosition(cc.p(var_4_1, var_4_2))
		arg_4_0:setCurPos(cc.p(arg_4_0._holderPos.x, arg_4_0._holderPos.y))
	end

	if arg_4_0._holderZOrder ~= arg_4_0.holderView:getLocalZOrder() then
		arg_4_0._holderZOrder = arg_4_0.holderView:getLocalZOrder()

		arg_4_0:setLocalZOrder(arg_4_0._holderZOrder + 1)
	end
end

function BattlePossessSprite.onAddToScene(arg_5_0)
	BattleSprite.onAddToScene(arg_5_0)
	arg_5_0:resetPosZ(arg_5_0._holderPos.y - 1)
	arg_5_0:setLocalZOrder(arg_5_0.posZ)
end

function BattlePossessSprite.popEffectInfo(arg_6_0, arg_6_1)
	return arg_6_0.casterView:popEffectInfo(arg_6_1)
end

function BattlePossessSprite.getProcessArgs(arg_7_0, arg_7_1)
	return arg_7_0.casterView:getProcessArgs(arg_7_1)
end

function BattlePossessSprite.popIgnoreEffect(arg_8_0, arg_8_1, arg_8_2)
	return arg_8_0.casterView:popIgnoreEffect(arg_8_1, arg_8_2)
end

function BattlePossessSprite.getSeat(arg_9_0)
	return arg_9_0.args.targetSeat
end

function BattlePossessSprite.initLifeBar(arg_10_0)
	return
end

function BattlePossessSprite.initNatureQuan(arg_11_0)
	return
end

function BattlePossessSprite.initGroundRing(arg_12_0)
	return
end

function BattlePossessSprite.updHitPanel(arg_13_0)
	return
end

function BattlePossessSprite.setDirty(arg_14_0, arg_14_1)
	arg_14_0.isDirty = arg_14_1
end

function BattlePossessSprite.showHero(arg_15_0, arg_15_1, arg_15_2)
	arg_15_0:setVisible(arg_15_1)
end

function BattlePossessSprite.checkSceneTag(arg_16_0, arg_16_1)
	if arg_16_1 then
		return arg_16_1.isPossessAttack
	end

	return false
end

function BattlePossessSprite.sceneDelObj(arg_17_0, arg_17_1)
	arg_17_0.holderView:removeFollowSpr(arg_17_0)
	arg_17_0.casterView:removeReplaceView(arg_17_0)
	arg_17_0:removeSelf()
end

function BattlePossessSprite.objToHideEff(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_1
	local var_18_1 = not arg_18_1
	local var_18_2 = arg_18_2.skillSceneTag:back()
	local var_18_3 = var_18_2 and var_18_2.isBigSkill

	if arg_18_0.casterView == arg_18_2 then
		arg_18_2:objToHideEff(arg_18_1)

		if var_18_3 then
			arg_18_0.casterView:setVisible(var_18_1)
		end

		var_18_1 = arg_18_1

		arg_18_0:setDirty(var_18_0)
		arg_18_0:setVisible(var_18_1)
	elseif var_18_3 then
		arg_18_0:setDirty(var_18_0)
		arg_18_0:setVisible(var_18_1)
	end
end
