local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("ActivityBossDetail", Dialog)

var_0_1.RESOURCE_FILENAME = "activity_boss_clearance.json"
var_0_1.RESOURCE_BINDING = {
	["centerPanel.item"] = "item",
	centerPanel = "centerPanel",
	emptyPanel = "emptyPanel",
	["centerPanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("roleDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("icon", "name", "lvNum", "area", "fighting")

					bind.extend(arg_1_0, var_1_0.icon, {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_1_3.logo,
							frameId = arg_1_3.frame,
							onNode = function(arg_2_0)
								arg_2_0:scale(0.8)
							end
						}
					})
					var_1_0.name:text(arg_1_3.name)
					var_1_0.lvNum:text(arg_1_3.level)
					var_1_0.area:text(string.format(gLanguageCsv.brackets, getServerArea(arg_1_3.game_key)))
					var_1_0.area:x(var_1_0.area:x() - 35)
					var_1_0.fighting:text(arg_1_3.fight_point)
				end
			}
		}
	},
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1)
	arg_3_0.item:hide()

	arg_3_0.roleDatas = arg_3_1

	arg_3_0.emptyPanel:visible(#arg_3_1 == 0)
	arg_3_0.centerPanel:visible(#arg_3_1 > 0)
	Dialog.onCreate(arg_3_0)
end

return var_0_1
