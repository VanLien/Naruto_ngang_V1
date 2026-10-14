local var_0_0 = {
	gLanguageCsv.huntingCureTips,
	gLanguageCsv.huntingCureTips,
	gLanguageCsv.huntingReviveTips
}
local var_0_1 = {
	{
		res = "city/adventure/hunting/box_green.png",
		color = cc.c4b(68, 185, 117, 255)
	},
	{
		res = "city/adventure/hunting/box_yellow.png",
		color = cc.c4b(202, 153, 35, 255)
	},
	{
		res = "city/adventure/hunting/box_blue.png",
		color = cc.c4b(65, 142, 177, 255)
	},
	{
		res = "city/adventure/hunting/box_orange.png",
		color = cc.c4b(227, 118, 84, 255)
	},
	{
		res = "city/adventure/hunting/box_pink.png",
		color = cc.c4b(217, 85, 118, 255)
	},
	{
		res = "city/adventure/hunting/box_purple.png",
		color = cc.c4b(165, 82, 193, 255)
	},
	{
		res = "city/adventure/hunting/box_red.png",
		color = cc.c4b(227, 98, 91, 255)
	}
}
local var_0_2 = {
	all = 2,
	single = 1,
	resurrect = 3
}
local var_0_3 = cc.load("mvc").ViewBase
local var_0_4 = class("HuntingSupplyView", var_0_3)

var_0_4.RESOURCE_FILENAME = "hunting_supply.json"
var_0_4.RESOURCE_BINDING = {
	item = "item",
	title = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(192, 91, 69, 255)
				}
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				padding = 10,
				data = bindHelper.self("eventDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("bg", "name", "icon", "select", "text")

					var_1_0.select:visible(arg_1_3.isSel)
					var_1_0.name:text(arg_1_3.name)
					text.addEffect(var_1_0.name, {
						color = var_0_1[arg_1_3.quality].color
					})
					var_1_0.bg:texture(var_0_1[arg_1_3.quality].res)
					var_1_0.icon:texture(arg_1_3.icon)
					var_1_0.text:removeChildByName("richText")

					local var_1_1 = rich.createByStr("#C0xFFFFFF#" .. arg_1_3.desc, 40, nil):xy(var_1_0.text:width() / 2, var_1_0.text:y() / 2):anchorPoint(0.5, 0.5):addTo(var_1_0.text, 100, "richText"):formatText()

					var_1_0.text:text("")
					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	},
	["btnSure.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	btnSure = {
		varname = "eventSure",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSure")
			}
		}
	}
}

function var_0_4.onCreate(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.params = arg_2_1
	arg_2_0.cb = arg_2_2

	arg_2_0:initModel()
	arg_2_0.selectNum:addListener(function(arg_3_0, arg_3_1)
		if arg_2_0.eventDatas:atproxy(arg_3_1) then
			arg_2_0.eventDatas:atproxy(arg_3_1).isSel = false
		end

		if arg_2_0.eventDatas:atproxy(arg_3_0) then
			arg_2_0.eventDatas:atproxy(arg_3_0).isSel = true
		end
	end)
end

function var_0_4.onClose(arg_4_0)
	arg_4_0:addCallbackOnExit(arg_4_0.cb, true)
	var_0_3.onClose(arg_4_0)

	return arg_4_0
end

function var_0_4.initModel(arg_5_0)
	arg_5_0.selectNum = idler.new(1)
	arg_5_0.eventDatas = idlers.newWithMap({})

	local var_5_0 = {}

	for iter_5_0, iter_5_1 in orderCsvPairs(csv.cross.hunting.supply) do
		if iter_5_1.group == arg_5_0.params.group then
			table.insert(var_5_0, {
				isSel = false,
				id = iter_5_0,
				name = iter_5_1.name,
				type = iter_5_1.type,
				icon = iter_5_1.icon,
				desc = iter_5_1.desc,
				quality = iter_5_1.quality
			})
		end
	end

	arg_5_0.eventDatas:update(var_5_0)
end

function var_0_4.onItemClick(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_0.selectNum:set(arg_6_2)
end

function var_0_4.onSure(arg_7_0)
	local var_7_0 = csv.cross.hunting.supply[arg_7_0.selectNum:read()]
	local var_7_1 = gGameModel.hunting:read("hunting_route")[arg_7_0.params.route].card_states or {}
	local var_7_2 = false
	local var_7_3 = false

	for iter_7_0, iter_7_1 in pairs(var_7_1) do
		if iter_7_1[1] < 1 and iter_7_1[1] > 0 then
			var_7_3 = true
		elseif iter_7_1[1] == 0 then
			var_7_2 = true
		end
	end

	local function var_7_4()
		gGameApp:requestServer("/game/hunting/supply", function(arg_9_0)
			arg_7_0:onClose()
		end, arg_7_0.params.route, arg_7_0.params.node, arg_7_0.eventDatas:atproxy(arg_7_0.selectNum:read()).id)
	end

	local var_7_5 = {
		isRich = false,
		btnType = 2,
		size = {
			width = 850,
			height = 460
		},
		cb = var_7_4,
		content = var_0_0[var_7_0.type],
		dialogParams = {
			clickClose = false
		}
	}

	if var_7_0.type == var_0_2.single then
		if var_7_3 then
			gGameUI:stackUI("city.adventure.hunting.supply_detail", nil, nil, {
				route = arg_7_0.params.route,
				node = arg_7_0.params.node,
				cb = arg_7_0:createHandler("onClose"),
				type = var_0_2.single,
				csvId = arg_7_0.eventDatas:atproxy(arg_7_0.selectNum:read()).id
			})
		else
			gGameUI:showDialog(var_7_5)
		end
	elseif var_7_0.type == var_0_2.all then
		if var_7_3 then
			gGameApp:requestServer("/game/hunting/supply", function(arg_10_0)
				arg_7_0:onClose()
			end, arg_7_0.params.route, arg_7_0.params.node, arg_7_0.eventDatas:atproxy(arg_7_0.selectNum:read()).id)
		else
			gGameUI:showDialog(var_7_5)
		end
	elseif var_7_0.type == var_0_2.resurrect then
		if var_7_2 then
			gGameUI:stackUI("city.adventure.hunting.supply_detail", nil, nil, {
				route = arg_7_0.params.route,
				node = arg_7_0.params.node,
				cb = arg_7_0:createHandler("onClose"),
				type = var_0_2.resurrect,
				csvId = arg_7_0.eventDatas:atproxy(arg_7_0.selectNum:read()).id
			})
		else
			gGameUI:showDialog(var_7_5)
		end
	end
end

return var_0_4
