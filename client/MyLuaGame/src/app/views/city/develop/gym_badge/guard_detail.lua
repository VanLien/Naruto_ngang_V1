local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("gymBadgeGuardDetailView", var_0_0)

var_0_1.RESOURCE_FILENAME = "gym_badge_guard_detail.json"
var_0_1.RESOURCE_BINDING = {
	["baseNode.txt3"] = "txt3",
	["baseNode.attr2"] = "attr2",
	["baseNode.bg"] = "bg",
	["baseNode.text5"] = "text5",
	["baseNode.txt1"] = "txt1",
	baseNode = "baseNode",
	["baseNode.text4"] = "text4",
	["baseNode.txt4"] = "txt4",
	["baseNode.cardName"] = "cardName",
	["baseNode.cardIcon"] = "cardIcon",
	["baseNode.txt2"] = "txt2",
	["baseNode.txt5"] = "txt5",
	["baseNode.attr1"] = "attr1"
}

function var_0_1.onCreate(arg_1_0, arg_1_1)
	arg_1_0.selectDbId = arg_1_1.selectDbId

	local var_1_0 = arg_1_1.badgeNumb

	arg_1_0:initModel()

	local var_1_1 = csv.cards[arg_1_0.cardId]
	local var_1_2 = csv.unit[var_1_1.unitID]

	arg_1_0.cardName:text(var_1_2.name)
	arg_1_0.attr1:texture(ui.ATTR_ICON[var_1_2.natureType])

	if var_1_2.natureType2 then
		arg_1_0.attr2:texture(ui.ATTR_ICON[var_1_2.natureType2])
	else
		arg_1_0.attr2:hide()
	end

	local var_1_3 = "0%"
	local var_1_4 = "0%"
	local var_1_5 = "0%"
	local var_1_6 = "0%"
	local var_1_7 = 0
	local var_1_8 = {}

	for iter_1_0, iter_1_1 in pairs(arg_1_0.nvalue) do
		var_1_7 = var_1_7 + iter_1_1
	end

	local var_1_9 = false

	if itertools.include(csv.gym_badge.badge[var_1_0].nature, var_1_2.natureType) then
		var_1_9 = true
	end

	if itertools.include(csv.gym_badge.badge[var_1_0].nature, var_1_2.natureType2) then
		var_1_9 = true
	end

	for iter_1_2, iter_1_3 in ipairs(csv.gym_badge.guard_effect) do
		if iter_1_2 == var_1_2.rarity then
			var_1_3 = iter_1_3.rarityAttr
			var_1_4 = iter_1_3.starAttrs[arg_1_0.star]
			var_1_5 = iter_1_3.advanceAttrs[arg_1_0.advance]

			if var_1_9 then
				var_1_6 = iter_1_3.natureAttr
			end

			var_1_8 = iter_1_3.nvalueAttrs
		end
	end

	local var_1_10, var_1_11 = dataEasy.getQuality(arg_1_0.advance)
	local var_1_12 = ""

	if not itertools.isempty(var_1_11) then
		var_1_12 = gLanguageCsv[ui.QUALITY_COLOR_TEXT[var_1_10]] .. "+" .. var_1_11
	else
		var_1_12 = gLanguageCsv[ui.QUALITY_COLOR_TEXT[var_1_10]] .. var_1_11
	end

	local var_1_13 = gLanguageCsv.rarityAdditionText
	local var_1_14 = string.gsub(var_1_13, "#C0x5C9970#", "#C0x06C545#")
	local var_1_15 = gLanguageCsv.advanceAdditionText
	local var_1_16 = string.gsub(var_1_15, "#C0x5C9970#", "#C0x06C545#")
	local var_1_17 = gLanguageCsv.starAdditionText
	local var_1_18 = string.gsub(var_1_17, "#C0x5C9970#", "#C0x06C545#")

	rich.createWithWidth(string.format(var_1_14, ui.QUALITYCOLOR[var_1_2.rarity + 2] .. gLanguageCsv["rarityCard" .. var_1_2.rarity - 1], var_1_3), 40, nil, 1250):addTo(arg_1_0.txt1, 10):anchorPoint(cc.p(0, 0.5)):xy(0, 0):formatText()
	rich.createWithWidth(string.format(var_1_16, ui.QUALITYCOLOR[var_1_10] .. var_1_12, var_1_5), 40, nil, 1250):addTo(arg_1_0.txt2, 10):anchorPoint(cc.p(0, 0.5)):xy(0, 0):formatText()
	rich.createWithWidth(string.format(var_1_18, arg_1_0.star, var_1_4), 40, nil, 1250):addTo(arg_1_0.txt3, 10):anchorPoint(cc.p(0, 0.5)):xy(0, 0):formatText()

	local var_1_19 = 0
	local var_1_20

	for iter_1_4, iter_1_5 in orderCsvPairs(var_1_8) do
		if iter_1_4 <= var_1_7 and var_1_19 <= iter_1_4 then
			var_1_19 = iter_1_4
			var_1_20 = iter_1_5
		end
	end

	if var_1_20 then
		local var_1_21 = gLanguageCsv.nNatureAdditionText
		local var_1_22 = string.gsub(var_1_21, "#C0x5C9970#", "#C0x06C545#")

		rich.createWithWidth(string.format(var_1_22, var_1_19, var_1_20), 40, nil, 1250):addTo(arg_1_0.txt4, 10):anchorPoint(cc.p(0, 0.5)):xy(0, 0):formatText()
	else
		arg_1_0.txt4:hide()
		arg_1_0.baseNode:get("text4"):hide()
		arg_1_0.bg:height(arg_1_0.bg:height() - 150)
		arg_1_0.bg:y(arg_1_0.bg:y() + 75)
	end

	if var_1_9 == true then
		local var_1_23 = gLanguageCsv.sameNatureAdditionText
		local var_1_24 = string.gsub(var_1_23, "#C0x5C9970#", "#C0x06C545#")

		rich.createWithWidth(string.format(var_1_24, var_1_6), 40, nil, 1250):addTo(arg_1_0.txt5, 10):anchorPoint(cc.p(0, 0.5)):xy(0, 0):formatText()

		if arg_1_0.txt4:isVisible() == false then
			arg_1_0.txt5:y(arg_1_0.txt4:y())
			arg_1_0.text5:y(arg_1_0.text4:y())
		end
	else
		arg_1_0.txt5:hide()
		arg_1_0.baseNode:get("text5"):hide()
		arg_1_0.bg:height(arg_1_0.bg:height() - 150)
		arg_1_0.bg:y(arg_1_0.bg:y() + 75)
	end

	local var_1_25 = dataEasy.getUnitId(arg_1_0.cardId, arg_1_0.skinId)

	bind.extend(arg_1_0, arg_1_0.cardIcon, {
		class = "card_icon",
		props = {
			unitId = var_1_25,
			star = arg_1_0.star,
			rarity = var_1_2.rarity,
			advance = arg_1_0.advance,
			levelProps = {
				data = arg_1_0.level
			},
			onNode = function(arg_2_0)
				local var_2_0 = arg_2_0:size()

				arg_2_0:alignCenter(var_2_0)
			end
		}
	})
end

function var_0_1.initModel(arg_3_0)
	local var_3_0 = gGameModel.cards:find(arg_3_0.selectDbId)

	arg_3_0.advance = var_3_0:read("advance")
	arg_3_0.cardId = var_3_0:read("card_id")
	arg_3_0.skinId = var_3_0:read("skin_id")
	arg_3_0.star = var_3_0:read("star")
	arg_3_0.nvalue = var_3_0:read("nvalue")
	arg_3_0.level = var_3_0:read("level")
end

return var_0_1
