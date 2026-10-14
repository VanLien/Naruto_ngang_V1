local var_0_0 = require("app.views.city.handbook.tools")
local var_0_1 = 4
local var_0_2 = {
	[0] = "city/handbook/tag_bg.png",
	"city/handbook/tag_bg.png",
	"city/handbook/tag_bg.png",
	"city/handbook/tag_bg.png",
	"city/handbook/tag_bg.png",
	"city/handbook/tag_bg.png"
}

local function var_0_3(arg_1_0)
	local var_1_0 = arg_1_0.path
	local var_1_1 = arg_1_0.size
	local var_1_2 = arg_1_0.rect
	local var_1_3 = arg_1_0.rotation or 0
	local var_1_4 = ccui.Scale9Sprite:create()

	var_1_4:initWithFile(var_1_2, var_1_0)
	var_1_4:size(var_1_1)
	var_1_4:setRotation(var_1_3)

	return var_1_4
end

local function var_0_4(arg_2_0, arg_2_1)
	local var_2_0 = itertools.size(arg_2_0)
	local var_2_1 = false

	if var_2_0 == 0 then
		var_2_1 = true
		arg_2_0 = arg_2_1
	end

	local var_2_2 = 2
	local var_2_3 = #arg_2_0
	local var_2_4 = #arg_2_1
	local var_2_5 = arg_2_0[1]:size()

	for iter_2_0, iter_2_1 in ipairs(arg_2_0) do
		local var_2_6 = iter_2_1:getChildByName("line1")

		if var_2_6 then
			var_2_6:visible(true)
		else
			local var_2_7 = {
				path = "city/handbook/box_line_bg.png",
				size = cc.size(58, 18),
				rect = cc.rect(25, 9, 1, 1)
			}

			var_0_3(var_2_7):xy(var_2_5.width + var_2_2, var_2_5.height / 2):visible(not var_2_1 and iter_2_0 <= var_2_4):addTo(iter_2_1, -2, "line1")

			local var_2_8 = {
				path = "city/handbook/box_line_1.png",
				size = cc.size(82, 28),
				rect = cc.rect(25, 14, 1, 1)
			}

			var_0_3(var_2_8):xy(var_2_5.width + var_2_2, var_2_5.height / 2):addTo(iter_2_1, -1, "redline1")
		end
	end

	if var_2_3 == 1 and var_2_4 > 1 then
		for iter_2_2, iter_2_3 in ipairs(arg_2_0) do
			local var_2_9 = iter_2_3:getChildByName("line1")

			var_2_9:x(var_2_5.width - 18)
			var_2_9:size(26, 18)

			local var_2_10 = iter_2_3:getChildByName("redline1")

			var_2_10:x(var_2_5.width - 18)
			var_2_10:size(58, 28)
		end

		local var_2_11 = var_2_5.width + 3
		local var_2_12 = var_2_5.height / 2
		local var_2_13 = arg_2_0[1]
		local var_2_14 = (var_2_4 - 1) * (var_2_5.height + 15)
		local var_2_15 = {
			rotation = 90,
			path = "city/handbook/box_line_bg.png",
			size = cc.size(var_2_14 + 18, 18),
			rect = cc.rect(25, 9, 1, 1)
		}

		var_0_3(var_2_15):xy(var_2_11, var_2_12):addTo(var_2_13, -3, "line2")

		local var_2_16 = {
			rotation = 90,
			path = "city/handbook/box_line_1.png",
			size = cc.size(var_2_14 + 28, 32),
			rect = cc.rect(25, 9, 1, 1)
		}

		var_0_3(var_2_16):xy(var_2_11 + 2, var_2_12):addTo(var_2_13, -2, "redline2")

		local var_2_17, var_2_18 = 20, var_2_5.height / 2

		for iter_2_4, iter_2_5 in ipairs(arg_2_1) do
			local var_2_19 = {
				path = "city/handbook/box_line_bg.png",
				size = cc.size(17, 18),
				rect = cc.rect(25, 9, 1, 1)
			}

			var_0_3(var_2_19):xy(var_2_17, var_2_18):addTo(iter_2_5, -2, "line3")

			local var_2_20 = {
				path = "city/handbook/box_line_1.png",
				size = cc.size(43, 28),
				rect = cc.rect(25, 14, 1, 1)
			}

			var_0_3(var_2_20):xy(var_2_17 - 2, var_2_18):addTo(iter_2_5, -1, "redline3")
		end
	end
end

local function var_0_5(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	for iter_3_0 = 1, math.huge do
		local var_3_0 = arg_3_1:get("item" .. iter_3_0)

		if not var_3_0 then
			break
		end

		var_3_0:removeFromParent()
	end

	local var_3_1 = arg_3_0:size().width
	local var_3_2 = arg_3_3[1].itemType

	if var_3_2 == "title" then
		arg_3_1:get("imgTitle"):visible(true)
		arg_3_1:get("imgBg"):visible(true)
		arg_3_1:get("list"):visible(false)
		arg_3_1:get("imgTitle"):texture(ui.RARITY_ICON[arg_3_3[1].val])
		arg_3_1:get("imgBg"):texture(var_0_2[arg_3_3[1].val])

		local var_3_3 = arg_3_1:get("imgTitle"):getBoundingBox()

		arg_3_1:size(cc.size(var_3_1, var_3_3.height))
		arg_3_1:get("imgTitle"):y(var_3_3.height / 2)
		arg_3_1:get("imgBg"):y(var_3_3.height / 2)
	elseif var_3_2 == 4 then
		arg_3_1:get("imgBg"):visible(false)
		arg_3_1:get("imgTitle"):visible(false)
		arg_3_1:get("list"):visible(false)

		local var_3_4 = {}

		for iter_3_1, iter_3_2 in ipairs(arg_3_3) do
			local var_3_5 = csv.cards[iter_3_2.cfg.cardID]
			local var_3_6 = var_3_5.branch

			if not var_3_4[var_3_6] then
				var_3_4[var_3_6] = {}
			end

			iter_3_2.develop = var_3_5.develop
			iter_3_2.currRealBranch = var_3_5.branch
			iter_3_2.branch = {}
			iter_3_2.order = iter_3_1

			table.insert(var_3_4[var_3_6], iter_3_2)
		end

		local var_3_7
		local var_3_8 = csvSize(var_3_4)

		if var_3_4[0] and var_3_8 > 1 then
			var_3_8 = var_3_8 - 1
		end

		local var_3_9 = var_3_4[0] and #var_3_4[0] or 0
		local var_3_10 = 202 * var_3_8 + (var_3_8 - 1) * 3 + 40

		arg_3_1:size(cc.size(var_3_1, var_3_10 - 10))

		local var_3_11 = {}
		local var_3_12 = {}
		local var_3_13 = 0

		for iter_3_3, iter_3_4 in pairs(var_3_4) do
			table.sort(iter_3_4, function(arg_4_0, arg_4_1)
				return arg_4_0.develop < arg_4_1.develop
			end)

			if iter_3_3 ~= 0 then
				var_3_13 = var_3_13 + 1
			end

			local var_3_14 = {}
			local var_3_15 = iter_3_3 ~= 0 and var_3_9 or 0

			for iter_3_5, iter_3_6 in ipairs(iter_3_4) do
				local var_3_16 = csv.cards[iter_3_6.cfg.cardID]
				local var_3_17 = var_3_16.develop
				local var_3_18 = var_3_16.branch
				local var_3_19 = arg_3_0.cloneItem:clone()

				var_3_19:visible(true)
				arg_3_1:addChild(var_3_19, 10, "item" .. iter_3_6.order)

				local var_3_20 = var_3_19:size()

				if iter_3_6.isHas then
					var_3_7 = var_3_19
				end

				local var_3_21 = csv.unit[var_3_16.unitID].rarity

				var_3_19:get("cardPanel"):show()
				bind.extend(arg_3_0, var_3_19:get("cardPanel"), {
					class = "card_icon",
					props = {
						cardId = iter_3_6.cfg.cardID,
						rarity = var_3_21,
						grayState = iter_3_6.isHas and 0 or 2,
						selected = iter_3_6.isSel,
						onNode = function(arg_5_0)
							arg_5_0:xy(14, 3)
						end
					}
				})

				local var_3_22 = var_3_10 / 2 + (var_3_20.height + 15) * (var_3_8 / 2 - var_3_13 + 0.5)

				if var_3_8 == 1 or var_3_18 == 0 then
					var_3_22 = var_3_10 / 2
				end

				local var_3_23 = var_3_15 + iter_3_5

				var_3_19:xy(var_3_20.width / 2 + (var_3_23 - 1) * var_3_20.width, var_3_22)

				if not var_3_11[var_3_23] then
					var_3_11[var_3_23] = {}

					table.insert(var_3_12, var_3_23)
				end

				table.insert(var_3_11[var_3_23], var_3_19)
				bind.touch(arg_3_0, var_3_19:get("cardPanel"), {
					methods = {
						ended = functools.partial(arg_3_0.clickCell, arg_3_2, iter_3_6.order, iter_3_6.cfg.cardID, var_3_2)
					}
				})
			end
		end

		table.sort(var_3_12)

		local var_3_24 = {}
		local var_3_25 = true

		for iter_3_7, iter_3_8 in ipairs(var_3_12) do
			local var_3_26 = var_3_11[iter_3_8]

			var_0_4(var_3_24, var_3_26)

			var_3_24 = var_3_26
		end

		local var_3_27 = false

		for iter_3_9, iter_3_10 in ipairs(var_3_12) do
			local var_3_28 = var_3_11[iter_3_10]
			local var_3_29 = #var_3_28

			for iter_3_11, iter_3_12 in ipairs(var_3_28) do
				if not var_3_7 or var_3_7 == iter_3_12 then
					if var_3_29 == 1 then
						var_3_25 = false
					else
						var_3_27 = true
					end
				end

				for iter_3_13 = 1, 3 do
					local var_3_30 = iter_3_12:getChildByName("redline" .. iter_3_13)
					local var_3_31 = iter_3_12:getChildByName("line" .. iter_3_13)

					if var_3_30 then
						var_3_30:visible(var_3_25 and var_3_31:visible())
					end
				end
			end

			var_3_25 = var_3_27 and not var_3_25 or var_3_25
			var_3_27 = false
		end
	else
		arg_3_1:get("imgTitle"):visible(false)
		arg_3_1:get("imgBg"):visible(false)
		arg_3_1:get("list"):visible(true)

		local var_3_32 = arg_3_0.cloneItem:size()

		arg_3_1:size(cc.size(var_3_1, var_3_32.height + 10))
		arg_3_1:get("list"):size(cc.size(var_3_1, var_3_32.height + 10))

		local var_3_33 = {
			class = "listview",
			props = {
				data = arg_3_3,
				item = arg_3_0.cloneItem,
				topPadding = padding,
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					local var_6_0 = arg_6_1:size()
					local var_6_1 = csv.cards[arg_6_3.cfg.cardID]
					local var_6_2 = csv.unit[var_6_1.unitID].rarity

					bind.extend(arg_6_0, arg_6_1, {
						class = "card_icon",
						props = {
							cardId = arg_6_3.cfg.cardID,
							rarity = var_6_2,
							grayState = arg_6_3.isHas and 0 or 2,
							selected = arg_6_3.isSel,
							onNode = function(arg_7_0)
								arg_7_0:xy(14, 3)
							end
						}
					})
					arg_6_1:visible(true)
					bind.touch(arg_3_0, arg_6_1, {
						methods = {
							ended = functools.partial(arg_3_0.clickCell, arg_3_2, arg_6_2, arg_6_3.cfg.cardID, var_3_2)
						}
					})
				end
			}
		}

		bind.extend(arg_3_0, arg_3_1:get("list"), var_3_33)
	end
end

local var_0_6 = cc.load("mvc").ViewBase
local var_0_7 = class("HandbookView", var_0_6)

var_0_7.RESOURCE_FILENAME = "handbook.json"
var_0_7.RESOURCE_BINDING = {
	["center.textDesc"] = "textDescList",
	center = "center",
	item1 = "item1",
	["center.textLocation"] = "textLocation",
	textName = "centerName",
	item = "item",
	btnItem = "btnItem",
	attrTmp = "attrTmp",
	["center.imgIcon"] = "imgIcon",
	starItem = "starItem",
	attrItem = "attrItem",
	left = {
		varname = "left",
		binds = {
			event = "extend",
			class = "sort_menus",
			props = {
				expandUp = true,
				data = bindHelper.self("sortTabData"),
				btnClick = bindHelper.self("onSortMenusBtnClick", true),
				btnTouch = bindHelper.self("onCloseOtherView", true),
				showSortList = bindHelper.self("isDownListShow"),
				showSelected = bindHelper.self("sortType"),
				onNode = function(arg_8_0)
					arg_8_0:xy(-855, -392):z(20):scale(0.82)
				end
			}
		}
	},
	["left.textCount"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("hasCount")
		}
	},
	["left.btnAttrSort"] = {
		varname = "btnAttr",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowAttrPanel")
			}
		}
	},
	["left.btnAttrSort.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["left.btnUp.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["left.btnUp"] = {
		varname = "btnTupo",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onShowTupoPanel")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "handbookAdvance",
					onNode = function(arg_9_0)
						arg_9_0:xy(153, 55):scale(0.5)
					end
				}
			}
		}
	},
	["left.list"] = {
		varname = "leftList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 7,
				backupCached = false,
				data = bindHelper.self("cardDatas"),
				item = bindHelper.self("item1"),
				cloneItem = bindHelper.self("item"),
				preloadCenterIndex = bindHelper.self("preloadCenterIndex"),
				itemAction = {
					isAction = true,
					alwaysShow = true
				},
				onItem = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
					var_0_5(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onClickItem")
			}
		}
	},
	["left.btnShowAttrAdd"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowAllAttrPanel")
			}
		}
	},
	["center.btnFeel"] = {
		varname = "btnFeel",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnFeel")
			}
		}
	},
	["center.btnFeel.note"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["center.btnDetail"] = {
		varname = "btnDetail",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnDetail")
			}
		}
	},
	["center.btnDetail.note"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["center.attrPanel.hp.textNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("hpNum")
		}
	},
	["center.attrPanel.attack.textNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("damageNum")
		}
	},
	["center.attrPanel.special.textNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("specialDamageNum")
		}
	},
	["center.attrPanel.phyFang.textNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("defenceNum")
		}
	},
	["center.attrPanel.speFang.textNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("specialDefenceNum")
		}
	},
	["center.attrPanel.speed.textNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("speedNum")
		}
	},
	["center.attrPanel.hp.progressBar"] = {
		binds = {
			event = "percent",
			idler = bindHelper.self("hpPercent")
		}
	},
	["center.attrPanel.attack.progressBar"] = {
		binds = {
			event = "percent",
			idler = bindHelper.self("damagePercent")
		}
	},
	["center.attrPanel.special.progressBar"] = {
		binds = {
			event = "percent",
			idler = bindHelper.self("specialDamagePercent")
		}
	},
	["center.attrPanel.phyFang.progressBar"] = {
		binds = {
			event = "percent",
			idler = bindHelper.self("defencePercent")
		}
	},
	["center.attrPanel.speFang.progressBar"] = {
		binds = {
			event = "percent",
			idler = bindHelper.self("specialDefencePercent")
		}
	},
	["center.attrPanel.speed.progressBar"] = {
		binds = {
			event = "percent",
			idler = bindHelper.self("speedPercent")
		}
	},
	["center.starList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("starDatas"),
				item = bindHelper.self("starItem"),
				onItem = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
					arg_11_1:get("icon"):texture(arg_11_3.icon):scale(0.45)
				end
			}
		}
	},
	["center.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("curCardAttrAdd"),
				item = bindHelper.self("attrItem"),
				onItem = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
					local var_12_0 = game.ATTRDEF_TABLE[arg_12_3.attrType]
					local var_12_1 = "attr" .. string.caption(var_12_0)
					local var_12_2 = arg_12_1:get("textName")
					local var_12_3 = arg_12_1:get("textNum")

					var_12_2:text(gLanguageCsv[var_12_1])
					var_12_3:text("+" .. arg_12_3.val)

					local var_12_4 = ui.ATTR_LOGO[game.ATTRDEF_TABLE[arg_12_3.attrType]]

					arg_12_1:get("imgIcon"):texture(var_12_4)
					adapt.oneLinePos(arg_12_1:get("imgIcon"), var_12_2, cc.p(24, 0))
					adapt.oneLinePos(var_12_2, var_12_3, cc.p(12, 0))

					local var_12_5 = var_12_3:box()

					arg_12_1:size(var_12_3:x() + var_12_5.width + 40, var_12_5.height)
				end
			},
			handlers = {
				clickItem = bindHelper.self("onChangeView")
			}
		}
	},
	["btnItem.btnClick.textNote"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 2,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			}
		}
	},
	["pageList.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("btnsData"),
				item = bindHelper.self("btnItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
					arg_13_1:get("btnClick"):visible(arg_13_3.state)
					arg_13_1:get("btnNormal"):visible(not arg_13_3.state)
					;(arg_13_3.state and arg_13_1:get("btnClick") or arg_13_1:get("btnNormal")):get("textNote"):text(arg_13_3.text)
					bind.touch(arg_13_0, arg_13_1:get("btnNormal"), {
						methods = {
							ended = functools.partial(arg_13_0.clickItem, arg_13_2, arg_13_3)
						}
					})
				end
			},
			handlers = {
				clickItem = bindHelper.self("onChangeView")
			}
		}
	},
	["center.textHeightNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("textHight")
		}
	},
	["center.textWeightNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("textWeight")
		}
	},
	upList = {
		varname = "upList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("cardAttrs"),
				item = bindHelper.self("attrTmp"),
				onItem = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
					local var_14_0 = ui.ATTR_ICON[arg_14_3]

					arg_14_1:get("imgIcon"):texture(var_14_0)
				end
			}
		}
	},
	["center.attrPanel.textSum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("allVal")
		}
	}
}

function var_0_7.resetData(arg_15_0, arg_15_1, arg_15_2)
	arg_15_1 = arg_15_1 or {}

	local var_15_0 = {}
	local var_15_1 = csv.cards
	local var_15_2 = csv.unit

	if arg_15_2 == 1 then
		local var_15_3 = {}

		for iter_15_0, iter_15_1 in ipairs(arg_15_1) do
			local var_15_4 = var_15_1[iter_15_1.cfg.cardID]
			local var_15_5 = var_15_2[var_15_4.unitID].rarity
			local var_15_6 = var_15_4.cardMarkID
			local var_15_7 = arg_15_2 == 1 and var_15_5 or var_15_6

			if not var_15_0[var_15_7] then
				var_15_0[var_15_7] = {}

				table.insert(var_15_3, var_15_7)
			end

			table.insert(var_15_0[var_15_7], iter_15_1)
		end

		table.sort(var_15_3, function(arg_16_0, arg_16_1)
			if arg_15_2 == 1 then
				return arg_16_1 < arg_16_0
			else
				return arg_16_0 < arg_16_1
			end
		end)

		local var_15_8 = {}

		for iter_15_2, iter_15_3 in ipairs(var_15_3) do
			table.insert(var_15_8, var_15_0[iter_15_3])
		end

		var_15_0 = var_15_8

		for iter_15_4, iter_15_5 in ipairs(var_15_0) do
			table.sort(iter_15_5, function(arg_17_0, arg_17_1)
				local var_17_0 = arg_17_0.cfg.cardID
				local var_17_1 = arg_17_1.cfg.cardID

				if arg_15_2 == 1 then
					return arg_17_0.cfg.sort < arg_17_1.cfg.sort
				end

				local var_17_2 = var_15_1[var_17_0]
				local var_17_3 = var_15_1[var_17_1]

				if var_17_2.develop ~= var_17_3.develop then
					return var_17_2.develop < var_17_3.develop
				end

				return var_17_2.branch < var_17_3.branch
			end)
		end
	elseif arg_15_2 == 2 then
		var_15_0[1] = {}

		for iter_15_6, iter_15_7 in ipairs(arg_15_1) do
			if arg_15_0.pokedex:read()[iter_15_7.cfg.cardID] then
				table.insert(var_15_0[1], iter_15_7)
			end
		end

		for iter_15_8, iter_15_9 in ipairs(var_15_0) do
			table.sort(iter_15_9, function(arg_18_0, arg_18_1)
				local var_18_0 = var_15_1[arg_18_0.cfg.cardID]
				local var_18_1 = var_15_2[var_18_0.unitID].rarity
				local var_18_2 = var_15_1[arg_18_1.cfg.cardID]
				local var_18_3 = var_15_2[var_18_2.unitID].rarity

				if var_18_1 == var_18_3 then
					return arg_18_0.cfg.sort < arg_18_1.cfg.sort
				end

				return var_18_3 < var_18_1
			end)
		end
	elseif arg_15_2 == 3 then
		var_15_0[1] = {}

		for iter_15_10, iter_15_11 in ipairs(arg_15_1) do
			if not arg_15_0.pokedex:read()[iter_15_11.cfg.cardID] then
				table.insert(var_15_0[1], iter_15_11)
			end
		end

		for iter_15_12, iter_15_13 in ipairs(var_15_0) do
			table.sort(iter_15_13, function(arg_19_0, arg_19_1)
				local var_19_0 = var_15_1[arg_19_0.cfg.cardID]
				local var_19_1 = var_15_2[var_19_0.unitID].rarity
				local var_19_2 = var_15_1[arg_19_1.cfg.cardID]
				local var_19_3 = var_15_2[var_19_2.unitID].rarity

				if var_19_1 == var_19_3 then
					return arg_19_0.cfg.sort < arg_19_1.cfg.sort
				end

				return var_19_3 < var_19_1
			end)
		end
	end

	return var_15_0
end

function var_0_7.onCreate(arg_20_0, arg_20_1)
	arg_20_1 = arg_20_1 or {}
	arg_20_0.leftColumnSize = var_0_1

	arg_20_0:initModel()
	gGameModel.handbook:getIdlerOrigin("isNew"):set(false)
	gGameUI.topuiManager:createView("title", arg_20_0, {
		onClose = arg_20_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = "city/handbook/txt_renzhetujian.png"
	})

	arg_20_0.isDownListShow = idler.new(false)
	arg_20_0.selItemInfo = arg_20_0.selItemInfo or {}
	arg_20_0.sortTabData = idlertable.new({
		gLanguageCsv.rarity,
		gLanguageCsv.alreadyHas,
		gLanguageCsv.notOwn
	})
	arg_20_0.isShowNaturePanel = idler.new(false)
	arg_20_0.textDesc = idler.new("")
	arg_20_0.textAddNum = idler.new("")
	arg_20_0.textHight = idler.new("")
	arg_20_0.textWeight = idler.new("")
	arg_20_0.hasCount = idler.new(itertools.size(arg_20_0.pokedex:read()))
	arg_20_0.allVal = idler.new(0)
	arg_20_0.curSelAttrs = idlertable.new({})
	arg_20_0.cardAttrs = idlertable.new({})
	arg_20_0.sortType = idler.new(1)
	arg_20_0._selCardId = arg_20_0._selCardId or arg_20_1.cardId
	arg_20_0.selCardId = idler.new(arg_20_0._selCardId or 0)
	arg_20_0.curSelBtn = arg_20_0.curSelBtn or 1

	local var_20_0 = {
		{
			state = false,
			text = gLanguageCsv.detail,
			func = function()
				arg_20_0.center:visible(true)
				arg_20_0.centerName:visible(true)
				arg_20_0.upList:visible(true)
			end
		},
		{
			state = false,
			text = gLanguageCsv.produce,
			func = function(arg_22_0)
				arg_20_0.center:visible(false)
				arg_20_0.centerName:visible(false)
				arg_20_0.upList:visible(false)

				return gGameUI:createView("city.handbook.gain_way", arg_20_0):init(arg_22_0)
			end
		},
		{
			state = false,
			text = gLanguageCsv.skill,
			func = function(arg_23_0)
				arg_20_0.center:visible(false)
				arg_20_0.centerName:visible(true)
				arg_20_0.upList:visible(true)

				return gGameUI:createView("city.handbook.skill", arg_20_0):init(arg_23_0)
			end
		},
		{
			state = false,
			text = gLanguageCsv.fetter,
			func = function(arg_24_0)
				arg_20_0.center:visible(false)
				arg_20_0.centerName:visible(true)
				arg_20_0.upList:visible(true)

				return gGameUI:createView("city.handbook.fetter", arg_20_0):init(arg_24_0)
			end
		}
	}

	arg_20_0.btnsData = idlers.newWithMap(var_20_0)

	local var_20_1 = {}

	for iter_20_0 = 1, 5 do
		table.insert(var_20_1, {
			state = false
		})
	end

	arg_20_0.natureDatas = idlers.newWithMap(arg_20_0._natureDatas or var_20_1)
	arg_20_0.cardDatas = idlers.newWithMap({})
	arg_20_0.cardTabDatas = {}

	idlereasy.any({
		arg_20_0.sortType,
		arg_20_0.curSelAttrs
	}, function(arg_25_0, arg_25_1, arg_25_2)
		arg_20_0:refreshSortCardIdlersData()
	end)

	local var_20_2 = {
		"hpNum",
		"speedNum",
		"damageNum",
		"defenceNum",
		"specialDamageNum",
		"specialDefenceNum"
	}
	local var_20_3 = {
		"hpPercent",
		"speedPercent",
		"damagePercent",
		"defencePercent",
		"specialDamagePercent",
		"specialDefencePercent"
	}

	arg_20_0.hpNum = idler.new(0)
	arg_20_0.hpPercent = idler.new(0)
	arg_20_0.damageNum = idler.new(0)
	arg_20_0.damagePercent = idler.new(0)
	arg_20_0.specialDamageNum = idler.new(0)
	arg_20_0.specialDamagePercent = idler.new(0)
	arg_20_0.defenceNum = idler.new(0)
	arg_20_0.defencePercent = idler.new(0)
	arg_20_0.specialDefenceNum = idler.new(0)
	arg_20_0.specialDefencePercent = idler.new(0)
	arg_20_0.speedNum = idler.new(0)
	arg_20_0.speedPercent = idler.new(0)
	arg_20_0.curCardAttrAdd = idlers.newWithMap({})
	arg_20_0.starDatas = idlers.new({})

	local var_20_4 = {
		0,
		nil,
		nil,
		nil,
		nil,
		nil,
		0,
		0,
		0,
		0,
		nil,
		nil,
		0
	}

	for iter_20_1, iter_20_2 in pairs(arg_20_0.pokedex:read()) do
		local var_20_5 = gHandbookCsv[iter_20_1]

		if var_20_5 then
			for iter_20_3 = 1, math.huge do
				local var_20_6 = var_20_5["attrType" .. iter_20_3]

				if not var_20_6 then
					break
				end

				local var_20_7 = 1

				if var_20_6 >= 9 then
					local var_20_8 = 2
				end

				local var_20_9, var_20_10 = dataEasy.parsePercentStr(var_20_5["attrValue" .. iter_20_3])

				var_20_4[var_20_6] = var_20_4[var_20_6] + var_20_9
			end
		end
	end

	arg_20_0.attrDatas = idlers.newWithMap(var_20_4)

	idlereasy.when(arg_20_0.selCardId, function(arg_26_0, arg_26_1)
		local var_26_0 = csv.cards[arg_26_1]

		if var_26_0 then
			arg_20_0.textLocation:text(var_26_0.location)

			local var_26_1 = gHandbookCsv[arg_26_1]
			local var_26_2 = var_26_1.heightAndWeight
			local var_26_3 = var_26_2[2] .. "kg"
			local var_26_4 = var_26_2[1] .. "m"
			local var_26_5 = var_26_0.introduction

			arg_20_0.centerName:text(var_26_0.name)
			adapt.oneLinePos(arg_20_0.centerName, arg_20_0.upList, cc.p(28, 0))

			local var_26_6 = {}

			for iter_26_0 = 1, math.huge do
				local var_26_7 = var_26_1["attrType" .. iter_26_0]

				if not var_26_7 then
					break
				end

				local var_26_8 = arg_20_0.pokedex:read()[arg_26_1] ~= nil
				local var_26_9, var_26_10 = dataEasy.parsePercentStr(var_26_1["attrValue" .. iter_26_0])
				local var_26_11 = mathEasy.getPreciseDecimal(var_26_9, 2)

				if var_26_10 then
					var_26_11 = var_26_11 .. "%"
				end

				table.insert(var_26_6, {
					attrType = var_26_7,
					val = var_26_11,
					hasRole = var_26_8
				})
			end

			arg_20_0.curCardAttrAdd:update(var_26_6)
			arg_20_0:resetStarData()

			local var_26_12 = cc.c3b(57, 253, 57)

			arg_20_0.textHight:set(var_26_4)
			arg_20_0.textWeight:set(var_26_3)
			beauty.textScroll({
				isRich = true,
				strs = "",
				list = arg_20_0.textDescList
			})
			beauty.textScroll({
				isRich = true,
				list = arg_20_0.textDescList,
				strs = "#C0x5b545b#" .. var_26_5
			})

			local var_26_13 = var_26_0.unitID
			local var_26_14 = csv.unit[var_26_13]

			if arg_20_0.imgIcon:get("imgshow") then
				arg_20_0.imgIcon:get("imgshow"):removeSelf()
			end

			local var_26_15 = string.gsub(var_26_14.unitRes, ".skel", "_ui.skel")

			widget.addAnimationByKey(arg_20_0.imgIcon, var_26_15, "imgshow", "standby_loop", 1):xy(arg_20_0.imgIcon:size().width / 2, -15)
			arg_20_0.imgIcon:visible(true)

			local var_26_16 = var_26_0.specValue

			for iter_26_1, iter_26_2 in ipairs(var_26_16) do
				if iter_26_1 > 6 then
					arg_20_0.allVal:set(iter_26_2)

					break
				end

				arg_20_0[var_20_2[iter_26_1]]:set(iter_26_2)
				arg_20_0[var_20_3[iter_26_1]]:set(iter_26_2 / 255 * 100)
			end

			local var_26_17 = {}

			table.insert(var_26_17, var_26_14.natureType)

			if var_26_14.natureType2 then
				table.insert(var_26_17, var_26_14.natureType2)
			end

			arg_20_0.cardAttrs:set(var_26_17)
		else
			arg_20_0.centerName:text("")
			beauty.textScroll({
				isRich = true,
				strs = "",
				list = arg_20_0.textDescList
			})
			arg_20_0.textAddNum:set("")
			arg_20_0.textHight:set("")
			arg_20_0.textWeight:set("")
			arg_20_0.imgIcon:visible(false)

			for iter_26_3 = 1, 7 do
				if iter_26_3 > 6 then
					arg_20_0.allVal:set(0)

					break
				end

				arg_20_0[var_20_2[iter_26_3]]:set(0)
				arg_20_0[var_20_3[iter_26_3]]:set(0)
			end

			arg_20_0.cardAttrs:set({})
		end
	end)

	if matchLanguage({
		"en",
		"kr"
	}) then
		adapt.setTextAdaptWithSize(arg_20_0.textLocation, {
			margin = -5,
			horizontal = "left",
			vertical = "center",
			size = cc.size(570, 100)
		})
	end

	arg_20_0.attrPanel = gGameUI:createView("common.attr_filter", arg_20_0):init({
		isMultiSelect = true,
		selectDatas = arg_20_0:createHandler("natureDatas"),
		panelState = arg_20_0:createHandler("isShowNaturePanel")
	}):anchorPoint(0.5, 0):xy(-720, -195):z(20)

	idlereasy.if_not(arg_20_0.isShowNaturePanel, function()
		arg_20_0:onSureSelNature()
	end)
	idlereasy.when(arg_20_0.isShowNaturePanel, function(arg_28_0, arg_28_1)
		arg_20_0.attrPanel:visible(arg_28_1)
	end)
	uiEasy.updateUnlockRes(gUnlockCsv.cardLike, arg_20_0.btnFeel, {
		pos = cc.p(120, 100)
	})
	idlereasy.any({
		arg_20_0.cardFeels,
		arg_20_0.selCardId,
		arg_20_0.roleLevel
	}, function(arg_29_0, arg_29_1, arg_29_2)
		local var_29_0 = arg_29_1[csv.cards[arg_29_2].cardMarkID] or {}

		arg_20_0.btnFeel:get("level"):text(var_29_0.level or 0)
	end)

	if arg_20_0._sortType or arg_20_1.sortType then
		arg_20_0.sortType:set(arg_20_0._sortType or arg_20_1.sortType)
	end

	arg_20_0:onChangeView(nil, arg_20_0.curSelBtn)

	arg_20_0._selCardId = nil
end

function var_0_7.jumpToCard(arg_30_0, arg_30_1)
	if arg_30_0._selCardId then
		for iter_30_0, iter_30_1 in ipairs(arg_30_1) do
			for iter_30_2, iter_30_3 in ipairs(iter_30_1) do
				if iter_30_3.cfg and iter_30_3.cfg.cardID == arg_30_0._selCardId then
					arg_30_1[iter_30_0][iter_30_2].isSel = true
					arg_30_0.selItemInfo = {
						row = iter_30_0,
						idx = iter_30_2
					}

					arg_30_0.selCardId:set(arg_30_0._selCardId)

					arg_30_0.preloadCenterIndex = iter_30_0

					return true
				end
			end
		end
	end
end

function var_0_7.refreshSortCardIdlersData(arg_31_0)
	arg_31_0.leftList:jumpToTop()

	local var_31_0 = arg_31_0.sortType:read()
	local var_31_1 = {}

	for iter_31_0, iter_31_1 in ipairs(gHandbookArrayCsv) do
		local var_31_2 = {
			cfg = iter_31_1,
			itemType = arg_31_0.sortType:read(),
			isHas = arg_31_0.pokedex:read()[iter_31_1.cardID] ~= nil
		}

		var_31_2.isSel = false

		if arg_31_0.curSelAttrs:size() > 0 then
			local var_31_3 = csv.cards[iter_31_1.cardID]
			local var_31_4 = csv.unit[var_31_3.unitID]

			if itertools.include(arg_31_0.curSelAttrs:proxy(), var_31_4.natureType) or itertools.include(arg_31_0.curSelAttrs:proxy(), var_31_4.natureType2) then
				table.insert(var_31_1, var_31_2)
			end
		else
			table.insert(var_31_1, var_31_2)
		end
	end

	local var_31_5 = arg_31_0:resetData(var_31_1, var_31_0)
	local var_31_6 = arg_31_0:resetDataStruct(var_31_5, var_31_0)
	local var_31_7 = var_31_0 == 1 and 2 or 1

	if not arg_31_0:jumpToCard(var_31_6) and var_31_6[var_31_7] and var_31_6[var_31_7][1] then
		var_31_6[var_31_7][1].isSel = true
		arg_31_0.selItemInfo = {
			idx = 1,
			row = var_31_7
		}

		arg_31_0.selCardId:set(var_31_6[var_31_7][1].cfg.cardID)
	end

	arg_31_0.cardDatas:update(var_31_6)
end

function var_0_7.resetStarData(arg_32_0)
	local var_32_0 = csv.cards[arg_32_0.selCardId:read()]
	local var_32_1, var_32_2, var_32_3 = dataEasy.getCardMaxStar(var_32_0.cardMarkID)

	arg_32_0.starDatas:update(dataEasy.getStarData(var_32_1))

	local var_32_4, var_32_5, var_32_6 = var_0_0.getStarAttrData(var_32_0.cardMarkID)

	var_0_0.setAttrPanel(arg_32_0.center:get("starAttr"), var_32_4, var_32_5, var_32_6)

	local var_32_7

	var_32_7 = arg_32_0.pokedex:read()[arg_32_0.selCardId:read()] ~= nil
end

function var_0_7.resetDataStruct(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = {}

	if arg_33_2 == 1 then
		local var_33_1 = false

		for iter_33_0, iter_33_1 in ipairs(arg_33_1) do
			local var_33_2 = false
			local var_33_3 = {}

			for iter_33_2, iter_33_3 in ipairs(iter_33_1) do
				if not var_33_2 then
					var_33_2 = true

					local var_33_4 = csv.cards[iter_33_3.cfg.cardID]
					local var_33_5 = csv.unit[var_33_4.unitID].rarity

					table.insert(var_33_0, {
						{
							itemType = "title",
							val = var_33_5
						}
					})
				end

				if iter_33_2 % 4 == 1 then
					if iter_33_2 > 4 then
						table.insert(var_33_0, var_33_3)
					end

					var_33_3 = {}
				end

				table.insert(var_33_3, iter_33_3)
			end

			if #var_33_3 > 0 then
				table.insert(var_33_0, var_33_3)

				local var_33_6 = {}
			end
		end
	else
		local var_33_7 = {}
		local var_33_8 = 0

		for iter_33_4, iter_33_5 in ipairs(arg_33_1[1] or {}) do
			if iter_33_4 % 4 == 1 then
				if iter_33_4 > 4 then
					var_33_8 = var_33_8 + 1

					table.insert(var_33_0, var_33_7)
				end

				var_33_7 = {}
			end

			table.insert(var_33_7, iter_33_5)
		end

		if #var_33_7 > 0 then
			table.insert(var_33_0, var_33_7)
		end
	end

	return var_33_0
end

function var_0_7.initModel(arg_34_0)
	arg_34_0.pokedex = gGameModel.role:getIdler("pokedex")
	arg_34_0.cardFeels = gGameModel.role:getIdler("card_feels")
	arg_34_0.roleLevel = gGameModel.role:getIdler("level")
end

function var_0_7.onCleanup(arg_35_0)
	arg_35_0._sortType = arg_35_0.sortType:read()
	arg_35_0._selCardId = arg_35_0.selCardId:read()
	arg_35_0._natureDatas = {}

	for iter_35_0, iter_35_1 in arg_35_0.natureDatas:ipairs() do
		if iter_35_0 < 6 then
			table.insert(arg_35_0._natureDatas, table.deepcopy(iter_35_1:read(), true))
		end
	end

	var_0_6.onCleanup(arg_35_0)
end

function var_0_7.onShowAttrPanel(arg_36_0, arg_36_1, arg_36_2)
	arg_36_0.isShowNaturePanel:modify(function(arg_37_0)
		return true, not arg_37_0
	end)
	arg_36_0.isDownListShow:set(false)
end

function var_0_7.onSureSelNature(arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = {}

	for iter_38_0 = 1, 5 do
		if arg_38_0.natureDatas:atproxy(iter_38_0).state then
			table.insert(var_38_0, iter_38_0)
		end
	end

	arg_38_0.curSelAttrs:set(var_38_0)
end

function var_0_7.onClickItem(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5)
	arg_39_0.cardDatas:atproxy(arg_39_0.selItemInfo.row)[arg_39_0.selItemInfo.idx].isSel = false
	arg_39_0.selItemInfo = {
		row = arg_39_2,
		idx = arg_39_3
	}
	arg_39_0.cardDatas:atproxy(arg_39_2)[arg_39_3].isSel = true

	arg_39_0.selCardId:set(arg_39_4)
end

function var_0_7.onShowTupoPanel(arg_40_0, arg_40_1, arg_40_2)
	gGameUI:stackUI("city.handbook.break", nil, {
		blackLayer = true
	})
end

function var_0_7.onSortMenusBtnClick(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
	if arg_41_3 == arg_41_0.sortType:read() then
		return
	end

	arg_41_0.leftList:getInnerContainer():setPosition(cc.p(0, 0))
	arg_41_0.leftList:setInnerContainerSize(cc.size(0, 0))
	arg_41_0.sortType:set(arg_41_3)
end

function var_0_7.onCloseOtherView(arg_42_0, arg_42_1, arg_42_2)
	arg_42_0.isShowNaturePanel:set(false)
end

function var_0_7.onBtnComment(arg_43_0)
	local var_43_0 = gHandbookCsv[arg_43_0.selCardId:read()]

	if var_43_0 and not var_43_0.isOpen then
		gGameUI:showTip(gLanguageCsv.currentVersionNotOpen)

		return
	end

	gGameApp:requestServer("/game/card/comment/list", function(arg_44_0)
		gGameApp:requestServer("/game/card/score/get", function(arg_45_0)
			gGameUI:stackUI("city.card.comment", nil, {
				full = true
			}, arg_43_0.selCardId:read(), arg_44_0.view, arg_45_0.view)
		end, arg_43_0.selCardId:read())
	end, arg_43_0.selCardId:read(), 0, 20)
end

function var_0_7.onBtnFeel(arg_46_0)
	local var_46_0 = arg_46_0.selCardId:read()
	local var_46_1 = csv.cards[var_46_0]
	local var_46_2 = gHandbookCsv[var_46_0]

	if var_46_2 and not var_46_2.isOpen then
		gGameUI:showTip(gLanguageCsv.currentVersionNotOpen)

		return
	end

	if csvSize(var_46_1.feelItems) <= 0 then
		gGameUI:showTip(gLanguageCsv.notDevelopFeel)

		return
	end

	if not dataEasy.isUnlock(gUnlockCsv.cardLike) then
		gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.cardLike))

		return
	end

	if csv.card_mega[var_46_1.megaIndex] and not dataEasy.isUnlock(gUnlockCsv.mega) then
		gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.mega))

		return
	end

	local var_46_3 = arg_46_0.cardDatas:atproxy(arg_46_0.selItemInfo.row)[arg_46_0.selItemInfo.idx].cfg.cardID
	local var_46_4 = csv.cards
	local var_46_5 = false

	for iter_46_0, iter_46_1 in pairs(arg_46_0.pokedex:read()) do
		if var_46_4[iter_46_0].cardMarkID == var_46_4[var_46_3].cardMarkID then
			var_46_5 = true

			break
		end
	end

	if not var_46_5 then
		gGameUI:showTip(gLanguageCsv.wizardNotActivated)

		return
	end

	gGameUI:stackUI("city.card.feel.view", nil, nil, var_46_0)
end

function var_0_7.onBtnDetail(arg_47_0)
	local var_47_0 = gHandbookCsv[arg_47_0.selCardId:read()]

	if var_47_0 and not var_47_0.isOpen then
		gGameUI:showTip(gLanguageCsv.currentVersionNotOpen)

		return
	end

	gGameUI:stackUI("city.handbook.detail", nil, nil, arg_47_0.selCardId:read(), arg_47_0:createHandler("resetStarData"))
end

function var_0_7.onShowAllAttrPanel(arg_48_0)
	gGameUI:stackUI("city.handbook.add_attr", nil, {
		blackLayer = false,
		clickClose = true
	})
end

function var_0_7.onChangeView(arg_49_0, arg_49_1, arg_49_2, arg_49_3)
	arg_49_0.btnsData:atproxy(arg_49_0.curSelBtn).state = false
	arg_49_0.btnsData:atproxy(arg_49_2).state = true
	arg_49_0.curSelBtn = arg_49_2

	local var_49_0 = arg_49_0.btnsData:atproxy(arg_49_2).func

	if var_49_0 then
		if arg_49_0.childView then
			arg_49_0.childView:onClose()
		end

		arg_49_0.childView = var_49_0({
			selCardId = arg_49_0:createHandler("selCardId")
		})
	end

	adapt.oneLinePos(arg_49_0.centerName, arg_49_0.upList, cc.p(28, 0))
end

return var_0_7
