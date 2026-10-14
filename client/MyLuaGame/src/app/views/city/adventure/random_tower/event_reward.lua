local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("RandomTowerEventRewardView", var_0_0)

var_0_1.RESOURCE_FILENAME = "random_tower_event_reward.json"
var_0_1.RESOURCE_BINDING = {
	pos = "pos",
	item = "item",
	textTitle = "textTitle",
	list = {
		varname = "listview",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("eventDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("itemPanel", "textName")
					local var_1_1 = csv.items[dataEasy.stringMapingID(arg_1_3.key)]

					var_1_0.textName:text(var_1_1.name)

					local var_1_2 = false

					if arg_1_3.key == "gold" then
						var_1_2 = dataEasy.isDoubleHuodong("randomGold")
					end

					local var_1_3 = {
						class = "icon_key",
						props = {
							data = {
								key = arg_1_3.key,
								num = arg_1_3.num
							},
							isDouble = var_1_2
						}
					}

					bind.extend(arg_1_0, var_1_0.itemPanel, var_1_3)
				end,
				onAfterBuild = function(arg_2_0)
					arg_2_0:setItemAlignCenter()
				end
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1)
	arg_3_0.cb = arg_3_1.cb

	local var_3_0 = csv.random_tower.event[arg_3_1.eventId]
	local var_3_1 = dataEasy.mergeRawDate(arg_3_1.tb.view.items or {})

	if arg_3_1.tb.view.points then
		table.insert(var_3_1, {
			key = 417,
			num = arg_3_1.tb.view.points
		})
	end

	local var_3_2 = #var_3_1 > 0 and 180 or 0
	local var_3_3 = arg_3_1.choiceID or 1
	local var_3_4 = var_3_0["resultDesc" .. var_3_3]
	local var_3_5 = rich.createByStr(var_3_4, 50)

	var_3_5:formatText()

	if var_3_5:size().width > 1400 then
		var_3_5 = rich.createWithWidth(var_3_4, 50, nil, 1400)
	end

	var_3_5:anchorPoint(cc.p(0.5, 0.5)):addTo(arg_3_0.pos):xy(0, var_3_2)
	arg_3_0.textTitle:text(var_3_0.name)

	arg_3_0.eventDatas = var_3_1
end

function var_0_1.onClose(arg_4_0)
	arg_4_0:addCallbackOnExit(arg_4_0.cb)
	var_0_0.onClose(arg_4_0)
end

return var_0_1
