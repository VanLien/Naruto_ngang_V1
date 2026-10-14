local var_0_0 = battleCsv.newCsvCls("CsvBuff")

battleCsv.CsvBuff = var_0_0

function var_0_0.getDispleState(arg_1_0)
	return arg_1_0.model:getEventByKey(battle.ExRecordEvent.dispelSuccess) or false
end

function var_0_0.getValue(arg_2_0)
	return arg_2_0.model.value
end

function var_0_0.getGroup(arg_3_0)
	return arg_3_0.model.csvCfg.group
end

function var_0_0.getCfgId(arg_4_0)
	return arg_4_0.model.cfgId
end

function var_0_0.getEasyEffectFunc(arg_5_0)
	return arg_5_0.model.csvCfg.easyEffectFunc
end

function var_0_0.getRecordDataTab(arg_6_0, arg_6_1)
	return arg_6_0.model:getEventByKey(battle.ExRecordEvent[arg_6_1]) or 0
end

function var_0_0.getValueIdx(arg_7_0, arg_7_1)
	return arg_7_0.model.value[arg_7_1]
end

function var_0_0.getLifeRound(arg_8_0)
	return arg_8_0.model.args.lifeRound
end

function var_0_0.getFinalLifeRound(arg_9_0)
	return arg_9_0.model:getLifeRound()
end

function var_0_0.getOverLayCount(arg_10_0)
	return arg_10_0.model:getOverLayCount()
end

function var_0_0.getCopyBuffState(arg_11_0)
	return arg_11_0.model:getEventByKey(battle.ExRecordEvent.copyState) or false
end

function var_0_0.getTransferBuffState(arg_12_0)
	return arg_12_0.model:getEventByKey(battle.ExRecordEvent.transferState) or false
end
