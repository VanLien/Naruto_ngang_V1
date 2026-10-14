local var_0_0 = class("CloneBattleSpriteList", Dialog)

var_0_0.RESOURCE_FILENAME = "clone_battle_spr_show.json"
var_0_0.RESOURCE_BINDING = {
	item = "item",
	showPanel = "showPanel",
	["showPanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("natureDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_3.natureId
					local var_1_1 = arg_1_1:multiget("natureImg", "text", "spr1", "spr2", "spr3")

					var_1_1.natureImg:texture(ui.SKILL_ICON[var_1_0])
					var_1_1.text:text(gLanguageCsv[game.NATURE_TABLE[var_1_0]] .. gLanguageCsv.talentElement)
					text.addEffect(var_1_1.text, {
						outline = {
							size = 4,
							color = ui.COLORS.OUTLINE.WHITE
						},
						color = ui.COLORS.ATTR[var_1_0]
					})

					local var_1_2 = gGameModel.role:read("pokedex")
					local var_1_3 = {}

					for iter_1_0, iter_1_1 in pairs(var_1_2) do
						var_1_3[csv.cards[iter_1_0].cardMarkID] = true
					end

					for iter_1_2 = 1, 3 do
						local var_1_4 = arg_1_3.spriteTb[iter_1_2]
						local var_1_5 = var_1_1["spr" .. iter_1_2]

						var_1_5:visible(var_1_4 and true or false)

						if var_1_4 then
							var_1_5:texture(var_1_4.config.iconSimple)
							var_1_5:get("text"):text(var_1_4.config.name)

							if not var_1_4.inBox then
								cache.setShader(var_1_5, false, "hsl_gray")
							end
						end
					end
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0.natureDatas = arg_2_1

	local var_2_0 = #arg_2_1
	local var_2_1 = arg_2_0.item:size().height
	local var_2_2 = (var_2_1 + 20) * var_2_0 - 20

	arg_2_0.list:height(var_2_2):xy(25, 50)
	arg_2_0.showPanel:height(var_2_2 + 98):xy(arg_2_2 - arg_2_0.showPanel:size().width - 70, 1000 - (var_2_2 - var_2_1 - 20))
	Dialog.onCreate(arg_2_0, {
		noBlackLayer = true,
		clickClose = true
	})
end

return var_0_0
