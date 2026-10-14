local var_0_0 = class("DebugArea", battleModule.CBase)

function var_0_0.ctor(arg_1_0, arg_1_1)
	battleModule.CBase.ctor(arg_1_0, arg_1_1)

	if EDITOR_ENABLE then
		arg_1_0:addPauseBtn()
		arg_1_0:addFrameControlBtn()
		arg_1_0:addEffectControlBtn()
		arg_1_0:addAutoTestDebug()
		arg_1_0:addDebugEnabled()
		arg_1_0:addFullManual()

		if arg_1_0.parent.gateType ~= game.GATE_TYPE.newbie and arg_1_0.parent.gateType ~= game.GATE_TYPE.test then
			arg_1_0:addEnterCity()
		end

		arg_1_0.backView = "city.view"
		arg_1_0.layer = cc.Layer:create()

		arg_1_0.parent.layer:add(arg_1_0.layer, 999)
		arg_1_0:addSpeedControlBtn()
		arg_1_0:addFrontBgBtn()
		arg_1_0:addBattleRecordBtn()
		arg_1_0:addBattleSpriteDebug()
		arg_1_0:addEffectDebug()
		arg_1_0:addTintColorDebug()
		arg_1_0:addCRenderTargetDebug()
		arg_1_0:addThreadDebug()
		arg_1_0:addSpineDebug()
		arg_1_0:addSpineTimeScaleDebug()
	end
end

local function var_0_1()
	local var_2_0 = {}
	local var_2_1 = "res/resources/battle/scene/"
	local var_2_2 = require("editor.fs").listAllFiles(var_2_1, function(arg_3_0)
		return arg_3_0:match("%.[jpg|png]")
	end, false)
	local var_2_3 = 0

	for iter_2_0, iter_2_1 in pairs(var_2_2) do
		local var_2_4

		while true do
			local var_2_5 = string.find(iter_2_0, "/")

			if not var_2_5 then
				break
			end

			iter_2_0 = string.sub(iter_2_0, var_2_5 + 1)
		end

		var_2_3 = var_2_3 + 1
		var_2_0[var_2_3] = "battle/scene/" .. iter_2_0
	end

	return var_2_0
end

local var_0_2

function var_0_0.chooseBgImage(arg_4_0, arg_4_1)
	if not var_0_2 then
		var_0_2 = var_0_1()
	end

	arg_4_0.currentBg = arg_4_0.currentBg or 0

	if arg_4_0.bgSpr then
		arg_4_0.bgSpr:removeSelf()
	end

	if arg_4_1 == "next" then
		arg_4_0.currentBg = arg_4_0.currentBg + 1 >= table.length(var_0_2) and 1 or arg_4_0.currentBg + 1
	else
		arg_4_0.currentBg = arg_4_0.currentBg - 1 <= 0 and table.length(var_0_2) or arg_4_0.currentBg - 1
	end

	local var_4_0 = cc.Sprite:create(var_0_2[arg_4_0.currentBg])

	var_4_0:xy(display.center):scale(2)
	arg_4_0.parent.stageLayer:add(var_4_0)

	arg_4_0.bgSpr = var_4_0
end

function var_0_0.newBtn(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = cc.Label:createWithTTF(arg_5_3, ui.FONT_PATH, 40)

	var_5_0:setPosition(100, 30)

	local var_5_1 = ccui.Button:create("common/box/mask_fangd.png")

	var_5_1:add(var_5_0)
	var_5_1:setPressedActionEnabled(true)
	var_5_1:setPosition(cc.p(arg_5_1, arg_5_2))
	var_5_1:setOpacity(100)

	if arg_5_0.layer then
		arg_5_0.layer:add(var_5_1, 999)
	else
		arg_5_0.parent.layer:add(var_5_1, 999)
	end

	var_5_1.content = var_5_0

	adapt.dockWithScreen(var_5_1, "left")
	var_5_1:setScaleY(0.8)

	return var_5_1
end

function var_0_0.addPauseBtn(arg_6_0)
	local var_6_0 = arg_6_0:newBtn(160, display.cy + 320, " stop!")

	var_6_0:onClick(function()
		if display.director:isPaused() then
			display.director:resume()
			gRootViewProxy:proxy():setEffectDebugBreakpoint(nil)
			var_6_0.content:setString(" stop!")
		else
			display.director:pause()
			var_6_0.content:setString(" run! ")
		end
	end)
end

function var_0_0.addFrameControlBtn(arg_8_0)
	local var_8_0 = arg_8_0:newBtn(160, display.cy + 320 - 80, "下一帧")

	var_8_0:onClick(function()
		display.director:resume()
		print("resume")
		performWithDelay(var_8_0, function()
			print("pause")
			display.director:pause()
		end, 0.016666666666666666)
	end)
end

function var_0_0.addEffectControlBtn(arg_11_0)
	arg_11_0:newBtn(160, display.cy + 320 - 160, "Next Effect"):onClick(function()
		display.director:resume()
		print("resume effect")
		gRootViewProxy:proxy():setEffectDebugBreakpoint(function(arg_13_0, arg_13_1, arg_13_2)
			print("pause effect", string.format("%d/%d", arg_13_1, arg_13_0.queTailID), arg_13_2, toDebugString(arg_13_2))
			display.director:pause()

			return false
		end)
	end)
end

function var_0_0.backToLogin(arg_14_0)
	arg_14_0.backView = "login.view"
end

function var_0_0.addEnterCity(arg_15_0)
	arg_15_0:newBtn(160, display.cy + 320 - 240, "Return city"):onClick(function()
		local var_16_0 = gGameModel.role:getRawIdler_("gold")

		if var_16_0 then
			print("refresh gold for test", var_16_0, gold)
			var_16_0:notify()
		end

		gGameUI:switchUI(arg_15_0.backView)

		if var_16_0 then
			print("refresh gold for test", var_16_0, gold)
			var_16_0:notify()
		end
	end)
end

function var_0_0.addDebugEnabled(arg_17_0)
	local var_17_0 = false

	arg_17_0:newBtn(160, display.cy + 320 - 640, "debug switch"):onClick(function()
		var_17_0 = not var_17_0

		arg_17_0.layer:setVisible(var_17_0)
	end)
end

function var_0_0.addFullManual(arg_19_0)
	local var_19_0 = false
	local var_19_1 = arg_19_0:newBtn(160, display.cy + 320 - 720, "Global manual off")
	local var_19_2

	var_19_1:onClick(function()
		local var_20_0 = gGameUI.uiRoot._model.scene
		local var_20_1 = var_20_0.play

		if var_20_0.isRecord or var_20_1.data.gateType == game.GATE_TYPE.test or var_20_1.data.gateType == game.GATE_TYPE.friendFight then
			if not var_19_0 then
				var_19_2 = var_20_0.autoFight

				var_20_0:setAutoFight(false)
			else
				if not var_20_1:isMyTurn() then
					gGameUI:showTip("The attack switches to its own side and then closes")

					return
				end

				var_20_0:setAutoFight(var_19_2)
			end

			var_19_0 = not var_19_0

			var_19_1.content:setString(var_19_0 and "Global manual on" or "Global manual off")
			var_20_0:setFullManual(var_19_0)
		else
			gGameUI:showTip("This scenario does not support global manual")
		end
	end)
end

function var_0_0.addAutoTestDebug(arg_21_0)
	arg_21_0:newBtn(160, display.cy + 320 - 560, "Simulate 100 battles"):onClick(function()
		local var_22_0 = arg_21_0.parent.data

		gGameUI:switchUI("city.view")
		performWithDelay(gGameUI.scene, function()
			local var_23_0 = 100
			local var_23_1 = 0
			local var_23_2 = 0

			for iter_23_0 = 1, var_23_0 do
				var_22_0.randSeed = math.random(1, 99999999)

				local var_23_3 = battleEntrance.battleRecord(var_22_0, "unknown", {
					fromRecordFile = true
				}):run()

				if var_23_3.result == "win" then
					var_23_1 = var_23_1 + 1
				elseif var_23_3.result == "fail" then
					var_23_2 = var_23_2 + 1
				end

				print(string.format("[INFO] current: %d (%d vs %d)", var_23_0, var_23_1, var_23_2))
				print(string.format("[INFO] RunTime: (%d/%d), Seed: %d", iter_23_0, var_23_0, var_22_0.randSeed))
			end

			print(string.format("[INFO] Total number of combat tests: %d Which wins %d times lose %d times", var_23_0, var_23_1, var_23_2))
		end, 5)
	end)
end

function var_0_0.addSpeedControlBtn(arg_24_0)
	arg_24_0:newBtn(950, 150, "Speed"):onClick(function()
		local var_25_0 = display.director:getScheduler():getTimeScale()
		local var_25_1 = math.min(20, var_25_0 + 1)

		display.director:getScheduler():setTimeScale(var_25_1)
		gGameUI:showTip("Accelerate, now speed" .. var_25_1)
		print("speed up", var_25_1)
	end)
	arg_24_0:newBtn(950, 70, "Slow"):onClick(function()
		local var_26_0 = display.director:getScheduler():getTimeScale()
		local var_26_1 = var_26_0 - 1

		if var_26_0 - 1 < 1 then
			var_26_1 = var_26_0 - 0.3
		end

		local var_26_2 = math.max(0.1, var_26_1)

		display.director:getScheduler():setTimeScale(var_26_2)

		if var_26_2 >= 1 then
			gGameUI:showTip("Slow down, now speed" .. var_26_2)
		else
			gGameUI:cleanTip()
		end

		print("speed down", var_26_2)
	end)
end

function var_0_0.addFrontBgBtn(arg_27_0)
	arg_27_0:newBtn(1150, 150, "Previous"):onClick(function()
		arg_27_0:chooseBgImage("front")
	end)
	arg_27_0:newBtn(1150, 230, "Next"):onClick(function()
		arg_27_0:chooseBgImage("next")
	end)
end

function var_0_0.addBattleRecordBtn(arg_30_0)
	local var_30_0 = arg_30_0:newBtn(1150, 70, "Combat data")
	local var_30_1 = {}
	local var_30_2 = {
		[3245] = true
	}

	var_30_0:onClick(function()
		if gGameUI.rootViewName:find("battle.view") then
			if not arg_30_0.battleDataDisplay then
				local var_31_0 = gGameUI.uiRoot._model.scene

				arg_30_0.battleDataDisplay = gGameUI:createView("city.test.test_battle_data_display", gGameUI.uiRoot):init():z(999)

				local function var_31_1()
					if gGameUI.rootViewName:find("battle.view") then
						local var_32_0 = {}
						local var_32_1 = {}

						for iter_32_0, iter_32_1 in var_31_0:ipairsHeros() do
							var_32_1[iter_32_1.seat] = iter_32_1.unitID

							if not var_30_2[iter_32_1.orginUnitId] then
								var_32_0[iter_32_1.seat] = {
									seat = iter_32_1.seat,
									dbID = iter_32_1.dbID,
									unitID = iter_32_1.orginUnitId,
									star = iter_32_1.star,
									advance = iter_32_1.data.advance,
									level = iter_32_1.level,
									totalDamage = iter_32_1.totalDamage,
									totalResumeHp = iter_32_1.totalResumeHp,
									totalTakeDamage = iter_32_1.totalTakeDamage,
									bigSkillUseTimes = iter_32_1:getEventByKey(battle.MainSkillType.BigSkill)
								}
							end
						end

						if not itertools.equal(var_32_1, var_30_1) then
							var_30_1 = var_32_1
						end

						return var_32_0
					end
				end

				arg_30_0.battleDataDisplay:refresh(var_31_1())
				schedule(arg_30_0.battleDataDisplay, function()
					arg_30_0.battleDataDisplay:refresh(var_31_1())
				end, 0.03333333333333333)
			else
				arg_30_0.battleDataDisplay:visible(not arg_30_0.battleDataDisplay:visible())
			end
		end
	end)
end

function var_0_0.addBattleSpriteDebug(arg_34_0)
	local var_34_0 = false
	local var_34_1 = arg_34_0:newBtn(1350, 150, "Point display")

	var_34_1:onClick(function()
		var_34_1.content:setString(var_34_0 and "Point display" or "Point hidden")

		var_34_0 = not var_34_0

		local var_35_0 = gRootViewProxy:call("getSceneObjs")

		for iter_35_0, iter_35_1 in pairs(var_35_0) do
			if iter_35_1.seat < 13 then
				iter_35_1:setDebugEnabled(var_34_0)
			end
		end
	end)
end

function var_0_0.addEffectDebug(arg_36_0)
	local var_36_0 = false
	local var_36_1 = arg_36_0:newBtn(1350, 70, "Effect display")

	var_36_1:onClick(function()
		var_36_1.content:setString(var_36_0 and "Effect display" or "Effect hidden")

		var_36_0 = not var_36_0

		local var_37_0 = gRootViewProxy:call("getSceneObjs")

		for iter_37_0, iter_37_1 in pairs(var_37_0) do
			if iter_37_1.seat < 13 then
				iter_37_1:setEffectDebugEnabled(var_36_0)
			end
		end

		gRootViewProxy:proxy():setEffectDebugEnabled(var_36_0)
	end)
end

function var_0_0.addTintColorDebug(arg_38_0)
	local var_38_0 = false
	local var_38_1 = arg_38_0:newBtn(950, 230, "TintColor on")

	var_38_1:onClick(function()
		var_38_1.content:setString(var_38_0 and "TintColor on" or "TintColor off")

		var_38_0 = not var_38_0

		for iter_39_0, iter_39_1 in pairs(SpineSpritesMap) do
			if tolua.isnull(iter_39_0) then
				printWarn("spine %s released but no gc", tostring(iter_39_0))
			else
				printInfo("spine %s\t%s %s tint color", tostring(iter_39_0), iter_39_1.__aniRes, var_38_0 and "open" or "close")
				iter_39_0:setTwoColorTint(var_38_0)
			end
		end
	end)
end

function var_0_0.addCRenderTargetDebug(arg_40_0)
	local var_40_0 = true
	local var_40_1 = arg_40_0:newBtn(1150, 310, "RT off")

	var_40_1:onClick(function()
		var_40_1.content:setString(var_40_0 and "RT on" or "RT off")

		var_40_0 = not var_40_0

		for iter_41_0, iter_41_1 in pairs(CRenderSpritesMap) do
			if tolua.isnull(iter_41_0) then
				printWarn("render_target %s released but no gc", tostring(iter_41_0))
			else
				printInfo("render_target %s\t%s %s", tostring(iter_41_0), iter_41_0:name(), var_40_0 and "show" or "hide")
				iter_41_0:setVisible(var_40_0)

				if iter_41_1 then
					iter_41_0:addDebugLayer()

					CRenderSpritesMap[iter_41_0] = false
				end
			end
		end
	end)
end

function var_0_0.addA4Debug(arg_42_0)
	local var_42_0 = false
	local var_42_1 = arg_42_0:newBtn(1150, 230, "A4 on")

	var_42_1:onClick(function()
		var_42_1.content:setString(var_42_0 and "A4 on" or "A4 off")

		var_42_0 = not var_42_0

		local var_43_0 = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888

		if var_42_0 then
			var_43_0 = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444
		end

		printInfo("A4 default %s %s", var_42_0 and "true" or "false", var_43_0)
		cc.Texture2D:setDefaultAlphaPixelFormat(var_43_0)
		display.textureCache:removeAllTextures()
	end)
end

function var_0_0.addThreadDebug(arg_44_0)
	local var_44_0 = false
	local var_44_1 = arg_44_0:newBtn(1350, 310, "Thread on")

	var_44_1:onClick(function()
		var_44_1.content:setString(var_44_0 and "Thread on" or "Thread off")

		var_44_0 = not var_44_0

		printInfo("Thread %s", var_44_0 and "true" or "false")
		display.director:setSpineThreadDrawEnabled(var_44_0)
	end)
end

function var_0_0.addSpineDebug(arg_46_0)
	arg_46_0:newBtn(1350, 230, "Spine hidden"):onClick(function()
		local var_47_0 = 0

		for iter_47_0, iter_47_1 in pairs(SpineSpritesMap) do
			if tolua.isnull(iter_47_0) then
				printWarn("spine %s released but no gc", tostring(iter_47_0))
			elseif iter_47_0:isVisible() then
				printInfo("spine %s\t%s hide", tostring(iter_47_0), iter_47_1.__aniRes)
				iter_47_0:setVisible(false)

				var_47_0 = var_47_0 + 1

				return
			end
		end

		if var_47_0 == 0 then
			for iter_47_2, iter_47_3 in pairs(SpineSpritesMap) do
				if not tolua.isnull(iter_47_2) then
					iter_47_2:setVisible(true)
					printInfo("spine %s\t%s show", tostring(iter_47_2), iter_47_3.__aniRes)
				end
			end
		end
	end)
end

function var_0_0.addSpineTimeScaleDebug(arg_48_0)
	local var_48_0 = 10
	local var_48_1 = 60
	local var_48_2 = arg_48_0:newBtn(950, 310, "Spine fps" .. tostring(var_48_1))

	var_48_2:onClick(function()
		display.director:setSpineInterval(1 / var_48_1)
		printInfo("spine fps %s", tostring(var_48_1))

		if var_48_1 <= 30 then
			display.director:setAnimationInterval(0.03333333333333333)
		else
			display.director:setAnimationInterval(0.016666666666666666)
		end

		var_48_1 = var_48_1 - var_48_0

		if var_48_1 <= 0 then
			var_48_1 = 60
		end

		var_48_2.content:setString("Spine fps" .. tostring(var_48_1))
	end)
end

return var_0_0
