local var_0_0 = class("BattleEndPvpRewardView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "battle_end_reward.json"
var_0_0.RESOURCE_BINDING = {
	title = "title",
	tipText = "tipText",
	awardsList = "awardsList",
	textContinue = "textContinue",
	awardItem = "awardItem",
	blackBg = {
		varname = "blackBg",
		binds = {
			event = "click",
			method = bindHelper.self("onCloseClick")
		}
	}
}

function var_0_0.playEffect(arg_1_0)
	local var_1_0 = arg_1_0:getResourceNode()

	arg_1_0.selEffect = CSprite.new("effect/gongxihuode.skel")

	arg_1_0.selEffect:addTo(var_1_0, 100)
	arg_1_0.selEffect:setAnchorPoint(cc.p(0.5, 1))

	local var_1_1, var_1_2 = arg_1_0.title:xy()

	arg_1_0.selEffect:xy(var_1_1, var_1_2)
	arg_1_0.selEffect:visible(true)
	arg_1_0.selEffect:play(arg_1_0.isFail and "zhandoujiangli2" or "zhandoujiangli")
	arg_1_0.selEffect:addPlay(arg_1_0.isFail and "zhandoujiangli2_loop" or "zhandoujiangli_loop")
end

function var_0_0.onCreate(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_2.serverData.view

	arg_2_2.showReward = false
	arg_2_0.showEndView = arg_2_1
	arg_2_0.isFail = arg_2_2.result ~= "win"

	arg_2_0:playEffect()
	arg_2_0.awardsList:setScrollBarEnabled(false)

	if next(var_2_0.award) ~= nil then
		local var_2_1 = {}

		for iter_2_0, iter_2_1 in pairs(var_2_0.award) do
			table.insert(var_2_1, {
				key = iter_2_0,
				num = iter_2_1
			})
		end

		local var_2_2 = #var_2_1

		if var_2_2 <= 5 then
			local var_2_3 = arg_2_0.awardsList:x() + (arg_2_0.awardsList:width() - arg_2_0.awardItem:width() * var_2_2) / 2

			arg_2_0.awardsList:x(var_2_3)
		end

		arg_2_0:showItem(1, var_2_1)
	end

	arg_2_0.textContinue:text(gLanguageCsv.click2Continue)
	rich.createByStr(string.format(gLanguageCsv.canReciveAwardTime, arg_2_2.awardRemainTime), 44):anchorPoint(0.5, 0.5):xy(arg_2_0.tipText:x(), arg_2_0.tipText:y()):addTo(arg_2_0:getResourceNode()):z(10)

	if arg_2_2.from == "ban_embattle" then
		ccui.ImageView:create("battle/scene/bg_dzjjc.png"):scale(2):xy(display.sizeInView.width / 2, display.sizeInView.height / 2):addTo(arg_2_0:getResourceNode(), 0)
	end
end

function var_0_0.showItem(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0.awardItem:clone()

	var_3_0:show()

	local var_3_1 = var_3_0:size()
	local var_3_2 = arg_3_2[arg_3_1].key
	local var_3_3 = arg_3_2[arg_3_1].num
	local var_3_4 = dataEasy.getCfgByKey(var_3_2)
	local var_3_5 = {
		class = "icon_key",
		props = {
			effect = "gain",
			data = {
				key = var_3_2,
				num = var_3_3
			},
			onNode = function(arg_4_0)
				arg_4_0:xy(var_3_1.width / 2, var_3_1.height / 2 + 20)
				arg_4_0:hide():z(2)
				transition.executeSequence(arg_4_0, true):delay(0.5):func(function()
					arg_4_0:show()
				end):done()
			end
		}
	}
	local var_3_6, var_3_7 = uiEasy.setIconName(var_3_2, var_3_3)

	beauty.singleTextLimitWord(var_3_6, {
		fontSize = 40
	}, {
		width = 240
	}):xy(var_3_1.width / 2, 20):addTo(var_3_0, 10)
	bind.extend(arg_3_0, var_3_0, var_3_5)
	arg_3_0.awardsList:pushBackCustomItem(var_3_0)
	transition.executeSequence(arg_3_0.awardsList, true):delay(0.25):func(function()
		if arg_3_1 < csvSize(arg_3_2) then
			arg_3_0:showItem(arg_3_1 + 1, arg_3_2)
		else
			arg_3_0.awardsList:adaptTouchEnabled()
		end
	end):done()
end

function var_0_0.onCloseClick(arg_7_0)
	local var_7_0 = arg_7_0.showEndView

	arg_7_0:onClose()
	var_7_0()
end

return var_0_0
