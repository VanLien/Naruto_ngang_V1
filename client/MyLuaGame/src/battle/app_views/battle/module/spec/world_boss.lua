local var_0_0 = string.format
local var_0_1 = class("BattleWorldBossView", battleModule.CBase)

var_0_1.RESOURCE_FILENAME = "battle_world_boss.json"
var_0_1.RESOURCE_BINDING = {
	["bossLifePanel.award"] = "award",
	bossLifePanel = "bossLifePanel"
}

function var_0_1.ctor(arg_1_0, arg_1_1)
	battleModule.CBase.ctor(arg_1_0, arg_1_1)

	arg_1_0.root = cache.createWidget(arg_1_0.RESOURCE_FILENAME)

	bindUI(arg_1_0, arg_1_0.root, arg_1_0.RESOURCE_BINDING)
	arg_1_0.root:addTo(arg_1_1, 999):show()
	arg_1_0:init()
end

function var_0_1.init(arg_2_0)
	arg_2_0.bossLifePanel:hide()

	arg_2_0.sceneID = arg_2_0.parent.sceneID

	arg_2_0.bossLifePanel:show()

	arg_2_0.awardLevel = -1
end

function var_0_1.onNewBattleRound(arg_3_0, arg_3_1)
	local var_3_0 = csv.scene_conf[arg_3_0.parent.sceneID]
	local var_3_1 = math.max(math.min(arg_3_1.curRound, var_3_0.roundLimit), 0)

	arg_3_0.bossLifePanel:get("round.round"):setString(var_0_0(gLanguageCsv.theRound, var_3_1, var_3_0.roundLimit))
end

function var_0_1.onInitBossLife(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_1.name
	local var_4_1 = arg_4_1.headIconRes
	local var_4_2 = arg_4_1.damageAward[1]

	arg_4_0.damageAward = arg_4_1.damageAward

	if var_4_0 then
		arg_4_0.bossLifePanel:get("name"):text(var_4_0)
	end

	if var_4_1 then
		arg_4_0.bossLifePanel:get("headIcon"):texture(var_4_1)
	end

	local var_4_3 = arg_4_0.bossLifePanel:get("bar1")
	local var_4_4 = arg_4_0.bossLifePanel:get("bar2")

	text.addEffect(arg_4_0.bossLifePanel:get("hp"), {
		outline = {
			color = cc.c4b(254, 253, 236, 255)
		}
	})
	text.addEffect(arg_4_0.bossLifePanel:get("hpMax"), {
		outline = {
			color = cc.c4b(209, 128, 0, 255)
		}
	})

	arg_4_0.fullWidth = var_4_4:width()

	var_4_3:show()
	var_4_4:show()

	arg_4_0.awardEffect = widget.addAnimation(arg_4_0.award, "worldboss/bossbaoxiang.skel", "effect", 100)

	arg_4_0.awardEffect:anchorPoint(cc.p(0.5, 0.5)):xy(cc.p(arg_4_0.award:width() / 2, arg_4_0.award:height() / 2))
	arg_4_0:onRefreshBossHp(0, 0, var_4_2.damage, 0)
	arg_4_0:onRefreshBossAward(var_4_2.boxRes, 0)
end

function var_0_1.onRefreshBossHp(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if arg_5_4 < arg_5_0.awardLevel then
		return
	end

	local var_5_0 = 0.8
	local var_5_1 = arg_5_1 * 100
	local var_5_2 = arg_5_1 * arg_5_0.fullWidth
	local var_5_3 = arg_5_0.bossLifePanel:get("bar1")
	local var_5_4 = arg_5_0.bossLifePanel:get("bar2")
	local var_5_5 = arg_5_0.bossLifePanel:get("hp")
	local var_5_6 = arg_5_0.bossLifePanel:get("hpMax")

	var_5_3:stopAllActions()

	if arg_5_4 > arg_5_0.awardLevel then
		arg_5_0.awardLevel = arg_5_4

		local var_5_7 = arg_5_0.awardLevel + 1

		var_5_6:setString("/" .. arg_5_3)
		var_5_3:setPercent(0)

		if arg_5_0.damageAward[var_5_7] then
			arg_5_0.award:loadTexture(arg_5_0.damageAward[var_5_7].boxRes)
			arg_5_0.awardEffect:stopAllActions()
			arg_5_0.awardEffect:play("effect")
		end
	end

	var_5_5:setString(math.floor(arg_5_2))

	if math.abs(var_5_4:width() - var_5_2) < 0.01 and math.abs(var_5_3:getPercent() - var_5_1) < 0.01 then
		return
	end

	var_5_4:width(var_5_2)
	transition.executeSequence(var_5_3):progressTo(var_5_0, var_5_1):done()
end

function var_0_1.onRefreshBossAward(arg_6_0, arg_6_1, arg_6_2)
	if not arg_6_2 or not arg_6_1 or arg_6_2 and arg_6_2 == 0 then
		return
	end

	arg_6_0.award:loadTexture(arg_6_1)
end

function var_0_1.onShowSpec(arg_7_0, arg_7_1)
	arg_7_0.root:setVisible(arg_7_1)
end

function var_0_1.onClose(arg_8_0)
	ViewBase.onClose(arg_8_0)
end

function var_0_1.onShowBuffIcon(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	if arg_9_1.model.isBoss then
		local var_9_0 = gRootViewProxy:call("getRecord", arg_9_1, true)

		if not var_9_0.initByBoss then
			local var_9_1 = cc.p(580, -50)
			local var_9_2 = 0.8
			local var_9_3 = arg_9_0.bossLifePanel:convertToWorldSpace(var_9_1)

			var_9_0.shadowNode:unscheduleUpdate()
			var_9_0.buffGroupNode:xy(var_9_3)
			var_9_0.buffOverlayNode:xy(var_9_3)
			var_9_0.buffGroupNode:scale(var_9_2)
			var_9_0.buffOverlayNode:scale(var_9_2)

			var_9_0.lineLimit = 13

			var_9_0.buffGroupNode:setVisible(true)

			local var_9_4

			var_9_0.shadowNode:scheduleUpdate(function()
				local var_10_0 = var_9_0.visible and arg_9_0.root:visible()

				if var_9_4 ~= var_10_0 then
					var_9_4 = var_10_0

					var_9_0.buffGroupNode:setVisible(var_10_0)
					var_9_0.buffOverlayNode:setVisible(var_10_0)
				end
			end)

			var_9_0.initByBoss = true
		end

		if var_9_0.buffEffectsMap[arg_9_3] == nil then
			return
		end
	end
end

return var_0_1
