local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("ChipItemDetailsView", var_0_0)

var_0_1.RESOURCE_FILENAME = "chip_item_details.json"
var_0_1.RESOURCE_BINDING = {
	["panel.sliderPanel"] = "sliderPanel",
	panel = "panel",
	["panel.sliderPanel.slider"] = "slider",
	["panel.btnReset"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onResetClick")
			}
		}
	},
	["panel.btnOK"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onOKClick")
			}
		}
	},
	["panel.btnOK.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["panel.btnReset.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["panel.sliderPanel.subBtn"] = {
		varname = "sliderSubBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_1_0, arg_1_1, arg_1_2)
				return arg_1_0:onChangeNum(arg_1_1, arg_1_2, -1)
			end)
		}
	},
	["panel.sliderPanel.addBtn"] = {
		varname = "sliderAddBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_2_0, arg_2_1, arg_2_2)
				return arg_2_0:onChangeNum(arg_2_1, arg_2_2, 1)
			end)
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1)
	arg_3_0.cb = arg_3_1.cb
	arg_3_0.changeCb = arg_3_1.changeCb
	arg_3_0.originNum = arg_3_1.num
	arg_3_0.maxNum = arg_3_1.maxNum
	arg_3_0.ownNum = dataEasy.getNumByKey(arg_3_1.id)
	arg_3_0.chipCfg = csv.chip.chips[arg_3_1.chipId]
	arg_3_0.clientChipLevel = arg_3_1.clientChipLevel
	arg_3_0.clientChipLevelExp = arg_3_1.clientChipLevelExp

	arg_3_0:enableSchedule()
	bind.extend(arg_3_0, arg_3_0.panel:get("icon"), {
		class = "icon_key",
		props = {
			noListener = true,
			data = {
				key = arg_3_1.id
			}
		}
	})
	uiEasy.setIconName(arg_3_1.id, nil, {
		node = arg_3_0.panel:get("name")
	})
	adapt.oneLinePos(arg_3_0.panel:get("gainExpText"), arg_3_0.panel:get("gainExp"))

	arg_3_0.singleItemExp = csv.items[arg_3_1.id].specialArgsMap.chipExp
	arg_3_0.num = idler.new(arg_3_0.originNum)

	idlereasy.when(arg_3_0.num, function(arg_4_0, arg_4_1)
		arg_3_0.changeCb(arg_4_1)
		arg_3_0.panel:get("gainExp"):text(math.max(arg_4_1, 1) * arg_3_0.singleItemExp)
		text.addEffect(arg_3_0.panel:get("gainExp"), {
			color = arg_4_1 > 0 and cc.c4b(96, 196, 86, 255) or cc.c4b(183, 176, 158, 255)
		})
		arg_3_0.panel:get("cost"):text(string.format("%s: %d/%d", gLanguageCsv.cost, arg_4_1, arg_3_0.ownNum))
		cache.setShader(arg_3_0.sliderSubBtn, false, arg_4_1 > 0 and "normal" or "hsl_gray")
		cache.setShader(arg_3_0.sliderAddBtn, false, arg_4_1 < arg_3_0.maxNum and "normal" or "hsl_gray")

		local var_4_0 = math.floor(arg_4_1 / arg_3_0.maxNum * 100)

		arg_3_0.slider:setPercent(var_4_0)
	end)

	arg_3_0.showedTip = false

	arg_3_0.slider:addEventListener(function(arg_5_0, arg_5_1)
		if arg_5_1 == ccui.SliderEventType.percentChanged then
			arg_3_0:unScheduleAll()

			local var_5_0 = arg_5_0:getPercent()
			local var_5_1 = math.ceil(arg_3_0.maxNum * var_5_0 * 0.01)

			if not arg_3_0.showedTip and var_5_1 > arg_3_0.maxNum then
				arg_3_0.showedTip = true

				gGameUI:showTip(gLanguageCsv.chipExpMax)
			end

			local var_5_2 = cc.clampf(var_5_1, 0, math.max(arg_3_0.maxNum, 0))

			arg_3_0.num:set(var_5_2, true)
		end
	end)
end

function var_0_1.onClose(arg_6_0)
	arg_6_0:addCallbackOnExit(arg_6_0.cb)
	var_0_0.onClose(arg_6_0)
end

function var_0_1.onIncreaseNum(arg_7_0, arg_7_1)
	arg_7_0.num:modify(function(arg_8_0)
		return true, cc.clampf(arg_8_0 + arg_7_1, 0, math.max(arg_7_0.maxNum, 0))
	end)
end

function var_0_1.onChangeNum(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if arg_9_2.name == "click" then
		arg_9_0:unScheduleAll()
		arg_9_0:onIncreaseNum(arg_9_3)
	elseif arg_9_2.name == "began" then
		arg_9_0:schedule(function()
			arg_9_0:onIncreaseNum(arg_9_3)
		end, 0.05, 0, 1)
	elseif arg_9_2.name == "ended" or arg_9_2.name == "cancelled" then
		arg_9_0:unScheduleAll()
	end
end

function var_0_1.onResetClick(arg_11_0)
	arg_11_0.num:set(0)
end

function var_0_1.onOKClick(arg_12_0)
	if arg_12_0.clientChipLevel:read() >= arg_12_0.chipCfg.maxLevel then
		gGameUI:showTip(gLanguageCsv.chipExpMax)

		return
	end

	if arg_12_0.num:read() >= arg_12_0.maxNum then
		gGameUI:showTip(gLanguageCsv.inadequateProps)

		return
	end

	local var_12_0 = csv.chip.strength_cost[arg_12_0.clientChipLevel:read()]["levelExp" .. arg_12_0.chipCfg.strengthSeq] - arg_12_0.clientChipLevelExp:read()
	local var_12_1 = math.min(arg_12_0.num:read() + math.ceil(var_12_0 / arg_12_0.singleItemExp), arg_12_0.maxNum)

	arg_12_0.num:set(var_12_1)
end

return var_0_1
