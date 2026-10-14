globals.__TestDefine = {}
__TestDefine.CallState = {
	enter = 1,
	exit = 2
}
__TestDefine.MonitorFunc = {}
__TestDefine.Monitor = false
__TestDefine.TestSceneID = 999999
__TestDefine.ReadRecordFolderPath = ".\\recordLog"
__TestDefine.historyBattleInfo = {}
__TestDefine.allHistoryBattleInfo = {}
__TestDefine.closeRandFix = false
__TestDefine.randSeedSwitch = false
__TestDefine.sameSpeedRandFix = false
__TestDefine.buffId = {}
__TestDefine.chProtocol = {}
__TestDefine.UnitRules = {
	{
		{
			check = "buffId == 1",
			typ = "buffTriggerTime",
			args = "lessE(time,1)"
		},
		{
			check = "buffId == 1",
			typ = "buffTriggerTime",
			args = "lessE(time,1)"
		}
	}
}

return __TestDefine
