local var_0_0 = class("SelectCardView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "character_select_card.json"
var_0_0.RESOURCE_BINDING = {
	itemCard = "cardItem",
	["rightPanel.leftUpPanel.stancePanel2"] = "stancePanel2",
	["leftPanel.imgIcon"] = "imgIcon",
	["rightPanel.leftUpPanel.stancePanel3"] = "stancePanel3",
	["rightPanel.leftUpPanel.stancePanel1"] = "stancePanel1",
	["leftPanel.attr2"] = "attr2",
	itemSkill = "skillItem",
	["leftPanel.textName"] = {
		binds = {
			event = "text",
			data = bindHelper.self("card"),
			method = function(arg_1_0)
				return arg_1_0.name
			end
		}
	},
	["leftPanel.rarity"] = {
		binds = {
			event = "texture",
			data = bindHelper.self("card"),
			method = function(arg_2_0)
				local var_2_0 = csv.unit[arg_2_0.unitID]

				return ui.RARITY_ICON[var_2_0.rarity]
			end
		}
	},
	["leftPanel.attr1"] = {
		binds = {
			event = "texture",
			data = bindHelper.self("card"),
			method = function(arg_3_0)
				local var_3_0 = csv.unit[arg_3_0.unitID]

				return ui.ATTR_ICON[var_3_0.natureType]
			end
		}
	},
	["leftPanel.attrPanel.hp.textNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("hpNum")
		}
	},
	["leftPanel.attrPanel.attack.textNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("damageNum")
		}
	},
	["leftPanel.attrPanel.special.textNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("specialDamageNum")
		}
	},
	["leftPanel.attrPanel.phyFang.textNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("defenceNum")
		}
	},
	["leftPanel.attrPanel.speFang.textNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("specialDefenceNum")
		}
	},
	["leftPanel.attrPanel.speed.textNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("speedNum")
		}
	},
	["leftPanel.attrPanel.hp.progressBar"] = {
		binds = {
			event = "percent",
			idler = bindHelper.self("hpPercent")
		}
	},
	["leftPanel.attrPanel.attack.progressBar"] = {
		binds = {
			event = "percent",
			idler = bindHelper.self("damagePercent")
		}
	},
	["leftPanel.attrPanel.special.progressBar"] = {
		binds = {
			event = "percent",
			idler = bindHelper.self("specialDamagePercent")
		}
	},
	["leftPanel.attrPanel.phyFang.progressBar"] = {
		binds = {
			event = "percent",
			idler = bindHelper.self("defencePercent")
		}
	},
	["leftPanel.attrPanel.speFang.progressBar"] = {
		binds = {
			event = "percent",
			idler = bindHelper.self("specialDefencePercent")
		}
	},
	["leftPanel.attrPanel.speed.progressBar"] = {
		binds = {
			event = "percent",
			idler = bindHelper.self("speedPercent")
		}
	},
	["leftPanel.attrPanel.textSum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("allVal")
		}
	},
	["rightPanel.downPanel.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("cardData"),
				item = bindHelper.self("cardItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:multiget("next", "rarity", "name", "attr1", "attr2", "iconPanel")
					local var_4_1 = csv.unit[arg_4_3.unitID]

					var_4_0.next:visible(arg_4_2 ~= 1)
					var_4_0.rarity:texture(ui.RARITY_ICON[var_4_1.rarity])
					var_4_0.attr1:texture(ui.ATTR_ICON[var_4_1.natureType])

					if var_4_1.natureType2 then
						var_4_0.attr2:texture(ui.ATTR_ICON[var_4_1.natureType2])
					else
						var_4_0.attr2:hide()
					end

					var_4_0.name:text(arg_4_3.name)

					local var_4_2 = var_4_0.iconPanel:size()
					local var_4_3 = widget.addAnimation(var_4_0.iconPanel, var_4_1.unitRes, "standby_loop")

					var_4_3:xy(var_4_2.width / 2, var_4_2.height / 3):scale(2)
					var_4_3:setSkin(var_4_1.skin)
					adapt.oneLinePos(var_4_0.name, var_4_0.rarity, cc.p(25, 0), "right")
					adapt.oneLinePos(var_4_0.name, {
						var_4_0.attr1,
						var_4_0.attr2
					}, {
						cc.p(25, 0),
						cc.p(5, 0)
					}, "left")
				end
			}
		}
	},
	["rightPanel.rightUp.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("skillData"),
				item = bindHelper.self("skillItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					local var_5_0 = arg_5_1:multiget("icon", "iconTxt", "txt", "btn")

					uiEasy.setSkillInfoToItems({
						name = var_5_0.txt,
						icon = var_5_0.icon,
						type1 = var_5_0.iconTxt
					}, arg_5_3.skillId)
					var_5_0.btn:onClick(functools.partial(arg_5_0.clickCell, arg_5_2, arg_5_3))
				end
			},
			handlers = {
				clickCell = bindHelper.self("onClickSkill")
			}
		}
	},
	["rightPanel.leftUpPanel.txt"] = {
		binds = {
			event = "text",
			data = bindHelper.self("card"),
			method = function(arg_6_0)
				return arg_6_0.location
			end
		}
	},
	["leftPanel.btnChange"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["rightPanel.btnSure"] = {
		binds = {
			clicksafe = true,
			event = "touch",
			methods = {
				ended = bindHelper.self("onSure")
			}
		}
	}
}
var_0_0.RESOURCE_STYLES = {
	full = true
}

function var_0_0.onCreate(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0.cb = arg_7_2
	arg_7_0.id = csv.newbie_init[1].cards[arg_7_1].id

	local var_7_0 = csv.cards[arg_7_0.id]
	local var_7_1 = {
		"hp",
		"speed",
		"damage",
		"defence",
		"specialDamage",
		"specialDefence"
	}
	local var_7_2 = {}

	for iter_7_0 = 1, 6 do
		var_7_2[var_7_1[iter_7_0]] = var_7_0.specValue[iter_7_0]
	end

	arg_7_0.skillData = {}

	for iter_7_1, iter_7_2 in csvPairs(var_7_0.skillList) do
		table.insert(arg_7_0.skillData, {
			skillLevel = 1,
			skillId = iter_7_2
		})
		table.sort(arg_7_0.skillData, function(arg_8_0, arg_8_1)
			return arg_8_0.skillId < arg_8_1.skillId
		end)
	end

	arg_7_0.card = var_7_0

	local var_7_3 = csv.unit[var_7_0.unitID]

	for iter_7_3, iter_7_4 in pairs(var_7_2) do
		arg_7_0[iter_7_3 .. "Num"] = idler.new(iter_7_4)
		arg_7_0[iter_7_3 .. "Percent"] = idler.new(iter_7_4 / 255 * 100)
	end

	if var_7_3.natureType2 then
		arg_7_0.attr2:texture(ui.ATTR_ICON[var_7_3.natureType2])
	else
		arg_7_0.attr2:hide()
	end

	local var_7_4 = var_7_0.specValue

	for iter_7_5, iter_7_6 in ipairs(var_7_4) do
		if iter_7_5 > 6 then
			arg_7_0.allVal = idler.new(iter_7_6)

			break
		end
	end

	arg_7_0.imgIcon:texture(var_7_3.cardShow):visible(true)

	arg_7_0.cardData = {}

	for iter_7_7, iter_7_8 in orderCsvPairs(csv.cards) do
		if iter_7_8.cardMarkID == var_7_0.cardMarkID and iter_7_8.develop < 4 then
			arg_7_0.cardData[iter_7_8.develop] = iter_7_8
		end
	end

	arg_7_0.stancePanel1:visible(arg_7_1 == 1)
	arg_7_0.stancePanel2:visible(arg_7_1 == 2)
	arg_7_0.stancePanel3:visible(arg_7_1 == 3)
end

function var_0_0.onSure(arg_9_0)
	gGameApp:requestServer("/game/role/newbie/card/choose", function()
		gGameUI:stackUI("new_character.gain_sprite", nil, nil, arg_9_0.id, arg_9_0.cb)
	end, 2, arg_9_0.id)
end

function var_0_0.onClickSkill(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = gGameUI:stackUI("common.skill_detail", nil, {
		clickClose = true,
		dispatchNodes = arg_11_1
	}, {
		skillId = arg_11_3.skillId,
		skillLevel = arg_11_3.skillLevel,
		cardId = arg_11_0.id
	}):getResourceNode()
	local var_11_1, var_11_2 = var_11_0:xy()

	var_11_0:xy(var_11_1 + 1140, var_11_2 + 200)
end

return var_0_0
