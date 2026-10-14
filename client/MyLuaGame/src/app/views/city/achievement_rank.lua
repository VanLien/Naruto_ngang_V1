local function var_0_0(arg_1_0, arg_1_1, arg_1_2)
	if arg_1_2 == 0 then
		return 0
	end

	local var_1_0 = 1
	local var_1_1 = 0

	for iter_1_0, iter_1_1 in ipairs(arg_1_0) do
		var_1_1 = var_1_1 + 1

		if arg_1_2 < iter_1_1 then
			var_1_0 = iter_1_0 - 1

			break
		end

		if arg_1_1 == var_1_1 then
			var_1_0 = arg_1_1
		end
	end

	return var_1_0
end

local var_0_1 = class("AchievementRankView", Dialog)

var_0_1.RESOURCE_FILENAME = "endless_tower_rank.json"
var_0_1.RESOURCE_BINDING = {
	fightNote = "fightNote",
	achievementItem = "item",
	gateNote = "gateNote",
	rottomPanel = "rottomPanel",
	btnClose = {
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
				asyncPreload = 6,
				data = bindHelper.self("rankDatas"),
				item = bindHelper.self("item"),
				achievementRank = bindHelper.self("rank"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_0.achievementRank:read()
					local var_2_1 = arg_2_1:multiget("rankImg", "logo", "textRank1", "textRank2", "roleName", "vip", "battle", "level", "textLv", "imgLvBg")

					bind.extend(arg_2_0, var_2_1.logo, {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_2_3.role.logo,
							frameId = arg_2_3.role.frame
						}
					})
					var_2_1.imgLvBg:texture(gAchievementLevelCsv[0][arg_2_3.achievementLv].icon)
					uiEasy.setRankIcon(arg_2_3.index or arg_2_2, var_2_1.rankImg, var_2_1.textRank1, var_2_1.textRank2)
					var_2_1.roleName:text(arg_2_3.role.name)

					local var_2_2 = arg_2_3.role.vip_level

					var_2_1.vip:texture(ui.VIP_ICON[var_2_2]):visible(var_2_2 > 0)
					var_2_1.battle:text(arg_2_3.achievement)
					var_2_1.level:text(arg_2_3.role.level)
					var_2_1.textLv:text(arg_2_3.achievementLv)
					adapt.oneLinePos(var_2_1.roleName, var_2_1.vip, cc.p(15, 0))
					var_2_1.logo:setTouchEnabled(var_2_0 ~= arg_2_2)
					var_2_1.logo:onClick(functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3))
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1)
	local var_3_0 = {}
	local var_3_1 = 0

	for iter_3_0, iter_3_1 in pairs(gAchievementLevelCsv[0]) do
		if iter_3_0 > 0 then
			var_3_0[iter_3_0] = iter_3_1.point
			var_3_1 = var_3_1 + 1
		end
	end

	arg_3_0:initModel()

	local var_3_2 = 0
	local var_3_3 = 0

	for iter_3_2 = 1, #arg_3_1 do
		local var_3_4 = arg_3_1[iter_3_2]

		if iter_3_2 == 1 then
			var_3_2 = var_3_4.achievement
			var_3_3 = iter_3_2
			var_3_4.index = var_3_3
		elseif var_3_2 == var_3_4.achievement then
			var_3_4.index = var_3_3
		else
			var_3_2 = var_3_4.achievement
			var_3_3 = iter_3_2
			var_3_4.index = iter_3_2
		end

		var_3_4.achievementLv = var_0_0(var_3_0, var_3_1, var_3_4.achievement)
	end

	arg_3_0.rankDatas = arg_3_1

	arg_3_0.fightNote:hide()
	arg_3_0.gateNote:hide()

	local var_3_5 = arg_3_0.rank:read() == 0 and gLanguageCsv.notOnTheList or arg_3_0.rank:read()

	arg_3_0.rottomPanel:get("rank"):text(var_3_5)
	arg_3_0.rottomPanel:get("roleName"):text(arg_3_0.roleName:read())

	local var_3_6 = 0

	for iter_3_3, iter_3_4 in pairs(arg_3_0.points:read()) do
		var_3_6 = var_3_6 + iter_3_4
	end

	arg_3_0.rottomPanel:get("battle"):text(var_3_6)

	local var_3_7 = -1

	for iter_3_5, iter_3_6 in ipairs(gAchievementLevelCsv[0]) do
		if var_3_6 < iter_3_6.point then
			var_3_7 = iter_3_5 - 1

			break
		end
	end

	if var_3_7 == -1 then
		var_3_7 = itertools.size(gAchievementLevelCsv[0]) - 1
	end

	arg_3_0.rottomPanel:get("gate"):text(var_3_7)
	Dialog.onCreate(arg_3_0)
end

function var_0_1.initModel(arg_4_0)
	arg_4_0.roleName = gGameModel.role:getIdler("name")
	arg_4_0.points = gGameModel.role:getIdler("achievement_points")
	arg_4_0.rank = gGameModel.role:getIdler("achievement_rank")
end

function var_0_1.onItemClick(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_4.target
	local var_5_1, var_5_2 = var_5_0:xy()
	local var_5_3 = var_5_0:getParent():convertToWorldSpace(cc.p(var_5_1, var_5_2))

	gGameUI:stackUI("city.chat.personal_info", nil, nil, var_5_3, {
		role = arg_5_3.role
	}, {
		speical = "rank",
		target = arg_5_1.item:get("bg")
	})
end

return var_0_1
