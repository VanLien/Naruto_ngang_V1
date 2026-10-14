local var_0_0 = string.format
local var_0_1 = class("BattleOnlineFightView", battleModule.CBase)

var_0_1.RESOURCE_FILENAME = "battle_online_fight.json"
var_0_1.RESOURCE_BINDING = {
	["tipBg.waitloadingPnl.effect1"] = "waitEffect1",
	["tipBg.cutdownimg"] = "cutdownimg",
	tipBg = "tipBg",
	["tipBg.waitloadingPnl"] = "waitloadingPnl",
	["tipBg.waitloadingPnl.effect3"] = "waitEffect3",
	["tipBg.waitloadingPnl.effect2"] = "waitEffect2",
	["tipBg.waitloadingPnl.waitloadinglabel"] = {
		varname = "waitloadinglabel",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(241, 60, 84, 255)
				}
			}
		}
	},
	["tipBg.waitlabel"] = {
		varname = "waitlabel",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(241, 60, 84, 255)
				}
			}
		}
	}
}

local var_0_2 = "battle/online_fight/"
local var_0_3 = {
	null = 0,
	wait = 6,
	waitloading = 4,
	attack = 5,
	record = 7
}

function var_0_1.ctor(arg_1_0, arg_1_1)
	battleModule.CBase.ctor(arg_1_0, arg_1_1)

	arg_1_0.root = cache.createWidget(arg_1_0.RESOURCE_FILENAME)

	bindUI(arg_1_0, arg_1_0.root, arg_1_0.RESOURCE_BINDING)
	arg_1_0.root:addTo(arg_1_1, 999):show()
	arg_1_0:onHideStateTips()

	arg_1_0.time = 0
	arg_1_0.waitServerTime = 0
	arg_1_0.state = var_0_3.null
	arg_1_0.defaultSpeed = 3
	arg_1_0.exitShowTip = gLanguageCsv.onlineFightBattleGiveUpTip
	arg_1_0.cutdownTime = idler.new(10)

	bind.extend(arg_1_0.parent, arg_1_0.cutdownimg, {
		class = "text_atlas",
		props = {
			pathName = "online_fight_battle_cutdown",
			align = "center",
			data = arg_1_0.cutdownTime
		}
	})

	local var_1_0 = arg_1_0.parent.data

	arg_1_0.leftHeadPnl = arg_1_0.parent.UIWidgetLeft:get("infoPVP")
	arg_1_0.rightHeadPnl = arg_1_0.parent.UIWidgetRight:get("infoPVP")

	arg_1_0.leftHeadPnl:get("level"):setFontSize(40):anchorPoint(0, 0.5):x(arg_1_0.leftHeadPnl:get("roleName"):x()):setString(getServerArea(var_1_0.role_key[1], true))
	arg_1_0.leftHeadPnl:get("levelLv"):visible(false)
	arg_1_0.rightHeadPnl:get("level"):setFontSize(40):anchorPoint(1, 0.5):x(arg_1_0.rightHeadPnl:get("roleName"):x()):setString(getServerArea(var_1_0.defence_role_key[1], true))
	arg_1_0.rightHeadPnl:get("levellv"):visible(false)
	arg_1_0:call("refreshInfoPvP")

	if arg_1_0.parent:getPlayModel().locals.state ~= var_0_3.record then
		arg_1_0:call("setPauseBtn", "battle/pause/icon_tc.png", function()
			local var_2_0 = gLanguageCsv.onlineFightBattleGiveUpTip

			if arg_1_0.parent:getPlayModel().curRound <= gCommonConfigCsv.onlineFightFleeRoundLimit then
				local var_2_1 = userDefault.getForeverLocalKey("onlineFightFleeTime", {})

				if #var_2_1 >= 3 and time.getTime() - var_2_1[1] < 3600 then
					gGameUI:showTip(gLanguageCsv.onlineFightNoFlee)

					return
				end

				var_2_0 = gLanguageCsv.onlineFightBattleFleeTip
			end

			audio.pauseAllSounds()
			gGameUI:showDialog({
				isRich = true,
				clearFast = true,
				btnType = 2,
				content = var_2_0,
				cb = function()
					arg_1_0.parent:getPlayModel():sendExitGameMsg()
				end
			})
		end)
		arg_1_0:call("setAutoBtn", false)
	else
		arg_1_0:call("setAutoBtn", true, function(arg_4_0)
			arg_4_0:get("disabled"):show()
			arg_4_0:get("lock"):show()
		end)
	end

	arg_1_0:call("setSpeedBtn", arg_1_0.defaultSpeed)
	arg_1_0:call("setJumpSkillBtn", true)
	arg_1_0:init()
end

function var_0_1.init(arg_5_0)
	arg_5_0.waitloadinglabel:setText(gLanguageCsv.beWaitLoading)
	arg_5_0.waitlabel:setText(gLanguageCsv.beWait)
end

function var_0_1.onUpdate(arg_6_0, arg_6_1)
	return
end

function var_0_1.onPlayOnlineFightState(arg_7_0)
	local var_7_0 = arg_7_0.parent:getPlayModel()
	local var_7_1 = var_7_0.locals.state

	if arg_7_0.state == var_7_1 and var_7_1 ~= var_0_3.attack then
		return
	end

	local var_7_2, var_7_3 = arg_7_0.waitloadingPnl:getPosition()

	if var_7_1 == var_0_3.waitloading then
		arg_7_0:refreshCutDownTime()
		arg_7_0.cutdownimg:visible(true)
		arg_7_0.waitloadingPnl:visible(true)
		arg_7_0.waitlabel:visible(false)
		arg_7_0.cutdownimg:setPosition(cc.p(var_7_2, var_7_3 - 100))
		arg_7_0:playFadeEffect(arg_7_0.waitEffect1, 0)
		arg_7_0:playFadeEffect(arg_7_0.waitEffect2, 0.2)
		arg_7_0:playFadeEffect(arg_7_0.waitEffect3, 0.4)
		setContentSizeOfAnchor(arg_7_0.tipBg, cc.size(1065, 157))
	elseif var_7_1 == var_0_3.wait or var_7_1 == var_0_3.attack then
		arg_7_0:refreshCutDownTime()
		arg_7_0.cutdownimg:setPosition(cc.p(var_7_2, var_7_3))
		arg_7_0.cutdownimg:visible(true)
		arg_7_0.waitloadingPnl:visible(false)
		arg_7_0.waitlabel:visible(false)
		setContentSizeOfAnchor(arg_7_0.tipBg, cc.size(273, 141))
	elseif var_7_1 == var_0_3.record then
		arg_7_0.cutdownimg:visible(false)
		arg_7_0.waitloadingPnl:visible(false)
		arg_7_0.waitlabel:visible(false)
		arg_7_0.tipBg:visible(false)
	end

	if arg_7_0.state == var_0_3.waitloading then
		arg_7_0.waitEffect1:stopAllActions()
		arg_7_0.waitEffect2:stopAllActions()
		arg_7_0.waitEffect3:stopAllActions()

		if var_7_1 == var_0_3.attack and not var_7_0:isNowTurnAutoFight() then
			arg_7_0:call("showSKillUIWidgets", true)
		end
	end

	arg_7_0.state = var_7_1

	if arg_7_0.state == var_0_3.record then
		return
	end

	arg_7_0.tipBg:visible(true)
end

function var_0_1.onHideStateTips(arg_8_0)
	if arg_8_0.state == var_0_3.record then
		return
	end

	arg_8_0.state = var_0_3.null

	arg_8_0.tipBg:visible(false)
end

function var_0_1.onNewBattleRound(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.parent:getPlayModel()

	if var_9_0.locals.scene_state == game.SYNC_SCENE_STATE.waitloading then
		return
	end

	if var_9_0:isLocalSlow() then
		display.director:getScheduler():setTimeScale(gCommonConfigCsv.onlineFightLateSpeedUpTime)
	else
		display.director:getScheduler():setTimeScale(arg_9_0.defaultSpeed)
	end

	local var_9_1 = var_9_0:getoffLineTb()

	for iter_9_0 = 1, 2 do
		if var_9_1 then
			arg_9_0:playerOffline(var_9_0.operateForce == iter_9_0 and arg_9_0.leftHeadPnl or arg_9_0.rightHeadPnl, var_9_1[iter_9_0])
		end
	end

	arg_9_0:onPlayOnlineFightState()
end

function var_0_1.playerOffline(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_1:get("roleImg")

	if arg_10_2 and arg_10_1:get("offlineText") then
		return
	end

	if not arg_10_2 and arg_10_1:get("offlineText") == nil then
		return
	end

	arg_10_1:removeChildByName("offlineText")
	cache.setShader(var_10_0, false, arg_10_2 and "hsl_gray" or "normal")

	if arg_10_2 then
		label.create(gLanguageCsv.onlineFightOffline, {
			fontSize = 40,
			fontPath = "font/youmi.ttf",
			effect = {
				color = ui.COLORS.NORMAL.WHITE,
				outline = {
					color = ui.COLORS.NORMAL.DEFAULT
				}
			}
		}):addTo(arg_10_1, var_10_0:z() + 1, "offlineText"):xy(var_10_0:xy())
	end

	arg_10_0:call("refreshInfoPvP")
end

function var_0_1.refreshCutDownTime(arg_11_0)
	local var_11_0 = arg_11_0.parent:getPlayModel():getCountDown()

	printDebug(var_11_0.clock_str, var_11_0.secstr)

	local var_11_1 = var_11_0.sec
	local var_11_2 = display.director:getScheduler():getTimeScale()

	arg_11_0.cutdownimg:stopAllActions()

	if var_11_0.sec <= 0 then
		return
	end

	arg_11_0.cutdownimg:runAction(cc.Repeat:create(cc.Sequence:create(cc.CallFunc:create(function()
		arg_11_0.cutdownTime:set(var_11_1)

		var_11_1 = var_11_1 - 1
	end), cc.ScaleTo:create(0.2 * var_11_2, 1), cc.DelayTime:create(0.6 * var_11_2), cc.ScaleTo:create(0.2 * var_11_2, 1.3), cc.CallFunc:create(function()
		if var_11_1 == 0 then
			arg_11_0.tipBg:visible(false)
		end
	end)), var_11_0.sec))
end

function var_0_1.playFadeEffect(arg_14_0, arg_14_1, arg_14_2)
	arg_14_1:runAction(cc.Sequence:create(cc.DelayTime:create(arg_14_2), cc.CallFunc:create(function()
		arg_14_1:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.FadeIn:create(1), cc.FadeOut:create(2))))
	end)))
end

function var_0_1.onSceneOver(arg_16_0, arg_16_1)
	arg_16_0.cutdownimg:stopAllActions()
	arg_16_0.waitEffect1:stopAllActions()
	arg_16_0.waitEffect2:stopAllActions()
	arg_16_0.waitEffect3:stopAllActions()
end

return var_0_1
