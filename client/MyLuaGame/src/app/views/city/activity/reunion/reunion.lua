local var_0_0 = {
	reunion = 2,
	gift = 1
}
local var_0_1 = {
	received = 2,
	noReach = 0,
	canReceive = 1
}
local var_0_2 = {
	reunion = 1,
	senior = 2
}
local var_0_3 = {
	bindPlayer = "city.activity.reunion.bind_player",
	task = "city.activity.reunion.task"
}
local var_0_4 = class("ReunionReunionView", cc.load("mvc").ViewBase)

var_0_4.RESOURCE_FILENAME = "reunion_reunion_base.json"
var_0_4.RESOURCE_BINDING = {}

function var_0_4.onCreate(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = csv.yunying.yyhuodong[arg_1_1]

	arg_1_0:initModel()

	local var_1_1 = arg_1_2.bindInfo
	local var_1_2 = arg_1_2.reunionRecord

	arg_1_0.role_type = arg_1_0.reunion.role_type
	arg_1_0.view = {}

	for iter_1_0, iter_1_1 in csvPairs(csv.yunying.reunion_gift) do
		if iter_1_1.huodongID == var_1_0.huodongID and iter_1_1.type == var_0_0.reunion and iter_1_1.target == arg_1_0.role_type then
			arg_1_0.csvID = iter_1_0
		end
	end

	local var_1_3 = "bindPlayer"

	if arg_1_0.role_type == var_0_2.reunion and arg_1_0.reunion.gift.bind and arg_1_0.csvID and arg_1_0.reunion.gift.bind[1] == arg_1_0.csvID and arg_1_0.reunion.gift.bind[2] == var_0_1.received or arg_1_0.role_type == var_0_2.senior then
		var_1_3 = "task"
	end

	arg_1_0.showViewName:addListener(function(arg_2_0, arg_2_1)
		if arg_2_1 and arg_1_0.view[arg_2_1] then
			arg_1_0.view[arg_2_1]:hide()
		end

		if arg_2_0 then
			local var_2_0 = {
				bindInfo = var_1_1,
				reunionRecord = var_1_2
			}

			if arg_2_0 == "bindPlayer" then
				var_2_0 = {
					goPanelClick = arg_1_0.goPanelClick,
					bindInfo = var_1_1
				}
			end

			if not arg_1_0.view[arg_2_0] then
				arg_1_0.view[arg_2_0] = gGameUI:createView(var_0_3[arg_2_0], arg_1_0):init(arg_1_1, var_2_0)
			else
				arg_1_0.view[arg_2_0]:show()
			end
		end
	end)
	arg_1_0.goPanelClick:addListener(function(arg_3_0, arg_3_1)
		if arg_3_0 == 1 then
			arg_1_0.showViewName:set("task")
		end
	end)
	arg_1_0.showViewName:set(var_1_3)
end

function var_0_4.initModel(arg_4_0)
	arg_4_0.reunion = gGameModel.role:read("reunion")
	arg_4_0.goPanelClick = idler.new(0)
	arg_4_0.showViewName = idler.new()
end

return var_0_4
