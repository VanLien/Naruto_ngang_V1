local var_0_0 = 5
local var_0_1 = {
	TASK = 2,
	REWARD = 1,
	SHOP = 3
}
local var_0_2 = {
	"rewardPanel",
	"taskPanel",
	"shopPanel"
}
local var_0_3 = {
	{
		bgPath = "activity/passport/task/bg_day.png",
		cornerPath = "activity/passport/task/lab_day.png",
		name = gLanguageCsv.everyday
	},
	{
		bgPath = "activity/passport/task/bg_week.png",
		cornerpath = "activity/passport/task/lab_week.png",
		name = gLanguageCsv.everyweek
	},
	{
		bgPath = "activity/passport/task/panle_day.png",
		cornerpath = "activity/passport/task/logo_day.png",
		name = gLanguageCsv.everydayVip
	},
	{
		bgPath = "activity/passport/task/panle_week.png",
		cornerpath = "activity/passport/task/logo_week.png",
		name = gLanguageCsv.everyweekVip
	}
}

local function var_0_4(arg_1_0, arg_1_1)
	arg_1_0:setTouchEnabled(arg_1_1)
	cache.setShader(arg_1_0, false, arg_1_1 and "normal" or "hsl_gray")

	if arg_1_1 then
		text.addEffect(arg_1_0:get("txtNode"), {
			outline = {
				size = 4,
				color = ui.NEWCOLORS.OUTLINE.YELLOW
			}
		})
	else
		text.deleteAllEffect(arg_1_0:get("txtNode"))
		text.addEffect(arg_1_0:get("txtNode"), {
			color = ui.COLORS.DISABLED.WHITE
		})
	end
end

local var_0_5 = cc.load("mvc").ViewBase
local var_0_6 = class("ActivityPassportView", var_0_5)

var_0_6.RESOURCE_FILENAME = "activity_passport.json"
var_0_6.RESOURCE_BINDING = {
	["rewardPanel.endTime"] = "rewardEndTime",
	["rewardPanel.icon"] = "rewardIcon",
	["taskPanel.txtNote"] = "taskNote",
	["rewardPanel.exp"] = "rewardExp",
	pointItem = "pointItem",
	iconItem = "iconItem",
	rewardPanel = "rewardPanel",
	["rewardPanel.highMask"] = "highMask",
	taskItem = "taskItem",
	["rewardPanel.scroll"] = "rewardScroll",
	["rewardPanel.target"] = "target",
	["rewardPanel.txtHigh"] = "rewardTxtHigh",
	["taskPanel.txtNode"] = "taskExpLess",
	["rewardPanel.iconPointPanel"] = "iconPointPanel",
	taskPanel = "taskPanel",
	["rewardPanel.highLock"] = "highLock",
	["taskPanel.iconTitle1"] = "taskIconTitle1",
	["rewardPanel.target.highPanel2"] = "targetHighPanel2",
	shopPanel = "shopPanel",
	["shopPanel.item"] = "shopItem",
	["taskPanel.notMaxPanel.imgLock"] = "taskImgLock",
	rewardItem = "rewardItem",
	["rewardPanel.textNode2"] = "txtNode2",
	["taskPanel.iconTitlePanel.iconTitle2"] = "taskIconTitle2",
	["taskPanel.iconTitle3"] = "taskIconTitle3",
	tabItem = "tabItem",
	["rewardPanel.target.noClick"] = "targetNoClick",
	["taskPanel.txtNote1"] = "taskNote1",
	["rewardPanel.imgLvMax"] = "imgLvMax",
	["taskPanel.icon"] = "taskIcon",
	["taskPanel.iconTitlePanel"] = "iconTitlePanel",
	["rewardPanel.txtNormal"] = "rewardTxtNormal",
	["rewardPanel.expBar"] = "rewardExpBar",
	["taskPanel.expBar"] = "taskExpBar",
	["rewardPanel.target.normalPanel"] = "targetNormalPanel",
	["taskPanel.notMaxPanel"] = "taskNotMaxPanel",
	["shopPanel.subList"] = "shopSubList",
	["rewardPanel.target.highPanel1"] = "targetHighPanel1",
	["taskPanel.notMaxPanel.normalList"] = "taskNormalList",
	["taskPanel.notMaxPanel.taskMask"] = "taskMask",
	["taskPanel.notMaxPanel.highList"] = "taskHighList",
	["taskPanel.notMaxPanel.txtHigh"] = "taskTxtHigh",
	["taskPanel.notMaxPanel.txtNormal"] = "taskTxtNormal",
	["taskPanel.imgMax"] = "taskImgMax",
	["tabItem.selected.txtNode"] = {
		varname = "rewardName",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.COLORS.OUTLINE.WHITE
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
				activityId = bindHelper.self("activityId"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:get("normal")
					local var_2_1 = arg_2_1:get("selected")
					local var_2_2

					if arg_2_3.select then
						var_2_0:hide()

						var_2_2 = var_2_1:show()
					else
						var_2_1:hide()

						var_2_2 = var_2_0:show()
					end

					local var_2_3 = var_2_2:getSize().height

					adapt.setAutoMultiLine(var_2_2:get("txtNode"), arg_2_3.name, var_2_3, 0)

					local var_2_4

					if arg_2_2 == var_0_1.REWARD then
						var_2_4 = "passportReward"
					elseif arg_2_2 == var_0_1.TASK then
						var_2_4 = "passportTask"
					end

					bind.extend(arg_2_0, var_2_2, {
						class = "red_hint",
						props = {
							state = arg_2_3.select ~= true and arg_2_3.red,
							specialTag = var_2_4,
							listenData = {
								activityId = arg_2_0.activityId
							},
							onNode = function(arg_3_0)
								arg_3_0:scale(0.5)
							end
						}
					})
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
	["rewardPanel.lv"] = {
		varname = "rewardLv",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = cc.c4b(123, 115, 118, 255)
				}
			}
		}
	},
	["rewardPanel.name"] = {
		varname = "rewardPanelName",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 6,
					color = ui.COLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["rewardPanel.btnRule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnRule")
			}
		}
	},
	["rewardPanel.btnRule.txtNode"] = {},
	["rewardPanel.btnBuy"] = {
		varname = "btnBuy",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnBuy")
			}
		}
	},
	["rewardPanel.btnBuyExp"] = {
		varname = "btnBuyExp",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnBuyExp")
			}
		}
	},
	["rewardPanel.btnOneKeyGet"] = {
		varname = "btnOneKeyGet",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnOneKeyGet")
			}
		}
	},
	["rewardPanel.btnOneKeyGet.txtNode"] = {
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
	["rewardPanel.btnBuy.txtNode"] = {
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
	["rewardPanel.btnBuyExp.txtNode"] = {
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
	["rewardItem.btnGet.txtNode"] = {
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
	["taskItem.btnGet.txtNode"] = {
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
	["taskItem.btnGo.txtNode"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE
				}
			}
		}
	},
	["rewardPanel.iconList"] = {
		varname = "iconList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("iconDatas"),
				item = bindHelper.self("iconItem"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					arg_4_1:get("icon"):texture(arg_4_3)
				end
			}
		}
	},
	["taskPanel.btnAllGet"] = {
		varname = "getBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_5_0)
					return arg_5_0:onAllGetBtn()
				end)
			}
		}
	},
	["taskPanel.list"] = {
		varname = "taskList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("taskDatas"),
				dataOrderCmp = function(arg_6_0, arg_6_1)
					if arg_6_0.sort ~= arg_6_1.sort then
						return arg_6_0.sort < arg_6_1.sort
					elseif arg_6_0.cfg.periodType ~= arg_6_1.cfg.periodType then
						return arg_6_0.cfg.periodType < arg_6_1.cfg.periodType
					else
						return arg_6_0.cfg.taskAttribute < arg_6_1.cfg.taskAttribute
					end
				end,
				item = bindHelper.self("taskItem"),
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					local var_7_0 = arg_7_1:multiget("bg", "cornerIcon", "cornerIcon1", "txtCorner", "txtCorner1", "txtTitle", "txtContent", "txtExp", "txtProgress", "btnGet", "btnGo", "imgGot")

					if arg_7_3.buyHigh or arg_7_3.cfg.taskAttribute == 3 then
						if arg_7_3.cfg.taskAttribute == 3 then
							var_7_0.cornerIcon1:hide()
							var_7_0.txtCorner1:hide()
							var_7_0.bg:texture(var_0_3[arg_7_3.cfg.periodType].bgPath)
							var_7_0.cornerIcon:texture(var_0_3[arg_7_3.cfg.periodType].cornerPath)
							var_7_0.txtCorner:text(var_0_3[arg_7_3.cfg.periodType].name)
						else
							var_7_0.cornerIcon:hide()
							var_7_0.txtCorner:hide()
							var_7_0.bg:texture(var_0_3[arg_7_3.cfg.periodType + 2].bgPath)
							var_7_0.cornerIcon1:texture(var_0_3[arg_7_3.cfg.periodType + 2].cornerPath)
							var_7_0.txtCorner1:text(var_0_3[arg_7_3.cfg.periodType + 2].name)
						end

						adapt.setTextScaleWithWidth(var_7_0.txtCorner, nil, 95)
						var_7_0.txtTitle:text(arg_7_3.cfg.title)
						var_7_0.txtContent:text(arg_7_3.cfg.desc)
						var_7_0.txtExp:text(gLanguageCsv.passportExp .. "+" .. arg_7_3.cfg.exp)
						text.addEffect(var_7_0.txtExp, {
							outline = {
								color = ui.COLORS.OUTLINE.WHITE
							}
						})
						var_7_0.txtProgress:text(arg_7_3.progress .. "/" .. arg_7_3.cfg.taskParam):visible(arg_7_3.state == 0)
						var_7_0.imgGot:visible(arg_7_3.state == 2)
						var_7_0.btnGet:visible(arg_7_3.state == 1)
						var_7_0.btnGo:hide()

						if arg_7_3.state == 0 then
							if arg_7_3.cfg.goToPanel then
								var_7_0.btnGo:show()
							else
								var_7_0.btnGo:hide()
							end
						end

						bind.touch(arg_7_0, var_7_0.btnGet, {
							methods = {
								ended = functools.partial(arg_7_0.clickCell, arg_7_1, arg_7_3)
							}
						})
						bind.touch(arg_7_0, var_7_0.btnGo, {
							methods = {
								ended = functools.partial(arg_7_0.clickGoCell, arg_7_3)
							}
						})
					else
						var_7_0.bg:hide()
						var_7_0.cornerIcon:hide()
						var_7_0.cornerIcon1:hide()
						var_7_0.txtCorner:hide()
						var_7_0.txtTitle:hide()
						var_7_0.txtContent:hide()
						var_7_0.txtExp:hide()
						var_7_0.txtProgress:hide()
						var_7_0.btnGet:hide()
						var_7_0.btnGo:hide()
						var_7_0.imgGot:hide()
						var_7_0.txtCorner1:hide()
						arg_7_1:height(0)
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onGetClick"),
				clickGoCell = bindHelper.self("onGoClick")
			}
		}
	},
	["shopPanel.list"] = {
		varname = "shoplist",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 5,
				asyncPreload = 15,
				data = bindHelper.self("shopDatas"),
				dataOrderCmp = function(arg_8_0, arg_8_1)
					return arg_8_0.position < arg_8_1.position
				end,
				item = bindHelper.self("shopSubList"),
				cell = bindHelper.self("shopItem"),
				sliderBg = bindHelper.self("slider"),
				onCell = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
					local var_9_0 = arg_9_1:multiget("name", "icon", "num", "btnBuy", "maskPanel", "textLimiteNote", "textLimiteNum")

					arg_9_1:setTouchEnabled(true)
					var_9_0.maskPanel:hide()
					var_9_0.icon:hide()

					local var_9_1 = uiEasy.setIconName(arg_9_3.itemId, nil, {
						node = var_9_0.name
					})

					adapt.setTextScaleWithWidth(var_9_0.name, var_9_0.name:text(), arg_9_1:width() - 150)
					bind.extend(arg_9_0, arg_9_1, {
						class = "icon_key",
						props = {
							simpleShow = true,
							data = {
								key = arg_9_3.itemId
							},
							onNode = function(arg_10_0)
								arg_10_0:setTouchEnabled(false)
								arg_10_0:xy(var_9_0.icon:xy()):scale(1.5):z(3)
							end
						}
					})
					var_9_0.num:text("x" .. arg_9_3.num)

					local var_9_2, var_9_3 = csvNext(arg_9_3.cfg.costMap)
					local var_9_4 = dataEasy.getCfgByKey(var_9_2)

					var_9_0.btnBuy:get("icon"):texture(dataEasy.getIconResByKey(var_9_2))
					var_9_0.btnBuy:get("txt"):text(var_9_3)
					adapt.oneLineCenterPos(cc.p(180, 50), {
						var_9_0.btnBuy:get("icon"),
						var_9_0.btnBuy:get("txt")
					}, cc.p(5, 0))
					bind.touch(arg_9_0, arg_9_1, {
						methods = {
							ended = functools.partial(arg_9_0.itemClick, arg_9_0:getIdx(arg_9_2), arg_9_3)
						}
					})

					if arg_9_3.itemNum == 0 then
						arg_9_1:setTouchEnabled(false)
						var_9_0.maskPanel:show()
					end

					local var_9_5 = arg_9_3.cfg.limitTimes
					local var_9_6 = arg_9_3.itemNum

					if var_9_5 > 0 then
						var_9_0.textLimiteNum:text(var_9_6 .. "/" .. var_9_5)

						local var_9_7 = ui.COLORS.NORMAL.FRIEND_GREEN

						if var_9_6 == 0 then
							var_9_7 = ui.COLORS.NORMAL.ALERT_ORANGE
						end

						text.addEffect(arg_9_1:get("textLimiteNum"), {
							color = var_9_7
						})
					end

					var_9_0.textLimiteNote:visible(var_9_5 > 0)
					var_9_0.textLimiteNum:visible(var_9_5 > 0)
					adapt.oneLineCenterPos(cc.p(210, 150), {
						var_9_0.textLimiteNote,
						var_9_0.textLimiteNum
					}, cc.p(5, 0))
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	["taskPanel.lv"] = {
		varname = "taskLv",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = cc.c4b(123, 115, 118, 255)
				}
			}
		}
	}
}

function var_0_6.onCreate(arg_11_0, arg_11_1)
	arg_11_0.shopPanel:hide()
	gGameModel.currday_dispatch:getIdlerOrigin("passport"):set(true)

	arg_11_0.activityId = arg_11_1

	arg_11_0:initModel()
	arg_11_0:initData()

	local var_11_0 = csv.yunying.yyhuodong[arg_11_0.activityId]

	arg_11_0.endDate = var_11_0.endDate
	arg_11_0.topView = gGameUI.topuiManager:createView(arg_11_0.exchangeShop == 1 and "passport" or "default", arg_11_0, {
		onClose = arg_11_0:createHandler("onClose")
	}):init({
		subTitle = "ORNAMENTS",
		title = "common/txt/txt_bt_tongxingzheng.png"
	})
	arg_11_0.tabDatas = idlers.newWithMap({
		{
			red = true,
			name = gLanguageCsv.passport
		},
		{
			red = true,
			name = gLanguageCsv.task
		},
		arg_11_0.exchangeShop == 1 and {
			red = false,
			name = gLanguageCsv.starSkillExchange
		} or nil
	})
	arg_11_0.showTab = idler.new(var_0_1.REWARD)

	arg_11_0.showTab:addListener(function(arg_12_0, arg_12_1)
		arg_11_0[var_0_2[arg_12_1]]:visible(false)
		arg_11_0[var_0_2[arg_12_0]]:visible(true)

		arg_11_0.tabDatas:atproxy(arg_12_1).select = false
		arg_11_0.tabDatas:atproxy(arg_12_0).select = true
	end)

	local var_11_1, var_11_2 = arg_11_0.taskHighList:xy()

	arg_11_0.spineExp = widget.addAnimationByKey(arg_11_0.taskPanel, "tongxingzheng/tongxingzheng.skel", "spineExp", "effect2", 999):xy(arg_11_0.taskIcon:x(), arg_11_0.taskIcon:y()):scale(2)

	arg_11_0.spineExp:setTimeScale(0)
	arg_11_0.rewardPanelName:text(var_11_0.name)

	arg_11_0.clientBuyTimes = idler.new(true)

	idlereasy.any({
		arg_11_0.passport,
		arg_11_0.clientBuyTimes
	}, function(arg_13_0, arg_13_1)
		local var_13_0 = 0
		local var_13_1 = {}

		arg_11_0.currentPassportLv = arg_13_1.level

		local var_13_2 = arg_11_0.max == arg_13_1.level

		arg_11_0.buyHigh = itertools.size(arg_13_1.buy) > 0
		arg_11_0.curRewardIdx = nil

		local var_13_3 = 1

		for iter_13_0, iter_13_1 in ipairs(arg_11_0.awardCfg) do
			local var_13_4 = iter_13_1.cfg
			local var_13_5 = iter_13_1.custom

			if var_13_4.level <= arg_13_1.level then
				var_13_0 = var_13_0 + var_13_4.needExp
			end

			if var_13_4.level == arg_13_1.level + 1 then
				var_13_1 = iter_13_1
			end

			local var_13_6 = arg_13_1.normal_award[var_13_5.csvId]

			if var_13_6 and var_13_5.normalAwardState ~= var_13_6 then
				var_13_5.normalAwardState = var_13_6

				if not arg_11_0.isReset then
					arg_11_0:modifyItem(iter_13_0)
				end
			end

			local var_13_7 = arg_13_1.elite_award[var_13_5.csvId]

			if var_13_7 and var_13_5.eliteAwardState ~= var_13_7 then
				var_13_5.eliteAwardState = var_13_7

				if not arg_11_0.isReset then
					arg_11_0:modifyItem(iter_13_0)
				end
			end

			if not arg_11_0.curRewardIdx then
				if not arg_11_0.buyHigh then
					if var_13_5.normalAwardState == 1 then
						arg_11_0.curRewardIdx = iter_13_0
					elseif var_13_5.normalAwardState == 0 then
						var_13_3 = iter_13_0
					end
				elseif var_13_5.normalAwardState == 1 or var_13_5.eliteAwardState == 1 then
					arg_11_0.curRewardIdx = iter_13_0
				elseif var_13_5.normalAwardState == 0 and var_13_5.eliteAwardState == 0 then
					var_13_3 = iter_13_0
				end
			end
		end

		arg_11_0.curRewardIdx = arg_11_0.curRewardIdx or var_13_3

		arg_11_0.rewardLv:text(arg_13_1.level)

		local var_13_8 = arg_11_0.buyHigh and arg_11_0.recharge[2].name or arg_11_0.recharge[1].name

		arg_11_0.rewardName:text(var_13_8)
		arg_11_0.rewardTxtNormal:text(arg_11_0.recharge[1].name)
		arg_11_0.rewardTxtHigh:text(arg_11_0.recharge[2].name)

		local var_13_9 = string.split(time.getActivityOpenDate(arg_13_1.yy_id), "-")

		arg_11_0.rewardEndTime:text(var_13_9[2])

		local var_13_10 = arg_13_1.exp - var_13_0 + arg_11_0.awardCfg[arg_13_1.level].cfg.needExp .. "/" .. arg_11_0.awardCfg[arg_13_1.level].cfg.needExp
		local var_13_11 = string.format(gLanguageCsv.leveUpLessExp, var_13_0 - arg_13_1.exp)

		if var_13_2 then
			var_13_10, var_13_11 = gLanguageCsv.levelMax, gLanguageCsv.levelMax
		else
			uiEasy.createItemsToList(arg_11_0, arg_11_0.taskNormalList, var_13_1.cfg.normalAward, {
				scale = 0.8
			})
			uiEasy.createItemsToList(arg_11_0, arg_11_0.taskHighList, var_13_1.cfg.eliteAward, {
				margin = 20,
				scale = 0.8,
				onAfterBuild = function()
					arg_11_0.taskHighList:setItemAlignCenter()
				end
			})
		end

		arg_11_0.rewardExp:text(var_13_10)
		arg_11_0.taskExpLess:text(var_13_11)
		arg_11_0.txtNode2:visible(arg_13_1.level ~= arg_11_0.max)
		arg_11_0.rewardExpBar:setPercent((arg_13_1.exp - var_13_0 + arg_11_0.awardCfg[arg_13_1.level].cfg.needExp) / arg_11_0.awardCfg[arg_13_1.level].cfg.needExp * 100)
		arg_11_0.imgLvMax:visible(var_13_2)
		arg_11_0:updBuyTime(var_13_2)
		arg_11_0.highMask:visible(not arg_11_0.buyHigh)
		arg_11_0.highLock:visible(not arg_11_0.buyHigh)

		local var_13_12 = var_11_0.clientParam.version

		arg_11_0.taskIconTitle2:x(465 - 116 * (var_13_12 - 1))
		arg_11_0.taskIcon:texture(arg_11_0.buyHigh and "activity/passport/icon_better_2.png" or "activity/passport/icon_regular_2.png")
		arg_11_0.rewardIcon:texture(arg_11_0.buyHigh and "activity/passport/icon_better_2.png" or "activity/passport/icon_regular_2.png")
		arg_11_0.taskIconTitle3:texture(arg_11_0.buyHigh and "activity/passport/task/" .. "txt_ds.png" or "activity/passport/task/" .. "txt_mx.png")
		arg_11_0.taskImgLock:visible(not arg_11_0.buyHigh)
		arg_11_0.taskMask:visible(not arg_11_0.buyHigh)
		arg_11_0.taskLv:text(arg_13_1.level)
		arg_11_0.taskExpBar:setPercent((arg_13_1.exp - var_13_0 + arg_11_0.awardCfg[arg_13_1.level].cfg.needExp) / arg_11_0.awardCfg[arg_13_1.level].cfg.needExp * 100)
		arg_11_0.taskImgMax:visible(var_13_2)
		arg_11_0.taskNotMaxPanel:visible(not var_13_2)
		arg_11_0.taskTxtNormal:text(arg_11_0.recharge[1].name)
		arg_11_0.taskTxtHigh:text(arg_11_0.recharge[2].name)
		arg_11_0:updTaskData(arg_13_1)
		arg_11_0:updataShopDatas()
		arg_11_0:updShowView()
	end)

	if arg_11_0.isReset then
		arg_11_0:resetScroll()
	end

	local var_11_3 = string.split(var_11_0.clientParam.res, "|")
	local var_11_4 = itertools.size(var_11_3)

	arg_11_0.iconDatas = idlers.newWithMap(var_11_3)

	arg_11_0:enableSchedule()
	arg_11_0:schedule(function()
		local var_15_0 = arg_11_0.index:read()

		if var_15_0 < var_11_4 - 1 then
			var_15_0 = var_15_0 + 1
		else
			var_15_0 = 0
		end

		arg_11_0.index:set(var_15_0)
		arg_11_0.iconList:jumpToItem(var_15_0, cc.p(0, 1), cc.p(0, 1))
	end, var_0_0, var_0_0, 1)
	arg_11_0.iconList:onScroll(function(arg_16_0)
		local var_16_0 = arg_11_0.iconList:getIndex(arg_11_0.iconList:getCenterItemInCurrentView())

		if arg_16_0.name == "SCROLLING_ENDED" then
			arg_11_0.iconList:jumpToItem(var_16_0, cc.p(0, 1), cc.p(0, 1))
			arg_11_0.index:set(var_16_0)
		end
	end)

	for iter_11_0 = 1, var_11_4 do
		local var_11_5 = arg_11_0.iconPointPanel:width() / 2 - (var_11_4 - 1) / 2 * (arg_11_0.pointItem:width() + 16) + (iter_11_0 - 1) * (arg_11_0.pointItem:width() + 16)
		local var_11_6 = arg_11_0.iconPointPanel:height() / 2
		local var_11_7 = arg_11_0.pointItem:clone():xy(var_11_5, var_11_6):show():addTo(arg_11_0.iconPointPanel, 10, "point" .. iter_11_0)
	end

	idlereasy.when(arg_11_0.index, function(arg_17_0, arg_17_1)
		for iter_17_0 = 1, var_11_4 do
			arg_11_0.iconPointPanel:get("point" .. iter_17_0):setOpacity(102)
		end

		arg_11_0.iconPointPanel:get("point" .. arg_17_1 + 1):setOpacity(178.5)
	end)
	adapt.oneLineCenterPos(cc.p(450, 1000), {
		arg_11_0.taskIconTitle1,
		arg_11_0.iconTitlePanel,
		arg_11_0.taskIconTitle3
	}, {
		cc.p(2, -arg_11_0.iconTitlePanel:size().height / 2),
		cc.p(2, arg_11_0.iconTitlePanel:size().height / 2)
	})
end

function var_0_6.initModel(arg_18_0)
	arg_18_0.passport = gGameModel.role:getIdler("passport")
	arg_18_0.shop = arg_18_0.passport:read().shop or {}
end

function var_0_6.initData(arg_19_0)
	local var_19_0 = csv.yunying.yyhuodong[arg_19_0.activityId]

	arg_19_0.awardCfg = {}

	for iter_19_0, iter_19_1 in orderCsvPairs(csv.yunying.passport_award) do
		if iter_19_1.huodongID == var_19_0.huodongID then
			table.insert(arg_19_0.awardCfg, {
				cfg = iter_19_1,
				custom = {
					csvId = iter_19_0
				}
			})
		end
	end

	arg_19_0.taskCfg = {}

	local var_19_1 = var_19_0.paramMap.taskHuodongID

	arg_19_0.startHideLevel = var_19_0.paramMap.startHideLevel or 0
	arg_19_0.exchangeShop = var_19_0.paramMap.exchangeShop

	for iter_19_2, iter_19_3 in orderCsvPairs(csv.yunying.passport_task) do
		if iter_19_3.huodongID == var_19_1 then
			arg_19_0.taskCfg[iter_19_2] = iter_19_3
		end
	end

	arg_19_0.shopCfg = {}

	for iter_19_4, iter_19_5 in orderCsvPairs(csv.yunying.passport_shop) do
		if iter_19_5.huodongID == var_19_0.huodongID then
			arg_19_0.shopCfg[iter_19_4] = iter_19_5
		end
	end

	arg_19_0.recharge = csv.yunying.passport_recharge
	arg_19_0.max = #arg_19_0.awardCfg
	arg_19_0.taskDatas = idlers.newWithMap({})
	arg_19_0.shopDatas = idlers.newWithMap({})
	arg_19_0.currentPassportLv = arg_19_0.passport:read().level
	arg_19_0.buyHigh = itertools.size(arg_19_0.passport:read().buy) > 0
	arg_19_0.index = idler.new(0)
	arg_19_0.isReset = true

	if not arg_19_0.clock then
		arg_19_0.clock = 1
	end

	arg_19_0.items = gGameModel.role:getIdler("items")
end

function var_0_6.updBuyTime(arg_20_0, arg_20_1)
	arg_20_0.btnBuy:visible(not arg_20_0.buyHigh)

	for iter_20_0, iter_20_1 in orderCsvPairs(csv.yunying.passport_recharge) do
		if iter_20_1.type == 1 and dataEasy.getPayClientBuyTimes("directBuyData", arg_20_0.activityId, iter_20_0, 0) > 0 then
			arg_20_0.btnBuy:hide()
		end
	end

	arg_20_0.btnBuyExp:hide()

	local var_20_0 = csv.yunying.yyhuodong[arg_20_0.activityId]

	if arg_20_0.buyHigh and not arg_20_1 then
		local var_20_1 = (gGameModel.role:read("yy_endtime")[arg_20_0.activityId] or 0) - time.getTime()
		local var_20_2 = var_20_0.clientParam.buyExpShowDay and var_20_0.clientParam.buyExpShowDay > 0 and var_20_1 <= var_20_0.clientParam.buyExpShowDay * 24 * 3600

		if var_20_0.paramMap.canBuyExp == 1 or var_20_2 then
			arg_20_0.btnBuyExp:show()
		end
	end
end

function var_0_6.updTaskData(arg_21_0, arg_21_1)
	local var_21_0 = {}
	local var_21_1 = false

	arg_21_0.playDatas = 0

	for iter_21_0, iter_21_1 in pairs(arg_21_0.taskCfg) do
		local var_21_2 = iter_21_1.periodType == 1

		var_21_2 = var_21_2 or iter_21_1.periodType == 2 and iter_21_1.weekParam == arg_21_1.week_num
		var_21_2 = var_21_2 and (iter_21_1.taskAttribute == 3 or arg_21_0.buyHigh)

		if var_21_2 then
			local var_21_3 = {
				progress = 0,
				sort = 2,
				state = 0,
				cfg = iter_21_1,
				csvId = iter_21_0,
				buyHigh = arg_21_0.buyHigh
			}
			local var_21_4 = arg_21_1.task[iter_21_0]

			if var_21_4 then
				var_21_3.progress = var_21_4[1]
				var_21_3.state = var_21_4[2]

				if var_21_4[2] ~= 0 then
					var_21_3.sort = var_21_4[2] == 1 and 1 or 3

					if var_21_4[2] == 1 then
						var_21_1 = true

						if arg_21_0.playDatas < 5 then
							arg_21_0.playDatas = arg_21_0.playDatas + 1
						end
					end
				end
			end

			table.insert(var_21_0, var_21_3)
		end
	end

	var_0_4(arg_21_0.getBtn, var_21_1)
	arg_21_0.taskDatas:update(var_21_0)
end

function var_0_6.updataShopDatas(arg_22_0)
	local var_22_0 = {}

	for iter_22_0, iter_22_1 in pairs(arg_22_0.shopCfg) do
		local var_22_1 = arg_22_0:getItemNum(iter_22_0, iter_22_1)
		local var_22_2, var_22_3 = csvNext(iter_22_1.items)
		local var_22_4, var_22_5 = csvNext(iter_22_1.costMap)
		local var_22_6 = {
			position = iter_22_1.position,
			costType = var_22_4,
			costNum = var_22_5,
			cfg = iter_22_1,
			csvId = iter_22_0,
			itemId = var_22_2,
			num = var_22_3,
			itemNum = var_22_1 or iter_22_1.limitTimes
		}

		table.insert(var_22_0, var_22_6)
	end

	arg_22_0.shopDatas:update(var_22_0)
end

function var_0_6.updShowView(arg_23_0)
	if arg_23_0.currentPassportLv > arg_23_0.startHideLevel and arg_23_0.clock == 1 then
		arg_23_0:resetScroll()

		arg_23_0.clock = 0
	end

	if not arg_23_0.buyHigh then
		local var_23_0 = rich.createWithWidth(gLanguageCsv.passwordActivateNote, 40, nil, 1250):addTo(arg_23_0.taskNote, 10):anchorPoint(cc.p(0, 0.5)):xy(-410, 10):formatText()
	else
		arg_23_0.taskNote:hide()

		local var_23_1 = rich.createWithWidth(gLanguageCsv.passwordTaskNote, 40, nil, 1250):addTo(arg_23_0.taskNote1, 10):anchorPoint(cc.p(0, 0.5)):xy(-410, 5):formatText()
	end
end

function var_0_6.onTabClick(arg_24_0, arg_24_1, arg_24_2)
	arg_24_0.rewardScroll:stopAutoScroll()
	arg_24_0.taskList:stopAutoScroll()
	arg_24_0.showTab:set(arg_24_2)
end

function var_0_6.onBtnRule(arg_25_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_25_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_6.onBtnBuy(arg_26_0)
	arg_26_0.rewardScroll:stopAutoScroll()
	gGameUI:stackUI("city.activity.passport.buy", nil, nil, arg_26_0.activityId, arg_26_0:createHandler("onBtnBuyCb"))
end

function var_0_6.onBtnBuyCb(arg_27_0)
	arg_27_0.clientBuyTimes:notify()
end

function var_0_6.onBtnBuyExp(arg_28_0)
	arg_28_0.rewardScroll:stopAutoScroll()
	gGameUI:stackUI("city.activity.passport.buy_exp", nil, nil, arg_28_0.activityId)
end

function var_0_6.getRuleContext(arg_29_0, arg_29_1)
	local var_29_0 = adaptContext

	return {
		var_29_0.clone(arg_29_1.title, function(arg_30_0)
			arg_30_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_29_0.noteText(116),
		var_29_0.noteText(63001, 63006)
	}
end

function var_0_6.onBtnGetClick(arg_31_0, arg_31_1)
	gGameApp:requestServer("/game/yy/award/get", function(arg_32_0)
		gGameUI:showGainDisplay(arg_32_0)
	end, arg_31_0.activityId, arg_31_1.custom.csvId)
end

function var_0_6.onBtnOneKeyGet(arg_33_0)
	local var_33_0 = false
	local var_33_1 = arg_33_0.passport:read()

	for iter_33_0, iter_33_1 in pairs(var_33_1.normal_award) do
		if iter_33_1 == 1 then
			var_33_0 = true

			break
		end
	end

	for iter_33_2, iter_33_3 in pairs(var_33_1.elite_award) do
		if iter_33_3 == 1 then
			var_33_0 = true

			break
		end
	end

	if not var_33_0 then
		gGameUI:showTip(gLanguageCsv.noRewardGet)

		return
	end

	gGameApp:requestServer("/game/yy/passport/award/get_onekey", function(arg_34_0)
		gGameUI:showGainDisplay(arg_34_0)
		arg_33_0:resetScroll()
	end, arg_33_0.activityId)
end

function var_0_6.onGetClick(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	local var_35_0 = {
		false
	}

	gGameApp:requestServerCustom("/game/yy/passport/task/get_exp"):params(arg_35_0.activityId, arg_35_3.csvId):onResponse(function()
		widget.addAnimationByKey(arg_35_2, "tongxingzheng/tongxingzheng.skel", "lingqu", "effect1", 999):xy(arg_35_2:width() / 2 + 25, arg_35_2:height() / 2):scale(2.2):play("effect1")
		arg_35_0.spineExp:setTimeScale(1)
		arg_35_0.spineExp:play("effect2")
		performWithDelay(arg_35_0, function()
			var_35_0[1] = true
		end, 0.8666666666666667)
	end):wait(var_35_0):doit()
end

function var_0_6.onAllGetBtn(arg_38_0)
	local var_38_0 = {
		false
	}

	gGameApp:requestServerCustom("/game/yy/passport/task/get_exp"):params(arg_38_0.activityId, -1):onResponse(function()
		local var_39_0 = arg_38_0.taskList:getItems()

		for iter_39_0 = 1, arg_38_0.playDatas do
			widget.addAnimationByKey(var_39_0[iter_39_0], "tongxingzheng/tongxingzheng.skel", "lingqu", "effect1", 999):xy(var_39_0[iter_39_0]:width() / 2 + 25, var_39_0[iter_39_0]:height() / 2):scale(2.2):play("effect1")
		end

		arg_38_0.spineExp:setTimeScale(1)
		arg_38_0.spineExp:play("effect2")
		performWithDelay(arg_38_0, function()
			var_38_0[1] = true
		end, 0.8666666666666667)
	end):wait(var_38_0):doit()
end

function var_0_6.onGoClick(arg_41_0, arg_41_1, arg_41_2)
	jumpEasy.jumpTo(arg_41_2.cfg.goToPanel)
end

function var_0_6.buildScroll(arg_42_0)
	arg_42_0.rewardScroll:setScrollBarEnabled(false)

	local var_42_0 = arg_42_0.rewardItem:width()
	local var_42_1 = arg_42_0.rewardScroll:size()
	local var_42_2 = arg_42_0.rewardScroll:getInnerContainer()
	local var_42_3 = 0
	local var_42_4 = 0

	if arg_42_0.currentPassportLv < arg_42_0.startHideLevel then
		var_42_3, var_42_4 = var_42_0 * arg_42_0.startHideLevel, var_42_1.height
	else
		var_42_3, var_42_4 = var_42_0 * arg_42_0.max, var_42_1.height
	end

	var_42_2:size(var_42_3, var_42_4)

	arg_42_0.itemCreateNum = math.ceil(var_42_1.width / var_42_0) + 5

	local var_42_5 = arg_42_0.itemCreateNum
	local var_42_6 = var_42_0 * var_42_5
	local var_42_7 = arg_42_0.curRewardIdx
	local var_42_8 = arg_42_0.curRewardIdx - 1 + arg_42_0.itemCreateNum

	if var_42_8 > arg_42_0.max then
		var_42_7 = var_42_7 - (var_42_8 - arg_42_0.max)

		local var_42_9 = arg_42_0.max
	end

	local var_42_10 = var_42_7 % var_42_5 == 0 and var_42_5 or var_42_7 % var_42_5
	local var_42_11 = var_42_10 - 1 == 0 and var_42_5 or var_42_10 - 1
	local var_42_12
	local var_42_13

	arg_42_0.percent = -1

	local function var_42_14()
		local var_43_0 = arg_42_0.rewardScroll:getScrolledPercentHorizontal()

		if var_43_0 < arg_42_0.percent then
			var_42_12 = "right"
			var_42_13 = var_42_11
			arg_42_0.percent = var_43_0
		elseif var_43_0 > arg_42_0.percent then
			var_42_12 = "left"
			var_42_13 = var_42_10
			arg_42_0.percent = var_43_0
		end

		local var_43_1 = math.abs(var_42_2:x())
		local var_43_2 = var_43_1 + var_42_1.width
		local var_43_3 = arg_42_0.rewardScroll:getChildByName("reward" .. var_42_13)
		local var_43_4 = math.ceil(var_43_2 / var_42_0)
		local var_43_5 = arg_42_0.currentPassportLv >= arg_42_0.startHideLevel and arg_42_0.max or arg_42_0.startHideLevel

		for iter_43_0 = var_43_4, var_43_5 do
			if arg_42_0.awardCfg[iter_43_0].cfg.specialAward == 1 then
				if iter_43_0 ~= arg_42_0.rigthRewardIndex then
					arg_42_0.rigthRewardIndex = iter_43_0

					arg_42_0:refreshTarget()
				end

				break
			end
		end

		local function var_43_6(arg_44_0, arg_44_1)
			local var_44_0 = arg_44_1

			if arg_44_0 ~= "left" then
				var_44_0 = var_42_5 - arg_44_1
			end

			var_42_10 = (var_44_0 + var_42_10 - 1) % var_42_5 + 1
			var_42_11 = (var_44_0 + var_42_11 - 1) % var_42_5 + 1
		end

		local function var_43_7(arg_45_0)
			for iter_45_0 = 1, arg_45_0 do
				local var_45_0 = var_42_12 == "left" and (var_42_13 + iter_45_0 - 1) % var_42_5 or (var_42_13 - iter_45_0 + 1) % var_42_5

				var_45_0 = var_45_0 == 0 and var_42_5 or var_45_0

				local var_45_1 = arg_42_0.rewardScroll:getChildByName("reward" .. var_45_0)

				if var_45_1 then
					if var_42_12 == "left" then
						var_45_1:x(var_45_1:x() + var_42_6)
					else
						var_45_1:x(var_45_1:x() - var_42_6)
					end

					arg_42_0:modifyItem(var_45_1:x() / var_42_0 + 1)
				end
			end
		end

		if var_43_3 then
			local var_43_8 = var_43_3:x()

			if var_42_12 == "left" and var_43_1 > var_43_8 + var_42_0 then
				local var_43_9 = arg_42_0.rewardScroll:getChildByName("reward" .. (var_42_11 == 0 and var_42_5 or var_42_11))
				local var_43_10 = (var_42_3 - var_43_9:x()) / var_42_0 - 1
				local var_43_11 = math.min(math.ceil((var_43_1 - (var_43_8 + var_42_0)) / var_42_0), var_43_10)

				var_43_6(var_42_12, var_43_11)
				var_43_7(var_43_11)

				var_42_13 = var_42_10
			elseif var_42_12 == "right" and var_43_2 < var_43_8 then
				local var_43_12 = arg_42_0.rewardScroll:getChildByName("reward" .. (var_42_10 == 0 and var_42_5 or var_42_10)):x() / var_42_0
				local var_43_13 = math.min(math.ceil((var_43_8 - var_42_0 - var_43_2) / var_42_0), var_43_12)

				var_43_6(var_42_12, var_43_13)
				var_43_7(var_43_13)

				var_42_13 = var_42_11
			end

			local var_43_14 = var_42_0 * arg_42_0.startHideLevel

			if arg_42_0.currentPassportLv < arg_42_0.startHideLevel and var_42_12 == "left" and var_43_2 >= var_43_14 - 1 then
				gGameUI:showTip(string.format(gLanguageCsv.upPasswordLevelToGet, arg_42_0.startHideLevel))
			end
		end
	end

	var_42_14()
	arg_42_0.rewardScroll:onEvent(function(arg_46_0)
		if arg_46_0.name == "CONTAINER_MOVED" then
			var_42_14()
		elseif arg_46_0.name == "SCROLLING_BEGAN" then
			arg_42_0:refreshNoClick(true)
		elseif arg_46_0.name == "AUTOSCROLL_ENDED" then
			arg_42_0:refreshNoClick(false)
		elseif arg_46_0.name == "SCROLLING_ENDED" then
			-- block empty
		end
	end)
end

function var_0_6.buildItem(arg_47_0)
	local var_47_0 = arg_47_0.curRewardIdx
	local var_47_1 = arg_47_0.curRewardIdx - 1 + arg_47_0.itemCreateNum

	if var_47_1 > arg_47_0.max then
		var_47_0 = var_47_0 - (var_47_1 - arg_47_0.max)
		var_47_1 = arg_47_0.max
	end

	for iter_47_0 = var_47_0, var_47_1 do
		arg_47_0:addItem(iter_47_0)
	end
end

function var_0_6.addItem(arg_48_0, arg_48_1)
	local var_48_0 = arg_48_0.awardCfg[arg_48_1]
	local var_48_1 = arg_48_0.rewardItem:clone()
	local var_48_2 = arg_48_1 % arg_48_0.itemCreateNum == 0 and arg_48_0.itemCreateNum or arg_48_1 % arg_48_0.itemCreateNum
	local var_48_3 = arg_48_0.rewardItem:width()
	local var_48_4 = (arg_48_1 - 1) * var_48_3

	var_48_1:xy(var_48_4, 0)
	arg_48_0:refreshRewardItem(var_48_1, arg_48_1)
	arg_48_0.rewardScroll:addChild(var_48_1, var_48_2, "reward" .. var_48_2)
	var_48_1:show()

	return var_48_1
end

function var_0_6.modifyItem(arg_49_0, arg_49_1)
	for iter_49_0 = 1, arg_49_0.itemCreateNum do
		local var_49_0 = arg_49_0.rewardScroll:getChildByName("reward" .. iter_49_0)

		if var_49_0:x() == (arg_49_1 - 1) * arg_49_0.rewardItem:width() then
			arg_49_0:refreshRewardItem(var_49_0, arg_49_1)
		end
	end
end

function var_0_6.refreshRewardItem(arg_50_0, arg_50_1, arg_50_2)
	local var_50_0 = arg_50_0.awardCfg[arg_50_2]
	local var_50_1 = var_50_0.cfg.specialAward == 1
	local var_50_2 = arg_50_1:multiget("lv", "normalPanel", "highPanel1", "highPanel2", "topMask", "bottomMask", "btnGet", "noClick")

	var_50_2.lv:text(var_50_0.cfg.level)

	local var_50_3 = {}

	for iter_50_0, iter_50_1 in csvMapPairs(var_50_0.cfg.normalAward) do
		var_50_3.key = iter_50_0
		var_50_3.num = iter_50_1
		var_50_3.state = var_50_0.custom.normalAwardState
	end

	arg_50_0:onBindIcon(arg_50_0.rewardScroll, var_50_2.normalPanel, var_50_3, var_50_1)

	local var_50_4 = {}

	for iter_50_2, iter_50_3 in csvMapPairs(var_50_0.cfg.eliteAward) do
		table.insert(var_50_4, {
			key = iter_50_2,
			num = iter_50_3,
			state = var_50_0.custom.eliteAwardState
		})
	end

	arg_50_0:onBindIcon(arg_50_0.rewardScroll, var_50_2.highPanel1, var_50_4[1], var_50_1)

	if var_50_4[2] then
		arg_50_0:onBindIcon(arg_50_0.rewardScroll, var_50_2.highPanel2, var_50_4[2], var_50_1)
		var_50_2.highPanel2:show()
	else
		var_50_2.highPanel2:hide()
	end

	var_50_2.btnGet:visible(var_50_0.custom.normalAwardState == 1 or var_50_0.custom.eliteAwardState == 1)
	bind.touch(arg_50_0, var_50_2.btnGet, {
		methods = {
			ended = function(arg_51_0, arg_51_1, arg_51_2)
				arg_50_0:onBtnGetClick(var_50_0)
			end
		}
	})
	var_50_2.topMask:visible(arg_50_0.currentPassportLv < var_50_0.cfg.level)
	var_50_2.bottomMask:visible(arg_50_0.currentPassportLv < var_50_0.cfg.level or not arg_50_0.buyHigh)
	bind.click(arg_50_0, var_50_2.noClick, {
		method = function()
			arg_50_0:onRewardNoClick()
		end
	})
end

function var_0_6.onRewardNoClick(arg_53_0)
	arg_53_0:refreshNoClick(false)
end

function var_0_6.onBindIcon(arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4)
	bind.extend(arg_54_0, arg_54_2, {
		class = "icon_key",
		props = {
			data = arg_54_3,
			onNode = function(arg_55_0)
				arg_55_0:scale(0.9)

				local var_55_0 = arg_54_2:get("img")

				if var_55_0 then
					var_55_0:visible(arg_54_3.state == 0)
				else
					local var_55_1 = ccui.ImageView:create("common/icon/radio_selected.png"):addTo(arg_54_2, 1000, "img"):xy(130, 130):visible(arg_54_3.state == 0)
				end
			end
		}
	})

	local var_54_0 = arg_54_2:getChildByName("wupinshanguang")

	if var_54_0 then
		var_54_0:removeFromParent()
	end

	if arg_54_4 then
		widget.addAnimationByKey(arg_54_2, "wupinshanguang/saoguang.skel", "wupinshanguang", "effect_loop", 999):xy(arg_54_2:size().width / 2, arg_54_2:size().height / 2):scale(0.7)
	end
end

function var_0_6.jumpScroll(arg_56_0)
	local var_56_0 = arg_56_0.itemCreateNum
	local var_56_1 = arg_56_0.curRewardIdx % var_56_0 == 0 and var_56_0 or arg_56_0.curRewardIdx % var_56_0
	local var_56_2 = arg_56_0.rewardScroll:getChildByName("reward" .. var_56_1)

	if not var_56_2 then
		return
	end

	local var_56_3 = var_56_2:x()
	local var_56_4 = arg_56_0.rewardScroll:getInnerContainer():size()
	local var_56_5 = arg_56_0.rewardScroll:size().width
	local var_56_6 = cc.clampf(var_56_3 / (var_56_4.width - var_56_5) * 100, 0, 100)

	arg_56_0.rewardScroll:scrollToPercentHorizontal(var_56_6, 0.01, false)

	arg_56_0.percent = var_56_6
end

function var_0_6.resetScroll(arg_57_0)
	arg_57_0.rewardScroll:removeAllChildren()
	arg_57_0:buildScroll()
	arg_57_0:buildItem()
	arg_57_0:refreshNoClick(false)
	arg_57_0:jumpScroll()

	arg_57_0.isReset = false
end

function var_0_6.refreshTarget(arg_58_0)
	local var_58_0 = arg_58_0.awardCfg[arg_58_0.rigthRewardIndex]

	arg_58_0.target:getChildByName("lv"):text(var_58_0.cfg.level .. gLanguageCsv.levelGet)

	if matchLanguage({
		"kr"
	}) then
		adapt.setTextAdaptWithSize(arg_58_0.target:getChildByName("lv"), {
			size = cc.size(150, 100)
		})
	elseif matchLanguage({
		"en"
	}) then
		arg_58_0.target:getChildByName("lv"):text(gLanguageCsv.levelGet .. var_58_0.cfg.level)
	end

	local var_58_1 = {}

	for iter_58_0, iter_58_1 in csvMapPairs(var_58_0.cfg.normalAward) do
		var_58_1.key = iter_58_0
		var_58_1.num = iter_58_1
		var_58_1.state = var_58_0.custom.normalAwardState
	end

	local var_58_2 = {}

	for iter_58_2, iter_58_3 in csvMapPairs(var_58_0.cfg.eliteAward) do
		table.insert(var_58_2, {
			key = iter_58_2,
			num = iter_58_3,
			state = var_58_0.custom.eliteAwardState
		})
	end

	arg_58_0:onBindIcon(arg_58_0.rewardScroll, arg_58_0.targetNormalPanel, var_58_1, true)
	arg_58_0:onBindIcon(arg_58_0.rewardScroll, arg_58_0.targetHighPanel1, var_58_2[1], true)

	if var_58_2[2] then
		arg_58_0:onBindIcon(arg_58_0.rewardScroll, arg_58_0.targetHighPanel2, var_58_2[2], true)
		arg_58_0.targetHighPanel2:show()
	else
		arg_58_0.targetHighPanel2:hide()
	end
end

function var_0_6.refreshNoClick(arg_59_0, arg_59_1)
	for iter_59_0 = 1, arg_59_0.itemCreateNum do
		arg_59_0.rewardScroll:getChildByName("reward" .. iter_59_0):getChildByName("noClick"):visible(arg_59_1)
	end

	arg_59_0.targetNoClick:visible(arg_59_1)
end

function var_0_6.getItemNum(arg_60_0, arg_60_1, arg_60_2)
	local var_60_0 = arg_60_2.limitTimes

	for iter_60_0, iter_60_1 in pairs(arg_60_0.shop) do
		if iter_60_0 == arg_60_1 then
			var_60_0 = arg_60_2.limitTimes - iter_60_1

			break
		end
	end

	return var_60_0
end

function var_0_6.onItemClick(arg_61_0, arg_61_1, arg_61_2, arg_61_3)
	if arg_61_3.itemNum <= 0 then
		return
	end

	local var_61_0 = time.getNumTimestamp(arg_61_0.endDate) - time.getTime()
	local var_61_1, var_61_2 = math.modf(var_61_0 / 86400)
	local var_61_3 = gLanguageCsv.goTobuy
	local var_61_4 = gLanguageCsv.passwordBuyVipNote
	local var_61_5, var_61_6 = csvNext(arg_61_3.cfg.costMap)

	if not arg_61_0.items:read()[var_61_5] then
		local var_61_7 = 0
	end

	local var_61_8 = 1

	if arg_61_0.buyHigh then
		gGameUI:stackUI("common.buy_info", nil, nil, arg_61_3.cfg.costMap, {
			id = arg_61_3.itemId,
			num = arg_61_3.num
		}, {
			contentType = "num",
			maxNum = arg_61_3.itemNum,
			discount = var_61_8
		}, arg_61_0:createHandler("buyItemCallBack", arg_61_3))
	elseif var_61_5 == game.ITEM_TICKET.passportCoin then
		gGameUI:stackUI("common.buy_info", nil, nil, arg_61_3.cfg.costMap, {
			id = arg_61_3.itemId,
			num = arg_61_3.num
		}, {
			contentType = "num",
			maxNum = arg_61_3.itemNum,
			discount = var_61_8
		}, arg_61_0:createHandler("buyItemCallBack", arg_61_3))
	else
		local function var_61_9()
			gGameUI:stackUI("city.activity.passport.buy", nil, nil, arg_61_0.activityId)
		end

		local var_61_10 = {
			isRich = false,
			btnType = 2,
			title = var_61_3,
			cb = var_61_9,
			content = var_61_4,
			dialogParams = {
				clickClose = false
			}
		}

		gGameUI:showDialog(var_61_10)
	end
end

function var_0_6.buyItemCallBack(arg_63_0, arg_63_1, arg_63_2)
	gGameApp:requestServer("/game/yy/passport/shop/buy", function(arg_64_0)
		gGameUI:showGainDisplay({
			{
				arg_63_1.itemId,
				arg_63_1.num * arg_63_2
			}
		}, {
			raw = false
		})
	end, arg_63_0.activityId, arg_63_1.csvId, arg_63_2)
end

return var_0_6
