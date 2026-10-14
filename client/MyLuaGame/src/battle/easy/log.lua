function battleEasy.logHerosInfo(arg_1_0)
	lazylog.battle.gate.allHerosInfo(" ---- 打印双方角色血量和怒气信息：", function()
		for iter_2_0, iter_2_1 in arg_1_0.heros:order_pairs() do
			printDebug(" -- 己方: seat=%s, hp=%s, mp=%s", iter_2_1.seat, iter_2_1:hp(), iter_2_1:mp1())
		end

		for iter_2_2, iter_2_3 in arg_1_0.enemyHeros:order_pairs() do
			printDebug(" -- 敌方: seat=%s, hp=%s, mp=%s", iter_2_3.seat, iter_2_3:hp(), iter_2_3:mp1())
		end
	end)
end
