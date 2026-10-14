local var_0_0 = class("SimpleActivityWinView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "battle_end_frags_win.json"
var_0_0.RESOURCE_BINDING = {
	awardsList = "awardsList",
	["cardItem.card"] = "awardsItem",
	bkg = {
		binds = {
			event = "click",
			method = bindHelper.self("onQuitClick")
		}
	}
}

function var_0_0.playEndEffect(arg_1_0)
	local var_1_0 = arg_1_0:getResourceNode()
	local var_1_1, var_1_2 = var_1_0:get("title"):getPosition()
	local var_1_3 = CSprite.new("effect/gongxihuode.skel")

	var_1_3:addTo(var_1_0, 100)
	var_1_3:setAnchorPoint(cc.p(0.5, 1))
	var_1_3:setPosition(var_1_1, var_1_2)
	var_1_3:visible(true)
	var_1_3:setName("spine_1")
	var_1_3:play("effect")
	var_1_3:addPlay("effect_loop")
	var_1_3:retain()
end

function var_0_0.onCreate(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	audio.playEffectWithWeekBGM("gate_win.mp3")

	arg_2_0.data = arg_2_2
	arg_2_0.results = arg_2_3
	arg_2_0.sceneID = arg_2_1

	local var_2_0 = arg_2_0:getResourceNode()
	local var_2_1 = arg_2_2.preData or {}
	local var_2_2 = var_2_1.roleInfo or {}
	local var_2_3 = var_2_1.cardsInfo or {}
	local var_2_4 = arg_2_3.serverData.view.drop or {}
	local var_2_5 = arg_2_3.serverData.view.award or {}
	local var_2_6 = {}

	for iter_2_0, iter_2_1 in pairs(var_2_4) do
		var_2_6[iter_2_0] = iter_2_1
	end

	for iter_2_2, iter_2_3 in pairs(var_2_5) do
		if not var_2_6[iter_2_2] then
			var_2_6[iter_2_2] = iter_2_3
		else
			var_2_6[iter_2_2] = var_2_6[iter_2_2] + iter_2_3
		end
	end

	local var_2_7 = csv.scene_conf[arg_2_1]

	var_2_0:get("levelText"):text(gLanguageCsv.roleLevel .. " :")

	local var_2_8 = gGameModel.role:read("level")

	var_2_0:get("level"):text(var_2_8 or 1)

	local var_2_9 = csv.base_attribute.role_level[var_2_2.level].levelExp or 10
	local var_2_10 = var_2_2.level_exp or 1
	local var_2_11 = var_2_7.roleExp or 1
	local var_2_12 = var_2_10 + var_2_11
	local var_2_13 = 1.1

	local function var_2_14(arg_3_0, arg_3_1, arg_3_2)
		var_2_0:get("expBar.expNew"):setPercent(arg_3_0)
		transition.executeSequence(var_2_0:get("expBar.expNew")):progressTo(var_2_13, arg_3_1):func(function()
			if arg_3_2 then
				arg_3_2()
			end
		end):done()
	end

	local function var_2_15(arg_5_0, arg_5_1)
		local var_5_0 = arg_5_0 - arg_5_1

		if var_5_0 >= 0 then
			var_2_13 = 0.5

			var_2_14(math.floor(var_2_10 / arg_5_1 * 100), 100, function()
				local var_6_0 = (var_2_2.level or 1) + 1

				arg_5_1 = csv.base_attribute.role_level[var_6_0].levelExp or 10

				var_2_0:get("expBar.expNew"):setPercent(0)

				var_2_10 = 0

				var_2_15(var_5_0, arg_5_1)
			end)
		else
			var_2_14(math.floor(var_2_10 / arg_5_1 * 100), math.floor(arg_5_0 / arg_5_1 * 100))
		end
	end

	var_2_0:get("exp"):text("+" .. var_2_11)
	var_2_15(var_2_12, var_2_9)
	arg_2_0:playEndEffect()

	if arg_2_3.flag == "gym" then
		var_2_0:get("expText"):hide()
		var_2_0:get("cardsList"):hide()

		local var_2_16 = var_2_0:get("bkg"):y()

		var_2_0:get("awardsText"):y(var_2_16 - 64)
		arg_2_0.awardsList:y(var_2_16 - 228)
	else
		var_2_0:get("expText"):text(gLanguageCsv.exps .. " :")

		local function var_2_17(arg_7_0, arg_7_1)
			local var_7_0 = arg_2_2.roleOut[arg_7_0.id]
			local var_7_1 = gGameModel.cards:find(arg_7_0.cardId or var_7_0.cardId)
			local var_7_2 = var_7_1:read("level_exp")
			local var_7_3 = var_7_1:read("next_level_exp")
			local var_7_4 = var_7_3 < var_7_2 + arg_7_1
			local var_7_5 = 0

			if var_7_4 then
				local var_7_6 = var_7_2 + arg_7_1
				local var_7_7 = csv.unit[arg_7_0.unitId]
				local var_7_8 = csv.cards[var_7_7.cardID].levelExpID

				while var_7_3 < var_7_6 do
					var_7_5 = var_7_5 + 1
					var_7_6 = var_7_6 - var_7_3

					if arg_7_0.level + var_7_5 >= 100 then
						break
					end

					var_7_3 = csv.base_attribute.card_level[arg_7_0.level + var_7_5]["levelExp" .. var_7_8]
				end
			end

			return var_7_4, var_7_5
		end

		local var_2_18 = var_2_0:get("cardsList")

		var_2_18:setScrollBarEnabled(false)
		var_2_18:setItemsMargin(25)

		for iter_2_4, iter_2_5 in ipairs(var_2_3) do
			local var_2_19, var_2_20 = var_2_17(iter_2_5, var_2_7.cardExp)
			local var_2_21 = var_2_0:get("cardItem"):clone()
			local var_2_22 = var_2_21:get("card")

			bind.extend(arg_2_0, var_2_22, {
				class = "card_icon",
				props = {
					unitId = iter_2_5.unitId,
					advance = iter_2_5.advance,
					star = iter_2_5.star,
					rarity = csv.unit[iter_2_5.unitId].rarity,
					levelProps = {
						data = iter_2_5.level + var_2_20
					},
					onNode = function(arg_8_0)
						return
					end
				}
			})
			var_2_21:get("exp"):text("EXP+" .. var_2_7.cardExp)
			var_2_21:get("levelUp"):visible(var_2_19)
			var_2_18:pushBackCustomItem(var_2_21)
		end
	end

	var_2_0:get("awardsText"):text(gLanguageCsv.getAwards .. " :")

	local var_2_23 = {}

	for iter_2_6, iter_2_7 in pairs(var_2_6) do
		table.insert(var_2_23, {
			key = iter_2_6,
			num = iter_2_7
		})
	end

	if next(var_2_23) then
		arg_2_0:showItem(1, var_2_23)
	end

	gGameUI:disableTouchDispatch(nil, false)
	transition.executeSequence(arg_2_0):delay(0.25):func(function()
		if var_2_8 - var_2_2.level > 0 then
			gGameUI:stackUI("common.upgrade_notice", nil, nil, var_2_2.level)
		end

		gGameUI:disableTouchDispatch(nil, true)
	end):done()
end

function var_0_0.showItem(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0.awardsItem:clone()

	var_10_0:show()

	local var_10_1 = arg_10_2[arg_10_1].key
	local var_10_2 = arg_10_2[arg_10_1].num
	local var_10_3 = {
		class = "icon_key",
		props = {
			data = {
				key = var_10_1,
				num = var_10_2
			},
			isDouble = dataEasy.isGateIdDoubleDrop(arg_10_0.sceneID),
			onNode = function(arg_11_0)
				local var_11_0, var_11_1 = arg_11_0:xy()

				arg_11_0:xy(var_11_0, var_11_1 + 3)
				arg_11_0:hide():z(2)
				transition.executeSequence(arg_11_0, true):delay(0.5):func(function()
					arg_11_0:show()
				end):done()
			end
		}
	}

	bind.extend(arg_10_0, var_10_0, var_10_3)
	arg_10_0.awardsList:setItemsMargin(25)
	arg_10_0.awardsList:pushBackCustomItem(var_10_0)
	arg_10_0.awardsList:setScrollBarEnabled(false)
	transition.executeSequence(arg_10_0.awardsList):delay(0.1):func(function()
		if arg_10_1 < table.length(arg_10_2) then
			arg_10_0:showItem(arg_10_1 + 1, arg_10_2)
		end
	end):done()
end

function var_0_0.onQuitClick(arg_14_0)
	gGameUI:switchUI("city.view")
end

return var_0_0
