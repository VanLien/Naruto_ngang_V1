local var_0_0 = class("NatureAttrInfoView", Dialog)

var_0_0.RESOURCE_FILENAME = "card_nature_attr.json"
var_0_0.RESOURCE_BINDING = {
	curFlag = "curFlag",
	item = "item",
	topList = "topList",
	textNote2 = "textNote2",
	rightList = "rightList",
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
			class = "listview",
			props = {
				data = bindHelper.self("attrDatas"),
				item = bindHelper.self("curFlag"),
				natureTypes = bindHelper.self("natureTypes"),
				cell = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_3.key
					local var_1_1 = game.NATURE_ENUM_TABLE[var_1_0]

					arg_1_1:get("imgIcon"):visible(itertools.include(arg_1_0.natureTypes, var_1_1))

					local var_1_2 = {}

					for iter_1_0 = 1, 5 do
						table.insert(var_1_2, arg_1_3.data[game.NATURE_TABLE[iter_1_0]])
					end

					bind.extend(arg_1_0, arg_1_1:get("list"), {
						class = "listview",
						props = {
							data = var_1_2,
							item = arg_1_0.cell,
							onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
								arg_2_1:get("textNote"):text(arg_2_3)

								local var_2_0 = ui.COLORS.NORMAL.DEFAULT

								if arg_2_3 > 1 then
									var_2_0 = ui.COLORS.NORMAL.FRIEND_GREEN
								elseif arg_2_3 < 1 then
									var_2_0 = ui.COLORS.NORMAL.RED
								elseif arg_2_3 == 0 then
									var_2_0 = ui.COLORS.NORMAL.ALERT_ORANGE
								end

								text.addEffect(arg_2_1:get("textNote"), {
									color = var_2_0
								})
							end
						}
					})
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_3_0, arg_3_1)
	arg_3_0.rightList:setScrollBarEnabled(false)
	arg_3_0.topList:setScrollBarEnabled(false)
	adapt.setAutoText(arg_3_0.textNote2, arg_3_0.textNote2:text(), nil)

	arg_3_0.cardId = gGameModel.cards:find(arg_3_1):read("card_id")

	local var_3_0 = csv.cards[arg_3_0.cardId].unitID
	local var_3_1 = csv.unit[var_3_0]

	arg_3_0.natureTypes = {
		var_3_1.natureType
	}

	if var_3_1.natureType2 then
		table.insert(arg_3_0.natureTypes, var_3_1.natureType2)
	end

	arg_3_0.attrDatas = idlers.newWithMap({})

	local var_3_2 = {}

	for iter_3_0 = 1, 5 do
		local var_3_3 = csv.base_attribute.nature_matrix[iter_3_0]

		table.insert(var_3_2, {
			key = game.NATURE_TABLE[iter_3_0],
			data = var_3_3
		})
	end

	arg_3_0.attrDatas:update(var_3_2)
	Dialog.onCreate(arg_3_0)
end

return var_0_0
