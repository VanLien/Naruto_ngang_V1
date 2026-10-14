local var_0_0 = {
	level = "battle/logo_hero_level.png",
	level2 = "battle/logo_hero_level2.png"
}
local var_0_1 = {
	level = "battle/logo_enemy_level.png",
	level2 = "battle/logo_enemy_level2.png"
}
local var_0_2 = {
	radius = "battle/bar_enemy_white_radius.png",
	normal = "battle/bar_enemy_white.png"
}

globals.CLifeBar = class("CLifeBar", cc.Node)

function CLifeBar.ctor(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.model = arg_1_1

	arg_1_0:init(arg_1_2)
end

function CLifeBar.init(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_1.UIWidget:getResourceNode()

	if arg_2_0.model.force ~= 1 or not var_0_0 then
		local var_2_1 = var_0_1
	end

	local var_2_2 = arg_2_0.model.showLevel or arg_2_0.model.level

	arg_2_0.barPanel = (function(arg_3_0)
		local var_3_0 = var_2_0:get("hpBarPanel"):clone()
		local var_3_1 = var_3_0:get("di"):size()
		local var_3_2 = var_3_1.width / 2
		local var_3_3 = var_3_1.height / 2

		var_3_0:addTo(arg_2_0, 4):xy(-var_3_2, var_3_3)
		var_3_0:get("level"):setString(var_2_2)

		return var_3_0
	end)()

	local var_2_3 = arg_2_0.barPanel:get("di"):size()

	arg_2_0.buffAddFirstPos = cc.p(-var_2_3.width / 2 + 70, 55)

	local var_2_4 = arg_2_0.model.unitCfg

	arg_2_0:setPosition(var_2_4.everyPos.lifePos)
	arg_2_0:setScale(var_2_4.lifeScale)

	arg_2_0.canSetVisible = true
	arg_2_0.barCapture = CRenderSprite.newWithNodes(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444, arg_2_0.barPanel)

	arg_2_0.barCapture:addTo(arg_2_0, 5):coverTo(arg_2_0.barPanel):setCaptureOffest(cc.p(4, 10))

	arg_2_0.updateCount = 0
	arg_2_0.lastPer = {
		mpPer = 0,
		mpOverflowPer = 0,
		shieldPer = 0,
		hpPer = 0
	}

	arg_2_0.barPanel:get("shieldBar"):setPercent(0)
	arg_2_0.barPanel:get("hpBar"):setPercent(0)
	arg_2_0.barPanel:get("mpBar"):setPercent(0)
	arg_2_0.barPanel:get("mpOverflowBar"):setPercent(0)
end

local function var_0_3(arg_4_0)
	local var_4_0 = arg_4_0.hp
	local var_4_1 = arg_4_0.hpMax
	local var_4_2 = arg_4_0.shieldHp
	local var_4_3 = arg_4_0.delayHp
	local var_4_4 = arg_4_0.specialShieldHp
	local var_4_5 = var_4_2 - var_4_4
	local var_4_6 = 0
	local var_4_7 = 0
	local var_4_8 = 0
	local var_4_9 = var_4_1 < var_4_0 + var_4_2 and var_4_0 + var_4_2 or var_4_1
	local var_4_10 = math.min(var_4_0 / var_4_1 * 100, 10)
	local var_4_11 = cc.clampf(var_4_3, 0, var_4_0)
	local var_4_12 = var_4_0 / var_4_9 * 100
	local var_4_13 = (var_4_0 - var_4_11) / var_4_9 * 100

	if var_4_12 < var_4_10 then
		var_4_12 = var_4_10
		var_4_13 = (var_4_0 - var_4_11) / var_4_0 * var_4_10
	end

	local var_4_14 = var_4_4 > 0
	local var_4_15 = var_4_14 and (var_4_9 - var_4_0 - var_4_4) / var_4_9 * 100 or (var_4_0 + var_4_2) / var_4_9 * 100
	local var_4_16 = (var_4_9 - var_4_0 - var_4_2) / var_4_9 * 100

	arg_4_0.hpPer = var_4_13
	arg_4_0.shieldPer = var_4_15
	arg_4_0.shieldStatus = var_4_5 > 0
	arg_4_0.delayPer = var_4_12
	arg_4_0.delayStatus = var_4_11 > 0
	arg_4_0.specialShieldStatus = var_4_14
	arg_4_0.coverPer = var_4_16
	arg_4_0.coverStatus = var_4_4 > 0 and var_4_16 > 0
end

function CLifeBar.update(arg_5_0, arg_5_1)
	if arg_5_1.needCalc then
		var_0_3(arg_5_1)

		arg_5_0.specialShieldStatus = arg_5_1.specialShieldStatus
	end

	local var_5_0 = arg_5_1.hpPer
	local var_5_1 = arg_5_1.shieldPer
	local var_5_2 = arg_5_1.shieldStatus
	local var_5_3 = arg_5_1.delayPer
	local var_5_4 = arg_5_1.delayStatus
	local var_5_5 = arg_5_1.coverPer
	local var_5_6 = arg_5_1.coverStatus
	local var_5_7 = arg_5_0.barPanel

	local function var_5_8()
		arg_5_0.updateCount = arg_5_0.updateCount - 1

		if arg_5_0.updateCount > 0 then
			return
		end

		if not arg_5_0.specialShieldStatus then
			arg_5_0.barCapture:show()
		end
	end

	local function var_5_9(arg_7_0, arg_7_1)
		local var_7_0 = var_5_7:get(arg_7_0)
		local var_7_1 = var_7_0:visible()

		arg_7_1 = arg_7_1 or false

		if arg_7_1 ~= var_7_1 then
			var_7_0:visible(arg_7_1)

			arg_5_0.updateCount = arg_5_0.updateCount + 1

			performWithDelay(arg_5_0, var_5_8, 0)
		end
	end

	local function var_5_10(arg_8_0, arg_8_1, arg_8_2)
		if not arg_8_1 then
			return
		end

		local var_8_0 = math.ceil(arg_8_1)

		if arg_5_0.lastPer[arg_8_2] ~= var_8_0 then
			arg_5_0.lastPer[arg_8_2] = var_8_0
			arg_5_0.updateCount = arg_5_0.updateCount + 1

			transition.executeSequence(var_5_7:get(arg_8_0)):progressTo(0.1, arg_8_1):func(var_5_8):done()
		end
	end

	var_5_9("shieldBar", var_5_2)
	var_5_9("delayBar", var_5_4)
	var_5_10("hpBar", var_5_0, "hpPer")
	var_5_10("shieldBar", var_5_1, "shieldPer")
	var_5_10("delayBar", var_5_3, "delayPer")
	var_5_9("coverBar", var_5_6)
	var_5_10("coverBar", var_5_5, "coverPer")

	local var_5_11 = var_5_7:get("di"):size()
	local var_5_12 = var_5_11.width / 2
	local var_5_13 = var_5_11.height / 2

	if arg_5_0.specialShieldStatus then
		arg_5_0.barPanel:get("shieldBar"):setDirection(1)
		arg_5_0.barPanel:get("shieldBar"):loadTexture(var_0_2.radius)
		widget.addAnimationByKey(arg_5_0.barPanel, battle.SpriteRes.fireShield, "hpBarSprite", "xuetiao_loop", 1):xy(var_5_12 + 25, var_5_13 - 15):setScaleX(1.85):addPlay("xuetiao_loop")
	else
		arg_5_0.barPanel:get("shieldBar"):setDirection(0)
		arg_5_0.barPanel:get("shieldBar"):loadTexture(var_0_2.normal)
		arg_5_0.barPanel:removeChildByName("hpBarSprite")
	end

	if arg_5_1.mp then
		local var_5_14 = arg_5_1.mp
		local var_5_15 = arg_5_1.mpMax
		local var_5_16 = arg_5_1.mpOverflow
		local var_5_17 = 0
		local var_5_18 = 0
		local var_5_19 = arg_5_1.mp1OverflowData
		local var_5_20 = math.min(var_5_14 + var_5_16, var_5_15) / var_5_15 * 100
		local var_5_21 = math.min(var_5_16, var_5_15) / var_5_15 * 100
		local var_5_22 = (not var_5_19 or var_5_19 and var_5_19.mode ~= 1) and var_5_16 > 0
		local var_5_23 = var_5_14 / var_5_15 * 100

		var_5_9("mpOverflowBar", var_5_22)
		var_5_10("mpBar", var_5_20, "mpPer")

		if var_5_23 >= 100 then
			local var_5_24 = "xuetiao_mankuang_loop"

			if var_5_22 then
				var_5_7:get("mpBar"):setScaleY(1.5)
				var_5_7:get("mpOverflowBar"):setScaleY(1.5)

				var_5_24 = "xuetiao_mankuang2_loop"
			end

			widget.addAnimationByKey(arg_5_0, battle.SpriteRes.mainSkill, "mpBarSprite", "xuetiao_mankuang", 10):xy(var_5_12 - 110, var_5_13 - 103):addPlay(var_5_24)
		else
			var_5_7:get("mpBar"):setScaleY(1)
			var_5_7:get("mpOverflowBar"):setScaleY(1)
			arg_5_0:removeChildByName("mpBarSprite")
		end

		var_5_10("mpOverflowBar", var_5_21, "mpOverflowPer")

		if var_5_19 and var_5_19.mode == 1 then
			local var_5_25 = math.floor(var_5_19.limit / var_5_19.rate)
			local var_5_26 = math.floor(arg_5_1.mpOverflow / var_5_19.rate)
			local var_5_27 = var_5_7:get("mpBar"):size()
			local var_5_28, var_5_29 = var_5_7:get("mpBar"):xy()
			local var_5_30 = var_5_28 - var_5_27.width / 2
			local var_5_31 = cc.Node:create()

			arg_5_0:removeChildByName("mp1PointNode")
			arg_5_0:addChild(var_5_31, 10, "mp1PointNode")

			local var_5_32 = var_5_27.width / var_5_25

			var_5_26 = var_5_26 or 0

			for iter_5_0 = 1, math.max(var_5_26, var_5_25) do
				local var_5_33 = "kong_effect_loop"

				if iter_5_0 <= var_5_26 then
					var_5_33 = "jihuo_effect_loop"
				end

				widget.addAnimationByKey(var_5_31, "buff/nuqidian/nuqidian.skel", "mp1PointLimit" .. iter_5_0, var_5_33, 10):xy(var_5_32 * iter_5_0 - 72, var_5_29 + 8):scale(2)
			end
		else
			arg_5_0:removeChildByName("mp1PointNode")
		end
	end

	if arg_5_0.updateCount > 0 then
		arg_5_0.barCapture:hide()
	end
end

function CLifeBar.setVisibleEnable(arg_9_0, arg_9_1)
	arg_9_0.canSetVisible = arg_9_1
end

function CLifeBar.setVisible(arg_10_0, arg_10_1)
	if not arg_10_0.canSetVisible then
		return
	end

	cc.Node.setVisible(arg_10_0, arg_10_1)
end
