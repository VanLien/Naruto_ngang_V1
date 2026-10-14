local var_0_0 = class("SkillInfo", battleModule.CBase)
local var_0_1 = string.format
local var_0_2 = {
	qian = "dazhao_qian_loop",
	shan = "dazhao_shan",
	hou = "dazhao_hou_loop",
	man = "dazhao_man_loop",
	mankuang = "dazhao_mankuang",
	mankuang_l = "dazhao_mankuang_loop",
	shui = "dazhao_shui_loop"
}

function var_0_0.selectIsFirstMainCharge(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.skillMainTb = arg_1_0.skillMainTb or {}

	local var_1_0 = tostring(arg_1_1)

	if arg_1_0.skillMainTb[var_1_0] ~= arg_1_2 and arg_1_2 then
		arg_1_0.skillMainTb[var_1_0] = arg_1_2

		return true
	end

	arg_1_0.skillMainTb[var_1_0] = arg_1_2

	return false
end

function var_0_0.playMainSkillEffect(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	if not arg_2_1.mpWater then
		error("water effect not exist")
	end

	local var_2_0 = arg_2_1:size()

	if not arg_2_1.kuang then
		arg_2_1.kuang = newCSprite("effect/dz_ice.skel")

		arg_2_1:z(6):add(arg_2_1.kuang)
		arg_2_1.kuang:setPosition(cc.p(var_2_0.width / 2 - 3, 5))
	end

	arg_2_1.kuang:visible(arg_2_2)

	if arg_2_2 then
		arg_2_1.mpWater:play(arg_2_0:getEffectName(arg_2_1, "shan"))
		arg_2_1.mpWater:addPlay(arg_2_0:getEffectName(arg_2_1, "man"))

		if arg_2_0:selectIsFirstMainCharge(arg_2_3, arg_2_2) then
			arg_2_1.kuang:z(10):play(arg_2_0:getEffectName(arg_2_1, "mankuang"))
			arg_2_1.kuang:z(8):addPlay(arg_2_0:getEffectName(arg_2_1, "mankuang_l"))
		else
			arg_2_1.kuang:play(arg_2_0:getEffectName(arg_2_1, "mankuang_l"))
		end
	else
		arg_2_1.mpWater:play(arg_2_0:getEffectName(arg_2_1, "shui"))
	end
end

function var_0_0.getEffectName(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_1.widgetEffects
	local var_3_1 = var_0_2[arg_3_2]

	if var_3_0 and var_3_0[arg_3_2] then
		var_3_1 = var_3_0[arg_3_2]
	end

	return var_3_1
end

function var_0_0.ctor(arg_4_0, arg_4_1)
	battleModule.CBase.ctor(arg_4_0, arg_4_1)

	arg_4_0.widgets = {
		arg_4_0.parent.UIWidgetBottomRight:get("skill1"),
		arg_4_0.parent.UIWidgetBottomRight:get("skill2"),
		arg_4_0.parent.UIWidgetBottomRight:get("skill3"),
		arg_4_0.parent.UIWidgetBottomRight:get("skill4")
	}

	for iter_4_0, iter_4_1 in ipairs(arg_4_0.widgets) do
		iter_4_1:hide()
	end

	arg_4_0.cardClipping = arg_4_0.parent.UIWidgetBottomRight:get("cardClipping")

	arg_4_0.cardClipping:hide()
	arg_4_0.cardClipping:setClippingEnabled(true)

	arg_4_0.cardPx, arg_4_0.cardPy = arg_4_0.cardClipping:xy()
	arg_4_0.cardPHalfWidth = arg_4_0.cardClipping:size().width / 2
	arg_4_0.heroIcon = arg_4_0.cardClipping:get("halfHeroIcon")
	arg_4_0.headIcon = arg_4_0.parent.UIWidgetBottomRight:get("head")
	arg_4_0.curSkill = nil
	arg_4_0.skillWidgetMap = {}
	arg_4_0.originWidigetY = arg_4_0.widgets[1]:getPositionY()

	local var_4_0 = arg_4_0.parent.UIWidgetBottomRight:get("skillInfo")

	var_4_0:hide()

	arg_4_0.infoPanelSize = var_4_0:getContentSize()
	arg_4_0.skillCdMap = {}
end

function var_0_0.skillInit(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_1.orderId
	local var_5_1 = arg_5_1.widget
	local var_5_2 = arg_5_1.skillID
	local var_5_3 = arg_5_1.leftCd
	local var_5_4 = arg_5_1.model
	local var_5_5 = arg_5_1.precent
	local var_5_6 = arg_5_1.costMp1
	local var_5_7 = csv.skill[var_5_2]

	var_5_1:get("skillName"):setString(var_5_7.skillName)
	var_5_1:get("skill"):loadTexture(var_5_7.iconRes)
	var_5_1:setTouchEnabled(true)

	local var_5_8, var_5_9 = arg_5_0:isZawakeSkill(var_5_7, var_5_4)

	var_5_1:get("bgLogo"):setVisible(var_5_8 ~= nil)

	if var_5_0 == 1 then
		local var_5_10 = math.floor(100 * var_5_5)
		local var_5_11 = math.min(math.max(0, var_5_10), 100)

		var_5_1.widgetEffects = var_5_7.widgetEffects or {}

		local var_5_12 = var_5_1:size()

		if not var_5_1.mpWater then
			var_5_1:get("bg"):hide()

			local var_5_13 = newCSprite("battle/btn_skill_2.png"):addTo(var_5_1, 3):xy(var_5_12.width / 2, var_5_12.height / 2)
			local var_5_14 = newCSprite("effect/dz_ice.skel")

			var_5_14:play(arg_5_0:getEffectName(var_5_1, "shui"))

			local var_5_15 = cc.Sprite:create("battle/btn_skill_1.png")

			var_5_15:anchorPoint(0, 0):scale(1.2):y(0):x(0)

			local var_5_16 = cc.ClippingNode:create(var_5_15)

			var_5_16:setAlphaThreshold(0.2)
			var_5_1:add(var_5_16)
			var_5_16:add(var_5_14)

			var_5_1.mpWater = var_5_14
		end

		local var_5_17 = cc.p(127, 0)

		var_5_1.mpWater:stopAllActions()

		if arg_5_2 then
			var_5_1.mpWater:setPosition(var_5_17)
			arg_5_0:playMainSkillEffect(var_5_1, var_5_11 >= 100, var_5_4)
		else
			local var_5_18 = 0.6

			transition.executeSequence(var_5_1.mpWater):moveTo(var_5_18, 150, var_5_17.y):delay(0.01):func(function()
				arg_5_0:playMainSkillEffect(var_5_1, var_5_11 >= 100, var_5_4)
			end):done()
		end

		if var_5_6 and var_5_6 == 0 and not arg_5_1.canSpell then
			var_5_1:get("bg"):show()
			arg_5_0:playMainSkillEffect(var_5_1, false, var_5_4)
			var_5_1.mpWater:hide()
		else
			var_5_1:get("bg"):hide()
			var_5_1.mpWater:show()
		end
	end

	local var_5_19 = var_5_1:get("round")

	var_5_19:hide()
	var_5_19:scale(2.5)
	var_5_19:opacity(0)

	local var_5_20 = var_5_1:get("cdBg")

	var_5_20:hide()

	if not arg_5_1.canSpell and var_5_3 and var_5_3 > 0 and var_5_3 < 100 then
		var_5_20:show()
		var_5_19:setVisible(true)
		var_5_19:setString(var_5_3)

		if not next(arg_5_0.skillCdMap) or arg_5_0.skillCdMap[var_5_2] ~= var_5_3 then
			transition.executeParallel(var_5_19):fadeTo(0.5, 255):scaleTo(0.5, 1)

			arg_5_0.skillCdMap[var_5_2] = var_5_3
		else
			var_5_19:scale(1)
			var_5_19:opacity(255)
		end

		local var_5_21
		local var_5_22 = (1 - var_5_3 / var_5_7.cdRound) * 100
	end
end

function var_0_0.isZawakeSkill(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_1.zawakeEffect[1]

	if var_7_0 and arg_7_2.tagSkills[var_7_0] then
		return csv.skill[var_7_0], arg_7_1 and arg_7_1.zawakeEffect[2] == 1
	end
end

function var_0_0.getSkillName(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_1.skillName
	local var_8_1 = arg_8_0:isZawakeSkill(arg_8_1, arg_8_2)

	if var_8_1 then
		return var_8_1.skillName .. var_8_0
	end

	return var_8_0
end

function var_0_0.skillButtonInit(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1.orderId
	local var_9_1 = arg_9_1.widget
	local var_9_2 = arg_9_1.skillID
	local var_9_3 = arg_9_1.leftCd
	local var_9_4 = arg_9_1.leftStartRound
	local var_9_5 = arg_9_1.model
	local var_9_6 = csv.skill[var_9_2]

	var_9_1:get("clickFrame"):hide()

	local var_9_7 = false

	local function var_9_8(arg_10_0)
		var_9_7 = arg_10_0

		local var_10_0 = arg_9_0.parent.UIWidgetBottomRight:get("skillInfo")
		local var_10_1 = var_10_0:get("container")
		local var_10_2 = var_10_1:get("skillDescribe")

		var_10_0:show()

		if not arg_10_0 then
			var_10_0:hide()
			var_10_2:removeAllChildren()

			return
		end

		local var_10_3, var_10_4 = var_9_1:getPosition()
		local var_10_5 = var_9_1:getBoundingBox()
		local var_10_6 = var_9_0 == 1 and -160 or 0

		var_10_0:setPosition(cc.p(var_10_3 + var_10_6, var_10_4 + var_10_5.height / 2 + 15))
		var_10_0:setLocalZOrder(99999)
		var_10_0:setVisible(true)

		local var_10_7 = var_10_1:get("skillName")

		var_10_7:setString(arg_9_0:getSkillName(var_9_6, var_9_5))

		local var_10_8 = nodetools.get(var_10_1, "skillrange")

		var_10_8:setString(var_9_6.targetTypeDesc)

		local var_10_9 = var_10_2:getContentSize()
		local var_10_10 = math.max(0, var_10_7:getContentSize().width + var_10_8:getContentSize().width - var_10_9.width)
		local var_10_11 = 0

		if matchLanguage({
			"en"
		}) then
			var_10_11 = 150
		end

		arg_9_0.descSizeWidth = var_10_9.width + var_10_10 + var_10_11

		local var_10_12 = var_9_6.describe
		local var_10_13 = false

		if arg_9_0:isZawakeSkill(var_9_6, var_9_5) then
			if var_9_6.zawakeEffect[2] == 1 then
				var_10_13 = true
			else
				var_10_12 = var_9_6.zawakeEffectDesc
			end
		end

		local var_10_14 = arg_9_1.level
		local var_10_15 = uiEasy.getStarSkillDesc({
			skillLevel = var_10_14,
			skillId = var_9_2,
			star = var_9_5:getStar(),
			isZawake = var_10_13
		})
		local var_10_16 = rich.createWithWidth(string.format("#C0x5b545b#%s", eval.doMixedFormula(var_10_12, {
			skillLevel = var_10_14 or 1,
			math = math
		}, nil) or "no desc") .. var_10_15, 40, nil, arg_9_0.descSizeWidth)

		var_10_16:setAnchorPoint(cc.p(0, 1))
		var_10_16:setPosition(cc.p(0, 0))
		var_10_2:addChild(var_10_16, 99)

		local var_10_17 = var_10_16:getContentSize().height
		local var_10_18 = math.max(0, var_10_17 - var_10_9.height)
		local var_10_19 = arg_9_0.infoPanelSize.width + var_10_10
		local var_10_20 = arg_9_0.infoPanelSize.height + var_10_18

		var_10_0:get("bg"):setContentSize(cc.size(var_10_19 + var_10_11, var_10_20))
		var_10_8:setPosition(cc.p(arg_9_0.infoPanelSize.width / 2 + var_10_10 + var_10_11 / 2, var_10_8:getPositionY()))
		var_10_1:setPosition(cc.p(arg_9_0.infoPanelSize.width / 2 - var_10_10 / 2 - var_10_11 / 2, var_10_20))
	end

	local var_9_9
	local var_9_10 = var_9_1:getContentSize()
	local var_9_11 = cc.rect(0, 0, var_9_10.width, var_9_10.height)

	var_9_1:addTouchEventListener(function(arg_11_0, arg_11_1)
		if arg_9_0.parent.guideManager:isInGuiding() then
			var_9_8(false)

			if var_9_9 then
				var_9_1:stopAction(var_9_9)

				var_9_9 = nil
			end

			return
		end

		if arg_11_1 == ccui.TouchEventType.began then
			if var_9_9 then
				var_9_1:stopAction(var_9_9)

				var_9_9 = nil
			end

			var_9_8(false)

			var_9_9 = performWithDelay(var_9_1, function()
				var_9_9 = nil

				var_9_8(not arg_9_0.parent.guideManager:isInGuiding())
			end, 0.3)
		elseif arg_11_1 == ccui.TouchEventType.moved then
			local var_11_0 = arg_11_0:getTouchMovePosition()
			local var_11_1 = var_9_1:convertToNodeSpace(var_11_0)

			if not cc.rectContainsPoint(var_9_11, var_11_1) then
				var_9_1:stopAction(var_9_9)

				var_9_9 = nil

				var_9_8(false)
			end
		elseif arg_11_1 == ccui.TouchEventType.ended or arg_11_1 == ccui.TouchEventType.canceled then
			var_9_1:stopAction(var_9_9)

			var_9_9 = nil

			var_9_8(false)
		end
	end)
	var_9_1:onClick(function()
		if var_9_7 then
			return
		end

		if arg_9_0.cannotClick then
			return
		end

		local var_13_0 = var_9_5.skills[var_9_2]

		if not var_13_0 then
			errorInWindows("selectedSkill is nil model unitID(%s), orginUnitId(%s), skillID(%s), skillsOrder(%s)", var_9_5.unitID, var_9_5.orginUnitId, var_9_2, dumps(var_9_5.skillsOrder or {}))

			return
		end

		var_9_5.curSelectSkill = var_13_0

		local var_13_1 = table.length(var_13_0:getTargetsHint())

		if not arg_9_1.canSpell then
			local var_13_2

			if var_9_3 > 0 or var_9_4 > 0 then
				var_13_2 = gLanguageCsv.skillCannotSpell
			elseif var_9_5:isLogicStateExit(battle.ObjectLogicState.cantUseSkill, {
				skillType2 = battle.MainSkillType.BigSkill
			}) and var_9_6.skillType2 == battle.MainSkillType.BigSkill or var_9_5:isLogicStateExit(battle.ObjectLogicState.cantUseSkill, {
				skillType2 = battle.MainSkillType.SmallSkill
			}) and var_9_6.skillType2 == battle.MainSkillType.SmallSkill or var_9_5:isLogicStateExit(battle.ObjectLogicState.cantUseSkill, {
				skillType2 = battle.MainSkillType.NormalSkill
			}) and var_9_6.skillType2 == battle.MainSkillType.NormalSkill or var_9_5:isLogicStateExit(battle.ObjectLogicState.cantUseSkill, {
				skillId = var_9_2
			}) then
				var_13_2 = gLanguageCsv.objectInControl
			elseif var_9_5:isBeInSneer() then
				var_13_2 = gLanguageCsv.objectInSneer
			elseif var_13_1 == 0 then
				var_13_2 = gLanguageCsv.canNotSelect
			else
				var_13_2 = gLanguageCsv.mpNotEnough
			end

			if var_13_2 then
				gGameUI:showTip(var_13_2)
			end

			return
		end

		arg_9_0:notify("selectedHero")

		if arg_9_0.curSkill then
			local var_13_3 = arg_9_0.widgets[arg_9_0.skillWidgetMap[arg_9_0.curSkill]]

			var_13_3:get("clickFrame"):hide()
			transition.executeParallel(var_13_3):moveBy(0.02, 0, -10)

			if arg_9_0.curSkill == var_9_2 then
				arg_9_0:call("resetHitPanelStateToShowAttrsPanel")

				arg_9_0.curSkill = nil

				return
			end
		end

		arg_9_0:notify("selectSkill", var_13_0, arg_9_1.exactImmuneInfos)
	end)
end

function var_0_0.onSelectSkill(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_1.id
	local var_14_1 = arg_14_0.widgets[arg_14_0.skillWidgetMap[var_14_0]]

	if not arg_14_0.skillWidgetMap[var_14_0] or not var_14_1 then
		return
	end

	local var_14_2 = var_14_1:get("clickFrame")

	transition.executeParallel(var_14_1):moveBy(0.02, 0, 10)
	var_14_2:setVisible(true)

	arg_14_0.curSkill = var_14_0
end

function var_0_0.onSkillRefresh(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	if not arg_15_2 or not next(arg_15_2) or not arg_15_3 or not next(arg_15_3) then
		return
	end

	local var_15_0 = arg_15_1.scene.play

	if not var_15_0:isPlaying() then
		arg_15_0.cannotClick = true

		return
	end

	if var_15_0:isNowTurnAutoFight() then
		arg_15_0.cannotClick = true
	end

	local var_15_1 = table.length(arg_15_2)

	arg_15_0.headIcon:loadTexture(arg_15_1.unitCfg.iconSimple)

	local var_15_2 = {}

	for iter_15_0, iter_15_1 in ipairs(arg_15_2) do
		if iter_15_0 <= table.length(arg_15_0.widgets) then
			iter_15_1 = arg_15_1.skillsMap[iter_15_1] or iter_15_1

			local var_15_3 = arg_15_3[iter_15_1].stateInfoTb
			local var_15_4 = {
				orderId = iter_15_0,
				skillID = iter_15_1,
				widget = arg_15_0.widgets[iter_15_0],
				canSpell = var_15_3.canSpell,
				leftCd = var_15_3.leftCd,
				leftStartRound = var_15_3.leftStartRound,
				precent = var_15_3.precent,
				level = var_15_3.level,
				model = arg_15_1,
				costMp1 = arg_15_3[iter_15_1].costMp1,
				exactImmuneInfos = arg_15_4[iter_15_1],
				natureType = arg_15_3[iter_15_1]:getSkillNatureType()
			}

			var_15_2[iter_15_0] = var_15_4

			arg_15_0:skillInit(var_15_4, true)

			arg_15_0.skillWidgetMap[iter_15_1] = iter_15_0

			arg_15_0.widgets[iter_15_0]:setVisible(true)
			arg_15_0.widgets[iter_15_0]:setTouchEnabled(false)
			performWithDelay(arg_15_0.widgets[iter_15_0], function()
				arg_15_0.widgets[iter_15_0]:setTouchEnabled(true)
			end, 0)
		end
	end

	arg_15_0.headIcon:loadTexture(arg_15_1.unitCfg.iconSimple)
	arg_15_0.heroIcon:loadTexture(arg_15_1.unitCfg.show)
	arg_15_0.heroIcon:scale(arg_15_1.unitCfg.bansxScale)

	local var_15_5 = arg_15_1.unitCfg.bansxPosC

	arg_15_0.heroIcon:xy(arg_15_0.cardPHalfWidth + (var_15_5.x or 0), var_15_5.y or 0)
	arg_15_0.heroIcon:setVisible(false)

	if var_15_1 < table.length(arg_15_0.widgets) then
		for iter_15_2 = var_15_1 + 1, table.length(arg_15_0.widgets) do
			arg_15_0.widgets[iter_15_2]:hide()
		end
	end

	local var_15_6 = arg_15_0.widgets[math.min(var_15_1, table.length(arg_15_0.widgets))]:getPositionX()

	arg_15_0.cardClipping:xy(var_15_6 - 40 - arg_15_0.cardPHalfWidth, arg_15_0.cardPy)

	for iter_15_3, iter_15_4 in ipairs(var_15_2) do
		arg_15_0:skillButtonInit(iter_15_4)
	end

	for iter_15_5, iter_15_6 in pairs(arg_15_0.widgets) do
		arg_15_0.widgets[iter_15_5]:setPositionY(arg_15_0.originWidigetY)
	end
end

function var_0_0.onNewBattleRound(arg_17_0, arg_17_1)
	arg_17_0.curSkill = nil
	arg_17_0.skillWidgetMap = {}
	arg_17_0.cannotClick = nil

	if arg_17_1.obj.scene.autoFight or arg_17_1.isTurnAutoFight then
		arg_17_0:hideAll()
	else
		arg_17_0:onSkillRefresh(arg_17_1.obj, arg_17_1.skillsOrder, arg_17_1.skillsStateInfoTb, arg_17_1.immuneInfos)
	end
end

function var_0_0.onBattleTurnEnd(arg_18_0)
	arg_18_0:hideAll()
end

function var_0_0.onAutoSelectSkill(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0:call("getSceneObjBySeat", arg_19_1)

	if var_19_0 then
		arg_19_0:onSelectObj(var_19_0, arg_19_2)
	end
end

function var_0_0.onSelectObj(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_2 or arg_20_0.curSkill

	if arg_20_0.curSkill == nil then
		if not var_20_0 then
			return
		end

		arg_20_0:onSelectSkill({
			id = var_20_0
		})
	end

	arg_20_0:notify("selectedHero")
	arg_20_1.natureQuan:show()
	transition.executeSequence(arg_20_1.natureQuan):delay(0.5):func(function()
		arg_20_1.natureQuan:hide()
	end):done()
	transition.executeSequence(arg_20_1.groundRing):delay(0.5):func(function()
		arg_20_1.groundRing:hide()
	end):done()

	arg_20_0.curSkill = nil
	arg_20_0.skillWidgetMap = {}

	for iter_20_0, iter_20_1 in ipairs(arg_20_0.widgets) do
		iter_20_1:setTouchEnabled(false)
	end

	arg_20_0.parent:handleOperation(battle.OperateTable.attack, arg_20_1.model.seat, var_20_0)

	arg_20_0.cannotClick = true
end

function var_0_0.onClose(arg_23_0)
	return
end

function var_0_0.hideAll(arg_24_0)
	for iter_24_0, iter_24_1 in ipairs(arg_24_0.widgets) do
		iter_24_1:setPositionY(-arg_24_0.originWidigetY - 100)
		iter_24_1:setVisible(false)
	end

	arg_24_0.heroIcon:hide()
end

return var_0_0
