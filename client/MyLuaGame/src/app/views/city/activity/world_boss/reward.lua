local var_0_0 = class("WorldBossRewardView", Dialog)

var_0_0.RESOURCE_FILENAME = "activity_world_boss_reward.json"
var_0_0.RESOURCE_BINDING = {
	["panel.rankItem"] = "rankItem",
	["leftPanel.tabItem"] = "tabItem",
	panel = "panel",
	["leftPanel.tabList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("tabItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("normal")
					local var_1_1 = arg_1_1:get("selected")
					local var_1_2

					if arg_1_3.select then
						var_1_0:hide()

						var_1_2 = var_1_1:show()
					else
						var_1_1:hide()

						var_1_2 = var_1_0:show()
					end

					adapt.setAutoMultiLine(var_1_2:get("txt"), arg_1_3.name, nil, 5)
					bind.touch(arg_1_0, var_1_0, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	["panel.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("datas"),
				item = bindHelper.self("rankItem"),
				itemAction = {
					isAction = true,
					alwaysShow = true
				},
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("imgBg", "rankIcon", "list", "txtRank")

					var_2_0.rankIcon:hide()
					var_2_0.txtRank:hide()

					if arg_2_2 <= 3 then
						var_2_0.rankIcon:show():texture("activity/world_boss/img_rank" .. arg_2_2 .. ".png")
					else
						local var_2_1 = arg_2_3.preRank
						local var_2_2 = arg_2_3.cfg.rank
						local var_2_3 = var_2_1 < var_2_2 and var_2_1 .. "-" .. var_2_2 or var_2_2

						var_2_0.txtRank:show():text(var_2_3)
					end

					uiEasy.createItemsToList(arg_2_0, var_2_0.list, arg_2_3.cfg.award, {
						margin = 40,
						scale = 0.9
					})
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_3_0, arg_3_1)
	local var_3_0 = csv.yunying.yyhuodong[arg_3_1]
	local var_3_1

	for iter_3_0, iter_3_1 in orderCsvPairs(csv.world_boss.base) do
		if iter_3_1.huodongID == var_3_0.huodongID then
			local var_3_2 = iter_3_1

			break
		end
	end

	local var_3_3 = {}
	local var_3_4 = csv.world_boss.role_rank_award

	for iter_3_2, iter_3_3 in orderCsvPairs(var_3_4) do
		if iter_3_3.huodongID == var_3_0.huodongID then
			table.insert(var_3_3, {
				cfg = iter_3_3,
				csvId = iter_3_2,
				preRank = var_3_4[iter_3_2 - 1] and var_3_4[iter_3_2 - 1].rank + 1 or 1
			})
		end
	end

	local var_3_5 = {}
	local var_3_6 = csv.world_boss.union_rank_award

	for iter_3_4, iter_3_5 in orderCsvPairs(var_3_6) do
		if iter_3_5.huodongID == var_3_0.huodongID then
			table.insert(var_3_5, {
				cfg = iter_3_5,
				csvId = iter_3_4,
				preRank = var_3_6[iter_3_4 - 1] and var_3_6[iter_3_4 - 1].rank + 1 or 1
			})
		end
	end

	arg_3_0.tabDatas = idlers.newWithMap({
		{
			name = gLanguageCsv.role
		},
		{
			name = gLanguageCsv.guild
		}
	})
	arg_3_0.showTab = idler.new(1)
	arg_3_0.datas = idlers.new()

	arg_3_0.showTab:addListener(function(arg_4_0, arg_4_1)
		arg_3_0.tabDatas:atproxy(arg_4_1).select = false
		arg_3_0.tabDatas:atproxy(arg_4_0).select = true

		arg_3_0.datas:update(arg_4_0 == 1 and var_3_3 or var_3_5)
	end)
	Dialog.onCreate(arg_3_0)
end

function var_0_0.onTabClick(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0.showTab:set(arg_5_2)
end

return var_0_0
