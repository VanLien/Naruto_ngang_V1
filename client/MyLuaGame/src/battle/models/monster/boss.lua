globals.BossModel = class("BossModel", MonsterModel)

local var_0_0 = {
	death = 4,
	serious = 3,
	minor = 2,
	intact = 1
}
local var_0_1 = {
	[var_0_0.intact] = {
		hitAction = "hit",
		standbyAction = "standby_loop"
	},
	[var_0_0.minor] = {
		hitAction = "hit",
		standbyAction = "standby_loop"
	},
	[var_0_0.serious] = {
		hitAction = "hit",
		standbyAction = "standby_loop"
	},
	[var_0_0.death] = {
		standbyAction = "use error action name to replace normal"
	}
}

function BossModel.ctor(arg_1_0, arg_1_1, arg_1_2)
	MonsterModel.ctor(arg_1_0, arg_1_1, arg_1_2)

	arg_1_0.isBoss = true
end

function BossModel.init(arg_2_0, arg_2_1)
	MonsterModel.init(arg_2_0, arg_2_1)

	arg_2_0.huodongCsv = csv.huodong_drop[arg_2_0.scene.sceneID]

	if arg_2_0.huodongCsv then
		local var_2_0 = arg_2_0.huodongCsv.node

		if not var_2_0 then
			error(string.format("huodong_drop not find node line in sceneId: %s", arg_2_0.scene.sceneID))
		end

		arg_2_0.hpToStage = {
			[var_0_0.intact] = 0,
			[var_0_0.minor] = 20,
			[var_0_0.serious] = 60,
			[var_0_0.death] = 100,
			[var_0_0.minor] = var_2_0[2],
			[var_0_0.serious] = var_2_0[3]
		}
		arg_2_0.curStage = arg_2_0:getCurStage()

		arg_2_0.view:notify("pushAction", battle.SpriteActionTable.death, "hit")
	end
end

function BossModel.getCurStage(arg_3_0)
	if not arg_3_0.huodongCsv then
		error("no stage in boss")
	end

	local var_3_0 = 100 * (1 - arg_3_0:hp() / arg_3_0:hpMax())
	local var_3_1 = var_0_0.intact

	for iter_3_0, iter_3_1 in pairs(arg_3_0.hpToStage) do
		if iter_3_1 <= var_3_0 and var_3_1 < iter_3_0 then
			var_3_1 = iter_3_0
		end
	end

	log.battle(string.format("==============boss lost hp %s==========================", var_3_0))

	return var_3_1
end

function BossModel.beAttack(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if arg_4_0.scene.gateType == game.GATE_TYPE.worldBoss and arg_4_4.from == battle.DamageFrom.buff then
		local var_4_0 = arg_4_0:hpMax() * gCommonConfigCsv.worldBossDamageLimitRate

		arg_4_2 = math.min(arg_4_2, var_4_0)
	end

	local var_4_1, var_4_2 = MonsterModel.beAttack(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_3 = arg_4_0.scene.play

	if var_4_3.gateDoOnObjectBeAttacked then
		var_4_3:gateDoOnObjectBeAttacked(arg_4_0.id)
	end

	return var_4_1, var_4_2
end

function BossModel.setHP(arg_5_0, arg_5_1, arg_5_2)
	MonsterModel.setHP(arg_5_0, arg_5_1, arg_5_2)

	if arg_5_0.scene.gateType == game.GATE_TYPE.worldBoss then
		MonsterModel.setHP(arg_5_0, arg_5_0.scene.play.recoverHp)
	end
end

function BossModel.playAniAfterBattleTurn(arg_6_0)
	if not arg_6_0.huodongCsv then
		error("no stage in boss")
	end

	local var_6_0 = arg_6_0:getCurStage()
	local var_6_1 = var_6_0 ~= arg_6_0.curStage

	if var_6_1 then
		local var_6_2 = var_6_0 - arg_6_0.curStage
		local var_6_3 = arg_6_0.view
		local var_6_4
		local var_6_5

		if var_6_2 > 1 and arg_6_0:isAlreadyDead() then
			var_6_0 = var_0_0.death

			local var_6_6 = var_0_1[var_6_0]

			battleEasy.queueNotifyFor(var_6_3, "playAction", var_6_6.changeAction)
		else
			for iter_6_0 = arg_6_0.curStage, var_6_0 do
				local var_6_7 = var_0_1[iter_6_0]

				if var_6_7.changeAction and iter_6_0 ~= arg_6_0.curStage then
					if not var_6_7.changeActionFrame or not (var_6_7.changeActionFrame * game.FRAME_TICK) then
						local var_6_8 = 20
					end

					battleEasy.queueNotifyFor(var_6_3, "playAction", var_6_7.changeAction)
				end

				if var_6_7.standbyAction then
					var_6_4 = var_6_7.standbyAction
				end

				if var_6_7.hitAction then
					var_6_5 = var_6_7.hitAction
				end
			end
		end

		if var_6_0 ~= var_0_0.death then
			battleEasy.queueEffect(function()
				if var_6_4 then
					battleEasy.queueNotifyFor(var_6_3, "pushAction", battle.SpriteActionTable.standby, var_6_4)
				end

				if var_6_5 then
					battleEasy.queueNotifyFor(var_6_3, "pushAction", battle.SpriteActionTable.hit, var_6_5)
				end
			end)
			battleEasy.queueNotifyFor(var_6_3, "playAction", battle.SpriteActionTable.standby)
		end

		arg_6_0.curStage = var_6_0
	end

	return var_6_1
end
