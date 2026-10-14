local var_0_0 = {}

globals.battleTarget = var_0_0

require("battle.models.target.target2")
require("battle.models.target.target")

local var_0_1
local var_0_2

function globals.newTargetFinder(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	log.targetFinder.choose(" newTargetFinder: self, selected, chooseType ", arg_1_0.seat, arg_1_1 and arg_1_1.seat, arg_1_2)

	local var_1_0 = {}

	if arg_1_4 and next(arg_1_4) then
		var_1_0 = arg_1_4

		if arg_1_3 and arg_1_3.allProcessesTargets then
			var_1_0.process = var_0_0.otherProcessFinder(var_1_0.process, arg_1_3.allProcessesTargets)
		end
	else
		if var_0_1[arg_1_2] == nil then
			printWarn("chooseType %d no implement in skillConfigTypeTb", arg_1_2)
		end

		var_1_0 = var_0_1[arg_1_2](arg_1_3)

		if arg_1_3 and arg_1_3.specialChoose and var_1_0.process then
			local var_1_1 = var_0_2[arg_1_3.specialChoose]
			local var_1_2 = string.format("%s|%s", var_1_0.process, var_1_1)

			if var_1_0.process == "" then
				var_1_2 = var_1_1
			end

			var_1_0.process = var_1_2
		end

		if arg_1_3 and arg_1_3.targetLimit and var_1_0.process then
			var_1_0.process = string.format("%s|random(%s)", var_1_0.process, arg_1_3.targetLimit)
		end
	end

	if var_1_0.input and arg_1_3 then
		if arg_1_3.skillType == battle.SkillType.PassiveSkill and arg_1_0 and battleEasy.isCompleteLeave(arg_1_0) then
			arg_1_3.inputExtraStr = string.format("leaveExtraDeal({casterId=%s})", arg_1_0.id)
		end

		if arg_1_3.inputExtraStr then
			var_1_0.input = var_1_0.input .. "|" .. arg_1_3.inputExtraStr
		end
	end

	if not var_1_0.input and not var_1_0.process then
		return {}
	end

	return var_0_0.targetFinder(arg_1_0, arg_1_1, var_1_0, arg_1_3)
end

function globals.newTargetTypeFinder(arg_2_0, arg_2_1)
	return var_0_1[arg_2_0](arg_2_1)
end

function var_0_0.findOtherProcessParams(arg_3_0, arg_3_1)
	arg_3_0 = string.trim(arg_3_0)

	local var_3_0, var_3_1 = string.find(arg_3_0, arg_3_1)

	if var_3_1 then
		local var_3_2 = string.find(arg_3_0, "%)")
		local var_3_3 = arg_3_0:sub(var_3_1 + 1, var_3_2 - 1)

		return (string.split(var_3_3, ","))
	else
		return nil
	end
end

function var_0_0.otherProcessFinder(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0

	if not var_4_0 or var_4_0 == "" then
		return ""
	end

	local var_4_1 = string.trim(var_4_0)

	if var_4_1:sub(1, 1) == "|" then
		var_4_1 = var_4_1:sub(2)
	end

	local var_4_2 = string.split(var_4_1, "|")
	local var_4_3 = {}

	for iter_4_0, iter_4_1 in ipairs(var_4_2) do
		local var_4_4 = {}
		local var_4_5 = var_0_0.findOtherProcessParams(iter_4_1, "otherProcessExcept%(")

		if var_4_5 then
			for iter_4_2, iter_4_3 in ipairs(var_4_5) do
				local var_4_6 = tonumber(iter_4_3)

				if arg_4_1[var_4_6] then
					for iter_4_4, iter_4_5 in ipairs(arg_4_1[var_4_6]) do
						table.insert(var_4_4, iter_4_5.seat)
					end
				end
			end

			table.insert(var_4_3, string.format("exclude({%s})", table.concat(var_4_4, ",")))
		else
			local var_4_7 = var_0_0.findOtherProcessParams(iter_4_1, "useOtherProcess%(")

			if var_4_7 then
				for iter_4_6, iter_4_7 in ipairs(var_4_7) do
					local var_4_8 = tonumber(iter_4_7)

					if arg_4_1[var_4_8] then
						for iter_4_8, iter_4_9 in ipairs(arg_4_1[var_4_8]) do
							table.insert(var_4_4, iter_4_9.seat)
						end
					end
				end

				table.insert(var_4_3, string.format("include({%s})", table.concat(var_4_4, ",")))
			else
				table.insert(var_4_3, iter_4_1)
			end
		end
	end

	return table.concat(var_4_3, "|")
end

local var_0_3 = {
	true,
	[19] = true,
	[13] = true,
	[14] = true
}
local var_0_4 = {
	[20] = true,
	[21] = true,
	[22] = true
}

function globals.isProcessTargetSingle(arg_5_0)
	if var_0_3[arg_5_0.skillTarget] then
		return true
	elseif var_0_4[arg_5_0.skillTarget] and arg_5_0.targetLimit <= 1 then
		return true
	end

	return false
end

local var_0_5 = {
	[0] = "selfForce|nodead",
	"enemyForce|nodead",
	"all|nodead"
}

var_0_1 = {
	function(arg_6_0)
		return {
			input = "selected"
		}
	end,
	function(arg_7_0)
		local var_7_0 = arg_7_0 and var_0_5[arg_7_0.friendOrEnemy] or ""

		return {
			process = "rowfront",
			input = var_7_0
		}
	end,
	function(arg_8_0)
		local var_8_0 = arg_8_0 and var_0_5[arg_8_0.friendOrEnemy] or ""

		return {
			process = "rowback",
			input = var_8_0
		}
	end,
	function(arg_9_0)
		local var_9_0 = arg_9_0 and var_0_5[arg_9_0.friendOrEnemy] or ""

		return {
			process = "column",
			input = var_9_0
		}
	end,
	[11] = function(arg_10_0)
		local var_10_0 = arg_10_0 and var_0_5[arg_10_0.friendOrEnemy] or ""

		return {
			process = "",
			input = var_10_0
		}
	end,
	[12] = function(arg_11_0)
		return {
			process = "near",
			input = "enemyForce|nodead"
		}
	end,
	[13] = function(arg_12_0)
		return {
			input = string.format("object(%d)", arg_12_0.specialChoose)
		}
	end,
	[14] = function(arg_13_0)
		return {
			input = "myself"
		}
	end,
	[15] = function(arg_14_0)
		return {
			process = "near",
			input = "myself|selfForce"
		}
	end,
	[16] = function(arg_15_0)
		return {
			process = "selfColumn",
			input = "selfForce"
		}
	end,
	[17] = function(arg_16_0)
		return {
			process = "selfRow",
			input = "selfForce()|nodead"
		}
	end,
	[18] = function(arg_17_0)
		return {
			process = "near",
			input = "selected|nodead"
		}
	end,
	[19] = function()
		return {
			input = "whokill|nodead"
		}
	end,
	[20] = function(arg_19_0)
		local var_19_0 = arg_19_0 and var_0_5[arg_19_0.friendOrEnemy] or ""
		local var_19_1 = 1

		if arg_19_0 and arg_19_0.targetLimit then
			var_19_1 = arg_19_0.targetLimit
		end

		return {
			input = var_19_0,
			process = "random(" .. var_19_1 .. ")"
		}
	end,
	[21] = function(arg_20_0)
		local var_20_0 = arg_20_0 and var_0_5[arg_20_0.friendOrEnemy] or ""
		local var_20_1 = 1

		if arg_20_0 and arg_20_0.targetLimit then
			var_20_1 = arg_20_0.targetLimit
		end

		return {
			input = var_20_0,
			process = "frontRowRandom(" .. var_20_1 .. ")"
		}
	end,
	[22] = function(arg_21_0)
		local var_21_0 = arg_21_0 and var_0_5[arg_21_0.friendOrEnemy] or ""
		local var_21_1 = 1

		if arg_21_0 and arg_21_0.targetLimit then
			var_21_1 = arg_21_0.targetLimit
		end

		return {
			input = var_21_0,
			process = "backRowRandom(" .. var_21_1 .. ")"
		}
	end,
	[23] = function(arg_22_0)
		return {
			input = string.format("objectEx(%d,%d)", arg_22_0.friendOrEnemy, arg_22_0.specialChoose)
		}
	end,
	[24] = function(arg_23_0)
		return {}
	end,
	[25] = function(arg_24_0)
		local var_24_0 = "selfForce()"
		local var_24_1 = "enemyRow(1, true)"

		return {
			input = "And(" .. var_24_0 .. "," .. var_24_1 .. ")"
		}
	end
}
var_0_2 = {
	"hpMax",
	"hpMin",
	"attackDamageMax",
	"attackDamageMin",
	"defenceMax",
	"defenceMin",
	"mp1Max",
	"mp1Min",
	"specialDamageMax",
	"specialDamageMin",
	"speedMax",
	"speedMin",
	"specialDefenceMax",
	"specialDefenceMin",
	"hpRatioMax",
	"hpRatioMin",
	"mp1RatioMax",
	"mp1RatioMin"
}
