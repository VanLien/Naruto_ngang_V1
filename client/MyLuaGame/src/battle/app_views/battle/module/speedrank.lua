local var_0_0 = {
	green = "battle/box_elves_green.png",
	gray = "battle/box_elves_gray.png",
	red = "battle/box_elves_red.png"
}
local var_0_1 = class("SpeedRank", battleModule.CBase)
local var_0_2 = 6
local var_0_3 = 0.9

function var_0_1.ctor(arg_1_0, arg_1_1)
	battleModule.CBase.ctor(arg_1_0, arg_1_1)

	arg_1_0.widget = arg_1_0.parent.UIWidgetMid:get("widgetPanel.speedRank")
	arg_1_0.iconItem = arg_1_0.widget:get("rankItem")
	arg_1_0.backGound = arg_1_0.widget:get("di")
	arg_1_0.iconRange = arg_1_0.widget:get("iconRange")
	arg_1_0.barLength = arg_1_0.iconRange:size().height
	arg_1_0.minIconSpace = arg_1_0.iconItem:size().height / 4

	arg_1_0.iconItem:hide()

	arg_1_0.newRanksInfo = {}
	arg_1_0.objWidget = {}
	arg_1_0.firstObjPosY = 0
	arg_1_0.posAddValue = 0
	arg_1_0.refreshCount = 0
	arg_1_0.specObjects = {}

	arg_1_0:initSpecRoundObject()
	arg_1_0.roundWidget:show()

	arg_1_0.captureSprite = CRenderSprite.newWithNodes(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444, arg_1_0.widget)

	arg_1_0.captureSprite:addTo(arg_1_0.parent.UIWidgetMid:get("widgetPanel")):coverTo(arg_1_0.widget)
	arg_1_0.captureSprite:setCaptureOffest(cc.p(90, 0))
	arg_1_0.roundWidget:hide()
end

function var_0_1.onRankRefresh(arg_2_0, arg_2_1)
	arg_2_0.refreshCount = arg_2_0.refreshCount + 1

	local var_2_0 = {}

	if arg_2_1 then
		arg_2_0.newRanksInfo = arg_2_1
	elseif arg_2_0.parent then
		arg_2_0.newRanksInfo, var_2_0 = arg_2_0.parent:getPlayModel():getSpeedRankArray()
	else
		arg_2_0.newRanksInfo, var_2_0 = {}, {}
	end

	local var_2_1 = 0
	local var_2_2 = math.huge
	local var_2_3 = false
	local var_2_4 = {}
	local var_2_5 = {}

	for iter_2_0, iter_2_1 in ipairs(arg_2_0.newRanksInfo) do
		if iter_2_1.isAlreadyDead and not iter_2_1:isAlreadyDead() then
			local var_2_6 = iter_2_1:speed()
			local var_2_7 = var_2_0[iter_2_0] ~= 0 and var_2_0[iter_2_0]
			local var_2_8 = var_2_7 and csv.unit[var_2_7].icon or iter_2_1.unitCfg.icon

			if var_2_0[iter_2_0] and var_2_0[iter_2_0] ~= 0 then
				if not var_2_3 and iter_2_1.unitID % 2 == 0 then
					var_2_6 = iter_2_1:speed(0)
				end

				if var_2_3 and iter_2_1.unitID % 2 ~= var_2_0[iter_2_0] % 2 then
					var_2_6 = iter_2_1:speed(0)
				end
			end

			local var_2_9 = arg_2_0:call("getSceneObjById", iter_2_1.id)
			local var_2_10 = iter_2_1:getOverlaySpecBuffByIdx("changeToRandEnemyObj")

			var_2_1 = math.max(var_2_1, var_2_6)
			var_2_2 = math.min(var_2_2, var_2_6)

			local var_2_11 = {
				objSeat = var_2_9.seat,
				dbID = tostring(iter_2_1) .. tostring(var_2_8),
				speed = var_2_6,
				heroIcon = var_2_10 and var_2_10.oldUnitCfg.icon or var_2_8,
				force = var_2_9.force,
				faceTo = var_2_9.faceTo,
				hasAttacked = var_2_3,
				curHero = iter_2_0 == 1
			}

			if not var_2_3 then
				table.insert(var_2_4, var_2_11)
			else
				table.insert(var_2_5, var_2_11)
			end
		else
			var_2_3 = true
		end
	end

	arg_2_0.maxSpeed = var_2_1
	arg_2_0.minSpeed = var_2_2

	for iter_2_2, iter_2_3 in ipairs(arg_2_0.specObjects) do
		iter_2_3:sort(var_2_4, var_2_5)
	end

	table.sort(var_2_5, function(arg_3_0, arg_3_1)
		return arg_3_0.speed > arg_3_1.speed
	end)

	arg_2_0.speedRankTb = arraytools.merge({
		var_2_4,
		var_2_5
	})

	arg_2_0:setWidgetSpace()

	local var_2_12 = arg_2_0.refreshCount
	local var_2_13 = 0

	local function var_2_14()
		var_2_13 = var_2_13 - 1

		if var_2_13 ~= 0 or var_2_12 ~= arg_2_0.refreshCount then
			return
		end

		arg_2_0.captureSprite:show()
	end

	arg_2_0.captureSprite:hide()

	local var_2_15 = arg_2_0.iconRange:size().width / 2
	local var_2_16 = -126

	for iter_2_4, iter_2_5 in pairs(arg_2_0.speedRankTb) do
		var_2_13 = var_2_13 + 1

		local var_2_17 = arg_2_0:getWidget(iter_2_4, iter_2_5.dbID, iter_2_5.heroIcon, iter_2_5.force, iter_2_5.faceTo)
		local var_2_18 = 0

		if iter_2_5.posY then
			var_2_18 = iter_2_5.posY - arg_2_0.firstObjPosY

			if var_2_18 < 0 then
				var_2_18 = var_2_18 + arg_2_0.barLength + arg_2_0.posAddValue
			end
		end

		if var_2_18 == 0 then
			var_2_17:scale(1.65)
			transition.executeSequence(var_2_17, true):moveTo(0.2, var_2_15, var_2_16):func(var_2_14):done()
		else
			var_2_17:scale(1)
			transition.executeSequence(var_2_17, true):moveTo(0.2, var_2_15, var_2_18):func(var_2_14):done()
		end
	end
end

function var_0_1.setWidgetSpace(arg_5_0)
	local var_5_0 = arg_5_0.maxSpeed
	local var_5_1 = arg_5_0.minSpeed
	local var_5_2 = arg_5_0.speedRankTb
	local var_5_3 = var_5_0 - var_5_1
	local var_5_4 = 50
	local var_5_5 = math.min(arg_5_0.barLength / table.length(var_5_2), var_5_4)

	local function var_5_6(arg_6_0, arg_6_1)
		local var_6_0 = arg_6_0.speed
		local var_6_1 = arg_6_1.speed
		local var_6_2 = math.abs(var_6_0 - var_6_1) / var_5_3 * arg_5_0.barLength

		return math.max(var_6_2, var_5_5)
	end

	local var_5_7 = {}
	local var_5_8 = 0
	local var_5_9 = arg_5_0.barLength

	for iter_5_0 = 1, table.length(var_5_2) - 1 do
		local var_5_10 = var_5_6(var_5_2[iter_5_0], var_5_2[iter_5_0 + 1])

		var_5_7[iter_5_0] = var_5_10

		if var_5_5 < var_5_10 then
			var_5_8 = var_5_8 + var_5_10
		else
			var_5_9 = var_5_9 - var_5_10
		end
	end

	local var_5_11 = var_5_8 / var_5_9

	if var_5_11 > 1 then
		for iter_5_1, iter_5_2 in pairs(var_5_7) do
			if var_5_5 < iter_5_2 then
				var_5_7[iter_5_1] = iter_5_2 / var_5_11
			end
		end
	end

	local var_5_12 = {}
	local var_5_13 = 0

	if table.length(var_5_7) > 1 then
		local var_5_14 = 0

		for iter_5_3 = 1, math.floor(#var_5_7 / 2) do
			var_5_12[iter_5_3] = 1.8 - 1.6 / (table.length(var_5_7) - 1) * (iter_5_3 - 1)
			var_5_12[table.length(var_5_7) - iter_5_3 + 1] = 0.2 + 1.6 / (table.length(var_5_7) - 1) * (iter_5_3 - 1)
		end

		if table.length(var_5_7) % 2 ~= 0 then
			var_5_12[math.floor(table.length(var_5_7) / 2) + 1] = 1
		end

		for iter_5_4 = 1, table.length(var_5_2) - 1 do
			var_5_14 = var_5_14 + var_5_7[iter_5_4]
			var_5_7[iter_5_4] = var_5_7[iter_5_4] * var_5_12[iter_5_4]

			local var_5_15 = var_5_2[iter_5_4]
			local var_5_16 = var_5_2[iter_5_4 + 1]

			if var_5_16.fixedSpacePrecent then
				var_5_7[iter_5_4] = var_5_16.fixedSpacePrecent[1] * arg_5_0.barLength
			elseif var_5_15.fixedSpacePrecent then
				var_5_7[iter_5_4] = var_5_15.fixedSpacePrecent[2] * arg_5_0.barLength
			end

			var_5_13 = var_5_13 + var_5_7[iter_5_4]
		end

		local var_5_17 = var_5_14 / var_5_13

		for iter_5_5 = 1, table.length(var_5_2) - 1 do
			var_5_7[iter_5_5] = var_5_7[iter_5_5] * var_5_17
		end
	end

	local var_5_18
	local var_5_19 = 0
	local var_5_20 = 0

	for iter_5_6 = 1, table.length(var_5_2) do
		local var_5_21 = var_5_2[iter_5_6]

		if iter_5_6 == 1 then
			var_5_20 = var_5_5
		else
			var_5_20 = var_5_20 + var_5_7[iter_5_6 - 1]
		end

		if not var_5_21.hasAttacked and not var_5_18 then
			var_5_19 = var_5_7[iter_5_6 - 1] or var_5_19
			var_5_18 = var_5_20
		end

		var_5_21.posY = var_5_20
	end

	arg_5_0.posAddValue = var_5_19
	arg_5_0.firstObjPosY = var_5_18 or arg_5_0.firstObjPosY
end

function var_0_1.getWidget(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	local var_7_0 = arg_7_6 or table.length(arg_7_0.speedRankTb) - arg_7_1

	if arg_7_0.objWidget[arg_7_2] then
		return arg_7_0.objWidget[arg_7_2]:z(var_7_0):show()
	end

	local var_7_1 = arg_7_0.iconItem:clone()
	local var_7_2 = var_7_1:get("icon")

	var_7_1:loadTexture(arg_7_4 == 1 and var_0_0.green or var_0_0.red):anchorPoint(0.5, 0.5):addTo(arg_7_0.iconRange, var_7_0):show()
	var_7_2:loadTexture(arg_7_3):scale(var_0_3)

	arg_7_0.objWidget[arg_7_2] = var_7_1

	return var_7_1:show()
end

function var_0_1.initSpecRoundObject(arg_8_0)
	local var_8_0 = {
		speed = -100,
		icon = "battle/icon_sl.png",
		hasAttacked = false,
		fixedSpacePrecent = {
			0.15,
			0.15
		}
	}

	var_8_0.dbID = tostring(var_8_0)

	function var_8_0.sort(arg_9_0, arg_9_1, arg_9_2)
		table.insert(arg_9_1, arg_9_0)

		arg_8_0.minSpeed = math.min(arg_8_0.minSpeed, arg_9_0.speed)

		arg_8_0.objWidget[arg_9_0.dbID]:get("round"):setText(arg_8_0.parent:getPlayModel().curRound + 1)
	end

	local var_8_1 = arg_8_0.iconItem:clone()
	local var_8_2 = var_8_1:get("icon")
	local var_8_3 = newCSprite("battle/logo_sxd.png")

	var_8_1:addChild(var_8_3)
	var_8_3:setAnchorPoint(cc.p(0, 1))
	var_8_3:setPosition(cc.p(20 - var_8_1:width(), var_8_1:height() - 30))
	var_8_3:setScaleX(-1)
	var_8_3:setRotation(-30)

	local var_8_4 = ccui.Text:create("1", "font/youmi.ttf", 48)

	var_8_1:addChild(var_8_4, 99, "round")
	var_8_4:setPosition(cc.p(15 - var_8_1:width(), var_8_1:height() - 25))
	var_8_1:loadTexture(var_0_0.gray):anchorPoint(0.5, 0.5):addTo(arg_8_0.iconRange):xy(cc.p(arg_8_0.iconRange:size().width / 2, 0))
	var_8_2:loadTexture(var_8_0.icon):scale(-1, 1):xy(var_8_1:width() / 2, var_8_1:height() / 2)

	arg_8_0.objWidget[var_8_0.dbID] = var_8_1

	table.insert(arg_8_0.specObjects, var_8_0)

	arg_8_0.roundWidget = var_8_1
end

function var_0_1.onNewBattleRound(arg_10_0, arg_10_1)
	arg_10_0.nowWave = arg_10_0.nowWave or arg_10_1.wave

	if arg_10_1.wave > arg_10_0.nowWave then
		arg_10_0.nowWave = arg_10_1.wave
	end

	for iter_10_0, iter_10_1 in pairs(arg_10_0.objWidget) do
		iter_10_1:hide()
	end

	arg_10_0.widget:show()
	arg_10_0:onRankRefresh()
end

return var_0_1
