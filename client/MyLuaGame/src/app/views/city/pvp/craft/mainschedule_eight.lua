local var_0_0 = 10
local var_0_1 = 10
local var_0_2 = 300
local var_0_3 = {
	final = 300,
	pre = 240,
	prepare = 600
}
local var_0_4 = {
	fighting = 2,
	over = 3,
	ready = 1
}
local var_0_5 = {
	"group-a1",
	"group-b1",
	"third",
	"champion"
}
local var_0_6 = {
	"signup",
	"prepare",
	"over",
	"closed"
}
local var_0_7 = string.find

local function var_0_8(arg_1_0)
	return var_0_7(arg_1_0, "_lock") ~= nil
end

local function var_0_9(arg_2_0)
	local var_2_0 = 0

	if string.find(arg_2_0, "prepare") then
		var_2_0 = var_0_3.prepare
	elseif string.find(arg_2_0, "pre") then
		var_2_0 = var_0_3.pre
	elseif string.find(arg_2_0, "final") then
		var_2_0 = var_0_3.final
	end

	return var_2_0
end

local var_0_10 = cc.load("mvc").ViewBase
local var_0_11 = class("CraftMainScheduleEightView", var_0_10)

var_0_11.RESOURCE_FILENAME = "main_schedule_eight.json"
var_0_11.RESOURCE_BINDING = {
	["pageBtns.btnGroupB.textNote"] = "textNote2",
	["pageBtns.btnGroupA.textNote"] = "textNote1",
	["pageBtns.btnChampion.textNote"] = "textNote4",
	inBattle = "inBattle",
	["oneToFour.play2"] = "play2",
	["oneToFour.play1"] = "play1",
	["oneToFour.imgVs"] = "imgVs",
	["pageBtns.btnThird.textNote"] = "textNote3",
	lightEfc = "lightEfc",
	["pageBtns.btnGroupA"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_3_0)
					arg_3_0:onChangePage(1)
				end)
			}
		}
	},
	["pageBtns.btnGroupB"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_4_0)
					arg_4_0:onChangePage(2)
				end)
			}
		}
	},
	["pageBtns.btnThird"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_5_0)
					arg_5_0:onChangePage(3)
				end)
			}
		}
	},
	["pageBtns.btnChampion"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_6_0)
					arg_6_0:onChangePage(4)
				end)
			}
		}
	},
	["pageBtns.btnGroupA.imgBg"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("curPageIdx"),
			method = function(arg_7_0)
				return arg_7_0 == 1
			end
		}
	},
	["pageBtns.btnGroupB.imgBg"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("curPageIdx"),
			method = function(arg_8_0)
				return arg_8_0 == 2
			end
		}
	},
	["pageBtns.btnThird.imgBg"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("curPageIdx"),
			method = function(arg_9_0)
				return arg_9_0 == 3
			end
		}
	},
	["pageBtns.btnChampion.imgBg"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("curPageIdx"),
			method = function(arg_10_0)
				return arg_10_0 == 4
			end
		}
	},
	group = {
		varname = "group",
		binds = {
			event = "visible",
			idler = bindHelper.self("curPageIdx"),
			method = function(arg_11_0)
				return arg_11_0 < 3
			end
		}
	},
	oneToFour = {
		varname = "oneToFour",
		binds = {
			event = "visible",
			idler = bindHelper.self("curPageIdx"),
			method = function(arg_12_0)
				return arg_12_0 > 2
			end
		}
	},
	["group.imgTitle"] = {
		binds = {
			event = "texture",
			idler = bindHelper.self("curPageIdx"),
			method = function(arg_13_0)
				local var_13_0 = "city/pvp/craft/mainschedule/txt_azs.png"

				if arg_13_0 == 2 then
					var_13_0 = "city/pvp/craft/mainschedule/txt_bzs.png"
				end

				return var_13_0
			end
		}
	},
	["oneToFour.imgTitle"] = {
		varname = "imgTitle",
		binds = {
			event = "texture",
			idler = bindHelper.self("curPageIdx"),
			method = function(arg_14_0)
				local var_14_0 = "city/pvp/craft/mainschedule/txt_jjs.png"

				if arg_14_0 == 4 then
					var_14_0 = "city/pvp/craft/mainschedule/txt_gjs.png"
				end

				return var_14_0
			end
		}
	},
	["inBattle.textStateNote"] = {
		varname = "textStateNote",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(242, 48, 81, 255)
				}
			}
		}
	},
	["inBattle.textTime"] = {
		varname = "inBattleTextTime",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						color = cc.c4b(46, 77, 229, 255)
					}
				}
			},
			{
				event = "text",
				idler = bindHelper.self("deltaTime"),
				method = function(arg_15_0)
					return time.getCutDown(arg_15_0).str
				end
			}
		}
	},
	["group.team1.btnReplay.textNote"] = {
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
	["group.team2.btnReplay.textNote"] = {
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
	["group.team3.btnReplay.textNote"] = {
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
	["oneToFour.btnReplay.textNote"] = {
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
	btnMyTeam = {
		binds = {
			{
				event = "visible",
				idler = bindHelper.self("isRecord"),
				method = function(arg_16_0)
					if arg_16_0 == nil then
						arg_16_0 = false
					end

					return not arg_16_0
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
	["btnMyTeam.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	btns = {
		binds = {
			event = "visible",
			idler = bindHelper.self("isRecord"),
			method = function(arg_17_0)
				if arg_17_0 == nil then
					arg_17_0 = false
				end

				return not arg_17_0
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
	["btns.btnBet.textNote"] = {
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
	["btns.btnRankReward"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnReward")
			}
		}
	},
	["btns.btnRankReward.textNote"] = {
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
	["btns.btnRecord"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPlayRecord")
			}
		}
	},
	["btns.btnRecord.textNote"] = {
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
	["btns.btnShop"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnShop")
			}
		}
	},
	["btns.btnShop.textNote"] = {
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
	["btns.btnRule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnRule")
			}
		}
	},
	["btns.btnRule.textNote"] = {
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
	leftDown = {
		binds = {
			event = "visible",
			idler = bindHelper.self("isRecord")
		}
	},
	["leftDown.btnMySchedule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onEnterMySchedule")
			}
		}
	},
	["leftDown.btnMainSchedule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onEnterMainSchedule")
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

function var_0_11.onCreate(arg_18_0, arg_18_1)
	arg_18_0.isRecord = idler.new(arg_18_1)

	arg_18_0:initModel()
	gGameUI.topuiManager:createView("default", arg_18_0, {
		onClose = arg_18_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = "common/txt/txt_bt_renzhedasai.png"
	})

	local var_18_0 = arg_18_1 == true and 4 or 1

	if string.find(arg_18_0.round:read(), "final3") ~= nil then
		var_18_0 = 3
	end

	local var_18_1 = var_18_0 < 3 and "xiaozusai_loop" or "juesai_loop"
	local var_18_2 = widget.addAnimationByKey(arg_18_0.lightEfc, "shiyingdahui/shiyingdahui.skel", "lightBg", var_18_1):scale(2):xy(100, 100)

	arg_18_0.curPageIdx = idler.new(var_18_0)
	arg_18_0.refresh = idler.new(false)

	idlereasy.any({
		arg_18_0.round,
		arg_18_0.curPageIdx,
		arg_18_0.top8,
		arg_18_0.curTime,
		arg_18_0.refresh
	}, function(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
		if not arg_18_1 and (arg_19_1 == "over" or arg_19_1 == "closed") then
			return
		end

		arg_18_0.oneToFour:removeChildByName("guanjunEft")

		for iter_19_0 = 1, 4 do
			text.deleteAllEffect(arg_18_0["textNote" .. iter_19_0])

			local var_19_0 = cc.c4b(252, 234, 210, 255)

			if iter_19_0 == arg_19_2 then
				var_19_0 = cc.c4b(245, 252, 237, 255)

				text.addEffect(arg_18_0["textNote" .. iter_19_0], {
					glow = {
						color = ui.COLORS.GLOW.WHITE
					}
				})
			end

			text.addEffect(arg_18_0["textNote" .. iter_19_0], {
				color = var_19_0
			})
		end

		local var_19_1 = arg_19_2 < 3
		local var_19_2 = string.find(arg_19_1, "final3") ~= nil
		local var_19_3 = "xiaozusai_loop"

		if var_19_1 then
			var_19_3 = "xiaozusai_loop"

			local var_19_4 = {}

			arg_18_0.inBattle:visible(not arg_18_1 and not var_19_2)

			local var_19_5 = arg_19_2 == 1 and "a" or "b"
			local var_19_6 = "group-" .. var_19_5
			local var_19_7 = {}

			for iter_19_1 = 1, 3 do
				local var_19_8 = arg_19_3[var_19_6 .. iter_19_1]

				if var_19_8 then
					var_19_4[iter_19_1] = var_19_8

					if iter_19_1 < 3 and arg_18_0:canShowResult(var_19_8.result, iter_19_1) then
						var_19_7["role" .. iter_19_1] = var_19_8.result == "win" and clone(var_19_8.role1) or clone(var_19_8.role2)
						var_19_4[3] = var_19_7
					end
				end
			end

			arg_18_0:setGroupPlayerInfo(var_19_4)
		else
			local var_19_9 = arg_19_2 == 3

			arg_18_0.play1:visible(var_19_9)
			arg_18_0.play2:visible(var_19_9)
			arg_18_0.imgVs:visible()
			arg_18_0.imgTitle:visible()

			var_19_3 = "juesai_loop"

			arg_18_0.inBattle:visible(not arg_18_1 and var_19_2)

			local var_19_10 = arg_19_3[var_0_5[arg_19_2]]

			if var_19_10 then
				arg_18_0:setFourPlayerInfo(var_19_10)
			end
		end

		var_18_2:play(var_19_3)
		var_18_2:visible(arg_19_2 <= 3)

		if arg_19_2 == 4 then
			widget.addAnimationByKey(arg_18_0.oneToFour, "shiyingdahui/shiyingdahui.skel", "guanjunEft", "juesai", 1):scale(2):xy(1170, 473):setSpriteEventHandler(function(arg_20_0, arg_20_1)
				performWithDelay(arg_18_0.oneToFour, function()
					arg_18_0.oneToFour:removeChildByName("guanjunEft")
					arg_18_0.play1:show()
					arg_18_0.play2:show()
					arg_18_0.imgVs:show()
					arg_18_0.imgTitle:show()
					var_18_2:show()
				end, 0.016666666666666666)
			end, sp.EventType.ANIMATION_COMPLETE)
		end

		if var_0_8(arg_19_1) then
			var_0_0 = -1
		end

		arg_18_0.delta = arg_19_4 + var_0_2 - time.getTime()

		if arg_18_0.delta < 0 then
			arg_18_0.delta = var_0_1
		end
	end)

	arg_18_0.deltaTime = idler.new(0)

	arg_18_0:enableSchedule()
	arg_18_0:schedule(function()
		local var_22_0 = arg_18_0.round:read()

		if var_22_0 == "over" or var_22_0 == "closed" then
			return false
		end

		arg_18_0.delta = arg_18_0.delta - 1

		if arg_18_0.delta < 0 then
			arg_18_0.delta = var_0_1

			gGameApp:requestServer("/game/craft/battle/main", function()
				if arg_18_0.refresh then
					arg_18_0.refresh:set(not arg_18_0.refresh:read(), true)
				end
			end)
		else
			local var_22_1 = arg_18_0.delta

			if arg_18_0.delta > 60 then
				var_22_1 = var_22_1 - 60

				arg_18_0.textStateNote:text(gLanguageCsv.stateReady)
			elseif arg_18_0.delta <= 60 and not var_0_8(var_22_0) then
				arg_18_0.textStateNote:text(gLanguageCsv.stateFighting)

				if var_0_0 < 0 then
					var_0_0 = 10

					gGameApp:requestServer("/game/craft/battle/main", function()
						if arg_18_0.refresh then
							arg_18_0.refresh:set(not arg_18_0.refresh:read(), true)
						end
					end)
				else
					var_0_0 = var_0_0 - 1
				end
			elseif arg_18_0.delta <= 60 then
				arg_18_0.textStateNote:text(gLanguageCsv.stateFighting)
			end

			arg_18_0.deltaTime:set(var_22_1)
		end
	end, 1, 0)

	if matchLanguage({
		"en"
	}) then
		adapt.oneLineCenterPos(cc.p(60, -16), {
			arg_18_0.textStateNote,
			arg_18_0.inBattleTextTime
		}, cc.p(6, 0))
	end
end

function var_0_11.initModel(arg_25_0)
	local var_25_0 = gGameModel.craft

	arg_25_0.roleId = gGameModel.role:read("id")
	arg_25_0.round = var_25_0:getIdler("round")
	arg_25_0.perRound = arg_25_0.round:read()
	arg_25_0.curTime = var_25_0:getIdler("time")
	arg_25_0.top8 = var_25_0:getIdler("top8_plays")

	if arg_25_0.isRecord:read() then
		arg_25_0.top8 = var_25_0:getIdler("yesterday_top8_plays")
	end

	arg_25_0.info = var_25_0:read("info")
	arg_25_0.isSignup = gGameModel.daily_record:read("craft_sign_up")
end

function var_0_11.canShowResult(arg_26_0, arg_26_1, arg_26_2)
	if not arg_26_1 or string.len(arg_26_1) == 0 then
		return false
	end

	local var_26_0 = arg_26_0.round:read()
	local var_26_1 = arg_26_0.curPageIdx:read()

	if string.find(var_26_0, "final2") and var_26_1 < 3 and arg_26_2 < 3 or string.find(var_26_0, "final3") and var_26_1 < 3 or itertools.include(var_0_6, var_26_0) then
		return true
	end

	return false
end

function var_0_11.setGroupPlayerInfo(arg_27_0, arg_27_1)
	local var_27_0 = 0
	local var_27_1 = false
	local var_27_2 = arg_27_0.group

	var_27_2:stopAllActions()
	var_27_2:removeChildByName("cloneNode")
	var_27_2:removeChildByName("touxiang")
	var_27_2:get("team3"):removeChildByName("progrressBar")
	var_27_2:get("team1"):removeChildByName("progrressBar2")
	var_27_2:get("team2"):removeChildByName("progrressBar3")

	for iter_27_0, iter_27_1 in ipairs(arg_27_1) do
		var_27_0 = var_27_0 + 1

		local var_27_3 = var_27_2:get("team" .. iter_27_0)
		local var_27_4 = arg_27_0:canShowResult(iter_27_1.result, iter_27_0)
		local var_27_5 = {}

		if var_27_4 then
			var_27_5[1] = iter_27_1.result == "win" and "city/pvp/craft/icon_win.png" or "city/pvp/craft/icon_lose.png"
			var_27_5[2] = iter_27_1.result == "win" and "city/pvp/craft/icon_lose.png" or "city/pvp/craft/icon_win.png"
		end

		var_27_3:get("btnReplay"):visible(var_27_4)
		var_27_3:get("win"):hide()
		var_27_3:get("fail"):hide()

		local var_27_6 = 0

		if iter_27_0 == 3 then
			if not var_27_4 then
				var_27_6 = 0.7

				local var_27_7 = arg_27_1[1].result == "win" and 2 or -2

				widget.addAnimationByKey(var_27_2:get("team1"), "shiyingdahui/jdt.skel", "progrressBar2", "effect_2", 2):scaleX(2):scaleY(var_27_7):xy(cc.p(1148, 464))

				local var_27_8 = arg_27_1[2].result == "win" and 2 or -2

				widget.addAnimationByKey(var_27_2:get("team2"), "shiyingdahui/jdt.skel", "progrressBar3", "effect_2", 2):scaleX(-2):scaleY(var_27_8):xy(cc.p(-736, 464))

				for iter_27_2 = 1, 2 do
					local var_27_9 = var_27_3:get("play" .. iter_27_2)
					local var_27_10 = var_27_9:getChildren()

					for iter_27_3, iter_27_4 in ipairs(var_27_10) do
						iter_27_4:hide()
					end

					var_27_9:getChildByName("imgBg"):show()
					var_27_9:getChildByName("null"):show()
				end
			else
				var_27_2:get("team1"):get(arg_27_1[1].result):show()
				var_27_2:get("team2"):get(arg_27_1[2].result):show()
			end
		end

		performWithDelay(arg_27_0.group, function()
			for iter_28_0 = 1, 2 do
				local var_28_0 = var_27_3:get("play" .. iter_28_0)

				var_28_0:get("null"):hide()

				local var_28_1 = iter_27_1["role" .. iter_28_0]

				var_28_0:get("textLv"):text("Lv" .. var_28_1.level)
				text.addEffect(var_28_0:get("textLv"), {
					outline = {
						size = 3,
						color = ui.COLORS.OUTLINE.DEFAULT
					}
				})
				var_28_0:get("textName"):text(var_28_1.name)
				var_28_0:get("textFightPoint"):text(var_28_1.display.fighting_point)
				var_28_0:get("textLv"):show()
				var_28_0:get("textName"):show()
				var_28_0:get("textFightPoint"):show()
				var_28_0:get("textNote"):show()
				bind.extend(arg_27_0, var_28_0, {
					class = "role_logo",
					props = {
						vip = false,
						level = false,
						logoId = var_28_1.logo,
						frameId = var_28_1.frame,
						onNode = function(arg_29_0)
							if var_28_1.frame ~= 1 then
								return
							end

							local var_29_0 = arg_29_0:getChildByName("frame")
							local var_29_1 = "config/portrait/frame/box_head_default.png"

							if iter_27_0 == 2 or iter_27_0 == 3 and iter_28_0 == 2 then
								var_29_1 = "city/pvp/craft/mainschedule/panel_head_blue.png"
							end

							var_29_0:texture(var_29_1)
						end
					}
				})
				var_28_0:get("imgResult"):visible(var_27_4)

				if var_27_4 then
					var_28_0:get("imgResult"):texture(var_27_5[iter_28_0])

					if arg_27_0.isRecord:read() then
						var_27_3:get(iter_27_1.result):show()
					end

					bind.click(arg_27_0, var_27_3:get("btnReplay"), {
						method = function()
							arg_27_0:onReplay(iter_27_1)
						end
					})
				end

				bind.click(arg_27_0, var_28_0, {
					method = function()
						arg_27_0:onShowTeamInfo(var_28_1)
					end
				})
			end
		end, var_27_6)

		if iter_27_0 == 3 and var_27_4 then
			var_27_1 = true

			local var_27_11 = iter_27_1.result == "win" and iter_27_1.role1 or iter_27_1.role2
			local var_27_12 = var_27_2:get("winner")

			var_27_12:get("null"):hide()
			var_27_12:get("imgResult"):hide()
			var_27_12:get("textLv"):text("Lv" .. var_27_11.level)
			text.addEffect(var_27_12:get("textLv"), {
				outline = {
					size = 3,
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			})
			var_27_12:get("textName"):text(var_27_11.name)
			var_27_12:get("textFightPoint"):text(var_27_11.display.fighting_point)
			var_27_12:get("textLv"):show()
			var_27_12:get("textName"):show()
			var_27_12:get("textNote"):show()
			var_27_12:get("textFightPoint"):show()
			bind.extend(arg_27_0, var_27_12, {
				class = "role_logo",
				props = {
					vip = false,
					level = false,
					logoId = var_27_11.logo,
					frameId = var_27_11.frame,
					onNode = function(arg_32_0)
						arg_32_0:scale(1.15)

						if var_27_11.frame ~= 1 then
							return
						end

						arg_32_0:getChildByName("frame"):texture("city/pvp/craft/mainschedule/box_head_purple.png")
					end
				}
			})
			bind.click(arg_27_0, var_27_12, {
				method = function()
					arg_27_0:onShowTeamInfo(var_27_11)
				end
			})

			if arg_27_0.isRecord:read() then
				break
			end

			local var_27_13 = 2

			if iter_27_1.result == "fail" then
				var_27_13 = -2
			end

			widget.addAnimationByKey(var_27_2:get("team3"), "shiyingdahui/jdt.skel", "progrressBar", "effect_1", 2):scale(var_27_13):xy(cc.p(640, 212))

			local var_27_14 = var_27_12:getChildren()

			for iter_27_5, iter_27_6 in ipairs(var_27_14) do
				iter_27_6:hide()
			end

			var_27_12:get("null"):show()
			var_27_12:get("imgBg"):show()

			local var_27_15 = var_27_2:get("winner"):clone()
			local var_27_16 = var_27_15:getChildren()

			for iter_27_7, iter_27_8 in ipairs(var_27_16) do
				iter_27_8:hide()
			end

			var_27_15:xy(var_27_12:xy())
			var_27_15:addTo(var_27_2, 1000, "cloneNode")
			var_27_15:show()
			bind.extend(arg_27_0, var_27_15, {
				class = "role_logo",
				props = {
					vip = false,
					level = false,
					logoId = var_27_11.logo,
					frameId = var_27_11.frame,
					onNode = function(arg_34_0)
						if var_27_11.frame ~= 1 then
							return
						end

						arg_34_0:getChildByName("frame"):texture("city/pvp/craft/mainschedule/box_head_purple.png")
					end
				}
			})

			local var_27_17 = widget.addAnimationByKey(var_27_2, "shiyingdahui/xzs_touxiang.skel", "touxiang", "xiaozusai_touxiang", 100):scale(2):xy(var_27_12:xy())

			performWithDelay(arg_27_0.group, function()
				var_27_2:getChildByName("cloneNode"):stopAllActions()
				performWithDelay(arg_27_0.group, function()
					var_27_2:removeChildByName("cloneNode")
					var_27_2:removeChildByName("touxiang")

					local var_36_0 = var_27_12:getChildren()

					for iter_36_0, iter_36_1 in ipairs(var_36_0) do
						iter_36_1:show()
					end

					var_27_12:get("null"):hide()
				end, 0.016666666666666666)
			end, 1.75)

			local var_27_18 = cc.RepeatForever:create(cc.Sequence:create(cc.CallFunc:create(function()
				local var_37_0, var_37_1 = var_27_17:getPosition()
				local var_37_2 = "node_move"
				local var_37_3 = var_27_17:getScaleX()
				local var_37_4 = var_27_17:getScaleY()
				local var_37_5 = var_27_17:getBonePosition(var_37_2)
				local var_37_6 = var_27_17:getBoneRotation(var_37_2)
				local var_37_7 = var_27_17:getBoneScaleX(var_37_2)
				local var_37_8 = var_27_17:getBoneScaleY(var_37_2)

				var_27_15:rotate(-var_37_6):scaleX(var_37_7 * 1.15):scaleY(var_37_8 * 1.15):xy(var_37_5.x * var_37_3 + var_37_0, var_37_5.y * var_37_4 + var_37_1)
			end)))

			var_27_15:runAction(var_27_18)
		end
	end

	for iter_27_9 = var_27_0 + 1, 3 do
		local var_27_19 = var_27_2:get("team" .. iter_27_9)

		var_27_19:get("play1.imgResult"):hide()
		var_27_19:get("play1.textLv"):hide()
		var_27_19:get("play1.textName"):hide()
		var_27_19:get("play1.textNote"):hide()
		var_27_19:get("play1.textFightPoint"):hide()
		var_27_19:get("play1.null"):show()
		var_27_19:get("play2.imgResult"):hide()
		var_27_19:get("play2.textLv"):hide()
		var_27_19:get("play2.textName"):hide()
		var_27_19:get("play2.textNote"):hide()
		var_27_19:get("play2.textFightPoint"):hide()
		var_27_19:get("play2.null"):show()
		var_27_19:get("btnReplay"):hide()
		var_27_19:get("win"):hide()
		var_27_19:get("fail"):hide()
	end

	if not var_27_1 then
		arg_27_0.group:get("winner.imgResult"):hide()
		arg_27_0.group:get("winner.textLv"):hide()
		arg_27_0.group:get("winner.textName"):hide()
		arg_27_0.group:get("winner.textNote"):hide()
		arg_27_0.group:get("winner.textFightPoint"):hide()
		arg_27_0.group:get("winner.null"):show()
	end
end

function var_0_11.setFourPlayerInfo(arg_38_0, arg_38_1)
	if not arg_38_1 then
		return
	end

	local var_38_0 = gRoleFigureCsv
	local var_38_1 = csv.cards
	local var_38_2 = csv.unit
	local var_38_3 = arg_38_0.oneToFour
	local var_38_4 = arg_38_0:canShowResult(arg_38_1.result)
	local var_38_5 = {}

	var_38_3:get("btnReplay"):visible(var_38_4)

	if var_38_4 then
		var_38_5[1] = arg_38_1.result == "win" and "city/pvp/craft/icon_win.png" or "city/pvp/craft/icon_lose.png"
		var_38_5[2] = arg_38_1.result == "win" and "city/pvp/craft/icon_lose.png" or "city/pvp/craft/icon_win.png"

		bind.click(arg_38_0, var_38_3:get("btnReplay"), {
			method = function()
				arg_38_0:onReplay(arg_38_1)
			end
		})
	end

	for iter_38_0 = 1, 2 do
		local var_38_6 = arg_38_1["role" .. iter_38_0]
		local var_38_7 = var_38_3:get("play" .. iter_38_0)

		var_38_7:get("role"):removeChildByName("card")
		var_38_7:get("role"):removeChildByName("figure")
		var_38_7:get("textName"):text(var_38_6.name)
		var_38_7:get("textFightPoint"):text(var_38_6.display.fighting_point)
		var_38_7:get("textLv"):text("Lv" .. var_38_6.level)

		local var_38_8 = var_38_6.display.top_card
		local var_38_9 = var_38_6.display.skin_id
		local var_38_10 = dataEasy.getUnitCsv(var_38_8, var_38_9)
		local var_38_11 = var_38_0[var_38_6.figure]
		local var_38_12 = var_38_7:size()

		if string.len(var_38_11.resSpine or "") > 0 then
			widget.addAnimationByKey(var_38_7:get("role"), var_38_11.resSpine, "figure", "standby_loop", 2):xy(100, -200):scale()
		end

		bind.extend(arg_38_0, var_38_7, {
			event = "extend",
			class = "role_title",
			props = {
				data = var_38_6.title,
				onNode = function(arg_40_0)
					arg_40_0:xy(var_38_12.width / 2, var_38_12.height + 100)
					arg_40_0:scale(2)
					arg_40_0:z(3)
				end
			}
		})
		var_38_7:get("imgResult"):visible(var_38_4)

		if var_38_4 then
			var_38_7:get("imgResult"):texture(var_38_5[iter_38_0])
		end

		bind.click(arg_38_0, var_38_7, {
			method = function()
				arg_38_0:onShowTeamInfo(var_38_6)
			end
		})
	end
end

function var_0_11.onChangePage(arg_42_0, arg_42_1)
	if not arg_42_0.isRecord:read() and arg_42_1 > 2 and string.find(arg_42_0.round:read(), "final3") == nil then
		gGameUI:showTip(gLanguageCsv.notStartFighting)

		return
	end

	arg_42_0.group:stopAllActions()
	arg_42_0.curPageIdx:set(arg_42_1)
end

function var_0_11.onShowTeamInfo(arg_43_0, arg_43_1)
	gGameApp:requestServer("/game/craft/battle/enemy/get", function(arg_44_0)
		gGameUI:stackUI("city.pvp.craft.enemy_embattle", nil, nil, arg_44_0.view, 2, arg_43_0.delta < 0)
	end, arg_43_1.role_db_id, arg_43_1.record_db_id)
end

function var_0_11.onReplay(arg_45_0, arg_45_1)
	local var_45_0 = "/game/craft/playrecord/get"

	gGameModel:playRecordBattle(arg_45_1.play_id, nil, var_45_0, 2, arg_45_0.roleId)
end

function var_0_11.onEnterEmbattle(arg_46_0)
	if not arg_46_0.isSignup then
		gGameUI:showTip(gLanguageCsv.notSignUp)

		return
	end

	if arg_46_0.info.isout then
		gGameUI:showTip(gLanguageCsv.isOutCantEnterEmbattle)

		return
	end

	gGameUI:stackUI("city.pvp.craft.embattle", nil, {
		full = true
	})
end

function var_0_11.onClose(arg_47_0)
	var_0_10.onClose(arg_47_0)
end

function var_0_11.onBtnBet(arg_48_0)
	gGameApp:requestServer("/game/craft/bet/info", function(arg_49_0)
		gGameUI:stackUI("city.pvp.craft.bet", nil, nil, arg_49_0.view)
	end)
end

function var_0_11.onBtnReward(arg_50_0)
	gGameApp:requestServer("/game/rank", function(arg_51_0)
		gGameUI:stackUI("city.pvp.craft.rank", nil, nil, arg_51_0.view)
	end, "craft", 0, 50)
end

function var_0_11.onBtnShop(arg_52_0)
	if not gGameUI:goBackInStackUI("city.shop") then
		gGameApp:requestServer("/game/fixshop/get", function(arg_53_0)
			gGameUI:stackUI("city.shop", nil, {
				full = true
			}, game.SHOP_INIT.CRAFT_SHOP)
		end)
	end
end

function var_0_11.onPlayRecord(arg_54_0)
	gGameUI:showTip(gLanguageCsv.craftRankGaming)
end

function var_0_11.onBtnRule(arg_55_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_55_0:createHandler("getRuleContext"), {
		width = 1500
	})
end

function var_0_11.getRuleContext(arg_56_0, arg_56_1)
	local var_56_0 = adaptContext

	return {
		var_56_0.clone(arg_56_1.title, function(arg_57_0)
			arg_57_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_56_0.noteText(112),
		var_56_0.noteText(39001, 39010),
		var_56_0.noteText(113),
		var_56_0.noteText(40001, 40005),
		var_56_0.noteText(114),
		var_56_0.noteText(41001, 41004),
		var_56_0.noteText(115),
		var_56_0.noteText(42001, 42004)
	}
end

function var_0_11.onEnterMySchedule(arg_58_0)
	gGameUI:stackUI("city.pvp.craft.myschedule", nil, {
		full = true
	}, true)
end

function var_0_11.onEnterMainSchedule(arg_59_0)
	return
end

return var_0_11
