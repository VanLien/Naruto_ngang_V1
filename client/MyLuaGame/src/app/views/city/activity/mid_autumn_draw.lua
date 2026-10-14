local var_0_0 = {
	"activity/midautumn_draw/txt_yyqf_fs.png",
	"activity/midautumn_draw/txt_yyqf_zj.png",
	"activity/midautumn_draw/txt_yyqf_gc.png",
	"activity/midautumn_draw/txt_yyqf_rd.png",
	"activity/midautumn_draw/txt_yyqf_sy.png"
}
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("MidAutumnDraw", var_0_1)

var_0_2.RESOURCE_FILENAME = "activity_midautumn_draw.json"
var_0_2.RESOURCE_BINDING = {
	["planeBless.tickets"] = "plnTickets",
	["ticket.bg"] = "bg",
	["rightPanel.imgTimes.txtTimes"] = "txtTimes",
	imgSpine = "imgSpine",
	ticket = "imgTicket",
	["ticket.bg1"] = "bg1",
	heroSpine = "heroSpine",
	bg = "bg",
	planeBless = "planeBless",
	["rightPanel.imgTimes"] = "imgTimes",
	["rightPanel.btnBless"] = {
		varname = "btnBless",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSure")
			}
		}
	},
	["leftPanel.btnRule"] = {
		varname = "btnRule",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onTips")
			}
		}
	},
	["leftPanel.btnTask"] = {
		varname = "btnTask",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onRewardClick")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "midAutumnTaskAward",
					state = true,
					listenData = {
						activityId = bindHelper.self("activityId")
					},
					onNode = function(arg_1_0)
						arg_1_0:xy(150, 150)
					end
				}
			}
		}
	},
	["leftPanel.btnRule.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.COLORS.NORMAL.WHITE
				},
				color = ui.COLORS.NORMAL.DEFAULT
			}
		}
	},
	["leftPanel.btnTask.txt"] = {
		varname = "txtTask",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.COLORS.NORMAL.WHITE
				},
				color = ui.COLORS.NORMAL.DEFAULT
			}
		}
	},
	tips = {
		varname = "tips",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.COLORS.NORMAL.DEFAULT
				},
				color = ui.COLORS.NORMAL.WHITE
			}
		}
	},
	endTime = {
		varname = "endTime",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.COLORS.NORMAL.DEFAULT
				},
				color = ui.COLORS.NORMAL.WHITE
			}
		}
	}
}

function var_0_2.onCreate(arg_2_0, arg_2_1)
	gGameUI.topuiManager:createView("title", arg_2_0, {
		onClose = arg_2_0:createHandler("onClose")
	}):init({
		subTitle = "MidAutumn Bless",
		title = gLanguageCsv.midAutumnDraw
	})

	arg_2_0.activityId = arg_2_1
	arg_2_0.huodongID = csv.yunying.yyhuodong[arg_2_0.activityId].huodongID
	arg_2_0.roundTime, arg_2_0.ticket, arg_2_0.tickets, arg_2_0.ticketsAnimation, arg_2_0.ticketsBone = 0, 0, {}, {}, {}

	arg_2_0:initModel()

	arg_2_0.addedTickets = 0
	arg_2_0.commonPool, arg_2_0.bestPool = {}, {}

	for iter_2_0, iter_2_1 in orderCsvPairs(csv.yunying.mid_autumn_draw) do
		if iter_2_1.huodongID == arg_2_0.huodongID then
			arg_2_0.roundTime = arg_2_0.roundTime + 1

			if iter_2_1.commonPoolID then
				table.insert(arg_2_0.commonPool, iter_2_1.commonPoolID.lib)
			end

			if iter_2_1.bestPoolID then
				table.insert(arg_2_0.bestPool, iter_2_1.bestPoolID.lib)
			end
		end
	end

	idlereasy.when(arg_2_0.yyhuodongs, function(arg_3_0, arg_3_1)
		local var_3_0 = arg_3_1[arg_2_1] or {}

		arg_2_0.drawTimes = var_3_0.info and var_3_0.info.draw_times or 0

		arg_2_0.txtTimes:text(string.format(gLanguageCsv.midAutumnCanDraw, arg_2_0.drawTimes))

		arg_2_0.ticket = var_3_0.info and var_3_0.info.round_counter or 0
	end)
	arg_2_0:initTickets(arg_2_0.roundTime - 1)
	arg_2_0:refreshAnimation()
	arg_2_0.tips:text(string.format(gLanguageCsv.midAutumnTips, arg_2_0.roundTime))

	arg_2_0.enter = widget.addAnimationByKey(arg_2_0.btnBless, "zhongqiuqifu/anniu.skel", "anniu", "effect", 10):scale(0.75):xy(200, 105)

	performWithDelay(arg_2_0, function()
		arg_2_0.enter:play("standby_loop")
	end, 0.8)

	arg_2_0.player = widget.addAnimationByKey(arg_2_0.heroSpine, "zhongqiuqifu/shanaiduo.skel", "hero", "standby_loop", 10):scale(2):xy(200, 200)

	arg_2_0:showEndTime()
	arg_2_0.txtTimes:xy((arg_2_0.txtTimes:size().width + 130) / 2, arg_2_0.imgTimes:size().height / 2)
	arg_2_0.imgTimes:size(arg_2_0.txtTimes:size().width + 130, arg_2_0.imgTimes:size().height)
	arg_2_0.txtTask:text(gLanguageCsv.midAutumnTask)
end

function var_0_2.initModel(arg_5_0)
	arg_5_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
end

function var_0_2.runAnimation(arg_6_0)
	local var_6_0 = {
		x = arg_6_0.btnPreview:x(),
		y = arg_6_0.btnPreview:y()
	}
	local var_6_1 = cc.EaseSineInOut:create(cc.MoveTo:create(1, cc.p(var_6_0.x, var_6_0.y + 10)))
	local var_6_2 = cc.EaseSineInOut:create(cc.MoveTo:create(1, cc.p(var_6_0.x, var_6_0.y - 10)))
	local var_6_3 = cc.Sequence:create(var_6_1, var_6_2)
	local var_6_4 = cc.RepeatForever:create(var_6_3)

	arg_6_0.btnPreview:runAction(var_6_4)
end

function var_0_2.refreshAnimation(arg_7_0)
	local var_7_0 = ccui.ImageView:create("activity/midautumn_draw/img_ttqf_xx.png"):anchorPoint(0.5, 0.5):xy(100, 250)

	local function var_7_1(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7)
		local var_8_0 = var_7_0:clone():show():addTo(arg_8_0, 10, "star" .. arg_8_1):xy(arg_8_2, arg_8_3):scale(0)

		performWithDelay(arg_7_0, function()
			local var_9_0 = cc.EaseSineInOut:create(cc.ScaleTo:create(0.2, arg_8_5))
			local var_9_1 = cc.Sequence:create(cc.ScaleTo:create(0.2, arg_8_4), cc.DelayTime:create(arg_8_7), var_9_0, cc.DelayTime:create(0.1))
			local var_9_2 = cc.RepeatForever:create(var_9_1)

			var_8_0:runAction(var_9_2)
		end, arg_8_6)
	end

	for iter_7_0, iter_7_1 in ipairs(arg_7_0.tickets) do
		local var_7_2 = iter_7_1:multiget("ticketShow", "ticket")

		if iter_7_0 < arg_7_0.ticket and iter_7_0 > arg_7_0.addedTickets then
			var_7_1(var_7_2.ticketShow, 1, 152, 286, 0, 1.3, 0, 0.6)
			var_7_1(var_7_2.ticketShow, 2, 259, 418, 0, 1.3, 0.2, 0.6)
			var_7_1(var_7_2.ticketShow, 3, 258, 543, 0, 0.7, 0.4, 0.6)
			var_7_1(var_7_2.ticketShow, 4, 155, 700, 0, 1, 0.1, 0.6)

			arg_7_0.addedTickets = iter_7_0
		end
	end
end

function var_0_2.showEndTime(arg_10_0)
	local var_10_0 = gGameModel.role:read("yy_endtime")[arg_10_0.activityId]
	local var_10_1 = time.getDate(math.floor(var_10_0))
	local var_10_2 = csv.yunying.yyhuodong[arg_10_0.activityId]

	var_10_1.hour = var_10_2.endTime / 100
	var_10_1.min = var_10_2.endTime % 100
	var_10_1.sec = 0

	bind.extend(arg_10_0, arg_10_0.endTime, {
		class = "cutdown_label",
		props = {
			endTime = var_10_0,
			strFunc = function(arg_11_0)
				return string.format(gLanguageCsv.bcActivityTime, arg_11_0.str)
			end,
			endFunc = function()
				arg_10_0.endTime:y(arg_10_0.endTime:y() + 24)
				arg_10_0.endTime:text(gLanguageCsv.activityOver)
			end
		}
	})
end

function var_0_2.initTickets(arg_13_0, arg_13_1)
	local var_13_0 = {
		SIZE = 1125,
		CENTER = 700,
		Y = 275
	}

	arg_13_1 = arg_13_1 or 5

	local var_13_1 = var_13_0.SIZE / arg_13_1
	local var_13_2 = var_13_0.CENTER - math.floor(arg_13_1 / 2) * var_13_1 + (arg_13_1 + 1) % 2 * var_13_1 / 2

	for iter_13_0 = 1, arg_13_1 do
		local var_13_3 = arg_13_0.plnTickets:clone():addTo(arg_13_0.planeBless, 10):xy(var_13_2, var_13_0.Y):show()

		table.insert(arg_13_0.tickets, var_13_3)

		var_13_2 = var_13_2 + var_13_1

		local var_13_4 = var_13_3:multiget("ticketShow", "ticket")

		if iter_13_0 < arg_13_0.ticket then
			var_13_4.ticketShow:get("txt"):texture(var_0_0[iter_13_0])
			var_13_4.ticketShow:show()
			var_13_4.ticket:hide()
		else
			var_13_4.ticketShow:hide()
			var_13_4.ticket:show()
		end
	end
end

function var_0_2.onSure(arg_14_0)
	if arg_14_0.drawTimes > 0 then
		gGameUI:disableTouchDispatch(1.3)
		arg_14_0.enter:play("effect")
		arg_14_0.player:play("effect")
		performWithDelay(arg_14_0, function()
			arg_14_0.enter:play("standby_loop")
			arg_14_0.player:play("standby_loop")
			gGameApp:requestServer("/game/yy/award/draw", function(arg_16_0)
				if arg_16_0.view.hit == 1 then
					gGameUI:stackUI("common.gain_display", nil, nil, arg_16_0, {
						cb = arg_14_0:createHandler("onTicketRotation"),
						tips = {
							foneSize = 50,
							str = gLanguageCsv.midAutumnGet,
							position = {
								x = 1270,
								y = 900
							},
							anchorPoint = {
								x = 0.5,
								y = 0.5
							}
						}
					})
				else
					gGameUI:stackUI("common.gain_display", nil, nil, arg_16_0, {
						cb = arg_14_0:createHandler("onShowTicket")
					})
				end
			end, arg_14_0.activityId, "blessing")
		end, 1.3)
	else
		gGameUI:showTip(gLanguageCsv.noTicketDraw)
	end
end

function var_0_2.onShowTicket(arg_17_0)
	gGameUI:stackUI("city.activity.mid_autumn_draw_mask", nil, {
		blackLayer = true
	}, arg_17_0.activityId, {
		cb = arg_17_0:createHandler("onTicketRotation"),
		num = arg_17_0.roundTime - 1,
		times = arg_17_0.ticket
	})
end

function var_0_2.onTicketRotation(arg_18_0)
	for iter_18_0, iter_18_1 in pairs(arg_18_0.tickets) do
		local var_18_0 = iter_18_1:multiget("ticketShow", "ticket", "txt")

		if iter_18_0 < arg_18_0.ticket then
			var_18_0.ticketShow:get("txt"):texture(var_0_0[iter_18_0])
			var_18_0.ticketShow:show()
			var_18_0.ticket:hide()
		else
			var_18_0.ticketShow:hide()
			var_18_0.ticketShow:hide()
			var_18_0.ticket:show()
		end

		if iter_18_0 == arg_18_0.ticket - 1 then
			var_18_0.ticketShow:hide()
			var_18_0.ticket:hide()

			local var_18_1 = widget.addAnimationByKey(iter_18_1, "zhongqiuqifu/zhongqiupaizi.skel", nil, "effect_fanzhuan", 1):scale(0.5):xy(111, 207)
			local var_18_2 = var_18_0.ticketShow:get("txt"):clone():show():addTo(iter_18_1, 10):texture(var_0_0[iter_18_0])
			local var_18_3 = cc.RepeatForever:create(cc.Sequence:create(cc.CallFunc:create(function()
				local var_19_0, var_19_1 = var_18_1:getPosition()
				local var_19_2 = var_18_1:getScaleX()
				local var_19_3 = var_18_1:getScaleY()
				local var_19_4 = var_18_1:getBonePosition("wenzi")
				local var_19_5 = var_18_1:getBoneRotation("wenzi")
				local var_19_6 = var_18_1:getBoneScaleX("wenzi")
				local var_19_7 = var_18_1:getBoneScaleY("wenzi")

				var_18_2:rotate(-var_19_5):scaleX(var_19_6 / 2):scaleY(var_19_7 / 2):xy(cc.p(var_19_4.x * var_19_2 + var_19_0, var_19_4.y * var_19_3 + var_19_1))

				if var_19_6 == 1 and var_19_5 == 0 then
					var_18_0.ticketShow:show()
					var_18_2:removeFromParent()
					var_18_1:removeFromParent()
					arg_18_0:refreshAnimation()
				end
			end)))

			var_18_2:runAction(var_18_3)
		else
			if arg_18_0.ticketsAnimation[iter_18_0] then
				arg_18_0.ticketsAnimation[iter_18_0]:removeFromParent()

				arg_18_0.ticketsAnimation[iter_18_0] = nil
			end

			if arg_18_0.ticketsBone[iter_18_0] then
				arg_18_0.ticketsBone[iter_18_0]:removeFromParent()

				arg_18_0.ticketsBone[iter_18_0] = nil
			end
		end
	end
end

function var_0_2.onTips(arg_20_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_20_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_2.getRuleContext(arg_21_0, arg_21_1)
	local var_21_0 = adaptContext

	return {
		var_21_0.clone(arg_21_1.title, function(arg_22_0)
			arg_22_0:get("text"):text(gLanguageCsv.midAutumnRule)
		end),
		var_21_0.noteText(125301, 125400)
	}
end

function var_0_2.onRewardClick(arg_23_0)
	gGameUI:stackUI("city.activity.mid_autumn_draw_task", nil, {
		blackLayer = false
	}, arg_23_0.activityId)
end

return var_0_2
