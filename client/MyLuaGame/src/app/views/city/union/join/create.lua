local var_0_0 = gCommonConfigCsv.unionCreateRMBCost
local var_0_1 = class("UnionCreateView", Dialog)

var_0_1.RESOURCE_FILENAME = "union_create_box.json"
var_0_1.RESOURCE_BINDING = {
	cost = "cost",
	["free.checkBox"] = "freeCheckBox",
	["namePanel.textInput"] = "textInput",
	["needRequest.checkBox"] = "requestCheckBox",
	["cost.textCost"] = "textCost",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	textTitle = {
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
	textNote = {
		varname = "textNote",
		binds = {
			event = "visible",
			idler = bindHelper.self("vipEnough")
		}
	},
	["head.imgIcon"] = {
		varname = "headIcon",
		binds = {
			event = "texture",
			idler = bindHelper.self("iconId"),
			method = function(arg_1_0)
				return (csv.union.union_logo[arg_1_0] or {}).icon or {}
			end
		}
	},
	btnChangeIcon = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChangeHeadUnion")
			}
		}
	},
	btnCreate = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onCreateUnion")
			}
		}
	},
	["btnCreate.textNote"] = {
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
	free = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onStateChange")
			}
		}
	},
	needRequest = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onStateChange")
			}
		}
	}
}

function var_0_1.onCreate(arg_2_0, arg_2_1)
	arg_2_0:initModel()

	arg_2_0.cb = arg_2_1

	arg_2_0.textInput:setPlaceHolderColor(ui.NEWCOLORS.GRAY3)
	arg_2_0.textInput:setTextColor(ui.NEWCOLORS.BROWN1)

	arg_2_0.iconId = idler.new(1)
	arg_2_0.vipEnough = idler.new(arg_2_0.vip:read() < gCommonConfigCsv.unionCreateNeedVip)

	arg_2_0.textNote:text(string.format(gLanguageCsv.unionCreateLimit, gCommonConfigCsv.unionCreateNeedVip))
	arg_2_0.textCost:text(var_0_0)
	adapt.oneLineCenterPos(cc.p(arg_2_0.cost:width() / 2, arg_2_0.cost:height() / 2), {
		arg_2_0.cost:get("textNote"),
		arg_2_0.textCost,
		arg_2_0.cost:get("imgIcon")
	}, cc.p(10, 0))

	arg_2_0.freeState = idler.new(true)
	arg_2_0.requestState = idler.new(false)

	idlereasy.any({
		arg_2_0.freeState,
		arg_2_0.requestState
	}, function(arg_3_0, arg_3_1, arg_3_2)
		arg_2_0.freeCheckBox:setSelectedState(arg_3_1)
		arg_2_0.requestCheckBox:setSelectedState(arg_3_2)
	end)
	idlereasy.when(arg_2_0.rmb, function(arg_4_0, arg_4_1)
		text.addEffect(arg_2_0.textCost, {
			color = arg_4_1 < var_0_0 and ui.COLORS.NORMAL.RED or ui.COLORS.NORMAL.DEFAULT
		})
	end)
	blacklist:addListener(arg_2_0.textInput, nil, functools.partial(arg_2_0.nameAdapt, arg_2_0))
	Dialog.onCreate(arg_2_0)
end

function var_0_1.initModel(arg_5_0)
	arg_5_0.vip = gGameModel.role:getIdler("vip_level")
	arg_5_0.rmb = gGameModel.role:getIdler("rmb")
end

function var_0_1.onStateChange(arg_6_0)
	arg_6_0.freeState:modify(function(arg_7_0)
		return true, not arg_7_0
	end)
	arg_6_0.requestState:modify(function(arg_8_0)
		return true, not arg_8_0
	end)
end

function var_0_1.nameAdapt(arg_9_0, arg_9_1)
	arg_9_1 = arg_9_1 or arg_9_0.textInput:text()

	local var_9_0 = beauty.singleTextLimitWord(arg_9_1, {
		fontSize = 40
	}, {
		width = 300,
		onlyText = true,
		replaceStr = ""
	})

	arg_9_0.textInput:text(var_9_0)
end

function var_0_1.onCreateUnion(arg_10_0)
	arg_10_0:nameAdapt()

	if arg_10_0.vip:read() < gCommonConfigCsv.unionCreateNeedVip then
		gGameUI:showTip(gLanguageCsv.redPacketVipLimit)

		return
	end

	if arg_10_0.rmb:read() < var_0_0 then
		uiEasy.showDialog("rmb", nil, {
			dialog = true
		})

		return
	end

	local var_10_0 = arg_10_0.textInput:text()

	if string.len(var_10_0) < 1 then
		gGameUI:showTip(gLanguageCsv.unionNameIsEmpty)

		return
	end

	local var_10_1 = arg_10_0.freeState:read() and 1 or 0

	dataEasy.sureUsingDiamonds(function()
		gGameApp:requestServer("/game/union/create", function(arg_12_0)
			gGameApp:requestServer("/game/union/get", function(arg_13_0)
				arg_10_0:addCallbackOnExit(arg_10_0.cb)
				arg_10_0:onCloseFast()
			end)
		end, var_10_0, arg_10_0.iconId, var_10_1)
	end, var_0_0)
end

function var_0_1.onChangeHeadUnion(arg_14_0)
	gGameUI:stackUI("city.union.lobby.select_logo", nil, nil, {
		cb = arg_14_0:createHandler("onChangeIconId"),
		id = arg_14_0.iconId:read()
	})
end

function var_0_1.onChangeIconId(arg_15_0, arg_15_1)
	arg_15_0.iconId:set(arg_15_1)
end

function var_0_1.onClose(arg_16_0, arg_16_1)
	Dialog.onClose(arg_16_0, arg_16_1)
end

return var_0_1
