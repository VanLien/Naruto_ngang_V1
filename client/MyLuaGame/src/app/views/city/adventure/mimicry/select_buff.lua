local var_0_0 = {}
local var_0_1 = 4
local var_0_2 = {
	"lv",
	"lan",
	"zi",
	"cheng"
}
local var_0_3 = {
	cc.c4b(145, 225, 177, 255),
	cc.c4b(112, 161, 227, 255),
	cc.c4b(177, 135, 254, 255),
	cc.c4b(236, 183, 42, 255)
}
local var_0_4 = 10

for iter_0_0 = 1, var_0_1 do
	table.insert(var_0_0, {
		quality = iter_0_0,
		icon = string.format("city/adventure/mimicry/btn_ntdz_%s.png", var_0_2[iter_0_0]),
		log = string.format("city/adventure/mimicry/log_ntdz_%s.png", var_0_2[iter_0_0]),
		maxNumber = csv.mimicry.base[1][string.format("quality%sBuffFieldNum", iter_0_0)]
	})
end

local var_0_5 = {
	initBuffView = function(arg_1_0)
		arg_1_0.progressBarSign = idler.new(true)
		arg_1_0.progressBarData = {}

		local var_1_0 = 0

		idlereasy.when(arg_1_0.progressBarSign, function(arg_2_0, arg_2_1)
			var_1_0 = var_1_0 + 1

			performWithDelay(arg_1_0, function()
				if var_1_0 > 0 then
					local var_3_0 = 0

					for iter_3_0, iter_3_1 in pairs(arg_1_0.progressBarData) do
						for iter_3_2, iter_3_3 in pairs(iter_3_1) do
							var_3_0 = var_3_0 + iter_3_3
						end
					end

					arg_1_0:buffSchedule(var_3_0)

					var_1_0 = 0
				end
			end, 0)
		end)
		idlereasy.when(arg_1_0.battle_times, function(arg_4_0, arg_4_1)
			arg_4_1 = cc.clampf(arg_4_1, 0, arg_1_0.maxNumber)

			local var_4_0 = string.format(gLanguageCsv.mimicryBattleNumber, arg_4_1, arg_1_0.maxNumber)

			if arg_4_1 < arg_1_0.maxNumber then
				local var_4_1 = string.format(gLanguageCsv.mimicryRecoverNum, arg_1_0.recoverNumber)

				var_4_0 = var_4_0 .. var_4_1
			end

			arg_1_0.countPanel:removeAllChildren()

			local var_4_2 = rich.createByStr(var_4_0, 40):addTo(arg_1_0.countPanel, 20, "richText"):anchorPoint(cc.p(0.5, 0.5)):xy(arg_1_0.countPanel:size().width / 2, 60):formatText()

			if arg_1_0.battle then
				var_4_2:hide()
			end

			local var_4_3 = arg_4_1 <= 0 and ui.COLORS.NORMAL.RED or cc.c4b(56, 240, 115, 255)

			arg_1_0.num1:setTextColor(var_4_3)
			arg_1_0.num1:text(arg_4_1)
			arg_1_0.num2:text("/" .. arg_1_0.maxNumber .. gLanguageCsv.symbolBracketRight)
			adapt.oneLinePos(arg_1_0.txtTime1, {
				arg_1_0.num1,
				arg_1_0.num2
			}, cc.p(1, 0))
		end)
		arg_1_0.buffSeleLv:update(var_0_0)
		idlereasy.any({
			arg_1_0.buff_choice,
			arg_1_0.bossID
		}, function(arg_5_0, arg_5_1, arg_5_2)
			arg_1_0.buffsChoiceClient:set(arg_5_1[arg_5_2] or {})
		end)
		idlereasy.any({
			arg_1_0.buff_field,
			arg_1_0.buffsChoiceClient,
			arg_1_0.bossID
		}, function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
			arg_1_0.progressBarData = {}

			local var_6_0 = csv.mimicry.base[1]
			local var_6_1 = {}

			for iter_6_0, iter_6_1 in pairs(arg_6_2 or {}) do
				if arg_1_0.buffCsv[iter_6_1] then
					local var_6_2 = arg_1_0.buffCsv[iter_6_1].quality

					if not var_6_1[var_6_2] then
						var_6_1[var_6_2] = {}
					end

					table.insert(var_6_1[var_6_2], iter_6_1)

					arg_1_0.progressBarData[var_6_2] = arg_1_0.progressBarData[var_6_2] or {}

					if not arg_1_0.progressBarData[var_6_2][iter_6_1] then
						arg_1_0.progressBarData[var_6_2][iter_6_1] = arg_1_0.buffCsv[iter_6_1].level
					end
				end
			end

			arg_1_0.progressBarSign:notify()

			for iter_6_2 = 1, var_0_1 do
				local var_6_3 = 1
				local var_6_4 = var_6_0[string.format("quality%sBuffFieldNum", iter_6_2)]
				local var_6_5 = {}
				local var_6_6 = 0

				if arg_6_1[arg_6_3] then
					var_6_6 = arg_6_1[arg_6_3][iter_6_2] or 0
				end

				for iter_6_3 = 1, var_6_4 do
					table.insert(var_6_5, {
						id = var_6_1[iter_6_2] and var_6_1[iter_6_2][var_6_3],
						lock = var_6_6 < iter_6_3,
						quality = iter_6_2,
						num = var_6_1[iter_6_2] and #var_6_1[iter_6_2] or 0
					})

					var_6_3 = var_6_3 + 1
				end

				arg_1_0[string.format("buffSelectData%s", iter_6_2)]:update(var_6_5)
			end

			local var_6_7 = {}

			for iter_6_4, iter_6_5 in pairs(arg_6_2) do
				var_6_7[iter_6_5] = iter_6_4
			end

			arg_1_0.buffSelectSever = var_6_7

			arg_1_0.txtBuffNum:text(string.format("%s/%s", itertools.size(arg_6_2), arg_1_0.allBuffSlot))
			arg_1_0.bossName:text(csv.mimicry.boss[arg_6_3].gateName)
		end)
		arg_1_0:maxQualitybuffShow()
		idlereasy.any({
			arg_1_0.bossID,
			arg_1_0.buffQuality
		}, function(arg_7_0, arg_7_1, arg_7_2)
			dataEasy.tryCallFunc(arg_1_0.buffList, "filterSortItems")

			local var_7_0 = false

			for iter_7_0, iter_7_1 in arg_1_0.buffDatas:ipairs() do
				local var_7_1 = iter_7_1:read().bossID

				if arg_1_0.buffQuality:read() == iter_7_1:read().quality and (not var_7_1 or var_7_1 == 0) then
					var_7_0 = true

					break
				end
			end

			arg_1_0.panelNobuff:setVisible(not var_7_0)
			arg_1_0.buffShow:set(0)
		end)
		idlereasy.when(arg_1_0.buffShow, function(arg_8_0, arg_8_1)
			local var_8_0 = arg_1_0.buffCsv[arg_8_1]
			local var_8_1 = arg_1_0.buffLeftPanel:get("buffDescPanel")

			var_8_1:setVisible(arg_8_1 and arg_8_1 ~= 0)

			local var_8_2 = not arg_8_1 or arg_8_1 == 0 or not var_8_0

			var_8_1:setVisible(not var_8_2)
			arg_1_0.buffLeftPanel:get("txtNo"):setVisible(var_8_2)

			if var_8_2 then
				return
			end

			var_8_1:get("buffName"):text(var_8_0.name)
			var_8_1:get("buffName"):setTextColor(var_0_3[var_8_0.quality])
			var_8_1:get("buffIcon"):texture(var_8_0.icon1)
			var_8_1:get("buffPoint"):text(var_8_0.basicScores)
			var_8_1:get("buffLevel"):text(var_8_0.level)
			adapt.oneLinePos(var_8_1:get("txt1"), var_8_1:get("buffPoint"))
			adapt.oneLinePos(var_8_1:get("txt2"), var_8_1:get("buffLevel"))
			var_8_1:get("buffDesc"):removeAllChildren()
			beauty.textScroll({
				isRich = true,
				list = var_8_1:get("buffDesc"),
				strs = "#C0xFFFCED#" .. var_8_0.desc
			})
		end)
	end,
	maxQualitybuffShow = function(arg_9_0)
		local var_9_0 = arg_9_0.buffs:read()
		local var_9_1 = userDefault.getForeverLocalKey("mimicryRoleBuff", nil)
		local var_9_2 = userDefault.getForeverLocalKey("mimicryNewBuffs", nil) or {}
		local var_9_3 = {}
		local var_9_4 = {}
		local var_9_5 = {}
		local var_9_6 = false
		local var_9_7 = false
		local var_9_8 = 1

		for iter_9_0, iter_9_1 in ipairs(var_9_0 or {}) do
			local var_9_9 = {}

			for iter_9_2, iter_9_3 in pairs(arg_9_0.buffCsv[iter_9_1]) do
				var_9_9[iter_9_2] = iter_9_3
			end

			var_9_9.isNew = not var_9_2[iter_9_1]
			var_9_9.key = iter_9_0

			table.insert(var_9_3, var_9_9)

			var_9_4[iter_9_1] = true

			if var_9_1 and not var_9_1[iter_9_1] or not var_9_1 then
				var_9_7 = true
				var_9_8 = math.max(var_9_9.quality, var_9_8)

				if arg_9_0.buffCsv[iter_9_1].tips ~= 0 then
					table.insert(var_9_5, arg_9_0.buffCsv[iter_9_1])

					var_9_6 = true
				end
			end
		end

		userDefault.setForeverLocalKey("mimicryRoleBuff", var_9_4)

		local function var_9_10()
			local var_10_0 = 4

			if not gGameUI.guideManagerLocal:checkFinished(var_10_0) then
				performWithDelay(arg_9_0, function()
					gGameUI.guideManagerLocal:checkGuide({
						specialName = "mimicryNewBuff"
					})
				end, 0.2)
			end
		end

		arg_9_0.buffDatas:update(var_9_3)

		if not var_9_1 or var_9_6 then
			if var_9_6 and arg_9_0.battle then
				performWithDelay(arg_9_0, function()
					gGameUI:stackUI("city.adventure.mimicry.buff_show", nil, nil, {
						showBuffData = var_9_5,
						cb = var_9_10
					})
				end, 0)
			elseif var_9_7 and arg_9_0.battle then
				var_9_10()
			end
		elseif var_9_7 and arg_9_0.battle then
			var_9_10()
		end

		arg_9_0.buffQuality:set(var_9_8)

		local var_9_11 = arg_9_0.showTab:read()
		local var_9_12 = arg_9_0.bossData:at(var_9_11):read().csvId

		arg_9_0.describe:get("score"):text(arg_9_0.total_scores:read()[var_9_12] or 0)
		arg_9_0.describe:get("max"):text(arg_9_0.history_scores:read()[var_9_12] or 0)
		adapt.oneLinePos(arg_9_0.describe:get("maxTitle"), arg_9_0.describe:get("max"), cc.p(2, 0))
		adapt.oneLinePos(arg_9_0.describe:get("scoreTitle"), arg_9_0.describe:get("score"), cc.p(2, 0))
	end,
	buffSchedule = function(arg_13_0, arg_13_1)
		local var_13_0 = arg_13_0.buff_field:read()
		local var_13_1 = 0

		for iter_13_0, iter_13_1 in ipairs(var_13_0[arg_13_0.bossID:read()] or {}) do
			if iter_13_1 > 0 then
				for iter_13_2 = 1, iter_13_1 do
					var_13_1 = var_13_1 + gMimicryBuffsCsv[iter_13_0][iter_13_2]
				end
			end
		end

		local var_13_2 = 900 * (var_13_1 == 0 and 0 or arg_13_1 / var_13_1)

		arg_13_0.bg:get("panel.mask"):width(var_13_2)
		arg_13_0.bg:get("panel.lv"):text(gLanguageCsv.textLv .. arg_13_1)
	end,
	changeBuffQuality = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
		arg_14_0.buffQuality:set(arg_14_2)
	end,
	onMarkerClick = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
		local var_15_0 = arg_15_0[string.format("buffSelectData%s", arg_15_3.quality)]

		for iter_15_0, iter_15_1 in var_15_0.ipairs(var_15_0) do
			if iter_15_1.read(iter_15_1).id == arg_15_3.id then
				arg_15_0.buffSelectSever[arg_15_3.id] = nil
				arg_15_0.upBuff = false

				local var_15_1 = itertools.keys(arg_15_0.buffSelectSever)

				arg_15_0.buffsChoiceClient:set(var_15_1)
				arg_15_0:onBuffClick(arg_15_1, arg_15_2, arg_15_3)

				return
			end
		end

		for iter_15_2, iter_15_3 in var_15_0.ipairs(var_15_0) do
			if iter_15_3.read(iter_15_3).lock then
				break
			end

			if not iter_15_3.read(iter_15_3).id then
				arg_15_0.upBuff = true

				local var_15_2 = itertools.keys(arg_15_0.buffSelectSever)

				table.insert(var_15_2, arg_15_3.id)
				arg_15_0.buffsChoiceClient:set(var_15_2)
				arg_15_0:onBuffClick(arg_15_1, arg_15_2, arg_15_3)

				return
			end
		end

		local var_15_3 = arg_15_0.total_scores:read()[arg_15_0.bossID:read()]
		local var_15_4

		for iter_15_4, iter_15_5 in orderCsvPairs(csv.mimicry.buff_field) do
			if arg_15_3.quality == iter_15_5.quality and iter_15_5.scoresCondition > (var_15_3 or 0) then
				var_15_4 = var_15_4 and math.min(iter_15_5.scoresCondition, var_15_4) or iter_15_5.scoresCondition
			end
		end

		if var_15_4 then
			gGameUI:showTip(string.format(gLanguageCsv.mimicryBuffUnlockTip, tostring(var_15_4)))
		else
			gGameUI:showTip(gLanguageCsv.mimicryBuffNumMax)
		end
	end,
	onBuffClick = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
		arg_16_0.buffShow:set(arg_16_3.id)

		local var_16_0 = {
			[arg_16_3.id] = true
		}

		arg_16_0.buffDatas:atproxy(arg_16_3.key).isNew = false

		userDefault.setForeverLocalKey("mimicryNewBuffs", var_16_0)
	end,
	onFilterBuffs = function(arg_17_0, arg_17_1)
		local var_17_0 = arg_17_0.buffQuality:read()

		return function(arg_18_0, arg_18_1)
			if arg_18_1.bossID and arg_18_1.bossID ~= 0 and arg_18_1.bossID ~= arg_17_0.bossID:read() then
				return false
			end

			return arg_18_1.quality == var_17_0, arg_18_0
		end
	end,
	onSortBuffs = function(arg_19_0, arg_19_1)
		return function(arg_20_0, arg_20_1)
			if arg_20_0.isNew == arg_20_1.isNew then
				return arg_20_0.id < arg_20_1.id
			end

			return arg_20_0.isNew
		end
	end,
	onBuffLvListItem = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
		idlereasy.any({
			arg_21_0.buffsChoiceClient,
			arg_21_0.bossID,
			arg_21_0.buffDatas
		}, function(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
			if arg_21_0.date.round == "start" then
				local var_22_0 = 0
				local var_22_1 = 0

				for iter_22_0, iter_22_1 in pairs(arg_22_1 or {}) do
					if arg_21_0.buffCsv[iter_22_1] and arg_21_0.buffCsv[iter_22_1].quality == arg_21_5.quality then
						var_22_1 = var_22_1 + 1
					end
				end

				for iter_22_2, iter_22_3 in arg_21_0.buffDatas:ipairs() do
					if iter_22_3:read().quality == arg_21_5.quality and (not iter_22_3:read().bossID or iter_22_3:read().bossID == 0) then
						var_22_0 = var_22_0 + 1
					end
				end

				arg_21_3:get("buffLvTxt"):text(string.format("%s/%s", tostring(var_22_1), tostring(var_22_0)))
			end
		end):anonyOnly(arg_21_2, arg_21_4)
		idlereasy.when(arg_21_0.buffQuality, function(arg_23_0, arg_23_1)
			if arg_21_0.date.round == "start" then
				arg_21_3:get("iconSelect"):setVisible(arg_23_1 == arg_21_5.quality)
			end
		end):anonyOnly(arg_21_2, arg_21_4)

		local function var_21_0(arg_24_0)
			arg_21_0.buffQuality:set(arg_24_0)
		end

		arg_21_3:get("buffLvIcon"):texture(arg_21_5.icon)
		bind.touch(arg_21_2, arg_21_3, {
			methods = {
				ended = functools.partial(var_21_0, arg_21_4)
			}
		})
	end,
	onBuffSelectCell = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
		local var_25_0 = ""

		if arg_25_5.lock or not arg_25_5.id then
			var_25_0 = "city/adventure/mimicry/log_ntdz_hui.png"
		else
			var_25_0 = var_0_0[arg_25_5.quality].log

			if arg_25_4 == arg_25_5.num and arg_25_0.upBuff and arg_25_0.buffQuality:read() == arg_25_5.quality then
				arg_25_0.upBuff = false

				widget.addAnimation(arg_25_3, "mimicry/dxfk.skel", "dxfk", 20):xy(arg_25_3:size().width / 2, arg_25_3:size().height / 2):scale(2)
			end
		end

		arg_25_3:get("rightBuffIcon"):texture(var_25_0)
		arg_25_3:get("lock"):scale(0.28)
		arg_25_3:get("lock"):visible(arg_25_5.lock)
	end,
	requestForTest = function(arg_26_0, arg_26_1, arg_26_2)
		local var_26_0 = tonumber(arg_26_0.battleNum) or 1
		local var_26_1, var_26_2 = arg_26_0:getTestData()
		local var_26_3 = {}

		local function var_26_4(arg_27_0)
			battleEntrance.battleRequest("/game/mimicry/battle/start", arg_26_0.bossID:read(), arg_26_1, arg_26_2, 1):onStartOK(function(arg_28_0)
				return
			end):onResult(function(arg_29_0, arg_29_1)
				local var_29_0 = arg_29_1.serverData.view
				local var_29_1 = var_29_0.boss_scores or 0
				local var_29_2 = var_29_0.buff_scores or 0
				local var_29_3 = var_29_1 + var_29_2

				var_26_3[arg_27_0] = {
					bossScores = var_29_1,
					buffScores = var_29_2,
					sum = var_29_3,
					buff = var_26_1[arg_27_0]
				}

				if arg_27_0 < var_26_0 then
					gGameApp:requestServer("/game/mimicry/deploy/buff", function()
						requestServerFun(arg_27_0 + 1)
					end, arg_26_0.bossID:read(), var_26_2[arg_27_0 + 1])
				else
					local var_29_4 = 0
					local var_29_5 = 0
					local var_29_6 = var_26_3[1].sum
					local var_29_7 = 0
					local var_29_8 = 0

					for iter_29_0, iter_29_1 in ipairs(var_26_3) do
						var_29_8 = var_29_8 + iter_29_1.sum
						var_29_4 = math.max(var_29_4, iter_29_1.sum)
						var_29_5 = var_29_4 > iter_29_1.sum and var_29_5 or iter_29_0
						var_29_6 = math.min(var_29_6, iter_29_1.sum)
						var_29_7 = var_29_6 < iter_29_1.sum and var_29_7 or iter_29_0

						print("-----------------------------------------------------------------------------------------")
						print(string.format("第%s次挑战", iter_29_0))
						print(string.format("boss分数：%s ", iter_29_1.bossScores))
						print(string.format("buff分数：%s ", iter_29_1.buffScores))
						print(string.format("总分数：%s ", iter_29_1.sum))
						print("使用buff")
						print_r(iter_29_1.buff)
					end

					print("-----------------------------------------------------------------------------------------")
					print(string.format("最高分为%s,第%s次挑战", var_29_4, var_29_5))
					print(string.format("最低分为%s,第%s次挑战", var_29_6, var_29_7))
					print(string.format("平均分为%s", var_29_8 / #var_26_3))

					return false
				end
			end):run()
		end

		gGameApp:requestServer("/game/mimicry/deploy/buff", function()
			var_26_4(1)
		end, arg_26_0.bossID:read(), var_26_2[1])
	end,
	getTestData = function(arg_32_0)
		local var_32_0 = arg_32_0.battleNum or 1
		local var_32_1 = arg_32_0.buff_field:read()[arg_32_0.bossID:read()]
		local var_32_2 = {}
		local var_32_3 = {}

		for iter_32_0, iter_32_1 in orderCsvPairs(csv.mimicry.buffs) do
			if not var_32_3[iter_32_1.quality] then
				var_32_3[iter_32_1.quality] = {}
			end

			table.insert(var_32_3[iter_32_1.quality], iter_32_1)
		end

		local function var_32_4(arg_33_0)
			if type(arg_33_0) ~= "table" then
				return
			end

			local var_33_0 = {}
			local var_33_1 = 1

			while #arg_33_0 ~= 0 do
				local var_33_2 = math.random(1, #arg_33_0)

				if arg_33_0[var_33_2] ~= nil then
					var_33_0[var_33_1] = arg_33_0[var_33_2]

					table.remove(arg_33_0, var_33_2)

					var_33_1 = var_33_1 + 1
				end
			end

			return var_33_0
		end

		for iter_32_2 = 1, tonumber(var_32_0) or 1 do
			if not var_32_2[iter_32_2] then
				var_32_2[iter_32_2] = {}
			end

			for iter_32_3, iter_32_4 in pairs(var_32_3) do
				if not var_32_2[iter_32_2][iter_32_3] then
					var_32_2[iter_32_2][iter_32_3] = {}
				end

				local var_32_5 = clone(iter_32_4)
				local var_32_6 = var_32_4(var_32_5)
				local var_32_7 = var_32_1[iter_32_3]

				for iter_32_5, iter_32_6 in pairs(var_32_6) do
					if var_32_7 <= #var_32_2[iter_32_2][iter_32_3] then
						break
					end

					if not iter_32_6.bossID or iter_32_6.bossID == 0 or iter_32_6.bossID == arg_32_0.bossID:read() then
						table.insert(var_32_2[iter_32_2][iter_32_3], iter_32_6.id)
					end
				end
			end
		end

		local var_32_8 = {}

		for iter_32_7, iter_32_8 in ipairs(var_32_2) do
			if not var_32_8[iter_32_7] then
				var_32_8[iter_32_7] = {}
			end

			for iter_32_9, iter_32_10 in pairs(iter_32_8) do
				for iter_32_11, iter_32_12 in pairs(iter_32_10) do
					table.insert(var_32_8[iter_32_7], iter_32_12)
				end
			end
		end

		return var_32_2, var_32_8
	end,
	fightCb = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
		local var_34_0 = arg_34_2
		local var_34_1 = {}
		local var_34_2 = {}

		for iter_34_0, iter_34_1 in pairs(var_34_0) do
			if iter_34_1 then
				var_34_1[iter_34_0] = iter_34_1.card_id

				if iter_34_1.skin_id ~= 0 then
					var_34_2[iter_34_1.card_id] = iter_34_1.skin_id
				end
			end
		end

		local var_34_3 = arg_34_0.findCsvID(arg_34_0, var_34_1)

		if not arg_34_3 then
			battleEntrance.battleRequest("/game/mimicry/battle/start", arg_34_0.bossID:read(), var_34_3, var_34_2):onStartOK(function(arg_35_0)
				local var_35_0 = userDefault.getForeverLocalKey("mimicryBattleCard", {})

				var_35_0[arg_34_0.bossID:read()] = {
					cards = var_34_3,
					skins = var_34_2
				}

				userDefault.setForeverLocalKey("mimicryBattleCard", var_35_0, {
					new = true
				})

				if arg_34_1 then
					arg_34_1:onClose(false)

					arg_34_1 = nil
				end
			end):show()
		else
			local var_34_4 = {}
			local var_34_5
			local var_34_6 = arg_34_0.history_scores:read()[arg_34_0.bossID:read()] or 0
			local var_34_7 = 0
			local var_34_8 = {}

			local function var_34_9(arg_36_0)
				battleEntrance.battleRequest("/game/mimicry/battle/start", arg_34_0.bossID:read(), var_34_3, var_34_2, 1):onStartOK(function(arg_37_0)
					return
				end):onResult(function(arg_38_0, arg_38_1)
					local var_38_0 = arg_38_1.serverData.view

					table.insert(var_34_4, {
						items = var_38_0.drop,
						dailyDatas = {
							hasTitle = gLanguageCsv.mopUpNotes
						}
					})

					local var_38_1 = var_38_0.boss_scores or 0
					local var_38_2 = var_38_0.buff_scores or 0
					local var_38_3 = var_38_1 + var_38_2

					table.insert(var_34_8, {
						bossScores = var_38_1,
						buffScores = var_38_2,
						sum = var_38_3,
						newBuffs = var_38_0.new_buff
					})

					if var_38_3 > var_34_6 and var_38_3 >= var_34_7 then
						var_34_5 = arg_36_0
						var_34_7 = var_38_3
					end

					if arg_36_0 < arg_34_3 then
						requestServerFun(arg_36_0 + 1)
					else
						if arg_34_4 then
							arg_34_4()
						end

						arg_34_0:onSweepReward(var_34_4, var_34_8, var_34_5)

						return false
					end
				end):run()
			end

			if arg_34_0.testBtn and EDITOR_ENABLE then
				arg_34_0.requestForTest(arg_34_0, var_34_3, var_34_2)
			else
				var_34_9(1)
			end
		end
	end,
	onSweepReward = function(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
		local var_39_0 = arg_39_0.bossID:read()
		local var_39_1 = csv.mimicry.boss[var_39_0].gateID
		local var_39_2 = gGameModel.capture:read("limit_sprites")

		gGameUI:stackUI("city.gate.sweep", nil, nil, {
			showType = 2,
			from = "gate",
			type = "mimicry",
			hasExtra = false,
			isDouble = false,
			sweepData = arg_39_1,
			oldRoleLv = arg_39_0.roleLv:read(),
			startGateId = var_39_1,
			oldCapture = var_39_2,
			scaors = arg_39_2,
			newNum = arg_39_3,
			cb = function()
				arg_39_0:maxQualitybuffShow()
			end
		})
	end,
	onBtnBattle = function(arg_41_0, arg_41_1)
		if arg_41_0.battle_times:read() <= 0 then
			gGameUI:showTip(gLanguageCsv.todayChanllengeToMuch)

			return
		end

		local function var_41_0()
			gGameUI:stackUI("city.adventure.mimicry.embattle", nil, {
				full = true
			}, {
				from = game.EMBATTLE_FROM_TABLE.mimicry,
				fightCb = arg_41_0:createHandler("fightCb"),
				bossID = arg_41_0.bossID:read(),
				isQuick = arg_41_1,
				limitID = arg_41_0.date.bosses[arg_41_0.bossID:read()]
			})
		end

		print("======================================================")
		print(game.EMBATTLE_FROM_TABLE.mimicry, arg_41_0.bossID:read(), arg_41_1, arg_41_0.date.bosses[arg_41_0.bossID:read()])
		arg_41_0.saveBuffs(arg_41_0, var_41_0)
	end,
	onBtnReword = function(arg_43_0)
		if itertools.isempty(arg_43_0.buffsChoiceClient:read()) then
			gGameUI:showTip(gLanguageCsv.noBuffsEquip)

			return
		end

		arg_43_0.buffsChoiceClient:set({})
		gGameUI:showTip(gLanguageCsv.resetSuccess)
	end,
	onBtnBuffDesc = function(arg_44_0)
		local var_44_0 = {}

		for iter_44_0 = 1, var_0_1 do
			local var_44_1 = {}

			var_44_0[iter_44_0] = {}

			local var_44_2 = arg_44_0[string.format("buffSelectData%s", iter_44_0)]

			for iter_44_1, iter_44_2 in var_44_2.ipairs(var_44_2) do
				if iter_44_2.read(iter_44_2).id then
					table.insert(var_44_0[iter_44_0], {
						id = iter_44_2.read(iter_44_2).id
					})
				end
			end
		end

		gGameUI:stackUI("city.adventure.mimicry.mimicry_additions", nil, nil, var_44_0, arg_44_0.buff_field:read(), arg_44_0.bossID:read())
	end,
	findCsvID = function(arg_45_0, arg_45_1)
		local var_45_0 = {}

		for iter_45_0, iter_45_1 in csvMapPairs(csv.mimicry.cards) do
			for iter_45_2, iter_45_3 in pairs(arg_45_1) do
				if iter_45_3 == iter_45_1.cardID then
					var_45_0[iter_45_2] = iter_45_1.id
				end
			end
		end

		return var_45_0
	end,
	saveBuffs = function(arg_46_0, arg_46_1)
		gGameApp:requestServer("/game/mimicry/deploy/buff", function()
			if arg_46_1 then
				arg_46_1()
			end
		end, arg_46_0.bossID:read(), arg_46_0.buffsChoiceClient:read())
	end
}

return function(arg_48_0)
	for iter_48_0, iter_48_1 in pairs(var_0_5) do
		arg_48_0[iter_48_0] = iter_48_1
	end
end
