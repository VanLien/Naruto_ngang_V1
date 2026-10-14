local var_0_0 = 10

local function var_0_1(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1:multiget("imgRank", "txtRank", "head", "txtName", "txtLv", "txtLevel", "txtServer", "txtScore")

	var_1_0.txtName:text(arg_1_3.name)
	var_1_0.txtLevel:text(arg_1_3.level)
	adapt.oneLinePos(var_1_0.txtName, {
		var_1_0.txtLv,
		var_1_0.txtLevel
	}, {
		cc.p(20, 0),
		cc.p(0, 0)
	})
	var_1_0.txtServer:text(string.format(gLanguageCsv.brackets, getServerArea(arg_1_3.game_key, true)))
	var_1_0.txtScore:text(arg_1_3.score)
	bind.extend(arg_1_0, var_1_0.head, {
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

	if arg_1_2 <= 7 then
		var_1_0.imgRank:show():texture("city/pvp/online_fight/display/icon_dzjjc_" .. arg_1_2 .. ".png")
		var_1_0.txtRank:hide()
	else
		var_1_0.imgRank:hide()
		var_1_0.txtRank:show():text(arg_1_2)
	end
end

local var_0_2 = class("OnlineFightRankView", Dialog)

var_0_2.RESOURCE_FILENAME = "online_fight_rank.json"
var_0_2.RESOURCE_BINDING = {
	["leftPanel.tabItem"] = "tabItem",
	noRankPanel = "noRankPanel",
	item = "item",
	myRankPanel = "myRankPanel",
	["topPanel.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
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
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:get("normal")
					local var_3_1 = arg_3_1:get("selected")
					local var_3_2

					if arg_3_3.select then
						var_3_0:hide()

						var_3_2 = var_3_1:show()

						var_3_2:get("txt"):setFontSize(60)
					else
						var_3_1:hide()

						var_3_2 = var_3_0:show()

						var_3_2:get("txt"):setFontSize(50)
					end

					var_3_2:get("txt"):getVirtualRenderer():setLineSpacing(-5)
					adapt.setAutoMultiLine(var_3_2:get("txt"), arg_3_3.name)
					var_3_1:setTouchEnabled(false)
					bind.touch(arg_3_0, var_3_0, {
						methods = {
							ended = functools.partial(arg_3_0.clickCell, arg_3_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	list1 = {
		varname = "list1",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("data1"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = var_0_1,
				scrollState = bindHelper.self("scrollState"),
				onBeforeBuild = function(arg_4_0)
					arg_4_0.scrollState:set(false)
				end,
				onAfterBuild = function(arg_5_0)
					arg_5_0.scrollState:set(true)
				end
			}
		}
	},
	list2 = {
		varname = "list2",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("data2"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = var_0_1,
				scrollState = bindHelper.self("scrollState"),
				onBeforeBuild = function(arg_6_0)
					arg_6_0.scrollState:set(false)
				end,
				onAfterBuild = function(arg_7_0)
					arg_7_0.scrollState:set(true)
				end
			}
		}
	}
}

function var_0_2.onCreate(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0.myRankPanel:multiget("txtName", "txtLv", "txtLevel")

	var_8_0.txtName:text(gGameModel.role:read("name"))
	var_8_0.txtLevel:text(gGameModel.role:read("level"))
	adapt.oneLinePos(var_8_0.txtName, {
		var_8_0.txtLv,
		var_8_0.txtLevel
	}, {
		cc.p(10, 0),
		cc.p(0, 0)
	})

	arg_8_0.tabDatas = idlers.newWithMap({
		{
			name = gLanguageCsv.onlineFightUnlimited
		},
		{
			name = gLanguageCsv.onlineFightLimited
		}
	})
	arg_8_0.datas = {
		{
			offset = 0,
			rank = gGameModel.cross_online_fight:read("unlimited_rank"),
			score = gGameModel.cross_online_fight:read("unlimited_score"),
			data = {}
		},
		{
			offset = 0,
			rank = gGameModel.cross_online_fight:read("limited_rank"),
			score = gGameModel.cross_online_fight:read("limited_score"),
			data = {}
		}
	}

	for iter_8_0, iter_8_1 in ipairs(arg_8_0.datas) do
		arg_8_0["data" .. iter_8_0] = idlers.new()

		local var_8_1 = arg_8_0["list" .. iter_8_0]

		var_8_1:hide()

		local var_8_2 = var_8_1:getInnerContainer()

		var_8_1:onScroll(function(arg_9_0)
			if var_8_2:getPositionY() >= -10 and arg_8_0.scrollState:read() then
				arg_8_0:sendProtocol()
			end
		end)
	end

	arg_8_0.scrollState = idler.new(true)
	arg_8_0.showTab = idler.new(arg_8_1)

	arg_8_0:initData(arg_8_2)
	arg_8_0.showTab:addListener(function(arg_10_0, arg_10_1)
		arg_8_0.tabDatas:atproxy(arg_10_1).select = false
		arg_8_0.tabDatas:atproxy(arg_10_0).select = true

		arg_8_0["list" .. arg_10_1]:hide()
		arg_8_0["list" .. arg_10_0]:show()

		local var_10_0 = arg_8_0.datas[arg_10_0]
		local var_10_1 = arg_8_0.myRankPanel:multiget("txtRank", "txtScore")

		var_10_1.txtRank:text(var_10_0.rank ~= 0 and var_10_0.rank or gLanguageCsv.noRank)
		var_10_1.txtScore:text(var_10_0.score or "--")

		if var_10_0.offset == 0 then
			arg_8_0:sendProtocol()
		end
	end)
	Dialog.onCreate(arg_8_0)
end

function var_0_2.onTabClick(arg_11_0, arg_11_1, arg_11_2)
	arg_11_0.showTab:set(arg_11_2)
end

function var_0_2.sendProtocol(arg_12_0)
	local var_12_0 = arg_12_0.showTab:read()

	if arg_12_0.datas[var_12_0].isEnd or arg_12_0.isRequest then
		return
	end

	arg_12_0.isRequest = true

	gGameApp:requestServer("/game/cross/online/rank", function(arg_13_0)
		arg_12_0.isRequest = false

		arg_12_0:initData(arg_13_0.view.rank)
	end, var_12_0, arg_12_0.datas[var_12_0].offset, var_0_0)
end

function var_0_2.initData(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.showTab:read()

	arg_14_0.datas[var_14_0].data = arraytools.merge_inplace(arg_14_0.datas[var_14_0].data, {
		arg_14_1
	})

	local var_14_1 = arg_14_0.datas[var_14_0].offset

	arg_14_0.datas[var_14_0].offset = var_14_1 + #arg_14_1

	arg_14_0["data" .. var_14_0]:update(arg_14_0.datas[var_14_0].data)
	arg_14_0["list" .. var_14_0]:jumpToItem(var_14_1 - 3, cc.p(0, 1), cc.p(0, 1))

	if #arg_14_1 < var_0_0 then
		arg_14_0.datas[var_14_0].isEnd = true
	end

	arg_14_0.noRankPanel:visible(#arg_14_0.datas[var_14_0].data == 0)
end

return var_0_2
