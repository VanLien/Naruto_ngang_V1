local var_0_0 = {
	{
		scale = 0.75,
		pos = cc.p(1055, 530)
	},
	{
		scale = 0.73,
		pos = cc.p(496, 446)
	},
	{
		scale = 0.73,
		pos = cc.p(1636, 446)
	},
	{
		scale = 0.7,
		pos = cc.p(54, 306)
	},
	{
		scale = 0.7,
		pos = cc.p(2136, 306)
	},
	{
		scale = 0.7,
		pos = cc.p(1055, -90)
	},
	{
		scale = 0.7,
		pos = cc.p(670, -40)
	},
	{
		scale = 0.7,
		pos = cc.p(1460, -40)
	},
	{
		scale = 0.7,
		pos = cc.p(286, 32)
	},
	{
		scale = 0.7,
		pos = cc.p(1872, 32)
	}
}
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("OverView", var_0_1)

var_0_2.RESOURCE_FILENAME = "cross_arena_over.json"
var_0_2.RESOURCE_BINDING = {
	rolePanel1 = "rolePanel1",
	centerPanel = "centerPanel",
	rolePanel2 = "rolePanel2",
	textNote = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	}
}

function var_0_2.onCreate(arg_1_0)
	arg_1_0:initSpine()
	arg_1_0:initModel()

	arg_1_0.subView = {}

	arg_1_0:initRole()
end

function var_0_2.initSpine(arg_2_0)
	return
end

function var_0_2.initModel(arg_3_0)
	arg_3_0.round = gGameModel.cross_arena:getIdler("round")
	arg_3_0.lastRanks = gGameModel.cross_arena:getIdler("lastRanks")
end

function var_0_2.initRole(arg_4_0)
	local var_4_0 = arg_4_0.lastRanks:read()

	for iter_4_0 = 1, 3 do
		local var_4_1 = var_4_0[iter_4_0]

		if var_4_1 == nil then
			break
		end

		local var_4_2 = arg_4_0.rolePanel1:clone():addTo(arg_4_0.centerPanel:get("pos" .. iter_4_0)):xy(var_0_0[iter_4_0].pos):name("role_" .. iter_4_0)

		var_4_2:get("textName"):text(var_4_1.name)
		adapt.oneLinePos(var_4_2:get("textName"), var_4_2:get("stagePanel"), cc.p(20, 0))
		var_4_2:get("textZl"):text(var_4_1.fighting_point)
		var_4_2:get("textServer"):text(string.format(gLanguageCsv.brackets, getServerArea(var_4_1.game_key, true)))
		adapt.oneLinePos(var_4_2:get("imgZl"), {
			var_4_2:get("textZl"),
			var_4_2:get("textServer")
		}, {
			cc.p(10, 0),
			cc.p(10, 0)
		})
		bind.extend(arg_4_0, var_4_2:get("stagePanel"), {
			class = "stage_icon",
			props = {
				showStage = false,
				showStageBg = false,
				rank = var_4_1.rank,
				onNode = function(arg_5_0)
					arg_5_0:scale(0.7):y(50)
				end
			}
		})

		if var_4_1.figure ~= "" then
			local var_4_3 = var_4_2:get("role"):size()
			local var_4_4

			var_4_4 = iter_4_0 == 1 and 20 or 50

			local var_4_5 = gRoleFigureCsv[var_4_1.figure]

			widget.addAnimationByKey(var_4_2:get("role"), var_4_5.resSpine, "figure", "standby_loop", 1):xy(var_4_3.width / 2, 50):scale(var_0_0[iter_4_0].scale)
		end

		var_4_2:get("imgRank"):texture("city/pvp/cross_arena/rank_" .. iter_4_0 .. ".png")
		bind.touch(arg_4_0, var_4_2, {
			methods = {
				ended = function()
					gGameApp:requestServer("/game/cross/arena/role/info", function(arg_7_0)
						local var_7_0 = gGameUI:stackUI("city.pvp.cross_arena.personal_info", nil, {
							clickClose = true,
							dispatchNodes = arg_4_0.centerPanel
						}, arg_7_0.view)

						tip.adaptView(var_7_0, arg_4_0, {
							canvasDir = "horizontal",
							relativeNode = var_4_2,
							childsName = {
								"baseNode"
							}
						})
					end, var_4_1.record_db_id, var_4_1.game_key, var_4_1.rank)
				end
			}
		})
	end

	for iter_4_1 = 4, 10 do
		local var_4_6 = var_4_0[iter_4_1]

		if var_4_6 == nil then
			break
		end

		local var_4_7 = arg_4_0.rolePanel2:clone():addTo(arg_4_0.centerPanel:get("pos" .. iter_4_1)):xy(var_0_0[iter_4_1].pos):name("role_" .. iter_4_1)

		var_4_7:get("textName"):text(var_4_6.name)
		var_4_7:get("textZl"):text(var_4_6.fighting_point)
		var_4_7:get("textStage"):text(dataEasy.getCrossArenaStageByRank(var_4_6.rank).stageName)
		var_4_7:get("textServer"):text(string.format(gLanguageCsv.brackets, getServerArea(var_4_6.game_key, true)))
		adapt.oneLinePos(var_4_7:get("imgZl"), var_4_7:get("textZl"), cc.p(10, 0))
		adapt.oneLinePos(var_4_7:get("textStage"), var_4_7:get("textServer"), cc.p(10, 0))
		var_4_7:get("atlasLabelRank"):text(iter_4_1)

		if iter_4_1 == 10 then
			var_4_7:get("atlasLabelRank"):x(var_4_7:get("atlasLabelRank"):x() + 25)
		end

		if var_4_6.figure ~= "" then
			local var_4_8 = var_4_7:get("role"):size()
			local var_4_9 = gRoleFigureCsv[var_4_6.figure]

			widget.addAnimationByKey(var_4_7:get("role"), var_4_9.resSpine, "figure", "standby_loop", 1):xy(var_4_8.width / 2, 50):scale(var_0_0[iter_4_1].scale)
		end

		bind.touch(arg_4_0, var_4_7, {
			methods = {
				ended = function()
					gGameApp:requestServer("/game/cross/arena/role/info", function(arg_9_0)
						local var_9_0 = gGameUI:stackUI("city.pvp.cross_arena.personal_info", nil, {
							clickClose = true,
							dispatchNodes = arg_4_0.centerPanel
						}, arg_9_0.view)

						tip.adaptView(var_9_0, arg_4_0, {
							canvasDir = "horizontal",
							relativeNode = var_4_7,
							childsName = {
								"baseNode"
							}
						})
					end, var_4_6.record_db_id, var_4_6.game_key, var_4_6.rank)
				end
			}
		})
	end
end

return var_0_2
