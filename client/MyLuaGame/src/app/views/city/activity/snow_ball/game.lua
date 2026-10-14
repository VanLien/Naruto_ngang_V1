local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("SnowBallGame", var_0_0)
local var_0_2 = {
	{
		nodeName = "rockerBg",
		content = gLanguageCsv.snowBallGuide1
	},
	{
		nodeName = "timeGuidePanel",
		content = gLanguageCsv.snowBallGuide2
	},
	{
		nodeName = "cannonPanel1",
		content = gLanguageCsv.snowBallGuide3
	},
	{
		nodeName = "cannonPanel2",
		content = gLanguageCsv.snowBallGuide4
	}
}

var_0_1.RESOURCE_FILENAME = "snow_ball_game.json"
var_0_1.RESOURCE_BINDING = {
	["bg.cannonPanel2"] = "cannonPanel2",
	panelCountDown = "panelCountDown",
	["imgInfo.imgSm"] = "imgSm",
	bg = "bg",
	["imgTimeBg.guidePanel"] = "timeGuidePanel",
	imgTimeBg = "imgTimeBg",
	["imgTimeBg.textTime"] = "textCountDown",
	["bg.cannonPanel1"] = "cannonPanel1",
	rockerPanel = {
		varname = "rockerPanel",
		binds = {
			event = "touch",
			soundClose = true,
			scaletype = 0,
			methods = {
				began = bindHelper.self("createRocker"),
				ended = bindHelper.self("removeRocker"),
				cancelled = bindHelper.self("removeRocker"),
				moved = bindHelper.self("moveRocker")
			}
		}
	},
	["imgInfo.textScore"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("point")
		}
	}
}

local var_0_3 = cc.p(100, 100)
local var_0_4 = cc.p(1500, 100)

local function var_0_5(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0[1]
	local var_1_1 = arg_1_0[2]
	local var_1_2 = arg_1_1[1]
	local var_1_3 = arg_1_1[2]
	local var_1_4 = (var_1_1.y - var_1_0.y) * (var_1_3.x - var_1_2.x) - (var_1_0.x - var_1_1.x) * (var_1_2.y - var_1_3.y)

	if var_1_4 == 0 then
		return nil
	end

	local var_1_5 = ((var_1_1.x - var_1_0.x) * (var_1_3.x - var_1_2.x) * (var_1_2.y - var_1_0.y) + (var_1_1.y - var_1_0.y) * (var_1_3.x - var_1_2.x) * var_1_0.x - (var_1_3.y - var_1_2.y) * (var_1_1.x - var_1_0.x) * var_1_2.x) / var_1_4
	local var_1_6 = -((var_1_1.y - var_1_0.y) * (var_1_3.y - var_1_2.y) * (var_1_2.x - var_1_0.x) + (var_1_1.x - var_1_0.x) * (var_1_3.y - var_1_2.y) * var_1_0.y - (var_1_3.x - var_1_2.x) * (var_1_1.y - var_1_0.y) * var_1_2.y) / var_1_4

	if (var_1_5 - var_1_0.x) * (var_1_5 - var_1_1.x) <= 0 and (var_1_6 - var_1_0.y) * (var_1_6 - var_1_1.y) <= 0 and (var_1_5 - var_1_2.x) * (var_1_5 - var_1_3.x) <= 0 and (var_1_6 - var_1_2.y) * (var_1_6 - var_1_3.y) <= 0 then
		return cc.p(var_1_5, var_1_6)
	end

	return nil
end

local function var_0_6()
	local var_2_0, var_2_1 = pcall(function()
		return require("socket")
	end)

	if var_2_0 then
		return var_2_1.gettime() * 1000
	else
		return os.time() * 1000
	end
end

function var_0_1.onCreate(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.tGift = {}
	arg_4_0.tSnowBall = {}

	arg_4_0:enableSchedule()
	arg_4_0.panelCountDown:globalZ(1)

	arg_4_0.activityId = arg_4_1
	arg_4_0.csvId = arg_4_2
	arg_4_0.attr = csv.yunying.snowball_element[arg_4_2].attr
	arg_4_0.playTime = 0

	arg_4_0:initLife()
	arg_4_0:initModel()
	arg_4_0:initMoveRect()
	arg_4_0:startCount()
	arg_4_0:createCannon()
end

function var_0_1.initModel(arg_5_0)
	arg_5_0.point = idler.new(0)
	arg_5_0.myLife = idler.new(arg_5_0.attr.life)

	local var_5_0 = gGameModel.role:read("yyhuodongs")[arg_5_0.activityId] or {}

	arg_5_0.topPoint = var_5_0.info.top_point or 0
	arg_5_0.isGuide = var_5_0.info.isGuide

	idlereasy.when(arg_5_0.myLife, function(arg_6_0, arg_6_1)
		for iter_6_0 = 1, arg_5_0.attr.life do
			if arg_6_1 < iter_6_0 then
				arg_5_0.tImgSm[iter_6_0]:get("img"):hide()
			else
				arg_5_0.tImgSm[iter_6_0]:get("img"):show()
			end
		end

		if arg_6_1 == 0 and arg_5_0.gaming == true then
			arg_5_0:gameOver()

			local var_6_0 = arg_5_0.point:read()

			gGameApp:requestServer("/game/yy/snowball/end", function(arg_7_0)
				arg_5_0:showGmameEnd(var_6_0)
			end, arg_5_0.activityId, var_6_0, arg_5_0.playTime, arg_5_0.isGuide == 0 and 1 or 0, arg_5_0.csvId)
		end
	end)
end

function var_0_1.initLife(arg_8_0)
	local var_8_0 = arg_8_0.imgSm

	arg_8_0.tImgSm = {
		arg_8_0.imgSm
	}

	for iter_8_0 = 2, arg_8_0.attr.life do
		local var_8_1 = var_8_0:clone():addTo(var_8_0:getParent()):xy(var_8_0:x() + 49 * (iter_8_0 - 1), var_8_0:y())

		table.insert(arg_8_0.tImgSm, var_8_1)
	end
end

function var_0_1.createSprite(arg_9_0)
	local var_9_0 = (arg_9_0.posTable[1].x + arg_9_0.posTable[3].x) / 2
	local var_9_1 = (arg_9_0.posTable[1].y + arg_9_0.posTable[3].y) / 2
	local var_9_2 = math.sqrt(arg_9_0.attr.weight)

	arg_9_0.spriteShadow = cc.Sprite:create("activity/snow_ball/img_xqdbs_ty.png"):addTo(arg_9_0.bg):xy(var_9_0, var_9_1):z(10000 - var_9_1):scale(var_9_2)

	local var_9_3 = arg_9_0.attr.cardName or arg_9_0.attr.careName

	arg_9_0.sprite = widget.addAnimation(arg_9_0.spriteShadow, string.format("snow_ball/%s.skel", var_9_3), "shengdan_standby_loop", 5):xy(arg_9_0.spriteShadow:width() / 2, arg_9_0.spriteShadow:height() / 2):scaleX(-1):scaleY(1):name("imgSel")
end

function var_0_1.initMoveRect(arg_10_0)
	arg_10_0.posTable = {}

	for iter_10_0 = 1, 4 do
		arg_10_0.posTable[iter_10_0] = cc.p(arg_10_0.bg:get("pos" .. iter_10_0):xy())
	end

	for iter_10_1 = 1, 4 do
		local var_10_0 = iter_10_1 == 4 and 1 or iter_10_1 + 1
		local var_10_1 = arg_10_0.posTable[var_10_0].x - arg_10_0.posTable[iter_10_1].x
		local var_10_2 = arg_10_0.posTable[var_10_0].y - arg_10_0.posTable[iter_10_1].y
		local var_10_3 = math.sqrt(math.pow(var_10_1, 2) + math.pow(var_10_2, 2))
	end
end

function var_0_1.initCountDown(arg_11_0)
	local var_11_0 = time.getTime()
	local var_11_1 = csv.yunying.yyhuodong[arg_11_0.activityId]
	local var_11_2 = var_11_1.paramMap.playTimeMax
	local var_11_3 = var_11_1.paramMap.timeDelta
	local var_11_4 = 0

	bind.extend(arg_11_0, arg_11_0.textCountDown, {
		class = "cutdown_label",
		props = {
			str_key = "short_clock_str",
			time = var_11_2,
			endFunc = function()
				if arg_11_0.gaming then
					arg_11_0:gameOver()

					local var_12_0 = arg_11_0.point:read()

					gGameApp:requestServer("/game/yy/snowball/end", function(arg_13_0)
						arg_11_0:showGmameEnd(var_12_0)
					end, arg_11_0.activityId, var_12_0, var_11_2, arg_11_0.isGuide == 0 and 1 or 0, arg_11_0.csvId)
				end
			end,
			callFunc = function()
				arg_11_0.playTime = time.getTime() - var_11_0
				var_11_4 = var_11_4 + 1

				if math.abs(arg_11_0.playTime - var_11_4) > var_11_3 then
					gGameUI:showTip(gLanguageCsv.cheat_error)
					performWithDelay(arg_11_0, function()
						arg_11_0:gameOver()
						arg_11_0:onClose()
					end, 3)

					return false
				end
			end
		}
	})
end

function var_0_1.initGuideCountDown(arg_16_0)
	local var_16_0 = time.getTime()
	local var_16_1 = csv.yunying.yyhuodong[arg_16_0.activityId]
	local var_16_2 = 30

	bind.extend(arg_16_0, arg_16_0.textCountDown, {
		class = "cutdown_label",
		props = {
			str_key = "short_clock_str",
			time = var_16_2,
			endFunc = function()
				if arg_16_0.gaming then
					arg_16_0:gameOver()

					local var_17_0 = arg_16_0.point:read()

					gGameApp:requestServer("/game/yy/snowball/end", function(arg_18_0)
						arg_16_0:showGmameEnd(var_17_0)
					end, arg_16_0.activityId, var_17_0, var_16_2, arg_16_0.isGuide == 0 and 1 or 0, arg_16_0.csvId)
				end
			end,
			callFunc = function()
				arg_16_0.playTime = time.getTime() - var_16_0
			end
		}
	})
end

function var_0_1.startCount(arg_20_0)
	local var_20_0 = csv.yunying.yyhuodong[arg_20_0.activityId].paramMap.playTimeMax

	if arg_20_0.isGuide == 0 then
		var_20_0 = 30
	end

	arg_20_0.textCountDown:text(time.getCutDown(var_20_0).short_clock_str)
	arg_20_0.panelCountDown:show()
	arg_20_0.rockerPanel:hide()

	local var_20_1 = 3
	local var_20_2 = arg_20_0.panelCountDown:get("textNum")

	var_20_2:text(var_20_1)
	adapt.oneLineCenterPos(cc.p(arg_20_0.panelCountDown:width() / 2, arg_20_0.panelCountDown:height() / 2), {
		arg_20_0.panelCountDown:get("textNote"),
		arg_20_0.panelCountDown:get("textNum")
	})
	arg_20_0:schedule(function(arg_21_0)
		if var_20_1 > 0 then
			local var_21_0 = var_20_2

			var_20_2:text(var_20_1)
			var_20_2:scale(1.3)
			var_20_2:runAction(cc.ScaleTo:create(0.5, 1))
			adapt.oneLineCenterPos(cc.p(arg_20_0.panelCountDown:width() / 2, arg_20_0.panelCountDown:height() / 2), {
				arg_20_0.panelCountDown:get("textNote"),
				arg_20_0.panelCountDown:get("textNum")
			})

			var_20_1 = var_20_1 - 1
		else
			arg_20_0:gameStart()

			return false
		end
	end, 1, 0, 663)
end

function var_0_1.gameStart(arg_22_0)
	arg_22_0.panelCountDown:hide()
	gGameApp:requestServer("/game/yy/snowball/start", function(arg_23_0)
		arg_22_0.gaming = true

		arg_22_0.rockerPanel:show()
		arg_22_0:createSprite()
		arg_22_0:createRocker()
		arg_22_0:startSnowBallAndGift()

		if arg_22_0.isGuide == 0 then
			arg_22_0:createGuide(1, function()
				return
			end)
			performWithDelay(arg_22_0, function()
				arg_22_0:createGuide(2, arg_22_0.initGuideCountDown)
			end, 1)
		else
			arg_22_0:initCountDown()
		end
	end, arg_22_0.activityId, arg_22_0.isGuide)
end

function var_0_1.gameOver(arg_26_0)
	arg_26_0.gaming = false

	arg_26_0.rockerPanel:hide()
	arg_26_0.bg:stopAllActions()
	arg_26_0:disableSchedule()
	arg_26_0.rockerPanel:unscheduleUpdate()
	arg_26_0:stopAllActions()

	for iter_26_0 = 1, 5 do
		arg_26_0["cannon" .. iter_26_0]:stopAllActions()
		arg_26_0["cannon" .. iter_26_0]:play("effect_loop")
	end

	for iter_26_1, iter_26_2 in pairs(arg_26_0.tGift) do
		iter_26_2.lihe:stopAllActions()
	end

	for iter_26_3, iter_26_4 in pairs(arg_26_0.tSnowBall) do
		iter_26_4.snowBall:stopAllActions()
		iter_26_4.snowBallDi:stopAllActions()
	end
end

function var_0_1.showGmameEnd(arg_27_0, arg_27_1)
	local var_27_0 = arg_27_1 > arg_27_0.topPoint

	gGameUI:stackUI("city.activity.snow_ball.game_over", nil, {
		blackLayer = true
	}, arg_27_0, arg_27_1, var_27_0, arg_27_0.isGuide)
end

function var_0_1.startSnowBallAndGift(arg_28_0)
	local var_28_0 = {}
	local var_28_1 = csv.yunying.yyhuodong[arg_28_0.activityId].huodongID

	for iter_28_0, iter_28_1 in orderCsvPairs(csv.yunying.snowball_stage) do
		if iter_28_1.huodongID == var_28_1 then
			local var_28_2 = csvClone(iter_28_1.dropsTempo)

			var_28_2.timeScore = iter_28_1.timeScore
			var_28_0[iter_28_1.timing] = var_28_2
		end
	end

	local var_28_3 = 0
	local var_28_4 = 0
	local var_28_5 = 0
	local var_28_6 = csv.yunying.yyhuodong[arg_28_0.activityId].paramMap.playTimeMax
	local var_28_7 = 0

	arg_28_0.ballGuideDelay = 0
	arg_28_0.giftGuideDelay = 0

	arg_28_0:schedule(function(arg_29_0)
		if arg_28_0.playTime <= var_28_3 then
			return
		end

		local var_29_0 = true

		var_28_4 = var_28_3

		for iter_29_0 = 1, var_28_6 do
			if var_28_0[iter_29_0] and arg_28_0.playTime > var_28_3 and iter_29_0 >= arg_28_0.playTime then
				var_28_3 = iter_29_0
				var_28_5 = var_28_3 - var_28_4

				break
			end
		end

		local var_29_1 = var_28_0[var_28_3] or {}

		arg_28_0.point:modify(function(arg_30_0)
			return true, arg_30_0 + var_28_7
		end)

		var_28_7 = var_29_1.timeScore or 0

		for iter_29_1, iter_29_2 in pairs(var_29_1) do
			if iter_29_1 ~= "effect" and iter_29_1 ~= "timeScore" then
				if csv.yunying.snowball_element[iter_29_1].belongs == 1 then
					arg_28_0:createSnow(iter_29_2, iter_29_1, var_28_5)
				elseif csv.yunying.snowball_element[iter_29_1].belongs == 2 then
					arg_28_0:createGift(iter_29_2, iter_29_1, var_28_5)
				end
			end
		end

		if math.abs(arg_28_0.giftGuideDelay - arg_28_0.ballGuideDelay) < 1 then
			if arg_28_0.giftGuideDelay < arg_28_0.ballGuideDelay then
				arg_28_0.ballGuideDelay = arg_28_0.ballGuideDelay + 1
			else
				arg_28_0.giftGuideDelay = arg_28_0.giftGuideDelay + 1
			end
		end

		if not arg_28_0.hasGuide4 and arg_28_0.isGuide == 0 then
			performWithDelay(arg_28_0, function()
				arg_28_0:createGuide(4, function()
					return
				end)
			end, arg_28_0.giftGuideDelay + 1)

			arg_28_0.hasGuide4 = true
		end

		if not arg_28_0.hasGuide3 and arg_28_0.isGuide == 0 then
			performWithDelay(arg_28_0, function()
				arg_28_0:createGuide(3, function()
					return
				end)
			end, arg_28_0.ballGuideDelay + 1)

			arg_28_0.hasGuide3 = true
		end

		if var_29_1.effect then
			arg_28_0.cannon1:play(var_29_1.effect)
			performWithDelay(arg_28_0.cannon2, function()
				arg_28_0.cannon2:play(var_29_1.effect)
			end, 0.25)
			performWithDelay(arg_28_0.cannon3, function()
				arg_28_0.cannon3:play(var_29_1.effect)
			end, 0.5)
			arg_28_0.cannon4:play("effect_loop")
			performWithDelay(arg_28_0.cannon5, function()
				arg_28_0.cannon5:play("effect_loop")
			end, 0.25)
		end
	end, 0.5, 0, 667)
end

function var_0_1.createCannon(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	arg_38_0.cannon1 = widget.addAnimationByKey(arg_38_0.bg, "snow_ball/shengdan_tankemiaomiao.skel", nil, "standby_loop", 5):xy(780, 650):z(10000):scale(1.1)
	arg_38_0.cannon2 = widget.addAnimationByKey(arg_38_0.bg, "snow_ball/shengdan_tankemiaomiao.skel", nil, "standby_loop", 5):xy(660, 425):z(10000):scale(1.3)
	arg_38_0.cannon3 = widget.addAnimationByKey(arg_38_0.bg, "snow_ball/shengdan_tankemiaomiao.skel", nil, "standby_loop", 5):xy(540, 200):z(10000):scale(1.5)
	arg_38_0.cannon4 = widget.addAnimationByKey(arg_38_0.bg, "snow_ball/shengdanxinshiniao.skel", nil, "standby_loop", 5):xy(1150, 600):z(10000):scale(1.8)
	arg_38_0.cannon5 = widget.addAnimationByKey(arg_38_0.bg, "snow_ball/shengdanxinshiniao.skel", nil, "standby_loop", 5):xy(1080, 350):z(10000):scale(2)
end

function var_0_1.createSnow(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	arg_39_0.ballGuideDelay = arg_39_3

	for iter_39_0 = 1, arg_39_1 do
		local var_39_0 = math.random(0, arg_39_3 * 100) / 100

		arg_39_0.ballGuideDelay = math.min(var_39_0, arg_39_0.ballGuideDelay)

		local var_39_1 = math.random(arg_39_0.posTable[1].x, arg_39_0.posTable[4].x)
		local var_39_2 = math.random(arg_39_0.posTable[1].y, arg_39_0.posTable[2].y)
		local var_39_3 = cc.DelayTime:create(var_39_0)

		arg_39_0.bg:runAction(cc.Sequence:create(var_39_3, cc.CallFunc:create(function()
			local var_40_0 = widget.addAnimationByKey(arg_39_0.bg, "snow_ball/shengdan_xueqiu.skel", nil, "effect", 5):xy(var_39_1, var_39_2):z(10000 - var_39_2):scale(0.8)
			local var_40_1 = widget.addAnimationByKey(arg_39_0.bg, "snow_ball/shengdan_xueqiu.skel", nil, "effect_di", 5):xy(var_39_1, var_39_2):z(10000 - var_39_2 - 1):scale(0.8)

			table.insert(arg_39_0.tSnowBall, {
				snowBall = var_40_0,
				snowBallDi = var_40_1,
				x = var_39_1,
				y = var_39_2,
				time = var_0_6()
			})
		end)))
	end
end

function var_0_1.createGift(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	local var_41_0 = csv.yunying.snowball_element[arg_41_2].attr.stayTime

	arg_41_0.giftGuideDelay = arg_41_3

	for iter_41_0 = 1, arg_41_1 do
		local var_41_1 = math.random(0, arg_41_3 * 100) / 100

		arg_41_0.giftGuideDelay = math.min(var_41_1, arg_41_0.giftGuideDelay)

		local var_41_2 = math.random(arg_41_0.posTable[1].x, arg_41_0.posTable[4].x)
		local var_41_3 = math.random(arg_41_0.posTable[1].y, arg_41_0.posTable[2].y)
		local var_41_4 = cc.DelayTime:create(var_41_1)

		arg_41_0.bg:runAction(cc.Sequence:create(var_41_4, cc.CallFunc:create(function()
			local var_42_0 = widget.addAnimationByKey(arg_41_0.bg, "snow_ball/lihe.skel", nil, "effect", 5):xy(var_41_2, var_41_3):z(10000 - var_41_3)

			var_42_0:setSpriteEventHandler(function(arg_43_0, arg_43_1)
				var_42_0:play("standby_loop")
			end, sp.EventType.ANIMATION_COMPLETE)
			table.insert(arg_41_0.tGift, {
				lihe = var_42_0,
				x = var_41_2,
				y = var_41_3,
				csvId = arg_41_2,
				endTime = var_0_6() + (var_41_0 + 1) * 1000,
				time = var_0_6()
			})
		end)))
	end
end

function var_0_1.createRocker(arg_44_0, arg_44_1, arg_44_2)
	arg_44_0.rockerXY = cc.p(600, 250)
	arg_44_0.cos = 0
	arg_44_0.sin = 0
	arg_44_0.r = 0

	if not arg_44_0.rockerBg then
		arg_44_0.rockerBg = ccui.ImageView:create("activity/snow_ball/btn_xqdbs_yg1.png"):addTo(arg_44_0.rockerPanel):z(100):anchorPoint(0.5, 0.5)
		arg_44_0.rocker = ccui.ImageView:create("activity/snow_ball/btn_xqdbs_yg2.png"):addTo(arg_44_0.rockerBg):alignCenter(arg_44_0.rockerBg:size()):z(1):anchorPoint(0.5, 0.5)
	end

	if arg_44_1 == nil then
		arg_44_0.rockerBg:xy(arg_44_0.rockerXY)

		local var_44_0 = adapt.dockWithScreen(arg_44_0.rockerBg, "left", "down")

		arg_44_0.sprite:play("shengdan_standby_loop")
	else
		arg_44_0.startPos = arg_44_0.rockerPanel:convertToNodeSpace(arg_44_2)

		arg_44_0.rockerBg:xy(arg_44_0.startPos)
		arg_44_0.sprite:play("shengdan_run_loop")
	end

	local var_44_1 = 130
	local var_44_2 = 60
	local var_44_3 = arg_44_0.spriteShadow:getBoundingBox().width

	arg_44_0.rockerPanel:scheduleUpdate(function(arg_45_0)
		arg_44_0:moveSprite()

		local var_45_0, var_45_1 = arg_44_0.spriteShadow:xy()

		for iter_45_0, iter_45_1 in pairs(arg_44_0.tGift) do
			if var_0_6() > iter_45_1.endTime then
				iter_45_1.lihe:removeSelf()

				arg_44_0.tGift[iter_45_0] = nil

				break
			end
		end

		for iter_45_2, iter_45_3 in pairs(arg_44_0.tGift) do
			local var_45_2 = var_0_6() - iter_45_3.time > 800
			local var_45_3 = iter_45_3.x
			local var_45_4 = iter_45_3.y
			local var_45_5 = math.sqrt((var_45_3 - var_45_0) * (var_45_3 - var_45_0) + (var_45_4 - var_45_1) * (var_45_4 - var_45_1))

			if math.sqrt((var_45_3 - var_45_0) * (var_45_3 - var_45_0) + (var_45_4 - var_45_1) * (var_45_4 - var_45_1)) - var_44_3 / 2 < var_44_1 / 2 and var_45_2 then
				arg_44_0:getGift(iter_45_3.csvId)

				arg_44_0.tGift[iter_45_2] = nil

				iter_45_3.lihe:play("effect_zhakai")
				iter_45_3.lihe:setSpriteEventHandler(function(arg_46_0, arg_46_1)
					performWithDelay(iter_45_3.lihe, function()
						if iter_45_3 and iter_45_3.lihe then
							iter_45_3.lihe:removeSelf()
						end
					end, 0)
				end, sp.EventType.ANIMATION_COMPLETE)

				break
			end
		end

		for iter_45_4, iter_45_5 in pairs(arg_44_0.tSnowBall) do
			local var_45_6 = iter_45_5.x
			local var_45_7 = iter_45_5.y

			if var_0_6() - iter_45_5.time > 2000 then
				iter_45_5.snowBall:removeSelf()
				iter_45_5.snowBallDi:removeSelf()

				arg_44_0.tSnowBall[iter_45_4] = nil

				break
			end
		end

		for iter_45_6, iter_45_7 in pairs(arg_44_0.tSnowBall) do
			local var_45_8 = var_0_6() - iter_45_7.time > 1400 and var_0_6() - iter_45_7.time < 1600
			local var_45_9 = iter_45_7.x
			local var_45_10 = iter_45_7.y

			if math.sqrt((var_45_9 - var_45_0) * (var_45_9 - var_45_0) + (var_45_10 - var_45_1) * (var_45_10 - var_45_1)) - var_44_3 / 2 < var_44_2 / 2 and var_45_8 then
				iter_45_7.snowBall:removeSelf()
				iter_45_7.snowBallDi:removeSelf()

				arg_44_0.tSnowBall[iter_45_6] = nil

				arg_44_0:beHit()

				break
			end
		end
	end)
end

function var_0_1.removeRocker(arg_48_0)
	arg_48_0.rockerBg:xy(arg_48_0.rockerXY)

	local var_48_0 = adapt.dockWithScreen(arg_48_0.rockerBg, "left", "down")
	local var_48_1 = arg_48_0.rockerBg:width() / 2
	local var_48_2 = arg_48_0.rockerBg:height() / 2

	arg_48_0.rocker:xy(var_48_1, var_48_2)

	arg_48_0.cos = 0
	arg_48_0.sin = 0

	arg_48_0.sprite:play("shengdan_standby_loop")
end

function var_0_1.moveRocker(arg_49_0, arg_49_1, arg_49_2)
	local var_49_0 = 135
	local var_49_1 = arg_49_0.rockerPanel:convertToNodeSpace(arg_49_2)
	local var_49_2 = var_49_1.x - arg_49_0.startPos.x
	local var_49_3 = var_49_1.y - arg_49_0.startPos.y
	local var_49_4 = math.sqrt(math.pow(var_49_2, 2) + math.pow(var_49_3, 2))
	local var_49_5 = math.min(var_49_4, var_49_0)

	arg_49_0.cos = var_49_2 / var_49_4
	arg_49_0.sin = var_49_3 / var_49_4
	arg_49_0.r = var_49_5 / var_49_0

	local var_49_6 = var_49_5 * arg_49_0.cos
	local var_49_7 = var_49_5 * arg_49_0.sin
	local var_49_8 = arg_49_0.rockerBg:width() / 2
	local var_49_9 = arg_49_0.rockerBg:height() / 2

	arg_49_0.rocker:xy(var_49_8 + var_49_6, var_49_9 + var_49_7)
end

function var_0_1.moveSprite(arg_50_0)
	local var_50_0 = arg_50_0.attr.speed
	local var_50_1, var_50_2 = arg_50_0.spriteShadow:xy()
	local var_50_3 = var_50_0 * arg_50_0.cos * arg_50_0.r
	local var_50_4 = var_50_0 * arg_50_0.sin * arg_50_0.r
	local var_50_5 = var_50_1 + var_50_3
	local var_50_6 = var_50_2 + var_50_4

	if var_50_3 < 0 then
		arg_50_0.spriteShadow:get("imgSel"):scaleX(-1)
	elseif var_50_3 > 0 then
		arg_50_0.spriteShadow:get("imgSel"):scaleX(1)
	end

	if dataEasy.checkInRect({
		arg_50_0.posTable
	}, cc.p(var_50_5, var_50_6)) == 1 then
		arg_50_0.spriteShadow:xy(var_50_5, var_50_6):z(10000 - var_50_6)
	else
		for iter_50_0 = 1, 4 do
			local var_50_7 = iter_50_0 == 4 and 1 or iter_50_0 + 1
			local var_50_8 = var_0_5({
				cc.p(var_50_1, var_50_2),
				cc.p(var_50_5, var_50_6)
			}, {
				arg_50_0.posTable[iter_50_0],
				arg_50_0.posTable[var_50_7]
			})

			if var_50_8 then
				if iter_50_0 == 1 then
					var_50_8.y = var_50_8.y + var_50_0 * arg_50_0.sin
				elseif iter_50_0 == 2 then
					var_50_8.x = var_50_8.x + var_50_0 * arg_50_0.cos
				elseif iter_50_0 == 3 then
					var_50_8.y = var_50_8.y + var_50_0 * arg_50_0.sin
				else
					var_50_8.x = var_50_8.x + var_50_0 * arg_50_0.cos
				end

				var_50_8.x = math.max(arg_50_0.posTable[1].x, var_50_8.x)
				var_50_8.x = math.min(arg_50_0.posTable[3].x, var_50_8.x)
				var_50_8.y = math.min(arg_50_0.posTable[1].y, var_50_8.y)
				var_50_8.y = math.max(arg_50_0.posTable[3].y, var_50_8.y)

				arg_50_0.spriteShadow:xy(var_50_8):z(10000 - var_50_6)
			end
		end
	end
end

function var_0_1.beHit(arg_51_0)
	arg_51_0.myLife:modify(function(arg_52_0)
		return true, arg_52_0 - 1 < 0 and 0 or arg_52_0 - 1
	end)
	arg_51_0.spriteShadow:runAction(cc.Sequence:create(cc.Blink:create(1, 5), cc.Show:create()))
	arg_51_0.sprite:play("hit")
	arg_51_0.sprite:setSpriteEventHandler(function(arg_53_0, arg_53_1)
		if arg_51_0.rockerPanel:isVisible() and arg_51_0.gaming then
			arg_51_0.sprite:play("shengdan_run_loop")
		else
			arg_51_0.sprite:play("shengdan_standby_loop")
		end
	end, sp.EventType.ANIMATION_COMPLETE)
end

function var_0_1.getGift(arg_54_0, arg_54_1)
	arg_54_0.point:modify(function(arg_55_0)
		return true, arg_55_0 + csv.yunying.snowball_element[arg_54_1].attr.value
	end)
end

function var_0_1.createGuide(arg_56_0, arg_56_1, arg_56_2)
	local function var_56_0(arg_57_0, arg_57_1)
		local var_57_0 = ccui.Layout:create():size(display.sizeInView.width, display.sizeInView.height):anchorPoint(0.5, 0.5):xy(display.center):addTo(arg_56_0, 1)
		local var_57_1 = ccui.ImageView:create("login/new_character/img_tjltm@.png"):xy(arg_57_0.x + arg_57_1 + 800, arg_57_0.y > display.sizeInView.height / 2 and arg_57_0.y - 200 or arg_57_0.y + 200):addTo(var_57_0, 2)
		local var_57_2 = ccui.ImageView:create("city/gate/bg_dialog.png")

		var_57_2:setScale9Enabled(true)
		var_57_2:setCapInsets({
			width = 1,
			height = 1,
			x = 77,
			y = 58
		})
		var_57_2:addTo(var_57_1)
		var_57_2:xy(-160, 200)
		var_57_2:width(500)

		local var_57_3 = rich.createWithWidth("#C0x5b545b#" .. var_0_2[arg_56_1].content, 40, nil, 450):anchorPoint(0, 0):addTo(var_57_2, 3, "talkContent"):xy(25, 50)

		var_57_2:height(var_57_3:height() + 80)

		return var_57_0
	end

	local var_56_1 = var_0_2[arg_56_1] and arg_56_0[var_0_2[arg_56_1].nodeName]

	if var_56_1 then
		var_56_1:show()

		local var_56_2 = var_56_1:box()
		local var_56_3 = gGameUI:getConvertPos(var_56_1)
		local var_56_4 = var_56_1:anchorPoint()

		var_56_3.x = var_56_3.x - var_56_4.x * var_56_2.width + display.uiOrigin.x
		var_56_3.y = var_56_3.y - var_56_4.y * var_56_2.height

		local var_56_5 = var_56_0(var_56_3, (1 - var_56_4.x) * var_56_2.width)
		local var_56_6 = cc.RenderTexture:create(display.sizeInView.width, display.sizeInView.height):addTo(var_56_5, 1, "bgRender")
		local var_56_7 = cc.LayerColor:create(cc.c4b(0, 0, 0, 150), display.sizeInView.width, display.sizeInView.height)
		local var_56_8 = ccui.Scale9Sprite:create()
		local var_56_9 = var_56_2.width
		local var_56_10 = var_56_2.height

		var_56_7:retain()
		var_56_8:retain()
		var_56_8:initWithFile(cc.rect(80, 80, 1, 1), "other/guide/icon_mask.png")
		var_56_8:anchorPoint(0.5, 0.5):size(var_56_9, var_56_10):xy(var_56_3.x + var_56_2.width / 2, var_56_3.y + var_56_2.height / 2)
		var_56_8:setBlendFunc({
			dst = 0,
			src = GL_DST_ALPHA
		})

		local var_56_11 = display.sizeInView.width * 2 / var_56_2.width
		local var_56_12 = display.sizeInView.height * 2 / var_56_2.height
		local var_56_13 = math.max(var_56_11, var_56_12)

		var_56_8:scale(var_56_13)
		var_56_6:begin()
		var_56_7:visit()
		var_56_8:visit()
		var_56_6:endToLua()

		local var_56_14 = false
		local var_56_15 = var_56_13 - 1

		arg_56_0:schedule(function(arg_58_0)
			var_56_13 = var_56_13 - arg_58_0 / 0.3 * var_56_15

			if not var_56_14 then
				if var_56_13 <= 1 then
					var_56_13 = 1
					var_56_14 = true

					display.director:pause()
				end

				var_56_8:scale(var_56_13)
				var_56_6:beginWithClear(0, 0, 0, 0)
				var_56_7:visit()
				var_56_8:visit()
				var_56_6:endToLua()
			else
				var_56_7:release()
				var_56_8:release()

				return false
			end
		end, 0.03333333333333333, 0, "guideCircleAni")
		var_56_5:setBackGroundColorOpacity(0)

		local var_56_16 = cc.LayerColor:create(cc.c4b(255, 0, 255, 150), display.sizeInView.width, display.sizeInView.height):addTo(var_56_5, 2)
		local var_56_17 = false

		var_56_16:hide()

		local var_56_18 = cc.EventListenerTouchOneByOne:create()
		local var_56_19 = var_56_16:getEventDispatcher()
		local var_56_20 = cc.p(0, 0)

		local function var_56_21(arg_59_0)
			var_56_18:setEnabled(false)
			var_56_19:dispatchEvent(arg_59_0)
			var_56_18:setEnabled(true)
		end

		local function var_56_22(arg_60_0, arg_60_1)
			return true
		end

		local function var_56_23(arg_61_0, arg_61_1)
			var_56_21(arg_61_1)
		end

		local function var_56_24(arg_62_0, arg_62_1)
			display.director:resume()
			arg_56_2(arg_56_0)

			if var_56_5 and var_56_14 then
				var_56_5:removeFromParent()

				var_56_5 = nil
			end
		end

		var_56_18:setSwallowTouches(true)
		var_56_18:registerScriptHandler(var_56_22, cc.Handler.EVENT_TOUCH_BEGAN)
		var_56_18:registerScriptHandler(var_56_23, cc.Handler.EVENT_TOUCH_MOVED)
		var_56_18:registerScriptHandler(var_56_24, cc.Handler.EVENT_TOUCH_ENDED)
		var_56_18:registerScriptHandler(var_56_24, cc.Handler.EVENT_TOUCH_CANCELLED)
		var_56_19:addEventListenerWithSceneGraphPriority(var_56_18, var_56_16)
	else
		var_56_0()
		arg_56_2(arg_56_0)
	end
end

function var_0_1.onClose(arg_63_0)
	display.director:resume()
	var_0_0.onClose(arg_63_0)
end

return var_0_1
