local var_0_0 = require("app.views.city.card.helditem.tools")
local var_0_1 = {
	dress = 1,
	down = 2
}
local var_0_2 = 450
local var_0_3 = class("HeldItemBagView", Dialog)

var_0_3.RESOURCE_FILENAME = "held_item_bag.json"
var_0_3.RESOURCE_BINDING = {
	roleItem = "roleItem",
	innweList = "innweList",
	["right.center.list"] = "rightCenterList",
	["right.roleInfo.roleItem"] = "roleInfoItem",
	attrInnerList = "attrInnerList",
	item1 = "item1",
	["right.center"] = "rightCenter",
	item = "item",
	left = "left",
	["right.item"] = "rightItem",
	["left.title.textNote1"] = {
		varname = "textNote1",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE1
				}
			}
		}
	},
	["left.title.textNote2"] = {
		varname = "textNote2",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE1
				}
			}
		}
	},
	["left.title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["left.btnLeft"] = {
		varname = "btnLeft",
		binds = {
			event = "extend",
			class = "sort_menus",
			props = {
				btnType = 4,
				data = bindHelper.self("leftSortData"),
				btnClick = bindHelper.self("onSortLeftMenusBtnClick", true),
				btnTouch = bindHelper.self("onCloseLeftOtherView", true),
				showSortList = bindHelper.self("isLeftDownListShow"),
				showSelected = bindHelper.self("showLeftSelected"),
				onNode = function(arg_1_0)
					arg_1_0:xy(-1120, -486)
				end
			}
		}
	},
	["left.btnRight"] = {
		varname = "btnRight",
		binds = {
			event = "extend",
			class = "sort_menus",
			props = {
				btnType = 4,
				data = bindHelper.self("rightSortData"),
				btnClick = bindHelper.self("onSortRightMenusBtnClick", true),
				btnTouch = bindHelper.self("onCloseRightOtherView", true),
				showSortList = bindHelper.self("isRightDownListShow"),
				showSelected = bindHelper.self("showRightSelected"),
				onNode = function(arg_2_0)
					arg_2_0:xy(-1067, -486)
				end
			}
		}
	},
	["left.noItem"] = {
		varname = "noItem",
		binds = {
			event = "visible",
			idler = bindHelper.self("hasItem")
		}
	},
	["left.handbook"] = {
		varname = "handbook",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("bagHandbook")
			}
		}
	},
	["left.handbook.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	right = {
		varname = "rightPanel",
		binds = {
			event = "visible",
			idler = bindHelper.self("isVisibleRight")
		}
	},
	["left.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				leftPadding = 10,
				asyncPreload = 25,
				topPadding = 10,
				columnSize = 5,
				data = bindHelper.self("heldItems"),
				item = bindHelper.self("innweList"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true,
					alwaysShow = true
				},
				onCell = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_3.inMeteor and 1 or 0

					arg_3_1:get("imgSel"):visible(arg_3_3.isSel)
					arg_3_1:get("tips"):text(gLanguageCsv.inMeteor):visible(var_3_0 == 1)
					bind.extend(arg_3_0, arg_3_1, {
						class = "icon_key",
						props = {
							noListener = true,
							data = {
								key = arg_3_3.csvId,
								num = arg_3_3.num,
								dbId = arg_3_3.dbId[1]
							},
							grayState = var_3_0,
							specialKey = {
								lv = arg_3_3.lv
							},
							onNode = function(arg_4_0)
								local var_4_0 = arg_3_0:getIdx(arg_3_2)

								bind.click(arg_3_0, arg_4_0, {
									method = functools.partial(arg_3_0.clickCell, var_4_0, arg_3_3)
								})
							end
						}
					})

					local var_3_1 = arg_3_3.dbId[1]
					local var_3_2 = gGameModel.held_items:find(var_3_1)
					local var_3_3 = var_3_2 and var_3_2:read("exist_flag", "card_db_id")

					if var_3_3 and var_3_3.card_db_id then
						bind.extend(arg_3_0, arg_3_1:get("redHint"), {
							class = "red_hint",
							props = {
								listenData = {
									curDbId = idler.new(var_3_1)
								},
								specialTag = {
									"heldItemLevelUp",
									"heldItemAdvanceUp"
								}
							}
						})
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	},
	["right.textName"] = {
		varname = "heldItemName",
		binds = {
			event = "text",
			idler = bindHelper.self("itemName")
		}
	},
	["right.textLv"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("itemLv")
		}
	},
	["right.roleInfo"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("hasRoleDress")
		}
	},
	["right.list"] = {
		varname = "rightlist",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 2,
				data = bindHelper.self("attrs"),
				item = bindHelper.self("attrInnerList"),
				cell = bindHelper.self("item1"),
				onCell = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					local var_5_0 = game.ATTRDEF_TABLE[arg_5_3.attr]
					local var_5_1 = gLanguageCsv["attr" .. string.caption(var_5_0)]
					local var_5_2 = ui.ATTR_LOGO[var_5_0]

					arg_5_1:get("imgIcon"):texture(var_5_2)
					arg_5_1:get("textAttrName"):text(var_5_1)
					arg_5_1:get("textAttrNum"):text("+" .. arg_5_3.val)
					adapt.oneLinePos(arg_5_1:get("textAttrName"), arg_5_1:get("textAttrNum"), cc.p(10, 0), "left")
				end
			}
		}
	},
	["right.center.btnInfo"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onInfoClick")
			}
		}
	},
	["right.down.list"] = {
		varname = "downlist",
		binds = {
			{
				event = "visible",
				idler = bindHelper.self("hasShowCards")
			},
			{
				event = "extend",
				class = "listview",
				props = {
					data = bindHelper.self("tabCards"),
					item = bindHelper.self("roleItem"),
					itemAction = {
						isAction = true,
						alwaysShow = true
					},
					onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
						bind.extend(arg_6_0, arg_6_1, {
							class = "card_icon",
							props = {
								rarity = arg_6_3.rarity,
								cardId = arg_6_3.card.id,
								onNode = function(arg_7_0)
									arg_7_0:scale(0.9)
								end
							}
						})
					end
				}
			}
		}
	},
	["right.down"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("hasShowCards")
		}
	},
	["right.btnStrengthen"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onStrengthenClick")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					state = bindHelper.self("curItemOnCard"),
					listenData = {
						curDbId = bindHelper.self("curSelDbId")
					},
					specialTag = {
						"heldItemLevelUp",
						"heldItemAdvanceUp"
					},
					onNode = function(arg_8_0)
						arg_8_0:scale(0.66)
					end
				}
			}
		}
	},
	["right.btnStrengthen.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["right.btnDress"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDressClick")
			}
		}
	},
	["right.btnDress.textNote"] = {
		binds = {
			{
				event = "text",
				idler = bindHelper.self("btnText")
			},
			{
				event = "effect",
				data = {
					outline = {
						size = 2,
						color = ui.NEWCOLORS.OUTLINE.YELLOW1
					}
				}
			}
		}
	}
}

function var_0_3.onCreate(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0:initModel()
	Dialog.onCreate(arg_9_0)
	dataEasy.getListenUnlock(gUnlockCsv.propHandbook, function(arg_10_0)
		arg_9_0.handbook:visible(arg_10_0)
	end)

	arg_9_0.cardDbId = arg_9_1 or arg_9_0.cards:read()[1]
	arg_9_0.handlers = arg_9_2

	adapt.oneLinePos(arg_9_0.textNote1, arg_9_0.textNote2)

	arg_9_0.isVisibleRight = idler.new(false)
	arg_9_0.curSelDbId = idler.new()
	arg_9_0.curItemOnCard = idler.new(true)
	arg_9_0.heldItems = idlers.newWithMap({})
	arg_9_0.hasItem = idler.new(false)
	arg_9_0.leftSortData = idlertable.new({
		gLanguageCsv.spaceAll,
		gLanguageCsv.aleardyDress,
		gLanguageCsv.notDress
	})
	arg_9_0.isLeftDownListShow = idler.new(false)
	arg_9_0.showLeftSelected = idler.new(1)
	arg_9_0.rightSortData = idlertable.new({
		gLanguageCsv.spaceQuality,
		gLanguageCsv.strengthenLv,
		gLanguageCsv.breachLv
	})
	arg_9_0.isRightDownListShow = idler.new(false)
	arg_9_0.showRightSelected = idler.new(1)
	arg_9_0.itemName = idler.new("")
	arg_9_0.itemLv = idler.new("")
	arg_9_0.curBtnState = idler.new(1)
	arg_9_0.attrs = idlers.newWithMap({})
	arg_9_0.tabCards = idlers.newWithMap({})
	arg_9_0.hasShowCards = idler.new(false)
	arg_9_0.btnText = idler.new(gLanguageCsv.spaceEquip)
	arg_9_0.hasRoleDress = idler.new(false)

	idlereasy.when(arg_9_0.curSelDbId, function(arg_11_0, arg_11_1)
		if not arg_11_1 then
			arg_9_0.curItemOnCard:set(false)
		end

		if type(arg_11_1) == "table" then
			arg_11_1 = arg_11_1[1]
		end

		local var_11_0 = gGameModel.held_items:find(arg_11_1)
		local var_11_1 = var_11_0 and var_11_0:read("exist_flag", "card_db_id")

		if var_11_1 and var_11_1.card_db_id then
			arg_9_0.curItemOnCard:set(true)
		else
			arg_9_0.curItemOnCard:set(false)
		end
	end)
	idlereasy.when(arg_9_0.isVisibleRight, function(arg_12_0, arg_12_1, arg_12_2)
		local var_12_0 = display.sizeInView.width / 2
		local var_12_1 = arg_9_0.left:size().width
		local var_12_2 = arg_12_1 and var_12_0 - var_12_1 / 2 - 17 or var_12_0

		arg_9_0.left:x(var_12_2)
	end)
	idlereasy.any({
		arg_9_0.showLeftSelected,
		arg_9_0.showRightSelected,
		arg_9_0.refreshFlag
	}, function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
		arg_9_0:refreshData()

		local var_13_0 = {}
		local var_13_1 = 0

		for iter_13_0, iter_13_1 in ipairs(arg_9_0.tableDatas) do
			if arg_13_1 == 2 and iter_13_1.cardDbID then
				var_13_1 = var_13_1 + 1

				table.insert(var_13_0, clone(iter_13_1))
			elseif arg_13_1 == 3 and not iter_13_1.cardDbID then
				var_13_1 = var_13_1 + 1

				table.insert(var_13_0, clone(iter_13_1))
			elseif arg_13_1 == 1 then
				var_13_1 = var_13_1 + 1

				table.insert(var_13_0, clone(iter_13_1))
			end
		end

		table.sort(var_13_0, function(arg_14_0, arg_14_1)
			if arg_13_2 == 1 then
				return dataEasy.sortHelditemCmp(arg_14_0, arg_14_1)
			elseif arg_13_2 == 2 then
				if arg_14_0.lv ~= arg_14_1.lv then
					return arg_14_0.lv > arg_14_1.lv
				end

				return dataEasy.sortHelditemCmp(arg_14_0, arg_14_1)
			elseif arg_13_2 == 3 then
				if arg_14_0.advance ~= arg_14_1.advance then
					return arg_14_0.advance > arg_14_1.advance
				end

				return dataEasy.sortHelditemCmp(arg_14_0, arg_14_1)
			end
		end)

		local var_13_2 = gGameModel.cards:find(arg_9_0.cardDbId)
		local var_13_3 = arg_9_0.curDbId or var_13_2:read("held_item")
		local var_13_4

		if var_13_3 then
			for iter_13_2, iter_13_3 in ipairs(var_13_0) do
				if iter_13_3.dbId[1] == var_13_3 then
					var_13_4 = iter_13_2

					break
				end
			end
		end

		local var_13_5 = var_13_4 or 1

		if var_13_1 < var_13_5 then
			var_13_5 = 1
		end

		local var_13_6 = arg_9_0.selIdx:read() ~= -1 and var_13_0[var_13_5] or false

		if var_13_6 then
			var_13_0[var_13_5].isSel = true
		end

		arg_9_0.selIdx:set(var_13_5)
		arg_9_0.heldItems:update(var_13_0)
		arg_9_0.hasItem:set(var_13_1 <= 0)
		arg_9_0.selIdx:notify()
		arg_9_0.isVisibleRight:set(var_13_6 ~= false)

		arg_9_0.curDbId = nil
	end)
	arg_9_0.selIdx:addListener(function(arg_15_0, arg_15_1)
		if arg_9_0.heldItems:size() <= 0 then
			arg_9_0.isVisibleRight:set(false)

			return
		end

		if arg_15_1 ~= -1 and arg_15_0 ~= arg_15_1 and arg_9_0.heldItems:atproxy(arg_15_1) and arg_9_0.heldItems:atproxy(arg_15_1).isSel ~= false then
			arg_9_0.heldItems:atproxy(arg_15_1).isSel = false
		end

		if not arg_9_0.heldItems:atproxy(arg_15_0) then
			arg_9_0.curSelDbId:set(nil)

			return
		end

		if arg_15_0 ~= arg_15_1 and arg_9_0.heldItems:atproxy(arg_15_0).isSel ~= true then
			arg_9_0.heldItems:atproxy(arg_15_0).isSel = true
		end

		arg_9_0.curSelDbId:set(arg_9_0.heldItems:atproxy(arg_15_0).dbId)

		local var_15_0 = csv.held_item.items
		local var_15_1 = csv.held_item.effect
		local var_15_2 = arg_9_0.heldItems:atproxy(arg_15_0)
		local var_15_3 = var_15_0[var_15_2.csvId]
		local var_15_4 = var_15_2.cardDbID
		local var_15_5 = 1
		local var_15_6 = gLanguageCsv.spaceEquip
		local var_15_7, var_15_8 = var_0_0.isExclusive(var_15_2)

		if var_15_4 then
			if var_15_4 == arg_9_0.cardDbId then
				var_15_5 = 2
				var_15_6 = gLanguageCsv.dressDown
			end

			local var_15_9 = gGameModel.cards:find(var_15_4):read("card_id", "skin_id", "advance", "level", "star")
			local var_15_10 = csv.cards[var_15_9.card_id]
			local var_15_11 = csv.unit[var_15_10.unitID]
			local var_15_12 = dataEasy.getUnitId(var_15_9.card_id, var_15_9.skin_id)

			bind.extend(arg_9_0, arg_9_0.roleInfoItem, {
				class = "card_icon",
				props = {
					levelProps = {
						data = var_15_9.level
					},
					rarity = var_15_11.rarity,
					unitId = var_15_12,
					advance = var_15_9.advance,
					star = var_15_9.star,
					onNode = function(arg_16_0)
						return
					end
				}
			})
		end

		arg_9_0.hasRoleDress:set(var_15_7)
		arg_9_0.curBtnState:set(var_15_5)
		arg_9_0.btnText:set(var_15_6)

		local var_15_13 = var_15_2.cfg.name

		if var_15_2.advance > 0 then
			var_15_13 = string.format("%s +%d", var_15_2.cfg.name, var_15_2.advance)
		end

		arg_9_0.itemName:set(var_15_13)
		text.addEffect(arg_9_0.heldItemName, {
			color = var_15_2.cfg.quality == 1 and ui.COLORS.NORMAL.DEFAULT or ui.COLORS.QUALITY[var_15_2.cfg.quality]
		})
		arg_9_0.itemLv:set("Lv." .. var_15_2.lv)
		bind.extend(arg_9_0, arg_9_0.rightItem, {
			class = "icon_key",
			props = {
				noListener = true,
				data = {
					key = var_15_2.csvId,
					num = var_15_2.num,
					dbId = var_15_2.dbId[1]
				}
			}
		})

		local var_15_14 = var_15_1[var_15_3.effect1]

		if var_15_3 and itertools.size(var_15_3.exclusiveCards) > 0 then
			var_15_14 = var_15_1[var_15_3.effect2]
		end

		local var_15_15 = {}

		for iter_15_0, iter_15_1 in csvMapPairs(var_15_14.exclusiveCards) do
			for iter_15_2, iter_15_3 in pairs(gCardsCsv[iter_15_1]) do
				for iter_15_4, iter_15_5 in pairs(iter_15_3) do
					local var_15_16 = csv.unit[iter_15_5.unitID]

					table.insert(var_15_15, {
						card = iter_15_5,
						rarity = var_15_16.rarity
					})
				end
			end
		end

		arg_9_0.tabCards:update(var_15_15)

		local var_15_17

		var_15_17 = #var_15_15 > 0

		arg_9_0.hasShowCards:set(itertools.size(var_15_14.exclusiveCards) > 0)

		local var_15_18 = var_15_2.cfg.attrTypes
		local var_15_19 = var_15_2.cfg.attrNumRates
		local var_15_20 = csv.held_item.advance_attrs[var_15_2.advance]
		local var_15_21 = var_15_20["attrNum" .. var_15_2.cfg.advanceAttrSeq]
		local var_15_22 = var_15_20["attrRate" .. var_15_2.cfg.advanceAttrSeq]
		local var_15_23 = csv.held_item.level_attrs[var_15_2.lv]["attrNum" .. var_15_2.cfg.strengthAttrSeq]
		local var_15_24 = {}

		for iter_15_6, iter_15_7 in ipairs(var_15_18) do
			local var_15_25 = {
				attr = iter_15_7,
				val = math.floor(var_15_19[iter_15_6] * var_15_22[iter_15_6] * (var_15_23[iter_15_6] + var_15_21[iter_15_6]))
			}

			table.insert(var_15_24, var_15_25)
		end

		arg_9_0.attrs:update(var_15_24)

		if gGameModel.held_items:find(var_15_2.dbId[1]) then
			local var_15_26 = {}
			local var_15_27 = "#C0x62440E#"

			for iter_15_8 = 1, 100 do
				local var_15_28 = var_15_2.cfg[string.format("effect%dLevelAdvSeq", iter_15_8)]
				local var_15_29 = gGameModel.held_items:find(var_15_2.dbId[1]):read("advance")

				if not var_15_2.cfg["effect" .. iter_15_8] or var_15_2.cfg["effect" .. iter_15_8] == 0 or not var_15_28 or var_15_29 < var_15_28[1] then
					break
				end

				local var_15_30 = var_0_0.getStrinigByData(iter_15_8, var_15_2, var_15_27)

				table.insert(var_15_26, var_15_30)
			end

			local var_15_31 = var_15_27 .. table.concat(var_15_26, "\n")
			local var_15_32 = beauty.textScroll({
				isRich = true,
				fontSize = 40,
				list = arg_9_0.rightCenterList,
				strs = var_15_31
			})

			arg_9_0:setRightCenterListSize()
		end
	end)
end

function var_0_3.initModel(arg_17_0)
	arg_17_0.myHeldItem = gGameModel.role:getIdler("held_items")
	arg_17_0.cards = gGameModel.role:getIdler("cards")
	arg_17_0.refreshFlag = idler.new(false)
	arg_17_0.selIdx = idler.new(1)
end

function var_0_3.setRightCenterListSize(arg_18_0)
	local var_18_0 = arg_18_0.hasShowCards:read()
	local var_18_1 = arg_18_0.rightCenterList:getInnerContainerSize()
	local var_18_2 = arg_18_0.rightCenterList:size()

	var_18_1.height = var_18_1.height > var_0_2 and var_0_2 or var_18_1.height

	if not var_18_0 then
		arg_18_0.rightCenterList:size(var_18_1)
		arg_18_0.rightCenterList:y(arg_18_0.rightCenterList:y() - (var_18_1.height - var_18_2.height))
	end
end

function var_0_3.refreshData(arg_19_0)
	arg_19_0.tableDatas = {}
	arg_19_0.dataIdx = {}

	local var_19_0 = {}
	local var_19_1 = {}
	local var_19_2 = 0
	local var_19_3 = csv.held_item.items
	local var_19_4 = dataEasy.getInMeteorHelditemsHash()

	for iter_19_0, iter_19_1 in pairs(arg_19_0.myHeldItem:read()) do
		local var_19_5 = gGameModel.held_items:find(iter_19_1)

		if var_19_5 then
			local var_19_6 = var_19_5:read("exist_flag", "card_db_id", "advance", "level", "sum_exp", "held_item_id")

			if var_19_6.exist_flag then
				local var_19_7 = var_19_3[var_19_6.held_item_id]

				if not var_19_4[iter_19_1] and var_19_6.sum_exp == 0 and var_19_6.advance == 0 and not var_19_6.card_db_id then
					if not var_19_0[var_19_6.held_item_id] then
						var_19_0[var_19_6.held_item_id] = {
							num = 0,
							maxNum = var_19_7.stackShow,
							dbIds = {}
						}
					end

					var_19_0[var_19_6.held_item_id].num = var_19_0[var_19_6.held_item_id].num + 1

					table.insert(var_19_0[var_19_6.held_item_id].dbIds, iter_19_1)
				else
					var_19_2 = var_19_2 + 1

					local var_19_8 = {
						cfg = var_19_7,
						csvId = var_19_6.held_item_id,
						dbId = {
							iter_19_1
						}
					}

					var_19_8.num = 1
					var_19_8.isSel = false
					var_19_8.lv = var_19_6.level
					var_19_8.cardDbID = var_19_6.card_db_id
					var_19_8.advance = var_19_6.advance

					local var_19_9, var_19_10 = var_0_0.isExclusive(var_19_8)

					var_19_8.isDress = var_19_9
					var_19_8.isExc = var_19_10
					var_19_8.inMeteor = var_19_4[iter_19_1]

					table.insert(var_19_1, var_19_8)

					arg_19_0.dataIdx[iter_19_1] = var_19_2
				end
			end
		end
	end

	for iter_19_2, iter_19_3 in pairs(var_19_0) do
		local var_19_11 = iter_19_3.num
		local var_19_12 = iter_19_3.maxNum

		for iter_19_4 = 1, math.ceil(var_19_11 / var_19_12) do
			var_19_2 = var_19_2 + 1

			local var_19_13 = {
				cfg = var_19_3[iter_19_2],
				csvId = iter_19_2
			}
			local var_19_14 = math.min(var_19_12, var_19_11)

			var_19_13.num = var_19_14

			local var_19_15 = {}

			for iter_19_5 = 1, var_19_14 do
				table.insert(var_19_15, iter_19_3.dbIds[iter_19_5])
			end

			var_19_13.dbId = var_19_15
			var_19_13.isSel = false
			var_19_13.lv = 1
			var_19_13.advance = 0

			local var_19_16, var_19_17 = var_0_0.isExclusive(var_19_13)

			var_19_13.isDress = false
			var_19_13.isExc = var_19_17

			table.insert(var_19_1, var_19_13)

			var_19_11 = var_19_11 - var_19_12
			arg_19_0.dataIdx[iter_19_2] = var_19_2
		end
	end

	arg_19_0.tableDatas = var_19_1
end

function var_0_3.onDressClick(arg_20_0)
	local var_20_0 = arg_20_0.curBtnState:read()
	local var_20_1 = arg_20_0.selIdx:read()
	local var_20_2 = arg_20_0.heldItems:atproxy(var_20_1)

	if var_20_0 == var_0_1.dress then
		if var_20_2.inMeteor then
			gGameUI:showTip(gLanguageCsv.inMeteorites)

			return
		end

		local var_20_3 = false
		local var_20_4 = var_20_2.cardDbID

		local function var_20_5()
			local var_21_0 = var_20_2.dbId[1]

			gGameApp:requestServer("/game/helditem/equip", function()
				arg_20_0.selIdx:set(-1)
				arg_20_0.refreshFlag:notify()

				if arg_20_0.handlers then
					arg_20_0.handlers(var_21_0)
				end

				audio.playEffectWithWeekBGM("equip.mp3")
				gGameUI:showTip(gLanguageCsv.dressSuccess)
			end, arg_20_0.cardDbId, var_21_0)
		end

		if var_20_4 then
			local var_20_6 = true
			local var_20_7 = gGameModel.cards:find(var_20_4):read("card_id")
			local var_20_8 = csv.cards[var_20_7].name
			local var_20_9, var_20_10 = string.find(gLanguageCsv.heldItemReDress, "%%s")
			local var_20_11, var_20_12 = var_0_0.getCardNameColor(var_20_4)
			local var_20_13 = var_0_0.insertColor(gLanguageCsv.heldItemReDress, var_20_11, false, 1, false)
			local var_20_14 = "#C0x57472E#" .. var_20_13
			local var_20_15 = var_20_8 .. var_20_12
			local var_20_16 = string.format(var_20_14, var_20_15)
			local var_20_17 = {
				isRich = true,
				btnType = 2,
				cb = var_20_5,
				content = var_20_16
			}

			gGameUI:showDialog(var_20_17)
		else
			var_20_5()
		end
	elseif var_20_0 == var_0_1.down then
		gGameApp:requestServer("/game/helditem/unload", function()
			arg_20_0.selIdx:set(-1)
			arg_20_0.refreshFlag:notify()

			if arg_20_0.handlers then
				arg_20_0.handlers()
			end

			gGameUI:showTip(gLanguageCsv.dressDownSuccess)
		end, var_20_2.dbId[1])
	end
end

function var_0_3.callBackData(arg_24_0, arg_24_1)
	arg_24_0.curDbId = arg_24_1

	arg_24_0.refreshFlag:notify()
end

function var_0_3.onStrengthenClick(arg_25_0)
	gGameUI:stackUI("city.card.helditem.advance", {
		refreshData = arg_25_0:createHandler("callBackData")
	}, {
		full = true
	}, arg_25_0.heldItems:atproxy(arg_25_0.selIdx:read()).dbId)
end

function var_0_3.onSortLeftMenusBtnClick(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	arg_26_0.showLeftSelected:set(arg_26_3)
end

function var_0_3.onCloseLeftOtherView(arg_27_0, arg_27_1, arg_27_2)
	arg_27_0.isRightDownListShow:set(false)
end

function var_0_3.onSortRightMenusBtnClick(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	arg_28_0.showRightSelected:set(arg_28_3)
end

function var_0_3.onCloseRightOtherView(arg_29_0, arg_29_1, arg_29_2)
	arg_29_0.isLeftDownListShow:set(false)
end

function var_0_3.onInfoClick(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_0.heldItems:atproxy(arg_30_0.selIdx:read())
	local var_30_1, var_30_2 = arg_30_1:getPosition()
	local var_30_3 = arg_30_1:getParent():convertToWorldSpace(cc.p(var_30_1, var_30_2))
	local var_30_4 = {
		offy = 120,
		offx = 256,
		data = var_30_0,
		target = arg_30_1,
		x = var_30_3.x,
		y = var_30_3.y
	}

	gGameUI:stackUI("city.card.helditem.advance_detail", nil, nil, var_30_4)
end

function var_0_3.onItemClick(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	arg_31_0.selIdx:set(arg_31_2.k, true)

	if arg_31_0.heldItems:atproxy(arg_31_2.k) and arg_31_0.heldItems:atproxy(arg_31_2.k).isSel ~= true then
		arg_31_0.heldItems:atproxy(arg_31_2.k).isSel = true
	end

	arg_31_0.isVisibleRight:set(true)
end

function var_0_3.bagHandbook(arg_32_0)
	gGameUI:stackUI("city.card.helditem.bag_handbook", nil, nil, arg_32_0.cardDbId)
end

function var_0_3.onClose(arg_33_0)
	local var_33_0 = gGameModel.cards:find(arg_33_0.cardDbId):read("held_item")

	if arg_33_0.handlers then
		arg_33_0.handlers(var_33_0)
	end

	Dialog.onClose(arg_33_0)
end

return var_0_3
