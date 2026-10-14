local var_0_0 = class("BattleEndWinView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "battle_end_clone_win.json"
var_0_0.RESOURCE_BINDING = {
	exitText = "exitText",
	["receiveBtn.awardCondText"] = "awardCondText",
	["receiveBtn.awardInfoText"] = "awardInfoText",
	["receiveBtn.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["backBtn.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	receiveBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onReceiveBtnClick")
			}
		}
	},
	backBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBackBtnClick")
			}
		}
	}
}

function var_0_0.playEndEffect(arg_1_0)
	local var_1_0 = arg_1_0:getResourceNode()
	local var_1_1, var_1_2 = var_1_0:get("awardPnl"):getPosition()
	local var_1_3 = CSprite.new("effect/gongxihuode.skel")

	var_1_3:addTo(var_1_0, 100)
	var_1_3:setAnchorPoint(cc.p(0.5, 1))
	var_1_3:setPosition(var_1_1, var_1_2)
	var_1_3:visible(true)
	var_1_3:setName("spine_1")
	var_1_3:play("jiesuan_shenglizi")
	var_1_3:addPlay("jiesuan_shenglizi_loop")
	var_1_3:retain()

	local var_1_4 = CSprite.new("effect/gongxihuode.skel")

	var_1_4:addTo(var_1_0, 99)
	var_1_4:setAnchorPoint(cc.p(0.5, 1))
	var_1_4:setPosition(var_1_1, var_1_2)
	var_1_4:visible(true)
	var_1_4:setName("spine_2")
	var_1_4:play("jiesuan_shenglitu")
	var_1_4:addPlay("jiesuan_shenglitu_loop")
	var_1_4:retain()

	arg_1_0.awardEffect = CSprite.new("clone_battle/baoxiang.skel")

	arg_1_0.awardEffect:addTo(var_1_0, 99)
	arg_1_0.awardEffect:setAnchorPoint(cc.p(0.5, 0.5))
	arg_1_0.awardEffect:setPosition(var_1_1, var_1_2 - 250)
	arg_1_0.awardEffect:visible(true)
	arg_1_0.awardEffect:scale(2)
	arg_1_0.awardEffect:setName("spine_3")
	arg_1_0.awardEffect:play("huangxiangzi_loop")
	arg_1_0.awardEffect:retain()
end

function var_0_0.onCreate(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	audio.playEffectWithWeekBGM("gate_win.mp3")

	arg_2_0.data = arg_2_2
	arg_2_0.results = arg_2_3
	arg_2_0.sceneID = arg_2_1
	arg_2_0.isFirstAward = true
	arg_2_0.drawNum = 0
	arg_2_0.consumeNum = 1

	local var_2_0 = gGameModel.clone_room:read("places")
	local var_2_1
	local var_2_2 = gGameModel.role:read("id")

	for iter_2_0, iter_2_1 in pairs(var_2_0) do
		if iter_2_1.id == var_2_2 then
			var_2_1 = iter_2_1.monster
		end
	end

	local var_2_3 = csv.clone.monster[var_2_1].cardID
	local var_2_4 = csv.cards[var_2_3].unitID
	local var_2_5 = csv.unit[var_2_4].rarity

	arg_2_0.seqParam = csv.clone.draw_box_cost[var_2_5].seqParam
	arg_2_0.receiveMax = table.length(arg_2_0.seqParam)

	local var_2_6 = arg_2_0:getResourceNode()
	local var_2_7 = {
		backBtn = "back",
		receiveBtn = "commonTextGet"
	}

	for iter_2_2, iter_2_3 in pairs(var_2_7) do
		var_2_6:get(iter_2_2 .. ".text"):text(gLanguageCsv[iter_2_3])
	end

	arg_2_0.exitText:text(gLanguageCsv.click2Exit)
	arg_2_0.exitText:visible(false)
	arg_2_0:playEndEffect()
	arg_2_0:updateAwardInfo(0)
end

function var_0_0.updateAwardInfo(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0:getResourceNode()
	local var_3_1 = var_3_0:get("receiveBtn")
	local var_3_2 = var_3_0:get("backBtn")

	if arg_3_0.isFirstAward then
		var_3_2:setEnabled(false)
		uiEasy.setBtnShader(var_3_2, var_3_2:get("text"), 2)
		text.deleteAllEffect(var_3_2:get("text"))
		arg_3_0.awardCondText:get("icon"):visible(false)
		arg_3_0.awardInfoText:setString(gLanguageCsv.canOpen .. string.format("(%s/%s)", arg_3_0.receiveMax, arg_3_0.receiveMax))
	else
		if arg_3_1 == 0 then
			uiEasy.setBtnShader(var_3_2, var_3_2:get("text"), 1)
			var_3_2:setEnabled(true)
			text.addEffect(var_3_2:get("text"), {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
			arg_3_0.awardCondText:get("icon"):visible(true)
			var_3_0:removeChildByName("spine_1")
			var_3_0:removeChildByName("spine_2")
		end

		local var_3_3 = arg_3_0.receiveMax - arg_3_1

		if var_3_3 ~= 0 then
			local var_3_4 = arg_3_0.seqParam[arg_3_0.consumeNum]

			arg_3_0.awardCondText:setString(string.format(gLanguageCsv.cost .. ": %s", var_3_4))

			arg_3_0.consumeNum = arg_3_0.consumeNum + 1
		end

		arg_3_0.awardInfoText:setString(string.format(gLanguageCsv.canOpenTimes, var_3_3, arg_3_0.receiveMax))
	end
end

function var_0_0.onReceiveBtnClick(arg_4_0)
	arg_4_0:dealDealyTime(false)

	local function var_4_0(arg_5_0, arg_5_1)
		local var_5_0 = arg_5_0.view.result

		arg_4_0.drawNum = arg_5_0.drawNum

		arg_4_0:updateAwardInfo(arg_5_0.drawNum)
		arg_4_0.awardEffect:play("huangxiangzikaixiang")
		performWithDelay(arg_4_0, function()
			gGameUI:showGainDisplay(var_5_0, {
				raw = arg_5_1,
				cb = function()
					if arg_4_0.drawNum == arg_4_0.receiveMax then
						arg_4_0:onBackBtnClick()
						gGameUI:showTip(gLanguageCsv.rewardBoxReciveOver)
					else
						arg_4_0.awardEffect:play("huangxiangzi_loop")
					end
				end
			})
			arg_4_0:dealDealyTime(true)
		end, 1)
	end

	if arg_4_0.isFirstAward then
		arg_4_0.isFirstAward = false

		var_4_0({
			view = {
				result = arg_4_0.results.freeBox
			},
			drawNum = arg_4_0.drawNum
		}, false)
	else
		local var_4_1 = arg_4_0.seqParam[arg_4_0.drawNum + 1]

		local function var_4_2()
			if not gGameUI:goBackInStackUI("city.recharge") then
				gGameUI:stackUI("city.recharge", nil, {
					full = true
				})
			end
		end

		if var_4_1 > gGameModel.role:getIdler("rmb"):read() then
			gGameUI:showDialog({
				clearFast = true,
				btnType = 2,
				title = gLanguageCsv.rmbNotEnough,
				content = gLanguageCsv.noDiamondGoRecharge,
				cb = var_4_2
			})
			arg_4_0:dealDealyTime(true)
		else
			arg_4_0.drawNum = arg_4_0.drawNum + 1

			gGameApp:requestServer("/game/clone/box/draw", var_4_0)
		end
	end
end

function var_0_0.dealDealyTime(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0:getResourceNode()
	local var_9_1 = var_9_0:get("receiveBtn")
	local var_9_2 = var_9_0:get("backBtn")

	var_9_1:setEnabled(arg_9_1)
	var_9_2:setEnabled(arg_9_1)
end

function var_0_0.onBackBtnClick(arg_10_0)
	gGameUI:switchUI("city.view")
	gGameUI:goBackInStackUI("city.adventure.clone_battle.base")
end

return var_0_0
