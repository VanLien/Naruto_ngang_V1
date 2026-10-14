require("battle.app_views.battle.preload_res")

local var_0_0 = {
	loadOver = 2,
	loading = 1,
	switchUI = 3
}
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("BattleLoadingView", var_0_1)

var_0_2.RESOURCE_FILENAME = "battle_loading.json"
var_0_2.RESOURCE_BINDING = {
	bg = "bg",
	bar = {
		varname = "bar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				maskImg = "common/icon/mask_bar_red.png",
				data = bindHelper.self("percent")
			}
		}
	},
	percentText = {
		binds = {
			{
				event = "text",
				idler = bindHelper.self("percent"),
				method = function(arg_1_0)
					return math.floor(arg_1_0) .. "%"
				end
			},
			{
				event = "effect",
				data = {
					outline = {
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			}
		}
	},
	tipText = {
		varname = "tipText",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	}
}

local function var_0_3(arg_2_0, arg_2_1)
	for iter_2_0, iter_2_1 in pairs(arg_2_1) do
		arg_2_0[iter_2_1] = 1 + (arg_2_0[iter_2_1] or 0)
	end
end

function var_0_2.onCreate(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	assert(arg_3_4, "entrance was nil !")

	arg_3_0.data = arg_3_1
	arg_3_0.sceneID = arg_3_2
	arg_3_0.modes = arg_3_3 or {}
	arg_3_0.entrance = arg_3_4
	arg_3_0.percent = idler.new(0)

	local var_3_0 = math.random(1, csvSize(csv.loading_tips))

	arg_3_0.tipText:text(csv.loading_tips[var_3_0].tip)

	local var_3_1 = math.random(1, table.length(gCommonConfigArrayCsv.loadingBgTotal))

	arg_3_0.bg:texture(string.format("loading/bg_%d.png", gCommonConfigArrayCsv.loadingBgTotal[var_3_1]))
	arg_3_0:enableAsyncload():asyncFor(functools.partial(arg_3_0.onLoading, arg_3_0), functools.partial(arg_3_0.onLoadOver, arg_3_0))

	local var_3_2, var_3_3 = arg_3_0.bar:xy()
	local var_3_4 = arg_3_0.bar:box()
	local var_3_5 = widget.addAnimationByKey(arg_3_0:getResourceNode(), "loading/loading_dog.skel", "effect", "effect_loop", 5):xy(var_3_2 - var_3_4.width / 2, var_3_3 + var_3_4.height / 2):scale(1.6)

	idlereasy.when(arg_3_0.percent, function(arg_4_0, arg_4_1)
		var_3_5:x(var_3_2 - var_3_4.width / 2 + arg_4_1 * var_3_4.width / 100)
	end)

	arg_3_0.canPlayMusic = false

	if not arg_3_0.modes.baseMusic then
		local var_3_6 = math.random(1, 5)
		local var_3_7 = string.format("battle%d.mp3", var_3_6)

		arg_3_0.modes.baseMusic = var_3_7
	end

	audio.preloadMusic(arg_3_0.modes.baseMusic)
end

function var_0_2.onLoading(arg_5_0)
	local var_5_0 = collectgarbage("count")

	arg_5_0.loadingState = var_0_0.loading

	arg_5_0.percent:set(1)
	coroutine.yield()
	arg_5_0.percent:set(4)
	cache.onBattleClear()
	coroutine.yield()
	arg_5_0.percent:set(5)
	checkGGCheat()
	coroutine.yield()
	arg_5_0.percent:set(6)
	battleEntrance.preloadConfig()
	arg_5_0.percent:set(7)
	cache.texturePreload("battle_common_ui")
	cache.texturePreload("battle_module")
	coroutine.yield()

	local var_5_1 = {}
	local var_5_2 = {}
	local var_5_3 = gMonsterCsv[arg_5_0.sceneID][1]

	if not var_5_3 then
		printError(" 查找 monster_scenes 时出错!!! 有场景第一波的配置不存在: sceneID=%s", arg_5_0.sceneID)
	end

	visitFightResources(var_5_1, var_5_2, var_5_3, arg_5_0.data)

	for iter_5_0 = 2, itertools.size(gMonsterCsv[arg_5_0.sceneID]) do
		local var_5_4 = gMonsterCsv[arg_5_0.sceneID][iter_5_0]

		for iter_5_1, iter_5_2 in ipairs(var_5_4.monsters) do
			if iter_5_2 > 0 then
				local var_5_5 = csv.unit[iter_5_2]

				for iter_5_3, iter_5_4 in ipairs(var_5_5.skillList) do
					local var_5_6 = csv.skill[iter_5_4]

					if var_5_6.sound then
						var_5_2[var_5_6.sound.res] = true
					end
				end
			end
		end
	end

	var_0_3(var_5_1, battle.SpriteRes)
	var_0_3(var_5_1, battle.ShowHeadNumberRes)
	var_0_3(var_5_1, battle.MainAreaRes)
	var_0_3(var_5_1, battle.StageRes)
	var_0_3(var_5_1, battle.RestraintTypeIcon)

	local var_5_7 = 0
	local var_5_8 = itertools.sum(var_5_1) + itertools.size(var_5_2)

	log.battleloading.preload(" ---- preLoad res, allCount=", var_5_8, itertools.sum(var_5_1), itertools.size(var_5_2))
	arg_5_0.percent:set(10)
	coroutine.yield()
	performWithDelay(arg_5_0, function()
		arg_5_0:onRunBattleModel()
	end, 0.01)
	cc.SpriteFrameCache:getInstance():addSpriteFrames("battle/buff_icon/buffs0.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames("battle/txt/txts0.plist")
	coroutine.yield()

	local var_5_9 = 50

	local function var_5_10()
		local var_7_0 = cc.FileUtils:getInstance()
		local var_7_1 = display.textureCache:removeLongTimeUnusedTexturesWithCallback(function(arg_8_0, arg_8_1)
			local var_8_0 = var_7_0:getRawPathInRepoCache(arg_8_1:getPath())

			return var_8_0:find("battle/") == nil and var_8_0:find("res/spine/koudai_") == nil
		end, var_5_9, -1)

		if var_7_1 > 0 then
			printInfo("remove %d textures in battle.loading", var_7_1)
		end

		return var_7_1
	end

	local var_5_11 = display.textureCache:getDescription()

	if (tonumber(var_5_11:sub(10)) or 0) > 100 then
		local var_5_12

		var_5_12 = schedule(arg_5_0, function()
			if var_5_10() < var_5_9 then
				var_5_12 = nil
			end
		end, 0)
	end

	coroutine.yield()

	for iter_5_5, iter_5_6 in pairs(var_5_1) do
		log.battleloading.preload(" ---- preload: file path=", iter_5_5, iter_5_6)

		for iter_5_7 = 1, iter_5_6 do
			CSprite.preLoad(iter_5_5)

			var_5_7 = var_5_7 + 1

			arg_5_0.percent:set(10 + 70 * var_5_7 / var_5_8)
			coroutine.yield()
		end
	end

	arg_5_0.canPlayMusic = true

	for iter_5_8, iter_5_9 in pairs(var_5_2) do
		log.battleloading.preload(" ---- preload: audio path=", iter_5_8, iter_5_9)
		audio.preloadSound(iter_5_8)

		var_5_7 = var_5_7 + 1

		arg_5_0.percent:set(10 + 70 * var_5_7 / var_5_8)
		coroutine.yield()
	end

	for iter_5_10 = 1, 15 do
		collectgarbage("step", 10000)
		arg_5_0.percent:set(80 + iter_5_10)
		coroutine.yield()
	end

	while arg_5_0.loadingState ~= var_0_0.loadOver do
		collectgarbage("step", 10000)
		coroutine.yield()
	end

	local var_5_13 = os.clock()

	collectgarbage()
	printInfo("battle loading gc over %.2f KB %s s", var_5_0 - collectgarbage("count"), os.clock() - var_5_13)
	arg_5_0.percent:set(100)
	coroutine.yield()

	arg_5_0.loadingState = var_0_0.loadOver
end

function var_0_2.onPlayMusic(arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_0.canPlayMusic then
		return
	end

	if arg_10_1 then
		audio.playMusic(arg_10_1)
	else
		audio.playMusic(arg_10_0.modes.baseMusic)

		arg_10_0.canPlayMusic = false
	end
end

function var_0_2.onLoadOver(arg_11_0)
	if arg_11_0.loadingState ~= var_0_0.loadOver then
		return
	end

	arg_11_0.percent:set(100)
	performWithDelay(arg_11_0, function()
		if not gGameUI.isPlayVideo then
			arg_11_0.loadingState = var_0_0.switchUI

			arg_11_0:onPlayMusic()
			gGameUI:switchUI("battle.view", arg_11_0.data, arg_11_0.sceneID, arg_11_0.modes, arg_11_0.entrance)
		end
	end, 0)
end

function var_0_2.onRunBattleModel(arg_13_0)
	arg_13_0.loadingState = var_0_0.loadOver
end

return var_0_2
