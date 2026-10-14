local var_0_0 = {
	"common/icon/logo_yellow.png",
	"common/icon/logo_blue.png",
	"common/icon/logo_green.png",
	"common/icon/logo_gray.png"
}
local var_0_1 = class("ArenaRankView", Dialog)

var_0_1.RESOURCE_FILENAME = "arena_rank.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["title.textTitle1"] = {
		varname = "textTitle1",
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
		varname = "textTitle2",
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
	["down.textName"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("record"),
			method = function(arg_1_0)
				return arg_1_0.role_name
			end
		}
	},
	["down.textRank"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("record"),
			method = function(arg_2_0)
				return arg_2_0.rank
			end
		}
	},
	["down.textFightPoint"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("record"),
			method = function(arg_3_0)
				return arg_3_0.fighting_point
			end
		}
	},
	["down.textLv"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("record"),
			method = function(arg_4_0)
				return arg_4_0.role_level
			end
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 12,
				asyncPreload = 4,
				data = bindHelper.self("rankDatas"),
				item = bindHelper.self("item"),
				record = bindHelper.self("record"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					local var_5_0 = arg_5_0.record:read()

					arg_5_1:get("baseNode.textName"):text(arg_5_3.name)
					arg_5_1:get("baseNode.textLv"):text(arg_5_3.level)
					uiEasy.setRankIcon(arg_5_2, arg_5_1:get("baseNode.imgIcon"), arg_5_1:get("baseNode.textRank1"), arg_5_1:get("baseNode.textRank2"))
					bind.extend(arg_5_0, arg_5_1:get("baseNode.head"), {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_5_3.logo,
							frameId = arg_5_3.frame
						}
					})
					arg_5_1:get("baseNode.textFightPoint"):text(arg_5_3.fighting_point)
					bind.touch(arg_5_0, arg_5_1, {
						methods = {
							ended = functools.partial(arg_5_0.clickCell, arg_5_2, arg_5_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_6_0, arg_6_1)
	arg_6_0:initModel()

	arg_6_0.rankDatas = arg_6_1.rank

	Dialog.onCreate(arg_6_0)
end

function var_0_1.initModel(arg_7_0)
	arg_7_0.record = gGameModel.arena:getIdler("record")
end

function var_0_1.onItemClick(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if arg_8_3.role_db_id == arg_8_0.record:read().role_db_id then
		return
	end

	gGameApp:requestServer("/game/pw/role/info", function(arg_9_0)
		gGameUI:stackUI("city.pvp.arena.personal_info", nil, nil, arg_9_0.view)
	end, arg_8_3.record_id)
end

return var_0_1
