local var_0_0 = require("app.views.city.zawake.tools")
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("ZawakeForceView", Dialog)

var_0_2.RESOURCE_FILENAME = "zawake_force.json"
var_0_2.RESOURCE_BINDING = {
	leftInnerList = "leftInnerList",
	item = "item",
	leftItem = "leftItem",
	downListTips = "downListTips",
	["bgPanel.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnRule = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleClick")
			}
		}
	},
	textLv = {
		binds = {
			event = "text",
			idler = bindHelper.self("lvText")
		}
	},
	textExp = {
		binds = {
			event = "text",
			idler = bindHelper.self("expText")
		}
	},
	expBar = {
		varname = "bar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				maskImg = "common/icon/mask_bar_red.png",
				data = bindHelper.self("expSlider")
			}
		}
	},
	rightList = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("listDatas"),
				item = bindHelper.self("item"),
				level = bindHelper.self("level"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("num", "txt")

					var_1_0.txt:removeAllChildren()
					var_1_0.num:text(string.format("Lv.%s:", arg_1_3.level))

					local var_1_1 = arg_1_0.level:read()
					local var_1_2 = false

					if var_1_1 < arg_1_3.level then
						text.addEffect(var_1_0.num, {
							color = ui.COLORS.DISABLED.GRAY
						})

						var_1_2 = true
					end

					local var_1_3 = var_0_0.getAttrStr(arg_1_3.cfg, var_1_2)
					local var_1_4 = arg_1_1:width() - var_1_0.num:width() - var_1_0.num:x() - 20
					local var_1_5 = rich.createWithWidth(var_1_3, 44, nil, var_1_4)

					var_1_5:anchorPoint(0, 0)
					var_1_5:xy(0, 0)
					var_1_5:addTo(var_1_0.txt)
					arg_1_1:height(var_1_5:height() + 10)
					var_1_0.num:y(arg_1_1:height() - 30)
					adapt.oneLinePos(var_1_0.num, var_1_0.txt, cc.p(5, 0))
					var_1_0.txt:y(5)
				end
			}
		}
	},
	leftList = {
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 6,
				data = bindHelper.self("attrCardDatas"),
				item = bindHelper.self("leftInnerList"),
				cell = bindHelper.self("leftItem"),
				onCell = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("icon", "txt")
					local var_2_1 = {}

					for iter_2_0, iter_2_1 in pairs(arg_2_3.zawakeDate) do
						table.insert(var_2_1, {
							stage = iter_2_0,
							level = iter_2_1
						})
					end

					table.sort(var_2_1, function(arg_3_0, arg_3_1)
						return arg_3_0.stage > arg_3_1.stage
					end)
					var_2_0.txt:text(string.format("%s%s", gLanguageCsv.effortAdvance, gLanguageCsv["symbolRome" .. var_2_1[1].stage]))

					local var_2_2 = csv.cards[arg_2_3.cardId]
					local var_2_3 = csv.unit[var_2_2.unitID]

					bind.extend(arg_2_0, var_2_0.icon, {
						class = "card_icon",
						props = {
							cardId = arg_2_3.cardId,
							rarity = var_2_3.rarity,
							onNode = function(arg_4_0)
								arg_4_0:anchorPoint(0.5, 0.5)

								local var_4_0 = var_2_0.icon:size()

								arg_4_0:xy(var_4_0.width / 2, var_4_0.height / 2)
								arg_4_0:scale(0.7)
							end
						}
					})
				end
			}
		}
	}
}

function var_0_2.onCreate(arg_5_0)
	Dialog.onCreate(arg_5_0)
	arg_5_0:initModel()
	idlereasy.when(arg_5_0.zawake, function(arg_6_0, arg_6_1)
		if arg_6_1 == nil then
			arg_6_1 = {}
		end

		local var_6_0 = 0
		local var_6_1 = 0
		local var_6_2 = 0
		local var_6_3 = 0
		local var_6_4 = 0
		local var_6_5 = {}

		for iter_6_0, iter_6_1 in pairs(arg_6_1) do
			for iter_6_2, iter_6_3 in pairs(iter_6_1) do
				for iter_6_4 = 1, iter_6_3 do
					local var_6_6 = var_0_0.getLevelCfg(iter_6_0, iter_6_2, iter_6_3)

					if not var_6_6 then
						break
					end

					var_6_0 = var_6_0 + var_6_6.exp
				end
			end

			local var_6_7 = var_0_0.getCardByZawakeID(iter_6_0)

			var_6_7.zawakeDate = iter_6_1

			table.insert(var_6_5, var_6_7)
		end

		arg_5_0.attrCardDatas:update(var_6_5)
		arg_5_0.downListTips:visible(#var_6_5 == 0)

		local var_6_8 = {}

		for iter_6_5, iter_6_6 in csvPairs(csv.zawake.bonus) do
			table.insert(var_6_8, {
				cfg = iter_6_6,
				level = iter_6_5
			})
		end

		table.sort(var_6_8, function(arg_7_0, arg_7_1)
			return arg_7_0.level < arg_7_1.level
		end)

		for iter_6_7, iter_6_8 in ipairs(var_6_8) do
			var_6_3 = iter_6_8.cfg.exp
			var_6_2 = var_6_2 + var_6_3
			var_6_1 = var_6_2 - var_6_0

			if var_6_1 > 0 then
				var_6_4 = iter_6_8.level - 1

				break
			elseif iter_6_7 == csvSize(csv.zawake.bonus) and var_6_2 <= var_6_0 then
				var_6_4 = iter_6_8.level
			end
		end

		arg_5_0.level:set(var_6_4)
		arg_5_0.listDatas:update(var_6_8)
		arg_5_0.lvText:set("Lv:" .. var_6_4)
		arg_5_0.expText:set(var_6_1 >= 0 and string.format("%s/%s", var_6_3 - var_6_1, var_6_3) or "Max")

		local var_6_9 = 100

		if var_6_3 - var_6_1 >= 0 then
			var_6_9 = cc.clampf(100 * (var_6_3 - var_6_1) / var_6_3, 0, 100)
		end

		arg_5_0.expSlider:set(var_6_9)
	end)
end

function var_0_2.initModel(arg_8_0)
	arg_8_0.zawake = gGameModel.role:getIdler("zawake")
	arg_8_0.attrCardDatas = idlers.newWithMap({})
	arg_8_0.listDatas = idlers.newWithMap({})
	arg_8_0.lvText = idler.new("")
	arg_8_0.expText = idler.new("")
	arg_8_0.level = idler.new(0)
	arg_8_0.expSlider = idler.new(0)
end

function var_0_2.onRuleClick(arg_9_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_9_0:createHandler("getRuleContext"), {
		width = 1500
	})
end

function var_0_2.getRuleContext(arg_10_0, arg_10_1)
	local var_10_0 = adaptContext

	return {
		var_10_0.clone(arg_10_1.title, function(arg_11_0)
			arg_11_0:get("text"):text(gLanguageCsv.zawakeForceLevelTitle)
		end),
		var_10_0.noteText(124101, 124151)
	}
end

return var_0_2
