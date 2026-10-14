local var_0_0 = class("OnlineFightRecordInfoView", Dialog)

var_0_0.RESOURCE_FILENAME = "online_fight_record_info.json"
var_0_0.RESOURCE_BINDING = {
	panel2 = "panel2",
	item = "item",
	panel1 = "panel1"
}

function var_0_0.onCreate(arg_1_0, arg_1_1, arg_1_2)
	Dialog.onCreate(arg_1_0)

	local var_1_0 = {
		{
			fighting_point = 0,
			result = arg_1_1.results[1] == "win",
			name = arg_1_1.name,
			game_key = arg_1_1.role_key[1],
			level = arg_1_1.level,
			rank = arg_1_1.rank,
			score = arg_1_1.score,
			logo = arg_1_1.logo,
			frame = arg_1_1.frame,
			cards = arg_1_1.cards,
			card_attrs = arg_1_1.card_attrs,
			teamBuffs = {}
		},
		{
			fighting_point = 0,
			result = arg_1_1.results[1] ~= "win",
			name = arg_1_1.defence_name,
			game_key = arg_1_1.defence_role_key[1],
			level = arg_1_1.defence_level,
			rank = arg_1_1.defence_rank,
			score = arg_1_1.defence_score,
			logo = arg_1_1.defence_logo,
			frame = arg_1_1.defence_frame,
			cards = arg_1_1.defence_cards,
			card_attrs = arg_1_1.defence_card_attrs,
			teamBuffs = {}
		}
	}

	for iter_1_0 = 1, 2 do
		local var_1_1 = var_1_0[iter_1_0]
		local var_1_2 = arg_1_0["panel" .. iter_1_0]
		local var_1_3 = var_1_2:get("head"):multiget("img", "textNoteLv", "textLv", "textName", "head")

		bind.extend(arg_1_0, var_1_3.head, {
			event = "extend",
			class = "role_logo",
			props = {
				vip = false,
				level = false,
				logoId = var_1_1.logo,
				frameId = var_1_1.frame
			}
		})
		text.addEffect(var_1_3.textNoteLv, {
			outline = {
				color = ui.COLORS.OUTLINE.DEFAULT
			}
		})
		text.addEffect(var_1_3.textLv, {
			outline = {
				color = ui.COLORS.OUTLINE.DEFAULT
			}
		})
		var_1_3.img:texture(var_1_1.result and "city/pvp/craft/icon_win.png" or "city/pvp/craft/icon_lose.png")
		var_1_3.textName:text(var_1_1.name)
		var_1_3.textLv:text(var_1_1.level)

		for iter_1_1 = 1, 2 do
			local var_1_4 = {}

			for iter_1_2 = 1, 3 do
				local var_1_5 = (iter_1_1 - 1) * 3 + iter_1_2
				local var_1_6 = var_1_1.cards[var_1_5]

				if var_1_6 then
					local var_1_7 = var_1_1.card_attrs[var_1_6]
					local var_1_8 = csv.cards[var_1_7.card_id]
					local var_1_9 = csv.unit[var_1_8.unitID]

					if var_1_7.nature_choose == 1 then
						var_1_1.teamBuffs[var_1_5] = var_1_9.natureType
					else
						var_1_1.teamBuffs[var_1_5] = var_1_9.natureType2
					end

					local var_1_10 = dataEasy.getUnitId(var_1_7.card_id, var_1_7.skin_id)

					var_1_4[iter_1_2] = {
						card_id = var_1_7.card_id,
						unitId = var_1_10,
						advance = var_1_7.advance,
						star = var_1_7.star,
						level = var_1_7.level,
						rarity = var_1_9.rarity
					}
					var_1_1.fighting_point = var_1_1.fighting_point + var_1_7.fighting_point
				else
					var_1_4[iter_1_2] = {}
				end
			end

			bind.extend(arg_1_0, var_1_2:get("array.list" .. iter_1_1), {
				class = "listview",
				props = {
					data = var_1_4,
					item = arg_1_0.item,
					onAfterBuild = function(arg_2_0)
						arg_2_0:setClippingEnabled(false)
					end,
					onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
						if itertools.isempty(arg_3_3) then
							arg_3_1:get("emptyPanel"):show()

							return
						end

						arg_3_1:get("emptyPanel"):hide()
						bind.extend(arg_3_0, arg_3_1, {
							class = "card_icon",
							props = {
								unitId = arg_3_3.unitId,
								advance = arg_3_3.advance,
								rarity = arg_3_3.rarity,
								star = arg_3_3.star,
								levelProps = {
									data = arg_3_3.level
								},
								onNode = function(arg_4_0)
									arg_4_0:xy(0, -6):scale(0.8)
								end
							}
						})
					end
				}
			})
		end

		if arg_1_2 == 1 then
			var_1_2:get("array.textArray"):show()
			var_1_2:get("array.textFight"):hide()
			var_1_2:get("array.textZl"):hide()
		else
			var_1_2:get("array.textArray"):hide()
			var_1_2:get("array.textFight"):show()
			var_1_2:get("array.textZl"):show():text(var_1_1.fighting_point)
		end

		var_1_2:get("array.imgBuf"):texture(dataEasy.getTeamBuff(var_1_1.teamBuffs).imgPath)
	end
end

return var_0_0
