local var_0_0 = class("BattleEndWorldBossView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "battle_end_world_boss_win.json"
var_0_0.RESOURCE_BINDING = {
	["awardBg.awardText"] = "awardText",
	awardBg = "awardBg",
	["awardBg.awardNewText"] = "awardNewText",
	["awardBg.awardNewImg"] = "awardNewImg",
	["bkg.exitText"] = "exitText",
	awardsList = "awardsList",
	cardItem = "awardsItem",
	bkg = {
		binds = {
			event = "click",
			method = bindHelper.self("onPanelClick")
		}
	}
}

function var_0_0.onCreate(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	audio.playEffectWithWeekBGM("pve_win.mp3")

	local var_1_0 = arg_1_0:getResourceNode()

	arg_1_0.data = arg_1_2
	arg_1_0.results = arg_1_3

	local var_1_1 = arg_1_0:getResourceNode()

	if not arg_1_2.preData then
		local var_1_2 = {}
	end

	local var_1_3 = widget.addAnimation(var_1_1, "effect/gongxihuode.skel", "effect", 100)

	var_1_3:anchorPoint(cc.p(0.5, 1)):scale(2):xy(display.cx, display.cy):play("jiesuan_shenglitu_new")
	var_1_3:addPlay("jiesuan_shenglitu_new_loop")

	arg_1_0.bestCardId = arg_1_2.roleOut[arg_1_0.results.mvpPosId].roleId

	local var_1_4 = csv.unit[arg_1_0.bestCardId].unitRes
	local var_1_5 = string.gsub(var_1_4, ".skel", "_ui.skel")
	local var_1_6 = CSprite.new(var_1_5)

	var_1_6:addTo(var_1_1, 100)
	var_1_6:setAnchorPoint(cc.p(0.5, 1))
	var_1_6:setPosition(display.cx / 4, -188)
	var_1_6:play("standby_loop")
	var_1_6:scale(2)
	arg_1_0.exitText:text(gLanguageCsv.click2Exit)
	arg_1_0.awardText:setString(arg_1_3.damage)
	arg_1_0.awardsList:setItemsMargin(25)
	arg_1_0.awardsList:setScrollBarEnabled(false)

	if next(arg_1_3.award) ~= nil then
		local var_1_7 = {}

		for iter_1_0, iter_1_1 in pairs(arg_1_3.award) do
			table.insert(var_1_7, {
				key = iter_1_0,
				num = iter_1_1
			})
		end

		arg_1_0:showItem(1, var_1_7)
	end

	arg_1_0.awardNewImg:setVisible(arg_1_3.isNewRecordDamage)
	arg_1_0.awardNewText:setVisible(arg_1_3.isNewRecordDamage)

	if arg_1_3.isNewRecordDamage then
		arg_1_0.awardNewText:setString(gLanguageCsv.worldBossDamageMaxTip)
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
