local var_0_0 = class("UnionGateRankView", Dialog)

var_0_0.RESOURCE_FILENAME = "union_gate_rank.json"
var_0_0.RESOURCE_BINDING = {
	empty = "empty",
	item = "item",
	rottomPanel = "rottomPanel",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	title1 = {
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
	title2 = {
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
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("rankDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("iconRank", "textRank1", "textRank2", "logo", "textName", "level", "gate")

					var_1_0.logo:texture(arg_1_3.unionLogo)
					var_1_0.textName:text(arg_1_3.unionName)
					var_1_0.level:text(arg_1_3.unionLevel)
					var_1_0.gate:text(string.format(gLanguageCsv.howManyLevels, arg_1_3.gateNum))
					uiEasy.setRankIcon(arg_1_2, var_1_0.iconRank, var_1_0.textRank1, var_1_0.textRank2)
				end,
				onAfterBuild = function(arg_2_0)
					arg_2_0.afterBuild()
				end
			},
			handlers = {
				afterBuild = bindHelper.self("onAfterBuild")
			}
		}
	}
}

function var_0_0.onCreate(arg_3_0, arg_3_1)
	arg_3_0:initModel()
	arg_3_0.empty:hide()

	local var_3_0 = {}

	for iter_3_0, iter_3_1 in pairs(arg_3_1) do
		table.insert(var_3_0, {
			gateNum = iter_3_1[1],
			damage = iter_3_1[2],
			time = iter_3_1[3],
			unionName = iter_3_1[4],
			unionLogo = csv.union.union_logo[iter_3_1[5]].icon,
			unionLevel = iter_3_1[6],
			dbid = iter_3_0
		})
	end

	table.sort(var_3_0, function(arg_4_0, arg_4_1)
		if arg_4_0.gateNum ~= arg_4_1.gateNum then
			return arg_4_0.gateNum > arg_4_1.gateNum
		end

		if arg_4_0.damage ~= arg_4_1.damage then
			return arg_4_0.damage > arg_4_1.damage
		end

		return arg_4_0.time < arg_4_1.time
	end)

	arg_3_0.rankDatas = var_3_0

	local var_3_1 = arg_3_0.unionId:read()

	arg_3_0.rottomPanel:get("unionName"):text(arg_3_0.unionName)

	for iter_3_2, iter_3_3 in pairs(var_3_0) do
		if var_3_1 == iter_3_3.dbid then
			arg_3_0.rottomPanel:get("rank"):text(iter_3_2)
			arg_3_0.rottomPanel:get("unionName"):text(iter_3_3.unionName)
			arg_3_0.rottomPanel:get("gate"):text(string.format(gLanguageCsv.howManyLevels, iter_3_3.gateNum))
		end
	end

	Dialog.onCreate(arg_3_0)
end

function var_0_0.initModel(arg_5_0)
	local var_5_0 = gGameModel.union

	arg_5_0.unionId = var_5_0:getIdler("id")
	arg_5_0.unionName = var_5_0:read("name")
end

function var_0_0.onAfterBuild(arg_6_0)
	arg_6_0.empty:visible(itertools.isempty(arg_6_0.rankDatas))
end

return var_0_0
