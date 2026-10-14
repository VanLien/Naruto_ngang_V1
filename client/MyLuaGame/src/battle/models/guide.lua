globals.BattleGuideModel = class("BattleGuideModel")

function BattleGuideModel.ctor(arg_1_0, arg_1_1)
	arg_1_0.scene = arg_1_1
end

function BattleGuideModel.init(arg_2_0, arg_2_1)
	arg_2_0.play = arg_2_1
end

function BattleGuideModel.checkGuide(arg_3_0, arg_3_1, arg_3_2)
	arg_3_2 = arg_3_2 or {}

	local var_3_0 = arg_3_2.round or arg_3_0.play.curRound
	local var_3_1 = arg_3_2.heroId

	log.battle.guide("checkGuide: round", var_3_0, "sceneID", arg_3_0.scene.sceneID, "curWave", arg_3_0.play.curWave, "curRound", arg_3_0.play.curRound, "heroId", var_3_1)

	local var_3_2 = arg_3_0.play:getMonsterGuideCsv(arg_3_0.scene.sceneID, arg_3_0.play.curWave)

	if not var_3_2 then
		arg_3_1()

		return false
	end

	local function var_3_3(arg_4_0)
		local var_4_0 = csv.scene_monster_story[arg_4_0[2]]

		if arg_3_0.scene.gateType == game.GATE_TYPE.normal then
			local var_4_1 = arg_3_0.scene.sceneID
			local var_4_2 = gGameModel.role:read("gate_star") or {}
			local var_4_3 = var_4_2[var_4_1] and var_4_2[var_4_1].star and var_4_2[var_4_1].star > 0

			if var_4_0.isFirstGate and var_4_3 then
				return false
			end
		end

		if arg_4_0[1] == var_3_0 and arg_4_0[3] == var_3_1 then
			return true
		end

		return false
	end

	local var_3_4 = {}

	for iter_3_0, iter_3_1 in ipairs(var_3_2.storys) do
		if var_3_3(iter_3_1) then
			table.insert(var_3_4, iter_3_1[2])
		end
	end

	if next(var_3_4) then
		gRootViewProxy:proxy():setGuideData(var_3_4)
		arg_3_0.scene:modelWait("guiding", arg_3_1)

		return true
	end

	arg_3_1()

	return false
end
