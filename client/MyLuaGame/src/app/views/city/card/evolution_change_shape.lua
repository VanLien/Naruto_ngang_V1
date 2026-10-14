local function var_0_0(arg_1_0)
	local var_1_0 = {}
	local var_1_1 = {}

	for iter_1_0, iter_1_1 in ipairs(arg_1_0) do
		if itertools.size(iter_1_1.branch) > 1 then
			var_1_0 = iter_1_1.branch

			table.sort(var_1_0, function(arg_2_0, arg_2_1)
				return arg_2_0.develop < arg_2_1.develop
			end)

			if arg_1_0[iter_1_0 + 1] then
				var_1_1 = arg_1_0[iter_1_0 + 1].branch

				for iter_1_2, iter_1_3 in pairs(var_1_0) do
					if not var_1_1[iter_1_2] then
						var_1_1[iter_1_2] = {}
					end

					var_1_1[iter_1_2].develop = iter_1_3.develop
				end

				table.sort(var_1_1, function(arg_3_0, arg_3_1)
					return arg_3_0.develop < arg_3_1.develop
				end)
			end

			break
		end
	end

	return var_1_0, var_1_1
end

local var_0_1 = class("CardEvolutionChangeShapeView", Dialog)

var_0_1.RESOURCE_FILENAME = "card_change_shape.json"
var_0_1.RESOURCE_BINDING = {
	item = "item1",
	txtNum = "txtNum",
	title1 = "title1",
	txt = "txt",
	nowIcon = "nowIcon1",
	nowIcon1 = "nowIcon2",
	icon = "icon",
	item1 = "item2",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	changeBtn = {
		varname = "changeBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSwitchChange")
			}
		}
	}
}

function var_0_1.onCreate(arg_4_0, arg_4_1)
	arg_4_0.params = arg_4_1

	local var_4_0, var_4_1, var_4_2, var_4_3, var_4_4 = arg_4_1()

	arg_4_0.oldCurrBranch = var_4_4
	arg_4_0.selectDbId = var_4_3
	arg_4_0.changeBranch = var_4_2 == 2 and 1 or 2
	arg_4_0.cost = 0
	arg_4_0.branch = var_4_2 == 0 and 1 or var_4_2
	arg_4_0.nowBranch = 1

	arg_4_0:initModel()
	userDefault.setForeverLocalKey("evolutionBranch", {
		[arg_4_0.cardId:read()] = arg_4_0.branch
	})
	arg_4_0.params(arg_4_0.branch)

	local var_4_5 = csv.cards
	local var_4_6 = var_4_5[arg_4_0.cardId:read()].developType
	local var_4_7 = {}
	local var_4_8, var_4_9 = var_0_0(var_4_1)
	local var_4_10 = var_4_5[var_4_8[arg_4_0.branch].id]
	local var_4_11 = var_4_5[var_4_8[arg_4_0.changeBranch].id]

	arg_4_0.develop = var_4_0
	arg_4_0.nextDevelop = var_4_10.develop

	if arg_4_0.develop ~= arg_4_0.nextDevelop then
		var_4_10 = var_4_5[var_4_8[1].id]
		var_4_11 = var_4_5[var_4_8[2].id]
		arg_4_0.nowBranch = arg_4_0.branch

		arg_4_0.title1:text(gLanguageCsv.qualityExchangeFragmentTitle3)
	end

	arg_4_0:switchSpriteSpine(var_4_10, 1)
	arg_4_0:switchSpriteSpine(var_4_11, 2)

	local var_4_12 = arg_4_0.cardId:read()

	idlereasy.any({
		arg_4_0.switchTimes,
		arg_4_0.oldCurrBranch,
		arg_4_0.cardId
	}, function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		if arg_5_3 ~= var_4_12 then
			var_4_12 = arg_5_3

			gGameUI:showTip(gLanguageCsv.succeedSwitchChangeShape)

			arg_4_0.nowBranch = arg_4_0.nowBranch == 1 and 2 or 1

			arg_4_0.oldCurrBranch:set(arg_4_0.changeBranch)

			arg_4_0.changeBranch = arg_4_0.changeBranch == 1 and 2 or 1
		end

		if arg_4_0.nowBranch == 1 then
			arg_4_0.nowIcon1:show()
			arg_4_0.nowIcon2:hide()
			arg_4_0.item1:get("bottomShow"):show()
			arg_4_0.item1:get("bottomHide"):hide()
			arg_4_0.item2:get("bottomHide"):show()
			arg_4_0.item2:get("bottomShow"):hide()
		else
			arg_4_0.nowIcon2:show()
			arg_4_0.nowIcon1:hide()
			arg_4_0.item2:get("bottomShow"):show()
			arg_4_0.item2:get("bottomHide"):hide()
			arg_4_0.item1:get("bottomHide"):show()
			arg_4_0.item1:get("bottomShow"):hide()
		end

		local var_5_0 = csv.cards_branch_cost

		for iter_5_0, iter_5_1 in orderCsvPairs(var_5_0) do
			if iter_5_1.developType == var_4_6 then
				local var_5_1 = 0

				for iter_5_2, iter_5_3 in csvPairs(iter_5_1.cost) do
					var_5_1 = var_5_1 + 1
				end

				local var_5_2 = math.min(arg_5_1 + 1, var_5_1)

				arg_4_0.cost = iter_5_1.cost[var_5_2].rmb or 0
				var_4_7 = dataEasy.getItemData(iter_5_1.cost[var_5_2])
			end
		end

		arg_4_0.txtNum:text(arg_4_0.cost)

		if arg_4_0.cost == 0 or arg_4_0.develop ~= arg_4_0.nextDevelop then
			arg_4_0.cost = 0

			arg_4_0.txt:hide()
			arg_4_0.txtNum:hide()
			arg_4_0.icon:hide()
		else
			arg_4_0.txt:show()
			arg_4_0.txtNum:show()
			arg_4_0.icon:show()
		end

		adapt.oneLineCenterPos(cc.p(1285 + display.uiOrigin.x, 536), {
			arg_4_0.txt,
			arg_4_0.txtNum,
			arg_4_0.icon
		}, cc.p(15, 0))
	end)
	idlereasy.when(arg_4_0.rmb, function(arg_6_0, arg_6_1)
		local var_6_0 = arg_6_1 < arg_4_0.cost and ui.COLORS.NORMAL.RED or ui.COLORS.NORMAL.DEFAULT

		text.addEffect(arg_4_0.txtNum, {
			color = var_6_0
		})
	end)
	arg_4_0:iconFloat(arg_4_0.nowIcon1)
	arg_4_0:iconFloat(arg_4_0.nowIcon2)
	Dialog.onCreate(arg_4_0)
end

function var_0_1.initModel(arg_7_0)
	local var_7_0 = gGameModel.cards:find(arg_7_0.selectDbId)

	arg_7_0.cardId = var_7_0:getIdler("card_id")
	arg_7_0.switchTimes = var_7_0:getIdler("branch_switch_times")
	arg_7_0.rmb = gGameModel.role:getIdler("rmb")
	arg_7_0.gold = gGameModel.role:getIdler("gold")
	arg_7_0.items = gGameModel.role:getIdler("items")
end

function var_0_1.iconFloat(arg_8_0, arg_8_1)
	local var_8_0, var_8_1 = arg_8_1:xy()
	local var_8_2 = var_8_1 + 10
	local var_8_3 = var_8_1 - 10
	local var_8_4 = 0.2

	arg_8_0:enableSchedule():schedule(function()
		var_8_1 = var_8_1 + var_8_4

		if var_8_1 >= 1030 then
			var_8_4 = -0.2
		elseif var_8_1 <= 1010 then
			var_8_4 = 0.2
		end

		arg_8_1:y(var_8_1)
	end, 0.016666666666666666, 0, "controlIconFloat" .. var_8_0)
end

function var_0_1.setBottomSpine(arg_10_0)
	local var_10_0 = arg_10_0.item:size()
	local var_10_1 = CSprite.new("effect/jinhuajiemian.skel")

	var_10_1:xy(var_10_0.width / 2 - 40, var_10_0.height / 4 - 15)
	var_10_1:play("effect_down2_loop")
	var_10_1:addTo(arg_10_0.item, 4, "effect1")

	local var_10_2 = CSprite.new("effect/jinhuajiemian.skel")

	var_10_2:xy(var_10_0.width / 2 - 40, var_10_0.height / 4 - 15)
	var_10_2:play("effect_up_loop")
	var_10_2:addTo(arg_10_0.item, 7, "effect2")
end

function var_0_1.switchSpriteSpine(arg_11_0, arg_11_1, arg_11_2)
	arg_11_0.markID = arg_11_1.cardMarkID

	local var_11_0 = csv.unit[arg_11_1.unitID]
	local var_11_1 = arg_11_0["item" .. arg_11_2]
	local var_11_2 = var_11_1:size()
	local var_11_3 = var_11_1:multiget("name", "attr2", "rarity", "attr1", "cardImg")

	var_11_3.cardImg:removeAllChildren()

	local var_11_4 = widget.addAnimation(var_11_3.cardImg, var_11_0.unitRes, "standby_loop")
	local var_11_5 = var_11_3.cardImg:size()

	var_11_4:xy(var_11_5.width / 2, var_11_5.height / 7):scale(var_11_0.scale)
	var_11_4:setSkin(var_11_0.skin)
	var_11_3.name:text(var_11_0.name)
	var_11_3.name:setTextColor(ui.COLORS.NORMAL.DEFAULT)
	var_11_3.attr2:visible(var_11_0.natureType2 ~= nil)

	if var_11_0.natureType2 then
		var_11_3.attr2:texture(ui.ATTR_ICON[var_11_0.natureType2])
	end

	var_11_3.rarity:texture(ui.RARITY_ICON[var_11_0.rarity])
	var_11_3.attr1:texture(ui.ATTR_ICON[var_11_0.natureType])

	if var_11_0.natureType2 then
		adapt.oneLineCenterPos(cc.p(290, 75), {
			var_11_3.rarity,
			var_11_3.name,
			var_11_3.attr1,
			var_11_3.attr2
		}, cc.p(8, 0))
	else
		adapt.oneLineCenterPos(cc.p(290, 75), {
			var_11_3.rarity,
			var_11_3.name,
			var_11_3.attr1
		}, cc.p(8, 0))
	end
end

function var_0_1.onSwitchChange(arg_12_0)
	if arg_12_0.rmb:read() < arg_12_0.cost then
		uiEasy.showDialog("rmb", nil, {
			dialog = true
		})

		return
	end

	local var_12_0 = "#C0x5b545b#" .. string.format(gLanguageCsv.onSwitchChangeShape, arg_12_0.cost)

	if arg_12_0.cost == 0 then
		var_12_0 = "#C0x5b545b#" .. gLanguageCsv.onSwitchChangeShape1
	end

	if arg_12_0.develop == arg_12_0.nextDevelop then
		gGameUI:showDialog({
			btnType = 2,
			isRich = true,
			content = var_12_0,
			cb = function()
				gGameApp:requestServer("/game/card/switch/branch", function(arg_14_0)
					if not itertools.isempty(arg_14_0.view) then
						gGameUI:showGainDisplay(arg_14_0.view)
					end
				end, arg_12_0.selectDbId, arg_12_0.changeBranch)
			end,
			dialogParams = {
				clickClose = false
			}
		})
	else
		userDefault.setForeverLocalKey("evolutionBranch", {
			[arg_12_0.cardId:read()] = arg_12_0.changeBranch
		})

		arg_12_0.nowBranch = arg_12_0.nowBranch == 1 and 2 or 1

		arg_12_0.params(arg_12_0.changeBranch)
		gGameUI:showTip(gLanguageCsv.succeedChanceChangeShape)

		arg_12_0.changeBranch = arg_12_0.changeBranch == 1 and 2 or 1
	end
end

return var_0_1
