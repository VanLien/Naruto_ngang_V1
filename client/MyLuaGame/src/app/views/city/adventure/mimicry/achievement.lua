local var_0_0 = {
	CAN_NOT_GOTTEN = 0,
	CAN_GOTTEN = 1,
	GOTTEN = 2
}
local var_0_1 = class("MimicryAhievementView", Dialog)

var_0_1.RESOURCE_FILENAME = "mimicry_achievement.json"
var_0_1.RESOURCE_BINDING = {
	rankItem = "rankItem",
	rewardPanel1 = "rewardPanel1",
	["topPanel.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["rewardPanel1.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("achvDatas"),
				item = bindHelper.self("rankItem"),
				value = bindHelper.self("value"),
				dataOrderCmpGen = bindHelper.self("onSortCards", true),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_3.cfg
					local var_1_1 = arg_1_1:multiget("achvDesc", "btnGet", "list", "got")

					var_1_1.achvDesc:text(var_1_0.mimicryAchievement)

					if next(var_1_0.award) ~= nil then
						uiEasy.createItemsToList(arg_1_0, var_1_1.list, var_1_0.award, {
							scale = 0.8
						})
					end

					var_1_1.list:setScrollBarEnabled(false)
					bind.touch(arg_1_0, var_1_1.btnGet, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_3.csvId, arg_1_3.get)
						}
					})
					var_1_1.got:visible(arg_1_3.get == var_0_0.GOTTEN)
					var_1_1.btnGet:visible(arg_1_3.get ~= var_0_0.GOTTEN)
					print(".....", arg_1_3.csvId)
					print(".....", var_1_0.targetArg2)
					print(".....", arg_1_0.value[arg_1_3.csvId])

					local var_1_2 = arg_1_0.value[arg_1_3.csvId] or 0

					if var_1_2 < var_1_0.targetArg2 then
						var_1_1.btnGet:get("txt"):text(var_1_2 .. "/" .. var_1_0.targetArg2)
					else
						var_1_1.btnGet:get("txt"):text(gLanguageCsv.spaceReceive)
					end

					uiEasy.setBtnShader(var_1_1.btnGet, var_1_1.btnGet:get("txt"), arg_1_3.get == 1 and 1 or 2)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onGetBtn")
			}
		}
	},
	btnBattle = {
		varname = "btnBattle",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onGetAllAwardBtn")
			}
		}
	}
}

function var_0_1.onCreate(arg_2_0, arg_2_1)
	arg_2_0.initModel(arg_2_0)

	arg_2_0.achvDatas = idlers.new()

	idlereasy.when(arg_2_0.state, function(arg_3_0, arg_3_1)
		local var_3_0 = {}
		local var_3_1 = 2

		for iter_3_0, iter_3_1 in orderCsvPairs(csv.mimicry.tasks) do
			if iter_3_1.version == arg_2_1 then
				table.insert(var_3_0, {
					cfg = iter_3_1,
					csvId = iter_3_0,
					get = arg_3_1[iter_3_0]
				})

				if arg_3_1[iter_3_0] == var_0_0.CAN_GOTTEN then
					var_3_1 = 1
				end
			end
		end

		uiEasy.setBtnShader(arg_2_0.btnBattle, nil, var_3_1)
		arg_2_0.achvDatas:update(var_3_0)
	end)
	Dialog.onCreate(arg_2_0)
end

function var_0_1.initModel(arg_4_0)
	arg_4_0.value = gGameModel.mimicry:read("achievement_value")
	arg_4_0.state = gGameModel.mimicry:getIdler("achievement_state")
end

function var_0_1.onGetBtn(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if arg_5_3 == var_0_0.CAN_GOTTEN then
		gGameApp:requestServer("/game/mimicry/award", function(arg_6_0)
			gGameUI:showGainDisplay(arg_6_0)
		end, arg_5_2)
	end
end

function var_0_1.onGetAllAwardBtn(arg_7_0)
	gGameApp:requestServer("/game/mimicry/award/onekey", function(arg_8_0)
		gGameUI:showGainDisplay(arg_8_0)
	end)
end

function var_0_1.onSortCards(arg_9_0, arg_9_1)
	return function(arg_10_0, arg_10_1)
		local var_10_0 = arg_10_0.get or 0.5
		local var_10_1 = arg_10_1.get or 0.5

		if var_10_0 ~= var_10_1 then
			return var_10_1 < var_10_0
		end

		return arg_10_0.csvId < arg_10_1.csvId
	end
end

return var_0_1
