local var_0_0 = {
	"common/icon/logo_yellow.png",
	"common/icon/logo_blue.png",
	"common/icon/logo_green.png",
	"common/icon/logo_gray.png"
}
local var_0_1 = class("HorseRaceRankView", Dialog)

var_0_1.RESOURCE_FILENAME = "horse_race_rank.json"
var_0_1.RESOURCE_BINDING = {
	noRank = "noRank",
	down = "downPanel",
	item = "item",
	["title.textTitle2"] = "textTitle2",
	["title.textTitle1"] = "textTitle1",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
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
				padding = 20,
				data = bindHelper.self("rankDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("baseNode.textName"):text(arg_1_3.name)
					local var_1_1 = arg_1_1:get("baseNode.textLv"):text(arg_1_3.level)

					uiEasy.setRankIcon(arg_1_2, arg_1_1:get("baseNode.imgIcon"), arg_1_1:get("baseNode.textRank1"), arg_1_1:get("baseNode.textRank2"))
					arg_1_1:get("baseNode.textFightPoint"):text(arg_1_3.rank_data[1])
					arg_1_1:get("baseNode.textServer"):text(string.format(gLanguageCsv.brackets, getServerArea(arg_1_3.game_key, true)))
					adapt.oneLinePos(var_1_0, {
						arg_1_1:get("baseNode.textLvNote"),
						var_1_1
					}, cc.p(10, 0), "left")
					bind.extend(arg_1_0, arg_1_1:get("baseNode.head"), {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_1_3.logo,
							frameId = arg_1_3.frame
						}
					})
					arg_1_1:get("baseNode.textFightPoint"):text(arg_1_3.fighting_point)
				end
			}
		}
	}
}

function var_0_1.onCreate(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0:initModel()

	arg_2_0.rankDatas = idlers.new()

	arg_2_0.rankDatas:update(arg_2_2.ranking)

	local var_2_0 = arg_2_0.yyhuodongs[arg_2_1].horse_race.point

	if arg_2_2.my_rank and arg_2_2.my_rank ~= 0 then
		arg_2_0.downPanel:get("textRank"):text(arg_2_2.my_rank)
	else
		arg_2_0.downPanel:get("textRank"):text(gLanguageCsv.noRank)
	end

	if itertools.size(arg_2_2.ranking) <= 0 then
		arg_2_0.noRank:setVisible(true)
		arg_2_0.downPanel:setVisible(false)
	else
		arg_2_0.noRank:setVisible(false)
		arg_2_0.downPanel:setVisible(true)
	end

	arg_2_0.downPanel:get("textName"):text(arg_2_0.name)
	arg_2_0.downPanel:get("textFightPoint"):text(var_2_0 or 0)
	Dialog.onCreate(arg_2_0)
end

function var_0_1.initModel(arg_3_0)
	arg_3_0.yyhuodongs = gGameModel.role:read("yyhuodongs")
	arg_3_0.name = gGameModel.role:read("name")
end

return var_0_1
