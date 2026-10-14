local var_0_0 = 0.08
local var_0_1 = class("gymBadgeAwakeSuccessView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "gym_badge_awake_success.json"
var_0_1.RESOURCE_BINDING = {
	rightName = "rightName",
	leftPanel = "leftPanel",
	item = "item",
	topList = "topList",
	leftName = "leftName",
	arrow = "arrow",
	rightPanel = "rightPanel",
	bg = {
		binds = {
			event = "click",
			method = bindHelper.self("onClose")
		}
	}
}

function var_0_1.playEffect(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0:getResourceNode()
	local var_1_1 = CSprite.new("effect/gongxihuode.skel")

	var_1_1:addTo(var_1_0, 100)
	var_1_1:setAnchorPoint(cc.p(0.5, 0.5))
	var_1_1:setPosition(var_1_0:get("title"):getPosition())
	var_1_1:visible(true)
	var_1_1:play("xjiesuan_juexingzi")
	var_1_1:addPlay("xjiesuan_juexingzi")
	var_1_1:retain()

	local var_1_2 = CSprite.new("effect/gongxihuode.skel")

	var_1_2:addTo(var_1_0, 99)
	var_1_2:setAnchorPoint(cc.p(0.5, 0.5))
	var_1_2:setPosition(var_1_0:get("title"):getPosition())
	var_1_2:visible(true)
	var_1_2:play("jiesuan_shenglitu")
	var_1_2:addPlay("jiesuan_shenglitu_loop")
	var_1_2:retain()
end

function var_0_1.onCreate(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_1.awake
	local var_2_1 = arg_2_1.nextEffStrs
	local var_2_2 = arg_2_1.badgeNumb
	local var_2_3 = csv.gym_badge.badge
	local var_2_4 = var_2_3[var_2_2].icon
	local var_2_5 = var_2_3[var_2_2].name

	arg_2_0.leftPanel:get("icon"):texture(var_2_4)
	arg_2_0.rightPanel:get("icon"):texture(var_2_4)
	arg_2_0.leftName:text(var_2_5 .. "+" .. var_2_0)
	arg_2_0.rightName:text(var_2_5 .. "+" .. var_2_0 + 1)
	beauty.textScroll({
		margin = 20,
		align = "left",
		isRich = true,
		list = arg_2_0.topList,
		effect = {
			color = ui.COLORS.NORMAL.WHITE
		},
		strs = var_2_1
	})
	arg_2_0:playEffect("jihuo")
	uiEasy.setExecuteSequence(arg_2_0.leftPanel, {
		delayTime = var_0_0
	})
	uiEasy.setExecuteSequence(arg_2_0.leftName, {
		delayTime = var_0_0 * 2
	})
	uiEasy.setExecuteSequence(arg_2_0.arrow, {
		delayTime = var_0_0 * 2
	})
	uiEasy.setExecuteSequence(arg_2_0.rightPanel, {
		delayTime = var_0_0 * 4
	})
	uiEasy.setExecuteSequence(arg_2_0.rightName, {
		delayTime = var_0_0 * 5
	})
end

return var_0_1
