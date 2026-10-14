local var_0_0 = class("BattleEndRandomWinView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "battle_end_random_win.json"
var_0_0.RESOURCE_BINDING = {
	text2 = "text2",
	["cardItem.card"] = "awardsItem",
	awardsList = "awardsList",
	["backBtn.text"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["againBtn.text"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["dungeonsBtn.text"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	bkg = {
		binds = {
			event = "click",
			method = bindHelper.self("onDungeonsBtnClick")
		}
	}
}

function var_0_0.playEndEffect(arg_1_0)
	local var_1_0 = arg_1_0.data
	local var_1_1 = arg_1_0:getResourceNode()

	if not var_1_0.preData then
		local var_1_2 = {}
	end

	local var_1_3 = widget.addAnimation(var_1_1, "effect/gongxihuode.skel", "effect", 100)

	var_1_3:anchorPoint(cc.p(0.5, 1)):scale(2):xy(display.cx, display.cy):play("jiesuan_shenglitu_new")
	var_1_3:addPlay("jiesuan_shenglitu_new_loop")

	arg_1_0.bestCardId = var_1_0.roleOut[arg_1_0.results.mvpPosId].roleId

	local var_1_4 = csv.unit[arg_1_0.bestCardId].unitRes
	local var_1_5 = string.gsub(var_1_4, ".skel", "_ui.skel")
	local var_1_6 = CSprite.new(var_1_5)

	var_1_6:addTo(var_1_1, 100)
	var_1_6:setAnchorPoint(cc.p(0.5, 1))
	var_1_6:setPosition(display.cx / 4, -188)
	var_1_6:play("standby_loop")
	var_1_6:scale(2)
end

function var_0_0.onCreate(arg_2_0, arg_2_1, arg_2_2)
	audio.playEffectWithWeekBGM("gate_win.mp3")

	arg_2_0.battleView = arg_2_1
	arg_2_0.data = arg_2_1.data
	arg_2_0.sceneID = arg_2_1.sceneID
	arg_2_0.results = arg_2_2

	if matchLanguage({
		"en"
	}) then
		arg_2_0.text2:ignoreContentAdaptWithSize(false)
		arg_2_0.text2:setContentSize(cc.size(450, 200))
		arg_2_0.text2:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		arg_2_0.text2:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
		arg_2_0.text2:y(arg_2_0.text2:y() - 22)
	end

	local var_2_0 = arg_2_0:getResourceNode()
	local var_2_1 = {
		backBtn = "back2City",
		againBtn = "playAgain",
		dungeonsBtn = "dungeonList"
	}

	for iter_2_0, iter_2_1 in pairs(var_2_1) do
		var_2_0:get(iter_2_0 .. ".text"):text(gLanguageCsv[iter_2_1])
	end

	arg_2_0:showPlayerScoreInfo()
	arg_2_0:playEndEffect()
	arg_2_0:showStarsInfo()
	arg_2_0:showCardStateInfo()
	arg_2_0:showItemInfo()
end

function var_0_0.showPlayerScoreInfo(arg_3_0)
	local var_3_0 = arg_3_0.sceneID
	local var_3_1 = arg_3_0:getResourceNode()
	local var_3_2 = (arg_3_0.results.serverData or {}).point
	local var_3_3 = var_3_2 >= 0 and "+" or "-"
	local var_3_4 = var_3_1:multiget("score", "levelTextNote", "levelTextExtre")

	var_3_4.score:text(var_3_3 .. tostring(var_3_2))
	adapt.oneLinePos(var_3_4.levelTextNote, {
		var_3_4.score,
		var_3_4.levelTextExtre
	}, cc.p(10, 0))
end

function var_0_0.showStarsInfo(arg_4_0)
	local var_4_0 = arg_4_0:getResourceNode()
	local var_4_1 = arg_4_0.results
	local var_4_2 = var_4_1.conditionTb
	local var_4_3 = var_4_1.gateStarTb

	if var_4_2 and var_4_3 then
		for iter_4_0 = 1, 3 do
			local var_4_4 = var_4_2[iter_4_0][1]
			local var_4_5 = var_4_2[iter_4_0][2]
			local var_4_6 = var_4_3[iter_4_0][1]
			local var_4_7 = var_4_0:get("text" .. iter_4_0)

			var_4_7:text(string.format(gLanguageCsv["starCondition" .. var_4_4], var_4_5))
			text.addEffect(var_4_7, {
				color = ui.NEWCOLORS.GREEN2
			})

			if not var_4_6 then
				text.addEffect(var_4_7, {
					color = ui.NEWCOLORS.REDLIGHT
				})
			end

			var_4_0:get("star" .. iter_4_0 .. ".achieve"):setVisible(var_4_6)
		end
	end
end

function var_0_0.showCardStateInfo(arg_5_0)
	local var_5_0 = arg_5_0.results
	local var_5_1 = arg_5_0:getResourceNode()
	local var_5_2 = var_5_0.cardStates or {}
	local var_5_3 = arg_5_0.data.roleOut or {}
	local var_5_4 = var_5_1:get("cardsList")

	var_5_4:setScrollBarEnabled(false)
	var_5_4:setItemsMargin(25)

	for iter_5_0, iter_5_1 in pairs(var_5_3) do
		if iter_5_0 <= 6 then
			local var_5_5 = var_5_1:get("cardItem"):clone()

			var_5_4:pushBackCustomItem(var_5_5)
			bind.extend(arg_5_0, var_5_5:get("card"), {
				class = "card_icon",
				props = {
					unitId = iter_5_1.roleId,
					advance = iter_5_1.advance,
					star = iter_5_1.star,
					rarity = csv.unit[iter_5_1.roleId].rarity
				}
			})

			local var_5_6 = var_5_2[iter_5_1.cardId]

			if var_5_6 then
				var_5_5:get("hpBar"):setPercent(math.floor(var_5_6[1] * 100))
				var_5_5:get("mpBar"):setPercent(math.floor(var_5_6[2] * 100))
				var_5_5:get("mask"):visible(var_5_6[1] <= 0)
			end
		end
	end
end

function var_0_0.showItemInfo(arg_6_0)
	local var_6_0 = arg_6_0:getResourceNode()
	local var_6_1 = (arg_6_0.results.serverData or {}).award or {}
	local var_6_2 = {}

	local function var_6_3(arg_7_0)
		if next(arg_7_0) then
			for iter_7_0, iter_7_1 in csvMapPairs(arg_7_0) do
				local var_7_0 = {
					key = iter_7_0,
					num = iter_7_1
				}

				table.insert(var_6_2, var_7_0)
			end
		end
	end

	if next(var_6_1) ~= nil then
		var_6_3(var_6_1)
	end
end

function var_0_0.showItem(arg_8_0, arg_8_1, arg_8_2)
	local function var_8_0(arg_9_0, arg_9_1)
		local var_9_0 = arg_9_0:size()
		local var_9_1 = cc.Sprite:create(arg_9_1):addTo(arg_9_0, 999):anchorPoint(1, 1):xy(var_9_0.width, var_9_0.height)
	end

	local var_8_1 = arg_8_0.awardsItem:clone()

	var_8_1:show()

	local var_8_2 = arg_8_2[arg_8_1]
	local var_8_3 = {
		class = "icon_key",
		props = {
			data = {
				key = var_8_2.key,
				num = var_8_2.num
			},
			onNode = function(arg_10_0)
				local var_10_0, var_10_1 = arg_10_0:xy()

				arg_10_0:xy(var_10_0, var_10_1 + 3)
				arg_10_0:hide():z(2)
				transition.executeSequence(arg_10_0, true):delay(0.5):func(function()
					arg_10_0:show()
				end):done()
			end
		}
	}

	bind.extend(arg_8_0, var_8_1, var_8_3)
	arg_8_0.awardsList:setItemsMargin(25)
	arg_8_0.awardsList:pushBackCustomItem(var_8_1)
	arg_8_0.awardsList:setScrollBarEnabled(false)
	transition.executeSequence(arg_8_0.awardsList):delay(0.1):func(function()
		if arg_8_1 < table.length(arg_8_2) then
			arg_8_0:showItem(arg_8_1 + 1, arg_8_2)
		end
	end):done()
end

function var_0_0.onBackBtnClick(arg_13_0)
	gGameUI:switchUI("city.view")
end

function var_0_0.onAgainBtnClick(arg_14_0)
	arg_14_0.battleView.entrance:restart()
end

function var_0_0.onDungeonsBtnClick(arg_15_0)
	gGameUI:switchUI("city.view")
end

return var_0_0
