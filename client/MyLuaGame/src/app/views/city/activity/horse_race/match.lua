local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("HorseRaceMatch", var_0_0)

var_0_1.RESOURCE_FILENAME = "horse_race_match.json"
var_0_1.RESOURCE_BINDING = {
	name = "name",
	["end"] = "ended",
	ready = "ready",
	blank = "blank",
	lab = "lab",
	times = "times",
	trackBG = "trackBG",
	["times.time"] = "time",
	bet = "bet",
	go = "go",
	["lab.rate"] = "rate",
	btn = {
		varname = "btn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSkip")
			}
		}
	}
}

function var_0_1.onCreate(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	gGameUI.topuiManager:createView("city", arg_1_0):init()

	arg_1_0.leftMarge, arg_1_0.rightMarge = {
		340,
		440,
		540,
		640
	}, {
		300,
		250,
		200,
		150
	}
	arg_1_0.activityId = arg_1_1
	arg_1_0.select = arg_1_2[2]
	arg_1_0.data = arg_1_2[1]
	arg_1_0.index = arg_1_2[2]
	arg_1_0.cb = arg_1_3

	arg_1_0.time:text(0)

	if arg_1_2[3] then
		arg_1_0.btn:visible(false)
	else
		arg_1_0.btn:visible(true)
	end

	local var_1_0 = {}
	local var_1_1 = {}
	local var_1_2 = {}
	local var_1_3 = {}
	local var_1_4 = {
		"time",
		"sprint_time_slots",
		"csv_id",
		"result"
	}
	local var_1_5 = {
		"endTime",
		"crash",
		"player",
		"result"
	}

	for iter_1_0, iter_1_1 in pairs(var_1_5) do
		local var_1_6 = {}

		for iter_1_2, iter_1_3 in pairs(arg_1_0.data) do
			local var_1_7 = csv.cross.horse_race.horse_race_card[iter_1_3.csv_id]

			var_1_6[iter_1_2] = iter_1_3[var_1_4[iter_1_0]]
		end

		var_1_0[iter_1_1] = var_1_6
	end

	var_1_0.distance = csv.cross.horse_race.base[1].distance

	arg_1_0:initRes(var_1_0)
	arg_1_0:initData(var_1_0)
	arg_1_0:runAnimation(var_1_0)
end

function var_0_1.initData(arg_2_0, arg_2_1)
	local var_2_0 = csv.cross.horse_race.horse_race_card
	local var_2_1 = {}

	arg_2_0.ls = {}

	local var_2_2 = 0
	local var_2_3 = {
		0,
		0,
		0,
		0
	}

	arg_2_0.speed = {
		400,
		450,
		300,
		350
	}

	local var_2_4 = arg_2_1.crash
	local var_2_5 = {
		1,
		1,
		4,
		2
	}
	local var_2_6 = {
		1,
		1,
		1,
		1
	}
	local var_2_7 = {
		0,
		0,
		0,
		0
	}
	local var_2_8 = {
		0,
		0,
		0,
		0
	}
	local var_2_9 = arg_2_1.distance
	local var_2_10 = {
		var_2_9,
		var_2_9,
		var_2_9,
		var_2_9
	}
	local var_2_11 = {
		20,
		30,
		10,
		10
	}
	local var_2_12 = {
		10,
		10,
		10,
		10
	}
	local var_2_13 = 1
	local var_2_14 = 0
	local var_2_15 = {
		0,
		0,
		0,
		0
	}
	local var_2_16 = 1
	local var_2_17 = 0
	local var_2_18 = arg_2_1.endTime

	arg_2_0.costTime = {
		0,
		0,
		0,
		0
	}
	arg_2_0.tempValue = {
		{},
		{},
		{},
		{}
	}
	arg_2_0.secLen = {
		{},
		{},
		{},
		{}
	}

	local var_2_19 = 600
	local var_2_20 = {}
	local var_2_21 = {
		1,
		1,
		1,
		1
	}

	arg_2_0.weak = {
		{},
		{},
		{},
		{}
	}

	for iter_2_0, iter_2_1 in pairs(arg_2_1.player) do
		local var_2_22 = var_2_0[iter_2_1]

		var_2_1[iter_2_0] = var_2_22.stamina
		var_2_20[iter_2_0] = var_2_22.stamina
		arg_2_0.speed[iter_2_0] = var_2_22.speed / 10
		var_2_5[iter_2_0] = var_2_22.sprintMultiple
		var_2_11[iter_2_0] = var_2_22.staminaCost
		var_2_12[iter_2_0] = var_2_22.staminaRecovery
	end

	arg_2_0.maxTimes = math.ceil(math.max(var_2_18[1], var_2_18[2], var_2_18[3], var_2_18[4]))

	local function var_2_23()
		local var_3_0 = 1
		local var_3_1 = 0

		for iter_3_0, iter_3_1 in pairs(var_2_8) do
			if var_3_1 < iter_3_1 then
				var_3_1 = iter_3_1
				var_3_0 = iter_3_0
			end
		end

		return var_3_0
	end

	for iter_2_2 = 1, arg_2_0.maxTimes + 1 do
		for iter_2_3 = 1, 4 do
			local var_2_24 = 0

			if var_2_1[iter_2_3] < var_2_20[iter_2_3] * 0.5 and var_2_1[iter_2_3] > 0 then
				var_2_24 = -csv.cross.horse_race.base[1].sMultiple2

				table.insert(arg_2_0.weak[iter_2_3], iter_2_2)
			elseif var_2_1[iter_2_3] <= 0 then
				var_2_24 = -csv.cross.horse_race.base[1].sMultiple1

				table.insert(arg_2_0.weak[iter_2_3], iter_2_2)
			end

			for iter_2_4, iter_2_5 in pairs(var_2_4[iter_2_3] or {}) do
				if iter_2_5 == iter_2_2 then
					var_2_7[iter_2_3] = var_2_6[iter_2_3]

					break
				end
			end

			local var_2_25 = 0
			local var_2_26 = var_2_19 <= iter_2_2 and 500 or arg_2_0.speed[iter_2_3] * ((var_2_7[iter_2_3] > 0 and var_2_5[iter_2_3] or 0) + 1 + var_2_24)

			var_2_3[iter_2_3] = var_2_26

			if var_2_9 <= var_2_8[iter_2_3] + var_2_26 then
				arg_2_0.costTime[iter_2_3] = arg_2_0.costTime[iter_2_3] + (var_2_9 - var_2_8[iter_2_3]) / var_2_26
				var_2_8[iter_2_3] = var_2_9
				arg_2_0.secLen[iter_2_3][iter_2_2] = var_2_9 - (var_2_8[iter_2_3 - 1] or 0)
			else
				arg_2_0.costTime[iter_2_3] = arg_2_0.costTime[iter_2_3] + 1
				var_2_8[iter_2_3] = var_2_8[iter_2_3] + var_2_26
				arg_2_0.secLen[iter_2_3][iter_2_2] = var_2_26
			end

			var_2_7[iter_2_3] = var_2_7[iter_2_3] - 1
			var_2_10[iter_2_3] = var_2_10[iter_2_3] - arg_2_0.speed[iter_2_3]

			if var_2_15[iter_2_3] == 0 then
				var_2_1[iter_2_3] = math.max(var_2_1[iter_2_3] - var_2_11[iter_2_3], 0)
			else
				var_2_1[iter_2_3] = math.min(var_2_1[iter_2_3] + var_2_12[iter_2_3], var_2_20[iter_2_3])
			end

			if var_2_1[iter_2_3] == var_2_20[iter_2_3] then
				var_2_15[iter_2_3] = 0
			end

			if var_2_1[iter_2_3] == 0 then
				var_2_15[iter_2_3] = 1
			end

			arg_2_0.tempValue[iter_2_3][iter_2_2] = var_2_8[iter_2_3] * var_2_16
		end

		for iter_2_6 = 1, 4 do
			if arg_2_0.leftMarge[iter_2_6] + var_2_8[iter_2_6] * var_2_16 >= display.size.width * 0.618 then
				local var_2_27 = 1
			end
		end

		local var_2_28 = var_2_23()

		if var_2_28 ~= var_2_13 then
			var_2_13 = var_2_28
		end

		local var_2_29 = var_2_8[var_2_13] * var_2_16 >= display.size.width * 0.5 and 1 or 0
		local var_2_30 = (arg_2_0.secLen[var_2_13][iter_2_2] + (arg_2_0.secLen[var_2_13][iter_2_2 - 1] or 0)) / 2
		local var_2_31 = (arg_2_0.secLen[var_2_13][iter_2_2] + (arg_2_0.secLen[var_2_13][iter_2_2 + 1] or arg_2_0.secLen[var_2_13][iter_2_2])) / 2

		if var_2_29 == 1 then
			local var_2_32 = arg_2_0.maxBg:size().width - display.size.width - 600

			if var_2_32 >= var_2_8[var_2_13] * var_2_16 - display.size.width * 0.5 then
				local var_2_33 = var_2_31 * 0.4 + var_2_30 * 0.4 + arg_2_0.secLen[var_2_13][iter_2_2] * 0.2 + (arg_2_0.ls[iter_2_2 - 1] or 0)

				arg_2_0.ls[iter_2_2] = var_2_8[var_2_13] * var_2_16 - display.size.width * 0.5
			else
				arg_2_0.ls[iter_2_2] = var_2_32
			end
		end
	end
end

function var_0_1.runAnimation(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0.maxTimes
	local var_4_1 = 1
	local var_4_2 = arg_4_0.obj
	local var_4_3 = {
		0,
		0,
		0,
		0
	}
	local var_4_4 = {
		0,
		0,
		0,
		0
	}

	arg_4_0.go:runAction(cc.Sequence:create(cc.CallFunc:create(function()
		arg_4_0.ready:setVisible(true)
	end), cc.DelayTime:create(1), cc.CallFunc:create(function()
		arg_4_0.ready:setVisible(false)
		arg_4_0.go:setVisible(true)
	end), cc.DelayTime:create(1), cc.CallFunc:create(function()
		arg_4_0.go:setVisible(false)
	end)))
	arg_4_0:enableSchedule():schedule(function(arg_8_0)
		arg_4_0.time:text(math.floor(math.min(arg_4_0.maxTimes, var_4_1 - 1) / 10))

		if var_4_0 <= -2 then
			arg_4_0.ended:setVisible(true)
		end

		var_4_0 = var_4_0 - 1

		if var_4_0 > -2 then
			for iter_8_0, iter_8_1 in pairs(var_4_2) do
				if var_4_4[iter_8_0] == 0 then
					arg_4_0.animation[iter_8_0]:play("run_loop")

					var_4_4[iter_8_0] = 1
				end

				local var_8_0 = math.ceil(arg_4_0.costTime[iter_8_0]) - var_4_1

				if var_8_0 >= 0 then
					iter_8_1:runAction(cc.Sequence:create(cc.MoveTo:create((arg_4_0.costTime[iter_8_0] - var_4_1 >= 0 and 1 or arg_4_0.costTime[iter_8_0] - var_4_1 + 1) / 10, cc.p(arg_4_0.tempValue[iter_8_0][var_4_1] + arg_4_0.leftMarge[iter_8_0], iter_8_1:y()))))
					arg_4_0.icon[iter_8_0]:runAction(cc.Sequence:create(cc.MoveTo:create((var_8_0 > 0 and 1 or var_8_0 + 1) / 10, cc.p(83 + arg_4_0.tempValue[iter_8_0][var_4_1] * (670 / arg_4_1.distance), arg_4_0.icon[iter_8_0]:y()))))
					arg_4_0.animation[iter_8_0]:setTimeScale(math.min(arg_4_0.secLen[iter_8_0][var_4_1] / arg_4_0.speed[iter_8_0], 4))

					if var_4_1 < arg_4_0.maxTimes + 2 then
						for iter_8_2, iter_8_3 in pairs(arg_4_1.crash[iter_8_0] or {}) do
							if iter_8_3 == var_4_1 then
								arg_4_0.sprint[iter_8_0]:setVisible(true)

								break
							else
								arg_4_0.sprint[iter_8_0]:setVisible(false)
							end
						end

						for iter_8_4, iter_8_5 in pairs(arg_4_0.weak[iter_8_0]) do
							if iter_8_5 == var_4_1 then
								arg_4_0.weakness[iter_8_0]:setVisible(true)

								break
							else
								arg_4_0.weakness[iter_8_0]:setVisible(false)
							end
						end
					end
				end
			end

			arg_4_0.maxBg:runAction(cc.Sequence:create(cc.MoveTo:create(0.1, cc.p(arg_4_0.maxBg:size().width / 2 - (arg_4_0.ls[var_4_1] or 0), arg_4_0.maxBg:y()))))
			arg_4_0.treeBg:runAction(cc.Sequence:create(cc.MoveTo:create(0.1, cc.p(arg_4_0.montBg:size().width / 2 - (arg_4_0.ls[var_4_1] or 0) * 0.8, arg_4_0.treeBg:y()))))
			arg_4_0.montBg:runAction(cc.Sequence:create(cc.MoveTo:create(0.1, cc.p(arg_4_0.montBg:size().width / 2 - (arg_4_0.ls[var_4_1] or 0) * 0.6, arg_4_0.montBg:y()))))
			arg_4_0.could:runAction(cc.Sequence:create(cc.MoveTo:create(0.1, cc.p(arg_4_0.could:size().width / 2 - (arg_4_0.ls[var_4_1] or 0) * 0.4, arg_4_0.could:y()))))
		end

		var_4_1 = var_4_1 + 1
	end, 0.1, 2, "delayTime")

	local var_4_5 = {
		1,
		1,
		1,
		1
	}

	local function var_4_6()
		for iter_9_0, iter_9_1 in pairs(var_4_2) do
			local var_9_0 = 1

			for iter_9_2 = 1, 4 do
				if iter_9_2 ~= iter_9_0 and var_4_2[iter_9_2]:x() - arg_4_0.leftMarge[iter_9_2] > iter_9_1:x() - arg_4_0.leftMarge[iter_9_0] then
					var_9_0 = var_9_0 + 1
				end
			end

			var_4_5[iter_9_0] = var_9_0
		end
	end

	local var_4_7 = 0
	local var_4_8 = {
		0,
		0,
		0,
		0
	}

	arg_4_0:enableSchedule():schedule(function(arg_10_0)
		for iter_10_0, iter_10_1 in pairs(var_4_2) do
			var_4_8[iter_10_0] = var_4_8[iter_10_0] - 1

			if iter_10_1:x() >= arg_4_1.distance + arg_4_0.leftMarge[iter_10_0] - 10 then
				iter_10_1:get("name"):visible(true)
			elseif var_4_8[iter_10_0] < 0 then
				local var_10_0 = iter_10_1:get("name"):setVisible(false)

				var_10_0:get("tip"):visible(false)
				var_10_0:get("beyond"):visible(true)
			end

			if iter_10_1:x() >= arg_4_1.distance + arg_4_0.leftMarge[iter_10_0] - 10 and var_4_3[iter_10_0] == 0 then
				local var_10_1 = iter_10_1:get("name"):setVisible(true)

				arg_4_0.sprint[iter_10_0]:setVisible(false)
				arg_4_0.weakness[iter_10_0]:setVisible(false)
				var_10_1:get("tip"):visible(true)
				var_10_1:get("beyond"):visible(false)
				var_10_1:get("tip"):get("rank"):text(string.format(gLanguageCsv.horseRaceRecordRank, arg_4_1.result[iter_10_0]))
				arg_4_0.animation[iter_10_0]:play("win_loop")
				arg_4_0.animation[iter_10_0]:setTimeScale(1)

				var_4_3[iter_10_0] = 1
			end
		end

		for iter_10_2, iter_10_3 in pairs(var_4_2) do
			for iter_10_4, iter_10_5 in pairs(var_4_2) do
				if iter_10_4 ~= iter_10_2 and iter_10_5:x() - arg_4_0.leftMarge[iter_10_4] < iter_10_3:x() - arg_4_0.leftMarge[iter_10_2] + 10 and var_4_5[iter_10_2] > var_4_5[iter_10_4] and var_4_7 > 30 and var_4_3[iter_10_2] == 0 then
					iter_10_3:get("name"):setVisible(true)

					if var_4_8[iter_10_2] < 0 then
						transition.executeSequence(iter_10_3:get("name"):get("beyond")):fadeTo(0, 255):easeBegin("SINEOUT"):fadeTo(1, 0):easeEnd():done()
					end

					var_4_8[iter_10_2] = 10
				end
			end
		end

		var_4_6()

		var_4_7 = var_4_7 + 1
	end, 0.1, 2, "places")
	performWithDelay(arg_4_0, function()
		arg_4_0:unScheduleAll()
		arg_4_0:onSkip()
	end, math.ceil(arg_4_0.maxTimes / 10) + 4)
end

function var_0_1.initRes(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1.distance + 784 + 778

	arg_12_0.node = arg_12_0.trackBG:getParent()
	arg_12_0.maxBg = ccui.Layout:create():size(var_12_0, 720):anchorPoint(0.5, 0.5):xy(var_12_0 / 2, 735):addTo(arg_12_0.node, 5, "maxBg")
	arg_12_0.bg2 = cc.Sprite:create("activity/horse_race/qidian.png"):setScale(2):anchorPoint(0.5, 0.5):xy(592, 346):addTo(arg_12_0.maxBg, 5, "bg2")
	arg_12_0.bg1 = cc.Sprite:create("activity/horse_race/paodao_04.png"):setScaleY(2):setScaleX(arg_12_1.distance - 500):anchorPoint(0.5, 0.5):xy(var_12_0 / 2 - 150, 105):addTo(arg_12_0.maxBg, 5, "bg1")
	arg_12_0.bg3 = cc.Sprite:create("activity/horse_race/zhongdian.png"):setScale(2):anchorPoint(0.5, 0.5):xy(arg_12_1.distance + 895, 346):addTo(arg_12_0.maxBg, 5, "bg3")
	arg_12_0.bg4 = cc.Sprite:create("activity/horse_race/dimian_03.png"):setScaleY(2):setScaleX(2):anchorPoint(0.5, 0.5):xy(0, 103):addTo(arg_12_0.maxBg, 3, "bg4")
	arg_12_0.treeBg = ccui.Layout:create():size(var_12_0, 720):anchorPoint(0.5, 0.5):xy(var_12_0 / 2, 1334):addTo(arg_12_0.node, 4, "treeBg")

	local var_12_1 = 0
	local var_12_2 = 0

	while var_12_1 <= var_12_0 + 1560 do
		cc.Sprite:create("activity/horse_race/dimian_03.png"):setScaleY(2):setScaleX(2):anchorPoint(0.5, 0.5):xy(var_12_2 * 1560 * 2 - 50, 103):addTo(arg_12_0.maxBg, 3, "bg4")

		var_12_2 = var_12_2 + 1
		var_12_1 = var_12_1 + 3120 - 50
	end

	local var_12_3 = 0

	while var_12_3 <= var_12_0 do
		local var_12_4 = math.random(1, 5)
		local var_12_5 = math.random(500, 1000)
		local var_12_6 = math.random(4)
		local var_12_7 = math.random(5, 30)

		if var_12_4 > 3 then
			cc.Sprite:create("activity/horse_race/shu_0" .. var_12_6 .. ".png"):setScale(2):anchorPoint(0.5, 0.5):xy(0 + var_12_3, 230):addTo(arg_12_0.treeBg, 5, "shu" .. var_12_3)
		end

		cc.Sprite:create("activity/horse_race/caocong_0" .. var_12_6 .. ".png"):setScale(2):anchorPoint(0.5, 0.5):xy(0 + var_12_3, 0 + var_12_7):addTo(arg_12_0.treeBg, 5, "cao" .. var_12_3)

		var_12_3 = var_12_3 + var_12_5
	end

	arg_12_0.montBg = ccui.Layout:create():size(var_12_0, 720):anchorPoint(0.5, 0.5):xy(var_12_0 / 2, 1440):addTo(arg_12_0.node, 3, "montBg")

	local var_12_8 = 0
	local var_12_9 = {
		10,
		50,
		-25,
		65,
		110
	}

	while var_12_8 <= var_12_0 do
		local var_12_10 = math.random(1200, 1600)
		local var_12_11 = math.random(5)

		cc.Sprite:create("activity/horse_race/shan_0" .. var_12_11 .. ".png"):setScale(2):anchorPoint(0.5, 0.5):xy(0 + var_12_8, var_12_9[var_12_11]):addTo(arg_12_0.montBg, 5, "shan" .. var_12_8)

		var_12_8 = var_12_8 + var_12_10
	end

	arg_12_0.could = ccui.Layout:create():size(var_12_0, 720):anchorPoint(0.5, 0.5):xy(var_12_0 / 2, 1750):addTo(arg_12_0.node, 2, "could")

	local var_12_12 = 0

	while var_12_12 <= var_12_0 do
		local var_12_13 = math.random(1200, 1600)
		local var_12_14 = math.random(2)

		cc.Sprite:create("activity/horse_race/yun_0" .. var_12_14 .. ".png"):setScale(2):anchorPoint(0.5, 0.5):xy(0 + var_12_12, 0):addTo(arg_12_0.could, 5, "shan" .. var_12_12)

		var_12_12 = var_12_12 + var_12_13
	end

	arg_12_0.icon = {}
	arg_12_0.obj = {}
	arg_12_0.animation = {}
	arg_12_0.weakness = {}
	arg_12_0.sprint = {}

	local var_12_15 = {
		"standby_loop",
		"attack",
		"win_loop",
		"run_loop"
	}

	for iter_12_0, iter_12_1 in pairs(arg_12_1.player) do
		local var_12_16 = ccui.Layout:create():size(500, 800):xy(arg_12_0.leftMarge[iter_12_0], 50 + iter_12_0 * 200 - 400):anchorPoint(0.5, 0.5):setScale(1):addTo(arg_12_0.maxBg, 20 - iter_12_0, "play" .. iter_12_0)
		local var_12_17 = arg_12_0.blank:clone():addTo(var_12_16, 25):xy(0, 100):setVisible(false):alignCenter(var_12_16:size())

		widget.addAnimationByKey(var_12_17, "effect/saipao.skel", "sprint", "chongci_loop", 5):setScale(1.2):anchorPoint(cc.p(0.5, 0.5)):alignCenter(cc.size(var_12_17:size().width + 50, var_12_17:size().height - 100))

		local var_12_18 = arg_12_0.blank:clone():addTo(var_12_16, 25):xy(0, 100):setVisible(false):alignCenter(var_12_16:size())

		widget.addAnimationByKey(var_12_18, "effect/saipao.skel", "weak", "xuruo_loop", 5):setScale(2):anchorPoint(cc.p(0.5, 0.5)):alignCenter(cc.size(var_12_18:size().width - 0, var_12_18:size().height - 100))

		local var_12_19 = arg_12_0.name:clone():addTo(var_12_16, 20):xy(300, 680):setVisible(false):anchorPoint(cc.p(0.5, 0.5))

		text.addEffect(var_12_19:get("tip"):get("rank"), {
			outline = {
				size = 4,
				color = cc.c4b(218, 105, 64, 255)
			}
		})

		local var_12_20 = csv.cross.horse_race.horse_race_card[iter_12_1]
		local var_12_21 = widget.addAnimation(var_12_16, csv.unit[var_12_20.unitID].unitRes, "standby_loop", 5):anchorPoint(cc.p(0.5, 0.5)):alignCenter(var_12_16:size()):setScale(2)

		var_12_21:setSkin(csv.unit[var_12_20.unitID].skin)

		local var_12_22
		local var_12_23 = {
			-145,
			75,
			275,
			455
		}

		if iter_12_0 == arg_12_0.select then
			arg_12_0.bet:clone():addTo(arg_12_0.maxBg, 20 - iter_12_0):xy(592 + arg_12_0.leftMarge[iter_12_0] - 500, var_12_23[iter_12_0])
			arg_12_0.bet:clone():addTo(arg_12_0.maxBg, 20 - iter_12_0):xy(arg_12_1.distance + arg_12_0.leftMarge[iter_12_0] + 600 - 770, var_12_23[iter_12_0])

			var_12_22 = cc.Sprite:create("activity/horse_race/icon_horserace_select.png"):setScale(1):anchorPoint(0.5, 0.5):xy(83, 135):addTo(arg_12_0.lab, 3, "icon" .. iter_12_0)

			cc.Sprite:create(csv.unit[var_12_20.unitID].icon):setScale(1):anchorPoint(0.5, 0.5):xy(60, 80):addTo(var_12_22, 3, "icons" .. iter_12_0)
		else
			var_12_22 = cc.Sprite:create("activity/horse_race/icon_horserace_normal.png"):setScale(1):anchorPoint(0.5, 0.5):xy(83, 135):addTo(arg_12_0.lab, 3, "icon" .. iter_12_0)

			cc.Sprite:create(csv.unit[var_12_20.unitID].icon):setScale(1):anchorPoint(0.5, 0.5):xy(55, 65):addTo(var_12_22, 3, "icons" .. iter_12_0)
		end

		table.insert(arg_12_0.obj, var_12_16)
		table.insert(arg_12_0.animation, var_12_21)
		table.insert(arg_12_0.icon, var_12_22)
		table.insert(arg_12_0.weakness, var_12_18)
		table.insert(arg_12_0.sprint, var_12_17)
	end
end

function var_0_1.onSkip(arg_13_0)
	local var_13_0 = arg_13_0.activityId
	local var_13_1 = arg_13_0.data
	local var_13_2 = arg_13_0.index

	var_0_0.onClose(arg_13_0)
	gGameUI:stackUI("city.activity.horse_race.end", nil, nil, var_13_0, {
		var_13_1,
		var_13_2
	})
end

function var_0_1.onClose(arg_14_0)
	var_0_0.onClose(arg_14_0)
end

return var_0_1
