local var_0_0 = class("BattleEndlessWinView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "battle_end_endless_win.json"
var_0_0.RESOURCE_BINDING = {
	["cardItem.card"] = "awardsItem",
	di = "di",
	guan = "guan",
	awardsList = "awardsList",
	gateNum = "gateNum",
	backBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBackBtnClick")
			}
		}
	},
	againBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAgainBtnClick")
			}
		}
	},
	dungeonsBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDungeonsBtnClick")
			}
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

function var_0_0.onCreate(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	audio.playEffectWithWeekBGM("gate_win.mp3")

	arg_2_0.data = arg_2_2
	arg_2_0.results = arg_2_3

	local var_2_0 = arg_2_0:getResourceNode()
	local var_2_1 = {
		backBtn = "back2City",
		againBtn = "nextGate",
		dungeonsBtn = "dungeonList"
	}

	for iter_2_0, iter_2_1 in pairs(var_2_1) do
		var_2_0:get(iter_2_0 .. ".text"):text(gLanguageCsv[iter_2_1])
	end

	arg_2_3 = arg_2_3 or {}

	local var_2_2 = arg_2_3.serverData or {}
	local var_2_3 = arg_2_2.preData or {}

	if not var_2_3.roleInfo then
		local var_2_4 = {}
	end

	if not var_2_3.cardsInfo then
		local var_2_5 = {}
	end

	local var_2_6 = var_2_2.view.drop or {}

	arg_2_0.gateIdx = arg_2_3.gateIdx or 1

	arg_2_0:playEndEffect()
	var_2_0:get("curGate"):text(gLanguageCsv.curEndlessGateIdx .. " :")
	var_2_0:get("gateNum"):text(arg_2_0.gateIdx)
	var_2_0:get("awardsText"):text(gLanguageCsv.getAwards .. " :")

	local var_2_7 = dataEasy.isGateIdDoubleDrop(arg_2_1)

	if arg_2_2.preData.isFirst then
		var_2_7 = false
	end

	if next(var_2_6) ~= nil then
		local var_2_8 = {}

		for iter_2_2, iter_2_3 in csvMapPairs(var_2_6) do
			table.insert(var_2_8, {
				key = iter_2_2,
				num = iter_2_3,
				isDouble = var_2_7
			})
		end

		arg_2_0:showItem(1, var_2_8)
	end

	adapt.oneLinePos(arg_2_0.di, {
		arg_2_0.gateNum,
		arg_2_0.guan
	}, {
		cc.p(5, 0),
		cc.p(5, 0)
	})
end

function var_0_0.showItem(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0.awardsItem:clone()

	var_3_0:show()

	local var_3_1 = arg_3_2[arg_3_1].key
	local var_3_2 = arg_3_2[arg_3_1].num
	local var_3_3 = arg_3_2[arg_3_1].isDouble
	local var_3_4 = {
		class = "icon_key",
		props = {
			data = {
				key = var_3_1,
				num = var_3_2
			},
			isDouble = var_3_3,
			onNode = function(arg_4_0)
				local var_4_0, var_4_1 = arg_4_0:xy()

				arg_4_0:xy(var_4_0, var_4_1 + 3)
				arg_4_0:hide():z(2)
				transition.executeSequence(arg_4_0, true):delay(0.5):func(function()
					arg_4_0:show()
				end):done()
			end
		}
	}

	bind.extend(arg_3_0, var_3_0, var_3_4)
	arg_3_0.awardsList:setItemsMargin(25)
	arg_3_0.awardsList:pushBackCustomItem(var_3_0)
	arg_3_0.awardsList:setScrollBarEnabled(false)
	transition.executeSequence(arg_3_0.awardsList, true):delay(0.25):func(function()
		if arg_3_1 < csvSize(arg_3_2) then
			arg_3_0:showItem(arg_3_1 + 1, arg_3_2)
		end
	end):done()
end

function var_0_0.onBackBtnClick(arg_7_0)
	gGameUI:cleanStash()
	gGameUI:switchUI("city.view")
end

function var_0_0.onAgainBtnClick(arg_8_0)
	local var_8_0 = csvSize(csv.endless_tower_scene)
	local var_8_1 = arg_8_0.gateIdx + 1

	if var_8_0 <= arg_8_0.gateIdx then
		arg_8_0:onDungeonsBtnClick()
		gGameUI:showTip(gLanguageCsv.allCheckpointscleared)
	else
		local var_8_2 = gGameUI:switchUI("city.view")

		gGameUI:sendMessage("nextGate", var_8_1)
	end
end

function var_0_0.onDungeonsBtnClick(arg_9_0)
	gGameUI:switchUI("city.view")
end

return var_0_0
