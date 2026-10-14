local var_0_0 = {
	WhetherLive = function(arg_1_0)
		local var_1_0 = 0
		local var_1_1 = 0

		for iter_1_0, iter_1_1 in pairs(arg_1_0 or {}) do
			var_1_0 = var_1_0 + 1
			var_1_1 = iter_1_1[1] + var_1_1
		end

		if var_1_1 == 0 then
			return 0
		end

		return mathEasy.getPreciseDecimal(var_1_1 / var_1_0, 1, false)
	end,
	unionMembersState = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		arg_2_2 = arg_2_2 or {}

		if arg_2_3 < 0 then
			arg_2_3 = 0
		end

		if not arg_2_0 then
			return arg_2_2
		end

		for iter_2_0 = 1, 3 do
			if arg_2_0[iter_2_0] then
				for iter_2_1, iter_2_2 in ipairs(arg_2_0[iter_2_0] or {}) do
					if arg_2_3 >= iter_2_2.round or arg_2_4 then
						if arg_2_1 == iter_2_2.left.union_db_id then
							if not arg_2_2[iter_2_2.left.role_db_id] then
								arg_2_2[iter_2_2.left.role_db_id] = {}
							end

							if not arg_2_2[iter_2_2.left.role_db_id].troop_card_state then
								arg_2_2[iter_2_2.left.role_db_id].troop_card_state = {}
							end

							arg_2_2[iter_2_2.left.role_db_id].troop = iter_2_2.left.troop or 1

							for iter_2_3, iter_2_4 in pairs(iter_2_2.left.troop_card_state) do
								arg_2_2[iter_2_2.left.role_db_id].troop_card_state[iter_2_3] = iter_2_4
							end
						elseif arg_2_1 == iter_2_2.right.union_db_id then
							if not arg_2_2[iter_2_2.right.role_db_id] then
								arg_2_2[iter_2_2.right.role_db_id] = {}
							end

							if not arg_2_2[iter_2_2.right.role_db_id].troop_card_state then
								arg_2_2[iter_2_2.right.role_db_id].troop_card_state = {}
							end

							arg_2_2[iter_2_2.right.role_db_id].troop = iter_2_2.right.troop or 1

							for iter_2_5, iter_2_6 in pairs(iter_2_2.right.troop_card_state) do
								arg_2_2[iter_2_2.right.role_db_id].troop_card_state[iter_2_5] = iter_2_6
							end
						end
					end
				end
			end
		end

		return arg_2_2
	end,
	comparison = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		if not arg_3_0[1] and not arg_3_0[2] and (not arg_3_1.left.role_db_id or not arg_3_1.right.role_db_id) then
			return false
		end

		if arg_3_0[1] then
			if arg_3_2 == arg_3_1.left.union_db_id or arg_3_2 == arg_3_1.right.union_db_id then
				return true
			else
				return false
			end
		end

		if arg_3_0[2] then
			if arg_3_3 == arg_3_1.left.role_db_id or arg_3_3 == arg_3_1.right.role_db_id then
				return true
			else
				return false
			end
		end

		return true
	end
}

function var_0_0.roleDie(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_1 == arg_4_0.left.role_db_id and arg_4_0.left.troop == arg_4_2 then
		return var_0_0.WhetherLive(arg_4_0.left.troop_card_state) == 0
	elseif arg_4_1 == arg_4_0.right.role_db_id and arg_4_0.right.troop == arg_4_2 then
		return var_0_0.WhetherLive(arg_4_0.right.troop_card_state)
	end

	return false
end

function var_0_0.getNowMatch(arg_5_0)
	local var_5_0 = {
		"start",
		"prePrepare",
		"preStart",
		"preBattle",
		"preOver",
		"preAward"
	}
	local var_5_1 = {
		"topPrepare",
		"topStart",
		"topBattle",
		"topOver",
		"closed"
	}

	if itertools.include(var_5_0, arg_5_0) then
		return 1
	end

	if itertools.include(var_5_1, arg_5_0) then
		return 2
	end

	return 1
end

function var_0_0.whetherCloseShowUI(arg_6_0)
	if gGameModel.role:read("cross_union_fight_status") == "closed" then
		local var_6_0

		if arg_6_0 and arg_6_0 ~= 0 then
			var_6_0 = arg_6_0
		else
			var_6_0 = dataEasy.getCrossServiceData("crossunionfight", false, -518400)
		end

		if var_6_0 then
			local var_6_1 = csv.cross.service[var_6_0]
			local var_6_2 = time.getNumTimestamp(var_6_1.date, time.getRefreshHour()) + 259200
			local var_6_3 = var_6_2 + 259200

			if var_6_2 <= time.getTime() and var_6_3 >= time.getTime() then
				return true
			end
		end
	end

	return false
end

function var_0_0.battleStateView(arg_7_0, arg_7_1)
	if var_0_0.getNowMatch(arg_7_1) == 1 then
		if arg_7_0 then
			if arg_7_1 == "preOver" or arg_7_1 == "preAward" then
				return true
			end
		elseif arg_7_1 ~= "preOver" and arg_7_1 ~= "preAward" then
			return true
		end
	elseif arg_7_0 then
		if arg_7_1 == "topOver" or arg_7_1 == "closed" then
			return true
		end
	elseif arg_7_1 ~= "topOver" and arg_7_1 ~= "closed" then
		return true
	end

	return false
end

function var_0_0.onInitItem(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	local var_8_0 = 50

	arg_8_4 = arg_8_4 or arg_8_3.status:read()

	local var_8_1 = arg_8_3.unionId
	local var_8_2 = arg_8_3.roles
	local var_8_3 = arg_8_3.slider
	local var_8_4 = 272

	if arg_8_2.time then
		arg_8_1:get("itmeTime"):visible(not arg_8_2.itemUp)
		arg_8_1:get("itmeTime"):text(gLanguageCsv.battleBeginning)
		arg_8_1:get("upItem"):visible(arg_8_2.itemUp)

		if arg_8_2.title then
			arg_8_1:get("upItem.title"):show()
			arg_8_1:get("upItem.title"):text(arg_8_2.title)
			arg_8_1:get("upItem.time"):hide()
		end

		arg_8_1:get("upItem.bg"):scale(2)

		var_8_4 = arg_8_2.itemUp and arg_8_1:get("upItem"):height() or arg_8_1:get("itmeTime"):height()

		arg_8_1:get("upItem"):y(arg_8_1:get("upItem"):height() / 2)
		arg_8_1:get("itmeTime"):y(arg_8_1:get("itmeTime"):height() / 2)
	elseif arg_8_2.anima then
		if arg_8_2.unionAlive or arg_8_2.condition or arg_8_2.finish then
			arg_8_1:get("upItem"):show()
			arg_8_1:get("upItem.bg"):scale(2)
			arg_8_1:get("upItem.title"):show()

			local var_8_5

			if arg_8_2.finish then
				var_8_5 = gLanguageCsv.crossUnionUnionBattleSucceed
			else
				var_8_5 = arg_8_2.unionAlive and gLanguageCsv.crossUnionUnionBattleFailure or gLanguageCsv.crossUnionBattleFailure
			end

			arg_8_1:get("upItem.title"):text(var_8_5)
			arg_8_1:get("upItem.time"):hide()
			arg_8_1:get("upItem"):y(arg_8_1:get("upItem"):height() / 2)

			var_8_4 = arg_8_1:get("upItem"):height()
		else
			arg_8_1:get("itemAnima"):show()
			arg_8_1:get("itemAnima"):y(arg_8_1:get("itemAnima"):height() / 2 - 80)

			local var_8_6 = widget.addAnimation(arg_8_1:get("itemAnima"), "cross_union/dazuozhan.skel", "ruchang", 25)

			var_8_6:xy(900, 44)
			var_8_6:scale(2)
			var_8_6:setSpriteEventHandler(function(arg_9_0, arg_9_1)
				var_8_6:play("zhandou_loop")
			end, sp.EventType.ANIMATION_COMPLETE)
			arg_8_1:get("itemAnima"):height(270)

			var_8_4 = arg_8_1:get("itemAnima"):height() + 100
		end
	elseif arg_8_2.roundTime then
		if arg_8_2.numRoundBattle then
			arg_8_1:get("itmeTime"):show()
			arg_8_1:get("itmeTime"):text(string.format(gLanguageCsv.roundBattle, arg_8_2.round))
			arg_8_1:get("itmeTime"):y(arg_8_1:get("itmeTime"):height() / 2)

			var_8_4 = arg_8_1:get("itmeTime"):height()
		else
			arg_8_1:get("round"):show()
			arg_8_1:get("round.round"):text(string.format(gLanguageCsv.roundBattle, arg_8_2.round))
			arg_8_1:get("round.over"):text(gLanguageCsv.afterFinish)
			adapt.oneLinePos(arg_8_1:get("round.round"), {
				arg_8_1:get("round.time"),
				arg_8_1:get("round.over")
			}, cc.p(10, 0), "left")
			arg_8_1:get("round"):y(arg_8_1:get("round"):height() / 2)

			var_8_4 = arg_8_1:get("round"):height()
		end
	else
		arg_8_1:get("panel"):show()
		arg_8_1:get("panel"):y(arg_8_1:get("panel"):height() / 2)

		var_8_4 = arg_8_1:get("panel"):height() - 10

		local var_8_7 = arg_8_2.round
		local var_8_8 = arg_8_3.roles.oldval

		local function var_8_9(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
			local var_10_0 = arg_10_0:multiget("roleIcon", "level", "name", "unionName", "team", "hpText", "hpBar", "win")
			local var_10_1 = var_8_8[arg_10_1.role_db_id] or arg_10_1

			bind.extend(arg_8_3, var_10_0.roleIcon, {
				event = "extend",
				class = "role_logo",
				props = {
					vip = false,
					level = false,
					logoId = var_10_1.role_logo or 1,
					frameId = var_10_1.role_frame or 1
				}
			})
			var_10_0.roleIcon:scale(0.85)
			var_10_0.level:text(var_10_1.role_level)
			text.addEffect(var_10_0.level, {
				outline = {
					size = 4,
					color = ui.COLORS.NORMAL.DEFAULT
				}
			})
			var_10_0.name:text(var_10_1.role_name)
			var_10_0.unionName:text(arg_10_1.union_name)
			var_10_0.win:show()
			var_10_0.team:text(string.format(gLanguageCsv.unionFightTeam, arg_10_1.troop))

			local var_10_2 = var_0_0.WhetherLive(arg_10_1.troop_card_state) * 100
			local var_10_3

			if arg_10_4 == "win" and arg_10_2 == "left" or arg_10_4 == "fail" and arg_10_2 == "right" then
				if arg_10_4 == "fail" then
					arg_10_3:texture("city/union/cross_unionfight/panel_bldzz_05.png")
				end

				var_10_0.win:texture("city/pvp/craft/icon_win.png")

				var_10_3 = string.format(gLanguageCsv.unionFightHpText, var_10_2 .. "%")
			else
				var_10_3 = gLanguageCsv.unionFightDead
			end

			var_10_0.hpText:text(var_10_3)
			adapt.oneLinePos(var_10_0.team, var_10_0.hpText, cc.p(1, 0), arg_10_2)
			var_10_0.hpBar:setPercent(var_10_2)
		end

		local var_8_10 = arg_8_2.left
		local var_8_11 = arg_8_2.right
		local var_8_12 = arg_8_2.result

		if arg_8_2.right.union_db_id == var_8_1 then
			var_8_10 = arg_8_2.right
			var_8_11 = arg_8_2.left
			var_8_12 = arg_8_2.result == "win" and "fail" or "win"
		end

		arg_8_1:get("panel.centerJs"):show()

		if var_8_10.role_db_id then
			var_8_9(arg_8_1:get("panel.left"), var_8_10, "left", arg_8_1:get("panel.bg"), var_8_12)
		else
			arg_8_1:get("panel.bg"):texture("city/union/cross_unionfight/panel_bldzz_05")
			arg_8_1:get("panel.left"):hide()
			arg_8_1:get("panel.leftInexistence"):show()
			arg_8_1:get("panel.leftInexistence.title"):text(gLanguageCsv.curRoundNoEnemy)
			arg_8_1:get("panel.centerJs"):hide()
		end

		if var_8_11.role_db_id then
			var_8_9(arg_8_1:get("panel.right"), var_8_11, "right", arg_8_1:get("panel.bg"), var_8_12)
		else
			arg_8_1:get("panel.right"):hide()
			arg_8_1:get("panel.rightInexistence"):show()
			arg_8_1:get("panel.rightInexistence.title"):text(gLanguageCsv.curRoundNoEnemy)
			arg_8_1:get("panel.centerJs"):hide()
		end

		if not var_8_10.role_db_id or not var_8_11.role_db_id then
			arg_8_1:get("panel.left.win"):hide()
			arg_8_1:get("panel.right.win"):hide()
		end

		bind.touch(arg_8_0, arg_8_1:get("panel.centerJs"), {
			methods = {
				ended = function()
					arg_8_3:battleReport(arg_8_0, arg_8_1, arg_8_2)
				end
			}
		})
	end

	local var_8_13 = require("app.views.city.union.cross_unionfight.view")

	arg_8_1:size(1837, var_8_4)
	arg_8_3:enableSchedule()

	local var_8_14 = {
		countDown = function()
			arg_8_1:get("upItem.time"):show()
			text.addEffect(arg_8_1:get("upItem.time"), {
				outline = {
					color = cc.c4b(139, 119, 84, 255)
				}
			})

			local var_12_0 = var_8_13:countDown(arg_8_4)

			arg_8_1:get("upItem.time"):text(time.getCutDown(var_12_0).min_sec_clock)
			arg_8_3:schedule(function()
				local var_13_0 = var_8_13:countDown(arg_8_4)

				if var_13_0 <= 0 then
					return
				end

				if arg_8_1 and arg_8_1:get("upItem") then
					arg_8_1:get("upItem.time"):text(time.getCutDown(var_13_0).min_sec_clock)
				end
			end, 1, 0, var_8_0)
		end,
		roundCountDown = function()
			local var_14_0 = arg_8_3.model.countDown

			arg_8_1:get("round.time"):text(time.getCutDown(var_14_0).min_sec_clock)
			arg_8_3:schedule(function()
				local var_15_0 = arg_8_3.model.countDown

				if var_15_0 <= 0 or not arg_8_1 then
					return
				end

				if arg_8_1 and arg_8_1:get("round") then
					arg_8_1:get("round.time"):text(time.getCutDown(var_15_0).min_sec_clock)
					adapt.oneLinePos(arg_8_1:get("round.round"), {
						arg_8_1:get("round.time"),
						arg_8_1:get("round.over")
					}, cc.p(10, 0), "left")
				end
			end, 1, 0, var_8_0)
		end
	}
	local var_8_15 = arg_8_0:size()
	local var_8_16, var_8_17 = arg_8_0:xy()
	local var_8_18 = arg_8_3.slider:size()

	arg_8_3.slider:x(var_8_16 + var_8_15.width - var_8_18.width)

	local var_8_19, var_8_20 = arg_8_3.slider:xy()

	arg_8_3.slider:show()
	arg_8_0:setScrollBarEnabled(true)
	arg_8_0:setScrollBarColor(cc.c3b(245, 156, 2))
	arg_8_0:setScrollBarOpacity(255)
	arg_8_0:setScrollBarAutoHideEnabled(false)
	arg_8_0:setScrollBarPositionFromCorner(cc.p(var_8_16 + var_8_15.width - var_8_19, (var_8_15.height - var_8_18.height) / 2 + 5))
	arg_8_0:setScrollBarWidth(var_8_18.width)
	arg_8_0:refreshView()

	if not arg_8_5 and var_8_14[arg_8_2.roundTime] then
		var_8_14[arg_8_2.roundTime]()

		return
	end
end

local var_0_1 = 86400
local var_0_2 = 75600
local var_0_3 = 31800.000000000004
local var_0_4 = {
	start = var_0_3 + var_0_1,
	prePrepare = var_0_3 + 43200 + var_0_1,
	preStart = var_0_2 + 1800 + var_0_1,
	preBattle = var_0_2 + 1800 + var_0_1,
	preOver = var_0_2 + 1800 + var_0_1,
	preAward = var_0_2 - 43200 + var_0_1 * 3,
	topPrepare = var_0_3 + 43200 + var_0_1 * 3,
	topStart = var_0_2 + 1800 + var_0_1 * 3,
	topBattle = var_0_2 + 1800 + var_0_1 * 3,
	topOver = var_0_2 + 1800 + var_0_1 * 3
}

function var_0_0.getNextStateTime(arg_16_0, arg_16_1)
	local var_16_0 = time.getTime()

	return time.getNumTimestamp(arg_16_1) + (var_0_4[arg_16_0] or 0) - var_16_0
end

function var_0_0.getDistribute(arg_17_0, arg_17_1, arg_17_2)
	for iter_17_0, iter_17_1 in pairs(arg_17_0) do
		if iter_17_0 == arg_17_1 then
			return iter_17_1.projects[arg_17_2]
		end
	end
end

return var_0_0
