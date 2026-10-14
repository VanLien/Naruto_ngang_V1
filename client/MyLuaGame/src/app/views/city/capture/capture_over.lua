local var_0_0 = class("CaptureOver", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "capture_failed.json"
var_0_0.RESOURCE_BINDING = {
	btn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["iconBg2.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["iconBg.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0, arg_1_1)
	arg_1_0.cb = arg_1_1

	local var_1_0 = arg_1_0:getResourceNode()
	local var_1_1 = CSprite.new("effect/gongxihuode.skel")

	var_1_1:addTo(var_1_0, 100)
	var_1_1:setAnchorPoint(cc.p(0.5, 1))
	var_1_1:setPosition(var_1_0:get("titlePos"):getPosition())
	var_1_1:visible(true)
	var_1_1:play("jiesuan_buzhuoshibai")
	var_1_1:addPlay("jiesuan_buzhuoshibai_loop")
	var_1_1:retain()
end

function var_0_0.onClose(arg_2_0)
	if arg_2_0.cb then
		arg_2_0.cb(true)
	end
end

return var_0_0
