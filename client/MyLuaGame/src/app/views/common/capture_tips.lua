local var_0_0 = class("CaptureTips", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "common_capture_tips.json"
var_0_0.RESOURCE_BINDING = {
	imgBG = {
		varname = "bg",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onEnterCaptureClick")
			}
		}
	}
}

function var_0_0.onEnterCaptureClick(arg_1_0)
	arg_1_0:removeSelf()
	gGameUI:stackUI("city.capture.capture_limit", nil, {
		full = true
	})
end

function var_0_0.onEnter(arg_2_0)
	local var_2_0 = cc.p(arg_2_0.bg:xy())
	local var_2_1 = cc.Place:create(cc.p(var_2_0.x - 500, var_2_0.y))
	local var_2_2 = cc.MoveTo:create(0.5, var_2_0)
	local var_2_3 = cc.EaseBackOut:create(var_2_2)

	arg_2_0.bg:runAction(cc.Sequence:create(var_2_1, var_2_3))
end

return var_0_0
