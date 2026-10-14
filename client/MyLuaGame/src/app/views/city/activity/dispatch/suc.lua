local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("ActivityDispatchSuc", var_0_0)

var_0_1.RESOURCE_FILENAME = "activity_dispatch_suc.json"
var_0_1.RESOURCE_BINDING = {
	textNote = "textNote"
}

function var_0_1.onCreate(arg_1_0)
	widget.addAnimation(arg_1_0:getResourceNode(), "qimiaomaoxian/weipaichenggong.skel", "effect", 0):scale(2.5):alignCenter(display.sizeInView):addPlay("effect_loop")
end

return var_0_1
