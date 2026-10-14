local var_0_0 = require("app.views.city.test.gate.gate")
local var_0_1 = require("app.views.city.test.model.prefab")
local var_0_2 = class("BraveChallengeGate", var_0_0)
local var_0_3 = {
	specialDefence = 3000,
	level = 90,
	mp1Recover = 1,
	natureRestraint = 1,
	mp2 = 1,
	damageDeepen = 1,
	damage = 10000,
	hit = 10000,
	classify = 0,
	specialDefenceIgnore = 1,
	strikeResistance = 1,
	mp2Recover = 1,
	star = 12,
	rebound = 0,
	defence = 3000,
	controlPer = 0,
	hpRecover = 1,
	block = 1,
	strike = 1,
	speed = 14,
	hp = 100000,
	immuneGate = 1,
	fightPoint = 0,
	suckBlood = 0,
	breakBlock = 1,
	damageReduce = 1,
	defenceIgnore = 1,
	ultimateAdd = 0,
	ultimateSub = 0,
	dodge = 1,
	specialDamage = 10000,
	damageSub = 1,
	mp1 = 1000,
	damageAdd = 1,
	gatePer = 1,
	blockPower = 1,
	strikeDamage = 15000,
	cure = 1,
	skills = {},
	passive_skills = {},
	ex_skills = {}
}

function var_0_2.preTreat(arg_1_0)
	local var_1_0 = csv.cards

	arg_1_0.playerCards = {}
	arg_1_0.monsterCards = {}
	arg_1_0.badgesSkills = {}
	arg_1_0.rdBadgesSkills = {}

	for iter_1_0, iter_1_1 in pairs(csv.brave_challenge.cards) do
		if type(iter_1_1) == "table" and iter_1_1.cardID then
			local var_1_1 = clone(var_0_3)

			var_1_1.roleId = var_1_0[iter_1_1.cardID].unitID

			for iter_1_2, iter_1_3 in pairs(var_1_0[iter_1_1.cardID].skillList) do
				var_1_1.skills[iter_1_3] = iter_1_1.level
			end

			if iter_1_1.groupID >= 10 and iter_1_1.groupID <= 11 then
				table.insert(arg_1_0.playerCards, var_1_1)
			elseif iter_1_1.groupID > 100 then
				arg_1_0.monsterCards[iter_1_0] = var_1_1
			end
		end
	end

	for iter_1_4, iter_1_5 in pairs(csv.brave_challenge.badge) do
		if type(iter_1_5) == "table" and iter_1_5.skillIDs and iter_1_5.skillIDs[1] then
			arg_1_0.badgesSkills[iter_1_4] = iter_1_5.skillIDs[1]

			table.insert(arg_1_0.rdBadgesSkills, iter_1_5.skillIDs[1])
		end
	end
end

function var_0_2.addSelfRoles(arg_2_0)
	local var_2_0 = {}

	for iter_2_0 = 1, 6 do
		local var_2_1 = math.random(1, #arg_2_0.playerCards)
		local var_2_2 = math.random(1, #arg_2_0.rdBadgesSkills)
		local var_2_3 = arg_2_0.rdBadgesSkills[var_2_2]

		var_2_0[iter_2_0] = arg_2_0.playerCards[var_2_1]
		var_2_0[iter_2_0].skills[var_2_3] = var_2_0[iter_2_0].level

		table.insert(var_2_0[iter_2_0].ex_skills, var_2_3)
	end

	return var_2_0
end

function var_0_2.specificBattle(arg_3_0)
	local var_3_0 = {}
	local var_3_1 = false
	local var_3_2 = 98008
	local var_3_3 = {
		1261,
		741,
		2013,
		3611,
		333,
		493
	}
	local var_3_4 = {
		5002711,
		5003306,
		5006702,
		5006715,
		5009713,
		5004702
	}

	for iter_3_0, iter_3_1 in ipairs(var_3_3) do
		for iter_3_2, iter_3_3 in ipairs(arg_3_0.playerCards) do
			if iter_3_1 == iter_3_3.roleId then
				var_3_0[iter_3_0] = iter_3_3
				var_3_0[iter_3_0].skills[var_3_4[iter_3_0]] = var_3_0[iter_3_0].level

				table.insert(var_3_0[iter_3_0].ex_skills, var_3_4[iter_3_0])

				break
			end
		end
	end

	for iter_3_4, iter_3_5 in pairs(csv.brave_challenge.monster) do
		if type(iter_3_5) == "table" and iter_3_5.cards and iter_3_5.badges then
			local var_3_5 = iter_3_5.cards
			local var_3_6 = iter_3_5.badges

			if iter_3_4 == var_3_2 and var_3_5 and var_3_6 then
				for iter_3_6, iter_3_7 in pairs(var_3_5) do
					if iter_3_7 ~= 0 then
						local var_3_7 = arg_3_0.monsterCards[iter_3_7]

						var_3_7.key = iter_3_4

						if var_3_6[iter_3_6] ~= 0 then
							local var_3_8 = arg_3_0.badgesSkills[var_3_6[iter_3_6]]

							if var_3_8 then
								var_3_7.skills[var_3_8] = var_3_7.level

								table.insert(var_3_7.ex_skills, var_3_8)
							end
						end

						var_3_0[iter_3_6 + 6] = var_3_7
					end
				end

				break
			end
		end
	end

	return var_3_1, {
		var_3_0
	}
end

function var_0_2.getFightRoleData(arg_4_0)
	arg_4_0:preTreat()

	local var_4_0, var_4_1 = arg_4_0:specificBattle()

	if var_4_0 then
		return var_4_1
	end

	local var_4_2 = {}

	for iter_4_0, iter_4_1 in pairs(csv.brave_challenge.monster) do
		if type(iter_4_1) == "table" and iter_4_1.cards and iter_4_1.badges then
			local var_4_3 = iter_4_1.cards
			local var_4_4 = iter_4_1.badges

			if var_4_3 and var_4_4 then
				local var_4_5 = arg_4_0:addSelfRoles()

				for iter_4_2, iter_4_3 in pairs(var_4_3) do
					if iter_4_3 ~= 0 then
						local var_4_6 = arg_4_0.monsterCards[iter_4_3]

						var_4_6.key = iter_4_0

						if var_4_4[iter_4_2] ~= 0 then
							local var_4_7 = arg_4_0.badgesSkills[var_4_4[iter_4_2]]

							if var_4_7 then
								var_4_6.skills[var_4_7] = var_4_6.level

								table.insert(var_4_6.ex_skills, var_4_7)
							end
						end

						var_4_5[iter_4_2 + 6] = var_4_6
					end
				end

				table.insert(var_4_2, var_4_5)
			end
		end
	end

	return var_4_2
end

return var_0_2
