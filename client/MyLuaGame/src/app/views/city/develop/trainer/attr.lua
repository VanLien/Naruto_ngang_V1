local var_0_0 = class("TrainAttrAdd", Dialog)

var_0_0.RESOURCE_FILENAME = "trainer_attr.json"
var_0_0.RESOURCE_BINDING = {
	subList = "subList",
	item = "item",
	name = "nodeName",
	pos = "pos",
	titleTxt = {
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
	list = {
		varname = "attrList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 6,
				columnSize = 2,
				data = bindHelper.self("attrDatas"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("icon", "name")
					local var_1_1 = game.ATTRDEF_TABLE[arg_1_3.id]

					var_1_0.icon:texture(ui.ATTR_LOGO[var_1_1])
					var_1_0.name:text(getLanguageAttr(arg_1_3.id) .. " +" .. dataEasy.getAttrValueString(arg_1_3.id, arg_1_3.num))
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

function var_0_0.onCreate(arg_2_0, arg_2_1)
	arg_2_0.data = arg_2_1()

	local var_2_0 = {}

	for iter_2_0, iter_2_1 in csvPairs(arg_2_0.data.cfg.attrs) do
		table.insert(var_2_0, {
			id = iter_2_0,
			num = iter_2_1
		})
	end

	arg_2_0.attrDatas = idlertable.new(var_2_0)

	arg_2_0.nodeName:text(arg_2_0.data.cfg.name)

	local var_2_1

	var_2_1 = arg_2_0.data.level < 7 and "1_6" or "7_12"

	widget.addAnimation(arg_2_0.pos, "config/trainer/trainer_" .. arg_2_0.data.level .. ".png", "", 2):alignCenter(arg_2_0.pos:size()):scale(1)
	Dialog.onCreate(arg_2_0)
end

return var_0_0
