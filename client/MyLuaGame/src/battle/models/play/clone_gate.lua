local var_0_0 = class("CloneGate", battlePlay.Gate)

battlePlay.CloneGate = var_0_0
var_0_0.OperatorArgs = {
	canHandle = true,
	isAuto = false,
	isFullManual = false,
	canSpeedAni = true,
	canPause = true,
	canSkip = true
}

function var_0_0.init(arg_1_0, arg_1_1)
	if dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.BattleSkip, game.GATE_TYPE.clone) then
		arg_1_0.OperatorArgs.canSkip = true
	end

	battlePlay.Gate.init(arg_1_0, arg_1_1)
end

function var_0_0.newWaveAddObjsStrategy(arg_2_0)
	arg_2_0:addCardRoles(1)
	arg_2_0:addCardRoles(2)
	arg_2_0:doObjsAttrsCorrect(true, true)
	battlePlay.Gate.newWaveAddObjsStrategy(arg_2_0)
end

function var_0_0.postEndResultToServer(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0:makeEndViewInfos()
	local var_3_1 = gRootViewProxy:raw()

	local function var_3_2(arg_4_0)
		if not var_3_1.modes.fromRecordFile then
			var_3_0.freeBox = arg_4_0.view.freeBox
		end

		arg_3_1(var_3_0, arg_4_0)
	end

	var_3_1:postEndResultToServer("/game/clone/battle/end", {
		cb = var_3_2,
		onErrClose = function(arg_5_0)
			if arg_5_0 and arg_5_0.err ~= "cloneRoomOutDate" and arg_5_0.err ~= "ErrCloneRoomNotExists" then
				return
			end

			gGameUI:switchUI("city.view")
			gGameUI:goBackInStackUI("city.adventure.clone_battle.base")
		end
	}, var_3_0.result)
end

function var_0_0.getMonsterCsv(arg_6_0, arg_6_1, arg_6_2)
	arg_6_1 = arg_6_1 or arg_6_0.scene.sceneID

	return csvClone(gMonsterCsv[arg_6_1][1])
end

local var_0_1 = class("CloneGateRecord", var_0_0)

battlePlay.CloneGateRecord = var_0_1
var_0_1.OperatorArgs = {
	canHandle = false,
	isAuto = true,
	isFullManual = false,
	canSpeedAni = true,
	canPause = true,
	canSkip = true
}

function var_0_1.init(arg_7_0, arg_7_1)
	battlePlay.Gate.init(arg_7_0, arg_7_1)
end
