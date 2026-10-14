local var_0_0 = class("BattleEndDailyActivityView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "battle_end_daily_activity.json"
var_0_0.RESOURCE_BINDING = {
	score = "score",
	awardsList = "awardsList",
	progress = "progress",
	progressText = "progressText",
	progressImg = "progressImg",
	scoreText = "scoreText",
	["bkg.exitText"] = "exitText",
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

	arg_1_0.results = arg_1_2
	arg_1_0.data = arg_1_3

	local var_1_0 = arg_1_0:getResourceNode()

	arg_1_2 = arg_1_2 or {}

	local var_1_1 = (arg_1_2.serverData or {}).view or {}
	local var_1_2 = var_1_1.award or var_1_1.drop or {}
	local var_1_3 = arg_1_2.damage
	local var_1_4 = arg_1_2.hpMax
	local var_1_5 = csv.scene_conf[arg_1_1]
	local var_1_6 = widget.addAnimation(var_1_0, "effect/gongxihuode.skel", "effect", 100)

	var_1_6:anchorPoint(cc.p(0.5, 1)):scale(2):xy(display.cx, display.cy):play("jiesuan_shenglitu_new")
	var_1_6:addPlay("jiesuan_shenglitu_new_loop")

	arg_1_0.bestCardId = arg_1_0.data.roleOut[arg_1_0.results.mvpPosId].roleId

	local var_1_7 = csv.unit[arg_1_0.bestCardId].unitRes
	local var_1_8 = string.gsub(var_1_7, ".skel", "_ui.skel")
	local var_1_9 = CSprite.new(var_1_8)

	var_1_9:addTo(var_1_0, 100)
	var_1_9:setAnchorPoint(cc.p(0.5, 1))
	var_1_9:setPosition(display.cx / 4, -188)
	var_1_9:play("standby_loop")
	var_1_9:scale(2)
	arg_1_0.exitText:text(gLanguageCsv.click2Exit)
	var_1_0:get("pjText"):text(gLanguageCsv.battleEvaluation .. " :")

	if arg_1_2.socre then
		arg_1_0.scoreText:text(gLanguageCsv.battleScore .. " :")
	else
		arg_1_0.scoreText:text(gLanguageCsv.damageMade .. " :")
	end

	arg_1_0.score:text(math.floor(arg_1_2.socre or var_1_3 or 1))
	arg_1_0.progressText:text(gLanguageCsv.battleProgress .. " :")

	local var_1_10 = arg_1_2.percent

	if not var_1_10 then
		var_1_3 = var_1_3 or 0
		var_1_4 = var_1_4 or 1

		local var_1_11 = var_1_3 * 100 / var_1_4

		var_1_10 = var_1_11 - var_1_11 % 0.01
	end

	local var_1_12 = arg_1_0.progressImg

	if var_1_3 or var_1_4 then
		var_1_12:hide()
		arg_1_0.progress:text(var_1_10 .. "%")
	else
		local var_1_13 = arg_1_2.rankNode or 1
		local var_1_14 = ({
			"city/adventure/win/txt_b.png",
			"city/adventure/win/txt_a.png",
			"city/adventure/win/txt_s.png",
			"city/adventure/win/txt_ss.png",
			"city/adventure/win/txt_sss.png"
		})[var_1_13]

		var_1_12:loadTexture(var_1_14)

		if var_1_5.gateType == game.GATE_TYPE.dailyGold then
			arg_1_0.progress:text(var_1_10 .. "%")
		elseif var_1_5.gateType == game.GATE_TYPE.dailyExp then
			local var_1_15 = var_1_5.finishPoint.killNumber
			local var_1_16 = math.floor(var_1_10 / var_1_15 * 100)

			arg_1_0.progress:text(var_1_16 .. "%")
		end
	end

	adapt.oneLinePos(arg_1_0.scoreText, arg_1_0.score, cc.p(5, 0))
	adapt.oneLinePos(arg_1_0.progressText, {
		arg_1_0.progressImg,
		arg_1_0.progress
	}, cc.p(5, 0))
	var_1_0:get("awardsText"):text(gLanguageCsv.getAwards .. " :")

	if var_1_5.gateType == game.GATE_TYPE.crossMineBoss and var_1_1.score and var_1_1.score ~= 0 then
		local var_1_17 = var_1_0:get("awardsText")
		local var_1_18 = cc.Label:createWithTTF("", ui.FONT_PATH, 47):color(cc.c3b(91, 84, 91)):align(cc.p(0, 0.5), arg_1_0.progressText:x(), var_1_17:y()):addTo(var_1_0, 2, "mineGetText"):show():text(gLanguageCsv.crossMineBossScore)
		local var_1_19 = cc.Label:createWithTTF("", ui.FONT_PATH, 50):color(cc.c3b(238, 114, 14)):align(cc.p(0, 0.5), arg_1_0.score:x(), var_1_17:y()):addTo(var_1_0, 2, "mineScoreText"):show():text("+" .. var_1_1.score)

		adapt.oneLinePos(var_1_18, var_1_19, cc.p(16, 0))
	end

	local var_1_20 = dataEasy.isGateIdDoubleDrop(arg_1_1)

	if next(var_1_2) ~= nil then
		local var_1_21 = {}

		for iter_1_0, iter_1_1 in pairs(var_1_2) do
			table.insert(var_1_21, {
				key = iter_1_0,
				num = iter_1_1,
				isDouble = var_1_20
			})
		end

		arg_1_0:showItem(1, var_1_21)
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
	arg_2_0.awardsList:setItemsMargin(25)
	arg_2_0.awardsList:pushBackCustomItem(var_2_0)
	arg_2_0.awardsList:setScrollBarEnabled(false)
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
