local var_0_0 = require("app.views.city.card.rebirth.tools")
local var_0_1 = require("app.views.city.card.helditem.tools")
local var_0_2 = 1
local var_0_3 = class("ChooseHeldItemView", Dialog)

var_0_3.RESOURCE_FILENAME = "rebirth_select_card.json"
var_0_3.RESOURCE_BINDING = {
	item = "item",
	innerList = "innerList",
	["tipPanel.textTip"] = "textTip",
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
				topPadding = 10,
				columnSize = 6,
				asyncPreload = 24,
				data = bindHelper.self("heldItemDatas"),
				item = bindHelper.self("innerList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:removeChildByName("name")
					arg_1_1:get("icon.imgSel"):visible(arg_1_3.isSel)
					bind.extend(arg_1_0, arg_1_1:get("icon"), {
						class = "icon_key",
						props = {
							noListener = true,
							data = {
								key = arg_1_3.csvId,
								num = arg_1_3.num,
								dbId = arg_1_3.dbId
							},
							specialKey = {
								lv = arg_1_3.lv
							},
							onNode = function(arg_2_0)
								local var_2_0 = arg_1_0:getIdx(arg_1_2)

								bind.click(arg_1_0, arg_2_0, {
									method = functools.partial(arg_1_0.clickCell, var_2_0, arg_1_3)
								})
							end
						}
					})

					local var_1_0 = csv.held_item.items[arg_1_3.csvId]
					local var_1_1 = var_1_0.name
					local var_1_2 = var_1_0.quality
					local var_1_3 = beauty.singleTextLimitWord(var_1_1, {
						fontSize = 40
					}, {
						width = 200
					}):xy(100, 17):addTo(arg_1_1, 2, "name")

					text.addEffect(var_1_3, {
						color = var_1_2 == 1 and ui.COLORS.NORMAL.DEFAULT or ui.COLORS.QUALITY[var_1_2]
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onCellClick")
			}
		}
	},
	["title.textNote1"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE1
				}
			}
		}
	},
	["title.textNote2"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE1
				}
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

function var_0_3.onCreate(arg_3_0, arg_3_1)
	arg_3_0.handlers = arg_3_1.handlers

	local var_3_0 = arg_3_1.curSel

	arg_3_0:initModel()
	adapt.setTextAdaptWithSize(arg_3_0.textTip, {
		vertical = "center",
		horizontal = "center",
		size = cc.size(500, 200)
	})

	arg_3_0.showTip = idler.new(false)
	arg_3_0.heldItemDatas = idlers.newWithMap({})

	local var_3_1 = {}
	local var_3_2 = 0
	local var_3_3 = csv.held_item.items

	for iter_3_0, iter_3_1 in ipairs(arg_3_0.myHeldItem:read()) do
		local var_3_4 = gGameModel.held_items:find(iter_3_1):read("exist_flag", "card_db_id", "advance", "level", "sum_exp", "held_item_id")

		if var_3_4.exist_flag and (var_3_4.sum_exp > 0 or var_3_4.advance > 0) then
			local var_3_5 = var_3_3[var_3_4.held_item_id]
			local var_3_6 = {
				cfg = var_3_5,
				csvId = var_3_4.held_item_id,
				dbId = iter_3_1
			}

			var_3_6.num = 1
			var_3_6.isSel = var_3_0 == iter_3_1
			var_3_6.cardDbID = var_3_4.card_db_id
			var_3_6.lv = var_3_4.level
			var_3_6.advance = var_3_4.advance

			local var_3_7, var_3_8 = var_0_1.isExclusive(var_3_6)

			var_3_6.isDress = var_3_7
			var_3_6.isExc = var_3_8

			table.insert(var_3_1, var_3_6)

			var_3_2 = var_3_2 + 1
		end
	end

	table.sort(var_3_1, function(arg_4_0, arg_4_1)
		local var_4_0 = arg_4_0.cfg.quality
		local var_4_1 = arg_4_1.cfg.quality

		if var_4_0 ~= var_4_1 then
			return var_4_1 < var_4_0
		end

		return arg_4_0.csvId > arg_4_1.csvId
	end)
	arg_3_0.heldItemDatas:update(var_3_1)
	arg_3_0.showTip:set(var_3_2 == 0)
	Dialog.onCreate(arg_3_0)
end

function var_0_3.initModel(arg_5_0)
	arg_5_0.myHeldItem = gGameModel.role:getIdler("held_items")
end

function var_0_3.onCellClick(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local function var_6_0()
		arg_6_0.heldItemDatas:atproxy(arg_6_2.k).isSel = true

		if arg_6_0.handlers then
			arg_6_0.handlers(arg_6_0.heldItemDatas:atproxy(arg_6_2.k))
		end

		arg_6_0:onClose()
	end

	if arg_6_3.isDress then
		local var_6_1 = uiEasy.getCardName(arg_6_3.cardDbID)
		local var_6_2 = string.format(gLanguageCsv.heldItemIsDress, var_6_1)
		local var_6_3 = {
			btnType = 2,
			isRich = true,
			cb = function()
				var_6_0()
			end,
			content = var_6_2
		}

		gGameUI:showDialog(var_6_3)
	else
		var_6_0()
	end
end

return var_0_3
