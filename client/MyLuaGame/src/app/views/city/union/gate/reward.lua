local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("UnionGateRewardView", Dialog)

var_0_1.RESOURCE_FILENAME = "union_gate_reward.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
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
				asyncPreload = 3,
				data = bindHelper.self("rewardDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("title"):text(arg_1_3.id .. "-" .. arg_1_3.name)
					uiEasy.createItemsToList(arg_1_0, arg_1_1:get("list"), arg_1_3.rewards, {
						scale = 0.8
					})
					bind.touch(arg_1_0, arg_1_1:get("btn"), {
						methods = {
							ended = functools.partial(arg_1_0.itemClick, arg_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	btnTltle = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	},
	["item.btnTitle"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	},
	btn = {
		varname = "btn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRequest")
			}
		}
	}
}

function var_0_1.onCreate(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.cb = arg_2_2

	arg_2_0:initModel()

	arg_2_0.rewardDatas = idlers.new()

	idlereasy.when(arg_2_0.unionFbAward, function(arg_3_0, arg_3_1)
		local var_3_0 = {}
		local var_3_1 = dataEasy.getUnionFubenCurrentMonth()

		for iter_3_0, iter_3_1 in ipairs(arg_2_1) do
			local var_3_2 = arg_2_0.unionFuben[iter_3_0].first_time > 0
			local var_3_3 = arg_3_1[iter_3_0] and arg_3_1[iter_3_0][1] == var_3_1 and arg_3_1[iter_3_0][2] > 0

			if var_3_2 and not var_3_3 then
				local var_3_4 = {}
				local var_3_5 = csv.union.union_fuben[iter_3_0]
				local var_3_6 = arg_3_1[iter_3_0] and var_3_5.repeatAward or var_3_5.firstAward

				for iter_3_2, iter_3_3 in csvMapPairs(var_3_6) do
					table.insert(var_3_4, {
						key = iter_3_2,
						num = iter_3_3
					})
				end

				table.insert(var_3_0, {
					id = iter_3_0,
					rewards = var_3_4,
					name = var_3_5.name
				})
			end
		end

		table.sort(var_3_0, function(arg_4_0, arg_4_1)
			return arg_4_0.id < arg_4_1.id
		end)
		dataEasy.tryCallFunc(arg_2_0.list, "updatePreloadCenterIndex")
		arg_2_0.rewardDatas:update(var_3_0)
	end)
	Dialog.onCreate(arg_2_0)
end

function var_0_1.initModel(arg_5_0)
	arg_5_0.unionFbAward = gGameModel.role:getIdler("union_fb_award")
	arg_5_0.unionFuben = gGameModel.union_fuben:read("states")
end

function var_0_1.onItemClick(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = {
		false
	}

	gGameApp:requestServerCustom("/game/union/fuben/award"):params(arg_6_3.id):onResponse(function(arg_7_0)
		var_6_0[1] = true
	end):wait(var_6_0):doit(function(arg_8_0)
		if arg_6_0.rewardDatas:size() == 0 then
			arg_6_0:addCallbackOnExit(functools.partial(arg_6_0.cb, arg_8_0))
			var_0_0.onClose(arg_6_0)
		end

		gGameUI:showGainDisplay(arg_8_0)
	end)
end

function var_0_1.onRequest(arg_9_0)
	gGameApp:requestServer("/game/union/fuben/award", function(arg_10_0)
		arg_9_0:addCallbackOnExit(functools.partial(arg_9_0.cb, arg_10_0))
		var_0_0.onClose(arg_9_0)
	end)
end

return var_0_1
