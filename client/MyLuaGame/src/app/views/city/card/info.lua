local var_0_0 = class("CardInfoView", Dialog)

var_0_0.RESOURCE_FILENAME = "card_info.json"
var_0_0.RESOURCE_BINDING = {
	["rightPanel.attributePanel.upPanel.static1"] = "static1",
	["rightPanel.attributePanel.upPanel.up"] = "up",
	["leftPanel.levelNote"] = "cardLevelNote",
	["leftPanel.level"] = "cardLevel",
	["rightPanel.skillPanel"] = "skillPanel",
	["rightPanel.attributePanel.upPanel.nature"] = "nature",
	["rightPanel.attributePanel"] = "attributePanel",
	["leftPanel.gender"] = "gender",
	skillItem = "skillItem",
	["leftPanel.cardImg"] = "cardImg",
	["rightPanel.attributePanel.upPanel.upIcon"] = "upIcon",
	item = "item",
	["leftPanel.rarity"] = "rarity",
	leftPanel = "leftPanel",
	["rightPanel.attributePanel.upPanel.downIcon"] = "downIcon",
	subList = "subList",
	["rightPanel.attributePanel.upPanel.down"] = "down",
	itemNature = "itemNature",
	starItem = "starItem",
	["leftPanel.power"] = "power",
	["leftPanel.powerNote1"] = "powerNote1",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	titleTxt1 = {
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
	titleTxt2 = {
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
	["leftPanel.btnAdd"] = {
		varname = "btnAdd",
		binds = {
			event = "visible",
			idler = bindHelper.self("hasHeldItem")
		}
	},
	["leftPanel.btnAdd.bg"] = {
		binds = {
			event = "texture",
			idler = bindHelper.self("heldItemBg")
		}
	},
	["leftPanel.btnAdd.add"] = {
		varname = "icon",
		binds = {
			event = "texture",
			idler = bindHelper.self("heldItemIcon")
		}
	},
	["rightPanel.btnList"] = {
		varname = "btnList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("btn")
					local var_1_1 = var_1_0:get("txt")

					var_1_1:text(arg_1_3.name)
					var_1_0:setTouchEnabled(not arg_1_3.isSelected)
					var_1_0:setBright(not arg_1_3.isSelected)
					var_1_0:onClick(functools.partial(arg_1_0.itemClick, arg_1_2))

					if arg_1_3.isSelected then
						text.addEffect(var_1_1, {
							outline = {
								size = 2,
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							},
							color = ui.COLORS.NORMAL.YELLOW
						})
					else
						text.addEffect(var_1_1, {
							outline = {
								size = 2,
								color = ui.NEWCOLORS.OUTLINE.BLUE
							},
							color = ui.COLORS.NORMAL.WHITE
						})
					end
				end
			},
			handlers = {
				itemClick = bindHelper.self("onChangePage")
			}
		}
	},
	["rightPanel.skillPanel.list"] = {
		varname = "skillList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("skillDatas"),
				item = bindHelper.self("skillItem"),
				zawakeSkills = bindHelper.self("zawakeSkills"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("level", "name", "type", "icon", "bg", "btn", "levelNote")

					var_2_0.level:text(arg_2_3.level)
					adapt.oneLinePos(var_2_0.level, var_2_0.levelNote, cc.p(2, 0), "right")
					uiEasy.setSkillInfoToItems({
						name = var_2_0.name,
						icon = var_2_0.icon,
						type1 = var_2_0.type
					}, arg_2_3.id)
					var_2_0.bg:z(-1)
					arg_2_1:removeChildByName("zawakeBg")
					var_2_0.icon:removeChildByName("zawakeUp")

					if dataEasy.isZawakeSkill(arg_2_3.id, arg_2_0.zawakeSkills) then
						ccui.ImageView:create("city/zawake/panel_z2.png"):alignCenter(arg_2_1:size()):addTo(arg_2_1, 0, "zawakeBg")
						ccui.ImageView:create("city/drawcard/draw/txt_up.png"):scale(1.2):align(cc.p(1, 1), 200, 190):addTo(var_2_0.icon, 1, "zawakeUp")

						local var_2_1 = csv.skill[arg_2_3.id].zawakeEffect[1]

						var_2_0.name:text(csv.skill[var_2_1].skillName .. var_2_0.name:text())
					end

					bind.touch(arg_2_0, arg_2_1, {
						methods = {
							ended = functools.partial(arg_2_0.itemClick, arg_2_2, arg_2_3)
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onSkillDetail")
			}
		}
	},
	["rightPanel.attributePanel.upPanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 2,
				data = bindHelper.self("attrDatas"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("itemNature"),
				onCell = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:multiget("name", "num", "icon")

					var_3_0.name:text(arg_3_3.name .. ":")
					var_3_0.num:text(arg_3_3.num)
					var_3_0.icon:texture(arg_3_3.icon)
				end
			}
		}
	},
	["rightPanel.attributePanel.downPanel.pos"] = {
		binds = {
			event = "extend",
			class = "draw_attr",
			props = {
				bgScale = 0.85,
				type = "big",
				nvalue = bindHelper.self("nvalue"),
				offsetPos = {
					{
						x = -225,
						y = -235
					},
					{
						x = -145,
						y = -265
					},
					{
						x = -145,
						y = -365
					},
					{
						x = -225,
						y = -395
					},
					{
						y = -365,
						x = matchLanguage({
							"kr",
							"en"
						}) and -360 or -305
					},
					{
						y = -265,
						x = matchLanguage({
							"kr",
							"en"
						}) and -360 or -305
					}
				},
				offset = {
					x = 100,
					y = 150
				},
				texColor = ui.NEWCOLORS.BROWN1
			}
		}
	},
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["leftPanel.starList"] = {
		varname = "starList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("starData"),
				item = bindHelper.self("starItem"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					arg_4_1:get("img"):texture(arg_4_3.icon):scale(arg_4_3.starScale)
					arg_4_1:setTouchEnabled(false)
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_5_0, arg_5_1)
	arg_5_0.hasHeldItem = idler.new(false)
	arg_5_0.heldItemBg = idler.new("common/box/box_carry.png")
	arg_5_0.heldItemIcon = idler.new("common/btn/btn_add_icon.png")

	local var_5_0 = arg_5_1.held_item

	arg_5_0.cardData = arg_5_1
	arg_5_0.zawakeSkills = arg_5_0.cardData.zawake_skills

	local var_5_1 = 1

	if var_5_0 then
		arg_5_0.hasHeldItem:set(true)

		var_5_1 = 1

		local var_5_2 = csv.held_item.items[var_5_0.held_item_id]

		arg_5_0.heldItemIcon:set(var_5_2.icon)
		arg_5_0.heldItemBg:set(string.format("city/card/helditem/panel_icon_%d.png", var_5_2.quality))

		if csvSize(var_5_2.exclusiveCards) > 0 then
			ccui.ImageView:create("common/icon/txt_zs.png"):xy(65, 120):addTo(arg_5_0.btnAdd, 16, "exclusive")
		end

		local var_5_3 = cc.Label:createWithTTF("Lv", ui.FONT_PATH, 30):xy(154, 60):addTo(arg_5_0.btnAdd, 8, "textLv")
		local var_5_4 = cc.Label:createWithTTF(var_5_0.level, ui.FONT_PATH, 30):xy(154, 60):addTo(arg_5_0.btnAdd, 8, "textLvNum")

		text.addEffect(var_5_3, {
			outline = {
				color = ui.NEWCOLORS.OUTLINE.BLACK
			}
		})
		text.addEffect(var_5_4, {
			outline = {
				color = ui.NEWCOLORS.OUTLINE.BLACK
			}
		})
		adapt.oneLineCenterPos(cc.p(65, 13), {
			var_5_3,
			var_5_4
		}, cc.p(5, 0))

		local var_5_5 = {
			width = 900,
			height = 1350
		}
		local var_5_6 = ccui.Layout:create():addTo(arg_5_0, 1):setAnchorPoint(cc.p(0.5, 0.5)):alignCenter(var_5_5)

		bind.click(arg_5_0, arg_5_0.btnAdd, {
			method = function()
				local var_6_0 = {
					key = var_5_0.held_item_id,
					advance = var_5_0.advance,
					level = var_5_0.level
				}

				gGameUI:showItemDetail(var_5_6, var_6_0)
			end
		})
	end

	arg_5_0.icon:scale(var_5_1)

	local var_5_7 = csv.character[arg_5_1.character].name

	if csvSize(csv.character[arg_5_1.character].attrMap) ~= 0 then
		var_5_7 = var_5_7 .. gLanguageCsv.symbolBracketLeft

		arg_5_0.nature:text(var_5_7)

		local var_5_8 = {}

		for iter_5_0, iter_5_1 in csvMapPairs(csv.character[arg_5_1.character].attrMap) do
			local var_5_9 = string.match(iter_5_1, "%d+")

			table.insert(var_5_8, {
				id = iter_5_0,
				num = var_5_9
			})
		end

		table.sort(var_5_8, function(arg_7_0, arg_7_1)
			return tonumber(arg_7_0.num) > tonumber(arg_7_1.num)
		end)
		arg_5_0.up:text(getLanguageAttr(var_5_8[1].id) .. math.abs(var_5_8[1].num - 100) .. "%")
		arg_5_0.down:text(getLanguageAttr(var_5_8[2].id) .. math.abs(var_5_8[2].num - 100) .. "%")
		adapt.oneLinePos(arg_5_0.nature, {
			arg_5_0.up,
			arg_5_0.upIcon,
			arg_5_0.down,
			arg_5_0.downIcon,
			arg_5_0.static1
		}, cc.p(5, 0))
	else
		arg_5_0.nature:text(var_5_7)
		itertools.invoke({
			arg_5_0.up,
			arg_5_0.upIcon,
			arg_5_0.down,
			arg_5_0.downIcon,
			arg_5_0.static1
		}, "hide")
	end

	if arg_5_1.gender == 0 then
		arg_5_0.gender:hide()
	elseif arg_5_1.gender == 1 then
		arg_5_0.gender:texture("other/gain_sprite/icon_man.png")
	else
		arg_5_0.gender:texture("other/gain_sprite/icon_woman.png")
	end

	arg_5_0:initModel()

	local var_5_10 = dataEasy.getUnitCsv(arg_5_1.card_id, arg_5_1.skin_id)
	local var_5_11 = arg_5_0.leftPanel:multiget("rarity", "name", "attr1", "attr2", "starList", "cardImg", "masterName", "masterNameNote")

	var_5_11.rarity:texture(ui.RARITY_ICON[var_5_10.rarity])
	var_5_11.masterName:text(arg_5_1.role_name or arg_5_0.myName:read())
	adapt.oneLineCenterPos(cc.p(arg_5_0.cardImg:x(), var_5_11.masterName:y()), {
		var_5_11.masterNameNote,
		var_5_11.masterName
	}, cc.p(25, 0))
	var_5_11.name:text(uiEasy.setIconName("card", arg_5_1.card_id, {
		space = true,
		node = var_5_11.name,
		name = arg_5_1.name,
		advance = arg_5_1.advance
	}))
	var_5_11.attr2:visible(var_5_10.natureType2 ~= nil)

	if var_5_10.natureType2 then
		var_5_11.attr2:texture(ui.ATTR_ICON[var_5_10.natureType2])
	end

	var_5_11.attr1:texture(ui.ATTR_ICON[var_5_10.natureType])
	var_5_11.starList:setScrollBarEnabled(false)

	local var_5_12 = ccui.ImageView:create("common/icon/icon_star.png"):scale(1)

	var_5_12:hide()

	local var_5_13 = var_5_12:box()
	local var_5_14 = {}
	local var_5_15 = arg_5_1.star - 6
	local var_5_16 = 0.6

	for iter_5_2 = 1, 6 do
		local var_5_17 = "common/icon/icon_stardi.png"

		if iter_5_2 <= arg_5_1.star then
			var_5_17 = dataEasy.getStarRes(arg_5_1.star, iter_5_2)
		end

		table.insert(var_5_14, {
			icon = var_5_17,
			starScale = var_5_16
		})
	end

	arg_5_0.starData = idlertable.new(var_5_14)

	local var_5_18 = var_5_11.cardImg:size()

	var_5_11.cardImg:removeAllChildren()

	local var_5_19 = string.gsub(var_5_10.unitRes, ".skel", "_ui.skel")

	widget.addAnimation(var_5_11.cardImg, var_5_19, "standby_loop", 5):xy(var_5_18.width / 2, 0):scale(var_5_10.scale * 0.5):setSkin(var_5_10.skin)
	arg_5_0.cardLevel:text(arg_5_1.level)
	adapt.oneLineCenterPos(cc.p(arg_5_0.rarity:x(), arg_5_0.cardLevel:y()), {
		arg_5_0.cardLevelNote,
		arg_5_0.cardLevel
	}, cc.p(5, 3))
	arg_5_0.power:text(arg_5_1.fighting_point)
	adapt.oneLineCenterPos(cc.p(arg_5_0.cardImg:x(), arg_5_0.power:y()), {
		arg_5_0.powerNote1,
		arg_5_0.power
	}, cc.p(25, 0))

	arg_5_0.tabDatas = {
		{
			isSelected = true,
			name = gLanguageCsv.spaceAttribute,
			panel = arg_5_0.attributePanel
		},
		{
			isSelected = false,
			name = gLanguageCsv.spaceSkill,
			panel = arg_5_0.skillPanel
		}
	}
	arg_5_0.tabDatas = idlers.newWithMap(arg_5_0.tabDatas)
	arg_5_0.showPage = idler.new(1)

	arg_5_0.showPage:addListener(function(arg_8_0, arg_8_1, arg_8_2)
		arg_5_0.tabDatas:atproxy(arg_8_1).isSelected = false
		arg_5_0.tabDatas:atproxy(arg_8_0).isSelected = true

		if arg_5_0.tabDatas:atproxy(arg_8_1).panel then
			arg_5_0.tabDatas:atproxy(arg_8_1).panel:hide()
		end

		if arg_5_0.tabDatas:atproxy(arg_8_0).panel then
			arg_5_0.tabDatas:atproxy(arg_8_0).panel:show()
		end
	end)

	arg_5_0.skillDatas = {}

	local var_5_20 = dataEasy.getCardSkillList(arg_5_1.card_id, arg_5_1.skin_id)

	for iter_5_3, iter_5_4 in csvPairs(var_5_20) do
		table.insert(arg_5_0.skillDatas, {
			id = iter_5_4,
			level = arg_5_1.skills[iter_5_4] or 1
		})
	end

	table.sort(arg_5_0.skillDatas, function(arg_9_0, arg_9_1)
		return arg_9_0.id <= arg_9_1.id
	end)

	arg_5_0.attrDatas = {}

	for iter_5_5, iter_5_6 in ipairs(game.ATTRDEF_SIMPLE_TABLE) do
		assertInWindows(arg_5_1.attrs[iter_5_6], "cardId(%s) attrs(%s) %s is nil", arg_5_0.cardData.card_id, dumps(arg_5_1.attrs), iter_5_6)

		local var_5_21 = {
			name = getLanguageAttr(iter_5_6),
			num = math.floor(arg_5_1.attrs[iter_5_6] or 0),
			icon = ui.ATTR_LOGO[iter_5_6]
		}

		arg_5_0.attrDatas[iter_5_5] = var_5_21
	end

	arg_5_0.nvalue = arg_5_1.nvalue

	local var_5_22 = arg_5_0.leftPanel

	Dialog.onCreate(arg_5_0)
end

function var_0_0.initModel(arg_10_0)
	arg_10_0.level = gGameModel.role:getIdler("level")
	arg_10_0.levelExp = gGameModel.role:getIdler("level_exp")
	arg_10_0.cards = gGameModel.role:getIdler("cards")
	arg_10_0.battleCards = gGameModel.role:getIdler("battle_cards")
	arg_10_0.personalSign = gGameModel.role:getIdler("personal_sign")
	arg_10_0.logo = gGameModel.role:getIdler("logo")
	arg_10_0.myName = gGameModel.role:getIdler("name")
end

function var_0_0.onChangePage(arg_11_0, arg_11_1, arg_11_2)
	arg_11_0.showPage:set(arg_11_2)
end

function var_0_0.onSkillDetail(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = gGameUI:stackUI("common.skill_detail", nil, {
		clickClose = true,
		dispatchNodes = arg_12_1
	}, {
		skillId = arg_12_3.id,
		skillLevel = arg_12_3.level,
		cardId = arg_12_0.cardData.card_id,
		star = arg_12_0.cardData.star,
		isZawake = dataEasy.isZawakeSkill(arg_12_3.id, arg_12_0.cardData.zawake_skills)
	}):getResourceNode()
	local var_12_1, var_12_2 = var_12_0:xy()

	var_12_0:xy(var_12_1 - 60, var_12_2)
end

return var_0_0
