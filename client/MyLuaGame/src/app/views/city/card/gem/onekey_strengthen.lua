local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("GemOneKeyStrengthenView", Dialog)
local var_0_2 = table.insert

var_0_1.RESOURCE_FILENAME = "gem_onekey_strengthen.json"
var_0_1.RESOURCE_BINDING = {
	txtCost = "txtCost",
	["sliderPanel.slider"] = "slider",
	level = "txtLevel",
	["sliderPanel.subBtn"] = {
		varname = "sliderSubBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_1_0, arg_1_1, arg_1_2)
				return arg_1_0:onChangeNum(arg_1_1, arg_1_2, -1)
			end)
		}
	},
	["sliderPanel.addBtn"] = {
		varname = "sliderAddBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_2_0, arg_2_1, arg_2_2)
				return arg_2_0:onChangeNum(arg_2_1, arg_2_2, 1)
			end)
		}
	},
	btnSure = {
		varname = "btnSure",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClickBtnSure")
			}
		}
	},
	["btnSure.text"] = {
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
	title = {
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
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1)
	arg_3_0:enableSchedule()
	arg_3_0:initModel()

	arg_3_0.gemdbid = arg_3_1

	arg_3_0.slider:setPercent(50)

	arg_3_0.curLv = gGameModel.gems:find(arg_3_1):read("level")

	local var_3_0 = dataEasy.getCfgByKey(gGameModel.gems:find(arg_3_1):read("gem_id"))

	arg_3_0.levelMax = var_3_0.strengthMax
	arg_3_0.costNodes = {}
	arg_3_0.levelCosts = {}

	local var_3_1 = {}

	for iter_3_0 = arg_3_0.curLv, arg_3_0.levelMax do
		local var_3_2 = csv.gem.cost[iter_3_0]["costItemMap" .. var_3_0.strengthCostSeq]

		for iter_3_1, iter_3_2 in csvMapPairs(var_3_2) do
			var_3_1[iter_3_1] = (var_3_1[iter_3_1] or 0) + iter_3_2
		end

		arg_3_0.levelCosts[iter_3_0] = {}

		for iter_3_3, iter_3_4 in pairs(var_3_1) do
			arg_3_0.levelCosts[iter_3_0][iter_3_3] = iter_3_4
		end
	end

	arg_3_0:calculateLvUpMax()

	arg_3_0.level = idler.new(arg_3_0.curLv + 1)

	idlereasy.when(arg_3_0.level, function(arg_4_0, arg_4_1)
		arg_3_0:setDetail()
	end)
	idlereasy.when(arg_3_0.gold, function()
		arg_3_0:calculateLvUpMax()
		arg_3_0:setDetail()
	end)
	arg_3_0.slider:addEventListener(function(arg_6_0, arg_6_1)
		arg_3_0:unScheduleAll()

		local var_6_0 = arg_6_0:getPercent()
		local var_6_1 = cc.clampf(arg_3_0.curLv + math.ceil((arg_3_0.levelMax - arg_3_0.curLv) * var_6_0 * 0.01), arg_3_0.curLv + 1, arg_3_0.canLvUpMax)

		arg_3_0.level:set(var_6_1)

		if var_6_1 >= arg_3_0.canLvUpMax then
			local var_6_2 = math.ceil((var_6_1 - arg_3_0.curLv) / (arg_3_0.levelMax - arg_3_0.curLv) * 100)

			arg_3_0.slider:setPercent(var_6_2)
		end
	end)
	Dialog.onCreate(arg_3_0)
end

function var_0_1.calculateLvUpMax(arg_7_0)
	arg_7_0.canLvUpMax = arg_7_0.levelMax

	for iter_7_0 = arg_7_0.curLv, arg_7_0.levelMax do
		local var_7_0 = arg_7_0.levelCosts[iter_7_0]

		for iter_7_1, iter_7_2 in pairs(var_7_0) do
			if iter_7_2 > dataEasy.getNumByKey(iter_7_1) and iter_7_0 >= arg_7_0.curLv + 1 then
				arg_7_0.canLvUpMax = iter_7_0

				return
			end
		end
	end
end

function var_0_1.setDetail(arg_8_0)
	local var_8_0 = arg_8_0.level:read()

	arg_8_0.txtLevel:setString(var_8_0 .. "/" .. arg_8_0.levelMax)

	if not arg_8_0.slider:isHighlighted() then
		local var_8_1 = math.ceil((var_8_0 - arg_8_0.curLv) / (arg_8_0.levelMax - arg_8_0.curLv) * 100)

		arg_8_0.slider:setPercent(var_8_1)
	end

	local var_8_2 = arg_8_0.levelCosts[var_8_0 - 1]

	for iter_8_0, iter_8_1 in pairs(arg_8_0.costNodes) do
		iter_8_1:removeSelf()
	end

	local var_8_3 = {
		arg_8_0.txtCost
	}

	arg_8_0.costNodes = {}
	arg_8_0.costNeed = nil

	for iter_8_2, iter_8_3 in pairs(var_8_2) do
		local var_8_4 = cc.Label:createWithTTF(iter_8_3, ui.FONT_PATH, 40):addTo(arg_8_0:getResourceNode(), 100):setTextColor(ui.COLORS.NORMAL.BLACK)
		local var_8_5 = ccui.ImageView:create(dataEasy.getIconResByKey(iter_8_2)):addTo(arg_8_0:getResourceNode(), 100):scale(0.8)

		var_0_2(arg_8_0.costNodes, var_8_4)
		var_0_2(arg_8_0.costNodes, var_8_5)
		var_0_2(var_8_3, var_8_4)
		var_0_2(var_8_3, var_8_5)

		if iter_8_3 > dataEasy.getNumByKey(iter_8_2) then
			text.addEffect(var_8_4, {
				color = ui.COLORS.NORMAL.RED
			})

			arg_8_0.costNeed = iter_8_2
		end
	end

	local var_8_6 = {}
	local var_8_7 = true

	for iter_8_4 = 1, #var_8_3 do
		var_0_2(var_8_6, var_8_7 and cc.p(15, 0) or cc.p(0, 0))

		var_8_7 = not var_8_7
	end

	adapt.oneLineCenterPos(cc.p(arg_8_0.btnSure:x(), arg_8_0.txtCost:y()), var_8_3, var_8_6)
	cache.setShader(arg_8_0.sliderAddBtn, false, var_8_0 >= arg_8_0.canLvUpMax and "hsl_gray" or "normal")
	cache.setShader(arg_8_0.sliderSubBtn, false, var_8_0 <= arg_8_0.curLv + 1 and "hsl_gray" or "normal")
end

function var_0_1.onIncreaseNum(arg_9_0, arg_9_1)
	arg_9_0.level:modify(function(arg_10_0)
		return true, cc.clampf(arg_10_0 + arg_9_1, arg_9_0.curLv + 1, arg_9_0.canLvUpMax)
	end)
end

function var_0_1.onChangeNum(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	if arg_11_2.name == "click" then
		arg_11_0:unScheduleAll()
		arg_11_0:onIncreaseNum(arg_11_3)
	elseif arg_11_2.name == "began" then
		arg_11_0:schedule(function()
			arg_11_0:onIncreaseNum(arg_11_3)
		end, 0.05, 0, 100)
	elseif arg_11_2.name == "ended" or arg_11_2.name == "cancelled" then
		arg_11_0:unScheduleAll()
	end
end

function var_0_1.onClickBtnSure(arg_13_0)
	if arg_13_0.costNeed then
		if arg_13_0.costNeed == "gold" then
			uiEasy.showDialog("gold")
		else
			gGameUI:showTip(gLanguageCsv.materialsNotEnough)
		end

		return
	end

	local var_13_0 = arg_13_0.gemdbid
	local var_13_1 = arg_13_0.level:read()

	var_0_0.onClose(arg_13_0)
	gGameApp:requestServer("/game/gem/strength", nil, var_13_0, var_13_1)
end

function var_0_1.initModel(arg_14_0)
	arg_14_0.gold = gGameModel.role:getIdler("gold")
end

return var_0_1
