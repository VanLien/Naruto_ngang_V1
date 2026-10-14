local var_0_0 = {
	2,
	3,
	3
}
local var_0_1 = require("app.views.city.union.cross_unionfight.tools")
local var_0_2 = class("CrossUnionModel")

var_0_2.MatchStage = {
	Final = 2,
	Preliminary = 1
}

function var_0_2.ctor(arg_1_0)
	arg_1_0.rank = nil
	arg_1_0.lastBattle = {}
	arg_1_0.countDown = 0
	arg_1_0.battleRound = 1
	arg_1_0.finish = false
	arg_1_0.unionAll = 0
	arg_1_0.unionState = {}
	arg_1_0.saveBattleData = {}
	arg_1_0.localModel = {}

	for iter_1_0 = 1, 4 do
		arg_1_0.saveBattleData[iter_1_0] = {}
		arg_1_0.localModel[iter_1_0] = arg_1_0.localModel[iter_1_0] or {}

		for iter_1_1 = 1, 3 do
			arg_1_0.localModel[iter_1_0][iter_1_1] = {
				endFrameId = 0
			}
		end
	end

	arg_1_0.distribute = 0
end

function var_0_2.setLastBattle(arg_2_0, arg_2_1, arg_2_2)
	if arg_2_2 then
		arg_2_0.lastBattle[arg_2_2] = arg_2_1
	else
		arg_2_0.lastBattle = arg_2_1
	end
end

function var_0_2.getLastBattle(arg_3_0, arg_3_1)
	return arg_3_0.lastBattle[arg_3_1]
end

function var_0_2.battleground(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0
	local var_4_1

	for iter_4_0, iter_4_1 in ipairs(arg_4_1 or {}) do
		for iter_4_2, iter_4_3 in ipairs(iter_4_1) do
			if iter_4_3.union_db_id == arg_4_2 then
				var_4_0 = iter_4_0

				break
			end
		end
	end

	if arg_4_3 == "preAward" or arg_4_3 == "topPrepare" or arg_4_3 == "preOver" and arg_4_0.finish then
		var_4_1 = true
	end

	return var_4_0, var_4_1
end

function var_0_2.notRequireBattle(arg_5_0)
	if arg_5_0.status == "preBattle" or arg_5_0.status == "preOver" or arg_5_0.status == "topBattle" or arg_5_0.status == "topOver" then
		return true
	end

	return false
end

function var_0_2.notRequireRank(arg_6_0)
	if arg_6_0.status == "preBattle" or arg_6_0.status == "preStart" or arg_6_0.status == "topBattle" or arg_6_0.status == "topStart" then
		return false
	end

	return true
end

function var_0_2.calculationUnionPoint(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	if not arg_7_0:notRequireBattle() then
		if arg_7_2 then
			arg_7_2()
		end

		return
	end

	if arg_7_1 == arg_7_0.squad and not itertools.isempty(arg_7_0.saveBattleData[arg_7_1]) then
		arg_7_0:getUnionInfo(arg_7_2, arg_7_1)

		return
	end

	local var_7_0 = {}

	for iter_7_0 = 1, 3 do
		var_7_0[iter_7_0] = arg_7_0.localModel[arg_7_1][iter_7_0].endFrameId + 1
	end

	performWithDelay(arg_7_3, function()
		gGameApp:requestServer("/game/cross/union/fight/battle/result", function(arg_9_0)
			if (arg_9_0.view.status == "preOver" or arg_9_0.view.status == "topOver") and not itertools.isempty(arg_7_0.saveBattleData[arg_7_1]) then
				arg_7_0:getUnionInfo(arg_7_2, arg_7_1)

				return
			end

			local var_9_0 = {}
			local var_9_1 = false
			local var_9_2 = false

			for iter_9_0 = 1, 3 do
				local var_9_3 = arg_9_0.view.results[iter_9_0]

				if var_9_3 and #var_9_3 > 0 then
					arg_7_0.localModel[arg_7_1][iter_9_0].endFrameId = #var_9_3 + arg_7_0.localModel[arg_7_1][iter_9_0].endFrameId

					for iter_9_1, iter_9_2 in ipairs(var_9_3) do
						table.insert(arg_7_0.saveBattleData[arg_7_1], iter_9_2)
					end
				end
			end

			arg_7_0:getUnionInfo(arg_7_2, arg_7_1)
		end, arg_7_1, var_7_0)
	end, 0)
end

function var_0_2.differentUnion(arg_10_0)
	local var_10_0 = var_0_1.getNowMatch(arg_10_0.status)
	local var_10_1 = var_10_0 == 1 and arg_10_0.unionClassifyData or arg_10_0.top_battle_groups
	local var_10_2 = {}

	for iter_10_0, iter_10_1 in ipairs(var_10_1 or {}) do
		if var_10_0 == 1 then
			for iter_10_2, iter_10_3 in ipairs(iter_10_1) do
				var_10_2[iter_10_3.union_db_id] = {}
			end
		else
			var_10_2[iter_10_1.union_db_id] = {}
		end
	end

	arg_10_0.unionState = var_10_2
end

function var_0_2.getUnionInfo(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0.battleRound <= 1 and 0 or arg_11_0.battleRound - 1

	for iter_11_0, iter_11_1 in ipairs(arg_11_0.saveBattleData[arg_11_2] or {}) do
		if var_11_0 == iter_11_1.round then
			if arg_11_0.unionState[iter_11_1.right.union_db_id] then
				arg_11_0.unionState[iter_11_1.right.union_db_id][1] = iter_11_1.right.union_alive
				arg_11_0.unionState[iter_11_1.right.union_db_id][2] = iter_11_1.right.union_point
			end

			if arg_11_0.unionState[iter_11_1.left.union_db_id] then
				arg_11_0.unionState[iter_11_1.left.union_db_id][1] = iter_11_1.left.union_alive
				arg_11_0.unionState[iter_11_1.left.union_db_id][2] = iter_11_1.left.union_point
			end

			if arg_11_0.distribute and var_0_1.roleDie(iter_11_1, arg_11_0.roleId, var_0_0[arg_11_0.distribute]) then
				arg_11_0.condition = true
			end
		end
	end

	if arg_11_1 then
		arg_11_1(true)
	end
end

return var_0_2
