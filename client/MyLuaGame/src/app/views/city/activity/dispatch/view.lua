local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("DispatchView", var_0_0)

var_0_1.RESOURCE_FILENAME = "activity_dispatch_main.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	["leftDownPanel.btnRule.textNote"] = {
		varname = "ruleNote",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(90, 84, 91, 255)
				}
			}
		}
	},
	["leftDownPanel.btnRule"] = {
		varname = "btnRule",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnRuleClick")
			}
		}
	},
	["leftDownPanel.btnTask"] = {
		varname = "btnTask",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onBtnTaskClick")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "dispatchTaskType",
					listenData = {
						activityId = bindHelper.self("activityId")
					},
					onNode = function(arg_1_0)
						arg_1_0:xy(120, 135)
					end
				}
			}
		}
	},
	["leftDownPanel.btnTask.textNote"] = {
		varname = "ruleNote",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(90, 84, 91, 255)
				}
			}
		}
	},
	scrollView = {
		varname = "scrollView",
		binds = {
			event = "scrollBarEnabled",
			data = false
		}
	},
	["item.cdPanel.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(255, 252, 237, 255)
				}
			}
		}
	},
	["rightDownPanel.textCountDown"] = {
		varname = "textCountDown",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	},
	["rightDownPanel.textNote"] = {
		varname = "textCountDownNote",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	}
}

local function var_0_2(arg_2_0, arg_2_1, arg_2_2)
	local function var_2_0(arg_3_0, arg_3_1)
		local var_3_0 = {}

		table.insert(var_3_0, {
			x = arg_3_0.x,
			y = arg_3_0.y
		})

		local var_3_1 = math.abs(arg_3_1.x - arg_3_0.x)
		local var_3_2 = math.abs(arg_3_1.y - arg_3_0.y)
		local var_3_3 = math.max(var_3_1, var_3_2)
		local var_3_4 = math.max(0, math.floor(var_3_3 / 45) - 1)

		for iter_3_0 = 1, var_3_4 do
			local var_3_5 = arg_3_1.x >= arg_3_0.x and 1 or -1
			local var_3_6 = arg_3_1.y >= arg_3_0.y and 1 or -1
			local var_3_7 = var_3_1 / (var_3_4 + 1)
			local var_3_8 = arg_3_0.x + iter_3_0 * var_3_7 * var_3_5 + math.random(0, 8)
			local var_3_9 = var_3_2 / (var_3_4 + 1)
			local var_3_10 = arg_3_0.y + iter_3_0 * var_3_9 * var_3_6 + math.random(0, 8)

			table.insert(var_3_0, {
				x = var_3_8,
				y = var_3_10
			})
		end

		return var_3_0
	end

	local var_2_1 = {}

	for iter_2_0 = 2, itertools.size(arg_2_1.frontWay or {}) do
		local var_2_2 = arg_2_1.frontWay[iter_2_0 - 1]
		local var_2_3 = arg_2_1.frontWay[iter_2_0]
		local var_2_4 = var_2_0({
			x = var_2_2[1],
			y = var_2_2[2]
		}, {
			x = var_2_3[1],
			y = var_2_3[2]
		})

		for iter_2_1, iter_2_2 in ipairs(var_2_4) do
			local var_2_5 = cc.Sprite:create("city/gate/logo_path.png")

			var_2_5:visible(false)
			var_2_5:xy(iter_2_2.x + arg_2_2, iter_2_2.y)
			arg_2_0:addChild(var_2_5, 9, "point")
			table.insert(var_2_1, var_2_5)
		end
	end

	return var_2_1
end

function var_0_1.onBtnRuleClick(arg_4_0)
	gGameUI:stackUI("common.rule", nil, {}, arg_4_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_1.getRuleContext(arg_5_0, arg_5_1)
	local var_5_0 = adaptContext

	return {
		var_5_0.clone(arg_5_1.title, function(arg_6_0)
			arg_6_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_5_0.noteText(124201),
		var_5_0.noteText(124202, 124300)
	}
end

function var_0_1.onBtnTaskClick(arg_7_0)
	gGameUI:stackUI("city.activity.dispatch.task", nil, {
		clickClose = true
	}, arg_7_0.activityId)
end

function var_0_1.onCreate(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0.activityId = arg_8_1

	arg_8_0:enableSchedule()

	local var_8_0 = csv.yunying.yyhuodong[arg_8_0.activityId].paramMap.item

	gGameUI.topuiManager:createView("activity_dispatch", arg_8_0, {
		onClose = arg_8_0:createHandler("onClose")
	}):init({
		title = "common/txt/txt_bt_paiqian.png",
		subTitle = "DISPATCH",
		actionPointKey = var_8_0
	})
	arg_8_0:initMap()
	arg_8_0:initModel()
	adapt.oneLinePos(arg_8_0.textCountDownNote, arg_8_0.textCountDown, cc.p(0, 0))
	arg_8_0:endTimeCountDown()
end

function var_0_1.initModel(arg_9_0)
	arg_9_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")

	idlereasy.when(arg_9_0.yyhuodongs, function(arg_10_0, arg_10_1)
		arg_9_0:unScheduleAll()

		local var_10_0 = (arg_10_1[arg_9_0.activityId] or {}).dispatch or {}
		local var_10_1 = 0

		for iter_10_0, iter_10_1 in pairs(var_10_0) do
			local var_10_2 = arg_9_0.gameCfg[iter_10_0].item

			var_10_2:removeChildByName("rewardEffect")

			if var_10_0[iter_10_0].times >= csv.yunying.dispatch[iter_10_0].times then
				var_10_2:get("dispatchingPanel"):hide()
				var_10_2:get("completePanel"):show()
				var_10_2:get("cdPanel"):hide()
				var_10_2:get("lockPanel"):show()
				var_10_2:get("posIcon"):texture("activity/dispatch/51send_ywc.png"):scale(1):y(85)
				var_10_2:setTouchEnabled(false)
				var_10_2:get("canDispatchImg"):hide()
			elseif iter_10_1.status == 1 then
				var_10_2:get("dispatchingPanel"):show()
				var_10_2:get("completePanel"):hide()
				var_10_2:get("cdPanel"):hide()
				var_10_2:get("lockPanel"):hide()
				var_10_2:get("canDispatchImg"):hide()

				if time.getTime() > var_10_0[iter_10_0].end_time then
					var_10_2:get("dispatchingPanel.imgIcon"):texture("common/icon/icon_box4.png"):scale(1.5)
					widget.addAnimationByKey(var_10_2, "effect/guanqiabaoxiang.skel", "rewardEffect", "effect_loop", 2):xy(100, 200):scale(0.5)
				else
					local var_10_3 = dataEasy.getUnitCsv(iter_10_1.cards[1].card_id, iter_10_1.cards[1].skin_id)

					var_10_2:get("dispatchingPanel.imgIcon"):texture(var_10_3.iconSimple)
					arg_9_0:schedule(function(arg_11_0)
						if time.getTime() > var_10_0[iter_10_0].end_time then
							var_10_2:get("dispatchingPanel.imgIcon"):texture("common/icon/icon_box4.png"):scale(1.5)
							widget.addAnimationByKey(var_10_2, "effect/guanqiabaoxiang.skel", "rewardEffect", "effect_loop", 2):xy(100, 200):scale(0.5)

							return false
						end
					end, iter_10_0)
				end
			elseif iter_10_1.status == 2 then
				var_10_2:get("dispatchingPanel"):hide()
				var_10_2:get("completePanel"):hide()

				if var_10_0[iter_10_0].cd_time and time.getTime() < var_10_0[iter_10_0].cd_time then
					var_10_2:get("cdPanel"):show()
					var_10_2:get("lockPanel"):hide()
					arg_9_0:countDown(var_10_2:get("cdPanel"), var_10_0[iter_10_0].cd_time, iter_10_0)
					var_10_2:get("canDispatchImg"):hide()
				else
					var_10_2:get("cdPanel"):hide()
					var_10_2:get("lockPanel"):show()
					var_10_2:get("canDispatchImg"):show()
					var_10_2:get("canDispatchImg"):stopAllActions()
				end
			end

			if arg_9_0.gameCfg[iter_10_0].data.type == 1 then
				var_10_1 = math.max(var_10_1, iter_10_0)
			end
		end

		arg_9_0:moveToDispatch(var_10_1)
		arg_9_0:setSelEffect(var_10_1)
	end)
end

function var_0_1.initMap(arg_12_0)
	arg_12_0.gameCfg = {}

	for iter_12_0, iter_12_1 in orderCsvPairs(csv.yunying.dispatch) do
		if iter_12_1.huodongID == csv.yunying.yyhuodong[arg_12_0.activityId].huodongID then
			arg_12_0.gameCfg[iter_12_0] = {
				data = iter_12_1,
				id = iter_12_0
			}
		end
	end

	arg_12_0.scrollView:size(display.sizeInViewRect):xy(display.sizeInViewRect)

	for iter_12_2, iter_12_3 in pairs(arg_12_0.gameCfg) do
		local var_12_0 = arg_12_0.item:clone():addTo(arg_12_0.scrollView):show():xy(iter_12_3.data.position):z(10)

		arg_12_0.gameCfg[iter_12_2].item = var_12_0

		var_12_0:get("lockPanel"):show()
		var_12_0:get("lockPanel.text"):text(iter_12_3.data.numText)
		bind.touch(arg_12_0.scrollView, var_12_0, {
			methods = {
				ended = functools.partial(arg_12_0.clickGateItem, arg_12_0, iter_12_3.id)
			}
		})
		var_12_0:get("posIcon"):texture(iter_12_3.data.icon):scale(1):y(85)

		if iter_12_3.data.type == 3 then
			var_12_0:get("posIcon"):scale(2):y(120)
		end

		local var_12_1 = var_0_2(arg_12_0.scrollView, iter_12_3.data, 0)

		for iter_12_4, iter_12_5 in ipairs(var_12_1) do
			iter_12_5:visible(true)
		end

		arg_12_0.gameCfg[iter_12_2].item:get("canDispatchImg"):hide()
	end
end

function var_0_1.moveToDispatch(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.gameCfg[arg_13_1].item
	local var_13_1 = arg_13_0.scrollView:size()
	local var_13_2 = var_13_0:x()
	local var_13_3 = var_13_0:y()
	local var_13_4 = var_13_1.width / 2 - var_13_2
	local var_13_5 = var_13_1.height / 2 - var_13_3
	local var_13_6 = math.min(0, var_13_4)
	local var_13_7 = math.min(0, var_13_5)
	local var_13_8 = math.max(-arg_13_0.scrollView:getInnerContainerSize().width + var_13_1.width, var_13_6)
	local var_13_9 = math.max(-arg_13_0.scrollView:getInnerContainerSize().height + var_13_1.height, var_13_7)

	arg_13_0.scrollView:setInnerContainerPosition(cc.p(var_13_8, var_13_9))
end

function var_0_1.setSelEffect(arg_14_0, arg_14_1)
	arg_14_0.selEffectId = arg_14_1

	if not arg_14_0.selEffect then
		arg_14_0.selEffect = CSprite.new("level/xuanguan.skel")

		arg_14_0.selEffect:play("effect_loop")
		arg_14_0.selEffect:visible(true)
		arg_14_0.selEffect:retain()
	end

	local var_14_0 = arg_14_0.gameCfg[arg_14_1].item
	local var_14_1 = cc.p(100, -80)

	if var_14_0:get("dispatchingPanel"):isVisible() then
		var_14_1 = cc.p(100, 120)
	elseif var_14_0:get("completePanel"):isVisible() then
		arg_14_0.selEffect:hide()

		return
	elseif var_14_0:get("cdPanel"):isVisible() then
		var_14_1 = cc.p(100, 10)
	elseif var_14_0:get("lockPanel"):isVisible() then
		if csv.yunying.dispatch[arg_14_1].type == 3 then
			var_14_1 = cc.p(100, 0)
		else
			var_14_1 = cc.p(100, -80)
		end
	end

	if var_14_0 and arg_14_0.selEffect then
		arg_14_0.selEffect:removeFromParent()
		arg_14_0.selEffect:addTo(var_14_0, 100, "selEffect")
		arg_14_0.selEffect:xy(var_14_1)
		arg_14_0.selEffect:retain()

		return arg_14_0.selEffect
	end
end

function var_0_1.clickGateItem(arg_15_0, arg_15_1)
	if csv.yunying.dispatch[arg_15_1].type == 3 then
		local var_15_0 = (arg_15_0.yyhuodongs:read()[arg_15_0.activityId] or {}).dispatch or {}
		local var_15_1 = csv.yunying.dispatch[arg_15_1].award
		local var_15_2 = csv.yunying.yyhuodong[arg_15_0.activityId].paramMap.item
		local var_15_3 = csv.yunying.dispatch[arg_15_1].cost[var_15_2]

		if var_15_0[arg_15_1] and var_15_0[arg_15_1].status == 2 then
			local var_15_4 = string.format(gLanguageCsv.dispatchBoxTip1, var_15_3)

			gGameUI:showDialog({
				btnType = 2,
				content = var_15_4,
				cb = function()
					local var_16_0 = csv.yunying.yyhuodong[arg_15_0.activityId].paramMap.item

					if dataEasy.getNumByKey(var_16_0) < var_15_3 then
						gGameUI:showTip(gLanguageCsv.actionPointNotEnough)

						return
					end

					gGameApp:requestServer("/game/yy/dispatch/begin", function(arg_17_0)
						gGameUI:showGainDisplay(arg_17_0)
					end, arg_15_0.activityId, arg_15_1)
				end
			})
		else
			gGameUI:showBoxDetail({
				state = 1,
				data = var_15_1,
				content = string.format(gLanguageCsv.dispatchBoxTip2, var_15_3)
			})
		end
	else
		gGameUI:stackUI("city.activity.dispatch.sprite_select", nil, {
			blackLayer = true,
			clickClose = true
		}, arg_15_0.activityId, arg_15_1)
	end

	arg_15_0:setSelEffect(arg_15_1)
end

function var_0_1.countDown(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local function var_18_0()
		local var_19_0 = arg_18_1:get("text")
		local var_19_1, var_19_2 = arg_18_1:getPosition()
		local var_19_3 = time.getCutDown(arg_18_2 - time.getTime())

		var_19_0:text(var_19_3.str)
		arg_18_1:get("imgBg"):width(var_19_0:width() + 20)

		if arg_18_2 - time.getTime() <= 0 then
			arg_18_0.gameCfg[arg_18_3].item:get("cdPanel"):hide()
			arg_18_0.gameCfg[arg_18_3].item:get("lockPanel"):show()
			arg_18_0:selEffect(arg_18_0.selEffectId)

			return false
		end

		return true
	end

	var_18_0()
	arg_18_0:schedule(function(arg_20_0)
		if not var_18_0() then
			return false
		end
	end, 1, 0, arg_18_3)
end

function var_0_1.endTimeCountDown(arg_21_0)
	arg_21_0:enableSchedule():unSchedule(99)

	local var_21_0 = gGameModel.role:read("yy_endtime")[arg_21_0.activityId]

	if var_21_0 - time.getTime() <= 0 then
		arg_21_0.textCountDownNote:text(gLanguageCsv.activityOver)
		arg_21_0.textCountDown:text("")

		return
	end

	bind.extend(arg_21_0, arg_21_0.textCountDown, {
		class = "cutdown_label",
		props = {
			tag = 99,
			endTime = var_21_0,
			strFunc = function(arg_22_0)
				return arg_22_0.str
			end,
			endFunc = function()
				arg_21_0:endTimeCountDown()
			end
		}
	})
end

return var_0_1
