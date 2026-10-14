local var_0_0 = class("SnowBallRank", Dialog)

var_0_0.RESOURCE_FILENAME = "snow_ball_rank.json"
var_0_0.RESOURCE_BINDING = {
	["right.rank.down.time"] = "myTime",
	["right.rank.down.rank"] = "myRank",
	["right.rank.item"] = "rankItem",
	["right.rank.down.score"] = "myScore",
	["right.rank.down.spriteName"] = "mySpriteName",
	["right.rank.txtCount"] = "txtCount",
	["right.rank.down.name"] = "myName",
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
					local var_1_0 = arg_1_1:multiget("rank", "head", "name", "Lv", "Lv1", "score", "count", "txtRank", "time", "imgSprite")

					bind.extend(arg_1_0, var_1_0.head, {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_1_3.role.logo,
							frameId = arg_1_3.role.frame,
							onNode = function(arg_2_0)
								arg_2_0:xy(104, 95):z(6):scale(0.9)
							end
						}
					})
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

					local var_1_1 = arg_1_3.snowball.role == 0 and 4 or arg_1_3.snowball.role
					local var_1_2 = csv.yunying.snowball_element[var_1_1].attr.cardId
					local var_1_3 = csv.unit[csv.cards[var_1_2].unitID]

					var_1_0.imgSprite:texture(var_1_3.iconSimple)
					var_1_0.name:text(arg_1_3.role.name)
					var_1_0.Lv1:text(arg_1_3.role.level)
					adapt.oneLinePos(var_1_0.Lv, var_1_0.Lv1, cc.p(2, 0), "left")
					var_1_0.score:text(arg_1_3.snowball.point)

					local var_1_4 = math.floor(arg_1_3.snowball.time % 3600 / 60)
					local var_1_5 = math.floor(arg_1_3.snowball.time % 60)
					local var_1_6 = string.format("%02d:%02d", var_1_4, var_1_5)

					var_1_0.time:text(var_1_6)
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.data = arg_3_1

	arg_3_0:resetShowPanel()

	arg_3_0.rightColumnSize = 10

	arg_3_0.rankList:setScrollBarEnabled(false)

	arg_3_0.rankData = idlers.newWithMap(arg_3_0.data.rank or {})

	if arg_3_2.rank and arg_3_2.rank ~= 0 then
		arg_3_0.myRank:text(arg_3_2.rank)
	else
		arg_3_0.myRank:text("--")
	end

	arg_3_0.myName:text(gGameModel.role:read("name"))
	arg_3_0.myScore:text(arg_3_2.top_point == 0 and "--" or arg_3_2.top_point)

	if arg_3_2.top_time and arg_3_2.top_time == 0 then
		arg_3_0.myTime:text("--:--")
	else
		local var_3_0 = math.floor(arg_3_2.top_time % 3600 / 60)
		local var_3_1 = math.floor(arg_3_2.top_time % 60)
		local var_3_2 = string.format("%02d:%02d", var_3_0, var_3_1)

		arg_3_0.myTime:text(var_3_2)
	end

	if arg_3_2.top_role and arg_3_2.top_role ~= 0 then
		local var_3_3 = csv.yunying.snowball_element[arg_3_2.top_role].attr.cardId
		local var_3_4 = csv.unit[csv.cards[var_3_3].unitID]

		arg_3_0.mySpriteName:text(var_3_4.name)
	else
		arg_3_0.mySpriteName:text("")
	end

	Dialog.onCreate(arg_3_0)
end

function var_0_0.resetShowPanel(arg_4_0)
	arg_4_0.right:get("noRank"):visible(arg_4_0.data.rank[1] == nil)
	arg_4_0.right:get("rank"):visible(arg_4_0.data.rank[1] ~= nil)
end

return var_0_0
