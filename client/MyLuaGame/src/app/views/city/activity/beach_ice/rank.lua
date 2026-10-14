local var_0_0 = class("BeachIceRankView", Dialog)

var_0_0.RESOURCE_FILENAME = "beach_ice_rank.json"
var_0_0.RESOURCE_BINDING = {
	["right.rank.down.name"] = "myName",
	["right.rank.item"] = "rankItem",
	["right.rank.down.area"] = "myArea",
	["right.rank.down.high"] = "myHigh",
	["right.rank.down.rank"] = "myRank",
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
					local var_1_0 = arg_1_1:multiget("rank", "head", "name", "Lv", "Lv1", "score", "txtRank", "score", "area", "vip")

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
					var_1_0.area:text(getServerArea(arg_1_3.game_key))
					var_1_0.rank:get("txt"):visible(arg_1_2 > 3)
					var_1_0.rank:visible(arg_1_2 <= 10)
					var_1_0.txtRank:visible(arg_1_2 > 10)

					if arg_1_2 == 1 then
						var_1_0.rank:texture("city/rank/icon_jp.png")
					elseif arg_1_2 == 2 then
						var_1_0.rank:texture("city/rank/icon_yp.png")
					elseif arg_1_2 == 3 then
						var_1_0.rank:texture("city/rank/icon_tp.png")
					elseif arg_1_2 >= 4 and arg_1_2 <= 10 then
						var_1_0.rank:texture("common/icon/icon_four.png")
						var_1_0.rank:get("txt"):text(arg_1_2)
					elseif arg_1_2 > 10 then
						var_1_0.txtRank:text(arg_1_2)
					end

					var_1_0.name:text(arg_1_3.name)

					if arg_1_3.vip > 0 then
						var_1_0.vip:texture("common/icon/vip/icon_vip" .. arg_1_3.vip .. ".png"):show()
						adapt.oneLinePos(var_1_0.name, var_1_0.vip, cc.p(10, 0))
					else
						var_1_0.vip:hide()
					end

					var_1_0.Lv1:text(arg_1_3.level)
					var_1_0.score:text(arg_1_3.rank_data[1])
					adapt.oneLinePos(var_1_0.Lv, var_1_0.Lv1, cc.p(20, 0))
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.yyhuodongs = gGameModel.role:read("yyhuodongs")

	local var_3_0 = (arg_3_0.yyhuodongs[arg_3_2] or {}).info or {}

	arg_3_0.rankData = idlers.newWithMap(arg_3_1.ranking or {})

	if itertools.size(arg_3_1.ranking) ~= 0 then
		arg_3_0.right:get("rank"):show()
		arg_3_0.right:get("noRank"):hide()

		if arg_3_1.rank and arg_3_1.rank ~= 0 then
			arg_3_0.myRank:text(arg_3_1.rank)
			arg_3_0.myHigh:text(var_3_0.score or 0)
		else
			arg_3_0.myRank:text("--")
			arg_3_0.myHigh:text("--")
		end

		arg_3_0.myName:text(gGameModel.role:read("name"))
		arg_3_0.myArea:text(getServerArea(userDefault.getForeverLocalKey("serverKey", nil, {
			rawKey = true
		})))
	else
		arg_3_0.right:get("rank"):hide()
		arg_3_0.right:get("noRank"):show()
	end

	Dialog.onCreate(arg_3_0)
end

return var_0_0
