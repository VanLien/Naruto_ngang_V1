local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("HistoryView", Dialog)

var_0_1.RESOURCE_FILENAME = "clone_battle_history.json"
var_0_1.RESOURCE_BINDING = {
	title = "title",
	["showPanel.list"] = "list",
	["showPanel.item"] = "item",
	allPanel = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	}
}

local var_0_2 = {
	gLanguageCsv.cloneBattleRecord1,
	gLanguageCsv.cloneBattleRecord2,
	gLanguageCsv.cloneBattleRecord3,
	gLanguageCsv.cloneBattleRecord4,
	gLanguageCsv.cloneBattleRecord5,
	gLanguageCsv.cloneBattleRecord6,
	gLanguageCsv.cloneBattleRecord7
}

function var_0_1.onCreate(arg_1_0, arg_1_1)
	Dialog.onCreate(arg_1_0)

	local var_1_0 = gGameModel.forever_dispatch:getIdlerOrigin("cloneBattleLookHistory"):read()

	gGameModel.forever_dispatch:getIdlerOrigin("cloneBattleLookHistory"):set(var_1_0 + 1)
	arg_1_0.list:setScrollBarEnabled(false)
	arg_1_0.list:setItemsMargin(0)

	local var_1_1 = arg_1_1.historyTab or {}

	arg_1_0.refreshNumber = arg_1_1.refreshNumber

	userDefault.setForeverLocalKey("cloneBattleHistory", var_1_1, {
		new = true
	})

	local var_1_2 = {}

	for iter_1_0, iter_1_1 in ipairs(var_1_1) do
		local var_1_3 = time.getDate(iter_1_1.time)
		local var_1_4 = string.formatex(gLanguageCsv.timeMonthDay, {
			month = var_1_3.month,
			day = var_1_3.day
		})

		var_1_2[var_1_4] = var_1_2[var_1_4] or {}

		table.insert(var_1_2[var_1_4], iter_1_1)
	end

	for iter_1_2, iter_1_3 in pairs(var_1_2) do
		local var_1_5 = arg_1_0.item:clone()
		local var_1_6 = rich.createByStr("#Pfont/youmi.ttf##C0x000000#" .. iter_1_2, 40):addTo(var_1_5):anchorPoint(0, 0.5):xy(10, 32):height(45)

		arg_1_0.list:pushBackCustomItem(var_1_5)

		local var_1_7 = ""

		for iter_1_4, iter_1_5 in ipairs(iter_1_3) do
			local var_1_8 = arg_1_0.item:clone()
			local var_1_9 = time.getDate(iter_1_5.time)
			local var_1_10 = "#C0x000000##Pfont/youmi.ttf#" .. string.format("%02d:%02d", var_1_9.hour, var_1_9.min)
			local var_1_11 = string.formatex("#C0x000000#" .. var_0_2[iter_1_5.type], {
				name = "#C0x5FC355#" .. iter_1_5.name .. "#C0x000000#"
			})
			local var_1_12 = rich.createByStr(var_1_10, 40):addTo(var_1_8):anchorPoint(0, 1):xy(160, 32)
			local var_1_13 = rich.createWithWidth(var_1_11, 40, nil, 730):addTo(var_1_8):anchorPoint(0, 1):xy(280, 32)
			local var_1_14 = var_1_13:height()

			var_1_8:height(var_1_14)
			var_1_12:xy(160, var_1_14)
			var_1_13:xy(280, var_1_14)
			arg_1_0.list:pushBackCustomItem(var_1_8)
		end
	end

	arg_1_0.list:jumpToBottom()
end

return var_0_1
