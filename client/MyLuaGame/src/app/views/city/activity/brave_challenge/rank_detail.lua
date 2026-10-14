local var_0_0 = 40
local var_0_1 = 50
local var_0_2 = class("BraveChallengeRankDetailView", cc.load("mvc").ViewBase)

var_0_2.RESOURCE_FILENAME = "activity_brave_challenge_rank_detail.json"
var_0_2.RESOURCE_BINDING = {
	baseNode = "baseNode",
	["baseNode.title1.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = cc.c4b(212, 86, 95, 255)
				}
			}
		}
	},
	["baseNode.title2.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = cc.c4b(212, 86, 95, 255)
				}
			}
		}
	}
}

function var_0_2.onCreate(arg_1_0, arg_1_1)
	arg_1_0.baseNode:get("list1"):setScrollBarEnabled(false)
	arg_1_0.baseNode:get("list2"):setScrollBarEnabled(false)

	local var_1_0 = arg_1_0.baseNode:get("item")

	local function var_1_1(arg_2_0, arg_2_1, arg_2_2)
		arg_2_0:removeAllChildren()

		for iter_2_0 = arg_2_1, arg_2_2 do
			local var_2_0 = var_1_0:clone()

			arg_2_0:pushBackCustomItem(var_2_0)

			local var_2_1 = arg_1_1.brave_challenge_rank_info.deployments[iter_2_0]

			if var_2_1 ~= 0 then
				local var_2_2 = csv.brave_challenge.cards[var_2_1]
				local var_2_3 = csv.cards[var_2_2.cardID]
				local var_2_4 = csv.unit[var_2_3.unitID]

				var_2_0:get("icon"):texture(var_2_4.iconSimple)
				var_2_0:show()
			else
				var_2_0:get("icon"):hide()
			end
		end
	end

	var_1_1(arg_1_0.baseNode:get("list1"), 1, 3)
	var_1_1(arg_1_0.baseNode:get("list2"), 4, 6)
end

return var_0_2
