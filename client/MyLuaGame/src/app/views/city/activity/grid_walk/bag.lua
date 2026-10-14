local var_0_0 = require("app.views.city.activity.grid_walk.tools")
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("GridWalkBagView", var_0_1)

var_0_2.RESOURCE_FILENAME = "grid_walk_bag.json"
var_0_2.RESOURCE_BINDING = {
	["bgPanel.empty"] = "empty",
	["bgPanel.bg"] = "bg",
	item = "item",
	closePanel = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["bgPanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("itemDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("icon", "txt")
					local var_1_1 = beauty.singleTextLimitWord(arg_1_3.name, {
						fontSize = var_1_0.txt:getFontSize()
					}, {
						width = 240,
						onlyText = true
					})

					var_1_0.txt:text(var_1_1)

					local var_1_2 = {
						class = "icon_key",
						props = {
							data = {
								key = arg_1_3.key,
								num = arg_1_3.val
							}
						}
					}

					bind.extend(arg_1_0, var_1_0.icon, var_1_2)
				end,
				onAfterBuild = function(arg_2_0)
					arg_2_0:setItemAlignCenter()
					arg_2_0.afterBuild()
				end
			},
			handlers = {
				afterBuild = bindHelper.self("onAfterBuild")
			}
		}
	}
}

function var_0_2.onCreate(arg_3_0)
	arg_3_0.itemDatas = idlers.new()

	local var_3_0 = {}
	local var_3_1 = true

	for iter_3_0, iter_3_1 in pairs(var_0_0.CARDSBAG_ID) do
		local var_3_2 = dataEasy.getCfgByKey(iter_3_1)
		local var_3_3 = dataEasy.getNumByKey(iter_3_1)

		if var_3_3 > 0 then
			table.insert(var_3_0, {
				key = iter_3_1,
				val = var_3_3,
				name = var_3_2.name
			})

			var_3_1 = false
		end
	end

	if var_3_1 then
		arg_3_0.empty:show()
	else
		arg_3_0.itemDatas:update(var_3_0)
	end
end

function var_0_2.onAfterBuild(arg_4_0)
	local var_4_0 = arg_4_0.list:width()

	if var_4_0 > 0 then
		arg_4_0.bg:width(var_4_0 + 70)
	end
end

return var_0_2
