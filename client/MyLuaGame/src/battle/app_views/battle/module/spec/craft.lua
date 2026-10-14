local var_0_0 = {
	scale = 1.1,
	pos1 = {
		x = 16,
		y = 25
	},
	pos2 = {
		x = 32,
		y = 23
	}
}
local var_0_1 = {
	scale = 1,
	pos1 = {
		x = 14,
		y = 26
	},
	pos2 = {
		x = 33,
		y = 23
	}
}
local var_0_2 = {
	{
		{
			x = 34,
			y = 332
		},
		{
			x = 34,
			y = 131
		},
		{
			x = 181,
			y = 131
		}
	},
	{
		{
			x = 966,
			y = 332
		},
		{
			x = 966,
			y = 131
		},
		{
			x = 819,
			y = 131
		}
	}
}
local var_0_3 = class("CraftSpecView", battleModule.CBase)

var_0_3.RESOURCE_FILENAME = "battle_craft.json"
var_0_3.RESOURCE_BINDING = {
	selfInfo = "selfInfo",
	enemyWin = "enemyWin",
	enemyMp = "enemyMp",
	selfWin = "selfWin",
	selfMp = "selfMp",
	enemyInfo = "enemyInfo"
}

function var_0_3.ctor(arg_1_0, arg_1_1)
	battleModule.CBase.ctor(arg_1_0, arg_1_1)

	arg_1_0.root = cache.createWidget(arg_1_0.RESOURCE_FILENAME)

	bindUI(arg_1_0, arg_1_0.root, arg_1_0.RESOURCE_BINDING)
	arg_1_0.root:addTo(arg_1_1, 99):show()
	arg_1_0:init()
	arg_1_0:initBar(arg_1_0.selfMp:get("progress"), 1)
	arg_1_0:initBar(arg_1_0.enemyMp:get("progress"), -1)

	arg_1_0.selfInfoProgress = arg_1_0.selfInfo:get("progress")
	arg_1_0.enemyInfoProgress = arg_1_0.enemyInfo:get("progress")

	arg_1_0:initProgressBar(arg_1_0.selfInfo:get("progress"))
	arg_1_0:initProgressBar(arg_1_0.enemyInfo:get("progress"))
end

function var_0_3.init(arg_2_0)
	arg_2_0.selfWin:hide()
	arg_2_0.enemyWin:hide()

	arg_2_0.myHpPercent = 100
	arg_2_0.enemyHpPercent = 100
	arg_2_0.myMpPercent = 0
	arg_2_0.enemyMpPercent = 0
	arg_2_0.isFinal = arg_2_0.parent:getPlayModel().isFinal

	if not arg_2_0.isFinal then
		nodetools.invoke(arg_2_0.selfInfo, {
			"firstIcon",
			"secondIcon",
			"thirdIcon",
			"iconBase1",
			"iconBase2"
		}, "hide")
		nodetools.invoke(arg_2_0.enemyInfo, {
			"firstIcon",
			"secondIcon",
			"thirdIcon",
			"iconBase1",
			"iconBase2"
		}, "hide")
	else
		arg_2_0.backUpIconData = {
			{},
			{}
		}
	end

	arg_2_0.root:setVisible(false)
end

function var_0_3.setCurrent(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0.parent:getPlayModel().firstRoleout[arg_3_2]
	local var_3_1 = csv.unit[var_3_0.roleId].cardIcon2

	arg_3_1:get("current"):loadTexture(var_3_1)
end

function var_0_3.setSkillName(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0.parent:getPlayModel().firstRoleout[arg_4_2]
	local var_4_1 = ""

	for iter_4_0, iter_4_1 in pairs(var_4_0.skills) do
		local var_4_2 = csv.skill[iter_4_0]

		if var_4_2.skillType2 == battle.MainSkillType.BigSkill then
			var_4_1 = var_4_2.skillName
		end
	end

	arg_4_1:get("skillname"):setString(var_4_1)
	adapt.setTextScaleWithWidth(arg_4_1:get("skillname"), nil, 220)
end

function var_0_3.onInitPvp(arg_5_0)
	arg_5_0:setCurrent(arg_5_0.selfInfo, 1)
	arg_5_0:setCurrent(arg_5_0.enemyInfo, 2)
	arg_5_0:setSkillName(arg_5_0.selfMp, 1)
	arg_5_0:setSkillName(arg_5_0.enemyMp, 2)

	local var_5_0 = {
		"secondIcon",
		"thirdIcon"
	}

	local function var_5_1(arg_6_0, arg_6_1)
		local var_6_0 = arg_5_0.parent:getPlayModel().backUp[arg_6_1]

		for iter_6_0 = 1, 2 do
			local var_6_1 = var_6_0[iter_6_0]
			local var_6_2 = arg_5_0[arg_6_0]:get("iconBase" .. iter_6_0)

			if var_6_1 then
				arg_5_0.backUpIconData[arg_6_1][iter_6_0] = var_6_1

				local var_6_3 = {
					grayState = 0,
					unitId = arg_5_0.backUpIconData[arg_6_1][iter_6_0].roleId,
					advance = arg_5_0.backUpIconData[arg_6_1][iter_6_0].advance,
					flip = arg_6_1 == 2
				}

				var_0_3.setIconByData(var_6_2, var_6_3)
			else
				arg_5_0[arg_6_0]:get(var_5_0[iter_6_0]):hide()
			end
		end
	end

	if arg_5_0.isFinal then
		var_5_1("selfInfo", 1)
		var_5_1("enemyInfo", 2)
	end

	local var_5_2 = arg_5_0.parent.data.names

	arg_5_0.selfInfo:get("name"):setString(var_5_2[1])
	arg_5_0.enemyInfo:get("name"):setString(var_5_2[2])
	arg_5_0.root:setVisible(true)
end

local function var_0_4(arg_7_0, arg_7_1, arg_7_2)
	local function var_7_0(arg_8_0, arg_8_1, arg_8_2)
		arg_8_0:move(arg_8_1):scale(arg_8_2.scale)
		arg_8_0:get("num"):xy(arg_8_2.pos1)
		arg_8_0:get("txt"):xy(arg_8_2.pos2)
	end

	local var_7_1 = nodetools.multiget(arg_7_0, "firstIcon", "secondIcon", "thirdIcon")

	if arg_7_1 == 2 then
		var_7_0(var_7_1.firstIcon, var_0_2[arg_7_2][3], var_0_1)
		var_7_0(var_7_1.secondIcon, var_0_2[arg_7_2][1], var_0_0)
		var_7_0(var_7_1.thirdIcon, var_0_2[arg_7_2][2], var_0_1)
	elseif arg_7_1 == 3 then
		var_7_0(var_7_1.firstIcon, var_0_2[arg_7_2][2], var_0_1)
		var_7_0(var_7_1.secondIcon, var_0_2[arg_7_2][3], var_0_1)
		var_7_0(var_7_1.thirdIcon, var_0_2[arg_7_2][1], var_0_0)
	end
end

function var_0_3.onChangeWave(arg_9_0, arg_9_1)
	if not arg_9_0.isFinal then
		return
	end

	local function var_9_0(arg_10_0, arg_10_1)
		local var_10_0 = arg_9_0.parent:getPlayModel()
		local var_10_1 = var_10_0.backUp[arg_10_1]
		local var_10_2 = var_10_0.loserRoleOut[arg_10_1]
		local var_10_3 = arg_9_0[arg_10_0]
		local var_10_4 = 0

		for iter_10_0, iter_10_1 in pairs(var_10_2) do
			var_10_4 = var_10_4 + 1
		end

		if var_10_4 == 1 then
			arg_9_0.backUpIconData[arg_10_1][1] = var_10_1[1]
			arg_9_0.backUpIconData[arg_10_1][2] = var_10_2[1]

			for iter_10_2 = 1, 2 do
				local var_10_5 = var_10_3:get("iconBase" .. iter_10_2)
				local var_10_6 = {
					unitId = arg_9_0.backUpIconData[arg_10_1][iter_10_2].roleId,
					advance = arg_9_0.backUpIconData[arg_10_1][iter_10_2].advance,
					grayState = iter_10_2,
					flip = arg_10_1 == 2
				}

				var_0_3.setIconByData(var_10_5, var_10_6)
			end

			var_0_4(var_10_3, 2, arg_10_1)
		elseif var_10_4 == 2 then
			arg_9_0.backUpIconData[arg_10_1][1] = var_10_2[1]
			arg_9_0.backUpIconData[arg_10_1][2] = var_10_2[2]

			for iter_10_3 = 1, 2 do
				local var_10_7 = var_10_3:get("iconBase" .. iter_10_3)
				local var_10_8 = {
					grayState = 2,
					unitId = arg_9_0.backUpIconData[arg_10_1][iter_10_3].roleId,
					advance = arg_9_0.backUpIconData[arg_10_1][iter_10_3].advance,
					flip = arg_10_1 == 2
				}

				var_0_3.setIconByData(var_10_7, var_10_8)
			end

			var_0_4(var_10_3, 3, arg_10_1)
		end
	end

	if arg_9_1 == 1 then
		arg_9_0:setCurrent(arg_9_0.enemyInfo, 2)
		arg_9_0:setSkillName(arg_9_0.enemyMp, 2)
		var_9_0("enemyInfo", 2)
	else
		arg_9_0:setCurrent(arg_9_0.selfInfo, 1)
		arg_9_0:setSkillName(arg_9_0.selfMp, 1)
		var_9_0("selfInfo", 1)
	end
end

local var_0_5 = 0.1

local function var_0_6(arg_11_0, arg_11_1)
	transition.executeSequence(arg_11_0):progressTo(var_0_5, arg_11_1):done()
end

local function var_0_7(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0:get("progress")
	local var_12_1 = arg_12_0:get("full")
	local var_12_2 = var_12_0:size().width

	transition.executeSequence(var_12_0):func(function()
		if var_12_0.whenChange then
			var_12_0.whenChange(var_0_5, arg_12_1)
		end
	end):delay(var_0_5):func(function()
		var_12_0:visible(arg_12_1 < 100)
		var_12_1:visible(arg_12_1 >= 100)
	end):done()
end

function var_0_3.onChangeHpMp(arg_15_0, arg_15_1)
	local function var_15_0(arg_16_0, arg_16_1)
		if arg_16_1 >= 0 then
			arg_15_0[arg_16_0] = math.floor(arg_16_1 * 100)
		end
	end

	if arg_15_1.selfHpRatio and arg_15_1.enemyHpRatio then
		if arg_15_1.selfHpRatio == -1 and arg_15_0.myHpPercent == 1 then
			arg_15_0.myHpPercent = 0
		end

		if math.abs(arg_15_0.myHpPercent - arg_15_1.selfHpRatio) > 1e-05 then
			var_15_0("myHpPercent", arg_15_1.selfHpRatio)
			var_0_6(arg_15_0.selfInfoProgress, arg_15_0.myHpPercent)
		end

		if arg_15_1.enemyHpRatio == -1 and arg_15_0.enemyHpPercent == 1 then
			arg_15_0.enemyHpPercent = 0
		end

		if math.abs(arg_15_0.enemyHpPercent - arg_15_1.enemyHpRatio) > 1e-05 then
			var_15_0("enemyHpPercent", arg_15_1.enemyHpRatio)
			var_0_6(arg_15_0.enemyInfoProgress, arg_15_0.enemyHpPercent)
		end
	end

	if arg_15_1.selfMpRatio and arg_15_1.enemyMpRatio then
		if arg_15_1.selfMpRatio == -1 and arg_15_0.myMpPercent == 1 then
			arg_15_0.myMpPercent = 0
		end

		if math.abs(arg_15_0.myMpPercent - arg_15_1.selfMpRatio) > 1e-05 then
			var_15_0("myMpPercent", arg_15_1.selfMpRatio)
			var_0_7(arg_15_0.selfMp, arg_15_0.myMpPercent)
		end

		if arg_15_1.enemyMpRatio == -1 and arg_15_0.enemyMpPercent == 1 then
			arg_15_0.enemyMpPercent = 0
		end

		if math.abs(arg_15_0.enemyMpPercent - arg_15_1.enemyMpRatio) > 1e-05 then
			var_15_0("enemyMpPercent", arg_15_1.enemyMpRatio)
			var_0_7(arg_15_0.enemyMp, arg_15_0.enemyMpPercent)
		end
	end
end

function var_0_3.setIconByData(arg_17_0, arg_17_1)
	if arg_17_0.panel then
		arg_17_0:removeAllChildren()
	end

	local var_17_0 = cc.size(198, 198)
	local var_17_1 = ccui.Layout:create():size(198, 198):scale(0.7):addTo(arg_17_0, 1, "_card_")
	local var_17_2 = dataEasy.getQuality(arg_17_1.advance, false)
	local var_17_3 = ui.QUALITY_BOX[var_17_2]
	local var_17_4 = ccui.ImageView:create(var_17_3):alignCenter(var_17_0):addTo(var_17_1, 1, "imgBG")
	local var_17_5 = ccui.ImageView:create(string.format("common/icon/panel_icon_k%d.png", var_17_2)):alignCenter(var_17_0):addTo(var_17_1, 3, "imgFG")

	arg_17_0.panel = var_17_1

	local var_17_6 = ccui.ImageView:create(csv.unit[arg_17_1.unitId].cardIcon):alignCenter(var_17_0):scale(2):addTo(var_17_1, 2, "icon")
	local var_17_7 = arg_17_1.grayState == 2 and "hsl_gray" or "normal"

	cache.setShader(var_17_4, false, var_17_7)
	cache.setShader(var_17_6, false, var_17_7)

	if arg_17_1.flip then
		arg_17_0:setFlippedX(true)
	end
end

function var_0_3.onShowSpec(arg_18_0, arg_18_1)
	arg_18_0.root:setVisible(arg_18_1)
end

function var_0_3.onClose(arg_19_0)
	ViewBase.onClose(arg_19_0)
end

function var_0_3.initProgressBar(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_1:getVirtualRenderer()
	local var_20_1 = var_20_0:getTexture():getPath()
	local var_20_2 = arg_20_1:size()
	local var_20_3 = var_20_0:getCapInsets()
	local var_20_4 = ccui.Scale9Sprite:create()

	var_20_4:initWithFile(var_20_3, var_20_1)
	var_20_4:setScale9Enabled(true)
	var_20_4:size(var_20_2)

	local var_20_5, var_20_6 = arg_20_1:xy()
	local var_20_7 = arg_20_1:parent()

	arg_20_1:retain():removeSelf():xy(0, 0)

	local var_20_8 = cc.ClippingNode:create(var_20_4):setAlphaThreshold(0.15):size(var_20_2):add(arg_20_1):xy(var_20_5, var_20_6):addTo(var_20_7)

	arg_20_1:release()
end

function var_0_3.initBar(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = "battle/craft/bar_card_b.png"
	local var_21_1 = arg_21_1:size()
	local var_21_2 = cc.rect(0, 0, var_21_1.width, var_21_1.height)
	local var_21_3 = var_21_1.width
	local var_21_4 = ccui.Scale9Sprite:create()

	var_21_4:initWithFile(var_21_2, var_21_0)
	var_21_4:setScale9Enabled(isScale9Enabled)
	var_21_4:size(var_21_1):anchorPoint(0, 0):setCapInsets(var_21_2)

	local var_21_5 = ccui.Scale9Sprite:create()

	var_21_5:initWithFile(var_21_2, var_21_0)
	var_21_5:setScale9Enabled(isScale9Enabled)
	var_21_5:size(var_21_1):anchorPoint(0, 0):setCapInsets(var_21_2)
	cc.ClippingNode:create(var_21_5):setAlphaThreshold(0.15):anchorPoint(0, 0):size(var_21_1):add(var_21_4, 999, "img"):x(arg_21_2 == 1 and 0 or var_21_3):scale(arg_21_2, 1):addTo(arg_21_1, 999, "clip")

	function arg_21_1.whenChange(arg_22_0, arg_22_1)
		local var_22_0 = var_21_3 * (arg_22_1 / 100 - 1)

		var_21_4:stopAllActions()

		local var_22_1 = transition.executeSequence(var_21_4):moveTo(arg_22_0, var_22_0, 0):done()
	end
end

return var_0_3
