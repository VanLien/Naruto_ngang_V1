local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("AutoFishingView", var_0_0)

var_0_1.RESOURCE_FILENAME = "fishing_auto.json"
var_0_1.RESOURCE_BINDING = {
	btnCancel = "btnCancel",
	fish = "autoFish",
	["award.item"] = "awardItem",
	btnFinish = "btnFinish",
	["fish.item"] = "fishItem",
	["fish.list"] = {
		varname = "fishList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("autoFishCfg"),
				item = bindHelper.self("fishItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					bind.extend(arg_1_0, arg_1_1, {
						event = "extend",
						class = "fish_icon",
						props = {
							onNodeClick = true,
							data = {
								key = arg_1_2,
								num = arg_1_3
							},
							onNode = function(arg_2_0)
								arg_2_0:xy(10, 10)
							end
						}
					})
				end
			}
		}
	},
	["award.list"] = {
		varname = "awardList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("autoAwardCfg"),
				item = bindHelper.self("awardItem"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					if arg_3_3.key == "id" then
						local var_3_0 = csv.cards[arg_3_3.val].unitID
						local var_3_1 = csv.cards[arg_3_3.val].star
						local var_3_2 = csv.unit[var_3_0].rarity

						bind.extend(arg_3_0, arg_3_1, {
							class = "card_icon",
							props = {
								unitId = var_3_0,
								rarity = var_3_2,
								star = var_3_1
							}
						})
						bind.touch(arg_3_0, arg_3_1, {
							methods = {
								ended = functools.partial(arg_3_0.itemClick, arg_3_1, arg_3_2, arg_3_3)
							}
						})
					else
						bind.extend(arg_3_0, arg_3_1, {
							class = "icon_key",
							props = {
								data = {
									key = arg_3_3.key,
									num = arg_3_3.val
								}
							}
						})
					end
				end
			},
			handlers = {
				itemClick = bindHelper.self("onitemClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:initModel()

	arg_4_0.autoFishCfg = idlertable.new({})
	arg_4_0.autoAwardCfg = idlers.newWithMap({})

	arg_4_0:enableSchedule()

	local var_4_0 = gCommonConfigCsv.fishingAutoDuration + 1

	arg_4_0:schedule(function()
		gGameApp:requestServer("/game/fishing/main")
	end, var_4_0, 0, 6)
	idlereasy.any({
		arg_4_0.autoStopped,
		arg_4_0.autoAward,
		arg_4_0.autoWinCounter,
		arg_4_0.autoFailCounter
	}, function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		local var_6_0 = {}

		arg_4_0.autoFish:get("txt2"):text(arg_6_3 + arg_6_4)
		arg_4_0.autoFish:get("txt4"):text(arg_6_3)
		arg_4_0.autoFish:get("txt6"):text(arg_6_4)
		adapt.oneLinePos(arg_4_0.autoFish:get("txt1"), {
			arg_4_0.autoFish:get("txt2"),
			arg_4_0.autoFish:get("txt3"),
			arg_4_0.autoFish:get("txt4"),
			arg_4_0.autoFish:get("txt5"),
			arg_4_0.autoFish:get("txt6"),
			arg_4_0.autoFish:get("txt7")
		}, cc.p(5, 0), "left")

		if arg_6_2.fish ~= nil then
			arg_4_0.autoFishCfg:set(arg_6_2.fish)
		end

		if arg_6_2.type1 then
			for iter_6_0, iter_6_1 in pairs(arg_6_2.type1) do
				table.insert(var_6_0, {
					key = iter_6_0,
					val = iter_6_1
				})
			end
		end

		if arg_6_2.type2 then
			for iter_6_2, iter_6_3 in pairs(arg_6_2.type2) do
				table.insert(var_6_0, {
					key = iter_6_2,
					val = iter_6_3
				})
			end
		end

		if arg_6_2.cards then
			for iter_6_4, iter_6_5 in pairs(arg_6_2.cards) do
				table.insert(var_6_0, {
					key = "id",
					val = iter_6_5.id
				})
			end
		end

		arg_4_0.autoAwardCfg:update(var_6_0)
	end)
	bind.touch(arg_4_0, arg_4_0.btnCancel, {
		methods = {
			ended = function()
				arg_4_0:enableSchedule():unSchedule(6)
				arg_4_0:onClose()
			end
		}
	})
	bind.touch(arg_4_0, arg_4_0.btnFinish, {
		methods = {
			ended = function()
				gGameApp:requestServer("/game/fishing/auto/end", function(arg_9_0)
					var_0_0.onClose(arg_4_0)

					if arg_4_2 then
						arg_4_2()
					end
				end)
			end
		}
	})
end

function var_0_1.onitemClick(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	gGameUI:showItemDetail(arg_10_2, {
		key = "card",
		num = arg_10_4.val
	})
end

function var_0_1.initModel(arg_11_0)
	arg_11_0.autoStopped = gGameModel.fishing:getIdler("auto_stopped")
	arg_11_0.autoAward = gGameModel.fishing:getIdler("auto_award")
	arg_11_0.autoWinCounter = gGameModel.fishing:getIdler("auto_win_counter")
	arg_11_0.autoFailCounter = gGameModel.fishing:getIdler("auto_fail_counter")
end

return var_0_1
