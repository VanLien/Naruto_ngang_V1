local var_0_0 = class("StrangeMeteorHeldExtraEffectDetailView", Dialog)

var_0_0.RESOURCE_FILENAME = "strange_meteor_held_extra_effect_detail.json"
var_0_0.RESOURCE_BINDING = {
	["baseNode.text3"] = "text3",
	["baseNode.bg"] = "bg",
	["baseNode.txt3"] = "txt3",
	["baseNode.txt1"] = "txt1",
	baseNode = "baseNode",
	["baseNode.text2"] = "text2",
	["baseNode.cardName"] = "heldName",
	["baseNode.cardIcon"] = "heldIcon",
	["baseNode.txt2"] = "txt2",
	["baseNode.text1"] = "text1",
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

function var_0_0.onCreate(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)
	arg_1_0.stopActionCb = arg_1_7
	arg_1_0.changeCb = arg_1_4
	arg_1_0.downCb = arg_1_5
	arg_1_0.pos = arg_1_2 + 1
	arg_1_0.isOnlyLook = arg_1_3

	local var_1_0 = gGameModel.role:read("meteorites")[arg_1_1].helditems[arg_1_2]
	local var_1_1 = gGameModel.held_items:find(var_1_0)
	local var_1_2
	local var_1_3 = ""
	local var_1_4 = 1
	local var_1_5 = 1
	local var_1_6 = 0
	local var_1_7

	if var_1_1 then
		local var_1_8 = var_1_1.read(var_1_1, "exist_flag", "card_db_id", "advance", "level", "sum_exp", "held_item_id")

		var_1_2 = var_1_8.held_item_id

		local var_1_9 = csv.held_item.items[var_1_2]

		var_1_3 = var_1_9.name
		var_1_4 = var_1_9.quality
		var_1_5 = var_1_8.level
		var_1_6 = var_1_8.advance
	end

	local var_1_10 = "0%"
	local var_1_11 = "0%"
	local var_1_12 = "0%"
	local var_1_13 = 1
	local var_1_14 = csv.meteorite.helditem_effect[var_1_4]

	for iter_1_0 = 1, #var_1_14.levelAttrs do
		if var_1_5 >= var_1_14.levelAttrs[iter_1_0][1] then
			var_1_13 = var_1_14.levelAttrs[iter_1_0][1]
			var_1_10 = var_1_14.levelAttrs[iter_1_0][2]
		end
	end

	local var_1_15 = var_1_14.rarityAttr
	local var_1_16 = var_1_14.advanceAttrs[var_1_6] or "0%"

	rich.createWithWidth(string.format(gLanguageCsv.meteorHeldItemsAdd1, var_1_13, var_1_10), 40, nil, 620):addTo(arg_1_0.txt1, 10):anchorPoint(cc.p(0, 0.5)):xy(0, -10):formatText()
	rich.createWithWidth(string.format(gLanguageCsv.meteorHeldItemsAdd2, var_1_6, var_1_16), 40, nil, 620):addTo(arg_1_0.txt2, 10):anchorPoint(cc.p(0, 0.5)):xy(0, -28):formatText()
	arg_1_0.text2:y(arg_1_0.text2:y() - 20)
	rich.createWithWidth(string.format(gLanguageCsv.meteorHeldItemsAdd3, gLanguageCsv[ui.QUALITY_COLOR_TEXT[var_1_4]], var_1_15), 40, nil, 620):addTo(arg_1_0.txt3, 10):anchorPoint(cc.p(0, 0.5)):xy(0, -45):formatText()
	arg_1_0.text3:y(arg_1_0.text3:y() - 35)
	arg_1_0.baseNode:x(arg_1_6.x + 1000)
	arg_1_0.heldName:text(var_1_3)
	bind.extend(arg_1_0, arg_1_0.heldIcon, {
		class = "icon_key",
		props = {
			noListener = true,
			data = {
				key = var_1_2,
				dbId = var_1_0
			},
			specialKey = {
				lv = var_1_5
			},
			onNode = function(arg_2_0)
				arg_2_0:setTouchEnabled(false)
			end
		}
	})
	Dialog.onCreate(arg_1_0, {
		clearFast = true,
		blackOpacity = 0
	})
end

function var_0_0.initModel(arg_3_0)
	arg_3_0.myHeldItem = gGameModel.role:getIdler("held_items")
end

function var_0_0.onChangeClick(arg_4_0)
	if arg_4_0.changeCb then
		arg_4_0.addCallbackOnExit(arg_4_0, functools.partial(arg_4_0.changeCb, arg_4_0.pos, arg_4_0.isOnlyLook, true))
		arg_4_0.onClose(arg_4_0)
	end
end

function var_0_0.onDownClick(arg_5_0)
	if arg_5_0.downCb then
		arg_5_0.addCallbackOnExit(arg_5_0, functools.partial(arg_5_0.downCb, arg_5_0.pos))
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
