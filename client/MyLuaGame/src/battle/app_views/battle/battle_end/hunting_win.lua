local var_0_0 = class("HuntingWinView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "battle_end_hunting_win.json"
var_0_0.RESOURCE_BINDING = {
	awardsList = "awardsList",
	awardsItem = "awardsItem",
	bkg = {
		binds = {
			event = "click",
			method = bindHelper.self("onQuitClick")
		}
	}
}

function var_0_0.playEndEffect(arg_1_0)
	local var_1_0 = arg_1_0.data
	local var_1_1 = arg_1_0:getResourceNode()

	if not var_1_0.preData then
		local var_1_2 = {}
	end

	local var_1_3 = widget.addAnimation(var_1_1, "effect/gongxihuode.skel", "effect", 100)

	var_1_3:anchorPoint(cc.p(0.5, 1)):scale(2):xy(display.cx, display.cy):play("jiesuan_shenglitu_new")
	var_1_3:addPlay("jiesuan_shenglitu_new_loop")

	arg_1_0.bestCardId = var_1_0.roleOut[arg_1_0.results.mvpPosId].roleId

	local var_1_4 = csv.unit[arg_1_0.bestCardId].unitRes
	local var_1_5 = string.gsub(var_1_4, ".skel", "_ui.skel")
	local var_1_6 = CSprite.new(var_1_5)

	var_1_6:addTo(var_1_1, 100)
	var_1_6:setAnchorPoint(cc.p(0.5, 1))
	var_1_6:setPosition(display.cx / 4, -188)
	var_1_6:play("standby_loop")
	var_1_6:scale(2)
end

function var_0_0.onCreate(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	audio.playEffectWithWeekBGM("gate_win.mp3")

	arg_2_0.data = arg_2_3
	arg_2_0.results = arg_2_4
	arg_2_0.sceneID = arg_2_2

	local var_2_0 = arg_2_0:getResourceNode()

	arg_2_0:playEndEffect()
	arg_2_0:showCardStateInfo()

	local var_2_1 = var_2_0:get("awardsText")

	var_2_1:text(gLanguageCsv.getAwards .. ":")

	local var_2_2 = arg_2_4.serverData.drop or {}
	local var_2_3 = dataEasy.mergeRawDate(var_2_2)

	if next(var_2_3) then
		arg_2_0:showItem(1, var_2_3)
	else
		local var_2_4, var_2_5 = var_2_1:xy()

		var_2_1:xy(var_2_4 + 325, var_2_5)
		var_2_1:text(gLanguageCsv.passAwardsAlreadyToplimit)
		arg_2_0.awardsList:hide()
	end
end

function var_0_0.showItem(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0.awardsItem:clone()

	var_3_0:show()

	local var_3_1 = arg_3_2[arg_3_1].key
	local var_3_2 = arg_3_2[arg_3_1].num
	local var_3_3 = arg_3_2[arg_3_1].dbId
	local var_3_4 = {
		class = "icon_key",
		props = {
			data = {
				key = var_3_1,
				num = var_3_2,
				dbId = var_3_3
			},
			isDouble = dataEasy.isGateIdDoubleDrop(arg_3_0.sceneID),
			onNode = function(arg_4_0)
				local var_4_0, var_4_1 = arg_4_0:xy()

				arg_4_0:xy(var_4_0, var_4_1 + 3)
				arg_4_0:hide():z(2)
				transition.executeSequence(arg_4_0, true):delay(0.5):func(function()
					arg_4_0:show()
				end):done()
			end
		}
	}

	bind.extend(arg_3_0, var_3_0, var_3_4)
	arg_3_0.awardsList:setItemsMargin(25)
	arg_3_0.awardsList:pushBackCustomItem(var_3_0)
	arg_3_0.awardsList:setScrollBarEnabled(false)
	transition.executeSequence(arg_3_0.awardsList):delay(0.1):func(function()
		if arg_3_1 < table.length(arg_3_2) then
			arg_3_0:showItem(arg_3_1 + 1, arg_3_2)
		end
	end):done()
end

function var_0_0.showCardStateInfo(arg_7_0)
	local var_7_0 = arg_7_0.results
	local var_7_1 = arg_7_0:getResourceNode()
	local var_7_2 = var_7_0.cardStates or {}
	local var_7_3 = arg_7_0.data.roleOut or {}
	local var_7_4 = var_7_1:get("cardsList")

	var_7_4:setScrollBarEnabled(false)
	var_7_4:setItemsMargin(25)

	for iter_7_0, iter_7_1 in pairs(var_7_3) do
		if iter_7_0 <= 6 then
			local var_7_5 = var_7_1:get("cardItem"):clone()

			var_7_4:pushBackCustomItem(var_7_5)
			bind.extend(arg_7_0, var_7_5:get("card"), {
				class = "card_icon",
				props = {
					unitId = iter_7_1.roleId,
					advance = iter_7_1.advance,
					star = iter_7_1.star,
					rarity = csv.unit[iter_7_1.roleId].rarity
				}
			})

			local var_7_6 = var_7_2[iter_7_1.cardId]

			if var_7_6 then
				var_7_5:get("hpBar"):setPercent(math.floor(var_7_6[1] * 100))
				var_7_5:get("mpBar"):setPercent(math.floor(var_7_6[2] * 100))
				var_7_5:get("mask"):visible(var_7_6[1] <= 0)
			end
		end
	end
end

function var_0_0.onQuitClick(arg_8_0)
	gGameUI:switchUI("city.view")
end

return var_0_0
