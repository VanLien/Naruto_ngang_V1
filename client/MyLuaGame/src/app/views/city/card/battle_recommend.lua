local function var_0_0(arg_1_0)
	local var_1_0 = {}
	local var_1_1 = itertools.size(arg_1_0)

	for iter_1_0, iter_1_1 in orderCsvPairs(arg_1_0) do
		local var_1_2 = csv.cards[iter_1_1]
		local var_1_3 = csv.unit[var_1_2.unitID].natureType

		var_1_0[var_1_3] = var_1_0[var_1_3] or 0
		var_1_0[var_1_3] = var_1_0[var_1_3] + 1
	end

	local var_1_4 = {}

	for iter_1_2, iter_1_3 in pairs(var_1_0) do
		table.insert(var_1_4, iter_1_3)
	end

	table.sort(var_1_4, function(arg_2_0, arg_2_1)
		return arg_2_1 < arg_2_0
	end)

	local var_1_5 = #var_1_4
	local var_1_6 = csv.battle_card_halo
	local var_1_7 = {}
	local var_1_8 = {}

	for iter_1_4, iter_1_5 in csvPairs(var_1_6) do
		local var_1_9 = iter_1_5.args

		if iter_1_5.type == 1 then
			local var_1_10 = itertools.size(var_1_9)

			if var_1_10 <= var_1_5 then
				for iter_1_6 = 1, var_1_10 do
					if var_1_4[iter_1_6] < var_1_9[iter_1_6] then
						break
					end

					if iter_1_6 == var_1_10 then
						local var_1_11 = iter_1_5.group
						local var_1_12 = iter_1_5.priority

						if not var_1_7[var_1_11] or not (var_1_12 < var_1_7[var_1_11].priority) then
							var_1_7[var_1_11] = {
								csvId = iter_1_4,
								priority = var_1_12
							}
						end
					end
				end
			end
		elseif iter_1_5.type == 2 then
			for iter_1_7, iter_1_8 in pairs(var_1_9) do
				if (var_1_0[iter_1_8[1]] or 0) >= iter_1_8[2] then
					var_1_8[iter_1_4] = iter_1_8[1]
				end
			end
		end
	end

	local var_1_13 = "config/embattle/icon_gh.png"
	local var_1_14 = -1

	for iter_1_9, iter_1_10 in pairs(var_1_7) do
		if var_1_14 < iter_1_9 then
			var_1_14 = iter_1_9
			var_1_13 = var_1_6[iter_1_10.csvId].icon
		end
	end

	return var_1_13
end

local function var_0_1(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	local var_3_0 = arg_3_7 == "clippingBg"
	local var_3_1 = arg_3_2.bg:size()
	local var_3_2 = cc.Sprite:create(arg_3_1.cardData.icon)
	local var_3_3 = var_3_2:size()
	local var_3_4 = arg_3_4 * arg_3_1.cardData.scale
	local var_3_5 = cc.p(arg_3_1.cardData.posOffset.x / var_3_4 - arg_3_5, -arg_3_1.cardData.posOffset.y / var_3_4 + arg_3_6)
	local var_3_6 = cc.size(var_3_1.width / var_3_4, var_3_1.height / var_3_4)
	local var_3_7 = cc.rect((var_3_3.width - var_3_6.width) / 2 - var_3_5.x, (var_3_3.height - var_3_6.height) / 2 - var_3_5.y, var_3_6.width, var_3_6.height)

	var_3_2:alignCenter(var_3_1):scale(var_3_4):setTextureRect(var_3_7)

	if var_3_0 then
		cache.setShader(var_3_2, false, "hsl_gray_white")
		var_3_2:opacity(36)
	end

	arg_3_0:removeChildByName(arg_3_7)
	cc.ClippingNode:create(arg_3_3):setAlphaThreshold(0.1):size(var_3_1):alignCenter(arg_3_0:size()):add(var_3_2):addTo(arg_3_0, var_3_0 and 1 or 2, arg_3_7)
end

local var_0_2 = cc.load("mvc").ViewBase
local var_0_3 = class("CardBattleRecommendView", Dialog)

var_0_3.RESOURCE_FILENAME = "card_battle_recommend.json"
var_0_3.RESOURCE_BINDING = {
	subList = "subList",
	item = "item",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 9,
				columnSize = 3,
				data = bindHelper.self("battleDatas"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:multiget("iconCard", "iconCardBg", "imgSpecialMark", "textSpecial", "bg", "iconAttr", "textAttr", "textDesc", "recommendPanel")

					var_4_0.textAttr:text(arg_4_3.name)
					text.addEffect(var_4_0.textAttr, {
						outline = {
							color = ui.COLORS.NORMAL.WHITE
						}
					})
					var_4_0.textDesc:text(arg_4_3.desc)
					var_4_0.iconAttr:texture(arg_4_3.attrIcon)
					var_4_0.imgSpecialMark:texture(arg_4_3.specialMarkBg):visible(arg_4_3.specialMarkBg ~= "")
					adapt.setTextScaleWithWidth(var_4_0.textSpecial, arg_4_3.specialMarkTitle, 110)
					var_4_0.recommendPanel:visible(arg_4_3.isRecommend)

					local var_4_1 = var_4_0.bg:size()
					local var_4_2 = ccui.Scale9Sprite:create()
					local var_4_3 = dataEasy.getCardIdAndStar(arg_4_3.cardData.cardId)

					var_4_2:initWithFile(cc.rect(60, 60, 1, 1), "common/box/mask_panel_exercise.png")
					var_4_2:size(var_4_1.width - 20, var_4_1.height - 20):alignCenter(var_4_1)
					var_0_1(arg_4_1, arg_4_3, var_4_0, var_4_2, 1, 92, 10, "clipping")
					var_0_1(arg_4_1, arg_4_3, var_4_0, var_4_2, 1.2, 20, 5, "clippingBg")
					bind.touch(arg_4_0, arg_4_1, {
						methods = {
							ended = functools.partial(arg_4_0.itemClick, arg_4_1, arg_4_0:getIdx(arg_4_2), arg_4_3)
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	}
}

function var_0_3.onCreate(arg_5_0, arg_5_1)
	arg_5_0.item:hide()
	arg_5_0:initModel()

	arg_5_0.battleDatas = idlertable.new({})

	local var_5_0 = arg_5_0.cards:read()
	local var_5_1 = {}

	for iter_5_0, iter_5_1 in ipairs(var_5_0) do
		local var_5_2 = gGameModel.cards:find(iter_5_1):read("card_id", "name", "fighting_point", "level", "star", "advance")
		local var_5_3 = csv.cards[var_5_2.card_id]
		local var_5_4 = csv.unit[var_5_3.unitID]

		var_5_1[var_5_3.cardMarkID] = var_5_1[var_5_3.cardMarkID] or {}

		local var_5_5 = var_5_1[var_5_3.cardMarkID][var_5_3.branch]

		if not var_5_5 or var_5_5.fight < var_5_2.fighting_point then
			var_5_1[var_5_3.cardMarkID][var_5_3.branch] = {
				cardId = var_5_2.card_id,
				name = var_5_2.name ~= "" and var_5_2.name or var_5_3.name,
				rarity = var_5_4.rarity,
				fight = var_5_2.fighting_point,
				level = var_5_2.level,
				star = var_5_2.star,
				advance = var_5_2.advance
			}
		end
	end

	arg_5_0.cardDatas = var_5_1

	local var_5_6 = {}
	local var_5_7 = {}

	for iter_5_2, iter_5_3 in orderCsvPairs(csv.card_battle_recommend) do
		for iter_5_4, iter_5_5 in orderCsvPairs(iter_5_3.cards) do
			local var_5_8 = csv.cards[iter_5_5]
			local var_5_9 = var_5_8.cardMarkID

			if iter_5_3.coreMark[iter_5_4] == 1 then
				local var_5_10 = var_5_1[var_5_9] and (var_5_1[var_5_9][var_5_8.branch] or var_5_1[var_5_9][0]) or {}
				local var_5_11 = var_5_10.cardId or iter_5_5
				local var_5_12 = csv.cards[var_5_11]
				local var_5_13 = csv.unit[var_5_12.unitID]

				var_5_7 = {
					cardId = var_5_11,
					name = not var_5_10.name and var_5_12.name or var_5_10.name,
					advance = var_5_10.advance,
					rarity = var_5_13.rarity,
					fight = var_5_10.fighting_point or 0,
					icon = var_5_13.cardShow,
					scale = var_5_13.cardShowScale,
					posOffset = var_5_13.cardShowPosC
				}
			end
		end

		local var_5_14 = csv.battle_card_halo[iter_5_3.haloId]

		table.insert(var_5_6, {
			csvId = iter_5_2,
			cardData = var_5_7,
			name = iter_5_3.name,
			desc = iter_5_3.desc,
			specialMarkBg = iter_5_3.specialMarkBg,
			specialMarkTitle = iter_5_3.specialMarkTitle,
			sort = iter_5_3.sort,
			attrIcon = not var_5_14 and var_0_0(iter_5_3.cards) or var_5_14.icon,
			isRecommend = iter_5_3.isRecommend
		})
	end

	table.sort(var_5_6, function(arg_6_0, arg_6_1)
		return arg_6_0.sort > arg_6_1.sort
	end)
	arg_5_0.battleDatas:set(var_5_6)
	Dialog.onCreate(arg_5_0)
end

function var_0_3.initModel(arg_7_0)
	arg_7_0.cards = gGameModel.role:getIdler("cards")
	arg_7_0.battleCards = gGameModel.role:getIdler("battle_cards")
	arg_7_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_7_0.roleLv = gGameModel.role:getIdler("level")
end

function var_0_3.onItemClick(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	gGameUI:stackUI("city.card.battle_detail", nil, {
		dialog = true
	}, arg_8_0.battleDatas:read(), arg_8_3.k, arg_8_0.cardDatas)
end

return var_0_3
