local var_0_0 = {
	"rankPanel",
	"rewardPanel"
}
local var_0_1 = csv.unlock[gUnlockCsv.craft].startLevel
local var_0_2 = 18
local var_0_3 = cc.load("mvc").ViewBase
local var_0_4 = class("CrossCraftRankView", Dialog)

var_0_4.RESOURCE_FILENAME = "cross_craft_rank.json"
var_0_4.RESOURCE_BINDING = {
	["noRankPanel.txtNode"] = "noRankTxt",
	["rewardPanel.winOnceList"] = "winOnceList",
	rewardPanel = "rewardPanel",
	["myRankPanel.txtRecord"] = "myRecord",
	myRankPanel = "myRankPanel",
	rankPanel = "rankPanel",
	["rankPanel.rankItem"] = "rankItem",
	["leftPanel.tabItem"] = "tabItem",
	["myRankPanel.txtName"] = "myName",
	["rewardPanel.loseOnceList"] = "loseOnceList",
	noRankPanel = "noRankPanel",
	["myRankPanel.txtScore"] = "myScore",
	["myRankPanel.txtRank"] = "myRanking",
	["rewardPanel.rewardItem"] = "rewardItem",
	["topPanel.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["leftPanel.tabItem.selected.txt"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 1,
						color = ui.NEWCOLORS.OUTLINE.YELLOW1
					}
				}
			}
		}
	},
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

						var_1_2:get("txt"):setFontSize(arg_1_3.fontSize)
					else
						var_1_1:hide()

						var_1_2 = var_1_0:show()
					end

					var_1_2:get("txt"):text(arg_1_3.name)
					var_1_2:get("txt"):getVirtualRenderer():setLineSpacing(-10)
					var_1_1:setTouchEnabled(false)
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
	["rankPanel.list"] = {
		varname = "rankList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 10,
				data = bindHelper.self("showData1"),
				item = bindHelper.self("rankItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("imgBg", "txtRank", "trainerIcon", "rankIcon", "txtName", "txtServer", "txtLv", "txtScore", "txtRecord")
					local var_2_1 = {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_2_3.logo,
							frameId = arg_2_3.frame,
							onNode = function(arg_3_0)
								arg_3_0:xy(104, 95):z(6):scale(0.9)
							end
						}
					}

					bind.extend(arg_2_0, var_2_0.trainerIcon, var_2_1)
					var_2_0.txtName:text(arg_2_3.name)
					var_2_0.txtServer:text(getServerArea(arg_2_3.game_key, true))
					adapt.oneLinePos(var_2_0.txtName, var_2_0.txtServer, cc.p(5, 0), "left")
					var_2_0.txtLv:text(math.max(var_0_1, tonumber(arg_2_3.level)))

					local var_2_2 = arg_2_2

					var_2_0.txtRank:visible(var_2_2 > 3)
					var_2_0.txtRank:text(var_2_2)
					var_2_0.rankIcon:visible(var_2_2 < 4)

					if var_2_2 <= 3 then
						var_2_0.imgBg:texture("city/pvp/cross_craft/rank/box_phb" .. var_2_2 .. ".png")
						var_2_0.rankIcon:texture("city/pvp/cross_craft/icon_" .. var_2_2 .. ".png")
					end

					var_2_0.imgBg:setTouchEnabled(true)
					var_2_0.txtScore:text(arg_2_3.point)
					var_2_0.txtRecord:text(string.format(gLanguageCsv.winAndLoseNum, arg_2_3.win, math.min(arg_2_3.round, var_0_2) - arg_2_3.win))
				end
			}
		}
	},
	["rewardPanel.list"] = {
		varname = "rewardList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 10,
				padding = 10,
				data = bindHelper.self("showData2"),
				item = bindHelper.self("rewardItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:multiget("imgBg", "rankIcon", "itemList")
					local var_4_1 = arg_4_2

					if var_4_1 <= 3 then
						var_4_0.imgBg:texture("city/pvp/cross_craft/rank/box_phb" .. var_4_1 .. ".png")
						var_4_0.rankIcon:texture("city/pvp/cross_craft/icon_" .. var_4_1 .. ".png")
					else
						local var_4_2 = csv.cross.craft.rank
						local var_4_3 = var_4_2[var_4_1 - 1].rankMax + 1
						local var_4_4 = var_4_2[var_4_1].rankMax
						local var_4_5 = var_4_3 < var_4_4 and var_4_3 .. "-" .. var_4_4 or var_4_4

						bind.extend(arg_4_0, arg_4_1, {
							class = "text_atlas",
							props = {
								isEqualDist = false,
								pathName = "cross_craft",
								align = "left",
								data = var_4_5,
								onNode = function(arg_5_0)
									arg_5_0:x(var_4_0.rankIcon:x() - 50)
									arg_5_0:y(var_4_0.rankIcon:y())

									if var_4_3 > 1000 then
										arg_5_0:scale(0.8)
									end
								end
							}
						})
						var_4_0.rankIcon:hide()
					end

					uiEasy.createItemsToList(arg_4_0, var_4_0.itemList, arg_4_3.cfg.award, {
						margin = 11,
						scale = 0.9
					})
				end
			}
		}
	}
}

function var_0_4.onCreate(arg_6_0, arg_6_1)
	arg_6_0:initModel()

	arg_6_0.showData1 = idlers.newWithMap(arg_6_1.rank or {})

	local var_6_0 = {}

	for iter_6_0, iter_6_1 in orderCsvPairs(csv.cross.craft.rank) do
		if iter_6_1.version == arg_6_0.version then
			table.insert(var_6_0, {
				cfg = iter_6_1
			})
		end
	end

	arg_6_0.showData2 = idlers.newWithMap(var_6_0)

	uiEasy.createItemsToList(arg_6_0, arg_6_0.winOnceList, csv.cross.craft.base[1].winAward, {
		margin = 11,
		scale = 0.9
	})
	uiEasy.createItemsToList(arg_6_0, arg_6_0.loseOnceList, csv.cross.craft.base[1].failAward, {
		margin = 11,
		scale = 0.9
	})
	arg_6_0.myName:text(arg_6_0.roleName:read())

	if arg_6_1.myinfo then
		arg_6_0.myScore:text(arg_6_1.myinfo.point)
		arg_6_0.myRecord:text(string.format(gLanguageCsv.winAndLoseNum, arg_6_1.myinfo.win, math.min(arg_6_1.myinfo.round, var_0_2) - arg_6_1.myinfo.win))
		arg_6_0.myRanking:text(arg_6_1.myinfo.rank and arg_6_1.myinfo.rank > 0 and arg_6_1.myinfo.rank or gLanguageCsv.craftNoRank)
		arg_6_0.myRanking:setFontSize(arg_6_1.myinfo.rank and arg_6_1.myinfo.rank > 0 and 70 or 50)
	else
		arg_6_0.myScore:text("0")
		arg_6_0.myRecord:text(string.format(gLanguageCsv.winAndLoseNum, 0, 0))
		arg_6_0.myRanking:text(gLanguageCsv.craftNoRank)
	end

	arg_6_0.tabDatas = idlers.newWithMap({
		{
			fontSize = 50,
			type = "rank",
			name = gLanguageCsv.rankList
		},
		{
			fontSize = 43,
			name = gLanguageCsv.craftRankReward
		}
	})

	for iter_6_2, iter_6_3 in ipairs(var_0_0) do
		arg_6_0[iter_6_3]:visible(false)
	end

	arg_6_0.showTab = idler.new(1)

	arg_6_0.rankPanel:visible(true)
	arg_6_0.showTab:addListener(function(arg_7_0, arg_7_1)
		arg_6_0[var_0_0[arg_7_1]]:visible(false)
		arg_6_0[var_0_0[arg_7_0]]:visible(true)
		arg_6_0.myRankPanel:visible(arg_7_0 ~= 2)
		arg_6_0.noRankPanel:visible(false)

		if #arg_6_1.rank == 0 and arg_7_0 == 1 then
			arg_6_0[var_0_0[arg_7_0]]:visible(false)
			arg_6_0.myRankPanel:visible(false)
			arg_6_0.noRankPanel:visible(true)

			if arg_6_0.round:read() == "prepare" or arg_6_0.round:read() == "pre1" or arg_6_0.round:read() == "pre1_lock" then
				arg_6_0.noRankTxt:text(gLanguageCsv.craftRankGaming)
			end
		end

		arg_6_0.tabDatas:atproxy(arg_7_1).select = false
		arg_6_0.tabDatas:atproxy(arg_7_0).select = true
	end)
	Dialog.onCreate(arg_6_0)
end

function var_0_4.initModel(arg_8_0)
	local var_8_0 = gGameModel.daily_record
	local var_8_1 = gGameModel.cross_craft

	arg_8_0.round = var_8_1:getIdler("round")
	arg_8_0.roleName = gGameModel.role:getIdler("name")
	arg_8_0.id = gGameModel.role:read("id")
	arg_8_0.version = var_8_1:read("version")
end

function var_0_4.onTabClick(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0.showTab:set(arg_9_2)
end

return var_0_4
