local function var_0_0(arg_1_0)
	return time.getCutDown(math.max(time.getTime() - arg_1_0, 0), nil, true).head_date_str .. gLanguageCsv.before
end

local var_0_1 = class("CrossUnionFightRecordView", Dialog)

var_0_1.RESOURCE_FILENAME = "cross_union_fight_record.json"
var_0_1.RESOURCE_BINDING = {
	["goodPanel.slider"] = "slider",
	["emptyPanel.emptyTxt"] = "emptyTxt",
	leftPanel = "leftPanel",
	["goodPanel.item"] = "item1",
	emptyPanel = "emptyPanel",
	["leftPanel.tabItem"] = "tabItem",
	goodPanel = "goodPanel",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
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
					else
						var_2_1:hide()

						var_2_2 = var_2_0:show()
					end

					var_2_2:get("txt"):getVirtualRenderer():setLineSpacing(-10)
					var_2_2:get("txt"):text(arg_2_3.name)
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
	["goodPanel.list"] = {
		varname = "list1",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				data = bindHelper.self("battleData"),
				item = bindHelper.self("item1"),
				dataOrderCmp = function(arg_3_0, arg_3_1)
					return arg_3_0.idx > arg_3_1.idx
				end,
				itemAction = {
					isAction = true
				},
				sliderBg = bindHelper.self("slider"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:get("tips")
					local var_4_1 = arg_4_1:get("dataPlane")

					arg_4_1:size(cc.size(1600, 265))

					if arg_4_3.type == "title" then
						arg_4_1:size(cc.size(1600, 100))
						var_4_0:xy(800, 50)
						var_4_1:hide()
						var_4_0:show()
						var_4_0:get("txt"):text(string.format(gLanguageCsv.roundBattle, arg_4_3.round))
					else
						local var_4_2 = var_4_1:multiget("head1", "btnReplay", "head2", "txtTop", "txtTop1", "txtLvNode", "txtLvNode1", "txtLv", "txtLv1", "imgFlag", "imgFlag1", "imgBG", "textName", "textName1", "teams", "teams1", "textServe", "textServe1", "empty", "empty1")

						for iter_4_0, iter_4_1 in pairs(var_4_2) do
							iter_4_1:show()
						end

						local var_4_3 = arg_4_3.left

						if itertools.isempty(var_4_3.userData) or var_4_3.troop == 0 then
							itertools.invoke({
								var_4_2.imgFlag,
								var_4_2.imgFlag1,
								var_4_2.head1,
								var_4_2.textName,
								var_4_2.txtTop,
								var_4_2.txtLvNode,
								var_4_2.txtLv,
								var_4_2.teams,
								var_4_2.btnReplay,
								var_4_2.textServe
							}, "hide")
						else
							var_4_2.empty:hide()
							bind.extend(arg_4_0, var_4_2.head1, {
								event = "extend",
								class = "role_logo",
								props = {
									vip = false,
									level = false,
									logoId = var_4_3.userData.role_logo,
									frameId = var_4_3.userData.role_frame
								}
							})
							var_4_2.textName:text(var_4_3.userData.role_name)
							var_4_2.txtTop:text(var_4_3.union_name)
							var_4_2.txtLv:text(var_4_3.userData.role_level)
							var_4_2.teams:text(gLanguageCsv.team .. gLanguageCsv["symbolNumber" .. var_4_3.troop])
						end

						local var_4_4 = arg_4_3.right

						if itertools.isempty(var_4_3.userData) or var_4_4.troop == 0 then
							itertools.invoke({
								var_4_2.imgFlag,
								var_4_2.imgFlag1,
								var_4_2.head2,
								var_4_2.textName1,
								var_4_2.txtTop1,
								var_4_2.txtLvNode1,
								var_4_2.txtLv1,
								var_4_2.teams1,
								var_4_2.btnReplay,
								var_4_2.textServe1
							}, "hide")
						else
							var_4_2.empty1:hide()
							bind.extend(arg_4_0, var_4_2.head2, {
								event = "extend",
								class = "role_logo",
								props = {
									vip = false,
									level = false,
									logoId = var_4_4.userData.role_logo,
									frameId = var_4_4.userData.role_frame
								}
							})
							var_4_2.textName1:text(var_4_4.userData.role_name)
							var_4_2.txtTop1:text(var_4_4.union_name)
							var_4_2.txtLv1:text(var_4_4.userData.role_level)
							var_4_2.teams1:text(gLanguageCsv.team .. gLanguageCsv["symbolNumber" .. var_4_3.troop])
						end

						if arg_4_3.result == "win" then
							var_4_2.imgBG:texture("city/pvp/cross_arena/list_bg_1.png")
							var_4_2.imgFlag:texture("city/pvp/craft/icon_win.png")
							var_4_2.imgFlag1:texture("city/pvp/craft/icon_lose.png")
						else
							var_4_2.imgBG:texture("city/pvp/cross_arena/list_bg_2.png")
							var_4_2.imgFlag1:texture("city/pvp/craft/icon_win.png")
							var_4_2.imgFlag:texture("city/pvp/craft/icon_lose.png")
						end

						text.addEffect(var_4_2.txtLv, {
							outline = {
								color = ui.COLORS.OUTLINE.DEFAULT
							}
						})
						text.addEffect(var_4_2.txtLv1, {
							outline = {
								color = ui.COLORS.OUTLINE.DEFAULT
							}
						})
						text.addEffect(var_4_2.txtLvNode, {
							outline = {
								color = ui.COLORS.OUTLINE.DEFAULT
							}
						})
						text.addEffect(var_4_2.txtLvNode1, {
							outline = {
								color = ui.COLORS.OUTLINE.DEFAULT
							}
						})
						bind.touch(arg_4_0, var_4_2.btnReplay, {
							methods = {
								ended = functools.partial(arg_4_0.playbackBtn, arg_4_2, arg_4_3)
							}
						})
					end
				end,
				onBeforeBuild = function(arg_5_0)
					if arg_5_0.sliderBg:visible() then
						local var_5_0, var_5_1 = arg_5_0:xy()
						local var_5_2 = arg_5_0:size()
						local var_5_3, var_5_4 = arg_5_0.sliderBg:xy()
						local var_5_5 = arg_5_0.sliderBg:size()

						arg_5_0:setScrollBarEnabled(true)
						arg_5_0:setScrollBarColor(cc.c3b(245, 156, 2))
						arg_5_0:setScrollBarOpacity(255)
						arg_5_0:setScrollBarAutoHideEnabled(false)
						arg_5_0:setScrollBarPositionFromCorner(cc.p(var_5_0 + var_5_2.width - var_5_3, (var_5_2.height - var_5_5.height) / 2 + 15))
						arg_5_0:setScrollBarWidth(var_5_5.width)
						arg_5_0:refreshView()
					else
						arg_5_0:setScrollBarEnabled(false)
					end
				end
			},
			handlers = {
				playbackBtn = bindHelper.self("onPlaybackClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_0:initModel()

	arg_6_0.showTab = idler.new(1)
	arg_6_0.unionId = arg_6_3
	arg_6_0.allData = arg_6_1[arg_6_2] or {}
	arg_6_0.battleData = idlers.new()
	arg_6_0.tabDatas = idlers.newWithMap({
		{
			fontSize = 50,
			name = gLanguageCsv.crossUnionFightEmbattle1
		},
		{
			fontSize = 50,
			name = gLanguageCsv.crossUnionFightEmbattle2
		},
		{
			fontSize = 50,
			name = gLanguageCsv.crossUnionFightEmbattle3
		}
	})

	arg_6_0.showTab:addListener(function(arg_7_0, arg_7_1)
		arg_6_0.tabDatas:atproxy(arg_7_1).select = false
		arg_6_0.tabDatas:atproxy(arg_7_0).select = true

		if itertools.isempty(arg_6_0.allData[arg_7_0]) then
			arg_6_0.emptyPanel:show()
			arg_6_0.goodPanel:hide()
		else
			arg_6_0.emptyPanel:hide()
			arg_6_0.goodPanel:show()
		end

		arg_6_0.battleData:update(arg_6_0:getUserInfoDataTable(arg_6_0.allData[arg_7_0]))
	end)
	Dialog.onCreate(arg_6_0)
end

function var_0_1.getUserInfoDataTable(arg_8_0, arg_8_1)
	local var_8_0 = {}
	local var_8_1 = 1
	local var_8_2 = 1

	for iter_8_0, iter_8_1 in pairs(arg_8_1 or {}) do
		local var_8_3 = table.shallowcopy(iter_8_1)

		if var_8_3.round ~= var_8_1 then
			table.insert(var_8_0, {
				type = "title",
				round = var_8_1,
				idx = var_8_2
			})

			var_8_2 = var_8_2 + 1
			var_8_1 = var_8_3.round
		end

		var_8_3.left.userData = arg_8_0.userInfo[var_8_3.left.role_db_id] or {}
		var_8_3.right.userData = arg_8_0.userInfo[var_8_3.right.role_db_id] or {}

		if arg_8_0.unionId and var_8_3.right.union_db_id == arg_8_0.unionId then
			var_8_3.left, var_8_3.right = var_8_3.right, var_8_3.left

			if var_8_3.result == "win" then
				var_8_3.result = "fail"
			else
				var_8_3.result = "win"
			end
		end

		var_8_3.idx = var_8_2

		table.insert(var_8_0, var_8_3)

		var_8_2 = var_8_2 + 1
	end

	table.insert(var_8_0, {
		type = "title",
		round = var_8_1,
		idx = var_8_2
	})
	arg_8_0.slider:setVisible(#var_8_0 > 6)

	return var_8_0
end

function var_0_1.initModel(arg_9_0)
	arg_9_0.userInfo = gGameModel.cross_union_fight:read("roles")
end

function var_0_1.onPlaybackClick(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = "/game/cross/union/fight/playrecord/get"

	gGameModel:playRecordBattle(arg_10_3.play_id, arg_10_3.cross_key, var_10_0, 0, nil)
end

function var_0_1.oninfoClick(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	return
end

function var_0_1.onItemClick(arg_12_0, arg_12_1, arg_12_2)
	return
end

function var_0_1.onTabClick(arg_13_0, arg_13_1, arg_13_2)
	arg_13_0.showTab:set(arg_13_2)
end

return var_0_1
