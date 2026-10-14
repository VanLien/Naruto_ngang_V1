local var_0_0 = require("app.views.city.pvp.craft.battle_messages"):getInstance()
local var_0_1 = -1
local var_0_2 = 10
local var_0_3 = csv.unlock[gUnlockCsv.craft].startLevel
local var_0_4 = {
	final = 300,
	pre = 240,
	prepare = 600
}

local function var_0_5(arg_1_0)
	local var_1_0 = 0

	if string.find(arg_1_0, "prepare") then
		var_1_0 = var_0_4.prepare
	elseif string.find(arg_1_0, "pre") then
		var_1_0 = var_0_4.pre
	elseif string.find(arg_1_0, "final") then
		var_1_0 = var_0_4.final
	end

	return var_1_0 + 1
end

local var_0_6 = string.find

local function var_0_7(arg_2_0)
	return var_0_6(arg_2_0, "_lock") ~= nil
end

local function var_0_8(arg_3_0)
	return arg_3_0 == "over" or arg_3_0 == "closed"
end

local function var_0_9(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	for iter_4_0, iter_4_1 in ipairs(arg_4_1) do
		local var_4_0 = arg_4_0.item:get(iter_4_1):x()

		arg_4_3[iter_4_1]:x(var_4_0 + arg_4_0.deltaWidth / arg_4_2 - 10)
	end
end

local function var_0_10(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_1:size()

	arg_5_1:size(var_5_0.width + arg_5_0.deltaWidth, var_5_0.height)

	local var_5_1 = arg_5_1:get("imgBg"):size()

	arg_5_1:get("imgBg"):size(1188 + arg_5_0.deltaWidth / 2, var_5_1.height)
	arg_5_1:get("imgBg"):x((2376 + arg_5_0.deltaWidth) / 2 + 20)
	arg_5_0:enableSchedule()
	arg_5_0:unSchedule(arg_5_2)
	arg_5_1:removeChildByName("_leftIcon")
	arg_5_1:removeChildByName("_rightIcon")

	local var_5_2 = arg_5_1:multiget("imgResultL", "imgResultR", "imgIconL", "imgIconR", "imgHeroL", "imgHeroR", "textLvLeft", "textLvRight", "textNameLeft", "textNameRight", "textNoteLeft", "textNoteRight", "textFightPointL", "textFightPointR", "btnShowInfoL", "btnShowInfoR", "imgTitle", "imgBox", "btnReplay", "textTimeNote", "textTime", "leftIconEight1", "leftIconEight2", "leftIconEight3", "rightIconEight1", "rightIconEight2", "rightIconEight3", "imgTimeBg", "textLK", "righttouxiang1", "righttouxiang2", "righttouxiang3")

	if arg_5_3.round == "out" then
		local var_5_3 = (2376 + arg_5_0.deltaWidth) / 2
		local var_5_4 = 57.5

		arg_5_1:get("imgBg"):texture("city/pvp/craft/myschedule/bg_wdsc.png")
		arg_5_1:size(cc.size(var_5_0.width + arg_5_0.deltaWidth, 115))
		arg_5_1:get("imgBg"):size(1188 + arg_5_0.deltaWidth / 2, 57)
		arg_5_1:get("imgBg"):xy(var_5_3, var_5_4)
		itertools.invoke(var_5_2, "hide")
		arg_5_1:get("textResult"):text(arg_5_3.str)
		arg_5_1:get("textResult"):xy(var_5_3, var_5_4)
		arg_5_1:get("textResult"):show()

		return
	end

	cache.setShader(var_5_2.imgHeroR, false, "normal")
	cache.setShader(var_5_2.imgHeroL, false, "normal")

	local var_5_5 = {
		"imgResultR",
		"imgIconR",
		"imgHeroR",
		"textLvRight",
		"textNameRight",
		"textNoteRight",
		"textFightPointR",
		"btnShowInfoR",
		"rightIconEight1",
		"rightIconEight2",
		"rightIconEight3"
	}
	local var_5_6 = {
		"imgBox",
		"imgTitle",
		"btnReplay",
		"textTimeNote",
		"textTime"
	}

	var_0_9(arg_5_0, var_5_5, 1, var_5_2)
	var_0_9(arg_5_0, var_5_6, 2, var_5_2)
	var_5_2.imgTitle:hide()

	if arg_5_3.path then
		var_5_2.imgTitle:texture(arg_5_3.path)
		var_5_2.imgTitle:show()
	end

	var_5_2.textFightPointL:text(arg_5_3.fighting_point)
	var_5_2.textNameLeft:text(arg_5_0.roleName)
	var_5_2.textLvLeft:text("lv" .. arg_5_0.level)
	text.addEffect(var_5_2.textLvLeft, {
		outline = {
			color = cc.c4b(153, 46, 82, 255)
		}
	})
	text.addEffect(var_5_2.textNameLeft, {
		outline = {
			color = cc.c4b(153, 46, 82, 255)
		}
	})
	text.addEffect(var_5_2.textNoteLeft, {
		outline = {
			color = cc.c4b(153, 46, 82, 255)
		}
	})
	text.addEffect(var_5_2.textFightPointL, {
		outline = {
			color = cc.c4b(153, 46, 82, 255)
		}
	})
	text.addEffect(var_5_2.textLvRight, {
		outline = {
			color = cc.c4b(31, 92, 153, 255)
		}
	})
	text.addEffect(var_5_2.textNameRight, {
		outline = {
			color = cc.c4b(31, 92, 153, 255)
		}
	})
	text.addEffect(var_5_2.textNoteRight, {
		outline = {
			color = cc.c4b(31, 92, 153, 255)
		}
	})
	text.addEffect(var_5_2.textFightPointR, {
		outline = {
			color = cc.c4b(31, 92, 153, 255)
		}
	})
	text.addEffect(var_5_2.textLK, {
		outline = {
			color = cc.c4b(31, 92, 153, 255)
		}
	})

	local var_5_7 = gRoleFigureCsv
	local var_5_8 = csv.unit
	local var_5_9 = csv.cards
	local var_5_10 = var_5_7[arg_5_0.figure]
	local var_5_11, var_5_12 = var_5_2.imgIconL:xy()
	local var_5_13 = cc.Sprite:create(var_5_10.res):anchorPoint(0.5, 1):xy(var_5_11, var_5_12):scale(0.7):addTo(arg_5_1, 2, "_leftIcon"):size()

	var_5_2.imgIconL:hide()

	local var_5_14 = "city/pvp/craft/vs.png"
	local var_5_15 = string.find(arg_5_3.round, "final") ~= nil

	var_5_2.imgHeroL:visible(not var_5_15)
	var_5_2.imgHeroR:visible(not var_5_15)

	for iter_5_0 = 1, 3 do
		var_5_2["leftIconEight" .. iter_5_0]:visible(var_5_15)
		var_5_2["rightIconEight" .. iter_5_0]:visible(var_5_15)
	end

	local var_5_16, var_5_17 = var_5_2.imgIconR:xy()

	var_5_2.imgIconR:hide()

	local function var_5_18(arg_6_0)
		arg_6_0 = arg_6_0 or "config/big_role/show/img_21.png"

		local var_6_0 = cc.Sprite:create(arg_6_0):anchorPoint(0.5, 1):xy(var_5_16, var_5_17):scale(0.7):addTo(arg_5_1, 2, "_rightIcon")
		local var_6_1 = var_6_0:size()

		return var_6_0
	end

	local function var_5_19()
		var_5_2.textFightPointR:text(arg_5_3.enemy.fighting_point)
		var_5_2.textLvRight:text("lv" .. math.max(var_0_3, arg_5_3.enemy.level))
		var_5_2.textNameRight:text(arg_5_3.enemy.name)
	end

	local function var_5_20()
		var_5_2.textLvRight:text("???")
		var_5_2.textNameRight:text(gLanguageCsv.whoIsMe)
	end

	local var_5_21 = not itertools.isempty(arg_5_3.enemy)

	var_5_2.textFightPointR:visible(var_5_21)
	var_5_2.textNoteRight:visible(var_5_21)
	var_5_2.btnShowInfoR:visible(var_5_21)
	var_5_2.textLK:visible(not var_5_21)
	var_5_2.textLK:x(var_5_2.rightIconEight2:x())

	if arg_5_0.round:read() == "prepare" then
		var_5_2.textLK:hide()
	end

	if not var_5_15 then
		local var_5_22 = var_5_8[dataEasy.getUnitId(arg_5_3.cards[1][2], arg_5_3.cards[1][3])].cardIcon2

		var_5_2.imgHeroL:texture(var_5_22):scale(1.9)

		if var_5_21 then
			var_5_19()

			local var_5_23 = var_5_8[dataEasy.getUnitId(arg_5_3.enemy.cards[1][2], arg_5_3.enemy.cards[1][3])].cardIcon2

			var_5_2.imgHeroR:setColor(cc.c3b(255, 255, 255))
			var_5_2.imgHeroR:setOpacity(255)
			var_5_2.imgHeroR:texture(var_5_23):scale(1.9)
			var_5_18(var_5_7[arg_5_3.enemy.figure].res)
		else
			var_5_20()
			var_5_2.imgHeroR:texture("config/portrait/jinglingtouxiang2/img_21.png")
			var_5_2.imgHeroR:setColor(cc.c3b(0, 0, 0))
			var_5_2.imgHeroR:setOpacity(125)

			local var_5_24 = var_5_18()

			var_5_24:setColor(cc.c3b(0, 0, 0))
			var_5_24:setOpacity(125)
		end
	else
		var_5_14 = "city/pvp/craft/icon_pk.png"

		for iter_5_1, iter_5_2 in ipairs(arg_5_3.cards) do
			local var_5_25 = dataEasy.getUnitCsv(iter_5_2[2], iter_5_2[3]).iconSimple

			var_5_2["leftIconEight" .. iter_5_1]:texture(var_5_25)
		end

		if not itertools.isempty(arg_5_3.enemy) then
			var_5_19()
			var_5_18(var_5_7[arg_5_3.enemy.figure].res)

			for iter_5_3, iter_5_4 in ipairs(arg_5_3.enemy.cards) do
				local var_5_26 = dataEasy.getUnitCsv(iter_5_4[2], iter_5_4[3]).iconSimple

				var_5_2["rightIconEight" .. iter_5_3]:setColor(cc.c3b(255, 255, 255))
				var_5_2["rightIconEight" .. iter_5_3]:setOpacity(255)
				var_5_2["rightIconEight" .. iter_5_3]:texture(var_5_26)
			end
		else
			var_5_20()

			for iter_5_5 = 1, 3 do
				var_5_2["rightIconEight" .. iter_5_5]:setColor(cc.c3b(0, 0, 0))
				var_5_2["rightIconEight" .. iter_5_5]:setOpacity(125)
			end

			local var_5_27 = var_5_18()

			var_5_27:setColor(cc.c3b(0, 0, 0))
			var_5_27:setOpacity(125)
		end
	end

	text.addEffect(var_5_2.textTimeNote, {
		outline = {
			color = cc.c4b(242, 48, 81, 255)
		}
	})
	text.addEffect(var_5_2.textTime, {
		outline = {
			color = cc.c4b(46, 77, 229, 255)
		}
	})
	var_5_2.imgResultL:hide()
	var_5_2.imgResultR:hide()

	local var_5_28 = "city/pvp/craft/icon_box_vs1.png"

	if arg_5_3.result then
		local var_5_29 = "city/pvp/craft/icon_lose.png"
		local var_5_30 = "city/pvp/craft/icon_win.png"
		local var_5_31 = var_5_15 and "leftIconEight" or var_5_2.imgHeroL

		if arg_5_3.result == "win" then
			var_5_29, var_5_30 = var_5_30, var_5_29
			var_5_31 = var_5_15 and "rightIconEight" or var_5_2.imgHeroR
			var_5_28 = "city/pvp/craft/icon_box_vs2.png"
		end

		var_5_2.imgResultL:texture(var_5_29)
		var_5_2.imgResultR:texture(var_5_30)
		var_5_2.imgResultL:show()
		var_5_2.imgResultR:show()

		if var_5_15 then
			for iter_5_6 = 1, 3 do
				cache.setShader(var_5_2[var_5_31 .. iter_5_6], false, "hsl_gray_white")
			end
		else
			cache.setShader(var_5_31, false, "hsl_gray_white")
		end
	end

	local var_5_32 = true
	local var_5_33, var_5_34 = string.find(arg_5_0.round:read(), "^pre%d+")
	local var_5_35, var_5_36 = string.find(arg_5_0.round:read(), "^final%d+")

	if not var_5_33 and not var_5_35 and not arg_5_0.isRecord:read() then
		var_5_32 = false
	elseif var_5_33 then
		var_5_32 = string.sub(arg_5_0.round:read(), var_5_33, var_5_34) ~= arg_5_3.round
	elseif var_5_35 then
		var_5_32 = string.sub(arg_5_0.round:read(), var_5_35, var_5_36) ~= arg_5_3.round
	end

	var_5_2.btnReplay:visible(var_5_21 and var_5_32)
	var_5_2.textTimeNote:visible(not var_5_32)
	var_5_2.textTime:visible(not var_5_32)
	var_5_2.imgTimeBg:visible(not var_5_32)

	if var_5_32 then
		var_5_2.imgBox:texture(var_5_28)
		var_5_2.imgBox:scale(1.12)
	else
		local var_5_37 = gLanguageCsv.stateReady

		if arg_5_0.round:read() == "prepare" then
			var_5_37 = gLanguageCsv.countTime
		elseif string.find(arg_5_0.round:read(), "_lock") then
			var_5_37 = gLanguageCsv.stateFighting
		end

		var_5_2.textTimeNote:text(var_5_37)
		var_5_2.imgBox:texture(var_5_14)
		var_5_2.imgBox:scale(1)

		local var_5_38 = var_0_5(arg_5_3.round)
		local var_5_39 = 0

		local function var_5_40()
			if time.getTime() - var_5_39 > var_0_2 then
				var_5_39 = time.getTime()

				gGameApp:requestServer("/game/craft/battle/main")

				return true
			end
		end

		local function var_5_41(arg_10_0)
			local var_10_0 = arg_5_0.round:read()

			if arg_10_0 > 60 and var_10_0 ~= "prepare" then
				arg_10_0 = arg_10_0 - 60

				var_5_2.textTimeNote:text(gLanguageCsv.stateReady)
			elseif arg_10_0 <= 60 and var_10_0 ~= "prepare" then
				var_5_2.textTimeNote:text(gLanguageCsv.stateFighting)
			end

			local var_10_1 = time.getCutDown(arg_10_0)

			var_5_2.textTime:text(var_10_1.min_sec_clock)
		end

		local var_5_42 = arg_5_3.showTime + var_5_38 - time.getTime()

		var_5_41(var_5_42)
		arg_5_0:schedule(function()
			local var_11_0 = arg_5_3.showTime + var_5_38 - time.getTime()
			local var_11_1 = arg_5_0.round:read()

			if arg_5_3.round ~= var_11_1 and not string.find(var_11_1, arg_5_3.round) then
				return false
			end

			if var_11_0 < 0 then
				if var_5_40() then
					return false
				end
			else
				var_5_41(var_11_0)
			end
		end, 1, 0, arg_5_2)
	end

	local var_5_43 = string.find(arg_5_3.round, "pre")
	local var_5_44 = 1

	if not var_5_43 then
		var_5_44 = 2
	end

	bind.touch(arg_5_0, var_5_2.btnReplay, {
		methods = {
			ended = functools.partial(arg_5_0.clickCell, arg_5_2, arg_5_3)
		}
	})
	bind.click(arg_5_0, var_5_2.btnShowInfoL, {
		method = functools.partial(arg_5_0.showMyInfo, arg_5_2, arg_5_3, var_5_44, string.find(arg_5_0.round:read(), "_lock"))
	})
	bind.click(arg_5_0, var_5_2.btnShowInfoR, {
		method = functools.partial(arg_5_0.showEnemyInfo, arg_5_2, arg_5_3, var_5_44, string.find(arg_5_0.round:read(), "_lock"))
	})
end

local var_0_11 = cc.load("mvc").ViewBase
local var_0_12 = class("CraftMyScheduleView", var_0_11)

var_0_12.RESOURCE_FILENAME = "craft_schedule.json"
var_0_12.RESOURCE_BINDING = {
	["topLeftPanel.textNote2"] = "textNote2",
	roleItem = "roleItem",
	slider = "slider",
	["topLeftPanel.textNote1"] = "textNote1",
	item = "item",
	["item.btnReplay.textNote"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.NEWCOLORS.OUTLINE.BROWN1,
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["topLeftPanel.textContent"] = {
		varname = "textContent",
		binds = {
			event = "text",
			idler = bindHelper.self("winAndloseNum")
		}
	},
	["topLeftPanel.textNum"] = {
		varname = "textNum",
		binds = {
			event = "text",
			idler = bindHelper.self("pointNum")
		}
	},
	list = {
		varname = "speList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				backupCached = false,
				data = bindHelper.self("fightDatas"),
				item = bindHelper.self("item"),
				sliderBg = bindHelper.self("slider"),
				level = bindHelper.self("level"),
				roleName = bindHelper.self("roleName"),
				figure = bindHelper.self("figure"),
				roleItem = bindHelper.self("roleItem"),
				round = bindHelper.self("round"),
				isRecord = bindHelper.self("isRecord"),
				deltaWidth = bindHelper.self("deltaWidth"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
					var_0_10(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				end,
				onBeforeBuild = function(arg_13_0)
					if arg_13_0.sliderBg:visible() then
						local var_13_0 = arg_13_0:size()
						local var_13_1, var_13_2 = arg_13_0:xy()
						local var_13_3 = arg_13_0.sliderBg:size()

						arg_13_0.sliderBg:x(var_13_1 + var_13_0.width - var_13_3.width)

						local var_13_4, var_13_5 = arg_13_0.sliderBg:xy()

						arg_13_0.sliderBg:show()
						arg_13_0:setScrollBarEnabled(true)
						arg_13_0:setScrollBarColor(cc.c3b(245, 156, 2))
						arg_13_0:setScrollBarOpacity(255)
						arg_13_0:setScrollBarAutoHideEnabled(false)
						arg_13_0:setScrollBarPositionFromCorner(cc.p(var_13_1 + var_13_0.width - var_13_4, (var_13_0.height - var_13_3.height) / 2 + 5))
						arg_13_0:setScrollBarWidth(var_13_3.width)
						arg_13_0:refreshView()
					else
						arg_13_0:setScrollBarEnabled(false)
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onReplay"),
				showMyInfo = bindHelper.self("onShowMyInfo"),
				showEnemyInfo = bindHelper.self("onShowEnemyInfo"),
				replayRecord = bindHelper.self("onItemPlayRecord")
			}
		}
	},
	btnMainSchedule = {
		binds = {
			{
				event = "visible",
				idler = bindHelper.self("isRecord"),
				method = function(arg_14_0)
					return not arg_14_0
				end
			},
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onMainSchedule")
				}
			}
		}
	},
	btnMyTeam = {
		binds = {
			{
				event = "visible",
				idler = bindHelper.self("isRecord"),
				method = function(arg_15_0)
					if arg_15_0 == nil then
						arg_15_0 = false
					end

					return not arg_15_0
				end
			},
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onEnterEmbattle")
				}
			}
		}
	},
	btns = {
		binds = {
			event = "visible",
			idler = bindHelper.self("isRecord"),
			method = function(arg_16_0)
				if arg_16_0 == nil then
					arg_16_0 = false
				end

				return not arg_16_0
			end
		}
	},
	["btns.btnBet"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnBet")
			}
		}
	},
	["btns.btnRankReward"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnReward")
			}
		}
	},
	["btns.btnRecord"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPlayRecord")
			}
		}
	},
	["btns.btnShop"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnShop")
			}
		}
	},
	["btns.btnRule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowRule")
			}
		}
	},
	["btns.btnRule.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["btns.btnRankReward.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["btns.btnRecord.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["btns.btnBet.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["btns.btnShop.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	leftDown = {
		binds = {
			event = "visible",
			idler = bindHelper.self("isRecord")
		}
	},
	["leftDown.btnMainSchedule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onMainSchedule")
			}
		}
	},
	["leftDown.btnMySchedule"] = {
		binds = {
			event = "touch",
			idler = bindHelper.self("onMySchedule")
		}
	},
	["btnMyTeam.textNote"] = {
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
	["btnMainSchedule.textNote"] = {
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
	["leftDown.btnMySchedule.textNote"] = {
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
	["leftDown.btnMainSchedule.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_12.onCreate(arg_17_0, arg_17_1)
	gGameUI.topuiManager:createView("default", arg_17_0, {
		onClose = arg_17_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = "common/txt/txt_bt_renzhedasai.png"
	})

	local var_17_0 = true

	arg_17_0.deltaWidth = adapt.centerWithScreen("left", "right", nil, {
		{
			arg_17_0.speList,
			"pos",
			"left"
		},
		{
			arg_17_0.speList,
			"width"
		}
	})
	arg_17_0.isRecord = idler.new(arg_17_1)

	arg_17_0:initModel()

	arg_17_0.rounds = {}
	arg_17_0.fightDatas = idlers.newWithMap({})
	arg_17_0.winAndloseNum = idler.new(string.format(gLanguageCsv.winAndLoseNum, 0, 0))
	arg_17_0.pointNum = idler.new(arg_17_0.info:read().point)

	local var_17_1 = -1

	idlereasy.any({
		arg_17_0.history,
		arg_17_0.vsinfo,
		arg_17_0.curTime,
		arg_17_0.round,
		arg_17_0.info
	}, function(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
		local function var_18_0()
			if not arg_17_1 and (arg_18_4 == "over" or arg_18_4 == "closed") then
				gGameUI:goBackInStackUI("city.adventure.pvp")
				gGameUI:stackUI("city.pvp.craft.view", nil, {
					full = true
				})

				return
			end

			arg_17_0.rounds = {}

			local var_19_0 = {}

			if arg_18_5.point == 0 and arg_18_1[1] and time.getTime() - arg_18_1[1].time > 86400 then
				arg_18_1 = {}
			end

			local var_19_1 = #arg_18_1
			local var_19_2 = 0

			for iter_19_0 = var_19_1, 1, -1 do
				local var_19_3 = clone(arg_18_1[iter_19_0])

				table.insert(arg_17_0.rounds, var_19_3.round)

				var_19_3.path = arg_17_0:getTitleRes(var_19_3.round)
				var_19_3.showTime = arg_18_3

				table.insert(var_19_0, var_19_3)

				var_19_2 = var_19_2 + 1
			end

			local var_19_4 = arg_17_0.speList:getItemsMargin()
			local var_19_5 = arg_17_0.item:size().height
			local var_19_6 = var_19_2 * var_19_5 + (var_19_2 - 1) * var_19_4

			if not arg_17_1 then
				local var_19_7 = var_0_7(arg_18_4)
				local var_19_8 = var_0_8(arg_18_4)
				local var_19_9 = arg_18_4

				if var_19_7 then
					var_19_9 = string.split(arg_18_4, "_")[1]
				end

				if not var_19_8 and arg_17_0.isSignup and not arg_18_5.isout and not itertools.include(arg_17_0.rounds, var_19_9) then
					local var_19_10 = string.format("craft, info.isout(%s), round(%s), vsinfo.round(%s), history(len:%d)\nhistory:last(%s)\nvsinfo(%s)", tostring(arg_18_5.isout), arg_18_4, tostring(arg_18_2.round), var_19_1, dumps(arg_18_1[var_19_1]), dumps(arg_18_2))

					if not itertools.isempty(arg_18_2.round) then
						assertInWindows(arg_18_4 == arg_18_2.round, var_19_10)
					end

					local var_19_11 = {
						figure = arg_18_5.figure,
						showTime = arg_18_3
					}
					local var_19_12, var_19_13 = arg_17_0:getCardsByRound()

					var_19_11.cards = var_19_12
					var_19_11.fighting_point = var_19_13
					var_19_11.round = var_19_9
					var_19_11.enemy = arg_18_2
					var_19_11.path = arg_17_0:getTitleRes(var_19_9)

					table.insert(var_19_0, 1, var_19_11)

					var_19_6 = var_19_6 + var_19_4 + var_19_5
				end

				if not arg_17_0.isSignup or arg_18_5.isout then
					local var_19_14 = string.format(gLanguageCsv.craftIsOver, arg_18_5.win or 0, math.min(arg_18_5.round or 0, 13) - (arg_18_5.win or 0))

					if not arg_17_0.isSignup then
						var_19_14 = gLanguageCsv.noSignupCantBattle
						var_19_0 = {}

						if var_17_0 then
							var_17_0 = false

							arg_17_0:onMainSchedule()
						end
					end

					table.insert(var_19_0, 1, {
						round = "out",
						str = var_19_14
					})

					var_19_6 = var_19_6 + var_19_4 + 115
				end

				if arg_18_5.isout then
					arg_17_0:enableSchedule()
					arg_17_0:unSchedule(1010)

					local var_19_15 = var_0_5(arg_18_4)
					local var_19_16 = arg_18_3 + var_19_15 - time.getTime()

					if var_19_16 < 0 then
						var_19_16 = var_0_2
					end

					arg_17_0:schedule(function()
						var_19_16 = var_19_16 - 1

						if var_19_16 <= 0 then
							var_19_16 = var_0_2

							gGameApp:requestServer("/game/craft/battle/main")
						end
					end, 1, 0, 1010)
				end
			elseif var_19_1 == 0 and not arg_17_0.isSignup then
				var_19_0 = {}

				table.insert(var_19_0, 1, {
					round = "out",
					str = gLanguageCsv.notSignupCantShowBattleReport
				})

				var_19_6 = var_19_6 + var_19_4 + 115
			end

			arg_17_0.slider:visible(var_19_6 > arg_17_0.speList:size().height)
			arg_17_0.fightDatas:update(var_19_0)
			arg_17_0.winAndloseNum:set(string.format(gLanguageCsv.winAndLoseNum, arg_18_5.win or 0, math.min(arg_18_5.round or 0, 13) - (arg_18_5.win or 0)))
			arg_17_0.pointNum:set(arg_18_5.point)
		end

		if var_17_1 < 0 then
			var_17_1 = 0

			var_18_0()

			return
		end

		var_17_1 = var_17_1 + 1

		performWithDelay(arg_17_0, function()
			var_17_1 = var_17_1 - 1

			if var_17_1 > 0 then
				return
			end

			var_18_0()
		end, 0)
	end)

	if matchLanguage({
		"en"
	}) then
		adapt.oneLinePos(arg_17_0.textNote2, arg_17_0.textNum, cc.p(6, 0), "left")
	end
end

function var_0_12.initModel(arg_22_0)
	arg_22_0.roleId = gGameModel.role:read("id")
	arg_22_0.craft_record_db_id = gGameModel.role:read("craft_record_db_id")
	arg_22_0.level = gGameModel.role:read("level")
	arg_22_0.roleName = gGameModel.role:read("name")
	arg_22_0.figure = gGameModel.role:read("figure")

	local var_22_0 = gGameModel.craft

	arg_22_0.round = var_22_0:getIdler("round")
	arg_22_0.curTime = var_22_0:getIdler("time")
	arg_22_0.history = var_22_0:getIdler("history")
	arg_22_0.top8 = var_22_0:getIdler("top8_plays")
	arg_22_0.info = var_22_0:getIdler("info")
	arg_22_0.cardAttrs = arg_22_0.info:read().card_attrs
	arg_22_0.isSignup = gGameModel.daily_record:read("craft_sign_up")
	arg_22_0.vsinfo = var_22_0:getIdler("vsinfo")
end

function var_0_12.getCardsByRound(arg_23_0)
	local var_23_0 = arg_23_0.round:read()
	local var_23_1, var_23_2 = string.find(var_23_0, "^pre%d+")
	local var_23_3, var_23_4 = string.find(var_23_0, "^final%d+")
	local var_23_5 = {}
	local var_23_6 = 0

	if var_23_1 or var_23_0 == "prepare" then
		local var_23_7 = 1

		if var_23_1 then
			var_23_7 = string.sub(var_23_0, var_23_1 + 3, var_23_2)
		end

		local var_23_8 = arg_23_0.info:read().cards[tonumber(var_23_7)]

		if var_23_8 then
			local var_23_9 = arg_23_0.cardAttrs[var_23_8]
			local var_23_10 = var_23_9.card_id
			local var_23_11 = var_23_9.skin_id
			local var_23_12 = {
				var_23_8,
				var_23_10,
				var_23_11
			}

			table.insert(var_23_5, var_23_12)

			var_23_6 = var_23_9.fighting_point
		end
	elseif var_23_3 then
		local var_23_13 = string.sub(var_23_0, var_23_3 + 5, var_23_4)
		local var_23_14 = tonumber(var_23_13) * 3

		for iter_23_0 = var_23_14 - 2, var_23_14 do
			local var_23_15 = arg_23_0.info:read().cards[iter_23_0]

			if var_23_15 then
				local var_23_16 = arg_23_0.cardAttrs[var_23_15]
				local var_23_17 = var_23_16.card_id
				local var_23_18 = var_23_16.skin_id
				local var_23_19 = {
					var_23_15,
					var_23_17,
					var_23_18
				}

				table.insert(var_23_5, var_23_19)

				var_23_6 = var_23_6 + var_23_16.fighting_point
			end
		end
	end

	return var_23_5, var_23_6
end

function var_0_12.getTitleRes(arg_24_0, arg_24_1)
	arg_24_1 = arg_24_1 or arg_24_0.round:read()

	local var_24_0, var_24_1 = string.find(arg_24_1, "^pre%d+")

	if var_24_0 or arg_24_1 == "prepare" then
		local var_24_2 = 1

		if var_24_0 then
			var_24_2 = string.sub(arg_24_1, var_24_0 + 3, var_24_1)
		end

		return "city/pvp/craft/myschedule/txt_yxs" .. var_24_2 .. ".png"
	end

	if arg_24_1 == "final1" then
		return "city/pvp/craft/myschedule/txt_sqs1.png"
	elseif arg_24_1 == "final2" then
		return "city/pvp/craft/myschedule/txt_bjs1.png"
	elseif arg_24_1 == "final3" then
		local var_24_3 = arg_24_0.history:read()[12]

		if not var_24_3 then
			return
		end

		local var_24_4 = var_24_3.result
		local var_24_5 = "city/pvp/craft/myschedule/txt_jjs.png"

		if var_24_4 == "win" then
			var_24_5 = "city/pvp/craft/myschedule/txt_gjs1.png"
		end

		return var_24_5
	end

	return nil
end

function var_0_12.onEnterEmbattle(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	if not arg_25_0.isSignup then
		gGameUI:showTip(gLanguageCsv.notSignUp)

		return
	end

	if arg_25_0.info:read().isout then
		gGameUI:showTip(gLanguageCsv.isOutCantEnterEmbattle)

		return
	end

	gGameUI:stackUI("city.pvp.craft.embattle", nil, {
		full = true
	}, arg_25_0.isRecord:read(), arg_25_2)
end

function var_0_12.onMainSchedule(arg_26_0)
	local var_26_0 = arg_26_0.round:read()

	if string.find(var_26_0, "pre") then
		gGameUI:stackUI("city.pvp.craft.mainschedule", nil, {
			full = true
		})
	elseif not gGameUI:goBackInStackUI("city.pvp.craft.mainschedule_eight") then
		gGameUI:stackUI("city.pvp.craft.mainschedule_eight", nil, {
			full = true
		}, arg_26_0.isRecord:read())
	end
end

function var_0_12.onShowEnemyInfo(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	gGameApp:requestServer("/game/craft/battle/enemy/get", function(arg_28_0)
		gGameUI:stackUI("city.pvp.craft.enemy_embattle", nil, nil, arg_28_0.view, arg_27_4)
	end, arg_27_3.enemy.role_db_id, arg_27_3.enemy.record_db_id)
end

function var_0_12.onShowMyInfo(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
	gGameApp:requestServer("/game/craft/battle/enemy/get", function(arg_30_0)
		gGameUI:stackUI("city.pvp.craft.enemy_embattle", nil, nil, arg_30_0.view, arg_29_4)
	end, arg_29_0.roleId, arg_29_0.craft_record_db_id)
end

function var_0_12.onBtnBet(arg_31_0)
	gGameApp:requestServer("/game/craft/bet/info", function(arg_32_0)
		gGameUI:stackUI("city.pvp.craft.bet", nil, nil, arg_32_0.view)
	end)
end

function var_0_12.onBtnReward(arg_33_0)
	gGameApp:requestServer("/game/rank", function(arg_34_0)
		gGameUI:stackUI("city.pvp.craft.rank", nil, nil, arg_34_0.view)
	end, "craft", 0, 50)
end

function var_0_12.onPlayRecord(arg_35_0)
	gGameUI:showTip(gLanguageCsv.craftRankGaming)
end

function var_0_12.onReplay(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
	local var_36_0 = "/game/craft/playrecord/get"

	gGameModel:playRecordBattle(arg_36_3.prid, nil, var_36_0, 2, arg_36_0.roleId)
end

function var_0_12.onBtnShop(arg_37_0)
	if not gGameUI:goBackInStackUI("city.shop") then
		gGameApp:requestServer("/game/fixshop/get", function(arg_38_0)
			gGameUI:stackUI("city.shop", nil, {
				full = true
			}, game.SHOP_INIT.CRAFT_SHOP)
		end)
	end
end

function var_0_12.onShowRule(arg_39_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_39_0:createHandler("getRuleContext"), {
		width = 1500
	})
end

function var_0_12.getRuleContext(arg_40_0, arg_40_1)
	local var_40_0 = adaptContext

	return {
		var_40_0.clone(arg_40_1.title, function(arg_41_0)
			arg_41_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_40_0.noteText(112),
		var_40_0.noteText(39001, 39010),
		var_40_0.noteText(113),
		var_40_0.noteText(40001, 40005),
		var_40_0.noteText(114),
		var_40_0.noteText(41001, 41004),
		var_40_0.noteText(115),
		var_40_0.noteText(42001, 42004)
	}
end

function var_0_12.onClose(arg_42_0)
	if arg_42_0.isRecord:read() and gGameUI:goBackInStackUI("city.pvp.craft.view") then
		return
	end

	var_0_11.onClose(arg_42_0)
end

return var_0_12
