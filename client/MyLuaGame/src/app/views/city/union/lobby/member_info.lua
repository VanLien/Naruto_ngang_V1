local var_0_0 = class("UnionMemberInfoView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "union_member_info.json"
var_0_0.RESOURCE_BINDING = {
	baseNode = "baseNode",
	["baseNode.panelLogo"] = "panelLogo",
	["baseNode.bg"] = "bg",
	["baseNode.textLevel"] = "textLevel",
	["baseNode.textName"] = "textName",
	["baseNode.iconVip"] = "iconVip",
	["baseNode.btndetail"] = {
		varname = "btndetail",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtndetail")
			}
		}
	},
	["baseNode.btndetail.textNote"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["baseNode.btnFriend"] = {
		varname = "btnFriend",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnFriend")
			}
		}
	},
	["baseNode.btnFriend.textNote"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
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
				ended = bindHelper.self("onBtnChat")
			}
		}
	},
	["baseNode.btnChat.textNote"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["baseNode.btnKickOut"] = {
		varname = "btnKickOut",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnKickOut")
			}
		}
	},
	["baseNode.btnKickOut.textNote"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["baseNode.btnBossChange"] = {
		varname = "btnBossChange",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnBossChange")
			}
		}
	},
	["baseNode.btnBossChange.textNote"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["baseNode.btnUpJob"] = {
		varname = "btnUpJob",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnUpJob")
			}
		}
	},
	["baseNode.btnUpJob.textNote"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["baseNode.btnDownJob"] = {
		varname = "btnDownJob",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnDownJob")
			}
		}
	},
	["baseNode.btnDownJob.textNote"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0, arg_1_1)
	arg_1_0:initModel()

	arg_1_0.memberData = arg_1_1.memberData

	local var_1_0 = arg_1_1.memberData
	local var_1_1 = arg_1_1.myJob

	arg_1_0.viceChairmanNum = arg_1_1.viceChairmanNum
	arg_1_0.viceChairmanMax = arg_1_1.viceChairmanMax

	bind.extend(arg_1_0, arg_1_0.panelLogo, {
		event = "extend",
		class = "role_logo",
		props = {
			vip = false,
			level = false,
			logoId = var_1_0.logo,
			frameId = var_1_0.frame,
			onNode = function(arg_2_0)
				arg_2_0:scale(0.9)
			end
		}
	})
	arg_1_0.textLevel:text(var_1_0.level)
	arg_1_0.textName:text(var_1_0.name)

	if var_1_0.vip > 0 then
		arg_1_0.iconVip:texture(ui.VIP_ICON[var_1_0.vip]):show()
		adapt.oneLinePos(arg_1_0.textName, arg_1_0.iconVip, cc.p(15, 0))
	else
		arg_1_0.iconVip:hide()
	end

	arg_1_0.btnKickOut:visible(var_1_1 < var_1_0.job)
	arg_1_0.btnBossChange:visible(var_1_1 == 1)
	arg_1_0.btnUpJob:visible(var_1_1 == 1 and var_1_0.job == 3)
	arg_1_0.btnDownJob:visible(var_1_1 == 1 and var_1_0.job == 2)

	if var_1_1 == 3 then
		local var_1_2 = arg_1_0.bg:size()

		arg_1_0.bg:size(var_1_2.width, var_1_2.height - 130)
	end

	local var_1_3 = arg_1_0.baseNode:size()
	local var_1_4 = arg_1_1.pos
	local var_1_5 = arg_1_1 and arg_1_1.speical

	if var_1_5 and var_1_5 == "rank" then
		local var_1_6 = arg_1_1.target:size()
		local var_1_7 = display.height / 2 <= var_1_4.y
		local var_1_8

		if var_1_7 then
			var_1_8 = var_1_4.y - var_1_3.height / 2 - var_1_6.height / 2
		else
			var_1_8 = var_1_4.y + var_1_3.height / 2 + var_1_6.height / 2
		end

		arg_1_0.baseNode:xy(var_1_4.x - 200, var_1_8)
	else
		local var_1_9 = var_1_4.x + var_1_3.width / 2 + 200
		local var_1_10 = var_1_4.y - var_1_3.height / 2
		local var_1_11 = arg_1_0.bg:size()
		local var_1_12 = math.max(var_1_11.height / 2, var_1_10)
		local var_1_13 = math.min(var_1_12, display.height - var_1_11.height / 2)

		arg_1_0.baseNode:xy(var_1_9, var_1_13)
	end
end

function var_0_0.initModel(arg_3_0)
	arg_3_0.myFriend = gGameModel.society:getIdler("friends")
	arg_3_0.createTime = gGameModel.union:read("created_time")
end

function var_0_0.onBtndetail(arg_4_0)
	gGameApp:requestServer("/game/role_info", function(arg_5_0)
		gGameUI:stackUI("city.personal.other", nil, nil, arg_5_0.view)
	end, arg_4_0.memberData.id)
end

function var_0_0.onBtnFriend(arg_6_0)
	idlereasy.do_(function(arg_7_0)
		local var_7_0 = false

		if arg_7_0 and #arg_7_0 > 0 then
			for iter_7_0, iter_7_1 in ipairs(arg_7_0) do
				if iter_7_1.id == arg_6_0.memberData.id then
					var_7_0 = true

					break
				end
			end
		end

		if var_7_0 then
			gGameUI:showTip(gLanguageCsv.friendAlready)
		else
			gGameApp:requestServer("/game/society/friend/askfor", function(arg_8_0)
				gGameUI:showTip(gLanguageCsv.addFriendWait)
			end, {
				arg_6_0.memberData.id
			})
		end
	end, arg_6_0.myFriend)
end

function var_0_0.onBtnChat(arg_9_0)
	local var_9_0 = {
		role = arg_9_0.memberData
	}

	gGameUI:stackUI("city.chat.privataly", nil, nil, var_9_0)
end

function var_0_0.onBtnKickOut(arg_10_0)
	gGameUI:stackUI("city.union.lobby.prompt", nil, nil, {
		typ = "kick",
		content = "#C0x5B545B#" .. string.format(gLanguageCsv.unionKickMember, arg_10_0.memberData.name),
		requestParams = {
			arg_10_0.memberData.id
		},
		cb = arg_10_0:createHandler("kickCb")
	})
end

function var_0_0.kickCb(arg_11_0)
	gGameUI:showTip(gLanguageCsv.pleaseLeave)
	arg_11_0:onClose()
end

function var_0_0.onBtnBossChange(arg_12_0)
	if time.getTime() - arg_12_0.createTime <= 86400 then
		gGameUI:showTip(gLanguageCsv.cantChangeBoss)

		return
	end

	local var_12_0 = arg_12_0.memberData.job == 2 and gLanguageCsv.viceChairman or gLanguageCsv.normalMember

	gGameUI:stackUI("city.union.lobby.prompt", nil, nil, {
		typ = "swap",
		needConsider = true,
		content = dataEasy.getTextScrollStrs(string.format(gLanguageCsv.unionChangeChairman, arg_12_0.memberData.name, var_12_0)),
		requestParams = {
			arg_12_0.memberData.id
		},
		cb = arg_12_0:createHandler("bossChangeCb")
	})
end

function var_0_0.bossChangeCb(arg_13_0)
	gGameUI:showTip(gLanguageCsv.transferred)
	arg_13_0:onClose()
end

function var_0_0.onBtnUpJob(arg_14_0)
	if arg_14_0.viceChairmanNum >= arg_14_0.viceChairmanMax then
		gGameUI:showTip(gLanguageCsv.unionViceChairmanMax)

		return
	end

	gGameUI:stackUI("city.union.lobby.prompt", nil, nil, {
		typ = "promote",
		content = string.format(gLanguageCsv.unionPromoteMember, arg_14_0.memberData.name),
		numTip = string.format(gLanguageCsv.currentNumberVicePresidents, arg_14_0.viceChairmanNum, arg_14_0.viceChairmanMax),
		requestParams = {
			arg_14_0.memberData.id
		},
		cb = arg_14_0:createHandler("upJobCb")
	})
end

function var_0_0.upJobCb(arg_15_0)
	gGameUI:showTip(gLanguageCsv.promoted)
	arg_15_0:onClose()
end

function var_0_0.onBtnDownJob(arg_16_0)
	gGameUI:stackUI("city.union.lobby.prompt", nil, nil, {
		typ = "demote",
		content = string.format(gLanguageCsv.unionDemoteMember, arg_16_0.memberData.name),
		requestParams = {
			arg_16_0.memberData.id
		},
		cb = arg_16_0:createHandler("downJobCb")
	})
end

function var_0_0.downJobCb(arg_17_0)
	gGameUI:showTip(gLanguageCsv.demoted)
	arg_17_0:onClose()
end

return var_0_0
