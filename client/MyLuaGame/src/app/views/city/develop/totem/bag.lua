local var_0_0 = class("TotemBag", Dialog)

var_0_0.RESOURCE_FILENAME = "totem_bag.json"
var_0_0.RESOURCE_BINDING = {
	["title.textTitle2"] = "textTitle2",
	["emptyPanel.emptyTxt"] = "emptyTxt",
	["goodPanel.item"] = "item1",
	emptyPanel = "emptyPanel",
	["title.textTitle1"] = "textTitle1",
	leftPanel = "leftPanel",
	["leftPanel.tabItem"] = "tabItem",
	goodPanel = "goodPanel",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["leftPanel.tabList"] = {
		varname = "tabList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("tabItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1.get(arg_1_1, "normal")
					local var_1_1 = arg_1_1.get(arg_1_1, "selected")
					local var_1_2

					if arg_1_3.select then
						var_1_0.hide(var_1_0)

						var_1_2 = var_1_1.show(var_1_1)
					else
						var_1_1.hide(var_1_1)

						var_1_2 = var_1_0.show(var_1_0)
					end

					var_1_2:get("txt"):getVirtualRenderer():setLineSpacing(-10):text(arg_1_3.name)
					text.addEffect(var_1_2:get("txt"), {
						outline = {
							color = cc.c3b(91, 84, 91)
						}
					})
					var_1_1:setTouchEnabled(false)
					bind.touch(arg_1_0, var_1_0, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	["goodPanel.list"] = {
		varname = "list1",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("showData"),
				item = bindHelper.self("item1"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1.get(arg_2_1, "list")

					uiEasy.createItemsToList(arg_2_0, var_2_0, arg_2_3.item, {
						margin = 25,
						scale = 1,
						sortFunc = function(arg_3_0, arg_3_1)
							return arg_3_0.key < arg_3_1.key
						end
					})
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_4_0)
	arg_4_0:initModel()
	arg_4_0.emptyPanel:hide()
	arg_4_0.goodPanel:hide()

	arg_4_0.showData = idlers.new({})
	arg_4_0.showTab = idler.new(1)
	arg_4_0.panel = {
		{
			node = arg_4_0.goodPanel,
			data = arg_4_0.normalTotem,
			txtNode = gLanguageCsv.totemNotHave
		},
		{
			node = arg_4_0.goodPanel,
			data = arg_4_0.specialTotem,
			txtNode = gLanguageCsv.totemNotHave
		}
	}
	arg_4_0.tabDatas = idlers.newWithMap({
		{
			fontSize = 50,
			name = gLanguageCsv.totemNormal
		},
		{
			fontSize = 50,
			name = gLanguageCsv.totemSpecial
		}
	})

	adapt.oneLinePos(arg_4_0.textTitle1, arg_4_0.textTitle2, cc.p(0, 0))

	if arg_4_0.tmp == 2 then
		arg_4_0.showTab:set(2)
	end

	arg_4_0.showTab:addListener(function(arg_5_0, arg_5_1)
		arg_4_0.tabDatas:atproxy(arg_5_1).select = false
		arg_4_0.tabDatas:atproxy(arg_5_0).select = true

		arg_4_0.panel[arg_5_1].node:hide()
		arg_4_0.panel[arg_5_0].node:show()

		local var_5_0 = itertools.isempty(arg_4_0.panel[arg_5_0].data)

		arg_4_0.emptyPanel:visible(var_5_0)
		arg_4_0.emptyTxt:text(arg_4_0.panel[arg_5_0].txtNode)
		arg_4_0.showData:update(arg_4_0.panel[arg_5_0].data)
	end)
	Dialog.onCreate(arg_4_0)
end

function var_0_0.initModel(arg_6_0)
	arg_6_0.items = gGameModel.role:read("items")
	arg_6_0.normalTotem = {}
	arg_6_0.specialTotem = {}

	local function var_6_0(arg_7_0)
		local var_7_0 = {}

		for iter_7_0, iter_7_1 in pairs(arg_7_0) do
			if csv.items[iter_7_0].type == game.ITEM_TYPE_ENUM_TABLE.totemType then
				table.insert(var_7_0, {
					csvId = iter_7_0,
					num = iter_7_1
				})
			end
		end

		table.sort(var_7_0, function(arg_8_0, arg_8_1)
			return arg_8_0.csvId < arg_8_1.csvId
		end)

		return var_7_0
	end

	local var_6_1 = {}
	local var_6_2 = {}
	local var_6_3 = var_6_0(arg_6_0.items)

	for iter_6_0, iter_6_1 in pairs(var_6_3) do
		if csv.items[iter_6_1.csvId].specialArgsMap.ease then
			if itertools.size(var_6_1) >= 6 then
				table.insert(arg_6_0.specialTotem, {
					item = var_6_1
				})

				var_6_1 = {}
			end

			table.insert(var_6_1, {
				key = iter_6_1.csvId,
				num = iter_6_1.num
			})
		else
			if itertools.size(var_6_2) >= 6 then
				table.insert(arg_6_0.normalTotem, {
					item = var_6_2
				})

				var_6_2 = {}
			end

			table.insert(var_6_2, {
				key = iter_6_1.csvId,
				num = iter_6_1.num
			})
		end
	end

	if not itertools.isempty(var_6_1) then
		table.insert(arg_6_0.specialTotem, {
			item = var_6_1
		})
	end

	if not itertools.isempty(var_6_2) then
		table.insert(arg_6_0.normalTotem, {
			item = var_6_2
		})
	end

	if not arg_6_0.tmp then
		arg_6_0.tmp = 0
	end
end

function var_0_0.onTabClick(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0.showTab:set(arg_9_2)

	arg_9_0.tmp = arg_9_2
end

return var_0_0
