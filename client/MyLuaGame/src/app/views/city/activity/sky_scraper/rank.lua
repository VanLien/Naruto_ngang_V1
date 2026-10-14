local var_0_0 = class("SnowBallRank", Dialog)

var_0_0.RESOURCE_FILENAME = "sky_scraper_rank.json"
var_0_0.RESOURCE_BINDING = {
	["right.rank.down.floor"] = "myFloor",
	["right.rank.down.rank"] = "myRank",
	["right.rank.item"] = "rankItem",
	["right.rank.down.score"] = "myScore",
	["right.rank.down.spriteName"] = "mySpriteName",
	["right.rank.down.name"] = "myName",
	["right.rank.txtRank"] = "txtRank",
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
				huodongId = bindHelper.self("huodongId"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("rank", "head", "name", "Lv", "Lv1", "score", "count", "txtRank", "floor", "imgSprite", "area")

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

					local var_1_1 = 1
					local var_1_2

					for iter_1_0, iter_1_1 in orderCsvPairs(csv.yunying.skyscraper_medals) do
						if iter_1_1.huodongID == arg_1_0.huodongId then
							var_1_1 = var_1_1 < iter_1_1.medalLevel and iter_1_1.medalLevel or var_1_1
							var_1_2 = iter_1_1.medalLevel == var_1_1 and iter_1_1.rankRes or var_1_2
						end
					end

					for iter_1_2, iter_1_3 in orderCsvPairs(csv.yunying.skyscraper_medals) do
						if iter_1_3.medalLevel == arg_1_3.medallvl + 1 and iter_1_3.huodongID == arg_1_0.huodongId then
							var_1_0.imgSprite:texture(iter_1_3.rankRes)

							break
						end
					end

					if arg_1_3.medallvl == var_1_1 then
						var_1_0.imgSprite:texture(var_1_2)
					end

					var_1_0.name:text(arg_1_3.name)
					var_1_0.Lv1:text(arg_1_3.level)
					adapt.oneLinePos(var_1_0.Lv, var_1_0.Lv1, cc.p(2, 0), "left")
					var_1_0.score:text(arg_1_3.high_score)
					var_1_0.floor:text(string.format(gLanguageCsv.randomTowerSomeFloor, arg_1_3.high_floor))
					adapt.oneLinePos(var_1_0.name, {
						var_1_0.Lv,
						var_1_0.Lv1
					}, {
						cc.p(20, 0),
						cc.p(0, 0)
					})
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.data = arg_3_2

	arg_3_0:resetShowPanel()

	arg_3_0.rightColumnSize = 10

	arg_3_0.rankList:setScrollBarEnabled(false)

	arg_3_0.rankData = idlers.newWithMap(arg_3_0.data.top_scorers or {})
	arg_3_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_3_0.huodongId = csv.yunying.yyhuodong[arg_3_1].huodongID

	idlereasy.when(arg_3_0.yyhuodongs, function(arg_4_0, arg_4_1)
		local var_4_0 = arg_4_1[arg_3_1] or {}

		arg_3_0.yydata = var_4_0

		local var_4_1 = var_4_0.info or {}

		if var_4_1.rank and var_4_1.rank ~= -1 then
			arg_3_0.myRank:text(var_4_1.rank)
		else
			arg_3_0.myRank:text("--")
		end

		arg_3_0.myName:text(gGameModel.role:read("name"))
		arg_3_0.myScore:text(var_4_1.high_points == 0 and "--" or var_4_1.high_points)
		arg_3_0.myFloor:text(var_4_1.high_floors == 0 and "--" or string.format(gLanguageCsv.randomTowerSomeFloor, var_4_1.high_floors))
	end)
	Dialog.onCreate(arg_3_0)
end

function var_0_0.resetShowPanel(arg_5_0)
	arg_5_0.right:get("noRank"):visible(arg_5_0.data.top_scorers[1] == nil)
	arg_5_0.right:get("rank"):visible(arg_5_0.data.top_scorers[1] ~= nil)
end

return var_0_0
