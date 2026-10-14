require("battle.models.buff.buff_node")
require("battle.models.buff.buff_global")
require("battle.models.buff.buff")
require("battle.models.buff.buff_effect")
require("battle.models.buff.buff_args")
require("battle.models.buff.spec.aura_buff")

local var_0_0 = 999999
local var_0_1 = true
local var_0_2 = {}
local var_0_3

var_0_3 = {
	[battle.BuffOverlayType.Normal] = function(arg_1_0, arg_1_1)
		return var_0_1, false
	end,
	[battle.BuffOverlayType.Cover] = function(arg_2_0, arg_2_1)
		if arg_2_0.isAuraType then
			return var_0_1, false, true
		end

		return var_0_1, true, true
	end,
	[battle.BuffOverlayType.Overlay] = function(arg_3_0, arg_3_1)
		if arg_3_0:getOverLayCount() < arg_3_1.overlayLimit then
			return var_0_1, false, true
		end

		return var_0_1, false, true
	end,
	[battle.BuffOverlayType.OverlayDrop] = function(arg_4_0, arg_4_1)
		if arg_4_0:getOverLayCount() < arg_4_1.overlayLimit then
			return var_0_1, false, true
		end

		return var_0_1, false, false
	end,
	[battle.BuffOverlayType.CoverValue] = function(arg_5_0, arg_5_1)
		local var_5_0 = var_0_2.args.value
		local var_5_1 = arg_5_0.args.value

		if type(var_5_0) == "number" and type(var_5_1) == "number" then
			if math.abs(var_5_0) <= math.abs(var_5_1) then
				return var_0_1, false
			end

			return var_0_1, true, true
		else
			errorInWindows("buff check overlay %d, old %s, new %s", arg_5_1.overlayType, var_5_0, var_5_1)
		end
	end,
	[battle.BuffOverlayType.CoverLifeRound] = function(arg_6_0, arg_6_1)
		local var_6_0 = var_0_2.args.lifeRound
		local var_6_1 = arg_6_0.args.lifeRound

		if type(var_6_0) == "number" and type(var_6_1) == "number" then
			if var_6_0 <= var_6_1 then
				return var_0_1, false
			end

			return var_0_1, true, true
		else
			errorInWindows("buff check overlay %d, old %s, new %s", arg_6_1.overlayType, var_6_0, var_6_1)
		end
	end,
	[battle.BuffOverlayType.IndeLifeRound] = function(arg_7_0, arg_7_1)
		if arg_7_0:getOverLayCount() < arg_7_1.overlayLimit then
			return var_0_1, false, true
		end

		return var_0_1, false
	end,
	[battle.BuffOverlayType.Coexist] = function(arg_8_0, arg_8_1)
		if var_0_3.CoexistLessCheck(arg_8_1) then
			return var_0_1, true, true
		end

		return var_0_1, false
	end,
	[battle.BuffOverlayType.CoexistLifeRound] = function(arg_9_0, arg_9_1)
		if var_0_3.CoexistLessCheck(arg_9_1) then
			return var_0_1, true, true
		end

		return var_0_1, false, true
	end,
	CoexistLessCheck = function(arg_10_0)
		local var_10_0 = var_0_2.cfgId

		if var_0_2.holder.buffOverlayCount[var_10_0] < arg_10_0.overlayLimit then
			return true
		end
	end
}

local var_0_4 = {
	function(arg_11_0, arg_11_1)
		if not arg_11_0 or arg_11_0:isRealDeath() then
			return var_0_1, false
		end
	end,
	function(arg_12_0, arg_12_1)
		local var_12_0 = var_0_2.caster

		if var_0_2.args.isAuraType and (not var_12_0 or var_12_0:isDeath()) then
			return var_0_1, false
		end
	end,
	function(arg_13_0, arg_13_1)
		local var_13_0 = var_0_2.caster
		local var_13_1 = var_13_0 and var_13_0.id or 0

		if not arg_13_0:checkBuffCanBeAdd(var_13_1, arg_13_1.ignoreCaster, arg_13_1.ignoreHolder) then
			return var_0_1, false
		end
	end,
	function(arg_14_0, arg_14_1)
		local var_14_0 = var_0_2.cfgId

		if not arg_14_0.scene.buffGlobalManager:checkBuffCanAdd({
			csvCfg = arg_14_1,
			cfgId = var_14_0
		}, arg_14_0) then
			return var_0_1, false
		end
	end,
	function(arg_15_0, arg_15_1)
		local var_15_0 = var_0_2.caster
		local var_15_1 = var_0_2.args.prob
		local var_15_2 = 0
		local var_15_3 = 0
		local var_15_4 = 0
		local var_15_5 = 0
		local var_15_6

		local function var_15_7(arg_16_0, arg_16_1, arg_16_2)
			local var_16_0 = arg_16_1
			local var_16_1

			if arg_15_1.ignoreControlVal == 1 then
				return var_16_0
			end

			for iter_16_0, iter_16_1 in arg_16_2:ipairsOverlaySpecBuff(arg_16_0) do
				local var_16_2

				var_16_0, var_16_2 = iter_16_1.refreshProb(var_16_0, arg_15_1.group)
				var_15_6 = var_15_6 or var_16_2
			end

			return var_16_0
		end

		local var_15_8 = battleEasy.groupReltaionInclude(gBuffGroupRelationCsv[var_0_0].immuneGroup, arg_15_1.group)

		if var_15_8 then
			var_15_3 = var_15_3 + arg_15_0:immuneControl()
		end

		local var_15_9 = var_15_7("immuneControlVal", var_15_3, arg_15_0)
		local var_15_10 = var_15_7("immuneControlAdd", var_15_2, arg_15_0)

		if var_15_0 then
			if var_15_8 then
				var_15_5 = var_15_5 + var_15_0:controlPer()
			end

			var_15_5 = var_15_7("controlPerVal", var_15_5, var_15_0)
			var_15_4 = var_15_7("controlPerAdd", var_15_4, var_15_0)
		end

		local var_15_11

		var_15_11 = var_15_1 > 0 and (var_15_1 + var_15_5 - var_15_9) * (1 + var_15_4 - var_15_10) or 0

		local var_15_12 = math.max(math.min(var_15_11, 1), 0)

		if var_15_12 < 1 and var_15_12 < ymrand.random() then
			if var_15_6 then
				battleEasy.deferNotifyCantJump(arg_15_0.view, "showBuffImmuneEffect", var_15_6)
			end

			return var_0_1, false
		end
	end,
	function(arg_17_0, arg_17_1)
		local var_17_0 = var_0_2.cfgId
		local var_17_1 = arg_17_0.scene
		local var_17_2 = var_17_1.play

		if var_17_1:isCraftGateType() then
			local var_17_3 = var_17_2.craftBuffAddTimes[var_17_0] and var_17_2.craftBuffAddTimes[var_17_0][arg_17_0.force] or 0
			local var_17_4 = var_17_1.gateType
			local var_17_5

			if arg_17_1.craftTriggerLimit then
				for iter_17_0, iter_17_1 in ipairs(arg_17_1.craftTriggerLimit) do
					if type(iter_17_1) == "number" then
						var_17_5 = iter_17_1
					else
						var_17_4, var_17_5 = iter_17_1[1], iter_17_1[2]
					end

					if var_17_4 == var_17_1.gateType and var_17_3 and var_17_3 >= (var_17_5 or math.huge) then
						return var_0_1, false
					end
				end
			end
		end
	end,
	function(arg_18_0, arg_18_1)
		local var_18_0 = var_0_2.cfgId
		local var_18_1 = var_0_2.args
		local var_18_2 = csv.buff_group_power[arg_18_1.groupPower]

		var_18_1.effectBuffs = {}

		if not arg_18_0:checkBuffCanAdd(var_18_0, arg_18_1.group, var_18_2) then
			return var_0_1, false
		end

		for iter_18_0, iter_18_1 in arg_18_0:iterBuffs() do
			if iter_18_1.cfgId == var_18_0 then
				var_0_2.holderBuff = var_0_2.holderBuff or iter_18_1

				table.insert(var_18_1.effectBuffs, iter_18_1)
			end
		end
	end,
	function(arg_19_0, arg_19_1)
		if var_0_2.holderBuff then
			return var_0_3[arg_19_1.overlayType](var_0_2.holderBuff, arg_19_1)
		end
	end
}

local function var_0_5(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = csv.buff[arg_20_0]

	if not var_20_0 then
		return false
	end

	if arg_20_3.isSceneBuff then
		return true
	end

	var_0_2 = {
		cfgId = arg_20_0,
		holder = arg_20_1,
		caster = arg_20_2,
		args = arg_20_3
	}

	for iter_20_0, iter_20_1 in ipairs(var_0_4) do
		local var_20_1, var_20_2, var_20_3 = iter_20_1(arg_20_1, var_20_0)

		if var_20_1 then
			return var_20_2, var_20_3
		end
	end

	return true, true
end

local function var_0_6(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = arg_21_3.effectBuffs

	if not var_21_0 then
		return
	end

	local var_21_1 = csv.buff[arg_21_0]
	local var_21_2 = true

	for iter_21_0, iter_21_1 in ipairs(var_21_0) do
		if var_21_1.overlayType == battle.BuffOverlayType.Cover then
			if iter_21_1.isAuraType then
				return
			end

			iter_21_1:over({
				endType = battle.BuffOverType.overlay
			})
		elseif var_21_1.overlayType == battle.BuffOverlayType.Overlay or var_21_1.overlayType == battle.BuffOverlayType.OverlayDrop then
			if iter_21_1:getOverLayCount() < var_21_1.overlayLimit then
				iter_21_1:refresh(arg_21_3, 1)
			elseif iter_21_1:getOverLayCount() == var_21_1.overlayLimit and var_21_1.overlayType == battle.BuffOverlayType.Overlay then
				iter_21_1:refresh(arg_21_3)
			end
		elseif var_21_1.overlayType == battle.BuffOverlayType.CoverValue then
			local var_21_3 = arg_21_3.value
			local var_21_4 = iter_21_1.args.value

			if type(var_21_3) == "number" and iter_21_1.isNumberType and math.abs(var_21_3) > math.abs(var_21_4) then
				iter_21_1:over({
					endType = battle.BuffOverType.overlay
				})
			end
		elseif var_21_1.overlayType == battle.BuffOverlayType.CoverLifeRound then
			local var_21_5 = arg_21_3.lifeRound
			local var_21_6 = iter_21_1.args.lifeRound

			if type(var_21_5) == "number" and type(var_21_6) == "number" and var_21_6 < var_21_5 then
				iter_21_1:over({
					endType = battle.BuffOverType.overlay
				})
			end
		elseif var_21_1.overlayType == battle.BuffOverlayType.IndeLifeRound then
			iter_21_1:refresh(arg_21_3, 1)
		elseif var_21_1.overlayType == battle.BuffOverlayType.Coexist then
			if arg_21_1.buffOverlayCount[arg_21_0] < var_21_1.overlayLimit and var_21_2 then
				arg_21_1.buffOverlayCount[arg_21_0] = arg_21_1.buffOverlayCount[arg_21_0] + 1
			end
		elseif var_21_1.overlayType == battle.BuffOverlayType.CoexistLifeRound then
			if arg_21_1.buffOverlayCount[arg_21_0] < var_21_1.overlayLimit and var_21_2 then
				arg_21_1.buffOverlayCount[arg_21_0] = arg_21_1.buffOverlayCount[arg_21_0] + 1
			end

			iter_21_1:refresh(arg_21_3, 1)
		end

		var_21_2 = false
	end
end

local function var_0_7(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0.scene.buffGlobalManager:getAllBuffLinkValue(arg_22_0.id)

	if not var_22_0 or not next(var_22_0) then
		return {}
	end

	local var_22_1 = {}

	for iter_22_0, iter_22_1 in pairs(var_22_0) do
		if iter_22_1.cfgId == arg_22_1 and (type(iter_22_1.groups) == "number" or itertools.include(iter_22_1.groups, arg_22_2)) then
			table.insert(var_22_1, {
				key = iter_22_0,
				val = iter_22_1
			})
		end
	end

	table.sort(var_22_1, function(arg_23_0, arg_23_1)
		return arg_23_0.key < arg_23_1.key
	end)

	return var_22_1
end

local function var_0_8(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = {}
	local var_24_1 = csv.buff[arg_24_0]
	local var_24_2 = csv.buff_group_power[var_24_1.groupPower]
	local var_24_3 = arg_24_0
	local var_24_4
	local var_24_5
	local var_24_6 = false
	local var_24_7 = false

	while true do
		local var_24_8 = false

		if var_24_2.beChange == 1 and arg_24_1:checkOverlaySpecBuffExit(battle.OverlaySpecBuff.transformAttrBuff) then
			for iter_24_0, iter_24_1 in arg_24_1:ipairsOverlaySpecBuff(battle.OverlaySpecBuff.transformAttrBuff) do
				if not var_24_0[iter_24_1.cfgId] then
					local var_24_9, var_24_10

					var_24_3, var_24_9, var_24_10 = iter_24_1.refreshCfgId(var_24_3, var_24_1.group)

					if var_24_3 ~= arg_24_0 and var_24_9 then
						if var_24_10 == "number" then
							arg_24_3.value = string.format("(%s)*%s", arg_24_3.value, var_24_9)
						else
							arg_24_3.value = string.format("%s", var_24_9)
						end

						var_24_0[iter_24_1.cfgId] = true
						var_24_8 = true

						break
					end
				end
			end
		end

		if var_24_8 then
			if not var_0_5(var_24_3, arg_24_1, arg_24_2, arg_24_3) then
				return nil
			end
		else
			break
		end

		arg_24_0 = var_24_3
		var_24_1 = csv.buff[arg_24_0]
		var_24_2 = csv.buff_group_power[var_24_1.groupPower]
	end

	return arg_24_0
end

local function var_0_9(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	if arg_25_3.isAuraType then
		return AuraBuffModel.new(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	end

	return BuffModel.new(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
end

local var_0_10 = {
	"value",
	"buffValueFormula"
}

local function var_0_11(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	do return end

	if not arg_26_3.skillCfg or not arg_26_3.skillCfg.isCombat then
		return
	end

	local var_26_0 = 3 - arg_26_2.force
	local var_26_1 = arg_26_1.scene.forceRecordTb[arg_26_2.force].totalFightPoint
	local var_26_2 = arg_26_1.scene.forceRecordTb[var_26_0].totalFightPoint
	local var_26_3 = 1
	local var_26_4

	if var_26_1 and var_26_2 and var_26_2 ~= 0 then
		var_26_3 = var_26_1 / var_26_2
		var_26_4 = math.max(var_26_1, var_26_2)
	end

	if var_26_3 >= 1 then
		return
	end

	local var_26_5 = csv.buff[arg_26_0]

	local function var_26_6(arg_27_0, arg_27_1)
		if var_26_3 >= arg_27_1.fightPointRate[1] or var_26_3 < arg_27_1.fightPointRate[2] then
			return false
		end

		if itertools.include(arg_27_1.excludeBuffID, arg_26_0) then
			return false
		end

		if not gCPCorrectionGroups[arg_27_0][var_26_5.group] then
			return false
		end

		if (arg_27_1.combatPowerLimit[arg_26_1.scene.gateType] or math.huge) > var_26_4 then
			return false
		end

		return true
	end

	for iter_26_0, iter_26_1 in orderCsvPairs(csv.combat_power_correction) do
		if var_26_6(iter_26_0, iter_26_1) then
			local var_26_7 = iter_26_1.buffValueRate
			local var_26_8 = iter_26_1.buffProbRate

			arg_26_3.prob = battleEasy.ifElse(arg_26_3.prob < 1, var_26_8, 0) + arg_26_3.prob

			if arg_26_4 then
				for iter_26_2, iter_26_3 in ipairs(var_0_10) do
					if arg_26_3[iter_26_3] and type(arg_26_3[iter_26_3]) ~= "table" then
						arg_26_3[iter_26_3] = string.format("(%s)*%s", arg_26_3[iter_26_3], var_26_7)
					end
				end
			end

			break
		end
	end
end

local function var_0_12(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = 0
	local var_28_1 = csv.buff[arg_28_0]

	for iter_28_0, iter_28_1 in arg_28_1:ipairsOverlaySpecBuff(battle.OverlaySpecBuff.changeBuffLifeRound) do
		var_28_0 = var_28_0 + iter_28_1.getExtraRound(var_28_1.group, arg_28_0)
	end

	arg_28_2.lifeRound = arg_28_2.lifeRound + var_28_0

	return var_28_0 ~= 0 and arg_28_2.lifeRound <= 0
end

local var_0_13 = {}

local function var_0_14(arg_29_0, arg_29_1, arg_29_2)
	var_0_13[arg_29_0] = var_0_13[arg_29_0] or 0
	var_0_13[arg_29_0] = var_0_13[arg_29_0] + 1

	if var_0_13[arg_29_0] > 50 then
		var_0_13[arg_29_0] = nil

		errorInWindows("buff:%d cast stack overflow, from skill:%d, source:%s", arg_29_1, arg_29_2.fromSkillId or 0, arg_29_2.source or "")

		return true
	end

	return false
end

function globals.addBuffToHero(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	arg_30_1 = cow.proxyObject("holder", arg_30_1)
	arg_30_2 = cow.proxyObject("caster", arg_30_2)

	if arg_30_3.miss then
		return _, false
	end

	var_0_11(arg_30_0, arg_30_1, arg_30_2, arg_30_3)

	if var_0_12(arg_30_0, arg_30_1, arg_30_3) then
		return _, false
	end

	local var_30_0, var_30_1 = var_0_5(arg_30_0, arg_30_1, arg_30_2, arg_30_3)

	if var_30_1 then
		if not arg_30_3.isAuraType and var_30_0 then
			arg_30_0 = var_0_8(arg_30_0, arg_30_1, arg_30_2, arg_30_3)

			if not arg_30_0 then
				return _, true
			end
		end

		var_0_11(arg_30_0, arg_30_1, arg_30_2, arg_30_3, true)
		var_0_6(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	end

	if arg_30_3.isAuraType and arg_30_1:hasBuff(arg_30_0) then
		return _, var_30_1
	end

	if var_30_0 then
		local var_30_2 = string.format("%d_%d_%d", arg_30_0, arg_30_1 and arg_30_1.seat or 0, arg_30_2 and arg_30_2.seat or 0)

		if var_0_14(var_30_2, arg_30_0, arg_30_3) then
			return _, var_30_1
		end

		local var_30_3 = var_0_9(arg_30_0, arg_30_1, arg_30_2, arg_30_3)

		arg_30_1.scene.allBuffs:insert(var_30_3.id, var_30_3)

		if var_30_3.isFieldBuff then
			arg_30_1.scene.fieldBuffs:insert(var_30_3.id, var_30_3)
		end

		arg_30_1.buffs:insert(var_30_3.id, var_30_3)

		local var_30_4 = arg_30_1:getOverlaySpecBuffByIdx("changeToRandEnemyObj")

		if arg_30_2 and var_30_4 and arg_30_2.id == arg_30_1.id and var_30_4.changeUnitBuffs then
			table.insert(var_30_4.changeUnitBuffs, var_30_3.id)
		end

		var_30_3:init()
		arg_30_1:onBuffEffectedHolder(var_30_3)
		arg_30_1:triggerBuffOnPoint(battle.BuffTriggerPoint.onBuffBeAdd, var_30_3)

		local var_30_5 = var_0_7(arg_30_1, arg_30_0, var_30_3:group())
		local var_30_6 = arg_30_3.value

		if next(var_30_5) then
			for iter_30_0, iter_30_1 in ipairs(var_30_5) do
				local var_30_7 = var_30_6 * iter_30_1.val.fixValue
				local var_30_8 = iter_30_1.key
				local var_30_9 = arg_30_1.scene:getObjectExcludeDead(var_30_8)

				if var_30_9 then
					arg_30_3.value = var_30_7

					addBuffToHero(arg_30_0, var_30_9, arg_30_2, arg_30_3)
				end
			end
		end

		var_0_13[var_30_2] = nil

		return var_30_3, var_30_1
	end

	return _, var_30_1
end

function globals.addAuraBuffToHero(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	arg_31_3.isAuraType = true

	local var_31_0 = addBuffToHero(arg_31_0, arg_31_1, arg_31_2, arg_31_3)

	if var_31_0 and arg_31_2 and not arg_31_2:isDeath() then
		arg_31_2.auraBuffs:insert(var_31_0.id, var_31_0)
	end

	return var_31_0
end

function globals.addBuffToScene(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	local var_32_0 = arg_32_3.prob

	if var_32_0 < 1 and var_32_0 < ymrand.random() then
		return
	end

	local var_32_1 = var_0_9(arg_32_0, arg_32_1, arg_32_2, arg_32_3)

	if not arg_32_1.scene.buffGlobalManager:checkBuffCanAdd(var_32_1, arg_32_1) then
		return
	end

	var_32_1.isInited = true
	var_32_1.buffValue = clone(var_32_1:cfg2Value(var_32_1.args.value))
	var_32_1.showDispelEffect = false

	arg_32_1.scene.buffGlobalManager:refreshBuffLimit(arg_32_1.scene, var_32_1)
	arg_32_1.scene:initGroupObj(var_32_1)
end
