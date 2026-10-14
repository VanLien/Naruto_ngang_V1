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
	offx = 102,
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
	2,
	8
}

local function var_0_3(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = "th"

	if arg_1_1 == 1 then
		var_1_0 = "st"
	elseif arg_1_1 == 2 then
		var_1_0 = "nd"
	elseif arg_1_1 == 3 then
		var_1_0 = "rd"
	end

	arg_1_0:scale(arg_1_2.scale)
	arg_1_0:get("num"):setString(tostring(arg_1_1)):xy(arg_1_2.pos1)
	arg_1_0:get("txt"):setString(var_1_0):xy(arg_1_2.pos2)
end

local var_0_4 = class("GymSpecView", battleModule.CBase)

var_0_4.RESOURCE_FILENAME = "battle_craft.json"
var_0_4.RESOURCE_BINDING = {
	selfInfo = "selfInfo",
	enemyWin = "enemyWin",
	backUpItem = "backUpItem",
	selfMp = "selfMp",
	selfWin = "selfWin",
	enemyMp = "enemyMp",
	["enemyInfo.enemyList"] = "enemyInfoList",
	["selfInfo.selfList"] = "selfInfoList",
	enemyInfo = "enemyInfo"
}

function var_0_4.ctor(arg_2_0, arg_2_1)
	battleModule.CBase.ctor(arg_2_0, arg_2_1)

	arg_2_0.root = cache.createWidget(arg_2_0.RESOURCE_FILENAME)

	bindUI(arg_2_0, arg_2_0.root, arg_2_0.RESOURCE_BINDING)
	arg_2_0.root:addTo(arg_2_1, 99):show()
	arg_2_0:init()
	arg_2_0:initBar(arg_2_0.selfMp:get("progress"), 1)
	arg_2_0:initBar(arg_2_0.enemyMp:get("progress"), -1)

	arg_2_0.selfInfoProgress = arg_2_0.selfInfo:get("progress")
	arg_2_0.enemyInfoProgress = arg_2_0.enemyInfo:get("progress")

	arg_2_0:initProgressBar(arg_2_0.selfInfo:get("progress"))
	arg_2_0:initProgressBar(arg_2_0.enemyInfo:get("progress"))
end

function var_0_4.init(arg_3_0)
	arg_3_0.selfWin:hide()
	arg_3_0.enemyWin:hide()

	arg_3_0.myHpPercent = 100
	arg_3_0.enemyHpPercent = 100
	arg_3_0.myMpPercent = 0
	arg_3_0.enemyMpPercent = 0
	arg_3_0.items = {
		{},
		{}
	}

	local var_3_0 = arg_3_0.parent:getPlayModel()

	nodetools.invoke(arg_3_0.selfInfo, {
		"secondIcon",
		"thirdIcon",
		"iconBase1",
		"iconBase2"
	}, "hide")
	nodetools.invoke(arg_3_0.enemyInfo, {
		"secondIcon",
		"thirdIcon",
		"iconBase1",
		"iconBase2"
	}, "hide")

	arg_3_0.backUpIconData = {
		{},
		{}
	}

	arg_3_0.root:setVisible(false)
end

function var_0_4.setCurrent(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0.parent:getPlayModel()
	local var_4_1 = var_4_0:getFirstRoleOut(arg_4_2)
	local var_4_2 = csv.unit[var_4_1.roleId].cardIcon2

	arg_4_1:get("current"):loadTexture(var_4_2)

	local var_4_3 = csv.unit[var_4_1.roleId].name

	arg_4_1:get("name"):setString(var_4_3)
	var_0_3(arg_4_1:get("firstIcon"), var_4_0.forceWaveNum[arg_4_2], var_0_0)
end

function var_0_4.setSkillName(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0.parent:getPlayModel():getFirstRoleOut(arg_5_2)
	local var_5_1 = ""

	for iter_5_0, iter_5_1 in pairs(var_5_0.skills) do
		local var_5_2 = csv.skill[iter_5_0]

		if var_5_2.skillType2 == battle.MainSkillType.BigSkill then
			var_5_1 = var_5_2.skillName
		end
	end

	arg_5_1:get("skillname"):setString(var_5_1)
	adapt.setTextScaleWithWidth(arg_5_1:get("skillname"), nil, 220)
end

function var_0_4.syncBackUpData(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.parent:getPlayModel()
	local var_6_1 = var_6_0.backUp[arg_6_1]
	local var_6_2 = {}

	for iter_6_0, iter_6_1 in ipairs(var_6_1) do
		if iter_6_0 ~= var_6_0.forceWaveNum[arg_6_1] then
			local var_6_3 = iter_6_1[var_0_2[arg_6_1]]
			local var_6_4 = {
				rank = iter_6_0,
				unitId = var_6_3.roleId,
				advance = var_6_3.advance,
				grayState = iter_6_0 < var_6_0.forceWaveNum[arg_6_1] and 2 or 1,
				flip = arg_6_1 == 2
			}

			table.insert(var_6_2, var_6_4)
		end
	end

	if arg_6_1 == 1 then
		arg_6_0:updateBackUpView(arg_6_0.selfInfoList, var_6_2, arg_6_1)
	else
		arg_6_0:updateBackUpView(arg_6_0.enemyInfoList, var_6_2, arg_6_1)
	end
end

function var_0_4.updateBackUpView(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_0.parent:getPlayModel()

	local function var_7_1(arg_8_0)
		if arg_7_0.items[arg_7_3][arg_8_0] then
			return arg_7_0.items[arg_7_3][arg_8_0]
		end

		local var_8_0 = arg_7_0.backUpItem:clone()

		var_8_0:addTo(arg_7_1)
		table.insert(arg_7_0.items[arg_7_3], var_8_0)

		local var_8_1 = var_8_0:size()
		local var_8_2

		if arg_7_3 == 1 then
			var_8_2 = arg_7_1:x() + var_8_1.width * (arg_8_0 - 0.5) + 18 * (arg_8_0 - 1)
		else
			var_8_2 = arg_7_1:x() - var_8_1.width * (arg_8_0 - 0.5) - 18 * (arg_8_0 - 1)
		end

		var_8_0:xy(var_8_2, arg_7_1:y())

		return var_8_0
	end

	for iter_7_0, iter_7_1 in ipairs(arg_7_2) do
		local var_7_2 = var_7_1(iter_7_0):multiget("sortIcon", "iconBase")

		var_0_3(var_7_2.sortIcon, iter_7_1.rank, var_0_1)

		if arg_7_3 == 2 then
			var_7_2.sortIcon:xy(var_0_1.offx, var_7_2.sortIcon:y())
		end

		var_0_4.setIconByData(var_7_2.iconBase, iter_7_1)
	end
end

function var_0_4.onInitPvp(arg_9_0)
	arg_9_0:setCurrent(arg_9_0.selfInfo, 1)
	arg_9_0:setCurrent(arg_9_0.enemyInfo, 2)
	arg_9_0:setSkillName(arg_9_0.selfMp, 1)
	arg_9_0:setSkillName(arg_9_0.enemyMp, 2)
	arg_9_0:syncBackUpData(1)
	arg_9_0:syncBackUpData(2)
	arg_9_0.root:setVisible(true)
end

function var_0_4.onChangeWave(arg_10_0, arg_10_1)
	if arg_10_1 == 1 then
		arg_10_0:setCurrent(arg_10_0.enemyInfo, 2)
		arg_10_0:setSkillName(arg_10_0.enemyMp, 2)
		arg_10_0:syncBackUpData(2)
	else
		arg_10_0:setCurrent(arg_10_0.selfInfo, 1)
		arg_10_0:setSkillName(arg_10_0.selfMp, 1)
		arg_10_0:syncBackUpData(1)
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

function var_0_4.onChangeHpMp(arg_15_0, arg_15_1)
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

function var_0_4.setIconByData(arg_17_0, arg_17_1)
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

function var_0_4.onShowSpec(arg_18_0, arg_18_1)
	arg_18_0.root:setVisible(arg_18_1)
end

function var_0_4.onClose(arg_19_0)
	ViewBase.onClose(arg_19_0)
end

function var_0_4.initProgressBar(arg_20_0, arg_20_1)
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

function var_0_4.initBar(arg_21_0, arg_21_1, arg_21_2)
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

return var_0_4
