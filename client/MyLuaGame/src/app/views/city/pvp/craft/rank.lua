local var_0_0 = {
	"rankPanel",
	"rewardPanel"
}
local var_0_1 = csv.unlock[gUnlockCsv.craft].startLevel
local var_0_2 = cc.load("mvc").ViewBase
local var_0_3 = class("CraftRankView", Dialog)

var_0_3.RESOURCE_FILENAME = "craft_rank.json"
var_0_3.RESOURCE_BINDING = {
	["noRankPanel.txtNode"] = "noRankTxt",
	rewardPanel = "rewardPanel",
	["myRankPanel.txtScore"] = "myScore",
	["rewardPanel.winOnceList"] = "winOnceList",
	["myRankPanel.txtRecord"] = "myRecord",
	["rankPanel.rankItem"] = "rankItem",
	rankPanel = "rankPanel",
	["leftPanel.tabItem"] = "tabItem",
	["myRankPanel.txtName"] = "myName",
	["rewardPanel.loseOnceList"] = "loseOnceList",
	noRankPanel = "noRankPanel",
	myRankPanel = "myRankPanel",
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
	["topPanel.title"] = {
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
	["topPanel.subTitle"] = {
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
	["leftPanel.tabItem.selected.txt"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 3,
						color = ui.NEWCOLORS.OUTLINE.WHITE
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

						local var_1_3 = var_1_1:show()

						var_1_3:get("txt"):setFontSize(arg_1_3.fontSize)
						adapt.setAutoMultiLine(var_1_3:get("txt"), arg_1_3.name, 240, -10)
					else
						var_1_1:hide()

						local var_1_4 = var_1_0:show()

						adapt.setAutoMultiLine(var_1_4:get("txt"), arg_1_3.name, 240, 0)
					end

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
					local var_2_0 = arg_2_3.role
					local var_2_1 = arg_2_1:multiget("imgBg", "txtRank", "trainerIcon", "rankIcon", "txtName", "txtLv", "txtScore", "txtRecord")
					local var_2_2 = {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = var_2_0.logo,
							frameId = var_2_0.frame,
							onNode = function(arg_3_0)
								arg_3_0:xy(104, 95):z(6):scale(0.9)
							end
						}
					}

					bind.extend(arg_2_0, var_2_1.trainerIcon, var_2_2)
					var_2_1.txtName:text(var_2_0.name)
					var_2_1.txtLv:text(math.max(var_0_1, tonumber(var_2_0.level)))

					local var_2_3 = arg_2_2

					var_2_1.txtRank:visible(var_2_3 > 3)
					var_2_1.txtRank:text(var_2_3)
					var_2_1.rankIcon:visible(var_2_3 < 4)

					if var_2_3 <= 3 then
						var_2_1.imgBg:texture("city/pvp/craft/dialog_icon/iten_" .. var_2_3 .. ".png")
						var_2_1.rankIcon:texture("city/pvp/craft/img_xz" .. var_2_3 .. ".png")
					end

					var_2_1.imgBg:setTouchEnabled(true)
					var_2_1.imgBg:onClick(functools.partial(arg_2_0.clickHead, arg_2_2, var_2_0, var_2_3))
					var_2_1.txtScore:text(arg_2_3.craft.point)
					var_2_1.txtRecord:text(string.format(gLanguageCsv.winAndLoseNum, arg_2_3.craft.win, math.min(arg_2_3.craft.round, 13) - arg_2_3.craft.win))
				end
			},
			handlers = {
				clickHead = bindHelper.self("onHeadClick")
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
				data = bindHelper.self("showData2"),
				item = bindHelper.self("rewardItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:multiget("imgBg", "rankIcon", "itemList")
					local var_4_1 = arg_4_3.cfg.rankMax

					if var_4_1 <= 3 then
						var_4_0.imgBg:texture("city/pvp/craft/dialog_icon/iten_" .. var_4_1 .. ".png")
						var_4_0.rankIcon:texture("city/pvp/craft/img_xz" .. var_4_1 .. ".png")
					else
						local var_4_2 = csv.craft.rank
						local var_4_3 = var_4_2[arg_4_3.csvId - 1].rankMax + 1
						local var_4_4 = var_4_2[arg_4_3.csvId].rankMax
						local var_4_5 = var_4_3 < var_4_4 and var_4_3 .. "-" .. var_4_4 or var_4_4

						bind.extend(arg_4_0, arg_4_1, {
							class = "text_atlas",
							props = {
								isEqualDist = false,
								pathName = "craft",
								align = "center",
								data = var_4_5,
								onNode = function(arg_5_0)
									arg_5_0:xy(var_4_0.rankIcon:x(), var_4_0.rankIcon:y())
								end
							}
						})
						var_4_0.rankIcon:hide()
					end

					uiEasy.createItemsToList(arg_4_0, var_4_0.itemList, arg_4_3.award, {
						margin = 11,
						scale = 0.8
					})
				end
			}
		}
	}
}

function var_0_3.onCreate(arg_6_0, arg_6_1)
	arg_6_0:initModel()

	arg_6_0.datas = {}

	for iter_6_0 = 1, #var_0_0 do
		arg_6_0.datas[iter_6_0] = iter_6_0 == 1 and arg_6_1.rank or {}

		if iter_6_0 == 2 then
			local var_6_0 = getVersionContainMerge("pwAwardVer")

			for iter_6_1, iter_6_2 in orderCsvPairs(csv.craft.rank) do
				if iter_6_2.version == var_6_0 then
					table.insert(arg_6_0.datas[iter_6_0], {
						csvId = iter_6_1,
						cfg = iter_6_2,
						award = arg_6_0:getAwardBylevel(iter_6_2.award)
					})
				end
			end
		end

		arg_6_0["showData" .. iter_6_0] = idlers.newWithMap(arg_6_0.datas[iter_6_0])
	end

	uiEasy.createItemsToList(arg_6_0, arg_6_0.winOnceList, arg_6_0:getAwardBylevel(csv.craft.base[1].winAward), {
		margin = 11,
		scale = 0.8
	})
	uiEasy.createItemsToList(arg_6_0, arg_6_0.loseOnceList, arg_6_0:getAwardBylevel(csv.craft.base[1].failAward), {
		margin = 11,
		scale = 0.8
	})
	arg_6_0.myRanking:text(arg_6_0.craftRank:read() and arg_6_0.craftRank:read() > 0 and arg_6_0.craftRank:read() or gLanguageCsv.craftNoRank)
	arg_6_0.myRanking:setFontSize(arg_6_0.craftRank:read() and arg_6_0.craftRank:read() > 0 and 55 or 50)
	arg_6_0.myName:text(arg_6_0.roleName:read())

	if arg_6_1.craft then
		arg_6_0.myScore:text(arg_6_1.craft.point)
		arg_6_0.myRecord:text(string.format(gLanguageCsv.winAndLoseNum, arg_6_1.craft.win, math.min(arg_6_1.craft.round, 13) - arg_6_1.craft.win))
	else
		arg_6_0.myScore:text("0")
		arg_6_0.myRecord:text(string.format(gLanguageCsv.winAndLoseNum, 0, 0))
	end

	arg_6_0.tabDatas = idlers.newWithMap({
		{
			fontSize = 22,
			type = "rank",
			name = gLanguageCsv.rankList
		},
		{
			fontSize = 20,
			name = gLanguageCsv.craftRankReward
		}
	})

	for iter_6_3, iter_6_4 in ipairs(var_0_0) do
		arg_6_0[iter_6_4]:visible(false)
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

function var_0_3.initModel(arg_8_0)
	local var_8_0 = gGameModel.daily_record

	arg_8_0.round = gGameModel.craft:getIdler("round")
	arg_8_0.roleName = gGameModel.role:getIdler("name")
	arg_8_0.craftRank = var_8_0:getIdler("craft_rank")
	arg_8_0.id = gGameModel.role:read("id")
	arg_8_0.level = gGameModel.role:read("level")
end

function var_0_3.onTabClick(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0.showTab:set(arg_9_2)
end

function var_0_3.onHeadClick(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	if arg_10_0.id == arg_10_3.id then
		return
	end

	local var_10_0 = arg_10_5.target
	local var_10_1, var_10_2 = var_10_0:xy()
	local var_10_3 = var_10_0:getParent():convertToWorldSpace(cc.p(var_10_1, var_10_2))

	gGameUI:stackUI("city.chat.personal_info", nil, nil, var_10_3, {
		role = arg_10_3
	}, {
		speical = "rank",
		target = arg_10_1.item:get("imgBg")
	})
end

function var_0_3.getAwardBylevel(arg_11_0, arg_11_1)
	local var_11_0 = {}

	for iter_11_0, iter_11_1 in csvPairs(arg_11_1) do
		if arg_11_0.level >= iter_11_1[1] and arg_11_0.level <= iter_11_1[2] then
			var_11_0 = iter_11_1[3]

			break
		end
	end

	return var_11_0
end

return var_0_3
