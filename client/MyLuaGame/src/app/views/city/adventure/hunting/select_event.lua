local var_0_0 = {
	boxDropLibs = 1,
	supplyGroup = 2
}
local var_0_1 = {
	{
		"city/adventure/hunting/box_orange.png",
		"city/adventure/hunting/img_ptxlj.png",
		gLanguageCsv.commonPk
	},
	{
		"city/adventure/hunting/box_purple.png",
		"city/adventure/hunting/img_jyxlj.png",
		gLanguageCsv.seniorPk
	},
	{
		"city/adventure/hunting/box_pink.png",
		"city/adventure/hunting/img_sqbbzx@.png",
		gLanguageCsv.huntingCure
	}
}
local var_0_2 = {
	cc.c3b(255, 255, 235, 1),
	cc.c3b(189, 6, 236, 1),
	(cc.c3b(246, 37, 9, 1))
}
local var_0_3 = {
	eliteGate = 2,
	normalGate = 1,
	careCenter = 3
}
local var_0_4 = cc.load("mvc").ViewBase
local var_0_5 = class("HuntingSelectEventView", var_0_4)

var_0_5.RESOURCE_FILENAME = "hunting_select_event.json"
var_0_5.RESOURCE_BINDING = {
	item = "item",
	title = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 6,
					color = cc.c3b(192, 91, 69, 1)
				}
			}
		}
	},
	list = {
		varname = "eventList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("eventDatas"),
				item = bindHelper.self("item"),
				margin = bindHelper.self("eventMargin"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("bg", "icon", "select", "name")

					if arg_1_3.type == var_0_3.normalGate then
						var_1_0.bg:texture(var_0_1[1][1])
						var_1_0.icon:texture(var_0_1[1][2])
						var_1_0.name:text(var_0_1[1][3])
						text.addEffect(var_1_0.name, {
							color = var_0_2[1]
						})
					elseif arg_1_3.type == var_0_3.eliteGate then
						var_1_0.bg:texture(var_0_1[2][1])
						var_1_0.icon:texture(var_0_1[2][2])
						var_1_0.name:text(var_0_1[2][3])
						text.addEffect(var_1_0.name, {
							color = var_0_2[2]
						})
					else
						var_1_0.bg:texture(var_0_1[3][1])
						var_1_0.icon:texture(var_0_1[3][2])
						var_1_0.name:text(var_0_1[3][3])
						text.addEffect(var_1_0.name, {
							color = var_0_2[3]
						})
					end

					var_1_0.select:visible(arg_1_3.select)
					bind.touch(arg_1_0, arg_1_1, {
						clicksafe = false,
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2)
						}
					})
				end,
				onAfterBuild = function(arg_2_0)
					arg_2_0:setItemAlignCenter()
				end
			},
			handlers = {
				clickCell = bindHelper.self("clickCell")
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
				ended = bindHelper.self("onEventSure")
			}
		}
	}
}

function var_0_5.onCreate(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.node = arg_3_1
	arg_3_0.cb = arg_3_2
	arg_3_0.selectNum = 1
	arg_3_0.eventMargin = 100
	arg_3_0.eventDatas = idlers.new()

	arg_3_0:initModel()
end

function var_0_5.initModel(arg_4_0)
	local var_4_0 = {}
	local var_4_1 = csv.cross.hunting.route[arg_4_0.node]

	arg_4_0.routeType = var_4_1.routeTag

	local var_4_2 = {}

	for iter_4_0, iter_4_1 in pairs(var_4_1.gateIDs) do
		local var_4_3 = csv.cross.hunting.gate[iter_4_1].type

		table.insert(var_4_2, {
			id = iter_4_1,
			type = var_4_3
		})
	end

	table.sort(var_4_2, function(arg_5_0, arg_5_1)
		return arg_5_0.type < arg_5_1.type
	end)

	if var_4_1.supplyGroup > 0 then
		table.insert(var_4_2, {
			id = -1,
			type = 3
		})
	end

	for iter_4_2, iter_4_3 in pairs(var_4_2) do
		if iter_4_2 == 1 then
			iter_4_3.select = true
		else
			iter_4_3.select = false
		end
	end

	arg_4_0.data = var_4_2
	arg_4_0.eventMargin = itertools.size(var_4_2) == 2 and 400 or 100

	arg_4_0.eventDatas:update(var_4_2)
	arg_4_0.eventList:setTouchEnabled(false)
end

function var_0_5.onClose(arg_6_0)
	arg_6_0:addCallbackOnExit(arg_6_0.cb, true)
	var_0_4.onClose(arg_6_0)

	return arg_6_0
end

function var_0_5.clickCell(arg_7_0, arg_7_1, arg_7_2)
	for iter_7_0 = 1, #arg_7_0.data do
		if iter_7_0 == arg_7_2 then
			arg_7_0.eventDatas:atproxy(iter_7_0).select = true
		else
			arg_7_0.eventDatas:atproxy(iter_7_0).select = false
		end
	end

	arg_7_0.selectNum = arg_7_2
end

function var_0_5.onEventSure(arg_8_0)
	local var_8_0
	local var_8_1 = arg_8_0.data[arg_8_0.selectNum].id == -1 and 2 or arg_8_0.data[arg_8_0.selectNum].id

	gGameApp:requestServer("/game/hunting/board/choose", function(arg_9_0)
		arg_8_0:onClose()
	end, arg_8_0.routeType, arg_8_0.node, var_8_1)
end

return var_0_5
