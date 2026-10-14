local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("CloneBattleVoteView", Dialog)

var_0_1.RESOURCE_FILENAME = "clone_battle_kick_note.json"
var_0_1.RESOURCE_BINDING = {
	name4 = "name4",
	content = "contentLabel",
	txt4 = "txt4",
	name2 = "name2",
	txt1 = "txt1",
	txt3 = "txt3",
	name1 = "name1",
	txt2 = "txt2",
	name3 = "name3",
	closeBtn = {
		varname = "closeBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	leaveBtn = {
		varname = "leaveBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onLeaveBtn")
			}
		}
	},
	stayBtn = {
		varname = "stayBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onStayBtn")
			}
		}
	},
	["leaveBtn.txt"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	},
	["stayBtn.txt"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	},
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	}
}

function var_0_1.onCreate(arg_1_0, arg_1_1)
	arg_1_0:initModel()

	local var_1_0 = arg_1_1

	idlereasy.any({
		arg_1_0.beasIdler.finishNum,
		arg_1_0.beasIdler.places,
		arg_1_0.beasIdler.voteRound
	}, function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		if arg_2_3 == "start" then
			local var_2_0 = {}
			local var_2_1 = 0
			local var_2_2 = 0
			local var_2_3 = 0
			local var_2_4 = gGameModel.role:read("id")

			arg_1_0.name = arg_2_2[1].name

			local var_2_5 = "center"
			local var_2_6 = arg_1_0.contentLabel:size()
			local var_2_7, var_2_8 = beauty.textScroll({
				fontSize = 50,
				verticalSpace = 10,
				isRich = true,
				margin = 20,
				size = var_2_6,
				effect = {
					color = ui.COLORS.NORMAL.DEFAULT
				},
				strs = string.format("#C0x5b545b#" .. gLanguageCsv.cloneBattleKickText, arg_1_0.name),
				align = var_2_5
			})
			local var_2_9 = 0

			if var_2_8 < var_2_6.height then
				var_2_9 = -(var_2_6.height - var_2_8) / 2
			end

			var_2_7:addTo(arg_1_0.contentLabel, 10):y(var_2_9)

			for iter_2_0, iter_2_1 in pairs(arg_2_2) do
				if iter_2_1.kick_leader ~= 0 then
					table.insert(var_2_0, iter_2_1.name)

					if iter_2_1.kick_leader < 0 then
						var_2_2 = var_2_2 + 1
					else
						var_2_1 = var_2_1 + 1
					end

					if iter_2_1.id == var_2_4 then
						var_2_3 = iter_2_1.kick_leader
					end
				end
			end

			for iter_2_2 = 1, 4 do
				if var_2_0[iter_2_2] then
					arg_1_0["name" .. iter_2_2]:text(var_2_0[iter_2_2])
					arg_1_0["name" .. iter_2_2]:show()
				else
					arg_1_0["name" .. iter_2_2]:hide()
				end
			end

			if var_2_3 ~= 0 then
				cache.setShader(arg_1_0.leaveBtn, false, "hsl_gray")
				cache.setShader(arg_1_0.stayBtn, false, "hsl_gray")

				if var_2_3 == 1 then
					arg_1_0.leaveBtn:get("gou"):show()
				else
					arg_1_0.stayBtn:get("gou"):show()
				end

				adapt.oneLineCenterPos(cc.p(140, 60), {
					arg_1_0.leaveBtn:get("gou"),
					arg_1_0.leaveBtn:get("txt")
				}, cc.p(0, 0))
				adapt.oneLineCenterPos(cc.p(140, 60), {
					arg_1_0.stayBtn:get("gou"),
					arg_1_0.stayBtn:get("txt")
				}, cc.p(0, 0))
				arg_1_0.leaveBtn:setTouchEnabled(false)
				arg_1_0.stayBtn:setTouchEnabled(false)
				arg_1_0.txt3:text(string.format(gLanguageCsv.cloneBattleVote, var_2_1))
				arg_1_0.txt3:show()
				arg_1_0.txt4:text(string.format(gLanguageCsv.cloneBattleVote, var_2_2))
				arg_1_0.txt4:show()
			end

			var_1_0 = false
		elseif var_1_0 == false then
			var_0_0.onClose(arg_1_0)

			return
		end
	end)
	Dialog.onCreate(arg_1_0)
end

function var_0_1.initModel(arg_3_0)
	arg_3_0.beasIdler = {
		date = gGameModel.clone_room:getIdler("date"),
		finishNum = gGameModel.clone_room:getIdler("finish_num"),
		monsters = gGameModel.clone_room:getIdler("monsters"),
		places = gGameModel.clone_room:getIdler("places"),
		voteRound = gGameModel.clone_room:getIdler("vote_round")
	}
end

function var_0_1.onLeaveBtn(arg_4_0)
	local var_4_0 = arg_4_0.name

	gGameUI:showDialog({
		btnType = 2,
		isRich = true,
		content = "#C0x5b545b#" .. gLanguageCsv.cloneBattleKickVoteTipLeave,
		cb = function()
			gGameApp:requestServer("/game/clone/room/vote", function(arg_6_0)
				if arg_6_0.view.result == "win" then
					gGameUI:showTip(string.format(gLanguageCsv.cloneBattleKickVoteResultTipLeave, var_4_0))
				elseif arg_6_0.view.result == "fail" then
					gGameUI:showTip(string.format(gLanguageCsv.cloneBattleKickVoteResultTipStay, var_4_0))
				end
			end, 1)
		end,
		dialogParams = {
			clickClose = false
		}
	})
end

function var_0_1.onStayBtn(arg_7_0)
	local var_7_0 = arg_7_0.name

	gGameUI:showDialog({
		btnType = 2,
		isRich = true,
		content = "#C0x5b545b#" .. gLanguageCsv.cloneBattleKickVoteTipStay,
		cb = function()
			gGameApp:requestServer("/game/clone/room/vote", function(arg_9_0)
				if arg_9_0.view.result == "win" then
					gGameUI:showTip(string.format(gLanguageCsv.cloneBattleKickVoteResultTipLeave, var_7_0))
				elseif arg_9_0.view.result == "fail" then
					gGameUI:showTip(string.format(gLanguageCsv.cloneBattleKickVoteResultTipStay, var_7_0))
				end
			end, -1)
		end,
		dialogParams = {
			clickClose = false
		}
	})
end

return var_0_1
