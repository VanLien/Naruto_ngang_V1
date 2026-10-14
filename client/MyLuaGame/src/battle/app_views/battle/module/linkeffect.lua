local var_0_0 = class("LinkEffect", battleModule.CBase)

local function var_0_1(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0
	local var_1_1
	local var_1_2
	local var_1_3

	if arg_1_4 then
		var_1_0, var_1_1 = arg_1_0:x(), arg_1_0:y()
		var_1_2, var_1_3 = arg_1_1:x(), arg_1_1:y()
	else
		var_1_0, var_1_1 = arg_1_0:getSelfPos()
		var_1_2, var_1_3 = arg_1_1:getSelfPos()
	end

	local var_1_4 = arg_1_0.unitCfg.everyPos.hitPos
	local var_1_5 = arg_1_1.unitCfg.everyPos.hitPos
	local var_1_6 = var_1_0 + var_1_4.x
	local var_1_7 = var_1_1 + var_1_4.y
	local var_1_8 = var_1_2 + var_1_5.x
	local var_1_9 = var_1_3 + var_1_5.y
	local var_1_10 = arg_1_3 * (math.sqrt((var_1_6 - var_1_8) * (var_1_6 - var_1_8) + (var_1_7 - var_1_9) * (var_1_7 - var_1_9)) / arg_1_2:getBoundingBox().width)
	local var_1_11 = {
		x = var_1_6 - var_1_8,
		y = var_1_7 - var_1_9
	}
	local var_1_12 = math.atan2(var_1_11.y, var_1_11.x) * 180 / math.pi

	arg_1_2:scaleX(var_1_10):setRotation(-var_1_12)
end

function var_0_0.ctor(arg_2_0, arg_2_1)
	battleModule.CBase.ctor(arg_2_0, arg_2_1)

	arg_2_0.lines = {}
	arg_2_0.caster2Keys = {}
	arg_2_0.isShow = true
	arg_2_0.updateObjKey = nil
	arg_2_0.updateObjSpr = nil
	arg_2_0.lastx = 0
	arg_2_0.lasty = 0
end

function var_0_0.onUpdate(arg_3_0, arg_3_1)
	if not arg_3_0.updateObjKey or not arg_3_0.isShow or not arg_3_0:checkObjMove() then
		return
	end

	for iter_3_0, iter_3_1 in pairs(arg_3_0.lines) do
		local var_3_0, var_3_1 = arg_3_0:tryGetCaster(iter_3_1.casterKey)

		var_3_0 = var_3_0 or iter_3_1.casterKey
		var_3_1 = var_3_1 or iter_3_1.casterSpr

		if var_3_0 == arg_3_0.updateObjKey or iter_3_1.holderKey == arg_3_0.updateObjKey then
			var_0_1(var_3_1, iter_3_1.holderSpr, iter_3_1.line, iter_3_1.scaleX, true)
		end
	end
end

function var_0_0.checkObjMove(arg_4_0)
	local var_4_0 = arg_4_0.updateObjSpr:x()
	local var_4_1 = arg_4_0.updateObjSpr:y()

	if var_4_0 ~= arg_4_0.lastx or var_4_1 ~= arg_4_0.lasty then
		arg_4_0.lastx, arg_4_0.lasty = var_4_0, var_4_1

		return true
	end

	return false
end

function var_0_0.onAddLinkEffect(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_4

	if arg_5_0.lines[var_5_0] then
		return
	end

	local var_5_1 = arg_5_3.effectRes
	local var_5_2 = arg_5_3.aniName
	local var_5_3 = arg_5_3.offsetPos
	local var_5_4 = arg_5_3.deep
	local var_5_5 = arg_5_3.scaleX or 1
	local var_5_6 = arg_5_0:call("getSceneObj", arg_5_1)
	local var_5_7 = arg_5_0:call("getSceneObj", arg_5_2)
	local var_5_8

	var_5_8 = var_5_3 and cc.p(var_5_3.x, var_5_3.y) or cc.p(0, 0)

	if var_5_6.force == 2 then
		local var_5_9 = cc.p(-var_5_8.x, var_5_8.y)
	end

	local var_5_10 = var_5_6.unitCfg.everyPos.hitPos
	local var_5_11 = newCSprite(var_5_1)

	var_5_11:addTo(var_5_6, var_5_4)
	var_5_11:setPosition(var_5_10)
	var_5_11:play(var_5_2)
	var_5_11:setVisible(arg_5_0.isShow)

	arg_5_0.lines[var_5_0] = {
		line = var_5_11,
		holderKey = arg_5_1,
		casterKey = arg_5_2,
		holderSpr = var_5_6,
		casterSpr = var_5_7,
		scaleX = var_5_5
	}
	arg_5_0.caster2Keys[arg_5_2] = arg_5_0.caster2Keys[arg_5_2] or {}

	local var_5_12 = {
		key = arg_5_1,
		spr = var_5_6
	}

	if arg_5_1 == arg_5_2 then
		table.insert(arg_5_0.caster2Keys[arg_5_2], 1, var_5_12)
	else
		table.insert(arg_5_0.caster2Keys[arg_5_2], var_5_12)
	end

	local var_5_13, var_5_14 = arg_5_0:tryGetCaster(arg_5_2)

	arg_5_0:refreshByObj(var_5_13)
end

function var_0_0.onDelLinkEffect(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_1

	if not arg_6_0.lines[var_6_0] then
		return
	end

	local var_6_1 = arg_6_0.lines[var_6_0].casterKey

	if arg_6_0.caster2Keys[var_6_1] then
		for iter_6_0, iter_6_1 in ipairs(arg_6_0.caster2Keys[var_6_1]) do
			if iter_6_1.key == arg_6_0.lines[var_6_0].holderKey then
				table.remove(arg_6_0.caster2Keys[var_6_1], iter_6_0)

				break
			end
		end
	end

	local var_6_2 = arg_6_0.lines[var_6_0].line

	var_6_2:setRotation(0)
	removeCSprite(var_6_2)

	arg_6_0.lines[var_6_0] = nil

	arg_6_0:refreshByObj(arg_6_0:tryGetCaster(var_6_1))
end

function var_0_0.onShowLinkEffect(arg_7_0, arg_7_1)
	if arg_7_1 == arg_7_0.isShow then
		return
	end

	arg_7_0.isShow = arg_7_1

	for iter_7_0, iter_7_1 in pairs(arg_7_0.lines) do
		iter_7_1.line:setVisible(arg_7_1)
	end
end

function var_0_0.onDoShiftPos(arg_8_0, arg_8_1)
	arg_8_0:refreshByObj(arg_8_1)
end

function var_0_0.refreshByObj(arg_9_0, arg_9_1)
	for iter_9_0, iter_9_1 in pairs(arg_9_0.lines) do
		local var_9_0, var_9_1 = arg_9_0:tryGetCaster(iter_9_1.casterKey)

		var_9_0 = var_9_0 or iter_9_1.casterKey
		var_9_1 = var_9_1 or iter_9_1.casterSpr

		if var_9_0 == arg_9_1 or iter_9_1.holderKey == arg_9_1 then
			var_0_1(var_9_1, iter_9_1.holderSpr, iter_9_1.line, iter_9_1.scaleX)
		end
	end
end

function var_0_0.onUpdateLinkEffect(arg_10_0, arg_10_1, arg_10_2)
	if arg_10_1 then
		arg_10_0.updateObjSpr = arg_10_0:call("getSceneObj", arg_10_2)

		if arg_10_0.updateObjSpr then
			arg_10_0.updateObjKey = arg_10_2
		end
	else
		arg_10_0:refreshByObj(arg_10_2)

		arg_10_0.updateObjKey = nil
		arg_10_0.updateObjSpr = nil
		arg_10_0.lastx = 0
		arg_10_0.lasty = 0
	end
end

function var_0_0.tryGetCaster(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.caster2Keys[arg_11_1] and arg_11_0.caster2Keys[arg_11_1][1]

	if var_11_0 then
		return var_11_0.key, var_11_0.spr
	end
end

return var_0_0
