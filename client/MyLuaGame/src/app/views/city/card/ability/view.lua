local var_0_0 = {
	"city/card/ability/panel_jctx.png",
	"city/card/ability/panel_pttx.png",
	"city/card/ability/panel_hxtx.png"
}
local var_0_1 = {
	0.82,
	0.9,
	1
}
local var_0_2 = {
	850,
	851
}
local var_0_3 = require("app.views.city.card.ability.tools")
local var_0_4 = class("CardAbilityView", cc.load("mvc").ViewBase)

var_0_4.RESOURCE_FILENAME = "card_ability.json"
var_0_4.RESOURCE_BINDING = {
	bar = "bar",
	item = "item",
	panel = "panel",
	abilityPanel = "abilityPanel",
	bar1 = "bar1",
	barBg = "barBg",
	strengthenPanel = "strengthenPanel",
	closePanel = {
		varname = "closePanel",
		binds = {
			event = "click",
			method = bindHelper.self("onClosePanel")
		}
	},
	["panel.costInfo1.btnAdd"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_1_0)
					return arg_1_0:onDetailClick(1)
				end)
			}
		}
	},
	["panel.costInfo2.btnAdd"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_2_0)
					return arg_2_0:onDetailClick(2)
				end)
			}
		}
	}
}

function var_0_4.onCreate(arg_3_0, arg_3_1)
	arg_3_0.selectDbId = arg_3_1()

	arg_3_0:initModel()

	arg_3_0.selectPos = idler.new(0)

	idlereasy.when(arg_3_0.cardId, function(arg_4_0, arg_4_1)
		arg_3_0.abilityPanel:removeAllChildren()

		local var_4_0 = csv.cards[arg_3_0.cardId:read()]
		local var_4_1 = gCardAbilityCsv[var_4_0.abilitySeqID]
		local var_4_2 = arg_3_0.abilityPanel:size()
		local var_4_3 = ""

		for iter_4_0 = 1, table.maxn(var_4_1) do
			local var_4_4 = var_4_1[iter_4_0]

			if var_4_4 then
				var_4_3 = var_4_4.baseSrc

				local var_4_5 = arg_3_0.item:clone():show():xy(var_4_2.width / 2 + var_4_4.pos.x, var_4_2.height / 2 + var_4_4.pos.y):name("item" .. iter_4_0):addTo(arg_3_0.abilityPanel, 20 - iter_4_0)

				bind.touch(arg_3_0, var_4_5, {
					scaletype = 0,
					longtouch = 0.2,
					method = function(arg_5_0, arg_5_1, arg_5_2)
						arg_3_0:onItemClick(arg_5_2, arg_5_1, iter_4_0, var_4_4)
					end
				})
				var_4_5:get("select"):scale(var_0_1[var_4_4.type])
				var_4_5:get("icon"):texture(var_4_4.icon):scale(var_0_1[var_4_4.type] * 2)
				var_4_5:get("iconBg"):texture(var_0_0[var_4_4.type])
				var_4_5:get("textLv"):scale(var_0_1[var_4_4.type] + 0.1)
				var_4_5:get("lvBg"):scale(var_0_1[var_4_4.type] + 0.1)

				for iter_4_1, iter_4_2 in orderCsvPairs(var_4_4.preAbilityID) do
					arg_3_0:setAngleByPos(var_4_5, var_4_4.id, iter_4_2, false)
				end
			end
		end

		arg_3_0.panel:get("imgBG"):texture(var_4_3)
		arg_3_0.abilities:notify()
	end)
	idlereasy.when(arg_3_0.abilities, function(arg_6_0, arg_6_1)
		local var_6_0 = csv.cards[arg_3_0.cardId:read()]
		local var_6_1 = gCardAbilityCsv[var_6_0.abilitySeqID]

		for iter_6_0 = 1, table.maxn(var_6_1) do
			local var_6_2 = var_6_1[iter_6_0]

			if var_6_2 then
				local var_6_3 = arg_3_0.abilityPanel:get("item" .. iter_6_0)

				if var_6_3 then
					var_6_3:get("select"):visible(arg_3_0.selectPos:read() == iter_6_0)

					local var_6_4 = arg_6_1[iter_6_0] or 0

					if var_6_2.iconGray == "" then
						cache.setShader(var_6_3:get("icon"), false, var_6_4 == 0 and "hsl_gray_white" or "normal")
					else
						var_6_3:get("icon"):texture(var_6_4 == 0 and var_6_2.iconGray or var_6_2.icon)
					end

					cache.setShader(var_6_3:get("iconBg"), false, var_6_4 == 0 and "hsl_gray_white" or "normal")
					var_6_3:get("textLv"):text(var_6_4 .. "/" .. var_6_2.strengthMax)

					if not arg_3_0.oldLv[iter_6_0] then
						arg_3_0.oldLv[iter_6_0] = {}
					end

					for iter_6_1, iter_6_2 in orderCsvPairs(var_6_2.preAbilityID) do
						local var_6_5 = arg_6_1[iter_6_2] or 0
						local var_6_6 = false

						if arg_3_0.oldLv[iter_6_0][iter_6_2] == 0 and var_6_5 == 1 then
							var_6_6 = true
						end

						arg_3_0:setAngleByPos(var_6_3, var_6_2.id, iter_6_2, var_6_6)

						arg_3_0.oldLv[iter_6_0][iter_6_2] = var_6_5
					end
				end
			end
		end
	end)
	idlereasy.any({
		arg_3_0.abilities,
		arg_3_0.advance,
		arg_3_0.cardLv
	}, function(arg_7_0, arg_7_1)
		local var_7_0 = csv.cards[arg_3_0.cardId:read()]
		local var_7_1 = gCardAbilityCsv[var_7_0.abilitySeqID]

		for iter_7_0 = 1, table.maxn(var_7_1) do
			local var_7_2 = var_7_1[iter_7_0]

			if var_7_2 then
				local var_7_3 = arg_3_0.abilityPanel:get("item" .. iter_7_0)

				if var_7_3 then
					local var_7_4 = arg_7_1[iter_7_0] or 0

					if #var_0_3.getConditionStr(arg_3_0.selectDbId:read(), var_7_2.id) == 0 and var_7_4 == 0 then
						var_0_3.setEffect({
							effectName = "effect_shiyongzhong_loop",
							zOrder = 9,
							spinePath = "figure/touxiang.skel",
							parent = var_7_3,
							scale = var_0_1[var_7_2.type] - 0.3
						})
					else
						local var_7_5 = var_7_3:get("effect")

						if var_7_5 then
							var_7_5:hide()
						end
					end
				end
			end
		end
	end)
	arg_3_0.selectPos:addListener(function(arg_8_0, arg_8_1)
		local var_8_0 = arg_3_0.abilityPanel:get("item" .. arg_8_1)

		if var_8_0 then
			var_8_0:get("select"):hide()
		end

		local var_8_1 = arg_3_0.abilityPanel:get("item" .. arg_8_0)

		if var_8_1 then
			var_8_1:get("select"):show()
			var_0_3.setEffect({
				effectName = "effect_xuanzhong",
				spinePath = "figure/touxiang.skel",
				parent = var_8_1:get("select"),
				scale = var_8_1:get("select"):scale()
			})
		end
	end)
	idlereasy.when(arg_3_0.items, function(arg_9_0, arg_9_1)
		for iter_9_0, iter_9_1 in pairs(var_0_2) do
			local var_9_0 = arg_3_0.panel:get("costInfo" .. iter_9_0):multiget("textCostNum", "imgIcon")
			local var_9_1 = csv.items[iter_9_1].icon

			var_9_0.textCostNum:text(mathEasy.getShortNumber(arg_9_1[iter_9_1] or 0, 2))
			var_9_0.imgIcon:texture(var_9_1):scale(1.12)
		end
	end)

	arg_3_0.refreshData = idlertable.new({
		id = 0,
		cardDbid = arg_3_0.selectDbId:read()
	})
	arg_3_0.strengthen = nil
	arg_3_0.strengthen = gGameUI:createView("city.card.ability.strengthen", arg_3_0.strengthenPanel):init(arg_3_0:createHandler("refreshData"), arg_3_0:createHandler("onClosePanel"))

	arg_3_0:onClosePanel()
end

function var_0_4.initModel(arg_10_0)
	arg_10_0.gold = gGameModel.role:getIdler("gold")
	arg_10_0.items = gGameModel.role:getIdler("items")

	idlereasy.when(arg_10_0.selectDbId, function(arg_11_0, arg_11_1)
		arg_10_0.oldLv = {}

		if assertInWindows(arg_11_1, "val:%s", tostring(arg_11_1)) then
			return
		end

		local var_11_0 = gGameModel.cards:find(arg_11_1)

		arg_10_0.cardId = idlereasy.assign(var_11_0:getIdler("card_id"), arg_10_0.cardId)
		arg_10_0.abilities = idlereasy.assign(var_11_0:getIdler("abilities"), arg_10_0.abilities)
		arg_10_0.advance = idlereasy.assign(var_11_0:getIdler("advance"), arg_10_0.advance)
		arg_10_0.cardLv = idlereasy.assign(var_11_0:getIdler("level"), arg_10_0.cardLv)
	end)
end

function var_0_4.setAngleByPos(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = csv.card_ability[arg_12_2]
	local var_12_1 = csv.card_ability[gCardAbilityCsv[var_12_0.abilitySeqID][arg_12_3].id]
	local var_12_2 = var_12_1.pos.x - var_12_0.pos.x
	local var_12_3 = var_12_1.pos.y - var_12_0.pos.y
	local var_12_4 = arg_12_0.abilities:read()[arg_12_3] or 0
	local var_12_5 = math.sqrt(math.pow(var_12_2, 2) + math.pow(var_12_3, 2))
	local var_12_6 = math.atan2(var_12_2, var_12_3) * 180 / math.pi

	var_12_6 = var_12_6 > 0 and var_12_6 - 270 or var_12_6 + 90

	local var_12_7 = arg_12_1:get("barBg" .. arg_12_3)
	local var_12_8 = arg_12_0.barBg:size().height
	local var_12_9

	var_12_9 = var_12_7 or arg_12_0.barBg:clone():show():xy(100 + var_12_2 / 2, 100 + var_12_3 / 2):name("barBg" .. arg_12_3):setRotation(var_12_6):size(var_12_5, var_12_8):addTo(arg_12_1, 1)

	local var_12_10 = arg_12_1:get("bar" .. arg_12_3) or arg_12_0.bar:clone():show():setCapInsets(cc.rect(36, 0, 1, 1)):xy(100 + var_12_2 / 2, 100 + var_12_3 / 2):name("bar" .. arg_12_3):setRotation(var_12_6):size(var_12_5, var_12_8):addTo(arg_12_1, 2)
	local var_12_11 = (var_12_4 == 0 or arg_12_4) and 20 or 100

	if var_12_10:getPercent() == 20 or var_12_10:getPercent() == 100 then
		var_12_10:setPercent(var_12_11)
	end

	if arg_12_4 then
		transition.executeParallel(arg_12_1:get("bar" .. arg_12_3)):progressTo(0.8, 100)
	end
end

function var_0_4.onItemClick(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	arg_13_0.selectPos:set(arg_13_3, true)
	arg_13_0.strengthenPanel:show()
	arg_13_0.closePanel:show()
	arg_13_0.refreshData:set({
		cardDbid = arg_13_0.selectDbId:read(),
		id = arg_13_4.id
	})
end

function var_0_4.onDetailClick(arg_14_0, arg_14_1)
	gGameUI:stackUI("common.gain_way", nil, nil, var_0_2[arg_14_1])
end

function var_0_4.onClosePanel(arg_15_0)
	arg_15_0.strengthenPanel:hide()
	arg_15_0.closePanel:hide()
	arg_15_0.selectPos:set(0)
end

return var_0_4
