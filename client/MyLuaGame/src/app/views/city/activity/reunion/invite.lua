local var_0_0 = {
	RECOMMEND_FRIEND = 2,
	MY_FRIEND = 1
}
local var_0_1 = {
	"friendPanel",
	"recommendPanel"
}
local var_0_2 = {
	gLanguageCsv.friend,
	gLanguageCsv.invite,
	gLanguageCsv.recommend
}

local function var_0_3(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1:name() .. arg_1_1:tag()

	arg_1_0:enableSchedule():unSchedule(var_1_0)

	if arg_1_3 > 30 or arg_1_3 <= 0 then
		cache.setShader(arg_1_1, false, "normal")
		arg_1_1:get("txt"):text(gLanguageCsv.invite)
		arg_1_1:setTouchEnabled(true)

		return
	end

	local var_1_1 = 0

	arg_1_0:enableSchedule():schedule(function(arg_2_0)
		if var_1_1 == 0 then
			cache.setShader(arg_1_1, false, "hsl_gray")
			arg_1_1:setTouchEnabled(false)
		end

		local var_2_0 = string.format(arg_1_2, math.floor(arg_1_3 - var_1_1))

		arg_1_1:get("txt"):text(var_2_0)

		var_1_1 = var_1_1 + arg_2_0

		if var_1_1 > arg_1_3 then
			cache.setShader(arg_1_1, false, "normal")
			arg_1_1:get("txt"):text(gLanguageCsv.invite)
			arg_1_0:enableSchedule():unSchedule(var_1_0)
			arg_1_1:setTouchEnabled(true)
		end
	end, 1, 0, var_1_0)
end

local function var_0_4(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = time.getTime()
	local var_3_1 = arg_3_1:multiget("name", "level", "power", "txt2")

	var_3_1.name:text(arg_3_3.name)
	arg_3_1:get("iconBg"):removeAllChildren()

	local var_3_2 = {
		event = "extend",
		class = "role_logo",
		props = {
			vip = false,
			level = false,
			logoId = arg_3_3.logo,
			frameId = arg_3_3.frame,
			onNode = function(arg_4_0)
				arg_4_0:z(6)
			end
		}
	}

	bind.extend(arg_3_0, arg_3_1:get("iconBg"), var_3_2)
	var_3_1.power:text(arg_3_3.battle_fighting_point)
	var_3_1.level:text(arg_3_3.level)
	adapt.oneLinePos(var_3_1.name, {
		var_3_1.txt2
	}, cc.p(36, 0), "left")
	adapt.oneLinePos(var_3_1.txt2, {
		var_3_1.level
	}, cc.p(2, 0), "left")
end

local var_0_5 = class("ReunionInviteView", Dialog)

var_0_5.RESOURCE_FILENAME = "reunion_invite.json"
var_0_5.RESOURCE_BINDING = {
	["leftPanel.panel.title1"] = "topTitle1",
	item = "item",
	leftItem = "leftItem",
	["leftPanel.panel.friendPanel"] = "friendPanel",
	["leftPanel.panel.title2"] = "topTitle2",
	["leftPanel.panel"] = "leftPanel",
	["leftPanel.panel.recommendPanel"] = "recommendPanel",
	["leftPanel.panel.duckPanel"] = "duckPanel",
	["leftPanel.panel.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["leftPanel.panel.recommendPanel.btnChange"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChangeClick")
			}
		}
	},
	["leftPanel.panel.recommendPanel.btnChange.txt"] = {
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
	["item.btnAdd.txt"] = {
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
	["leftItem.selected.txt"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 3,
						color = ui.NEWCOLORS.OUTLINE.WHITE
					}
				}
			}
		}
	},
	["leftPanel.panel.recommendPanel.list"] = {
		varname = "recommendlists",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				data = bindHelper.self("showdata2"),
				item = bindHelper.self("item"),
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					var_0_4(arg_5_0, arg_5_1, arg_5_2, arg_5_3)

					local var_5_0 = arg_5_1:multiget("btnAdd")

					var_5_0.btnAdd:tag(100 + arg_5_2)

					if arg_5_3.inviteTime then
						local var_5_1 = time.getTime() - arg_5_3.inviteTime

						if var_5_1 <= 30 and var_5_1 > 0 then
							var_5_1 = 30 - var_5_1
						end

						var_0_3(arg_5_0, var_5_0.btnAdd, "(%s S)", var_5_1)
					end

					bind.touch(arg_5_0, var_5_0.btnAdd, {
						methods = {
							ended = functools.partial(arg_5_0.inviteFriend, arg_5_3, var_5_0.btnAdd)
						}
					})
				end
			},
			handlers = {
				inviteFriend = bindHelper.self("onInviteFriendClick")
			}
		}
	},
	["leftPanel.panel.friendPanel.list"] = {
		varname = "friendsList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				data = bindHelper.self("showdata1"),
				item = bindHelper.self("item"),
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					var_0_4(arg_6_0, arg_6_1, arg_6_2, arg_6_3)

					local var_6_0 = arg_6_1:multiget("btnAdd")

					var_6_0.btnAdd:tag(200 + arg_6_2)

					if arg_6_3.inviteTime then
						local var_6_1 = time.getTime() - arg_6_3.inviteTime

						if var_6_1 > 0 and var_6_1 <= 30 then
							var_6_1 = 30 - var_6_1
						end

						var_0_3(arg_6_0, var_6_0.btnAdd, "(%s S)", var_6_1)
					end

					bind.touch(arg_6_0, var_6_0.btnAdd, {
						methods = {
							ended = functools.partial(arg_6_0.inviteFriend, arg_6_3, var_6_0.btnAdd)
						}
					})
				end
			},
			handlers = {
				inviteFriend = bindHelper.self("onInviteFriendClick")
			}
		}
	},
	["leftPanel.panel.leftList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				padding = 5,
				data = bindHelper.self("btnsAttr"),
				item = bindHelper.self("leftItem"),
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					local var_7_0 = arg_7_1:get("normal")
					local var_7_1 = arg_7_1:get("selected")
					local var_7_2

					if arg_7_3.select then
						var_7_0:hide()

						var_7_2 = var_7_1:show()

						var_7_2:get("txt"):getVirtualRenderer():setLineSpacing(-10)
					else
						var_7_1:hide()

						var_7_2 = var_7_0:show()

						var_7_2:get("txt"):getVirtualRenderer():setLineSpacing(-10)
					end

					local var_7_3 = var_7_2:size().height - 20

					adapt.setAutoText(var_7_2:get("txt"), arg_7_3.name, var_7_3)
					var_7_1:setTouchEnabled(false)
					bind.touch(arg_7_0, var_7_0, {
						methods = {
							ended = functools.partial(arg_7_0.clickCell, arg_7_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onLeftButtonClick")
			}
		}
	}
}

function var_0_5.onCreate(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0:initModel()

	arg_8_0.showdata1 = idlers.new()
	arg_8_0.showdata2 = idlers.new()

	local var_8_0 = {
		{
			enter = false,
			name = gLanguageCsv.reunionFriendBind
		},
		{
			enter = false,
			name = gLanguageCsv.reunionInviteBind
		}
	}

	var_8_0[arg_8_1].enter = true
	arg_8_0.btnsAttr = idlers.newWithMap(var_8_0)
	arg_8_0.dropAttrTab = idler.new(1)
	arg_8_0.searchState = idler.new(false)
	arg_8_0.leftButtonTab = idler.new(arg_8_1)
	arg_8_0.datas = {}

	arg_8_0.topTitle2:text(var_0_2[3])
	arg_8_0:composeData(arg_8_1, arg_8_2)

	arg_8_0.firstEnter = true

	arg_8_0:changeTab(arg_8_1)
	arg_8_0.leftButtonTab:addListener(function(arg_9_0, arg_9_1, arg_9_2)
		arg_8_0.btnsAttr:atproxy(arg_9_1).select = false
		arg_8_0.btnsAttr:atproxy(arg_9_0).select = true

		if not arg_8_0.btnsAttr:atproxy(arg_9_0).enter or arg_9_0 == var_0_0.RECOMMEND_FRIEND then
			arg_8_0:changeTab(arg_9_0)

			arg_8_0.btnsAttr:atproxy(arg_9_0).enter = true
		else
			arg_8_0:changeTagShow(arg_9_0)
		end

		arg_8_0.topTitle1:text(var_0_2[arg_9_0])
		adapt.oneLinePos(arg_8_0.topTitle1, arg_8_0.topTitle2, cc.p(0, 0))
	end)
	Dialog.onCreate(arg_8_0)
end

function var_0_5.changeTagShow(arg_10_0, arg_10_1)
	arg_10_0.friendPanel:visible(arg_10_1 == var_0_0.MY_FRIEND)
	arg_10_0.recommendPanel:visible(arg_10_1 == var_0_0.RECOMMEND_FRIEND)
	idlereasy.do_(function(arg_11_0, arg_11_1)
		local var_11_0 = arg_10_1 == var_0_0.MY_FRIEND and #arg_11_0 == 0 or arg_10_1 == var_0_0.RECOMMEND_FRIEND and #arg_11_1 == 0

		if var_11_0 then
			arg_10_0.duckPanel:visible(var_11_0)
		else
			arg_10_0.duckPanel:hide()
		end
	end, arg_10_0.showdata1, arg_10_0.showdata2)
end

function var_0_5.composeData(arg_12_0, arg_12_1, arg_12_2)
	arg_12_2 = arg_12_2 or arg_12_0.datas[arg_12_1]

	for iter_12_0, iter_12_1 in pairs(arg_12_2) do
		if arg_12_0.reunion:read().invite_time and arg_12_0.reunion:read().invite_time[iter_12_1.id] then
			iter_12_1.inviteTime = arg_12_0.reunion:read().invite_time[iter_12_1.id]
		else
			iter_12_1.inviteTime = nil
		end
	end

	if arg_12_1 == var_0_0.MY_FRIEND then
		arg_12_0.showdata1:update(arg_12_2)
	else
		arg_12_0.showdata2:update(arg_12_2)
	end

	arg_12_0.datas[arg_12_1] = arg_12_2

	arg_12_0:changeTagShow(arg_12_0.leftButtonTab:read())
end

function var_0_5.initModel(arg_13_0)
	arg_13_0.reunion = gGameModel.role:getIdler("reunion")
end

function var_0_5.changeTab(arg_14_0, arg_14_1)
	arg_14_0:sendProtocolCountDown(arg_14_1)
end

function var_0_5.sendProtocolCountDown(arg_15_0, arg_15_1, arg_15_2)
	arg_15_2 = arg_15_2 or function(arg_16_0, arg_16_1)
		arg_15_0:composeData(arg_16_0, arg_16_1)
	end

	var_0_5.sendProtocol(arg_15_1, arg_15_2)
end

function var_0_5.onChangeClick(arg_17_0)
	arg_17_0:sendProtocolCountDown(var_0_0.RECOMMEND_FRIEND)
end

function var_0_5.onLeftButtonClick(arg_18_0, arg_18_1, arg_18_2)
	arg_18_0.leftButtonTab:set(arg_18_2)
end

function var_0_5.sendProtocol(arg_19_0, arg_19_1)
	gGameApp:requestServer("/game/yy/reunion/bind/list", function(arg_20_0)
		arg_19_1(arg_19_0, arg_20_0.view.roles)
	end, arg_19_0)
end

function var_0_5.sortItem(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0.dropAttrTab:read()
	local var_21_1 = arg_21_0.btnSelectAscOrder:read()

	return function(arg_22_0, arg_22_1)
		local var_22_0 = arg_22_0[ATTR_VAL_TYPE[var_21_0]]
		local var_22_1 = arg_22_1[ATTR_VAL_TYPE[var_21_0]]

		if var_22_0 ~= var_22_1 then
			if var_21_1 then
				return var_22_0 < var_22_1
			else
				return var_22_1 < var_22_0
			end
		end
	end
end

function var_0_5.onInviteFriendClick(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0 = {
		id = arg_23_2.id,
		level = arg_23_2.level,
		logo = arg_23_2.logo,
		name = arg_23_2.name,
		vip = arg_23_2.vip_level,
		frame = arg_23_2.frame
	}

	gGameApp:requestServer("/game/yy/reunion/bind/invite", function(arg_24_0)
		if arg_24_0.view.result then
			var_0_3(arg_23_1, arg_23_3, "(%s S)", 30)
		end
	end, "recommend", var_23_0)
end

return var_0_5
