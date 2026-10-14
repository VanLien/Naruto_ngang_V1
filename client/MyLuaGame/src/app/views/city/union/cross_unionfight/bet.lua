local var_0_0 = {
	hide = 3,
	showIcon = 1,
	showPanel = 2
}
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("BetView", var_0_1)

var_0_2.RESOURCE_FILENAME = "cross_union_fight_bet.json"
var_0_2.RESOURCE_BINDING = {
	["rightPanel.txt1"] = "txt1",
	["leftPanel.leftItem"] = "leftItem",
	item = "item",
	["leftPanel.text2"] = "text2",
	["rightPanel.topPanel.unionIcon"] = "unionIcon",
	rightPanel = "rightPanel",
	["rightPanel.topPanel.stateTxt"] = "topStateTxt",
	["leftPanel.text1"] = "text1",
	["rightPanel.topPanel.unionName"] = "unionName",
	["leftPanel.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("leftDatas"),
				item = bindHelper.self("leftItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("normal")
					local var_1_1 = arg_1_1:get("select")
					local var_1_2

					if arg_1_3.select then
						var_1_0:hide()

						var_1_2 = var_1_1:show()
					else
						var_1_1:hide()

						var_1_2 = var_1_0:show()

						var_1_2:get("subTxt"):text(arg_1_3.subName)
					end

					var_1_2:get("txt"):text(arg_1_3.name)
					var_1_1:setTouchEnabled(false)
					bind.touch(arg_1_0, var_1_0, {
						methods = {
							ended = functools.partial(arg_1_0.cellClick, arg_1_2, arg_1_3.name)
						}
					})

					if arg_1_3.lock then
						uiEasy.updateUnlockRes(nil, var_1_0, {
							pos = cc.p(290, 120)
						})
					end
				end
			},
			handlers = {
				cellClick = bindHelper.self("onLeftItemClick")
			}
		}
	},
	["leftPanel.textTime"] = {
		binds = {
			event = "effect",
			data = {
				color = cc.c4b(107, 238, 107, 255),
				outline = {
					size = 3,
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["rightPanel.ruleBtn"] = {
		varname = "ruleBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleBtnClick")
			}
		}
	},
	["rightPanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("showData"),
				showTab = bindHelper.self("showTab"),
				item = bindHelper.self("item"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("unionIcon", "unionName", "serverKey", "fightingPoint", "panel", "iconBg", "bg", "line")

					var_2_0.iconBg:hide()
					var_2_0.panel:show()

					if arg_2_3.bet == var_0_0.showIcon then
						var_2_0.iconBg:show()
						var_2_0.panel:hide()
					elseif arg_2_3.bet == var_0_0.hide then
						var_2_0.iconBg:hide()
						var_2_0.panel:hide()
					else
						var_2_0.iconBg:hide()
						var_2_0.panel:show()
					end

					var_2_0.panel:get("costNum"):text(arg_2_3.cost[1].num)
					var_2_0.unionName:text(arg_2_3.union_name)
					var_2_0.serverKey:text(getServerArea(arg_2_3.server_key, false))
					var_2_0.fightingPoint:text(arg_2_3.fighting_point)
					cache.setShader(var_2_0.panel:get("btn"), false, arg_2_3.grayData and "hsl_gray" or "normal")
					bind.touch(arg_2_0, var_2_0.panel:get("btn"), {
						methods = {
							ended = functools.partial(arg_2_0.clickGuess, arg_2_3.union_db_id)
						}
					})
					adapt.oneLineCenterPos(cc.p(var_2_0.panel:get("btn"):x(), var_2_0.panel:get("btn"):y() + 80), {
						var_2_0.panel:get("icon"),
						var_2_0.panel:get("costNum")
					}, cc.p(10, 0))
					var_2_0.unionIcon:texture(csv.union.union_logo[arg_2_3.union_logo].icon)

					if arg_2_2 % 2 == 0 then
						var_2_0.bg:color(cc.c4b(255, 252, 237, 128))
					else
						var_2_0.bg:color(cc.c4b(238, 231, 215, 153))
					end

					if arg_2_2 >= 4 then
						var_2_0.line:hide()
					end
				end
			},
			handlers = {
				clickGuess = bindHelper.self("onGuessBtnClick")
			}
		}
	}
}

function var_0_2.onCreate(arg_3_0, arg_3_1, arg_3_2)
	gGameUI.topuiManager:createView("union", arg_3_0, {
		onClose = arg_3_0:createHandler("onClose")
	}):init({
		subTitle = "BET",
		title = gLanguageCsv.guess
	})

	arg_3_0.data = arg_3_1
	arg_3_0.rankData = arg_3_2
	arg_3_0.originBet = arg_3_1.bets
	arg_3_0.betData = {}

	arg_3_0:initModel()
	arg_3_0.item:hide()
	arg_3_0.leftItem:hide()

	arg_3_0.showTab = idler.new(1)
	arg_3_0.showData = idlertable.new({})

	arg_3_0:handleBetData()

	arg_3_0.grayData = false
	arg_3_0.leftDatas = idlers.newWithMap({
		{
			subName = "Eastern",
			name = gLanguageCsv.easternConstructionGroup
		},
		{
			subName = "Western",
			name = gLanguageCsv.westernConstructionGroup
		},
		{
			subName = "Southern",
			name = gLanguageCsv.southernConstructionGroup
		},
		{
			subName = "Northern ",
			name = gLanguageCsv.northernConstructionGroup
		},
		{
			lock = true,
			subName = "FinalMatch",
			name = gLanguageCsv.finalMatch
		}
	})

	arg_3_0.showTab:addListener(function(arg_4_0, arg_4_1)
		arg_3_0.leftDatas:atproxy(arg_4_1).select = false
		arg_3_0.leftDatas:atproxy(arg_4_0).select = true

		arg_3_0:handleBetData()
		arg_3_0:refreshTopIcon()
		arg_3_0:setButtonStatus(arg_3_0.status:read(), arg_4_0)
	end)
	idlereasy.when(arg_3_0.status, function(arg_5_0, arg_5_1)
		local var_5_0 = userDefault.getForeverLocalKey("crossUnionFightShowed", {})

		if arg_5_1 == "start" or arg_5_1 == "prePrapare" or arg_5_1 == "preStart" or arg_5_1 == "preBattle" or arg_5_1 == "preOver" or arg_5_1 == "preAward" then
			arg_3_0.leftDatas:atproxy(5).lock = true
		elseif arg_5_1 == "topPrepare" or arg_5_1 == "topStart" or arg_5_1 == "topBattle" or arg_5_1 == "topOver" or arg_5_1 == "closed" then
			arg_3_0.leftDatas:atproxy(5).lock = false
		end

		local function var_5_1(arg_6_0)
			return (arg_6_0 == "preAward" or arg_6_0 == "topPrepare" or arg_6_0 == "topStart" or arg_6_0 == "topBattle" or arg_6_0 == "topOver" or arg_6_0 == "closed") and true or false
		end

		arg_3_0:handleBetData()

		if not itertools.isempty(var_5_0) and itertools.size(arg_3_0.bet) > 0 and tonumber(time.getTodayStr()) - var_5_0.time < 28 then
			if var_5_0.type == 1 and var_5_1(arg_5_1) then
				userDefault.setForeverLocalKey("crossUnionFightShowed", {})
				gGameUI:stackUI("city.union.cross_unionfight.bet_result", nil, nil, arg_3_0.bet, var_5_0.type + 3)
			elseif var_5_0.type == 2 and arg_5_1 == "closed" then
				userDefault.setForeverLocalKey("crossUnionFightShowed", {})
				gGameUI:stackUI("city.union.cross_unionfight.bet_result", nil, nil, arg_3_0.bet, var_5_0.type + 3)
			end
		end

		arg_3_0:setButtonStatus(arg_5_1, arg_3_0.showTab:read())
	end)
	arg_3_0.text1:text(gLanguageCsv.crossUnionFightBetTips1)
	arg_3_0.text2:text(gLanguageCsv.crossUnionFightBetTips2)
	arg_3_0:addTabListClipping()
end

function var_0_2.setButtonStatus(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = time.getTime()
	local var_7_1 = time.getNumTimestamp(tonumber(time.getTodayStr()), 9, 0)

	if arg_7_1 == "prePrepare" and var_7_1 < var_7_0 then
		arg_7_0.grayData = false
	elseif arg_7_1 == "topPrepare" and arg_7_2 == 5 then
		arg_7_0.grayData = false
	else
		arg_7_0.grayData = true
	end

	if arg_7_2 == 5 then
		for iter_7_0, iter_7_1 in pairs(arg_7_0.topData) do
			iter_7_1.grayData = arg_7_0.grayData
		end

		arg_7_0.showData:set(arg_7_0.topData, true)
	else
		for iter_7_2, iter_7_3 in pairs(arg_7_0.preData[arg_7_2]) do
			iter_7_3.grayData = arg_7_0.grayData
		end

		arg_7_0.showData:set(arg_7_0.preData[arg_7_2], true)
	end
end

function var_0_2.refreshTopIcon(arg_8_0)
	local var_8_0 = arg_8_0.showTab:read() == 5 and arg_8_0.topData or arg_8_0.preData[arg_8_0.showTab:read()]
	local var_8_1

	for iter_8_0, iter_8_1 in ipairs(var_8_0) do
		if iter_8_1.bet == var_0_0.showIcon then
			var_8_1 = iter_8_1

			arg_8_0.unionIcon:show()
			arg_8_0.unionIcon:texture(csv.union.union_logo[iter_8_1.union_logo].icon)
			arg_8_0.topStateTxt:text(gLanguageCsv.beted)
			arg_8_0.unionName:text(iter_8_1.union_name)
			text.addEffect(arg_8_0.topStateTxt, {
				color = cc.c4b(74, 148, 205, 255)
			})

			break
		end

		arg_8_0.unionIcon:hide()
		text.addEffect(arg_8_0.topStateTxt, {
			color = cc.c4b(151, 143, 137, 255)
		})
		arg_8_0.unionName:text("")
		arg_8_0.topStateTxt:text(gLanguageCsv.notBet)
	end

	if arg_8_0.rankData and arg_8_0.rankData.last_ranks then
		local var_8_2 = arg_8_0.rankData.last_ranks[arg_8_0.showTab:read()]

		if var_8_2 and var_8_1 and var_8_2[1] then
			if var_8_2[1].union_db_id == var_8_1.union_db_id then
				arg_8_0.topStateTxt:text(gLanguageCsv.betSuccess)
				text.addEffect(arg_8_0.topStateTxt, {
					color = cc.c4b(255, 125, 29, 255)
				})
			else
				arg_8_0.topStateTxt:text(gLanguageCsv.betFail)
				text.addEffect(arg_8_0.topStateTxt, {
					color = cc.c4b(113, 119, 153, 255)
				})
			end

			arg_8_0.unionIcon:texture(csv.union.union_logo[var_8_2[1].union_logo].icon)
			arg_8_0.unionName:text(var_8_2[1].union_name)
		end
	end
end

function var_0_2.handleBetData(arg_9_0)
	local var_9_0 = arg_9_0.showTab:read() == 5 and arg_9_0.topData or arg_9_0.preData[arg_9_0.showTab:read()] or {}

	for iter_9_0, iter_9_1 in ipairs(var_9_0) do
		iter_9_1.cost = arg_9_0.showTab:read() == 5 and dataEasy.getItemData(csv.cross.union_fight.base[1].top4BetCost) or dataEasy.getItemData(csv.cross.union_fight.base[1].preBetCost)
	end

	local var_9_1 = arg_9_0.originBet[arg_9_0.showTab:read()] or {}
	local var_9_2 = arg_9_0.showTab:read() ~= 5 and arg_9_0.preData[arg_9_0.showTab:read()] or arg_9_0.topData

	for iter_9_2, iter_9_3 in pairs(var_9_1) do
		for iter_9_4, iter_9_5 in pairs(iter_9_3.role_keys) do
			if iter_9_5[2] == arg_9_0.userId then
				for iter_9_6, iter_9_7 in ipairs(var_9_2) do
					iter_9_7.bet = var_0_0.hide

					if iter_9_2 == iter_9_7.union_db_id then
						iter_9_7.bet = var_0_0.showIcon
					end
				end
			end
		end
	end

	if arg_9_0.showTab:read() == 5 then
		arg_9_0.showData:set(arg_9_0.topData, true)
	else
		arg_9_0.showData:set(arg_9_0.preData[arg_9_0.showTab:read()], true)
	end

	local var_9_3 = {}

	if not itertools.isempty(arg_9_0.preData) then
		for iter_9_8, iter_9_9 in pairs(arg_9_0.preData) do
			for iter_9_10, iter_9_11 in ipairs(iter_9_9) do
				table.insert(var_9_3, iter_9_11)
			end
		end
	end

	if not itertools.isempty(arg_9_0.topData) then
		for iter_9_12, iter_9_13 in pairs(arg_9_0.topData) do
			table.insert(var_9_3, iter_9_13)
		end
	end

	local var_9_4 = {}

	for iter_9_14, iter_9_15 in pairs(arg_9_0.originBet) do
		for iter_9_16, iter_9_17 in pairs(iter_9_15) do
			for iter_9_18, iter_9_19 in pairs(iter_9_17.role_keys) do
				if iter_9_19[2] == arg_9_0.userId then
					for iter_9_20, iter_9_21 in ipairs(var_9_3) do
						if iter_9_16 == iter_9_21.union_db_id then
							var_9_4[iter_9_14] = {
								union_db_id = iter_9_16,
								success = iter_9_17.success,
								union_name = iter_9_21.union_name,
								union_logo = iter_9_21.union_logo
							}
						end
					end
				end
			end
		end
	end

	arg_9_0.bet = var_9_4
end

function var_0_2.initModel(arg_10_0)
	arg_10_0.preData = gGameModel.cross_union_fight:read("pre_battle_groups") or {
		{},
		{},
		{},
		{}
	}
	arg_10_0.status = gGameModel.cross_union_fight:getIdler("status")
	arg_10_0.topData = gGameModel.cross_union_fight:read("top_battle_groups") or {}

	if arg_10_0.status:read() == "closed" then
		arg_10_0.lastBattle = gGameModel.cross_union_fight:read("last_battle_groups") or {}
		arg_10_0.unions = gGameModel.cross_union_fight:read("unions") or {}

		local var_10_0 = {
			{},
			{},
			{},
			{}
		}
		local var_10_1 = {}

		for iter_10_0, iter_10_1 in ipairs(arg_10_0.lastBattle) do
			if iter_10_0 == 5 then
				for iter_10_2, iter_10_3 in pairs(iter_10_1) do
					var_10_1[iter_10_2] = arg_10_0.unions[iter_10_3]
				end
			else
				for iter_10_4, iter_10_5 in pairs(iter_10_1) do
					var_10_0[iter_10_0][iter_10_4] = arg_10_0.unions[iter_10_5]
				end
			end
		end

		arg_10_0.preData = var_10_0
		arg_10_0.topData = var_10_1
	end

	arg_10_0.userId = gGameModel.role:read("id")
	arg_10_0.preData = itertools.isempty(arg_10_0.preData) and {
		{},
		{},
		{},
		{}
	} or arg_10_0.preData

	for iter_10_6, iter_10_7 in pairs(arg_10_0.topData) do
		iter_10_7.grayData = true
	end

	for iter_10_8, iter_10_9 in pairs(arg_10_0.preData) do
		for iter_10_10, iter_10_11 in pairs(iter_10_9) do
			iter_10_11.grayData = true
		end
	end
end

function var_0_2.onRuleBtnClick(arg_11_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_11_0:createHandler("getRuleContext"), {
		width = 1326
	})
end

function var_0_2.getRuleContext(arg_12_0, arg_12_1)
	local var_12_0 = adaptContext

	return {
		var_12_0.clone(arg_12_1.title, function(arg_13_0)
			arg_13_0:get("text"):text(gLanguageCsv.rule)
		end),
		var_12_0.noteText(125601, 125699)
	}
end

function var_0_2.onGuessBtnClick(arg_14_0, arg_14_1, arg_14_2)
	local function var_14_0()
		local var_15_0 = {}

		if arg_14_0.showTab:read() == 5 then
			for iter_15_0, iter_15_1 in csvMapPairs(csv.cross.union_fight.base[1].top4BetCost) do
				var_15_0[iter_15_0] = iter_15_1
			end
		else
			for iter_15_2, iter_15_3 in csvMapPairs(csv.cross.union_fight.base[1].preBetCost) do
				var_15_0[iter_15_2] = iter_15_3
			end
		end

		local var_15_1 = false

		for iter_15_4, iter_15_5 in pairs(var_15_0) do
			if iter_15_5 > dataEasy.getNumByKey(iter_15_4) then
				gGameUI:showTip(gLanguageCsv.cuildCurrencyNotEnough)

				var_15_1 = false

				break
			end

			var_15_1 = true
		end

		if var_15_1 then
			gGameApp:requestServer("/game/cross/union/fight/bet", function(arg_16_0)
				arg_14_0.originBet = arg_16_0.view.bets

				arg_14_0:handleBetData()
				arg_14_0:refreshTopIcon()
				userDefault.setForeverLocalKey("crossUnionFightShowed", {
					type = arg_14_0.showTab:read() ~= 5 and 1 or 2,
					time = tonumber(time.getTodayStr())
				})
			end, arg_14_0.showTab:read(), arg_14_2)
		end
	end

	local var_14_1 = arg_14_0.showTab:read() == 5 and string.format(gLanguageCsv.finalMatchTip, dataEasy.getItemData(csv.cross.union_fight.base[1].top4BetCost)[1].num) or string.format(gLanguageCsv.preliminaryMatchTip, dataEasy.getItemData(csv.cross.union_fight.base[1].preBetCost)[1].num)
	local var_14_2 = "crossUnionFightBet"
	local var_14_3 = userDefault.getCurrDayKey(var_14_2, "first")

	if var_14_3 == "first" then
		var_14_3 = "true"

		userDefault.setCurrDayKey(var_14_2, var_14_3)
	end

	local var_14_4 = time.getTime()
	local var_14_5 = time.getNumTimestamp(tonumber(time.getTodayStr()), 9, 0)

	if arg_14_0.status:read() == "prePrepare" and var_14_5 < var_14_4 or arg_14_0.status:read() == "topPrepare" and arg_14_0.showTab:read() == 5 then
		if var_14_3 == "first" or var_14_3 == "true" then
			if arg_14_0.status:read() == "topPrepare" and arg_14_0.showTab:read() == 5 then
				gGameUI:showDialog({
					fontSize = 40,
					isRich = true,
					btnType = 2,
					align = "center",
					content = var_14_1,
					cb = var_14_0
				})
			else
				gGameUI:showDialog({
					fontSize = 40,
					selectType = 2,
					isRich = true,
					btnType = 2,
					align = "center",
					content = var_14_1,
					cb = var_14_0,
					selectKey = var_14_2
				})
			end
		else
			var_14_0()
		end
	else
		gGameUI:showTip(gLanguageCsv.crossUnionFightDoNotBet)
	end
end

function var_0_2.onLeftItemClick(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	if arg_17_0.leftDatas:at(arg_17_2):read().lock then
		if arg_17_0.leftDatas:at(5).oldval.lock then
			gGameUI:showTip(gLanguageCsv.finalMatchNotStart)
		end
	else
		arg_17_0.showTab:set(arg_17_2)
		arg_17_0.txt1:text(arg_17_3)
	end
end

function var_0_2.addTabListClipping(arg_18_0)
	local var_18_0 = arg_18_0.list

	var_18_0:retain()
	var_18_0:removeFromParent()

	local var_18_1 = var_18_0:size()
	local var_18_2 = ccui.Scale9Sprite:create()

	var_18_2:initWithFile(cc.rect(48, 0, var_18_1.width, var_18_1.height), "city/union/cross_unionfight/box_jc_mask.png")
	var_18_2:size(var_18_1):anchorPoint(0, 0):xy(var_18_0:xy())
	cc.ClippingNode:create(var_18_2):setAlphaThreshold(0.1):add(var_18_0):addTo(arg_18_0.rightPanel, var_18_0:z())
	var_18_0:release()
end

return var_0_2
