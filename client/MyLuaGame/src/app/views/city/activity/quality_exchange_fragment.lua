local var_0_0 = require("app.views.city.activity.view")
local var_0_1 = class("ActivityQualityExchangeFragmentView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "activity_quality_exchange_fragment.json"
var_0_1.RESOURCE_BINDING = {
	costPanel = "costPanel",
	descPanel = "descPanel",
	leftPanel = "leftPanel",
	countdownText = "countdownText",
	sliderPanel = "sliderPanel",
	countdown = "countdown",
	rightPanel = "rightPanel",
	rulePanel = {
		binds = {
			event = "click",
			method = bindHelper.self("onRuleClick")
		}
	},
	detailPanel = {
		varname = "detailPanel",
		binds = {
			event = "click",
			method = bindHelper.self("onDetailPanelClick")
		}
	},
	["sliderPanel.sub"] = {
		varname = "sliderSubBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_1_0, arg_1_1, arg_1_2)
				return arg_1_0:onChangeNum(arg_1_1, arg_1_2, -1)
			end)
		}
	},
	["sliderPanel.add"] = {
		varname = "sliderAddBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_2_0, arg_2_1, arg_2_2)
				return arg_2_0:onChangeNum(arg_2_1, arg_2_2, 1)
			end)
		}
	},
	["leftPanel.btn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onLeftBtnClick")
			}
		}
	},
	["rightPanel.btn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRightBtnClick")
			}
		}
	},
	btn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnClick")
			}
		}
	},
	["btn.label"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1)
	gGameUI.topuiManager:createView("default", arg_3_0, {
		onClose = arg_3_0:createHandler("onClose")
	}):init({
		subTitle = "FRAGMENT EXCHANGE",
		title = "common/txt/txt_bt_suipianzhuanhuanji.png"
	})
	arg_3_0.detailPanel:get("bg"):width(arg_3_0.detailPanel:get("tip"):width() + 48)
	arg_3_0:enableSchedule()

	arg_3_0.bgEffect = widget.addAnimation(arg_3_0:getResourceNode(), "effect/zhuanhuanzhuangzhi.skel", "right_loop", 1):alignCenter(display.sizeInView):scale(2)
	arg_3_0.activityId = arg_3_1
	arg_3_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_3_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_3_0.rmb = gGameModel.role:getIdler("rmb")
	arg_3_0.num = idler.new(0)
	arg_3_0.maxNum = 0

	local var_3_0 = csv.yunying.yyhuodong[arg_3_1]
	local var_3_1 = var_3_0.huodongID

	arg_3_0.datas = {}
	arg_3_0.qualityData = {}
	arg_3_0.detailItems = {}

	for iter_3_0, iter_3_1 in orderCsvPairs(csv.yunying.qualityexchange) do
		if iter_3_1.huodongID == var_3_1 then
			for iter_3_2, iter_3_3 in orderCsvPairs(iter_3_1.items) do
				local var_3_2, var_3_3 = next(iter_3_3)

				table.insert(arg_3_0.detailItems, {
					key = var_3_2
				})

				if not arg_3_0.datas[var_3_2] then
					arg_3_0.datas[var_3_2] = {}
				end

				arg_3_0.datas[var_3_2][iter_3_1.quality] = {
					csvId = iter_3_0,
					cfg = iter_3_1,
					key = var_3_2,
					num = var_3_3,
					idx = iter_3_2,
					rmb = iter_3_1.costMap.rmb or 0
				}
			end

			arg_3_0.qualityData[iter_3_1.quality] = {
				leftTimes = 0
			}
		end
	end

	table.sort(arg_3_0.detailItems, dataEasy.sortItemCmp)
	idlereasy.any({
		arg_3_0.yyhuodongs,
		arg_3_0.vipLevel
	}, function(arg_4_0, arg_4_1, arg_4_2)
		local var_4_0 = (arg_4_1[arg_3_1] or {}).stamps or {}
		local var_4_1 = gVipCsv[arg_4_2]
		local var_4_2 = {}

		for iter_4_0, iter_4_1 in csvPairs(var_3_0.paramMap.quality) do
			table.insert(var_4_2, {
				quality = iter_4_0,
				leftTimes = iter_4_1 + (var_4_1.fragExchangeTimes[iter_4_0] or 0) - (var_4_0[iter_4_0] or 0)
			})
		end

		table.sort(var_4_2, function(arg_5_0, arg_5_1)
			return arg_5_0.quality > arg_5_1.quality
		end)

		local var_4_3 = {}

		for iter_4_2, iter_4_3 in ipairs(var_4_2) do
			if arg_3_0.qualityData[iter_4_3.quality] then
				arg_3_0.qualityData[iter_4_3.quality].leftTimes = iter_4_3.leftTimes
			end

			table.insert(var_4_3, {
				str = string.format(" #L00100010##LOC0xFFFCED##C0x%s#%s #L10##C0x5B545B#%s:#L10#%s%d#L10##C0x5B545B#%s", string.sub(ui.QUALITYCOLOR[iter_4_3.quality], 5, 10), ui.RARITY_TEXT[iter_4_3.quality - 2], gLanguageCsv.fragment, iter_4_3.leftTimes > 0 and "#C0x60C456#" or "#C0xF13B54#", iter_4_3.leftTimes, gLanguageCsv.times)
			})
		end

		beauty.textScroll({
			fontSize = 30,
			margin = 30,
			isRich = true,
			list = arg_3_0.descPanel:get("list"),
			strs = var_4_3
		})
	end)

	arg_3_0.leftId = idler.new()
	arg_3_0.rightId = idler.new()

	idlereasy.any({
		arg_3_0.leftId,
		arg_3_0.rightId,
		arg_3_0.num,
		arg_3_0.rmb
	}, function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		arg_3_0:getSelectData()
		arg_3_0.costPanel:hide()

		arg_3_0.maxNum = 0

		if arg_3_0.selectData then
			if arg_6_3 > 0 then
				local var_6_0 = arg_3_0.costPanel:multiget("txt", "num", "icon")
				local var_6_1 = arg_3_0.selectData.rmb * arg_6_3

				var_6_0.num:text(var_6_1)
				text.addEffect(var_6_0.num, {
					color = var_6_1 <= arg_6_4 and cc.c4b(249, 248, 200, 255) or ui.COLORS.NORMAL.RED
				})
				adapt.oneLineCenterPos(cc.p(200, 30), {
					var_6_0.txt,
					var_6_0.num,
					var_6_0.icon
				}, cc.p(10, 0))
				arg_3_0.costPanel:show()
			end

			local var_6_2 = dataEasy.getCfgByKey(arg_6_1)
			local var_6_3 = dataEasy.getNumByKey(arg_6_1)

			arg_3_0.maxNum = math.min(math.floor(var_6_3 / arg_3_0.selectData.cfg.count), arg_3_0.qualityData[var_6_2.quality].leftTimes)
		end

		arg_3_0.sliderPanel:get("num"):text(arg_6_3 .. "/" .. arg_3_0.maxNum)

		if arg_6_3 < 1 or arg_6_3 >= arg_3_0.maxNum then
			arg_3_0:unScheduleAll()
		end

		if not arg_3_0.sliderPanel:get("slider"):isHighlighted() then
			local var_6_4 = arg_3_0.maxNum == 0 and 0 or arg_6_3 / arg_3_0.maxNum

			arg_3_0.sliderPanel:get("slider"):setPercent(var_6_4 * 100)
		end

		if not arg_6_2 then
			arg_3_0:refreshPanel(1, false)
			arg_3_0:refreshPanel(2, true)
			arg_3_0:playBgEffect("right_loop")
		elseif not arg_6_1 then
			arg_3_0:refreshPanel(1, true)
			arg_3_0:refreshPanel(2, true, arg_6_2)
			arg_3_0:playBgEffect("left_loop")
		else
			arg_3_0:refreshPanel(1, true, arg_6_1)
			arg_3_0:refreshPanel(2, true, arg_6_2)
			arg_3_0:playBgEffect("standby_loop")
		end
	end)
	arg_3_0.sliderPanel:get("slider"):addEventListener(function(arg_7_0, arg_7_1)
		arg_3_0:unScheduleAll()

		local var_7_0 = arg_7_0:getPercent()
		local var_7_1 = cc.clampf(math.ceil(arg_3_0.maxNum * var_7_0 * 0.01), 0, arg_3_0.maxNum)

		arg_3_0.num:set(var_7_1)
	end)

	local var_3_4 = cc.p(arg_3_0.countdown:xy())

	var_0_0.setCountdown(arg_3_0, arg_3_1, arg_3_0.countdownText, arg_3_0.countdown, {
		labelChangeCb = function()
			adapt.oneLineCenterPos(var_3_4, {
				arg_3_0.countdownText,
				arg_3_0.countdown
			}, cc.p(5, 0))
		end
	})
end

function var_0_1.playBgEffect(arg_9_0, arg_9_1)
	if arg_9_0.bgEffectName ~= arg_9_1 then
		arg_9_0.bgEffectName = arg_9_1

		arg_9_0.bgEffect:play(arg_9_0.bgEffectName)
	end
end

function var_0_1.getSelectData(arg_10_0)
	local var_10_0 = arg_10_0.leftId:read()
	local var_10_1 = arg_10_0.rightId:read()

	if var_10_0 and var_10_1 then
		local var_10_2 = dataEasy.getCfgByKey(var_10_0)

		arg_10_0.selectData = arg_10_0.datas[var_10_1][var_10_2.quality]
	else
		arg_10_0.selectData = nil
	end
end

function var_0_1.refreshPanel(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = (arg_11_1 == 1 and arg_11_0.leftPanel or arg_11_0.rightPanel):multiget("btn", "text")

	var_11_0.btn:visible(arg_11_2)
	var_11_0.text:visible(arg_11_2)
	var_11_0.btn:get("icon"):visible(arg_11_3 ~= nil)

	if arg_11_3 then
		local var_11_1
		local var_11_2

		if arg_11_0.selectData then
			local var_11_3 = math.max(arg_11_0.num:read(), 1)

			if arg_11_1 == 1 then
				var_11_1 = dataEasy.getNumByKey(arg_11_3)
				var_11_2 = arg_11_0.selectData.cfg.count * var_11_3
			else
				var_11_1 = arg_11_0.selectData.num * var_11_3
			end
		end

		bind.extend(arg_11_0, var_11_0.btn:get("icon"), {
			class = "icon_key",
			props = {
				data = {
					key = arg_11_3,
					num = var_11_1,
					targetNum = var_11_2
				},
				onNode = function(arg_12_0)
					arg_12_0:setTouchEnabled(false)
				end
			}
		})
	end
end

function var_0_1.onRuleClick(arg_13_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_13_0:createHandler("getRuleContext"))
end

function var_0_1.getRuleContext(arg_14_0, arg_14_1)
	local var_14_0 = adaptContext

	return {
		var_14_0.clone(arg_14_1.title, function(arg_15_0)
			arg_15_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_14_0.noteText(106001, 106099)
	}
end

function var_0_1.onDetailPanelClick(arg_16_0)
	gGameUI:stackUI("city.activity.quality_exchange_fragment_select", nil, nil, {
		data = arg_16_0.detailItems,
		title = {
			gLanguageCsv.qualityExchangeFragmentTitle1,
			gLanguageCsv.qualityExchangeFragmentTitle2
		}
	})
end

function var_0_1.getQualities(arg_17_0)
	local var_17_0 = {}

	for iter_17_0, iter_17_1 in pairs(arg_17_0.qualityData) do
		if iter_17_1.leftTimes > 0 then
			var_17_0[iter_17_0] = iter_17_1.leftTimes
		end
	end

	return var_17_0
end

function var_0_1.onBtnClick(arg_18_0)
	if itertools.isempty(arg_18_0:getQualities()) then
		gGameUI:showTip(gLanguageCsv.qualityExchangeFragmentTimes)

		return
	end

	local var_18_0 = arg_18_0.num:read()

	if not arg_18_0.selectData then
		gGameUI:showTip(gLanguageCsv.qualityExchangeFragmentChooseTip1)

		return
	end

	if var_18_0 <= 0 then
		gGameUI:showTip(gLanguageCsv.qualityExchangeFragmentChooseTip2)

		return
	end

	if arg_18_0.rmb:read() < arg_18_0.selectData.rmb * var_18_0 then
		uiEasy.showDialog("rmb")

		return
	end

	local var_18_1 = dataEasy.getCfgByKey(arg_18_0.leftId:read())
	local var_18_2 = string.format("#C0x%s#%s", string.sub(ui.QUALITYCOLOR[var_18_1.quality], 5, 10), var_18_1.name)
	local var_18_3 = string.format("%s(x%s)#C0x5B545B#", var_18_2, arg_18_0.selectData.cfg.count * var_18_0)
	local var_18_4 = dataEasy.getCfgByKey(arg_18_0.selectData.key)
	local var_18_5 = string.format("#C0x%s#%s(x%s)#C0x5B545B#", string.sub(ui.QUALITYCOLOR[var_18_4.quality], 5, 10), var_18_4.name, arg_18_0.selectData.num * var_18_0)
	local var_18_6 = string.format(gLanguageCsv.qualityExchangeFragmentExchangeTip, var_18_3, var_18_5, var_18_2)

	gGameUI:showDialog({
		btnType = 2,
		isRich = true,
		cb = function()
			local var_19_0 = {
				false
			}

			gGameApp:requestServerCustom("/game/yy/award/exchange"):params(arg_18_0.activityId, arg_18_0.selectData.csvId, arg_18_0.leftId:read(), arg_18_0.selectData.idx, var_18_0):onResponse(function(arg_20_0)
				arg_18_0:playBgEffect("zhuanhuan")
				performWithDelay(arg_18_0, function()
					var_19_0[1] = true
				end, 2)
			end):wait(var_19_0):doit(function(arg_22_0)
				arg_18_0.leftId:set(nil)
				arg_18_0.num:set(0)
				gGameUI:showGainDisplay(arg_22_0)
			end)
		end,
		content = "#C0x5B545B#" .. var_18_6
	})
end

function var_0_1.onLeftBtnClick(arg_23_0)
	local var_23_0 = arg_23_0.rightId:read()

	if not var_23_0 then
		return
	end

	local var_23_1 = gGameModel.role:read("frags")
	local var_23_2 = {}

	for iter_23_0, iter_23_1 in pairs(var_23_1) do
		local var_23_3 = dataEasy.getCfgByKey(iter_23_0)

		if arg_23_0.datas[var_23_0][var_23_3.quality] and iter_23_0 ~= var_23_0 then
			table.insert(var_23_2, {
				key = iter_23_0,
				num = iter_23_1
			})
		end
	end

	table.sort(var_23_2, dataEasy.sortItemCmp)
	gGameUI:stackUI("city.activity.quality_exchange_fragment_select", nil, nil, {
		data = var_23_2,
		title = {
			gLanguageCsv.bag,
			gLanguageCsv.fragment
		},
		tip = gLanguageCsv.qualityExchangeFragmentLeftTip,
		cb = function(arg_24_0)
			arg_23_0.leftId:set(arg_24_0)
			arg_23_0.num:set(math.min(1, arg_23_0.maxNum))
		end
	})
end

function var_0_1.onRightBtnClick(arg_25_0)
	if itertools.isempty(arg_25_0:getQualities()) then
		gGameUI:showTip(gLanguageCsv.qualityExchangeFragmentTimes)

		return
	end

	local var_25_0 = {}

	for iter_25_0, iter_25_1 in pairs(arg_25_0.datas) do
		for iter_25_2, iter_25_3 in pairs(iter_25_1) do
			if arg_25_0.qualityData[iter_25_2] and arg_25_0.qualityData[iter_25_2].leftTimes > 0 then
				var_25_0[iter_25_0] = true
			end
		end
	end

	local var_25_1 = {}

	for iter_25_4, iter_25_5 in pairs(var_25_0) do
		table.insert(var_25_1, {
			key = iter_25_4
		})
	end

	table.sort(var_25_1, dataEasy.sortItemCmp)
	gGameUI:stackUI("city.activity.quality_exchange_fragment_select", nil, nil, {
		data = var_25_1,
		title = {
			gLanguageCsv.qualityExchangeFragmentTitle3,
			gLanguageCsv.qualityExchangeFragmentTitle4
		},
		tip = gLanguageCsv.qualityExchangeFragmentRightTip,
		cb = function(arg_26_0)
			arg_25_0.leftId:set(nil)
			arg_25_0.num:set(0)
			arg_25_0.rightId:set(arg_26_0)
		end
	})
end

function var_0_1.onIncreaseNum(arg_27_0, arg_27_1)
	arg_27_0.num:modify(function(arg_28_0)
		return true, cc.clampf(arg_28_0 + arg_27_1, 0, math.max(arg_27_0.maxNum, 0))
	end)
end

function var_0_1.onChangeNum(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	if arg_29_2.name == "click" then
		arg_29_0:unScheduleAll()
		arg_29_0:onIncreaseNum(arg_29_3)
	elseif arg_29_2.name == "began" then
		arg_29_0:schedule(function()
			arg_29_0:onIncreaseNum(arg_29_3)
		end, 0.05, 0, 1)
	elseif arg_29_2.name == "ended" or arg_29_2.name == "cancelled" then
		arg_29_0:unScheduleAll()
	end
end

return var_0_1
