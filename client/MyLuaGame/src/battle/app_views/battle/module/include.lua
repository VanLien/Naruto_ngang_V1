local var_0_0 = {}

globals.battleModule = var_0_0

require("battle.app_views.battle.module.base")
require("battle.app_views.battle.module.notify")

var_0_0.mods = {
	require("battle.app_views.battle.module.objmanager"),
	require("battle.app_views.battle.module.mainarea"),
	require("battle.app_views.battle.module.skillinfo"),
	require("battle.app_views.battle.module.speedrank"),
	require("battle.app_views.battle.module.sys"),
	require("battle.app_views.battle.module.vsinfo"),
	require("battle.app_views.battle.module.weather"),
	require("battle.app_views.battle.module.stage"),
	require("battle.app_views.battle.module.bufficon"),
	require("battle.app_views.battle.module.headnum"),
	require("battle.app_views.battle.module.frame"),
	require("battle.app_views.battle.module.linkeffect"),
	require("battle.app_views.battle.module.debugarea")
}
var_0_0.dailyActivityMods = {
	require("battle.app_views.battle.module.spec.daily_activity")
}
var_0_0.craftMods = {
	require("battle.app_views.battle.module.spec.craft")
}
var_0_0.bossMods = {
	require("battle.app_views.battle.module.spec.world_boss")
}
var_0_0.onlineFightMods = {
	require("battle.app_views.battle.module.spec.online_fight")
}
var_0_0.gymMods = {
	require("battle.app_views.battle.module.spec.gym")
}
var_0_0.crossMineMods = {
	require("battle.app_views.battle.module.spec.cross_mine")
}
var_0_0.mimicryMods = {
	require("battle.app_views.battle.module.spec.mimicry")
}

return var_0_0
