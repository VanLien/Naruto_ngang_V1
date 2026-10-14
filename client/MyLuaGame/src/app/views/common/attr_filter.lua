local function var_0_0(arg_1_0)
	if not arg_1_0 then
		local var_1_0 = {}

		for iter_1_0 = 1, 5 do
			table.insert(var_1_0, {
				ui.ATTR_ICON[iter_1_0]
			})
		end

		return var_1_0
	end

	return ui.ATTR_ICON[arg_1_0]
end

local var_0_1 = class("AttrFilterView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "common_attr_filter.json"
var_0_1.RESOURCE_BINDING = {
	subList = "subList",
	item = "item",
	btnReset = {
		varname = "btnReset",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowAttrPanel")
			}
		}
	},
	btnOK = {
		varname = "btnOK",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSpecialClose")
			}
		}
	},
	list = {
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 24,
				columnSize = 6,
				data = bindHelper.self("attrDatas"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					arg_2_1:show()

					local var_2_0 = arg_2_0:getIdx(arg_2_2)

					arg_2_1:get("bg"):texture(var_0_0(var_2_0.k))
					arg_2_1:get("name"):text(gLanguageCsv[game.NATURE_TABLE[var_2_0.k]])
					arg_2_1:get("select"):visible(arg_2_3.state == true)
					arg_2_1:onClick(functools.partial(arg_2_0.itemClick, var_2_0, arg_2_3))
				end
			},
			handlers = {
				itemClick = bindHelper.self("onAttrItemClick")
			}
		}
	},
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSpecialClose")
			}
		}
	},
	closeBtn = {
		varname = "closeBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSpecialClose")
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1)
	arg_3_0.item:hide()

	local var_3_0 = arg_3_1.btnColse and true or false

	arg_3_0.isMultiSelect = arg_3_1.isMultiSelect

	arg_3_0.btnOK:visible(not var_3_0)
	arg_3_0.btnReset:visible(not var_3_0)
	arg_3_0.closeBtn:visible(var_3_0)

	arg_3_0.isShow = arg_3_1.panelState()

	if arg_3_0.isMultiSelect then
		arg_3_0.selectData = arg_3_1.selectDatas()
		arg_3_0.attrDatas = arg_3_0.selectData
	else
		arg_3_0.selectData = arg_3_1.selectDatas()
		arg_3_0.attrDatas = arraytools.map(var_0_0(), function(arg_4_0, arg_4_1)
			return {
				icon = arg_4_1
			}
		end)
	end
end

function var_0_1.onSpecialClose(arg_5_0)
	arg_5_0.isShow:set(false)
end

function var_0_1.onAttrItemClick(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if arg_6_0.isMultiSelect then
		arg_6_0.attrDatas:atproxy(arg_6_2.k).state = not arg_6_0.attrDatas:atproxy(arg_6_2.k).state
	else
		arg_6_0.selectData:set(arg_6_2.k, true)
		arg_6_0:onSpecialClose()
	end
end

function var_0_1.onShowAttrPanel(arg_7_0)
	if arg_7_0.isMultiSelect then
		local var_7_0 = {}

		for iter_7_0 = 1, 5 do
			table.insert(var_7_0, {
				state = false
			})
		end

		arg_7_0.attrDatas:update(var_7_0)
	else
		arg_7_0.selectData:set(5, true)
		arg_7_0:onSpecialClose()
	end
end

return var_0_1
