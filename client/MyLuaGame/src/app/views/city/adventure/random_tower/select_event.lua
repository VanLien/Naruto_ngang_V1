local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("RandomTowerSelectEventView", var_0_0)

var_0_1.RESOURCE_FILENAME = "random_tower_select_event.json"
var_0_1.RESOURCE_BINDING = {
	textTitle = "textTitle",
	item = "item",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	list = {
		varname = "listview",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("eventDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("textOrder", "textDesc")

					var_1_0.textOrder:text(arg_1_2)
					var_1_0.textDesc:text(arg_1_3.name)
					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3)
						}
					})
				end,
				onAfterBuild = function(arg_2_0)
					arg_2_0:setItemAlignCenter()
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_0.cb = arg_3_2
	arg_3_0.boardID = arg_3_1

	arg_3_0:initModel()

	if arg_3_3 then
		arg_3_0.type = "jump"
		arg_3_0.eventId = arg_3_3
	else
		arg_3_0.type = "common"
		arg_3_0.eventId = arg_3_0.roomInfo:read().event[arg_3_1]
	end

	local var_3_0 = csv.random_tower.event[arg_3_0.eventId]

	arg_3_0.textTitle:text(var_3_0.desc)

	if matchLanguage({
		"kr",
		"en"
	}) then
		arg_3_0.textTitle:x(display.sizeInView.width / 2)
		adapt.setTextAdaptWithSize(arg_3_0.textTitle, {
			size = cc.size(1900, 150)
		})
	end

	local var_3_1 = {}

	for iter_3_0 = 1, 3 do
		local var_3_2 = var_3_0["choice" .. iter_3_0]

		if var_3_0["choice" .. iter_3_0] ~= "" then
			table.insert(var_3_1, {
				key = iter_3_0,
				name = var_3_2
			})
		end
	end

	arg_3_0.eventDatas = var_3_1
end

function var_0_1.initModel(arg_4_0)
	arg_4_0.roomInfo = gGameModel.random_tower:getIdler("room_info")
end

function var_0_1.onItemClick(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if arg_5_0.type == "jump" then
		local var_5_0 = {
			false
		}

		gGameApp:requestServerCustom("/game/random_tower/jump/event"):params(arg_5_0.boardID, "choice" .. arg_5_3.key):onResponse(function(arg_6_0)
			var_5_0[1] = true
		end):wait(var_5_0):doit(function(arg_7_0)
			local var_7_0 = arg_5_0.eventId

			var_0_0.onClose(arg_5_0)
			gGameUI:stackUI("city.adventure.random_tower.event_reward", nil, {
				clickClose = true
			}, {
				eventId = var_7_0,
				tb = arg_7_0,
				choiceID = arg_5_3.key,
				cb = function()
					return
				end
			})
		end)
	else
		local var_5_1 = {
			false
		}

		gGameApp:requestServerCustom("/game/random_tower/event/choose"):params("choice" .. arg_5_3.key):onResponse(function(arg_9_0)
			var_5_1[1] = true
		end):wait(var_5_1):doit(function(arg_10_0)
			local var_10_0 = arg_5_0.eventId
			local var_10_1 = arg_5_0.cb

			var_0_0.onClose(arg_5_0)
			gGameUI:stackUI("city.adventure.random_tower.event_reward", nil, {
				clickClose = true
			}, {
				eventId = var_10_0,
				tb = arg_10_0,
				choiceID = arg_5_3.key,
				cb = var_10_1
			})
		end)
	end
end

return var_0_1
