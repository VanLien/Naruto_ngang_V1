local var_0_0 = {
	REFUSEJOIN = 2,
	APPROVEJOIN = 0,
	DIRECTJOIN = 1
}
local var_0_1 = {
	[0] = gLanguageCsv.needApply,
	gLanguageCsv.directJoin,
	gLanguageCsv.refuseJoin
}
local var_0_2 = {
	gLanguageCsv.approve,
	gLanguageCsv.approveCancle,
	gLanguageCsv.joinIn
}
local var_0_3 = cc.load("mvc").ViewBase
local var_0_4 = class("UnionJoinView", Dialog)

var_0_4.RESOURCE_FILENAME = "union_join.json"
var_0_4.RESOURCE_BINDING = {
	"noUnionInfo",
	["down.textInput"] = "textInput",
	item = "item",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	noUnionInfo = {
		binds = {
			event = "visible",
			idler = bindHelper.self("isShowTip")
		}
	},
	["title.textNote1"] = {
		varname = "textNote1",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	["title.textNote2"] = {
		varname = "textNote2",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	list = {
		varname = "listview",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("unionDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("head", "textName", "textLvNum", "textCount", "textState", "textLimitLv", "btnRight")

					var_1_0.head:get("imgIcon"):texture(csv.union.union_logo[arg_1_3.logo].icon)
					var_1_0.textName:text(arg_1_3.name)
					var_1_0.textLvNum:text(arg_1_3.level)
					var_1_0.textCount:text(string.format("%d/%d", arg_1_3.members, arg_1_3.member_max))
					var_1_0.textState:text(var_0_1[arg_1_3.join_type])
					var_1_0.textLimitLv:text(arg_1_3.join_level)

					local var_1_1 = gLanguageCsv.approve

					if arg_1_3.isApprove and arg_1_3.join_type == var_0_0.APPROVEJOIN then
						var_1_1 = gLanguageCsv.approveCancle
					elseif arg_1_3.join_type == var_0_0.DIRECTJOIN then
						var_1_1 = gLanguageCsv.joinIn
					end

					adapt.setTextScaleWithWidth(var_1_0.btnRight:get("textNote"), var_1_1, 240)
					text.addEffect(var_1_0.btnRight:get("textNote"), {
						outline = {
							size = 4,
							color = ui.NEWCOLORS.OUTLINE.YELLOW
						}
					})
					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.onClickCell, arg_1_2, arg_1_3)
						}
					})
					bind.touch(arg_1_0, var_1_0.btnRight, {
						methods = {
							ended = functools.partial(arg_1_0.onBtnClick, arg_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				onClickCell = bindHelper.self("onItemClick"),
				onBtnClick = bindHelper.self("onBtnClick")
			}
		}
	},
	["down.btnChange"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChangeUnion")
			}
		}
	},
	["down.btnChange.textNote"] = {
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
	["down.btnCreate"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onCreateUnion")
			}
		}
	},
	["down.btnCreate.textNote"] = {
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
	["down.btnJoin"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onJoinUnion")
			}
		}
	},
	["down.btnJoin.textNote"] = {
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
	["down.btnFind"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onFindUnion")
			}
		}
	},
	["down.btnClear"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClearInput")
			}
		}
	}
}

function var_0_4.onCreate(arg_2_0, arg_2_1)
	arg_2_0.oldApproveTab = {}

	adapt.oneLinePos(arg_2_0.textNote1, arg_2_0.textNote2, nil, "left")
	arg_2_0.textInput:setPlaceHolderColor(ui.NEWCOLORS.BROWN1)
	arg_2_0.textInput:setTextColor(ui.COLORS.NORMAL.DEFAULT)
	arg_2_0:initModel()

	arg_2_0.offset = 11
	arg_2_0.dbIdTab = {}

	local var_2_0 = itertools.map(arg_2_0.unionJoinQue:read() or {}, function(arg_3_0, arg_3_1)
		return arg_3_1, 1
	end)

	for iter_2_0, iter_2_1 in pairs(arg_2_1) do
		if var_2_0[iter_2_1.id] then
			arg_2_1[iter_2_0].isApprove = true
		else
			arg_2_1[iter_2_0].isApprove = false
		end

		arg_2_0.dbIdTab[iter_2_1.id] = iter_2_0
	end

	arg_2_0.isShowTip = idler.new(itertools.size(arg_2_1) <= 0)
	arg_2_0.unionDatas = idlertable.new(arg_2_1)
	arg_2_0.canQuickJoin = false

	idlereasy.when(arg_2_0.unionDatas, function(arg_4_0, arg_4_1)
		for iter_4_0, iter_4_1 in pairs(arg_4_1) do
			if iter_4_1.join_type == var_0_0.DIRECTJOIN then
				arg_2_0.canQuickJoin = true

				break
			end
		end
	end)
	idlereasy.when(arg_2_0.unionJoinQue, function(arg_5_0, arg_5_1)
		local var_5_0 = itertools.size(arg_2_0.oldApproveTab or {})
		local var_5_1 = itertools.size(arg_5_1)

		if var_5_0 >= 3 and var_5_1 >= 3 then
			local var_5_2 = itertools.map(arg_2_0.oldApproveTab, function(arg_6_0, arg_6_1)
				return arg_6_1, arg_6_0
			end)

			for iter_5_0, iter_5_1 in pairs(arg_5_1) do
				local var_5_3 = var_5_2[iter_5_1]

				if var_5_3 then
					arg_2_0.oldApproveTab[var_5_3] = nil
				end
			end

			local var_5_4, var_5_5 = next(arg_2_0.oldApproveTab)
			local var_5_6 = arg_2_0.dbIdTab[var_5_5]

			if var_5_6 then
				arg_2_0.unionDatas:proxy()[var_5_6].isApprove = false
			end
		end
	end)
	Dialog.onCreate(arg_2_0)
end

function var_0_4.initModel(arg_7_0)
	arg_7_0.unionJoinQue = gGameModel.role:getIdler("union_join_que")
end

function var_0_4.onItemClick(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	gGameUI:stackUI("city.union.join.detail", nil, nil, arg_8_2, arg_8_3, arg_8_0:createHandler("onChangeData"), arg_8_0:createHandler("onCloseFast"))
end

function var_0_4.onChangeData(arg_9_0, arg_9_1)
	arg_9_0.unionDatas:proxy()[arg_9_1].isApprove = not arg_9_0.unionDatas:proxy()[arg_9_1].isApprove
end

function var_0_4.onBtnClick(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if arg_10_3.members >= arg_10_3.member_max then
		gGameUI:showTip(gLanguageCsv.unionMemberMax)

		return
	end

	local var_10_0 = "/game/union/join"
	local var_10_1 = arg_10_3.join_type

	if arg_10_3.isApprove then
		var_10_0 = "/game/union/join/cancel"
	elseif itertools.size(arg_10_0.unionJoinQue:read()) >= 3 then
		gGameUI:showTip(gLanguageCsv.approveMax)

		arg_10_0.oldApproveTab = table.deepcopy(arg_10_0.unionJoinQue:read(), true)
	end

	gGameApp:requestServer(var_10_0, function(arg_11_0)
		if var_10_1 == var_0_0.DIRECTJOIN then
			gGameApp:requestServer("/game/union/get", function(arg_12_0)
				arg_10_0:onCloseFast()
			end)
		end

		arg_10_0:onChangeData(arg_10_2)
	end, arg_10_3.id)
end

function var_0_4.onCreateUnion(arg_13_0)
	gGameUI:stackUI("city.union.join.create", nil, nil, arg_13_0:createHandler("onCloseFast"))
end

function var_0_4.onFindUnion(arg_14_0)
	local var_14_0 = arg_14_0.textInput:text() or ""

	if string.len(var_14_0) < 1 then
		return
	end

	gGameApp:requestServer("/game/union/find", function(arg_15_0)
		arg_14_0.unionDatas:set(arg_15_0.view)
	end, var_14_0)
end

function var_0_4.onChangeUnion(arg_16_0)
	local var_16_0 = itertools.map(arg_16_0.unionJoinQue:read() or {}, function(arg_17_0, arg_17_1)
		return arg_17_1, 1
	end)

	gGameApp:requestServer("/game/union/list", function(arg_18_0)
		local var_18_0 = itertools.size(arg_18_0.view.unions)

		arg_16_0.isShowTip:set(arg_16_0.offset == 1 and var_18_0 <= 0)

		if var_18_0 > 0 then
			local var_18_1 = arg_18_0.view.unions

			for iter_18_0, iter_18_1 in pairs(var_18_1) do
				if var_16_0[iter_18_1.id] then
					var_18_1[iter_18_0].isApprove = true
				else
					var_18_1[iter_18_0].isApprove = false
				end
			end

			arg_16_0.unionDatas:set(var_18_1)

			arg_16_0.offset = var_18_0 < 10 and 1 or arg_16_0.offset + 10
		end

		arg_16_0.listview:jumpToTop()
		gGameUI:showTip(gLanguageCsv.refreshUnionList)
	end, arg_16_0.offset, 10)
end

function var_0_4.onJoinUnion(arg_19_0)
	if not arg_19_0.canQuickJoin then
		gGameUI:showTip(gLanguageCsv.noUnionToJoin)

		return
	end

	gGameApp:requestServer("/game/union/fast/join", function(arg_20_0)
		gGameApp:requestServer("/game/union/get", function(arg_21_0)
			arg_19_0:onCloseFast()
		end)
	end)
end

function var_0_4.onClearInput(arg_22_0)
	arg_22_0.textInput:text("")
end

function var_0_4.onCloseFast(arg_23_0)
	Dialog.onCloseFast(arg_23_0)
	jumpEasy.jumpTo("union")
end

return var_0_4
