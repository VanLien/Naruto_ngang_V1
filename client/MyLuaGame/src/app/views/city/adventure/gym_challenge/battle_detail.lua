local var_0_0 = class("GymBattleDetail", Dialog)

local function var_0_1(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	if not arg_1_3.card_id then
		arg_1_1:get("emptyPanel"):show()

		return
	end

	arg_1_1:get("emptyPanel"):hide()

	local var_1_0 = dataEasy.getUnitId(arg_1_3.card_id, arg_1_3.skin_id)

	bind.extend(arg_1_0, arg_1_1, {
		class = "card_icon",
		props = {
			unitId = var_1_0,
			advance = arg_1_3.advance,
			rarity = arg_1_3.rarity,
			star = arg_1_3.star,
			levelProps = {
				data = arg_1_3.level
			},
			onNode = function(arg_2_0)
				arg_2_0:xy(0, -6):scale(0.8)
			end
		}
	})
end

var_0_0.RESOURCE_FILENAME = "gym_battle_detail.json"
var_0_0.RESOURCE_BINDING = {
	item = "item",
	left = "left",
	["imgBG.img"] = "img",
	right = "right",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["left.textLv"] = {
		varname = "textLvL",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["left.textNote3"] = {
		varname = "textNote3L",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["right.textLv"] = {
		varname = "textLvR",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["right.textNote3"] = {
		varname = "textNote3R",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["left.list1"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 3,
				data = bindHelper.self("team1"),
				item = bindHelper.self("item"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					var_0_1(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				end
			}
		}
	},
	["left.list2"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 3,
				data = bindHelper.self("team2"),
				item = bindHelper.self("item"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					var_0_1(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				end
			}
		}
	},
	["right.list1"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 3,
				data = bindHelper.self("team3"),
				item = bindHelper.self("item"),
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					var_0_1(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				end
			}
		}
	},
	["right.list2"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 3,
				data = bindHelper.self("team4"),
				item = bindHelper.self("item"),
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					var_0_1(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				end
			}
		}
	},
	["imgBG.btnReplay"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onReplay")
			}
		}
	},
	["imgBG.btnReplay.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["left.head"] = {
		binds = {
			event = "extend",
			class = "role_logo",
			props = {
				vip = false,
				level = false,
				logoId = bindHelper.self("logoId1"),
				frameId = bindHelper.self("frameId1"),
				onNode = function(arg_7_0)
					arg_7_0:scale(1.2)
				end
			}
		}
	},
	["right.head"] = {
		binds = {
			event = "extend",
			class = "role_logo",
			props = {
				vip = false,
				level = false,
				logoId = bindHelper.self("logoId2"),
				frameId = bindHelper.self("frameId2"),
				onNode = function(arg_8_0)
					arg_8_0:scale(1.2)
				end
			}
		}
	},
	["left.textName"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("name1")
		}
	},
	["right.textName"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("name2")
		}
	}
}

function var_0_0.onCreate(arg_9_0, arg_9_1)
	Dialog.onCreate(arg_9_0)
	arg_9_0:initRole(arg_9_1)
	arg_9_0:initCardData(arg_9_1)

	arg_9_0.recordID = arg_9_1.play_record_id
	arg_9_0.crossKey = arg_9_1.cross_key
end

function var_0_0.initRole(arg_10_0, arg_10_1)
	arg_10_0.logoId1 = idler.new(arg_10_1.logo)
	arg_10_0.logoId2 = idler.new(arg_10_1.defence_logo)
	arg_10_0.frameId1 = idler.new(arg_10_1.frame)
	arg_10_0.frameId2 = idler.new(arg_10_1.defence_frame)
	arg_10_0.name1 = idler.new(arg_10_1.name)
	arg_10_0.name2 = idler.new(arg_10_1.defence_name)

	arg_10_0.left:get("textLv"):text(arg_10_1.level)
	adapt.oneLineCenterPos(cc.p(250, 543), {
		arg_10_0.left:get("textNote3"),
		arg_10_0.left:get("textLv")
	}, cc.p(2, 3))
	arg_10_0.right:get("textLv"):text(arg_10_1.defence_level)
	adapt.oneLineCenterPos(cc.p(250, 543), {
		arg_10_0.right:get("textNote3"),
		arg_10_0.right:get("textLv")
	}, cc.p(2, 3))

	if arg_10_1.role_key ~= "" then
		arg_10_0.left:get("textService"):text(getServerArea(arg_10_1.role_key))
	else
		arg_10_0.left:get("textService"):hide()
	end

	if arg_10_1.defence_role_key ~= "" then
		arg_10_0.right:get("textService"):text(getServerArea(arg_10_1.defence_role_key))
	else
		arg_10_0.right:get("textService"):hide()
	end

	local var_10_0 = gGameModel.role:read("id")

	if var_10_0 == arg_10_1.role_id and arg_10_1.result == "win" or var_10_0 ~= arg_10_1.role_id and arg_10_1.result ~= "win" then
		arg_10_0.left:get("head.imgResult"):texture("city/pvp/craft/icon_win.png")
		arg_10_0.right:get("head.imgResult"):texture("city/pvp/craft/icon_lose.png")
		arg_10_0.img:texture("city/adventure/gym_challenge/bg_1.png")
	else
		arg_10_0.right:get("head.imgResult"):texture("city/pvp/craft/icon_win.png")
		arg_10_0.left:get("head.imgResult"):texture("city/pvp/craft/icon_lose.png")
		arg_10_0.img:texture("city/adventure/gym_challenge/bg_2.png")
	end

	if matchLanguage({
		"en"
	}) then
		adapt.setAutoText(arg_10_0.left:get("textNote1"), nil, 120)
		adapt.setAutoText(arg_10_0.left:get("textNote2"), nil, 120)
		adapt.setAutoText(arg_10_0.right:get("textNote1"), nil, 120)
		adapt.setAutoText(arg_10_0.right:get("textNote2"), nil, 120)
	end
end

function var_0_0.initCardData(arg_11_0, arg_11_1)
	arg_11_0.team1 = {}
	arg_11_0.team2 = {}
	arg_11_0.team3 = {}
	arg_11_0.team4 = {}

	local var_11_0 = csv.unit
	local var_11_1 = csv.cards

	for iter_11_0 = 1, 6 do
		if iter_11_0 <= 3 then
			local var_11_2 = arg_11_1.cards[iter_11_0]

			if var_11_2 then
				local var_11_3 = table.shallowcopy(arg_11_1.card_attrs[var_11_2])

				arg_11_0.team1[iter_11_0] = var_11_3

				local var_11_4 = var_11_1[var_11_3.card_id].unitID

				arg_11_0.team1[iter_11_0].rarity = var_11_0[var_11_4].rarity
			else
				arg_11_0.team1[iter_11_0] = {}
			end

			local var_11_5 = arg_11_1.defence_cards[iter_11_0]

			if var_11_5 then
				local var_11_6 = table.shallowcopy(arg_11_1.defence_card_attrs[var_11_5])

				arg_11_0.team3[iter_11_0] = var_11_6

				local var_11_7 = var_11_1[var_11_6.card_id].unitID

				arg_11_0.team3[iter_11_0].rarity = var_11_0[var_11_7].rarity
			else
				arg_11_0.team3[iter_11_0] = {}
			end
		else
			local var_11_8 = arg_11_1.cards[iter_11_0]

			if var_11_8 then
				local var_11_9 = table.shallowcopy(arg_11_1.card_attrs[var_11_8])

				arg_11_0.team2[iter_11_0 - 3] = var_11_9

				local var_11_10 = var_11_1[var_11_9.card_id].unitID

				arg_11_0.team2[iter_11_0 - 3].rarity = var_11_0[var_11_10].rarity
			else
				arg_11_0.team2[iter_11_0 - 3] = {}
			end

			local var_11_11 = arg_11_1.defence_cards[iter_11_0]

			if var_11_11 then
				local var_11_12 = table.shallowcopy(arg_11_1.defence_card_attrs[var_11_11])

				arg_11_0.team4[iter_11_0 - 3] = var_11_12

				local var_11_13 = var_11_1[var_11_12.card_id].unitID

				arg_11_0.team4[iter_11_0 - 3].rarity = var_11_0[var_11_13].rarity
			else
				arg_11_0.team4[iter_11_0 - 3] = {}
			end
		end
	end

	local var_11_14 = 0

	for iter_11_1 = 1, 3 do
		print("---", arg_11_0.team1[iter_11_1].fighting_point, arg_11_0.team1[iter_11_1].fighting_point or 0)

		var_11_14 = var_11_14 + (arg_11_0.team1[iter_11_1].fighting_point or 0)
		var_11_14 = var_11_14 + (arg_11_0.team2[iter_11_1].fighting_point or 0)
	end

	local var_11_15 = 0

	for iter_11_2 = 1, 3 do
		var_11_15 = var_11_15 + (arg_11_0.team3[iter_11_2].fighting_point or 0)
		var_11_15 = var_11_15 + (arg_11_0.team4[iter_11_2].fighting_point or 0)
	end

	arg_11_0.left:get("imgBg.textZl"):text(var_11_14)
	arg_11_0.right:get("imgBg.textZl"):text(var_11_15)

	local var_11_16 = {}
	local var_11_17 = {}

	for iter_11_3 = 1, 3 do
		local var_11_18 = arg_11_0.team1[iter_11_3]

		if var_11_18.card_id then
			local var_11_19 = csv.cards[var_11_18.card_id]
			local var_11_20 = csv.unit[var_11_19.unitID]

			if var_11_18.nature_choose == 1 then
				var_11_16[iter_11_3] = var_11_20.natureType
			else
				var_11_16[iter_11_3] = var_11_20.natureType2
			end
		end

		local var_11_21 = arg_11_0.team2[iter_11_3]

		if var_11_21.card_id then
			local var_11_22 = csv.cards[var_11_21.card_id]
			local var_11_23 = csv.unit[var_11_22.unitID]

			if var_11_21.nature_choose == 1 then
				var_11_16[iter_11_3 + 3] = var_11_23.natureType
			else
				var_11_16[iter_11_3 + 3] = var_11_23.natureType2
			end
		end

		local var_11_24 = arg_11_0.team3[iter_11_3]

		if var_11_24.card_id then
			local var_11_25 = csv.cards[var_11_24.card_id]
			local var_11_26 = csv.unit[var_11_25.unitID]

			if var_11_24.nature_choose == 1 then
				var_11_17[iter_11_3] = var_11_26.natureType
			else
				var_11_17[iter_11_3] = var_11_26.natureType2
			end
		end

		local var_11_27 = arg_11_0.team4[iter_11_3]

		if var_11_27.card_id then
			local var_11_28 = csv.cards[var_11_27.card_id]
			local var_11_29 = csv.unit[var_11_28.unitID]

			if var_11_27.nature_choose == 1 then
				var_11_17[iter_11_3 + 3] = var_11_29.natureType
			else
				var_11_17[iter_11_3 + 3] = var_11_29.natureType2
			end
		end
	end

	arg_11_0.left:get("imgBg.imgBuf"):texture(dataEasy.getTeamBuff(var_11_16).imgPath)
	arg_11_0.right:get("imgBg.imgBuf"):texture(dataEasy.getTeamBuff(var_11_17).imgPath)
end

function var_0_0.onReplay(arg_12_0)
	local var_12_0 = "/game/gym/playrecord/get"

	gGameModel:playRecordBattle(arg_12_0.recordID, arg_12_0.crossKey, var_12_0, 0, nil)
end

return var_0_0
