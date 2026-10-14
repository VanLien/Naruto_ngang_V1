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

local function var_0_2(arg_2_0, arg_2_1)
	local var_2_0 = gCommonConfigCsv.universalFragGeneral
	local var_2_1 = gCommonConfigCsv.universalFragSpecial

	if arg_2_0 == 1 then
		var_2_1 = csv.cards[arg_2_1].fragID
		var_2_0 = csv.fragments[var_2_1].universalFragID
	end

	return var_2_0, var_2_1
end

local function var_0_3(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0:size()
	local var_3_1 = arg_3_0:get("txt")

	if not var_3_1 then
		local var_3_2 = gCommonConfigCsv.universalFragGeneral
		local var_3_3 = gCommonConfigCsv.universalFragSpecial
		local var_3_4 = dataEasy.getCfgByKey(var_3_2)
		local var_3_5 = dataEasy.getCfgByKey(var_3_3)
		local var_3_6 = string.format(gLanguageCsv.universalFragCombTip, "#C0x5B545B#" .. gCommonConfigCsv.universalFragSwitch, ui.QUALITY_OUTLINE_COLOR[var_3_4.quality] .. var_3_4.name .. "#C0x5B545B#", 1, ui.QUALITY_OUTLINE_COLOR[var_3_5.quality] .. var_3_5.name)

		var_3_1 = rich.createByStr(var_3_6, 34):anchorPoint(0.5, 0.5):xy(var_3_0.width / 2, var_3_0.height / 2):addTo(arg_3_0, 6, "txt")
	end

	var_3_1:visible(arg_3_1)
end

local var_0_4 = cc.load("mvc").ViewBase
local var_0_5 = class("CardStarChangeFragsView", Dialog)

var_0_5.RESOURCE_FILENAME = "card_star_changefrags.json"
var_0_5.RESOURCE_BINDING = {
	["barPanel.myFrags"] = "myFrags",
	["cardPanel.textName2"] = "textName2",
	cardPanel = "cardPanel",
	["barPanel.needFrags"] = "needFrags",
	["cardPanel.card1"] = "card1",
	textNeedNum = "textNeedNum",
	["cardPanel.card2"] = "card2",
	["cardPanel.textName1"] = "textName1",
	item = "item",
	["barPanel.bar"] = "slider",
	barPanel = "barPanel",
	combTipPos = "combTipPos",
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
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE1
				}
			}
		}
	},
	btnList = {
		varname = "btnList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:get("btn")
					local var_4_1 = arg_4_1:get("title")

					var_4_1:text(arg_4_3.name)
					var_4_0:setBright(not arg_4_3.isSelected)
					arg_4_1:onClick(functools.partial(arg_4_0.itemClick, arg_4_2))

					if arg_4_3.isSelected then
						text.addEffect(var_4_1, {
							color = ui.COLORS.NORMAL.YELLOW,
							outline = {
								size = 4,
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							}
						})
					else
						text.addEffect(var_4_1, {
							color = ui.COLORS.NORMAL.WHITE,
							outline = {
								size = 4,
								color = ui.NEWCOLORS.OUTLINE.BLUE
							}
						})
					end
				end
			},
			handlers = {
				itemClick = bindHelper.self("onChangePage")
			}
		}
	},
	["barPanel.subBtn"] = {
		varname = "subBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onReduceClick")
			}
		}
	},
	["barPanel.addBtn"] = {
		varname = "addBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAddClick")
			}
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
				color = ui.COLORS.NORMAL.YELLOW,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_5.onCreate(arg_5_0, arg_5_1)
	arg_5_0.selectDbId = arg_5_1

	arg_5_0:initModel()

	local var_5_0 = {}
	local var_5_1
	local var_5_2 = 2

	if arg_5_1 then
		var_5_0 = {
			{
				isSelected = false,
				name = gLanguageCsv.fragmentTransformation
			},
			{
				isSelected = false,
				name = gLanguageCsv.universalSynthesis
			}
		}
		var_5_1 = arg_5_0.cardId:read()
		var_5_2 = 1
	else
		arg_5_0.cardPanel:y(arg_5_0.cardPanel:y() + 50)
		arg_5_0.barPanel:y(arg_5_0.barPanel:y() + 25)
	end

	arg_5_0.selectNum = idler.new(0)
	arg_5_0.tabIdx = idler.new(var_5_2)

	local var_5_3

	idlereasy.any({
		arg_5_0.selectNum,
		arg_5_0.tabIdx
	}, function(arg_6_0, arg_6_1, arg_6_2)
		local var_6_0, var_6_1 = var_0_2(arg_6_2, var_5_1)

		arg_5_0.fragsId = var_6_1

		local var_6_2 = dataEasy.getCfgByKey(var_6_0)
		local var_6_3 = dataEasy.getCfgByKey(var_6_1)
		local var_6_4 = dataEasy.getNumByKey(var_6_0)
		local var_6_5 = dataEasy.getNumByKey(var_6_1)

		var_5_3 = var_6_4

		if arg_6_2 == 2 then
			var_5_3 = math.floor(var_6_4 / gCommonConfigCsv.universalFragSwitch)
		end

		if not arg_5_0.slider:isHighlighted() then
			local var_6_6 = math.ceil(arg_6_1 / var_5_3 * 100)

			arg_5_0.slider:setPercent(var_6_6)
		end

		if arg_6_2 == 1 then
			local var_6_7 = csv.fragments[var_6_1]

			arg_5_0.textNeedNum:text(math.max(var_6_7.combCount - dataEasy.getNumByKey(var_6_1), 0))
		end

		arg_5_0.needFrags:text("/" .. var_5_3)
		arg_5_0.myFrags:text(arg_6_1)
		adapt.oneLineCenterPos(cc.p(arg_5_0.barPanel:size().width / 2, arg_5_0.myFrags:y()), {
			arg_5_0.myFrags,
			arg_5_0.needFrags
		})
		arg_5_0.textName1:text(var_6_2.name)
		arg_5_0.textName2:text(var_6_3.name)
		text.addEffect(arg_5_0.textName1, {
			color = ui.COLORS.QUALITY[var_6_2.quality]
		})
		text.addEffect(arg_5_0.textName2, {
			color = ui.COLORS.QUALITY[var_6_3.quality]
		})
		uiEasy.setBtnShader(arg_5_0.addBtn, nil, arg_6_1 < var_5_3 and 1 or 2)
		uiEasy.setBtnShader(arg_5_0.subBtn, nil, arg_6_1 > 0 and 1 or 2)
		var_0_0(arg_5_0, arg_5_0.card1, var_6_0, var_6_4)
		var_0_0(arg_5_0, arg_5_0.card2, var_6_1, arg_6_1)
	end)
	arg_5_0.slider:setPercent(0)
	arg_5_0.slider:addEventListener(function(arg_7_0, arg_7_1)
		if arg_7_1 == ccui.SliderEventType.percentChanged then
			local var_7_0 = arg_7_0:getPercent()
			local var_7_1 = csv.fragments[fragsId]
			local var_7_2 = arg_5_0.selectNum:read()
			local var_7_3 = math.ceil(var_5_3 / 100 * var_7_0)

			arg_5_0.selectNum:set(math.min(var_7_3, var_5_3))
		end
	end)

	arg_5_0.tabDatas = idlers.newWithMap(var_5_0)

	arg_5_0.tabIdx:addListener(function(arg_8_0, arg_8_1, arg_8_2)
		arg_5_0.title:text(var_0_1[arg_8_0].txt)
		arg_5_0.btnTxt:text(var_0_1[arg_8_0].spaceTxt)
		arg_5_0.needNumNote:visible(arg_8_0 == 1)
		arg_5_0.textNeedNum:visible(arg_8_0 == 1)
		var_0_3(arg_5_0.combTipPos, arg_8_0 == 2)

		if arg_5_0.tabDatas:atproxy(arg_8_1) then
			arg_5_0.tabDatas:atproxy(arg_8_1).isSelected = false
		end

		if arg_5_0.tabDatas:atproxy(arg_8_0) then
			arg_5_0.tabDatas:atproxy(arg_8_0).isSelected = true
		end
	end)
	Dialog.onCreate(arg_5_0)
end

function var_0_5.initModel(arg_9_0)
	local var_9_0 = gGameModel.cards:find(arg_9_0.selectDbId)

	if var_9_0 then
		arg_9_0.cardId = var_9_0:getIdler("card_id")
	end
end

function var_0_5.onAddClick(arg_10_0)
	arg_10_0.selectNum:set(arg_10_0.selectNum:read() + 1)
end

function var_0_5.onReduceClick(arg_11_0)
	arg_11_0.selectNum:set(arg_11_0.selectNum:read() - 1)
end

function var_0_5.onChangePage(arg_12_0, arg_12_1, arg_12_2)
	arg_12_0.selectNum:set(0)
	arg_12_0.tabIdx:set(arg_12_2)
end

function var_0_5.onChangeClick(arg_13_0)
	if arg_13_0.selectNum:read() == 0 then
		gGameUI:showTip(string.format(gLanguageCsv.pleaseSelectNumber, var_0_1[arg_13_0.tabIdx:read()].txt))

		return
	end

	local var_13_0

	if arg_13_0.tabIdx:read() == 1 then
		var_13_0 = arg_13_0.fragsId
	end

	gGameApp:requestServer("/game/role/acitem/switch", function(arg_14_0)
		gGameUI:showTip(var_0_1[arg_13_0.tabIdx:read()].success)
		var_0_4.onClose(arg_13_0)
	end, arg_13_0.selectNum, var_13_0)
end

return var_0_5
