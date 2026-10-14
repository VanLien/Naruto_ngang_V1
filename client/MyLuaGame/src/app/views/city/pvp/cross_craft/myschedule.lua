local var_0_0 = require("app.views.city.pvp.cross_craft.view")
local var_0_1 = string.find

local function var_0_2(arg_1_0)
	return var_0_1(arg_1_0, "_lock") ~= nil
end

local function var_0_3(arg_2_0)
	return arg_2_0 == "over" or arg_2_0 == "closed"
end

local function var_0_4(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	for iter_3_0, iter_3_1 in ipairs(arg_3_1) do
		local var_3_0 = arg_3_0.item:get("fight"):get(iter_3_1):x()

		arg_3_3[iter_3_1]:x(var_3_0 + arg_3_2)
	end
end

local function var_0_5(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_0.item:size()
	local var_4_1 = 530

	if arg_4_3.round == "time" then
		var_4_1 = 260
	elseif arg_4_3.round == "out" then
		var_4_1 = 120
	elseif not arg_4_3.paths then
		var_4_1 = 349
	end

	arg_4_1:size(var_4_0.width + arg_4_0.deltaWidth, var_4_1)
	arg_4_1:get("ended"):size(var_4_0.width + arg_4_0.deltaWidth, var_4_1)
	arg_4_1:get("time"):size(var_4_0.width + arg_4_0.deltaWidth, var_4_1)
	arg_4_1:get("fight"):size(var_4_0.width + arg_4_0.deltaWidth, var_4_1)
	arg_4_1:get("time"):xy((var_4_0.width + arg_4_0.deltaWidth) / 2, var_4_1 / 2)
	arg_4_1:get("fight"):xy((var_4_0.width + arg_4_0.deltaWidth) / 2, var_4_1 / 2)
	arg_4_1:get("ended"):xy((var_4_0.width + arg_4_0.deltaWidth) / 2, var_4_1 / 2)
	arg_4_1:get("time"):visible(arg_4_3.round == "time")
	arg_4_1:get("fight"):visible(arg_4_3.round ~= "out" and arg_4_3.round ~= "time")
	arg_4_1:get("ended"):visible(arg_4_3.round == "out")
	arg_4_1:get("fight.title"):visible(arg_4_3.paths ~= nil)

	local var_4_2 = arg_4_1:get("fight.imgBg"):size()

	arg_4_1:get("fight.imgBg"):size(1207 + arg_4_0.deltaWidth / 2, var_4_2.height)
	arg_4_1:get("fight.imgBg"):x((2414 + arg_4_0.deltaWidth) / 2)
	arg_4_0:enableSchedule()
	arg_4_0:unSchedule(arg_4_2)
	arg_4_1:get("fight"):removeChildByName("_leftIcon")
	arg_4_1:get("fight"):removeChildByName("_rightIcon")

	local var_4_3 = arg_4_1:get("fight"):multiget("imgResultL", "imgResultR", "imgIconL", "imgIconR", "infoL", "infoR", "imgTitle", "imgBox", "btnReplay", "textNote", "textTime", "imgLeftIcon1", "imgLeftIcon2", "imgLeftIcon3", "imgRightIcon1", "imgRightIcon2", "imgRightIcon3", "title")
	local var_4_4 = {
		out = function()
			local var_5_0 = (2412 + arg_4_0.deltaWidth) / 2
			local var_5_1 = 60

			arg_4_1:get("ended.imgBg"):size(1206 + arg_4_0.deltaWidth / 2, 76)
			arg_4_1:get("ended.imgBg"):xy(arg_4_1:get("ended"):size().width / 2, var_5_1)
			arg_4_1:get("ended.textTip"):text(arg_4_3.str)
			arg_4_1:get("ended.textTip"):xy(var_5_0, var_5_1)
		end,
		time = function()
			local var_6_0 = {
				"textNote",
				"imgBg",
				"textTime"
			}

			for iter_6_0, iter_6_1 in ipairs(var_6_0) do
				local var_6_1 = arg_4_0.item:get("time"):get(iter_6_1):x()

				arg_4_1:get("time"):get(iter_6_1):x(var_6_1 + arg_4_0.deltaWidth / 2 + 15)
			end

			local var_6_2 = arg_4_0.round:read()
			local var_6_3 = var_0_0.getNextStateTime(var_6_2 == "halftime" and "prepare2" or nil, true)

			arg_4_1:get("time.textTime"):text(time.getCutDown(var_6_3).str)
			arg_4_0:schedule(function()
				local var_7_0 = arg_4_0.round:read()

				if arg_4_3.useRound ~= var_7_0 then
					return false
				end

				var_6_3 = var_0_0.getNextStateTime(var_7_0 == "halftime" and "prepare2" or nil, true)

				arg_4_1:get("time.textTime"):text(time.getCutDown(var_6_3).str)
			end, 1, 0, arg_4_2)
		end
	}

	if var_4_4[arg_4_3.round] then
		var_4_4[arg_4_3.round]()

		return
	end

	local var_4_5 = {
		"imgResultR",
		"imgIconR",
		"infoR",
		"imgRightIcon1",
		"imgRightIcon2",
		"imgRightIcon3"
	}
	local var_4_6 = {
		"imgBox",
		"imgTitle",
		"btnReplay",
		"textNote",
		"textTime",
		"title"
	}

	var_0_4(arg_4_0, var_4_5, arg_4_0.deltaWidth + 25, var_4_3)
	var_0_4(arg_4_0, var_4_6, arg_4_0.deltaWidth / 2 + 15, var_4_3)
	var_4_3.imgTitle:hide()

	if arg_4_3.path then
		var_4_3.imgTitle:texture(arg_4_3.path)
		var_4_3.imgTitle:show()
	end

	if arg_4_3.paths then
		var_4_3.title:get("imgTitle1"):hide()
		var_4_3.title:get("imgTitle2"):hide()

		local var_4_7 = {}

		for iter_4_0, iter_4_1 in ipairs(arg_4_3.paths) do
			local var_4_8 = var_4_3.title:get("imgTitle" .. iter_4_0)

			var_4_8:texture(iter_4_1)
			table.insert(var_4_7, var_4_8)
			var_4_8:show()
		end

		adapt.oneLineCenterPos(cc.p(250, 60), var_4_7, cc.p(5, 0))
	end

	var_4_3.infoL:get("textFightPoint"):text(arg_4_3.fighting_point)

	local var_4_9 = userDefault.getForeverLocalKey("serverKey", nil, {
		rawKey = true
	})
	local var_4_10 = getServerArea(var_4_9, true)

	var_4_3.infoL:get("textNameAndSer"):text(string.format("%s %s", arg_4_0.roleName, var_4_10))
	var_4_3.infoL:get("textLv"):text("lv" .. arg_4_0.level)
	text.addEffect(var_4_3.infoL:get("textLv"), {
		outline = {
			color = cc.c4b(153, 46, 82, 255)
		}
	})
	text.addEffect(var_4_3.infoL:get("textNameAndSer"), {
		outline = {
			color = cc.c4b(153, 46, 82, 255)
		}
	})
	text.addEffect(var_4_3.infoL:get("textNote"), {
		outline = {
			color = cc.c4b(153, 46, 82, 255)
		}
	})
	text.addEffect(var_4_3.infoL:get("textFightPoint"), {
		outline = {
			color = cc.c4b(153, 46, 82, 255)
		}
	})
	text.addEffect(var_4_3.infoR:get("textLv"), {
		outline = {
			color = cc.c4b(31, 92, 153, 255)
		}
	})
	text.addEffect(var_4_3.infoR:get("textNameAndSer"), {
		outline = {
			color = cc.c4b(31, 92, 153, 255)
		}
	})
	text.addEffect(var_4_3.infoR:get("textNote"), {
		outline = {
			color = cc.c4b(31, 92, 153, 255)
		}
	})
	text.addEffect(var_4_3.infoR:get("textFightPoint"), {
		outline = {
			color = cc.c4b(31, 92, 153, 255)
		}
	})
	text.addEffect(var_4_3.infoR:get("textLK"), {
		outline = {
			color = cc.c4b(31, 92, 153, 255)
		}
	})

	local var_4_11 = gRoleFigureCsv
	local var_4_12 = var_4_11[arg_4_0.figure]
	local var_4_13, var_4_14 = var_4_3.imgIconL:xy()
	local var_4_15 = cc.Sprite:create(var_4_12.res):anchorPoint(0.5, 1):xy(var_4_13, var_4_14 + 380):scale(0.8):addTo(arg_4_1:get("fight"), 2, "_leftIcon")
	local var_4_16 = var_4_15:size()
	local var_4_17 = cc.rect(0, 0, var_4_16.width, 404)

	var_4_15:setTextureRect(var_4_17)
	var_4_3.imgIconL:hide()

	local var_4_18, var_4_19 = var_4_3.imgIconR:xy()

	var_4_3.imgIconR:hide()

	local function var_4_20(arg_8_0)
		arg_8_0 = arg_8_0 or "config/big_role/show/img_21.png"

		local var_8_0 = cc.Sprite:create(arg_8_0):anchorPoint(0.5, 1):xy(var_4_18, var_4_19 + 380):scale(0.8):addTo(arg_4_1:get("fight"), 2, "_rightIcon")
		local var_8_1 = var_8_0:size()
		local var_8_2 = cc.rect(0, 0, var_8_1.width, 404)

		var_8_0:setTextureRect(var_8_2)

		return var_8_0
	end

	local function var_4_21()
		var_4_3.infoR:get("textFightPoint"):text(arg_4_3.enemy.fighting_point)
		var_4_3.infoR:get("textLv"):text("lv" .. arg_4_3.enemy.level)

		local var_9_0 = getServerArea(arg_4_3.enemy.game_key, true)

		var_4_3.infoR:get("textNameAndSer"):text(string.format("%s %s", var_9_0, arg_4_3.enemy.name))
	end

	local function var_4_22()
		var_4_3.infoR:get("textLv"):text("???")
		var_4_3.infoR:get("textNameAndSer"):text(gLanguageCsv.whoIsMe)
	end

	local var_4_23 = not itertools.isempty(arg_4_3.enemy)

	var_4_3.infoR:get("textFightPoint"):visible(var_4_23)
	var_4_3.infoR:get("textNote"):visible(var_4_23)
	var_4_3.infoR:get("btnShowInfo"):visible(var_4_23)
	var_4_3.infoR:get("textLK"):visible(not var_4_23)

	local var_4_24 = arg_4_0.round:read()

	if var_4_24 == "prepare" or var_4_24 == "prepare2" then
		var_4_3.infoR:get("textLK"):hide()
	end

	local var_4_25 = "city/pvp/craft/icon_pk.png"

	for iter_4_2, iter_4_3 in ipairs(arg_4_3.cards) do
		local var_4_26 = dataEasy.getUnitCsv(iter_4_3[2], iter_4_3[3]).iconSimple

		var_4_3["imgLeftIcon" .. iter_4_2]:texture(var_4_26)
	end

	if var_4_23 then
		var_4_21()
		var_4_20(var_4_11[arg_4_3.enemy.figure].res)

		for iter_4_4, iter_4_5 in ipairs(arg_4_3.enemy.cards) do
			local var_4_27 = dataEasy.getUnitCsv(iter_4_5[2], iter_4_5[3]).iconSimple

			var_4_3["imgRightIcon" .. iter_4_4]:setColor(cc.c3b(255, 255, 255))
			var_4_3["imgRightIcon" .. iter_4_4]:setOpacity(255)
			var_4_3["imgRightIcon" .. iter_4_4]:texture(var_4_27)
		end
	else
		var_4_22()

		for iter_4_6 = 1, 3 do
			var_4_3["imgRightIcon" .. iter_4_6]:setColor(cc.c3b(0, 0, 0))
			var_4_3["imgRightIcon" .. iter_4_6]:setOpacity(125)
		end

		local var_4_28 = var_4_20()

		var_4_28:setColor(cc.c3b(0, 0, 0))
		var_4_28:setOpacity(125)
	end

	text.addEffect(var_4_3.textNote, {
		outline = {
			size = 3,
			color = cc.c4b(34, 15, 52, 255)
		}
	})
	text.addEffect(var_4_3.textTime, {
		outline = {
			size = 3,
			color = cc.c4b(34, 15, 52, 255)
		}
	})
	var_4_3.imgResultL:hide()
	var_4_3.imgResultR:hide()

	local var_4_29 = true
	local var_4_30 = arg_4_0.round:read()
	local var_4_31 = var_0_1(var_4_30, "_lock$")

	if var_4_31 then
		var_4_30 = string.sub(var_4_30, 1, var_4_31 - 1)
	end

	local var_4_32 = arraytools.hash(game.CROSS_CRAFT_ROUNDS, true)

	if not arg_4_0.isRecord:read() then
		var_4_29 = var_4_32[var_4_30] > var_4_32[arg_4_3.round]
	end

	var_4_3.btnReplay:visible(var_4_29 and var_4_23)
	var_4_3.textNote:visible(not var_4_29 and not var_0_1(arg_4_3.round, "prepare"))
	var_4_3.textTime:visible(not var_4_29 and not var_0_1(arg_4_3.round, "prepare"))

	if var_4_29 then
		local var_4_33 = "config/item/icon_lmdh2.png"

		if arg_4_3.result then
			local var_4_34 = "city/pvp/craft/icon_lose.png"
			local var_4_35 = "city/pvp/craft/icon_win.png"
			local var_4_36 = "imgLeftIcon"

			if arg_4_3.result == "win" then
				var_4_34, var_4_35 = var_4_35, var_4_34
				var_4_36 = "imgRightIcon"
				var_4_33 = "config/item/icon_lmdh1.png"
			end

			var_4_3.imgResultL:texture(var_4_34)
			var_4_3.imgResultR:texture(var_4_35)
			var_4_3.imgResultL:show()
			var_4_3.imgResultR:show()

			for iter_4_7 = 1, 3 do
				cache.setShader(var_4_3[var_4_36 .. iter_4_7], false, "hsl_gray_white")
			end
		end

		var_4_3.imgBox:texture(var_4_33)
		var_4_3.imgBox:scale(2)
	elseif not var_0_1(arg_4_3.round, "prepare") then
		var_4_3.imgBox:hide()

		local var_4_37 = var_0_0.getNextStateTime(nil, true)
		local var_4_38 = time.getCutDown(var_4_37)

		var_4_3.textNote:text("")

		local var_4_39 = widget.addAnimationByKey(arg_4_1:get("fight"), "kuafushiying/vs.skel", "vsSpine", "effect_loop", 3):scale(2)
		local var_4_40

		local function var_4_41(arg_11_0)
			local var_11_0 = var_0_2(arg_11_0)
			local var_11_1 = gLanguageCsv.stateReady

			if var_11_0 then
				var_11_1 = gLanguageCsv.stateFighting
			end

			var_4_3.textNote:text(var_11_1 .. ":")

			local var_11_2 = time.getCutDown(var_4_37)

			var_4_3.textTime:text(var_11_2.min_sec_clock)

			if var_4_40 ~= arg_11_0 then
				var_4_40 = arg_11_0

				local var_11_3 = "effect_loop"
				local var_11_4 = -15

				if var_0_2(arg_11_0) then
					var_11_3 = "effect_loop2"
					var_11_4 = -40
				end

				local var_11_5, var_11_6 = var_4_3.imgBox:xy()

				var_4_39:xy(var_11_5, var_11_6 + var_11_4):play(var_11_3)
			end
		end

		var_4_41(arg_4_0.round:read())
		arg_4_0:schedule(function()
			var_4_37 = var_0_0.getNextStateTime(nil, true)

			local var_12_0 = arg_4_0.round:read()
			local var_12_1 = var_12_0
			local var_12_2 = var_0_1(var_12_1, "_lock$")

			if var_12_2 then
				var_12_1 = string.sub(var_12_1, 1, var_12_2 - 1)
			end

			if arg_4_3.round ~= var_12_0 and arg_4_3.round ~= var_12_1 then
				return false
			end

			var_4_41(arg_4_0.round:read())
		end, 1, 0, arg_4_2)
	else
		var_4_3.imgBox:hide()

		local var_4_42, var_4_43 = var_4_3.imgBox:xy()

		widget.addAnimationByKey(arg_4_1:get("fight"), "kuafushiying/vs.skel", "vsSpine", "effect_loop", 3):scale(2):xy(var_4_42, var_4_43 - 15)
	end

	adapt.oneLineCenterPos(cc.p(700, 50), {
		var_4_3.infoL:get("textNote"),
		var_4_3.infoL:get("textFightPoint")
	}, cc.p(10, 0))
	adapt.oneLineCenterPos(cc.p(250, 50), {
		var_4_3.infoR:get("textNote"),
		var_4_3.infoR:get("textFightPoint")
	}, cc.p(10, 0))
	bind.touch(arg_4_0, var_4_3.btnReplay, {
		methods = {
			ended = functools.partial(arg_4_0.clickCell, arg_4_2, arg_4_3)
		}
	})
	bind.click(arg_4_0, var_4_3.infoL, {
		method = functools.partial(arg_4_0.showMyInfo, arg_4_2, arg_4_3)
	})

	if not itertools.isempty(arg_4_3.enemy) then
		bind.click(arg_4_0, var_4_3.infoR, {
			method = functools.partial(arg_4_0.showEnemyInfo, arg_4_2, arg_4_3)
		})
	end
end

local var_0_6 = cc.load("mvc").ViewBase
local var_0_7 = class("CrossCraftMainScheduleView", var_0_6)

var_0_7.RESOURCE_FILENAME = "cross_craft_myschedule.json"
var_0_7.RESOURCE_BINDING = {
	slider = "slider",
	item = "item",
	info = "infoPanel",
	recordBg = {
		varname = "recordBg",
		binds = {
			event = "visible",
			idler = bindHelper.self("isRecord")
		}
	},
	["info.textVal1"] = {
		varname = "textVal1",
		binds = {
			{
				event = "text",
				idler = bindHelper.self("winAndloseNum")
			}
		}
	},
	["info.textVal2"] = {
		varname = "textVal2",
		binds = {
			{
				event = "text",
				idler = bindHelper.self("pointNum")
			}
		}
	},
	listview = {
		varname = "speList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				backupCached = false,
				padding = 0,
				data = bindHelper.self("fightDatas"),
				item = bindHelper.self("item"),
				sliderBg = bindHelper.self("slider"),
				level = bindHelper.self("level"),
				roleName = bindHelper.self("roleName"),
				figure = bindHelper.self("figure"),
				round = bindHelper.self("round"),
				isRecord = bindHelper.self("isRecord"),
				deltaWidth = bindHelper.self("deltaWidth"),
				info = bindHelper.self("info"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
					var_0_5(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				end,
				onBeforeBuild = function(arg_14_0)
					if arg_14_0.sliderBg:visible() then
						local var_14_0 = arg_14_0:size()
						local var_14_1, var_14_2 = arg_14_0:xy()
						local var_14_3 = arg_14_0.sliderBg:size()

						arg_14_0.sliderBg:x(var_14_1 + var_14_0.width - var_14_3.width)

						local var_14_4, var_14_5 = arg_14_0.sliderBg:xy()

						arg_14_0.sliderBg:show()
						arg_14_0:setScrollBarEnabled(true)
						arg_14_0:setScrollBarColor(cc.c3b(245, 156, 2))
						arg_14_0:setScrollBarOpacity(255)
						arg_14_0:setScrollBarAutoHideEnabled(false)
						arg_14_0:setScrollBarPositionFromCorner(cc.p(var_14_1 + var_14_0.width - var_14_4, (var_14_0.height - var_14_3.height) / 2 + 5))
						arg_14_0:setScrollBarWidth(var_14_3.width)
						arg_14_0:refreshView()
					else
						arg_14_0:setScrollBarEnabled(false)
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
	}
}

local function var_0_8(arg_15_0, arg_15_1)
	local var_15_0, var_15_1 = var_0_1(arg_15_0, "^pre[1-4]")
	local var_15_2, var_15_3 = var_0_1(arg_15_0, "^top%d+")
	local var_15_4, var_15_5 = var_0_1(arg_15_0, "^final%d+")
	local var_15_6
	local var_15_7

	if var_15_0 then
		return var_0_1(arg_15_1, arg_15_0) or string.sub(arg_15_0, var_15_1 + 1, var_15_1 + 1) == "4"
	elseif var_15_2 and string.sub(arg_15_0, var_15_2 + 3, var_15_3) == "16" then
		return var_0_1(arg_15_1, arg_15_0) or true
	elseif var_15_4 and string.sub(arg_15_0, var_15_4 + 5, var_15_5) == "3" then
		return var_0_1(arg_15_1, arg_15_0) or true
	end

	return false
end

function var_0_7.onCreate(arg_16_0, arg_16_1)
	if arg_16_1 then
		gGameUI.topuiManager:createView("default", arg_16_0, {
			onClose = arg_16_0:createHandler("onClose")
		}):init({
			subTitle = "",
			title = "common/txt/txt_bt_kuafurenzhedasai.png"
		})
	end

	arg_16_0.deltaWidth = adapt.centerWithScreen("left", "right", nil, {
		{
			arg_16_0.speList,
			"pos",
			"left"
		},
		{
			arg_16_0.speList,
			"width"
		},
		{
			arg_16_0.infoPanel,
			"pos",
			"left"
		}
	})
	arg_16_0.isRecord = idler.new(arg_16_1)

	arg_16_0:initModel()

	arg_16_0.rounds = {}
	arg_16_0.titleTypeCache = {}
	arg_16_0.fightDatas = idlers.newWithMap({})
	arg_16_0.winAndloseNum = idler.new(string.format(gLanguageCsv.winAndLoseNum, 0, 0))
	arg_16_0.pointNum = idler.new(0)

	local var_16_0 = -1

	idlereasy.any({
		arg_16_0.history,
		arg_16_0.vsinfo,
		arg_16_0.curTime,
		arg_16_0.round,
		arg_16_0.info,
		arg_16_0.infoCards,
		arg_16_0.cardAttrs
	}, function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
		local function var_17_0()
			if not arg_16_1 and (arg_17_4 == "over" or arg_17_4 == "closed") then
				return
			end

			local var_18_0 = arg_16_0.speList:getItemsMargin()
			local var_18_1 = 0

			arg_16_0.rounds = {
				"halftime"
			}
			arg_16_0.titleTypeCache = {}

			local var_18_2 = {}
			local var_18_3 = #arg_17_1
			local var_18_4 = 0
			local var_18_5 = 0
			local var_18_6 = 0
			local var_18_7 = 0

			for iter_18_0 = var_18_3, 1, -1 do
				var_18_4 = var_18_4 + 1

				local var_18_8 = clone(arg_17_1[iter_18_0])

				table.insert(arg_16_0.rounds, var_18_8.round)

				var_18_8.path = arg_16_0:getTitleRes(var_18_8.round)
				var_18_8.showTime = arg_17_3

				if var_0_8(var_18_8.round, arg_17_4) then
					var_18_8.paths = arg_16_0:getItemTitle(var_18_8.round)
				end

				table.insert(var_18_2, var_18_8)

				local var_18_9 = 415

				if not paths then
					var_18_9 = 349
				end

				var_18_1 = var_18_1 + var_18_9

				if var_18_8.result == "win" then
					var_18_5 = var_18_5 + 1
				elseif var_18_8.result == "fail" then
					var_18_6 = var_18_6 + 1
				end

				var_18_7 = var_18_7 + var_18_8.point
			end

			local var_18_10 = var_18_1 + (var_18_4 - 1) * var_18_0

			if not arg_16_1 then
				local var_18_11 = var_0_2(arg_17_4)
				local var_18_12 = var_0_3(arg_17_4)
				local var_18_13 = arg_17_4

				if var_18_11 then
					var_18_13 = string.split(arg_17_4, "_")[1]
				end

				if not var_18_12 and arg_16_0.isSignup and not arg_17_5.isout and not itertools.include(arg_16_0.rounds, var_18_13) then
					local var_18_14 = {
						figure = arg_17_5.figure,
						showTime = arg_17_3
					}
					local var_18_15, var_18_16 = arg_16_0:getCardsByRound()

					var_18_14.cards = var_18_15
					var_18_14.fighting_point = var_18_16
					var_18_14.round = arg_17_4
					var_18_14.enemy = arg_17_2
					var_18_14.path = arg_16_0:getTitleRes(var_18_13)

					local var_18_17 = arg_16_0:getItemTitle(var_18_13)

					var_18_14.paths = var_18_17

					table.insert(var_18_2, 1, var_18_14)

					local var_18_18 = 415

					if not var_18_17 then
						var_18_18 = 349
					end

					var_18_10 = var_18_10 + var_18_0 + var_18_18
				end

				if arg_17_4 == "prepare" then
					table.insert(var_18_2, {
						round = "time",
						showTime = arg_17_3,
						useRound = arg_17_4
					})
				end

				if arg_16_0.isSignup and not arg_17_5.isout and (arg_17_4 == "halftime" or arg_17_4 == "prepare2") then
					table.insert(var_18_2, 1, {
						round = "time",
						showTime = arg_17_3,
						useRound = arg_17_4
					})

					local var_18_19 = string.format(gLanguageCsv.crossCrafthalfTimeTip, var_18_5, var_18_6, var_18_7)

					table.insert(var_18_2, 1, {
						round = "out",
						str = var_18_19
					})

					var_18_10 = var_18_10 + 2 * var_18_0 + 260 + 120
				end

				if var_18_3 == 0 and not arg_16_0.isSignup or arg_17_5.isout then
					local var_18_20 = string.format(gLanguageCsv.crossCraftOutTip, var_18_5, var_18_6)

					if not arg_16_0.isSignup then
						var_18_20 = gLanguageCsv.noSignupCantBattle
						var_18_2 = {}
					end

					table.insert(var_18_2, 1, {
						round = "out",
						str = var_18_20
					})

					var_18_10 = var_18_10 + var_18_0 + 120
				end
			end

			arg_16_0.slider:visible(var_18_10 > arg_16_0.speList:size().height)
			arg_16_0.fightDatas:update(var_18_2)
			arg_16_0.winAndloseNum:set(string.format(gLanguageCsv.winAndLoseNum, var_18_5, var_18_6))
			arg_16_0.textVal1:text(arg_16_0.winAndloseNum:read())
			arg_16_0.pointNum:set(var_18_7)
			arg_16_0.textVal2:text(arg_16_0.pointNum:read())
			adapt.oneLinePos(arg_16_0.infoPanel:get("textNote1"), {
				arg_16_0.infoPanel:get("textVal1"),
				arg_16_0.infoPanel:get("textNote2"),
				arg_16_0.infoPanel:get("textVal2")
			}, {
				cc.p(5, 0),
				cc.p(50, 0),
				cc.p(5, 0)
			})
		end

		if var_16_0 < 0 then
			var_16_0 = 0

			var_17_0()

			return
		end

		var_16_0 = var_16_0 + 1

		performWithDelay(arg_16_0, function()
			var_16_0 = var_16_0 - 1

			if var_16_0 > 0 then
				return
			end

			var_17_0()
		end, 0)
	end)
end

function var_0_7.initModel(arg_20_0)
	arg_20_0.roleId = gGameModel.role:read("id")
	arg_20_0.level = gGameModel.role:read("level")
	arg_20_0.roleName = gGameModel.role:read("name")
	arg_20_0.figure = gGameModel.role:read("figure")

	local var_20_0 = gGameModel.cross_craft

	arg_20_0.round = var_20_0:getIdler("round")
	arg_20_0.curTime = var_20_0:getIdler("time")
	arg_20_0.history = var_20_0:getIdler("history")
	arg_20_0.info = var_20_0:getIdler("info")
	arg_20_0.servers = var_20_0:getIdler("servers")
	arg_20_0.infoCards = var_20_0:getIdler("cards")
	arg_20_0.cardAttrs = var_20_0:getIdler("card_attrs")
	arg_20_0.vsinfo = var_20_0:getIdler("vsinfo")
	arg_20_0.isSignup = var_0_0.isSigned()
end

function var_0_7.getCardsByRound(arg_21_0)
	local var_21_0 = arg_21_0.round:read()
	local var_21_1, var_21_2 = var_0_1(var_21_0, "^pre%d+")
	local var_21_3, var_21_4 = var_0_1(var_21_0, "^top%d+")
	local var_21_5, var_21_6 = var_0_1(var_21_0, "^final%d+")
	local var_21_7 = {}
	local var_21_8 = 0

	if var_21_1 or var_21_3 or var_21_5 or var_21_0 == "prepare" or var_21_0 == "prepare2" then
		local var_21_9 = 1

		if var_21_1 then
			var_21_9 = tonumber(string.sub(var_21_0, var_21_1 + 3, var_21_2)) % 10
		elseif var_21_3 then
			local var_21_10 = string.sub(var_21_0, var_21_3 + 3, var_21_4)

			var_21_9 = ({
				["32"] = 2,
				["16"] = 3,
				["64"] = 1
			})[var_21_10]
		elseif var_21_5 then
			var_21_9 = tonumber(string.sub(var_21_0, var_21_5 + 5, var_21_6))
		end

		for iter_21_0 = var_21_9 * 3 - 2, var_21_9 * 3 do
			local var_21_11 = arg_21_0.infoCards:read()[iter_21_0]

			if var_21_11 then
				local var_21_12 = arg_21_0.cardAttrs:read()[var_21_11]
				local var_21_13 = var_21_12.card_id
				local var_21_14 = var_21_12.skin_id
				local var_21_15 = {
					var_21_11,
					var_21_13,
					var_21_14
				}

				table.insert(var_21_7, var_21_15)

				var_21_8 = var_21_8 + var_21_12.fighting_point
			end
		end
	end

	return var_21_7, var_21_8
end

function var_0_7.getItemTitle(arg_22_0, arg_22_1)
	arg_22_1 = arg_22_1 or arg_22_0.round:read()

	local var_22_0, var_22_1 = var_0_1(arg_22_1, "^pre%d+")

	if var_22_0 or var_0_1(arg_22_1, "prepare") then
		local var_22_2 = {
			"city/pvp/cross_craft/txt/txt_yxs.png"
		}
		local var_22_3 = 11

		if arg_22_1 == "prepare2" then
			var_22_3 = 31
		elseif var_22_0 then
			var_22_3 = tonumber(string.sub(arg_22_1, var_22_0 + 3, var_22_1))
		end

		var_22_2[2] = "city/pvp/cross_craft/txt/txt_d" .. math.floor(var_22_3 / 10) .. "l.png"

		return var_22_2
	end

	if var_0_1(arg_22_1, "^top%d+") then
		return {
			"city/pvp/cross_craft/txt/txt_jjs.png"
		}
	elseif var_0_1(arg_22_1, "^final%d+") then
		return {
			"city/pvp/cross_craft/txt/txt_dfs.png"
		}
	end

	return nil
end

function var_0_7.getTitleRes(arg_23_0, arg_23_1)
	arg_23_1 = arg_23_1 or arg_23_0.round:read()

	local var_23_0, var_23_1 = var_0_1(arg_23_1, "^pre%d+")

	if var_23_0 or var_0_1(arg_23_1, "prepare") then
		local var_23_2 = 1

		if var_23_0 then
			var_23_2 = tonumber(string.sub(arg_23_1, var_23_0 + 3, var_23_1)) % 10
		end

		return "city/pvp/cross_craft/txt/txt_d" .. var_23_2 .. "c.png"
	end

	local var_23_3, var_23_4 = var_0_1(arg_23_1, "^top%d+")

	if var_23_3 then
		local var_23_5 = tonumber(string.sub(arg_23_1, var_23_3 + 3, var_23_4)) / 2

		return "city/pvp/cross_craft/txt/txt_" .. var_23_5 .. "qs.png"
	end

	if arg_23_1 == "final1" then
		return "city/pvp/cross_craft/txt/txt_4qs.png"
	elseif arg_23_1 == "final2" then
		return "city/pvp/cross_craft/txt/txt_bjs.png"
	elseif arg_23_1 == "final3" then
		local var_23_6 = arg_23_0.history:read()[17]

		if not var_23_6 then
			return
		end

		local var_23_7 = var_23_6.result
		local var_23_8 = "city/pvp/cross_craft/txt/txt_jjs0.png"

		if var_23_7 == "win" then
			var_23_8 = "city/pvp/cross_craft/txt/txt_gjs.png"
		end

		return var_23_8
	end

	return nil
end

function var_0_7.onReplay(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = "/game/cross/craft/playrecord/get"

	gGameModel:playRecordBattle(arg_24_3.prid, arg_24_3.cross_key, var_24_0, 2, arg_24_0.roleId)
end

function var_0_7.onShowEnemyInfo(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	gGameApp:requestServer("/game/cross/craft/battle/enemy/get", function(arg_26_0)
		gGameUI:stackUI("city.pvp.cross_craft.array_info", nil, nil, arg_26_0.view, arg_25_3.round)
	end, arg_25_3.enemy.game_key, arg_25_3.enemy.role_db_id, arg_25_3.enemy.record_db_id)
end

function var_0_7.onShowMyInfo(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	if arg_27_0.round:read() == "closed" then
		local var_27_0 = userDefault.getForeverLocalKey("serverKey", nil, {
			rawKey = true
		})
		local var_27_1 = gGameModel.role:read("id")
		local var_27_2 = gGameModel.role:read("cross_craft_record_db_id")

		gGameApp:requestServer("/game/cross/craft/battle/enemy/get", function(arg_28_0)
			gGameUI:stackUI("city.pvp.cross_craft.array_info", nil, nil, arg_28_0.view, arg_27_3.round)
		end, var_27_0, var_27_1, var_27_2)
	else
		gGameUI:stackUI("city.pvp.cross_craft.array_info", nil, nil, nil, arg_27_3.round)
	end
end

return var_0_7
