local var_0_0 = require("app.views.city.union.cross_unionfight.tools")
local var_0_1 = require("app.views.city.union.cross_unionfight.view")
local var_0_2 = require("app.views.city.union.cross_unionfight.model")
local var_0_3 = 30
local var_0_4 = {
	{
		950,
		550
	},
	{
		640,
		1000
	},
	{
		1370,
		1000
	},
	{
		2130,
		1000
	}
}
local var_0_5 = cc.load("mvc").ViewBase
local var_0_6 = class("CompetitionView", var_0_5)

var_0_6.RESOURCE_FILENAME = "cross_union_competition.json"
var_0_6.RESOURCE_BINDING = {
	unionPanel = "unionPanel",
	time = "time",
	state = "state",
	title = "title",
	titleTime = "titleTime",
	item = "item",
	bg = "bg",
	battle = "battle",
	iconBg = "iconBg",
	center = "center",
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("listData"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("normal")
					local var_1_1 = arg_1_1:get("selected")
					local var_1_2

					if arg_1_3.isSel then
						var_1_0:hide()

						local var_1_3 = var_1_1:show()
					else
						var_1_1:hide()

						local var_1_4 = var_1_0:show()
					end

					arg_1_1:get("textNote"):text(arg_1_3.str)
					arg_1_1:get("textNote"):color(arg_1_3.isSel and ui.COLORS.NORMAL.WHITE or cc.c4b(241, 61, 86, 255))
					arg_1_1:get("role"):visible(arg_1_3.role)
					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onChangePromotionPage")
			}
		}
	},
	playback = {
		varname = "playback",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("playbackView")
			}
		}
	},
	["battle.final"] = {
		varname = "final",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("finalView")
			}
		}
	},
	["battle.preliminary"] = {
		varname = "preliminary",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("preliminaryView")
			}
		}
	},
	battlefield = {
		varname = "battlefield",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("battlefieldView")
			}
		}
	}
}

function var_0_6.onCreate(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0:initModel(arg_2_1)

	arg_2_0.battleData = arg_2_2 or {}

	if arg_2_2 then
		arg_2_0.topuiView = gGameUI.topuiManager:createView("title", arg_2_0, {
			onClose = arg_2_0:createHandler("onClose")
		}):init({
			subTitle = "Building war",
			title = gLanguageCsv.ministryHouseBattle
		})

		arg_2_0.bg:show()

		arg_2_0.unionRankData = arg_2_3

		arg_2_0:qualificationView(arg_2_3.last_ranks, arg_2_3.last_ranks[5])
	else
		arg_2_0.bg:hide()
		arg_2_0:qualificationView(arg_2_0.unionClassifyData, arg_2_0.top_battle_groups)
	end

	arg_2_0:enableSchedule()
	arg_2_0:savePositionView()
	arg_2_0:unSchedule(var_0_3)
	idlereasy.when(arg_2_0.status, function(arg_3_0, arg_3_1)
		arg_2_0.center:get("round"):hide()
		arg_2_0:onUpdateStatus(arg_3_1)
	end)
end

function var_0_6.onUpdateStatus(arg_4_0, arg_4_1)
	arg_4_0.battle:hide()
	arg_4_0.battlefield:hide()
	arg_4_0.center:hide()

	if arg_4_1 == "preStart" or arg_4_1 == "preBattle" then
		arg_4_0:groupView(false, true)
		arg_4_0:startView(arg_4_1)
	elseif arg_4_1 == "preOver" then
		if arg_4_0.model.finish then
			arg_4_0:groupView(true, true)
			arg_4_0:preOverAwardView()
		else
			arg_4_0:groupView(false, true)
			arg_4_0:startView(arg_4_1)
		end
	elseif arg_4_1 == "preAward" then
		arg_4_0:groupView(true, true)
		arg_4_0:preOverAwardView()
	elseif arg_4_1 == "topPrepare" then
		arg_4_0.list:hide()
		arg_4_0:groupView()
		arg_4_0:topPrepareView()
	elseif arg_4_1 == "topStart" or arg_4_1 == "topBattle" then
		arg_4_0.list:hide()
		arg_4_0:groupView()
		arg_4_0:startView(arg_4_1)
	elseif arg_4_1 == "topOver" then
		arg_4_0.list:hide()
		arg_4_0:groupView(false, true)
		arg_4_0:startView(arg_4_1)

		if arg_4_0.unionRankData and arg_4_0.model.finish then
			arg_4_0.battle:show()

			if arg_4_0.qualification[1] then
				arg_4_0:preliminaryView()
			else
				arg_4_0.battlefield:hide()
			end

			arg_4_0:closedView()
		end
	elseif arg_4_1 == "closed" then
		arg_4_0:unSchedule(var_0_3)
		arg_4_0:groupView(true, true)

		if arg_4_0.unionRankData then
			arg_4_0.battle:show()

			if arg_4_0.battleStage == var_0_2.MatchStage.Final then
				arg_4_0:finalView()
			else
				arg_4_0:preliminaryView()
			end

			if not arg_4_0.qualification[1] then
				arg_4_0.battlefield:hide()
			end

			arg_4_0:closedView()
		end
	end
end

function var_0_6.savePositionView(arg_5_0)
	arg_5_0.iconBgPosX = arg_5_0.iconBg:x()
	arg_5_0.iconBgPosY = arg_5_0.iconBg:y()
	arg_5_0.itemPostion = {}

	for iter_5_0 = 1, 4 do
		if not arg_5_0.itemPostion[iter_5_0] then
			arg_5_0.itemPostion[iter_5_0] = {
				arg_5_0.unionPanel:get("panel" .. iter_5_0):x(),
				arg_5_0.unionPanel:get("panel" .. iter_5_0):y()
			}
		end
	end
end

function var_0_6.closedView(arg_6_0)
	arg_6_0.center:hide()
	arg_6_0:preOverAwardView()
	arg_6_0.titleTime:hide()
end

function var_0_6.qualificationView(arg_7_0, arg_7_1, arg_7_2)
	for iter_7_0, iter_7_1 in ipairs(arg_7_1 or {}) do
		if iter_7_0 <= 4 then
			for iter_7_2, iter_7_3 in ipairs(iter_7_1) do
				if iter_7_3.union_db_id == arg_7_0.unionId then
					arg_7_0.qualification[1] = true
					arg_7_0.group = iter_7_0

					break
				end
			end
		end

		if arg_7_0.qualification[1] then
			break
		end
	end

	for iter_7_4, iter_7_5 in ipairs(arg_7_2 or {}) do
		if iter_7_5.union_db_id == arg_7_0.unionId then
			arg_7_0.qualification[2] = true

			break
		end
	end
end

function var_0_6.initModel(arg_8_0, arg_8_1)
	arg_8_0.model = arg_8_1
	arg_8_0.status = gGameModel.cross_union_fight:getIdler("status")
	arg_8_0.unionClassifyData = gGameModel.cross_union_fight:read("pre_battle_groups") or {}
	arg_8_0.top_battle_groups = gGameModel.cross_union_fight:read("top_battle_groups") or {}
	arg_8_0.unions = gGameModel.cross_union_fight:read("unions")
	arg_8_0.unionId = gGameModel.union:read("id")
	arg_8_0.roleId = gGameModel.role:read("id")
	arg_8_0.roles = gGameModel.cross_union_fight:read("roles")
	arg_8_0.listData = idlers.newWithMap({})

	if not itertools.isempty(arg_8_0.competitionViewData) then
		arg_8_0.groupIdx = idler.new(arg_8_0.competitionViewData.group)
		arg_8_0.battleStage = arg_8_0.competitionViewData.type
	else
		arg_8_0.groupIdx = idler.new(1)
		arg_8_0.battleStage = var_0_2.MatchStage.Preliminary
	end

	arg_8_0.qualification = {
		false,
		false
	}
end

function var_0_6.startView(arg_9_0, arg_9_1)
	arg_9_0:unSchedule(var_0_3)
	arg_9_0.titleTime:hide()
	arg_9_0.center:show()
	arg_9_0.center:get("timeTitle"):hide()
	arg_9_0.center:get("title"):hide()

	if arg_9_1 == "preStart" or arg_9_1 == "topStart" then
		arg_9_0.center:get("title"):show()
	elseif arg_9_1 == "preBattle" or arg_9_1 == "topBattle" or arg_9_1 == "preOver" or arg_9_1 == "topOver" then
		arg_9_0.center:get("round"):show()

		local var_9_0 = string.format(gLanguageCsv.roundBattle, arg_9_0.model.battleRound)

		if arg_9_0.model.await then
			var_9_0 = var_9_0 .. gLanguageCsv.ltaskRunning .. ".."
		end

		arg_9_0.center:get("round.round"):text(var_9_0)
	end

	arg_9_0.center:get("time"):show()
	text.addEffect(arg_9_0.center:get("time"), {
		outline = {
			size = 4,
			color = ui.COLORS.NORMAL.DEFAULT
		}
	})

	local var_9_1 = gLanguageCsv.finalStage

	if arg_9_1 == "preStart" or arg_9_1 == "preBattle" or arg_9_1 == "preOver" then
		var_9_1 = gLanguageCsv.preliminaryContest
	end

	arg_9_0.title:text(var_9_1)

	local var_9_2 = gCommonConfigCsv.crossUnionFight

	if arg_9_1 == "preStart" or arg_9_1 == "preBattle" or arg_9_1 == "preOver" or arg_9_1 == "topStart" or arg_9_1 == "topBattle" or arg_9_1 == "topOver" then
		local var_9_3

		arg_9_0:schedule(function()
			local var_10_0 = arg_9_0.status:read()

			if var_10_0 == "preStart" or var_10_0 == "topStart" then
				var_9_3 = var_0_1:countDown(var_10_0, true)
			else
				var_9_3 = arg_9_0.model.countDown

				if var_9_3 == 0 then
					if arg_9_0.model.finish and (var_10_0 == "preOver" or var_10_0 == "topOver") then
						gGameApp:requestServer("/game/cross/union/fight/rank", function(arg_11_0)
							arg_9_0.unionRankData = arg_11_0.view

							arg_9_0:preOverAwardView()
							arg_9_0:setUnionInfo()
							arg_9_0:unSchedule(var_0_3)
						end)

						return
					else
						arg_9_0.model:calculationUnionPoint(arg_9_0.groupIdx:read(), function(arg_12_0)
							if arg_12_0 then
								arg_9_0:setUnionInfo()

								local var_12_0 = string.format(gLanguageCsv.roundBattle, arg_9_0.model.battleRound)

								if arg_9_0.model.await then
									var_12_0 = var_12_0 .. gLanguageCsv.ltaskRunning .. ".."
								end

								arg_9_0.center:get("round.round"):text(var_12_0)
							end
						end, arg_9_0)
					end
				end
			end

			if var_9_3 <= 0 then
				var_9_3 = 0
			end

			arg_9_0.center:get("time"):text(time.getCutDown(var_9_3).min_sec_clock)
		end, 1, 0, var_0_3)
	end
end

function var_0_6.groupView(arg_13_0, arg_13_1, arg_13_2)
	if arg_13_2 then
		local var_13_0 = {}

		for iter_13_0 = 1, 4 do
			var_13_0[iter_13_0] = {
				isSel = false,
				str = gLanguageCsv["buildOrganization" .. iter_13_0],
				role = iter_13_0 == arg_13_0.group
			}
		end

		arg_13_0.listData:update(var_13_0)

		local var_13_1 = 1

		if arg_13_0.group and arg_13_0.group <= 4 then
			var_13_1 = arg_13_0.group
		end

		if not itertools.isempty(arg_13_0.competitionViewData) then
			var_13_1 = arg_13_0.competitionViewData.group
		end

		arg_13_0.groupIdx = idler.new(var_13_1)
		arg_13_0.idxGroup = var_13_1

		arg_13_0.groupIdx:addListener(function(arg_14_0, arg_14_1)
			arg_13_0.idxGroup = arg_14_0

			if arg_13_0.listData:atproxy(arg_14_1) then
				arg_13_0.listData:atproxy(arg_14_1).isSel = false
			end

			if arg_13_0.listData:atproxy(arg_14_0) then
				arg_13_0.listData:atproxy(arg_14_0).isSel = true
			end
		end)
	end

	local var_13_2 = arg_13_0.status:read()

	if arg_13_1 then
		performWithDelay(arg_13_0, function()
			gGameApp:requestServer("/game/cross/union/fight/rank", function(arg_16_0)
				arg_13_0.unionRankData = arg_16_0.view

				arg_13_0:setUnionInfo()
			end)
		end, 0)
	elseif var_13_2 == "topStart" or var_13_2 == "preStart" then
		arg_13_0:setUnionInfo()
	else
		arg_13_0.model:calculationUnionPoint(1, function(arg_17_0)
			arg_13_0:setUnionInfo()
		end, arg_13_0)
	end
end

function var_0_6.preOverAwardView(arg_18_0)
	arg_18_0:unSchedule(var_0_3)
	arg_18_0.titleTime:show()
	arg_18_0.playback:show()

	if not itertools.isempty(arg_18_0.competitionViewData) then
		local var_18_0 = arg_18_0.competitionViewData.type == 2 and gLanguageCsv.finalMatch .. gLanguageCsv.effortAdvance or gLanguageCsv.preliminaryContest

		arg_18_0.title:text(var_18_0)
	else
		arg_18_0.title:text(gLanguageCsv.preliminaryContest)
	end

	adapt.oneLinePos(arg_18_0.title, arg_18_0.playback, cc.p(10, 0))
	arg_18_0.titleTime:text(gLanguageCsv.finalTime)
	arg_18_0.center:hide()
end

function var_0_6.topPrepareView(arg_19_0)
	arg_19_0.title:text(gLanguageCsv.finalStage)
	arg_19_0.titleTime:hide()
	arg_19_0.playback:hide()
	arg_19_0.center:show()
	arg_19_0.center:get("bg"):hide()
	arg_19_0.center:get("title"):text(gLanguageCsv.battleChampion)
	arg_19_0.center:get("time"):hide()
	arg_19_0.center:get("timeTitle"):show()
	arg_19_0.center:get("timeTitle"):text(gLanguageCsv.finalStageTime)
	text.addEffect(arg_19_0.center:get("timeTitle"), {
		outline = {
			size = 4,
			color = ui.COLORS.NORMAL.DEFAULT
		}
	})
end

function var_0_6.finalView(arg_20_0)
	arg_20_0.battleStage = var_0_2.MatchStage.Final

	arg_20_0.final:get("btn"):texture("common/btn/btn_normal.png")
	arg_20_0.preliminary:get("btn"):texture("common/btn/btn_recharge.png")
	arg_20_0.final:get("name"):setColor(ui.COLORS.NORMAL.WHITE)
	arg_20_0.preliminary:get("name"):setColor(cc.c3b(241, 61, 86))
	arg_20_0.title:text(gLanguageCsv.finalMatch .. gLanguageCsv.effortAdvance)
	adapt.oneLinePos(arg_20_0.title, arg_20_0.playback, cc.p(10, 0))
	arg_20_0.list:hide()
	arg_20_0:setUnionInfo()

	if arg_20_0.qualification and arg_20_0.qualification[2] then
		arg_20_0.battlefield:show()
	else
		arg_20_0.battlefield:hide()
	end
end

function var_0_6.preliminaryView(arg_21_0)
	arg_21_0.battleStage = var_0_2.MatchStage.Preliminary

	arg_21_0.preliminary:get("btn"):texture("common/btn/btn_normal.png")
	arg_21_0.final:get("btn"):texture("common/btn/btn_recharge.png")
	arg_21_0.preliminary:get("name"):setColor(ui.COLORS.NORMAL.WHITE)
	arg_21_0.final:get("name"):setColor(cc.c3b(241, 61, 86))
	arg_21_0.title:text(gLanguageCsv.preliminaryContest)
	adapt.oneLinePos(arg_21_0.title, arg_21_0.playback, cc.p(10, 0))
	arg_21_0.list:show()
	arg_21_0:setUnionInfo()

	if arg_21_0.qualification and arg_21_0.qualification[1] then
		arg_21_0.battlefield:show()
	else
		arg_21_0.battlefield:hide()
	end
end

function var_0_6.battlefieldView(arg_22_0)
	arg_22_0.list:show()

	local var_22_0 = {}
	local var_22_1 = arg_22_0.groupIdx:read()

	arg_22_0.competitionViewData = {
		type = arg_22_0.battleStage,
		group = var_22_1
	}

	if arg_22_0.battleStage == var_0_2.MatchStage.Preliminary then
		for iter_22_0, iter_22_1 in ipairs(arg_22_0.battleData) do
			if iter_22_0 == var_22_1 then
				var_22_0 = clone(iter_22_1)
			end
		end
	else
		var_22_0 = clone(arg_22_0.battleData[5])
	end

	gGameUI:stackUI("city.union.cross_unionfight.fight_playback", nil, nil, arg_22_0.model, arg_22_0.battleStage, var_22_0)
end

function var_0_6.setUnionInfo(arg_23_0)
	local var_23_0 = arg_23_0.groupIdx:read()

	local function var_23_1(arg_24_0, arg_24_1)
		arg_23_0.iconBg:show()
		arg_23_0.iconBg:scale(0.8)

		local var_24_0
		local var_24_1 = arg_23_0.status:read()
		local var_24_2 = false

		if not arg_23_0.model.finish and arg_23_0.model:notRequireBattle() then
			var_24_0 = arg_24_0
			var_24_2 = true
		else
			var_24_0 = itertools.size(arg_24_1) == 0 and arg_24_0 or arg_24_1
		end

		var_24_0 = var_24_0 or {}

		for iter_24_0 = 1, 4 do
			local var_24_3 = var_24_0[iter_24_0]

			if arg_23_0.unionPanel:get("noUnionIcon" .. iter_24_0) then
				arg_23_0.unionPanel:get("noUnionIcon" .. iter_24_0):removeSelf()
			end

			if var_24_3 then
				local var_24_4 = false
				local var_24_5 = arg_23_0.unionPanel:get("panel" .. iter_24_0):show()

				var_24_5:scale(0.9)
				var_24_5:get("layer.name"):text(var_24_3.union_name)
				adapt.setTextScaleWithWidth(var_24_5:get("layer.name"), nil, 270)
				var_24_5:get("layer.server"):text(string.format(gLanguageCsv.brackets, getServerArea(var_24_3.server_key, nil)))
				var_24_5:get("layer.icon"):texture(csv.union.union_logo[var_24_3.union_logo].icon)

				local var_24_6 = arg_23_0.unions[var_24_3.union_db_id].chairman_name == "" and var_24_3.union_name or arg_23_0.unions[var_24_3.union_db_id].chairman_name

				var_24_5:get("layer.unionName"):text(var_24_6)

				local var_24_7
				local var_24_8

				if var_24_2 then
					if arg_23_0.model.unionState and arg_23_0.model.unionState[var_24_3.union_db_id] then
						if arg_23_0.model.unionState[var_24_3.union_db_id][1] then
							var_24_8 = arg_23_0.model.unionState[var_24_3.union_db_id][1]
						end

						if arg_23_0.model.unionState[var_24_3.union_db_id][2] then
							var_24_7 = arg_23_0.model.unionState[var_24_3.union_db_id][2]
						end
					end

					var_24_8 = var_24_8 or var_24_3.signs_count

					if not var_24_7 then
						var_24_7 = 0
					end
				elseif itertools.size(arg_24_1) > 0 then
					var_24_7, var_24_8 = var_24_3.point, var_24_3.alive_count
				else
					var_24_7, var_24_8 = 0, var_24_3.signs_count
				end

				var_24_5:get("layer.num"):text(var_24_8 .. "/" .. var_24_3.signs_count)
				var_24_5:get("layer.pointNum"):text(var_24_7)

				local var_24_9 = var_24_5:get("layer.name"):x()
				local var_24_10 = var_24_5:get("layer.point"):y()
				local var_24_11 = var_24_5:get("layer.title"):y()

				adapt.oneLineCenterPos(cc.p(var_24_9, var_24_11), {
					var_24_5:get("layer.title"),
					var_24_5:get("layer.num")
				})
				adapt.oneLineCenterPos(cc.p(var_24_9, var_24_10), {
					var_24_5:get("layer.point"),
					var_24_5:get("layer.pointNum")
				})

				local var_24_12

				if arg_23_0.unions[var_24_3.union_db_id] and arg_23_0.unions[var_24_3.union_db_id].union_base and arg_23_0.unions[var_24_3.union_db_id].union_base.chairman_db_id then
					var_24_12 = arg_23_0.unions[var_24_3.union_db_id].union_base.chairman_db_id
				elseif arg_23_0.unions[var_24_3.union_db_id] and arg_23_0.unions[var_24_3.union_db_id].chairman_db_id then
					var_24_12 = arg_23_0.unions[var_24_3.union_db_id].chairman_db_id
				end

				local var_24_13 = 1
				local var_24_14 = arg_23_0.unions[var_24_3.union_db_id].chairman_figure == 0 and 1 or arg_23_0.unions[var_24_3.union_db_id].chairman_figure

				if var_24_12 and arg_23_0.roles[var_24_12] then
					local var_24_15 = arg_23_0.roles[var_24_12].display_card
				end

				local var_24_16 = 0

				if not var_24_2 and itertools.size(arg_24_1) > 0 then
					if iter_24_0 == 1 then
						var_24_5:get("win"):show()
					end

					var_24_5:get("bg"):scaleX(iter_24_0 == 1 and 1 or -1)
					var_24_5:get("layer.anima"):x(iter_24_0 == 1 and 436 or -165)
					var_24_5:get("layer"):x(iter_24_0 == 1 and 138 or 177)
					var_24_5:xy(var_0_4[iter_24_0][1], var_0_4[iter_24_0][2])
				else
					if iter_24_0 == 1 then
						var_24_5:get("win"):hide()
					end

					var_24_5:get("bg"):scaleX(iter_24_0 % 2 == 1 and 1 or -1)
					var_24_5:get("layer"):x(iter_24_0 % 2 == 1 and 138 or 177)
					var_24_5:get("layer.anima"):x(iter_24_0 % 2 and 436 or -165)
					var_24_5:xy(arg_23_0.itemPostion[iter_24_0][1], arg_23_0.itemPostion[iter_24_0][2])

					var_24_16 = iter_24_0 % 2 == 1 and 0 or -600
				end

				local var_24_17 = gRoleFigureCsv[var_24_14]
				local var_24_18 = var_24_5:get("layer.anima"):size()

				var_24_5:get("layer.anima"):removeAllChildren()

				local var_24_19

				if var_24_17.resSpine ~= "" then
					var_24_19 = widget.addAnimationByKey(var_24_5:get("layer.anima"), var_24_17.resSpine, "figure", "standby_loop", 4):xy(var_24_18.width / 2 + var_24_16, var_24_18.height / 4 - 150):scale(0.8)
				end

				if var_24_19 then
					var_24_5:get("layer.unionName"):x(var_24_5:get("layer.anima"):x() + var_24_16)
					var_24_5:get("layer.bg"):x(var_24_5:get("layer.anima"):x() + var_24_16)
				end

				if arg_23_0.unions[var_24_3.union_db_id].chairman_title ~= -1 then
					bind.extend(arg_23_0, var_24_5:get("layer.anima"), {
						event = "extend",
						class = "role_title",
						props = {
							data = arg_23_0.unions[var_24_3.union_db_id].chairman_title,
							onNode = function(arg_25_0)
								arg_25_0:xy(var_24_18.width / 2 + var_24_16, var_24_18.height + 80)
								arg_25_0:scale(0.9)
								arg_25_0:z(6)
							end
						}
					})
				end
			else
				arg_23_0.unionPanel:get("panel" .. iter_24_0):hide()

				local var_24_20 = arg_23_0.unionPanel:get("noUnionData"):clone():show()

				arg_23_0.unionPanel:add(var_24_20, 10, "noUnionIcon" .. iter_24_0)

				if not var_24_2 and itertools.size(arg_24_1) > 0 then
					var_24_20:xy(var_0_4[iter_24_0][1], var_0_4[iter_24_0][2])
				else
					var_24_20:xy(arg_23_0.itemPostion[iter_24_0][1], arg_23_0.itemPostion[iter_24_0][2])
				end
			end
		end

		local var_24_21 = arg_23_0.iconBgPosX
		local var_24_22 = arg_23_0.iconBgPosY

		if not var_24_2 and itertools.size(arg_24_1) > 0 then
			var_24_21 = var_24_21 + 280
			var_24_22 = var_24_22 - 130
		end

		arg_23_0.iconBg:xy(var_24_21, var_24_22)
	end

	local var_23_2 = arg_23_0.status:read()
	local var_23_3 = false

	if var_23_2 == "topOver" and arg_23_0.battleStage == var_0_2.MatchStage.Preliminary and arg_23_0.model.finish or var_23_2 == "closed" and arg_23_0.battleStage == var_0_2.MatchStage.Preliminary then
		var_23_3 = true
	end

	if var_0_0.getNowMatch(var_23_2) == 1 or var_23_3 then
		arg_23_0.iconBg:texture("city/union/cross_unionfight/img_cs_bw.png")

		local var_23_4 = {}

		if arg_23_0.unionRankData and arg_23_0.unionRankData.last_ranks and arg_23_0.unionRankData.last_ranks[var_23_0] then
			var_23_4 = arg_23_0.unionRankData.last_ranks[var_23_0]
		end

		var_23_1(arg_23_0.unionClassifyData[var_23_0], var_23_4)
	else
		arg_23_0.iconBg:texture("city/union/cross_unionfight/img_js_bw.png")

		local var_23_5 = {}

		if (var_23_2 == "closed" or var_23_2 == "topOver" and arg_23_0.model.finish) and arg_23_0.unionRankData and arg_23_0.unionRankData.last_ranks[5] then
			var_23_5 = arg_23_0.unionRankData.last_ranks[5]
		end

		var_23_1(arg_23_0.top_battle_groups, var_23_5)
	end
end

function var_0_6.onChangePromotionPage(arg_26_0, arg_26_1, arg_26_2)
	if arg_26_2 == arg_26_0.idxGroup then
		return
	end

	arg_26_0.groupIdx:set(arg_26_2)

	if not arg_26_0.unionRankData and arg_26_0.model:notRequireRank() then
		gGameApp:requestServer("/game/cross/union/fight/rank", function(arg_27_0)
			arg_26_0.unionRankData = arg_27_0.view

			arg_26_0.model:calculationUnionPoint(arg_26_2, function(arg_28_0)
				arg_26_0:setUnionInfo()
			end, arg_26_0)
		end)
	else
		arg_26_0.model:calculationUnionPoint(arg_26_2, function(arg_29_0)
			arg_26_0:setUnionInfo()
		end, arg_26_0)
	end
end

function var_0_6.playbackView(arg_30_0)
	arg_30_0.competitionViewData = {
		type = arg_30_0.battleStage,
		group = arg_30_0.groupIdx:read()
	}

	local var_30_0 = var_0_0.getNowMatch(arg_30_0.status:read()) == 2 and 5 or arg_30_0.groupIdx:read()

	if itertools.isempty(var_0_1.lastBattle) then
		gGameApp:requestServer("/game/cross/union/fight/last/battle", function(arg_31_0)
			var_0_1.lastBattle = arg_31_0.view

			gGameUI:stackUI("city.union.cross_unionfight.record", nil, {
				full = false
			}, arg_31_0.view, var_30_0, arg_30_0.unionId)
		end)
	else
		gGameUI:stackUI("city.union.cross_unionfight.record", nil, {
			full = false
		}, var_0_1.lastBattle, var_30_0, arg_30_0.unionId)
	end
end

function var_0_6.onClose(arg_32_0)
	arg_32_0.competitionViewData = {}

	var_0_5.onClose(arg_32_0)
end

return var_0_6
