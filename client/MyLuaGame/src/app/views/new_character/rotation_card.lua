local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("RotationCardView", var_0_0)

var_0_1.RESOURCE_FILENAME = "character_rotation_card.json"
var_0_1.RESOURCE_BINDING = {
	["bottomCenterPanel.attr"] = "attr",
	["bottomCenterPanel.name"] = {
		varname = "nodeName",
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
	centerPanel = {
		binds = {
			event = "extend",
			class = "rotation_spine",
			props = {
				a = 500,
				minScale = 0.5,
				b = 170,
				maxScale = 0.8,
				data = bindHelper.self("ids"),
				unitRes = bindHelper.self("unitRes"),
				textNode = bindHelper.self("nodeName"),
				icon = bindHelper.self("attr"),
				onNode = function(arg_1_0, arg_1_1)
					arg_1_1:y(450)
				end,
				clickCb = function(arg_2_0, arg_2_1)
					gGameUI:stackUI("new_character.select_card", nil, nil, arg_2_1, arg_2_0.clickClose)
				end
			},
			handlers = {
				clickClose = bindHelper.self("onClose")
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1)
	arg_3_0.cb = arg_3_1
	arg_3_0.ids = {}
	arg_3_0.unitRes = {
		"koudai_miaowazhongzi2/miaowazhongzi2.skel",
		"koudai_xiaohuolong2/xiaohuolong2.skel",
		"koudai_jienigui2/jienigui_zhanshi2.skel"
	}

	for iter_3_0, iter_3_1 in ipairs(csv.newbie_init[1].cards) do
		table.insert(arg_3_0.ids, iter_3_1.id)
	end

	local var_3_0 = csv.cards[arg_3_0.ids[2]]
	local var_3_1 = csv.unit[var_3_0.unitID]

	arg_3_0.nodeName:text(var_3_0.name)
	arg_3_0.attr:texture(ui.ATTR_ICON[var_3_1.natureType])
end

function var_0_1.onClose(arg_4_0)
	arg_4_0:addCallbackOnExit(arg_4_0.cb)
	var_0_0.onClose(arg_4_0)
end

return var_0_1
