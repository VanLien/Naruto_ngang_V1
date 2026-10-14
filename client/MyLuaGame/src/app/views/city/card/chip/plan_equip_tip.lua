local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("ChipPlanEquipView", Dialog)

var_0_1.RESOURCE_FILENAME = "chip_plan_equip_tip.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	tip = "tip",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	titleTxt1 = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	btnCancel = {
		varname = "btnCancel",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnOk = {
		varname = "btnOk",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClickOk")
			}
		}
	},
	["btnOk.txt"] = {
		varname = "btnText",
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
	["btnCancel.txt"] = {
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
	list = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("data"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					bind.extend(arg_1_0, arg_1_1:get("chip"), {
						class = "icon_key",
						props = {
							noListener = true,
							data = {
								key = arg_1_3.chipId,
								dbId = arg_1_3.dbId
							},
							specialKey = {
								lv = arg_1_3.level
							},
							onNode = function(arg_2_0)
								arg_2_0:get("box"):hide()
								arg_2_0:get("imgFG"):hide()
								arg_2_0:get("defaultLv"):anchorPoint(0.5, 0):xy(arg_2_0:width() / 2, 30)
								arg_2_0:scale(1.1)
							end
						}
					})

					if arg_1_3.cardDBID then
						arg_1_1:get("line"):texture("city/card/chip/bar_1.png")
						arg_1_1:get("card.icon"):hide()
						arg_1_1:get("card.txt"):hide()

						local var_1_0 = gGameModel.cards:find(arg_1_3.cardDBID):read("card_id", "skin_id", "level", "star", "advance")
						local var_1_1 = csv.cards[var_1_0.card_id]
						local var_1_2 = csv.unit[var_1_1.unitID]
						local var_1_3 = dataEasy.getUnitId(var_1_0.card_id, var_1_0.skin_id)

						bind.extend(arg_1_0, arg_1_1:get("card"), {
							class = "card_icon",
							props = {
								unitId = var_1_3,
								advance = var_1_0.advance,
								rarity = var_1_2.rarity,
								star = var_1_0.star,
								levelProps = {
									data = var_1_0.level
								},
								onNode = function(arg_3_0)
									arg_3_0:alignCenter(arg_1_1:get("card"):size()):scale(0.9)
								end
							}
						})
					else
						arg_1_1:get("line"):texture("city/card/chip/bar_0.png")
						arg_1_1:get("card.icon"):show()
						arg_1_1:get("card.txt"):show()
					end
				end,
				onAfterBuild = function(arg_4_0)
					arg_4_0:setItemAlignCenter()
				end
			}
		}
	}
}

function var_0_1.onCreate(arg_5_0, arg_5_1)
	arg_5_0.params = arg_5_1

	local var_5_0 = {}
	local var_5_1 = 0

	for iter_5_0 = 1, table.maxn(arg_5_1.chips) do
		local var_5_2 = arg_5_1.chips[iter_5_0]

		if var_5_2 then
			local var_5_3 = gGameModel.chips:find(var_5_2):read("chip_id", "card_db_id", "level")

			if var_5_3.card_db_id then
				var_5_1 = var_5_1 + 1
			end

			table.insert(var_5_0, {
				dbId = var_5_2,
				chipId = var_5_3.chip_id,
				level = var_5_3.level,
				cardDBID = var_5_3.card_db_id
			})
		end
	end

	arg_5_0.data = var_5_0

	arg_5_0.tip:text(string.format(gLanguageCsv.chipPlanUsedTip, var_5_1))
	Dialog.onCreate(arg_5_0)
end

function var_0_1.onClickOk(arg_6_0)
	arg_6_0:addCallbackOnExit(arg_6_0.params.cb)
	arg_6_0:onCloseFast()

	return arg_6_0
end

return var_0_1
