local var_0_0 = {
	[0] = {
		animation = "standby_loop",
		bg = "city/pvp/reward/bg_pvp_lose.png",
		bg2 = "activity/volleyball/bg_sb.png",
		result = "effect_shibai_loop"
	},
	{
		animation = "win_loop",
		bg = "city/pvp/reward/bg_pvp_win.png",
		bg2 = "city/pvp/reward/bg_role.png",
		result = "effect_chenggong_loop"
	}
}
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("VolleyballGameOver", var_0_1)

var_0_2.RESOURCE_FILENAME = "volleyball_end.json"
var_0_2.RESOURCE_BINDING = {
	bg2 = "bg2",
	bg = "bg",
	img = "img",
	result = "result",
	btnBack = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBackClick")
			}
		}
	},
	btnAgain = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAgainClick")
			}
		}
	},
	score = {
		varname = "score",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 8,
					color = cc.c4b(0, 0, 0, 30)
				},
				color = ui.COLORS.WHITE
			}
		}
	},
	["btnBack.back"] = {
		varname = "back",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(82, 76, 85, 255)
				}
			}
		}
	},
	["btnAgain.again"] = {
		varname = "again",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(82, 76, 85, 255)
				}
			}
		}
	}
}

function var_0_2.onCreate(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.parent = arg_1_1

	local var_1_0 = var_0_0[arg_1_2.result]

	widget.addAnimationByKey(arg_1_0.result, "volleyball_result/tiaozhan.skel", "resultEffect", var_1_0.result, 5):alignCenter(arg_1_0.result:size()):scale(1)
	arg_1_0.bg2:texture(var_1_0.bg2)
	arg_1_0.bg:texture(var_1_0.bg)
	widget.addAnimationByKey(arg_1_0.img, csv.unit[arg_1_2.unitId].unitRes, nil, var_1_0.animation, 5):alignCenter(arg_1_0.img:size()):scale(4)
	arg_1_0.score:text(string.format("%d : %d", arg_1_2.score[1], arg_1_2.score[2]))
end

function var_0_2.onPanelClick(arg_2_0)
	arg_2_0.parent:onClose()
end

function var_0_2.onBackClick(arg_3_0)
	arg_3_0.parent:onClose()
end

function var_0_2.onAgainClick(arg_4_0)
	arg_4_0.parent:resetGame()
	var_0_1.onClose(arg_4_0)
end

return var_0_2
