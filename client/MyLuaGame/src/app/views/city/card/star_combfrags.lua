local function var_0_0(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = {
		class = "icon_key",
		props = {
			data = {
				key = arg_1_2,
				num = arg_1_3
			}
		}
	}

	bind.extend(arg_1_0, arg_1_1, var_1_0)
end

local var_0_1 = {
	{
		txt = gLanguageCsv.change,
		spaceTxt = gLanguageCsv.spaceChange,
		success = gLanguageCsv.advanceSuccess
	},
	{
		txt = gLanguageCsv.comb,
		spaceTxt = gLanguageCsv.spaceComb,
		success = gLanguageCsv.combSuccess
	}
}
local var_0_2 = cc.load("mvc").ViewBase
local var_0_3 = class("fragmentComposeView", Dialog)

var_0_3.RESOURCE_FILENAME = "card_fragment_compose.json"
var_0_3.RESOURCE_BINDING = {
	combTipPos = "combTipPos",
	["barPanel.needFrags"] = "needFrags",
	["barPanel.bar"] = "slider",
	["cardPanel.card1"] = "card1",
	["cardPanel.card2"] = "card2",
	["cardPanel.textName1"] = "textName1",
	cardPanel = "cardPanel",
	["cardPanel.textName2"] = "textName2",
	barPanel = "barPanel",
	["barPanel.myFrags"] = "myFrags",
	note = "needNumNote",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	titleTxt = {
		varname = "title",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	["barPanel.subBtn"] = {
		varname = "subBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_2_0, arg_2_1, arg_2_2)
				return arg_2_0:onChangeNum(arg_2_1, arg_2_2, -1)
			end)
		}
	},
	["barPanel.addBtn"] = {
		varname = "addBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_3_0, arg_3_1, arg_3_2)
				return arg_3_0:onChangeNum(arg_3_1, arg_3_2, 1)
			end)
		}
	},
	changeBtn = {
		varname = "changeBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChangeClick")
			}
		}
	},
	["changeBtn.title"] = {
		varname = "btnTxt",
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_3.onCreate(arg_4_0, arg_4_1)
	arg_4_0.selectDbId = arg_4_1

	arg_4_0:enableSchedule()

	arg_4_0.selectNum = idler.new(0)

	local var_4_0 = csv.fragments[arg_4_0.selectDbId]

	idlereasy.when(arg_4_0.selectNum, function(arg_5_0, arg_5_1)
		local var_5_0 = arg_4_0.selectDbId
		local var_5_1 = var_4_0.combID

		arg_4_0.fragsId = var_5_1

		local var_5_2 = dataEasy.getCfgByKey(var_5_0)
		local var_5_3 = dataEasy.getCfgByKey(var_5_1)
		local var_5_4 = dataEasy.getNumByKey(var_5_0)

		arg_4_0.targetNum = math.modf(arg_5_1 / var_4_0.combCount)
		arg_4_0.canMaxNum = math.modf(var_5_4 / var_4_0.combCount)

		if not arg_4_0.slider:isHighlighted() then
			local var_5_5 = math.ceil(arg_5_1 / arg_4_0.canMaxNum * 100)

			arg_4_0.slider:setPercent(var_5_5)
		end

		local var_5_6 = csv.fragments[var_5_1]

		arg_4_0.needFrags:text("/" .. arg_4_0.canMaxNum)
		arg_4_0.myFrags:text(arg_5_1)
		adapt.oneLineCenterPos(cc.p(arg_4_0.barPanel:size().width / 2, arg_4_0.myFrags:y()), {
			arg_4_0.myFrags,
			arg_4_0.needFrags
		})
		arg_4_0.textName1:text(var_5_2.name)
		arg_4_0.textName2:text(var_5_3.name)
		text.addEffect(arg_4_0.textName1, {
			color = ui.COLORS.QUALITY[var_5_2.quality]
		})
		text.addEffect(arg_4_0.textName2, {
			color = ui.COLORS.QUALITY[var_5_3.quality]
		})
		uiEasy.setBtnShader(arg_4_0.addBtn, nil, arg_5_1 < arg_4_0.canMaxNum and 1 or 2)
		uiEasy.setBtnShader(arg_4_0.subBtn, nil, arg_5_1 > 0 and 1 or 2)
		var_0_0(arg_4_0, arg_4_0.card1, var_5_0, var_5_4)
		var_0_0(arg_4_0, arg_4_0.card2, var_5_1, arg_5_1)

		local var_5_7 = ""

		if var_4_0.type == 4 then
			var_5_7 = csv.held_item.items[var_5_1].name
		elseif var_4_0.type == 3 then
			var_5_7 = csv.items[var_5_1].name
		end

		arg_4_0.needNumNote:removeAllChildren()

		local var_5_8 = matchLanguage({
			"kr"
		}) and 30 or 34

		rich.createByStr(string.format(gLanguageCsv.fragmentComposeText, var_4_0.combCount, ui.QUALITYCOLOR[var_5_2.quality] .. var_4_0.name, 1, ui.QUALITYCOLOR[var_5_3.quality] .. var_5_7), var_5_8, nil, nil):addTo(arg_4_0.needNumNote, 10):anchorPoint(cc.p(0.5, 0.5)):xy(0, 0):formatText()
	end)
	arg_4_0.slider:setPercent(0)
	arg_4_0.slider:addEventListener(function(arg_6_0, arg_6_1)
		arg_4_0:unScheduleAll()

		local var_6_0 = arg_6_0:getPercent()
		local var_6_1 = cc.clampf(math.ceil(arg_4_0.canMaxNum * var_6_0 * 0.01), 0, arg_4_0.canMaxNum)

		arg_4_0.selectNum:set(var_6_1)
	end)
	Dialog.onCreate(arg_4_0)
end

function var_0_3.onChangeClick(arg_7_0)
	if arg_7_0.selectNum:read() == 0 then
		gGameUI:showTip(gLanguageCsv.pleaseSelectFragmentCombText)

		return
	end

	gGameApp:requestServer("/game/role/frag/comb/item", function(arg_8_0)
		var_0_2.onClose(arg_7_0)
		gGameUI:showGainDisplay(arg_8_0)
	end, arg_7_0.selectDbId, arg_7_0.selectNum:read())
end

function var_0_3.onChangeNum(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if arg_9_2.name == "click" then
		arg_9_0:unScheduleAll()
		arg_9_0:onIncreaseNum(arg_9_3)
	elseif arg_9_2.name == "began" then
		arg_9_0:schedule(function()
			arg_9_0:onIncreaseNum(arg_9_3)
		end, 0.05, 0, 100)
	elseif arg_9_2.name == "ended" or arg_9_2.name == "cancelled" then
		arg_9_0:unScheduleAll()
	end
end

function var_0_3.onIncreaseNum(arg_11_0, arg_11_1)
	arg_11_0.selectNum:modify(function(arg_12_0)
		return true, cc.clampf(arg_12_0 + arg_11_1, 0, arg_11_0.canMaxNum)
	end)
end

return var_0_3
