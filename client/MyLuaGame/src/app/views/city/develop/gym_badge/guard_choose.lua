local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("gymBadgeGuardChooseView", var_0_0)
local var_0_2 = {
	CARD = 1
}
local var_0_3 = {
	{
		{
			val = 1,
			name = gLanguageCsv.fighting
		},
		{
			val = 2,
			name = gLanguageCsv.rarity
		},
		{
			val = 3,
			name = gLanguageCsv.star
		},
		{
			val = 4,
			name = gLanguageCsv.breakthroughLevel
		},
		{
			val = 5,
			name = gLanguageCsv.getTime
		}
	},
	{
		{
			val = 1,
			name = gLanguageCsv.fighting
		},
		{
			val = 2,
			name = gLanguageCsv.level
		},
		{
			val = 4,
			name = gLanguageCsv.star
		},
		{
			val = 5,
			name = gLanguageCsv.getTime
		}
	},
	{
		{
			val = 3,
			name = gLanguageCsv.rarity
		},
		{
			val = 6,
			name = gLanguageCsv.numberPieces
		},
		{
			val = 7,
			name = gLanguageCsv.collectDegrees
		}
	},
	{
		{
			val = 6,
			name = gLanguageCsv.numberPieces
		},
		{
			val = 7,
			name = gLanguageCsv.collectDegrees
		}
	}
}

local function var_0_4(arg_1_0, arg_1_1, arg_1_2)
	if next(arg_1_0) == nil then
		return {}
	end

	for iter_1_0, iter_1_1 in pairs(arg_1_0) do
		if iter_1_1.num then
			iter_1_1.numPercent = iter_1_1.num / iter_1_1.maxNum
		end
	end

	local var_1_0 = {
		"fight",
		"rarity",
		"star",
		"advance",
		"getTime",
		"num",
		"numPercent"
	}

	if arg_1_1 == nil then
		table.sort(arg_1_0, function(arg_2_0, arg_2_1)
			for iter_2_0 = 1, 4 do
				if arg_2_0[var_1_0[iter_2_0]] ~= arg_2_1[var_1_0[iter_2_0]] then
					return arg_2_0[var_1_0[iter_2_0]] > arg_2_1[var_1_0[iter_2_0]]
				end
			end

			return arg_2_0[var_1_0[5]] > arg_2_1[var_1_0[5]]
		end)
	else
		table.sort(arg_1_0, function(arg_3_0, arg_3_1)
			if arg_3_0.isBg ~= arg_3_1.isBg then
				return arg_3_0.isBg
			end

			if arg_3_0[var_1_0[arg_1_1]] ~= arg_3_1[var_1_0[arg_1_1]] then
				if arg_1_2 then
					return arg_3_0[var_1_0[arg_1_1]] > arg_3_1[var_1_0[arg_1_1]]
				else
					return arg_3_0[var_1_0[arg_1_1]] < arg_3_1[var_1_0[arg_1_1]]
				end
			end

			if arg_3_0.markId ~= arg_3_1.markId then
				return arg_3_0.markId < arg_3_1.markId
			end

			if arg_3_0.fight and arg_3_1.fight then
				return arg_3_0.fight > arg_3_1.fight
			end

			return false
		end)
	end

	return arg_1_0
end

local function var_0_5(arg_4_0, arg_4_1)
	if next(arg_4_0) == nil then
		return {}
	end

	if arg_4_1 == nil or arg_4_1[2] == nil then
		return arg_4_0
	end

	local function var_4_0(arg_5_0, arg_5_1, arg_5_2)
		if arg_5_1 == "allCards" then
			if arg_5_2 == true then
				return true
			elseif not arg_5_0.badge[1] then
				return true
			else
				return false
			end
		end

		if arg_5_1 == "chooseBadge" then
			if arg_5_2 == 0 then
				return true
			elseif arg_5_0.badge[1] == arg_5_2 then
				return true
			else
				return false
			end
		end

		if arg_5_0[arg_5_1] == nil and (arg_5_1 ~= "attr2" or arg_5_0.attr1 == arg_5_2) then
			return true
		end

		if arg_5_1 == "atkType" then
			for iter_5_0, iter_5_1 in ipairs(arg_5_0.atkType) do
				if arg_5_2[iter_5_1] then
					return true
				end
			end

			return false
		end

		if arg_5_0[arg_5_1] == arg_5_2 then
			return true
		end

		return false
	end

	local var_4_1 = {}

	for iter_4_0, iter_4_1 in pairs(arg_4_0) do
		if var_4_0(iter_4_1, arg_4_1[1], arg_4_1[2]) then
			table.insert(var_4_1, iter_4_1)
		end
	end

	return var_4_1
end

local function var_0_6(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0

	for iter_6_0 = 1, #arg_6_1 do
		var_6_0 = var_0_5(var_6_0, arg_6_1[iter_6_0])
	end

	return var_6_0
end

var_0_1.RESOURCE_FILENAME = "gym_badge_choose_card.json"
var_0_1.RESOURCE_BINDING = {
	subList = "subList",
	item = "badgeItem",
	empty = "showEmpty",
	cardItem = "cardItem",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	title = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	title1 = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	list1 = {
		varname = "list1",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("badgeData"),
				item = bindHelper.self("badgeItem"),
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					arg_7_1:get("icon"):texture(arg_7_3.icon)

					if arg_7_3.isIcon == 1 then
						arg_7_1:get("bg"):texture("city/card/gem/btn_yq_b.png")
					else
						arg_7_1:get("bg"):texture("city/card/gem/btn_yq_h.png")
					end

					bind.click(arg_7_0, arg_7_1, {
						method = functools.partial(arg_7_0.itemClick, arg_7_1, arg_7_2, arg_7_3)
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	sortPanel = {
		varname = "sortPanel",
		binds = {
			event = "extend",
			class = "sort_menus",
			props = {
				width = 245,
				height = 80,
				btnHeight = 80,
				btnType = 2,
				expandUp = false,
				btnWidth = 270,
				maxCount = 4,
				data = bindHelper.self("sortTabData"),
				showSelected = bindHelper.self("sortKey"),
				btnClick = bindHelper.self("onSortMenusBtnClick", true),
				showSortList = bindHelper.self("isDownListShow"),
				onNode = bindHelper.self("onSortMenusNode", true)
			}
		}
	},
	allBtn = {
		varname = "allBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAllBtn")
			}
		}
	},
	useBtn = {
		varname = "useBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onUseBtn")
			}
		}
	},
	list = {
		varname = "cardList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 18,
				leftPadding = 5,
				columnSize = 3,
				data = bindHelper.self("cardDatas"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("cardItem"),
				onCell = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					local var_8_0 = arg_8_1:multiget("iconPanel", "textFight", "textName", "icon", "icon1", "badge", "mask", "textPanel")

					bind.extend(arg_8_0, var_8_0.iconPanel, {
						class = "card_icon",
						props = {
							unitId = arg_8_3.unitId,
							advance = arg_8_3.advance,
							star = arg_8_3.star,
							rarity = arg_8_3.rarity,
							levelProps = {
								data = arg_8_3.level
							},
							onNode = function(arg_9_0)
								return
							end
						}
					})
					bind.click(arg_8_0, arg_8_1, {
						method = functools.partial(arg_8_0.guardUp, arg_8_1, arg_8_2, arg_8_3)
					})
					var_8_0.textName:text(arg_8_3.name)
					var_8_0.textFight:text(arg_8_3.fight)
					var_8_0.icon:texture(ui.ATTR_ICON[arg_8_3.attr1])

					if arg_8_3.attr2 then
						var_8_0.icon1:texture(ui.ATTR_ICON[arg_8_3.attr2])
					else
						var_8_0.icon1:hide()
					end

					if arg_8_3.badge[1] then
						var_8_0.badge:show()
						var_8_0.badge:texture(csv.gym_badge.badge[arg_8_3.badge[1]].icon)
					else
						var_8_0.badge:hide()
					end
				end
			},
			handlers = {
				guardUp = bindHelper.self("onGuardUp")
			}
		}
	}
}

function var_0_1.onCreate(arg_10_0, arg_10_1)
	arg_10_0.badgeNumb = arg_10_1.badgeNumb
	arg_10_0.seat = arg_10_1.key
	arg_10_0.setType = arg_10_1.setType

	arg_10_0:initModel()
	arg_10_0.sortPanel:xy(arg_10_0.sortPanel:x() - 308, 1027)

	arg_10_0.chooseBadge = idler.new(0)
	arg_10_0.badgeData = idlers.new()
	arg_10_0.cardDatas = idlertable.new({})
	arg_10_0.sortOrder = idler.new(true)
	arg_10_0.sortKey = idler.new(1)
	arg_10_0.sortTabData = idlertable.new()
	arg_10_0.sortTabDataIndex = idler.new()
	arg_10_0.attr1 = idler.new()
	arg_10_0.attr2 = idler.new()
	arg_10_0.rarity = idler.new()
	arg_10_0.atkType = idlertable.new({})
	arg_10_0.type = idler.new(1)
	arg_10_0.allCards = idler.new(true)
	arg_10_0.notAllCardsBtn = idler.new(false)
	arg_10_0.allCardsBtn = idler.new(true)
	arg_10_0.isDownListShow = idler.new(false)
	arg_10_0.filterPanel = gGameUI:createView("city.develop.gym_badge.guard_filter", arg_10_0):init({
		cb = arg_10_0:createHandler("onBagFilter"),
		showIdler = arg_10_0:createHandler("isDownListShow"),
		others = {
			panelOffsetX = 330,
			panelOrder = true
		}
	}):xy(40, 45)

	idlereasy.any({
		arg_10_0.type,
		arg_10_0.rarity
	}, function(arg_11_0, arg_11_1, arg_11_2)
		local var_11_0

		if arg_11_1 == var_0_2.CARD then
			var_11_0 = ui.RARITY_ICON[arg_11_2] and 2 or 1
		else
			var_11_0 = ui.RARITY_ICON[arg_11_2] and 4 or 3
		end

		arg_10_0.sortTabDataIndex:set(var_11_0)

		local var_11_1 = {}

		for iter_11_0, iter_11_1 in pairs(var_0_3[var_11_0]) do
			table.insert(var_11_1, iter_11_1.name)
		end

		arg_10_0.sortTabData:set(var_11_1)
		arg_10_0.sortKey:set(1)
		arg_10_0.sortOrder:set(true)
	end)

	arg_10_0.cardInfos = idlertable.new({})

	local var_10_0 = csv.gym_badge.badge

	idlereasy.when(arg_10_0.cards, function(arg_12_0, arg_12_1)
		local var_12_0 = {}
		local var_12_1 = dataEasy.inUsingCardsHash()
		local var_12_2 = (arg_10_0.badges:read() and arg_10_0.badges:read()[arg_10_0.badgeNumb] or {}).guards or {}

		for iter_12_0, iter_12_1 in ipairs(arg_12_1) do
			if var_12_2[arg_10_0.seat] and var_12_2[arg_10_0.seat] == iter_12_1 then
				-- block empty
			else
				local var_12_3 = gGameModel.cards:find(iter_12_1)

				if var_12_3 then
					local var_12_4 = var_12_3:read("card_id", "skin_id", "name", "fighting_point", "level", "star", "advance", "created_time", "locked", "equips", "effort_values", "badge_guard")
					local var_12_5 = csv.cards[var_12_4.card_id]
					local var_12_6 = csv.unit[var_12_5.unitID]
					local var_12_7 = dataEasy.getUnitId(var_12_4.card_id, var_12_4.skin_id)

					var_12_0[iter_12_0] = {
						isSprite = true,
						unitId = var_12_7,
						markId = var_12_5.cardMarkID,
						name = var_12_6.name,
						rarity = var_12_6.rarity,
						attr1 = var_12_6.natureType,
						attr2 = var_12_6.natureType2,
						fight = var_12_4.fighting_point,
						level = var_12_4.level,
						star = var_12_4.star,
						advance = var_12_4.advance,
						dbid = iter_12_1,
						battleType = var_12_1[iter_12_1],
						atkType = var_12_5.atkType,
						badge = var_12_4.badge_guard
					}

					arg_10_0.cardInfos:set(var_12_0, true)
				end
			end
		end
	end)
	idlereasy.when(arg_10_0.chooseBadge, function(arg_13_0, arg_13_1)
		local var_13_0 = {}

		for iter_13_0, iter_13_1 in ipairs(var_10_0) do
			if arg_13_1 == iter_13_0 then
				local var_13_1 = iter_13_1.showIcon2

				table.insert(var_13_0, {
					isIcon = 2,
					icon = var_13_1
				})
			else
				local var_13_2 = iter_13_1.showIcon1

				table.insert(var_13_0, {
					isIcon = 1,
					icon = var_13_2
				})
			end
		end

		arg_10_0.badgeData:update(var_13_0)
	end)
	idlereasy.any({
		arg_10_0.notAllCardsBtn,
		arg_10_0.allCardsBtn
	}, function(arg_14_0, arg_14_1, arg_14_2)
		arg_10_0.allBtn:setBright(not arg_14_2)
		arg_10_0.useBtn:setBright(not arg_14_1)
		text.addEffect(arg_10_0.allBtn:get("txt"), {
			outline = {
				size = 3,
				color = arg_14_2 and ui.NEWCOLORS.OUTLINE.BLUE or ui.NEWCOLORS.OUTLINE.BLUE
			}
		})
		text.addEffect(arg_10_0.useBtn:get("txt"), {
			outline = {
				size = 3,
				color = not arg_14_2 and ui.NEWCOLORS.OUTLINE.BLUE or ui.NEWCOLORS.OUTLINE.BLUE
			}
		})
	end)

	local var_10_1 = idler.new(true)
	local var_10_2 = idlereasyArgs.new(arg_10_0, "sortTabDataIndex", "cardInfos", "type", "sortKey", "sortOrder", "rarity", "attr1", "attr2", "atkType", "allCards", "chooseBadge")
	local var_10_3 = 0

	idlereasy.any(var_10_2, function(...)
		var_10_3 = var_10_3 + 1

		performWithDelay(arg_10_0, function()
			if var_10_3 > 0 then
				var_10_1:notify()

				var_10_3 = 0
			end
		end, 0)
	end)
	idlerflow.if_(var_10_1):do_(function(arg_17_0)
		local var_17_0 = arg_17_0.cardInfos

		if var_0_3[arg_17_0.sortTabDataIndex][arg_17_0.sortKey] then
			local var_17_1 = var_0_3[arg_17_0.sortTabDataIndex][arg_17_0.sortKey].val

			arg_10_0:sortFilterData(arg_17_0.type, var_17_0, var_17_1, arg_17_0.sortOrder, {
				{
					"rarity",
					ui.RARITY_ICON[arg_17_0.rarity] and arg_17_0.rarity
				},
				{
					"attr2",
					ui.ATTR_ICON[arg_17_0.attr2] and arg_17_0.attr2
				},
				{
					"attr1",
					ui.ATTR_ICON[arg_17_0.attr1] and arg_17_0.attr1
				},
				{
					"atkType",
					arg_17_0.atkType
				},
				{
					"allCards",
					arg_17_0.allCards
				},
				{
					"chooseBadge",
					arg_17_0.chooseBadge
				}
			})
		end
	end, var_10_2)
	Dialog.onCreate(arg_10_0)
end

function var_0_1.initModel(arg_18_0)
	arg_18_0.cards = gGameModel.role:getIdler("cards")
	arg_18_0.badges = gGameModel.role:getIdler("badges")
end

function var_0_1.sortFilterData(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	local var_19_0 = var_0_6(arg_19_2, arg_19_5)
	local var_19_1 = var_0_4(var_19_0, arg_19_3, arg_19_4)

	if next(var_19_1) == nil then
		arg_19_0.showEmpty:show()
		arg_19_0.showEmpty:get("txt"):text(gLanguageCsv.noGuardCards)
	else
		arg_19_0.showEmpty:hide()
	end

	if arg_19_1 == var_0_2.CARD then
		local var_19_2

		if arg_19_0.cardCenterDbid then
			for iter_19_0, iter_19_1 in ipairs(var_19_1) do
				if iter_19_1.dbid == arg_19_0.cardCenterDbid then
					var_19_2 = iter_19_0

					break
				end
			end
		end

		arg_19_0.cardList.preloadCenterIndex = var_19_2 and math.ceil(var_19_2 / arg_19_0.columnSize)

		arg_19_0.cardDatas:set(var_19_1, true)
	end
end

function var_0_1.onBagFilter(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	arg_20_0.attr1:set(arg_20_1)
	arg_20_0.attr2:set(19)
	arg_20_0.rarity:set(arg_20_3)
	arg_20_0.atkType:modify(function()
		return true, arg_20_4
	end)
end

function var_0_1.onSortMenusBtnClick(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	if arg_22_5 == arg_22_3 then
		arg_22_0.sortOrder:modify(function(arg_23_0)
			return true, not arg_23_0
		end)
	else
		arg_22_0.sortOrder:set(true)
	end

	arg_22_0.sortKey:set(arg_22_3)
end

function var_0_1.onSortMenusNode(arg_24_0, arg_24_1, arg_24_2)
	arg_24_2:xy(900, -430):z(20)
end

function var_0_1.onAllBtn(arg_25_0, arg_25_1, arg_25_2)
	arg_25_0.allCards:set(true)
	arg_25_0.chooseBadge:set(0)
	arg_25_0.notAllCardsBtn:set(false)
	arg_25_0.allCardsBtn:set(true)
end

function var_0_1.onUseBtn(arg_26_0, arg_26_1, arg_26_2)
	arg_26_0.allCards:set(false)
	arg_26_0.allCardsBtn:set(false)
	arg_26_0.chooseBadge:set(0)
	arg_26_0.notAllCardsBtn:set(true)
end

function var_0_1.onItemClick(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	if arg_27_0.chooseBadge:read() ~= arg_27_3 then
		arg_27_0.chooseBadge:set(arg_27_3)
		arg_27_0.allCards:set(true)
		arg_27_0.allCardsBtn:set(false)
		arg_27_0.notAllCardsBtn:set(false)
	else
		arg_27_0.chooseBadge:set(0)
		arg_27_0.allCards:set(true)
		arg_27_0.allCardsBtn:set(true)
		arg_27_0.notAllCardsBtn:set(false)
	end
end

function var_0_1.onGuardUp(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	local var_28_0 = (arg_28_0.badges:read() and arg_28_0.badges:read()[arg_28_0.badgeNumb] or {}).guards or {}

	if arg_28_4.dbid == var_28_0[arg_28_0.seat] then
		gGameUI:showTip(gLanguageCsv.cardAlrealyGuard)

		return
	end

	gGameApp:requestServer("/game/badge/guard/setup", nil, arg_28_0.badgeNumb, arg_28_0.seat, arg_28_4.dbid)

	if arg_28_0.setType == 1 then
		gGameUI:showTip(gLanguageCsv.guardAlreadyChange)
	else
		gGameUI:showTip(gLanguageCsv.guardALreadySet)
	end

	var_0_0.onClose(arg_28_0)
end

return var_0_1
