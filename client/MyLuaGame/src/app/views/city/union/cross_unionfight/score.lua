local var_0_0 = class("ScoreView", Dialog)

var_0_0.RESOURCE_FILENAME = "cross_union_fight_score.json"
var_0_0.RESOURCE_BINDING = {
	noRank = "noRank",
	item = "item",
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("showData"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("rankIcon", "unionIcon", "unionName", "point", "bg", "bg1", "rankNum", "includeImg")

					var_1_0.unionName:text(arg_1_3.union_name)
					var_1_0.point:text(arg_1_3.point)

					if arg_1_2 <= 3 then
						var_1_0.rankIcon:texture(ui.RANK_ICON[arg_1_2])
					elseif arg_1_2 <= 10 then
						var_1_0.rankIcon:texture(ui.RANK_ICON[4])
						var_1_0.rankNum:text(arg_1_2)
					else
						var_1_0.rankIcon:hide()
						var_1_0.rankNum:text(arg_1_2)
						text.addEffect(var_1_0.rankNum, {
							color = ui.COLORS.NORMAL.DEFAULT
						})
					end

					var_1_0.bg:visible(arg_1_3.color == nil)
					var_1_0.bg1:visible(arg_1_3.color ~= nil)
					var_1_0.includeImg:visible(arg_1_3.include ~= nil)
					var_1_0.unionIcon:texture(csv.union.union_logo[arg_1_3.union_logo].icon)
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_2_0, arg_2_1)
	Dialog.onCreate(arg_2_0)
	arg_2_0.item:hide()

	arg_2_0.data = {}
	arg_2_0.showData = idlers.newWithMap({})

	local var_2_0 = arg_2_1.union_db_ids or {}
	local var_2_1 = gGameModel.role:read("union_db_id")
	local var_2_2
	local var_2_3 = {}

	for iter_2_0, iter_2_1 in ipairs(arg_2_1.rank) do
		table.insert(arg_2_0.data, iter_2_1)
	end

	if not itertools.isempty(arg_2_0.data) then
		for iter_2_2, iter_2_3 in ipairs(arg_2_0.data) do
			if var_2_1 == iter_2_3.union_db_id then
				var_2_2 = iter_2_2
			end

			for iter_2_4, iter_2_5 in pairs(var_2_0) do
				if iter_2_5 == iter_2_3.union_db_id then
					var_2_3[iter_2_2] = 1
				end
			end
		end

		arg_2_0.showData:update(arg_2_0.data)

		if var_2_2 then
			arg_2_0.showData:atproxy(var_2_2).color = 1
		end

		for iter_2_6, iter_2_7 in pairs(var_2_3) do
			arg_2_0.showData:atproxy(iter_2_6).include = 1
		end
	end

	if itertools.isempty(arg_2_1.rank) then
		arg_2_0.noRank:show()
	end
end

return var_0_0
