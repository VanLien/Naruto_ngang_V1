local var_0_0 = class("CrossArenaPersonalRecordInfoView", cc.load("mvc").ViewBase)

local function var_0_1(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	if not arg_1_3.isInfo then
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

var_0_0.RESOURCE_FILENAME = "cross_arena_record_info.json"
var_0_0.RESOURCE_BINDING = {
	["baseNode.head1"] = "head1",
	["baseNode.down1"] = "down1",
	["baseNode.down4"] = "down4",
	["baseNode.head.textName"] = "textName",
	["baseNode.head1.textName"] = "textName1",
	["baseNode.down2"] = "down2",
	item = "item",
	["baseNode.head.img"] = "img",
	["baseNode.down3"] = "down3",
	["baseNode.head"] = "head",
	["baseNode.head1.img"] = "img1",
	["baseNode.head.head"] = {
		binds = {
			event = "extend",
			class = "role_logo",
			props = {
				vip = false,
				level = false,
				logoId = bindHelper.self("logoId"),
				frameId = bindHelper.self("frameId"),
				onNode = function(arg_3_0)
					arg_3_0:scale(1)
				end
			}
		}
	},
	["baseNode.head1.head"] = {
		binds = {
			event = "extend",
			class = "role_logo",
			props = {
				vip = false,
				level = false,
				logoId = bindHelper.self("logoId1"),
				frameId = bindHelper.self("frameId1"),
				onNode = function(arg_4_0)
					arg_4_0:scale(1)
				end
			}
		}
	},
	["baseNode.head.textLv"] = {
		varname = "textLv"
	},
	["baseNode.head1.textLv"] = {
		varname = "textLv1"
	},
	["baseNode.down1.list1"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 3,
				data = bindHelper.self("team1"),
				item = bindHelper.self("item"),
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					var_0_1(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				end
			}
		}
	},
	["baseNode.down1.list2"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 3,
				data = bindHelper.self("team2"),
				item = bindHelper.self("item"),
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					var_0_1(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				end
			}
		}
	},
	["baseNode.down2.list1"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 3,
				data = bindHelper.self("team3"),
				item = bindHelper.self("item"),
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					var_0_1(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				end
			}
		}
	},
	["baseNode.down2.list2"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 3,
				data = bindHelper.self("team4"),
				item = bindHelper.self("item"),
				onItem = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					var_0_1(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				end
			}
		}
	},
	["baseNode.down3.list1"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 3,
				data = bindHelper.self("team5"),
				item = bindHelper.self("item"),
				onItem = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
					var_0_1(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				end
			}
		}
	},
	["baseNode.down3.list2"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 3,
				data = bindHelper.self("team6"),
				item = bindHelper.self("item"),
				onItem = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
					var_0_1(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				end
			}
		}
	},
	["baseNode.down4.list1"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 3,
				data = bindHelper.self("team7"),
				item = bindHelper.self("item"),
				onItem = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
					var_0_1(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				end
			}
		}
	},
	["baseNode.down4.list2"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 3,
				data = bindHelper.self("team8"),
				item = bindHelper.self("item"),
				onItem = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
					var_0_1(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_13_0, arg_13_1)
	arg_13_0.fightPoint = idler.new(0)
	arg_13_0.logoId = idler.new(arg_13_1.logo)
	arg_13_0.logoId1 = idler.new(arg_13_1.defence_logo)
	arg_13_0.frameId = idler.new(arg_13_1.frame)
	arg_13_0.frameId1 = idler.new(arg_13_1.defence_frame)
	arg_13_0.personalInfo = arg_13_1
	arg_13_0.team1 = {}
	arg_13_0.team2 = {}
	arg_13_0.team3 = {}
	arg_13_0.team4 = {}
	arg_13_0.team5 = {}
	arg_13_0.team6 = {}
	arg_13_0.team7 = {}
	arg_13_0.team8 = {}

	if arg_13_1.result == "win" then
		arg_13_0.img:texture("city/pvp/craft/icon_win.png")
		arg_13_0.img1:texture("city/pvp/craft/icon_lose.png")
	else
		arg_13_0.img:texture("city/pvp/craft/icon_lose.png")
		arg_13_0.img1:texture("city/pvp/craft/icon_win.png")
	end

	arg_13_0.textLv:text(arg_13_1.level)
	arg_13_0.textLv1:text(arg_13_1.defence_level)
	arg_13_0.textName:text(arg_13_1.name)
	arg_13_0.textName1:text(arg_13_1.defence_name)

	local var_13_0 = {
		{
			{},
			{}
		},
		{
			{},
			{}
		},
		{
			{},
			{}
		},
		{
			{},
			{}
		}
	}
	local var_13_1 = 0
	local var_13_2 = 0
	local var_13_3 = 0
	local var_13_4 = 0
	local var_13_5 = {
		{},
		{}
	}
	local var_13_6 = {
		{},
		{}
	}
	local var_13_7 = csv.cards
	local var_13_8 = csv.unit

	for iter_13_0 = 1, 2 do
		for iter_13_1 = 1, 6 do
			local var_13_9 = arg_13_1.cards[iter_13_0][iter_13_1]

			if var_13_9 then
				local var_13_10 = arg_13_1.card_attrs[var_13_9]
				local var_13_11 = csv.cards[var_13_10.card_id]
				local var_13_12 = csv.unit[var_13_11.unitID]

				if var_13_10.nature_choose == 1 then
					var_13_5[iter_13_0][iter_13_1] = var_13_12.natureType
				else
					var_13_5[iter_13_0][iter_13_1] = var_13_12.natureType2
				end

				if var_13_7[var_13_10.card_id] then
					var_13_10.rarity = var_13_8[var_13_7[var_13_10.card_id].unitID].rarity
					var_13_10.isInfo = true

					if iter_13_1 <= 3 then
						var_13_0[iter_13_0][1][iter_13_1] = var_13_10
					else
						var_13_0[iter_13_0][2][iter_13_1 - 3] = var_13_10
					end

					if iter_13_0 == 1 then
						var_13_1 = var_13_1 + var_13_10.fighting_point
					else
						var_13_2 = var_13_2 + var_13_10.fighting_point
					end
				end
			elseif iter_13_1 <= 3 then
				var_13_0[iter_13_0][1][iter_13_1] = {
					isInfo = false
				}
			else
				var_13_0[iter_13_0][2][iter_13_1 - 3] = {
					isInfo = false
				}
			end
		end
	end

	for iter_13_2 = 1, 2 do
		for iter_13_3 = 1, 6 do
			local var_13_13 = arg_13_1.defence_cards[iter_13_2][iter_13_3]

			if var_13_13 then
				local var_13_14 = arg_13_1.defence_card_attrs[var_13_13]
				local var_13_15 = csv.cards[var_13_14.card_id]
				local var_13_16 = csv.unit[var_13_15.unitID]

				if var_13_14.nature_choose == 1 then
					var_13_6[iter_13_2][iter_13_3] = var_13_16.natureType
				else
					var_13_6[iter_13_2][iter_13_3] = var_13_16.natureType2
				end

				if var_13_7[var_13_14.card_id] then
					var_13_14.rarity = var_13_8[var_13_7[var_13_14.card_id].unitID].rarity
					var_13_14.isInfo = true

					if iter_13_3 <= 3 then
						var_13_0[iter_13_2 + 2][1][iter_13_3] = var_13_14
					else
						var_13_0[iter_13_2 + 2][2][iter_13_3 - 3] = var_13_14
					end

					if iter_13_2 == 1 then
						var_13_3 = var_13_3 + var_13_14.fighting_point
					else
						var_13_4 = var_13_4 + var_13_14.fighting_point
					end
				end
			elseif iter_13_3 <= 3 then
				var_13_0[iter_13_2 + 2][1][iter_13_3] = {
					isInfo = false
				}
			else
				var_13_0[iter_13_2 + 2][2][iter_13_3 - 3] = {
					isInfo = false
				}
			end
		end
	end

	arg_13_0.down1:get("textZl"):text(var_13_1)
	arg_13_0.down2:get("textZl"):text(var_13_2)
	arg_13_0.down3:get("textZl"):text(var_13_3)
	arg_13_0.down4:get("textZl"):text(var_13_4)
	arg_13_0.down1:get("imgBuf"):texture(dataEasy.getTeamBuff(var_13_5[1]).imgPath)
	arg_13_0.down2:get("imgBuf"):texture(dataEasy.getTeamBuff(var_13_5[2]).imgPath)
	arg_13_0.down3:get("imgBuf"):texture(dataEasy.getTeamBuff(var_13_6[1]).imgPath)
	arg_13_0.down4:get("imgBuf"):texture(dataEasy.getTeamBuff(var_13_6[2]).imgPath)

	arg_13_0.team1 = var_13_0[1][2]
	arg_13_0.team2 = var_13_0[1][1]
	arg_13_0.team3 = var_13_0[2][2]
	arg_13_0.team4 = var_13_0[2][1]
	arg_13_0.team5 = var_13_0[3][2]
	arg_13_0.team6 = var_13_0[3][1]
	arg_13_0.team7 = var_13_0[4][2]
	arg_13_0.team8 = var_13_0[4][1]
end

return var_0_0
