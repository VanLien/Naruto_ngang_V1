local var_0_0 = class("StrangeMeteorSpriteExtraEffectDetailView", Dialog)
local var_0_1 = require("app.views.city.develop.strange_meteor.tools")

var_0_0.RESOURCE_FILENAME = "strange_meteor_sprite_extra_effect_detail.json"
var_0_0.RESOURCE_BINDING = {
	["baseNode.txt3"] = "txt3",
	["baseNode.attr2"] = "attr2",
	["baseNode.bg"] = "bg",
	["baseNode.txt1"] = "txt1",
	baseNode = "baseNode",
	["baseNode.txt4"] = "txt4",
	["baseNode.cardName"] = "cardName",
	["baseNode.cardIcon"] = "cardIcon",
	["baseNode.txt2"] = "txt2",
	["baseNode.attr1"] = "attr1",
	["baseNode.btnChange"] = {
		varname = "btnChange",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChangeClick")
			}
		}
	},
	["baseNode.btnDown"] = {
		varname = "btnDown",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDownClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	arg_1_0.stopActionCb = arg_1_5
	arg_1_0.viewPos = arg_1_4
	arg_1_0.selectDbId = gGameModel.role:read("meteorites")[arg_1_1].card
	arg_1_0.changeCb = arg_1_2
	arg_1_0.downCb = arg_1_3

	arg_1_0:initModel()

	local var_1_0 = false
	local var_1_1 = false
	local var_1_2 = csv.cards[arg_1_0.cardId]
	local var_1_3 = csv.unit[var_1_2.unitID]

	arg_1_0.cardName:text(var_1_3.name)
	arg_1_0.attr1:texture(ui.ATTR_ICON[var_1_3.natureType])

	if var_1_3.natureType2 then
		arg_1_0.attr2:texture(ui.ATTR_ICON[var_1_3.natureType2])
	else
		arg_1_0.attr2:hide()
	end

	local var_1_4 = "0%"
	local var_1_5 = "0%"
	local var_1_6 = "0%"
	local var_1_7 = "0%"
	local var_1_8 = csv.meteorite.guard_effect[var_1_3.rarity]
	local var_1_9 = var_1_8.rarityAttr
	local var_1_10 = var_1_8.starAttrs[arg_1_0.star]
	local var_1_11 = var_1_8.advanceAttrs[arg_1_0.advance]

	if var_1_1 then
		var_1_7 = var_1_8.zawakeAttrs[var_1_0]
	else
		var_1_7 = "0%"
	end

	local var_1_12, var_1_13 = dataEasy.getQuality(arg_1_0.advance)
	local var_1_14 = ""

	if not itertools.isempty(var_1_13) then
		var_1_14 = gLanguageCsv[ui.QUALITY_COLOR_TEXT[var_1_12]] .. "+" .. var_1_13
	else
		var_1_14 = gLanguageCsv[ui.QUALITY_COLOR_TEXT[var_1_12]] .. var_1_13
	end

	rich.createWithWidth(string.format(gLanguageCsv.meteorSpriteAdd1, ui.QUALITYCOLOR[var_1_3.rarity + 2] .. gLanguageCsv["rarityCard" .. var_1_3.rarity - 1], var_1_9), 40, nil, 1250):addTo(arg_1_0.txt1, 10):anchorPoint(cc.p(0, 0.5)):xy(0, 0):formatText()
	rich.createWithWidth(string.format(gLanguageCsv.meteorSpriteAdd2, ui.QUALITYCOLOR[var_1_12] .. var_1_14, var_1_11), 40, nil, 1250):addTo(arg_1_0.txt2, 10):anchorPoint(cc.p(0, 0.5)):xy(0, 0):formatText()
	rich.createWithWidth(string.format(gLanguageCsv.meteorSpriteAdd3, arg_1_0.star, var_1_10), 40, nil, 1250):addTo(arg_1_0.txt3, 10):anchorPoint(cc.p(0, 0.5)):xy(0, 0):formatText()

	if var_1_1 then
		rich.createWithWidth(string.format(gLanguageCsv.meteorSpriteAdd4, gLanguageCsv["symbolRome" .. var_1_0], var_1_7), 40, nil, 1250):addTo(arg_1_0.txt4, 10):anchorPoint(cc.p(0, 0.5)):xy(0, 0):formatText()
	else
		arg_1_0.txt4:text(gLanguageCsv.meteorSpriteNoZawakeTips)
	end

	arg_1_0.baseNode:x(arg_1_4.x + 1200)
	arg_1_0.bg:height(arg_1_0.bg:height())
	arg_1_0.bg:y(arg_1_0.bg:y())

	local var_1_15 = dataEasy.getUnitId(arg_1_0.cardId, arg_1_0.skinId)

	bind.extend(arg_1_0, arg_1_0.cardIcon, {
		class = "card_icon",
		props = {
			unitId = var_1_15,
			star = arg_1_0.star,
			rarity = var_1_3.rarity,
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
	Dialog.onCreate(arg_1_0, {
		clearFast = true,
		blackOpacity = 0
	})
end

function var_0_0.initModel(arg_3_0)
	local var_3_0 = gGameModel.cards:find(arg_3_0.selectDbId)

	arg_3_0.advance = var_3_0:read("advance")
	arg_3_0.cardId = var_3_0:read("card_id")
	arg_3_0.skinId = var_3_0:read("skin_id")
	arg_3_0.star = var_3_0:read("star")
	arg_3_0.level = var_3_0:read("level")
end

function var_0_0.onChangeClick(arg_4_0)
	if arg_4_0.changeCb then
		arg_4_0.addCallbackOnExit(arg_4_0, functools.partial(arg_4_0.changeCb, 1, false, true))
		arg_4_0.onClose(arg_4_0)
	end
end

function var_0_0.onDownClick(arg_5_0)
	if arg_5_0.downCb then
		arg_5_0.addCallbackOnExit(arg_5_0, functools.partial(arg_5_0.downCb, 1))
		arg_5_0.onClose(arg_5_0)
	end
end

function var_0_0.onClose(arg_6_0)
	if arg_6_0.stopActionCb then
		arg_6_0.addCallbackOnExit(arg_6_0, functools.partial(arg_6_0.stopActionCb))
		Dialog.onClose(arg_6_0)
	else
		Dialog.onClose(arg_6_0)
	end
end

return var_0_0
