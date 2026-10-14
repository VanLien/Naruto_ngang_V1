local var_0_0 = class("FishDetailView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "common_fish_detail.json"
var_0_0.RESOURCE_BINDING = {
	["baseNode.lockPanel.lock1"] = "lock1",
	["baseNode.lockPanel.lock2"] = "lock2",
	["baseNode.lockPanel"] = "lockPanel",
	baseNode = "baseNode",
	["baseNode.list"] = "list",
	["baseNode.lockPanel.numlock"] = "numlock",
	["baseNode.content"] = "contentLabel",
	["baseNode.name"] = "nodeName",
	["baseNode.icon"] = {
		binds = {
			event = "extend",
			class = "fish_icon",
			props = {
				data = bindHelper.self("data"),
				onNode = function(arg_1_0)
					local var_1_0 = arg_1_0:size()

					arg_1_0:alignCenter(var_1_0)
					arg_1_0:scale(1.2)
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_2_0, arg_2_1)
	arg_2_0:initModel()

	local var_2_0 = arg_2_1.key

	arg_2_0.data = {
		key = var_2_0
	}

	local var_2_1 = csv.fishing.fish[var_2_0]

	arg_2_0.nodeName:text(var_2_1.name)
	text.addEffect(arg_2_0.nodeName, {
		color = ui.COLORS.QUALITY[var_2_1.rare + 2]
	}, {
		outline = {
			color = ui.COLORS.QUALITY_OUTLINE[var_2_1.rare + 2]
		}
	})

	if arg_2_0.fishLevel:read() < var_2_1.needLv then
		arg_2_0.lockPanel:show()
		arg_2_0.numlock:text(var_2_1.needLv)
		adapt.oneLinePos(arg_2_0.lock1, {
			arg_2_0.numlock,
			arg_2_0.lock2
		}, cc.p(0, 0), "left")
	end

	local var_2_2 = matchLanguage({
		"tw"
	}) and 38 or 40

	beauty.textScroll({
		isRich = true,
		list = arg_2_0.list,
		strs = "#C0x5B545B#" .. var_2_1.desc,
		fontSize = var_2_2
	})
end

function var_0_0.initModel(arg_3_0)
	arg_3_0.fishLevel = gGameModel.fishing:getIdler("level")
end

return var_0_0
