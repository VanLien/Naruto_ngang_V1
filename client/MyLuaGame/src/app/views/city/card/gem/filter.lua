local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("GemFilterView", var_0_0)

var_0_1.RESOURCE_FILENAME = "gem_filter.json"
var_0_1.RESOURCE_BINDING = {
	subList = "subList",
	item = "item",
	window = "window",
	["window.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 4,
				data = bindHelper.self("showData"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("icon"):texture(arg_1_3.icon)

					if arg_1_3.selected then
						ccui.ImageView:create("common/box/box_selected.png"):alignCenter(arg_1_1:size()):addTo(arg_1_1, -1):scale(0.6):y(94)
					end

					arg_1_1:get("name"):text(gLanguageCsv["gemSuit" .. arg_1_3.typeIdx])
					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_1, arg_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	},
	closePanel = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("closeWithoutSelect")
			}
		}
	},
	["window.btnAll.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE
				}
			}
		}
	},
	["window.btnAll"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("clickAll")
			}
		}
	}
}

function var_0_1.closeWithoutSelect(arg_2_0)
	arg_2_0:addCallbackOnExit(arg_2_0.cb)
	var_0_0.onClose(arg_2_0)
end

function var_0_1.clickAll(arg_3_0)
	arg_3_0:addCallbackOnExit(functools.partial(arg_3_0.cb, 0))
	var_0_0.onClose(arg_3_0)
end

function var_0_1.onItemClick(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	arg_4_0:addCallbackOnExit(functools.partial(arg_4_0.cb, arg_4_4.typeIdx))
	var_0_0.onClose(arg_4_0)
end

function var_0_1.onCreate(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	arg_5_2 = arg_5_2 or {}

	local var_5_0 = arg_5_0.window:size()
	local var_5_1 = {
		left = var_5_0.width / 2,
		right = -var_5_0.width / 2
	}
	local var_5_2 = {
		top = -var_5_0.height / 2,
		bottom = var_5_0.height / 2
	}
	local var_5_3 = 0
	local var_5_4 = 0

	for iter_5_0, iter_5_1 in pairs(arg_5_2) do
		if var_5_1[iter_5_1] then
			var_5_3 = var_5_1[iter_5_1]
		end

		if var_5_2[iter_5_1] then
			var_5_4 = var_5_2[iter_5_1]
		end
	end

	arg_5_0.window:xy(arg_5_1.x + var_5_3, arg_5_1.y + var_5_4)

	arg_5_0.showData = idlers.new()

	local var_5_5 = {}

	for iter_5_2 = 1, 9 do
		table.insert(var_5_5, {
			icon = ui.GEM_SUIT_ICON[iter_5_2],
			typeIdx = iter_5_2,
			selected = iter_5_2 == arg_5_4
		})
	end

	arg_5_0.cb = arg_5_3

	arg_5_0.list:setClippingEnabled(false)
	arg_5_0.showData:update(var_5_5)
end

return var_0_1
