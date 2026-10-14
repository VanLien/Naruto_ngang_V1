local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("ChatPersonalInfoView", var_0_0)

var_0_1.RESOURCE_FILENAME = "chat_personal_info.json"
var_0_1.RESOURCE_BINDING = {
	["baseNode.vip"] = "vip",
	["baseNode.level"] = "level",
	baseNode = "baseNode",
	["baseNode.txt"] = "txt",
	["baseNode.bg"] = "bg",
	["baseNode.name"] = "nodeName",
	["baseNode.iconBg"] = {
		varname = "iconBg",
		binds = {
			event = "extend",
			class = "role_logo",
			props = {
				vip = false,
				level = false,
				logoId = bindHelper.self("logoId"),
				frameId = bindHelper.self("frameId"),
				onNode = function(arg_1_0)
					arg_1_0:y(80)
				end
			}
		}
	},
	touchPanel = {
		varname = "touchPanel",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["baseNode.btnDetail"] = {
		varname = "btnDetail",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowInfo")
			}
		}
	},
	["baseNode.btnDetail.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["baseNode.btnAdd"] = {
		varname = "btnAdd",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAddFirend")
			}
		}
	},
	["baseNode.btnAdd.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["baseNode.btnBlack"] = {
		varname = "btnBlack",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDefriend")
			}
		}
	},
	["baseNode.btnBlack.txt"] = {
		varname = "defriend",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["baseNode.btnChat"] = {
		varname = "btnChat",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPrivateChat")
			}
		}
	},
	["baseNode.btnKick"] = {
		varname = "btnKick",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnKick")
			}
		}
	},
	["baseNode.btnChat.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_3 = arg_2_3 or {}

	if arg_2_3.disableTouch then
		arg_2_0.touchPanel:setTouchEnabled(false)
	end

	arg_2_0.params = arg_2_3.params
	arg_2_0.state = arg_2_3.state
	arg_2_0.cb = arg_2_3.cb
	arg_2_0.blackCb = arg_2_3.blackCb

	if arg_2_0.params then
		arg_2_0.btnChat:get("txt"):text(gLanguageCsv.delete)
	end

	arg_2_0.personData = arg_2_2

	arg_2_0:initModel()

	arg_2_0.vipLv = arg_2_2.role.vip or arg_2_2.role.vip_level or 0

	arg_2_0.nodeName:text(arg_2_2.role.name)

	arg_2_0.logoId = arg_2_2.role.logo
	arg_2_0.frameId = arg_2_2.role.frame or 1

	arg_2_0.level:text(arg_2_2.role.level)

	if arg_2_0.vipLv == 0 then
		arg_2_0.vip:hide()
	else
		arg_2_0.vip:texture(ui.VIP_ICON[arg_2_0.vipLv])
		adapt.oneLinePos(arg_2_0.nodeName, arg_2_0.vip)
	end

	if arg_2_3.isKickNum and arg_2_3.isKickNum ~= 0 and dataEasy.isUnlock(gUnlockCsv.cloneBattleKick) then
		arg_2_0.places = gGameModel.clone_room:getIdler("places")
		arg_2_0.voteRound = gGameModel.clone_room:getIdler("vote_round")

		local var_2_0 = (533 - arg_2_0.bg:height()) / 2

		arg_2_0.bg:height(533)
		arg_2_0.iconBg:y(arg_2_0.iconBg:y() + var_2_0)
		arg_2_0.level:y(arg_2_0.level:y() + var_2_0)
		arg_2_0.nodeName:y(arg_2_0.nodeName:y() + var_2_0)
		arg_2_0.btnDetail:y(arg_2_0.btnDetail:y() + var_2_0 + 20)
		arg_2_0.btnAdd:y(arg_2_0.btnAdd:y() + var_2_0 + 20)
		arg_2_0.btnBlack:y(arg_2_0.btnBlack:y() + var_2_0 + 20)
		arg_2_0.btnChat:y(arg_2_0.btnChat:y() + var_2_0 + 20)
		arg_2_0.txt:y(arg_2_0.txt:y() + var_2_0)
		arg_2_0.vip:y(arg_2_0.vip:y() + var_2_0)
		arg_2_0.btnKick:show()
		arg_2_0.btnKick:y(arg_2_0.btnKick:y() + var_2_0 + 20)
		idlereasy.when(arg_2_0.places, function(arg_3_0, arg_3_1)
			arg_2_0.isLeader = arg_2_3.isLeader

			local var_3_0 = arg_3_1[arg_2_3.isKickNum]

			if not var_3_0 then
				var_0_0.onClose(arg_2_0)

				return
			end

			arg_2_0.id = var_3_0.id
			arg_2_0.canKick = false
			arg_2_0.name = var_3_0.name

			local var_3_1 = 0

			for iter_3_0, iter_3_1 in pairs(arg_3_1) do
				if iter_3_1.play >= 3 then
					var_3_1 = var_3_1 + 1
				end
			end

			local var_3_2 = var_3_0.time
			local var_3_3 = var_3_0.play

			if arg_2_0.isLeader then
				if time.getTime() - var_3_2 > gCommonConfigCsv.cloneCanKickTime * 60 and var_3_3 <= 0 and var_3_1 >= gCommonConfigCsv.cloneCanKickFinishNum then
					arg_2_0.canKick = true
				end
			elseif var_3_3 <= 0 and time.getTime() - var_3_2 > gCommonConfigCsv.cloneCanKickTime * 60 and var_3_1 >= gCommonConfigCsv.cloneCanKickFinishNum then
				arg_2_0.canKick = true
			end

			if arg_2_0.canKick then
				cache.setShader(arg_2_0.btnKick, false, "normal")
				text.addEffect(arg_2_0.btnKick:get("txt"), {
					color = ui.COLORS.NORMAL.WHITE,
					outline = {
						size = 3,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				})
			else
				cache.setShader(arg_2_0.btnKick, false, "hsl_gray")
				text.addEffect(arg_2_0.btnKick:get("txt"), {
					color = ui.COLORS.GLOW.WHITE
				})
			end
		end)
	else
		arg_2_0.btnKick:hide()
	end

	local var_2_1 = arg_2_0.baseNode:size()
	local var_2_2 = arg_2_3.speical

	if var_2_2 and var_2_2 == "rank" then
		local var_2_3 = arg_2_3.target:size()
		local var_2_4 = arg_2_1.y >= display.height / 2
		local var_2_5

		if var_2_4 then
			var_2_5 = arg_2_1.y - var_2_1.height / 2 - var_2_3.height / 2
		else
			var_2_5 = arg_2_1.y + var_2_1.height / 2 + var_2_3.height / 2
		end

		arg_2_0.baseNode:xy(arg_2_1.x - 200, var_2_5)
	else
		local var_2_6 = arg_2_1.x + var_2_1.width / 2 + 200
		local var_2_7 = arg_2_1.y - var_2_1.height / 2
		local var_2_8 = arg_2_0.baseNode:size()
		local var_2_9 = math.max(var_2_8.height / 2, var_2_7)
		local var_2_10 = math.min(var_2_9, display.height - var_2_8.height / 2)

		arg_2_0.baseNode:xy(var_2_6, var_2_10)
	end
end

function var_0_1.initModel(arg_4_0)
	arg_4_0.myFriend = gGameModel.society:getIdler("friends")
	arg_4_0.blackList = gGameModel.society:getIdler("black_list")
	arg_4_0.friendMessage = gGameModel.messages:getIdler("private")
	arg_4_0.isBlack = false

	idlereasy.when(arg_4_0.blackList, function(arg_5_0, arg_5_1)
		local var_5_0 = itertools.include(arg_5_1, arg_4_0.personData.role.id)

		arg_4_0.defriend:text(var_5_0 and gLanguageCsv.unBlackList or gLanguageCsv.spaceBlackList)

		arg_4_0.isBlack = var_5_0
	end)
end

function var_0_1.onDefriend(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0.isBlack and "/game/society/blacklist/remove" or "/game/society/blacklist/add"
	local var_6_1 = arg_6_0.isBlack and gLanguageCsv.removeBlackListSuccess or gLanguageCsv.addBlackListSuccess

	gGameApp:requestServer(var_6_0, function(arg_7_0)
		gGameUI:showTip(var_6_1)

		if arg_6_0.blackCb then
			arg_6_0.blackCb(arg_6_0)
		end
	end, arg_6_0.personData.role.id)
end

function var_0_1.onShowInfo(arg_8_0, arg_8_1, arg_8_2)
	gGameApp:requestServer("/game/role_info", function(arg_9_0)
		gGameUI:stackUI("city.personal.other", nil, nil, arg_9_0.view)
	end, arg_8_0.personData.role.id)
end

function var_0_1.onAddFirend(arg_10_0, arg_10_1, arg_10_2)
	idlereasy.do_(function(arg_11_0)
		if itertools.include(arg_11_0, arg_10_0.personData.role.id) then
			gGameUI:showTip(gLanguageCsv.friendAlready)
		else
			gGameApp:requestServer("/game/society/friend/askfor", function(arg_12_0)
				gGameUI:showTip(gLanguageCsv.addFriendWait)
			end, {
				arg_10_0.personData.role.id
			})
		end
	end, arg_10_0.myFriend)
end

function var_0_1.onPrivateChat(arg_13_0)
	if arg_13_0.params then
		local var_13_0 = arg_13_0.personData.role.id
		local var_13_1 = false

		for iter_13_0, iter_13_1 in ipairs(arg_13_0.friendMessage:read()) do
			if iter_13_1.args and iter_13_1.args.id == var_13_0 then
				var_13_1 = true
			end
		end

		gGameApp:requestServer("/game/chat/del", function(arg_14_0)
			gGameModel.messages:delRoleChatMsg(var_13_0)

			local var_14_0 = gGameModel.messages:read("private")
			local var_14_1 = arg_13_0.cb
			local var_14_2 = arg_13_0.state

			var_0_0.onClose(arg_13_0)

			if var_14_1 then
				if itertools.isempty(var_14_0) then
					var_14_1(false, var_13_1)
				elseif var_14_2 then
					var_14_1(true, var_13_1)
				end
			end
		end, var_13_0)
	else
		gGameUI:stackUI("city.chat.privataly", nil, nil, arg_13_0.personData)
	end
end

function var_0_1.onBtnKick(arg_15_0)
	if arg_15_0.canKick and arg_15_0.isLeader then
		if arg_15_0.places:read()[1].play > 0 then
			local var_15_0 = string.format("#C0x5b545b#" .. gLanguageCsv.cloneBattleKickTip3, arg_15_0.name)

			gGameUI:showDialog({
				btnType = 2,
				isRich = true,
				content = var_15_0,
				cb = function()
					gGameApp:requestServer("/game/clone/room/kick", nil, arg_15_0.id)
					gGameUI:showTip(string.format(gLanguageCsv.cloneBattleKickTip4, arg_15_0.name))
					var_0_0.onClose(arg_15_0)
				end,
				dialogParams = {
					clickClose = false
				}
			})
		else
			gGameUI:showTip(gLanguageCsv.cloneBattleKickTip2)
		end
	elseif arg_15_0.canKick then
		if arg_15_0.voteRound:read() == "start" then
			gGameUI:showTip(gLanguageCsv.cloneBattleKickVoteTip)

			return
		end

		local var_15_1 = gGameModel.role:read("id")

		for iter_15_0, iter_15_1 in ipairs(arg_15_0.places:read()) do
			if iter_15_1.id == var_15_1 then
				if iter_15_1.play >= gCommonConfigCsv.cloneCanKickFinishNum then
					gGameApp:requestServer("/game/clone/room/vote", nil, 1)
					var_0_0.onClose(arg_15_0)
					gGameUI:stackUI("city.adventure.clone_battle.vote", nil, {
						clickClose = true
					}, true)

					break
				end

				gGameUI:showTip(gLanguageCsv.cloneBattleKickTipThreeTimes)

				break
			end
		end
	else
		gGameUI:showTip(gLanguageCsv.cloneBattleKickTip1)
	end
end

return var_0_1
