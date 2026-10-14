local var_0_0 = class("BetResultView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "cross_union_fight_bet_result.json"
var_0_0.RESOURCE_BINDING = {
	winPanel = "winPanel",
	losePanel = "losePanel",
	["winPanel.item"] = "item",
	["losePanel.txt"] = "loseTxt",
	["winPanel.list"] = "list",
	["losePanel.list"] = "loseList",
	["winPanel.unionItem"] = "unionItem",
	["winPanel.imgBG"] = "imgBG",
	["winPanel.imgText"] = "imgText",
	["winPanel.unionList"] = {
		varname = "unionList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("unionData"),
				item = bindHelper.self("unionItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("icon", "name")

					var_1_0.name:text(arg_1_3.union_name)
					var_1_0.icon:texture(csv.union.union_logo[arg_1_3.union_logo].icon)
				end,
				onAfterBuild = function(arg_2_0)
					arg_2_0:setItemAlignCenter()
				end
			}
		}
	}
}
var_0_0.RESOURCE_STYLES = {
	clickClose = true,
	blackLayer = true
}

function var_0_0.onCreate(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_2 and arg_3_1[5] or arg_3_1

	arg_3_0.loseList:setScrollBarEnabled(false)

	local var_3_1 = arg_3_0:getResourceNode()

	arg_3_0.allBetSuccess = false

	local var_3_2 = {}
	local var_3_3 = {}

	if arg_3_2 ~= 5 then
		for iter_3_0, iter_3_1 in pairs(var_3_0) do
			if iter_3_1.success then
				var_3_2[iter_3_0] = iter_3_1
				var_3_3[iter_3_0] = csv.cross.union_fight.base[1].preBetWinAward
			else
				var_3_3[iter_3_0] = csv.cross.union_fight.base[1].preBetFailAward
			end
		end
	else
		if var_3_0.success then
			var_3_2[arg_3_2] = var_3_0
			var_3_3[arg_3_2] = csv.cross.union_fight.base[1].top4BetWinAward
		else
			var_3_3[arg_3_2] = csv.cross.union_fight.base[1].top4BetFailAward
		end

		local var_3_4 = 0

		for iter_3_2, iter_3_3 in pairs(arg_3_1) do
			if iter_3_3.success then
				var_3_4 = var_3_4 + 1
			end
		end

		if var_3_4 == 5 then
			arg_3_0.allBetSuccess = true
			var_3_3[6] = csv.cross.union_fight.base[1].extraAward
		end
	end

	local var_3_5 = {}

	for iter_3_4, iter_3_5 in pairs(var_3_3) do
		for iter_3_6, iter_3_7 in csvMapPairs(iter_3_5) do
			var_3_5[iter_3_6] = var_3_5[iter_3_6] and var_3_5[iter_3_6] + iter_3_7 or iter_3_7
		end
	end

	arg_3_0.awardData = {}

	for iter_3_8, iter_3_9 in pairs(var_3_5) do
		table.insert(arg_3_0.awardData, {
			key = iter_3_8,
			val = iter_3_9
		})
	end

	if itertools.size(var_3_2) == 0 then
		arg_3_0.winPanel:hide()
		arg_3_0.losePanel:show()

		if arg_3_2 <= 4 then
			arg_3_0.loseTxt:text(gLanguageCsv.losePreBet)
		else
			arg_3_0.loseTxt:text(gLanguageCsv.loseFinalBet)
		end

		arg_3_0:initAward(arg_3_0.loseList)
	else
		arg_3_0.winPanel:show()
		arg_3_0.losePanel:hide()
		arg_3_0.imgText:visible(arg_3_2 < 5)
		widget.addAnimation(var_3_1, "kuafushiying/jccg.skel", "effect_loop", 10):anchorPoint(cc.p(0.5, 0.5)):xy(var_3_1:width() / 2, var_3_1:height() - 280):scale(2)
		arg_3_0:initAward(arg_3_0.list)
		arg_3_0.imgText:show()
	end

	arg_3_0.unionData = idlers.newWithMap(var_3_2)
end

function var_0_0.initAward(arg_4_0, arg_4_1)
	bind.extend(arg_4_0, arg_4_1, {
		class = "listview",
		props = {
			data = arg_4_0.awardData,
			item = arg_4_0.item,
			margin = itertools.size(arg_4_0.awardData) > 4 and 0 or 80,
			onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				bind.extend(arg_5_0, arg_5_1, {
					class = "icon_key",
					props = {
						data = {
							key = arg_5_3.key,
							num = arg_5_3.val
						},
						onNode = function(arg_6_0)
							arg_6_0:y(160)

							local var_6_0 = dataEasy.getCfgByKey(arg_5_3.key).name

							adapt.setTextScaleWithWidth(arg_5_1:get("txtName"), var_6_0, arg_6_0:width() + 80)
						end
					}
				})
			end,
			onAfterBuild = function(arg_7_0)
				arg_7_0:setItemAlignCenter()
			end
		}
	})
	arg_4_0.list:setScrollBarEnabled(false)
end

return var_0_0
