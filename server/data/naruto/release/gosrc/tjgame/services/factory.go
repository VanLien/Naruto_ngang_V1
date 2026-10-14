package services

import (
	"fmt"
	anticheat "tjgame/services/anti-cheat"
	"tjgame/services/arena"
	"tjgame/services/battletest"
	"tjgame/services/card_comment"
	"tjgame/services/card_fight"
	"tjgame/services/card_score"
	"tjgame/services/clone"
	"tjgame/services/craft"
	crossarena "tjgame/services/cross/arena"
	crosscraft "tjgame/services/cross/craft"
	crossFishing "tjgame/services/cross/fishing"
	crossgym "tjgame/services/cross/gym"
	crosshorse "tjgame/services/cross/horse_race"
	crosshunting "tjgame/services/cross/hunting"
	"tjgame/services/cross/huodongboss"
	crossMatch "tjgame/services/cross/match"
	crossMine "tjgame/services/cross/mine"
	"tjgame/services/cross/onlinefight"
	"tjgame/services/cross/onlinefight/forward"
	"tjgame/services/cross/onlinefight/lobby"
	"tjgame/services/cross/pvp"
	"tjgame/services/cross/ranking"
	"tjgame/services/cross/redpacket"
	"tjgame/services/cross/skyscraper"
	crossunionfight "tjgame/services/cross/union_fight"
	"tjgame/services/cross/unionqa"
	"tjgame/services/game"
	"tjgame/services/gym"
	"tjgame/services/hunting"
	"tjgame/services/society"
	"tjgame/services/storage"
	"tjgame/services/union"
	"tjgame/services/union_fight"
	"tjgame/services/yyhuodong"

	"tjgame/server_framework/tj/service"
)

const (
	Game               = game.Name
	Login              = "login"
	Storage            = storage.Name
	Logger             = "logger"
	Arena              = arena.Name
	Society            = society.Name
	Union              = union.Name
	Craft              = craft.Name
	Clone              = clone.Name
	PVP                = pvp.Name
	CrossCraft         = crosscraft.Name
	UnionFight         = union_fight.Name
	YYHuodong          = yyhuodong.Name
	CrossArena         = crossarena.Name
	OnlineFight        = onlinefight.Name
	AntiCheat          = anticheat.Name
	CrossFishing       = crossFishing.Name
	CrossMatch         = crossMatch.Name
	CrossMine          = crossMine.Name
	CardComment        = card_comment.Name
	CardScore          = card_score.Name
	CardFightPoint     = card_fight.Name
	CrossGym           = crossgym.Name
	Gym                = gym.Name
	HuoDongBoss        = huodongboss.Name
	CrossRedPacket     = redpacket.Name
	CrossSkyscraper    = skyscraper.Name
	Battletest         = battletest.Name
	CrossRanking       = ranking.Name
	OnlineFightForward = forward.Name
	CrossUnionQA       = unionqa.Name
	CrossHorse         = crosshorse.Name
	CrossLobby         = lobby.Name
	CrossHunting       = crosshunting.Name
	Hunting            = hunting.Name
	CrossUnionFight    = crossunionfight.Name
)

type factory struct {
	svcs    map[string]func(service.IOption, service.IContainer) service.IService
	options map[string]func() interface{}
}

var Factory *factory

// for non-practical service (may be the service no export anything for other)
func newFakeService(option service.IOption, container service.IContainer) service.IService {
	return service.NewService(option, container)
}

func (f *factory) NewOption(name string) interface{} {
	if f, ok := f.options[name]; ok {
		return f()
	}
	return new(service.Option)
}

// IFactory
func (f *factory) NewService(option service.IOption, container service.IContainer) service.IService {
	name := option.Base().Name
	serviceName, _, _ := service.SplitServiceName(name)
	newf, ok := f.svcs[serviceName]
	if ok {
		return newf(option, container)
	}
	panic(fmt.Sprintf("unknown service %s", name))
}

func init() {
	Factory = &factory{
		svcs:    make(map[string]func(service.IOption, service.IContainer) service.IService),
		options: make(map[string]func() interface{}),
	}
	Factory.svcs[Storage] = storage.NewService
	Factory.svcs[fmt.Sprintf("%smerge", Storage)] = storage.NewService
	Factory.svcs[Arena] = arena.NewService
	Factory.svcs[fmt.Sprintf("%smerge", Arena)] = arena.NewService
	Factory.svcs[Society] = society.NewService
	Factory.svcs[Union] = union.NewService
	Factory.svcs[fmt.Sprintf("%smerge", Union)] = union.NewService
	Factory.svcs[Craft] = craft.NewService
	Factory.svcs[fmt.Sprintf("%smerge", Craft)] = craft.NewService
	Factory.svcs[Clone] = clone.NewService
	Factory.svcs[fmt.Sprintf("%smerge", Clone)] = clone.NewService
	Factory.svcs[PVP] = pvp.NewService
	Factory.svcs[fmt.Sprintf("%smerge", PVP)] = pvp.NewService
	Factory.svcs[CrossCraft] = crosscraft.NewService
	Factory.svcs[UnionFight] = union_fight.NewService
	Factory.svcs[fmt.Sprintf("%smerge", UnionFight)] = union_fight.NewService
	Factory.svcs[YYHuodong] = yyhuodong.NewService
	Factory.svcs[fmt.Sprintf("%smerge", YYHuodong)] = yyhuodong.NewService
	Factory.svcs[CrossArena] = crossarena.NewService
	Factory.svcs[OnlineFight] = onlinefight.NewService
	Factory.svcs[CrossFishing] = crossFishing.NewService
	Factory.svcs[CrossMatch] = crossMatch.NewService
	Factory.svcs[CrossMine] = crossMine.NewService
	Factory.svcs[CardComment] = card_comment.NewService
	Factory.svcs[CardScore] = card_score.NewService
	Factory.svcs[CardFightPoint] = card_fight.NewService
	Factory.svcs[fmt.Sprintf("%smerge", CardFightPoint)] = card_fight.NewService
	Factory.svcs[CrossGym] = crossgym.NewService
	Factory.svcs[Gym] = gym.NewService
	Factory.svcs[fmt.Sprintf("%smerge", Gym)] = gym.NewService
	Factory.svcs[HuoDongBoss] = huodongboss.NewService
	Factory.svcs[CrossUnionQA] = unionqa.NewService
	Factory.svcs[CrossRedPacket] = redpacket.NewService
	Factory.svcs[CrossSkyscraper] = skyscraper.NewService
	Factory.svcs[CrossRanking] = ranking.NewService
	Factory.svcs[CrossHorse] = crosshorse.NewService
	Factory.svcs[CrossLobby] = lobby.NewService
	Factory.svcs[CrossHunting] = crosshunting.NewService
	Factory.svcs[Hunting] = hunting.NewService
	Factory.svcs[fmt.Sprintf("%smerge", Hunting)] = hunting.NewService
	Factory.svcs[CrossUnionFight] = crossunionfight.NewService
	Factory.svcs[Login] = newFakeService
	Factory.svcs[Game] = game.NewService
	Factory.svcs[fmt.Sprintf("%smerge", Game)] = game.NewService

	for _, name := range storage.Alias {
		Factory.svcs[name] = storage.NewService
	}

	Factory.svcs[AntiCheat] = anticheat.NewService
	Factory.svcs[OnlineFightForward] = forward.NewService
	Factory.svcs[Battletest] = battletest.NewService

	// default is service.Option
	Factory.options[Storage] = func() interface{} { return new(storage.Option) }
	Factory.options[fmt.Sprintf("%smerge", Storage)] = func() interface{} { return new(storage.Option) }
	for _, name := range storage.Alias {
		Factory.options[name] = func() interface{} { return new(storage.Option) }
	}
}
