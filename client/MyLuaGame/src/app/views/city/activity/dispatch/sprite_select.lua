local var_0_0 = class("ActiviytDispatchSpriteSelect", Dialog)

local function var_0_1(arg_1_0)
	local var_1_0 = {}

	for iter_1_0, iter_1_1 in pairs(arg_1_0) do
		for iter_1_2, iter_1_3 in pairs(iter_1_1.cards or {}) do
			if iter_1_1.status == 1 then
				var_1_0[iter_1_3.id] = 1
			end

			if iter_1_1.status == 2 then
				var_1_0[iter_1_3.id] = 2
			end
		end
	end

	return var_1_0
end

local function var_0_2(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = 0

	if not arg_2_3 then
		if arg_2_2.selectState then
			var_2_0 = 1
		elseif arg_2_2.status ~= 0 then
			var_2_0 = 2
		end
	end

	bind.extend(arg_2_0, arg_2_1, {
		class = "card_icon",
		props = {
			unitId = arg_2_2.unitId,
			advance = arg_2_2.advance,
			rarity = arg_2_2.rarity,
			star = arg_2_2.star,
			grayState = var_2_0,
			levelProps = {
				data = arg_2_2.level
			},
			onNode = function(arg_3_0)
				if arg_2_3 then
					arg_3_0:visible(arg_2_2.selectState == true)
				end
			end
		}
	})
end

local function var_0_3(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = 0 + arg_4_1(arg_4_2:atproxy(1))

	for iter_4_0 = 1, 3 do
		var_4_0 = var_4_0 + arg_4_1(arg_4_3:atproxy(iter_4_0))
	end

	return var_4_0 >= arg_4_0[1], var_4_0
end

local var_0_4 = {
	function(arg_5_0, arg_5_1, arg_5_2)
		local function var_5_0(arg_6_0)
			if arg_6_0.selectState then
				return 1
			end

			return 0
		end

		return var_0_3(arg_5_0, var_5_0, arg_5_1, arg_5_2)
	end,
	function(arg_7_0, arg_7_1, arg_7_2)
		local function var_7_0(arg_8_0)
			if arg_8_0.selectState and (arg_8_0.attr1 == arg_7_0[1] or arg_8_0.attr2 == arg_7_0[1]) then
				return 1
			end

			return 0
		end

		return var_0_3(arg_7_0, var_7_0, arg_7_1, arg_7_2)
	end,
	function(arg_9_0, arg_9_1, arg_9_2)
		if arg_9_1:atproxy(1).selectState then
			local var_9_0 = arg_9_1:atproxy(1).id

			return csv.cards[var_9_0].cardMarkID == arg_9_0[1]
		end

		return false
	end,
	function(arg_10_0, arg_10_1, arg_10_2)
		local function var_10_0(arg_11_0)
			if arg_11_0.selectState then
				local var_11_0 = arg_11_0.gender

				for iter_11_0 = 1, itertools.size(arg_10_0) - 1 do
					if var_11_0 == arg_10_0[iter_11_0] then
						return 1
					end
				end
			end

			return 0
		end

		return var_0_3(arg_10_0, var_10_0, arg_10_1, arg_10_2)
	end,
	function(arg_12_0, arg_12_1, arg_12_2)
		local function var_12_0(arg_13_0)
			if arg_13_0.selectState and (gHandbookCsv[arg_13_0.id].heightAndWeight[1] or 0) >= arg_12_0[1] then
				return 1
			end

			return 0
		end

		return var_0_3(arg_12_0, var_12_0, arg_12_1, arg_12_2)
	end,
	function(arg_14_0, arg_14_1, arg_14_2)
		local function var_14_0(arg_15_0)
			if arg_15_0.selectState and (gHandbookCsv[arg_15_0.id].heightAndWeight[1] or 0) <= arg_14_0[1] then
				return 1
			end

			return 0
		end

		return var_0_3(arg_14_0, var_14_0, arg_14_1, arg_14_2)
	end,
	function(arg_16_0, arg_16_1, arg_16_2)
		local function var_16_0(arg_17_0)
			if arg_17_0.selectState and (gHandbookCsv[arg_17_0.id].heightAndWeight[2] or 0) >= arg_16_0[1] then
				return 1
			end

			return 0
		end

		return var_0_3(arg_16_0, var_16_0, arg_16_1, arg_16_2)
	end,
	function(arg_18_0, arg_18_1, arg_18_2)
		local function var_18_0(arg_19_0)
			if arg_19_0.selectState and (gHandbookCsv[arg_19_0.id].heightAndWeight[2] or 0) <= arg_18_0[1] then
				return 1
			end

			return 0
		end

		return var_0_3(arg_18_0, var_18_0, arg_18_1, arg_18_2)
	end,
	function(arg_20_0, arg_20_1, arg_20_2)
		local function var_20_0(arg_21_0)
			if arg_21_0.selectState then
				local var_21_0 = arg_21_0.id
				local var_21_1 = csv.cards[var_21_0].cardMarkID

				if ((gGameModel.role:read("card_feels")[var_21_1] or {}).level or 0) >= arg_20_0[1] then
					return 1
				end
			end

			return 0
		end

		return var_0_3(arg_20_0, var_20_0, arg_20_1, arg_20_2)
	end,
	function(arg_22_0, arg_22_1, arg_22_2)
		local function var_22_0(arg_23_0)
			if arg_23_0.selectState and arg_23_0.rarity >= arg_22_0[1] then
				return 1
			end

			return 0
		end

		return var_0_3(arg_22_0, var_22_0, arg_22_1, arg_22_2)
	end,
	function(arg_24_0, arg_24_1, arg_24_2)
		local var_24_0 = {}

		local function var_24_1(arg_25_0, arg_25_1)
			if arg_25_0.selectState then
				local var_25_0 = arg_25_0.attr1
				local var_25_1 = arg_25_0.attr2

				return var_25_0 == arg_25_1 or var_25_1 == arg_25_1
			end

			return false
		end

		for iter_24_0, iter_24_1 in ipairs(arg_24_0) do
			var_24_0[iter_24_0] = false

			repeat
				if var_24_1(arg_24_1:atproxy(1)) then
					var_24_0[iter_24_0] = true

					break
				end

				for iter_24_2 = 1, 3 do
					if var_24_1(arg_24_2:atproxy(iter_24_2)) then
						var_24_0[iter_24_0] = true
					end
				end
			until true
		end

		return var_24_0
	end
}

var_0_0.RESOURCE_FILENAME = "activity_dispatch_sprite_select.json"
var_0_0.RESOURCE_BINDING = {
	imgExtra = "imgExtra",
	leftPanel = "leftPanel",
	["rightPanel.awardList"] = "awardList",
	["rightPanel.title"] = "title",
	["leftPanel.empty"] = "empty",
	["leftPanel.filter"] = "filter",
	["rightPanel.conditionPanel.taskDesc"] = "taskDesc",
	["rightPanel.conditionPanel.attrList"] = "attrList",
	["rightPanel.textTimes"] = "textTimes",
	["rightPanel.imgTimes"] = "imgTimes",
	item = "item",
	attrItem = "attrItem",
	bg = "bg",
	["rightPanel.conditionPanel"] = "conditionPanel",
	["rightPanel.dispatchedPanel"] = "dispatchedPanel",
	["rightPanel.img"] = "titleImg",
	["rightPanel.conditionPanel.attrList1"] = "attrList1",
	["leftPanel.subList"] = "subList",
	rightPanel = "rightPanel",
	btnClose = {
		varname = "btnClose",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["rightPanel.btnDispatch"] = {
		varname = "btnDispatch",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnDispatch")
			}
		}
	},
	["rightPanel.btnStart"] = {
		varname = "btnStart",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnStart")
			}
		}
	},
	["rightPanel.btnStop"] = {
		varname = "btnStop",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnStop")
			}
		}
	},
	["leftPanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				xMargin = 10,
				yMargin = 10,
				asyncPreload = 25,
				columnSize = 5,
				data = bindHelper.self("cardDatas"),
				dataFilterGen = bindHelper.self("onFilterCards", true),
				dataOrderCmpGen = bindHelper.self("onSortCards", true),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				empty = bindHelper.self("empty"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
					var_0_2(arg_26_0, arg_26_1, arg_26_3)
					arg_26_1:get("icon"):setVisible(arg_26_3.recommend)

					local var_26_0 = arg_26_3.status == 2 and gLanguageCsv.restIn or gLanguageCsv.InDispatch

					if arg_26_3.selectState or arg_26_3.status == 0 then
						var_26_0 = gLanguageCsv.inTheTeam
					end

					arg_26_1:get("mask.imgMask"):hide()

					local var_26_1 = arg_26_1:get("mask.textNote")

					var_26_1:text(var_26_0)
					uiEasy.addTextEffect1(var_26_1)
					arg_26_1:get("mask"):visible(arg_26_3.selectState or arg_26_3.status ~= 0)
					arg_26_1:setTouchEnabled(arg_26_3.status == 0)
					bind.touch(arg_26_0, arg_26_1, {
						methods = {
							ended = functools.partial(arg_26_0.itemClick, arg_26_0:getIdx(arg_26_2), arg_26_3)
						}
					})
				end,
				onBeforeBuild = function(arg_27_0)
					arg_27_0.empty:visible(itertools.size(arg_27_0.data) == 0)
				end
			},
			handlers = {
				itemClick = bindHelper.self("onCardItemClick")
			}
		}
	},
	["leftPanel.cardPanel.list1"] = {
		varname = "taskCardList1",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 5,
				data = bindHelper.self("taskCardDatas1"),
				item = bindHelper.self("item"),
				onItem = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
					var_0_2(arg_28_0, arg_28_1, arg_28_3, true)
					bind.touch(arg_28_0, arg_28_1, {
						methods = {
							ended = functools.partial(arg_28_0.itemClick, arg_28_2, arg_28_3)
						}
					})
					arg_28_1:get("mask"):visible(false)
					arg_28_1:get("icon"):visible(false)
				end
			},
			handlers = {
				itemClick = bindHelper.self("onTaskItemClick1")
			}
		}
	},
	["leftPanel.cardPanel.list2"] = {
		varname = "taskCardList2",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 5,
				data = bindHelper.self("taskCardDatas2"),
				item = bindHelper.self("item"),
				onItem = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
					var_0_2(arg_29_0, arg_29_1, arg_29_3, true)
					bind.touch(arg_29_0, arg_29_1, {
						methods = {
							ended = functools.partial(arg_29_0.itemClick, arg_29_2, arg_29_3)
						}
					})
					arg_29_1:get("mask"):visible(false)
					arg_29_1:get("icon"):visible(false)
				end
			},
			handlers = {
				itemClick = bindHelper.self("onTaskItemClick2")
			}
		}
	},
	["rightPanel.dispatchedPanel.list1"] = {
		varname = "dispatchList1",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 5,
				data = bindHelper.self("disptachedData1"),
				item = bindHelper.self("item"),
				onItem = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
					var_0_2(arg_30_0, arg_30_1, arg_30_3, true)
					arg_30_1:get("mask"):visible(false)
					arg_30_1:get("icon"):visible(false)
				end
			}
		}
	},
	["rightPanel.dispatchedPanel.list2"] = {
		varname = "dispatchList2",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 5,
				data = bindHelper.self("disptachedData2"),
				item = bindHelper.self("item"),
				onItem = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
					var_0_2(arg_31_0, arg_31_1, arg_31_3, true)
					arg_31_1:get("mask"):visible(false)
					arg_31_1:get("icon"):visible(false)
				end
			}
		}
	}
}

function var_0_0.getConditionStr(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	local var_32_0 = arg_32_3 .. "." .. gLanguageCsv["dispatchCondition" .. arg_32_1]
	local var_32_1, var_32_2 = var_0_4[arg_32_1](arg_32_2, arg_32_0.taskCardDatas1, arg_32_0.taskCardDatas2)
	local var_32_3 = ""
	local var_32_4 = var_32_1 and "#C0x62C558#" or "#C0xF7734E#"
	local var_32_5 = arg_32_2[1]

	if arg_32_1 == 1 then
		var_32_0 = var_32_4 .. string.format(var_32_0, var_32_2 .. "/" .. arg_32_2[1])
	elseif arg_32_1 == 2 then
		local var_32_6 = "#I" .. ui.ATTR_ICON[arg_32_2[1]] .. "-50-50#"

		var_32_0 = var_32_4 .. string.format(var_32_0, var_32_6, var_32_2 .. "/" .. arg_32_2[2])
	elseif arg_32_1 == 3 then
		local var_32_7 = arg_32_2[1]
		local var_32_8 = csv.cards[var_32_7].name

		var_32_0 = var_32_4 .. string.format(var_32_0, string.format(gLanguageCsv.selectTypeCardFragments, var_32_8))
	elseif arg_32_1 == 4 then
		local var_32_9 = ""

		for iter_32_0 = 1, itertools.size(arg_32_2) - 1 do
			if iter_32_0 == itertools.size(arg_32_2) - 1 then
				var_32_9 = var_32_9 .. gLanguageCsv["sex" .. arg_32_2[iter_32_0]]
			else
				var_32_9 = var_32_9 .. gLanguageCsv["sex" .. arg_32_2[iter_32_0]] .. gLanguageCsv["or"]
			end
		end

		var_32_0 = var_32_4 .. string.format(var_32_0, var_32_9, var_32_2 .. "/" .. arg_32_2[itertools.size(arg_32_2)])
	elseif arg_32_1 == 5 or arg_32_1 == 6 or arg_32_1 == 7 or arg_32_1 == 8 then
		var_32_0 = var_32_4 .. string.format(var_32_0, arg_32_2[1], var_32_2 .. "/" .. arg_32_2[2])
	elseif arg_32_1 == 9 then
		var_32_0 = var_32_4 .. string.format(var_32_0, arg_32_2[1], var_32_2 .. "/" .. arg_32_2[2])
	elseif arg_32_1 == 10 then
		local var_32_10 = "#I" .. ui.RARITY_ICON[arg_32_2[1]] .. "-50-50#"

		var_32_0 = var_32_4 .. string.format(var_32_0, var_32_10, var_32_2 .. "/" .. arg_32_2[2])
	elseif arg_32_1 == 11 then
		return var_32_0, var_32_1
	end

	return var_32_0, var_32_1
end

function var_0_0.showAward(arg_33_0, arg_33_1)
	local var_33_0 = csv.yunying.dispatch[arg_33_0.id]

	if arg_33_1 then
		local var_33_1 = table.shallowcopy(var_33_0.award)

		for iter_33_0, iter_33_1 in pairs(var_33_0.extraAward) do
			var_33_1[iter_33_0] = iter_33_1
		end

		uiEasy.createItemsToList(arg_33_0, arg_33_0.awardList, var_33_1, {
			scale = 0.9,
			onAfterBuild = function()
				arg_33_0.awardList:setItemAlignCenter()
			end,
			sortFunc = function(arg_35_0, arg_35_1)
				if var_33_0.extraAward[arg_35_0.key] and not var_33_0.extraAward[arg_35_1.key] then
					return false
				elseif not var_33_0.extraAward[arg_35_0.key] and var_33_0.extraAward[arg_35_1.key] then
					return true
				else
					return dataEasy.sortItemCmp(arg_35_0, arg_35_1)
				end
			end,
			onNode = function(arg_36_0, arg_36_1)
				if var_33_0.extraAward[arg_36_1.key] then
					local var_36_0 = arg_33_0.imgExtra:clone():addTo(arg_36_0):xy(157, 185):z(10):scale(1.1):show()
				end
			end
		})
	else
		uiEasy.createItemsToList(arg_33_0, arg_33_0.awardList, var_33_0.award, {
			scale = 0.9,
			onAfterBuild = function()
				arg_33_0.awardList:setItemAlignCenter()
			end
		})
	end
end

function var_0_0.refreshRight(arg_38_0)
	local var_38_0 = csv.yunying.dispatch[arg_38_0.id]
	local var_38_1 = true

	for iter_38_0 = 1, 3 do
		arg_38_0.conditionPanel:removeChildByName("rich" .. iter_38_0)

		local var_38_2 = var_38_0["target" .. iter_38_0]

		if var_38_2 ~= 0 then
			local var_38_3 = var_38_0["params" .. iter_38_0]
			local var_38_4, var_38_5 = arg_38_0:getConditionStr(var_38_2, var_38_3, iter_38_0)

			if var_38_2 == 11 then
				for iter_38_1, iter_38_2 in ipairs(var_38_5) do
					if not iter_38_2 then
						var_38_1 = false
					end
				end
			elseif var_38_5 == false then
				var_38_1 = false
			end

			if var_38_2 == 11 then
				local var_38_6 = cc.Label:createWithTTF(var_38_4, ui.FONT_PATH, 40):name("rich" .. iter_38_0):anchorPoint(cc.p(0, 1)):xy(arg_38_0.conditionPanel:get("conditionNote"):x(), 745 - 52 * iter_38_0):text(var_38_4):z(10):addTo(arg_38_0.conditionPanel)
				local var_38_7 = true

				for iter_38_3, iter_38_4 in ipairs(var_38_5) do
					if not iter_38_4 then
						var_38_7 = false
					end
				end

				arg_38_0.attrList:removeAllChildren()
				arg_38_0.attrList:setScrollBarEnabled(false)
				arg_38_0.attrList:scale(0.8)

				for iter_38_5, iter_38_6 in ipairs(var_38_3) do
					local var_38_8 = arg_38_0.attrItem:clone():show()

					var_38_8:get("attrIcon"):texture(ui.ATTR_ICON[iter_38_6])
					var_38_8:get("img"):setVisible(var_38_5[iter_38_5])
					arg_38_0.attrList:pushBackCustomItem(var_38_8)
				end

				var_38_6:setTextColor(var_38_7 and cc.c4b(98, 197, 88, 255) or cc.c4b(247, 115, 78, 255))
				arg_38_0.attrList:xy(var_38_6:x() + var_38_6:width() + 5, var_38_6:y() - 45)
			else
				local var_38_9 = rich.createWithWidth(var_38_4, 40, nil, 1000, nil, cc.p(0, 0.5)):xy(610, 745 - 52 * iter_38_0):addTo(arg_38_0.conditionPanel):name("rich" .. iter_38_0):show():z(10)
			end
		end
	end

	uiEasy.setBtnShader(arg_38_0.btnDispatch, arg_38_0.btnDispatch:get("title"), var_38_1 and 1 or 2)

	local var_38_10 = arg_38_0.conditionPanel:get("extraCondition")
	local var_38_11 = var_38_0.spTarget

	arg_38_0.conditionPanel:removeChildByName("rich")

	local var_38_12 = var_38_0.spParams
	local var_38_13 = false

	if var_38_11 ~= 0 then
		local var_38_14, var_38_15 = arg_38_0:getConditionStr(var_38_11, var_38_12, 1)

		arg_38_0.conditionPanel:get("extraConditionNote"):show()

		if var_38_11 == 11 then
			local var_38_16 = cc.Label:createWithTTF(var_38_14, ui.FONT_PATH, 40):name("rich"):anchorPoint(cc.p(0, 1)):xy(arg_38_0.conditionPanel:get("extraCondition"):x(), 490):text(var_38_14):z(10):addTo(arg_38_0.conditionPanel)
			local var_38_17 = true

			for iter_38_7, iter_38_8 in ipairs(var_38_15) do
				if not iter_38_8 then
					var_38_17 = false
				end
			end

			arg_38_0.attrList1:removeAllChildren()
			arg_38_0.attrList1:setScrollBarEnabled(false)
			arg_38_0.attrList1:scale(0.8)

			for iter_38_9, iter_38_10 in ipairs(var_38_12) do
				local var_38_18 = arg_38_0.attrItem:clone():show()

				var_38_18:get("attrIcon"):texture(ui.ATTR_ICON[iter_38_10])
				var_38_18:get("img"):setVisible(var_38_15[iter_38_9])
				arg_38_0.attrList1:pushBackCustomItem(var_38_18)
			end

			var_38_16:setTextColor(var_38_17 and cc.c4b(98, 197, 88, 255) or cc.c4b(247, 115, 78, 255))
			arg_38_0.attrList1:xy(var_38_16:x() + var_38_16:width() + 5, var_38_16:y() - 45)
		else
			local var_38_19 = rich.createWithWidth(var_38_14, 40, nil, 1000, nil, cc.p(0, 0.5)):xy(610, 490):addTo(arg_38_0.conditionPanel):name("rich"):show():z(10)
		end

		if var_38_0.extraTime ~= 0 then
			var_38_10:text(string.format(gLanguageCsv.dispatchAddition, tostring(mathEasy.getPreciseDecimal(var_38_0.extraTime / 60, 2, false))))
		else
			var_38_10:hide()
		end

		local var_38_20 = (arg_38_0.yyhuodongs:read()[arg_38_0.activityId] or {}).dispatch or {}

		if not var_38_20[arg_38_0.id] or var_38_20[arg_38_0.id].status == 2 then
			arg_38_0:showAward(true)
		elseif var_38_20[arg_38_0.id].status == 1 and var_38_20[arg_38_0.id].extra then
			arg_38_0:showAward(true)
		else
			arg_38_0:showAward(false)
		end
	else
		arg_38_0.conditionPanel:get("extraConditionNote"):hide()
		var_38_10:hide()
		arg_38_0:showAward(false)
	end
end

function var_0_0.initModel(arg_39_0)
	arg_39_0.cards = gGameModel.role:getIdler("cards")
	arg_39_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_39_0.cardDatas = idlers.new()
	arg_39_0.filterCondition = idlertable.new()
	arg_39_0.selectIdx = idler.new(0)
	arg_39_0.taskCardDatas1 = idlers.new()

	arg_39_0.taskCardDatas1:update({
		{}
	})

	arg_39_0.taskCardDatas2 = idlers.new()

	local var_39_0 = {}

	for iter_39_0 = 1, 3 do
		var_39_0[iter_39_0] = {}
	end

	arg_39_0.taskCardDatas2:update(var_39_0)

	arg_39_0.disptachedData1 = idlers.newWithMap({
		{}
	})
	arg_39_0.disptachedData2 = idlers.newWithMap({
		{},
		{},
		{}
	})
	arg_39_0.dispatchStatus = idler.new(0)
end

function var_0_0.initDispatchedShow(arg_40_0, arg_40_1)
	arg_40_0.dispatchedPanel:show()
	arg_40_0.conditionPanel:hide()

	local var_40_0 = {}

	for iter_40_0 = 1, 4 do
		local var_40_1 = arg_40_1[arg_40_0.id].cards[iter_40_0]

		if var_40_1 then
			local var_40_2 = arg_40_1[arg_40_0.id].cards[iter_40_0].id
			local var_40_3 = csv.cards[var_40_1.card_id]
			local var_40_4 = csv.unit[var_40_3.unitID]
			local var_40_5 = dataEasy.getUnitId(var_40_1.card_id, var_40_1.skin_id)

			var_40_0[iter_40_0] = {
				selectState = true,
				id = var_40_1.card_id,
				unitId = var_40_5,
				rarity = var_40_4.rarity,
				attr1 = var_40_4.natureType,
				attr2 = var_40_4.natureType2,
				level = var_40_1.level,
				star = var_40_1.star,
				advance = var_40_1.advance,
				dbid = var_40_2
			}
		end
	end

	arg_40_0.disptachedData1:update({
		var_40_0[1]
	})
	arg_40_0.disptachedData2:update({
		var_40_0[2],
		var_40_0[3],
		var_40_0[4]
	})
end

function var_0_0.onCreate(arg_41_0, arg_41_1, arg_41_2)
	arg_41_0.activityId = arg_41_1
	arg_41_0.id = arg_41_2
	arg_41_0.allDispatchNum = 0

	arg_41_0:initModel()
	arg_41_0:initFilter()

	arg_41_0.dispatchTimes = 0
	arg_41_0.endTime = 0
	arg_41_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")

	local var_41_0 = csv.yunying.yyhuodong[arg_41_0.activityId].paramMap.item

	arg_41_0.actionPoint = idler.new(dataEasy.getNumByKey(var_41_0))

	local var_41_1 = csv.yunying.dispatch[arg_41_2]

	arg_41_0.bg:texture(var_41_1.frameType)
	arg_41_0.title:text(var_41_1.name)
	adapt.oneLineCenterPos(cc.p(550, arg_41_0.title:y()), {
		arg_41_0.titleImg,
		arg_41_0.title
	}, cc.p(5, 0))
	arg_41_0.taskDesc:text(var_41_1.desc)
	arg_41_0.titleImg:texture(var_41_1.iconSpecial)

	local var_41_2 = csv.yunying.yyhuodong[arg_41_0.activityId].paramMap.item
	local var_41_3 = string.format(gLanguageCsv.dispatchCost, tostring(mathEasy.getPreciseDecimal(var_41_1.duration / 60, 2, false)), var_41_1.cost[var_41_2])
	local var_41_4 = rich.createByStr(var_41_3, 40, nil, nil, cc.p(0, 0)):addTo(arg_41_0.conditionPanel:get("imgBg"), 100):anchorPoint(cc.p(0, 0.5)):xy(arg_41_0.conditionPanel:get("imgBg.text"):xy()):formatText()

	arg_41_0.conditionPanel:get("imgBg.text"):hide()

	if var_41_1.times > 1 then
		arg_41_0.imgTimes:show()
		arg_41_0.textTimes:show()
	else
		arg_41_0.imgTimes:hide()
		arg_41_0.textTimes:hide()
	end

	idlereasy.when(arg_41_0.yyhuodongs, function(arg_42_0, arg_42_1)
		local var_42_0 = (arg_42_1[arg_41_0.activityId] or {}).dispatch or {}

		arg_41_0.dispatchTimes = var_42_0[arg_41_0.id] and var_42_0[arg_41_0.id].times or 0

		if not var_42_0[arg_41_0.id] then
			arg_41_0.dispatchStatus:set(5)
		elseif var_42_0[arg_41_0.id].status == 1 then
			if var_42_0[arg_41_0.id].end_time < time.getTime() then
				arg_41_0.dispatchStatus:set(4)
			else
				arg_41_0.dispatchStatus:set(3)
			end
		elseif time.getTime() < var_42_0[arg_41_0.id].cd_time then
			arg_41_0.dispatchStatus:set(5)
		else
			arg_41_0.dispatchStatus:set(1)
		end

		arg_41_0.allDispatchNum = 0

		for iter_42_0, iter_42_1 in pairs(var_42_0) do
			if var_42_0[iter_42_0] and var_42_0[iter_42_0].status == 1 then
				arg_41_0.allDispatchNum = arg_41_0.allDispatchNum + 1
			end
		end

		arg_41_0.textTimes:text(string.format(gLanguageCsv.dispatchTips, csv.yunying.dispatch[arg_41_0.id].times - arg_41_0.dispatchTimes))

		arg_41_0.endTime = var_42_0[arg_41_0.id] and var_42_0[arg_41_0.id].end_time or 0
	end)
	idlereasy.when(arg_41_0.dispatchStatus, function(arg_43_0, arg_43_1)
		local var_43_0 = (arg_41_0.yyhuodongs:read()[arg_41_0.activityId] or {}).dispatch or {}

		if arg_43_1 == 1 then
			arg_41_0.disptachedData1:update({})
			arg_41_0.disptachedData2:update({})
			arg_41_0.leftPanel:show()
			arg_41_0.dispatchedPanel:hide()
			arg_41_0.conditionPanel:show()
			arg_41_0.btnDispatch:hide()
			arg_41_0.btnStart:show()
			arg_41_0.btnStop:hide()
			arg_41_0.leftPanel:hide()
			arg_41_0.bg:width(1156)
			arg_41_0.rightPanel:x(arg_41_0.bg:x())
			arg_41_0.btnClose:x(arg_41_0.bg:x() + 607)
			uiEasy.setBtnShader(arg_41_0.btnStart, arg_41_0.btnStart:get("title"), 1)
		elseif arg_43_1 == 2 then
			arg_41_0.leftPanel:show()
			arg_41_0.bg:width(2304)
			arg_41_0.rightPanel:x(530 + display.sizeInViewRect.width / 2)
			arg_41_0.btnClose:x(1137 + display.sizeInViewRect.width / 2)
			arg_41_0.dispatchedPanel:hide()
			arg_41_0.conditionPanel:show()
			arg_41_0.btnDispatch:show()
			arg_41_0.btnStart:hide()
			arg_41_0.btnStop:hide()
		elseif arg_43_1 == 3 then
			arg_41_0.leftPanel:hide()
			arg_41_0.bg:width(1156)
			arg_41_0.rightPanel:x(arg_41_0.bg:x())
			arg_41_0.btnClose:x(arg_41_0.bg:x() + 607)
			arg_41_0:initDispatchedShow(var_43_0)
			arg_41_0.btnDispatch:hide()
			arg_41_0.btnStart:hide()
			arg_41_0.btnStop:show()
			arg_41_0:initCountDown(var_43_0[arg_41_0.id].end_time)
		elseif arg_43_1 == 4 then
			arg_41_0.leftPanel:hide()
			arg_41_0.bg:width(1156)
			arg_41_0.rightPanel:x(arg_41_0.bg:x())
			arg_41_0.btnClose:x(arg_41_0.bg:x() + 607)
			arg_41_0.btnDispatch:hide()
			arg_41_0.btnStart:hide()
			arg_41_0.btnStop:show()
			arg_41_0:initDispatchedShow(var_43_0)
			arg_41_0.dispatchedPanel:get("textNote"):text(gLanguageCsv.dispatchComplete)
			arg_41_0.dispatchedPanel:get("textCountDown"):text("")
			adapt.oneLineCenterPos(cc.p(500, 520), {
				arg_41_0.dispatchedPanel:get("textCountDown"),
				arg_41_0.dispatchedPanel:get("textNote")
			}, cc.p(0, 0))
			arg_41_0.btnStop:get("title"):text(gLanguageCsv.completeDispatch)
		elseif arg_43_1 == 5 then
			arg_41_0.leftPanel:hide()
			arg_41_0.bg:width(1156)
			arg_41_0.rightPanel:x(arg_41_0.bg:x())
			arg_41_0.btnClose:x(arg_41_0.bg:x() + 607)
			arg_41_0.btnDispatch:hide()
			arg_41_0.btnStart:show()
			arg_41_0.btnStop:hide()
			arg_41_0.dispatchedPanel:hide()
			adapt.oneLineCenterPos(cc.p(500, 520), {
				arg_41_0.dispatchedPanel:get("textCountDown"),
				arg_41_0.dispatchedPanel:get("textNote")
			}, cc.p(0, 0))
			uiEasy.setBtnShader(arg_41_0.btnStart, arg_41_0.btnStart:get("title"), 3)
		end
	end)
	idlereasy.any({
		arg_41_0.cards,
		arg_41_0.yyhuodongs
	}, function(arg_44_0, arg_44_1, arg_44_2)
		local var_44_0 = (arg_44_2[arg_41_0.activityId] or {}).dispatch or {}
		local var_44_1 = var_0_1(var_44_0)
		local var_44_2 = {}

		for iter_44_0, iter_44_1 in pairs(arg_44_1) do
			local var_44_3 = gGameModel.cards:find(iter_44_1):read("card_id", "skin_id", "name", "fighting_point", "level", "star", "advance", "gender")
			local var_44_4 = csv.cards[var_44_3.card_id]
			local var_44_5 = csv.unit[var_44_4.unitID]
			local var_44_6 = dataEasy.getUnitId(var_44_3.card_id, var_44_3.skin_id)
			local var_44_7 = {
				selectState = false,
				id = var_44_3.card_id,
				unitId = var_44_6,
				rarity = var_44_5.rarity,
				attr1 = var_44_5.natureType,
				attr2 = var_44_5.natureType2,
				level = var_44_3.level,
				star = var_44_3.star,
				advance = var_44_3.advance,
				gender = var_44_3.gender,
				fight = var_44_3.fighting_point,
				dbid = iter_44_1,
				status = var_44_1[iter_44_1] or 0,
				atkType = var_44_4.atkType
			}

			var_44_7.recommend = arg_41_0:checkRecommend(var_44_7)
			var_44_2[iter_44_1] = var_44_7
		end

		arg_41_0.cardDatas:update(var_44_2)
	end)
	idlereasy.when(arg_41_0.selectIdx, function(arg_45_0, arg_45_1)
		if arg_45_1 == 0 then
			arg_41_0:refreshRight()

			return
		end

		local var_45_0 = arg_41_0.cardDatas:atproxy(arg_45_1)

		if var_45_0.selectState then
			local var_45_1 = arg_41_0.taskCardDatas1:atproxy(1)

			if var_45_0.dbid == var_45_1.dbid then
				var_45_1.selectState = false
				var_45_0.selectState = false
			else
				for iter_45_0 = 1, 3 do
					local var_45_2 = arg_41_0.taskCardDatas2:atproxy(iter_45_0)

					if var_45_0.dbid == var_45_2.dbid then
						var_45_2.selectState = false
						var_45_0.selectState = false
					end
				end
			end
		else
			local function var_45_3(arg_46_0, arg_46_1)
				arg_46_0.selectState = true
				arg_46_0.id = arg_46_1.id
				arg_46_0.unitId = arg_46_1.unitId
				arg_46_0.rarity = arg_46_1.rarity
				arg_46_0.attr1 = arg_46_1.attr1
				arg_46_0.attr2 = arg_46_1.attr2
				arg_46_0.level = arg_46_1.level
				arg_46_0.star = arg_46_1.star
				arg_46_0.advance = arg_46_1.advance
				arg_46_0.gender = arg_46_1.gender
				arg_46_0.fight = arg_46_1.fight
				arg_46_0.dbid = arg_46_1.dbid
				arg_46_1.selectState = true
			end

			local var_45_4 = arg_41_0.taskCardDatas1:atproxy(1)
			local var_45_5 = false

			if not var_45_4.selectState then
				var_45_3(var_45_4, var_45_0)
			else
				for iter_45_1 = 1, 3 do
					local var_45_6 = arg_41_0.taskCardDatas2:atproxy(iter_45_1)

					if not var_45_6.selectState then
						var_45_3(var_45_6, var_45_0)

						break
					end
				end
			end
		end

		arg_41_0:refreshRight()
	end)
end

function var_0_0.onSortCards(arg_47_0, arg_47_1)
	return function(arg_48_0, arg_48_1)
		if arg_48_0.status ~= arg_48_1.status then
			return arg_48_0.status < arg_48_1.status
		else
			return arg_48_0.fight > arg_48_1.fight
		end
	end
end

function var_0_0.initFilter(arg_49_0)
	local var_49_0 = arg_49_0.filter:parent():convertToWorldSpace(arg_49_0.filter:box())
	local var_49_1 = arg_49_0:convertToNodeSpace(var_49_0)

	gGameUI:createView("city.card.bag_filter", arg_49_0.filter):init({
		cb = arg_49_0:createHandler("onBattleFilter"),
		others = {
			height = 102,
			panelOffsetX = 940,
			panelOrder = true,
			panelOffsetY = 450,
			width = 221,
			btn = arg_49_0.filter:get("btnFilter"),
			x = gGameUI:getConvertPos(arg_49_0.filter, arg_49_0:getResourceNode())
		}
	}):xy(-var_49_1.x, -var_49_1.y)
	arg_49_0.filter:z(1000)
	idlereasy.any({
		arg_49_0.filterCondition
	}, function()
		dataEasy.tryCallFunc(arg_49_0.list, "filterSortItems", false)
	end)
end

function var_0_0.onBattleFilter(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4)
	arg_51_0.filterCondition:set({
		attr1 = arg_51_1,
		attr2 = arg_51_2,
		rarity = arg_51_3,
		atkType = arg_51_4
	}, true)
end

function var_0_0.onFilterCards(arg_52_0, arg_52_1)
	local var_52_0 = arg_52_0.filterCondition:read()
	local var_52_1 = {
		{
			"rarity",
			var_52_0.rarity < ui.RARITY_LAST_VAL and var_52_0.rarity or nil
		},
		{
			"attr2",
			var_52_0.attr2 < ui.ATTR_MAX and var_52_0.attr2 or nil
		},
		{
			"attr1",
			var_52_0.attr1 < ui.ATTR_MAX and var_52_0.attr1 or nil
		},
		{
			"atkType",
			var_52_0.atkType
		}
	}

	local function var_52_2(arg_53_0, arg_53_1, arg_53_2)
		if arg_53_0[arg_53_1] == nil and (arg_53_1 ~= "attr2" or arg_53_0.attr1 == arg_53_2) then
			return true
		end

		if arg_53_1 == "atkType" then
			for iter_53_0, iter_53_1 in ipairs(arg_53_0.atkType) do
				if arg_53_2[iter_53_1] then
					return true
				end
			end

			return false
		end

		if arg_53_0[arg_53_1] == arg_53_2 then
			return true
		end

		return false
	end

	return function(arg_54_0, arg_54_1)
		for iter_54_0 = 1, #var_52_1 do
			local var_54_0 = var_52_1[iter_54_0]

			if var_54_0[2] and not var_52_2(arg_54_1, var_54_0[1], var_54_0[2]) then
				return false
			end
		end

		return true, arg_54_0
	end
end

function var_0_0.onBtnDispatch(arg_55_0)
	local var_55_0 = csv.yunying.dispatch[arg_55_0.id]

	for iter_55_0 = 1, 3 do
		local var_55_1 = var_55_0["target" .. iter_55_0]

		if var_55_1 ~= 0 then
			local var_55_2 = var_55_0["params" .. iter_55_0]

			if not var_0_4[var_55_1](var_55_2, arg_55_0.taskCardDatas1, arg_55_0.taskCardDatas2) then
				gGameUI:showTip(gLanguageCsv.dispatchMismatchCondition)

				return
			end
		end
	end

	if not arg_55_0.taskCardDatas1:atproxy(1).selectState then
		gGameUI:showTip(gLanguageCsv.dispatchWithoutLeader)

		return
	end

	local var_55_3 = csv.yunying.yyhuodong[arg_55_0.activityId].paramMap.item

	if dataEasy.getNumByKey(var_55_3) < csv.yunying.dispatch[arg_55_0.id].cost[var_55_3] then
		gGameUI:showTip(gLanguageCsv.actionPointNotEnough)

		return
	end

	local var_55_4 = {
		arg_55_0.taskCardDatas1:atproxy(1).dbid
	}

	for iter_55_1 = 1, 3 do
		local var_55_5 = arg_55_0.taskCardDatas2:atproxy(iter_55_1)

		if var_55_5.selectState then
			table.insert(var_55_4, var_55_5.dbid)
		end
	end

	gGameApp:requestServer("/game/yy/dispatch/begin", function(arg_56_0)
		arg_55_0:addCallbackOnExit(function()
			gGameUI:stackUI("city.activity.dispatch.suc", nil, {
				clickClose = true
			})
		end)
		arg_55_0:onClose()
	end, arg_55_0.activityId, arg_55_0.id, var_55_4)
end

function var_0_0.onBtnStop(arg_58_0)
	if arg_58_0.dispatchStatus:read() == 4 then
		arg_58_0.dispatchStatus:shutup()
		gGameApp:requestServer("/game/yy/dispatch/end", function(arg_59_0)
			arg_58_0:addCallbackOnExit(function()
				gGameUI:showGainDisplay(arg_59_0)
			end)
			arg_58_0:onClose()
		end, arg_58_0.activityId, arg_58_0.id, false)
	else
		gGameUI:showDialog({
			btnType = 2,
			content = gLanguageCsv.endDispatchTip,
			closeTime = arg_58_0.endTime,
			cb = function()
				arg_58_0.dispatchStatus:shutup()
				gGameApp:requestServer("/game/yy/dispatch/end", function(arg_62_0)
					arg_58_0:addCallbackOnExit(function()
						gGameUI:showTip(gLanguageCsv.dispatchFailTip)
					end)
					arg_58_0:onClose()
				end, arg_58_0.activityId, arg_58_0.id, true)
			end
		})
	end
end

function var_0_0.onBtnStart(arg_64_0)
	local var_64_0 = (arg_64_0.yyhuodongs:read()[arg_64_0.activityId] or {}).dispatch or {}

	if not var_64_0[arg_64_0.id] then
		gGameUI:showTip(gLanguageCsv.dispatchLockTips)

		return
	end

	if time.getTime() < var_64_0[arg_64_0.id].cd_time then
		gGameUI:showTip(gLanguageCsv.dispatchCdTips)

		return
	end

	if csv.yunying.yyhuodong[arg_64_0.activityId].paramMap.number <= arg_64_0.allDispatchNum then
		gGameUI:showTip(gLanguageCsv.dispatchNumOver)

		return
	end

	local var_64_1 = csv.yunying.yyhuodong[arg_64_0.activityId].paramMap.item

	if dataEasy.getNumByKey(var_64_1) < csv.yunying.dispatch[arg_64_0.id].cost[var_64_1] then
		gGameUI:showTip(gLanguageCsv.actionPointNotEnough)

		return
	end

	if arg_64_0.dispatchStatus:read() == 1 then
		arg_64_0.dispatchStatus:set(2)
	end
end

function var_0_0.onCardItemClick(arg_65_0, arg_65_1, arg_65_2, arg_65_3)
	arg_65_0.selectIdx:set(arg_65_3.dbid, true)
end

function var_0_0.onTaskItemClick1(arg_66_0, arg_66_1, arg_66_2, arg_66_3)
	if not arg_66_3.selectState then
		return
	end

	arg_66_0.taskCardDatas1:atproxy(arg_66_2).selectState = false

	arg_66_0.selectIdx:set(arg_66_3.dbid, true)
end

function var_0_0.onTaskItemClick2(arg_67_0, arg_67_1, arg_67_2, arg_67_3)
	if not arg_67_3.selectState then
		return
	end

	arg_67_0.taskCardDatas2:atproxy(arg_67_2).selectState = false

	arg_67_0.selectIdx:set(arg_67_3.dbid, true)
end

function var_0_0.checkRecommend(arg_68_0, arg_68_1)
	local var_68_0 = csv.yunying.dispatch[arg_68_0.id]

	local function var_68_1(arg_69_0, arg_69_1)
		local var_69_0 = var_68_0["target" .. arg_69_1]
		local var_69_1 = var_68_0["params" .. arg_69_1]

		if arg_69_1 == 4 then
			var_69_0 = var_68_0.spTarget
			var_69_1 = var_68_0.spParams
		end

		if var_69_0 ~= 0 then
			if var_69_0 == 1 then
				return 0
			elseif var_69_0 == 2 then
				if arg_69_0.attr1 == var_69_1[1] or arg_69_0.attr2 == var_69_1[1] then
					return true, var_69_0
				end

				return false, var_69_0
			elseif var_69_0 == 3 then
				return csv.cards[arg_69_0.id].cardMarkID == var_69_1[1], var_69_0
			elseif var_69_0 == 4 then
				for iter_69_0 = 1, itertools.size(var_69_1) - 1 do
					if arg_69_0.gender == var_69_1[iter_69_0] then
						return true
					end
				end

				return false
			elseif var_69_0 == 5 then
				return (gHandbookCsv[arg_69_0.id].heightAndWeight[1] or 0) >= var_69_1[1], var_69_0
			elseif var_69_0 == 6 then
				return (gHandbookCsv[arg_69_0.id].heightAndWeight[1] or 0) <= var_69_1[1], var_69_0
			elseif var_69_0 == 7 then
				return (gHandbookCsv[arg_69_0.id].heightAndWeight[2] or 0) >= var_69_1[1], var_69_0
			elseif var_69_0 == 8 then
				return (gHandbookCsv[arg_69_0.id].heightAndWeight[2] or 0) <= var_69_1[1], var_69_0
			elseif var_69_0 == 9 then
				local var_69_2 = csv.cards[arg_69_0.id].cardMarkID

				return ((gGameModel.role:read("card_feels")[var_69_2] or {}).level or 0) >= var_69_1[1], var_69_0
			elseif var_69_0 == 10 then
				return arg_69_0.rarity >= var_69_1[1], var_69_0
			elseif var_69_0 == 11 then
				for iter_69_1, iter_69_2 in ipairs(var_69_1) do
					if arg_69_0.attr1 == iter_69_2 or arg_69_0.attr2 == iter_69_2 then
						return true, var_69_0
					end
				end

				return false, var_69_0
			end
		end

		return false, 0
	end

	for iter_68_0 = 1, 4 do
		local var_68_2, var_68_3 = var_68_1(arg_68_1, iter_68_0)

		if var_68_2 == true then
			return true
		end
	end
end

function var_0_0.initCountDown(arg_70_0, arg_70_1)
	adapt.oneLineCenterPos(cc.p(500, 520), {
		arg_70_0.dispatchedPanel:get("textCountDown"),
		arg_70_0.dispatchedPanel:get("textNote")
	}, cc.p(0, 0))
	bind.extend(arg_70_0, arg_70_0.dispatchedPanel:get("textCountDown"), {
		class = "cutdown_label",
		props = {
			str_key = "str",
			endTime = arg_70_1,
			endFunc = function(arg_71_0)
				arg_70_0.dispatchStatus:set(4)
			end,
			callFunc = function(arg_72_0)
				adapt.oneLineCenterPos(cc.p(500, 520), {
					arg_70_0.dispatchedPanel:get("textCountDown"),
					arg_70_0.dispatchedPanel:get("textNote")
				}, cc.p(0, 0))
			end
		}
	})
end

function var_0_0.initCdCountDown(arg_73_0, arg_73_1)
	arg_73_0:enableSchedule()
	arg_73_0:schedule(function(arg_74_0)
		if time.getTime() > arg_73_1 then
			arg_73_0.dispatchStatus:set(1)

			return false
		end
	end, 1)
end

return var_0_0
