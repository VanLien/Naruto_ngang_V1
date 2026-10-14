local var_0_0 = {
	[0] = "stageLayer",
	"effectLayerLower",
	"gameLayer",
	nil,
	"frontStageLayer"
}
local var_0_1 = {
	gLanguageCsv.firstTeam,
	gLanguageCsv.secondTeam,
	gLanguageCsv.thirdTeam,
	gLanguageCsv.fourthTeam,
	gLanguageCsv.fifthTeam,
	gLanguageCsv.sixthTeam,
	gLanguageCsv.seventhTeam,
	gLanguageCsv.eighthTeam,
	gLanguageCsv.ninthTeam,
	gLanguageCsv.tenthTeam
}

require("battle.models.skill.helper")

local var_0_2 = table.insert
local var_0_3 = string.format
local var_0_4 = class("MainArea", battleModule.CBase)

function var_0_4.ctor(arg_1_0, arg_1_1)
	battleModule.CBase.ctor(arg_1_0, arg_1_1)

	arg_1_0.isFirstEnter = true
	arg_1_0.preNumber = 0
	arg_1_0.sumNumber = 0
	arg_1_0.showNumberType = nil
	arg_1_0.mp1AwardCount = {}

	for iter_1_0 = 1, battlePlay.Gate.ObjectNumber do
		arg_1_0.mp1AwardCount[iter_1_0] = 0
	end

	arg_1_0.damangeSumSprite = cc.Sprite:create(battle.MainAreaRes.txtZsh)
	arg_1_0.hpSumSprite = cc.Sprite:create(battle.MainAreaRes.txtZzl)
	arg_1_0.sumSprite = nil

	arg_1_0.damangeSumSprite:hide():z(999):anchorPoint(1, 0.5):addTo(arg_1_0.parent.effectLayer)
	arg_1_0.hpSumSprite:hide():z(999):anchorPoint(1, 0.5):addTo(arg_1_0.parent.effectLayer)

	arg_1_0.damageSumLabel = ccui.Layout:create():z(1099):addTo(arg_1_0.parent.effectLayer):hide()
	arg_1_0.hpSumLabel = ccui.Layout:create():z(1099):addTo(arg_1_0.parent.effectLayer):hide()
	arg_1_0.sumLabel = nil
	arg_1_0.sumLabelNum = idler.new(0)

	bind.extend(arg_1_0.parent, arg_1_0.damageSumLabel, {
		class = "text_atlas",
		props = {
			align = "center",
			isEqualDist = false,
			data = arg_1_0.sumLabelNum,
			pathName = battle.MainAreaRes.fontZsh
		}
	})
	bind.extend(arg_1_0.parent, arg_1_0.hpSumLabel, {
		class = "text_atlas",
		props = {
			align = "center",
			isEqualDist = false,
			data = arg_1_0.sumLabelNum,
			pathName = battle.MainAreaRes.fontZzl
		}
	})

	local var_1_0 = cc.Sprite:create(battle.MainAreaRes.diZzl)

	var_1_0:addTo(arg_1_0.hpSumLabel, -100):anchorPoint(0.5, 0.5)

	arg_1_0.hpDiWidth = var_1_0:width()
	arg_1_0.showSwitch = {
		showNumber = true
	}
	arg_1_0.roundLabelNode = arg_1_0.parent.UIWidgetMid:get("widgetPanel.topinfo.round")
	arg_1_0.hits = {}

	for iter_1_1 = 1, battlePlay.Gate.ObjectNumber do
		local var_1_1 = ccui.Layout:create()

		var_1_1:setTag(iter_1_1)
		var_1_1:setName("hitPanel" .. iter_1_1)
		var_1_1:setAnchorPoint(cc.p(0.5, 0.5))
		arg_1_0.parent.layer:add(var_1_1, 101)
		var_1_1:setContentSize(cc.size(300, 300))
		var_1_1:setVisible(false)

		var_1_1.showAttrPanelFlag = true
		var_1_1.canChooseObjFlag = false

		var_1_1:onClick(function()
			local var_2_0 = iter_1_1
			local var_2_1 = arg_1_0:call("getSceneObjBySeat", var_2_0)

			if var_2_1 and not var_2_1.model:isDeath() then
				if var_1_1.showAttrPanelFlag and false then
					arg_1_0.parent.objAttrPanel:showPanel(var_2_1)
				elseif var_1_1.canChooseObjFlag then
					arg_1_0:notify("selectObj", var_2_1)
				end
			end
		end)

		arg_1_0.hits[iter_1_1] = var_1_1
	end

	local var_1_2 = arg_1_0.parent:isPVPScene()

	if arg_1_0.parent:isPVEScene() then
		var_1_2 = false

		if arg_1_0.parent:isBossScene() then
			arg_1_0.roundLabelNode:hide()
		end
	elseif arg_1_0.parent:isPVPScene() and arg_1_0.parent:isSepcPVPScene() then
		var_1_2 = false
	end

	if var_1_2 then
		local var_1_3 = arg_1_0.parent.data

		var_1_3.names = var_1_3.names or {
			"leftPlayer",
			"rightPlayer"
		}
		var_1_3.levels = var_1_3.levels or {
			99,
			99
		}
		var_1_3.logos = var_1_3.logos or {
			1,
			1
		}

		local var_1_4 = arg_1_0.parent.UIWidgetLeft:get("infoPVP")
		local var_1_5 = arg_1_0.parent.UIWidgetRight:get("infoPVP")

		var_1_4:get("roleName"):setString(var_1_3.names[1] or "leftPlayer")
		var_1_4:get("level"):setString(var_1_3.levels[1] or 99)
		var_1_4:get("roleImg"):loadTexture(dataEasy.getRoleLogoIcon(var_1_3.logos[1]))
		var_1_5:get("roleName"):setString(var_1_3.names[2] or "rightPlayer")
		var_1_5:get("level"):setString(var_1_3.levels[2] or 99)
		var_1_5:get("roleImg"):loadTexture(dataEasy.getRoleLogoIcon(var_1_3.logos[2]))
		arg_1_0.parent.UIWidgetLeft:show()
		arg_1_0.parent.UIWidgetRight:show()
	end

	arg_1_0.explorerShowList = {
		{},
		[-1] = {}
	}
	arg_1_0.showNumberCnt = 0
end

local function var_0_5(arg_3_0)
	arg_3_0.lastBuffPos = {}
	arg_3_0.lastBuffCount = 0
end

function var_0_4.refreshInfoPvP(arg_4_0, arg_4_1)
	if arg_4_0.renderLeftSpr and arg_4_0.renderRightSpr then
		arg_4_0.renderLeftSpr:refresh()
		arg_4_0.renderRightSpr:refresh()
	end
end

function var_0_4.getObjHitPanel(arg_5_0, arg_5_1)
	return arg_5_0.hits[arg_5_1]
end

function var_0_4.onPlayMainSkillEffect(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0:call("getSceneObjBySeat", arg_6_1)

	if var_6_0 then
		var_6_0:playMainSkillEffect()
	end
end

function var_0_4.onSelectSkill(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_1.id
	local var_7_1 = arg_7_1:getTargetsHint()
	local var_7_2 = csv.skill[var_7_0].skillProcess[1]
	local var_7_3 = csv.skill_process[var_7_2].targetType
	local var_7_4 = {}

	for iter_7_0, iter_7_1 in ipairs(var_7_1) do
		var_7_4[iter_7_1.seat] = true
	end

	arg_7_0:hideSkillTargetsHelpTips()

	local var_7_5 = arg_7_0:call("getSceneObjs")

	for iter_7_2, iter_7_3 in pairs(var_7_5) do
		local var_7_6 = iter_7_3.model
		local var_7_7 = var_7_6.seat
		local var_7_8 = arg_7_0.hits[var_7_7]

		if var_7_8 then
			var_7_8.showAttrPanelFlag = false

			if var_7_4[var_7_7] then
				local var_7_9 = skillHelper.natureRestraintType(arg_7_1:getSkillNatureType(), var_7_6, arg_7_1.owner:natureRestraint(), iter_7_3.model:natureResistance())

				iter_7_3:showSkillSelectTextState(var_7_3, var_7_9, arg_7_2[var_7_6.id])

				var_7_8.canChooseObjFlag = true
			else
				var_7_8.canChooseObjFlag = false
			end
		end
	end
end

function var_0_4.onSelectedHero(arg_8_0)
	local var_8_0 = arg_8_0:call("getSceneObjs")

	for iter_8_0, iter_8_1 in pairs(var_8_0) do
		local var_8_1 = iter_8_1.model.seat
		local var_8_2 = arg_8_0.hits[var_8_1]

		if var_8_2 then
			var_8_2.showAttrPanelFlag = false
			var_8_2.canChooseObjFlag = false
		end
	end

	arg_8_0:hideSkillTargetsHelpTips()
end

function var_0_4.resetHitPanelStateToShowAttrsPanel(arg_9_0)
	local var_9_0 = arg_9_0:call("getSceneObjs")

	for iter_9_0, iter_9_1 in pairs(var_9_0) do
		local var_9_1 = iter_9_1.model.seat
		local var_9_2 = arg_9_0.hits[var_9_1]

		if var_9_2 then
			var_9_2.showAttrPanelFlag = true
			var_9_2.canChooseObjFlag = false
		end
	end

	arg_9_0:hideSkillTargetsHelpTips()
end

function var_0_4.onHideAllObjsSkillTips(arg_10_0)
	if arg_10_0.enterShowCb then
		arg_10_0.enterShowCb()
	end

	local var_10_0 = arg_10_0:call("getSceneObjs")

	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		iter_10_1.natureQuan:setVisible(false)
		iter_10_1.groundRing:setVisible(false)
	end
end

function var_0_4.hideSkillTargetsHelpTips(arg_11_0)
	local var_11_0 = arg_11_0:call("getSceneObjs")

	for iter_11_0, iter_11_1 in pairs(var_11_0) do
		iter_11_1.natureQuan:setVisible(false)
	end
end

function var_0_4.onShowSkillName(arg_12_0, arg_12_1)
	local var_12_0 = csv.skill[arg_12_1].skillName
end

function var_0_4.onSetWaveNumber(arg_13_0, arg_13_1, arg_13_2)
	arg_13_0.parent.UIWidgetMid:get("widgetPanel.wavePanel.wave"):setString(var_0_3(gLanguageCsv.theWave, arg_13_1 or 1, arg_13_2 or 1))
end

function var_0_4.onSetTeamNumber(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0.parent.UIWidgetGroupLeft:get("txt")
	local var_14_1 = arg_14_0.parent.UIWidgetGroupRight:get("txt")

	if arg_14_1 == 1 then
		var_14_0:text(gLanguageCsv.firstTeam)
		var_14_1:text(gLanguageCsv.firstTeam)
	else
		if arg_14_2 == 1 or arg_14_2 == 3 then
			var_14_0:text(gLanguageCsv.secondTeam)
		end

		if arg_14_2 == 2 or arg_14_2 == 3 then
			var_14_1:text(gLanguageCsv.secondTeam)
		end
	end
end

function var_0_4.onSetGymNumber(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0.parent.UIWidgetGroupLeft:get("txt")
	local var_15_1 = arg_15_0.parent.UIWidgetGroupRight:get("txt")

	var_15_0:text(var_0_1[arg_15_1] or tostring(arg_15_1))
	var_15_1:text(var_0_1[arg_15_2] or tostring(arg_15_2))
end

function var_0_4.onPlayWaveAni(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = CSprite.new("battlearena/battle_zidong.skel")

	var_16_0:xy(display.cx, display.cy)
	var_16_0:play("boci" .. arg_16_1)
	var_16_0:addTo(arg_16_0.parent.layer, 999, "waveAni"):scale(2)
end

function var_0_4.setRoundNumber(arg_17_0, arg_17_1, arg_17_2)
	arg_17_1 = math.max(math.min(arg_17_1, arg_17_2), 0)

	arg_17_0.roundLabelNode:get("round"):setString(arg_17_1)
end

function var_0_4.onNewBattleRound(arg_18_0, arg_18_1)
	var_0_5(arg_18_0)
	arg_18_0:onShowMain(true)
	arg_18_0:showSKillUIWidgets(not arg_18_1.isTurnAutoFight)

	local var_18_0 = arg_18_0.parent:getPlayModel()

	arg_18_0:setRoundNumber(arg_18_1.curRound, var_18_0.roundLimit)
	arg_18_0:onHideAllObjsSkillTips()

	if not arg_18_0.isFirstEnter then
		arg_18_0:notify("showHero", {
			typ = "showAll",
			obj = tostring(arg_18_1.obj)
		})
	else
		arg_18_0.firstBattleObj = arg_18_1.obj
	end

	for iter_18_0, iter_18_1 in pairs(arg_18_0.hits) do
		iter_18_1.showAttrPanelFlag = true
		iter_18_1.canChooseObjFlag = false
	end
end

function var_0_4.onObjMainSkill(arg_19_0)
	for iter_19_0, iter_19_1 in pairs(arg_19_0.hits) do
		iter_19_1.showAttrPanelFlag = false
	end
end

function var_0_4.onShowMain(arg_20_0, arg_20_1)
	arg_20_0.parent.UIWidgetLeft:setVisible(arg_20_1)
	arg_20_0.parent.UIWidgetRight:setVisible(arg_20_1)
	arg_20_0.parent.UIWidgetMid:get("widgetPanel"):setVisible(arg_20_1)
	arg_20_0.parent.UIWidgetBottomRight:setVisible(arg_20_1)

	local var_20_0 = arg_20_0.parent.data

	if var_20_0.gateType == game.GATE_TYPE.crossArena or var_20_0.gateType == game.GATE_TYPE.crossMine or arg_20_0.parent:getGymDeployType() == game.DEPLOY_TYPE.WheelType then
		arg_20_0.parent.UIWidgetGroupLeft:setVisible(arg_20_1)
		arg_20_0.parent.UIWidgetGroupRight:setVisible(arg_20_1)
	end

	for iter_20_0, iter_20_1 in pairs(arg_20_0.parent.buffEffectsToHide) do
		if type(iter_20_1.setVisible) == "function" then
			iter_20_1:setVisible(arg_20_1)
		end
	end
end

function var_0_4.onSetUltAccEnable(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0.parent.inUltAcc

	arg_21_0.parent.ultAccEnable = arg_21_1

	if var_21_0 and not arg_21_1 then
		arg_21_0.parent:handleOperation(battle.OperateTable.ultAccEnd)
	end
end

function var_0_4.showSKillUIWidgets(arg_22_0, arg_22_1)
	arg_22_0.parent.UIWidgetBottomRight:setVisible(arg_22_1)
end

function var_0_4.onShowNumber(arg_23_0, arg_23_1)
	local function var_23_0(arg_24_0)
		if arg_24_0 and arg_24_0 ~= arg_23_0.showNumberCnt then
			return
		end

		if arg_23_0.showSwitch.showNumber then
			return
		end

		if arg_23_0.sumSprite then
			arg_23_0.sumSprite:hide()

			arg_23_0.sumSprite = nil
		end

		if arg_23_0.sumLabel then
			arg_23_0.sumLabel:hide():unscheduleUpdate()

			arg_23_0.sumLabel = nil
		end

		arg_23_0.preNumber = 0
		arg_23_0.sumNumber = 0
		arg_23_0.showNumberType = nil
		arg_23_0.showSwitch.showNumber = true
	end

	if not arg_23_0.showSwitch.showNumber then
		arg_23_0.showNumberCnt = arg_23_0.showNumberCnt + 1

		var_23_0()
	end

	if arg_23_1.close then
		arg_23_0.showSwitch.showNumber = false

		transition.executeSequence(arg_23_0.parent.effectLayer):delay(1.5):func(functools.partial(var_23_0, arg_23_0.showNumberCnt)):done()

		return
	end

	arg_23_0.sumNumber = arg_23_0.sumNumber + (arg_23_1.delta or 0)

	if not (not arg_23_0.sumSprite or arg_23_0.showNumberType ~= arg_23_1.typ) then
		return
	end

	arg_23_0.damangeSumSprite:hide()
	arg_23_0.hpSumSprite:hide()
	arg_23_0.damageSumLabel:hide():unscheduleUpdate()
	arg_23_0.hpSumLabel:hide():unscheduleUpdate()

	if arg_23_1.typ == battle.SkillSegType.damage then
		arg_23_0.sumSprite = arg_23_0.damangeSumSprite
		arg_23_0.sumLabel = arg_23_0.damageSumLabel
	elseif arg_23_1.typ == battle.SkillSegType.resumeHp then
		arg_23_0.sumSprite = arg_23_0.hpSumSprite
		arg_23_0.sumLabel = arg_23_0.hpSumLabel
	end

	local function var_23_1(arg_25_0)
		local var_25_0 = arg_23_0.preNumber
		local var_25_1 = arg_23_0.sumNumber
		local var_25_2 = math.floor((var_25_1 - var_25_0) * arg_25_0 * 10 + 1)

		arg_23_0.sumLabelNum:set(var_25_0)

		arg_23_0.preNumber = math.min(var_25_0 + var_25_2, var_25_1)
	end

	assert(arg_23_0.sumSprite, string.format("type %s is error", arg_23_1.typ))
	arg_23_0.sumSprite:show()
	arg_23_0.sumLabelNum:set(0)
	arg_23_0.sumLabel:show():scheduleUpdate(var_23_1)

	arg_23_0.showNumberType = arg_23_1.typ
	arg_23_0.preNumber = 0
	arg_23_0.sumNumber = arg_23_1.delta or 0

	local var_23_2 = 0
	local var_23_3 = arg_23_0.sumSprite:width()
	local var_23_4 = csv.skill[arg_23_1.skillId].hurtPos
	local var_23_5 = display.cx + var_23_4.x
	local var_23_6 = display.cy / 4 + var_23_4.y

	if arg_23_1.typ == battle.SkillSegType.damage then
		local var_23_7 = 320
		local var_23_8 = 370
		local var_23_9 = arg_23_0.sumLabel.panel:width()
		local var_23_10 = var_23_8 / 2

		if var_23_8 < var_23_9 then
			var_23_10 = var_23_9 / 2
		end

		arg_23_0.sumLabel:xy(var_23_5 - var_23_3 / 2 + var_23_7 + var_23_10, var_23_6 - 20 + var_23_2)
		arg_23_0.sumSprite:xy(var_23_5 + var_23_3 / 2, var_23_6 + var_23_2)
	elseif arg_23_1.typ == battle.SkillSegType.resumeHp then
		local var_23_11 = arg_23_0.hpDiWidth
		local var_23_12 = arg_23_0.sumLabel.panel:width()
		local var_23_13 = var_23_11 / 2

		if var_23_11 < var_23_12 then
			var_23_13 = var_23_12 / 2
		end

		arg_23_0.sumLabel:xy(var_23_5 + var_23_13, var_23_6 - 15 + var_23_2)
		arg_23_0.sumSprite:xy(var_23_5, var_23_6 + var_23_2)
	end
end

function var_0_4.onShowMP1Award(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0:call("getSceneObj", arg_26_1.key)

	if not var_26_0 then
		return
	end

	local var_26_1 = var_26_0.seat

	arg_26_0.mp1AwardCount[var_26_1] = arg_26_0.mp1AwardCount[var_26_1] + 1

	local var_26_2 = cc.Sprite:create(battle.MainAreaRes.txtNqz)
	local var_26_3 = cc.LabelAtlas:create(arg_26_1.mp, battle.MainAreaRes.fontNqz, 34, 43, string.byte("0"))
	local var_26_4, var_26_5 = var_26_0:getCurPos()
	local var_26_6 = cc.pAdd(cc.p(var_26_4, var_26_5), var_26_0.unitCfg.everyPos.headPos)

	var_26_3:z(999):xy(cc.p(var_26_2:width() / 2, var_26_2:height())):anchorPoint(0.5, 0)
	var_26_2:z(999):xy(var_26_6):hide()
	var_26_2:add(var_26_3)
	arg_26_0.parent.effectLayer:add(var_26_2)
	transition.executeSequence(arg_26_0.parent.effectLayer):delay((arg_26_0.mp1AwardCount[var_26_1] - 1) * 0.6):func(function()
		var_26_2:show()
	end):delay(0.2):func(function()
		transition.moveBy(var_26_2, {
			time = 0.8,
			x = 5,
			y = 30
		})
	end):delay(0.8):func(function()
		var_26_2:removeSelf()

		arg_26_0.mp1AwardCount[var_26_1] = arg_26_0.mp1AwardCount[var_26_1] - 1
	end):done()
end

local var_0_6 = {
	[0] = function(arg_30_0, arg_30_1, arg_30_2)
		local var_30_0, var_30_1 = arg_30_0:getCurPos()

		return cc.pAdd(cc.p(var_30_0, var_30_1), arg_30_2), arg_30_0.faceTo
	end,
	function(arg_31_0, arg_31_1, arg_31_2)
		local var_31_0, var_31_1 = arg_31_0:getCurPos()
		local var_31_2 = cc.pAdd(arg_31_0.unitCfg.everyPos.headPos, arg_31_2)

		return cc.pAdd(cc.p(var_31_0, var_31_1), var_31_2), arg_31_0:getScaleX() * arg_31_0.faceTo
	end,
	function(arg_32_0, arg_32_1, arg_32_2)
		local var_32_0, var_32_1 = arg_32_0:getCurPos()
		local var_32_2 = cc.pAdd(arg_32_0.unitCfg.everyPos.hitPos, arg_32_2)

		return cc.pAdd(cc.p(var_32_0, var_32_1), var_32_2), arg_32_0:getScaleX() * arg_32_0.faceTo
	end,
	function(arg_33_0, arg_33_1, arg_33_2)
		arg_33_1:setPosition(display.center)

		local var_33_0, var_33_1 = arg_33_1:getPosition()

		return cc.pAdd(cc.p(var_33_0, var_33_1), arg_33_2), 1
	end,
	function(arg_34_0, arg_34_1, arg_34_2)
		local var_34_0, var_34_1 = arg_34_0:getSelfPos()

		return cc.pAdd(cc.p(var_34_0, var_34_1), arg_34_2), arg_34_0.faceTo
	end,
	function(arg_35_0, arg_35_1, arg_35_2)
		local var_35_0 = (battle.StandingPos[2].x + battle.StandingPos[5].x) / 2

		var_35_0 = arg_35_0.force == 1 and var_35_0 or display.width - var_35_0

		return cc.pAdd(cc.p(var_35_0, battle.StandingPos[2].y), arg_35_2), arg_35_0.faceTo
	end,
	function(arg_36_0, arg_36_1, arg_36_2)
		local var_36_0 = (battle.StandingPos[2].x + battle.StandingPos[5].x) / 2

		var_36_0 = arg_36_0.force == 1 and display.width - var_36_0 or var_36_0

		return cc.pAdd(cc.p(var_36_0, battle.StandingPos[2].y), arg_36_2), arg_36_0.faceTo
	end
}

function var_0_4.onBuffPlayOnceEffect(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5, arg_37_6, arg_37_7)
	if not arg_37_2 or arg_37_2 == "" then
		return
	end

	local var_37_0 = arg_37_0:call("getSceneObj", arg_37_1)

	if not var_37_0 then
		return
	end

	local var_37_1 = newCSprite(arg_37_2)

	if not var_37_1 then
		return
	end

	local var_37_2 = arg_37_0.parent.effectLayer

	if arg_37_6 then
		local var_37_3 = var_0_0[arg_37_6]

		if var_37_3 then
			var_37_2 = arg_37_0.parent[var_37_3]
		end
	end

	var_37_2:addChild(var_37_1, 9999)
	var_37_1:setSpriteEventHandler(function(arg_38_0, arg_38_1)
		if arg_38_0 == sp.EventType.ANIMATION_COMPLETE then
			if arg_37_7 then
				arg_37_0.parent.onceEffectWaitCount = arg_37_0.parent.onceEffectWaitCount - 1
			end

			removeCSprite(var_37_1)
		end
	end)

	local var_37_4 = arg_37_3 or "effect"
	local var_37_5 = var_37_1:play(var_37_4)

	arg_37_7 = arg_37_7 and var_37_5

	if arg_37_7 then
		arg_37_0.parent.onceEffectWaitCount = arg_37_0.parent.onceEffectWaitCount + 1
	end

	if var_37_0.force == 2 then
		arg_37_5 = cc.p(-arg_37_5.x, arg_37_5.y)
	end

	local var_37_6, var_37_7 = var_0_6[arg_37_4](var_37_0, var_37_1, arg_37_5)

	var_37_1:setPosition(var_37_6):scale(2)
	var_37_1:setScaleX(2 * var_37_7)
end

function var_0_4.onEnterAnimation(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	function arg_39_0.enterShowCb()
		if arg_39_1 or arg_39_2 then
			arg_39_0:notify("showHero", {
				typ = "showAll",
				obj = tostring(arg_39_0.firstBattleObj)
			})

			arg_39_0.isFirstEnter = nil
		end

		arg_39_0.enterShowCb = nil
	end

	local function var_39_0(arg_41_0, arg_41_1, arg_41_2)
		local var_41_0 = newCSprite("ruchang/ruchang.skel")

		var_41_0:setScaleX(2 * arg_41_0)
		var_41_0:setScaleY(2)
		arg_39_0.parent.frontStageLayer:add(var_41_0)
		transition.executeSequence(var_41_0):delay(0.05):func(function()
			var_41_0:xy(display.cx + arg_41_1, display.cy + arg_41_2):play("changjing_1")
		end):delay(1.7):func(function()
			removeCSprite(var_41_0, false)
		end):done()
	end

	local function var_39_1(arg_44_0)
		if (not arg_39_1 or arg_44_0 ~= 1) and (not arg_39_2 or arg_44_0 ~= -1) then
			return
		end

		local var_44_0

		if arg_44_0 == 1 then
			var_44_0 = arg_39_1
		else
			var_44_0 = arg_39_2
		end

		var_44_0 = var_44_0 or {}

		local var_44_1 = battle.StandingPos

		for iter_44_0, iter_44_1 in pairs(var_44_0) do
			local var_44_2 = arg_39_0:call("getSceneObjById", iter_44_1)

			if var_44_2 then
				local var_44_3, var_44_4 = var_44_2:getSelfPos()
				local var_44_5 = var_44_3 - (arg_44_0 == 1 and var_44_1[2].x + 150 or display.width - var_44_1[2].x - 150)
				local var_44_6 = var_44_4 - var_44_1[2].y - 100

				var_39_0(arg_44_0, var_44_5, var_44_6)
			end
		end
	end

	var_39_1(1)
	var_39_1(-1)

	local var_39_2

	if arg_39_3 then
		var_39_2 = arg_39_0.parent:onEventEffectQueue("wait")
	end

	transition.executeSequence(arg_39_0.parent.frontStageLayer):delay(0.8):func(function()
		if arg_39_0.enterShowCb then
			arg_39_0.enterShowCb()
		end

		if var_39_2 then
			var_39_2:stop()
		end
	end):done()
end

function var_0_4.onFightStart(arg_46_0)
	battleEasy.queueEffect("delay", {
		lifetime = 800
	})

	local var_46_0 = widget.addAnimationByKey(arg_46_0.parent.frontStageLayer, "battlearena/battlearena_effect.skel", "startgame", "zhandoukaishi", 1):xy(display.cx, 0):scale(2)

	transition.executeSequence(var_46_0):delay(1.3):func(function()
		removeCSprite(var_46_0, false)
	end):done()
	battleEasy.queueEffect("delay", {
		lifetime = 300
	})
end

function var_0_4.onFightOver(arg_48_0)
	local var_48_0 = widget.addAnimationByKey(arg_48_0.parent.effectLayerLower, "battlearena/battlearena_effect.skel", "endgame", "zhandoujieshu", 1):xy(display.cx, 0):scale(2)

	transition.executeSequence(var_48_0):delay(2):func(function()
		removeCSprite(var_48_0, false)
	end):done()
end

function var_0_4.onQueueExplorer(arg_50_0, arg_50_1, arg_50_2)
	if not itertools.include(arg_50_0.explorerShowList[arg_50_1], arg_50_2) then
		table.insert(arg_50_0.explorerShowList[arg_50_1], arg_50_2)
	end
end

function var_0_4.showExplorer(arg_51_0, arg_51_1, arg_51_2)
	if not next(arg_51_2) then
		return
	end

	local var_51_0 = cc.size(615, 137)
	local var_51_1 = ccui.Layout:create():z(1099):size(615, 137):xy(display.center)
	local var_51_2 = ccui.Layout:create():size(615, 137):z(2):addTo(var_51_1, 2)
	local var_51_3 = {}

	for iter_51_0 = 1, table.length(arg_51_2) do
		local var_51_4 = ccui.ImageView:create(arg_51_2[iter_51_0]):xy((-700 - iter_51_0 * 120) * arg_51_1, 160):scale(1.6 * -arg_51_1, 1.6):z(2):addTo(var_51_2)

		var_0_2(var_51_3, var_51_4)
	end

	local var_51_5 = "tanxianqi/tanxianqi_skill.skel"
	local var_51_6 = newCSprite(var_51_5)

	if not var_51_6 then
		return
	end

	var_51_6:xy(cc.p(0, -20)):scale(1.2 * arg_51_1, 1.2):addTo(var_51_1, 1):play("bot_effect")

	local var_51_7 = newCSprite(var_51_5)

	if not var_51_7 then
		return
	end

	var_51_7:xy(cc.p(0, -20)):scale(1.2 * arg_51_1, 1.2):addTo(var_51_1, 3):play("top_effect")

	local function var_51_8(arg_52_0, arg_52_1, arg_52_2)
		local var_52_0 = transition.executeSequence(arg_52_0):delay(0.3 + 0.05 * arg_52_1):easeBegin("EXPONENTIALOUT"):moveBy(1.2, 450 * arg_51_1, 0):easeEnd():func(function()
			transition.executeSpawn(arg_52_0):easeBegin("EXPONENTIALOUT"):moveBy(1, 250 * arg_51_1, 0):fadeTo(1, 0.25):easeEnd():done()
		end)

		if arg_52_2 then
			var_52_0:delay(0.3)
			var_52_0:func(function()
				var_51_1:removeFromParent()
			end)
		end

		var_52_0:done()
	end

	for iter_51_1, iter_51_2 in ipairs(var_51_3) do
		var_51_8(iter_51_2, iter_51_1, iter_51_1 == table.length(var_51_3))
	end

	var_51_1:xy(var_51_1:x() - arg_51_1 * (display.uiOrigin.x + 500), 800):addTo(arg_51_0.parent.effectLayer)
end

function var_0_4.onPlayExplorer(arg_55_0)
	local function var_55_0(arg_56_0)
		local var_56_0 = arg_55_0.explorerShowList[arg_56_0]

		arg_55_0:showExplorer(arg_56_0, var_56_0)

		arg_55_0.explorerShowList[arg_56_0] = {}
	end

	var_55_0(1)
	var_55_0(-1)
end

local var_0_7 = {}

var_0_7.RESOURCE_FILENAME = "battle_vs_pvp.json"
var_0_7.RESOURCE_BINDING = {
	item2 = "item2",
	rightMask = "rightMask",
	leftMask = "leftMask",
	item = "item"
}

function var_0_4.onShowVsPvpView(arg_57_0, arg_57_1)
	local var_57_0 = gGameUI:createSimpleView(var_0_7, arg_57_0.parent.frontStageLayer):init()

	var_57_0:z(100)

	local var_57_1 = var_57_0.leftMask:size()

	var_57_0.leftMask:hide():size(0, var_57_1.height)
	var_57_0.rightMask:hide():size(0, var_57_1.height)
	var_57_0.leftMask:setClippingEnabled(true)
	var_57_0.rightMask:setClippingEnabled(true)

	local var_57_2 = widget.addAnimationByKey(arg_57_0.parent.frontStageLayer, "effect/jiemian_vs.skel", "ani", "effect", 1):scale(2):xy(display.cx, display.cy)

	var_57_2:getAni():setTwoColorTint(true)
	performWithDelay(arg_57_0.parent.frontStageLayer, function()
		var_57_2:play("effect")
		var_57_2:addPlay("effect2")
	end, 0.1)

	local var_57_3 = arg_57_0.parent.data.figures
	local var_57_4 = arg_57_0.parent.data.names
	local var_57_5 = arg_57_0.parent:getPlayModel()

	local function var_57_6(arg_59_0, arg_59_1)
		if var_57_5.operateForce == 2 then
			return arg_59_0[battleEasy.mirrorSeat(arg_59_1)]
		end

		return arg_59_0[arg_59_1]
	end

	local var_57_7 = {}

	for iter_57_0 = 1, var_57_5.ForceNumber do
		if arg_57_0.parent.data.multipGroup then
			var_57_7[iter_57_0] = var_57_6(arg_57_0.parent.data.roleOut[1][1], iter_57_0)
			var_57_7[iter_57_0 + 6] = var_57_6(arg_57_0.parent.data.roleOut[2][1], iter_57_0 + 6)
		else
			var_57_7[iter_57_0] = var_57_6(arg_57_0.parent.data.roleOut, iter_57_0)
			var_57_7[iter_57_0 + 6] = var_57_6(arg_57_0.parent.data.roleOut, iter_57_0 + 6)
		end
	end

	local var_57_8 = var_57_0.item

	if arg_57_1 == 3 then
		var_57_8 = var_57_0.item2
	end

	var_57_8:hide()

	local var_57_9 = var_57_8:width()
	local var_57_10 = var_57_8:size().height

	local function var_57_11(arg_60_0, arg_60_1)
		local var_60_0 = gRoleFigureCsv[var_57_3[arg_60_1]] or {}

		arg_60_0:get("role"):texture("common/btn/kong.png")

		if arg_60_0:get("role"):get("role") then
			arg_60_0:get("role"):removeChildByName("role")
		end

		widget.addAnimationByKey(arg_60_0:get("role"), var_60_0.resSpine, "role", "standby_loop", 999):scale(0.5)
		arg_60_0:get("role"):y(arg_60_0:get("role"):y() - 308)

		local var_60_1 = var_60_0.actPos.x

		if arg_60_1 == 2 then
			var_60_1 = -var_60_1
		end

		arg_60_0:get("role"):x(arg_60_0:get("role"):x() + var_60_1)
		arg_60_0:get("role"):y(arg_60_0:get("role"):y() + var_60_0.actPos.y)
		arg_60_0:get("name.text"):text(var_57_4[arg_60_1])
	end

	local function var_57_12(arg_61_0, arg_61_1)
		local var_61_0 = 0
		local var_61_1 = 300
		local var_61_2 = 370
		local var_61_3 = 1

		if arg_61_1 == 2 then
			var_61_0 = 6
			var_61_1 = 900
			var_61_3 = -1
		end

		for iter_61_0 = 1, 6 do
			local var_61_4, var_61_5 = mathEasy.getRowCol(iter_61_0, 3)
			local var_61_6 = var_61_1 + 200 * var_61_3 * (var_61_5 - 1) + 100 * var_61_3 * (var_61_4 - 1)
			local var_61_7 = var_61_2 - 200 * (var_61_4 - 1)
			local var_61_8 = var_57_8:clone():xy(var_61_6, var_61_7):show():addTo(arg_61_0:get("cards"), 5)
			local var_61_9 = var_57_7[iter_61_0 + var_61_0]

			if var_61_9 then
				var_61_8:get("empty"):hide()
				bind.extend(var_57_0, var_61_8, {
					class = "card_icon",
					props = {
						unitId = var_61_9.roleId,
						advance = var_61_9.advance,
						star = var_61_9.star,
						rarity = csv.unit[var_61_9.roleId].rarity,
						levelProps = {
							data = var_61_9.level
						},
						onNode = function(arg_62_0)
							if arg_61_1 == 2 then
								arg_62_0:get("icon"):setFlippedX(true)
							end
						end
					}
				})
			end
		end
	end

	local function var_57_13(arg_63_0, arg_63_1)
		local var_63_0 = 1

		if arg_63_1 == 2 then
			var_63_0 = 7
		end

		local var_63_1 = arg_63_0:get("singleCard")
		local var_63_2 = var_57_7[var_63_0]
		local var_63_3 = csv.unit[var_63_2.roleId].cardIcon2

		var_63_1:texture(var_63_3)
	end

	local function var_57_14(arg_64_0, arg_64_1)
		local var_64_0 = {
			"battle/craft/opening/txt_1st_red.png",
			"battle/craft/opening/txt_2nd_red.png",
			"battle/craft/opening/txt_3rd_red.png",
			nil,
			nil,
			nil,
			"battle/craft/opening/txt_1st.png",
			"battle/craft/opening/txt_2nd.png",
			"battle/craft/opening/txt_3rd.png"
		}
		local var_64_1 = 0
		local var_64_2 = 360
		local var_64_3 = 320
		local var_64_4 = 1

		if arg_64_1 == 2 then
			var_64_1 = 6
		end

		for iter_64_0 = 1, 3 do
			local var_64_5 = var_64_2 + 200 * var_64_4 * (iter_64_0 - 1)
			local var_64_6 = var_64_3
			local var_64_7 = var_57_8:clone():xy(var_64_5, var_64_6):show():addTo(arg_64_0:get("cards"), 5)
			local var_64_8 = var_57_7[iter_64_0 + var_64_1]

			if var_64_8 then
				var_64_7:get("icon"):get("empty"):hide()
				bind.extend(var_57_0, var_64_7:get("icon"), {
					class = "card_icon",
					props = {
						unitId = var_64_8.roleId,
						advance = var_64_8.advance,
						star = var_64_8.star,
						rarity = csv.unit[var_64_8.roleId].rarity,
						levelProps = {
							data = var_64_8.level
						}
					}
				})
			end

			var_64_7:get("rank"):loadTexture(var_64_0[iter_64_0 + var_64_1])
		end
	end

	local function var_57_15(arg_65_0, arg_65_1)
		if arg_65_1 == 2 then
			arg_65_0:get("singleCard"):show()
			arg_65_0:get("cards"):hide()
		else
			arg_65_0:get("singleCard"):hide()
			arg_65_0:get("cards"):show()
		end
	end

	local var_57_16 = var_57_0.leftMask:get("infoPanel")
	local var_57_17 = var_57_0.rightMask:get("infoPanel")

	var_57_15(var_57_16, arg_57_1)
	var_57_15(var_57_17, arg_57_1)
	var_57_11(var_57_16, 1)
	var_57_11(var_57_17, 2)

	if arg_57_1 == 1 then
		var_57_12(var_57_16, 1)
		var_57_12(var_57_17, 2)
	elseif arg_57_1 == 2 then
		var_57_13(var_57_16, 1)
		var_57_13(var_57_17, 2)
	elseif arg_57_1 == 3 then
		var_57_14(var_57_16, 1)
		var_57_14(var_57_17, 2)
	end

	local var_57_18 = var_57_16:y()
	local var_57_19 = var_57_17:y()
	local var_57_20 = 1.2
	local var_57_21 = 0.4
	local var_57_22 = 0.01
	local var_57_23 = var_57_1.width / (var_57_21 / var_57_22)
	local var_57_24 = 0
	local var_57_25 = 0
	local var_57_26 = arg_57_0.parent:onEventEffectQueue("wait")

	local function var_57_27()
		local var_66_0 = 0
		local var_66_1 = battle.UITag.pvpOpening

		arg_57_0.parent:enableSchedule():schedule(function()
			var_66_0 = var_66_0 + var_57_23
			var_57_24 = var_57_24 + var_57_22

			if var_66_0 > var_57_1.width then
				if var_57_24 > 2 and var_57_25 >= 4 then
					arg_57_0.parent:enableSchedule():unSchedule(var_66_1)
					var_57_2:removeSelf()
					var_57_0:onClose()
					var_57_26:stop()
				end
			else
				var_57_0.leftMask:size(var_66_0, var_57_1.height)
				var_57_0.rightMask:size(var_66_0, var_57_1.height)
				var_57_16:xy(var_66_0 / 2, var_57_18)
				var_57_17:xy(var_66_0 / 2, var_57_19)
			end
		end, var_57_22, 0, var_66_1)
	end

	local var_57_28 = 50
	local var_57_29 = 6
	local var_57_30 = 185
	local var_57_31 = 320
	local var_57_32 = 320
	local var_57_33 = 150

	local function var_57_34(arg_68_0, arg_68_1, arg_68_2)
		local var_68_0 = arg_68_1 and 1 or -1
		local var_68_1, var_68_2 = arg_68_0:xy()

		arg_68_0:xy(var_68_1, var_68_2 - var_57_28)

		local var_68_3, var_68_4 = arg_68_0:get("role"):xy()

		arg_68_0:get("role"):xy(var_68_3 + var_68_0 * var_57_30, var_68_4 - var_57_31)

		local var_68_5, var_68_6 = arg_68_0:get("name"):xy()

		arg_68_0:get("name"):xy(var_68_5 - var_68_0 * var_57_32, var_68_6)

		local var_68_7

		if arg_68_2 == 2 then
			var_68_7 = arg_68_0:get("singleCard")
		else
			var_68_7 = arg_68_0:get("cards")
		end

		local var_68_8, var_68_9 = var_68_7:xy()

		var_68_7:xy(var_68_8 + var_57_33, var_68_9)
	end

	var_57_34(var_57_16, true, arg_57_1)
	var_57_34(var_57_17, false, arg_57_1)

	local function var_57_35()
		var_57_25 = var_57_25 + 1
	end

	local function var_57_36()
		local function var_70_0(arg_71_0, arg_71_1)
			local var_71_0 = arg_71_1 and 1 or -1

			transition.executeSequence(arg_71_0):moveBy(0.83, 0, var_57_28 + var_57_29):moveBy(0.23, 0, -var_57_29):func(var_57_35):done()
			transition.moveBy(arg_71_0:get("role"), {
				time = 0.83,
				x = -var_71_0 * var_57_33,
				y = var_57_31
			})
			transition.executeSequence(arg_71_0:get("name")):delay(0.36):moveBy(0.6, var_71_0 * var_57_32, 0):func(var_57_35):done()

			local var_71_1

			if arg_57_1 == 2 then
				var_71_1 = arg_71_0:get("singleCard")
			else
				var_71_1 = arg_71_0:get("cards")
			end

			transition.moveBy(var_71_1, {
				time = 0.83,
				x = -var_57_33
			})
		end

		var_70_0(var_57_16, true)
		var_70_0(var_57_17)
	end

	transition.executeSequence(var_57_0.leftMask):delay(var_57_20):show():func(var_57_27):func(var_57_36):done()
	transition.executeSequence(var_57_0.rightMask):delay(var_57_20):show():done()
end

local var_0_8 = {}

var_0_8.RESOURCE_FILENAME = "battle_boss_come.json"
var_0_8.RESOURCE_BINDING = {}

function var_0_4.onShowBossComeView(arg_72_0, arg_72_1)
	local var_72_0 = gGameUI:createSimpleView(var_0_8, arg_72_0.parent.frontStageLayer):init()

	var_72_0:setLocalZOrder(99)

	local var_72_1 = arg_72_0.parent:onEventEffectQueue("wait")

	performWithDelay(var_72_0, function()
		var_72_0:setVisible(false)
		var_72_0:removeSelf()

		if arg_72_1 then
			gGameUI:createView("battle.boss_info", arg_72_0.parent.frontStageLayer):init(arg_72_0.parent, var_72_1):z(999)
		else
			var_72_1:stop()
		end
	end, 1)
end

return var_0_4
