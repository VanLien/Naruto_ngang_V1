local var_0_0 = require("app.views.city.activity.view")
local var_0_1 = {
	"shicai_move_2",
	"shicai_move_3",
	"shicai_move_1"
}
local var_0_2 = {
	"shicai_move_6",
	"shicai_move_5",
	"shicai_move_4"
}
local var_0_3 = cc.load("mvc").ViewBase
local var_0_4 = class("DuanWuView", var_0_3)

var_0_4.RESOURCE_FILENAME = "activity_duanwu.json"
var_0_4.RESOURCE_BINDING = {
	["panel.icon1"] = "icon1",
	["panel.plate"] = "plate",
	["panel.hintTxt"] = "hintTxt",
	panel = "panel",
	["panel.item1"] = "item1",
	["panel.panel"] = "animaPanel",
	["panel.icon3"] = "icon3",
	["panel.item3"] = "item3",
	["panel.item2"] = "item2",
	["panel.icon2"] = "icon2",
	["panel.achievement"] = {
		varname = "achievement",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("achievementFunc")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "zongZiAward",
					listenData = {
						activityId = bindHelper.self("activityID")
					}
				}
			}
		}
	},
	["panel.rule"] = {
		varname = "rule",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("ruleFunc")
			}
		}
	},
	["panel.use"] = {
		varname = "use",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("zongZiUse")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "zongziUnused",
					activityId = bindHelper.self("activityID"),
					onNode = function(arg_1_0)
						arg_1_0:xy(100, 105)
					end
				}
			}
		}
	},
	["panel.btn"] = {
		varname = "zongZiBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("btnClick")
			}
		}
	},
	["panel.btn.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["panel.make"] = {
		varname = "speedUse",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("speedUseClick")
			}
		}
	},
	["panel.timeTxt"] = {
		varname = "timeTxt",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["panel.time"] = {
		varname = "time",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	}
}
var_0_4.RESOURCE_STYLES = {
	full = true
}

function var_0_4.onCreate(arg_2_0, arg_2_1)
	gGameUI.topuiManager:createView("title", arg_2_0, {
		onClose = arg_2_0:createHandler("onClose")
	}):init({
		subTitle = "ACTIVITY",
		title = gLanguageCsv.duanWuheadline
	})

	arg_2_0.animaBg = widget.addAnimation(arg_2_0.panel, "duanwuzongzi/dwj_bzz.skel", "effect_loop", 1):alignCenter(arg_2_0.panel:size()):scale(2)

	local var_2_0 = {}

	arg_2_0.zongziDataId = {}

	local var_2_1 = csv.yunying.yyhuodong[arg_2_1].huodongID

	for iter_2_0, iter_2_1 in orderCsvPairs(csv.yunying.bao_zongzi_recipe) do
		if iter_2_1.huodongID == var_2_1 then
			local var_2_2, var_2_3 = csvNext(iter_2_1.mainItem)
			local var_2_4, var_2_5 = csvNext(iter_2_1.minorItem)
			local var_2_6, var_2_7 = csvNext(iter_2_1.compoundItem)

			if not var_2_0[var_2_2] then
				var_2_0[var_2_2] = {}
			end

			if not arg_2_0.zongziDataId[var_2_2] then
				arg_2_0.zongziDataId[var_2_2] = {}
			end

			arg_2_0.zongziDataId[var_2_2][var_2_4] = iter_2_0
			var_2_0[var_2_2][var_2_4] = var_2_6
		end
	end

	arg_2_0.activityID = arg_2_1
	arg_2_0.zongziData = {}

	local var_2_8 = {
		6352,
		6353,
		6354
	}
	local var_2_9 = {
		6355,
		6356,
		6357
	}

	for iter_2_2 = 1, 3 do
		-- block empty
	end

	text.addEffect(arg_2_0.achievement:get("txt"), {
		outline = {
			color = cc.c4b(129, 75, 36, 255)
		}
	})
	text.addEffect(arg_2_0.rule:get("txt"), {
		outline = {
			color = cc.c4b(129, 75, 36, 255)
		}
	})
	text.addEffect(arg_2_0.use:get("txt"), {
		outline = {
			color = cc.c4b(129, 75, 36, 255)
		}
	})
	text.addEffect(arg_2_0.speedUse:get("txt"), {
		outline = {
			color = cc.c4b(129, 75, 36, 255)
		}
	})
	text.addEffect(arg_2_0.hintTxt, {
		outline = {
			color = cc.c4b(129, 75, 36, 255)
		}
	})

	arg_2_0.timeOver = true

	arg_2_0:timeUpdata(arg_2_1)
	arg_2_0.timeTxt:x(arg_2_0.time:x() - arg_2_0.time:width() - 25)
	arg_2_0.plate:get("icon"):visible(false)
	arg_2_0.plate:get("item"):visible(false)

	local var_2_10 = ui.NEWCOLORS.REDLIGHT

	idlereasy.when(gGameModel.role:getIdler("items"), function(arg_3_0, arg_3_1)
		for iter_3_0 = 1, 3 do
			local var_3_0 = string.format(gLanguageCsv.possessIngredient, 0)
			local var_3_1 = string.format(gLanguageCsv.possessIngredient, 0)
			local var_3_2 = var_2_10
			local var_3_3 = var_2_10
			local var_3_4 = false
			local var_3_5 = false

			if arg_3_1[var_2_8[iter_3_0]] then
				var_3_0 = string.format(gLanguageCsv.possessIngredient, arg_3_1[var_2_8[iter_3_0]])
				var_3_2 = ui.COLORS.NORMAL.WHITE
				var_3_4 = true
			end

			arg_2_0["icon" .. iter_3_0]:get("iconTxt"):text(var_3_0)
			arg_2_0["icon" .. iter_3_0]:get("iconTxt"):color(var_3_2)
			arg_2_0["icon" .. iter_3_0]:get("icon"):visible(var_3_4)

			if arg_3_1[var_2_9[iter_3_0]] then
				var_3_1 = string.format(gLanguageCsv.possessIngredient, arg_3_1[var_2_9[iter_3_0]])
				var_3_3 = ui.COLORS.NORMAL.WHITE
				var_3_5 = true
			end

			arg_2_0["item" .. iter_3_0]:get("itemTxt"):text(var_3_1)
			arg_2_0["item" .. iter_3_0]:get("itemTxt"):color(var_3_3)
			arg_2_0["item" .. iter_3_0]:get("item"):visible(var_3_5)
		end
	end)
	arg_2_0.hintTxt:text(gLanguageCsv.clickAddZongzi)

	arg_2_0.itemPostion1 = {}
	arg_2_0.itemPostion2 = {}
	arg_2_0.itemAnimaData = {}

	for iter_2_3 = 1, 3 do
		arg_2_0.itemPostion1[iter_2_3] = {
			x = arg_2_0["icon" .. iter_2_3]:get("icon"):x(),
			y = arg_2_0["icon" .. iter_2_3]:get("icon"):y()
		}
		arg_2_0.itemPostion2[iter_2_3] = {
			x = arg_2_0["item" .. iter_2_3]:get("item"):x(),
			y = arg_2_0["item" .. iter_2_3]:get("item"):y()
		}

		arg_2_0["icon" .. iter_2_3]:onClick(function()
			if not arg_2_0.timeOver then
				gGameUI:showTip(gLanguageCsv.activityOver)

				return
			end

			if gGameModel.role:read("items")[var_2_8[iter_2_3]] then
				arg_2_0.zongziData[1] = var_2_8[iter_2_3]

				arg_2_0.plate:get("icon"):visible(false)
			else
				gGameUI:showTip(string.format(gLanguageCsv.noItems, csv.items[var_2_8[iter_2_3]].name))
			end

			local var_4_0 = false

			if arg_2_0.zongziData[1] then
				arg_2_0.plate:get("icon"):texture(csv.items[arg_2_0.zongziData[1]].icon)

				if arg_2_0.itemAnimaData[2] then
					arg_2_0.itemAnimaData[2]:removeFromParent()

					arg_2_0.itemAnimaData[2] = nil
				end

				arg_2_0.itemAnimaData[2] = arg_2_0:animaFunc(arg_2_0["icon" .. iter_2_3]:get("icon"), "xian_move_1", arg_2_0.zongziData[1])

				local var_4_1 = true

				if arg_2_0.zongziData[2] then
					local var_4_2 = var_2_0[arg_2_0.zongziData[1]][arg_2_0.zongziData[2]]

					arg_2_0.hintTxt:text(string.format(gLanguageCsv.obtainZongZi, csv.items[var_4_2].name))
				end
			end
		end)
		arg_2_0["item" .. iter_2_3]:onClick(function()
			if not arg_2_0.timeOver then
				gGameUI:showTip(gLanguageCsv.activityOver)

				return
			end

			if gGameModel.role:read("items")[var_2_9[iter_2_3]] then
				arg_2_0.zongziData[2] = var_2_9[iter_2_3]

				arg_2_0.plate:get("item"):visible(false)
			else
				gGameUI:showTip(string.format(gLanguageCsv.noItems, csv.items[var_2_9[iter_2_3]].name))
			end

			local var_5_0 = false

			if arg_2_0.zongziData[2] then
				if arg_2_0.itemAnimaData[1] then
					arg_2_0.itemAnimaData[1]:removeFromParent()

					arg_2_0.itemAnimaData[1] = nil
				end

				arg_2_0.itemAnimaData[1] = arg_2_0:animaFunc(arg_2_0["item" .. iter_2_3]:get("item"), "xian_move_2", arg_2_0.zongziData[2])

				arg_2_0.plate:get("item"):texture(csv.items[arg_2_0.zongziData[2]].icon)

				local var_5_1 = true

				if arg_2_0.zongziData[1] then
					local var_5_2 = var_2_0[arg_2_0.zongziData[1]][arg_2_0.zongziData[2]]

					arg_2_0.hintTxt:text(string.format(gLanguageCsv.obtainZongZi, csv.items[var_5_2].name))
				end
			end
		end)
	end
end

function var_0_4.timeUpdata(arg_6_0, arg_6_1)
	arg_6_0:enableSchedule():unSchedule(1)

	local var_6_0 = csv.yunying.yyhuodong[arg_6_1]
	local var_6_1 = ""

	if var_6_0.countType == 0 then
		var_6_1 = gLanguageCsv.activityDaily
	end

	local var_6_2 = 0
	local var_6_3 = gGameModel.role:read("yy_endtime")

	if var_6_3[arg_6_1] then
		var_6_2 = var_6_3[arg_6_1] - time.getTime()
	end

	local function var_6_4()
		if var_6_2 <= 0 then
			arg_6_0.timeOver = false

			arg_6_0.timeTxt:text(gLanguageCsv.activityOver)
			arg_6_0.time:text("")
		else
			arg_6_0.timeTxt:text(gLanguageCsv.activityLeftTime)
			arg_6_0.time:text(time.getCutDown(var_6_2).str .. var_6_1)
		end
	end

	var_6_4()
	arg_6_0:schedule(function()
		var_6_2 = var_6_2 - 1

		var_6_4()

		if var_6_2 <= 0 then
			return false
		end
	end, 1, 1, 1)
end

function var_0_4.achievementFunc(arg_9_0)
	if not arg_9_0.timeOver then
		gGameUI:showTip(gLanguageCsv.activityOver)

		return
	end

	gGameUI:stackUI("city.activity.duan_wu_festival.proficiency_award", nil, nil, arg_9_0.activityID)
end

function var_0_4.zongZiUse(arg_10_0)
	if not arg_10_0.timeOver then
		gGameUI:showTip(gLanguageCsv.activityOver)

		return
	end

	gGameUI:stackUI("city.activity.duan_wu_festival.zongzi_select", nil, nil, arg_10_0.activityID)
end

function var_0_4.animaFunc(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_1:clone():show()

	var_11_0:addTo(arg_11_0.animaPanel, 10)

	if arg_11_3 then
		var_11_0:texture(csv.items[arg_11_3].icon)
	end

	local var_11_1 = cc.RepeatForever:create(cc.Sequence:create(cc.CallFunc:create(function()
		local var_12_0, var_12_1 = arg_11_0.animaBg:getPosition()
		local var_12_2 = arg_11_0.animaBg:getScaleX()
		local var_12_3 = arg_11_0.animaBg:getScaleY()
		local var_12_4 = arg_11_0.animaBg:getBonePosition(arg_11_2)
		local var_12_5 = arg_11_0.animaBg:getBoneRotation(arg_11_2)
		local var_12_6 = arg_11_0.animaBg:getBoneScaleX(arg_11_2)
		local var_12_7 = arg_11_0.animaBg:getBoneScaleY(arg_11_2)

		var_11_0:rotate(-var_12_5):scaleX(var_12_6):scaleY(var_12_7):xy(cc.p(var_12_4.x * var_12_2 + var_12_0, var_12_4.y * var_12_3 + var_12_1))
	end)))

	var_11_0:runAction(var_11_1)

	if arg_11_0.animaData then
		table.insert(arg_11_0.animaData, var_11_0)
	end

	return var_11_0
end

function var_0_4.btnClick(arg_13_0, arg_13_1, arg_13_2)
	if not arg_13_0.timeOver then
		gGameUI:showTip(gLanguageCsv.activityOver)

		return
	end

	local var_13_0 = {}

	arg_13_0.animaData = {}

	if arg_13_1 ~= "speedMake" then
		if csvSize(arg_13_0.zongziData) ~= 2 then
			gGameUI:showTip(gLanguageCsv.zongZiFabrication)

			return
		end

		arg_13_0.hintTxt:visible(false)

		var_13_0[arg_13_0.zongziDataId[arg_13_0.zongziData[1]][arg_13_0.zongziData[2]]] = 1

		arg_13_0.animaBg:play("effect_solo_hou")

		arg_13_0.anima = widget.addAnimation(arg_13_0.animaPanel, "duanwuzongzi/dwj_bzz.skel", "effect_solo_qian", 3):alignCenter(arg_13_0.animaPanel:size()):scale(2)
	else
		arg_13_0.hintTxt:visible(false)

		var_13_0 = arg_13_2

		arg_13_0.animaBg:play("kuaisu_effect")
		performWithDelay(arg_13_0, function()
			for iter_14_0 = 1, 3 do
				arg_13_0["item" .. iter_14_0]:get("item"):runAction(cc.Sequence:create(cc.MoveTo:create(0.5, cc.p(arg_13_0["item" .. iter_14_0]:get("item"):x(), arg_13_0["item" .. iter_14_0]:get("item"):y() + 750)), cc.MoveTo:create(0.6, cc.p(arg_13_0["item" .. iter_14_0]:get("item"):x(), arg_13_0["item" .. iter_14_0]:get("item"):y() - 50))))
				arg_13_0["icon" .. iter_14_0]:get("icon"):runAction(cc.Sequence:create(cc.MoveTo:create(0.5, cc.p(arg_13_0["icon" .. iter_14_0]:get("icon"):x(), arg_13_0["icon" .. iter_14_0]:get("icon"):y() + 750)), cc.MoveTo:create(0.6, cc.p(arg_13_0["icon" .. iter_14_0]:get("icon"):x(), arg_13_0["icon" .. iter_14_0]:get("icon"):y() - 50))))
			end

			performWithDelay(arg_13_0, function()
				local var_15_0
				local var_15_1

				for iter_15_0 = 1, 3 do
					arg_13_0:animaFunc(arg_13_0["item" .. iter_15_0]:get("item"), var_0_1[iter_15_0])
					arg_13_0:animaFunc(arg_13_0["icon" .. iter_15_0]:get("icon"), var_0_2[iter_15_0])
					arg_13_0["item" .. iter_15_0]:visible(false)
					arg_13_0["icon" .. iter_15_0]:visible(false)
				end
			end, 0.9)
		end, 0.8)
	end

	arg_13_0.zongZiBtn:visible(false)
	gGameUI:goBackInStackUI("city.activity.duan_wu_festival.view")

	local var_13_1 = {
		false
	}

	gGameApp:requestServerCustom("/game/yy/bao/zongzi"):params(arg_13_0.activityID, var_13_0):onResponse(function(arg_16_0)
		performWithDelay(arg_13_0, function()
			var_13_1[1] = true
			arg_13_0.zongziData = {}

			arg_13_0.hintTxt:text(gLanguageCsv.clickAddZongzi)
			arg_13_0.animaBg:play("effect_loop")
			arg_13_0.hintTxt:visible(true)

			if arg_13_0.anima then
				arg_13_0.anima:removeFromParent()

				arg_13_0.anima = nil

				if arg_13_0.itemAnimaData[1] then
					arg_13_0.itemAnimaData[1]:removeFromParent()
				end

				if arg_13_0.itemAnimaData[2] then
					arg_13_0.itemAnimaData[2]:removeFromParent()
				end

				arg_13_0.itemAnimaData = {}
			else
				for iter_17_0 = 1, 3 do
					arg_13_0["item" .. iter_17_0]:visible(true)
					arg_13_0["item" .. iter_17_0]:get("item"):xy(cc.p(arg_13_0.itemPostion2[iter_17_0].x, arg_13_0.itemPostion2[iter_17_0].y))
					arg_13_0["icon" .. iter_17_0]:visible(true)
					arg_13_0["icon" .. iter_17_0]:get("icon"):xy(cc.p(arg_13_0.itemPostion1[iter_17_0].x, arg_13_0.itemPostion1[iter_17_0].y))
				end
			end

			for iter_17_1, iter_17_2 in pairs(arg_13_0.animaData) do
				if iter_17_2 then
					iter_17_2:removeFromParent()
				end
			end

			arg_13_0.zongZiBtn:visible(true)
		end, 3.7)
	end):wait(var_13_1):doit(function(arg_18_0)
		gGameUI:showGainDisplay(arg_18_0)
	end)
end

function var_0_4.speedUseClick(arg_19_0)
	if not arg_19_0.timeOver then
		gGameUI:showTip(gLanguageCsv.activityOver)

		return
	end

	arg_19_0.plate:get("icon"):visible(false)
	arg_19_0.plate:get("item"):visible(false)

	if arg_19_0.itemAnimaData[1] then
		arg_19_0.itemAnimaData[1]:removeFromParent()

		arg_19_0.itemAnimaData[1] = nil
	end

	if arg_19_0.itemAnimaData[2] then
		arg_19_0.itemAnimaData[2]:removeFromParent()

		arg_19_0.itemAnimaData[2] = nil
	end

	arg_19_0.hintTxt:text(gLanguageCsv.clickAddZongzi)

	arg_19_0.zongziData = {}

	gGameUI:stackUI("city.activity.duan_wu_festival.speed_fabrication", nil, nil, arg_19_0.activityID, arg_19_0:createHandler("btnClick"))
end

function var_0_4.ruleFunc(arg_20_0)
	if not arg_20_0.timeOver then
		gGameUI:showTip(gLanguageCsv.activityOver)

		return
	end

	gGameUI:stackUI("common.rule", nil, nil, arg_20_0:createHandler("getRuleContext"), {
		width = 1300
	})
end

function var_0_4.getRuleContext(arg_21_0, arg_21_1)
	local var_21_0 = {
		92001,
		92005
	}
	local var_21_1 = adaptContext

	return {
		var_21_1.clone(arg_21_1.title, function(arg_22_0)
			arg_22_0:get("text"):text(gLanguageCsv.duanWuheadline)
		end),
		var_21_1.noteText(unpack(var_21_0))
	}
end

return var_0_4
