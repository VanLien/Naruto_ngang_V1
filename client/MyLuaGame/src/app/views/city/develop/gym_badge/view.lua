local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("gymBadgeView", var_0_0)
local var_0_2 = {
	{
		cc.p(464, 924),
		cc.p(716, 924),
		cc.p(716, 1176),
		cc.p(464, 1176)
	},
	{
		cc.p(729, 714),
		cc.p(981, 714),
		cc.p(981, 966),
		cc.p(729, 966)
	},
	{
		cc.p(945, 455),
		cc.p(1197, 455),
		cc.p(1197, 707),
		cc.p(945, 707)
	},
	{
		cc.p(734, 196),
		cc.p(986, 196),
		cc.p(986, 448),
		cc.p(734, 448)
	},
	{
		cc.p(478, -23),
		cc.p(730, -23),
		cc.p(730, 229),
		cc.p(478, 229)
	},
	{
		cc.p(214, 203),
		cc.p(466, 203),
		cc.p(466, 455),
		cc.p(214, 455)
	},
	{
		cc.p(7, 459),
		cc.p(259, 459),
		cc.p(259, 711),
		cc.p(7, 711)
	},
	{
		cc.p(221, 713),
		cc.p(473, 713),
		cc.p(473, 965),
		cc.p(221, 965)
	}
}
local var_0_3 = {
	[4] = {
		effectName = "huo_effect",
		scale = 2,
		y = 632,
		x = 603,
		loopName = "huo_loop",
		point = cc.p(0.5, 0.5)
	},
	[5] = {
		effectName = "long_effect",
		scale = 2,
		y = 632,
		x = 599,
		loopName = "long_loop",
		point = cc.p(0.5, 0.5)
	},
	[2] = {
		effectName = "shui_effect",
		scale = 2,
		y = 632,
		x = 599,
		loopName = "shui_loop",
		point = cc.p(0.5, 0.5)
	},
	{
		effectName = "yan_effect",
		scale = 2,
		y = 632,
		x = 599,
		loopName = "yan_loop",
		point = cc.p(0.5, 0.5)
	},
	[3] = {
		effectName = "cao_effect",
		scale = 2,
		y = 632,
		x = 599,
		loopName = "cao_loop",
		point = cc.p(0.5, 0.5)
	},
	[6] = {
		effectName = "e_effect",
		scale = 2,
		y = 630,
		x = 597,
		loopName = "e_loop",
		point = cc.p(0.5, 0.5)
	},
	[8] = {
		effectName = "yao_effect",
		scale = 2,
		y = 632,
		x = 599,
		loopName = "yao_loop",
		point = cc.p(0.5, 0.5)
	},
	[7] = {
		effectName = "du_effect",
		scale = 2,
		y = 629,
		x = 597,
		loopName = "du_loop",
		point = cc.p(0, 0)
	}
}

var_0_1.RESOURCE_FILENAME = "gym_badge.json"
var_0_1.RESOURCE_BINDING = {
	centerPanel = "centerPanel",
	["centerPanel.bg"] = "badge",
	bg = "bg",
	gymBtn = {
		varname = "gymBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onGym")
			}
		}
	},
	rule = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowRule")
			}
		}
	},
	["rule.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["gymBtn.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_1_0)
	arg_1_0:initModel()
	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_1_0.rule,
			"pos",
			"left"
		},
		{
			arg_1_0.gymBtn,
			"pos",
			"right"
		}
	})

	arg_1_0.isView = idler.new(true)

	gGameUI.topuiManager:createView("default", arg_1_0, {
		onClose = arg_1_0:createHandler("onClose")
	}):init({
		subTitle = "GYMBADGE",
		title = "common/txt/txt_bt_bagua.png"
	})

	for iter_1_0 = 1, 8 do
		arg_1_0.centerPanel:get("name" .. iter_1_0):setColor(cc.c3b(128, 128, 128))
	end

	arg_1_0.lastBadge = userDefault.getForeverLocalKey("gymBadge", {})

	userDefault.setForeverLocalKey("gymBadge")

	arg_1_0.nowBadge = {}

	local var_1_0 = false

	idlereasy.any({
		arg_1_0.badges,
		arg_1_0.isView
	}, function(arg_2_0, arg_2_1, arg_2_2)
		for iter_2_0, iter_2_1 in orderCsvPairs(csv.gym_badge.badge) do
			if iter_2_1.preBadgeID then
				local var_2_0 = arg_2_1 and arg_2_1[iter_2_1.preBadgeID] or {}

				if iter_2_1.preBadgeType == 1 then
					if (var_2_0.awake or 0) >= iter_2_1.preLevel then
						arg_1_0.nowBadge[iter_2_0] = 1
					end
				else
					local var_2_1 = csv.gym_badge.badge[iter_2_1.preBadgeID].talentIDs[6]
					local var_2_2 = arg_2_1[iter_2_1.preBadgeID] and arg_2_1[iter_2_1.preBadgeID].talents

					if (var_2_2 and var_2_2[var_2_1] or 0) >= iter_2_1.preLevel then
						arg_1_0.nowBadge[iter_2_0] = 1
					end
				end
			else
				arg_1_0.nowBadge[iter_2_0] = 1

				if arg_2_1[iter_2_0] then
					var_1_0 = true
				end
			end
		end
	end)

	if var_1_0 then
		arg_1_0.lastBadge = clone(arg_1_0.nowBadge)
	end

	arg_1_0:playLoopEff()
	idlereasy.when(arg_1_0.isView, function(arg_3_0, arg_3_1)
		if arg_3_1 then
			arg_1_0:playEffect()
		end
	end)
	arg_1_0.centerPanel:onTouch(functools.partial(arg_1_0.showBadge, arg_1_0))
end

function var_0_1.initModel(arg_4_0)
	arg_4_0.badges = gGameModel.role:getIdler("badges")
end

function var_0_1.onGym(arg_5_0)
	jumpEasy.jumpTo("gymChallenge")
end

function var_0_1.showBadge(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_1.target:convertToNodeSpace(arg_6_1)

	if arg_6_1.name == "began" then
		arg_6_0.touchIndex = dataEasy.checkInRect(var_0_2, var_6_0)

		if arg_6_0.touchIndex then
			if arg_6_0.centerPanel:getChildByName("spine" .. arg_6_0.touchIndex) then
				arg_6_0.centerPanel:getChildByName("spine" .. arg_6_0.touchIndex):scale(2.3)
			else
				arg_6_0.centerPanel:get("name" .. arg_6_0.touchIndex):scale(0.9)
			end
		end
	elseif arg_6_1.name == "ended" or arg_6_1.name == "cancelled" then
		if arg_6_0.touchIndex == nil then
			return
		end

		if arg_6_0.centerPanel:getChildByName("spine" .. arg_6_0.touchIndex) then
			arg_6_0.centerPanel:getChildByName("spine" .. arg_6_0.touchIndex):scale(2.5)
		else
			arg_6_0.centerPanel:get("name" .. arg_6_0.touchIndex):scale(1)
		end

		if arg_6_0.touchIndex == dataEasy.checkInRect(var_0_2, var_6_0) then
			if arg_6_0.nowBadge[arg_6_0.touchIndex] == 1 then
				arg_6_0.isView:set(false)
				gGameUI:stackUI("city.develop.gym_badge.talent", nil, {
					full = true
				}, {
					badgeNumb = arg_6_0.touchIndex,
					isView = arg_6_0.isView
				})
			else
				arg_6_0:showUnlockTips(arg_6_0.touchIndex)
			end
		end
	end
end

function var_0_1.showUnlockTips(arg_7_0, arg_7_1)
	local var_7_0 = csv.gym_badge.badge
	local var_7_1 = var_7_0[arg_7_1].preBadgeID

	if var_7_0[arg_7_1].preBadgeType == 1 then
		gGameUI:showTip(string.format(gLanguageCsv.noOpenPleaseToGymView1, var_7_0[var_7_1].name, var_7_0[arg_7_1].preLevel))
	else
		gGameUI:showTip(string.format(gLanguageCsv.noOpenPleaseToGymView2, var_7_0[var_7_1].name, var_7_0[arg_7_1].preLevel))
	end
end

function var_0_1.onShowRule(arg_8_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_8_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_1.getRuleContext(arg_9_0, arg_9_1)
	local var_9_0 = adaptContext

	return {
		var_9_0.clone(arg_9_1.title, function(arg_10_0)
			arg_10_0:get("text"):text(gLanguageCsv.badgeExplain)
		end),
		var_9_0.noteText(111001, 111011)
	}
end

function var_0_1.playEffect(arg_11_0)
	if not arg_11_0.maskPanel then
		arg_11_0.maskPanel = ccui.Layout:create():size(display.sizeInView):x(-display.uiOrigin.x):addTo(arg_11_0, 99999, "maskPanel")

		arg_11_0.maskPanel:setTouchEnabled(true)
		arg_11_0.maskPanel:onClick(function()
			arg_11_0:stopAllActions()
			arg_11_0:handlerShowItem(0.1)
		end)
	end

	arg_11_0.maskPanel:show()

	arg_11_0.aniIndex = 1
	arg_11_0.aniData = {}

	for iter_11_0, iter_11_1 in ipairs(csv.gym_badge.badge) do
		if arg_11_0.lastBadge[iter_11_0] ~= 1 and arg_11_0.nowBadge[iter_11_0] == 1 then
			table.insert(arg_11_0.aniData, {
				id = iter_11_0
			})
		end
	end

	arg_11_0:handlerShowItem(2)
	userDefault.setForeverLocalKey("gymBadge", arg_11_0.nowBadge)
end

function var_0_1.handlerShowItem(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.aniIndex
	local var_13_1 = arg_13_0.aniData[var_13_0]

	if not var_13_1 then
		arg_13_0.maskPanel:hide()

		return
	end

	local var_13_2 = var_13_0 == 1 and 0.1 or arg_13_1

	performWithDelay(arg_13_0, function()
		local var_14_0 = var_13_1.id

		arg_13_0.lastBadge[var_14_0] = 1

		local var_14_1, var_14_2 = arg_13_0.centerPanel:get("name" .. var_14_0):xy()
		local var_14_3 = widget.addAnimationByKey(arg_13_0.centerPanel, "daoguanhuizhang/dghz.skel", "spine" .. var_14_0, var_0_3[var_14_0].effectName, 100):xy(var_14_1, var_14_2):scale(2.5)

		var_14_3:setSpriteEventHandler(function(arg_15_0, arg_15_1)
			var_14_3:setSpriteEventHandler(nil, sp.EventType.ANIMATION_COMPLETE)
			var_14_3:play(var_0_3[var_14_0].loopName)
			arg_13_0.centerPanel:get("name" .. var_14_0):hide()
		end, sp.EventType.ANIMATION_COMPLETE)

		arg_13_0.aniIndex = arg_13_0.aniIndex + 1

		arg_13_0:handlerShowItem(arg_13_1)
	end, var_13_2)
end

function var_0_1.playLoopEff(arg_16_0)
	for iter_16_0, iter_16_1 in ipairs(csv.gym_badge.badge) do
		if arg_16_0.lastBadge[iter_16_0] == 1 then
			local var_16_0, var_16_1 = arg_16_0.centerPanel:get("name" .. iter_16_0):xy()
			local var_16_2 = widget.addAnimationByKey(arg_16_0.centerPanel, "daoguanhuizhang/dghz.skel", "spine" .. iter_16_0, var_0_3[iter_16_0].loopName, 100):xy(var_16_0, var_16_1):scale(2.5)

			arg_16_0.centerPanel:get("name" .. iter_16_0):hide()
		end
	end
end

function var_0_1.onCleanup(arg_17_0)
	if arg_17_0.maskPanel then
		arg_17_0.maskPanel:removeFromParent()

		arg_17_0.maskPanel = nil
	end

	var_0_0.onCleanup(arg_17_0)
end

return var_0_1
