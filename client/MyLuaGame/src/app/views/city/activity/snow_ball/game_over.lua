local var_0_0 = class("SnowballGameOver", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "snow_ball_game_over.json"
var_0_0.RESOURCE_BINDING = {
	["awardBg.awardText"] = "awardText",
	["awardBg.awardNewImg"] = "awardNewImg",
	["awardBg.awardNewText"] = "awardNewText",
	["bkg.exitText"] = "exitText",
	awardBg = "awardBg",
	bkg = {
		binds = {
			event = "click",
			method = bindHelper.self("onPanelClick")
		}
	}
}

function var_0_0.onCreate(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0.parent = arg_1_1

	audio.playEffectWithWeekBGM("pve_win.mp3")

	local var_1_0 = arg_1_0:getResourceNode()

	widget.addAnimation(var_1_0, "level/newzhandoushengli.skel", "effect3", 100):anchorPoint(cc.p(0.5, 0.5)):xy(var_1_0:get("title"):getPosition()):addPlay("effect3_loop")
	arg_1_0.awardText:setString(arg_1_2)

	if arg_1_4 == 0 then
		arg_1_0.awardNewImg:setVisible(false)
		arg_1_0.awardNewText:text(gLanguageCsv.snowBallGuideTips):show()
	else
		arg_1_0.awardNewImg:setVisible(arg_1_3)
		arg_1_0.awardNewText:setVisible(arg_1_3)
	end
end

function var_0_0.onPanelClick(arg_2_0)
	arg_2_0.parent:onClose()
end

return var_0_0
