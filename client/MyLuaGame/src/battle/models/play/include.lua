local var_0_0 = {}

globals.battlePlay = var_0_0

require("battle.models.play.gate")
require("battle.models.play.normal_gate")
require("battle.models.play.arena_gate")
require("battle.models.play.cross_arena_gate")
require("battle.models.play.newbie_gate")
require("battle.models.play.test_gate")
require("battle.models.play.skill_test_gate")
require("battle.models.play.daily_activity_gate")
require("battle.models.play.endless_gate")
require("battle.models.play.union_raid_gate")
require("battle.models.play.simple_activity_gate")
require("battle.models.play.world_boss_gate")
require("battle.models.play.huodong_boss_gate")
require("battle.models.play.sync_fight_gate")
require("battle.models.play.friend_gate")
require("battle.models.play.craft_gate")
require("battle.models.play.cross_craft_gate")
require("battle.models.play.random_gate")
require("battle.models.play.clone_gate")
require("battle.models.play.union_fight_gate")
require("battle.models.play.cross_union_fight_gate")
require("battle.models.play.gym_gate")
require("battle.models.play.cross_mine_gate")
require("battle.models.play.cross_mine_boss_gate")
require("battle.models.play.brave_challenge_gate")
require("battle.models.play.hunting_gate")
require("battle.models.play.activity_challenge_gate")
require("battle.models.play.mimicry_gate")

local var_0_1 = {
	[game.GATE_TYPE.test] = var_0_0.TestGate,
	[game.GATE_TYPE.skillTest] = var_0_0.SkillTestGate,
	[game.GATE_TYPE.newbie] = var_0_0.NewbieGate,
	[game.GATE_TYPE.normal] = var_0_0.NormalGate,
	[game.GATE_TYPE.arena] = var_0_0.ArenaGate,
	[game.GATE_TYPE.crossArena] = var_0_0.CrossArenaGate,
	[game.GATE_TYPE.dailyGold] = var_0_0.DailyActivityGate,
	[game.GATE_TYPE.dailyExp] = var_0_0.DailyActivityGate,
	[game.GATE_TYPE.endlessTower] = var_0_0.EndlessGate,
	[game.GATE_TYPE.unionFuben] = var_0_0.UnionRaidGate,
	[game.GATE_TYPE.gift] = var_0_0.SimpleActivityGate,
	[game.GATE_TYPE.fragment] = var_0_0.SimpleActivityGate,
	[game.GATE_TYPE.simpleActivity] = var_0_0.SimpleActivityGate,
	[game.GATE_TYPE.friendFight] = var_0_0.FriendGate,
	[game.GATE_TYPE.randomTower] = var_0_0.RandomGate,
	[game.GATE_TYPE.clone] = var_0_0.CloneGate,
	[game.GATE_TYPE.worldBoss] = var_0_0.ActivityWorldBossGate,
	[game.GATE_TYPE.huoDongBoss] = var_0_0.ActivityBossGate,
	[game.GATE_TYPE.crossOnlineFight] = var_0_0.SyncFightGate,
	[game.GATE_TYPE.gym] = var_0_0.GymGate,
	[game.GATE_TYPE.gymLeader] = var_0_0.GymLeaderGate,
	[game.GATE_TYPE.crossGym] = var_0_0.CrossGymGate,
	[game.GATE_TYPE.crossMine] = var_0_0.CrossMineGate,
	[game.GATE_TYPE.crossMineBoss] = var_0_0.CrossMineBossGate,
	[game.GATE_TYPE.braveChallenge] = var_0_0.BraveChallengeGate,
	[game.GATE_TYPE.hunting] = var_0_0.HuntingGate,
	[game.GATE_TYPE.summerChallenge] = var_0_0.ActivityChallengeGate,
	[game.GATE_TYPE.mimicry] = var_0_0.MimicryGate
}
local var_0_2 = {
	[game.GATE_TYPE.arena] = var_0_0.ArenaGateRecord,
	[game.GATE_TYPE.crossArena] = var_0_0.CrossArenaGateRecord,
	[game.GATE_TYPE.endlessTower] = var_0_0.EndlessGateRecord,
	[game.GATE_TYPE.craft] = var_0_0.CraftGateRecord,
	[game.GATE_TYPE.crossCraft] = var_0_0.CrossCraftGateRecord,
	[game.GATE_TYPE.unionFight] = var_0_0.UnionFightGate,
	[game.GATE_TYPE.crossUnionFight] = var_0_0.CrossUnionFightGate,
	[game.GATE_TYPE.crossOnlineFight] = var_0_0.SyncFightGateRecord,
	[game.GATE_TYPE.gym] = var_0_0.GymGateRecord,
	[game.GATE_TYPE.gymLeader] = var_0_0.GymLeaderGateRecord,
	[game.GATE_TYPE.crossMine] = var_0_0.CrossMineGateRecord,
	[game.GATE_TYPE.crossMineBoss] = var_0_0.CrossMineBossGateRecord,
	[game.GATE_TYPE.braveChallenge] = var_0_0.BraveChallengeGateRecord,
	[game.GATE_TYPE.summerChallenge] = var_0_0.ActivityChallengeGateRecord,
	[game.GATE_TYPE.mimicry] = var_0_0.MimicryGateRecord
}

function globals.newPlayModel(arg_1_0, arg_1_1)
	local var_1_0 = var_0_1[arg_1_1]

	if var_1_0 then
		return var_1_0.new(arg_1_0)
	end
end

function globals.newRecordPlayModel(arg_2_0, arg_2_1)
	local var_2_0 = var_0_2[arg_2_1] or var_0_1[arg_2_1]

	if var_2_0 then
		return var_2_0.new(arg_2_0)
	end
end
