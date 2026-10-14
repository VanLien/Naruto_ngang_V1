local var_0_0 = require("app.views.city.zawake.tools")
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("ZawakeReplaceView", Dialog)

var_0_2.RESOURCE_FILENAME = "zawake_choose_card.json"
var_0_2.RESOURCE_BINDING = {
	tipPanel = "tipPanel",
	item = "item",
	innerList = "innerList",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	list = {
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 3,
				asyncPreload = 12,
				data = bindHelper.self("cardDatas"),
				item = bindHelper.self("innerList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("icon", "textFightPoint", "textLevel", "textStage", "txt1", "maskPanel")

					var_1_0.maskPanel:visible(arg_1_3.isSelf)
					var_1_0.textFightPoint:text(arg_1_3.maxFightPoint)
					var_1_0.textLevel:text(string.format("(%s/8)", arg_1_3.level))
					var_1_0.textStage:text(gLanguageCsv.effortAdvance .. gLanguageCsv["symbolRome" .. arg_1_3.stage])
					adapt.oneLinePos(var_1_0.textStage, var_1_0.textLevel, cc.p(10, 0))

					local var_1_1 = csv.cards[arg_1_3.cfg.id]
					local var_1_2 = csv.unit[var_1_1.unitID].rarity

					bind.extend(arg_1_0, var_1_0.icon, {
						class = "card_icon",
						props = {
							cardId = arg_1_3.cfg.id,
							rarity = var_1_2
						}
					})
					arg_1_1:onClick(functools.partial(arg_1_0.clickSelect, arg_1_2, arg_1_3))
				end
			},
			handlers = {
				clickSelect = bindHelper.self("onSelectClick")
			}
		}
	}
}

function var_0_2.onCreate(arg_2_0, arg_2_1)
	Dialog.onCreate(arg_2_0)

	arg_2_0.zawakeID = arg_2_1.zawakeID

	arg_2_0:initModel()
	arg_2_0:updateCards()
end

function var_0_2.updateCards(arg_3_0)
	local var_3_0 = var_0_0.getAllCards()
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		local var_3_2, var_3_3 = var_0_0.getMaxStageLevel(iter_3_0)

		if not var_3_2 then
			var_3_2 = 1
			var_3_3 = 0
		end

		table.insert(var_3_1, {
			zawakeID = iter_3_0,
			stage = var_3_2,
			level = var_3_3,
			cfg = iter_3_1.cfg,
			maxFightPoint = iter_3_1.maxFightPoint,
			isSelf = arg_3_0.zawakeID:read() == iter_3_0
		})
	end

	table.sort(var_3_1, function(arg_4_0, arg_4_1)
		return arg_4_0.maxFightPoint > arg_4_1.maxFightPoint
	end)
	arg_3_0.tipPanel:visible(#var_3_1 == 0)
	arg_3_0.cardDatas:update(var_3_1)
end

function var_0_2.initModel(arg_5_0)
	arg_5_0.zawake = gGameModel.role:read("zawake") or {}
	arg_5_0.cardDatas = idlers.newWithMap({})
end

function var_0_2.onSelectClick(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_0.zawakeID:set(arg_6_3.zawakeID)
	arg_6_0:onClose()
end

return var_0_2
