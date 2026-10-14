local var_0_0 = require("app.views.city.adventure.fishing.tools")
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("FishingAwardView", var_0_1)

var_0_2.RESOURCE_FILENAME = "fishing_award.json"
var_0_2.RESOURCE_BINDING = {
	point = "point",
	award = "award",
	fishItem = "fishItem",
	list = "list",
	fishList = "fishList"
}

function var_0_2.onCreate(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0:initSkel()
	arg_1_0:initModel()
	arg_1_0.list:setScrollBarEnabled(false)
	arg_1_0.fishList:setScrollBarEnabled(false)

	local var_1_0 = 0

	if arg_1_2 == game.FISHING_GAME then
		for iter_1_0, iter_1_1 in pairs(arg_1_1.fish) do
			var_1_0 = var_1_0 + csv.fishing.fish[iter_1_0].point * iter_1_1
		end
	end

	arg_1_0.point:get("txt2"):text(arg_1_1.win + arg_1_1.fail)
	arg_1_0.point:get("txt4"):text(arg_1_1.win)
	arg_1_0.point:get("txt6"):text(arg_1_1.fail)
	arg_1_0.point:get("txt8"):text(var_1_0)
	adapt.oneLinePos(arg_1_0.point:get("txt1"), {
		arg_1_0.point:get("txt2"),
		arg_1_0.point:get("txt3"),
		arg_1_0.point:get("txt4"),
		arg_1_0.point:get("txt5"),
		arg_1_0.point:get("txt6"),
		arg_1_0.point:get("txt7"),
		arg_1_0.point:get("txt8"),
		arg_1_0.point:get("txt9")
	}, cc.p(5, 0), "left")
	idlereasy.any({
		arg_1_0.fishLevel,
		arg_1_0.fishCounter,
		arg_1_0.targetCounter
	}, function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		arg_1_0.point:get("lv"):text(string.format(gLanguageCsv.fishingLv, arg_2_1))

		local var_2_0, var_2_1 = var_0_0.getExp(arg_2_1, arg_2_2, arg_2_3)

		if arg_2_1 == table.length(csv.fishing.level) then
			arg_1_0.point:get("num1"):text("Max")
			arg_1_0.point:get("num2"):hide()
			arg_1_0.point:get("bar"):setPercent(100)
		else
			arg_1_0.point:get("num1"):text(var_2_0)
			arg_1_0.point:get("num2"):text("/" .. var_2_1)
			arg_1_0.point:get("bar"):setPercent(cc.clampf(100 * (var_2_0 / var_2_1), 0, 100))
		end

		adapt.oneLinePos(arg_1_0.point:get("lv"), arg_1_0.point:get("barBg"), cc.p(15, 0), "left")
		adapt.oneLinePos(arg_1_0.point:get("lv"), arg_1_0.point:get("bar"), cc.p(15, 0), "left")
		adapt.oneLinePos(arg_1_0.point:get("bar"), arg_1_0.point:get("num1"), cc.p(15, 0), "left")
		adapt.oneLinePos(arg_1_0.point:get("num1"), arg_1_0.point:get("num2"), cc.p(0, 0), "left")
	end)
	arg_1_0.point:removeFromParent()
	arg_1_0.list:pushBackCustomItem(arg_1_0.point)

	local var_1_1
	local var_1_2 = 1

	for iter_1_2, iter_1_3 in pairs(arg_1_1.fish) do
		if var_1_2 % 6 == 1 then
			var_1_1 = arg_1_0.fishList:clone()

			var_1_1:show()
			arg_1_0.list:pushBackCustomItem(var_1_1)
		end

		local var_1_3 = arg_1_0.fishItem:clone():show()

		bind.extend(arg_1_0, var_1_3, {
			class = "fish_icon",
			props = {
				onNodeClick = true,
				data = {
					key = iter_1_2,
					num = iter_1_3
				},
				onNode = function(arg_3_0)
					arg_3_0:xy(10, 10)
				end
			}
		})
		var_1_1:pushBackCustomItem(var_1_3)

		var_1_2 = var_1_2 + 1
	end

	arg_1_0.award:removeFromParent()
	arg_1_0.list:pushBackCustomItem(arg_1_0.award)

	local var_1_4
	local var_1_5 = {}

	for iter_1_4, iter_1_5 in pairs(arg_1_1.award) do
		if iter_1_4 == "cards" then
			for iter_1_6, iter_1_7 in pairs(arg_1_1.award.cards) do
				table.insert(var_1_5, {
					key = "id",
					val = iter_1_7.id
				})
			end
		elseif iter_1_4 ~= "cards" and iter_1_4 ~= "carddbIDs" and iter_1_4 ~= "card2mailL" then
			table.insert(var_1_5, {
				key = iter_1_4,
				val = iter_1_5
			})
		end
	end

	local var_1_6 = 1

	for iter_1_8, iter_1_9 in pairs(var_1_5) do
		if var_1_6 % 6 == 1 then
			var_1_4 = arg_1_0.fishList:clone()

			var_1_4:show()
			arg_1_0.list:pushBackCustomItem(var_1_4)
		end

		local var_1_7 = arg_1_0.fishItem:clone():show()

		if iter_1_9.key == "id" then
			local var_1_8 = csv.cards[iter_1_9.val].unitID
			local var_1_9 = csv.cards[iter_1_9.val].star
			local var_1_10 = csv.unit[var_1_8].rarity

			bind.extend(arg_1_0, var_1_7, {
				class = "card_icon",
				props = {
					unitId = var_1_8,
					rarity = var_1_10,
					star = var_1_9,
					onNodeClick = function(arg_4_0)
						arg_1_0:onitemClick(arg_4_0, iter_1_9.val)
					end
				}
			})
		else
			bind.extend(arg_1_0, var_1_7, {
				class = "icon_key",
				props = {
					data = {
						key = iter_1_9.key,
						num = iter_1_9.val
					}
				}
			})
		end

		var_1_4:pushBackCustomItem(var_1_7)

		var_1_6 = var_1_6 + 1
	end

	if arg_1_3 < arg_1_0.fishLevel:read() then
		gGameUI:stackUI("city.adventure.fishing.upgrade")
	end
end

function var_0_2.initSkel(arg_5_0)
	local var_5_0 = arg_5_0:getResourceNode()

	widget.addAnimationByKey(var_5_0, "effect/gongxihuode.skel", "gongxihuode", "effect", 10):anchorPoint(cc.p(0.5, 0.5)):xy(var_5_0:width() / 2, var_5_0:height() - 300):addPlay("effect_loop")
end

function var_0_2.initModel(arg_6_0)
	arg_6_0.fishLevel = gGameModel.fishing:getIdler("level")
	arg_6_0.fishCounter = gGameModel.fishing:getIdler("fish_counter")
	arg_6_0.targetCounter = gGameModel.fishing:getIdler("target_counter")
end

function var_0_2.onitemClick(arg_7_0, arg_7_1, arg_7_2)
	gGameUI:showItemDetail(arg_7_1, {
		key = "card",
		num = arg_7_2
	})
end

return var_0_2
