local var_0_0 = {
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
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("HuntingSelectBuffView", var_0_1)

var_0_2.RESOURCE_FILENAME = "hunting_select_buff.json"
var_0_2.RESOURCE_BINDING = {
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
						color = var_0_0[arg_1_3.quality].color
					})
					var_1_0.bg:texture(var_0_0[arg_1_3.quality].res)
					var_1_0.icon:texture(arg_1_3.icon)
					beauty.textScroll({
						isRich = true,
						align = "center",
						list = var_1_0.text,
						strs = "#C0xFCFFE7#" .. arg_1_3.desc,
						fontSize = ui.FONT_SIZE
					})
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

function var_0_2.onCreate(arg_2_0, arg_2_1)
	arg_2_0.params = arg_2_1

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

function var_0_2.initModel(arg_4_0)
	arg_4_0.selectNum = idler.new(1)
	arg_4_0.eventDatas = idlers.newWithMap({})

	local var_4_0 = {}
	local var_4_1 = gGameModel.hunting:read("hunting_route")[arg_4_0.params.route].board_buffs

	for iter_4_0, iter_4_1 in ipairs(var_4_1) do
		local var_4_2 = csv.cross.hunting.buffs[iter_4_1]

		table.insert(var_4_0, {
			isSel = false,
			id = iter_4_1,
			name = var_4_2.name,
			type = var_4_2.type,
			icon = var_4_2.icon,
			quality = var_4_2.quality,
			desc = var_4_2.desc
		})
	end

	arg_4_0.eventDatas:update(var_4_0)
end

function var_0_2.onItemClick(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_0.selectNum:set(arg_5_2)
end

function var_0_2.onSure(arg_6_0)
	gGameApp:requestServer("/game/hunting/battle/choose", function(arg_7_0)
		if arg_6_0.params.cb then
			arg_6_0:addCallbackOnExit(arg_6_0.params.cb)
		end

		arg_6_0:onClose()
	end, arg_6_0.params.route, arg_6_0.params.node, arg_6_0.selectNum:read())
end

return var_0_2
