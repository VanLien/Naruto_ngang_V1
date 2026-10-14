local var_0_0 = class("VolleyballRankView", Dialog)

var_0_0.RESOURCE_FILENAME = "volleyball_rank.json"
var_0_0.RESOURCE_BINDING = {
	["right.rank.down.rank"] = "myRank",
	["right.rank.item"] = "rankItem",
	["right.rank.down.name"] = "myName",
	["right.rank.down.times"] = "myTimes",
	["right.rank.down.spriteName"] = "mySpriteName",
	["right.rank.txtCount"] = "txtCount",
	["right.rank.down.areaSer"] = "myAreaSer",
	right = "right",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["right.rank.list"] = {
		varname = "rankList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 10,
				padding = 10,
				data = bindHelper.self("rankData"),
				item = bindHelper.self("rankItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("rank", "head", "name", "Lv", "Lv1", "areaSer", "txtRank", "times")

					bind.extend(arg_1_0, var_1_0.head, {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_1_3.logo,
							frameId = arg_1_3.frame,
							onNode = function(arg_2_0)
								arg_2_0:xy(104, 95):z(6):scale(0.9)
							end
						}
					})
					var_1_0.rank:get("txt"):visible(arg_1_2 > 3)
					var_1_0.rank:visible(arg_1_2 <= 10)
					var_1_0.txtRank:visible(arg_1_2 > 10)

					local var_1_1 = {
						"city/rank/icon_jp.png",
						"city/rank/icon_yp.png",
						"city/rank/icon_tp.png",
						"common/icon/icon_four.png"
					}

					if arg_1_2 < 4 then
						var_1_0.rank:texture(var_1_1[arg_1_2])
					elseif arg_1_2 >= 4 and arg_1_2 <= 10 then
						var_1_0.rank:texture(var_1_1[4])
						var_1_0.rank:get("txt"):text(arg_1_2)
					elseif arg_1_2 > 10 then
						var_1_0.txtRank:text(arg_1_2)
					end

					var_1_0.name:text(arg_1_3.name)
					var_1_0.Lv1:text(arg_1_3.level)
					adapt.oneLinePos(var_1_0.Lv, var_1_0.Lv1, cc.p(2, 0), "left")
					var_1_0.areaSer:text(getServerArea(arg_1_3.game_key))
					var_1_0.times:text(arg_1_3.rank_data[1])
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.data = arg_3_1
	arg_3_0.ranking = arg_3_1.ranking or {}
	arg_3_0.rightColumnSize = 10
	arg_3_0.rankData = idlers.newWithMap(arg_3_0.ranking)

	arg_3_0.rankList:setScrollBarEnabled(false)
	arg_3_0:resetShowPanel()
	arg_3_0:showMyRank(arg_3_2)
	Dialog.onCreate(arg_3_0)
end

function var_0_0.resetShowPanel(arg_4_0)
	arg_4_0.right:get("noRank"):visible(arg_4_0.ranking[1] == nil)
	arg_4_0.right:get("rank"):visible(arg_4_0.ranking[1] ~= nil)
end

function var_0_0.showMyRank(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.data
	local var_5_1 = var_5_0.rank and var_5_0.rank ~= 0 and var_5_0.rank or gLanguageCsv.noRank

	arg_5_0.myRank:text(var_5_1)
	arg_5_0.myName:text(gGameModel.role:read("name"))

	local var_5_2 = userDefault.getForeverLocalKey("serverKey", nil, {
		rawKey = true
	})

	arg_5_0.myAreaSer:text(getServerArea(var_5_2))

	local var_5_3 = arg_5_1 > 0 and arg_5_1 or "--"

	arg_5_0.myTimes:text(var_5_3)
end

return var_0_0
