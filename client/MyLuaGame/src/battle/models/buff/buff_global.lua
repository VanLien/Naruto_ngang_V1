globals.BuffGlobalModel = class("BuffGlobalModel")

local var_0_0 = {
	holderForce = 2,
	object = 1
}

function BuffGlobalModel.ctor(arg_1_0)
	arg_1_0.triggerType3Record = {
		{},
		{}
	}
	arg_1_0.damageLinkRecord = {}
	arg_1_0.buffLinkRecord = {}
	arg_1_0.buffTriggerTypeRecord = {}
	arg_1_0.triggerLimitRecordTb = {}

	for iter_1_0, iter_1_1 in pairs(var_0_0) do
		arg_1_0.triggerLimitRecordTb[iter_1_1] = {}
	end

	arg_1_0.cfgIdToLimitType = {}
	arg_1_0.effectToBuffs = {}
end

function BuffGlobalModel.setDamageLinkRecord(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	if not arg_2_0.damageLinkRecord[arg_2_2] then
		arg_2_0.damageLinkRecord[arg_2_2] = {}
	end

	arg_2_0.damageLinkRecord[arg_2_2][arg_2_1] = {
		value = arg_2_3,
		oneWay = arg_2_4,
		casterId = arg_2_5
	}
end

function BuffGlobalModel.cleanDamageLinkRecord(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.damageLinkRecord[arg_3_2][arg_3_1] = nil
end

function BuffGlobalModel.getDamageLinkObjs(arg_4_0, arg_4_1, arg_4_2)
	if not arg_4_0.damageLinkRecord[arg_4_2] then
		return {}
	end

	if arg_4_0.damageLinkRecord[arg_4_2][arg_4_1].oneWay == 1 then
		return {}
	end

	local var_4_0 = arg_4_0.damageLinkRecord[arg_4_2][arg_4_1].casterId
	local var_4_1 = {}

	for iter_4_0, iter_4_1 in pairs(arg_4_0.damageLinkRecord[arg_4_2]) do
		if iter_4_0 ~= arg_4_1 and iter_4_1.casterId == var_4_0 and iter_4_1.oneWay ~= 2 then
			table.insert(var_4_1, iter_4_0)
		end
	end

	table.sort(var_4_1)

	return var_4_1
end

function BuffGlobalModel.getDamageLinkValue(arg_5_0, arg_5_1, arg_5_2)
	if not arg_5_0.damageLinkRecord[arg_5_2] then
		return nil
	end

	return arg_5_0.damageLinkRecord[arg_5_2][arg_5_1].value
end

function BuffGlobalModel.setBuffLinkValue(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	if not arg_6_0.buffLinkRecord[arg_6_1] then
		arg_6_0.buffLinkRecord[arg_6_1] = {}
	end

	arg_6_0.buffLinkRecord[arg_6_1][arg_6_2] = {
		fixValue = arg_6_3,
		groups = arg_6_4,
		cfgId = arg_6_5
	}
end

function BuffGlobalModel.getAllBuffLinkValue(arg_7_0, arg_7_1)
	return arg_7_0.buffLinkRecord[arg_7_1]
end

function BuffGlobalModel.onBuffLinkOver(arg_8_0, arg_8_1)
	local var_8_0 = {}

	for iter_8_0, iter_8_1 in pairs(arg_8_0.buffLinkRecord) do
		for iter_8_2, iter_8_3 in pairs(iter_8_1) do
			if iter_8_1.cfgId == arg_8_1 then
				table.insert(var_8_0, {
					srcObjID = iter_8_0,
					dstObjID = iter_8_2
				})
			end
		end
	end

	table.sort(var_8_0, function(arg_9_0, arg_9_1)
		if arg_9_0.srcObjID ~= arg_9_1.srcObjID then
			return arg_9_0.srcObjID < arg_9_1.srcObjID
		else
			return arg_9_0.dstObjID < arg_9_1.dstObjID
		end
	end)

	for iter_8_4, iter_8_5 in ipairs(var_8_0) do
		arg_8_0.buffLinkRecord[iter_8_5.srcObjID][iter_8_5.dstObjID] = nil
	end
end

function BuffGlobalModel.recordBuffTriggerType(arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_0.buffTriggerTypeRecord[arg_10_1] then
		arg_10_0.buffTriggerTypeRecord[arg_10_1] = {}
	end

	if not arg_10_0.buffTriggerTypeRecord[arg_10_1][arg_10_2] then
		arg_10_0.buffTriggerTypeRecord[arg_10_1][arg_10_2] = 1
	else
		arg_10_0.buffTriggerTypeRecord[arg_10_1][arg_10_2] = arg_10_0.buffTriggerTypeRecord[arg_10_1][arg_10_2] + 1
	end
end

function BuffGlobalModel.getBuffTriggerTime(arg_11_0, arg_11_1, arg_11_2)
	if not arg_11_0.buffTriggerTypeRecord[arg_11_1] then
		return 0
	end

	if not arg_11_0.buffTriggerTypeRecord[arg_11_1][arg_11_2] then
		return 0
	end

	return arg_11_0.buffTriggerTypeRecord[arg_11_1][arg_11_2]
end

function BuffGlobalModel.cleanBuffTriggerTimeRecord(arg_12_0)
	arg_12_0.buffTriggerTypeRecord = {}
end

function BuffGlobalModel.initBuffCfgLimit(arg_13_0, arg_13_1, arg_13_2)
	return {
		type = arg_13_2.type,
		limit = arg_13_2.limit
	}
end

function BuffGlobalModel.refreshBuffLimit(arg_14_0, arg_14_1, arg_14_2)
	if not arg_14_2.gateLimit then
		return
	end

	if not arg_14_0.cfgIdToLimitType[arg_14_2.cfgId] then
		arg_14_0.cfgIdToLimitType[arg_14_2.cfgId] = true

		for iter_14_0, iter_14_1 in ipairs(arg_14_2.gateLimit) do
			if iter_14_1.scenes then
				if itertools.include(iter_14_1.scenes, arg_14_1.gateType) then
					arg_14_0.cfgIdToLimitType[arg_14_2.cfgId] = arg_14_0:initBuffCfgLimit(arg_14_2.cfgId, iter_14_1)
				end
			else
				arg_14_0.cfgIdToLimitType[arg_14_2.cfgId] = arg_14_0:initBuffCfgLimit(arg_14_2.cfgId, iter_14_1)
			end
		end
	end

	if arg_14_0.cfgIdToLimitType[arg_14_2.cfgId] == true then
		return
	end

	local var_14_0 = arg_14_0.cfgIdToLimitType[arg_14_2.cfgId]

	if var_14_0.absForce and var_14_0.absForce ~= arg_14_2.holder.force and (var_14_0.type == var_0_0.object or var_14_0.type == var_0_0.holderForce) then
		arg_14_0.cfgIdToLimitType[arg_14_2.cfgId] = true

		return
	end

	local var_14_1

	if not arg_14_0.triggerLimitRecordTb[var_14_0.type][arg_14_2.cfgId] then
		arg_14_0.triggerLimitRecordTb[var_14_0.type][arg_14_2.cfgId] = {}
	end

	local var_14_2 = arg_14_0.triggerLimitRecordTb[var_14_0.type][arg_14_2.cfgId]
	local var_14_3
	local var_14_4 = arg_14_2.holder

	if var_14_0.type == var_0_0.object then
		var_14_2[var_14_4.id] = var_14_2[var_14_4.id] or {
			time = 0,
			limit = var_14_0.limit
		}
		var_14_3 = var_14_2[var_14_4.id]
	elseif var_14_0.type == var_0_0.holderForce then
		var_14_2[var_14_4.force] = var_14_2[var_14_4.force] or {
			time = 0,
			limit = var_14_0.limit
		}
		var_14_3 = var_14_2[var_14_4.force]
	end

	if var_14_3.time < var_14_3.limit then
		var_14_3.time = var_14_3.time + 1
	else
		var_14_3.time = var_14_3.limit
	end
end

function BuffGlobalModel.refreshBuffEffectNums(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_1.csvCfg.easyEffectFunc

	if not arg_15_0.effectToBuffs[var_15_0] then
		arg_15_0.effectToBuffs[var_15_0] = CVector.new()
	end

	while arg_15_2 <= arg_15_0.effectToBuffs[var_15_0]:size() do
		arg_15_0.effectToBuffs[var_15_0]:pop_front():over()
	end

	arg_15_0.effectToBuffs[var_15_0]:push_back(arg_15_1)
end

function BuffGlobalModel.checkBuffCanAdd(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0.cfgIdToLimitType[arg_16_1.cfgId]

	if not arg_16_1.csvCfg.gateLimit then
		return true
	end

	if not var_16_0 or var_16_0 == true then
		return true
	end

	local var_16_1 = arg_16_0.triggerLimitRecordTb[var_16_0.type][arg_16_1.cfgId]

	if not var_16_1 then
		return true
	end

	if var_16_0.type == var_0_0.object then
		if not var_16_1[arg_16_2.id] then
			return true
		end

		return var_16_1[arg_16_2.id].time < var_16_1[arg_16_2.id].limit
	elseif var_16_0.type == var_0_0.holderForce then
		if not var_16_1[arg_16_2.force] then
			return true
		end

		return var_16_1[arg_16_2.force] and var_16_1[arg_16_2.force].time < var_16_1[arg_16_2.force].limit
	end

	return true
end
