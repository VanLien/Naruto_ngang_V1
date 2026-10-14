local var_0_0 = class("CardDetailView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "common_card_detail.json"
var_0_0.RESOURCE_BINDING = {
	["baseCardNode.skillIcon"] = "skillIcon",
	["baseCardNode.raceNote"] = "raceNote",
	["baseCardNode.raceNum"] = "raceNum",
	["baseCardNode.skillDescribeList"] = "skillDescribeList",
	["baseCardNode.skillAttr"] = "skillAttr",
	["baseCardNode.attr1"] = "attr1",
	["baseCardNode.cardName"] = "cardName",
	["baseCardNode.attr2"] = "attr2",
	["baseCardNode.attrItem"] = "attrItem",
	baseCardNode = "baseCardNode",
	["baseCardNode.skillName"] = "skillName",
	["baseCardNode.cardIcon"] = {
		binds = {
			event = "extend",
			class = "card_icon",
			props = {
				cardId = bindHelper.self("cardId"),
				star = bindHelper.self("star"),
				rarity = bindHelper.self("rarity"),
				onNode = function(arg_1_0)
					local var_1_0 = arg_1_0:size()

					arg_1_0:alignCenter(var_1_0)
				end
			}
		}
	},
	["baseCardNode.list"] = {
		varname = "attrList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				data = bindHelper.self("attrDatas"),
				item = bindHelper.self("attrItem"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("icon", "note", "num", "bar")

					var_2_0.note:text(arg_2_3.note)
					var_2_0.num:text(arg_2_3.num)
					var_2_0.icon:texture(arg_2_3.icon)

					local var_2_1 = arg_2_3.num * 100 / game.RACE_ATTR_LIMIT

					var_2_0.bar:setPercent(var_2_1)
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_1.num

	arg_3_0:getResourceNode():setTouchEnabled(false)

	arg_3_0.attrDatas = idlertable.new({})

	local var_3_1, var_3_2 = dataEasy.getCardIdAndStar(var_3_0)
	local var_3_3 = csv.cards[var_3_1]
	local var_3_4 = csv.unit[var_3_3.unitID]
	local var_3_5 = csv.skill[var_3_3.innateSkillID]

	arg_3_0.cardId = idler.new(var_3_1)
	arg_3_0.star = idler.new(var_3_2)
	arg_3_0.rarity = idler.new(var_3_4.rarity)

	beauty.textScroll({
		isRich = true,
		fontSize = 40,
		list = arg_3_0.skillDescribeList,
		strs = "#C0xFFFFFF#" .. var_3_5.simDesc
	})
	arg_3_0.cardName:text(var_3_3.name)
	arg_3_0.attr1:texture(ui.ATTR_ICON[var_3_4.natureType])

	if var_3_4.natureType2 then
		arg_3_0.attr2:texture(ui.ATTR_ICON[var_3_4.natureType2]):show()
	else
		arg_3_0.attr2:hide()
	end

	arg_3_0.skillName:text(var_3_5.skillName)

	local var_3_6 = arg_3_0.skillName:size().width

	if not var_3_5.skillNatureType then
		arg_3_0.skillAttr:hide()
		arg_3_0.skillIcon:hide()
	else
		arg_3_0.skillAttr:texture(ui.SKILL_TEXT_ICON[var_3_5.skillNatureType]):show()
		arg_3_0.skillIcon:texture(ui.SKILL_ICON[var_3_5.skillNatureType]):show()
	end

	arg_3_0.raceNum:text(var_3_3.specValue[csvSize(var_3_3.specValue)])

	local var_3_7 = {}
	local var_3_8 = {
		{
			"hp",
			"sm"
		},
		{
			"speed",
			"sd"
		},
		{
			"damage",
			"wg"
		},
		{
			"defence",
			"wf"
		},
		{
			"specialDamage",
			"tg"
		},
		{
			"specialDefence",
			"tf"
		}
	}

	for iter_3_0, iter_3_1 in ipairs(var_3_8) do
		var_3_7[iter_3_0] = {
			note = getLanguageAttr(iter_3_1[1]),
			num = var_3_3.specValue[iter_3_0],
			icon = ui.ATTR_LOGO[iter_3_1[1]],
			barImg = "card_info/bar_" .. iter_3_1[2] .. ".png"
		}
	end

	arg_3_0.attrDatas:set(var_3_7)
end

function var_0_0.hitTestPanel(arg_4_0, arg_4_1)
	if arg_4_0.skillDescribeList:isTouchEnabled() then
		local var_4_0 = arg_4_0.baseCardNode
		local var_4_1 = var_4_0:box()
		local var_4_2 = var_4_0:parent():convertToWorldSpace(cc.p(var_4_1.x, var_4_1.y))

		var_4_1.x = var_4_2.x
		var_4_1.y = var_4_2.y

		return cc.rectContainsPoint(var_4_1, arg_4_1)
	end

	return false
end

return var_0_0
