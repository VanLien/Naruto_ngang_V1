local var_0_0 = {
	"common/icon/logo_yellow.png",
	"common/icon/logo_blue.png",
	"common/icon/logo_green.png",
	"common/icon/logo_gray.png"
}

local function var_0_1(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = 0
	local var_1_1 = 0
	local var_1_2 = 0

	if arg_1_0 then
		var_1_0 = csv.random_tower.tower[arg_1_0].floor
		var_1_1 = csv.random_tower.tower[arg_1_0].roomIdx
		var_1_2 = gRandomTowerFloorMax[var_1_0]
	end

	arg_1_1:text(string.format(gLanguageCsv.randomTowerSomeFloor, var_1_0))
	arg_1_2:text(var_1_1 .. "/" .. var_1_2)
	adapt.oneLinePos(arg_1_1, arg_1_2, cc.p(5, 0))
end

local var_0_2 = class("RandomTowerRankView", Dialog)

var_0_2.RESOURCE_FILENAME = "random_tower_rank.json"
var_0_2.RESOURCE_BINDING = {
	["down.textProgress"] = "textProgress",
	item = "item",
	["down.textProgressNote"] = "textProgressNote",
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
			idler = bindHelper.self("roleName")
		}
	},
	["down.textRank"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("dayRank"),
			method = function(arg_2_0)
				return arg_2_0 > 0 and arg_2_0 or gLanguageCsv.noRank
			end
		}
	},
	["down.textPoint"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("dayPoint")
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
				itemAction = {
					isAction = true
				},
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:multiget("imgIcon", "textRank1", "textRank2", "head", "textName", "imgVip", "textLv", "textPoint", "textProgress", "textProgressNote")

					var_3_0.textName:text(arg_3_3.role.name)
					var_3_0.imgVip:texture(ui.VIP_ICON[arg_3_3.role.vip_level]):visible(arg_3_3.role.vip_level > 0)
					adapt.oneLinePos(var_3_0.textName, var_3_0.imgVip, cc.p(5, 0))
					var_0_1(arg_3_3.random_tower.room, var_3_0.textProgressNote, var_3_0.textProgress)
					var_3_0.textLv:text(arg_3_3.role.level)
					uiEasy.setRankIcon(arg_3_2, var_3_0.imgIcon, var_3_0.textRank1, var_3_0.textRank2)
					bind.extend(arg_3_0, var_3_0.head, {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_3_3.role.logo,
							frameId = arg_3_3.role.frame
						}
					})
					var_3_0.textPoint:text(arg_3_3.random_tower.day_point)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	}
}

function var_0_2.onCreate(arg_4_0, arg_4_1)
	arg_4_0:initModel()

	arg_4_0.rankDatas = arg_4_1.rank

	var_0_1(arg_4_0.room:read(), arg_4_0.textProgressNote, arg_4_0.textProgress)
	Dialog.onCreate(arg_4_0)
end

function var_0_2.initModel(arg_5_0)
	arg_5_0.dayRank = gGameModel.random_tower:getIdler("day_rank")
	arg_5_0.dayPoint = gGameModel.random_tower:getIdler("day_point")
	arg_5_0.room = gGameModel.random_tower:getIdler("room")
	arg_5_0.roleName = gGameModel.role:getIdler("name")
end

return var_0_2
