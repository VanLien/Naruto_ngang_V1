local var_0_0 = {}

local function var_0_1(arg_1_0, arg_1_1)
	local var_1_0 = matchLanguage({
		"kr"
	}) and 36 or 40
	local var_1_1 = rich.createByStr(arg_1_0, var_1_0, nil, nil, cc.p(0, 0.5)):anchorPoint(0, 0.5):addTo(arg_1_1, 6)

	var_1_1:formatText()
	var_1_1:y(var_1_1:size().height / 2)
end

local var_0_2 = {
	{
		name = "star",
		note = gLanguageCsv.manyStars
	},
	{
		name = "advance",
		note = gLanguageCsv.manyClasses
	},
	{
		name = "rarity",
		note = gLanguageCsv.manyQualifications
	}
}

local function var_0_3(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = ui.NEWCOLORS.BROWN2

	if arg_2_3 ~= 2 then
		var_2_0 = arg_2_2 and ui.NEWCOLORS.GREEN1 or ui.NEWCOLORS.RED1
	end

	text.addEffect(arg_2_0, {
		color = var_2_0
	})

	if arg_2_1 ~= "" then
		arg_2_0:text(arg_2_1)
	end
end

local function var_0_4(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_0:removeAllChildren()

	if arg_3_3 ~= 2 then
		local var_3_0 = string.format(gLanguageCsv.troopsOnTheBattlefield, arg_3_2.cardNums)

		var_0_3(arg_3_0, var_3_0, arg_3_1 >= arg_3_2.cardNums, arg_3_3)
	else
		arg_3_0:text("")

		local var_3_1 = string.format("#C0x8a5b0c#" .. gLanguageCsv.troopsOnTheBattlefield, "#C0xF41F0E#" .. arg_3_2.cardNums .. "#C0x8a5b0c#")

		var_0_1(var_3_1, arg_3_0)
	end
end

local function var_0_5(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	arg_4_0:removeAllChildren()

	local var_4_0 = var_0_2[arg_4_2.condition1].name
	local var_4_1, var_4_2 = csvNext(arg_4_2.condition1Arg)
	local var_4_3 = "#C0xF41F0E#"
	local var_4_4 = "#C0x8a5b0c#"

	if arg_4_3 ~= 2 then
		local var_4_5 = var_4_2 <= arg_4_1 and "#C0x04b508#" or "#C0xF41F0E#"

		var_4_3 = var_4_5
		var_4_4 = var_4_5
	end

	local var_4_6 = var_4_3 .. var_4_1 .. var_4_4

	if var_4_0 == "advance" then
		local var_4_7, var_4_8 = dataEasy.getQuality(var_4_1, true)

		var_4_1 = gLanguageCsv[ui.QUALITY_COLOR_TEXT[var_4_7]]
		var_4_1 = var_4_1 .. var_4_8
		var_4_6 = ui.QUALITY_OUTLINE_COLOR[var_4_7] .. var_4_1 .. var_4_4
	end

	arg_4_0:text("")

	local var_4_9
	local var_4_10 = var_0_2[arg_4_2.condition1].note

	if var_4_0 ~= "rarity" then
		local var_4_11 = string.format(var_4_10, var_4_6)

		var_4_9 = string.format(var_4_4 .. gLanguageCsv.conditionsForBattle, var_4_3 .. var_4_2 .. var_4_4, var_4_11)
	else
		local var_4_12 = string.format("#I%s-60-60#", ui.RARITY_ICON[var_4_1])

		var_4_9 = string.format(var_4_4 .. var_4_10, var_4_12, var_4_3 .. var_4_2 .. var_4_4)
	end

	var_0_1(var_4_9, arg_4_0)
end

local function var_0_6(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = 0

	arg_5_0.attrList:removeAllChildren()

	for iter_5_0, iter_5_1 in pairs(arg_5_1) do
		local var_5_1 = arg_5_2:clone():show()

		var_5_1:get("img"):visible(iter_5_1.state)
		var_5_1:get("attrIcon"):texture(ui.ATTR_ICON[iter_5_1.attr])

		local var_5_2 = (iter_5_1.state or arg_5_3.status == 2) and cc.c3b(255, 255, 255) or cc.c3b(150, 150, 150)

		var_5_1:get("attrIcon"):color(var_5_2)

		if iter_5_1.state then
			var_5_0 = var_5_0 + 1
		end

		arg_5_0.attrList:pushBackCustomItem(var_5_1)
	end

	local var_5_3 = itertools.size(arg_5_1)

	var_0_3(arg_5_0.extraCondition2, "", var_5_3 <= var_5_0, arg_5_3.status)

	local var_5_4 = arg_5_3.extraAwardPoint

	if var_5_4 == 0 then
		local var_5_5, var_5_6 = csvNext(arg_5_5.condition1Arg)

		var_5_4 = var_5_0 / var_5_3 * arg_5_5.cardNatureRate + 0.05 + (var_5_6 <= arg_5_4 and arg_5_5.rate1 or 0)
	end

	arg_5_0.gainChance:visible(arg_5_3.status ~= 2)

	local var_5_7 = math.floor(var_5_4 * 10) / 10

	var_0_3(arg_5_0.gainChance, string.format(gLanguageCsv.gainChance, var_5_7 .. "%"), var_5_7 >= 60, arg_5_3.status)
end

function var_0_0.setItemCondition(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_0:multiget("condition1", "condition2", "extraCondition1", "extraCondition2", "attrList", "gainChance")
	local var_6_1 = 0
	local var_6_2 = 0
	local var_6_3 = {}
	local var_6_4 = arg_6_1.cfg
	local var_6_5 = 0
	local var_6_6, var_6_7 = csvNext(var_6_4.condition1Arg)

	if arg_6_3 ~= "main" then
		for iter_6_0, iter_6_1 in pairs(var_6_4.cardNatures) do
			var_6_3[iter_6_1] = {
				state = false,
				attr = iter_6_1
			}
		end

		for iter_6_2, iter_6_3 in ipairs(arg_6_1.cardIDs) do
			local var_6_8 = gGameModel.cards:find(iter_6_3):read("card_id", "advance", "fighting_point", "star")
			local var_6_9 = csv.cards[var_6_8.card_id]
			local var_6_10 = csv.unit[var_6_9.unitID]

			var_6_8.rarity = var_6_10.rarity
			var_6_1 = var_6_1 + 1
			var_6_2 = var_6_2 + var_6_8.fighting_point

			if var_6_3[var_6_10.natureType] then
				var_6_3[var_6_10.natureType].state = true
			end

			if var_6_10.natureType2 and var_6_3[var_6_10.natureType2] then
				var_6_3[var_6_10.natureType2].state = true
			end

			if var_6_6 <= var_6_8[var_0_2[var_6_4.condition1].name] then
				var_6_5 = var_6_5 + 1
			end
		end
	else
		var_6_1 = var_6_4.cardNums
		var_6_2 = arg_6_1.taskData.reach_fighting_point or 0

		for iter_6_4, iter_6_5 in pairs(arg_6_1.taskData.reach or {}) do
			if iter_6_4 == 1 and iter_6_5 == 1 then
				var_6_5 = var_6_7
			end
		end

		local var_6_11 = itertools.map(arg_6_1.taskData.reach_natures or {}, function(arg_7_0, arg_7_1)
			return arg_7_1, arg_7_0
		end)

		for iter_6_6, iter_6_7 in pairs(var_6_4.cardNatures) do
			var_6_3[iter_6_7] = {
				attr = iter_6_7,
				state = var_6_11[iter_6_7] ~= nil
			}
		end
	end

	local var_6_12 = string.format(gLanguageCsv.forceRequirement, var_6_2, arg_6_1.fightingPoint)

	var_0_3(var_6_0.condition1, var_6_12, var_6_2 >= arg_6_1.fightingPoint, arg_6_1.status)
	var_0_4(var_6_0.condition2, var_6_1, var_6_4, arg_6_1.status)
	var_0_5(var_6_0.extraCondition1, var_6_5, var_6_4, arg_6_1.status)
	var_0_6(var_6_0, var_6_3, arg_6_2, arg_6_1, var_6_5, var_6_4)
end

function var_0_0.setRewardPanel(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = {}

	for iter_8_0, iter_8_1 in csvMapPairs(arg_8_2) do
		table.insert(var_8_0, {
			key = iter_8_0,
			num = iter_8_1
		})
	end

	table.sort(var_8_0, dataEasy.sortItemCmp)

	local var_8_1 = 1
	local var_8_2 = #var_8_0

	for iter_8_2, iter_8_3 in ipairs(var_8_0) do
		local var_8_3
		local var_8_4 = var_8_1

		if var_8_2 == 3 and arg_8_4 == "main" then
			var_8_4 = var_8_4 == 1 and 3 or var_8_4 - 1
		end

		local var_8_5 = arg_8_1:get(arg_8_3 .. var_8_4)

		bind.extend(arg_8_0, var_8_5, {
			class = "icon_key",
			props = {
				data = {
					key = iter_8_3.key
				},
				onNode = function(arg_9_0)
					local var_9_0 = arg_8_4 == "main" and 0.6 or 0.7

					arg_9_0:scale(var_9_0)

					local var_9_1 = arg_9_0:box()
					local var_9_2 = var_8_5:size()
					local var_9_3 = dataEasy.getCfgByKey(iter_8_3.key).quality

					var_8_5:removeChildByName("num")

					local var_9_4 = cc.Label:createWithTTF(iter_8_3.num, ui.FONT_PATH, 32):align(cc.p(1, 0), var_9_2.width / 2 + var_9_1.width / 2 - 30 * var_9_0, var_9_2.height - var_9_1.height + 14 * var_9_0):addTo(var_8_5, 10, "num")

					text.addEffect(var_9_4, {
						outline = {
							color = ui.COLORS.QUALITY_OUTLINE[var_9_3]
						}
					})
				end
			}
		})

		var_8_1 = var_8_1 + 1
	end

	if arg_8_4 == "main" then
		local var_8_6 = arg_8_1:get("bgLeft"):y() - 10
		local var_8_7 = arg_8_1:get(arg_8_3 .. 3):x()

		if var_8_2 == 1 then
			arg_8_1:get(arg_8_3 .. 1):xy(var_8_7, var_8_6)
		end

		if var_8_2 == 2 then
			arg_8_1:get(arg_8_3 .. 1):xy(var_8_7 - 70, var_8_6)
			arg_8_1:get(arg_8_3 .. 2):xy(var_8_7 + 70, var_8_6)
		end

		if var_8_2 == 3 then
			arg_8_1:get(arg_8_3 .. 3):xy(var_8_7, var_8_6 + 90)
			arg_8_1:get(arg_8_3 .. 2):xy(var_8_7 - 80, var_8_6 - 20)
			arg_8_1:get(arg_8_3 .. 1):xy(var_8_7 + 80, var_8_6 - 20)
		end

		arg_8_1:get(arg_8_3 .. 2):visible(var_8_2 > 1)
		arg_8_1:get(arg_8_3 .. 3):visible(var_8_2 > 2)
	else
		if var_8_2 == 1 then
			arg_8_1:get(arg_8_3 .. 1):x(arg_8_1:get(arg_8_3 .. 2):x())
		end

		if var_8_2 == 2 then
			local var_8_8 = arg_8_1:get(arg_8_3 .. 2):x()

			arg_8_1:get(arg_8_3 .. 1):x(var_8_8 - 100)
			arg_8_1:get(arg_8_3 .. 2):x(var_8_8 + 100)
		end
	end
end

return var_0_0
