local var_0_0 = class("RandomTowerBuffDetailView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "random_tower_buff_detail.json"
var_0_0.RESOURCE_BINDING = {
	["baseNode.bg"] = "bg",
	baseNode = "baseNode",
	["baseNode.list"] = "list",
	touchPanel = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0, arg_1_1)
	local var_1_0 = csv.random_tower.buffs[arg_1_1.buffId]

	beauty.textScroll({
		isRich = true,
		fontSize = 40,
		list = arg_1_0.list,
		strs = "#C0xFFFFFF#" .. var_1_0.desc
	})

	local var_1_1 = arg_1_0.baseNode:size()
	local var_1_2 = arg_1_1.pos
	local var_1_3 = var_1_2.x + var_1_1.width / 2 + 200
	local var_1_4 = var_1_2.y - var_1_1.height / 2
	local var_1_5 = arg_1_0.bg:size()
	local var_1_6 = math.max(var_1_5.height / 2, var_1_4)
	local var_1_7 = math.min(var_1_6, display.height - var_1_5.height / 2)

	arg_1_0.baseNode:xy(var_1_3, var_1_7)
end

return var_0_0
