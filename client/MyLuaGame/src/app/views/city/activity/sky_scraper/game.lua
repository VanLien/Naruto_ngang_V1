local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("SkyScraperGameView", var_0_0)

var_0_1.RESOURCE_FILENAME = "sky_scraper_game.json"
var_0_1.RESOURCE_BINDING = {
	panelCountDown = "panelCountDown",
	centerPanel = "centerPanel",
	bgPanel = "background",
	["info.imgSm"] = "imgSm",
	["centerPanel.hook"] = "hook",
	["centerPanel.basePanel"] = "basePanel",
	["rolePanel.car.txt"] = "floorTxt",
	["rolePanel.word"] = "word",
	info = "info",
	["info.score"] = {
		varname = "scoreNum",
		binds = {
			{
				event = "text",
				idler = bindHelper.self("point")
			},
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = cc.c4b(241, 61, 86, 255)
					}
				}
			}
		}
	},
	["info.scoreText"] = {
		varname = "scoreText",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(241, 61, 86, 255)
				}
			}
		}
	},
	["centerPanel.bar"] = {
		varname = "bar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				data = bindHelper.self("curPagePro")
			}
		}
	},
	btnDown = {
		varname = "btnDown",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDown")
			}
		}
	}
}

local var_0_2 = 3
local var_0_3 = 900
local var_0_4 = 0.3
local var_0_5 = 12
local var_0_6 = 0.8
local var_0_7 = 120
local var_0_8 = 1.5
local var_0_9 = 155 * var_0_8
local var_0_10 = 271 * var_0_8
local var_0_11 = 3
local var_0_12 = 3120
local var_0_13 = 1440
local var_0_14 = 400
local var_0_15 = {
	FAILURE = 0,
	PERFECT = 3,
	GOOD = 2,
	GENERAL = 1
}

function var_0_1.onCreate(arg_1_0, arg_1_1)
	arg_1_0.activityId = arg_1_1
	arg_1_0.gameEnd = false

	arg_1_0.btnDown:z(15000)
	arg_1_0:enableSchedule()
	arg_1_0:initModel()
	arg_1_0:addBackgroundSpine()
	arg_1_0:startCount()
	arg_1_0:initLife()
	arg_1_0:createFirstFloor()
end

function var_0_1.initModel(arg_2_0)
	arg_2_0.point = idler.new(0)
	arg_2_0.floor = idler.new(0)
	arg_2_0.myLife = idler.new(var_0_2)
	arg_2_0.curPagePro = idler.new(0)
	arg_2_0.perfectNum = 0
	arg_2_0.moveSpeed = 1
	arg_2_0.awardFloor = {}
	arg_2_0.maxRotate = 20

	arg_2_0.word:visible(false)

	local var_2_0 = gGameModel.role:read("yyhuodongs")[arg_2_0.activityId] or {}
	local var_2_1 = csv.yunying.yyhuodong[arg_2_0.activityId]

	arg_2_0.highpoint = var_2_0.info.high_points or 0
	arg_2_0.huodongID = var_2_1.huodongID
	arg_2_0.tOverLap = {}
	arg_2_0.overlap = 100
	arg_2_0.hookDir = "right"

	adapt.oneLinePos(arg_2_0.scoreText, arg_2_0.scoreNum, cc.p(5, 0), "left")
	idlereasy.when(arg_2_0.myLife, function(arg_3_0, arg_3_1)
		for iter_3_0 = 1, 3 do
			if arg_3_1 < iter_3_0 then
				cache.setShader(arg_2_0.tImgSm[iter_3_0], false, "hsl_gray")
			end
		end

		if arg_3_1 == 0 then
			performWithDelay(arg_2_0, function()
				arg_2_0:gameOver(0)
			end, 0.8)
		end
	end)
	idlereasy.when(arg_2_0.floor, function(arg_5_0, arg_5_1)
		local var_5_0 = csv.yunying.yyhuodong[arg_2_0.activityId].paramMap or {}

		arg_2_0.maxFloor = var_5_0.maxFloor

		arg_2_0.floorTxt:text(arg_5_1 .. gLanguageCsv.skyScraperFloor)

		if arg_5_1 == arg_2_0.maxFloor then
			performWithDelay(arg_2_0, function()
				arg_2_0:gameOver(0)
			end, 0.8)
		end

		for iter_5_0, iter_5_1 in orderCsvPairs(csv.yunying.skyscraper_floors) do
			if iter_5_1.huodongID == arg_2_0.huodongID and arg_5_1 >= iter_5_1.range[1] and arg_5_1 < iter_5_1.range[2] then
				arg_2_0.moveSpeed = iter_5_1.hookSpeed * var_0_14
				arg_2_0.maxRotate = iter_5_1.maxRotate
			end
		end

		for iter_5_2, iter_5_3 in pairs(arg_2_0.awardFloor) do
			if arg_5_1 == iter_5_3.floor then
				if iter_5_3.res ~= "" then
					local var_5_1 = arg_2_0.basePanel:getChildByName("house" .. arg_5_1 - 1):box()

					arg_2_0.award = cc.Sprite:create(iter_5_3.res)

					arg_2_0.award:addTo(arg_2_0.basePanel, 1000, "award" .. arg_5_1):xy(var_5_1.x + var_5_1.width * 0.5, var_5_1.y + var_5_1.height * 0.5 + 200):scale(var_0_8)
				end

				break
			elseif arg_5_1 == iter_5_3.floor + 1 and arg_2_0.award then
				arg_2_0.award:removeSelf()

				arg_2_0.award = nil
			end
		end
	end)
end

function var_0_1.initLife(arg_7_0)
	local var_7_0 = arg_7_0.imgSm

	arg_7_0.tImgSm = {
		arg_7_0.imgSm
	}

	for iter_7_0 = 2, 3 do
		local var_7_1 = var_7_0:clone():addTo(var_7_0:getParent()):xy(var_7_0:x() + 160 * (iter_7_0 - 1), var_7_0:y())

		table.insert(arg_7_0.tImgSm, var_7_1)
	end
end

function var_0_1.updateOverLap(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.basePanel:y()

	if #arg_8_0.tOverLap >= var_0_5 then
		table.remove(arg_8_0.tOverLap, 1)
	end

	table.insert(arg_8_0.tOverLap, arg_8_1)

	local var_8_1 = 0

	for iter_8_0, iter_8_1 in ipairs(arg_8_0.tOverLap) do
		var_8_1 = var_8_1 + iter_8_1
	end

	arg_8_0.overlap = var_8_1 / #arg_8_0.tOverLap
end

function var_0_1.createFirstFloor(arg_9_0)
	local var_9_0 = arg_9_0.floor:read()
	local var_9_1 = csv.yunying.skyscraper_resources
	local var_9_2
	local var_9_3

	for iter_9_0, iter_9_1 in orderCsvPairs(var_9_1) do
		if iter_9_1.huodongID == arg_9_0.huodongID and var_9_0 >= iter_9_1.range[1] and var_9_0 < iter_9_1.range[2] then
			if itertools.size(iter_9_1.pngResource) == 0 then
				local var_9_4 = itertools.size(iter_9_1.spineResource)

				var_9_2 = iter_9_1.spineResource[math.random(1, var_9_4)]
				var_9_3 = "spine"

				break
			end

			local var_9_5 = itertools.size(iter_9_1.pngResource)

			var_9_2 = iter_9_1.pngResource[math.random(1, var_9_5)]
			var_9_3 = "png"

			break
		end
	end

	local var_9_6
	local var_9_7 = "house" .. arg_9_0.floor:read()

	if var_9_3 == "png" then
		cc.Sprite:create(var_9_2):xy(arg_9_0.basePanel:width() / 2, 0):anchorPoint(0.5, 0):addTo(arg_9_0.basePanel, 10000, var_9_7):scale(var_0_8)
	elseif arg_9_0.topHouse.resType == "spine" then
		widget.addAnimationByKey(arg_9_0.basePanel, var_9_2, var_9_7, "effect_loop", 10):xy(arg_9_0.basePanel:width() / 2, 0):anchorPoint(0.5, 0):scale(var_0_8)
	end

	arg_9_0.floor:set(arg_9_0.floor:read() + 1)
end

function var_0_1.createDroppingHouse(arg_10_0)
	local var_10_0 = arg_10_0.housePanel
	local var_10_1 = var_10_0:anchorPoint().y
	local var_10_2 = var_10_0:getParent():convertToWorldSpace(cc.p(var_10_0:x(), var_10_0:y() - var_0_9 * var_10_1))
	local var_10_3 = arg_10_0.centerPanel:convertToNodeSpace(var_10_2)
	local var_10_4 = ccui.Layout:create():size(var_0_10, var_0_9):addTo(arg_10_0.centerPanel, 0, "house" .. arg_10_0.floor:read()):anchorPoint(0.5, 0):xy(var_10_3.x, var_10_3.y)

	if arg_10_0.topHouse.resType == "png" then
		cc.Sprite:create(arg_10_0.topHouse.houseResource):xy(var_10_3.x, var_10_3.y):anchorPoint(0.5, 0.5):addTo(var_10_4):xy(var_0_10 / 2, var_0_9 / 2):scale(var_0_8)
	elseif arg_10_0.topHouse.resType == "spine" then
		local var_10_5 = widget.addAnimationByKey(var_10_4, arg_10_0.topHouse.houseResource, "house", "effect_loop", 10):xy(var_0_10 / 2, var_0_9 / 2 - 120):anchorPoint(0.5, 0.5):scale(var_0_8)
	end

	return var_10_4
end

function var_0_1.createTopHousePanel(arg_11_0)
	arg_11_0.housePanel = ccui.Layout:create():size(var_0_10, var_0_9):addTo(arg_11_0.hook, 0, "housePanel"):anchorPoint(0.5, 0.9):xy(arg_11_0.hook:width() / 2, 30)
end

function var_0_1.runTopHookAction(arg_12_0)
	local var_12_0 = 1200 / arg_12_0.moveSpeed

	arg_12_0.hook:stopActionByTag(888)
	arg_12_0.housePanel:stopActionByTag(777)

	if arg_12_0.hookDir == "right" then
		local var_12_1 = cc.MoveTo:create(var_12_0, cc.p(1100, 1310))
		local var_12_2 = cc.Sequence:create(cc.EaseSineInOut:create(var_12_1), cc.CallFunc:create(function()
			arg_12_0.hookDir = "left"

			arg_12_0:runTopHookAction()
		end))
		local var_12_3 = cc.EaseInOut:create(cc.RotateTo:create(var_12_0, -10), var_12_0)

		arg_12_0.hook:runAction(var_12_2)
		arg_12_0.housePanel:runAction(var_12_3)
		var_12_2:setTag(888)
		var_12_3:setTag(777)
	else
		local var_12_4 = cc.MoveTo:create(var_12_0, cc.p(-100, 1310))
		local var_12_5 = cc.Sequence:create(cc.EaseSineInOut:create(var_12_4), cc.CallFunc:create(function()
			arg_12_0.hookDir = "right"

			arg_12_0:runTopHookAction()
		end))
		local var_12_6 = cc.EaseInOut:create(cc.RotateTo:create(var_12_0, 10), var_12_0)

		arg_12_0.hook:runAction(var_12_5)
		arg_12_0.housePanel:runAction(var_12_6)
		var_12_5:setTag(888)
		var_12_6:setTag(777)
	end
end

function var_0_1.createTopHouse(arg_15_0)
	if arg_15_0.floor:read() == arg_15_0.maxFloor then
		return
	end

	local var_15_0 = arg_15_0.floor:read()
	local var_15_1 = csv.yunying.skyscraper_resources
	local var_15_2
	local var_15_3

	for iter_15_0, iter_15_1 in orderCsvPairs(var_15_1) do
		if iter_15_1.huodongID == arg_15_0.huodongID and var_15_0 >= iter_15_1.range[1] and var_15_0 < iter_15_1.range[2] then
			if itertools.size(iter_15_1.pngResource) == 0 then
				local var_15_4 = itertools.size(iter_15_1.spineResource)

				var_15_2 = iter_15_1.spineResource[math.random(1, var_15_4)]
				var_15_3 = "spine"
			else
				local var_15_5 = itertools.size(iter_15_1.pngResource)

				var_15_2 = iter_15_1.pngResource[math.random(1, var_15_5)]
				var_15_3 = "png"
			end
		end
	end

	if arg_15_0.topHouse then
		arg_15_0.topHouse:removeSelf()

		arg_15_0.topHouse = nil
	end

	if var_15_3 == "png" then
		arg_15_0.topHouse = cc.Sprite:create(var_15_2):anchorPoint(0.5, 0.5):addTo(arg_15_0.housePanel):xy(var_0_10 / 2, var_0_9 / 2):scale(var_0_8)
	else
		arg_15_0.topHouse = widget.addAnimationByKey(arg_15_0.housePanel, var_15_2, "house", "effect_loop", 10):xy(var_0_10 / 2, var_0_9 / 2 - 120):anchorPoint(0.5, 0.5):scale(var_0_8)
	end

	arg_15_0.topHouse.houseResource = var_15_2
	arg_15_0.topHouse.resType = var_15_3

	arg_15_0.topHouse:show()
end

function var_0_1.startWaggle(arg_16_0, arg_16_1)
	arg_16_0.basePanel:stopActionByTag(666)

	local var_16_0

	if arg_16_0.rotateDir == "right" then
		var_16_0 = -(100 - arg_16_0.overlap) * arg_16_0.maxRotate / 100
	else
		var_16_0 = (100 - arg_16_0.overlap) * arg_16_0.maxRotate / 100
	end

	local var_16_1 = arg_16_0.basePanel:getRotation()
	local var_16_2 = arg_16_1 and var_0_6 or var_0_6 * 2

	if arg_16_0.rotateDir == "right" then
		local var_16_3 = cc.Sequence:create(cc.RotateTo:create(var_16_2, var_16_0), cc.CallFunc:create(function()
			arg_16_0.rotateDir = "left"

			arg_16_0:startWaggle(false)
		end))

		var_16_3:setTag(666)
		arg_16_0.basePanel:runAction(cc.EaseInOut:create(var_16_3, var_16_2))
	else
		local var_16_4 = cc.Sequence:create(cc.RotateTo:create(var_16_2, var_16_0), cc.CallFunc:create(function()
			arg_16_0.rotateDir = "right"

			arg_16_0:startWaggle(false)
		end))

		var_16_4:setTag(666)
		arg_16_0.basePanel:runAction(cc.EaseInOut:create(var_16_4, var_16_2))
	end
end

function var_0_1.onDown(arg_19_0)
	if not arg_19_0.topHouse:isVisible() or arg_19_0.gameEnd then
		return
	end

	arg_19_0:unSchedule(100)
	arg_19_0.topHouse:hide()

	local var_19_0 = arg_19_0:createDroppingHouse()
	local var_19_1 = arg_19_0.floor:read()
	local var_19_2 = var_19_1

	if var_19_1 > var_0_5 then
		var_19_2 = var_0_5
	end

	local var_19_3 = (var_19_0:y() - (var_0_9 * var_19_2 + arg_19_0.basePanel:y())) / var_0_3
	local var_19_4 = (600 - math.abs(arg_19_0.hook:x() - 500)) / 600 * (arg_19_0.moveSpeed / var_0_14) * var_0_7 + 30
	local var_19_5 = arg_19_0.hookDir == "right" and var_19_4 or -var_19_4
	local var_19_6 = cc.MoveBy:create(var_19_3, cc.p(var_19_5, 0))
	local var_19_7 = cc.MoveBy:create(var_19_3, cc.p(0, var_0_9 * var_19_2 + arg_19_0.basePanel:y() - var_19_0:y()))

	var_19_0:runAction(cc.Spawn:create(var_19_6, cc.EaseSineIn:create(var_19_7)))

	local var_19_8 = cc.RotateTo:create(0.2, 0)

	var_19_0:runAction(var_19_8)
	performWithDelay(arg_19_0, function()
		local function var_20_0()
			arg_19_0:createTopHouse()
			arg_19_0:updateTime()
		end

		if arg_19_0:calculate() then
			local var_20_1 = arg_19_0.floor:read()

			arg_19_0.basePanel:height(var_0_9 * var_20_1)

			if var_20_1 >= var_0_5 then
				local var_20_2 = var_20_1 - var_0_5

				arg_19_0.basePanel:anchorPoint(0.5, var_20_2 / var_20_1)
				arg_19_0.basePanel:y(arg_19_0.basePanel:y() + var_0_9)
			end

			if var_20_1 > 2 then
				if var_20_1 == var_0_5 then
					arg_19_0.basePanel:y(arg_19_0.basePanel:y() - var_0_9)
				end

				if var_20_1 == var_0_11 then
					arg_19_0.basePanel:y(arg_19_0.basePanel:y() - var_0_9)
				end

				local var_20_3 = arg_19_0.basePanel:y() - var_0_9
				local var_20_4 = cc.MoveTo:create(var_0_4, cc.p(arg_19_0.basePanel:x(), var_20_3))

				arg_19_0.basePanel:runAction(cc.Sequence:create(var_20_4, cc.CallFunc:create(function()
					var_20_0()
				end)))

				local var_20_5 = -1 / arg_19_0.maxFloor * arg_19_0.background:height() * 0.75

				arg_19_0.background:runAction(cc.MoveBy:create(var_0_4, cc.p(0, var_20_5)))
			else
				var_20_0()
			end
		end
	end, var_19_3)
end

function var_0_1.addDroppingEffect(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = 200
	local var_23_1 = 220

	if arg_23_0.topHouse.resType == "spine" then
		local var_23_2 = widget.addAnimationByKey(arg_23_2, "skyscraper/floor_tx.skel", "bottom", "effecr_yanwu", 10):xy(200, -20):scale(var_0_8)
	else
		local var_23_3 = widget.addAnimationByKey(arg_23_2, "skyscraper/floor_tx.skel", "bottom", "effecr_yanwu", 10):xy(200, 0):scale(var_0_8)
	end

	if arg_23_1 == var_0_15.GENERAL then
		-- block empty
	elseif arg_23_1 == var_0_15.GOOD and (arg_23_0.topHouse.resType ~= "spine" or true) then
		local var_23_4 = widget.addAnimationByKey(arg_23_2, "skyscraper/floor_tx.skel", "word", "effect_good", 20):xy(var_23_0, var_23_1):scale(var_0_8)

		arg_23_0.word:visible(true)
		arg_23_0.word:get("txt"):text(gLanguageCsv.skyscraperGood)
		performWithDelay(arg_23_0, function()
			arg_23_0.word:visible(false)
		end, 1)
	elseif arg_23_1 == var_0_15.PERFECT then
		if arg_23_0.topHouse.resType == "spine" then
			var_23_0 = 0
		end

		local var_23_5 = widget.addAnimationByKey(arg_23_2, "skyscraper/floor_tx.skel", "word", "effect_perfect", 20):xy(var_23_0, var_23_1):scale(var_0_8)

		arg_23_0.word:visible(true)
		arg_23_0.word:get("txt"):text(gLanguageCsv.skyscraperPerfect)
		performWithDelay(arg_23_0, function()
			arg_23_0.word:visible(false)
		end, 1)

		arg_23_0.perfectNum = arg_23_0.perfectNum + 1
	end
end

function var_0_1.calculate(arg_26_0)
	local var_26_0 = arg_26_0.centerPanel:getChildByName("house" .. arg_26_0.floor:read())
	local var_26_1 = var_26_0:getParent():convertToWorldSpace(cc.p(var_26_0:getPosition()))
	local var_26_2 = arg_26_0.basePanel:convertToNodeSpace(var_26_1)
	local var_26_3 = var_26_0:box()
	local var_26_4 = arg_26_0.basePanel:getChildByName("house" .. arg_26_0.floor:read() - 1)
	local var_26_5 = (1 - math.abs(var_26_4:x() - var_26_2.x) / var_0_10) * 100

	for iter_26_0, iter_26_1 in orderCsvPairs(csv.yunying.skyscraper_accessment) do
		if iter_26_1.huodongID == arg_26_0.huodongID then
			if iter_26_1.type == var_0_15.FAILURE then
				if var_26_5 <= iter_26_1.contactRange then
					local var_26_6 = -300
					local var_26_7 = (var_26_0:y() - var_26_6) / var_0_3 * 0.75
					local var_26_8 = cc.MoveTo:create(var_26_7, cc.p(var_26_0:x(), var_26_6))

					var_26_0:runAction(cc.Sequence:create(var_26_8, cc.CallFunc:create(function()
						var_26_0:removeSelf()
						arg_26_0:updateTime()
						arg_26_0:createTopHouse()
					end)))
					arg_26_0.myLife:set(arg_26_0.myLife:read() - 1)

					return false
				end
			elseif var_26_5 <= iter_26_1.contactRange then
				var_26_0:retain()
				var_26_0:removeFromParent()
				var_26_0:xy(var_26_2.x, arg_26_0.floor:read() * var_0_9)
				var_26_0:addTo(arg_26_0.basePanel, 10000, "house" .. arg_26_0.floor:read())
				var_26_0:release()
				arg_26_0:addDroppingEffect(iter_26_1.type, var_26_0)

				if arg_26_0.floor:read() > 5 then
					arg_26_0.basePanel:removeChildByName("house" .. arg_26_0.floor:read() - 5)
				end

				arg_26_0:updateOverLap(var_26_5)
				arg_26_0.point:set(arg_26_0.point:read() + iter_26_1.points)

				break
			end
		end
	end

	arg_26_0.floor:set(arg_26_0.floor:read() + 1)

	return true
end

function var_0_1.updateTime(arg_28_0)
	local var_28_0 = 5
	local var_28_1 = var_28_0

	arg_28_0:enableSchedule():unSchedule(100)
	arg_28_0:schedule(function(arg_29_0)
		var_28_1 = var_28_1 - arg_29_0

		if var_28_1 <= 0 then
			arg_28_0:onDown()

			return false
		end

		arg_28_0.curPagePro:set(math.min(var_28_1 / var_28_0) * 100, 100)
	end, 0.01, 0, 100)
end

function var_0_1.checkCheat(arg_30_0)
	local var_30_0 = 0
	local var_30_1 = 20

	arg_30_0:schedule(function(arg_31_0)
		var_30_0 = var_30_0 + 1
		arg_30_0.playTime = time.getTime() - arg_30_0.startTime

		if math.abs(arg_30_0.playTime - var_30_0) > var_30_1 then
			gGameUI:showTip(gLanguageCsv.skyScraperTimeError)
			performWithDelay(arg_30_0, function()
				arg_30_0:onClose()
			end, 3)

			return false
		end
	end, 1, 0, 11)
end

function var_0_1.huodongTimeOut(arg_33_0)
	local var_33_0 = gGameModel.role:read("yy_endtime")[arg_33_0.activityId]
	local var_33_1 = 0

	arg_33_0:schedule(function(arg_34_0)
		var_33_1 = var_33_1 + 1

		if math.floor(var_33_0 - time.getTime()) <= 0 then
			gGameUI:showTip(gLanguageCsv.flipCardFinishedClickTip)
			performWithDelay(arg_33_0, function()
				arg_33_0:onClose()
			end, 3)

			return false
		end
	end, 1, 0, 20)
end

function var_0_1.addBackgroundSpine(arg_36_0)
	local var_36_0 = widget.addAnimationByKey(arg_36_0.background:get("bg1"), "skyscraper/dieloufang_01.skel", "effect", "effect_loop", 1):anchorPoint(0.5, 0.5):xy(780, 360)
	local var_36_1 = widget.addAnimationByKey(arg_36_0.background:get("bg2"), "skyscraper/dieloufang_02.skel", "effect", "effect_loop", 1):anchorPoint(0.5, 0.5):xy(780, 720)
	local var_36_2 = widget.addAnimationByKey(arg_36_0.background:get("bg3"), "skyscraper/dieloufang_03.skel", "effect", "effect_loop", 2):anchorPoint(0.5, 0.5):xy(780, 360)
	local var_36_3 = widget.addAnimationByKey(arg_36_0.background:get("bg4"), "skyscraper/dieloufang_04.skel", "effect", "effect_loop", 2):xy(780, 0)
end

function var_0_1.startCount(arg_37_0)
	local var_37_0 = csv.yunying.yyhuodong[arg_37_0.activityId]

	arg_37_0.panelCountDown:show()

	local var_37_1 = 3
	local var_37_2 = arg_37_0.panelCountDown:get("textNum")

	var_37_2:text(var_37_1)
	arg_37_0:createTopHousePanel()
	arg_37_0:createTopHouse()
	adapt.oneLineCenterPos(cc.p(arg_37_0.panelCountDown:width() / 2, arg_37_0.panelCountDown:height() / 2), {
		arg_37_0.panelCountDown:get("textNote"),
		arg_37_0.panelCountDown:get("textNum")
	})
	arg_37_0:schedule(function(arg_38_0)
		if var_37_1 > 0 then
			arg_37_0.btnDown:setTouchEnabled(false)

			local var_38_0 = var_37_2

			var_37_2:text(var_37_1)
			var_37_2:scale(1.3)
			var_37_2:runAction(cc.ScaleTo:create(0.5, 1))
			adapt.oneLineCenterPos(cc.p(arg_37_0.panelCountDown:width() / 2, arg_37_0.panelCountDown:height() / 2), {
				arg_37_0.panelCountDown:get("textNote"),
				arg_37_0.panelCountDown:get("textNum")
			})

			var_37_1 = var_37_1 - 1
		else
			arg_37_0:gameStart()
			arg_37_0.btnDown:setTouchEnabled(true)

			return false
		end
	end, 1, 0, 663)
end

function var_0_1.gameStart(arg_39_0)
	arg_39_0.startTime = time.getTime()

	arg_39_0.btnDown:setTouchEnabled(true)
	arg_39_0.panelCountDown:hide()
	arg_39_0:rangeFloor()
	arg_39_0:runTopHookAction()
	arg_39_0:updateTime()
	arg_39_0:createTopHouse()
	arg_39_0:startWaggle(true)
	arg_39_0:checkCheat()
	arg_39_0:huodongTimeOut()
end

function var_0_1.rangeFloor(arg_40_0)
	for iter_40_0, iter_40_1 in orderCsvPairs(csv.yunying.skyscraper_floors) do
		if iter_40_1.huodongID == arg_40_0.huodongID then
			local var_40_0 = math.random(iter_40_1.range[1], iter_40_1.range[2] - 1)

			table.insert(arg_40_0.awardFloor, {
				floor = var_40_0,
				res = iter_40_1.awardsIcon
			})
		end
	end
end

function var_0_1.gameOver(arg_41_0, arg_41_1)
	arg_41_0.hook:stopAllActions()
	arg_41_0:enableSchedule():unSchedule(100)

	arg_41_0.gameEnd = true

	local var_41_0 = arg_41_0.point:read() > arg_41_0.highpoint
	local var_41_1 = {}
	local var_41_2 = 0

	for iter_41_0, iter_41_1 in pairs(arg_41_0.awardFloor) do
		if arg_41_0.floor:read() > iter_41_1.floor then
			table.insert(var_41_1, iter_41_1.floor)

			if iter_41_1.res ~= "" then
				var_41_2 = var_41_2 + 1
			end
		end
	end

	gGameApp:requestServerCustom("/game/yy/skyscraper/end"):onErrClose(function()
		arg_41_0:onClose()
	end):params(arg_41_0.activityId, arg_41_0.point:read(), arg_41_0.floor:read(), arg_41_0.perfectNum, 0, itertools.size(var_41_1)):doit(function(arg_43_0)
		gGameUI:stackUI("city.activity.sky_scraper.game_over", nil, {
			full = true
		}, arg_41_0:createHandler("onClose"), arg_41_0.activityId, arg_41_0.point:read(), arg_41_0.floor:read(), var_41_0, var_41_2, arg_43_0)
	end)
end

return var_0_1
