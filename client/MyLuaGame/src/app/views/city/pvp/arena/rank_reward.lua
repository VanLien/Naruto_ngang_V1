local var_0_0 = class("ArenaRankRewardView", Dialog)

var_0_0.RESOURCE_FILENAME = "arena_rank_reward.json"
var_0_0.RESOURCE_BINDING = {
	textRank = "textRank",
	textNote = "textNote",
	item = "item",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["title.textTitle1"] = {
		varname = "textTitle1",
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
		varname = "textTitle2",
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
				margin = 12,
				asyncPreload = 4,
				data = bindHelper.self("rankDatas"),
				item = bindHelper.self("item"),
				dataOrderCmpGen = bindHelper.self("onSortCards", true),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("textRank", "textCost", "btnGet", "imgIcon", "list")

					var_1_0.textRank:text(arg_1_3.rank)

					local var_1_1

					if arg_1_3.pointNum ~= 0 then
						var_1_1 = arg_1_3.canReceive == 0 and gLanguageCsv.hasChange or gLanguageCsv.spaceExchange

						var_1_0.textCost:text(arg_1_3.pointNum)
						var_1_0.btnGet:y(arg_1_1:size().height / 3)
					else
						var_1_1 = arg_1_3.canReceive == 0 and gLanguageCsv.received or gLanguageCsv.spaceReceive

						var_1_0.btnGet:y(arg_1_1:size().height / 2)
						var_1_0.imgIcon:y(arg_1_1:size().height / 2)
						var_1_0.textCost:y(arg_1_1:size().height / 2)
						var_1_0.imgIcon:hide()
						var_1_0.textCost:hide()
					end

					if next(arg_1_3.award) ~= nil then
						uiEasy.createItemsToList(arg_1_0, var_1_0.list, arg_1_3.award, {
							scale = 0.9
						})
					end

					bind.touch(arg_1_0, var_1_0.btnGet, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3)
						}
					})

					local var_1_2 = arg_1_3.canReceive == 1 and arg_1_3.pointEnough
					local var_1_3 = arg_1_3.pointEnough and ui.COLORS.NORMAL.DEFAULT or cc.c4b(255, 76, 76, 255)

					text.addEffect(var_1_0.textCost, {
						color = var_1_3
					})
					var_1_0.btnGet:setTouchEnabled(var_1_2)
					cache.setShader(var_1_0.btnGet, false, var_1_2 and "normal" or "hsl_gray")
					var_1_0.btnGet:get("textNote"):text(var_1_1)

					if var_1_2 then
						text.addEffect(var_1_0.btnGet:get("textNote"), {
							outline = {
								size = 4,
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							}
						})
					else
						text.deleteAllEffect(var_1_0.btnGet:get("textNote"))
						text.addEffect(var_1_0.btnGet:get("textNote"), {
							color = ui.COLORS.DISABLED.WHITE
						})
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onitemClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_2_0)
	arg_2_0:initModel()

	arg_2_0.rankDatas = idlers.new()

	idlereasy.when(arg_2_0.rankAward, function(arg_3_0, arg_3_1)
		local var_3_0 = {}

		for iter_3_0, iter_3_1 in csvPairs(csv.pwrank_award) do
			local var_3_1, var_3_2 = csvNext(iter_3_1.cost)

			var_3_2 = var_3_2 or 0

			local var_3_3 = true

			if var_3_2 > 0 then
				var_3_3 = var_3_2 <= dataEasy.getNumByKey(var_3_1)
			end

			var_3_0[iter_3_0] = {
				id = iter_3_0,
				pointNum = var_3_2,
				pointEnough = var_3_3,
				award = iter_3_1.award,
				rank = iter_3_1.needRank,
				canReceive = arg_3_1[iter_3_0] or 0.5
			}
		end

		dataEasy.tryCallFunc(arg_2_0.list, "updatePreloadCenterIndex")
		arg_2_0.rankDatas:update(var_3_0)
	end)
	adapt.oneLinePos(arg_2_0.textTitle1, arg_2_0.textTitle2, nil, "left")
	idlereasy.when(arg_2_0.record, function(arg_4_0, arg_4_1)
		arg_2_0.textRank:text(arg_4_1.rank_top)
		adapt.oneLinePos(arg_2_0.textRank, arg_2_0.textNote, cc.p(8, 0), "right")
	end)
	Dialog.onCreate(arg_2_0)
end

function var_0_0.initModel(arg_5_0)
	arg_5_0.rankAward = gGameModel.role:getIdler("pw_rank_award")
	arg_5_0.record = gGameModel.arena:getIdler("record")
end

function var_0_0.onSortCards(arg_6_0, arg_6_1)
	return function(arg_7_0, arg_7_1)
		if arg_7_0.canReceive ~= arg_7_1.canReceive then
			return arg_7_0.canReceive > arg_7_1.canReceive
		end

		return arg_7_0.rank > arg_7_1.rank
	end
end

function var_0_0.onitemClick(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local function var_8_0()
		gGameApp:requestServer("/game/pw/battle/rank/award", function(arg_10_0)
			local var_10_0 = {}

			for iter_10_0, iter_10_1 in csvMapPairs(arg_8_3.award) do
				var_10_0[iter_10_0] = iter_10_1
			end

			gGameUI:showGainDisplay(var_10_0)
		end, arg_8_3.id)
	end

	if arg_8_3.pointNum > 0 then
		local var_8_1 = {
			isRich = true,
			btnType = 2,
			cb = var_8_0,
			content = string.format(gLanguageCsv.changeItems, arg_8_3.pointNum),
			dialogParams = {
				clickClose = false
			}
		}

		gGameUI:showDialog(var_8_1)

		return
	end

	var_8_0()
end

return var_0_0
