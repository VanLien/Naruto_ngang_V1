local var_0_0 = {}
local var_0_1 = game.BRAVE_CHALLENGE_TYPE
local var_0_2 = {
	main = {
		[var_0_1.anniversary] = "/game/yy/brave_challenge/main",
		[var_0_1.common] = "/game/brave_challenge/main"
	},
	preStart = {
		[var_0_1.anniversary] = "/game/yy/brave_challenge/prepare/start",
		[var_0_1.common] = "/game/brave_challenge/prepare/start"
	},
	preEnd = {
		[var_0_1.anniversary] = "/game/yy/brave_challenge/prepare/end",
		[var_0_1.common] = "/game/brave_challenge/prepare/end"
	},
	deploy = {
		[var_0_1.anniversary] = "/game/yy/brave_challenge/deploy",
		[var_0_1.common] = "/game/brave_challenge/deploy"
	},
	battleStart = {
		[var_0_1.anniversary] = "/game/yy/brave_challenge/battle/start",
		[var_0_1.common] = "/game/brave_challenge/battle/start"
	},
	battleEnd = {
		[var_0_1.anniversary] = "/game/yy/brave_challenge/battle/end",
		[var_0_1.common] = "/game/brave_challenge/battle/end"
	},
	choose = {
		[var_0_1.anniversary] = "/game/yy/brave_challenge/badge/choose",
		[var_0_1.common] = "/game/brave_challenge/badge/choose"
	},
	buy = {
		[var_0_1.anniversary] = "/game/yy/brave_challenge/buy",
		[var_0_1.common] = "/game/brave_challenge/buy"
	},
	quit = {
		[var_0_1.anniversary] = "/game/yy/brave_challenge/quit",
		[var_0_1.common] = "/game/brave_challenge/quit"
	},
	rank = {
		[var_0_1.anniversary] = "/game/yy/brave_challenge/rank",
		[var_0_1.common] = "/game/brave_challenge/rank"
	},
	award = {
		[var_0_1.anniversary] = "/game/yy/award/get",
		[var_0_1.common] = "/game/brave_challenge/award/get"
	}
}

function var_0_0.set(arg_1_0)
	var_0_0.typ = arg_1_0
end

function var_0_0.url(arg_2_0)
	return var_0_2[arg_2_0][var_0_0.typ]
end

return var_0_0
