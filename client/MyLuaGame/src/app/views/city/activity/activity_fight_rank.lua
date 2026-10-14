local var_0_0 = {
	cc.c4b(166, 68, 3, 255),
	cc.c4b(86, 86, 145, 255),
	cc.c4b(111, 59, 27, 255),
	(cc.c4b(13, 73, 68, 255))
}

local function var_0_1(arg_1_0)
	if arg_1_0.sliderBg:visible() then
		local var_1_0, var_1_1 = arg_1_0:xy()
		local var_1_2 = arg_1_0:size()
		local var_1_3, var_1_4 = arg_1_0.sliderBg:xy()
		local var_1_5 = arg_1_0.sliderBg:size()

		arg_1_0:setScrollBarEnabled(true)
		arg_1_0:setScrollBarColor(cc.c3b(245, 156, 2))
		arg_1_0:setScrollBarOpacity(255)
		arg_1_0:setScrollBarAutoHideEnabled(false)
		arg_1_0:setScrollBarPositionFromCorner(cc.p(var_1_0 + var_1_2.width - var_1_3, (var_1_2.height - var_1_5.height) / 2 + 5))
		arg_1_0:setScrollBarWidth(var_1_5.width)
		arg_1_0:refreshView()
	else
		arg_1_0:setScrollBarEnabled(false)
	end
end

local var_0_2 = class("ActivityFightRankView", Dialog)

var_0_2.RESOURCE_FILENAME = "activity_fight_rank.json"
var_0_2.RESOURCE_BINDING = {
	["leftPanel.item"] = "tabItem",
	["centerPanel.mainPanel.rankAwardPanel.item"] = "itemRankAward",
	["centerPanel.spritePanel"] = "spritePanel",
	["centerPanel.mainPanel.rankPanel"] = "rankPanel",
	["leftPanel.fightPoint"] = "curFightPoint",
	["centerPanel.mainPanel.rankAwardPanel"] = "rankAwardPanel",
	["centerPanel.spritePanel.sliderBg"] = "spriteSliderBg",
	["centerPanel.spritePanel.spritePanel"] = "cardArea",
	["centerPanel.spritePanel.item"] = "spriteItem",
	["centerPanel.mainPanel.rankPanel.item"] = "itemRank",
	["centerPanel.mainPanel.rankPanel.ming"] = "rankLast",
	["centerPanel.spritePanel.spritePanel.cardShow"] = "cardShow",
	["topPanel.time"] = "timeLabel",
	["centerPanel.mainPanel"] = "mainPanel",
	["centerPanel.mainPanel.rankPanel.text1"] = "randHead",
	topPanel = "topPanel",
	["centerPanel.mainPanel.fightAwardPanel.item"] = "itemFightAward",
	["centerPanel.mainPanel.rankPanel.di"] = "rankFirst",
	["centerPanel.mainPanel.rankPanel.richText"] = "richText",
	["centerPanel.mainPanel.rankPanel.rankNumber"] = "rankNumber",
	["centerPanel.mainPanel.rankAwardPanel.sliderBg"] = "rankAwardSliderBg",
	["centerPanel.mainPanel.fightAwardPanel.sliderBg"] = "fightAwardSliderBg",
	["centerPanel.mainPanel.fightAwardPanel"] = "fightAwardPanel",
	["centerPanel.mainPanel.rankPanel.sliderBg"] = "rankSliderBg",
	["topPanel.day"] = {
		varname = "dayLabel",
		binds = {
			event = "extend",
			class = "text_atlas",
			props = {
				isEqualDist = false,
				pathName = "frhd",
				align = "right",
				data = bindHelper.self("dayStr"),
				onNode = function(arg_2_0)
					if not arg_2_0.isFirstOver then
						arg_2_0:x(arg_2_0:x() + 185)
						arg_2_0:y(arg_2_0:y() + 85)

						arg_2_0.isFirstOver = true
					end
				end
			}
		}
	},
	["topPanel.ruleBtn"] = {
		varname = "ruleBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowRule")
			}
		}
	},
	closeBtn = {
		varname = "closeBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["leftPanel.list"] = {
		varname = "tabList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("tabItem"),
				itemAction = {
					isAction = true
				},
				dataOrderCmp = function(arg_3_0, arg_3_1)
					return arg_3_0.id < arg_3_1.id
				end,
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					arg_4_1:get("name"):text(arg_4_3.name)
					arg_4_1:get("selected"):visible(arg_4_3.selected)
					arg_4_1:get("line"):visible(not arg_4_3.isLast)

					if arg_4_3.selected then
						text.addEffect(arg_4_1:get("name"), {
							color = ui.NEWCOLORS.OUTLINE.BLACK
						})
					else
						text.deleteAllEffect(arg_4_1:get("name"))
						text.addEffect(arg_4_1:get("name"), {
							color = ui.NEWCOLORS.OUTLINE.WHITE
						})
					end

					bind.click(arg_4_0, arg_4_1, {
						method = functools.partial(arg_4_0.clickCell, arg_4_2, arg_4_3)
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	["centerPanel.mainPanel.fightAwardPanel.list"] = {
		varname = "fightAwardList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("fightAward"),
				item = bindHelper.self("itemFightAward"),
				sliderBg = bindHelper.self("fightAwardSliderBg"),
				itemAction = {
					isAction = true,
					alwaysShow = true
				},
				onBeforeBuild = function(arg_5_0)
					var_0_1(arg_5_0)
				end,
				dataOrderCmp = function(arg_6_0, arg_6_1)
					return arg_6_0.fightPointRequire > arg_6_1.fightPointRequire
				end,
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					local var_7_0 = arg_7_1:multiget("iconList", "bg", "fightPoint", "fightText")

					var_7_0.fightPoint:text(arg_7_3.fightPointRequire)
					text.addEffect(var_7_0.fightText, {
						outline = {
							color = var_0_0[math.min(arg_7_2, 4)]
						}
					})
					text.addEffect(var_7_0.fightPoint, {
						outline = {
							color = ui.NEWCOLORS.OUTLINE.WHITE1
						}
					})

					if arg_7_2 < 4 then
						var_7_0.bg:texture(string.format("activity/fight_rank/box_panel_no%d.png", arg_7_2))
					else
						var_7_0.bg:texture("activity/fight_rank/box_panel_no4.png")
					end

					uiEasy.createItemsToList(arg_7_0, var_7_0.iconList, arg_7_3.award)
				end
			}
		}
	},
	["centerPanel.mainPanel.rankAwardPanel.list"] = {
		varname = "rankAwardList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("rankReward"),
				item = bindHelper.self("itemRankAward"),
				sliderBg = bindHelper.self("rankAwardSliderBg"),
				itemAction = {
					isAction = true,
					alwaysShow = true
				},
				onBeforeBuild = function(arg_8_0)
					var_0_1(arg_8_0)
				end,
				dataOrderCmp = function(arg_9_0, arg_9_1)
					return arg_9_0.rank < arg_9_1.rank
				end,
				onItem = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
					local var_10_0 = arg_10_1:multiget("iconList", "bg", "iconPanel")

					if arg_10_3.rank < 4 then
						var_10_0.iconPanel:get("rankIcon"):texture(string.format("activity/fight_rank/icon_no%d.png", arg_10_3.rank))
						var_10_0.bg:texture(string.format("activity/fight_rank/box_panel_no%d.png", arg_10_3.rank))
					else
						var_10_0.iconPanel:get("rankIcon"):hide()
						var_10_0.bg:texture("activity/fight_rank/box_panel_no4.png")
						bind.extend(arg_10_0, var_10_0.iconPanel, {
							class = "text_atlas",
							props = {
								isEqualDist = false,
								pathName = "frhd_num",
								align = "center",
								data = arg_10_2,
								onNode = function(arg_11_0)
									arg_11_0:x(arg_11_0:x() + 110)
									arg_11_0:y(arg_11_0:y() + 116)
								end
							}
						})
					end

					uiEasy.createItemsToList(arg_10_0, var_10_0.iconList, arg_10_3.award)
				end
			}
		}
	},
	["centerPanel.mainPanel.rankPanel.item.name"] = {
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
	["centerPanel.mainPanel.rankPanel.item.lv"] = {
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
	["centerPanel.mainPanel.rankPanel.item.level"] = {
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
	["centerPanel.mainPanel.rankPanel.item.fightPoint"] = {
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
	["centerPanel.mainPanel.rankPanel.item.text"] = {
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
	["centerPanel.mainPanel.rankPanel.list"] = {
		varname = "rankList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("fightRank"),
				item = bindHelper.self("itemRank"),
				sliderBg = bindHelper.self("rankSliderBg"),
				selfId = bindHelper.self("id"),
				rankIdler = bindHelper.self("rankIdler"),
				itemAction = {
					isAction = true,
					alwaysShow = true
				},
				onBeforeBuild = function(arg_12_0)
					var_0_1(arg_12_0)
				end,
				dataOrderCmp = function(arg_13_0, arg_13_1)
					return arg_13_0.fighting_point > arg_13_1.fighting_point
				end,
				onItem = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
					local var_14_0 = arg_14_1:multiget("iconPanel", "icon", "name", "vipIcon", "lv", "level", "fightPoint", "bg")
					local var_14_1 = arg_14_3.role

					var_14_0.name:text(var_14_1.name)
					var_14_0.level:text(var_14_1.level)

					if var_14_1.vip_level == 0 then
						var_14_0.vipIcon:hide()
					else
						var_14_0.vipIcon:texture(ui.VIP_ICON[var_14_1.vip_level])
					end

					var_14_0.fightPoint:text(arg_14_3.fighting_point)
					bind.extend(arg_14_0, var_14_0.icon, {
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = var_14_1.logo,
							frameId = var_14_1.frame
						}
					})
					adapt.oneLinePos(var_14_0.name, var_14_0.vipIcon, cc.p(10, 0))

					if arg_14_2 < 4 then
						var_14_0.iconPanel:get("rankIcon"):texture(string.format("activity/fight_rank/icon_no%d.png", arg_14_2))
						var_14_0.bg:texture(string.format("activity/fight_rank/box_panel_no%d.png", arg_14_2))
					else
						var_14_0.iconPanel:get("rankIcon"):hide()
						var_14_0.bg:texture("activity/fight_rank/box_panel_no4.png")
						bind.extend(arg_14_0, var_14_0.iconPanel, {
							class = "text_atlas",
							props = {
								isEqualDist = false,
								pathName = "frhd_num",
								align = "center",
								data = arg_14_2,
								onNode = function(arg_15_0)
									arg_15_0:x(arg_15_0:x() + 110)
									arg_15_0:y(arg_15_0:y() + 116)
								end
							}
						})
					end

					if arg_14_0.selfId == arg_14_3.role.id then
						arg_14_0.rankIdler:set(arg_14_2)
					end
				end
			}
		}
	},
	["centerPanel.spritePanel.list"] = {
		varname = "spriteList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				backupCached = false,
				data = bindHelper.self("skillData"),
				item = bindHelper.self("spriteItem"),
				sliderBg = bindHelper.self("spriteSliderBg"),
				itemAction = {
					isAction = true,
					alwaysShow = true
				},
				onBeforeBuild = function(arg_16_0)
					var_0_1(arg_16_0)
				end,
				dataOrderCmp = function(arg_17_0, arg_17_1)
					if arg_17_0.skillType2 == battle.MainSkillType.BigSkill then
						return false
					elseif arg_17_1.skillType2 == battle.MainSkillType.BigSkill then
						return true
					end
				end,
				onItem = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
					local var_18_0 = arg_18_1:multiget("icon", "name", "type", "note", "targetType", "richList", "bg", "iconbg")

					uiEasy.setSkillInfoToItems({
						name = var_18_0.name,
						icon = var_18_0.icon,
						type1 = var_18_0.type,
						type2 = var_18_0.note,
						target = var_18_0.targetType
					}, arg_18_3)

					local var_18_1, var_18_2 = beauty.textScroll({
						isRich = true,
						fontSize = 40,
						list = var_18_0.richList,
						strs = "#C0x5B545B#" .. eval.doMixedFormula(arg_18_3.describe, {
							skillLevel = 1,
							math = math
						})
					})
					local var_18_3 = var_18_2 - var_18_1:size().height

					var_18_1:size(var_18_1:size().width, var_18_2)
					var_18_1:y(var_18_1:y() - var_18_3)
					var_18_0.bg:size(var_18_0.bg:size().width, var_18_0.bg:size().height + var_18_3)
					arg_18_1:size(arg_18_1:size().width, arg_18_1:size().height + var_18_3)

					for iter_18_0, iter_18_1 in pairs(var_18_0) do
						iter_18_1:y(iter_18_1:y() + var_18_3)
					end
				end
			}
		}
	}
}

function var_0_2.initInfo(arg_19_0)
	arg_19_0.cfg = csv.yunying.yyhuodong[arg_19_0.activityId]

	local var_19_0 = arg_19_0.cfg.paramMap.card

	arg_19_0.cardInfo = csv.cards[var_19_0]
	arg_19_0.unitCsv = csv.unit[arg_19_0.cardInfo.unitID]

	local var_19_1 = arg_19_0.cardInfo.skillList
	local var_19_2 = {}

	for iter_19_0, iter_19_1 in pairs(var_19_1) do
		table.insert(var_19_2, csv.skill[iter_19_1])
	end

	arg_19_0.skillData = var_19_2

	local var_19_3 = arg_19_0.cardArea:size()
	local var_19_4 = arg_19_0.unitCsv.cardShow

	arg_19_0.cardShow:texture(var_19_4)

	local var_19_5 = arg_19_0.cardShow:size()
	local var_19_6 = math.min(var_19_3.width / var_19_5.width, var_19_3.height / var_19_5.height)

	arg_19_0.cardShow:scale(var_19_6)
end

function var_0_2.onCreate(arg_20_0, arg_20_1, arg_20_2)
	arg_20_0.activityId = arg_20_1
	arg_20_0.yyEndtime = gGameModel.role:read("yy_endtime")
	arg_20_0.id = gGameModel.role:read("id")
	arg_20_0.dayStr = idler.new("00")

	arg_20_0:initInfo()

	if arg_20_2 then
		arg_20_0.endTime = arg_20_2.view.end_time
	end

	local var_20_0 = {
		{
			id = 1,
			showRightIndex = true,
			name = gLanguageCsv.rankAward,
			view = arg_20_0.rankAwardPanel
		},
		{
			id = 2,
			showRightIndex = true,
			name = gLanguageCsv.fightAward,
			view = arg_20_0.fightAwardPanel
		},
		{
			id = 3,
			showRightIndex = true,
			name = gLanguageCsv.fightRankItem,
			view = arg_20_0.rankPanel
		},
		{
			id = 4,
			showRightIndex = false,
			name = gLanguageCsv.spriteShow
		}
	}
	local var_20_1 = {}

	for iter_20_0, iter_20_1 in orderCsvPairs(csv.yunying.fightrankaward) do
		if iter_20_1.huodongID == arg_20_0.cfg.huodongID then
			table.insert(var_20_1, iter_20_0, iter_20_1)
		end
	end

	local var_20_2 = {}

	for iter_20_2, iter_20_3 in orderCsvPairs(csv.yunying.fightpointaward) do
		if iter_20_3.huodongID == arg_20_0.cfg.huodongID then
			table.insert(var_20_2, iter_20_2, iter_20_3)
		end
	end

	arg_20_0.subViews = {}
	arg_20_0.tabDatas = idlers.newWithMap(var_20_0)
	arg_20_0.rankReward = var_20_1
	arg_20_0.fightAward = var_20_2
	arg_20_0.fightRank = idlers.new()
	arg_20_0.tabChooseId = idler.new(1)
	arg_20_0.rankIdler = idler.new()
	arg_20_0.fightPoint = gGameModel.role:getIdler("top6_fighting_point")

	arg_20_0:resetTimeLabel()
	idlereasy.when(arg_20_0.fightPoint, function(arg_21_0, arg_21_1)
		arg_20_0.curFightPoint:text(arg_21_1)
		text.addEffect(arg_20_0.curFightPoint, {
			color = ui.COLORS.NORMAL.WHITE,
			outline = {
				color = ui.NEWCOLORS.OUTLINE.BLACK
			}
		})
	end)
	idlereasy.when(arg_20_0.rankIdler, function(arg_22_0, arg_22_1)
		local var_22_0 = arg_22_1 and true or false

		arg_20_0.rankFirst:visible(var_22_0)
		arg_20_0.rankLast:visible(var_22_0)

		if not var_22_0 then
			arg_20_0.rankNumber:text(gLanguageCsv.noRank)
			adapt.oneLinePos(arg_20_0.randHead, arg_20_0.rankNumber, cc.p(20, 0))
		else
			arg_20_0.rankNumber:text(arg_22_1)
			adapt.oneLinePos(arg_20_0.randHead, {
				arg_20_0.rankFirst,
				arg_20_0.rankNumber,
				arg_20_0.rankLast
			}, {
				cc.p(20, 0),
				cc.p(0, 0),
				cc.p(0, 0)
			})
		end
	end)
	arg_20_0.tabChooseId:addListener(function(arg_23_0, arg_23_1)
		if arg_23_1 then
			arg_20_0.tabDatas:atproxy(arg_23_1).selected = false

			if var_20_0[arg_23_1].view then
				var_20_0[arg_23_1].view:hide()
			end
		end

		if arg_23_0 then
			arg_20_0.tabDatas:atproxy(arg_23_0).selected = true

			local var_23_0 = var_20_0[arg_23_0]

			if var_23_0 then
				if var_23_0.view then
					var_23_0.view:show()
				end

				local var_23_1 = var_23_0.showRightIndex

				arg_20_0.spritePanel:visible(not var_23_1)
				arg_20_0.mainPanel:visible(var_23_1)
			end
		end
	end)

	local var_20_3 = arg_20_0.ruleBtn:get("text")

	text.addEffect(var_20_3, {
		color = ui.NEWCOLORS.OUTLINE.BLACK4,
		outline = {
			color = ui.NEWCOLORS.OUTLINE.YELLOW1
		}
	})

	local var_20_4 = gLanguageCsv.fightRankBottomRichText
	local var_20_5 = rich.createByStr(string.format(var_20_4, "#C0xFFFFFF#", "#C0x0f9932#", "#C0xFFFFFF#", "#C0xff794c#", "#C0xFFFFFF#"), 40)

	arg_20_0.richText:add(var_20_5):text("")
	var_20_5:anchorPoint(0, 0.5):xy(0, 0)
	Dialog.onCreate(arg_20_0, {
		blackType = 1
	})
end

function var_0_2.updateRankData(arg_24_0, arg_24_1)
	gGameApp:requestServer("/game/yy/fightrank/get", function(arg_25_0)
		arg_24_0.fightRank:update(arg_25_0.view.rank)

		arg_24_0.endTime = arg_25_0.view.end_time

		arg_24_0:resetTimeLabel()

		if arg_24_1 then
			arg_24_1()
		end
	end, arg_24_0.activityId)
end

function var_0_2.onTabClick(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	if arg_26_2 == 3 then
		arg_26_0:updateRankData(function()
			arg_26_0.tabChooseId:set(arg_26_2)
		end)
	else
		arg_26_0.tabChooseId:set(arg_26_2)
	end
end

function var_0_2.resetTimeLabel(arg_28_0)
	local var_28_0 = arg_28_0.timeLabel
	local var_28_1 = arg_28_0.dayLabel

	if not arg_28_0.endTime then
		arg_28_0.endTime = time.getNumTimestamp(arg_28_0.cfg.endDate, 21, 30) - 86400
	end

	local function var_28_2()
		local var_29_0 = arg_28_0.endTime - time.getTime()

		if var_29_0 <= 0 then
			var_28_0:text(gLanguageCsv.activityOver)
			arg_28_0.dayStr:set("00")

			return false
		end

		local var_29_1 = time.getCutDown(var_29_0)

		arg_28_0.dayStr:set(tostring(var_29_1.day))
		var_28_0:text(string.format(gLanguageCsv.fightRankTimeFMT, var_29_1.day, var_29_1.hour, var_29_1.min, var_29_1.sec))

		return true
	end

	var_28_2()

	local var_28_3 = 1

	arg_28_0:enableSchedule():unSchedule(var_28_3)
	arg_28_0:schedule(function()
		if not var_28_2() then
			return false
		end
	end, 1, 1, var_28_3)
end

function var_0_2.onShowRule(arg_31_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_31_0:createHandler("getRuleContext"))
end

function var_0_2.getRuleContext(arg_32_0, arg_32_1)
	local var_32_0 = adaptContext

	return {
		var_32_0.clone(arg_32_1.title, function(arg_33_0)
			arg_33_0:get("text"):text(gLanguageCsv.fightRankRuleTitle)
		end),
		var_32_0.noteText(55001, 55005)
	}
end

return var_0_2
