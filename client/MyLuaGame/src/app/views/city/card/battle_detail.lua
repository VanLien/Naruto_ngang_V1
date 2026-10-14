local function var_0_0(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	if arg_1_3:get("richText") then
		arg_1_3:removeChildByName("richText")
	end

	return rich.createWithWidth(arg_1_0, 40, nil, arg_1_4):anchorPoint(0, 1):xy(arg_1_1, arg_1_2):addTo(arg_1_3, 6, "richText")
end

local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("CardBattleDetailView", Dialog)

var_0_2.RESOURCE_FILENAME = "card_battle_detail.json"
var_0_2.RESOURCE_BINDING = {
	leftPanel = "leftPanel",
	rightPanel = "rightPanel",
	cardItem = "cardItem",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	cardList = {
		varname = "cardList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 7,
				backupCached = false,
				data = bindHelper.self("datas"),
				item = bindHelper.self("cardItem"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("textName", "maskPanel")

					bind.extend(arg_2_0, arg_2_1, {
						class = "card_icon",
						props = {
							levelProps = {
								data = arg_2_3.level
							},
							rarity = arg_2_3.rarity,
							cardId = arg_2_3.cardId,
							advance = arg_2_3.advance,
							star = arg_2_3.star,
							grayState = arg_2_3.fight and 0 or 2,
							onNode = function(arg_3_0)
								arg_3_0:y(52):scale(0.8)
							end
						}
					})
					var_2_0.textName:text("")
					var_2_0.maskPanel:visible(not arg_2_3.fight)
					var_2_0.maskPanel:get("iconMask"):hide()
					bind.touch(arg_2_0, arg_2_1, {
						methods = {
							ended = functools.partial(arg_2_0.itemClick, arg_2_1, t, arg_2_3)
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	leftBtn = {
		varname = "subBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onLeftClick")
			}
		}
	},
	rightBtn = {
		varname = "addBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRightClick")
			}
		}
	}
}

function var_0_2.onCreate(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	arg_4_0.count = itertools.size(arg_4_1)

	arg_4_0:initModel()

	arg_4_0.selectId = idler.new(arg_4_2)
	arg_4_0.datas = idlertable.new({})

	idlereasy.when(arg_4_0.selectId, function(arg_5_0, arg_5_1)
		local var_5_0 = arg_4_1[arg_5_1]
		local var_5_1 = csv.card_battle_recommend[var_5_0.csvId]
		local var_5_2 = {}

		for iter_5_0, iter_5_1 in ipairs(var_5_1.cards) do
			local var_5_3 = csv.cards[iter_5_1]
			local var_5_4 = var_5_3.cardMarkID
			local var_5_5 = arg_4_3[var_5_4] and (arg_4_3[var_5_4][var_5_3.branch] or arg_4_3[var_5_4][0])
			local var_5_6 = var_5_5 and var_5_5.cardId or iter_5_1
			local var_5_7 = csv.cards[var_5_6]
			local var_5_8 = csv.unit[var_5_7.unitID]
			local var_5_9 = var_5_5 or {
				cardId = var_5_6,
				name = var_5_7.name,
				rarity = var_5_8.rarity
			}

			var_5_9.isCoreMark = var_5_1.coreMark[iter_5_0] == 1

			table.insert(var_5_2, var_5_9)
		end

		arg_4_0.datas:set(var_5_2)
		arg_4_0:setLeftPanel(var_5_0)
		arg_4_0:setRightPanel(var_5_0)
	end)
	Dialog.onCreate(arg_4_0)
end

function var_0_2.initModel(arg_6_0)
	arg_6_0.cards = gGameModel.role:getIdler("cards")
	arg_6_0.battleCards = gGameModel.role:getIdler("battle_cards")
	arg_6_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_6_0.roleLv = gGameModel.role:getIdler("level")
end

function var_0_2.onRightClick(arg_7_0)
	local var_7_0 = arg_7_0.selectId:read() + 1

	arg_7_0.selectId:set(var_7_0 > arg_7_0.count and 1 or var_7_0)
end

function var_0_2.onLeftClick(arg_8_0)
	local var_8_0 = arg_8_0.selectId:read() - 1

	arg_8_0.selectId:set(var_8_0 < 1 and arg_8_0.count or var_8_0)
end

function var_0_2.setLeftPanel(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1.cardData
	local var_9_1 = arg_9_0.leftPanel:multiget("cardIcon", "rarityIcon", "imgSpecialMark", "textName", "bg")
	local var_9_2 = var_9_1.bg:size()
	local var_9_3 = ccui.Scale9Sprite:create()

	var_9_3:initWithFile(cc.rect(0, 0, 0, 0), "city/card/battle_recommend/mask_jlzs.png")
	var_9_3:size(var_9_2.width - 5, var_9_2.height):alignCenter(var_9_2):xy(var_9_1.bg:x() - 160, var_9_1.bg:y() - 414):scale(2)

	local var_9_4 = cc.Sprite:create(var_9_0.icon)
	local var_9_5 = var_9_4:size()
	local var_9_6 = cc.rect((var_9_5.width - var_9_2.width) / 2, (var_9_5.height - var_9_2.height) / 2, var_9_2.width, var_9_2.height)

	var_9_4:alignCenter(var_9_2):scale(2):setTextureRect(var_9_6)
	arg_9_0.leftPanel:removeChildByName("clipping")
	cc.ClippingNode:create(var_9_3):setAlphaThreshold(0.1):size(var_9_2):alignCenter(arg_9_0.leftPanel:size()):xy(var_9_1.cardIcon:x(), var_9_1.cardIcon:y()):add(var_9_4):addTo(arg_9_0.leftPanel, 1, "clipping")
	var_9_1.cardIcon:texture(var_9_0.icon):hide()
	var_9_1.rarityIcon:texture(ui.RARITY_ICON[var_9_0.rarity])
	var_9_1.imgSpecialMark:hide()
	var_9_1.textName:text(var_9_0.name)
end

function var_0_2.setRightPanel(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.rightPanel:multiget("attrIcon", "attrText", "titleBg1", "titleBg2", "titleBg3", "list")
	local var_10_1 = csv.card_battle_recommend[arg_10_1.csvId]

	var_10_0.attrText:text(var_10_1.name)
	var_10_0.attrIcon:texture(arg_10_1.attrIcon)
	var_10_0.titleBg2:get("textTitle"):text(var_10_1.coreEffectName)

	local var_10_2 = var_0_0("#C0x57472E#" .. var_10_1.features, 40, -15, var_10_0.titleBg1, 1160)
	local var_10_3 = var_0_0("#C0x57472E#" .. var_10_1.coreEffect, 40, -15, var_10_0.titleBg2, 1160)

	var_10_0.titleBg2:y(var_10_0.titleBg1:y() - 104 - var_10_2:size().height)
	var_10_0.titleBg3:y(var_10_0.titleBg2:y() - 104 - var_10_3:size().height)
	var_10_0.list:size(1160, 578 - var_10_2:size().height - var_10_3:size().height)

	local var_10_4 = {}

	for iter_10_0 = 1, 10 do
		if var_10_1["matchEffect" .. iter_10_0] and var_10_1["matchEffect" .. iter_10_0] ~= "" then
			table.insert(var_10_4, {
				verticalSpace = 10,
				str = "#C0x57472E#" .. var_10_1["matchEffect" .. iter_10_0]
			})
		end
	end

	beauty.textScroll({
		isRich = true,
		list = var_10_0.list,
		strs = var_10_4
	})
end

function var_0_2.onItemClick(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	gGameUI:stackUI("city.handbook.view", nil, {
		full = true
	}, {
		cardId = arg_11_4.cardId
	})
end

return var_0_2
