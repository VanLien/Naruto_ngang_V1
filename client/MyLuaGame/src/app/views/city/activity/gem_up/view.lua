local function var_0_0(arg_1_0, arg_1_1)
	return cc.RepeatForever:create(cc.Sequence:create(cc.MoveTo:create(1, cc.p(arg_1_0, arg_1_1 + 30)), cc.MoveTo:create(1, cc.p(arg_1_0, arg_1_1 - 30))))
end

local var_0_1 = require("app.views.city.activity.view")
local var_0_2 = class("GemUpView", Dialog)

var_0_2.RESOURCE_FILENAME = "activity_gem.json"
var_0_2.RESOURCE_BINDING = {
	txt = "timeTxt",
	icon2 = "icon2",
	icon3 = "icon3",
	iconTxt2 = "iconTxt2",
	iconTxt1 = "iconTxt1",
	freePanel = "freePanel",
	bgAnima = "bgAnima",
	item1 = "item1",
	item2 = "item2",
	bg = "bg",
	item3 = "item3",
	iconBg = "iconBg",
	icon1 = "icon1",
	iconTxt3 = "iconTxt3",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	replacement = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("replacement")
			}
		}
	},
	["replacement.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	time = {
		varname = "time",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = cc.c4b(139, 47, 28, 255)
				}
			}
		}
	},
	resolvePanel = {
		varname = "resolvePanel",
		binds = {
			event = "click",
			method = bindHelper.self("resolveGem")
		}
	},
	imgBg = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("awardBrowse")
			}
		}
	},
	["extract1.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["extract2.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	extract1 = {
		varname = "drawOnePanel",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_2_0)
					arg_2_0:onDrawClick(1)
				end)
			}
		}
	},
	extract2 = {
		varname = "drawTenPanel",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_3_0)
					arg_3_0:onDrawClick(10)
				end)
			}
		}
	},
	["iconBg.btn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleShow")
			}
		}
	}
}

function var_0_2.onCreate(arg_4_0, arg_4_1)
	arg_4_0.drawOnePanel:get("textFree"):visible(false)

	arg_4_0.activityID = arg_4_1

	local var_4_0 = userDefault.getForeverLocalKey("gemUpReplacement", false)

	arg_4_0.resolvePanel:get("icon"):visible(var_4_0)

	if matchLanguage({
		"en"
	}) then
		adapt.setTextAdaptWithSize(arg_4_0.resolvePanel:get("title"), {
			margin = 0,
			vertical = "center",
			horizontal = "left",
			maxLine = 2,
			size = cc.size(400, 120)
		})
	end

	arg_4_0.whetherResolve = var_4_0 and 1 or 0

	arg_4_0.timeTxt:text(string.format("%02d:00", time.getRefreshHour()))
	arg_4_0:initModel()
	arg_4_0:setCountdown(arg_4_1)
	arg_4_0.bg:visible(false)

	local var_4_1 = widget.addAnimation(arg_4_0.bgAnima, "fushichouqu/fwxd.skel", "effect_loop", 10):alignCenter(arg_4_0.bgAnima:size()):scale(2)
	local var_4_2 = widget.addAnimation(arg_4_0.bgAnima, "fushichouqu/fwxd_wz.skel", "effect_loop", 20):alignCenter(arg_4_0.bgAnima:size()):scale(2)

	idlereasy.when(gGameModel.daily_record:getIdler("limit_up_gem_free_count"), function(arg_5_0, arg_5_1)
		if arg_5_1 == 0 then
			arg_4_0.freePanel:get("txt"):text(gLanguageCsv.freeCount)
			arg_4_0.freePanel:get("time"):text(1 .. "/" .. 1)
		end

		arg_4_0.freePanel:visible(arg_5_1 == 0)
		arg_4_0.drawOnePanel:get("icon"):visible(arg_5_1 ~= 0)
		arg_4_0.freePanel:get("icon"):visible(arg_5_1 ~= 0)
		arg_4_0.drawOnePanel:get("textFree"):visible(arg_5_1 == 0)
		arg_4_0.drawOnePanel:get("txt1"):visible(arg_5_1 ~= 0)
		arg_4_0.drawOnePanel:get("num"):visible(arg_5_1 ~= 0)
	end)

	local var_4_3 = csv.yunying.yyhuodong[arg_4_1]

	arg_4_0.numUp = var_4_3.paramMap.drawLimit

	local var_4_4 = var_4_3.clientParam.up

	arg_4_0.rmbDown = var_4_3.paramMap.RMB1
	arg_4_0.rmbUp = var_4_3.paramMap.RMB10

	arg_4_0.drawOnePanel:get("num"):text(arg_4_0.rmbDown)
	adapt.oneLinePos(arg_4_0.drawOnePanel:get("num"), arg_4_0.drawOnePanel:get("icon"), cc.p(10, 0), "left")
	arg_4_0.drawTenPanel:get("num"):text(arg_4_0.rmbUp)
	adapt.oneLinePos(arg_4_0.drawTenPanel:get("num"), arg_4_0.drawTenPanel:get("icon"), cc.p(10, 0), "left")

	for iter_4_0 = 1, 3 do
		if var_4_4[iter_4_0] then
			arg_4_0["item" .. iter_4_0]:get("gem"):texture(ui.GEM_SUIT_ICON[var_4_4[iter_4_0]])
			arg_4_0["iconTxt" .. iter_4_0]:text(gLanguageCsv["gemSuit" .. var_4_4[iter_4_0]])
		else
			arg_4_0.item2:x(arg_4_0.item2:x() + 260)
			arg_4_0.iconTxt2:x(arg_4_0.iconTxt2:x() + 260)
			arg_4_0.item1:x(arg_4_0.item1:x() + 180)
			arg_4_0.iconTxt1:x(arg_4_0.iconTxt1:x() + 180)
			arg_4_0["item" .. iter_4_0]:visible(false)
			arg_4_0["iconTxt" .. iter_4_0]:visible(false)
		end

		if csvSize(var_4_4) == 2 then
			if iter_4_0 == 1 then
				arg_4_0.item1:runAction(var_0_0(arg_4_0.item1:x() + 180, arg_4_0.item1:y()))
				widget.addAnimation(arg_4_0.icon1, "fushichouqu/fwxd_hezi.skel", "effect_loop", 10):xy(720, 375):scale(2)
			elseif iter_4_0 == 2 then
				arg_4_0.item2:runAction(var_0_0(arg_4_0.item2:x() + 260, arg_4_0.item1:y()))
				widget.addAnimation(arg_4_0.icon2, "fushichouqu/fwxd_hezi.skel", "effect_loop", 10):xy(790, 375):scale(2)
			end
		else
			arg_4_0["item" .. iter_4_0]:runAction(var_0_0(arg_4_0["item" .. iter_4_0]:x(), arg_4_0.item1:y()))
			widget.addAnimation(arg_4_0["icon" .. iter_4_0], "fushichouqu/fwxd_hezi.skel", "effect_loop", 10):xy(530, 375):scale(2)
		end
	end

	idlereasy.when(gGameModel.role:getIdler("rmb"), function()
		arg_4_0:textColor()
	end)
	idlereasy.when(arg_4_0.yyhuodongs, function(arg_7_0, arg_7_1)
		local var_7_0 = 0

		if arg_7_1[arg_4_1] and arg_7_1[arg_4_1].info.draw_counter then
			var_7_0 = arg_7_1[arg_4_1].info.draw_counter
		end

		arg_4_0.iconBg:get("num"):text(var_7_0 .. "/" .. arg_4_0.numUp)
		adapt.oneLinePos(arg_4_0.iconBg:get("num"), arg_4_0.iconBg:get("btn"), cc.p(10, 0), "left")
	end)
	Dialog.onCreate(arg_4_0, {
		blackType = 1
	})
end

function var_0_2.setCountdown(arg_8_0, arg_8_1)
	arg_8_0:enableSchedule()

	local var_8_0 = csv.yunying.yyhuodong[arg_8_1]
	local var_8_1 = 0
	local var_8_2 = gGameModel.role:read("yy_endtime")

	if var_8_2[arg_8_1] then
		var_8_1 = var_8_2[arg_8_1] - time.getTime()
	end

	bind.extend(arg_8_0, arg_8_0.time, {
		class = "cutdown_label",
		props = {
			time = var_8_1,
			endFunc = function()
				arg_8_0.time:text(gLanguageCsv.activityOver)
			end
		}
	})
end

function var_0_2.initModel(arg_10_0)
	arg_10_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
end

function var_0_2.replacement(arg_11_0)
	gGameUI:stackUI("city.activity.gem_up.gem_replacement", nil, nil, arg_11_0.activityID)
end

function var_0_2.resolveGem(arg_12_0)
	local var_12_0 = userDefault.getForeverLocalKey("gemUpReplacement", false)

	userDefault.setForeverLocalKey("gemUpReplacement", not var_12_0)
	arg_12_0.resolvePanel:get("icon"):visible(not var_12_0)

	arg_12_0.whetherResolve = not var_12_0 and 1 or 0
end

function var_0_2.awardBrowse(arg_13_0)
	gGameUI:stackUI("city.card.gem.preview", nil, {
		clickClose = true,
		blackLayer = true
	}, arg_13_0.activityID)
end

function var_0_2.drawRequest(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = gGameModel.daily_record:read("limit_up_gem_free_count")
	local var_14_1 = 0

	if arg_14_0.yyhuodongs:read()[arg_14_0.activityID] and arg_14_0.yyhuodongs:read()[arg_14_0.activityID].info.draw_counter then
		var_14_1 = arg_14_0.yyhuodongs:read()[arg_14_0.activityID].info.draw_counter
	end

	local var_14_2 = arg_14_1 == 1 and arg_14_0.rmbDown or arg_14_0.rmbUp

	if arg_14_1 == 10 or var_14_0 == 1 and arg_14_1 == 1 then
		if arg_14_1 == 10 and arg_14_0.numUp == var_14_1 then
			gGameUI:showTip(gLanguageCsv.gemDrawLimit)

			return
		elseif arg_14_1 == 10 and arg_14_0.numUp - var_14_1 <= 9 and arg_14_0.numUp - var_14_1 >= 1 then
			gGameUI:showTip(string.format(gLanguageCsv.leftTimesNotEnough, 10))

			return
		elseif arg_14_1 == 1 and arg_14_0.numUp == var_14_1 then
			gGameUI:showTip(gLanguageCsv.gemDrawLimit)

			return
		end

		if var_14_2 > gGameModel.role:read("rmb") then
			uiEasy.showDialog("rmb")

			return
		end
	end

	local var_14_3

	if arg_14_1 == 1 then
		var_14_3 = var_14_0 == 0 and "limit_up_gem_free1" or "limit_up_gem_rmb1"
	else
		var_14_3 = "limit_up_gem_rmb10"
	end

	local function var_14_4()
		gGameApp:requestServerCustom("/game/yy/limit/gem/draw"):onErrCall(function(arg_16_0)
			if gLanguageCsv[arg_16_0.err] then
				gGameUI:showTip(gLanguageCsv[arg_16_0.err])
			end
		end):params(arg_14_0.activityID, var_14_3, arg_14_0.whetherResolve):doit(function(arg_17_0)
			local var_17_0 = {}

			for iter_17_0, iter_17_1 in pairs(arg_17_0.view.items) do
				local var_17_1 = {
					key = iter_17_1[1],
					num = iter_17_1[2]
				}

				if iter_17_1[3] then
					var_17_1 = {
						num = 1,
						key = iter_17_1[3],
						decomposed = {
							key = iter_17_1[1],
							num = iter_17_1[2]
						}
					}
				end

				table.insert(var_17_0, var_17_1)
			end

			arg_14_0:textColor()
			arg_14_2(random.shuffle(var_17_0))
		end)
	end

	if var_14_3 == "limit_up_gem_rmb10" or var_14_3 == "limit_up_gem_rmb1" then
		dataEasy.sureUsingDiamonds(var_14_4, var_14_2)
	else
		var_14_4()
	end
end

function var_0_2.onDrawClick(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_1 == 1 and arg_18_0.rmbDown or arg_18_0.rmbUp

	arg_18_0:drawRequest(arg_18_1, function(arg_19_0)
		gGameUI:stackUI("city.card.gem.result", nil, nil, arg_19_0, "rmb", arg_18_1, var_18_0, 531, arg_18_0:createHandler("drawRequest"), true)
	end)
end

function var_0_2.textColor(arg_20_0)
	local var_20_0 = ui.COLORS.NORMAL.WHITE
	local var_20_1 = ui.COLORS.RED

	if gGameModel.role:read("rmb") < arg_20_0.rmbDown then
		arg_20_0.drawOnePanel:get("num"):color(var_20_1)
		arg_20_0.drawTenPanel:get("num"):color(var_20_1)
	elseif gGameModel.role:read("rmb") < arg_20_0.rmbUp and gGameModel.role:read("rmb") >= arg_20_0.rmbDown then
		arg_20_0.drawOnePanel:get("num"):color(var_20_0)
		arg_20_0.drawTenPanel:get("num"):color(var_20_1)
	elseif gGameModel.role:read("rmb") >= arg_20_0.rmbUp then
		arg_20_0.drawOnePanel:get("num"):color(var_20_0)
		arg_20_0.drawTenPanel:get("num"):color(var_20_0)
	end
end

function var_0_2.onRuleShow(arg_21_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_21_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_2.getRuleContext(arg_22_0, arg_22_1)
	local var_22_0 = {
		90001,
		90003
	}
	local var_22_1 = adaptContext

	return {
		var_22_1.clone(arg_22_1.title, function(arg_23_0)
			arg_23_0:get("text"):text(gLanguageCsv.gemUpExtract)
		end),
		var_22_1.noteText(unpack(var_22_0))
	}
end

return var_0_2
