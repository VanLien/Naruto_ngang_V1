local var_0_0 = class("DrawcardPropertyDetailView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "drawcard_property_detail.json"
var_0_0.RESOURCE_BINDING = {
	subList = "subList",
	["previewPanel.img1"] = "img",
	icon = "icon",
	previewPanel = "previewPanel",
	["previewPanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				yMargin = 0,
				leftPadding = 0,
				asyncPreload = 12,
				xMargin = 30,
				topPadding = 15,
				data = bindHelper.self("showDatas"),
				columnSize = bindHelper.self("midColumnSize"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("icon"),
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					bind.extend(arg_1_0, arg_1_1, {
						class = "icon_key",
						props = {
							data = arg_1_3
						}
					})
					arg_1_1:scale(0.8)
					cc.Sprite:create("city/drawcard/draw/txt_up.png"):addTo(arg_1_1):xy(cc.p(arg_1_1:size().width - 30, arg_1_1:size().height)):z(5)
					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_1, arg_1_2, arg_1_3)
						}
					})
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_2_0, arg_2_1)
	local var_2_0 = {}

	for iter_2_0, iter_2_1 in pairs(arg_2_1) do
		table.insert(var_2_0, {
			key = "card",
			num = iter_2_1
		})
	end

	local var_2_1 = math.ceil(table.getn(arg_2_1) / 3)

	arg_2_0.img:height(var_2_1 * 185 - (var_2_1 - 2) * 14)

	arg_2_0.midColumnSize = 3
	arg_2_0.showDatas = idlers.new()

	arg_2_0.showDatas:update(var_2_0)
end

return var_0_0
