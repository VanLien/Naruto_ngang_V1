local var_0_0 = {
	BATTLEACTIVITY = 5,
	manGrow = 2,
	CARDSGROW = 4,
	CARDSGET = 3,
	ACHIEVEMENTALL = 1,
	PVPCHALLENGR = 6,
	SOCIALCONTACK = 7,
	UNVISLBLEACHIEVEMENT = 8
}
local var_0_1 = {
	BATTLEACTIVITY = 4,
	manGrow = 1,
	CARDSGROW = 3,
	CARDSGET = 2,
	ACHIEVEMENTALL = 0,
	PVPCHALLENGR = 5,
	SOCIALCONTACK = 6,
	UNVISLBLEACHIEVEMENT = 7
}
local var_0_2 = {
	WILLBE = 2,
	FINISH = 1
}
local var_0_3 = {
	GET = 1,
	DOING = 2,
	FINISHED = 0
}
local var_0_4 = {
	OTHER = 2,
	PAGE1 = 1
}
local var_0_5 = {
	[48] = true
}
local var_0_6 = {
	jinjie5_effect = "effect_loop1",
	jinjie4_effect = "effect_loop"
}
local var_0_7 = {
	levelUp = 1.8333333333333333
}

local function var_0_8(arg_1_0, arg_1_1)
	local var_1_0 = gAchievementLevelCsv[arg_1_0][arg_1_1 + 1]

	if not var_1_0 then
		return
	end

	return var_1_0.award
end

local function var_0_9(arg_2_0, arg_2_1)
	return arg_2_1 >= itertools.size(gAchievementLevelCsv[arg_2_0]) - 1
end

local function var_0_10(arg_3_0, arg_3_1)
	local var_3_0 = csv.achievement.achievement_level
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(arg_3_1) do
		local var_3_2 = var_3_0[iter_3_0]

		if iter_3_1 == 1 and var_3_2.type == arg_3_0 then
			local var_3_3 = {
				cfg = var_3_2,
				csvId = iter_3_0
			}

			table.insert(var_3_1, var_3_3)
		end
	end

	table.sort(var_3_1, function(arg_4_0, arg_4_1)
		return arg_4_0.cfg.level < arg_4_1.cfg.level
	end)

	return var_3_1[1]
end

local function var_0_11(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_1:multiget("textCount", "textNote1", "textNote2", "list", "textPro", "btnGet", "btnGo", "imgGot")

	var_5_0.textNote1:text(arg_5_3.cfg.title)

	local var_5_1 = arg_5_3.cfg.desc

	var_5_0.textNote2:hide()
	arg_5_1:removeChildByName("descRichText")

	local var_5_2, var_5_3 = beauty.textScroll({
		size = cc.size(660, 110),
		strs = var_5_1,
		fontSize = var_5_0.textNote2:getFontSize(),
		effect = {
			color = ui.NEWCOLORS.BROWN1
		}
	})
	local var_5_4 = 15

	if var_5_3 < 110 then
		var_5_4 = 15 - (110 - var_5_3) / 2
	end

	var_5_2:xy(var_5_0.textNote2:x(), var_5_4):addTo(arg_5_1, var_5_0.textNote2:z(), "descRichText")
	var_5_0.textCount:text(arg_5_3.cfg.point)
	var_5_0.imgGot:visible(arg_5_3.flag == var_0_3.FINISHED)
	var_5_0.btnGet:visible(arg_5_3.flag == var_0_3.GET)
	var_5_0.btnGo:visible(arg_5_3.flag == var_0_3.DOING and arg_5_3.cfg.jumpTo ~= "")
	var_5_0.textPro:visible(arg_5_3.flag ~= var_0_3.FINISHED)

	local var_5_5 = ui.NEWCOLORS.GREENLIGHT

	if arg_5_3.flag == var_0_3.DOING then
		var_5_5 = ui.NEWCOLORS.RED1
	end

	text.addEffect(var_5_0.textPro, {
		color = var_5_5
	})

	local var_5_6 = arg_5_3.count or 0

	var_5_0.textPro:text(var_5_6 .. "/" .. mathEasy.getShortNumber(arg_5_3.cfg.targetArg, 2))

	local var_5_7 = arg_5_1:size()

	var_5_0.textPro:y(var_5_7.height / 2)

	if arg_5_3.flag == var_0_3.GET or arg_5_3.cfg.jumpTo ~= "" then
		var_5_0.textPro:y(173)
	end

	uiEasy.createItemsToList(arg_5_0, var_5_0.list, arg_5_3.cfg.award, {
		scale = 0.8
	})
	bind.touch(arg_5_0, var_5_0.btnGet, {
		methods = {
			ended = functools.partial(arg_5_0.clickGet, arg_5_2, arg_5_3)
		}
	})
	bind.touch(arg_5_0, var_5_0.btnGo, {
		methods = {
			ended = functools.partial(arg_5_0.clickJump, arg_5_3)
		}
	})
end

local var_0_12 = cc.load("mvc").ViewBase
local var_0_13 = class("achievementView", var_0_12)

var_0_13.RESOURCE_FILENAME = "achievement_main.json"
var_0_13.RESOURCE_BINDING = {
	btn = "btnItem",
	["rightAll.info"] = "rightAllInfo",
	["rightAll.btnFinish.textNote"] = "btnTextNote1",
	["rightAll.btnWillBe.textNote"] = "btnTextNote2",
	item = "item",
	Image_14 = "leftBG",
	infoItem = "infoItem",
	normal = "rightNormal",
	["rightAll.allInfo"] = "allInfo",
	left = "leftPanel",
	["right.leftInfo"] = "leftInfo",
	rightAll = {
		varname = "rightAll",
		binds = {
			event = "visible",
			idler = bindHelper.self("selIdx"),
			method = function(arg_6_0)
				return arg_6_0 == var_0_0.ACHIEVEMENTALL
			end
		}
	},
	right = {
		varname = "right",
		binds = {
			event = "visible",
			idler = bindHelper.self("selIdx"),
			method = function(arg_7_0)
				return arg_7_0 ~= var_0_0.ACHIEVEMENTALL
			end
		}
	},
	["left.listview"] = {
		varname = "btnList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("btnDatas"),
				item = bindHelper.self("btnItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					local var_8_0 = arg_8_1:get("btnNormal")
					local var_8_1 = arg_8_1:get("btnSelected")

					var_8_1:visible(arg_8_3.isSel)
					var_8_0:visible(not arg_8_3.isSel)
					var_8_0:get("textNote"):text(arg_8_3.txt)
					var_8_0:get("textNote1"):text(arg_8_3.enTxt)
					var_8_1:get("textNote"):text(arg_8_3.txt)
					bind.extend(arg_8_0, arg_8_1, {
						class = "red_hint",
						props = {
							state = arg_8_3.isSel ~= true,
							listenData = {
								curType = arg_8_3.type
							},
							specialTag = {
								"achievementTask",
								"achievementBox"
							},
							onNode = function(arg_9_0)
								arg_9_0:xy(355, 145)
							end
						}
					})
					bind.touch(arg_8_0, var_8_0, {
						methods = {
							ended = functools.partial(arg_8_0.clickCell, arg_8_2, arg_8_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onClickBtn")
			}
		}
	},
	["rightAll.btnFinish"] = {
		varname = "btnFinish",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_10_0)
						arg_10_0:onChangeListPage(var_0_2.FINISH)
					end)
				}
			},
			{
				specialTag = "achievementTask",
				state = bindHelper.self("isFinishedPage"),
				listenData = {
					curType = 0
				},
				onNode = function(arg_11_0)
					arg_11_0:xy(280, 110)
				end
			}
		}
	},
	["rightAll.btnWillBe"] = {
		varname = "btnWillBe",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_12_0)
					arg_12_0:onChangeListPage(var_0_2.WILLBE)
				end)
			}
		}
	},
	["rightAll.btnRank"] = {
		varname = "btnRank",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowRank")
			}
		}
	},
	["rightAll.btnRank.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLUE
				}
			}
		}
	},
	["item.btnGo.textNote"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE
					}
				}
			}
		}
	},
	["item.btnGet.textNote"] = {
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
	["rightAll.list"] = {
		varname = "allPanelList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("threeDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
					var_0_11(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				end
			},
			handlers = {
				clickGet = bindHelper.self("onClickGet"),
				clickJump = bindHelper.self("onClickJump")
			}
		}
	},
	["rightAll.allInfo.list"] = {
		varname = "allInfoList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("taskItems"),
				item = bindHelper.self("infoItem"),
				onItem = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
					arg_14_1:get("imgIcon"):texture(arg_14_3.icon)
					arg_14_1:get("textName"):text(arg_14_3.name)
					arg_14_1:get("textPro"):text(arg_14_3.progress)
				end
			}
		}
	},
	["rightAll.info.textPro"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 3,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			},
			{
				event = "text",
				idler = bindHelper.self("curPoints")
			}
		}
	},
	["rightAll.info.textLv"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = cc.c4b(153, 119, 9, 255)
					}
				}
			},
			{
				event = "text",
				idler = bindHelper.self("curLv")
			}
		}
	},
	["rightAll.info.progress"] = {
		varname = "rightAllProgressBar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				data = bindHelper.self("curPagePro")
			}
		}
	},
	["right.leftInfo.textNote1"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("curPageName")
		}
	},
	["right.leftInfo.textNote2"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("curPageNameEn")
		}
	},
	["right.pageInfo.textPro"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 3,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			},
			{
				event = "text",
				idler = bindHelper.self("curPoints")
			}
		}
	},
	["right.pageInfo.textName"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 3,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			},
			{
				event = "text",
				idler = bindHelper.self("curPageName")
			}
		}
	},
	["right.pageInfo.progress"] = {
		varname = "rightProgressBar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				data = bindHelper.self("curPagePro")
			}
		}
	},
	["normal.textNote"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("normalText")
		}
	},
	["right.list"] = {
		varname = "rightList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("rightDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
					var_0_11(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				end
			},
			handlers = {
				clickGet = bindHelper.self("onClickGet"),
				clickJump = bindHelper.self("onClickJump")
			}
		}
	},
	["right.pageInfo"] = {
		varname = "rightPageInfo",
		binds = {
			event = "visible",
			idler = bindHelper.self("selIdx"),
			method = function(arg_16_0)
				return arg_16_0 ~= var_0_0.UNVISLBLEACHIEVEMENT and arg_16_0 ~= var_0_0.ACHIEVEMENTALL
			end
		}
	},
	["right.pageInfo.box"] = {
		varname = "rightBox",
		binds = {
			{
				event = "visible",
				idler = bindHelper.self("isShowBox")
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "achievementBox",
					listenData = {
						curType = bindHelper.self("curSelType")
					},
					onNode = function(arg_17_0)
						arg_17_0:xy(140, 110)
					end
				}
			},
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_18_0)
						arg_18_0:onGetBoxGift(var_0_4.OTHER)
					end)
				}
			}
		}
	},
	["right.pageInfo.box.imgBox"] = {
		binds = {
			event = "texture",
			idler = bindHelper.self("boxPath")
		}
	},
	["rightAll.info.box"] = {
		varname = "rightAllBox",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_19_0)
						arg_19_0:onGetBoxGift(var_0_4.PAGE1)
					end)
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "achievementBox",
					listenData = {
						curType = 0
					},
					onNode = function(arg_20_0)
						arg_20_0:xy(140, 110)
					end
				}
			},
			{
				event = "visible",
				idler = bindHelper.self("isShowBox")
			}
		}
	},
	["rightAll.info.box.imgBox"] = {
		binds = {
			{
				event = "texture",
				idler = bindHelper.self("boxPath")
			}
		}
	},
	["rightAll.info.imgIcon"] = {
		varname = "imgIcon",
		binds = {
			event = "texture",
			idler = bindHelper.self("imgLvBg")
		}
	}
}

function var_0_13.onCreate(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0.item:multiget("imgBg")
	local var_21_1, var_21_2 = arg_21_0.right:multiget("img_BG", "Img_bg")
	local var_21_3 = arg_21_0.item:multiget("imgIcon", "textCount", "textNote1", "textNote2", "Image_17")
	local var_21_4 = arg_21_0.item:multiget("list", "btnGet", "btnGo", "textPro", "imgGot", "Image_18")

	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_21_0.leftPanel,
			"pos",
			"left"
		},
		{
			arg_21_0.leftBG,
			"pos",
			"left"
		},
		{
			arg_21_0.allPanelList,
			"width"
		},
		{
			arg_21_0.rightList,
			"width"
		},
		{
			var_21_1,
			"width"
		},
		{
			var_21_2,
			"width"
		},
		{
			var_21_0,
			"width"
		},
		{
			var_21_3,
			"pos",
			"left"
		},
		{
			var_21_4,
			"pos",
			"right"
		},
		{
			{
				arg_21_0.leftInfo,
				arg_21_0.rightList,
				arg_21_0.allPanelList,
				arg_21_0.allInfo,
				arg_21_0.btnFinish,
				arg_21_0.btnWillBe
			},
			"pos",
			"left"
		},
		{
			{
				arg_21_0.rightPageInfo,
				arg_21_0.btnRank,
				arg_21_0.rightAllInfo
			},
			"pos",
			"right"
		}
	})

	arg_21_1 = arg_21_1 or var_0_0.ACHIEVEMENTALL

	arg_21_0:initModel()
	gGameUI.topuiManager:createView("default", arg_21_0, {
		onClose = arg_21_0:createHandler("onClose")
	}):init({
		subTitle = "ACHIEVEMENT",
		title = "common/txt/txt_bt_chengjiu.png"
	})

	arg_21_0.isFinishedPage = idler.new(true)
	arg_21_0.curPoints = idler.new("")
	arg_21_0.curPageName = idler.new("")
	arg_21_0.curPageNameEn = idler.new("")
	arg_21_0.boxPath = idler.new("")
	arg_21_0.imgLvBg = idler.new("")
	arg_21_0.normalText = idler.new(gLanguageCsv.noUnvisibleTasks)
	arg_21_0.isShowBox = idler.new(true)
	arg_21_0.curLv = idler.new(0)
	arg_21_0.curPagePro = idler.new(0)
	arg_21_0.selIdx = idler.new(arg_21_0._selIdx or arg_21_1)

	local var_21_5 = {
		{
			isSel = false,
			idx = 1,
			enTxt = "Overview",
			type = 0,
			txt = gLanguageCsv.allAchievement
		},
		{
			isSel = false,
			idx = 2,
			enTxt = "Develop",
			type = 1,
			txt = gLanguageCsv.manGrow
		},
		{
			isSel = false,
			idx = 3,
			enTxt = "Collect",
			type = 2,
			txt = gLanguageCsv.cardsGet
		},
		{
			isSel = false,
			idx = 4,
			enTxt = "Training",
			type = 3,
			txt = gLanguageCsv.strengthen
		},
		{
			isSel = false,
			idx = 5,
			enTxt = "Gate",
			type = 4,
			txt = gLanguageCsv.battleActivity
		},
		{
			isSel = false,
			idx = 6,
			enTxt = "Sports",
			type = 5,
			txt = gLanguageCsv.pvpChallenge
		},
		{
			isSel = false,
			idx = 7,
			enTxt = "Social",
			type = 6,
			txt = gLanguageCsv.socialContact
		}
	}
	local var_21_6 = {
		isSel = false,
		idx = 8,
		enTxt = "Hide",
		type = 7,
		txt = gLanguageCsv.unvislbleAchievement
	}

	var_21_5[arg_21_0.selIdx:read()].isSel = true
	arg_21_0.curSelType = idler.new(var_21_5[arg_21_0.selIdx:read()].type)
	arg_21_0.btnDatas = idlers.newWithMap(var_21_5)
	arg_21_0.taskItems = {}

	for iter_21_0, iter_21_1 in orderCsvPairs(csv.achievement.achievement) do
		if iter_21_0 > 6 then
			break
		end

		if not arg_21_0.taskItems[iter_21_0] then
			arg_21_0.taskItems[iter_21_0] = {}
		end

		arg_21_0.taskItems[iter_21_0].icon = iter_21_1.icon
		arg_21_0.taskItems[iter_21_0].name = iter_21_1.name
	end

	arg_21_0.taskItems = idlers.newWithMap(arg_21_0.taskItems)

	local var_21_7 = csv.achievement.achievement_task
	local var_21_8 = {}
	local var_21_9 = {}

	for iter_21_2, iter_21_3 in orderCsvPairs(var_21_7) do
		if not var_21_8[iter_21_3.type] then
			var_21_8[iter_21_3.type] = {}
		end

		if not var_21_8[iter_21_3.type][iter_21_3.targetType2] then
			var_21_8[iter_21_3.type][iter_21_3.targetType2] = {}
		end

		local var_21_10 = {
			cfg = iter_21_3,
			csvId = iter_21_2
		}

		table.insert(var_21_8[iter_21_3.type][iter_21_3.targetType2], var_21_10)

		var_21_9[iter_21_3.type] = (var_21_9[iter_21_3.type] or 0) + 1
	end

	for iter_21_4, iter_21_5 in ipairs(var_21_8) do
		for iter_21_6, iter_21_7 in ipairs(iter_21_5) do
			table.sort(iter_21_7, function(arg_22_0, arg_22_1)
				return arg_22_0.cfg.sort < arg_22_1.cfg.sort
			end)
		end
	end

	arg_21_0.allListPageIdx = idler.new(1)
	arg_21_0.threeDatas = idlers.newWithMap({})
	arg_21_0.rightDatas = idlers.newWithMap({})

	local var_21_11 = {
		arg_21_0.selIdx,
		arg_21_0.allListPageIdx,
		arg_21_0.tasks,
		arg_21_0.points,
		arg_21_0.boxAward
	}

	idlereasy.any(var_21_11, function(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
		arg_23_3 = arg_23_3 or {}
		arg_23_4 = arg_23_4 or {}
		arg_23_5 = arg_23_5 or {}

		local var_23_0 = arg_21_0.btnDatas:atproxy(arg_23_1).type
		local var_23_1, var_23_2 = arg_21_0:getCurLvAndNextExp()
		local var_23_3 = arg_23_4[var_23_0] or 0

		if arg_23_1 == var_0_0.ACHIEVEMENTALL then
			var_23_3 = 0

			for iter_23_0, iter_23_1 in pairs(arg_23_4) do
				var_23_3 = var_23_3 + iter_23_1
			end
		end

		arg_21_0.curPoints:set(string.format("%s/%s", var_23_3, var_23_2))
		arg_21_0.curPageName:set(arg_21_0.btnDatas:atproxy(arg_23_1).txt)
		arg_21_0.curPageNameEn:set(arg_21_0.btnDatas:atproxy(arg_23_1).enTxt)
		arg_21_0.curPagePro:set(math.min(100, var_23_3 / var_23_2 * 100))
		arg_21_0.curLv:set(var_23_1)
		arg_21_0.curSelType:set(var_23_0, true)
		arg_21_0:updateBox(var_23_0, arg_23_5, var_23_1)
		arg_21_0:addUnVisibleItem(var_21_5, arg_23_3)

		if arg_23_1 ~= var_0_0.ACHIEVEMENTALL then
			local var_23_4 = var_21_8[var_23_0] or {}

			dataEasy.tryCallFunc(arg_21_0.rightList, "updatePreloadCenterIndex")

			local var_23_5, var_23_6 = arg_21_0:getRightDatas(arg_23_1, arg_23_3, var_23_4)

			arg_21_0.rightDatas:update(var_23_5)
			arg_21_0.rightNormal:xy(1670, 640)
			arg_21_0.normalText:set(gLanguageCsv.noUnvisibleTasks)
			arg_21_0.rightNormal:visible(var_23_6 == 0)
			arg_21_0.rightList:visible(var_23_6 ~= 0)
		else
			arg_21_0:addAllAchievementEffect(var_23_0, var_23_1, arg_23_2)

			local var_23_7, var_23_8, var_23_9 = arg_21_0:getAllAchievementDatas(arg_23_3, var_21_9)
			local var_23_10, var_23_11 = arg_21_0:getThreeTabs(var_23_7, arg_23_3, arg_23_2, var_21_8, var_23_8)

			arg_21_0.rightNormal:xy(1500, 400)
			arg_21_0.normalText:set(gLanguageCsv.noFinishedTasks)
			arg_21_0.rightNormal:visible(var_23_11 == 0)
			arg_21_0.threeDatas:update(var_23_10)

			for iter_23_2, iter_23_3 in ipairs(var_21_9) do
				if arg_21_0.taskItems:atproxy(iter_23_2) then
					arg_21_0.taskItems:atproxy(iter_23_2).progress = string.format("%s/%s", var_23_9[iter_23_2] or 0, iter_23_3)
				end
			end
		end

		arg_21_0.isFinishedPage:set(arg_23_2 ~= 1)
	end)
end

function var_0_13.updateBox(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	arg_24_0.curBoxReward = var_0_10(arg_24_1, arg_24_2)

	arg_24_0.rightAllBox:removeChildByName("effect")
	arg_24_0.rightBox:removeChildByName("effect")

	if arg_24_0.curBoxReward then
		local var_24_0 = arg_24_1 == var_0_1.ACHIEVEMENTALL and arg_24_0.rightAllBox or arg_24_0.rightBox
		local var_24_1 = arg_24_1 == var_0_1.ACHIEVEMENTALL and cc.p(70, -10) or cc.p(50, -10)

		widget.addAnimationByKey(var_24_0, "effect/jiedianjiangli.skel", "effect", "effect_loop", 1):xy(var_24_1):scale(0.5)
	end

	local var_24_2 = gAchievementLevelCsv[arg_24_1] or {}
	local var_24_3 = arg_24_0.curBoxReward or {
		cfg = var_24_2[arg_24_3 + 1]
	}
	local var_24_4 = false
	local var_24_5 = ""

	if var_24_3 and not itertools.isempty(var_24_3) then
		var_24_5 = var_24_3.cfg.boxIcon
		var_24_4 = true
	end

	arg_24_0.boxPath:set(var_24_5)
	arg_24_0.isShowBox:set(var_24_4)
end

function var_0_13.addAllAchievementEffect(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	local var_25_0 = (gAchievementLevelCsv[arg_25_1] or {})[arg_25_2] or {}

	arg_25_0.imgLvBg:set(var_25_0.icon)
	arg_25_0:showLevelSpine()

	local var_25_1 = arg_25_3 == var_0_2.FINISH

	arg_25_0.btnFinish:setTouchEnabled(not var_25_1)
	arg_25_0.btnWillBe:setTouchEnabled(var_25_1)
	arg_25_0.btnFinish:setBright(not var_25_1)
	arg_25_0.btnWillBe:setBright(var_25_1)
	text.deleteAllEffect(arg_25_0.btnTextNote1)
	text.deleteAllEffect(arg_25_0.btnTextNote2)

	local var_25_2 = ui.COLORS.NORMAL.WHITE
	local var_25_3 = ui.COLORS.NORMAL.WHITE
	local var_25_4 = arg_25_0.btnTextNote2

	if arg_25_3 == var_0_2.FINISH then
		var_25_2 = ui.COLORS.NORMAL.WHITE
		var_25_3 = ui.COLORS.NORMAL.WHITE
		var_25_4 = arg_25_0.btnTextNote1
	end

	text.addEffect(arg_25_0.btnTextNote1, {
		color = var_25_2,
		outline = {
			size = 3,
			color = ui.NEWCOLORS.OUTLINE.BLUE
		}
	})
	text.addEffect(arg_25_0.btnTextNote2, {
		color = var_25_3,
		outline = {
			size = 3,
			color = ui.NEWCOLORS.OUTLINE.BLUE
		}
	})
	text.addEffect(var_25_4, {
		outline = {
			size = 1,
			color = ui.NEWCOLORS.OUTLINE.YELLOW1
		}
	})
end

function var_0_13.getAllAchievementDatas(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = {}
	local var_26_1 = {}
	local var_26_2 = {}
	local var_26_3 = 0
	local var_26_4 = csv.achievement.achievement_task

	for iter_26_0, iter_26_1 in pairs(arg_26_1 or {}) do
		local var_26_5 = var_26_4[iter_26_0]
		local var_26_6 = var_26_5.targetType2
		local var_26_7 = var_26_5.targetArg

		if not var_26_0[var_26_6] then
			table.insert(var_26_1, var_26_6)

			var_26_0[var_26_6] = {}
		end

		table.insert(var_26_0[var_26_6], {
			csvId = iter_26_0,
			cfg = var_26_5,
			state = iter_26_1[1],
			finishTime = iter_26_1[2]
		})

		if iter_26_1[1] == var_0_3.FINISHED or iter_26_1[1] == var_0_3.GET then
			var_26_2[var_26_5.type] = (var_26_2[var_26_5.type] or 0) + 1
		end
	end

	table.sort(var_26_1, function(arg_27_0, arg_27_1)
		return arg_27_0 < arg_27_1
	end)

	for iter_26_2, iter_26_3 in pairs(var_26_0) do
		table.sort(iter_26_3, function(arg_28_0, arg_28_1)
			if arg_28_0.state == arg_28_1.state and arg_28_0.state == 1 then
				return arg_28_0.cfg.sort < arg_28_1.cfg.sort
			end

			if arg_28_0.state ~= arg_28_1.state then
				return arg_28_0.state == 1
			end

			if arg_28_0.finishTime ~= arg_28_1.finishTime then
				return arg_28_0.finishTime > arg_28_1.finishTime
			end

			return arg_28_0.csvId < arg_28_1.csvId
		end)
	end

	return var_26_0, var_26_1, var_26_2
end

function var_0_13.getThreeTabs(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5)
	local var_29_0 = csv.achievement.achievement_task
	local var_29_1 = 0
	local var_29_2 = {}

	if arg_29_3 == var_0_2.WILLBE then
		local var_29_3 = {}

		for iter_29_0, iter_29_1 in pairs(arg_29_4) do
			for iter_29_2, iter_29_3 in pairs(iter_29_1) do
				local var_29_4
				local var_29_5

				for iter_29_4, iter_29_5 in ipairs(iter_29_3) do
					if iter_29_5.cfg.isShow and not var_0_5[iter_29_2] then
						var_29_5 = gGameModel.role:getAchievement(iter_29_5.csvId)

						if var_29_5 < iter_29_5.cfg.targetArg then
							var_29_4 = iter_29_5

							break
						end
					end
				end

				if var_29_4 then
					local var_29_6 = var_29_5 / var_29_4.cfg.targetArg * 100
					local var_29_7 = iter_29_1[var_29_4.csvId] or {}
					local var_29_8 = {
						flag = var_29_7[1] or var_0_3.DOING,
						count = var_29_5,
						cfg = var_29_4.cfg,
						csvId = var_29_4.csvId,
						percent = var_29_6
					}

					table.insert(var_29_3, var_29_8)

					var_29_1 = var_29_1 + 1
				end
			end
		end

		table.sort(var_29_3, function(arg_30_0, arg_30_1)
			return arg_30_0.percent > arg_30_1.percent
		end)

		for iter_29_6 = 1, #var_29_3 do
			if var_29_3[iter_29_6].cfg.type ~= var_0_1.UNVISLBLEACHIEVEMENT then
				table.insert(var_29_2, var_29_3[iter_29_6])
			end

			if #var_29_2 >= 3 then
				break
			end
		end
	else
		local var_29_9 = {}

		for iter_29_7, iter_29_8 in ipairs(arg_29_5) do
			local var_29_10 = arg_29_1[iter_29_8][1]

			table.insert(var_29_9, var_29_10)
		end

		table.sort(var_29_9, function(arg_31_0, arg_31_1)
			return arg_31_0.finishTime > arg_31_1.finishTime
		end)

		for iter_29_9, iter_29_10 in ipairs(var_29_9) do
			if var_29_1 >= 3 then
				break
			end

			local var_29_11 = {
				cfg = var_29_0[iter_29_10.csvId],
				csvId = iter_29_10.csvId,
				flag = arg_29_2[iter_29_10.csvId][1],
				count = gGameModel.role:getAchievement(iter_29_10.csvId)
			}

			table.insert(var_29_2, var_29_11)

			var_29_1 = var_29_1 + 1
		end
	end

	return var_29_2, var_29_1
end

function var_0_13.addUnVisibleItem(arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = csv.achievement.achievement_task

	for iter_32_0, iter_32_1 in ipairs(arg_32_1) do
		if iter_32_1.type == var_0_1.UNVISLBLEACHIEVEMENT then
			return
		end
	end

	for iter_32_2, iter_32_3 in pairs(arg_32_2) do
		if var_32_0[iter_32_2].type == var_0_1.UNVISLBLEACHIEVEMENT then
			table.insert(arg_32_1, {
				isSel = false,
				idx = 8,
				enTxt = "Hide",
				type = 7,
				txt = gLanguageCsv.unvislbleAchievement
			})
			arg_32_0.btnDatas:update(arg_32_1)

			break
		end
	end
end

function var_0_13.getRightDatas(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	local var_33_0 = {}
	local var_33_1 = 0
	local var_33_2 = {}

	local function var_33_3(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
		if not var_0_5[arg_34_0] then
			if arg_34_1 < arg_34_3 or arg_34_2[1] == 1 then
				return true
			end

			return false
		end

		if arg_34_1 == 0 or arg_34_3 < arg_34_1 or arg_34_2[1] == 1 then
			return true
		end

		return false
	end

	local function var_33_4(arg_35_0)
		local var_35_0
		local var_35_1 = #arg_35_0

		for iter_35_0, iter_35_1 in ipairs(arg_35_0) do
			local var_35_2 = gGameModel.role:getAchievement(iter_35_1.csvId)
			local var_35_3 = arg_33_2[iter_35_1.csvId] or {}

			if iter_35_1.cfg.type ~= 7 and iter_35_1.cfg.isShow or false or var_35_3[1] == var_0_3.GET or var_35_3[1] == var_0_3.FINISHED then
				if var_33_3(taskType, var_35_2, var_35_3, iter_35_1.cfg.targetArg) then
					return iter_35_1
				end

				var_35_0 = iter_35_1
			end
		end

		return var_35_0
	end

	for iter_33_0, iter_33_1 in pairs(arg_33_3) do
		local var_33_5 = var_33_4(iter_33_1)

		if var_33_5 then
			local var_33_6 = arg_33_2[var_33_5.csvId] or {}
			local var_33_7 = {
				flag = var_33_6[1] or var_0_3.DOING,
				count = gGameModel.role:getAchievement(var_33_5.csvId),
				cfg = var_33_5.cfg,
				csvId = var_33_5.csvId
			}

			table.insert(var_33_2, var_33_7)

			if arg_33_1 ~= var_0_0.UNVISLBLEACHIEVEMENT then
				var_33_1 = var_33_1 + 1
			elseif not itertools.isempty(var_33_6) then
				var_33_1 = var_33_1 + 1

				table.insert(var_33_0, var_33_7)
			end
		end
	end

	if arg_33_1 == var_0_0.UNVISLBLEACHIEVEMENT then
		var_33_2 = var_33_0
	end

	table.sort(var_33_2, function(arg_36_0, arg_36_1)
		if arg_36_0.flag == arg_36_1.flag then
			return arg_36_0.csvId < arg_36_1.csvId
		elseif arg_36_0.flag ~= var_0_3.FINISHED and arg_36_1.flag ~= var_0_3.FINISHED then
			return arg_36_0.flag < arg_36_1.flag
		else
			return arg_36_0.flag ~= var_0_3.FINISHED
		end
	end)

	return var_33_2, var_33_1
end

function var_0_13.initModel(arg_37_0)
	arg_37_0.boxAward = gGameModel.role:getIdler("achievement_box_awards")
	arg_37_0.points = gGameModel.role:getIdler("achievement_points")
	arg_37_0.tasks = gGameModel.role:getIdler("achievement_tasks")
end

function var_0_13.getCurLvAndNextExp(arg_38_0, arg_38_1)
	arg_38_1 = arg_38_1 or arg_38_0.selIdx:read()

	local var_38_0 = 0
	local var_38_1 = 0

	if arg_38_1 == var_0_0.UNVISLBLEACHIEVEMENT then
		return var_38_0, var_38_1
	end

	local var_38_2 = arg_38_0.btnDatas:atproxy(arg_38_1).type
	local var_38_3 = itertools.size(gAchievementLevelCsv[var_38_2]) - 1
	local var_38_4 = (arg_38_0.points:read() or {})[var_38_2] or 0

	if arg_38_1 == var_0_0.ACHIEVEMENTALL then
		var_38_4 = 0

		for iter_38_0, iter_38_1 in pairs(arg_38_0.points:read() or {}) do
			var_38_4 = var_38_4 + iter_38_1
		end
	end

	for iter_38_2, iter_38_3 in ipairs(gAchievementLevelCsv[var_38_2]) do
		if var_38_4 < iter_38_3.point then
			var_38_0 = iter_38_2 - 1
			var_38_4 = iter_38_3.point

			break
		end

		if iter_38_2 == var_38_3 then
			var_38_0 = iter_38_2
			var_38_4 = iter_38_3.point
		end
	end

	return var_38_0, var_38_4
end

function var_0_13.onClickBtn(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	arg_39_0.selIdx:modify(function(arg_40_0)
		arg_39_0.btnDatas:atproxy(arg_40_0).isSel = false
		arg_39_0.btnDatas:atproxy(arg_39_2).isSel = true

		return true, arg_39_2
	end)
end

function var_0_13.onChangeListPage(arg_41_0, arg_41_1)
	arg_41_0.allListPageIdx:set(arg_41_1)
end

function var_0_13.onShowRank(arg_42_0)
	gGameApp:requestServer("/game/rank", function(arg_43_0)
		gGameUI:stackUI("city.achievement_rank", nil, nil, arg_43_0.view.rank)
	end, "achievement", 0, 50)
end

function var_0_13.onClickJump(arg_44_0, arg_44_1, arg_44_2)
	if arg_44_2.cfg.jumpTo == "" then
		return
	end

	jumpEasy.jumpTo(arg_44_2.cfg.jumpTo)
end

function var_0_13.onClickGet(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	local var_45_0 = arg_45_0:getCurLvAndNextExp(var_0_0.ACHIEVEMENTALL)
	local var_45_1 = gAchievementLevelCsv[arg_45_0.btnDatas:atproxy(var_0_0.ACHIEVEMENTALL).type]
	local var_45_2 = var_45_1[var_45_0].spine
	local var_45_3 = {
		false
	}

	gGameApp:requestServerCustom("/game/role/achievement/task/award/get"):params(arg_45_3.csvId):onResponse(function(arg_46_0)
		local var_46_0 = arg_45_0:getCurLvAndNextExp(var_0_0.ACHIEVEMENTALL)
		local var_46_1 = var_45_1[var_46_0].spine
		local var_46_2 = 0

		if var_45_2 ~= var_46_1 then
			arg_45_0.isLvUp = true

			if arg_45_0.selIdx:read() == var_0_0.ACHIEVEMENTALL then
				arg_45_0:showLevelSpine()

				var_46_2 = var_0_7.levelUp
			end
		end

		performWithDelay(arg_45_0, function()
			var_45_3[1] = true
		end, var_46_2)
	end):wait(var_45_3):doit(function(arg_48_0)
		gGameUI:showGainDisplay(arg_48_0)
	end)
end

function var_0_13.showLevelSpine(arg_49_0)
	local var_49_0 = arg_49_0.btnDatas:atproxy(arg_49_0.selIdx).type
	local var_49_1 = ((gAchievementLevelCsv[var_49_0] or {})[arg_49_0:getCurLvAndNextExp()] or {}).spine
	local var_49_2 = var_0_6[var_49_1]

	arg_49_0.imgIcon:visible(not var_49_2)

	if not arg_49_0.rightAllInfo:getChildByName("flag") and var_49_2 then
		widget.addAnimationByKey(arg_49_0.rightAllInfo, "chengjiu/chengjiutubiaotexiao.skel", "flag", var_49_2, 1):scale(2):xy(196, 100)
	end

	if arg_49_0.isLvUp then
		arg_49_0.isLvUp = false

		local var_49_3 = arg_49_0.rightAllInfo:getChildByName("effect")

		if not var_49_3 then
			var_49_3 = widget.addAnimationByKey(arg_49_0.rightAllInfo, "chengjiu/chengjiutubiaotexiao.skel", "effect", var_49_1, 6):scale(2):xy(196, 100)
		else
			var_49_3:show()
			var_49_3:play(var_49_1)
		end

		var_49_3:setSpriteEventHandler(function(arg_50_0, arg_50_1)
			var_49_3:hide()
		end, sp.EventType.ANIMATION_COMPLETE)
	end
end

function var_0_13.onGetBoxGift(arg_51_0, arg_51_1)
	if not arg_51_0.curBoxReward then
		local var_51_0 = arg_51_0.btnDatas:atproxy(arg_51_0.selIdx:read()).type
		local var_51_1, var_51_2 = arg_51_0:getCurLvAndNextExp()
		local var_51_3 = var_0_9(var_51_0, var_51_1)
		local var_51_4 = string.format(gLanguageCsv.needTargetAchievementLv, var_51_1 + 1)

		if var_0_4.OTHER == arg_51_1 then
			var_51_4 = string.format(gLanguageCsv.needTargetAchievementPoint, var_51_2)
		end

		if not var_51_3 then
			local var_51_5 = var_0_8(var_51_0, var_51_1)

			gGameUI:showBoxDetail({
				state = 1,
				data = var_51_5,
				content = var_51_4
			})
		end

		return
	end

	gGameApp:requestServer("/game/role/achievement/box/award/get", function(arg_52_0)
		gGameUI:showGainDisplay(arg_52_0)
	end, arg_51_0.curBoxReward.csvId)
end

function var_0_13.onCleanup(arg_53_0)
	arg_53_0._selIdx = arg_53_0.selIdx:read()

	var_0_12.onCleanup(arg_53_0)
end

return var_0_13
