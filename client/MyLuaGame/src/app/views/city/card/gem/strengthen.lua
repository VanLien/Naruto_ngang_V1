local var_0_0 = class("GemStrengthenView", Dialog)
local var_0_1 = table.insert

var_0_0.RESOURCE_FILENAME = "gem_strengthen.json"
var_0_0.RESOURCE_BINDING = {
	["gemPanel.equipOn"] = "equipOn",
	["gemPanel.cardName"] = "cardName",
	["gemPanel.icon"] = "icon",
	["detail.lvNum"] = "detailLv",
	["detail.lvNum2"] = "detailLv2",
	["acquire.num"] = "acquireNum",
	["gemPanel.gemName"] = "gemName",
	["gemPanel.gemIconBg"] = "gemIconBg",
	gemPanel = "gemPanel",
	["detail.lvMax"] = "detailLvMax",
	["gemPanel.lvBg"] = "lvBg",
	subList = "subList",
	item = "item",
	imgLvMax = "imgLvMax",
	btnPanel = "btnPanel",
	["detail.arrow"] = "detailArrow",
	acquire = "acquire",
	["btnPanel.txtCost"] = "txtCost",
	["detail.attr"] = "attr",
	detail = "detail",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	titleTxt1 = {
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
	titleTxt2 = {
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
	["gemPanel.lv"] = {
		varname = "lv",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						color = ui.COLORS.OUTLINE.DEFAULT
					}
				}
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 5,
				asyncPreload = 15,
				topPadding = 10,
				leftPadding = 10,
				preloadCenterIndex = bindHelper.self("curIdx"),
				data = bindHelper.self("gems"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					bind.extend(arg_1_0, arg_1_1, {
						class = "icon_key",
						props = {
							noListener = true,
							data = {
								key = arg_1_3.key,
								num = arg_1_3.num
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

								arg_2_0:stopAllActions()
								arg_2_0:scale(1)
								bind.touch(arg_1_0, arg_2_0, {
									methods = {
										ended = functools.partial(arg_1_0.itemClick, arg_2_0, arg_1_2, arg_1_3)
									}
								})
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
	["btnPanel.btnStrengthen"] = {
		varname = "btnStrengthen",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onStrengthen")
			}
		}
	},
	["btnPanel.btnStrengthen.title"] = {
		varname = "btnStrengthenTxt",
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
	["btnPanel.btnOneKeyStrengthen"] = {
		varname = "btnOneKeyStrengthen",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("oneKeyStrengthen")
			}
		}
	},
	["btnPanel.btnOneKeyStrengthen.title"] = {
		varname = "btnOneKeyStrengthenTxt",
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
	["detail.attrList"] = {
		varname = "attrList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("attrData"),
				item = bindHelper.self("attr"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					if arg_3_3.type == "special" then
						arg_3_1:get("attrTxt"):text(gLanguageCsv.attrIndexPoint)
						arg_3_1:get("attrNum"):text("+" .. arg_3_3.num)
					else
						local var_3_0 = game.ATTRDEF_TABLE[arg_3_3.type]
						local var_3_1 = "attr" .. string.caption(var_3_0)

						arg_3_1:get("attrTxt"):text(gLanguageCsv[var_3_1])

						local var_3_2 = dataEasy.getAttrValueString(arg_3_3.type, arg_3_3.num)

						arg_3_1:get("attrNum"):text("+" .. var_3_2)
					end

					adapt.oneLinePos(arg_3_1:get("attrTxt"), arg_3_1:get("attrNum"), cc.p(10, 0))

					local var_3_3 = arg_3_3.num == arg_3_3.nextNum

					arg_3_1:get("arrowUp"):visible(false)
					arg_3_1:get("attrNum3"):visible(false)

					if not arg_3_3.isMaxLv then
						if not var_3_3 then
							if arg_3_3.type == "special" then
								arg_3_1:get("attrNum2"):text("+" .. arg_3_3.nextNum .. "(+" .. arg_3_3.nextNum - arg_3_3.num)
							else
								local var_3_4 = dataEasy.getAttrValueString(arg_3_3.type, arg_3_3.nextNum)
								local var_3_5 = dataEasy.getAttrValueString(arg_3_3.type, arg_3_3.nextNum - arg_3_3.num)

								arg_3_1:get("attrNum2"):text("+" .. var_3_4 .. "(+" .. var_3_5)
							end

							arg_3_1:get("arrowUp"):visible(true)
							arg_3_1:get("attrNum3"):visible(true)
							adapt.oneLinePos(arg_3_1:get("attrNum"), {
								arg_3_1:get("arrow"),
								arg_3_1:get("attrNum2")
							}, cc.p(40, 0))
							adapt.oneLinePos(arg_3_1:get("attrNum2"), {
								arg_3_1:get("arrowUp"),
								arg_3_1:get("attrNum3")
							})
						elseif arg_3_3.nextLevel then
							arg_3_1:get("tip"):text(string.format(gLanguageCsv.strengthenWhenlvN, arg_3_3.nextLevel))
							adapt.oneLinePos(arg_3_1:get("attrNum"), arg_3_1:get("tip"))
						end
					end

					arg_3_1:get("tip"):visible(var_3_3 and not arg_3_3.isMaxLv and arg_3_3.nextLevel and true or false)
					arg_3_1:get("attrNum2"):visible(not var_3_3 and not arg_3_3.isMaxLv)
					arg_3_1:get("arrow"):visible(not var_3_3 and not arg_3_3.isMaxLv)
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_4_0, arg_4_1)
	arg_4_0.attr:visible(false)
	arg_4_0:initModel()

	arg_4_0.costNodes = {}

	dataEasy.getListenUnlock(gUnlockCsv.gemOnekeyStrengthen, function(arg_5_0)
		arg_4_0.btnOneKeyStrengthen:visible(arg_5_0)
		arg_4_0.btnStrengthen:x(arg_5_0 and 587 or 357)

		arg_4_0.unlock = arg_5_0

		arg_4_0:resetCostNodesXY()
	end)

	arg_4_0.gemIdler = idler.new()
	arg_4_0.attrData = idlers.newWithMap({})

	if arg_4_1 then
		arg_4_0.gemIdler:set(arg_4_1)
	end

	arg_4_0.selectEffect = ccui.ImageView:create("common/box/box_selected.png"):alignCenter(arg_4_0.item:size()):retain()

	idlereasy.when(arg_4_0.gemIdler, function(arg_6_0, arg_6_1)
		arg_4_0.firstDetail = false

		local var_6_0 = gGameModel.gems:find(arg_6_1)
		local var_6_1 = dataEasy.getCfgByKey(var_6_0:read("gem_id"))

		arg_4_0.icon:texture(var_6_1.icon)

		local var_6_2, var_6_3 = uiEasy.setIconName(var_6_0:read("gem_id"))

		arg_4_0.gemName:text(var_6_2)
		text.addEffect(arg_4_0.gemName, var_6_3)
		arg_4_0.gemIconBg:texture("city/card/helditem/strengthen/img_dt" .. var_6_1.quality .. ".png")

		arg_4_0.gemlevel = idlereasy.assign(var_6_0:getIdler("level"), arg_4_0.gemlevel)
	end)
	idlereasy.any({
		arg_4_0.gemlevel,
		arg_4_0.gold
	}, function(arg_7_0, arg_7_1)
		arg_4_0:setDetail()
	end)

	local var_4_0 = gGameModel.gems:find(arg_4_1):read("card_db_id")

	if not var_4_0 then
		arg_4_0.equipOn:visible(false)
		arg_4_0.cardName:visible(false)
	else
		local var_4_1 = gGameModel.cards:find(var_4_0)

		uiEasy.setIconName("card", var_4_1:read("card_id"), {
			space = true,
			node = arg_4_0.cardName,
			name = var_4_1:read("name"),
			advance = var_4_1:read("advance")
		})
		adapt.oneLineCenterPos(cc.p(241, 0), {
			arg_4_0.equipOn,
			arg_4_0.cardName
		})
	end

	arg_4_0.gems = idlers.new()

	local var_4_2 = 0
	local var_4_3 = {}
	local var_4_4

	if var_4_0 then
		var_4_4 = gGameModel.cards:find(var_4_0):read("gems")
	else
		var_4_4 = gGameModel.role:read("gems")
	end

	for iter_4_0, iter_4_1 in pairs(var_4_4) do
		local var_4_5 = gGameModel.gems:find(iter_4_1)

		if var_4_0 or not var_4_5:read("card_db_id") then
			var_4_2 = var_4_2 + 1

			local var_4_6 = dataEasy.getCfgByKey(var_4_5:read("gem_id"))
			local var_4_7 = {
				gemdbid = iter_4_1,
				key = var_4_5:read("gem_id"),
				quality = var_4_6.quality,
				suitID = var_4_6.suitID,
				suitNo = var_4_6.suitNo,
				level = var_4_5:read("level")
			}

			table.insert(var_4_3, var_4_7)
		end
	end

	table.sort(var_4_3, function(arg_8_0, arg_8_1)
		if arg_8_0.quality ~= arg_8_1.quality then
			return arg_8_0.quality > arg_8_1.quality
		end

		if arg_8_0.suitID ~= arg_8_1.suitID then
			if arg_8_0.suitID and arg_8_1.suitID then
				return arg_8_0.suitID < arg_8_1.suitID
			else
				return not arg_8_1.suitID
			end
		end

		if arg_8_0.suitNo ~= arg_8_1.suitNo then
			if arg_8_0.suitNo and arg_8_1.suitNo then
				return arg_8_0.suitNo < arg_8_1.suitNo
			else
				return not arg_8_1.suitNo
			end
		end

		return arg_8_0.level > arg_8_1.level
	end)

	for iter_4_2, iter_4_3 in ipairs(var_4_3) do
		if iter_4_3.gemdbid == arg_4_1 then
			arg_4_0.curIdx = math.ceil(iter_4_2 / 5)
			iter_4_3.selectEffect = arg_4_0.selectEffect
		end

		iter_4_3.idx = iter_4_2

		idlereasy.when(gGameModel.gems:find(iter_4_3.gemdbid):getIdler("level"), function(arg_9_0, arg_9_1)
			arg_4_0.gems:atproxy(iter_4_2).level = arg_9_1
		end, true):anonyOnly(arg_4_0, stringz.bintohex(iter_4_3.gemdbid))
	end

	arg_4_0.gems:update(var_4_3)

	if #var_4_3 <= 10 then
		performWithDelay(arg_4_0, function()
			arg_4_0.list:setItemAlignCenter()
		end, 0)
	end

	arg_4_0.selectItem = idler.new()

	arg_4_0.selectItem:addListener(function(arg_11_0, arg_11_1)
		if arg_11_0 then
			arg_4_0.gems:atproxy(arg_11_0).selectEffect = arg_4_0.selectEffect
		end
	end)

	arg_4_0.item529 = idler.new(0)

	idlereasy.when(gGameModel.role:getIdler("items"), function(arg_12_0, arg_12_1)
		arg_4_0.item529:set(arg_12_1[529] or 0)
	end)
	idlereasy.when(arg_4_0.item529, function(arg_13_0, arg_13_1)
		arg_4_0.acquireNum:text(arg_13_1)

		local var_13_0 = arg_4_0.acquireNum:width() + 50
		local var_13_1 = math.max(var_13_0, 187)

		arg_4_0.acquire:get("bg"):width(var_13_1)
		arg_4_0.acquireNum:x(arg_4_0.acquire:get("bg"):x() + var_13_1 / 2)
	end)
	Dialog.onCreate(arg_4_0)
end

function var_0_0.setDetail(arg_14_0)
	local var_14_0 = gGameModel.gems:find(arg_14_0.gemIdler:read())
	local var_14_1 = var_14_0:read("level")
	local var_14_2 = dataEasy.getCfgByKey(var_14_0:read("gem_id"))

	arg_14_0.lv:text("Lv" .. var_14_1)
	arg_14_0.detailLv:text("Lv" .. var_14_1)
	arg_14_0.detailLv2:text("Lv" .. var_14_1 + 1)
	arg_14_0.lvBg:visible(false)

	local var_14_3 = var_14_1 == var_14_2.strengthMax

	arg_14_0.detailLvMax:visible(var_14_3)
	arg_14_0.detailLv2:visible(not var_14_3)
	arg_14_0.imgLvMax:visible(var_14_3)
	arg_14_0.detailArrow:visible(not var_14_3)
	adapt.oneLinePos(arg_14_0.detailLv, {
		arg_14_0.detailLvMax
	})
	arg_14_0.btnPanel:visible(not var_14_3)

	local var_14_4 = csv.gem.cost[var_14_1]["costItemMap" .. var_14_2.strengthCostSeq]

	for iter_14_0, iter_14_1 in pairs(arg_14_0.costNodes) do
		iter_14_1:removeSelf()
	end

	arg_14_0.costNodes = {}
	arg_14_0.needCost = nil

	for iter_14_2, iter_14_3 in csvMapPairs(var_14_4) do
		local var_14_5 = cc.Label:createWithTTF(iter_14_3, ui.FONT_PATH, 40):addTo(arg_14_0.btnPanel, 100):setTextColor(ui.COLORS.NORMAL.BLACK)
		local var_14_6 = ccui.ImageView:create(dataEasy.getIconResByKey(iter_14_2)):addTo(arg_14_0.btnPanel, 100):scale(0.8)

		var_0_1(arg_14_0.costNodes, var_14_5)
		var_0_1(arg_14_0.costNodes, var_14_6)

		if iter_14_3 > dataEasy.getNumByKey(iter_14_2) then
			text.addEffect(var_14_5, {
				color = ui.COLORS.NORMAL.RED
			})

			arg_14_0.needCost = iter_14_2
		end
	end

	arg_14_0:resetCostNodesXY()

	arg_14_0.curCost = var_14_4

	local var_14_7 = {}

	for iter_14_4 = 1, math.huge do
		if var_14_2["attrType" .. iter_14_4] and var_14_2["attrType" .. iter_14_4] ~= 0 then
			local var_14_8 = var_14_2["attrNum" .. iter_14_4]
			local var_14_9 = {
				type = var_14_2["attrType" .. iter_14_4],
				num = var_14_8[var_14_1],
				nextNum = var_14_8[var_14_1 + 1],
				level = var_14_1,
				isMaxLv = var_14_3
			}

			for iter_14_5 = var_14_1, var_14_2.strengthMax do
				if not var_14_8[iter_14_5] then
					break
				elseif var_14_8[iter_14_5] ~= var_14_8[var_14_1] then
					var_14_9.nextLevel = iter_14_5

					break
				end
			end

			table.insert(var_14_7, var_14_9)
		else
			break
		end
	end

	local var_14_10 = csv.gem.quality
	local var_14_11 = var_14_2.quality
	local var_14_12 = "qualityNum" .. var_14_11
	local var_14_13 = {
		type = "special",
		num = var_14_10[var_14_1][var_14_12],
		isMaxLv = var_14_3
	}

	if var_14_10[var_14_1 + 1] then
		var_14_13.nextNum = var_14_10[var_14_1 + 1][var_14_12]
	end

	for iter_14_6 = var_14_1, var_14_2.strengthMax do
		if not var_14_10[iter_14_6] then
			break
		elseif var_14_10[iter_14_6] and var_14_10[var_14_1][var_14_12] ~= var_14_10[iter_14_6][var_14_12] then
			var_14_13.nextLevel = iter_14_6

			break
		end
	end

	table.insert(var_14_7, var_14_13)
	arg_14_0.attrData:update(var_14_7)

	if not arg_14_0.firstDetail then
		arg_14_0.firstDetail = true
	else
		arg_14_0:showLvUpEffects()
	end
end

function var_0_0.resetCostNodesXY(arg_15_0)
	local var_15_0, var_15_1 = arg_15_0.btnStrengthen:xy()
	local var_15_2 = {
		arg_15_0.txtCost,
		unpack(arg_15_0.costNodes)
	}
	local var_15_3 = {}

	if arg_15_0.unlock then
		local var_15_4 = {}
		local var_15_5 = false

		for iter_15_0 = #var_15_2 - 1, 1, -1 do
			var_15_2[iter_15_0]:y(var_15_1 + 100)
			var_0_1(var_15_4, var_15_2[iter_15_0])
			var_0_1(var_15_3, var_15_5 and cc.p(15, 0) or cc.p(0, 0))

			var_15_5 = not var_15_5
		end

		var_15_2[#var_15_2]:xy(var_15_0 + 120, var_15_1 + 100)
		adapt.oneLinePos(var_15_2[#var_15_2], var_15_4, var_15_3, "right")
	else
		local var_15_6 = true

		for iter_15_1 = 1, #var_15_2 do
			var_0_1(var_15_3, var_15_6 and cc.p(15, 0) or cc.p(0, 0))

			var_15_6 = not var_15_6
		end

		adapt.oneLineCenterPos(cc.p(var_15_0, var_15_1 + 100), var_15_2, var_15_3)
	end
end

function var_0_0.showLvUpEffects(arg_16_0)
	local var_16_0 = arg_16_0.attrList:getItems()

	for iter_16_0, iter_16_1 in ipairs(var_16_0) do
		if iter_16_1:get("effect") then
			iter_16_1:get("effect"):removeSelf()
		end

		widget.addAnimationByKey(iter_16_1, "haogandujiesuo/shuzhibianhua.skel ", "effect", "effect", 10):alignCenter(iter_16_1:size()):xy(320, 40)
	end

	if arg_16_0.gemPanel:get("effect") then
		arg_16_0.gemPanel:get("effect"):removeSelf()
	end

	widget.addAnimationByKey(arg_16_0.gemPanel, "koudai_gonghuixunlian/gonghuixunlian.skel", "effect", "fangguang2", 100):xy(241, 150)
	gGameUI:showTip(gLanguageCsv.strengthenSuccess)
end

function var_0_0.onItemClick(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	arg_17_0.selectItem:set(arg_17_4.idx)
	arg_17_0.gemIdler:set(arg_17_4.gemdbid)
end

function var_0_0.onStrengthen(arg_18_0)
	if arg_18_0.needCost then
		if arg_18_0.needCost == "gold" or arg_18_0.needCost == "rmb" then
			uiEasy.showDialog(arg_18_0.needCost)
		else
			gGameUI:showTip(gLanguageCsv.materialsNotEnough)
		end

		return
	end

	local var_18_0 = arg_18_0.gemIdler:read()
	local var_18_1 = gGameModel.gems:find(var_18_0)

	gGameApp:requestServer("/game/gem/strength", function()
		return
	end, var_18_0, var_18_1:read("level") + 1)
end

function var_0_0.oneKeyStrengthen(arg_20_0)
	if arg_20_0.needCost then
		if arg_20_0.needCost == "gold" or arg_20_0.needCost == "rmb" then
			uiEasy.showDialog(arg_20_0.needCost)
		else
			gGameUI:showTip(gLanguageCsv.materialsNotEnough)
		end

		return
	end

	gGameUI:stackUI("city.card.gem.onekey_strengthen", nil, nil, arg_20_0.gemIdler:read())
end

function var_0_0.initModel(arg_21_0)
	arg_21_0.gold = gGameModel.role:getIdler("gold")
end

return var_0_0
