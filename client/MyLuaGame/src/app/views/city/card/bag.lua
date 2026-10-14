local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("CardBagView", var_0_0)
local var_0_2 = {
	FRAGMENT = 2,
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
			name = gLanguageCsv.level
		},
		{
			val = 3,
			name = gLanguageCsv.rarity
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
local var_0_4 = {
	"advance",
	"effortValue",
	"equipStar",
	"equipStrengthen",
	"equipAwake",
	"equipSignet",
	"star",
	"skill",
	"nvalue",
	"cardFeel",
	"cardDevelop",
	"gemFreeExtract",
	"canZawake"
}
local var_0_5 = {
	"star"
}

local function var_0_6(arg_1_0, arg_1_1, arg_1_2)
	arg_1_2 = arg_1_2 or {}

	local var_1_0 = arg_1_0:size()

	if arg_1_0:get("star") then
		arg_1_0:get("star"):removeFromParent()
	end

	local var_1_1 = ccui.Layout:create():size(var_1_0.width, 70):align(cc.p(0, 0), 0, 0):addTo(arg_1_0, 50, "star"):xy(100, 96)

	if tonumber(arg_1_1) then
		local var_1_2 = arg_1_2.starInterval or 45
		local var_1_3 = arg_1_1 > 6 and 6 or arg_1_1
		local var_1_4 = arg_1_1 - 6
		local var_1_5 = var_1_4 >= 0 and 0 or (0 - var_1_4) * 45 / 2

		for iter_1_0 = 1, var_1_3 do
			local var_1_6 = dataEasy.getStarRes(arg_1_1, iter_1_0)

			ccui.ImageView:create(var_1_6):xy(var_1_2 * (iter_1_0 - 1) + var_1_5, 0):addTo(var_1_1, 400, "star"):scale(0.4)
		end
	end
end

local function var_0_7(arg_2_0, arg_2_1, arg_2_2)
	if next(arg_2_0) == nil then
		return {}
	end

	for iter_2_0, iter_2_1 in pairs(arg_2_0) do
		if iter_2_1.num then
			iter_2_1.numPercent = iter_2_1.num / iter_2_1.maxNum
		end
	end

	local var_2_0 = {
		"fight",
		"level",
		"rarity",
		"star",
		"getTime",
		"num",
		"numPercent"
	}

	if arg_2_1 == nil then
		table.sort(arg_2_0, function(arg_3_0, arg_3_1)
			for iter_3_0 = 1, 4 do
				if arg_3_0[var_2_0[iter_3_0]] ~= arg_3_1[var_2_0[iter_3_0]] then
					return arg_3_0[var_2_0[iter_3_0]] > arg_3_1[var_2_0[iter_3_0]]
				end
			end

			return arg_3_0[var_2_0[5]] > arg_3_1[var_2_0[5]]
		end)
	else
		table.sort(arg_2_0, function(arg_4_0, arg_4_1)
			if arg_4_0.isBg ~= arg_4_1.isBg then
				return arg_4_0.isBg
			end

			if arg_4_0[var_2_0[arg_2_1]] ~= arg_4_1[var_2_0[arg_2_1]] then
				if arg_2_2 then
					return arg_4_0[var_2_0[arg_2_1]] > arg_4_1[var_2_0[arg_2_1]]
				else
					return arg_4_0[var_2_0[arg_2_1]] < arg_4_1[var_2_0[arg_2_1]]
				end
			end

			if arg_4_0.markId ~= arg_4_1.markId then
				return arg_4_0.markId < arg_4_1.markId
			end

			if arg_4_0.fight and arg_4_1.fight then
				return arg_4_0.fight > arg_4_1.fight
			end

			if arg_4_0.id and arg_4_1.id then
				return arg_4_0.id > arg_4_1.id
			end

			return false
		end)
	end

	return arg_2_0
end

local function var_0_8(arg_5_0, arg_5_1)
	if next(arg_5_0) == nil then
		return {}
	end

	if arg_5_1 == nil or arg_5_1[2] == nil then
		return arg_5_0
	end

	local function var_5_0(arg_6_0, arg_6_1, arg_6_2)
		if arg_6_0[arg_6_1] == nil and (arg_6_1 ~= "attr2" or arg_6_0.attr1 == arg_6_2) then
			return true
		end

		if arg_6_1 == "atkType" then
			for iter_6_0, iter_6_1 in ipairs(arg_6_0.atkType) do
				if arg_6_2[iter_6_1] then
					return true
				end
			end

			return false
		end

		if arg_6_0[arg_6_1] == arg_6_2 then
			return true
		end

		return false
	end

	local var_5_1 = {}

	for iter_5_0, iter_5_1 in pairs(arg_5_0) do
		if var_5_0(iter_5_1, arg_5_1[1], arg_5_1[2]) then
			table.insert(var_5_1, iter_5_1)
		end
	end

	return var_5_1
end

local function var_0_9(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0

	for iter_7_0 = 1, #arg_7_1 do
		var_7_0 = var_0_8(var_7_0, arg_7_1[iter_7_0])
	end

	return var_7_0
end

local function var_0_10(arg_8_0)
	arg_8_0:setScrollBarEnabled(true)
	arg_8_0:setScrollBarColor(cc.c3b(255, 200, 0))
	arg_8_0:setScrollBarOpacity(255)
	arg_8_0:setScrollBarWidth(10)
	arg_8_0:setScrollBarPositionFromCorner(cc.p(100, 40))
end

local function var_0_11(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_1.bg:size()
	local var_9_1 = 80
	local var_9_2 = ccui.Scale9Sprite:create()
	local var_9_3 = dataEasy.getCardIdAndStar(arg_9_2.id)

	var_9_2:initWithFile(cc.rect(82, 82, 1, 1), "common/icon/mask_card.png")
	var_9_2:size(var_9_0.width - 39, var_9_0.height - 45):alignCenter(var_9_0)

	local var_9_4 = csv.cards[var_9_3]

	arg_9_1.material:visible(var_9_4 and var_9_4.cardType == 2)

	local var_9_5 = cc.Sprite:create(arg_9_2.icon)
	local var_9_6 = var_9_5:size()
	local var_9_7 = cc.p(arg_9_2.posOffset.x / arg_9_2.scale, -arg_9_2.posOffset.y / arg_9_2.scale)
	local var_9_8 = cc.size(var_9_0.width / arg_9_2.scale, var_9_0.height / arg_9_2.scale)
	local var_9_9 = cc.rect((var_9_6.width - var_9_8.width) / 2 - var_9_7.x, (var_9_6.height - var_9_8.height) / 2 - var_9_7.y, var_9_8.width, var_9_8.height)

	var_9_5:alignCenter(var_9_0):scale(arg_9_2.scale + 0.2):setTextureRect(var_9_9)
	arg_9_0:removeChildByName("clipping")
	cc.ClippingNode:create(var_9_2):setAlphaThreshold(0.1):size(var_9_0):alignCenter(arg_9_0:size()):add(var_9_5):addTo(arg_9_0, 5, "clipping")
	arg_9_1.qulityNumber:hide()
	uiEasy.setIconName("card", var_9_3, {
		advance = 1,
		space = true,
		node = arg_9_1.levelNamePanel:get("name"),
		name = arg_9_2.name
	})
	text.addEffect(arg_9_1.levelNamePanel:get("name"), {
		color = ui.COLORS.NORMAL.WHITE
	})
	arg_9_1.fightPointPanel:get("fightPoint"):text(arg_9_2.fight)
	arg_9_1.levelNamePanel:get("level"):text(arg_9_2.level)
	arg_9_1.namebg:z(arg_9_1.levelNamePanel:z() - 1)
	adapt.oneLineCenterPos(cc.p(200, 10), {
		arg_9_1.fightPointPanel:get("fightPointTxt"),
		arg_9_1.fightPointPanel:get("fightPoint")
	}, cc.p(15, 0))
	adapt.oneLineCenterPos(cc.p(200, 13), {
		arg_9_1.levelNamePanel:get("level"),
		arg_9_1.levelNamePanel:get("name")
	}, cc.p(16, 0))
	arg_9_1.bg:texture(string.format("common/icon/panel_card_%d.png", arg_9_2.rarity + 2))
	arg_9_1.bottomBg:texture(string.format("city/card/bag/box_bottom_d%d.png", arg_9_2.rarity + 2))
	arg_9_1.rarity:texture(ui.RARITY_ICON[arg_9_2.rarity]):scale(1)

	if arg_9_2.isBg then
		widget.addAnimationByKey(arg_9_1.maskBg, "effect/duiwuzhong.skel", "effect", "effect_loop", 20):xy(var_9_0.width / 2 - 30, var_9_0.height / 2 + 45):scale(1, 1.6666666666666667)
	end

	arg_9_1.attr1:texture(ui.ATTR_ICON[arg_9_2.attr1])

	if arg_9_2.attr2 == nil then
		arg_9_1.attr2:hide()
	else
		arg_9_1.attr2:texture(ui.ATTR_ICON[arg_9_2.attr2]):show()
	end
end

local function var_0_12(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_1.maskBg:size()
	local var_10_1 = ccui.Scale9Sprite:create()
	local var_10_2 = dataEasy.getCfgByKey(arg_10_2.id)
	local var_10_3 = var_10_2.quality
	local var_10_4 = uiEasy.setIconName(arg_10_2.id)

	var_10_1:initWithFile(cc.rect(82, 82, 1, 1), "common/icon/mask_card.png")
	var_10_1:size(var_10_0.width - 20, var_10_0.height - 20):alignCenter(var_10_0)

	local var_10_5 = csv.cards[var_10_2.combID]

	arg_10_1.material:visible(var_10_5 and var_10_5.cardType == 2)

	local var_10_6 = cc.Sprite:create(arg_10_2.icon)
	local var_10_7 = var_10_6:size()
	local var_10_8 = cc.p(arg_10_2.posOffset.x / arg_10_2.scale, -arg_10_2.posOffset.y / arg_10_2.scale)
	local var_10_9 = cc.size(var_10_0.width / arg_10_2.scale, var_10_0.height / arg_10_2.scale)
	local var_10_10 = cc.rect((var_10_7.width - var_10_9.width) / 2 - var_10_8.x, (var_10_7.height - var_10_9.height) / 2 - var_10_8.y, var_10_9.width, var_10_9.height)

	var_10_6:alignCenter(var_10_0):scale(arg_10_2.scale + 0.2):setTextureRect(var_10_10)
	cc.ClippingNode:create(var_10_1):setAlphaThreshold(0.1):size(var_10_0):alignCenter(arg_10_0:size()):add(var_10_6):addTo(arg_10_0, 5)
	arg_10_1.name:text(var_10_4)
	text.addEffect(arg_10_1.name, {
		color = ui.COLORS.NORMAL.WHITE
	})
	arg_10_1.numBg:get("num"):text(arg_10_2.num .. "/" .. arg_10_2.maxNum)
	arg_10_1.bottomBg:z(arg_10_1.name:z() - 1)
	adapt.oneLineCenterPos(cc.p(180, 28), {
		arg_10_1.numBg:get("numTitle"),
		arg_10_1.numBg:get("num")
	}, cc.p(2, 4))
	arg_10_1.rarity:texture(ui.RARITY_ICON[arg_10_2.rarity])

	if arg_10_2.isBg then
		arg_10_1.rarity:z(11):color(cc.c3b(200, 200, 200))
	end

	arg_10_1.attr1:texture(ui.ATTR_ICON[arg_10_2.attr1])

	if arg_10_2.attr2 == nil then
		arg_10_1.attr2:hide()
	else
		arg_10_1.attr2:texture(ui.ATTR_ICON[arg_10_2.attr2]):show()
	end
end

var_0_1.RESOURCE_FILENAME = "card_bag.json"
var_0_1.RESOURCE_BINDING = {
	panelBtn = "panelBtn",
	["centerPanel.cardItem"] = "cardItem",
	["centerPanel.subList"] = "subList",
	["centerPanel.fragItem"] = "fragItem",
	["capacityPanel.numText"] = "capacityNumText",
	["centerPanel.empty"] = "showEmpty",
	["panelBtn.line"] = "line",
	["centerPanel.slider"] = "slider",
	["capacityPanel.text"] = "capacityText",
	capacityPanel = {
		varname = "capacityPanel",
		binds = {
			event = "visible",
			idler = bindHelper.self("showBottomRight")
		}
	},
	["capacityPanel.btn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAddClick")
			}
		}
	},
	btnBattleRecommend = {
		varname = "btnBattleRecommend",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBattleRecommendClick")
			}
		}
	},
	["btnBattleRecommend.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["panelBtn.btn1"] = {
		varname = "btnSprite",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_11_0)
					return arg_11_0:onChangeClick(1)
				end)
			}
		}
	},
	["panelBtn.btn2"] = {
		varname = "btnFragment",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_12_0)
						return arg_12_0:onChangeClick(2)
					end)
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "bottomFragment",
					listenData = {
						type = bindHelper.self("type")
					},
					onNode = function(arg_13_0)
						arg_13_0:xy(105, 105):scale(0.66)
					end
				}
			}
		}
	},
	["panelBtn.btn3"] = {
		varname = "btnDecompose",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onEnterDecompose")
				}
			},
			{
				event = "visible",
				idler = bindHelper.self("cardRebornListen")
			}
		}
	},
	centerPanel = {
		varname = "centerPanel",
		binds = {
			event = "extend",
			class = "sort_menus",
			props = {
				width = 310,
				height = 80,
				expandUp = true,
				data = bindHelper.self("sortTabData"),
				showSelected = bindHelper.self("sortKey"),
				btnClick = bindHelper.self("onSortMenusBtnClick", true),
				showSortList = bindHelper.self("isDownListShow"),
				onNode = bindHelper.self("onSortMenusNode", true)
			}
		}
	},
	["centerPanel.cardList"] = {
		varname = "cardList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 18,
				leftPadding = 5,
				data = bindHelper.self("cardDatas"),
				columnSize = bindHelper.self("columnSize"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("cardItem"),
				sliderBg = bindHelper.self("slider"),
				itemAction = {
					alwaysShow = true,
					duration = 0.3,
					isAction = true,
					actionTime = 0.5
				},
				onCell = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
					local var_14_0 = arg_14_1:multiget("bg", "attr1", "attr2", "levelNamePanel", "material", "fightPointPanel", "rarity", "maskBg", "qulityNumber", "bottomBg", "imgLock", "namebg")

					var_0_11(arg_14_1, var_14_0, arg_14_3)
					var_0_6(arg_14_1, arg_14_3.star)
					var_14_0.imgLock:visible(arg_14_3.lock)
					var_14_0.maskBg:visible(arg_14_3.isBg)
					arg_14_1:removeChildByName("isNew")

					if not arg_14_3.isBg and arg_14_3.isNew then
						ccui.ImageView:create("other/gain_sprite/txt_new.png"):alignCenter(arg_14_1:size()):addTo(arg_14_1, 11, "isNew")
					end

					local var_14_1 = arg_14_0:getIdx(arg_14_2)

					arg_14_1:setName("cardItem" .. var_14_1.k)

					local var_14_2 = {
						class = "red_hint",
						props = {
							state = arg_14_3.selectEffect == nil,
							listenData = {
								selectDbId = arg_14_3.dbid
							},
							specialTag = arg_14_3.isBg and var_0_4 or var_0_5,
							onNode = function(arg_15_0)
								arg_15_0:xy(405, 495)
							end
						}
					}

					bind.extend(arg_14_0, arg_14_1, var_14_2)
					bind.touch(arg_14_0, arg_14_1, {
						methods = {
							ended = functools.partial(arg_14_0.itemClick, arg_14_1, var_14_1, arg_14_3)
						}
					})
				end,
				onBeforeBuild = function(arg_16_0)
					if arg_16_0.sliderBg:visible() then
						local var_16_0, var_16_1 = arg_16_0:xy()
						local var_16_2 = arg_16_0:size()
						local var_16_3, var_16_4 = arg_16_0.sliderBg:xy()
						local var_16_5 = arg_16_0.sliderBg:size()

						arg_16_0:setScrollBarEnabled(true)
						arg_16_0:setScrollBarColor(cc.c3b(245, 156, 2))
						arg_16_0:setScrollBarOpacity(255)
						arg_16_0:setScrollBarAutoHideEnabled(false)
						arg_16_0:setScrollBarPositionFromCorner(cc.p(25, (var_16_2.height - var_16_5.height) / 2 - 25))
						arg_16_0.sliderBg:x(var_16_0 + var_16_2.width - 25)
						arg_16_0:setScrollBarWidth(var_16_5.width)
						arg_16_0:refreshView()
					else
						arg_16_0:setScrollBarEnabled(false)
					end
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	["centerPanel.fragList"] = {
		varname = "fragList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 18,
				leftPadding = 5,
				data = bindHelper.self("fragDatas"),
				columnSize = bindHelper.self("columnSize"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("fragItem"),
				sliderBg = bindHelper.self("slider"),
				itemAction = {
					alwaysShow = true,
					duration = 0.3,
					isAction = true,
					actionTime = 0.5
				},
				onCell = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
					local var_17_0 = arg_17_1:multiget("bg", "attr1", "attr2", "name", "rarity", "numBg", "maskBg", "fragBg", "bottomBg", "material")

					var_0_12(arg_17_1, var_17_0, arg_17_3)

					if arg_17_3.isBg then
						var_17_0.bg:texture("common/icon/panel_card_1.png")
						var_17_0.maskBg:show()

						local var_17_1 = csv.fragments[arg_17_3.id]
						local var_17_2 = csv.cards[var_17_1.combID]

						var_17_0.name:text(var_17_2.name)
						widget.addAnimationByKey(arg_17_1, "effect/jinglingbeibao.skel", "jinglingbeibao", "effect_loop", 10):anchorPoint(cc.p(0.5, 0.5)):xy(arg_17_1:width() / 2 + 1, arg_17_1:height() / 2 + 1)
					else
						var_17_0.bg:texture("common/icon/panel_card.png")
						var_17_0.maskBg:hide()
					end

					local var_17_3 = {
						class = "red_hint",
						props = {
							state = arg_17_3.selectEffect == nil and arg_17_3.isBg,
							onNode = function(arg_18_0)
								arg_18_0:xy(405, 495)
							end
						}
					}

					bind.extend(arg_17_0, arg_17_1, var_17_3)
					var_17_0.fragBg:visible(not arg_17_3.isBg)

					local var_17_4 = arg_17_0:getIdx(arg_17_2)

					arg_17_1:setName("fragItem" .. var_17_4.k)
					bind.touch(arg_17_0, arg_17_1, {
						methods = {
							ended = functools.partial(arg_17_0.itemClick, arg_17_1, var_17_4, arg_17_3)
						}
					})
				end,
				onBeforeBuild = function(arg_19_0)
					if arg_19_0.sliderBg:visible() then
						local var_19_0, var_19_1 = arg_19_0:xy()
						local var_19_2 = arg_19_0:size()
						local var_19_3, var_19_4 = arg_19_0.sliderBg:xy()
						local var_19_5 = arg_19_0.sliderBg:size()

						arg_19_0:setScrollBarEnabled(true)
						arg_19_0:setScrollBarColor(cc.c3b(245, 156, 2))
						arg_19_0:setScrollBarOpacity(255)
						arg_19_0:setScrollBarAutoHideEnabled(false)
						arg_19_0:setScrollBarPositionFromCorner(cc.p(var_19_0 + var_19_2.width - var_19_3, (var_19_2.height - var_19_5.height) / 2 + 5))
						arg_19_0:setScrollBarWidth(var_19_5.width)
						arg_19_0:refreshView()
					else
						arg_19_0:setScrollBarEnabled(false)
					end
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	}
}

function var_0_1.resetListSlider(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_1 == var_0_2.CARD and arg_20_0.cardDatas:size() or arg_20_0.fragDatas:size()
	local var_20_1 = arg_20_1 == var_0_2.CARD and arg_20_0.cardList or arg_20_0.fragList
	local var_20_2 = var_20_0 > arg_20_0.columnSize * 2

	arg_20_0.slider:setVisible(var_20_2)
	var_20_1:setScrollBarEnabled(var_20_2)
end

function var_0_1.onCreate(arg_21_0, arg_21_1)
	arg_21_0:initModel()
	gGameUI.topuiManager:createView("title", arg_21_0, {
		onClose = arg_21_0:createHandler("onClose")
	}):init({
		subTitle = "PIXIE BACKPACK",
		title = "common/txt/txt_bt_renzhebeibao.png"
	})

	arg_21_0.cardRebornListen = dataEasy.getListenShow(gUnlockCsv.cardReborn)
	arg_21_0.attr1 = idler.new()
	arg_21_0.attr2 = idler.new()
	arg_21_0.rarity = idler.new()
	arg_21_0.atkType = idlertable.new({})
	arg_21_0.isDownListShow = idler.new(false)
	arg_21_0.refreshSign = true
	arg_21_0.filterPanel = gGameUI:createView("city.card.bag_filter", arg_21_0:getResourceNode()):init({
		cb = arg_21_0:createHandler("onBagFilter"),
		showIdler = arg_21_0:createHandler("isDownListShow"),
		others = {
			panelOrder = true,
			panelOffsetX = 330,
			y = 125,
			x = 1889 + display.uiOrigin.x
		}
	}):x(display.uiOrigin.x):z(100)

	local var_21_0, var_21_1 = adapt.centerWithScreen("left", "right", {
		itemWidthExtra = 200,
		itemWidth = arg_21_0.cardItem:size().width
	}, {
		{
			arg_21_0.panelBtn,
			"pos",
			"left"
		},
		{
			arg_21_0.filterPanel.filterBtn,
			"pos",
			"right"
		},
		{
			arg_21_0.btnBattleRecommend,
			"pos",
			"right"
		},
		{
			arg_21_0.capacityPanel,
			"pos",
			"right"
		},
		{
			arg_21_0.slider,
			"pos",
			"right"
		},
		{
			arg_21_0.centerPanel,
			"width"
		},
		{
			{
				arg_21_0.subList,
				arg_21_0.cardList,
				arg_21_0.fragList
			},
			"width"
		},
		{
			{
				arg_21_0.subList,
				arg_21_0.cardList,
				arg_21_0.fragList
			},
			"pos",
			"left"
		}
	})

	arg_21_0.deltaWidth = var_21_0 or 0
	arg_21_0.columnSize = 5 + var_21_1
	arg_21_0.cardDatas = idlertable.new({})
	arg_21_0.fragDatas = idlertable.new({})
	arg_21_0.showBottomRight = idler.new(true)
	arg_21_0.sortOrder = idler.new(true)
	arg_21_0.type = idler.new(arg_21_1 or var_0_2.CARD)
	arg_21_0.sortKey = idler.new(1)
	arg_21_0.sortTabData = idlertable.new()
	arg_21_0.sortTabDataIndex = idler.new()

	idlereasy.when(arg_21_0.type, function(arg_22_0, arg_22_1)
		arg_21_0.cardList:visible(arg_22_1 == var_0_2.CARD)
		arg_21_0.fragList:visible(arg_22_1 == var_0_2.FRAGMENT)
		arg_21_0.slider:setVisible(true)
		arg_21_0.btnSprite:setBright(arg_22_1 ~= var_0_2.CARD)
		arg_21_0.btnSprite:get("tip"):setVisible(arg_22_1 == var_0_2.CARD)
		arg_21_0.btnSprite:get("imgIcon"):setVisible(arg_22_1 == var_0_2.CARD)
		arg_21_0.btnSprite:setTouchEnabled(arg_22_1 ~= var_0_2.CARD)
		arg_21_0.btnFragment:setBright(arg_22_1 ~= var_0_2.FRAGMENT)
		arg_21_0.btnFragment:get("tip"):setVisible(arg_22_1 == var_0_2.FRAGMENT)
		arg_21_0.btnFragment:get("imgIcon"):setVisible(arg_22_1 == var_0_2.FRAGMENT)
		arg_21_0.btnFragment:setTouchEnabled(arg_22_1 ~= var_0_2.FRAGMENT)

		local var_22_0 = ui.COLORS.NORMAL.WHITE
		local var_22_1 = ui.COLORS.NORMAL.WHITE
		local var_22_2 = ui.NEWCOLORS.OUTLINE.BLUE
		local var_22_3 = ui.NEWCOLORS.OUTLINE.BLUE

		if arg_22_1 == var_0_2.CARD then
			local var_22_4 = ui.COLORS.NORMAL.WHITE
			local var_22_5 = ui.NEWCOLORS.OUTLINE.YELLOW
		end

		if arg_22_1 == var_0_2.FRAGMENT then
			local var_22_6 = ui.COLORS.NORMAL.WHITE
			local var_22_7 = ui.NEWCOLORS.OUTLINE.YELLOW
		end
	end)
	idlereasy.any({
		arg_21_0.type,
		arg_21_0.rarity
	}, function(arg_23_0, arg_23_1, arg_23_2)
		arg_21_0.showBottomRight:set(arg_23_1 == var_0_2.CARD)

		local var_23_0

		if arg_23_1 == var_0_2.CARD then
			var_23_0 = ui.RARITY_ICON[arg_23_2] and 2 or 1
		else
			var_23_0 = ui.RARITY_ICON[arg_23_2] and 4 or 3
		end

		arg_21_0.sortTabDataIndex:set(var_23_0)

		local var_23_1 = {}

		for iter_23_0, iter_23_1 in pairs(var_0_3[var_23_0]) do
			table.insert(var_23_1, iter_23_1.name)
		end

		arg_21_0.sortTabData:set(var_23_1)
		arg_21_0.sortKey:set(1)
		arg_21_0.sortOrder:set(true)
	end)
	idlereasy.any({
		arg_21_0.cardCapacity,
		arg_21_0.cards
	}, function(arg_24_0, arg_24_1, arg_24_2)
		arg_21_0.capacityNumText:text(#arg_24_2 .. "/" .. arg_24_1)
		adapt.oneLinePos(arg_21_0.capacityNumText, arg_21_0.capacityText, cc.p(0, 0), "right")
	end)

	arg_21_0.cardInfos = idlertable.new({})

	local var_21_2 = {}
	local var_21_3 = 0

	idlereasy.any({
		arg_21_0.cards,
		arg_21_0.battleCards
	}, function(arg_25_0, arg_25_1, arg_25_2)
		if arg_21_0.refreshSign then
			arg_21_0:refushBagData()
		end
	end)
	idlereasy.when(gGameModel.cards:getNewFlags(), function(arg_26_0, arg_26_1)
		arg_21_0.cardInfos:modify(function(arg_27_0)
			local var_27_0 = false

			for iter_27_0, iter_27_1 in ipairs(arg_27_0) do
				local var_27_1 = stringz.bintohex(iter_27_1.dbid)
				local var_27_2 = arg_26_1[var_27_1] or false

				var_27_0 = var_27_0 or iter_27_1.isNew ~= var_27_2
				iter_27_1.isNew = var_27_2
			end

			return var_27_0, arg_27_0
		end)
	end, true)

	arg_21_0.fragInfos = idlertable.new()

	idlereasy.when(arg_21_0.frags, function(arg_28_0, arg_28_1)
		local var_28_0 = {}

		for iter_28_0, iter_28_1 in pairs(arg_28_1) do
			local var_28_1 = csv.fragments[iter_28_0]

			if var_28_1.type == 1 then
				local var_28_2 = csv.cards[var_28_1.combID]
				local var_28_3 = csv.unit[var_28_2.unitID]

				table.insert(var_28_0, {
					isSprite = false,
					id = iter_28_0,
					name = uiEasy.setIconName(iter_28_0),
					num = iter_28_1,
					maxNum = var_28_1.combCount,
					maxNum1 = var_28_1.stackMax,
					rarity = var_28_3.rarity,
					isBg = iter_28_1 >= var_28_1.combCount,
					attr1 = var_28_3.natureType,
					attr2 = var_28_3.natureType2,
					icon = var_28_3.cardShow,
					scale = var_28_3.cardShowScale,
					posOffset = var_28_3.cardShowPosC,
					dbid = iter_28_0,
					atkType = var_28_2.atkType
				})
			end
		end

		arg_21_0.fragInfosChange = true

		arg_21_0.fragInfos:set(var_28_0)
	end)

	local var_21_4 = idler.new(true)
	local var_21_5 = idlereasyArgs.new(arg_21_0, "sortTabDataIndex", "cardInfos", "fragInfos", "type", "sortKey", "sortOrder", "rarity", "attr1", "attr2", "atkType")
	local var_21_6 = 0

	idlereasy.any(var_21_5, function(...)
		var_21_6 = var_21_6 + 1

		performWithDelay(arg_21_0, function()
			if var_21_6 > 0 then
				var_21_4:notify()

				var_21_6 = 0
			end
		end, 0)
	end)
	idlerflow.if_(var_21_4):do_(function(arg_31_0)
		local var_31_0

		if arg_31_0.type == var_0_2.CARD then
			var_31_0 = arg_31_0.cardInfos
		else
			var_31_0 = arg_31_0.fragInfos
		end

		if var_0_3[arg_31_0.sortTabDataIndex][arg_31_0.sortKey] then
			local var_31_1 = var_0_3[arg_31_0.sortTabDataIndex][arg_31_0.sortKey].val

			arg_21_0:sortFilterData(arg_31_0.type, var_31_0, var_31_1, arg_31_0.sortOrder, {
				{
					"rarity",
					ui.RARITY_ICON[arg_31_0.rarity] and arg_31_0.rarity
				},
				{
					"attr2",
					ui.ATTR_ICON[arg_31_0.attr2] and arg_31_0.attr2
				},
				{
					"attr1",
					ui.ATTR_ICON[arg_31_0.attr1] and arg_31_0.attr1
				},
				{
					"atkType",
					arg_31_0.atkType
				}
			})
		end
	end, var_21_5)
	uiEasy.updateUnlockRes(gUnlockCsv.cardReborn, arg_21_0.btnDecompose, {
		pos = cc.p(arg_21_0.btnDecompose:width() - 20, 100)
	})

	local var_21_7 = nodetools.multiget(arg_21_0:getResourceNode(), {
		"bg"
	})

	effect.captureForBackgroud(arg_21_0, unpack(var_21_7))
	dataEasy.getListenUnlock(gUnlockCsv.battleRecommend, function(arg_32_0)
		arg_21_0.btnBattleRecommend:visible(false)
	end)
end

function var_0_1.initModel(arg_33_0)
	arg_33_0.cards = gGameModel.role:getIdler("cards")
	arg_33_0.frags = gGameModel.role:getIdler("frags")
	arg_33_0.cardCapacity = gGameModel.role:getIdler("card_capacity")
	arg_33_0.battleCards = gGameModel.role:getIdler("battle_cards")
	arg_33_0.rmb = gGameModel.role:getIdler("rmb")
	arg_33_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_33_0.cardCapacityTimes = gGameModel.role:getIdler("card_capacity_times")
	arg_33_0.roleLv = gGameModel.role:getIdler("level")
end

function var_0_1.refushBagData(arg_34_0)
	local var_34_0 = arg_34_0.cards:read()
	local var_34_1 = arg_34_0.battleCards:read()
	local var_34_2 = itertools.map(itertools.ivalues(var_34_1), function(arg_35_0, arg_35_1)
		return arg_35_1, arg_35_0
	end)
	local var_34_3 = {}

	for iter_34_0, iter_34_1 in ipairs(var_34_0) do
		local var_34_4 = gGameModel.cards:find(iter_34_1)

		if var_34_4 then
			local var_34_5 = var_34_4:read("card_id", "unit_id", "skin_id", "fighting_point", "level", "star", "advance", "locked", "name", "created_time", "equips", "effort_values")
			local var_34_6 = csv.cards[var_34_5.card_id]
			local var_34_7 = dataEasy.getUnitCsv(var_34_5.card_id, var_34_5.skin_id)

			var_34_3[iter_34_0] = {
				isSprite = true,
				id = var_34_5.card_id,
				markId = var_34_6.cardMarkID,
				name = var_34_5.name,
				rarity = var_34_7.rarity,
				isBg = var_34_2[iter_34_1] and true or false,
				isNew = gGameModel.cards:isNew(iter_34_1),
				attr1 = var_34_7.natureType,
				attr2 = var_34_7.natureType2,
				fight = var_34_5.fighting_point,
				level = var_34_5.level,
				star = var_34_5.star,
				getTime = var_34_5.created_time,
				icon = var_34_7.cardShow,
				scale = var_34_7.cardShowScale,
				posOffset = var_34_7.cardShowPosC,
				advance = var_34_5.advance,
				dbid = iter_34_1,
				lock = var_34_5.locked,
				equips = var_34_5.equips,
				effortValue = var_34_5.effort_values,
				atkType = var_34_6.atkType
			}
		end
	end

	arg_34_0.cardInfos:set(var_34_3)
end

function var_0_1.sortFilterData(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5)
	local var_36_0 = var_0_9(arg_36_2, arg_36_5)
	local var_36_1 = var_0_7(var_36_0, arg_36_3, arg_36_4)

	if next(var_36_1) == nil then
		local var_36_2 = next(arg_36_2) == nil and arg_36_1 ~= var_0_2.CARD and gLanguageCsv.cardBagNoFrags or gLanguageCsv.filteringIsEmpty

		arg_36_0.showEmpty:show()
		arg_36_0.showEmpty:get("txt"):text(var_36_2)
	else
		arg_36_0.showEmpty:hide()
	end

	if arg_36_1 == var_0_2.CARD then
		local var_36_3

		if arg_36_0.cardCenterDbid then
			for iter_36_0, iter_36_1 in ipairs(var_36_1) do
				if iter_36_1.dbid == arg_36_0.cardCenterDbid then
					var_36_3 = iter_36_0

					break
				end
			end
		end

		arg_36_0.cardList.preloadCenterIndex = var_36_3 and math.ceil(var_36_3 / arg_36_0.columnSize)

		arg_36_0.cardDatas:set(var_36_1, true)
	else
		if arg_36_0.fragInfosChange then
			dataEasy.tryCallFunc(arg_36_0.fragList, "updatePreloadCenterIndex")
		end

		arg_36_0.fragDatas:set(var_36_1, true)
	end

	arg_36_0.fragInfosChange = false

	arg_36_0:resetListSlider(arg_36_1)
end

function var_0_1.onItemClick(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
	if arg_37_4.isSprite then
		gGameUI:stackUI("city.card.strengthen", nil, {
			full = true
		}, 1, arg_37_4.dbid)
	elseif arg_37_4.isBg then
		if itertools.size(arg_37_0.cards:read()) >= arg_37_0.cardCapacity:read() then
			gGameUI:showTip(gLanguageCsv.cardBagHaveBeenFull)

			return
		end

		local var_37_0 = csv.fragments[arg_37_4.id]
		local var_37_1 = csv.cards[var_37_0.combID]
		local var_37_2 = {
			string.format("#C0x57472e#" .. gLanguageCsv.wantConsumeFragsCombCard, var_37_0.combCount, "#C0x01A001#" .. var_37_0.name .. "#C0x57472e#", "#C0x01A001#" .. var_37_1.name)
		}

		gGameUI:showDialog({
			btnType = 2,
			clearFast = true,
			isRich = true,
			content = var_37_2,
			cb = function()
				gGameApp:requestServer("/game/role/frag/comb", function(arg_39_0)
					gGameUI:stackUI("common.gain_sprite", nil, {
						full = true
					}, arg_39_0.view, nil, false, arg_37_0:createHandler("setCardCenterDbid", arg_39_0.view.db_id))
				end, arg_37_4.id)
			end
		})
	else
		gGameUI:stackUI("common.gain_way", nil, nil, arg_37_4.id, nil, arg_37_4.maxNum)
	end
end

function var_0_1.setCardCenterDbid(arg_40_0, arg_40_1)
	arg_40_0.cardCenterDbid = arg_40_1

	performWithDelay(arg_40_0, function()
		arg_40_0.cardCenterDbid = nil
	end, 0.1)
	arg_40_0.type:set(var_0_2.CARD)
end

function var_0_1.onBattleRecommendClick(arg_42_0)
	gGameUI:stackUI("city.card.battle_recommend")
end

function var_0_1.onAddClick(arg_43_0)
	gGameUI:stackUI("city.card.buy_capacity")
end

function var_0_1.buyCapacity(arg_44_0)
	gGameApp:requestServer("/game/role/card_capacity/buy", function(arg_45_0)
		gGameUI:showTip(gLanguageCsv.hasBuy)
	end)
end

function var_0_1.onChangeClick(arg_46_0, arg_46_1)
	arg_46_1 = arg_46_1 or 1

	arg_46_0.type:set(arg_46_1)
end

function var_0_1.onBagFilter(arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
	arg_47_0.attr1:set(arg_47_1)
	arg_47_0.attr2:set(arg_47_2)
	arg_47_0.rarity:set(arg_47_3)
	arg_47_0.atkType:modify(function()
		return true, arg_47_4
	end)
end

function var_0_1.onSortMenusBtnClick(arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4, arg_49_5)
	if arg_49_5 == arg_49_3 then
		arg_49_0.sortOrder:modify(function(arg_50_0)
			return true, not arg_50_0
		end)
	else
		arg_49_0.sortOrder:set(true)
	end

	arg_49_0.sortKey:set(arg_49_3)
end

function var_0_1.onSortMenusNode(arg_51_0, arg_51_1, arg_51_2)
	arg_51_2:xy(962 + arg_51_0.deltaWidth, -431):z(20)
end

function var_0_1.onEnterDecompose(arg_52_0)
	if not dataEasy.isUnlock(gUnlockCsv.cardReborn) then
		gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.cardReborn))

		return
	end

	if not gGameUI:goBackInStackUI("city.card.rebirth.view") then
		gGameUI:stackUI("city.card.rebirth.view", nil, {
			full = true
		}, 2)
	end
end

function var_0_1.onStackHide(arg_53_0, ...)
	arg_53_0.refreshSign = false

	return var_0_0.onStackHide(arg_53_0, ...)
end

function var_0_1.onStackShow(arg_54_0)
	arg_54_0.refreshSign = true

	arg_54_0:refushBagData()

	return var_0_0.onStackShow(arg_54_0)
end

return var_0_1
