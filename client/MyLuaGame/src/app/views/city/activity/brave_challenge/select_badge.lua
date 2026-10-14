local var_0_0 = require("app.views.city.activity.brave_challenge.adapt")
local var_0_1 = {
	forever = 3,
	rare = 2,
	normal = 1
}
local var_0_2 = cc.load("mvc").ViewBase
local var_0_3 = class("BraveChallengeSelectBadgeView", var_0_2)

var_0_3.RESOURCE_FILENAME = "activity_brave_challenge_select_badge.json"
var_0_3.RESOURCE_BINDING = {
	panel1 = "panel1",
	panel3 = "panel3",
	forever = "forever",
	rare = "rare",
	panel2 = "panel2",
	normal = "normal",
	["rare.title"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = cc.c4b(244, 144, 15, 255)
					}
				}
			}
		}
	},
	["rare.rarity"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = cc.c4b(244, 144, 15, 255)
					}
				}
			}
		}
	},
	["forever.title"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = cc.c4b(210, 68, 73, 255)
					}
				}
			}
		}
	},
	["forever.rarity"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = cc.c4b(210, 68, 73, 255)
					}
				}
			}
		}
	},
	btnSure = {
		varname = "btnSure",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSure")
			}
		}
	}
}

function var_0_3.onCreate(arg_1_0, arg_1_1)
	arg_1_0.activityId = gGameModel.brave_challenge:read("yyID")
	arg_1_0.selectNum = idler.new(0)
	arg_1_0.badges = arg_1_1 or {}
	arg_1_0.selectBadge = {}
	arg_1_0.panelCell = {
		arg_1_0.normal,
		arg_1_0.rare,
		arg_1_0.forever
	}

	for iter_1_0, iter_1_1 in ipairs(arg_1_0.badges) do
		table.insert(arg_1_0.selectBadge, iter_1_1[1])
	end

	local var_1_0 = csv.brave_challenge.badge

	for iter_1_2, iter_1_3 in ipairs(arg_1_0.selectBadge) do
		local var_1_1 = arg_1_0.panelCell[var_1_0[iter_1_3].rarity]:clone():show()

		var_1_1:get("title"):text(var_1_0[iter_1_3].name)
		beauty.textScroll({
			isRich = true,
			align = "center",
			list = var_1_1:get("desc"),
			strs = "#C0x5B545B#" .. var_1_0[iter_1_3].desc,
			fontSize = ui.FONT_SIZE
		})
		var_1_1:get("desc"):setItemAlignCenter()
		var_1_1:get("icon"):texture(var_1_0[iter_1_3].iconResPath)
		var_1_1:get("select"):visible(false)
		bind.touch(arg_1_0, var_1_1, {
			methods = {
				ended = functools.partial(arg_1_0.onBadgeClick, arg_1_0, iter_1_2)
			}
		})
		var_1_1:addTo(arg_1_0["panel" .. iter_1_2], 2, "item"):xy(arg_1_0["panel" .. iter_1_2]:width() / 2, arg_1_0["panel" .. iter_1_2]:height() / 2)
	end

	idlereasy.when(arg_1_0.selectNum, function(arg_2_0, arg_2_1)
		for iter_2_0 = 1, 3 do
			arg_1_0["panel" .. iter_2_0]:get("item"):get("select"):visible(false)
		end

		if arg_2_1 ~= 0 then
			arg_1_0["panel" .. arg_2_1]:get("item"):get("select"):visible(true)
		end

		arg_1_0.btnSure:setEnabled(arg_2_1 ~= 0)
	end)
end

function var_0_3.onBadgeClick(arg_3_0, arg_3_1)
	arg_3_0.selectNum:set(arg_3_1)
end

function var_0_3.onSure(arg_4_0)
	if arg_4_0.selectNum:read() == 0 then
		gGameUI:showTip(gLanguageCsv.braveChallengeTip05)

		return
	end

	gGameUI:disableTouchDispatch(nil, false)

	local var_4_0 = widget.addAnimationByKey(arg_4_0["panel" .. arg_4_0.selectNum:read()], "effect/xunzhangxuanze.skel", "select", "effect", 100):xy(arg_4_0["panel" .. arg_4_0.selectNum:read()]:width() / 2, arg_4_0["panel" .. arg_4_0.selectNum:read()]:height() / 2):scale(2)

	arg_4_0:runAction(cc.Sequence:create(cc.DelayTime:create(0.3), cc.CallFunc:create(function()
		gGameUI:disableTouchDispatch(nil, true)
		gGameApp:requestServer(var_0_0.url("choose"), function(arg_6_0)
			arg_4_0:onClose()
		end, arg_4_0.selectBadge[arg_4_0.selectNum:read()], arg_4_0.activityId)
	end), nil))
end

return var_0_3
