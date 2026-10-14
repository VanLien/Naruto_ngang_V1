local var_0_0 = require("app.views.city.activity.brave_challenge.adapt")
local var_0_1 = 3
local var_0_2 = {
	gainBuff = 3,
	clearance = 4,
	uncondition = 0,
	gainCard = 1,
	failure = 2
}
local var_0_3 = 0.5
local var_0_4 = {
	cc.p(95, 100),
	cc.p(295, 100),
	cc.p(495, 100),
	cc.p(695, 100),
	cc.p(895, 100),
	cc.p(1095, 100),
	cc.p(1455, 100),
	cc.p(1655, 100)
}
local var_0_5 = {
	cc.p(-522, 165),
	cc.p(11, 165),
	cc.p(546, 165)
}
local var_0_6 = cc.load("mvc").ViewBase
local var_0_7 = class("BraveChallengeSelectCardView", var_0_6)

var_0_7.RESOURCE_FILENAME = "activity_brave_challenge_view_select_card.json"
var_0_7.RESOURCE_BINDING = {
	["bottomPanel.commonTipPanel"] = "commonTipPanel",
	["bottomPanel.txtTip"] = "txtTip",
	starItem = "starItem",
	selectPanel = "selectPanel",
	["bottomPanel.btnFilter"] = "btnFilter",
	item01 = "item01",
	["bottomPanel.rateTipPanel"] = "rateTipPanel",
	item02 = "item02",
	selectItem = "selectItem",
	bottomPanel = "bottomPanel",
	["bottomPanel.btnStart"] = {
		varname = "btnStart",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnGame")
			}
		}
	},
	["bottomPanel.btnStart.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.ORANGE
				}
			}
		}
	},
	["bottomPanel.btnFilter.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(246, 82, 102, 255)
				}
			}
		}
	},
	["bottomPanel.cardList"] = {
		varname = "cardList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 3,
				data = bindHelper.self("allCardDatas"),
				item = bindHelper.self("item01"),
				cloneItem = bindHelper.self("item02"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = 7
					local var_1_1 = 1

					arg_1_1:removeAllChildren()

					for iter_1_0, iter_1_1 in pairs(arg_1_3) do
						local var_1_2 = var_1_0

						if iter_1_1.unlockType == 0 then
							var_1_2 = var_1_1
							var_1_1 = var_1_1 + 1
						else
							var_1_0 = var_1_0 + 1
						end

						local var_1_3 = arg_1_0.cloneItem:clone()

						var_1_3:addTo(arg_1_1)
						var_1_3:xy(var_0_4[var_1_2])

						local var_1_4 = var_1_3:multiget("imgSelect", "imgLock", "imgNew")

						var_1_4.imgSelect:visible(iter_1_1.battle == 1)
						var_1_4.imgLock:visible(not iter_1_1.isUse)

						local var_1_5 = iter_1_1.battle == 1

						var_1_5 = var_1_5 or not iter_1_1.isUse

						bind.extend(arg_1_0, var_1_3, {
							class = "card_icon",
							props = {
								unitId = iter_1_1.unitId,
								advance = iter_1_1.advance,
								rarity = iter_1_1.rarity,
								star = iter_1_1.star,
								grayState = var_1_5 and 1 or 0,
								isNew = iter_1_1.isNew,
								levelProps = {
									data = iter_1_1.level
								},
								onNode = function(arg_2_0)
									arg_2_0:xy(-4, -4)
								end
							}
						})

						if iter_1_1.isUse then
							bind.touch(arg_1_0, var_1_3, {
								methods = {
									ended = functools.partial(arg_1_0.clickCell, iter_1_1, arg_1_2, iter_1_0)
								}
							})
						else
							bind.touch(arg_1_0, var_1_3, {
								methods = {
									ended = functools.partial(arg_1_0.clickCellTwo, iter_1_1)
								}
							})
						end
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onSelectCard", true),
				clickCellTwo = bindHelper.self("onDelockTip", true)
			}
		}
	},
	["selectItem.panelAddInfo.txtUp"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.COLORS.OUTLINE.ORANGE
				}
			}
		}
	}
}

function var_0_7.onCreate(arg_3_0, arg_3_1)
	arg_3_0.parent = arg_3_1.parent
	arg_3_0.data = arg_3_1.data.datas

	arg_3_0:initModel()

	arg_3_0.selectIndex = idler.new()
	arg_3_0.allCardDatas = idlers.newWithMap({})
	arg_3_0.selectCardData = idlertable.new({})
	arg_3_0.filterCondition = idlertable.new()
	arg_3_0.commonCardDatas = {}
	arg_3_0.rateCardDatas = {}
	arg_3_0.activityId = arg_3_0.id:read()

	arg_3_0:initBaseCardData()

	arg_3_0.showPanel = {}
	arg_3_0.baseInfo = arg_3_0.parent:getBaseInfo()

	arg_3_0:initShowPanel()
	idlereasy.when(arg_3_0.selectCardData, function(arg_4_0, arg_4_1)
		for iter_4_0 = 1, var_0_1 do
			arg_3_0:showSelectCard(iter_4_0, arg_4_1[iter_4_0])
		end
	end)
	idlereasy.when(arg_3_0.filterCondition, function()
		arg_3_0:reflushDatas()
	end)
	arg_3_0:initFilterBtn()
	arg_3_0:initSelectPanel()
	arg_3_0:initDownPanel()
	arg_3_0:runStartAction()
end

function var_0_7.initShowPanel(arg_6_0)
	for iter_6_0 = 1, var_0_1 do
		local var_6_0 = arg_6_0.selectItem:clone():show():addTo(arg_6_0.selectPanel):xy(var_0_5[iter_6_0])

		arg_6_0.showPanel[iter_6_0] = var_6_0
	end
end

function var_0_7.openAddCardView(arg_7_0)
	arg_7_0.addCards = idler.new(0)

	idlereasy.when(arg_7_0.addCards, function(arg_8_0, arg_8_1)
		local var_8_0 = arg_7_0.data.add or {}

		if arg_8_1 < itertools.size(var_8_0) then
			arg_7_0:checkCards(var_8_0[arg_8_1 + 1])
		end
	end)
end

function var_0_7.initDownPanel(arg_9_0)
	arg_9_0.txtTip:text(string.format(gLanguageCsv.bcSelectCardTip03, arg_9_0.baseInfo.sameTimes))
end

function var_0_7.runStartAction(arg_10_0)
	local var_10_0, var_10_1 = arg_10_0.bottomPanel:xy()

	arg_10_0.bottomPanel:xy(var_10_0, var_10_1 - 600)
	arg_10_0.selectPanel:visible(false)
	performWithDelay(arg_10_0, function()
		arg_10_0.bottomPanel:runAction(cc.Sequence:create(cc.EaseOut:create(cc.MoveTo:create(var_0_3, cc.p(var_10_0, var_10_1)), var_0_3), cc.CallFunc:create(function()
			arg_10_0.selectPanel:visible(true)
			arg_10_0:openAddCardView()
		end), nil))
		arg_10_0.parent:setType(2)
	end, 0.016666666666666666)
end

function var_0_7.runEndAction(arg_13_0)
	arg_13_0.selectPanel:visible(false)

	local var_13_0, var_13_1 = arg_13_0.bottomPanel:xy()

	arg_13_0.bottomPanel:runAction(cc.Sequence:create(cc.EaseOut:create(cc.MoveTo:create(var_0_3, cc.p(var_13_0, var_13_1 - 600)), var_0_3), cc.CallFunc:create(function()
		return
	end), nil))
end

function var_0_7.initModel(arg_15_0)
	arg_15_0.id = gGameModel.brave_challenge:getIdler("yyID")
	arg_15_0.unlockCards = gGameModel.brave_challenge:getIdler("unlock_cards")
	arg_15_0.status = gGameModel.brave_challenge:getIdler("status")
end

function var_0_7.initSelectPanel(arg_16_0)
	for iter_16_0 = 1, 3 do
		local var_16_0 = arg_16_0.showPanel[iter_16_0]
		local var_16_1 = var_16_0:get("imgBg")
		local var_16_2 = var_16_1:get("imgSel")
		local var_16_3 = var_16_1:size()
		local var_16_4

		var_16_4 = var_16_2 or widget.addAnimationByKey(var_16_0, "effect/buzhen2.skel", "imgSel", "effect_loop", 5):xy(var_16_1:x(), var_16_1:y() + 20):scale(0.6)
	end
end

function var_0_7.checkCards(arg_17_0, arg_17_1)
	gGameUI:stackUI("city.activity.brave_challenge.gain_card", nil, {
		clickClose = true,
		blackLayer = true
	}, arg_17_1, arg_17_0:createHandler("addCount"))
end

function var_0_7.addCount(arg_18_0)
	arg_18_0.addCards:set(arg_18_0.addCards:read() + 1)
end

function var_0_7.getCardType(arg_19_0)
	local var_19_0 = arg_19_0.parent:getBaseInfo()
	local var_19_1 = {}

	for iter_19_0, iter_19_1 in csvPairs(var_19_0.cards) do
		var_19_1[iter_19_1] = iter_19_0
	end

	return var_19_1
end

function var_0_7.initBaseCardData(arg_20_0)
	local var_20_0 = arg_20_0:getCardType()
	local var_20_1 = {}
	local var_20_2 = gGameModel.brave_challenge:read("unlock_cards")

	for iter_20_0, iter_20_1 in ipairs(var_20_2) do
		var_20_1[iter_20_1] = true
	end

	local var_20_3 = {}
	local var_20_4 = arg_20_0.data.add or {}

	for iter_20_2, iter_20_3 in ipairs(var_20_4) do
		var_20_3[iter_20_3] = true
	end

	local var_20_5 = {}
	local var_20_6 = {}

	arg_20_0.starAddAttrsData = {}

	for iter_20_4, iter_20_5 in csvPairs(csv.brave_challenge.cards) do
		if var_20_0[iter_20_5.groupID] then
			arg_20_0.starAddAttrsData[iter_20_5.cardID] = iter_20_5

			local var_20_7 = csv.cards[iter_20_5.cardID]
			local var_20_8 = csv.unit[var_20_7.unitID]
			local var_20_9 = {
				battle = 0,
				csvID = iter_20_4,
				cardId = iter_20_5.cardID,
				unitId = var_20_7.unitID,
				level = iter_20_5.level,
				star = iter_20_5.star,
				advance = iter_20_5.advance,
				rarity = var_20_8.rarity,
				attr1 = var_20_8.natureType,
				attr2 = var_20_8.natureType2,
				atkType = var_20_7.atkType,
				unlockTarget = iter_20_5.unlockTarget,
				unlockType = iter_20_5.unlockType,
				lockTip = iter_20_5.unlockdesc1,
				isNew = var_20_3[iter_20_4] or false
			}

			if iter_20_5.unlockType == 0 then
				var_20_9.isUse = true

				table.insert(arg_20_0.commonCardDatas, var_20_9)
			else
				var_20_9.isUse = var_20_1[iter_20_4] or false

				table.insert(arg_20_0.rateCardDatas, var_20_9)
			end
		end
	end
end

function var_0_7.setStructData(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = {}
	local var_21_1 = {}
	local var_21_2 = 0

	for iter_21_0, iter_21_1 in pairs(arg_21_1) do
		var_21_2 = var_21_2 + 1

		if var_21_2 % arg_21_2 == 1 then
			if arg_21_2 < var_21_2 then
				table.insert(var_21_0, var_21_1)
			end

			var_21_1 = {}
		end

		table.insert(var_21_1, iter_21_1)
	end

	if #var_21_1 > 0 then
		table.insert(var_21_0, var_21_1)

		local var_21_3 = {}
	end

	return var_21_0
end

function var_0_7.setShowData(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0:setStructData(arg_22_1, 6)
	local var_22_1 = arg_22_0:setStructData(arg_22_2, 2)
	local var_22_2 = #var_22_0

	if #var_22_0 < #var_22_1 then
		var_22_2 = #var_22_1
	end

	local var_22_3 = {}

	for iter_22_0 = 1, var_22_2 do
		var_22_3[iter_22_0] = var_22_0[iter_22_0] or {}

		local var_22_4 = var_22_1[iter_22_0] or {}

		for iter_22_1, iter_22_2 in ipairs(var_22_4) do
			table.insert(var_22_3[iter_22_0], iter_22_2)
		end
	end

	arg_22_0.allCardDatas:update(var_22_3)
end

function var_0_7.reflushDatas(arg_23_0)
	local var_23_0 = arg_23_0:onFilterCards()
	local var_23_1 = arg_23_0:onSortCards()

	local function var_23_2(arg_24_0)
		local var_24_0 = {}

		for iter_24_0, iter_24_1 in ipairs(arg_24_0) do
			if var_23_0(iter_24_1) then
				table.insert(var_24_0, iter_24_1)
			end
		end

		table.sort(var_24_0, var_23_1)

		return var_24_0
	end

	local var_23_3 = var_23_2(arg_23_0.commonCardDatas)
	local var_23_4 = var_23_2(arg_23_0.rateCardDatas)

	arg_23_0:setShowData(var_23_3, var_23_4)
	arg_23_0.rateTipPanel:visible(#var_23_4 == 0)
	arg_23_0.commonTipPanel:visible(#var_23_3 == 0)
end

function var_0_7.showSelectCard(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = csv.brave_challenge.cards
	local var_25_1 = arg_25_0.selectCardData:read()[arg_25_1]
	local var_25_2 = arg_25_0.showPanel[arg_25_1]
	local var_25_3 = var_25_2:get("panelAddInfo")

	if not var_25_1 then
		if var_25_2:getChildByName("sprite") then
			var_25_2:getChildByName("sprite"):hide()
		end

		var_25_3:hide()

		return
	end

	local var_25_4 = var_25_0[var_25_1]
	local var_25_5 = csv.cards[var_25_4.cardID].unitID
	local var_25_6 = csv.unit[var_25_5]
	local var_25_7 = var_25_2:get("imgBg")

	if var_25_2.csvID == var_25_1 and var_25_2:getChildByName("sprite") then
		var_25_2:getChildByName("sprite"):show()
	else
		var_25_2:removeChildByName("sprite")
		widget.addAnimationByKey(var_25_2, var_25_6.unitRes, "sprite", "standby_loop", 1):scale(var_25_6.scale * 0.8):xy(var_25_7:x(), var_25_7:y() + 15):setSkin(var_25_6.skin)

		var_25_2.csvID = var_25_1
	end

	if arg_25_0.baseInfo.isStarAttrAdd then
		var_25_3:show()
		arg_25_0:initDownStar(var_25_3, var_25_4.cardID)
	end
end

function var_0_7.initFilterBtn(arg_26_0)
	local var_26_0 = arg_26_0.btnFilter:parent():convertToWorldSpace(arg_26_0.btnFilter:box())
	local var_26_1 = arg_26_0:convertToNodeSpace(var_26_0)
	local var_26_2 = gGameUI:getConvertPos(arg_26_0.btnFilter, arg_26_0:getResourceNode())

	gGameUI:createView("city.card.bag_filter", arg_26_0.btnFilter):init({
		cb = arg_26_0:createHandler("onBattleFilter"),
		others = {
			height = 122,
			panelOrder = false,
			width = 190,
			isShow = false,
			x = var_26_2.x,
			y = var_26_2.y,
			btn = arg_26_0.btnFilter
		}
	}):z(100):xy(-var_26_1.x, -var_26_1.y)
end

function var_0_7.onBtnGame(arg_27_0)
	if table.nums(arg_27_0.selectCardData:read()) ~= 3 then
		gGameUI:showTip(gLanguageCsv.bcSelectCardTip)

		return
	end

	if arg_27_0.status:read() == "start" then
		return
	end

	gGameApp:requestServer(var_0_0.url("preEnd"), function(arg_28_0)
		gGameUI:disableTouchDispatch(var_0_3, false)
		arg_27_0.parent:openOtherView("city.activity.brave_challenge.challenge_gate", 3, true)
	end, arg_27_0.selectCardData:read(), arg_27_0.activityId)
end

function var_0_7.onSelectCard(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
	local var_29_0 = {}

	if table.nums(arg_29_0.selectCardData:read()) >= 3 and arg_29_2.battle == 0 then
		gGameUI:showTip(gLanguageCsv.bcSelectCardTip02)

		return
	end

	for iter_29_0, iter_29_1 in arg_29_0.selectCardData:ipairs() do
		var_29_0[iter_29_0] = iter_29_1
	end

	if arg_29_2.battle == 0 then
		table.insert(var_29_0, arg_29_2.csvID)
	else
		for iter_29_2, iter_29_3 in ipairs(var_29_0) do
			if iter_29_3 == arg_29_2.csvID then
				table.remove(var_29_0, iter_29_2)

				break
			end
		end
	end

	local var_29_1 = arg_29_0.allCardDatas:atproxy(arg_29_3)

	var_29_1[arg_29_4].battle = arg_29_2.battle == 0 and 1 or 0
	var_29_1[arg_29_4].isNew = false

	arg_29_0.selectCardData:set(var_29_0)
end

function var_0_7.onDelockTip(arg_30_0, arg_30_1, arg_30_2)
	gGameUI:showTip(arg_30_2.lockTip)
end

function var_0_7.onBattleFilter(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	arg_31_0.filterCondition:set({
		attr1 = arg_31_1,
		attr2 = arg_31_2,
		rarity = arg_31_3,
		atkType = arg_31_4
	}, true)
end

function var_0_7.onFilterCards(arg_32_0)
	local var_32_0 = arg_32_0.filterCondition:read()
	local var_32_1 = {}

	if not itertools.isempty(var_32_0) then
		var_32_1 = {
			{
				"rarity",
				var_32_0.rarity < ui.RARITY_LAST_VAL and var_32_0.rarity or nil
			},
			{
				"attr2",
				var_32_0.attr2 < ui.ATTR_MAX and var_32_0.attr2 or nil
			},
			{
				"attr1",
				var_32_0.attr1 < ui.ATTR_MAX and var_32_0.attr1 or nil
			},
			{
				"atkType",
				var_32_0.atkType
			}
		}
	end

	local function var_32_2(arg_33_0, arg_33_1, arg_33_2)
		if arg_33_0[arg_33_1] == nil and (arg_33_1 ~= "attr2" or arg_33_0.attr1 == arg_33_2) then
			return true
		end

		if arg_33_1 == "atkType" then
			for iter_33_0, iter_33_1 in ipairs(arg_33_0.atkType) do
				if arg_33_2[iter_33_1] then
					return true
				end
			end

			return false
		end

		if arg_33_0[arg_33_1] == arg_33_2 then
			return true
		end

		return false
	end

	return function(arg_34_0)
		for iter_34_0 = 1, #var_32_1 do
			local var_34_0 = var_32_1[iter_34_0]

			if var_34_0[2] and not var_32_2(arg_34_0, var_34_0[1], var_34_0[2]) then
				return false
			end
		end

		return true
	end
end

function var_0_7.onSortCards(arg_35_0)
	return function(arg_36_0, arg_36_1)
		if arg_36_0.battle ~= arg_36_1.battle then
			return arg_36_0.battle > arg_36_1.battle
		end

		if arg_36_0.isUse ~= arg_36_1.isUse then
			return arg_36_0.isUse
		end

		local var_36_0 = arg_36_0.rarity
		local var_36_1 = arg_36_1.rarity

		if var_36_0 ~= var_36_1 then
			return var_36_1 < var_36_0
		end

		return arg_36_0.cardId < arg_36_1.cardId
	end
end

function var_0_7.getCardMaxStar(arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = gGameModel.role:read("cards")
	local var_37_1 = 0
	local var_37_2 = {}
	local var_37_3

	for iter_37_0, iter_37_1 in ipairs(var_37_0) do
		local var_37_4 = gGameModel.cards:find(iter_37_1)
		local var_37_5 = var_37_4:read("card_id")
		local var_37_6 = var_37_4:read("star")

		var_37_2[var_37_5] = true

		local var_37_7 = csv.cards[var_37_5]

		if arg_37_1 == var_37_7.cardMarkID and var_37_1 < var_37_6 and (not arg_37_2 or arg_37_2 and var_37_7.megaIndex ~= 0) then
			var_37_1 = var_37_6
			var_37_3 = iter_37_1
		end
	end

	return var_37_1, var_37_2, var_37_3
end

function var_0_7.getAddNum(arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = arg_38_0.starAddAttrsData[arg_38_1]

	if var_38_0 then
		local var_38_1 = 0

		for iter_38_0, iter_38_1 in ipairs(var_38_0.starUnlock) do
			if iter_38_1 <= arg_38_2 then
				var_38_1 = iter_38_0
			end
		end

		if var_38_1 ~= 0 then
			return dataEasy.attrSubtraction(var_38_0.addAttributes[var_38_1], "100%")
		end
	end

	return "0%"
end

function var_0_7.initDownStar(arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = csv.cards[arg_39_2]
	local var_39_1 = var_39_0.cardMarkID
	local var_39_2 = var_39_0.megaIndex ~= 0
	local var_39_3 = arg_39_0:getCardMaxStar(var_39_1, var_39_2)
	local var_39_4 = arg_39_0:getAddNum(arg_39_2, var_39_3)
	local var_39_5 = arg_39_1:multiget("txtUp", "starList", "btnDetail")

	var_39_5.txtUp:text(var_39_4)
	bind.extend(arg_39_0, var_39_5.starList, {
		class = "listview",
		props = {
			data = dataEasy.getStarData(var_39_3),
			item = bindHelper.self("starItem"),
			onItem = function(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				arg_40_1:get("icon"):texture(arg_40_3.icon)
			end
		}
	})
	bind.touch(arg_39_0, var_39_5.btnDetail, {
		methods = {
			ended = functools.partial(arg_39_0.onBtnDetail, arg_39_0, var_39_5.btnDetail)
		}
	})
end

function var_0_7.onBtnDetail(arg_41_0, arg_41_1)
	local var_41_0 = {}
	local var_41_1 = arg_41_1:getParent():convertToWorldSpace(cc.p(arg_41_1:xy()))

	var_41_0.pos = cc.p(var_41_1.x, var_41_1.y + 50)
	var_41_0.strs = {
		csv.note[125101].fmt,
		csv.note[125102].fmt
	}

	local var_41_2 = gGameUI:stackUI("city.activity.brave_challenge.tip", nil, nil, var_41_0)

	gGameUI.itemDetailView = var_41_2
end

return var_0_7
