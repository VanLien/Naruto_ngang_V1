local var_0_0 = {
	CAN_NOT_GOTTEN = 2,
	CAN_GOTTEN = 1,
	GOTTEN = 0
}
local var_0_1 = class("ActivitySevenDayLoginDialog", Dialog)

var_0_1.RESOURCE_BINDING = {
	item = "item",
	iconItem = "iconItem",
	btnClose = {
		varname = "btnClose",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	textCountDown = {
		varname = "textCountDown",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = cc.c4b(255, 255, 225, 255)
					}
				}
			}
		}
	},
	textCountDown1 = {
		varname = "textCountDown1",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = cc.c4b(255, 255, 225, 255)
					}
				}
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				data = bindHelper.self("itemsData"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_0.initItem(arg_1_1, arg_1_2, arg_1_3)
				end
			},
			handlers = {
				initItem = bindHelper.self("initItem")
			}
		}
	}
}

function var_0_1.onCreate(arg_2_0, arg_2_1)
	Dialog.onCreate(arg_2_0, {
		blackType = 1
	})

	arg_2_0.activityId = arg_2_1

	arg_2_0:initModel()
	arg_2_0:initData()
	arg_2_0:initCountDown()
	gGameModel.currday_dispatch:getIdlerOrigin("newPlayerWeffare"):set(true)
end

function var_0_1.initModel(arg_3_0)
	arg_3_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_3_0.itemsData = idlertable.new({})
	arg_3_0.date = idler.new("")
end

function var_0_1.initData(arg_4_0)
	local var_4_0 = {}
	local var_4_1 = csv.yunying.yyhuodong[arg_4_0.activityId]
	local var_4_2 = var_4_1.huodongID

	for iter_4_0, iter_4_1 in csvPairs(csv.yunying.loginweal) do
		if iter_4_1.huodongID == var_4_2 then
			var_4_0[iter_4_1.daySum] = {
				award = iter_4_1.award,
				id = iter_4_0
			}
		end
	end

	idlereasy.when(arg_4_0.yyhuodongs, function(arg_5_0, arg_5_1)
		local var_5_0 = arg_5_1[arg_4_0.activityId]
		local var_5_1 = {}

		for iter_5_0, iter_5_1 in pairs(var_4_0) do
			if var_5_0.stamps[iter_5_1.id] == nil then
				var_5_1[iter_5_0] = {
					award = iter_5_1.award,
					id = iter_5_1.id,
					getType = var_0_0.CAN_NOT_GOTTEN
				}
			else
				var_5_1[iter_5_0] = {
					award = iter_5_1.award,
					id = iter_5_1.id,
					getType = var_5_0.stamps[iter_5_1.id]
				}
			end
		end

		dataEasy.tryCallFunc(arg_4_0.list, "updatePreloadCenterIndex")
		arg_4_0.itemsData:set(var_5_1)
	end)

	local var_4_3, var_4_4, var_4_5 = time.getYearMonthDay(var_4_1.beginDate)
	local var_4_6, var_4_7, var_4_8 = time.getYearMonthDay(var_4_1.endDate)

	arg_4_0.date:set(var_4_4 .. "." .. var_4_5 .. "-" .. var_4_7 .. "." .. var_4_8)

	if arg_4_0.springFestival then
		local var_4_9 = arg_4_0:getResourceNode()

		widget.addAnimationByKey(var_4_9, "login_gift_spring_festival/chunjieqiridenglu.skel", "bg", "effect_h_loop", 0):xy(var_4_9:width() / 2, var_4_9:height() / 2 + 50):anchorPoint(cc.p(0.5, 0.5)):scale(2)
		widget.addAnimationByKey(var_4_9, "login_gift_spring_festival/chunjieqiridenglu.skel", "detail", "effect_q_loop", 4):xy(var_4_9:width() / 2, var_4_9:height() / 2 + 50):anchorPoint(cc.p(0.5, 0.5)):scale(2)
	end
end

function var_0_1.initCountDown(arg_6_0)
	local var_6_0 = arg_6_0.textCountDown
	local var_6_1 = csv.yunying.yyhuodong[arg_6_0.activityId]
	local var_6_2, var_6_3 = time.getHourAndMin(var_6_1.endTime)
	local var_6_4 = time.getNumTimestamp(var_6_1.endDate, var_6_2, var_6_3)

	local function var_6_5()
		local var_7_0 = time.getCutDown(var_6_4 - time.getTime())

		var_6_0:text(var_7_0.str)

		if arg_6_0.textCountDown1 then
			adapt.oneLinePos(arg_6_0.textCountDown1, var_6_0, cc.p(5, 0))
		end

		if var_6_4 - time.getTime() <= 0 then
			var_6_0:text(gLanguageCsv.activityOver)
			arg_6_0:unSchedule(1)

			return false
		end

		return true
	end

	arg_6_0:enableSchedule()
	arg_6_0:schedule(function(arg_8_0)
		if not var_6_5() then
			return false
		end
	end, 1, 0, 1)
end

function var_0_1.initItem(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = arg_9_2:multiget("textDay", "btnGet", "list", "imgBg", "imgDayBg", "textDi", "textTian")
	local var_9_1 = var_9_0.textDay:setString(arg_9_3)
	local var_9_2 = arg_9_4.award
	local var_9_3 = {}

	if arg_9_0.springFestival then
		var_9_3 = {
			onNode = function(arg_10_0, arg_10_1)
				if arg_10_1.key ~= "card" then
					arg_10_0:get("box"):texture("activity/spring_festival/box_cjhd.png")
					arg_10_0:get("imgFG"):hide()
					text.addEffect(arg_10_0:get("num"), {
						outline = {
							color = cc.c4b(204, 61, 73, 255)
						}
					})
				else
					arg_10_0.panel:get("imgBG"):texture("activity/spring_festival/box_cjhd.png")
					arg_10_0.panel:get("imgFG"):hide()
				end
			end
		}
	end

	uiEasy.createItemsToList(arg_9_1, var_9_0.list, var_9_2, var_9_3)

	if arg_9_0.springFestival then
		-- block empty
	else
		text.addEffect(var_9_0.textDay, {
			outline = {
				size = 4,
				color = ui.NEWCOLORS.OUTLINE.WHITE2
			}
		})
		text.addEffect(var_9_0.textDi, {
			outline = {
				size = 4,
				color = ui.NEWCOLORS.OUTLINE.WHITE2
			}
		})
		text.addEffect(var_9_0.textTian, {
			outline = {
				size = 4,
				color = ui.NEWCOLORS.OUTLINE.WHITE2
			}
		})
	end

	if arg_9_4.getType == var_0_0.CAN_NOT_GOTTEN then
		adapt.setTextScaleWithWidth(var_9_0.btnGet:get("textGet"), gLanguageCsv.haveNotLogin, 250)
		var_9_0.btnGet:setEnabled(false)

		if arg_9_0.springFestival then
			var_9_0.imgDayBg:texture("activity/spring_festival/tip_2.png")
			var_9_0.imgBg:texture("activity/spring_festival/panel_qr0.png")
		else
			var_9_0.imgBg:texture("activity/seven_day_login/panel_qr0.png")
		end
	elseif arg_9_4.getType == var_0_0.CAN_GOTTEN then
		adapt.setTextScaleWithWidth(var_9_0.btnGet:get("textGet"), gLanguageCsv.spaceReceive, 250)
		var_9_0.btnGet:setEnabled(true)

		if arg_9_0.springFestival then
			var_9_0.imgBg:texture("activity/spring_festival/panel_qr1.png")
		else
			var_9_0.imgBg:texture("activity/seven_day_login/panel_qr1.png")
			text.addEffect(var_9_0.btnGet:get("textGet"), {
				color = ui.NEWCOLORS.OUTLINE.BLACK5,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
		end
	elseif arg_9_4.getType == var_0_0.GOTTEN then
		var_9_0.btnGet:get("textGet"):setString(gLanguageCsv.received)

		if arg_9_0.springFestival then
			var_9_0.imgDayBg:texture("activity/spring_festival/tip_2.png")
			var_9_0.imgBg:texture("activity/spring_festival/panel_qr0.png")
		else
			var_9_0.imgBg:texture("activity/seven_day_login/panel_qr0.png")
		end

		var_9_0.btnGet:setEnabled(false)
	end

	local var_9_4 = cc.p(arg_9_2:get("imgDayBg"):xy())

	bind.touch(arg_9_0, var_9_0.btnGet, {
		methods = {
			ended = functools.partial(arg_9_0.sendGetAward, arg_9_0, arg_9_4.id)
		}
	})
	var_9_0.textDay:x(arg_9_2:get("imgDayBg"):x())
end

function var_0_1.sendGetAward(arg_11_0, arg_11_1)
	gGameApp:requestServer("/game/yy/award/get", function(arg_12_0)
		gGameUI:showGainDisplay(arg_12_0)
	end, arg_11_0.activityId, arg_11_1)
end

return var_0_1
