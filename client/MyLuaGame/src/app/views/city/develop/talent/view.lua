local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("TalentView", var_0_0)
local var_0_2 = require("app.easy.bind.helper.red_hint")
local var_0_3 = {
	"HAVE_ROOT",
	"HAVE_ROOT",
	"NOT_ROOT",
	"NOT_ROOT"
}
local var_0_4 = {
	{
		bg = "city/develop/talent/logo_red.png",
		glow = cc.c4b(198, 94, 52, 255)
	},
	{
		bg = "city/develop/talent/logo_purple.png",
		glow = cc.c4b(167, 157, 55, 255)
	},
	{
		bg = "city/develop/talent/logo_green.png",
		glow = cc.c4b(111, 123, 205, 255)
	}
}
local var_0_5 = 3

local function var_0_6(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	itertools.invoke({
		arg_1_1.btn:get("lock"),
		arg_1_1.btn:get("mask")
	}, "visible", arg_1_2.isLock)

	local var_1_0 = arg_1_2.level or 0
	local var_1_1 = csv.talent[arg_1_2.id]

	arg_1_1.level:text(var_1_0 .. "/" .. var_1_1.levelUp)
	arg_1_1.btn:get("icon"):texture(var_1_1.icon)

	if not arg_1_3 then
		cache.setShader(arg_1_1.center, false, arg_1_2.isLock == true and "hsl_gray" or "normal")
		arg_1_1.btn:setTouchEnabled(true)
		bind.touch(arg_1_0, arg_1_1.btn, {
			methods = {
				ended = functools.partial(arg_1_0.itemClick, arg_1_2)
			}
		})
	end
end

var_0_1.RESOURCE_FILENAME = "talent.json"
var_0_1.RESOURCE_BINDING = {
	["leftPanel.item"] = "leftItem",
	["rightPanel.cost"] = "cost1",
	["rightPanel.subList2"] = "subList2",
	["rightPanel.num"] = "talentPointNum",
	["rightPanel.begin"] = "begin",
	["rightPanel.slider"] = "slider",
	item1 = "item1",
	["rightPanel.name"] = "nodeName",
	item2 = "item2",
	["rightPanel.subList1"] = "subList1",
	["leftPanel.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("leftDatas"),
				item = bindHelper.self("leftItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:get("normal")
					local var_2_1 = arg_2_1:get("selected")
					local var_2_2

					if arg_2_3.selected then
						var_2_0:hide()

						var_2_2 = var_2_1:show()

						var_2_2:get("txt"):setTextColor(ui.NEWCOLORS.BLACK)
					else
						var_2_1:hide()

						var_2_2 = var_2_0:show()

						var_2_2:get("subTxt"):text(arg_2_3.show.subName)
						var_2_2:get("subTxt"):setTextColor(ui.COLORS.NORMAL.GRAY)
						var_2_2:get("txt"):setTextColor(ui.NEWCOLORS.WHITE)
					end

					var_2_2:get("lock"):visible(arg_2_3.isLock == true)
					var_2_2:get("txt"):text(arg_2_3.show.name)
					var_2_1:setTouchEnabled(false)
					bind.touch(arg_2_0, var_2_0, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	["rightPanel.list1"] = {
		varname = "list1",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				yMargin = 305,
				data = bindHelper.self("showdata1"),
				columnSize = var_0_5,
				item = bindHelper.self("subList1"),
				cell = bindHelper.self("item1"),
				onCell = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:multiget("center", "level", "btn")

					var_3_0.center:visible(arg_3_0:getIdx(arg_3_2).col ~= 1)
					var_0_6(arg_3_0, var_3_0, arg_3_3)
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	["rightPanel.list2"] = {
		varname = "list2",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				xMargin = -240,
				asyncPreload = 12,
				backupCached = false,
				data = bindHelper.self("showdata2"),
				columnSize = var_0_5,
				item = bindHelper.self("subList2"),
				cell = bindHelper.self("item2"),
				sliderBg = bindHelper.self("slider"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:multiget("center", "level", "btn", "title1", "title2")

					var_4_0.center:visible(arg_4_0:getIdx(arg_4_2).col ~= 1)

					if arg_4_3.tab == 3 then
						var_4_0.title1:hide()
						var_4_0.title2:visible(arg_4_0:getIdx(arg_4_2).col == 1)
						var_4_0.title2:get("titleBg"):texture(ui.SKILL_ICON[arg_4_0:getIdx(arg_4_2).row])
						var_4_0.title2:get("title"):texture(ui.SKILL_TEXT_ICON[arg_4_0:getIdx(arg_4_2).row])
					elseif arg_4_3.tab == 4 then
						var_4_0.title1:visible(arg_4_0:getIdx(arg_4_2).col == 1)
						var_4_0.title2:hide()

						local var_4_1 = var_0_4[arg_4_0:getIdx(arg_4_2).row % 3 == 0 and 3 or arg_4_0:getIdx(arg_4_2).row % 3]

						var_4_0.title1:get("titleBg"):texture(var_4_1.bg)
						var_4_0.title1:get("title"):text(csv.talent[arg_4_3.id].name)
						text.addEffect(var_4_0.title1:get("title"), {
							outline = {
								color = var_4_1.glow
							}
						})
					end

					var_0_6(arg_4_0, var_4_0, arg_4_3)
				end,
				onBeforeBuild = function(arg_5_0)
					if arg_5_0.sliderBg:visible() then
						arg_5_0.sliderShow = true

						arg_5_0.sliderBg:hide()
					end

					arg_5_0:setScrollBarEnabled(false)
				end,
				onAfterBuild = function(arg_6_0)
					if arg_6_0.sliderShow then
						arg_6_0.sliderBg:show()

						arg_6_0.sliderShow = false
					end

					local var_6_0, var_6_1 = arg_6_0:xy()
					local var_6_2 = arg_6_0:size()
					local var_6_3, var_6_4 = arg_6_0.sliderBg:xy()
					local var_6_5 = arg_6_0.sliderBg:size()

					arg_6_0:setScrollBarEnabled(true)
					arg_6_0:setScrollBarColor(cc.c3b(245, 156, 2))
					arg_6_0:setScrollBarOpacity(255)
					arg_6_0:setScrollBarAutoHideEnabled(false)
					arg_6_0:setScrollBarPositionFromCorner(cc.p(var_6_0 + var_6_2.width - var_6_3, (var_6_2.height - var_6_5.height) / 2 + 5))
					arg_6_0:setScrollBarWidth(var_6_5.width)
					arg_6_0:refreshView()
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	["rightPanel.btnReset.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["rightPanel.btnOneReset.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["rightPanel.btnReset"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_7_0)
					arg_7_0:onReset(true)
				end)
			}
		}
	},
	["rightPanel.btnOneReset"] = {
		varname = "btnOneReset",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_8_0)
					arg_8_0:onReset()
				end)
			}
		}
	},
	["rightPanel.btnQuestion"] = {
		varname = "btnQuestion",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowRule")
			}
		}
	}
}

function var_0_1.onCreate(arg_9_0)
	arg_9_0:initModel()
	arg_9_0:initCsvTable()
	idlereasy.when(arg_9_0.talentPoint, function(arg_10_0, arg_10_1)
		arg_9_0.talentPointNum:text(arg_10_1)
		adapt.oneLinePos(arg_9_0.talentPointNum, arg_9_0.btnQuestion, cc.p(10, 0), "left")
	end)

	arg_9_0.ids = {}

	gGameUI.topuiManager:createView("default", arg_9_0, {
		onClose = arg_9_0:createHandler("onClose")
	}):init({
		subTitle = "TALENT",
		title = "common/txt/txt_bt_tianfu.png"
	})

	local var_9_0 = {}
	local var_9_1 = {
		{
			subName = "Basis",
			name = gLanguageCsv.talentBasis
		},
		{
			subName = "Advance",
			name = gLanguageCsv.talentAdvance
		},
		{
			subName = "Element",
			name = gLanguageCsv.talentElement
		},
		{
			subName = "Challenge",
			name = gLanguageCsv.talentChallenge
		}
	}

	for iter_9_0, iter_9_1 in orderCsvPairs(csv.talent_tree) do
		if matchLanguage(iter_9_1.languages) and arg_9_0.level >= iter_9_1.showLevel then
			table.insert(var_9_0, {
				id = iter_9_0,
				cfg = iter_9_1,
				show = var_9_1[iter_9_0]
			})
		end
	end

	arg_9_0.leftDatas = idlers.newWithMap(var_9_0)
	arg_9_0.showTab = idler.new(1)
	arg_9_0.showdata1 = idlers.newWithMap({})
	arg_9_0.showdata2 = idlers.newWithMap({})

	arg_9_0.showTab:addListener(function(arg_11_0, arg_11_1, arg_11_2)
		arg_9_0.nodeName:removeAllChildren()

		arg_9_0.leftDatas:atproxy(arg_11_1).selected = false
		arg_9_0.leftDatas:atproxy(arg_11_0).selected = true

		arg_9_0.nodeName:text(arg_9_0.leftDatas:atproxy(arg_11_0).show.name)

		local var_11_0 = 2560

		if matchLanguage({
			"kr",
			"en"
		}) then
			var_11_0 = 1550
		end

		local var_11_1 = rich.createWithWidth(string.format("#C0xFFFFFFFF#%s", arg_9_0.leftDatas:atproxy(arg_11_0).cfg.des), 40, nil, var_11_0, nil, cc.p(0, 0.5)):addTo(arg_9_0.nodeName, 3, "richtext"):xy(arg_9_0.nodeName:size().width + 1310, 48)

		if matchLanguage({
			"en"
		}) then
			var_11_1:y(var_11_1:y() - 18)
			var_11_1:x(arg_9_0.nodeName:size().width + var_11_0 / 2 + 20)
		elseif matchLanguage({
			"kr"
		}) then
			var_11_1:x(arg_9_0.nodeName:size().width + var_11_0 / 2 + 20)
		end

		itertools.invoke({
			arg_9_0.list1,
			arg_9_0.begin
		}, "visible", arg_11_0 < 3)
		itertools.invoke({
			arg_9_0.list2,
			arg_9_0.slider
		}, "visible", arg_11_0 >= 3)

		if arg_11_0 >= 3 then
			arg_9_0.list2:jumpToTop()
		end

		dataEasy.tryCallFunc(arg_9_0.list2, "setItemAction", {
			isAction = true
		})
		arg_9_0:refreshShowData()
	end)
	idlereasy.when(arg_9_0.talentTree, function()
		dataEasy.tryCallFunc(arg_9_0.list2, "updatePreloadCenterIndex")
		arg_9_0:refreshShowData()
	end)
	arg_9_0.btnOneReset:visible(dataEasy.isShow(gUnlockCsv.singleTalentReset))
	uiEasy.updateUnlockRes(gUnlockCsv.singleTalentReset, arg_9_0.btnOneReset, {
		scale = 0.5,
		pos = cc.p(215, 75)
	})
end

function var_0_1.getPageLockState(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = false

	if arg_13_1[arg_13_2] == nil and arg_13_2 == 1 then
		var_13_0 = true
	elseif arg_13_2 > 1 and arg_13_0.leftDatas:atproxy(arg_13_2 - 1).isLock then
		var_13_0 = true
	elseif arg_13_2 > 1 then
		local var_13_1 = csv.talent_tree[arg_13_2]

		if arg_13_0.level < var_13_1.roleLevel or arg_13_1[arg_13_2 - 1] == nil or arg_13_1[arg_13_2 - 1].cost < var_13_1.preTalentpoint then
			var_13_0 = true
		end
	end

	return var_13_0
end

function var_0_1.refreshShowData(arg_14_0)
	arg_14_0.list2.sliderShow = false

	local var_14_0 = arg_14_0.talentTree:read()
	local var_14_1 = arg_14_0.showTab:read()
	local var_14_2 = arg_14_0.usedTable[var_14_1]

	for iter_14_0, iter_14_1 in orderCsvPairs(csv.talent_tree) do
		if matchLanguage(iter_14_1.languages) and arg_14_0.level >= iter_14_1.showLevel then
			arg_14_0.leftDatas:atproxy(iter_14_0).isLock = arg_14_0:getPageLockState(var_14_0, iter_14_0)
		end
	end

	local var_14_3 = var_14_0[var_14_1] and var_14_0[var_14_1].talent or {}
	local var_14_4 = arg_14_0:getPageLockState(var_14_0, var_14_1)

	for iter_14_2, iter_14_3 in ipairs(var_14_2.tree) do
		iter_14_3.isLock = var_14_3[iter_14_3.id] == nil or var_14_4
		iter_14_3.level = var_14_3[iter_14_3.id]
		iter_14_3.tab = var_14_1
	end

	if var_14_2.root then
		local var_14_5 = {}
		local var_14_6 = math.floor(#var_14_2.tree / var_0_5)

		for iter_14_4 = 1, var_14_6 do
			var_14_5[iter_14_4] = var_14_3[var_14_2.tree[1 + (iter_14_4 - 1) * var_0_5].id] ~= nil
		end

		arg_14_0.list1:setItemsMargin(#var_14_5 == 2 and 334 or 34)

		local var_14_7 = var_14_3[var_14_2.root.id]

		arg_14_0:initRootNode(var_14_2.root.id, var_14_7, var_14_5)
	end

	;(var_14_2.root and arg_14_0.showdata1 or arg_14_0.showdata2):update(clone(var_14_2.tree))

	local var_14_8 = arg_14_0.leftDatas:atproxy(var_14_1).isLock
	local var_14_9

	if var_14_8 then
		local var_14_10 = csv.talent_tree[var_14_1]
		local var_14_11 = var_14_10.roleLevel

		if var_14_1 ~= 1 then
			local var_14_12 = csv.talent_tree[var_14_1 - 1].name

			var_14_9 = string.format(gLanguageCsv.talentTreeUnlockCondition, var_14_12, var_14_10.preTalentpoint, var_14_10.roleLevel)
		else
			var_14_9 = string.format(gLanguageCsv.teamReachTargetLevel, var_14_10.roleLevel)
		end
	else
		var_14_9 = string.format(gLanguageCsv.currTreeCostTalentPoint, var_14_0[var_14_1] and var_14_0[var_14_1].cost or 0)
	end

	arg_14_0.cost1:setTextColor(var_14_8 and ui.COLORS.NORMAL.ALERT_ORANGE or ui.COLORS.NORMAL.WHITE)
	arg_14_0.cost1:text(var_14_9)

	if matchLanguage({
		"en"
	}) then
		adapt.setTextAdaptWithSize(arg_14_0.cost1, {
			vertical = "bottom",
			size = cc.size(1700, 120)
		})
	end
end

function var_0_1.initRootNode(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = arg_15_0.begin:multiget("up", "down", "level", "btn", "center")

	cache.setShader(var_15_0.up, false, arg_15_3[1] and "normal" or "hsl_gray")

	local var_15_1 = #arg_15_3 == 2 and arg_15_3[2] or arg_15_3[3]

	var_15_0.center:show()

	if #arg_15_3 == 2 then
		var_15_0.center:size(160, 43)
		var_15_0.center:x(350)
	else
		var_15_0.center:size(160, 43)
		var_15_0.center:x(350)
	end

	cache.setShader(var_15_0.center, false, (var_15_1 or arg_15_3[1]) and "normal" or "hsl_gray")
	cache.setShader(var_15_0.down, false, var_15_1 and "normal" or "hsl_gray")

	local var_15_2 = arg_15_2 == nil
	local var_15_3 = {
		isLock = var_15_2,
		level = arg_15_2 or 0,
		id = arg_15_1
	}

	var_15_0.btn:setTouchEnabled(true)
	var_0_6(arg_15_0, var_15_0, var_15_3, true)
	bind.touch(arg_15_0.begin, var_15_0.btn, {
		methods = {
			ended = function()
				gGameUI:stackUI("city.develop.talent.detail", nil, {
					clickClose = true
				}, arg_15_0:createHandler("sendParams", arg_15_0.showTab:read(), arg_15_1, var_15_2))
			end
		}
	})
end

function var_0_1.sendParams(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	return arg_17_1, arg_17_2, arg_17_3, arg_17_0.talentTree, arg_17_0.ids
end

function var_0_1.initCsvTable(arg_18_0, arg_18_1)
	arg_18_0.talentTreeTable = {}

	for iter_18_0, iter_18_1 in orderCsvPairs(csv.talent) do
		if not arg_18_0.talentTreeTable[iter_18_1.treeID] then
			arg_18_0.talentTreeTable[iter_18_1.treeID] = {}
		end

		arg_18_0.talentTreeTable[iter_18_1.treeID][iter_18_0] = {
			cfg = iter_18_1,
			next = {}
		}
	end

	local var_18_0 = {}

	for iter_18_2, iter_18_3 in ipairs(arg_18_0.talentTreeTable) do
		var_18_0[iter_18_2] = {}

		for iter_18_4, iter_18_5 in pairs(iter_18_3) do
			if iter_18_5.cfg.preTalentID then
				arg_18_0.talentTreeTable[iter_18_2][iter_18_5.cfg.preTalentID].next = arg_18_0.talentTreeTable[iter_18_2][iter_18_5.cfg.preTalentID].next or {}

				table.insert(arg_18_0.talentTreeTable[iter_18_2][iter_18_5.cfg.preTalentID].next, iter_18_4)
			else
				table.insert(var_18_0[iter_18_2], {
					cfg = iter_18_5,
					id = iter_18_4,
					next = iter_18_5.next
				})
			end
		end
	end

	arg_18_0.usedTable = {}

	for iter_18_6, iter_18_7 in ipairs(var_18_0) do
		local var_18_1 = {}
		local var_18_2 = {}

		for iter_18_8, iter_18_9 in ipairs(iter_18_7) do
			table.sort(iter_18_9.next)

			for iter_18_10, iter_18_11 in ipairs(iter_18_9.next) do
				var_18_2[iter_18_10] = {}

				if var_0_3[iter_18_6] == "NOT_ROOT" then
					table.insert(var_18_2[iter_18_10], {
						id = iter_18_9.id
					})
				end

				local var_18_3 = arg_18_0.talentTreeTable[iter_18_6][iter_18_11]

				table.insert(var_18_2[iter_18_10], {
					id = iter_18_11
				})

				local var_18_4 = var_18_3.next and var_18_3.next[1]

				while var_18_4 and type(var_18_4) == "number" do
					table.insert(var_18_2[iter_18_10], {
						id = var_18_4
					})

					local var_18_5 = arg_18_0.talentTreeTable[iter_18_6][var_18_4]

					var_18_4 = var_18_5.next and var_18_5.next[1]
				end
			end

			if var_0_3[iter_18_6] == "NOT_ROOT" then
				var_18_1[iter_18_8] = clone(var_18_2[1])
			else
				var_18_1 = clone(var_18_2)
			end
		end

		if var_0_3[iter_18_6] == "HAVE_ROOT" then
			arg_18_0.usedTable[iter_18_6] = {
				root = {
					id = iter_18_7[1].id
				},
				tree = arraytools.merge(var_18_1)
			}
		else
			table.sort(var_18_1, function(arg_19_0, arg_19_1)
				return arg_19_0[1].id < arg_19_1[1].id
			end)

			arg_18_0.usedTable[iter_18_6] = {
				tree = arraytools.merge(var_18_1)
			}
		end
	end
end

function var_0_1.initModel(arg_20_0)
	arg_20_0.talentTree = gGameModel.role:getIdler("talent_trees")
	arg_20_0.talentPoint = gGameModel.role:getIdler("talent_point")
	arg_20_0.level = gGameModel.role:read("level")
end

function var_0_1.onTabClick(arg_21_0, arg_21_1, arg_21_2)
	arg_21_0.showTab:set(arg_21_2)
end

function var_0_1.onItemClick(arg_22_0, arg_22_1, arg_22_2)
	gGameUI:stackUI("city.develop.talent.detail", nil, {
		clickClose = true
	}, arg_22_0:createHandler("sendParams", arg_22_0.showTab:read(), arg_22_2.id, arg_22_2.isLock))
end

function var_0_1.onReset(arg_23_0, arg_23_1)
	local var_23_0 = {}

	if not arg_23_1 then
		if not dataEasy.isUnlock(gUnlockCsv.singleTalentReset) then
			gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.singleTalentReset))

			return
		end

		var_23_0 = {
			treeID = arg_23_0.showTab:read()
		}
	end

	gGameUI:stackUI("city.develop.talent.reset", nil, {
		clickClose = true
	}, var_23_0)
end

function var_0_1.onClose(arg_24_0)
	local var_24_0 = {}

	for iter_24_0, iter_24_1 in pairs(arg_24_0.ids) do
		table.insert(var_24_0, iter_24_0)
	end

	if #var_24_0 > 0 then
		gGameApp:requestServer("/game/talent/levelup_end", function(arg_25_0)
			var_0_0.onClose(arg_24_0)
		end, var_24_0)
	else
		var_0_0.onClose(arg_24_0)
	end
end

function var_0_1.onShowRule(arg_26_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_26_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_1.getRuleContext(arg_27_0, arg_27_1)
	local var_27_0 = adaptContext

	return {
		var_27_0.clone(arg_27_1.title, function(arg_28_0)
			arg_28_0:get("text"):text(gLanguageCsv.talentPoint)
		end),
		var_27_0.noteText(56001, 56004)
	}
end

return var_0_1
