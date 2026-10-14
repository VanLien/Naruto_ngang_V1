local var_0_0 = class("EndlessTowerRank", Dialog)

var_0_0.RESOURCE_FILENAME = "endless_tower_rank.json"
var_0_0.RESOURCE_BINDING = {
	rottomPanel = "rottomPanel",
	item = "item",
	textPoint = "textPoint",
	textLv = "textLv",
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
				asyncPreload = 6,
				data = bindHelper.self("rankDatas"),
				item = bindHelper.self("item"),
				endlessRank = bindHelper.self("endlessRank"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_0.endlessRank:read()
					local var_1_1 = arg_1_1:multiget("rankImg", "logo", "textRank1", "textRank2", "roleName", "vip", "battle", "level", "gate")

					bind.extend(arg_1_0, var_1_1.logo, {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_1_3.role.logo,
							frameId = arg_1_3.role.frame
						}
					})
					uiEasy.setRankIcon(arg_1_2, var_1_1.rankImg, var_1_1.textRank1, var_1_1.textRank2)
					var_1_1.roleName:text(arg_1_3.role.name)
					var_1_1.vip:texture(ui.VIP_ICON[arg_1_3.role.vip_level]):visible(arg_1_3.role.vip_level > 0)
					var_1_1.battle:text(arg_1_3.fighting_point)
					var_1_1.level:text(arg_1_3.role.level)

					if arg_1_3.endless ~= 0 then
						local var_1_2 = csv.endless_tower_scene[arg_1_3.endless].sceneName

						var_1_1.gate:text(var_1_2)
					end

					adapt.oneLinePos(var_1_1.roleName, var_1_1.vip, cc.p(15, 0))
					var_1_1.logo:setTouchEnabled(var_1_0 ~= arg_1_2)
					var_1_1.logo:onClick(functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3))
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_2_0, arg_2_1)
	arg_2_0:initModel()

	arg_2_0.rankDatas = arg_2_1

	arg_2_0.textPoint:hide()
	arg_2_0.textLv:hide()

	local var_2_0 = arg_2_0.endlessRank:read() == 0 and gLanguageCsv.notOnTheList or arg_2_0.endlessRank:read()

	arg_2_0.rottomPanel:get("rank"):text(var_2_0)
	arg_2_0.rottomPanel:get("roleName"):text(arg_2_0.roleName:read())
	arg_2_0.rottomPanel:get("battle"):text(arg_2_0.fightingPoint:read())

	local var_2_1 = arg_2_0.maxGateId:read() == 0 and gLanguageCsv.notCleared or csv.endless_tower_scene[arg_2_0.maxGateId:read()].sceneName

	arg_2_0.rottomPanel:get("gate"):text(var_2_1)
	Dialog.onCreate(arg_2_0)
end

function var_0_0.initModel(arg_3_0)
	arg_3_0.endlessRank = gGameModel.role:getIdler("endless_rank")
	arg_3_0.roleName = gGameModel.role:getIdler("name")
	arg_3_0.fightingPoint = gGameModel.role:getIdler("top6_fighting_point")
	arg_3_0.maxGateId = gGameModel.role:getIdler("endless_tower_max_gate")
end

function var_0_0.onItemClick(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_4.target
	local var_4_1, var_4_2 = var_4_0:xy()
	local var_4_3 = var_4_0:getParent():convertToWorldSpace(cc.p(var_4_1, var_4_2))

	gGameUI:stackUI("city.chat.personal_info", nil, nil, var_4_3, {
		role = arg_4_3.role
	}, {
		speical = "rank",
		target = arg_4_1.item:get("bg")
	})
end

return var_0_0
