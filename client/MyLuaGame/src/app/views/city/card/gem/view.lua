local var_0_0 = table.insert
local var_0_1 = table.sort
local var_0_2 = {
	NORMAL = "city/card/gem/btn_yq_b.png",
	SELECTED = "city/card/gem/btn_yq_h.png"
}
local var_0_3 = {
	nil,
	"effect_lv",
	"effect_lan",
	"effect_zi",
	"effect_huang",
	"effect_hong"
}
local var_0_4 = {
	nil,
	"effect_lv_loop",
	"effect_lan_loop",
	"effect_zi_loop",
	"effect_huang_loop",
	"effect_hong_loop"
}
local var_0_5 = cc.load("mvc").ViewBase
local var_0_6 = require("app.views.city.card.gem.tools")
local var_0_7 = class("GemView", var_0_5)

var_0_7.RESOURCE_FILENAME = "gem.json"
var_0_7.RESOURCE_BINDING = {
	["left.bg2"] = "centerBg",
	["right.acquire.num"] = "acquireNum",
	["right.btnFilterPanel"] = "btnFilterPanel",
	["right.btnFilterPanel.btnFilter.arrow"] = "filterArrow",
	["right.pageBtn"] = "pageBtn",
	["right.noGemTip"] = "noGemTip",
	["right.acquire.bg"] = "acquireBg",
	["right.subList"] = "subList",
	["right.item"] = "item",
	left = "left",
	right = "right",
	["right.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = bindHelper.self("asyncPreload"),
				data = bindHelper.self("showData"),
				columnSize = bindHelper.self("midColumnSize"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					bind.extend(arg_1_0, arg_1_1, {
						class = "icon_key",
						props = {
							noListener = true,
							data = {
								key = arg_1_3.id,
								num = arg_1_3.num,
								dbId = arg_1_3.dbid
							},
							specialKey = {
								leftTopLv = arg_1_3.level
							},
							onNode = function(arg_2_0)
								if arg_1_3.selectEffect then
									arg_1_3.selectEffect:removeSelf()
									arg_1_3.selectEffect:alignCenter(arg_2_0:size())
									arg_2_0:add(arg_1_3.selectEffect, -1)
								end

								arg_2_0:scale(1.15)
								arg_2_0:onTouch(functools.partial(arg_1_0.itemClick, arg_1_0, arg_2_0, arg_1_2, arg_1_3))
							end
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	["right.pageBtn.title"] = {
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
	["right.pageList"] = {
		varname = "pageList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = bindHelper.self("pageBtnSpace"),
				data = bindHelper.self("pageBtns"),
				item = bindHelper.self("pageBtn"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_3.select and var_0_2.SELECTED or var_0_2.NORMAL

					arg_3_1:get("bg"):texture(var_3_0)

					local var_3_1 = arg_3_3.select and ui.COLORS.WHITE or ui.COLORS.WHITE

					arg_3_1:get("title"):setTextColor(var_3_1)
					arg_3_1:get("title"):setString(gLanguageCsv["symbolRome" .. arg_3_2])
					arg_3_1:get("bg"):setTouchEnabled(true)
					bind.touch(arg_3_0, arg_3_1:get("bg"), {
						methods = {
							ended = functools.partial(arg_3_0.clickCell, arg_3_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("pageBtnClick")
			}
		}
	},
	["left.card"] = {
		varname = "card",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowSelectSpriteView")
			}
		}
	},
	["left.btnExchange"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowSelectSpriteView")
			}
		}
	},
	["left.btnExchange.txt"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	},
	["left.btnDraw"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onClickDraw")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					state = bindHelper.self("gemFreeNumer"),
					onNode = function(arg_4_0)
						arg_4_0:xy(150, 150)
					end
				}
			}
		}
	},
	["left.btnShowAll"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("btnShowAllFunc")
			}
		}
	},
	["left.btnPoint"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClickIndex")
			}
		}
	},
	["left.btnPoint.pointNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("qualityNum")
		}
	},
	["left.btnDecompose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("btnDecompose")
			}
		}
	},
	["left.btnOneKeyUnEquip"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("unEquipAll")
			}
		}
	},
	["left.btnOneKeyUnEquip.txt"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	},
	["left.btnOneKeyEquip"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("oneKeyEquip")
			}
		}
	},
	["left.btnOneKeyEquip.txt"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	},
	["right.btnFilterPanel.btnFilter"] = {
		varname = "btnFilter",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onFilter")
			}
		}
	},
	["right.btnFilterPanel.btnFilter.txt"] = {
		varname = "filterTxt",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	},
	["right.acquire.btnAdd"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("btnDecompose")
			}
		}
	}
}
var_0_7.RESOURCE_STYLES = {
	full = true
}

function var_0_7.onCreate(arg_5_0, arg_5_1)
	gGameUI.topuiManager:createView("default", arg_5_0, {
		onClose = arg_5_0:createHandler("onClose")
	}):init({
		subTitle = "GEM",
		title = "common/txt/txt_bt_yinji.png"
	})

	arg_5_0.selectEffect = ccui.ImageView:create("common/box/box_selected.png"):alignCenter(arg_5_0.item:size()):retain()
	arg_5_0.baglevelIdlers = {}

	arg_5_0:initModel()

	local var_5_0, var_5_1 = adapt.centerWithScreen("left", "right", {
		itemWidthExtra = 80,
		itemWidth = arg_5_0.item:size().width
	}, {
		{
			{
				arg_5_0.bagSubList,
				arg_5_0.bagList
			},
			"width"
		},
		{
			{
				arg_5_0.subList,
				arg_5_0.list,
				arg_5_0.pageList
			},
			"width"
		},
		{
			{
				arg_5_0.subList,
				arg_5_0.list,
				arg_5_0.pageList
			},
			"pos",
			"left"
		}
	})

	arg_5_0.deltaWidth = var_5_0 or 0
	arg_5_0.midColumnSize = 4 + (var_5_1 or 0)
	arg_5_0.asyncPreload = arg_5_0.midColumnSize * 5
	arg_5_0.pageBtnSpace = math.floor((arg_5_0.pageList:width() - 6 * arg_5_0.pageBtn:width()) / 5)

	arg_5_0.btnFilterPanel:x(arg_5_0.list:x() + arg_5_0.list:width() - arg_5_0.btnFilterPanel:width() / 2)
	arg_5_0.right:get("acquire"):x(arg_5_0.list:x())

	local var_5_2 = cc.p(30 + display.sizeInViewRect.x, 0)

	arg_5_0.left:runAction(cc.MoveTo:create(0.4, var_5_2))
	arg_5_0.right:runAction(cc.MoveTo:create(0.4, cc.p(display.uiOrigin.x + 1500, 0)))

	arg_5_0.pageBtns = idlers.newWithMap({
		{},
		{},
		{},
		{},
		{},
		{}
	})
	arg_5_0.selectedPage = idler.new()

	arg_5_0.selectedPage:addListener(function(arg_6_0, arg_6_1)
		if arg_6_1 then
			arg_5_0.pageBtns:atproxy(arg_6_1).select = false
		end

		if arg_6_0 then
			arg_5_0.pageBtns:atproxy(arg_6_0).select = true
		end
	end)

	arg_5_0.gemFreeNumer = idler.new(true)

	idlereasy.any({
		arg_5_0.goldFreeCount,
		arg_5_0.rmbFreeCount
	}, function(arg_7_0, arg_7_1, arg_7_2)
		if arg_7_1 ~= 0 and arg_7_2 ~= 0 then
			arg_5_0.gemFreeNumer:set(false)
		end
	end)

	arg_5_0.selectItem = idlertable.new({})

	arg_5_0.selectItem:addListener(function(arg_8_0, arg_8_1)
		if next(arg_8_0) then
			arg_5_0.showData:atproxy(arg_8_0.k).selectEffect = arg_5_0.selectEffect
		end
	end)

	local var_5_3 = idler.new(0)

	idlereasy.when(arg_5_0.items, function(arg_9_0, arg_9_1)
		var_5_3:set(arg_9_1[529] or 0)
	end)
	idlereasy.when(var_5_3, function(arg_10_0, arg_10_1)
		local var_10_0 = arg_5_0.right:get("acquire"):multiget("icon", "btnAdd", "bg", "num")

		var_10_0.num:text(arg_10_1)

		local var_10_1 = var_10_0.num:width() / 0.8 + 130

		if var_10_1 > 296 then
			var_10_0.bg:width(var_10_1)
			adapt.oneLinePos(var_10_0.icon, {
				var_10_0.num,
				var_10_0.btnAdd
			})
		end
	end)

	arg_5_0.filterType = 0
	arg_5_0.qualityNum = idler.new(0)
	arg_5_0.showData = idlers.new({})

	idlereasy.when(arg_5_0.gems, function(arg_11_0, arg_11_1)
		arg_5_0:updateShowData()
	end)
	arg_5_0:createGemSlots()
	idlereasy.when(gGameModel.role:getIdler("cards"), function(arg_12_0, arg_12_1)
		local var_12_0 = {}
		local var_12_1 = 0
		local var_12_2
		local var_12_3 = 0

		for iter_12_0, iter_12_1 in ipairs(arg_12_1) do
			local var_12_4 = gGameModel.cards:find(iter_12_1):read("card_id", "fighting_point", "level", "star", "advance")
			local var_12_5 = csv.cards[var_12_4.card_id]
			local var_12_6 = csv.unit[var_12_5.unitID]

			var_12_0[iter_12_1] = true

			if var_12_1 < var_12_6.rarity then
				var_12_2 = iter_12_1
				var_12_1 = var_12_6.rarity
				var_12_3 = var_12_4.fighting_point
			elseif var_12_6.rarity == var_12_1 and var_12_3 < var_12_4.fighting_point then
				var_12_2 = iter_12_1
				var_12_3 = var_12_4.fighting_point
			end
		end

		if arg_5_1 and var_12_0[arg_5_1] then
			arg_5_0:setCardID(arg_5_1)
		else
			arg_5_0:setCardID(var_12_2)
		end
	end)
end

function var_0_7.onTouchSlot(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0.gemSlots[arg_13_1]
	local var_13_1 = arg_13_0.curCard:read("gems")[arg_13_1]

	if not var_0_6.isSlotLocked(arg_13_0.carddbid, arg_13_1) then
		arg_13_0.curSlot:set(arg_13_1)
	else
		local var_13_2 = csv.cards[gGameModel.cards:find(arg_13_0.carddbid):read("card_id")]
		local var_13_3 = gGemPosCsv[var_13_2.gemPosSeqID][arg_13_1].openCondition

		if var_13_3[1] == 1 then
			gGameUI:showTip(gLanguageCsv.nLvUnlock, var_13_3[2])
		elseif var_13_3[1] == 2 then
			local var_13_4, var_13_5 = dataEasy.getQuality(var_13_3[2])

			gGameUI:showTip(gLanguageCsv.openAdvance, gLanguageCsv[ui.QUALITY_COLOR_TEXT[var_13_4]] .. var_13_5)
		end
	end

	if not var_13_1 then
		return
	end

	local var_13_6 = gGameModel.gems:find(var_13_1)

	if arg_13_2.name == "began" then
		arg_13_0.touchBeganPos = var_13_0:getTouchBeganPosition()
	elseif arg_13_2.name == "moved" then
		local var_13_7 = arg_13_2
		local var_13_8 = math.abs(var_13_7.x - arg_13_0.touchBeganPos.x)
		local var_13_9 = math.abs(var_13_7.y - arg_13_0.touchBeganPos.y)

		if not arg_13_0.hasMovingItem and (var_13_8 >= ui.TOUCH_MOVED_THRESHOLD or var_13_9 >= ui.TOUCH_MOVED_THRESHOLD) then
			var_13_0:get("gemPanel"):visible(false)

			arg_13_0.hasMovingItem = true

			arg_13_0:createMovePanel({
				id = var_13_6:read("gem_id"),
				level = var_13_6:read("level")
			})
		end

		if arg_13_0.hasMovingItem then
			local var_13_10 = arg_13_0:convertToNodeSpace(var_13_7)

			arg_13_0.movePanel:xy(var_13_10.x, var_13_10.y)
		end
	elseif arg_13_2.name == "ended" or arg_13_2.name == "cancelled" then
		if not arg_13_0.hasMovingItem then
			arg_13_0:showDetails()
		else
			arg_13_0.hasMovingItem = false

			local var_13_11 = arg_13_0.movePanel:box()
			local var_13_12 = arg_13_0:convertToWorldSpace(cc.p(var_13_11.x, var_13_11.y))
			local var_13_13 = arg_13_0.left:convertToNodeSpace(var_13_12)

			var_13_11.x, var_13_11.y = var_13_13.x, var_13_13.y

			local var_13_14 = var_13_0:box()
			local var_13_15 = arg_13_0:checkRectInSlots(var_13_11)

			if var_13_15 == arg_13_1 then
				var_13_0:get("gemPanel"):visible(true)
			elseif not var_13_15 then
				var_0_6.unEquipGem(arg_13_0.carddbid, arg_13_1)
			else
				var_0_6.moveGem(arg_13_0.carddbid, var_13_15, var_13_1, function()
					var_13_0:get("gemPanel"):visible(true)
				end)
			end

			arg_13_0.movePanel:removeSelf()

			arg_13_0.movePanel = nil
		end
	end
end

function var_0_7.checkRectInSlots(arg_15_0, arg_15_1)
	local var_15_0 = math.huge
	local var_15_1

	for iter_15_0, iter_15_1 in pairs(arg_15_0.gemSlots) do
		local var_15_2 = iter_15_1:box()

		if cc.rectIntersectsRect(var_15_2, arg_15_1) then
			local var_15_3 = cc.p(var_15_2.x + var_15_2.width / 2, var_15_2.y + var_15_2.height / 2)
			local var_15_4 = cc.p(arg_15_1.x + arg_15_1.width / 2, arg_15_1.y + arg_15_1.height / 2)
			local var_15_5 = cc.pGetDistance(var_15_3, var_15_4)

			if var_15_5 < var_15_0 then
				var_15_0 = var_15_5
				var_15_1 = iter_15_0
			end
		end
	end

	return var_15_1
end

function var_0_7.createGemSlots(arg_16_0)
	arg_16_0.suitEffectQualitys = {}
	arg_16_0.gemSlots = {}
	arg_16_0.curSlot = idler.new(1)

	local var_16_0 = cc.p(772, 704)
	local var_16_1 = cc.p(772, 1100)

	widget.addAnimationByKey(arg_16_0.left, "fushichouqu/baoshixiangqian.skel", "bg", "effect_shiban_loop", 5):xy(var_16_0)

	local var_16_2 = var_16_1.x - var_16_0.x
	local var_16_3 = var_16_1.y - var_16_0.y

	for iter_16_0 = 1, 9 do
		arg_16_0.suitEffectQualitys[iter_16_0] = 0

		local var_16_4 = (iter_16_0 - 0.5) / 9 * 360 + 180
		local var_16_5 = -math.rad(var_16_4)
		local var_16_6 = var_16_0.x + var_16_2 * math.cos(var_16_5) + var_16_3 * math.sin(var_16_5)
		local var_16_7 = var_16_0.y + var_16_2 * math.sin(var_16_5) - var_16_3 * math.cos(var_16_5)

		arg_16_0.gemSlots[iter_16_0] = arg_16_0.left:get("gemSlot"):clone():addTo(arg_16_0.left, 30):xy(var_16_6, var_16_7)

		widget.addAnimationByKey(arg_16_0.gemSlots[iter_16_0], "fushichouqu/baoshixiangqian.skel", "empty", "effect_kong_loop", 1):alignCenter(arg_16_0.gemSlots[iter_16_0]:size()):setRotation(var_16_4 + 180)
		arg_16_0.gemSlots[iter_16_0]:get("bg"):visible(false)
		arg_16_0.gemSlots[iter_16_0]:onTouch(function(arg_17_0)
			arg_16_0:onTouchSlot(iter_16_0, arg_17_0)
		end)
	end

	arg_16_0.slotEffect = ccui.ImageView:create("common/box/box_portrait_select.png"):alignCenter(arg_16_0.item:size()):retain()

	idlereasy.when(arg_16_0.curSlot, function(arg_18_0, arg_18_1)
		local var_18_0 = arg_16_0.gemSlots[arg_18_1]

		arg_16_0.slotEffect:removeSelf()
		arg_16_0.slotEffect:alignCenter(var_18_0:size())
		var_18_0:add(arg_16_0.slotEffect, 5)
	end)
end

function var_0_7.updateShowData(arg_19_0)
	arg_19_0.selectItem:set({})
	dataEasy.tryCallFunc(arg_19_0.list, "updatePreloadCenterIndexAdaptFirst")

	local var_19_0 = {}
	local var_19_1 = {}
	local var_19_2 = gGameModel.role:read("gems")

	for iter_19_0, iter_19_1 in pairs(var_19_2) do
		local var_19_3 = gGameModel.gems:find(iter_19_1)
		local var_19_4 = var_19_3:read("gem_id")
		local var_19_5 = var_19_3:read("level")
		local var_19_6 = dataEasy.getCfgByKey(var_19_4)
		local var_19_7 = {
			num = 1,
			id = var_19_4,
			suitNo = var_19_6.suitNo,
			suitID = var_19_6.suitID,
			level = var_19_5,
			quality = var_19_6.quality,
			dbid = iter_19_1
		}
		local var_19_8 = var_19_3:read("card_db_id")
		local var_19_9 = arg_19_0.selectedPage:read()

		if not var_19_8 and (not var_19_9 or var_19_9 == var_19_7.suitNo or not var_19_7.suitNo) and (arg_19_0.filterType == 0 or arg_19_0.filterType == var_19_7.suitID or not var_19_7.suitID) then
			if var_19_5 == 1 then
				if not var_19_1[var_19_4] then
					var_19_7.dbids = {
						iter_19_1
					}
					var_19_1[var_19_4] = var_19_7

					var_0_0(var_19_0, var_19_7)
				else
					var_0_0(var_19_1[var_19_4].dbids, iter_19_1)

					var_19_1[var_19_4].num = var_19_1[var_19_4].num + 1
				end
			else
				var_0_0(var_19_0, var_19_7)
			end
		end
	end

	var_0_1(var_19_0, function(arg_20_0, arg_20_1)
		if arg_20_0.quality ~= arg_20_1.quality then
			return arg_20_0.quality > arg_20_1.quality
		end

		if arg_20_0.suitID ~= arg_20_1.suitID then
			if arg_20_0.suitID and arg_20_1.suitID then
				return arg_20_0.suitID < arg_20_1.suitID
			else
				return not arg_20_1.suitID
			end
		end

		if arg_20_0.suitNo ~= arg_20_1.suitNo then
			if arg_20_0.suitNo and arg_20_1.suitNo then
				return arg_20_0.suitNo < arg_20_1.suitNo
			else
				return not arg_20_1.suitNo
			end
		end

		return arg_20_0.level > arg_20_1.level
	end)

	local function var_19_10(arg_21_0, arg_21_1, arg_21_2)
		arg_19_0.baglevelIdlers[arg_21_1] = idlereasy.when(gGameModel.gems:find(arg_21_1):getIdler("level"), function(arg_22_0, arg_22_1)
			if arg_21_2 then
				arg_19_0:updateShowData()
			else
				local var_22_0 = arg_19_0.showData:atproxy(arg_21_0)

				if var_22_0 then
					var_22_0.level = arg_22_1
				end
			end
		end, true):anonyOnly(arg_19_0, stringz.bintohex(arg_21_1))
	end

	for iter_19_2, iter_19_3 in ipairs(var_19_0) do
		if iter_19_3.dbids then
			for iter_19_4, iter_19_5 in ipairs(iter_19_3.dbids) do
				var_19_10(iter_19_2, iter_19_5, true)
			end
		else
			var_19_10(iter_19_2, iter_19_3.dbid)
		end
	end

	arg_19_0.showData:update(var_19_0)
	arg_19_0.noGemTip:visible(#var_19_0 == 0)
end

function var_0_7.pageBtnClick(arg_23_0, arg_23_1, arg_23_2)
	if arg_23_0.selectedPage:read() == arg_23_2 then
		arg_23_2 = nil
	end

	arg_23_0.selectedPage:set(arg_23_2)
	arg_23_0:updateShowData()
end

function var_0_7.getPercent(arg_24_0)
	local var_24_0 = arg_24_0.list:getInnerContainer()
	local var_24_1 = var_24_0:size()
	local var_24_2 = arg_24_0.list:size()
	local var_24_3, var_24_4 = var_24_0:xy()

	return 100 - math.abs(var_24_4) / (var_24_1.height - var_24_2.height) * 100
end

function var_0_7.onItemClick(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6)
	if arg_25_6.name == "began" then
		arg_25_0.touchBeganPos = arg_25_3:getTouchBeganPosition()

		arg_25_0.list:setTouchEnabled(false)

		arg_25_0.isClicked = true
		arg_25_0.hasMovingItem = nil
	elseif arg_25_6.name == "moved" then
		local var_25_0 = arg_25_6
		local var_25_1 = math.abs(var_25_0.x - arg_25_0.touchBeganPos.x)
		local var_25_2 = math.abs(var_25_0.y - arg_25_0.touchBeganPos.y)

		if arg_25_0.hasMovingItem == nil and (var_25_1 >= ui.TOUCH_MOVED_THRESHOLD or var_25_2 >= ui.TOUCH_MOVED_THRESHOLD) then
			arg_25_0.hasMovingItem = false

			if var_25_1 > var_25_2 * 0.7 then
				arg_25_0.hasMovingItem = true

				arg_25_0:createMovePanel(arg_25_5)
			end

			arg_25_0.list:setTouchEnabled(not arg_25_0.hasMovingItem)

			arg_25_0.isClicked = false
		end

		if arg_25_0.hasMovingItem then
			local var_25_3 = arg_25_0:convertToNodeSpace(var_25_0)

			arg_25_0.movePanel:xy(var_25_3.x, var_25_3.y)
		end
	elseif arg_25_6.name == "ended" or arg_25_6.name == "cancelled" then
		if not arg_25_0.hasMovingItem then
			if arg_25_0.isClicked then
				local var_25_4 = arg_25_1:getIdx(arg_25_4)

				var_25_4.data = arg_25_5

				arg_25_0.selectItem:set(var_25_4)
				arg_25_0:showDetails(arg_25_5.dbid)
			end
		else
			arg_25_0.hasMovingItem = false

			local var_25_5 = arg_25_0.movePanel:box()
			local var_25_6 = arg_25_0:convertToWorldSpace(cc.p(var_25_5.x, var_25_5.y))
			local var_25_7 = arg_25_0.left:convertToNodeSpace(var_25_6)

			var_25_5.x, var_25_5.y = var_25_7.x, var_25_7.y

			local var_25_8 = arg_25_0:checkRectInSlots(var_25_5)

			if var_25_8 then
				if arg_25_0.curCard:read("gems")[var_25_8] then
					arg_25_0:swapGem(var_25_8, arg_25_0.movePanel.dbid)
				else
					arg_25_0:equipGem(var_25_8, arg_25_0.movePanel.dbid)
				end

				arg_25_0.curSlot:set(var_25_8)
			end

			arg_25_0.movePanel:removeSelf()

			arg_25_0.movePanel = nil
		end
	end
end

function var_0_7.swapGem(arg_26_0, arg_26_1, arg_26_2)
	var_0_6.swapGem(arg_26_0.carddbid, arg_26_1, arg_26_2)
end

function var_0_7.equipGem(arg_27_0, arg_27_1, arg_27_2)
	var_0_6.equipGem(arg_27_0.carddbid, arg_27_1, arg_27_2, function()
		local var_28_0 = arg_27_0.gemSlots[arg_27_1]

		if var_28_0:get("effectEquip") then
			var_28_0:get("effectEquip"):removeSelf()
		end

		local var_28_1 = (arg_27_1 - 0.5) / 9 * 360
		local var_28_2 = widget.addAnimationByKey(var_28_0, "fushichouqu/baoshixiangqian.skel", "effectEquip", "effect_jihuo", 5):alignCenter(var_28_0:size()):setRotation(var_28_1)

		performWithDelay(var_28_2, function()
			var_28_2:removeSelf()
		end, 0.5)
	end)
end

function var_0_7.createMovePanel(arg_30_0, arg_30_1)
	if arg_30_0.movePanel then
		arg_30_0.movePanel:removeSelf()

		arg_30_0.movePanel = nil
	end

	arg_30_0.movePanel = arg_30_0.item:clone():addTo(arg_30_0, 100)
	arg_30_0.movePanel.dbid = arg_30_1.dbid
	arg_30_0.moveData = arg_30_1

	bind.extend(arg_30_0, arg_30_0.movePanel, {
		class = "icon_key",
		props = {
			simpleShow = true,
			data = {
				key = arg_30_1.id
			},
			specialKey = {
				leftTopLv = arg_30_1.level
			},
			onNode = function(arg_31_0)
				arg_31_0:scale(1.15)
			end
		}
	})
end

function var_0_7.onShowSelectSpriteView(arg_32_0)
	gGameUI:stackUI("city.card.gem.select_sprite", nil, nil, arg_32_0.carddbid, arg_32_0:createHandler("setCardID"))
end

function var_0_7.setCardID(arg_33_0, arg_33_1)
	if not arg_33_1 then
		return
	end

	local var_33_0 = gGameModel.cards:find(arg_33_1)
	local var_33_1 = var_33_0:read("card_id", "skin_id", "fighting_point", "level", "star", "advance")
	local var_33_2 = csv.cards[var_33_1.card_id]
	local var_33_3 = csv.unit[var_33_2.unitID]
	local var_33_4 = dataEasy.getUnitId(var_33_1.card_id, var_33_1.skin_id)

	bind.extend(arg_33_0, arg_33_0.card, {
		class = "card_icon",
		props = {
			unitId = var_33_4,
			advance = var_33_1.advance,
			rarity = var_33_3.rarity,
			star = var_33_1.star,
			levelProps = {
				data = var_33_1.level
			},
			onNode = function(arg_34_0)
				return
			end
		}
	})

	arg_33_0.carddbid = arg_33_1
	arg_33_0.curCard = var_33_0

	idlereasy.when(var_33_0:getIdler("gems"), function(arg_35_0, arg_35_1)
		arg_33_0:updateShowData()
		arg_33_0:resetGemSlots(arg_35_1)
	end):anonyOnly(arg_33_0, "cardgems")
end

function var_0_7.checkSuits(arg_36_0, arg_36_1)
	local var_36_0 = {}

	for iter_36_0 = 1, 9 do
		local var_36_1 = arg_36_1[iter_36_0]

		if var_36_1 then
			local var_36_2 = gGameModel.gems:find(var_36_1)
			local var_36_3 = csv.gem.gem[var_36_2:read("gem_id")]

			if var_36_3.suitID then
				if not var_36_0[var_36_3.suitID] then
					var_36_0[var_36_3.suitID] = {}
				end

				var_0_0(var_36_0[var_36_3.suitID], {
					slot = iter_36_0,
					quality = var_36_3.quality
				})
			end
		end
	end

	local var_36_4 = {}

	for iter_36_1, iter_36_2 in pairs(var_36_0) do
		var_0_1(iter_36_2, function(arg_37_0, arg_37_1)
			if arg_37_0.quality ~= arg_37_1.quality then
				return arg_37_0.quality > arg_37_1.quality
			end

			return arg_37_0.slot < arg_37_1.slot
		end)

		local var_36_5, var_36_6 = next(gGemSuitCsv[iter_36_1])

		for iter_36_3 = 9, 1, -1 do
			if var_36_6[iter_36_3] and iter_36_3 <= #iter_36_2 then
				for iter_36_4 = 1, iter_36_3 do
					var_36_4[iter_36_2[iter_36_4].slot] = iter_36_2[iter_36_3].quality
				end
			end
		end
	end

	return var_36_4
end

function var_0_7.resetGemSlots(arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0:checkSuits(arg_38_1)

	for iter_38_0, iter_38_1 in pairs(arg_38_0.gemSlots) do
		if (not var_38_0[iter_38_0] or arg_38_0.suitEffectQualitys[iter_38_0] ~= var_38_0[iter_38_0]) and iter_38_1:get("effect") then
			iter_38_1:get("effect"):removeSelf()
		end

		if arg_38_0.suitEffectQualitys[iter_38_0] ~= var_38_0[iter_38_0] and var_38_0[iter_38_0] then
			local var_38_1 = (iter_38_0 - 0.5) / 9 * 360
			local var_38_2 = widget.addAnimationByKey(iter_38_1, "fushichouqu/baoshixiangqian.skel", "effect", var_0_3[var_38_0[iter_38_0]], 1):alignCenter(iter_38_1:size())

			performWithDelay(var_38_2, function()
				var_38_2:removeSelf()
				widget.addAnimationByKey(iter_38_1, "fushichouqu/baoshixiangqian.skel", "effect", var_0_4[var_38_0[iter_38_0]], 1):alignCenter(iter_38_1:size()):setRotation(var_38_1)
			end, 0.5)
			var_38_2:setRotation(var_38_1)
		end

		arg_38_0.suitEffectQualitys[iter_38_0] = var_38_0[iter_38_0]

		local var_38_3 = iter_38_1:get("gemPanel")
		local var_38_4 = var_38_3:get("icon")
		local var_38_5 = var_38_3:get("levelBg")
		local var_38_6 = iter_38_1:get("unlockLv")
		local var_38_7 = iter_38_1:get("unlockLvBg")
		local var_38_8 = arg_38_0.curCard:read("advance")
		local var_38_9, var_38_10 = var_0_6.isSlotLocked(arg_38_0.carddbid, iter_38_0)
		local var_38_11 = arg_38_1[iter_38_0] and true or false

		var_38_3:visible(var_38_11)
		var_38_5:visible(false)

		local var_38_12 = var_38_3:get("lv")

		text.addEffect(var_38_12, {
			outline = {
				color = ui.COLORS.NORMAL.DEFAULT
			}
		})

		if var_38_11 then
			local var_38_13 = gGameModel.gems:find(arg_38_1[iter_38_0])
			local var_38_14 = var_38_13:read("gem_id")
			local var_38_15 = dataEasy.getCfgByKey(var_38_14)

			var_38_4:texture(var_38_15.icon)
			var_38_4:visible(true)

			if arg_38_0.baglevelIdlers[arg_38_1[iter_38_0]] then
				arg_38_0.baglevelIdlers[arg_38_1[iter_38_0]]:destroy()

				arg_38_0.baglevelIdlers[arg_38_1[iter_38_0]] = nil
			end

			idlereasy.when(var_38_13:getIdler("level"), function(arg_40_0, arg_40_1)
				var_38_12:setString("Lv" .. arg_40_1)
				arg_38_0:updateIndexPoints()
			end):anonyOnly(arg_38_0, "gemSlot" .. iter_38_0)
		else
			var_38_4:texture("city/card/gem/btn_jh2.png")
		end

		var_38_6:visible(var_38_9)

		if var_38_9 then
			var_38_6:text(var_38_10)
		end

		var_38_7:visible(var_38_9)
		iter_38_1:get("lock"):visible(var_38_9)
		iter_38_1:get("imgAdd"):visible(not var_38_11 and not var_38_9)
	end

	arg_38_0:updateIndexPoints()
end

function var_0_7.updateIndexPoints(arg_41_0)
	local var_41_0 = gGameModel.cards:find(arg_41_0.carddbid)
	local var_41_1 = dataEasy.getGemQualityIndex(var_41_0)

	arg_41_0.qualityNum:set(var_41_1)
end

function var_0_7.unEquipAll(arg_42_0)
	local var_42_0 = arg_42_0.curCard:read("gems")
	local var_42_1 = {}

	for iter_42_0, iter_42_1 in pairs(var_42_0) do
		if iter_42_1 then
			var_0_0(var_42_1, iter_42_1)
		end
	end

	if #var_42_1 == 0 then
		gGameUI:showTip(gLanguageCsv.noEquippedGem)

		return
	end

	gGameApp:requestServer("/game/gem/unload", function()
		gGameUI:showTip(gLanguageCsv.dischargeSuccess)
	end, var_42_1)
end

function var_0_7.onFilter(arg_44_0)
	arg_44_0.filterArrow:setRotation(180)

	local var_44_0 = arg_44_0.btnFilterPanel:size()
	local var_44_1 = arg_44_0.btnFilterPanel:convertToWorldSpace(cc.p(var_44_0.width, -100))

	gGameUI:stackUI("city.card.gem.filter", nil, nil, var_44_1, {
		"right",
		"top"
	}, arg_44_0:createHandler("setFilterType"), arg_44_0.filterType)
end

function var_0_7.setFilterType(arg_45_0, arg_45_1)
	arg_45_0.filterArrow:setRotation(0)

	if arg_45_1 then
		arg_45_0.filterType = arg_45_1

		arg_45_0.filterTxt:text(gLanguageCsv["gemSuit" .. arg_45_1] or gLanguageCsv.typeFilter)
		arg_45_0:updateShowData()
	end
end

function var_0_7.onClickIndex(arg_46_0)
	gGameUI:stackUI("city.card.gem.quality_index", nil, nil, arg_46_0.carddbid, arg_46_0.qualityNum:read())
end

function var_0_7.btnShowAllFunc(arg_47_0)
	gGameUI:stackUI("city.card.gem.add_effect", nil, {
		clickClose = true,
		blackLayer = true
	}, arg_47_0.carddbid, arg_47_0.qualityNum:read())
end

function var_0_7.btnDecompose(arg_48_0)
	gGameUI:stackUI("city.card.gem.decompose", nil, nil)
end

function var_0_7.onClickDraw(arg_49_0)
	gGameUI:stackUI("city.card.gem.draw", nil, {
		full = true
	})
end

function var_0_7.showDetails(arg_50_0, arg_50_1)
	local var_50_0 = arg_50_0.curSlot:read()
	local var_50_1 = arg_50_0.centerBg:convertToWorldSpaceAR(cc.p(0, 0))
	local var_50_2 = "right"

	if not arg_50_1 and var_50_0 < 5 then
		var_50_2 = "left"
	end

	arg_50_0.details = gGameUI:stackUI("city.card.gem.details", nil, {
		clickClose = true,
		dispatchNodes = {
			arg_50_0.list,
			arg_50_0.left
		}
	}, {
		cardID = arg_50_0.carddbid,
		slotIdx = var_50_0,
		dbid = arg_50_1,
		pos = var_50_1,
		align = var_50_2
	})
end

function var_0_7.closeDetails(arg_51_0)
	arg_51_0.details:onClose()
end

function var_0_7.oneKeyEquip(arg_52_0)
	local var_52_0 = gGameModel.role:read("gems")
	local var_52_1 = {}

	for iter_52_0, iter_52_1 in pairs(var_52_0) do
		local var_52_2 = gGameModel.gems:find(iter_52_1)
		local var_52_3 = dataEasy.getCfgByKey(var_52_2:read("gem_id"))

		if var_52_2:read("card_db_id") == nil or var_52_2:read("card_db_id") == arg_52_0.carddbid then
			var_0_0(var_52_1, {
				dbid = iter_52_1,
				quality = var_52_3.quality,
				level = var_52_2:read("level"),
				suitID = var_52_3.suitID,
				suitNo = var_52_3.suitNo,
				gem_id = var_52_2:read("gem_id")
			})
		end
	end

	table.sort(var_52_1, function(arg_53_0, arg_53_1)
		if arg_53_0.quality ~= arg_53_1.quality then
			return arg_53_0.quality > arg_53_1.quality
		end

		return arg_53_0.level > arg_53_1.level
	end)

	if #var_52_1 == 0 then
		gGameUI:showTip(gLanguageCsv.noGemTip)

		return
	end

	local var_52_4 = {}
	local var_52_5 = {}
	local var_52_6 = {}

	for iter_52_2, iter_52_3 in pairs(var_52_1) do
		if (not var_52_4[iter_52_3.suitID] or not var_52_4[iter_52_3.suitID][iter_52_3.suitNo]) and not var_52_6[iter_52_3.gem_id] then
			if iter_52_3.suitID and iter_52_3.suitNo then
				var_52_4[iter_52_3.suitID] = var_52_4[iter_52_3.suitID] or {}
				var_52_4[iter_52_3.suitID][iter_52_3.suitNo] = true
			else
				var_52_6[iter_52_3.gem_id] = true
			end

			var_0_0(var_52_5, iter_52_3.dbid)

			if #var_52_5 == 9 then
				break
			end
		end
	end

	local var_52_7 = {}
	local var_52_8 = 0

	for iter_52_4 = 1, 9 do
		local var_52_9, var_52_10 = var_0_6.isSlotLocked(arg_52_0.carddbid, iter_52_4)

		if not var_52_9 then
			var_52_8 = var_52_8 + 1
			var_52_7[iter_52_4] = var_52_5[var_52_8]
		end
	end

	gGameApp:requestServer("/game/gem/onekey/equip", function(arg_54_0)
		gGameUI:showTip(gLanguageCsv.inlaySuccess)
	end, arg_52_0.carddbid, var_52_7)
end

function var_0_7.initModel(arg_55_0)
	arg_55_0.items = gGameModel.role:getIdler("items")
	arg_55_0.gems = gGameModel.role:getIdler("gems")
	arg_55_0.goldFreeCount = gGameModel.daily_record:getIdler("gem_gold_dc1_free_count")
	arg_55_0.rmbFreeCount = gGameModel.daily_record:getIdler("gem_rmb_dc1_free_count")
end

function var_0_7.onCleanup(arg_56_0)
	var_0_5.onCleanup(arg_56_0)
	arg_56_0.selectItem:destroy()
end

return var_0_7
