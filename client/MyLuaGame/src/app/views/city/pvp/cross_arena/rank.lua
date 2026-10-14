local var_0_0 = class("CrossArenaRankView", Dialog)

local function var_0_1(arg_1_0)
	local var_1_0 = gGameModel.cross_arena:read("csvID")
	local var_1_1 = csv.cross.service[var_1_0]
	local var_1_2 = var_1_1 and var_1_1.version or nil
	local var_1_3 = {}
	local var_1_4 = dataEasy.getCrossArenaStageByRank(1)

	for iter_1_0, iter_1_1 in orderCsvPairs(csv.cross.arena.stage) do
		if iter_1_1.version == var_1_2 then
			var_1_3[iter_1_1.stageID] = {
				rank = iter_1_1.range[1],
				stage = iter_1_1.stageName
			}
		end
	end

	table.insert(var_1_3, {
		rank = 4,
		stage = var_1_4.stageName
	})

	for iter_1_2, iter_1_3 in ipairs(var_1_3) do
		if arg_1_0 ~= 1 and arg_1_0 == iter_1_3.rank then
			return iter_1_3.stage
		end
	end

	return 0
end

var_0_0.RESOURCE_FILENAME = "cross_arena_rank.json"
var_0_0.RESOURCE_BINDING = {
	topBgPanel = "topBgPanel",
	["topPanel.downbg.top3"] = "top3",
	topPanel = "topPanel",
	["topPanel.downbg.top1"] = "top1",
	rankPanel = "rankPanel",
	["rankPanel.rankItem"] = "rankItem",
	["myRankPanel.txtScore"] = "myScore",
	["myRankPanel.txtName"] = "myName",
	["topPanel.downbg"] = "downbg",
	["myRankPanel.txtState"] = "myState",
	["myRankPanel.txtRank"] = "myRank",
	noRankPanel = "noRankPanel",
	myRankPanel = "myRankPanel",
	["topPanel.downbg.top2"] = "top2",
	["topBgPanel.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["topPanel.panel1"] = {
		binds = {
			event = "touch",
			varname = "panel1",
			methods = {
				ended = bindHelper.defer(function(arg_2_0)
					return arg_2_0:topClick(1)
				end)
			}
		}
	},
	["topPanel.stageIcon1"] = {
		binds = {
			event = "extend",
			class = "stage_icon",
			props = {
				showStage = false,
				showStageBg = false,
				rank = 1,
				onNode = function(arg_3_0)
					arg_3_0:xy(80, 40):z(6):scale(1)
				end
			}
		}
	},
	["topPanel.stageIcon2"] = {
		binds = {
			event = "extend",
			class = "stage_icon",
			props = {
				showStage = false,
				showStageBg = false,
				rank = 2,
				onNode = function(arg_4_0)
					arg_4_0:xy(80, 40):z(6):scale(1)
				end
			}
		}
	},
	["topPanel.stageIcon3"] = {
		binds = {
			event = "extend",
			class = "stage_icon",
			props = {
				showStage = false,
				showStageBg = false,
				rank = 3,
				onNode = function(arg_5_0)
					arg_5_0:xy(80, 40):z(6):scale(1)
				end
			}
		}
	},
	["topPanel.panel2"] = {
		binds = {
			event = "touch",
			varname = "panel2",
			methods = {
				ended = bindHelper.defer(function(arg_6_0)
					return arg_6_0:topClick(2)
				end)
			}
		}
	},
	["topPanel.panel3"] = {
		binds = {
			event = "touch",
			varname = "panel3",
			methods = {
				ended = bindHelper.defer(function(arg_7_0)
					return arg_7_0:topClick(3)
				end)
			}
		}
	},
	["rankPanel.list"] = {
		varname = "rankList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("showData"),
				item = bindHelper.self("rankItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					local var_8_0 = arg_8_1:multiget("title", "down")

					bind.extend(arg_8_0, var_8_0.down:get("trainerIcon"), {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_8_3.logo,
							frameId = arg_8_3.frame,
							onNode = function(arg_9_0)
								arg_9_0:xy(30, 85):z(6):scale(0.8)
							end
						}
					})
					bind.extend(arg_8_0, var_8_0.down:get("rankIcon"), {
						event = "extend",
						class = "stage_icon",
						props = {
							showStage = false,
							showStageBg = false,
							rank = arg_8_3.rank,
							onNode = function(arg_10_0)
								arg_10_0:xy(100, 60):z(6):scale(1)
							end
						}
					})
					var_8_0.title:hide()
					var_8_0.down:get("imgVip"):hide()
					var_8_0.down:get("txtName"):text(arg_8_3.name)
					var_8_0.down:get("txtLv"):text(arg_8_3.level)
					var_8_0.down:get("txtServer"):text(string.format(gLanguageCsv.brackets, getServerArea(arg_8_3.game_key, true)))
					var_8_0.down:get("txtRecord"):text(arg_8_3.fighting_point)
					adapt.oneLinePos(var_8_0.down:get("txtNode"), {
						var_8_0.down:get("txtLv"),
						var_8_0.down:get("txtServer")
					}, cc.p(5, 0), "left")

					local var_8_1 = dataEasy.getCrossArenaStageByRank(arg_8_3.rank)

					var_8_0.down:get("txtRank"):text(var_8_1.rank)

					local var_8_2 = var_0_1(arg_8_3.rank)

					if var_8_2 ~= 0 then
						var_8_0.title:show()
						var_8_0.title:get("txtRank"):text(var_8_2)
						arg_8_1:height(271)
					else
						arg_8_1:height(200)
					end

					arg_8_1:setTouchEnabled(true)
					bind.touch(arg_8_0, var_8_0.down, {
						methods = {
							ended = functools.partial(arg_8_0.clickCell, arg_8_1, arg_8_3)
						}
					})
				end,
				scrollState = bindHelper.self("scrollState"),
				onBeforeBuild = function(arg_11_0)
					arg_11_0.scrollState:set(false)
				end,
				onAfterBuild = function(arg_12_0)
					arg_12_0.scrollState:set(true)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_13_0, arg_13_1)
	arg_13_0.topPanel:show()
	arg_13_0.rankPanel:show()
	arg_13_0.myRankPanel:show()
	arg_13_0.noRankPanel:hide()

	arg_13_0.title = {}

	local var_13_0 = arg_13_1.rank.myinfo

	if var_13_0 ~= nil then
		local var_13_1 = dataEasy.getCrossArenaStageByRank(var_13_0.rank)

		arg_13_0.myState:text(var_13_1.stageName)
		arg_13_0.myScore:text(var_13_0.fighting_point)
		arg_13_0.myName:text(var_13_0.name)
		arg_13_0.myRank:text(var_13_1.rank)
	else
		arg_13_0.myScore:hide()
		arg_13_0.myState:hide()
		arg_13_0.myRank:hide()
		arg_13_0.myName:text(gLanguageCsv.crossArenaNoRank):x(858)
	end

	arg_13_0.data = arg_13_1.rank.ranks or {}

	if itertools.isempty(arg_13_0.data) then
		arg_13_0.topPanel:hide()
		arg_13_0.rankPanel:hide()
		arg_13_0.noRankPanel:show()
	else
		local var_13_2 = {}

		for iter_13_0, iter_13_1 in ipairs(arg_13_0.data) do
			table.insert(var_13_2, {
				cfg = iter_13_1
			})
		end

		for iter_13_2 = 1, 3 do
			table.remove(arg_13_0.data, 1)
		end

		arg_13_0.showData = idlers.newWithMap(arg_13_0.data)
		arg_13_0.topData = var_13_2

		local var_13_3 = {
			arg_13_0.topPanel:get("panel1"),
			arg_13_0.topPanel:get("panel2"),
			arg_13_0.topPanel:get("panel3")
		}
		local var_13_4 = gRoleFigureCsv

		for iter_13_3 = 1, 3 do
			local var_13_5 = nodetools.multiget(arg_13_0["top" .. iter_13_3], "txt", "damage", "name", "vip", "attack")

			var_13_3[iter_13_3]:xy(var_13_3[iter_13_3]:x() + var_13_4[var_13_2[iter_13_3].cfg.figure].crossArenaPos.x, var_13_3[iter_13_3]:y() + var_13_4[var_13_2[iter_13_3].cfg.figure].crossArenaPos.y)
			bind.extend(arg_13_0, var_13_3[iter_13_3], {
				class = "role_figure",
				props = {
					spine = true,
					data = var_13_2[iter_13_3].cfg.figure,
					onSpine = function(arg_14_0)
						arg_14_0:scale(0.55):xy(125, 0)
					end
				}
			})
			var_13_5.txt:text(string.format(gLanguageCsv.brackets, getServerArea(var_13_2[iter_13_3].cfg.game_key, true)))
			var_13_5.damage:text(var_13_2[iter_13_3].cfg.fighting_point)
			var_13_5.name:text(var_13_2[iter_13_3].cfg.name)
			var_13_5.vip:hide()
			text.addEffect(var_13_5.txt, {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			})
			text.addEffect(var_13_5.name, {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			})
			text.addEffect(var_13_5.damage, {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.WHITE1
				}
			})
			adapt.oneLineCenterPos(cc.p(250, 80), {
				var_13_5.txt,
				var_13_5.name,
				var_13_5.vip
			}, cc.p(15, 0))
		end
	end

	arg_13_0.scrollState = idler.new(true)
	arg_13_0.isCanDown = #arg_13_0.data == 7

	local var_13_6 = arg_13_0.rankList:getInnerContainer()

	arg_13_0.rankList:onScroll(function(arg_15_0)
		if var_13_6:getPositionY() == 0 and arg_13_0.scrollState:read() and arg_13_0.isCanDown then
			local var_15_0 = #arg_13_0.data

			arg_13_0.isCanDown = false

			gGameApp:requestServer("/game/cross/arena/rank", function(arg_16_0)
				if tolua.isnull(arg_13_0) then
					return
				end

				for iter_16_0, iter_16_1 in ipairs(arg_16_0.view.rank.ranks) do
					table.insert(arg_13_0.data, iter_16_1)
				end

				arg_13_0.isCanDown = #arg_16_0.view.rank.ranks == 10

				arg_13_0.showData:update(arg_13_0.data)
				arg_13_0.rankList:jumpToItem(var_15_0 - 3, cc.p(0, 1), cc.p(0, 1))
			end, var_15_0 + 3, 10)
		end
	end)
	Dialog.onCreate(arg_13_0)
end

function var_0_0.topClick(arg_17_0, arg_17_1)
	gGameApp:requestServer("/game/cross/arena/role/info", function(arg_18_0)
		gGameUI:stackUI("city.pvp.cross_arena.personal_info", nil, {
			blackLayer = true,
			clickClose = true
		}, arg_18_0.view)
	end, arg_17_0.topData[arg_17_1].cfg.record_db_id, arg_17_0.topData[arg_17_1].cfg.game_key, arg_17_0.topData[arg_17_1].cfg.rank)
end

function var_0_0.onItemClick(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	gGameApp:requestServer("/game/cross/arena/role/info", function(arg_20_0)
		gGameUI:stackUI("city.pvp.cross_arena.personal_info", nil, {
			blackLayer = true,
			clickClose = true
		}, arg_20_0.view)
	end, arg_19_3.record_db_id, arg_19_3.game_key, arg_19_3.rank)
end

return var_0_0
