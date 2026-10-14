local var_0_0 = {
	received = 3,
	noReach = 2,
	canReceive = 1
}
local var_0_1 = require("app.views.city.activity.view")
local var_0_2 = class("ActivityRechargeGift", cc.load("mvc").ViewBase)
local var_0_3 = matchLanguage({
	"cn"
}) and 10 or 1

local function var_0_4(arg_1_0, arg_1_1)
	return cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0.1), cc.MoveTo:create(0.3, cc.p(arg_1_0, arg_1_1 + 10)), cc.DelayTime:create(0.1), cc.MoveTo:create(0.3, cc.p(arg_1_0, arg_1_1))))
end

var_0_2.RESOURCE_FILENAME = "activity_recharge_gift.json"
var_0_2.RESOURCE_BINDING = {
	itemBox = "boxItem",
	item = "item",
	bigTarget = "icon",
	barBg = "barBg",
	rmb = "rmb",
	recievedBtn = "recievedBtn",
	txtBg = "txtBg",
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("datas"),
				item = bindHelper.self("item"),
				dataOrderCmp = dataEasy.sortItemCmp,
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					bind.extend(arg_2_0, arg_2_1, {
						class = "icon_key",
						props = {
							data = arg_2_3,
							onNode = function(arg_3_0)
								arg_3_0:y(185)
							end
						}
					})
					arg_2_1:get("name"):text(uiEasy.setIconName(arg_2_3.key, arg_2_3.num))
					arg_2_1:get("name"):getVirtualRenderer():setLineSpacing(-15)
					text.addEffect(arg_2_1:get("name"), {
						outline = {
							color = ui.NEWCOLORS.OUTLINE.BLACK
						}
					})
				end,
				onAfterBuild = function(arg_4_0)
					arg_4_0:setItemAlignCenter()
				end
			}
		}
	},
	target = {
		binds = {
			event = "extend",
			class = "icon_key",
			props = {
				data = bindHelper.self("targetData")
			}
		}
	},
	boxList = {
		varname = "boxList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("boxData"),
				item = bindHelper.self("boxItem"),
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					local var_5_0 = arg_5_1:multiget("icon", "select", "light")

					var_5_0.select:visible(arg_5_3.selected == true)
					var_5_0.icon:texture("common/icon/icon_signin_box2" .. (arg_5_3.state == var_0_0.received and "_open.png" or ".png"))

					local var_5_1 = arg_5_3.state == var_0_0.canReceive

					if var_5_1 then
						local var_5_2 = widget.addAnimation(arg_5_1, "effect/jiedianjiangli.skel", "effect_loop", var_5_0.icon:z() - 1)
						local var_5_3 = var_5_0.icon:size()

						var_5_2:scale(0.5):x(var_5_0.icon:x() - var_5_3.width / 2 + 35):y(var_5_0.icon:y() - 16)

						arg_5_1.effectBox = var_5_2
					elseif not var_5_1 and arg_5_1.effectBox then
						arg_5_1.effectBox:hide()
						arg_5_1.effectBox:removeFromParent()

						arg_5_1.effectBox = nil
					end

					var_5_0.light:hide()
					bind.touch(arg_5_0, var_5_0.icon, {
						methods = {
							ended = functools.partial(arg_5_0.clickBox, arg_5_2, arg_5_3, arg_5_1)
						}
					})

					if not arg_5_3.originY then
						arg_5_3.originX, arg_5_3.originY = var_5_0.select:xy()
					end

					arg_5_3.action = arg_5_3.action or var_0_4(arg_5_3.originX, arg_5_3.originY)

					var_5_0.select:stopAction(arg_5_3.action)

					if arg_5_3.selected then
						arg_5_3.action = var_0_4(arg_5_3.originX, arg_5_3.originY)

						var_5_0.select:runAction(arg_5_3.action)
					end
				end
			},
			handlers = {
				clickBox = bindHelper.self("onBoxClick")
			}
		}
	},
	timeTxt = {
		varname = "timeLabel",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			}
		}
	},
	time = {
		varname = "time",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			}
		}
	},
	bar = {
		varname = "bar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				maskImg = "common/icon/mask_bar_red.png",
				data = bindHelper.self("barPoint")
			}
		}
	},
	recieveBtn = {
		varname = "recieveBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRecieveClick")
			}
		}
	},
	rechargeBtn = {
		varname = "rechargeBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRechargeClick")
			}
		}
	}
}

function var_0_2.onCreate(arg_6_0, arg_6_1)
	arg_6_0.activityID = arg_6_1

	local var_6_0 = csv.yunying.yyhuodong[arg_6_1]
	local var_6_1 = (gGameModel.role:read("yy_hdid") or {})[arg_6_1] or var_6_0.huodongID

	arg_6_0.originX = arg_6_0.list:x()
	arg_6_0.boxData = idlers.new()
	arg_6_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_6_0.boxIndex = idler.new(1)
	arg_6_0.currDay = idler.new(0)
	arg_6_0.rechargeNum = idler.new(0)

	local var_6_2 = {
		15,
		35,
		55,
		75,
		100
	}

	arg_6_0.barPoint = idler.new(0)

	idlereasy.when(arg_6_0.yyhuodongs, function(arg_7_0, arg_7_1)
		local var_7_0 = arg_7_1[arg_6_1] or {}
		local var_7_1 = var_7_0.stamps or {}
		local var_7_2 = var_7_0.info.rechargesum or 0

		arg_6_0.rechargeNum:set(var_7_2 / var_0_3)

		local var_7_3 = {}
		local var_7_4 = 0
		local var_7_5 = var_7_0.info.lastdaysum or 0
		local var_7_6 = var_7_0.info.daysum or 0

		for iter_7_0, iter_7_1 in orderCsvPairs(csv.yunying.rechargegift) do
			if iter_7_1.huodongID == var_6_1 then
				local var_7_7 = var_0_0.noReach

				if var_7_1[iter_7_0] == 1 then
					var_7_7 = var_0_0.canReceive
				elseif var_7_1[iter_7_0] == 0 then
					var_7_7 = var_0_0.received
				end

				arg_6_0.money = iter_7_1.amount / var_0_3

				if csvNext(iter_7_1.special) then
					local var_7_8, var_7_9 = csvNext(iter_7_1.special)

					arg_6_0.targetData = idlertable.new({
						key = var_7_8,
						num = var_7_9
					})
				end

				table.insert(var_7_3, {
					csvId = iter_7_0,
					cfg = iter_7_1,
					state = var_7_7
				})
			end
		end

		table.sort(var_7_3, function(arg_8_0, arg_8_1)
			return arg_8_0.cfg.daySum < arg_8_1.cfg.daySum
		end)

		local var_7_10 = #var_7_3
		local var_7_11 = var_7_5 ~= var_7_6 and var_7_6 or var_7_5 + 1

		arg_6_0.currDay:set(math.min(var_7_11, var_7_10))

		if var_7_6 ~= var_7_5 then
			if var_7_3[var_7_6].state == var_0_0.noReach then
				arg_6_0.barPoint:set(mathEasy.showProgress(var_6_2, {
					1,
					2,
					3,
					4,
					5
				}, var_7_6 - 1))
			else
				arg_6_0.barPoint:set(mathEasy.showProgress(var_6_2, {
					1,
					2,
					3,
					4,
					5
				}, var_7_6))
			end
		else
			arg_6_0.barPoint:set(mathEasy.showProgress(var_6_2, {
				1,
				2,
				3,
				4,
				5
			}, var_7_6))
		end

		arg_6_0.boxData:update(var_7_3)
		arg_6_0.boxIndex:set(arg_6_0.currDay:read(), true)
	end)
	arg_6_0.boxIndex:addListener(function(arg_9_0, arg_9_1)
		arg_6_0.boxData:atproxy(arg_9_1).selected = false
		arg_6_0.boxData:atproxy(arg_9_0).selected = true
	end)
	idlereasy.any({
		arg_6_0.currDay,
		arg_6_0.boxIndex
	}, function(arg_10_0, arg_10_1, arg_10_2)
		local var_10_0 = {}
		local var_10_1 = arg_6_0.boxData:atproxy(arg_10_2)

		for iter_10_0, iter_10_1 in csvMapPairs(var_10_1.cfg.award) do
			if iter_10_0 == "cards" then
				for iter_10_2, iter_10_3 in ipairs(iter_10_1) do
					table.insert(var_10_0, {
						key = "card",
						num = iter_10_3
					})
				end
			else
				table.insert(var_10_0, {
					key = iter_10_0,
					num = iter_10_1
				})
			end
		end

		arg_6_0.list:setItemsMargin(#var_10_0 == 3 and 50 or 20)

		if not arg_6_0.datas then
			arg_6_0.datas = idlers.newWithMap(var_10_0)
		else
			arg_6_0.datas:update(var_10_0)
		end

		itertools.invoke({
			arg_6_0.recieveBtn,
			arg_6_0.rechargeBtn,
			arg_6_0.recievedBtn
		}, "hide")

		if var_10_1.state == var_0_0.canReceive then
			arg_6_0.recieveBtn:show()
			text.addEffect(arg_6_0.recieveBtn:get("label"), {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
		elseif var_10_1.state == var_0_0.noReach then
			if arg_10_2 == arg_10_1 then
				arg_6_0.rechargeBtn:show()
				text.addEffect(arg_6_0.rechargeBtn:get("label"), {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				})
			else
				arg_6_0.recievedBtn:show()
				arg_6_0.recievedBtn:get("label"):text(gLanguageCsv.notOpen)
				text.addEffect(arg_6_0.recievedBtn:get("label"), {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				})
			end
		else
			arg_6_0.recievedBtn:show()
			arg_6_0.recievedBtn:get("label"):text(gLanguageCsv.received)
			text.addEffect(arg_6_0.recievedBtn:get("label"), {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
		end
	end)
	idlereasy.when(arg_6_0.rechargeNum, function(arg_11_0, arg_11_1)
		if arg_6_0.txtBg:get("txt") then
			arg_6_0.txtBg:get("txt"):removeFromParent()
		end

		local var_11_0 = rich.createByStr(string.format(gLanguageCsv.activityRechargeGift, arg_6_0.money - arg_11_1 >= 0 and arg_6_0.money - arg_11_1 or 0), 46):addTo(arg_6_0.txtBg, 10, "txt"):alignCenter(arg_6_0.txtBg:size())
	end)
	arg_6_0.rmb:texture(string.format("activity/recharge_gift/txt_%dy.png", arg_6_0.money)):scale(1)
	arg_6_0.icon:texture(var_6_0.clientParam.hero)
	var_0_1.setCountdown(arg_6_0, arg_6_1, arg_6_0.timeLabel, arg_6_0.time, {
		labelChangeCb = function()
			adapt.oneLinePos(arg_6_0.timeLabel, arg_6_0.time, cc.p(15, 0))
		end
	})
end

function var_0_2.onBoxClick(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	arg_13_0.boxIndex:set(arg_13_2)
end

function var_0_2.onRecieveClick(arg_14_0)
	local var_14_0 = arg_14_0.boxIndex:read()
	local var_14_1 = {
		false
	}

	gGameApp:requestServerCustom("/game/yy/award/get"):params(arg_14_0.activityID, arg_14_0.boxData:atproxy(arg_14_0.boxIndex:read()).csvId):onResponse(function(arg_15_0)
		local var_15_0 = arg_14_0.boxList:getChildren()[var_14_0]

		uiEasy.setBoxEffect(var_15_0, 1, function()
			var_14_1[1] = true
		end, 35, 5)
	end):wait(var_14_1):doit(function(arg_17_0)
		gGameUI:showGainDisplay(arg_17_0)
	end)
end

function var_0_2.onRechargeClick(arg_18_0)
	gGameUI:stackUI("city.recharge", nil, {
		full = true
	})
end

return var_0_2
