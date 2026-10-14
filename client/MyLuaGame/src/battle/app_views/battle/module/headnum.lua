local var_0_0 = class("HeadNum", battleModule.CBase)
local var_0_1 = 1.2
local var_0_2 = {
	strong = battle.ShowHeadNumberRes.txtStrong,
	weak = battle.ShowHeadNumberRes.txtWeak,
	fullweak = battle.ShowHeadNumberRes.txtFullweak
}
local var_0_3 = {}
local var_0_4 = 1

local function var_0_5(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0.pathName or arg_1_0:getAni():getResourceName()

	if var_0_3[var_1_0] then
		return var_0_3[var_1_0] + arg_1_1
	end

	var_0_4 = var_0_4 + 1

	local var_1_1 = var_0_4 * 10000

	var_0_3[var_1_0] = var_1_1

	return var_1_1 + arg_1_1
end

local function var_0_6(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = tostring(arg_2_1)

	if arg_2_3 == 1 then
		var_2_0 = "-" .. var_2_0
	elseif arg_2_3 == 2 then
		var_2_0 = "+" .. var_2_0
	end

	local var_2_1 = ccui.Layout:create()

	bind.extend(arg_2_0, var_2_1, {
		class = "text_atlas",
		props = {
			isEqualDist = false,
			align = "center",
			data = var_2_0,
			pathName = arg_2_2,
			onNode = function(arg_3_0)
				arg_3_0:setCascadeOpacityEnabled(true)
			end
		}
	})

	return var_2_1
end

local function var_0_7(arg_4_0)
	local var_4_0

	if arg_4_0:find("battle/txt") then
		local var_4_1 = arg_4_0:sub(12)
		local var_4_2 = cc.SpriteFrameCache:getInstance():getSpriteFrameByName(var_4_1)

		if var_4_2 then
			var_4_0 = cc.Sprite:createWithSpriteFrame(var_4_2)

			var_4_0:setScale(2)
		else
			errorInWindows("buff_txt not in batch %s", var_4_1)
		end
	end

	return CSprite.new(arg_4_0, var_4_0)
end

function var_0_0.ctor(arg_5_0, arg_5_1)
	battleModule.CBase.ctor(arg_5_0, arg_5_1)

	arg_5_0.layerDi = ccui.Layout:create()
	arg_5_0.layerFont = ccui.Layout:create()
	arg_5_0.layerTxt = ccui.Layout:create()
	arg_5_0.layerTxtRestraint = ccui.Layout:create()
	arg_5_0.showUnitSeg0Number = {}

	arg_5_0.parent.effectLayerNum:add(arg_5_0.layerDi, 1):add(arg_5_0.layerFont, 2):add(arg_5_0.layerTxt, 3):add(arg_5_0.layerTxtRestraint, 4)
end

local function var_0_8(arg_6_0, arg_6_1, arg_6_2)
	if arg_6_0 < 0 then
		return true
	end

	if arg_6_0 <= 0 and (arg_6_2.from == battle.DamageFrom.rebound or arg_6_2.from == battle.ResumeHpFrom.suckblood) then
		return true
	end

	if arg_6_1 and arg_6_1 > 1 then
		if arg_6_2.miss then
			return true
		end

		if arg_6_0 <= 0 then
			return true
		end

		if arg_6_2.immune then
			return true
		end
	end

	return false
end

function var_0_0.getHeadNumberPos(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = 0
	local var_7_1 = 0
	local var_7_2
	local var_7_3 = cc.p(-140, 0)

	if arg_7_3.from == battle.ResumeHpFrom.suckblood then
		var_7_2 = battle.ShowHeadNumberRes.txtXx
		var_7_3 = cc.p(-150, 65)
	elseif arg_7_3.from == battle.DamageFrom.rebound then
		var_7_2 = battle.ShowHeadNumberRes.txtFs
		var_7_3 = cc.p(-150, 40)
	elseif arg_7_3.strike then
		var_7_2 = battle.ShowHeadNumberRes.txtBj
		var_7_3 = cc.p(-220, 82)
	elseif arg_7_3.block then
		var_7_2 = battle.ShowHeadNumberRes.txtGd
		var_7_3 = cc.p(-220, 41)
	elseif arg_7_3.immune and arg_7_3.immune == "all" then
		var_7_2 = battle.ShowHeadNumberRes.txtAllImmune
	elseif arg_7_3.immune and arg_7_3.immune == "special" then
		var_7_2 = battle.ShowHeadNumberRes.txtSpecialImmune
	elseif arg_7_3.immune and arg_7_3.immune == "physical" then
		var_7_2 = battle.ShowHeadNumberRes.txtPhysicalImmune
	end

	local var_7_4

	if var_7_2 and not arg_7_1 then
		var_7_4 = newCSpriteWithFunc(var_7_2, var_0_7)

		local var_7_5 = var_7_4:getAni():getBoundingBox().width

		if not arg_7_3.block then
			local var_7_6 = arg_7_3.strike
		end

		var_7_4:addTo(arg_7_0.layerTxt):xy(var_7_0, var_7_1 + var_7_3.y):z(var_0_5(var_7_4, arg_7_2))

		var_7_0 = var_7_0 + var_7_5 + var_7_3.x
	end

	return var_7_0, var_7_1, var_7_4
end

function var_0_0.getHeadNumberArray(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7)
	local var_8_0 = arg_8_7.natureFlag
	local var_8_1 = arg_8_7.nature
	local var_8_2 = arg_8_7.segId or 1
	local var_8_3 = arg_8_7.delay or 0
	local var_8_4 = arg_8_0.showUnitSeg0Number
	local var_8_5 = arg_8_6.model.seat
	local var_8_6 = false
	local var_8_7 = var_8_0 and var_8_0 == "fullweak"
	local var_8_8
	local var_8_9
	local var_8_10
	local var_8_11
	local var_8_12
	local var_8_13
	local var_8_14

	if not arg_8_7.miss and not var_8_7 and not arg_8_7.immune then
		local var_8_15 = 0
		local var_8_16 = 0
		local var_8_17, var_8_18

		var_8_17, var_8_18, var_8_14 = arg_8_0:getHeadNumberPos(var_8_7, arg_8_4, arg_8_7)

		if not var_8_7 then
			if arg_8_7.strike then
				var_8_8 = var_0_6(arg_8_0.parent, arg_8_5, battle.ShowHeadNumberRes.fontBj, 1, var_8_3)
				var_8_9 = battle.ShowHeadNumberRes.txtBjDi
			elseif arg_8_1 == 0 then
				var_8_8 = var_0_6(arg_8_0.parent, arg_8_5, battle.ShowHeadNumberRes.fontPtsh, 1, var_8_3)
				var_8_9 = battle.ShowHeadNumberRes.txtPtshDi
			elseif arg_8_1 == 1 then
				var_8_8 = var_0_6(arg_8_0.parent, arg_8_5, battle.ShowHeadNumberRes.fontZlsz, 2, var_8_3)
				var_8_9 = battle.ShowHeadNumberRes.txtZlszDi
			end
		end

		if var_8_0 and var_8_1 and var_8_0 ~= "normal" and var_8_0 ~= "fullweak" then
			local var_8_19 = string.format("(x%s)", var_8_1)

			var_8_10 = var_0_6(arg_8_0.parent, var_8_19, battle.ShowHeadNumberRes.fontKz, 3, var_8_3)
			var_8_11 = battle.ShowHeadNumberRes.txtKzDi
		end

		local function var_8_20(arg_9_0, arg_9_1, arg_9_2)
			local var_9_0 = arg_9_0.panel:getContentSize()
			local var_9_1 = newCSpriteWithFunc(arg_9_1, var_0_7)
			local var_9_2 = var_9_1:getAni():getContentSize()
			local var_9_3 = 1

			if var_9_0.width > var_9_2.width then
				var_9_3 = var_9_0.width / var_9_2.width

				var_9_1:getAni():scaleX(var_9_3)
			end

			local var_9_4 = var_9_2.width * var_9_3
			local var_9_5 = var_9_2.height + (var_8_4[var_8_5] or 0)

			arg_9_0:addTo(arg_8_0.layerFont):xy(var_9_4 / 2 + var_8_17, var_9_5 / 2):z(var_0_5(arg_9_0, arg_8_4))
			var_9_1:addTo(arg_8_0.layerDi):xy(var_9_4 / 2 + var_8_17, var_9_5 / 2):z(var_0_5(var_9_1, arg_8_4))

			var_8_17 = var_8_17 + var_9_4 + (arg_9_2 or 0)

			return var_9_1
		end

		if var_8_8 and var_8_9 then
			var_8_12 = var_8_20(var_8_8, var_8_9, arg_8_7.strike and -60)

			if var_8_2 == 1 then
				var_8_6 = var_8_12:getAni():getContentSize().height
				var_8_4[var_8_5] = var_8_4[var_8_5] or 0
				var_8_4[var_8_5] = var_8_4[var_8_5] + var_8_6 + 2
			end
		end

		if var_8_10 and var_8_11 then
			var_8_13 = var_8_20(var_8_10, var_8_11, arg_8_7.strike and -60)
		end
	end

	local var_8_21 = {
		var_8_14,
		var_8_12,
		var_8_13,
		var_8_8,
		var_8_10
	}
	local var_8_22 = {}

	for iter_8_0 = 1, table.maxn(var_8_21) do
		if var_8_21[iter_8_0] then
			table.insert(var_8_22, var_8_21[iter_8_0])
		end
	end

	return var_8_22, var_8_6
end

function var_0_0.onShowHeadNumber(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_2.typ
	local var_10_1 = math.floor(arg_10_2.num)
	local var_10_2 = arg_10_2.args
	local var_10_3 = var_10_2.natureFlag
	local var_10_4 = var_10_2.nature
	local var_10_5 = var_10_2.segId or 1
	local var_10_6 = var_10_2.delay or 0
	local var_10_7 = var_10_2.isLastSeg
	local var_10_8 = var_10_2.call
	local var_10_9 = arg_10_0.showUnitSeg0Number
	local var_10_10 = arg_10_1.model.seat

	if var_0_8(var_10_1, var_10_5, var_10_2) then
		return
	end

	local var_10_11, var_10_12 = arg_10_1:getCurPos()
	local var_10_13 = arg_10_1.unitCfg.everyPos.headPos
	local var_10_14 = var_10_11 + var_10_13.x - 60
	local var_10_15 = var_10_12 + var_10_13.y + 25
	local var_10_16 = display.height - var_10_15
	local var_10_17 = var_10_16 - 1
	local var_10_18 = 2 - math.floor((arg_10_1.model.seat + 2) / 3) % 2 == 1 and var_10_16 or var_10_17
	local var_10_19 = arg_10_1.model.seat <= 6 and -1 or 1
	local var_10_20 = var_10_5 and var_10_5 - 1 or 0
	local var_10_21 = cc.p(0, 0)
	local var_10_22 = cc.p(var_10_14 - var_10_20 * var_10_19 * 20 + var_10_19 * var_10_21.x, var_10_15 - var_10_20 * 40 + var_10_21.y)
	local var_10_23, var_10_24 = arg_10_0:getHeadNumberArray(var_10_0, var_10_14, var_10_15, var_10_18, var_10_1, arg_10_1, var_10_2)

	local function var_10_25(arg_11_0)
		for iter_11_0, iter_11_1 in ipairs(var_10_23) do
			arg_11_0(iter_11_1)
		end
	end

	var_10_25(function(arg_12_0)
		local var_12_0, var_12_1 = arg_12_0:xy()

		arg_12_0:xy(var_12_0 + var_10_22.x, var_12_1 + var_10_22.y):show()
		arg_12_0:setScale(1)
		arg_12_0:setOpacity(255)
		arg_12_0:setCascadeOpacityEnabled(true)
	end)

	local var_10_26 = var_10_19 * 12
	local var_10_27 = false

	local function var_10_28()
		if var_10_27 then
			return
		end

		var_10_27 = true

		if var_10_24 then
			var_10_9[var_10_10] = var_10_9[var_10_10] - var_10_24
		end

		var_10_25(function(arg_14_0)
			if isCSprite(arg_14_0) then
				removeCSprite(arg_14_0)
			else
				arg_14_0:removeFromParent()
			end
		end)

		if var_10_8 then
			var_10_8()
		end

		if var_10_7 then
			arg_10_1.relationshipStatus = "showRelationship"
		end
	end

	var_10_25(function(arg_15_0)
		transition.executeSequence(arg_15_0):delay(var_10_6):scaleTo(0.15, 2):scaleTo(0.1, 1):moveBy(var_0_1, var_10_26, 180):func(var_10_28):done()
		transition.executeSequence(arg_15_0):delay(var_10_6):fadeOut(var_0_1):done()
	end)

	if arg_10_1.relationshipStatus == "showRelationship" and var_10_3 and var_10_4 and var_10_3 ~= "normal" then
		arg_10_1.relationshipStatus = "stop"

		local var_10_29 = 0
		local var_10_30 = -60
		local var_10_31 = newCSpriteWithFunc(var_0_2[var_10_3], var_0_7)

		var_10_31:setAnchorPoint(0.5, 0.5)
		var_10_31:setPosition(cc.p(var_10_14 + var_10_29, var_10_15 + var_10_30))
		var_10_31:setLocalZOrder(var_10_18 + 1000)
		arg_10_0.layerTxtRestraint:add(var_10_31)
		transition.executeSequence(var_10_31):delay(var_10_6):scaleTo(0.2, 1.8):scaleTo(0.1, 1):delay(0.3):moveBy(1, 0, 50):func(function()
			removeCSprite(var_10_31)
		end):done()
	end
end

function var_0_0.onShowHeadText(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_2.args
	local var_17_1 = var_17_0.segId == 1
	local var_17_2

	if var_17_0.miss then
		var_17_2 = battle.ShowHeadNumberRes.txtSb
	end

	if not var_17_2 then
		return
	end

	if not var_17_1 then
		return
	end

	local var_17_3, var_17_4 = arg_17_1:getCurPos()
	local var_17_5 = cc.p(var_17_3, var_17_4)
	local var_17_6 = arg_17_1.unitCfg.everyPos.headPos
	local var_17_7 = cc.pAdd(var_17_5, var_17_6)
	local var_17_8 = display.height - var_17_4
	local var_17_9 = var_17_8 - 1
	local var_17_10 = 2 - math.floor((arg_17_1.model.seat + 2) / 3) % 2 == 1 and var_17_8 or var_17_9
	local var_17_11 = 0
	local var_17_12 = newCSpriteWithFunc(var_17_2, var_0_7)

	var_17_12:addTo(arg_17_0.layerTxt):xy(var_17_7.x, var_17_7.y):z(var_0_5(var_17_12, var_17_10))

	local var_17_13 = {}

	if var_17_12 then
		table.insert(var_17_13, var_17_12)
	end

	local function var_17_14(arg_18_0)
		for iter_18_0, iter_18_1 in ipairs(var_17_13) do
			arg_18_0(iter_18_1)
		end
	end

	var_17_14(function(arg_19_0)
		arg_19_0:show()
		arg_19_0:setScale(1)
		arg_19_0:setOpacity(255)
		arg_19_0:setCascadeOpacityEnabled(true)
	end)

	local var_17_15 = false

	local function var_17_16()
		if var_17_15 then
			return
		end

		var_17_15 = true

		var_17_14(function(arg_21_0)
			if isCSprite(arg_21_0) then
				removeCSprite(arg_21_0)
			else
				arg_21_0:removeFromParent()
			end
		end)
	end

	var_17_14(function(arg_22_0)
		transition.executeSequence(arg_22_0):delay(var_17_11):scaleTo(0.15, 2):scaleTo(0.1, 1):moveBy(var_0_1, 0, 180):func(var_17_16):done()
		transition.executeSequence(arg_22_0):delay(var_17_11):fadeOut(var_0_1):done()
	end)
end

return var_0_0
