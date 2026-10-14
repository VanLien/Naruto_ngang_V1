local var_0_0 = math.abs
local var_0_1 = math.max
local var_0_2 = math.min
local var_0_3 = battle.PassiveSkillTypes

globals.GroupObjectModel = class("GroupObjectModel", ObjectModel)

for iter_0_0, iter_0_1 in pairs(ObjectAttrs.AttrsTable) do
	GroupObjectModel[iter_0_0] = function(arg_1_0)
		return arg_1_0.attrs:getFinalAttr(iter_0_0)
	end
end

local var_0_4 = 0
local var_0_5 = 200
local var_0_6 = {
	sound = {
		"sound"
	},
	shaker = {
		"shaker",
		"segInterval"
	},
	music = {
		"music"
	},
	move = {
		"move"
	},
	hpSeg = {
		"hpSeg",
		"segInterval"
	},
	effect = {
		"effectType",
		"effectRes",
		"effectArgs"
	},
	zOrder = {
		"zOrder"
	},
	follow = {
		"follow"
	},
	jump = {
		"jumpFlag"
	},
	control = {
		"control"
	}
}
local var_0_7 = {
	damageSeg = {
		"damageSeg",
		"segInterval"
	}
}

function GroupObjectModel.ctor(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.scene = arg_2_1
	arg_2_0.view = nil
	ObjectModel.IDCounter = ObjectModel.IDCounter + 1
	arg_2_0.id = ObjectModel.IDCounter
	arg_2_0.seat = battle.SpecialObjectId.teamShiled + arg_2_2 - 1
	arg_2_0.force = arg_2_2
	arg_2_0.faceTo = arg_2_0.force == 1 and 1 or -1
	arg_2_0.attrs = ObjectAttrs.new()
	arg_2_0.hpTable = {
		0,
		0,
		0
	}
	arg_2_0.buffs = {}
	arg_2_0.recordBuffDataTb = {}
	arg_2_0.viewAniList = CVector.new()
	arg_2_0.overlayCount = 1
end

function GroupObjectModel.init(arg_3_0)
	arg_3_0.unitID = 200000
	arg_3_0.state = battle.ObjectState.none
	arg_3_0.unitCfg = csvClone(csv.unit[arg_3_0.unitID])
	arg_3_0.cardID = arg_3_0.unitCfg.cardID
	arg_3_0.hpTable = {
		0,
		0,
		0
	}

	if not arg_3_0.unitCfg then
		error(string.format("no unit config id = %s", arg_3_0.unitID))
	end

	arg_3_0.stackPos = 0
	arg_3_0.totalDamage = {}
	arg_3_0.targetTotalDamage = {}
	arg_3_0.targetRateDamage = {}
	arg_3_0.attackerCurSkill = {}
	arg_3_0.processIdList = CVector.new()
	arg_3_0.scene.deadObjsToBeDeleted[arg_3_0.id] = nil
end

function GroupObjectModel.initView(arg_4_0)
	local var_4_0 = {
		type = battle.SpriteType.Normal
	}

	arg_4_0.view = gRootViewProxy:getProxy("onSceneAddObj", tostring(arg_4_0), readOnlyProxy(arg_4_0), var_4_0)

	arg_4_0.view:proxy():updateLifeBarState(false)
	arg_4_0.view:proxy():setVisible(false)
	arg_4_0.view:proxy():setVisibleEnable(false)
end

function GroupObjectModel.reloadUnit(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0:isDeath()

	arg_5_0.unitRes = arg_5_1 and arg_5_1.csvCfg.effectResPath and arg_5_1.csvCfg.effectResPath or arg_5_0.unitCfg.unitRes
	arg_5_0.state = battle.ObjectState.normal
	arg_5_0.attackerCurSkill = {}

	if arg_5_1 then
		if arg_5_1.csvCfg.buffActionEffect then
			arg_5_0.view:proxy():resetActionTab()

			for iter_5_0, iter_5_1 in csvMapPairs(arg_5_1.csvCfg.buffActionEffect) do
				arg_5_0.view:proxy():onPushAction(battle.SpriteActionTable[iter_5_0], iter_5_1)
			end
		end

		if arg_5_0.cfgId == nil or arg_5_0.cfgId ~= arg_5_1.cfgId then
			arg_5_0:hpMax(arg_5_1.buffValue)

			var_5_0 = true
		else
			arg_5_0:hpMax(math.max(arg_5_0:hp(), 0) + arg_5_1.buffValue)
		end

		arg_5_0.cfgId = arg_5_1.cfgId

		local var_5_1 = arg_5_1.csvCfg.specialVal and arg_5_1.csvCfg.specialVal[1] or {}

		arg_5_0.buffs = var_5_1.buffs or {}
		arg_5_0.addBuffsForce = var_5_1.force
		arg_5_0.addBuffsNums = var_5_1.nums
		arg_5_0.caster = arg_5_1.caster
	end

	if var_5_0 then
		if arg_5_0.scene.deadObjsToBeDeleted[arg_5_0.id] then
			arg_5_0.scene.deadObjsToBeDeleted[arg_5_0.id] = nil

			arg_5_0.viewAniList:pop_back()
		end

		arg_5_0.viewAniList:push_back(battle.ObjectState.normal)
		arg_5_0.scene:addCallBackToBattleTurn(function()
			arg_5_0:playStateView()
		end)
	end
end

function GroupObjectModel.hp(arg_7_0, arg_7_1)
	if not arg_7_1 then
		return arg_7_0.hpTable[1]
	end
end

function GroupObjectModel.setHP(arg_8_0, arg_8_1)
	if arg_8_1 then
		arg_8_0.hpTable[1] = arg_8_1 + arg_8_0:hp()
	end

	return arg_8_0.hpTable[1]
end

function GroupObjectModel.hpMax(arg_9_0, arg_9_1)
	if arg_9_1 then
		arg_9_0.hpTable[2] = arg_9_1
		arg_9_0.hpTable[1] = arg_9_1
	end

	return arg_9_0.hpTable[2]
end

function GroupObjectModel.isHit(arg_10_0, arg_10_1, arg_10_2)
	return true
end

function GroupObjectModel.getBattleRound(arg_11_0, arg_11_1)
	return arg_11_0.scene.play.curRound
end

function GroupObjectModel.getBattleRoundAllWave(arg_12_0, arg_12_1)
	return arg_12_0.scene.play.totalRound
end

function GroupObjectModel.pushRecordData(arg_13_0, arg_13_1, arg_13_2)
	arg_13_0.stackPos = arg_13_0.stackPos + 1
	arg_13_0.targetTotalDamage[arg_13_0.stackPos] = {}
	arg_13_0.totalDamage[arg_13_0.stackPos] = {}
	arg_13_0.targetRateDamage[arg_13_0.stackPos] = {}
end

function GroupObjectModel.popRecordData(arg_14_0, arg_14_1, arg_14_2)
	arg_14_0.processIdList:pop_back()

	if arg_14_0.stackPos > 0 then
		arg_14_0.targetTotalDamage[arg_14_0.stackPos] = nil
		arg_14_0.totalDamage[arg_14_0.stackPos] = nil
		arg_14_0.targetRateDamage[arg_14_0.stackPos] = nil
		arg_14_0.stackPos = arg_14_0.stackPos - 1
	end
end

function GroupObjectModel.syncView(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = arg_15_2.process.id
	local var_15_1 = arg_15_1.processEventCsv[var_15_0]

	arg_15_2.ignoreEvenet = arg_15_2.ignoreEvenet or {}
	arg_15_2.ignoreEvenet[arg_15_0.id] = var_0_6
	arg_15_2.otherTargets[arg_15_0.id] = arg_15_0

	if arg_15_0.totalDamage[arg_15_0.stackPos] and next(arg_15_0.totalDamage[arg_15_0.stackPos]) then
		arg_15_2.viewTargets = {}

		for iter_15_0, iter_15_1 in ipairs(arg_15_2.targets) do
			table.insert(arg_15_2.viewTargets, iter_15_1)
		end

		arg_15_2.otherTargets[arg_15_0.id] = nil

		if arg_15_3 then
			if arg_15_2.process.segType == battle.SkillSegType.damage and arg_15_0.totalDamage[arg_15_0.stackPos] and arg_15_0.totalDamage[arg_15_0.stackPos][var_15_0] and arg_15_0.totalDamage[arg_15_0.stackPos][var_15_0] > 0 then
				arg_15_2.ignoreEvenet = arg_15_2.ignoreEvenet or {}

				arg_15_0:switchToRealDamage(var_15_0)

				for iter_15_2, iter_15_3 in ipairs(var_15_1.segInterval) do
					local var_15_2 = iter_15_2 == table.length(var_15_1.segInterval)

					arg_15_0:dealGroupObjectSeg(arg_15_1, var_15_0, arg_15_2, iter_15_2, var_15_2)

					for iter_15_4, iter_15_5 in ipairs(arg_15_2.targets) do
						arg_15_2.ignoreEvenet[iter_15_5.id] = var_0_7
					end
				end

				table.insert(arg_15_2.viewTargets, arg_15_0)
			end
		else
			table.insert(arg_15_2.viewTargets, arg_15_0)
		end
	end

	if not arg_15_0:isDeath() and arg_15_0:hp() <= 0 then
		arg_15_0:setDead(arg_15_1.owner)
	end
end

function GroupObjectModel.dealGroupObjectSeg(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	local var_16_0 = arg_16_0.targetTotalDamage[arg_16_0.stackPos][arg_16_2][arg_16_0.id]
	local var_16_1 = battleEasy.valueTypeTable()
	local var_16_2 = arg_16_1:getTargetsFinalResult(arg_16_0.id, battle.SkillSegType.damage)

	if not arg_16_3.values[arg_16_0.id] then
		arg_16_3.values[arg_16_0.id] = {}
	end

	local var_16_3 = (gProcessEventCsv and gProcessEventCsv[arg_16_2]).damageSeg[arg_16_4]
	local var_16_4 = gRootViewProxy:proxy():pushDeferList(arg_16_1.id, arg_16_2, "groupObjectModel")
	local var_16_5 = {
		segId = arg_16_4,
		isLastSeg = arg_16_5
	}

	var_16_1:add(math.floor(var_16_3 * var_16_0))
	battleEasy.deferNotify(arg_16_0.view, "showHeadNumber", {
		typ = 0,
		num = var_16_1:get(),
		args = var_16_5
	})

	arg_16_3.ignoreEvenet[arg_16_0.id] = var_0_6
	arg_16_3.values[arg_16_0.id][arg_16_4] = arg_16_3.values[arg_16_0.id][arg_16_4] or {}
	arg_16_3.values[arg_16_0.id][arg_16_4].value = var_16_1
	arg_16_3.values[arg_16_0.id][arg_16_4].deferList = gRootViewProxy:proxy():popDeferList(var_16_4)

	var_16_2.real:add(var_16_1)
end

function GroupObjectModel.switchToRealDamage(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0.totalDamage[arg_17_0.stackPos][var_0_4]
	local var_17_1 = var_17_0 - (arg_17_0:hp() < 0 and math.abs(arg_17_0:hp()) or 0)

	if arg_17_0:hp() < 0 then
		for iter_17_0, iter_17_1 in pairs(arg_17_0.targetTotalDamage[arg_17_0.stackPos][arg_17_1]) do
			arg_17_0.targetTotalDamage[arg_17_0.stackPos][arg_17_1][iter_17_0] = iter_17_1 / var_17_0 * (var_17_0 - var_17_1)
		end
	else
		arg_17_0.targetTotalDamage[arg_17_0.stackPos][arg_17_1] = {}
	end

	arg_17_0.targetTotalDamage[arg_17_0.stackPos][arg_17_1][arg_17_0.id] = arg_17_0.totalDamage[arg_17_0.stackPos][arg_17_1] / var_17_0 * var_17_1
end

function GroupObjectModel.beAttack(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = arg_18_3.valueF
	local var_18_1 = arg_18_3.args

	logf.battle.object.groupShield("全护盾  %d 攻击 当前hp %f - damage %f => 最终hp %f", arg_18_1 and arg_18_1.seat, arg_18_0:hp(), var_18_0, arg_18_0:hp() - var_18_0)

	if var_18_0 > 0 and not arg_18_0:isDeath() and not var_18_1.ignoreGroupShiled then
		arg_18_0:setHP(-var_18_0)

		if var_18_1.processId then
			if var_18_1.processId ~= arg_18_0.processIdList:back() then
				arg_18_0:pushRecordData()
				arg_18_0.processIdList:push_back(var_18_1.processId)
			end

			arg_18_0:saveTargetDamage(arg_18_2.id, var_18_0, var_18_1.processId)
			arg_18_0:saveProcessDamage(var_18_0, var_18_1.processId)
		end

		if var_18_1.from == battle.DamageFrom.skill then
			return var_18_0
		elseif var_18_1.processId then
			if var_18_1.isProcessState.isEnd then
				local var_18_2 = arg_18_0.targetTotalDamage[arg_18_0.stackPos][var_0_4]
				local var_18_3 = arg_18_0.totalDamage[arg_18_0.stackPos][var_18_1.processId]
				local var_18_4 = arg_18_0:hp() < 0 and math.abs(arg_18_0:hp()) or var_18_3
				local var_18_5 = clone(var_18_1)
				local var_18_6

				var_18_5.ignoreGroupShiled = true

				for iter_18_0, iter_18_1 in arg_18_0.scene:ipairsHeros() do
					if iter_18_1 and not iter_18_1:isAlreadyDead() and var_18_2[iter_18_1.id] then
						iter_18_1:beAttack(arg_18_1, var_18_4 * (var_18_2[iter_18_1.id] / var_18_3), arg_18_3.id, var_18_5)
					end
				end

				if arg_18_0:hp() < 0 then
					arg_18_0:setDead(arg_18_1)
				end

				arg_18_0:popRecordData()
			end

			return var_18_0
		elseif arg_18_0:hp() + var_18_0 > 0 then
			if arg_18_0:hp() < 0 then
				arg_18_0:setDead(arg_18_1)

				return var_18_0 + arg_18_0:hp()
			else
				battleEasy.queueNotifyFor(arg_18_0.view, "showHeadNumber", {
					typ = 0,
					num = var_18_0,
					args = var_18_1
				})
				battleEasy.queueNotifyFor(arg_18_0.view, "eventEffect", "callback", {
					func = function()
						arg_18_0.view:proxy():beHit(0, 600)
						arg_18_0.view:proxy():addActionCompleteListener(function()
							arg_18_0.view:proxy():onPlayState(battle.SpriteActionTable.standby)
						end)
					end
				})

				return var_18_0
			end
		end
	end
end

function GroupObjectModel.saveTargetDamage(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = arg_21_0.targetTotalDamage[arg_21_0.stackPos][arg_21_3] or {}

	var_21_0[arg_21_1] = var_21_0[arg_21_1] or 0
	var_21_0[arg_21_1] = var_21_0[arg_21_1] + arg_21_2
	arg_21_0.targetTotalDamage[arg_21_0.stackPos][arg_21_3] = var_21_0
	arg_21_0.targetTotalDamage[arg_21_0.stackPos][var_0_4] = arg_21_0.targetTotalDamage[arg_21_0.stackPos][var_0_4] or {}
	arg_21_0.targetTotalDamage[arg_21_0.stackPos][var_0_4][arg_21_1] = arg_21_0.targetTotalDamage[arg_21_0.stackPos][var_0_4][arg_21_1] or 0
	arg_21_0.targetTotalDamage[arg_21_0.stackPos][var_0_4][arg_21_1] = arg_21_0.targetTotalDamage[arg_21_0.stackPos][var_0_4][arg_21_1] + arg_21_2
end

function GroupObjectModel.saveProcessDamage(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = (arg_22_0.totalDamage[arg_22_0.stackPos][arg_22_2] or 0) + arg_22_1

	arg_22_0.totalDamage[arg_22_0.stackPos][arg_22_2] = var_22_0
	arg_22_0.totalDamage[arg_22_0.stackPos][var_0_4] = arg_22_0.totalDamage[arg_22_0.stackPos][var_0_4] or 0
	arg_22_0.totalDamage[arg_22_0.stackPos][var_0_4] = arg_22_0.totalDamage[arg_22_0.stackPos][var_0_4] + arg_22_1
end

function GroupObjectModel.setDead(arg_23_0, arg_23_1)
	if arg_23_0:isDeath() then
		return
	end

	arg_23_0.state = battle.ObjectState.realDead
	arg_23_0.attackMeDeadObj = arg_23_1

	if not arg_23_0.scene.deadObjsToBeDeleted[arg_23_0.id] then
		arg_23_0.viewAniList:push_back(battle.ObjectState.realDead)
	end

	arg_23_0.scene:addObjToBeDeleted(arg_23_0)
	arg_23_0:dispatchBuffToHeros()
end

function GroupObjectModel.dispatchBuffToHeros(arg_24_0)
	local var_24_0 = {
		isSceneBuff = true,
		lifeRound = 1,
		prob = 1,
		buffValue1 = 0,
		value = {
			arg_24_0.force,
			arg_24_0.attackMeDeadObj and arg_24_0.attackMeDeadObj.seat or 0
		}
	}
	local var_24_1 = gRootViewProxy:proxy():pushDeferList(arg_24_0.id, "realDead")

	for iter_24_0, iter_24_1 in ipairs(arg_24_0.buffs) do
		local var_24_2 = 0

		for iter_24_2, iter_24_3 in arg_24_0.scene:ipairsHeros() do
			if (iter_24_3.force == arg_24_0.force and arg_24_0.addBuffsForce ~= 2 or iter_24_3.force ~= arg_24_0.force and arg_24_0.addBuffsForce ~= 1) and addBuffToHero(iter_24_1, iter_24_3, arg_24_0.caster, var_24_0) then
				var_24_2 = var_24_2 + 1
			end

			if var_24_2 == arg_24_0.addBuffsNums then
				break
			end
		end
	end

	arg_24_0.scene:addListViewToBattleTurn(arg_24_0, gRootViewProxy:proxy():popDeferList(var_24_1))
end

function GroupObjectModel.isDeath(arg_25_0)
	return arg_25_0.state == battle.ObjectState.realDead or arg_25_0.state == battle.ObjectState.none
end

function GroupObjectModel.isInStealth(arg_26_0, arg_26_1)
	return false
end

function GroupObjectModel.isAttackableStealth(arg_27_0)
	return false
end

function GroupObjectModel.getShieldHp(arg_28_0)
	if arg_28_0:isDeath() then
		return 0
	end

	if arg_28_0:hp() < 0 then
		return 0
	end

	return arg_28_0:hp()
end

function GroupObjectModel.playStateView(arg_29_0)
	if arg_29_0.viewAniList:size() == 0 then
		return
	end

	local var_29_0 = arg_29_0.viewAniList:pop_front()

	if var_29_0 == battle.ObjectState.normal then
		arg_29_0.view:proxy():onReloadUnit("effectLayer")
		arg_29_0.view:proxy():setVisibleEnable(true)
		arg_29_0.view:proxy():setVisible(true)
	elseif var_29_0 == battle.ObjectState.realDead and arg_29_0.viewAniList:size() == 0 then
		battleEasy.effect(arg_29_0, "effect", {
			action = battle.SpriteActionTable.death,
			onComplete = function()
				arg_29_0.view:proxy():setVisible(false)
				arg_29_0.view:proxy():setVisibleEnable(false)
			end
		})
	end
end

function GroupObjectModel.toHumanString(arg_31_0)
	return string.format("GroupObjectModel: %s(%s)", arg_31_0.id, arg_31_0.seat)
end
