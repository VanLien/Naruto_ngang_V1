local var_0_0 = {
	GO = 1,
	GET = 0,
	GOT = 3,
	NONE = 2
}
local var_0_1 = {
	CHAIRMAN = 1,
	MEMBER = 3,
	VICE_CHAIRMAN = 2
}
local var_0_2 = {
	gLanguageCsv.chairman,
	gLanguageCsv.viceChairman,
	gLanguageCsv.member
}
local var_0_3 = {
	[0] = gLanguageCsv.needApply,
	gLanguageCsv.freeEntry,
	gLanguageCsv.noMoreRecruiting
}
local var_0_4 = {
	[0] = ui.COLORS.NORMAL.WHITE,
	ui.NEWCOLORS.GREEN2,
	ui.COLORS.NORMAL.RED
}

local function var_0_5(arg_1_0, arg_1_1)
	if arg_1_1.chairman == arg_1_0 then
		return var_0_1.CHAIRMAN
	end

	if arg_1_1.viceChairmans[arg_1_0] then
		return var_0_1.VICE_CHAIRMAN
	end

	return var_0_1.MEMBER
end

local function var_0_6(arg_2_0)
	local var_2_0 = csv.union.history[arg_2_0.type].fmt

	if arg_2_0.type == 3 then
		return string.format(var_2_0, arg_2_0.name1, arg_2_0.name2)
	elseif arg_2_0.type == 6 or arg_2_0.type == 8 then
		return string.format(var_2_0, arg_2_0.name2, arg_2_0.name1)
	else
		return string.format(var_2_0, arg_2_0.name1)
	end
end

local function var_0_7(arg_3_0)
	local var_3_0 = math.max(time.getTime() - arg_3_0, 0)
	local var_3_1 = time.getCutDown(var_3_0, nil, true)

	if var_3_1.day <= 0 and var_3_1.hour <= 0 and var_3_1.min <= 10 then
		return ""
	end

	return var_3_1.head_date_str .. gLanguageCsv.before
end

local function var_0_8(arg_4_0, arg_4_1)
	if var_0_7(arg_4_1) == "" then
		arg_4_0:text(gLanguageCsv.currentlyOnline)
		text.addEffect(arg_4_0, {
			color = ui.COLORS.NORMAL.FRIEND_GREEN
		})
	else
		arg_4_0:text(var_0_7(arg_4_1))
		text.addEffect(arg_4_0, {
			color = ui.COLORS.NORMAL.GRAY
		})
	end
end

local function var_0_9(arg_5_0, arg_5_1, arg_5_2)
	bind.extend(arg_5_0, arg_5_1.logo, {
		event = "extend",
		class = "role_logo",
		props = {
			vip = false,
			level = false,
			logoId = arg_5_2.logo,
			frameId = arg_5_2.frame,
			onNode = function(arg_6_0)
				arg_6_0:scale(0.9)
			end
		}
	})
	arg_5_1.vipIcon:texture(ui.VIP_ICON[arg_5_2.vip]):visible(arg_5_2.vip > 0)
	arg_5_1.textName:text(arg_5_2.name)
	adapt.oneLinePos(arg_5_1.textName, arg_5_1.vipIcon, cc.p(5, 0))
	arg_5_1.level:text(arg_5_2.level)
	arg_5_1.fighting:text(arg_5_2.fighting_point)

	local var_5_0 = arg_5_2.lasttime or arg_5_2.time

	var_0_8(arg_5_1.onlineTime, var_5_0)
end

local var_0_10 = class("UnionLobbyView", cc.load("mvc").ViewBase)

var_0_10.RESOURCE_FILENAME = "union_lobby.json"
var_0_10.RESOURCE_BINDING = {
	["leftPanel.item"] = "leftItem",
	["informationPanel.chairmanName"] = "chairmanName",
	informationItem = "informationItem",
	recordTitleItem = "recordTitleItem",
	recordItem = "recordItem",
	["informationPanel.unionExp"] = "unionExp",
	["applyPanel.state"] = "state",
	["leftPanel.bg"] = "leftbg",
	applyPanel = "applyPanel",
	["informationPanel.pos2"] = "pos2",
	recordList = "recordList",
	["informationPanel.unionMaxNum"] = "unionMaxNum",
	["informationPanel.pos1"] = "pos1",
	["informationPanel.unionNum"] = "unionNum",
	applyItem = "applyItem",
	informationPanel = "informationPanel",
	["informationPanel.pos3"] = "pos3",
	["leftPanel.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("leftDatas"),
				item = bindHelper.self("leftItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					local var_7_0 = arg_7_1:get("normal")
					local var_7_1 = arg_7_1:get("selected")
					local var_7_2

					if arg_7_3.select then
						var_7_0:hide()

						var_7_2 = var_7_1:show()
					else
						var_7_1:hide()

						var_7_2 = var_7_0:show()

						if arg_7_3.redHint then
							local var_7_3 = arg_7_3.redHint

							bind.extend(arg_7_0, var_7_2, {
								class = "red_hint",
								props = var_7_3
							})
						end
					end

					var_7_2:get("txt"):text(arg_7_3.name)
					adapt.setTextScaleWithWidth(var_7_2:get("txt"), nil, 330)
					var_7_1:setTouchEnabled(false)
					bind.touch(arg_7_0, var_7_0, {
						methods = {
							ended = functools.partial(arg_7_0.clickCell, arg_7_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onLeftItemClick")
			}
		}
	},
	["informationPanel.list"] = {
		varname = "memberList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("memberDatas"),
				item = bindHelper.self("informationItem"),
				dataOrderCmpGen = bindHelper.self("onSortMembers", true),
				roleId = bindHelper.self("roleId"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					local var_8_0 = arg_8_0.roleId:read()
					local var_8_1 = arg_8_1:multiget("logo", "vipIcon", "textName", "job", "level", "fighting", "contribution", "onlineTime")

					var_0_9(arg_8_0, var_8_1, arg_8_3)
					var_8_1.contribution:text(arg_8_3.contrib)
					var_8_1.job:text(var_0_2[arg_8_3.job])
					arg_8_1:setTouchEnabled(var_8_0 ~= arg_8_3.id)
					arg_8_1:onClick(functools.partial(arg_8_0.clickCell, arg_8_2, arg_8_3))
				end
			},
			handlers = {
				clickCell = bindHelper.self("onShowInfoClick")
			}
		}
	},
	["applyPanel.list"] = {
		varname = "applyList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("joinNotes"),
				item = bindHelper.self("applyItem"),
				myJob = bindHelper.self("myJob"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
					local var_9_0 = arg_9_0.myJob:read()
					local var_9_1 = arg_9_1:multiget("logo", "vipIcon", "textName", "level", "fighting", "applyTime", "onlineTime", "noBtn", "yesBtn")

					var_0_9(arg_9_0, var_9_1, arg_9_3)

					local var_9_2 = var_0_7(arg_9_3.time)

					if var_9_2 == "" then
						var_9_2 = gLanguageCsv.justNow
					end

					var_9_1.applyTime:text(var_9_2)
					var_9_1.noBtn:visible(var_9_0 ~= var_0_1.MEMBER)
					var_9_1.yesBtn:visible(var_9_0 ~= var_0_1.MEMBER)
					bind.touch(arg_9_0, var_9_1.noBtn, {
						methods = {
							ended = functools.partial(arg_9_0.refuseClick, arg_9_2, arg_9_3)
						}
					})
					bind.touch(arg_9_0, var_9_1.yesBtn, {
						methods = {
							ended = functools.partial(arg_9_0.acceptClick, arg_9_2, arg_9_3)
						}
					})
					arg_9_1:onClick(functools.partial(arg_9_0.detailClick, arg_9_2, arg_9_3))
				end,
				onAfterBuild = function(arg_10_0)
					arg_10_0.afterBuild()
				end
			},
			handlers = {
				refuseClick = bindHelper.self("onRefuseBtn"),
				acceptClick = bindHelper.self("onAcceptBtn"),
				detailClick = bindHelper.self("onBtnDetail"),
				afterBuild = bindHelper.self("onAfterBuild")
			}
		}
	},
	["informationPanel.logoPanel"] = {
		varname = "selectLogoBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSelectLogo")
			}
		}
	},
	["informationPanel.btnChangeName"] = {
		varname = "btnChangeName",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnChangeName")
			}
		}
	},
	["informationPanel.disbandBtn"] = {
		varname = "disbandBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDisbandBtn")
			}
		}
	},
	["informationPanel.disbandBtn.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE
				}
			}
		}
	},
	["informationPanel.changeBtn"] = {
		varname = "changeNoticeBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChangeNoticeBtn")
			}
		}
	},
	["informationPanel.changeBtn.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["informationPanel.emailBtn"] = {
		varname = "emailBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onEmailBtn")
			}
		}
	},
	["informationPanel.emailBtn.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["informationPanel.emailBtn.imgLock"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("mailUnlock"),
			method = function(arg_11_0)
				return not arg_11_0
			end
		}
	},
	["informationPanel.quitBtn"] = {
		varname = "quitBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onQuitBtn")
			}
		}
	},
	["informationPanel.btnRule"] = {
		varname = "btnRule",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleBtn")
			}
		}
	},
	["informationPanel.quitBtn.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["informationPanel.unionName"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("unionName")
		}
	},
	["informationPanel.unionId"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("uid")
		}
	},
	["informationPanel.logoPanel.logo"] = {
		binds = {
			event = "texture",
			idler = bindHelper.self("logo"),
			method = function(arg_12_0)
				return csv.union.union_logo[arg_12_0].icon
			end
		}
	},
	["informationPanel.unionLevel"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("unionLevel")
		}
	},
	["applyPanel.changeBtn"] = {
		varname = "changeStateBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChangeStateBtn")
			}
		}
	},
	["applyPanel.recruitBtn"] = {
		varname = "recruitBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRecruitBtn")
			}
		}
	},
	["applyPanel.recruitBtn.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["applyPanel.refuseBtn"] = {
		varname = "refuseBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRefuseAllBtn")
			}
		}
	},
	["applyPanel.refuseBtn.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_10.onCreate(arg_13_0)
	local var_13_0 = arg_13_0.informationItem:multiget("bg")
	local var_13_1 = arg_13_0.informationPanel:multiget("list", "listTitlePanel", "listTitlePanel.bg")
	local var_13_2 = arg_13_0.informationItem:multiget("logo", "textName", "levelNote", "level", "vipIcon", "job")
	local var_13_3 = arg_13_0.informationPanel:multiget("list", "listTitlePanel.member", "listTitlePanel.job", "logoPanel", "unionLevelNote", "unionLevel", "unionNameNote", "unionName", "chairmanNameNote", "chairmanName", "unionExpNote", "unionExp", "btnChangeName", "unionIdNote", "unionId", "unionNumNote", "unionNum", "unionMaxNum")
	local var_13_4 = arg_13_0.informationItem:multiget("contribution", "onlineTime")
	local var_13_5 = arg_13_0.informationPanel:multiget("listTitlePanel.contribution", "listTitlePanel.onlineTime", "disbandBtn", "changeBtn", "emailBtn", "quitBtn", "pos1", "pos2", "pos3")

	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_13_0.informationItem,
			"width"
		},
		{
			var_13_0,
			"width"
		},
		{
			var_13_1,
			"width"
		},
		{
			var_13_2,
			"pos",
			"center"
		},
		{
			var_13_3,
			"pos",
			"left"
		},
		{
			arg_13_0.leftbg,
			"pos",
			"left"
		},
		{
			var_13_4,
			"pos",
			"right"
		},
		{
			var_13_5,
			"pos",
			"right"
		}
	})
	arg_13_0.pos1:setTouchEnabled(false)
	arg_13_0.pos2:setTouchEnabled(false)
	arg_13_0.pos3:setTouchEnabled(false)
	arg_13_0:initModel()
	gGameUI.topuiManager:createView("union", arg_13_0, {
		onClose = arg_13_0:createHandler("onClose")
	}):init({
		subTitle = "CONSORTIA",
		title = "common/txt/txt_bt_zuzhi.png"
	})

	arg_13_0.leftDatas = {
		{
			subName = "Information",
			name = gLanguageCsv.unionInformation
		},
		{
			subName = "Record",
			name = gLanguageCsv.unionRecod
		},
		{
			subName = "Apply",
			name = gLanguageCsv.applyList,
			redHint = {
				specialTag = "unionLobby"
			}
		}
	}
	arg_13_0.leftDatas = idlers.newWithMap(arg_13_0.leftDatas)

	arg_13_0.recordList:setScrollBarEnabled(false)

	arg_13_0.showTab = idler.new(1)

	arg_13_0.showTab:addListener(function(arg_14_0, arg_14_1, arg_14_2)
		arg_13_0:setTabPanel(arg_14_0, arg_14_1)
	end)

	arg_13_0.jobList = {}
	arg_13_0.myJob = idler.new()
	arg_13_0.memberDatas = idlertable.new()

	idlereasy.any({
		arg_13_0.chairmanId,
		arg_13_0.viceChairmans,
		arg_13_0.members
	}, function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
		local var_15_0 = {
			chairman = arg_15_1
		}
		local var_15_1 = {}

		for iter_15_0, iter_15_1 in ipairs(arg_15_2) do
			var_15_1[iter_15_1] = true
		end

		var_15_0.viceChairmans = var_15_1
		arg_13_0.jobList = var_15_0

		arg_13_0.myJob:set(var_0_5(arg_13_0.roleId:read(), var_15_0))
		arg_13_0.unionNum:text(itertools.size(arg_15_3))
		adapt.oneLinePos(arg_13_0.unionNum, arg_13_0.unionMaxNum)

		local var_15_2 = var_15_0.chairman

		arg_13_0.chairmanName:text(arg_15_3[var_15_2].name)

		local var_15_3 = {}

		for iter_15_2, iter_15_3 in pairs(arg_15_3) do
			iter_15_3.job = var_0_5(iter_15_3.id, var_15_0)

			table.insert(var_15_3, iter_15_3)
		end

		dataEasy.tryCallFunc(arg_13_0.memberList, "updatePreloadCenterIndex")
		arg_13_0.memberDatas:set(var_15_3, true)
	end)
	idlereasy.when(arg_13_0.myJob, function(arg_16_0, arg_16_1)
		arg_13_0:setFunctions(arg_16_1)
	end)
	idlereasy.any({
		arg_13_0.unionLevel,
		arg_13_0.unionContrib
	}, function(arg_17_0, arg_17_1, arg_17_2)
		local var_17_0 = csv.union.union_level

		arg_13_0.unionMaxNum:text("/" .. var_17_0[arg_17_1].memberMax)

		arg_13_0.viceChairmanMax = var_17_0[arg_17_1].viceChairmanMax

		local var_17_1 = arg_17_2

		for iter_17_0 = 1, arg_17_1 - 1 do
			var_17_1 = var_17_1 - var_17_0[iter_17_0].levelUpContrib
		end

		arg_13_0.unionExp:text(var_17_1 .. "/" .. var_17_0[arg_17_1].levelUpContrib)
	end)
	idlereasy.any({
		arg_13_0.joinLevel,
		arg_13_0.joinType
	}, function(arg_18_0, arg_18_1, arg_18_2)
		local var_18_0 = var_0_3[arg_18_2]

		if arg_18_2 ~= 2 then
			var_18_0 = var_18_0 .. (arg_18_1 == 0 and gLanguageCsv.noLimit or string.format(gLanguageCsv.levelLimit, arg_18_1))
		end

		arg_13_0.state:text(var_18_0)
		text.addEffect(arg_13_0.state, {
			color = var_0_4[arg_18_2]
		})
		adapt.oneLinePos(arg_13_0.state, arg_13_0.changeStateBtn, cc.p(15, 0))
	end)
	idlereasy.when(arg_13_0.history, function(arg_19_0, arg_19_1)
		local var_19_0 = {}

		arg_13_0.recordList:removeAllChildren()

		for iter_19_0, iter_19_1 in ipairs(arg_19_1) do
			local var_19_1 = time.getDate(iter_19_1.time)

			if next(var_19_0) == nil or var_19_1.month ~= var_19_0.month or var_19_1.day ~= var_19_0.day then
				var_19_0.month = var_19_1.month
				var_19_0.day = var_19_1.day

				local var_19_2 = arg_13_0.recordTitleItem:clone():show()

				var_19_2:get("month"):text(var_19_1.month)
				var_19_2:get("day"):text(var_19_1.day)
				adapt.oneLinePos(var_19_2:get("month"), {
					var_19_2:get("monthNote"),
					var_19_2:get("day"),
					var_19_2:get("dayNote")
				}, cc.p(15, 0))
				arg_13_0.recordList:pushBackCustomItem(var_19_2)
			end

			local var_19_3 = arg_13_0.recordItem:clone():show()
			local var_19_4 = rich.createWithWidth("#C0xFFFFFF#" .. var_0_6(iter_19_1), 40, nil, 1680)

			var_19_4:setAnchorPoint(cc.p(0, 0.5))
			var_19_3:get("time"):text(string.format("%02d:%02d", var_19_1.hour, var_19_1.min))
			var_19_3:get("pos"):add(var_19_4, 3)
			arg_13_0.recordList:pushBackCustomItem(var_19_3)
		end

		arg_13_0.recordList:jumpToBottom()
	end)

	arg_13_0.mailUnlock = idler.new(dataEasy.isUnlock("unionMail"))

	idlereasy.when(arg_13_0.roleLv, function()
		arg_13_0.mailUnlock:set(dataEasy.isUnlock("unionMail"))
	end)
end

function var_0_10.initModel(arg_21_0)
	arg_21_0.roleLv = gGameModel.role:getIdler("level")

	local var_21_0 = gGameModel.union

	arg_21_0.unionId = var_21_0:getIdler("id")
	arg_21_0.history = var_21_0:getIdler("history")
	arg_21_0.joinNotes = var_21_0:getIdler("join_notes")
	arg_21_0.uid = var_21_0:getIdler("uid")
	arg_21_0.logo = var_21_0:getIdler("logo")
	arg_21_0.chairmanId = var_21_0:getIdler("chairman_db_id")
	arg_21_0.viceChairmans = var_21_0:getIdler("vice_chairmans")
	arg_21_0.joinLevel = var_21_0:getIdler("join_level")
	arg_21_0.joinType = var_21_0:getIdler("join_type")
	arg_21_0.unionLevel = var_21_0:getIdler("level")
	arg_21_0.unionContrib = var_21_0:getIdler("contrib")
	arg_21_0.members = var_21_0:getIdler("members")
	arg_21_0.unionName = var_21_0:getIdler("name")
	arg_21_0.roleId = gGameModel.role:getIdler("id")
	arg_21_0.sendMailTimes = var_21_0:getIdler("send_mail_times")
	arg_21_0.joinupInviteIimes = var_21_0:getIdler("joinup_invite_times")
end

function var_0_10.setTabPanel(arg_22_0, arg_22_1, arg_22_2)
	arg_22_0.leftDatas:atproxy(arg_22_2).select = false
	arg_22_0.leftDatas:atproxy(arg_22_1).select = true

	arg_22_0.informationPanel:visible(arg_22_1 == 1)
	arg_22_0.recordList:visible(arg_22_1 == 2)
	arg_22_0.applyPanel:visible(arg_22_1 == 3)
end

function var_0_10.setFunctions(arg_23_0, arg_23_1)
	arg_23_0.disbandBtn:visible(arg_23_1 == var_0_1.CHAIRMAN)

	local var_23_0 = arg_23_1 == var_0_1.CHAIRMAN and arg_23_0.pos2:x() or arg_23_0.pos1:x()

	arg_23_0.changeNoticeBtn:visible(arg_23_1 ~= var_0_1.MEMBER):x(var_23_0)
	arg_23_0.btnChangeName:visible(arg_23_1 == var_0_1.CHAIRMAN)

	local var_23_1 = arg_23_1 == var_0_1.CHAIRMAN and arg_23_0.pos3:x() or arg_23_0.pos2:x()

	arg_23_0.emailBtn:visible(arg_23_1 ~= var_0_1.MEMBER):x(var_23_1)
	arg_23_0.quitBtn:visible(arg_23_1 ~= var_0_1.CHAIRMAN)
	arg_23_0.changeStateBtn:visible(arg_23_1 ~= var_0_1.MEMBER)
	arg_23_0.recruitBtn:visible(arg_23_1 ~= var_0_1.MEMBER)
	arg_23_0.refuseBtn:visible(arg_23_1 ~= var_0_1.MEMBER)
	arg_23_0.selectLogoBtn:setEnabled(arg_23_1 ~= var_0_1.MEMBER)
end

function var_0_10.onSelectLogo(arg_24_0)
	gGameUI:stackUI("city.union.lobby.select_logo", nil, nil, {
		id = arg_24_0.logo:read()
	})
end

function var_0_10.onShowInfoClick(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	local var_25_0 = arg_25_4.target
	local var_25_1, var_25_2 = var_25_0:xy()
	local var_25_3 = var_25_0:getParent():convertToWorldSpace(cc.p(var_25_1 - 300, var_25_2))

	gGameUI:stackUI("city.union.lobby.member_info", nil, {
		clickClose = true,
		dispatchNodes = arg_25_1
	}, {
		memberData = arg_25_3,
		myJob = arg_25_0.myJob:read(),
		viceChairmanNum = itertools.size(arg_25_0.jobList.viceChairmans),
		viceChairmanMax = arg_25_0.viceChairmanMax,
		pos = var_25_3,
		target = arg_25_1.item:get("logo")
	})
end

function var_0_10.onBtnChangeName(arg_26_0)
	gGameUI:stackUI("city.card.changename", nil, nil, {
		typ = "union",
		name = arg_26_0.unionName:read(),
		cost = gCommonConfigCsv.unionRenameRMBCost,
		titleTxt = gLanguageCsv.unionChangeName
	})
end

function var_0_10.onDisbandBtn(arg_27_0)
	if itertools.size(arg_27_0.members:read()) > 1 then
		gGameUI:showTip(gLanguageCsv.canDissolvedOnlyOnePerson)

		return
	end

	local var_27_0 = gGameModel.role:read("cross_union_fight_status")

	if var_27_0 and var_27_0 ~= "closed" then
		gGameUI:showTip(gLanguageCsv.crossUnionNotDissolveUnion)

		return
	end

	gGameUI:stackUI("city.union.lobby.prompt", nil, nil, {
		typ = "destroy",
		needConsider = true,
		content = "#C0x5B545B#" .. gLanguageCsv.confirmDissolutionGuild,
		cb = arg_27_0:createHandler("disbandCb")
	})
end

function var_0_10.disbandCb(arg_28_0)
	arg_28_0:onBackBtnClick()
end

function var_0_10.onChangeNoticeBtn(arg_29_0)
	gGameUI:stackUI("city.union.lobby.change_notice")
end

function var_0_10.onEmailBtn(arg_30_0)
	if not arg_30_0.mailUnlock:read() then
		local var_30_0 = csv.unlock[gUnlockCsv.unionMail].startLevel

		gGameUI:showTip(string.format(gLanguageCsv.unionMailUnlockLv, var_30_0))

		return
	end

	local var_30_1 = arg_30_0.sendMailTimes:read() or 0

	if var_30_1 >= 2 then
		gGameUI:showTip(gLanguageCsv.noMailTime)

		return
	end

	gGameUI:stackUI("city.union.lobby.group_email", nil, nil, var_30_1)
end

function var_0_10.onQuitBtn(arg_31_0)
	local var_31_0 = gLanguageCsv.confirmWithdrawalFromTheGuild

	if dataEasy.isUnionBuildProtectionTime() then
		local var_31_1 = gCommonConfigCsv.newbieUnionQuitProtectDays

		var_31_0 = string.format(gLanguageCsv.newWithdrawalFromTheGuild, var_31_1 * 24)
	end

	gGameUI:stackUI("city.union.lobby.prompt", nil, nil, {
		typ = "quit",
		content = "#C0x5B545B#" .. var_31_0,
		cb = arg_31_0:createHandler("onBackBtnClick")
	})
end

function var_0_10.onRuleBtn(arg_32_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_32_0:createHandler("getRuleContext"))
end

function var_0_10.getRuleContext(arg_33_0, arg_33_1)
	local var_33_0 = adaptContext

	return {
		var_33_0.clone(arg_33_1.title),
		var_33_0.noteText(142),
		var_33_0.noteText(11001, 11099)
	}
end

function var_0_10.onBackBtnClick(arg_34_0)
	gGameUI:cleanStash()
	gGameUI:switchUI("city.view")
end

function var_0_10.onChangeStateBtn(arg_35_0)
	gGameUI:stackUI("city.union.lobby.current_state")
end

function var_0_10.onRecruitBtn(arg_36_0)
	if arg_36_0.joinType:read() == 2 then
		gGameUI:showTip(gLanguageCsv.noMoreRecruiting)

		return
	end

	local var_36_0 = arg_36_0.joinupInviteIimes:read() or 0

	if var_36_0 >= 2 then
		gGameUI:showTip(gLanguageCsv.noRecruitTime)

		return
	end

	gGameUI:stackUI("city.union.lobby.prompt", nil, nil, {
		typ = "joinup",
		content = "#C0x5B545B#" .. gLanguageCsv.publishingRecruitmentInformation,
		numTip = string.format(gLanguageCsv.sendableToday, 2 - var_36_0, 2),
		cb = arg_36_0:createHandler("recruitCb")
	})
end

function var_0_10.recruitCb(arg_37_0)
	gGameUI:showTip(gLanguageCsv.releaseSuccessful)
end

function var_0_10.onRefuseAllBtn(arg_38_0)
	if itertools.size(arg_38_0.joinNotes:read()) < 1 then
		gGameUI:showTip(gLanguageCsv.currentlyNoApplication)

		return
	end

	gGameApp:requestServer("/game/union/join/refuse/all", function(arg_39_0)
		gGameUI:showTip(gLanguageCsv.allRejected)
	end)
end

function var_0_10.onAcceptBtn(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	gGameApp:requestServer("/game/union/join/accept", function(arg_41_0)
		gGameUI:showTip(gLanguageCsv.agreed)
	end, arg_40_3.id)
end

function var_0_10.onRefuseBtn(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	gGameApp:requestServer("/game/union/join/refuse", function(arg_43_0)
		gGameUI:showTip(gLanguageCsv.rejected)
	end, arg_42_3.id)
end

function var_0_10.onBtnDetail(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
	local var_44_0 = arg_44_4.target
	local var_44_1, var_44_2 = var_44_0:xy()
	local var_44_3 = var_44_0:getParent():convertToWorldSpace(cc.p(var_44_1 - 900, var_44_2))

	arg_44_3.job = 3

	gGameUI:stackUI("city.union.lobby.member_info", nil, {
		clickClose = true,
		dispatchNodes = arg_44_1
	}, {
		myJob = 3,
		memberData = arg_44_3,
		viceChairmanNum = itertools.size(arg_44_0.jobList.viceChairmans),
		viceChairmanMax = arg_44_0.viceChairmanMax,
		pos = var_44_3,
		target = arg_44_1.item:get("logo")
	})
end

function var_0_10.onLeftItemClick(arg_45_0, arg_45_1, arg_45_2)
	arg_45_0.showTab:set(arg_45_2)
end

function var_0_10.onSortMembers(arg_46_0, arg_46_1)
	return function(arg_47_0, arg_47_1)
		if arg_47_0.job ~= arg_47_1.job then
			return arg_47_0.job < arg_47_1.job
		end

		return arg_47_0.contrib > arg_47_1.contrib
	end
end

function var_0_10.onAfterBuild(arg_48_0)
	arg_48_0.applyPanel:get("empty"):visible(arg_48_0.applyList:getChildrenCount() == 0)
end

return var_0_10
