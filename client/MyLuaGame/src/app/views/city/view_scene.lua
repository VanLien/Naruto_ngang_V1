local var_0_0

if device.platform == "windows" then
	-- block empty
end

local var_0_1 = {}
local var_0_2 = require("app.views.city.halloween_messages"):getInstance()
local var_0_3 = game.YYHUODONG_TYPE_ENUM_TABLE
local var_0_4 = {
	sceneSet = 1,
	mysteryShop = 3,
	cityMan = 2
}
local var_0_5 = 2
local var_0_6 = 2012211734
local var_0_7 = {
	3,
	9,
	16
}
local var_0_8 = {
	springfestival = {
		y2 = -230,
		height = 400,
		offx2 = 50,
		spine2 = "zhuchangjing/chunjiezhucheng.skel",
		scale = 1.7,
		spineName1 = "dumpling",
		callback = "onClickChunjieDumpling",
		effectName1 = "day_loop",
		spine1 = "zhuchangjing/chunjiezhucheng_light.skel",
		y1 = -320,
		offx1 = 210,
		z2 = 120,
		spineName2 = "chunjieMan",
		z1 = 150,
		width = 700,
		effectName2 = "effect_loop",
		pos = cc.p(1020, 230)
	},
	christmastree = {
		y2 = 200,
		height = 800,
		spine2 = "christmastree/shengdanxiong.skel",
		offx2 = 0,
		scale = 1.7,
		spineName1 = "shengdanshu",
		callback = "onClickChristmastree",
		effectName1 = "day_loop",
		spine1 = "christmastree/shengdanshu.skel",
		y1 = 200,
		offx1 = 0,
		z2 = 150,
		spineName2 = "shengdanxiong",
		z1 = 120,
		effectNameActive2 = "dailingqu_loop",
		width = 850,
		effectName2 = "daiji_loop",
		pos = cc.p(900, 200)
	},
	midmoon = {
		spine2 = "event/huodongtandian.skel",
		z2 = 120,
		spineName2 = "midmoon",
		width = 750,
		height = 650,
		offx2 = 0,
		scale = 1.4,
		effectNameActive2 = "day_loop",
		callback = "onClickMidmoon",
		y2 = 200,
		effectName2 = "day2_loop",
		pos = cc.p(2900, 200)
	},
	halloween = {
		spine2 = "wanshengjie/shadiao.skel",
		z2 = 0,
		spineName2 = "shadiao",
		offx2 = 0,
		width = 650,
		height = 200,
		scale = 2,
		callback = "onClickHalloweenFour",
		y2 = 10,
		effectName2 = "effect_loop",
		pos = cc.p(1005, 245)
	}
}
local var_0_9
local var_0_10 = "zhuchangjing/chezi.skel"
local var_0_11 = "narutomaincity/shenmishangdian.skel"
local var_0_12 = 1
local var_0_13 = cc.p(2800, 160)
local var_0_14 = "zhuchangjing/zhuchangjing_shan.skel"
local var_0_15 = "zhuchangjing/zhuchangjing_fang.skel"
local var_0_16 = "zhuchangjing/zhuchangjing_che.skel"
local var_0_17 = 1.55

;({})[1] = {
	name = "day",
	res = "narutomaincity/maincity.skel",
	zOrder = 1
}

function var_0_1.initSceneData(arg_1_0)
	arg_1_0.refreshBgShade = idler.new(true)
	arg_1_0.roleFigureNum = 1
	arg_1_0.roleSprite = nil
	arg_1_0.isNight = idler.new(false)

	arg_1_0:initHalloween()
	arg_1_0:initBgPanel()
	arg_1_0:addCitySprites()
	arg_1_0:refreshMysteryShop()
	arg_1_0:initSnowman()
	arg_1_0:fishingGameTip()
	idlereasy.when(arg_1_0.level, function(arg_2_0, arg_2_1)
		arg_1_0:dailyAssistantTip()
	end)
	idlereasy.when(arg_1_0.crossFishingRound, function(arg_3_0, arg_3_1)
		local var_3_0 = dataEasy.isUnlock(gUnlockCsv.fishing)
	end)
	arg_1_0:initBgShade()
	performWithDelay(arg_1_0, function()
		return
	end, 0)
end

function var_0_1.initBgPanel(arg_5_0)
	arg_5_0.effects = {}

	idlereasy.any({
		arg_5_0.yyOpen,
		arg_5_0.yyhuodongs
	}, function(arg_6_0, arg_6_1, arg_6_2)
		arg_5_0.halloweenDailyAward:set(false)

		if not arg_5_0:initLoginWeal() then
			for iter_6_0, iter_6_1 in pairs(var_0_8) do
				if iter_6_1.spineName1 then
					arg_5_0.effects[iter_6_1.spineName1] = nil
				end

				if iter_6_1.spineName2 then
					arg_5_0[iter_6_1.spineName2] = nil
				end

				if arg_5_0.bgPanel:get(iter_6_0) then
					arg_5_0.bgPanel:get(iter_6_0):removeSelf()
				end
			end
		end
	end)
end

function var_0_1.initLoginWeal(arg_7_0)
	local var_7_0 = arg_7_0.yyOpen:read()
	local var_7_1 = arg_7_0.yyhuodongs:read()
	local var_7_2 = false

	for iter_7_0, iter_7_1 in ipairs(var_7_0) do
		local var_7_3 = csv.yunying.yyhuodong[iter_7_1]
		local var_7_4 = var_7_3.clientParam.type

		if var_7_3.type == var_0_3.loginWeal and var_7_3.independent == -1 and var_0_8[var_7_4] then
			var_7_2 = true

			local var_7_5
			local var_7_6 = var_7_1[iter_7_1] or {}

			for iter_7_2, iter_7_3 in pairs(var_7_6.stamps or {}) do
				if iter_7_3 > 0 and (not var_7_5 or iter_7_2 < var_7_5) then
					var_7_5 = iter_7_2
				end
			end

			local var_7_7 = var_0_8[var_7_4]
			local var_7_8 = var_7_7.effectName1
			local var_7_9 = var_7_7.effectName2

			if var_7_5 and var_7_7.effectNameActive2 then
				var_7_9 = var_7_7.effectNameActive2
			end

			local var_7_10 = arg_7_0.bgPanel:get(var_7_4)

			if not var_7_10 then
				var_7_10 = ccui.Layout:create()

				var_7_10:setTouchEnabled(true)
				var_7_10:xy(var_7_7.pos)
				var_7_10:addTo(arg_7_0.bgPanel, 200, var_7_4)

				if var_0_0 then
					var_7_10:setBackGroundColorType(1)
					var_7_10:setBackGroundColor(cc.c3b(200, 0, 0))
					var_7_10:setBackGroundColorOpacity(100)
				end

				local var_7_11

				if var_7_7.spine1 then
					local var_7_12 = widget.addAnimation(var_7_10, var_7_7.spine1, var_7_8, var_7_7.z1):scale(var_7_7.scale)

					arg_7_0.effects[var_7_7.spineName1] = var_7_12

					if not var_7_11 then
						var_7_11 = var_7_12:box()

						var_7_10:size(var_7_7.width or var_7_11.width, var_7_7.height)
					end

					var_7_12:xy(var_7_11.width / 2 + var_7_7.offx1, var_7_7.y1)
				end

				if var_7_7.spine2 then
					local var_7_13 = widget.addAnimation(var_7_10, var_7_7.spine2, var_7_9, var_7_7.z2)

					arg_7_0[var_7_7.spineName2] = var_7_13

					if not var_7_11 then
						var_7_11 = var_7_13:box()

						var_7_10:size(var_7_7.width or var_7_11.width, var_7_7.height)
					end

					var_7_13:xy(var_7_11.width / 2 + var_7_7.offx2, var_7_7.y2):scale(var_7_7.scale)
				end
			else
				if arg_7_0.effects[var_7_7.spineName1] then
					arg_7_0.effects[var_7_7.spineName1]:play(var_7_8)
				end

				if var_7_7.spine2 and arg_7_0[var_7_7.spineName2] then
					arg_7_0[var_7_7.spineName2]:play(var_7_9)
				end
			end

			bind.click(arg_7_0, var_7_10, {
				method = functools.partial(arg_7_0[var_7_7.callback], arg_7_0, iter_7_1, var_7_5)
			})

			if var_7_4 == "halloween" then
				arg_7_0.halloweenDailyAward:set(true)
			end
		end
	end

	return var_7_2
end

function var_0_1.initBgShade(arg_8_0)
	local var_8_0 = {
		"roleSprite",
		"roleFigure"
	}

	for iter_8_0, iter_8_1 in pairs(var_0_8) do
		if iter_8_1.spineName2 then
			table.insert(var_8_0, iter_8_1.spineName2)
		end
	end

	local var_8_1 = gCommonConfigCsv.cityBgStartTime * 60
	local var_8_2 = {
		{
			res = "common/bg/city_bg_day.jpg",
			action = "day_loop",
			changeAction = "morning",
			duration = gCommonConfigCsv.cityBgDayDuration * 60,
			shaderColor = cc.vec4(1, 1, 1, 1)
		},
		{
			res = "common/bg/city_bg_night.jpg",
			action = "night_loop",
			changeAction = "dusk",
			duration = gCommonConfigCsv.cityBgNightDuration * 60,
			shaderColor = cc.vec4(0.75, 0.75, 1.2, 1)
		}
	}
	local var_8_3 = 0

	for iter_8_2, iter_8_3 in ipairs(var_8_2) do
		var_8_3 = var_8_3 + iter_8_3.duration
	end

	local var_8_4 = 1
	local var_8_5 = 0
	local var_8_6 = 60

	local function var_8_7(arg_9_0)
		local var_9_0 = var_8_2[var_8_4]

		arg_8_0:unSchedule(var_0_4.sceneSet)

		if arg_9_0 or not var_9_0.changeAction then
			arg_8_0.bgPanel:texture(var_9_0.res)

			for iter_9_0, iter_9_1 in ipairs(var_8_0) do
				if arg_8_0[iter_9_1] then
					cache.setColor2Shader(arg_8_0[iter_9_1], false, var_9_0.shaderColor)
				end
			end

			for iter_9_2, iter_9_3 in pairs(arg_8_0.citySpriteDatas) do
				cache.setColor2Shader(iter_9_3.target:get("effect"), false, var_9_0.shaderColor)
			end

			arg_8_0.curChangIndex = 0

			arg_8_0.isNight:set(var_8_4 == 2)
		else
			arg_8_0.bgPanel:texture(var_9_0.res)

			local var_9_1 = var_8_4 == 1 and #var_8_2 or var_8_4 - 1
			local var_9_2 = var_8_2[var_9_1].shaderColor
			local var_9_3 = var_9_0.shaderColor
			local var_9_4 = arg_8_0.curChangIndex or 0

			arg_8_0:schedule(function(arg_10_0)
				var_9_4 = var_9_4 + 1
				arg_8_0.curChangIndex = var_9_4

				local var_10_0 = var_9_4 / (var_8_6 / arg_10_0)
				local var_10_1 = {}

				for iter_10_0, iter_10_1 in pairs(var_9_3) do
					var_10_1[iter_10_0] = var_9_2[iter_10_0] + var_10_0 * (iter_10_1 - var_9_2[iter_10_0])
				end

				for iter_10_2, iter_10_3 in ipairs(var_8_0) do
					if arg_8_0[iter_10_3] then
						cache.setColor2Shader(arg_8_0[iter_10_3], false, var_10_1)
					end
				end

				for iter_10_4, iter_10_5 in pairs(arg_8_0.citySpriteDatas) do
					cache.setColor2Shader(iter_10_5.target:get("effect"), false, var_10_1)
				end

				if var_10_0 >= 1 then
					arg_8_0.isNight:set(var_8_4 == 2)

					arg_8_0.curChangIndex = 0

					arg_8_0.bgPanel:texture(var_9_0.res)

					return false
				end
			end, 0.016666666666666666, 0, var_0_4.sceneSet)
		end

		arg_8_0.bgPanel:stopAllActions()
		performWithDelay(arg_8_0.bgPanel, function()
			var_8_4 = var_8_4 % #var_8_2 + 1
			var_8_5 = var_8_2[var_8_4].duration

			var_8_7()
		end, var_8_5)
	end

	idlereasy.when(arg_8_0.refreshBgShade, function()
		local var_12_0 = time.getNowDate()

		var_8_5 = var_12_0.hour * 3600 + var_12_0.min * 60 + var_12_0.sec - var_8_1

		if var_8_5 < 0 then
			var_8_5 = var_8_5 + 86400
		end

		var_8_5 = var_8_5 % var_8_3

		for iter_12_0, iter_12_1 in ipairs(var_8_2) do
			if var_8_5 < iter_12_1.duration then
				var_8_5 = iter_12_1.duration - var_8_5
				var_8_4 = iter_12_0

				break
			end

			var_8_5 = var_8_5 - iter_12_1.duration
		end

		var_8_7(true)
	end)
end

function var_0_1.addCitySprites(arg_13_0)
	arg_13_0.roleFigure = widget.addAnimationByKey(arg_13_0.bgPanel, "effect/city_xiaoren.skel", "roleFigure", "city_xiaoren_loop", 1):xy(566, 136)

	idlereasy.when(arg_13_0.figure, function(arg_14_0, arg_14_1)
		local var_14_0 = gRoleFigureCsv[arg_14_1]
		local var_14_1 = var_14_0.resSpine
		local var_14_2 = string.gsub(var_14_1, "_city", "_ui")

		if arg_13_0.roleSprite then
			arg_13_0.roleSprite:removeFromParent()

			arg_13_0.roleSprite = nil
		end

		if var_14_2 and var_14_2 ~= "" then
			local var_14_3 = 0
			local var_14_4 = 30
			local var_14_5
			local var_14_6 = gCommonConfigCsv.citySpecialTimeMin
			local var_14_7 = ccui.Layout:create()

			var_14_7:setTouchEnabled(true)
			var_14_7:xy(500, 0)
			var_14_7:addTo(arg_13_0.bgPanel, var_14_0.zOrder)

			arg_13_0.roleSprite = var_14_7

			if var_0_0 then
				var_14_7:setBackGroundColorType(1)
				var_14_7:setBackGroundColor(cc.c3b(0, 0, 200))
				var_14_7:setBackGroundColorOpacity(100)
			end

			bind.click(arg_13_0, var_14_7, {
				method = functools.partial(arg_13_0.onClickRoleSprite, arg_13_0, arg_14_1)
			})

			local var_14_8 = widget.addAnimationByKey(var_14_7, var_14_2, "effect", "standby_loop", 1):scale(0.8)
			local var_14_9 = var_14_8:box()

			var_14_7:size(var_14_9.width * 2, var_14_9.height * 2)
			var_14_8:xy(0, -20)
			arg_13_0.refreshBgShade:notify()
			arg_13_0:schedule(function()
				var_14_3 = var_14_3 + 1

				if var_14_3 > var_14_6 then
					if not var_14_5 then
						var_14_5 = math.random(var_14_6, var_14_6 + var_14_4)
					end

					if var_14_3 >= var_14_5 and arg_13_0.roleSprite then
						var_14_3 = 0
						var_14_5 = nil

						arg_13_0.roleSprite:get("effect"):setSpriteEventHandler(function(arg_16_0, arg_16_1)
							arg_13_0.roleSprite:get("effect"):play("standby_loop")
						end, sp.EventType.ANIMATION_COMPLETE)
					end
				end
			end, 1, 0, var_0_4.cityMan)
		end
	end)

	arg_13_0.spriteUnfreezeYYData = idlereasy.new({})

	idlereasy.any({
		arg_13_0.yyOpen,
		arg_13_0.yyhuodongs
	}, function(arg_17_0, arg_17_1, arg_17_2)
		for iter_17_0, iter_17_1 in ipairs(arg_17_1) do
			if csv.yunying.yyhuodong[iter_17_1].type == var_0_3.spriteUnfreeze then
				local var_17_0 = arg_17_2[iter_17_1] or {}
				local var_17_1 = clone(var_17_0.stamps or {})

				arg_13_0.spriteUnfreezeYYData:set({
					yyId = iter_17_1,
					stamps = var_17_1
				})

				return
			end
		end

		arg_13_0.spriteUnfreezeYYData:set({})
	end)

	arg_13_0.citySpriteDatas = {}
	arg_13_0.spriteUnfreezeData = {}
end

function var_0_1.refreshBaibian(arg_18_0)
	local var_18_0 = arg_18_0.citySprites:read()
	local var_18_1 = time.getTime()
	local var_18_2 = var_18_0.baibian
	local var_18_3 = var_18_1
	local var_18_4 = var_18_2 and next(var_18_2)

	if var_18_4 and var_18_2.period then
		var_18_3 = time.getNumTimestamp(var_18_2.period or 0, time.getRefreshHour()) + gCommonConfigCsv.citySpriteBaibianPeriodDay * 24 * 3600 + 1
	end

	if (not var_18_4 or var_18_1 - var_18_2.last > gCommonConfigCsv.citySpriteBaibianCD and (var_18_3 < var_18_1 or (var_18_2.times or 0) < gCommonConfigCsv.citySpriteBaibianTimeMax)) and math.random(1, 100) <= gCommonConfigCsv.citySpriteBaibianProbability then
		gGameApp:slientRequestServer("/game/role/city/sprite/active", nil, 1)
	end

	local var_18_5 = var_18_0.miniQ
	local var_18_6 = var_18_5 and next(var_18_5)
	local var_18_7 = var_18_1

	if var_18_6 and var_18_5.period then
		var_18_7 = time.getNumTimestamp(var_18_5.period or 0, time.getRefreshHour()) + gCommonConfigCsv.citySpriteMiniQPeriodDay * 24 * 3600 + 1
	end

	if (not var_18_6 or var_18_1 - var_18_5.last > gCommonConfigCsv.citySpriteMiniQCD and (var_18_7 < var_18_1 or (var_18_5.times or 0) < gCommonConfigCsv.citySpriteMiniQTimeMax)) and math.random(1, 100) <= gCommonConfigCsv.citySpriteMiniQProbability then
		gGameApp:slientRequestServer("/game/role/city/sprite/active", nil, 2)
	end
end

function var_0_1.showRoleSpeak(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0
	local var_19_1
	local var_19_2

	if arg_19_2 == 1 then
		var_19_0 = arg_19_0.citySpriteDatas[arg_19_1].target
		var_19_1 = csv.city_sprites[arg_19_1]
	elseif arg_19_2 == 2 then
		var_19_0 = arg_19_0.roleSprite
		var_19_1 = gRoleFigureCsv[arg_19_1]
	end

	local var_19_3 = var_19_0:getChildByName("effect")

	var_19_0:removeChildByName("talkContent")
	var_19_0:removeChildByName("talkBg")

	local var_19_4 = {}
	local var_19_5 = 0

	for iter_19_0 = 1, 10 do
		local var_19_6 = var_19_1["chattext" .. iter_19_0]

		if not var_19_6 or var_19_6 == "" then
			break
		end

		table.insert(var_19_4, var_19_6)

		var_19_5 = var_19_5 + 1
	end

	local var_19_7 = var_19_3:box()

	if var_19_5 < arg_19_0.roleFigureNum then
		arg_19_0.roleFigureNum = math.random(1, var_19_5)
	end

	local var_19_8 = var_19_1.offPos
	local var_19_9 = 240
	local var_19_10 = 320
	local var_19_11 = 0
	local var_19_12 = 0.6
	local var_19_13 = rich.createWithWidth("#C0x5b545b#" .. var_19_4[arg_19_0.roleFigureNum], 40, nil, var_19_9):anchorPoint(0.5, 0):xy(var_19_7.width / 2 + var_19_8.x + var_19_11, var_19_7.height / 2 + var_19_10 / 2 + var_19_8.y + 25):addTo(var_19_0, 3, "talkContent"):scale(var_19_12):size()
	local var_19_14 = ccui.Scale9Sprite:create()

	var_19_14:initWithFile(cc.rect(75, 59, 1, 1), "city/gate/bg_dialog.png")
	var_19_14:size(var_19_13.width + 60, var_19_13.height + 60):anchorPoint(0.5, 0):xy(var_19_7.width / 2 + var_19_8.x, var_19_7.height / 2 + var_19_10 / 2 + var_19_8.y):scale(var_19_1.overture and -var_19_12 or var_19_12, var_19_12):addTo(var_19_0, 2, "talkBg")
	var_19_0:setTouchEnabled(false)
	performWithDelay(var_19_0, function()
		var_19_0:removeChildByName("talkContent")
		var_19_0:removeChildByName("talkBg")
		var_19_0:setTouchEnabled(true)
	end, 2)

	arg_19_0.roleFigureNum = math.max((arg_19_0.roleFigureNum + 1) % (var_19_5 + 1), 1)
end

function var_0_1.addCar(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0.bgPanel:get("steryShop")

	if var_21_0 then
		var_21_0:removeSelf()
	end

	arg_21_0.effects.chezi = nil
end

function var_0_1.refreshMysteryShop(arg_22_0)
	local var_22_0 = userDefault.getForeverLocalKey("mySteryState", 0)
	local var_22_1 = uiEasy.isOpenMystertShop()
	local var_22_2 = 1

	if uiEasy.showMysteryShop() or var_22_1 then
		var_22_2 = 2
	elseif not var_22_1 then
		var_22_2 = 0
	end

	userDefault.setForeverLocalKey("mySteryState", var_22_2)

	local var_22_3 = arg_22_0.leftPanel:getChildByName("steryShop")

	if var_22_1 and var_22_2 ~= 0 and not var_22_3 then
		local var_22_4 = arg_22_0.leftPanel:getChildByName("chezi")
		local var_22_5 = 11

		if var_22_4 then
			var_22_5 = var_22_4:z()

			var_22_4:removeFromParent()
		end

		var_22_3 = ccui.Layout:create():size(200, 200)

		var_22_3:setTouchEnabled(true)
		var_22_3:addTo(arg_22_0.leftPanel, var_22_5, "steryShop")
		var_22_3:xy(245, 675)
		var_22_3:anchorPoint(0, 0)

		local var_22_6 = widget.addAnimation(var_22_3, var_0_11, "day_loop", 1):scale(2):xy(100, 100):setCascadeOpacityEnabled(true):opacity(0)

		if var_0_12 ~= 1 then
			var_22_6:xy(280, 100)
		end

		transition.fadeIn(var_22_6, {
			time = 1
		})

		arg_22_0.effects.chezi = var_22_6

		arg_22_0:schedule(function()
			if not uiEasy.isOpenMystertShop() then
				userDefault.setForeverLocalKey("mySteryState", 0)
				arg_22_0:addCar(var_22_5)

				return false
			end
		end, 1, 0, var_0_4.mysteryShop)

		if var_0_0 then
			var_22_3:setBackGroundColorType(1)
			var_22_3:setBackGroundColor(cc.c3b(200, 0, 0))
			var_22_3:setBackGroundColorOpacity(100)
		end

		bind.click(arg_22_0, var_22_3, {
			method = function()
				gGameApp:requestServer("/game/mystery/get", function()
					gGameUI:stackUI("city.mystery_shop.view", nil, {
						full = true
					})
				end)
			end
		})
	elseif not var_22_1 and var_22_3 then
		arg_22_0:addCar(var_22_3:z())
	end

	if arg_22_0.isNight:read() and arg_22_0.halloweenActivity:read() and not arg_22_0.fixCar and (not arg_22_0.leftPanel:get("steryShop") or true) then
		local var_22_7 = arg_22_0.leftPanel:getChildByName("chezi")

		if var_22_7 then
			var_22_7:hide()
		end
	end

	arg_22_0.refreshBgShade:notify()
end

function var_0_1.onClickRoleSprite(arg_26_0, arg_26_1)
	local var_26_0 = gRoleFigureCsv[arg_26_1]

	if not arg_26_0.roleSprite:get("effect") then
		return
	end
end

function var_0_1.onClickMidmoon(arg_27_0, arg_27_1, arg_27_2)
	if not arg_27_2 then
		gGameUI:showTip(gLanguageCsv.noGiftsToReceiveMidmoon)

		return
	end

	local var_27_0 = {
		false
	}

	gGameApp:requestServerCustom("/game/yy/award/get"):params(arg_27_1, arg_27_2):onResponse(function(arg_28_0)
		var_27_0[1] = true
	end):wait(var_27_0):doit(function(arg_29_0)
		gGameUI:showGainDisplay(arg_29_0)
	end)
end

function var_0_1.onClickChristmastree(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_0.shengdanxiong

	if not var_30_0 or not arg_30_2 then
		gGameUI:showTip(gLanguageCsv.noGiftsToReceiveNow)

		return
	end

	local var_30_1 = {
		false
	}

	gGameApp:requestServerCustom("/game/yy/award/get"):params(arg_30_1, arg_30_2):onResponse(function(arg_31_0)
		local var_31_0 = arg_30_0:get("effectGet")

		if not var_31_0 then
			var_31_0 = widget.addAnimationByKey(arg_30_0, "christmastree/shengdanxiong.skel", "effectGet", "lingqu", 150):alignCenter(arg_30_0:getContentSize()):scale(1.7)
		else
			var_31_0:show():play("lingqu")
		end

		var_31_0:setSpriteEventHandler(function(arg_32_0, arg_32_1)
			var_30_0:play("daiji_loop")
			var_31_0:hide()

			var_30_1[1] = true
		end, sp.EventType.ANIMATION_COMPLETE)
	end):wait(var_30_1):doit(function(arg_33_0)
		gGameUI:showGainDisplay(arg_33_0)
	end)
end

function var_0_1.onClickChunjieDumpling(arg_34_0, arg_34_1, arg_34_2)
	if not arg_34_0.chunjieMan or not arg_34_2 then
		gGameUI:showTip(gLanguageCsv.noGiftsToReceiveNow)

		return
	end

	local var_34_0 = {
		false
	}

	gGameApp:requestServerCustom("/game/yy/award/get"):params(arg_34_1, arg_34_2):onResponse(function(arg_35_0)
		var_34_0[1] = true
	end):wait(var_34_0):doit(function(arg_36_0)
		gGameUI:showGainDisplay(arg_36_0)
	end)
end

function var_0_1.onAllSaintsDaySpine(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	local var_37_0 = csv.yunying.halloween_sprites[arg_37_3]
	local var_37_1 = ccui.Layout:create()
	local var_37_2 = var_0_2.get()
	local var_37_3 = var_37_0.range
	local var_37_4 = arg_37_1
	local var_37_5 = arg_37_2

	if var_37_2[arg_37_3] then
		var_37_4 = var_37_2[arg_37_3].x
		var_37_5 = var_37_2[arg_37_3].y
	end

	var_37_1:setTouchEnabled(true)
	var_37_1:anchorPoint(0.5, 0.5)
	var_37_1:xy(var_37_4, var_37_5)
	var_37_1:addTo(arg_37_0.bgPanel, 1000)

	local var_37_6

	if var_37_0.spcialAct ~= 0 and not var_37_2[arg_37_3] then
		var_37_6 = widget.addAnimationByKey(var_37_1, var_37_0.res, "effect", "standby1_loop", 1000)
	else
		var_37_6 = widget.addAnimationByKey(var_37_1, var_37_0.res, "effect", "standby_loop", 1000)
	end

	local var_37_7 = var_37_6:box()
	local var_37_8 = var_37_4 < var_37_0.normPos[1] and -1 or 1

	var_37_6:scale(var_37_0.scale * var_37_8, var_37_0.scale)
	var_37_1:size(150, 150)
	var_37_6:xy(75, 75)

	if var_0_0 then
		var_37_1:setBackGroundColorType(1)
		var_37_1:setBackGroundColor(cc.c3b(200, 0, 0))
		var_37_1:setBackGroundColorOpacity(100)
	end

	bind.click(arg_37_0, var_37_1, {
		method = functools.partial(arg_37_0.onClickhalloweenSpineChange, arg_37_0, var_37_1, arg_37_3, var_37_8)
	})

	arg_37_0.halloweenTab["yexunling" .. arg_37_3] = var_37_1
end

function var_0_1.onClickhalloweenSpineChange(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	local var_38_0 = var_0_2.get()
	local var_38_1 = csv.yunying.halloween_sprites[arg_38_2]
	local var_38_2 = false
	local var_38_3 = var_38_1.range
	local var_38_4 = var_38_1.needClick
	local var_38_5 = math.random(var_38_3[1][1], var_38_3[2][1])
	local var_38_6 = math.random(var_38_3[1][2], var_38_3[2][2])
	local var_38_7 = math.random(var_38_4[1], var_38_4[2])

	if not var_38_0[arg_38_2] and var_38_1.spcialAct ~= 0 then
		var_38_5 = var_38_1.posClick[1]
		var_38_6 = var_38_1.posClick[2]
		var_38_2 = true
	end

	local var_38_8 = var_0_2.getHalloweenMessages(var_38_0, var_38_5, var_38_6, arg_38_2, var_38_7)

	var_0_2.set(var_38_8)

	if var_0_2.get()[arg_38_2].num >= var_0_2.get()[arg_38_2].clickNum then
		local var_38_9 = arg_38_1:clone()

		var_38_9:addTo(arg_38_0.bgPanel):scale(arg_38_1:scaleX(), arg_38_1:scaleY()):xy(arg_38_1:xy())
		arg_38_1:removeSelf()

		arg_38_0.halloweenTab["yexunling" .. arg_38_2] = nil

		local var_38_10 = var_38_9:getChildByName("effect")

		if not var_38_10 then
			var_38_10 = widget.addAnimationByKey(var_38_9, var_38_1.res, "effect", "standby_loop", 1000)

			var_38_10:scale(var_38_1.scale * arg_38_3, var_38_1.scale)
			var_38_10:xy(75, 75)
		end

		var_38_10:play("effect_xiaoshi")
		var_38_10:setSpriteEventHandler(function(arg_39_0, arg_39_1)
			performWithDelay(arg_38_0, function()
				var_38_9:removeSelf()
			end, 0)
		end, sp.EventType.ANIMATION_COMPLETE)
		gGameApp:requestServer("/game/yy/award/get", function(arg_41_0)
			gGameUI:showGainDisplay(arg_41_0)
		end, arg_38_0.halloweenId, arg_38_2)
	else
		local var_38_11 = arg_38_1:getChildByName("effect")

		var_38_11:scale(var_38_1.scale * arg_38_3, var_38_1.scale)

		if var_38_1.spcialAct ~= 0 and var_38_2 then
			var_38_11:play("effect_tiaochu")
			var_38_11:addPlay("standby_loop")
		else
			var_38_11:play("effect_xiaoshi")
			var_38_11:addPlay("effect_chuxian")
			var_38_11:addPlay("standby_loop")
		end

		if var_38_1.spcialAct == 2 then
			var_38_11:xy(-400, 500)
		else
			var_38_11:xy(75, 75)
		end

		performWithDelay(arg_38_0, function()
			if arg_38_0.halloweenTab["yexunling" .. arg_38_2] and not tolua.isnull(arg_38_1) then
				arg_38_1:xy(var_38_5, var_38_6)

				if var_38_1.spcialAct ~= 2 then
					if (var_38_3[1][1] + var_38_3[2][1]) / 2 > var_38_5 then
						var_38_11:scaleX(-1 * var_38_1.scale)
					else
						var_38_11:scaleX(1 * var_38_1.scale)
					end
				end
			end
		end, 0.5)
	end
end

function var_0_1.onClickhalloweenSpineMove(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	local var_43_0 = csv.yunying.halloween_sprites[arg_43_3]
	local var_43_1 = var_43_0.range
	local var_43_2 = ccui.Layout:create()

	var_43_2:setTouchEnabled(true)

	local var_43_3 = var_0_2.get()
	local var_43_4 = arg_43_1
	local var_43_5 = arg_43_2

	if var_43_3[arg_43_3] then
		var_43_4 = var_43_3[arg_43_3].x
		var_43_5 = var_43_3[arg_43_3].y
	end

	var_43_2:xy(var_43_4, var_43_5)
	var_43_2:addTo(arg_43_0.bgPanel, 1000)

	local var_43_6 = widget.addAnimationByKey(var_43_2, var_43_0.res, "effect", "standby_loop", 1000)
	local var_43_7 = var_43_6:box()

	var_43_2:size(var_43_7.width, var_43_7.height)
	var_43_6:xy(var_43_7.width / 2, 0)
	var_43_6:scale(var_43_0.scale)

	if var_0_0 then
		var_43_2:setBackGroundColorType(1)
		var_43_2:setBackGroundColor(cc.c3b(200, 0, 0))
		var_43_2:setBackGroundColorOpacity(100)
	end

	bind.click(arg_43_0, var_43_2, {
		method = functools.partial(arg_43_0.onClickhalloweenSpineMoveChange, arg_43_0, var_43_4, var_43_5, var_43_2, arg_43_3)
	})

	arg_43_0.halloweenTab["nanguajing" .. arg_43_3] = var_43_2
end

function var_0_1.onClickhalloweenSpineMoveChange(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
	local var_44_0 = var_0_2.get()

	arg_44_3:setTouchEnabled(false)

	local var_44_1 = csv.yunying.halloween_sprites[arg_44_4]
	local var_44_2 = var_44_1.range
	local var_44_3 = var_44_1.needClick
	local var_44_4 = var_44_1.finalPos
	local var_44_5 = math.random(var_44_3[1], var_44_3[2])
	local var_44_6 = var_44_1.randDistance[1]
	local var_44_7 = var_44_1.randDistance[2]
	local var_44_8, var_44_9, var_44_10 = var_0_2.getSpritesPos(arg_44_1, arg_44_2, arg_44_4)
	local var_44_11 = var_44_8 - arg_44_1
	local var_44_12 = var_44_9 - arg_44_2
	local var_44_13 = false

	if (var_44_0[arg_44_4] and var_44_0[arg_44_4].num + 1 or 1) >= (var_44_0[arg_44_4] and var_44_0[arg_44_4].clickNum or var_44_5) then
		var_44_8, var_44_9 = var_44_4[1], var_44_4[2]
		var_44_11 = var_44_8 - arg_44_1
		var_44_12 = var_44_9 - arg_44_2

		if var_44_11 >= 0 and var_44_12 >= 0 then
			var_44_10 = 1
		elseif var_44_11 >= 0 and var_44_12 < 0 then
			var_44_10 = 2
		elseif var_44_11 < 0 and var_44_12 < 0 then
			var_44_10 = 3
		elseif var_44_11 < 0 and var_44_12 >= 0 then
			var_44_10 = 4
		end

		var_44_13 = true
	end

	local var_44_14 = arg_44_0.bgPanel:get("tmpNanguajing" .. arg_44_4)

	if var_44_14 then
		var_44_14:removeSelf()
	end

	local var_44_15 = arg_44_3:clone()

	var_44_15:addTo(arg_44_0.bgPanel):scale(arg_44_3:scale()):xy(arg_44_3:xy()):name("tmpNanguajing" .. arg_44_4)

	local var_44_16 = var_44_15:get("effect")

	if not var_44_16 then
		var_44_16 = widget.addAnimationByKey(var_44_15, var_44_1.res, "effect", "standby_loop", 1000)

		var_44_16:scale(var_44_1.scale)

		local var_44_17 = var_44_16:box()

		var_44_16:xy(var_44_17.width / 2, 0)
	end

	var_44_16:play("run_loop")
	arg_44_3:removeSelf()

	arg_44_0.halloweenTab["nanguajing" .. arg_44_4] = nil

	local function var_44_18(arg_45_0, arg_45_1)
		arg_44_0:unSchedule("nValueChange" .. arg_44_4)

		if var_44_13 then
			var_44_16:play("standby_loop")
			performWithDelay(arg_44_0.bgPanel, function()
				var_44_16:play("effect_zhuazhu")
			end, 2)
			performWithDelay(arg_44_0.bgPanel, function()
				var_44_15:removeSelf()
				gGameApp:requestServer("/game/yy/award/get", function(arg_48_0)
					gGameUI:showGainDisplay(arg_48_0)
				end, arg_44_0.halloweenId, arg_44_4)
			end, 3)
		else
			var_44_15:removeSelf()

			var_44_0 = var_0_2.getHalloweenMessages(var_44_0, arg_45_0, arg_45_1, arg_44_4, var_44_5)

			var_0_2.set(var_44_0)
			arg_44_0:onClickhalloweenSpineMove(arg_45_0, arg_45_1, arg_44_4)
		end
	end

	arg_44_0:enableSchedule():schedule(function()
		local var_49_0 = math.abs(var_44_12) / math.abs(var_44_11)
		local var_49_1 = var_44_11 / 60
		local var_49_2 = var_44_12 / 60
		local var_49_3 = var_44_11 >= 0 and 4 or -4

		if var_44_12 >= 0 then
			var_49_2 = 4 * var_49_0
		else
			var_49_2 = -4 * var_49_0
		end

		arg_44_1 = arg_44_1 + var_49_3
		arg_44_2 = arg_44_2 + var_49_2

		var_44_15:xy(arg_44_1, arg_44_2)

		if var_44_10 == 1 then
			if arg_44_1 + var_49_3 >= var_44_8 or arg_44_2 + var_49_2 >= var_44_9 then
				var_44_18(arg_44_1, arg_44_2)
			end
		elseif var_44_10 == 2 then
			if arg_44_1 + var_49_3 >= var_44_8 or arg_44_2 + var_49_2 <= var_44_9 then
				var_44_18(arg_44_1, arg_44_2)
			end
		elseif var_44_10 == 3 then
			if arg_44_1 + var_49_3 <= var_44_8 or arg_44_2 + var_49_2 <= var_44_9 then
				var_44_18(arg_44_1, arg_44_2)
			end
		elseif var_44_10 == 4 and (arg_44_1 + var_49_3 <= var_44_8 or arg_44_2 + var_49_2 >= var_44_9) then
			var_44_18(arg_44_1, arg_44_2)
		end
	end, 0.016666666666666666, 1, "nValueChange" .. arg_44_4)
end

function var_0_1.onClickHalloweenCar(arg_50_0)
	local var_50_0 = arg_50_0.yyhuodongs:read()

	if not ((var_50_0[arg_50_0.halloweenId] and var_50_0[arg_50_0.halloweenId].stamps or {})[0] == 1) then
		gGameUI:showTip(gLanguageCsv.halloweenInDay)

		return
	end

	gGameApp:requestServer("/game/yy/award/get", function(arg_51_0)
		gGameUI:showGainDisplay(arg_51_0)
	end, arg_50_0.halloweenId, 0)
end

function var_0_1.onClickHalloweenFour(arg_52_0, arg_52_1, arg_52_2)
	if not arg_52_2 then
		gGameUI:showTip(gLanguageCsv.noGiftsToReceiveNow)

		return
	end

	local var_52_0 = {
		false
	}

	gGameApp:requestServerCustom("/game/yy/award/get"):params(arg_52_1, arg_52_2):onResponse(function(arg_53_0)
		local var_53_0 = arg_52_0.shadiao

		if var_53_0 then
			var_53_0:play("effect_xiru")
			var_53_0:addPlay("effect_loop")
			var_53_0:setSpriteEventHandler(function(arg_54_0, arg_54_1)
				var_52_0[1] = true
			end, sp.EventType.ANIMATION_COMPLETE)
		else
			performWithDelay(arg_52_0, function()
				var_52_0[1] = true
			end, 2)
		end
	end):wait(var_52_0):doit(function(arg_56_0)
		gGameUI:showGainDisplay(arg_56_0)
	end)
end

function var_0_1.fixCarAndHouse(arg_57_0)
	if arg_57_0.fixCar and arg_57_0.bgPanel:getChildByName("halloweenBreakCar") then
		if arg_57_0.bgPanel:get("halloweenBreakCar") then
			arg_57_0.bgPanel:get("halloweenBreakCar"):removeSelf()
		end

		local var_57_0 = widget.addAnimationByKey(arg_57_0.bgPanel, var_0_16, "halloweenBreakCar", "effect_xiufu", 120):alignCenter(arg_57_0.bgPanel:getInnerContainerSize()):scale(var_0_17):setCascadeOpacityEnabled(true):opacity(0)

		performWithDelay(arg_57_0, function()
			if arg_57_0.bgPanel:get("halloweenBreakCar") then
				arg_57_0.bgPanel:get("halloweenBreakCar"):removeSelf()
			end
		end, 2)
	end

	if arg_57_0.fixHouse and arg_57_0.bgPanel:getChildByName("halloweenFang") then
		if arg_57_0.bgPanel:get("halloweenFang") then
			arg_57_0.bgPanel:get("halloweenFang"):removeSelf()
		end

		local var_57_1 = widget.addAnimationByKey(arg_57_0.bgPanel, var_0_15, "halloweenFang", "effect_xiufu", 9):alignCenter(arg_57_0.bgPanel:getInnerContainerSize()):scale(var_0_17)

		performWithDelay(arg_57_0, function()
			if arg_57_0.bgPanel:get("halloweenFang") then
				arg_57_0.bgPanel:get("halloweenFang"):removeSelf()
			end
		end, 2)
	end
end

function var_0_1.initSnowman(arg_60_0)
	arg_60_0.snowmanId = idler.new()

	idlereasy.any({
		arg_60_0.yyOpen
	}, function(arg_61_0, arg_61_1)
		for iter_61_0, iter_61_1 in ipairs(arg_61_1) do
			if csv.yunying.yyhuodong[iter_61_1].type == var_0_3.huoDongCloth then
				arg_60_0.snowmanId:set(iter_61_1)

				return
			end
		end

		arg_60_0.snowmanId:set()
	end)
	idlereasy.any({
		arg_60_0.yyhuodongs,
		arg_60_0.snowmanId
	}, function(arg_62_0, arg_62_1, arg_62_2)
		if not arg_62_2 then
			local var_62_0 = arg_60_0.bgPanel:get("snowman")

			if var_62_0 then
				var_62_0:removeAllChildren()
			end
		else
			local var_62_1 = arg_60_0.yyhuodongs:read()[arg_62_2] or {}
			local var_62_2 = 0

			if var_62_1.info then
				var_62_2 = var_62_1.info.level
			end

			local var_62_3 = csv.yunying.yyhuodong[arg_62_2].huodongID
			local var_62_4 = arg_60_0.bgPanel:get("snowman")
			local var_62_5 = cc.size(500, 540)
			local var_62_6 = cc.p(250, 170)

			if not var_62_4 then
				var_62_4 = ccui.Layout:create():xy(cc.p(1330, 380)):size(var_62_5):addTo(arg_60_0.bgPanel, 9, "snowman")

				var_62_4:setTouchEnabled(true)
			else
				var_62_4:removeAllChildren()
			end

			ccui.ImageView:create("activity/snowman/img_cs_snowman.png"):xy(var_62_6):addTo(var_62_4, 30, "snow"):scale(1.6)

			if var_62_2 == 0 then
				local var_62_7 = ccui.Scale9Sprite:create()

				var_62_7:initWithFile(cc.rect(56, 43, 1, 1), "activity/snowman/box_sd_dialog.png")
				var_62_7:size(190, 87):anchorPoint(0.3, 0):xy(330, 340):addTo(var_62_4, 100, "snowTip")
				cc.Label:createWithTTF(str, "font/youmi.ttf", 28):color(cc.c4b(255, 255, 255, 255)):xy(90, 48):addTo(var_62_4:get("snowTip"), 2, "tipText")
				var_62_4:get("snowTip"):getChildByName("tipText"):text(gLanguageCsv.snowClothEntranceTip)
			end

			var_62_4:get("snow"):setTouchEnabled(false)

			if var_0_0 then
				var_62_4:setBackGroundColorType(1)
				var_62_4:setBackGroundColor(cc.c3b(200, 0, 0))
				var_62_4:setBackGroundColorOpacity(100)
			end

			bind.click(arg_60_0, var_62_4, {
				method = functools.partial(arg_60_0.onClickSnowman, arg_60_0)
			})

			local var_62_8 = var_62_1.targets

			if var_62_8 then
				for iter_62_0 = 1, itertools.size(var_62_8) do
					local var_62_9 = csv.yunying.huodongcloth_part[var_62_8[tostring(iter_62_0)]]
					local var_62_10 = arg_60_0.bgPanel:get("snowman"):get("decoration" .. var_62_8[tostring(iter_62_0)])
					local var_62_11 = var_62_9.lookPos.x
					local var_62_12 = var_62_9.lookPos.y

					if not pane1l then
						local var_62_13 = ccui.Layout:create():xy(var_62_6):size(var_62_5):addTo(arg_60_0.bgPanel:get("snowman"), var_62_9.zOrder, "decoration" .. var_62_8[tostring(iter_62_0)])

						if var_62_9.showType == "pic" then
							ccui.ImageView:create(var_62_9.res):xy(var_62_11, var_62_12):addTo(var_62_13, 1, "decoration"):scale(0.75)
						else
							widget.addAnimationByKey(var_62_13, var_62_9.res, "decoration", "night_loop", 120):scale(0.75):xy(var_62_11, var_62_12)
						end
					end
				end
			end

			for iter_62_1, iter_62_2 in orderCsvPairs(csv.yunying.huodongcloth_level) do
				for iter_62_3, iter_62_4 in orderCsvPairs(csv.yunying.huodongcloth_part) do
					if var_62_2 >= iter_62_2.level and iter_62_4.huodongID == var_62_3 and iter_62_4.belongPart == iter_62_2.unlockPart and iter_62_2.unlockPart > 100 then
						local var_62_14 = arg_60_0.bgPanel:get("snowman"):get("decoration" .. iter_62_3)
						local var_62_15 = iter_62_4.lookPos.x
						local var_62_16 = iter_62_4.lookPos.y

						if not pane1l then
							local var_62_17 = ccui.Layout:create():xy(var_62_6):size(var_62_5):addTo(arg_60_0.bgPanel:get("snowman"), iter_62_4.zOrder, "decoration" .. iter_62_3)

							if iter_62_4.showType == "pic" then
								ccui.ImageView:create(iter_62_4.res):xy(var_62_15, var_62_16):addTo(var_62_17, 1, "decoration"):scale(1.6)
							else
								widget.addAnimationByKey(var_62_17, iter_62_4.res, "decoration", "night_loop", 120):scale(1.6):xy(var_62_15, var_62_16)
							end
						end
					end
				end
			end
		end
	end)
end

function var_0_1.onClickSnowman(arg_63_0)
	local var_63_0 = arg_63_0.snowmanId:read()

	if var_63_0 then
		gGameApp:requestServer("/game/yy/cloth/main", function(arg_64_0)
			gGameUI:stackUI("city.activity.snowman", nil, nil, var_63_0)
		end, var_63_0)
	end
end

function var_0_1.onFreezeSprite(arg_65_0, arg_65_1)
	local var_65_0 = arg_65_1.id
	local var_65_1 = arg_65_1.res
	local var_65_2 = arg_65_0.citySpriteDatas[var_65_0].target
	local var_65_3 = var_65_2:size()

	local function var_65_4(arg_66_0, arg_66_1, arg_66_2)
		local var_66_0 = arg_66_2.state
		local var_66_1 = arg_66_2.clickCount

		arg_66_0:stopActionByTag(var_0_6)

		if var_66_0 > 1 then
			performWithDelay(arg_66_0, function()
				arg_66_0:stopActionByTag(var_0_6)

				var_66_0 = 1
				var_66_1 = 0
				arg_66_2.state = var_66_0
				arg_66_2.clickCount = var_66_1

				arg_66_1:play("effect_loop")

				local var_67_0 = widget.addAnimationByKey(arg_66_0, var_65_1, "freezeRecoverBg", "BK_huifu_hou", 0):scale(2):xy(var_65_3.width / 2, 0)
				local var_67_1 = widget.addAnimationByKey(arg_66_0, var_65_1, "freezeRecoverFg", "BK_huifu_qian", 2):scale(2):xy(var_65_3.width / 2, 0)

				var_67_1:setSpriteEventHandler()
				var_67_1:setSpriteEventHandler(function()
					var_67_1:setSpriteEventHandler()
					performWithDelay(arg_66_0, function()
						var_67_0:removeFromParent()
						var_67_1:removeFromParent()
						arg_66_1:play("JS_bingdong" .. var_66_0 .. "_loop")
					end, 0)
				end, sp.EventType.ANIMATION_COMPLETE)
			end, var_0_5):setTag(var_0_6)
		end
	end

	local var_65_5 = arg_65_0.spriteUnfreezeData[var_65_0]
	local var_65_6 = var_65_5.state

	if var_0_7[var_65_6] then
		local var_65_7 = var_65_2:get("effect")

		var_65_7:play("JS_bingdong" .. var_65_6 .. "_loop")
		var_65_4(var_65_2, var_65_7, var_65_5)
	end

	bind.click(arg_65_0, var_65_2, {
		method = function()
			if not arg_65_0.citySpriteDatas[var_65_0] then
				return
			end

			local var_70_0 = arg_65_0.citySpriteDatas[var_65_0].target
			local var_70_1 = var_70_0:get("effect")
			local var_70_2 = var_70_0:size()
			local var_70_3 = arg_65_0.spriteUnfreezeData[var_65_0]
			local var_70_4 = var_70_3.state
			local var_70_5 = var_70_3.clickCount

			if var_0_7[var_70_4] then
				local var_70_6 = var_70_0:get("freezeEffect") or widget.addAnimation(var_70_0, "zhuchangjing/bingbao.skel", "bingbao", 10):alignCenter(var_70_2)
				local var_70_7 = var_70_0:get("freezeRecoverFg")

				if var_70_7 then
					var_70_7:stopAllActions()
					var_70_7:removeFromParent()
					var_70_0:get("freezeRecoverBg"):removeFromParent()
					var_70_1:play("JS_bingdong" .. var_70_4 .. "_loop")
				end

				var_70_6:play("bingbao")

				local var_70_8 = var_70_5 + 1

				var_70_3.clickCount = var_70_8

				if var_70_8 >= var_0_7[var_70_4] then
					local var_70_9 = var_70_4 + 1

					var_70_3.state = var_70_9

					if not var_0_7[var_70_9] then
						var_70_9 = 0
						var_70_3.state = var_70_9

						var_70_1:play("effect_loop")

						local var_70_10 = arg_65_0.spriteUnfreezeYYData:read().yyId

						arg_65_0:onUnfreezeAward(var_70_10, var_65_0)
					else
						var_70_1:play("JS_bingdong" .. var_70_9 .. "_loop")
					end
				end

				var_65_4(var_70_0, var_70_1, var_70_3)
			end
		end
	})
end

function var_0_1.onUnfreezeAward(arg_71_0, arg_71_1, arg_71_2)
	if not arg_71_1 or not arg_71_2 then
		return
	end

	gGameApp:requestServer("/game/yy/award/get", function(arg_72_0)
		gGameUI:showGainDisplay(arg_72_0)
	end, arg_71_1, arg_71_2)
end

function var_0_1.dailyAssistantTip(arg_73_0)
	if not dataEasy.isShow("dailyAssistant") then
		return
	end

	local var_73_0 = arg_73_0.bgPanel:getChildByName("dailyAssistantPanel")
	local var_73_1 = arg_73_0.leftPanel:x()
	local var_73_2 = arg_73_0.leftPanel:size().width

	if var_73_0 == nil then
		var_73_0 = ccui.Layout:create()

		var_73_0:setTouchEnabled(true)
		var_73_0:addTo(arg_73_0.bgPanel, 20, "dailyAssistantPanel")
		var_73_0:xy((var_73_1 + var_73_2) * 2 / 3, 220)
		var_73_0:anchorPoint(0.5, 0)
		adapt.centerWithScreen({
			"left",
			nil,
			false
		}, {
			"right",
			nil,
			false
		}, nil, {
			{
				var_73_0,
				"width"
			},
			{
				var_73_0,
				"pos",
				"left"
			}
		})

		local var_73_3 = 1
		local var_73_4 = widget.addAnimationByKey(var_73_0, "narutomaincity/maincityzs.skel", "luotuomutujian", "effect_loop", 1)

		var_73_4:anchorPoint(cc.p(0.5, 0.5))
		var_73_4:scale(var_73_3)

		local var_73_5 = var_73_4:box()

		var_73_5.width = var_73_5.width * var_73_3
		var_73_5.height = var_73_5.height * var_73_3

		var_73_4:xy(var_73_5.width / 2, 0)
		var_73_0:size(var_73_5.width, var_73_5.height)

		if var_0_0 then
			var_73_0:setBackGroundColorType(1)
			var_73_0:setBackGroundColor(cc.c3b(200, 0, 0))
			var_73_0:setBackGroundColorOpacity(100)
		end

		bind.click(arg_73_0, var_73_0, {
			method = function()
				jumpEasy.jumpTo("dailyAssistant")
			end
		})

		local var_73_6 = {
			class = "red_hint",
			props = {
				specialTag = "dailyAssistant",
				onNode = function(arg_75_0)
					arg_75_0:xy(var_73_5.width, var_73_5.height - 40)
					arg_75_0:scale(0.5)
				end
			}
		}

		bind.extend(arg_73_0, var_73_0, var_73_6)

		local var_73_7 = {}

		for iter_73_0 = 1, math.huge do
			local var_73_8 = gLanguageCsv["dailyAssistantShowTips" .. iter_73_0]

			if var_73_8 == nil then
				break
			end

			table.insert(var_73_7, var_73_8)
		end

		local var_73_9 = {
			x = 100,
			y = 30
		}
		local var_73_10 = 0.6

		local function var_73_11()
			local var_76_0 = var_73_0:getChildByName("_redHint_")

			if not var_76_0 or not var_76_0:visible() then
				return
			end

			local var_76_1 = math.random(1, #var_73_7)
			local var_76_2 = rich.createByStr("#C0x5b545b#" .. var_73_7[var_76_1], 40):anchorPoint(0.5, 0):xy(var_73_5.width / 2 + var_73_9.x, var_73_5.height + 15 + var_73_9.y):addTo(var_73_0, 3, "talkContent"):formatText():scale(var_73_10):size()
			local var_76_3 = ccui.Scale9Sprite:create()

			var_76_3:initWithFile(cc.rect(75, 59, 1, 1), "city/gate/bg_dialog.png")
			var_76_3:size(var_76_2.width + 40, var_76_2.height + 40):anchorPoint(0.5, 0):xy(var_73_5.width / 2 + var_73_9.x, var_73_5.height + var_73_9.y):scale(-1 * var_73_10, var_73_10):addTo(var_73_0, 2, "talkBg")
			performWithDelay(var_73_0, function()
				var_73_0:removeChildByName("talkContent")
				var_73_0:removeChildByName("talkBg")
			end, 2)
		end

		local var_73_12 = cc.Sequence:create(cc.DelayTime:create(8), cc.CallFunc:create(function()
			var_73_11()
		end))
		local var_73_13 = cc.RepeatForever:create(var_73_12)

		var_73_0:runAction(var_73_13)
	end

	var_73_0:visible(dataEasy.isShow("dailyAssistant"))

	arg_73_0.dailyAssistantPanel = var_73_0

	adapt.dockWithScreen(arg_73_0.dailyAssistantPanel, "right")
end

function var_0_1.fishingGameTip(arg_79_0)
	return
end

function var_0_1.fishingClick(arg_80_0)
	if arg_80_0.crossFishingRound:read() == "closed" then
		gGameUI:showTip(gLanguageCsv.fishGameNotStart)
		arg_80_0.fishPanel:hide()

		return
	end

	local function var_80_0()
		gGameApp:requestServer("/game/cross/fishing/rank", function(arg_82_0)
			gGameUI:stackUI("city.adventure.fishing.view", nil, {
				full = true
			}, game.FISHING_GAME, arg_82_0.view, arg_80_0:createHandler("onOpenFishingMain"))
		end)
	end

	if arg_80_0.fishingSelectScene:read() == game.FISHING_GAME then
		var_80_0()
	elseif arg_80_0.fishingIsAuto:read() then
		gGameUI:stackUI("city.adventure.fishing.auto", nil, {
			clickClose = false,
			blackLayer = true
		}, game.FISHING_GAME, arg_80_0:createHandler("onOpenView"))
	else
		gGameApp:requestServer("/game/fishing/prepare", var_80_0, "scene", game.FISHING_GAME)
	end
end

function var_0_1.onOpenView(arg_83_0)
	if arg_83_0.crossFishingRound:read() == "closed" then
		gGameUI:showTip(gLanguageCsv.fishGameNotStart)
		arg_83_0.fishPanel:hide()

		return
	end

	gGameApp:requestServer("/game/fishing/prepare", function(arg_84_0)
		gGameApp:requestServer("/game/cross/fishing/rank", function(arg_85_0)
			gGameUI:stackUI("city.adventure.fishing.view", nil, {
				full = true
			}, game.FISHING_GAME, arg_85_0.view, arg_83_0:createHandler("onOpenFishingMain"))
		end)
	end, "scene", game.FISHING_GAME)
end

function var_0_1.onOpenFishingMain(arg_86_0)
	gGameUI:stackUI("city.adventure.fishing.sence_select", nil, {
		full = true
	})
end

function var_0_1.onClickSprite(arg_87_0, arg_87_1)
	local var_87_0 = arg_87_0.citySpriteDatas[arg_87_1.csvId]
	local var_87_1 = {
		false
	}

	local function var_87_2()
		var_87_1[1] = true
	end

	if not var_87_0.isBaibian and not var_87_0.isMiniQ then
		if arg_87_0.spriteGiftTimes:read() < 3 and not var_87_0.isGetGift then
			function var_87_2(arg_89_0)
				var_87_0.target:setTouchEnabled(true)

				if arg_87_1.cfg.action then
					local var_89_0 = var_87_0.target:getChildByName("effect")

					if var_89_0 then
						var_89_0:play("effect")
						var_89_0:setSpriteEventHandler(function(arg_90_0, arg_90_1)
							var_89_0:play("effect_loop")
						end, sp.EventType.ANIMATION_COMPLETE)
					end
				end

				var_87_1[1] = true
				arg_87_0.citySpriteDatas[arg_87_1.csvId].isGetGift = true
			end
		elseif arg_87_1.cfg.action then
			local var_87_3 = var_87_0.target:getChildByName("effect")

			if var_87_3 then
				var_87_3:play("effect")
				var_87_3:setSpriteEventHandler(function(arg_91_0, arg_91_1)
					var_87_3:play("effect_loop")
				end, sp.EventType.ANIMATION_COMPLETE)
			end

			return
		end
	elseif var_87_0.isBaibian and not var_87_0.isGet then
		function var_87_2(arg_92_0)
			local var_92_0 = var_87_0.target:getChildByName("effect")

			if var_92_0 then
				var_92_0:hide()

				local var_92_1 = ({
					"effect_jingya",
					"effect_shengqi",
					"effect_kaixin"
				})[math.random(1, 3)]

				widget.addAnimationByKey(var_87_0.target, "zhuchangjing/zjm_bbg.skel", "changeEft", var_92_1, 1):xy(var_92_0:xy()):setSpriteEventHandler(function(arg_93_0, arg_93_1)
					var_87_0.target:setTouchEnabled(true)

					arg_87_0.citySpriteDatas[arg_87_1.csvId].isGet = true
					var_87_1[1] = true
				end, sp.EventType.ANIMATION_COMPLETE)
			end
		end
	elseif var_87_0.isMiniQ then
		function var_87_2(arg_94_0)
			local var_94_0 = var_87_0.target:getChildByName("effect")

			if var_94_0 then
				var_94_0:play("effect")
				var_94_0:setSpriteEventHandler(function(arg_95_0, arg_95_1)
					performWithDelay(arg_87_0, function()
						var_87_0.target:removeFromParent()

						arg_87_0.citySpriteDatas[arg_87_1.csvId] = nil
						var_87_1[1] = true
					end, 0.016666666666666666)
				end, sp.EventType.ANIMATION_COMPLETE)
			end
		end
	end

	var_87_0.target:setTouchEnabled(false)
	gGameApp:requestServerCustom("/game/role/city/sprite/gift"):params(arg_87_1.csvId):onResponse(function()
		if tolua.isnull(var_87_0.target) then
			var_87_1[1] = true
		else
			var_87_2()
		end
	end):wait(var_87_1):doit(function(arg_98_0)
		gGameUI:showGainDisplay(arg_98_0)
	end)
end

function var_0_1.initHalloween(arg_99_0)
	arg_99_0.halloweenActivity = idler.new(false)
	arg_99_0.halloweenDailyAward = idler.new(false)
	arg_99_0.halloweenAllSpriteClicked = idler.new()

	arg_99_0:onHalloween()
end

function var_0_1.setHalloweenMoveSprites(arg_100_0)
	arg_100_0.fixHouse = true
	arg_100_0.fixCar = true

	arg_100_0.halloweenAllSpriteClicked:set(true)

	local var_100_0 = arg_100_0.yyhuodongs:read()
	local var_100_1 = var_100_0[arg_100_0.halloweenId] and var_100_0[arg_100_0.halloweenId].stamps or {}
	local var_100_2 = 0

	for iter_100_0, iter_100_1 in pairs(var_100_1) do
		if iter_100_0 ~= 0 then
			local var_100_3 = csv.yunying.halloween_sprites[iter_100_0]

			if var_100_3.type == 1 then
				if var_100_3.buildNum == 1 and iter_100_1 ~= 0 then
					arg_100_0.fixHouse = false

					arg_100_0.halloweenAllSpriteClicked:set(false)
				end

				if var_100_3.buildNum == 2 and iter_100_1 ~= 0 then
					arg_100_0.fixCar = false

					arg_100_0.halloweenAllSpriteClicked:set(false)
				end
			elseif iter_100_1 == 0 then
				var_100_2 = var_100_2 + 1
			else
				arg_100_0.halloweenAllSpriteClicked:set(false)
			end
		end
	end

	for iter_100_2, iter_100_3 in pairs(var_100_1) do
		if iter_100_2 ~= 0 and iter_100_3 == 1 then
			local var_100_4 = csv.yunying.halloween_sprites[iter_100_2]
			local var_100_5 = math.random(csvSize(var_100_4.pos))
			local var_100_6 = var_100_4.pos[var_100_5][1]
			local var_100_7 = var_100_4.pos[var_100_5][2]

			if var_100_4.type == 1 then
				arg_100_0:onAllSaintsDaySpine(var_100_6, var_100_7, iter_100_2)
			elseif var_100_4.type == 2 and arg_100_0.fixHouse and arg_100_0.fixCar then
				arg_100_0:onClickhalloweenSpineMove(var_100_6, var_100_7, iter_100_2)
			end
		end
	end

	local var_100_8 = arg_100_0.bgPanel:get("halloweenCar"):get("halloweenCar")

	if var_100_2 == 1 then
		var_100_8:play("night_deng1_bianhua")
		var_100_8:addPlay("night_po_hou1_loop")
	end

	if var_100_2 == 2 then
		if var_100_1[0] == 1 then
			var_100_8:play("night_deng2_bianhua")
			var_100_8:addPlay("night_hao_loop")
		else
			var_100_8:play("night_loop")
		end
	end
end

function var_0_1.onHalloween(arg_101_0)
	arg_101_0.halloweenTab = {}

	idlereasy.any({
		arg_101_0.yyOpen
	}, function(arg_102_0, arg_102_1)
		arg_101_0.halloweenActivity:set(false)

		for iter_102_0, iter_102_1 in ipairs(arg_102_1) do
			local var_102_0 = csv.yunying.yyhuodong[iter_102_1]

			if var_102_0.clientParam.type == "halloween" and var_102_0.type == var_0_3.halloween then
				arg_101_0.halloweenId = iter_102_1

				arg_101_0.halloweenActivity:set(true)

				break
			end
		end
	end)
	idlereasy.any({
		arg_101_0.isNight,
		arg_101_0.halloweenActivity,
		arg_101_0.yyhuodongs
	}, function(arg_103_0, arg_103_1, arg_103_2, arg_103_3)
		for iter_103_0, iter_103_1 in pairs(arg_101_0.halloweenTab) do
			iter_103_1:removeSelf()
		end

		arg_101_0.halloweenTab = {}

		if arg_101_0.bgPanel:get("halloweenFang") then
			arg_101_0.bgPanel:get("halloweenFang"):removeSelf()
		end

		if arg_101_0.bgPanel:get("halloweenShan") then
			arg_101_0.bgPanel:get("halloweenShan"):removeSelf()
		end

		if arg_101_0.bgPanel:get("halloweenBreakCar") then
			arg_101_0.bgPanel:get("halloweenBreakCar"):removeSelf()
		end

		if arg_101_0.bgPanel:get("halloweenCar") then
			arg_101_0.bgPanel:get("halloweenCar"):removeSelf()
		end

		local var_103_0 = arg_101_0.bgPanel:get("steryShop")

		if var_103_0 then
			var_103_0:show()
		end

		if arg_101_0.bgPanel:get("chezi") then
			-- block empty
		end

		if arg_103_2 then
			arg_101_0:addHalloweenCar()

			if arg_103_1 then
				arg_101_0:setHalloweenMoveSprites()
				widget.addAnimationByKey(arg_101_0.bgPanel, var_0_14, "halloweenShan", "effect_loop", 100):alignCenter(arg_101_0.bgPanel:getInnerContainerSize()):scale(var_0_17)

				if not arg_101_0.fixHouse then
					widget.addAnimationByKey(arg_101_0.bgPanel, var_0_15, "halloweenFang", "effect_loop", 9):alignCenter(arg_101_0.bgPanel:getInnerContainerSize()):scale(var_0_17)
				end

				if not arg_101_0.fixCar and (not arg_101_0.bgPanel:get("steryShop") or true) then
					local var_103_1 = arg_101_0.bgPanel:get("chezi")

					if var_103_1 then
						var_103_1:hide()
					end

					arg_101_0:addBreakCar()
				end

				arg_101_0:fixCarAndHouse()
			end
		end
	end)
end

function var_0_1.addBreakCar(arg_104_0)
	return
end

function var_0_1.addHalloweenCar(arg_105_0)
	local var_105_0 = arg_105_0.bgPanel:get("halloweenCar")

	if not var_105_0 then
		var_105_0 = ccui.Layout:create():xy(var_0_13):size(850, 800):addTo(arg_105_0.bgPanel, 200, "halloweenCar")

		var_105_0:setTouchEnabled(true)

		local var_105_1 = arg_105_0.isNight:read() and "night_po_loop" or "day_loop"

		widget.addAnimationByKey(var_105_0, "wanshengjie/wsj_nanguache.skel", "halloweenCar", var_105_1, 120):scale(2):xy(500, 200)

		if var_0_0 then
			var_105_0:setBackGroundColorType(1)
			var_105_0:setBackGroundColor(cc.c3b(200, 0, 0))
			var_105_0:setBackGroundColorOpacity(100)
		end

		bind.click(arg_105_0, var_105_0, {
			method = functools.partial(arg_105_0.onClickHalloweenCar, arg_105_0)
		})
	else
		var_105_0:xy(var_0_13)
	end
end

return function(arg_106_0)
	for iter_106_0, iter_106_1 in pairs(var_0_1) do
		arg_106_0[iter_106_0] = iter_106_1
	end
end
