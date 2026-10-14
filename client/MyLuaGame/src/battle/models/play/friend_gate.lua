local var_0_0 = class("FriendGate", battlePlay.ArenaGate)

battlePlay.FriendGate = var_0_0

function var_0_0.postEndResultToServer(arg_1_0, arg_1_1)
	arg_1_1(arg_1_0:makeEndViewInfos())
end
