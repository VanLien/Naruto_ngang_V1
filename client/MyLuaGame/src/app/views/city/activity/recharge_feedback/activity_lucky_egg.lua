local var_0_0 = class("LuckyEggView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "activity_lucky_egg.json"
var_0_0.RESOURCE_BINDING = {
	["mainPanel.drawTenPanel"] = "drawTenPanel",
	["mainPanel.drawOnePanel"] = "drawOnePanel",
	["awardPanel.item"] = "awardItem",
	["mainPanel.drawOnePanel.costPanel"] = "oneCostPanel",
	["mainPanel.drawTenPanel.costPanel"] = "tenCostPanel",
	["awardPanel.text"] = "awardText",
	["awardPanel.icon"] = "awardIcon",
	["mainPanel.drawOnePanel.freePanel"] = "freePanel",
	["mainPanel.aniPanel"] = "aniPanel",
	["btnRule.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	btnRule = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRule")
			}
		}
	},
	["btnAward.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	btnAward = {},
	["mainPanel.drawOnePanel.text"] = {},
	["mainPanel.drawTenPanel.text"] = {},
	["mainPanel.drawOnePanel.btn"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onDrawOne")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "luckyEggDrawCardFree"
				}
			}
		}
	},
	["mainPanel.drawOnePanel.limitPanel.limitText"] = {},
	["mainPanel.drawOnePanel.limitPanel.limitNum"] = {
		varname = "limitOneNum"
	},
	["mainPanel.drawTenPanel.limitPanel.limitText"] = {},
	["mainPanel.drawTenPanel.limitPanel.limitNum"] = {
		varname = "limitTenNum"
	},
	["mainPanel.drawTenPanel.btn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDrawTen")
			}
		}
	},
	["mainPanel.timeText1"] = {
		varname = "timeText1"
	},
	["mainPanel.timeText2"] = {
		varname = "timeText2"
	},
	["mainPanel.btnSkip"] = {
		varname = "btnSkip",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSkipClick")
			}
		}
	},
	["mainPanel.btnSkip.img"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("isSkip")
		}
	},
	["awardPanel.tip"] = {},
	["awardPanel.btnShop.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["awardPanel.list"] = {
		varname = "awardList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("listItems"),
				item = bindHelper.self("awardItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = {
						num = 0,
						key = arg_1_3
					}

					if type(arg_1_3) == "table" then
						var_1_0.key = "card"
						var_1_0.num = arg_1_3.card
					end

					arg_1_1:scale(0.89)
					bind.extend(arg_1_0, arg_1_1, {
						class = "icon_key",
						props = {
							data = var_1_0
						}
					})
				end
			}
		}
	},
	["awardPanel.btnShop"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onShop")
				}
			}
		}
	}
}

local var_0_1 = false

function var_0_0.onCreate(arg_2_0, arg_2_1, arg_2_2)
	gGameUI.topuiManager:createView("default", arg_2_0, {
		onClose = arg_2_0:createHandler("onClose")
	}):init({
		subTitle = "LUCKY_EGG",
		title = "common/txt/txt_bt_niudanji.png"
	})

	arg_2_0.activityId = arg_2_1

	arg_2_0:initModel()

	local var_2_0 = csv.yunying.yyhuodong[arg_2_1]

	arg_2_0.huodongId = var_2_0.huodongID

	local var_2_1 = {}

	for iter_2_0, iter_2_1 in csvPairs(var_2_0.clientParam.awards) do
		var_2_1[iter_2_0] = iter_2_1
	end

	arg_2_0.listItems = var_2_1

	arg_2_0:resetTimeLabel()
	arg_2_0:initAni()
end

function var_0_0.resetTimeLabel(arg_3_0)
	local var_3_0 = gGameModel.role:read("yy_endtime")[arg_3_0.activityId] - time.getTime()
	local var_3_1 = arg_3_0.timeText1
	local var_3_2 = arg_3_0.timeText2
	local var_3_3 = cc.p((var_3_1:x() + var_3_2:x()) / 2, var_3_2:y())

	local function var_3_4()
		if var_3_0 <= 0 then
			var_3_2:text(gLanguageCsv.activityOver)
			adapt.oneLineCenterPos(var_3_3, {
				var_3_1,
				var_3_2
			}, cc.p(10, 0))

			return false
		end

		var_3_0 = var_3_0 - 1

		local var_4_0 = var_3_0 > 3600 and ui.COLORS.NORMAL.FRIEND_GREEN or ui.COLORS.NORMAL.ALERT_ORANGE

		text.addEffect(var_3_2, {
			color = var_4_0
		})
		var_3_2:text(time.getCutDown(var_3_0).str)
		adapt.oneLineCenterPos(var_3_3, {
			var_3_1,
			var_3_2
		}, cc.p(10, 0))

		return true
	end

	var_3_4()

	local var_3_5 = tag or 100

	arg_3_0:enableSchedule():unSchedule(var_3_5)
	arg_3_0:schedule(function()
		return var_3_4()
	end, 1, 1, var_3_5)
end

function var_0_0.initModel(arg_6_0)
	arg_6_0.isSkip = idler.new(var_0_1)
	arg_6_0.isFree = idler.new(false)
	arg_6_0.rmb = gGameModel.role:getIdler("rmb")
	arg_6_0.items = gGameModel.role:getIdler("items")
	arg_6_0.activityScore = idler.new(0)
	arg_6_0.drawCardNum = idler.new(0)
	arg_6_0.drawFreeCount = gGameModel.daily_record:getIdler("lucky_egg_free_counter")
	arg_6_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")

	idlereasy.when(arg_6_0.items, function(arg_7_0, arg_7_1)
		arg_6_0.drawCardNum:set(dataEasy.getNumByKey(game.ITEM_TICKET.luckyEggCard))
		arg_6_0.awardText:text(dataEasy.getNumByKey(game.ITEM_TICKET.luckyEggScore))
		adapt.oneLineCenterPos(cc.p(800, 250), {
			arg_6_0.awardIcon,
			arg_6_0.awardText
		}, cc.p(15, 0))
	end)
	idlereasy.any({
		arg_6_0.rmb,
		arg_6_0.drawCardNum,
		arg_6_0.drawFreeCount,
		arg_6_0.yyhuodongs
	}, function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
		local var_8_0 = csv.yunying.yyhuodong[arg_6_0.activityId]
		local var_8_1 = arg_8_4[arg_6_0.activityId] or {}
		local var_8_2 = var_8_0.paramMap
		local var_8_3 = var_8_1.info or {}

		arg_6_0.limitOneMax = var_8_0.paramMap.RMB1LIMIT or 0
		arg_6_0.limitTenMax = var_8_0.paramMap.RMB10LIMIT or 0
		arg_6_0.myOneTims = var_8_3.lucky_egg_draw1_times or 0
		arg_6_0.myTenTims = var_8_3.lucky_egg_draw10_times or 0

		if arg_6_0.limitOneMax > 0 then
			arg_6_0.limitOneNum:text(arg_6_0.myOneTims .. "/" .. arg_6_0.limitOneMax)
			arg_6_0.drawOnePanel:get("limitPanel"):show()

			arg_6_0.canDrawOne = arg_6_0.myOneTims < var_8_0.paramMap.RMB1LIMIT
		else
			arg_6_0.canDrawOne = true

			arg_6_0.drawOnePanel:get("limitPanel"):hide()
		end

		if arg_6_0.limitTenMax > 0 then
			arg_6_0.limitTenNum:text(arg_6_0.myTenTims .. "/" .. arg_6_0.limitTenMax)
			arg_6_0.drawTenPanel:get("limitPanel"):show()

			arg_6_0.canDrawTen = arg_6_0.myTenTims < var_8_0.paramMap.RMB10LIMIT
		else
			arg_6_0.canDrawTen = true

			arg_6_0.drawTenPanel:get("limitPanel"):hide()
		end

		local function var_8_4(arg_9_0, arg_9_1, arg_9_2)
			arg_9_2 = tonumber(arg_9_2)

			local var_9_0 = string.format("%s/%s", arg_8_2, arg_9_2)
			local var_9_1 = cc.c4b(254, 249, 238, 255)
			local var_9_2 = dataEasy.getIconResByKey(game.ITEM_TICKET.luckyEggCard)

			if arg_9_2 > dataEasy.getNumByKey(game.ITEM_TICKET.luckyEggCard) then
				var_9_1 = cc.c4b(255, 90, 58, 255)
			end

			arg_9_0:text(var_9_0)
			arg_9_1:texture(var_9_2)
			adapt.oneLinePos(arg_9_0, arg_9_1, cc.p(10, 0))
			text.addEffect(arg_9_0, {
				color = var_9_1
			})
		end

		local var_8_5 = arg_8_3 < 1

		arg_6_0.isFree:set(var_8_5)
		arg_6_0.freePanel:visible(var_8_5)
		arg_6_0.oneCostPanel:visible(not var_8_5)

		if not var_8_5 then
			var_8_4(arg_6_0.oneCostPanel:get("text"), arg_6_0.oneCostPanel:get("icon"), 1)
		end

		var_8_4(arg_6_0.tenCostPanel:get("text"), arg_6_0.tenCostPanel:get("icon"), 10)
	end)
end

function var_0_0.initAni(arg_10_0)
	local var_10_0 = "niudan/niudan.skel"
	local var_10_1 = widget.addAnimation(arg_10_0.aniPanel, var_10_0, "effect_loop", 99):scale(2)

	var_10_1:setSpriteEventHandler(function(arg_11_0, arg_11_1)
		var_10_1:play("effect_loop")
	end, sp.EventType.ANIMATION_COMPLETE)

	arg_10_0.spine = var_10_1
end

function var_0_0.playAni(arg_12_0)
	if arg_12_0.isSkip:read() then
		return 0
	end

	arg_12_0.spine:play("effect")

	local var_12_0, var_12_1 = arg_12_0.drawOnePanel:xy()
	local var_12_2, var_12_3 = arg_12_0.drawTenPanel:xy()
	local var_12_4, var_12_5 = arg_12_0.btnSkip:xy()
	local var_12_6 = cc.Sequence:create(cc.DelayTime:create(0.1), cc.MoveTo:create(0.04, cc.p(var_12_0 + 10, var_12_1)), cc.MoveTo:create(0.04, cc.p(var_12_0 - 10, var_12_1)), cc.MoveTo:create(0.04, cc.p(var_12_0, var_12_1)))

	arg_12_0.drawOnePanel:runAction(cc.RepeatForever:create(var_12_6))

	local var_12_7 = cc.Sequence:create(cc.DelayTime:create(0.1), cc.MoveTo:create(0.04, cc.p(var_12_2 + 10, var_12_3)), cc.MoveTo:create(0.04, cc.p(var_12_2 - 10, var_12_3)), cc.MoveTo:create(0.04, cc.p(var_12_2, var_12_3)))

	arg_12_0.drawTenPanel:runAction(cc.RepeatForever:create(var_12_7))
	performWithDelay(arg_12_0, function()
		arg_12_0.drawOnePanel:stopAllActions()
		arg_12_0.drawTenPanel:stopAllActions()
	end, 1.8)

	return 3.3333333333333335
end

function var_0_0.onSkipClick(arg_14_0)
	local var_14_0 = arg_14_0.isSkip:read()

	arg_14_0.isSkip:set(not var_14_0)

	var_0_1 = not var_14_0
end

function var_0_0.showDrawCardResult(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	arg_15_0.inAnimation = false

	audio.pauseMusic()
	audio.playEffectWithWeekBGM("drawcard_one.mp3")

	local var_15_0 = arg_15_1 == 1 and arg_15_0.limitOneMax or arg_15_0.limitTenMax
	local var_15_1 = arg_15_1 == 1 and arg_15_0.myOneTims or arg_15_0.myTenTims
	local var_15_2, var_15_3, var_15_4 = dataEasy.getRawTable(arg_15_5)
	local var_15_5 = dataEasy.getItems(var_15_2, var_15_3)
	local var_15_6 = {
		drawType = "lucky_egg",
		items = var_15_5,
		times = arg_15_1,
		isFree = arg_15_2,
		yyId = arg_15_3,
		limitMax = var_15_0 > 0 and var_15_0 - var_15_1 or -1
	}

	gGameUI:stackUI("city.drawcard.result", nil, nil, var_15_6)
end

function var_0_0.isCanDrawCard(arg_16_0, arg_16_1)
	if arg_16_0.inAnimation then
		return false
	end

	local var_16_0 = dataEasy.getNumByKey(game.ITEM_TICKET.luckyEggCard)
	local var_16_1 = arg_16_0.rmb:read()
	local var_16_2 = arg_16_0.drawCardNum:read()
	local var_16_3 = csv.yunying.yyhuodong[arg_16_0.activityId].paramMap["RMB" .. arg_16_1]

	if arg_16_1 > gGameModel.role:read("card_capacity") - itertools.size(gGameModel.role:read("cards")) then
		gGameUI:showDialog({
			btnType = 2,
			clearFast = true,
			content = gLanguageCsv.cardBagHaveBeenFullDraw,
			cb = function()
				gGameUI:stackUI("city.card.bag", nil, {
					full = true
				})
			end
		})

		return false
	end

	if arg_16_1 == 1 and arg_16_0.isFree:read() or arg_16_1 <= var_16_2 then
		-- block empty
	else
		local var_16_4 = dataEasy.getCfgByKey(game.ITEM_TICKET.luckyEggCard)

		gGameUI:showDialog({
			content = string.format(gLanguageCsv.limitCardNotEnough, var_16_4.name),
			cb = function()
				gGameUI:stackUI("city.activity.direct_buy_gift", nil, nil, nil, {
					yyId = 336500
				})
			end,
			closeCb = function()
				return
			end
		})

		return false
	end

	if arg_16_1 == 1 and arg_16_0.drawFreeCount:read() >= 1 and not arg_16_0.canDrawOne then
		gGameUI:showTip(gLanguageCsv.luckyEggDrawOneMax)

		return false
	elseif arg_16_1 == 10 and not arg_16_0.canDrawTen then
		gGameUI:showTip(gLanguageCsv.luckyEggDrawTenMax)

		return false
	end

	arg_16_0.inAnimation = true

	return true
end

function var_0_0.onDrawOne(arg_20_0)
	if not arg_20_0:isCanDrawCard(1) then
		return
	end

	local var_20_0 = arg_20_0.activityId
	local var_20_1 = arg_20_0.isFree:read()
	local var_20_2 = var_20_1 and "lucky_egg_free1" or "lucky_egg_rmb1"
	local var_20_3 = csv.yunying.yyhuodong[arg_20_0.activityId].paramMap.RMB1

	local function var_20_4()
		local var_21_0 = {
			false
		}

		gGameApp:requestServerCustom("/game/yy/lucky/egg/draw"):params(var_20_0, var_20_2):onResponse(function(arg_22_0)
			performWithDelay(arg_20_0, function()
				var_21_0[1] = true
			end, arg_20_0:playAni())
		end):wait(var_21_0):onErrCall(function(arg_24_0)
			if arg_24_0 and arg_24_0.ret == false then
				gGameUI:showTip(arg_24_0 and arg_24_0.err)
			end

			arg_20_0.inAnimation = false
		end):doit(function(arg_25_0)
			arg_20_0:showDrawCardResult(1, var_20_1, var_20_0, "drawcard_one.mp3", arg_25_0)
		end)
	end

	if var_20_1 then
		var_20_4()
	else
		dataEasy.sureUsingDiamonds(var_20_4, var_20_3, function()
			arg_20_0.inAnimation = false
		end)
	end
end

function var_0_0.onDrawTen(arg_27_0)
	if not arg_27_0:isCanDrawCard(10) then
		return
	end

	local var_27_0 = arg_27_0.activityId
	local var_27_1 = "lucky_egg_rmb10"
	local var_27_2 = csv.yunying.yyhuodong[arg_27_0.activityId].paramMap.RMB10

	dataEasy.sureUsingDiamonds(function()
		local var_28_0 = {
			false
		}

		gGameApp:requestServerCustom("/game/yy/lucky/egg/draw"):params(var_27_0, var_27_1):onResponse(function(arg_29_0)
			performWithDelay(arg_27_0, function()
				var_28_0[1] = true
			end, arg_27_0:playAni())
		end):wait(var_28_0):onErrCall(function(arg_31_0)
			if arg_31_0 and arg_31_0.ret == false then
				gGameUI:showTip(arg_31_0 and arg_31_0.err)
			end

			arg_27_0.inAnimation = false
		end):doit(function(arg_32_0)
			arg_27_0:showDrawCardResult(10, false, var_27_0, "drawcard_ten.mp3", arg_32_0)
		end)
	end, var_27_2, function()
		arg_27_0.inAnimation = false
	end)
end

function var_0_0.onShop(arg_34_0)
	gGameUI:stackUI("city.activity.recharge_feedback.activity_lucky_egg_shop", nil, {
		blackLayer = true
	}, arg_34_0.activityId, arg_34_0.huodongId)
end

function var_0_0.onAwardShow(arg_35_0)
	gGameUI:stackUI("city.drawcard.preview", nil, {
		clickClose = true,
		blackLayer = true
	}, "lucky_egg", arg_35_0.activityId)
end

function var_0_0.onRule(arg_36_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_36_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_0.getRuleContext(arg_37_0, arg_37_1)
	local var_37_0 = adaptContext

	return {
		var_37_0.clone(arg_37_1.title, function(arg_38_0)
			arg_38_0:get("text"):text(gLanguageCsv.luckyEggRuleTitle)
		end),
		var_37_0.noteText(70001, 70006)
	}
end

return var_0_0
