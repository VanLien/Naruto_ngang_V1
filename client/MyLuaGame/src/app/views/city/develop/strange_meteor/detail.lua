local var_0_0 = class("StrangeMeteorDetailView", cc.load("mvc").ViewBase)
local var_0_1 = require("app.views.city.develop.strange_meteor.tools")

var_0_0.RESOURCE_FILENAME = "strange_meteor_detail.json"
var_0_0.RESOURCE_BINDING = {
	["rightPanel.costItem"] = "costItem",
	meteorTabItem = "meteorTabItem",
	["rightPanel.imgLevelMax"] = "imgLevelMax",
	["leftPanel.meteoriteItem2"] = "meteoriteItem2",
	["leftPanel.imgJT"] = "imgJT",
	["rightPanel.txtAttributeTitle"] = "txtAttributeTitle",
	bg_zhen = "bg_zhen",
	["rightPanel.txtLvNote"] = "txtLvNote",
	["leftPanel.txtEffect"] = "txtEffect",
	leftPanel = "leftPanel",
	meteorTabBg = "meteorTabBg",
	["leftPanel.meteoriteItem4"] = "meteoriteItem4",
	["rightPanel.name"] = "meteorname",
	["rightPanel.attributeItem"] = "attributeItem",
	["rightPanel.txtCostTitle"] = "txtCostTitle",
	["leftPanel.meteoriteItem5"] = "meteoriteItem5",
	["leftPanel.meteoriteItem3"] = "meteoriteItem3",
	["leftPanel.meteoriteItem1"] = "meteoriteItem1",
	["rightPanel.txtLv"] = "txtLv",
	rightPanel = "rightPanel",
	rule = {
		varname = "rule",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleClick")
			}
		}
	},
	["meteorTabBg.meteorTabList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 55,
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("meteorTabItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1.get(arg_1_1, "normal")
					local var_1_1 = arg_1_1.get(arg_1_1, "select")
					local var_1_2

					if arg_1_3.select then
						var_1_0:hide()

						var_1_2 = var_1_1:show()

						var_1_2:get("icon"):setOpacity(255)
					else
						var_1_1:hide()

						var_1_2 = var_1_0:show()

						var_1_2:get("icon"):setOpacity(204)
					end

					var_1_2:get("icon"):texture(string.format("city/develop/strange_meteor/icon_qyys_jy%d.png", arg_1_3.id))

					if not arg_1_3.unlock then
						var_1_0:get("icon"):setColor(cc.c3b(183, 176, 158))
						var_1_0:get("icon"):setOpacity(102)
					end

					var_1_1.setTouchEnabled(var_1_1, false)
					bind.touch(arg_1_0, var_1_0, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabItemClick")
			}
		}
	},
	["rightPanel.attributeList"] = {
		varname = "attributeList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 20,
				data = bindHelper.self("attributeData"),
				item = bindHelper.self("attributeItem"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("icon", "name", "num", "imgTo", "name1", "nextLvNum", "iconMax")
					local var_2_1 = ui.ATTR_LOGO[game.ATTRDEF_TABLE[arg_2_3.key]]

					var_2_0.icon:texture(var_2_1)
					var_2_0.name:text(getLanguageAttr(arg_2_3.key))

					if arg_2_3.num == -1 then
						var_2_0.num:text("---")
					else
						var_2_0.num:text("+" .. arg_2_3.num)
					end

					if arg_2_3.isMax then
						var_2_0.num:text("+" .. arg_2_3.num)
					end

					itertools.invoke({
						var_2_0.imgTo,
						var_2_0.name1,
						var_2_0.nextLvNum
					}, "visible", not arg_2_3.isMax)
					var_2_0.iconMax:visible(arg_2_3.isMax or false)

					if not arg_2_3.isMax then
						var_2_0.name1:text(getLanguageAttr(arg_2_3.key))

						if arg_2_3.nextLvNum == -1 then
							var_2_0.nextLvNum:text("---")
						else
							var_2_0.nextLvNum:text("+" .. arg_2_3.nextLvNum)
						end
					end

					text.addEffect(var_2_0.name, {
						outline = {
							color = ui.COLORS.NORMAL.DEFAULT
						}
					})
					text.addEffect(var_2_0.num, {
						outline = {
							color = ui.COLORS.NORMAL.DEFAULT
						}
					})
					text.addEffect(var_2_0.name1, {
						outline = {
							color = ui.COLORS.NORMAL.DEFAULT
						}
					})
					text.addEffect(var_2_0.nextLvNum, {
						outline = {
							color = ui.COLORS.NORMAL.DEFAULT
						}
					})
				end
			}
		}
	},
	["rightPanel.btnInset"] = {
		varname = "btnInset",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onInsetClick")
			}
		}
	},
	["rightPanel.costList"] = {
		varname = "costList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 10,
				data = bindHelper.self("costData"),
				item = bindHelper.self("costItem"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:multiget("icon", "addPanel")
					local var_3_1 = dataEasy.getNumByKey(arg_3_3.key)

					var_3_0.addPanel:visible(var_3_1 < arg_3_3.num)
					bind.extend(arg_3_0, var_3_0.icon, {
						class = "icon_key",
						props = {
							noListener = true,
							data = {
								key = arg_3_3.key,
								num = var_3_1,
								targetNum = arg_3_3.num
							},
							grayState = showAddBtn and 1 or 0,
							onNode = function(arg_4_0)
								arg_4_0:setTouchEnabled(false)
							end
						}
					})
					var_3_0.icon:setTouchEnabled(true)
					bind.click(arg_3_0, var_3_0.icon, {
						method = function(arg_5_0, arg_5_1, arg_5_2)
							gGameUI:stackUI("common.gain_way", nil, nil, arg_3_3.key, nil, arg_3_3.num)
						end
					})
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_6_0, arg_6_1)
	gGameUI.topuiManager:createView("default", arg_6_0, {
		onClose = arg_6_0:createHandler("onClose")
	}):init({
		subTitle = "STRANGEMETEOR",
		title = "common/txt/txt_bt_ssshy.png"
	})
	arg_6_0:initModel()
	arg_6_0:enableSchedule()

	arg_6_0.index = idler.new(arg_6_1)
	arg_6_0.costData = idlers.new()
	arg_6_0.attributeData = idlers.new()
	arg_6_0.tabDatas = idlers.new()
	arg_6_0.selIdx = idler.new(0)
	arg_6_0.meteorPos = {
		{
			x = arg_6_0.meteoriteItem1:x(),
			y = arg_6_0.meteoriteItem1:y()
		},
		{
			x = arg_6_0.meteoriteItem2:x(),
			y = arg_6_0.meteoriteItem2:y()
		},
		{
			x = arg_6_0.meteoriteItem3:x(),
			y = arg_6_0.meteoriteItem3:y()
		},
		{
			x = arg_6_0.meteoriteItem4:x(),
			y = arg_6_0.meteoriteItem4:y()
		},
		{
			x = arg_6_0.meteoriteItem5:x(),
			y = arg_6_0.meteoriteItem5:y()
		}
	}
	arg_6_0.jiantouPos = {
		{
			x = arg_6_0.imgJT:x(),
			y = arg_6_0.imgJT:y()
		}
	}

	arg_6_0.index:addListener(function()
		arg_6_0:initData()
	end)
	arg_6_0.selIdx:addListener(function()
		arg_6_0:onPlaySelectSpine()
	end)
	arg_6_0:getResourceNode():removeChildByName("spineGuanghuan")
	widget.addAnimationByKey(arg_6_0:getResourceNode(), "strange_meteor/yunhsi2.skel", "spineGuanghuan", "guanghuan_loop", 1):scale(2):xy(display.uiOrigin.x + 980, 270)
	idlereasy.any({
		arg_6_0.meteorites,
		arg_6_0.items,
		arg_6_0.gold
	}, function()
		arg_6_0:initData()
	end)
end

function var_0_0.initModel(arg_10_0)
	arg_10_0.meteorites = gGameModel.role:getIdler("meteorites")
	arg_10_0.items = gGameModel.role:getIdler("items")
	arg_10_0.gold = gGameModel.role:getIdler("gold")
end

function var_0_0.initData(arg_11_0)
	arg_11_0.meteorObject = {
		arg_11_0.meteoriteItem1,
		arg_11_0.meteoriteItem2,
		arg_11_0.meteoriteItem3,
		arg_11_0.meteoriteItem4,
		arg_11_0.meteoriteItem5
	}
	arg_11_0.nameOutLineColor = {
		cc.c4b(92, 153, 112, 255),
		cc.c4b(61, 138, 153, 255),
		cc.c4b(138, 92, 153, 255),
		cc.c4b(230, 153, 0, 255),
		cc.c4b(241, 59, 84, 255)
	}

	arg_11_0.selIdx:set(0)

	local var_11_0 = arg_11_0.meteorites:read()[arg_11_0.index:read()]
	local var_11_1 = csv.meteorite.base[arg_11_0.index:read()]
	local var_11_2 = 0

	if var_11_0 then
		var_11_2 = var_11_0.level
	end

	for iter_11_0, iter_11_1 in ipairs(arg_11_0.meteorObject) do
		if iter_11_0 ~= arg_11_0.index:read() then
			iter_11_1.hide(iter_11_1)
		else
			iter_11_1.show(iter_11_1)
		end
	end

	local var_11_3 = arg_11_0.meteorObject[arg_11_0.index:read()]

	var_11_3:stopAllActions()

	var_11_3.originScale = var_11_3:scale()

	var_11_3:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.EaseBackOut:create(cc.ScaleTo:create(0.5, var_11_3.originScale))))
	performWithDelay(var_11_3, function()
		var_11_3:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.EaseSineInOut:create(cc.MoveTo:create(2, cc.p(arg_11_0.meteorPos[arg_11_0.index:read()].x, arg_11_0.meteorPos[arg_11_0.index:read()].y + 50))), cc.EaseSineInOut:create(cc.MoveTo:create(2, cc.p(arg_11_0.meteorPos[arg_11_0.index:read()].x, arg_11_0.meteorPos[arg_11_0.index:read()].y))))))
	end, 0)
	arg_11_0.imgJT:stopAllActions()

	arg_11_0.imgJT.originScale = arg_11_0.imgJT:scale()

	arg_11_0.imgJT:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.EaseBackOut:create(cc.ScaleTo:create(0.25, arg_11_0.imgJT.originScale))))
	performWithDelay(arg_11_0.imgJT, function()
		arg_11_0.imgJT:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.EaseSineInOut:create(cc.MoveTo:create(2, cc.p(arg_11_0.jiantouPos[1].x, arg_11_0.jiantouPos[1].y + 10))), cc.EaseSineInOut:create(cc.MoveTo:create(2, cc.p(arg_11_0.jiantouPos[1].x, arg_11_0.jiantouPos[1].y))))))
	end, 0)

	arg_11_0.spriteItem = var_11_3:get("spriteItem")
	arg_11_0.heldItem1 = var_11_3:get("heldItem1")
	arg_11_0.heldItem2 = var_11_3:get("heldItem2")
	arg_11_0.spriteItemPos = {
		x = arg_11_0.spriteItem:x(),
		y = arg_11_0.spriteItem:y()
	}
	arg_11_0.heldItemPos1 = {
		x = arg_11_0.heldItem1:x(),
		y = arg_11_0.heldItem1:y()
	}
	arg_11_0.heldItemPos2 = {
		x = arg_11_0.heldItem2:x(),
		y = arg_11_0.heldItem2:y()
	}

	arg_11_0.heldItem1:get("img_kuang"):hide()
	arg_11_0.heldItem2:get("img_kuang"):hide()
	arg_11_0.spriteItem:get("img_bian"):stopAllActions()
	arg_11_0.heldItem1:get("img_kuang"):stopAllActions()
	arg_11_0.heldItem2:get("img_kuang"):stopAllActions()
	arg_11_0.heldItem2:visible(var_11_1.helditemNum > 1)

	local var_11_4 = string.format(gLanguageCsv.meteoriteEffectDesc, var_0_1.getMeteorExtraAddNum(arg_11_0.index:read()))

	arg_11_0.txtEffect:parent():removeChildByName("richEffectText")

	local var_11_5 = rich.createByStr(var_11_4, 50):anchorPoint(0.5, 0.5):xy(arg_11_0.txtEffect:xy()):addTo(arg_11_0.txtEffect:parent(), 1, "richEffectText")

	arg_11_0.txtEffect:text(var_11_4):hide()
	arg_11_0.meteorname:text(var_11_1.name)
	arg_11_0.txtLv:text(var_11_2)
	text.addEffect(arg_11_0.meteorname, {
		outline = {
			color = arg_11_0.nameOutLineColor[arg_11_0.index:read()]
		}
	})
	text.addEffect(arg_11_0.txtLv, {
		outline = {
			color = ui.COLORS.NORMAL.DEFAULT
		}
	})
	text.addEffect(arg_11_0.txtAttributeTitle, {
		outline = {
			color = ui.COLORS.NORMAL.DEFAULT
		}
	})
	text.addEffect(arg_11_0.txtCostTitle, {
		outline = {
			color = ui.COLORS.NORMAL.DEFAULT
		}
	})
	text.addEffect(arg_11_0.rule:get("name"), {
		outline = {
			color = ui.COLORS.NORMAL.WHITE
		}
	})

	local var_11_6 = {}
	local var_11_7 = gGameModel.role:read("level")

	for iter_11_2, iter_11_3 in orderCsvPairs(csv.meteorite.base) do
		local var_11_8 = arg_11_0.meteorites:read()[iter_11_2] or {}
		local var_11_9 = 999

		if iter_11_2 >= 2 then
			var_11_9 = not arg_11_0.meteorites:read()[iter_11_2 - 1] and 0 or arg_11_0.meteorites:read()[iter_11_2 - 1].level
		end

		local var_11_10 = false

		if var_11_7 >= iter_11_3.unlockLevel and var_11_9 >= iter_11_3.preLevel then
			var_11_10 = true
		end

		local var_11_11 = false

		if iter_11_2 == arg_11_0.index:read() then
			var_11_11 = true
		end

		var_11_6[iter_11_2] = {
			id = iter_11_2,
			cfg = iter_11_3,
			unlock = var_11_10,
			meteorites = var_11_8,
			select = var_11_11
		}
	end

	arg_11_0.tabDatas:update(var_11_6)

	local var_11_12

	arg_11_0.hasSprite = false

	if var_11_0 and var_11_0.card then
		local var_11_13 = gGameModel.cards:find(var_11_0.card)

		if var_11_13 then
			var_11_12 = var_11_13.read(var_11_13, "card_id", "skin_id")
		end
	end

	if var_11_12 then
		local var_11_14 = dataEasy.getUnitCsv(var_11_12.card_id, var_11_12.skin_id)
		local var_11_15 = string.gsub(var_11_14.unitRes, ".skel", "_ui.skel")

		arg_11_0.spriteItem:get("imgSprite"):show()

		local var_11_16 = widget.addAnimation(arg_11_0.spriteItem:get("imgSprite"), var_11_15, battle.SpriteActionTable.standby):anchorPoint(0.5, 0):xy(30, -150):scale(0.5)

		arg_11_0.spriteItem:get("img_bian"):texture(string.format("city/develop/strange_meteor/img_qyys_%d.png", arg_11_0.index:read()))
		arg_11_0.spriteItem:get("img_add"):hide()

		arg_11_0.hasSprite = true

		arg_11_0.spriteItem:get("renHintNode"):hide()
	else
		arg_11_0.spriteItem:get("img_add"):show()
		arg_11_0.spriteItem:get("imgSprite"):hide()
		arg_11_0.spriteItem:get("img_bian"):texture("city/develop/strange_meteor/img_qyys_empty.png"):show()
		arg_11_0.spriteItem:get("renHintNode"):show()
		bind.extend(arg_11_0, arg_11_0.spriteItem:get("renHintNode"), {
			class = "red_hint",
			props = {
				state = true
			}
		})
	end

	local var_11_17 = {}

	if var_11_0 then
		var_11_17 = var_11_0.helditems or {}
	end

	if var_11_17[1] then
		local var_11_18 = gGameModel.held_items:find(var_11_17[1]):read("held_item_id")
		local var_11_19 = csv.held_item.items[var_11_18].icon

		arg_11_0.heldItem1:get("imgHeldItem"):texture(var_11_19):show()
		arg_11_0.heldItem1:get("img_add"):visible(false)
		arg_11_0.heldItem1:get("renHintNode"):hide()
	else
		arg_11_0.heldItem1:get("imgHeldItem"):hide()
		arg_11_0.heldItem1:get("img_add"):show()
		arg_11_0.heldItem1:get("renHintNode"):show()
		bind.extend(arg_11_0, arg_11_0.heldItem1:get("renHintNode"), {
			class = "red_hint",
			props = {
				state = true
			}
		})
	end

	if var_11_1.helditemNum >= 2 then
		if var_11_17[2] then
			local var_11_20 = gGameModel.held_items:find(var_11_17[2]):read("held_item_id")
			local var_11_21 = csv.held_item.items[var_11_20].icon

			arg_11_0.heldItem2:get("imgHeldItem"):texture(var_11_21):show()
			arg_11_0.heldItem2:get("img_add"):hide()
			arg_11_0.heldItem2:get("renHintNode"):hide()
		else
			arg_11_0.heldItem2:get("imgHeldItem"):hide()
			arg_11_0.heldItem2:get("img_add"):show()
			arg_11_0.heldItem2:get("renHintNode"):show()
			bind.extend(arg_11_0, arg_11_0.heldItem2:get("renHintNode"), {
				class = "red_hint",
				props = {
					state = true
				}
			})
		end
	end

	local var_11_22 = {}
	local var_11_23 = "attr" .. var_11_1.levelSeqID
	local var_11_24 = csv.meteorite.level[var_11_2][var_11_23]
	local var_11_25 = csv.meteorite.level[var_11_2 + 1]

	var_11_25 = var_11_25 and var_11_25[var_11_23]

	if not var_11_25 then
		arg_11_0.isMax = true
	else
		arg_11_0.isMax = false
	end

	for iter_11_4, iter_11_5 in ipairs(game.ATTRDEF_SIMPLE_TABLE) do
		local var_11_26 = game.ATTRDEF_ENUM_TABLE[iter_11_5]
		local var_11_27

		if not var_11_25 then
			if var_11_24[var_11_26] then
				var_11_27 = {
					isMax = true,
					key = var_11_26,
					num = var_11_24[var_11_26] or -1
				}
			end
		elseif var_11_24[var_11_26] or var_11_25[var_11_26] then
			if not var_11_24[var_11_26] then
				local var_11_28 = -1
			end

			if not var_11_25[var_11_26] then
				local var_11_29 = -1
			end

			var_11_27 = {
				key = var_11_26,
				num = var_11_24[var_11_26],
				nextLvNum = var_11_25[var_11_26]
			}
		end

		if var_11_27 then
			table.insert(var_11_22, var_11_27)
		end
	end

	arg_11_0.attributeData:update(var_11_22)
	arg_11_0.costList:hide()

	if var_11_2 < csvSize(csv.meteorite.level) - 1 then
		local var_11_30 = {}
		local var_11_31 = csv.meteorite.cost[var_11_2]["cost" .. var_11_1.costSeqID]

		dataEasy.getItemData(var_11_31)
		arg_11_0.costList:show()
		arg_11_0.costData:update(dataEasy.getItemData(var_11_31))
	end

	if arg_11_0.isMax then
		arg_11_0.btnInset:hide()
		arg_11_0.txtCostTitle:hide()
		arg_11_0.imgLevelMax:show()
	else
		arg_11_0.btnInset:show()
		arg_11_0.txtCostTitle:show()
		arg_11_0.imgLevelMax:hide()
	end

	arg_11_0.onCardHelditemExtend(arg_11_0)
end

local var_0_2 = {
	function(arg_14_0, arg_14_1)
		return {
			obj = arg_14_0.spriteItem,
			itemClick = arg_14_0.onSpriteItemClick,
			cd = arg_14_1 and arg_14_1.card_cd or 0,
			itemNum = arg_14_1 and arg_14_1.card or 0,
			img = arg_14_0.spriteItem:get("imgSprite")
		}
	end,
	function(arg_15_0, arg_15_1)
		return {
			obj = arg_15_0.heldItem1,
			itemClick = arg_15_0.onHeldItemClick,
			cd = arg_15_1 and arg_15_1.helditem_cd[1] or 0,
			itemNum = arg_15_1 and arg_15_1.helditems[1] or 0,
			img = arg_15_0.heldItem1:get("imgHeldItem")
		}
	end,
	function(arg_16_0, arg_16_1)
		return {
			obj = arg_16_0.heldItem2,
			itemClick = arg_16_0.onHeldItemClick,
			cd = arg_16_1 and arg_16_1.helditem_cd[2] or 0,
			itemNum = arg_16_1 and arg_16_1.helditems[2] or 0,
			img = arg_16_0.heldItem2:get("imgHeldItem")
		}
	end
}

function var_0_0.onCardHelditemExtend(arg_17_0)
	local var_17_0 = arg_17_0.meteorites:read()[arg_17_0.index:read()]
	local var_17_1 = csv.meteorite.base[arg_17_0.index:read()]
	local var_17_2 = 0

	if var_17_0 then
		var_17_2 = var_17_0.level
	end

	local var_17_3
	local var_17_4
	local var_17_5 = var_17_1.cardCD

	for iter_17_0, iter_17_1 in csvMapPairs(var_17_1.helditemCDs) do
		if iter_17_0 == 1 then
			var_17_3 = iter_17_1
		end

		if iter_17_0 == 2 then
			var_17_4 = iter_17_1
		end
	end

	var_17_4 = var_17_4 or 0

	local var_17_6 = {
		var_17_5,
		var_17_3,
		var_17_4
	}

	for iter_17_2 = 1, #var_0_2 do
		local var_17_7 = var_0_2[iter_17_2](arg_17_0, var_17_0)
		local var_17_8 = false
		local var_17_9 = var_17_7.obj

		var_17_9:get("lock"):visible(iter_17_2 ~= 1)

		if iter_17_2 > 1 then
			local var_17_10 = 0

			for iter_17_3, iter_17_4 in csvMapPairs(var_17_1.unlockParams) do
				if iter_17_3 == iter_17_2 - 1 then
					var_17_10 = iter_17_4
				end
			end

			for iter_17_5, iter_17_6 in csvMapPairs(var_17_1.open) do
				if iter_17_5 == iter_17_2 - 1 and iter_17_6 == 1 then
					var_17_8 = true

					break
				end
			end

			if var_17_10 <= var_17_2 then
				var_17_9:get("lock"):hide()
			else
				var_17_9:get("img_add"):hide()
				var_17_9:get("renHintNode"):hide()
			end

			if var_17_7.itemNum == 0 and var_17_10 <= var_17_2 then
				var_17_9:get("img_add"):show()
			end

			if var_17_8 then
				var_17_9:get("lock"):show()
				var_17_9:get("img_add"):hide()
				arg_17_0.heldItem2:get("renHintNode"):hide()
			end
		end

		local var_17_11 = {
			var_17_9,
			var_17_7.img,
			var_17_9.get(var_17_9, "img_add"),
			var_17_9.get(var_17_9, "lock")
		}

		for iter_17_7, iter_17_8 in ipairs(var_17_11) do
			bind.click(arg_17_0, iter_17_8, {
				method = function()
					var_17_7.itemClick(arg_17_0, iter_17_2, var_17_8, false)
				end
			})
		end

		text.addEffect(var_17_9.get(var_17_9, "time"), {
			outline = {
				color = ui.COLORS.NORMAL.WHITE
			}
		})
		text.addEffect(var_17_9.get(var_17_9, "timeStr"), {
			outline = {
				color = ui.COLORS.NORMAL.WHITE
			}
		})
		arg_17_0.schedule(arg_17_0, function()
			local var_19_0 = math.min(math.max(var_17_7.cd - time.getTime(), 0), var_17_6[iter_17_2])

			var_17_9:get("time"):text(time.getCutDown(var_19_0).short_clock_str)
			var_17_9:get("time"):visible(var_19_0 ~= 0)
			var_17_9:get("timeStr"):hide(var_19_0 ~= 0)
		end, 1, 0, iter_17_2)
	end
end

function var_0_0.onTabItemClick(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	if arg_20_3.unlock then
		arg_20_0.index:set(arg_20_2)
	else
		gGameUI:showTip(gLanguageCsv.meteorUnLockTips)
	end
end

function var_0_0.onPlaySelectSpine(arg_21_0)
	arg_21_0.spriteItem:get("img_bian"):stopAllActions()
	arg_21_0.heldItem1:get("img_kuang"):stopAllActions()
	arg_21_0.heldItem2:get("img_kuang"):stopAllActions()
	arg_21_0.heldItem1:get("img_kuang"):hide()
	arg_21_0.heldItem2:get("img_kuang"):hide()

	local var_21_0 = arg_21_0.selIdx:read()

	if var_21_0 == 1 and arg_21_0.hasSprite then
		arg_21_0.spriteItem:get("img_bian"):runAction(cc.RepeatForever:create(cc.RotateBy:create(3, 360)))
	elseif var_21_0 == 2 or var_21_0 == 3 then
		local var_21_1 = cc.Sequence:create(cc.ScaleTo:create(1, 1.55, 1.55), cc.ScaleTo:create(1, 1.5, 1.5))
		local var_21_2 = arg_21_0["heldItem" .. var_21_0 - 1]

		var_21_2:get("img_kuang"):show()

		local var_21_3 = cc.RepeatForever:create(var_21_1)

		var_21_2:get("img_kuang"):runAction(var_21_3)
	end
end

function var_0_0.onRuleClick(arg_22_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_22_0:createHandler("getRuleContext"), {
		width = 1500
	})
end

function var_0_0.getRuleContext(arg_23_0, arg_23_1)
	local var_23_0 = adaptContext

	return {
		var_23_0.clone(arg_23_1.title, function(arg_24_0)
			arg_24_0:get("text"):text(gLanguageCsv.meteorRuleTitle)
		end),
		var_23_0.noteText(128401, 128500)
	}
end

function var_0_0.onInsetClick(arg_25_0)
	for iter_25_0, iter_25_1 in arg_25_0.costData:pairs() do
		local var_25_0 = iter_25_1.read(iter_25_1)

		if dataEasy.getNumByKey(var_25_0.key) < var_25_0.num then
			gGameUI:showTip(gLanguageCsv.effortExtraItemLess)

			return
		end
	end

	arg_25_0.meteorUpLevelIdx = arg_25_0.meteorUpLevelIdx and arg_25_0.meteorUpLevelIdx + 1 or 0

	gGameApp:requestServer("/game/meteorite/strength", function(arg_26_0)
		gGameUI:showTip(gLanguageCsv.meteorUpLevel)

		local var_26_0 = widget.addAnimationByKey(arg_25_0.leftPanel, "strange_meteor/yunhsi2.skel", "meteorUpLevelIdx" .. arg_25_0.meteorUpLevelIdx, "shouhuchenggong", 101):scale(2.5):xy(arg_25_0.txtEffect:x(), arg_25_0.txtEffect:y())
		local var_26_1 = arg_25_0.attributeList:getItems()

		for iter_26_0, iter_26_1 in ipairs(var_26_1) do
			if iter_26_1:get("effect") then
				iter_26_1:get("effect"):removeSelf()
			end

			widget.addAnimationByKey(iter_26_1, "strange_meteor/yunhsi5.skel ", "effect", "effect", 10):alignCenter(iter_26_1:size()):xy(90, 40):scaleX(1.25):setTimeScale(1.5)
		end

		performWithDelay(arg_25_0, function()
			var_26_0:removeFromParent()
		end, 2)
	end, arg_25_0.index:read(), 1)
end

function var_0_0.onSpriteItemClick(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	arg_28_0.selIdx:set(1)

	local var_28_0 = arg_28_0.meteorites:read()[arg_28_0.index:read()]
	local var_28_1 = var_28_0 and var_28_0.card_cd or 0
	local var_28_2 = math.max(var_28_1 - time.getTime(), 0)

	if (var_28_0 and var_28_0.card or 0) ~= 0 and not arg_28_3 then
		arg_28_0.onBtnLookClick(arg_28_0, 1, arg_28_2)

		return
	end

	if var_28_2 > 0 then
		gGameUI:showTip(gLanguageCsv.meteorSpriteCDTips)
		arg_28_0.selIdx:set(0)

		return
	end

	gGameUI:stackUI("city.develop.strange_meteor.sprite_select", nil, nil, arg_28_0.index:read(), arg_28_0:createHandler("stopSelectAction"), arg_28_0:createHandler("onInsetSuccSpine"))
end

function var_0_0.onHeldItemClick(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	arg_29_0.selIdx:set(arg_29_1)

	local var_29_0 = arg_29_0.meteorites:read()[arg_29_0.index:read()]
	local var_29_1 = csv.meteorite.base[arg_29_0.index:read()]
	local var_29_2 = 0
	local var_29_3 = 0

	if var_29_0 then
		var_29_2 = var_29_0.level
	end

	for iter_29_0, iter_29_1 in csvMapPairs(var_29_1.unlockParams) do
		if iter_29_0 == arg_29_1 - 1 then
			var_29_3 = iter_29_1
		end
	end

	local var_29_4 = string.format(gLanguageCsv.meteorUnLockLevelTips, var_29_3)
	local var_29_5 = var_29_0 and var_29_0.helditem_cd[arg_29_1 - 1] or 0
	local var_29_6 = math.max(var_29_5 - time.getTime(), 0)

	if (var_29_0 and var_29_0.helditems[arg_29_1 - 1] or 0) ~= 0 and not arg_29_3 then
		arg_29_0.onBtnLookClick(arg_29_0, arg_29_1, arg_29_2)

		return
	end

	if var_29_6 > 0 then
		gGameUI:showTip(gLanguageCsv.meteorHeldItemsCDTips)
		arg_29_0.selIdx:set(0)

		return
	elseif arg_29_2 then
		gGameUI:showTip(gLanguageCsv.meteorOnlyLookTips)
		arg_29_0.selIdx:set(0)

		return
	elseif var_29_2 < var_29_3 then
		local var_29_7 = string.format(gLanguageCsv.meteorUnLockLevelTips, var_29_3)

		gGameUI:showTip(var_29_7)
		arg_29_0.selIdx:set(0)

		return
	end

	gGameUI:stackUI("city.develop.strange_meteor.held_select", nil, nil, arg_29_0.index:read(), arg_29_1 - 1, arg_29_0:createHandler("stopSelectAction"), arg_29_0:createHandler("onInsetSuccSpine"))
end

function var_0_0.onBtnLookClick(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_0.meteorites:read()[arg_30_0.index:read()]
	local var_30_1

	if arg_30_1 == 1 then
		var_30_1 = arg_30_0.spriteItemPos
	elseif arg_30_1 == 2 then
		var_30_1 = arg_30_0.heldItemPos1
	else
		var_30_1 = arg_30_0.heldItemPos2
	end

	if arg_30_1 == 1 then
		if not var_30_0 or not var_30_0.card then
			gGameUI:showTip(gLanguageCsv.meteorNoSprite)

			return
		end

		gGameUI:stackUI("city.develop.strange_meteor.sprite_extra_effect_detail", nil, nil, arg_30_0.index:read(), arg_30_0:createHandler("onSpriteItemClick"), arg_30_0:createHandler("onBtnDownClick"), var_30_1, arg_30_0:createHandler("stopSelectAction"))
	else
		if not var_30_0 or not var_30_0.helditems[arg_30_1 - 1] then
			gGameUI:showTip(gLanguageCsv.meteorNoHeldItems)

			return
		end

		gGameUI:stackUI("city.develop.strange_meteor.held_extra_effect_detail", nil, nil, arg_30_0.index:read(), arg_30_1 - 1, arg_30_2, arg_30_0:createHandler("onHeldItemClick"), arg_30_0:createHandler("onBtnDownClick"), var_30_1, arg_30_0:createHandler("stopSelectAction"))
	end
end

function var_0_0.onBtnDownClick(arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0.meteorites:read()[arg_31_0.index:read()]
	local var_31_1 = {
		{
			type = 1,
			exist = var_31_0 and var_31_0.card or nil,
			cd = var_31_0 and var_31_0.card_cd or 0
		},
		{
			pos = 1,
			type = 2,
			exist = var_31_0 and var_31_0.helditems[1] or nil,
			cd = var_31_0 and var_31_0.helditem_cd[1] or 0
		},
		{
			pos = 2,
			type = 2,
			exist = var_31_0 and var_31_0.helditems[2] or nil,
			cd = var_31_0 and var_31_0.helditem_cd[2] or 0
		}
	}

	if not var_31_1[arg_31_1].exist then
		gGameUI:showTip(gLanguageCsv.meteorNoItems)

		return
	end

	local function var_31_2()
		gGameApp:requestServer("/game/meteorite/guard/setup", function(arg_33_0)
			gGameUI:showTip(gLanguageCsv.meteorDownOk)
		end, arg_31_0.index:read(), var_31_1[arg_31_1].type, var_31_1[arg_31_1].pos, -1)
	end

	local var_31_3 = userDefault.getCurrDayKey("strangeMeteorDown", "first")

	if var_31_3 == "first" then
		var_31_3 = "true"

		userDefault.setCurrDayKey("strangeMeteorDown", var_31_3)
	end

	local var_31_4 = math.max(var_31_1[arg_31_1].cd - time.getTime(), 0)

	if var_31_3 == "true" and var_31_4 > 0 then
		gGameUI:showDialog({
			selectType = 2,
			clearFast = true,
			btnType = 1,
			selectKey = "strangeMeteorDown",
			content = gLanguageCsv.meteorDownCDTips,
			cb = var_31_2,
			selectTip = gLanguageCsv.todayNoTip
		})
	else
		var_31_2()
	end
end

function var_0_0.stopSelectAction(arg_34_0)
	arg_34_0.selIdx:set(0)
	arg_34_0.heldItem1:get("img_kuang"):hide()
	arg_34_0.heldItem2:get("img_kuang"):hide()
	arg_34_0.spriteItem:get("img_bian"):stopAllActions()
	arg_34_0.heldItem1:get("img_kuang"):stopAllActions()
	arg_34_0.heldItem2:get("img_kuang"):stopAllActions()
end

function var_0_0.onInsetSuccSpine(arg_35_0)
	gGameUI:showTip(gLanguageCsv.meteorInsetSuccTips)

	local var_35_0 = arg_35_0.txtEffect:x()

	arg_35_0:getResourceNode():removeChildByName("spineMeteorLevelUp")
	widget.addAnimationByKey(arg_35_0:getResourceNode(), "strange_meteor/yunhsi4.skel", "spineMeteorLevelUp", "shengji", 101):scale(2):alignCenter(display.sizeInView):x(var_35_0 + 280 + display.uiOrigin.x)
end

return var_0_0
