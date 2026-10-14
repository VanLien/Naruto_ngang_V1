local var_0_0 = class("RankView", Dialog)
local var_0_1 = {
	FINALMATCH = 2,
	PRELIMINARY = 1
}

var_0_0.RESOURCE_FILENAME = "cross_union_fight_rank.json"
var_0_0.RESOURCE_BINDING = {
	["bg.titleText"] = "title",
	preliminaryPanel = "preliminaryPanel",
	["bg.titleText.bg"] = "bg",
	["duckPanel.txt"] = "duckTxt",
	leftItem = "leftItem",
	finalMatchPanel = "finalMatchPanel",
	["finalMatchPanel.finalMatchItem"] = "finalMatchItem",
	["preliminaryPanel.item"] = "item",
	duckPanel = "duckPanel",
	["bg.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	leftList = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 15,
				data = bindHelper.self("btnsAttr"),
				item = bindHelper.self("leftItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("normal")
					local var_1_1 = arg_1_1:get("selected")
					local var_1_2

					if arg_1_3.select then
						var_1_0:hide()

						var_1_2 = var_1_1:show()

						var_1_2:get("txt"):setFontSize(50)
					else
						var_1_1:hide()

						var_1_2 = var_1_0:show()
					end

					var_1_2:get("txt"):getVirtualRenderer():setLineSpacing(-10)
					adapt.setAutoText(var_1_2:get("txt"), arg_1_3.name, 240)
					var_1_1:setTouchEnabled(false)
					bind.touch(arg_1_0, var_1_0, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onLeftButtonClick")
			}
		}
	},
	["preliminaryPanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 0,
				data = bindHelper.self("preData"),
				item = bindHelper.self("item"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("rankIcon", "unionIcon", "unionName", "serverKey", "winNum", "aliveCount", "point", "bg", "rankNum", "groupItem")

					if arg_2_3.group ~= nil then
						arg_2_1:height(98)
						var_2_0.groupItem:show()
						var_2_0.bg:color(cc.c3b(228, 224, 209))
						var_2_0.groupItem:get("txt"):text(string.format(gLanguageCsv.crossUnionFightTeam, arg_2_3.group))
						var_2_0.rankIcon:hide()
						var_2_0.unionIcon:hide()
						var_2_0.unionName:hide()
						var_2_0.serverKey:hide()
						var_2_0.winNum:hide()
						var_2_0.aliveCount:hide()
						var_2_0.point:hide()
						var_2_0.bg:hide()
						var_2_0.rankNum:hide()
					else
						arg_2_1:height(130)
						var_2_0.groupItem:hide()
						var_2_0.rankIcon:show()
						var_2_0.unionIcon:show()
						var_2_0.unionName:show()
						var_2_0.serverKey:show()
						var_2_0.winNum:show()
						var_2_0.aliveCount:show()
						var_2_0.point:show()
						var_2_0.bg:show()
						var_2_0.rankNum:show()

						if arg_2_3[1].rank % 2 == 0 then
							var_2_0.bg:show()
						else
							var_2_0.bg:hide()
						end

						var_2_0.unionName:text(arg_2_3.union_name)
						var_2_0.serverKey:text(getServerArea(arg_2_3.server_key, false))
						var_2_0.winNum:text(arg_2_3.win_num)
						var_2_0.aliveCount:text(arg_2_3.alive_count)
						var_2_0.point:text(arg_2_3.point)

						if arg_2_3[1].rank <= 3 then
							var_2_0.rankIcon:texture(ui.RANK_ICON[arg_2_3[1].rank])
						elseif arg_2_3[1].rank <= 10 then
							var_2_0.rankIcon:texture(ui.RANK_ICON[4])
							var_2_0.rankNum:text(4)
						else
							var_2_0.rankNum:text(4)
						end

						var_2_0.unionIcon:texture(csv.union.union_logo[arg_2_3.union_logo].icon)
					end
				end
			}
		}
	},
	["finalMatchPanel.finalMatchList"] = {
		varname = "finalMatchList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 20,
				data = bindHelper.self("topData"),
				item = bindHelper.self("finalMatchItem"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:multiget("rankIcon", "unionIcon", "unionName", "serverKey", "winNum", "aliveCount", "point", "bg", "rankNum")

					var_3_0.unionName:text(arg_3_3.union_name)
					var_3_0.serverKey:text(getServerArea(arg_3_3.server_key, false))
					var_3_0.winNum:text(arg_3_3.win_num)
					var_3_0.aliveCount:text(arg_3_3.alive_count)
					var_3_0.point:text(arg_3_3.point)

					if arg_3_2 <= 3 then
						var_3_0.rankIcon:texture(ui.RANK_ICON[arg_3_2])
					elseif arg_3_2 <= 10 then
						var_3_0.rankIcon:texture(ui.RANK_ICON[4])
						var_3_0.rankNum:text(arg_3_2)
					else
						var_3_0.rankIcon:hide()
						var_3_0.rankNum:text(arg_3_2)
					end

					var_3_0.unionIcon:texture(csv.union.union_logo[arg_3_3.union_logo].icon)
				end
			}
		}
	}
}

function var_0_0.onLeftButtonClick(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.leftButtonTab:set(arg_4_2)
end

function var_0_0.judgeClearData(arg_5_0, arg_5_1)
	if arg_5_0.status == "closed" and time.getNowDate().wday == 4 then
		arg_5_0.topData = {}
		arg_5_0.preData = {}

		arg_5_0.duckPanel:show()
		arg_5_0.title:hide()
		arg_5_0.duckTxt:text(gLanguageCsv.crossArenaNoRank)
	end

	if not arg_5_0.model.finish then
		if arg_5_0.status == "preOver" then
			arg_5_0.preData = {}

			arg_5_0.duckPanel:show()
			arg_5_0.duckTxt:text(gLanguageCsv.crossArenaNoRank)
		elseif arg_5_0.status == "topOver" then
			arg_5_0.topData = {}

			if arg_5_1 == 2 then
				arg_5_0.duckPanel:show()
			end

			arg_5_0.duckTxt:text(gLanguageCsv.crossArenaNoRank)
		end
	end
end

function var_0_0.onCreate(arg_6_0, arg_6_1, arg_6_2)
	Dialog.onCreate(arg_6_0)

	arg_6_0.model = arg_6_2

	arg_6_0.duckPanel:hide()
	arg_6_0.item:hide()
	arg_6_0.finalMatchItem:hide()
	arg_6_0.leftItem:hide()
	arg_6_0.preliminaryPanel:hide()
	arg_6_0.finalMatchPanel:hide()
	arg_6_0:initModel(arg_6_1)

	arg_6_0.panel = {
		{
			node = arg_6_0.preliminaryPanel,
			data = arg_6_0.preData
		},
		{
			node = arg_6_0.finalMatchPanel,
			data = arg_6_0.topData
		}
	}

	local var_6_0 = {
		{
			name = gLanguageCsv.preliminary
		},
		{
			name = gLanguageCsv.finalMatch
		}
	}

	arg_6_0.btnsAttr = idlers.newWithMap(var_6_0)
	arg_6_0.leftButtonTab = idler.new(1)

	arg_6_0.leftButtonTab:addListener(function(arg_7_0, arg_7_1)
		arg_6_0.btnsAttr:atproxy(arg_7_1).select = false
		arg_6_0.btnsAttr:atproxy(arg_7_0).select = true

		arg_6_0.panel[arg_7_1].node:hide()
		arg_6_0.panel[arg_7_0].node:show()
		arg_6_0.bg:visible(arg_7_0 == 1)
		arg_6_0.title:get("redLine"):visible(arg_7_0 == 1)

		local var_7_0 = itertools.isempty(arg_6_0.panel[arg_7_0].data)

		arg_6_0.duckPanel:visible(var_7_0)
		arg_6_0.title:visible(not var_7_0)
		arg_6_0.duckTxt:text(gLanguageCsv.crossArenaNoRank)
		arg_6_0:judgeClearData(arg_7_0)
	end)
end

function var_0_0.initModel(arg_8_0, arg_8_1)
	arg_8_0.status = gGameModel.cross_union_fight:read("status")

	local var_8_0 = {}
	local var_8_1 = 1

	if not itertools.isempty(arg_8_1.last_ranks) then
		for iter_8_0, iter_8_1 in pairs(arg_8_1.last_ranks) do
			if iter_8_0 < 5 then
				table.insert(var_8_0, {
					group = var_8_1
				})

				var_8_1 = var_8_1 + 1

				table.sort(iter_8_1, function(arg_9_0, arg_9_1)
					if arg_9_0.point > arg_9_1.point then
						return true
					elseif arg_9_0.point == arg_9_1.point then
						return arg_9_0.alive_count > arg_9_1.alive_count
					end

					return false
				end)

				for iter_8_2, iter_8_3 in ipairs(iter_8_1) do
					table.insert(iter_8_3, {
						rank = iter_8_2
					})
					table.insert(var_8_0, iter_8_3)
				end
			end
		end
	end

	if not itertools.isempty(arg_8_1.last_ranks[5]) then
		table.sort(arg_8_1.last_ranks[5], function(arg_10_0, arg_10_1)
			if arg_10_0.point > arg_10_1.point then
				return true
			elseif arg_10_0.point == arg_10_1.point then
				return arg_10_0.alive_count > arg_10_1.alive_count
			end

			return false
		end)
	end

	arg_8_0.preData = var_8_0
	arg_8_0.topData = arg_8_1.last_ranks[5] or {}
end

return var_0_0
