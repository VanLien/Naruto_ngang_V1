local var_0_0 = require("app.views.city.adventure.dispatch_task.tools")

local function var_0_1(arg_1_0, arg_1_1)
	if next(arg_1_0) == nil then
		return {}
	end

	if arg_1_1 == nil or arg_1_1[2] == nil then
		return arg_1_0
	end

	local function var_1_0(arg_2_0, arg_2_1, arg_2_2)
		if arg_2_0[arg_2_1] == nil and (arg_2_1 ~= "attr2" or arg_2_0.attr1 == arg_2_2) then
			return true
		end

		if arg_2_1 == "atkType" then
			for iter_2_0, iter_2_1 in ipairs(arg_2_0.atkType) do
				if arg_2_2[iter_2_1] then
					return true
				end
			end

			return false
		end

		if arg_2_0[arg_2_1] == arg_2_2 then
			return true
		end

		return false
	end

	local var_1_1 = {}

	for iter_1_0, iter_1_1 in pairs(arg_1_0) do
		if var_1_0(iter_1_1, arg_1_1[1], arg_1_1[2]) then
			var_1_1[iter_1_0] = iter_1_1
		end
	end

	return var_1_1
end

local function var_0_2(arg_3_0, arg_3_1, arg_3_2)
	for iter_3_0 = 1, arg_3_0 do
		local var_3_0 = arg_3_1:atproxy(iter_3_0)

		if not arg_3_2.selectState then
			if arg_3_2.dbid == var_3_0.dbid then
				var_3_0.selectState = false

				return iter_3_0
			end
		else
			if arg_3_2.dbid ~= var_3_0.dbid and not var_3_0.selectState then
				var_3_0.selectState = true
				var_3_0.id = arg_3_2.id
				var_3_0.unitId = arg_3_2.unitId
				var_3_0.rarity = arg_3_2.rarity
				var_3_0.attr1 = arg_3_2.attr1
				var_3_0.attr2 = arg_3_2.attr2
				var_3_0.level = arg_3_2.level
				var_3_0.star = arg_3_2.star
				var_3_0.advance = arg_3_2.advance
				var_3_0.fight = arg_3_2.fight
				var_3_0.dbid = arg_3_2.dbid

				return iter_3_0
			end

			if arg_3_2.dbid == var_3_0.dbid and not var_3_0.selectState then
				var_3_0.selectState = true

				return iter_3_0
			end
		end
	end

	return 1
end

local function var_0_3(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0

	for iter_4_0 = 1, #arg_4_1 do
		var_4_0 = var_0_1(var_4_0, arg_4_1[iter_4_0])
	end

	return var_4_0
end

local var_0_4 = {
	{
		name = "star",
		note = gLanguageCsv.manyStars
	},
	{
		name = "advance",
		note = gLanguageCsv.manyClasses
	},
	{
		name = "rarity",
		note = gLanguageCsv.manyQualifications
	}
}

local function var_0_5(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = 0

	if not arg_5_3 then
		if arg_5_2.selectState then
			var_5_0 = 1
		elseif arg_5_2.status ~= 0 then
			var_5_0 = 2
		end
	end

	bind.extend(arg_5_0, arg_5_1, {
		class = "card_icon",
		props = {
			unitId = arg_5_2.unitId,
			advance = arg_5_2.advance,
			rarity = arg_5_2.rarity,
			star = arg_5_2.star,
			grayState = var_5_0,
			levelProps = {
				data = arg_5_2.level
			},
			onNode = function(arg_6_0)
				if arg_5_3 then
					arg_6_0:visible(arg_5_2.selectState == true)
				end
			end
		}
	})
end

local function var_0_6(arg_7_0, arg_7_1)
	local var_7_0 = {}

	for iter_7_0, iter_7_1 in ipairs(arg_7_0) do
		for iter_7_2, iter_7_3 in pairs(iter_7_1.cardIDs or {}) do
			if iter_7_1.status == 1 then
				var_7_0[iter_7_3] = 2
			end

			if iter_7_1.status == 3 then
				var_7_0[iter_7_3] = 1
			end
		end
	end

	for iter_7_4, iter_7_5 in ipairs(arg_7_1) do
		if not var_7_0[iter_7_5] then
			var_7_0[iter_7_5] = 2
		end
	end

	return var_7_0
end

local var_0_7 = class("DispatchTaskSpriteSelectView", cc.load("mvc").ViewBase)

var_0_7.RESOURCE_FILENAME = "dispatch_task_sprite_select.json"
var_0_7.RESOURCE_BINDING = {
	subList = "subList",
	item = "item",
	empty = "empty",
	filter = "filter",
	attrItem = "attrItem",
	rightPanel = "rightPanel",
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 25,
				columnSize = 5,
				data = bindHelper.self("cardDatas"),
				dataOrderCmpGen = bindHelper.self("onSortCards", true),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				empty = bindHelper.self("empty"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					var_0_5(arg_8_0, arg_8_1, arg_8_3)
					arg_8_1:get("icon"):visible(arg_8_3.weight > 0)

					local var_8_0 = arg_8_3.status == 2 and gLanguageCsv.restIn or gLanguageCsv.InDispatch

					if arg_8_3.selectState or arg_8_3.status == 0 then
						var_8_0 = gLanguageCsv.inTheTeam
					end

					arg_8_1:get("mask.imgMask"):hide()

					local var_8_1 = arg_8_1:get("mask.textNote")

					var_8_1:text(var_8_0)
					uiEasy.addTextEffect1(var_8_1)
					arg_8_1:get("mask"):visible(arg_8_3.selectState or arg_8_3.status ~= 0)
					arg_8_1:setTouchEnabled(arg_8_3.status == 0)
					bind.touch(arg_8_0, arg_8_1, {
						methods = {
							ended = functools.partial(arg_8_0.itemClick, arg_8_0:getIdx(arg_8_2), arg_8_3)
						}
					})
				end,
				onBeforeBuild = function(arg_9_0)
					arg_9_0.empty:visible(itertools.size(arg_9_0.data) == 0)
				end
			},
			handlers = {
				itemClick = bindHelper.self("onCardItemClick")
			}
		}
	},
	btnSort = {
		varname = "btnSort",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnSortClick")
			}
		}
	},
	["btnSort.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["rightPanel.cardPanel.list"] = {
		varname = "taskCardList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("taskCardDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
					var_0_5(arg_10_0, arg_10_1, arg_10_3, true)
					bind.touch(arg_10_0, arg_10_1, {
						methods = {
							ended = functools.partial(arg_10_0.itemClick, arg_10_2, arg_10_3)
						}
					})
					arg_10_1:get("mask"):visible(false)
					arg_10_1:get("icon"):visible(false)
				end
			},
			handlers = {
				itemClick = bindHelper.self("onTaskItemClick")
			}
		}
	},
	["rightPanel.cardPanel.btnOneKey"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onOneKeyClick")
			}
		}
	},
	["rightPanel.btnStart"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnStart")
			}
		}
	},
	["rightPanel.btnStart.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_7.onCreate(arg_11_0, arg_11_1)
	arg_11_0:initModel()

	arg_11_0.taskData = arg_11_1

	arg_11_0.rightPanel:get("attrList"):setScrollBarEnabled(false)
	gGameUI.topuiManager:createView("default", arg_11_0, {
		onClose = arg_11_0:createHandler("onClose")
	}):init({
		subTitle = "SEND",
		title = "common/txt/txt_bt_paiqian.png"
	})

	arg_11_0.filterCondition = idlertable.new()

	local var_11_0 = arg_11_0.filter:parent():convertToWorldSpace(arg_11_0.filter:box())
	local var_11_1 = arg_11_0:convertToNodeSpace(var_11_0)

	gGameUI:createView("city.card.bag_filter", arg_11_0.filter):init({
		cb = arg_11_0:createHandler("onBattleFilter"),
		others = {
			panelOrder = true,
			height = 122,
			panelOffsetX = 300,
			panelOffsetY = 5,
			width = 270,
			x = gGameUI:getConvertPos(arg_11_0.filter, arg_11_0:getResourceNode())
		}
	}):xy(-var_11_1.x, -var_11_1.y)
	arg_11_0.filter:z(15)

	arg_11_0.cardNatures = {}

	local var_11_2 = csv.dispatch_task.tasks[arg_11_1.csvID]

	for iter_11_0, iter_11_1 in pairs(var_11_2.cardNatures) do
		arg_11_0.cardNatures[iter_11_1] = 1
	end

	local var_11_3, var_11_4 = csvNext(var_11_2.condition1Arg)

	arg_11_0.condition1 = {
		typ = var_11_2.condition1,
		level = var_11_3,
		num = var_11_4,
		typStr = var_0_4[var_11_2.condition1]
	}
	arg_11_0.cardStateData = {}
	arg_11_0.cardInfos = idlertable.new({})
	arg_11_0.cardInfosOrder = {}

	idlereasy.any({
		arg_11_0.cards,
		arg_11_0.dispatchTasks,
		arg_11_0.dispatchCardIDs
	}, function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
		local var_12_0 = var_0_6(arg_12_2, arg_12_3)
		local var_12_1 = {}

		for iter_12_0, iter_12_1 in pairs(arg_12_1) do
			local var_12_2 = gGameModel.cards:find(iter_12_1):read("card_id", "skin_id", "name", "fighting_point", "level", "star", "advance")
			local var_12_3 = csv.cards[var_12_2.card_id]
			local var_12_4 = csv.unit[var_12_3.unitID]
			local var_12_5 = dataEasy.getUnitId(var_12_2.card_id, var_12_2.skin_id)
			local var_12_6 = {
				selectState = false,
				id = var_12_2.card_id,
				unitId = var_12_5,
				rarity = var_12_4.rarity,
				attr1 = var_12_4.natureType,
				attr2 = var_12_4.natureType2,
				level = var_12_2.level,
				star = var_12_2.star,
				advance = var_12_2.advance,
				fight = var_12_2.fighting_point,
				dbid = iter_12_1,
				status = var_12_0[iter_12_1] or 0,
				atkType = var_12_3.atkType
			}
			local var_12_7 = 0

			if arg_11_0.cardNatures[var_12_6.attr1] == 1 then
				var_12_7 = 1
			end

			if var_12_6.attr2 and arg_11_0.cardNatures[var_12_6.attr2] == 1 then
				var_12_7 = 1
			end

			var_12_6.weight = var_12_7

			table.insert(arg_11_0.cardInfosOrder, var_12_6)

			var_12_1[iter_12_1] = var_12_6
		end

		table.sort(arg_11_0.cardInfosOrder, function(arg_13_0, arg_13_1)
			return arg_13_0.fight > arg_13_1.fight
		end)
		arg_11_0.cardInfos:set(var_12_1)
	end)

	arg_11_0.cardDatas = idlers.new()
	arg_11_0.sortOrder = idler.new(true)

	idlereasy.any({
		arg_11_0.filterCondition,
		arg_11_0.sortOrder,
		arg_11_0.cardInfos
	}, function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
		local var_14_0 = {
			{
				"rarity",
				arg_14_1.rarity < ui.RARITY_LAST_VAL and arg_14_1.rarity or nil
			},
			{
				"attr2",
				arg_14_1.attr2 < ui.ATTR_MAX and arg_14_1.attr2 or nil
			},
			{
				"attr1",
				arg_14_1.attr1 < ui.ATTR_MAX and arg_14_1.attr1 or nil
			},
			{
				"atkType",
				arg_14_1.atkType
			}
		}
		local var_14_1 = var_0_3(clone(arg_14_3), var_14_0)

		arg_11_0.btnSort:get("icon"):scaleY(arg_14_2 and -1.6 or 1.6)

		for iter_14_0, iter_14_1 in pairs(var_14_1) do
			iter_14_1.selectState = arg_11_0.cardStateData[iter_14_1.dbid] and true or false
		end

		arg_11_0.cardDatas:update(var_14_1)
	end)

	arg_11_0.taskCardDatas = idlers.new()

	local var_11_5 = {}

	for iter_11_2 = 1, var_11_2.cardNums do
		var_11_5[iter_11_2] = {}
	end

	arg_11_0.taskCardDatas:update(var_11_5)

	arg_11_0.selectIdx = idler.new(0)
	arg_11_0.attrDatas = idlers.new()

	arg_11_0:setRightPanel(var_11_2)
	idlereasy.when(arg_11_0.selectIdx, function(arg_15_0, arg_15_1)
		local var_15_0 = arg_11_0.cardDatas:atproxy(arg_15_1)

		if var_15_0 then
			var_15_0.selectState = not clone(var_15_0.selectState)
			arg_11_0.cardStateData[var_15_0.dbid] = clone(var_15_0.selectState)

			local var_15_1 = var_0_2(var_11_2.cardNums, arg_11_0.taskCardDatas, clone(var_15_0))

			arg_11_0.taskCardList:jumpToItem(var_15_1, cc.p(1, 0), cc.p(1, 0))
		end

		arg_11_0:setRightPanel(var_11_2)
	end)
	var_0_0.setRewardPanel(arg_11_0, arg_11_0.rightPanel, var_11_2.award, "icon")
	var_0_0.setRewardPanel(arg_11_0, arg_11_0.rightPanel, var_11_2.extraAward, "extraIcon")
end

function var_0_7.initModel(arg_16_0)
	arg_16_0.cards = gGameModel.role:getIdler("cards")
	arg_16_0.dispatchTasks = gGameModel.role:getIdler("dispatch_tasks")
	arg_16_0.dispatchCardIDs = gGameModel.daily_record:getIdler("dispatch_cardIDs")
end

function var_0_7.setRightPanel(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0.rightPanel:multiget("title", "taskDesc", "condition1", "condition2", "extraCondition1", "extraCondition2", "gainChance", "btnReward", "btnComplete", "attrList")

	var_17_0.title:text(arg_17_1.name)
	var_17_0.taskDesc:text(arg_17_1.desc)

	local var_17_1 = 0
	local var_17_2 = 0
	local var_17_3 = {}
	local var_17_4 = 0

	for iter_17_0, iter_17_1 in arg_17_0.taskCardDatas:ipairs() do
		local var_17_5 = iter_17_1:proxy()

		if var_17_5.selectState then
			var_17_1 = var_17_1 + 1
			var_17_2 = var_17_2 + var_17_5.fight

			table.insert(var_17_3, var_17_5.dbid)
		end
	end

	local var_17_6 = clone(arg_17_0.taskData)

	var_17_6.cardIDs = var_17_3
	var_17_6.status = 1

	var_0_0.setItemCondition(arg_17_0.rightPanel, var_17_6, arg_17_0.attrItem)

	arg_17_0.fightEnough = var_17_2 >= arg_17_0.taskData.fightingPoint
	arg_17_0.numberEnough = var_17_1 >= arg_17_1.cardNums

	adapt.oneLinePos(var_17_0.extraCondition2, var_17_0.attrList, cc.p(5, 0))
end

function var_0_7.onCardItemClick(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = 0

	for iter_18_0, iter_18_1 in arg_18_0.taskCardDatas:ipairs() do
		if not iter_18_1:proxy().selectState then
			break
		end

		var_18_0 = var_18_0 + 1

		if var_18_0 == arg_18_0.taskCardDatas:size() and not arg_18_3.selectState then
			return
		end
	end

	arg_18_0.selectIdx:set(arg_18_3.dbid, true)
end

function var_0_7.onOneKeyClick(arg_19_0)
	local var_19_0 = {}
	local var_19_1 = arg_19_0.taskData.cfg

	for iter_19_0, iter_19_1 in pairs(var_19_1.cardNatures) do
		var_19_0[iter_19_1] = {
			state = false,
			attr = iter_19_1
		}
	end

	local var_19_2 = {}
	local var_19_3 = 0

	for iter_19_2, iter_19_3 in ipairs(arg_19_0.cardInfosOrder) do
		if itertools.size(var_19_2) >= var_19_1.cardNums then
			break
		end

		if var_19_0[iter_19_3.attr1] and not var_19_0[iter_19_3.attr1].state and iter_19_3.status == 0 then
			var_19_0[iter_19_3.attr1].state = true
			var_19_2[iter_19_3.dbid] = iter_19_3
		end

		if iter_19_3.attr2 and var_19_0[iter_19_3.attr2] and not var_19_0[iter_19_3.attr2].state and iter_19_3.status == 0 then
			var_19_0[iter_19_3.attr2].state = true
			var_19_2[iter_19_3.dbid] = iter_19_3
		end
	end

	for iter_19_4, iter_19_5 in ipairs(arg_19_0.cardInfosOrder) do
		if itertools.size(var_19_2) >= var_19_1.cardNums then
			break
		end

		local var_19_4, var_19_5 = csvNext(var_19_1.condition1Arg)

		if var_19_4 <= iter_19_5[var_0_4[var_19_1.condition1].name] and var_19_3 < var_19_5 and iter_19_5.status == 0 then
			var_19_2[iter_19_5.dbid] = iter_19_5
			var_19_3 = var_19_3 + 1
		end
	end

	for iter_19_6, iter_19_7 in ipairs(arg_19_0.cardInfosOrder) do
		if itertools.size(var_19_2) >= var_19_1.cardNums then
			break
		end

		if not var_19_2[iter_19_7.dbid] and iter_19_7.status == 0 then
			var_19_2[iter_19_7.dbid] = iter_19_7
		end
	end

	if itertools.size(var_19_2) < var_19_1.cardNums then
		gGameUI:showTip(gLanguageCsv.numberNotEnough)

		return
	end

	local var_19_6 = {}

	for iter_19_8, iter_19_9 in pairs(var_19_2) do
		iter_19_9.selectState = true

		table.insert(var_19_6, iter_19_9)
	end

	local var_19_7 = true

	for iter_19_10, iter_19_11 in ipairs(var_19_6) do
		local var_19_8 = arg_19_0.taskCardDatas:atproxy(iter_19_10)

		if iter_19_11.dbid ~= var_19_8.dbid or iter_19_11.selectState ~= var_19_8.selectState then
			var_19_7 = false
		end
	end

	if var_19_7 then
		return
	end

	arg_19_0.cardStateData = var_19_2

	arg_19_0.taskCardDatas:update(clone(var_19_6))
	arg_19_0:setRightPanel(var_19_1)
	arg_19_0.sortOrder:set(arg_19_0.sortOrder:read(), true)
end

function var_0_7.onTaskItemClick(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	if not arg_20_3.selectState then
		return
	end

	arg_20_0.taskCardDatas:atproxy(arg_20_2).selectState = false

	arg_20_0.selectIdx:set(arg_20_3.dbid, true)

	arg_20_0.cardStateData[arg_20_3.dbid] = false
end

function var_0_7.onBtnStart(arg_21_0)
	local var_21_0 = arg_21_0.taskData
	local var_21_1 = arg_21_0.dispatchTasks:read()[var_21_0.dbid]

	if not var_21_1 or var_21_0.csvID ~= var_21_1.csvID or var_21_1.status ~= 2 then
		gGameUI:showTip(gLanguageCsv.currentTaskChanged)

		return
	end

	if not arg_21_0.numberEnough then
		gGameUI:showTip(gLanguageCsv.numberNotEnough)

		return
	end

	if not arg_21_0.fightEnough then
		gGameUI:showTip(gLanguageCsv.fightNotEnough)

		return
	end

	local var_21_2 = {}

	for iter_21_0, iter_21_1 in arg_21_0.taskCardDatas:ipairs() do
		local var_21_3 = iter_21_1:proxy()

		if var_21_3.selectState then
			table.insert(var_21_2, var_21_3.dbid)
		end
	end

	gGameApp:requestServer("/game/dispatch/task/begin", function(arg_22_0)
		arg_21_0:onClose()
	end, var_21_2, arg_21_0.taskData.dbid)
end

function var_0_7.onBattleFilter(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	arg_23_0.filterCondition:set({
		attr1 = arg_23_1,
		attr2 = arg_23_2,
		rarity = arg_23_3,
		atkType = arg_23_4
	}, true)
end

function var_0_7.onBtnSortClick(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	arg_24_0.sortOrder:modify(function(arg_25_0)
		return true, not arg_25_0
	end)
end

function var_0_7.onSortCards(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0.sortOrder:read()

	return function(arg_27_0, arg_27_1)
		if arg_27_0.status ~= arg_27_1.status then
			return arg_27_0.status < arg_27_1.status
		end

		if var_26_0 then
			return arg_27_0.fight > arg_27_1.fight
		else
			return arg_27_0.fight < arg_27_1.fight
		end
	end
end

return var_0_7
