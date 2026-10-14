local var_0_0 = {
	received = 2,
	noReach = 0,
	canReceive = 1
}
local var_0_1 = {
	reunion = 1,
	senior = 2
}
local var_0_2 = {
	reunion = 2,
	gift = 1
}
local var_0_3 = {
	ReunionGift = 1,
	TaskAward = 3,
	BindAward = 2,
	PointAward = 4
}
local var_0_4 = class("ReunionBindView", cc.load("mvc").ViewBase)

var_0_4.RESOURCE_FILENAME = "reunion_bind.json"
var_0_4.RESOURCE_BINDING = {
	["rightPanel.invitePanel.worldBtn"] = "worldBtn",
	["rightPanel.bindPanel.headBg"] = "bindHeadBg",
	["topPanel.bg.reunion"] = "topPanelReunion",
	["rightPanel.bindPanel.nameBg"] = "bindNameBg",
	["rightPanel.labelList"] = "rightPanelLabelList",
	["rightPanel.selfPanel.nameBg"] = "selfNameBg",
	["rightPanel.invitePanel"] = "invitePanel",
	["rightPanel.bindPanel"] = "bindPanel",
	["rightPanel.list"] = "list",
	["rightPanel.selfPanel.headBg"] = "selfHeadBg",
	["rightPanel.selfPanel"] = "selfPanel",
	["topPanel.bg.senior"] = "topPanelSenior",
	["topPanel.bg.reunion.title_0"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(233, 251, 229, 255)
				},
				shadow = {
					size = 6,
					color = cc.c4b(0, 0, 0, 255),
					offset = cc.size(0, -6)
				}
			}
		}
	},
	["topPanel.bg.reunion.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(233, 251, 229, 255)
				},
				shadow = {
					size = 6,
					color = cc.c4b(0, 0, 0, 255),
					offset = cc.size(0, -6)
				}
			}
		}
	},
	["topPanel.bg.senior.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(233, 251, 229, 255)
				},
				shadow = {
					size = 6,
					color = cc.c4b(0, 0, 0, 255),
					offset = cc.size(0, -6)
				}
			}
		}
	},
	["topPanel.btnRule"] = {
		varname = "btnRule",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRule")
			}
		}
	},
	["rightPanel.selfPanel.nameBg.name"] = {
		varname = "selfName",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["rightPanel.bindPanel.nameBg.name"] = {
		varname = "bindName",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["rightPanel.invitePanel.recommendBtn"] = {
		varname = "recommendBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRecommendBtnClick")
			}
		}
	},
	["rightPanel.goPanel"] = {
		varname = "goPanel",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onGoTaskClick")
			}
		}
	},
	["rightPanel.receiveBtn"] = {
		varname = "receiveBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onReceiveClick")
			}
		}
	},
	["rightPanel.invitePanel.worldBtn.label"] = {
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
	["rightPanel.invitePanel.recommendBtn.label"] = {
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
	["rightPanel.receiveBtn.label"] = {
		varname = "receiveBtnLabel",
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

function var_0_4.onCreate(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.yyID = arg_1_1

	local var_1_0 = csv.yunying.yyhuodong[arg_1_1]

	arg_1_0.goPanelClick = arg_1_2.goPanelClick

	local var_1_1 = arg_1_2.bindInfo

	arg_1_0:initModel()

	arg_1_0.role_type = arg_1_0.reunion:read().role_type

	bind.touch(arg_1_0, arg_1_0.worldBtn, {
		methods = {
			ended = functools.partial(arg_1_0.onWorldInvite, arg_1_0, "worldBtn")
		}
	})

	for iter_1_0, iter_1_1 in csvPairs(csv.yunying.reunion_gift) do
		if iter_1_1.huodongID == var_1_0.huodongID and iter_1_1.type == var_0_2.reunion and iter_1_1.target == arg_1_0.role_type then
			arg_1_0.csvID = iter_1_0

			uiEasy.createItemsToList(arg_1_0, arg_1_0.list, iter_1_1.item)
		end
	end

	arg_1_0.topPanelReunion:visible(var_0_1.reunion == arg_1_0.role_type)
	arg_1_0.topPanelSenior:visible(var_0_1.senior == arg_1_0.role_type)
	arg_1_0:createHead(arg_1_0.selfPanel:get("headBg"), arg_1_0.figure)
	arg_1_0.selfName:text(arg_1_0.roleName)
	arg_1_0.selfNameBg:visible(true)
	arg_1_0.selfPanel:get("noPlayer"):visible(false)
	arg_1_0.OtherRoleID:addListener(function(arg_2_0, arg_2_1)
		if arg_2_0 == arg_2_1 then
			return
		end

		if arg_2_0 ~= "" then
			arg_1_0:onGetInfo(arg_2_0, function(arg_3_0)
				local var_3_0 = arg_3_0.view

				arg_1_0:showBindInfo(var_3_0)
			end)
		else
			arg_1_0.bindPanel:get("noPlayer"):visible(true)
			arg_1_0.bindNameBg:visible(false)
		end
	end)
	idlereasy.any({
		arg_1_0.reunion,
		arg_1_0.reunionBindRoleId
	}, function(arg_4_0, arg_4_1, arg_4_2)
		if arg_1_0.role_type == var_0_1.reunion then
			if arg_4_2 then
				arg_1_0:setOtherRoleID(arg_4_2)
				arg_1_0.receiveBtn:visible(true)
				arg_1_0.invitePanel:visible(false)
				text.deleteAllEffect(arg_1_0.receiveBtnLabel)
			else
				arg_1_0.receiveBtn:visible(false)
				arg_1_0.invitePanel:visible(true)

				if arg_4_1.world_invite_time then
					local var_4_0 = time.getTime() - arg_4_1.world_invite_time

					var_4_0 = var_4_0 > 0 and var_4_0 or 30

					local var_4_1

					var_4_1 = var_4_0 < 30 and 30 - var_4_0 or 0

					arg_1_0:setBtnTime("(%s S)", var_4_1)
				end
			end

			if arg_4_1.gift.bind and arg_4_1.gift.bind[1] == arg_1_0.csvID and arg_4_1.gift.bind[2] == var_0_0.received then
				arg_1_0.goPanel:visible(true)
			end
		end

		if not arg_4_1.gift then
			cache.setShader(arg_1_0.receiveBtn, false, "hsl_gray")
			arg_1_0.receiveBtnLabel:text(gLanguageCsv.notReach)
			arg_1_0.receiveBtn:setTouchEnabled(false)
		elseif arg_4_1.gift.bind and arg_4_1.gift.bind[1] == arg_1_0.csvID and arg_4_1.gift.bind[2] == var_0_0.canReceive then
			cache.setShader(arg_1_0.receiveBtn, false, "normal")
			arg_1_0.receiveBtnLabel:text(gLanguageCsv.spaceReceive)
			text.addEffect(arg_1_0.receiveBtnLabel, {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
			arg_1_0.receiveBtn:setTouchEnabled(true)
		elseif arg_4_1.gift.bind and arg_4_1.gift.bind[1] == arg_1_0.csvID and arg_4_1.gift.bind[2] == var_0_0.received then
			cache.setShader(arg_1_0.receiveBtn, false, "hsl_gray")
			arg_1_0.receiveBtnLabel:text(gLanguageCsv.received)
			arg_1_0.receiveBtn:setTouchEnabled(false)
		end
	end)
	arg_1_0.bindPanel:get("noPlayer"):visible(true)
	arg_1_0.bindNameBg:visible(false)
	arg_1_0:showBindInfo(var_1_1)

	local var_1_2 = arg_1_0.reunion:read()

	if arg_1_0.role_type == var_0_1.reunion then
		local var_1_3 = gLanguageCsv.reunionBindTextByReunion

		arg_1_0:createRichText(var_1_3)
		gGameModel.forever_dispatch:getIdlerOrigin("reunionBindPlayer"):set(var_1_2.info.yyID)
	else
		arg_1_0.receiveBtn:visible(true)
	end
end

function var_0_4.showBindInfo(arg_5_0, arg_5_1)
	if not arg_5_1 then
		return
	end

	arg_5_0.bindPanel:get("noPlayer"):visible(false)
	arg_5_0.bindNameBg:visible(true)
	arg_5_0.bindName:text(arg_5_1.name)
	arg_5_0:createHead(arg_5_0.bindPanel:get("headBg"), arg_5_1.figure)

	if var_0_1.senior == arg_5_0.role_type then
		local var_5_0 = string.format(gLanguageCsv.reunionBindTextBySenior, arg_5_1.name)

		arg_5_0:createRichText(var_5_0)
	end

	arg_5_0.bindHeadBg:get("headBtn"):onClick(functools.partial(arg_5_0.onBindHeadBtnClick, arg_5_0, arg_5_1))
end

function var_0_4.initModel(arg_6_0, arg_6_1)
	arg_6_0.reunion = gGameModel.role:getIdler("reunion")
	arg_6_0.reunionBindRoleId = gGameModel.reunion_record:getIdler("bind_role_db_id")
	arg_6_0.figure = gGameModel.role:read("figure")
	arg_6_0.roleName = gGameModel.role:read("name")
	arg_6_0.datas = idlers.new()
	arg_6_0.OtherRoleID = idler.new(arg_6_1 and arg_6_1.id or "")

	arg_6_0.goPanel:visible(false)
	arg_6_0.invitePanel:visible(false)
end

function var_0_4.createRichText(arg_7_0, arg_7_1)
	arg_7_0.rightPanelLabelList:removeAllItems()
	beauty.textScroll({
		fontSize = 42,
		isRich = true,
		verticalSpace = 10,
		list = arg_7_0.rightPanelLabelList,
		strs = arg_7_1
	})
end

function var_0_4.createHead(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_1:get("panel")

	var_8_0:removeAllChildren()

	local var_8_1 = gRoleFigureCsv[arg_8_2]
	local var_8_2 = var_8_0:width() / 2
	local var_8_3 = 200
	local var_8_4 = cc.Sprite:create(var_8_1.res):anchorPoint(0.5, 0.5):xy(var_8_2, var_8_3):scale(0.8):addTo(var_8_0, 2, "Icon")
end

function var_0_4.setOtherRoleID(arg_9_0, arg_9_1)
	arg_9_0.OtherRoleID:set(arg_9_1)
end

function var_0_4.onReceiveClick(arg_10_0)
	if arg_10_0.reunion:read().info.end_time - time.getTime() < 0 then
		gGameUI:showTip(gLanguageCsv.activityOver)

		return
	end

	gGameApp:requestServer("/game/yy/reunion/award/get", function(arg_11_0)
		gGameUI:showGainDisplay(arg_11_0)

		if arg_10_0.role_type == var_0_1.reunion then
			arg_10_0.goPanel:visible(true)
		end
	end, arg_10_0.yyID, arg_10_0.csvID, var_0_3.BindAward)
end

function var_0_4.onGoTaskClick(arg_12_0)
	if arg_12_0.goPanelClick then
		arg_12_0.goPanelClick:set(1)
	end
end

function var_0_4.onGetInfo(arg_13_0, arg_13_1, arg_13_2)
	gGameApp:requestServer("/game/role_info", function(arg_14_0)
		if arg_13_2 then
			arg_13_2(arg_14_0)
		end
	end, arg_13_1)
end

function var_0_4.onRule(arg_15_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_15_0:createHandler("getRuleContext"))
end

function var_0_4.getRuleContext(arg_16_0, arg_16_1)
	local var_16_0 = adaptContext

	return {
		var_16_0.clone(arg_16_1.title, function(arg_17_0)
			arg_17_0:get("text"):text(gLanguageCsv.reunionRule)
		end),
		var_16_0.noteText(148),
		var_16_0.noteText(101001, 101020)
	}
end

function var_0_4.onWorldInvite(arg_18_0, arg_18_1)
	gGameApp:requestServer("/game/yy/reunion/bind/invite", function(arg_19_0)
		if arg_19_0.view.result then
			arg_18_0:setBtnTime("(%s S)", 30)
		end
	end, "world")
end

function var_0_4.onRecommendBtnClick(arg_20_0)
	local function var_20_0(arg_21_0, arg_21_1)
		gGameUI:stackUI("city.activity.reunion.invite", nil, nil, arg_21_0, arg_21_1)
	end

	require("app.views.city.activity.reunion.invite").sendProtocol(1, var_20_0)
end

function var_0_4.onBindHeadBtnClick(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_2.target
	local var_22_1, var_22_2 = var_22_0:xy()
	local var_22_3 = var_22_0:getParent():convertToWorldSpace(cc.p(var_22_1, var_22_2))

	var_22_3.x = var_22_3.x + 250
	var_22_3.y = var_22_3.y + 400

	gGameUI:stackUI("city.chat.personal_info", nil, nil, var_22_3, {
		role = arg_22_1
	})
end

function var_0_4.setBtnTime(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = 0
	local var_23_1 = arg_23_0.worldBtn
	local var_23_2 = var_23_1:name()

	arg_23_0:enableSchedule():unSchedule(var_23_2)

	if arg_23_2 > 30 or arg_23_2 <= 0 then
		cache.setShader(var_23_1, false, "normal")
		var_23_1:get("label"):text(gLanguageCsv.worldInvitation)
		var_23_1:setTouchEnabled(true)
		text.addEffect(var_23_1:get("label"), {
			outline = {
				size = 4,
				color = ui.NEWCOLORS.OUTLINE.YELLOW
			}
		})

		return
	end

	text.deleteAllEffect(var_23_1:get("label"))
	arg_23_0:enableSchedule():schedule(function(arg_24_0)
		if var_23_0 == 0 then
			cache.setShader(var_23_1, false, "hsl_gray")
			var_23_1:setTouchEnabled(false)
		end

		local var_24_0 = string.format(arg_23_1, math.floor(arg_23_2 - var_23_0))

		var_23_1:get("label"):text(var_24_0)

		var_23_0 = var_23_0 + arg_24_0

		if var_23_0 > arg_23_2 then
			cache.setShader(var_23_1, false, "normal")
			var_23_1:get("label"):text(gLanguageCsv.worldInvitation)
			text.addEffect(var_23_1:get("label"), {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
			arg_23_0:enableSchedule():unSchedule(var_23_2)
			var_23_1:setTouchEnabled(true)
		end
	end, 1, 0, var_23_2)
end

return var_0_4
