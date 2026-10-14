local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("SkyScraperGameOver", var_0_0)

var_0_1.RESOURCE_FILENAME = "sky_scraper_game_over.json"
var_0_1.RESOURCE_BINDING = {
	["awardBg.awardText"] = "scoreText",
	awardList = "awardList",
	["awardBg.awardNewText"] = "awardNewText",
	item = "item",
	["awardBg.awardNewImg"] = "awardNewImg",
	imgOver = "imgOver",
	awardText = "awardText",
	awardBg = "awardBg",
	barPanel = "barPanel",
	["barPanel.maxText"] = "maxText",
	["barPanel.curImg"] = "curImg",
	["bkg.exitText"] = "exitText",
	pjText = "pjText",
	bkg = {
		binds = {
			event = "click",
			method = bindHelper.self("onPanelClick")
		}
	},
	["barPanel.bar"] = {
		varname = "progressBar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				data = bindHelper.self("curPagePro")
			}
		}
	}
}

function var_0_1.onCreate(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)
	arg_1_0.closeCb = arg_1_1
	arg_1_0.activityId = arg_1_2
	arg_1_0.floor = arg_1_4

	arg_1_0:initModel()
	audio.playEffectWithWeekBGM("pve_win.mp3")

	local var_1_0 = arg_1_7.view.result or {}

	arg_1_0.showdata:update(var_1_0)
	uiEasy.createItemsToList(arg_1_0, arg_1_0.awardList, var_1_0, {
		onAfterBuild = function()
			arg_1_0.awardList:setItemAlignCenter()
		end
	})
	arg_1_0.curImg:get("txt"):text(arg_1_4)
	arg_1_0.pjText:text(string.format(gLanguageCsv.skyScraperGameOverScore, arg_1_4))
	arg_1_0.awardText:text(string.format(gLanguageCsv.skyScraperGameOverAward, arg_1_6))
	arg_1_0.scoreText:setString(arg_1_3)
	arg_1_0.awardNewImg:setVisible(arg_1_5)
	arg_1_0.awardNewText:setVisible(arg_1_5)
end

function var_0_1.initModel(arg_3_0)
	arg_3_0.curPagePro = idler.new(0)
	arg_3_0.showdata = idlers.newWithMap({})

	local var_3_0 = (csv.yunying.yyhuodong[arg_3_0.activityId].paramMap or {}).maxFloor

	arg_3_0.maxText:text(var_3_0)
	arg_3_0.curPagePro:set(arg_3_0.floor / var_3_0 * 100)
	arg_3_0.curImg:x(arg_3_0.curImg:x() + arg_3_0.floor / var_3_0 * 830)

	if arg_3_0.floor == var_3_0 then
		widget.addAnimation(arg_3_0.imgOver, "level/newzhandoushengli.skel", "effect4", 100):anchorPoint(cc.p(0.5, 0.5)):xy(290, -410):addPlay("effect4_loop")
		arg_3_0.curImg:get("txt"):visible(false)
	else
		widget.addAnimation(arg_3_0.imgOver, "level/newzhandoushengli.skel", "effect3", 100):anchorPoint(cc.p(0.5, 0.5)):xy(290, -410):addPlay("effect3_loop")
	end
end

function var_0_1.onPanelClick(arg_4_0)
	arg_4_0.closeCb()
end

return var_0_1
