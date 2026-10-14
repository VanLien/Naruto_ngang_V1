local var_0_0 = {
	"lv",
	"lan",
	"zi",
	"cheng"
}
local var_0_1 = class("MimicryPersonalInfoView", Dialog)

var_0_1.RESOURCE_FILENAME = "mimicry_personal_info.json"
var_0_1.RESOURCE_BINDING = {
	["rightPanel.list2"] = "subList",
	battleNum = "battleNum",
	title = "title",
	["rightPanel.noBuff"] = "noBuff",
	["rightPanel.item"] = "item",
	roleName = "roleName",
	leftPanel = "leftPanel",
	levelNode = "levelNode",
	lv = "lv",
	rightPanel = "rightPanel",
	icon = {
		binds = {
			event = "extend",
			class = "role_logo",
			props = {
				vip = false,
				level = false,
				logoId = bindHelper.self("logoId"),
				frameId = bindHelper.self("frameId"),
				onNode = function(arg_1_0)
					arg_1_0.scale(arg_1_0, 1)
				end
			}
		}
	},
	["rightPanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 5,
				data = bindHelper.self("buffDate"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_3

					arg_2_1:get("bg"):texture(string.format("city/adventure/mimicry/icon_ntdz_%s.png", var_0_0[var_2_0.quality]))
					arg_2_1:get("icon"):texture(var_2_0.icon1)
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1)
	arg_3_0.logoId = idler.new(arg_3_1.logo)
	arg_3_0.frameId = idler.new(arg_3_1.frame)
	arg_3_0.buffDate = idlers.new({})

	if not arg_3_1.buff_ids or #arg_3_1.buff_ids == 0 then
		arg_3_0.noBuff:show()
	end

	local var_3_0 = {}
	local var_3_1 = csv.mimicry.buffs

	for iter_3_0, iter_3_1 in ipairs(arg_3_1.buff_ids or {}) do
		table.insert(var_3_0, var_3_1[iter_3_1])
	end

	table.sort(var_3_0, function(arg_4_0, arg_4_1)
		if arg_4_0.quality ~= arg_4_1.quality then
			return arg_4_1.quality < arg_4_0.quality
		end

		return arg_4_1.level < arg_4_0.level
	end)
	arg_3_0.buffDate:update(table.deepcopy(var_3_0))
	arg_3_0.roleName:text(arg_3_1.name)
	arg_3_0.lv:text(arg_3_1.level)
	adapt.oneLinePos(arg_3_0.roleName, {
		arg_3_0.levelNode,
		arg_3_0.lv
	}, cc.p(3, 0))

	local var_3_2 = 0

	for iter_3_2 = 1, 6 do
		local var_3_3 = arg_3_0.leftPanel:get("icon" .. iter_3_2)

		var_3_3:visible(true)

		if arg_3_1 and arg_3_1.battle_cards and arg_3_1.battle_cards[iter_3_2] then
			local var_3_4 = arg_3_1.battle_cards[iter_3_2]

			var_3_2 = var_3_2 + var_3_4.fighting_point

			local var_3_5 = csv.mimicry.cards[var_3_4.card_csv_id]
			local var_3_6 = dataEasy.getUnitId(var_3_5.cardID, var_3_4.skin_id)
			local var_3_7 = csv.unit[var_3_6]

			var_3_3.removeAllChildren(var_3_3)
			bind.extend(arg_3_0, var_3_3, {
				class = "card_icon",
				props = {
					showAttribute = false,
					unitId = var_3_6,
					advance = var_3_5.advance,
					levelProps = {
						data = var_3_5.level
					},
					star = var_3_4.star,
					rarity = var_3_7.rarity,
					onNode = function(arg_5_0)
						arg_5_0.scale(arg_5_0, 0.8)
					end
				}
			})
		end
	end

	arg_3_0.battleNum:text(var_3_2)
	adapt.oneLinePos(arg_3_0.title, arg_3_0.battleNum, cc.p(3, 0))
	Dialog.onCreate(arg_3_0)
end

return var_0_1
