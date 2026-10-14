require("easy.sprite")
require("battle.views.lifebar")

globals.BattleSprite = class("BattleSprite", cc.Node)

function globals.newCSpriteWithOption(arg_1_0, ...)
	local var_1_0 = newCSprite(arg_1_0, ...)
	local var_1_1 = gEffectOptionCsv[arg_1_0]

	if var_1_0:isSpine() and var_1_1 then
		var_1_0:getAni():setTwoColorTint(var_1_1.tintBlack)
	end

	return var_1_0
end

function BattleSprite.ctor(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	arg_2_0.battleView = arg_2_1
	arg_2_0.model = arg_2_2
	arg_2_0.key = arg_2_3
	arg_2_0.args = arg_2_4
	arg_2_0.type = arg_2_4.type
	arg_2_0.spineEventMap = {}
	arg_2_0.debug = {
		enabled = false
	}
	arg_2_0.effectDebug = {
		enabled = false
	}
	arg_2_0.relationshipStatus = "showRelationship"
	arg_2_0.actionTable = {}
	arg_2_0.skillSceneTag = CVector.new()
	arg_2_0.followSprite = {}
	arg_2_0.replaceView = nil
	arg_2_0.canSetVisible = true
	arg_2_0.refreshBuffIconOnce = false
	arg_2_0.skillJumpSwitchOnce = false
	arg_2_0.recordOrderDataTb = {}
	arg_2_0.lockEffectSwitch = true
	arg_2_0.skins = CVector.new()

	arg_2_0:resetActionTab()
end

function BattleSprite.init(arg_3_0)
	arg_3_0:initUnitData()

	arg_3_0.monsterCfg = arg_3_0.model.monsterCfg
	arg_3_0.force = battleEasy.getForce(arg_3_0.seat)
	arg_3_0.forceFaceTo = arg_3_0.force == 1 and 1 or -1
	arg_3_0.faceTo = arg_3_0.forceFaceTo
	arg_3_0.posAdjust = arg_3_0:getPosAdjust()
	arg_3_0.actionState = "run"
	arg_3_0.beHitTime = 200

	if arg_3_0.monsterCfg and arg_3_0.monsterCfg.posAdjust and arg_3_0.monsterCfg.posAdjust[arg_3_0.seat - 6] ~= 0 then
		arg_3_0.posAdjust.x = arg_3_0.monsterCfg.posAdjust[arg_3_0.seat - 6].x
		arg_3_0.posAdjust.y = arg_3_0.monsterCfg.posAdjust[arg_3_0.seat - 6].y
	end

	local var_3_0, var_3_1 = arg_3_0:getSelfPos()

	arg_3_0.posXY = cc.p(var_3_0, var_3_1)
	arg_3_0.posZ = var_3_1
	arg_3_0._scale = nil
	arg_3_0._scaleX = nil
	arg_3_0._scaleY = nil
	arg_3_0.battleMovePosZ = 0
	arg_3_0.effectManager = battleEffect.Manager.new("BattleSprite." .. arg_3_0.model.id)
	arg_3_0.effectProcessArgs = {}

	arg_3_0:loadSprite(arg_3_0.unitCfg.unitRes, battle.SpriteLayerZOrder.selfSpr)

	arg_3_0.spineActionScales = {}
	arg_3_0.spinePrevAction = nil

	if arg_3_0.unitCfg.scaleCMode == 2 then
		for iter_3_0, iter_3_1 in csvPairs(arg_3_0.unitCfg.skillList) do
			local var_3_2 = csv.skill[iter_3_1]

			if var_3_2 and var_3_2.spineAction then
				arg_3_0.spineActionScales[var_3_2.spineAction] = arg_3_0.unitCfg.scale
			end
		end
	end

	arg_3_0:initLifeBar()
	arg_3_0:initNatureQuan()
	arg_3_0:initGroundRing()
	arg_3_0:setPosition(arg_3_0.posXY)

	arg_3_0.buffEffectMap = CMap.new()
	arg_3_0.buffEffectSpriteMap = CMap.new()
	arg_3_0.buffEffectsMap = {}
	arg_3_0.buffEffectsRef = {}
	arg_3_0.buffEffectHolderMap = {}
	arg_3_0.buffEffectsFollowObjToScale = {}
	arg_3_0.specBindEffectCache = {}
	arg_3_0.effectJumpCache = {}
	arg_3_0.startYinyingPos = arg_3_0.sprite:getBonePosition("yinying")

	arg_3_0:updHitPanel()
end

function BattleSprite.initLifeBar(arg_4_0)
	arg_4_0.lifebar = CLifeBar.new(arg_4_0.model, arg_4_0.battleView)

	arg_4_0:add(arg_4_0.lifebar, battle.SpriteLayerZOrder.lifebar, "lifebar")
end

function BattleSprite.initNatureQuan(arg_5_0)
	arg_5_0.natureQuan = cc.Node:create()

	arg_5_0.natureQuan:hide():anchorPoint(0.5, 1):xy(arg_5_0.unitCfg.everyPos.hitPos)
	arg_5_0:add(arg_5_0.natureQuan, battle.SpriteLayerZOrder.quan, "nature_quan")

	local var_5_0 = arg_5_0.natureQuan:getContentSize()
	local var_5_1 = ccui.ImageView:create(battle.SpriteRes.natureQuanTxtDi)

	var_5_1:addTo(arg_5_0.natureQuan, -5):xy(var_5_0.width / 2, var_5_0.height / 2)

	arg_5_0.natureQuan.textDi = var_5_1

	newCSprite(battle.SpriteRes.natureQuan):addTo(arg_5_0.natureQuan, 1):xy(var_5_0.width / 2, var_5_0.height / 2):play("xuanzhong_loop")
end

function BattleSprite.initGroundRing(arg_6_0)
	arg_6_0.groundRing = newCSprite(battle.SpriteRes.groundRing)

	arg_6_0.groundRing:addTo(arg_6_0, battle.SpriteLayerZOrder.ground):hide():play("effect_loop")
end

function BattleSprite.initUnitData(arg_7_0)
	arg_7_0.id = arg_7_0.model.id
	arg_7_0.seat = arg_7_0.model.seat
	arg_7_0.unitID = arg_7_0.model.unitID
	arg_7_0.unitCfg = csv.unit[arg_7_0.unitID]
	arg_7_0.unitSpecBind = arg_7_0.unitCfg.specBind
	arg_7_0.unitRes = arg_7_0.model.unitRes or arg_7_0.unitCfg.unitRes
	arg_7_0.cardID = arg_7_0.model.cardID
	arg_7_0.cardCfg = csv.cards[arg_7_0.unitCfg.cardID]
end

function BattleSprite.getSeat(arg_8_0)
	return arg_8_0.seat
end

function BattleSprite.loadSprite(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if arg_9_1 then
		arg_9_0.sprite = newCSprite(arg_9_1)

		arg_9_0.sprite:setPosition(cc.p(0, 0))
		arg_9_0.sprite:setSpriteEventHandler(handler(arg_9_0, arg_9_0.onSpriteEvent))
		arg_9_0:add(arg_9_0.sprite, arg_9_2)
		arg_9_0:setScale(1)
		arg_9_0:setSkin(arg_9_3)
	end
end

function BattleSprite.reloadUnit(arg_10_0, arg_10_1)
	local var_10_0 = cc.p(arg_10_0.sprite:getPositionX(), arg_10_0.sprite:getPositionY())
	local var_10_1 = arg_10_0.sprite:isVisible()

	arg_10_0.sprite:removeAnimation()
	arg_10_0:initUnitData()

	arg_10_0._scale = nil
	arg_10_0._scaleX = nil
	arg_10_0._scaleY = nil
	arg_10_0.actionState = "run"

	arg_10_0:loadSprite(arg_10_0.unitRes, battle.SpriteLayerZOrder.selfSpr, arg_10_1)
	arg_10_0.sprite:setPosition(var_10_0)
	arg_10_0.sprite:setVisible(var_10_1)
	arg_10_0:setActionState(battle.SpriteActionTable.standby)
end

function BattleSprite.addToLayer(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.battleView[arg_11_1]

	if var_11_0 then
		arg_11_0:retain()
		arg_11_0:removeFromParent()
		var_11_0:add(arg_11_0, 999)
		arg_11_0:release()
	end
end

function BattleSprite.updateLifeBarState(arg_12_0, arg_12_1)
	arg_12_0.lifebar:setVisible(arg_12_1)

	arg_12_0.lifebar.canSetVisible = arg_12_1
end

function BattleSprite.pauseAnimation(arg_13_0)
	arg_13_0.isPausing = true

	if arg_13_0.sprite then
		arg_13_0.sprite:pause()
	end

	for iter_13_0, iter_13_1 in pairs(arg_13_0.buffEffectsMap) do
		iter_13_1:pause()
	end
end

function BattleSprite.resumeAnimation(arg_14_0)
	arg_14_0.isPausing = nil

	if arg_14_0.sprite then
		arg_14_0.sprite:resume()
	end

	for iter_14_0, iter_14_1 in pairs(arg_14_0.buffEffectsMap) do
		iter_14_1:resume()
	end
end

function BattleSprite.getFaceTo(arg_15_0)
	return arg_15_0.faceTo
end

function BattleSprite.pauseSprite(arg_16_0)
	arg_16_0.isPausing = true

	if arg_16_0.sprite then
		arg_16_0.sprite:pause()
	end
end

function BattleSprite.resumeSprite(arg_17_0)
	arg_17_0.isPausing = nil

	if arg_17_0.sprite then
		arg_17_0.sprite:resume()
	end
end

function BattleSprite.setPlaySpeed(arg_18_0, arg_18_1)
	if arg_18_0.sprite then
		arg_18_0.sprite:setAnimationSpeedScale(arg_18_1)
	end
end

function BattleSprite.setSpriteOpacity(arg_19_0, arg_19_1)
	arg_19_0.sprite:setCascadeOpacityEnabled(true)
	arg_19_0.sprite:setOpacity(arg_19_1)

	arg_19_0.sprite._opacity = arg_19_1
end

function BattleSprite.objToBlank(arg_20_0, arg_20_1)
	transition.executeSequence(arg_20_0):scaleTo(arg_20_1.startLast / 1000, arg_20_1.scale):delay(arg_20_1.delayLast / 1000):scaleTo(arg_20_1.endLast / 1000, 1):done()
end

function BattleSprite.objToHideEff(arg_21_0, arg_21_1)
	arg_21_1 = battleEasy.ifElse(arg_21_0.lockEffectSwitch, arg_21_1, true)

	for iter_21_0, iter_21_1 in pairs(arg_21_0.buffEffectsMap) do
		local var_21_0 = iter_21_1.showEffect or not arg_21_1

		if iter_21_1.holderActionVisible ~= nil then
			var_21_0 = iter_21_1.holderActionVisible
		end

		iter_21_1:setVisible(var_21_0)
	end

	for iter_21_2, iter_21_3 in pairs(arg_21_0.followSprite) do
		iter_21_3:objToHideEff(arg_21_1, arg_21_0)
	end

	gRootViewProxy:notify("setBuffIconVisible", arg_21_0, true)
end

function BattleSprite.setGLProgram(arg_22_0, arg_22_1)
	arg_22_0.sprite:setGLProgram(arg_22_1)

	for iter_22_0, iter_22_1 in pairs(arg_22_0.buffEffectsMap) do
		iter_22_1:setGLProgram(arg_22_1)
	end
end

function BattleSprite.setScale(arg_23_0, arg_23_1, arg_23_2)
	arg_23_0.scaleX = nil
	arg_23_0.scaleY = nil

	cc.Node.setScale(arg_23_0, 1)

	if arg_23_1 ~= arg_23_0._scale or arg_23_2 then
		arg_23_0._scale = arg_23_1

		arg_23_0:setScaleX(arg_23_0.faceTo * arg_23_1, arg_23_2)
		arg_23_0:setScaleY(arg_23_1, arg_23_2)
	end
end

function BattleSprite.setShowFaceTo(arg_24_0, arg_24_1)
	if arg_24_1 > 0 and arg_24_0._scaleX > 0 then
		return
	end

	if arg_24_1 < 0 and arg_24_0._scaleX < 0 then
		return
	end

	if arg_24_0._scaleX or arg_24_0._scaleX == 0 then
		arg_24_0._scaleX = arg_24_1 > 0 and 1 or -1
	else
		arg_24_0._scaleX = -arg_24_0._scaleX
	end

	local var_24_0 = arg_24_0.sprite:getScaleX()

	arg_24_0.sprite:setScaleX(-var_24_0)
end

function BattleSprite.setScaleX(arg_25_0, arg_25_1, arg_25_2)
	cc.Node.setScaleX(table.getraw(arg_25_0), 1)

	if arg_25_1 ~= arg_25_0._scaleX or arg_25_2 then
		arg_25_0._scaleX = arg_25_1

		arg_25_0.sprite:setScaleX(arg_25_1 * arg_25_0.unitCfg.scaleX * arg_25_0.unitCfg.scale * arg_25_0.unitCfg.scaleC)
	end
end

function BattleSprite.setScaleY(arg_26_0, arg_26_1, arg_26_2)
	cc.Node.setScaleY(table.getraw(arg_26_0), 1)

	if arg_26_1 ~= arg_26_0._scaleY or arg_26_2 then
		arg_26_0._scaleY = arg_26_1

		arg_26_0.sprite:setScaleY(arg_26_1 * arg_26_0.unitCfg.scale * arg_26_0.unitCfg.scaleC)
	end
end

function BattleSprite.getScale(arg_27_0)
	return arg_27_0._scale or 1
end

function BattleSprite.getScaleX(arg_28_0)
	return arg_28_0._scaleX or 1
end

function BattleSprite.getScaleY(arg_29_0)
	return arg_29_0._scaleY or 1
end

function BattleSprite.getMovePosZ(arg_30_0)
	return arg_30_0.battleMovePosZ
end

function BattleSprite.getSelfPos(arg_31_0)
	local var_31_0 = arg_31_0:getSeat()
	local var_31_1
	local var_31_2

	if var_31_0 < 0 then
		var_31_1, var_31_2 = battle.StandingPos[99].x, battle.StandingPos[99].y
	elseif var_31_0 <= 6 or var_31_0 > 12 then
		var_31_1, var_31_2 = battle.StandingPos[var_31_0].x, battle.StandingPos[var_31_0].y
	else
		var_31_1, var_31_2 = display.width - battle.StandingPos[var_31_0 - 6].x, battle.StandingPos[var_31_0 - 6].y
	end

	return var_31_1 + arg_31_0.posAdjust.x, var_31_2 + arg_31_0.posAdjust.y
end

function BattleSprite.setCurPos(arg_32_0, arg_32_1)
	arg_32_0.posXY = arg_32_1
end

function BattleSprite.getCurPos(arg_33_0)
	return arg_33_0.posXY.x, arg_33_0.posXY.y
end

function BattleSprite.curPosEqual(arg_34_0, arg_34_1, arg_34_2)
	return arg_34_0.posXY.x == arg_34_1 and arg_34_0.posXY.y == arg_34_2
end

function BattleSprite.getAttackPos(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	local var_35_0 = arg_35_0:getSeat()
	local var_35_1
	local var_35_2
	local var_35_3 = arg_35_3 and -1 or 1

	if arg_35_1 == battle.AttackPosIndex.selfPos then
		return arg_35_0:getSelfPos()
	elseif arg_35_1 <= 6 or arg_35_1 == battle.AttackPosIndex.center then
		var_35_1, var_35_2 = battle.AttackPos[arg_35_1].x, battle.AttackPos[arg_35_1].y
	else
		var_35_1, var_35_2 = display.width - battle.AttackPos[arg_35_1 - 6].x, battle.AttackPos[arg_35_1 - 6].y
	end

	local var_35_4 = 1

	if arg_35_0.unitCfg.scaleCMode == 1 then
		var_35_4 = arg_35_0.unitCfg.scaleC
	end

	local var_35_5 = var_35_1 + arg_35_0.faceTo * arg_35_2.x * var_35_4 * var_35_3
	local var_35_6 = var_35_2 + arg_35_2.y - 1

	return var_35_5, var_35_6
end

function BattleSprite.getProtectPos(arg_36_0, arg_36_1, arg_36_2)
	local var_36_0
	local var_36_1

	if arg_36_1 <= 6 or arg_36_1 >= 13 then
		var_36_0, var_36_1 = battle.ProtectPos[arg_36_1].x, battle.ProtectPos[arg_36_1].y
	else
		var_36_0, var_36_1 = display.width - battle.ProtectPos[arg_36_1 - 6].x, battle.ProtectPos[arg_36_1 - 6].y
	end

	local var_36_2 = 1

	if arg_36_0.unitCfg.scaleCMode == 1 then
		var_36_2 = arg_36_0.unitCfg.scaleC
	end

	local var_36_3 = var_36_0 + arg_36_0.faceTo * arg_36_2.x * var_36_2
	local var_36_4 = var_36_1 + arg_36_2.y - 1

	return var_36_3 + arg_36_0.posAdjust.x, var_36_4 + arg_36_0.posAdjust.y
end

function BattleSprite.updHitPanel(arg_37_0)
	local var_37_0 = arg_37_0.battleView:onViewProxyCall("getObjHitPanel", arg_37_0.seat)

	if var_37_0 then
		var_37_0:setVisible(true)
		var_37_0:setEnabled(true)
		var_37_0:setTouchEnabled(true)

		local var_37_1, var_37_2 = arg_37_0:getSelfPos()
		local var_37_3 = arg_37_0.model.unitCfg.everyPos.hitPos
		local var_37_4 = var_37_1 + var_37_3.x
		local var_37_5 = var_37_2 + var_37_3.y

		var_37_0:setAnchorPoint(0.5, 0)
		var_37_0:setPosition(var_37_4, var_37_5)

		local var_37_6 = arg_37_0.model.unitCfg.rectSize

		var_37_0:setContentSize(cc.size(var_37_6.x, var_37_6.y))
	end
end

function BattleSprite.onUpdate(arg_38_0, arg_38_1)
	return arg_38_0.effectManager:update(arg_38_1)
end

function BattleSprite.onPushAction(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	if arg_39_0.actionTable[arg_39_1] == nil then
		arg_39_0.actionTable[arg_39_1] = CList.new()
	end

	arg_39_0.actionTable[arg_39_1]:push_front({
		action = arg_39_2,
		from = arg_39_3
	})
end

function BattleSprite.onPopAction(arg_40_0, arg_40_1, arg_40_2)
	for iter_40_0, iter_40_1 in arg_40_0.actionTable[arg_40_1]:pairs() do
		if iter_40_1.from == arg_40_2 then
			arg_40_0.actionTable[arg_40_1]:erase(iter_40_0)

			break
		end
	end
end

function BattleSprite.getActionName(arg_41_0, arg_41_1)
	local var_41_0 = arg_41_0.actionTable[arg_41_1] and arg_41_0.actionTable[arg_41_1]:front()

	return var_41_0 and var_41_0.action
end

local var_0_0 = {
	attack = true,
	skill2 = true,
	skill1 = true,
	skill3 = true
}

function BattleSprite.setActionState(arg_42_0, arg_42_1, arg_42_2)
	if not arg_42_1 then
		return
	end

	if arg_42_0.actionState == "win_loop" then
		return
	end

	if arg_42_0.actionState == arg_42_1 then
		if not battle.LoopActionMap[arg_42_1] then
			if not arg_42_0.actionCompleteCallback then
				arg_42_0.actionCompleteCallback = arg_42_2
			end

			arg_42_0:onPlayState(arg_42_1)
		end

		return
	end

	if arg_42_0.actionCompleteCallback then
		arg_42_0.actionCompleteCallback()
	end

	arg_42_0.actionState = arg_42_1
	arg_42_0.actionCompleteCallback = arg_42_2

	arg_42_0:onPlayState(arg_42_1)
end

function BattleSprite.onPlayState(arg_43_0, arg_43_1)
	if not arg_43_1 then
		return
	end

	local var_43_0 = arg_43_0:getActionName(arg_43_1) or arg_43_1

	arg_43_0.sprite:play(var_43_0)
end

function BattleSprite.addActionCompleteListener(arg_44_0, arg_44_1)
	arg_44_0.actionCompleteCallback = arg_44_0.actionCompleteCallback and callbacks.new(arg_44_0.actionCompleteCallback, arg_44_1) or arg_44_1

	return arg_44_0.actionCompleteCallback
end

function BattleSprite.showGuide(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	local var_45_0 = 368
	local var_45_1 = 162

	if not arg_45_0.qipao then
		arg_45_0.qipao = newCSprite()

		arg_45_0.qipao:setContentSize(cc.size(var_45_0, var_45_1))

		local var_45_2 = arg_45_0.unitCfg.everyPos.lifePos

		arg_45_0.qipao:addTo(arg_45_0.battleView.gameLayer, battle.SpriteLayerZOrder.qipao):xy(cc.p(arg_45_0:getPositionX() + var_45_2.x, arg_45_0:getPositionY() + var_45_2.y + 20)):anchorPoint(1, 0)

		local var_45_3 = cc.Scale9Sprite:create("city/gate/bg_dialog.png")

		var_45_3:setCapInsets(CCRectMake(40, 60, 1, 1))
		var_45_3:size(cc.size(var_45_0, var_45_1))
		var_45_3:xy(cc.p(var_45_0 / 2, var_45_1 / 2))
		arg_45_0.qipao:add(var_45_3)

		if arg_45_0.force == 1 then
			var_45_3:setScaleX(-1)
			arg_45_0.qipao:xy(cc.p(var_45_2.x + var_45_0, var_45_2.y + 20))
		end
	end

	arg_45_0.qipao:show()
	arg_45_0.qipao:removeChildByName("richText")

	local var_45_4 = rich.createWithWidth("#C0x5b545b#" .. arg_45_1, 30, deltaSize, var_45_0 - 35)

	var_45_4:setAnchorPoint(cc.p(0, 1))

	local var_45_5 = var_45_4:getContentSize().height

	var_45_4:xy(25, var_45_1 - (var_45_1 - 17 - var_45_5) / 2)
	arg_45_0.qipao:add(var_45_4, 3, "richText")
	transition.executeSequence(arg_45_0.qipao):delay((arg_45_2 or 1000) / 1000):func(function()
		if arg_45_0.qipao then
			arg_45_0.qipao:hide()
		end

		if arg_45_3 then
			arg_45_3()
		end
	end):done()
end

function BattleSprite.resetPos(arg_47_0)
	arg_47_0:setVisible(true)
	arg_47_0:setLocalZOrder(arg_47_0.posZ)
	arg_47_0:setRotation(0)
	arg_47_0:stopAllActions()
	arg_47_0:setActionState(battle.SpriteActionTable.standby)
	arg_47_0:moveToPosIdx(arg_47_0:getSeat())
	arg_47_0:setScaleX(arg_47_0.forceFaceTo)
	arg_47_0:setScaleY(1)
end

function BattleSprite.resetActionTab(arg_48_0)
	for iter_48_0, iter_48_1 in pairs(battle.SpriteActionTable) do
		arg_48_0.actionTable[iter_48_1] = CList.new()

		if iter_48_1 ~= battle.SpriteActionTable.death then
			arg_48_0:onPushAction(iter_48_1, iter_48_1)
		end
	end
end

function BattleSprite.isComeBacking(arg_49_0, arg_49_1)
	if arg_49_1 ~= nil then
		arg_49_0.comeBacking = arg_49_1
	end

	return arg_49_0.comeBacking
end

function BattleSprite.setSkin(arg_50_0, arg_50_1)
	arg_50_1 = arg_50_1 or {
		buffId = -1,
		isRestore = false
	}
	arg_50_1.skinName = arg_50_1.skinName or arg_50_0.unitCfg.skin

	if arg_50_1.isRestore then
		for iter_50_0, iter_50_1 in arg_50_0.skins:ipairs() do
			if iter_50_1.buffId == arg_50_1.buffId then
				arg_50_0.skins:erase(iter_50_0)

				if iter_50_0 <= arg_50_0.skins:size() then
					return
				end

				break
			end
		end
	else
		arg_50_0.skins:push_back(arg_50_1)
	end

	local var_50_0 = arg_50_0.skins:back() and arg_50_0.skins:back().skinName

	if not var_50_0 then
		return
	end

	local var_50_1 = arg_50_0.sprite:getAni()

	var_50_1:setSkin(var_50_0)
	var_50_1:setToSetupPose()
end

function BattleSprite.stopAllHolderAction(arg_51_0)
	for iter_51_0, iter_51_1 in pairs(arg_51_0.buffEffectHolderMap) do
		if iter_51_1.isPlayId then
			for iter_51_2, iter_51_3 in iter_51_1.datas:pairs() do
				if iter_51_3.id == iter_51_1.isPlayId then
					arg_51_0:onPlayBuffHolderAction(iter_51_0, iter_51_3, true)

					iter_51_1.isPlayId = nil

					break
				end
			end
		end
	end
end

function BattleSprite.onSetSpriteVisible(arg_52_0, arg_52_1)
	arg_52_0.sprite:setVisible(arg_52_1)
end

function BattleSprite.getSpriteVisible(arg_53_0)
	return arg_53_0.sprite:isVisible()
end

function BattleSprite.getPosAdjust(arg_54_0)
	local var_54_0 = arg_54_0.args.offsetPos or cc.p(0, 0)

	return cc.p(arg_54_0.forceFaceTo * var_54_0.x, var_54_0.y)
end

function BattleSprite.updateFaceTo(arg_55_0, arg_55_1)
	arg_55_0.force = arg_55_1
	arg_55_0.forceFaceTo = arg_55_0.force == 1 and 1 or -1
	arg_55_0.faceTo = arg_55_0.forceFaceTo

	arg_55_0:setScaleX(arg_55_0.forceFaceTo)
end

function BattleSprite.alterLockEffectRecord(arg_56_0, arg_56_1)
	arg_56_0.lockEffectSwitch = arg_56_1
end

function BattleSprite.setVisibleEnable(arg_57_0, arg_57_1)
	arg_57_0.canSetVisible = arg_57_1
end

function BattleSprite.setVisible(arg_58_0, arg_58_1)
	if not arg_58_0.canSetVisible then
		return
	end

	cc.Node.setVisible(table.getraw(arg_58_0), arg_58_1)
end

function BattleSprite.addReplaceView(arg_59_0, arg_59_1, arg_59_2)
	arg_59_0.replaceView = arg_59_1
end

function BattleSprite.removeReplaceView(arg_60_0, arg_60_1)
	arg_60_0.replaceView = nil
end

function BattleSprite.checkSceneTag(arg_61_0, arg_61_1)
	return
end

function BattleSprite.getRealUseView(arg_62_0)
	local var_62_0 = arg_62_0

	if arg_62_0.replaceView and arg_62_0.replaceView:checkSceneTag(arg_62_0.skillSceneTag:back()) then
		var_62_0 = arg_62_0.replaceView
	end

	return var_62_0
end

function BattleSprite.pushApplySkillSceneTag(arg_63_0, arg_63_1)
	arg_63_0.skillSceneTag:push_back(arg_63_1)
end

function BattleSprite.popApplySkillSceneTag(arg_64_0)
	arg_64_0.skillSceneTag:pop_back()
end

function BattleSprite.showHero(arg_65_0, arg_65_1, arg_65_2)
	if arg_65_2.obj then
		arg_65_0.groundRing:setVisible(arg_65_1 and arg_65_0.key == arg_65_2.obj)
	end

	arg_65_0.lifebar:setVisible(arg_65_1 and not arg_65_2.hideLife)
	arg_65_0:setVisible(arg_65_1)
end

function BattleSprite.addFollowSpr(arg_66_0, arg_66_1, arg_66_2)
	arg_66_0.followSprite[arg_66_1.key] = arg_66_1
end

function BattleSprite.removeFollowSpr(arg_67_0, arg_67_1)
	arg_67_0.followSprite[arg_67_1.key] = nil
end

function BattleSprite.sceneDelFollowObj(arg_68_0, arg_68_1)
	for iter_68_0, iter_68_1 in pairs(arg_68_0.followSprite) do
		gRootViewProxy:notify("sceneDelObj", iter_68_1.key)
	end
end

function BattleSprite.sceneDelObj(arg_69_0, arg_69_1)
	arg_69_0:unscheduleUpdate()
	arg_69_0:retain()
	arg_69_0:sceneDelFollowObj(arg_69_1)
	arg_69_0:removeSelf()
	arg_69_1:addChild(arg_69_0)
	arg_69_0:release()
end

require("battle.views.sprite_normal")
require("battle.views.sprite_effect")
require("battle.views.sprite_proxy")
require("battle.views.sprite_debug")
