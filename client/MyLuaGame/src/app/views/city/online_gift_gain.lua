local function var_0_0(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	return widget.addAnimationByKey(arg_1_0, "effect/jiesuanjiemian.skel", arg_1_1, arg_1_2, arg_1_3):xy(arg_1_0:width() / 2, arg_1_0:height() / 2)
end

local var_0_1 = class("OnlineGiftGainView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "online_gift_gain.json"
var_0_1.RESOURCE_BINDING = {
	["rewardPanel.list"] = "list",
	label = "label",
	item = "item",
	rewardPanel = "rewardPanel",
	bg = "bg"
}

function var_0_1.onCreate(arg_2_0, arg_2_1)
	audio.playEffectWithWeekBGM("zaixianlibao.mp3")

	local var_2_0 = arg_2_0:getResourceNode()

	widget.addAnimationByKey(var_2_0, "hupazaixianlibao/hupazaixianlibao.skel", "hupazaixianlibao", "effect", 1):anchorPoint(cc.p(0.5, 0.5)):scale(2):xy(var_2_0:width() / 2, var_2_0:height() / 2)
	performWithDelay(arg_2_0, function()
		arg_2_0.rewardPanel:setVisible(true)
		arg_2_0.label:setVisible(true)

		arg_2_0.data = dataEasy.mergeRawDate(arg_2_1)
		arg_2_0.intervalTime = 0.25

		arg_2_0.list:setScrollBarEnabled(false)

		local var_3_0 = arg_2_0.list:size()
		local var_3_1 = arg_2_0.item:size()
		local var_3_2 = #arg_2_0.data
		local var_3_3 = arg_2_0.list:getItemsMargin()
		local var_3_4 = arg_2_0.list:x() + (var_3_0.width - var_3_1.width * var_3_2 - (var_3_2 - 1) * var_3_3) / 2
		local var_3_5 = arg_2_0.list:y()

		arg_2_0.list:xy(var_3_4, var_3_5)
		arg_2_0:showItem(1)
	end, 1)
	performWithDelay(arg_2_0, function()
		arg_2_0.bg:onClick(functools.partial(arg_2_0.onClose, arg_2_0))
	end, 2)
end

function var_0_1.showItem(arg_5_0, arg_5_1)
	if arg_5_1 > #arg_5_0.data then
		return
	end

	local var_5_0 = arg_5_0.item:clone()

	var_5_0:show()

	local var_5_1 = arg_5_0.data[arg_5_1]
	local var_5_2 = var_5_1.key
	local var_5_3 = var_5_1.num
	local var_5_4 = {
		class = "icon_key",
		props = {
			data = {
				key = var_5_2,
				num = var_5_3
			},
			onNode = function(arg_6_0)
				arg_6_0:hide():z(3)
				transition.executeSequence(arg_6_0, true):delay(0.5):func(function()
					arg_6_0:show()
				end):done()
			end
		}
	}
	local var_5_5 = 1

	if var_5_2 ~= "card" then
		var_5_5 = dataEasy.getCfgByKey(var_5_2).quality
	end

	var_0_0(var_5_0, "djhd", "djhd" .. var_5_5, 4)
	var_0_0(var_5_0, "djhd_hou", "djhd_hou" .. var_5_5, 2)
	bind.extend(arg_5_0, var_5_0, var_5_4)
	arg_5_0.list:pushBackCustomItem(var_5_0)
	transition.executeSequence(arg_5_0.list, true):delay(arg_5_0.intervalTime):func(function()
		arg_5_0:showItem(arg_5_1 + 1)
	end):done()
end

return var_0_1
