local var_0_0 = class("BraveChallengeWinView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "battle_end_brave_challenge_win.json"
var_0_0.RESOURCE_BINDING = {
	awardsList = "awardsList",
	awardsItem = "awardsItem",
	bkg = {
		binds = {
			event = "click",
			method = bindHelper.self("onQuitClick")
		}
	},
	roundNums = {
		binds = {
			event = "extend",
			class = "text_atlas",
			props = {
				pathName = "frhd_num",
				isEqualDist = false,
				align = "center",
				data = bindHelper.self("roundNums")
			}
		}
	}
}

function var_0_0.playEndEffect(arg_1_0)
	local var_1_0 = arg_1_0:getResourceNode()
	local var_1_1 = CSprite.new("effect/gongxihuode.skel")

	var_1_1:addTo(var_1_0, 100)
	var_1_1:setAnchorPoint(cc.p(0.5, 1))
	var_1_1:setPosition(var_1_0:get("title"):getPosition())
	var_1_1:visible(true)
	var_1_1:play("jiesuan_shenglizi")
	var_1_1:addPlay("jiesuan_shenglizi_loop")
	var_1_1:retain()

	local var_1_2 = CSprite.new("effect/gongxihuode.skel")

	var_1_2:addTo(var_1_0, 99)
	var_1_2:setAnchorPoint(cc.p(0.5, 1))
	var_1_2:setPosition(var_1_0:get("title"):getPosition())
	var_1_2:visible(true)
	var_1_2:play("jiesuan_shenglitu")
	var_1_2:addPlay("jiesuan_shenglitu_loop")
	var_1_2:retain()
end

function var_0_0.onCreate(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	audio.playEffectWithWeekBGM("gate_win.mp3")

	arg_2_0.data = arg_2_2
	arg_2_0.results = arg_2_3
	arg_2_0.sceneID = arg_2_1

	local var_2_0 = arg_2_0:getResourceNode()
	local var_2_1 = arg_2_2.preData or {}

	if not var_2_1.roleInfo then
		local var_2_2 = {}
	end

	if not var_2_1.cardsInfo then
		local var_2_3 = {}
	end

	local var_2_4 = arg_2_3.serverData.view.drop or {}
	local var_2_5 = arg_2_3.serverData.view.award or {}
	local var_2_6 = arg_2_0.data.floorID
	local var_2_7 = csv.brave_challenge.floor[var_2_6].firstAward
	local var_2_8 = arg_2_3.serverData.view.first_pass
	local var_2_9 = {}

	for iter_2_0, iter_2_1 in pairs(var_2_4) do
		var_2_9[iter_2_0] = iter_2_1
	end

	for iter_2_2, iter_2_3 in pairs(var_2_5) do
		if not var_2_9[iter_2_2] then
			var_2_9[iter_2_2] = iter_2_3
		else
			var_2_9[iter_2_2] = var_2_9[iter_2_2] + iter_2_3
		end
	end

	local var_2_10 = csv.scene_conf[arg_2_1]

	if arg_2_3.round then
		var_2_0:get("round"):text(gLanguageCsv.round .. " :")

		arg_2_0.roundNums = arg_2_3.round
	else
		var_2_0:get("round"):visible(false)
	end

	arg_2_0:playEndEffect()

	local var_2_11 = var_2_0:get("awardsText")

	var_2_11:text(gLanguageCsv.getAwards .. " :")

	local var_2_12 = {}

	for iter_2_4, iter_2_5 in pairs(var_2_9) do
		local var_2_13 = battleEasy.ifElse(var_2_8, 1, table.length(var_2_12) + 1)

		table.insert(var_2_12, var_2_13, {
			key = iter_2_4,
			num = iter_2_5,
			isFirst = var_2_8
		})
	end

	if next(var_2_12) then
		arg_2_0:showItem(1, var_2_12)
	else
		local var_2_14, var_2_15 = var_2_11:xy()

		var_2_11:xy(var_2_14 + 325, var_2_15)
		var_2_11:text(gLanguageCsv.passAwardsAlreadyToplimit)
		arg_2_0.awardsList:hide()
	end
end

function var_0_0.showItem(arg_3_0, arg_3_1, arg_3_2)
	local function var_3_0(arg_4_0, arg_4_1)
		local var_4_0 = arg_4_0:size()
		local var_4_1 = cc.Sprite:create(arg_4_1):addTo(arg_4_0, 999):anchorPoint(1, 1):xy(var_4_0.width, var_4_0.height)
	end

	local var_3_1 = arg_3_0.awardsItem:clone()

	var_3_1:show()

	local var_3_2 = arg_3_2[arg_3_1].key
	local var_3_3 = arg_3_2[arg_3_1].num
	local var_3_4 = {
		class = "icon_key",
		props = {
			data = {
				key = var_3_2,
				num = var_3_3
			},
			isDouble = dataEasy.isGateIdDoubleDrop(arg_3_0.sceneID),
			onNode = function(arg_5_0)
				local var_5_0, var_5_1 = arg_5_0:xy()

				arg_5_0:xy(var_5_0, var_5_1 + 3)
				arg_5_0:hide():z(2)
				transition.executeSequence(arg_5_0, true):delay(0.5):func(function()
					arg_5_0:show()
				end):done()

				if arg_3_2[arg_3_1].isFirst then
					var_3_0(arg_5_0, "city/adventure/endless_tower/icon_st.png")
				end
			end
		}
	}

	bind.extend(arg_3_0, var_3_1, var_3_4)
	arg_3_0.awardsList:setItemsMargin(25)
	arg_3_0.awardsList:pushBackCustomItem(var_3_1)
	arg_3_0.awardsList:setScrollBarEnabled(false)
	transition.executeSequence(arg_3_0.awardsList):delay(0.1):func(function()
		if arg_3_1 < table.length(arg_3_2) then
			arg_3_0:showItem(arg_3_1 + 1, arg_3_2)
		end
	end):done()
end

function var_0_0.onQuitClick(arg_8_0)
	gGameUI:switchUI("city.view")
end

return var_0_0
