package scheme

import (
	"tjgame/document"
	"tjgame/server_framework/tj/log"
)

func init() {
	// register document
	document.Register(&Account{})
	document.Register(&GMAccount{})
	document.Register(&PayOrder{})
	document.Register(&Gift{})

	document.Register(&Role{})
	document.Register(&RoleCard{})
	document.Register(&RoleHeldItem{})
	document.Register(&DailyRecord{})
	document.Register(&MonthlyRecord{})
	document.Register(&LotteryRecord{})
	document.Register(&Mail{})
	document.Register(&MailGlobal{})
	document.Register(&GMYYConfig{})
	document.Register(&Union{})
	document.Register(&UnionFuben{})
	document.Register(&UnionShop{})
	document.Register(&UnionTraining{})
	document.Register(&UnionRedPacket{})
	document.Register(&FixShop{})
	document.Register(&Society{})
	document.Register(&ServerGlobalRecord{})
	document.Register(&MysteryShop{})
	document.Register(&CloneGlobal{})
	document.Register(&CloneRoom{})
	document.Register(&MessageGlobal{})
	document.Register(&ExplorerShop{})
	document.Register(&FragShop{})
	document.Register(&EquipShop{})
	document.Register(&FishingShop{})

	document.Register(&TinyRank{})

	document.Register(&ArenaRecord{})
	document.Register(&ArenaPlayRecord{})
	document.Register(&ArenaGlobal{})
	document.Register(&ArenaGlobalHistory{})

	document.Register(&CraftGlobal{})
	document.Register(&CraftRecord{})
	document.Register(&CraftPlayRecord{})
	document.Register(&CraftGameGlobal{})

	document.Register(&CrossCraftGlobal{})
	document.Register(&CrossCraftRecord{})
	document.Register(&CrossCraftPlayRecord{})
	document.Register(&CrossCraftGameGlobal{})

	document.Register(&EndlessTowerGlobal{})
	document.Register(&PVEBattlePlayRecord{})

	document.Register(&RandomTower{})
	document.Register(&RandomTowerShop{})
	document.Register(&Capture{})

	document.Register(&RmbReturn{})

	document.Register(&UnionFightGlobal{})
	document.Register(&UnionFightRoleRecord{})
	document.Register(&UnionFightUnionRecord{})
	document.Register(&UnionFightGameGlobal{})
	document.Register(&UnionFightPlayRecord{})

	document.Register(&RoleGem{})
	document.Register(&RoleChip{})

	document.Register(&WorldBossGlobal{})

	document.Register(&CrossArenaRecord{})
	document.Register(&CrossArenaPlayRecord{})
	document.Register(&CrossArenaGlobal{})
	document.Register(&CrossArenaGameGlobal{})

	document.Register(&CrossOnlineFightRecord{})
	document.Register(&CrossOnlineFightPlayRecord{})
	document.Register(&CrossOnlineFightGlobal{})
	document.Register(&CrossOnlineFightGameGlobal{})

	document.Register(&CrossMatch{})

	document.Register(&CrossFishingGlobal{})
	document.Register(&CrossFishingGameGlobal{})

	document.Register(&Fishing{})

	document.Register(&CardComment{})
	document.Register(&CardCommentRole{})
	document.Register(&CardScoreGlobal{})
	document.Register(&CardScoreRole{})
	document.Register(&CardFightGlobal{})

	document.Register(&GymRecord{})
	document.Register(&CrossGymGlobal{})
	document.Register(&GymGlobal{})
	document.Register(&GymGameGlobal{})
	document.Register(&GymPlayRecord{})
	document.Register(&ReunionRecord{})
	document.Register(&HuoDongBossGlobal{})
	document.Register(&CrossUnionQAGlobal{})

	document.Register(&CrossMineGlobal{})
	document.Register(&CrossMineRecord{})
	document.Register(&CrossMinePlayRecord{})
	document.Register(&CrossMineGameGlobal{})

	document.Register(&CrossRedPacketGlobal{})
	document.Register(&SkyscraperGlobal{})
	document.Register(&CrossRankingGlobal{})
	document.Register(&HorseRaceGlobal{})

	document.Register(&HuntingGlobal{})
	document.Register(&HuntingRecord{})
	document.Register(&ArenaHuntingRecord{})

	document.Register(&CrossUnionFightGlobal{})
	document.Register(&CrossUnionFightRoleRecord{})
	document.Register(&CrossUnionFightPlayRecord{})
	document.Register(&CrossUnionFightGameGlobal{})

	document.Register(&BraveChallengeRecord{})
	log.Info("register document ok")
}
