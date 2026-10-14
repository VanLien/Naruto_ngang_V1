local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("ExplorerDrawItemSuccessView", var_0_0)

var_0_1.RESOURCE_FILENAME = "explore_draw_item_success.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	costPanel = "costPanel",
	["costPanel.num"] = "num",
	pos = "pos",
	["costPanel.numNote"] = "numNote",
	txt = "txt",
	["costPanel.icon"] = "icon",
	bg = {
		binds = {
			event = "click",
			method = bindHelper.self("onClose")
		}
	},
	btnSure = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btn = {
		varname = "btn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAgain")
			}
		}
	},
	["btnSure.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["btn.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0:initModel()

	arg_1_0.isStandby = arg_1_2()

	local var_1_0 = arg_1_0:getResourceNode()

	widget.addAnimationByKey(var_1_0, "effect/gongxihuode.skel", "gongxihuode", "effect", 10):anchorPoint(cc.p(0.5, 0.5)):xy(var_1_0:width() / 2, var_1_0:height() - 300):addPlay("effect_loop")

	local var_1_1 = {}

	for iter_1_0, iter_1_1 in ipairs(arg_1_1.result) do
		table.insert(var_1_1, {
			key = iter_1_1[1][1],
			num = iter_1_1[1][2]
		})
	end

	local var_1_2 = arg_1_1.result.extra[1][1]
	local var_1_3 = arg_1_1.result.extra[1][2]

	if #var_1_1 == 1 then
		for iter_1_2 = 1, 5 do
			arg_1_0:getResourceNode():get("pos" .. iter_1_2):hide()
		end

		local var_1_4 = arg_1_0.item:clone():show()

		var_1_4:addTo(arg_1_0.pos):alignCenter(arg_1_0.pos:size())
		bind.extend(arg_1_0, var_1_4, {
			class = "explore_icon",
			props = {
				effect = "drawcard",
				data = var_1_1[1],
				onNode = function(arg_2_0)
					arg_2_0:scale(1.2)
				end
			}
		})

		local var_1_5, var_1_6 = uiEasy.setIconName(var_1_1[1].key, num)

		beauty.singleTextLimitWord(var_1_5, {
			fontSize = 40
		}, {
			width = 240
		}):xy(arg_1_0.pos:size().width / 2, 0):addTo(var_1_4, 10)

		arg_1_0.type = "one"

		arg_1_0.btn:get("txt"):text(gLanguageCsv.drawItemOne)
	else
		arg_1_0.icon:texture(dataEasy.getIconResByKey("rmb"))
		arg_1_0.num:text(gCommonConfigCsv.draw5ItemCostPrice)
		arg_1_0.pos:hide()
		table.sort(var_1_1, function(arg_3_0, arg_3_1)
			local var_3_0 = dataEasy.getCfgByKey(arg_3_0.key)
			local var_3_1 = dataEasy.getCfgByKey(arg_3_1.key)

			if var_3_0.quality ~= var_3_1.quality then
				return var_3_0.quality < var_3_1.quality
			end

			return arg_3_0.key < arg_3_1.key
		end)

		for iter_1_3 = 1, 5 do
			local var_1_7 = arg_1_0.item:clone():show()
			local var_1_8 = arg_1_0:getResourceNode():get("pos" .. iter_1_3)

			var_1_7:addTo(var_1_8):alignCenter(var_1_8:size())
			bind.extend(arg_1_0, var_1_7, {
				class = "explore_icon",
				props = {
					effect = "drawcard",
					data = var_1_1[iter_1_3],
					onNode = function(arg_4_0)
						arg_4_0:scale(1.2)
					end
				}
			})

			local var_1_9, var_1_10 = uiEasy.setIconName(var_1_1[iter_1_3].key, num)

			beauty.singleTextLimitWord(var_1_9, {
				fontSize = 40
			}, {
				width = 240
			}):xy(var_1_8:size().width / 2, 0):addTo(var_1_7, 10)
		end

		arg_1_0.type = "five"

		arg_1_0.btn:get("txt"):text(gLanguageCsv.drawItemFive)
	end

	local var_1_11 = arg_1_0.items:read()[game.ITEM_TICKET.card4] or 0
	local var_1_12 = arg_1_0.itemDiamondHalfCount:read() == 0 and dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.FirstRMBDrawItemHalf) ~= 0

	if arg_1_0.type == "one" and var_1_11 > 0 and not var_1_12 or arg_1_0.type == "five" and var_1_11 >= 5 then
		local var_1_13 = arg_1_0.items:read()[game.ITEM_TICKET.card4] .. "/1"

		if arg_1_0.type == "five" and var_1_11 >= 5 then
			var_1_13 = arg_1_0.items:read()[game.ITEM_TICKET.card4] .. "/5"
		end

		arg_1_0.num:text(var_1_13)
		arg_1_0.icon:texture(dataEasy.getIconResByKey(game.ITEM_TICKET.card4))
	else
		if arg_1_0.type == "one" then
			local var_1_14 = gCommonConfigCsv.drawItemCostPrice

			if var_1_12 then
				var_1_14 = gCommonConfigCsv.drawItemCostPrice / 2
			end

			arg_1_0.num:text(var_1_14)
			idlereasy.when(arg_1_0.rmb, function(arg_5_0, arg_5_1)
				local var_5_0 = arg_1_0.rmb:read() < var_1_14 and ui.COLORS.NORMAL.RED or ui.COLORS.NORMAL.WHITE

				text.addEffect(arg_1_0.num, {
					color = var_5_0
				})
			end)
		else
			arg_1_0.num:text(gCommonConfigCsv.draw5ItemCostPrice)
			idlereasy.when(arg_1_0.rmb, function(arg_6_0, arg_6_1)
				local var_6_0 = arg_1_0.rmb:read() < gCommonConfigCsv.draw5ItemCostPrice and ui.COLORS.NORMAL.RED or ui.COLORS.NORMAL.WHITE

				text.addEffect(arg_1_0.num, {
					color = var_6_0
				})
			end)
		end

		arg_1_0.icon:texture(dataEasy.getIconResByKey("rmb"))
	end

	local var_1_15 = arg_1_0.costPanel:size()

	adapt.oneLineCenterPos(cc.p(var_1_15.width / 2, var_1_15.height / 2), {
		arg_1_0.numNote,
		arg_1_0.num,
		arg_1_0.icon
	}, cc.p(10, 0))

	local var_1_16 = string.format(gLanguageCsv.extraGetCoin4, arg_1_1.result.extra[1][2], dataEasy.getIconResByKey(arg_1_1.result.extra[1][1]))

	rich.createByStr(var_1_16, 40, nil, nil, cc.p(0, 0)):addTo(arg_1_0.txt):alignCenter(arg_1_0.txt:size())
end

function var_0_1.onAgain(arg_7_0)
	local var_7_0 = arg_7_0.items:read()[game.ITEM_TICKET.card4] or 0
	local var_7_1 = arg_7_0.itemDiamondHalfCount:read() == 0 and dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.FirstRMBDrawItemHalf) ~= 0

	if arg_7_0.type == "one" then
		if gVipCsv[arg_7_0.vip:read()].drawItemCountLimit == arg_7_0.totalTime:read() then
			gGameUI:showTip(gLanguageCsv.todayDrawItemLimit)

			return
		end

		if var_7_1 and param ~= "free1" and arg_7_0.rmb:read() < gCommonConfigCsv.drawItemCostPrice / 2 then
			uiEasy.showDialog("rmb")

			return
		end

		if not var_7_1 and var_7_0 == 0 and arg_7_0.rmb:read() < gCommonConfigCsv.drawItemCostPrice and param ~= "free1" then
			uiEasy.showDialog("rmb")

			return
		end

		if var_7_1 and param ~= "free1" or not var_7_1 and var_7_0 == 0 and param ~= "free1" then
			dataEasy.sureUsingDiamonds(function()
				arg_7_0:onClose(1)
			end, var_7_1 and gCommonConfigCsv.drawItemCostPrice / 2 or gCommonConfigCsv.drawItemCostPrice)
		else
			arg_7_0:onClose(1)
		end
	else
		if gVipCsv[arg_7_0.vip:read()].drawItemCountLimit == arg_7_0.totalTime:read() then
			gGameUI:showTip(gLanguageCsv.todayDrawItemLimit)

			return
		elseif gVipCsv[arg_7_0.vip:read()].drawItemCountLimit - arg_7_0.totalTime:read() < 5 then
			gGameUI:showTip(gLanguageCsv.todayDrawItemTimesLessFive)

			return
		end

		if var_7_0 < 5 and arg_7_0.rmb:read() < gCommonConfigCsv.draw5ItemCostPrice then
			uiEasy.showDialog("rmb")

			return
		end

		if var_7_0 < 5 then
			dataEasy.sureUsingDiamonds(function()
				arg_7_0:onClose(5)
			end, gCommonConfigCsv.draw5ItemCostPrice)
		else
			arg_7_0:onClose(5)
		end
	end
end

function var_0_1.initModel(arg_10_0)
	arg_10_0.rmb = gGameModel.role:getIdler("rmb")
	arg_10_0.items = gGameModel.role:getIdler("items")
	arg_10_0.vip = gGameModel.role:getIdler("vip_level")
	arg_10_0.freeTime = gGameModel.daily_record:getIdler("item_dc1_free_counter")
	arg_10_0.totalTime = gGameModel.daily_record:getIdler("draw_item")
	arg_10_0.itemDiamondHalfCount = gGameModel.daily_record:getIdler("draw_item_rmb1_half")
end

function var_0_1.onClose(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.isStandby

	var_0_0.onClose(arg_11_0)

	if type(arg_11_1) == "number" then
		var_11_0:set(arg_11_1)
	else
		var_11_0:set(true)
	end
end

return var_0_1
