local var_0_0 = require("app.views.city.zawake.tools")

local function var_0_1(arg_1_0, arg_1_1)
	local var_1_0 = {}
	local var_1_1 = {}
	local var_1_2 = csv.cards[arg_1_1].develop

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

	if itertools.size(var_1_1) > 0 then
		for iter_1_4, iter_1_5 in ipairs(var_1_0) do
			iter_1_5.curr = false
		end

		for iter_1_6, iter_1_7 in ipairs(var_1_1) do
			if iter_1_7.unitID == arg_1_1 then
				iter_1_7.curr = true
			else
				iter_1_7.curr = false
			end
		end
	end

	return var_1_0, var_1_1
end

local function var_0_2(arg_4_0)
	local var_4_0 = 0

	for iter_4_0, iter_4_1 in arg_4_0:pairs() do
		if iter_4_1:proxy().unitID then
			var_4_0 = var_4_0 + 1
		end
	end

	return var_4_0
end

local var_0_3 = class("CardEvolutionBranchView", Dialog)

var_0_3.RESOURCE_FILENAME = "card_evolution_branch.json"
var_0_3.RESOURCE_BINDING = {
	line12 = "line12",
	branchPanel = "branchPanel",
	btnPanel1 = "btnPanel1",
	line122 = "line122",
	line13 = "line13",
	["btnPanel.btnBranch.title"] = "branchTxt",
	costPanel = "costPanel",
	line133 = "line133",
	["costPanel.text"] = "costText",
	btnPanel = "btnPanel",
	item1 = "item1",
	item2 = "item2",
	["btnPanel.text"] = "specialText",
	["branchPanel.img1"] = "img1",
	["branchPanel.img2"] = "img2",
	spritePanel = "spritePanel",
	["costPanel.item"] = "costItem",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["btnPanel.btnBranch"] = {
		varname = "btnBranch",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSwitch")
			}
		}
	},
	["btnPanel1.btnBranch"] = {
		varname = "btnBranch1",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSwitchChange")
			}
		}
	},
	["branchPanel.list1"] = {
		varname = "list1",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("showData1"),
				item = bindHelper.self("item1"),
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					arg_5_1:multiget("select").select:visible(arg_5_3.curr == true)
					bind.extend(arg_5_0, arg_5_1, {
						class = "card_icon",
						props = {
							cardId = arg_5_3.id,
							onNode = function(arg_6_0)
								arg_6_0:xy(10, 10)
							end,
							onNodeClick = functools.partial(arg_5_0.clickCell, arg_5_2, arg_5_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onSelectClick")
			}
		}
	},
	["branchPanel.list2"] = {
		varname = "list2",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("showData2"),
				item = bindHelper.self("item2"),
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					arg_7_1:multiget("select").select:visible(arg_7_3.curr == true)

					if arg_7_3.id then
						bind.extend(arg_7_0, arg_7_1, {
							class = "card_icon",
							props = {
								cardId = arg_7_3.id,
								onNode = function(arg_8_0)
									arg_8_0:xy(0, 12)
								end,
								onNodeClick = functools.partial(arg_7_0.clickCell, arg_7_2, arg_7_3)
							}
						})
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onList2SelectClick")
			}
		}
	},
	["costPanel.list"] = {
		varname = "costList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 2,
				data = bindHelper.self("developItem"),
				item = bindHelper.self("costItem"),
				onItem = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
					local var_9_0 = false

					if arg_9_3.targetNum then
						var_9_0 = arg_9_3.num < (arg_9_3.targetNum or 0)
					end

					arg_9_1:get("btnAdd"):visible(var_9_0)
					arg_9_1:get("imgMask"):visible(var_9_0)
					bind.extend(arg_9_0, arg_9_1, {
						class = "icon_key",
						props = {
							data = {
								key = arg_9_3.key,
								num = arg_9_3.num,
								targetNum = arg_9_3.targetNum
							},
							onNode = function(arg_10_0)
								bind.click(arg_9_0, arg_10_0, {
									method = functools.partial(arg_9_0.itemClick, arg_10_0, arg_9_2, arg_9_3)
								})
							end
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	}
}

function var_0_3.onCreate(arg_11_0, arg_11_1)
	arg_11_0.costPanel:hide()

	arg_11_0.params = arg_11_1

	local var_11_0, var_11_1, var_11_2, var_11_3, var_11_4 = arg_11_1()

	arg_11_0.oldCurrBranch = var_11_4
	arg_11_0.selectDbId = var_11_3
	arg_11_0.data = var_11_1
	arg_11_0.branch = idler.new(var_11_2)
	arg_11_0.cost = 0

	arg_11_0:initModel()

	local var_11_5 = csv.cards[arg_11_0.cardId].developType
	local var_11_6 = {}
	local var_11_7 = {}

	arg_11_0.developItem = idlers.new()
	arg_11_0.iconItem = {}

	local var_11_8, var_11_9 = var_0_1(var_11_1, arg_11_0.cardId)

	arg_11_0.showData1 = idlers.newWithMap(var_11_8)
	arg_11_0.showData2 = idlers.newWithMap(var_11_9)

	local var_11_10 = csv.cards[arg_11_0.cardId]

	arg_11_0:switchSpriteSpine(var_11_10)

	arg_11_0.isData2Branch = arg_11_0.showData2:size() > 0

	local var_11_11 = false

	for iter_11_0, iter_11_1 in ipairs(var_11_8) do
		if iter_11_1.id == arg_11_0.cardId then
			arg_11_0.btnPanel:hide()
			arg_11_0.btnPanel1:show()

			var_11_11 = true

			break
		end

		arg_11_0.btnPanel1:hide()
		arg_11_0.btnPanel:show()
	end

	for iter_11_2, iter_11_3 in ipairs(var_11_9) do
		if iter_11_3.id == arg_11_0.cardId then
			arg_11_0.btnPanel:hide()
			arg_11_0.btnPanel1:show()

			var_11_11 = true

			break
		end

		arg_11_0.btnPanel1:hide()
		arg_11_0.btnPanel:show()
	end

	if var_11_11 == true then
		local var_11_12 = csv.cards_branch_cost

		for iter_11_4, iter_11_5 in orderCsvPairs(var_11_12) do
			if iter_11_5.developType == var_11_5 then
				local var_11_13 = 0

				for iter_11_6, iter_11_7 in csvPairs(iter_11_5.cost) do
					var_11_13 = var_11_13 + 1
				end

				local var_11_14 = math.min(arg_11_0.switchTimes, var_11_13)

				arg_11_0.cost = iter_11_5.cost[var_11_14].rmb or 0
				var_11_6 = dataEasy.getItemData(iter_11_5.cost[var_11_14])
			end
		end
	end

	local var_11_15 = arg_11_0.costList:x()
	local var_11_16 = arg_11_0.costText:x()

	idlereasy.when(arg_11_0.items, function(arg_12_0, arg_12_1)
		for iter_12_0, iter_12_1 in ipairs(var_11_6) do
			if iter_12_1.key ~= "rmb" and iter_12_1.key ~= "gold" then
				table.insert(var_11_7, {
					key = iter_12_1.key,
					num = arg_12_1[iter_12_1.key] or 0,
					targetNum = iter_12_1.num
				})
			end
		end

		if var_11_6.gold then
			table.insert(var_11_7, {
				key = "gold",
				num = var_11_6.gold
			})
		end

		local var_12_0 = #var_11_7

		arg_11_0.costList:size(200 * var_12_0, 200)
		arg_11_0.costList:x(var_11_15 - 200 * (var_12_0 - 1))
		arg_11_0.costText:x(var_11_16 - 200 * (var_12_0 - 1))

		arg_11_0.item = var_11_7

		arg_11_0.developItem:update(var_11_7)
	end)

	local var_11_17 = var_11_2
	local var_11_18 = var_11_2
	local var_11_19 = 0

	for iter_11_8, iter_11_9 in arg_11_0.showData1:pairs() do
		local var_11_20 = iter_11_9:proxy()

		var_11_19 = var_11_19 + 1

		if var_11_20.curr == true then
			var_11_17 = var_11_19

			break
		end
	end

	arg_11_0.showTab1 = idler.new(var_11_17)
	arg_11_0.showTab2 = idler.new(var_11_18)

	local var_11_21 = arg_11_0.showData1:size()
	local var_11_22 = "line1" .. (arg_11_0.showData2:size() == 0 and var_11_21 or var_11_21 .. arg_11_0.showData2:size())

	if arg_11_0.showData2:size() == 0 then
		arg_11_0.showTab1:addListener(function(arg_13_0, arg_13_1, arg_13_2)
			arg_11_0.btnBranch:setTouchEnabled(arg_13_0 ~= 0)
			arg_11_0.specialText:visible(arg_13_0 == 0)
			cache.setShader(arg_11_0.btnBranch, false, arg_13_0 ~= 0 and "normal" or "hsl_gray")

			if arg_13_0 ~= 0 then
				if var_11_8[arg_13_0].id == arg_11_0.cardId then
					arg_11_0.btnBranch1:setTouchEnabled(false)
					arg_11_0.btnPanel1:get("text"):hide()
					arg_11_0.btnPanel1:get("text1"):hide()
					arg_11_0.btnPanel1:get("icon"):hide()
					arg_11_0.costPanel:hide()
					arg_11_0.btnBranch1:get("title"):text(gLanguageCsv.nowBranch)
					cache.setShader(arg_11_0.btnBranch1, false, "hsl_gray")
				else
					arg_11_0.btnBranch1:setTouchEnabled(true)

					if arg_11_0.cost > 0 then
						arg_11_0.btnPanel1:get("text"):show()
						arg_11_0.btnPanel1:get("text"):text(arg_11_0.cost)
						arg_11_0.btnPanel1:get("text1"):show()
						arg_11_0.btnPanel1:get("icon"):show()
					end

					arg_11_0.costPanel:visible(#arg_11_0.item > 0)
					arg_11_0.btnBranch1:get("title"):text(gLanguageCsv.chanceBranch)
					cache.setShader(arg_11_0.btnBranch1, false, "normal")
				end
			end

			if arg_13_0 ~= 0 then
				text.addEffect(arg_11_0.branchTxt, {
					glow = {
						color = ui.COLORS.GLOW.WHITE
					},
					color = ui.COLORS.NORMAL.WHITE
				})
			else
				text.deleteAllEffect(arg_11_0.branchTxt)
				text.addEffect(arg_11_0.branchTxt, {
					color = ui.COLORS.DISABLED.WHITE
				})
			end

			if arg_13_1 ~= 0 then
				arg_11_0.showData1:atproxy(arg_13_1).curr = false

				arg_11_0[var_11_22]:get("red" .. arg_13_1):hide()
			end

			if arg_13_0 ~= 0 then
				local var_13_0 = arg_11_0.showData1:atproxy(arg_13_0)

				var_13_0.curr = true

				arg_11_0[var_11_22]:get("red" .. arg_13_0):show()
				arg_11_0:switchSpriteSpine(var_13_0)
				arg_11_0.branch:set(var_13_0.currRealBranch)
			end
		end)
	else
		arg_11_0.showTab2:addListener(function(arg_14_0, arg_14_1, arg_14_2)
			arg_11_0.btnBranch:setTouchEnabled(arg_14_0 ~= 0)
			arg_11_0.specialText:visible(arg_14_0 == 0)
			cache.setShader(arg_11_0.btnBranch, false, arg_14_0 ~= 0 and "normal" or "hsl_gray")

			if arg_14_0 ~= 0 then
				if var_11_9[arg_14_0].id == arg_11_0.cardId then
					arg_11_0.btnBranch1:setTouchEnabled(false)
					arg_11_0.btnPanel1:get("text"):hide()
					arg_11_0.btnPanel1:get("text1"):hide()
					arg_11_0.btnPanel1:get("icon"):hide()
					arg_11_0.costPanel:hide()
					arg_11_0.btnBranch1:get("title"):text(gLanguageCsv.nowBranch)
					cache.setShader(arg_11_0.btnBranch1, false, "hsl_gray")
				else
					arg_11_0.btnBranch1:setTouchEnabled(true)

					if arg_11_0.cost > 0 then
						arg_11_0.btnPanel1:get("text"):show()
						arg_11_0.btnPanel1:get("text"):text(arg_11_0.cost)
						arg_11_0.btnPanel1:get("text1"):show()
						arg_11_0.btnPanel1:get("icon"):show()
					end

					arg_11_0.costPanel:visible(#arg_11_0.item > 0)
					arg_11_0.btnBranch1:get("title"):text(gLanguageCsv.chanceBranch)
					cache.setShader(arg_11_0.btnBranch1, false, "normal")
				end
			end

			if arg_14_0 ~= 0 then
				text.addEffect(arg_11_0.branchTxt, {
					glow = {
						color = ui.COLORS.GLOW.WHITE
					},
					color = ui.COLORS.NORMAL.WHITE
				})
			else
				text.deleteAllEffect(arg_11_0.branchTxt)
				text.addEffect(arg_11_0.branchTxt, {
					color = ui.COLORS.DISABLED.WHITE
				})
			end

			if arg_14_1 ~= 0 then
				arg_11_0.showData2:atproxy(arg_14_1).curr = false

				arg_11_0[var_11_22]:get("red" .. arg_14_1):hide()
			end

			if arg_14_0 ~= 0 then
				local var_14_0 = arg_11_0.showData2:atproxy(arg_14_0)

				var_14_0.curr = true

				arg_11_0[var_11_22]:get("red" .. arg_14_0):show()
				arg_11_0:switchSpriteSpine(var_14_0)
				arg_11_0.branch:set(var_14_0.currRealBranch)
			end
		end)
	end

	arg_11_0:setLine(var_11_22)

	local var_11_23 = 1
	local var_11_24 = csv.cards[arg_11_0.cardId].cardMarkID

	for iter_11_10, iter_11_11 in orderCsvPairs(csv.cards) do
		if matchLanguage(iter_11_11.languages) and iter_11_11.cardMarkID == var_11_24 and var_11_0 >= iter_11_11.develop and iter_11_11.branch == 0 and var_11_23 < iter_11_10 then
			var_11_23 = iter_11_10
		end
	end

	local var_11_25 = arg_11_0.showData2:size() == 0 and 178 or 28

	bind.extend(arg_11_0, arg_11_0.branchPanel, {
		class = "card_icon",
		props = {
			cardId = var_11_11 and var_11_23 or arg_11_0.cardId,
			onNode = function(arg_15_0)
				arg_15_0:xy(cc.p(var_11_25, 250))
			end
		}
	})
	idlereasy.when(arg_11_0.rmb, function(arg_16_0, arg_16_1)
		local var_16_0 = arg_16_1 < arg_11_0.cost and ui.COLORS.NORMAL.RED or ui.COLORS.NORMAL.DEFAULT

		text.addEffect(arg_11_0.btnPanel1:get("text"), {
			color = var_16_0
		})
	end)
	arg_11_0:setBottomSpine()
	Dialog.onCreate(arg_11_0)
end

function var_0_3.initModel(arg_17_0)
	local var_17_0 = gGameModel.cards:find(arg_17_0.selectDbId)

	arg_17_0.cardId = var_17_0:read("card_id")
	arg_17_0.rmb = gGameModel.role:getIdler("rmb")
	arg_17_0.switchTimes = var_17_0:read("branch_switch_times") + 1
	arg_17_0.gold = gGameModel.role:getIdler("gold")
	arg_17_0.items = gGameModel.role:getIdler("items")
end

function var_0_3.setBottomSpine(arg_18_0)
	local var_18_0 = arg_18_0.spritePanel:size()
	local var_18_1 = CSprite.new("effect/jinhuajiemian.skel")

	var_18_1:xy(var_18_0.width / 2 - 40, var_18_0.height / 4 - 15)
	var_18_1:play("effect_down2_loop")
	var_18_1:addTo(arg_18_0.spritePanel, 4, "effect1")

	local var_18_2 = CSprite.new("effect/jinhuajiemian.skel")

	var_18_2:xy(var_18_0.width / 2 - 40, var_18_0.height / 4 - 15)
	var_18_2:play("effect_up_loop")
	var_18_2:addTo(arg_18_0.spritePanel, 7, "effect2")
end

function var_0_3.setLine(arg_19_0, arg_19_1)
	local var_19_0 = cc.size(215, 422)
	local var_19_1 = cc.size(214, 432)
	local var_19_2 = cc.size(215, 646)
	local var_19_3 = cc.size(214, 658)
	local var_19_4 = 136
	local var_19_5 = 21
	local var_19_6 = 345

	if arg_19_0.showData2:size() == 0 then
		arg_19_0.list2:hide()

		if arg_19_0.showData1:size() == 2 then
			arg_19_0.list1:xy(533, var_19_4)
			arg_19_0.list1:size(var_19_0)
			arg_19_0.img1:xy(642, var_19_6)
			arg_19_0.img1:size(var_19_1)
		else
			arg_19_0.list1:size(var_19_2)
			arg_19_0.list1:xy(533, var_19_5)
			arg_19_0.img1:xy(645, var_19_6)
			arg_19_0.img1:size(var_19_3)
		end

		arg_19_0.img1:show()
		arg_19_0.img2:hide()
	else
		if arg_19_0.showData1:size() == 2 then
			arg_19_0.list1:xy(364, var_19_4)
			arg_19_0.list1:size(var_19_0)
			arg_19_0.list2:xy(710, var_19_4)
			arg_19_0.list2:size(var_19_0)
			arg_19_0.img1:size(var_19_1)
			arg_19_0.img1:xy(472, var_19_6)
		else
			arg_19_0.list1:xy(364, var_19_5)
			arg_19_0.list1:size(var_19_2)
			arg_19_0.list2:xy(710, var_19_5)
			arg_19_0.list2:size(var_19_2)
			arg_19_0.img1:xy(472, var_19_6)
			arg_19_0.img1:size(var_19_3)
		end

		arg_19_0.img1:hide()
		arg_19_0.img2:visible(var_0_2(arg_19_0.showData2) > 1)
	end

	arg_19_0[arg_19_1]:show()

	local var_19_7 = 0

	for iter_19_0, iter_19_1 in arg_19_0.showData2:pairs() do
		local var_19_8 = iter_19_1:proxy()

		var_19_7 = var_19_7 + 1

		if var_19_8.id == nil then
			arg_19_0[arg_19_1]:get("red" .. var_19_7, "line6"):hide()
			arg_19_0[arg_19_1]:get("white" .. var_19_7):hide()
		end
	end
end

function var_0_3.switchSpriteSpine(arg_20_0, arg_20_1)
	arg_20_0.markID = arg_20_1.cardMarkID

	local var_20_0 = csv.unit[arg_20_1.unitID]
	local var_20_1 = arg_20_0.spritePanel:size()
	local var_20_2 = arg_20_0.spritePanel:multiget("name", "attr2", "rarity", "attr1", "cardImg", "bottom")

	var_20_2.bottom:visible(false)
	var_20_2.cardImg:removeAllChildren()

	local var_20_3 = widget.addAnimation(var_20_2.cardImg, var_20_0.unitRes, "standby_loop")
	local var_20_4 = var_20_2.cardImg:size()

	var_20_3:xy(var_20_4.width / 2, var_20_4.height / 7):scale(var_20_0.scale)
	var_20_3:setSkin(var_20_0.skin)
	var_20_2.name:text(var_20_0.name)
	var_20_2.name:setTextColor(ui.COLORS.NORMAL.DEFAULT)
	var_20_2.attr2:visible(var_20_0.natureType2 ~= nil)

	if var_20_0.natureType2 then
		var_20_2.attr2:texture(ui.ATTR_ICON[var_20_0.natureType2])
	end

	var_20_2.rarity:texture(ui.RARITY_ICON[var_20_0.rarity])
	var_20_2.attr1:texture(ui.ATTR_ICON[var_20_0.natureType])

	if var_20_0.natureType2 then
		adapt.oneLineCenterPos(cc.p(290, 80), {
			var_20_2.rarity,
			var_20_2.name,
			var_20_2.attr1,
			var_20_2.attr2
		}, cc.p(8, 0))
	else
		adapt.oneLineCenterPos(cc.p(290, 80), {
			var_20_2.rarity,
			var_20_2.name,
			var_20_2.attr1
		}, cc.p(8, 0))
	end
end

function var_0_3.onSwitch(arg_21_0)
	userDefault.setForeverLocalKey("evolutionBranch", {
		[arg_21_0.cardId] = arg_21_0.branch:read()
	})
	arg_21_0.params(arg_21_0.branch:read())
	arg_21_0:onClose()
end

function var_0_3.onSwitchChange(arg_22_0)
	if arg_22_0.rmb:read() < arg_22_0.cost then
		uiEasy.showDialog("rmb", nil, {
			dialog = true
		})

		return
	end

	for iter_22_0, iter_22_1 in ipairs(arg_22_0.item) do
		if iter_22_1.key == "gold" then
			if iter_22_1.num > arg_22_0.gold:read() then
				gGameUI:showTip(gLanguageCsv.goldNotEnough)

				return
			end
		elseif iter_22_1.targetNum > iter_22_1.num then
			gGameUI:showTip(gLanguageCsv.branchItemsNotEnough)

			return
		end
	end

	local function var_22_0()
		local var_23_0 = "#C0x5b545b#" .. string.format(gLanguageCsv.onSwitchChange1, arg_22_0.cost)

		if arg_22_0.cost == 0 then
			var_23_0 = "#C0x5b545b#" .. gLanguageCsv.onSwitchChange2
		end

		gGameUI:showDialog({
			btnType = 2,
			isRich = true,
			content = var_23_0,
			cb = function()
				gGameApp:requestServer("/game/card/switch/branch", function(arg_25_0)
					if not itertools.isempty(arg_25_0.view) then
						gGameUI:showGainDisplay(arg_25_0.view)
					end
				end, arg_22_0.selectDbId, arg_22_0.branch:read())
				arg_22_0.oldCurrBranch:set(arg_22_0.branch:read())
				gGameUI:showTip(gLanguageCsv.succeedSwitchChange)
				arg_22_0:onClose()
			end,
			dialogParams = {
				clickClose = false
			}
		})
	end

	local var_22_1 = csv.cards[arg_22_0.cardId].zawakeID
	local var_22_2, var_22_3 = var_0_0.getMaxStageLevel(var_22_1)

	if var_22_2 then
		local var_22_4 = csv.cards[arg_22_0.cardId].name
		local var_22_5 = gLanguageCsv["symbolRome" .. var_22_2]
		local var_22_6 = string.format(gLanguageCsv.zawakeBranchTip, var_22_4, var_22_5)

		gGameUI:showDialog({
			btnType = 2,
			isRich = true,
			content = var_22_6,
			cb = var_22_0
		})
	else
		var_22_0()
	end
end

function var_0_3.onSelectClick(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	local var_26_0 = csv.cards
	local var_26_1 = arg_26_0.showData1:atproxy(arg_26_2)

	if csv.cards[var_26_1.id].develop < csv.cards[arg_26_0.cardId].develop then
		gGameUI:showTip(gLanguageCsv.canNotSwitchChange)

		return
	else
		arg_26_0.showTab1:set(arg_26_2)
	end
end

function var_0_3.onList2SelectClick(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	local var_27_0 = csv.cards
	local var_27_1 = arg_27_0.showData2:atproxy(arg_27_2)

	if csv.cards[var_27_1.id].develop < csv.cards[arg_27_0.cardId].develop then
		gGameUI:showTip(gLanguageCsv.canNotSwitchChange)

		return
	else
		arg_27_0.showTab2:set(arg_27_2)
	end
end

function var_0_3.onItemClick(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	gGameUI:stackUI("common.gain_way", nil, nil, arg_28_4.key, nil, arg_28_4.targetNum)
end

return var_0_3
