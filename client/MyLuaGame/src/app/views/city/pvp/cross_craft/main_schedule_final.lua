local var_0_0 = require("app.views.city.pvp.cross_craft.view")
local var_0_1 = {
	promotion = 1,
	topStage = 2
}
local var_0_2 = {
	fight = 2,
	ready = 1
}
local var_0_3 = string.find

local function var_0_4(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_0:getChildByName("frame")
	local var_1_1 = "config/portrait/frame/box_head_default.png"

	if arg_1_1 == 3 or arg_1_1 == 4 or arg_1_1 == 6 or arg_1_1 == 7 and arg_1_2 == 2 then
		var_1_1 = "city/pvp/craft/mainschedule/panel_head_blue.png"
	end

	var_1_0:texture(var_1_1)
end

local function var_0_5(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_0:getChildByName("frame")
	local var_2_1 = "config/portrait/frame/box_head_default.png"

	if arg_2_1 == 2 or arg_2_1 == 3 and arg_2_2 == 2 then
		var_2_1 = "city/pvp/craft/mainschedule/panel_head_blue.png"
	end

	var_2_0:texture(var_2_1)
end

local function var_0_6(arg_3_0)
	return var_0_3(arg_3_0, "_lock") ~= nil
end

local var_0_7 = {
	"group-a1",
	"group-a2",
	"group-b1",
	"group-b2",
	"group-a3",
	"group-b3"
}

local function var_0_8(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0["t" .. arg_4_1 - 1]
	local var_4_1 = {}

	for iter_4_0, iter_4_1 in ipairs(var_0_7) do
		local var_4_2 = var_4_0 and var_4_0[iter_4_1]

		if var_4_2 then
			table.insert(var_4_1, var_4_2)
		end
	end

	if var_4_0 and var_4_0.champion then
		table.insert(var_4_1, var_4_0.champion)
	end

	return var_4_1
end

local function var_0_9(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.final
	local var_5_1 = {}
	local var_5_2 = arg_5_1 == 2 and "b" or "a"

	for iter_5_0 = 1, 3 do
		local var_5_3 = var_5_0 and var_5_0["group-" .. var_5_2 .. iter_5_0]

		if var_5_3 then
			table.insert(var_5_1, var_5_3)
		end
	end

	return var_5_1
end

local function var_0_10(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.final

	if arg_6_1 == 3 then
		return var_6_0 and var_6_0.third
	elseif arg_6_1 == 4 then
		return var_6_0 and var_6_0.champion
	end
end

local var_0_11 = cc.load("mvc").ViewBase
local var_0_12 = class("CrossCraftMainScheduleFinalView", var_0_11)

var_0_12.RESOURCE_FILENAME = "cross_craft_mainschedule.json"
var_0_12.RESOURCE_BINDING = {
	schedule = "inBattle",
	["leftDown.btnPromotion.textNote"] = "btnPromotionNote",
	["leftDown.btnFinal.textNote"] = "btnFinalNote",
	item1 = "item1",
	item = "item",
	bgPanel = "bgPanel",
	recordBg = {
		varname = "recordBg",
		binds = {
			event = "visible",
			idler = bindHelper.self("isRecord")
		}
	},
	["item.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["view1.listview"] = {
		varname = "list1",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("listData1"),
				item = bindHelper.self("item"),
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					local var_7_0 = "city/pvp/cross_craft/mainschedule/btn_b.png"

					if arg_7_3.isSel then
						var_7_0 = "city/pvp/cross_craft/mainschedule/btn_r.png"
					end

					arg_7_1:get("imgBg"):texture(var_7_0)
					arg_7_1:get("textNote"):text(arg_7_3.str)
					bind.touch(arg_7_0, arg_7_1, {
						methods = {
							ended = functools.partial(arg_7_0.clickCell, arg_7_2, arg_7_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onChangePromotionPage")
			}
		}
	},
	["view2.listview"] = {
		varname = "list2",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 20,
				data = bindHelper.self("listData2"),
				item = bindHelper.self("item1"),
				onItem = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					local var_8_0 = "city/pvp/cross_craft/mainschedule/btn_b1.png"

					if arg_8_3.isSel then
						var_8_0 = "city/pvp/cross_craft/mainschedule/btn_r1.png"
					end

					arg_8_1:get("imgBg"):texture(var_8_0)
					arg_8_1:get("textNote"):text(arg_8_3.str)

					if arg_8_3.isSel then
						text.addEffect(arg_8_1:get("textNote"), {
							color = ui.COLORS.NORMAL.YELLOW,
							outline = {
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							}
						})
					else
						text.addEffect(arg_8_1:get("textNote"), {
							color = ui.COLORS.NORMAL.WHITE,
							outline = {
								color = ui.NEWCOLORS.OUTLINE.BLUE
							}
						})
					end

					adapt.setTextScaleWithWidth(arg_8_1:get("textNote"), nil, 170)
					bind.touch(arg_8_0, arg_8_1, {
						methods = {
							ended = functools.partial(arg_8_0.clickCell, arg_8_2, arg_8_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onChangeTopStafePage")
			}
		}
	},
	view1 = {
		varname = "view1",
		binds = {
			event = "visible",
			idler = bindHelper.self("isPromotion")
		}
	},
	view2 = {
		varname = "view2",
		binds = {
			event = "visible",
			idler = bindHelper.self("isPromotion"),
			method = function(arg_9_0)
				return not arg_9_0
			end
		}
	},
	["view2.half1"] = {
		varname = "half1",
		binds = {
			event = "visible",
			idler = bindHelper.self("curTopstagePageIdx"),
			method = function(arg_10_0)
				return arg_10_0 < 3
			end
		}
	},
	["view2.half2"] = {
		varname = "half2",
		binds = {
			event = "visible",
			idler = bindHelper.self("curTopstagePageIdx"),
			method = function(arg_11_0)
				return arg_11_0 > 2
			end
		}
	},
	["view1.title.imgTitle2"] = {
		binds = {
			event = "texture",
			idler = bindHelper.self("titlePath"),
			method = function(arg_12_0)
				local var_12_0 = string.lower(arg_12_0)

				return "city/pvp/cross_craft/txt/txt_" .. var_12_0 .. ".png"
			end
		}
	},
	["view2.half1.title.imgTitle"] = {
		binds = {
			event = "texture",
			idler = bindHelper.self("titleType"),
			method = function(arg_13_0)
				local var_13_0 = "city/pvp/cross_craft/txt/txt_xbsq.png"

				if arg_13_0 == 1 then
					var_13_0 = "city/pvp/cross_craft/txt/txt_sbsq.png"
				end

				return var_13_0
			end
		}
	},
	["schedule.textTime"] = {
		varname = "scheduleTime",
		binds = {
			event = "text",
			idler = bindHelper.self("deltaTime"),
			method = function(arg_14_0)
				return time.getCutDown(arg_14_0).min_sec_clock
			end
		}
	},
	btnMySchedule = {
		varname = "btnMySchedule",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onEnterMySchedule")
			}
		}
	},
	["btnMySchedule.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
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
	["leftDown.btnPromotion"] = {
		varname = "btnPromotion",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_15_0)
					arg_15_0:onChangePage(var_0_1.promotion)
				end)
			}
		}
	},
	["leftDown.btnFinal"] = {
		varname = "btnFinal",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_16_0)
					arg_16_0:onChangePage(var_0_1.topStage)
				end)
			}
		}
	}
}

function var_0_12.onCreate(arg_17_0, arg_17_1)
	if arg_17_1 == nil then
		arg_17_1 = false
	end

	arg_17_0.isRecord = idler.new(arg_17_1)

	arg_17_0:initModel()

	local var_17_0 = {
		{
			str = "A",
			isSel = false
		},
		{
			str = "B",
			isSel = false
		},
		{
			str = "C",
			isSel = false
		},
		{
			str = "D",
			isSel = false
		},
		{
			str = "E",
			isSel = false
		},
		{
			str = "F",
			isSel = false
		},
		{
			str = "G",
			isSel = false
		},
		{
			str = "H",
			isSel = false
		}
	}

	arg_17_0.listData1 = idlers.newWithMap(var_17_0)

	local var_17_1 = {
		{
			isSel = false,
			str = gLanguageCsv.halfUpBattle
		},
		{
			isSel = false,
			str = gLanguageCsv.halfDownBattle
		},
		{
			isSel = false,
			str = gLanguageCsv.thirdBattle
		},
		{
			isSel = false,
			str = gLanguageCsv.champtionBattle
		}
	}

	arg_17_0.listData2 = idlers.newWithMap(var_17_1)
	arg_17_0.refresh = idler.new(false)
	arg_17_0.titlePath = idler.new("A")
	arg_17_0.titleType = idler.new(1)
	arg_17_0.isPromotion = idler.new()

	local var_17_2 = false

	if arg_17_1 then
		arg_17_0:onChangePage(var_0_1.promotion)

		var_17_2 = not itertools.isempty(arg_17_0.history)

		gGameUI.topuiManager:createView("default", arg_17_0, {
			onClose = arg_17_0:createHandler("onClose")
		}):init({
			subTitle = "",
			title = "common/txt/txt_bt_kuafurenzhedasai.png"
		})
	else
		arg_17_0.isPromotion:set(var_0_3(arg_17_0.round:read(), "top") ~= nil)
	end

	if arg_17_0._isPromotion ~= nil then
		arg_17_0:onChangePage(arg_17_0._isPromotion and var_0_1.promotion)
	end

	arg_17_0.btnMySchedule:visible(var_17_2)

	arg_17_0.curPromotionPageIdx = idler.new()
	arg_17_0.curTopstagePageIdx = idler.new()

	local var_17_3 = 1

	if string.find(arg_17_0.round:read(), "final3") ~= nil then
		var_17_3 = 3
	end

	arg_17_0.curPromotionPageIdx:set(arg_17_0._curPromotionPageIdx or var_17_3)
	arg_17_0.curTopstagePageIdx:set(arg_17_0._curTopstagePageIdx or var_17_3)
	arg_17_0.curPromotionPageIdx:addListener(function(arg_18_0, arg_18_1)
		if arg_17_0.listData1:atproxy(arg_18_1) then
			arg_17_0.listData1:atproxy(arg_18_1).isSel = false
		end

		if arg_17_0.listData1:atproxy(arg_18_0) then
			arg_17_0.listData1:atproxy(arg_18_0).isSel = true
		end
	end)
	arg_17_0.curTopstagePageIdx:addListener(function(arg_19_0, arg_19_1)
		if arg_17_0.listData2:atproxy(arg_19_1) then
			arg_17_0.listData2:atproxy(arg_19_1).isSel = false
		end

		if arg_17_0.listData2:atproxy(arg_19_0) then
			arg_17_0.listData2:atproxy(arg_19_0).isSel = true
		end
	end)

	local var_17_4 = arg_17_0.bgPanel:size()
	local var_17_5 = widget.addAnimationByKey(arg_17_0.bgPanel, "kuafushiying/jb.skel", "bgSpine1", "effect_jj_loop", 2):scale(2):xy(var_17_4.width / 2, var_17_4.height / 2 + 50):hide()
	local var_17_6 = arg_17_0.inBattle:size()
	local var_17_7 = widget.addAnimationByKey(arg_17_0.inBattle, "kuafushiying/wz.skel", "stateSpine", "effect_bzz_loop", 1):scale(1):xy(var_17_6.width / 2 - 50, var_17_6.height / 2 - 110)

	arg_17_0.deltaTime = idler.new(0)

	arg_17_0:enableSchedule()

	local var_17_8 = var_0_2.ready

	local function var_17_9()
		local var_20_0 = var_0_6(arg_17_0.round:read())
		local var_20_1 = "effect_bzz_loop"
		local var_20_2 = cc.c4b(76, 255, 76, 255)
		local var_20_3 = ui.COLORS.NORMAL.DEFAULT
		local var_20_4 = 1

		if var_20_0 then
			var_20_2 = cc.c4b(255, 255, 0, 255)
			var_20_1 = "effect_zdz_loop"
			var_20_4 = 2
		end

		if var_20_4 ~= var_17_8 then
			var_17_8 = var_20_4

			var_17_7:play(var_20_1)
		end

		text.addEffect(arg_17_0.scheduleTime, {
			color = var_20_2
		})
		arg_17_0.deltaTime:set(arg_17_0.delta)
		arg_17_0.inBattle:get("imgBg"):visible(arg_17_0.isPromotion:read() or arg_17_0.curTopstagePageIdx:read() <= 2)
	end

	if arg_17_0.delta then
		var_17_9()
	end

	local var_17_10 = {
		arg_17_0.round,
		arg_17_0.curPromotionPageIdx,
		arg_17_0.curTopstagePageIdx,
		arg_17_0.top8,
		arg_17_0.curTime,
		arg_17_0.refresh
	}

	idlereasy.any(var_17_10, function(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
		if not arg_17_1 and (arg_21_1 == "over" or arg_21_1 == "closed") then
			return
		end

		if not arg_17_1 then
			local var_21_0 = var_0_3(arg_21_1, "top") ~= nil

			arg_17_0.isPromotion:set(var_21_0)
		end

		if not arg_17_0.isPromotion:read() and arg_21_3 > 2 then
			local var_21_1 = "effect_jj_loop"

			if arg_21_3 == 4 then
				var_21_1 = "effect_gj_loop"
			end

			var_17_5:play(var_21_1)
			var_17_5:show()

			local var_21_2 = var_0_10(arg_21_4, arg_21_3)

			if var_21_2 then
				arg_17_0:initTopStageView(var_21_2)
			end
		else
			var_17_5:hide()

			local var_21_3

			if arg_17_0.isPromotion:read() then
				var_21_3 = var_0_8(arg_21_4, arg_21_2)
			elseif arg_21_3 < 3 then
				var_21_3 = var_0_9(arg_21_4, arg_21_3)
			end

			if var_21_3 then
				arg_17_0:initUI(var_21_3)
			end
		end

		local var_21_4 = var_0_3(arg_21_1, "^final3") ~= nil

		arg_17_0.inBattle:visible(not arg_17_1 and (not var_21_4 or arg_21_3 > 2))

		if not arg_17_1 then
			arg_17_0.delta = var_0_0.getNextStateTime(nil, true)

			var_17_9()
		end
	end)
	arg_17_0:schedule(function()
		local var_22_0 = arg_17_0.round:read()

		if arg_17_1 or var_22_0 == "over" or var_22_0 == "closed" then
			return false
		end

		arg_17_0.delta = var_0_0.getNextStateTime(nil, true)

		var_17_9()
	end, 1, 0)
end

function var_0_12.initModel(arg_23_0)
	arg_23_0.roleId = gGameModel.role:read("id")

	local var_23_0 = gGameModel.cross_craft

	arg_23_0.round = var_23_0:getIdler("round")
	arg_23_0.curTime = var_23_0:getIdler("time")
	arg_23_0.top8 = var_23_0:getIdler("top8_plays")

	if arg_23_0.isRecord:read() then
		arg_23_0.top8 = var_23_0:getIdler("last_top8_plays")
	end

	arg_23_0.history = var_23_0:read("history")
	arg_23_0.isSignup = var_0_0.isSigned()
end

function var_0_12.onCleanup(arg_24_0)
	arg_24_0._isPromotion = arg_24_0.isPromotion:read()
	arg_24_0._curPromotionPageIdx = arg_24_0.curPromotionPageIdx:read()
	arg_24_0._curTopstagePageIdx = arg_24_0.curTopstagePageIdx:read()

	var_0_11.onCleanup(arg_24_0)
end

function var_0_12.canShowResult(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_0.round:read()

	if arg_25_0.isRecord:read() or var_25_0 == "closed" or var_25_0 == "over" then
		return true
	end

	if not arg_25_1.result or arg_25_1.result == "" then
		return false
	end

	local var_25_1 = false

	if var_0_3(var_25_0, "final1") or var_0_3(var_25_0, "top64") then
		return var_25_1
	elseif var_0_3(var_25_0, "top32") and arg_25_2 <= 4 or var_0_3(var_25_0, "top16") and arg_25_2 <= 6 or var_0_3(var_25_0, "final2") and arg_25_2 <= 2 then
		var_25_1 = true
	elseif var_0_3(var_25_0, "final3") then
		return arg_25_0.curTopstagePageIdx:read() < 3
	end

	return var_25_1
end

function var_0_12.initUI(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0.isPromotion:read()
	local var_26_1 = arg_26_0.half1
	local var_26_2 = 3

	if var_26_0 then
		var_26_1, var_26_2 = arg_26_0.view1, 7
	end

	local var_26_3 = 0
	local var_26_4 = false

	var_26_1:stopAllActions()
	var_26_1:removeChildByName("cloneNode")
	var_26_1:removeChildByName("touxiang")

	for iter_26_0, iter_26_1 in ipairs(arg_26_1) do
		var_26_3 = var_26_3 + 1

		local var_26_5 = var_26_1:get("team" .. iter_26_0)

		var_26_5:removeChildByName("vsInfo")

		local var_26_6 = arg_26_0:canShowResult(iter_26_1, iter_26_0)
		local var_26_7 = {}

		if var_26_6 then
			var_26_7[1] = iter_26_1.result == "win" and "city/pvp/craft/icon_win.png" or "city/pvp/craft/icon_lose.png"
			var_26_7[2] = iter_26_1.result == "win" and "city/pvp/craft/icon_lose.png" or "city/pvp/craft/icon_win.png"
		end

		var_26_5:get("btnReplay"):visible(var_26_6)
		var_26_5:get("win"):hide()
		var_26_5:get("fail"):hide()

		for iter_26_2 = 1, 2 do
			local var_26_8 = var_26_5:get("item" .. iter_26_2)

			var_26_8:get("normal"):hide()

			local var_26_9 = iter_26_1["role" .. iter_26_2]

			var_26_8:get("textLv"):text("Lv" .. var_26_9.level)
			text.addEffect(var_26_8:get("textLv"), {
				outline = {
					size = 2,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			})
			text.addEffect(var_26_8:get("textName"), {
				outline = {
					size = 2,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			})
			var_26_8:get("textName"):text(var_26_9.name)
			var_26_8:get("textLv"):show()
			var_26_8:get("textName"):show()
			bind.extend(arg_26_0, var_26_8:get("head"), {
				class = "role_logo",
				props = {
					vip = false,
					level = false,
					logoId = var_26_9.logo,
					frameId = var_26_9.frame,
					onNode = function(arg_27_0)
						if var_26_9.frame ~= 1 then
							return
						end

						if var_26_0 then
							var_0_4(arg_27_0, iter_26_0, iter_26_2)
						else
							var_0_5(arg_27_0, iter_26_0, iter_26_2)
						end
					end
				}
			})
			var_26_8:get("imgFlag"):hide()

			if var_26_6 then
				var_26_8:get("imgFlag"):texture(var_26_7[iter_26_2])
				var_26_8:get("imgFlag"):show()
				var_26_5:get(iter_26_1.result):show()
				bind.click(arg_26_0, var_26_5:get("btnReplay"), {
					method = function()
						arg_26_0:onReplay(iter_26_1)
					end
				})
			end

			bind.click(arg_26_0, var_26_8:get("head"), {
				method = function()
					local var_29_0 = arg_26_0.round:read()

					if var_26_0 and var_0_3(var_29_0, "top") == nil then
						var_29_0 = "top"
					end

					arg_26_0:onShowTeamInfo(var_26_9, var_29_0)
				end
			})
		end

		var_26_5:get("imgFlag"):hide()

		if not var_26_6 and var_0_6(arg_26_0.round:read()) then
			local var_26_10, var_26_11 = var_26_5:get("imgFlag"):xy()
			local var_26_12 = -40

			if not arg_26_0.isPromotion:read() and arg_26_0.curTopstagePageIdx:read() <= 2 and iter_26_0 == 3 then
				var_26_12 = 140
			end

			widget.addAnimationByKey(var_26_5, "kuafushiying/vs.skel", "vsInfo", "effect_loop2", 6):scale(2):xy(var_26_10, var_26_11 + var_26_12)
		end

		if iter_26_0 == var_26_2 and var_26_6 then
			var_26_4 = true

			local var_26_13 = iter_26_1.result == "win" and iter_26_1.role1 or iter_26_1.role2
			local var_26_14 = var_26_1:get("winner")

			var_26_14:get("normal"):hide()
			var_26_14:get("textLv"):text("Lv" .. var_26_13.level)
			text.addEffect(var_26_14:get("textLv"), {
				outline = {
					size = 2,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			})
			text.addEffect(var_26_14:get("textName"), {
				outline = {
					size = 2,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			})
			var_26_14:get("textName"):text(var_26_13.name)
			var_26_14:get("textLv"):show()
			var_26_14:get("textName"):show()
			bind.extend(arg_26_0, var_26_14:get("head"), {
				class = "role_logo",
				props = {
					vip = false,
					level = false,
					logoId = var_26_13.logo,
					frameId = var_26_13.frame
				}
			})
			bind.click(arg_26_0, var_26_14:get("head"), {
				method = function()
					arg_26_0:onShowTeamInfo(var_26_13, var_26_0 and "top" or "final")
				end
			})

			if arg_26_0.isRecord:read() then
				break
			end

			local var_26_15 = var_26_14:getChildren()

			for iter_26_3, iter_26_4 in ipairs(var_26_15) do
				iter_26_4:hide()
			end

			var_26_14:get("normal"):show()
			var_26_14:get("imgNameBg"):show()
			var_26_14:get("imgHeadBg"):show()

			local var_26_16 = var_26_14:clone()
			local var_26_17 = var_26_16:getChildren()

			for iter_26_5, iter_26_6 in ipairs(var_26_17) do
				iter_26_6:hide()
			end

			local var_26_18 = gGameUI:getConvertPos(var_26_14:get("head"), var_26_1)
			local var_26_19 = var_26_18.x
			local var_26_20 = var_26_18.y

			var_26_16:xy(var_26_19, var_26_20)
			var_26_16:addTo(var_26_1, 1000, "cloneNode")
			var_26_16:show()
			var_26_16:get("head"):show()
			bind.extend(arg_26_0, var_26_16:get("head"), {
				class = "role_logo",
				props = {
					vip = false,
					level = false,
					logoId = var_26_13.logo,
					frameId = var_26_13.frame,
					onNode = function(arg_31_0)
						arg_31_0:y(arg_31_0:y() - 20)
					end
				}
			})

			local var_26_21 = widget.addAnimationByKey(var_26_1, "shiyingdahui/xzs_touxiang.skel", "touxiang", "xiaozusai_touxiang", 100):scale(1.6666666666666667):xy(var_26_19, var_26_20)

			performWithDelay(var_26_1, function()
				var_26_1:get("cloneNode"):stopAllActions()
				performWithDelay(var_26_1, function()
					var_26_1:removeChildByName("cloneNode")
					var_26_1:removeChildByName("touxiang")

					local var_33_0 = var_26_14:getChildren()

					for iter_33_0, iter_33_1 in ipairs(var_33_0) do
						iter_33_1:show()
					end

					var_26_14:get("normal"):hide()
				end, 0.016666666666666666)
			end, 1.75)

			local var_26_22 = cc.RepeatForever:create(cc.Sequence:create(cc.CallFunc:create(function()
				local var_34_0, var_34_1 = var_26_21:getPosition()
				local var_34_2 = "node_move"
				local var_34_3 = var_26_21:getScaleX()
				local var_34_4 = var_26_21:getScaleY()
				local var_34_5 = var_26_21:getBonePosition(var_34_2)
				local var_34_6 = var_26_21:getBoneRotation(var_34_2)
				local var_34_7 = var_26_21:getBoneScaleX(var_34_2)
				local var_34_8 = var_26_21:getBoneScaleY(var_34_2)

				var_26_16:rotate(-var_34_6):scaleX(var_34_7):scaleY(var_34_8):xy(var_34_5.x * var_34_3 + var_34_0, var_34_5.y * var_34_4 + var_34_1)
			end)))

			var_26_16:runAction(var_26_22)
		end
	end

	for iter_26_7 = var_26_3 + 1, var_26_2 do
		local var_26_23 = var_26_1:get("team" .. iter_26_7)

		var_26_23:get("item1.imgFlag"):hide()
		var_26_23:get("item1.textLv"):hide()
		var_26_23:get("item1.textName"):hide()
		var_26_23:get("item1.normal"):show()
		var_26_23:get("item2.imgFlag"):hide()
		var_26_23:get("item2.textLv"):hide()
		var_26_23:get("item2.textName"):hide()
		var_26_23:get("item2.normal"):show()
		var_26_23:get("btnReplay"):hide()
		var_26_23:get("imgFlag"):hide()
		var_26_23:get("win"):hide()
		var_26_23:get("fail"):hide()
		text.addEffect(var_26_23:get("item1.normal.textNote"), {
			outline = {
				size = 2,
				color = ui.NEWCOLORS.OUTLINE.BLACK
			}
		})
	end

	if not var_26_4 then
		var_26_1:get("winner.textLv"):hide()
		var_26_1:get("winner.textName"):hide()
		var_26_1:get("winner.normal"):show()
	end
end

function var_0_12.initTopStageView(arg_35_0, arg_35_1)
	local var_35_0 = gRoleFigureCsv
	local var_35_1 = csv.cards
	local var_35_2 = csv.unit
	local var_35_3 = arg_35_0.half2
	local var_35_4 = arg_35_0:canShowResult(arg_35_1)
	local var_35_5 = {}

	var_35_3:get("btnReplay"):visible(var_35_4)

	if var_35_4 then
		var_35_5[1] = arg_35_1.result == "win" and "city/pvp/craft/icon_win.png" or "city/pvp/craft/icon_lose.png"
		var_35_5[2] = arg_35_1.result == "win" and "city/pvp/craft/icon_lose.png" or "city/pvp/craft/icon_win.png"

		bind.touch(arg_35_0, var_35_3:get("btnReplay"), {
			methods = {
				ended = function()
					arg_35_0:onReplay(arg_35_1)
				end
			}
		})
	end

	if not var_35_4 and var_0_6(arg_35_0.round:read()) then
		local var_35_6, var_35_7 = var_35_3:get("btnReplay"):xy()

		widget.addAnimationByKey(var_35_3, "kuafushiying/vs.skel", "vsInfo", "effect_loop2", 6):scale(2):xy(var_35_6, var_35_7 + 130)
	end

	for iter_35_0 = 1, 2 do
		local var_35_8 = arg_35_1["role" .. iter_35_0]
		local var_35_9 = var_35_3:get("item" .. iter_35_0)

		var_35_9:get("role"):removeChildByName("figure")
		var_35_9:get("info1.textName"):text(var_35_8.name)
		var_35_9:get("info1.textFightPoint"):text(var_35_8.display.fighting_point)

		local var_35_10 = string.format(gLanguageCsv.brackets, getServerArea(var_35_8.game_key, true))

		var_35_9:get("info1.textLvAndSer"):text("Lv" .. var_35_8.level .. " " .. var_35_10)
		text.addEffect(var_35_9:get("info1.textName"), {
			outline = {
				size = 2,
				color = ui.NEWCOLORS.OUTLINE.BLACK
			}
		})
		text.addEffect(var_35_9:get("info1.textFightPoint"), {
			outline = {
				size = 2,
				color = ui.NEWCOLORS.OUTLINE.BLACK
			}
		})
		text.addEffect(var_35_9:get("info1.textLvAndSer"), {
			outline = {
				size = 2,
				color = ui.NEWCOLORS.OUTLINE.BLACK
			}
		})
		text.addEffect(var_35_9:get("info1.textNote"), {
			outline = {
				size = 2,
				color = ui.NEWCOLORS.OUTLINE.BLACK
			}
		})
		adapt.oneLinePos(var_35_9:get("info1.textName"), var_35_9:get("info1.imgVip"), cc.p(15, 0))
		adapt.oneLinePos(var_35_9:get("info1.textNote"), var_35_9:get("info1.textFightPoint"), cc.p(10, 0))

		local var_35_11 = var_35_8.vip

		var_35_9:get("info1.imgVip"):visible(var_35_11 > 0)

		if var_35_11 > 0 then
			local var_35_12 = string.format("common/icon/vip/icon_vip%d.png", var_35_11)

			var_35_9:get("info1.imgVip"):texture(var_35_12)
		end

		local var_35_13

		var_35_13 = iter_35_0 == 2 and -1 or 1

		local var_35_14 = var_35_8.display.top_card
		local var_35_15 = var_35_8.display.skin_id
		local var_35_16 = dataEasy.getUnitCsv(var_35_14, var_35_15)
		local var_35_17 = var_35_0[var_35_8.figure]
		local var_35_18 = var_35_9:size()
		local var_35_19 = iter_35_0 == 2 and 200 or 0

		if string.len(var_35_17.resSpine or "") > 0 then
			widget.addAnimationByKey(var_35_9:get("role"), var_35_17.resSpine, "figure", "standby_loop", 2):xy(var_35_18.width / 2 + var_35_19, var_35_18.height / 5 - 15):scale(1.2):anchorPoint(0.5, 0.5)
		end

		bind.extend(arg_35_0, var_35_9, {
			event = "extend",
			class = "role_title",
			props = {
				data = var_35_8.title,
				onNode = function(arg_37_0)
					arg_37_0:xy(var_35_18.width / 2, var_35_18.height - 100)
					arg_37_0:scale(2)
					arg_37_0:z(3)
				end
			}
		})
		var_35_9:get("imgResult"):visible(var_35_4)

		if var_35_4 then
			var_35_9:get("imgResult"):texture(var_35_5[iter_35_0])
		end

		bind.click(arg_35_0, var_35_9, {
			method = function()
				arg_35_0:onShowTeamInfo(var_35_8)
			end
		})
	end
end

function var_0_12.onChangePromotionPage(arg_39_0, arg_39_1, arg_39_2)
	arg_39_0.view1:stopAllActions()
	arg_39_0.curPromotionPageIdx:set(arg_39_2)
	arg_39_0.titlePath:set(arg_39_0.listData1:atproxy(arg_39_2).str)
end

function var_0_12.onChangeTopStafePage(arg_40_0, arg_40_1, arg_40_2)
	if not arg_40_0.isRecord:read() and not arg_40_0.isPromotion:read() and var_0_3(arg_40_0.round:read(), "final3") == nil and arg_40_2 > 2 then
		gGameUI:showTip(gLanguageCsv.notStartFighting)

		return
	end

	arg_40_0.half1:stopAllActions()
	arg_40_0.curTopstagePageIdx:set(arg_40_2)

	local var_40_0 = math.min(arg_40_2, 2)

	arg_40_0.titleType:set(var_40_0)
end

function var_0_12.onChangePage(arg_41_0, arg_41_1)
	local var_41_0 = arg_41_1 == var_0_1.promotion

	arg_41_0.isPromotion:set(var_41_0)
	arg_41_0.btnPromotion:setTouchEnabled(not var_41_0)
	arg_41_0.btnPromotion:setBright(not var_41_0)
	arg_41_0.btnFinal:setTouchEnabled(var_41_0)
	arg_41_0.btnFinal:setBright(var_41_0)

	local var_41_1 = ui.NEWCOLORS.OUTLINE.YELLOW
	local var_41_2 = ui.NEWCOLORS.OUTLINE.YELLOW

	if var_41_0 then
		var_41_1, var_41_2 = var_41_2, var_41_1
	end

	text.addEffect(arg_41_0.btnPromotionNote, {
		outline = {
			color = var_41_1
		}
	})
	text.addEffect(arg_41_0.btnFinalNote, {
		outline = {
			color = var_41_2
		}
	})
	arg_41_0.refresh:set(not arg_41_0.refresh:read())
end

function var_0_12.onEnterMySchedule(arg_42_0)
	gGameUI:stackUI("city/pvp/cross_craft/myschedule", nil, {
		full = true
	}, true)
end

function var_0_12.onShowTeamInfo(arg_43_0, arg_43_1, arg_43_2)
	gGameApp:requestServer("/game/cross/craft/battle/enemy/get", function(arg_44_0)
		gGameUI:stackUI("city.pvp.cross_craft.array_info", nil, nil, arg_44_0.view, arg_43_2)
	end, arg_43_1.game_key, arg_43_1.role_db_id, arg_43_1.record_db_id)
end

function var_0_12.onReplay(arg_45_0, arg_45_1)
	local var_45_0 = "/game/cross/craft/playrecord/get"

	gGameModel:playRecordBattle(arg_45_1.play_id, arg_45_1.cross_key, var_45_0, 2, arg_45_0.roleId)
end

return var_0_12
