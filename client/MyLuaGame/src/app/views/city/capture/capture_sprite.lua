local var_0_0 = {
	"diuqiu_effect",
	"cjq_diuqiu_effect",
	"dsq_diuqiu_effect"
}
local var_0_1 = {
	"chenggong_effect",
	"cjq_chenggong_effect",
	"dsq_chenggong_effect"
}
local var_0_2 = {
	"jinglinqiu_effect_loop",
	"cjq_jinglinqiu_effect_loop",
	"dsq_jinglinqiu_effect_loop"
}
local var_0_3 = {
	"shibai1_effect",
	"shibai2_effect",
	"shibai3_effect"
}
local var_0_4 = {
	{
		"shibai1_effect",
		"shibai2_effect",
		"shibai3_effect"
	},
	{
		"cjq_shibai1_effect",
		"cjq_shibai2_effect",
		"cjq_shibai3_effect"
	},
	{
		"dsq_shibai1_effect",
		"dsq_shibai2_effect",
		"dsq_shibai3_effect"
	}
}
local var_0_5 = {
	"capture/shibai1_effect.mp3",
	"capture/shibai2_effect.mp3",
	"capture/shibai3_effect.mp3"
}
local var_0_6 = cc.load("mvc").ViewBase
local var_0_7 = class("CaptureSpriteView", var_0_6)

var_0_7.RESOURCE_FILENAME = "capture_sprite.json"
var_0_7.RESOURCE_BINDING = {
	bg = "bg",
	btn1 = "btn1",
	ball3 = "ball3",
	btn3 = "btn3",
	btn2 = "btn2",
	titleUp = "titleUp",
	ball1 = "ball1",
	anima = "anima",
	ball2 = "ball2"
}
var_0_7.RESOURCE_STYLES = {
	full = true
}

local function var_0_8(arg_1_0)
	for iter_1_0, iter_1_1 in orderCsvPairs(csv.capture.probability) do
		if arg_1_0 >= iter_1_1.probability then
			return iter_1_1.desc
		end
	end

	return ""
end

function var_0_7.initModel(arg_2_0)
	arg_2_0.level = gGameModel.capture:getIdler("level")
	arg_2_0.captureNumber = gGameModel.role:getIdler("items")
	arg_2_0.limit = gGameModel.capture:getIdler("limit_sprites")
	arg_2_0.levelBall = gGameModel.role:getIdler("level")
	arg_2_0.gold = gGameModel.role:getIdler("gold")
end

function var_0_7.onCreate(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	gGameUI.topuiManager:createView("title", arg_3_0, {
		onClose = arg_3_0:createHandler("onClose")
	}):init({
		subTitle = "CATCH",
		title = gLanguageCsv.capture
	})

	arg_3_0.cb = arg_3_3
	arg_3_0.gateId = arg_3_2
	arg_3_0.captureTab = arg_3_1
	arg_3_0.numberUsed = arg_3_1.sceneTimes

	arg_3_0:initModel()

	arg_3_0.itemMove = true
	arg_3_0.ballData = true
	arg_3_0.captureTabId = {
		523,
		524,
		525
	}
	arg_3_0.timeTab = {
		5,
		4,
		3
	}

	local var_3_0 = {
		600,
		100,
		-400
	}

	arg_3_0.animaData = {
		btnClickState = 1,
		closeDate = true
	}

	local var_3_1 = csv.cards[arg_3_1.cardID].unitID
	local var_3_2 = csv.unit[var_3_1]
	local var_3_3 = var_3_2.scale * gCommonConfigCsv.captureSprite

	arg_3_0.cardSprite = widget.addAnimation(arg_3_0.anima:get("state"), var_3_2.unitRes, "standby_loop", 5):alignCenter(arg_3_0.anima:get("state"):size()):scale(var_3_3)

	arg_3_0.cardSprite:setSkin(var_3_2.skin)

	arg_3_0.captureBgAnima = widget.addAnimation(arg_3_0.bg, "diuqiu/buzhuo_di.skel", "daiji_loop", 3):alignCenter(arg_3_0.bg:size())

	arg_3_0.titleUp:get("number"):text(arg_3_0.numberUsed .. "/" .. arg_3_0.numberUsed)
	idlereasy.when(arg_3_0.captureNumber, function(arg_4_0, arg_4_1)
		local var_4_0 = csv.capture.level[arg_3_0.level:read()].rateUp

		for iter_4_0 = 1, 3 do
			if arg_3_0.captureNumber:read()[arg_3_0.captureTabId[iter_4_0]] then
				arg_3_0["btn" .. iter_4_0]:get("title.number"):text("x " .. arg_3_0.captureNumber:read()[arg_3_0.captureTabId[iter_4_0]])
			else
				arg_3_0["btn" .. iter_4_0]:get("title.number"):text("x " .. 0)
			end
		end
	end)
	idlereasy.when(arg_3_0.level, function(arg_5_0, arg_5_1)
		local var_5_0 = csv.capture.level[arg_3_0.level:read()].rateUp
		local var_5_1

		if arg_3_0.animaData.btnClickData then
			local var_5_2 = math.floor(var_5_0 * arg_3_1["rate" .. arg_3_0.animaData.btnClickData])

			arg_3_0["btn" .. arg_3_0.animaData.btnClickData]:get("success.success"):text(var_0_8(var_5_2))
		else
			for iter_5_0 = 1, 3 do
				local var_5_3 = math.floor(var_5_0 * arg_3_1["rate" .. iter_5_0])

				arg_3_0["btn" .. iter_5_0]:get("success.success"):text(var_0_8(var_5_3))
			end
		end
	end)

	for iter_3_0 = 1, 3 do
		arg_3_0["ball" .. iter_3_0]:addTouchEventListener(function(arg_6_0, arg_6_1)
			if arg_6_1 == ccui.TouchEventType.began then
				arg_3_0.ballNumber = arg_3_0.captureNumber:read()[arg_3_0.captureTabId[iter_3_0]]

				if not arg_3_0.ballNumber or arg_3_0.ballNumber <= 0 then
					arg_3_0.ballData = false

					arg_3_0["btn" .. iter_3_0]:get("title.number"):text("x " .. 0)

					if iter_3_0 == 1 then
						gGameUI:showTip(gLanguageCsv.captureBallNotEnough)
						arg_3_0:buyerBall(iter_3_0)
					elseif iter_3_0 == 2 then
						gGameUI:showTip(gLanguageCsv.canBuyInBoutique)
					else
						gGameUI:showTip(gLanguageCsv.getInActOrMysteryShop)
					end

					return
				else
					arg_3_0.ballData = true
				end

				if arg_3_0.animaData.btnClickState == 1 then
					arg_3_0["ball" .. iter_3_0]:setEnabled(false)

					arg_3_0.animaData.btnClickState = 2
					arg_3_0.animaData.btnClickData = iter_3_0

					if not arg_3_0.spriteBall and not arg_3_0.guideBall then
						arg_3_0.spriteBall = widget.addAnimation(arg_3_0["ball" .. iter_3_0]:get("ball"), "diuqiu/buzhuo.skel", var_0_2[iter_3_0], 3):alignCenter(arg_3_0["ball" .. iter_3_0]:get("ball"):size()):scale(1.8)
						arg_3_0.guideBall = widget.addAnimation(arg_3_0["ball" .. iter_3_0], "diuqiu/buzhuo.skel", "yindao_effect_loop", 3):xy(arg_3_0.spriteBall:x() + 260, arg_3_0.spriteBall:y() + 400):scale(0.65)
					end

					arg_3_0:captureChangeView(iter_3_0, -1000)
				end

				arg_3_0.touchBeganPos = arg_6_0:getTouchBeganPosition()
				arg_3_0.btnClickView = false
			elseif arg_6_1 == ccui.TouchEventType.moved then
				if not arg_3_0.ballData then
					return
				end

				if arg_3_0.animaData.btnClickState ~= 2 then
					return
				end

				if arg_6_0:getTouchMovePosition().y - arg_3_0.touchBeganPos.y >= 20 then
					arg_3_0.btnClickView = true
				else
					arg_3_0.btnClickView = false
				end
			elseif arg_6_1 == ccui.TouchEventType.ended or arg_6_1 == ccui.TouchEventType.canceled then
				if arg_3_0.animaData.btnClickState ~= 2 then
					return
				end

				if not arg_3_0.btnClickView then
					arg_3_0:captureChangeView(iter_3_0, 0)

					return
				end

				if not arg_3_0.ballData then
					return
				end

				arg_3_0.animaData.closeDate = false

				audio.playEffectWithWeekBGM("capture/diuqiu_effect.mp3")

				if arg_3_0.spriteBall or arg_3_0.guideBall then
					arg_3_0.spriteBall:hide()
					arg_3_0.guideBall:hide()
				end

				arg_3_0.animaData.btnClickState = 3
				arg_3_0.castBallAnima = widget.addAnimation(arg_3_0["ball" .. iter_3_0]:get("castAnima"), "diuqiu/buzhuo.skel", var_0_0[iter_3_0], 5):xy(var_3_0[iter_3_0], 600):scale(2)

				performWithDelay(arg_3_0, function()
					arg_3_0.anima:runAction(cc.Sequence:create(cc.ScaleBy:create(0.2, 0.3), cc.CallFunc:create(function()
						arg_3_0.cardSprite:visible(false)
					end)))
				end, 0.8)
				performWithDelay(arg_3_0, function()
					if arg_3_0.castBallAnima then
						arg_3_0.castBallAnima:removeFromParent()

						arg_3_0.castBallAnima = nil
					end

					arg_3_0:onChangeClick(iter_3_0)
				end, 1.3)
			end
		end)
	end
end

function var_0_7.captureChangeView(arg_10_0, arg_10_1, arg_10_2)
	if arg_10_0.itemMove and arg_10_2 >= 0 or not arg_10_0.itemMove and arg_10_2 < 0 then
		return
	end

	for iter_10_0 = 1, 3 do
		arg_10_0["btn" .. iter_10_0]:stopAllActions()

		if arg_10_1 ~= iter_10_0 then
			arg_10_0["btn" .. iter_10_0]:runAction(cc.MoveTo:create(0.2, cc.p(arg_10_0["btn" .. iter_10_0]:x(), 283 + arg_10_2)))
			arg_10_0["ball" .. iter_10_0]:visible(arg_10_2 >= 0)
		end
	end

	if arg_10_2 >= 0 then
		arg_10_0["btn" .. arg_10_1]:visible(true)
		arg_10_0["btn" .. arg_10_1]:scale(1)

		if arg_10_0.spriteBall and arg_10_0.guideBall then
			arg_10_0.spriteBall:removeFromParent()

			arg_10_0.spriteBall = nil

			arg_10_0.guideBall:removeFromParent()

			arg_10_0.guideBall = nil
		end

		arg_10_0.animaData.closeDate = true
		arg_10_0.itemMove = true

		arg_10_0["ball" .. arg_10_1]:setEnabled(true)

		arg_10_0.animaData.btnClickState = 1
	else
		arg_10_0["btn" .. arg_10_1]:visible(false)

		arg_10_0.itemMove = false
	end
end

function var_0_7.onChangeClick(arg_11_0, arg_11_1)
	local var_11_0 = math.random(1, 3)

	gGameApp:requestServer("/game/capture", function(arg_12_0)
		if csvNext(arg_12_0.view.result) then
			if not arg_11_0.resultAnima then
				arg_11_0.resultAnima = widget.addAnimation(arg_11_0.anima, "diuqiu/buzhuo.skel", var_0_1[arg_11_1], 2):scale(5):alignCenter(arg_11_0.anima:size())

				arg_11_0.resultAnima:y(arg_11_0.resultAnima:y() - 40)
			else
				arg_11_0.resultAnima:show():play(var_0_1[arg_11_1])
				arg_11_0.resultAnima:scale(5)
			end

			arg_11_0.captureBgAnima:play("chenggong_effect")
			audio.playEffectWithWeekBGM("capture/chenggong_effect.mp3")

			local var_12_0 = {
				db_id = arg_12_0.view.result.carddbIDs[1][1],
				first = arg_12_0.view.result.carddbIDs[1][2]
			}

			performWithDelay(arg_11_0, function()
				gGameUI:stackUI("common.gain_sprite", nil, {
					full = true
				}, var_12_0, nil, false, arg_11_0:createHandler("captureWin"))
			end, 5.5)
		else
			audio.playEffectWithWeekBGM(var_0_5[var_11_0])
			arg_11_0.captureBgAnima:play(var_0_3[var_11_0])

			if not arg_11_0.resultAnima then
				arg_11_0.resultAnima = widget.addAnimation(arg_11_0.anima, "diuqiu/buzhuo.skel", var_0_4[arg_11_1][var_11_0], 2):alignCenter(arg_11_0.anima:size()):scale(5)

				arg_11_0.resultAnima:y(arg_11_0.resultAnima:y() - 40)
			else
				arg_11_0.resultAnima:show():play(var_0_4[arg_11_1][var_11_0])
				arg_11_0.resultAnima:scale(5)
			end

			performWithDelay(arg_11_0, function()
				audio.playEffectWithWeekBGM("capture/fanhui_effect.mp3")
			end, arg_11_0.timeTab[var_11_0] - 1)
			performWithDelay(arg_11_0, function()
				arg_11_0.titleUp:get("number"):text(arg_11_0.numberUsed - arg_12_0.view.scene_times .. "/" .. arg_11_0.numberUsed)
				arg_11_0.resultAnima:scale(3)
				arg_11_0.resultAnima:play("fanhui_effect")
				arg_11_0.captureBgAnima:play("fanhui_effect")
				performWithDelay(arg_11_0, function()
					arg_11_0.cardSprite:visible(true)
					arg_11_0.anima:scale(1)
				end, 0.3)
				performWithDelay(arg_11_0, function()
					arg_11_0.captureBgAnima:play("daiji_loop")
					arg_11_0:captureChangeView(arg_11_1, 0)

					if arg_12_0.view.scene_times == arg_11_0.numberUsed then
						gGameUI:stackUI("city.capture.capture_over", nil, nil, arg_11_0:createHandler("captSpriteCloseView"))

						return
					end
				end, 0.8)
			end, arg_11_0.timeTab[var_11_0])
		end
	end, arg_11_0.captureTab.type, arg_11_0.gateId, arg_11_0.captureTabId[arg_11_1])
end

function var_0_7.captureWin(arg_18_0)
	arg_18_0:captureChangeView(arg_18_0.animaData.btnClickData, 0)
	arg_18_0:captSpriteCloseView()
end

function var_0_7.buyerBall(arg_19_0, arg_19_1)
	if arg_19_1 ~= 1 then
		gGameUI:showTip(gLanguageCsv.captureBallNotEnough)

		return
	end

	local var_19_0 = csv.items[game.SPRITE_BALL_ID.normal].specialArgsMap.buy_gold
	local var_19_1 = 100

	gGameUI:stackUI("common.buy_info", nil, nil, {
		gold = var_19_0
	}, {
		id = game.SPRITE_BALL_ID.normal
	}, {
		contentType = "num",
		maxNum = var_19_1
	}, arg_19_0:createHandler("showBuyInfo"))
end

function var_0_7.showBuyInfo(arg_20_0, arg_20_1)
	if csv.items[game.SPRITE_BALL_ID.normal].specialArgsMap.buy_level > arg_20_0.levelBall:read() then
		gGameUI:showTip(gLanguageCsv.buyItemLevelLimit)

		return
	else
		gGameApp:requestServer("/game/ball/buy_item", function(arg_21_0)
			gGameUI:showTip(gLanguageCsv.hasBuy)
		end, game.SPRITE_BALL_ID.normal, arg_20_1)
	end
end

function var_0_7.onClose(arg_22_0)
	if not arg_22_0.animaData.closeDate then
		return
	end

	gGameUI:showDialog({
		clearFast = true,
		btnType = 2,
		title = gLanguageCsv.abandon,
		content = gLanguageCsv.spriteClose,
		cb = function()
			var_0_6.onClose(arg_22_0)
		end
	})
end

function var_0_7.captSpriteCloseView(arg_24_0, arg_24_1)
	if arg_24_0.cb then
		arg_24_0.cb(arg_24_1)
	end
end

return var_0_7
