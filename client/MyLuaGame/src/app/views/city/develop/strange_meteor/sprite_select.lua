local var_0_0 = class("StrangeMeteorSpriteSelectView", Dialog)
local var_0_1 = require("app.views.city.develop.strange_meteor.tools")

var_0_0.RESOURCE_FILENAME = "strange_meteor_sprite_select.json"
var_0_0.RESOURCE_BINDING = {
	["down.textNum"] = "textNum",
	item = "item",
	["down.textNote"] = "textNote",
	innerList = "innerList",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 3,
				asyncPreload = 12,
				data = bindHelper.self("cardDatas"),
				item = bindHelper.self("innerList"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					bind.extend(arg_1_0, arg_1_1.get(arg_1_1, "head"), {
						class = "card_icon",
						props = {
							unitId = arg_1_3.unitId,
							advance = arg_1_3.advance,
							star = arg_1_3.star,
							rarity = arg_1_3.rarity,
							levelProps = {
								data = arg_1_3.level
							}
						}
					})

					local var_1_0 = gLanguageCsv.inTheTeam

					if arg_1_3.battle == 1 and ui.CARD_USING_TXTS[arg_1_3.battleType] then
						var_1_0 = gLanguageCsv[ui.CARD_USING_TXTS[arg_1_3.battleType]]
					end

					local var_1_1 = arg_1_1:get("battle.textNote")

					var_1_1:text(var_1_0)
					uiEasy.addTextEffect1(var_1_1)
					arg_1_1:get("textName"):text(csv.cards[arg_1_3.id].name)
					arg_1_1:get("textFightPoint"):text(arg_1_3.fight)
					arg_1_1:get("imgLock"):visible(arg_1_3.lock)
					arg_1_1:get("imgTick"):visible(arg_1_3.isSel)
					arg_1_1:get("imgMask"):visible(arg_1_3.battle == 1 or arg_1_3.isSel)
					arg_1_1:get("battle"):visible(arg_1_3.battle == 1)

					local var_1_2 = arg_1_0:getIdx(arg_1_2)

					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, var_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onCellClick")
			}
		}
	},
	down = {
		binds = {
			event = "visible",
			idler = bindHelper.self("isShowDown")
		}
	},
	["down.btnOk"] = {
		varname = "btnOk",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSure")
			}
		}
	},
	tipPanel = {
		binds = {
			event = "visible",
			idler = bindHelper.self("showTip")
		}
	}
}

function var_0_0.onCreate(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0.index = arg_2_1
	arg_2_0.showTip = idler.new(false)
	arg_2_0.cardDatas = idlers.newWithMap({})
	arg_2_0.isShowDown = idler.new(false)
	arg_2_0.stopActionCb = arg_2_2
	arg_2_0.insetCb = arg_2_3

	local var_2_0 = var_0_1.getSelectCard(nil, arg_2_1)

	table.sort(var_2_0, function(arg_3_0, arg_3_1)
		if arg_3_0.battle ~= arg_3_1.battle then
			return arg_3_0.battle == 2
		end

		if arg_3_0.rarity ~= arg_3_1.rarity then
			return arg_3_1.rarity < arg_3_0.rarity
		end

		return arg_3_1.fight < arg_3_0.fight
	end)
	arg_2_0.cardDatas:update(var_2_0)
	idlereasy.when(arg_2_0.cardDatas, function()
		local var_4_0

		for iter_4_0, iter_4_1 in arg_2_0.cardDatas:ipairs() do
			local var_4_1 = iter_4_1:read()

			if var_4_1.isSel then
				var_4_0 = var_4_1.dbid
			end
		end

		if var_4_0 then
			uiEasy.setBtnShader(arg_2_0.btnOk, false, 1)
		else
			uiEasy.setBtnShader(arg_2_0.btnOk, false, 3)
		end
	end)

	arg_2_0.selected = {}

	arg_2_0.list:size(1665, 850)
	arg_2_0.list:y(arg_2_0.list:y() + 100)
	arg_2_0.showTip:set(arg_2_0.cardDatas:size() == 0)
	arg_2_0.isShowDown:set(arg_2_0.cardDatas:size() ~= 0)
	arg_2_0.textNum:hide()
	Dialog.onCreate(arg_2_0)
end

function var_0_0.onChangeData(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = gGameModel.cards:find(arg_5_2.dbid)

	arg_5_0.cardDatas:atproxy(arg_5_1).lock = var_5_0:read("locked")
end

function var_0_0.onCellClick(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = itertools.size(arg_6_0.selected)
	local var_6_1 = 1

	if not arg_6_3.isSel and var_6_1 <= var_6_0 then
		gGameUI:showTip(string.format(gLanguageCsv.selectedmax, var_6_1))

		return
	end

	if (function()
		if arg_6_3.battle == 1 then
			gGameUI:showTip(gLanguageCsv[ui.CARD_USING_TXTS[arg_6_3.battleType]])

			return true
		end
	end)() then
		return
	end

	local var_6_2 = csv.cards[arg_6_3.id]

	if arg_6_3.isSel then
		arg_6_0.cardDatas:atproxy(arg_6_2.k).isSel = false
		arg_6_0.selected[arg_6_2.k] = nil
	else
		arg_6_0.cardDatas:atproxy(arg_6_2.k).isSel = true
		arg_6_0.selected[arg_6_2.k] = arg_6_3
	end
end

function var_0_0.onSure(arg_8_0)
	local var_8_0

	for iter_8_0, iter_8_1 in arg_8_0.cardDatas:ipairs() do
		local var_8_1 = iter_8_1.read(iter_8_1)

		if var_8_1.isSel then
			var_8_0 = var_8_1.dbid
		end
	end

	if not var_8_0 then
		gGameUI:showTip(gLanguageCsv.meteorSelectSprite)

		return
	end

	local function var_8_2()
		gGameApp:requestServer("/game/meteorite/guard/setup", function(arg_10_0)
			if arg_8_0.insetCb then
				arg_8_0:addCallbackOnExit(functools.partial(arg_8_0.insetCb))
				arg_8_0:onClose()
			else
				arg_8_0:onClose()
			end
		end, arg_8_0.index, 1, nil, var_8_0)
	end

	local var_8_3 = csv.meteorite.base[arg_8_0.index].cardCD
	local var_8_4 = math.floor(var_8_3 / 3600)
	local var_8_5 = math.floor((var_8_3 - var_8_4 * 3600) / 60)
	local var_8_6 = math.max(var_8_3 - var_8_4 * 3600 - var_8_5 * 60, 0)
	local var_8_7 = string.format(gLanguageCsv.meteorSpriteUpCDTips, var_8_4, var_8_5, var_8_6)
	local var_8_8 = userDefault.getCurrDayKey("strangeMeteorUp", "first")

	if var_8_8 == "first" then
		var_8_8 = "true"

		userDefault.setCurrDayKey("strangeMeteorUp", var_8_8)
	end

	if var_8_8 == "true" then
		gGameUI:showDialog({
			selectType = 2,
			clearFast = true,
			btnType = 1,
			selectKey = "strangeMeteorUp",
			content = var_8_7,
			cb = var_8_2,
			selectTip = gLanguageCsv.todayNoTip
		})
	else
		var_8_2()
	end
end

function var_0_0.onClose(arg_11_0)
	if arg_11_0.stopActionCb then
		arg_11_0.addCallbackOnExit(arg_11_0, functools.partial(arg_11_0.stopActionCb))
		Dialog.onClose(arg_11_0)
	else
		Dialog.onClose(arg_11_0)
	end
end

return var_0_0
