local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("TotemDrawSuccessView", var_0_0)

var_0_1.RESOURCE_FILENAME = "totem_draw_success.json"
var_0_1.RESOURCE_BINDING = {
	bgPanel = "bgPanel",
	["downPanel.costInfo"] = "costPanel",
	["downPanel.costInfo.imgIcon"] = "costIcon",
	["downPanel.costInfo.textCost"] = "textCost",
	item = "item",
	["downPanel.costInfo.textNote"] = "textNote",
	downPanel = "downPanel",
	movePanel = "movePanel",
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("showData"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					bind.extend(arg_1_0, arg_1_1:get("icon"), {
						class = "icon_key",
						props = {
							effect = "drawcard",
							data = {
								key = arg_1_3.key,
								num = arg_1_3.num
							}
						}
					})
					arg_1_1:get("textName"):text(dataEasy.getCfgByKey(arg_1_3.key).name):hide()

					if matchLanguage({
						"en",
						"kr"
					}) then
						arg_1_1:get("textName"):hide()

						local var_1_0 = beauty.singleTextLimitWord(dataEasy.getCfgByKey(arg_1_3.key).name, {
							fontSize = 40
						}, {
							width = 240
						}):xy(135, 26):addTo(arg_1_1, 2, "label")
					end
				end,
				onAfterBuild = function(arg_2_0)
					arg_2_0.setItemAlignCenter(arg_2_0)
				end
			}
		}
	},
	["downPanel.btnOk"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["downPanel.btnOk.textNote"] = {
		binds = {
			{
				event = "effect",
				data = {
					glow = {
						color = ui.COLORS.GLOW.WHITE
					}
				}
			}
		}
	},
	["downPanel.btnAgain"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAgain")
			}
		}
	},
	["downPanel.btnAgain.textNote"] = {
		varname = "btnTxt",
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0:initModel()

	arg_3_0.isStandby = arg_3_2()

	local var_3_0 = arg_3_0:getResourceNode()

	arg_3_0.movePanel:hide()
	widget.addAnimationByKey(var_3_0, "effect/chouka.skel", "efc1", "huode", 10):anchorPoint(cc.p(0.5, 0.5)):xy(var_3_0:width() / 2, var_3_0:height() - 800):addPlay("effect_loop"):scale(2)

	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(arg_3_1.result.items) do
		table.insert(var_3_1, {
			key = iter_3_1[1],
			num = iter_3_1[2]
		})
	end

	if itertools.size(var_3_1) == 1 then
		arg_3_0.type = "one"

		arg_3_0.btnTxt:text(gLanguageCsv.drawItemOne)
	else
		arg_3_0.type = "six"

		arg_3_0.btnTxt:text(gLanguageCsv.exchangeDrawSix)
	end

	arg_3_0.showData:update(var_3_1)

	local var_3_2 = arg_3_0.items:read()[game.ITEM_TICKET.totemCard] or 0

	if arg_3_0.type == "one" and var_3_2 > 0 or arg_3_0.type == "six" and var_3_2 >= 6 then
		local var_3_3 = arg_3_0.items:read()[game.ITEM_TICKET.totemCard] .. "/1"

		if arg_3_0.type == "six" and var_3_2 >= 6 then
			var_3_3 = arg_3_0.items:read()[game.ITEM_TICKET.totemCard] .. "/6"
		end

		arg_3_0.textCost:text(var_3_3)
		arg_3_0.costIcon:texture(dataEasy.getIconResByKey(game.ITEM_TICKET.totemCard))
	else
		if arg_3_0.type == "one" then
			local var_3_4 = gCommonConfigCsv.drawTotemCostPrice

			arg_3_0.textCost:text(var_3_4)
			idlereasy.when(arg_3_0.rmb, function(arg_4_0, arg_4_1)
				local var_4_0 = arg_3_0.rmb:read() < var_3_4 and ui.COLORS.NORMAL.RED or ui.COLORS.NORMAL.WHITE

				text.addEffect(arg_3_0.textCost, {
					color = var_4_0
				})
			end)
		else
			arg_3_0.textCost:text(gCommonConfigCsv.draw6TotemCostPrice)
			idlereasy.when(arg_3_0.rmb, function(arg_5_0, arg_5_1)
				local var_5_0 = arg_3_0.rmb:read() < gCommonConfigCsv.draw6TotemCostPrice and ui.COLORS.NORMAL.RED or ui.COLORS.NORMAL.WHITE

				text.addEffect(arg_3_0.textCost, {
					color = var_5_0
				})
			end)
		end

		arg_3_0.costIcon:texture(dataEasy.getIconResByKey("rmb"))
	end

	local var_3_5 = arg_3_0.costPanel:size()

	adapt.oneLineCenterPos(cc.p(var_3_5.width / 2, var_3_5.height / 2), {
		arg_3_0.textNote,
		arg_3_0.textCost,
		arg_3_0.costIcon
	}, cc.p(10, 0))
end

function var_0_1.onAgain(arg_6_0)
	local var_6_0 = arg_6_0.items:read()[game.ITEM_TICKET.totemCard] or 0

	if arg_6_0.type == "one" then
		if gVipCsv[arg_6_0.vip:read()].drawTotemCountLimit == arg_6_0.totalTime:read() then
			gGameUI:showTip(gLanguageCsv.todayDrawTotemLimit)

			return
		end

		if var_6_0 == 0 and arg_6_0.rmb:read() < gCommonConfigCsv.drawTotemCostPrice and param ~= "free1" then
			uiEasy.showDialog("rmb")

			return
		end

		if param ~= "free1" or var_6_0 == 0 and param ~= "free1" then
			dataEasy.sureUsingDiamonds(function()
				arg_6_0:onClose(1)
			end, gCommonConfigCsv.drawTotemCostPrice)
		else
			arg_6_0.onClose(arg_6_0, 1)
		end
	else
		if gVipCsv[arg_6_0.vip:read()].drawTotemCountLimit == arg_6_0.totalTime:read() then
			gGameUI:showTip(gLanguageCsv.todayDrawTotemLimit)

			return
		elseif gVipCsv[arg_6_0.vip:read()].drawTotemCountLimit - arg_6_0.totalTime:read() < 6 then
			gGameUI:showTip(gLanguageCsv.todayDrawItemTimesLessSix)

			return
		end

		if var_6_0 < 6 and arg_6_0.rmb:read() < gCommonConfigCsv.draw6TotemCostPrice then
			uiEasy.showDialog("rmb")

			return
		end

		if var_6_0 < 6 then
			dataEasy.sureUsingDiamonds(function()
				arg_6_0:onClose(6)
			end, gCommonConfigCsv.draw6TotemCostPrice)
		else
			arg_6_0.onClose(arg_6_0, 6)
		end
	end
end

function var_0_1.initModel(arg_9_0)
	arg_9_0.rmb = gGameModel.role:getIdler("rmb")
	arg_9_0.items = gGameModel.role:getIdler("items")
	arg_9_0.vip = gGameModel.role:getIdler("vip_level")
	arg_9_0.freeTime = gGameModel.daily_record:getIdler("totem_rmb_dc1_free_count")
	arg_9_0.totalTime = gGameModel.daily_record:getIdler("draw_totem")
	arg_9_0.itemDiamondHalfCount = gGameModel.daily_record:getIdler("draw_item_rmb1_half")
	arg_9_0.showData = idlers.newWithMap({})
end

function var_0_1.onClose(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.isStandby

	var_0_0.onClose(arg_10_0)

	if type(arg_10_1) == "number" then
		var_10_0.set(var_10_0, arg_10_1)
	else
		var_10_0.set(var_10_0, true)
	end
end

return var_0_1
