require("battle.app_views.battle.stage_layer")

globals.CStageModel = class("CStageModel")

function CStageModel.ctor(arg_1_0, arg_1_1)
	arg_1_0.battleView = arg_1_1
	arg_1_0.bkLayerMap = CMap.new()
end

function CStageModel.init(arg_2_0, arg_2_1)
	arg_2_0.bkLayerMap:clear()

	local var_2_0 = getCsv(arg_2_1)

	for iter_2_0, iter_2_1 in orderCsvPairs(var_2_0) do
		if iter_2_1.resType == 1 or iter_2_1.resType == 2 then
			local var_2_1 = CStageLayerModel.new(arg_2_0.battleView, iter_2_1)

			var_2_1:init()
			arg_2_0.bkLayerMap:insert(iter_2_0, var_2_1)
		end
	end
end

function CStageModel.update(arg_3_0, arg_3_1)
	for iter_3_0, iter_3_1 in pairs(arg_3_0.bkLayerMap) do
		iter_3_1:updateSelf(arg_3_1)
	end
end
