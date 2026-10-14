local var_0_0

if device.platform == "windows" then
	-- block empty
end

local var_0_1 = {
	-100,
	1100
}
local var_0_2 = {
	width = 333.33333333333337,
	height = 191.66666666666669
}
local var_0_3 = 5
local var_0_4 = 2.2
local var_0_5 = 5
local var_0_6 = 5
local var_0_7 = 5
local var_0_8 = 0.1
local var_0_9 = 0.8
local var_0_10 = {
	3,
	2
}
local var_0_11 = 500
local var_0_12 = 200
local var_0_13 = 30
local var_0_14 = 800
local var_0_15 = 1000
local var_0_16 = 40
local var_0_17 = 1.5
local var_0_18 = 20
local var_0_19 = {
	MOVE = 1,
	DROP = 2,
	GAME_OVER = 3,
	READY = 0
}
local var_0_20 = cc.load("mvc").ViewBase
local var_0_21 = class("SkyScraperGame2View", var_0_20)

var_0_21.RESOURCE_FILENAME = "sky_scraper_game.json"
var_0_21.RESOURCE_BINDING = {
	panelCountDown = "panelCountDown",
	centerPanel = "centerPanel",
	["centerPanel.hook"] = "hook",
	["info.imgSm"] = "imgSm",
	bg = "bg",
	["centerPanel.basePanel"] = "basePanel",
	["rolePanel.car.txt"] = "floorTxt",
	["rolePanel.world"] = "world",
	info = "info",
	["info.score"] = {
		varname = "score",
		binds = {
			event = "text",
			idler = bindHelper.self("point")
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
				ended = bindHelper.self("onBtnDown")
			}
		}
	}
}

function var_0_21.onCreate(arg_1_0, arg_1_1)
	gGameUI.topuiManager:createView("title", arg_1_0, {
		onClose = arg_1_0:createHandler("onClose")
	}):init({
		subTitle = "SKY SCRAPER",
		title = gLanguageCsv.skyScraper
	})

	arg_1_0.activityId = arg_1_1

	arg_1_0:enableSchedule()
	arg_1_0:initLife()
	arg_1_0:initModel()
	arg_1_0:onStartCount()
end

function var_0_21.onUpdate(arg_2_0, arg_2_1)
	if arg_2_0.state ~= var_0_19.GAME_OVER then
		arg_2_0.gameTime = arg_2_0.gameTime + arg_2_1
	end

	if arg_2_0.state ~= var_0_19.READY and arg_2_0.state ~= var_0_19.GAME_OVER then
		arg_2_0.btnDown:visible(arg_2_0.state == var_0_19.MOVE)
		arg_2_0:onProcessTime(arg_2_1)
		arg_2_0:onSwing(arg_2_1)
		arg_2_0:onTopHook(arg_2_1)
		arg_2_0:onTopHouse(arg_2_1)
		arg_2_0:onFloorDown(arg_2_1)
	end
end

function var_0_21.initModel(arg_3_0)
	arg_3_0.btnDown:hide()

	arg_3_0.state = var_0_19.READY
	arg_3_0.gameTime = 0
	arg_3_0.progressTime = var_0_3
	arg_3_0.hookPos = cc.p(var_0_1[1], 1290)
	arg_3_0.hookDir = 1
	arg_3_0.houseData = {
		hookDy = -75
	}

	arg_3_0.basePanel:size(0, 0)

	if var_0_0 then
		local var_3_0 = cc.DrawNode:create()

		var_3_0:drawPoints({
			cc.p(0, 0)
		}, 1, 5, cc.c4f(1, 0, 0, 1))
		var_3_0:addTo(arg_3_0.basePanel, 10000, "testPoint")
	end

	arg_3_0.baseData = {
		nextSwingFloor = 0,
		swingDx = 0,
		swingDir = 0,
		swingFloor = 0,
		swingRootFloor = 0,
		maxBasePanelY = arg_3_0.basePanel:y() + (var_0_4 - 0.5) * var_0_2.height,
		basePanelY = arg_3_0.basePanel:y(),
		swingRangeX = {
			0,
			0
		},
		nextSwingRangeX = {
			0,
			0
		}
	}

	if var_0_0 then
		local var_3_1 = cc.DrawNode:create()

		var_3_1:drawLine(cc.p(0, arg_3_0.baseData.maxBasePanelY), cc.p(arg_3_0.centerPanel:width(), arg_3_0.baseData.maxBasePanelY), cc.c4f(1, 0, 0, 1))
		var_3_1:addTo(arg_3_0.centerPanel, 100, "testLineMax")
	end

	arg_3_0.hook:xy(arg_3_0.hookPos)

	arg_3_0.point = idler.new(0)
	arg_3_0.floor = idler.new(0)
	arg_3_0.curPagePro = idler.new(0)
	arg_3_0.hookSpeed = idler.new(1)
	arg_3_0.myLife = idler.new(3)
	arg_3_0.perfectNum = 0
	arg_3_0.highpoint = (gGameModel.role:read("yyhuodongs")[arg_3_0.activityId] or {}).info.high_points or 0

	local var_3_2 = csv.yunying.yyhuodong[arg_3_0.activityId]

	arg_3_0.floorCfg = {}
	arg_3_0.awardFloor = {}

	local var_3_3 = 0
	local var_3_4 = 1

	for iter_3_0, iter_3_1 in orderCsvPairs(csv.yunying.skyscraper_floors) do
		if iter_3_1.huodongID == var_3_2.huodongID then
			if iter_3_1.range[1] then
				for iter_3_2 = var_3_3, iter_3_1.range[1] - 1 do
					arg_3_0.floorCfg[iter_3_2] = {
						hookSpeed = var_3_4
					}
				end

				var_3_3 = iter_3_1.range[1]
			end

			if iter_3_1.range[2] then
				for iter_3_3 = var_3_3, iter_3_1.range[2] do
					arg_3_0.floorCfg[iter_3_3] = {
						hookSpeed = iter_3_1.hookSpeed
					}
				end

				if csvSize(iter_3_1.awards) > 0 then
					local var_3_5 = math.random(iter_3_1.range[1], iter_3_1.range[2] - 1)

					arg_3_0.awardFloor[var_3_5] = {
						res = iter_3_1.awardsIcon
					}
				end
			end
		end
	end

	arg_3_0.accessmentCfg = {}

	for iter_3_4, iter_3_5 in orderCsvPairs(csv.yunying.skyscraper_accessment) do
		if iter_3_5.huodongID == var_3_2.huodongID then
			table.insert(arg_3_0.accessmentCfg, iter_3_5)
		end
	end

	table.sort(arg_3_0.accessmentCfg, function(arg_4_0, arg_4_1)
		return arg_4_0.contactRange > arg_4_1.contactRange
	end)
	idlereasy.when(arg_3_0.myLife, function(arg_5_0, arg_5_1)
		for iter_5_0 = arg_5_1 + 1, 3 do
			if arg_3_0.tImgSm[iter_5_0] then
				arg_3_0.tImgSm[iter_5_0]:texture("activity/sky_scraper/icon_mjh.png")
			end
		end

		if arg_5_1 == 0 then
			arg_3_0:onGameOver()
		end
	end)
	idlereasy.when(arg_3_0.floor, function(arg_6_0, arg_6_1)
		arg_3_0.floorTxt:text(arg_6_1 .. gLanguageCsv.skyScraperFloor)

		if arg_6_1 >= var_3_2.paramMap.maxFloor then
			arg_3_0:onGameOver()

			return
		end

		if arg_6_1 > 0 then
			arg_3_0.baseData.basePanelY = math.min(arg_3_0.baseData.basePanelY, arg_3_0.baseData.maxBasePanelY - (arg_6_1 - math.max(1, arg_3_0.baseData.swingRootFloor) + 0.5) * var_0_2.height)
		end

		if var_0_0 then
			arg_3_0.centerPanel:removeChildByName("testLine")

			local var_6_0 = cc.DrawNode:create()

			var_6_0:drawLine(cc.p(0, arg_3_0.baseData.basePanelY), cc.p(arg_3_0.centerPanel:width(), arg_3_0.baseData.basePanelY), cc.c4f(0, 1, 0, 1))
			var_6_0:addTo(arg_3_0.centerPanel, 100, "testLine")
		end

		if arg_6_1 >= var_0_5 then
			arg_3_0.baseData.nextSwingFloor = arg_6_1
			arg_3_0.baseData.nextSwingRangeX = arg_3_0:calculateSwing()
		end

		arg_3_0.hookSpeed:set(arg_3_0.floorCfg[arg_6_1].hookSpeed)

		if arg_3_0.awardFloor[arg_6_1] then
			local var_6_1 = arg_3_0.basePanel:get("house" .. arg_6_1)

			cc.Sprite:create(arg_3_0.awardFloor[arg_6_1].res):anchorPoint(0.5, 0):xy(var_0_2.width / 2, var_0_2.height):addTo(var_6_1, 2, "award")
		end
	end)
end

function var_0_21.calculateSwing(arg_7_0)
	local var_7_0 = arg_7_0.floor:read()
	local var_7_1 = 0
	local var_7_2 = math.max(2, var_7_0 - var_0_7 + 1)
	local var_7_3 = var_7_0 - var_7_2 + 1
	local var_7_4 = 0

	for iter_7_0 = var_7_0, var_7_2, -1 do
		var_7_4 = var_7_4 + 1
		var_7_1 = var_7_1 + math.abs(arg_7_0.floorCfg[iter_7_0].calcRange) * (var_0_10[var_7_4] or 1)
		var_7_3 = var_7_3 + (var_0_10[var_7_4] or 1) - 1
	end

	local var_7_5 = var_7_1 / var_7_3
	local var_7_6 = math.min(var_0_12, (100 - var_7_5) / 100 * var_0_11)
	local var_7_7 = -var_7_6

	if arg_7_0.basePanel:get("house" .. var_7_0):x() > 0 then
		var_7_7 = var_7_7 * var_0_9
	else
		var_7_6 = var_7_6 * var_0_9
	end

	if var_0_0 then
		printInfo("平均接触面积(%s), 晃动范围[%s, %s]", var_7_5, var_7_7, var_7_6)
	end

	return {
		var_7_7,
		var_7_6
	}
end

function var_0_21.onStartCount(arg_8_0)
	local var_8_0 = csv.yunying.yyhuodong[arg_8_0.activityId]

	arg_8_0.panelCountDown:show()

	local var_8_1 = 3
	local var_8_2 = arg_8_0.panelCountDown:get("textNum")

	var_8_2:text(var_8_1)
	adapt.oneLineCenterPos(cc.p(arg_8_0.panelCountDown:width() / 2, arg_8_0.panelCountDown:height() / 2), {
		arg_8_0.panelCountDown:get("textNote"),
		arg_8_0.panelCountDown:get("textNum")
	})
	arg_8_0:schedule(function(arg_9_0)
		if var_8_1 > 0 then
			local var_9_0 = var_8_2

			var_8_2:text(var_8_1)
			var_8_2:scale(1.3)
			var_8_2:runAction(cc.ScaleTo:create(0.5, 1))
			adapt.oneLineCenterPos(cc.p(arg_8_0.panelCountDown:width() / 2, arg_8_0.panelCountDown:height() / 2), {
				arg_8_0.panelCountDown:get("textNote"),
				arg_8_0.panelCountDown:get("textNum")
			})

			var_8_1 = var_8_1 - 1
		else
			arg_8_0:onGameStart()

			return false
		end
	end, 1, 0, 663)
end

function var_0_21.onGameStart(arg_10_0)
	arg_10_0.panelCountDown:hide()

	arg_10_0.state = var_0_19.MOVE
end

function var_0_21.initLife(arg_11_0)
	local var_11_0 = arg_11_0.imgSm

	arg_11_0.tImgSm = {
		arg_11_0.imgSm
	}

	for iter_11_0 = 2, 3 do
		local var_11_1 = var_11_0:clone():addTo(var_11_0:getParent()):xy(var_11_0:x() + 140 * (iter_11_0 - 1), var_11_0:y())

		table.insert(arg_11_0.tImgSm, var_11_1)
	end
end

function var_0_21.onProcessTime(arg_12_0, arg_12_1)
	if arg_12_0.state == var_0_19.MOVE then
		arg_12_0.progressTime = math.max(arg_12_0.progressTime - arg_12_1, 0)

		arg_12_0.curPagePro:set(100 * arg_12_0.progressTime / var_0_3)

		if arg_12_0.progressTime <= 0 then
			arg_12_0.state = var_0_19.DROP
		end
	end
end

function var_0_21.onSwing(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_1 * (arg_13_0.baseData.swingRangeX[2] - arg_13_0.baseData.swingRangeX[1]) / var_0_17
	local var_13_1 = arg_13_0.baseData.swingDx

	if arg_13_0.baseData.swingDir ~= 0 then
		local var_13_2 = var_13_0 % (arg_13_0.baseData.swingRangeX[2] - arg_13_0.baseData.swingRangeX[1])

		arg_13_0.baseData.swingDx = arg_13_0.baseData.swingDx + arg_13_0.baseData.swingDir * var_13_2

		local function var_13_3()
			if arg_13_0.baseData.swingDir == 1 then
				if arg_13_0.baseData.swingDx > arg_13_0.baseData.swingRangeX[2] then
					arg_13_0.baseData.swingDx = arg_13_0.baseData.swingRangeX[2] - (arg_13_0.baseData.swingDx - arg_13_0.baseData.swingRangeX[2])
					arg_13_0.baseData.swingDir = -1
				end
			elseif arg_13_0.baseData.swingDx < arg_13_0.baseData.swingRangeX[1] then
				arg_13_0.baseData.swingDx = arg_13_0.baseData.swingRangeX[1] - (arg_13_0.baseData.swingDx - arg_13_0.baseData.swingRangeX[1])
				arg_13_0.baseData.swingDir = 1
			end
		end

		var_13_3()
		var_13_3()
	end

	if arg_13_0.baseData.nextSwingFloor > arg_13_0.baseData.swingFloor and arg_13_0.baseData.swingDx * var_13_1 <= 0 then
		arg_13_0.baseData.swingFloor = arg_13_0.baseData.nextSwingFloor
		arg_13_0.baseData.swingRangeX = arg_13_0.baseData.nextSwingRangeX

		local var_13_4 = math.max(1, arg_13_0.baseData.swingFloor - var_0_6 + 1)

		if var_13_4 > arg_13_0.baseData.swingRootFloor then
			arg_13_0.basePanel:rotate(0)

			arg_13_0.baseData.swingRootFloor = var_13_4

			local var_13_5, var_13_6 = arg_13_0.basePanel:get("house" .. arg_13_0.baseData.swingRootFloor):xy()

			arg_13_0.basePanel:xy(arg_13_0.basePanel:x() + var_13_5, arg_13_0.basePanel:y() + var_13_6)

			for iter_13_0 = arg_13_0.baseData.swingFloor, arg_13_0.baseData.swingRootFloor, -1 do
				local var_13_7 = arg_13_0.basePanel:get("house" .. iter_13_0)

				var_13_7:xy(var_13_7:x() - var_13_5, var_13_7:y() - var_13_6)
			end

			for iter_13_1 = arg_13_0.baseData.swingRootFloor - 1, 1, -1 do
				local var_13_8 = arg_13_0.basePanel:get("house" .. iter_13_1)

				if not var_13_8 then
					break
				end

				var_13_8:removeFromParent()
			end
		end

		arg_13_0.baseData.basePanelY = arg_13_0.baseData.maxBasePanelY - (arg_13_0.floor:read() - math.max(1, arg_13_0.baseData.swingRootFloor) + 0.5) * var_0_2.height

		local var_13_9 = arg_13_0.baseData.swingRangeX[2] - arg_13_0.baseData.swingRangeX[1]

		if math.abs(var_13_9) < var_0_13 * 2 then
			arg_13_0.baseData.swingDir = 0
			arg_13_0.baseData.swingDx = 0
		elseif arg_13_0.baseData.swingDir == 0 then
			if arg_13_0.basePanel:get("house" .. arg_13_0.floor:read()):x() > 0 then
				arg_13_0.baseData.swingDir = 1
			else
				arg_13_0.baseData.swingDir = -1
			end
		end

		if var_0_0 then
			arg_13_0.centerPanel:removeChildByName("testLine")

			local var_13_10 = cc.DrawNode:create()

			var_13_10:drawLine(cc.p(0, arg_13_0.baseData.basePanelY), cc.p(arg_13_0.centerPanel:width(), arg_13_0.baseData.basePanelY), cc.c4f(0, 1, 0, 1))
			var_13_10:addTo(arg_13_0.centerPanel, 100, "testLine")
		end
	end

	arg_13_0.basePanel:rotate(math.deg(math.atan(arg_13_0.baseData.swingDx / (arg_13_0.baseData.maxBasePanelY - arg_13_0.basePanel:y()))))
end

function var_0_21.onTopHook(arg_15_0, arg_15_1)
	local var_15_0 = var_0_1[2] - var_0_1[1]
	local var_15_1 = arg_15_1 * arg_15_0.hookSpeed:read() * var_15_0 / 2 % (var_15_0 * 2)

	if arg_15_0.hookDir == 1 then
		arg_15_0.hookPos.x = arg_15_0.hookPos.x + var_15_1
	else
		arg_15_0.hookPos.x = arg_15_0.hookPos.x - var_15_1
	end

	local function var_15_2()
		if arg_15_0.hookDir == 1 then
			if arg_15_0.hookPos.x > var_0_1[2] then
				arg_15_0.hookPos.x = var_0_1[2] - (arg_15_0.hookPos.x - var_0_1[2])
				arg_15_0.hookDir = -1
			end
		elseif arg_15_0.hookPos.x < var_0_1[1] then
			arg_15_0.hookPos.x = var_0_1[1] - (arg_15_0.hookPos.x - var_0_1[1])
			arg_15_0.hookDir = 1
		end
	end

	var_15_2()
	var_15_2()
	arg_15_0.hook:x(arg_15_0.hookPos.x)

	if arg_15_0.house then
		local var_15_3 = arg_15_0.house:get("effect")
		local var_15_4 = arg_15_0.hookPos.x - var_0_1[1]
		local var_15_5 = var_0_1[2] - arg_15_0.hookPos.x
		local var_15_6 = 0.4
		local var_15_7 = var_0_18 / var_15_6
		local var_15_8 = 5

		if arg_15_0.hookDir == 1 then
			local var_15_9 = var_15_4 / var_15_0

			if var_15_9 <= var_15_6 / var_15_8 then
				var_15_3:rotate(var_15_7 * var_15_9 * var_15_8)
			elseif var_15_9 <= var_15_6 then
				var_15_3:rotate(var_15_7 * (var_15_6 - var_15_9) * var_15_8 / (var_15_8 - 1))
			else
				var_15_3:rotate(0)
			end
		else
			local var_15_10 = 1 - var_15_4 / var_15_0

			if var_15_10 <= var_15_6 / var_15_8 then
				var_15_3:rotate(-var_15_7 * var_15_10 * var_15_8)
			elseif var_15_10 <= var_15_6 then
				var_15_3:rotate(-var_15_7 * (var_15_6 - var_15_10) * var_15_8 / (var_15_8 - 1))
			else
				var_15_3:rotate(0)
			end
		end
	end
end

function var_0_21.onTopHouse(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0.floor:read()

	if arg_17_0.state == var_0_19.MOVE then
		if not arg_17_0.house then
			arg_17_0.house = ccui.Layout:create():anchorPoint(0.5, 0.5):size(var_0_2):xy(arg_17_0.hook:width() / 2, arg_17_0.houseData.hookDy):addTo(arg_17_0.hook, 1000, "house" .. var_17_0 + 1)

			local var_17_1 = math.random(1, 15)

			cc.Sprite:create("activity/sky_scraper/img_fz" .. var_17_1 .. ".png"):alignCenter(var_0_2):anchorPoint(0.5, 1):y(var_0_2.height):addTo(arg_17_0.house, 1, "effect"):scale(1.25)
		end
	elseif arg_17_0.state == var_0_19.DROP then
		if arg_17_0.house then
			local var_17_2 = arg_17_0.house

			arg_17_0.house = nil

			var_17_2:retain()

			local var_17_3 = gGameUI:getConvertPos(var_17_2, arg_17_0.centerPanel)

			var_17_2:removeFromParent()
			var_17_2:addTo(arg_17_0.centerPanel, arg_17_0.hook:z() + 1):xy(var_17_3)
			var_17_2:release()

			arg_17_0.houseData.obj = var_17_2
			arg_17_0.houseData.x = var_17_3.x
			arg_17_0.houseData.y = var_17_3.y
			arg_17_0.houseData.calcRange = nil
			arg_17_0.houseTime = 0.1
			arg_17_0.houseDir = arg_17_0.hookDir

			var_17_2:get("effect"):runAction(cc.EaseBackInOut:create(cc.RotateTo:create(1, 0)))
		end

		local var_17_4 = arg_17_0.houseDir * arg_17_1 * 200 * arg_17_0.hookSpeed:read()
		local var_17_5 = 0.1 * var_0_14 * (math.pow(arg_17_0.houseTime + arg_17_1, 2) * math.pow(arg_17_0.houseTime, 2))

		arg_17_0.houseTime = arg_17_0.houseTime + arg_17_1

		local var_17_6 = arg_17_0.houseData.obj

		if not arg_17_0.houseData.calcRange then
			local var_17_7

			if var_17_0 > 0 then
				local var_17_8 = arg_17_0.basePanel:get("house" .. var_17_0)
				local var_17_9, var_17_10 = var_17_8:xy()
				local var_17_11 = var_17_10 + var_0_2.height / 2
				local var_17_12 = var_17_8:parent():convertToWorldSpace(cc.p(var_17_9, var_17_11))

				var_17_7 = arg_17_0.centerPanel:convertToNodeSpace(var_17_12)
			else
				var_17_7 = cc.p(arg_17_0.houseData.x, arg_17_0.basePanel:y() - var_0_2.height / 2)
			end

			local var_17_13 = arg_17_0.houseData.y - var_0_2.height / 2 - var_17_7.y

			if var_17_13 <= var_17_5 then
				local var_17_14 = arg_17_0.houseData.x + var_17_4 * var_17_13 / math.abs(var_17_5)
				local var_17_15 = var_17_14 >= var_17_7.x and 1 or -1
				local var_17_16 = math.max(0, var_0_2.width - math.abs(var_17_14 - var_17_7.x))

				arg_17_0.houseData.calcRange = var_17_15 * var_17_16 * 100 / var_0_2.width

				if arg_17_0:calculateIsContact() then
					local var_17_17 = cc.p(var_17_14, arg_17_0.houseData.y - var_17_13)

					if var_17_0 > 0 then
						var_17_17 = cc.p(var_17_7.x + var_17_15 * (var_0_2.width - var_17_16), var_17_7.y + var_0_2.height / 2)
					end

					local var_17_18 = arg_17_0.centerPanel:convertToWorldSpace(var_17_17)
					local var_17_19 = arg_17_0.basePanel:convertToNodeSpace(var_17_18)

					if var_17_0 > 0 then
						var_17_19.y = (var_17_0 + 1 - math.max(1, arg_17_0.baseData.swingRootFloor)) * var_0_2.height
					end

					var_17_6:get("effect"):rotate(0)
					var_17_6:retain()
					var_17_6:removeFromParent()
					var_17_6:addTo(arg_17_0.basePanel):xy(var_17_19)
					var_17_6:release()

					local var_17_20 = arg_17_0.basePanel:get("house" .. var_17_0)

					if var_17_20 and var_17_20:get("award") then
						var_17_20:get("award"):hide()
					end

					arg_17_0.floorCfg[var_17_0 + 1].calcRange = arg_17_0.houseData.calcRange
					arg_17_0.state = var_0_19.MOVE
					arg_17_0.progressTime = var_0_3

					arg_17_0.floor:modify(function(arg_18_0)
						return true, arg_18_0 + 1
					end)

					return true
				end
			end
		end

		arg_17_0.houseData.y = arg_17_0.houseData.y - var_17_5

		var_17_6:y(arg_17_0.houseData.y)

		arg_17_0.houseData.x = arg_17_0.houseData.x + var_17_4

		var_17_6:x(arg_17_0.houseData.x)

		if arg_17_0.houseData.y < -var_0_2.height / 2 then
			var_17_6:removeFromParent()

			arg_17_0.state = var_0_19.MOVE
			arg_17_0.progressTime = var_0_3
		end
	end
end

function var_0_21.onFloorDown(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0.basePanel:y()

	if var_19_0 > arg_19_0.baseData.basePanelY then
		local var_19_1 = arg_19_1 * var_0_15
		local var_19_2 = math.max(arg_19_0.baseData.basePanelY, var_19_0 - var_19_1)

		arg_19_0.basePanel:y(var_19_2)
	end
end

function var_0_21.onBtnDown(arg_20_0)
	if arg_20_0.state == var_0_19.MOVE then
		arg_20_0.state = var_0_19.DROP
	end
end

function var_0_21.calculateIsContact(arg_21_0)
	if arg_21_0.floor:read() == 0 then
		return true
	end

	local var_21_0 = math.abs(arg_21_0.houseData.calcRange)

	for iter_21_0, iter_21_1 in ipairs(arg_21_0.accessmentCfg) do
		if var_21_0 >= iter_21_1.contactRange then
			if iter_21_1.type == 3 then
				arg_21_0.perfectNum = arg_21_0.perfectNum + 1
			end

			arg_21_0.point:modify(function(arg_22_0)
				return true, arg_22_0 + iter_21_1.points
			end)

			return true
		end
	end

	arg_21_0.myLife:modify(function(arg_23_0)
		return true, arg_23_0 - 1
	end)

	return false
end

function var_0_21.onGameOver(arg_24_0)
	arg_24_0.state = var_0_19.GAME_OVER

	local var_24_0 = arg_24_0.floor:read()
	local var_24_1 = arg_24_0.point:read() > arg_24_0.highpoint
	local var_24_2 = {}

	for iter_24_0, iter_24_1 in pairs(arg_24_0.awardFloor) do
		if iter_24_0 < var_24_0 then
			table.insert(var_24_2, iter_24_0)
		end
	end

	gGameApp:requestServer("/game/yy/skyscraper/end", function(arg_25_0)
		gGameUI:stackUI("city.activity.sky_scraper.game_over", nil, {
			full = true
		}, arg_24_0:createHandler("onClose"), arg_24_0.activityId, arg_24_0.point:read(), arg_24_0.floor:read() + 1, var_24_1, arg_25_0)
	end, arg_24_0.activityId, arg_24_0.point:read(), var_24_0, arg_24_0.perfectNum, arg_24_0.gameTime, 1, var_24_2)
end

return var_0_21
