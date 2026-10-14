local var_0_0 = class("BattleCrossMineView", battleModule.CBase)

var_0_0.RESOURCE_FILENAME = "battle_cross_mine.json"
var_0_0.RESOURCE_BINDING = {
	selfInfo = "selfInfo",
	["totalScore.score"] = "scoreNum",
	totalScore = "totalScore",
	enemyInfo = "enemyInfo"
}

function var_0_0.ctor(arg_1_0, arg_1_1)
	battleModule.CBase.ctor(arg_1_0, arg_1_1)

	arg_1_0.root = cache.createWidget(arg_1_0.RESOURCE_FILENAME)

	bindUI(arg_1_0, arg_1_0.root, arg_1_0.RESOURCE_BINDING)
	arg_1_0.root:addTo(arg_1_1, 99):show()
	arg_1_0:init()
end

function var_0_0.init(arg_2_0)
	nodetools.invoke(arg_2_0.selfInfo, {
		"result1",
		"result2",
		"result3"
	}, "hide")
	nodetools.invoke(arg_2_0.enemyInfo, {
		"result1",
		"result2",
		"result3"
	}, "hide")

	local var_2_0 = arg_2_0.parent.data

	arg_2_0.leftHeadPnl = arg_2_0.parent.UIWidgetLeft:get("infoPVP")
	arg_2_0.rightHeadPnl = arg_2_0.parent.UIWidgetRight:get("infoPVP")

	arg_2_0.leftHeadPnl:get("level"):setFontSize(40):anchorPoint(0, 0.5):x(arg_2_0.leftHeadPnl:get("roleName"):x()):setString(getServerArea(var_2_0.role_key[1], true))
	arg_2_0.leftHeadPnl:get("levelLv"):visible(false)
	arg_2_0.rightHeadPnl:get("level"):setFontSize(40):anchorPoint(1, 0.5):x(arg_2_0.rightHeadPnl:get("roleName"):x()):setString(getServerArea(var_2_0.defence_role_key[1], true))
	arg_2_0.rightHeadPnl:get("levellv"):visible(false)
	arg_2_0:call("refreshInfoPvP")
	arg_2_0.root:setVisible(false)
end

function var_0_0.onInitPvp(arg_3_0)
	arg_3_0:setTeamIcon("selfInfo", 1)
	arg_3_0:setTeamIcon("enemyInfo", 2)
	arg_3_0:setScore(0, 0)
	arg_3_0.root:setVisible(true)
end

function var_0_0.setTeamIcon(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0.parent:getPlayModel().data.roleOut[arg_4_2]

	local function var_4_1(arg_5_0)
		local var_5_0 = next(arg_5_0)
		local var_5_1 = 0

		for iter_5_0, iter_5_1 in pairs(arg_5_0) do
			if var_5_1 < iter_5_1.fightPoint then
				var_5_0 = iter_5_0
				var_5_1 = iter_5_1.fightPoint
			end
		end

		return var_5_0
	end

	for iter_4_0 = 1, 3 do
		local var_4_2 = var_4_1(var_4_0[iter_4_0])
		local var_4_3 = var_4_0[iter_4_0][var_4_2]
		local var_4_4 = arg_4_0[arg_4_1]:get("iconBase" .. iter_4_0)
		local var_4_5 = {
			grayState = 0,
			unitId = var_4_3.roleId,
			advance = var_4_3.advance,
			level = var_4_3.level,
			star = var_4_3.star,
			rarity = csv.unit[var_4_3.roleId].rarity
		}

		var_0_0.setIconByData(var_4_4, var_4_5)
	end
end

function var_0_0.setIconByData(arg_6_0, arg_6_1)
	if arg_6_0.panel then
		arg_6_0:removeAllChildren()
	end

	local var_6_0 = cc.size(198, 198)
	local var_6_1 = ccui.Layout:create():size(198, 198):scale(0.8):addTo(arg_6_0, 1, "_card_")
	local var_6_2 = dataEasy.getQuality(arg_6_1.advance, false)
	local var_6_3 = ui.QUALITY_BOX[var_6_2]
	local var_6_4 = ccui.ImageView:create(var_6_3):alignCenter(var_6_0):addTo(var_6_1, 1, "imgBG")
	local var_6_5 = ccui.ImageView:create(string.format("common/icon/panel_icon_k%d.png", var_6_2)):alignCenter(var_6_0):addTo(var_6_1, 3, "imgFG")

	arg_6_0.panel = var_6_1

	local var_6_6 = ccui.ImageView:create(csv.unit[arg_6_1.unitId].cardIcon):alignCenter(var_6_0):scale(2):addTo(var_6_1, 2, "icon")
	local var_6_7 = arg_6_1.grayState == 2 and "hsl_gray" or "normal"

	cache.setShader(var_6_4, false, var_6_7)
	cache.setShader(var_6_6, false, var_6_7)

	local var_6_8 = ccui.Layout:create():size(150, 60):align(cc.p(0, 1)):addTo(var_6_1):xy(90, 35):z(4)
	local var_6_9 = cc.Label:createWithTTF("Lv", ui.FONT_PATH, 24):align(cc.p(1, 0), 75, 55):addTo(var_6_8, 2, "txtLv")

	text.addEffect(var_6_9, {
		outline = {
			color = ui.COLORS.OUTLINE.DEFAULT
		}
	})

	local var_6_10 = cc.Label:createWithTTF("", ui.FONT_PATH, 30):align(cc.p(1, 0), 90, 55):addTo(var_6_8, 2, "txtLvNum"):show():text(arg_6_1.level)

	text.addEffect(var_6_10, {
		outline = {
			color = ui.COLORS.OUTLINE.DEFAULT
		}
	})
	adapt.oneLinePos(var_6_10, var_6_9, cc.p(5, 0), "right")

	local var_6_11 = var_6_1:size()
	local var_6_12 = ccui.Layout:create():size(var_6_11.width, 70):align(cc.p(0, 0), 0, 0):addTo(var_6_1, 5, "star")

	if tonumber(arg_6_1.star) then
		local var_6_13 = 12
		local var_6_14 = arg_6_1.star > 6 and 6 or arg_6_1.star

		for iter_6_0 = 1, var_6_14 do
			local var_6_15 = arg_6_1.star - 6
			local var_6_16 = "city/card/equip/icon_star.png"

			if iter_6_0 <= var_6_15 then
				var_6_16 = "common/icon/icon_star_z1.png"
			end

			ccui.ImageView:create(var_6_16):xy(99 - var_6_13 * (var_6_14 + 1 - 2 * iter_6_0), 20):addTo(var_6_12, 4, "star"):scale(0.75)
		end
	end

	local var_6_17 = ccui.ImageView:create():align(cc.p(0.5, 0.5), 36, 164):addTo(var_6_1, 14, "rarity"):scale(0.62)

	if not tonumber(arg_6_1.rarity) then
		var_6_17:hide()
	else
		var_6_17:texture(ui.RARITY_ICON[arg_6_1.rarity]):show()
		var_6_4:texture(ui.QUALITY_BOX[arg_6_1.rarity + 2])
		var_6_5:show():texture(string.format("common/icon/panel_icon_k%d.png", arg_6_1.rarity + 2)):show()
	end

	if arg_6_1.flip then
		arg_6_0:setFlippedX(true)
	end
end

function var_0_0.onShowSpec(arg_7_0, arg_7_1)
	arg_7_0.root:setVisible(arg_7_1)
end

function var_0_0.onChangeWave(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	arg_8_0:setScore(arg_8_1, arg_8_2 - arg_8_1)

	if arg_8_3 then
		arg_8_0:setWinFlag(arg_8_3, arg_8_2, true)
		arg_8_0:setWinFlag(3 - arg_8_3, arg_8_2, false)
		arg_8_0:setLoseGray(arg_8_1, arg_8_2, 3 - arg_8_3)
	end
end

function var_0_0.setScore(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0.scoreNum = rich.createByStr(string.format(gLanguageCsv.crossMinePVPScore, arg_9_1, arg_9_2), 40):anchorPoint(0.5, 0.5):xy(arg_9_0.scoreNum:x(), arg_9_0.scoreNum:y()):addTo(arg_9_0.totalScore):z(10), arg_9_0.scoreNum:removeFromParent()
end

function var_0_0.setWinFlag(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = (arg_10_1 == 1 and arg_10_0.selfInfo or arg_10_0.enemyInfo):get("result" .. arg_10_2)

	if arg_10_3 then
		var_10_0:loadTexture("battle/cross_mine/logo_win.png")
	else
		var_10_0:loadTexture("battle/cross_mine/logo_lose.png")
	end

	var_10_0:show()
end

function var_0_0.setLoseGray(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = (arg_11_3 == 1 and arg_11_0.selfInfo or arg_11_0.enemyInfo):get("iconBase" .. arg_11_2)

	if var_11_0.panel then
		local var_11_1 = var_11_0.panel:get("imgBG")
		local var_11_2 = var_11_0.panel:get("icon")
		local var_11_3 = cc.c3b(128, 128, 128)

		var_11_1:color(var_11_3)
		var_11_2:color(var_11_3)
	end
end

function var_0_0.onClose(arg_12_0)
	ViewBase.onClose(arg_12_0)
end

return var_0_0
