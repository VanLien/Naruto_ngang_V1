local var_0_0 = require("app.views.city.union.tools")
local var_0_1 = require("app.views.city.union.cross_unionfight.tools")
local var_0_2 = {
	"dailygift",
	"redpacket",
	"training",
	"unionskill",
	"fuben",
	"unionFight",
	"unionqa",
	"crossunionfight"
}
local var_0_3 = {
	fragdonate = function(arg_1_0, arg_1_1)
		if not var_0_0.canEnterBuilding("fragdonate", nil, true) then
			return false
		end

		return arg_1_0.unionFragDonateStartTimes:read() == 0
	end,
	contribute = function(arg_2_0, arg_2_1)
		if not var_0_0.canEnterBuilding("contribute", nil, true) then
			return false
		end

		local var_2_0 = arg_2_0.unionLv:read()

		return csv.union.union_level[var_2_0].ContribMax > arg_2_0.contribCount:read()
	end,
	uniontask = function(arg_3_0, arg_3_1)
		if not var_0_0.canEnterBuilding("contribute", nil, true) then
			return false
		end

		local var_3_0 = false
		local var_3_1 = {}

		for iter_3_0, iter_3_1 in pairs(arg_3_0.unionAllTasks:read()) do
			var_3_1[iter_3_0] = iter_3_1[2]
		end

		for iter_3_2, iter_3_3 in orderCsvPairs(csv.union.union_task) do
			if iter_3_3.type == 1 and (not var_3_1[iter_3_2] or var_3_1[iter_3_2] == 0) then
				var_3_0 = true

				break
			end
		end

		return var_3_0
	end,
	dailygift = function(arg_4_0, arg_4_1)
		if not var_0_0.canEnterBuilding("dailygift", nil, true) then
			return false
		end

		return arg_4_0.dailyGiftTimes:read() <= 0
	end,
	speedup = function(arg_5_0, arg_5_1)
		if not var_0_0.canEnterBuilding("training", nil, true) then
			return false
		end

		local var_5_0 = 0

		if arg_5_1.tarhetArg then
			var_5_0 = math.max(6 - arg_5_0.trainingSpeedup:read(), 0)
		end

		return arg_5_0.trainingSpeedup:read() < 6, var_5_0
	end,
	dailypacket = function(arg_6_0, arg_6_1)
		if not var_0_0.canEnterBuilding("redpacket", nil, true) then
			return false
		end

		return arg_6_0.systemRedPacket:read()
	end,
	fuben = function(arg_7_0, arg_7_1)
		local var_7_0 = var_0_0.canEnterBuilding("fuben", nil, true)
		local var_7_1 = var_0_0.currentOpenFuben()

		if not var_7_0 or var_7_1 ~= "open" then
			return false
		end

		local var_7_2 = arg_7_0.unionFbTimes:read()
		local var_7_3 = 0

		if arg_7_1.tarhetArg then
			var_7_3 = math.max(3 - var_7_2, 0)
		end

		return math.max(3 - var_7_2, 0) > 0, var_7_3
	end,
	fightsign = function(arg_8_0, arg_8_1)
		return false
	end
}

local function var_0_4(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0:get("effect")
	local var_9_1 = arg_9_0:size()

	if not var_9_0 then
		var_9_0 = widget.addAnimationByKey(arg_9_0, "union/hongbaokeling.skel", "effect", arg_9_1, 2):xy(var_9_1.width / 2 + 0, var_9_1.height / 2 + 0)
	else
		var_9_0:show():play(arg_9_1)
	end
end

local var_0_5 = {
	dailygift = function(arg_10_0)
		if not var_0_0.canEnterBuilding("dailygift") then
			return
		end

		if arg_10_0.dailyGiftTimes:read() > 0 then
			gGameUI:showTip(gLanguageCsv.aleardyGetGift)

			return
		end

		local var_10_0 = {
			false
		}

		gGameApp:requestServerCustom("/game/union/daily_gift"):params():onResponse(function(arg_11_0)
			arg_10_0.dailygift:get("effect"):play("dianji_houjing")

			local var_11_0 = arg_10_0.effectPanel:get("effect")

			if not var_11_0 then
				var_11_0 = widget.addAnimationByKey(arg_10_0.effectPanel, "union/gonghuimeiri.skel", "effect", "dianji_qianjing", 1):xy(565, 170)

				var_11_0:setSpriteEventHandler(function(arg_12_0, arg_12_1)
					var_11_0:hide()
					arg_10_0.dailygift:get("effect"):play("standby_loop")

					var_10_0[1] = true
				end, sp.EventType.ANIMATION_COMPLETE)
			else
				var_11_0:show():play("dianji_qianjing")
			end
		end):wait(var_10_0):doit(function(arg_13_0)
			gGameUI:showGainDisplay(arg_13_0)
		end)
	end,
	redpacket = function(arg_14_0)
		if not var_0_0.canEnterBuilding("redpacket", true) then
			return
		end

		gGameApp:requestServer("/game/union/redpacket/info", function(arg_15_0)
			gGameUI:stackUI("city.union.redpack.view", nil, {
				full = true
			}, arg_15_0.view)
		end)
	end,
	training = function(arg_16_0)
		if not var_0_0.canEnterBuilding("training") then
			return
		end

		gGameApp:requestServer("/game/union/training/open", function(arg_17_0)
			gGameUI:stackUI("city.union.train.view", nil, nil, arg_17_0)
		end)
	end,
	unionskill = function(arg_18_0)
		if not var_0_0.canEnterBuilding("unionskill", true) then
			return
		end

		gGameUI:stackUI("city.union.skill.view")
	end,
	fuben = function(arg_19_0)
		if not var_0_0.canEnterBuilding("fuben") then
			return
		end

		gGameApp:requestServer("/game/union/fuben/get", function(arg_20_0)
			gGameUI:stackUI("city.union.gate.view", nil, nil, arg_20_0.view)
		end)
	end,
	unionFight = function(arg_21_0)
		if not dataEasy.isInServer("unionFight") then
			return
		end

		if not var_0_0.canEnterBuilding("unionFight") then
			return
		end

		if not dataEasy.isUnlock(gUnlockCsv.unionFight) then
			local var_21_0 = dataEasy.getUnlockTip(gUnlockCsv.unionFight)

			gGameUI:showTip(var_21_0)

			return
		end

		for iter_21_0, iter_21_1 in csvPairs(csv.pvpandpve) do
			if iter_21_1.unlockFeature == "unionFight" then
				local var_21_1 = getCsv(iter_21_1.serverDayInfo.sevCsv)

				if dataEasy.serverOpenDaysLess(var_21_1) then
					local var_21_2 = string.format(gLanguageCsv.unlockServerOpen, var_21_1)

					gGameUI:showTip(var_21_2)

					return
				end
			end
		end

		gGameApp:requestServer("/game/union/fight/battle/main", function(arg_22_0)
			gGameUI:stackUI("city.union.union_fight.view", nil, {
				full = true
			})
		end)
	end,
	contribute = function(arg_23_0)
		if not var_0_0.canEnterBuilding("contribute") then
			return
		end

		gGameUI:stackUI("city.union.contrib.view")
	end,
	fragdonate = function(arg_24_0)
		if not var_0_0.canEnterBuilding("fragdonate") then
			return
		end

		gGameApp:requestServer("/game/union/get", function(arg_25_0)
			gGameUI:stackUI("city.union.frag_donate.view")
		end)
	end,
	lobby = function()
		gGameApp:requestServer("/game/union/get", function(arg_27_0)
			gGameUI:stackUI("city.union.lobby.view", nil, {
				full = true
			})
		end)
	end,
	unionnotice = function(arg_28_0)
		local var_28_0 = {
			content = arg_28_0.unionNoticeText:read(),
			title = gLanguageCsv.notice
		}

		gGameUI:showDialog(var_28_0)
	end,
	unionshop = function(arg_29_0)
		if not gGameUI:goBackInStackUI("city.shop") then
			gGameApp:requestServer("/game/union/shop/get", function(arg_30_0)
				gGameUI:stackUI("city.shop", nil, {
					full = true
				}, game.SHOP_INIT.UNION_SHOP)
			end)
		end
	end,
	unionqa = function(arg_31_0)
		if not var_0_0.canEnterBuilding("unionqa") then
			return
		end

		if not dataEasy.isUnlock(gUnlockCsv.unionQA) then
			local var_31_0 = dataEasy.getUnlockTip(gUnlockCsv.unionQA)

			gGameUI:showTip(var_31_0)

			return
		end

		local var_31_1 = csv.cross.union_qa.base[1].servOpenDays

		if dataEasy.serverOpenDaysLess(var_31_1) then
			local var_31_2 = string.format(gLanguageCsv.unlockServerOpen, var_31_1)

			gGameUI:showTip(var_31_2)

			return
		end

		gGameApp:requestServer("/game/union/qa/main", function(arg_32_0)
			gGameUI:stackUI("city.union.answer.view", nil, {
				full = true
			}, arg_32_0)
		end)
	end,
	crossunionfight = function(arg_33_0)
		if not dataEasy.isInServer("crossunionfight") then
			return
		end

		if not dataEasy.isUnlock(gUnlockCsv.crossunionfight) then
			local var_33_0 = dataEasy.getUnlockTip(gUnlockCsv.crossunionfight)

			gGameUI:showTip(var_33_0)

			return
		end

		for iter_33_0, iter_33_1 in csvPairs(csv.pvpandpve) do
			if iter_33_1.unlockFeature == "crossunionfight" then
				local var_33_1 = getCsv(iter_33_1.serverDayInfo.sevCsv)

				if dataEasy.serverOpenDaysLess(var_33_1) then
					local var_33_2 = string.format(gLanguageCsv.unlockServerOpen, var_33_1)

					gGameUI:showTip(var_33_2)

					return
				end
			end
		end

		if dataEasy.notUseUnionBuild() then
			gGameUI:showTip(gLanguageCsv.crossunionfightJionTimeUp)

			return
		end

		if (gUnionFeatureCsv.crossunionfight or 0) <= arg_33_0.unionLv:read() then
			gGameApp:requestServer("/game/cross/union/fight/main", function()
				gGameUI:stackUI("city.union.cross_unionfight.view", nil, nil, arg_33_0:createHandler("crossUnionAnimaShow"))
			end)
		end
	end
}
local var_0_6 = class("UnionView", cc.load("mvc").ViewBase)

var_0_6.RESOURCE_FILENAME = "union_main.json"
var_0_6.RESOURCE_BINDING = {
	effectPanel = "effectPanel",
	item = "item",
	["scrollBuilding.unionNoName2"] = "unionNoName2",
	["scrollBuilding.ribbon"] = "ribbon",
	leftUp = {
		varname = "leftUp",
		binds = {
			event = "visible",
			idler = bindHelper.self("hasEnter")
		}
	},
	redpacket = {
		varname = "redpacket",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_35_0)
						arg_35_0:onBuildingClick("redpacket")
					end)
				}
			},
			{
				event = "visible",
				idler = bindHelper.self("isShowRedPack")
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					state = bindHelper.self("isShowRedPack"),
					specialTag = {
						"unionSystemRedPacket",
						"unionMemberRedPacket",
						"unionSendedRedPacket"
					},
					onNode = function(arg_36_0)
						arg_36_0:xy(171, 175)
					end
				}
			}
		}
	},
	["redpacket.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["leftUp.list"] = {
		varname = "listview",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("quickDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				dataOrderCmp = function(arg_37_0, arg_37_1)
					return arg_37_0.csvId < arg_37_1.csvId
				end,
				onItem = function(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
					arg_38_1:removeChildByName("content")

					local var_38_0 = arg_38_3.cfg.desc

					if arg_38_3.cfg.tarhetArg then
						var_38_0 = string.format("%s(%d/%d)", var_38_0, arg_38_3.leftNum, arg_38_3.cfg.tarhetArg)
					end

					local var_38_1 = rich.createWithWidth("#L100#" .. var_38_0, 40, nil, 400)

					var_38_1:anchorPoint(0, 0.5)
					arg_38_1:addChild(var_38_1, 2, "content")
					arg_38_1:height(var_38_1:height())
					var_38_1:xy(100, var_38_1:height() / 2)
					arg_38_1:get("imgIcon"):y(var_38_1:y())
					bind.touch(arg_38_0, arg_38_1, {
						methods = {
							ended = functools.partial(arg_38_0.clickCell, arg_38_2, arg_38_3.cfg)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	},
	bgEffect = {},
	scrollCloud = {
		varname = "scrollCloud",
		binds = {
			{
				event = "scrollBarEnabled",
				data = false
			}
		}
	},
	scrollMont1 = {
		varname = "scrollMont1",
		binds = {
			{
				event = "scrollBarEnabled",
				data = false
			}
		}
	},
	scrollMont2 = {
		varname = "scrollMont2",
		binds = {
			{
				event = "scrollBarEnabled",
				data = false
			}
		}
	},
	scrollMont3 = {
		varname = "scrollMont3",
		binds = {
			{
				event = "scrollBarEnabled",
				data = false
			}
		}
	},
	scroll = {
		varname = "scroll",
		binds = {
			{
				event = "scrollBarEnabled",
				data = false
			}
		}
	},
	scrollBuilding = {
		varname = "scrollBuilding",
		binds = {
			{
				event = "scrollBarEnabled",
				data = false
			}
		}
	},
	scrollPlant = {
		varname = "scrollPlant",
		binds = {
			{
				event = "scrollBarEnabled",
				data = false
			}
		}
	},
	contribute = {
		varname = "contribute",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_39_0)
						arg_39_0:onBuildingClick("contribute")
					end)
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "unionContribute",
					state = bindHelper.self("state"),
					onNode = function(arg_40_0)
						arg_40_0:xy(121, 125):scale(0.65)
					end
				}
			}
		}
	},
	fragdonate = {
		varname = "fragdonate",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_41_0)
						arg_41_0:onBuildingClick("fragdonate")
					end)
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "unionFragDonate",
					state = bindHelper.self("state"),
					onNode = function(arg_42_0)
						arg_42_0:xy(121, 125):scale(0.65)
					end
				}
			}
		}
	},
	["scrollBuilding.lobby"] = {
		varname = "lobby",
		binds = {
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "unionLobby",
					state = bindHelper.self("state"),
					onNode = function(arg_43_0)
						arg_43_0:xy(119, 388)
					end
				}
			},
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_44_0)
						arg_44_0:onBuildingClick("lobby")
					end)
				}
			}
		}
	},
	["scrollBuilding.lobby.crossUnionAnima"] = {
		varname = "crossUnionAnima"
	},
	["scrollBuilding.training"] = {
		varname = "training",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_45_0)
						arg_45_0:onBuildingClick("training")
					end)
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					state = bindHelper.self("trainingRedHint"),
					onNode = function(arg_46_0)
						arg_46_0:xy(703, 811)
					end
				}
			}
		}
	},
	["scrollBuilding.unionskill"] = {
		varname = "unionskill",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_47_0)
						arg_47_0:onBuildingClick("unionskill")
					end)
				}
			}
		}
	},
	["scrollBuilding.fuben"] = {
		varname = "fuben",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_48_0)
						arg_48_0:onBuildingClick("fuben")
					end)
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "unionFuben",
					state = bindHelper.self("state"),
					onNode = function(arg_49_0)
						arg_49_0:xy(750, 1580)
					end
				}
			}
		}
	},
	["scrollBuilding.dailygift"] = {
		varname = "dailygift",
		binds = {
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "unionDailyGift",
					state = bindHelper.self("state"),
					onNode = function(arg_50_0)
						arg_50_0:xy(451, 424)
					end
				}
			},
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_51_0)
						arg_51_0:onBuildingClick("dailygift")
					end)
				}
			}
		}
	},
	["scrollBuilding.unionfight"] = {
		varname = "unionFight",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_52_0)
						arg_52_0:onBuildingClick("unionFight")
					end)
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = {
						"unionFightSignUp"
					},
					onNode = function(arg_53_0)
						arg_53_0:xy(920, 900)
					end
				}
			}
		}
	},
	["scrollBuilding.unionNotice"] = {
		varname = "unionNotice",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_54_0)
						arg_54_0:onBuildingClick("unionnotice")
					end)
				}
			}
		}
	},
	["scrollBuilding.unionAnswer"] = {
		varname = "unionqa",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_55_0)
						arg_55_0:onBuildingClick("unionqa")
					end)
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = {
						"unionAnswer"
					},
					onNode = function(arg_56_0)
						arg_56_0:xy(395, 316)
					end
				}
			}
		}
	},
	["scrollBuilding.unionNotice.textNotice"] = {
		varname = "textNotice",
		binds = {
			event = "text",
			idler = bindHelper.self("unionNoticeText")
		}
	},
	["scrollBuilding.unionNoName3"] = {
		varname = "unionNoName3"
	},
	["scrollBuilding.unionShop"] = {
		varname = "unionShop",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_57_0)
						arg_57_0:onBuildingClick("unionshop")
					end)
				}
			}
		}
	},
	unionFuli = {
		varname = "unionFuli",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_58_0)
						arg_58_0:onBuildingClick("unionFuli")
					end)
				}
			}
		}
	},
	["scrollBuilding.crossunionfight"] = {
		varname = "crossunionfight",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_59_0)
						arg_59_0:onBuildingClick("crossunionfight")
					end)
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = {
						"crossUnionFight"
					},
					onNode = function(arg_60_0)
						arg_60_0:xy(400, 400)
					end
				}
			}
		}
	}
}

local var_0_7 = {
	unionFight = function(arg_61_0, arg_61_1, arg_61_2, arg_61_3, arg_61_4)
		local var_61_0, var_61_1 = dataEasy.judgeServerOpen("unionFight")

		arg_61_2 = arg_61_2 or not var_61_0 or not arg_61_3

		if not dataEasy.isInServer(arg_61_1) then
			arg_61_2 = true
		end

		return arg_61_2
	end,
	unionqa = function(arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4)
		if not gUnlockCsv.unionQA then
			arg_62_4:setTouchEnabled(false)

			return false
		end

		local var_62_0 = csv.cross.union_qa.base[1].servOpenDays
		local var_62_1 = dataEasy.serverOpenDaysLess(var_62_0)

		if not dataEasy.isUnlock(gUnlockCsv.unionQA) or var_62_1 then
			arg_62_2 = true
		end

		return arg_62_2
	end,
	dailygift = function(arg_63_0, arg_63_1, arg_63_2, arg_63_3, arg_63_4)
		local var_63_0 = (arg_63_0.dailyGiftTimes:read() >= 1 or arg_63_2 or dataEasy.notUseUnionBuild()) and "standby_loop" or "kelingqu_loop"

		arg_63_0.dailygift:get("effect"):play(var_63_0)

		return arg_63_2
	end,
	crossunionfight = function(arg_64_0, arg_64_1, arg_64_2, arg_64_3, arg_64_4)
		local var_64_0, var_64_1 = dataEasy.judgeServerOpen("crossunionfight")

		arg_64_2 = arg_64_2 or not var_64_0 or not arg_64_3

		if not dataEasy.isInServer(arg_64_1) then
			arg_64_2 = true
		end

		return arg_64_2
	end
}
local var_0_8 = {
	unionFight = function(arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4, arg_65_5, arg_65_6)
		local var_65_0, var_65_1 = dataEasy.judgeServerOpen("unionFight")

		if arg_65_5 or not var_65_0 or not arg_65_6 then
			if not dataEasy.isInServer(arg_65_4) then
				arg_65_3 = gLanguageCsv.pleaseWait
			elseif arg_65_1 == 0 or arg_65_2 < arg_65_1 then
				arg_65_3 = string.format(gLanguageCsv.unionUnlockLevel, arg_65_1)
			elseif not var_65_0 then
				arg_65_3 = string.format(gLanguageCsv.unlockServerOpen, var_65_1)
			elseif not arg_65_6 then
				arg_65_3 = dataEasy.getUnlockTip(gUnlockCsv.unionFight)
			end
		elseif gGameModel.role:read("union_fight_round") == "battle" then
			-- block empty
		end

		return arg_65_3
	end,
	unionqa = function(arg_66_0, arg_66_1, arg_66_2, arg_66_3, arg_66_4, arg_66_5, arg_66_6)
		local var_66_0 = csv.cross.union_qa.base[1].servOpenDays
		local var_66_1 = dataEasy.serverOpenDaysLess(var_66_0)

		if arg_66_1 ~= 0 and not (arg_66_2 < arg_66_1) then
			if var_66_1 then
				arg_66_3 = string.format(gLanguageCsv.unlockServerOpen, var_66_0)
			end

			if not dataEasy.isUnlock(gUnlockCsv.unionQA) then
				arg_66_3 = dataEasy.getUnlockTip(gUnlockCsv.unionQA)
			end
		end

		return arg_66_3
	end,
	crossunionfight = function(arg_67_0, arg_67_1, arg_67_2, arg_67_3, arg_67_4, arg_67_5, arg_67_6)
		local var_67_0, var_67_1 = dataEasy.judgeServerOpen("crossunionfight")

		if arg_67_5 or not var_67_0 or not arg_67_6 then
			if not dataEasy.isInServer(arg_67_4) then
				arg_67_3 = gLanguageCsv.pleaseWait
			elseif arg_67_1 == 0 or arg_67_2 < arg_67_1 then
				arg_67_3 = string.format(gLanguageCsv.unionUnlockLevel, arg_67_1)
			elseif not var_67_0 then
				arg_67_3 = string.format(gLanguageCsv.unlockServerOpen, var_67_1)
			elseif not arg_67_6 then
				arg_67_3 = dataEasy.getUnlockTip(gUnlockCsv.unionFight)
			end
		end

		return arg_67_3
	end
}

function var_0_6.onCreate(arg_68_0, arg_68_1, arg_68_2)
	arg_68_0.crossUnionData = arg_68_2

	arg_68_0:initModel()
	arg_68_0.crossunionfight:visible(dataEasy.isShow("crossunionfight"))
	arg_68_0.scrollBuilding:size(display.sizeInViewRect):x(display.sizeInViewRect.x):jumpToPercentHorizontal(50)
	arg_68_0.scrollPlant:size(display.sizeInViewRect):x(display.sizeInViewRect.x)
	arg_68_0.scroll:size(display.sizeInViewRect):x(display.sizeInViewRect.x)
	arg_68_0.scrollCloud:size(display.sizeInViewRect):x(display.sizeInViewRect.x)
	arg_68_0.scrollMont1:size(display.sizeInViewRect):x(display.sizeInViewRect.x)
	arg_68_0.scrollMont2:size(display.sizeInViewRect):x(display.sizeInViewRect.x)
	arg_68_0.scrollMont3:size(display.sizeInViewRect):x(display.sizeInViewRect.x)

	local function var_68_0(arg_69_0)
		arg_68_0.scrollPlant:jumpToPercentHorizontal(arg_69_0)
		arg_68_0.scroll:jumpToPercentHorizontal(arg_69_0)
		arg_68_0.scrollMont1:jumpToPercentHorizontal(arg_69_0 * 0.78)
		arg_68_0.scrollMont2:jumpToPercentHorizontal(arg_69_0 * 0.55)
		arg_68_0.scrollMont3:jumpToPercentHorizontal(arg_69_0 * 0.45)
		arg_68_0.scrollCloud:jumpToPercentHorizontal(arg_69_0 * 0.38)
	end

	var_68_0(50)
	arg_68_0.scrollBuilding:onEvent(function(arg_70_0)
		if arg_70_0.name == "CONTAINER_MOVED" then
			local var_70_0 = arg_68_0.scrollBuilding:getScrolledPercentHorizontal()

			var_68_0(var_70_0)
		end
	end)

	local var_68_1 = not gUnionFeatureCsv.dailygift or gUnionFeatureCsv.dailygift > arg_68_0.unionLv:read()
	local var_68_2 = (arg_68_0.dailyGiftTimes:read() >= 1 or var_68_1 or dataEasy.notUseUnionBuild()) and "standby_loop" or "kelingqu_loop"

	widget.addAnimationByKey(arg_68_0.dailygift, "union/gonghuimeiri.skel", "effect", var_68_2, 1):xy(170, 90)

	arg_68_0.isShowRedPack = dataEasy.getListenUnlock(gUnlockCsv.unionRedpacket)
	arg_68_0.tarinRedHintState = false
	arg_68_0.trainingRedHint = idler.new(false)

	gGameUI.topuiManager:createView("union", arg_68_0, {
		onClose = arg_68_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = "common/txt/txt_bt_zuzhi.png"
	})
	idlereasy.when(arg_68_0.unionLv, function(arg_71_0, arg_71_1)
		for iter_71_0, iter_71_1 in pairs(var_0_2) do
			local var_71_0 = gUnionFeatureCsv[iter_71_1] or 0
			local var_71_1 = var_71_0 == 0 or arg_71_1 < var_71_0
			local var_71_2 = true
			local var_71_3 = arg_68_0[iter_71_1]

			if var_0_7[iter_71_1] then
				var_71_1 = var_0_7[iter_71_1](arg_68_0, iter_71_1, var_71_1, var_71_2, var_71_3)
			end

			local var_71_4 = var_71_3:get("lock")

			if var_71_4 then
				var_71_4:visible(var_71_1)

				local var_71_5 = string.format(gLanguageCsv.unionUnlockLevel, var_71_0)

				if var_0_8[iter_71_1] then
					var_71_5 = var_0_8[iter_71_1](arg_68_0, var_71_0, arg_71_1, var_71_5, iter_71_1, var_71_1, var_71_2)
				end

				var_71_4:get("textNote"):text(var_71_5)
			end

			local var_71_6 = var_71_1 and 0 or 1
			local var_71_7 = var_71_3:get("effect")

			if var_71_7 then
				var_71_7:setTimeScale(var_71_6)
			end
		end

		arg_68_0:setTrainingRedHint()
	end)

	local var_68_3 = {
		arg_68_0.unionLv,
		arg_68_0.contribCount,
		arg_68_0.unionAllTasks,
		arg_68_0.unionTasks,
		arg_68_0.dailyGiftTimes,
		arg_68_0.trainingSpeedup,
		arg_68_0.memberRedPacket,
		arg_68_0.systemRedPacket,
		arg_68_0.unionFbTimes,
		arg_68_0.unionFragDonateStartTimes
	}

	arg_68_0.quickDatas = idlertable.new({})

	idlereasy.any(var_68_3, function(arg_72_0, ...)
		local var_72_0 = {}
		local var_72_1 = 0

		for iter_72_0, iter_72_1 in orderCsvPairs(csv.union.daily_notice) do
			local var_72_2 = var_0_3[iter_72_1.targetType]

			if var_72_2 then
				local var_72_3, var_72_4 = var_72_2(arg_68_0, iter_72_1)

				if var_72_3 then
					table.insert(var_72_0, {
						cfg = iter_72_1,
						leftNum = var_72_4,
						csvId = iter_72_0
					})

					var_72_1 = var_72_1 + 1

					if var_72_1 == 3 then
						break
					end
				end
			end
		end

		arg_68_0.quickDatas:set(var_72_0)

		local var_72_5 = arg_68_0.item:size()
		local var_72_6 = arg_68_0.listview:getItemsMargin()
		local var_72_7 = var_72_1 * var_72_5.height + var_72_6 * (var_72_1 - 1)
		local var_72_8 = arg_68_0.leftUp:get("imgBg"):size()

		arg_68_0.leftUp:get("imgBg"):size(var_72_8.width, var_72_7 + 37 + 39)

		local var_72_9 = arg_68_0.listview:size()

		arg_68_0.listview:size(var_72_9.width, var_72_7)

		local var_72_10 = arg_68_0.leftUp:size()
		local var_72_11 = (var_72_10.height - (var_72_7 + 37 + 39)) / 2
		local var_72_12 = var_72_10.height / 2 + var_72_11

		arg_68_0.leftUp:get("imgBg"):y(var_72_12)
		arg_68_0.listview:y(var_72_12 - (var_72_7 + 37 + 39) / 2 + 37)
	end)

	arg_68_0.hasEnter = idler.new(false)

	idlereasy.when(arg_68_0.quickDatas, function(arg_73_0, arg_73_1)
		arg_68_0.hasEnter:set(#arg_73_1 > 0)
	end)

	local var_68_4 = {
		arg_68_0.unionLv,
		arg_68_0.memberRedPacket,
		arg_68_0.systemRedPacket,
		arg_68_0.redPacketRobCount,
		arg_68_0.unionRedpackets,
		arg_68_0.sendedRedPacket
	}

	idlereasy.any(var_68_4, function(arg_74_0, arg_74_1, arg_74_2, arg_74_3, arg_74_4, arg_74_5, arg_74_6)
		local var_74_0 = gUnionFeatureCsv.redpacket or 0
		local var_74_1 = var_74_0 == 0 or arg_74_1 < var_74_0
		local var_74_2 = true
		local var_74_3 = gCommonConfigCsv.unionRobRedpacketDailyLimit
		local var_74_4 = (not dataEasy.notUseUnionBuild() and not var_74_1 or false) and (arg_74_3 and dataEasy.canSystemRedPacket() or arg_74_2 and arg_74_4 < var_74_3 or not arg_74_6 and itertools.size(arg_74_5) > 0) and "effect_loop" or "effect1_loop"

		var_0_4(arg_68_0.redpacket, var_74_4)
	end)

	if matchLanguage({
		"en"
	}) then
		for iter_68_0 = 1, math.huge do
			if not arg_68_0["textNote" .. iter_68_0] then
				break
			end

			arg_68_0["imgTextBG" .. iter_68_0]:height(320)
			adapt.setAutoText(arg_68_0["textNote" .. iter_68_0], nil, 300)
			arg_68_0["textNote" .. iter_68_0]:y(arg_68_0["imgTextBG" .. iter_68_0]:y() - 165)
		end
	else
		for iter_68_1 = 1, math.huge do
			if not arg_68_0["textNote" .. iter_68_1] then
				break
			end

			adapt.setAutoText(arg_68_0["textNote" .. iter_68_1], nil, 244)
		end
	end

	arg_68_0:crossUnionAnimaShow()
end

function var_0_6.crossUnionAnimaShow(arg_75_0)
	local var_75_0 = gGameModel.role:read("cross_union_fight_status")

	if var_75_0 == nil then
		arg_75_0.crossUnionAnima:hide()
	elseif var_75_0 == "closed" then
		arg_75_0.crossUnionAnima:hide()

		if arg_75_0.crossUnionData and arg_75_0.crossUnionData.union_db_id and var_0_1.whetherCloseShowUI() and not arg_75_0.ribbon:get("panel"):get("rich") then
			arg_75_0.ribbon:show()
			arg_75_0.ribbon:get("imgIcon"):show()
			arg_75_0.ribbon:get("panel"):show()
			arg_75_0.ribbon:get("panel.name"):hide()

			local var_75_1 = string.format(gLanguageCsv.brackets, getServerArea(arg_75_0.crossUnionData.server_key, nil))
			local var_75_2 = string.format(gLanguageCsv.getFirstPlace, var_75_1, arg_75_0.crossUnionData.union_name)
			local var_75_3 = rich.createWithWidth(var_75_2, 32, nil, 240):addTo(arg_75_0.ribbon:get("panel"), 10, "rich"):anchorPoint(cc.p(0.5, 1)):xy(130, 66):formatText()
			local var_75_4 = var_75_3:height() / 36 * 67
			local var_75_5 = cc.Sequence:create(cc.MoveTo:create(gCommonConfigCsv.crossUnionFight, cc.p(120, var_75_4)), cc.CallFunc:create(function()
				var_75_3:xy(120, 20)
			end))
			local var_75_6 = cc.RepeatForever:create(var_75_5)

			var_75_3:runAction(var_75_6)
		end
	else
		arg_75_0.crossUnionAnima:show()
	end
end

function var_0_6.initModel(arg_77_0)
	arg_77_0.roleLv = gGameModel.role:getIdler("level")
	arg_77_0.id = gGameModel.role:getIdler("id")

	local var_77_0 = gGameModel.union

	arg_77_0.unionLv = var_77_0:getIdler("level")
	arg_77_0.unionNoticeText = var_77_0:getIdler("intro")

	local var_77_1 = gGameModel.daily_record

	arg_77_0.dailyGiftTimes = var_77_1:getIdler("union_daily_gift_times")
	arg_77_0.memberRedPacket = gGameModel.role:getIdler("union_role_packet_can_rob")
	arg_77_0.systemRedPacket = gGameModel.role:getIdler("union_sys_packet_can_rob")
	arg_77_0.contribCount = var_77_1:getIdler("union_contrib_times")
	arg_77_0.unionAllTasks = gGameModel.role:getIdler("union_contrib_tasks")
	arg_77_0.unionTasks = var_77_0:getIdler("contrib_tasks")
	arg_77_0.members = var_77_0:getIdler("members")
	arg_77_0.trainingSpeedup = var_77_1:getIdler("union_training_speedup")
	arg_77_0.unionFbTimes = var_77_1:getIdler("union_fb_times")
	arg_77_0.redPacketRobCount = var_77_1:getIdler("redPacket_rob_count")
	arg_77_0.unionRedpackets = gGameModel.role:getIdler("union_redpackets")
	arg_77_0.sendedRedPacket = gGameModel.currday_dispatch:getIdler("sendedRedPacket")
	arg_77_0.unionFragDonateStartTimes = var_77_1:getIdler("union_frag_donate_start_times")
end

function var_0_6.setTrainingRedHint(arg_78_0)
	local var_78_0 = var_0_0.canEnterBuilding("training", nil, true)
	local var_78_1 = gGameModel.union_training

	if not arg_78_0.tarinRedHintState and var_78_0 and var_78_1 then
		arg_78_0.tarinRedHintState = true

		performWithDelay(arg_78_0, function()
			gGameApp:requestServer("/game/union/training/list", function(arg_80_0)
				local var_80_0 = 0
				local var_80_1 = arg_78_0.id:read()

				for iter_80_0, iter_80_1 in ipairs(arg_80_0.view) do
					if var_80_1 ~= iter_80_1[1] and iter_80_1[2] > 0 then
						var_80_0 = var_80_0 + 1
					end
				end

				arg_78_0.opened = var_78_1:getIdler("opened")
				arg_78_0.slots = var_78_1:getIdler("slots")
				arg_78_0.trainSpeedUp = gGameModel.daily_record:getIdler("union_training_speedup")

				idlereasy.any({
					arg_78_0.opened,
					arg_78_0.slots,
					arg_78_0.trainSpeedUp,
					arg_78_0.roleLv
				}, function(arg_81_0, arg_81_1, arg_81_2, arg_81_3, arg_81_4)
					local var_81_0 = false

					if arg_81_3 < 6 and var_80_0 > 0 then
						var_81_0 = true
					end

					for iter_81_0, iter_81_1 in csvPairs(csv.union.training) do
						if arg_81_1[iter_81_0] and not arg_81_2[iter_81_0] then
							var_81_0 = true

							break
						end

						if arg_81_2[iter_81_0] and arg_81_4 <= arg_81_2[iter_81_0].level then
							var_81_0 = true

							break
						end
					end

					arg_78_0.trainingRedHint:set(var_81_0)
				end):anonyOnly(arg_78_0, "setTrainingRedHint")
			end)
		end, 0)
	end
end

function var_0_6.onBuildingClick(arg_82_0, arg_82_1)
	local var_82_0 = var_0_5[arg_82_1]

	if var_82_0 then
		var_82_0(arg_82_0)
	end
end

function var_0_6.onItemClick(arg_83_0, arg_83_1, arg_83_2, arg_83_3)
	if not arg_83_3.goTo then
		return
	end

	arg_83_0:onBuildingClick(arg_83_3.goTo)
end

return var_0_6
