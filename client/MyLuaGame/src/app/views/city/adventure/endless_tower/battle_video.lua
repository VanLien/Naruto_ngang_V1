local var_0_0 = class("EndlessTowerBattleVideo", Dialog)

var_0_0.RESOURCE_FILENAME = "endless_tower_battle_video.json"
var_0_0.RESOURCE_BINDING = {
	icon = "icon",
	item = "item",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	title1 = {
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
	title2 = {
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
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				data = bindHelper.self("combatDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("logo", "roleName", "vip", "battle", "rounds", "btn")

					bind.extend(arg_1_0, var_1_0.logo, {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_1_3.logo,
							frameId = arg_1_3.frame,
							onNode = function(arg_2_0)
								arg_2_0:scale(0.9)
							end
						}
					})
					var_1_0.roleName:text(arg_1_3.name)
					var_1_0.vip:texture(ui.VIP_ICON[arg_1_3.vip]):visible(arg_1_3.vip > 0)
					var_1_0.battle:text(arg_1_3.fighting_point)
					var_1_0.rounds:text(arg_1_3.round)

					if arg_1_3.vip > 0 then
						var_1_0.vip:texture(ui.VIP_ICON[arg_1_3.vip])
						adapt.oneLinePos(var_1_0.roleName, var_1_0.vip, cc.p(15, 0))
					end

					bind.touch(arg_1_0, var_1_0.btn, {
						methods = {
							ended = functools.partial(arg_1_0.playBtn, arg_1_2, arg_1_3)
						}
					})
				end,
				onAfterBuild = function(arg_3_0)
					arg_3_0.afterBuild()
				end
			},
			handlers = {
				playBtn = bindHelper.self("onPlayClick"),
				afterBuild = bindHelper.self("onAfterBuild")
			}
		}
	}
}

function var_0_0.onCreate(arg_4_0, arg_4_1)
	arg_4_0.combatDatas = arg_4_1

	Dialog.onCreate(arg_4_0)
end

function var_0_0.onPlayClick(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0

	local function var_5_1(arg_6_0, arg_6_1, arg_6_2)
		battleEntrance.battleRecord(arg_6_1, arg_6_0.result, {
			noShowEndRewards = true
		}):preCheck(nil, function()
			if arg_6_2 then
				for iter_7_0, iter_7_1 in pairs(game.ATTRDEF_ENUM_TABLE) do
					for iter_7_2, iter_7_3 in pairs(arg_6_1.roleOut) do
						if iter_7_3[iter_7_0] then
							iter_7_3[iter_7_0] = iter_7_3[iter_7_0] * gCommonConfigCsv.preCheckFailAttrFix
						end
					end
				end

				arg_6_1.endlessAttrFix = true

				var_5_1(arg_6_0, arg_6_1)
			else
				gGameUI:showTip(gLanguageCsv.crossCraftPlayNotExisted)
			end
		end):show()
	end

	gGameApp:requestServer("/game/endless/play/detail", function(arg_8_0)
		local var_8_0 = gGameModel:getEndlessPlayRecord(arg_5_3.play_id)
		local var_8_1 = var_8_0:getData()

		var_5_1(var_8_0, var_8_1, true)
	end, arg_5_3.play_id)
end

function var_0_0.onAfterBuild(arg_9_0)
	arg_9_0.icon:visible(arg_9_0.list:getChildrenCount() == 0)
end

return var_0_0
