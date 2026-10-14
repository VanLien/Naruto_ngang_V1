local var_0_0 = class("ObjectManager", battleModule.CBase)

function var_0_0.ctor(arg_1_0, arg_1_1)
	battleModule.CBase.ctor(arg_1_0, arg_1_1)

	arg_1_0.gameLayer = arg_1_0.parent.gameLayer
	arg_1_0.deleteObjLayer = arg_1_0.parent.deleteObjLayer
	arg_1_0.units = {}
	arg_1_0.unitIds = {}
	arg_1_0.unitsInSeat = {}
	arg_1_0.updateUnits = {}
	arg_1_0.updateDirty = true
end

function var_0_0.onClose(arg_2_0)
	arg_2_0.units = {}
	arg_2_0.unitIds = {}
	arg_2_0.unitsInSeat = {}
	arg_2_0.updateUnits = {}
	arg_2_0.updateDirty = true
end

function var_0_0.onSceneAddObj(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0
	local var_3_1

	if arg_3_3.type == battle.SpriteType.Normal then
		var_3_0 = BattleSprite.new(arg_3_0.parent, arg_3_2, arg_3_1, arg_3_3)
		var_3_1 = arg_3_2.seat < 13
	elseif arg_3_3.type == battle.SpriteType.Possess then
		var_3_0 = BattlePossessSprite.new(arg_3_0.parent, arg_3_2, arg_3_1, arg_3_3)
		var_3_1 = false
	elseif arg_3_3.type == battle.SpriteType.Follower then
		var_3_0 = BattleFollowerSprite.new(arg_3_0.parent, arg_3_2, arg_3_1, arg_3_3)
		var_3_1 = false
	end

	var_3_0:init()
	var_3_0:onAddToScene()
	arg_3_0.gameLayer:addChild(var_3_0)

	arg_3_0.units[arg_3_1] = var_3_0

	if var_3_1 then
		arg_3_0.unitIds[arg_3_2.id] = var_3_0
		arg_3_0.unitsInSeat[arg_3_1] = var_3_0
	end

	if var_3_0.onFixedUpdate then
		arg_3_0.updateUnits[arg_3_1] = var_3_0
	end

	arg_3_0.updateDirty = true

	return var_3_0
end

function var_0_0.onSceneDeadObj(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0.units[arg_4_1]

	if var_4_0 then
		local function var_4_1()
			arg_4_0:onSceneDelObj(arg_4_1)
		end

		var_4_0:onDead("effect/death.skel", var_4_1)
	end
end

function var_0_0.onSceneDelObj(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.units[arg_6_1]

	if var_6_0 then
		arg_6_0.units[arg_6_1] = nil
		arg_6_0.unitsInSeat[arg_6_1] = nil
		arg_6_0.updateUnits[arg_6_1] = nil
		arg_6_0.updateDirty = true

		local var_6_1 = arg_6_0.unitIds[var_6_0.id]

		if var_6_1 and var_6_1.key == arg_6_1 then
			arg_6_0.unitIds[var_6_0.id] = nil
		end

		if var_6_0.__vmproxy then
			var_6_0.__vmproxy:modelOnly({
				getMovePosZ = function()
					return 0
				end
			})

			var_6_0.__vmproxy = nil
		end

		var_6_0:sceneDelObj(arg_6_0.deleteObjLayer)
	end
end

function var_0_0.onSceneEndPlayAni(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_1 == "win" and 1 or 2

	for iter_8_0, iter_8_1 in pairs(arg_8_0.units) do
		if arg_8_0.unitsInSeat[iter_8_0] then
			if iter_8_1.force == var_8_0 then
				iter_8_1:setActionState("win_loop")
			else
				iter_8_1:setActionState(battle.SpriteActionTable.standby)
			end
		else
			iter_8_1:setVisible(false)
		end
	end
end

function var_0_0.onShowHero(arg_9_0, arg_9_1)
	if arg_9_1 then
		local var_9_0 = arg_9_1.typ == "showAll"

		for iter_9_0, iter_9_1 in pairs(arg_9_0.units) do
			iter_9_1:showHero(var_9_0, arg_9_1)
		end
	end
end

function var_0_0.onUpdate(arg_10_0, arg_10_1)
	for iter_10_0, iter_10_1 in pairs(arg_10_0.updateUnits) do
		iter_10_1:onFixedUpdate(arg_10_1)
	end

	if not arg_10_0.updateDirty then
		return
	end

	local var_10_0 = 0

	for iter_10_2, iter_10_3 in pairs(arg_10_0.units) do
		if iter_10_3 and iter_10_3:onUpdate(arg_10_1) then
			var_10_0 = var_10_0 + 1
		end
	end

	arg_10_0.updateDirty = var_10_0 > 0
end

function var_0_0.onEffectUpdated(arg_11_0)
	arg_11_0.updateDirty = true
end

function var_0_0.getSceneObjs(arg_12_0)
	return arg_12_0.unitsInSeat
end

function var_0_0.getSceneAllObjs(arg_13_0)
	return arg_13_0.units
end

function var_0_0.getSceneObj(arg_14_0, arg_14_1)
	return arg_14_0.units[arg_14_1]
end

function var_0_0.getSceneObjBySeat(arg_15_0, arg_15_1, arg_15_2)
	arg_15_2 = arg_15_2 or battle.SpriteType.Normal

	for iter_15_0, iter_15_1 in pairs(arg_15_0.unitIds) do
		if iter_15_1.seat == arg_15_1 and iter_15_1.type == arg_15_2 then
			return iter_15_1
		end
	end
end

function var_0_0.getSceneObjById(arg_16_0, arg_16_1)
	return arg_16_0.unitIds[arg_16_1]
end

function var_0_0.isObjExisted(arg_17_0, arg_17_1)
	return arg_17_0.units[arg_17_1] ~= nil
end

function var_0_0.onViewBeProxy(arg_18_0, arg_18_1, arg_18_2)
	for iter_18_0, iter_18_1 in pairs(arg_18_0.units) do
		if iter_18_1 == arg_18_1 then
			arg_18_1.__vmproxy = arg_18_2

			return
		end
	end
end

function var_0_0.onAddUnitsInSeat(arg_19_0, arg_19_1)
	if arg_19_0.unitsInSeat[arg_19_1] then
		return
	end

	arg_19_0.unitsInSeat[arg_19_1] = arg_19_0.units[arg_19_1]
end

function var_0_0.onSceneClearAll(arg_20_0)
	for iter_20_0, iter_20_1 in pairs(arg_20_0.units) do
		arg_20_0:onSceneDelObj(iter_20_0)
	end

	arg_20_0.units = {}
	arg_20_0.unitIds = {}
	arg_20_0.unitsInSeat = {}
	arg_20_0.updateDirty = true
end

return var_0_0
