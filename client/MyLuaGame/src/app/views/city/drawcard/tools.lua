local var_0_0 = {}

function var_0_0.hasCard(arg_1_0)
	local var_1_0 = {}
	local var_1_1 = -1
	local var_1_2 = csv.cards
	local var_1_3 = csv.unit
	local var_1_4

	for iter_1_0, iter_1_1 in ipairs(arg_1_0) do
		if iter_1_1.key == "card" then
			local var_1_5 = var_1_3[var_1_2[iter_1_1.num.id].unitID].rarity

			if var_1_1 < var_1_5 then
				var_1_1 = var_1_5
				var_1_4 = iter_1_1
			end
		elseif var_0_0.is2choose1item(iter_1_1[1]) then
			local var_1_6 = dataEasy.getCfgByKey(iter_1_1[1])
			local var_1_7 = math.random(1, 2)

			if var_1_6.specialArgsMap["choose" .. var_1_7].card then
				var_1_4 = {
					num = {
						id = var_1_6.specialArgsMap["choose" .. var_1_7].card.id
					}
				}
			end
		end
	end

	if var_1_4 then
		table.insert(var_1_0, var_1_4)
	end

	return #var_1_0 > 0, var_1_0
end

function var_0_0.is2choose1item(arg_2_0)
	if not arg_2_0 then
		return false
	end

	local var_2_0 = dataEasy.getCfgByKey(arg_2_0)

	if var_2_0 and var_2_0.type == game.ITEM_TYPE_ENUM_TABLE.chooseGift and var_2_0.specialArgsMap and csvSize(var_2_0.specialArgsMap) == 2 then
		for iter_2_0, iter_2_1 in csvMapPairs(var_2_0.specialArgsMap) do
			if not iter_2_1.card then
				return false
			end
		end

		return true
	end

	return false
end

function var_0_0.addLight(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_1.parent
	local var_3_1 = arg_3_1.parentEffect
	local var_3_2 = arg_3_1.datas
	local var_3_3 = arg_3_1.count
	local var_3_4 = arg_3_1.cloneItem
	local var_3_5 = csv.cards
	local var_3_6 = csv.unit

	for iter_3_0 = 1, var_3_3 do
		local var_3_7 = var_3_2[iter_3_0]
		local var_3_8 = var_3_7.key == "card"
		local var_3_9 = var_3_4:clone()

		var_3_9:addTo(var_3_0, 1000)
		var_3_9:show()

		local var_3_10 = {
			class = "icon_key",
			props = {
				effect = "drawcard",
				data = {
					key = var_3_8 and "card" or var_3_7[1],
					num = var_3_8 and var_3_7.num.id or var_3_7[2]
				}
			}
		}

		bind.extend(arg_3_0, var_3_9, var_3_10)

		local var_3_11 = false

		if var_3_8 then
			var_3_11 = var_3_6[var_3_5[var_3_7.num.id].unitID].rarity >= 4
		end

		local var_3_12 = var_3_11 and "effect_gjguangquan_loop" or "effect_guangquan_loop"

		widget.addAnimationByKey(var_3_9, "effect/xianshichouka.skel", "guanquan", var_3_12, 1000):scale(2):alignCenter(var_3_9:size())

		local var_3_13 = cc.RepeatForever:create(cc.Sequence:create(cc.CallFunc:create(function()
			local var_4_0, var_4_1 = var_3_1:getPosition()
			local var_4_2 = "icon_move" .. iter_3_0
			local var_4_3 = var_3_1:getScaleX()
			local var_4_4 = var_3_1:getScaleY()
			local var_4_5 = var_3_1:getBonePosition(var_4_2)
			local var_4_6 = var_3_1:getBoneRotation(var_4_2)
			local var_4_7 = var_3_1:getBoneScaleX(var_4_2)
			local var_4_8 = var_3_1:getBoneScaleY(var_4_2)

			var_3_9:rotate(var_4_6):scaleX(var_4_7):scaleY(var_4_8):xy(var_4_5.x * var_4_3 + var_4_0, var_4_5.y * var_4_4 + var_4_1)
		end)))

		var_3_9:runAction(var_3_13)
	end
end

function var_0_0.addCardImg(arg_5_0, arg_5_1)
	local var_5_0 = 0
	local var_5_1 = arg_5_1:getChildByName("effect")

	for iter_5_0, iter_5_1 in ipairs(arg_5_0) do
		var_5_0 = (iter_5_0 - 1) * 70 / 30

		local var_5_2 = arg_5_1:getChildByName("showCard")

		performWithDelay(arg_5_1, function()
			local var_6_0 = csv.cards[iter_5_1.num.id].unitID
			local var_6_1 = csv.unit[var_6_0]

			if not var_5_2 then
				var_5_2 = ccui.ImageView:create(var_6_1.cardShow):alignCenter(arg_5_1:size()):addTo(arg_5_1, 20, "showCard")
			else
				var_5_2:texture(var_6_1.cardShow)
			end

			var_5_2:setColor(cc.c3b(0, 0, 0))

			local var_6_2 = cc.RepeatForever:create(cc.Sequence:create(cc.CallFunc:create(function()
				local var_7_0, var_7_1 = var_5_1:getPosition()
				local var_7_2 = "jingling_move1"
				local var_7_3 = var_5_1:getScaleX()
				local var_7_4 = var_5_1:getScaleY()
				local var_7_5 = var_5_1:getBonePosition(var_7_2)
				local var_7_6 = var_5_1:getBoneRotation(var_7_2)
				local var_7_7 = var_5_1:getBoneScaleX(var_7_2)
				local var_7_8 = var_5_1:getBoneScaleY(var_7_2)

				var_5_2:rotate(var_7_6):scaleX(var_7_7):scaleY(var_7_8):xy(var_7_5.x * var_7_3 + var_7_0, var_7_5.y * var_7_4 + var_7_1)
			end)))

			var_5_2:runAction(var_6_2)
		end, var_5_0)
	end

	return var_5_0 - 0.13333333333333333
end

return var_0_0
