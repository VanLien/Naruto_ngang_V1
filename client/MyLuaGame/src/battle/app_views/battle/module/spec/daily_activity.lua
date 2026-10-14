local var_0_0 = string.format
local var_0_1 = {
	"city/adventure/goldbaby/bar_hxt1.png",
	"city/adventure/goldbaby/bar_zxt.png",
	"city/adventure/goldbaby/bar_hxt.png",
	"city/adventure/goldbaby/bar_lxt1.png",
	"city/adventure/goldbaby/bar_lxt.png"
}
local var_0_2 = {
	1,
	2,
	3,
	4,
	5,
	1
}
local var_0_3 = class("BattleDailyActivityView", battleModule.CBase)

var_0_3.RESOURCE_FILENAME = "battle_daily_activity.json"
var_0_3.RESOURCE_BINDING = {
	bossLifePanel = "bossLifePanel",
	item2 = "item2",
	item1 = "item1",
	statsPanel = "statsPanel",
	["statsPanel.count"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["item1.count"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["item2.count"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	}
}

function var_0_3.ctor(arg_1_0, arg_1_1)
	battleModule.CBase.ctor(arg_1_0, arg_1_1)

	arg_1_0.root = cache.createWidget(arg_1_0.RESOURCE_FILENAME)

	bindUI(arg_1_0, arg_1_0.root, arg_1_0.RESOURCE_BINDING)
	arg_1_0.root:addTo(arg_1_1, 99):show()
	arg_1_0:init()
end

function var_0_3.init(arg_2_0)
	arg_2_0.item1:hide()
	arg_2_0.item2:hide()
	arg_2_0.statsPanel:hide()
	arg_2_0.bossLifePanel:hide()

	arg_2_0.sceneID = arg_2_0.parent.sceneID

	if arg_2_0.parent.gateType == game.GATE_TYPE.dailyGold or arg_2_0.parent.gateType == game.GATE_TYPE.unionFuben or arg_2_0.parent.gateType == game.GATE_TYPE.crossMineBoss then
		arg_2_0.bossLifePanel:show()

		arg_2_0.barResOrderN = 1
	elseif arg_2_0.parent.gateType == game.GATE_TYPE.dailyExp then
		arg_2_0.statsPanel:show()
	end

	arg_2_0.dropSpritesTb = {
		{},
		{}
	}
	arg_2_0.countTb = {
		0,
		0
	}
	arg_2_0.lostHpPerTb = arg_2_0.lostHpPerTb or {}

	local var_2_0 = csv.huodong_drop[arg_2_0.sceneID]

	if var_2_0 then
		arg_2_0.dropCfg = var_2_0

		for iter_2_0, iter_2_1 in csvMapPairs(var_2_0.perDrop or {}) do
			local var_2_1 = dataEasy.getIconResByKey(iter_2_0)

			if var_2_1 then
				arg_2_0.item1Res = var_2_1

				arg_2_0.item1:get("icon"):texture(var_2_1)
				arg_2_0.item1:show()

				break
			end
		end

		if not itertools.isempty(var_2_0.node) then
			arg_2_0.item2:show()
		end
	end

	arg_2_0.convStr = idler.new("")
end

function var_0_3.onKillCount(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_1.curCount or 0
	local var_3_1 = arg_3_1.totalCount or 1
	local var_3_2 = arg_3_0.statsPanel:get("count")
	local var_3_3 = string.format(gLanguageCsv.totalKill, var_3_0, var_3_1)

	var_3_2:text(var_3_3)
end

function var_0_3.onNewBattleRound(arg_4_0, arg_4_1)
	local var_4_0 = csv.scene_conf[arg_4_0.parent.sceneID]
	local var_4_1 = math.max(math.min(arg_4_1.curRound, var_4_0.roundLimit), 0)

	arg_4_0.bossLifePanel:get("round.round"):setString(var_0_0(gLanguageCsv.theRound, var_4_1, var_4_0.roundLimit))
end

function var_0_3.onDropShow(arg_5_0, arg_5_1)
	if not arg_5_1 then
		return
	end

	if not arg_5_0.dropCfg then
		return
	end

	local var_5_0 = arg_5_0.dropCfg
	local var_5_1 = arg_5_1.nPer
	local var_5_2 = arg_5_1.nNode
	local var_5_3 = arg_5_1.tostrModel
	local var_5_4 = arg_5_0.parent:onViewProxyCall("getSceneObjs")[var_5_3]

	if not var_5_4 then
		return
	end

	local var_5_5, var_5_6 = var_5_4:xy()
	local var_5_7 = var_5_5 - 250
	local var_5_8 = var_5_5 + 100
	local var_5_9 = 270
	local var_5_10 = {}

	if var_5_1 >= 1 then
		for iter_5_0, iter_5_1 in csvMapPairs(var_5_0.perDrop or {}) do
			var_5_10[iter_5_0] = var_5_10[iter_5_0] or 0
			var_5_10[iter_5_0] = var_5_10[iter_5_0] + iter_5_1 * var_5_1
		end
	end

	arg_5_0.nodeDropN = arg_5_0.nodeDropN or 0

	if var_5_0.node then
		for iter_5_2, iter_5_3 in ipairs(var_5_0.node) do
			if iter_5_2 > arg_5_0.nodeDropN and iter_5_3 <= var_5_2 then
				arg_5_0.nodeDropN = iter_5_2

				local var_5_11 = var_5_0.nodeDrop[iter_5_2]

				for iter_5_4, iter_5_5 in csvMapPairs(var_5_11 or {}) do
					var_5_10[iter_5_4] = var_5_10[iter_5_4] or 0
					var_5_10[iter_5_4] = var_5_10[iter_5_4] + iter_5_5
				end
			end
		end
	end

	if next(var_5_10) then
		for iter_5_6, iter_5_7 in pairs(var_5_10) do
			local var_5_12 = dataEasy.getIconResByKey(iter_5_6)
			local var_5_13 = arg_5_0.item1Res == var_5_12 and 1 or 2

			arg_5_0.countTb[var_5_13] = arg_5_0.countTb[var_5_13] + iter_5_7

			if var_5_12 then
				local var_5_14 = iter_5_7

				if iter_5_7 > 100 then
					var_5_14 = cc.clampf(math.ceil(iter_5_7 / (var_5_0.perIcon or 1)), 1, 99)
				end

				for iter_5_8 = 1, var_5_14 do
					local var_5_15 = newCSprite(var_5_12)

					var_5_15:xy(var_5_5, var_5_6 + display.fightLower):anchorPoint(0, 0)
					arg_5_0.root:add(var_5_15)
					table.insert(arg_5_0.dropSpritesTb[var_5_13], var_5_15)

					local var_5_16 = math.random(var_5_7, var_5_8)
					local var_5_17 = var_5_5 < var_5_16 and math.random(var_5_5, var_5_16) or math.random(var_5_16, var_5_5)

					var_5_15:runAction(cc.Sequence:create(cc.JumpTo:create(0.4, cc.p(var_5_16, var_5_9), 0, 1), cc.JumpTo:create(0.4, cc.p(var_5_17, var_5_9), 50, 1)))
				end
			end
		end
	end
end

function var_0_3.onRoundEndDropCollection(arg_6_0)
	local var_6_0, var_6_1 = arg_6_0.item1:xy()
	local var_6_2, var_6_3 = arg_6_0.item2:xy()
	local var_6_4 = 0.03

	for iter_6_0, iter_6_1 in ipairs(arg_6_0.dropSpritesTb) do
		local var_6_5 = var_6_0
		local var_6_6 = var_6_1

		if iter_6_0 ~= 1 then
			var_6_5, var_6_6 = var_6_2, var_6_3
		end

		local var_6_7 = 0

		for iter_6_2, iter_6_3 in ipairs(iter_6_1) do
			transition.executeSequence(iter_6_3):delay(var_6_7):moveTo(0.5, var_6_5, var_6_6):func(function()
				removeCSprite(iter_6_3)
			end):done()

			var_6_7 = var_6_7 + var_6_4
		end
	end

	local function var_6_8(arg_8_0, arg_8_1)
		local var_8_0 = arg_8_0:get("count")
		local var_8_1 = math.max(1, table.length(arg_6_0.dropSpritesTb[arg_8_1]))
		local var_8_2 = arg_6_0.countTb[arg_8_1] / var_8_1
		local var_8_3 = tonumber(var_8_0:getString())
		local var_8_4 = var_8_3 + arg_6_0.countTb[arg_8_1]

		arg_8_0:stopAllActionsByTag(arg_8_1)

		local var_8_5

		var_8_5 = schedule(arg_8_0, function()
			var_8_3 = math.floor(var_8_3 + var_8_2)

			var_8_0:text(math.max(var_8_3, var_8_4))

			if var_8_3 >= var_8_4 then
				var_8_0:text(var_8_4)
				arg_8_0:stopAction(var_8_5)
			end
		end, var_6_4)

		var_8_5:setTag(arg_8_1)
	end

	var_6_8(arg_6_0.item1, 1)
	var_6_8(arg_6_0.item2, 2)

	arg_6_0.dropSpritesTb = {
		{},
		{}
	}
	arg_6_0.countTb = {
		0,
		0
	}
end

function var_0_3.onInitBossLife(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.name
	local var_10_1 = arg_10_1.headIconRes

	arg_10_0.bossLifeTotalCount = arg_10_1.leftBars or 1
	arg_10_0.bossLastLifeBarsPer = arg_10_1.barsLife

	if var_10_0 then
		arg_10_0.bossLifePanel:get("name"):text(var_10_0)
	end

	if var_10_1 then
		arg_10_0.bossLifePanel:get("headIcon"):texture(var_10_1)
	end

	local var_10_2 = arg_10_0.bossLifePanel:get("bar1")
	local var_10_3 = arg_10_0.bossLifePanel:get("bar2")

	if arg_10_0.bossLifeTotalCount == 1 then
		var_10_2:loadTexture(var_0_1[arg_10_0.barResOrderN])
		var_10_3:hide()
	else
		var_10_2:loadTexture(var_0_1[var_0_2[arg_10_0.barResOrderN]])
		var_10_3:texture(var_0_1[var_0_2[arg_10_0.barResOrderN + 1]])
	end

	arg_10_0.convStr:set("x" .. tostring(arg_10_0.bossLifeTotalCount))
	bind.extend(arg_10_0.parent, arg_10_0.bossLifePanel:get("lifeCount"), {
		class = "text_atlas",
		props = {
			pathName = "boss",
			isEqualDist = false,
			align = "left",
			data = arg_10_0.convStr
		}
	})

	local var_10_4 = arg_10_0.bossLifeTotalCount * 100 - arg_10_0.bossLastLifeBarsPer

	arg_10_0:onBossLostHp({
		lostHpPer = var_10_4
	})
end

function var_0_3.onBossLostHp(arg_11_0, arg_11_1)
	if arg_11_1.lostHpPer > 0 then
		table.insert(arg_11_0.lostHpPerTb, arg_11_1.lostHpPer)
	end

	arg_11_0.root:stopAllActionsByTag(100)

	local var_11_0 = 0
	local var_11_1

	var_11_1 = schedule(arg_11_0.root, function()
		var_11_0 = var_11_0 + 0.02

		if next(arg_11_0.lostHpPerTb) then
			arg_11_0:showBossHPBarAni()
		end

		if var_11_0 > 5 or not arg_11_0.isHPBarChanging then
			arg_11_0.root:stopAction(var_11_1)
		end
	end, 0.02)

	var_11_1:setTag(100)
end

function var_0_3.onShowSpec(arg_13_0, arg_13_1)
	arg_13_0.root:setVisible(arg_13_1)
end

function var_0_3.showBossHPBarAni(arg_14_0)
	if arg_14_0.isHPBarChanging then
		return
	end

	arg_14_0.isHPBarChanging = true

	local var_14_0 = arg_14_0.bossLifePanel:get("bar1")
	local var_14_1 = arg_14_0.bossLifePanel:get("bar2")
	local var_14_2 = arg_14_0.lostHpPerTb[1]
	local var_14_3 = arg_14_0.bossLastLifeBarsPer % 100

	if var_14_3 == 0 then
		var_14_3 = 100
	end

	local var_14_4

	arg_14_0.lostHpPerTb[1] = var_14_2 - var_14_3

	if arg_14_0.lostHpPerTb[1] <= 0 then
		table.remove(arg_14_0.lostHpPerTb, 1)

		var_14_4 = var_14_3 - var_14_2
		arg_14_0.bossLastLifeBarsPer = arg_14_0.bossLastLifeBarsPer - var_14_2
	else
		var_14_4 = 0
		arg_14_0.bossLastLifeBarsPer = arg_14_0.bossLastLifeBarsPer - var_14_3
	end

	local var_14_5 = 0.1

	local function var_14_6()
		if arg_14_0.bossLifeTotalCount == 1 then
			arg_14_0.bossLifeTotalCount = 0

			arg_14_0.convStr:set("x" .. arg_14_0.bossLifeTotalCount)

			return
		end

		arg_14_0.barResOrderN = var_0_2[arg_14_0.barResOrderN + 1]

		var_14_0:loadTexture(var_0_1[arg_14_0.barResOrderN])
		var_14_0:setPercent(100)
		var_14_1:texture(var_0_1[var_0_2[arg_14_0.barResOrderN + 1]])

		arg_14_0.bossLifeTotalCount = arg_14_0.bossLifeTotalCount - 1

		arg_14_0.convStr:set("x" .. arg_14_0.bossLifeTotalCount)

		if arg_14_0.bossLifeTotalCount <= 1 then
			var_14_1:hide()
		end
	end

	local var_14_7 = transition.executeSequence(var_14_0):progressTo(var_14_5, var_14_4)

	if var_14_4 == 0 then
		var_14_7:func(var_14_6)
	end

	var_14_7:func(function()
		arg_14_0.isHPBarChanging = false
	end)
	var_14_7:done()
end

function var_0_3.onClose(arg_17_0)
	ViewBase.onClose(arg_17_0)
end

return var_0_3
