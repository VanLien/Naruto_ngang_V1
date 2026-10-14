local var_0_0 = class("SysSetting", battleModule.CBase)

function var_0_0.ctor(arg_1_0, arg_1_1)
	battleModule.CBase.ctor(arg_1_0, arg_1_1)

	arg_1_0.speedButton = arg_1_0.parent.UIWidgetBottomLeft:get("speedUp")
	arg_1_0.autoButton = arg_1_0.parent.UIWidgetBottomLeft:get("autoAtt")
	arg_1_0.pauseButton = arg_1_0.parent.UIWidgetBottomLeft:get("pause")
	arg_1_0.passButton = arg_1_0.parent.UIWidgetBottomLeft:get("mainSkillPass")
	arg_1_0.buttonCapture = CRenderSprite.newWithNodes(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444, arg_1_0.pauseButton, arg_1_0.autoButton, arg_1_0.speedButton, arg_1_0.passButton)

	arg_1_0.buttonCapture:addTo(arg_1_0.parent.UIWidgetBottomLeft, 999):coverTo(arg_1_0.pauseButton)

	if arg_1_0.parent:hasGuide() then
		arg_1_0.buttonCapture:hide()
	else
		arg_1_0.buttonCapture:setTouchEnabled()
		performWithDelay(arg_1_0.parent, function()
			arg_1_0.buttonCapture:show()
		end, 1)
	end

	arg_1_0.skipButton = arg_1_0.parent.UIWidgetBottomLeft:get("skip")

	if arg_1_0.skipButton then
		arg_1_0.skipButton:hide()
	end
end

function var_0_0.setAutoButton(arg_3_0, arg_3_1)
	arg_3_0.autoButton:get("auto"):setString("")

	local var_3_0 = arg_3_0.autoButton:get("mannal")
	local var_3_1 = arg_3_0.autoButton:size()
	local var_3_2 = -25

	var_3_0 = var_3_0 or widget.addAnimationByKey(arg_3_0.autoButton, "battlearena/battle_zidong.skel", "manual", "zidong", 10):xy(var_3_1.width * 2 / 3, var_3_2):scale(2)

	if arg_3_1.canHandle and not arg_3_1.isAuto then
		if arg_3_0.parent.gateType == game.GATE_TYPE.newbie then
			-- block empty
		elseif arg_3_0.parent.gateType ~= game.GATE_TYPE.test and not dataEasy.isUnlock(gUnlockCsv.gateAuto) then
			var_3_0:play("zidong")
			arg_3_0.autoButton:onClick(function()
				gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.gateSpeed2))
			end)
		else
			arg_3_0.autoButton:get("disabled"):hide()
			arg_3_0.autoButton:get("lock"):hide()

			local var_3_3 = userDefault.getForeverLocalKey("gateAuto", false)

			if arg_3_1.lockAuto ~= nil then
				var_3_3 = arg_3_1.lockAuto
			end

			var_3_0:play(var_3_3 and "zidong_loop" or "zidong")
			arg_3_0.parent:handleOperation(battle.OperateTable.autoFight, var_3_3)
			arg_3_0.autoButton:onClick(function()
				var_3_3 = not var_3_3

				var_3_0:play(var_3_3 and "zidong_loop" or "zidong")

				if var_3_3 then
					arg_3_0:call("showSKillUIWidgets", false)
				end

				arg_3_0.parent:handleOperation(battle.OperateTable.autoFight, var_3_3)
				userDefault.setForeverLocalKey("gateAuto", var_3_3)
			end)
		end
	else
		local var_3_4 = userDefault.getForeverLocalKey("gateAuto", false)

		var_3_0:play(var_3_4 and "zidong_loop" or "zidong")
	end
end

function var_0_0.setPauseButton(arg_6_0, arg_6_1)
	if (arg_6_0.parent.gateType == game.GATE_TYPE.test or dataEasy.isUnlock(gUnlockCsv.gatePause)) and arg_6_1.canPause then
		arg_6_0.pauseButton:get("disabled"):hide()
		arg_6_0.pauseButton:get("lock"):hide()
		arg_6_0.pauseButton:onClick(function()
			if arg_6_1.canPause then
				audio.pauseAllSounds()
				gGameUI:stackUI("battle.pause", nil, nil, arg_6_0.parent):z(999)
			end
		end)
	end
end

function var_0_0.setSpeedButton(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.speedButton:get("speed")
	local var_8_1 = arg_8_1.speedNum or 1

	if (arg_8_0.parent.gateType == game.GATE_TYPE.test or dataEasy.isUnlock(gUnlockCsv.gateSpeed2)) and arg_8_1.canSpeedAni then
		var_8_1 = tonumber(userDefault.getForeverLocalKey("gateSpeed", 1))

		arg_8_0.speedButton:get("disabled"):hide()
		arg_8_0.speedButton:get("lock"):hide()
	end

	var_8_0:setString(string.format("x%d", var_8_1))
	arg_8_0.parent:handleOperation(battle.OperateTable.timeScale, var_8_1)

	local function var_8_2(arg_9_0)
		if dataEasy.isUnlock(gUnlockCsv.gateSpeed3) then
			arg_9_0 = arg_9_0 + 1

			if arg_9_0 == 4 then
				arg_9_0 = 1
			end

			return arg_9_0
		else
			if arg_9_0 == 2 then
				gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.gateSpeed3))
			end

			return 3 - arg_9_0
		end
	end

	arg_8_0.speedButton:onClick(function()
		if arg_8_0.parent.gateType == game.GATE_TYPE.newbie then
			-- block empty
		elseif arg_8_0.parent.gateType ~= game.GATE_TYPE.test and not dataEasy.isUnlock(gUnlockCsv.gateSpeed2) then
			gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.gateSpeed2))
		elseif arg_8_1.canSpeedAni then
			var_8_1 = var_8_2(var_8_1)

			var_8_0:setString(string.format("x%d", var_8_1))
			arg_8_0.parent:handleOperation(battle.OperateTable.timeScale, var_8_1)
			userDefault.setForeverLocalKey("gateSpeed", var_8_1)
		end
	end)
end

function var_0_0.setSkipButton(arg_11_0, arg_11_1)
	local function var_11_0(arg_12_0)
		arg_12_0 = tonumber(arg_12_0)

		local var_12_0 = battle.UITag.passCD

		arg_11_0.parent:enableSchedule():unSchedule(var_12_0)
		arg_11_0.skipButton:setColor(cc.c3b(75, 75, 75))
		arg_11_0.skipButton:get("text"):setColor(cc.c3b(75, 75, 75))
		arg_11_0.skipButton:get("mask"):setVisible(true)
		arg_11_0.skipButton:get("mask"):get("timer"):setString(arg_12_0)
		arg_11_0.parent:schedule(function()
			arg_12_0 = arg_12_0 - 1

			arg_11_0.skipButton:get("mask"):get("timer"):setString(arg_12_0)

			if arg_12_0 <= 0 then
				arg_11_0.skipButton:get("mask"):setVisible(false)
				arg_11_0.skipButton:setColor(cc.c3b(255, 255, 255))
				arg_11_0.skipButton:get("text"):setColor(cc.c3b(255, 252, 237))

				return false
			end
		end, 1, 1, var_12_0)
	end

	if arg_11_0.parent.gateType == game.GATE_TYPE.crossMine then
		arg_11_0.originPassStr = arg_11_0.skipButton:get("text"):text()

		arg_11_0.skipButton:get("text"):text(gLanguageCsv.crossMinePVPSkip)
	end

	if arg_11_1.canSkip and arg_11_0.skipButton then
		arg_11_0.skipButton:show()
		arg_11_0.skipButton:onClick(function()
			arg_11_0:onClickPass()
		end)

		if arg_11_0.parent.gateType == game.GATE_TYPE.arena and not arg_11_1.canSkipInstant then
			local var_11_1 = gGameModel.role:getIdler("vip_level")
			local var_11_2 = gVipCsv[var_11_1:read()].arenaPassCD

			if dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.BattleSkip, game.SCENE_TYPE.arena) then
				var_11_2 = 0
			end

			var_11_0(var_11_2)
		elseif arg_11_0.parent.gateType == game.GATE_TYPE.endlessTower then
			local var_11_3 = gCommonConfigCsv.endlessTowerJumpCD

			if dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.BattleSkip, game.SCENE_TYPE.endlessTower) then
				var_11_3 = 0
			end

			var_11_0(var_11_3)
		elseif arg_11_0.parent.gateType == game.GATE_TYPE.randomTower then
			local var_11_4 = gCommonConfigCsv.randomTowerJumpCD

			if dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.BattleSkip, game.SCENE_TYPE.randomTower) then
				var_11_4 = 0
			end

			var_11_0(var_11_4)
		elseif arg_11_0.parent.gateType == game.GATE_TYPE.worldBoss then
			local var_11_5 = gCommonConfigCsv.worldBossJumpCD

			if dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.BattleSkip, game.SCENE_TYPE.worldBoss) then
				var_11_5 = 0
			end

			var_11_0(var_11_5)
		elseif arg_11_0.parent.gateType == game.GATE_TYPE.gym then
			local var_11_6 = gCommonConfigCsv.gymGateJumpCD

			if dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.BattleSkip, game.SCENE_TYPE.gym) then
				var_11_6 = 0
			end

			var_11_0(var_11_6)
		elseif arg_11_0.parent.gateType == game.GATE_TYPE.hunting then
			local var_11_7 = gCommonConfigCsv.huntingJumpCD

			if dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.BattleSkip, game.SCENE_TYPE.hunting) then
				var_11_7 = 0
			end

			var_11_0(var_11_7)
		elseif arg_11_0.parent.gateType == game.GATE_TYPE.clone then
			if not dataEasy.isUnlock(gUnlockCsv.skipCloneBattle) then
				arg_11_0.skipButton:hide()
				arg_11_0.skipButton:onClick(function()
					return
				end)
			else
				arg_11_0.skipButton:get("mask"):setVisible(false)
			end
		else
			arg_11_0.skipButton:get("mask"):setVisible(false)
		end
	end
end

function var_0_0.setPassButton(arg_16_0, arg_16_1)
	local var_16_0 = userDefault.getForeverLocalKey("mainSkillPass", false)
	local var_16_1 = arg_16_0.passButton:get("imgOpen")
	local var_16_2 = arg_16_0.passButton:get("imgClose")

	var_16_1:visible(var_16_0)
	var_16_2:visible(not var_16_0)

	if arg_16_0.parent.gateType == game.GATE_TYPE.test or dataEasy.isUnlock(gUnlockCsv.ultraAcc) then
		arg_16_0.passButton:hide()
	else
		arg_16_0.passButton:hide()
	end

	arg_16_0.passButton:onClick(function()
		local var_17_0 = userDefault.getForeverLocalKey("mainSkillPass", false)

		if var_17_0 then
			print("MainSkillPass Close")
		else
			print("MainSkillPass Open")
		end

		local var_17_1 = not var_17_0

		userDefault.setForeverLocalKey("mainSkillPass", var_17_1)
		var_16_1:visible(var_17_1)
		var_16_2:visible(not var_17_1)
	end)
end

function var_0_0.onSetOperators(arg_18_0, arg_18_1)
	arg_18_0:setAutoButton(arg_18_1)
	arg_18_0:setPauseButton(arg_18_1)
	arg_18_0:setSpeedButton(arg_18_1)
	arg_18_0:setSkipButton(arg_18_1)
	arg_18_0:setPassButton(arg_18_1)
	arg_18_0.buttonCapture:refresh()
end

function var_0_0.onClickPass(arg_19_0)
	if arg_19_0.parent.gateType == game.GATE_TYPE.crossMine then
		arg_19_0.parent:handleOperation(battle.OperateTable.passOneWave)
	else
		if arg_19_0.parent.isModelPass then
			return
		end

		arg_19_0.parent.isModelPass = true

		arg_19_0.parent:handleOperation(battle.OperateTable.pass)
	end
end

function var_0_0.onNewBattleRound(arg_20_0, arg_20_1)
	if arg_20_0.parent.gateType ~= game.GATE_TYPE.crossMine or not arg_20_1.wave or not arg_20_1.totalWave then
		return
	end

	if not arg_20_0.isLastWave and arg_20_1.wave >= arg_20_1.totalWave then
		arg_20_0.isLastWave = true

		if arg_20_0.originPassStr then
			arg_20_0.skipButton:get("text"):text(arg_20_0.originPassStr)
		end
	end
end

function var_0_0.onClose(arg_21_0)
	arg_21_0.buttonCapture:hide()
end

function var_0_0.setPauseBtn(arg_22_0, arg_22_1, arg_22_2)
	if arg_22_1 then
		arg_22_0.pauseButton:get("settingImg"):loadTexture(arg_22_1)
	end

	if arg_22_2 then
		arg_22_0.pauseButton:onClick(arg_22_2)
	end

	arg_22_0.buttonCapture:refresh()
end

function var_0_0.setSpeedBtn(arg_23_0, arg_23_1)
	arg_23_0.speedButton:get("speed"):setString(string.format("x%d", arg_23_1))
	arg_23_0.parent:handleOperation(battle.OperateTable.timeScale, arg_23_1)
	arg_23_0.buttonCapture:refresh()
end

function var_0_0.setJumpSkillBtn(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0.passButton:get("imgOpen")
	local var_24_1 = arg_24_0.passButton:get("imgClose")

	var_24_0:visible(arg_24_1)
	var_24_1:visible(not arg_24_1)
	userDefault.setForeverLocalKey("mainSkillPass", arg_24_1)
	arg_24_0.buttonCapture:refresh()
end

function var_0_0.setAutoBtn(arg_25_0, arg_25_1, arg_25_2)
	arg_25_0.autoButton:get("auto"):setString("")

	local var_25_0 = arg_25_0.autoButton:get("mannal")
	local var_25_1 = arg_25_0.autoButton:size()
	local var_25_2 = -25

	var_25_0 = var_25_0 or widget.addAnimationByKey(arg_25_0.autoButton, "battlearena/battle_zidong.skel", "manual", "zidong", 10):xy(var_25_1.width * 2 / 3, var_25_2):scale(2)

	if arg_25_1 then
		var_25_0:play("zidong_loop")
	else
		var_25_0:play("zidong")
	end

	arg_25_0.parent:handleOperation(battle.OperateTable.autoFight, arg_25_1)

	if arg_25_2 then
		arg_25_0.autoButton:onClick(functools.partial(arg_25_2, arg_25_0.autoButton))
	end

	arg_25_0.buttonCapture:refresh()
end

return var_0_0
