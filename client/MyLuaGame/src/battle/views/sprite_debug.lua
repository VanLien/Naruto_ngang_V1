local var_0_0 = 6
local var_0_1 = 10
local var_0_2 = 30
local var_0_3 = 30
local var_0_4 = 999999
local var_0_5 = cc.p(0.5, 1)

local function var_0_6(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_3 = arg_1_3 or var_0_2

	local var_1_0 = cc.Label:createWithTTF("", ui.FONT_PATH, arg_1_3, cc.size(0, 0), cc.TEXT_ALIGNMENT_CENTER)

	var_1_0:align(var_0_5, 0, arg_1_1):addTo(arg_1_2, var_0_4):setTextColor(cc.convertColor(arg_1_0, "4b"))
	var_1_0:enableShadow(cc.c4b(0, 0, 0, 255 * arg_1_0.a), cc.size(1, -1))

	return var_1_0
end

local function var_0_7(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = cc.DrawNode:create(var_0_0)

	var_2_0:drawDot(cc.p(0, 0), var_0_1, arg_2_0)

	if arg_2_1 then
		var_2_0:drawLine(cc.p(0, 0), cc.p(20, 0), arg_2_0)
	end

	var_2_0:addTo(arg_2_2, var_0_4)

	return var_2_0
end

local function var_0_8(arg_3_0, arg_3_1)
	arg_3_0:retain()
	arg_3_0:removeSelf():addTo(arg_3_1, var_0_4)
	arg_3_0:autorelease()
end

local function var_0_9(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = cc.Node:create()

	var_4_0:addTo(arg_4_3, var_0_4)
	var_4_0:xy(arg_4_1)
	var_0_7(arg_4_0, false, var_4_0)
	var_0_6(arg_4_0, -var_0_2, var_4_0):setString(string.format("%s (%d, %d)", arg_4_2, arg_4_1.x, arg_4_1.y))

	return var_4_0
end

local function var_0_10(arg_5_0)
	local var_5_0 = cc.c4f(0, 0, 1, 0.8)
	local var_5_1 = var_0_6(var_5_0, -var_0_2, arg_5_0)
	local var_5_2

	if arg_5_0:getParent() then
		var_5_2 = var_0_7(var_5_0, false, arg_5_0:getParent())

		var_5_2:move(arg_5_0:getCurPos())
		var_0_8(var_5_1, var_5_2)
	end

	local var_5_3 = cc.c4f(1, 0, 0, 0.8)
	local var_5_4 = var_0_6(var_5_3, -var_0_2 * 2, arg_5_0)
	local var_5_5 = var_0_7(var_5_3, true, arg_5_0)
	local var_5_6 = cc.c4f(0, 1, 0, 0.8)
	local var_5_7 = var_0_6(var_5_6, -var_0_2 * 3, arg_5_0)
	local var_5_8

	if arg_5_0.sprite then
		var_5_8 = var_0_7(var_5_6, true, arg_5_0.sprite.__ani)
	end

	local var_5_9 = cc.c4f(1, 1, 0, 0.8)
	local var_5_10 = var_0_6(var_5_9, -var_0_2 * 4, arg_5_0)
	local var_5_11

	if arg_5_0.sprite then
		var_5_11 = var_0_7(var_5_9, false, arg_5_0.sprite)
	end

	local var_5_12 = var_5_9
	local var_5_13
	local var_5_14
	local var_5_15

	if arg_5_0.unitCfg then
		var_5_13 = var_0_9(var_5_12, arg_5_0.unitCfg.everyPos.headPos, string.format("[%d] head", arg_5_0.seat), arg_5_0)
		var_5_14 = var_0_9(var_5_12, arg_5_0.unitCfg.everyPos.lifePos, string.format("[%d] life", arg_5_0.seat), arg_5_0)
		var_5_15 = var_0_9(var_5_12, arg_5_0.unitCfg.everyPos.hitPos, string.format("[%d] hit", arg_5_0.seat), arg_5_0)
	end

	local var_5_16 = cc.RepeatForever:create(cc.Sequence:create(cc.CallFunc:create(function()
		if var_5_2 then
			var_5_2:move(arg_5_0:getCurPos())
		end

		local var_6_0 = cc.p(0, 0)

		if var_5_11 then
			var_6_0 = arg_5_0.sprite:getBonePosition("yinying")

			var_5_11:move(var_6_0)
		end

		local var_6_1 = arg_5_0:convertToWorldSpace(cc.p(0, 0))
		local var_6_2 = arg_5_0.sprite:convertToWorldSpace(cc.p(0, 0))

		var_5_1:setString(string.format("[%d] cur (%d, %d)", arg_5_0.seat, arg_5_0:getCurPos()))
		var_5_4:setString(string.format("[%d] world (%d, %d)", arg_5_0.seat, var_6_1.x, var_6_1.y))
		var_5_7:setString(string.format("[%d] csprite (%d, %d)", arg_5_0.seat, var_6_2.x, var_6_2.y))
		var_5_10:setString(string.format("[%d] yinying (%d, %d)", arg_5_0.seat, var_6_0.x, var_6_0.y))
	end)))

	gRootViewProxy:proxy():runAction(var_5_16)

	arg_5_0.debug.nodes = {
		curPos = var_5_2,
		worldPos = var_5_5,
		cspritePos = var_5_8,
		yinyingPos = var_5_11,
		curPosLabel = var_5_1,
		worldPosLabel = var_5_4,
		cspritePosLabel = var_5_7,
		yinyingPosLabel = var_5_10,
		headPosNode = var_5_13,
		lifePosNode = var_5_14,
		hitPosNode = var_5_15
	}

	for iter_5_0, iter_5_1 in pairs(arg_5_0.debug.nodes) do
		iter_5_1:retain()
	end

	arg_5_0.debug.action = var_5_16
end

local function var_0_11(arg_7_0)
	local var_7_0 = cc.c4f(1, 0, 0, 1)
	local var_7_1 = cc.Node:create():addTo(arg_7_0:getParent(), var_0_4)
	local var_7_2 = var_0_6(var_7_0, -var_0_3, var_7_1, var_0_3)
	local var_7_3 = var_0_6(var_7_0, -var_0_3 * 2, var_7_1, var_0_3)

	var_7_3:setAlignment(cc.TEXT_ALIGNMENT_LEFT, cc.VERTICAL_TEXT_ALIGNMENT_TOP)

	if not arg_7_0.getCurPos then
		var_7_1:move(display.top_center)
	end

	local var_7_4 = cc.RepeatForever:create(cc.Sequence:create(cc.CallFunc:create(function()
		if arg_7_0.getCurPos then
			local var_8_0 = cc.p(0, 0)

			if arg_7_0.debug.enabled then
				var_8_0.y = -var_0_2 * 4
			end

			var_7_1:move(cc.pAdd(cc.p(arg_7_0:getCurPos()), var_8_0))
		end

		local var_8_1 = arg_7_0.effectManager:queueSize()
		local var_8_2 = arg_7_0.effectManager:queueInfo()
		local var_8_3 = arg_7_0.effectManager.updEffects
		local var_8_4 = 0
		local var_8_5 = {}

		if var_8_3 then
			var_8_4 = itertools.size(var_8_3)
			var_8_5 = itertools.map(var_8_3, function(arg_9_0, arg_9_1)
				return arg_9_1:debugString()
			end)
		end

		local var_8_6 = arg_7_0.seat and arg_7_0.seat or "scene"

		var_7_2:setString(string.format("[%s] effect que %d upd %d", var_8_6, var_8_1, var_8_4))

		local var_8_7 = ""

		if table.length(var_8_2) > 0 then
			var_8_7 = string.format("[%s] que:\n%s\n", var_8_6, table.concat(var_8_2, "\n"))
		end

		local var_8_8 = ""

		if table.length(var_8_5) > 0 then
			var_8_8 = string.format("[%s] upd:\n%s", var_8_6, table.concat(var_8_5, "\n"))
		end

		var_7_3:setString(string.format("%s%s", var_8_7, var_8_8))
	end)))

	gRootViewProxy:proxy():runAction(var_7_4)

	arg_7_0.effectDebug.nodes = {
		effectNode = var_7_1
	}

	for iter_7_0, iter_7_1 in pairs(arg_7_0.effectDebug.nodes) do
		iter_7_1:retain()
	end

	arg_7_0.effectDebug.action = var_7_4
end

function BattleSprite.setDebugEnabled(arg_10_0, arg_10_1)
	if arg_10_1 == arg_10_0.debug.enabled then
		return
	end

	arg_10_0.debug.enabled = arg_10_1

	if arg_10_1 then
		var_0_10(arg_10_0)
	else
		for iter_10_0, iter_10_1 in pairs(arg_10_0.debug.nodes) do
			iter_10_1:removeSelf():autorelease()
		end

		gRootViewProxy:proxy():stopAction(arg_10_0.debug.action)

		arg_10_0.debug = {
			enabled = false
		}
	end
end

function BattleSprite.setEffectDebugEnabled(arg_11_0, arg_11_1)
	if arg_11_1 == arg_11_0.effectDebug.enabled then
		return
	end

	arg_11_0.effectDebug.enabled = arg_11_1

	if arg_11_1 then
		if arg_11_0.effectManager == nil then
			printWarn("%s no effectManager", arg_11_0)

			return
		end

		var_0_11(arg_11_0)
	else
		for iter_11_0, iter_11_1 in pairs(arg_11_0.effectDebug.nodes) do
			iter_11_1:removeSelf():autorelease()
		end

		gRootViewProxy:proxy():stopAction(arg_11_0.effectDebug.action)

		arg_11_0.effectDebug = {
			enabled = false
		}
	end
end

function BattleSprite.debugParents(arg_12_0)
	local var_12_0 = arg_12_0.sprite.__ani or arg_12_0.sprite
	local var_12_1 = 0

	while var_12_0 do
		local var_12_2, var_12_3 = var_12_0:getPosition()

		print("[DBG]", arg_12_0, var_12_1, var_12_0, var_12_0:getName(), var_12_2, var_12_3, var_12_0:getScaleX(), var_12_0:getScaleY())

		var_12_0 = var_12_0:getParent()
		var_12_1 = var_12_1 + 1
	end
end

function BattleSprite.debugString(arg_13_0)
	return string.format("BattleSprite: %d", arg_13_0.seat)
end
