local var_0_0 = game.YYHUODONG_TYPE_ENUM_TABLE
local var_0_1 = {
	news = {
		name = gLanguageCsv.system,
		color = cc.c4b(238, 115, 143, 255),
		outlinecolor = cc.c4b(96, 18, 12, 255)
	},
	world = {
		name = gLanguageCsv.world,
		color = cc.c4b(139, 175, 223, 255),
		outlinecolor = cc.c4b(14, 42, 79, 255)
	},
	union = {
		name = gLanguageCsv.guild,
		color = cc.c4b(204, 143, 223, 255),
		outlinecolor = cc.c4b(107, 19, 134, 255)
	},
	team = {
		name = gLanguageCsv.formTeam,
		color = cc.c4b(236, 183, 43, 255),
		outlinecolor = cc.c4b(89, 56, 5, 255)
	},
	huodong = {
		name = gLanguageCsv.activity,
		color = cc.c4b(255, 94, 66, 255),
		outlinecolor = cc.c4b(110, 20, 4, 255)
	},
	private = {
		name = gLanguageCsv.privateChat,
		color = cc.c4b(204, 143, 223, 255),
		outlinecolor = cc.c4b(107, 19, 134, 255)
	}
}
local var_0_2 = {
	huodong = 5,
	private = 6,
	world = 2,
	union = 3,
	team = 4,
	news = 1
}
local var_0_3 = 1000

local function var_0_4(arg_1_0)
	return userDefault.getForeverLocalKey(arg_1_0, "") == time.getTodayStr()
end

local function var_0_5(arg_2_0, arg_2_1)
	return userDefault.getForeverLocalKey(arg_2_0, "") == tostring(arg_2_1)
end

local function var_0_6(arg_3_0)
	local var_3_0 = false

	if not tonumber(string.sub(arg_3_0, 2), 2) then
		return arg_3_0
	end

	local var_3_1 = string.len(arg_3_0)

	if var_3_1 < 5 then
		return arg_3_0
	end

	local var_3_2 = var_3_1 - 5 + 1

	if string.sub(arg_3_0, var_3_2, var_3_2) == "0" then
		return arg_3_0
	end

	return (string.sub(arg_3_0, 1, var_3_2 - 1) .. "0") .. string.sub(arg_3_0, var_3_2 + 1)
end

local function var_0_7()
	return {
		{
			key = "signIn",
			viewName = "city.sign_in",
			icon = "city/main/icon_qd.png",
			name = gLanguageCsv.signIn,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "signIn",
					onNode = function(arg_5_0)
						arg_5_0:xy(162, 162)
					end
				}
			}
		},
		{
			key = "friend",
			viewName = "city.friend",
			icon = "city/main/icon_hy.png",
			name = gLanguageCsv.friend,
			func = function(arg_6_0)
				local var_6_0 = require("app.views.city.friend")
				local var_6_1, var_6_2 = var_6_0.initFriendShowType()

				var_6_0.sendProtocol(var_6_1, var_6_2, arg_6_0)
			end,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = {
						"friendStaminaRecv",
						"friendReqs"
					},
					onNode = function(arg_7_0)
						arg_7_0:xy(162, 162)
					end
				}
			}
		},
		{
			key = "rank",
			unlockKey = "rank",
			viewName = "city.rank",
			icon = "city/main/icon_ph@.png",
			name = gLanguageCsv.rank,
			styles = {
				full = true
			},
			func = function(arg_8_0)
				gGameApp:requestServer("/game/rank", function(arg_9_0)
					arg_8_0(arg_9_0.view.rank)
				end, "fight", 0, 10)
			end
		},
		{
			key = "union",
			unlockKey = "union",
			icon = "city/main/icon_gh@.png",
			name = gLanguageCsv.guild,
			func = function()
				jumpEasy.jumpTo("union")
			end,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = {
						"unionTraining",
						"unionSystemRedPacket",
						"unionMemberRedPacket",
						"unionSendedRedPacket",
						"unionDailyGift",
						"unionLobby",
						"unionContribute",
						"unionFuben",
						"unionFragDonate",
						"unionFightSignUp",
						"unionAnswer"
					},
					onNode = function(arg_11_0)
						arg_11_0:xy(162, 162)
					end
				}
			}
		}
	}
end

local function var_0_8()
	return {
		{
			viewName = "city.chat.privataly",
			key = "chatPrivataly",
			icon = "city/icon_xinxi.png",
			func = function(arg_13_0)
				local var_13_0 = gGameModel.messages:read("private")

				if itertools.isempty(var_13_0) then
					gGameUI:showTip(gLanguageCsv.noPrivateChatList)

					return
				end

				arg_13_0()
			end
		},
		{
			viewName = "city.mail",
			key = "mail"
		},
		{
			viewName = "city.setting.view",
			key = "setting"
		}
	}
end

local function var_0_9()
	return {
		{
			key = "pvp",
			viewName = "city.adventure.pvp",
			name = gLanguageCsv.pvp,
			styles = {
				full = true
			},
			func = function(arg_15_0)
				arg_15_0("pvp")
			end
		},
		{
			key = "pve",
			viewName = "city.adventure.pve",
			name = gLanguageCsv.adventure,
			styles = {
				full = true
			},
			func = function(arg_16_0)
				arg_16_0("pve")
			end
		},
		{
			viewName = "city.gate.view",
			key = "gate",
			name = gLanguageCsv.gate,
			styles = {
				full = true
			}
		},
		{
			unlockKey = "trainer",
			key = "trainer",
			viewName = "city.develop.trainer.view",
			name = gLanguageCsv.trainerWay,
			styles = {
				full = true
			}
		}
	}
end

local var_0_10 = cc.load("mvc").ViewBase
local var_0_11 = class("CityView", var_0_10)

var_0_11.RESOURCE_FILENAME = "city.json"
var_0_11.RESOURCE_BINDING = {
	["leftBottomPanel.talkPanel.baseTalkPanel.list"] = "talkList",
	item = "item",
	["leftBottomPanel.talkPanel.talkbg"] = "talkbg",
	["rightPanel.panel2"] = "activityPanel2",
	["leftTopPanel.powerNum"] = "powerNum",
	["leftBottomPanel.talkPanel.baseTalkPanel"] = "baseTalkPanel",
	["leftTopPanel.vipNum"] = "vipNum",
	["leftTopPanel.yeartime"] = "yeartime",
	["rightPanel.panel"] = "activityPanel",
	["developPanel.bg"] = "developBg",
	["leftTopPanel.daytime"] = "daytime",
	bg = "bgPanel",
	rightBottomPanel = "rightBottomPanel",
	["rightPanel.onlineGiftPanel"] = "onlineGiftPanelItem",
	["leftTopPanel.name"] = "nameTxt",
	["leftTopPanel.vip"] = "roleVip",
	activityTip = "activityTip",
	["rightBottomPanel.mainList"] = "mainList",
	["leftBottomPanel.panel"] = "leftBottomBtnPanel",
	leftPanel = "leftPanel",
	["leftBottomPanel.talkPanel.baseTalkPanel.textPos"] = "textPos",
	["leftTopPanel.level"] = "levelTxt",
	activityItem = "activityItem",
	["rightPanel.showList"] = "topShowList",
	["rightPanel.go"] = "go",
	leftTopPanel = "leftTopPanel",
	["developPanel.listItem"] = "listItem",
	rightPanel = "rightPanel",
	["leftTopPanel.head"] = {
		binds = {
			{
				event = "click",
				method = bindHelper.self("onPersonalInfo")
			},
			{
				event = "extend",
				class = "role_logo",
				props = {
					vip = false,
					level = false,
					logoId = bindHelper.self("logo"),
					frameId = bindHelper.self("frame")
				}
			}
		}
	},
	["leftTopPanel.rechargeItem"] = {
		varname = "rechargeItem",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onRechargeClick")
				}
			},
			{
				event = "extend",
				class = "multi_text_effect",
				props = {
					data = gLanguageCsv.recharge,
					effects = {
						{
							outline = {
								size = 6,
								color = cc.c4b(54, 66, 82, 255)
							}
						},
						{
							outline = {
								size = 12,
								color = cc.c4b(255, 255, 255, 255)
							}
						}
					},
					onNode = function(arg_17_0)
						arg_17_0:xy(140, 72):z(5)
					end
				}
			}
		}
	},
	["leftPanel.list"] = {
		varname = "leftList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 12,
				data = bindHelper.self("leftBtns"),
				item = bindHelper.self("item"),
				onItem = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
					arg_18_1:name(arg_18_3.key)
					arg_18_1:get("icon"):texture(arg_18_3.icon)
					arg_18_1:removeChildByName("name")

					if arg_18_3.redHint and (arg_18_3.key ~= "union" or gGameModel.union_training) then
						bind.extend(arg_18_0, arg_18_1, arg_18_3.redHint)
					end

					bind.touch(arg_18_0, arg_18_1, {
						methods = {
							ended = functools.partial(arg_18_0.clickCell, arg_18_3)
						}
					})
					uiEasy.updateUnlockRes(arg_18_3.unlockKey, arg_18_1, {
						justRemove = not arg_18_3.unlockKey,
						pos = cc.p(140, 140)
					}):anonyOnly(arg_18_0, arg_18_0:getIdx(arg_18_2))
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	},
	["leftBottomPanel.panel.btnTalk"] = {
		varname = "btnTalk",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_19_0)
						return arg_19_0:onItemClick(nil, arg_19_0.leftBottomBtns[1])
					end)
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					state = bindHelper.self("talkRedHint"),
					onNode = function(arg_20_0)
						arg_20_0:xy(120, 116)
					end
				}
			}
		}
	},
	["leftBottomPanel.panel.btnMsg"] = {
		varname = "btnMsg",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_21_0)
						gGameApp:slientRequestServer("/game/sync")

						return arg_21_0:onItemClick(nil, arg_21_0.leftBottomBtns[2])
					end)
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "mail",
					onNode = function(arg_22_0)
						arg_22_0:xy(120, 116)
					end
				}
			}
		}
	},
	["leftBottomPanel.panel.btnSet"] = {
		varname = "btnSetting",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_23_0)
					return arg_23_0:onItemClick(nil, arg_23_0.leftBottomBtns[3])
				end)
			}
		}
	},
	["leftBottomPanel.talkPanel"] = {
		varname = "talkPanel",
		binds = {
			event = "click",
			method = bindHelper.self("onTalkClick")
		}
	},
	["rightPanel.btnExpand"] = {
		varname = "activityExpandBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onActivityExpandClick")
			}
		}
	},
	["rightPanel.panel.list"] = {
		varname = "activityList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("activityBtns"),
				dataOrderCmp = function(arg_24_0, arg_24_1)
					return arg_24_0.sortWeight > arg_24_1.sortWeight
				end,
				item = bindHelper.self("activityItem"),
				margin = ACTIVITY_LIST_MARGIN,
				itemAction = {
					isAction = true
				},
				onBeforeBuild = function(arg_25_0)
					arg_25_0:enableSchedule():unScheduleAll()
				end,
				onItem = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
					local var_26_0 = arg_26_1:multiget("icon", "labelTime")

					var_26_0.icon:texture(arg_26_3.icon)
					text.addEffect(var_26_0.labelTime, {
						outline = {
							size = 3,
							color = ui.NEWCOLORS.OUTLINE.BLACK
						}
					})

					if arg_26_3.endTime then
						var_0_11.setCountdown(arg_26_0, var_26_0.labelTime, {
							endTime = arg_26_3.endTime,
							tag = arg_26_3.tag
						})
					else
						var_26_0.labelTime:hide()
					end

					if arg_26_3.redHint then
						bind.extend(arg_26_0, arg_26_1, arg_26_3.redHint)
					end

					bind.touch(arg_26_0, arg_26_1, {
						methods = {
							ended = functools.partial(arg_26_0.clickCell, arg_26_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	},
	["rightPanel.panel2.list"] = {
		varname = "activityList2",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("activityBtns2"),
				dataOrderCmp = function(arg_27_0, arg_27_1)
					return arg_27_0.sortWeight > arg_27_1.sortWeight
				end,
				item = bindHelper.self("activityItem"),
				margin = ACTIVITY_LIST_MARGIN,
				itemAction = {
					isAction = true
				},
				onBeforeBuild = function(arg_28_0)
					arg_28_0:enableSchedule():unScheduleAll()
				end,
				onItem = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
					local var_29_0 = arg_29_1:multiget("icon", "labelTime")

					var_29_0.icon:texture(arg_29_3.icon)
					text.addEffect(var_29_0.labelTime, {
						outline = {
							size = 3,
							color = ui.NEWCOLORS.OUTLINE.BLACK
						}
					})

					if arg_29_3.endTime then
						var_0_11.setCountdown(arg_29_0, var_29_0.labelTime, {
							endTime = arg_29_3.endTime,
							tag = arg_29_3.tag
						})
					else
						var_29_0.labelTime:hide()
					end

					if arg_29_3.redHint then
						bind.extend(arg_29_0, arg_29_1, arg_29_3.redHint)
					end

					bind.touch(arg_29_0, arg_29_1, {
						methods = {
							ended = functools.partial(arg_29_0.clickCell, arg_29_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	},
	["centerBottomPanel.actionList"] = {
		varname = "actionList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 20,
				data = bindHelper.self("actionBtns"),
				item = bindHelper.self("item"),
				onItem = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
					arg_30_1:name(arg_30_3.key)
					arg_30_1:get("icon"):texture(arg_30_3.icon):scale(0.7)
					arg_30_1:removeChildByName("name")

					if arg_30_3.redHint then
						bind.extend(arg_30_0, arg_30_1, arg_30_3.redHint)
					end

					if arg_30_3.actionExpandName then
						bind.touch(arg_30_0, arg_30_1, {
							methods = {
								ended = functools.partial(arg_30_0.clickDevelop, arg_30_1, arg_30_3)
							}
						})
					else
						bind.touch(arg_30_0, arg_30_1, {
							methods = {
								ended = functools.partial(arg_30_0.clickCell, arg_30_3)
							}
						})
					end

					uiEasy.updateUnlockRes(arg_30_3.unlockKey, arg_30_1, {
						justRemove = not arg_30_3.unlockKey,
						pos = cc.p(126, 126)
					}):anonyOnly(arg_30_0, arg_30_0:getIdx(arg_30_2))
				end,
				onAfterBuild = function(arg_31_0)
					arg_31_0:setItemAlignCenter()
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick"),
				clickDevelop = bindHelper.self("onItemDevelopClick")
			}
		}
	},
	developPanel = {
		varname = "developPanel",
		binds = {
			event = "visible",
			idler = bindHelper.self("actionExpandName"),
			method = function(arg_32_0)
				return arg_32_0 ~= ""
			end
		}
	},
	["developPanel.developList"] = {
		varname = "developList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 4,
				backupCached = false,
				data = bindHelper.self("developBtns"),
				item = bindHelper.self("listItem"),
				cell = bindHelper.self("item"),
				onCell = function(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
					arg_33_1:scaleY(-1)
					arg_33_1:name(arg_33_3.key)
					arg_33_1:get("icon"):texture(arg_33_3.icon):y(84)
					bind.touch(arg_33_0, arg_33_1, {
						methods = {
							ended = functools.partial(arg_33_0.clickCell, arg_33_3)
						}
					})
					arg_33_1:removeChildByName("name")

					if arg_33_3.key == "mega" then
						arg_33_1:get("icon"):scale(0.66)
					else
						arg_33_1:get("icon"):scale(0.66)
					end

					if arg_33_3.redHint then
						bind.extend(arg_33_0, arg_33_1, arg_33_3.redHint)
					end

					arg_33_3.unlockRes = uiEasy.updateUnlockRes(arg_33_3.unlockKey, arg_33_1, {
						justRemove = not arg_33_3.unlockKey,
						pos = cc.p(140, 140)
					}):anonyOnly(arg_33_0, arg_33_0:getIdx(arg_33_2))
				end,
				dataOrderCmp = function(arg_34_0, arg_34_1)
					local var_34_0 = gUnlockCsv[arg_34_0.unlockKey]
					local var_34_1 = gUnlockCsv[arg_34_1.unlockKey]

					if var_34_0 and var_34_1 then
						if csv.unlock[var_34_0].startLevel == csv.unlock[var_34_1].startLevel then
							return var_34_0 < var_34_1
						end

						return csv.unlock[var_34_0].startLevel < csv.unlock[var_34_1].startLevel
					elseif not var_34_0 and not var_34_1 then
						return false
					else
						return var_34_0 == nil
					end
				end,
				onAfterBuild = function(arg_35_0)
					arg_35_0:adaptTouchEnabled()
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	},
	["rightBottomPanel.btnPvp"] = {
		varname = "itemPvp",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_36_0)
						return arg_36_0:onItemClick(nil, arg_36_0.mainBtns[1])
					end)
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = {
						"arenaAward",
						"crossArenaAward",
						"onlineFightAward"
					},
					onNode = function(arg_37_0)
						arg_37_0:xy(244, 244)
					end
				}
			}
		}
	},
	["rightBottomPanel.btnPvp.namePanel"] = {
		binds = {
			event = "extend",
			class = "multi_text_effect",
			props = {
				onNode = function(arg_38_0)
					arg_38_0:xy(95, 50):z(5)
				end
			}
		}
	},
	["rightBottomPanel.btnAdventure"] = {
		varname = "itemAdventure",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_39_0)
						return arg_39_0:onItemClick(nil, arg_39_0.mainBtns[2])
					end)
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = {
						"dispatchTask",
						"randomTower",
						"randomTowerPoint",
						"gymChallenge",
						"cloneBattle",
						"braveChallengeAch"
					},
					listenData = {
						sign = game.BRAVE_CHALLENGE_TYPE.common
					},
					onNode = function(arg_40_0)
						arg_40_0:xy(280, 300):scale(1.35)
					end
				}
			}
		}
	},
	["rightBottomPanel.btnAdventure.namePanel"] = {
		binds = {
			event = "extend",
			class = "multi_text_effect",
			props = {
				onNode = function(arg_41_0)
					arg_41_0:xy(95, 50):z(5)
				end
			}
		}
	},
	["rightBottomPanel.btnTrainer"] = {
		varname = "btnTrainer",
		binds = {
			{
				clicksafe = true,
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_42_0)
						return arg_42_0:onItemClick(nil, arg_42_0.mainBtns[4])
					end)
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "trainer",
					onNode = function(arg_43_0)
						arg_43_0:xy(300, 300):scale(1.35)
					end
				}
			}
		}
	},
	["rightBottomPanel.btnPve"] = {
		varname = "itemPve",
		binds = {
			{
				clicksafe = true,
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_44_0)
						return arg_44_0:onItemClick(nil, arg_44_0.mainBtns[3])
					end)
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "pve",
					onNode = function(arg_45_0)
						arg_45_0:xy(560, 330):scale(1.5)
					end
				}
			}
		}
	},
	["rightBottomPanel.btnPve.namePanel"] = {
		binds = {
			event = "extend",
			class = "multi_text_effect",
			props = {
				onNode = function(arg_46_0)
					arg_46_0:xy(95, 50):z(5)
				end
			}
		}
	},
	["activityTip.textNote1"] = {
		varname = "textNote1",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.BLACK1
				}
			}
		}
	},
	["activityTip.textNote2"] = {
		varname = "textNote2",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.BLACK1
				}
			}
		}
	},
	marqueePanel = {
		varname = "marqueePanel",
		binds = {
			event = "extend",
			class = "marquee"
		}
	}
}

function var_0_11.onCreate(arg_47_0)
	gGameUI.topuiManager:createView("city", arg_47_0):init()
	arg_47_0:enableSchedule()
	arg_47_0:initModel()

	local var_47_0 = {
		"app.views.city.view_scene",
		"app.views.city.view_action",
		"app.views.city.view_activity"
	}

	for iter_47_0, iter_47_1 in ipairs(var_47_0) do
		require(iter_47_1)(var_0_11)
	end

	idlereasy.when(arg_47_0.vipHide, function(arg_48_0, arg_48_1)
		arg_47_0.roleVip:visible(not arg_48_1)
		arg_47_0.vipNum:visible(not arg_48_1)
	end)
	arg_47_0.baseTalkPanel:get("list"):setScrollBarEnabled(false)
	idlereasy.any({
		arg_47_0.level,
		arg_47_0.roleName,
		arg_47_0.top6_fighting_point,
		arg_47_0.vipLevel
	}, function(arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4)
		arg_47_0.levelTxt:text(arg_49_1)
		arg_47_0.powerNum:text(arg_49_3)
		text.addEffect(arg_47_0.powerNum, {
			fontname = "font/youmi.ttf",
			size = 50
		})
		adapt.setTextScaleWithWidth(arg_47_0.powerNum, arg_49_3, 200)
		arg_47_0.vipNum:text(arg_49_4)
		text.addEffect(arg_47_0.vipNum, {
			fontname = "font/youmi.ttf",
			size = 50
		})
		text.addEffect(arg_47_0.levelTxt, {
			size = 45
		})
		arg_47_0.nameTxt:text(arg_49_2)
		text.addEffect(arg_47_0.nameTxt, {
			size = 50,
			color = cc.c4b(0, 0, 0, 255)
		})
		adapt.setTextScaleWithWidth(arg_47_0.nameTxt, arg_49_2, 250)
		adapt.oneLinePos(arg_47_0.levelTxt, arg_47_0.nameTxt, cc.p(15, 0), "left")

		local var_49_0 = math.max(630, arg_47_0.nameTxt:x() + arg_47_0.nameTxt:width() + 40)

		arg_47_0.leftTopPanel:get("bg"):width(var_49_0)
	end)
	arg_47_0.topShowList:setScrollBarEnabled(false)

	arg_47_0.actionExpandName = idler.new("")
	arg_47_0.autoNewPlayerWealId = idler.new(0)

	arg_47_0:initData()
	arg_47_0:initTalkPanel()

	arg_47_0.autoPopBoxInfo = {}

	arg_47_0:initPoster()
	idlereasy.when(arg_47_0.create_account_award_flag, function(arg_50_0, arg_50_1)
		arg_50_1 = tonumber(arg_50_1) or 0

		if arg_50_1 <= 0 then
			-- table.insert(arg_47_0.autoPopBoxInfo, {
			-- 	viewName = "city.activity.first_reward",
			-- 	params = {
			-- 		true
			-- 	}
			-- })
			table.insert(arg_47_0.autoPopBoxInfo, {
				viewName = "city.activity.first_recharge",
				params = {
					20
				}
			})
		end
	end)

	if gGameModel.monthly_record:read("last_sign_in_day") < time.getNowDate().day then
		table.insert(arg_47_0.autoPopBoxInfo, {
			viewName = "city.sign_in",
			params = {
				true
			}
		})
	end

	arg_47_0:initAutoNewPlayerWeal()
	arg_47_0:checkPopBox(true)

	local var_47_1 = userDefault.getForeverLocalKey("musicIdx", 1)
	local var_47_2 = csv.citysound[var_47_1]

	if var_47_2 then
		audio.playMusic(var_47_2.path)
	else
		printWarn("music index not exist", var_47_1)
	end

	arg_47_0.isRefresh = idler.new(false)

	idlereasy.any({
		arg_47_0.level,
		arg_47_0.isRefresh
	}, function(arg_51_0, arg_51_1, arg_51_2)
		arg_47_0:unSchedule(var_0_3)

		local var_51_0 = {}
		local var_51_1 = time.getNowDate()
		local var_51_2 = var_51_1.hour * 100 + var_51_1.min
		local var_51_3 = var_51_1.wday

		var_51_3 = var_51_3 == 1 and 7 or var_51_3 - 1

		local var_51_4 = math.huge

		local function var_51_5(arg_52_0)
			if arg_52_0.reminder ~= 2 and arg_52_0.roundKey then
				if gGameModel.role:read(arg_52_0.roundKey) ~= arg_52_0.roundState then
					return false
				end
			elseif arg_52_0.reminder == 2 then
				local var_52_0 = gGameModel.role:read(arg_52_0.roundKey)

				if var_52_0 == nil or tostring(var_52_0) == arg_52_0.roundState then
					return false
				end
			end

			if arg_52_0.unionlevel then
				local var_52_1 = gGameModel.role:read("union_db_id")
				local var_52_2 = gGameModel.union:read("level")

				if not var_52_1 or var_52_2 < arg_52_0.unionlevel then
					return false
				end
			end

			if dataEasy.serverOpenDaysLess(arg_52_0.serverday) then
				return false
			end

			if not itertools.include(arg_52_0.openseq, var_51_3) then
				return false
			end

			if var_51_2 < arg_52_0.startTime or var_51_2 >= arg_52_0.endTime then
				return false
			end

			return true
		end

		for iter_51_0, iter_51_1 in orderCsvPairs(csv.sysopen) do
			if iter_51_1.feature == "" or dataEasy.isUnlock(iter_51_1.feature) then
				if (iter_51_1.reminder == 0 or iter_51_1.reminder == 1 and not var_0_4("sysOpen" .. iter_51_1.sighid) or iter_51_1.reminder == 2 and not var_0_5("sysOpen" .. iter_51_1.sighid, gGameModel.role:read(iter_51_1.roundKey))) and var_51_5(iter_51_1) then
					table.insert(var_51_0, iter_51_1)
				end

				local var_51_6 = tonumber(time.getTodayStr())

				if csvSize(iter_51_1.startTimes) > 0 then
					for iter_51_2, iter_51_3 in csvMapPairs(iter_51_1.startTimes) do
						local var_51_7 = time.getNumTimestamp(var_51_6, iter_51_3 / 100, iter_51_3 % 100) - time.getTime()

						if var_51_7 < 0 then
							var_51_7 = var_51_7 + 86400
						end

						var_51_4 = math.min(var_51_4, var_51_7)
					end
				else
					local var_51_8 = time.getNumTimestamp(var_51_6, iter_51_1.startTime / 100, iter_51_1.startTime % 100) - time.getTime()

					if var_51_8 < 0 then
						var_51_8 = var_51_8 + 86400
					end

					var_51_4 = math.min(var_51_4, var_51_8)
				end
			end
		end

		table.sort(var_51_0, function(arg_53_0, arg_53_1)
			return arg_53_0.priority > arg_53_1.priority
		end)
		arg_47_0:initActivityTip(var_51_0[1])
		arg_47_0:schedule(function()
			arg_47_0.isRefresh:notify()

			return false
		end, var_51_4, var_51_4, var_0_3)
	end)
	arg_47_0:enableMessage():registerMessage("adapterNotchScreen", function(arg_55_0)
		adaptUI(arg_47_0:getResourceNode(), "city.json", arg_55_0)
	end)
	arg_47_0:registerMessage("stackUIViewExit", function(arg_56_0, arg_56_1)
		if arg_56_1 == "city.view" then
			performWithDelay(arg_47_0, function()
				arg_47_0:checkPopBox()
				arg_47_0:refreshBaibian()
				arg_47_0:refreshMysteryShop()
				arg_47_0:refreshHuodongBoss()
				arg_47_0.isRefresh:notify()
			end, 0)
		end
	end)
	arg_47_0:setGameSyncTimer()
	arg_47_0:setHorseRaceTimer()
	arg_47_0:specialGiftLink()
	arg_47_0:setSecialSupport()

	if device.platform == "windows" then
		for iter_47_2, iter_47_3 in gGameModel.cards:pairs() do
			local var_47_3 = iter_47_3:read("card_id")

			if not csv.cards[var_47_3] then
				gGameUI:showDialog({
					content = string.format("数据中包含未开放的卡牌%d, 检查本地 language 与服务器是否一致", var_47_3)
				})

				break
			end
		end
	end

	arg_47_0:initTrainer()
end

function var_0_11.initTrainer(arg_58_0)
	local var_58_0 = arg_58_0.mainBtns[4]

	dataEasy.getListenUnlock(var_58_0.key, function(arg_59_0)
		if not arg_59_0 then
			uiEasy.updateUnlockRes(var_58_0.key, arg_58_0.btnTrainer, {
				scale = 1.3,
				justRemove = not var_58_0.key,
				pos = cc.p(300, 300)
			})
		end
	end)
end

function var_0_11.onClose(arg_60_0)
	arg_60_0:unregisterMessage("stackUIViewExit")

	arg_60_0.onlineGiftPanel = nil

	var_0_10.onClose(arg_60_0)
end

function var_0_11.initModel(arg_61_0)
	arg_61_0.level = gGameModel.role:getIdler("level")
	arg_61_0.roleName = gGameModel.role:getIdler("name")
	arg_61_0.levelExp = gGameModel.role:getIdler("level_exp")
	arg_61_0.top6_fighting_point = gGameModel.role:getIdler("top6_fighting_point")
	arg_61_0.create_account_award_flag = gGameModel.role:getIdler("create_account_award_flag")
	arg_61_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_61_0.vipHide = gGameModel.role:getIdler("vip_hide")
	arg_61_0.logo = gGameModel.role:getIdler("logo")
	arg_61_0.frame = gGameModel.role:getIdler("frame")
	arg_61_0.allChannel = gGameModel.messages:getIdler("all")
	arg_61_0.friendMessage = gGameModel.messages:getIdler("private")
	arg_61_0.id = gGameModel.role:getIdler("id")
	arg_61_0.figure = gGameModel.role:getIdler("figure")
	arg_61_0.title = gGameModel.role:getIdler("title_id")
	arg_61_0.titles = gGameModel.role:getIdler("titles")
	arg_61_0.yyOpen = gGameModel.role:getIdler("yy_open")
	arg_61_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_61_0.yy_endtime = gGameModel.role:read("yy_endtime")
	arg_61_0.citySprites = gGameModel.role:getIdler("city_sprites")
	arg_61_0.spriteGiftTimes = gGameModel.daily_record:getIdler("city_sprite_gift_times")
	arg_61_0.mysteryShopLastTime = gGameModel.mystery_shop:getIdler("last_active_time")
	arg_61_0.redHintRefresh = idler.new(true)
	arg_61_0.crossFishingRound = gGameModel.role:getIdler("cross_fishing_round")
	arg_61_0.fishingSelectScene = gGameModel.fishing:getIdler("select_scene")
	arg_61_0.fishingIsAuto = gGameModel.fishing:getIdler("is_auto")
	arg_61_0.reunion = gGameModel.role:getIdler("reunion")
end

function var_0_11.stackUI(arg_62_0, arg_62_1, arg_62_2, arg_62_3, ...)
	gGameUI:stackUI(arg_62_1, arg_62_2, arg_62_3, ...)
end

function var_0_11.initData(arg_63_0)
	arg_63_0.leftBtns = var_0_7()
	arg_63_0.leftBottomBtns = var_0_8()
	arg_63_0.mainBtns = var_0_9()

	arg_63_0:initActionData()
	arg_63_0:initSceneData()
	arg_63_0:initActivityData()
end

function var_0_11.onPersonalInfo(arg_64_0)
	arg_64_0:stackUI("city.personal.info", nil, {
		full = true
	})
end

function var_0_11.initTitlePanel(arg_65_0)
	local var_65_0 = arg_65_0.titlePanel:x()

	idlereasy.when(arg_65_0.titles, function(arg_66_0, arg_66_1)
		if gGameModel.role.title_queue then
			arg_65_0.titlePanel:show()
			transition.executeSequence(arg_65_0.titlePanel, true):moveTo(2, var_65_0 - arg_65_0.titlePanel:width()):delay(1):moveTo(2, var_65_0):done()

			gGameModel.role.title_queue = nil
		else
			arg_65_0.titlePanel:hide()
		end
	end)
end

function var_0_11.onItemClick(arg_67_0, arg_67_1, arg_67_2)
	if arg_67_2.unlockKey then
		if arg_67_2.unlockKey == "handbook" then
			sdk.trackEvent("check_pokedex")
		end

		if not dataEasy.isUnlock(arg_67_2.unlockKey) then
			gGameUI:showTip(dataEasy.getUnlockTip(arg_67_2.unlockKey))

			return
		end

		if arg_67_2.specialLock then
			if arg_67_2.unlockKey == "totem" then
				local var_67_0 = csv.unlock[gUnlockCsv.totem]

				gGameUI:showTip(string.format(gLanguageCsv.totemTownExplorationUnlock, var_67_0.startLevel))
			end

			if arg_67_2.unlockKey == "meteorite" then
				gGameUI:showTip(gLanguageCsv.meteoriteSpeicalLock)
			end

			return
		end
	end

	if arg_67_2.func then
		arg_67_2.func(function(...)
			local var_68_0 = {}

			if arg_67_2.independent == 4 or arg_67_2.independent == 5 then
				if arg_67_2.independent == 4 then
					var_68_0 = {
						"main",
						arg_67_2.params[1]
					}
				else
					var_68_0 = {
						"award",
						arg_67_2.params[1]
					}
				end
			else
				var_68_0 = clone(arg_67_2.params or {})

				for iter_68_0, iter_68_1 in ipairs({
					...
				}) do
					table.insert(var_68_0, iter_68_1)
				end
			end

			arg_67_0:stackUI(arg_67_2.viewName, nil, arg_67_2.styles, unpack(var_68_0))
		end, arg_67_2.params or {})
	elseif arg_67_2.viewName then
		arg_67_0:stackUI(arg_67_2.viewName, nil, arg_67_2.styles, unpack(arg_67_2.params or {}))
	end

	arg_67_0.actionExpandName:set("")
end

function var_0_11.onItemDevelopClick(arg_69_0, arg_69_1, arg_69_2, arg_69_3)
	local var_69_0, var_69_1 = arg_69_2:xy()
	local var_69_2 = arg_69_1:convertToWorldSpace(cc.p(var_69_0, var_69_1))

	arg_69_0.developPanel:x(var_69_2.x)
	arg_69_0.actionExpandName:modify(function(arg_70_0)
		if arg_69_3.actionExpandName ~= arg_70_0 then
			return true, arg_69_3.actionExpandName
		end

		return true, ""
	end)
end

function var_0_11.onRechargeClick(arg_71_0)
	arg_71_0:stackUI("city.recharge", nil, {
		full = true
	})
end

function var_0_11.onTalkClick(arg_72_0)
	arg_72_0:stackUI("city.chat.view", nil, {
		clickClose = true
	}, arg_72_0.charIdx)
end

function var_0_11.onTalkExpandClick(arg_73_0)
	arg_73_0.talkExpand:modify(function(arg_74_0)
		return true, not arg_74_0
	end)
end

function var_0_11.onActivityExpandClick(arg_75_0)
	arg_75_0.activityExpand:modify(function(arg_76_0)
		return true, not arg_76_0
	end)
end

function var_0_11.initTalkPanel(arg_77_0)
	arg_77_0.charIdx = var_0_2.world
	arg_77_0.talkRedHint = idler.new(false)

	idlereasy.when(arg_77_0.allChannel, function(arg_78_0, arg_78_1)
		if arg_78_1 and #arg_78_1 > 0 then
			for iter_78_0 = #arg_78_1, 1, -1 do
				if arg_78_1[iter_78_0].channel ~= "private" then
					local var_78_0 = arg_78_1[iter_78_0]

					arg_77_0.charIdx = var_0_2[var_78_0.channel]

					local var_78_1 = arg_77_0.baseTalkPanel:multiget("textChannel", "bg", "textPos", "list")

					var_78_1.textChannel:text(var_0_1[var_78_0.channel].name)
					text.addEffect(var_78_1.textChannel, {
						color = var_0_1[var_78_0.channel].color,
						outline = {
							size = 4,
							color = var_0_1[var_78_0.channel].outlinecolor
						}
					})

					local var_78_2 = string.match(var_78_0.msg, "%[(%w+)%]")
					local var_78_3 = var_78_0.msg

					if gEmojiCsv[var_78_2] then
						var_78_3 = "#C0xA7F247#[" .. gEmojiCsv[var_78_2].text .. "]"
					end

					local var_78_4

					if itertools.first(game.MESSAGE_SHOW_TYPE[var_78_0.type], 3) then
						var_78_4 = var_78_0.args and var_78_0.args.name or var_78_0.role.name
						var_78_4 = var_78_4 and var_78_4 .. ": " .. var_78_3 or var_78_3
					else
						var_78_4 = var_78_0.msg
					end

					for iter_78_1, iter_78_2 in csvMapPairs(csv.color) do
						var_78_4 = string.gsub(var_78_4, iter_78_2.key, iter_78_2.exchange)
					end

					var_78_1.textPos:removeAllChildren()
					var_78_1.list:removeAllChildren()

					local var_78_5, var_78_6, var_78_7 = string.find(var_78_4, "#(L[^#]+)#")

					while var_78_5 do
						local var_78_8 = var_0_6(var_78_7)

						var_78_4 = string.sub(var_78_4, 1, var_78_5) .. var_78_8 .. string.sub(var_78_4, var_78_6)
						var_78_5, var_78_6, var_78_7 = string.find(var_78_4, "#(L[^#]+)#", var_78_6 + 1)
					end

					beauty.singleTextAutoScroll({
						fontSize = 36,
						waitTimeSt = 2,
						isRich = true,
						align = "left",
						style = 1,
						speed = 108,
						waitTimeEnd = 2,
						strs = var_78_4,
						list = var_78_1.list,
						anchor = cc.p(0, 0.5),
						vertical = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
					})
					arg_77_0.baseTalkPanel:show()

					return
				end
			end
		end

		arg_77_0.baseTalkPanel:hide()
	end)

	local var_77_0 = arg_77_0.talkList:getInnerContainer():getPositionX()
	local var_77_1 = 0
	local var_77_2 = 5

	local function var_77_3(arg_79_0, arg_79_1)
		if arg_79_1 == ccui.TouchEventType.began then
			var_77_1 = 0
		elseif arg_79_1 == ccui.TouchEventType.moved then
			if var_77_1 <= var_77_2 then
				local var_79_0 = arg_77_0.talkList:getInnerContainer():getPositionX()

				var_77_1 = var_77_1 + math.abs(var_79_0 - var_77_0)
				var_77_0 = var_79_0
			end
		elseif arg_79_1 == ccui.TouchEventType.ended then
			if var_77_1 < var_77_2 then
				arg_77_0:onTalkClick()
			end

			var_77_1 = 0
			var_77_0 = arg_77_0.talkList:getInnerContainer():getPositionX()
		end
	end

	arg_77_0.talkList:addTouchEventListener(function(arg_80_0, arg_80_1)
		var_77_3(arg_80_0, arg_80_1)
	end)

	arg_77_0.chatPrivatalyLastId = gGameModel.forever_dispatch:getIdlerOrigin("chatPrivatalyLastId")

	idlereasy.any({
		arg_77_0.friendMessage,
		arg_77_0.chatPrivatalyLastId
	}, function(arg_81_0, arg_81_1, arg_81_2)
		local var_81_0 = itertools.size(arg_81_1)
		local var_81_1 = arg_81_1[var_81_0]

		if arg_81_1 and var_81_0 ~= 0 and arg_81_2 < var_81_1.id and not var_81_1.isMine then
			arg_77_0.talkRedHint:set(true, true)
		else
			arg_77_0.talkRedHint:set(false)
		end
	end)
end

function var_0_11.initPoster(arg_82_0)
	if userDefault.getForeverLocalKey("posterLoginShow", false, {
		rawKey = true
	}) then
		return
	end

	arg_82_0.posterState = idler.new(false)

	local var_82_0 = {}

	arg_82_0.posterIds = {}

	local var_82_1 = userDefault.getCurrDayKey("posterNotShowInfo", {})
	local var_82_2 = gGameModel.currday_dispatch:getIdlerOrigin("newPlayerWeffare"):read()

	for iter_82_0, iter_82_1 in ipairs(arg_82_0.yyOpen:read()) do
		local var_82_3 = csv.yunying.yyhuodong[iter_82_1]

		if var_82_3.type == var_0_0.clientShow and var_82_3.independent == -1 and not var_82_1[iter_82_1] then
			local function var_82_4()
				arg_82_0.posterIds[iter_82_1] = true

				table.insert(var_82_0, {
					viewName = "city.activity.poster",
					id = iter_82_1,
					sortWeight = var_82_3.sortWeight,
					params = {
						{
							cfg = var_82_3,
							state = arg_82_0:createHandler("posterState")
						}
					}
				})
			end

			if var_82_3.clientParam.isReunion then
				local var_82_5 = arg_82_0.reunion:read()

				if var_82_5 and var_82_5.role_type == 1 then
					for iter_82_2, iter_82_3 in ipairs(arg_82_0.yyOpen:read()) do
						if iter_82_3 == var_82_5.info.yyID and var_82_5.info.end_time > time.getTime() then
							var_82_4()
						end
					end
				end
			else
				var_82_4()
			end
		end
	end

	if not itertools.isempty(var_82_0) then
		table.sort(var_82_0, function(arg_84_0, arg_84_1)
			if arg_84_0.sortWeight ~= arg_84_1.sortWeight then
				return arg_84_0.sortWeight < arg_84_1.sortWeight
			end

			return arg_84_0.id < arg_84_1.id
		end)

		var_82_0[#var_82_0].params[1].cb = arg_82_0:createHandler("onPosterCb")

		arraytools.merge_inplace(arg_82_0.autoPopBoxInfo, {
			var_82_0
		})
	end
end

function var_0_11.onPosterCb(arg_85_0)
	if arg_85_0.posterState:read() then
		userDefault.setCurrDayKey("posterNotShowInfo", arg_85_0.posterIds)
	end
end

function var_0_11.checkPopBox(arg_86_0, arg_86_1)
	local function var_86_0()
		if dev.IGNORE_POPUP_BOX then
			return
		end

		if arg_86_1 and arg_86_0.hasCheckPopBoxFirst then
			return
		end

		arg_86_0.hasCheckPopBoxFirst = true

		performWithDelay(arg_86_0, function()
			if gGameUI.guideManager:isInGuiding() then
				return
			end

			if itertools.isempty(arg_86_0.autoPopBoxInfo) then
				if sdk.loginInfo then
					local var_88_0 = json.decode(sdk.loginInfo)

					sdk.loginInfo = nil
				end

				return
			end

			local var_88_1 = arg_86_0.autoPopBoxInfo[1]

			if var_88_1.viewName == "city.activity.poster" then
				userDefault.setForeverLocalKey("posterLoginShow", true, {
					rawKey = true
				})
			end

			table.remove(arg_86_0.autoPopBoxInfo, 1)

			if var_88_1.func then
				var_88_1.func(function()
					arg_86_0:stackUI(var_88_1.viewName, nil, var_88_1.styles, unpack(var_88_1.params or {}))
				end)
			else
				arg_86_0:stackUI(var_88_1.viewName, nil, var_88_1.styles, unpack(var_88_1.params or {}))
			end
		end, 0)
	end

	if not game.hasCheckOnlineFight and gGameModel.role:read("in_cross_online_fight_battle") then
		game.hasCheckOnlineFight = true

		gGameUI:showDialog({
			isRich = true,
			btnType = 2,
			clearFast = true,
			content = "#C0x5B545B#" .. gLanguageCsv.onlineFightReconnection,
			cb = function()
				dataEasy.onlineFightLoginServer(arg_86_0, var_86_0)
			end,
			closeCb = var_86_0
		})
	else
		var_86_0()
	end
end

function var_0_11.initAutoNewPlayerWeal(arg_91_0)
	if gGameModel.currday_dispatch:getIdlerOrigin("newPlayerWeffare"):read() == true then
		return
	end

	idlereasy.when(arg_91_0.autoNewPlayerWealId, function(arg_92_0, arg_92_1)
		if arg_92_1 > 0 then
			table.insert(arg_91_0.autoPopBoxInfo, {
				viewName = "city.activity.recharge_feedback.new_player_welfare",
				params = {
					arg_92_1
				},
				func = function(arg_93_0)
					gGameApp:requestServer("/game/yy/active/get", function(arg_94_0)
						arg_93_0()
					end)
				end
			})
			arg_91_0.autoNewPlayerWealId:set(-1)
		end
	end)
end

function var_0_11.initActivityTip(arg_95_0, arg_95_1)
	if not arg_95_1 then
		arg_95_0.activityTip:hide()
		arg_95_0.activityTip:removeChildByName("gojt")

		return
	end

	widget.addAnimationByKey(arg_95_0.activityTip, "huodongtixing/huodongtixing.skel", "gojt", "effect_loop", 1):alignCenter(arg_95_0.activityTip:size())

	local var_95_0 = arg_95_1.name or csv.unlock[gUnlockCsv[arg_95_1.feature]].name

	adapt.setTextScaleWithWidth(arg_95_0.activityTip:get("textNote1"), var_95_0, 180)
	adapt.setTextScaleWithWidth(arg_95_0.activityTip:get("textNote2"), arg_95_1.txt, 180)
	bind.touch(arg_95_0, arg_95_0.activityTip, {
		methods = {
			ended = function()
				if arg_95_1.reminder == 2 then
					userDefault.setForeverLocalKey("sysOpen" .. arg_95_1.sighid, tostring(gGameModel.role:read(arg_95_1.roundKey)))
				else
					userDefault.setForeverLocalKey("sysOpen" .. arg_95_1.sighid, time.getTodayStr())
				end

				jumpEasy.jumpTo(arg_95_1.goTo)

				if arg_95_1.reminder ~= 0 then
					arg_95_0.isRefresh:notify()
				end
			end
		}
	})
	arg_95_0.activityTip:show()
end

function var_0_11.initGrowPanel(arg_97_0)
	local var_97_0 = {
		arg_97_0.growGuideData
	}

	for iter_97_0, iter_97_1 in ipairs(gGrowGuideCsv) do
		table.insert(var_97_0, dataEasy.getListenUnlock(iter_97_1.feature))
	end

	idlereasy.any(var_97_0, function(arg_98_0, arg_98_1, ...)
		local var_98_0 = {
			...
		}
		local var_98_1 = {}
		local var_98_2 = 0

		for iter_98_0, iter_98_1 in ipairs(gGrowGuideCsv) do
			local var_98_3 = iter_98_1.id

			var_98_2 = var_98_2 + 1

			if not arg_98_1 or not arg_98_1[var_98_3] or arg_98_1[var_98_3][1] ~= 0 then
				local var_98_4 = {
					cfg = iter_98_1,
					csvId = var_98_3
				}
				local var_98_5 = 3

				if arg_98_1 and arg_98_1[var_98_3] and arg_98_1[var_98_3][1] == 1 then
					var_98_5 = 1
				elseif not var_98_0[var_98_2] then
					var_98_5 = 2
				end

				if iter_98_1.feature == "craft" and var_98_5 ~= 2 then
					local var_98_6, var_98_7 = dataEasy.judgeServerOpen("craft")

					if not var_98_6 and var_98_7 then
						var_98_5 = 2
						var_98_4.serverDay = var_98_7
					end
				end

				var_98_4.state = var_98_5

				table.insert(var_98_1, var_98_4)
			end
		end

		table.sort(var_98_1, function(arg_99_0, arg_99_1)
			local var_99_0 = csv.unlock
			local var_99_1 = var_99_0[gUnlockCsv[arg_99_0.cfg.feature]].startLevel
			local var_99_2 = var_99_0[gUnlockCsv[arg_99_1.cfg.feature]].startLevel

			if var_99_1 ~= var_99_2 then
				return var_99_1 < var_99_2
			end

			return arg_99_0.csvId < arg_99_1.csvId
		end)

		local var_98_8
		local var_98_9
		local var_98_10 = 999

		for iter_98_2, iter_98_3 in ipairs(var_98_1) do
			if var_98_10 > iter_98_3.state then
				var_98_8 = iter_98_3
				var_98_10 = iter_98_3.state
				var_98_9 = iter_98_2
			end

			if var_98_10 == 1 then
				break
			end
		end

		if not var_98_8 then
			arg_97_0.growGuide:hide()

			return
		end

		arg_97_0.growGuide:get("textNote1"):text(var_98_8.cfg.name)
		arg_97_0.growGuide:removeChildByName("getEffect")
		arg_97_0.growGuide:get("imgBg"):show()
		arg_97_0.growGuide:get("imgIcon"):show()
		arg_97_0.growGuide:get("imgBg2"):show()

		local var_98_11 = ""

		if var_98_8.state == 1 then
			var_98_11 = gLanguageCsv.rewardCanGet

			arg_97_0.growGuide:get("imgBg"):hide()
			arg_97_0.growGuide:get("imgIcon"):hide()
			arg_97_0.growGuide:get("imgBg2"):hide()
			widget.addAnimationByKey(arg_97_0.growGuide, "effect/xiangdao.skel", "getEffect", "effect_loop", 3):xy(120, 19):scale(2)
		elseif var_98_8.state == 2 then
			local var_98_12 = gUnlockCsv[var_98_8.cfg.feature]
			local var_98_13 = csv.unlock[var_98_12]

			var_98_11 = string.format(gLanguageCsv.arrivalLevelOpen, var_98_13.startLevel)

			if var_98_8.serverDay then
				var_98_11 = string.format(gLanguageCsv.unlockServerOpen, var_98_8.serverDay)
			end
		elseif var_98_8.state == 3 then
			var_98_11 = gLanguageCsv.stateFighting
		end

		arg_97_0.growGuide:get("textNote2"):text(var_98_11)
		adapt.setTextScaleWithWidth(arg_97_0.growGuide:get("textNote2"), nil, 170)
		arg_97_0.growGuide:show()
		bind.touch(arg_97_0, arg_97_0.growGuide, {
			methods = {
				ended = function()
					gGameUI:stackUI("city.grow_guide", nil, nil, var_98_9)
				end
			}
		})
	end)
end

function var_0_11.setCountdown(arg_101_0, arg_101_1, arg_101_2)
	arg_101_0:enableSchedule()
	arg_101_0:unSchedule(arg_101_2.tag)

	local var_101_0 = arg_101_2.endTime - time.getTime()

	if var_101_0 <= 0 then
		arg_101_1:hide()

		if arg_101_2.cb then
			arg_101_2.cb()
		end

		return
	end

	arg_101_0:schedule(function()
		var_101_0 = arg_101_2.endTime - time.getTime()

		local var_102_0 = time.getCutDown(var_101_0)
		local var_102_1 = var_102_0.day * 24 + var_102_0.hour

		if var_102_0.day and var_102_0.day > 0 then
			arg_101_1:text(string.format("%s" .. gLanguageCsv.day, gLanguageCsv.exclusiveIconTime, var_102_0.day))
		else
			arg_101_1:text(string.format("%02d:%02d:%02d", var_102_0.hour, var_102_0.min, var_102_0.sec))
		end

		if var_101_0 <= 0 then
			var_0_11.setCountdown(arg_101_0, arg_101_1, arg_101_2)
		end
	end, 1, 0, arg_101_2.tag)
end

function var_0_11.onReFreshRedHint(arg_103_0)
	arg_103_0.redHintRefresh:modify(function(arg_104_0)
		return true, not arg_104_0
	end)
end

function var_0_11.setGameSyncTimer(arg_105_0)
	local var_105_0 = {
		18000,
		75600
	}

	var_105_0[#var_105_0 + 1] = var_105_0[1] + 86400

	local var_105_1 = time.getNowDate()
	local var_105_2 = var_105_1.hour * 3600 + var_105_1.min * 60 + var_105_1.sec
	local var_105_3 = 1

	for iter_105_0 = 1, #var_105_0 do
		if var_105_2 < var_105_0[iter_105_0] then
			var_105_3 = var_105_0[iter_105_0] - var_105_2 + 1

			break
		end
	end

	performWithDelay(arg_105_0, function()
		gGameApp:slientRequestServer("/game/sync", functools.handler(arg_105_0, "setGameSyncTimer"))
	end, var_105_3)
end

function var_0_11.setFishingGameTimer(arg_107_0)
	local var_107_0 = {
		18015,
		82800
	}

	var_107_0[#var_107_0 + 1] = var_107_0[1] + 86400

	local var_107_1 = time.getNowDate()
	local var_107_2 = var_107_1.hour * 3600 + var_107_1.min * 60 + var_107_1.sec
	local var_107_3 = 1

	for iter_107_0 = 1, #var_107_0 do
		if var_107_2 < var_107_0[iter_107_0] then
			var_107_3 = var_107_0[iter_107_0] - var_107_2 + 1

			break
		end
	end

	performWithDelay(arg_107_0, function()
		gGameApp:slientRequestServer("/game/sync", functools.handler(arg_107_0, "setFishingGameTimer"))
	end, var_107_3)
end

function var_0_11.specialGiftLink(arg_109_0)
	if matchLanguage({
		"kr"
	}) then
		local var_109_0 = ccui.ImageView:create("city/main/icon_krgift.png"):setTouchEnabled(true):scale(0.95):xy(128, 410)

		bind.touch(arg_109_0, var_109_0, {
			methods = {
				ended = function()
					gGameUI:stackUI("city.kr_gift_link_view")
				end
			}
		})
		arg_109_0.rightBottomPanel:addChild(var_109_0, 2, "krGift")
	end
end

function var_0_11.setSecialSupport(arg_111_0)
	if matchLanguage({
		"en",
		"cn"
	}) then
		-- block empty
	end
end

function var_0_11.setTimeLabel(arg_112_0)
	if matchLanguage({
		"en",
		"cn"
	}) then
		arg_112_0.daytime:visible(true)
		arg_112_0.yeartime:visible(true)

		local var_112_0 = {
			"Jan.",
			"Feb.",
			"Mar.",
			"Apr.",
			"May.",
			"Jun.",
			"Jul.",
			"Aug.",
			"Sep.",
			"Oct.",
			"Nov.",
			"Dec."
		}

		arg_112_0:enableSchedule():schedule(function()
			local var_113_0 = time.getTimeTable()

			arg_112_0.yeartime:text(string.format("%s/%02d/%04d", var_112_0[var_113_0.month], var_113_0.day, var_113_0.year))
			arg_112_0.daytime:text(string.format("%02d:%02d", var_113_0.hour, var_113_0.min))
		end, 1, 0)
	else
		arg_112_0.daytime:visible(false)
		arg_112_0.yeartime:visible(false)
	end
end

return var_0_11
