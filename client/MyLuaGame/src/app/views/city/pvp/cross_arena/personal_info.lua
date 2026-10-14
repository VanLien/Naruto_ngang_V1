local var_0_0 = class("CrossArenaPersonalInfoView", cc.load("mvc").ViewBase)

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

var_0_0.RESOURCE_FILENAME = "cross_arena_personal_info.json"
var_0_0.RESOURCE_BINDING = {
	["baseNode.top.imgVip"] = "imgVip",
	["baseNode.top.textRankNote"] = "textRankNote",
	["baseNode.top.textName"] = "textName",
	["baseNode.top.textStage"] = "textStage",
	["baseNode.down2"] = "down2",
	item = "item",
	["baseNode.down1"] = "down1",
	["baseNode.top.textServer"] = "textServer",
	["baseNode.top.head"] = {
		binds = {
			event = "extend",
			class = "role_logo",
			props = {
				vip = false,
				level = false,
				logoId = bindHelper.self("logoId"),
				frameId = bindHelper.self("frameId"),
				onNode = function(arg_3_0)
					arg_3_0:scale(0.85)
				end
			}
		}
	},
	["baseNode.top.stage"] = {
		varname = "stage",
		binds = {
			event = "extend",
			class = "stage_icon",
			props = {
				showStage = false,
				showStageBg = false,
				rank = bindHelper.self("rank"),
				onNode = function(arg_4_0)
					arg_4_0:y(40):scale(1)
				end
			}
		}
	},
	["baseNode.top.textRank"] = {
		varname = "textRank"
	},
	["baseNode.top.head.textLv"] = {
		varname = "textLv"
	},
	["baseNode.top.head.textNoteLv"] = {
		varname = "textNoteLv"
	},
	["baseNode.down1.list1"] = {
		varname = "list",
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
		varname = "list",
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
		varname = "list",
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
		varname = "list",
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
	}
}

function var_0_0.onCreate(arg_9_0, arg_9_1)
	arg_9_0.roleId = arg_9_1.role_db_id
	arg_9_0.rank = idler.new(arg_9_1.rank)
	arg_9_0.fightPoint = idler.new(0)
	arg_9_0.logoId = idler.new(arg_9_1.role_logo)
	arg_9_0.frameId = idler.new(arg_9_1.role_frame)
	arg_9_0.personalInfo = arg_9_1
	arg_9_0.team1 = {}
	arg_9_0.team2 = {}
	arg_9_0.team3 = {}
	arg_9_0.team4 = {}

	arg_9_0.textName:text(arg_9_1.role_name)
	arg_9_0.imgVip:visible(arg_9_1.role_vip > 0)

	if arg_9_1.role_vip > 0 then
		arg_9_0.imgVip:texture(string.format("common/icon/vip/icon_vip%d.png", arg_9_1.role_vip))
	end

	arg_9_0.textLv:text(arg_9_1.role_level)
	adapt.oneLineCenterPos(cc.p(100, 20), {
		arg_9_0.textNoteLv,
		arg_9_0.textLv
	}, cc.p(0, 0))
	arg_9_0.textRank:text(dataEasy.getCrossArenaStageByRank(arg_9_1.rank).rank)
	arg_9_0.textStage:text(dataEasy.getCrossArenaStageByRank(arg_9_1.rank).stageName)
	arg_9_0.textServer:text(string.format(gLanguageCsv.brackets, getServerArea(arg_9_1.game_key, true)))
	adapt.oneLinePos(arg_9_0.textName, {
		arg_9_0.textServer,
		arg_9_0.imgVip
	}, {
		cc.p(10, 0),
		cc.p(5, 0)
	})

	local var_9_0 = {
		{
			{},
			{}
		},
		{
			{},
			{}
		}
	}
	local var_9_1 = 0
	local var_9_2 = 0
	local var_9_3 = {
		{},
		{}
	}
	local var_9_4 = csv.cards
	local var_9_5 = csv.unit

	for iter_9_0 = 1, 2 do
		for iter_9_1 = 1, 6 do
			local var_9_6 = arg_9_1.defence_cards[iter_9_0][iter_9_1]

			if var_9_6 then
				local var_9_7 = arg_9_1.defence_card_attrs[var_9_6]
				local var_9_8 = csv.cards[var_9_7.card_id]
				local var_9_9 = csv.unit[var_9_8.unitID]

				if var_9_7.nature_choose == 1 then
					var_9_3[iter_9_0][iter_9_1] = var_9_9.natureType
				else
					var_9_3[iter_9_0][iter_9_1] = var_9_9.natureType2
				end

				if var_9_4[var_9_7.card_id] then
					var_9_7.rarity = var_9_5[var_9_4[var_9_7.card_id].unitID].rarity
					var_9_7.isInfo = true

					if iter_9_1 <= 3 then
						var_9_0[iter_9_0][1][iter_9_1] = var_9_7
					else
						var_9_0[iter_9_0][2][iter_9_1 - 3] = var_9_7
					end

					if iter_9_0 == 1 then
						var_9_1 = var_9_1 + var_9_7.fighting_point
					else
						var_9_2 = var_9_2 + var_9_7.fighting_point
					end
				end
			elseif iter_9_1 <= 3 then
				var_9_0[iter_9_0][1][iter_9_1] = {
					isInfo = false
				}
			else
				var_9_0[iter_9_0][2][iter_9_1 - 3] = {
					isInfo = false
				}
			end
		end
	end

	arg_9_0.down1:get("imgBg.textZl"):text(var_9_1)
	arg_9_0.down2:get("imgBg.textZl"):text(var_9_2)
	arg_9_0.down1:get("imgBg.imgBuf"):texture(dataEasy.getTeamBuff(var_9_3[1]).imgPath)
	arg_9_0.down2:get("imgBg.imgBuf"):texture(dataEasy.getTeamBuff(var_9_3[2]).imgPath)
	adapt.oneLinePos(arg_9_0.down1:get("imgBg.textNote"), arg_9_0.down1:get("imgBg.textZl"))
	adapt.oneLinePos(arg_9_0.down2:get("imgBg.textNote"), arg_9_0.down2:get("imgBg.textZl"))

	if matchLanguage({
		"en"
	}) then
		adapt.setAutoText(arg_9_0.down1:get("textNote1"), nil, 120)
		adapt.setAutoText(arg_9_0.down1:get("textNote2"), nil, 120)
		adapt.setAutoText(arg_9_0.down2:get("textNote1"), nil, 120)
		adapt.setAutoText(arg_9_0.down2:get("textNote2"), nil, 120)
	end

	arg_9_0.team1 = var_9_0[1][1]
	arg_9_0.team2 = var_9_0[1][2]
	arg_9_0.team3 = var_9_0[2][1]
	arg_9_0.team4 = var_9_0[2][2]
end

return var_0_0
