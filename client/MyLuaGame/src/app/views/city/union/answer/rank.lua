local function var_0_0(arg_1_0)
	return time.getCutDown(math.max(time.getTime() - arg_1_0, 0), nil, true).head_date_str .. gLanguageCsv.before
end

local var_0_1 = {
	8,
	6,
	7
}
local var_0_2 = class("UnionAnswerRankView", Dialog)

var_0_2.RESOURCE_FILENAME = "union_answer_rank.json"
var_0_2.RESOURCE_BINDING = {
	["leftPanel.tabItem"] = "tabItem",
	item = "item",
	down = "downPanel",
	leftPanel = "leftPanel",
	emptyPanel = "emptyPanel",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["title.textTitle1"] = {
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
	["title.textTitle2"] = {
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
	["leftPanel.tabList"] = {
		varname = "tabList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("tabItem"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:get("normal")
					local var_2_1 = arg_2_1:get("selected")
					local var_2_2

					if arg_2_3.select then
						var_2_0:hide()

						var_2_2 = var_2_1:show()

						var_2_2:get("txt"):setFontSize(arg_2_3.fontSize)
					else
						var_2_1:hide()

						var_2_2 = var_2_0:show()
					end

					var_2_2:get("txt"):getVirtualRenderer():setLineSpacing(-10)
					adapt.setAutoText(var_2_2:get("txt"), arg_2_3.name, 240)
					adapt.setTextScaleWithWidth(var_2_2:get("txt"), nil, 50)
					var_2_1:setTouchEnabled(false)
					bind.touch(arg_2_0, var_2_0, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
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
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 10,
				asyncPreload = 4,
				data = bindHelper.self("roleData"),
				item = bindHelper.self("item"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:multiget("imgIcon", "head", "textName", "textFightPoint", "textRank1", "textRank2", "server", "textName1")

					uiEasy.setRankIcon(arg_3_2, var_3_0.imgIcon, var_3_0.textRank1, var_3_0.textRank2)
					var_3_0.textName:text(arg_3_3.name)
					var_3_0.textName1:text(arg_3_3.name1)
					var_3_0.textFightPoint:text(arg_3_3.score)
					var_3_0.server:text(string.format(gLanguageCsv.brackets, getServerArea(arg_3_3.gameKey, true)))
					bind.extend(arg_3_0, var_3_0.head, {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_3_3.logo,
							frameId = arg_3_3.frame
						}
					})
				end
			},
			handlers = {}
		}
	},
	list1 = {
		varname = "list1",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 10,
				asyncPreload = 4,
				data = bindHelper.self("unionData"),
				item = bindHelper.self("item"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:multiget("imgIcon", "head", "textName", "textFightPoint", "textRank1", "textRank2", "server", "textName1")

					uiEasy.setRankIcon(arg_4_2, var_4_0.imgIcon, var_4_0.textRank1, var_4_0.textRank2)
					var_4_0.textName:text(arg_4_3.name)
					var_4_0.textFightPoint:text(arg_4_3.score)
					var_4_0.textName1:text(arg_4_3.name1)
					var_4_0.server:text(string.format(gLanguageCsv.brackets, getServerArea(arg_4_3.gameKey, true)))

					local var_4_1 = ccui.ImageView:create(csv.union.union_logo[arg_4_3.logo].icon):addTo(var_4_0.head):scale(2):xy(var_4_0.head:size().width / 2, var_4_0.head:size().height / 2)
				end
			},
			handlers = {}
		}
	},
	btn1 = {
		varname = "btn1",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_5_0)
					return arg_5_0:onBtn(1)
				end)
			}
		}
	},
	btn2 = {
		varname = "btn2",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_6_0)
					return arg_6_0:onBtn(2)
				end)
			}
		}
	},
	btn3 = {
		varname = "btn3",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_7_0)
					return arg_7_0:onBtn(3)
				end)
			}
		}
	}
}

function var_0_2.onCreate(arg_8_0, arg_8_1)
	arg_8_0:initModel()

	arg_8_0.showTab = idler.new(1)

	arg_8_0.list:setScrollBarEnabled(false)
	arg_8_0.list1:setScrollBarEnabled(false)

	arg_8_0.rankType = idler.new(1)

	local var_8_0 = arg_8_1.view

	arg_8_0.roleData = idlers.new({})
	arg_8_0.unionData = idlers.new({})
	arg_8_0.panel = {
		{
			node = arg_8_0.list1
		},
		{
			node = arg_8_0.list
		}
	}

	idlereasy.when(arg_8_0.rankType, function(arg_9_0, arg_9_1)
		arg_8_0.btn1:setBright(arg_9_1 == 1)
		arg_8_0.btn2:setBright(arg_9_1 == 2)
		arg_8_0.btn3:setBright(arg_9_1 == 3)
		text.addEffect(arg_8_0.btn1:get("txt"), {
			outline = {
				size = 4,
				color = arg_9_1 == 1 and ui.NEWCOLORS.OUTLINE.YELLOW or ui.NEWCOLORS.OUTLINE.BLUE
			}
		})
		text.addEffect(arg_8_0.btn2:get("txt"), {
			outline = {
				size = 4,
				color = arg_9_1 == 2 and ui.NEWCOLORS.OUTLINE.YELLOW or ui.NEWCOLORS.OUTLINE.BLUE
			}
		})
		text.addEffect(arg_8_0.btn3:get("txt"), {
			outline = {
				size = 4,
				color = arg_9_1 == 3 and ui.NEWCOLORS.OUTLINE.YELLOW or ui.NEWCOLORS.OUTLINE.BLUE
			}
		})

		local var_9_0 = {}
		local var_9_1 = {}

		if var_8_0[var_0_1[arg_9_1]] and var_8_0[var_0_1[arg_9_1]].role_ranks then
			for iter_9_0, iter_9_1 in ipairs(var_8_0[var_0_1[arg_9_1]].role_ranks) do
				table.insert(var_9_0, {
					logo = iter_9_1.logo,
					name = iter_9_1.name,
					score = iter_9_1.score,
					gameKey = iter_9_1.game_key,
					frame = iter_9_1.frame,
					name1 = iter_9_1.union_name
				})
			end
		end

		if var_8_0[var_0_1[arg_9_1]] and var_8_0[var_0_1[arg_9_1]].union_ranks then
			for iter_9_2, iter_9_3 in ipairs(var_8_0[var_0_1[arg_9_1]].union_ranks) do
				table.insert(var_9_1, {
					logo = iter_9_3.logo,
					name = iter_9_3.name,
					score = iter_9_3.score,
					gameKey = iter_9_3.game_key,
					name1 = iter_9_3.chairman
				})
			end
		end

		arg_8_0.roleData:update(var_9_0)
		arg_8_0.unionData:update(var_9_1)
	end)

	arg_8_0.tabDatas = idlers.newWithMap({
		{
			fontSize = 50,
			name = gLanguageCsv.unionRank
		},
		{
			fontSize = 50,
			name = gLanguageCsv.personalRank
		}
	})

	arg_8_0.showTab:addListener(function(arg_10_0, arg_10_1)
		arg_8_0.tabDatas:atproxy(arg_10_1).select = false
		arg_8_0.tabDatas:atproxy(arg_10_0).select = true

		arg_8_0.panel[arg_10_1].node:hide()
		arg_8_0.panel[arg_10_0].node:show()
	end)
	idlereasy.any({
		arg_8_0.rankType,
		arg_8_0.showTab
	}, function(arg_11_0, arg_11_1, arg_11_2)
		local var_11_0 = arg_8_0.downPanel:multiget("num", "textRank", "textName", "textName1", "server")
		local var_11_1 = {}

		if var_8_0[var_0_1[arg_11_1]] then
			if arg_11_2 == 2 then
				var_11_1 = var_8_0[var_0_1[arg_11_1]].my_rank

				var_11_0.textName:text(arg_8_0.roleId)
				var_11_0.textName1:text(arg_8_0.unionName)
				arg_8_0.emptyPanel:visible(itertools.isempty(var_8_0[var_0_1[arg_11_1]].role_ranks))
				arg_8_0.downPanel:visible(not itertools.isempty(var_8_0[var_0_1[arg_11_1]].role_ranks))
			else
				var_11_1 = var_8_0[var_0_1[arg_11_1]].my_union_rank

				var_11_0.textName:text(arg_8_0.unionName)
				var_11_0.textName1:text(arg_8_0.members[arg_8_0.chairmanId].name)
				arg_8_0.emptyPanel:visible(itertools.isempty(var_8_0[var_0_1[arg_11_1]].union_ranks))
				arg_8_0.downPanel:visible(not itertools.isempty(var_8_0[var_0_1[arg_11_1]].role_ranks))
			end

			if var_11_1.rank ~= 0 then
				var_11_0.textRank:text(var_11_1.rank)
			else
				var_11_0.textRank:text(gLanguageCsv.noRank)
			end

			var_11_0.num:text(var_11_1.score)
			var_11_0.server:text(string.format(gLanguageCsv.brackets, getServerArea(arg_8_0.gameKey, true)))
		else
			arg_8_0.downPanel:hide()
			arg_8_0.emptyPanel:show()
		end
	end)
	Dialog.onCreate(arg_8_0)
end

function var_0_2.initModel(arg_12_0)
	arg_12_0.unionName = gGameModel.union:read("name")
	arg_12_0.chairmanId = gGameModel.union:read("chairman_db_id")
	arg_12_0.members = gGameModel.union:read("members")
	arg_12_0.roleId = gGameModel.role:read("name")
	arg_12_0.gameKey = gGameModel.role:read("game_key")
end

function var_0_2.onBtn(arg_13_0, arg_13_1)
	arg_13_0.rankType:set(arg_13_1)
end

function var_0_2.onTabClick(arg_14_0, arg_14_1, arg_14_2)
	arg_14_0.showTab:set(arg_14_2)
end

return var_0_2
