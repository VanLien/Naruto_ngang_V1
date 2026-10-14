local var_0_0 = class("PersonalFigureView", Dialog)
local var_0_1 = {
	{
		val = 1,
		name = gLanguageCsv.spaceAll
	},
	{
		val = 2,
		name = gLanguageCsv.unlockSuccess
	},
	{
		val = 3,
		name = gLanguageCsv.canUnlock
	},
	{
		val = 4,
		name = gLanguageCsv.notUnlock
	}
}
local var_0_2 = {
	ALL = 1,
	UNLOCKED = 2,
	NOT_UNLOCK = 4,
	CAN_UNLOCK = 3
}
local var_0_3 = {
	NOT_UNLOCK = 3,
	UNLOCKED = 1,
	NO_SHOW = 4,
	CAN_UNLOCK = 2
}
local var_0_4 = {
	FIGURE_EXPLAIN = 2,
	FIGURE_ATTR = 1
}
local var_0_5 = 3
local var_0_6 = {
	"effect_shiyongzhong_loop",
	"effect_xuanzhong",
	"effect_jiesuo"
}

local function var_0_7(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	for iter_1_0 = 1, math.huge do
		local var_1_0 = arg_1_1:get("item" .. iter_1_0)

		if not var_1_0 then
			break
		end

		var_1_0:removeFromParent()
	end

	local var_1_1 = arg_1_0:size().width

	if arg_1_3[1].sign == "title" then
		local var_1_2 = arg_1_1:get("title")

		var_1_2:visible(true)
		arg_1_1:get("list"):visible(false)
		var_1_2:text(arg_1_3[1].typ == 1 and gLanguageCsv.normalFigure or gLanguageCsv.raceFigure)

		local var_1_3 = var_1_2:getBoundingBox()

		arg_1_1:size(cc.size(var_1_1, var_1_3.height))
		var_1_2:y(var_1_3.height / 2 - 10)
	else
		arg_1_1:get("title"):visible(false)
		arg_1_1:get("list"):visible(true)

		local var_1_4 = arg_1_0.cloneItem:size()

		arg_1_1:size(cc.size(var_1_1, var_1_4.height))
		arg_1_1:get("list"):size(cc.size(var_1_1, var_1_4.height))

		local var_1_5 = {
			class = "listview",
			props = {
				data = arg_1_3,
				item = arg_1_0.cloneItem,
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = gRoleFigureCsv[arg_2_3.id]

					arg_2_1:get("icon"):texture(var_2_0.logo):scale(1.7)
					arg_2_1:get("selected"):visible(arg_2_3.isSel)
					arg_2_1:get("used"):visible(arg_2_3.isUse)
					arg_2_1:get("locked"):visible(arg_2_3.unlocked ~= var_0_2.UNLOCKED)
					arg_2_1:get("locked.lock"):visible(arg_2_3.unlocked ~= var_0_2.UNLOCKED and arg_2_3.unlocked ~= var_0_2.CAN_UNLOCK)

					arg_2_3.figureSprite = widget.addAnimationByKey(arg_2_1, "figure/touxiang.skel", "effect", var_0_6[1], 16):alignCenter(arg_2_1:size()):scale(0.55):hide()

					if arg_2_3.unlocked == var_0_2.CAN_UNLOCK then
						widget.addAnimation(arg_2_1, "figure/touxiang.skel", var_0_6[1], 15):alignCenter(arg_2_1:size()):scale(0.55)
					end

					if arg_2_3.isAuto then
						arg_2_3.figureSprite:show():play(var_0_6[2])

						arg_2_3.isAuto = false
					end

					bind.touch(arg_1_0, arg_2_1, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2, arg_2_2, arg_2_3)
						}
					})
				end
			}
		}

		bind.extend(arg_1_0, arg_1_1:get("list"), var_1_5)
	end
end

var_0_0.RESOURCE_FILENAME = "personal_figure.json"
var_0_0.RESOURCE_BINDING = {
	name = "figureName",
	costPanel = "costPanel",
	["descPanel.txt"] = "figureExplain",
	emptyPanel = "emptyPanel",
	specialTxt = "specialTxt",
	skillTitle = "skillTitle",
	skillCurrentTitle = "skillCurrentTitle",
	["addPanel.title1"] = "addPanelTitle1",
	["addPanel.itemAttr"] = "itemAttr",
	lockSkillPanel = "lockSkillPanel",
	item = "item",
	complete = "complete",
	skillDescPanel = "skillDescPanel",
	itemLogo = "figureSubItem",
	condition = "condition",
	addPanel = "addPanel",
	descPanel = "descPanel",
	["addPanel.list"] = "attrList",
	itemSkill = "itemSkill",
	conditionList = "conditionList",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	leftList = {
		varname = "figureList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("figureDatas"),
				item = bindHelper.self("item"),
				cloneItem = bindHelper.self("figureSubItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					var_0_7(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onClickItem")
			}
		}
	},
	pos = {
		binds = {
			event = "extend",
			class = "sort_menus",
			props = {
				btnWidth = 280,
				height = 80,
				btnHeight = 90,
				btnType = 2,
				width = 310,
				data = bindHelper.self("filterTabData"),
				btnClick = bindHelper.self("onSortMenusBtnClick", true),
				onNode = function(arg_4_0)
					arg_4_0:xy(-1120, -480):z(25)
				end
			}
		}
	},
	title = {
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
	title1 = {
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
	btnAdd = {
		varname = "btnAdd",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_5_0)
					return arg_5_0:onChangeClick(1)
				end)
			}
		}
	},
	btnDesc = {
		varname = "btnDesc",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_6_0)
					return arg_6_0:onChangeClick(2)
				end)
			}
		}
	},
	skillList = {
		varname = "skillList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("skillData"),
				item = bindHelper.self("itemSkill"),
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					local var_7_0 = arg_7_1:get("skillPanel")
					local var_7_1 = arg_7_3.state == var_0_3.UNLOCKED
					local var_7_2 = arg_7_3.state == var_0_3.CAN_UNLOCK
					local var_7_3 = arg_7_3.state == var_0_3.NOT_UNLOCK

					var_7_0:visible(arg_7_3.id ~= -1)
					arg_7_1:get("imgAdd"):visible(var_7_1 and arg_7_3.id == -1)
					arg_7_1:get("imgInfo"):visible(var_7_2)
					arg_7_1:get("imgSuo"):visible(var_7_3)
					arg_7_1:setTouchEnabled(not var_7_3)

					if arg_7_3.id ~= -1 then
						local var_7_4 = csv.skill[arg_7_3.id]

						var_7_0:get("imgSkill"):texture(var_7_4.iconRes)
					end

					if var_7_2 then
						local var_7_5 = widget.addAnimation(arg_7_1, "figure/touxiang.skel", var_0_6[1], 15):alignCenter(arg_7_1:size()):scale(0.55):play(var_0_6[1])
					end

					bind.touch(arg_7_0, arg_7_1, {
						methods = {
							ended = functools.partial(arg_7_0.btnClick, arg_7_2, arg_7_3)
						}
					})
				end,
				onAfterBuild = function(arg_8_0)
					arg_8_0.afterBuild()
				end
			},
			handlers = {
				afterBuild = bindHelper.self("onAfterBuild"),
				btnClick = bindHelper.self("onBtnClick")
			}
		}
	},
	["btnSave.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	btnSave = {
		varname = "btnSave",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("btnSaveClick")
			}
		}
	},
	figureIcon = {
		binds = {
			event = "extend",
			class = "role_figure",
			props = {
				spine = true,
				data = bindHelper.self("figureId"),
				onNode = function(arg_9_0)
					arg_9_0:scale(0.78)
				end,
				onSpine = function(arg_10_0)
					arg_10_0:scale(1.2):xy(388, -101)
				end
			}
		}
	},
	shade = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("btnClickClose")
			}
		}
	}
}

function var_0_0.onCreate(arg_11_0, arg_11_1)
	arg_11_0.attrList:setScrollBarEnabled(false)

	arg_11_0.skillCountLimit = gCommonConfigCsv.figureSkillLimit
	arg_11_0.unLockSkillLimit = {
		0,
		gCommonConfigCsv.figureSkill2,
		gCommonConfigCsv.figureSkill3
	}
	arg_11_0.unLockSkillCost = gCostCsv.figure_skill_unlock_cost
	arg_11_0.selItemInfo = arg_11_0.selItemInfo or {}

	arg_11_0:initModel()

	arg_11_0.skillData = idlers.new()
	arg_11_0.filterKey = idler.new(var_0_2.ALL)
	arg_11_0.figureId = idler.new()
	arg_11_0.selectData = idlertable.new({})
	arg_11_0.figureBaseDatas = idlertable.new()
	arg_11_0.figureDatas = idlers.new()

	local var_11_0 = {}

	for iter_11_0, iter_11_1 in pairs(var_0_1) do
		table.insert(var_11_0, iter_11_1.name)
	end

	arg_11_0.filterTabData = idlertable.new(var_11_0)

	idlereasy.any({
		arg_11_0.figures,
		arg_11_0.vipLevel,
		arg_11_0.roleLv,
		arg_11_0.figure,
		arg_11_0.gold,
		arg_11_0.rmb
	}, function(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
		arg_11_0:refreshFigureBaseIdlerData()
	end)
	idlereasy.any({
		arg_11_0.filterKey,
		arg_11_0.figureBaseDatas
	}, function(arg_13_0, arg_13_1, arg_13_2)
		if not arg_11_0.isActive then
			local var_13_0 = string.format(gLanguageCsv.withoutSomeFigure, arg_11_0.filterTabData:read()[arg_13_1])

			arg_11_0.emptyPanel:get("txt"):text(var_13_0)
			arg_11_0:refreshFigureIdlerData(arg_13_2)
		end
	end)
	arg_11_0.selectData:addListener(function(arg_14_0, arg_14_1)
		arg_11_0:btnClickClose()
		arg_11_0:setCostItemState(arg_14_0.id, arg_14_0.unlocked, arg_14_0.typ)
		arg_11_0:setBtnState(arg_14_0.unlocked)
		arg_11_0:setFigureBaseInfo(arg_14_0.id)
	end)
	idlereasy.any({
		arg_11_0.skillFigure,
		arg_11_0.skillCount
	}, function()
		local var_15_0 = arg_11_0.selectData:read()

		arg_11_0:setCostItemState(var_15_0.id, var_15_0.unlocked, var_15_0.typ)
	end)

	arg_11_0.showType = idler.new(1)

	idlereasy.when(arg_11_0.showType, function(arg_16_0, arg_16_1)
		local var_16_0 = var_0_4.FIGURE_ATTR == arg_16_1

		arg_11_0.addPanel:visible(var_16_0)
		arg_11_0.descPanel:visible(not var_16_0)
		arg_11_0.btnAdd:setBright(not var_16_0)
		arg_11_0.btnDesc:setBright(var_16_0)

		local var_16_1 = var_16_0 and arg_11_0.btnAdd:get("txt") or arg_11_0.btnDesc:get("txt")
		local var_16_2 = not var_16_0 and arg_11_0.btnAdd:get("txt") or arg_11_0.btnDesc:get("txt")

		text.addEffect(var_16_1, {
			outline = {
				size = 3,
				color = ui.NEWCOLORS.OUTLINE.BLACK
			}
		})
		text.deleteAllEffect(var_16_2)
		text.addEffect(var_16_2, {
			outline = {
				size = 3,
				color = ui.NEWCOLORS.OUTLINE.BLUE
			}
		})
	end)
	arg_11_0.addPanel:get("desc"):text(gLanguageCsv.personalDesc)
	Dialog.onCreate(arg_11_0)
end

function var_0_0.initModel(arg_17_0)
	arg_17_0.figure = gGameModel.role:getIdler("figure")
	arg_17_0.figures = gGameModel.role:getIdler("figures")
	arg_17_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_17_0.roleLv = gGameModel.role:getIdler("level")
	arg_17_0.gold = gGameModel.role:getIdler("gold")
	arg_17_0.rmb = gGameModel.role:getIdler("rmb")
	arg_17_0.gateStar = gGameModel.role:getIdler("gate_star")
	arg_17_0.fightingPoint = gGameModel.role:getIdler("battle_fighting_point")
	arg_17_0.pwRank = gGameModel.role:getIdler("pw_rank")
	arg_17_0.skillFigure = gGameModel.role:getIdler("skill_figures")
	arg_17_0.skillCount = gGameModel.role:getIdler("figure_skill_count")
	arg_17_0.pokedex = gGameModel.role:getIdler("pokedex")
end

function var_0_0.refreshFigureBaseIdlerData(arg_18_0)
	local var_18_0 = arg_18_0.figure:read()
	local var_18_1 = arg_18_0.figures:read()
	local var_18_2 = {}

	for iter_18_0, iter_18_1 in csvPairs(gRoleFigureCsv) do
		if iter_18_1.hide == 0 then
			local var_18_3 = {
				isSel = false,
				isUse = var_18_0 == iter_18_0,
				unlocked = var_0_2.NOT_UNLOCK,
				showIdx = iter_18_1.showIdx,
				typ = iter_18_1.type,
				id = iter_18_0
			}

			local function var_18_4()
				if csvNext(iter_18_1.unlock) then
					local var_19_0, var_19_1 = csvNext(iter_18_1.activeCost)
					local var_19_2, var_19_3 = csvNext(iter_18_1.unlock)

					if var_19_1 <= dataEasy.getNumByKey(var_19_0) and arg_18_0:getConditionLevel(var_19_2, var_19_3) then
						var_18_3.unlocked = var_0_2.CAN_UNLOCK
					end
				end
			end

			if var_18_1[iter_18_0] then
				var_18_3.unlocked = var_0_2.UNLOCKED
			else
				var_18_4()
			end

			table.insert(var_18_2, var_18_3)
		end
	end

	table.sort(var_18_2, function(arg_20_0, arg_20_1)
		if arg_20_0.unlocked ~= arg_20_1.unlocked then
			return arg_20_0.unlocked < arg_20_1.unlocked
		end

		if arg_20_0.showIdx ~= arg_20_1.showIdx then
			return arg_20_0.showIdx > arg_20_1.showIdx
		end

		return arg_20_0.id < arg_20_1.id
	end)
	arg_18_0.figureBaseDatas:set(var_18_2)
end

function var_0_0.refreshFigureIdlerData(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0.filterKey:read()
	local var_21_1 = {}

	for iter_21_0, iter_21_1 in ipairs(arg_21_1) do
		iter_21_1.isSel = false

		if var_21_1[iter_21_1.typ] == nil then
			var_21_1[iter_21_1.typ] = {}
		end

		if var_21_0 == 1 then
			table.insert(var_21_1[iter_21_1.typ], iter_21_1)
		elseif var_21_0 == iter_21_1.unlocked then
			table.insert(var_21_1[iter_21_1.typ], iter_21_1)
		end
	end

	local var_21_2 = arg_21_0:resetDataStruct(var_21_1)

	arg_21_0.emptyPanel:visible(#var_21_2 == 0)
	arg_21_0.figureDatas:update(var_21_2)
end

function var_0_0.resetDataStruct(arg_22_0, arg_22_1)
	local var_22_0 = {}
	local var_22_1 = 0
	local var_22_2 = 0
	local var_22_3 = 0
	local var_22_4
	local var_22_5 = arg_22_0.selectData:read()

	for iter_22_0, iter_22_1 in ipairs(arg_22_1) do
		if #iter_22_1 > 0 then
			table.insert(var_22_0, {
				{
					sign = "title",
					typ = iter_22_0
				}
			})
		end

		local var_22_6 = {}

		for iter_22_2, iter_22_3 in ipairs(iter_22_1) do
			if iter_22_2 % 3 == 1 then
				if iter_22_2 > 3 then
					table.insert(var_22_0, var_22_6)
				end

				var_22_6 = {}
			end

			table.insert(var_22_6, iter_22_3)

			local function var_22_7(arg_23_0)
				var_22_1 = arg_23_0
				var_22_4 = iter_22_3
				var_22_2 = #var_22_0 + 1
				var_22_3 = iter_22_2 % 3
			end

			if var_22_1 < 3 then
				if var_22_5.id and var_22_5.id == iter_22_3.id then
					var_22_7(3)
				end

				if var_22_1 < 2 then
					if iter_22_3.isUse then
						var_22_7(2)
					end

					if var_22_1 == 0 then
						var_22_7(1)
					end
				end
			end
		end

		if #var_22_6 > 0 then
			table.insert(var_22_0, var_22_6)

			local var_22_8 = {}
		end
	end

	if var_22_4 then
		if var_22_3 == 0 then
			var_22_3 = 3
		end

		arg_22_0.selItemInfo = {
			row = var_22_2,
			idx = var_22_3
		}
		var_22_0[var_22_2][var_22_3].isSel = true

		arg_22_0.selectData:set(var_22_4)
	end

	return var_22_0
end

function var_0_0.getConditionLevel(arg_24_0, arg_24_1, arg_24_2)
	if arg_24_1 == 1 then
		return arg_24_2 <= arg_24_0.roleLv:read()
	end

	if arg_24_1 == 2 then
		return (arg_24_0.gateStar:read()[arg_24_2] or 0) >= 1
	end

	if arg_24_1 == 5 then
		return arg_24_2 <= arg_24_0.vipLevel:read()
	end

	if arg_24_1 == 6 then
		return arg_24_2 <= arg_24_0.fightingPoint:read()
	end

	if arg_24_1 == 119 then
		return arg_24_0.pokedex:read()[arg_24_2] ~= nil
	end

	if arg_24_1 == 44 then
		return arg_24_2 <= arg_24_0.pwRank:read()
	end

	if arg_24_1 == 79 then
		return arg_24_2 <= gGameModel.role:read("trainer_level")
	end
end

function var_0_0.setFigureBaseInfo(arg_25_0, arg_25_1)
	local var_25_0 = gRoleFigureCsv[arg_25_1]

	arg_25_0.figureName:text(var_25_0.name)
	arg_25_0.figureId:set(arg_25_1)
	arg_25_0.descPanel:get("txt"):text(var_25_0.desc)

	local var_25_1 = {}
	local var_25_2 = 0

	for iter_25_0 = 1, 3 do
		local var_25_3 = var_25_0["attrNatureType" .. iter_25_0] + 1

		if not var_25_1[var_25_3] then
			var_25_1[var_25_3] = {}
		end

		local var_25_4 = var_25_0["attrType" .. iter_25_0]

		if var_25_4 ~= 0 then
			table.insert(var_25_1[var_25_3], {
				attrType = var_25_4,
				attrValue = var_25_0["attrValue" .. iter_25_0]
			})
		end
	end

	arg_25_0.attrList:removeAllChildren()
	arg_25_0.addPanelTitle1:text(gLanguageCsv.allTeamActiveText)

	for iter_25_1, iter_25_2 in pairs(var_25_1) do
		for iter_25_3, iter_25_4 in pairs(iter_25_2) do
			local var_25_5 = arg_25_0.itemAttr:clone():show()
			local var_25_6 = var_25_5:multiget("txt", "icon")

			if iter_25_1 ~= 1 or not gLanguageCsv.allSprite then
				local var_25_7 = string.format(gLanguageCsv.someSprite, gLanguageCsv[game.NATURE_TABLE[iter_25_1 - 1]])
			end

			local var_25_8 = ui.ATTR_LOGO[game.ATTRDEF_TABLE[iter_25_4.attrType]]
			local var_25_9 = getLanguageAttr(iter_25_4.attrType)

			var_25_6.icon:texture(var_25_8)
			var_25_6.txt:text(var_25_9 .. " +" .. dataEasy.getAttrValueString(iter_25_4.attrType, iter_25_4.attrValue))
			adapt.oneLinePos(var_25_6.icon, var_25_6.txt, cc.p(15, 0), "left")
			arg_25_0.attrList:pushBackCustomItem(var_25_5)
		end

		local var_25_10 = arg_25_0.attrList:y() + arg_25_0.attrList:height() - math.min(arg_25_0.attrList:height(), arg_25_0.attrList:getInnerItemSize().height) - 30

		arg_25_0.addPanel:get("desc"):y(var_25_10)
	end
end

function var_0_0.setViewHideOrShow(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_1 == var_0_2.UNLOCKED

	arg_26_0.skillCurrentTitle:visible(var_26_0)
	arg_26_0.skillList:visible(var_26_0)
	arg_26_0.conditionList:visible(var_26_0)
	arg_26_0.skillTitle:visible(not var_26_0 and arg_26_2 == 2)
	arg_26_0.lockSkillPanel:visible(not var_26_0 and arg_26_2 == 2)
	arg_26_0.condition:visible(not var_26_0)
	arg_26_0.complete:visible(arg_26_1 == var_0_2.CAN_UNLOCK)
end

function var_0_0.setCostItemState(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	arg_27_0:setViewHideOrShow(arg_27_2, arg_27_3)

	if arg_27_2 == var_0_2.UNLOCKED then
		local var_27_0 = {}
		local var_27_1 = gRoleFigureCsv[arg_27_1]
		local var_27_2 = arg_27_0.skillFigure:read()[arg_27_1]

		if var_27_2 then
			for iter_27_0, iter_27_1 in pairs(var_27_2) do
				local var_27_3 = gRoleFigureCsv[iter_27_1].skills[1]

				table.insert(var_27_0, {
					id = var_27_3,
					figureId = iter_27_1
				})
			end
		else
			local var_27_4 = var_27_1.skills[1]

			table.insert(var_27_0, {
				id = var_27_4,
				figureId = arg_27_1
			})
		end

		local var_27_5 = arg_27_0.skillCount:read()
		local var_27_6 = arg_27_0.figures:read()
		local var_27_7 = table.nums(var_27_6)

		for iter_27_2 = 1, arg_27_0.skillCountLimit do
			if var_27_0[iter_27_2] == nil then
				var_27_0[iter_27_2] = {}
			end

			local var_27_8 = var_27_0[iter_27_2]

			var_27_8.id = var_27_8.id or -1
			var_27_8.figureId = var_27_8.figureId or -1

			if iter_27_2 <= var_27_5 then
				var_27_8.state = var_0_3.UNLOCKED
			else
				if var_27_7 >= arg_27_0.unLockSkillLimit[iter_27_2] then
					var_27_8.state = var_0_3.CAN_UNLOCK

					break
				end

				var_27_8.state = var_0_3.NOT_UNLOCK

				break
			end
		end

		arg_27_0.skillData:update(var_27_0)
	else
		if arg_27_3 == 2 then
			arg_27_0:setLockSkillPanel(arg_27_1)
		end

		arg_27_0:showActiveState(arg_27_1, arg_27_2)
	end

	arg_27_0:setSkillTip()
end

function var_0_0.setLockSkillPanel(arg_28_0, arg_28_1)
	local var_28_0 = gRoleFigureCsv[arg_28_1].skills[1]
	local var_28_1 = csv.skill[var_28_0]

	arg_28_0.lockSkillPanel:get("icon"):texture(var_28_1.iconRes)
	arg_28_0.lockSkillPanel:get("name"):text(var_28_1.skillName)
	beauty.textScroll({
		isRich = true,
		list = arg_28_0.lockSkillPanel:get("descList"),
		strs = "#C0x5B545B#" .. var_28_1.describe
	})
end

function var_0_0.showActiveState(arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = gRoleFigureCsv[arg_29_1]

	arg_29_0.condition:text(var_29_0.unlockDesc)
	text.addEffect(arg_29_0.condition, {
		color = arg_29_2 == var_0_2.CAN_UNLOCK and ui.NEWCOLORS.GREENLIGHT or ui.NEWCOLORS.RED
	})
	adapt.oneLinePos(arg_29_0.condition, arg_29_0.complete, cc.p(10, 0))

	local var_29_1 = var_29_0.activeCost

	if var_29_1 then
		arg_29_0.specialTxt:hide()
		arg_29_0.costPanel:show()
		arg_29_0.btnSave:show()
	else
		arg_29_0.specialTxt:show()
		arg_29_0.costPanel:hide()
		arg_29_0.btnSave:hide()

		return
	end

	local var_29_2, var_29_3 = csvNext(var_29_1)
	local var_29_4 = arg_29_0.costPanel:multiget("item", "icon", "txt", "title")
	local var_29_5 = arg_29_0.costPanel:get("item")

	if var_29_2 == "rmb" or var_29_2 == "gold" then
		var_29_4.title:show()
		var_29_5:hide()

		local var_29_6 = string.format("common/icon/icon_%s.png", var_29_2 == "rmb" and "diamond" or "gold")

		arg_29_0.costPanel:get("icon"):texture(var_29_6):show()
		arg_29_0.costPanel:get("txt"):text(var_29_3):show()
		adapt.oneLinePos(var_29_4.icon, var_29_4.txt, cc.p(10, 0), "right")
		adapt.oneLinePos(var_29_4.txt, var_29_4.title, cc.p(0, 0), "right")
	else
		var_29_4.title:hide()
		var_29_5:show()
		arg_29_0.costPanel:get("icon"):hide()
		arg_29_0.costPanel:get("txt"):hide()

		local var_29_7 = arg_29_0.costPanel:size()
		local var_29_8 = dataEasy.getNumByKey(var_29_2)

		bind.extend(arg_29_0, var_29_5, {
			class = "icon_key",
			props = {
				data = {
					key = var_29_2,
					num = var_29_8,
					targetNum = var_29_3
				},
				grayState = var_29_3 <= var_29_8 and 0 or 1,
				onNode = function(arg_30_0)
					arg_30_0:scale(0.9)
				end
			}
		})
	end

	local var_29_9 = var_29_3 <= dataEasy.getNumByKey(var_29_2) and ui.NEWCOLORS.BROWN1 or ui.COLORS.NORMAL.RED

	text.addEffect(arg_29_0.costPanel:get("txt"), {
		color = var_29_9
	})
end

function var_0_0.setBtnState(arg_31_0, arg_31_1)
	local var_31_0 = gLanguageCsv.spaceActive

	if arg_31_1 == var_0_2.UNLOCKED then
		arg_31_0.btnSave:show()
		arg_31_0.specialTxt:hide()
		arg_31_0.costPanel:hide()

		var_31_0 = gLanguageCsv.spaceUse
	end

	arg_31_0.btnSave:setTouchEnabled(arg_31_1 ~= var_0_2.NOT_UNLOCK)
	cache.setShader(arg_31_0.btnSave, false, arg_31_1 ~= var_0_2.NOT_UNLOCK and "normal" or "hsl_gray")

	if arg_31_1 == var_0_2.NOT_UNLOCK then
		text.deleteAllEffect(arg_31_0.btnSave:get("txt"))
	else
		text.addEffect(arg_31_0.btnSave:get("txt"), {
			outline = {
				size = 4,
				color = ui.NEWCOLORS.OUTLINE.YELLOW
			}
		})
	end

	arg_31_0.btnSave:get("txt"):text(var_31_0)
end

function var_0_0.setSkillTip(arg_32_0)
	local var_32_0 = arg_32_0.skillCount:read()
	local var_32_1 = arg_32_0.figures:read()
	local var_32_2 = table.nums(var_32_1)
	local var_32_3 = ""

	if var_32_0 < arg_32_0.skillCountLimit then
		if var_32_2 < arg_32_0.unLockSkillLimit[var_32_0 + 1] then
			var_32_3 = string.format(gLanguageCsv.unlockSkillLimitTip, arg_32_0.unLockSkillLimit[var_32_0 + 1])
		else
			var_32_3 = string.format(gLanguageCsv.unlockSkillCostTip, arg_32_0.unLockSkillCost[var_32_0])
		end
	end

	beauty.textScroll({
		isRich = true,
		align = "left",
		list = arg_32_0.conditionList,
		strs = {
			var_32_3,
			gLanguageCsv.sureChangeSkillTip
		}
	})
end

function var_0_0.onChangeClick(arg_33_0, arg_33_1)
	arg_33_0.showType:set(arg_33_1)
end

function var_0_0.btnClickClose(arg_34_0)
	if arg_34_0.showSkillDesc then
		arg_34_0.skillDescPanel:visible(false)

		arg_34_0.showSkillDesc = false
	end
end

function var_0_0.btnSaveClick(arg_35_0)
	local var_35_0 = arg_35_0.selectData:read()

	if var_35_0.unlocked == var_0_2.UNLOCKED then
		if arg_35_0.figure:read() ~= var_35_0.id then
			gGameApp:requestServer("/game/role/figure", function()
				arg_35_0:onClose()
			end, var_35_0.id)
		end
	else
		if arg_35_0.isActive then
			return
		end

		local function var_35_1()
			arg_35_0.isActive = true

			arg_35_0.btnSave:setTouchEnabled(false)

			local var_37_0 = {
				false
			}

			gGameApp:requestServerCustom("/game/role/figure_active"):params(var_35_0.id):onResponse(function(arg_38_0)
				gGameUI:showTip(gLanguageCsv.activeSuccess)

				local var_38_0 = var_35_0.figureSprite

				var_38_0:show()
				var_38_0:play(var_0_6[3])
				var_38_0:setSpriteEventHandler(function(arg_39_0, arg_39_1)
					var_38_0:setSpriteEventHandler()
					performWithDelay(arg_35_0, function()
						arg_35_0.isActive = false
						var_37_0[1] = true
					end, 0.01)
				end, sp.EventType.ANIMATION_COMPLETE)
			end):wait(var_37_0):doit(function(arg_41_0)
				arg_35_0:setBtnState(var_0_2.UNLOCKED)
				arg_35_0.btnSave:setTouchEnabled(true)
				arg_35_0.filterKey:set(arg_35_0.filterKey:read(), true)
			end)
		end

		local var_35_2 = gRoleFigureCsv[var_35_0.id]
		local var_35_3 = gGameModel.role:read("cards")
		local var_35_4 = false

		for iter_35_0, iter_35_1 in pairs(var_35_2.unlock) do
			for iter_35_2, iter_35_3 in ipairs(var_35_3) do
				if iter_35_1 == gGameModel.cards:find(iter_35_3):read("card_id") then
					var_35_4 = true

					break
				end
			end
		end

		if var_35_4 then
			if var_35_2.activeCost then
				local var_35_5, var_35_6 = csvNext(var_35_2.activeCost)

				if var_35_5 == "rmb" then
					dataEasy.sureUsingDiamonds(var_35_1, var_35_6)
				else
					var_35_1()
				end
			else
				var_35_1()
			end
		else
			gGameUI:showTip(gLanguageCsv.figureAlreadyDecompose)
		end
	end
end

function var_0_0.onSortMenusBtnClick(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
	dataEasy.tryCallFunc(arg_42_0.figureList, "setItemAction", {
		isAction = true,
		alwaysShow = true
	})
	arg_42_0.filterKey:set(arg_42_3)
	dataEasy.tryCallFunc(arg_42_0.figureList, "setItemAction", {
		isAction = false
	})
end

function var_0_0.onAfterBuild(arg_43_0)
	local var_43_0

	var_43_0 = arg_43_0.skillData:size() == 0
end

function var_0_0.onBtnClick(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	local var_44_0 = arg_44_3.state == var_0_3.UNLOCKED

	if arg_44_3.state == var_0_3.CAN_UNLOCK then
		local var_44_1 = arg_44_0.skillCount:read()
		local var_44_2 = arg_44_0.unLockSkillCost[var_44_1]

		gGameUI:showDialog({
			isRich = true,
			btnType = 2,
			strs = {
				string.format(gLanguageCsv.sureBuyFigureSkillTip, var_44_2),
				gLanguageCsv.sureChangeSkillTip2
			},
			cb = function()
				gGameApp:requestServer("/game/role/figure/skill/unlock", function(arg_46_0)
					return
				end, var_44_1)
			end,
			dialogParams = {
				clickClose = false
			}
		})
	end

	if var_44_0 then
		local var_44_3 = arg_44_0.selectData:read()

		gGameUI:stackUI("city.personal.skill_choose", nil, {
			clickClose = true
		}, var_44_3.id, arg_44_3.figureId, arg_44_2)
	end
end

function var_0_0.onClickItem(arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
	arg_47_0.figureDatas:atproxy(arg_47_0.selItemInfo.row)[arg_47_0.selItemInfo.idx].isSel = false
	arg_47_0.selItemInfo = {
		row = arg_47_2,
		idx = arg_47_3
	}
	arg_47_0.figureDatas:atproxy(arg_47_2)[arg_47_3].isSel = true
	arg_47_0.figureDatas:atproxy(arg_47_2)[arg_47_3].isAuto = true

	arg_47_0.selectData:set(arg_47_4)
end

return var_0_0
