
// Code generated - temporary package for csvgen - DO NOT EDIT.
package csv

import tjcsv "tjgame/server_framework/tj/csv"

// 
type csvConfig struct {
	// achievement
	Achievement *Achievement `yaml:"achievement" codec:"achievement"`
	// banlvxiaowu.csv
	Banlvxiaowu map[int]*Banlvxiaowu `yaml:"banlvxiaowu" codec:"banlvxiaowu"`
	// base_attribute
	Base_attribute *Base_attribute `yaml:"base_attribute" codec:"base_attribute"`
	// battle_card_halo.csv
	Battle_card_halo map[int]*Battle_card_halo `yaml:"battle_card_halo" codec:"battle_card_halo"`
	// bossaward.csv
	Bossaward map[int]*Bossaward `yaml:"bossaward" codec:"bossaward"`
	// brave_challenge
	Brave_challenge *Brave_challenge `yaml:"brave_challenge" codec:"brave_challenge"`
	// buff_effect.csv
	Buff_effect map[int]*Buff_effect `yaml:"buff_effect" codec:"buff_effect"`
	// buff_group_power.csv
	Buff_group_power map[int]*Buff_group_power `yaml:"buff_group_power" codec:"buff_group_power"`
	// buff_level_correct.csv
	Buff_level_correct map[int]*Buff_level_correct `yaml:"buff_level_correct" codec:"buff_level_correct"`
	// capture
	Capture *Capture `yaml:"capture" codec:"capture"`
	// card_ability.csv
	Card_ability map[int]*Card_ability `yaml:"card_ability" codec:"card_ability"`
	// card_ability_cost.csv
	Card_ability_cost map[int]*Card_ability_cost `yaml:"card_ability_cost" codec:"card_ability_cost"`
	// card_effort.csv
	Card_effort map[int]*Card_effort `yaml:"card_effort" codec:"card_effort"`
	// card_effort_advance.csv
	Card_effort_advance map[int]*Card_effort_advance `yaml:"card_effort_advance" codec:"card_effort_advance"`
	// card_mega.csv
	Card_mega map[int]*Card_mega `yaml:"card_mega" codec:"card_mega"`
	// card_mega_convert.csv
	Card_mega_convert map[int]*Card_mega_convert `yaml:"card_mega_convert" codec:"card_mega_convert"`
	// card_recast.csv
	Card_recast map[int]*Card_recast `yaml:"card_recast" codec:"card_recast"`
	// card_skin.csv
	Card_skin map[int]*Card_skin `yaml:"card_skin" codec:"card_skin"`
	// card_skin_shop.csv
	Card_skin_shop map[int]*Card_skin_shop `yaml:"card_skin_shop" codec:"card_skin_shop"`
	// card_star.csv
	Card_star map[int]*Card_star `yaml:"card_star" codec:"card_star"`
	// card_star2frag.csv
	Card_star2frag map[int]*Card_star2frag `yaml:"card_star2frag" codec:"card_star2frag"`
	// card_star_effect.csv
	Card_star_effect map[int]*Card_star_effect `yaml:"card_star_effect" codec:"card_star_effect"`
	// card_star_skill.csv
	Card_star_skill map[int]*Card_star_skill `yaml:"card_star_skill" codec:"card_star_skill"`
	// cards.csv
	Cards map[int]*Cards `yaml:"cards" codec:"cards"`
	// cards_branch_cost.csv
	Cards_branch_cost map[int]*Cards_branch_cost `yaml:"cards_branch_cost" codec:"cards_branch_cost"`
	// character.csv
	Character map[int]*Character `yaml:"character" codec:"character"`
	// character_random.csv
	Character_random map[int]*Character_random `yaml:"character_random" codec:"character_random"`
	// chat_emoji.csv
	Chat_emoji map[int]*Chat_emoji `yaml:"chat_emoji" codec:"chat_emoji"`
	// chat_limit.csv
	Chat_limit map[int]*Chat_limit `yaml:"chat_limit" codec:"chat_limit"`
	// chip
	Chip *Chip `yaml:"chip" codec:"chip"`
	// city_sprites.csv
	City_sprites map[int]*City_sprites `yaml:"city_sprites" codec:"city_sprites"`
	// clone
	Clone *Clone `yaml:"clone" codec:"clone"`
	// combat_power_correction.csv
	Combat_power_correction map[int]*Combat_power_correction `yaml:"combat_power_correction" codec:"combat_power_correction"`
	// common_config.csv
	Common_config map[int]*Common_config `yaml:"common_config" codec:"common_config"`
	// cost.csv
	Cost map[int]*Cost `yaml:"cost" codec:"cost"`
	// craft
	Craft *Craft `yaml:"craft" codec:"craft"`
	// cross
	Cross *Cross `yaml:"cross" codec:"cross"`
	// daily_assistant.csv
	Daily_assistant map[int]*Daily_assistant `yaml:"daily_assistant" codec:"daily_assistant"`
	// dispatch_task
	Dispatch_task *Dispatch_task `yaml:"dispatch_task" codec:"dispatch_task"`
	// draw_card.csv
	Draw_card map[int]*Draw_card `yaml:"draw_card" codec:"draw_card"`
	// draw_card_up_group.csv
	Draw_card_up_group map[int]*Draw_card_up_group `yaml:"draw_card_up_group" codec:"draw_card_up_group"`
	// draw_chip.csv
	Draw_chip map[int]*Draw_chip `yaml:"draw_chip" codec:"draw_chip"`
	// draw_chip_dynamic.csv
	Draw_chip_dynamic map[int]*Draw_chip_dynamic `yaml:"draw_chip_dynamic" codec:"draw_chip_dynamic"`
	// draw_count.csv
	Draw_count map[int]*Draw_count `yaml:"draw_count" codec:"draw_count"`
	// draw_equip.csv
	Draw_equip map[int]*Draw_equip `yaml:"draw_equip" codec:"draw_equip"`
	// draw_gem.csv
	Draw_gem map[int]*Draw_gem `yaml:"draw_gem" codec:"draw_gem"`
	// draw_item.csv
	Draw_item map[int]*Draw_item `yaml:"draw_item" codec:"draw_item"`
	// draw_items_lib.csv
	Draw_items_lib map[int]*Draw_items_lib `yaml:"draw_items_lib" codec:"draw_items_lib"`
	// draw_metal.csv
	Draw_metal map[int]*Draw_metal `yaml:"draw_metal" codec:"draw_metal"`
	// draw_totem.csv
	Draw_totem map[int]*Draw_totem `yaml:"draw_totem" codec:"draw_totem"`
	// effect_option.csv
	Effect_option map[int]*Effect_option `yaml:"effect_option" codec:"effect_option"`
	// effect_power.csv
	Effect_power map[int]*Effect_power `yaml:"effect_power" codec:"effect_power"`
	// endless_tower_scene.csv
	Endless_tower_scene map[int]*Endless_tower_scene `yaml:"endless_tower_scene" codec:"endless_tower_scene"`
	// equip_shop.csv
	Equip_shop map[int]*Equip_shop `yaml:"equip_shop" codec:"equip_shop"`
	// equips.csv
	Equips map[int]*Equips `yaml:"equips" codec:"equips"`
	// explorer
	Explorer *Explorer `yaml:"explorer" codec:"explorer"`
	// extra_object.csv
	Extra_object map[int]*Extra_object `yaml:"extra_object" codec:"extra_object"`
	// extra_round_trigger.csv
	Extra_round_trigger map[int]*Extra_round_trigger `yaml:"extra_round_trigger" codec:"extra_round_trigger"`
	// fetter.csv
	Fetter map[int]*Fetter `yaml:"fetter" codec:"fetter"`
	// fighting_weight.csv
	Fighting_weight map[int]*Fighting_weight `yaml:"fighting_weight" codec:"fighting_weight"`
	// fishing
	Fishing *Fishing `yaml:"fishing" codec:"fishing"`
	// fix_shop.csv
	Fix_shop map[int]*Fix_shop `yaml:"fix_shop" codec:"fix_shop"`
	// frag_shop.csv
	Frag_shop map[int]*Frag_shop `yaml:"frag_shop" codec:"frag_shop"`
	// fragments.csv
	Fragments map[int]*Fragments `yaml:"fragments" codec:"fragments"`
	// gem
	Gem *Gem `yaml:"gem" codec:"gem"`
	// gift.csv
	Gift map[int]*Gift `yaml:"gift" codec:"gift"`
	// good_feel.csv
	Good_feel map[int]*Good_feel `yaml:"good_feel" codec:"good_feel"`
	// good_feel_effect.csv
	Good_feel_effect map[int]*Good_feel_effect `yaml:"good_feel_effect" codec:"good_feel_effect"`
	// grow_guide.csv
	Grow_guide map[int]*Grow_guide `yaml:"grow_guide" codec:"grow_guide"`
	// gym
	Gym *Gym `yaml:"gym" codec:"gym"`
	// gym_badge
	Gym_badge *Gym_badge `yaml:"gym_badge" codec:"gym_badge"`
	// held_item
	Held_item *Held_item `yaml:"held_item" codec:"held_item"`
	// homeland
	Homeland *Homeland `yaml:"homeland" codec:"homeland"`
	// huodong.csv
	Huodong map[int]*Huodong `yaml:"huodong" codec:"huodong"`
	// huodong_drop.csv
	Huodong_drop map[int]*Huodong_drop `yaml:"huodong_drop" codec:"huodong_drop"`
	// huodong_gate_fragment.csv
	Huodong_gate_fragment map[int]*Huodong_gate_fragment `yaml:"huodong_gate_fragment" codec:"huodong_gate_fragment"`
	// huodong_huanxiang.csv
	Huodong_huanxiang map[int]*Huodong_huanxiang `yaml:"huodong_huanxiang" codec:"huodong_huanxiang"`
	// items.csv
	Items map[int]*Items `yaml:"items" codec:"items"`
	// language.csv
	Language map[int]*Language `yaml:"language" codec:"language"`
	// limit_drops
	Limit_drops *Limit_drops `yaml:"limit_drops" codec:"limit_drops"`
	// livenessaward.csv
	Livenessaward map[int]*Livenessaward `yaml:"livenessaward" codec:"livenessaward"`
	// mail.csv
	Mail map[int]*Mail `yaml:"mail" codec:"mail"`
	// marquee.csv
	Marquee map[int]*Marquee `yaml:"marquee" codec:"marquee"`
	// meteorite
	Meteorite *Meteorite `yaml:"meteorite" codec:"meteorite"`
	// mimicry
	Mimicry *Mimicry `yaml:"mimicry" codec:"mimicry"`
	// monster_scenes.csv
	Monster_scenes map[int]*Monster_scenes `yaml:"monster_scenes" codec:"monster_scenes"`
	// month_card_privilege.csv
	Month_card_privilege map[int]*Month_card_privilege `yaml:"month_card_privilege" codec:"month_card_privilege"`
	// mystery_shop.csv
	Mystery_shop map[int]*Mystery_shop `yaml:"mystery_shop" codec:"mystery_shop"`
	// mystery_shop_config.csv
	Mystery_shop_config map[int]*Mystery_shop_config `yaml:"mystery_shop_config" codec:"mystery_shop_config"`
	// new_guide.csv
	New_guide map[int]*New_guide `yaml:"new_guide" codec:"new_guide"`
	// new_guide_local.csv
	New_guide_local map[int]*New_guide_local `yaml:"new_guide_local" codec:"new_guide_local"`
	// new_guide_local_.csv
	New_guide_local_ map[int]*New_guide_local_ `yaml:"new_guide_local_" codec:"new_guide_local_"`
	// newbie_init.csv
	Newbie_init map[int]*Newbie_init `yaml:"newbie_init" codec:"newbie_init"`
	// note.csv
	Note map[int]*Note `yaml:"note" codec:"note"`
	// notice.csv
	Notice map[int]*Notice `yaml:"notice" codec:"notice"`
	// notify_message.csv
	Notify_message map[int]*Notify_message `yaml:"notify_message" codec:"notify_message"`
	// nvalue_min_value.csv
	Nvalue_min_value map[int]*Nvalue_min_value `yaml:"nvalue_min_value" codec:"nvalue_min_value"`
	// nvalue_random.csv
	Nvalue_random map[int]*Nvalue_random `yaml:"nvalue_random" codec:"nvalue_random"`
	// nvalue_random_lib.csv
	Nvalue_random_lib map[int]*Nvalue_random_lib `yaml:"nvalue_random_lib" codec:"nvalue_random_lib"`
	// nvalue_rmb.csv
	Nvalue_rmb map[int]*Nvalue_rmb `yaml:"nvalue_rmb" codec:"nvalue_rmb"`
	// online_gift.csv
	Online_gift map[int]*Online_gift `yaml:"online_gift" codec:"online_gift"`
	// overflow_exp_exchange.csv
	Overflow_exp_exchange map[int]*Overflow_exp_exchange `yaml:"overflow_exp_exchange" codec:"overflow_exp_exchange"`
	// pokedex.csv
	Pokedex map[int]*Pokedex `yaml:"pokedex" codec:"pokedex"`
	// pokedex_advance.csv
	Pokedex_advance map[int]*Pokedex_advance `yaml:"pokedex_advance" codec:"pokedex_advance"`
	// pokedex_develop.csv
	Pokedex_develop map[int]*Pokedex_develop `yaml:"pokedex_develop" codec:"pokedex_develop"`
	// pvpandpve.csv
	Pvpandpve map[int]*Pvpandpve `yaml:"pvpandpve" codec:"pvpandpve"`
	// pwaward.csv
	Pwaward map[int]*Pwaward `yaml:"pwaward" codec:"pwaward"`
	// pwbattle.csv
	Pwbattle map[int]*Pwbattle `yaml:"pwbattle" codec:"pwbattle"`
	// pwflop_award.csv
	Pwflop_award map[int]*Pwflop_award `yaml:"pwflop_award" codec:"pwflop_award"`
	// pwpoint_award.csv
	Pwpoint_award map[int]*Pwpoint_award `yaml:"pwpoint_award" codec:"pwpoint_award"`
	// pwrank_award.csv
	Pwrank_award map[int]*Pwrank_award `yaml:"pwrank_award" codec:"pwrank_award"`
	// pwshop.csv
	Pwshop map[int]*Pwshop `yaml:"pwshop" codec:"pwshop"`
	// random_drops.csv
	Random_drops map[int]*Random_drops `yaml:"random_drops" codec:"random_drops"`
	// random_tower
	Random_tower *Random_tower `yaml:"random_tower" codec:"random_tower"`
	// rebirth_rmb_cost.csv
	Rebirth_rmb_cost map[int]*Rebirth_rmb_cost `yaml:"rebirth_rmb_cost" codec:"rebirth_rmb_cost"`
	// recharges.csv
	Recharges map[int]*Recharges `yaml:"recharges" codec:"recharges"`
	// role_figure.csv
	Role_figure map[int]*Role_figure `yaml:"role_figure" codec:"role_figure"`
	// role_frame.csv
	Role_frame map[int]*Role_frame `yaml:"role_frame" codec:"role_frame"`
	// role_logo.csv
	Role_logo map[int]*Role_logo `yaml:"role_logo" codec:"role_logo"`
	// role_out.csv
	Role_out map[int]*Role_out `yaml:"role_out" codec:"role_out"`
	// role_out_init.csv
	Role_out_init map[int]*Role_out_init `yaml:"role_out_init" codec:"role_out_init"`
	// scene_conf.csv
	Scene_conf map[int]*Scene_conf `yaml:"scene_conf" codec:"scene_conf"`
	// scene_demon_correct.csv
	Scene_demon_correct map[int]*Scene_demon_correct `yaml:"scene_demon_correct" codec:"scene_demon_correct"`
	// scene_level_correct.csv
	Scene_level_correct map[int]*Scene_level_correct `yaml:"scene_level_correct" codec:"scene_level_correct"`
	// scene_monster_story.csv
	Scene_monster_story map[int]*Scene_monster_story `yaml:"scene_monster_story" codec:"scene_monster_story"`
	// scene_story_choices.csv
	Scene_story_choices map[int]*Scene_story_choices `yaml:"scene_story_choices" codec:"scene_story_choices"`
	// sdk
	Sdk *Sdk `yaml:"sdk" codec:"sdk"`
	// server
	Server *Server `yaml:"server" codec:"server"`
	// shop.csv
	Shop map[int]*Shop `yaml:"shop" codec:"shop"`
	// sighingift.csv
	Sighingift map[int]*Sighingift `yaml:"sighingift" codec:"sighingift"`
	// signin.csv
	Signin map[int]*Signin `yaml:"signin" codec:"signin"`
	// skill.csv
	Skill map[int]*Skill `yaml:"skill" codec:"skill"`
	// sound_config.csv
	Sound_config map[int]*Sound_config `yaml:"sound_config" codec:"sound_config"`
	// stable_drops.csv
	Stable_drops map[int]*Stable_drops `yaml:"stable_drops" codec:"stable_drops"`
	// stage
	Stage *Stage `yaml:"stage" codec:"stage"`
	// story.csv
	Story map[int]*Story `yaml:"story" codec:"story"`
	// story_talk.csv
	Story_talk map[int]*Story_talk `yaml:"story_talk" codec:"story_talk"`
	// summer_challenge
	Summer_challenge *Summer_challenge `yaml:"summer_challenge" codec:"summer_challenge"`
	// sysopen.csv
	Sysopen map[int]*Sysopen `yaml:"sysopen" codec:"sysopen"`
	// talent.csv
	Talent map[int]*Talent `yaml:"talent" codec:"talent"`
	// talent_cost.csv
	Talent_cost map[int]*Talent_cost `yaml:"talent_cost" codec:"talent_cost"`
	// talent_tree.csv
	Talent_tree map[int]*Talent_tree `yaml:"talent_tree" codec:"talent_tree"`
	// tasks.csv
	Tasks map[int]*Tasks `yaml:"tasks" codec:"tasks"`
	// test_battle.csv
	Test_battle map[int]*Test_battle `yaml:"test_battle" codec:"test_battle"`
	// test_force.csv
	Test_force map[int]*Test_force `yaml:"test_force" codec:"test_force"`
	// title.csv
	Title map[int]*Title `yaml:"title" codec:"title"`
	// title_type.csv
	Title_type map[int]*Title_type `yaml:"title_type" codec:"title_type"`
	// totem
	Totem *Totem `yaml:"totem" codec:"totem"`
	// town
	Town *Town `yaml:"town" codec:"town"`
	// trainer
	Trainer *Trainer `yaml:"trainer" codec:"trainer"`
	// try_play_battle.csv
	Try_play_battle map[int]*Try_play_battle `yaml:"try_play_battle" codec:"try_play_battle"`
	// union
	Union *Union `yaml:"union" codec:"union"`
	// union_fight
	Union_fight *Union_fight `yaml:"union_fight" codec:"union_fight"`
	// union_qa
	Union_qa *Union_qa `yaml:"union_qa" codec:"union_qa"`
	// unit.csv
	Unit map[int]*Unit `yaml:"unit" codec:"unit"`
	// unlock.csv
	Unlock map[int]*Unlock `yaml:"unlock" codec:"unlock"`
	// vip.csv
	Vip map[int]*Vip `yaml:"vip" codec:"vip"`
	// vip_desc.csv
	Vip_desc map[int]*Vip_desc `yaml:"vip_desc" codec:"vip_desc"`
	// volleyball_unit.csv
	Volleyball_unit map[int]*Volleyball_unit `yaml:"volleyball_unit" codec:"volleyball_unit"`
	// weather.csv
	Weather map[int]*Weather `yaml:"weather" codec:"weather"`
	// weather_buff.csv
	Weather_buff map[int]*Weather_buff `yaml:"weather_buff" codec:"weather_buff"`
	// weather_skill.csv
	Weather_skill map[int]*Weather_skill `yaml:"weather_skill" codec:"weather_skill"`
	// world_boss
	World_boss *World_boss `yaml:"world_boss" codec:"world_boss"`
	// world_level
	World_level *World_level `yaml:"world_level" codec:"world_level"`
	// world_map.csv
	World_map map[int]*World_map `yaml:"world_map" codec:"world_map"`
	// yunying
	Yunying *Yunying `yaml:"yunying" codec:"yunying"`
	// zawake
	Zawake *Zawake `yaml:"zawake" codec:"zawake"`
}
// achievement
type Achievement struct {
	// achievement/achievement.csv
	Achievement map[int]*Achievement_achievement `yaml:"achievement" codec:"achievement"`
	// achievement/achievement_.csv
	Achievement_ map[int]*Achievement_achievement_ `yaml:"achievement_" codec:"achievement_"`
	// achievement/achievement_level.csv
	Achievement_level map[int]*Achievement_achievement_level `yaml:"achievement_level" codec:"achievement_level"`
	// achievement/achievement_task.csv
	Achievement_task map[int]*Achievement_achievement_task `yaml:"achievement_task" codec:"achievement_task"`
}
// achievement/achievement.csv
type Achievement_achievement struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// name
	Name string `yaml:"name" codec:"name"`
}
// achievement/achievement_.csv
type Achievement_achievement_ struct {
	// 成就分类
	ID int `yaml:"ID" codec:"ID"`
	// 成就分类名称
	Name string `yaml:"name" codec:"name"`
	// 成就分类图标
	Icon string `yaml:"icon" codec:"icon"`
}
// achievement/achievement_level.csv
type Achievement_achievement_level struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// boxIcon
	BoxIcon string `yaml:"boxIcon" codec:"boxIcon"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// level
	Level int `yaml:"level" codec:"level"`
	// point
	Point int `yaml:"point" codec:"point"`
	// spine
	Spine string `yaml:"spine" codec:"spine"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// achievement/achievement_task.csv
type Achievement_achievement_task struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// isShow
	IsShow bool `yaml:"isShow" codec:"isShow"`
	// jumpTo
	JumpTo string `yaml:"jumpTo" codec:"jumpTo"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// point
	Point int `yaml:"point" codec:"point"`
	// sort
	Sort int `yaml:"sort" codec:"sort"`
	// targetArg
	TargetArg int `yaml:"targetArg" codec:"targetArg"`
	// targetArg2
	TargetArg2 int `yaml:"targetArg2" codec:"targetArg2"`
	// targetType
	TargetType int `yaml:"targetType" codec:"targetType"`
	// targetType2
	TargetType2 int `yaml:"targetType2" codec:"targetType2"`
	// title
	Title string `yaml:"title" codec:"title"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// banlvxiaowu.csv
type Banlvxiaowu struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// name
	Name string `yaml:"name" codec:"name"`
	// clothattr
	Clothattr tjcsv.Map `yaml:"clothattr" codec:"clothattr"`
	// videoattr
	Videoattr tjcsv.Map `yaml:"videoattr" codec:"videoattr"`
	// chipnum
	Chipnum int `yaml:"chipnum" codec:"chipnum"`
	// blessing
	Blessing string `yaml:"blessing" codec:"blessing"`
	// attrType
	AttrType int `yaml:"attrType" codec:"attrType"`
	// attrNum
	AttrNum string `yaml:"attrNum" codec:"attrNum"`
	// cardID
	CardID int `yaml:"cardID" codec:"cardID"`
	// clothCost
	ClothCost tjcsv.Map `yaml:"clothCost" codec:"clothCost"`
	// videoCost
	VideoCost tjcsv.Map `yaml:"videoCost" codec:"videoCost"`
	// sort
	Sort int `yaml:"sort" codec:"sort"`
	// randLib
	RandLib int `yaml:"randLib" codec:"randLib"`
	// chattext1
	Chattext1 string `yaml:"chattext1" codec:"chattext1"`
	// chattext2
	Chattext2 string `yaml:"chattext2" codec:"chattext2"`
	// chattext3
	Chattext3 string `yaml:"chattext3" codec:"chattext3"`
	// roleConfig
	RoleConfig tjcsv.Map `yaml:"roleConfig" codec:"roleConfig"`
	// chtaTextConfig
	ChtaTextConfig tjcsv.Map `yaml:"chtaTextConfig" codec:"chtaTextConfig"`
}
// base_attribute
type Base_attribute struct {
	// base_attribute/advance_level.csv
	Advance_level map[int]*Base_attribute_advance_level `yaml:"advance_level" codec:"advance_level"`
	// base_attribute/base
	Base *Base_attribute_base `yaml:"base" codec:"base"`
	// base_attribute/bossmonster
	Bossmonster *Base_attribute_bossmonster `yaml:"bossmonster" codec:"bossmonster"`
	// base_attribute/bossmonster2
	Bossmonster2 *Base_attribute_bossmonster2 `yaml:"bossmonster2" codec:"bossmonster2"`
	// base_attribute/card_level.csv
	Card_level map[int]*Base_attribute_card_level `yaml:"card_level" codec:"card_level"`
	// base_attribute/common
	Common *Base_attribute_common `yaml:"common" codec:"common"`
	// base_attribute/controllbufftype.csv
	Controllbufftype map[int]*Base_attribute_controllbufftype `yaml:"controllbufftype" codec:"controllbufftype"`
	// base_attribute/develop_level.csv
	Develop_level map[int]*Base_attribute_develop_level `yaml:"develop_level" codec:"develop_level"`
	// base_attribute/elites
	Elites *Base_attribute_elites `yaml:"elites" codec:"elites"`
	// base_attribute/elitesmonster
	Elitesmonster *Base_attribute_elitesmonster `yaml:"elitesmonster" codec:"elitesmonster"`
	// base_attribute/equip_ability.csv
	Equip_ability map[int]*Base_attribute_equip_ability `yaml:"equip_ability" codec:"equip_ability"`
	// base_attribute/equip_advance.csv
	Equip_advance map[int]*Base_attribute_equip_advance `yaml:"equip_advance" codec:"equip_advance"`
	// base_attribute/equip_awake.csv
	Equip_awake map[int]*Base_attribute_equip_awake `yaml:"equip_awake" codec:"equip_awake"`
	// base_attribute/equip_awake_ability.csv
	Equip_awake_ability map[int]*Base_attribute_equip_awake_ability `yaml:"equip_awake_ability" codec:"equip_awake_ability"`
	// base_attribute/equip_signet.csv
	Equip_signet map[int]*Base_attribute_equip_signet `yaml:"equip_signet" codec:"equip_signet"`
	// base_attribute/equip_signet_advance.csv
	Equip_signet_advance map[int]*Base_attribute_equip_signet_advance `yaml:"equip_signet_advance" codec:"equip_signet_advance"`
	// base_attribute/equip_signet_advance_cost.csv
	Equip_signet_advance_cost map[int]*Base_attribute_equip_signet_advance_cost `yaml:"equip_signet_advance_cost" codec:"equip_signet_advance_cost"`
	// base_attribute/equip_star.csv
	Equip_star map[int]*Base_attribute_equip_star `yaml:"equip_star" codec:"equip_star"`
	// base_attribute/equip_strength.csv
	Equip_strength map[int]*Base_attribute_equip_strength `yaml:"equip_strength" codec:"equip_strength"`
	// base_attribute/fight_soul_level.csv
	Fight_soul_level map[int]*Base_attribute_fight_soul_level `yaml:"fight_soul_level" codec:"fight_soul_level"`
	// base_attribute/hero_level.csv
	Hero_level map[int]*Base_attribute_hero_level `yaml:"hero_level" codec:"hero_level"`
	// base_attribute/monster
	Monster *Base_attribute_monster `yaml:"monster" codec:"monster"`
	// base_attribute/monster_gym
	Monster_gym *Base_attribute_monster_gym `yaml:"monster_gym" codec:"monster_gym"`
	// base_attribute/nature_matrix.csv
	Nature_matrix map[int]*Base_attribute_nature_matrix `yaml:"nature_matrix" codec:"nature_matrix"`
	// base_attribute/role_level.csv
	Role_level map[int]*Base_attribute_role_level `yaml:"role_level" codec:"role_level"`
	// base_attribute/scene_attr_correct.csv
	Scene_attr_correct map[int]*Base_attribute_scene_attr_correct `yaml:"scene_attr_correct" codec:"scene_attr_correct"`
	// base_attribute/skill_level.csv
	Skill_level map[int]*Base_attribute_skill_level `yaml:"skill_level" codec:"skill_level"`
}
// base_attribute/advance_level.csv
type Base_attribute_advance_level struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// damageC
	DamageC int `yaml:"damageC" codec:"damageC"`
	// damageGrow
	DamageGrow float64 `yaml:"damageGrow" codec:"damageGrow"`
	// defenceC
	DefenceC int `yaml:"defenceC" codec:"defenceC"`
	// defenceGrow
	DefenceGrow float64 `yaml:"defenceGrow" codec:"defenceGrow"`
	// gold
	Gold int `yaml:"gold" codec:"gold"`
	// hpC
	HpC int `yaml:"hpC" codec:"hpC"`
	// hpGrow
	HpGrow float64 `yaml:"hpGrow" codec:"hpGrow"`
	// itemMap
	ItemMap tjcsv.Map `yaml:"itemMap" codec:"itemMap"`
	// levelDec
	LevelDec int `yaml:"levelDec" codec:"levelDec"`
	// quality
	Quality int `yaml:"quality" codec:"quality"`
	// specialDamageC
	SpecialDamageC int `yaml:"specialDamageC" codec:"specialDamageC"`
	// specialDamageGrow
	SpecialDamageGrow float64 `yaml:"specialDamageGrow" codec:"specialDamageGrow"`
	// specialDefenceC
	SpecialDefenceC int `yaml:"specialDefenceC" codec:"specialDefenceC"`
	// specialDefenceGrow
	SpecialDefenceGrow float64 `yaml:"specialDefenceGrow" codec:"specialDefenceGrow"`
	// speedC
	SpeedC int `yaml:"speedC" codec:"speedC"`
	// speedGrow
	SpeedGrow float64 `yaml:"speedGrow" codec:"speedGrow"`
	// stage
	Stage int `yaml:"stage" codec:"stage"`
	// typeID
	TypeID int `yaml:"typeID" codec:"typeID"`
}
// base_attribute/base
type Base_attribute_base struct {
	// base_attribute/base/base_attribute.csv
	Base_attribute map[int]*Base_attribute_base_base_attribute `yaml:"base_attribute" codec:"base_attribute"`
}
// base_attribute/base/base_attribute.csv
type Base_attribute_base_base_attribute struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// block
	Block int `yaml:"block" codec:"block"`
	// blockPower
	BlockPower int `yaml:"blockPower" codec:"blockPower"`
	// breakBlock
	BreakBlock int `yaml:"breakBlock" codec:"breakBlock"`
	// controlPer
	ControlPer int `yaml:"controlPer" codec:"controlPer"`
	// cure
	Cure int `yaml:"cure" codec:"cure"`
	// damage
	Damage int `yaml:"damage" codec:"damage"`
	// damageAdd
	DamageAdd int `yaml:"damageAdd" codec:"damageAdd"`
	// damageDeepen
	DamageDeepen int `yaml:"damageDeepen" codec:"damageDeepen"`
	// damageDodge
	DamageDodge int `yaml:"damageDodge" codec:"damageDodge"`
	// damageHit
	DamageHit int `yaml:"damageHit" codec:"damageHit"`
	// damageReduce
	DamageReduce int `yaml:"damageReduce" codec:"damageReduce"`
	// damageSub
	DamageSub int `yaml:"damageSub" codec:"damageSub"`
	// defence
	Defence int `yaml:"defence" codec:"defence"`
	// defenceIgnore
	DefenceIgnore int `yaml:"defenceIgnore" codec:"defenceIgnore"`
	// dodge
	Dodge int `yaml:"dodge" codec:"dodge"`
	// hit
	Hit int `yaml:"hit" codec:"hit"`
	// hp
	Hp int `yaml:"hp" codec:"hp"`
	// hpRecover
	HpRecover int `yaml:"hpRecover" codec:"hpRecover"`
	// immuneControl
	ImmuneControl int `yaml:"immuneControl" codec:"immuneControl"`
	// initMp1
	InitMp1 int `yaml:"initMp1" codec:"initMp1"`
	// mp1
	Mp1 int `yaml:"mp1" codec:"mp1"`
	// mp1Recover
	Mp1Recover int `yaml:"mp1Recover" codec:"mp1Recover"`
	// mp2Recover
	Mp2Recover int `yaml:"mp2Recover" codec:"mp2Recover"`
	// natureRestraint
	NatureRestraint int `yaml:"natureRestraint" codec:"natureRestraint"`
	// rebound
	Rebound int `yaml:"rebound" codec:"rebound"`
	// specialDamage
	SpecialDamage int `yaml:"specialDamage" codec:"specialDamage"`
	// specialDefence
	SpecialDefence int `yaml:"specialDefence" codec:"specialDefence"`
	// specialDefenceIgnore
	SpecialDefenceIgnore int `yaml:"specialDefenceIgnore" codec:"specialDefenceIgnore"`
	// speed
	Speed int `yaml:"speed" codec:"speed"`
	// strike
	Strike int `yaml:"strike" codec:"strike"`
	// strikeDamage
	StrikeDamage int `yaml:"strikeDamage" codec:"strikeDamage"`
	// strikeResistance
	StrikeResistance int `yaml:"strikeResistance" codec:"strikeResistance"`
	// suckBlood
	SuckBlood int `yaml:"suckBlood" codec:"suckBlood"`
	// ultimateAdd
	UltimateAdd int `yaml:"ultimateAdd" codec:"ultimateAdd"`
	// ultimateSub
	UltimateSub int `yaml:"ultimateSub" codec:"ultimateSub"`
}
// base_attribute/bossmonster
type Base_attribute_bossmonster struct {
	// base_attribute/bossmonster/base_attribute.csv
	Base_attribute map[int]*Base_attribute_bossmonster_base_attribute `yaml:"base_attribute" codec:"base_attribute"`
}
// base_attribute/bossmonster/base_attribute.csv
type Base_attribute_bossmonster_base_attribute struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// block
	Block int `yaml:"block" codec:"block"`
	// blockPower
	BlockPower int `yaml:"blockPower" codec:"blockPower"`
	// breakBlock
	BreakBlock int `yaml:"breakBlock" codec:"breakBlock"`
	// controlPer
	ControlPer int `yaml:"controlPer" codec:"controlPer"`
	// cure
	Cure int `yaml:"cure" codec:"cure"`
	// damage
	Damage int `yaml:"damage" codec:"damage"`
	// damageAdd
	DamageAdd int `yaml:"damageAdd" codec:"damageAdd"`
	// damageDeepen
	DamageDeepen int `yaml:"damageDeepen" codec:"damageDeepen"`
	// damageDodge
	DamageDodge int `yaml:"damageDodge" codec:"damageDodge"`
	// damageHit
	DamageHit int `yaml:"damageHit" codec:"damageHit"`
	// damageReduce
	DamageReduce int `yaml:"damageReduce" codec:"damageReduce"`
	// damageSub
	DamageSub int `yaml:"damageSub" codec:"damageSub"`
	// defence
	Defence int `yaml:"defence" codec:"defence"`
	// defenceIgnore
	DefenceIgnore int `yaml:"defenceIgnore" codec:"defenceIgnore"`
	// dodge
	Dodge int `yaml:"dodge" codec:"dodge"`
	// hit
	Hit int `yaml:"hit" codec:"hit"`
	// hp
	Hp int `yaml:"hp" codec:"hp"`
	// hpRecover
	HpRecover int `yaml:"hpRecover" codec:"hpRecover"`
	// immuneControl
	ImmuneControl int `yaml:"immuneControl" codec:"immuneControl"`
	// initMp1
	InitMp1 int `yaml:"initMp1" codec:"initMp1"`
	// mp1
	Mp1 int `yaml:"mp1" codec:"mp1"`
	// mp1Recover
	Mp1Recover int `yaml:"mp1Recover" codec:"mp1Recover"`
	// mp2Recover
	Mp2Recover int `yaml:"mp2Recover" codec:"mp2Recover"`
	// natureRestraint
	NatureRestraint int `yaml:"natureRestraint" codec:"natureRestraint"`
	// rebound
	Rebound int `yaml:"rebound" codec:"rebound"`
	// specialDamage
	SpecialDamage int `yaml:"specialDamage" codec:"specialDamage"`
	// specialDefence
	SpecialDefence int `yaml:"specialDefence" codec:"specialDefence"`
	// specialDefenceIgnore
	SpecialDefenceIgnore int `yaml:"specialDefenceIgnore" codec:"specialDefenceIgnore"`
	// speed
	Speed int `yaml:"speed" codec:"speed"`
	// strike
	Strike int `yaml:"strike" codec:"strike"`
	// strikeDamage
	StrikeDamage int `yaml:"strikeDamage" codec:"strikeDamage"`
	// strikeResistance
	StrikeResistance int `yaml:"strikeResistance" codec:"strikeResistance"`
	// suckBlood
	SuckBlood int `yaml:"suckBlood" codec:"suckBlood"`
	// ultimateAdd
	UltimateAdd int `yaml:"ultimateAdd" codec:"ultimateAdd"`
	// ultimateSub
	UltimateSub int `yaml:"ultimateSub" codec:"ultimateSub"`
}
// base_attribute/bossmonster2
type Base_attribute_bossmonster2 struct {
	// base_attribute/bossmonster2/base_attribute.csv
	Base_attribute map[int]*Base_attribute_bossmonster2_base_attribute `yaml:"base_attribute" codec:"base_attribute"`
}
// base_attribute/bossmonster2/base_attribute.csv
type Base_attribute_bossmonster2_base_attribute struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// block
	Block int `yaml:"block" codec:"block"`
	// blockPower
	BlockPower int `yaml:"blockPower" codec:"blockPower"`
	// breakBlock
	BreakBlock int `yaml:"breakBlock" codec:"breakBlock"`
	// controlPer
	ControlPer int `yaml:"controlPer" codec:"controlPer"`
	// cure
	Cure int `yaml:"cure" codec:"cure"`
	// damage
	Damage int `yaml:"damage" codec:"damage"`
	// damageAdd
	DamageAdd int `yaml:"damageAdd" codec:"damageAdd"`
	// damageDeepen
	DamageDeepen int `yaml:"damageDeepen" codec:"damageDeepen"`
	// damageDodge
	DamageDodge int `yaml:"damageDodge" codec:"damageDodge"`
	// damageHit
	DamageHit int `yaml:"damageHit" codec:"damageHit"`
	// damageReduce
	DamageReduce int `yaml:"damageReduce" codec:"damageReduce"`
	// damageSub
	DamageSub int `yaml:"damageSub" codec:"damageSub"`
	// defence
	Defence int `yaml:"defence" codec:"defence"`
	// defenceIgnore
	DefenceIgnore int `yaml:"defenceIgnore" codec:"defenceIgnore"`
	// dodge
	Dodge int `yaml:"dodge" codec:"dodge"`
	// hit
	Hit int `yaml:"hit" codec:"hit"`
	// hp
	Hp int `yaml:"hp" codec:"hp"`
	// hpRecover
	HpRecover int `yaml:"hpRecover" codec:"hpRecover"`
	// immuneControl
	ImmuneControl int `yaml:"immuneControl" codec:"immuneControl"`
	// initMp1
	InitMp1 int `yaml:"initMp1" codec:"initMp1"`
	// mp1
	Mp1 int `yaml:"mp1" codec:"mp1"`
	// mp1Recover
	Mp1Recover int `yaml:"mp1Recover" codec:"mp1Recover"`
	// mp2Recover
	Mp2Recover int `yaml:"mp2Recover" codec:"mp2Recover"`
	// natureRestraint
	NatureRestraint int `yaml:"natureRestraint" codec:"natureRestraint"`
	// rebound
	Rebound int `yaml:"rebound" codec:"rebound"`
	// specialDamage
	SpecialDamage int `yaml:"specialDamage" codec:"specialDamage"`
	// specialDefence
	SpecialDefence int `yaml:"specialDefence" codec:"specialDefence"`
	// specialDefenceIgnore
	SpecialDefenceIgnore int `yaml:"specialDefenceIgnore" codec:"specialDefenceIgnore"`
	// speed
	Speed int `yaml:"speed" codec:"speed"`
	// strike
	Strike int `yaml:"strike" codec:"strike"`
	// strikeDamage
	StrikeDamage int `yaml:"strikeDamage" codec:"strikeDamage"`
	// strikeResistance
	StrikeResistance int `yaml:"strikeResistance" codec:"strikeResistance"`
	// suckBlood
	SuckBlood int `yaml:"suckBlood" codec:"suckBlood"`
	// ultimateAdd
	UltimateAdd int `yaml:"ultimateAdd" codec:"ultimateAdd"`
	// ultimateSub
	UltimateSub int `yaml:"ultimateSub" codec:"ultimateSub"`
}
// base_attribute/card_level.csv
type Base_attribute_card_level struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// levelExp1
	LevelExp1 int `yaml:"levelExp1" codec:"levelExp1"`
	// levelExp2
	LevelExp2 int `yaml:"levelExp2" codec:"levelExp2"`
	// levelExp3
	LevelExp3 int `yaml:"levelExp3" codec:"levelExp3"`
	// levelExp4
	LevelExp4 int `yaml:"levelExp4" codec:"levelExp4"`
	// levelExp5
	LevelExp5 int `yaml:"levelExp5" codec:"levelExp5"`
	// levelExp6
	LevelExp6 int `yaml:"levelExp6" codec:"levelExp6"`
}
// base_attribute/common
type Base_attribute_common struct {
	// base_attribute/common/base_attribute.csv
	Base_attribute map[int]*Base_attribute_common_base_attribute `yaml:"base_attribute" codec:"base_attribute"`
}
// base_attribute/common/base_attribute.csv
type Base_attribute_common_base_attribute struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// block
	Block int `yaml:"block" codec:"block"`
	// blockPower
	BlockPower int `yaml:"blockPower" codec:"blockPower"`
	// breakBlock
	BreakBlock int `yaml:"breakBlock" codec:"breakBlock"`
	// controlPer
	ControlPer int `yaml:"controlPer" codec:"controlPer"`
	// cure
	Cure int `yaml:"cure" codec:"cure"`
	// damage
	Damage int `yaml:"damage" codec:"damage"`
	// damageAdd
	DamageAdd int `yaml:"damageAdd" codec:"damageAdd"`
	// damageDeepen
	DamageDeepen int `yaml:"damageDeepen" codec:"damageDeepen"`
	// damageDodge
	DamageDodge int `yaml:"damageDodge" codec:"damageDodge"`
	// damageHit
	DamageHit int `yaml:"damageHit" codec:"damageHit"`
	// damageReduce
	DamageReduce int `yaml:"damageReduce" codec:"damageReduce"`
	// damageSub
	DamageSub int `yaml:"damageSub" codec:"damageSub"`
	// defence
	Defence int `yaml:"defence" codec:"defence"`
	// defenceIgnore
	DefenceIgnore int `yaml:"defenceIgnore" codec:"defenceIgnore"`
	// dodge
	Dodge int `yaml:"dodge" codec:"dodge"`
	// hit
	Hit int `yaml:"hit" codec:"hit"`
	// hp
	Hp int `yaml:"hp" codec:"hp"`
	// hpRecover
	HpRecover int `yaml:"hpRecover" codec:"hpRecover"`
	// immuneControl
	ImmuneControl int `yaml:"immuneControl" codec:"immuneControl"`
	// initMp1
	InitMp1 int `yaml:"initMp1" codec:"initMp1"`
	// mp1
	Mp1 int `yaml:"mp1" codec:"mp1"`
	// mp1Recover
	Mp1Recover int `yaml:"mp1Recover" codec:"mp1Recover"`
	// mp2Recover
	Mp2Recover int `yaml:"mp2Recover" codec:"mp2Recover"`
	// natureRestraint
	NatureRestraint int `yaml:"natureRestraint" codec:"natureRestraint"`
	// rebound
	Rebound int `yaml:"rebound" codec:"rebound"`
	// specialDamage
	SpecialDamage int `yaml:"specialDamage" codec:"specialDamage"`
	// specialDefence
	SpecialDefence int `yaml:"specialDefence" codec:"specialDefence"`
	// specialDefenceIgnore
	SpecialDefenceIgnore int `yaml:"specialDefenceIgnore" codec:"specialDefenceIgnore"`
	// speed
	Speed int `yaml:"speed" codec:"speed"`
	// strike
	Strike int `yaml:"strike" codec:"strike"`
	// strikeDamage
	StrikeDamage int `yaml:"strikeDamage" codec:"strikeDamage"`
	// strikeResistance
	StrikeResistance int `yaml:"strikeResistance" codec:"strikeResistance"`
	// suckBlood
	SuckBlood int `yaml:"suckBlood" codec:"suckBlood"`
	// ultimateAdd
	UltimateAdd int `yaml:"ultimateAdd" codec:"ultimateAdd"`
	// ultimateSub
	UltimateSub int `yaml:"ultimateSub" codec:"ultimateSub"`
}
// base_attribute/controllbufftype.csv
type Base_attribute_controllbufftype struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// controllBuffType
	ControllBuffType string `yaml:"controllBuffType" codec:"controllBuffType"`
	// unlock
	Unlock bool `yaml:"unlock" codec:"unlock"`
}
// base_attribute/develop_level.csv
type Base_attribute_develop_level struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// cost
	Cost tjcsv.Map `yaml:"cost" codec:"cost"`
	// needAdvance
	NeedAdvance int `yaml:"needAdvance" codec:"needAdvance"`
	// needLevel
	NeedLevel int `yaml:"needLevel" codec:"needLevel"`
	// needStar
	NeedStar int `yaml:"needStar" codec:"needStar"`
}
// base_attribute/elites
type Base_attribute_elites struct {
	// base_attribute/elites/base_attribute.csv
	Base_attribute map[int]*Base_attribute_elites_base_attribute `yaml:"base_attribute" codec:"base_attribute"`
}
// base_attribute/elites/base_attribute.csv
type Base_attribute_elites_base_attribute struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// block
	Block int `yaml:"block" codec:"block"`
	// blockPower
	BlockPower int `yaml:"blockPower" codec:"blockPower"`
	// breakBlock
	BreakBlock int `yaml:"breakBlock" codec:"breakBlock"`
	// controlPer
	ControlPer int `yaml:"controlPer" codec:"controlPer"`
	// cure
	Cure int `yaml:"cure" codec:"cure"`
	// damage
	Damage int `yaml:"damage" codec:"damage"`
	// damageAdd
	DamageAdd int `yaml:"damageAdd" codec:"damageAdd"`
	// damageDeepen
	DamageDeepen int `yaml:"damageDeepen" codec:"damageDeepen"`
	// damageDodge
	DamageDodge int `yaml:"damageDodge" codec:"damageDodge"`
	// damageHit
	DamageHit int `yaml:"damageHit" codec:"damageHit"`
	// damageReduce
	DamageReduce int `yaml:"damageReduce" codec:"damageReduce"`
	// damageSub
	DamageSub int `yaml:"damageSub" codec:"damageSub"`
	// defence
	Defence int `yaml:"defence" codec:"defence"`
	// defenceIgnore
	DefenceIgnore int `yaml:"defenceIgnore" codec:"defenceIgnore"`
	// dodge
	Dodge int `yaml:"dodge" codec:"dodge"`
	// hit
	Hit int `yaml:"hit" codec:"hit"`
	// hp
	Hp int `yaml:"hp" codec:"hp"`
	// hpRecover
	HpRecover int `yaml:"hpRecover" codec:"hpRecover"`
	// immuneControl
	ImmuneControl int `yaml:"immuneControl" codec:"immuneControl"`
	// initMp1
	InitMp1 int `yaml:"initMp1" codec:"initMp1"`
	// mp1
	Mp1 int `yaml:"mp1" codec:"mp1"`
	// mp1Recover
	Mp1Recover int `yaml:"mp1Recover" codec:"mp1Recover"`
	// mp2Recover
	Mp2Recover int `yaml:"mp2Recover" codec:"mp2Recover"`
	// natureRestraint
	NatureRestraint int `yaml:"natureRestraint" codec:"natureRestraint"`
	// rebound
	Rebound int `yaml:"rebound" codec:"rebound"`
	// specialDamage
	SpecialDamage int `yaml:"specialDamage" codec:"specialDamage"`
	// specialDefence
	SpecialDefence int `yaml:"specialDefence" codec:"specialDefence"`
	// specialDefenceIgnore
	SpecialDefenceIgnore int `yaml:"specialDefenceIgnore" codec:"specialDefenceIgnore"`
	// speed
	Speed int `yaml:"speed" codec:"speed"`
	// strike
	Strike int `yaml:"strike" codec:"strike"`
	// strikeDamage
	StrikeDamage int `yaml:"strikeDamage" codec:"strikeDamage"`
	// strikeResistance
	StrikeResistance int `yaml:"strikeResistance" codec:"strikeResistance"`
	// suckBlood
	SuckBlood int `yaml:"suckBlood" codec:"suckBlood"`
	// ultimateAdd
	UltimateAdd int `yaml:"ultimateAdd" codec:"ultimateAdd"`
	// ultimateSub
	UltimateSub int `yaml:"ultimateSub" codec:"ultimateSub"`
}
// base_attribute/elitesmonster
type Base_attribute_elitesmonster struct {
	// base_attribute/elitesmonster/base_attribute.csv
	Base_attribute map[int]*Base_attribute_elitesmonster_base_attribute `yaml:"base_attribute" codec:"base_attribute"`
}
// base_attribute/elitesmonster/base_attribute.csv
type Base_attribute_elitesmonster_base_attribute struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// block
	Block int `yaml:"block" codec:"block"`
	// blockPower
	BlockPower int `yaml:"blockPower" codec:"blockPower"`
	// breakBlock
	BreakBlock int `yaml:"breakBlock" codec:"breakBlock"`
	// controlPer
	ControlPer int `yaml:"controlPer" codec:"controlPer"`
	// cure
	Cure int `yaml:"cure" codec:"cure"`
	// damage
	Damage int `yaml:"damage" codec:"damage"`
	// damageAdd
	DamageAdd int `yaml:"damageAdd" codec:"damageAdd"`
	// damageDeepen
	DamageDeepen int `yaml:"damageDeepen" codec:"damageDeepen"`
	// damageDodge
	DamageDodge int `yaml:"damageDodge" codec:"damageDodge"`
	// damageHit
	DamageHit int `yaml:"damageHit" codec:"damageHit"`
	// damageReduce
	DamageReduce int `yaml:"damageReduce" codec:"damageReduce"`
	// damageSub
	DamageSub int `yaml:"damageSub" codec:"damageSub"`
	// defence
	Defence int `yaml:"defence" codec:"defence"`
	// defenceIgnore
	DefenceIgnore int `yaml:"defenceIgnore" codec:"defenceIgnore"`
	// dodge
	Dodge int `yaml:"dodge" codec:"dodge"`
	// hit
	Hit int `yaml:"hit" codec:"hit"`
	// hp
	Hp int `yaml:"hp" codec:"hp"`
	// hpRecover
	HpRecover int `yaml:"hpRecover" codec:"hpRecover"`
	// immuneControl
	ImmuneControl int `yaml:"immuneControl" codec:"immuneControl"`
	// initMp1
	InitMp1 int `yaml:"initMp1" codec:"initMp1"`
	// mp1
	Mp1 int `yaml:"mp1" codec:"mp1"`
	// mp1Recover
	Mp1Recover int `yaml:"mp1Recover" codec:"mp1Recover"`
	// mp2Recover
	Mp2Recover int `yaml:"mp2Recover" codec:"mp2Recover"`
	// natureRestraint
	NatureRestraint int `yaml:"natureRestraint" codec:"natureRestraint"`
	// rebound
	Rebound int `yaml:"rebound" codec:"rebound"`
	// specialDamage
	SpecialDamage int `yaml:"specialDamage" codec:"specialDamage"`
	// specialDefence
	SpecialDefence int `yaml:"specialDefence" codec:"specialDefence"`
	// specialDefenceIgnore
	SpecialDefenceIgnore int `yaml:"specialDefenceIgnore" codec:"specialDefenceIgnore"`
	// speed
	Speed int `yaml:"speed" codec:"speed"`
	// strike
	Strike int `yaml:"strike" codec:"strike"`
	// strikeDamage
	StrikeDamage int `yaml:"strikeDamage" codec:"strikeDamage"`
	// strikeResistance
	StrikeResistance int `yaml:"strikeResistance" codec:"strikeResistance"`
	// suckBlood
	SuckBlood int `yaml:"suckBlood" codec:"suckBlood"`
	// ultimateAdd
	UltimateAdd int `yaml:"ultimateAdd" codec:"ultimateAdd"`
	// ultimateSub
	UltimateSub int `yaml:"ultimateSub" codec:"ultimateSub"`
}
// base_attribute/equip_ability.csv
type Base_attribute_equip_ability struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// costItemMap1
	CostItemMap1 tjcsv.Map `yaml:"costItemMap1" codec:"costItemMap1"`
	// costItemMap2
	CostItemMap2 tjcsv.Map `yaml:"costItemMap2" codec:"costItemMap2"`
	// costItemMap3
	CostItemMap3 tjcsv.Map `yaml:"costItemMap3" codec:"costItemMap3"`
	// costItemMap4
	CostItemMap4 tjcsv.Map `yaml:"costItemMap4" codec:"costItemMap4"`
	// costItemMap5
	CostItemMap5 tjcsv.Map `yaml:"costItemMap5" codec:"costItemMap5"`
}
// base_attribute/equip_advance.csv
type Base_attribute_equip_advance struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// costGold
	CostGold int `yaml:"costGold" codec:"costGold"`
	// costItemMap
	CostItemMap tjcsv.Map `yaml:"costItemMap" codec:"costItemMap"`
	// stage
	Stage int `yaml:"stage" codec:"stage"`
}
// base_attribute/equip_awake.csv
type Base_attribute_equip_awake struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// costItemMap1
	CostItemMap1 tjcsv.Map `yaml:"costItemMap1" codec:"costItemMap1"`
	// costItemMap10
	CostItemMap10 tjcsv.Map `yaml:"costItemMap10" codec:"costItemMap10"`
	// costItemMap11
	CostItemMap11 tjcsv.Map `yaml:"costItemMap11" codec:"costItemMap11"`
	// costItemMap12
	CostItemMap12 tjcsv.Map `yaml:"costItemMap12" codec:"costItemMap12"`
	// costItemMap13
	CostItemMap13 tjcsv.Map `yaml:"costItemMap13" codec:"costItemMap13"`
	// costItemMap14
	CostItemMap14 tjcsv.Map `yaml:"costItemMap14" codec:"costItemMap14"`
	// costItemMap15
	CostItemMap15 tjcsv.Map `yaml:"costItemMap15" codec:"costItemMap15"`
	// costItemMap16
	CostItemMap16 tjcsv.Map `yaml:"costItemMap16" codec:"costItemMap16"`
	// costItemMap17
	CostItemMap17 tjcsv.Map `yaml:"costItemMap17" codec:"costItemMap17"`
	// costItemMap18
	CostItemMap18 tjcsv.Map `yaml:"costItemMap18" codec:"costItemMap18"`
	// costItemMap19
	CostItemMap19 tjcsv.Map `yaml:"costItemMap19" codec:"costItemMap19"`
	// costItemMap2
	CostItemMap2 tjcsv.Map `yaml:"costItemMap2" codec:"costItemMap2"`
	// costItemMap20
	CostItemMap20 tjcsv.Map `yaml:"costItemMap20" codec:"costItemMap20"`
	// costItemMap21
	CostItemMap21 tjcsv.Map `yaml:"costItemMap21" codec:"costItemMap21"`
	// costItemMap22
	CostItemMap22 tjcsv.Map `yaml:"costItemMap22" codec:"costItemMap22"`
	// costItemMap23
	CostItemMap23 tjcsv.Map `yaml:"costItemMap23" codec:"costItemMap23"`
	// costItemMap24
	CostItemMap24 tjcsv.Map `yaml:"costItemMap24" codec:"costItemMap24"`
	// costItemMap25
	CostItemMap25 tjcsv.Map `yaml:"costItemMap25" codec:"costItemMap25"`
	// costItemMap26
	CostItemMap26 tjcsv.Map `yaml:"costItemMap26" codec:"costItemMap26"`
	// costItemMap27
	CostItemMap27 tjcsv.Map `yaml:"costItemMap27" codec:"costItemMap27"`
	// costItemMap28
	CostItemMap28 tjcsv.Map `yaml:"costItemMap28" codec:"costItemMap28"`
	// costItemMap29
	CostItemMap29 tjcsv.Map `yaml:"costItemMap29" codec:"costItemMap29"`
	// costItemMap3
	CostItemMap3 tjcsv.Map `yaml:"costItemMap3" codec:"costItemMap3"`
	// costItemMap30
	CostItemMap30 tjcsv.Map `yaml:"costItemMap30" codec:"costItemMap30"`
	// costItemMap31
	CostItemMap31 tjcsv.Map `yaml:"costItemMap31" codec:"costItemMap31"`
	// costItemMap32
	CostItemMap32 tjcsv.Map `yaml:"costItemMap32" codec:"costItemMap32"`
	// costItemMap33
	CostItemMap33 tjcsv.Map `yaml:"costItemMap33" codec:"costItemMap33"`
	// costItemMap34
	CostItemMap34 tjcsv.Map `yaml:"costItemMap34" codec:"costItemMap34"`
	// costItemMap35
	CostItemMap35 tjcsv.Map `yaml:"costItemMap35" codec:"costItemMap35"`
	// costItemMap36
	CostItemMap36 tjcsv.Map `yaml:"costItemMap36" codec:"costItemMap36"`
	// costItemMap37
	CostItemMap37 tjcsv.Map `yaml:"costItemMap37" codec:"costItemMap37"`
	// costItemMap38
	CostItemMap38 tjcsv.Map `yaml:"costItemMap38" codec:"costItemMap38"`
	// costItemMap39
	CostItemMap39 tjcsv.Map `yaml:"costItemMap39" codec:"costItemMap39"`
	// costItemMap4
	CostItemMap4 tjcsv.Map `yaml:"costItemMap4" codec:"costItemMap4"`
	// costItemMap40
	CostItemMap40 tjcsv.Map `yaml:"costItemMap40" codec:"costItemMap40"`
	// costItemMap41
	CostItemMap41 tjcsv.Map `yaml:"costItemMap41" codec:"costItemMap41"`
	// costItemMap42
	CostItemMap42 tjcsv.Map `yaml:"costItemMap42" codec:"costItemMap42"`
	// costItemMap43
	CostItemMap43 tjcsv.Map `yaml:"costItemMap43" codec:"costItemMap43"`
	// costItemMap44
	CostItemMap44 tjcsv.Map `yaml:"costItemMap44" codec:"costItemMap44"`
	// costItemMap45
	CostItemMap45 tjcsv.Map `yaml:"costItemMap45" codec:"costItemMap45"`
	// costItemMap46
	CostItemMap46 tjcsv.Map `yaml:"costItemMap46" codec:"costItemMap46"`
	// costItemMap47
	CostItemMap47 tjcsv.Map `yaml:"costItemMap47" codec:"costItemMap47"`
	// costItemMap48
	CostItemMap48 tjcsv.Map `yaml:"costItemMap48" codec:"costItemMap48"`
	// costItemMap49
	CostItemMap49 tjcsv.Map `yaml:"costItemMap49" codec:"costItemMap49"`
	// costItemMap5
	CostItemMap5 tjcsv.Map `yaml:"costItemMap5" codec:"costItemMap5"`
	// costItemMap50
	CostItemMap50 tjcsv.Map `yaml:"costItemMap50" codec:"costItemMap50"`
	// costItemMap51
	CostItemMap51 tjcsv.Map `yaml:"costItemMap51" codec:"costItemMap51"`
	// costItemMap52
	CostItemMap52 tjcsv.Map `yaml:"costItemMap52" codec:"costItemMap52"`
	// costItemMap6
	CostItemMap6 tjcsv.Map `yaml:"costItemMap6" codec:"costItemMap6"`
	// costItemMap7
	CostItemMap7 tjcsv.Map `yaml:"costItemMap7" codec:"costItemMap7"`
	// costItemMap8
	CostItemMap8 tjcsv.Map `yaml:"costItemMap8" codec:"costItemMap8"`
	// costItemMap9
	CostItemMap9 tjcsv.Map `yaml:"costItemMap9" codec:"costItemMap9"`
}
// base_attribute/equip_awake_ability.csv
type Base_attribute_equip_awake_ability struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// costItemMap1
	CostItemMap1 tjcsv.Map `yaml:"costItemMap1" codec:"costItemMap1"`
	// costItemMap10
	CostItemMap10 tjcsv.Map `yaml:"costItemMap10" codec:"costItemMap10"`
	// costItemMap11
	CostItemMap11 tjcsv.Map `yaml:"costItemMap11" codec:"costItemMap11"`
	// costItemMap12
	CostItemMap12 tjcsv.Map `yaml:"costItemMap12" codec:"costItemMap12"`
	// costItemMap13
	CostItemMap13 tjcsv.Map `yaml:"costItemMap13" codec:"costItemMap13"`
	// costItemMap14
	CostItemMap14 tjcsv.Map `yaml:"costItemMap14" codec:"costItemMap14"`
	// costItemMap15
	CostItemMap15 tjcsv.Map `yaml:"costItemMap15" codec:"costItemMap15"`
	// costItemMap16
	CostItemMap16 tjcsv.Map `yaml:"costItemMap16" codec:"costItemMap16"`
	// costItemMap17
	CostItemMap17 tjcsv.Map `yaml:"costItemMap17" codec:"costItemMap17"`
	// costItemMap18
	CostItemMap18 tjcsv.Map `yaml:"costItemMap18" codec:"costItemMap18"`
	// costItemMap19
	CostItemMap19 tjcsv.Map `yaml:"costItemMap19" codec:"costItemMap19"`
	// costItemMap2
	CostItemMap2 tjcsv.Map `yaml:"costItemMap2" codec:"costItemMap2"`
	// costItemMap20
	CostItemMap20 tjcsv.Map `yaml:"costItemMap20" codec:"costItemMap20"`
	// costItemMap21
	CostItemMap21 tjcsv.Map `yaml:"costItemMap21" codec:"costItemMap21"`
	// costItemMap22
	CostItemMap22 tjcsv.Map `yaml:"costItemMap22" codec:"costItemMap22"`
	// costItemMap23
	CostItemMap23 tjcsv.Map `yaml:"costItemMap23" codec:"costItemMap23"`
	// costItemMap24
	CostItemMap24 tjcsv.Map `yaml:"costItemMap24" codec:"costItemMap24"`
	// costItemMap25
	CostItemMap25 tjcsv.Map `yaml:"costItemMap25" codec:"costItemMap25"`
	// costItemMap26
	CostItemMap26 tjcsv.Map `yaml:"costItemMap26" codec:"costItemMap26"`
	// costItemMap27
	CostItemMap27 tjcsv.Map `yaml:"costItemMap27" codec:"costItemMap27"`
	// costItemMap28
	CostItemMap28 tjcsv.Map `yaml:"costItemMap28" codec:"costItemMap28"`
	// costItemMap29
	CostItemMap29 tjcsv.Map `yaml:"costItemMap29" codec:"costItemMap29"`
	// costItemMap3
	CostItemMap3 tjcsv.Map `yaml:"costItemMap3" codec:"costItemMap3"`
	// costItemMap30
	CostItemMap30 tjcsv.Map `yaml:"costItemMap30" codec:"costItemMap30"`
	// costItemMap31
	CostItemMap31 tjcsv.Map `yaml:"costItemMap31" codec:"costItemMap31"`
	// costItemMap32
	CostItemMap32 tjcsv.Map `yaml:"costItemMap32" codec:"costItemMap32"`
	// costItemMap33
	CostItemMap33 tjcsv.Map `yaml:"costItemMap33" codec:"costItemMap33"`
	// costItemMap34
	CostItemMap34 tjcsv.Map `yaml:"costItemMap34" codec:"costItemMap34"`
	// costItemMap35
	CostItemMap35 tjcsv.Map `yaml:"costItemMap35" codec:"costItemMap35"`
	// costItemMap36
	CostItemMap36 tjcsv.Map `yaml:"costItemMap36" codec:"costItemMap36"`
	// costItemMap37
	CostItemMap37 tjcsv.Map `yaml:"costItemMap37" codec:"costItemMap37"`
	// costItemMap38
	CostItemMap38 tjcsv.Map `yaml:"costItemMap38" codec:"costItemMap38"`
	// costItemMap39
	CostItemMap39 tjcsv.Map `yaml:"costItemMap39" codec:"costItemMap39"`
	// costItemMap4
	CostItemMap4 tjcsv.Map `yaml:"costItemMap4" codec:"costItemMap4"`
	// costItemMap40
	CostItemMap40 tjcsv.Map `yaml:"costItemMap40" codec:"costItemMap40"`
	// costItemMap41
	CostItemMap41 tjcsv.Map `yaml:"costItemMap41" codec:"costItemMap41"`
	// costItemMap42
	CostItemMap42 tjcsv.Map `yaml:"costItemMap42" codec:"costItemMap42"`
	// costItemMap43
	CostItemMap43 tjcsv.Map `yaml:"costItemMap43" codec:"costItemMap43"`
	// costItemMap44
	CostItemMap44 tjcsv.Map `yaml:"costItemMap44" codec:"costItemMap44"`
	// costItemMap45
	CostItemMap45 tjcsv.Map `yaml:"costItemMap45" codec:"costItemMap45"`
	// costItemMap46
	CostItemMap46 tjcsv.Map `yaml:"costItemMap46" codec:"costItemMap46"`
	// costItemMap47
	CostItemMap47 tjcsv.Map `yaml:"costItemMap47" codec:"costItemMap47"`
	// costItemMap48
	CostItemMap48 tjcsv.Map `yaml:"costItemMap48" codec:"costItemMap48"`
	// costItemMap5
	CostItemMap5 tjcsv.Map `yaml:"costItemMap5" codec:"costItemMap5"`
	// costItemMap6
	CostItemMap6 tjcsv.Map `yaml:"costItemMap6" codec:"costItemMap6"`
	// costItemMap7
	CostItemMap7 tjcsv.Map `yaml:"costItemMap7" codec:"costItemMap7"`
	// costItemMap8
	CostItemMap8 tjcsv.Map `yaml:"costItemMap8" codec:"costItemMap8"`
	// costItemMap9
	CostItemMap9 tjcsv.Map `yaml:"costItemMap9" codec:"costItemMap9"`
}
// base_attribute/equip_signet.csv
type Base_attribute_equip_signet struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// costItemMap1
	CostItemMap1 tjcsv.Map `yaml:"costItemMap1" codec:"costItemMap1"`
	// costItemMap10
	CostItemMap10 tjcsv.Map `yaml:"costItemMap10" codec:"costItemMap10"`
	// costItemMap11
	CostItemMap11 tjcsv.Map `yaml:"costItemMap11" codec:"costItemMap11"`
	// costItemMap12
	CostItemMap12 tjcsv.Map `yaml:"costItemMap12" codec:"costItemMap12"`
	// costItemMap13
	CostItemMap13 tjcsv.Map `yaml:"costItemMap13" codec:"costItemMap13"`
	// costItemMap14
	CostItemMap14 tjcsv.Map `yaml:"costItemMap14" codec:"costItemMap14"`
	// costItemMap15
	CostItemMap15 tjcsv.Map `yaml:"costItemMap15" codec:"costItemMap15"`
	// costItemMap16
	CostItemMap16 tjcsv.Map `yaml:"costItemMap16" codec:"costItemMap16"`
	// costItemMap17
	CostItemMap17 tjcsv.Map `yaml:"costItemMap17" codec:"costItemMap17"`
	// costItemMap18
	CostItemMap18 tjcsv.Map `yaml:"costItemMap18" codec:"costItemMap18"`
	// costItemMap19
	CostItemMap19 tjcsv.Map `yaml:"costItemMap19" codec:"costItemMap19"`
	// costItemMap2
	CostItemMap2 tjcsv.Map `yaml:"costItemMap2" codec:"costItemMap2"`
	// costItemMap20
	CostItemMap20 tjcsv.Map `yaml:"costItemMap20" codec:"costItemMap20"`
	// costItemMap3
	CostItemMap3 tjcsv.Map `yaml:"costItemMap3" codec:"costItemMap3"`
	// costItemMap4
	CostItemMap4 tjcsv.Map `yaml:"costItemMap4" codec:"costItemMap4"`
	// costItemMap5
	CostItemMap5 tjcsv.Map `yaml:"costItemMap5" codec:"costItemMap5"`
	// costItemMap6
	CostItemMap6 tjcsv.Map `yaml:"costItemMap6" codec:"costItemMap6"`
	// costItemMap7
	CostItemMap7 tjcsv.Map `yaml:"costItemMap7" codec:"costItemMap7"`
	// costItemMap8
	CostItemMap8 tjcsv.Map `yaml:"costItemMap8" codec:"costItemMap8"`
	// costItemMap9
	CostItemMap9 tjcsv.Map `yaml:"costItemMap9" codec:"costItemMap9"`
}
// base_attribute/equip_signet_advance.csv
type Base_attribute_equip_signet_advance struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// advanceIndex
	AdvanceIndex int `yaml:"advanceIndex" codec:"advanceIndex"`
	// advanceLevel
	AdvanceLevel int `yaml:"advanceLevel" codec:"advanceLevel"`
	// advanceLimitNum
	AdvanceLimitNum int `yaml:"advanceLimitNum" codec:"advanceLimitNum"`
	// advanceLimitType
	AdvanceLimitType int `yaml:"advanceLimitType" codec:"advanceLimitType"`
	// advanceName
	AdvanceName string `yaml:"advanceName" codec:"advanceName"`
	// advanceSeqID
	AdvanceSeqID int `yaml:"advanceSeqID" codec:"advanceSeqID"`
	// attrNum1
	AttrNum1 string `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 string `yaml:"attrNum2" codec:"attrNum2"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// sceneType
	SceneType tjcsv.Slice `yaml:"sceneType" codec:"sceneType"`
}
// base_attribute/equip_signet_advance_cost.csv
type Base_attribute_equip_signet_advance_cost struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// costItemMap1
	CostItemMap1 tjcsv.Map `yaml:"costItemMap1" codec:"costItemMap1"`
	// costItemMap10
	CostItemMap10 tjcsv.Map `yaml:"costItemMap10" codec:"costItemMap10"`
	// costItemMap11
	CostItemMap11 tjcsv.Map `yaml:"costItemMap11" codec:"costItemMap11"`
	// costItemMap12
	CostItemMap12 tjcsv.Map `yaml:"costItemMap12" codec:"costItemMap12"`
	// costItemMap13
	CostItemMap13 tjcsv.Map `yaml:"costItemMap13" codec:"costItemMap13"`
	// costItemMap14
	CostItemMap14 tjcsv.Map `yaml:"costItemMap14" codec:"costItemMap14"`
	// costItemMap15
	CostItemMap15 tjcsv.Map `yaml:"costItemMap15" codec:"costItemMap15"`
	// costItemMap16
	CostItemMap16 tjcsv.Map `yaml:"costItemMap16" codec:"costItemMap16"`
	// costItemMap17
	CostItemMap17 tjcsv.Map `yaml:"costItemMap17" codec:"costItemMap17"`
	// costItemMap18
	CostItemMap18 tjcsv.Map `yaml:"costItemMap18" codec:"costItemMap18"`
	// costItemMap19
	CostItemMap19 tjcsv.Map `yaml:"costItemMap19" codec:"costItemMap19"`
	// costItemMap2
	CostItemMap2 tjcsv.Map `yaml:"costItemMap2" codec:"costItemMap2"`
	// costItemMap20
	CostItemMap20 tjcsv.Map `yaml:"costItemMap20" codec:"costItemMap20"`
	// costItemMap3
	CostItemMap3 tjcsv.Map `yaml:"costItemMap3" codec:"costItemMap3"`
	// costItemMap4
	CostItemMap4 tjcsv.Map `yaml:"costItemMap4" codec:"costItemMap4"`
	// costItemMap5
	CostItemMap5 tjcsv.Map `yaml:"costItemMap5" codec:"costItemMap5"`
	// costItemMap6
	CostItemMap6 tjcsv.Map `yaml:"costItemMap6" codec:"costItemMap6"`
	// costItemMap7
	CostItemMap7 tjcsv.Map `yaml:"costItemMap7" codec:"costItemMap7"`
	// costItemMap8
	CostItemMap8 tjcsv.Map `yaml:"costItemMap8" codec:"costItemMap8"`
	// costItemMap9
	CostItemMap9 tjcsv.Map `yaml:"costItemMap9" codec:"costItemMap9"`
}
// base_attribute/equip_star.csv
type Base_attribute_equip_star struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// costItemMap1
	CostItemMap1 tjcsv.Map `yaml:"costItemMap1" codec:"costItemMap1"`
	// costItemMap10
	CostItemMap10 tjcsv.Map `yaml:"costItemMap10" codec:"costItemMap10"`
	// costItemMap11
	CostItemMap11 tjcsv.Map `yaml:"costItemMap11" codec:"costItemMap11"`
	// costItemMap12
	CostItemMap12 tjcsv.Map `yaml:"costItemMap12" codec:"costItemMap12"`
	// costItemMap13
	CostItemMap13 tjcsv.Map `yaml:"costItemMap13" codec:"costItemMap13"`
	// costItemMap14
	CostItemMap14 tjcsv.Map `yaml:"costItemMap14" codec:"costItemMap14"`
	// costItemMap15
	CostItemMap15 tjcsv.Map `yaml:"costItemMap15" codec:"costItemMap15"`
	// costItemMap16
	CostItemMap16 tjcsv.Map `yaml:"costItemMap16" codec:"costItemMap16"`
	// costItemMap17
	CostItemMap17 tjcsv.Map `yaml:"costItemMap17" codec:"costItemMap17"`
	// costItemMap18
	CostItemMap18 tjcsv.Map `yaml:"costItemMap18" codec:"costItemMap18"`
	// costItemMap19
	CostItemMap19 tjcsv.Map `yaml:"costItemMap19" codec:"costItemMap19"`
	// costItemMap2
	CostItemMap2 tjcsv.Map `yaml:"costItemMap2" codec:"costItemMap2"`
	// costItemMap20
	CostItemMap20 tjcsv.Map `yaml:"costItemMap20" codec:"costItemMap20"`
	// costItemMap21
	CostItemMap21 tjcsv.Map `yaml:"costItemMap21" codec:"costItemMap21"`
	// costItemMap22
	CostItemMap22 tjcsv.Map `yaml:"costItemMap22" codec:"costItemMap22"`
	// costItemMap23
	CostItemMap23 tjcsv.Map `yaml:"costItemMap23" codec:"costItemMap23"`
	// costItemMap24
	CostItemMap24 tjcsv.Map `yaml:"costItemMap24" codec:"costItemMap24"`
	// costItemMap25
	CostItemMap25 tjcsv.Map `yaml:"costItemMap25" codec:"costItemMap25"`
	// costItemMap26
	CostItemMap26 tjcsv.Map `yaml:"costItemMap26" codec:"costItemMap26"`
	// costItemMap27
	CostItemMap27 tjcsv.Map `yaml:"costItemMap27" codec:"costItemMap27"`
	// costItemMap28
	CostItemMap28 tjcsv.Map `yaml:"costItemMap28" codec:"costItemMap28"`
	// costItemMap29
	CostItemMap29 tjcsv.Map `yaml:"costItemMap29" codec:"costItemMap29"`
	// costItemMap3
	CostItemMap3 tjcsv.Map `yaml:"costItemMap3" codec:"costItemMap3"`
	// costItemMap30
	CostItemMap30 tjcsv.Map `yaml:"costItemMap30" codec:"costItemMap30"`
	// costItemMap31
	CostItemMap31 tjcsv.Map `yaml:"costItemMap31" codec:"costItemMap31"`
	// costItemMap32
	CostItemMap32 tjcsv.Map `yaml:"costItemMap32" codec:"costItemMap32"`
	// costItemMap33
	CostItemMap33 tjcsv.Map `yaml:"costItemMap33" codec:"costItemMap33"`
	// costItemMap34
	CostItemMap34 tjcsv.Map `yaml:"costItemMap34" codec:"costItemMap34"`
	// costItemMap35
	CostItemMap35 tjcsv.Map `yaml:"costItemMap35" codec:"costItemMap35"`
	// costItemMap36
	CostItemMap36 tjcsv.Map `yaml:"costItemMap36" codec:"costItemMap36"`
	// costItemMap37
	CostItemMap37 tjcsv.Map `yaml:"costItemMap37" codec:"costItemMap37"`
	// costItemMap38
	CostItemMap38 tjcsv.Map `yaml:"costItemMap38" codec:"costItemMap38"`
	// costItemMap39
	CostItemMap39 tjcsv.Map `yaml:"costItemMap39" codec:"costItemMap39"`
	// costItemMap4
	CostItemMap4 tjcsv.Map `yaml:"costItemMap4" codec:"costItemMap4"`
	// costItemMap40
	CostItemMap40 tjcsv.Map `yaml:"costItemMap40" codec:"costItemMap40"`
	// costItemMap41
	CostItemMap41 tjcsv.Map `yaml:"costItemMap41" codec:"costItemMap41"`
	// costItemMap42
	CostItemMap42 tjcsv.Map `yaml:"costItemMap42" codec:"costItemMap42"`
	// costItemMap43
	CostItemMap43 tjcsv.Map `yaml:"costItemMap43" codec:"costItemMap43"`
	// costItemMap44
	CostItemMap44 tjcsv.Map `yaml:"costItemMap44" codec:"costItemMap44"`
	// costItemMap45
	CostItemMap45 tjcsv.Map `yaml:"costItemMap45" codec:"costItemMap45"`
	// costItemMap46
	CostItemMap46 tjcsv.Map `yaml:"costItemMap46" codec:"costItemMap46"`
	// costItemMap47
	CostItemMap47 tjcsv.Map `yaml:"costItemMap47" codec:"costItemMap47"`
	// costItemMap48
	CostItemMap48 tjcsv.Map `yaml:"costItemMap48" codec:"costItemMap48"`
	// costItemMap49
	CostItemMap49 tjcsv.Map `yaml:"costItemMap49" codec:"costItemMap49"`
	// costItemMap5
	CostItemMap5 tjcsv.Map `yaml:"costItemMap5" codec:"costItemMap5"`
	// costItemMap50
	CostItemMap50 tjcsv.Map `yaml:"costItemMap50" codec:"costItemMap50"`
	// costItemMap51
	CostItemMap51 tjcsv.Map `yaml:"costItemMap51" codec:"costItemMap51"`
	// costItemMap52
	CostItemMap52 tjcsv.Map `yaml:"costItemMap52" codec:"costItemMap52"`
	// costItemMap6
	CostItemMap6 tjcsv.Map `yaml:"costItemMap6" codec:"costItemMap6"`
	// costItemMap7
	CostItemMap7 tjcsv.Map `yaml:"costItemMap7" codec:"costItemMap7"`
	// costItemMap8
	CostItemMap8 tjcsv.Map `yaml:"costItemMap8" codec:"costItemMap8"`
	// costItemMap9
	CostItemMap9 tjcsv.Map `yaml:"costItemMap9" codec:"costItemMap9"`
}
// base_attribute/equip_strength.csv
type Base_attribute_equip_strength struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// costExp1
	CostExp1 int `yaml:"costExp1" codec:"costExp1"`
	// costExp10
	CostExp10 int `yaml:"costExp10" codec:"costExp10"`
	// costExp11
	CostExp11 int `yaml:"costExp11" codec:"costExp11"`
	// costExp12
	CostExp12 int `yaml:"costExp12" codec:"costExp12"`
	// costExp13
	CostExp13 int `yaml:"costExp13" codec:"costExp13"`
	// costExp2
	CostExp2 int `yaml:"costExp2" codec:"costExp2"`
	// costExp3
	CostExp3 int `yaml:"costExp3" codec:"costExp3"`
	// costExp4
	CostExp4 int `yaml:"costExp4" codec:"costExp4"`
	// costExp5
	CostExp5 int `yaml:"costExp5" codec:"costExp5"`
	// costExp6
	CostExp6 int `yaml:"costExp6" codec:"costExp6"`
	// costExp7
	CostExp7 int `yaml:"costExp7" codec:"costExp7"`
	// costExp8
	CostExp8 int `yaml:"costExp8" codec:"costExp8"`
	// costExp9
	CostExp9 int `yaml:"costExp9" codec:"costExp9"`
	// costGold1
	CostGold1 int `yaml:"costGold1" codec:"costGold1"`
	// costGold10
	CostGold10 int `yaml:"costGold10" codec:"costGold10"`
	// costGold11
	CostGold11 int `yaml:"costGold11" codec:"costGold11"`
	// costGold12
	CostGold12 int `yaml:"costGold12" codec:"costGold12"`
	// costGold13
	CostGold13 int `yaml:"costGold13" codec:"costGold13"`
	// costGold2
	CostGold2 int `yaml:"costGold2" codec:"costGold2"`
	// costGold3
	CostGold3 int `yaml:"costGold3" codec:"costGold3"`
	// costGold4
	CostGold4 int `yaml:"costGold4" codec:"costGold4"`
	// costGold5
	CostGold5 int `yaml:"costGold5" codec:"costGold5"`
	// costGold6
	CostGold6 int `yaml:"costGold6" codec:"costGold6"`
	// costGold7
	CostGold7 int `yaml:"costGold7" codec:"costGold7"`
	// costGold8
	CostGold8 int `yaml:"costGold8" codec:"costGold8"`
	// costGold9
	CostGold9 int `yaml:"costGold9" codec:"costGold9"`
	// costItemMap1
	CostItemMap1 tjcsv.Map `yaml:"costItemMap1" codec:"costItemMap1"`
	// costItemMap10
	CostItemMap10 tjcsv.Map `yaml:"costItemMap10" codec:"costItemMap10"`
	// costItemMap11
	CostItemMap11 tjcsv.Map `yaml:"costItemMap11" codec:"costItemMap11"`
	// costItemMap12
	CostItemMap12 tjcsv.Map `yaml:"costItemMap12" codec:"costItemMap12"`
	// costItemMap13
	CostItemMap13 tjcsv.Map `yaml:"costItemMap13" codec:"costItemMap13"`
	// costItemMap2
	CostItemMap2 tjcsv.Map `yaml:"costItemMap2" codec:"costItemMap2"`
	// costItemMap3
	CostItemMap3 tjcsv.Map `yaml:"costItemMap3" codec:"costItemMap3"`
	// costItemMap4
	CostItemMap4 tjcsv.Map `yaml:"costItemMap4" codec:"costItemMap4"`
	// costItemMap5
	CostItemMap5 tjcsv.Map `yaml:"costItemMap5" codec:"costItemMap5"`
	// costItemMap6
	CostItemMap6 tjcsv.Map `yaml:"costItemMap6" codec:"costItemMap6"`
	// costItemMap7
	CostItemMap7 tjcsv.Map `yaml:"costItemMap7" codec:"costItemMap7"`
	// costItemMap8
	CostItemMap8 tjcsv.Map `yaml:"costItemMap8" codec:"costItemMap8"`
	// costItemMap9
	CostItemMap9 tjcsv.Map `yaml:"costItemMap9" codec:"costItemMap9"`
}
// base_attribute/fight_soul_level.csv
type Base_attribute_fight_soul_level struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// levelExp1
	LevelExp1 int `yaml:"levelExp1" codec:"levelExp1"`
	// levelExp10
	LevelExp10 int `yaml:"levelExp10" codec:"levelExp10"`
	// levelExp11
	LevelExp11 int `yaml:"levelExp11" codec:"levelExp11"`
	// levelExp12
	LevelExp12 int `yaml:"levelExp12" codec:"levelExp12"`
	// levelExp2
	LevelExp2 int `yaml:"levelExp2" codec:"levelExp2"`
	// levelExp3
	LevelExp3 int `yaml:"levelExp3" codec:"levelExp3"`
	// levelExp4
	LevelExp4 int `yaml:"levelExp4" codec:"levelExp4"`
	// levelExp5
	LevelExp5 int `yaml:"levelExp5" codec:"levelExp5"`
	// levelExp6
	LevelExp6 int `yaml:"levelExp6" codec:"levelExp6"`
	// levelExp7
	LevelExp7 int `yaml:"levelExp7" codec:"levelExp7"`
	// levelExp8
	LevelExp8 int `yaml:"levelExp8" codec:"levelExp8"`
	// levelExp9
	LevelExp9 int `yaml:"levelExp9" codec:"levelExp9"`
}
// base_attribute/hero_level.csv
type Base_attribute_hero_level struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// common
	Common int `yaml:"common" codec:"common"`
	// default
	Default int `yaml:"default" codec:"default"`
	// elites
	Elites int `yaml:"elites" codec:"elites"`
}
// base_attribute/monster
type Base_attribute_monster struct {
	// base_attribute/monster/base_attribute.csv
	Base_attribute map[int]*Base_attribute_monster_base_attribute `yaml:"base_attribute" codec:"base_attribute"`
}
// base_attribute/monster/base_attribute.csv
type Base_attribute_monster_base_attribute struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// block
	Block int `yaml:"block" codec:"block"`
	// blockPower
	BlockPower int `yaml:"blockPower" codec:"blockPower"`
	// breakBlock
	BreakBlock int `yaml:"breakBlock" codec:"breakBlock"`
	// controlPer
	ControlPer int `yaml:"controlPer" codec:"controlPer"`
	// cure
	Cure int `yaml:"cure" codec:"cure"`
	// damage
	Damage int `yaml:"damage" codec:"damage"`
	// damageAdd
	DamageAdd int `yaml:"damageAdd" codec:"damageAdd"`
	// damageDeepen
	DamageDeepen int `yaml:"damageDeepen" codec:"damageDeepen"`
	// damageDodge
	DamageDodge int `yaml:"damageDodge" codec:"damageDodge"`
	// damageHit
	DamageHit int `yaml:"damageHit" codec:"damageHit"`
	// damageReduce
	DamageReduce int `yaml:"damageReduce" codec:"damageReduce"`
	// damageSub
	DamageSub int `yaml:"damageSub" codec:"damageSub"`
	// defence
	Defence int `yaml:"defence" codec:"defence"`
	// defenceIgnore
	DefenceIgnore int `yaml:"defenceIgnore" codec:"defenceIgnore"`
	// dodge
	Dodge int `yaml:"dodge" codec:"dodge"`
	// hit
	Hit int `yaml:"hit" codec:"hit"`
	// hp
	Hp int `yaml:"hp" codec:"hp"`
	// hpRecover
	HpRecover int `yaml:"hpRecover" codec:"hpRecover"`
	// immuneControl
	ImmuneControl int `yaml:"immuneControl" codec:"immuneControl"`
	// initMp1
	InitMp1 int `yaml:"initMp1" codec:"initMp1"`
	// mp1
	Mp1 int `yaml:"mp1" codec:"mp1"`
	// mp1Recover
	Mp1Recover int `yaml:"mp1Recover" codec:"mp1Recover"`
	// mp2Recover
	Mp2Recover int `yaml:"mp2Recover" codec:"mp2Recover"`
	// natureRestraint
	NatureRestraint int `yaml:"natureRestraint" codec:"natureRestraint"`
	// rebound
	Rebound int `yaml:"rebound" codec:"rebound"`
	// specialDamage
	SpecialDamage int `yaml:"specialDamage" codec:"specialDamage"`
	// specialDefence
	SpecialDefence int `yaml:"specialDefence" codec:"specialDefence"`
	// specialDefenceIgnore
	SpecialDefenceIgnore int `yaml:"specialDefenceIgnore" codec:"specialDefenceIgnore"`
	// speed
	Speed int `yaml:"speed" codec:"speed"`
	// strike
	Strike int `yaml:"strike" codec:"strike"`
	// strikeDamage
	StrikeDamage int `yaml:"strikeDamage" codec:"strikeDamage"`
	// strikeResistance
	StrikeResistance int `yaml:"strikeResistance" codec:"strikeResistance"`
	// suckBlood
	SuckBlood int `yaml:"suckBlood" codec:"suckBlood"`
	// ultimateAdd
	UltimateAdd int `yaml:"ultimateAdd" codec:"ultimateAdd"`
	// ultimateSub
	UltimateSub int `yaml:"ultimateSub" codec:"ultimateSub"`
}
// base_attribute/monster_gym
type Base_attribute_monster_gym struct {
	// base_attribute/monster_gym/base_attribute.csv
	Base_attribute map[int]*Base_attribute_monster_gym_base_attribute `yaml:"base_attribute" codec:"base_attribute"`
}
// base_attribute/monster_gym/base_attribute.csv
type Base_attribute_monster_gym_base_attribute struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// block
	Block int `yaml:"block" codec:"block"`
	// blockPower
	BlockPower int `yaml:"blockPower" codec:"blockPower"`
	// breakBlock
	BreakBlock int `yaml:"breakBlock" codec:"breakBlock"`
	// controlPer
	ControlPer int `yaml:"controlPer" codec:"controlPer"`
	// cure
	Cure int `yaml:"cure" codec:"cure"`
	// damage
	Damage int `yaml:"damage" codec:"damage"`
	// damageAdd
	DamageAdd int `yaml:"damageAdd" codec:"damageAdd"`
	// damageDeepen
	DamageDeepen int `yaml:"damageDeepen" codec:"damageDeepen"`
	// damageDodge
	DamageDodge int `yaml:"damageDodge" codec:"damageDodge"`
	// damageHit
	DamageHit int `yaml:"damageHit" codec:"damageHit"`
	// damageReduce
	DamageReduce int `yaml:"damageReduce" codec:"damageReduce"`
	// damageSub
	DamageSub int `yaml:"damageSub" codec:"damageSub"`
	// defence
	Defence int `yaml:"defence" codec:"defence"`
	// defenceIgnore
	DefenceIgnore int `yaml:"defenceIgnore" codec:"defenceIgnore"`
	// dodge
	Dodge int `yaml:"dodge" codec:"dodge"`
	// hit
	Hit int `yaml:"hit" codec:"hit"`
	// hp
	Hp int `yaml:"hp" codec:"hp"`
	// hpRecover
	HpRecover int `yaml:"hpRecover" codec:"hpRecover"`
	// immuneControl
	ImmuneControl int `yaml:"immuneControl" codec:"immuneControl"`
	// initMp1
	InitMp1 int `yaml:"initMp1" codec:"initMp1"`
	// mp1
	Mp1 int `yaml:"mp1" codec:"mp1"`
	// mp1Recover
	Mp1Recover int `yaml:"mp1Recover" codec:"mp1Recover"`
	// mp2Recover
	Mp2Recover int `yaml:"mp2Recover" codec:"mp2Recover"`
	// natureRestraint
	NatureRestraint int `yaml:"natureRestraint" codec:"natureRestraint"`
	// rebound
	Rebound int `yaml:"rebound" codec:"rebound"`
	// specialDamage
	SpecialDamage int `yaml:"specialDamage" codec:"specialDamage"`
	// specialDefence
	SpecialDefence int `yaml:"specialDefence" codec:"specialDefence"`
	// specialDefenceIgnore
	SpecialDefenceIgnore int `yaml:"specialDefenceIgnore" codec:"specialDefenceIgnore"`
	// speed
	Speed int `yaml:"speed" codec:"speed"`
	// strike
	Strike int `yaml:"strike" codec:"strike"`
	// strikeDamage
	StrikeDamage int `yaml:"strikeDamage" codec:"strikeDamage"`
	// strikeResistance
	StrikeResistance int `yaml:"strikeResistance" codec:"strikeResistance"`
	// suckBlood
	SuckBlood int `yaml:"suckBlood" codec:"suckBlood"`
	// ultimateAdd
	UltimateAdd int `yaml:"ultimateAdd" codec:"ultimateAdd"`
	// ultimateSub
	UltimateSub int `yaml:"ultimateSub" codec:"ultimateSub"`
}
// base_attribute/nature_matrix.csv
type Base_attribute_nature_matrix struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// combat
	Combat float64 `yaml:"combat" codec:"combat"`
	// dragon
	Dragon float64 `yaml:"dragon" codec:"dragon"`
	// electricity
	Electricity float64 `yaml:"electricity" codec:"electricity"`
	// evil
	Evil float64 `yaml:"evil" codec:"evil"`
	// fairy
	Fairy float64 `yaml:"fairy" codec:"fairy"`
	// fire
	Fire float64 `yaml:"fire" codec:"fire"`
	// fly
	Fly float64 `yaml:"fly" codec:"fly"`
	// ghost
	Ghost float64 `yaml:"ghost" codec:"ghost"`
	// grass
	Grass float64 `yaml:"grass" codec:"grass"`
	// ground
	Ground float64 `yaml:"ground" codec:"ground"`
	// ice
	Ice float64 `yaml:"ice" codec:"ice"`
	// normal
	Normal float64 `yaml:"normal" codec:"normal"`
	// poison
	Poison float64 `yaml:"poison" codec:"poison"`
	// rock
	Rock float64 `yaml:"rock" codec:"rock"`
	// steel
	Steel float64 `yaml:"steel" codec:"steel"`
	// super
	Super float64 `yaml:"super" codec:"super"`
	// water
	Water float64 `yaml:"water" codec:"water"`
	// worm
	Worm float64 `yaml:"worm" codec:"worm"`
}
// base_attribute/role_level.csv
type Base_attribute_role_level struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// benchUnlock
	BenchUnlock int `yaml:"benchUnlock" codec:"benchUnlock"`
	// cardLevelMax
	CardLevelMax int `yaml:"cardLevelMax" codec:"cardLevelMax"`
	// equipAdvanceMax
	EquipAdvanceMax int `yaml:"equipAdvanceMax" codec:"equipAdvanceMax"`
	// explorePointMax
	ExplorePointMax int `yaml:"explorePointMax" codec:"explorePointMax"`
	// featureUnlock
	FeatureUnlock interface{} `yaml:"featureUnlock" codec:"featureUnlock"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// levelExp
	LevelExp int `yaml:"levelExp" codec:"levelExp"`
	// lianJinGold
	LianJinGold int `yaml:"lianJinGold" codec:"lianJinGold"`
	// rmbGoldGive
	RmbGoldGive int `yaml:"rmbGoldGive" codec:"rmbGoldGive"`
	// runeUnlock
	RuneUnlock int `yaml:"runeUnlock" codec:"runeUnlock"`
	// skillPointMax
	SkillPointMax int `yaml:"skillPointMax" codec:"skillPointMax"`
	// staminaGive
	StaminaGive int `yaml:"staminaGive" codec:"staminaGive"`
	// staminaMax
	StaminaMax int `yaml:"staminaMax" codec:"staminaMax"`
	// unionTrainingFix
	UnionTrainingFix int `yaml:"unionTrainingFix" codec:"unionTrainingFix"`
}
// base_attribute/scene_attr_correct.csv
type Base_attribute_scene_attr_correct struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// activeSkillMp1
	ActiveSkillMp1 int `yaml:"activeSkillMp1" codec:"activeSkillMp1"`
	// addMp1
	AddMp1 int `yaml:"addMp1" codec:"addMp1"`
	// addMp2
	AddMp2 int `yaml:"addMp2" codec:"addMp2"`
	// blockLevelC
	BlockLevelC int `yaml:"blockLevelC" codec:"blockLevelC"`
	// blockPowerC
	BlockPowerC int `yaml:"blockPowerC" codec:"blockPowerC"`
	// breakBlockLevelC
	BreakBlockLevelC int `yaml:"breakBlockLevelC" codec:"breakBlockLevelC"`
	// buffGroup
	BuffGroup tjcsv.Slice `yaml:"buffGroup" codec:"buffGroup"`
	// curePowerC
	CurePowerC int `yaml:"curePowerC" codec:"curePowerC"`
	// damageAddC
	DamageAddC int `yaml:"damageAddC" codec:"damageAddC"`
	// damageC
	DamageC float64 `yaml:"damageC" codec:"damageC"`
	// damageDeepenC
	DamageDeepenC int `yaml:"damageDeepenC" codec:"damageDeepenC"`
	// damageReduceC
	DamageReduceC int `yaml:"damageReduceC" codec:"damageReduceC"`
	// damageSubC
	DamageSubC int `yaml:"damageSubC" codec:"damageSubC"`
	// defenceC
	DefenceC float64 `yaml:"defenceC" codec:"defenceC"`
	// defenceIgnoreC
	DefenceIgnoreC int `yaml:"defenceIgnoreC" codec:"defenceIgnoreC"`
	// dodgeC
	DodgeC int `yaml:"dodgeC" codec:"dodgeC"`
	// hitC
	HitC int `yaml:"hitC" codec:"hitC"`
	// hpC
	HpC float64 `yaml:"hpC" codec:"hpC"`
	// hpRecoverC
	HpRecoverC float64 `yaml:"hpRecoverC" codec:"hpRecoverC"`
	// initMp1C
	InitMp1C int `yaml:"initMp1C" codec:"initMp1C"`
	// lostBloodMp1
	LostBloodMp1 float64 `yaml:"lostBloodMp1" codec:"lostBloodMp1"`
	// mainSkillAddC
	MainSkillAddC int `yaml:"mainSkillAddC" codec:"mainSkillAddC"`
	// mainSkillSubC
	MainSkillSubC int `yaml:"mainSkillSubC" codec:"mainSkillSubC"`
	// mp1C
	Mp1C int `yaml:"mp1C" codec:"mp1C"`
	// mp1RecoverC
	Mp1RecoverC int `yaml:"mp1RecoverC" codec:"mp1RecoverC"`
	// mp2RecoverC
	Mp2RecoverC int `yaml:"mp2RecoverC" codec:"mp2RecoverC"`
	// natureRestraintC
	NatureRestraintC int `yaml:"natureRestraintC" codec:"natureRestraintC"`
	// reboundC
	ReboundC int `yaml:"reboundC" codec:"reboundC"`
	// sceneID
	SceneID int `yaml:"sceneID" codec:"sceneID"`
	// slayAddMp1Fix
	SlayAddMp1Fix tjcsv.Slice `yaml:"slayAddMp1Fix" codec:"slayAddMp1Fix"`
	// specialDamageC
	SpecialDamageC float64 `yaml:"specialDamageC" codec:"specialDamageC"`
	// specialDefence
	SpecialDefence float64 `yaml:"specialDefence" codec:"specialDefence"`
	// specialDefenceIgnore
	SpecialDefenceIgnore int `yaml:"specialDefenceIgnore" codec:"specialDefenceIgnore"`
	// speedC
	SpeedC int `yaml:"speedC" codec:"speedC"`
	// strikeDamageC
	StrikeDamageC int `yaml:"strikeDamageC" codec:"strikeDamageC"`
	// strikeLevelC
	StrikeLevelC int `yaml:"strikeLevelC" codec:"strikeLevelC"`
	// strikeResistanceC
	StrikeResistanceC int `yaml:"strikeResistanceC" codec:"strikeResistanceC"`
	// suckBloodC
	SuckBloodC int `yaml:"suckBloodC" codec:"suckBloodC"`
}
// base_attribute/skill_level.csv
type Base_attribute_skill_level struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// fragNum1
	FragNum1 int `yaml:"fragNum1" codec:"fragNum1"`
	// fragNum2
	FragNum2 int `yaml:"fragNum2" codec:"fragNum2"`
	// fragNum3
	FragNum3 int `yaml:"fragNum3" codec:"fragNum3"`
	// gold1
	Gold1 int `yaml:"gold1" codec:"gold1"`
	// gold2
	Gold2 int `yaml:"gold2" codec:"gold2"`
	// gold3
	Gold3 int `yaml:"gold3" codec:"gold3"`
	// gold4
	Gold4 int `yaml:"gold4" codec:"gold4"`
	// gold5
	Gold5 int `yaml:"gold5" codec:"gold5"`
	// gold6
	Gold6 int `yaml:"gold6" codec:"gold6"`
	// gold7
	Gold7 int `yaml:"gold7" codec:"gold7"`
	// itemMap1
	ItemMap1 tjcsv.Map `yaml:"itemMap1" codec:"itemMap1"`
	// itemMap2
	ItemMap2 tjcsv.Map `yaml:"itemMap2" codec:"itemMap2"`
	// itemMap3
	ItemMap3 tjcsv.Map `yaml:"itemMap3" codec:"itemMap3"`
	// itemMap4
	ItemMap4 tjcsv.Map `yaml:"itemMap4" codec:"itemMap4"`
	// itemMap5
	ItemMap5 tjcsv.Map `yaml:"itemMap5" codec:"itemMap5"`
	// itemMap6
	ItemMap6 tjcsv.Map `yaml:"itemMap6" codec:"itemMap6"`
	// itemMap7
	ItemMap7 tjcsv.Map `yaml:"itemMap7" codec:"itemMap7"`
	// itemNum1
	ItemNum1 int `yaml:"itemNum1" codec:"itemNum1"`
	// itemNum2
	ItemNum2 int `yaml:"itemNum2" codec:"itemNum2"`
	// itemNum3
	ItemNum3 int `yaml:"itemNum3" codec:"itemNum3"`
	// itemNum4
	ItemNum4 int `yaml:"itemNum4" codec:"itemNum4"`
	// itemNum5
	ItemNum5 int `yaml:"itemNum5" codec:"itemNum5"`
	// needLevel
	NeedLevel int `yaml:"needLevel" codec:"needLevel"`
}
// battle_card_halo.csv
type Battle_card_halo struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// args
	Args tjcsv.Slice `yaml:"args" codec:"args"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// attrType3
	AttrType3 int `yaml:"attrType3" codec:"attrType3"`
	// attrValue1
	AttrValue1 string `yaml:"attrValue1" codec:"attrValue1"`
	// attrValue2
	AttrValue2 string `yaml:"attrValue2" codec:"attrValue2"`
	// attrValue3
	AttrValue3 string `yaml:"attrValue3" codec:"attrValue3"`
	// autoPriority
	AutoPriority int `yaml:"autoPriority" codec:"autoPriority"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// group
	Group int `yaml:"group" codec:"group"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// invalidScenes
	InvalidScenes tjcsv.Slice `yaml:"invalidScenes" codec:"invalidScenes"`
	// priority
	Priority int `yaml:"priority" codec:"priority"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// bossaward.csv
type Bossaward struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// range
	Range tjcsv.Slice `yaml:"range" codec:"range"`
}
// brave_challenge
type Brave_challenge struct {
	// brave_challenge/achievement.csv
	Achievement map[int]*Brave_challenge_achievement `yaml:"achievement" codec:"achievement"`
	// brave_challenge/badge.csv
	Badge map[int]*Brave_challenge_badge `yaml:"badge" codec:"badge"`
	// brave_challenge/badge_gen.csv
	Badge_gen map[int]*Brave_challenge_badge_gen `yaml:"badge_gen" codec:"badge_gen"`
	// brave_challenge/base.csv
	Base map[int]*Brave_challenge_base `yaml:"base" codec:"base"`
	// brave_challenge/cards.csv
	Cards map[int]*Brave_challenge_cards `yaml:"cards" codec:"cards"`
	// brave_challenge/floor.csv
	Floor map[int]*Brave_challenge_floor `yaml:"floor" codec:"floor"`
	// brave_challenge/monster.csv
	Monster map[int]*Brave_challenge_monster `yaml:"monster" codec:"monster"`
	// brave_challenge/open.csv
	Open map[int]*Brave_challenge_open `yaml:"open" codec:"open"`
	// brave_challenge/team.csv
	Team map[int]*Brave_challenge_team `yaml:"team" codec:"team"`
}
// brave_challenge/achievement.csv
type Brave_challenge_achievement struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// groupID
	GroupID int `yaml:"groupID" codec:"groupID"`
	// isShow
	IsShow bool `yaml:"isShow" codec:"isShow"`
	// sort
	Sort int `yaml:"sort" codec:"sort"`
	// targetArg1
	TargetArg1 int `yaml:"targetArg1" codec:"targetArg1"`
	// targetArg2
	TargetArg2 int `yaml:"targetArg2" codec:"targetArg2"`
	// targetType
	TargetType int `yaml:"targetType" codec:"targetType"`
	// targetType2
	TargetType2 int `yaml:"targetType2" codec:"targetType2"`
	// type
	Type int `yaml:"type" codec:"type"`
	// unlock
	Unlock tjcsv.Map `yaml:"unlock" codec:"unlock"`
}
// brave_challenge/badge.csv
type Brave_challenge_badge struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// activeType
	ActiveType int `yaml:"activeType" codec:"activeType"`
	// addAttrs
	AddAttrs tjcsv.Map `yaml:"addAttrs" codec:"addAttrs"`
	// addType
	AddType int `yaml:"addType" codec:"addType"`
	// cardIDs
	CardIDs tjcsv.Slice `yaml:"cardIDs" codec:"cardIDs"`
	// desc
	Desc interface{} `yaml:"desc" codec:"desc"`
	// groupID
	GroupID int `yaml:"groupID" codec:"groupID"`
	// iconResPath
	IconResPath interface{} `yaml:"iconResPath" codec:"iconResPath"`
	// name
	Name interface{} `yaml:"name" codec:"name"`
	// rarity
	Rarity int `yaml:"rarity" codec:"rarity"`
	// skillIDs
	SkillIDs tjcsv.Slice `yaml:"skillIDs" codec:"skillIDs"`
	// timesLimit
	TimesLimit int `yaml:"timesLimit" codec:"timesLimit"`
	// type
	Type int `yaml:"type" codec:"type"`
	// unlockCount
	UnlockCount int `yaml:"unlockCount" codec:"unlockCount"`
	// unlockTarget
	UnlockTarget int `yaml:"unlockTarget" codec:"unlockTarget"`
	// unlockType
	UnlockType int `yaml:"unlockType" codec:"unlockType"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
}
// brave_challenge/badge_gen.csv
type Brave_challenge_badge_gen struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// firstRandomLibs
	FirstRandomLibs tjcsv.Map `yaml:"firstRandomLibs" codec:"firstRandomLibs"`
	// floor
	Floor int `yaml:"floor" codec:"floor"`
	// groupID
	GroupID int `yaml:"groupID" codec:"groupID"`
	// position
	Position int `yaml:"position" codec:"position"`
	// repeatRandomLibs1
	RepeatRandomLibs1 tjcsv.Map `yaml:"repeatRandomLibs1" codec:"repeatRandomLibs1"`
	// repeatRandomLibs2
	RepeatRandomLibs2 tjcsv.Map `yaml:"repeatRandomLibs2" codec:"repeatRandomLibs2"`
	// weight1
	Weight1 int `yaml:"weight1" codec:"weight1"`
	// weight2
	Weight2 int `yaml:"weight2" codec:"weight2"`
}
// brave_challenge/base.csv
type Brave_challenge_base struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// achiSeqID
	AchiSeqID int `yaml:"achiSeqID" codec:"achiSeqID"`
	// achievementID
	AchievementID int `yaml:"achievementID" codec:"achievementID"`
	// addTimes
	AddTimes int `yaml:"addTimes" codec:"addTimes"`
	// background
	Background string `yaml:"background" codec:"background"`
	// badgeCards
	BadgeCards tjcsv.Slice `yaml:"badgeCards" codec:"badgeCards"`
	// badgeLibID
	BadgeLibID int `yaml:"badgeLibID" codec:"badgeLibID"`
	// buyCost
	BuyCost tjcsv.Slice `yaml:"buyCost" codec:"buyCost"`
	// buyTimes
	BuyTimes int `yaml:"buyTimes" codec:"buyTimes"`
	// cards
	Cards tjcsv.Slice `yaml:"cards" codec:"cards"`
	// dailyWeightUp
	DailyWeightUp tjcsv.Slice `yaml:"dailyWeightUp" codec:"dailyWeightUp"`
	// floorFail
	FloorFail tjcsv.Map `yaml:"floorFail" codec:"floorFail"`
	// gateSeq
	GateSeq tjcsv.Slice `yaml:"gateSeq" codec:"gateSeq"`
	// genSeqID
	GenSeqID int `yaml:"genSeqID" codec:"genSeqID"`
	// goldLimit
	GoldLimit int `yaml:"goldLimit" codec:"goldLimit"`
	// isDailyBadge
	IsDailyBadge bool `yaml:"isDailyBadge" codec:"isDailyBadge"`
	// isDailyRecover
	IsDailyRecover bool `yaml:"isDailyRecover" codec:"isDailyRecover"`
	// isDailyUnlockCard
	IsDailyUnlockCard bool `yaml:"isDailyUnlockCard" codec:"isDailyUnlockCard"`
	// isShowAward
	IsShowAward bool `yaml:"isShowAward" codec:"isShowAward"`
	// isStarAttrAdd
	IsStarAttrAdd bool `yaml:"isStarAttrAdd" codec:"isStarAttrAdd"`
	// lastAnimation
	LastAnimation string `yaml:"lastAnimation" codec:"lastAnimation"`
	// monsterCards
	MonsterCards tjcsv.Slice `yaml:"monsterCards" codec:"monsterCards"`
	// mp
	Mp float64 `yaml:"mp" codec:"mp"`
	// sameTimes
	SameTimes int `yaml:"sameTimes" codec:"sameTimes"`
	// timesLimit
	TimesLimit int `yaml:"timesLimit" codec:"timesLimit"`
	// title
	Title string `yaml:"title" codec:"title"`
	// weightUp
	WeightUp int `yaml:"weightUp" codec:"weightUp"`
}
// brave_challenge/cards.csv
type Brave_challenge_cards struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// abilities
	Abilities tjcsv.Map `yaml:"abilities" codec:"abilities"`
	// addAttributes
	AddAttributes tjcsv.Slice `yaml:"addAttributes" codec:"addAttributes"`
	// advance
	Advance int `yaml:"advance" codec:"advance"`
	// blockLevel
	BlockLevel interface{} `yaml:"blockLevel" codec:"blockLevel"`
	// blockPower
	BlockPower interface{} `yaml:"blockPower" codec:"blockPower"`
	// breakBlockLevel
	BreakBlockLevel interface{} `yaml:"breakBlockLevel" codec:"breakBlockLevel"`
	// cardID
	CardID int `yaml:"cardID" codec:"cardID"`
	// controlPer
	ControlPer interface{} `yaml:"controlPer" codec:"controlPer"`
	// damage
	Damage float64 `yaml:"damage" codec:"damage"`
	// damageAdd
	DamageAdd int `yaml:"damageAdd" codec:"damageAdd"`
	// damageSub
	DamageSub int `yaml:"damageSub" codec:"damageSub"`
	// defence
	Defence float64 `yaml:"defence" codec:"defence"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// equipAdvance
	EquipAdvance int `yaml:"equipAdvance" codec:"equipAdvance"`
	// equipAwake
	EquipAwake int `yaml:"equipAwake" codec:"equipAwake"`
	// equipLevel
	EquipLevel int `yaml:"equipLevel" codec:"equipLevel"`
	// equipStar
	EquipStar int `yaml:"equipStar" codec:"equipStar"`
	// fetters
	Fetters bool `yaml:"fetters" codec:"fetters"`
	// groupID
	GroupID int `yaml:"groupID" codec:"groupID"`
	// hp
	Hp float64 `yaml:"hp" codec:"hp"`
	// immuneControl
	ImmuneControl interface{} `yaml:"immuneControl" codec:"immuneControl"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// level
	Level int `yaml:"level" codec:"level"`
	// lock
	Lock int `yaml:"lock" codec:"lock"`
	// mainSkillAdd
	MainSkillAdd int `yaml:"mainSkillAdd" codec:"mainSkillAdd"`
	// mainSkillSub
	MainSkillSub int `yaml:"mainSkillSub" codec:"mainSkillSub"`
	// nvalue
	Nvalue tjcsv.Map `yaml:"nvalue" codec:"nvalue"`
	// rarity
	Rarity int `yaml:"rarity" codec:"rarity"`
	// rebound
	Rebound interface{} `yaml:"rebound" codec:"rebound"`
	// skillLevels
	SkillLevels tjcsv.Slice `yaml:"skillLevels" codec:"skillLevels"`
	// specialDamage
	SpecialDamage float64 `yaml:"specialDamage" codec:"specialDamage"`
	// specialDefence
	SpecialDefence float64 `yaml:"specialDefence" codec:"specialDefence"`
	// speed
	Speed float64 `yaml:"speed" codec:"speed"`
	// star
	Star int `yaml:"star" codec:"star"`
	// starUnlock
	StarUnlock tjcsv.Slice `yaml:"starUnlock" codec:"starUnlock"`
	// strikeDamage
	StrikeDamage interface{} `yaml:"strikeDamage" codec:"strikeDamage"`
	// strikeLevel
	StrikeLevel interface{} `yaml:"strikeLevel" codec:"strikeLevel"`
	// strikeResistance
	StrikeResistance interface{} `yaml:"strikeResistance" codec:"strikeResistance"`
	// suckBlood
	SuckBlood interface{} `yaml:"suckBlood" codec:"suckBlood"`
	// unlockTarget
	UnlockTarget int `yaml:"unlockTarget" codec:"unlockTarget"`
	// unlockType
	UnlockType int `yaml:"unlockType" codec:"unlockType"`
	// unlockdesc1
	Unlockdesc1 interface{} `yaml:"unlockdesc1" codec:"unlockdesc1"`
	// unlockdesc2
	Unlockdesc2 interface{} `yaml:"unlockdesc2" codec:"unlockdesc2"`
	// zawake
	Zawake tjcsv.Slice `yaml:"zawake" codec:"zawake"`
}
// brave_challenge/floor.csv
type Brave_challenge_floor struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// damageFix
	DamageFix float64 `yaml:"damageFix" codec:"damageFix"`
	// damageMax
	DamageMax int `yaml:"damageMax" codec:"damageMax"`
	// defenceFix
	DefenceFix float64 `yaml:"defenceFix" codec:"defenceFix"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// extraAward
	ExtraAward tjcsv.Map `yaml:"extraAward" codec:"extraAward"`
	// firstAward
	FirstAward tjcsv.Map `yaml:"firstAward" codec:"firstAward"`
	// firstMonters
	FirstMonters tjcsv.Slice `yaml:"firstMonters" codec:"firstMonters"`
	// floor
	Floor int `yaml:"floor" codec:"floor"`
	// hpFix
	HpFix float64 `yaml:"hpFix" codec:"hpFix"`
	// monsterDesc
	MonsterDesc interface{} `yaml:"monsterDesc" codec:"monsterDesc"`
	// name
	Name string `yaml:"name" codec:"name"`
	// repeatAward
	RepeatAward tjcsv.Map `yaml:"repeatAward" codec:"repeatAward"`
	// repeatMonters
	RepeatMonters tjcsv.Slice `yaml:"repeatMonters" codec:"repeatMonters"`
	// scene
	Scene string `yaml:"scene" codec:"scene"`
	// singleDamageMax
	SingleDamageMax int `yaml:"singleDamageMax" codec:"singleDamageMax"`
	// speedFix
	SpeedFix float64 `yaml:"speedFix" codec:"speedFix"`
}
// brave_challenge/monster.csv
type Brave_challenge_monster struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// badges
	Badges tjcsv.Slice `yaml:"badges" codec:"badges"`
	// boss
	Boss tjcsv.Slice `yaml:"boss" codec:"boss"`
	// cards
	Cards tjcsv.Slice `yaml:"cards" codec:"cards"`
	// desc
	Desc interface{} `yaml:"desc" codec:"desc"`
	// groupID
	GroupID int `yaml:"groupID" codec:"groupID"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
}
// brave_challenge/open.csv
type Brave_challenge_open struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// startTime
	StartTime int `yaml:"startTime" codec:"startTime"`
}
// brave_challenge/team.csv
type Brave_challenge_team struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// csvID
	CsvID int `yaml:"csvID" codec:"csvID"`
	// level
	Level int `yaml:"level" codec:"level"`
	// system
	System string `yaml:"system" codec:"system"`
}
// buff_effect.csv
type Buff_effect struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// easyEffectFunc
	EasyEffectFunc string `yaml:"easyEffectFunc" codec:"easyEffectFunc"`
	// overlayLimit
	OverlayLimit int `yaml:"overlayLimit" codec:"overlayLimit"`
	// overlayType
	OverlayType int `yaml:"overlayType" codec:"overlayType"`
}
// buff_group_power.csv
type Buff_group_power struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beChange
	BeChange int `yaml:"beChange" codec:"beChange"`
	// beCopy
	BeCopy int `yaml:"beCopy" codec:"beCopy"`
	// beDispel
	BeDispel int `yaml:"beDispel" codec:"beDispel"`
	// beImmune
	BeImmune int `yaml:"beImmune" codec:"beImmune"`
	// beTransfer
	BeTransfer int `yaml:"beTransfer" codec:"beTransfer"`
}
// buff_level_correct.csv
type Buff_level_correct struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// propCorrect
	PropCorrect float64 `yaml:"propCorrect" codec:"propCorrect"`
}
// capture
type Capture struct {
	// capture/base.csv
	Base map[int]*Capture_base `yaml:"base" codec:"base"`
	// capture/level.csv
	Level map[int]*Capture_level `yaml:"level" codec:"level"`
	// capture/probability.csv
	Probability map[int]*Capture_probability `yaml:"probability" codec:"probability"`
	// capture/random.csv
	Random map[int]*Capture_random `yaml:"random" codec:"random"`
	// capture/sprite.csv
	Sprite map[int]*Capture_sprite `yaml:"sprite" codec:"sprite"`
}
// capture/base.csv
type Capture_base struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// dailyMax
	DailyMax int `yaml:"dailyMax" codec:"dailyMax"`
	// onceMax
	OnceMax int `yaml:"onceMax" codec:"onceMax"`
	// weightMax
	WeightMax float64 `yaml:"weightMax" codec:"weightMax"`
	// weightMin
	WeightMin float64 `yaml:"weightMin" codec:"weightMin"`
}
// capture/level.csv
type Capture_level struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// name
	Name string `yaml:"name" codec:"name"`
	// needExp
	NeedExp int `yaml:"needExp" codec:"needExp"`
	// rateUp
	RateUp float64 `yaml:"rateUp" codec:"rateUp"`
	// weight1
	Weight1 int `yaml:"weight1" codec:"weight1"`
	// weight2
	Weight2 float64 `yaml:"weight2" codec:"weight2"`
	// weight3
	Weight3 float64 `yaml:"weight3" codec:"weight3"`
}
// capture/probability.csv
type Capture_probability struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// probability
	Probability int `yaml:"probability" codec:"probability"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
}
// capture/random.csv
type Capture_random struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// drawTriggerTimes
	DrawTriggerTimes int `yaml:"drawTriggerTimes" codec:"drawTriggerTimes"`
	// drawTriggerType
	DrawTriggerType int `yaml:"drawTriggerType" codec:"drawTriggerType"`
	// drawType
	DrawType string `yaml:"drawType" codec:"drawType"`
	// effectLimit
	EffectLimit int `yaml:"effectLimit" codec:"effectLimit"`
	// libs
	Libs tjcsv.Map `yaml:"libs" codec:"libs"`
	// probEffectInterval
	ProbEffectInterval int `yaml:"probEffectInterval" codec:"probEffectInterval"`
	// probInit
	ProbInit int `yaml:"probInit" codec:"probInit"`
	// probLimit
	ProbLimit float64 `yaml:"probLimit" codec:"probLimit"`
	// probMiniTimes
	ProbMiniTimes int `yaml:"probMiniTimes" codec:"probMiniTimes"`
	// probStep
	ProbStep float64 `yaml:"probStep" codec:"probStep"`
	// startCount
	StartCount int `yaml:"startCount" codec:"startCount"`
	// weightEnd
	WeightEnd int `yaml:"weightEnd" codec:"weightEnd"`
	// weightStart
	WeightStart int `yaml:"weightStart" codec:"weightStart"`
}
// capture/sprite.csv
type Capture_sprite struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// cardID
	CardID int `yaml:"cardID" codec:"cardID"`
	// cd
	Cd int `yaml:"cd" codec:"cd"`
	// exp
	Exp int `yaml:"exp" codec:"exp"`
	// gate
	Gate int `yaml:"gate" codec:"gate"`
	// gatePos
	GatePos tjcsv.Map `yaml:"gatePos" codec:"gatePos"`
	// group
	Group int `yaml:"group" codec:"group"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// limitPos
	LimitPos tjcsv.Slice `yaml:"limitPos" codec:"limitPos"`
	// name
	Name string `yaml:"name" codec:"name"`
	// rate1
	Rate1 int `yaml:"rate1" codec:"rate1"`
	// rate2
	Rate2 int `yaml:"rate2" codec:"rate2"`
	// rate3
	Rate3 int `yaml:"rate3" codec:"rate3"`
	// sceneTimes
	SceneTimes int `yaml:"sceneTimes" codec:"sceneTimes"`
	// time
	Time int `yaml:"time" codec:"time"`
	// totalTimes
	TotalTimes int `yaml:"totalTimes" codec:"totalTimes"`
	// type
	Type int `yaml:"type" codec:"type"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
	// weightFix1
	WeightFix1 float64 `yaml:"weightFix1" codec:"weightFix1"`
	// weightFix2
	WeightFix2 float64 `yaml:"weightFix2" codec:"weightFix2"`
	// weightFix3
	WeightFix3 int `yaml:"weightFix3" codec:"weightFix3"`
}
// card_ability.csv
type Card_ability struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// abilitySeqID
	AbilitySeqID int `yaml:"abilitySeqID" codec:"abilitySeqID"`
	// attrAddScene1
	AttrAddScene1 tjcsv.Slice `yaml:"attrAddScene1" codec:"attrAddScene1"`
	// attrAddScene2
	AttrAddScene2 tjcsv.Slice `yaml:"attrAddScene2" codec:"attrAddScene2"`
	// attrAddType1
	AttrAddType1 int `yaml:"attrAddType1" codec:"attrAddType1"`
	// attrAddType2
	AttrAddType2 int `yaml:"attrAddType2" codec:"attrAddType2"`
	// attrNum1
	AttrNum1 tjcsv.Slice `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 tjcsv.Slice `yaml:"attrNum2" codec:"attrNum2"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// baseSrc
	BaseSrc string `yaml:"baseSrc" codec:"baseSrc"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// effectType
	EffectType int `yaml:"effectType" codec:"effectType"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// iconGray
	IconGray string `yaml:"iconGray" codec:"iconGray"`
	// name
	Name string `yaml:"name" codec:"name"`
	// pos
	Pos tjcsv.Map `yaml:"pos" codec:"pos"`
	// position
	Position int `yaml:"position" codec:"position"`
	// preAbilityID
	PreAbilityID tjcsv.Slice `yaml:"preAbilityID" codec:"preAbilityID"`
	// skillID
	SkillID int `yaml:"skillID" codec:"skillID"`
	// strengthCod1
	StrengthCod1 tjcsv.Slice `yaml:"strengthCod1" codec:"strengthCod1"`
	// strengthCod2
	StrengthCod2 int `yaml:"strengthCod2" codec:"strengthCod2"`
	// strengthMax
	StrengthMax int `yaml:"strengthMax" codec:"strengthMax"`
	// strengthSeqID
	StrengthSeqID int `yaml:"strengthSeqID" codec:"strengthSeqID"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// card_ability_cost.csv
type Card_ability_cost struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// costItemMap1
	CostItemMap1 tjcsv.Map `yaml:"costItemMap1" codec:"costItemMap1"`
	// costItemMap10
	CostItemMap10 tjcsv.Map `yaml:"costItemMap10" codec:"costItemMap10"`
	// costItemMap11
	CostItemMap11 tjcsv.Map `yaml:"costItemMap11" codec:"costItemMap11"`
	// costItemMap12
	CostItemMap12 tjcsv.Map `yaml:"costItemMap12" codec:"costItemMap12"`
	// costItemMap13
	CostItemMap13 tjcsv.Map `yaml:"costItemMap13" codec:"costItemMap13"`
	// costItemMap14
	CostItemMap14 tjcsv.Map `yaml:"costItemMap14" codec:"costItemMap14"`
	// costItemMap15
	CostItemMap15 tjcsv.Map `yaml:"costItemMap15" codec:"costItemMap15"`
	// costItemMap16
	CostItemMap16 tjcsv.Map `yaml:"costItemMap16" codec:"costItemMap16"`
	// costItemMap17
	CostItemMap17 tjcsv.Map `yaml:"costItemMap17" codec:"costItemMap17"`
	// costItemMap18
	CostItemMap18 tjcsv.Map `yaml:"costItemMap18" codec:"costItemMap18"`
	// costItemMap19
	CostItemMap19 tjcsv.Map `yaml:"costItemMap19" codec:"costItemMap19"`
	// costItemMap2
	CostItemMap2 tjcsv.Map `yaml:"costItemMap2" codec:"costItemMap2"`
	// costItemMap20
	CostItemMap20 tjcsv.Map `yaml:"costItemMap20" codec:"costItemMap20"`
	// costItemMap21
	CostItemMap21 tjcsv.Map `yaml:"costItemMap21" codec:"costItemMap21"`
	// costItemMap22
	CostItemMap22 tjcsv.Map `yaml:"costItemMap22" codec:"costItemMap22"`
	// costItemMap23
	CostItemMap23 tjcsv.Map `yaml:"costItemMap23" codec:"costItemMap23"`
	// costItemMap24
	CostItemMap24 tjcsv.Map `yaml:"costItemMap24" codec:"costItemMap24"`
	// costItemMap3
	CostItemMap3 tjcsv.Map `yaml:"costItemMap3" codec:"costItemMap3"`
	// costItemMap4
	CostItemMap4 tjcsv.Map `yaml:"costItemMap4" codec:"costItemMap4"`
	// costItemMap5
	CostItemMap5 tjcsv.Map `yaml:"costItemMap5" codec:"costItemMap5"`
	// costItemMap6
	CostItemMap6 tjcsv.Map `yaml:"costItemMap6" codec:"costItemMap6"`
	// costItemMap7
	CostItemMap7 tjcsv.Map `yaml:"costItemMap7" codec:"costItemMap7"`
	// costItemMap8
	CostItemMap8 tjcsv.Map `yaml:"costItemMap8" codec:"costItemMap8"`
	// costItemMap9
	CostItemMap9 tjcsv.Map `yaml:"costItemMap9" codec:"costItemMap9"`
}
// card_effort.csv
type Card_effort struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// advance
	Advance int `yaml:"advance" codec:"advance"`
	// attrType
	AttrType int `yaml:"attrType" codec:"attrType"`
	// cost1
	Cost1 tjcsv.Map `yaml:"cost1" codec:"cost1"`
	// cost2
	Cost2 tjcsv.Map `yaml:"cost2" codec:"cost2"`
	// randomRange1
	RandomRange1 tjcsv.Slice `yaml:"randomRange1" codec:"randomRange1"`
	// randomRange2
	RandomRange2 tjcsv.Slice `yaml:"randomRange2" codec:"randomRange2"`
}
// card_effort_advance.csv
type Card_effort_advance struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// advance
	Advance int `yaml:"advance" codec:"advance"`
	// advanceLimit
	AdvanceLimit int `yaml:"advanceLimit" codec:"advanceLimit"`
	// attrEffect
	AttrEffect float64 `yaml:"attrEffect" codec:"attrEffect"`
	// damage
	Damage int `yaml:"damage" codec:"damage"`
	// defence
	Defence int `yaml:"defence" codec:"defence"`
	// effortSeqID
	EffortSeqID int `yaml:"effortSeqID" codec:"effortSeqID"`
	// hp
	Hp int `yaml:"hp" codec:"hp"`
	// needLevel
	NeedLevel int `yaml:"needLevel" codec:"needLevel"`
	// specialDamage
	SpecialDamage int `yaml:"specialDamage" codec:"specialDamage"`
	// specialDefence
	SpecialDefence int `yaml:"specialDefence" codec:"specialDefence"`
	// speed
	Speed int `yaml:"speed" codec:"speed"`
}
// card_mega.csv
type Card_mega struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// card
	Card tjcsv.Slice `yaml:"card" codec:"card"`
	// condition
	Condition tjcsv.Slice `yaml:"condition" codec:"condition"`
	// costCards
	CostCards tjcsv.Map `yaml:"costCards" codec:"costCards"`
	// costItems
	CostItems tjcsv.Map `yaml:"costItems" codec:"costItems"`
}
// card_mega_convert.csv
type Card_mega_convert struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// cardConvertNum
	CardConvertNum int `yaml:"cardConvertNum" codec:"cardConvertNum"`
	// costItemCard
	CostItemCard tjcsv.Map `yaml:"costItemCard" codec:"costItemCard"`
	// costItemFrag
	CostItemFrag tjcsv.Map `yaml:"costItemFrag" codec:"costItemFrag"`
	// needCards1
	NeedCards1 tjcsv.Slice `yaml:"needCards1" codec:"needCards1"`
	// needCards2
	NeedCards2 tjcsv.Slice `yaml:"needCards2" codec:"needCards2"`
	// needFrags1
	NeedFrags1 tjcsv.Slice `yaml:"needFrags1" codec:"needFrags1"`
	// needFrags2
	NeedFrags2 tjcsv.Slice `yaml:"needFrags2" codec:"needFrags2"`
	// needSpecialCards
	NeedSpecialCards tjcsv.Slice `yaml:"needSpecialCards" codec:"needSpecialCards"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// card_recast.csv
type Card_recast struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// costItems
	CostItems tjcsv.Map `yaml:"costItems" codec:"costItems"`
	// lockNum
	LockNum int `yaml:"lockNum" codec:"lockNum"`
}
// card_skin.csv
type Card_skin struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// activeType
	ActiveType int `yaml:"activeType" codec:"activeType"`
	// attrAddType
	AttrAddType int `yaml:"attrAddType" codec:"attrAddType"`
	// attrNum1
	AttrNum1 float64 `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 float64 `yaml:"attrNum2" codec:"attrNum2"`
	// attrNum3
	AttrNum3 float64 `yaml:"attrNum3" codec:"attrNum3"`
	// attrNum4
	AttrNum4 interface{} `yaml:"attrNum4" codec:"attrNum4"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// attrType3
	AttrType3 int `yaml:"attrType3" codec:"attrType3"`
	// attrType4
	AttrType4 int `yaml:"attrType4" codec:"attrType4"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// extraItem
	ExtraItem tjcsv.Map `yaml:"extraItem" codec:"extraItem"`
	// isOpen
	IsOpen bool `yaml:"isOpen" codec:"isOpen"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// markID
	MarkID int `yaml:"markID" codec:"markID"`
	// name
	Name string `yaml:"name" codec:"name"`
	// rank
	Rank int `yaml:"rank" codec:"rank"`
	// skinFrameRes
	SkinFrameRes string `yaml:"skinFrameRes" codec:"skinFrameRes"`
	// unitIDs
	UnitIDs tjcsv.Map `yaml:"unitIDs" codec:"unitIDs"`
}
// card_skin_shop.csv
type Card_skin_shop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// exchangeLimit
	ExchangeLimit int `yaml:"exchangeLimit" codec:"exchangeLimit"`
	// extraItem
	ExtraItem tjcsv.Map `yaml:"extraItem" codec:"extraItem"`
	// itemCount
	ItemCount int `yaml:"itemCount" codec:"itemCount"`
	// itemMap
	ItemMap tjcsv.Map `yaml:"itemMap" codec:"itemMap"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
	// limitTimes
	LimitTimes int `yaml:"limitTimes" codec:"limitTimes"`
	// limitType
	LimitType int `yaml:"limitType" codec:"limitType"`
	// litSkinNum
	LitSkinNum int `yaml:"litSkinNum" codec:"litSkinNum"`
	// position
	Position int `yaml:"position" codec:"position"`
	// showUnable
	ShowUnable bool `yaml:"showUnable" codec:"showUnable"`
	// type
	Type int `yaml:"type" codec:"type"`
	// vipStart
	VipStart int `yaml:"vipStart" codec:"vipStart"`
	// vipWeight
	VipWeight int `yaml:"vipWeight" codec:"vipWeight"`
}
// card_star.csv
type Card_star struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// blockLevelC
	BlockLevelC int `yaml:"blockLevelC" codec:"blockLevelC"`
	// blockPowerC
	BlockPowerC int `yaml:"blockPowerC" codec:"blockPowerC"`
	// breakBlockLevelC
	BreakBlockLevelC int `yaml:"breakBlockLevelC" codec:"breakBlockLevelC"`
	// costCardNum
	CostCardNum int `yaml:"costCardNum" codec:"costCardNum"`
	// costItems
	CostItems tjcsv.Map `yaml:"costItems" codec:"costItems"`
	// curePowerC
	CurePowerC int `yaml:"curePowerC" codec:"curePowerC"`
	// damageAddC
	DamageAddC int `yaml:"damageAddC" codec:"damageAddC"`
	// damageC
	DamageC float64 `yaml:"damageC" codec:"damageC"`
	// damageDeepenC
	DamageDeepenC int `yaml:"damageDeepenC" codec:"damageDeepenC"`
	// damageGrow
	DamageGrow float64 `yaml:"damageGrow" codec:"damageGrow"`
	// damageReduceC
	DamageReduceC int `yaml:"damageReduceC" codec:"damageReduceC"`
	// damageSubC
	DamageSubC int `yaml:"damageSubC" codec:"damageSubC"`
	// defenceC
	DefenceC float64 `yaml:"defenceC" codec:"defenceC"`
	// defenceGrow
	DefenceGrow float64 `yaml:"defenceGrow" codec:"defenceGrow"`
	// defenceIgnoreC
	DefenceIgnoreC int `yaml:"defenceIgnoreC" codec:"defenceIgnoreC"`
	// dodgeC
	DodgeC int `yaml:"dodgeC" codec:"dodgeC"`
	// gold
	Gold int `yaml:"gold" codec:"gold"`
	// hitC
	HitC int `yaml:"hitC" codec:"hitC"`
	// hpC
	HpC float64 `yaml:"hpC" codec:"hpC"`
	// hpGrow
	HpGrow float64 `yaml:"hpGrow" codec:"hpGrow"`
	// hpRecoverC
	HpRecoverC int `yaml:"hpRecoverC" codec:"hpRecoverC"`
	// initMp1C
	InitMp1C int `yaml:"initMp1C" codec:"initMp1C"`
	// mainSkillAddC
	MainSkillAddC int `yaml:"mainSkillAddC" codec:"mainSkillAddC"`
	// mainSkillSubC
	MainSkillSubC int `yaml:"mainSkillSubC" codec:"mainSkillSubC"`
	// mp1C
	Mp1C int `yaml:"mp1C" codec:"mp1C"`
	// mp1RecoverC
	Mp1RecoverC int `yaml:"mp1RecoverC" codec:"mp1RecoverC"`
	// mp2RecoverC
	Mp2RecoverC int `yaml:"mp2RecoverC" codec:"mp2RecoverC"`
	// natureRestraintC
	NatureRestraintC int `yaml:"natureRestraintC" codec:"natureRestraintC"`
	// reboundC
	ReboundC int `yaml:"reboundC" codec:"reboundC"`
	// specialDamageC
	SpecialDamageC float64 `yaml:"specialDamageC" codec:"specialDamageC"`
	// specialDamageGrow
	SpecialDamageGrow float64 `yaml:"specialDamageGrow" codec:"specialDamageGrow"`
	// specialDefenceC
	SpecialDefenceC float64 `yaml:"specialDefenceC" codec:"specialDefenceC"`
	// specialDefenceGrow
	SpecialDefenceGrow float64 `yaml:"specialDefenceGrow" codec:"specialDefenceGrow"`
	// specialDefenceIgnore
	SpecialDefenceIgnore int `yaml:"specialDefenceIgnore" codec:"specialDefenceIgnore"`
	// speedC
	SpeedC float64 `yaml:"speedC" codec:"speedC"`
	// speedGrow
	SpeedGrow float64 `yaml:"speedGrow" codec:"speedGrow"`
	// star
	Star int `yaml:"star" codec:"star"`
	// strikeDamageC
	StrikeDamageC int `yaml:"strikeDamageC" codec:"strikeDamageC"`
	// strikeLevelC
	StrikeLevelC int `yaml:"strikeLevelC" codec:"strikeLevelC"`
	// strikeResistanceC
	StrikeResistanceC int `yaml:"strikeResistanceC" codec:"strikeResistanceC"`
	// suckBloodC
	SuckBloodC int `yaml:"suckBloodC" codec:"suckBloodC"`
	// typeID
	TypeID int `yaml:"typeID" codec:"typeID"`
	// universalCards
	UniversalCards tjcsv.Slice `yaml:"universalCards" codec:"universalCards"`
}
// card_star2frag.csv
type Card_star2frag struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// baseFragNum
	BaseFragNum int `yaml:"baseFragNum" codec:"baseFragNum"`
	// getStar
	GetStar int `yaml:"getStar" codec:"getStar"`
	// hasStar1
	HasStar1 int `yaml:"hasStar1" codec:"hasStar1"`
	// hasStar2
	HasStar2 int `yaml:"hasStar2" codec:"hasStar2"`
	// hasStar3
	HasStar3 int `yaml:"hasStar3" codec:"hasStar3"`
	// hasStar4
	HasStar4 int `yaml:"hasStar4" codec:"hasStar4"`
	// hasStar5
	HasStar5 int `yaml:"hasStar5" codec:"hasStar5"`
	// hasStar6
	HasStar6 int `yaml:"hasStar6" codec:"hasStar6"`
	// hasStar7
	HasStar7 int `yaml:"hasStar7" codec:"hasStar7"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// card_star_effect.csv
type Card_star_effect struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNatureType
	AttrNatureType int `yaml:"attrNatureType" codec:"attrNatureType"`
	// attrNum
	AttrNum tjcsv.Map `yaml:"attrNum" codec:"attrNum"`
	// attrTarget
	AttrTarget int `yaml:"attrTarget" codec:"attrTarget"`
	// effectDesc
	EffectDesc string `yaml:"effectDesc" codec:"effectDesc"`
	// star
	Star int `yaml:"star" codec:"star"`
	// typeID
	TypeID int `yaml:"typeID" codec:"typeID"`
}
// card_star_skill.csv
type Card_star_skill struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// cardExchangeRate
	CardExchangeRate int `yaml:"cardExchangeRate" codec:"cardExchangeRate"`
	// fragExchangeRate
	FragExchangeRate int `yaml:"fragExchangeRate" codec:"fragExchangeRate"`
	// starSkillList
	StarSkillList tjcsv.Slice `yaml:"starSkillList" codec:"starSkillList"`
	// universalCards
	UniversalCards tjcsv.Slice `yaml:"universalCards" codec:"universalCards"`
}
// cards.csv
type Cards struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// abilitySeqID
	AbilitySeqID int `yaml:"abilitySeqID" codec:"abilitySeqID"`
	// advanceLevelReq
	AdvanceLevelReq tjcsv.Slice `yaml:"advanceLevelReq" codec:"advanceLevelReq"`
	// advanceMax
	AdvanceMax int `yaml:"advanceMax" codec:"advanceMax"`
	// advanceTypeID
	AdvanceTypeID int `yaml:"advanceTypeID" codec:"advanceTypeID"`
	// atkType
	AtkType tjcsv.Slice `yaml:"atkType" codec:"atkType"`
	// branch
	Branch int `yaml:"branch" codec:"branch"`
	// branchType
	BranchType int `yaml:"branchType" codec:"branchType"`
	// canDevelop
	CanDevelop bool `yaml:"canDevelop" codec:"canDevelop"`
	// cardMarkID
	CardMarkID int `yaml:"cardMarkID" codec:"cardMarkID"`
	// cardType
	CardType int `yaml:"cardType" codec:"cardType"`
	// chaRecom
	ChaRecom tjcsv.Slice `yaml:"chaRecom" codec:"chaRecom"`
	// chaRnd
	ChaRnd int `yaml:"chaRnd" codec:"chaRnd"`
	// contractPlan
	ContractPlan int `yaml:"contractPlan" codec:"contractPlan"`
	// develop
	Develop int `yaml:"develop" codec:"develop"`
	// developType
	DevelopType int `yaml:"developType" codec:"developType"`
	// drawlanguages
	Drawlanguages tjcsv.Slice `yaml:"drawlanguages" codec:"drawlanguages"`
	// effect
	Effect tjcsv.Map `yaml:"effect" codec:"effect"`
	// effortSeqID
	EffortSeqID int `yaml:"effortSeqID" codec:"effortSeqID"`
	// energy
	Energy int `yaml:"energy" codec:"energy"`
	// energyCorrection
	EnergyCorrection int `yaml:"energyCorrection" codec:"energyCorrection"`
	// equipsList
	EquipsList tjcsv.Slice `yaml:"equipsList" codec:"equipsList"`
	// feelItems
	FeelItems tjcsv.Slice `yaml:"feelItems" codec:"feelItems"`
	// feelType
	FeelType int `yaml:"feelType" codec:"feelType"`
	// fetterList
	FetterList tjcsv.Slice `yaml:"fetterList" codec:"fetterList"`
	// fightingWeight
	FightingWeight int `yaml:"fightingWeight" codec:"fightingWeight"`
	// fragID
	FragID int `yaml:"fragID" codec:"fragID"`
	// fragNumType
	FragNumType int `yaml:"fragNumType" codec:"fragNumType"`
	// gemPosSeqID
	GemPosSeqID int `yaml:"gemPosSeqID" codec:"gemPosSeqID"`
	// gemQualitySeqID
	GemQualitySeqID int `yaml:"gemQualitySeqID" codec:"gemQualitySeqID"`
	// gender
	Gender int `yaml:"gender" codec:"gender"`
	// innateSkillID
	InnateSkillID int `yaml:"innateSkillID" codec:"innateSkillID"`
	// introduction
	Introduction string `yaml:"introduction" codec:"introduction"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// levelExpID
	LevelExpID int `yaml:"levelExpID" codec:"levelExpID"`
	// levelMax
	LevelMax int `yaml:"levelMax" codec:"levelMax"`
	// location
	Location string `yaml:"location" codec:"location"`
	// maleRate
	MaleRate int `yaml:"maleRate" codec:"maleRate"`
	// megaIndex
	MegaIndex int `yaml:"megaIndex" codec:"megaIndex"`
	// nValueRnd
	NValueRnd int `yaml:"nValueRnd" codec:"nValueRnd"`
	// name
	Name string `yaml:"name" codec:"name"`
	// skillList
	SkillList tjcsv.Slice `yaml:"skillList" codec:"skillList"`
	// skinSkillMap
	SkinSkillMap tjcsv.Map `yaml:"skinSkillMap" codec:"skinSkillMap"`
	// specValue
	SpecValue tjcsv.Slice `yaml:"specValue" codec:"specValue"`
	// star
	Star int `yaml:"star" codec:"star"`
	// starEffectIndex
	StarEffectIndex int `yaml:"starEffectIndex" codec:"starEffectIndex"`
	// starSkillMaxLevel
	StarSkillMaxLevel int `yaml:"starSkillMaxLevel" codec:"starSkillMaxLevel"`
	// starSkillSeqID
	StarSkillSeqID int `yaml:"starSkillSeqID" codec:"starSkillSeqID"`
	// starTypeID
	StarTypeID int `yaml:"starTypeID" codec:"starTypeID"`
	// townSkill
	TownSkill int `yaml:"townSkill" codec:"townSkill"`
	// unitID
	UnitID int `yaml:"unitID" codec:"unitID"`
	// zawakeFragID
	ZawakeFragID int `yaml:"zawakeFragID" codec:"zawakeFragID"`
	// zawakeID
	ZawakeID int `yaml:"zawakeID" codec:"zawakeID"`
}
// cards_branch_cost.csv
type Cards_branch_cost struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// cost
	Cost tjcsv.Slice `yaml:"cost" codec:"cost"`
	// developType
	DevelopType int `yaml:"developType" codec:"developType"`
}
// character.csv
type Character struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrMap
	AttrMap tjcsv.Map `yaml:"attrMap" codec:"attrMap"`
	// name
	Name string `yaml:"name" codec:"name"`
	// res
	Res interface{} `yaml:"res" codec:"res"`
}
// character_random.csv
type Character_random struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// weightList
	WeightList tjcsv.Map `yaml:"weightList" codec:"weightList"`
}
// chat_emoji.csv
type Chat_emoji struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// key
	Key string `yaml:"key" codec:"key"`
	// resource
	Resource string `yaml:"resource" codec:"resource"`
	// tab
	Tab tjcsv.Slice `yaml:"tab" codec:"tab"`
	// text
	Text string `yaml:"text" codec:"text"`
}
// chat_limit.csv
type Chat_limit struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// correction
	Correction float64 `yaml:"correction" codec:"correction"`
	// gateStarSum
	GateStarSum int `yaml:"gateStarSum" codec:"gateStarSum"`
}
// chip
type Chip struct {
	// chip/chips.csv
	Chips map[int]*Chip_chips `yaml:"chips" codec:"chips"`
	// chip/libs.csv
	Libs map[int]*Chip_libs `yaml:"libs" codec:"libs"`
	// chip/main_attr.csv
	Main_attr map[int]*Chip_main_attr `yaml:"main_attr" codec:"main_attr"`
	// chip/recast_cost.csv
	Recast_cost map[int]*Chip_recast_cost `yaml:"recast_cost" codec:"recast_cost"`
	// chip/resonance.csv
	Resonance map[int]*Chip_resonance `yaml:"resonance" codec:"resonance"`
	// chip/strength_cost.csv
	Strength_cost map[int]*Chip_strength_cost `yaml:"strength_cost" codec:"strength_cost"`
	// chip/suits.csv
	Suits map[int]*Chip_suits `yaml:"suits" codec:"suits"`
}
// chip/chips.csv
type Chip_chips struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// acquiredLevels
	AcquiredLevels tjcsv.Slice `yaml:"acquiredLevels" codec:"acquiredLevels"`
	// acquiredLib
	AcquiredLib int `yaml:"acquiredLib" codec:"acquiredLib"`
	// acquiredLimit
	AcquiredLimit int `yaml:"acquiredLimit" codec:"acquiredLimit"`
	// effect
	Effect tjcsv.Map `yaml:"effect" codec:"effect"`
	// exp
	Exp int `yaml:"exp" codec:"exp"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// mainAttr
	MainAttr int `yaml:"mainAttr" codec:"mainAttr"`
	// maxLevel
	MaxLevel int `yaml:"maxLevel" codec:"maxLevel"`
	// name
	Name string `yaml:"name" codec:"name"`
	// pos
	Pos int `yaml:"pos" codec:"pos"`
	// quality
	Quality int `yaml:"quality" codec:"quality"`
	// recastCostSeq
	RecastCostSeq int `yaml:"recastCostSeq" codec:"recastCostSeq"`
	// recastLib
	RecastLib int `yaml:"recastLib" codec:"recastLib"`
	// startLib
	StartLib int `yaml:"startLib" codec:"startLib"`
	// startNum
	StartNum int `yaml:"startNum" codec:"startNum"`
	// strengthLevels
	StrengthLevels tjcsv.Slice `yaml:"strengthLevels" codec:"strengthLevels"`
	// strengthSeq
	StrengthSeq int `yaml:"strengthSeq" codec:"strengthSeq"`
	// suitID
	SuitID int `yaml:"suitID" codec:"suitID"`
}
// chip/libs.csv
type Chip_libs struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNum1
	AttrNum1 tjcsv.Slice `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 tjcsv.Slice `yaml:"attrNum2" codec:"attrNum2"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// attrsDesc
	AttrsDesc string `yaml:"attrsDesc" codec:"attrsDesc"`
	// drawWeight
	DrawWeight int `yaml:"drawWeight" codec:"drawWeight"`
	// drawWeightFix
	DrawWeightFix int `yaml:"drawWeightFix" codec:"drawWeightFix"`
	// randomLibID
	RandomLibID int `yaml:"randomLibID" codec:"randomLibID"`
	// recastWeight
	RecastWeight tjcsv.Slice `yaml:"recastWeight" codec:"recastWeight"`
	// recastWeightFix
	RecastWeightFix tjcsv.Slice `yaml:"recastWeightFix" codec:"recastWeightFix"`
}
// chip/main_attr.csv
type Chip_main_attr struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNum1
	AttrNum1 int `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 int `yaml:"attrNum2" codec:"attrNum2"`
	// attrNum3
	AttrNum3 int `yaml:"attrNum3" codec:"attrNum3"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// attrType3
	AttrType3 int `yaml:"attrType3" codec:"attrType3"`
	// level
	Level int `yaml:"level" codec:"level"`
	// seq
	Seq int `yaml:"seq" codec:"seq"`
}
// chip/recast_cost.csv
type Chip_recast_cost struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// costItemMap1
	CostItemMap1 tjcsv.Map `yaml:"costItemMap1" codec:"costItemMap1"`
	// costItemMap2
	CostItemMap2 tjcsv.Map `yaml:"costItemMap2" codec:"costItemMap2"`
	// costItemMap3
	CostItemMap3 tjcsv.Map `yaml:"costItemMap3" codec:"costItemMap3"`
	// costItemMap4
	CostItemMap4 tjcsv.Map `yaml:"costItemMap4" codec:"costItemMap4"`
	// costItemMap5
	CostItemMap5 tjcsv.Map `yaml:"costItemMap5" codec:"costItemMap5"`
}
// chip/resonance.csv
type Chip_resonance struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNum1
	AttrNum1 string `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 string `yaml:"attrNum2" codec:"attrNum2"`
	// attrNum3
	AttrNum3 string `yaml:"attrNum3" codec:"attrNum3"`
	// attrNum4
	AttrNum4 string `yaml:"attrNum4" codec:"attrNum4"`
	// attrNum5
	AttrNum5 string `yaml:"attrNum5" codec:"attrNum5"`
	// attrNum6
	AttrNum6 string `yaml:"attrNum6" codec:"attrNum6"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// attrType3
	AttrType3 int `yaml:"attrType3" codec:"attrType3"`
	// attrType4
	AttrType4 int `yaml:"attrType4" codec:"attrType4"`
	// attrType5
	AttrType5 int `yaml:"attrType5" codec:"attrType5"`
	// attrType6
	AttrType6 int `yaml:"attrType6" codec:"attrType6"`
	// groupID
	GroupID int `yaml:"groupID" codec:"groupID"`
	// param
	Param tjcsv.Slice `yaml:"param" codec:"param"`
	// priority
	Priority int `yaml:"priority" codec:"priority"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// chip/strength_cost.csv
type Chip_strength_cost struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// levelExp1
	LevelExp1 int `yaml:"levelExp1" codec:"levelExp1"`
	// levelExp2
	LevelExp2 int `yaml:"levelExp2" codec:"levelExp2"`
	// levelExp3
	LevelExp3 int `yaml:"levelExp3" codec:"levelExp3"`
	// levelExp4
	LevelExp4 int `yaml:"levelExp4" codec:"levelExp4"`
	// levelExp5
	LevelExp5 int `yaml:"levelExp5" codec:"levelExp5"`
	// levelExp6
	LevelExp6 int `yaml:"levelExp6" codec:"levelExp6"`
}
// chip/suits.csv
type Chip_suits struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNum1
	AttrNum1 string `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 string `yaml:"attrNum2" codec:"attrNum2"`
	// attrNum3
	AttrNum3 string `yaml:"attrNum3" codec:"attrNum3"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// attrType3
	AttrType3 int `yaml:"attrType3" codec:"attrType3"`
	// skillID
	SkillID int `yaml:"skillID" codec:"skillID"`
	// suitID
	SuitID int `yaml:"suitID" codec:"suitID"`
	// suitIcon
	SuitIcon string `yaml:"suitIcon" codec:"suitIcon"`
	// suitName
	SuitName string `yaml:"suitName" codec:"suitName"`
	// suitNum
	SuitNum int `yaml:"suitNum" codec:"suitNum"`
	// suitQuality
	SuitQuality int `yaml:"suitQuality" codec:"suitQuality"`
}
// city_sprites.csv
type City_sprites struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// action
	Action bool `yaml:"action" codec:"action"`
	// active
	Active bool `yaml:"active" codec:"active"`
	// activityIds
	ActivityIds tjcsv.Slice `yaml:"activityIds" codec:"activityIds"`
	// activityPosition
	ActivityPosition tjcsv.Map `yaml:"activityPosition" codec:"activityPosition"`
	// activityScale
	ActivityScale int `yaml:"activityScale" codec:"activityScale"`
	// baibianRandLib
	BaibianRandLib int `yaml:"baibianRandLib" codec:"baibianRandLib"`
	// chattext1
	Chattext1 string `yaml:"chattext1" codec:"chattext1"`
	// chattext2
	Chattext2 string `yaml:"chattext2" codec:"chattext2"`
	// chattext3
	Chattext3 string `yaml:"chattext3" codec:"chattext3"`
	// group
	Group int `yaml:"group" codec:"group"`
	// offPos
	OffPos tjcsv.Map `yaml:"offPos" codec:"offPos"`
	// overture
	Overture bool `yaml:"overture" codec:"overture"`
	// position
	Position tjcsv.Map `yaml:"position" codec:"position"`
	// randLib
	RandLib int `yaml:"randLib" codec:"randLib"`
	// res
	Res string `yaml:"res" codec:"res"`
	// scale
	Scale float64 `yaml:"scale" codec:"scale"`
	// touchSize
	TouchSize tjcsv.Map `yaml:"touchSize" codec:"touchSize"`
	// type
	Type int `yaml:"type" codec:"type"`
	// unfreezeAward
	UnfreezeAward tjcsv.Map `yaml:"unfreezeAward" codec:"unfreezeAward"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
	// zOrder
	ZOrder int `yaml:"zOrder" codec:"zOrder"`
}
// clone
type Clone struct {
	// clone/award.csv
	Award map[int]*Clone_award `yaml:"award" codec:"award"`
	// clone/battle.csv
	Battle map[int]*Clone_battle `yaml:"battle" codec:"battle"`
	// clone/draw_box_cost.csv
	Draw_box_cost map[int]*Clone_draw_box_cost `yaml:"draw_box_cost" codec:"draw_box_cost"`
	// clone/monster.csv
	Monster map[int]*Clone_monster `yaml:"monster" codec:"monster"`
	// clone/nature.csv
	Nature map[int]*Clone_nature `yaml:"nature" codec:"nature"`
	// clone/rarity.csv
	Rarity map[int]*Clone_rarity `yaml:"rarity" codec:"rarity"`
}
// clone/award.csv
type Clone_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// dropLib
	DropLib tjcsv.Slice `yaml:"dropLib" codec:"dropLib"`
	// dropNum
	DropNum int `yaml:"dropNum" codec:"dropNum"`
	// randWeight
	RandWeight int `yaml:"randWeight" codec:"randWeight"`
}
// clone/battle.csv
type Clone_battle struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrFix1
	AttrFix1 float64 `yaml:"attrFix1" codec:"attrFix1"`
	// attrFix2
	AttrFix2 float64 `yaml:"attrFix2" codec:"attrFix2"`
	// attrFix3
	AttrFix3 float64 `yaml:"attrFix3" codec:"attrFix3"`
	// attrFix4
	AttrFix4 float64 `yaml:"attrFix4" codec:"attrFix4"`
	// attrFix5
	AttrFix5 float64 `yaml:"attrFix5" codec:"attrFix5"`
	// attrFix6
	AttrFix6 float64 `yaml:"attrFix6" codec:"attrFix6"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// attrType3
	AttrType3 int `yaml:"attrType3" codec:"attrType3"`
	// attrType4
	AttrType4 int `yaml:"attrType4" codec:"attrType4"`
	// attrType5
	AttrType5 int `yaml:"attrType5" codec:"attrType5"`
	// attrType6
	AttrType6 int `yaml:"attrType6" codec:"attrType6"`
	// skillLevelFix
	SkillLevelFix float64 `yaml:"skillLevelFix" codec:"skillLevelFix"`
}
// clone/draw_box_cost.csv
type Clone_draw_box_cost struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// rarity
	Rarity int `yaml:"rarity" codec:"rarity"`
	// seqParam
	SeqParam tjcsv.Slice `yaml:"seqParam" codec:"seqParam"`
}
// clone/monster.csv
type Clone_monster struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// CDTime
	CDTime int `yaml:"CDTime" codec:"CDTime"`
	// cardID
	CardID int `yaml:"cardID" codec:"cardID"`
	// extraAward
	ExtraAward tjcsv.Map `yaml:"extraAward" codec:"extraAward"`
	// isForce
	IsForce int `yaml:"isForce" codec:"isForce"`
	// serverOpenDays
	ServerOpenDays int `yaml:"serverOpenDays" codec:"serverOpenDays"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
	// weight2
	Weight2 int `yaml:"weight2" codec:"weight2"`
}
// clone/nature.csv
type Clone_nature struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// CDTime
	CDTime int `yaml:"CDTime" codec:"CDTime"`
	// fix
	Fix float64 `yaml:"fix" codec:"fix"`
	// name
	Name string `yaml:"name" codec:"name"`
	// recommendAttr
	RecommendAttr tjcsv.Slice `yaml:"recommendAttr" codec:"recommendAttr"`
	// robot1
	Robot1 int `yaml:"robot1" codec:"robot1"`
	// robot2
	Robot2 int `yaml:"robot2" codec:"robot2"`
	// robot3
	Robot3 int `yaml:"robot3" codec:"robot3"`
	// robot4
	Robot4 int `yaml:"robot4" codec:"robot4"`
	// spine
	Spine string `yaml:"spine" codec:"spine"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
}
// clone/rarity.csv
type Clone_rarity struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// rarityMatch
	RarityMatch tjcsv.Map `yaml:"rarityMatch" codec:"rarityMatch"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
}
// combat_power_correction.csv
type Combat_power_correction struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attr
	Attr tjcsv.Map `yaml:"attr" codec:"attr"`
	// buffProbRate
	BuffProbRate float64 `yaml:"buffProbRate" codec:"buffProbRate"`
	// buffValueRate
	BuffValueRate float64 `yaml:"buffValueRate" codec:"buffValueRate"`
	// combatPowerLimit
	CombatPowerLimit tjcsv.Map `yaml:"combatPowerLimit" codec:"combatPowerLimit"`
	// excludeBuffID
	ExcludeBuffID tjcsv.Slice `yaml:"excludeBuffID" codec:"excludeBuffID"`
	// fightPointRate
	FightPointRate tjcsv.Slice `yaml:"fightPointRate" codec:"fightPointRate"`
	// groupKey
	GroupKey string `yaml:"groupKey" codec:"groupKey"`
}
// common_config.csv
type Common_config struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// name
	Name string `yaml:"name" codec:"name"`
	// value
	Value float64 `yaml:"value" codec:"value"`
	// valueArray
	ValueArray tjcsv.Slice `yaml:"valueArray" codec:"valueArray"`
}
// cost.csv
type Cost struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// mapParam
	MapParam tjcsv.Map `yaml:"mapParam" codec:"mapParam"`
	// seqParam
	SeqParam tjcsv.Slice `yaml:"seqParam" codec:"seqParam"`
	// service
	Service string `yaml:"service" codec:"service"`
}
// craft
type Craft struct {
	// craft/base.csv
	Base map[int]*Craft_base `yaml:"base" codec:"base"`
	// craft/buffs.csv
	Buffs map[int]*Craft_buffs `yaml:"buffs" codec:"buffs"`
	// craft/craft_special_rule.csv
	Craft_special_rule map[int]*Craft_craft_special_rule `yaml:"craft_special_rule" codec:"craft_special_rule"`
	// craft/rank.csv
	Rank map[int]*Craft_rank `yaml:"rank" codec:"rank"`
	// craft/robot_card.csv
	Robot_card map[int]*Craft_robot_card `yaml:"robot_card" codec:"robot_card"`
	// craft/robot_level.csv
	Robot_level map[int]*Craft_robot_level `yaml:"robot_level" codec:"robot_level"`
	// craft/robot_num.csv
	Robot_num map[int]*Craft_robot_num `yaml:"robot_num" codec:"robot_num"`
	// craft/shop.csv
	Shop map[int]*Craft_shop `yaml:"shop" codec:"shop"`
}
// craft/base.csv
type Craft_base struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// autoSignVIP
	AutoSignVIP int `yaml:"autoSignVIP" codec:"autoSignVIP"`
	// betRateFix
	BetRateFix int `yaml:"betRateFix" codec:"betRateFix"`
	// damageScoreRatio
	DamageScoreRatio int `yaml:"damageScoreRatio" codec:"damageScoreRatio"`
	// failAward
	FailAward tjcsv.Slice `yaml:"failAward" codec:"failAward"`
	// maxBetWin
	MaxBetWin int `yaml:"maxBetWin" codec:"maxBetWin"`
	// minBetRate
	MinBetRate int `yaml:"minBetRate" codec:"minBetRate"`
	// numMax
	NumMax int `yaml:"numMax" codec:"numMax"`
	// openWeekday
	OpenWeekday tjcsv.Slice `yaml:"openWeekday" codec:"openWeekday"`
	// servOpenDays
	ServOpenDays int `yaml:"servOpenDays" codec:"servOpenDays"`
	// winAward
	WinAward tjcsv.Slice `yaml:"winAward" codec:"winAward"`
}
// craft/buffs.csv
type Craft_buffs struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNum
	AttrNum string `yaml:"attrNum" codec:"attrNum"`
	// attrType
	AttrType int `yaml:"attrType" codec:"attrType"`
	// natureTypes
	NatureTypes tjcsv.Slice `yaml:"natureTypes" codec:"natureTypes"`
}
// craft/craft_special_rule.csv
type Craft_craft_special_rule struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// buffType
	BuffType string `yaml:"buffType" codec:"buffType"`
	// isOpen
	IsOpen bool `yaml:"isOpen" codec:"isOpen"`
	// markID
	MarkID int `yaml:"markID" codec:"markID"`
}
// craft/rank.csv
type Craft_rank struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Slice `yaml:"award" codec:"award"`
	// rankMax
	RankMax int `yaml:"rankMax" codec:"rankMax"`
	// version
	Version int `yaml:"version" codec:"version"`
}
// craft/robot_card.csv
type Craft_robot_card struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// advance1
	Advance1 tjcsv.Slice `yaml:"advance1" codec:"advance1"`
	// advance10
	Advance10 tjcsv.Slice `yaml:"advance10" codec:"advance10"`
	// advance2
	Advance2 tjcsv.Slice `yaml:"advance2" codec:"advance2"`
	// advance3
	Advance3 tjcsv.Slice `yaml:"advance3" codec:"advance3"`
	// advance4
	Advance4 tjcsv.Slice `yaml:"advance4" codec:"advance4"`
	// advance5
	Advance5 tjcsv.Slice `yaml:"advance5" codec:"advance5"`
	// advance6
	Advance6 tjcsv.Slice `yaml:"advance6" codec:"advance6"`
	// advance7
	Advance7 tjcsv.Slice `yaml:"advance7" codec:"advance7"`
	// advance8
	Advance8 tjcsv.Slice `yaml:"advance8" codec:"advance8"`
	// advance9
	Advance9 tjcsv.Slice `yaml:"advance9" codec:"advance9"`
	// card1
	Card1 int `yaml:"card1" codec:"card1"`
	// card10
	Card10 int `yaml:"card10" codec:"card10"`
	// card2
	Card2 int `yaml:"card2" codec:"card2"`
	// card3
	Card3 int `yaml:"card3" codec:"card3"`
	// card4
	Card4 int `yaml:"card4" codec:"card4"`
	// card5
	Card5 int `yaml:"card5" codec:"card5"`
	// card6
	Card6 int `yaml:"card6" codec:"card6"`
	// card7
	Card7 int `yaml:"card7" codec:"card7"`
	// card8
	Card8 int `yaml:"card8" codec:"card8"`
	// card9
	Card9 int `yaml:"card9" codec:"card9"`
	// damageC1
	DamageC1 tjcsv.Slice `yaml:"damageC1" codec:"damageC1"`
	// damageC10
	DamageC10 tjcsv.Slice `yaml:"damageC10" codec:"damageC10"`
	// damageC2
	DamageC2 tjcsv.Slice `yaml:"damageC2" codec:"damageC2"`
	// damageC3
	DamageC3 tjcsv.Slice `yaml:"damageC3" codec:"damageC3"`
	// damageC4
	DamageC4 tjcsv.Slice `yaml:"damageC4" codec:"damageC4"`
	// damageC5
	DamageC5 tjcsv.Slice `yaml:"damageC5" codec:"damageC5"`
	// damageC6
	DamageC6 tjcsv.Slice `yaml:"damageC6" codec:"damageC6"`
	// damageC7
	DamageC7 tjcsv.Slice `yaml:"damageC7" codec:"damageC7"`
	// damageC8
	DamageC8 tjcsv.Slice `yaml:"damageC8" codec:"damageC8"`
	// damageC9
	DamageC9 tjcsv.Slice `yaml:"damageC9" codec:"damageC9"`
	// defenceC1
	DefenceC1 tjcsv.Slice `yaml:"defenceC1" codec:"defenceC1"`
	// defenceC10
	DefenceC10 tjcsv.Slice `yaml:"defenceC10" codec:"defenceC10"`
	// defenceC2
	DefenceC2 tjcsv.Slice `yaml:"defenceC2" codec:"defenceC2"`
	// defenceC3
	DefenceC3 tjcsv.Slice `yaml:"defenceC3" codec:"defenceC3"`
	// defenceC4
	DefenceC4 tjcsv.Slice `yaml:"defenceC4" codec:"defenceC4"`
	// defenceC5
	DefenceC5 tjcsv.Slice `yaml:"defenceC5" codec:"defenceC5"`
	// defenceC6
	DefenceC6 tjcsv.Slice `yaml:"defenceC6" codec:"defenceC6"`
	// defenceC7
	DefenceC7 tjcsv.Slice `yaml:"defenceC7" codec:"defenceC7"`
	// defenceC8
	DefenceC8 tjcsv.Slice `yaml:"defenceC8" codec:"defenceC8"`
	// defenceC9
	DefenceC9 tjcsv.Slice `yaml:"defenceC9" codec:"defenceC9"`
	// hpC1
	HpC1 tjcsv.Slice `yaml:"hpC1" codec:"hpC1"`
	// hpC10
	HpC10 tjcsv.Slice `yaml:"hpC10" codec:"hpC10"`
	// hpC2
	HpC2 tjcsv.Slice `yaml:"hpC2" codec:"hpC2"`
	// hpC3
	HpC3 tjcsv.Slice `yaml:"hpC3" codec:"hpC3"`
	// hpC4
	HpC4 tjcsv.Slice `yaml:"hpC4" codec:"hpC4"`
	// hpC5
	HpC5 tjcsv.Slice `yaml:"hpC5" codec:"hpC5"`
	// hpC6
	HpC6 tjcsv.Slice `yaml:"hpC6" codec:"hpC6"`
	// hpC7
	HpC7 tjcsv.Slice `yaml:"hpC7" codec:"hpC7"`
	// hpC8
	HpC8 tjcsv.Slice `yaml:"hpC8" codec:"hpC8"`
	// hpC9
	HpC9 tjcsv.Slice `yaml:"hpC9" codec:"hpC9"`
	// levelC1
	LevelC1 tjcsv.Slice `yaml:"levelC1" codec:"levelC1"`
	// levelC10
	LevelC10 tjcsv.Slice `yaml:"levelC10" codec:"levelC10"`
	// levelC2
	LevelC2 tjcsv.Slice `yaml:"levelC2" codec:"levelC2"`
	// levelC3
	LevelC3 tjcsv.Slice `yaml:"levelC3" codec:"levelC3"`
	// levelC4
	LevelC4 tjcsv.Slice `yaml:"levelC4" codec:"levelC4"`
	// levelC5
	LevelC5 tjcsv.Slice `yaml:"levelC5" codec:"levelC5"`
	// levelC6
	LevelC6 tjcsv.Slice `yaml:"levelC6" codec:"levelC6"`
	// levelC7
	LevelC7 tjcsv.Slice `yaml:"levelC7" codec:"levelC7"`
	// levelC8
	LevelC8 tjcsv.Slice `yaml:"levelC8" codec:"levelC8"`
	// levelC9
	LevelC9 tjcsv.Slice `yaml:"levelC9" codec:"levelC9"`
	// levelMax
	LevelMax int `yaml:"levelMax" codec:"levelMax"`
	// specialDamageC1
	SpecialDamageC1 tjcsv.Slice `yaml:"specialDamageC1" codec:"specialDamageC1"`
	// specialDamageC10
	SpecialDamageC10 tjcsv.Slice `yaml:"specialDamageC10" codec:"specialDamageC10"`
	// specialDamageC2
	SpecialDamageC2 tjcsv.Slice `yaml:"specialDamageC2" codec:"specialDamageC2"`
	// specialDamageC3
	SpecialDamageC3 tjcsv.Slice `yaml:"specialDamageC3" codec:"specialDamageC3"`
	// specialDamageC4
	SpecialDamageC4 tjcsv.Slice `yaml:"specialDamageC4" codec:"specialDamageC4"`
	// specialDamageC5
	SpecialDamageC5 tjcsv.Slice `yaml:"specialDamageC5" codec:"specialDamageC5"`
	// specialDamageC6
	SpecialDamageC6 tjcsv.Slice `yaml:"specialDamageC6" codec:"specialDamageC6"`
	// specialDamageC7
	SpecialDamageC7 tjcsv.Slice `yaml:"specialDamageC7" codec:"specialDamageC7"`
	// specialDamageC8
	SpecialDamageC8 tjcsv.Slice `yaml:"specialDamageC8" codec:"specialDamageC8"`
	// specialDamageC9
	SpecialDamageC9 tjcsv.Slice `yaml:"specialDamageC9" codec:"specialDamageC9"`
	// specialDefenceC1
	SpecialDefenceC1 tjcsv.Slice `yaml:"specialDefenceC1" codec:"specialDefenceC1"`
	// specialDefenceC10
	SpecialDefenceC10 tjcsv.Slice `yaml:"specialDefenceC10" codec:"specialDefenceC10"`
	// specialDefenceC2
	SpecialDefenceC2 tjcsv.Slice `yaml:"specialDefenceC2" codec:"specialDefenceC2"`
	// specialDefenceC3
	SpecialDefenceC3 tjcsv.Slice `yaml:"specialDefenceC3" codec:"specialDefenceC3"`
	// specialDefenceC4
	SpecialDefenceC4 tjcsv.Slice `yaml:"specialDefenceC4" codec:"specialDefenceC4"`
	// specialDefenceC5
	SpecialDefenceC5 tjcsv.Slice `yaml:"specialDefenceC5" codec:"specialDefenceC5"`
	// specialDefenceC6
	SpecialDefenceC6 tjcsv.Slice `yaml:"specialDefenceC6" codec:"specialDefenceC6"`
	// specialDefenceC7
	SpecialDefenceC7 tjcsv.Slice `yaml:"specialDefenceC7" codec:"specialDefenceC7"`
	// specialDefenceC8
	SpecialDefenceC8 tjcsv.Slice `yaml:"specialDefenceC8" codec:"specialDefenceC8"`
	// specialDefenceC9
	SpecialDefenceC9 tjcsv.Slice `yaml:"specialDefenceC9" codec:"specialDefenceC9"`
	// star1
	Star1 tjcsv.Slice `yaml:"star1" codec:"star1"`
	// star10
	Star10 tjcsv.Slice `yaml:"star10" codec:"star10"`
	// star2
	Star2 tjcsv.Slice `yaml:"star2" codec:"star2"`
	// star3
	Star3 tjcsv.Slice `yaml:"star3" codec:"star3"`
	// star4
	Star4 tjcsv.Slice `yaml:"star4" codec:"star4"`
	// star5
	Star5 tjcsv.Slice `yaml:"star5" codec:"star5"`
	// star6
	Star6 tjcsv.Slice `yaml:"star6" codec:"star6"`
	// star7
	Star7 tjcsv.Slice `yaml:"star7" codec:"star7"`
	// star8
	Star8 tjcsv.Slice `yaml:"star8" codec:"star8"`
	// star9
	Star9 tjcsv.Slice `yaml:"star9" codec:"star9"`
}
// craft/robot_level.csv
type Craft_robot_level struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
}
// craft/robot_num.csv
type Craft_robot_num struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// realNum
	RealNum int `yaml:"realNum" codec:"realNum"`
	// totalNum
	TotalNum int `yaml:"totalNum" codec:"totalNum"`
}
// craft/shop.csv
type Craft_shop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// exchangeLimit
	ExchangeLimit int `yaml:"exchangeLimit" codec:"exchangeLimit"`
	// itemMap
	ItemMap tjcsv.Map `yaml:"itemMap" codec:"itemMap"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
	// limitTimes
	LimitTimes int `yaml:"limitTimes" codec:"limitTimes"`
	// limitType
	LimitType int `yaml:"limitType" codec:"limitType"`
	// regainHour
	RegainHour int `yaml:"regainHour" codec:"regainHour"`
	// showUnable
	ShowUnable bool `yaml:"showUnable" codec:"showUnable"`
	// vipStart
	VipStart int `yaml:"vipStart" codec:"vipStart"`
}
// cross
type Cross struct {
	// cross/arena
	Arena *Cross_arena `yaml:"arena" codec:"arena"`
	// cross/chat_service.csv
	Chat_service map[int]*Cross_chat_service `yaml:"chat_service" codec:"chat_service"`
	// cross/craft
	Craft *Cross_craft `yaml:"craft" codec:"craft"`
	// cross/fishing
	Fishing *Cross_fishing `yaml:"fishing" codec:"fishing"`
	// cross/gym
	Gym *Cross_gym `yaml:"gym" codec:"gym"`
	// cross/horse_race
	Horse_race *Cross_horse_race `yaml:"horse_race" codec:"horse_race"`
	// cross/hunting
	Hunting *Cross_hunting `yaml:"hunting" codec:"hunting"`
	// cross/mine
	Mine *Cross_mine `yaml:"mine" codec:"mine"`
	// cross/online_fight
	Online_fight *Cross_online_fight `yaml:"online_fight" codec:"online_fight"`
	// cross/service.csv
	Service map[int]*Cross_service `yaml:"service" codec:"service"`
	// cross/supremacy
	Supremacy *Cross_supremacy `yaml:"supremacy" codec:"supremacy"`
	// cross/union_fight
	Union_fight *Cross_union_fight `yaml:"union_fight" codec:"union_fight"`
	// cross/union_qa
	Union_qa *Cross_union_qa `yaml:"union_qa" codec:"union_qa"`
}
// cross/arena
type Cross_arena struct {
	// cross/arena/base.csv
	Base map[int]*Cross_arena_base `yaml:"base" codec:"base"`
	// cross/arena/cross_arena_battle_fix.csv
	Cross_arena_battle_fix map[int]*Cross_arena_cross_arena_battle_fix `yaml:"cross_arena_battle_fix" codec:"cross_arena_battle_fix"`
	// cross/arena/daily_award.csv
	Daily_award map[int]*Cross_arena_daily_award `yaml:"daily_award" codec:"daily_award"`
	// cross/arena/pw_matching.csv
	Pw_matching map[int]*Cross_arena_pw_matching `yaml:"pw_matching" codec:"pw_matching"`
	// cross/arena/robot.csv
	Robot map[int]*Cross_arena_robot `yaml:"robot" codec:"robot"`
	// cross/arena/robot_fix.csv
	Robot_fix map[int]*Cross_arena_robot_fix `yaml:"robot_fix" codec:"robot_fix"`
	// cross/arena/robot_monster_level.csv
	Robot_monster_level map[int]*Cross_arena_robot_monster_level `yaml:"robot_monster_level" codec:"robot_monster_level"`
	// cross/arena/robot_monsters.csv
	Robot_monsters map[int]*Cross_arena_robot_monsters `yaml:"robot_monsters" codec:"robot_monsters"`
	// cross/arena/shop.csv
	Shop map[int]*Cross_arena_shop `yaml:"shop" codec:"shop"`
	// cross/arena/stage.csv
	Stage map[int]*Cross_arena_stage `yaml:"stage" codec:"stage"`
}
// cross/arena/base.csv
type Cross_arena_base struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// minStageID
	MinStageID int `yaml:"minStageID" codec:"minStageID"`
	// robotName
	RobotName string `yaml:"robotName" codec:"robotName"`
	// servOpenDays
	ServOpenDays int `yaml:"servOpenDays" codec:"servOpenDays"`
	// topBattleHistoryPeriods
	TopBattleHistoryPeriods tjcsv.Slice `yaml:"topBattleHistoryPeriods" codec:"topBattleHistoryPeriods"`
}
// cross/arena/cross_arena_battle_fix.csv
type Cross_arena_cross_arena_battle_fix struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrFix
	AttrFix float64 `yaml:"attrFix" codec:"attrFix"`
	// attrType
	AttrType string `yaml:"attrType" codec:"attrType"`
}
// cross/arena/daily_award.csv
type Cross_arena_daily_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// pwTime
	PwTime int `yaml:"pwTime" codec:"pwTime"`
}
// cross/arena/pw_matching.csv
type Cross_arena_pw_matching struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// enemyRange1
	EnemyRange1 tjcsv.Slice `yaml:"enemyRange1" codec:"enemyRange1"`
	// enemyRange2
	EnemyRange2 tjcsv.Slice `yaml:"enemyRange2" codec:"enemyRange2"`
	// enemyRange3
	EnemyRange3 tjcsv.Slice `yaml:"enemyRange3" codec:"enemyRange3"`
	// enemyRange4
	EnemyRange4 tjcsv.Slice `yaml:"enemyRange4" codec:"enemyRange4"`
	// range
	Range tjcsv.Slice `yaml:"range" codec:"range"`
}
// cross/arena/robot.csv
type Cross_arena_robot struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// daysRange
	DaysRange tjcsv.Slice `yaml:"daysRange" codec:"daysRange"`
	// fightingPoint
	FightingPoint int `yaml:"fightingPoint" codec:"fightingPoint"`
	// level
	Level int `yaml:"level" codec:"level"`
	// num
	Num int `yaml:"num" codec:"num"`
}
// cross/arena/robot_fix.csv
type Cross_arena_robot_fix struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// fightC
	FightC float64 `yaml:"fightC" codec:"fightC"`
	// range
	Range tjcsv.Slice `yaml:"range" codec:"range"`
}
// cross/arena/robot_monster_level.csv
type Cross_arena_robot_monster_level struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// advanceEnd
	AdvanceEnd int `yaml:"advanceEnd" codec:"advanceEnd"`
	// advanceStart
	AdvanceStart int `yaml:"advanceStart" codec:"advanceStart"`
	// damageC
	DamageC float64 `yaml:"damageC" codec:"damageC"`
	// defenceC
	DefenceC float64 `yaml:"defenceC" codec:"defenceC"`
	// fightEnd
	FightEnd int `yaml:"fightEnd" codec:"fightEnd"`
	// fightStart
	FightStart int `yaml:"fightStart" codec:"fightStart"`
	// hpC
	HpC float64 `yaml:"hpC" codec:"hpC"`
	// level
	Level int `yaml:"level" codec:"level"`
	// skillLevel
	SkillLevel int `yaml:"skillLevel" codec:"skillLevel"`
	// specialDamageC
	SpecialDamageC float64 `yaml:"specialDamageC" codec:"specialDamageC"`
	// specialDefenceC
	SpecialDefenceC float64 `yaml:"specialDefenceC" codec:"specialDefenceC"`
	// speedC
	SpeedC int `yaml:"speedC" codec:"speedC"`
	// starEnd
	StarEnd int `yaml:"starEnd" codec:"starEnd"`
	// starStart
	StarStart int `yaml:"starStart" codec:"starStart"`
}
// cross/arena/robot_monsters.csv
type Cross_arena_robot_monsters struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// levelEnd
	LevelEnd int `yaml:"levelEnd" codec:"levelEnd"`
	// levelStart
	LevelStart int `yaml:"levelStart" codec:"levelStart"`
	// monsters1
	Monsters1 tjcsv.Slice `yaml:"monsters1" codec:"monsters1"`
	// monsters2
	Monsters2 tjcsv.Slice `yaml:"monsters2" codec:"monsters2"`
	// rangeFixs
	RangeFixs tjcsv.Slice `yaml:"rangeFixs" codec:"rangeFixs"`
}
// cross/arena/shop.csv
type Cross_arena_shop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// exchangeLimit
	ExchangeLimit int `yaml:"exchangeLimit" codec:"exchangeLimit"`
	// itemMap
	ItemMap tjcsv.Map `yaml:"itemMap" codec:"itemMap"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
	// limitTimes
	LimitTimes int `yaml:"limitTimes" codec:"limitTimes"`
	// limitType
	LimitType int `yaml:"limitType" codec:"limitType"`
	// regainHour
	RegainHour int `yaml:"regainHour" codec:"regainHour"`
	// showUnable
	ShowUnable bool `yaml:"showUnable" codec:"showUnable"`
	// vipStart
	VipStart int `yaml:"vipStart" codec:"vipStart"`
}
// cross/arena/stage.csv
type Cross_arena_stage struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// finishAward
	FinishAward tjcsv.Map `yaml:"finishAward" codec:"finishAward"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// periodAward
	PeriodAward tjcsv.Map `yaml:"periodAward" codec:"periodAward"`
	// range
	Range tjcsv.Slice `yaml:"range" codec:"range"`
	// stageID
	StageID int `yaml:"stageID" codec:"stageID"`
	// stageLevel
	StageLevel string `yaml:"stageLevel" codec:"stageLevel"`
	// stageName
	StageName string `yaml:"stageName" codec:"stageName"`
	// stagePinyin
	StagePinyin string `yaml:"stagePinyin" codec:"stagePinyin"`
	// stageRes
	StageRes interface{} `yaml:"stageRes" codec:"stageRes"`
	// version
	Version int `yaml:"version" codec:"version"`
}
// cross/chat_service.csv
type Cross_chat_service struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// kind
	Kind string `yaml:"kind" codec:"kind"`
	// servers
	Servers tjcsv.Slice `yaml:"servers" codec:"servers"`
}
// cross/craft
type Cross_craft struct {
	// cross/craft/base.csv
	Base map[int]*Cross_craft_base `yaml:"base" codec:"base"`
	// cross/craft/buffs.csv
	Buffs map[int]*Cross_craft_buffs `yaml:"buffs" codec:"buffs"`
	// cross/craft/halo_fix.csv
	Halo_fix map[int]*Cross_craft_halo_fix `yaml:"halo_fix" codec:"halo_fix"`
	// cross/craft/rank.csv
	Rank map[int]*Cross_craft_rank `yaml:"rank" codec:"rank"`
	// cross/craft/robot.csv
	Robot map[int]*Cross_craft_robot `yaml:"robot" codec:"robot"`
	// cross/craft/robot_num.csv
	Robot_num map[int]*Cross_craft_robot_num `yaml:"robot_num" codec:"robot_num"`
	// cross/craft/shop.csv
	Shop map[int]*Cross_craft_shop `yaml:"shop" codec:"shop"`
}
// cross/craft/base.csv
type Cross_craft_base struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// autoSignVIP
	AutoSignVIP int `yaml:"autoSignVIP" codec:"autoSignVIP"`
	// betRateFixCoin
	BetRateFixCoin int `yaml:"betRateFixCoin" codec:"betRateFixCoin"`
	// betRateFixGold
	BetRateFixGold int `yaml:"betRateFixGold" codec:"betRateFixGold"`
	// championBetCoin
	ChampionBetCoin int `yaml:"championBetCoin" codec:"championBetCoin"`
	// championBetGold
	ChampionBetGold int `yaml:"championBetGold" codec:"championBetGold"`
	// damageScoreRatio
	DamageScoreRatio int `yaml:"damageScoreRatio" codec:"damageScoreRatio"`
	// failAward
	FailAward tjcsv.Map `yaml:"failAward" codec:"failAward"`
	// maxBetWinCoin
	MaxBetWinCoin int `yaml:"maxBetWinCoin" codec:"maxBetWinCoin"`
	// maxBetWinGold
	MaxBetWinGold int `yaml:"maxBetWinGold" codec:"maxBetWinGold"`
	// minBetRateCoin
	MinBetRateCoin int `yaml:"minBetRateCoin" codec:"minBetRateCoin"`
	// minBetRateGold
	MinBetRateGold float64 `yaml:"minBetRateGold" codec:"minBetRateGold"`
	// preBetCoin
	PreBetCoin int `yaml:"preBetCoin" codec:"preBetCoin"`
	// preBetExtraAward
	PreBetExtraAward tjcsv.Map `yaml:"preBetExtraAward" codec:"preBetExtraAward"`
	// preBetGold
	PreBetGold int `yaml:"preBetGold" codec:"preBetGold"`
	// servOpenDays
	ServOpenDays int `yaml:"servOpenDays" codec:"servOpenDays"`
	// top4BetCoin
	Top4BetCoin int `yaml:"top4BetCoin" codec:"top4BetCoin"`
	// top4BetExtraAward
	Top4BetExtraAward tjcsv.Map `yaml:"top4BetExtraAward" codec:"top4BetExtraAward"`
	// top4BetGold
	Top4BetGold int `yaml:"top4BetGold" codec:"top4BetGold"`
	// winAward
	WinAward tjcsv.Map `yaml:"winAward" codec:"winAward"`
}
// cross/craft/buffs.csv
type Cross_craft_buffs struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNum
	AttrNum int `yaml:"attrNum" codec:"attrNum"`
	// attrType
	AttrType int `yaml:"attrType" codec:"attrType"`
	// natureTypes
	NatureTypes tjcsv.Slice `yaml:"natureTypes" codec:"natureTypes"`
}
// cross/craft/halo_fix.csv
type Cross_craft_halo_fix struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// damage1
	Damage1 float64 `yaml:"damage1" codec:"damage1"`
	// damage2
	Damage2 float64 `yaml:"damage2" codec:"damage2"`
	// damage3
	Damage3 float64 `yaml:"damage3" codec:"damage3"`
	// damage4
	Damage4 float64 `yaml:"damage4" codec:"damage4"`
	// damage5
	Damage5 float64 `yaml:"damage5" codec:"damage5"`
	// damage6
	Damage6 float64 `yaml:"damage6" codec:"damage6"`
	// damage7
	Damage7 float64 `yaml:"damage7" codec:"damage7"`
	// date
	Date int `yaml:"date" codec:"date"`
	// hp1
	Hp1 float64 `yaml:"hp1" codec:"hp1"`
	// hp2
	Hp2 float64 `yaml:"hp2" codec:"hp2"`
	// hp3
	Hp3 float64 `yaml:"hp3" codec:"hp3"`
	// hp4
	Hp4 float64 `yaml:"hp4" codec:"hp4"`
	// hp5
	Hp5 float64 `yaml:"hp5" codec:"hp5"`
	// hp6
	Hp6 float64 `yaml:"hp6" codec:"hp6"`
	// hp7
	Hp7 float64 `yaml:"hp7" codec:"hp7"`
}
// cross/craft/rank.csv
type Cross_craft_rank struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// rankMax
	RankMax int `yaml:"rankMax" codec:"rankMax"`
	// version
	Version int `yaml:"version" codec:"version"`
}
// cross/craft/robot.csv
type Cross_craft_robot struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// advance1
	Advance1 tjcsv.Slice `yaml:"advance1" codec:"advance1"`
	// advance10
	Advance10 tjcsv.Slice `yaml:"advance10" codec:"advance10"`
	// advance11
	Advance11 tjcsv.Slice `yaml:"advance11" codec:"advance11"`
	// advance12
	Advance12 tjcsv.Slice `yaml:"advance12" codec:"advance12"`
	// advance2
	Advance2 tjcsv.Slice `yaml:"advance2" codec:"advance2"`
	// advance3
	Advance3 tjcsv.Slice `yaml:"advance3" codec:"advance3"`
	// advance4
	Advance4 tjcsv.Slice `yaml:"advance4" codec:"advance4"`
	// advance5
	Advance5 tjcsv.Slice `yaml:"advance5" codec:"advance5"`
	// advance6
	Advance6 tjcsv.Slice `yaml:"advance6" codec:"advance6"`
	// advance7
	Advance7 tjcsv.Slice `yaml:"advance7" codec:"advance7"`
	// advance8
	Advance8 tjcsv.Slice `yaml:"advance8" codec:"advance8"`
	// advance9
	Advance9 tjcsv.Slice `yaml:"advance9" codec:"advance9"`
	// card1
	Card1 int `yaml:"card1" codec:"card1"`
	// card10
	Card10 int `yaml:"card10" codec:"card10"`
	// card11
	Card11 int `yaml:"card11" codec:"card11"`
	// card12
	Card12 int `yaml:"card12" codec:"card12"`
	// card2
	Card2 int `yaml:"card2" codec:"card2"`
	// card3
	Card3 int `yaml:"card3" codec:"card3"`
	// card4
	Card4 int `yaml:"card4" codec:"card4"`
	// card5
	Card5 int `yaml:"card5" codec:"card5"`
	// card6
	Card6 int `yaml:"card6" codec:"card6"`
	// card7
	Card7 int `yaml:"card7" codec:"card7"`
	// card8
	Card8 int `yaml:"card8" codec:"card8"`
	// card9
	Card9 int `yaml:"card9" codec:"card9"`
	// damageC1
	DamageC1 tjcsv.Slice `yaml:"damageC1" codec:"damageC1"`
	// damageC10
	DamageC10 tjcsv.Slice `yaml:"damageC10" codec:"damageC10"`
	// damageC11
	DamageC11 tjcsv.Slice `yaml:"damageC11" codec:"damageC11"`
	// damageC12
	DamageC12 tjcsv.Slice `yaml:"damageC12" codec:"damageC12"`
	// damageC2
	DamageC2 tjcsv.Slice `yaml:"damageC2" codec:"damageC2"`
	// damageC3
	DamageC3 tjcsv.Slice `yaml:"damageC3" codec:"damageC3"`
	// damageC4
	DamageC4 tjcsv.Slice `yaml:"damageC4" codec:"damageC4"`
	// damageC5
	DamageC5 tjcsv.Slice `yaml:"damageC5" codec:"damageC5"`
	// damageC6
	DamageC6 tjcsv.Slice `yaml:"damageC6" codec:"damageC6"`
	// damageC7
	DamageC7 tjcsv.Slice `yaml:"damageC7" codec:"damageC7"`
	// damageC8
	DamageC8 tjcsv.Slice `yaml:"damageC8" codec:"damageC8"`
	// damageC9
	DamageC9 tjcsv.Slice `yaml:"damageC9" codec:"damageC9"`
	// defenceC1
	DefenceC1 tjcsv.Slice `yaml:"defenceC1" codec:"defenceC1"`
	// defenceC10
	DefenceC10 tjcsv.Slice `yaml:"defenceC10" codec:"defenceC10"`
	// defenceC11
	DefenceC11 tjcsv.Slice `yaml:"defenceC11" codec:"defenceC11"`
	// defenceC12
	DefenceC12 tjcsv.Slice `yaml:"defenceC12" codec:"defenceC12"`
	// defenceC2
	DefenceC2 tjcsv.Slice `yaml:"defenceC2" codec:"defenceC2"`
	// defenceC3
	DefenceC3 tjcsv.Slice `yaml:"defenceC3" codec:"defenceC3"`
	// defenceC4
	DefenceC4 tjcsv.Slice `yaml:"defenceC4" codec:"defenceC4"`
	// defenceC5
	DefenceC5 tjcsv.Slice `yaml:"defenceC5" codec:"defenceC5"`
	// defenceC6
	DefenceC6 tjcsv.Slice `yaml:"defenceC6" codec:"defenceC6"`
	// defenceC7
	DefenceC7 tjcsv.Slice `yaml:"defenceC7" codec:"defenceC7"`
	// defenceC8
	DefenceC8 tjcsv.Slice `yaml:"defenceC8" codec:"defenceC8"`
	// defenceC9
	DefenceC9 tjcsv.Slice `yaml:"defenceC9" codec:"defenceC9"`
	// hpC1
	HpC1 tjcsv.Slice `yaml:"hpC1" codec:"hpC1"`
	// hpC10
	HpC10 tjcsv.Slice `yaml:"hpC10" codec:"hpC10"`
	// hpC11
	HpC11 tjcsv.Slice `yaml:"hpC11" codec:"hpC11"`
	// hpC12
	HpC12 tjcsv.Slice `yaml:"hpC12" codec:"hpC12"`
	// hpC2
	HpC2 tjcsv.Slice `yaml:"hpC2" codec:"hpC2"`
	// hpC3
	HpC3 tjcsv.Slice `yaml:"hpC3" codec:"hpC3"`
	// hpC4
	HpC4 tjcsv.Slice `yaml:"hpC4" codec:"hpC4"`
	// hpC5
	HpC5 tjcsv.Slice `yaml:"hpC5" codec:"hpC5"`
	// hpC6
	HpC6 tjcsv.Slice `yaml:"hpC6" codec:"hpC6"`
	// hpC7
	HpC7 tjcsv.Slice `yaml:"hpC7" codec:"hpC7"`
	// hpC8
	HpC8 tjcsv.Slice `yaml:"hpC8" codec:"hpC8"`
	// hpC9
	HpC9 tjcsv.Slice `yaml:"hpC9" codec:"hpC9"`
	// levelC1
	LevelC1 tjcsv.Slice `yaml:"levelC1" codec:"levelC1"`
	// levelC10
	LevelC10 tjcsv.Slice `yaml:"levelC10" codec:"levelC10"`
	// levelC11
	LevelC11 tjcsv.Slice `yaml:"levelC11" codec:"levelC11"`
	// levelC12
	LevelC12 tjcsv.Slice `yaml:"levelC12" codec:"levelC12"`
	// levelC2
	LevelC2 tjcsv.Slice `yaml:"levelC2" codec:"levelC2"`
	// levelC3
	LevelC3 tjcsv.Slice `yaml:"levelC3" codec:"levelC3"`
	// levelC4
	LevelC4 tjcsv.Slice `yaml:"levelC4" codec:"levelC4"`
	// levelC5
	LevelC5 tjcsv.Slice `yaml:"levelC5" codec:"levelC5"`
	// levelC6
	LevelC6 tjcsv.Slice `yaml:"levelC6" codec:"levelC6"`
	// levelC7
	LevelC7 tjcsv.Slice `yaml:"levelC7" codec:"levelC7"`
	// levelC8
	LevelC8 tjcsv.Slice `yaml:"levelC8" codec:"levelC8"`
	// levelC9
	LevelC9 tjcsv.Slice `yaml:"levelC9" codec:"levelC9"`
	// levelMax
	LevelMax int `yaml:"levelMax" codec:"levelMax"`
	// specialDamageC1
	SpecialDamageC1 tjcsv.Slice `yaml:"specialDamageC1" codec:"specialDamageC1"`
	// specialDamageC10
	SpecialDamageC10 tjcsv.Slice `yaml:"specialDamageC10" codec:"specialDamageC10"`
	// specialDamageC11
	SpecialDamageC11 tjcsv.Slice `yaml:"specialDamageC11" codec:"specialDamageC11"`
	// specialDamageC12
	SpecialDamageC12 tjcsv.Slice `yaml:"specialDamageC12" codec:"specialDamageC12"`
	// specialDamageC2
	SpecialDamageC2 tjcsv.Slice `yaml:"specialDamageC2" codec:"specialDamageC2"`
	// specialDamageC3
	SpecialDamageC3 tjcsv.Slice `yaml:"specialDamageC3" codec:"specialDamageC3"`
	// specialDamageC4
	SpecialDamageC4 tjcsv.Slice `yaml:"specialDamageC4" codec:"specialDamageC4"`
	// specialDamageC5
	SpecialDamageC5 tjcsv.Slice `yaml:"specialDamageC5" codec:"specialDamageC5"`
	// specialDamageC6
	SpecialDamageC6 tjcsv.Slice `yaml:"specialDamageC6" codec:"specialDamageC6"`
	// specialDamageC7
	SpecialDamageC7 tjcsv.Slice `yaml:"specialDamageC7" codec:"specialDamageC7"`
	// specialDamageC8
	SpecialDamageC8 tjcsv.Slice `yaml:"specialDamageC8" codec:"specialDamageC8"`
	// specialDamageC9
	SpecialDamageC9 tjcsv.Slice `yaml:"specialDamageC9" codec:"specialDamageC9"`
	// specialDefenceC1
	SpecialDefenceC1 tjcsv.Slice `yaml:"specialDefenceC1" codec:"specialDefenceC1"`
	// specialDefenceC10
	SpecialDefenceC10 tjcsv.Slice `yaml:"specialDefenceC10" codec:"specialDefenceC10"`
	// specialDefenceC11
	SpecialDefenceC11 tjcsv.Slice `yaml:"specialDefenceC11" codec:"specialDefenceC11"`
	// specialDefenceC12
	SpecialDefenceC12 tjcsv.Slice `yaml:"specialDefenceC12" codec:"specialDefenceC12"`
	// specialDefenceC2
	SpecialDefenceC2 tjcsv.Slice `yaml:"specialDefenceC2" codec:"specialDefenceC2"`
	// specialDefenceC3
	SpecialDefenceC3 tjcsv.Slice `yaml:"specialDefenceC3" codec:"specialDefenceC3"`
	// specialDefenceC4
	SpecialDefenceC4 tjcsv.Slice `yaml:"specialDefenceC4" codec:"specialDefenceC4"`
	// specialDefenceC5
	SpecialDefenceC5 tjcsv.Slice `yaml:"specialDefenceC5" codec:"specialDefenceC5"`
	// specialDefenceC6
	SpecialDefenceC6 tjcsv.Slice `yaml:"specialDefenceC6" codec:"specialDefenceC6"`
	// specialDefenceC7
	SpecialDefenceC7 tjcsv.Slice `yaml:"specialDefenceC7" codec:"specialDefenceC7"`
	// specialDefenceC8
	SpecialDefenceC8 tjcsv.Slice `yaml:"specialDefenceC8" codec:"specialDefenceC8"`
	// specialDefenceC9
	SpecialDefenceC9 tjcsv.Slice `yaml:"specialDefenceC9" codec:"specialDefenceC9"`
	// star1
	Star1 tjcsv.Slice `yaml:"star1" codec:"star1"`
	// star10
	Star10 tjcsv.Slice `yaml:"star10" codec:"star10"`
	// star11
	Star11 tjcsv.Slice `yaml:"star11" codec:"star11"`
	// star12
	Star12 tjcsv.Slice `yaml:"star12" codec:"star12"`
	// star2
	Star2 tjcsv.Slice `yaml:"star2" codec:"star2"`
	// star3
	Star3 tjcsv.Slice `yaml:"star3" codec:"star3"`
	// star4
	Star4 tjcsv.Slice `yaml:"star4" codec:"star4"`
	// star5
	Star5 tjcsv.Slice `yaml:"star5" codec:"star5"`
	// star6
	Star6 tjcsv.Slice `yaml:"star6" codec:"star6"`
	// star7
	Star7 tjcsv.Slice `yaml:"star7" codec:"star7"`
	// star8
	Star8 tjcsv.Slice `yaml:"star8" codec:"star8"`
	// star9
	Star9 tjcsv.Slice `yaml:"star9" codec:"star9"`
}
// cross/craft/robot_num.csv
type Cross_craft_robot_num struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// realNum
	RealNum int `yaml:"realNum" codec:"realNum"`
	// totalNum
	TotalNum int `yaml:"totalNum" codec:"totalNum"`
}
// cross/craft/shop.csv
type Cross_craft_shop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// exchangeLimit
	ExchangeLimit int `yaml:"exchangeLimit" codec:"exchangeLimit"`
	// itemMap
	ItemMap tjcsv.Map `yaml:"itemMap" codec:"itemMap"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
	// limitTimes
	LimitTimes int `yaml:"limitTimes" codec:"limitTimes"`
	// limitType
	LimitType int `yaml:"limitType" codec:"limitType"`
	// regainHour
	RegainHour int `yaml:"regainHour" codec:"regainHour"`
	// showUnable
	ShowUnable bool `yaml:"showUnable" codec:"showUnable"`
	// vipStart
	VipStart int `yaml:"vipStart" codec:"vipStart"`
}
// cross/fishing
type Cross_fishing struct {
	// cross/fishing/base.csv
	Base map[int]*Cross_fishing_base `yaml:"base" codec:"base"`
	// cross/fishing/rank.csv
	Rank map[int]*Cross_fishing_rank `yaml:"rank" codec:"rank"`
}
// cross/fishing/base.csv
type Cross_fishing_base struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// groupSize
	GroupSize int `yaml:"groupSize" codec:"groupSize"`
	// servOpenDays
	ServOpenDays int `yaml:"servOpenDays" codec:"servOpenDays"`
	// specialFish
	SpecialFish int `yaml:"specialFish" codec:"specialFish"`
}
// cross/fishing/rank.csv
type Cross_fishing_rank struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// rankMax
	RankMax int `yaml:"rankMax" codec:"rankMax"`
}
// cross/gym
type Cross_gym struct {
	// cross/gym/base.csv
	Base map[int]*Cross_gym_base `yaml:"base" codec:"base"`
}
// cross/gym/base.csv
type Cross_gym_base struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// servOpenDays
	ServOpenDays int `yaml:"servOpenDays" codec:"servOpenDays"`
}
// cross/horse_race
type Cross_horse_race struct {
	// cross/horse_race/base.csv
	Base map[int]*Cross_horse_race_base `yaml:"base" codec:"base"`
	// cross/horse_race/horse_race_card.csv
	Horse_race_card map[int]*Cross_horse_race_horse_race_card `yaml:"horse_race_card" codec:"horse_race_card"`
}
// cross/horse_race/base.csv
type Cross_horse_race_base struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// distance
	Distance float64 `yaml:"distance" codec:"distance"`
	// sMultiple1
	SMultiple1 float64 `yaml:"sMultiple1" codec:"sMultiple1"`
	// sMultiple2
	SMultiple2 float64 `yaml:"sMultiple2" codec:"sMultiple2"`
	// time
	Time tjcsv.Slice `yaml:"time" codec:"time"`
}
// cross/horse_race/horse_race_card.csv
type Cross_horse_race_horse_race_card struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// group
	Group int `yaml:"group" codec:"group"`
	// name
	Name string `yaml:"name" codec:"name"`
	// speed
	Speed int `yaml:"speed" codec:"speed"`
	// sprintInterval
	SprintInterval int `yaml:"sprintInterval" codec:"sprintInterval"`
	// sprintMultiple
	SprintMultiple float64 `yaml:"sprintMultiple" codec:"sprintMultiple"`
	// sprintRandom
	SprintRandom int `yaml:"sprintRandom" codec:"sprintRandom"`
	// sprintTime
	SprintTime int `yaml:"sprintTime" codec:"sprintTime"`
	// stamina
	Stamina float64 `yaml:"stamina" codec:"stamina"`
	// staminaCost
	StaminaCost float64 `yaml:"staminaCost" codec:"staminaCost"`
	// staminaRecovery
	StaminaRecovery float64 `yaml:"staminaRecovery" codec:"staminaRecovery"`
	// unitID
	UnitID int `yaml:"unitID" codec:"unitID"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
}
// cross/hunting
type Cross_hunting struct {
	// cross/hunting/base.csv
	Base map[int]*Cross_hunting_base `yaml:"base" codec:"base"`
	// cross/hunting/battle_cards.csv
	Battle_cards map[int]*Cross_hunting_battle_cards `yaml:"battle_cards" codec:"battle_cards"`
	// cross/hunting/battle_fix.csv
	Battle_fix map[int]*Cross_hunting_battle_fix `yaml:"battle_fix" codec:"battle_fix"`
	// cross/hunting/buffs.csv
	Buffs map[int]*Cross_hunting_buffs `yaml:"buffs" codec:"buffs"`
	// cross/hunting/defence_num.csv
	Defence_num map[int]*Cross_hunting_defence_num `yaml:"defence_num" codec:"defence_num"`
	// cross/hunting/gate.csv
	Gate map[int]*Cross_hunting_gate `yaml:"gate" codec:"gate"`
	// cross/hunting/route.csv
	Route map[int]*Cross_hunting_route `yaml:"route" codec:"route"`
	// cross/hunting/shop.csv
	Shop map[int]*Cross_hunting_shop `yaml:"shop" codec:"shop"`
	// cross/hunting/supply.csv
	Supply map[int]*Cross_hunting_supply `yaml:"supply" codec:"supply"`
}
// cross/hunting/base.csv
type Cross_hunting_base struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// battleLimit
	BattleLimit int `yaml:"battleLimit" codec:"battleLimit"`
	// boxOpenLimit
	BoxOpenLimit int `yaml:"boxOpenLimit" codec:"boxOpenLimit"`
	// heldItemC
	HeldItemC tjcsv.Map `yaml:"heldItemC" codec:"heldItemC"`
	// rarityC
	RarityC tjcsv.Map `yaml:"rarityC" codec:"rarityC"`
	// refreshDay
	RefreshDay int `yaml:"refreshDay" codec:"refreshDay"`
	// version
	Version int `yaml:"version" codec:"version"`
	// zawakeC
	ZawakeC tjcsv.Map `yaml:"zawakeC" codec:"zawakeC"`
}
// cross/hunting/battle_cards.csv
type Cross_hunting_battle_cards struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// deployNum
	DeployNum int `yaml:"deployNum" codec:"deployNum"`
	// fightingPoint
	FightingPoint tjcsv.Slice `yaml:"fightingPoint" codec:"fightingPoint"`
}
// cross/hunting/battle_fix.csv
type Cross_hunting_battle_fix struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrFix1
	AttrFix1 float64 `yaml:"attrFix1" codec:"attrFix1"`
	// attrFix2
	AttrFix2 float64 `yaml:"attrFix2" codec:"attrFix2"`
	// attrFix3
	AttrFix3 float64 `yaml:"attrFix3" codec:"attrFix3"`
	// attrFix4
	AttrFix4 float64 `yaml:"attrFix4" codec:"attrFix4"`
	// attrFix5
	AttrFix5 float64 `yaml:"attrFix5" codec:"attrFix5"`
	// attrFix6
	AttrFix6 float64 `yaml:"attrFix6" codec:"attrFix6"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// attrType3
	AttrType3 int `yaml:"attrType3" codec:"attrType3"`
	// attrType4
	AttrType4 int `yaml:"attrType4" codec:"attrType4"`
	// attrType5
	AttrType5 int `yaml:"attrType5" codec:"attrType5"`
	// attrType6
	AttrType6 int `yaml:"attrType6" codec:"attrType6"`
}
// cross/hunting/buffs.csv
type Cross_hunting_buffs struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// group
	Group int `yaml:"group" codec:"group"`
	// groupWeight
	GroupWeight int `yaml:"groupWeight" codec:"groupWeight"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// name
	Name string `yaml:"name" codec:"name"`
	// quality
	Quality int `yaml:"quality" codec:"quality"`
	// skillID
	SkillID int `yaml:"skillID" codec:"skillID"`
	// type
	Type int `yaml:"type" codec:"type"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
}
// cross/hunting/defence_num.csv
type Cross_hunting_defence_num struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// deployNum
	DeployNum int `yaml:"deployNum" codec:"deployNum"`
	// openDays
	OpenDays tjcsv.Slice `yaml:"openDays" codec:"openDays"`
}
// cross/hunting/gate.csv
type Cross_hunting_gate struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// backGround
	BackGround string `yaml:"backGround" codec:"backGround"`
	// buffType
	BuffType tjcsv.Slice `yaml:"buffType" codec:"buffType"`
	// damageC
	DamageC float64 `yaml:"damageC" codec:"damageC"`
	// defenceC
	DefenceC float64 `yaml:"defenceC" codec:"defenceC"`
	// drops
	Drops tjcsv.Map `yaml:"drops" codec:"drops"`
	// dropsView
	DropsView tjcsv.Map `yaml:"dropsView" codec:"dropsView"`
	// fightingPointC
	FightingPointC float64 `yaml:"fightingPointC" codec:"fightingPointC"`
	// hpC
	HpC float64 `yaml:"hpC" codec:"hpC"`
	// isBuff
	IsBuff int `yaml:"isBuff" codec:"isBuff"`
	// recoverMp
	RecoverMp int `yaml:"recoverMp" codec:"recoverMp"`
	// specialDamageC
	SpecialDamageC float64 `yaml:"specialDamageC" codec:"specialDamageC"`
	// specialDefenceC
	SpecialDefenceC float64 `yaml:"specialDefenceC" codec:"specialDefenceC"`
	// speedC
	SpeedC float64 `yaml:"speedC" codec:"speedC"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// cross/hunting/route.csv
type Cross_hunting_route struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// boxDropLibs
	BoxDropLibs tjcsv.Map `yaml:"boxDropLibs" codec:"boxDropLibs"`
	// boxDropLibs2
	BoxDropLibs2 tjcsv.Map `yaml:"boxDropLibs2" codec:"boxDropLibs2"`
	// gateIDs
	GateIDs tjcsv.Slice `yaml:"gateIDs" codec:"gateIDs"`
	// historyCanPass
	HistoryCanPass int `yaml:"historyCanPass" codec:"historyCanPass"`
	// lastCanPass
	LastCanPass int `yaml:"lastCanPass" codec:"lastCanPass"`
	// routeTag
	RouteTag int `yaml:"routeTag" codec:"routeTag"`
	// supplyGroup
	SupplyGroup int `yaml:"supplyGroup" codec:"supplyGroup"`
	// type
	Type int `yaml:"type" codec:"type"`
	// version
	Version int `yaml:"version" codec:"version"`
}
// cross/hunting/shop.csv
type Cross_hunting_shop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// exchangeLimit
	ExchangeLimit int `yaml:"exchangeLimit" codec:"exchangeLimit"`
	// itemMap
	ItemMap tjcsv.Map `yaml:"itemMap" codec:"itemMap"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
	// limitTimes
	LimitTimes int `yaml:"limitTimes" codec:"limitTimes"`
	// limitType
	LimitType int `yaml:"limitType" codec:"limitType"`
	// regainHour
	RegainHour int `yaml:"regainHour" codec:"regainHour"`
	// showUnable
	ShowUnable bool `yaml:"showUnable" codec:"showUnable"`
	// sortValue
	SortValue int `yaml:"sortValue" codec:"sortValue"`
	// vipStart
	VipStart int `yaml:"vipStart" codec:"vipStart"`
}
// cross/hunting/supply.csv
type Cross_hunting_supply struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// effect
	Effect int `yaml:"effect" codec:"effect"`
	// group
	Group int `yaml:"group" codec:"group"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// name
	Name string `yaml:"name" codec:"name"`
	// quality
	Quality int `yaml:"quality" codec:"quality"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// cross/mine
type Cross_mine struct {
	// cross/mine/base.csv
	Base map[int]*Cross_mine_base `yaml:"base" codec:"base"`
	// cross/mine/boss.csv
	Boss map[int]*Cross_mine_boss `yaml:"boss" codec:"boss"`
	// cross/mine/boss_figure.csv
	Boss_figure map[int]*Cross_mine_boss_figure `yaml:"boss_figure" codec:"boss_figure"`
	// cross/mine/boss_hp_fix.csv
	Boss_hp_fix map[int]*Cross_mine_boss_hp_fix `yaml:"boss_hp_fix" codec:"boss_hp_fix"`
	// cross/mine/boss_rank_award.csv
	Boss_rank_award map[int]*Cross_mine_boss_rank_award `yaml:"boss_rank_award" codec:"boss_rank_award"`
	// cross/mine/buff_add.csv
	Buff_add map[int]*Cross_mine_buff_add `yaml:"buff_add" codec:"buff_add"`
	// cross/mine/buff_feed.csv
	Buff_feed map[int]*Cross_mine_buff_feed `yaml:"buff_feed" codec:"buff_feed"`
	// cross/mine/building.csv
	Building map[int]*Cross_mine_building `yaml:"building" codec:"building"`
	// cross/mine/event_lib.csv
	Event_lib map[int]*Cross_mine_event_lib `yaml:"event_lib" codec:"event_lib"`
	// cross/mine/event_times.csv
	Event_times map[int]*Cross_mine_event_times `yaml:"event_times" codec:"event_times"`
	// cross/mine/match.csv
	Match map[int]*Cross_mine_match `yaml:"match" codec:"match"`
	// cross/mine/npc.csv
	Npc map[int]*Cross_mine_npc `yaml:"npc" codec:"npc"`
	// cross/mine/patrol.csv
	Patrol map[int]*Cross_mine_patrol `yaml:"patrol" codec:"patrol"`
	// cross/mine/rank.csv
	Rank map[int]*Cross_mine_rank `yaml:"rank" codec:"rank"`
	// cross/mine/rob.csv
	Rob map[int]*Cross_mine_rob `yaml:"rob" codec:"rob"`
	// cross/mine/role_award.csv
	Role_award map[int]*Cross_mine_role_award `yaml:"role_award" codec:"role_award"`
	// cross/mine/shop.csv
	Shop map[int]*Cross_mine_shop `yaml:"shop" codec:"shop"`
}
// cross/mine/base.csv
type Cross_mine_base struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beRevengedLimitByRole
	BeRevengedLimitByRole int `yaml:"beRevengedLimitByRole" codec:"beRevengedLimitByRole"`
	// bossFreeTimes
	BossFreeTimes int `yaml:"bossFreeTimes" codec:"bossFreeTimes"`
	// bossMaxTimes
	BossMaxTimes int `yaml:"bossMaxTimes" codec:"bossMaxTimes"`
	// byRobLimit
	ByRobLimit int `yaml:"byRobLimit" codec:"byRobLimit"`
	// extraAward
	ExtraAward tjcsv.Map `yaml:"extraAward" codec:"extraAward"`
	// revengeFreeTimes
	RevengeFreeTimes int `yaml:"revengeFreeTimes" codec:"revengeFreeTimes"`
	// robCorrect
	RobCorrect float64 `yaml:"robCorrect" codec:"robCorrect"`
	// robFreeTimes
	RobFreeTimes int `yaml:"robFreeTimes" codec:"robFreeTimes"`
	// robTimes
	RobTimes int `yaml:"robTimes" codec:"robTimes"`
	// roleAddLevelLimit
	RoleAddLevelLimit int `yaml:"roleAddLevelLimit" codec:"roleAddLevelLimit"`
	// servOpenDays
	ServOpenDays int `yaml:"servOpenDays" codec:"servOpenDays"`
	// serverAddLevelLimit
	ServerAddLevelLimit tjcsv.Slice `yaml:"serverAddLevelLimit" codec:"serverAddLevelLimit"`
	// serverAward1
	ServerAward1 int `yaml:"serverAward1" codec:"serverAward1"`
	// serverAward2
	ServerAward2 int `yaml:"serverAward2" codec:"serverAward2"`
	// serverAward3
	ServerAward3 int `yaml:"serverAward3" codec:"serverAward3"`
	// serverAward4
	ServerAward4 int `yaml:"serverAward4" codec:"serverAward4"`
	// serverAward5
	ServerAward5 int `yaml:"serverAward5" codec:"serverAward5"`
	// serverAward6
	ServerAward6 int `yaml:"serverAward6" codec:"serverAward6"`
	// serverAward7
	ServerAward7 int `yaml:"serverAward7" codec:"serverAward7"`
	// serverAward8
	ServerAward8 int `yaml:"serverAward8" codec:"serverAward8"`
	// serverAward9
	ServerAward9 int `yaml:"serverAward9" codec:"serverAward9"`
	// serverPointRank
	ServerPointRank int `yaml:"serverPointRank" codec:"serverPointRank"`
	// topBattleHistoryPeriods
	TopBattleHistoryPeriods tjcsv.Slice `yaml:"topBattleHistoryPeriods" codec:"topBattleHistoryPeriods"`
	// topBattleLastHP
	TopBattleLastHP float64 `yaml:"topBattleLastHP" codec:"topBattleLastHP"`
	// topBattleRank
	TopBattleRank int `yaml:"topBattleRank" codec:"topBattleRank"`
	// topBattleRound
	TopBattleRound int `yaml:"topBattleRound" codec:"topBattleRound"`
}
// cross/mine/boss.csv
type Cross_mine_boss struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// baseHP
	BaseHP tjcsv.Slice `yaml:"baseHP" codec:"baseHP"`
	// battleAward
	BattleAward tjcsv.Map `yaml:"battleAward" codec:"battleAward"`
	// battleScoreAward
	BattleScoreAward int `yaml:"battleScoreAward" codec:"battleScoreAward"`
	// bossFigure
	BossFigure tjcsv.Slice `yaml:"bossFigure" codec:"bossFigure"`
	// bossID
	BossID tjcsv.Slice `yaml:"bossID" codec:"bossID"`
	// buffAdd
	BuffAdd tjcsv.Map `yaml:"buffAdd" codec:"buffAdd"`
	// buffDesc
	BuffDesc string `yaml:"buffDesc" codec:"buffDesc"`
	// buffIcon
	BuffIcon string `yaml:"buffIcon" codec:"buffIcon"`
	// buffName
	BuffName string `yaml:"buffName" codec:"buffName"`
	// buffTime
	BuffTime int `yaml:"buffTime" codec:"buffTime"`
	// duration
	Duration int `yaml:"duration" codec:"duration"`
	// gateID
	GateID int `yaml:"gateID" codec:"gateID"`
	// killAward
	KillAward tjcsv.Map `yaml:"killAward" codec:"killAward"`
	// rankAwardVersion
	RankAwardVersion int `yaml:"rankAwardVersion" codec:"rankAwardVersion"`
	// serverKillPoint
	ServerKillPoint int `yaml:"serverKillPoint" codec:"serverKillPoint"`
}
// cross/mine/boss_figure.csv
type Cross_mine_boss_figure struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// bossRes
	BossRes string `yaml:"bossRes" codec:"bossRes"`
	// effectName
	EffectName string `yaml:"effectName" codec:"effectName"`
}
// cross/mine/boss_hp_fix.csv
type Cross_mine_boss_hp_fix struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// ServerOpenDays
	ServerOpenDays int `yaml:"ServerOpenDays" codec:"ServerOpenDays"`
	// hpFix
	HpFix int `yaml:"hpFix" codec:"hpFix"`
}
// cross/mine/boss_rank_award.csv
type Cross_mine_boss_rank_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// rank
	Rank int `yaml:"rank" codec:"rank"`
	// score
	Score int `yaml:"score" codec:"score"`
	// version
	Version int `yaml:"version" codec:"version"`
}
// cross/mine/buff_add.csv
type Cross_mine_buff_add struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// roleDamageAdd
	RoleDamageAdd float64 `yaml:"roleDamageAdd" codec:"roleDamageAdd"`
	// roleDefenceAdd
	RoleDefenceAdd float64 `yaml:"roleDefenceAdd" codec:"roleDefenceAdd"`
	// roleExp
	RoleExp int `yaml:"roleExp" codec:"roleExp"`
	// roleHpAdd
	RoleHpAdd float64 `yaml:"roleHpAdd" codec:"roleHpAdd"`
	// serverDamageAdd
	ServerDamageAdd float64 `yaml:"serverDamageAdd" codec:"serverDamageAdd"`
	// serverDefenceAdd
	ServerDefenceAdd float64 `yaml:"serverDefenceAdd" codec:"serverDefenceAdd"`
	// serverExp
	ServerExp int `yaml:"serverExp" codec:"serverExp"`
	// serverExpDayMax
	ServerExpDayMax int `yaml:"serverExpDayMax" codec:"serverExpDayMax"`
	// serverHpAdd
	ServerHpAdd float64 `yaml:"serverHpAdd" codec:"serverHpAdd"`
}
// cross/mine/buff_feed.csv
type Cross_mine_buff_feed struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// costCoin13
	CostCoin13 int `yaml:"costCoin13" codec:"costCoin13"`
	// dayFeedTimesLimit
	DayFeedTimesLimit int `yaml:"dayFeedTimesLimit" codec:"dayFeedTimesLimit"`
	// feedExp
	FeedExp int `yaml:"feedExp" codec:"feedExp"`
	// feedVip
	FeedVip int `yaml:"feedVip" codec:"feedVip"`
	// roleFeedAward
	RoleFeedAward tjcsv.Map `yaml:"roleFeedAward" codec:"roleFeedAward"`
	// serverFeedAward
	ServerFeedAward tjcsv.Map `yaml:"serverFeedAward" codec:"serverFeedAward"`
}
// cross/mine/building.csv
type Cross_mine_building struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// rank
	Rank tjcsv.Slice `yaml:"rank" codec:"rank"`
	// res
	Res tjcsv.Slice `yaml:"res" codec:"res"`
}
// cross/mine/event_lib.csv
type Cross_mine_event_lib struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// eventID
	EventID int `yaml:"eventID" codec:"eventID"`
	// eventLib
	EventLib int `yaml:"eventLib" codec:"eventLib"`
	// eventParam
	EventParam tjcsv.Map `yaml:"eventParam" codec:"eventParam"`
	// eventType
	EventType int `yaml:"eventType" codec:"eventType"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
}
// cross/mine/event_times.csv
type Cross_mine_event_times struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// day
	Day int `yaml:"day" codec:"day"`
	// randLib1
	RandLib1 tjcsv.Map `yaml:"randLib1" codec:"randLib1"`
	// randLib2
	RandLib2 tjcsv.Map `yaml:"randLib2" codec:"randLib2"`
	// time
	Time int `yaml:"time" codec:"time"`
	// weight1
	Weight1 int `yaml:"weight1" codec:"weight1"`
	// weight2
	Weight2 int `yaml:"weight2" codec:"weight2"`
}
// cross/mine/match.csv
type Cross_mine_match struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// enemyRange1
	EnemyRange1 tjcsv.Slice `yaml:"enemyRange1" codec:"enemyRange1"`
	// enemyRange10
	EnemyRange10 tjcsv.Slice `yaml:"enemyRange10" codec:"enemyRange10"`
	// enemyRange2
	EnemyRange2 tjcsv.Slice `yaml:"enemyRange2" codec:"enemyRange2"`
	// enemyRange3
	EnemyRange3 tjcsv.Slice `yaml:"enemyRange3" codec:"enemyRange3"`
	// enemyRange4
	EnemyRange4 tjcsv.Slice `yaml:"enemyRange4" codec:"enemyRange4"`
	// enemyRange5
	EnemyRange5 tjcsv.Slice `yaml:"enemyRange5" codec:"enemyRange5"`
	// enemyRange6
	EnemyRange6 tjcsv.Slice `yaml:"enemyRange6" codec:"enemyRange6"`
	// enemyRange7
	EnemyRange7 tjcsv.Slice `yaml:"enemyRange7" codec:"enemyRange7"`
	// enemyRange8
	EnemyRange8 tjcsv.Slice `yaml:"enemyRange8" codec:"enemyRange8"`
	// enemyRange9
	EnemyRange9 tjcsv.Slice `yaml:"enemyRange9" codec:"enemyRange9"`
	// range
	Range tjcsv.Slice `yaml:"range" codec:"range"`
}
// cross/mine/npc.csv
type Cross_mine_npc struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// dialogLib
	DialogLib int `yaml:"dialogLib" codec:"dialogLib"`
	// duration
	Duration int `yaml:"duration" codec:"duration"`
	// moveIntervalX
	MoveIntervalX tjcsv.Slice `yaml:"moveIntervalX" codec:"moveIntervalX"`
	// moveIntervalY
	MoveIntervalY tjcsv.Slice `yaml:"moveIntervalY" codec:"moveIntervalY"`
	// moveSpeed
	MoveSpeed tjcsv.Slice `yaml:"moveSpeed" codec:"moveSpeed"`
	// res
	Res string `yaml:"res" codec:"res"`
}
// cross/mine/patrol.csv
type Cross_mine_patrol struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// refreshInterval
	RefreshInterval int `yaml:"refreshInterval" codec:"refreshInterval"`
	// refreshNum
	RefreshNum tjcsv.Map `yaml:"refreshNum" codec:"refreshNum"`
}
// cross/mine/rank.csv
type Cross_mine_rank struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// byRobLimit
	ByRobLimit int `yaml:"byRobLimit" codec:"byRobLimit"`
	// minuteCoin13
	MinuteCoin13 float64 `yaml:"minuteCoin13" codec:"minuteCoin13"`
	// point
	Point int `yaml:"point" codec:"point"`
	// rankMax
	RankMax int `yaml:"rankMax" codec:"rankMax"`
	// version
	Version int `yaml:"version" codec:"version"`
}
// cross/mine/rob.csv
type Cross_mine_rob struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// fightDiff
	FightDiff float64 `yaml:"fightDiff" codec:"fightDiff"`
	// robCorrect
	RobCorrect float64 `yaml:"robCorrect" codec:"robCorrect"`
}
// cross/mine/role_award.csv
type Cross_mine_role_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// dayAward
	DayAward tjcsv.Map `yaml:"dayAward" codec:"dayAward"`
	// endAward
	EndAward tjcsv.Map `yaml:"endAward" codec:"endAward"`
	// rankMax
	RankMax int `yaml:"rankMax" codec:"rankMax"`
	// version
	Version int `yaml:"version" codec:"version"`
}
// cross/mine/shop.csv
type Cross_mine_shop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// exchangeLimit
	ExchangeLimit int `yaml:"exchangeLimit" codec:"exchangeLimit"`
	// itemMap
	ItemMap tjcsv.Map `yaml:"itemMap" codec:"itemMap"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
	// limitTimes
	LimitTimes int `yaml:"limitTimes" codec:"limitTimes"`
	// limitType
	LimitType int `yaml:"limitType" codec:"limitType"`
	// regainHour
	RegainHour int `yaml:"regainHour" codec:"regainHour"`
	// showUnable
	ShowUnable bool `yaml:"showUnable" codec:"showUnable"`
	// sortValue
	SortValue int `yaml:"sortValue" codec:"sortValue"`
	// vipStart
	VipStart int `yaml:"vipStart" codec:"vipStart"`
}
// cross/online_fight
type Cross_online_fight struct {
	// cross/online_fight/banpick.csv
	Banpick map[int]*Cross_online_fight_banpick `yaml:"banpick" codec:"banpick"`
	// cross/online_fight/base.csv
	Base map[int]*Cross_online_fight_base `yaml:"base" codec:"base"`
	// cross/online_fight/cards.csv
	Cards map[int]*Cross_online_fight_cards `yaml:"cards" codec:"cards"`
	// cross/online_fight/expand_servers.csv
	Expand_servers map[int]*Cross_online_fight_expand_servers `yaml:"expand_servers" codec:"expand_servers"`
	// cross/online_fight/final_award.csv
	Final_award map[int]*Cross_online_fight_final_award `yaml:"final_award" codec:"final_award"`
	// cross/online_fight/match.csv
	Match map[int]*Cross_online_fight_match `yaml:"match" codec:"match"`
	// cross/online_fight/newbie_protect.csv
	Newbie_protect map[int]*Cross_online_fight_newbie_protect `yaml:"newbie_protect" codec:"newbie_protect"`
	// cross/online_fight/shop.csv
	Shop map[int]*Cross_online_fight_shop `yaml:"shop" codec:"shop"`
	// cross/online_fight/talent.csv
	Talent map[int]*Cross_online_fight_talent `yaml:"talent" codec:"talent"`
	// cross/online_fight/team.csv
	Team map[int]*Cross_online_fight_team `yaml:"team" codec:"team"`
	// cross/online_fight/theme.csv
	Theme map[int]*Cross_online_fight_theme `yaml:"theme" codec:"theme"`
	// cross/online_fight/theme_open.csv
	Theme_open map[int]*Cross_online_fight_theme_open `yaml:"theme_open" codec:"theme_open"`
	// cross/online_fight/weekly_award.csv
	Weekly_award map[int]*Cross_online_fight_weekly_award `yaml:"weekly_award" codec:"weekly_award"`
	// cross/online_fight/weekly_target.csv
	Weekly_target map[int]*Cross_online_fight_weekly_target `yaml:"weekly_target" codec:"weekly_target"`
}
// cross/online_fight/banpick.csv
type Cross_online_fight_banpick struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// banCount
	BanCount int `yaml:"banCount" codec:"banCount"`
	// countdown
	Countdown int `yaml:"countdown" codec:"countdown"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// pickCount
	PickCount int `yaml:"pickCount" codec:"pickCount"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// cross/online_fight/base.csv
type Cross_online_fight_base struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// awardTime
	AwardTime int `yaml:"awardTime" codec:"awardTime"`
	// battleFailAward
	BattleFailAward tjcsv.Map `yaml:"battleFailAward" codec:"battleFailAward"`
	// battleWinAward
	BattleWinAward tjcsv.Map `yaml:"battleWinAward" codec:"battleWinAward"`
	// expandLimitedOpen
	ExpandLimitedOpen bool `yaml:"expandLimitedOpen" codec:"expandLimitedOpen"`
	// expandLimitedOpenScore
	ExpandLimitedOpenScore int `yaml:"expandLimitedOpenScore" codec:"expandLimitedOpenScore"`
	// expandUnlimitedOpen
	ExpandUnlimitedOpen bool `yaml:"expandUnlimitedOpen" codec:"expandUnlimitedOpen"`
	// expandUnlimitedOpenScore
	ExpandUnlimitedOpenScore int `yaml:"expandUnlimitedOpenScore" codec:"expandUnlimitedOpenScore"`
	// failStreakCount
	FailStreakCount int `yaml:"failStreakCount" codec:"failStreakCount"`
	// leastCardNum
	LeastCardNum int `yaml:"leastCardNum" codec:"leastCardNum"`
	// limitedBanScore
	LimitedBanScore int `yaml:"limitedBanScore" codec:"limitedBanScore"`
	// limitedTopBattleRank
	LimitedTopBattleRank int `yaml:"limitedTopBattleRank" codec:"limitedTopBattleRank"`
	// longMatchTimeout
	LongMatchTimeout int `yaml:"longMatchTimeout" codec:"longMatchTimeout"`
	// matchTime
	MatchTime int `yaml:"matchTime" codec:"matchTime"`
	// matchTimeMax
	MatchTimeMax int `yaml:"matchTimeMax" codec:"matchTimeMax"`
	// mostCardNum
	MostCardNum int `yaml:"mostCardNum" codec:"mostCardNum"`
	// normalMatchTimeout
	NormalMatchTimeout int `yaml:"normalMatchTimeout" codec:"normalMatchTimeout"`
	// openTime
	OpenTime tjcsv.Slice `yaml:"openTime" codec:"openTime"`
	// openWeekday
	OpenWeekday tjcsv.Slice `yaml:"openWeekday" codec:"openWeekday"`
	// servOpenDays
	ServOpenDays int `yaml:"servOpenDays" codec:"servOpenDays"`
	// topBattleHistoryPeriods
	TopBattleHistoryPeriods tjcsv.Slice `yaml:"topBattleHistoryPeriods" codec:"topBattleHistoryPeriods"`
	// unlimitedTopBattleRank
	UnlimitedTopBattleRank int `yaml:"unlimitedTopBattleRank" codec:"unlimitedTopBattleRank"`
	// weeklyAwardLeastTimes
	WeeklyAwardLeastTimes int `yaml:"weeklyAwardLeastTimes" codec:"weeklyAwardLeastTimes"`
	// weeklyTarget
	WeeklyTarget int `yaml:"weeklyTarget" codec:"weeklyTarget"`
	// winStreakCount
	WinStreakCount int `yaml:"winStreakCount" codec:"winStreakCount"`
}
// cross/online_fight/cards.csv
type Cross_online_fight_cards struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// abilities
	Abilities tjcsv.Map `yaml:"abilities" codec:"abilities"`
	// advance
	Advance int `yaml:"advance" codec:"advance"`
	// blockLevel
	BlockLevel interface{} `yaml:"blockLevel" codec:"blockLevel"`
	// blockPower
	BlockPower interface{} `yaml:"blockPower" codec:"blockPower"`
	// breakBlockLevel
	BreakBlockLevel interface{} `yaml:"breakBlockLevel" codec:"breakBlockLevel"`
	// cardId
	CardId int `yaml:"cardId" codec:"cardId"`
	// damage
	Damage float64 `yaml:"damage" codec:"damage"`
	// damageAdd
	DamageAdd interface{} `yaml:"damageAdd" codec:"damageAdd"`
	// damageSub
	DamageSub interface{} `yaml:"damageSub" codec:"damageSub"`
	// defence
	Defence float64 `yaml:"defence" codec:"defence"`
	// equipAdvance
	EquipAdvance int `yaml:"equipAdvance" codec:"equipAdvance"`
	// equipAwake
	EquipAwake int `yaml:"equipAwake" codec:"equipAwake"`
	// equipLevel
	EquipLevel int `yaml:"equipLevel" codec:"equipLevel"`
	// equipStar
	EquipStar int `yaml:"equipStar" codec:"equipStar"`
	// fetters
	Fetters bool `yaml:"fetters" codec:"fetters"`
	// hp
	Hp float64 `yaml:"hp" codec:"hp"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// level
	Level int `yaml:"level" codec:"level"`
	// mainSkillAdd
	MainSkillAdd interface{} `yaml:"mainSkillAdd" codec:"mainSkillAdd"`
	// mainSkillSub
	MainSkillSub interface{} `yaml:"mainSkillSub" codec:"mainSkillSub"`
	// nvalue
	Nvalue tjcsv.Map `yaml:"nvalue" codec:"nvalue"`
	// skillLevels
	SkillLevels tjcsv.Slice `yaml:"skillLevels" codec:"skillLevels"`
	// specialDamage
	SpecialDamage float64 `yaml:"specialDamage" codec:"specialDamage"`
	// specialDefence
	SpecialDefence float64 `yaml:"specialDefence" codec:"specialDefence"`
	// speedRate
	SpeedRate int `yaml:"speedRate" codec:"speedRate"`
	// star
	Star int `yaml:"star" codec:"star"`
	// strikeDamage
	StrikeDamage interface{} `yaml:"strikeDamage" codec:"strikeDamage"`
	// strikeLevel
	StrikeLevel interface{} `yaml:"strikeLevel" codec:"strikeLevel"`
	// strikeResistance
	StrikeResistance interface{} `yaml:"strikeResistance" codec:"strikeResistance"`
}
// cross/online_fight/expand_servers.csv
type Cross_online_fight_expand_servers struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// cross
	Cross string `yaml:"cross" codec:"cross"`
	// servers
	Servers tjcsv.Slice `yaml:"servers" codec:"servers"`
}
// cross/online_fight/final_award.csv
type Cross_online_fight_final_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// rankMax
	RankMax int `yaml:"rankMax" codec:"rankMax"`
	// version
	Version int `yaml:"version" codec:"version"`
}
// cross/online_fight/match.csv
type Cross_online_fight_match struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// extendHighRange
	ExtendHighRange tjcsv.Slice `yaml:"extendHighRange" codec:"extendHighRange"`
	// extendLowRange
	ExtendLowRange tjcsv.Slice `yaml:"extendLowRange" codec:"extendLowRange"`
	// extendNormalRange
	ExtendNormalRange tjcsv.Slice `yaml:"extendNormalRange" codec:"extendNormalRange"`
	// priorityHighRange
	PriorityHighRange tjcsv.Slice `yaml:"priorityHighRange" codec:"priorityHighRange"`
	// priorityLowRange
	PriorityLowRange tjcsv.Slice `yaml:"priorityLowRange" codec:"priorityLowRange"`
	// priorityNormalRange
	PriorityNormalRange tjcsv.Slice `yaml:"priorityNormalRange" codec:"priorityNormalRange"`
	// range
	Range tjcsv.Slice `yaml:"range" codec:"range"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// cross/online_fight/newbie_protect.csv
type Cross_online_fight_newbie_protect struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// limitedNewbieFailN
	LimitedNewbieFailN float64 `yaml:"limitedNewbieFailN" codec:"limitedNewbieFailN"`
	// limitedNewbieFailT
	LimitedNewbieFailT float64 `yaml:"limitedNewbieFailT" codec:"limitedNewbieFailT"`
	// limitedNewbieWinN
	LimitedNewbieWinN float64 `yaml:"limitedNewbieWinN" codec:"limitedNewbieWinN"`
	// limitedNewbieWinT
	LimitedNewbieWinT float64 `yaml:"limitedNewbieWinT" codec:"limitedNewbieWinT"`
	// limitedRepeatMatchFailFix
	LimitedRepeatMatchFailFix tjcsv.Slice `yaml:"limitedRepeatMatchFailFix" codec:"limitedRepeatMatchFailFix"`
	// limitedRepeatMatchWinFix
	LimitedRepeatMatchWinFix tjcsv.Slice `yaml:"limitedRepeatMatchWinFix" codec:"limitedRepeatMatchWinFix"`
	// range
	Range tjcsv.Slice `yaml:"range" codec:"range"`
	// unlimitedNewbieFailN
	UnlimitedNewbieFailN float64 `yaml:"unlimitedNewbieFailN" codec:"unlimitedNewbieFailN"`
	// unlimitedNewbieFailT
	UnlimitedNewbieFailT float64 `yaml:"unlimitedNewbieFailT" codec:"unlimitedNewbieFailT"`
	// unlimitedNewbieWinN
	UnlimitedNewbieWinN float64 `yaml:"unlimitedNewbieWinN" codec:"unlimitedNewbieWinN"`
	// unlimitedNewbieWinT
	UnlimitedNewbieWinT float64 `yaml:"unlimitedNewbieWinT" codec:"unlimitedNewbieWinT"`
	// unlimitedRepeatMatchFailFix
	UnlimitedRepeatMatchFailFix tjcsv.Slice `yaml:"unlimitedRepeatMatchFailFix" codec:"unlimitedRepeatMatchFailFix"`
	// unlimitedRepeatMatchWinFix
	UnlimitedRepeatMatchWinFix tjcsv.Slice `yaml:"unlimitedRepeatMatchWinFix" codec:"unlimitedRepeatMatchWinFix"`
}
// cross/online_fight/shop.csv
type Cross_online_fight_shop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// exchangeLimit
	ExchangeLimit int `yaml:"exchangeLimit" codec:"exchangeLimit"`
	// itemMap
	ItemMap tjcsv.Map `yaml:"itemMap" codec:"itemMap"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
	// limitTimes
	LimitTimes int `yaml:"limitTimes" codec:"limitTimes"`
	// limitType
	LimitType int `yaml:"limitType" codec:"limitType"`
	// regainHour
	RegainHour int `yaml:"regainHour" codec:"regainHour"`
	// showUnable
	ShowUnable bool `yaml:"showUnable" codec:"showUnable"`
	// topScore
	TopScore int `yaml:"topScore" codec:"topScore"`
	// vipStart
	VipStart int `yaml:"vipStart" codec:"vipStart"`
}
// cross/online_fight/talent.csv
type Cross_online_fight_talent struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// addType
	AddType int `yaml:"addType" codec:"addType"`
	// attrNum
	AttrNum float64 `yaml:"attrNum" codec:"attrNum"`
	// attrType
	AttrType int `yaml:"attrType" codec:"attrType"`
	// natureType
	NatureType int `yaml:"natureType" codec:"natureType"`
}
// cross/online_fight/team.csv
type Cross_online_fight_team struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// csvID
	CsvID int `yaml:"csvID" codec:"csvID"`
	// level
	Level int `yaml:"level" codec:"level"`
	// system
	System string `yaml:"system" codec:"system"`
}
// cross/online_fight/theme.csv
type Cross_online_fight_theme struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// rarityLimit
	RarityLimit tjcsv.Map `yaml:"rarityLimit" codec:"rarityLimit"`
	// skills
	Skills tjcsv.Map `yaml:"skills" codec:"skills"`
}
// cross/online_fight/theme_open.csv
type Cross_online_fight_theme_open struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// day
	Day int `yaml:"day" codec:"day"`
	// invalidMarkIDs
	InvalidMarkIDs tjcsv.Slice `yaml:"invalidMarkIDs" codec:"invalidMarkIDs"`
	// invalidMegaCardIDs
	InvalidMegaCardIDs tjcsv.Slice `yaml:"invalidMegaCardIDs" codec:"invalidMegaCardIDs"`
	// theme
	Theme int `yaml:"theme" codec:"theme"`
}
// cross/online_fight/weekly_award.csv
type Cross_online_fight_weekly_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// score
	Score tjcsv.Slice `yaml:"score" codec:"score"`
	// version
	Version int `yaml:"version" codec:"version"`
}
// cross/online_fight/weekly_target.csv
type Cross_online_fight_weekly_target struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// count
	Count int `yaml:"count" codec:"count"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// cross/service.csv
type Cross_service struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// cross
	Cross string `yaml:"cross" codec:"cross"`
	// date
	Date int `yaml:"date" codec:"date"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// servers
	Servers tjcsv.Slice `yaml:"servers" codec:"servers"`
	// service
	Service string `yaml:"service" codec:"service"`
	// version
	Version int `yaml:"version" codec:"version"`
}
// cross/supremacy
type Cross_supremacy struct {
	// cross/supremacy/barrage.csv
	Barrage map[int]*Cross_supremacy_barrage `yaml:"barrage" codec:"barrage"`
	// cross/supremacy/base.csv
	Base map[int]*Cross_supremacy_base `yaml:"base" codec:"base"`
	// cross/supremacy/division.csv
	Division map[int]*Cross_supremacy_division `yaml:"division" codec:"division"`
	// cross/supremacy/elite.csv
	Elite map[int]*Cross_supremacy_elite `yaml:"elite" codec:"elite"`
	// cross/supremacy/grade.csv
	Grade map[int]*Cross_supremacy_grade `yaml:"grade" codec:"grade"`
	// cross/supremacy/match.csv
	Match map[int]*Cross_supremacy_match `yaml:"match" codec:"match"`
	// cross/supremacy/rank.csv
	Rank map[int]*Cross_supremacy_rank `yaml:"rank" codec:"rank"`
	// cross/supremacy/robot_level.csv
	Robot_level map[int]*Cross_supremacy_robot_level `yaml:"robot_level" codec:"robot_level"`
	// cross/supremacy/robots.csv
	Robots map[int]*Cross_supremacy_robots `yaml:"robots" codec:"robots"`
	// cross/supremacy/shop.csv
	Shop map[int]*Cross_supremacy_shop `yaml:"shop" codec:"shop"`
	// cross/supremacy/week_award.csv
	Week_award map[int]*Cross_supremacy_week_award `yaml:"week_award" codec:"week_award"`
}
// cross/supremacy/barrage.csv
type Cross_supremacy_barrage struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// text
	Text string `yaml:"text" codec:"text"`
}
// cross/supremacy/base.csv
type Cross_supremacy_base struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// deductWeight
	DeductWeight int `yaml:"deductWeight" codec:"deductWeight"`
	// formulaValidBeginGrade
	FormulaValidBeginGrade int `yaml:"formulaValidBeginGrade" codec:"formulaValidBeginGrade"`
	// initWeight
	InitWeight int `yaml:"initWeight" codec:"initWeight"`
	// matchTime
	MatchTime int `yaml:"matchTime" codec:"matchTime"`
	// openWholeMatchBeginGrade
	OpenWholeMatchBeginGrade int `yaml:"openWholeMatchBeginGrade" codec:"openWholeMatchBeginGrade"`
	// robotNumInGrade
	RobotNumInGrade int `yaml:"robotNumInGrade" codec:"robotNumInGrade"`
	// servOpenDays
	ServOpenDays int `yaml:"servOpenDays" codec:"servOpenDays"`
	// topBattleHistoryPeriods
	TopBattleHistoryPeriods tjcsv.Slice `yaml:"topBattleHistoryPeriods" codec:"topBattleHistoryPeriods"`
	// topBattleLastHP
	TopBattleLastHP float64 `yaml:"topBattleLastHP" codec:"topBattleLastHP"`
	// topBattleRank
	TopBattleRank int `yaml:"topBattleRank" codec:"topBattleRank"`
	// topBattleRound
	TopBattleRound int `yaml:"topBattleRound" codec:"topBattleRound"`
	// winStreakCount
	WinStreakCount int `yaml:"winStreakCount" codec:"winStreakCount"`
	// winStreakGradeLimit
	WinStreakGradeLimit int `yaml:"winStreakGradeLimit" codec:"winStreakGradeLimit"`
	// winStreakScoreAward
	WinStreakScoreAward int `yaml:"winStreakScoreAward" codec:"winStreakScoreAward"`
}
// cross/supremacy/division.csv
type Cross_supremacy_division struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// division
	Division int `yaml:"division" codec:"division"`
	// servers
	Servers tjcsv.Slice `yaml:"servers" codec:"servers"`
	// serviceCSVID
	ServiceCSVID int `yaml:"serviceCSVID" codec:"serviceCSVID"`
}
// cross/supremacy/elite.csv
type Cross_supremacy_elite struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// day
	Day int `yaml:"day" codec:"day"`
	// invalidMarkIDs
	InvalidMarkIDs tjcsv.Slice `yaml:"invalidMarkIDs" codec:"invalidMarkIDs"`
	// invalidMegaCardIDs
	InvalidMegaCardIDs tjcsv.Slice `yaml:"invalidMegaCardIDs" codec:"invalidMegaCardIDs"`
}
// cross/supremacy/grade.csv
type Cross_supremacy_grade struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// battleFailAward
	BattleFailAward tjcsv.Map `yaml:"battleFailAward" codec:"battleFailAward"`
	// battleFailScoreRatio
	BattleFailScoreRatio float64 `yaml:"battleFailScoreRatio" codec:"battleFailScoreRatio"`
	// battleWinAward
	BattleWinAward tjcsv.Map `yaml:"battleWinAward" codec:"battleWinAward"`
	// battleWinScore
	BattleWinScore int `yaml:"battleWinScore" codec:"battleWinScore"`
	// battleWinScoreRatio
	BattleWinScoreRatio float64 `yaml:"battleWinScoreRatio" codec:"battleWinScoreRatio"`
	// failAddScore
	FailAddScore int `yaml:"failAddScore" codec:"failAddScore"`
	// growResLimit
	GrowResLimit tjcsv.Map `yaml:"growResLimit" codec:"growResLimit"`
	// minuteRes
	MinuteRes tjcsv.Map `yaml:"minuteRes" codec:"minuteRes"`
	// nextSeasonGrade
	NextSeasonGrade int `yaml:"nextSeasonGrade" codec:"nextSeasonGrade"`
	// openRobot
	OpenRobot int `yaml:"openRobot" codec:"openRobot"`
	// score
	Score int `yaml:"score" codec:"score"`
	// seasonAward
	SeasonAward tjcsv.Map `yaml:"seasonAward" codec:"seasonAward"`
}
// cross/supremacy/match.csv
type Cross_supremacy_match struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// matchRange1
	MatchRange1 tjcsv.Slice `yaml:"matchRange1" codec:"matchRange1"`
	// matchRange2
	MatchRange2 tjcsv.Slice `yaml:"matchRange2" codec:"matchRange2"`
	// matchRange3
	MatchRange3 tjcsv.Slice `yaml:"matchRange3" codec:"matchRange3"`
	// range
	Range tjcsv.Slice `yaml:"range" codec:"range"`
}
// cross/supremacy/rank.csv
type Cross_supremacy_rank struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// flag
	Flag int `yaml:"flag" codec:"flag"`
	// range
	Range int `yaml:"range" codec:"range"`
	// version
	Version int `yaml:"version" codec:"version"`
}
// cross/supremacy/robot_level.csv
type Cross_supremacy_robot_level struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attackDamageC
	AttackDamageC int `yaml:"attackDamageC" codec:"attackDamageC"`
	// defenceC
	DefenceC int `yaml:"defenceC" codec:"defenceC"`
	// hpC
	HpC int `yaml:"hpC" codec:"hpC"`
	// level
	Level int `yaml:"level" codec:"level"`
}
// cross/supremacy/robots.csv
type Cross_supremacy_robots struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// eliteCards
	EliteCards tjcsv.Slice `yaml:"eliteCards" codec:"eliteCards"`
	// grade
	Grade int `yaml:"grade" codec:"grade"`
	// monsterIDs1
	MonsterIDs1 tjcsv.Slice `yaml:"monsterIDs1" codec:"monsterIDs1"`
	// monsterIDs2
	MonsterIDs2 tjcsv.Slice `yaml:"monsterIDs2" codec:"monsterIDs2"`
	// monsterIDs3
	MonsterIDs3 tjcsv.Slice `yaml:"monsterIDs3" codec:"monsterIDs3"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
}
// cross/supremacy/shop.csv
type Cross_supremacy_shop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// exchangeLimit
	ExchangeLimit int `yaml:"exchangeLimit" codec:"exchangeLimit"`
	// itemMap
	ItemMap tjcsv.Map `yaml:"itemMap" codec:"itemMap"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
	// limitTimes
	LimitTimes int `yaml:"limitTimes" codec:"limitTimes"`
	// limitType
	LimitType int `yaml:"limitType" codec:"limitType"`
	// regainHour
	RegainHour int `yaml:"regainHour" codec:"regainHour"`
	// showUnable
	ShowUnable bool `yaml:"showUnable" codec:"showUnable"`
	// sortValue
	SortValue int `yaml:"sortValue" codec:"sortValue"`
	// vipStart
	VipStart int `yaml:"vipStart" codec:"vipStart"`
}
// cross/supremacy/week_award.csv
type Cross_supremacy_week_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// fightTimes
	FightTimes int `yaml:"fightTimes" codec:"fightTimes"`
	// weekAward
	WeekAward tjcsv.Map `yaml:"weekAward" codec:"weekAward"`
}
// cross/union_fight
type Cross_union_fight struct {
	// cross/union_fight/base.csv
	Base map[int]*Cross_union_fight_base `yaml:"base" codec:"base"`
	// cross/union_fight/battle_fix.csv
	Battle_fix map[int]*Cross_union_fight_battle_fix `yaml:"battle_fix" codec:"battle_fix"`
	// cross/union_fight/play_point.csv
	Play_point map[int]*Cross_union_fight_play_point `yaml:"play_point" codec:"play_point"`
	// cross/union_fight/rank_award.csv
	Rank_award map[int]*Cross_union_fight_rank_award `yaml:"rank_award" codec:"rank_award"`
}
// cross/union_fight/base.csv
type Cross_union_fight_base struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrCorrectMap
	AttrCorrectMap tjcsv.Slice `yaml:"attrCorrectMap" codec:"attrCorrectMap"`
	// extraAward
	ExtraAward tjcsv.Map `yaml:"extraAward" codec:"extraAward"`
	// preBetCost
	PreBetCost tjcsv.Map `yaml:"preBetCost" codec:"preBetCost"`
	// preBetFailAward
	PreBetFailAward tjcsv.Map `yaml:"preBetFailAward" codec:"preBetFailAward"`
	// preBetWinAward
	PreBetWinAward tjcsv.Map `yaml:"preBetWinAward" codec:"preBetWinAward"`
	// roleLevel
	RoleLevel int `yaml:"roleLevel" codec:"roleLevel"`
	// roundLimit
	RoundLimit tjcsv.Slice `yaml:"roundLimit" codec:"roundLimit"`
	// sceneCount
	SceneCount tjcsv.Slice `yaml:"sceneCount" codec:"sceneCount"`
	// servOpenDays
	ServOpenDays int `yaml:"servOpenDays" codec:"servOpenDays"`
	// top4BetCost
	Top4BetCost tjcsv.Map `yaml:"top4BetCost" codec:"top4BetCost"`
	// top4BetFailAward
	Top4BetFailAward tjcsv.Map `yaml:"top4BetFailAward" codec:"top4BetFailAward"`
	// top4BetWinAward
	Top4BetWinAward tjcsv.Map `yaml:"top4BetWinAward" codec:"top4BetWinAward"`
	// unionLevel
	UnionLevel int `yaml:"unionLevel" codec:"unionLevel"`
}
// cross/union_fight/battle_fix.csv
type Cross_union_fight_battle_fix struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// battleTimes
	BattleTimes int `yaml:"battleTimes" codec:"battleTimes"`
	// cure
	Cure float64 `yaml:"cure" codec:"cure"`
	// damage
	Damage float64 `yaml:"damage" codec:"damage"`
	// defence
	Defence float64 `yaml:"defence" codec:"defence"`
	// hpMax
	HpMax float64 `yaml:"hpMax" codec:"hpMax"`
	// mp1Recover
	Mp1Recover float64 `yaml:"mp1Recover" codec:"mp1Recover"`
	// specialDamage
	SpecialDamage float64 `yaml:"specialDamage" codec:"specialDamage"`
	// specialDefence
	SpecialDefence float64 `yaml:"specialDefence" codec:"specialDefence"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// cross/union_fight/play_point.csv
type Cross_union_fight_play_point struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// extraPoint
	ExtraPoint int `yaml:"extraPoint" codec:"extraPoint"`
	// failPoint
	FailPoint int `yaml:"failPoint" codec:"failPoint"`
	// limit
	Limit int `yaml:"limit" codec:"limit"`
	// winPoint
	WinPoint int `yaml:"winPoint" codec:"winPoint"`
}
// cross/union_fight/rank_award.csv
type Cross_union_fight_rank_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// rank
	Rank int `yaml:"rank" codec:"rank"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// cross/union_qa
type Cross_union_qa struct {
	// cross/union_qa/base.csv
	Base map[int]*Cross_union_qa_base `yaml:"base" codec:"base"`
	// cross/union_qa/role_rank.csv
	Role_rank map[int]*Cross_union_qa_role_rank `yaml:"role_rank" codec:"role_rank"`
	// cross/union_qa/union_rank.csv
	Union_rank map[int]*Cross_union_qa_union_rank `yaml:"union_rank" codec:"union_rank"`
}
// cross/union_qa/base.csv
type Cross_union_qa_base struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// groupSize
	GroupSize int `yaml:"groupSize" codec:"groupSize"`
	// servOpenDays
	ServOpenDays int `yaml:"servOpenDays" codec:"servOpenDays"`
}
// cross/union_qa/role_rank.csv
type Cross_union_qa_role_rank struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// rankMax
	RankMax int `yaml:"rankMax" codec:"rankMax"`
	// version
	Version int `yaml:"version" codec:"version"`
}
// cross/union_qa/union_rank.csv
type Cross_union_qa_union_rank struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// rankMax
	RankMax int `yaml:"rankMax" codec:"rankMax"`
	// version
	Version int `yaml:"version" codec:"version"`
}
// daily_assistant.csv
type Daily_assistant struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// features
	Features string `yaml:"features" codec:"features"`
	// inUnlock
	InUnlock int `yaml:"inUnlock" codec:"inUnlock"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// name
	Name string `yaml:"name" codec:"name"`
	// sortID
	SortID int `yaml:"sortID" codec:"sortID"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// dispatch_task
type Dispatch_task struct {
	// dispatch_task/fighting_point.csv
	Fighting_point map[int]*Dispatch_task_fighting_point `yaml:"fighting_point" codec:"fighting_point"`
	// dispatch_task/rankdom.csv
	Rankdom map[int]*Dispatch_task_rankdom `yaml:"rankdom" codec:"rankdom"`
	// dispatch_task/tasks.csv
	Tasks map[int]*Dispatch_task_tasks `yaml:"tasks" codec:"tasks"`
}
// dispatch_task/fighting_point.csv
type Dispatch_task_fighting_point struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// fightingPoint
	FightingPoint int `yaml:"fightingPoint" codec:"fightingPoint"`
}
// dispatch_task/rankdom.csv
type Dispatch_task_rankdom struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
	// weights
	Weights tjcsv.Map `yaml:"weights" codec:"weights"`
}
// dispatch_task/tasks.csv
type Dispatch_task_tasks struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// cardNatureRate
	CardNatureRate int `yaml:"cardNatureRate" codec:"cardNatureRate"`
	// cardNatures
	CardNatures tjcsv.Slice `yaml:"cardNatures" codec:"cardNatures"`
	// cardNums
	CardNums int `yaml:"cardNums" codec:"cardNums"`
	// condition1
	Condition1 int `yaml:"condition1" codec:"condition1"`
	// condition1Arg
	Condition1Arg tjcsv.Map `yaml:"condition1Arg" codec:"condition1Arg"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// duration
	Duration int `yaml:"duration" codec:"duration"`
	// extraAward
	ExtraAward tjcsv.Map `yaml:"extraAward" codec:"extraAward"`
	// fightinPoints
	FightinPoints tjcsv.Slice `yaml:"fightinPoints" codec:"fightinPoints"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
	// name
	Name string `yaml:"name" codec:"name"`
	// quality
	Quality int `yaml:"quality" codec:"quality"`
	// rate1
	Rate1 int `yaml:"rate1" codec:"rate1"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
}
// draw_card.csv
type Draw_card struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// drawTriggerTimes
	DrawTriggerTimes int `yaml:"drawTriggerTimes" codec:"drawTriggerTimes"`
	// drawTriggerType
	DrawTriggerType int `yaml:"drawTriggerType" codec:"drawTriggerType"`
	// drawType
	DrawType string `yaml:"drawType" codec:"drawType"`
	// effectLimit
	EffectLimit int `yaml:"effectLimit" codec:"effectLimit"`
	// lotteryType1
	LotteryType1 tjcsv.Map `yaml:"lotteryType1" codec:"lotteryType1"`
	// lotteryType10
	LotteryType10 tjcsv.Map `yaml:"lotteryType10" codec:"lotteryType10"`
	// lotteryType2
	LotteryType2 tjcsv.Map `yaml:"lotteryType2" codec:"lotteryType2"`
	// lotteryType3
	LotteryType3 tjcsv.Map `yaml:"lotteryType3" codec:"lotteryType3"`
	// lotteryType4
	LotteryType4 tjcsv.Map `yaml:"lotteryType4" codec:"lotteryType4"`
	// lotteryType5
	LotteryType5 tjcsv.Map `yaml:"lotteryType5" codec:"lotteryType5"`
	// lotteryType6
	LotteryType6 tjcsv.Map `yaml:"lotteryType6" codec:"lotteryType6"`
	// lotteryType7
	LotteryType7 tjcsv.Map `yaml:"lotteryType7" codec:"lotteryType7"`
	// lotteryType8
	LotteryType8 tjcsv.Map `yaml:"lotteryType8" codec:"lotteryType8"`
	// lotteryType9
	LotteryType9 tjcsv.Map `yaml:"lotteryType9" codec:"lotteryType9"`
	// lotteryWeight1
	LotteryWeight1 int `yaml:"lotteryWeight1" codec:"lotteryWeight1"`
	// lotteryWeight10
	LotteryWeight10 int `yaml:"lotteryWeight10" codec:"lotteryWeight10"`
	// lotteryWeight2
	LotteryWeight2 int `yaml:"lotteryWeight2" codec:"lotteryWeight2"`
	// lotteryWeight3
	LotteryWeight3 int `yaml:"lotteryWeight3" codec:"lotteryWeight3"`
	// lotteryWeight4
	LotteryWeight4 int `yaml:"lotteryWeight4" codec:"lotteryWeight4"`
	// lotteryWeight5
	LotteryWeight5 int `yaml:"lotteryWeight5" codec:"lotteryWeight5"`
	// lotteryWeight6
	LotteryWeight6 int `yaml:"lotteryWeight6" codec:"lotteryWeight6"`
	// lotteryWeight7
	LotteryWeight7 int `yaml:"lotteryWeight7" codec:"lotteryWeight7"`
	// lotteryWeight8
	LotteryWeight8 int `yaml:"lotteryWeight8" codec:"lotteryWeight8"`
	// lotteryWeight9
	LotteryWeight9 int `yaml:"lotteryWeight9" codec:"lotteryWeight9"`
	// probEffectInterval
	ProbEffectInterval int `yaml:"probEffectInterval" codec:"probEffectInterval"`
	// probInit
	ProbInit float64 `yaml:"probInit" codec:"probInit"`
	// probLimit
	ProbLimit float64 `yaml:"probLimit" codec:"probLimit"`
	// probMiniTimes
	ProbMiniTimes int `yaml:"probMiniTimes" codec:"probMiniTimes"`
	// probStep
	ProbStep float64 `yaml:"probStep" codec:"probStep"`
	// startCount
	StartCount int `yaml:"startCount" codec:"startCount"`
	// weightEnd
	WeightEnd int `yaml:"weightEnd" codec:"weightEnd"`
	// weightStart
	WeightStart int `yaml:"weightStart" codec:"weightStart"`
}
// draw_card_up_group.csv
type Draw_card_up_group struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrs
	Attrs tjcsv.Slice `yaml:"attrs" codec:"attrs"`
	// cards
	Cards tjcsv.Slice `yaml:"cards" codec:"cards"`
	// name
	Name string `yaml:"name" codec:"name"`
	// priviewId
	PriviewId int `yaml:"priviewId" codec:"priviewId"`
}
// draw_chip.csv
type Draw_chip struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// drawTriggerTimes
	DrawTriggerTimes int `yaml:"drawTriggerTimes" codec:"drawTriggerTimes"`
	// drawTriggerType
	DrawTriggerType int `yaml:"drawTriggerType" codec:"drawTriggerType"`
	// drawType
	DrawType string `yaml:"drawType" codec:"drawType"`
	// effectLimit
	EffectLimit int `yaml:"effectLimit" codec:"effectLimit"`
	// lotteryType1
	LotteryType1 tjcsv.Map `yaml:"lotteryType1" codec:"lotteryType1"`
	// lotteryType10
	LotteryType10 tjcsv.Map `yaml:"lotteryType10" codec:"lotteryType10"`
	// lotteryType2
	LotteryType2 tjcsv.Map `yaml:"lotteryType2" codec:"lotteryType2"`
	// lotteryType3
	LotteryType3 tjcsv.Map `yaml:"lotteryType3" codec:"lotteryType3"`
	// lotteryType4
	LotteryType4 tjcsv.Map `yaml:"lotteryType4" codec:"lotteryType4"`
	// lotteryType5
	LotteryType5 tjcsv.Map `yaml:"lotteryType5" codec:"lotteryType5"`
	// lotteryType6
	LotteryType6 tjcsv.Map `yaml:"lotteryType6" codec:"lotteryType6"`
	// lotteryType7
	LotteryType7 tjcsv.Map `yaml:"lotteryType7" codec:"lotteryType7"`
	// lotteryType8
	LotteryType8 tjcsv.Map `yaml:"lotteryType8" codec:"lotteryType8"`
	// lotteryType9
	LotteryType9 tjcsv.Map `yaml:"lotteryType9" codec:"lotteryType9"`
	// lotteryWeight1
	LotteryWeight1 int `yaml:"lotteryWeight1" codec:"lotteryWeight1"`
	// lotteryWeight10
	LotteryWeight10 int `yaml:"lotteryWeight10" codec:"lotteryWeight10"`
	// lotteryWeight2
	LotteryWeight2 int `yaml:"lotteryWeight2" codec:"lotteryWeight2"`
	// lotteryWeight3
	LotteryWeight3 int `yaml:"lotteryWeight3" codec:"lotteryWeight3"`
	// lotteryWeight4
	LotteryWeight4 int `yaml:"lotteryWeight4" codec:"lotteryWeight4"`
	// lotteryWeight5
	LotteryWeight5 int `yaml:"lotteryWeight5" codec:"lotteryWeight5"`
	// lotteryWeight6
	LotteryWeight6 int `yaml:"lotteryWeight6" codec:"lotteryWeight6"`
	// lotteryWeight7
	LotteryWeight7 int `yaml:"lotteryWeight7" codec:"lotteryWeight7"`
	// lotteryWeight8
	LotteryWeight8 int `yaml:"lotteryWeight8" codec:"lotteryWeight8"`
	// lotteryWeight9
	LotteryWeight9 int `yaml:"lotteryWeight9" codec:"lotteryWeight9"`
	// probEffectInterval
	ProbEffectInterval int `yaml:"probEffectInterval" codec:"probEffectInterval"`
	// probInit
	ProbInit int `yaml:"probInit" codec:"probInit"`
	// probLimit
	ProbLimit float64 `yaml:"probLimit" codec:"probLimit"`
	// probMiniTimes
	ProbMiniTimes int `yaml:"probMiniTimes" codec:"probMiniTimes"`
	// probStep
	ProbStep float64 `yaml:"probStep" codec:"probStep"`
	// startCount
	StartCount int `yaml:"startCount" codec:"startCount"`
	// weightEnd
	WeightEnd float64 `yaml:"weightEnd" codec:"weightEnd"`
	// weightStart
	WeightStart float64 `yaml:"weightStart" codec:"weightStart"`
}
// draw_chip_dynamic.csv
type Draw_chip_dynamic struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// drawTriggerTimes
	DrawTriggerTimes int `yaml:"drawTriggerTimes" codec:"drawTriggerTimes"`
	// drawTriggerType
	DrawTriggerType int `yaml:"drawTriggerType" codec:"drawTriggerType"`
	// effectLimit
	EffectLimit int `yaml:"effectLimit" codec:"effectLimit"`
	// libID
	LibID int `yaml:"libID" codec:"libID"`
	// probEffectInterval
	ProbEffectInterval int `yaml:"probEffectInterval" codec:"probEffectInterval"`
	// probInit
	ProbInit int `yaml:"probInit" codec:"probInit"`
	// probLimit
	ProbLimit float64 `yaml:"probLimit" codec:"probLimit"`
	// probMiniTimes
	ProbMiniTimes int `yaml:"probMiniTimes" codec:"probMiniTimes"`
	// probStep
	ProbStep float64 `yaml:"probStep" codec:"probStep"`
	// selected
	Selected float64 `yaml:"selected" codec:"selected"`
	// startCount
	StartCount int `yaml:"startCount" codec:"startCount"`
	// unselected
	Unselected int `yaml:"unselected" codec:"unselected"`
	// weightEnd
	WeightEnd float64 `yaml:"weightEnd" codec:"weightEnd"`
	// weightStart
	WeightStart float64 `yaml:"weightStart" codec:"weightStart"`
}
// draw_count.csv
type Draw_count struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// count
	Count int `yaml:"count" codec:"count"`
	// drawType
	DrawType int `yaml:"drawType" codec:"drawType"`
}
// draw_equip.csv
type Draw_equip struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// drawTriggerTimes
	DrawTriggerTimes int `yaml:"drawTriggerTimes" codec:"drawTriggerTimes"`
	// drawTriggerType
	DrawTriggerType int `yaml:"drawTriggerType" codec:"drawTriggerType"`
	// drawType
	DrawType string `yaml:"drawType" codec:"drawType"`
	// effectLimit
	EffectLimit int `yaml:"effectLimit" codec:"effectLimit"`
	// lotteryType1
	LotteryType1 tjcsv.Map `yaml:"lotteryType1" codec:"lotteryType1"`
	// lotteryType10
	LotteryType10 tjcsv.Map `yaml:"lotteryType10" codec:"lotteryType10"`
	// lotteryType2
	LotteryType2 tjcsv.Map `yaml:"lotteryType2" codec:"lotteryType2"`
	// lotteryType3
	LotteryType3 tjcsv.Map `yaml:"lotteryType3" codec:"lotteryType3"`
	// lotteryType4
	LotteryType4 tjcsv.Map `yaml:"lotteryType4" codec:"lotteryType4"`
	// lotteryType5
	LotteryType5 tjcsv.Map `yaml:"lotteryType5" codec:"lotteryType5"`
	// lotteryType6
	LotteryType6 tjcsv.Map `yaml:"lotteryType6" codec:"lotteryType6"`
	// lotteryType7
	LotteryType7 tjcsv.Map `yaml:"lotteryType7" codec:"lotteryType7"`
	// lotteryType8
	LotteryType8 tjcsv.Map `yaml:"lotteryType8" codec:"lotteryType8"`
	// lotteryType9
	LotteryType9 tjcsv.Map `yaml:"lotteryType9" codec:"lotteryType9"`
	// lotteryWeight1
	LotteryWeight1 int `yaml:"lotteryWeight1" codec:"lotteryWeight1"`
	// lotteryWeight10
	LotteryWeight10 int `yaml:"lotteryWeight10" codec:"lotteryWeight10"`
	// lotteryWeight2
	LotteryWeight2 int `yaml:"lotteryWeight2" codec:"lotteryWeight2"`
	// lotteryWeight3
	LotteryWeight3 int `yaml:"lotteryWeight3" codec:"lotteryWeight3"`
	// lotteryWeight4
	LotteryWeight4 int `yaml:"lotteryWeight4" codec:"lotteryWeight4"`
	// lotteryWeight5
	LotteryWeight5 int `yaml:"lotteryWeight5" codec:"lotteryWeight5"`
	// lotteryWeight6
	LotteryWeight6 int `yaml:"lotteryWeight6" codec:"lotteryWeight6"`
	// lotteryWeight7
	LotteryWeight7 int `yaml:"lotteryWeight7" codec:"lotteryWeight7"`
	// lotteryWeight8
	LotteryWeight8 int `yaml:"lotteryWeight8" codec:"lotteryWeight8"`
	// lotteryWeight9
	LotteryWeight9 int `yaml:"lotteryWeight9" codec:"lotteryWeight9"`
	// probEffectInterval
	ProbEffectInterval int `yaml:"probEffectInterval" codec:"probEffectInterval"`
	// probInit
	ProbInit float64 `yaml:"probInit" codec:"probInit"`
	// probLimit
	ProbLimit float64 `yaml:"probLimit" codec:"probLimit"`
	// probMiniTimes
	ProbMiniTimes int `yaml:"probMiniTimes" codec:"probMiniTimes"`
	// probStep
	ProbStep float64 `yaml:"probStep" codec:"probStep"`
	// startCount
	StartCount int `yaml:"startCount" codec:"startCount"`
	// weightEnd
	WeightEnd float64 `yaml:"weightEnd" codec:"weightEnd"`
	// weightStart
	WeightStart float64 `yaml:"weightStart" codec:"weightStart"`
}
// draw_gem.csv
type Draw_gem struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// drawTriggerTimes
	DrawTriggerTimes int `yaml:"drawTriggerTimes" codec:"drawTriggerTimes"`
	// drawTriggerType
	DrawTriggerType int `yaml:"drawTriggerType" codec:"drawTriggerType"`
	// drawType
	DrawType string `yaml:"drawType" codec:"drawType"`
	// effectLimit
	EffectLimit int `yaml:"effectLimit" codec:"effectLimit"`
	// lotteryType1
	LotteryType1 tjcsv.Map `yaml:"lotteryType1" codec:"lotteryType1"`
	// lotteryType10
	LotteryType10 tjcsv.Map `yaml:"lotteryType10" codec:"lotteryType10"`
	// lotteryType2
	LotteryType2 tjcsv.Map `yaml:"lotteryType2" codec:"lotteryType2"`
	// lotteryType3
	LotteryType3 tjcsv.Map `yaml:"lotteryType3" codec:"lotteryType3"`
	// lotteryType4
	LotteryType4 tjcsv.Map `yaml:"lotteryType4" codec:"lotteryType4"`
	// lotteryType5
	LotteryType5 tjcsv.Map `yaml:"lotteryType5" codec:"lotteryType5"`
	// lotteryType6
	LotteryType6 tjcsv.Map `yaml:"lotteryType6" codec:"lotteryType6"`
	// lotteryType7
	LotteryType7 tjcsv.Map `yaml:"lotteryType7" codec:"lotteryType7"`
	// lotteryType8
	LotteryType8 tjcsv.Map `yaml:"lotteryType8" codec:"lotteryType8"`
	// lotteryType9
	LotteryType9 tjcsv.Map `yaml:"lotteryType9" codec:"lotteryType9"`
	// lotteryWeight1
	LotteryWeight1 int `yaml:"lotteryWeight1" codec:"lotteryWeight1"`
	// lotteryWeight10
	LotteryWeight10 int `yaml:"lotteryWeight10" codec:"lotteryWeight10"`
	// lotteryWeight2
	LotteryWeight2 int `yaml:"lotteryWeight2" codec:"lotteryWeight2"`
	// lotteryWeight3
	LotteryWeight3 int `yaml:"lotteryWeight3" codec:"lotteryWeight3"`
	// lotteryWeight4
	LotteryWeight4 int `yaml:"lotteryWeight4" codec:"lotteryWeight4"`
	// lotteryWeight5
	LotteryWeight5 int `yaml:"lotteryWeight5" codec:"lotteryWeight5"`
	// lotteryWeight6
	LotteryWeight6 int `yaml:"lotteryWeight6" codec:"lotteryWeight6"`
	// lotteryWeight7
	LotteryWeight7 int `yaml:"lotteryWeight7" codec:"lotteryWeight7"`
	// lotteryWeight8
	LotteryWeight8 int `yaml:"lotteryWeight8" codec:"lotteryWeight8"`
	// lotteryWeight9
	LotteryWeight9 int `yaml:"lotteryWeight9" codec:"lotteryWeight9"`
	// probEffectInterval
	ProbEffectInterval int `yaml:"probEffectInterval" codec:"probEffectInterval"`
	// probInit
	ProbInit int `yaml:"probInit" codec:"probInit"`
	// probLimit
	ProbLimit float64 `yaml:"probLimit" codec:"probLimit"`
	// probMiniTimes
	ProbMiniTimes int `yaml:"probMiniTimes" codec:"probMiniTimes"`
	// probStep
	ProbStep float64 `yaml:"probStep" codec:"probStep"`
	// startCount
	StartCount int `yaml:"startCount" codec:"startCount"`
	// weightEnd
	WeightEnd float64 `yaml:"weightEnd" codec:"weightEnd"`
	// weightStart
	WeightStart float64 `yaml:"weightStart" codec:"weightStart"`
}
// draw_item.csv
type Draw_item struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// drawTriggerTimes
	DrawTriggerTimes int `yaml:"drawTriggerTimes" codec:"drawTriggerTimes"`
	// drawTriggerType
	DrawTriggerType int `yaml:"drawTriggerType" codec:"drawTriggerType"`
	// drawType
	DrawType string `yaml:"drawType" codec:"drawType"`
	// effectLimit
	EffectLimit int `yaml:"effectLimit" codec:"effectLimit"`
	// lotteryType1
	LotteryType1 tjcsv.Map `yaml:"lotteryType1" codec:"lotteryType1"`
	// lotteryType10
	LotteryType10 tjcsv.Map `yaml:"lotteryType10" codec:"lotteryType10"`
	// lotteryType2
	LotteryType2 tjcsv.Map `yaml:"lotteryType2" codec:"lotteryType2"`
	// lotteryType3
	LotteryType3 tjcsv.Map `yaml:"lotteryType3" codec:"lotteryType3"`
	// lotteryType4
	LotteryType4 tjcsv.Map `yaml:"lotteryType4" codec:"lotteryType4"`
	// lotteryType5
	LotteryType5 tjcsv.Map `yaml:"lotteryType5" codec:"lotteryType5"`
	// lotteryType6
	LotteryType6 tjcsv.Map `yaml:"lotteryType6" codec:"lotteryType6"`
	// lotteryType7
	LotteryType7 tjcsv.Map `yaml:"lotteryType7" codec:"lotteryType7"`
	// lotteryType8
	LotteryType8 tjcsv.Map `yaml:"lotteryType8" codec:"lotteryType8"`
	// lotteryType9
	LotteryType9 tjcsv.Map `yaml:"lotteryType9" codec:"lotteryType9"`
	// lotteryWeight1
	LotteryWeight1 int `yaml:"lotteryWeight1" codec:"lotteryWeight1"`
	// lotteryWeight10
	LotteryWeight10 int `yaml:"lotteryWeight10" codec:"lotteryWeight10"`
	// lotteryWeight2
	LotteryWeight2 int `yaml:"lotteryWeight2" codec:"lotteryWeight2"`
	// lotteryWeight3
	LotteryWeight3 int `yaml:"lotteryWeight3" codec:"lotteryWeight3"`
	// lotteryWeight4
	LotteryWeight4 int `yaml:"lotteryWeight4" codec:"lotteryWeight4"`
	// lotteryWeight5
	LotteryWeight5 int `yaml:"lotteryWeight5" codec:"lotteryWeight5"`
	// lotteryWeight6
	LotteryWeight6 int `yaml:"lotteryWeight6" codec:"lotteryWeight6"`
	// lotteryWeight7
	LotteryWeight7 int `yaml:"lotteryWeight7" codec:"lotteryWeight7"`
	// lotteryWeight8
	LotteryWeight8 int `yaml:"lotteryWeight8" codec:"lotteryWeight8"`
	// lotteryWeight9
	LotteryWeight9 int `yaml:"lotteryWeight9" codec:"lotteryWeight9"`
	// probEffectInterval
	ProbEffectInterval int `yaml:"probEffectInterval" codec:"probEffectInterval"`
	// probInit
	ProbInit int `yaml:"probInit" codec:"probInit"`
	// probLimit
	ProbLimit float64 `yaml:"probLimit" codec:"probLimit"`
	// probMiniTimes
	ProbMiniTimes int `yaml:"probMiniTimes" codec:"probMiniTimes"`
	// probStep
	ProbStep float64 `yaml:"probStep" codec:"probStep"`
	// startCount
	StartCount int `yaml:"startCount" codec:"startCount"`
	// weightEnd
	WeightEnd int `yaml:"weightEnd" codec:"weightEnd"`
	// weightStart
	WeightStart int `yaml:"weightStart" codec:"weightStart"`
}
// draw_items_lib.csv
type Draw_items_lib struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// cardWeightMap
	CardWeightMap tjcsv.Slice `yaml:"cardWeightMap" codec:"cardWeightMap"`
	// specialWeightMap
	SpecialWeightMap tjcsv.Map `yaml:"specialWeightMap" codec:"specialWeightMap"`
	// weightList
	WeightList tjcsv.Slice `yaml:"weightList" codec:"weightList"`
}
// draw_metal.csv
type Draw_metal struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// drawTriggerTimes
	DrawTriggerTimes int `yaml:"drawTriggerTimes" codec:"drawTriggerTimes"`
	// drawTriggerType
	DrawTriggerType int `yaml:"drawTriggerType" codec:"drawTriggerType"`
	// drawType
	DrawType string `yaml:"drawType" codec:"drawType"`
	// effectLimit
	EffectLimit int `yaml:"effectLimit" codec:"effectLimit"`
	// lotteryType1
	LotteryType1 tjcsv.Map `yaml:"lotteryType1" codec:"lotteryType1"`
	// lotteryType10
	LotteryType10 tjcsv.Map `yaml:"lotteryType10" codec:"lotteryType10"`
	// lotteryType2
	LotteryType2 tjcsv.Map `yaml:"lotteryType2" codec:"lotteryType2"`
	// lotteryType3
	LotteryType3 tjcsv.Map `yaml:"lotteryType3" codec:"lotteryType3"`
	// lotteryType4
	LotteryType4 tjcsv.Map `yaml:"lotteryType4" codec:"lotteryType4"`
	// lotteryType5
	LotteryType5 tjcsv.Map `yaml:"lotteryType5" codec:"lotteryType5"`
	// lotteryType6
	LotteryType6 tjcsv.Map `yaml:"lotteryType6" codec:"lotteryType6"`
	// lotteryType7
	LotteryType7 tjcsv.Map `yaml:"lotteryType7" codec:"lotteryType7"`
	// lotteryType8
	LotteryType8 tjcsv.Map `yaml:"lotteryType8" codec:"lotteryType8"`
	// lotteryType9
	LotteryType9 tjcsv.Map `yaml:"lotteryType9" codec:"lotteryType9"`
	// lotteryWeight1
	LotteryWeight1 int `yaml:"lotteryWeight1" codec:"lotteryWeight1"`
	// lotteryWeight10
	LotteryWeight10 int `yaml:"lotteryWeight10" codec:"lotteryWeight10"`
	// lotteryWeight2
	LotteryWeight2 int `yaml:"lotteryWeight2" codec:"lotteryWeight2"`
	// lotteryWeight3
	LotteryWeight3 int `yaml:"lotteryWeight3" codec:"lotteryWeight3"`
	// lotteryWeight4
	LotteryWeight4 int `yaml:"lotteryWeight4" codec:"lotteryWeight4"`
	// lotteryWeight5
	LotteryWeight5 int `yaml:"lotteryWeight5" codec:"lotteryWeight5"`
	// lotteryWeight6
	LotteryWeight6 int `yaml:"lotteryWeight6" codec:"lotteryWeight6"`
	// lotteryWeight7
	LotteryWeight7 int `yaml:"lotteryWeight7" codec:"lotteryWeight7"`
	// lotteryWeight8
	LotteryWeight8 int `yaml:"lotteryWeight8" codec:"lotteryWeight8"`
	// lotteryWeight9
	LotteryWeight9 int `yaml:"lotteryWeight9" codec:"lotteryWeight9"`
	// startCount
	StartCount int `yaml:"startCount" codec:"startCount"`
	// weightEnd
	WeightEnd float64 `yaml:"weightEnd" codec:"weightEnd"`
	// weightStart
	WeightStart float64 `yaml:"weightStart" codec:"weightStart"`
}
// draw_totem.csv
type Draw_totem struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// drawTriggerTimes
	DrawTriggerTimes int `yaml:"drawTriggerTimes" codec:"drawTriggerTimes"`
	// drawTriggerType
	DrawTriggerType int `yaml:"drawTriggerType" codec:"drawTriggerType"`
	// drawType
	DrawType string `yaml:"drawType" codec:"drawType"`
	// effectLimit
	EffectLimit int `yaml:"effectLimit" codec:"effectLimit"`
	// lotteryType1
	LotteryType1 tjcsv.Map `yaml:"lotteryType1" codec:"lotteryType1"`
	// lotteryType10
	LotteryType10 tjcsv.Map `yaml:"lotteryType10" codec:"lotteryType10"`
	// lotteryType2
	LotteryType2 tjcsv.Map `yaml:"lotteryType2" codec:"lotteryType2"`
	// lotteryType3
	LotteryType3 tjcsv.Map `yaml:"lotteryType3" codec:"lotteryType3"`
	// lotteryType4
	LotteryType4 tjcsv.Map `yaml:"lotteryType4" codec:"lotteryType4"`
	// lotteryType5
	LotteryType5 tjcsv.Map `yaml:"lotteryType5" codec:"lotteryType5"`
	// lotteryType6
	LotteryType6 tjcsv.Map `yaml:"lotteryType6" codec:"lotteryType6"`
	// lotteryType7
	LotteryType7 tjcsv.Map `yaml:"lotteryType7" codec:"lotteryType7"`
	// lotteryType8
	LotteryType8 tjcsv.Map `yaml:"lotteryType8" codec:"lotteryType8"`
	// lotteryType9
	LotteryType9 tjcsv.Map `yaml:"lotteryType9" codec:"lotteryType9"`
	// lotteryWeight1
	LotteryWeight1 int `yaml:"lotteryWeight1" codec:"lotteryWeight1"`
	// lotteryWeight10
	LotteryWeight10 int `yaml:"lotteryWeight10" codec:"lotteryWeight10"`
	// lotteryWeight2
	LotteryWeight2 int `yaml:"lotteryWeight2" codec:"lotteryWeight2"`
	// lotteryWeight3
	LotteryWeight3 int `yaml:"lotteryWeight3" codec:"lotteryWeight3"`
	// lotteryWeight4
	LotteryWeight4 int `yaml:"lotteryWeight4" codec:"lotteryWeight4"`
	// lotteryWeight5
	LotteryWeight5 int `yaml:"lotteryWeight5" codec:"lotteryWeight5"`
	// lotteryWeight6
	LotteryWeight6 int `yaml:"lotteryWeight6" codec:"lotteryWeight6"`
	// lotteryWeight7
	LotteryWeight7 int `yaml:"lotteryWeight7" codec:"lotteryWeight7"`
	// lotteryWeight8
	LotteryWeight8 int `yaml:"lotteryWeight8" codec:"lotteryWeight8"`
	// lotteryWeight9
	LotteryWeight9 int `yaml:"lotteryWeight9" codec:"lotteryWeight9"`
	// probEffectInterval
	ProbEffectInterval int `yaml:"probEffectInterval" codec:"probEffectInterval"`
	// probInit
	ProbInit int `yaml:"probInit" codec:"probInit"`
	// probLimit
	ProbLimit float64 `yaml:"probLimit" codec:"probLimit"`
	// probMiniTimes
	ProbMiniTimes int `yaml:"probMiniTimes" codec:"probMiniTimes"`
	// probStep
	ProbStep float64 `yaml:"probStep" codec:"probStep"`
	// startCount
	StartCount int `yaml:"startCount" codec:"startCount"`
	// weightEnd
	WeightEnd int `yaml:"weightEnd" codec:"weightEnd"`
	// weightStart
	WeightStart int `yaml:"weightStart" codec:"weightStart"`
}
// effect_option.csv
type Effect_option struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// resPath
	ResPath string `yaml:"resPath" codec:"resPath"`
	// tintBlack
	TintBlack bool `yaml:"tintBlack" codec:"tintBlack"`
}
// effect_power.csv
type Effect_power struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// killAddMp1
	KillAddMp1 int `yaml:"killAddMp1" codec:"killAddMp1"`
	// passiveSkill
	PassiveSkill tjcsv.Map `yaml:"passiveSkill" codec:"passiveSkill"`
	// triggerPoint
	TriggerPoint tjcsv.Map `yaml:"triggerPoint" codec:"triggerPoint"`
}
// endless_tower_scene.csv
type Endless_tower_scene struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// backGround
	BackGround string `yaml:"backGround" codec:"backGround"`
	// backMusic
	BackMusic string `yaml:"backMusic" codec:"backMusic"`
	// boss
	Boss tjcsv.Slice `yaml:"boss" codec:"boss"`
	// firstAward
	FirstAward tjcsv.Map `yaml:"firstAward" codec:"firstAward"`
	// firstAwardShow
	FirstAwardShow tjcsv.Slice `yaml:"firstAwardShow" codec:"firstAwardShow"`
	// gateDesc
	GateDesc string `yaml:"gateDesc" codec:"gateDesc"`
	// gateType
	GateType int `yaml:"gateType" codec:"gateType"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// limitArg
	LimitArg tjcsv.Slice `yaml:"limitArg" codec:"limitArg"`
	// limitType
	LimitType int `yaml:"limitType" codec:"limitType"`
	// lowestFightingPoint
	LowestFightingPoint int `yaml:"lowestFightingPoint" codec:"lowestFightingPoint"`
	// monsters
	Monsters tjcsv.Slice `yaml:"monsters" codec:"monsters"`
	// openLevel
	OpenLevel int `yaml:"openLevel" codec:"openLevel"`
	// roundLimit
	RoundLimit int `yaml:"roundLimit" codec:"roundLimit"`
	// saodangAward
	SaodangAward tjcsv.Map `yaml:"saodangAward" codec:"saodangAward"`
	// saodangAwardShow
	SaodangAwardShow tjcsv.Slice `yaml:"saodangAwardShow" codec:"saodangAwardShow"`
	// sceneCount
	SceneCount int `yaml:"sceneCount" codec:"sceneCount"`
	// sceneLevel
	SceneLevel int `yaml:"sceneLevel" codec:"sceneLevel"`
	// sceneName
	SceneName string `yaml:"sceneName" codec:"sceneName"`
	// sceneType
	SceneType int `yaml:"sceneType" codec:"sceneType"`
	// showLevel
	ShowLevel int `yaml:"showLevel" codec:"showLevel"`
	// skillLevel
	SkillLevel int `yaml:"skillLevel" codec:"skillLevel"`
}
// equip_shop.csv
type Equip_shop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// itemCount
	ItemCount int `yaml:"itemCount" codec:"itemCount"`
	// itemMap
	ItemMap tjcsv.Map `yaml:"itemMap" codec:"itemMap"`
	// itemWeightMap
	ItemWeightMap tjcsv.Map `yaml:"itemWeightMap" codec:"itemWeightMap"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
	// limitTimes
	LimitTimes int `yaml:"limitTimes" codec:"limitTimes"`
	// limitType
	LimitType int `yaml:"limitType" codec:"limitType"`
	// position
	Position int `yaml:"position" codec:"position"`
	// showUnable
	ShowUnable bool `yaml:"showUnable" codec:"showUnable"`
	// type
	Type int `yaml:"type" codec:"type"`
	// vipStart
	VipStart int `yaml:"vipStart" codec:"vipStart"`
	// vipWeight
	VipWeight int `yaml:"vipWeight" codec:"vipWeight"`
}
// equips.csv
type Equips struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// abilityAttr
	AbilityAttr tjcsv.Slice `yaml:"abilityAttr" codec:"abilityAttr"`
	// abilityMax
	AbilityMax int `yaml:"abilityMax" codec:"abilityMax"`
	// abilitySeqID
	AbilitySeqID int `yaml:"abilitySeqID" codec:"abilitySeqID"`
	// advanceIndex
	AdvanceIndex int `yaml:"advanceIndex" codec:"advanceIndex"`
	// advanceMax
	AdvanceMax int `yaml:"advanceMax" codec:"advanceMax"`
	// advanceSeqID
	AdvanceSeqID int `yaml:"advanceSeqID" codec:"advanceSeqID"`
	// attrAdvanceNum1
	AttrAdvanceNum1 tjcsv.Slice `yaml:"attrAdvanceNum1" codec:"attrAdvanceNum1"`
	// attrAdvanceNum2
	AttrAdvanceNum2 tjcsv.Slice `yaml:"attrAdvanceNum2" codec:"attrAdvanceNum2"`
	// attrNum1
	AttrNum1 tjcsv.Slice `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 tjcsv.Slice `yaml:"attrNum2" codec:"attrNum2"`
	// attrStarC1
	AttrStarC1 tjcsv.Slice `yaml:"attrStarC1" codec:"attrStarC1"`
	// attrStarC2
	AttrStarC2 tjcsv.Slice `yaml:"attrStarC2" codec:"attrStarC2"`
	// attrStarNum1
	AttrStarNum1 tjcsv.Slice `yaml:"attrStarNum1" codec:"attrStarNum1"`
	// attrStarNum2
	AttrStarNum2 tjcsv.Slice `yaml:"attrStarNum2" codec:"attrStarNum2"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// awakeAbilityAttrNum1
	AwakeAbilityAttrNum1 tjcsv.Slice `yaml:"awakeAbilityAttrNum1" codec:"awakeAbilityAttrNum1"`
	// awakeAbilityAttrNum2
	AwakeAbilityAttrNum2 tjcsv.Slice `yaml:"awakeAbilityAttrNum2" codec:"awakeAbilityAttrNum2"`
	// awakeAbilityAttrType1
	AwakeAbilityAttrType1 int `yaml:"awakeAbilityAttrType1" codec:"awakeAbilityAttrType1"`
	// awakeAbilityAttrType2
	AwakeAbilityAttrType2 int `yaml:"awakeAbilityAttrType2" codec:"awakeAbilityAttrType2"`
	// awakeAbilityMax
	AwakeAbilityMax int `yaml:"awakeAbilityMax" codec:"awakeAbilityMax"`
	// awakeAbilitySeqID
	AwakeAbilitySeqID int `yaml:"awakeAbilitySeqID" codec:"awakeAbilitySeqID"`
	// awakeAttrNum1
	AwakeAttrNum1 tjcsv.Slice `yaml:"awakeAttrNum1" codec:"awakeAttrNum1"`
	// awakeAttrNum2
	AwakeAttrNum2 tjcsv.Slice `yaml:"awakeAttrNum2" codec:"awakeAttrNum2"`
	// awakeAttrType1
	AwakeAttrType1 int `yaml:"awakeAttrType1" codec:"awakeAttrType1"`
	// awakeAttrType2
	AwakeAttrType2 int `yaml:"awakeAttrType2" codec:"awakeAttrType2"`
	// awakeMax
	AwakeMax int `yaml:"awakeMax" codec:"awakeMax"`
	// awakeRoleLevelMax
	AwakeRoleLevelMax tjcsv.Slice `yaml:"awakeRoleLevelMax" codec:"awakeRoleLevelMax"`
	// awakeSeqID
	AwakeSeqID int `yaml:"awakeSeqID" codec:"awakeSeqID"`
	// awakeStar
	AwakeStar tjcsv.Slice `yaml:"awakeStar" codec:"awakeStar"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// icon2
	Icon2 string `yaml:"icon2" codec:"icon2"`
	// name0
	Name0 string `yaml:"name0" codec:"name0"`
	// name1
	Name1 string `yaml:"name1" codec:"name1"`
	// part
	Part int `yaml:"part" codec:"part"`
	// quality
	Quality tjcsv.Slice `yaml:"quality" codec:"quality"`
	// roleLevelMax
	RoleLevelMax tjcsv.Slice `yaml:"roleLevelMax" codec:"roleLevelMax"`
	// signetAdvanceMax
	SignetAdvanceMax int `yaml:"signetAdvanceMax" codec:"signetAdvanceMax"`
	// signetAttrNum1
	SignetAttrNum1 tjcsv.Slice `yaml:"signetAttrNum1" codec:"signetAttrNum1"`
	// signetAttrNum2
	SignetAttrNum2 tjcsv.Slice `yaml:"signetAttrNum2" codec:"signetAttrNum2"`
	// signetAttrType1
	SignetAttrType1 int `yaml:"signetAttrType1" codec:"signetAttrType1"`
	// signetAttrType2
	SignetAttrType2 int `yaml:"signetAttrType2" codec:"signetAttrType2"`
	// signetStrengthMax
	SignetStrengthMax tjcsv.Slice `yaml:"signetStrengthMax" codec:"signetStrengthMax"`
	// signetStrengthSeqID
	SignetStrengthSeqID int `yaml:"signetStrengthSeqID" codec:"signetStrengthSeqID"`
	// starMax
	StarMax int `yaml:"starMax" codec:"starMax"`
	// starSeqID
	StarSeqID int `yaml:"starSeqID" codec:"starSeqID"`
	// strengthMax
	StrengthMax tjcsv.Slice `yaml:"strengthMax" codec:"strengthMax"`
	// strengthSeqID
	StrengthSeqID int `yaml:"strengthSeqID" codec:"strengthSeqID"`
}
// explorer
type Explorer struct {
	// explorer/ability.csv
	Ability map[int]*Explorer_ability `yaml:"ability" codec:"ability"`
	// explorer/component.csv
	Component map[int]*Explorer_component `yaml:"component" codec:"component"`
	// explorer/component_level.csv
	Component_level map[int]*Explorer_component_level `yaml:"component_level" codec:"component_level"`
	// explorer/explorer.csv
	Explorer map[int]*Explorer_explorer `yaml:"explorer" codec:"explorer"`
	// explorer/explorer_advance.csv
	Explorer_advance map[int]*Explorer_explorer_advance `yaml:"explorer_advance" codec:"explorer_advance"`
	// explorer/explorer_effect.csv
	Explorer_effect map[int]*Explorer_explorer_effect `yaml:"explorer_effect" codec:"explorer_effect"`
	// explorer/explorer_shop.csv
	Explorer_shop map[int]*Explorer_explorer_shop `yaml:"explorer_shop" codec:"explorer_shop"`
}
// explorer/ability.csv
type Explorer_ability struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNum1
	AttrNum1 tjcsv.Slice `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 tjcsv.Slice `yaml:"attrNum2" codec:"attrNum2"`
	// attrTarget
	AttrTarget tjcsv.Slice `yaml:"attrTarget" codec:"attrTarget"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// effectType
	EffectType int `yaml:"effectType" codec:"effectType"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// levelMax
	LevelMax int `yaml:"levelMax" codec:"levelMax"`
	// name
	Name string `yaml:"name" codec:"name"`
	// pos
	Pos tjcsv.Map `yaml:"pos" codec:"pos"`
	// position
	Position int `yaml:"position" codec:"position"`
	// preID
	PreID tjcsv.Slice `yaml:"preID" codec:"preID"`
	// seqCod1
	SeqCod1 tjcsv.Slice `yaml:"seqCod1" codec:"seqCod1"`
	// seqCod2
	SeqCod2 tjcsv.Slice `yaml:"seqCod2" codec:"seqCod2"`
	// seqCost
	SeqCost tjcsv.Map `yaml:"seqCost" codec:"seqCost"`
	// seqID
	SeqID int `yaml:"seqID" codec:"seqID"`
	// skillID
	SkillID int `yaml:"skillID" codec:"skillID"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// explorer/component.csv
type Explorer_component struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNum1
	AttrNum1 tjcsv.Slice `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 tjcsv.Slice `yaml:"attrNum2" codec:"attrNum2"`
	// attrNum3
	AttrNum3 tjcsv.Slice `yaml:"attrNum3" codec:"attrNum3"`
	// attrNum4
	AttrNum4 tjcsv.Slice `yaml:"attrNum4" codec:"attrNum4"`
	// attrNumType1
	AttrNumType1 int `yaml:"attrNumType1" codec:"attrNumType1"`
	// attrNumType2
	AttrNumType2 int `yaml:"attrNumType2" codec:"attrNumType2"`
	// attrNumType3
	AttrNumType3 int `yaml:"attrNumType3" codec:"attrNumType3"`
	// attrNumType4
	AttrNumType4 int `yaml:"attrNumType4" codec:"attrNumType4"`
	// attrTarget
	AttrTarget tjcsv.Slice `yaml:"attrTarget" codec:"attrTarget"`
	// componentLine
	ComponentLine tjcsv.Map `yaml:"componentLine" codec:"componentLine"`
	// componentPosID
	ComponentPosID int `yaml:"componentPosID" codec:"componentPosID"`
	// componentsize
	Componentsize int `yaml:"componentsize" codec:"componentsize"`
	// coordinate
	Coordinate tjcsv.Map `yaml:"coordinate" codec:"coordinate"`
	// itemID
	ItemID int `yaml:"itemID" codec:"itemID"`
	// strengthCostSeq
	StrengthCostSeq int `yaml:"strengthCostSeq" codec:"strengthCostSeq"`
}
// explorer/component_level.csv
type Explorer_component_level struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// costItemMap1
	CostItemMap1 tjcsv.Map `yaml:"costItemMap1" codec:"costItemMap1"`
	// costItemMap10
	CostItemMap10 tjcsv.Map `yaml:"costItemMap10" codec:"costItemMap10"`
	// costItemMap11
	CostItemMap11 tjcsv.Map `yaml:"costItemMap11" codec:"costItemMap11"`
	// costItemMap12
	CostItemMap12 tjcsv.Map `yaml:"costItemMap12" codec:"costItemMap12"`
	// costItemMap13
	CostItemMap13 tjcsv.Map `yaml:"costItemMap13" codec:"costItemMap13"`
	// costItemMap14
	CostItemMap14 tjcsv.Map `yaml:"costItemMap14" codec:"costItemMap14"`
	// costItemMap15
	CostItemMap15 tjcsv.Map `yaml:"costItemMap15" codec:"costItemMap15"`
	// costItemMap16
	CostItemMap16 tjcsv.Map `yaml:"costItemMap16" codec:"costItemMap16"`
	// costItemMap17
	CostItemMap17 tjcsv.Map `yaml:"costItemMap17" codec:"costItemMap17"`
	// costItemMap18
	CostItemMap18 tjcsv.Map `yaml:"costItemMap18" codec:"costItemMap18"`
	// costItemMap19
	CostItemMap19 tjcsv.Map `yaml:"costItemMap19" codec:"costItemMap19"`
	// costItemMap2
	CostItemMap2 tjcsv.Map `yaml:"costItemMap2" codec:"costItemMap2"`
	// costItemMap20
	CostItemMap20 tjcsv.Map `yaml:"costItemMap20" codec:"costItemMap20"`
	// costItemMap21
	CostItemMap21 tjcsv.Map `yaml:"costItemMap21" codec:"costItemMap21"`
	// costItemMap22
	CostItemMap22 tjcsv.Map `yaml:"costItemMap22" codec:"costItemMap22"`
	// costItemMap23
	CostItemMap23 tjcsv.Map `yaml:"costItemMap23" codec:"costItemMap23"`
	// costItemMap24
	CostItemMap24 tjcsv.Map `yaml:"costItemMap24" codec:"costItemMap24"`
	// costItemMap25
	CostItemMap25 tjcsv.Map `yaml:"costItemMap25" codec:"costItemMap25"`
	// costItemMap26
	CostItemMap26 tjcsv.Map `yaml:"costItemMap26" codec:"costItemMap26"`
	// costItemMap27
	CostItemMap27 tjcsv.Map `yaml:"costItemMap27" codec:"costItemMap27"`
	// costItemMap28
	CostItemMap28 tjcsv.Map `yaml:"costItemMap28" codec:"costItemMap28"`
	// costItemMap29
	CostItemMap29 tjcsv.Map `yaml:"costItemMap29" codec:"costItemMap29"`
	// costItemMap3
	CostItemMap3 tjcsv.Map `yaml:"costItemMap3" codec:"costItemMap3"`
	// costItemMap30
	CostItemMap30 tjcsv.Map `yaml:"costItemMap30" codec:"costItemMap30"`
	// costItemMap31
	CostItemMap31 tjcsv.Map `yaml:"costItemMap31" codec:"costItemMap31"`
	// costItemMap32
	CostItemMap32 tjcsv.Map `yaml:"costItemMap32" codec:"costItemMap32"`
	// costItemMap33
	CostItemMap33 tjcsv.Map `yaml:"costItemMap33" codec:"costItemMap33"`
	// costItemMap34
	CostItemMap34 tjcsv.Map `yaml:"costItemMap34" codec:"costItemMap34"`
	// costItemMap35
	CostItemMap35 tjcsv.Map `yaml:"costItemMap35" codec:"costItemMap35"`
	// costItemMap36
	CostItemMap36 tjcsv.Map `yaml:"costItemMap36" codec:"costItemMap36"`
	// costItemMap37
	CostItemMap37 tjcsv.Map `yaml:"costItemMap37" codec:"costItemMap37"`
	// costItemMap38
	CostItemMap38 tjcsv.Map `yaml:"costItemMap38" codec:"costItemMap38"`
	// costItemMap39
	CostItemMap39 tjcsv.Map `yaml:"costItemMap39" codec:"costItemMap39"`
	// costItemMap4
	CostItemMap4 tjcsv.Map `yaml:"costItemMap4" codec:"costItemMap4"`
	// costItemMap40
	CostItemMap40 tjcsv.Map `yaml:"costItemMap40" codec:"costItemMap40"`
	// costItemMap5
	CostItemMap5 tjcsv.Map `yaml:"costItemMap5" codec:"costItemMap5"`
	// costItemMap6
	CostItemMap6 tjcsv.Map `yaml:"costItemMap6" codec:"costItemMap6"`
	// costItemMap7
	CostItemMap7 tjcsv.Map `yaml:"costItemMap7" codec:"costItemMap7"`
	// costItemMap8
	CostItemMap8 tjcsv.Map `yaml:"costItemMap8" codec:"costItemMap8"`
	// costItemMap9
	CostItemMap9 tjcsv.Map `yaml:"costItemMap9" codec:"costItemMap9"`
}
// explorer/explorer.csv
type Explorer_explorer struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// advanceCostSeq
	AdvanceCostSeq int `yaml:"advanceCostSeq" codec:"advanceCostSeq"`
	// bg
	Bg string `yaml:"bg" codec:"bg"`
	// componentIDs
	ComponentIDs tjcsv.Slice `yaml:"componentIDs" codec:"componentIDs"`
	// coordinate
	Coordinate tjcsv.Map `yaml:"coordinate" codec:"coordinate"`
	// effect
	Effect tjcsv.Slice `yaml:"effect" codec:"effect"`
	// extraEff
	ExtraEff tjcsv.Slice `yaml:"extraEff" codec:"extraEff"`
	// extraEffCod
	ExtraEffCod tjcsv.Slice `yaml:"extraEffCod" codec:"extraEffCod"`
	// levelMax
	LevelMax int `yaml:"levelMax" codec:"levelMax"`
	// name
	Name string `yaml:"name" codec:"name"`
	// quality
	Quality int `yaml:"quality" codec:"quality"`
	// res
	Res string `yaml:"res" codec:"res"`
	// simpleIcon
	SimpleIcon string `yaml:"simpleIcon" codec:"simpleIcon"`
}
// explorer/explorer_advance.csv
type Explorer_explorer_advance struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// costItemMap1
	CostItemMap1 tjcsv.Map `yaml:"costItemMap1" codec:"costItemMap1"`
	// costItemMap2
	CostItemMap2 tjcsv.Map `yaml:"costItemMap2" codec:"costItemMap2"`
	// costItemMap3
	CostItemMap3 tjcsv.Map `yaml:"costItemMap3" codec:"costItemMap3"`
	// costItemMap4
	CostItemMap4 tjcsv.Map `yaml:"costItemMap4" codec:"costItemMap4"`
	// costItemMap5
	CostItemMap5 tjcsv.Map `yaml:"costItemMap5" codec:"costItemMap5"`
	// costItemMap6
	CostItemMap6 tjcsv.Map `yaml:"costItemMap6" codec:"costItemMap6"`
}
// explorer/explorer_effect.csv
type Explorer_explorer_effect struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNum1
	AttrNum1 tjcsv.Slice `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 tjcsv.Slice `yaml:"attrNum2" codec:"attrNum2"`
	// attrNum3
	AttrNum3 tjcsv.Slice `yaml:"attrNum3" codec:"attrNum3"`
	// attrNum4
	AttrNum4 tjcsv.Slice `yaml:"attrNum4" codec:"attrNum4"`
	// attrNum5
	AttrNum5 tjcsv.Slice `yaml:"attrNum5" codec:"attrNum5"`
	// attrNum6
	AttrNum6 tjcsv.Slice `yaml:"attrNum6" codec:"attrNum6"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// attrType3
	AttrType3 int `yaml:"attrType3" codec:"attrType3"`
	// attrType4
	AttrType4 int `yaml:"attrType4" codec:"attrType4"`
	// attrType5
	AttrType5 int `yaml:"attrType5" codec:"attrType5"`
	// attrType6
	AttrType6 int `yaml:"attrType6" codec:"attrType6"`
	// effectDesc
	EffectDesc string `yaml:"effectDesc" codec:"effectDesc"`
	// effectType
	EffectType int `yaml:"effectType" codec:"effectType"`
	// skillID
	SkillID int `yaml:"skillID" codec:"skillID"`
	// target
	Target tjcsv.Slice `yaml:"target" codec:"target"`
}
// explorer/explorer_shop.csv
type Explorer_explorer_shop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// itemCount
	ItemCount int `yaml:"itemCount" codec:"itemCount"`
	// itemWeightMap
	ItemWeightMap tjcsv.Map `yaml:"itemWeightMap" codec:"itemWeightMap"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
	// limitTimes
	LimitTimes int `yaml:"limitTimes" codec:"limitTimes"`
	// limitType
	LimitType int `yaml:"limitType" codec:"limitType"`
	// position
	Position int `yaml:"position" codec:"position"`
	// showUnable
	ShowUnable bool `yaml:"showUnable" codec:"showUnable"`
	// vipStart
	VipStart int `yaml:"vipStart" codec:"vipStart"`
	// vipWeight
	VipWeight int `yaml:"vipWeight" codec:"vipWeight"`
}
// extra_object.csv
type Extra_object struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// battleTurnFollowMode
	BattleTurnFollowMode int `yaml:"battleTurnFollowMode" codec:"battleTurnFollowMode"`
	// beAttackOffsetPos
	BeAttackOffsetPos tjcsv.Map `yaml:"beAttackOffsetPos" codec:"beAttackOffsetPos"`
	// bornAddBuffs
	BornAddBuffs tjcsv.Map `yaml:"bornAddBuffs" codec:"bornAddBuffs"`
	// category
	Category int `yaml:"category" codec:"category"`
	// deadDel
	DeadDel bool `yaml:"deadDel" codec:"deadDel"`
	// dealGroup
	DealGroup int `yaml:"dealGroup" codec:"dealGroup"`
	// hideLifebar
	HideLifebar int `yaml:"hideLifebar" codec:"hideLifebar"`
	// lerpZ
	LerpZ int `yaml:"lerpZ" codec:"lerpZ"`
	// natureIncluded
	NatureIncluded bool `yaml:"natureIncluded" codec:"natureIncluded"`
	// posZ
	PosZ int `yaml:"posZ" codec:"posZ"`
	// triggerBattleTurn
	TriggerBattleTurn bool `yaml:"triggerBattleTurn" codec:"triggerBattleTurn"`
}
// extra_round_trigger.csv
type Extra_round_trigger struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// cfgIds
	CfgIds tjcsv.Slice `yaml:"cfgIds" codec:"cfgIds"`
	// disableBattleState
	DisableBattleState int `yaml:"disableBattleState" codec:"disableBattleState"`
	// forbiddenBuff
	ForbiddenBuff tjcsv.Slice `yaml:"forbiddenBuff" codec:"forbiddenBuff"`
	// forbiddenPassiveSkill
	ForbiddenPassiveSkill tjcsv.Slice `yaml:"forbiddenPassiveSkill" codec:"forbiddenPassiveSkill"`
	// limitBuff
	LimitBuff tjcsv.Slice `yaml:"limitBuff" codec:"limitBuff"`
}
// fetter.csv
type Fetter struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrMap
	AttrMap tjcsv.Map `yaml:"attrMap" codec:"attrMap"`
	// cards
	Cards tjcsv.Slice `yaml:"cards" codec:"cards"`
	// name
	Name string `yaml:"name" codec:"name"`
}
// fighting_weight.csv
type Fighting_weight struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// block
	Block float64 `yaml:"block" codec:"block"`
	// blockPower
	BlockPower float64 `yaml:"blockPower" codec:"blockPower"`
	// breakBlock
	BreakBlock float64 `yaml:"breakBlock" codec:"breakBlock"`
	// controlPer
	ControlPer float64 `yaml:"controlPer" codec:"controlPer"`
	// cure
	Cure float64 `yaml:"cure" codec:"cure"`
	// damage
	Damage float64 `yaml:"damage" codec:"damage"`
	// damageAdd
	DamageAdd float64 `yaml:"damageAdd" codec:"damageAdd"`
	// damageDeepen
	DamageDeepen int `yaml:"damageDeepen" codec:"damageDeepen"`
	// damageReduce
	DamageReduce int `yaml:"damageReduce" codec:"damageReduce"`
	// damageSub
	DamageSub float64 `yaml:"damageSub" codec:"damageSub"`
	// defence
	Defence float64 `yaml:"defence" codec:"defence"`
	// defenceIgnore
	DefenceIgnore int `yaml:"defenceIgnore" codec:"defenceIgnore"`
	// dodge
	Dodge float64 `yaml:"dodge" codec:"dodge"`
	// hit
	Hit float64 `yaml:"hit" codec:"hit"`
	// hp
	Hp float64 `yaml:"hp" codec:"hp"`
	// hpRecover
	HpRecover int `yaml:"hpRecover" codec:"hpRecover"`
	// immuneControl
	ImmuneControl float64 `yaml:"immuneControl" codec:"immuneControl"`
	// initMp1
	InitMp1 int `yaml:"initMp1" codec:"initMp1"`
	// level
	Level int `yaml:"level" codec:"level"`
	// mp1
	Mp1 int `yaml:"mp1" codec:"mp1"`
	// mp1Recover
	Mp1Recover int `yaml:"mp1Recover" codec:"mp1Recover"`
	// mp2Recover
	Mp2Recover int `yaml:"mp2Recover" codec:"mp2Recover"`
	// natureRestraint
	NatureRestraint float64 `yaml:"natureRestraint" codec:"natureRestraint"`
	// physicalDamageAdd
	PhysicalDamageAdd float64 `yaml:"physicalDamageAdd" codec:"physicalDamageAdd"`
	// physicalDamageSub
	PhysicalDamageSub float64 `yaml:"physicalDamageSub" codec:"physicalDamageSub"`
	// pvpDamageAdd
	PvpDamageAdd float64 `yaml:"pvpDamageAdd" codec:"pvpDamageAdd"`
	// pvpDamageSub
	PvpDamageSub float64 `yaml:"pvpDamageSub" codec:"pvpDamageSub"`
	// rebound
	Rebound float64 `yaml:"rebound" codec:"rebound"`
	// specialDamage
	SpecialDamage float64 `yaml:"specialDamage" codec:"specialDamage"`
	// specialDamageAdd
	SpecialDamageAdd float64 `yaml:"specialDamageAdd" codec:"specialDamageAdd"`
	// specialDamageSub
	SpecialDamageSub float64 `yaml:"specialDamageSub" codec:"specialDamageSub"`
	// specialDefence
	SpecialDefence float64 `yaml:"specialDefence" codec:"specialDefence"`
	// specialDefenceIgnore
	SpecialDefenceIgnore int `yaml:"specialDefenceIgnore" codec:"specialDefenceIgnore"`
	// speed
	Speed float64 `yaml:"speed" codec:"speed"`
	// strike
	Strike float64 `yaml:"strike" codec:"strike"`
	// strikeDamage
	StrikeDamage float64 `yaml:"strikeDamage" codec:"strikeDamage"`
	// strikeResistance
	StrikeResistance float64 `yaml:"strikeResistance" codec:"strikeResistance"`
	// suckBlood
	SuckBlood float64 `yaml:"suckBlood" codec:"suckBlood"`
	// ultimateAdd
	UltimateAdd float64 `yaml:"ultimateAdd" codec:"ultimateAdd"`
	// ultimateSub
	UltimateSub float64 `yaml:"ultimateSub" codec:"ultimateSub"`
}
// fishing
type Fishing struct {
	// fishing/bait.csv
	Bait map[int]*Fishing_bait `yaml:"bait" codec:"bait"`
	// fishing/fish.csv
	Fish map[int]*Fishing_fish `yaml:"fish" codec:"fish"`
	// fishing/level.csv
	Level map[int]*Fishing_level `yaml:"level" codec:"level"`
	// fishing/partner.csv
	Partner map[int]*Fishing_partner `yaml:"partner" codec:"partner"`
	// fishing/rod.csv
	Rod map[int]*Fishing_rod `yaml:"rod" codec:"rod"`
	// fishing/scene.csv
	Scene map[int]*Fishing_scene `yaml:"scene" codec:"scene"`
	// fishing/shop.csv
	Shop map[int]*Fishing_shop `yaml:"shop" codec:"shop"`
}
// fishing/bait.csv
type Fishing_bait struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// cost
	Cost tjcsv.Map `yaml:"cost" codec:"cost"`
	// extraProbability
	ExtraProbability int `yaml:"extraProbability" codec:"extraProbability"`
	// extraRate
	ExtraRate tjcsv.Map `yaml:"extraRate" codec:"extraRate"`
	// itemId
	ItemId int `yaml:"itemId" codec:"itemId"`
	// lowerRandom
	LowerRandom float64 `yaml:"lowerRandom" codec:"lowerRandom"`
	// lowerWait
	LowerWait float64 `yaml:"lowerWait" codec:"lowerWait"`
	// name
	Name string `yaml:"name" codec:"name"`
	// needLv
	NeedLv int `yaml:"needLv" codec:"needLv"`
	// rare
	Rare int `yaml:"rare" codec:"rare"`
	// scene
	Scene tjcsv.Slice `yaml:"scene" codec:"scene"`
}
// fishing/fish.csv
type Fishing_fish struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// bait
	Bait tjcsv.Slice `yaml:"bait" codec:"bait"`
	// big
	Big int `yaml:"big" codec:"big"`
	// bookId
	BookId int `yaml:"bookId" codec:"bookId"`
	// competitionEscape
	CompetitionEscape int `yaml:"competitionEscape" codec:"competitionEscape"`
	// competitionRandMove
	CompetitionRandMove tjcsv.Slice `yaml:"competitionRandMove" codec:"competitionRandMove"`
	// competitionSpeed
	CompetitionSpeed int `yaml:"competitionSpeed" codec:"competitionSpeed"`
	// crossFishingWeight
	CrossFishingWeight int `yaml:"crossFishingWeight" codec:"crossFishingWeight"`
	// deadTime
	DeadTime int `yaml:"deadTime" codec:"deadTime"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// escape
	Escape int `yaml:"escape" codec:"escape"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// length
	Length tjcsv.Slice `yaml:"length" codec:"length"`
	// maxWinTimes
	MaxWinTimes int `yaml:"maxWinTimes" codec:"maxWinTimes"`
	// name
	Name string `yaml:"name" codec:"name"`
	// needLv
	NeedLv int `yaml:"needLv" codec:"needLv"`
	// operateTimePointUp
	OperateTimePointUp tjcsv.Slice `yaml:"operateTimePointUp" codec:"operateTimePointUp"`
	// overDeal
	OverDeal int `yaml:"overDeal" codec:"overDeal"`
	// point
	Point int `yaml:"point" codec:"point"`
	// priority
	Priority int `yaml:"priority" codec:"priority"`
	// probability
	Probability float64 `yaml:"probability" codec:"probability"`
	// randMove
	RandMove tjcsv.Slice `yaml:"randMove" codec:"randMove"`
	// randType
	RandType int `yaml:"randType" codec:"randType"`
	// rare
	Rare int `yaml:"rare" codec:"rare"`
	// res
	Res string `yaml:"res" codec:"res"`
	// scale
	Scale float64 `yaml:"scale" codec:"scale"`
	// scene
	Scene tjcsv.Slice `yaml:"scene" codec:"scene"`
	// showType
	ShowType string `yaml:"showType" codec:"showType"`
	// speed
	Speed int `yaml:"speed" codec:"speed"`
	// time
	Time tjcsv.Slice `yaml:"time" codec:"time"`
	// type
	Type int `yaml:"type" codec:"type"`
	// weekMax
	WeekMax int `yaml:"weekMax" codec:"weekMax"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
	// weightMax
	WeightMax float64 `yaml:"weightMax" codec:"weightMax"`
	// weightMin
	WeightMin float64 `yaml:"weightMin" codec:"weightMin"`
}
// fishing/level.csv
type Fishing_level struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNum1
	AttrNum1 int `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 int `yaml:"attrNum2" codec:"attrNum2"`
	// attrNum3
	AttrNum3 int `yaml:"attrNum3" codec:"attrNum3"`
	// attrNum4
	AttrNum4 int `yaml:"attrNum4" codec:"attrNum4"`
	// attrNum5
	AttrNum5 int `yaml:"attrNum5" codec:"attrNum5"`
	// attrNum6
	AttrNum6 int `yaml:"attrNum6" codec:"attrNum6"`
	// attrNum7
	AttrNum7 int `yaml:"attrNum7" codec:"attrNum7"`
	// attrNum8
	AttrNum8 int `yaml:"attrNum8" codec:"attrNum8"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// attrType3
	AttrType3 int `yaml:"attrType3" codec:"attrType3"`
	// attrType4
	AttrType4 int `yaml:"attrType4" codec:"attrType4"`
	// attrType5
	AttrType5 int `yaml:"attrType5" codec:"attrType5"`
	// attrType6
	AttrType6 int `yaml:"attrType6" codec:"attrType6"`
	// attrType7
	AttrType7 int `yaml:"attrType7" codec:"attrType7"`
	// attrType8
	AttrType8 int `yaml:"attrType8" codec:"attrType8"`
	// extraProbability
	ExtraProbability float64 `yaml:"extraProbability" codec:"extraProbability"`
	// fasterSpeed
	FasterSpeed float64 `yaml:"fasterSpeed" codec:"fasterSpeed"`
	// highNum
	HighNum int `yaml:"highNum" codec:"highNum"`
	// lowNum
	LowNum int `yaml:"lowNum" codec:"lowNum"`
	// middleNum
	MiddleNum int `yaml:"middleNum" codec:"middleNum"`
	// name
	Name string `yaml:"name" codec:"name"`
	// targetNum
	TargetNum tjcsv.Map `yaml:"targetNum" codec:"targetNum"`
	// timeDown
	TimeDown float64 `yaml:"timeDown" codec:"timeDown"`
	// totalNum
	TotalNum int `yaml:"totalNum" codec:"totalNum"`
}
// fishing/partner.csv
type Fishing_partner struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// actMode
	ActMode int `yaml:"actMode" codec:"actMode"`
	// actRate
	ActRate int `yaml:"actRate" codec:"actRate"`
	// cost
	Cost tjcsv.Map `yaml:"cost" codec:"cost"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// name
	Name string `yaml:"name" codec:"name"`
	// needLv
	NeedLv int `yaml:"needLv" codec:"needLv"`
	// scale
	Scale float64 `yaml:"scale" codec:"scale"`
	// spcialEffect
	SpcialEffect interface{} `yaml:"spcialEffect" codec:"spcialEffect"`
	// spcialEffectDesc
	SpcialEffectDesc interface{} `yaml:"spcialEffectDesc" codec:"spcialEffectDesc"`
	// unitId
	UnitId int `yaml:"unitId" codec:"unitId"`
}
// fishing/rod.csv
type Fishing_rod struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// cost
	Cost tjcsv.Map `yaml:"cost" codec:"cost"`
	// extraProbability
	ExtraProbability float64 `yaml:"extraProbability" codec:"extraProbability"`
	// extraSpeed
	ExtraSpeed float64 `yaml:"extraSpeed" codec:"extraSpeed"`
	// extraZone
	ExtraZone float64 `yaml:"extraZone" codec:"extraZone"`
	// itemId
	ItemId int `yaml:"itemId" codec:"itemId"`
	// lowerSpeed
	LowerSpeed float64 `yaml:"lowerSpeed" codec:"lowerSpeed"`
	// lowerWait
	LowerWait float64 `yaml:"lowerWait" codec:"lowerWait"`
	// name
	Name string `yaml:"name" codec:"name"`
	// needLv
	NeedLv int `yaml:"needLv" codec:"needLv"`
	// res
	Res string `yaml:"res" codec:"res"`
}
// fishing/scene.csv
type Fishing_scene struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// characterPos
	CharacterPos tjcsv.Slice `yaml:"characterPos" codec:"characterPos"`
	// lock
	Lock int `yaml:"lock" codec:"lock"`
	// name
	Name string `yaml:"name" codec:"name"`
	// needLv
	NeedLv int `yaml:"needLv" codec:"needLv"`
	// priview
	Priview tjcsv.Slice `yaml:"priview" codec:"priview"`
	// res
	Res string `yaml:"res" codec:"res"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// fishing/shop.csv
type Fishing_shop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// fishingLevelRange
	FishingLevelRange tjcsv.Slice `yaml:"fishingLevelRange" codec:"fishingLevelRange"`
	// itemCount
	ItemCount int `yaml:"itemCount" codec:"itemCount"`
	// itemWeightMap
	ItemWeightMap tjcsv.Map `yaml:"itemWeightMap" codec:"itemWeightMap"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
	// limitTimes
	LimitTimes int `yaml:"limitTimes" codec:"limitTimes"`
	// limitType
	LimitType int `yaml:"limitType" codec:"limitType"`
	// position
	Position int `yaml:"position" codec:"position"`
	// showUnable
	ShowUnable bool `yaml:"showUnable" codec:"showUnable"`
	// vipStart
	VipStart int `yaml:"vipStart" codec:"vipStart"`
	// vipWeight
	VipWeight int `yaml:"vipWeight" codec:"vipWeight"`
}
// fix_shop.csv
type Fix_shop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// itemCount
	ItemCount int `yaml:"itemCount" codec:"itemCount"`
	// itemWeightMap
	ItemWeightMap tjcsv.Map `yaml:"itemWeightMap" codec:"itemWeightMap"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
	// limitTimes
	LimitTimes int `yaml:"limitTimes" codec:"limitTimes"`
	// limitType
	LimitType int `yaml:"limitType" codec:"limitType"`
	// position
	Position int `yaml:"position" codec:"position"`
	// showUnable
	ShowUnable bool `yaml:"showUnable" codec:"showUnable"`
	// vipStart
	VipStart int `yaml:"vipStart" codec:"vipStart"`
	// vipWeight
	VipWeight int `yaml:"vipWeight" codec:"vipWeight"`
}
// frag_shop.csv
type Frag_shop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// itemCount
	ItemCount int `yaml:"itemCount" codec:"itemCount"`
	// itemWeightMap
	ItemWeightMap tjcsv.Map `yaml:"itemWeightMap" codec:"itemWeightMap"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
	// limitTimes
	LimitTimes int `yaml:"limitTimes" codec:"limitTimes"`
	// limitType
	LimitType int `yaml:"limitType" codec:"limitType"`
	// position
	Position int `yaml:"position" codec:"position"`
	// showUnable
	ShowUnable bool `yaml:"showUnable" codec:"showUnable"`
	// vipStart
	VipStart int `yaml:"vipStart" codec:"vipStart"`
	// vipWeight
	VipWeight int `yaml:"vipWeight" codec:"vipWeight"`
}
// fragments.csv
type Fragments struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// autoComb
	AutoComb bool `yaml:"autoComb" codec:"autoComb"`
	// combCount
	CombCount int `yaml:"combCount" codec:"combCount"`
	// combID
	CombID int `yaml:"combID" codec:"combID"`
	// decomposeGain
	DecomposeGain tjcsv.Map `yaml:"decomposeGain" codec:"decomposeGain"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// desc1
	Desc1 string `yaml:"desc1" codec:"desc1"`
	// donateType
	DonateType int `yaml:"donateType" codec:"donateType"`
	// drawlanguages
	Drawlanguages tjcsv.Slice `yaml:"drawlanguages" codec:"drawlanguages"`
	// effBtn
	EffBtn tjcsv.Slice `yaml:"effBtn" codec:"effBtn"`
	// effect
	Effect tjcsv.Map `yaml:"effect" codec:"effect"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// isFinal
	IsFinal int `yaml:"isFinal" codec:"isFinal"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// name
	Name string `yaml:"name" codec:"name"`
	// pageTag
	PageTag tjcsv.Slice `yaml:"pageTag" codec:"pageTag"`
	// produceDesc
	ProduceDesc string `yaml:"produceDesc" codec:"produceDesc"`
	// produceGate1
	ProduceGate1 string `yaml:"produceGate1" codec:"produceGate1"`
	// produceGate2
	ProduceGate2 string `yaml:"produceGate2" codec:"produceGate2"`
	// produceGate3
	ProduceGate3 string `yaml:"produceGate3" codec:"produceGate3"`
	// produceGate4
	ProduceGate4 string `yaml:"produceGate4" codec:"produceGate4"`
	// produceGate5
	ProduceGate5 interface{} `yaml:"produceGate5" codec:"produceGate5"`
	// produceGate6
	ProduceGate6 interface{} `yaml:"produceGate6" codec:"produceGate6"`
	// produceGate7
	ProduceGate7 interface{} `yaml:"produceGate7" codec:"produceGate7"`
	// quality
	Quality int `yaml:"quality" codec:"quality"`
	// rebirthRMB
	RebirthRMB int `yaml:"rebirthRMB" codec:"rebirthRMB"`
	// sellPrice
	SellPrice int `yaml:"sellPrice" codec:"sellPrice"`
	// sortType
	SortType int `yaml:"sortType" codec:"sortType"`
	// sortValue
	SortValue int `yaml:"sortValue" codec:"sortValue"`
	// stackMax
	StackMax int `yaml:"stackMax" codec:"stackMax"`
	// type
	Type int `yaml:"type" codec:"type"`
	// universalFragID
	UniversalFragID int `yaml:"universalFragID" codec:"universalFragID"`
}
// gem
type Gem struct {
	// gem/cards.csv
	Cards map[int]*Gem_cards `yaml:"cards" codec:"cards"`
	// gem/cost.csv
	Cost map[int]*Gem_cost `yaml:"cost" codec:"cost"`
	// gem/gem.csv
	Gem map[int]*Gem_gem `yaml:"gem" codec:"gem"`
	// gem/pos.csv
	Pos map[int]*Gem_pos `yaml:"pos" codec:"pos"`
	// gem/quality.csv
	Quality map[int]*Gem_quality `yaml:"quality" codec:"quality"`
	// gem/quality_attrs.csv
	Quality_attrs map[int]*Gem_quality_attrs `yaml:"quality_attrs" codec:"quality_attrs"`
	// gem/suit.csv
	Suit map[int]*Gem_suit `yaml:"suit" codec:"suit"`
}
// gem/cards.csv
type Gem_cards struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// abilitySeqID
	AbilitySeqID int `yaml:"abilitySeqID" codec:"abilitySeqID"`
	// advanceLevelReq
	AdvanceLevelReq tjcsv.Slice `yaml:"advanceLevelReq" codec:"advanceLevelReq"`
	// advanceMax
	AdvanceMax int `yaml:"advanceMax" codec:"advanceMax"`
	// advanceTypeID
	AdvanceTypeID int `yaml:"advanceTypeID" codec:"advanceTypeID"`
	// atkType
	AtkType tjcsv.Slice `yaml:"atkType" codec:"atkType"`
	// branch
	Branch int `yaml:"branch" codec:"branch"`
	// branchType
	BranchType int `yaml:"branchType" codec:"branchType"`
	// canDevelop
	CanDevelop bool `yaml:"canDevelop" codec:"canDevelop"`
	// cardMarkID
	CardMarkID int `yaml:"cardMarkID" codec:"cardMarkID"`
	// cardType
	CardType int `yaml:"cardType" codec:"cardType"`
	// chaRecom
	ChaRecom tjcsv.Slice `yaml:"chaRecom" codec:"chaRecom"`
	// chaRnd
	ChaRnd int `yaml:"chaRnd" codec:"chaRnd"`
	// develop
	Develop int `yaml:"develop" codec:"develop"`
	// developType
	DevelopType int `yaml:"developType" codec:"developType"`
	// drawlanguages
	Drawlanguages tjcsv.Slice `yaml:"drawlanguages" codec:"drawlanguages"`
	// effect
	Effect tjcsv.Map `yaml:"effect" codec:"effect"`
	// effortSeqID
	EffortSeqID int `yaml:"effortSeqID" codec:"effortSeqID"`
	// energy
	Energy int `yaml:"energy" codec:"energy"`
	// energyCorrection
	EnergyCorrection int `yaml:"energyCorrection" codec:"energyCorrection"`
	// equipsList
	EquipsList tjcsv.Slice `yaml:"equipsList" codec:"equipsList"`
	// feelItems
	FeelItems tjcsv.Slice `yaml:"feelItems" codec:"feelItems"`
	// feelType
	FeelType int `yaml:"feelType" codec:"feelType"`
	// fetterList
	FetterList tjcsv.Slice `yaml:"fetterList" codec:"fetterList"`
	// fightingWeight
	FightingWeight int `yaml:"fightingWeight" codec:"fightingWeight"`
	// fragID
	FragID int `yaml:"fragID" codec:"fragID"`
	// fragNumType
	FragNumType int `yaml:"fragNumType" codec:"fragNumType"`
	// gemPosSeqID
	GemPosSeqID int `yaml:"gemPosSeqID" codec:"gemPosSeqID"`
	// gemQualitySeqID
	GemQualitySeqID int `yaml:"gemQualitySeqID" codec:"gemQualitySeqID"`
	// gender
	Gender int `yaml:"gender" codec:"gender"`
	// innateSkillID
	InnateSkillID int `yaml:"innateSkillID" codec:"innateSkillID"`
	// introduction
	Introduction string `yaml:"introduction" codec:"introduction"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// levelExpID
	LevelExpID int `yaml:"levelExpID" codec:"levelExpID"`
	// levelMax
	LevelMax int `yaml:"levelMax" codec:"levelMax"`
	// location
	Location string `yaml:"location" codec:"location"`
	// maleRate
	MaleRate int `yaml:"maleRate" codec:"maleRate"`
	// megaIndex
	MegaIndex int `yaml:"megaIndex" codec:"megaIndex"`
	// nValueRnd
	NValueRnd int `yaml:"nValueRnd" codec:"nValueRnd"`
	// name
	Name string `yaml:"name" codec:"name"`
	// skillList
	SkillList tjcsv.Slice `yaml:"skillList" codec:"skillList"`
	// skinSkillMap
	SkinSkillMap tjcsv.Map `yaml:"skinSkillMap" codec:"skinSkillMap"`
	// specValue
	SpecValue tjcsv.Slice `yaml:"specValue" codec:"specValue"`
	// star
	Star int `yaml:"star" codec:"star"`
	// starEffectIndex
	StarEffectIndex int `yaml:"starEffectIndex" codec:"starEffectIndex"`
	// starSkillMaxLevel
	StarSkillMaxLevel int `yaml:"starSkillMaxLevel" codec:"starSkillMaxLevel"`
	// starSkillSeqID
	StarSkillSeqID int `yaml:"starSkillSeqID" codec:"starSkillSeqID"`
	// starTypeID
	StarTypeID int `yaml:"starTypeID" codec:"starTypeID"`
	// townSkill
	TownSkill int `yaml:"townSkill" codec:"townSkill"`
	// unitID
	UnitID int `yaml:"unitID" codec:"unitID"`
	// zawakeFragID
	ZawakeFragID int `yaml:"zawakeFragID" codec:"zawakeFragID"`
	// zawakeID
	ZawakeID int `yaml:"zawakeID" codec:"zawakeID"`
}
// gem/cost.csv
type Gem_cost struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// costItemMap1
	CostItemMap1 tjcsv.Map `yaml:"costItemMap1" codec:"costItemMap1"`
	// costItemMap2
	CostItemMap2 tjcsv.Map `yaml:"costItemMap2" codec:"costItemMap2"`
	// costItemMap3
	CostItemMap3 tjcsv.Map `yaml:"costItemMap3" codec:"costItemMap3"`
	// costItemMap4
	CostItemMap4 tjcsv.Map `yaml:"costItemMap4" codec:"costItemMap4"`
	// costItemMap5
	CostItemMap5 tjcsv.Map `yaml:"costItemMap5" codec:"costItemMap5"`
	// costItemMap6
	CostItemMap6 tjcsv.Map `yaml:"costItemMap6" codec:"costItemMap6"`
}
// gem/gem.csv
type Gem_gem struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNum1
	AttrNum1 tjcsv.Slice `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 tjcsv.Slice `yaml:"attrNum2" codec:"attrNum2"`
	// attrNum3
	AttrNum3 tjcsv.Slice `yaml:"attrNum3" codec:"attrNum3"`
	// attrNum4
	AttrNum4 tjcsv.Slice `yaml:"attrNum4" codec:"attrNum4"`
	// attrNum5
	AttrNum5 tjcsv.Slice `yaml:"attrNum5" codec:"attrNum5"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// attrType3
	AttrType3 int `yaml:"attrType3" codec:"attrType3"`
	// attrType4
	AttrType4 int `yaml:"attrType4" codec:"attrType4"`
	// attrType5
	AttrType5 int `yaml:"attrType5" codec:"attrType5"`
	// decomposeReturn
	DecomposeReturn tjcsv.Map `yaml:"decomposeReturn" codec:"decomposeReturn"`
	// desc
	Desc interface{} `yaml:"desc" codec:"desc"`
	// effect
	Effect tjcsv.Map `yaml:"effect" codec:"effect"`
	// gemDescribe
	GemDescribe string `yaml:"gemDescribe" codec:"gemDescribe"`
	// heapLimit
	HeapLimit int `yaml:"heapLimit" codec:"heapLimit"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// name
	Name string `yaml:"name" codec:"name"`
	// quality
	Quality int `yaml:"quality" codec:"quality"`
	// strengthCostSeq
	StrengthCostSeq int `yaml:"strengthCostSeq" codec:"strengthCostSeq"`
	// strengthMax
	StrengthMax int `yaml:"strengthMax" codec:"strengthMax"`
	// suitID
	SuitID int `yaml:"suitID" codec:"suitID"`
	// suitNo
	SuitNo int `yaml:"suitNo" codec:"suitNo"`
}
// gem/pos.csv
type Gem_pos struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// gemPosNo
	GemPosNo int `yaml:"gemPosNo" codec:"gemPosNo"`
	// gemPosSeqID
	GemPosSeqID int `yaml:"gemPosSeqID" codec:"gemPosSeqID"`
	// openCondition
	OpenCondition tjcsv.Slice `yaml:"openCondition" codec:"openCondition"`
}
// gem/quality.csv
type Gem_quality struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// qualityNum1
	QualityNum1 int `yaml:"qualityNum1" codec:"qualityNum1"`
	// qualityNum2
	QualityNum2 int `yaml:"qualityNum2" codec:"qualityNum2"`
	// qualityNum3
	QualityNum3 int `yaml:"qualityNum3" codec:"qualityNum3"`
	// qualityNum4
	QualityNum4 int `yaml:"qualityNum4" codec:"qualityNum4"`
	// qualityNum5
	QualityNum5 int `yaml:"qualityNum5" codec:"qualityNum5"`
	// qualityNum6
	QualityNum6 int `yaml:"qualityNum6" codec:"qualityNum6"`
}
// gem/quality_attrs.csv
type Gem_quality_attrs struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNum1
	AttrNum1 string `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 string `yaml:"attrNum2" codec:"attrNum2"`
	// attrNum3
	AttrNum3 string `yaml:"attrNum3" codec:"attrNum3"`
	// attrNum4
	AttrNum4 string `yaml:"attrNum4" codec:"attrNum4"`
	// attrNum5
	AttrNum5 string `yaml:"attrNum5" codec:"attrNum5"`
	// attrNum6
	AttrNum6 string `yaml:"attrNum6" codec:"attrNum6"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// attrType3
	AttrType3 int `yaml:"attrType3" codec:"attrType3"`
	// attrType4
	AttrType4 int `yaml:"attrType4" codec:"attrType4"`
	// attrType5
	AttrType5 int `yaml:"attrType5" codec:"attrType5"`
	// attrType6
	AttrType6 int `yaml:"attrType6" codec:"attrType6"`
	// gemQualitySeqID
	GemQualitySeqID int `yaml:"gemQualitySeqID" codec:"gemQualitySeqID"`
	// qualityNum
	QualityNum int `yaml:"qualityNum" codec:"qualityNum"`
}
// gem/suit.csv
type Gem_suit struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNum1
	AttrNum1 string `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 string `yaml:"attrNum2" codec:"attrNum2"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// suitID
	SuitID int `yaml:"suitID" codec:"suitID"`
	// suitName
	SuitName string `yaml:"suitName" codec:"suitName"`
	// suitNum
	SuitNum int `yaml:"suitNum" codec:"suitNum"`
	// suitQuality
	SuitQuality int `yaml:"suitQuality" codec:"suitQuality"`
}
// gift.csv
type Gift struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// giftType
	GiftType int `yaml:"giftType" codec:"giftType"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// name
	Name string `yaml:"name" codec:"name"`
	// numMax
	NumMax int `yaml:"numMax" codec:"numMax"`
	// type
	Type int `yaml:"type" codec:"type"`
	// typeMax
	TypeMax int `yaml:"typeMax" codec:"typeMax"`
	// validRoleCreatedDateRange
	ValidRoleCreatedDateRange tjcsv.Slice `yaml:"validRoleCreatedDateRange" codec:"validRoleCreatedDateRange"`
}
// good_feel.csv
type Good_feel struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNum1
	AttrNum1 int `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 int `yaml:"attrNum2" codec:"attrNum2"`
	// attrNum3
	AttrNum3 int `yaml:"attrNum3" codec:"attrNum3"`
	// attrNum4
	AttrNum4 int `yaml:"attrNum4" codec:"attrNum4"`
	// attrNum5
	AttrNum5 int `yaml:"attrNum5" codec:"attrNum5"`
	// attrNum6
	AttrNum6 int `yaml:"attrNum6" codec:"attrNum6"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// attrType3
	AttrType3 int `yaml:"attrType3" codec:"attrType3"`
	// attrType4
	AttrType4 int `yaml:"attrType4" codec:"attrType4"`
	// attrType5
	AttrType5 int `yaml:"attrType5" codec:"attrType5"`
	// attrType6
	AttrType6 int `yaml:"attrType6" codec:"attrType6"`
	// feelType
	FeelType int `yaml:"feelType" codec:"feelType"`
	// level
	Level int `yaml:"level" codec:"level"`
	// needExp
	NeedExp int `yaml:"needExp" codec:"needExp"`
}
// good_feel_effect.csv
type Good_feel_effect struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// addScene
	AddScene int `yaml:"addScene" codec:"addScene"`
	// addType
	AddType int `yaml:"addType" codec:"addType"`
	// attrNum1
	AttrNum1 string `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 string `yaml:"attrNum2" codec:"attrNum2"`
	// attrNum3
	AttrNum3 string `yaml:"attrNum3" codec:"attrNum3"`
	// attrNum4
	AttrNum4 string `yaml:"attrNum4" codec:"attrNum4"`
	// attrNum5
	AttrNum5 string `yaml:"attrNum5" codec:"attrNum5"`
	// attrNum6
	AttrNum6 string `yaml:"attrNum6" codec:"attrNum6"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// attrType3
	AttrType3 int `yaml:"attrType3" codec:"attrType3"`
	// attrType4
	AttrType4 int `yaml:"attrType4" codec:"attrType4"`
	// attrType5
	AttrType5 int `yaml:"attrType5" codec:"attrType5"`
	// attrType6
	AttrType6 int `yaml:"attrType6" codec:"attrType6"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// level
	Level int `yaml:"level" codec:"level"`
	// markID
	MarkID int `yaml:"markID" codec:"markID"`
	// natureType
	NatureType int `yaml:"natureType" codec:"natureType"`
}
// grow_guide.csv
type Grow_guide struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// feature
	Feature string `yaml:"feature" codec:"feature"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// items
	Items tjcsv.Slice `yaml:"items" codec:"items"`
	// name
	Name string `yaml:"name" codec:"name"`
	// res
	Res string `yaml:"res" codec:"res"`
	// taskDesc
	TaskDesc string `yaml:"taskDesc" codec:"taskDesc"`
	// taskParam
	TaskParam int `yaml:"taskParam" codec:"taskParam"`
	// taskType
	TaskType int `yaml:"taskType" codec:"taskType"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// gym
type Gym struct {
	// gym/gate.csv
	Gate map[int]*Gym_gate `yaml:"gate" codec:"gate"`
	// gym/gym.csv
	Gym map[int]*Gym_gym `yaml:"gym" codec:"gym"`
	// gym/npc.csv
	Npc map[int]*Gym_npc `yaml:"npc" codec:"npc"`
	// gym/talent_buff.csv
	Talent_buff map[int]*Gym_talent_buff `yaml:"talent_buff" codec:"talent_buff"`
	// gym/talent_cost.csv
	Talent_cost map[int]*Gym_talent_cost `yaml:"talent_cost" codec:"talent_cost"`
	// gym/talent_tree.csv
	Talent_tree map[int]*Gym_talent_tree `yaml:"talent_tree" codec:"talent_tree"`
}
// gym/gate.csv
type Gym_gate struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// deployCardNumLimit
	DeployCardNumLimit int `yaml:"deployCardNumLimit" codec:"deployCardNumLimit"`
	// deployNatureLimit
	DeployNatureLimit tjcsv.Slice `yaml:"deployNatureLimit" codec:"deployNatureLimit"`
	// deployNum
	DeployNum int `yaml:"deployNum" codec:"deployNum"`
	// deployType
	DeployType int `yaml:"deployType" codec:"deployType"`
	// gymID
	GymID int `yaml:"gymID" codec:"gymID"`
	// hardDegree
	HardDegree int `yaml:"hardDegree" codec:"hardDegree"`
	// historyJump
	HistoryJump int `yaml:"historyJump" codec:"historyJump"`
	// lastJump
	LastJump int `yaml:"lastJump" codec:"lastJump"`
	// npc
	Npc bool `yaml:"npc" codec:"npc"`
	// palce
	Palce string `yaml:"palce" codec:"palce"`
	// placeDesc
	PlaceDesc string `yaml:"placeDesc" codec:"placeDesc"`
	// specialEff
	SpecialEff tjcsv.Slice `yaml:"specialEff" codec:"specialEff"`
	// specialEffDesc
	SpecialEffDesc string `yaml:"specialEffDesc" codec:"specialEffDesc"`
	// weatherDesc
	WeatherDesc string `yaml:"weatherDesc" codec:"weatherDesc"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
}
// gym/gym.csv
type Gym_gym struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// crossLeaderAward
	CrossLeaderAward tjcsv.Map `yaml:"crossLeaderAward" codec:"crossLeaderAward"`
	// crossLeaderAwardDesc
	CrossLeaderAwardDesc string `yaml:"crossLeaderAwardDesc" codec:"crossLeaderAwardDesc"`
	// crossSubAward
	CrossSubAward tjcsv.Map `yaml:"crossSubAward" codec:"crossSubAward"`
	// crossSubAwardDesc
	CrossSubAwardDesc string `yaml:"crossSubAwardDesc" codec:"crossSubAwardDesc"`
	// fontColor
	FontColor string `yaml:"fontColor" codec:"fontColor"`
	// gateAward
	GateAward tjcsv.Map `yaml:"gateAward" codec:"gateAward"`
	// hardDegreeID
	HardDegreeID tjcsv.Slice `yaml:"hardDegreeID" codec:"hardDegreeID"`
	// leaderAward
	LeaderAward tjcsv.Map `yaml:"leaderAward" codec:"leaderAward"`
	// leaderAwardDesc
	LeaderAwardDesc string `yaml:"leaderAwardDesc" codec:"leaderAwardDesc"`
	// limitAttribute
	LimitAttribute tjcsv.Slice `yaml:"limitAttribute" codec:"limitAttribute"`
	// name
	Name string `yaml:"name" codec:"name"`
	// namePng
	NamePng string `yaml:"namePng" codec:"namePng"`
	// npcID
	NpcID int `yaml:"npcID" codec:"npcID"`
	// pos
	Pos tjcsv.Map `yaml:"pos" codec:"pos"`
	// posSkew
	PosSkew tjcsv.Map `yaml:"posSkew" codec:"posSkew"`
	// preGymID
	PreGymID int `yaml:"preGymID" codec:"preGymID"`
	// spine
	Spine string `yaml:"spine" codec:"spine"`
	// texture
	Texture string `yaml:"texture" codec:"texture"`
}
// gym/npc.csv
type Gym_npc struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// expertise
	Expertise string `yaml:"expertise" codec:"expertise"`
	// figure
	Figure int `yaml:"figure" codec:"figure"`
}
// gym/talent_buff.csv
type Gym_talent_buff struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNum1
	AttrNum1 tjcsv.Slice `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 tjcsv.Slice `yaml:"attrNum2" codec:"attrNum2"`
	// attrNum3
	AttrNum3 tjcsv.Slice `yaml:"attrNum3" codec:"attrNum3"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// attrType3
	AttrType3 int `yaml:"attrType3" codec:"attrType3"`
	// costID
	CostID int `yaml:"costID" codec:"costID"`
	// depth
	Depth int `yaml:"depth" codec:"depth"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// effectType
	EffectType int `yaml:"effectType" codec:"effectType"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// iconRate
	IconRate int `yaml:"iconRate" codec:"iconRate"`
	// levelUp
	LevelUp int `yaml:"levelUp" codec:"levelUp"`
	// name
	Name string `yaml:"name" codec:"name"`
	// preLevel
	PreLevel int `yaml:"preLevel" codec:"preLevel"`
	// preTalentIDs
	PreTalentIDs tjcsv.Slice `yaml:"preTalentIDs" codec:"preTalentIDs"`
	// skillID
	SkillID int `yaml:"skillID" codec:"skillID"`
	// treeID
	TreeID int `yaml:"treeID" codec:"treeID"`
}
// gym/talent_cost.csv
type Gym_talent_cost struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// cost1
	Cost1 tjcsv.Map `yaml:"cost1" codec:"cost1"`
	// cost2
	Cost2 tjcsv.Map `yaml:"cost2" codec:"cost2"`
	// cost3
	Cost3 tjcsv.Map `yaml:"cost3" codec:"cost3"`
	// cost4
	Cost4 tjcsv.Map `yaml:"cost4" codec:"cost4"`
	// cost5
	Cost5 tjcsv.Map `yaml:"cost5" codec:"cost5"`
}
// gym/talent_tree.csv
type Gym_talent_tree struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// name
	Name string `yaml:"name" codec:"name"`
	// prePointNum
	PrePointNum int `yaml:"prePointNum" codec:"prePointNum"`
	// preTreeID
	PreTreeID tjcsv.Slice `yaml:"preTreeID" codec:"preTreeID"`
}
// gym_badge
type Gym_badge struct {
	// gym_badge/awake_cost.csv
	Awake_cost map[int]*Gym_badge_awake_cost `yaml:"awake_cost" codec:"awake_cost"`
	// gym_badge/badge.csv
	Badge map[int]*Gym_badge_badge `yaml:"badge" codec:"badge"`
	// gym_badge/guard.csv
	Guard map[int]*Gym_badge_guard `yaml:"guard" codec:"guard"`
	// gym_badge/guard_effect.csv
	Guard_effect map[int]*Gym_badge_guard_effect `yaml:"guard_effect" codec:"guard_effect"`
	// gym_badge/talent.csv
	Talent map[int]*Gym_badge_talent `yaml:"talent" codec:"talent"`
	// gym_badge/talent_cost.csv
	Talent_cost map[int]*Gym_badge_talent_cost `yaml:"talent_cost" codec:"talent_cost"`
}
// gym_badge/awake_cost.csv
type Gym_badge_awake_cost struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// cost1
	Cost1 tjcsv.Map `yaml:"cost1" codec:"cost1"`
	// cost2
	Cost2 tjcsv.Map `yaml:"cost2" codec:"cost2"`
	// cost3
	Cost3 tjcsv.Map `yaml:"cost3" codec:"cost3"`
	// cost4
	Cost4 tjcsv.Map `yaml:"cost4" codec:"cost4"`
	// cost5
	Cost5 tjcsv.Map `yaml:"cost5" codec:"cost5"`
	// cost6
	Cost6 tjcsv.Map `yaml:"cost6" codec:"cost6"`
	// cost7
	Cost7 tjcsv.Map `yaml:"cost7" codec:"cost7"`
	// cost8
	Cost8 tjcsv.Map `yaml:"cost8" codec:"cost8"`
}
// gym_badge/badge.csv
type Gym_badge_badge struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNum1
	AttrNum1 tjcsv.Slice `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 tjcsv.Slice `yaml:"attrNum2" codec:"attrNum2"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// awakeCostSeqID
	AwakeCostSeqID int `yaml:"awakeCostSeqID" codec:"awakeCostSeqID"`
	// awakeMaxLevel
	AwakeMaxLevel int `yaml:"awakeMaxLevel" codec:"awakeMaxLevel"`
	// awakeTalentAttrs
	AwakeTalentAttrs tjcsv.Slice `yaml:"awakeTalentAttrs" codec:"awakeTalentAttrs"`
	// guardIDs
	GuardIDs tjcsv.Slice `yaml:"guardIDs" codec:"guardIDs"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// name
	Name string `yaml:"name" codec:"name"`
	// nature
	Nature tjcsv.Slice `yaml:"nature" codec:"nature"`
	// preBadgeID
	PreBadgeID int `yaml:"preBadgeID" codec:"preBadgeID"`
	// preBadgeType
	PreBadgeType int `yaml:"preBadgeType" codec:"preBadgeType"`
	// preLevel
	PreLevel int `yaml:"preLevel" codec:"preLevel"`
	// preTalentLevel
	PreTalentLevel tjcsv.Slice `yaml:"preTalentLevel" codec:"preTalentLevel"`
	// showIcon1
	ShowIcon1 string `yaml:"showIcon1" codec:"showIcon1"`
	// showIcon2
	ShowIcon2 string `yaml:"showIcon2" codec:"showIcon2"`
	// showIcon3
	ShowIcon3 string `yaml:"showIcon3" codec:"showIcon3"`
	// talentIDs
	TalentIDs tjcsv.Slice `yaml:"talentIDs" codec:"talentIDs"`
	// talentMaxLevel
	TalentMaxLevel int `yaml:"talentMaxLevel" codec:"talentMaxLevel"`
}
// gym_badge/guard.csv
type Gym_badge_guard struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// isOpen
	IsOpen bool `yaml:"isOpen" codec:"isOpen"`
	// openCondition
	OpenCondition int `yaml:"openCondition" codec:"openCondition"`
	// openCost
	OpenCost tjcsv.Map `yaml:"openCost" codec:"openCost"`
	// openParam
	OpenParam int `yaml:"openParam" codec:"openParam"`
}
// gym_badge/guard_effect.csv
type Gym_badge_guard_effect struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// advanceAttrs
	AdvanceAttrs tjcsv.Slice `yaml:"advanceAttrs" codec:"advanceAttrs"`
	// natureAttr
	NatureAttr string `yaml:"natureAttr" codec:"natureAttr"`
	// nvalueAttrs
	NvalueAttrs tjcsv.Map `yaml:"nvalueAttrs" codec:"nvalueAttrs"`
	// rarityAttr
	RarityAttr string `yaml:"rarityAttr" codec:"rarityAttr"`
	// starAttrs
	StarAttrs tjcsv.Slice `yaml:"starAttrs" codec:"starAttrs"`
}
// gym_badge/talent.csv
type Gym_badge_talent struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNum1
	AttrNum1 tjcsv.Slice `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 tjcsv.Slice `yaml:"attrNum2" codec:"attrNum2"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// costSeqID
	CostSeqID int `yaml:"costSeqID" codec:"costSeqID"`
	// icon
	Icon interface{} `yaml:"icon" codec:"icon"`
	// name
	Name string `yaml:"name" codec:"name"`
}
// gym_badge/talent_cost.csv
type Gym_badge_talent_cost struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// cost1
	Cost1 tjcsv.Map `yaml:"cost1" codec:"cost1"`
	// cost2
	Cost2 tjcsv.Map `yaml:"cost2" codec:"cost2"`
	// cost3
	Cost3 tjcsv.Map `yaml:"cost3" codec:"cost3"`
	// cost4
	Cost4 tjcsv.Map `yaml:"cost4" codec:"cost4"`
	// cost5
	Cost5 tjcsv.Map `yaml:"cost5" codec:"cost5"`
	// cost6
	Cost6 tjcsv.Map `yaml:"cost6" codec:"cost6"`
	// cost7
	Cost7 tjcsv.Map `yaml:"cost7" codec:"cost7"`
	// cost8
	Cost8 tjcsv.Map `yaml:"cost8" codec:"cost8"`
}
// held_item
type Held_item struct {
	// held_item/advance.csv
	Advance map[int]*Held_item_advance `yaml:"advance" codec:"advance"`
	// held_item/advance_attrs.csv
	Advance_attrs map[int]*Held_item_advance_attrs `yaml:"advance_attrs" codec:"advance_attrs"`
	// held_item/effect.csv
	Effect map[int]*Held_item_effect `yaml:"effect" codec:"effect"`
	// held_item/items.csv
	Items map[int]*Held_item_items `yaml:"items" codec:"items"`
	// held_item/level.csv
	Level map[int]*Held_item_level `yaml:"level" codec:"level"`
	// held_item/level_attrs.csv
	Level_attrs map[int]*Held_item_level_attrs `yaml:"level_attrs" codec:"level_attrs"`
	// held_item/shop.csv
	Shop map[int]*Held_item_shop `yaml:"shop" codec:"shop"`
}
// held_item/advance.csv
type Held_item_advance struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// costItemMap1
	CostItemMap1 tjcsv.Map `yaml:"costItemMap1" codec:"costItemMap1"`
	// costItemMap10
	CostItemMap10 tjcsv.Map `yaml:"costItemMap10" codec:"costItemMap10"`
	// costItemMap100
	CostItemMap100 tjcsv.Map `yaml:"costItemMap100" codec:"costItemMap100"`
	// costItemMap101
	CostItemMap101 tjcsv.Map `yaml:"costItemMap101" codec:"costItemMap101"`
	// costItemMap102
	CostItemMap102 tjcsv.Map `yaml:"costItemMap102" codec:"costItemMap102"`
	// costItemMap103
	CostItemMap103 tjcsv.Map `yaml:"costItemMap103" codec:"costItemMap103"`
	// costItemMap11
	CostItemMap11 tjcsv.Map `yaml:"costItemMap11" codec:"costItemMap11"`
	// costItemMap12
	CostItemMap12 tjcsv.Map `yaml:"costItemMap12" codec:"costItemMap12"`
	// costItemMap13
	CostItemMap13 tjcsv.Map `yaml:"costItemMap13" codec:"costItemMap13"`
	// costItemMap14
	CostItemMap14 tjcsv.Map `yaml:"costItemMap14" codec:"costItemMap14"`
	// costItemMap15
	CostItemMap15 tjcsv.Map `yaml:"costItemMap15" codec:"costItemMap15"`
	// costItemMap16
	CostItemMap16 tjcsv.Map `yaml:"costItemMap16" codec:"costItemMap16"`
	// costItemMap17
	CostItemMap17 tjcsv.Map `yaml:"costItemMap17" codec:"costItemMap17"`
	// costItemMap18
	CostItemMap18 tjcsv.Map `yaml:"costItemMap18" codec:"costItemMap18"`
	// costItemMap19
	CostItemMap19 tjcsv.Map `yaml:"costItemMap19" codec:"costItemMap19"`
	// costItemMap2
	CostItemMap2 tjcsv.Map `yaml:"costItemMap2" codec:"costItemMap2"`
	// costItemMap20
	CostItemMap20 tjcsv.Map `yaml:"costItemMap20" codec:"costItemMap20"`
	// costItemMap21
	CostItemMap21 tjcsv.Map `yaml:"costItemMap21" codec:"costItemMap21"`
	// costItemMap22
	CostItemMap22 tjcsv.Map `yaml:"costItemMap22" codec:"costItemMap22"`
	// costItemMap23
	CostItemMap23 tjcsv.Map `yaml:"costItemMap23" codec:"costItemMap23"`
	// costItemMap24
	CostItemMap24 tjcsv.Map `yaml:"costItemMap24" codec:"costItemMap24"`
	// costItemMap25
	CostItemMap25 tjcsv.Map `yaml:"costItemMap25" codec:"costItemMap25"`
	// costItemMap26
	CostItemMap26 tjcsv.Map `yaml:"costItemMap26" codec:"costItemMap26"`
	// costItemMap27
	CostItemMap27 tjcsv.Map `yaml:"costItemMap27" codec:"costItemMap27"`
	// costItemMap28
	CostItemMap28 tjcsv.Map `yaml:"costItemMap28" codec:"costItemMap28"`
	// costItemMap29
	CostItemMap29 tjcsv.Map `yaml:"costItemMap29" codec:"costItemMap29"`
	// costItemMap3
	CostItemMap3 tjcsv.Map `yaml:"costItemMap3" codec:"costItemMap3"`
	// costItemMap30
	CostItemMap30 tjcsv.Map `yaml:"costItemMap30" codec:"costItemMap30"`
	// costItemMap31
	CostItemMap31 tjcsv.Map `yaml:"costItemMap31" codec:"costItemMap31"`
	// costItemMap32
	CostItemMap32 tjcsv.Map `yaml:"costItemMap32" codec:"costItemMap32"`
	// costItemMap33
	CostItemMap33 tjcsv.Map `yaml:"costItemMap33" codec:"costItemMap33"`
	// costItemMap34
	CostItemMap34 tjcsv.Map `yaml:"costItemMap34" codec:"costItemMap34"`
	// costItemMap35
	CostItemMap35 tjcsv.Map `yaml:"costItemMap35" codec:"costItemMap35"`
	// costItemMap36
	CostItemMap36 tjcsv.Map `yaml:"costItemMap36" codec:"costItemMap36"`
	// costItemMap37
	CostItemMap37 tjcsv.Map `yaml:"costItemMap37" codec:"costItemMap37"`
	// costItemMap38
	CostItemMap38 tjcsv.Map `yaml:"costItemMap38" codec:"costItemMap38"`
	// costItemMap39
	CostItemMap39 tjcsv.Map `yaml:"costItemMap39" codec:"costItemMap39"`
	// costItemMap4
	CostItemMap4 tjcsv.Map `yaml:"costItemMap4" codec:"costItemMap4"`
	// costItemMap40
	CostItemMap40 tjcsv.Map `yaml:"costItemMap40" codec:"costItemMap40"`
	// costItemMap41
	CostItemMap41 tjcsv.Map `yaml:"costItemMap41" codec:"costItemMap41"`
	// costItemMap42
	CostItemMap42 tjcsv.Map `yaml:"costItemMap42" codec:"costItemMap42"`
	// costItemMap43
	CostItemMap43 tjcsv.Map `yaml:"costItemMap43" codec:"costItemMap43"`
	// costItemMap44
	CostItemMap44 tjcsv.Map `yaml:"costItemMap44" codec:"costItemMap44"`
	// costItemMap45
	CostItemMap45 tjcsv.Map `yaml:"costItemMap45" codec:"costItemMap45"`
	// costItemMap46
	CostItemMap46 tjcsv.Map `yaml:"costItemMap46" codec:"costItemMap46"`
	// costItemMap47
	CostItemMap47 tjcsv.Map `yaml:"costItemMap47" codec:"costItemMap47"`
	// costItemMap48
	CostItemMap48 tjcsv.Map `yaml:"costItemMap48" codec:"costItemMap48"`
	// costItemMap49
	CostItemMap49 tjcsv.Map `yaml:"costItemMap49" codec:"costItemMap49"`
	// costItemMap5
	CostItemMap5 tjcsv.Map `yaml:"costItemMap5" codec:"costItemMap5"`
	// costItemMap50
	CostItemMap50 tjcsv.Map `yaml:"costItemMap50" codec:"costItemMap50"`
	// costItemMap51
	CostItemMap51 tjcsv.Map `yaml:"costItemMap51" codec:"costItemMap51"`
	// costItemMap52
	CostItemMap52 tjcsv.Map `yaml:"costItemMap52" codec:"costItemMap52"`
	// costItemMap53
	CostItemMap53 tjcsv.Map `yaml:"costItemMap53" codec:"costItemMap53"`
	// costItemMap54
	CostItemMap54 tjcsv.Map `yaml:"costItemMap54" codec:"costItemMap54"`
	// costItemMap55
	CostItemMap55 tjcsv.Map `yaml:"costItemMap55" codec:"costItemMap55"`
	// costItemMap56
	CostItemMap56 tjcsv.Map `yaml:"costItemMap56" codec:"costItemMap56"`
	// costItemMap57
	CostItemMap57 tjcsv.Map `yaml:"costItemMap57" codec:"costItemMap57"`
	// costItemMap58
	CostItemMap58 tjcsv.Map `yaml:"costItemMap58" codec:"costItemMap58"`
	// costItemMap59
	CostItemMap59 tjcsv.Map `yaml:"costItemMap59" codec:"costItemMap59"`
	// costItemMap6
	CostItemMap6 tjcsv.Map `yaml:"costItemMap6" codec:"costItemMap6"`
	// costItemMap60
	CostItemMap60 tjcsv.Map `yaml:"costItemMap60" codec:"costItemMap60"`
	// costItemMap61
	CostItemMap61 tjcsv.Map `yaml:"costItemMap61" codec:"costItemMap61"`
	// costItemMap62
	CostItemMap62 tjcsv.Map `yaml:"costItemMap62" codec:"costItemMap62"`
	// costItemMap63
	CostItemMap63 tjcsv.Map `yaml:"costItemMap63" codec:"costItemMap63"`
	// costItemMap64
	CostItemMap64 tjcsv.Map `yaml:"costItemMap64" codec:"costItemMap64"`
	// costItemMap65
	CostItemMap65 tjcsv.Map `yaml:"costItemMap65" codec:"costItemMap65"`
	// costItemMap66
	CostItemMap66 tjcsv.Map `yaml:"costItemMap66" codec:"costItemMap66"`
	// costItemMap67
	CostItemMap67 tjcsv.Map `yaml:"costItemMap67" codec:"costItemMap67"`
	// costItemMap68
	CostItemMap68 tjcsv.Map `yaml:"costItemMap68" codec:"costItemMap68"`
	// costItemMap69
	CostItemMap69 tjcsv.Map `yaml:"costItemMap69" codec:"costItemMap69"`
	// costItemMap7
	CostItemMap7 tjcsv.Map `yaml:"costItemMap7" codec:"costItemMap7"`
	// costItemMap70
	CostItemMap70 tjcsv.Map `yaml:"costItemMap70" codec:"costItemMap70"`
	// costItemMap71
	CostItemMap71 tjcsv.Map `yaml:"costItemMap71" codec:"costItemMap71"`
	// costItemMap72
	CostItemMap72 tjcsv.Map `yaml:"costItemMap72" codec:"costItemMap72"`
	// costItemMap73
	CostItemMap73 tjcsv.Map `yaml:"costItemMap73" codec:"costItemMap73"`
	// costItemMap74
	CostItemMap74 tjcsv.Map `yaml:"costItemMap74" codec:"costItemMap74"`
	// costItemMap75
	CostItemMap75 tjcsv.Map `yaml:"costItemMap75" codec:"costItemMap75"`
	// costItemMap76
	CostItemMap76 tjcsv.Map `yaml:"costItemMap76" codec:"costItemMap76"`
	// costItemMap77
	CostItemMap77 tjcsv.Map `yaml:"costItemMap77" codec:"costItemMap77"`
	// costItemMap78
	CostItemMap78 tjcsv.Map `yaml:"costItemMap78" codec:"costItemMap78"`
	// costItemMap79
	CostItemMap79 tjcsv.Map `yaml:"costItemMap79" codec:"costItemMap79"`
	// costItemMap8
	CostItemMap8 tjcsv.Map `yaml:"costItemMap8" codec:"costItemMap8"`
	// costItemMap80
	CostItemMap80 tjcsv.Map `yaml:"costItemMap80" codec:"costItemMap80"`
	// costItemMap81
	CostItemMap81 tjcsv.Map `yaml:"costItemMap81" codec:"costItemMap81"`
	// costItemMap82
	CostItemMap82 tjcsv.Map `yaml:"costItemMap82" codec:"costItemMap82"`
	// costItemMap83
	CostItemMap83 tjcsv.Map `yaml:"costItemMap83" codec:"costItemMap83"`
	// costItemMap84
	CostItemMap84 tjcsv.Map `yaml:"costItemMap84" codec:"costItemMap84"`
	// costItemMap85
	CostItemMap85 tjcsv.Map `yaml:"costItemMap85" codec:"costItemMap85"`
	// costItemMap86
	CostItemMap86 tjcsv.Map `yaml:"costItemMap86" codec:"costItemMap86"`
	// costItemMap87
	CostItemMap87 tjcsv.Map `yaml:"costItemMap87" codec:"costItemMap87"`
	// costItemMap88
	CostItemMap88 tjcsv.Map `yaml:"costItemMap88" codec:"costItemMap88"`
	// costItemMap89
	CostItemMap89 tjcsv.Map `yaml:"costItemMap89" codec:"costItemMap89"`
	// costItemMap9
	CostItemMap9 tjcsv.Map `yaml:"costItemMap9" codec:"costItemMap9"`
	// costItemMap90
	CostItemMap90 tjcsv.Map `yaml:"costItemMap90" codec:"costItemMap90"`
	// costItemMap91
	CostItemMap91 tjcsv.Map `yaml:"costItemMap91" codec:"costItemMap91"`
	// costItemMap92
	CostItemMap92 tjcsv.Map `yaml:"costItemMap92" codec:"costItemMap92"`
	// costItemMap93
	CostItemMap93 tjcsv.Map `yaml:"costItemMap93" codec:"costItemMap93"`
	// costItemMap94
	CostItemMap94 tjcsv.Map `yaml:"costItemMap94" codec:"costItemMap94"`
	// costItemMap95
	CostItemMap95 tjcsv.Map `yaml:"costItemMap95" codec:"costItemMap95"`
	// costItemMap96
	CostItemMap96 tjcsv.Map `yaml:"costItemMap96" codec:"costItemMap96"`
	// costItemMap97
	CostItemMap97 tjcsv.Map `yaml:"costItemMap97" codec:"costItemMap97"`
	// costItemMap98
	CostItemMap98 tjcsv.Map `yaml:"costItemMap98" codec:"costItemMap98"`
	// costItemMap99
	CostItemMap99 tjcsv.Map `yaml:"costItemMap99" codec:"costItemMap99"`
}
// held_item/advance_attrs.csv
type Held_item_advance_attrs struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNum1
	AttrNum1 tjcsv.Slice `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 tjcsv.Slice `yaml:"attrNum2" codec:"attrNum2"`
	// attrNum3
	AttrNum3 tjcsv.Slice `yaml:"attrNum3" codec:"attrNum3"`
	// attrNum4
	AttrNum4 tjcsv.Slice `yaml:"attrNum4" codec:"attrNum4"`
	// attrNum5
	AttrNum5 tjcsv.Slice `yaml:"attrNum5" codec:"attrNum5"`
	// attrNum6
	AttrNum6 tjcsv.Slice `yaml:"attrNum6" codec:"attrNum6"`
	// attrRate1
	AttrRate1 tjcsv.Slice `yaml:"attrRate1" codec:"attrRate1"`
	// attrRate2
	AttrRate2 tjcsv.Slice `yaml:"attrRate2" codec:"attrRate2"`
	// attrRate3
	AttrRate3 tjcsv.Slice `yaml:"attrRate3" codec:"attrRate3"`
	// attrRate4
	AttrRate4 tjcsv.Slice `yaml:"attrRate4" codec:"attrRate4"`
	// attrRate5
	AttrRate5 tjcsv.Slice `yaml:"attrRate5" codec:"attrRate5"`
	// attrRate6
	AttrRate6 tjcsv.Slice `yaml:"attrRate6" codec:"attrRate6"`
}
// held_item/effect.csv
type Held_item_effect struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNum1
	AttrNum1 tjcsv.Slice `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 tjcsv.Slice `yaml:"attrNum2" codec:"attrNum2"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// exclusiveCards
	ExclusiveCards tjcsv.Slice `yaml:"exclusiveCards" codec:"exclusiveCards"`
	// skillID
	SkillID int `yaml:"skillID" codec:"skillID"`
	// type
	Type int `yaml:"type" codec:"type"`
	// viceAttrRate
	ViceAttrRate float64 `yaml:"viceAttrRate" codec:"viceAttrRate"`
	// viceSkillID
	ViceSkillID int `yaml:"viceSkillID" codec:"viceSkillID"`
}
// held_item/items.csv
type Held_item_items struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// advanceAttrSeq
	AdvanceAttrSeq int `yaml:"advanceAttrSeq" codec:"advanceAttrSeq"`
	// advanceLvLimit
	AdvanceLvLimit tjcsv.Slice `yaml:"advanceLvLimit" codec:"advanceLvLimit"`
	// advanceMax
	AdvanceMax int `yaml:"advanceMax" codec:"advanceMax"`
	// advanceSeqID
	AdvanceSeqID int `yaml:"advanceSeqID" codec:"advanceSeqID"`
	// attrNumRates
	AttrNumRates tjcsv.Slice `yaml:"attrNumRates" codec:"attrNumRates"`
	// attrTypes
	AttrTypes tjcsv.Slice `yaml:"attrTypes" codec:"attrTypes"`
	// effect
	Effect tjcsv.Map `yaml:"effect" codec:"effect"`
	// effect1
	Effect1 int `yaml:"effect1" codec:"effect1"`
	// effect1LevelAdvSeq
	Effect1LevelAdvSeq tjcsv.Slice `yaml:"effect1LevelAdvSeq" codec:"effect1LevelAdvSeq"`
	// effect2
	Effect2 int `yaml:"effect2" codec:"effect2"`
	// effect2LevelAdvSeq
	Effect2LevelAdvSeq tjcsv.Slice `yaml:"effect2LevelAdvSeq" codec:"effect2LevelAdvSeq"`
	// exclusiveCards
	ExclusiveCards tjcsv.Slice `yaml:"exclusiveCards" codec:"exclusiveCards"`
	// fragID
	FragID int `yaml:"fragID" codec:"fragID"`
	// heldItemExp
	HeldItemExp int `yaml:"heldItemExp" codec:"heldItemExp"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// itemsShow
	ItemsShow bool `yaml:"itemsShow" codec:"itemsShow"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// name
	Name string `yaml:"name" codec:"name"`
	// produceDesc
	ProduceDesc string `yaml:"produceDesc" codec:"produceDesc"`
	// produceGate1
	ProduceGate1 interface{} `yaml:"produceGate1" codec:"produceGate1"`
	// produceGate2
	ProduceGate2 interface{} `yaml:"produceGate2" codec:"produceGate2"`
	// produceGate3
	ProduceGate3 interface{} `yaml:"produceGate3" codec:"produceGate3"`
	// quality
	Quality int `yaml:"quality" codec:"quality"`
	// rebirthRMB
	RebirthRMB int `yaml:"rebirthRMB" codec:"rebirthRMB"`
	// stackShow
	StackShow int `yaml:"stackShow" codec:"stackShow"`
	// strengthAttrSeq
	StrengthAttrSeq int `yaml:"strengthAttrSeq" codec:"strengthAttrSeq"`
	// strengthMax
	StrengthMax int `yaml:"strengthMax" codec:"strengthMax"`
	// strengthSeqID
	StrengthSeqID int `yaml:"strengthSeqID" codec:"strengthSeqID"`
	// universalItems
	UniversalItems tjcsv.Slice `yaml:"universalItems" codec:"universalItems"`
	// viceAttrRate
	ViceAttrRate float64 `yaml:"viceAttrRate" codec:"viceAttrRate"`
}
// held_item/level.csv
type Held_item_level struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// levelExp1
	LevelExp1 int `yaml:"levelExp1" codec:"levelExp1"`
	// levelExp2
	LevelExp2 int `yaml:"levelExp2" codec:"levelExp2"`
	// levelExp3
	LevelExp3 int `yaml:"levelExp3" codec:"levelExp3"`
	// levelExp4
	LevelExp4 int `yaml:"levelExp4" codec:"levelExp4"`
	// levelExp5
	LevelExp5 int `yaml:"levelExp5" codec:"levelExp5"`
	// levelExp6
	LevelExp6 int `yaml:"levelExp6" codec:"levelExp6"`
}
// held_item/level_attrs.csv
type Held_item_level_attrs struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNum1
	AttrNum1 tjcsv.Slice `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 tjcsv.Slice `yaml:"attrNum2" codec:"attrNum2"`
	// attrNum3
	AttrNum3 tjcsv.Slice `yaml:"attrNum3" codec:"attrNum3"`
	// attrNum4
	AttrNum4 tjcsv.Slice `yaml:"attrNum4" codec:"attrNum4"`
	// attrNum5
	AttrNum5 tjcsv.Slice `yaml:"attrNum5" codec:"attrNum5"`
	// attrNum6
	AttrNum6 tjcsv.Slice `yaml:"attrNum6" codec:"attrNum6"`
}
// held_item/shop.csv
type Held_item_shop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// exchangeLimit
	ExchangeLimit int `yaml:"exchangeLimit" codec:"exchangeLimit"`
	// itemMap
	ItemMap tjcsv.Map `yaml:"itemMap" codec:"itemMap"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
	// limitTimes
	LimitTimes int `yaml:"limitTimes" codec:"limitTimes"`
	// limitType
	LimitType int `yaml:"limitType" codec:"limitType"`
	// regainHour
	RegainHour int `yaml:"regainHour" codec:"regainHour"`
	// showUnable
	ShowUnable bool `yaml:"showUnable" codec:"showUnable"`
	// sortValue
	SortValue int `yaml:"sortValue" codec:"sortValue"`
	// vipStart
	VipStart int `yaml:"vipStart" codec:"vipStart"`
}
// homeland
type Homeland struct {
	// homeland/furniture.csv
	Furniture map[int]*Homeland_furniture `yaml:"furniture" codec:"furniture"`
	// homeland/home.csv
	Home map[int]*Homeland_home `yaml:"home" codec:"home"`
	// homeland/home_default.csv
	Home_default map[int]*Homeland_home_default `yaml:"home_default" codec:"home_default"`
	// homeland/wall_floor.csv
	Wall_floor map[int]*Homeland_wall_floor `yaml:"wall_floor" codec:"wall_floor"`
}
// homeland/furniture.csv
type Homeland_furniture struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attr
	Attr tjcsv.Map `yaml:"attr" codec:"attr"`
	// attrAdd
	AttrAdd tjcsv.Map `yaml:"attrAdd" codec:"attrAdd"`
	// classify
	Classify int `yaml:"classify" codec:"classify"`
	// currentNum
	CurrentNum bool `yaml:"currentNum" codec:"currentNum"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// interactivityAttr
	InteractivityAttr tjcsv.Map `yaml:"interactivityAttr" codec:"interactivityAttr"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// name
	Name string `yaml:"name" codec:"name"`
	// position
	Position int `yaml:"position" codec:"position"`
	// quality
	Quality int `yaml:"quality" codec:"quality"`
	// relSize
	RelSize tjcsv.Map `yaml:"relSize" codec:"relSize"`
	// res
	Res string `yaml:"res" codec:"res"`
	// roleActionDatas
	RoleActionDatas tjcsv.Map `yaml:"roleActionDatas" codec:"roleActionDatas"`
	// size
	Size tjcsv.Map `yaml:"size" codec:"size"`
	// stackMax
	StackMax int `yaml:"stackMax" codec:"stackMax"`
	// startPos
	StartPos tjcsv.Map `yaml:"startPos" codec:"startPos"`
	// startResScale
	StartResScale float64 `yaml:"startResScale" codec:"startResScale"`
	// theme
	Theme int `yaml:"theme" codec:"theme"`
	// touchSize
	TouchSize tjcsv.Map `yaml:"touchSize" codec:"touchSize"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// homeland/home.csv
type Homeland_home struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// defaultIDs
	DefaultIDs tjcsv.Map `yaml:"defaultIDs" codec:"defaultIDs"`
	// name
	Name string `yaml:"name" codec:"name"`
	// roleNum
	RoleNum int `yaml:"roleNum" codec:"roleNum"`
	// unLockLv
	UnLockLv tjcsv.Slice `yaml:"unLockLv" codec:"unLockLv"`
}
// homeland/home_default.csv
type Homeland_home_default struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// defaultCards
	DefaultCards tjcsv.Slice `yaml:"defaultCards" codec:"defaultCards"`
	// defaultFurns
	DefaultFurns tjcsv.Slice `yaml:"defaultFurns" codec:"defaultFurns"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// layerID
	LayerID int `yaml:"layerID" codec:"layerID"`
}
// homeland/wall_floor.csv
type Homeland_wall_floor struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attr
	Attr tjcsv.Map `yaml:"attr" codec:"attr"`
	// furnId
	FurnId int `yaml:"furnId" codec:"furnId"`
	// res
	Res string `yaml:"res" codec:"res"`
	// roomID
	RoomID int `yaml:"roomID" codec:"roomID"`
	// size
	Size tjcsv.Map `yaml:"size" codec:"size"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// huodong.csv
type Huodong struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// awardDesc
	AwardDesc tjcsv.Slice `yaml:"awardDesc" codec:"awardDesc"`
	// background
	Background string `yaml:"background" codec:"background"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// beginTime
	BeginTime int `yaml:"beginTime" codec:"beginTime"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// endTime
	EndTime int `yaml:"endTime" codec:"endTime"`
	// gateLimitSeq
	GateLimitSeq tjcsv.Slice `yaml:"gateLimitSeq" codec:"gateLimitSeq"`
	// gateSeq
	GateSeq tjcsv.Slice `yaml:"gateSeq" codec:"gateSeq"`
	// gateSeq2
	GateSeq2 tjcsv.Slice `yaml:"gateSeq2" codec:"gateSeq2"`
	// huodongType
	HuodongType int `yaml:"huodongType" codec:"huodongType"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// intervalCD
	IntervalCD int `yaml:"intervalCD" codec:"intervalCD"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// name
	Name string `yaml:"name" codec:"name"`
	// openDuration
	OpenDuration int `yaml:"openDuration" codec:"openDuration"`
	// openLevel
	OpenLevel int `yaml:"openLevel" codec:"openLevel"`
	// openTimeDesc
	OpenTimeDesc string `yaml:"openTimeDesc" codec:"openTimeDesc"`
	// openType
	OpenType int `yaml:"openType" codec:"openType"`
	// openWeekDay
	OpenWeekDay tjcsv.Slice `yaml:"openWeekDay" codec:"openWeekDay"`
	// paramMap
	ParamMap tjcsv.Map `yaml:"paramMap" codec:"paramMap"`
	// rTitle
	RTitle string `yaml:"rTitle" codec:"rTitle"`
	// rankShow
	RankShow tjcsv.Slice `yaml:"rankShow" codec:"rankShow"`
	// ruleJson
	RuleJson string `yaml:"ruleJson" codec:"ruleJson"`
	// sortValue
	SortValue int `yaml:"sortValue" codec:"sortValue"`
	// times
	Times int `yaml:"times" codec:"times"`
	// type
	Type string `yaml:"type" codec:"type"`
	// zrTitle
	ZrTitle string `yaml:"zrTitle" codec:"zrTitle"`
	// zrTitleBg
	ZrTitleBg string `yaml:"zrTitleBg" codec:"zrTitleBg"`
}
// huodong_drop.csv
type Huodong_drop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// node
	Node tjcsv.Slice `yaml:"node" codec:"node"`
	// nodeDrop
	NodeDrop tjcsv.Slice `yaml:"nodeDrop" codec:"nodeDrop"`
	// perDrop
	PerDrop tjcsv.Map `yaml:"perDrop" codec:"perDrop"`
	// perIcon
	PerIcon int `yaml:"perIcon" codec:"perIcon"`
	// saodangAwawrd
	SaodangAwawrd tjcsv.Map `yaml:"saodangAwawrd" codec:"saodangAwawrd"`
}
// huodong_gate_fragment.csv
type Huodong_gate_fragment struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// cd
	Cd int `yaml:"cd" codec:"cd"`
	// date
	Date tjcsv.Slice `yaml:"date" codec:"date"`
	// dropItems
	DropItems tjcsv.Slice `yaml:"dropItems" codec:"dropItems"`
	// gateGroup
	GateGroup tjcsv.Slice `yaml:"gateGroup" codec:"gateGroup"`
	// markIDs
	MarkIDs tjcsv.Slice `yaml:"markIDs" codec:"markIDs"`
	// randomValue
	RandomValue int `yaml:"randomValue" codec:"randomValue"`
}
// huodong_huanxiang.csv
type Huodong_huanxiang struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// gateSeq
	GateSeq tjcsv.Slice `yaml:"gateSeq" codec:"gateSeq"`
	// unitIDs
	UnitIDs tjcsv.Slice `yaml:"unitIDs" codec:"unitIDs"`
}
// items.csv
type Items struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// autoSell
	AutoSell int `yaml:"autoSell" codec:"autoSell"`
	// dateType
	DateType int `yaml:"dateType" codec:"dateType"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// desc1
	Desc1 string `yaml:"desc1" codec:"desc1"`
	// drawItemsLibC
	DrawItemsLibC int `yaml:"drawItemsLibC" codec:"drawItemsLibC"`
	// effBtn
	EffBtn tjcsv.Slice `yaml:"effBtn" codec:"effBtn"`
	// effect
	Effect tjcsv.Map `yaml:"effect" codec:"effect"`
	// expireDate
	ExpireDate int `yaml:"expireDate" codec:"expireDate"`
	// expireTime
	ExpireTime int `yaml:"expireTime" codec:"expireTime"`
	// fragID
	FragID int `yaml:"fragID" codec:"fragID"`
	// gateDropC
	GateDropC int `yaml:"gateDropC" codec:"gateDropC"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// isLimitDrop
	IsLimitDrop bool `yaml:"isLimitDrop" codec:"isLimitDrop"`
	// isShow
	IsShow bool `yaml:"isShow" codec:"isShow"`
	// name
	Name string `yaml:"name" codec:"name"`
	// pageTag
	PageTag tjcsv.Slice `yaml:"pageTag" codec:"pageTag"`
	// produceDesc
	ProduceDesc string `yaml:"produceDesc" codec:"produceDesc"`
	// produceGate1
	ProduceGate1 string `yaml:"produceGate1" codec:"produceGate1"`
	// produceGate2
	ProduceGate2 string `yaml:"produceGate2" codec:"produceGate2"`
	// produceGate3
	ProduceGate3 string `yaml:"produceGate3" codec:"produceGate3"`
	// produceGate4
	ProduceGate4 interface{} `yaml:"produceGate4" codec:"produceGate4"`
	// produceGate5
	ProduceGate5 interface{} `yaml:"produceGate5" codec:"produceGate5"`
	// produceGate6
	ProduceGate6 interface{} `yaml:"produceGate6" codec:"produceGate6"`
	// produceGate7
	ProduceGate7 interface{} `yaml:"produceGate7" codec:"produceGate7"`
	// quality
	Quality int `yaml:"quality" codec:"quality"`
	// rebirthRMB
	RebirthRMB float64 `yaml:"rebirthRMB" codec:"rebirthRMB"`
	// regain
	Regain tjcsv.Map `yaml:"regain" codec:"regain"`
	// sellPrice
	SellPrice int `yaml:"sellPrice" codec:"sellPrice"`
	// sortType
	SortType int `yaml:"sortType" codec:"sortType"`
	// sortValue
	SortValue int `yaml:"sortValue" codec:"sortValue"`
	// specialArgsMap
	SpecialArgsMap tjcsv.Map `yaml:"specialArgsMap" codec:"specialArgsMap"`
	// stackMax
	StackMax int `yaml:"stackMax" codec:"stackMax"`
	// timeOut
	TimeOut int `yaml:"timeOut" codec:"timeOut"`
	// type
	Type int `yaml:"type" codec:"type"`
	// use
	Use string `yaml:"use" codec:"use"`
}
// language.csv
type Language struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// key
	Key string `yaml:"key" codec:"key"`
	// text
	Text string `yaml:"text" codec:"text"`
}
// limit_drops
type Limit_drops struct {
	// limit_drops/random_drops.csv
	Random_drops map[int]*Limit_drops_random_drops `yaml:"random_drops" codec:"random_drops"`
	// limit_drops/stable_drops.csv
	Stable_drops map[int]*Limit_drops_stable_drops `yaml:"stable_drops" codec:"stable_drops"`
}
// limit_drops/random_drops.csv
type Limit_drops_random_drops struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// count
	Count int `yaml:"count" codec:"count"`
	// extraVersion
	ExtraVersion int `yaml:"extraVersion" codec:"extraVersion"`
	// gateID
	GateID int `yaml:"gateID" codec:"gateID"`
	// itemCount
	ItemCount int `yaml:"itemCount" codec:"itemCount"`
	// itemMap
	ItemMap tjcsv.Map `yaml:"itemMap" codec:"itemMap"`
	// probability
	Probability float64 `yaml:"probability" codec:"probability"`
}
// limit_drops/stable_drops.csv
type Limit_drops_stable_drops struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// extraVersion
	ExtraVersion int `yaml:"extraVersion" codec:"extraVersion"`
	// firstWeight
	FirstWeight int `yaml:"firstWeight" codec:"firstWeight"`
	// gateID
	GateID int `yaml:"gateID" codec:"gateID"`
	// itemCount
	ItemCount int `yaml:"itemCount" codec:"itemCount"`
	// itemID
	ItemID int `yaml:"itemID" codec:"itemID"`
	// weightMax
	WeightMax float64 `yaml:"weightMax" codec:"weightMax"`
	// weightMin
	WeightMin float64 `yaml:"weightMin" codec:"weightMin"`
}
// livenessaward.csv
type Livenessaward struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// needPoint
	NeedPoint int `yaml:"needPoint" codec:"needPoint"`
}
// mail.csv
type Mail struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attachs
	Attachs tjcsv.Map `yaml:"attachs" codec:"attachs"`
	// content
	Content string `yaml:"content" codec:"content"`
	// sender
	Sender string `yaml:"sender" codec:"sender"`
	// special
	Special bool `yaml:"special" codec:"special"`
	// subject
	Subject string `yaml:"subject" codec:"subject"`
	// tab
	Tab int `yaml:"tab" codec:"tab"`
}
// marquee.csv
type Marquee struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// isActive
	IsActive int `yaml:"isActive" codec:"isActive"`
	// key
	Key string `yaml:"key" codec:"key"`
	// sortValue
	SortValue int `yaml:"sortValue" codec:"sortValue"`
	// waitTime
	WaitTime int `yaml:"waitTime" codec:"waitTime"`
}
// meteorite
type Meteorite struct {
	// meteorite/base.csv
	Base map[int]*Meteorite_base `yaml:"base" codec:"base"`
	// meteorite/cost.csv
	Cost map[int]*Meteorite_cost `yaml:"cost" codec:"cost"`
	// meteorite/guard_effect.csv
	Guard_effect map[int]*Meteorite_guard_effect `yaml:"guard_effect" codec:"guard_effect"`
	// meteorite/helditem_effect.csv
	Helditem_effect map[int]*Meteorite_helditem_effect `yaml:"helditem_effect" codec:"helditem_effect"`
	// meteorite/level.csv
	Level map[int]*Meteorite_level `yaml:"level" codec:"level"`
}
// meteorite/base.csv
type Meteorite_base struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// cardCD
	CardCD int `yaml:"cardCD" codec:"cardCD"`
	// costSeqID
	CostSeqID int `yaml:"costSeqID" codec:"costSeqID"`
	// helditemCDs
	HelditemCDs tjcsv.Map `yaml:"helditemCDs" codec:"helditemCDs"`
	// helditemNum
	HelditemNum int `yaml:"helditemNum" codec:"helditemNum"`
	// icon
	Icon interface{} `yaml:"icon" codec:"icon"`
	// levelSeqID
	LevelSeqID int `yaml:"levelSeqID" codec:"levelSeqID"`
	// name
	Name string `yaml:"name" codec:"name"`
	// open
	Open tjcsv.Map `yaml:"open" codec:"open"`
	// preID
	PreID int `yaml:"preID" codec:"preID"`
	// preLevel
	PreLevel int `yaml:"preLevel" codec:"preLevel"`
	// unlockLevel
	UnlockLevel int `yaml:"unlockLevel" codec:"unlockLevel"`
	// unlockParams
	UnlockParams tjcsv.Map `yaml:"unlockParams" codec:"unlockParams"`
}
// meteorite/cost.csv
type Meteorite_cost struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// cost1
	Cost1 tjcsv.Map `yaml:"cost1" codec:"cost1"`
	// cost2
	Cost2 tjcsv.Map `yaml:"cost2" codec:"cost2"`
	// cost3
	Cost3 tjcsv.Map `yaml:"cost3" codec:"cost3"`
	// cost4
	Cost4 tjcsv.Map `yaml:"cost4" codec:"cost4"`
	// cost5
	Cost5 tjcsv.Map `yaml:"cost5" codec:"cost5"`
}
// meteorite/guard_effect.csv
type Meteorite_guard_effect struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// advanceAttrs
	AdvanceAttrs tjcsv.Slice `yaml:"advanceAttrs" codec:"advanceAttrs"`
	// rarityAttr
	RarityAttr string `yaml:"rarityAttr" codec:"rarityAttr"`
	// starAttrs
	StarAttrs tjcsv.Slice `yaml:"starAttrs" codec:"starAttrs"`
	// zawakeAttrs
	ZawakeAttrs tjcsv.Slice `yaml:"zawakeAttrs" codec:"zawakeAttrs"`
}
// meteorite/helditem_effect.csv
type Meteorite_helditem_effect struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// advanceAttrs
	AdvanceAttrs tjcsv.Slice `yaml:"advanceAttrs" codec:"advanceAttrs"`
	// levelAttrs
	LevelAttrs tjcsv.Slice `yaml:"levelAttrs" codec:"levelAttrs"`
	// rarityAttr
	RarityAttr string `yaml:"rarityAttr" codec:"rarityAttr"`
}
// meteorite/level.csv
type Meteorite_level struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attr1
	Attr1 tjcsv.Map `yaml:"attr1" codec:"attr1"`
	// attr2
	Attr2 tjcsv.Map `yaml:"attr2" codec:"attr2"`
	// attr3
	Attr3 tjcsv.Map `yaml:"attr3" codec:"attr3"`
	// attr4
	Attr4 tjcsv.Map `yaml:"attr4" codec:"attr4"`
	// attr5
	Attr5 tjcsv.Map `yaml:"attr5" codec:"attr5"`
}
// mimicry
type Mimicry struct {
	// mimicry/base.csv
	Base map[int]*Mimicry_base `yaml:"base" codec:"base"`
	// mimicry/boss.csv
	Boss map[int]*Mimicry_boss `yaml:"boss" codec:"boss"`
	// mimicry/boss_limit.csv
	Boss_limit map[int]*Mimicry_boss_limit `yaml:"boss_limit" codec:"boss_limit"`
	// mimicry/boss_threshold.csv
	Boss_threshold map[int]*Mimicry_boss_threshold `yaml:"boss_threshold" codec:"boss_threshold"`
	// mimicry/buff_coefficient.csv
	Buff_coefficient map[int]*Mimicry_buff_coefficient `yaml:"buff_coefficient" codec:"buff_coefficient"`
	// mimicry/buff_drop.csv
	Buff_drop map[int]*Mimicry_buff_drop `yaml:"buff_drop" codec:"buff_drop"`
	// mimicry/buff_drop_lib.csv
	Buff_drop_lib map[int]*Mimicry_buff_drop_lib `yaml:"buff_drop_lib" codec:"buff_drop_lib"`
	// mimicry/buff_field.csv
	Buff_field map[int]*Mimicry_buff_field `yaml:"buff_field" codec:"buff_field"`
	// mimicry/buffs.csv
	Buffs map[int]*Mimicry_buffs `yaml:"buffs" codec:"buffs"`
	// mimicry/cards.csv
	Cards map[int]*Mimicry_cards `yaml:"cards" codec:"cards"`
	// mimicry/challenge_award.csv
	Challenge_award map[int]*Mimicry_challenge_award `yaml:"challenge_award" codec:"challenge_award"`
	// mimicry/open_boss.csv
	Open_boss map[int]*Mimicry_open_boss `yaml:"open_boss" codec:"open_boss"`
	// mimicry/rank_award.csv
	Rank_award map[int]*Mimicry_rank_award `yaml:"rank_award" codec:"rank_award"`
	// mimicry/scores_coefficient.csv
	Scores_coefficient map[int]*Mimicry_scores_coefficient `yaml:"scores_coefficient" codec:"scores_coefficient"`
	// mimicry/tasks.csv
	Tasks map[int]*Mimicry_tasks `yaml:"tasks" codec:"tasks"`
	// mimicry/team.csv
	Team map[int]*Mimicry_team `yaml:"team" codec:"team"`
}
// mimicry/base.csv
type Mimicry_base struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// battleTimesDailyAdd
	BattleTimesDailyAdd int `yaml:"battleTimesDailyAdd" codec:"battleTimesDailyAdd"`
	// battleTimesLimit
	BattleTimesLimit int `yaml:"battleTimesLimit" codec:"battleTimesLimit"`
	// crossGroupSize
	CrossGroupSize int `yaml:"crossGroupSize" codec:"crossGroupSize"`
	// fastChallengeThreshold
	FastChallengeThreshold int `yaml:"fastChallengeThreshold" codec:"fastChallengeThreshold"`
	// initBattleTimes
	InitBattleTimes int `yaml:"initBattleTimes" codec:"initBattleTimes"`
	// initBuff
	InitBuff tjcsv.Map `yaml:"initBuff" codec:"initBuff"`
	// minServerOpenDays
	MinServerOpenDays int `yaml:"minServerOpenDays" codec:"minServerOpenDays"`
	// quality1BuffFieldNum
	Quality1BuffFieldNum int `yaml:"quality1BuffFieldNum" codec:"quality1BuffFieldNum"`
	// quality2BuffFieldNum
	Quality2BuffFieldNum int `yaml:"quality2BuffFieldNum" codec:"quality2BuffFieldNum"`
	// quality3BuffFieldNum
	Quality3BuffFieldNum int `yaml:"quality3BuffFieldNum" codec:"quality3BuffFieldNum"`
	// quality4BuffFieldNum
	Quality4BuffFieldNum int `yaml:"quality4BuffFieldNum" codec:"quality4BuffFieldNum"`
	// rankingRequiredOpenDays
	RankingRequiredOpenDays int `yaml:"rankingRequiredOpenDays" codec:"rankingRequiredOpenDays"`
	// subCrossGroupSize
	SubCrossGroupSize int `yaml:"subCrossGroupSize" codec:"subCrossGroupSize"`
}
// mimicry/boss.csv
type Mimicry_boss struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// basicScores
	BasicScores int `yaml:"basicScores" codec:"basicScores"`
	// bossID
	BossID int `yaml:"bossID" codec:"bossID"`
	// cardIcon
	CardIcon string `yaml:"cardIcon" codec:"cardIcon"`
	// challengeAwardIndex
	ChallengeAwardIndex int `yaml:"challengeAwardIndex" codec:"challengeAwardIndex"`
	// damageCoefficientIndex
	DamageCoefficientIndex int `yaml:"damageCoefficientIndex" codec:"damageCoefficientIndex"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// gateID
	GateID int `yaml:"gateID" codec:"gateID"`
	// gateName
	GateName string `yaml:"gateName" codec:"gateName"`
	// hpThresholdIndex
	HpThresholdIndex int `yaml:"hpThresholdIndex" codec:"hpThresholdIndex"`
	// scale
	Scale int `yaml:"scale" codec:"scale"`
	// skillIcon
	SkillIcon tjcsv.Slice `yaml:"skillIcon" codec:"skillIcon"`
	// spine
	Spine interface{} `yaml:"spine" codec:"spine"`
	// word
	Word string `yaml:"word" codec:"word"`
}
// mimicry/boss_limit.csv
type Mimicry_boss_limit struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// group
	Group int `yaml:"group" codec:"group"`
	// specialLimitParameter
	SpecialLimitParameter tjcsv.Map `yaml:"specialLimitParameter" codec:"specialLimitParameter"`
	// specialLimitType
	SpecialLimitType int `yaml:"specialLimitType" codec:"specialLimitType"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
}
// mimicry/boss_threshold.csv
type Mimicry_boss_threshold struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// index
	Index int `yaml:"index" codec:"index"`
	// level
	Level int `yaml:"level" codec:"level"`
	// threshold
	Threshold int `yaml:"threshold" codec:"threshold"`
}
// mimicry/buff_coefficient.csv
type Mimicry_buff_coefficient struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// bossID
	BossID int `yaml:"bossID" codec:"bossID"`
	// damageRange
	DamageRange int `yaml:"damageRange" codec:"damageRange"`
	// index
	Index int `yaml:"index" codec:"index"`
	// scoresCoefficient
	ScoresCoefficient float64 `yaml:"scoresCoefficient" codec:"scoresCoefficient"`
}
// mimicry/buff_drop.csv
type Mimicry_buff_drop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// bossID
	BossID int `yaml:"bossID" codec:"bossID"`
	// dropTriggerTimes
	DropTriggerTimes int `yaml:"dropTriggerTimes" codec:"dropTriggerTimes"`
	// dropTriggerType
	DropTriggerType int `yaml:"dropTriggerType" codec:"dropTriggerType"`
	// effectLimit
	EffectLimit int `yaml:"effectLimit" codec:"effectLimit"`
	// lotteryType1
	LotteryType1 tjcsv.Map `yaml:"lotteryType1" codec:"lotteryType1"`
	// lotteryType10
	LotteryType10 tjcsv.Map `yaml:"lotteryType10" codec:"lotteryType10"`
	// lotteryType2
	LotteryType2 tjcsv.Map `yaml:"lotteryType2" codec:"lotteryType2"`
	// lotteryType3
	LotteryType3 tjcsv.Map `yaml:"lotteryType3" codec:"lotteryType3"`
	// lotteryType4
	LotteryType4 tjcsv.Map `yaml:"lotteryType4" codec:"lotteryType4"`
	// lotteryType5
	LotteryType5 tjcsv.Map `yaml:"lotteryType5" codec:"lotteryType5"`
	// lotteryType6
	LotteryType6 tjcsv.Map `yaml:"lotteryType6" codec:"lotteryType6"`
	// lotteryType7
	LotteryType7 tjcsv.Map `yaml:"lotteryType7" codec:"lotteryType7"`
	// lotteryType8
	LotteryType8 tjcsv.Map `yaml:"lotteryType8" codec:"lotteryType8"`
	// lotteryType9
	LotteryType9 tjcsv.Map `yaml:"lotteryType9" codec:"lotteryType9"`
	// lotteryWeight1
	LotteryWeight1 int `yaml:"lotteryWeight1" codec:"lotteryWeight1"`
	// lotteryWeight10
	LotteryWeight10 int `yaml:"lotteryWeight10" codec:"lotteryWeight10"`
	// lotteryWeight2
	LotteryWeight2 int `yaml:"lotteryWeight2" codec:"lotteryWeight2"`
	// lotteryWeight3
	LotteryWeight3 int `yaml:"lotteryWeight3" codec:"lotteryWeight3"`
	// lotteryWeight4
	LotteryWeight4 int `yaml:"lotteryWeight4" codec:"lotteryWeight4"`
	// lotteryWeight5
	LotteryWeight5 int `yaml:"lotteryWeight5" codec:"lotteryWeight5"`
	// lotteryWeight6
	LotteryWeight6 int `yaml:"lotteryWeight6" codec:"lotteryWeight6"`
	// lotteryWeight7
	LotteryWeight7 int `yaml:"lotteryWeight7" codec:"lotteryWeight7"`
	// lotteryWeight8
	LotteryWeight8 int `yaml:"lotteryWeight8" codec:"lotteryWeight8"`
	// lotteryWeight9
	LotteryWeight9 int `yaml:"lotteryWeight9" codec:"lotteryWeight9"`
	// probEffectInterval
	ProbEffectInterval int `yaml:"probEffectInterval" codec:"probEffectInterval"`
	// probInit
	ProbInit float64 `yaml:"probInit" codec:"probInit"`
	// probLimit
	ProbLimit float64 `yaml:"probLimit" codec:"probLimit"`
	// probMiniTimes
	ProbMiniTimes int `yaml:"probMiniTimes" codec:"probMiniTimes"`
	// probStep
	ProbStep float64 `yaml:"probStep" codec:"probStep"`
	// scoresCondition
	ScoresCondition int `yaml:"scoresCondition" codec:"scoresCondition"`
}
// mimicry/buff_drop_lib.csv
type Mimicry_buff_drop_lib struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// content
	Content tjcsv.Slice `yaml:"content" codec:"content"`
	// scores
	Scores int `yaml:"scores" codec:"scores"`
	// times
	Times int `yaml:"times" codec:"times"`
}
// mimicry/buff_field.csv
type Mimicry_buff_field struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// quality
	Quality int `yaml:"quality" codec:"quality"`
	// scoresCondition
	ScoresCondition int `yaml:"scoresCondition" codec:"scoresCondition"`
}
// mimicry/buffs.csv
type Mimicry_buffs struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// basicScores
	BasicScores int `yaml:"basicScores" codec:"basicScores"`
	// bossID
	BossID int `yaml:"bossID" codec:"bossID"`
	// coefficientIndex
	CoefficientIndex int `yaml:"coefficientIndex" codec:"coefficientIndex"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// dropID
	DropID int `yaml:"dropID" codec:"dropID"`
	// dropLimit
	DropLimit int `yaml:"dropLimit" codec:"dropLimit"`
	// icon1
	Icon1 string `yaml:"icon1" codec:"icon1"`
	// level
	Level int `yaml:"level" codec:"level"`
	// name
	Name string `yaml:"name" codec:"name"`
	// quality
	Quality int `yaml:"quality" codec:"quality"`
	// scoresCondition
	ScoresCondition int `yaml:"scoresCondition" codec:"scoresCondition"`
	// skill
	Skill int `yaml:"skill" codec:"skill"`
	// tips
	Tips int `yaml:"tips" codec:"tips"`
}
// mimicry/cards.csv
type Mimicry_cards struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// abilities
	Abilities tjcsv.Map `yaml:"abilities" codec:"abilities"`
	// advance
	Advance int `yaml:"advance" codec:"advance"`
	// block
	Block interface{} `yaml:"block" codec:"block"`
	// blockPower
	BlockPower interface{} `yaml:"blockPower" codec:"blockPower"`
	// breakBlock
	BreakBlock interface{} `yaml:"breakBlock" codec:"breakBlock"`
	// cardID
	CardID int `yaml:"cardID" codec:"cardID"`
	// damage
	Damage interface{} `yaml:"damage" codec:"damage"`
	// damageAdd
	DamageAdd interface{} `yaml:"damageAdd" codec:"damageAdd"`
	// damageSub
	DamageSub interface{} `yaml:"damageSub" codec:"damageSub"`
	// defence
	Defence interface{} `yaml:"defence" codec:"defence"`
	// equipAdvance
	EquipAdvance int `yaml:"equipAdvance" codec:"equipAdvance"`
	// equipAwake
	EquipAwake int `yaml:"equipAwake" codec:"equipAwake"`
	// equipLevel
	EquipLevel int `yaml:"equipLevel" codec:"equipLevel"`
	// equipStar
	EquipStar int `yaml:"equipStar" codec:"equipStar"`
	// fetters
	Fetters bool `yaml:"fetters" codec:"fetters"`
	// hp
	Hp interface{} `yaml:"hp" codec:"hp"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// level
	Level int `yaml:"level" codec:"level"`
	// mainSkillAdd
	MainSkillAdd interface{} `yaml:"mainSkillAdd" codec:"mainSkillAdd"`
	// mainSkillSub
	MainSkillSub interface{} `yaml:"mainSkillSub" codec:"mainSkillSub"`
	// markID
	MarkID int `yaml:"markID" codec:"markID"`
	// megaIndex
	MegaIndex int `yaml:"megaIndex" codec:"megaIndex"`
	// nvalue
	Nvalue tjcsv.Map `yaml:"nvalue" codec:"nvalue"`
	// skillLevels
	SkillLevels tjcsv.Slice `yaml:"skillLevels" codec:"skillLevels"`
	// specialDamage
	SpecialDamage interface{} `yaml:"specialDamage" codec:"specialDamage"`
	// specialDefence
	SpecialDefence interface{} `yaml:"specialDefence" codec:"specialDefence"`
	// speedRate
	SpeedRate int `yaml:"speedRate" codec:"speedRate"`
	// star
	Star int `yaml:"star" codec:"star"`
	// strike
	Strike interface{} `yaml:"strike" codec:"strike"`
	// strikeDamage
	StrikeDamage interface{} `yaml:"strikeDamage" codec:"strikeDamage"`
	// strikeResistance
	StrikeResistance interface{} `yaml:"strikeResistance" codec:"strikeResistance"`
}
// mimicry/challenge_award.csv
type Mimicry_challenge_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// index
	Index int `yaml:"index" codec:"index"`
	// randomAward
	RandomAward tjcsv.Map `yaml:"randomAward" codec:"randomAward"`
	// scoresRange
	ScoresRange int `yaml:"scoresRange" codec:"scoresRange"`
}
// mimicry/open_boss.csv
type Mimicry_open_boss struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// extraCoefficient
	ExtraCoefficient tjcsv.Map `yaml:"extraCoefficient" codec:"extraCoefficient"`
	// issue
	Issue int `yaml:"issue" codec:"issue"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// openBosses
	OpenBosses tjcsv.Map `yaml:"openBosses" codec:"openBosses"`
}
// mimicry/rank_award.csv
type Mimicry_rank_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// rankMax
	RankMax int `yaml:"rankMax" codec:"rankMax"`
}
// mimicry/scores_coefficient.csv
type Mimicry_scores_coefficient struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// damageRange
	DamageRange int `yaml:"damageRange" codec:"damageRange"`
	// index
	Index int `yaml:"index" codec:"index"`
	// scoresCoefficient
	ScoresCoefficient float64 `yaml:"scoresCoefficient" codec:"scoresCoefficient"`
}
// mimicry/tasks.csv
type Mimicry_tasks struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// mimicryAchievement
	MimicryAchievement string `yaml:"mimicryAchievement" codec:"mimicryAchievement"`
	// specialArg
	SpecialArg tjcsv.Slice `yaml:"specialArg" codec:"specialArg"`
	// targetArg
	TargetArg int `yaml:"targetArg" codec:"targetArg"`
	// targetArg2
	TargetArg2 int `yaml:"targetArg2" codec:"targetArg2"`
	// type
	Type int `yaml:"type" codec:"type"`
	// version
	Version int `yaml:"version" codec:"version"`
}
// mimicry/team.csv
type Mimicry_team struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// csvID
	CsvID int `yaml:"csvID" codec:"csvID"`
	// level
	Level int `yaml:"level" codec:"level"`
	// system
	System string `yaml:"system" codec:"system"`
}
// monster_scenes.csv
type Monster_scenes struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// bkCsv
	BkCsv string `yaml:"bkCsv" codec:"bkCsv"`
	// bossLifeCount
	BossLifeCount int `yaml:"bossLifeCount" codec:"bossLifeCount"`
	// bossMark
	BossMark tjcsv.Slice `yaml:"bossMark" codec:"bossMark"`
	// damageC
	DamageC float64 `yaml:"damageC" codec:"damageC"`
	// defenceC
	DefenceC float64 `yaml:"defenceC" codec:"defenceC"`
	// failStories
	FailStories tjcsv.Slice `yaml:"failStories" codec:"failStories"`
	// hpC
	HpC float64 `yaml:"hpC" codec:"hpC"`
	// monsters
	Monsters tjcsv.Slice `yaml:"monsters" codec:"monsters"`
	// posAdjust
	PosAdjust tjcsv.Slice `yaml:"posAdjust" codec:"posAdjust"`
	// round
	Round int `yaml:"round" codec:"round"`
	// showInfo
	ShowInfo bool `yaml:"showInfo" codec:"showInfo"`
	// specialDamageC
	SpecialDamageC float64 `yaml:"specialDamageC" codec:"specialDamageC"`
	// specialDefenceC
	SpecialDefenceC float64 `yaml:"specialDefenceC" codec:"specialDefenceC"`
	// speedC
	SpeedC float64 `yaml:"speedC" codec:"speedC"`
	// storyNames
	StoryNames tjcsv.Slice `yaml:"storyNames" codec:"storyNames"`
	// storys
	Storys tjcsv.Slice `yaml:"storys" codec:"storys"`
	// winStories
	WinStories tjcsv.Slice `yaml:"winStories" codec:"winStories"`
}
// month_card_privilege.csv
type Month_card_privilege struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// fixShopDiscount
	FixShopDiscount float64 `yaml:"fixShopDiscount" codec:"fixShopDiscount"`
	// fragShopRefreshLimit
	FragShopRefreshLimit int `yaml:"fragShopRefreshLimit" codec:"fragShopRefreshLimit"`
	// huodongExpDropRate
	HuodongExpDropRate float64 `yaml:"huodongExpDropRate" codec:"huodongExpDropRate"`
	// huodongExpTimes
	HuodongExpTimes int `yaml:"huodongExpTimes" codec:"huodongExpTimes"`
	// huodongFragTimes
	HuodongFragTimes int `yaml:"huodongFragTimes" codec:"huodongFragTimes"`
	// huodongGiftDropRate
	HuodongGiftDropRate float64 `yaml:"huodongGiftDropRate" codec:"huodongGiftDropRate"`
	// huodongGiftTimes
	HuodongGiftTimes int `yaml:"huodongGiftTimes" codec:"huodongGiftTimes"`
	// huodongGoldDropRate
	HuodongGoldDropRate float64 `yaml:"huodongGoldDropRate" codec:"huodongGoldDropRate"`
	// huodongGoldTimes
	HuodongGoldTimes int `yaml:"huodongGoldTimes" codec:"huodongGoldTimes"`
	// lianJinUpstart
	LianJinUpstart tjcsv.Map `yaml:"lianJinUpstart" codec:"lianJinUpstart"`
	// lianjinFreeTimes
	LianjinFreeTimes int `yaml:"lianjinFreeTimes" codec:"lianjinFreeTimes"`
	// lianjinRate
	LianjinRate float64 `yaml:"lianjinRate" codec:"lianjinRate"`
	// mysteryShopDiscount
	MysteryShopDiscount float64 `yaml:"mysteryShopDiscount" codec:"mysteryShopDiscount"`
	// skillPointExtraMax
	SkillPointExtraMax int `yaml:"skillPointExtraMax" codec:"skillPointExtraMax"`
	// staminaBuyFreeTimes
	StaminaBuyFreeTimes int `yaml:"staminaBuyFreeTimes" codec:"staminaBuyFreeTimes"`
	// staminaExtraMax
	StaminaExtraMax int `yaml:"staminaExtraMax" codec:"staminaExtraMax"`
}
// mystery_shop.csv
type Mystery_shop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// discountDesc
	DiscountDesc string `yaml:"discountDesc" codec:"discountDesc"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// itemCount
	ItemCount int `yaml:"itemCount" codec:"itemCount"`
	// itemWeightMap
	ItemWeightMap tjcsv.Map `yaml:"itemWeightMap" codec:"itemWeightMap"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
	// limitTimes
	LimitTimes int `yaml:"limitTimes" codec:"limitTimes"`
	// limitType
	LimitType int `yaml:"limitType" codec:"limitType"`
	// position
	Position int `yaml:"position" codec:"position"`
	// showUnable
	ShowUnable bool `yaml:"showUnable" codec:"showUnable"`
	// vipStart
	VipStart int `yaml:"vipStart" codec:"vipStart"`
	// vipWeight
	VipWeight int `yaml:"vipWeight" codec:"vipWeight"`
}
// mystery_shop_config.csv
type Mystery_shop_config struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
}
// new_guide.csv
type New_guide struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// animate
	Animate string `yaml:"animate" codec:"animate"`
	// animateAngle
	AnimateAngle int `yaml:"animateAngle" codec:"animateAngle"`
	// animatePos
	AnimatePos tjcsv.Map `yaml:"animatePos" codec:"animatePos"`
	// anyPosCancel
	AnyPosCancel bool `yaml:"anyPosCancel" codec:"anyPosCancel"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// battleEnter
	BattleEnter tjcsv.Map `yaml:"battleEnter" codec:"battleEnter"`
	// extendCondition
	ExtendCondition string `yaml:"extendCondition" codec:"extendCondition"`
	// force
	Force int `yaml:"force" codec:"force"`
	// gotoScene
	GotoScene int `yaml:"gotoScene" codec:"gotoScene"`
	// gotoStep
	GotoStep int `yaml:"gotoStep" codec:"gotoStep"`
	// headPos
	HeadPos tjcsv.Map `yaml:"headPos" codec:"headPos"`
	// headRes
	HeadRes string `yaml:"headRes" codec:"headRes"`
	// jumpToNode
	JumpToNode string `yaml:"jumpToNode" codec:"jumpToNode"`
	// lightSize
	LightSize tjcsv.Map `yaml:"lightSize" codec:"lightSize"`
	// offPos
	OffPos tjcsv.Map `yaml:"offPos" codec:"offPos"`
	// order
	Order int `yaml:"order" codec:"order"`
	// outDelay
	OutDelay float64 `yaml:"outDelay" codec:"outDelay"`
	// roleName
	RoleName string `yaml:"roleName" codec:"roleName"`
	// service
	Service int `yaml:"service" codec:"service"`
	// showAward
	ShowAward bool `yaml:"showAward" codec:"showAward"`
	// showType
	ShowType int `yaml:"showType" codec:"showType"`
	// specialName
	SpecialName string `yaml:"specialName" codec:"specialName"`
	// stage
	Stage int `yaml:"stage" codec:"stage"`
	// startGate
	StartGate int `yaml:"startGate" codec:"startGate"`
	// startLevel
	StartLevel int `yaml:"startLevel" codec:"startLevel"`
	// startSceen
	StartSceen string `yaml:"startSceen" codec:"startSceen"`
	// tagName
	TagName tjcsv.Slice `yaml:"tagName" codec:"tagName"`
	// talkContent
	TalkContent string `yaml:"talkContent" codec:"talkContent"`
	// useRoleFigure
	UseRoleFigure tjcsv.Slice `yaml:"useRoleFigure" codec:"useRoleFigure"`
}
// new_guide_local.csv
type New_guide_local struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// animateAngle
	AnimateAngle int `yaml:"animateAngle" codec:"animateAngle"`
	// anyPosCancel
	AnyPosCancel bool `yaml:"anyPosCancel" codec:"anyPosCancel"`
	// choices
	Choices tjcsv.Slice `yaml:"choices" codec:"choices"`
	// force
	Force int `yaml:"force" codec:"force"`
	// gotoScene
	GotoScene int `yaml:"gotoScene" codec:"gotoScene"`
	// lightSize
	LightSize tjcsv.Map `yaml:"lightSize" codec:"lightSize"`
	// offPos
	OffPos tjcsv.Map `yaml:"offPos" codec:"offPos"`
	// order
	Order int `yaml:"order" codec:"order"`
	// roleName
	RoleName string `yaml:"roleName" codec:"roleName"`
	// service
	Service int `yaml:"service" codec:"service"`
	// showAward
	ShowAward bool `yaml:"showAward" codec:"showAward"`
	// showType
	ShowType int `yaml:"showType" codec:"showType"`
	// specialName
	SpecialName string `yaml:"specialName" codec:"specialName"`
	// stage
	Stage int `yaml:"stage" codec:"stage"`
	// startGate
	StartGate int `yaml:"startGate" codec:"startGate"`
	// startLevel
	StartLevel int `yaml:"startLevel" codec:"startLevel"`
	// tagName
	TagName tjcsv.Slice `yaml:"tagName" codec:"tagName"`
	// talkContent
	TalkContent string `yaml:"talkContent" codec:"talkContent"`
	// useRoleFigure
	UseRoleFigure tjcsv.Slice `yaml:"useRoleFigure" codec:"useRoleFigure"`
}
// new_guide_local_.csv
type New_guide_local_ struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// animateAngle
	AnimateAngle int `yaml:"animateAngle" codec:"animateAngle"`
	// anyPosCancel
	AnyPosCancel bool `yaml:"anyPosCancel" codec:"anyPosCancel"`
	// choices
	Choices tjcsv.Slice `yaml:"choices" codec:"choices"`
	// force
	Force int `yaml:"force" codec:"force"`
	// gotoScene
	GotoScene int `yaml:"gotoScene" codec:"gotoScene"`
	// lightSize
	LightSize tjcsv.Map `yaml:"lightSize" codec:"lightSize"`
	// offPos
	OffPos tjcsv.Map `yaml:"offPos" codec:"offPos"`
	// order
	Order int `yaml:"order" codec:"order"`
	// roleName
	RoleName string `yaml:"roleName" codec:"roleName"`
	// service
	Service int `yaml:"service" codec:"service"`
	// showAward
	ShowAward bool `yaml:"showAward" codec:"showAward"`
	// showType
	ShowType int `yaml:"showType" codec:"showType"`
	// specialName
	SpecialName string `yaml:"specialName" codec:"specialName"`
	// stage
	Stage int `yaml:"stage" codec:"stage"`
	// startGate
	StartGate int `yaml:"startGate" codec:"startGate"`
	// startLevel
	StartLevel int `yaml:"startLevel" codec:"startLevel"`
	// tagName
	TagName tjcsv.Slice `yaml:"tagName" codec:"tagName"`
	// talkContent
	TalkContent string `yaml:"talkContent" codec:"talkContent"`
	// useRoleFigure
	UseRoleFigure tjcsv.Slice `yaml:"useRoleFigure" codec:"useRoleFigure"`
}
// newbie_init.csv
type Newbie_init struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// cards
	Cards tjcsv.Slice `yaml:"cards" codec:"cards"`
	// defaultCards
	DefaultCards tjcsv.Slice `yaml:"defaultCards" codec:"defaultCards"`
	// figures
	Figures tjcsv.Slice `yaml:"figures" codec:"figures"`
	// gold
	Gold int `yaml:"gold" codec:"gold"`
	// items
	Items tjcsv.Map `yaml:"items" codec:"items"`
	// newAward
	NewAward tjcsv.Map `yaml:"newAward" codec:"newAward"`
	// rmb
	Rmb int `yaml:"rmb" codec:"rmb"`
}
// note.csv
type Note struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// fmt
	Fmt string `yaml:"fmt" codec:"fmt"`
}
// notice.csv
type Notice struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// goToPanel
	GoToPanel string `yaml:"goToPanel" codec:"goToPanel"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// name
	Name string `yaml:"name" codec:"name"`
	// noticeLv
	NoticeLv int `yaml:"noticeLv" codec:"noticeLv"`
	// openLv
	OpenLv int `yaml:"openLv" codec:"openLv"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// notify_message.csv
type Notify_message struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// content
	Content string `yaml:"content" codec:"content"`
	// subject
	Subject string `yaml:"subject" codec:"subject"`
}
// nvalue_min_value.csv
type Nvalue_min_value struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// minValue
	MinValue int `yaml:"minValue" codec:"minValue"`
	// nvalueTimes
	NvalueTimes int `yaml:"nvalueTimes" codec:"nvalueTimes"`
}
// nvalue_random.csv
type Nvalue_random struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// drawTriggerTimes
	DrawTriggerTimes int `yaml:"drawTriggerTimes" codec:"drawTriggerTimes"`
	// drawTriggerType
	DrawTriggerType int `yaml:"drawTriggerType" codec:"drawTriggerType"`
	// drawType
	DrawType string `yaml:"drawType" codec:"drawType"`
	// effectLimit
	EffectLimit int `yaml:"effectLimit" codec:"effectLimit"`
	// libs
	Libs tjcsv.Map `yaml:"libs" codec:"libs"`
	// startCount
	StartCount int `yaml:"startCount" codec:"startCount"`
	// weightEnd
	WeightEnd int `yaml:"weightEnd" codec:"weightEnd"`
	// weightStart
	WeightStart int `yaml:"weightStart" codec:"weightStart"`
}
// nvalue_random_lib.csv
type Nvalue_random_lib struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// damage
	Damage tjcsv.Map `yaml:"damage" codec:"damage"`
	// defence
	Defence tjcsv.Map `yaml:"defence" codec:"defence"`
	// hp
	Hp tjcsv.Map `yaml:"hp" codec:"hp"`
	// specialDamage
	SpecialDamage tjcsv.Map `yaml:"specialDamage" codec:"specialDamage"`
	// specialDefence
	SpecialDefence tjcsv.Map `yaml:"specialDefence" codec:"specialDefence"`
	// speed
	Speed tjcsv.Map `yaml:"speed" codec:"speed"`
}
// nvalue_rmb.csv
type Nvalue_rmb struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// locknum
	Locknum int `yaml:"locknum" codec:"locknum"`
	// probEffectInterval
	ProbEffectInterval int `yaml:"probEffectInterval" codec:"probEffectInterval"`
	// probInit
	ProbInit float64 `yaml:"probInit" codec:"probInit"`
	// probLimit
	ProbLimit float64 `yaml:"probLimit" codec:"probLimit"`
	// probMiniTimes
	ProbMiniTimes int `yaml:"probMiniTimes" codec:"probMiniTimes"`
	// probStep
	ProbStep float64 `yaml:"probStep" codec:"probStep"`
	// totalCostRmb
	TotalCostRmb int `yaml:"totalCostRmb" codec:"totalCostRmb"`
}
// online_gift.csv
type Online_gift struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// awardShow
	AwardShow tjcsv.Map `yaml:"awardShow" codec:"awardShow"`
	// periods
	Periods int `yaml:"periods" codec:"periods"`
	// randLib
	RandLib int `yaml:"randLib" codec:"randLib"`
}
// overflow_exp_exchange.csv
type Overflow_exp_exchange struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// limit
	Limit int `yaml:"limit" codec:"limit"`
	// needExp
	NeedExp int `yaml:"needExp" codec:"needExp"`
	// sort
	Sort int `yaml:"sort" codec:"sort"`
}
// pokedex.csv
type Pokedex struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrValue1
	AttrValue1 string `yaml:"attrValue1" codec:"attrValue1"`
	// attrValue2
	AttrValue2 interface{} `yaml:"attrValue2" codec:"attrValue2"`
	// canDevelop
	CanDevelop bool `yaml:"canDevelop" codec:"canDevelop"`
	// canDevelop2
	CanDevelop2 bool `yaml:"canDevelop2" codec:"canDevelop2"`
	// cardID
	CardID int `yaml:"cardID" codec:"cardID"`
	// heightAndWeight
	HeightAndWeight tjcsv.Slice `yaml:"heightAndWeight" codec:"heightAndWeight"`
	// isOpen
	IsOpen bool `yaml:"isOpen" codec:"isOpen"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// sort
	Sort int `yaml:"sort" codec:"sort"`
}
// pokedex_advance.csv
type Pokedex_advance struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNatureType
	AttrNatureType int `yaml:"attrNatureType" codec:"attrNatureType"`
	// attrType
	AttrType int `yaml:"attrType" codec:"attrType"`
	// attrValue
	AttrValue int `yaml:"attrValue" codec:"attrValue"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// name
	Name string `yaml:"name" codec:"name"`
	// targetArg
	TargetArg int `yaml:"targetArg" codec:"targetArg"`
	// targetArg2
	TargetArg2 int `yaml:"targetArg2" codec:"targetArg2"`
	// targetType
	TargetType int `yaml:"targetType" codec:"targetType"`
}
// pokedex_develop.csv
type Pokedex_develop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// attrValue1
	AttrValue1 string `yaml:"attrValue1" codec:"attrValue1"`
	// attrValue2
	AttrValue2 interface{} `yaml:"attrValue2" codec:"attrValue2"`
	// markID
	MarkID int `yaml:"markID" codec:"markID"`
	// star
	Star int `yaml:"star" codec:"star"`
}
// pvpandpve.csv
type Pvpandpve struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// desc
	Desc interface{} `yaml:"desc" codec:"desc"`
	// flag
	Flag int `yaml:"flag" codec:"flag"`
	// goTo
	GoTo string `yaml:"goTo" codec:"goTo"`
	// lockbg1
	Lockbg1 string `yaml:"lockbg1" codec:"lockbg1"`
	// nameRes
	NameRes interface{} `yaml:"nameRes" codec:"nameRes"`
	// serverDayInfo
	ServerDayInfo tjcsv.Map `yaml:"serverDayInfo" codec:"serverDayInfo"`
	// sortIndex
	SortIndex int `yaml:"sortIndex" codec:"sortIndex"`
	// title
	Title string `yaml:"title" codec:"title"`
	// type
	Type string `yaml:"type" codec:"type"`
	// unionFeature
	UnionFeature string `yaml:"unionFeature" codec:"unionFeature"`
	// unlockFeature
	UnlockFeature string `yaml:"unlockFeature" codec:"unlockFeature"`
}
// pwaward.csv
type Pwaward struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// periodAward
	PeriodAward tjcsv.Map `yaml:"periodAward" codec:"periodAward"`
	// range
	Range tjcsv.Slice `yaml:"range" codec:"range"`
	// version
	Version int `yaml:"version" codec:"version"`
}
// pwbattle.csv
type Pwbattle struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// enemyRange1
	EnemyRange1 tjcsv.Slice `yaml:"enemyRange1" codec:"enemyRange1"`
	// enemyRange2
	EnemyRange2 tjcsv.Slice `yaml:"enemyRange2" codec:"enemyRange2"`
	// enemyRange3
	EnemyRange3 tjcsv.Slice `yaml:"enemyRange3" codec:"enemyRange3"`
	// enemyRange4
	EnemyRange4 tjcsv.Slice `yaml:"enemyRange4" codec:"enemyRange4"`
	// range
	Range tjcsv.Slice `yaml:"range" codec:"range"`
}
// pwflop_award.csv
type Pwflop_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// group
	Group string `yaml:"group" codec:"group"`
	// showWeight
	ShowWeight int `yaml:"showWeight" codec:"showWeight"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
}
// pwpoint_award.csv
type Pwpoint_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// needPoint
	NeedPoint int `yaml:"needPoint" codec:"needPoint"`
}
// pwrank_award.csv
type Pwrank_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// cost
	Cost tjcsv.Map `yaml:"cost" codec:"cost"`
	// needRank
	NeedRank int `yaml:"needRank" codec:"needRank"`
}
// pwshop.csv
type Pwshop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// exchangeLimit
	ExchangeLimit int `yaml:"exchangeLimit" codec:"exchangeLimit"`
	// itemMap
	ItemMap tjcsv.Map `yaml:"itemMap" codec:"itemMap"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
	// limitTimes
	LimitTimes int `yaml:"limitTimes" codec:"limitTimes"`
	// limitType
	LimitType int `yaml:"limitType" codec:"limitType"`
	// regainHour
	RegainHour int `yaml:"regainHour" codec:"regainHour"`
	// showUnable
	ShowUnable bool `yaml:"showUnable" codec:"showUnable"`
	// vipStart
	VipStart int `yaml:"vipStart" codec:"vipStart"`
}
// random_drops.csv
type Random_drops struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// count
	Count int `yaml:"count" codec:"count"`
	// gateID
	GateID int `yaml:"gateID" codec:"gateID"`
	// itemCount
	ItemCount int `yaml:"itemCount" codec:"itemCount"`
	// itemMap
	ItemMap tjcsv.Map `yaml:"itemMap" codec:"itemMap"`
	// probability
	Probability float64 `yaml:"probability" codec:"probability"`
}
// random_tower
type Random_tower struct {
	// random_tower/board.csv
	Board map[int]*Random_tower_board `yaml:"board" codec:"board"`
	// random_tower/buffs.csv
	Buffs map[int]*Random_tower_buffs `yaml:"buffs" codec:"buffs"`
	// random_tower/can_jump.csv
	Can_jump map[int]*Random_tower_can_jump `yaml:"can_jump" codec:"can_jump"`
	// random_tower/can_pass.csv
	Can_pass map[int]*Random_tower_can_pass `yaml:"can_pass" codec:"can_pass"`
	// random_tower/event.csv
	Event map[int]*Random_tower_event `yaml:"event" codec:"event"`
	// random_tower/monster_level.csv
	Monster_level map[int]*Random_tower_monster_level `yaml:"monster_level" codec:"monster_level"`
	// random_tower/monsters.csv
	Monsters map[int]*Random_tower_monsters `yaml:"monsters" codec:"monsters"`
	// random_tower/point.csv
	Point map[int]*Random_tower_point `yaml:"point" codec:"point"`
	// random_tower/point_award.csv
	Point_award map[int]*Random_tower_point_award `yaml:"point_award" codec:"point_award"`
	// random_tower/point_award_version.csv
	Point_award_version map[int]*Random_tower_point_award_version `yaml:"point_award_version" codec:"point_award_version"`
	// random_tower/rank_award.csv
	Rank_award map[int]*Random_tower_rank_award `yaml:"rank_award" codec:"rank_award"`
	// random_tower/shop.csv
	Shop map[int]*Random_tower_shop `yaml:"shop" codec:"shop"`
	// random_tower/tower.csv
	Tower map[int]*Random_tower_tower `yaml:"tower" codec:"tower"`
}
// random_tower/board.csv
type Random_tower_board struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// boxType
	BoxType int `yaml:"boxType" codec:"boxType"`
	// buff
	Buff tjcsv.Slice `yaml:"buff" codec:"buff"`
	// coin
	Coin int `yaml:"coin" codec:"coin"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// drops
	Drops tjcsv.Map `yaml:"drops" codec:"drops"`
	// event
	Event tjcsv.Slice `yaml:"event" codec:"event"`
	// fightC
	FightC float64 `yaml:"fightC" codec:"fightC"`
	// gold
	Gold int `yaml:"gold" codec:"gold"`
	// group
	Group int `yaml:"group" codec:"group"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// monster
	Monster int `yaml:"monster" codec:"monster"`
	// monsterType
	MonsterType int `yaml:"monsterType" codec:"monsterType"`
	// name
	Name string `yaml:"name" codec:"name"`
	// pointC
	PointC float64 `yaml:"pointC" codec:"pointC"`
	// randomLibs
	RandomLibs tjcsv.Map `yaml:"randomLibs" codec:"randomLibs"`
	// randomLibs2
	RandomLibs2 tjcsv.Map `yaml:"randomLibs2" codec:"randomLibs2"`
	// room
	Room int `yaml:"room" codec:"room"`
	// type
	Type int `yaml:"type" codec:"type"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
}
// random_tower/buffs.csv
type Random_tower_buffs struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNatureType1
	AttrNatureType1 int `yaml:"attrNatureType1" codec:"attrNatureType1"`
	// attrNatureType3
	AttrNatureType3 int `yaml:"attrNatureType3" codec:"attrNatureType3"`
	// attrNum1
	AttrNum1 string `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 string `yaml:"attrNum2" codec:"attrNum2"`
	// attrNum3
	AttrNum3 interface{} `yaml:"attrNum3" codec:"attrNum3"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// attrType3
	AttrType3 int `yaml:"attrType3" codec:"attrType3"`
	// belongLib
	BelongLib int `yaml:"belongLib" codec:"belongLib"`
	// buffColor
	BuffColor string `yaml:"buffColor" codec:"buffColor"`
	// buffType
	BuffType int `yaml:"buffType" codec:"buffType"`
	// changeLib
	ChangeLib int `yaml:"changeLib" codec:"changeLib"`
	// condition
	Condition int `yaml:"condition" codec:"condition"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// effectTimes
	EffectTimes int `yaml:"effectTimes" codec:"effectTimes"`
	// group
	Group int `yaml:"group" codec:"group"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// iconBg
	IconBg string `yaml:"iconBg" codec:"iconBg"`
	// limit
	Limit int `yaml:"limit" codec:"limit"`
	// onlyOne
	OnlyOne bool `yaml:"onlyOne" codec:"onlyOne"`
	// passiveSkill
	PassiveSkill int `yaml:"passiveSkill" codec:"passiveSkill"`
	// pointType
	PointType int `yaml:"pointType" codec:"pointType"`
	// pointValue
	PointValue int `yaml:"pointValue" codec:"pointValue"`
	// skillgroup
	Skillgroup tjcsv.Slice `yaml:"skillgroup" codec:"skillgroup"`
	// supplyNum
	SupplyNum int `yaml:"supplyNum" codec:"supplyNum"`
	// supplyTarget
	SupplyTarget int `yaml:"supplyTarget" codec:"supplyTarget"`
	// supplyType
	SupplyType int `yaml:"supplyType" codec:"supplyType"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
}
// random_tower/can_jump.csv
type Random_tower_can_jump struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// canJump
	CanJump int `yaml:"canJump" codec:"canJump"`
	// level
	Level int `yaml:"level" codec:"level"`
	// vip
	Vip int `yaml:"vip" codec:"vip"`
}
// random_tower/can_pass.csv
type Random_tower_can_pass struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// canPass
	CanPass int `yaml:"canPass" codec:"canPass"`
	// level
	Level int `yaml:"level" codec:"level"`
	// vip
	Vip int `yaml:"vip" codec:"vip"`
}
// random_tower/event.csv
type Random_tower_event struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// choice1
	Choice1 string `yaml:"choice1" codec:"choice1"`
	// choice2
	Choice2 string `yaml:"choice2" codec:"choice2"`
	// choice3
	Choice3 string `yaml:"choice3" codec:"choice3"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// group
	Group int `yaml:"group" codec:"group"`
	// limit
	Limit int `yaml:"limit" codec:"limit"`
	// name
	Name string `yaml:"name" codec:"name"`
	// onlyOne
	OnlyOne bool `yaml:"onlyOne" codec:"onlyOne"`
	// res
	Res interface{} `yaml:"res" codec:"res"`
	// result1
	Result1 tjcsv.Map `yaml:"result1" codec:"result1"`
	// result2
	Result2 tjcsv.Map `yaml:"result2" codec:"result2"`
	// result3
	Result3 tjcsv.Map `yaml:"result3" codec:"result3"`
	// resultDesc1
	ResultDesc1 string `yaml:"resultDesc1" codec:"resultDesc1"`
	// resultDesc2
	ResultDesc2 string `yaml:"resultDesc2" codec:"resultDesc2"`
	// resultDesc3
	ResultDesc3 string `yaml:"resultDesc3" codec:"resultDesc3"`
}
// random_tower/monster_level.csv
type Random_tower_monster_level struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// advanceEnd
	AdvanceEnd int `yaml:"advanceEnd" codec:"advanceEnd"`
	// advanceStart
	AdvanceStart int `yaml:"advanceStart" codec:"advanceStart"`
	// damageC
	DamageC float64 `yaml:"damageC" codec:"damageC"`
	// defenceC
	DefenceC float64 `yaml:"defenceC" codec:"defenceC"`
	// fightEnd
	FightEnd int `yaml:"fightEnd" codec:"fightEnd"`
	// fightStart
	FightStart int `yaml:"fightStart" codec:"fightStart"`
	// hpC
	HpC float64 `yaml:"hpC" codec:"hpC"`
	// level
	Level int `yaml:"level" codec:"level"`
	// skillLevel
	SkillLevel int `yaml:"skillLevel" codec:"skillLevel"`
	// starEnd
	StarEnd int `yaml:"starEnd" codec:"starEnd"`
	// starStart
	StarStart int `yaml:"starStart" codec:"starStart"`
}
// random_tower/monsters.csv
type Random_tower_monsters struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// backGround
	BackGround string `yaml:"backGround" codec:"backGround"`
	// boss
	Boss tjcsv.Slice `yaml:"boss" codec:"boss"`
	// group
	Group int `yaml:"group" codec:"group"`
	// levelEnd
	LevelEnd int `yaml:"levelEnd" codec:"levelEnd"`
	// levelStart
	LevelStart int `yaml:"levelStart" codec:"levelStart"`
	// monsters
	Monsters tjcsv.Slice `yaml:"monsters" codec:"monsters"`
	// res
	Res string `yaml:"res" codec:"res"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
}
// random_tower/point.csv
type Random_tower_point struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// initPoint
	InitPoint int `yaml:"initPoint" codec:"initPoint"`
}
// random_tower/point_award.csv
type Random_tower_point_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// needPoint
	NeedPoint int `yaml:"needPoint" codec:"needPoint"`
	// version
	Version int `yaml:"version" codec:"version"`
}
// random_tower/point_award_version.csv
type Random_tower_point_award_version struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// servers
	Servers tjcsv.Map `yaml:"servers" codec:"servers"`
	// version
	Version int `yaml:"version" codec:"version"`
}
// random_tower/rank_award.csv
type Random_tower_rank_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// periodAward
	PeriodAward tjcsv.Map `yaml:"periodAward" codec:"periodAward"`
	// range
	Range tjcsv.Slice `yaml:"range" codec:"range"`
	// version
	Version int `yaml:"version" codec:"version"`
}
// random_tower/shop.csv
type Random_tower_shop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// itemCount
	ItemCount int `yaml:"itemCount" codec:"itemCount"`
	// itemWeightMap
	ItemWeightMap tjcsv.Map `yaml:"itemWeightMap" codec:"itemWeightMap"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
	// limitTimes
	LimitTimes int `yaml:"limitTimes" codec:"limitTimes"`
	// limitType
	LimitType int `yaml:"limitType" codec:"limitType"`
	// position
	Position int `yaml:"position" codec:"position"`
	// showUnable
	ShowUnable bool `yaml:"showUnable" codec:"showUnable"`
	// vipStart
	VipStart int `yaml:"vipStart" codec:"vipStart"`
	// vipWeight
	VipWeight int `yaml:"vipWeight" codec:"vipWeight"`
}
// random_tower/tower.csv
type Random_tower_tower struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// boardGroups1
	BoardGroups1 tjcsv.Slice `yaml:"boardGroups1" codec:"boardGroups1"`
	// boardGroups2
	BoardGroups2 tjcsv.Slice `yaml:"boardGroups2" codec:"boardGroups2"`
	// boardGroups3
	BoardGroups3 tjcsv.Slice `yaml:"boardGroups3" codec:"boardGroups3"`
	// boards
	Boards tjcsv.Map `yaml:"boards" codec:"boards"`
	// canPass
	CanPass int `yaml:"canPass" codec:"canPass"`
	// fightC
	FightC tjcsv.Slice `yaml:"fightC" codec:"fightC"`
	// floor
	Floor int `yaml:"floor" codec:"floor"`
	// limit1
	Limit1 int `yaml:"limit1" codec:"limit1"`
	// limit2
	Limit2 int `yaml:"limit2" codec:"limit2"`
	// limit3
	Limit3 int `yaml:"limit3" codec:"limit3"`
	// lowestFight
	LowestFight tjcsv.Slice `yaml:"lowestFight" codec:"lowestFight"`
	// markBoards1
	MarkBoards1 int `yaml:"markBoards1" codec:"markBoards1"`
	// markBoards2
	MarkBoards2 int `yaml:"markBoards2" codec:"markBoards2"`
	// markBoards3
	MarkBoards3 int `yaml:"markBoards3" codec:"markBoards3"`
	// markType1
	MarkType1 int `yaml:"markType1" codec:"markType1"`
	// markType2
	MarkType2 int `yaml:"markType2" codec:"markType2"`
	// markType3
	MarkType3 int `yaml:"markType3" codec:"markType3"`
	// pointC
	PointC tjcsv.Slice `yaml:"pointC" codec:"pointC"`
}
// rebirth_rmb_cost.csv
type Rebirth_rmb_cost struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// rmbPoint
	RmbPoint int `yaml:"rmbPoint" codec:"rmbPoint"`
	// rmbRate
	RmbRate float64 `yaml:"rmbRate" codec:"rmbRate"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// recharges.csv
type Recharges struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// firstDesc
	FirstDesc string `yaml:"firstDesc" codec:"firstDesc"`
	// firstPresent
	FirstPresent int `yaml:"firstPresent" codec:"firstPresent"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// name
	Name string `yaml:"name" codec:"name"`
	// param
	Param tjcsv.Map `yaml:"param" codec:"param"`
	// present
	Present int `yaml:"present" codec:"present"`
	// recommend
	Recommend int `yaml:"recommend" codec:"recommend"`
	// rmb
	Rmb int `yaml:"rmb" codec:"rmb"`
	// rmbDisplay
	RmbDisplay string `yaml:"rmbDisplay" codec:"rmbDisplay"`
	// sortValue
	SortValue int `yaml:"sortValue" codec:"sortValue"`
	// type
	Type int `yaml:"type" codec:"type"`
	// validRechargeHuodong
	ValidRechargeHuodong bool `yaml:"validRechargeHuodong" codec:"validRechargeHuodong"`
}
// role_figure.csv
type Role_figure struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// actPos
	ActPos tjcsv.Map `yaml:"actPos" codec:"actPos"`
	// activeCost
	ActiveCost tjcsv.Map `yaml:"activeCost" codec:"activeCost"`
	// activeLevel
	ActiveLevel tjcsv.Slice `yaml:"activeLevel" codec:"activeLevel"`
	// attrNatureType1
	AttrNatureType1 int `yaml:"attrNatureType1" codec:"attrNatureType1"`
	// attrNatureType2
	AttrNatureType2 int `yaml:"attrNatureType2" codec:"attrNatureType2"`
	// attrNatureType3
	AttrNatureType3 int `yaml:"attrNatureType3" codec:"attrNatureType3"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// attrType3
	AttrType3 int `yaml:"attrType3" codec:"attrType3"`
	// attrValue1
	AttrValue1 string `yaml:"attrValue1" codec:"attrValue1"`
	// attrValue2
	AttrValue2 string `yaml:"attrValue2" codec:"attrValue2"`
	// attrValue3
	AttrValue3 interface{} `yaml:"attrValue3" codec:"attrValue3"`
	// chattext1
	Chattext1 string `yaml:"chattext1" codec:"chattext1"`
	// chattext2
	Chattext2 string `yaml:"chattext2" codec:"chattext2"`
	// chattext3
	Chattext3 string `yaml:"chattext3" codec:"chattext3"`
	// crossArenaPos
	CrossArenaPos tjcsv.Map `yaml:"crossArenaPos" codec:"crossArenaPos"`
	// crossMineResSpine
	CrossMineResSpine interface{} `yaml:"crossMineResSpine" codec:"crossMineResSpine"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// hide
	Hide int `yaml:"hide" codec:"hide"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// logo
	Logo string `yaml:"logo" codec:"logo"`
	// name
	Name string `yaml:"name" codec:"name"`
	// offPos
	OffPos tjcsv.Map `yaml:"offPos" codec:"offPos"`
	// overture
	Overture bool `yaml:"overture" codec:"overture"`
	// pos
	Pos tjcsv.Map `yaml:"pos" codec:"pos"`
	// qFigureres
	QFigureres interface{} `yaml:"qFigureres" codec:"qFigureres"`
	// qRoleSpine
	QRoleSpine interface{} `yaml:"qRoleSpine" codec:"qRoleSpine"`
	// res
	Res string `yaml:"res" codec:"res"`
	// resAct
	ResAct string `yaml:"resAct" codec:"resAct"`
	// resBack
	ResBack string `yaml:"resBack" codec:"resBack"`
	// resSpine
	ResSpine string `yaml:"resSpine" codec:"resSpine"`
	// showIdx
	ShowIdx int `yaml:"showIdx" codec:"showIdx"`
	// skills
	Skills tjcsv.Slice `yaml:"skills" codec:"skills"`
	// type
	Type int `yaml:"type" codec:"type"`
	// unavalibleDesc
	UnavalibleDesc interface{} `yaml:"unavalibleDesc" codec:"unavalibleDesc"`
	// unlock
	Unlock tjcsv.Map `yaml:"unlock" codec:"unlock"`
	// unlockDesc
	UnlockDesc string `yaml:"unlockDesc" codec:"unlockDesc"`
	// zOrder
	ZOrder int `yaml:"zOrder" codec:"zOrder"`
}
// role_frame.csv
type Role_frame struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// name
	Name string `yaml:"name" codec:"name"`
	// unlockDesc
	UnlockDesc string `yaml:"unlockDesc" codec:"unlockDesc"`
}
// role_logo.csv
type Role_logo struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// skinID
	SkinID interface{} `yaml:"skinID" codec:"skinID"`
	// roleID
	RoleID interface{} `yaml:"roleID" codec:"roleID"`
	// itemID
	ItemID interface{} `yaml:"itemID" codec:"itemID"`
	// cardID
	CardID int `yaml:"cardID" codec:"cardID"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// name
	Name string `yaml:"name" codec:"name"`
	// unlockDesc
	UnlockDesc string `yaml:"unlockDesc" codec:"unlockDesc"`
}
// role_out.csv
type Role_out struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// activeSkill
	ActiveSkill int `yaml:"activeSkill" codec:"activeSkill"`
	// block
	Block int `yaml:"block" codec:"block"`
	// blockPower
	BlockPower int `yaml:"blockPower" codec:"blockPower"`
	// breakBlock
	BreakBlock int `yaml:"breakBlock" codec:"breakBlock"`
	// classify
	Classify int `yaml:"classify" codec:"classify"`
	// cure
	Cure int `yaml:"cure" codec:"cure"`
	// damage
	Damage int `yaml:"damage" codec:"damage"`
	// damageAdd
	DamageAdd int `yaml:"damageAdd" codec:"damageAdd"`
	// damageDeepen
	DamageDeepen int `yaml:"damageDeepen" codec:"damageDeepen"`
	// damageReduce
	DamageReduce int `yaml:"damageReduce" codec:"damageReduce"`
	// damageSub
	DamageSub int `yaml:"damageSub" codec:"damageSub"`
	// defence
	Defence int `yaml:"defence" codec:"defence"`
	// defenceIgnore
	DefenceIgnore int `yaml:"defenceIgnore" codec:"defenceIgnore"`
	// dodge
	Dodge int `yaml:"dodge" codec:"dodge"`
	// hit
	Hit int `yaml:"hit" codec:"hit"`
	// hp
	Hp int `yaml:"hp" codec:"hp"`
	// hpRecover
	HpRecover int `yaml:"hpRecover" codec:"hpRecover"`
	// level
	Level int `yaml:"level" codec:"level"`
	// mp1
	Mp1 int `yaml:"mp1" codec:"mp1"`
	// mp1Recover
	Mp1Recover int `yaml:"mp1Recover" codec:"mp1Recover"`
	// mp2
	Mp2 int `yaml:"mp2" codec:"mp2"`
	// mp2Recover
	Mp2Recover int `yaml:"mp2Recover" codec:"mp2Recover"`
	// natureRestraint
	NatureRestraint int `yaml:"natureRestraint" codec:"natureRestraint"`
	// rebound
	Rebound int `yaml:"rebound" codec:"rebound"`
	// roleForce
	RoleForce int `yaml:"roleForce" codec:"roleForce"`
	// roleId
	RoleId int `yaml:"roleId" codec:"roleId"`
	// skills
	Skills tjcsv.Map `yaml:"skills" codec:"skills"`
	// specialDamage
	SpecialDamage int `yaml:"specialDamage" codec:"specialDamage"`
	// specialDefence
	SpecialDefence int `yaml:"specialDefence" codec:"specialDefence"`
	// specialDefenceIgnore
	SpecialDefenceIgnore int `yaml:"specialDefenceIgnore" codec:"specialDefenceIgnore"`
	// speed
	Speed int `yaml:"speed" codec:"speed"`
	// star
	Star int `yaml:"star" codec:"star"`
	// strike
	Strike int `yaml:"strike" codec:"strike"`
	// strikeDamage
	StrikeDamage int `yaml:"strikeDamage" codec:"strikeDamage"`
	// strikeResistance
	StrikeResistance int `yaml:"strikeResistance" codec:"strikeResistance"`
	// suckBlood
	SuckBlood int `yaml:"suckBlood" codec:"suckBlood"`
	// ultimateAdd
	UltimateAdd int `yaml:"ultimateAdd" codec:"ultimateAdd"`
	// ultimateSub
	UltimateSub int `yaml:"ultimateSub" codec:"ultimateSub"`
}
// role_out_init.csv
type Role_out_init struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// activeSkill
	ActiveSkill int `yaml:"activeSkill" codec:"activeSkill"`
	// block
	Block int `yaml:"block" codec:"block"`
	// blockPower
	BlockPower int `yaml:"blockPower" codec:"blockPower"`
	// breakBlock
	BreakBlock int `yaml:"breakBlock" codec:"breakBlock"`
	// classify
	Classify int `yaml:"classify" codec:"classify"`
	// cure
	Cure int `yaml:"cure" codec:"cure"`
	// damage
	Damage int `yaml:"damage" codec:"damage"`
	// damageAdd
	DamageAdd int `yaml:"damageAdd" codec:"damageAdd"`
	// damageDeepen
	DamageDeepen int `yaml:"damageDeepen" codec:"damageDeepen"`
	// damageReduce
	DamageReduce int `yaml:"damageReduce" codec:"damageReduce"`
	// damageSub
	DamageSub int `yaml:"damageSub" codec:"damageSub"`
	// defence
	Defence int `yaml:"defence" codec:"defence"`
	// defenceIgnore
	DefenceIgnore int `yaml:"defenceIgnore" codec:"defenceIgnore"`
	// dodge
	Dodge int `yaml:"dodge" codec:"dodge"`
	// hit
	Hit int `yaml:"hit" codec:"hit"`
	// hp
	Hp int `yaml:"hp" codec:"hp"`
	// hpRecover
	HpRecover int `yaml:"hpRecover" codec:"hpRecover"`
	// level
	Level int `yaml:"level" codec:"level"`
	// mp1
	Mp1 int `yaml:"mp1" codec:"mp1"`
	// mp1Recover
	Mp1Recover int `yaml:"mp1Recover" codec:"mp1Recover"`
	// mp2
	Mp2 int `yaml:"mp2" codec:"mp2"`
	// mp2Recover
	Mp2Recover int `yaml:"mp2Recover" codec:"mp2Recover"`
	// natureRestraint
	NatureRestraint int `yaml:"natureRestraint" codec:"natureRestraint"`
	// rebound
	Rebound int `yaml:"rebound" codec:"rebound"`
	// roleForce
	RoleForce int `yaml:"roleForce" codec:"roleForce"`
	// roleId
	RoleId int `yaml:"roleId" codec:"roleId"`
	// skills
	Skills tjcsv.Map `yaml:"skills" codec:"skills"`
	// specialDamage
	SpecialDamage int `yaml:"specialDamage" codec:"specialDamage"`
	// specialDefence
	SpecialDefence int `yaml:"specialDefence" codec:"specialDefence"`
	// specialDefenceIgnore
	SpecialDefenceIgnore int `yaml:"specialDefenceIgnore" codec:"specialDefenceIgnore"`
	// speed
	Speed int `yaml:"speed" codec:"speed"`
	// star
	Star int `yaml:"star" codec:"star"`
	// strike
	Strike int `yaml:"strike" codec:"strike"`
	// strikeDamage
	StrikeDamage int `yaml:"strikeDamage" codec:"strikeDamage"`
	// strikeResistance
	StrikeResistance int `yaml:"strikeResistance" codec:"strikeResistance"`
	// suckBlood
	SuckBlood int `yaml:"suckBlood" codec:"suckBlood"`
	// ultimateAdd
	UltimateAdd int `yaml:"ultimateAdd" codec:"ultimateAdd"`
	// ultimateSub
	UltimateSub int `yaml:"ultimateSub" codec:"ultimateSub"`
}
// scene_conf.csv
type Scene_conf struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// awardPos
	AwardPos tjcsv.Map `yaml:"awardPos" codec:"awardPos"`
	// backGround
	BackGround string `yaml:"backGround" codec:"backGround"`
	// backMusic
	BackMusic string `yaml:"backMusic" codec:"backMusic"`
	// boss
	Boss tjcsv.Slice `yaml:"boss" codec:"boss"`
	// cardExp
	CardExp int `yaml:"cardExp" codec:"cardExp"`
	// chestAward
	ChestAward tjcsv.Map `yaml:"chestAward" codec:"chestAward"`
	// dayChallengeMax
	DayChallengeMax int `yaml:"dayChallengeMax" codec:"dayChallengeMax"`
	// demonCorrect
	DemonCorrect int `yaml:"demonCorrect" codec:"demonCorrect"`
	// demonCorrectSelf
	DemonCorrectSelf int `yaml:"demonCorrectSelf" codec:"demonCorrectSelf"`
	// deployCardNumLimit
	DeployCardNumLimit int `yaml:"deployCardNumLimit" codec:"deployCardNumLimit"`
	// deployNatureLimit
	DeployNatureLimit tjcsv.Slice `yaml:"deployNatureLimit" codec:"deployNatureLimit"`
	// deployNum
	DeployNum int `yaml:"deployNum" codec:"deployNum"`
	// deployType
	DeployType int `yaml:"deployType" codec:"deployType"`
	// dropIds
	DropIds tjcsv.Map `yaml:"dropIds" codec:"dropIds"`
	// finishPoint
	FinishPoint tjcsv.Map `yaml:"finishPoint" codec:"finishPoint"`
	// frontWay
	FrontWay tjcsv.Slice `yaml:"frontWay" codec:"frontWay"`
	// gateType
	GateType int `yaml:"gateType" codec:"gateType"`
	// gold
	Gold int `yaml:"gold" codec:"gold"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// isQuickSweep
	IsQuickSweep int `yaml:"isQuickSweep" codec:"isQuickSweep"`
	// isWheel
	IsWheel bool `yaml:"isWheel" codec:"isWheel"`
	// kssdFlag
	KssdFlag int `yaml:"kssdFlag" codec:"kssdFlag"`
	// monsterRange
	MonsterRange tjcsv.Map `yaml:"monsterRange" codec:"monsterRange"`
	// monsters
	Monsters tjcsv.Slice `yaml:"monsters" codec:"monsters"`
	// openLevel
	OpenLevel int `yaml:"openLevel" codec:"openLevel"`
	// ownerId
	OwnerId int `yaml:"ownerId" codec:"ownerId"`
	// pos
	Pos tjcsv.Map `yaml:"pos" codec:"pos"`
	// preGateID
	PreGateID int `yaml:"preGateID" codec:"preGateID"`
	// roleExp
	RoleExp int `yaml:"roleExp" codec:"roleExp"`
	// roundLimit
	RoundLimit int `yaml:"roundLimit" codec:"roundLimit"`
	// sandangAward
	SandangAward tjcsv.Map `yaml:"sandangAward" codec:"sandangAward"`
	// sceneCount
	SceneCount int `yaml:"sceneCount" codec:"sceneCount"`
	// sceneLevel
	SceneLevel int `yaml:"sceneLevel" codec:"sceneLevel"`
	// sceneLevelCorrect
	SceneLevelCorrect string `yaml:"sceneLevelCorrect" codec:"sceneLevelCorrect"`
	// sceneName
	SceneName string `yaml:"sceneName" codec:"sceneName"`
	// sceneType
	SceneType int `yaml:"sceneType" codec:"sceneType"`
	// showLevel
	ShowLevel int `yaml:"showLevel" codec:"showLevel"`
	// skillLevel
	SkillLevel int `yaml:"skillLevel" codec:"skillLevel"`
	// staminaCost
	StaminaCost int `yaml:"staminaCost" codec:"staminaCost"`
	// star3Award
	Star3Award tjcsv.Map `yaml:"star3Award" codec:"star3Award"`
	// stars
	Stars tjcsv.Slice `yaml:"stars" codec:"stars"`
	// tag
	Tag tjcsv.Map `yaml:"tag" codec:"tag"`
	// winAward
	WinAward tjcsv.Map `yaml:"winAward" codec:"winAward"`
	// worldLevelSaodangAward
	WorldLevelSaodangAward tjcsv.Map `yaml:"worldLevelSaodangAward" codec:"worldLevelSaodangAward"`
}
// scene_demon_correct.csv
type Scene_demon_correct struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// damage
	Damage tjcsv.Slice `yaml:"damage" codec:"damage"`
	// damageself
	Damageself tjcsv.Slice `yaml:"damageself" codec:"damageself"`
	// defence
	Defence tjcsv.Slice `yaml:"defence" codec:"defence"`
	// defenceself
	Defenceself tjcsv.Slice `yaml:"defenceself" codec:"defenceself"`
	// hp
	Hp tjcsv.Slice `yaml:"hp" codec:"hp"`
	// hpself
	Hpself tjcsv.Slice `yaml:"hpself" codec:"hpself"`
	// index
	Index int `yaml:"index" codec:"index"`
	// seatExtraFix
	SeatExtraFix tjcsv.Map `yaml:"seatExtraFix" codec:"seatExtraFix"`
	// specialDamage
	SpecialDamage tjcsv.Slice `yaml:"specialDamage" codec:"specialDamage"`
	// specialDamageself
	SpecialDamageself tjcsv.Slice `yaml:"specialDamageself" codec:"specialDamageself"`
	// specialDefence
	SpecialDefence tjcsv.Slice `yaml:"specialDefence" codec:"specialDefence"`
	// specialDefenceself
	SpecialDefenceself tjcsv.Slice `yaml:"specialDefenceself" codec:"specialDefenceself"`
	// speed
	Speed tjcsv.Slice `yaml:"speed" codec:"speed"`
	// speedself
	Speedself tjcsv.Slice `yaml:"speedself" codec:"speedself"`
	// wave
	Wave int `yaml:"wave" codec:"wave"`
}
// scene_level_correct.csv
type Scene_level_correct struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// boss
	Boss int `yaml:"boss" codec:"boss"`
	// boss2
	Boss2 int `yaml:"boss2" codec:"boss2"`
	// boss501
	Boss501 int `yaml:"boss501" codec:"boss501"`
	// boss502
	Boss502 int `yaml:"boss502" codec:"boss502"`
	// boss503
	Boss503 int `yaml:"boss503" codec:"boss503"`
	// boss504
	Boss504 int `yaml:"boss504" codec:"boss504"`
	// boss505
	Boss505 int `yaml:"boss505" codec:"boss505"`
	// boss506
	Boss506 int `yaml:"boss506" codec:"boss506"`
	// boss601
	Boss601 int `yaml:"boss601" codec:"boss601"`
	// mineboss1
	Mineboss1 int `yaml:"mineboss1" codec:"mineboss1"`
	// mineboss2
	Mineboss2 int `yaml:"mineboss2" codec:"mineboss2"`
	// mineboss3
	Mineboss3 int `yaml:"mineboss3" codec:"mineboss3"`
}
// scene_monster_story.csv
type Scene_monster_story struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// animate
	Animate string `yaml:"animate" codec:"animate"`
	// animateAngle
	AnimateAngle int `yaml:"animateAngle" codec:"animateAngle"`
	// anyPosCancel
	AnyPosCancel bool `yaml:"anyPosCancel" codec:"anyPosCancel"`
	// canSkip
	CanSkip bool `yaml:"canSkip" codec:"canSkip"`
	// choices
	Choices tjcsv.Slice `yaml:"choices" codec:"choices"`
	// force
	Force int `yaml:"force" codec:"force"`
	// gotoStep
	GotoStep tjcsv.Slice `yaml:"gotoStep" codec:"gotoStep"`
	// headPos
	HeadPos tjcsv.Map `yaml:"headPos" codec:"headPos"`
	// headRes
	HeadRes string `yaml:"headRes" codec:"headRes"`
	// isFirstGate
	IsFirstGate bool `yaml:"isFirstGate" codec:"isFirstGate"`
	// lastTime
	LastTime int `yaml:"lastTime" codec:"lastTime"`
	// lightSize
	LightSize tjcsv.Map `yaml:"lightSize" codec:"lightSize"`
	// needAutoJump
	NeedAutoJump int `yaml:"needAutoJump" codec:"needAutoJump"`
	// offPos
	OffPos tjcsv.Map `yaml:"offPos" codec:"offPos"`
	// roleName
	RoleName string `yaml:"roleName" codec:"roleName"`
	// showType
	ShowType int `yaml:"showType" codec:"showType"`
	// storyType
	StoryType int `yaml:"storyType" codec:"storyType"`
	// tagName
	TagName tjcsv.Slice `yaml:"tagName" codec:"tagName"`
	// talkContent
	TalkContent string `yaml:"talkContent" codec:"talkContent"`
	// talkSelect
	TalkSelect tjcsv.Slice `yaml:"talkSelect" codec:"talkSelect"`
	// topPosX
	TopPosX int `yaml:"topPosX" codec:"topPosX"`
	// topPosY
	TopPosY int `yaml:"topPosY" codec:"topPosY"`
	// topTalk
	TopTalk string `yaml:"topTalk" codec:"topTalk"`
	// triggerTime
	TriggerTime int `yaml:"triggerTime" codec:"triggerTime"`
	// useRoleFigure
	UseRoleFigure tjcsv.Slice `yaml:"useRoleFigure" codec:"useRoleFigure"`
}
// scene_story_choices.csv
type Scene_story_choices struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// skills
	Skills tjcsv.Map `yaml:"skills" codec:"skills"`
	// startStoryID
	StartStoryID int `yaml:"startStoryID" codec:"startStoryID"`
	// text
	Text string `yaml:"text" codec:"text"`
}
// sdk
type Sdk struct {
	// sdk/sdk_activity.csv
	Sdk_activity map[int]*Sdk_sdk_activity `yaml:"sdk_activity" codec:"sdk_activity"`
	// sdk/sdk_gift.csv
	Sdk_gift map[int]*Sdk_sdk_gift `yaml:"sdk_gift" codec:"sdk_gift"`
}
// sdk/sdk_activity.csv
type Sdk_sdk_activity struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// beginTime
	BeginTime int `yaml:"beginTime" codec:"beginTime"`
	// code
	Code string `yaml:"code" codec:"code"`
	// day
	Day int `yaml:"day" codec:"day"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// endTime
	EndTime int `yaml:"endTime" codec:"endTime"`
	// name
	Name string `yaml:"name" codec:"name"`
	// prefix
	Prefix string `yaml:"prefix" codec:"prefix"`
	// signKey
	SignKey string `yaml:"signKey" codec:"signKey"`
}
// sdk/sdk_gift.csv
type Sdk_sdk_gift struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// activity
	Activity string `yaml:"activity" codec:"activity"`
	// day
	Day int `yaml:"day" codec:"day"`
	// giftId
	GiftId int `yaml:"giftId" codec:"giftId"`
}
// server
type Server struct {
	// server/merge.csv
	Merge map[int]*Server_merge `yaml:"merge" codec:"merge"`
	// server/robot.csv
	Robot map[int]*Server_robot `yaml:"robot" codec:"robot"`
	// server/robot_lib.csv
	Robot_lib map[int]*Server_robot_lib `yaml:"robot_lib" codec:"robot_lib"`
	// server/version.csv
	Version map[int]*Server_version `yaml:"version" codec:"version"`
}
// server/merge.csv
type Server_merge struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// craftAwardVer
	CraftAwardVer int `yaml:"craftAwardVer" codec:"craftAwardVer"`
	// destServer
	DestServer string `yaml:"destServer" codec:"destServer"`
	// pwAwardVer
	PwAwardVer int `yaml:"pwAwardVer" codec:"pwAwardVer"`
	// randomTowerAwardVer
	RandomTowerAwardVer int `yaml:"randomTowerAwardVer" codec:"randomTowerAwardVer"`
	// realityMerge
	RealityMerge int `yaml:"realityMerge" codec:"realityMerge"`
	// serverID
	ServerID int `yaml:"serverID" codec:"serverID"`
	// servers
	Servers tjcsv.Slice `yaml:"servers" codec:"servers"`
}
// server/robot.csv
type Server_robot struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// level
	Level tjcsv.Slice `yaml:"level" codec:"level"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
	// logo
	Logo tjcsv.Slice `yaml:"logo" codec:"logo"`
	// name
	Name string `yaml:"name" codec:"name"`
	// rank
	Rank int `yaml:"rank" codec:"rank"`
}
// server/robot_lib.csv
type Server_robot_lib struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// card1
	Card1 tjcsv.Map `yaml:"card1" codec:"card1"`
	// card2
	Card2 tjcsv.Map `yaml:"card2" codec:"card2"`
	// card3
	Card3 tjcsv.Map `yaml:"card3" codec:"card3"`
	// card4
	Card4 tjcsv.Map `yaml:"card4" codec:"card4"`
	// card5
	Card5 tjcsv.Map `yaml:"card5" codec:"card5"`
	// card6
	Card6 tjcsv.Map `yaml:"card6" codec:"card6"`
	// level
	Level int `yaml:"level" codec:"level"`
	// randomWeight
	RandomWeight int `yaml:"randomWeight" codec:"randomWeight"`
	// skillMap1
	SkillMap1 tjcsv.Map `yaml:"skillMap1" codec:"skillMap1"`
	// skillMap2
	SkillMap2 tjcsv.Map `yaml:"skillMap2" codec:"skillMap2"`
	// skillMap3
	SkillMap3 tjcsv.Map `yaml:"skillMap3" codec:"skillMap3"`
	// skillMap4
	SkillMap4 tjcsv.Map `yaml:"skillMap4" codec:"skillMap4"`
	// skillMap5
	SkillMap5 tjcsv.Map `yaml:"skillMap5" codec:"skillMap5"`
	// skillMap6
	SkillMap6 tjcsv.Map `yaml:"skillMap6" codec:"skillMap6"`
}
// server/version.csv
type Server_version struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// craftAwardVer
	CraftAwardVer int `yaml:"craftAwardVer" codec:"craftAwardVer"`
	// pwAwardVer
	PwAwardVer int `yaml:"pwAwardVer" codec:"pwAwardVer"`
	// randomTowerAwardVer
	RandomTowerAwardVer int `yaml:"randomTowerAwardVer" codec:"randomTowerAwardVer"`
	// server
	Server string `yaml:"server" codec:"server"`
}
// shop.csv
type Shop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// fontSize
	FontSize int `yaml:"fontSize" codec:"fontSize"`
	// group
	Group int `yaml:"group" codec:"group"`
}
// sighingift.csv
type Sighingift struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// day
	Day int `yaml:"day" codec:"day"`
	// reward
	Reward tjcsv.Map `yaml:"reward" codec:"reward"`
}
// signin.csv
type Signin struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// month1
	Month1 tjcsv.Map `yaml:"month1" codec:"month1"`
	// month10
	Month10 tjcsv.Map `yaml:"month10" codec:"month10"`
	// month11
	Month11 tjcsv.Map `yaml:"month11" codec:"month11"`
	// month12
	Month12 tjcsv.Map `yaml:"month12" codec:"month12"`
	// month2
	Month2 tjcsv.Map `yaml:"month2" codec:"month2"`
	// month3
	Month3 tjcsv.Map `yaml:"month3" codec:"month3"`
	// month4
	Month4 tjcsv.Map `yaml:"month4" codec:"month4"`
	// month5
	Month5 tjcsv.Map `yaml:"month5" codec:"month5"`
	// month6
	Month6 tjcsv.Map `yaml:"month6" codec:"month6"`
	// month7
	Month7 tjcsv.Map `yaml:"month7" codec:"month7"`
	// month8
	Month8 tjcsv.Map `yaml:"month8" codec:"month8"`
	// month9
	Month9 tjcsv.Map `yaml:"month9" codec:"month9"`
	// months
	Months tjcsv.Slice `yaml:"months" codec:"months"`
	// vipDouble
	VipDouble int `yaml:"vipDouble" codec:"vipDouble"`
}
// skill.csv
type Skill struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// activeCondition
	ActiveCondition int `yaml:"activeCondition" codec:"activeCondition"`
	// activeType
	ActiveType int `yaml:"activeType" codec:"activeType"`
	// allEffectTime
	AllEffectTime tjcsv.Slice `yaml:"allEffectTime" codec:"allEffectTime"`
	// alwaysEffective
	AlwaysEffective bool `yaml:"alwaysEffective" codec:"alwaysEffective"`
	// autoHintChoose
	AutoHintChoose tjcsv.Map `yaml:"autoHintChoose" codec:"autoHintChoose"`
	// blankTime
	BlankTime float64 `yaml:"blankTime" codec:"blankTime"`
	// cameraNear
	CameraNear int `yaml:"cameraNear" codec:"cameraNear"`
	// cdRound
	CdRound int `yaml:"cdRound" codec:"cdRound"`
	// changeUnitTrigger
	ChangeUnitTrigger bool `yaml:"changeUnitTrigger" codec:"changeUnitTrigger"`
	// chargeArgs
	ChargeArgs tjcsv.Map `yaml:"chargeArgs" codec:"chargeArgs"`
	// conditionValue
	ConditionValue tjcsv.Slice `yaml:"conditionValue" codec:"conditionValue"`
	// costID
	CostID int `yaml:"costID" codec:"costID"`
	// costMp1
	CostMp1 int `yaml:"costMp1" codec:"costMp1"`
	// costMp1Args
	CostMp1Args tjcsv.Slice `yaml:"costMp1Args" codec:"costMp1Args"`
	// damageFormula
	DamageFormula string `yaml:"damageFormula" codec:"damageFormula"`
	// describe
	Describe string `yaml:"describe" codec:"describe"`
	// diffSkillCalDmgProcessId
	DiffSkillCalDmgProcessId tjcsv.Map `yaml:"diffSkillCalDmgProcessId" codec:"diffSkillCalDmgProcessId"`
	// effectBigFlip
	EffectBigFlip bool `yaml:"effectBigFlip" codec:"effectBigFlip"`
	// effectBigName
	EffectBigName tjcsv.Slice `yaml:"effectBigName" codec:"effectBigName"`
	// effectBigPos
	EffectBigPos tjcsv.Map `yaml:"effectBigPos" codec:"effectBigPos"`
	// fightingPoint
	FightingPoint int `yaml:"fightingPoint" codec:"fightingPoint"`
	// flashBack
	FlashBack int `yaml:"flashBack" codec:"flashBack"`
	// hintChoose
	HintChoose int `yaml:"hintChoose" codec:"hintChoose"`
	// hintTargetType
	HintTargetType int `yaml:"hintTargetType" codec:"hintTargetType"`
	// hitFormula
	HitFormula tjcsv.Map `yaml:"hitFormula" codec:"hitFormula"`
	// hpFormula
	HpFormula string `yaml:"hpFormula" codec:"hpFormula"`
	// hurtMp1
	HurtMp1 int `yaml:"hurtMp1" codec:"hurtMp1"`
	// hurtPos
	HurtPos tjcsv.Map `yaml:"hurtPos" codec:"hurtPos"`
	// iconRes
	IconRes string `yaml:"iconRes" codec:"iconRes"`
	// isCombat
	IsCombat bool `yaml:"isCombat" codec:"isCombat"`
	// isGlobal
	IsGlobal bool `yaml:"isGlobal" codec:"isGlobal"`
	// moveTime
	MoveTime tjcsv.Slice `yaml:"moveTime" codec:"moveTime"`
	// notShowProcedure
	NotShowProcedure tjcsv.Map `yaml:"notShowProcedure" codec:"notShowProcedure"`
	// passivePriority
	PassivePriority int `yaml:"passivePriority" codec:"passivePriority"`
	// passiveSkillAttrs
	PassiveSkillAttrs tjcsv.Map `yaml:"passiveSkillAttrs" codec:"passiveSkillAttrs"`
	// passiveStartRound
	PassiveStartRound int `yaml:"passiveStartRound" codec:"passiveStartRound"`
	// passiveTriggerArg
	PassiveTriggerArg int `yaml:"passiveTriggerArg" codec:"passiveTriggerArg"`
	// passiveTriggerType
	PassiveTriggerType int `yaml:"passiveTriggerType" codec:"passiveTriggerType"`
	// posC
	PosC tjcsv.Map `yaml:"posC" codec:"posC"`
	// posChoose
	PosChoose int `yaml:"posChoose" codec:"posChoose"`
	// recoverMp1
	RecoverMp1 int `yaml:"recoverMp1" codec:"recoverMp1"`
	// scaleArgs
	ScaleArgs tjcsv.Map `yaml:"scaleArgs" codec:"scaleArgs"`
	// simDesc
	SimDesc string `yaml:"simDesc" codec:"simDesc"`
	// skillArgs
	SkillArgs tjcsv.Slice `yaml:"skillArgs" codec:"skillArgs"`
	// skillCalDamageProcessId
	SkillCalDamageProcessId int `yaml:"skillCalDamageProcessId" codec:"skillCalDamageProcessId"`
	// skillDamageType
	SkillDamageType int `yaml:"skillDamageType" codec:"skillDamageType"`
	// skillHit
	SkillHit int `yaml:"skillHit" codec:"skillHit"`
	// skillName
	SkillName string `yaml:"skillName" codec:"skillName"`
	// skillNatureType
	SkillNatureType int `yaml:"skillNatureType" codec:"skillNatureType"`
	// skillPower
	SkillPower int `yaml:"skillPower" codec:"skillPower"`
	// skillProcess
	SkillProcess tjcsv.Slice `yaml:"skillProcess" codec:"skillProcess"`
	// skillType
	SkillType int `yaml:"skillType" codec:"skillType"`
	// skillType2
	SkillType2 int `yaml:"skillType2" codec:"skillType2"`
	// skillTypeShow
	SkillTypeShow string `yaml:"skillTypeShow" codec:"skillTypeShow"`
	// sound
	Sound tjcsv.Map `yaml:"sound" codec:"sound"`
	// specialChoose
	SpecialChoose int `yaml:"specialChoose" codec:"specialChoose"`
	// specialHintChoose
	SpecialHintChoose int `yaml:"specialHintChoose" codec:"specialHintChoose"`
	// spineAction
	SpineAction string `yaml:"spineAction" codec:"spineAction"`
	// starEffect
	StarEffect tjcsv.Slice `yaml:"starEffect" codec:"starEffect"`
	// starEffectDesc
	StarEffectDesc string `yaml:"starEffectDesc" codec:"starEffectDesc"`
	// startRound
	StartRound int `yaml:"startRound" codec:"startRound"`
	// targetChooseType
	TargetChooseType string `yaml:"targetChooseType" codec:"targetChooseType"`
	// targetTypeDesc
	TargetTypeDesc string `yaml:"targetTypeDesc" codec:"targetTypeDesc"`
	// upLvDesc
	UpLvDesc string `yaml:"upLvDesc" codec:"upLvDesc"`
	// widgetEffects
	WidgetEffects tjcsv.Map `yaml:"widgetEffects" codec:"widgetEffects"`
	// zawakeEffect
	ZawakeEffect tjcsv.Slice `yaml:"zawakeEffect" codec:"zawakeEffect"`
	// zawakeEffectDesc
	ZawakeEffectDesc string `yaml:"zawakeEffectDesc" codec:"zawakeEffectDesc"`
	// zawakeSimpleDesc
	ZawakeSimpleDesc string `yaml:"zawakeSimpleDesc" codec:"zawakeSimpleDesc"`
	// zawakeSimpleType
	ZawakeSimpleType int `yaml:"zawakeSimpleType" codec:"zawakeSimpleType"`
}
// sound_config.csv
type Sound_config struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// action
	Action string `yaml:"action" codec:"action"`
	// delay
	Delay int `yaml:"delay" codec:"delay"`
	// res
	Res string `yaml:"res" codec:"res"`
	// spineName
	SpineName string `yaml:"spineName" codec:"spineName"`
}
// stable_drops.csv
type Stable_drops struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// firstWeight
	FirstWeight float64 `yaml:"firstWeight" codec:"firstWeight"`
	// gateID
	GateID int `yaml:"gateID" codec:"gateID"`
	// itemCount
	ItemCount int `yaml:"itemCount" codec:"itemCount"`
	// itemID
	ItemID int `yaml:"itemID" codec:"itemID"`
	// weightMax
	WeightMax float64 `yaml:"weightMax" codec:"weightMax"`
	// weightMin
	WeightMin float64 `yaml:"weightMin" codec:"weightMin"`
}
// stage
type Stage struct {
}
// story.csv
type Story struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// aniAction
	AniAction tjcsv.Map `yaml:"aniAction" codec:"aniAction"`
	// needCardStar
	NeedCardStar tjcsv.Map `yaml:"needCardStar" codec:"needCardStar"`
	// needLevel
	NeedLevel int `yaml:"needLevel" codec:"needLevel"`
	// soundAction
	SoundAction tjcsv.Map `yaml:"soundAction" codec:"soundAction"`
	// storyAni
	StoryAni string `yaml:"storyAni" codec:"storyAni"`
	// storyImg
	StoryImg string `yaml:"storyImg" codec:"storyImg"`
}
// story_talk.csv
type Story_talk struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
}
// summer_challenge
type Summer_challenge struct {
	// summer_challenge/base.csv
	Base map[int]*Summer_challenge_base `yaml:"base" codec:"base"`
	// summer_challenge/cards.csv
	Cards map[int]*Summer_challenge_cards `yaml:"cards" codec:"cards"`
	// summer_challenge/gates.csv
	Gates map[int]*Summer_challenge_gates `yaml:"gates" codec:"gates"`
	// summer_challenge/monsters.csv
	Monsters map[int]*Summer_challenge_monsters `yaml:"monsters" codec:"monsters"`
	// summer_challenge/team.csv
	Team map[int]*Summer_challenge_team `yaml:"team" codec:"team"`
}
// summer_challenge/base.csv
type Summer_challenge_base struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// achievementID
	AchievementID int `yaml:"achievementID" codec:"achievementID"`
	// background
	Background interface{} `yaml:"background" codec:"background"`
	// gateSeqID
	GateSeqID int `yaml:"gateSeqID" codec:"gateSeqID"`
}
// summer_challenge/cards.csv
type Summer_challenge_cards struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// abilities
	Abilities tjcsv.Map `yaml:"abilities" codec:"abilities"`
	// advance
	Advance int `yaml:"advance" codec:"advance"`
	// blockLevel
	BlockLevel int `yaml:"blockLevel" codec:"blockLevel"`
	// blockPower
	BlockPower int `yaml:"blockPower" codec:"blockPower"`
	// breakBlockLevel
	BreakBlockLevel int `yaml:"breakBlockLevel" codec:"breakBlockLevel"`
	// cardID
	CardID int `yaml:"cardID" codec:"cardID"`
	// controlPer
	ControlPer int `yaml:"controlPer" codec:"controlPer"`
	// damage
	Damage float64 `yaml:"damage" codec:"damage"`
	// damageAdd
	DamageAdd int `yaml:"damageAdd" codec:"damageAdd"`
	// damageSub
	DamageSub int `yaml:"damageSub" codec:"damageSub"`
	// defence
	Defence float64 `yaml:"defence" codec:"defence"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// equipAdvance
	EquipAdvance int `yaml:"equipAdvance" codec:"equipAdvance"`
	// equipAwake
	EquipAwake int `yaml:"equipAwake" codec:"equipAwake"`
	// equipLevel
	EquipLevel int `yaml:"equipLevel" codec:"equipLevel"`
	// equipStar
	EquipStar int `yaml:"equipStar" codec:"equipStar"`
	// fetters
	Fetters bool `yaml:"fetters" codec:"fetters"`
	// hp
	Hp float64 `yaml:"hp" codec:"hp"`
	// immuneControl
	ImmuneControl int `yaml:"immuneControl" codec:"immuneControl"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// level
	Level int `yaml:"level" codec:"level"`
	// mainSkillAdd
	MainSkillAdd int `yaml:"mainSkillAdd" codec:"mainSkillAdd"`
	// mainSkillSub
	MainSkillSub int `yaml:"mainSkillSub" codec:"mainSkillSub"`
	// nvalue
	Nvalue tjcsv.Map `yaml:"nvalue" codec:"nvalue"`
	// rarity
	Rarity int `yaml:"rarity" codec:"rarity"`
	// rebound
	Rebound int `yaml:"rebound" codec:"rebound"`
	// skillLevels
	SkillLevels tjcsv.Slice `yaml:"skillLevels" codec:"skillLevels"`
	// skills
	Skills tjcsv.Map `yaml:"skills" codec:"skills"`
	// specialDamage
	SpecialDamage float64 `yaml:"specialDamage" codec:"specialDamage"`
	// specialDefence
	SpecialDefence float64 `yaml:"specialDefence" codec:"specialDefence"`
	// speed
	Speed float64 `yaml:"speed" codec:"speed"`
	// star
	Star int `yaml:"star" codec:"star"`
	// strikeDamage
	StrikeDamage int `yaml:"strikeDamage" codec:"strikeDamage"`
	// strikeLevel
	StrikeLevel int `yaml:"strikeLevel" codec:"strikeLevel"`
	// strikeResistance
	StrikeResistance int `yaml:"strikeResistance" codec:"strikeResistance"`
	// suckBlood
	SuckBlood int `yaml:"suckBlood" codec:"suckBlood"`
	// unitID
	UnitID int `yaml:"unitID" codec:"unitID"`
}
// summer_challenge/gates.csv
type Summer_challenge_gates struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// autoCards
	AutoCards tjcsv.Map `yaml:"autoCards" codec:"autoCards"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// beforePlot
	BeforePlot int `yaml:"beforePlot" codec:"beforePlot"`
	// beforePlotRepeat
	BeforePlotRepeat bool `yaml:"beforePlotRepeat" codec:"beforePlotRepeat"`
	// beforeRes
	BeforeRes interface{} `yaml:"beforeRes" codec:"beforeRes"`
	// cards
	Cards tjcsv.Slice `yaml:"cards" codec:"cards"`
	// deployDesc
	DeployDesc interface{} `yaml:"deployDesc" codec:"deployDesc"`
	// deployLock
	DeployLock tjcsv.Slice `yaml:"deployLock" codec:"deployLock"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// floor
	Floor int `yaml:"floor" codec:"floor"`
	// gateSeq
	GateSeq int `yaml:"gateSeq" codec:"gateSeq"`
	// monsterIDs
	MonsterIDs tjcsv.Slice `yaml:"monsterIDs" codec:"monsterIDs"`
	// name
	Name string `yaml:"name" codec:"name"`
	// openDay
	OpenDay int `yaml:"openDay" codec:"openDay"`
	// reviewPlot
	ReviewPlot string `yaml:"reviewPlot" codec:"reviewPlot"`
	// roundLimit
	RoundLimit int `yaml:"roundLimit" codec:"roundLimit"`
	// scene
	Scene string `yaml:"scene" codec:"scene"`
	// winCondition
	WinCondition tjcsv.Map `yaml:"winCondition" codec:"winCondition"`
}
// summer_challenge/monsters.csv
type Summer_challenge_monsters struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// cards
	Cards tjcsv.Slice `yaml:"cards" codec:"cards"`
	// damageFix
	DamageFix tjcsv.Slice `yaml:"damageFix" codec:"damageFix"`
	// defenceFix
	DefenceFix tjcsv.Slice `yaml:"defenceFix" codec:"defenceFix"`
	// gateID
	GateID int `yaml:"gateID" codec:"gateID"`
	// hpFix
	HpFix tjcsv.Slice `yaml:"hpFix" codec:"hpFix"`
	// sceneCount
	SceneCount int `yaml:"sceneCount" codec:"sceneCount"`
	// speedFix
	SpeedFix tjcsv.Slice `yaml:"speedFix" codec:"speedFix"`
	// storys
	Storys tjcsv.Slice `yaml:"storys" codec:"storys"`
}
// summer_challenge/team.csv
type Summer_challenge_team struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// csvID
	CsvID int `yaml:"csvID" codec:"csvID"`
	// level
	Level int `yaml:"level" codec:"level"`
	// system
	System string `yaml:"system" codec:"system"`
}
// sysopen.csv
type Sysopen struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// bg
	Bg interface{} `yaml:"bg" codec:"bg"`
	// endTime
	EndTime int `yaml:"endTime" codec:"endTime"`
	// feature
	Feature string `yaml:"feature" codec:"feature"`
	// goTo
	GoTo string `yaml:"goTo" codec:"goTo"`
	// icon
	Icon interface{} `yaml:"icon" codec:"icon"`
	// openseq
	Openseq tjcsv.Slice `yaml:"openseq" codec:"openseq"`
	// priority
	Priority int `yaml:"priority" codec:"priority"`
	// reminder
	Reminder int `yaml:"reminder" codec:"reminder"`
	// serverday
	Serverday int `yaml:"serverday" codec:"serverday"`
	// sighid
	Sighid int `yaml:"sighid" codec:"sighid"`
	// startTime
	StartTime int `yaml:"startTime" codec:"startTime"`
	// startTimes
	StartTimes tjcsv.Slice `yaml:"startTimes" codec:"startTimes"`
	// txt
	Txt string `yaml:"txt" codec:"txt"`
	// unionlevel
	Unionlevel int `yaml:"unionlevel" codec:"unionlevel"`
}
// talent.csv
type Talent struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// addType1
	AddType1 int `yaml:"addType1" codec:"addType1"`
	// addType2
	AddType2 int `yaml:"addType2" codec:"addType2"`
	// attrAddDesc1
	AttrAddDesc1 string `yaml:"attrAddDesc1" codec:"attrAddDesc1"`
	// attrAddDesc2
	AttrAddDesc2 string `yaml:"attrAddDesc2" codec:"attrAddDesc2"`
	// attrDesc
	AttrDesc string `yaml:"attrDesc" codec:"attrDesc"`
	// attrNum1
	AttrNum1 float64 `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 float64 `yaml:"attrNum2" codec:"attrNum2"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// costID
	CostID int `yaml:"costID" codec:"costID"`
	// damageRelation1
	DamageRelation1 tjcsv.Slice `yaml:"damageRelation1" codec:"damageRelation1"`
	// damageRelation2
	DamageRelation2 tjcsv.Slice `yaml:"damageRelation2" codec:"damageRelation2"`
	// headIcon
	HeadIcon string `yaml:"headIcon" codec:"headIcon"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// levelUp
	LevelUp int `yaml:"levelUp" codec:"levelUp"`
	// name
	Name string `yaml:"name" codec:"name"`
	// natureType1
	NatureType1 int `yaml:"natureType1" codec:"natureType1"`
	// natureType2
	NatureType2 int `yaml:"natureType2" codec:"natureType2"`
	// preTalentID
	PreTalentID int `yaml:"preTalentID" codec:"preTalentID"`
	// preTalentLevel
	PreTalentLevel int `yaml:"preTalentLevel" codec:"preTalentLevel"`
	// roleLevel
	RoleLevel int `yaml:"roleLevel" codec:"roleLevel"`
	// treeID
	TreeID int `yaml:"treeID" codec:"treeID"`
}
// talent_cost.csv
type Talent_cost struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// costGold1
	CostGold1 int `yaml:"costGold1" codec:"costGold1"`
	// costGold10
	CostGold10 int `yaml:"costGold10" codec:"costGold10"`
	// costGold11
	CostGold11 int `yaml:"costGold11" codec:"costGold11"`
	// costGold12
	CostGold12 int `yaml:"costGold12" codec:"costGold12"`
	// costGold2
	CostGold2 int `yaml:"costGold2" codec:"costGold2"`
	// costGold3
	CostGold3 int `yaml:"costGold3" codec:"costGold3"`
	// costGold4
	CostGold4 int `yaml:"costGold4" codec:"costGold4"`
	// costGold5
	CostGold5 int `yaml:"costGold5" codec:"costGold5"`
	// costGold6
	CostGold6 int `yaml:"costGold6" codec:"costGold6"`
	// costGold7
	CostGold7 int `yaml:"costGold7" codec:"costGold7"`
	// costGold8
	CostGold8 int `yaml:"costGold8" codec:"costGold8"`
	// costGold9
	CostGold9 int `yaml:"costGold9" codec:"costGold9"`
	// costTalent1
	CostTalent1 int `yaml:"costTalent1" codec:"costTalent1"`
	// costTalent10
	CostTalent10 int `yaml:"costTalent10" codec:"costTalent10"`
	// costTalent11
	CostTalent11 int `yaml:"costTalent11" codec:"costTalent11"`
	// costTalent12
	CostTalent12 int `yaml:"costTalent12" codec:"costTalent12"`
	// costTalent2
	CostTalent2 int `yaml:"costTalent2" codec:"costTalent2"`
	// costTalent3
	CostTalent3 int `yaml:"costTalent3" codec:"costTalent3"`
	// costTalent4
	CostTalent4 int `yaml:"costTalent4" codec:"costTalent4"`
	// costTalent5
	CostTalent5 int `yaml:"costTalent5" codec:"costTalent5"`
	// costTalent6
	CostTalent6 int `yaml:"costTalent6" codec:"costTalent6"`
	// costTalent7
	CostTalent7 int `yaml:"costTalent7" codec:"costTalent7"`
	// costTalent8
	CostTalent8 int `yaml:"costTalent8" codec:"costTalent8"`
	// costTalent9
	CostTalent9 int `yaml:"costTalent9" codec:"costTalent9"`
}
// talent_tree.csv
type Talent_tree struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// des
	Des string `yaml:"des" codec:"des"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// name
	Name string `yaml:"name" codec:"name"`
	// preTalentpoint
	PreTalentpoint int `yaml:"preTalentpoint" codec:"preTalentpoint"`
	// roleLevel
	RoleLevel int `yaml:"roleLevel" codec:"roleLevel"`
	// showLevel
	ShowLevel int `yaml:"showLevel" codec:"showLevel"`
}
// tasks.csv
type Tasks struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// awardArgs
	AwardArgs tjcsv.Map `yaml:"awardArgs" codec:"awardArgs"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// goToPanel
	GoToPanel string `yaml:"goToPanel" codec:"goToPanel"`
	// group
	Group int `yaml:"group" codec:"group"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// levelReq
	LevelReq int `yaml:"levelReq" codec:"levelReq"`
	// point
	Point int `yaml:"point" codec:"point"`
	// rankInGroup
	RankInGroup int `yaml:"rankInGroup" codec:"rankInGroup"`
	// sortWeight
	SortWeight int `yaml:"sortWeight" codec:"sortWeight"`
	// targetArg
	TargetArg int `yaml:"targetArg" codec:"targetArg"`
	// targetArg2
	TargetArg2 int `yaml:"targetArg2" codec:"targetArg2"`
	// targetDisplay
	TargetDisplay int `yaml:"targetDisplay" codec:"targetDisplay"`
	// targetType
	TargetType int `yaml:"targetType" codec:"targetType"`
	// title
	Title string `yaml:"title" codec:"title"`
	// type
	Type int `yaml:"type" codec:"type"`
	// vipReq
	VipReq int `yaml:"vipReq" codec:"vipReq"`
}
// test_battle.csv
type Test_battle struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// activeSkill
	ActiveSkill int `yaml:"activeSkill" codec:"activeSkill"`
	// block
	Block int `yaml:"block" codec:"block"`
	// blockPower
	BlockPower int `yaml:"blockPower" codec:"blockPower"`
	// breakBlock
	BreakBlock int `yaml:"breakBlock" codec:"breakBlock"`
	// classify
	Classify int `yaml:"classify" codec:"classify"`
	// controlPer
	ControlPer int `yaml:"controlPer" codec:"controlPer"`
	// cure
	Cure int `yaml:"cure" codec:"cure"`
	// damage
	Damage int `yaml:"damage" codec:"damage"`
	// damageAdd
	DamageAdd int `yaml:"damageAdd" codec:"damageAdd"`
	// damageDeepen
	DamageDeepen int `yaml:"damageDeepen" codec:"damageDeepen"`
	// damageReduce
	DamageReduce int `yaml:"damageReduce" codec:"damageReduce"`
	// damageSub
	DamageSub int `yaml:"damageSub" codec:"damageSub"`
	// defence
	Defence int `yaml:"defence" codec:"defence"`
	// defenceIgnore
	DefenceIgnore int `yaml:"defenceIgnore" codec:"defenceIgnore"`
	// dodge
	Dodge int `yaml:"dodge" codec:"dodge"`
	// hit
	Hit int `yaml:"hit" codec:"hit"`
	// hp
	Hp int `yaml:"hp" codec:"hp"`
	// hpRecover
	HpRecover int `yaml:"hpRecover" codec:"hpRecover"`
	// immuneControl
	ImmuneControl int `yaml:"immuneControl" codec:"immuneControl"`
	// level
	Level int `yaml:"level" codec:"level"`
	// mp1
	Mp1 int `yaml:"mp1" codec:"mp1"`
	// mp1Recover
	Mp1Recover int `yaml:"mp1Recover" codec:"mp1Recover"`
	// mp2
	Mp2 int `yaml:"mp2" codec:"mp2"`
	// mp2Recover
	Mp2Recover int `yaml:"mp2Recover" codec:"mp2Recover"`
	// natureRestraint
	NatureRestraint int `yaml:"natureRestraint" codec:"natureRestraint"`
	// rebound
	Rebound int `yaml:"rebound" codec:"rebound"`
	// roleForce
	RoleForce int `yaml:"roleForce" codec:"roleForce"`
	// roleId
	RoleId int `yaml:"roleId" codec:"roleId"`
	// skills
	Skills tjcsv.Map `yaml:"skills" codec:"skills"`
	// specialDamage
	SpecialDamage int `yaml:"specialDamage" codec:"specialDamage"`
	// specialDefence
	SpecialDefence int `yaml:"specialDefence" codec:"specialDefence"`
	// specialDefenceIgnore
	SpecialDefenceIgnore int `yaml:"specialDefenceIgnore" codec:"specialDefenceIgnore"`
	// speed
	Speed int `yaml:"speed" codec:"speed"`
	// star
	Star int `yaml:"star" codec:"star"`
	// strike
	Strike int `yaml:"strike" codec:"strike"`
	// strikeDamage
	StrikeDamage int `yaml:"strikeDamage" codec:"strikeDamage"`
	// strikeResistance
	StrikeResistance int `yaml:"strikeResistance" codec:"strikeResistance"`
	// suckBlood
	SuckBlood int `yaml:"suckBlood" codec:"suckBlood"`
	// ultimateAdd
	UltimateAdd int `yaml:"ultimateAdd" codec:"ultimateAdd"`
	// ultimateSub
	UltimateSub int `yaml:"ultimateSub" codec:"ultimateSub"`
}
// test_force.csv
type Test_force struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// advance
	Advance int `yaml:"advance" codec:"advance"`
	// cardID
	CardID int `yaml:"cardID" codec:"cardID"`
	// level
	Level int `yaml:"level" codec:"level"`
	// priproity
	Priproity int `yaml:"priproity" codec:"priproity"`
	// star
	Star int `yaml:"star" codec:"star"`
}
// title.csv
type Title struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// alwaysDisplay
	AlwaysDisplay int `yaml:"alwaysDisplay" codec:"alwaysDisplay"`
	// attrNatureType1
	AttrNatureType1 int `yaml:"attrNatureType1" codec:"attrNatureType1"`
	// attrNatureType2
	AttrNatureType2 int `yaml:"attrNatureType2" codec:"attrNatureType2"`
	// attrNatureType3
	AttrNatureType3 int `yaml:"attrNatureType3" codec:"attrNatureType3"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// attrType3
	AttrType3 int `yaml:"attrType3" codec:"attrType3"`
	// attrValue1
	AttrValue1 string `yaml:"attrValue1" codec:"attrValue1"`
	// attrValue2
	AttrValue2 string `yaml:"attrValue2" codec:"attrValue2"`
	// attrValue3
	AttrValue3 interface{} `yaml:"attrValue3" codec:"attrValue3"`
	// color
	Color tjcsv.Slice `yaml:"color" codec:"color"`
	// condition1
	Condition1 int `yaml:"condition1" codec:"condition1"`
	// conditionDesc
	ConditionDesc string `yaml:"conditionDesc" codec:"conditionDesc"`
	// days
	Days int `yaml:"days" codec:"days"`
	// feature
	Feature string `yaml:"feature" codec:"feature"`
	// itemId
	ItemId int `yaml:"itemId" codec:"itemId"`
	// kind
	Kind int `yaml:"kind" codec:"kind"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// message
	Message string `yaml:"message" codec:"message"`
	// rank
	Rank int `yaml:"rank" codec:"rank"`
	// res
	Res string `yaml:"res" codec:"res"`
	// showType
	ShowType string `yaml:"showType" codec:"showType"`
	// title
	Title string `yaml:"title" codec:"title"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// title_type.csv
type Title_type struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// name
	Name string `yaml:"name" codec:"name"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// totem
type Totem struct {
	// totem/collection.csv
	Collection map[int]*Totem_collection `yaml:"collection" codec:"collection"`
	// totem/energy.csv
	Energy map[int]*Totem_energy `yaml:"energy" codec:"energy"`
	// totem/exchange_shop.csv
	Exchange_shop map[int]*Totem_exchange_shop `yaml:"exchange_shop" codec:"exchange_shop"`
	// totem/shop.csv
	Shop map[int]*Totem_shop `yaml:"shop" codec:"shop"`
	// totem/symbol.csv
	Symbol map[int]*Totem_symbol `yaml:"symbol" codec:"symbol"`
	// totem/symbol_group.csv
	Symbol_group map[int]*Totem_symbol_group `yaml:"symbol_group" codec:"symbol_group"`
}
// totem/collection.csv
type Totem_collection struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// activeNum
	ActiveNum int `yaml:"activeNum" codec:"activeNum"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// groupType
	GroupType int `yaml:"groupType" codec:"groupType"`
	// sort
	Sort int `yaml:"sort" codec:"sort"`
	// text
	Text string `yaml:"text" codec:"text"`
}
// totem/energy.csv
type Totem_energy struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// addType1
	AddType1 int `yaml:"addType1" codec:"addType1"`
	// addType2
	AddType2 int `yaml:"addType2" codec:"addType2"`
	// attrAddDesc1
	AttrAddDesc1 string `yaml:"attrAddDesc1" codec:"attrAddDesc1"`
	// attrAddDesc2
	AttrAddDesc2 string `yaml:"attrAddDesc2" codec:"attrAddDesc2"`
	// attrDesc
	AttrDesc string `yaml:"attrDesc" codec:"attrDesc"`
	// attrNum1
	AttrNum1 string `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 string `yaml:"attrNum2" codec:"attrNum2"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// powerNum
	PowerNum int `yaml:"powerNum" codec:"powerNum"`
	// symbolGroupType
	SymbolGroupType int `yaml:"symbolGroupType" codec:"symbolGroupType"`
}
// totem/exchange_shop.csv
type Totem_exchange_shop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// exchangeLimit
	ExchangeLimit int `yaml:"exchangeLimit" codec:"exchangeLimit"`
	// group
	Group int `yaml:"group" codec:"group"`
	// itemMap
	ItemMap tjcsv.Map `yaml:"itemMap" codec:"itemMap"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
	// limitTimes
	LimitTimes int `yaml:"limitTimes" codec:"limitTimes"`
	// limitType
	LimitType int `yaml:"limitType" codec:"limitType"`
	// regainHour
	RegainHour int `yaml:"regainHour" codec:"regainHour"`
	// showUnable
	ShowUnable bool `yaml:"showUnable" codec:"showUnable"`
	// sortValue
	SortValue int `yaml:"sortValue" codec:"sortValue"`
	// vipStart
	VipStart int `yaml:"vipStart" codec:"vipStart"`
}
// totem/shop.csv
type Totem_shop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// itemCount
	ItemCount int `yaml:"itemCount" codec:"itemCount"`
	// itemMap
	ItemMap tjcsv.Map `yaml:"itemMap" codec:"itemMap"`
	// itemWeightMap
	ItemWeightMap tjcsv.Map `yaml:"itemWeightMap" codec:"itemWeightMap"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
	// limitTimes
	LimitTimes int `yaml:"limitTimes" codec:"limitTimes"`
	// limitType
	LimitType int `yaml:"limitType" codec:"limitType"`
	// position
	Position int `yaml:"position" codec:"position"`
	// showUnable
	ShowUnable bool `yaml:"showUnable" codec:"showUnable"`
	// type
	Type int `yaml:"type" codec:"type"`
	// vipStart
	VipStart int `yaml:"vipStart" codec:"vipStart"`
	// vipWeight
	VipWeight int `yaml:"vipWeight" codec:"vipWeight"`
}
// totem/symbol.csv
type Totem_symbol struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNum1
	AttrNum1 string `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 string `yaml:"attrNum2" codec:"attrNum2"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// extraAttrNum1
	ExtraAttrNum1 int `yaml:"extraAttrNum1" codec:"extraAttrNum1"`
	// extraAttrNum2
	ExtraAttrNum2 int `yaml:"extraAttrNum2" codec:"extraAttrNum2"`
	// extraAttrsType1
	ExtraAttrsType1 int `yaml:"extraAttrsType1" codec:"extraAttrsType1"`
	// extraAttrsType2
	ExtraAttrsType2 int `yaml:"extraAttrsType2" codec:"extraAttrsType2"`
	// name
	Name string `yaml:"name" codec:"name"`
	// nature
	Nature tjcsv.Slice `yaml:"nature" codec:"nature"`
	// power
	Power int `yaml:"power" codec:"power"`
	// sort
	Sort int `yaml:"sort" codec:"sort"`
	// symbolGroupType
	SymbolGroupType int `yaml:"symbolGroupType" codec:"symbolGroupType"`
	// symbolPosition
	SymbolPosition tjcsv.Slice `yaml:"symbolPosition" codec:"symbolPosition"`
	// totemGroup1
	TotemGroup1 tjcsv.Slice `yaml:"totemGroup1" codec:"totemGroup1"`
}
// totem/symbol_group.csv
type Totem_symbol_group struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// name
	Name string `yaml:"name" codec:"name"`
	// showEnergy
	ShowEnergy int `yaml:"showEnergy" codec:"showEnergy"`
	// spineAnimation
	SpineAnimation string `yaml:"spineAnimation" codec:"spineAnimation"`
	// unlockEnergy
	UnlockEnergy int `yaml:"unlockEnergy" codec:"unlockEnergy"`
}
// town
type Town struct {
	// town/adventure.csv
	Adventure map[int]*Town_adventure `yaml:"adventure" codec:"adventure"`
	// town/adventure_award.csv
	Adventure_award map[int]*Town_adventure_award `yaml:"adventure_award" codec:"adventure_award"`
	// town/adventure_text.csv
	Adventure_text map[int]*Town_adventure_text `yaml:"adventure_text" codec:"adventure_text"`
	// town/building.csv
	Building map[int]*Town_building `yaml:"building" codec:"building"`
	// town/condition.csv
	Condition map[int]*Town_condition `yaml:"condition" codec:"condition"`
	// town/energy.csv
	Energy map[int]*Town_energy `yaml:"energy" codec:"energy"`
	// town/home.csv
	Home map[int]*Town_home `yaml:"home" codec:"home"`
	// town/home_collection.csv
	Home_collection map[int]*Town_home_collection `yaml:"home_collection" codec:"home_collection"`
	// town/home_furniture.csv
	Home_furniture map[int]*Town_home_furniture `yaml:"home_furniture" codec:"home_furniture"`
	// town/home_furniture_series.csv
	Home_furniture_series map[int]*Town_home_furniture_series `yaml:"home_furniture_series" codec:"home_furniture_series"`
	// town/home_furniture_type.csv
	Home_furniture_type map[int]*Town_home_furniture_type `yaml:"home_furniture_type" codec:"home_furniture_type"`
	// town/home_shop.csv
	Home_shop map[int]*Town_home_shop `yaml:"home_shop" codec:"home_shop"`
	// town/production_base.csv
	Production_base map[int]*Town_production_base `yaml:"production_base" codec:"production_base"`
	// town/skill.csv
	Skill map[int]*Town_skill `yaml:"skill" codec:"skill"`
	// town/skill_effect.csv
	Skill_effect map[int]*Town_skill_effect `yaml:"skill_effect" codec:"skill_effect"`
	// town/wall_floor.csv
	Wall_floor map[int]*Town_wall_floor `yaml:"wall_floor" codec:"wall_floor"`
}
// town/adventure.csv
type Town_adventure struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// actionCost1
	ActionCost1 int `yaml:"actionCost1" codec:"actionCost1"`
	// actionCost2
	ActionCost2 int `yaml:"actionCost2" codec:"actionCost2"`
	// actionCost3
	ActionCost3 int `yaml:"actionCost3" codec:"actionCost3"`
	// areaType
	AreaType int `yaml:"areaType" codec:"areaType"`
	// condition
	Condition tjcsv.Map `yaml:"condition" codec:"condition"`
	// energyCost1
	EnergyCost1 int `yaml:"energyCost1" codec:"energyCost1"`
	// energyCost2
	EnergyCost2 int `yaml:"energyCost2" codec:"energyCost2"`
	// energyCost3
	EnergyCost3 int `yaml:"energyCost3" codec:"energyCost3"`
	// explorationPoint
	ExplorationPoint int `yaml:"explorationPoint" codec:"explorationPoint"`
	// exploreValue1
	ExploreValue1 int `yaml:"exploreValue1" codec:"exploreValue1"`
	// exploreValue2
	ExploreValue2 int `yaml:"exploreValue2" codec:"exploreValue2"`
	// exploreValue3
	ExploreValue3 int `yaml:"exploreValue3" codec:"exploreValue3"`
	// normalRewards1
	NormalRewards1 int `yaml:"normalRewards1" codec:"normalRewards1"`
	// normalRewards2
	NormalRewards2 int `yaml:"normalRewards2" codec:"normalRewards2"`
	// normalRewards3
	NormalRewards3 int `yaml:"normalRewards3" codec:"normalRewards3"`
	// randomRewards1
	RandomRewards1 tjcsv.Map `yaml:"randomRewards1" codec:"randomRewards1"`
	// randomRewards2
	RandomRewards2 tjcsv.Map `yaml:"randomRewards2" codec:"randomRewards2"`
	// randomRewards3
	RandomRewards3 tjcsv.Map `yaml:"randomRewards3" codec:"randomRewards3"`
	// stage
	Stage int `yaml:"stage" codec:"stage"`
	// stageName
	StageName string `yaml:"stageName" codec:"stageName"`
	// timeCost1
	TimeCost1 int `yaml:"timeCost1" codec:"timeCost1"`
	// timeCost2
	TimeCost2 int `yaml:"timeCost2" codec:"timeCost2"`
	// timeCost3
	TimeCost3 int `yaml:"timeCost3" codec:"timeCost3"`
}
// town/adventure_award.csv
type Town_adventure_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// awardType
	AwardType int `yaml:"awardType" codec:"awardType"`
	// awards
	Awards tjcsv.Map `yaml:"awards" codec:"awards"`
	// needExplorationPoint
	NeedExplorationPoint int `yaml:"needExplorationPoint" codec:"needExplorationPoint"`
	// randomBelongID
	RandomBelongID int `yaml:"randomBelongID" codec:"randomBelongID"`
}
// town/adventure_text.csv
type Town_adventure_text struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// areaType
	AreaType int `yaml:"areaType" codec:"areaType"`
	// text
	Text interface{} `yaml:"text" codec:"text"`
	// textType
	TextType int `yaml:"textType" codec:"textType"`
}
// town/building.csv
type Town_building struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// buildID
	BuildID int `yaml:"buildID" codec:"buildID"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// level
	Level int `yaml:"level" codec:"level"`
	// levelUpCost
	LevelUpCost tjcsv.Map `yaml:"levelUpCost" codec:"levelUpCost"`
	// levelUpCostTime
	LevelUpCostTime int `yaml:"levelUpCostTime" codec:"levelUpCostTime"`
	// name
	Name string `yaml:"name" codec:"name"`
	// upgradeConditions
	UpgradeConditions tjcsv.Slice `yaml:"upgradeConditions" codec:"upgradeConditions"`
}
// town/condition.csv
type Town_condition struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// taskParam
	TaskParam int `yaml:"taskParam" codec:"taskParam"`
	// taskSpecialParam
	TaskSpecialParam tjcsv.Map `yaml:"taskSpecialParam" codec:"taskSpecialParam"`
	// taskType
	TaskType int `yaml:"taskType" codec:"taskType"`
}
// town/energy.csv
type Town_energy struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// advanceAdd
	AdvanceAdd int `yaml:"advanceAdd" codec:"advanceAdd"`
	// rarity
	Rarity int `yaml:"rarity" codec:"rarity"`
	// starAdd
	StarAdd int `yaml:"starAdd" codec:"starAdd"`
}
// town/home.csv
type Town_home struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// cardNum
	CardNum int `yaml:"cardNum" codec:"cardNum"`
	// defaultIDs
	DefaultIDs tjcsv.Map `yaml:"defaultIDs" codec:"defaultIDs"`
	// furnitureLimitNum
	FurnitureLimitNum int `yaml:"furnitureLimitNum" codec:"furnitureLimitNum"`
	// notice1
	Notice1 string `yaml:"notice1" codec:"notice1"`
	// notice2
	Notice2 string `yaml:"notice2" codec:"notice2"`
	// reply
	Reply int `yaml:"reply" codec:"reply"`
}
// town/home_collection.csv
type Town_home_collection struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// addAttrs
	AddAttrs tjcsv.Map `yaml:"addAttrs" codec:"addAttrs"`
	// level
	Level int `yaml:"level" codec:"level"`
	// needExp
	NeedExp int `yaml:"needExp" codec:"needExp"`
}
// town/home_furniture.csv
type Town_home_furniture struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attr
	Attr tjcsv.Map `yaml:"attr" codec:"attr"`
	// currentNum
	CurrentNum bool `yaml:"currentNum" codec:"currentNum"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// expAdd
	ExpAdd int `yaml:"expAdd" codec:"expAdd"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// name
	Name string `yaml:"name" codec:"name"`
	// position
	Position int `yaml:"position" codec:"position"`
	// quality
	Quality int `yaml:"quality" codec:"quality"`
	// relSize
	RelSize tjcsv.Map `yaml:"relSize" codec:"relSize"`
	// res
	Res string `yaml:"res" codec:"res"`
	// series
	Series int `yaml:"series" codec:"series"`
	// size
	Size tjcsv.Map `yaml:"size" codec:"size"`
	// stackMax
	StackMax int `yaml:"stackMax" codec:"stackMax"`
	// startPos
	StartPos tjcsv.Map `yaml:"startPos" codec:"startPos"`
	// startResScale
	StartResScale int `yaml:"startResScale" codec:"startResScale"`
	// touchSize
	TouchSize tjcsv.Slice `yaml:"touchSize" codec:"touchSize"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// town/home_furniture_series.csv
type Town_home_furniture_series struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// addAttrs
	AddAttrs tjcsv.Map `yaml:"addAttrs" codec:"addAttrs"`
	// expAdd
	ExpAdd int `yaml:"expAdd" codec:"expAdd"`
	// name
	Name string `yaml:"name" codec:"name"`
	// rarity
	Rarity int `yaml:"rarity" codec:"rarity"`
}
// town/home_furniture_type.csv
type Town_home_furniture_type struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// frontType
	FrontType int `yaml:"frontType" codec:"frontType"`
	// name
	Name string `yaml:"name" codec:"name"`
	// showType
	ShowType int `yaml:"showType" codec:"showType"`
}
// town/home_shop.csv
type Town_home_shop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// exchangeLimit
	ExchangeLimit int `yaml:"exchangeLimit" codec:"exchangeLimit"`
	// itemMap
	ItemMap tjcsv.Map `yaml:"itemMap" codec:"itemMap"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
	// limitTimes
	LimitTimes int `yaml:"limitTimes" codec:"limitTimes"`
	// limitType
	LimitType int `yaml:"limitType" codec:"limitType"`
	// regainHour
	RegainHour int `yaml:"regainHour" codec:"regainHour"`
	// showUnable
	ShowUnable bool `yaml:"showUnable" codec:"showUnable"`
	// vipStart
	VipStart int `yaml:"vipStart" codec:"vipStart"`
}
// town/production_base.csv
type Town_production_base struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// baseID
	BaseID int `yaml:"baseID" codec:"baseID"`
	// baseType
	BaseType int `yaml:"baseType" codec:"baseType"`
	// efficient
	Efficient int `yaml:"efficient" codec:"efficient"`
	// energyExpend
	EnergyExpend int `yaml:"energyExpend" codec:"energyExpend"`
	// inventory
	Inventory int `yaml:"inventory" codec:"inventory"`
	// item
	Item int `yaml:"item" codec:"item"`
	// level
	Level int `yaml:"level" codec:"level"`
	// orderCostItem
	OrderCostItem tjcsv.Map `yaml:"orderCostItem" codec:"orderCostItem"`
	// orderCostTime
	OrderCostTime int `yaml:"orderCostTime" codec:"orderCostTime"`
	// slotCapacityAdd
	SlotCapacityAdd int `yaml:"slotCapacityAdd" codec:"slotCapacityAdd"`
	// slotStockAdd
	SlotStockAdd int `yaml:"slotStockAdd" codec:"slotStockAdd"`
	// slotTimeAdd
	SlotTimeAdd string `yaml:"slotTimeAdd" codec:"slotTimeAdd"`
	// unlockSeat
	UnlockSeat int `yaml:"unlockSeat" codec:"unlockSeat"`
}
// town/skill.csv
type Town_skill struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// belongBase
	BelongBase int `yaml:"belongBase" codec:"belongBase"`
	// desc
	Desc interface{} `yaml:"desc" codec:"desc"`
	// effect
	Effect tjcsv.Slice `yaml:"effect" codec:"effect"`
	// icon
	Icon interface{} `yaml:"icon" codec:"icon"`
	// level
	Level int `yaml:"level" codec:"level"`
	// name
	Name interface{} `yaml:"name" codec:"name"`
	// skill
	Skill int `yaml:"skill" codec:"skill"`
	// type
	Type int `yaml:"type" codec:"type"`
	// upgradeCondition
	UpgradeCondition tjcsv.Slice `yaml:"upgradeCondition" codec:"upgradeCondition"`
}
// town/skill_effect.csv
type Town_skill_effect struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// param1
	Param1 string `yaml:"param1" codec:"param1"`
	// param2
	Param2 string `yaml:"param2" codec:"param2"`
	// param3
	Param3 int `yaml:"param3" codec:"param3"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// town/wall_floor.csv
type Town_wall_floor struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attr
	Attr tjcsv.Map `yaml:"attr" codec:"attr"`
	// furnId
	FurnId int `yaml:"furnId" codec:"furnId"`
	// res
	Res string `yaml:"res" codec:"res"`
	// roomID
	RoomID int `yaml:"roomID" codec:"roomID"`
	// size
	Size tjcsv.Map `yaml:"size" codec:"size"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// trainer
type Trainer struct {
	// trainer/attr_skills.csv
	Attr_skills map[int]*Trainer_attr_skills `yaml:"attr_skills" codec:"attr_skills"`
	// trainer/skills.csv
	Skills map[int]*Trainer_skills `yaml:"skills" codec:"skills"`
	// trainer/trainer_level.csv
	Trainer_level map[int]*Trainer_trainer_level `yaml:"trainer_level" codec:"trainer_level"`
}
// trainer/attr_skills.csv
type Trainer_attr_skills struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrValue
	AttrValue int `yaml:"attrValue" codec:"attrValue"`
	// desc
	Desc interface{} `yaml:"desc" codec:"desc"`
	// icon
	Icon interface{} `yaml:"icon" codec:"icon"`
	// levelMax
	LevelMax int `yaml:"levelMax" codec:"levelMax"`
	// name
	Name string `yaml:"name" codec:"name"`
	// totalAttrLevel
	TotalAttrLevel int `yaml:"totalAttrLevel" codec:"totalAttrLevel"`
	// trainerLevel
	TrainerLevel int `yaml:"trainerLevel" codec:"trainerLevel"`
	// upCost
	UpCost tjcsv.Map `yaml:"upCost" codec:"upCost"`
}
// trainer/skills.csv
type Trainer_skills struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// arg
	Arg int `yaml:"arg" codec:"arg"`
	// desc1
	Desc1 string `yaml:"desc1" codec:"desc1"`
	// desc2
	Desc2 string `yaml:"desc2" codec:"desc2"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// levelMax
	LevelMax int `yaml:"levelMax" codec:"levelMax"`
	// name
	Name string `yaml:"name" codec:"name"`
	// nums
	Nums tjcsv.Slice `yaml:"nums" codec:"nums"`
	// type
	Type int `yaml:"type" codec:"type"`
	// upCost
	UpCost tjcsv.Map `yaml:"upCost" codec:"upCost"`
}
// trainer/trainer_level.csv
type Trainer_trainer_level struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrs
	Attrs tjcsv.Map `yaml:"attrs" codec:"attrs"`
	// dailyAward
	DailyAward tjcsv.Map `yaml:"dailyAward" codec:"dailyAward"`
	// firstAward
	FirstAward tjcsv.Map `yaml:"firstAward" codec:"firstAward"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// isShowNext
	IsShowNext int `yaml:"isShowNext" codec:"isShowNext"`
	// name
	Name string `yaml:"name" codec:"name"`
	// needExp
	NeedExp int `yaml:"needExp" codec:"needExp"`
	// privilege
	Privilege tjcsv.Map `yaml:"privilege" codec:"privilege"`
	// skills
	Skills tjcsv.Slice `yaml:"skills" codec:"skills"`
}
// try_play_battle.csv
type Try_play_battle struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// activeSkill
	ActiveSkill int `yaml:"activeSkill" codec:"activeSkill"`
	// block
	Block int `yaml:"block" codec:"block"`
	// blockPower
	BlockPower int `yaml:"blockPower" codec:"blockPower"`
	// breakBlock
	BreakBlock int `yaml:"breakBlock" codec:"breakBlock"`
	// classify
	Classify int `yaml:"classify" codec:"classify"`
	// controlPer
	ControlPer int `yaml:"controlPer" codec:"controlPer"`
	// cure
	Cure int `yaml:"cure" codec:"cure"`
	// damage
	Damage int `yaml:"damage" codec:"damage"`
	// damageAdd
	DamageAdd int `yaml:"damageAdd" codec:"damageAdd"`
	// damageDeepen
	DamageDeepen int `yaml:"damageDeepen" codec:"damageDeepen"`
	// damageReduce
	DamageReduce int `yaml:"damageReduce" codec:"damageReduce"`
	// damageSub
	DamageSub int `yaml:"damageSub" codec:"damageSub"`
	// defence
	Defence int `yaml:"defence" codec:"defence"`
	// defenceIgnore
	DefenceIgnore int `yaml:"defenceIgnore" codec:"defenceIgnore"`
	// dodge
	Dodge int `yaml:"dodge" codec:"dodge"`
	// hit
	Hit int `yaml:"hit" codec:"hit"`
	// hp
	Hp int `yaml:"hp" codec:"hp"`
	// hpRecover
	HpRecover int `yaml:"hpRecover" codec:"hpRecover"`
	// immuneControl
	ImmuneControl int `yaml:"immuneControl" codec:"immuneControl"`
	// initMp1
	InitMp1 int `yaml:"initMp1" codec:"initMp1"`
	// level
	Level int `yaml:"level" codec:"level"`
	// mp1
	Mp1 int `yaml:"mp1" codec:"mp1"`
	// mp1Recover
	Mp1Recover int `yaml:"mp1Recover" codec:"mp1Recover"`
	// mp2
	Mp2 int `yaml:"mp2" codec:"mp2"`
	// mp2Recover
	Mp2Recover int `yaml:"mp2Recover" codec:"mp2Recover"`
	// natureRestraint
	NatureRestraint int `yaml:"natureRestraint" codec:"natureRestraint"`
	// roleForce
	RoleForce int `yaml:"roleForce" codec:"roleForce"`
	// roleId
	RoleId int `yaml:"roleId" codec:"roleId"`
	// skills
	Skills tjcsv.Map `yaml:"skills" codec:"skills"`
	// specialDamage
	SpecialDamage int `yaml:"specialDamage" codec:"specialDamage"`
	// specialDefence
	SpecialDefence int `yaml:"specialDefence" codec:"specialDefence"`
	// specialDefenceIgnore
	SpecialDefenceIgnore int `yaml:"specialDefenceIgnore" codec:"specialDefenceIgnore"`
	// speed
	Speed int `yaml:"speed" codec:"speed"`
	// star
	Star int `yaml:"star" codec:"star"`
	// strike
	Strike int `yaml:"strike" codec:"strike"`
	// strikeDamage
	StrikeDamage int `yaml:"strikeDamage" codec:"strikeDamage"`
	// strikeResistance
	StrikeResistance int `yaml:"strikeResistance" codec:"strikeResistance"`
	// suckBlood
	SuckBlood int `yaml:"suckBlood" codec:"suckBlood"`
	// suckBlood1
	SuckBlood1 int `yaml:"suckBlood1" codec:"suckBlood1"`
	// ultimateAdd
	UltimateAdd int `yaml:"ultimateAdd" codec:"ultimateAdd"`
	// ultimateSub
	UltimateSub int `yaml:"ultimateSub" codec:"ultimateSub"`
}
// union
type Union struct {
	// union/contrib.csv
	Contrib map[int]*Union_contrib `yaml:"contrib" codec:"contrib"`
	// union/daily_notice.csv
	Daily_notice map[int]*Union_daily_notice `yaml:"daily_notice" codec:"daily_notice"`
	// union/history.csv
	History map[int]*Union_history `yaml:"history" codec:"history"`
	// union/red_packet.csv
	Red_packet map[int]*Union_red_packet `yaml:"red_packet" codec:"red_packet"`
	// union/training.csv
	Training map[int]*Union_training `yaml:"training" codec:"training"`
	// union/union_frag_donate.csv
	Union_frag_donate map[int]*Union_union_frag_donate `yaml:"union_frag_donate" codec:"union_frag_donate"`
	// union/union_frag_donate_award.csv
	Union_frag_donate_award map[int]*Union_union_frag_donate_award `yaml:"union_frag_donate_award" codec:"union_frag_donate_award"`
	// union/union_fuben.csv
	Union_fuben map[int]*Union_union_fuben `yaml:"union_fuben" codec:"union_fuben"`
	// union/union_fuben_buff.csv
	Union_fuben_buff map[int]*Union_union_fuben_buff `yaml:"union_fuben_buff" codec:"union_fuben_buff"`
	// union/union_fuben_rank.csv
	Union_fuben_rank map[int]*Union_union_fuben_rank `yaml:"union_fuben_rank" codec:"union_fuben_rank"`
	// union/union_level.csv
	Union_level map[int]*Union_union_level `yaml:"union_level" codec:"union_level"`
	// union/union_logo.csv
	Union_logo map[int]*Union_union_logo `yaml:"union_logo" codec:"union_logo"`
	// union/union_shop.csv
	Union_shop map[int]*Union_union_shop `yaml:"union_shop" codec:"union_shop"`
	// union/union_skill.csv
	Union_skill map[int]*Union_union_skill `yaml:"union_skill" codec:"union_skill"`
	// union/union_skill_level.csv
	Union_skill_level map[int]*Union_union_skill_level `yaml:"union_skill_level" codec:"union_skill_level"`
	// union/union_task.csv
	Union_task map[int]*Union_union_task `yaml:"union_task" codec:"union_task"`
}
// union/contrib.csv
type Union_contrib struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// contrib
	Contrib int `yaml:"contrib" codec:"contrib"`
	// cost
	Cost tjcsv.Map `yaml:"cost" codec:"cost"`
	// title
	Title string `yaml:"title" codec:"title"`
	// vipNeed
	VipNeed int `yaml:"vipNeed" codec:"vipNeed"`
}
// union/daily_notice.csv
type Union_daily_notice struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// targetType
	TargetType string `yaml:"targetType" codec:"targetType"`
	// tarhetArg
	TarhetArg int `yaml:"tarhetArg" codec:"tarhetArg"`
}
// union/history.csv
type Union_history struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// fmt
	Fmt string `yaml:"fmt" codec:"fmt"`
}
// union/red_packet.csv
type Union_red_packet struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// conditionNum
	ConditionNum int `yaml:"conditionNum" codec:"conditionNum"`
	// conditionType
	ConditionType int `yaml:"conditionType" codec:"conditionType"`
	// date
	Date int `yaml:"date" codec:"date"`
	// name
	Name string `yaml:"name" codec:"name"`
	// showType
	ShowType int `yaml:"showType" codec:"showType"`
	// sortVal
	SortVal int `yaml:"sortVal" codec:"sortVal"`
	// tipText
	TipText string `yaml:"tipText" codec:"tipText"`
	// totalCount
	TotalCount int `yaml:"totalCount" codec:"totalCount"`
	// totalVal
	TotalVal tjcsv.Map `yaml:"totalVal" codec:"totalVal"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// union/training.csv
type Union_training struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// costRMB
	CostRMB int `yaml:"costRMB" codec:"costRMB"`
	// openLevel
	OpenLevel int `yaml:"openLevel" codec:"openLevel"`
	// openVIP
	OpenVIP int `yaml:"openVIP" codec:"openVIP"`
}
// union/union_frag_donate.csv
type Union_union_frag_donate struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// point
	Point int `yaml:"point" codec:"point"`
	// totalmax
	Totalmax int `yaml:"totalmax" codec:"totalmax"`
}
// union/union_frag_donate_award.csv
type Union_union_frag_donate_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// point
	Point int `yaml:"point" codec:"point"`
}
// union/union_fuben.csv
type Union_union_fuben struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// challengeAward
	ChallengeAward tjcsv.Map `yaml:"challengeAward" codec:"challengeAward"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// firstAward
	FirstAward tjcsv.Map `yaml:"firstAward" codec:"firstAward"`
	// gateID
	GateID int `yaml:"gateID" codec:"gateID"`
	// killAward
	KillAward tjcsv.Map `yaml:"killAward" codec:"killAward"`
	// name
	Name string `yaml:"name" codec:"name"`
	// repeatAward
	RepeatAward tjcsv.Map `yaml:"repeatAward" codec:"repeatAward"`
}
// union/union_fuben_buff.csv
type Union_union_fuben_buff struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// buff
	Buff int `yaml:"buff" codec:"buff"`
	// max
	Max int `yaml:"max" codec:"max"`
}
// union/union_fuben_rank.csv
type Union_union_fuben_rank struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// range
	Range tjcsv.Slice `yaml:"range" codec:"range"`
}
// union/union_level.csv
type Union_union_level struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// ContribMax
	ContribMax int `yaml:"ContribMax" codec:"ContribMax"`
	// ContribSumMax
	ContribSumMax int `yaml:"ContribSumMax" codec:"ContribSumMax"`
	// dailyGift
	DailyGift tjcsv.Map `yaml:"dailyGift" codec:"dailyGift"`
	// dailyPacket1
	DailyPacket1 tjcsv.Map `yaml:"dailyPacket1" codec:"dailyPacket1"`
	// dailyPacket2
	DailyPacket2 tjcsv.Map `yaml:"dailyPacket2" codec:"dailyPacket2"`
	// dailyPacket3
	DailyPacket3 tjcsv.Map `yaml:"dailyPacket3" codec:"dailyPacket3"`
	// levelUpContrib
	LevelUpContrib int `yaml:"levelUpContrib" codec:"levelUpContrib"`
	// memberMax
	MemberMax int `yaml:"memberMax" codec:"memberMax"`
	// notice1
	Notice1 string `yaml:"notice1" codec:"notice1"`
	// notice2
	Notice2 string `yaml:"notice2" codec:"notice2"`
	// notice3
	Notice3 interface{} `yaml:"notice3" codec:"notice3"`
	// notice4
	Notice4 interface{} `yaml:"notice4" codec:"notice4"`
	// openFeature
	OpenFeature tjcsv.Slice `yaml:"openFeature" codec:"openFeature"`
	// skillLvMax
	SkillLvMax int `yaml:"skillLvMax" codec:"skillLvMax"`
	// taskExpMax
	TaskExpMax int `yaml:"taskExpMax" codec:"taskExpMax"`
	// totalCount1
	TotalCount1 int `yaml:"totalCount1" codec:"totalCount1"`
	// totalCount2
	TotalCount2 int `yaml:"totalCount2" codec:"totalCount2"`
	// totalCount3
	TotalCount3 int `yaml:"totalCount3" codec:"totalCount3"`
	// trainingExp
	TrainingExp float64 `yaml:"trainingExp" codec:"trainingExp"`
	// viceChairmanMax
	ViceChairmanMax int `yaml:"viceChairmanMax" codec:"viceChairmanMax"`
}
// union/union_logo.csv
type Union_union_logo struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
}
// union/union_shop.csv
type Union_union_shop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// itemCount
	ItemCount int `yaml:"itemCount" codec:"itemCount"`
	// itemWeightMap
	ItemWeightMap tjcsv.Map `yaml:"itemWeightMap" codec:"itemWeightMap"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
	// limitTimes
	LimitTimes int `yaml:"limitTimes" codec:"limitTimes"`
	// limitType
	LimitType int `yaml:"limitType" codec:"limitType"`
	// position
	Position int `yaml:"position" codec:"position"`
	// showUnable
	ShowUnable bool `yaml:"showUnable" codec:"showUnable"`
	// vipStart
	VipStart int `yaml:"vipStart" codec:"vipStart"`
	// vipWeight
	VipWeight int `yaml:"vipWeight" codec:"vipWeight"`
}
// union/union_skill.csv
type Union_union_skill struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNatureType
	AttrNatureType int `yaml:"attrNatureType" codec:"attrNatureType"`
	// attrType
	AttrType int `yaml:"attrType" codec:"attrType"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// name
	Name string `yaml:"name" codec:"name"`
	// needGuildLv
	NeedGuildLv int `yaml:"needGuildLv" codec:"needGuildLv"`
	// preSkill
	PreSkill tjcsv.Slice `yaml:"preSkill" codec:"preSkill"`
	// sort
	Sort int `yaml:"sort" codec:"sort"`
}
// union/union_skill_level.csv
type Union_union_skill_level struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrValue
	AttrValue string `yaml:"attrValue" codec:"attrValue"`
	// cost
	Cost tjcsv.Map `yaml:"cost" codec:"cost"`
	// level
	Level int `yaml:"level" codec:"level"`
	// skillID
	SkillID int `yaml:"skillID" codec:"skillID"`
}
// union/union_task.csv
type Union_union_task struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// contrib
	Contrib int `yaml:"contrib" codec:"contrib"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// sortID
	SortID int `yaml:"sortID" codec:"sortID"`
	// targetArg
	TargetArg int `yaml:"targetArg" codec:"targetArg"`
	// targetDisplay
	TargetDisplay int `yaml:"targetDisplay" codec:"targetDisplay"`
	// targetType
	TargetType int `yaml:"targetType" codec:"targetType"`
	// type
	Type int `yaml:"type" codec:"type"`
	// userType
	UserType int `yaml:"userType" codec:"userType"`
}
// union_fight
type Union_fight struct {
	// union_fight/base.csv
	Base map[int]*Union_fight_base `yaml:"base" codec:"base"`
	// union_fight/battle_fix.csv
	Battle_fix map[int]*Union_fight_battle_fix `yaml:"battle_fix" codec:"battle_fix"`
	// union_fight/finalrank.csv
	Finalrank map[int]*Union_fight_finalrank `yaml:"finalrank" codec:"finalrank"`
	// union_fight/nature_limit.csv
	Nature_limit map[int]*Union_fight_nature_limit `yaml:"nature_limit" codec:"nature_limit"`
	// union_fight/point_fix.csv
	Point_fix map[int]*Union_fight_point_fix `yaml:"point_fix" codec:"point_fix"`
	// union_fight/prerank.csv
	Prerank map[int]*Union_fight_prerank `yaml:"prerank" codec:"prerank"`
	// union_fight/rank_point.csv
	Rank_point map[int]*Union_fight_rank_point `yaml:"rank_point" codec:"rank_point"`
	// union_fight/shop.csv
	Shop map[int]*Union_fight_shop `yaml:"shop" codec:"shop"`
}
// union_fight/base.csv
type Union_fight_base struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// autoSignVIP
	AutoSignVIP int `yaml:"autoSignVIP" codec:"autoSignVIP"`
	// betRateFix
	BetRateFix int `yaml:"betRateFix" codec:"betRateFix"`
	// failPoint
	FailPoint int `yaml:"failPoint" codec:"failPoint"`
	// finalSignAward
	FinalSignAward tjcsv.Map `yaml:"finalSignAward" codec:"finalSignAward"`
	// maxBetWin
	MaxBetWin int `yaml:"maxBetWin" codec:"maxBetWin"`
	// minBetRate
	MinBetRate int `yaml:"minBetRate" codec:"minBetRate"`
	// preSignAward
	PreSignAward tjcsv.Map `yaml:"preSignAward" codec:"preSignAward"`
	// servOpenDays
	ServOpenDays int `yaml:"servOpenDays" codec:"servOpenDays"`
	// winAward
	WinAward tjcsv.Map `yaml:"winAward" codec:"winAward"`
	// winLimit
	WinLimit int `yaml:"winLimit" codec:"winLimit"`
	// winPoint
	WinPoint int `yaml:"winPoint" codec:"winPoint"`
}
// union_fight/battle_fix.csv
type Union_fight_battle_fix struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrFix1
	AttrFix1 float64 `yaml:"attrFix1" codec:"attrFix1"`
	// attrFix2
	AttrFix2 float64 `yaml:"attrFix2" codec:"attrFix2"`
	// attrFix3
	AttrFix3 float64 `yaml:"attrFix3" codec:"attrFix3"`
	// attrFix4
	AttrFix4 float64 `yaml:"attrFix4" codec:"attrFix4"`
	// attrFix5
	AttrFix5 float64 `yaml:"attrFix5" codec:"attrFix5"`
	// attrFix6
	AttrFix6 float64 `yaml:"attrFix6" codec:"attrFix6"`
	// attrFix7
	AttrFix7 float64 `yaml:"attrFix7" codec:"attrFix7"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// attrType3
	AttrType3 int `yaml:"attrType3" codec:"attrType3"`
	// attrType4
	AttrType4 int `yaml:"attrType4" codec:"attrType4"`
	// attrType5
	AttrType5 int `yaml:"attrType5" codec:"attrType5"`
	// attrType6
	AttrType6 int `yaml:"attrType6" codec:"attrType6"`
	// attrType7
	AttrType7 int `yaml:"attrType7" codec:"attrType7"`
}
// union_fight/finalrank.csv
type Union_fight_finalrank struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// point
	Point int `yaml:"point" codec:"point"`
	// range
	Range tjcsv.Slice `yaml:"range" codec:"range"`
	// rankMax
	RankMax int `yaml:"rankMax" codec:"rankMax"`
}
// union_fight/nature_limit.csv
type Union_fight_nature_limit struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// natureLimit
	NatureLimit tjcsv.Slice `yaml:"natureLimit" codec:"natureLimit"`
	// weekDay
	WeekDay int `yaml:"weekDay" codec:"weekDay"`
}
// union_fight/point_fix.csv
type Union_fight_point_fix struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// pointFix
	PointFix int `yaml:"pointFix" codec:"pointFix"`
}
// union_fight/prerank.csv
type Union_fight_prerank struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// point
	Point int `yaml:"point" codec:"point"`
	// range
	Range tjcsv.Slice `yaml:"range" codec:"range"`
	// rankMax
	RankMax int `yaml:"rankMax" codec:"rankMax"`
}
// union_fight/rank_point.csv
type Union_fight_rank_point struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// point
	Point int `yaml:"point" codec:"point"`
}
// union_fight/shop.csv
type Union_fight_shop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// exchangeLimit
	ExchangeLimit int `yaml:"exchangeLimit" codec:"exchangeLimit"`
	// itemMap
	ItemMap tjcsv.Map `yaml:"itemMap" codec:"itemMap"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// levelRange
	LevelRange tjcsv.Slice `yaml:"levelRange" codec:"levelRange"`
	// limitTimes
	LimitTimes int `yaml:"limitTimes" codec:"limitTimes"`
	// limitType
	LimitType int `yaml:"limitType" codec:"limitType"`
	// regainHour
	RegainHour int `yaml:"regainHour" codec:"regainHour"`
	// showUnable
	ShowUnable bool `yaml:"showUnable" codec:"showUnable"`
	// vipStart
	VipStart int `yaml:"vipStart" codec:"vipStart"`
}
// union_qa
type Union_qa struct {
	// union_qa/qa_base.csv
	Qa_base map[int]*Union_qa_qa_base `yaml:"qa_base" codec:"qa_base"`
	// union_qa/qa_game.csv
	Qa_game map[int]*Union_qa_qa_game `yaml:"qa_game" codec:"qa_game"`
	// union_qa/qa_game1.csv
	Qa_game1 map[int]*Union_qa_qa_game1 `yaml:"qa_game1" codec:"qa_game1"`
	// union_qa/qa_img.csv
	Qa_img map[int]*Union_qa_qa_img `yaml:"qa_img" codec:"qa_img"`
	// union_qa/qa_question.csv
	Qa_question map[int]*Union_qa_qa_question `yaml:"qa_question" codec:"qa_question"`
	// union_qa/qa_type.csv
	Qa_type map[int]*Union_qa_qa_type `yaml:"qa_type" codec:"qa_type"`
}
// union_qa/qa_base.csv
type Union_qa_qa_base struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// multiple
	Multiple int `yaml:"multiple" codec:"multiple"`
	// typeSeqID
	TypeSeqID int `yaml:"typeSeqID" codec:"typeSeqID"`
}
// union_qa/qa_game.csv
type Union_qa_qa_game struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// name
	Name string `yaml:"name" codec:"name"`
	// type
	Type int `yaml:"type" codec:"type"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
}
// union_qa/qa_game1.csv
type Union_qa_qa_game1 struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// choiceNum
	ChoiceNum int `yaml:"choiceNum" codec:"choiceNum"`
	// displayNum
	DisplayNum int `yaml:"displayNum" codec:"displayNum"`
	// disturb
	Disturb int `yaml:"disturb" codec:"disturb"`
	// rate
	Rate int `yaml:"rate" codec:"rate"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
}
// union_qa/qa_img.csv
type Union_qa_qa_img struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// name
	Name string `yaml:"name" codec:"name"`
}
// union_qa/qa_question.csv
type Union_qa_qa_question struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// answer
	Answer int `yaml:"answer" codec:"answer"`
	// choice1
	Choice1 string `yaml:"choice1" codec:"choice1"`
	// choice2
	Choice2 string `yaml:"choice2" codec:"choice2"`
	// choice3
	Choice3 string `yaml:"choice3" codec:"choice3"`
	// choice4
	Choice4 string `yaml:"choice4" codec:"choice4"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// group
	Group int `yaml:"group" codec:"group"`
	// typeSeqID
	TypeSeqID int `yaml:"typeSeqID" codec:"typeSeqID"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
}
// union_qa/qa_type.csv
type Union_qa_qa_type struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// choiceNum
	ChoiceNum int `yaml:"choiceNum" codec:"choiceNum"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// limitTime
	LimitTime int `yaml:"limitTime" codec:"limitTime"`
	// score
	Score int `yaml:"score" codec:"score"`
	// scoreUp
	ScoreUp tjcsv.Slice `yaml:"scoreUp" codec:"scoreUp"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// unit.csv
type Unit struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attributeType
	AttributeType string `yaml:"attributeType" codec:"attributeType"`
	// bansxPosC
	BansxPosC tjcsv.Map `yaml:"bansxPosC" codec:"bansxPosC"`
	// bansxScale
	BansxScale float64 `yaml:"bansxScale" codec:"bansxScale"`
	// battleFlag
	BattleFlag tjcsv.Slice `yaml:"battleFlag" codec:"battleFlag"`
	// blockC
	BlockC int `yaml:"blockC" codec:"blockC"`
	// blockPowerC
	BlockPowerC int `yaml:"blockPowerC" codec:"blockPowerC"`
	// bossLife
	BossLife int `yaml:"bossLife" codec:"bossLife"`
	// breakBlockC
	BreakBlockC int `yaml:"breakBlockC" codec:"breakBlockC"`
	// buffId
	BuffId tjcsv.Slice `yaml:"buffId" codec:"buffId"`
	// buffLevel
	BuffLevel tjcsv.Slice `yaml:"buffLevel" codec:"buffLevel"`
	// buffLifeRound
	BuffLifeRound tjcsv.Slice `yaml:"buffLifeRound" codec:"buffLifeRound"`
	// buffProb
	BuffProb tjcsv.Slice `yaml:"buffProb" codec:"buffProb"`
	// buffValue1
	BuffValue1 tjcsv.Slice `yaml:"buffValue1" codec:"buffValue1"`
	// cardID
	CardID int `yaml:"cardID" codec:"cardID"`
	// cardIcon
	CardIcon string `yaml:"cardIcon" codec:"cardIcon"`
	// cardIcon2
	CardIcon2 string `yaml:"cardIcon2" codec:"cardIcon2"`
	// cardShow
	CardShow string `yaml:"cardShow" codec:"cardShow"`
	// cardShowPosC
	CardShowPosC tjcsv.Map `yaml:"cardShowPosC" codec:"cardShowPosC"`
	// cardShowScale
	CardShowScale float64 `yaml:"cardShowScale" codec:"cardShowScale"`
	// controlPerC
	ControlPerC int `yaml:"controlPerC" codec:"controlPerC"`
	// cureC
	CureC int `yaml:"cureC" codec:"cureC"`
	// damageAddC
	DamageAddC int `yaml:"damageAddC" codec:"damageAddC"`
	// damageBaseC
	DamageBaseC float64 `yaml:"damageBaseC" codec:"damageBaseC"`
	// damageC
	DamageC int `yaml:"damageC" codec:"damageC"`
	// damageDeepenC
	DamageDeepenC int `yaml:"damageDeepenC" codec:"damageDeepenC"`
	// damageDodgeC
	DamageDodgeC int `yaml:"damageDodgeC" codec:"damageDodgeC"`
	// damageGrow
	DamageGrow float64 `yaml:"damageGrow" codec:"damageGrow"`
	// damageHitC
	DamageHitC int `yaml:"damageHitC" codec:"damageHitC"`
	// damageReduceC
	DamageReduceC int `yaml:"damageReduceC" codec:"damageReduceC"`
	// damageSubC
	DamageSubC int `yaml:"damageSubC" codec:"damageSubC"`
	// deathTime
	DeathTime int `yaml:"deathTime" codec:"deathTime"`
	// defenceBaseC
	DefenceBaseC float64 `yaml:"defenceBaseC" codec:"defenceBaseC"`
	// defenceC
	DefenceC int `yaml:"defenceC" codec:"defenceC"`
	// defenceGrow
	DefenceGrow float64 `yaml:"defenceGrow" codec:"defenceGrow"`
	// defenceIgnoreC
	DefenceIgnoreC int `yaml:"defenceIgnoreC" codec:"defenceIgnoreC"`
	// dodgeC
	DodgeC int `yaml:"dodgeC" codec:"dodgeC"`
	// effectPowerId
	EffectPowerId int `yaml:"effectPowerId" codec:"effectPowerId"`
	// everyPos
	EveryPos tjcsv.Map `yaml:"everyPos" codec:"everyPos"`
	// fightingPoint
	FightingPoint int `yaml:"fightingPoint" codec:"fightingPoint"`
	// hitC
	HitC int `yaml:"hitC" codec:"hitC"`
	// hpBaseC
	HpBaseC float64 `yaml:"hpBaseC" codec:"hpBaseC"`
	// hpC
	HpC int `yaml:"hpC" codec:"hpC"`
	// hpGrow
	HpGrow float64 `yaml:"hpGrow" codec:"hpGrow"`
	// hpRecoverC
	HpRecoverC int `yaml:"hpRecoverC" codec:"hpRecoverC"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// iconSimple
	IconSimple string `yaml:"iconSimple" codec:"iconSimple"`
	// immuneControlC
	ImmuneControlC int `yaml:"immuneControlC" codec:"immuneControlC"`
	// initMp1C
	InitMp1C int `yaml:"initMp1C" codec:"initMp1C"`
	// killResumeMp1
	KillResumeMp1 int `yaml:"killResumeMp1" codec:"killResumeMp1"`
	// lifeScale
	LifeScale int `yaml:"lifeScale" codec:"lifeScale"`
	// mp1C
	Mp1C int `yaml:"mp1C" codec:"mp1C"`
	// mp1RecoverC
	Mp1RecoverC int `yaml:"mp1RecoverC" codec:"mp1RecoverC"`
	// mp2RecoverC
	Mp2RecoverC int `yaml:"mp2RecoverC" codec:"mp2RecoverC"`
	// name
	Name string `yaml:"name" codec:"name"`
	// natureRestraintC
	NatureRestraintC int `yaml:"natureRestraintC" codec:"natureRestraintC"`
	// natureType
	NatureType int `yaml:"natureType" codec:"natureType"`
	// natureType2
	NatureType2 int `yaml:"natureType2" codec:"natureType2"`
	// passiveSkillList
	PassiveSkillList tjcsv.Slice `yaml:"passiveSkillList" codec:"passiveSkillList"`
	// rarity
	Rarity int `yaml:"rarity" codec:"rarity"`
	// reboundC
	ReboundC int `yaml:"reboundC" codec:"reboundC"`
	// rectSize
	RectSize tjcsv.Map `yaml:"rectSize" codec:"rectSize"`
	// scale
	Scale float64 `yaml:"scale" codec:"scale"`
	// scaleC
	ScaleC float64 `yaml:"scaleC" codec:"scaleC"`
	// scaleCMode
	ScaleCMode int `yaml:"scaleCMode" codec:"scaleCMode"`
	// scaleSkin
	ScaleSkin int `yaml:"scaleSkin" codec:"scaleSkin"`
	// scaleU
	ScaleU float64 `yaml:"scaleU" codec:"scaleU"`
	// scaleX
	ScaleX int `yaml:"scaleX" codec:"scaleX"`
	// show
	Show string `yaml:"show" codec:"show"`
	// skillList
	SkillList tjcsv.Slice `yaml:"skillList" codec:"skillList"`
	// skin
	Skin string `yaml:"skin" codec:"skin"`
	// specBind
	SpecBind tjcsv.Slice `yaml:"specBind" codec:"specBind"`
	// specialDamageBaseC
	SpecialDamageBaseC float64 `yaml:"specialDamageBaseC" codec:"specialDamageBaseC"`
	// specialDamageC
	SpecialDamageC int `yaml:"specialDamageC" codec:"specialDamageC"`
	// specialDamageGrow
	SpecialDamageGrow float64 `yaml:"specialDamageGrow" codec:"specialDamageGrow"`
	// specialDefenceBaseC
	SpecialDefenceBaseC float64 `yaml:"specialDefenceBaseC" codec:"specialDefenceBaseC"`
	// specialDefenceC
	SpecialDefenceC int `yaml:"specialDefenceC" codec:"specialDefenceC"`
	// specialDefenceGrow
	SpecialDefenceGrow float64 `yaml:"specialDefenceGrow" codec:"specialDefenceGrow"`
	// specialDefenceIgnoreC
	SpecialDefenceIgnoreC int `yaml:"specialDefenceIgnoreC" codec:"specialDefenceIgnoreC"`
	// speedBaseC
	SpeedBaseC float64 `yaml:"speedBaseC" codec:"speedBaseC"`
	// speedC
	SpeedC float64 `yaml:"speedC" codec:"speedC"`
	// speedGrow
	SpeedGrow float64 `yaml:"speedGrow" codec:"speedGrow"`
	// star
	Star int `yaml:"star" codec:"star"`
	// strikeC
	StrikeC int `yaml:"strikeC" codec:"strikeC"`
	// strikeDamageC
	StrikeDamageC int `yaml:"strikeDamageC" codec:"strikeDamageC"`
	// strikeResistanceC
	StrikeResistanceC int `yaml:"strikeResistanceC" codec:"strikeResistanceC"`
	// suckBloodC
	SuckBloodC int `yaml:"suckBloodC" codec:"suckBloodC"`
	// summonCalDamage
	SummonCalDamage bool `yaml:"summonCalDamage" codec:"summonCalDamage"`
	// twinFlag
	TwinFlag bool `yaml:"twinFlag" codec:"twinFlag"`
	// ultimateAddC
	UltimateAddC int `yaml:"ultimateAddC" codec:"ultimateAddC"`
	// ultimateSubC
	UltimateSubC int `yaml:"ultimateSubC" codec:"ultimateSubC"`
	// unitRes
	UnitRes string `yaml:"unitRes" codec:"unitRes"`
}
// unlock.csv
type Unlock struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// feature
	Feature string `yaml:"feature" codec:"feature"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// name
	Name string `yaml:"name" codec:"name"`
	// servers
	Servers tjcsv.Map `yaml:"servers" codec:"servers"`
	// showLevel
	ShowLevel int `yaml:"showLevel" codec:"showLevel"`
	// startGate
	StartGate int `yaml:"startGate" codec:"startGate"`
	// startLevel
	StartLevel int `yaml:"startLevel" codec:"startLevel"`
	// startVip
	StartVip int `yaml:"startVip" codec:"startVip"`
}
// vip.csv
type Vip struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// PWcoldTime
	PWcoldTime int `yaml:"PWcoldTime" codec:"PWcoldTime"`
	// PWpointActive
	PWpointActive int `yaml:"PWpointActive" codec:"PWpointActive"`
	// arenaPassCD
	ArenaPassCD int `yaml:"arenaPassCD" codec:"arenaPassCD"`
	// bossTimeBuyLimit
	BossTimeBuyLimit int `yaml:"bossTimeBuyLimit" codec:"bossTimeBuyLimit"`
	// buyHeroGateTimes
	BuyHeroGateTimes int `yaml:"buyHeroGateTimes" codec:"buyHeroGateTimes"`
	// buyPWTimes
	BuyPWTimes int `yaml:"buyPWTimes" codec:"buyPWTimes"`
	// buySkillPointTimes
	BuySkillPointTimes int `yaml:"buySkillPointTimes" codec:"buySkillPointTimes"`
	// buyStaminaTimes
	BuyStaminaTimes int `yaml:"buyStaminaTimes" codec:"buyStaminaTimes"`
	// buyTimes2048
	BuyTimes2048 int `yaml:"buyTimes2048" codec:"buyTimes2048"`
	// buyTimesEatGreenBlock
	BuyTimesEatGreenBlock int `yaml:"buyTimesEatGreenBlock" codec:"buyTimesEatGreenBlock"`
	// buyTimesGoDown100
	BuyTimesGoDown100 int `yaml:"buyTimesGoDown100" codec:"buyTimesGoDown100"`
	// cardbgBuyNum
	CardbgBuyNum int `yaml:"cardbgBuyNum" codec:"cardbgBuyNum"`
	// chatTimes
	ChatTimes int `yaml:"chatTimes" codec:"chatTimes"`
	// crossArenaBuyPWMaxTimes
	CrossArenaBuyPWMaxTimes int `yaml:"crossArenaBuyPWMaxTimes" codec:"crossArenaBuyPWMaxTimes"`
	// crossArenaFreePWTimes
	CrossArenaFreePWTimes int `yaml:"crossArenaFreePWTimes" codec:"crossArenaFreePWTimes"`
	// crossMineRevengeBuyLimit
	CrossMineRevengeBuyLimit int `yaml:"crossMineRevengeBuyLimit" codec:"crossMineRevengeBuyLimit"`
	// crossMineRobBuyLimit
	CrossMineRobBuyLimit int `yaml:"crossMineRobBuyLimit" codec:"crossMineRobBuyLimit"`
	// dispatchTaskCount
	DispatchTaskCount int `yaml:"dispatchTaskCount" codec:"dispatchTaskCount"`
	// dispatchTaskQualityUpd
	DispatchTaskQualityUpd tjcsv.Map `yaml:"dispatchTaskQualityUpd" codec:"dispatchTaskQualityUpd"`
	// drawItemCountLimit
	DrawItemCountLimit int `yaml:"drawItemCountLimit" codec:"drawItemCountLimit"`
	// drawTotemCountLimit
	DrawTotemCountLimit int `yaml:"drawTotemCountLimit" codec:"drawTotemCountLimit"`
	// endlessTowerResetTimes
	EndlessTowerResetTimes int `yaml:"endlessTowerResetTimes" codec:"endlessTowerResetTimes"`
	// explorerShopRefreshLimit
	ExplorerShopRefreshLimit int `yaml:"explorerShopRefreshLimit" codec:"explorerShopRefreshLimit"`
	// fishingShopRefreshLimit
	FishingShopRefreshLimit int `yaml:"fishingShopRefreshLimit" codec:"fishingShopRefreshLimit"`
	// fragExchangeTimes
	FragExchangeTimes tjcsv.Map `yaml:"fragExchangeTimes" codec:"fragExchangeTimes"`
	// fragShopRefreshLimit
	FragShopRefreshLimit int `yaml:"fragShopRefreshLimit" codec:"fragShopRefreshLimit"`
	// freePWTimes
	FreePWTimes int `yaml:"freePWTimes" codec:"freePWTimes"`
	// freeTimes2048
	FreeTimes2048 int `yaml:"freeTimes2048" codec:"freeTimes2048"`
	// freeTimesEatGreenBlock
	FreeTimesEatGreenBlock int `yaml:"freeTimesEatGreenBlock" codec:"freeTimesEatGreenBlock"`
	// freeTimesGoDown100
	FreeTimesGoDown100 int `yaml:"freeTimesGoDown100" codec:"freeTimesGoDown100"`
	// gift
	Gift tjcsv.Map `yaml:"gift" codec:"gift"`
	// giftLevelLimit
	GiftLevelLimit int `yaml:"giftLevelLimit" codec:"giftLevelLimit"`
	// gold
	Gold interface{} `yaml:"gold" codec:"gold"`
	// goldDrawCardCountLimit
	GoldDrawCardCountLimit int `yaml:"goldDrawCardCountLimit" codec:"goldDrawCardCountLimit"`
	// goldDrawGemCountLimit
	GoldDrawGemCountLimit int `yaml:"goldDrawGemCountLimit" codec:"goldDrawGemCountLimit"`
	// gymBattleBuyTimes
	GymBattleBuyTimes int `yaml:"gymBattleBuyTimes" codec:"gymBattleBuyTimes"`
	// gymTalentPointBuyTimes
	GymTalentPointBuyTimes int `yaml:"gymTalentPointBuyTimes" codec:"gymTalentPointBuyTimes"`
	// hammer2048
	Hammer2048 int `yaml:"hammer2048" codec:"hammer2048"`
	// heldItemExchangeTimes
	HeldItemExchangeTimes tjcsv.Map `yaml:"heldItemExchangeTimes" codec:"heldItemExchangeTimes"`
	// huodongCrossRedPacketRob
	HuodongCrossRedPacketRob int `yaml:"huodongCrossRedPacketRob" codec:"huodongCrossRedPacketRob"`
	// huodongCrossRedPacketSend
	HuodongCrossRedPacketSend int `yaml:"huodongCrossRedPacketSend" codec:"huodongCrossRedPacketSend"`
	// huodongRedPacketRob
	HuodongRedPacketRob int `yaml:"huodongRedPacketRob" codec:"huodongRedPacketRob"`
	// huodongRedPacketSend
	HuodongRedPacketSend int `yaml:"huodongRedPacketSend" codec:"huodongRedPacketSend"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// icon2
	Icon2 string `yaml:"icon2" codec:"icon2"`
	// itemDrawChipCountLimit
	ItemDrawChipCountLimit int `yaml:"itemDrawChipCountLimit" codec:"itemDrawChipCountLimit"`
	// lianJinGift
	LianJinGift tjcsv.Map `yaml:"lianJinGift" codec:"lianJinGift"`
	// lianJinTimes
	LianJinTimes int `yaml:"lianJinTimes" codec:"lianJinTimes"`
	// lianJinUpstart
	LianJinUpstart tjcsv.Map `yaml:"lianJinUpstart" codec:"lianJinUpstart"`
	// megaCommonItemMaxTimes
	MegaCommonItemMaxTimes int `yaml:"megaCommonItemMaxTimes" codec:"megaCommonItemMaxTimes"`
	// megaItemMaxTimes
	MegaItemMaxTimes int `yaml:"megaItemMaxTimes" codec:"megaItemMaxTimes"`
	// monthGift
	MonthGift tjcsv.Map `yaml:"monthGift" codec:"monthGift"`
	// mysteryRefresh
	MysteryRefresh int `yaml:"mysteryRefresh" codec:"mysteryRefresh"`
	// newPrice
	NewPrice int `yaml:"newPrice" codec:"newPrice"`
	// oldPrice
	OldPrice int `yaml:"oldPrice" codec:"oldPrice"`
	// randomTowerPointRate
	RandomTowerPointRate float64 `yaml:"randomTowerPointRate" codec:"randomTowerPointRate"`
	// rmbDrawChipCountLimit
	RmbDrawChipCountLimit int `yaml:"rmbDrawChipCountLimit" codec:"rmbDrawChipCountLimit"`
	// rmbDrawGemCountLimit
	RmbDrawGemCountLimit int `yaml:"rmbDrawGemCountLimit" codec:"rmbDrawGemCountLimit"`
	// roleChatTimes
	RoleChatTimes int `yaml:"roleChatTimes" codec:"roleChatTimes"`
	// saodangCountOpen
	SaodangCountOpen int `yaml:"saodangCountOpen" codec:"saodangCountOpen"`
	// shopRefreshLimit
	ShopRefreshLimit int `yaml:"shopRefreshLimit" codec:"shopRefreshLimit"`
	// skillPointRecoverTime
	SkillPointRecoverTime int `yaml:"skillPointRecoverTime" codec:"skillPointRecoverTime"`
	// upSum
	UpSum int `yaml:"upSum" codec:"upSum"`
}
// vip_desc.csv
type Vip_desc struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// desc1
	Desc1 string `yaml:"desc1" codec:"desc1"`
	// desc10
	Desc10 string `yaml:"desc10" codec:"desc10"`
	// desc11
	Desc11 string `yaml:"desc11" codec:"desc11"`
	// desc2
	Desc2 string `yaml:"desc2" codec:"desc2"`
	// desc3
	Desc3 string `yaml:"desc3" codec:"desc3"`
	// desc4
	Desc4 string `yaml:"desc4" codec:"desc4"`
	// desc5
	Desc5 string `yaml:"desc5" codec:"desc5"`
	// desc6
	Desc6 string `yaml:"desc6" codec:"desc6"`
	// desc7
	Desc7 string `yaml:"desc7" codec:"desc7"`
	// desc8
	Desc8 string `yaml:"desc8" codec:"desc8"`
	// desc9
	Desc9 string `yaml:"desc9" codec:"desc9"`
}
// volleyball_unit.csv
type Volleyball_unit struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrType
	AttrType int `yaml:"attrType" codec:"attrType"`
	// failRate
	FailRate int `yaml:"failRate" codec:"failRate"`
	// gravity
	Gravity int `yaml:"gravity" codec:"gravity"`
	// hitOffsetPos
	HitOffsetPos tjcsv.Map `yaml:"hitOffsetPos" codec:"hitOffsetPos"`
	// hitRadius
	HitRadius int `yaml:"hitRadius" codec:"hitRadius"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// lrSpeedDelta
	LrSpeedDelta float64 `yaml:"lrSpeedDelta" codec:"lrSpeedDelta"`
	// name
	Name string `yaml:"name" codec:"name"`
	// power
	Power int `yaml:"power" codec:"power"`
	// ranWeight
	RanWeight int `yaml:"ranWeight" codec:"ranWeight"`
	// res
	Res string `yaml:"res" codec:"res"`
	// scale
	Scale float64 `yaml:"scale" codec:"scale"`
	// skillType
	SkillType int `yaml:"skillType" codec:"skillType"`
	// udSpeedDelta
	UdSpeedDelta int `yaml:"udSpeedDelta" codec:"udSpeedDelta"`
}
// weather.csv
type Weather struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// buffId
	BuffId tjcsv.Slice `yaml:"buffId" codec:"buffId"`
	// buffValueGroup
	BuffValueGroup tjcsv.Slice `yaml:"buffValueGroup" codec:"buffValueGroup"`
	// describe
	Describe string `yaml:"describe" codec:"describe"`
	// effectRes
	EffectRes string `yaml:"effectRes" codec:"effectRes"`
	// iconRes
	IconRes string `yaml:"iconRes" codec:"iconRes"`
	// lifeRound
	LifeRound int `yaml:"lifeRound" codec:"lifeRound"`
	// name
	Name string `yaml:"name" codec:"name"`
	// overlay
	Overlay int `yaml:"overlay" codec:"overlay"`
	// regEffect
	RegEffect tjcsv.Slice `yaml:"regEffect" codec:"regEffect"`
	// weatherType
	WeatherType int `yaml:"weatherType" codec:"weatherType"`
}
// weather_buff.csv
type Weather_buff struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// buffLifeRound
	BuffLifeRound tjcsv.Slice `yaml:"buffLifeRound" codec:"buffLifeRound"`
	// buffProb
	BuffProb tjcsv.Slice `yaml:"buffProb" codec:"buffProb"`
	// buffValueGroup
	BuffValueGroup tjcsv.Slice `yaml:"buffValueGroup" codec:"buffValueGroup"`
	// processId
	ProcessId int `yaml:"processId" codec:"processId"`
	// weatherId
	WeatherId int `yaml:"weatherId" codec:"weatherId"`
}
// weather_skill.csv
type Weather_skill struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// damageFormula
	DamageFormula int `yaml:"damageFormula" codec:"damageFormula"`
	// hpFormula
	HpFormula int `yaml:"hpFormula" codec:"hpFormula"`
	// skillHit
	SkillHit int `yaml:"skillHit" codec:"skillHit"`
	// skillId
	SkillId int `yaml:"skillId" codec:"skillId"`
	// skillPower
	SkillPower int `yaml:"skillPower" codec:"skillPower"`
	// weatherId
	WeatherId int `yaml:"weatherId" codec:"weatherId"`
}
// world_boss
type World_boss struct {
	// world_boss/base.csv
	Base map[int]*World_boss_base `yaml:"base" codec:"base"`
	// world_boss/damage_award.csv
	Damage_award map[int]*World_boss_damage_award `yaml:"damage_award" codec:"damage_award"`
	// world_boss/hp_fix.csv
	Hp_fix map[int]*World_boss_hp_fix `yaml:"hp_fix" codec:"hp_fix"`
	// world_boss/role_rank_award.csv
	Role_rank_award map[int]*World_boss_role_rank_award `yaml:"role_rank_award" codec:"role_rank_award"`
	// world_boss/union_rank_award.csv
	Union_rank_award map[int]*World_boss_union_rank_award `yaml:"union_rank_award" codec:"union_rank_award"`
}
// world_boss/base.csv
type World_boss_base struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// baseHP
	BaseHP int `yaml:"baseHP" codec:"baseHP"`
	// bg
	Bg interface{} `yaml:"bg" codec:"bg"`
	// bossID
	BossID int `yaml:"bossID" codec:"bossID"`
	// bossPos
	BossPos tjcsv.Map `yaml:"bossPos" codec:"bossPos"`
	// bossScale
	BossScale float64 `yaml:"bossScale" codec:"bossScale"`
	// desc
	Desc interface{} `yaml:"desc" codec:"desc"`
	// gateID
	GateID int `yaml:"gateID" codec:"gateID"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// serverTargetAward
	ServerTargetAward tjcsv.Map `yaml:"serverTargetAward" codec:"serverTargetAward"`
	// serverTargetRes
	ServerTargetRes string `yaml:"serverTargetRes" codec:"serverTargetRes"`
	// skillIcon
	SkillIcon tjcsv.Slice `yaml:"skillIcon" codec:"skillIcon"`
}
// world_boss/damage_award.csv
type World_boss_damage_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// boxRes
	BoxRes string `yaml:"boxRes" codec:"boxRes"`
	// damage
	Damage int `yaml:"damage" codec:"damage"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// level
	Level int `yaml:"level" codec:"level"`
}
// world_boss/hp_fix.csv
type World_boss_hp_fix struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// hpFix
	HpFix float64 `yaml:"hpFix" codec:"hpFix"`
	// level
	Level int `yaml:"level" codec:"level"`
}
// world_boss/role_rank_award.csv
type World_boss_role_rank_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// rank
	Rank int `yaml:"rank" codec:"rank"`
}
// world_boss/union_rank_award.csv
type World_boss_union_rank_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// rank
	Rank int `yaml:"rank" codec:"rank"`
}
// world_level
type World_level struct {
	// world_level/base.csv
	Base map[int]*World_level_base `yaml:"base" codec:"base"`
	// world_level/bonus.csv
	Bonus map[int]*World_level_bonus `yaml:"bonus" codec:"bonus"`
}
// world_level/base.csv
type World_level_base struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// servOpenDays
	ServOpenDays int `yaml:"servOpenDays" codec:"servOpenDays"`
	// topRank
	TopRank int `yaml:"topRank" codec:"topRank"`
}
// world_level/bonus.csv
type World_level_bonus struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// deltaRange
	DeltaRange tjcsv.Slice `yaml:"deltaRange" codec:"deltaRange"`
	// gateBonus
	GateBonus string `yaml:"gateBonus" codec:"gateBonus"`
	// heroGateBonus
	HeroGateBonus string `yaml:"heroGateBonus" codec:"heroGateBonus"`
}
// world_map.csv
type World_map struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// baseMap
	BaseMap string `yaml:"baseMap" codec:"baseMap"`
	// chapterType
	ChapterType int `yaml:"chapterType" codec:"chapterType"`
	// heroMapId
	HeroMapId int `yaml:"heroMapId" codec:"heroMapId"`
	// isWorldEnter
	IsWorldEnter bool `yaml:"isWorldEnter" codec:"isWorldEnter"`
	// name
	Name string `yaml:"name" codec:"name"`
	// nightmareMapId
	NightmareMapId int `yaml:"nightmareMapId" codec:"nightmareMapId"`
	// openLevel
	OpenLevel int `yaml:"openLevel" codec:"openLevel"`
	// ownerId
	OwnerId int `yaml:"ownerId" codec:"ownerId"`
	// res
	Res string `yaml:"res" codec:"res"`
	// seq
	Seq tjcsv.Slice `yaml:"seq" codec:"seq"`
	// starAwardConds
	StarAwardConds tjcsv.Slice `yaml:"starAwardConds" codec:"starAwardConds"`
	// starAwardIDs
	StarAwardIDs tjcsv.Slice `yaml:"starAwardIDs" codec:"starAwardIDs"`
}
// yunying
type Yunying struct {
	// yunying/bao_zongzi_recipe.csv
	Bao_zongzi_recipe map[int]*Yunying_bao_zongzi_recipe `yaml:"bao_zongzi_recipe" codec:"bao_zongzi_recipe"`
	// yunying/bao_zongzi_task.csv
	Bao_zongzi_task map[int]*Yunying_bao_zongzi_task `yaml:"bao_zongzi_task" codec:"bao_zongzi_task"`
	// yunying/card_award.csv
	Card_award map[int]*Yunying_card_award `yaml:"card_award" codec:"card_award"`
	// yunying/collectcard.csv
	Collectcard map[int]*Yunying_collectcard `yaml:"collectcard" codec:"collectcard"`
	// yunying/customize_gift.csv
	Customize_gift map[int]*Yunying_customize_gift `yaml:"customize_gift" codec:"customize_gift"`
	// yunying/dailybuy.csv
	Dailybuy map[int]*Yunying_dailybuy `yaml:"dailybuy" codec:"dailybuy"`
	// yunying/directbuygift.csv
	Directbuygift map[int]*Yunying_directbuygift `yaml:"directbuygift" codec:"directbuygift"`
	// yunying/dispatch.csv
	Dispatch map[int]*Yunying_dispatch `yaml:"dispatch" codec:"dispatch"`
	// yunying/dispatch_task.csv
	Dispatch_task map[int]*Yunying_dispatch_task `yaml:"dispatch_task" codec:"dispatch_task"`
	// yunying/double11_game.csv
	Double11_game map[int]*Yunying_double11_game `yaml:"double11_game" codec:"double11_game"`
	// yunying/double11_lottery.csv
	Double11_lottery map[int]*Yunying_double11_lottery `yaml:"double11_lottery" codec:"double11_lottery"`
	// yunying/draw_limit.csv
	Draw_limit map[int]*Yunying_draw_limit `yaml:"draw_limit" codec:"draw_limit"`
	// yunying/fightpointaward.csv
	Fightpointaward map[int]*Yunying_fightpointaward `yaml:"fightpointaward" codec:"fightpointaward"`
	// yunying/fightrankaward.csv
	Fightrankaward map[int]*Yunying_fightrankaward `yaml:"fightrankaward" codec:"fightrankaward"`
	// yunying/firstcharge.csv
	Firstcharge map[int]*Yunying_firstcharge `yaml:"firstcharge" codec:"firstcharge"`
	// yunying/flop_rounds.csv
	Flop_rounds map[int]*Yunying_flop_rounds `yaml:"flop_rounds" codec:"flop_rounds"`
	// yunying/flop_task.csv
	Flop_task map[int]*Yunying_flop_task `yaml:"flop_task" codec:"flop_task"`
	// yunying/gateaward.csv
	Gateaward map[int]*Yunying_gateaward `yaml:"gateaward" codec:"gateaward"`
	// yunying/gem_exchange.csv
	Gem_exchange map[int]*Yunying_gem_exchange `yaml:"gem_exchange" codec:"gem_exchange"`
	// yunying/generaltask.csv
	Generaltask map[int]*Yunying_generaltask `yaml:"generaltask" codec:"generaltask"`
	// yunying/grid_walk_events.csv
	Grid_walk_events map[int]*Yunying_grid_walk_events `yaml:"grid_walk_events" codec:"grid_walk_events"`
	// yunying/grid_walk_map.csv
	Grid_walk_map map[int]*Yunying_grid_walk_map `yaml:"grid_walk_map" codec:"grid_walk_map"`
	// yunying/grid_walk_shop.csv
	Grid_walk_shop map[int]*Yunying_grid_walk_shop `yaml:"grid_walk_shop" codec:"grid_walk_shop"`
	// yunying/grid_walk_tasks.csv
	Grid_walk_tasks map[int]*Yunying_grid_walk_tasks `yaml:"grid_walk_tasks" codec:"grid_walk_tasks"`
	// yunying/guidegift.csv
	Guidegift map[int]*Yunying_guidegift `yaml:"guidegift" codec:"guidegift"`
	// yunying/halloween_sprites.csv
	Halloween_sprites map[int]*Yunying_halloween_sprites `yaml:"halloween_sprites" codec:"halloween_sprites"`
	// yunying/horse_race_bet_award.csv
	Horse_race_bet_award map[int]*Yunying_horse_race_bet_award `yaml:"horse_race_bet_award" codec:"horse_race_bet_award"`
	// yunying/horse_race_point_award.csv
	Horse_race_point_award map[int]*Yunying_horse_race_point_award `yaml:"horse_race_point_award" codec:"horse_race_point_award"`
	// yunying/huodongboss.csv
	Huodongboss map[int]*Yunying_huodongboss `yaml:"huodongboss" codec:"huodongboss"`
	// yunying/huodongboss_config.csv
	Huodongboss_config map[int]*Yunying_huodongboss_config `yaml:"huodongboss_config" codec:"huodongboss_config"`
	// yunying/huodongcloth_level.csv
	Huodongcloth_level map[int]*Yunying_huodongcloth_level `yaml:"huodongcloth_level" codec:"huodongcloth_level"`
	// yunying/huodongcloth_part.csv
	Huodongcloth_part map[int]*Yunying_huodongcloth_part `yaml:"huodongcloth_part" codec:"huodongcloth_part"`
	// yunying/itembuy.csv
	Itembuy map[int]*Yunying_itembuy `yaml:"itembuy" codec:"itembuy"`
	// yunying/itembuy2.csv
	Itembuy2 map[int]*Yunying_itembuy2 `yaml:"itembuy2" codec:"itembuy2"`
	// yunying/itemexchange.csv
	Itemexchange map[int]*Yunying_itemexchange `yaml:"itemexchange" codec:"itemexchange"`
	// yunying/jifu_award.csv
	Jifu_award map[int]*Yunying_jifu_award `yaml:"jifu_award" codec:"jifu_award"`
	// yunying/jifu_task.csv
	Jifu_task map[int]*Yunying_jifu_task `yaml:"jifu_task" codec:"jifu_task"`
	// yunying/levelaward.csv
	Levelaward map[int]*Yunying_levelaward `yaml:"levelaward" codec:"levelaward"`
	// yunying/levelfund.csv
	Levelfund map[int]*Yunying_levelfund `yaml:"levelfund" codec:"levelfund"`
	// yunying/limitboxpointaward.csv
	Limitboxpointaward map[int]*Yunying_limitboxpointaward `yaml:"limitboxpointaward" codec:"limitboxpointaward"`
	// yunying/limitboxqualify.csv
	Limitboxqualify map[int]*Yunying_limitboxqualify `yaml:"limitboxqualify" codec:"limitboxqualify"`
	// yunying/limitboxrankaward.csv
	Limitboxrankaward map[int]*Yunying_limitboxrankaward `yaml:"limitboxrankaward" codec:"limitboxrankaward"`
	// yunying/limitbuygift.csv
	Limitbuygift map[int]*Yunying_limitbuygift `yaml:"limitbuygift" codec:"limitbuygift"`
	// yunying/loginweal.csv
	Loginweal map[int]*Yunying_loginweal `yaml:"loginweal" codec:"loginweal"`
	// yunying/luckycat.csv
	Luckycat map[int]*Yunying_luckycat `yaml:"luckycat" codec:"luckycat"`
	// yunying/luxurydirectbuygift.csv
	Luxurydirectbuygift map[int]*Yunying_luxurydirectbuygift `yaml:"luxurydirectbuygift" codec:"luxurydirectbuygift"`
	// yunying/mid_autumn_draw.csv
	Mid_autumn_draw map[int]*Yunying_mid_autumn_draw `yaml:"mid_autumn_draw" codec:"mid_autumn_draw"`
	// yunying/mid_autumn_draw_tasks.csv
	Mid_autumn_draw_tasks map[int]*Yunying_mid_autumn_draw_tasks `yaml:"mid_autumn_draw_tasks" codec:"mid_autumn_draw_tasks"`
	// yunying/newfirstrecharge.csv
	Newfirstrecharge map[int]*Yunying_newfirstrecharge `yaml:"newfirstrecharge" codec:"newfirstrecharge"`
	// yunying/oncerechage.csv
	Oncerechage map[int]*Yunying_oncerechage `yaml:"oncerechage" codec:"oncerechage"`
	// yunying/passport_award.csv
	Passport_award map[int]*Yunying_passport_award `yaml:"passport_award" codec:"passport_award"`
	// yunying/passport_recharge.csv
	Passport_recharge map[int]*Yunying_passport_recharge `yaml:"passport_recharge" codec:"passport_recharge"`
	// yunying/passport_shop.csv
	Passport_shop map[int]*Yunying_passport_shop `yaml:"passport_shop" codec:"passport_shop"`
	// yunying/passport_task.csv
	Passport_task map[int]*Yunying_passport_task `yaml:"passport_task" codec:"passport_task"`
	// yunying/placard.csv
	Placard map[int]*Yunying_placard `yaml:"placard" codec:"placard"`
	// yunying/playpassport_award.csv
	Playpassport_award map[int]*Yunying_playpassport_award `yaml:"playpassport_award" codec:"playpassport_award"`
	// yunying/playpassport_recharge.csv
	Playpassport_recharge map[int]*Yunying_playpassport_recharge `yaml:"playpassport_recharge" codec:"playpassport_recharge"`
	// yunying/qualityexchange.csv
	Qualityexchange map[int]*Yunying_qualityexchange `yaml:"qualityexchange" codec:"qualityexchange"`
	// yunying/rechargegift.csv
	Rechargegift map[int]*Yunying_rechargegift `yaml:"rechargegift" codec:"rechargegift"`
	// yunying/rechargegift_huodongid.csv
	Rechargegift_huodongid map[int]*Yunying_rechargegift_huodongid `yaml:"rechargegift_huodongid" codec:"rechargegift_huodongid"`
	// yunying/retrieve.csv
	Retrieve map[int]*Yunying_retrieve `yaml:"retrieve" codec:"retrieve"`
	// yunying/reunion_catchup.csv
	Reunion_catchup map[int]*Yunying_reunion_catchup `yaml:"reunion_catchup" codec:"reunion_catchup"`
	// yunying/reunion_gift.csv
	Reunion_gift map[int]*Yunying_reunion_gift `yaml:"reunion_gift" codec:"reunion_gift"`
	// yunying/reunion_point_box.csv
	Reunion_point_box map[int]*Yunying_reunion_point_box `yaml:"reunion_point_box" codec:"reunion_point_box"`
	// yunying/reunion_recharge.csv
	Reunion_recharge map[int]*Yunying_reunion_recharge `yaml:"reunion_recharge" codec:"reunion_recharge"`
	// yunying/reunion_task.csv
	Reunion_task map[int]*Yunying_reunion_task `yaml:"reunion_task" codec:"reunion_task"`
	// yunying/rmbcost.csv
	Rmbcost map[int]*Yunying_rmbcost `yaml:"rmbcost" codec:"rmbcost"`
	// yunying/rmbgoldreturn_award.csv
	Rmbgoldreturn_award map[int]*Yunying_rmbgoldreturn_award `yaml:"rmbgoldreturn_award" codec:"rmbgoldreturn_award"`
	// yunying/rmbgoldreturn_rate.csv
	Rmbgoldreturn_rate map[int]*Yunying_rmbgoldreturn_rate `yaml:"rmbgoldreturn_rate" codec:"rmbgoldreturn_rate"`
	// yunying/serveropen.csv
	Serveropen map[int]*Yunying_serveropen `yaml:"serveropen" codec:"serveropen"`
	// yunying/shaved_ice_base.csv
	Shaved_ice_base map[int]*Yunying_shaved_ice_base `yaml:"shaved_ice_base" codec:"shaved_ice_base"`
	// yunying/shaved_ice_cards.csv
	Shaved_ice_cards map[int]*Yunying_shaved_ice_cards `yaml:"shaved_ice_cards" codec:"shaved_ice_cards"`
	// yunying/shaved_ice_demand.csv
	Shaved_ice_demand map[int]*Yunying_shaved_ice_demand `yaml:"shaved_ice_demand" codec:"shaved_ice_demand"`
	// yunying/shaved_ice_items.csv
	Shaved_ice_items map[int]*Yunying_shaved_ice_items `yaml:"shaved_ice_items" codec:"shaved_ice_items"`
	// yunying/shaved_ice_stage_award.csv
	Shaved_ice_stage_award map[int]*Yunying_shaved_ice_stage_award `yaml:"shaved_ice_stage_award" codec:"shaved_ice_stage_award"`
	// yunying/skyscraper_accessment.csv
	Skyscraper_accessment map[int]*Yunying_skyscraper_accessment `yaml:"skyscraper_accessment" codec:"skyscraper_accessment"`
	// yunying/skyscraper_floors.csv
	Skyscraper_floors map[int]*Yunying_skyscraper_floors `yaml:"skyscraper_floors" codec:"skyscraper_floors"`
	// yunying/skyscraper_medals.csv
	Skyscraper_medals map[int]*Yunying_skyscraper_medals `yaml:"skyscraper_medals" codec:"skyscraper_medals"`
	// yunying/skyscraper_resources.csv
	Skyscraper_resources map[int]*Yunying_skyscraper_resources `yaml:"skyscraper_resources" codec:"skyscraper_resources"`
	// yunying/skyscraper_tasks.csv
	Skyscraper_tasks map[int]*Yunying_skyscraper_tasks `yaml:"skyscraper_tasks" codec:"skyscraper_tasks"`
	// yunying/snowball_award.csv
	Snowball_award map[int]*Yunying_snowball_award `yaml:"snowball_award" codec:"snowball_award"`
	// yunying/snowball_element.csv
	Snowball_element map[int]*Yunying_snowball_element `yaml:"snowball_element" codec:"snowball_element"`
	// yunying/snowball_stage.csv
	Snowball_stage map[int]*Yunying_snowball_stage `yaml:"snowball_stage" codec:"snowball_stage"`
	// yunying/stargift.csv
	Stargift map[int]*Yunying_stargift `yaml:"stargift" codec:"stargift"`
	// yunying/totalpaygift.csv
	Totalpaygift map[int]*Yunying_totalpaygift `yaml:"totalpaygift" codec:"totalpaygift"`
	// yunying/upstargift.csv
	Upstargift map[int]*Yunying_upstargift `yaml:"upstargift" codec:"upstargift"`
	// yunying/vipaward.csv
	Vipaward map[int]*Yunying_vipaward `yaml:"vipaward" codec:"vipaward"`
	// yunying/vipbuy.csv
	Vipbuy map[int]*Yunying_vipbuy `yaml:"vipbuy" codec:"vipbuy"`
	// yunying/volleyball_tasks.csv
	Volleyball_tasks map[int]*Yunying_volleyball_tasks `yaml:"volleyball_tasks" codec:"volleyball_tasks"`
	// yunying/weeklycard.csv
	Weeklycard map[int]*Yunying_weeklycard `yaml:"weeklycard" codec:"weeklycard"`
	// yunying/yyhuodong.csv
	Yyhuodong map[int]*Yunying_yyhuodong `yaml:"yyhuodong" codec:"yyhuodong"`
}
// yunying/bao_zongzi_recipe.csv
type Yunying_bao_zongzi_recipe struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// compoundItem
	CompoundItem tjcsv.Map `yaml:"compoundItem" codec:"compoundItem"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// mainItem
	MainItem tjcsv.Map `yaml:"mainItem" codec:"mainItem"`
	// minorItem
	MinorItem tjcsv.Map `yaml:"minorItem" codec:"minorItem"`
}
// yunying/bao_zongzi_task.csv
type Yunying_bao_zongzi_task struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// taskParam
	TaskParam int `yaml:"taskParam" codec:"taskParam"`
}
// yunying/card_award.csv
type Yunying_card_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// cardid
	Cardid int `yaml:"cardid" codec:"cardid"`
	// freeaward
	Freeaward tjcsv.Map `yaml:"freeaward" codec:"freeaward"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// item
	Item tjcsv.Map `yaml:"item" codec:"item"`
	// limit
	Limit int `yaml:"limit" codec:"limit"`
	// name
	Name string `yaml:"name" codec:"name"`
	// rechargeID
	RechargeID int `yaml:"rechargeID" codec:"rechargeID"`
	// remark
	Remark string `yaml:"remark" codec:"remark"`
	// star
	Star int `yaml:"star" codec:"star"`
}
// yunying/collectcard.csv
type Yunying_collectcard struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// goto
	Goto interface{} `yaml:"goto" codec:"goto"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// taskParam
	TaskParam int `yaml:"taskParam" codec:"taskParam"`
	// taskSpecialParam
	TaskSpecialParam tjcsv.Map `yaml:"taskSpecialParam" codec:"taskSpecialParam"`
	// taskType
	TaskType int `yaml:"taskType" codec:"taskType"`
}
// yunying/customize_gift.csv
type Yunying_customize_gift struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// awards
	Awards tjcsv.Map `yaml:"awards" codec:"awards"`
	// buyTimes
	BuyTimes int `yaml:"buyTimes" codec:"buyTimes"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// icon
	Icon interface{} `yaml:"icon" codec:"icon"`
	// name
	Name string `yaml:"name" codec:"name"`
	// optionalAwards1
	OptionalAwards1 tjcsv.Slice `yaml:"optionalAwards1" codec:"optionalAwards1"`
	// optionalAwards2
	OptionalAwards2 tjcsv.Slice `yaml:"optionalAwards2" codec:"optionalAwards2"`
	// optionalAwards3
	OptionalAwards3 tjcsv.Slice `yaml:"optionalAwards3" codec:"optionalAwards3"`
	// optionalAwards4
	OptionalAwards4 tjcsv.Slice `yaml:"optionalAwards4" codec:"optionalAwards4"`
	// rechargeID
	RechargeID int `yaml:"rechargeID" codec:"rechargeID"`
}
// yunying/dailybuy.csv
type Yunying_dailybuy struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// buyMax
	BuyMax int `yaml:"buyMax" codec:"buyMax"`
	// dayIdx
	DayIdx int `yaml:"dayIdx" codec:"dayIdx"`
	// discount
	Discount int `yaml:"discount" codec:"discount"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// item
	Item tjcsv.Map `yaml:"item" codec:"item"`
	// rmbCost
	RmbCost int `yaml:"rmbCost" codec:"rmbCost"`
	// rmbShow
	RmbShow int `yaml:"rmbShow" codec:"rmbShow"`
	// vipLeast
	VipLeast int `yaml:"vipLeast" codec:"vipLeast"`
}
// yunying/directbuygift.csv
type Yunying_directbuygift struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// hot
	Hot interface{} `yaml:"hot" codec:"hot"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// item
	Item tjcsv.Map `yaml:"item" codec:"item"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// levelLimit
	LevelLimit int `yaml:"levelLimit" codec:"levelLimit"`
	// limit
	Limit int `yaml:"limit" codec:"limit"`
	// name
	Name string `yaml:"name" codec:"name"`
	// oldPrice
	OldPrice int `yaml:"oldPrice" codec:"oldPrice"`
	// rechargeID
	RechargeID int `yaml:"rechargeID" codec:"rechargeID"`
	// refresh
	Refresh bool `yaml:"refresh" codec:"refresh"`
	// rmbCost
	RmbCost int `yaml:"rmbCost" codec:"rmbCost"`
	// sort
	Sort int `yaml:"sort" codec:"sort"`
	// status
	Status int `yaml:"status" codec:"status"`
}
// yunying/dispatch.csv
type Yunying_dispatch struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// cd
	Cd int `yaml:"cd" codec:"cd"`
	// cost
	Cost tjcsv.Map `yaml:"cost" codec:"cost"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// duration
	Duration int `yaml:"duration" codec:"duration"`
	// extraAward
	ExtraAward tjcsv.Map `yaml:"extraAward" codec:"extraAward"`
	// extraTime
	ExtraTime int `yaml:"extraTime" codec:"extraTime"`
	// frameType
	FrameType string `yaml:"frameType" codec:"frameType"`
	// frontWay
	FrontWay tjcsv.Slice `yaml:"frontWay" codec:"frontWay"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// iconSpecial
	IconSpecial string `yaml:"iconSpecial" codec:"iconSpecial"`
	// name
	Name string `yaml:"name" codec:"name"`
	// numText
	NumText string `yaml:"numText" codec:"numText"`
	// params1
	Params1 tjcsv.Slice `yaml:"params1" codec:"params1"`
	// params2
	Params2 tjcsv.Slice `yaml:"params2" codec:"params2"`
	// params3
	Params3 tjcsv.Slice `yaml:"params3" codec:"params3"`
	// position
	Position tjcsv.Map `yaml:"position" codec:"position"`
	// preID
	PreID int `yaml:"preID" codec:"preID"`
	// spParams
	SpParams tjcsv.Slice `yaml:"spParams" codec:"spParams"`
	// spTarget
	SpTarget int `yaml:"spTarget" codec:"spTarget"`
	// target1
	Target1 int `yaml:"target1" codec:"target1"`
	// target2
	Target2 int `yaml:"target2" codec:"target2"`
	// target3
	Target3 int `yaml:"target3" codec:"target3"`
	// times
	Times int `yaml:"times" codec:"times"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// yunying/dispatch_task.csv
type Yunying_dispatch_task struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// goTo
	GoTo string `yaml:"goTo" codec:"goTo"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// taskParam
	TaskParam int `yaml:"taskParam" codec:"taskParam"`
	// taskSpecialParam
	TaskSpecialParam tjcsv.Map `yaml:"taskSpecialParam" codec:"taskSpecialParam"`
	// taskType
	TaskType int `yaml:"taskType" codec:"taskType"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// yunying/double11_game.csv
type Yunying_double11_game struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// game
	Game int `yaml:"game" codec:"game"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// itemID
	ItemID int `yaml:"itemID" codec:"itemID"`
}
// yunying/double11_lottery.csv
type Yunying_double11_lottery struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// name
	Name string `yaml:"name" codec:"name"`
	// prize
	Prize int `yaml:"prize" codec:"prize"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
}
// yunying/draw_limit.csv
type Yunying_draw_limit struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// card1
	Card1 int `yaml:"card1" codec:"card1"`
	// card2
	Card2 int `yaml:"card2" codec:"card2"`
	// posRes1
	PosRes1 string `yaml:"posRes1" codec:"posRes1"`
	// posRes2
	PosRes2 string `yaml:"posRes2" codec:"posRes2"`
	// res1
	Res1 string `yaml:"res1" codec:"res1"`
	// res2
	Res2 string `yaml:"res2" codec:"res2"`
	// resPos1
	ResPos1 tjcsv.Map `yaml:"resPos1" codec:"resPos1"`
	// resPos2
	ResPos2 tjcsv.Map `yaml:"resPos2" codec:"resPos2"`
	// resScale1
	ResScale1 float64 `yaml:"resScale1" codec:"resScale1"`
	// resScale2
	ResScale2 float64 `yaml:"resScale2" codec:"resScale2"`
	// titleRes1
	TitleRes1 string `yaml:"titleRes1" codec:"titleRes1"`
	// titleRes2
	TitleRes2 string `yaml:"titleRes2" codec:"titleRes2"`
}
// yunying/fightpointaward.csv
type Yunying_fightpointaward struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// fightPointRequire
	FightPointRequire int `yaml:"fightPointRequire" codec:"fightPointRequire"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
}
// yunying/fightrankaward.csv
type Yunying_fightrankaward struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// fightPointLeast
	FightPointLeast int `yaml:"fightPointLeast" codec:"fightPointLeast"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// rank
	Rank int `yaml:"rank" codec:"rank"`
}
// yunying/firstcharge.csv
type Yunying_firstcharge struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// day
	Day int `yaml:"day" codec:"day"`
	// desc
	Desc interface{} `yaml:"desc" codec:"desc"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// page
	Page int `yaml:"page" codec:"page"`
	// pay
	Pay int `yaml:"pay" codec:"pay"`
	// rechargeID
	RechargeID int `yaml:"rechargeID" codec:"rechargeID"`
	// resBg
	ResBg string `yaml:"resBg" codec:"resBg"`
}
// yunying/flop_rounds.csv
type Yunying_flop_rounds struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// rounds
	Rounds tjcsv.Slice `yaml:"rounds" codec:"rounds"`
	// type
	Type int `yaml:"type" codec:"type"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
}
// yunying/flop_task.csv
type Yunying_flop_task struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award int `yaml:"award" codec:"award"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// jumpTo
	JumpTo string `yaml:"jumpTo" codec:"jumpTo"`
	// taskParam
	TaskParam int `yaml:"taskParam" codec:"taskParam"`
	// taskSpecialParam
	TaskSpecialParam tjcsv.Map `yaml:"taskSpecialParam" codec:"taskSpecialParam"`
	// taskType
	TaskType int `yaml:"taskType" codec:"taskType"`
	// times
	Times int `yaml:"times" codec:"times"`
}
// yunying/gateaward.csv
type Yunying_gateaward struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// gateID
	GateID int `yaml:"gateID" codec:"gateID"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
}
// yunying/gem_exchange.csv
type Yunying_gem_exchange struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// compensate
	Compensate tjcsv.Map `yaml:"compensate" codec:"compensate"`
	// cost
	Cost int `yaml:"cost" codec:"cost"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// quality
	Quality int `yaml:"quality" codec:"quality"`
}
// yunying/generaltask.csv
type Yunying_generaltask struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// taskParam
	TaskParam int `yaml:"taskParam" codec:"taskParam"`
	// taskSpecialParam
	TaskSpecialParam tjcsv.Map `yaml:"taskSpecialParam" codec:"taskSpecialParam"`
	// taskType
	TaskType int `yaml:"taskType" codec:"taskType"`
	// vip
	Vip int `yaml:"vip" codec:"vip"`
}
// yunying/grid_walk_events.csv
type Yunying_grid_walk_events struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// name
	Name string `yaml:"name" codec:"name"`
	// params
	Params tjcsv.Map `yaml:"params" codec:"params"`
	// resources
	Resources tjcsv.Slice `yaml:"resources" codec:"resources"`
	// trigger
	Trigger int `yaml:"trigger" codec:"trigger"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// yunying/grid_walk_map.csv
type Yunying_grid_walk_map struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// event
	Event int `yaml:"event" codec:"event"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// index
	Index int `yaml:"index" codec:"index"`
}
// yunying/grid_walk_shop.csv
type Yunying_grid_walk_shop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// items
	Items tjcsv.Map `yaml:"items" codec:"items"`
	// prices
	Prices tjcsv.Map `yaml:"prices" codec:"prices"`
	// type
	Type int `yaml:"type" codec:"type"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
}
// yunying/grid_walk_tasks.csv
type Yunying_grid_walk_tasks struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// goTo
	GoTo string `yaml:"goTo" codec:"goTo"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// taskParam
	TaskParam int `yaml:"taskParam" codec:"taskParam"`
	// taskSpecialParam
	TaskSpecialParam tjcsv.Map `yaml:"taskSpecialParam" codec:"taskSpecialParam"`
	// taskType
	TaskType int `yaml:"taskType" codec:"taskType"`
}
// yunying/guidegift.csv
type Yunying_guidegift struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// duration
	Duration int `yaml:"duration" codec:"duration"`
	// item
	Item tjcsv.Map `yaml:"item" codec:"item"`
	// itemID
	ItemID int `yaml:"itemID" codec:"itemID"`
	// name
	Name string `yaml:"name" codec:"name"`
	// rechargeID
	RechargeID int `yaml:"rechargeID" codec:"rechargeID"`
	// sort
	Sort int `yaml:"sort" codec:"sort"`
}
// yunying/halloween_sprites.csv
type Yunying_halloween_sprites struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// buildNum
	BuildNum int `yaml:"buildNum" codec:"buildNum"`
	// finalPos
	FinalPos tjcsv.Slice `yaml:"finalPos" codec:"finalPos"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// needClick
	NeedClick tjcsv.Slice `yaml:"needClick" codec:"needClick"`
	// normPos
	NormPos tjcsv.Slice `yaml:"normPos" codec:"normPos"`
	// pos
	Pos tjcsv.Slice `yaml:"pos" codec:"pos"`
	// posClick
	PosClick tjcsv.Slice `yaml:"posClick" codec:"posClick"`
	// randDistance
	RandDistance tjcsv.Slice `yaml:"randDistance" codec:"randDistance"`
	// range
	Range tjcsv.Slice `yaml:"range" codec:"range"`
	// res
	Res string `yaml:"res" codec:"res"`
	// scale
	Scale float64 `yaml:"scale" codec:"scale"`
	// spcialAct
	SpcialAct int `yaml:"spcialAct" codec:"spcialAct"`
	// type
	Type int `yaml:"type" codec:"type"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
}
// yunying/horse_race_bet_award.csv
type Yunying_horse_race_bet_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// point
	Point int `yaml:"point" codec:"point"`
	// rank
	Rank int `yaml:"rank" codec:"rank"`
}
// yunying/horse_race_point_award.csv
type Yunying_horse_race_point_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// point
	Point int `yaml:"point" codec:"point"`
}
// yunying/huodongboss.csv
type Yunying_huodongboss struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// gateLibID
	GateLibID int `yaml:"gateLibID" codec:"gateLibID"`
	// hardDegree
	HardDegree int `yaml:"hardDegree" codec:"hardDegree"`
	// posX
	PosX int `yaml:"posX" codec:"posX"`
	// posY
	PosY int `yaml:"posY" codec:"posY"`
	// scale
	Scale int `yaml:"scale" codec:"scale"`
	// timeLimit
	TimeLimit int `yaml:"timeLimit" codec:"timeLimit"`
	// times
	Times int `yaml:"times" codec:"times"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
}
// yunying/huodongboss_config.csv
type Yunying_huodongboss_config struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// cd
	Cd int `yaml:"cd" codec:"cd"`
	// dailyChallengeLimit
	DailyChallengeLimit int `yaml:"dailyChallengeLimit" codec:"dailyChallengeLimit"`
	// dailyCountLimit
	DailyCountLimit int `yaml:"dailyCountLimit" codec:"dailyCountLimit"`
	// gateLibID
	GateLibID int `yaml:"gateLibID" codec:"gateLibID"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// res
	Res interface{} `yaml:"res" codec:"res"`
	// staminaWeightMax
	StaminaWeightMax float64 `yaml:"staminaWeightMax" codec:"staminaWeightMax"`
	// staminaWeightMin
	StaminaWeightMin float64 `yaml:"staminaWeightMin" codec:"staminaWeightMin"`
}
// yunying/huodongcloth_level.csv
type Yunying_huodongcloth_level struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// level
	Level int `yaml:"level" codec:"level"`
	// needExp
	NeedExp int `yaml:"needExp" codec:"needExp"`
	// unlockPart
	UnlockPart int `yaml:"unlockPart" codec:"unlockPart"`
}
// yunying/huodongcloth_part.csv
type Yunying_huodongcloth_part struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// belongPart
	BelongPart int `yaml:"belongPart" codec:"belongPart"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// isDefault
	IsDefault bool `yaml:"isDefault" codec:"isDefault"`
	// lookPos
	LookPos tjcsv.Map `yaml:"lookPos" codec:"lookPos"`
	// res
	Res string `yaml:"res" codec:"res"`
	// showType
	ShowType string `yaml:"showType" codec:"showType"`
	// zOrder
	ZOrder int `yaml:"zOrder" codec:"zOrder"`
}
// yunying/itembuy.csv
type Yunying_itembuy struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// buyMax
	BuyMax int `yaml:"buyMax" codec:"buyMax"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// item
	Item tjcsv.Map `yaml:"item" codec:"item"`
	// logo
	Logo int `yaml:"logo" codec:"logo"`
	// refresh
	Refresh bool `yaml:"refresh" codec:"refresh"`
	// rmbCost
	RmbCost int `yaml:"rmbCost" codec:"rmbCost"`
	// rmbShow
	RmbShow int `yaml:"rmbShow" codec:"rmbShow"`
}
// yunying/itembuy2.csv
type Yunying_itembuy2 struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// buyMax
	BuyMax int `yaml:"buyMax" codec:"buyMax"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// item
	Item tjcsv.Map `yaml:"item" codec:"item"`
	// refresh
	Refresh bool `yaml:"refresh" codec:"refresh"`
	// tab
	Tab int `yaml:"tab" codec:"tab"`
	// tabText
	TabText interface{} `yaml:"tabText" codec:"tabText"`
}
// yunying/itemexchange.csv
type Yunying_itemexchange struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// exchangeTimes
	ExchangeTimes int `yaml:"exchangeTimes" codec:"exchangeTimes"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// items
	Items tjcsv.Map `yaml:"items" codec:"items"`
	// limit
	Limit tjcsv.Map `yaml:"limit" codec:"limit"`
}
// yunying/jifu_award.csv
type Yunying_jifu_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// awardID
	AwardID int `yaml:"awardID" codec:"awardID"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
}
// yunying/jifu_task.csv
type Yunying_jifu_task struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// boardID
	BoardID int `yaml:"boardID" codec:"boardID"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// goTo
	GoTo string `yaml:"goTo" codec:"goTo"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// taskParam
	TaskParam int `yaml:"taskParam" codec:"taskParam"`
	// taskSpecialParam
	TaskSpecialParam tjcsv.Map `yaml:"taskSpecialParam" codec:"taskSpecialParam"`
	// taskType
	TaskType int `yaml:"taskType" codec:"taskType"`
}
// yunying/levelaward.csv
type Yunying_levelaward struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// needLevel
	NeedLevel int `yaml:"needLevel" codec:"needLevel"`
}
// yunying/levelfund.csv
type Yunying_levelfund struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// needLevel
	NeedLevel int `yaml:"needLevel" codec:"needLevel"`
}
// yunying/limitboxpointaward.csv
type Yunying_limitboxpointaward struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// boxIcon
	BoxIcon int `yaml:"boxIcon" codec:"boxIcon"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// pointRequire
	PointRequire int `yaml:"pointRequire" codec:"pointRequire"`
}
// yunying/limitboxqualify.csv
type Yunying_limitboxqualify struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// fightPointLimit
	FightPointLimit int `yaml:"fightPointLimit" codec:"fightPointLimit"`
	// serverOpenDays
	ServerOpenDays int `yaml:"serverOpenDays" codec:"serverOpenDays"`
	// vipLimit
	VipLimit int `yaml:"vipLimit" codec:"vipLimit"`
}
// yunying/limitboxrankaward.csv
type Yunying_limitboxrankaward struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// pointLeast
	PointLeast int `yaml:"pointLeast" codec:"pointLeast"`
	// rank
	Rank int `yaml:"rank" codec:"rank"`
}
// yunying/limitbuygift.csv
type Yunying_limitbuygift struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// bgPath
	BgPath string `yaml:"bgPath" codec:"bgPath"`
	// countPath
	CountPath string `yaml:"countPath" codec:"countPath"`
	// duration
	Duration int `yaml:"duration" codec:"duration"`
	// group
	Group int `yaml:"group" codec:"group"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// item
	Item tjcsv.Map `yaml:"item" codec:"item"`
	// name
	Name string `yaml:"name" codec:"name"`
	// rechargeID
	RechargeID int `yaml:"rechargeID" codec:"rechargeID"`
	// rmbCost
	RmbCost int `yaml:"rmbCost" codec:"rmbCost"`
	// sort
	Sort int `yaml:"sort" codec:"sort"`
	// sumRechargeRMB
	SumRechargeRMB tjcsv.Slice `yaml:"sumRechargeRMB" codec:"sumRechargeRMB"`
	// targetType1
	TargetType1 int `yaml:"targetType1" codec:"targetType1"`
	// targetType2
	TargetType2 int `yaml:"targetType2" codec:"targetType2"`
}
// yunying/loginweal.csv
type Yunying_loginweal struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// daySum
	DaySum int `yaml:"daySum" codec:"daySum"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
}
// yunying/luckycat.csv
type Yunying_luckycat struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// drawID
	DrawID int `yaml:"drawID" codec:"drawID"`
	// goldCost
	GoldCost int `yaml:"goldCost" codec:"goldCost"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// range1
	Range1 tjcsv.Slice `yaml:"range1" codec:"range1"`
	// range2
	Range2 tjcsv.Slice `yaml:"range2" codec:"range2"`
	// range3
	Range3 tjcsv.Slice `yaml:"range3" codec:"range3"`
	// range4
	Range4 tjcsv.Slice `yaml:"range4" codec:"range4"`
	// range5
	Range5 tjcsv.Slice `yaml:"range5" codec:"range5"`
	// rmbCost
	RmbCost int `yaml:"rmbCost" codec:"rmbCost"`
	// rmbRndMax
	RmbRndMax int `yaml:"rmbRndMax" codec:"rmbRndMax"`
	// vip
	Vip int `yaml:"vip" codec:"vip"`
	// vipIcon
	VipIcon interface{} `yaml:"vipIcon" codec:"vipIcon"`
	// weight1
	Weight1 int `yaml:"weight1" codec:"weight1"`
	// weight2
	Weight2 int `yaml:"weight2" codec:"weight2"`
	// weight3
	Weight3 int `yaml:"weight3" codec:"weight3"`
	// weight4
	Weight4 int `yaml:"weight4" codec:"weight4"`
	// weight5
	Weight5 int `yaml:"weight5" codec:"weight5"`
}
// yunying/luxurydirectbuygift.csv
type Yunying_luxurydirectbuygift struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// discount
	Discount int `yaml:"discount" codec:"discount"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// item
	Item tjcsv.Map `yaml:"item" codec:"item"`
	// limit
	Limit int `yaml:"limit" codec:"limit"`
	// name
	Name string `yaml:"name" codec:"name"`
	// rechargeID
	RechargeID int `yaml:"rechargeID" codec:"rechargeID"`
	// rmbCost
	RmbCost int `yaml:"rmbCost" codec:"rmbCost"`
	// targetArg
	TargetArg tjcsv.Slice `yaml:"targetArg" codec:"targetArg"`
	// targetType
	TargetType int `yaml:"targetType" codec:"targetType"`
	// titleName
	TitleName string `yaml:"titleName" codec:"titleName"`
}
// yunying/mid_autumn_draw.csv
type Yunying_mid_autumn_draw struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// best
	Best tjcsv.Map `yaml:"best" codec:"best"`
	// bestPoolID
	BestPoolID tjcsv.Map `yaml:"bestPoolID" codec:"bestPoolID"`
	// bestPoolMaxTimes
	BestPoolMaxTimes int `yaml:"bestPoolMaxTimes" codec:"bestPoolMaxTimes"`
	// bestPoolProb
	BestPoolProb int `yaml:"bestPoolProb" codec:"bestPoolProb"`
	// common
	Common tjcsv.Map `yaml:"common" codec:"common"`
	// commonPoolID
	CommonPoolID tjcsv.Map `yaml:"commonPoolID" codec:"commonPoolID"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// roundDrawTimes
	RoundDrawTimes int `yaml:"roundDrawTimes" codec:"roundDrawTimes"`
}
// yunying/mid_autumn_draw_tasks.csv
type Yunying_mid_autumn_draw_tasks struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// addTimes
	AddTimes int `yaml:"addTimes" codec:"addTimes"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// taskParam
	TaskParam int `yaml:"taskParam" codec:"taskParam"`
	// taskSpecialParam
	TaskSpecialParam tjcsv.Map `yaml:"taskSpecialParam" codec:"taskSpecialParam"`
	// taskType
	TaskType int `yaml:"taskType" codec:"taskType"`
}
// yunying/newfirstrecharge.csv
type Yunying_newfirstrecharge struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// rmb
	Rmb int `yaml:"rmb" codec:"rmb"`
}
// yunying/oncerechage.csv
type Yunying_oncerechage struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// needRmb
	NeedRmb int `yaml:"needRmb" codec:"needRmb"`
}
// yunying/passport_award.csv
type Yunying_passport_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// eliteAward
	EliteAward tjcsv.Map `yaml:"eliteAward" codec:"eliteAward"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// level
	Level int `yaml:"level" codec:"level"`
	// needExp
	NeedExp int `yaml:"needExp" codec:"needExp"`
	// normalAward
	NormalAward tjcsv.Map `yaml:"normalAward" codec:"normalAward"`
	// specialAward
	SpecialAward int `yaml:"specialAward" codec:"specialAward"`
	// texiao
	Texiao tjcsv.Slice `yaml:"texiao" codec:"texiao"`
}
// yunying/passport_recharge.csv
type Yunying_passport_recharge struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// discountValue
	DiscountValue int `yaml:"discountValue" codec:"discountValue"`
	// exp
	Exp int `yaml:"exp" codec:"exp"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// level
	Level int `yaml:"level" codec:"level"`
	// logo
	Logo int `yaml:"logo" codec:"logo"`
	// name
	Name string `yaml:"name" codec:"name"`
	// rechargeID
	RechargeID int `yaml:"rechargeID" codec:"rechargeID"`
	// res
	Res string `yaml:"res" codec:"res"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// yunying/passport_shop.csv
type Yunying_passport_shop struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// items
	Items tjcsv.Map `yaml:"items" codec:"items"`
	// limitTimes
	LimitTimes int `yaml:"limitTimes" codec:"limitTimes"`
	// position
	Position int `yaml:"position" codec:"position"`
}
// yunying/passport_task.csv
type Yunying_passport_task struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// exp
	Exp int `yaml:"exp" codec:"exp"`
	// goToPanel
	GoToPanel string `yaml:"goToPanel" codec:"goToPanel"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// periodType
	PeriodType int `yaml:"periodType" codec:"periodType"`
	// taskAttribute
	TaskAttribute int `yaml:"taskAttribute" codec:"taskAttribute"`
	// taskParam
	TaskParam int `yaml:"taskParam" codec:"taskParam"`
	// taskSpecialParam
	TaskSpecialParam tjcsv.Map `yaml:"taskSpecialParam" codec:"taskSpecialParam"`
	// taskType
	TaskType int `yaml:"taskType" codec:"taskType"`
	// title
	Title string `yaml:"title" codec:"title"`
	// weekParam
	WeekParam int `yaml:"weekParam" codec:"weekParam"`
}
// yunying/placard.csv
type Yunying_placard struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// content
	Content interface{} `yaml:"content" codec:"content"`
}
// yunying/playpassport_award.csv
type Yunying_playpassport_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// eliteAward
	EliteAward tjcsv.Map `yaml:"eliteAward" codec:"eliteAward"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// level
	Level int `yaml:"level" codec:"level"`
	// needExp
	NeedExp int `yaml:"needExp" codec:"needExp"`
	// normalAward
	NormalAward tjcsv.Map `yaml:"normalAward" codec:"normalAward"`
	// specialAward
	SpecialAward int `yaml:"specialAward" codec:"specialAward"`
	// texiao
	Texiao tjcsv.Slice `yaml:"texiao" codec:"texiao"`
}
// yunying/playpassport_recharge.csv
type Yunying_playpassport_recharge struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// desc
	Desc interface{} `yaml:"desc" codec:"desc"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// icon
	Icon interface{} `yaml:"icon" codec:"icon"`
	// name
	Name string `yaml:"name" codec:"name"`
	// originalPrice
	OriginalPrice int `yaml:"originalPrice" codec:"originalPrice"`
	// rechargeID
	RechargeID int `yaml:"rechargeID" codec:"rechargeID"`
}
// yunying/qualityexchange.csv
type Yunying_qualityexchange struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// count
	Count int `yaml:"count" codec:"count"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// items
	Items tjcsv.Slice `yaml:"items" codec:"items"`
	// quality
	Quality int `yaml:"quality" codec:"quality"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// yunying/rechargegift.csv
type Yunying_rechargegift struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// amount
	Amount int `yaml:"amount" codec:"amount"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// daySum
	DaySum int `yaml:"daySum" codec:"daySum"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// special
	Special tjcsv.Map `yaml:"special" codec:"special"`
}
// yunying/rechargegift_huodongid.csv
type Yunying_rechargegift_huodongid struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// servers
	Servers tjcsv.Map `yaml:"servers" codec:"servers"`
}
// yunying/retrieve.csv
type Yunying_retrieve struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// advanceItems
	AdvanceItems tjcsv.Map `yaml:"advanceItems" codec:"advanceItems"`
	// cost
	Cost tjcsv.Map `yaml:"cost" codec:"cost"`
	// energyItems
	EnergyItems tjcsv.Map `yaml:"energyItems" codec:"energyItems"`
	// equipItems
	EquipItems tjcsv.Map `yaml:"equipItems" codec:"equipItems"`
	// expItems
	ExpItems tjcsv.Map `yaml:"expItems" codec:"expItems"`
	// gold
	Gold tjcsv.Map `yaml:"gold" codec:"gold"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// level
	Level int `yaml:"level" codec:"level"`
	// roleExp
	RoleExp tjcsv.Map `yaml:"roleExp" codec:"roleExp"`
}
// yunying/reunion_catchup.csv
type Yunying_reunion_catchup struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// addNum
	AddNum int `yaml:"addNum" codec:"addNum"`
	// addType
	AddType int `yaml:"addType" codec:"addType"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// goto
	Goto interface{} `yaml:"goto" codec:"goto"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// params
	Params tjcsv.Map `yaml:"params" codec:"params"`
	// remark
	Remark string `yaml:"remark" codec:"remark"`
	// title
	Title string `yaml:"title" codec:"title"`
}
// yunying/reunion_gift.csv
type Yunying_reunion_gift struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// item
	Item tjcsv.Map `yaml:"item" codec:"item"`
	// name
	Name string `yaml:"name" codec:"name"`
	// target
	Target int `yaml:"target" codec:"target"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// yunying/reunion_point_box.csv
type Yunying_reunion_point_box struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award1
	Award1 tjcsv.Map `yaml:"award1" codec:"award1"`
	// award2
	Award2 tjcsv.Map `yaml:"award2" codec:"award2"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// pointNode
	PointNode int `yaml:"pointNode" codec:"pointNode"`
	// res
	Res string `yaml:"res" codec:"res"`
	// resOpen
	ResOpen string `yaml:"resOpen" codec:"resOpen"`
}
// yunying/reunion_recharge.csv
type Yunying_reunion_recharge struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// item
	Item tjcsv.Map `yaml:"item" codec:"item"`
	// limitNum
	LimitNum int `yaml:"limitNum" codec:"limitNum"`
	// limitType
	LimitType int `yaml:"limitType" codec:"limitType"`
	// name
	Name string `yaml:"name" codec:"name"`
	// rechargeID
	RechargeID int `yaml:"rechargeID" codec:"rechargeID"`
	// res
	Res string `yaml:"res" codec:"res"`
}
// yunying/reunion_task.csv
type Yunying_reunion_task struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// goto
	Goto interface{} `yaml:"goto" codec:"goto"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// isCooperative
	IsCooperative bool `yaml:"isCooperative" codec:"isCooperative"`
	// isSync
	IsSync bool `yaml:"isSync" codec:"isSync"`
	// point
	Point int `yaml:"point" codec:"point"`
	// taskLinks
	TaskLinks int `yaml:"taskLinks" codec:"taskLinks"`
	// taskParam
	TaskParam int `yaml:"taskParam" codec:"taskParam"`
	// taskSpecialParam
	TaskSpecialParam tjcsv.Map `yaml:"taskSpecialParam" codec:"taskSpecialParam"`
	// taskType
	TaskType int `yaml:"taskType" codec:"taskType"`
	// theme
	Theme string `yaml:"theme" codec:"theme"`
	// themeType
	ThemeType int `yaml:"themeType" codec:"themeType"`
}
// yunying/rmbcost.csv
type Yunying_rmbcost struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// amount
	Amount int `yaml:"amount" codec:"amount"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
}
// yunying/rmbgoldreturn_award.csv
type Yunying_rmbgoldreturn_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// num
	Num int `yaml:"num" codec:"num"`
}
// yunying/rmbgoldreturn_rate.csv
type Yunying_rmbgoldreturn_rate struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// num
	Num int `yaml:"num" codec:"num"`
	// rate
	Rate float64 `yaml:"rate" codec:"rate"`
}
// yunying/serveropen.csv
type Yunying_serveropen struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// buyMax
	BuyMax int `yaml:"buyMax" codec:"buyMax"`
	// costMap
	CostMap tjcsv.Map `yaml:"costMap" codec:"costMap"`
	// countType
	CountType int `yaml:"countType" codec:"countType"`
	// daySum
	DaySum int `yaml:"daySum" codec:"daySum"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// priceShow
	PriceShow tjcsv.Map `yaml:"priceShow" codec:"priceShow"`
	// tabIndex
	TabIndex int `yaml:"tabIndex" codec:"tabIndex"`
	// tabName
	TabName string `yaml:"tabName" codec:"tabName"`
	// taskParam
	TaskParam int `yaml:"taskParam" codec:"taskParam"`
	// taskSpecialParam
	TaskSpecialParam tjcsv.Map `yaml:"taskSpecialParam" codec:"taskSpecialParam"`
	// taskType
	TaskType int `yaml:"taskType" codec:"taskType"`
	// themeName
	ThemeName string `yaml:"themeName" codec:"themeName"`
	// themeType
	ThemeType int `yaml:"themeType" codec:"themeType"`
}
// yunying/shaved_ice_base.csv
type Yunying_shaved_ice_base struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// emoji
	Emoji tjcsv.Map `yaml:"emoji" codec:"emoji"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// score
	Score tjcsv.Map `yaml:"score" codec:"score"`
	// time
	Time tjcsv.Map `yaml:"time" codec:"time"`
}
// yunying/shaved_ice_cards.csv
type Yunying_shaved_ice_cards struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
}
// yunying/shaved_ice_demand.csv
type Yunying_shaved_ice_demand struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// index
	Index int `yaml:"index" codec:"index"`
	// itemNum
	ItemNum int `yaml:"itemNum" codec:"itemNum"`
	// time
	Time float64 `yaml:"time" codec:"time"`
}
// yunying/shaved_ice_items.csv
type Yunying_shaved_ice_items struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// icon1
	Icon1 string `yaml:"icon1" codec:"icon1"`
	// icon2
	Icon2 string `yaml:"icon2" codec:"icon2"`
	// weight
	Weight int `yaml:"weight" codec:"weight"`
}
// yunying/shaved_ice_stage_award.csv
type Yunying_shaved_ice_stage_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// randomAward
	RandomAward tjcsv.Map `yaml:"randomAward" codec:"randomAward"`
	// score
	Score tjcsv.Slice `yaml:"score" codec:"score"`
}
// yunying/skyscraper_accessment.csv
type Yunying_skyscraper_accessment struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// contactRange
	ContactRange int `yaml:"contactRange" codec:"contactRange"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// points
	Points int `yaml:"points" codec:"points"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// yunying/skyscraper_floors.csv
type Yunying_skyscraper_floors struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// awards
	Awards tjcsv.Map `yaml:"awards" codec:"awards"`
	// awardsIcon
	AwardsIcon string `yaml:"awardsIcon" codec:"awardsIcon"`
	// hookSpeed
	HookSpeed float64 `yaml:"hookSpeed" codec:"hookSpeed"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// maxRotate
	MaxRotate int `yaml:"maxRotate" codec:"maxRotate"`
	// range
	Range tjcsv.Slice `yaml:"range" codec:"range"`
	// swing
	Swing int `yaml:"swing" codec:"swing"`
}
// yunying/skyscraper_medals.csv
type Yunying_skyscraper_medals struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// color
	Color tjcsv.Slice `yaml:"color" codec:"color"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// medalLevel
	MedalLevel int `yaml:"medalLevel" codec:"medalLevel"`
	// medalsName
	MedalsName string `yaml:"medalsName" codec:"medalsName"`
	// points
	Points int `yaml:"points" codec:"points"`
	// rankRes
	RankRes string `yaml:"rankRes" codec:"rankRes"`
	// resource
	Resource string `yaml:"resource" codec:"resource"`
	// resourceNum
	ResourceNum string `yaml:"resourceNum" codec:"resourceNum"`
}
// yunying/skyscraper_resources.csv
type Yunying_skyscraper_resources struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// pngResource
	PngResource tjcsv.Slice `yaml:"pngResource" codec:"pngResource"`
	// range
	Range tjcsv.Slice `yaml:"range" codec:"range"`
	// spineResource
	SpineResource tjcsv.Slice `yaml:"spineResource" codec:"spineResource"`
}
// yunying/skyscraper_tasks.csv
type Yunying_skyscraper_tasks struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// label
	Label string `yaml:"label" codec:"label"`
	// params
	Params int `yaml:"params" codec:"params"`
	// points
	Points int `yaml:"points" codec:"points"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// yunying/snowball_award.csv
type Yunying_snowball_award struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// num
	Num int `yaml:"num" codec:"num"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// yunying/snowball_element.csv
type Yunying_snowball_element struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attr
	Attr tjcsv.Map `yaml:"attr" codec:"attr"`
	// belongs
	Belongs int `yaml:"belongs" codec:"belongs"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
}
// yunying/snowball_stage.csv
type Yunying_snowball_stage struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// dropsTempo
	DropsTempo tjcsv.Map `yaml:"dropsTempo" codec:"dropsTempo"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// timeScore
	TimeScore int `yaml:"timeScore" codec:"timeScore"`
	// timing
	Timing int `yaml:"timing" codec:"timing"`
}
// yunying/stargift.csv
type Yunying_stargift struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// buyAward
	BuyAward tjcsv.Map `yaml:"buyAward" codec:"buyAward"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// freeAward
	FreeAward tjcsv.Map `yaml:"freeAward" codec:"freeAward"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// rechargeID
	RechargeID int `yaml:"rechargeID" codec:"rechargeID"`
	// star
	Star int `yaml:"star" codec:"star"`
}
// yunying/totalpaygift.csv
type Yunying_totalpaygift struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// item
	Item tjcsv.Map `yaml:"item" codec:"item"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// pay
	Pay int `yaml:"pay" codec:"pay"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// yunying/upstargift.csv
type Yunying_upstargift struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// day
	Day int `yaml:"day" codec:"day"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// rechargeID
	RechargeID int `yaml:"rechargeID" codec:"rechargeID"`
	// star
	Star int `yaml:"star" codec:"star"`
}
// yunying/vipaward.csv
type Yunying_vipaward struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// needLevel
	NeedLevel int `yaml:"needLevel" codec:"needLevel"`
}
// yunying/vipbuy.csv
type Yunying_vipbuy struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// displayRMB
	DisplayRMB int `yaml:"displayRMB" codec:"displayRMB"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// item
	Item tjcsv.Map `yaml:"item" codec:"item"`
	// rmb
	Rmb int `yaml:"rmb" codec:"rmb"`
	// title
	Title string `yaml:"title" codec:"title"`
	// vip
	Vip int `yaml:"vip" codec:"vip"`
}
// yunying/volleyball_tasks.csv
type Yunying_volleyball_tasks struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// targetArg
	TargetArg int `yaml:"targetArg" codec:"targetArg"`
	// targetArg2
	TargetArg2 int `yaml:"targetArg2" codec:"targetArg2"`
	// targetType
	TargetType int `yaml:"targetType" codec:"targetType"`
	// title
	Title string `yaml:"title" codec:"title"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// yunying/weeklycard.csv
type Yunying_weeklycard struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// award
	Award tjcsv.Map `yaml:"award" codec:"award"`
	// day
	Day int `yaml:"day" codec:"day"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
}
// yunying/yyhuodong.csv
type Yunying_yyhuodong struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// active
	Active int `yaml:"active" codec:"active"`
	// beginDate
	BeginDate int `yaml:"beginDate" codec:"beginDate"`
	// beginTime
	BeginTime int `yaml:"beginTime" codec:"beginTime"`
	// clientParam
	ClientParam tjcsv.Map `yaml:"clientParam" codec:"clientParam"`
	// countType
	CountType int `yaml:"countType" codec:"countType"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// endDate
	EndDate int `yaml:"endDate" codec:"endDate"`
	// endTime
	EndTime int `yaml:"endTime" codec:"endTime"`
	// huodongID
	HuodongID int `yaml:"huodongID" codec:"huodongID"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// icon1
	Icon1 int `yaml:"icon1" codec:"icon1"`
	// independent
	Independent int `yaml:"independent" codec:"independent"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// leastLevel
	LeastLevel int `yaml:"leastLevel" codec:"leastLevel"`
	// leastVipLevel
	LeastVipLevel int `yaml:"leastVipLevel" codec:"leastVipLevel"`
	// name
	Name string `yaml:"name" codec:"name"`
	// openDuration
	OpenDuration int `yaml:"openDuration" codec:"openDuration"`
	// openType
	OpenType int `yaml:"openType" codec:"openType"`
	// paramMap
	ParamMap tjcsv.Map `yaml:"paramMap" codec:"paramMap"`
	// rDesc
	RDesc string `yaml:"rDesc" codec:"rDesc"`
	// redpoint
	Redpoint int `yaml:"redpoint" codec:"redpoint"`
	// relativeDayRange
	RelativeDayRange tjcsv.Slice `yaml:"relativeDayRange" codec:"relativeDayRange"`
	// roleDayRange
	RoleDayRange tjcsv.Slice `yaml:"roleDayRange" codec:"roleDayRange"`
	// serverDayRange
	ServerDayRange tjcsv.Slice `yaml:"serverDayRange" codec:"serverDayRange"`
	// servers
	Servers tjcsv.Map `yaml:"servers" codec:"servers"`
	// sortWeight
	SortWeight int `yaml:"sortWeight" codec:"sortWeight"`
	// type
	Type int `yaml:"type" codec:"type"`
	// validRoleCreatedDateRange
	ValidRoleCreatedDateRange tjcsv.Slice `yaml:"validRoleCreatedDateRange" codec:"validRoleCreatedDateRange"`
	// validServerOpenDateRange
	ValidServerOpenDateRange tjcsv.Slice `yaml:"validServerOpenDateRange" codec:"validServerOpenDateRange"`
}
// zawake
type Zawake struct {
	// zawake/bonus.csv
	Bonus map[int]*Zawake_bonus `yaml:"bonus" codec:"bonus"`
	// zawake/exchange.csv
	Exchange map[int]*Zawake_exchange `yaml:"exchange" codec:"exchange"`
	// zawake/levels.csv
	Levels map[int]*Zawake_levels `yaml:"levels" codec:"levels"`
	// zawake/stages.csv
	Stages map[int]*Zawake_stages `yaml:"stages" codec:"stages"`
	// zawake/zawake_fragments.csv
	Zawake_fragments map[int]*Zawake_zawake_fragments `yaml:"zawake_fragments" codec:"zawake_fragments"`
}
// zawake/bonus.csv
type Zawake_bonus struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// attrNum1
	AttrNum1 float64 `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 float64 `yaml:"attrNum2" codec:"attrNum2"`
	// attrNum3
	AttrNum3 float64 `yaml:"attrNum3" codec:"attrNum3"`
	// attrNum4
	AttrNum4 float64 `yaml:"attrNum4" codec:"attrNum4"`
	// attrNum5
	AttrNum5 float64 `yaml:"attrNum5" codec:"attrNum5"`
	// attrNum6
	AttrNum6 float64 `yaml:"attrNum6" codec:"attrNum6"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// attrType3
	AttrType3 int `yaml:"attrType3" codec:"attrType3"`
	// attrType4
	AttrType4 int `yaml:"attrType4" codec:"attrType4"`
	// attrType5
	AttrType5 int `yaml:"attrType5" codec:"attrType5"`
	// attrType6
	AttrType6 int `yaml:"attrType6" codec:"attrType6"`
	// exp
	Exp int `yaml:"exp" codec:"exp"`
}
// zawake/exchange.csv
type Zawake_exchange struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// cardConvertNum
	CardConvertNum int `yaml:"cardConvertNum" codec:"cardConvertNum"`
	// costItemCard
	CostItemCard tjcsv.Map `yaml:"costItemCard" codec:"costItemCard"`
	// costItemFrag
	CostItemFrag tjcsv.Map `yaml:"costItemFrag" codec:"costItemFrag"`
	// needCards
	NeedCards tjcsv.Slice `yaml:"needCards" codec:"needCards"`
	// needFrags
	NeedFrags tjcsv.Slice `yaml:"needFrags" codec:"needFrags"`
	// needSpecialCards
	NeedSpecialCards tjcsv.Slice `yaml:"needSpecialCards" codec:"needSpecialCards"`
	// needSpecialFrags
	NeedSpecialFrags tjcsv.Slice `yaml:"needSpecialFrags" codec:"needSpecialFrags"`
	// roriCards
	RoriCards tjcsv.Slice `yaml:"roriCards" codec:"roriCards"`
	// roriFrags
	RoriFrags tjcsv.Slice `yaml:"roriFrags" codec:"roriFrags"`
	// type
	Type int `yaml:"type" codec:"type"`
}
// zawake/levels.csv
type Zawake_levels struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// activeReq
	ActiveReq tjcsv.Map `yaml:"activeReq" codec:"activeReq"`
	// attrAddType
	AttrAddType int `yaml:"attrAddType" codec:"attrAddType"`
	// attrNum1
	AttrNum1 int `yaml:"attrNum1" codec:"attrNum1"`
	// attrNum2
	AttrNum2 int `yaml:"attrNum2" codec:"attrNum2"`
	// attrNum3
	AttrNum3 int `yaml:"attrNum3" codec:"attrNum3"`
	// attrNum4
	AttrNum4 int `yaml:"attrNum4" codec:"attrNum4"`
	// attrNum5
	AttrNum5 int `yaml:"attrNum5" codec:"attrNum5"`
	// attrType1
	AttrType1 int `yaml:"attrType1" codec:"attrType1"`
	// attrType2
	AttrType2 int `yaml:"attrType2" codec:"attrType2"`
	// attrType3
	AttrType3 int `yaml:"attrType3" codec:"attrType3"`
	// attrType4
	AttrType4 int `yaml:"attrType4" codec:"attrType4"`
	// attrType5
	AttrType5 int `yaml:"attrType5" codec:"attrType5"`
	// awakeSeqID
	AwakeSeqID int `yaml:"awakeSeqID" codec:"awakeSeqID"`
	// costItemMap
	CostItemMap tjcsv.Map `yaml:"costItemMap" codec:"costItemMap"`
	// exp
	Exp int `yaml:"exp" codec:"exp"`
	// extraAttrs
	ExtraAttrs tjcsv.Map `yaml:"extraAttrs" codec:"extraAttrs"`
	// extraScene
	ExtraScene tjcsv.Slice `yaml:"extraScene" codec:"extraScene"`
	// level
	Level int `yaml:"level" codec:"level"`
	// natureType
	NatureType int `yaml:"natureType" codec:"natureType"`
	// skillID
	SkillID int `yaml:"skillID" codec:"skillID"`
	// viceHeldItem
	ViceHeldItem bool `yaml:"viceHeldItem" codec:"viceHeldItem"`
	// zawakeID
	ZawakeID int `yaml:"zawakeID" codec:"zawakeID"`
}
// zawake/stages.csv
type Zawake_stages struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// awakeDes1
	AwakeDes1 string `yaml:"awakeDes1" codec:"awakeDes1"`
	// awakeSeqID
	AwakeSeqID int `yaml:"awakeSeqID" codec:"awakeSeqID"`
	// isOpen
	IsOpen int `yaml:"isOpen" codec:"isOpen"`
	// pos
	Pos tjcsv.Map `yaml:"pos" codec:"pos"`
	// scale
	Scale float64 `yaml:"scale" codec:"scale"`
	// unlockLimit1
	UnlockLimit1 tjcsv.Map `yaml:"unlockLimit1" codec:"unlockLimit1"`
	// unlockLimit2
	UnlockLimit2 tjcsv.Map `yaml:"unlockLimit2" codec:"unlockLimit2"`
	// unlockType1
	UnlockType1 int `yaml:"unlockType1" codec:"unlockType1"`
	// unlockType2
	UnlockType2 int `yaml:"unlockType2" codec:"unlockType2"`
	// zawakeID
	ZawakeID int `yaml:"zawakeID" codec:"zawakeID"`
}
// zawake/zawake_fragments.csv
type Zawake_zawake_fragments struct {
	// ID
	ID int `yaml:"ID" codec:"ID"`
	// cardID
	CardID int `yaml:"cardID" codec:"cardID"`
	// desc
	Desc string `yaml:"desc" codec:"desc"`
	// desc1
	Desc1 string `yaml:"desc1" codec:"desc1"`
	// effBtn
	EffBtn tjcsv.Slice `yaml:"effBtn" codec:"effBtn"`
	// effect
	Effect tjcsv.Map `yaml:"effect" codec:"effect"`
	// icon
	Icon string `yaml:"icon" codec:"icon"`
	// languages
	Languages tjcsv.Slice `yaml:"languages" codec:"languages"`
	// name
	Name string `yaml:"name" codec:"name"`
	// pageTag
	PageTag tjcsv.Slice `yaml:"pageTag" codec:"pageTag"`
	// produceDesc
	ProduceDesc string `yaml:"produceDesc" codec:"produceDesc"`
	// produceGate1
	ProduceGate1 string `yaml:"produceGate1" codec:"produceGate1"`
	// produceGate2
	ProduceGate2 interface{} `yaml:"produceGate2" codec:"produceGate2"`
	// produceGate3
	ProduceGate3 interface{} `yaml:"produceGate3" codec:"produceGate3"`
	// produceGate4
	ProduceGate4 interface{} `yaml:"produceGate4" codec:"produceGate4"`
	// produceGate5
	ProduceGate5 interface{} `yaml:"produceGate5" codec:"produceGate5"`
	// produceGate6
	ProduceGate6 interface{} `yaml:"produceGate6" codec:"produceGate6"`
	// produceGate7
	ProduceGate7 interface{} `yaml:"produceGate7" codec:"produceGate7"`
	// quality
	Quality int `yaml:"quality" codec:"quality"`
	// sortType
	SortType int `yaml:"sortType" codec:"sortType"`
	// sortValue
	SortValue int `yaml:"sortValue" codec:"sortValue"`
	// stackMax
	StackMax int `yaml:"stackMax" codec:"stackMax"`
	// type
	Type int `yaml:"type" codec:"type"`
}

