local var_0_0 = {
	event = "effect",
	data = {
		outline = {
			size = 4,
			color = ui.COLORS.OUTLINE.DEFAULT
		}
	}
}
local var_0_1 = {
	event = "effect",
	data = {
		outline = {
			size = 4,
			color = ui.COLORS.QUALITY_OUTLINE[1]
		}
	}
}
local var_0_2 = 4
local var_0_3 = {
	"lv",
	"lan",
	"zi",
	"cheng"
}
local var_0_4 = require("app.views.city.adventure.mimicry.tools")
local var_0_5 = cc.load("mvc").ViewBase
local var_0_6 = class("MimicryView", var_0_5)

var_0_6.RESOURCE_FILENAME = "mimicry.json"
var_0_6.RESOURCE_BINDING = {
	["buffRightPanel.rightBuffItem"] = "rightItem",
	textField = "textField",
	rightPanel = "rightPanel",
	["leftPanel.describe"] = "describe",
	cell = "cell",
	subList = "subList",
	["buffLeftPanel.panelNobuff"] = "panelNobuff",
	bg = "bg",
	bossPanel = "bossPanel",
	["bg.panel"] = "bgPanel",
	downPanel = "downPanel",
	countPanel = "countPanel",
	animaPanel = "animaPanel",
	leftPanel = "leftPanel",
	buffLvItem = "buffLvItem",
	buffLeftPanel = "buffLeftPanel",
	["rightPanel.item"] = "item",
	buffRightPanel = "buffRightPanel",
	["rightPanel.timeText"] = {
		varname = "timeText",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.COLORS.NORMAL.DEFAULT
				}
			}
		}
	},
	["rightPanel.time"] = {
		varname = "time",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.COLORS.NORMAL.DEFAULT
				}
			}
		}
	},
	["rightPanel.battleBtn"] = {
		varname = "battleText",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBattleBtn")
			}
		}
	},
	timeOver = {
		varname = "timeOver",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.COLORS.NORMAL.DEFAULT
				}
			}
		}
	},
	["leftPanel.rankBtn.name"] = {
		binds = var_0_0
	},
	["leftPanel.ruleBtn.name"] = {
		binds = var_0_0
	},
	["leftPanel.achievement.name"] = {
		binds = var_0_0
	},
	["leftPanel.ruleBtn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleClick")
			}
		}
	},
	["leftPanel.rankBtn"] = {
		varname = "rankBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnRank")
			}
		}
	},
	["leftPanel.achievement"] = {
		varname = "achievement",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onBtnAchievement")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "mimicry",
					listenData = {
						award = true
					},
					onNode = function(arg_1_0)
						arg_1_0.xy(arg_1_0, 140, 130)
					end
				}
			}
		}
	},
	["leftPanel.describe.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.COLORS.NORMAL.DEFAULT
				}
			}
		}
	},
	["rightPanel.list"] = {
		varname = "bossList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("bossData"),
				item = bindHelper.self("item"),
				maxBossScore = bindHelper.self("maxBossScore"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					arg_2_1:get("icon"):texture(arg_2_3.cfg.cardIcon)
					arg_2_1:get("select"):visible(arg_2_3.select)
					arg_2_1:get("max"):visible(arg_2_3.csvId == arg_2_0.maxBossScore)
					bind.touch(arg_2_0, arg_2_1, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3.cfg)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onClickBtn")
			}
		}
	},
	["buffLeftPanel.buffLvList"] = {
		varname = "buffLvList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 45,
				data = bindHelper.self("buffSeleLv"),
				item = bindHelper.self("buffLvItem"),
				bossID = bindHelper.self("bossID"),
				onItem = bindHelper.self("onBuffLvListItem", true),
				onAfterBuild = function(arg_3_0)
					arg_3_0.setItemAlignCenter(arg_3_0)
				end
			},
			handlers = {
				itemClick = bindHelper.self("changeBuffQuality")
			}
		}
	},
	["buffLeftPanel.buffList"] = {
		varname = "buffList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				yMargin = 0,
				xMargin = 5,
				columnSize = 4,
				data = bindHelper.self("buffDatas"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("cell"),
				dataFilterGen = bindHelper.self("onFilterBuffs", true),
				dataOrderCmpGen = bindHelper.self("onSortBuffs", true),
				onCell = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_0:getIdx(arg_4_2)

					idlereasy.when(arg_4_0.buffsChoiceClient(), function(arg_5_0, arg_5_1)
						local var_5_0 = false

						for iter_5_0, iter_5_1 in pairs(arg_5_1 or {}) do
							if iter_5_1 == arg_4_3.id then
								var_5_0 = true

								break
							end
						end

						arg_4_1:get("markerSpace"):texture(var_5_0 and "city/adventure/mimicry/btn_ntdz_fxk1.png" or "city/adventure/mimicry/btn_ntdz_fxk2.png")
					end):anonyOnly(arg_4_0, arg_4_2)
					idlereasy.when(arg_4_0.buffShow(), function(arg_6_0, arg_6_1)
						arg_4_1:get("iconSelect"):setVisible(arg_6_1 == arg_4_3.id)
					end):anonyOnly(arg_4_0, arg_4_2)
					arg_4_1:get("iconNew"):setVisible(arg_4_3.isNew)
					arg_4_1:get("bg"):texture(string.format("city/adventure/mimicry/icon_ntdz_%s.png", var_0_3[arg_4_3.quality]))
					arg_4_1:get("buffIcon"):texture(arg_4_3.icon1)
					bind.touch(arg_4_0, arg_4_1, {
						methods = {
							ended = functools.partial(arg_4_0.clickCell, var_4_0.k, arg_4_3)
						}
					})
					bind.touch(arg_4_0, arg_4_1:get("markerSpace"), {
						methods = {
							ended = functools.partial(arg_4_0.markerClick, var_4_0.k, arg_4_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onBuffClick"),
				markerClick = bindHelper.self("onMarkerClick"),
				buffShow = bindHelper.self("buffShow"),
				buffsChoiceClient = bindHelper.self("buffsChoiceClient")
			}
		}
	},
	["buffLeftPanel.buffDescPanel.buffName"] = {
		bind = var_0_0
	},
	["buffRightPanel.bossName"] = {
		varname = "bossName",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.COLORS.NORMAL.DEFAULT
				}
			}
		}
	},
	["buffRightPanel.rightList1"] = {
		varname = "rightList1",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 14,
				data = bindHelper.self("buffSelectData1"),
				item = bindHelper.self("rightItem"),
				onItem = bindHelper.self("onBuffSelectCell", true)
			}
		}
	},
	["buffRightPanel.rightList2"] = {
		varname = "rightList2",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 14,
				data = bindHelper.self("buffSelectData2"),
				item = bindHelper.self("rightItem"),
				onItem = bindHelper.self("onBuffSelectCell", true)
			}
		}
	},
	["buffRightPanel.rightList3"] = {
		varname = "rightList3",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 14,
				data = bindHelper.self("buffSelectData3"),
				item = bindHelper.self("rightItem"),
				onItem = bindHelper.self("onBuffSelectCell", true)
			}
		}
	},
	["buffRightPanel.rightList4"] = {
		varname = "rightList4",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 14,
				data = bindHelper.self("buffSelectData4"),
				item = bindHelper.self("rightItem"),
				onItem = bindHelper.self("onBuffSelectCell", true)
			}
		}
	},
	["buffRightPanel.btnBattle"] = {
		binds = {
			event = "touch",
			clicksafe = true,
			methods = {
				ended = bindHelper.defer(function(arg_7_0)
					arg_7_0.onBtnBattle(arg_7_0)
				end)
			}
		}
	},
	["buffRightPanel.btnQuick"] = {
		varname = "btnQuick",
		binds = {
			event = "touch",
			clicksafe = true,
			methods = {
				ended = bindHelper.defer(function(arg_8_0)
					arg_8_0.onBtnBattle(arg_8_0, true)
				end)
			}
		}
	},
	["buffLeftPanel.btnReword"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnReword")
			}
		}
	},
	["buffRightPanel.btnBuffDesc"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnBuffDesc")
			}
		}
	},
	["buffRightPanel.txtTimeNum1"] = {
		varname = "num1",
		binds = var_0_1
	},
	["buffRightPanel.txtTimeNum2"] = {
		varname = "num2",
		binds = var_0_1
	},
	["buffRightPanel.txtTime1"] = {
		varname = "txtTime1",
		binds = var_0_1
	},
	["buffRightPanel.txtBuffNum"] = {
		varname = "txtBuffNum",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["buffLvItem.buffLvTxt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["bg.panel.lv"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(51, 72, 123, 255)
				}
			}
		}
	}
}

function var_0_6.onCreate(arg_9_0, arg_9_1)
	gGameUI.topuiManager:createView("default", arg_9_0, {
		onClose = arg_9_0:createHandler("onClose")
	}):init({
		subTitle = "NITAIDUIZHAN",
		title = "common/txt/txt_bt_aymy.png"
	})
	gGameModel.forever_dispatch:getIdlerOrigin("mimicryClick"):set(true)
	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_9_0.leftPanel,
			"pos",
			"left"
		},
		{
			arg_9_0.rightPanel,
			"pos",
			"right"
		},
		{
			arg_9_0.buffLeftPanel,
			"pos",
			"left"
		},
		{
			arg_9_0.buffRightPanel,
			"pos",
			"right"
		},
		{
			arg_9_0.bossPanel,
			"pos",
			"center"
		},
		{
			arg_9_0.animaPanel,
			"pos",
			"center"
		},
		{
			arg_9_0.countPanel,
			"pos",
			"center"
		}
	})
	require("app.views.city.adventure.mimicry.select_buff")(var_0_6)
	arg_9_0:initModel()
	arg_9_0:initData()

	arg_9_1 = arg_9_0:initType(arg_9_1)

	arg_9_0:battleEnd(arg_9_1)
	arg_9_0:initInterfaceUI()
	arg_9_0:initMonitor()

	arg_9_0.maxBossScore = arg_9_0:calculateMaxBossScore()

	arg_9_0:clientText()
end

function var_0_6.initModel(arg_10_0)
	arg_10_0.roleLv = gGameModel.role:getIdler("level")
	arg_10_0.mimicry = gGameModel.mimicry:read("role_db_id")
	arg_10_0.total_scores = gGameModel.mimicry:getIdler("total_scores")
	arg_10_0.history_scores = gGameModel.mimicry:getIdler("history_scores")
	arg_10_0.buffs = gGameModel.mimicry:getIdler("buffs")
	arg_10_0.buff_choice = gGameModel.mimicry:getIdler("buff_choice")
	arg_10_0.buff_field = gGameModel.mimicry:getIdler("buff_field")
	arg_10_0.battle_times = gGameModel.daily_record:getIdler("mimicry_battle_times")
end

function var_0_6.initData(arg_11_0)
	arg_11_0.maxNumber = csv.mimicry.base[1].battleTimesLimit
	arg_11_0.recoverNumber = csv.mimicry.base[1].battleTimesDailyAdd
	arg_11_0.fastChallengeThreshold = csv.mimicry.base[1].fastChallengeThreshold or 0
	arg_11_0.upBuff = false
	arg_11_0.bossData = idlers.newWithMap({})
	arg_11_0.actionAccomplish = true
	arg_11_0.buffsChoiceClient = idlertable.new({})
	arg_11_0.buffQuality = idler.new(1)
	arg_11_0.buffShow = idler.new()
	arg_11_0.buffDatas = idlers.new()
	arg_11_0.buffSeleLv = idlers.new()
	arg_11_0.buffSelectSever = {}
	arg_11_0.buffCsv = csv.mimicry.buffs
	arg_11_0.allBuffSlot = 0

	for iter_11_0 = 1, var_0_2 do
		arg_11_0[string.format("buffSelectData%s", iter_11_0)] = idlers.new()

		local var_11_0 = csv.mimicry.base[1][string.format("quality%sBuffFieldNum", iter_11_0)]

		arg_11_0.allBuffSlot = arg_11_0.allBuffSlot + var_11_0
	end
end

function var_0_6.initType(arg_12_0, arg_12_1)
	if arg_12_1.round == "prepare" then
		arg_12_1.round = "closed"
	end

	return arg_12_1
end

function var_0_6.battleEnd(arg_13_0, arg_13_1)
	if not arg_13_0.date then
		arg_13_0.date = arg_13_1
		arg_13_0.battle = false
	end
end

function var_0_6.initMonitor(arg_14_0)
	-- NOTE:
	-- initMonitor() used to call gameOver() directly, while gameOver() could call initMonitor() again.
	-- That created an infinite recursion and caused "stack overflow".
	-- Here we only register monitors / timers, and let onCreate / status changes call gameOver() safely.

	-- prevent duplicate monitor registration
	if arg_14_0.__mimicry_monitor_inited then
		return
	end
	arg_14_0.__mimicry_monitor_inited = true

	-- if UI not ready yet, just mark pending
	if not arg_14_0.start or not arg_14_0.rank or not arg_14_0.over then
		arg_14_0.__mimicry_gameover_pending = true
		return
	end

	-- initial refresh based on current status
	arg_14_0:gameOver()
end

function var_0_6.initInterfaceUI(arg_17_0)
	local var_17_0

	var_17_0 = arg_17_0.date.round ~= "start" and "effect_hudun_loop" or "effect_chushi_loop"

	arg_17_0.animaPanel:removeAllChildren()

	if arg_17_0.date.round ~= "start" then
		arg_17_0.bossPanel:removeAllChildren()
	end

	local var_17_1 = cc.Sprite:create("city/adventure/mimicry/img_ntdz_bg.jpg"):xy(arg_17_0.animaPanel:size().width / 2, arg_17_0.animaPanel:size().height / 2):setScale(2)

	arg_17_0.animaPanel:addChild(var_17_1)
	text.addEffect(arg_17_0.battleText:get("txt"), {
		glow = {
			color = cc.c4b(255, 71, 0, 255)
		}
	})
	arg_17_0.downPanel:xy(display.sizeInView.width / 2 + 630, display.sizeInView.height / 2 - 410)
	arg_17_0.rightPanel:get("battleBtn"):x(-display.sizeInView.width / 2 + 600)
	arg_17_0.countPanel:x(display.sizeInView.width / 2 + 630)
	arg_17_0.buffLeftPanel:get("txtNo"):text(gLanguageCsv.mimicryNoBuff)

	if arg_17_0.battle then
		arg_17_0.recoverPosition(arg_17_0)
	end
	-- apply pending gameOver state if any
	if self.__mimicry_gameover_pending then
		self:gameOver()
	end

end

function var_0_6.recoverPosition(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0.battle and 1000 or -1000

	if not arg_18_1 then
		arg_18_0.leftPanel:x(arg_18_0.leftPanel:x() - var_18_0)
	end

	arg_18_0.rightPanel:x(arg_18_0.rightPanel:x() + var_18_0)

	local var_18_1 = arg_18_0.battle and 1400 or -1400

	arg_18_0.buffLeftPanel:x(arg_18_0.buffLeftPanel:x() + var_18_1)
	arg_18_0.buffLeftPanel:visible(arg_18_0.battle)

	local var_18_2 = arg_18_0.battle and -900 or 900

	arg_18_0.buffRightPanel:x(arg_18_0.buffRightPanel:x() + var_18_2)
	arg_18_0.buffRightPanel:visible(arg_18_0.battle)

	for iter_18_0 = 1, 4 do
		arg_18_0.downPanel:get("bg" .. iter_18_0):visible(not arg_18_0.battle)
		arg_18_0.downPanel:get("icon" .. iter_18_0):opacity(arg_18_0.battle and 0 or 255)
	end

	local var_18_3 = arg_18_0.battle and 500 or -530
	local var_18_4 = arg_18_0.battle and 255 or 0

	arg_18_0.bgPanel:x(arg_18_0.bgPanel:x() + var_18_3)
	arg_18_0.bg:get("panel.progressBarBg"):visible(arg_18_0.battle)
	arg_18_0.bg:get("panel.mask.progressBar"):visible(arg_18_0.battle)
	arg_18_0.bg:get("panel.lv"):opacity(var_18_4)
	arg_18_0.bg:get("panel.mask.progressBar"):opacity(var_18_4)
	arg_18_0.bg:get("panel.progressBarBg"):opacity(var_18_4)

	if arg_18_0.battle and arg_18_0.cardSprite then
		arg_18_0.rightPanel:get("battleBtn"):visible(false)
	else
		arg_18_0.bossPanel:removeAllChildren()
	end

	if arg_18_0.countPanel:get("richText") then
		arg_18_0.countPanel:get("richText"):hide()
	end
end

function var_0_6.calculateMaxBossScore(arg_19_0)
	local var_19_0 = (arg_19_0.history_scores and arg_19_0.history_scores.read and arg_19_0.history_scores:read()) or {}
	local var_19_1
	local var_19_2

	for iter_19_0, iter_19_1 in pairs(var_19_0 or {}) do
		if iter_19_1 > 0 and (not var_19_1 or var_19_1 < iter_19_1) then
			var_19_1 = iter_19_1
			var_19_2 = iter_19_0
		end
	end

	return var_19_2
end

function var_0_6.onClickBtn(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	arg_20_0.showTab:set(arg_20_2)

	arg_20_0.selectBossId = arg_20_2
end

function var_0_6.selectBossUpdateUi(arg_21_0, arg_21_1, arg_21_2)
	arg_21_0.describe:get("list"):removeAllChildren()

	local var_21_0 = arg_21_0.date.bosses[arg_21_1]
	local var_21_1 = csv.mimicry.boss[arg_21_1]
	local var_21_2 = csv.mimicry.boss_limit[var_21_0]

	var_0_4.bossType(var_21_2, var_21_1, function(arg_22_0)
		beauty.textScroll({
			fontSize = 48,
			isRich = true,
			list = arg_21_0.describe:get("list"),
			strs = "#C0x5B545B#" .. arg_22_0
		})
	end)
	arg_21_0.describe:get("name"):text(var_21_1.gateName)
	arg_21_0.describe:get("score"):text(arg_21_0.total_scores:read()[arg_21_1] or 0)
	arg_21_0.describe:get("max"):text(arg_21_0.history_scores:read()[arg_21_1] or 0)
	adapt.oneLinePos(arg_21_0.describe:get("maxTitle"), arg_21_0.describe:get("max"), cc.p(2, 0))
	adapt.oneLinePos(arg_21_0.describe:get("scoreTitle"), arg_21_0.describe:get("score"), cc.p(2, 0))

	local var_21_3 = csv.unit[var_21_1.bossID]

	arg_21_0.bossPanel:setTouchEnabled(true)
	arg_21_0.bossPanel:removeAllChildren()

	local var_21_4 = 0.8

	arg_21_0.cardSprite = widget.addAnimation(arg_21_0.bossPanel, var_21_3.unitRes, "standby_loop", 2):scale(-var_21_3.scale * var_21_1.scale * var_21_4, var_21_3.scale * var_21_1.scale * var_21_4):xy(arg_21_0.bossPanel:size().width / 2 + 600, arg_21_0.bossPanel:size().height / 2 - 200)

	local var_21_5 = var_21_1.word

	bind.click(arg_21_0, arg_21_0.bossPanel, {
		method = functools.partial(arg_21_0.onClickAnima, arg_21_0, var_21_5)
	})

	for iter_21_0 = 1, 4 do
		local var_21_6 = arg_21_0.downPanel:get("icon" .. iter_21_0)
		local var_21_7 = csv.mimicry.boss[arg_21_1].skillIcon

		arg_21_0.downPanel:get("bg" .. iter_21_0):y(0)
		var_21_6:y(0)
		var_21_6:texture(var_21_7[iter_21_0])
		var_21_6:scale(1.15)
	end

	local var_21_8 = arg_21_0.total_scores:read()[arg_21_1] or 0

	if not dataEasy.isUnlock(gUnlockCsv.mimicryPass) or var_21_8 < arg_21_0.fastChallengeThreshold then
		arg_21_0.btnQuick:hide()
	else
		arg_21_0.btnQuick:show()
	end
end

function var_0_6.onClickAnima(arg_23_0, arg_23_1)
	local var_23_0 = 240
	local var_23_1 = rich.createWithWidth("#C0x5b545b#" .. arg_23_1, 40, nil, var_23_0):anchorPoint(0.5, 0):xy(arg_23_0.bossPanel:size().width / 2 + 400, arg_23_0.bossPanel:size().height / 2 + 200):addTo(arg_23_0.bossPanel, 3, "talkContent"):size()
	local var_23_2 = ccui.Scale9Sprite:create()

	var_23_2:initWithFile(cc.rect(75, 59, 1, 1), "city/gate/bg_dialog.png")
	var_23_2:size(var_23_1.width + 60, var_23_1.height + 60):anchorPoint(0.5, 0)
	var_23_2:xy(arg_23_0.bossPanel:size().width / 2 + 400, arg_23_0.bossPanel:size().height / 2 + 160)
	var_23_2:scaleX(-1)
	var_23_2:addTo(arg_23_0.bossPanel, 2, "talkBg")
	arg_23_0.bossPanel:setTouchEnabled(false)
	performWithDelay(arg_23_0.bossPanel, function()
		arg_23_0:deleteShowTip()
	end, 2)
end

function var_0_6.deleteShowTip(arg_25_0)
	if arg_25_0.bossPanel:get("talkContent") then
		arg_25_0.bossPanel:removeChildByName("talkContent")
	end

	if arg_25_0.bossPanel:get("talkBg") then
		arg_25_0.bossPanel:removeChildByName("talkBg")
	end

	arg_25_0.bossPanel:setTouchEnabled(not arg_25_0.battle)
end

function var_0_6.setViewAction(arg_26_0)
	local function var_26_0()
		local var_27_0 = arg_26_0.battle and -1000 or 1000

		transition.executeSequence(arg_26_0.leftPanel):moveBy(0.4, var_27_0, 0):done()
		transition.executeSequence(arg_26_0.rightPanel):moveBy(0.4, -var_27_0, 0):done()
	end

	local function var_26_1()
		transition.executeSequence(arg_26_0.buffLeftPanel):moveBy(0.4, arg_26_0.battle and 1400 or -1400, 0):func(function()
			arg_26_0.buffLeftPanel:visible(arg_26_0.battle)

			local var_29_0 = 3

			if not gGameUI.guideManagerLocal:checkFinished(var_29_0) then
				arg_26_0.buffQuality:set(1)
				gGameUI.guideManagerLocal:checkGuide({
					specialName = "mimicry"
				})
			end
		end):done()
		transition.executeSequence(arg_26_0.buffRightPanel):moveBy(0.4, arg_26_0.battle and -900 or 900, 0):func(function()
			arg_26_0.buffRightPanel:visible(arg_26_0.battle)
		end):done()
	end

	local function var_26_2()
		for iter_31_0 = 1, 4 do
			local var_31_0 = arg_26_0.downPanel:get("icon" .. iter_31_0)
			local var_31_1 = arg_26_0.downPanel:get("bg" .. iter_31_0)

			if arg_26_0.battle then
				transition.executeSequence(var_31_0):func(function()
					var_31_1:hide()
				end):fadeOut(0.3):done()
			else
				transition.executeSequence(var_31_0):fadeIn(0.3):func(function()
					var_31_1:show()

					arg_26_0.actionAccomplish = true
				end):done()
			end
		end
	end

	local function var_26_3()
		local var_34_0 = arg_26_0.bg:get("panel.progressBarBg")
		local var_34_1 = arg_26_0.bg:get("panel.mask.progressBar")
		local var_34_2 = arg_26_0.bg:get("panel.lv")

		if arg_26_0.battle then
			arg_26_0.bgPanel:x(1780)
			transition.executeSequence(var_34_0):fadeIn(0.3):done()
			transition.executeSequence(var_34_1):fadeIn(0.3):func(function()
				var_34_1:opacity(255)
			end):done()
			transition.executeSequence(var_34_2):fadeIn(0.3):done()
		else
			transition.executeSequence(var_34_0):fadeOut(0.3):done()
			transition.executeSequence(var_34_1):fadeOut(0.3):done()
			transition.executeSequence(var_34_2):fadeOut(0.3):func(function()
				arg_26_0.bgPanel:x(1280)
			end):done()
		end
	end

	local function var_26_4()
		performWithDelay(arg_26_0, function()
			if arg_26_0.battle then
				arg_26_0.rightPanel:get("battleBtn"):visible(false)

				arg_26_0.actionAccomplish = true
			else
				arg_26_0.rightPanel:get("battleBtn"):visible(true)
			end
		end, 0.03)
	end

	arg_26_0.actionAccomplish = false

	if arg_26_0.battle then
		arg_26_0:deleteShowTip()
		var_26_0()
		arg_26_0.countPanel:hide()
		performWithDelay(arg_26_0, function()
			arg_26_0.buffLeftPanel:show()
			arg_26_0.buffRightPanel:show()
			var_26_2()
			performWithDelay(arg_26_0, function()
				var_26_1()
				var_26_4()
			end, 0.15)
		end, 0.4)
	else
		arg_26_0.bossPanel:setTouchEnabled(true)
		var_26_1()
		var_26_3()
		performWithDelay(arg_26_0, function()
			var_26_0()
			var_26_4()
			performWithDelay(arg_26_0, function()
				var_26_2()
				arg_26_0.countPanel:show()
			end, 0.4)
		end, 0.4)
	end
end

function var_0_6.onBtnRank(arg_43_0)
	if arg_43_0.date.round ~= "start" then
		gGameUI:showTip(gLanguageCsv.pleaseWaitOpen)

		return
	end

	local var_43_0 = 30

	gGameApp:requestServer("/game/cross/mimicry/rank", function(arg_44_0)
		gGameUI:stackUI("city.adventure.mimicry.rank", nil, nil, arg_44_0.view, var_43_0)
	end, 0, var_43_0)
end

function var_0_6.onBtnAchievement(arg_45_0)
	if arg_45_0.date.round ~= "start" then
		gGameUI:showTip(gLanguageCsv.pleaseWaitOpen)

		return
	end

	gGameUI:stackUI("city.adventure.mimicry.achievement", nil, nil, arg_45_0.date.version)
end

function var_0_6.onBossSkillDesc(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	local var_46_0 = arg_46_0.bossID:read()
	local var_46_1 = csv.mimicry.boss[var_46_0]
	local var_46_2 = var_46_1.bossID
	local var_46_3 = arg_46_1 == 1 and csv.unit[var_46_2].passiveSkillList[arg_46_1] or csv.unit[var_46_2].skillList[arg_46_1 - 1]

	if arg_46_0.battle or not var_46_3 then
		return
	end

	local var_46_4 = gGameUI:stackUI("common.skill_detail", nil, {
		clickClose = true,
		dispatchNodes = arg_46_3
	}, {
		ignoreStar = false,
		hideSkillLevel = false,
		skillLevel = 1,
		skillId = var_46_3,
		skillIcon = var_46_1.skillIcon[arg_46_1]
	})
	local var_46_5 = var_46_4:getResourceNode()
	local var_46_6, var_46_7 = var_46_5:xy()

	var_46_5:xy(var_46_6 + arg_46_2:x() + 295, var_46_4.panel:y() - 70)
end

function var_0_6.onBattleBtn(arg_47_0)
	if not arg_47_0.actionAccomplish then
		return
	end

	arg_47_0.battle = not arg_47_0.battle

	if arg_47_0.countPanel:get("richText") then
		arg_47_0.countPanel:get("richText"):show()
	end

	arg_47_0.setViewAction(arg_47_0)
end

function var_0_6.updateTime(arg_48_0, arg_48_1, arg_48_2)
	local var_48_0 = arg_48_2 == "start" and arg_48_0.time or arg_48_0.timeOver

	bind.extend(arg_48_0, var_48_0, {
		class = "cutdown_label",
		props = {
			endTime = arg_48_1,
			strFunc = function(arg_49_0)
				if arg_48_2 == "start" then
					var_48_0:text(arg_49_0.str)
					adapt.oneLinePos(arg_48_0.timeText, var_48_0, cc.p(2, 0))
				else
					var_48_0:text(string.format(gLanguageCsv.bcActivityNextTime, arg_49_0.str))
				end
			end,
			endFunc = function()
				gGameApp:requestServer("/game/mimicry/main", function(arg_51_0)
					if arg_51_0.view.round == arg_48_0.date.round then
						arg_48_0:updateTime(5 + time.getTime(), arg_51_0.view.round)
					else
						arg_48_0.date = arg_51_0.view

						if arg_48_0.date.round == "prepare" then
							arg_48_0.date.round = "closed"
						end

						arg_48_0:gameOver(true)
					end
				end)
			end
		}
	})
end

function var_0_6.deleteSaveDate(arg_52_0)
	userDefault.setForeverLocalKey("mimicryRoleBuff", nil)
	userDefault.setForeverLocalKey("mimicryNewBuffs", nil)
	userDefault.setForeverLocalKey("mimicryBattleCard", nil)
end

function var_0_6.gameOver(arg_53_0, arg_53_1)
	-- safe gameOver: no re-init, no recursive calls
	local tb = arg_53_1
	if tb == nil and arg_53_0.date and arg_53_0.date.read then
		local ok, ret = pcall(function()
			return arg_53_0.date:read()
		end)
		if ok then tb = ret end
	end
	if type(tb) ~= "table" then
		tb = {}
	end

	local status = tb.status or "closed"
	local isStart = (status == "start")
	local isClosed = (status == "closed")

	-- UI may not be ready when initMonitor triggers gameOver
	if not arg_53_0.start or not arg_53_0.rank or not arg_53_0.over then
		arg_53_0.__mimicry_gameover_pending = true
		return
	end

	-- clear saved data only once when closed
	if isClosed and not arg_53_0.__mimicry_saved_cleared then
		arg_53_0.__mimicry_saved_cleared = true
		if arg_53_0.deleteSaveDate then
			pcall(function()
				arg_53_0:deleteSaveDate()
			end)
		end
	end

	-- toggle panels
	arg_53_0.start:visible(isStart)
	arg_53_0.rank:visible(false)
	arg_53_0.over:visible(not isStart)

	arg_53_0.__mimicry_gameover_pending = nil
end

function var_0_6.onRuleClick(arg_54_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_54_0:createHandler("getRuleContext"))
end

function var_0_6.getRuleContext(arg_55_0, arg_55_1)
	local var_55_0 = csv.mimicry.base[1].rankingRequiredOpenDays
	local var_55_1 = adaptContext
	local var_55_2 = {
		var_55_1.clone(arg_55_1.title, function(arg_56_0)
			arg_56_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_55_1.noteText(128301, 128320),
		string.format(csv.note[128321].fmt, var_55_0),
		var_55_1.noteText(128322)
	}
	local var_55_3 = 0

	for iter_55_0, iter_55_1 in orderCsvPairs(csv.mimicry.rank_award) do
		table.insert(var_55_2, var_55_1.clone(arg_55_1.awardItem, function(arg_57_0)
			local var_57_0 = arg_57_0.multiget(arg_57_0, "text", "list")

			if iter_55_1.rankMax - var_55_3 == 1 then
				var_57_0.text:text(string.format(gLanguageCsv.rankSingle, iter_55_1.rankMax))
			else
				var_57_0.text:text(string.format(gLanguageCsv.rankMulti, var_55_3 + 1, iter_55_1.rankMax))
			end

			uiEasy.createItemsToList(arg_55_1, var_57_0.list, iter_55_1.award)

			var_55_3 = iter_55_1.rankMax
		end))
	end

	return var_55_2
end

function var_0_6.onClose(arg_58_0)
	if arg_58_0.battle then
		functools.partial()
		arg_58_0.saveBuffs(arg_58_0, function()
			arg_58_0:onBattleBtn()
		end)
	else
		var_0_5.onClose(arg_58_0)
	end
end

function var_0_6.clientText(arg_60_0)
	arg_60_0.textField:setVisible(false)

	arg_60_0.testBtn = false

	arg_60_0:addTestButtons()
	blacklist:addListener(arg_60_0.textField, "*", function(arg_61_0)
		arg_60_0.battleNum = arg_61_0

		print("....挑战次数", arg_61_0)
	end)
end

function var_0_6.addTestButtons(arg_62_0)
	if not EDITOR_ENABLE then
		return
	end

	local function var_62_0(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
		arg_63_3 = arg_63_3 or {}

		local var_63_0 = ccui.Button:create("img/editor/btn.png")

		var_63_0:setPosition(arg_63_0)
		var_63_0:setScale(1)
		var_63_0:setTitleFontSize(arg_63_3.fontSize or 40)
		var_63_0:setTitleText(arg_63_1)
		arg_62_0:getResourceNode():addChild(var_63_0, 100)
		var_63_0:onClick(arg_63_2)
	end

	local var_62_1 = 350

	var_62_0(cc.p(150 + display.sizeInViewRect.x - display.uiOrigin.x, var_62_1), "score", function()
		arg_62_0.testBtn = not arg_62_0.testBtn

		arg_62_0.textField:setVisible(arg_62_0.testBtn)
		gGameUI:showTip("now is " .. (arg_62_0.testBtn and "open" or "close"))
	end)
end

return var_0_6
