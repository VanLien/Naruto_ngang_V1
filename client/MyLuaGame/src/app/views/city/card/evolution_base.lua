local function var_0_0(arg_1_0, arg_1_1)
	local var_1_0 = csv.unit[arg_1_1.unitID]
	local var_1_1 = arg_1_0.cardImg:size()

	arg_1_0.cardImg:removeAllChildren()

	local var_1_2 = widget.addAnimation(arg_1_0.cardImg, var_1_0.unitRes, "standby_loop")

	var_1_2:xy(var_1_1.width / 2, var_1_1.height / 7):scale(var_1_0.scale)
	var_1_2:setSkin(var_1_0.skin)
	arg_1_0.name:text(var_1_0.name):show():setTextColor(ui.COLORS.NORMAL.DEFAULT)
	arg_1_0.attr2:visible(var_1_0.natureType2 ~= nil)

	if var_1_0.natureType2 then
		arg_1_0.attr2:texture(ui.ATTR_ICON[var_1_0.natureType2])
	end

	itertools.invoke({
		arg_1_0.rarity,
		arg_1_0.attr1
	}, "show")
	arg_1_0.rarity:texture(ui.RARITY_ICON[var_1_0.rarity])
	arg_1_0.attr1:texture(ui.ATTR_ICON[var_1_0.natureType])

	if var_1_0.natureType2 then
		adapt.oneLineCenterPos(cc.p(290, 80), {
			arg_1_0.rarity,
			arg_1_0.name,
			arg_1_0.attr1,
			arg_1_0.attr2
		}, cc.p(8, 0))
	else
		adapt.oneLineCenterPos(cc.p(290, 80), {
			arg_1_0.rarity,
			arg_1_0.name,
			arg_1_0.attr1
		}, cc.p(8, 0))
	end
end

local function var_0_1(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_0:get("cardImg")

	ccui.ImageView:create("city/card/evolution/img_unknown@.png"):align(cc.p(0.5, 0.5), var_2_0:x() - 35, var_2_0:y() * 0.55):addTo(var_2_0, 2, "ball")
	arg_2_0:get("btnSelect"):visible(false)
	arg_2_0:get("btnChanceShape"):visible(false)
	nodetools.invoke(arg_2_0, {
		"attr2",
		"attr1",
		"rarity",
		"name"
	}, "hide")

	if arg_2_1 then
		arg_2_0:get("name"):text(gLanguageCsv.appearBranch):show()
		arg_2_0:get("name"):setTextColor(ui.COLORS.NORMAL.RED)
		arg_2_0:get("name"):x(arg_2_0:get("name"):x() + 30)
	end
end

local function var_0_2(arg_3_0)
	local var_3_0 = arg_3_0
	local var_3_1 = itertools.size(arg_3_0.branch)

	if arg_3_0.branch[arg_3_0.currBranch] then
		var_3_0 = arg_3_0.branch[arg_3_0.currBranch]
	end

	return var_3_0
end

local function var_0_3(arg_4_0, arg_4_1)
	local var_4_0 = var_0_2(arg_4_1)

	if arg_4_0.cardImg:get("ball") then
		arg_4_0.cardImg:get("ball"):hide()
	end

	var_0_0(arg_4_0, var_4_0)
end

local var_0_4 = cc.load("mvc").ViewBase
local var_0_5 = class("CardEvolutionBaseView", Dialog)

var_0_5.RESOURCE_FILENAME = "card_evolution.json"
var_0_5.RESOURCE_BINDING = {
	lastTxt = "lastTxt",
	branchPanel = "branchPanel",
	["bottomPanel.icon"] = "bottomIcon",
	["bottomPanel.txtNot1"] = "txtNot1",
	["bottomPanel.txtNot2"] = "txtNot2",
	["bottomPanel.txt2"] = "txt2",
	item1 = "item1",
	item = "item",
	["bottomPanel.txt3"] = "txt3",
	["bottomPanel.txt1"] = "txt1",
	bottomPanel = "bottomPanel",
	effect = {
		varname = "effect",
		binds = {
			event = "visible",
			idler = bindHelper.self("showEffect")
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
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("showData"),
				item = bindHelper.self("item"),
				margin = bindHelper.self("listMargin"),
				padding = bindHelper.self("listPadding"),
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					local var_5_0 = arg_5_1:multiget("btnSelect", "next", "cardImg", "name", "attr1", "attr2", "rarity", "curr", "bottom", "btnSelection", "btnChangeShape", "btnChanceShape")

					for iter_5_0 = 1, 3 do
						arg_5_1:removeChildByName("effect" .. iter_5_0)
					end

					local var_5_1 = arg_5_3.develop == arg_5_3.currDevelop

					bind.touch(arg_5_0, var_5_0.btnSelect, {
						methods = {
							ended = functools.partial(arg_5_0.clickSelect, arg_5_2)
						}
					})
					bind.touch(arg_5_0, var_5_0.btnSelection, {
						methods = {
							ended = functools.partial(arg_5_0.clickSelection, arg_5_2)
						}
					})
					bind.touch(arg_5_0, var_5_0.btnChangeShape, {
						methods = {
							ended = functools.partial(arg_5_0.clickChangeShape, arg_5_2)
						}
					})
					bind.touch(arg_5_0, var_5_0.btnChanceShape, {
						methods = {
							ended = functools.partial(arg_5_0.clickChangeShape, arg_5_2)
						}
					})
					var_5_0.curr:visible(false)

					local var_5_2 = arg_5_1:size()
					local var_5_3 = CSprite.new("effect/jinhuajiemian.skel")

					var_5_3:xy(var_5_2.width / 2 - 40, var_5_2.height / 4 - 15)
					var_5_3:play("effect_down2_loop")
					var_5_3:addTo(arg_5_1, 4, "effect1")
					var_5_3:visible(var_5_1)

					local var_5_4 = CSprite.new("effect/jinhuajiemian.skel")

					var_5_4:xy(var_5_2.width / 2 - 40, var_5_2.height / 4 - 15)
					var_5_4:play("effect_down_loop")
					var_5_4:addTo(arg_5_1, 5, "effect2")
					var_5_4:visible(var_5_1)

					local var_5_5 = CSprite.new("effect/jinhuajiemian.skel")

					var_5_5:xy(var_5_2.width / 2 - 40, var_5_2.height / 4 - 15)
					var_5_5:play("effect_up_loop")
					var_5_5:addTo(arg_5_1, 7, "effect3")
					var_5_5:visible(var_5_1)
					var_5_0.bottom:visible(not var_5_1)

					if arg_5_3.develop <= arg_5_3.currDevelop then
						if var_5_0.cardImg:get("ball") then
							var_5_0.cardImg:get("ball"):hide()
						end

						if arg_5_3.currDevelop == arg_5_3.maxDevelop then
							if arg_5_3.isBranch and arg_5_3.cardSwitchBranch and arg_5_3.develop == arg_5_3.maxDevelop and itertools.size(arg_5_3.branch) > 1 then
								if arg_5_3.branchType == 1 then
									var_5_0.btnSelection:show()
								elseif arg_5_3.branchType == 2 then
									var_5_0.btnChangeShape:show()
								end
							else
								var_5_0.btnSelection:hide()
								var_5_0.btnChangeShape:hide()
							end
						elseif arg_5_3.isBranch and arg_5_3.cardSwitchBranch and itertools.size(arg_5_3.branch) > 1 then
							if arg_5_3.branchType == 1 then
								var_5_0.btnSelection:show()
							elseif arg_5_3.branchType == 2 then
								var_5_0.btnChangeShape:show()
							end
						else
							var_5_0.btnSelection:hide()
							var_5_0.btnChangeShape:hide()
						end

						var_0_0(var_5_0, var_0_2(arg_5_3))
						var_5_0.btnSelect:hide()
						var_5_0.btnChanceShape:hide()
					else
						local var_5_6 = itertools.size(arg_5_3.branch)

						var_5_0.btnSelect:visible(var_5_6 > 1 and arg_5_3.isBranchPoint and arg_5_3.branchType == 1)
						var_5_0.btnChanceShape:visible(var_5_6 > 1 and arg_5_3.isBranchPoint and arg_5_3.branchType == 2)

						if not arg_5_3.branch[arg_5_3.currBranch] and var_5_6 > 1 then
							var_0_1(arg_5_1)
						else
							var_0_3(var_5_0, arg_5_3)
						end
					end

					var_5_0.next:visible(arg_5_2 ~= 1)
				end,
				onAfterBuild = function(arg_6_0)
					arg_6_0:setItemAlignCenter()

					if arg_6_0:getChildrenCount() > 3 then
						arg_6_0:jumpToPercentHorizontal(80)
					end
				end
			},
			handlers = {
				clickSelect = bindHelper.self("onSelectBranch"),
				clickSelection = bindHelper.self("onChangeBranch"),
				clickChangeShape = bindHelper.self("onChangeShape")
			}
		}
	},
	["bottomPanel.list"] = {
		varname = "bottomList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 20,
				data = bindHelper.self("showSmallData"),
				item = bindHelper.self("item1"),
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					local var_7_0 = dataEasy.getNumByKey(arg_7_3.id)
					local var_7_1 = {
						class = "icon_key",
						props = {
							noListener = true,
							data = {
								key = arg_7_3.id,
								num = var_7_0,
								targetNum = arg_7_3.num
							},
							grayState = var_7_0 >= arg_7_3.num and 1 or 0
						}
					}

					bind.extend(arg_7_0, arg_7_1, var_7_1)
					arg_7_1.panel:setTouchEnabled(false)
					nodetools.invoke(arg_7_1, {
						"mask",
						"add"
					}, "visible", var_7_0 < arg_7_3.num)
					bind.touch(arg_7_1, arg_7_1, {
						methods = {
							ended = function()
								gGameUI:stackUI("common.gain_way", nil, nil, arg_7_3.id, nil, arg_7_3.num)
							end
						}
					})
				end
			}
		}
	},
	["bottomPanel.num"] = {
		varname = "cost",
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.DEFAULT
			}
		}
	},
	["branchPanel.btnBranch"] = {
		varname = "btnBranch",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSelectBranch")
			}
		}
	},
	["bottomPanel.btnEvolution"] = {
		varname = "btnEvolution",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onEvolution")
			}
		}
	},
	["bottomPanel.btnEvolution.title"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	}
}

function var_0_5.onCreate(arg_9_0, arg_9_1)
	arg_9_0.update = idler.new(false)
	arg_9_0.selectDbId = arg_9_1

	arg_9_0:initModel()

	arg_9_0.cardSwitchBranch = dataEasy.isUnlock(gUnlockCsv.cardSwitchBranch)
	arg_9_0.canClick = true
	arg_9_0.showEffect = idler.new(false)

	local var_9_0 = arg_9_0.list:x()

	arg_9_0.showSmallData = idlertable.new({})

	local var_9_1 = {
		var_9_0 + 680,
		var_9_0 + 350,
		var_9_0
	}

	arg_9_0.showData = idlertable.new()
	arg_9_0.currDevelop = idler.new()

	local var_9_2 = userDefault.getForeverLocalKey("evolutionBranch", {})
	local var_9_3 = csv.cards[arg_9_0.cardId:read()].branch

	if var_9_3 == 0 and var_9_2[arg_9_0.cardId:read()] then
		var_9_3 = var_9_2[arg_9_0.cardId:read()]
	end

	arg_9_0.currBranch = idler.new(var_9_3)

	arg_9_0:setDevelopData()

	arg_9_0.maxDevelop = #arg_9_0.mainData
	arg_9_0.oldCurrBranch = var_9_3

	idlereasy.when(arg_9_0.update, function(arg_10_0, arg_10_1)
		arg_9_0:initModel()
	end)
	idlereasy.when(arg_9_0.cardId, function(arg_11_0, arg_11_1)
		arg_9_0:setDevelopData()

		arg_9_0.maxDevelop = #arg_9_0.mainData
		arg_9_0.oldCurrBranch = var_9_3

		local var_11_0 = csv.cards[arg_9_0.cardId:read()].branch

		arg_9_0.currBranch:set(var_11_0, true)
	end)
	idlereasy.when(arg_9_0.currBranch, function(arg_12_0, arg_12_1)
		local var_12_0 = arg_9_0.cardId:read()
		local var_12_1 = csv.cards[var_12_0]
		local var_12_2 = var_12_1.cardMarkID
		local var_12_3 = var_12_1.develop

		arg_9_0.currDevelop:set(var_12_1.develop)

		local var_12_4 = {}
		local var_12_5 = false

		for iter_12_0, iter_12_1 in ipairs(arg_9_0.mainData) do
			local var_12_6 = itertools.size(iter_12_1.branch)

			if arg_12_1 ~= 0 and not iter_12_1.branch[arg_12_1] and var_12_6 ~= 0 then
				break
			end

			if iter_12_1.develop > arg_9_0.maxDevelop then
				arg_9_0.maxDevelop = iter_12_1.develop
			end

			if iter_12_1.branch[arg_12_1] and iter_12_1.branch[arg_12_1].develop > arg_9_0.maxDevelop then
				arg_9_0.maxDevelop = iter_12_1.branch[arg_12_1].develop
			end

			iter_12_1.isBranchPoint = false

			if var_12_6 > 1 and not var_12_5 then
				var_12_5 = true
				iter_12_1.isBranchPoint = true

				if arg_12_1 ~= 0 and iter_12_1.branch[arg_12_1].id == var_12_0 and arg_9_0.oldCurrBranch ~= 0 then
					uiEasy.showConfirmNature(iter_12_1.branch[arg_9_0.oldCurrBranch].id, iter_12_1.branch[arg_12_1].id)

					arg_9_0.oldCurrBranch = arg_12_1
				end
			end

			iter_12_1.currDevelop = var_12_3
			iter_12_1.currBranch = arg_12_1
			arg_9_0.branchType = iter_12_1.branchType

			table.insert(var_12_4, iter_12_1)
		end

		table.sort(var_12_4, function(arg_13_0, arg_13_1)
			return arg_13_0.develop < arg_13_1.develop
		end)

		arg_9_0.developPos = 1

		for iter_12_2, iter_12_3 in ipairs(var_12_4) do
			if var_12_0 == iter_12_3.id then
				arg_9_0.developPos = iter_12_2
			end

			for iter_12_4, iter_12_5 in pairs(iter_12_3.branch) do
				if var_12_0 == iter_12_5.id then
					arg_9_0.developPos = iter_12_2
				end
			end
		end

		arg_9_0.showData:set(var_12_4, true)

		local var_12_7 = #var_12_4

		arg_9_0.listPadding = var_12_7 <= 1 and 120 or 0

		if arg_12_1 ~= 0 then
			arg_9_0.list:setTouchEnabled(var_12_7 > 3)

			arg_9_0.listMargin = var_12_7 <= 3 and 2 or -12
		else
			arg_9_0.list:setTouchEnabled(var_12_7 > 3)

			arg_9_0.listMargin = var_12_7 <= 3 and 2 or -12
		end

		arg_9_0:bottomPanelRefresh(arg_12_1, var_12_3)
	end)
	Dialog.onCreate(arg_9_0)
end

function var_0_5.initModel(arg_14_0)
	local var_14_0 = gGameModel.cards:find(arg_14_0.selectDbId)

	arg_14_0.attrs = var_14_0:getIdler("attrs")
	arg_14_0.oldFight = var_14_0:getIdler("fighting_point")
	arg_14_0.cardId = var_14_0:getIdler("card_id")
	arg_14_0.star = var_14_0:getIdler("star")
	arg_14_0.advance = var_14_0:getIdler("advance")
	arg_14_0.level = var_14_0:getIdler("level")
end

function var_0_5.setDevelopData(arg_15_0)
	local var_15_0 = csv.cards[arg_15_0.cardId:read()].cardMarkID

	arg_15_0.cardMaskData = {}
	arg_15_0.mainData = {}
	arg_15_0.branchData = {}

	local var_15_1 = 0

	for iter_15_0, iter_15_1 in orderCsvPairs(csv.cards) do
		if matchLanguage(iter_15_1.languages) and iter_15_1.canDevelop and iter_15_1.cardMarkID == var_15_0 and var_15_1 < iter_15_1.develop then
			var_15_1 = iter_15_1.develop
		end
	end

	for iter_15_2, iter_15_3 in orderCsvPairs(csv.cards) do
		if matchLanguage(iter_15_3.languages) and iter_15_3.canDevelop and iter_15_3.cardMarkID == var_15_0 then
			if not arg_15_0.cardMaskData[iter_15_3.cardMarkID] then
				arg_15_0.cardMaskData[iter_15_3.cardMarkID] = {}
			end

			table.insert(arg_15_0.cardMaskData[iter_15_3.cardMarkID], iter_15_2)

			if not arg_15_0.branchData[iter_15_3.branch] then
				arg_15_0.branchData[iter_15_3.branch] = {}
			end

			local var_15_2 = false

			if iter_15_3.branch ~= 0 then
				var_15_2 = true
			end

			table.insert(arg_15_0.branchData[iter_15_3.branch], {
				currBranch = 0,
				isBranchPoint = false,
				currDevelop = iter_15_3.develop,
				currRealBranch = iter_15_3.branch,
				id = iter_15_2,
				unitID = iter_15_3.unitID,
				cardMarkID = iter_15_3.cardMarkID,
				develop = iter_15_3.develop,
				branch = {},
				megaIndex = iter_15_3.megaIndex,
				isBranch = var_15_2,
				cardSwitchBranch = arg_15_0.cardSwitchBranch,
				branchType = iter_15_3.branchType,
				maxDevelop = var_15_1
			})
		end
	end

	local var_15_3 = 0
	local var_15_4 = {}

	for iter_15_4, iter_15_5 in pairs(arg_15_0.branchData) do
		if iter_15_4 ~= 0 and var_15_3 < #iter_15_5 then
			var_15_3 = #iter_15_5
			var_15_4 = iter_15_5
		end
	end

	table.sort(var_15_4, function(arg_16_0, arg_16_1)
		return arg_16_0.develop < arg_16_1.develop
	end)

	arg_15_0.mainData = arg_15_0.branchData[0] or {}

	for iter_15_6 = 1, var_15_3 do
		local var_15_5 = var_15_4[iter_15_6]

		for iter_15_7, iter_15_8 in pairs(arg_15_0.branchData) do
			table.sort(iter_15_8, function(arg_17_0, arg_17_1)
				return arg_17_0.develop < arg_17_1.develop
			end)

			if iter_15_7 ~= 0 and iter_15_8[iter_15_6] then
				var_15_5.branch[iter_15_8[iter_15_6].currRealBranch] = iter_15_8[iter_15_6]
			end
		end

		table.insert(arg_15_0.mainData, var_15_5)
	end

	local var_15_6 = {}
	local var_15_7 = false
	local var_15_8 = csv.cards[arg_15_0.cardId:read()].megaIndex > 0 and true or false

	for iter_15_9, iter_15_10 in pairs(arg_15_0.mainData) do
		if iter_15_10.megaIndex == 0 then
			table.insert(var_15_6, iter_15_10)
		else
			var_15_7 = true
		end
	end

	if not var_15_8 and var_15_7 then
		arg_15_0.mainData = var_15_6
	end
end

function var_0_5.bottomPanelRefresh(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_0.star:read()
	local var_18_1 = arg_18_0.level:read()
	local var_18_2 = arg_18_0.advance:read()
	local var_18_3
	local var_18_4 = arg_18_0.showData:proxy()[arg_18_0.developPos + 1]

	if var_18_4 then
		var_18_3 = var_0_2(var_18_4).id
	end

	local var_18_5 = csv.base_attribute.develop_level[var_18_3]

	if arg_18_2 < arg_18_0.maxDevelop and var_18_5 then
		local var_18_6 = 0
		local var_18_7 = {}

		for iter_18_0, iter_18_1 in csvMapPairs(var_18_5.cost) do
			if iter_18_0 ~= "gold" then
				table.insert(var_18_7, {
					id = iter_18_0,
					num = iter_18_1
				})
			end
		end

		arg_18_0.showSmallData:set(var_18_7, true)

		arg_18_0.strs = {}

		local function var_18_8(arg_19_0, arg_19_1)
			if arg_19_1.base ~= 0 then
				local var_19_0

				if not arg_19_1.special then
					if not arg_19_1.color then
						local var_19_1 = {}
						local var_19_2 = arg_19_1.base
						local var_19_3 = var_19_2 > 6 and 6 or var_19_2

						for iter_19_0 = 1, var_19_3 do
							if iter_19_0 <= var_19_2 - 6 then
								table.insert(var_19_1, "#Icommon/icon/icon_star_z.png-50-50#")
							else
								table.insert(var_19_1, "#Icommon/icon/icon_star.png-50-50#")
							end
						end

						var_19_0 = arg_19_1.str .. table.concat(var_19_1, "")
					else
						var_19_0 = string.format(arg_19_1.str, arg_19_1.color, arg_19_1.state, arg_19_1.base)
					end
				else
					local var_19_4, var_19_5 = dataEasy.getQuality(arg_19_1.base, false)

					var_19_0 = string.format(arg_19_1.str, ui.QUALITYCOLOR[var_19_4], gLanguageCsv[ui.QUALITY_COLOR_TEXT[var_19_4]], var_19_5)
				end

				table.insert(arg_19_0, {
					str = var_19_0,
					state = arg_19_1.state >= arg_19_1.base and 1 or 0,
					tip = arg_19_1.tip
				})
			end
		end

		local var_18_9 = "#C0x60C456#"

		if var_18_1 < var_18_5.needLevel then
			var_18_9 = "#C0xF76B45#"
		end

		if var_18_5.needLevel ~= 0 then
			var_18_8(arg_18_0.strs, {
				str = gLanguageCsv.cardLevelArrive,
				state = var_18_1,
				base = var_18_5.needLevel,
				tip = gLanguageCsv.spriteEvolutionLevelNotEnough,
				color = var_18_9
			})
		end

		if var_18_5.needStar ~= 0 then
			var_18_8(arg_18_0.strs, {
				str = gLanguageCsv.cardStarArrive,
				state = var_18_0,
				base = var_18_5.needStar,
				tip = gLanguageCsv.spriteEvolutionStarNotEnough
			})
		end

		if var_18_5.needAdvance ~= 0 then
			var_18_8(arg_18_0.strs, {
				special = true,
				str = gLanguageCsv.cardAdvanceArrive,
				state = var_18_2,
				base = var_18_5.needAdvance,
				tip = gLanguageCsv.spriteEvolutionAdvanceNotEnough
			})
		end

		table.sort(arg_18_0.strs, function(arg_20_0, arg_20_1)
			return arg_20_0.state < arg_20_1.state
		end)

		for iter_18_2 = 1, 2 do
			arg_18_0["txt" .. iter_18_2]:visible(false)
			arg_18_0["txtNot" .. iter_18_2]:visible(false)
			arg_18_0.bottomPanel:removeChildByName("richText" .. iter_18_2)
		end

		for iter_18_3 = 1, math.min(#arg_18_0.strs, 2) do
			local var_18_10, var_18_11 = arg_18_0["txt" .. iter_18_3]:xy()
			local var_18_12 = "#C0x5B545B#" .. iter_18_3 .. "." .. arg_18_0.strs[iter_18_3].str
			local var_18_13 = " #Icity/card/evolution/logo_tick1.png#"

			if arg_18_0.strs[iter_18_3].state ~= 1 then
				var_18_13 = "#C0xF76B45#" .. gLanguageCsv.notFinished
			end

			local var_18_14 = var_18_12 .. var_18_13
			local var_18_15 = rich.createWithWidth(var_18_14, 40, nil, 1100):anchorPoint(0, 0.5):xy(var_18_10, var_18_11):addTo(arg_18_0.bottomPanel, 10, "richText" .. iter_18_3)
		end

		if var_18_5.cost.gold and var_18_5.cost.gold ~= 0 then
			arg_18_0.cost:text(var_18_5.cost.gold)
			arg_18_0.cost:show()
			arg_18_0.bottomIcon:show()
			arg_18_0.txt3:show()
			adapt.oneLineCenterPos(cc.p(arg_18_0.btnEvolution:x(), arg_18_0.btnEvolution:y() + 90), {
				arg_18_0.txt3,
				arg_18_0.cost,
				arg_18_0.bottomIcon
			}, cc.p(10, 0))
			idlereasy.when(gGameModel.role:getIdler("gold"), function(arg_21_0, arg_21_1)
				arg_18_0.enoughGold = arg_21_1 >= var_18_5.cost.gold

				arg_18_0.cost:setTextColor(arg_18_0.enoughGold and ui.COLORS.NORMAL.DEFAULT or ui.COLORS.NORMAL.RED)
			end):anonyOnly(arg_18_0, "gold")
		else
			arg_18_0.cost:hide()
			arg_18_0.bottomIcon:hide()
			arg_18_0.txt3:hide()
		end
	end

	arg_18_0:bottomPanelBranchRefresh(arg_18_1, arg_18_2, var_18_4)
end

function var_0_5.bottomPanelBranchRefresh(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	local var_22_0 = arg_22_3 and (arg_22_3.branch[arg_22_1] ~= nil or itertools.size(arg_22_3.branch) <= 1)

	arg_22_0.bottomPanel:visible(arg_22_2 ~= arg_22_0.maxDevelop and var_22_0)
	arg_22_0.branchPanel:visible(arg_22_2 ~= arg_22_0.maxDevelop and not var_22_0)

	if arg_22_0.branchType == 2 then
		arg_22_0.branchPanel:get("txt"):text(gLanguageCsv.succeedChanceChangeShapeText)
		adapt.setTextScaleWithWidth(arg_22_0.btnBranch:get("title"), gLanguageCsv.shapeLookText, 300)
	end

	arg_22_0.cardMega = false

	local var_22_1 = false
	local var_22_2 = csv.cards[arg_22_0.cardId:read()].cardMarkID

	for iter_22_0, iter_22_1 in pairs(arg_22_0.cardMaskData[var_22_2]) do
		if csv.cards[iter_22_1].megaIndex > 0 then
			var_22_1 = true
		end
	end

	local var_22_3 = csv.cards[arg_22_0.cardId:read()].megaIndex == 0

	if var_22_1 and arg_22_2 == arg_22_0.maxDevelop and dataEasy.isUnlock(gUnlockCsv.mega) and var_22_3 then
		arg_22_0.branchPanel:visible(true)
		arg_22_0.branchPanel:get("txt"):visible(false)
		adapt.setTextScaleWithWidth(arg_22_0.btnBranch:get("title"), gLanguageCsv.megaHouse, 300)

		arg_22_0.cardMega = true

		arg_22_0.lastTxt:visible(false)
	elseif arg_22_2 == arg_22_0.maxDevelop then
		arg_22_0.lastTxt:visible(true)
		arg_22_0.branchPanel:get("txt"):visible(true)
	else
		arg_22_0.lastTxt:visible(false)
	end
end

function var_0_5.onSelectBranch(arg_23_0)
	if not arg_23_0.cardMega then
		if arg_23_0.branchType == 1 then
			gGameUI:stackUI("city.card.evolution_branch", nil, nil, arg_23_0:createHandler("sendParams"))
		else
			gGameUI:stackUI("city.card.evolution_change_shape", nil, nil, arg_23_0:createHandler("sendParams"))
		end
	end
end

function var_0_5.onChangeBranch(arg_24_0)
	gGameUI:stackUI("city.card.evolution_branch", nil, nil, arg_24_0:createHandler("sendParams"))
end

function var_0_5.onChangeShape(arg_25_0)
	gGameUI:stackUI("city.card.evolution_change_shape", nil, nil, arg_25_0:createHandler("sendParams"))
end

function var_0_5.playAction(arg_26_0, arg_26_1)
	arg_26_0.showEffect:set(true)
	;(arg_26_0.effect:getChildByName("effect1") or widget.addAnimationByKey(arg_26_0.effect, "effect/jinhua.skel", "effect1", "effect_down", 1):scale(2):alignCenter(arg_26_0.effect:size())):play("effect_down")

	local var_26_0 = arg_26_0.effect:getChildByName("effect2")

	CSprite.new("effect/jinhua.skel")

	var_26_0 = var_26_0 or widget.addAnimationByKey(arg_26_0.effect, "effect/jinhua.skel", "effect2", "effect_up", 3):scale(2):alignCenter(arg_26_0.effect:size())

	var_26_0:play("effect_up")

	local var_26_1 = arg_26_0.developPos
	local var_26_2 = arg_26_0.showData:proxy()[arg_26_0.developPos - 1]
	local var_26_3 = var_0_2(var_26_2)
	local var_26_4 = csv.unit[var_26_3.unitID]

	arg_26_0.effect:removeChildByName("roleSpine")

	local var_26_5 = widget.addAnimationByKey(arg_26_0.effect, var_26_4.unitRes, "roleSpine", "standby_loop", 2):alignCenter(arg_26_0.effect:size()):y(380):scale(var_26_4.scale)

	var_26_5:setSkin(var_26_4.skin)
	var_26_5:setCascadeOpacityEnabled(true)
	performWithDelay(arg_26_0.effect, function()
		transition.fadeOut(var_26_5, {
			time = 0.16666666666666666
		})
	end, 0.9666666666666667)
	performWithDelay(arg_26_0.effect, function()
		arg_26_0.effect:removeChildByName("roleSpine")

		local var_28_0 = arg_26_0.showData:proxy()[arg_26_0.developPos]
		local var_28_1 = var_0_2(var_28_0)
		local var_28_2 = csv.unit[var_28_1.unitID]

		widget.addAnimationByKey(arg_26_0.effect, var_28_2.unitRes, "roleSpine", "standby_loop", 2):alignCenter(arg_26_0.effect:size()):y(380):scale(var_28_2.scale):setSkin(var_28_2.skin)
	end, 8.6)
	performWithDelay(arg_26_0.effect, function()
		arg_26_0.showEffect:set(false)

		if arg_26_1 then
			arg_26_1()
		end
	end, 11.5)
end

function var_0_5.onEvolution(arg_30_0)
	if not arg_30_0.canClick then
		return
	end

	local var_30_0 = arg_30_0.cardId:read()

	for iter_30_0, iter_30_1 in ipairs(arg_30_0.strs) do
		if iter_30_1.state == 0 then
			gGameUI:showTip(iter_30_1.tip)

			return
		end
	end

	if not arg_30_0.enoughGold then
		uiEasy.showDialog("gold")

		return
	end

	arg_30_0.canClick = false

	local var_30_1 = {
		false
	}
	local var_30_2 = arg_30_0.showData:proxy()[arg_30_0.developPos + 1]
	local var_30_3 = var_30_2.currRealBranch

	if var_30_2.branch[arg_30_0.currBranch:read()] then
		var_30_3 = var_30_2.branch[arg_30_0.currBranch:read()].currRealBranch
	end

	local var_30_4 = arg_30_0.oldFight:read()
	local var_30_5 = clone(arg_30_0.attrs:read())

	gGameApp:requestServerCustom("/game/card/develop"):params(arg_30_0.selectDbId, var_30_3):delay(0.1):doit(function()
		audio.playEffectWithWeekBGM("evolution.mp3")
		arg_30_0:playAction(function()
			arg_30_0.canClick = true

			gGameUI:stackUI("city.card.common_success", nil, {
				blackLayer = true
			}, arg_30_0.selectDbId, var_30_4, {
				cardOld = var_30_0,
				attrs = var_30_5
			})
		end)
	end)
end

function var_0_5.sendParams(arg_33_0, arg_33_1)
	if arg_33_1 then
		arg_33_0.currBranch:set(arg_33_1)
	end

	return arg_33_0.currDevelop:read(), arg_33_0.mainData, arg_33_0.currBranch:read(), arg_33_0.selectDbId, arg_33_0.currBranch
end

function var_0_5.updateDbid(arg_34_0)
	arg_34_0.update:set(not arg_34_0.update:read())
end

return var_0_5
