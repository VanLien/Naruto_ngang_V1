local var_0_0 = class("BattleEndPvpStageUpView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "battle_end_pvp_stage_up.json"
var_0_0.RESOURCE_BINDING = {
	stageTxt = "stageTxt",
	stageChange = "stageChange",
	stage = {
		varname = "stage",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.DEFAULT
				}
			}
		}
	},
	imgBg = {
		binds = {
			event = "click",
			method = bindHelper.self("onCloseClick")
		}
	}
}

function var_0_0.playEffect(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = "effect_loop"

	if arg_1_1 == "zuanshi" and arg_1_2 == "dashi" or arg_1_1 == "dashi" and arg_1_2 == "wangzhe" or arg_1_1 == "zuanshi" and arg_1_2 == "wangzhe" then
		var_1_0 = "effect_up"
	end

	local var_1_1 = arg_1_0:getResourceNode()

	widget.addAnimationByKey(var_1_1, "crossarena/duanwei_di.skel", "selEffect", var_1_0, 100):anchorPoint(cc.p(0.5, 0.5)):xy(arg_1_0.stageChange:xy()):scale(2):play(var_1_0)
end

function var_0_0.playUPEffect(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = arg_2_1 .. "_loop"

	if arg_2_1 ~= arg_2_2 then
		var_2_0 = arg_2_1 .. "_up"
	end

	local var_2_1 = arg_2_0:getResourceNode()
	local var_2_2 = widget.addAnimationByKey(var_2_1, "crossarena/duanwei.skel", "selEffect1", var_2_0, 100):anchorPoint(cc.p(0.5, 0.5)):xy(arg_2_0.stageChange:xy()):scale(2.2)

	local function var_2_3(arg_3_0, arg_3_1)
		local var_3_0 = arg_3_0

		if arg_3_0 == "K" then
			if arg_3_1 == "dashi" then
				var_3_0 = gLanguageCsv.crossArenaStage18
			else
				var_3_0 = gLanguageCsv.crossArenaStage19
			end
		end

		return var_3_0
	end

	if arg_2_1 == arg_2_2 then
		arg_2_0.stageTxt:text(var_2_3(arg_2_4, arg_2_2))

		local var_2_4 = arg_2_0:getResourceNode()

		widget.addAnimationByKey(var_2_4, "crossarena/duanwei_shengji.skel", "selEffect2", "effect", 100):anchorPoint(cc.p(0.5, 0.5)):xy(arg_2_0.stageChange:xy()):play("effect")
	else
		local var_2_5 = arg_2_0:getResourceNode()

		performWithDelay(var_2_5, function()
			var_2_2:hide()
			widget.addAnimationByKey(var_2_5, "crossarena/duanwei.skel", "selEffect3", arg_2_2 .. "_loop", 100):anchorPoint(cc.p(0.5, 0.5)):xy(arg_2_0.stageChange:xy()):scale(2.2):play(arg_2_2 .. "_loop")
		end, 1.8)
		transition.executeSequence(arg_2_0.stageTxt):func(function()
			arg_2_0.stageTxt:text(var_2_3(arg_2_3, arg_2_1))
		end):fadeOut(0.8):done()
		performWithDelay(arg_2_0.stageTxt, function()
			transition.executeSequence(arg_2_0.stageTxt):func(function()
				arg_2_0.stageTxt:text(var_2_3(arg_2_4, arg_2_2))
			end):fadeIn(1):done()
		end, 1)
	end

	arg_2_0.stageTxt:scale(1.5)
end

function var_0_0.onCreate(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	audio.playEffectWithWeekBGM("pvp_win.mp3")

	arg_8_0.data = arg_8_2
	arg_8_0.results = arg_8_3

	local var_8_0 = arg_8_3.serverData.view
	local var_8_1 = var_8_0.rank
	local var_8_2 = var_8_1 + var_8_0.rank_move
	local var_8_3 = dataEasy.getCrossArenaStageByRank(var_8_2)
	local var_8_4 = dataEasy.getCrossArenaStageByRank(var_8_1)

	arg_8_0.stage:text(gLanguageCsv.crossArenaRankUPTo .. var_8_4.stageName)

	local var_8_5
	local var_8_6
	local var_8_7
	local var_8_8
	local var_8_9 = gGameModel.cross_arena:read("csvID")
	local var_8_10 = csv.cross.service[var_8_9].version

	for iter_8_0, iter_8_1 in ipairs(csv.cross.arena.stage) do
		if iter_8_1.version == var_8_10 then
			if var_8_4.stageName == iter_8_1.stageName then
				var_8_8 = iter_8_1.stageLevel
				var_8_6 = iter_8_1.stagePinyin
			end

			if var_8_3.stageName == iter_8_1.stageName then
				var_8_7 = iter_8_1.stageLevel
				var_8_5 = iter_8_1.stagePinyin
			end
		end
	end

	arg_8_0:playEffect(var_8_5, var_8_6)
	arg_8_0:playUPEffect(var_8_5, var_8_6, var_8_7, var_8_8)
end

function var_0_0.onCloseClick(arg_9_0)
	gGameUI:switchUI("city.view")
end

return var_0_0
