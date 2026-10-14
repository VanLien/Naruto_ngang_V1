local var_0_0 = class("CrossArenaSevenInfoView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "cross_arena_info.json"
var_0_0.RESOURCE_BINDING = {
	["sevenPanel.textNode"] = "textNode",
	sevenPanel = "sevenPanel",
	["sevenPanel.txt"] = "txt",
	["sevenPanel.textTime"] = {
		varname = "textTime"
	}
}

function var_0_0.onCreate(arg_1_0)
	arg_1_0:initModel()

	local var_1_0 = time.getNumTimestamp(arg_1_0.date:read()) + 518400 + 79200
	local var_1_1 = time.getDate(var_1_0)

	arg_1_0.textNode:text(string.format(gLanguageCsv.sevenNode, tonumber(var_1_1.month), tonumber(var_1_1.day)))

	local function var_1_2()
		if var_1_0 - time.getTime() >= 0 then
			local var_2_0 = time.getCutDown(var_1_0 - time.getTime())

			arg_1_0.textTime:text(var_2_0.str)
		else
			arg_1_0.textTime:text(gLanguageCsv.sevenEnd)

			local var_2_1 = matchLanguage({
				"en"
			}) and arg_1_0.textTime:x() - 90 or arg_1_0.textTime:x() - 40

			arg_1_0.textTime:x(var_2_1)
			arg_1_0.txt:hide()

			return false
		end

		return true
	end

	var_1_2()
	arg_1_0:enableSchedule()
	arg_1_0:schedule(function(arg_3_0)
		if not var_1_2() then
			return false
		end
	end, 1, 0)
end

function var_0_0.initModel(arg_4_0)
	arg_4_0.date = gGameModel.cross_arena:getIdler("date")
end

return var_0_0
