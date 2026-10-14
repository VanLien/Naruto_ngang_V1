local var_0_0 = {
	SIGNUP = 3,
	ADVENTURE = 4,
	REWARD = 1,
	UNION = 5,
	DRAWCARD = 2
}
local var_0_1 = {
	{
		specialTag = "dailyAssistantReward",
		onNode = function(arg_1_0)
			arg_1_0:xy(380, 140)
		end
	},
	{
		specialTag = "dailyAssistantDrawCard",
		onNode = function(arg_2_0)
			arg_2_0:xy(380, 140)
		end
	},
	{
		specialTag = "dailyAssistantSignup",
		onNode = function(arg_3_0)
			arg_3_0:xy(380, 140)
		end
	},
	{
		specialTag = "dailyAssistantAdventure",
		onNode = function(arg_4_0)
			arg_4_0:xy(380, 140)
		end
	},
	{
		specialTag = "dailyAssistantUnion",
		onNode = function(arg_5_0)
			arg_5_0:xy(380, 140)
		end
	}
}
local var_0_2 = {
	gem = gLanguageCsv.dailyAssistantGemSelectedTxt,
	catch = gLanguageCsv.dailyAssistantJumpCatch,
	endlessTower = gLanguageCsv.dailyAssistantEndlessTip
}
local var_0_3 = {
	gLanguageCsv.reward,
	gLanguageCsv.drawCard,
	gLanguageCsv.battleSignUp,
	gLanguageCsv.quickAdventure,
	gLanguageCsv.unionMatters
}
local var_0_4 = {
	hadSignUp = 2,
	canSignUp = 1,
	cantSignUp = 3
}
local var_0_5 = {
	gLanguageCsv.getAwardAll,
	gLanguageCsv.oneClickCardDraw,
	gLanguageCsv.oneClickRegistration,
	gLanguageCsv.oneClickDoing,
	gLanguageCsv.oneClickCompletion
}
local var_0_6 = gCommonConfigCsv.chipUpLimit

local function var_0_7(arg_6_0, arg_6_1, arg_6_2)
	for iter_6_0, iter_6_1 in pairs(arg_6_0) do
		if type(iter_6_1) == "table" then
			var_0_7(iter_6_1, arg_6_1, arg_6_2)
		elseif arg_6_2 == nil or iter_6_0 == arg_6_2 then
			arg_6_1[iter_6_0] = (arg_6_1[iter_6_0] or 0) + iter_6_1
		end
	end
end

local function var_0_8(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	arg_7_1:show()

	local var_7_0 = arg_7_1:multiget("gate", "txt1", "txt", "btnReward", "errTxt")

	var_7_0.btnReward:hide()
	var_7_0.txt:hide()
	var_7_0.txt1:hide()
	var_7_0.errTxt:hide()
	var_7_0.gate:hide()

	if arg_7_4.hasReward then
		var_7_0.btnReward:show()
		text.addEffect(var_7_0.btnReward:get("text"), {
			outline = {
				color = ui.COLORS.NORMAL.WHITE
			}
		})
	end

	if arg_7_4.errTxt then
		var_7_0.errTxt:show()
		var_7_0.errTxt:text(arg_7_4.errTxt)
	else
		if arg_7_4.txt or arg_7_4.txt1 then
			if arg_7_4.txt == nil then
				arg_7_4.txt = ""
			end

			if arg_7_4.txt1 == nil then
				arg_7_4.txt1 = ""
			end

			var_7_0.txt:show()
			var_7_0.txt1:show()

			local var_7_1 = var_7_0.txt
			local var_7_2 = var_7_0.txt1

			var_7_1:text(arg_7_4.txt)
			var_7_2:text(arg_7_4.txt1)
			adapt.oneLinePos(var_7_1, var_7_2, cc.p(10, 0))

			if arg_7_4.leftTimes and arg_7_4.leftTimes == 0 then
				text.addEffect(var_7_2, {
					color = cc.c3b(251, 96, 35)
				})
			end
		end

		var_7_0.gate:show()

		local var_7_3 = var_7_0.gate:multiget("icon", "imgSelect", "textOrder", "textHp")

		var_7_3.icon:texture(arg_7_4.data.icon)
		var_7_3.imgSelect:visible(arg_7_4.data.selectEffect == true)
		var_7_3.textOrder:text(arg_7_4.data.csvId)

		local var_7_4 = arg_7_4.data.maxHp == 0 and 100 or mathEasy.getPreciseDecimal(arg_7_4.data.surplusHp / arg_7_4.data.maxHp * 100, 2)

		var_7_3.textHp:text(string.format("%s:%s%%", gLanguageCsv.leftHP, var_7_4))
	end
end

local function var_0_9(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	arg_8_1:show()

	local var_8_0 = arg_8_1:multiget("redpackPanel", "txt", "finshImg")

	var_8_0.redpackPanel:show()
	var_8_0.txt:hide()
	var_8_0.finshImg:hide()

	if arg_8_4.finish then
		var_8_0.finshImg:show()
	end

	if arg_8_4.txt then
		var_8_0.redpackPanel:hide()
		var_8_0.finshImg:hide()
		var_8_0.txt:show()
		var_8_0.txt:text(arg_8_4.txt)

		if arg_8_2:width() + var_8_0.txt:width() / 2 > var_8_0.txt:x() - arg_8_2:x() then
			adapt.oneLinePos(arg_8_2, var_8_0.txt, cc.p(20, 0))
		end
	end
end

local function var_0_10(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	arg_9_1:show()

	local var_9_0 = arg_9_1:multiget("txtPanel", "panelSelectSuit", "finshImg", "txt")
	local var_9_1 = var_9_0.panelSelectSuit:get("suitPanel")

	if arg_9_4.txt or arg_9_4.txt1 then
		var_9_0.txtPanel:show()

		local var_9_2 = var_9_0.txtPanel:get("txt")
		local var_9_3 = var_9_0.txtPanel:get("txt1")

		var_9_2:text(arg_9_4.txt or "")
		var_9_3:text(arg_9_4.txt1 or "")
		adapt.oneLineCenterPos(cc.p(var_9_0.txtPanel:width() / 2, var_9_0.txtPanel:height() / 2), {
			var_9_2,
			var_9_3
		}, cc.p(20, 0))

		if arg_9_4.leftTimes and arg_9_4.leftTimes == 0 then
			text.addEffect(var_9_3, {
				color = cc.c3b(251, 96, 35)
			})
		end
	end

	var_9_0.txt:visible(table.length(arg_9_4.chip) == 0)
	var_9_0.panelSelectSuit:visible(table.length(arg_9_4.chip) > 0)

	if table.length(arg_9_4.chip) > 0 then
		for iter_9_0 = 1, var_0_6 do
			local var_9_4 = (var_9_1:get("item0" .. iter_9_0) or arg_9_2:clone():show():xy(90 * (iter_9_0 - 1), 0):addTo(var_9_1, 1, "item0" .. iter_9_0)):get("imgIcon")
			local var_9_5 = arg_9_4.chip[iter_9_0] ~= nil

			var_9_4:visible(var_9_5)

			if var_9_5 then
				local var_9_6, var_9_7 = next(gChipSuitCsv[arg_9_4.chip[iter_9_0]][6])
				local var_9_8 = string.gsub(var_9_7.suitIcon, "0.png", "2.png")

				var_9_4:texture(var_9_8)
			end
		end
	end

	var_9_0.finshImg:visible(arg_9_4.finish)
end

local function var_0_11(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	arg_10_1:show()

	local var_10_0 = arg_10_1:multiget("selectPanel", "txtPanel", "stateText", "stateImg", "btn", "list", "finshImg")

	var_10_0.selectPanel:hide()
	var_10_0.txtPanel:hide()
	var_10_0.stateText:hide()
	var_10_0.stateImg:hide()
	var_10_0.finshImg:hide()
	var_10_0.btn:hide()
	var_10_0.list:hide()

	if arg_10_4.btnName then
		var_10_0.btn:show()
		var_10_0.btn:get("txtNode"):text(arg_10_4.btnName)
	end

	if arg_10_4.reward then
		var_10_0.list:show()
		uiEasy.createItemsToList(arg_10_0, var_10_0.list, arg_10_4.reward, {
			scale = 0.9
		})
	end

	if arg_10_4.txt or arg_10_4.txt1 then
		var_10_0.txtPanel:show()

		local var_10_1 = var_10_0.txtPanel:get("txt")
		local var_10_2 = var_10_0.txtPanel:get("txt1")

		var_10_1:text(arg_10_4.txt or "")
		var_10_2:text(arg_10_4.txt1 or "")

		local var_10_3 = var_10_0.txtPanel:height() / 2

		if arg_10_4.selected and arg_10_4.selectedType == "center" then
			var_10_3 = var_10_0.txtPanel:height() / 2 + 41
		end

		adapt.oneLineCenterPos(cc.p(var_10_0.txtPanel:width() / 2, var_10_3), {
			var_10_1,
			var_10_2
		}, cc.p(20, 0))

		if arg_10_4.leftTimes and arg_10_4.leftTimes == 0 then
			text.addEffect(var_10_2, {
				color = cc.c3b(251, 96, 35)
			})
		end
	end

	if arg_10_4.rich then
		var_10_0.txtPanel:show()

		local var_10_4 = var_10_0.txtPanel:get("txt")
		local var_10_5 = var_10_0.txtPanel:get("txt1")

		var_10_4:text("")
		var_10_5:text("")
		var_10_4:removeAllChildren()

		local var_10_6 = rich.createByStr(arg_10_4.rich, 40)

		var_10_6:addTo(var_10_4)
		var_10_6:anchorPoint(0.5, 0.5)
		var_10_6:xy(0, 0)
	end

	if arg_10_4.state then
		if arg_10_4.state == var_0_4.canSignUp then
			var_10_0.stateText:show()
			var_10_0.stateText:text(gLanguageCsv.canSignup)
			text.addEffect(var_10_0.stateText, {
				color = cc.c3b(96, 196, 86)
			})
		elseif arg_10_4.state == var_0_4.hadSignUp then
			var_10_0.stateImg:show()
		elseif arg_10_4.state == var_0_4.cantSignUp then
			var_10_0.stateText:show()
			var_10_0.stateText:text(gLanguageCsv.cantSignup)
			text.addEffect(var_10_0.stateText, {
				color = cc.c3b(127, 127, 127)
			})
		end
	end

	if arg_10_4.selected then
		var_10_0.selectPanel:show()

		local var_10_7 = var_10_0.selectPanel:get("sPanel")

		var_10_7:get("select"):visible(arg_10_4.selected == 1)

		local var_10_8 = var_10_0.selectPanel:get("txt")

		var_10_8:text(var_0_2[arg_10_4.feature])

		if var_10_8:width() > var_10_0.btn:width() then
			adapt.oneLinePos(var_10_8, var_10_7, cc.p(5, 0), "right")
		else
			adapt.oneLineCenterPos(cc.p(var_10_0.selectPanel:width() / 2, var_10_0.selectPanel:height() / 2 + 7), {
				var_10_7,
				var_10_8
			}, cc.p(5, 0))
		end

		if arg_10_4.selectedType and arg_10_4.selectedType == "center" then
			local var_10_9 = arg_10_1:width() / 2 - var_10_0.selectPanel:x() + 40

			adapt.oneLineCenterPos(cc.p(var_10_9, var_10_0.selectPanel:height() / 2 + 32), {
				var_10_8,
				var_10_7
			}, cc.p(5, 0))
		end
	end

	if arg_10_4.finish then
		var_10_0.finshImg:show()
	end
end

local var_0_12 = require("app.views.city.union.tools")
local var_0_13 = require("app.views.city.daily_assistant.tools")
local var_0_14 = cc.load("mvc").ViewBase
local var_0_15 = class("DailyAssistantView", var_0_14)

var_0_15.RESOURCE_FILENAME = "daily_assistant.json"
var_0_15.RESOURCE_BINDING = {
	item = "item",
	selectSuitItem = "selectSuitItem",
	tabItem = "tabItem",
	["rightPanel.btnOneClick"] = {
		varname = "btnOneClick",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onBtnOneClick")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					state = bindHelper.self("oneClickShowRedHint"),
					onNode = function(arg_11_0)
						arg_11_0:xy(340, 130)
					end
				}
			}
		}
	},
	["rightPanel.btnOneClick.txtNode"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["item.normalPanel.btn.txtNode"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["rightPanel.bg"] = {
		binds = {
			event = "texture",
			idler = bindHelper.self("rightBgPath")
		}
	},
	["rightPanel.activePanel"] = {
		varname = "activePanel",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnShowActiveNoteClick")
			}
		}
	},
	["rightPanel.activePanel.txtNode"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(176, 89, 41, 255)
				}
			}
		}
	},
	tabList = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("tabItem"),
				onItem = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
					local var_12_0 = arg_12_1:multiget("selected", "normal")

					var_12_0.selected:visible(arg_12_3.selected)
					var_12_0.normal:visible(not arg_12_3.selected)
					var_12_0.selected:get("txtNode"):text(arg_12_3.name)
					var_12_0.normal:get("txtNode"):text(arg_12_3.name)
					arg_12_1:onClick(functools.partial(arg_12_0.clickCell, arg_12_2, arg_12_3))

					if var_0_1[arg_12_2] then
						local var_12_1 = var_0_1[arg_12_2]

						var_12_1.state = not arg_12_3.selected

						bind.extend(arg_12_0, arg_12_1, {
							class = "red_hint",
							props = var_12_1
						})
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("showDatas"),
				item = bindHelper.self("item"),
				suitItem = bindHelper.self("selectSuitItem"),
				dataOrderCmp = function(arg_13_0, arg_13_1)
					return arg_13_0.sortID < arg_13_1.sortID
				end,
				itemAction = {
					isAction = true
				},
				onItem = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
					local var_14_0 = arg_14_1:multiget("title", "activeImg", "unionGatePanel", "normalPanel", "unionRedpacketPanel", "chipPanel")

					var_14_0.title:text(arg_14_3.name)

					local var_14_1 = var_14_0.title:width()
					local var_14_2 = 480

					if var_14_2 < var_14_1 then
						adapt.setTextScaleWithWidth(var_14_0.title, nil, var_14_2)
					end

					var_14_0.activeImg:hide()

					if arg_14_3.active then
						var_14_0.activeImg:show()
					end

					var_14_0.normalPanel:hide()
					var_14_0.unionGatePanel:hide()
					var_14_0.unionRedpacketPanel:hide()
					var_14_0.chipPanel:hide()

					if arg_14_3.type == var_0_0.UNION and arg_14_3.feature == "unionFuben" then
						var_0_8(arg_14_0, var_14_0.unionGatePanel, var_14_0.title, arg_14_2, arg_14_3)
					elseif arg_14_3.type == var_0_0.REWARD and arg_14_3.feature == "unionRedpacket" then
						var_0_9(arg_14_0, var_14_0.unionRedpacketPanel, var_14_0.title, arg_14_2, arg_14_3)
					elseif arg_14_3.type == var_0_0.DRAWCARD and arg_14_3.feature == "chip" then
						var_0_10(arg_14_0, var_14_0.chipPanel, arg_14_0.suitItem, arg_14_2, arg_14_3)
					else
						var_0_11(arg_14_0, var_14_0.normalPanel, var_14_0.title, arg_14_2, arg_14_3)
					end

					bind.touch(arg_14_0, var_14_0.normalPanel:get("btn"), {
						methods = {
							ended = functools.partial(arg_14_0.clickCell, arg_14_2, arg_14_3)
						}
					})
					bind.touch(arg_14_0, var_14_0.unionGatePanel:get("btnReward"), {
						methods = {
							ended = functools.partial(arg_14_0.unionGateCell, arg_14_2, arg_14_3)
						}
					})
					var_14_0.normalPanel:get("selectPanel.sPanel"):onClick(functools.partial(arg_14_0.selectCell, arg_14_2, arg_14_3))
					var_14_0.normalPanel:get("selectPanel.txt"):onClick(functools.partial(arg_14_0.selectCell, arg_14_2, arg_14_3))
				end
			},
			handlers = {
				clickCell = bindHelper.self("onBtnClick"),
				selectCell = bindHelper.self("onSelectClick"),
				unionGateCell = bindHelper.self("onUnionRewardBtnClick")
			}
		}
	}
}

function var_0_15.onCreate(arg_15_0)
	gGameUI.topuiManager:createView("default", arg_15_0, {
		onClose = arg_15_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = "common/txt/txt_bt_richangzhushou.png"
	})
	arg_15_0:initModel()
	arg_15_0.tabSelected:addListener(function(arg_16_0, arg_16_1)
		if arg_16_0 == nil then
			return
		end

		if arg_16_1 then
			arg_15_0.tabDatas:atproxy(arg_16_1).selected = false
		end

		arg_15_0.tabDatas:atproxy(arg_16_0).selected = true

		arg_15_0.btnOneClick:get("txtNode"):text(var_0_5[arg_16_0])
		arg_15_0:setRightBgPath(arg_16_0)
		arg_15_0:updateShowDatas(arg_16_0)

		arg_15_0.errorTips = nil
	end)

	local var_15_0 = 5
	local var_15_1 = {}

	arg_15_0.allDatas = {}

	for iter_15_0, iter_15_1 in pairs(gDailyAssistantCsv) do
		local var_15_2 = iter_15_1.cfg

		if var_15_1[var_15_2.type] == nil then
			var_15_1[var_15_2.type] = {
				selected = false,
				name = var_0_3[var_15_2.type],
				type = var_15_2.type
			}
			var_15_0 = math.min(var_15_0, var_15_2.type)
		end

		if arg_15_0.allDatas[var_15_2.type] == nil then
			arg_15_0.allDatas[var_15_2.type] = {}
		end

		if var_15_2.inUnlock == 0 or dataEasy.isShow(iter_15_0) then
			arg_15_0.allDatas[var_15_2.type][iter_15_0] = {
				csvId = iter_15_1.csvId,
				sortID = var_15_2.sortID,
				name = var_15_2.name,
				type = var_15_2.type,
				feature = var_15_2.features
			}
		end
	end

	arg_15_0.tabDatas:update(var_15_1)
	arg_15_0.tabSelected:set(var_15_0)
	idlereasy.when(arg_15_0.dailyAssistant, function(arg_17_0, arg_17_1)
		if arg_17_1 == nil then
			return
		end

		if arg_15_0.showDatas:atproxy("unionContrib") or arg_15_0.showDatas:atproxy("unionFragDonate") or arg_15_0.showDatas:atproxy("catch") or arg_15_0.showDatas:atproxy("endlessTower") then
			arg_15_0:updateShowDatas(arg_15_0.tabSelected:read())
		end
	end)
	idlereasy.any({
		arg_15_0.curChallengeId,
		arg_15_0.resetCount,
		arg_15_0.maxGateId
	}, function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
		local var_18_0

		if arg_18_1 == 0 then
			var_18_0 = 1
		else
			local var_18_1 = 0

			for iter_18_0, iter_18_1 in orderCsvPairs(csv.endless_tower_scene) do
				var_18_1 = var_18_1 + 1

				if arg_18_1 > 0 and iter_18_0 == arg_18_1 then
					var_18_0 = var_18_1

					break
				end
			end

			var_18_0 = var_18_0 or var_18_1
		end

		arg_15_0.curGateIdx = var_18_0

		if arg_15_0.showDatas:atproxy("endlessTower") then
			arg_15_0:updateShowDatas(arg_15_0.tabSelected:read())
		end
	end)
	idlereasy.any({
		arg_15_0.unionFubenPassed,
		arg_15_0.unionFbTimes,
		arg_15_0.unionFbAward
	}, function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
		if arg_15_0.showDatas:atproxy("unionFuben") then
			arg_15_0:updateShowDatas(arg_15_0.tabSelected:read())
		end
	end)

	if var_0_13.getUnionFubenIsOpen() then
		idlereasy.when(arg_15_0.unionFuben, function(arg_20_0, arg_20_1)
			if arg_20_1 == nil then
				return
			end

			local var_20_0 = {}

			arg_15_0.selectCsvId = 1

			for iter_20_0, iter_20_1 in orderCsvPairs(csv.union.union_fuben) do
				local var_20_1 = csv.scene_conf[iter_20_1.gateID]
				local var_20_2 = arg_20_1[iter_20_0]

				if not itertools.isempty(var_20_2) then
					if iter_20_0 > arg_15_0.selectCsvId then
						arg_15_0.selectCsvId = iter_20_0
					end

					table.insert(var_20_0, {
						csvId = iter_20_0,
						icon = var_20_1.icon,
						buff = var_20_2.buff,
						surplusHp = math.max(var_20_2.hpmax - var_20_2.damage, 0),
						maxHp = var_20_2.hpmax,
						damage = var_20_2.damage,
						time = var_20_2.time
					})
				end
			end

			arg_15_0.unionFubenData:update(var_20_0)
		end)
	end

	idlereasy.any({
		arg_15_0.fishingSelectScene,
		arg_15_0.selectBait,
		arg_15_0.selectRod,
		arg_15_0.items
	}, function(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
		if arg_15_0.showDatas:atproxy("catch") then
			arg_15_0:updateShowDatas(arg_15_0.tabSelected:read())
		end
	end)
	idlereasy.when(arg_15_0.lianjinTimes, function(arg_22_0, arg_22_1)
		if arg_15_0.showDatas:atproxy("gainGold") then
			arg_15_0:updateShowDatas(arg_15_0.tabSelected:read())
		end
	end)
	arg_15_0.btnOnekeyState:addListener(function(arg_23_0, arg_23_1)
		if arg_23_0 == nil then
			return
		end

		local var_23_0 = arg_23_0.leftFinished > 0 and "normal" or "hsl_gray"

		cache.setShader(arg_15_0.btnOneClick, false, var_23_0)
		arg_15_0.btnOneClick:setTouchEnabled(arg_23_0.leftFinished > 0)
	end)
end

function var_0_15.initModel(arg_24_0)
	arg_24_0.dailyAssistant = gGameModel.role:getIdler("daily_assistant")
	arg_24_0.rmb = gGameModel.role:getIdler("rmb")
	arg_24_0.items = gGameModel.role:getIdler("items")
	arg_24_0.level = gGameModel.role:getIdler("level")
	arg_24_0.vip = gGameModel.role:getIdler("vip_level")
	arg_24_0.unionFbAward = gGameModel.role:getIdler("union_fb_award")
	arg_24_0.unionFubenPassed = gGameModel.role:getIdler("union_fuben_passed")
	arg_24_0.unionId = gGameModel.role:getIdler("union_db_id")
	arg_24_0.crossFishingRound = gGameModel.role:getIdler("cross_fishing_round")
	arg_24_0.unionLevel = gGameModel.role:getIdler("union_level")
	arg_24_0.curChallengeId = gGameModel.role:getIdler("endless_tower_current")
	arg_24_0.maxGateId = gGameModel.role:getIdler("endless_tower_max_gate")

	local var_24_0 = gGameModel.daily_record

	arg_24_0.resetCount = var_24_0:getIdler("endless_tower_reset_times")
	arg_24_0.lianjinTimes = var_24_0:getIdler("lianjin_times")
	arg_24_0.lianjinFreeTimes = gGameModel.daily_record:getIdler("lianjin_free_times")
	arg_24_0.unionTrainingSpeedup = var_24_0:getIdler("union_training_speedup")
	arg_24_0.unionFbTimes = var_24_0:getIdler("union_fb_times")
	arg_24_0.dailyGiftTimes = var_24_0:getIdler("union_daily_gift_times")

	if var_0_13.getUnionFubenIsOpen() then
		arg_24_0.unionFuben = gGameModel.union_fuben:getIdler("states")
	end

	arg_24_0.fishingSelectScene = gGameModel.fishing:getIdler("select_scene")
	arg_24_0.autoFishing = gGameModel.fishing:getIdler("is_auto")
	arg_24_0.selectRod = gGameModel.fishing:getIdler("select_rod")
	arg_24_0.selectBait = gGameModel.fishing:getIdler("select_bait")
	arg_24_0.tabDatas = idlers.new()
	arg_24_0.showDatas = idlers.new()
	arg_24_0.tabSelected = idler.new()
	arg_24_0.btnOnekeyState = idlertable.new()
	arg_24_0.unionFubenData = idlers.new()
	arg_24_0.rightBgPath = idler.new("city/daily_assistant/img_assistant_1.png")
	arg_24_0.curGateIdx = 1
	arg_24_0.oneClickShowRedHint = idler.new(false)
	arg_24_0.errorTips = nil
end

local var_0_16 = {
	unionDailyGift = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
		if arg_25_0.unionId:read() and arg_25_0.unionLevel:read() then
			local var_25_0, var_25_1 = var_0_13.getUnionLockAndText(arg_25_1.feature)

			if var_25_0 then
				arg_25_1.txt = var_25_1
				arg_25_1.finishFlag = true
			else
				arg_25_1.reward = csv.union.union_level[arg_25_0.unionLevel:read()].dailyGift
				arg_25_1.finish = arg_25_0.dailyGiftTimes:read() > 0
				arg_25_1.finishFlag = arg_25_1.finish
			end
		else
			arg_25_1.txt = gLanguageCsv.nonunion
			arg_25_1.finishFlag = true
		end
	end,
	unionRedpacket = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
		if not arg_26_0.unionId:read() or not arg_26_0.unionLevel:read() then
			arg_26_1.txt = gLanguageCsv.nonunion
			arg_26_1.finishFlag = true
		else
			local var_26_0, var_26_1 = var_0_13.getUnionLockAndText(arg_26_1.feature)

			if var_26_0 then
				arg_26_1.txt = var_26_1
				arg_26_1.finishFlag = true
			else
				arg_26_1.finish = not gGameModel.role:read("union_sys_packet_can_rob")
				arg_26_1.finishFlag = arg_26_1.finish
			end
		end
	end,
	trainer = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
		arg_27_1.finish = gGameModel.daily_record:read("trainer_gift_times") > 0
		arg_27_1.finishFlag = arg_27_1.finish

		local var_27_0 = gGameModel.role:read("trainer_level")

		arg_27_1.reward = csv.trainer.trainer_level[var_27_0].dailyAward
	end,
	gainGold = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
		local var_28_0, var_28_1 = var_0_13.getGainGoldTimes(arg_28_0.lianjinTimes:read(), arg_28_0.lianjinFreeTimes:read())

		arg_28_1.rich = var_28_0
		arg_28_1.finish = var_28_1 == 0
		arg_28_1.finishFlag = arg_28_1.finish
		arg_28_1.leftTimes = var_28_1
		arg_28_1.active = dataEasy.isDoubleHuodong("buyGold")

		if arg_28_1.active then
			local var_28_2, var_28_3 = var_0_13.getActiveText("buyGold")

			if var_28_2 then
				local var_28_4 = string.format("%s: %s", gDailyAssistantCsv[arg_28_1.feature].cfg.name, var_28_2)

				if var_28_3 then
					var_28_4 = string.format("%s、%s", var_28_4, gLanguageCsv.reunion)
				end

				table.insert(arg_28_3, var_28_4)
			end
		end
	end,
	drawCardRmb = function(arg_29_0, arg_29_1)
		local var_29_0 = gGameModel.daily_record:read("dc1_free_count") < 1

		arg_29_1.txt = gLanguageCsv.dailyAssistantFreeDrawCard

		local var_29_1 = var_29_0 and 1 or 0

		arg_29_1.txt1 = string.format("%s/1", var_29_1)
		arg_29_1.finish = var_29_1 == 0
		arg_29_1.finishFlag = arg_29_1.finish
		arg_29_1.leftTimes = var_29_1
	end,
	drawCardGold = function(arg_30_0, arg_30_1)
		local var_30_0 = dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.FreeGoldDrawCardTimes)
		local var_30_1 = gGameModel.daily_record:read("gold1_free_count")
		local var_30_2 = gGameModel.daily_record:read("draw_card_gold1_trainer")

		arg_30_1.txt = gLanguageCsv.dailyAssistantFreeDrawCard

		local var_30_3 = gCommonConfigCsv.drawGoldFreeLimit + var_30_0
		local var_30_4 = var_30_3 - var_30_1 - var_30_2

		arg_30_1.txt1 = string.format("%s/%s", var_30_4, var_30_3)
		arg_30_1.finish = var_30_4 == 0
		arg_30_1.finishFlag = arg_30_1.finish
		arg_30_1.leftTimes = var_30_4
	end,
	drawEquip = function(arg_31_0, arg_31_1)
		local var_31_0 = gGameModel.daily_record:read("eq_dc1_free_counter") < 1

		arg_31_1.txt = gLanguageCsv.dailyAssistantFreeDrawCard

		local var_31_1 = var_31_0 and 1 or 0

		arg_31_1.txt1 = string.format("%s/1", var_31_1)
		arg_31_1.finish = var_31_1 == 0
		arg_31_1.finishFlag = arg_31_1.finish
		arg_31_1.leftTimes = var_31_1
	end,
	explorer = function(arg_32_0, arg_32_1)
		local var_32_0 = dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.DrawItemFreeTimes)
		local var_32_1 = gGameModel.daily_record:read("item_dc1_free_counter")

		arg_32_1.txt = gLanguageCsv.dailyAssistantFreeDrawCardItem

		local var_32_2 = math.max(var_32_0 + 1 - var_32_1, 0)

		arg_32_1.txt1 = string.format("%s/%s", var_32_2, var_32_0 + 1)
		arg_32_1.finish = var_32_2 == 0
		arg_32_1.finishFlag = arg_32_1.finish
		arg_32_1.leftTimes = var_32_2
	end,
	gem = function(arg_33_0, arg_33_1)
		local var_33_0 = gGameModel.daily_record:read("gem_gold_dc1_free_count")
		local var_33_1 = gGameModel.daily_record:read("gem_rmb_dc1_free_count")
		local var_33_2 = math.max(2 - var_33_0 - var_33_1, 0)

		arg_33_1.txt = gLanguageCsv.dailyAssistantFreeGem
		arg_33_1.txt1 = string.format("%s/2", var_33_2)
		arg_33_1.finish = var_33_2 == 0
		arg_33_1.finishFlag = arg_33_1.finish

		if var_33_2 > 0 then
			arg_33_1.selected = userDefault.getForeverLocalKey("gemDrawAutoDecompose", false) and 1 or 0
			arg_33_1.selectedType = "center"
		end

		arg_33_1.leftTimes = var_33_2
	end,
	chip = function(arg_34_0, arg_34_1)
		local var_34_0 = gGameModel.daily_record:read("chip_item_dc1_free_count")
		local var_34_1 = gGameModel.daily_record:read("chip_rmb_dc1_free_count")
		local var_34_2 = math.max(2 - var_34_0 - var_34_1, 0)

		arg_34_1.txt = gLanguageCsv.dailyAssistantFreeGem
		arg_34_1.txt1 = string.format("%s/2", var_34_2)
		arg_34_1.finish = var_34_2 == 0
		arg_34_1.finishFlag = arg_34_1.finish
		arg_34_1.leftTimes = var_34_2

		local var_34_3 = {}
		local var_34_4 = userDefault.getForeverLocalKey("selectUpSuitID", {})

		for iter_34_0 = 1, var_0_6 do
			if var_34_4[iter_34_0] ~= 0 then
				table.insert(var_34_3, var_34_4[iter_34_0])
			end
		end

		arg_34_1.chip = var_34_3
	end,
	totemDraw = function(arg_35_0, arg_35_1)
		if dataEasy.isTotemUnlock() then
			local var_35_0 = gGameModel.daily_record:read("totem_rmb_dc1_free_count") < 1

			arg_35_1.txt = gLanguageCsv.dailyAssistantTotemDraw

			local var_35_1 = var_35_0 and 1 or 0

			arg_35_1.txt1 = string.format("%s/1", var_35_1)
			arg_35_1.finish = var_35_1 == 0
			arg_35_1.finishFlag = arg_35_1.finish
			arg_35_1.leftTimes = var_35_1
		else
			local var_35_2 = gUnlockCsv.totem
			local var_35_3 = csv.unlock[var_35_2]

			arg_35_1.txt = string.format(gLanguageCsv.totemTownExplorationUnlock, var_35_3.startLevel)
		end
	end,
	craft = function(arg_36_0, arg_36_1)
		local var_36_0, var_36_1 = dataEasy.judgeServerOpen("craft")

		if not var_36_0 and var_36_1 then
			arg_36_1.txt = string.format(gLanguageCsv.unlockServerOpen, var_36_1)
		else
			arg_36_1.state = var_0_13.getCraftState()
			arg_36_1.txt = gLanguageCsv.dailyAssistantCraftText
		end
	end,
	unionFight = function(arg_37_0, arg_37_1)
		if not arg_37_0.unionId:read() or not arg_37_0.unionLevel:read() then
			arg_37_1.txt = gLanguageCsv.nonunion
		else
			local var_37_0, var_37_1 = var_0_13.getUnionLockAndText(arg_37_1.feature)

			if var_37_0 then
				arg_37_1.txt = var_37_1
			else
				arg_37_1.state = var_0_13.getUnionFightState()
				arg_37_1.txt = gLanguageCsv.dailyAssistantUnionFighttText
			end
		end
	end,
	crossCraft = function(arg_38_0, arg_38_1)
		local var_38_0, var_38_1 = dataEasy.judgeServerOpen("crossCraft")

		if not var_38_0 and var_38_1 then
			arg_38_1.txt = string.format(gLanguageCsv.unlockServerOpen, var_38_1)
		else
			arg_38_1.state = var_0_13.getCrossCraftState()
			arg_38_1.txt = gLanguageCsv.dailyAssistantCrossCraftText
		end
	end,
	activityGate = function(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
		local var_39_0, var_39_1, var_39_2, var_39_3, var_39_4 = var_0_13.getActivityGateInfo()

		arg_39_1.txt = gLanguageCsv.dailyAssistantLeftTimes
		arg_39_1.txt1 = string.format("%s/%s", var_39_0, var_39_1)

		if var_39_0 == 0 then
			arg_39_1.finishFlag = true
		end

		arg_39_1.leftTimes = var_39_0

		local var_39_5, var_39_6 = dataEasy.isShowDailyActivityIcon()

		arg_39_1.active = var_39_5 or var_39_3

		if arg_39_1.active then
			local var_39_7 = ""

			local function var_39_8(arg_40_0)
				if string.len(var_39_7) > 0 then
					var_39_7 = var_39_7 .. gLanguageCsv.symbolComma
				end

				var_39_7 = var_39_7 .. arg_40_0
			end

			for iter_39_0, iter_39_1 in ipairs(var_39_2) do
				var_39_8(iter_39_1)
			end

			if var_39_5 then
				var_39_8(var_39_6.name)
			end

			if var_39_4 then
				var_39_8(gLanguageCsv.reunion)
			end

			if string.len(var_39_7) > 0 then
				var_39_7 = string.format("%s: %s", gDailyAssistantCsv[arg_39_1.feature].cfg.name, var_39_7)

				table.insert(arg_39_3, var_39_7)
			end
		end

		arg_39_2[arg_39_1.feature] = var_39_0
	end,
	endlessTower = function(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
		local var_41_0, var_41_1, var_41_2 = var_0_13.getEndlessLeftTimes()

		arg_41_1.btnName = var_41_0
		arg_41_1.selected = arg_41_0.dailyAssistant:read().endless_buy_reset

		local var_41_3 = arg_41_0.curChallengeId:read() >= arg_41_0.maxGateId:read()

		if var_41_3 and (arg_41_1.selected == 0 or var_41_1 == 0) then
			arg_41_1.finishFlag = true
		end

		arg_41_1.rich = string.format(gLanguageCsv.dailyAssistantEndlessGate, arg_41_0.curGateIdx)
		arg_41_1.active = dataEasy.isDoubleHuodong("endlessSaodang")

		if arg_41_1.active then
			local var_41_4, var_41_5 = var_0_13.getActiveText("endlessSaodang")

			if var_41_4 then
				local var_41_6 = string.format("%s: %s", gDailyAssistantCsv[arg_41_1.feature].cfg.name, var_41_4)

				if var_41_5 then
					var_41_6 = string.format("%s、%s", var_41_6, gLanguageCsv.reunion)
				end

				table.insert(arg_41_3, var_41_6)
			end
		end

		arg_41_2[arg_41_1.feature] = var_41_3 and var_41_1 or var_41_1 + 1
	end,
	catch = function(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
		if not dataEasy.isUnlock("fishing") then
			arg_42_1.txt = dataEasy.getUnlockTip("fishing")
			arg_42_1.finishFlag = true
		else
			arg_42_1.selected = arg_42_0.dailyAssistant:read().fishing_skip

			local var_42_0, var_42_1, var_42_2 = var_0_13.getFishingText()

			arg_42_1.rich = var_42_0
			arg_42_1.btnName = gLanguageCsv.adjustment

			if var_42_2 == 0 then
				arg_42_1.finishFlag = true
			end

			arg_42_1.active = arg_42_0.crossFishingRound:read() == "start"

			if arg_42_1.active then
				local var_42_3 = string.format("%s: %s", gDailyAssistantCsv[arg_42_1.feature].cfg.name, gLanguageCsv.FishingCompetition)

				table.insert(arg_42_3, var_42_3)
			end

			arg_42_2[arg_42_1.feature] = var_42_1
		end
	end,
	unionContrib = function(arg_43_0, arg_43_1, arg_43_2)
		local var_43_0, var_43_1 = var_0_13.getUnionLockAndText(arg_43_1.feature)

		if var_43_0 then
			arg_43_1.txt = var_43_1
		else
			arg_43_1.btnName = gLanguageCsv.replacementMethod

			local var_43_2, var_43_3 = var_0_13.getUnionContribText()

			arg_43_1.rich = var_43_2
			arg_43_2[arg_43_1.feature] = var_43_3
		end
	end,
	unionFragDonate = function(arg_44_0, arg_44_1, arg_44_2)
		local var_44_0, var_44_1 = var_0_13.getUnionLockAndText(arg_44_1.feature)

		if var_44_0 then
			arg_44_1.txt = var_44_1
		else
			arg_44_1.btnName = gLanguageCsv.spaceExchange2

			local var_44_2, var_44_3 = var_0_13.getUnionFragDonateText()

			arg_44_1.rich = var_44_2
			arg_44_2[arg_44_1.feature] = var_44_3
		end
	end,
	unionTrainingSpeedup = function(arg_45_0, arg_45_1, arg_45_2)
		local var_45_0, var_45_1 = var_0_13.getUnionLockAndText(arg_45_1.feature)

		if var_45_0 then
			arg_45_1.txt = var_45_1
		else
			local var_45_2 = math.max(6 - arg_45_0.unionTrainingSpeedup:read(), 0)

			arg_45_1.txt = gLanguageCsv.dailyAssistantSpeedTimes
			arg_45_1.txt1 = string.format("%s/6", var_45_2)
			arg_45_1.leftTimes = var_45_2
			arg_45_2[arg_45_1.feature] = var_45_2
		end
	end,
	unionFuben = function(arg_46_0, arg_46_1, arg_46_2)
		local var_46_0, var_46_1 = var_0_13.getUnionLockAndText(arg_46_1.feature)

		if var_46_0 then
			arg_46_1.errTxt = var_46_1
		else
			if var_0_12.currentOpenFuben() == "weekError" then
				arg_46_1.errTxt = gLanguageCsv.fubenClosedOnSunday
			elseif var_0_12.currentOpenFuben() ~= "open" then
				arg_46_1.errTxt = gLanguageCsv.unionFubenNoOpen
			else
				arg_46_1.txt = gLanguageCsv.changeTimes .. ":"

				local var_46_2, var_46_3 = var_0_13.getUnionFubenTimes()

				arg_46_1.txt1 = var_46_2

				if arg_46_0.selectCsvId then
					arg_46_1.data = arg_46_0.unionFubenData:atproxy(arg_46_0.selectCsvId)
				end

				arg_46_1.leftTimes = var_46_3
				arg_46_2[arg_46_1.feature] = var_46_3
			end

			arg_46_1.hasReward = dataEasy.haveUnionFubenReward()
		end
	end
}
local var_0_17 = {
	[var_0_0.SIGNUP] = function(arg_47_0, arg_47_1)
		return arg_47_0.state == nil or arg_47_0.state == var_0_4.hadSignUp or arg_47_0.state == var_0_4.cantSignUp
	end,
	[var_0_0.UNION] = function(arg_48_0, arg_48_1)
		return not arg_48_1[arg_48_0.feature] or arg_48_1[arg_48_0.feature] == 0
	end
}

function var_0_15.updateShowDatas(arg_49_0, arg_49_1)
	local var_49_0 = table.deepcopy(arg_49_0.allDatas[arg_49_1], true)
	local var_49_1 = itertools.size(var_49_0)
	local var_49_2 = {}
	local var_49_3 = {}

	for iter_49_0, iter_49_1 in pairs(var_49_0) do
		if gDailyAssistantCsv[iter_49_1.feature].cfg.inUnlock == 1 and not dataEasy.isUnlock(iter_49_1.feature) then
			iter_49_1.txt = dataEasy.getUnlockTip(iter_49_1.feature)
			var_49_1 = var_49_1 - 1
		else
			var_0_16[iter_49_1.feature](arg_49_0, iter_49_1, var_49_2, var_49_3)

			if var_0_17[arg_49_1] and var_0_17[arg_49_1](iter_49_1, var_49_2) then
				iter_49_1.finishFlag = true
			end

			if iter_49_1.finishFlag then
				var_49_1 = var_49_1 - 1
			end
		end

		iter_49_1.finishFlag = nil
	end

	if arg_49_1 == 2 and dataEasy.isTotemUnlock() == false then
		var_49_1 = var_49_1 - 1
	end

	arg_49_0.activePanel:visible(not itertools.isempty(var_49_3))
	arg_49_0.btnOnekeyState:set({
		showType = arg_49_1,
		leftFinished = var_49_1,
		featuresLeftTimes = var_49_2,
		activeTxt = var_49_3
	})
	arg_49_0.oneClickShowRedHint:set(var_49_1 > 0)
	arg_49_0.showDatas:update(var_49_0)
end

function var_0_15.onTabClick(arg_50_0, arg_50_1, arg_50_2, arg_50_3)
	if arg_50_2 == var_0_0.UNION and (not arg_50_0.unionId:read() or not arg_50_0.unionLevel:read()) then
		gGameUI:showTip(gLanguageCsv.nonunion)

		return
	end

	arg_50_0.tabSelected:set(arg_50_2)
end

function var_0_15.onBtnClick(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
	if arg_51_3.feature == "endlessTower" then
		if gVipCsv[arg_51_0.vip:read()].endlessTowerResetTimes - arg_51_0.resetCount:read() <= 0 then
			gGameUI:showTip(gLanguageCsv.resetTimesNotEnough)

			return
		end

		if arg_51_0.curGateIdx == 1 then
			gGameUI:showTip(gLanguageCsv.cannotResetGate)

			return
		end

		local var_51_0 = math.min(arg_51_0.resetCount:read() + 1, table.length(gCostCsv.endless_tower_reset_times_cost))
		local var_51_1 = gCostCsv.endless_tower_reset_times_cost[var_51_0]
		local var_51_2 = {
			clearFast = true,
			btnType = 2,
			cb = function()
				if var_51_1 > 0 and arg_51_0.rmb:read() < var_51_1 then
					uiEasy.showDialog("rmb")

					return
				end

				gGameApp:requestServer("/game/endless/reset")

				arg_51_0.errorTips = nil
			end,
			isRich = var_51_1 ~= 0,
			content = var_51_1 == 0 and gLanguageCsv.resetGate or string.format(gLanguageCsv.endlessTowerResetCost, var_51_1)
		}

		gGameUI:showDialog(var_51_2)
	elseif arg_51_3.feature == "catch" then
		if arg_51_0.autoFishing:read() then
			gGameUI:showTip(gLanguageCsv.dailyAssistantAutoFishingTips)

			return
		end

		gGameUI:stackUI("city.daily_assistant.fishing_select")
	elseif arg_51_3.feature == "unionContrib" then
		local function var_51_3(arg_53_0, arg_53_1)
			arg_51_0:setInfo(arg_53_1, arg_51_3.csvId, arg_53_0)
		end

		gGameUI:stackUI("city.daily_assistant.union_contribute", nil, nil, {
			callBack = var_51_3
		})
	elseif arg_51_3.feature == "unionFragDonate" then
		local function var_51_4(arg_54_0, arg_54_1)
			arg_51_0:setInfo(arg_54_1, arg_51_3.csvId, arg_54_0)
		end

		gGameUI:stackUI("city.union.frag_donate.wish", nil, nil, {
			isDailySelected = true,
			callBack = var_51_4
		})
	end
end

function var_0_15.onSelectClick(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
	local var_55_0

	local function var_55_1(arg_56_0)
		arg_55_0:setInfo(nil, arg_55_3.csvId, arg_56_0)
	end

	if arg_55_3.feature == "catch" then
		local var_55_2 = arg_55_0.dailyAssistant:read().fishing_skip or 1

		if var_55_2 == 1 then
			gGameUI:showDialog({
				btnType = 2,
				clearFast = true,
				content = gLanguageCsv.dailyAssistantFishTip,
				cb = function()
					var_55_1(0)
				end
			})
		else
			var_55_1(var_55_2 == 1 and 0 or 1)
		end
	elseif arg_55_3.feature == "endlessTower" then
		local var_55_3 = arg_55_0.dailyAssistant:read().endless_buy_reset or 0

		var_55_1(var_55_3 == 1 and 0 or 1)
	elseif arg_55_3.feature == "gem" then
		local var_55_4 = userDefault.getForeverLocalKey("gemDrawAutoDecompose", false)

		userDefault.setForeverLocalKey("gemDrawAutoDecompose", not var_55_4)

		arg_55_0.showDatas:atproxy("gem").selected = not var_55_4 and 1 or 0
	end
end

function var_0_15.onUnionRewardBtnClick(arg_58_0, arg_58_1, arg_58_2, arg_58_3)
	if not dataEasy.haveUnionFubenReward() then
		gGameUI:showTip(gLanguageCsv.noRewardAvailable)

		return
	end

	gGameUI:stackUI("city.union.gate.reward", nil, nil, arg_58_0.unionFuben:read(), arg_58_0:createHandler("onRewardCb"))
end

function var_0_15.onRewardCb(arg_59_0, arg_59_1, arg_59_2)
	local var_59_0

	if arg_59_2 then
		var_59_0 = {
			cb = arg_59_2
		}
	end

	gGameUI:showGainDisplay(arg_59_1, var_59_0)
end

function var_0_15.setRightBgPath(arg_60_0, arg_60_1)
	arg_60_0.rightBgPath:set(string.format("city/daily_assistant/img_assistant_%s.png", arg_60_1))
end

function var_0_15.setInfo(arg_61_0, arg_61_1, arg_61_2, arg_61_3, arg_61_4)
	gGameApp:requestServer("/game/daily/assistant/set", function(arg_62_0)
		if arg_62_0.ret then
			for iter_62_0, iter_62_1 in pairs(gDailyAssistantCsv) do
				if iter_62_1.csvId == arg_61_2 then
					local var_62_0

					if iter_62_0 == "unionContrib" then
						local var_62_1 = arg_61_0.dailyAssistant:read().union_contrib or 1

						var_62_0 = gLanguageCsv[csv.union.contrib[var_62_1].title]
					elseif iter_62_0 == "unionFragDonate" then
						var_62_0 = var_0_13.getCardFragmentsName(arg_61_0.dailyAssistant:read().union_frag_donate_card_id)
					end

					if var_62_0 then
						gGameUI:showTip(string.format(gLanguageCsv.dailyAssistantChangeSuccess, var_62_0))
					end

					break
				end
			end

			arg_61_0.errorTips = nil
		end

		if arg_61_1 then
			arg_61_1()
		end
	end, arg_61_2, arg_61_3, arg_61_4)
end

local var_0_18 = {
	drawCardRmb = function(arg_63_0, arg_63_1)
		arg_63_1.carddbIDs = arg_63_0[1].carddbIDs
	end,
	drawCardGold = function(arg_64_0, arg_64_1)
		for iter_64_0, iter_64_1 in pairs(arg_64_0) do
			local var_64_0 = iter_64_1.items[1][1]

			arg_64_1[var_64_0] = (arg_64_1[var_64_0] or 0) + iter_64_1.items[1][2]
		end
	end,
	drawEquip = function(arg_65_0, arg_65_1)
		local var_65_0 = arg_65_0[1].items[1][1]

		arg_65_1[var_65_0] = (arg_65_1[var_65_0] or 0) + arg_65_0[1].items[1][2]
	end,
	explorer = function(arg_66_0, arg_66_1)
		local var_66_0 = arg_66_0[1][1][1][1]

		arg_66_1[var_66_0] = (arg_66_1[var_66_0] or 0) + arg_66_0[1][1][1][2]
	end,
	gem = function(arg_67_0, arg_67_1)
		for iter_67_0, iter_67_1 in pairs(arg_67_0) do
			for iter_67_2, iter_67_3 in pairs(iter_67_1.items) do
				local var_67_0 = iter_67_3[1]

				arg_67_1[var_67_0] = (arg_67_1[var_67_0] or 0) + iter_67_3[2]
			end
		end
	end,
	chip = function(arg_68_0, arg_68_1)
		for iter_68_0, iter_68_1 in pairs(arg_68_0) do
			if iter_68_1.chipdbIDs then
				if arg_68_1.chipdbIDs == nil then
					arg_68_1.chipdbIDs = {}
				end

				table.insert(arg_68_1.chipdbIDs, iter_68_1.chipdbIDs[1])
			elseif iter_68_1.items then
				for iter_68_2, iter_68_3 in pairs(iter_68_1.items) do
					local var_68_0 = iter_68_3[1]

					arg_68_1[var_68_0] = (arg_68_1[var_68_0] or 0) + iter_68_3[2]
				end
			end
		end
	end,
	totemDraw = function(arg_69_0, arg_69_1)
		local var_69_0 = arg_69_0[1].items[1][1]

		arg_69_1[var_69_0] = (arg_69_1[var_69_0] or 0) + arg_69_0[1].items[1][2]
	end,
	unionDailyGift = var_0_7,
	unionRedpacket = var_0_7,
	trainer = var_0_7,
	gainGold = function(arg_70_0, arg_70_1)
		var_0_7(arg_70_0, arg_70_1, "gold")
	end
}

local function var_0_19(arg_71_0, arg_71_1)
	if arg_71_0 == "" then
		arg_71_0 = string.format("[ %s ]", arg_71_1)
	else
		arg_71_0 = string.format("%s%s [ %s ]", arg_71_0, gLanguageCsv.symbolComma, arg_71_1)
	end

	return arg_71_0
end

function var_0_15.sendOnekey(arg_72_0, arg_72_1, arg_72_2, arg_72_3)
	local var_72_0 = arg_72_0.tabSelected:read()
	local var_72_1 = arg_72_0.btnOnekeyState:read().featuresLeftTimes

	if itertools.isempty(arg_72_1) then
		arg_72_1 = nil
	end

	gGameApp:requestServer("/game/daily/assistant/onekey", function(arg_73_0)
		arg_72_0:updateShowDatas(var_72_0)

		local var_73_0 = arg_73_0.view
		local var_73_1 = ""

		if var_72_0 == var_0_0.SIGNUP then
			local var_73_2 = ""

			for iter_73_0, iter_73_1 in pairs(var_73_0) do
				for iter_73_2, iter_73_3 in pairs(arg_72_0.allDatas[var_72_0]) do
					if iter_73_3.csvId == iter_73_0 then
						if iter_73_1 == 1 then
							var_73_1 = var_0_19(var_73_1, iter_73_3.name)

							break
						elseif type(iter_73_1) == "table" and iter_73_1.errorID then
							var_73_2 = var_0_19(var_73_2, iter_73_3.name)

							break
						end
					end
				end
			end

			if var_73_1 ~= "" or var_73_2 ~= "" then
				if var_73_1 ~= "" then
					var_73_1 = string.format("%s %s", var_73_1, gLanguageCsv.signUpSuccess)
				end

				if var_73_2 ~= "" then
					if var_73_1 ~= "" then
						var_73_1 = var_73_1 .. ","
					end

					var_73_1 = string.format("%s %s %s", var_73_1, var_73_2, gLanguageCsv.signUpFailed)
				end

				gGameUI:showTip(var_73_1)
			end

			return
		else
			for iter_73_4, iter_73_5 in pairs(var_73_0) do
				for iter_73_6, iter_73_7 in pairs(arg_72_0.allDatas[var_72_0]) do
					if iter_73_7.csvId == iter_73_4 and type(iter_73_5) == "table" and iter_73_5.errorID then
						var_73_1 = gLanguageCsv[iter_73_5.errorID] or iter_73_5.errorID
						var_73_0[iter_73_4] = nil

						break
					end
				end
			end
		end

		if var_72_0 == var_0_0.REWARD or var_72_0 == var_0_0.DRAWCARD then
			if not itertools.isempty(var_73_0) then
				local var_73_3 = {}
				local var_73_4 = csv.daily_assistant

				for iter_73_8, iter_73_9 in pairs(var_73_0) do
					local var_73_5 = var_73_4[iter_73_8].features

					var_0_18[var_73_5](iter_73_9, var_73_3)
				end

				arg_72_0:onRewardCb(var_73_3)
			end

			if var_73_1 ~= "" then
				gGameUI:showTip(var_73_1)
			end
		elseif var_72_0 == var_0_0.ADVENTURE or var_72_0 == var_0_0.UNION then
			arg_72_0:showSweepView(var_72_1, var_73_0, arg_72_2)
		end
	end, var_72_0, arg_72_1, arg_72_3)
end

function var_0_15.sendRequestServerOnekey(arg_74_0, arg_74_1)
	local var_74_0 = arg_74_0.tabSelected:read()
	local var_74_1 = arg_74_0.btnOnekeyState:read()
	local var_74_2 = table.deepcopy(arg_74_0.allDatas[var_74_0], true)
	local var_74_3 = {}
	local var_74_4 = {}
	local var_74_5 = {}

	local function var_74_6(arg_75_0, arg_75_1)
		gGameUI:showDialog({
			clearFast = true,
			btnType = 2,
			content = arg_75_0.content,
			cb = function()
				if not arg_75_0.okInput or arg_75_0.okInput() then
					arg_75_1()
				end
			end,
			cancelCb = function()
				if not arg_75_0.cancelInput or arg_75_0.cancelInput() then
					arg_75_1()
				end
			end,
			isRich = arg_75_0.isRich or false
		})
	end

	local function var_74_7()
		if itertools.isempty(var_74_5) then
			arg_74_0:sendOnekey(var_74_4, arg_74_1, var_74_3)
		else
			local var_78_0 = table.deepcopy(var_74_5[1])

			table.remove(var_74_5, 1)
			var_74_6(var_78_0, var_74_7)
		end
	end

	for iter_74_0, iter_74_1 in pairs(var_74_2) do
		local var_74_8 = gDailyAssistantCsv[iter_74_0].csvId

		if iter_74_0 == "endlessTower" then
			var_74_3[var_74_8] = 0

			local var_74_9 = arg_74_0.dailyAssistant:read().endless_buy_reset
			local var_74_10 = gVipCsv[arg_74_0.vip:read()].endlessTowerResetTimes
			local var_74_11 = arg_74_0.resetCount:read()

			if var_74_9 == 1 and var_74_10 > 1 and var_74_11 < 2 then
				local var_74_12 = 0

				for iter_74_2 = var_74_11 + 1, var_74_10 do
					local var_74_13 = math.min(iter_74_2, table.length(gCostCsv.endless_tower_reset_times_cost))

					var_74_12 = var_74_12 + gCostCsv.endless_tower_reset_times_cost[var_74_13]
				end

				local var_74_14 = string.format(gLanguageCsv.dailyAssistantEndlessTip1, var_74_12)

				table.insert(var_74_5, {
					isRich = true,
					content = var_74_14,
					okInput = function()
						if var_74_12 > 0 and arg_74_0.rmb:read() < var_74_12 then
							uiEasy.showDialog("rmb")

							return false
						else
							var_74_3[var_74_8] = 1

							return true
						end
					end
				})
			end
		elseif iter_74_0 == "catch" then
			if arg_74_0.autoFishing:read() then
				table.insert(var_74_4, var_74_8)
			end
		elseif iter_74_0 == "gem" then
			var_74_3[var_74_8] = userDefault.getForeverLocalKey("gemDrawAutoDecompose", false) and 1 or 0
		elseif iter_74_0 == "chip" then
			local var_74_15 = userDefault.getForeverLocalKey("selectUpSuitID", {})
			local var_74_16 = {}

			for iter_74_3, iter_74_4 in ipairs(var_74_15) do
				if iter_74_4 ~= 0 then
					table.insert(var_74_16, iter_74_4)
				end
			end

			var_74_3[var_74_8] = var_74_16
		end
	end

	var_74_7()
end

local var_0_20 = {
	catch = function(arg_80_0, arg_80_1, arg_80_2, arg_80_3, arg_80_4)
		if arg_80_1 > 0 and arg_80_2 then
			local var_80_0 = {
				fish = arg_80_2.fish
			}

			table.insert(arg_80_3, {
				exp = arg_80_2.win,
				items = var_80_0,
				dailyDatas = {
					feature = arg_80_0,
					win = arg_80_2.win,
					fail = arg_80_2.fail
				}
			})
			table.insert(arg_80_3, {
				textDatas = {
					content = gLanguageCsv.textReward
				}
			})
			table.insert(arg_80_3, {
				noTitle = true,
				items = arg_80_2.award
			})

			return false
		end

		return true
	end,
	activityGate = function(arg_81_0, arg_81_1, arg_81_2, arg_81_3, arg_81_4)
		if arg_81_2 and not itertools.isempty(arg_81_2) then
			table.insert(arg_81_3, {
				exp = arg_81_1,
				items = arg_81_2,
				dailyDatas = {
					feature = arg_81_0
				}
			})

			return false
		end

		return true
	end,
	endlessTower = function(arg_82_0, arg_82_1, arg_82_2, arg_82_3, arg_82_4)
		if arg_82_2 and not itertools.isempty(arg_82_2) then
			table.insert(arg_82_3, {
				exp = arg_82_1,
				items = arg_82_2,
				dailyDatas = {
					feature = arg_82_0
				}
			})

			return false
		end

		return true
	end,
	unionContrib = function(arg_83_0, arg_83_1, arg_83_2, arg_83_3, arg_83_4)
		local var_83_0 = {}

		if arg_83_1 > 0 and arg_83_2 then
			for iter_83_0, iter_83_1 in pairs(arg_83_2) do
				for iter_83_2, iter_83_3 in pairs(iter_83_1) do
					var_83_0[iter_83_2] = (var_83_0[iter_83_2] or 0) + iter_83_3
				end
			end

			table.insert(arg_83_3, {
				exp = arg_83_1,
				items = var_83_0,
				dailyDatas = {
					feature = arg_83_0
				}
			})

			return false
		end

		return true
	end,
	unionFragDonate = function(arg_84_0, arg_84_1, arg_84_2, arg_84_3, arg_84_4)
		local var_84_0 = gGameModel.role:read("daily_assistant").union_frag_donate_card_id

		if arg_84_1 > 0 and var_84_0 then
			for iter_84_0, iter_84_1 in gGameModel.cards:pairs() do
				local var_84_1 = iter_84_1:read("card_id")

				if var_84_0 == var_84_1 then
					local var_84_2 = csv.cards[var_84_1].name .. gLanguageCsv.fragment

					table.insert(arg_84_4, string.format(gLanguageCsv.wishSuccess, var_84_2))

					return false, true
				end
			end

			return false
		end

		return true
	end,
	unionTrainingSpeedup = function(arg_85_0, arg_85_1, arg_85_2, arg_85_3, arg_85_4)
		local var_85_0 = {}

		if arg_85_1 > 0 then
			var_85_0.gold = gCommonConfigCsv.unionTrainingSpeedUpGold * arg_85_1

			table.insert(arg_85_3, {
				exp = arg_85_1,
				items = var_85_0,
				dailyDatas = {
					feature = arg_85_0
				}
			})

			return false
		end

		return true
	end
}

function var_0_15.showSweepView(arg_86_0, arg_86_1, arg_86_2, arg_86_3)
	local var_86_0 = arg_86_0.tabSelected:read()
	local var_86_1 = arg_86_0.btnOnekeyState:read()
	local var_86_2 = table.deepcopy(arg_86_0.allDatas[var_86_0], true)
	local var_86_3 = {}
	local var_86_4 = "unionFuben"
	local var_86_5 = {}
	local var_86_6 = {}
	local var_86_7 = false

	for iter_86_0, iter_86_1 in pairs(var_86_2) do
		local var_86_8 = arg_86_2[iter_86_1.csvId]
		local var_86_9 = arg_86_1[iter_86_0] or 0
		local var_86_10 = var_86_1.featuresLeftTimes[iter_86_0] or 0
		local var_86_11 = var_86_9 - var_86_10

		if var_0_20[iter_86_0] then
			local var_86_12, var_86_13 = var_0_20[iter_86_0](iter_86_0, var_86_11, var_86_8, var_86_3, var_86_5)

			var_86_7 = var_86_13

			if var_86_12 and var_86_10 > 0 then
				table.insert(var_86_6, iter_86_0)
			end
		end
	end

	if arg_86_3 then
		for iter_86_2, iter_86_3 in pairs(arg_86_3) do
			local var_86_14 = "unionFuben"

			table.insert(var_86_3, {
				exp = iter_86_3.exp,
				items = iter_86_3.items,
				dailyDatas = {
					feature = var_86_14
				}
			})

			if iter_86_3.bossKilled then
				local var_86_15 = "#Pfont/youmi.ttf##C0xFF57472E#" .. gLanguageCsv.crossMineBossHasKilled
				local var_86_16 = {
					isRich = true
				}

				table.insert(var_86_3, {
					textDatas = {
						content = var_86_15,
						params = var_86_16
					}
				})
			end
		end
	end

	if not itertools.isempty(var_86_6) then
		local var_86_17 = ""

		for iter_86_4, iter_86_5 in pairs(var_86_6) do
			var_86_17 = string.format("%s[ %s ] ", var_86_17, gDailyAssistantCsv[iter_86_5].cfg.name)

			if iter_86_4 ~= #var_86_6 then
				var_86_17 = var_86_17 .. gLanguageCsv.symbolComma
			end
		end

		local var_86_18 = var_86_17 .. gLanguageCsv.dailyAssistantCantTodo

		if itertools.isempty(var_86_3) then
			if var_86_7 then
				var_86_18 = string.format("%s,%s", gLanguageCsv.wishSuccess1, var_86_18)
			end

			gGameUI:showTip(var_86_18)

			if itertools.isempty(arg_86_2) then
				arg_86_0.errorTips = var_86_18
			end

			return
		else
			table.insert(var_86_5, "#C0xFF57472E#" .. var_86_18)
		end
	end

	if not itertools.isempty(var_86_5) then
		table.insert(var_86_3, {
			textDatas = {
				content = var_86_5,
				params = {
					isRich = true,
					align = "left",
					fontSize = 40
				}
			},
			dailyDatas = {
				hasTitle = gLanguageCsv.mopUpNotes
			}
		})
	end

	if itertools.isempty(var_86_3) then
		return
	end

	local var_86_19 = gGameModel.capture:read("limit_sprites")

	gGameUI:stackUI("city.gate.sweep", nil, nil, {
		showType = 2,
		from = "dailyAssistant",
		hasExtra = false,
		sweepData = var_86_3,
		oldRoleLv = arg_86_0.level:read(),
		title1 = gLanguageCsv.oneKey,
		title2 = gLanguageCsv.mopUp1,
		oldCapture = var_86_19
	})
end

function var_0_15.onBtnOneClick(arg_87_0)
	if arg_87_0.errorTips then
		gGameUI:showTip(arg_87_0.errorTips)

		return
	end

	local var_87_0 = arg_87_0.btnOnekeyState:read().featuresLeftTimes

	if arg_87_0.tabSelected:read() == var_0_0.UNION and var_87_0.unionFuben then
		arg_87_0:onBtnThreeFight()
	else
		arg_87_0:sendRequestServerOnekey()
	end
end

function var_0_15.onBtnThreeFight(arg_88_0)
	local var_88_0 = arg_88_0.selectCsvId
	local var_88_1 = arg_88_0.unionFubenData:atproxy(arg_88_0.selectCsvId)
	local var_88_2 = arg_88_0.unionFbTimes:read()
	local var_88_3 = math.max(0, 3 - var_88_2)
	local var_88_4 = var_88_1.maxHp == 0
	local var_88_5 = var_88_1.surplusHp
	local var_88_6 = csv.union.union_fuben[var_88_0]
	local var_88_7 = {}
	local var_88_8 = 0

	local function var_88_9()
		var_88_1 = arg_88_0.unionFubenData:atproxy(var_88_0)

		if var_88_5 == 0 then
			var_88_0 = arg_88_0.selectCsvId
			var_88_6 = csv.union.union_fuben[var_88_0]
		end

		var_88_8 = var_88_8 + 1

		battleEntrance.battleRequest("/game/union/fuben/start", var_88_0, var_88_6.gateID):onStartOK(function(arg_90_0)
			arg_90_0.damage = var_88_1.damage
			arg_90_0.hpMax = var_88_1.maxHp
		end):onResult(function(arg_91_0, arg_91_1)
			local var_91_0 = arg_91_1.serverData.view

			var_88_1 = arg_88_0.unionFubenData:atproxy(var_88_0)

			local var_91_1 = var_88_1.maxHp

			var_88_5 = var_88_1.surplusHp

			local var_91_2 = math.max(var_91_0.damage, 0) / var_91_1
			local var_91_3 = math.floor(var_91_2 * 10000) / 100 .. "%"
			local var_91_4 = false

			if var_88_5 == 0 then
				var_91_4 = true
			end

			table.insert(var_88_7, {
				items = var_91_0.drop,
				exp = var_91_3,
				bossKilled = var_91_4
			})

			var_88_3 = var_88_3 - 1
			var_88_4 = false

			if var_88_3 > 0 then
				var_88_9()
			else
				if #var_88_7 >= 1 then
					arg_88_0:sendRequestServerOnekey(var_88_7)
				end

				return false
			end
		end):run()
	end

	if var_88_3 > 0 then
		var_88_9()
	else
		arg_88_0:sendRequestServerOnekey()
	end
end

function var_0_15.onBtnShowActiveNoteClick(arg_92_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_92_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_15.getRuleContext(arg_93_0, arg_93_1)
	local var_93_0 = adaptContext
	local var_93_1 = {
		var_93_0.clone(arg_93_1.title, function(arg_94_0)
			arg_94_0:get("text"):text(string.format(gLanguageCsv.dailyAssistantActiveTxt, var_0_3[arg_93_0.tabSelected:read()]))
		end)
	}

	for iter_93_0, iter_93_1 in pairs(arg_93_0.btnOnekeyState:read().activeTxt) do
		table.insert(var_93_1, iter_93_1)
	end

	return var_93_1
end

return var_0_15
