local var_0_0 = class("BuffIcon", battleModule.CBase)

local function var_0_1()
	local var_1_0 = cc.Node:create()

	var_1_0.prevVisible = nil

	return var_1_0
end

local function var_0_2(arg_2_0, arg_2_1)
	if arg_2_0.prevVisible ~= arg_2_1 then
		arg_2_0:setVisible(arg_2_1)

		arg_2_0.prevVisible = arg_2_1
	end
end

function var_0_0.ctor(arg_3_0, arg_3_1)
	battleModule.CBase.ctor(arg_3_0, arg_3_1)

	arg_3_0.layer = arg_3_0.parent.gameLayer
	arg_3_0.layerPos = arg_3_0.layer:convertToWorldSpace(cc.p(0, 0))
	arg_3_0.buffTexts = {}
	arg_3_0.units = {}
end

function var_0_0.getRecord(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = tostring(arg_4_1)
	local var_4_1 = arg_4_0.units[var_4_0]

	if var_4_1 == nil and arg_4_2 then
		var_4_1 = {
			buffLastIndex = 0,
			lineLimit = 5,
			visible = true,
			buffEffectsMap = {},
			delArray = {},
			shadowNode = cc.Node:create(),
			buffGroupNode = var_0_1(),
			buffOverlayNode = var_0_1(),
			buffTextNode = var_0_1()
		}
		arg_4_0.units[var_4_0] = var_4_1

		var_4_1.shadowNode:addTo(arg_4_1.lifebar):xy(cc.pSub(arg_4_1.lifebar.buffAddFirstPos, arg_4_0.layerPos))

		local var_4_2 = var_4_1.shadowNode:convertToWorldSpace(cc.p(0, 0))

		var_4_1.buffGroupNode:addTo(arg_4_0.layer, battle.GameLayerZOrder.icon + arg_4_1.posZ):xy(var_4_2)
		var_4_1.buffOverlayNode:addTo(arg_4_0.layer, battle.GameLayerZOrder.overlay + arg_4_1.posZ):xy(var_4_2)
		var_4_1.buffTextNode:addTo(arg_4_0.layer, battle.GameLayerZOrder.text):xy(cc.pAdd(cc.p(arg_4_1:getPosition()), arg_4_1.unitCfg.everyPos.headPos))

		local var_4_3

		var_4_3 = var_4_1.shadowNode:onNodeEvent("exit", function()
			var_4_3:remove()

			arg_4_0.units[var_4_0] = nil

			for iter_5_0, iter_5_1 in pairs(var_4_1.buffEffectsMap) do
				removeCSprite(iter_5_1)
				iter_5_1:hide()
			end

			performWithDelay(arg_4_0.layer, function()
				var_4_1.buffGroupNode:removeSelf()
				var_4_1.buffOverlayNode:removeSelf()
				var_4_1.buffTextNode:removeSelf()
			end, 0)
		end)

		local var_4_4 = cc.p(0, 0)

		var_4_1.shadowNode:scheduleUpdate(function()
			local var_7_0, var_7_1 = arg_4_1:getPosition()

			if var_4_4.x ~= var_7_0 or var_4_4.y ~= var_7_1 or arg_4_1.refreshBuffIconOnce then
				var_4_4 = cc.p(var_7_0, var_7_1)

				local var_7_2 = var_4_1.shadowNode:convertToWorldSpace(cc.p(0, 0))

				var_4_1.buffGroupNode:setPosition(var_7_2)
				var_4_1.buffOverlayNode:setPosition(var_7_2)

				arg_4_1.refreshBuffIconOnce = false

				var_4_1.buffTextNode:setPosition(cc.pAdd(var_4_4, arg_4_1.unitCfg.everyPos.headPos))
			end

			local var_7_3 = var_4_1.visible and arg_4_1:visible()

			var_0_2(var_4_1.buffTextNode, var_7_3)

			var_7_3 = var_7_3 and arg_4_1.lifebar:visible()

			var_0_2(var_4_1.buffGroupNode, var_7_3)
			var_0_2(var_4_1.buffOverlayNode, var_7_3)
		end)
	end

	return var_4_1
end

local function var_0_3(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.firstIdx
	local var_8_1 = arg_8_0:getBoundingBox()
	local var_8_2 = (var_8_0 - 1) % arg_8_1 * (var_8_1.width + 5)
	local var_8_3 = math.floor((var_8_0 - 1) / arg_8_1) * var_8_1.height
	local var_8_4 = cc.p(var_8_2, var_8_3)

	arg_8_0:setPosition(var_8_4)

	if arg_8_0.overlayCountLabel and not arg_8_0.overlayOnSprite then
		arg_8_0.overlayCountLabel:setPosition(cc.pAdd(var_8_4, cc.p(var_8_1.width, -5)))
	end
end

local function var_0_4(arg_9_0)
	local var_9_0

	if arg_9_0:find("battle/txt") then
		local var_9_1 = arg_9_0:sub(12)
		local var_9_2 = cc.SpriteFrameCache:getInstance():getSpriteFrameByName(var_9_1)

		if var_9_2 then
			var_9_0 = cc.Sprite:createWithSpriteFrame(var_9_2)

			var_9_0:setScale(2)
		else
			errorInWindows("buff_txt not in batch %s", var_9_1)
		end
	end

	return CSprite.new(arg_9_0, var_9_0)
end

function var_0_0.onShowBuffText(arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_2 or arg_10_2 == "" then
		return
	end

	local var_10_0 = arg_10_0:getRecord(arg_10_1, true)

	arg_10_0.buffTexts[arg_10_1.id] = arg_10_0.buffTexts[arg_10_1.id] or {}

	local var_10_1 = arg_10_0.buffTexts[arg_10_1.id]

	if var_10_1[arg_10_2] then
		return
	end

	local var_10_2 = 0
	local var_10_3 = 0
	local var_10_4 = 0

	for iter_10_0, iter_10_1 in pairs(var_10_1) do
		var_10_2 = var_10_2 + iter_10_1
		var_10_3 = var_10_3 + 1
	end

	if var_10_2 + var_10_0.buffTextNode:getPositionY() > display.sizeInView.height then
		return
	end

	local var_10_5 = newCSpriteWithFunc(arg_10_2, var_0_4)

	if not var_10_5 then
		return
	end

	local var_10_6 = var_10_5:getBoundingBox()
	local var_10_7 = var_10_3 == 0 and var_10_6.height or (var_10_2 + var_10_6.height) / (var_10_3 + 1)
	local var_10_8 = cc.p(0, var_10_2 + var_10_7)

	var_10_1[arg_10_2] = var_10_7

	var_10_5:setPosition(var_10_8)
	var_10_0.buffTextNode:add(var_10_5)

	local function var_10_9()
		var_10_1[arg_10_2] = nil

		removeCSprite(var_10_5)
	end

	transition.executeSequence(var_10_5):delay(1):fadeOut(0.25):func(var_10_9):done()
end

function var_0_0.onShowBuffIcon(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = arg_12_0:getRecord(arg_12_1, true)
	local var_12_1 = var_12_0.buffEffectsMap[arg_12_3]

	if var_12_1 == nil then
		return
	end

	local var_12_2 = var_12_1.overlayCountLabel

	if var_12_2 and arg_12_4 and arg_12_4 <= 1 then
		var_12_2:setVisible(false)
	end

	if arg_12_4 and arg_12_4 > 1 then
		if var_12_2 == nil then
			local var_12_3 = cc.Label:createWithTTF(arg_12_4, "font/youmi.ttf", 30)

			var_12_3:enableOutline(cc.c4b(0, 0, 0, 255), 1)
			var_12_3:setAnchorPoint(cc.p(1, 0))

			if var_12_1.overlayOnSprite then
				local var_12_4 = var_12_1:getBoundingBox()

				var_12_3:setPosition(cc.p(var_12_4.width, -5))
				var_12_1:addChild(var_12_3)
			else
				var_12_0.buffOverlayNode:addChild(var_12_3)
			end

			var_12_1.overlayCountLabel = var_12_3
			var_12_2 = var_12_3
		end

		var_12_2:setString(arg_12_4)
		var_12_2:setVisible(true)
	end

	var_12_1:show()
	arg_12_0:refreshBuffIcons(var_12_0)
end

function var_0_0.refreshBuffIcons(arg_13_0, arg_13_1)
	local var_13_0 = {}

	for iter_13_0, iter_13_1 in pairs(arg_13_1.buffEffectsMap) do
		if iter_13_1:isVisible() then
			table.insert(var_13_0, iter_13_1)
		end
	end

	table.sort(var_13_0, function(arg_14_0, arg_14_1)
		return arg_14_0.firstIdx < arg_14_1.firstIdx
	end)

	for iter_13_2, iter_13_3 in ipairs(var_13_0) do
		iter_13_3.firstIdx = iter_13_2
	end

	arg_13_1.buffLastIndex = table.length(var_13_0)

	for iter_13_4, iter_13_5 in pairs(arg_13_1.buffEffectsMap) do
		var_0_3(iter_13_5, arg_13_1.lineLimit)
	end
end

function var_0_0.clearDelArray(arg_15_0, arg_15_1)
	for iter_15_0, iter_15_1 in ipairs(arg_15_1.delArray) do
		local var_15_0 = arg_15_1.buffEffectsMap[iter_15_1]

		if var_15_0 and var_15_0.ref <= 0 then
			arg_15_1.buffEffectsMap[iter_15_1] = nil

			if var_15_0.overlayCountLabel then
				var_15_0.overlayCountLabel:removeSelf()

				var_15_0.overlayCountLabel = nil
			end

			var_15_0:removeChildByName("iconFrame")
			removeCSprite(var_15_0)
		end
	end

	arg_15_1.delArray = {}
end

function var_0_0.onDelBuffIcon(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0:getRecord(arg_16_1)

	if var_16_0 == nil then
		return
	end

	local var_16_1 = var_16_0.buffEffectsMap[arg_16_2]

	if var_16_1 == nil then
		return
	end

	var_16_1.ref = var_16_1.ref - 1

	if var_16_1.ref > 0 then
		return
	end

	var_16_1:hide()
	arg_16_0:refreshBuffIcons(var_16_0)
	table.insert(var_16_0.delArray, arg_16_2)

	local var_16_2 = table.length(var_16_0.delArray)

	performWithDelay(var_16_0.shadowNode, function()
		if var_16_2 ~= table.length(var_16_0.delArray) then
			return
		end

		arg_16_0:clearDelArray(var_16_0)
	end, 1)
end

local function var_0_5(arg_18_0)
	local var_18_0

	if arg_18_0:find("battle/buff_icon") then
		local var_18_1 = arg_18_0:sub(18)
		local var_18_2 = cc.SpriteFrameCache:getInstance():getSpriteFrameByName(var_18_1)

		if var_18_2 then
			var_18_0 = cc.Sprite:createWithSpriteFrame(var_18_2)
		else
			errorInWindows("buff_icon not in batch %s", var_18_1)
		end
	end

	return CSprite.new(arg_18_0, var_18_0)
end

function var_0_0.onDealBuffEffectsMap(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	local var_19_0 = arg_19_0:getRecord(arg_19_1, true)
	local var_19_1 = var_19_0.buffEffectsMap[arg_19_3]

	if var_19_1 then
		if var_19_1.ref < 0 then
			var_19_1.ref = 0
		end

		var_19_1.ref = var_19_1.ref + 1

		return
	end

	if arg_19_2 and arg_19_2 ~= "" then
		var_19_0.buffLastIndex = var_19_0.buffLastIndex + 1

		local var_19_2 = var_19_0.buffLastIndex
		local var_19_3 = newCSpriteWithFunc(arg_19_2, var_0_5)

		var_19_3.ref = 1
		var_19_3.cfgId = arg_19_3
		var_19_3.firstIdx = var_19_2
		var_19_3.overlayCountLabel = nil
		var_19_3.overlayOnSprite = tj.type(arg_19_0.parent:getPlayModel()) == "ActivityWorldBossGate"

		if var_19_3.overlayOnSprite and arg_19_1.seat > battlePlay.Gate.ForceNumber then
			var_19_3.overlayOnSprite = false
		end

		if arg_19_4 == 1 then
			local var_19_4 = newCSpriteWithFunc("battle/buff_icon/box_selected.png", var_0_5)

			var_19_3:addChild(var_19_4, 99, "iconFrame")
			var_19_4:setPosition(25, 25)
		end

		var_19_3:getAni():scale(1)
		var_19_3:getAni():setAnchorPoint(cc.p(0, 0))
		var_19_3:hide()
		var_19_0.buffGroupNode:add(var_19_3)

		var_19_0.buffEffectsMap[arg_19_3] = var_19_3
	end
end

function var_0_0.onSetBuffIconVisible(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_0:getRecord(arg_20_1)

	if var_20_0 == nil then
		return
	end

	var_20_0.visible = arg_20_2
end

return var_0_0
