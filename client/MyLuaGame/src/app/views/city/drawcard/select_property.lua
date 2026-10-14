local var_0_0 = class("SelectPropertyDialog", Dialog)
local var_0_1 = gLanguageCsv.selfChooseFree
local var_0_2 = gLanguageCsv.selfChooseCost
local var_0_3 = gCommonConfigCsv.drawCardUpChangeLimit
local var_0_4 = 0

local function var_0_5(arg_1_0, arg_1_1)
	for iter_1_0 = 1, 5 do
		arg_1_0:get("icon" .. iter_1_0):hide()
		arg_1_0:get("circle.img" .. iter_1_0):hide()
	end

	arg_1_0:get("select"):visible(arg_1_1.select)

	local function var_1_0(arg_2_0, arg_2_1)
		arg_1_0:get("icon" .. arg_2_0):texture(ui.SKILL_ICON[arg_1_1.cfg.attrs[arg_2_1]]):show()
		arg_1_0:get("circle.img" .. arg_2_0):texture(ui.SKILL_TEXT_ICON[arg_1_1.cfg.attrs[arg_2_1]]):show()
	end

	if table.getn(arg_1_1.cfg.attrs) == 1 then
		var_1_0(1, 1)
	elseif table.getn(arg_1_1.cfg.attrs) == 2 then
		var_1_0(2, 1)
		var_1_0(3, 2)
	elseif table.getn(arg_1_1.cfg.attrs) == 3 then
		var_1_0(1, 1)
		var_1_0(4, 2)
		var_1_0(5, 3)
	end
end

var_0_0.RESOURCE_FILENAME = "drawcard_property_choose.json"
var_0_0.RESOURCE_BINDING = {
	leftTimes = "leftTimes",
	item = "item",
	subList = "subList",
	tipPanel = "tipPanel",
	btnSwitch = {
		varname = "btnSwitch",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSwitch")
			}
		}
	},
	["barBg.text1"] = {
		varname = "specifiTip1"
	},
	["barBg.text2"] = {
		varname = "specifiTip2"
	},
	["btnSwitch.textNote"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	},
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				yMargin = 0,
				leftPadding = 0,
				xMargin = 0,
				topPadding = 0,
				data = bindHelper.self("showDatas"),
				columnSize = bindHelper.self("midColumnSize"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					var_0_5(arg_3_1, arg_3_3)
					bind.touch(arg_3_0, arg_3_1, {
						methods = {
							ended = functools.partial(arg_3_0.clickCell, arg_3_1, arg_3_2, arg_3_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_4_0, arg_4_1)
	arg_4_0.midColumnSize = 2
	arg_4_0.previewMidColumnSize = 3
	arg_4_0.showDatas = idlers.new()
	arg_4_0.previewDatas = idlers.new()
	arg_4_0.cards = {}
	arg_4_0.select = arg_4_1 > 0 and arg_4_1 or 1
	arg_4_0.lastSelect = arg_4_0.select
	arg_4_0.currentCost = 0

	arg_4_0:initModel(arg_4_0.select)

	arg_4_0.changeTimes = gGameModel.daily_record:getIdler("draw_card_up_change_times")

	idlereasy.when(arg_4_0.changeTimes, function(arg_5_0, arg_5_1)
		local var_5_0 = gCostCsv.draw_card_up_change_cost
		local var_5_1 = arg_5_1 or 0
		local var_5_2 = var_5_0[var_5_1 + 1] or 100

		arg_4_0.currentCost = var_5_2

		local var_5_3

		if var_0_3 - var_5_1 > 0 then
			var_5_3 = var_0_3 - var_5_1
		else
			var_5_3 = 0
		end

		if var_5_3 > 0 then
			arg_4_0.btnSwitch:setTouchEnabled(true)

			if var_5_2 > 0 then
				arg_4_0.tipPanel:get("textfree"):hide()
				arg_4_0.tipPanel:get("cost"):text(var_0_2 .. var_5_2):show()
				arg_4_0.tipPanel:get("diamond"):show()
			else
				arg_4_0.tipPanel:get("textfree"):text(var_0_1):show()
				arg_4_0.tipPanel:get("cost"):hide()
				arg_4_0.tipPanel:get("diamond"):hide()
			end
		else
			arg_4_0.tipPanel:get("textfree"):hide()
			arg_4_0.tipPanel:get("cost"):hide()
			arg_4_0.tipPanel:get("diamond"):hide()
			arg_4_0.btnSwitch:setTouchEnabled(false)
			cache.setShader(arg_4_0.btnSwitch, false, "hsl_gray")
		end

		arg_4_0.leftTimes:get("num"):text(var_5_3 .. "/" .. var_0_3)
	end)
end

function var_0_0.initModel(arg_6_0, arg_6_1)
	local var_6_0 = {}

	for iter_6_0, iter_6_1 in csvMapPairs(csv.draw_card_up_group) do
		table.insert(var_6_0, {
			id = iter_6_0,
			cfg = iter_6_1,
			select = arg_6_1 == iter_6_0
		})
	end

	table.sort(var_6_0, function(arg_7_0, arg_7_1)
		return arg_7_0.id < arg_7_1.id
	end)
	arg_6_0.showDatas:update(var_6_0)
end

function var_0_0.onItemClick(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	arg_8_0.select = arg_8_4.id

	if gGameUI.itemDetailView then
		gGameUI.itemDetailView:onClose()
	end

	local var_8_0 = "city.drawcard.select_property_detail"
	local var_8_1 = "vertical"
	local var_8_2 = {
		"previewPanel"
	}
	local var_8_3 = arg_8_4.id % 2 == 0 and "right" or "left"
	local var_8_4 = tip.create(var_8_0, nil, {
		relativeNode = arg_8_2,
		canvasDir = var_8_1,
		childsName = var_8_2,
		dir = var_8_3
	}, arg_8_4.cfg.cards)

	var_8_4:onNodeEvent("exit", functools.partial(gGameUI.unModal, gGameUI, var_8_4))
	gGameUI:doModal(var_8_4)

	gGameUI.itemDetailView = var_8_4

	arg_8_0:initModel(arg_8_4.id)
end

function var_0_0.onSwitch(arg_9_0)
	if arg_9_0.lastSelect == arg_9_0.select then
		gGameUI:showTip(gLanguageCsv.sameAttributeSwitch)

		return
	end

	if gGameModel.role:read("rmb") < arg_9_0.currentCost then
		uiEasy.showDialog("rmb")

		return
	end

	local function var_9_0()
		gGameApp:requestServer("/game/lottery/card/up/choose", function(arg_11_0)
			arg_9_0:onClose()
		end, arg_9_0.select)
	end

	if arg_9_0.currentCost > 0 then
		gGameUI:showDialog({
			clearFast = true,
			isRich = true,
			btnType = 2,
			content = string.format(gLanguageCsv.costDiamondToSwitch, arg_9_0.currentCost),
			cb = function()
				var_9_0()
			end,
			dialogParams = {
				clickClose = false
			}
		})
	else
		var_9_0()
	end
end

return var_0_0
