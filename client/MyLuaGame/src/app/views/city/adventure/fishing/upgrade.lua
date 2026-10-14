local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("FishingUpgradeView", var_0_0)

var_0_1.RESOURCE_FILENAME = "fishing_upgrade.json"
var_0_1.RESOURCE_BINDING = {
	back = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	top = {
		varname = "imgInfo",
		binds = {
			event = "extend",
			class = "text_atlas",
			props = {
				isEqualDist = false,
				pathName = "lv_big",
				align = "center",
				data = bindHelper.self("fishLevel"),
				onNode = function(arg_1_0)
					arg_1_0:xy(415, 200)
				end
			}
		}
	}
}

function var_0_1.onCreate(arg_2_0, arg_2_1)
	arg_2_0.cb = arg_2_1

	audio.playEffectWithWeekBGM("role_levelup.mp3")
	arg_2_0:initModel()

	local var_2_0 = arg_2_0.fishLevel:read()
	local var_2_1 = arg_2_0.imgInfo
	local var_2_2 = var_2_1:size()
	local var_2_3 = CSprite.new("effect/gongxihuode.skel")

	var_2_3:addTo(var_2_1, 1)
	var_2_3:setAnchorPoint(cc.p(0.5, 0.5))
	var_2_3:xy(var_2_1:width() / 2 + 15, -345)
	var_2_3:play("shengji_new_loop")
end

function var_0_1.initModel(arg_3_0)
	arg_3_0.fishLevel = gGameModel.fishing:getIdler("level")
end

function var_0_1.onClose(arg_4_0)
	arg_4_0:addCallbackOnExit(arg_4_0.cb)
	var_0_0.onClose(arg_4_0)
end

return var_0_1
