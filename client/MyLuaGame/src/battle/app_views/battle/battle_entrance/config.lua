local var_0_0 = {
	"csv.common_config",
	"csv.monster_scenes",
	"csv.skill",
	"csv.skill_process",
	"csv.scene_conf",
	"csv.effect_event",
	"csv.effect_power",
	"csv.buff",
	"csv.buff_group_power",
	"csv.buff_group_relation",
	"csv.explorer.explorer",
	"csv.buff_effect",
	"csv.effect_option",
	"csv.damage_process",
	"csv.base_attribute.nature_matrix",
	"csv.game_end_special_rule"
}
local var_0_1 = require("battle.battle_config_defines")
local var_0_2 = false
local var_0_3
local var_0_4

function battleEntrance.preloadConfig()
	if var_0_2 then
		return
	end

	collectgarbage()

	local var_1_0 = collectgarbage("count")
	local var_1_1 = os.clock()

	var_0_3 = getLoadedCsvPathSet()

	printDebug("before battleEntrance.preloadConfig %s", itertools.size(var_0_3))

	for iter_1_0, iter_1_1 in ipairs(var_0_1) do
		iter_1_1.init()
		printDebug("battle preload %s %s", iter_1_1.name, globals[iter_1_1.name])
	end

	for iter_1_2, iter_1_3 in ipairs(var_0_0) do
		local var_1_2 = loadstring("return " .. iter_1_3)()
		local var_1_3 = table.nums(var_1_2)

		printDebug("battle preload %s %s %s", iter_1_3, var_1_2, var_1_3)
	end

	var_0_4 = getLoadedCsvPathSet()

	printDebug("after battleEntrance.preloadConfig %s", itertools.size(var_0_4))
	collectgarbage()

	local var_1_4 = collectgarbage("count")

	printDebug("battleEntrance.preloadConfig over mem %.2fKB cost %.2fKB %.3fs", var_1_4, var_1_4 - var_1_0, os.clock() - var_1_1)

	var_0_2 = true
end

function battleEntrance.unloadConfig()
	if not var_0_2 then
		return
	end

	local var_2_0 = collectgarbage("count")
	local var_2_1 = os.clock()
	local var_2_2 = getLoadedCsvPathSet()
	local var_2_3 = itertools.size(var_2_2)

	for iter_2_0, iter_2_1 in pairs(var_0_3) do
		var_2_2[iter_2_0] = nil
	end

	for iter_2_2, iter_2_3 in pairs(var_0_4) do
		if var_2_2[iter_2_2] then
			var_2_2[iter_2_2] = "preload"
		end
	end

	printDebug("battleEntrance.unloadConfig before %s end %s loaded in battle %s", itertools.size(var_0_3), var_2_3, itertools.size(var_2_2))
	collectgarbage()

	local var_2_4 = collectgarbage("count")

	printDebug("battleEntrance.unloadConfig over mem %.2fKB cost %.2fKB %.3fs", var_2_4, var_2_4 - var_2_0, os.clock() - var_2_1)

	var_0_3 = nil
	var_0_4 = nil
	var_0_2 = false
end
