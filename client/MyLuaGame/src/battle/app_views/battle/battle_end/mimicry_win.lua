local var_0_0 = class("BattleEndMimicryView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "battle_end_mimicry_win.json"
var_0_0.RESOURCE_BINDING = {
	scoreNum = "scoreNum",
	awardsList = "awardsList",
	pjNum = "pjNum",
	newBuffText = "newBuffText",
	["bkg.exitText"] = "exitText",
	cardItem = "awardsItem",
	bkg = {
		binds = {
			event = "click",
			method = bindHelper.self("onPanelClick")
		}
	}
}

function var_0_0.onCreate(arg_1_0, arg_1_1, arg_1_2)
	audio.playEffectWithWeekBGM("pve_win.mp3")

	arg_1_0.results = arg_1_2

	local var_1_0 = arg_1_0:getResourceNode()

	arg_1_2 = arg_1_2 or {}

	local var_1_1 = (arg_1_2.serverData or {}).view or {}

	if not var_1_1.award and not var_1_1.drop then
		local var_1_2 = {}
	end

	widget.addAnimation(var_1_0, "level/newzhandoushengli.skel", "effect2", 100):anchorPoint(cc.p(0.5, 0.5)):xy(var_1_0:get("title"):getPosition()):addPlay("effect2_loop")
	arg_1_0.exitText:text(gLanguageCsv.click2Exit)

	local var_1_3 = rich.createByStr(string.format(gLanguageCsv.mimicryEndScore, var_1_1.boss_scores + var_1_1.buff_scores, var_1_1.boss_scores, var_1_1.buff_scores), 50):anchorPoint(0, 0.5):xy(arg_1_0.scoreNum:x(), arg_1_0.scoreNum:y()):addTo(arg_1_0.scoreNum:parent()):z(10)

	arg_1_0.pjNum:setString(arg_1_2.finalDamage)
	arg_1_0.awardsList:setItemsMargin(25)
	arg_1_0.awardsList:setScrollBarEnabled(false)

	if next(arg_1_2.serverData.view.drop) ~= nil then
		local var_1_4 = {}

		for iter_1_0, iter_1_1 in pairs(var_1_1.drop) do
			table.insert(var_1_4, {
				key = iter_1_0,
				num = iter_1_1
			})
		end

		arg_1_0:showItem(1, var_1_4)
	end

	if var_1_1.new_buff then
		arg_1_0.newBuffText:setString(gLanguageCsv.mimicryEndNewBuff)
	end
end

function var_0_0.showItem(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_0.awardsItem:clone()

	var_2_0:show()

	local var_2_1 = arg_2_2[arg_2_1].key
	local var_2_2 = arg_2_2[arg_2_1].num
	local var_2_3 = arg_2_2[arg_2_1].isDouble
	local var_2_4 = {
		class = "icon_key",
		props = {
			data = {
				key = var_2_1,
				num = var_2_2
			},
			isDouble = var_2_3,
			onNode = function(arg_3_0)
				local var_3_0, var_3_1 = arg_3_0:xy()

				arg_3_0:xy(var_3_0, var_3_1 + 3)
				arg_3_0:hide():z(2)
				transition.executeSequence(arg_3_0, true):delay(0.5):func(function()
					arg_3_0:show()
				end):done()
			end
		}
	}

	bind.extend(arg_2_0, var_2_0, var_2_4)
	arg_2_0.awardsList:pushBackCustomItem(var_2_0)
	transition.executeSequence(arg_2_0.awardsList, true):delay(0.25):func(function()
		if arg_2_1 < csvSize(arg_2_2) then
			arg_2_0:showItem(arg_2_1 + 1, arg_2_2)
		end
	end):done()
end

function var_0_0.onPanelClick(arg_6_0)
	gGameUI:switchUI("city.view")
end

return var_0_0
