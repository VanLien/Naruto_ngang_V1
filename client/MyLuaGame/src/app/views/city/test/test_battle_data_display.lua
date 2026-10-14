local var_0_0 = class("TestBattleDataDisplay", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "test_battle_data_display.json"
var_0_0.RESOURCE_BINDING = {
	["leftPanel.item"] = "item",
	leftPanel = "leftPanel",
	rightPanel = "rightPanel",
	btnState = {
		varname = "btnState",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnStateClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0)
	arg_1_0:onBtnStateClick(true)
	arg_1_0.item:hide()

	for iter_1_0 = 1, 2 do
		local var_1_0 = iter_1_0 == 1 and arg_1_0.leftPanel or arg_1_0.rightPanel

		var_1_0:get("list"):setScrollBarEnabled(false)
		var_1_0:setCascadeOpacityEnabled(true)
		var_1_0:opacity(200)
		text.addEffect(var_1_0:get("card"), {
			outline = {
				size = 2,
				color = ui.COLORS.OUTLINE.DEFAULT
			}
		})
		text.addEffect(var_1_0:get("damage"), {
			outline = {
				size = 2,
				color = ui.COLORS.OUTLINE.DEFAULT
			}
		})
		text.addEffect(var_1_0:get("recover"), {
			outline = {
				size = 2,
				color = ui.COLORS.OUTLINE.DEFAULT
			}
		})
		text.addEffect(var_1_0:get("takeDamage"), {
			outline = {
				size = 2,
				color = ui.COLORS.OUTLINE.DEFAULT
			}
		})
		text.addEffect(var_1_0:get("bigSkill"), {
			outline = {
				size = 2,
				color = ui.COLORS.OUTLINE.DEFAULT
			}
		})
		var_1_0:get("bigSkill"):setFontSize(10)
	end

	arg_1_0.obj = {}

	local function var_1_1(arg_2_0, arg_2_1)
		local var_2_0 = arg_2_0:get(arg_2_1):hide()

		text.addEffect(var_2_0:get("num"), {
			outline = {
				size = 2,
				color = ui.COLORS.OUTLINE.WHITE
			}
		})
		text.addEffect(var_2_0:get("percent"), {
			outline = {
				size = 2,
				color = ui.COLORS.OUTLINE.DEFAULT
			}
		})
		bind.extend(arg_1_0, var_2_0:get("progress"), {
			class = "loadingbar"
		})
		var_2_0:get("num"):getVirtualRenderer():setLineSpacing(-5)
	end

	for iter_1_1 = 1, 12 do
		local var_1_2 = arg_1_0.item:clone():show()

		;(iter_1_1 <= 6 and arg_1_0.leftPanel:get("list") or arg_1_0.rightPanel:get("list")):pushBackCustomItem(var_1_2)
		var_1_1(var_1_2, "damage")
		var_1_1(var_1_2, "recover")
		var_1_1(var_1_2, "takeDamage")
		text.addEffect(var_1_2:get("bigSkill"), {
			outline = {
				size = 2,
				color = ui.COLORS.OUTLINE.WHITE
			}
		})
		var_1_2:get("bigSkill"):hide()

		arg_1_0.obj[iter_1_1] = {
			item = var_1_2
		}
	end

	arg_1_0.datas = {
		{},
		{}
	}
end

local function var_0_1(arg_3_0)
	if not arg_3_0 then
		return nil
	end

	return arg_3_0.dbID or arg_3_0.seat
end

function var_0_0.setData(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	for iter_4_0 = arg_4_2, arg_4_3 do
		if arg_4_1[iter_4_0] and not arg_4_0.datas[arg_4_4][var_0_1(arg_4_1[iter_4_0])] then
			arg_4_0.datas[arg_4_4] = {}

			break
		end
	end

	for iter_4_1 = arg_4_2, arg_4_3 do
		if arg_4_1[iter_4_1] then
			local var_4_0 = var_0_1(arg_4_1[iter_4_1])
			local var_4_1 = arg_4_0.datas[arg_4_4][var_4_0] and arg_4_0.datas[arg_4_4][var_4_0].seat or arg_4_1[iter_4_1].seat

			arg_4_0.datas[arg_4_4][var_4_0] = clone(arg_4_1[iter_4_1])
			arg_4_0.datas[arg_4_4][var_4_0].seat = var_4_1
		end
	end

	if not arg_4_0:visible() then
		return
	end

	local var_4_2 = 0
	local var_4_3 = 0
	local var_4_4 = 0

	for iter_4_2, iter_4_3 in pairs(arg_4_0.datas[arg_4_4]) do
		local var_4_5 = 0
		local var_4_6 = 0
		local var_4_7 = 0

		for iter_4_4, iter_4_5 in pairs(iter_4_3.totalDamage) do
			var_4_5 = var_4_5 + iter_4_5:get(battle.ValueType.normal)
		end

		for iter_4_6, iter_4_7 in pairs(iter_4_3.totalResumeHp) do
			var_4_6 = var_4_6 + iter_4_7:get(battle.ValueType.normal)
		end

		for iter_4_8, iter_4_9 in pairs(iter_4_3.totalTakeDamage) do
			var_4_7 = var_4_7 + iter_4_9:get(battle.ValueType.normal)
		end

		local var_4_8 = 0
		local var_4_9 = 0
		local var_4_10 = 0

		for iter_4_10, iter_4_11 in pairs(iter_4_3.totalDamage) do
			var_4_8 = var_4_8 + iter_4_11:get(battle.ValueType.valid)
		end

		for iter_4_12, iter_4_13 in pairs(iter_4_3.totalResumeHp) do
			var_4_9 = var_4_9 + iter_4_13:get(battle.ValueType.valid)
		end

		for iter_4_14, iter_4_15 in pairs(iter_4_3.totalTakeDamage) do
			var_4_10 = var_4_10 + iter_4_15:get(battle.ValueType.valid)
		end

		iter_4_3.damage = var_4_5
		iter_4_3.recover = var_4_6
		iter_4_3.takeDamage = var_4_7
		iter_4_3.damageValid = var_4_8
		iter_4_3.recoverValid = var_4_9
		iter_4_3.takeDamageValid = var_4_10
		iter_4_3.bigSkill = iter_4_3.bigSkillUseTimes or 0
		var_4_2 = var_4_2 + iter_4_3.damage
		var_4_3 = var_4_3 + iter_4_3.recover
		var_4_4 = var_4_4 + iter_4_3.takeDamage
	end

	local var_4_11 = {}

	local function var_4_12(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		local var_5_0 = arg_5_0:get(arg_5_1):show()

		var_5_0:get("num"):text(mathEasy.getShortNumber(arg_5_2[arg_5_1], 2))

		local var_5_1 = 0

		if arg_4_0.state == 1 then
			var_5_1 = arg_5_3 == 0 and 0 or math.floor(arg_5_2[arg_5_1] * 100 / arg_5_3)
		elseif arg_4_0.state == 2 then
			var_5_1 = arg_5_2[arg_5_1] == 0 and 100 or math.floor(100 * arg_5_2[arg_5_1 .. "Valid"] / arg_5_2[arg_5_1])
		end

		var_5_0:get("progress"):percent(var_5_1)
		var_5_0:get("percent"):text(var_5_1 .. "%")
	end

	for iter_4_16, iter_4_17 in pairs(arg_4_0.datas[arg_4_4]) do
		local var_4_13 = iter_4_17.seat

		var_4_11[var_4_13] = true

		local var_4_14 = arg_4_0.obj[var_4_13].item

		var_4_14:get("bigSkill"):show()

		if var_4_14:get("_card_") then
			var_4_14:get("_card_"):show()
		end

		var_4_12(var_4_14, "damage", iter_4_17, var_4_2)
		var_4_12(var_4_14, "recover", iter_4_17, var_4_3)
		var_4_12(var_4_14, "takeDamage", iter_4_17, var_4_4)
		var_4_14:get("bigSkill"):text(iter_4_17.bigSkill .. "次")

		local var_4_15 = var_0_1(iter_4_17)

		if arg_4_0.obj[var_4_13].dbID ~= var_4_15 then
			arg_4_0.obj[var_4_13].dbID = var_4_15

			local var_4_16 = iter_4_17.unitID
			local var_4_17 = csv.unit[var_4_16]

			bind.extend(arg_4_0, var_4_14, {
				class = "card_icon",
				props = {
					unitId = var_4_16,
					advance = iter_4_17.advance,
					star = iter_4_17.star,
					rarity = var_4_17.rarity,
					onNode = function(arg_6_0)
						arg_6_0:scale(0.25)

						local var_6_0 = var_4_14:width()
						local var_6_1 = var_4_14:height()
						local var_6_2 = (var_6_0 - arg_6_0:box().width) / 2

						arg_6_0:xy(var_6_2, var_6_1 - arg_6_0:box().height)
					end
				}
			})
		end
	end

	for iter_4_18 = arg_4_2, arg_4_3 do
		if not var_4_11[iter_4_18] then
			local var_4_18 = arg_4_0.obj[iter_4_18].item

			var_4_18:get("damage"):hide()
			var_4_18:get("recover"):hide()
			var_4_18:get("takeDamage"):hide()
			var_4_18:get("bigSkill"):hide()

			if var_4_18:get("_card_") then
				var_4_18:get("_card_"):hide()
			end
		end
	end
end

local var_0_2 = {
	[1] = "队伍数值占比",
	[2] = "有效值比"
}

function var_0_0.onBtnStateClick(arg_7_0, arg_7_1)
	if arg_7_1 == true then
		arg_7_0.state = 1

		arg_7_0.btnState:get("label"):text(var_0_2[arg_7_0.state])

		return
	end

	arg_7_0.state = arg_7_0.state % #var_0_2 + 1

	arg_7_0.btnState:get("label"):text(var_0_2[arg_7_0.state])
	arg_7_0:setData({}, 1, 6, 1)
	arg_7_0:setData({}, 7, 12, 2)
end

function var_0_0.refresh(arg_8_0, arg_8_1)
	if arg_8_1 then
		arg_8_0:setData(arg_8_1, 1, 6, 1)
		arg_8_0:setData(arg_8_1, 7, 12, 2)
	end
end

return var_0_0
