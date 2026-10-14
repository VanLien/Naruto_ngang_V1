local var_0_0 = class("FishingRankView", Dialog)

var_0_0.RESOURCE_FILENAME = "fishing_rank.json"
var_0_0.RESOURCE_BINDING = {
	["right.rank.down.count"] = "myCount",
	["right.reward.reward.item"] = "rewardItem",
	["left.item"] = "btnItem",
	["right.rank.txtCount"] = "txtCount",
	["right.rank.down.rank"] = "myRank",
	["right.rank.down.name"] = "myName",
	["right.rank.down.score"] = "myScore",
	["right.reward.server.item"] = "serverItem",
	["right.rank.item"] = "rankItem",
	["right.reward.server.subList"] = "subList",
	right = "right",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["left.list"] = {
		varname = "btnList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("btnDatas"),
				item = bindHelper.self("btnItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("normal")
					local var_1_1 = arg_1_1:get("selected")

					var_1_1:visible(arg_1_3.selected)
					var_1_0:visible(not arg_1_3.selected)
					var_1_0:get("txt"):text(arg_1_3.txt)

					local var_1_2 = var_1_1:getSize().height - 40

					adapt.setAutoText(var_1_1:get("txt"), arg_1_3.txt, var_1_2)

					if matchLanguage({
						"cn",
						"tw"
					}) then
						var_1_1:get("txt"):setFontSize(arg_1_3.fontSize)
					end

					if matchLanguage({
						"en"
					}) then
						adapt.setAutoText(var_1_0:get("txt"), nil, 300)
					else
						var_1_0:get("txt"):getVirtualRenderer():setLineSpacing(-10)
					end

					var_1_1:get("txt"):getVirtualRenderer():setLineSpacing(-10)
					bind.touch(arg_1_0, var_1_0, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onSelectClick")
			}
		}
	},
	["right.reward.reward.list"] = {
		varname = "rewardList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 10,
				padding = 10,
				data = bindHelper.self("showData"),
				item = bindHelper.self("rewardItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("bg", "icon", "txtRank", "list")
					local var_2_1 = arg_2_2
					local var_2_2 = csv.cross.fishing.rank

					var_2_0.txtRank:visible(var_2_1 > 4)

					if var_2_1 <= 3 then
						var_2_0.icon:show()
						var_2_0.txtRank:hide()
						var_2_0.bg:texture("city/pvp/cross_craft/rank/box_phb" .. var_2_1 .. ".png")
						var_2_0.icon:texture("city/pvp/cross_craft/icon_" .. var_2_1 .. ".png")
					elseif var_2_1 == 4 and var_2_2[4].rankMax == 10 then
						var_2_0.icon:show()
						var_2_0.txtRank:hide()
						var_2_0.bg:texture("city/pvp/cross_craft/rank/box_phb4.png")
						var_2_0.icon:texture("city/pvp/cross_craft/icon_4.png")
					elseif var_2_1 > 3 and var_2_2[4].rankMax ~= 10 then
						var_2_0.icon:hide()
						var_2_0.txtRank:show()

						local var_2_3 = var_2_2[var_2_1 - 1].rankMax + 1
						local var_2_4 = var_2_2[var_2_1].rankMax
						local var_2_5 = var_2_3 < var_2_4 and var_2_3 .. "-" .. var_2_4 or var_2_4

						var_2_0.txtRank:text(var_2_5)
					end

					uiEasy.createItemsToList(arg_2_0, var_2_0.list, arg_2_3.cfg.award, {
						margin = 11,
						scale = 0.9
					})
				end
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
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:multiget("rank", "head", "name", "Lv", "Lv1", "score", "count", "txtRank", "server")
					local var_3_1 = arg_3_2

					bind.extend(arg_3_0, var_3_0.head, {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_3_3.logo,
							frameId = arg_3_3.frame,
							onNode = function(arg_4_0)
								arg_4_0:xy(104, 95):z(6):scale(0.9)
							end
						}
					})
					var_3_0.rank:get("txt"):visible(var_3_1 > 3)
					var_3_0.rank:visible(var_3_1 <= 10)
					var_3_0.txtRank:visible(var_3_1 > 10)

					if var_3_1 == 1 then
						var_3_0.rank:texture("city/rank/icon_jp.png")
					elseif var_3_1 == 2 then
						var_3_0.rank:texture("city/rank/icon_yp.png")
					elseif var_3_1 == 3 then
						var_3_0.rank:texture("city/rank/icon_tp.png")
					elseif var_3_1 >= 4 and var_3_1 <= 10 then
						var_3_0.rank:texture("common/icon/icon_four.png")
						var_3_0.rank:get("txt"):text(var_3_1)
					elseif var_3_1 > 10 then
						var_3_0.txtRank:text(var_3_1)
					end

					var_3_0.name:text(arg_3_3.name)
					var_3_0.server:text(string.format(gLanguageCsv.brackets, getServerArea(arg_3_3.game_key, true)))
					adapt.oneLinePos(var_3_0.name, var_3_0.server, cc.p(10, 0), "left")
					var_3_0.Lv1:text(arg_3_3.level)
					adapt.oneLinePos(var_3_0.Lv, var_3_0.Lv1, cc.p(2, 0), "left")
					var_3_0.score:text(arg_3_3.point)
					var_3_0.count:text(arg_3_3.special_fish_num)
				end
			}
		}
	},
	["right.reward.server.list"] = {
		varname = "serverList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				xMargin = 22,
				columnSize = 9,
				data = bindHelper.self("serverData"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("serverItem"),
				onCell = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					arg_5_1:multiget("txt").txt:text(getServerArea(arg_5_3, true, true))
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_6_0, arg_6_1)
	arg_6_0.data = arg_6_1

	arg_6_0:initModel()
	arg_6_0.serverList:setScrollBarEnabled(false)
	arg_6_0.subList:setScrollBarEnabled(false)
	arg_6_0.rankList:setScrollBarEnabled(false)
	arg_6_0.rewardList:setScrollBarEnabled(false)

	arg_6_0.btnDatas = idlers.new(btnDatas)
	arg_6_0.showTab = idler.new(1)
	arg_6_0.rankData = idlers.newWithMap(arg_6_0.data.ranks or {})
	arg_6_0.serverData = idlers.newWithMap(getMergeServers(arg_6_0.data.servers or {}))

	local var_6_0 = csv.fishing.fish[csv.cross.fishing.base[1].specialFish].name

	arg_6_0.txtCount:text(string.format(gLanguageCsv.specialFishNum, var_6_0))
	arg_6_0.myRank:text(arg_6_0.data.rank ~= 0 and arg_6_0.data.rank or gLanguageCsv.noRank)
	arg_6_0.myName:text(arg_6_0.roleName)
	arg_6_0.myScore:text(arg_6_0.data.point)
	arg_6_0.myCount:text(arg_6_0.data.special_fish_num)

	local var_6_1 = {
		{
			selected = false,
			fontSize = 50,
			txt = gLanguageCsv.rankList
		},
		{
			selected = false,
			fontSize = 45,
			txt = gLanguageCsv.craftRankReward
		}
	}

	arg_6_0.btnDatas:update(var_6_1)

	local var_6_2 = {}

	for iter_6_0, iter_6_1 in orderCsvPairs(csv.cross.fishing.rank) do
		table.insert(var_6_2, {
			cfg = iter_6_1
		})
	end

	arg_6_0.showData = idlers.newWithMap(var_6_2)

	arg_6_0.showTab:addListener(function(arg_7_0, arg_7_1, arg_7_2)
		arg_6_0.btnDatas:atproxy(arg_7_1).selected = false
		arg_6_0.btnDatas:atproxy(arg_7_0).selected = true

		arg_6_0:resetShowPanel(arg_7_0)
	end)
	Dialog.onCreate(arg_6_0)
end

function var_0_0.initModel(arg_8_0)
	arg_8_0.roleName = gGameModel.role:read("name")
end

function var_0_0.resetShowPanel(arg_9_0, arg_9_1)
	arg_9_0.right:get("noRank"):visible(arg_9_0.data.ranks[1] == nil and arg_9_1 == 1)
	arg_9_0.right:get("rank"):visible(arg_9_0.data.ranks[1] ~= nil and arg_9_1 == 1)
	arg_9_0.right:get("reward"):visible(arg_9_1 == 2)
end

function var_0_0.onSelectClick(arg_10_0, arg_10_1, arg_10_2)
	arg_10_0.showTab:set(arg_10_2)
end

return var_0_0
