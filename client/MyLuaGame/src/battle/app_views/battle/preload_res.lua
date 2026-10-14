local var_0_0 = {}

local function var_0_1(arg_1_0, arg_1_1, arg_1_2)
	if arg_1_2.buffId == nil then
		return
	end

	for iter_1_0, iter_1_1 in pairs(arg_1_2.buffId) do
		if type(iter_1_1) == "number" then
			local var_1_0 = csv.buff[iter_1_1]

			if not var_1_0 then
				local var_1_1 = string.format("error: 预加载 [buff] 表资源时出错, 试图在该表中查找一个不存在的buffId=%s", iter_1_1)

				return errorInWindows(var_1_1)
			end

			if var_1_0.effectRes then
				arg_1_0[var_1_0.effectRes] = (arg_1_0[var_1_0.effectRes] or 0) + 1
			end

			if var_1_0.textResPath then
				arg_1_0[var_1_0.textResPath] = (arg_1_0[var_1_0.textResPath] or 0) + 1
			end

			if var_1_0.iconResPath then
				arg_1_0[var_1_0.iconResPath] = (arg_1_0[var_1_0.iconResPath] or 0) + 1
			end

			if var_1_0.playEffect then
				arg_1_0[var_1_0.playEffect] = (arg_1_0[var_1_0.playEffect] or 0) + 1
			end

			if var_1_0.fixShow then
				arg_1_0[var_1_0.fixShow] = (arg_1_0[var_1_0.fixShow] or 0) + 1
			end

			if var_1_0.easyEffectFunc == "change" then
				loadHeroUnit(arg_1_0, arg_1_1, arg_1_2.buffValue1[1])
			end
		end
	end
end

local function var_0_2(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = csv.skill_process[arg_2_2]

	if not var_2_0 then
		local var_2_1 = string.format("error: 预加载 [skill_process] 表资源时出错, 试图在该表中查找一个不存在的processId=%s", arg_2_2)

		return errorInWindows(var_2_1)
	end

	if var_2_0.effectRes then
		arg_2_0[var_2_0.effectRes] = (arg_2_0[var_2_0.effectRes] or 0) + 1
	end

	if var_2_0.shotEffect then
		arg_2_0[var_2_0.shotEffect] = (arg_2_0[var_2_0.shotEffect] or 0) + 1
	end

	var_0_1(arg_2_0, arg_2_1, var_2_0)

	if var_2_0.callerId ~= nil and var_2_0.callerId > 0 then
		loadHeroUnit(arg_2_0, arg_2_1, var_2_0.callerId)

		if var_2_0.callerEffect then
			arg_2_0[var_2_0.callerEffect] = (arg_2_0[var_2_0.callerEffect] or 0) + 1
		end
	end
end

local function var_0_3(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = csv.effect_event[arg_3_2]

	if not var_3_0 then
		local var_3_1 = string.format("error: 预加载 [effect_event] 表资源时出错, 试图在该表中查找一个不存在的eventID=%s", arg_3_2)

		return errorInWindows(var_3_1)
	end

	if var_3_0.sound then
		arg_3_1[var_3_0.sound.res] = true
	end

	if var_3_0.music then
		arg_3_1[var_3_0.music.res] = true
	end

	if var_3_0.effectRes then
		arg_3_0[var_3_0.effectRes] = (arg_3_0[var_3_0.effectRes] or 0) + 1
	end
end

local function var_0_4(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = csv.skill[arg_4_2]

	if not var_4_0 then
		local var_4_1 = string.format("error: 预加载 [skill] 表资源时出错, 试图在该表中查找一个不存在的skillId=%s", arg_4_2)

		return errorInWindows(var_4_1)
	end

	if var_4_0.skillProcess then
		for iter_4_0, iter_4_1 in pairs(var_4_0.skillProcess) do
			var_0_2(arg_4_0, arg_4_1, iter_4_1)
		end
	end

	for iter_4_2, iter_4_3 in ipairs(var_4_0.effectBigName) do
		if not string.find(iter_4_3, ".skel") and not string.find(iter_4_3, ".json") then
			local var_4_2 = "config/big_hero/skill/" .. iter_4_3 .. ".png"

			arg_4_0[var_4_2] = (arg_4_0[var_4_2] or 0) + 1
		end
	end

	if var_4_0.sound then
		arg_4_1[var_4_0.sound.res] = true
	end
end

local function var_0_5(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = csv.unit[arg_5_2]

	if not var_5_0 then
		local var_5_1 = string.format("error: 预加载 [unit] 表资源时出错, 试图在该表中查找一个不存在的unitId=%s", arg_5_2)

		return errorInWindows(var_5_1)
	end

	var_0_0[arg_5_2] = true
	arg_5_0[var_5_0.unitRes] = (arg_5_0[var_5_0.unitRes] or 0) + 1

	for iter_5_0, iter_5_1 in ipairs(var_5_0.skillList) do
		var_0_4(arg_5_0, arg_5_1, iter_5_1)
	end

	if var_5_0.deathSound then
		arg_5_1[var_5_0.deathSound] = true
	end
end

function globals.visitFightResources(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if arg_6_2.weatherTypeId then
		local var_6_0 = arg_6_2.weatherTypeId
		local var_6_1 = csv.weather

		if var_6_0 and var_6_1[var_6_0] then
			if var_6_1[var_6_0].iconRes then
				arg_6_0[var_6_1[var_6_0].iconRes] = (arg_6_0[var_6_1[var_6_0].iconRes] or 0) + 1
			end

			if var_6_1[var_6_0].effectRes then
				arg_6_0[var_6_1[var_6_0].effectRes] = (arg_6_0[var_6_1[var_6_0].effectRes] or 0) + 1
			end
		end
	end

	local var_6_2 = getCsv(arg_6_2.bkCsv)

	for iter_6_0, iter_6_1 in csvPairs(var_6_2) do
		arg_6_0[iter_6_1.res] = (arg_6_0[iter_6_1.res] or 0) + 1
	end

	local var_6_3 = 0

	var_0_0 = {}

	if arg_6_3.multipGroup then
		for iter_6_2, iter_6_3 in ipairs(arg_6_3.roleOut[1]) do
			for iter_6_4, iter_6_5 in ipairs(iter_6_3) do
				var_0_5(arg_6_0, arg_6_1, iter_6_5.roleId)

				var_6_3 = var_6_3 + 1
			end
		end

		for iter_6_6, iter_6_7 in ipairs(arg_6_3.roleOut[2]) do
			for iter_6_8, iter_6_9 in ipairs(iter_6_7) do
				var_0_5(arg_6_0, arg_6_1, iter_6_9.roleId)

				var_6_3 = var_6_3 + 1
			end
		end
	else
		for iter_6_10, iter_6_11 in pairs(arg_6_3.roleOut) do
			var_0_5(arg_6_0, arg_6_1, iter_6_11.roleId)

			var_6_3 = var_6_3 + 1
		end
	end

	for iter_6_12, iter_6_13 in ipairs(arg_6_2.monsters) do
		if iter_6_13 > 0 then
			var_0_5(arg_6_0, arg_6_1, iter_6_13)

			var_6_3 = var_6_3 + 1
		end
	end

	var_0_0 = nil
	arg_6_0["effect/death.skel"] = 1
	arg_6_0["effect/dazhao_bj.skel"] = 1
	arg_6_0[battle.SpriteRes.natureQuan] = var_6_3 > 0 and var_6_3 - 1 or 0
	arg_6_0[battle.SpriteRes.groundRing] = var_6_3 > 0 and var_6_3 - 1 or 0
	arg_6_0["ruchang/ruchang.skel"] = var_6_3 > 0 and var_6_3 - 1 or 0
	arg_6_0["img/dazhaodi.jpg"] = 1
	arg_6_0["battlearena/battlearena_effect.skel"] = 1
end
