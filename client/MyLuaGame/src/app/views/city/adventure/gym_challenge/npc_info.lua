local var_0_0 = class("GymNpcInfoView", Dialog)

var_0_0.RESOURCE_FILENAME = "gym_npc_info.json"
var_0_0.RESOURCE_BINDING = {
	["imgBG.textIntro2"] = "textIntro2",
	["imgBG.textName"] = "masterName",
	["imgBG.textIntro1"] = "textIntro1",
	["imgBG.bg"] = "bg",
	["imgBG.attrItem"] = "attrItem",
	["title.textTitle1"] = {
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
	["title.textTitle2"] = {
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
	["imgBG.arrList"] = {
		varname = "arrList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("attrData"),
				item = bindHelper.self("attrItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("imgIcon"):texture(ui.ATTR_ICON[arg_1_3])
				end,
				onAfterBuild = function(arg_2_0)
					local var_2_0 = arg_2_0.item:size()
					local var_2_1 = csvSize(arg_2_0.data)
					local var_2_2 = var_2_0.width * var_2_1 + arg_2_0:getItemsMargin() * (var_2_1 - 1)

					arg_2_0:setAnchorPoint(cc.p(1, 0.5))
					arg_2_0:width(var_2_2)
					arg_2_0:xy(cc.p(1600, 950))
				end
			}
		}
	},
	["imgBG.figurePanel"] = {
		binds = {
			event = "extend",
			class = "role_figure",
			props = {
				spine = true,
				data = bindHelper.self("figureId"),
				onSpine = function(arg_3_0)
					arg_3_0:scale(1):y(160)
				end
			}
		}
	},
	["imgBG.list"] = {
		varname = "battleArrayList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 10,
				padding = 10,
				data = bindHelper.self("monsterDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					bind.extend(arg_4_0, arg_4_1, {
						class = "card_icon",
						props = {
							showAttribute = true,
							unitId = arg_4_3.unitId,
							advance = arg_4_3.advance,
							levelProps = {
								data = arg_4_3.level
							},
							isBoss = arg_4_3.isBoss,
							rarity = arg_4_3.rarity,
							onNode = function(arg_5_0)
								local var_5_0, var_5_1 = arg_5_0:xy()

								arg_4_1:scale(arg_4_3.isBoss and 0.72 or 0.7)
							end
						}
					})
				end
			}
		}
	},
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	}
}

local function var_0_1(arg_6_0, arg_6_1)
	local var_6_0 = {}

	for iter_6_0, iter_6_1 in ipairs(arg_6_0) do
		local var_6_1 = csv.unit[iter_6_1.unitId]

		table.insert(var_6_0, {
			unitId = iter_6_1.unitId,
			level = iter_6_1.level,
			advance = iter_6_1.advance,
			rarity = var_6_1.rarity,
			attr1 = var_6_1.natureType,
			attr2 = var_6_1.natureType2,
			isBoss = arg_6_1
		})
	end

	table.sort(var_6_0, function(arg_7_0, arg_7_1)
		return arg_7_0.advance > arg_7_1.advance
	end)

	return var_6_0
end

function var_0_0.onCreate(arg_8_0, arg_8_1)
	arg_8_0.id = arg_8_1

	local var_8_0 = csv.gym.gym[arg_8_0.id].npcID
	local var_8_1 = csv.gym.npc[var_8_0].figure

	arg_8_0.figureId = idler.new(var_8_1)

	arg_8_0.masterName:text(gRoleFigureCsv[var_8_1].name)

	arg_8_0.attrData = idlers.newWithMap(csv.gym.gym[arg_8_1].limitAttribute)

	beauty.textScroll({
		fontSize = 40,
		isRich = false,
		list = arg_8_0.textIntro1,
		strs = csv.gym.npc[var_8_0].expertise,
		effect = {
			color = ui.NEWCOLORS.BROWN2
		}
	})
	beauty.textScroll({
		fontSize = 40,
		isRich = false,
		list = arg_8_0.textIntro2,
		strs = csv.gym.npc[var_8_0].desc,
		effect = {
			color = ui.NEWCOLORS.BROWN2
		}
	})

	arg_8_0.item = ccui.Layout:create():size(180, 180):show():setTouchEnabled(true):retain():scale(0.8)

	local var_8_2 = 0

	for iter_8_0, iter_8_1 in csvPairs(csv.gym.gate) do
		if iter_8_1.npc == true and iter_8_1.gymID == arg_8_0.id then
			var_8_2 = iter_8_0
		end
	end

	local var_8_3 = csv.scene_conf[var_8_2]
	local var_8_4 = var_0_1(var_8_3.boss, true)
	local var_8_5 = var_0_1(var_8_3.monsters, false)

	arg_8_0.monsterDatas = arraytools.merge({
		var_8_4,
		var_8_5
	})

	Dialog.onCreate(arg_8_0)
end

return var_0_0
