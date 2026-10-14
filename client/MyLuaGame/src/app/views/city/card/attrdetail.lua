local var_0_0 = class("CardAttrDetailView", Dialog)

var_0_0.RESOURCE_FILENAME = "card_attrdetail.json"
var_0_0.RESOURCE_BINDING = {
	["list.centerPanel.attrPanel.item"] = "attrItem",
	["list.centerPanel.attrPanel.subList"] = "attrSubList",
	cardName = "cardNameTxt",
	["list.centerPanel.attrPanel1.item"] = "attrItem1",
	["bottomPanel.textList"] = "textList",
	["list.centerPanel.attrPanel1.innerList"] = "innerList",
	["cardPanel.cardIcon"] = "cardIcon",
	list = "bottomList",
	bottomPanel = "bottomPanel",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	titleTxt1 = {
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
	titleTxt2 = {
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
	["list.centerPanel.attrPanel.list"] = {
		varname = "attrList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 6,
				columnSize = 2,
				data = bindHelper.self("attrDatas"),
				item = bindHelper.self("attrSubList"),
				cell = bindHelper.self("attrItem"),
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("txt1"):setString(arg_1_3.txt1 .. ":")
					arg_1_1:get("txt2"):setString(arg_1_3.txt2)
					arg_1_1:get("icon"):loadTexture(arg_1_3.icon)
					adapt.oneLinePos(arg_1_1:get("txt1"), arg_1_1:get("txt2"), cc.p(20, 0), "left")
				end
			}
		}
	},
	["list.centerPanel.attrPanel1.list"] = {
		varname = "attrList1",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 2,
				data = bindHelper.self("damageData"),
				item = bindHelper.self("innerList"),
				cell = bindHelper.self("attrItem1"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					arg_2_1:get("txt1"):setString(arg_2_3.txt .. ":")

					local var_2_0 = mathEasy.getPreciseDecimal(arg_2_3.num, 2)

					arg_2_1:get("txt2"):setString(dataEasy.getBuffShow(var_2_0))
					adapt.oneLinePos(arg_2_1:get("txt1"), arg_2_1:get("txt2"), cc.p(0, 0), "left")
				end
			}
		}
	},
	["list.centerPanel.attrdetailBtn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onEnterProperty")
			}
		}
	}
}

function var_0_0.onEnterProperty(arg_3_0)
	gGameUI:stackUI("city.card.detailed_attribute", nil, nil)
end

function var_0_0.onCreate(arg_4_0, arg_4_1)
	arg_4_0.selectDbId = arg_4_1

	arg_4_0:initModel()
	arg_4_0.bottomList:setScrollBarEnabled(false)
	arg_4_0.attrSubList:setScrollBarEnabled(false)
	arg_4_0.innerList:setScrollBarEnabled(false)

	arg_4_0.attrDatas = {}

	for iter_4_0, iter_4_1 in ipairs(game.ATTRDEF_SIMPLE_TABLE) do
		local var_4_0 = {
			txt2 = 0,
			txt1 = getLanguageAttr(iter_4_1),
			icon = ui.ATTR_LOGO[iter_4_1]
		}

		table.insert(arg_4_0.attrDatas, var_4_0)
	end

	arg_4_0.attrDatas = idlertable.new(arg_4_0.attrDatas)

	local var_4_1 = {
		"strike",
		"damageAdd",
		"strikeDamage",
		"damageSub",
		"strikeResistance",
		"ultimateAdd",
		"block",
		"ultimateSub",
		"breakBlock",
		"cure",
		"blockPower",
		"pvpDamageAdd",
		"controlPer",
		"pvpDamageSub",
		"immuneControl",
		"physicalDamageAdd",
		"defenceIgnore",
		"physicalDamageSub",
		"specialDefenceIgnore",
		"specialDamageAdd",
		"suckBlood",
		"specialDamageSub",
		"rebound"
	}

	arg_4_0.damageData = {}

	for iter_4_2, iter_4_3 in ipairs(var_4_1) do
		arg_4_0.damageData[iter_4_2] = {
			num = "",
			txt = getLanguageAttr(iter_4_3)
		}
	end

	arg_4_0.damageData = idlertable.new(arg_4_0.damageData)

	idlereasy.any({
		arg_4_0.attrs,
		arg_4_0.attrs2
	}, function(arg_5_0, arg_5_1, arg_5_2)
		arg_4_0.attrDatas:modify(function(arg_6_0)
			for iter_6_0, iter_6_1 in ipairs(game.ATTRDEF_SIMPLE_TABLE) do
				arg_6_0[iter_6_0].txt2 = math.floor(arg_5_1[iter_6_1])
			end
		end, true)
		arg_4_0.damageData:modify(function(arg_7_0)
			for iter_7_0, iter_7_1 in ipairs(var_4_1) do
				if arg_5_1[iter_7_1] ~= nil then
					arg_7_0[iter_7_0].num = math.floor(arg_5_1[iter_7_1])
				elseif arg_5_2[iter_7_1] ~= nil then
					arg_7_0[iter_7_0].num = math.floor(arg_5_2[iter_7_1])
				else
					arg_7_0[iter_7_0].num = 0
				end
			end
		end, true)
	end)

	local var_4_2 = arg_4_0.cardId:read()
	local var_4_3 = csv.cards[var_4_2].introduction

	beauty.textScroll({
		isRich = false,
		align = "left",
		list = arg_4_0.textList,
		strs = var_4_3,
		effect = {
			color = ui.NEWCOLORS.BROWN1
		}
	})

	local var_4_4 = dataEasy.getUnitCsv(arg_4_0.cardId:read(), arg_4_0.skinId:read())
	local var_4_5 = arg_4_0.cardIcon:getContentSize()

	cc.Sprite:create(var_4_4.cardShow):alignCenter(var_4_5):addTo(arg_4_0.cardIcon, 5, "icon"):scale(0.8)

	local var_4_6 = csv.cards[arg_4_0.cardId:read()].name

	arg_4_0.cardNameTxt:text(var_4_6)
	Dialog.onCreate(arg_4_0)
end

function var_0_0.initModel(arg_8_0)
	local var_8_0 = gGameModel.cards:find(arg_8_0.selectDbId)

	arg_8_0.cardName = var_8_0:getIdler("name")
	arg_8_0.cardId = var_8_0:getIdler("card_id")
	arg_8_0.advance = var_8_0:getIdler("advance")
	arg_8_0.unitId = var_8_0:getIdler("unit_id")
	arg_8_0.skinId = var_8_0:getIdler("skin_id")
	arg_8_0.attrs = var_8_0:getIdler("attrs")
	arg_8_0.attrs2 = var_8_0:getIdler("attrs2")
end

return var_0_0
