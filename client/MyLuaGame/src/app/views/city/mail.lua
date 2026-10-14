local var_0_0 = class("MailView", Dialog)
local var_0_1 = 200
local var_0_2 = 300

local function var_0_3(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0:removeAllChildren()
	beauty.singleTextLimitWord(arg_1_1, {
		fontSize = 50,
		fontPath = "font/youmi.ttf",
		color = ui.NEWCOLORS.BROWN1
	}, {
		width = 450,
		align = arg_1_2
	}):addTo(arg_1_0, 10, "label")
end

var_0_0.RESOURCE_FILENAME = "mail.json"
var_0_0.RESOURCE_BINDING = {
	["left.textNum1"] = "textNum1",
	["left.textNum2"] = "textNum2",
	["left.noMailPanel"] = "noMailPanel",
	btnItem = "btnItem",
	["left.maskPanel"] = "maskPanel",
	["right.textTimeNote"] = "textTimeNote",
	item = "item",
	["right.textLongList"] = "textLongList",
	left = "left",
	["left.textName"] = "textName",
	["right.textSortList"] = "textSortList",
	right = "rightPanel",
	["left.title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["left.title.textTitle"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE
					}
				}
			}
		}
	},
	["left.btnList"] = {
		varname = "btnList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("topPageBtns"),
				item = bindHelper.self("btnItem"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:get("btn")
					local var_2_1

					var_2_1 = arg_2_3.canReadNum > 0 and arg_2_3.isRed ~= false

					local var_2_2 = {
						class = "red_hint",
						props = {
							state = arg_2_3.canReadNum > 0 and arg_2_3.isRed ~= false,
							onNode = function(arg_3_0)
								arg_3_0:xy(190, 80)
							end
						}
					}

					bind.extend(arg_2_0, var_2_0, var_2_2)

					local var_2_3 = var_2_0:get("textNote")

					var_2_3:text(arg_2_3.name)
					var_2_0:setTouchEnabled(not arg_2_3.isSelected)
					var_2_0:setBright(not arg_2_3.isSelected)
					bind.touch(arg_2_0, var_2_0, {
						methods = {
							ended = functools.partial(arg_2_0.itemClick, arg_2_2)
						}
					})

					if arg_2_3.isSelected then
						text.addEffect(var_2_3, {
							color = ui.COLORS.NORMAL.YELLOW,
							outline = {
								size = 1,
								color = ui.NEWCOLORS.OUTLINE.YELLOW1
							}
						})
					else
						text.addEffect(var_2_3, {
							color = ui.COLORS.NORMAL.WHITE,
							outline = {
								size = 1,
								color = ui.NEWCOLORS.OUTLINE.BLUE
							}
						})
					end
				end
			},
			handlers = {
				itemClick = bindHelper.self("onListPage")
			}
		}
	},
	["left.list"] = {
		varname = "leftList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("pageDatas"),
				item = bindHelper.self("item"),
				dataOrderCmpGen = bindHelper.self("onSortDatas", true),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:multiget("imgBG", "textTitle", "textSender", "textTime", "imgSel", "imgIcon")

					var_0_3(var_4_0.textTitle, arg_4_3.subject, "left")
					var_4_0.textSender:text(arg_4_3.sender)

					local var_4_1 = time.getDate(arg_4_3.time)

					var_4_0.textTime:text(table.concat({
						var_4_1.year,
						var_4_1.month,
						var_4_1.day
					}, "."))
					var_4_0.imgSel:visible(arg_4_3.isSelected)
					var_4_0.imgBG:visible(not arg_4_3.isSelected)

					if not arg_4_3.isRead then
						if arg_4_3.hasattach then
							var_4_0.imgIcon:texture("city/mail/icon_post0.png")
						else
							var_4_0.imgIcon:texture("city/mail/icon_post.png")
						end
					elseif arg_4_3.attachs and itertools.size(arg_4_3.attachs) > 0 or arg_4_3.hasattach then
						var_4_0.imgIcon:texture("city/mail/icon_post_open0.png")
					else
						var_4_0.imgIcon:texture("city/mail/icon_post_open.png")
					end

					bind.touch(arg_4_0, arg_4_1, {
						methods = {
							ended = functools.partial(arg_4_0.itemClick, arg_4_0:getIdx(arg_4_3.db_id), arg_4_3)
						}
					})
				end,
				onAfterBuild = function(arg_5_0)
					arg_5_0.afterBuild()
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick"),
				afterBuild = bindHelper.self("onAfterBuild")
			}
		}
	},
	["left.btnDelete"] = {
		varname = "deleteAll",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDeleteAllMail")
			}
		}
	},
	["left.btnDelete.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["left.btnGetAll"] = {
		varname = "getAll",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onGetAllMail")
			}
		}
	},
	["left.btnGetAll.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["left.btnDetail"] = {
		varname = "btnDetail",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnDetail")
			}
		}
	},
	["right.textTitle"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("rightTitle")
		}
	},
	["right.textSender"] = {
		varname = "textSender",
		binds = {
			event = "text",
			idler = bindHelper.self("textSenderName")
		}
	},
	["right.textTime"] = {
		varname = "timeText",
		binds = {
			event = "text",
			idler = bindHelper.self("textTime")
		}
	},
	["right.btnGet"] = {
		varname = "getReward",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onGetReward")
			}
		}
	},
	["right.btnGet.textNote"] = {
		varname = "getTextNote",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	}
}

function var_0_0.initModel(arg_6_0)
	arg_6_0.mailboxIdler = gGameModel.role:getIdler("mailbox")
	arg_6_0.readMailboxIdler = gGameModel.role:getIdler("read_mailbox")
	arg_6_0.myFriend = gGameModel.society:getIdler("friends")
	arg_6_0.count = gGameModel.daily_record:getIdler("union_mail_send_count")
	arg_6_0.cardCapacity = gGameModel.role:getIdler("card_capacity")
	arg_6_0.cardDatas = gGameModel.role:getIdler("cards")
	arg_6_0.roleLv = gGameModel.role:getIdler("level")
end

function var_0_0.initData(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	arg_7_0.curPage = arg_7_0.curPage or 1
	arg_7_0.datas = {}

	for iter_7_0 = 1, 2 do
		arg_7_0.datas[iter_7_0] = {}
		arg_7_0.topPageBtns:atproxy(iter_7_0).canReadNum = 0
	end

	local var_7_0 = {}
	local var_7_1 = 2
	local var_7_2 = false

	for iter_7_1, iter_7_2 in ipairs(arg_7_1) do
		local var_7_3 = arg_7_0.topPageBtns:atproxy(csv.mail[iter_7_2.type].tab)

		var_7_3.canReadNum = var_7_3.canReadNum + 1
		var_7_2 = true
		var_7_1 = math.min(var_7_1, csv.mail[iter_7_2.type].tab)
		iter_7_2.isRead = false
		iter_7_2.isSelected = false

		table.insert(var_7_0, iter_7_2)
	end

	for iter_7_3, iter_7_4 in ipairs(arg_7_2) do
		iter_7_4.isRead = true
		iter_7_4.isSelected = false

		if not var_7_2 then
			var_7_1 = math.min(var_7_1, csv.mail[iter_7_4.type].tab)
		end

		table.insert(var_7_0, iter_7_4)
	end

	table.sort(var_7_0, function(arg_8_0, arg_8_1)
		if arg_8_0.isRead == arg_8_1.isRead then
			return arg_8_0.time > arg_8_1.time
		elseif arg_8_0.isRead and not arg_8_1.isRead then
			return false
		elseif arg_8_1.isRead and not arg_8_0.isRead then
			return true
		end
	end)

	for iter_7_5, iter_7_6 in ipairs(var_7_0) do
		arg_7_0.datas[csv.mail[iter_7_6.type].tab] = arg_7_0.datas[csv.mail[iter_7_6.type].tab] or {}

		table.insert(arg_7_0.datas[csv.mail[iter_7_6.type].tab], iter_7_6)
	end

	arg_7_0.originCurrPageData = clone(arg_7_0.datas[arg_7_0.curPage])

	if arg_7_0.firstEnter then
		if not arg_7_0.showPage then
			arg_7_0.showPage = idler.new(var_7_1)
		else
			arg_7_0.showPage:set(var_7_1)
		end

		arg_7_0.firstEnter = false
	end

	if not arg_7_0.pageDatas then
		arg_7_0.pageDatas = idlers.new()

		arg_7_0.pageDatas:update(arg_7_0:composeData())
	else
		if arg_7_3 then
			if #arg_7_0.originCurrPageData < #arg_7_0.datas[arg_7_0.curPage] then
				local var_7_4 = itertools.map(itertools.ivalues(arg_7_0.originCurrPageData), function(arg_9_0, arg_9_1)
					return arg_9_1.id or arg_9_1.db_id, true
				end)
				local var_7_5 = {}

				for iter_7_7, iter_7_8 in ipairs(arg_7_0.datas[arg_7_0.curPage]) do
					if var_7_4[iter_7_8.id or iter_7_8.db_id] ~= true then
						table.insert(var_7_5, iter_7_8)
					end
				end

				table.sort(var_7_5, function(arg_10_0, arg_10_1)
					return arg_10_0.time < arg_10_1.time
				end)

				for iter_7_9, iter_7_10 in ipairs(var_7_5) do
					table.insert(arg_7_0.originCurrPageData, 1, iter_7_10)
				end
			elseif #arg_7_0.originCurrPageData > #arg_7_0.datas[arg_7_0.curPage] or arg_7_0.isOneKey then
				arg_7_0.isOneKey = false
				arg_7_0.originCurrPageData = clone(arg_7_0.datas[arg_7_0.curPage])
			end

			arg_7_0.pageDatas:update(arg_7_0:composeData())
		end

		if arg_7_0.currReadMailId:read() and arg_7_0.currReadMailId:read() ~= 0 then
			for iter_7_11, iter_7_12 in ipairs(arg_7_0.originCurrPageData) do
				if arg_7_0.currReadMailId:read() == iter_7_12.id or arg_7_0.currReadMailId:read() == iter_7_12.db_id then
					arg_7_0.selectedItem = iter_7_12.index
					arg_7_0.pageDatas:atproxy(iter_7_12.id or iter_7_12.db_id).isSelected = true
				elseif arg_7_0.pageDatas:at(iter_7_12.id or iter_7_12.db_id) and arg_7_0.pageDatas:atproxy(iter_7_12.id or iter_7_12.db_id) then
					arg_7_0.pageDatas:atproxy(iter_7_12.id or iter_7_12.db_id).isSelected = false
				end
			end
		end
	end

	arg_7_0.isShowTip:set(arg_7_0.pageDatas:size() == 0)
end

function var_0_0.onCreate(arg_11_0)
	arg_11_0:initModel()

	arg_11_0.unReadState1 = false
	arg_11_0.originData = {}
	arg_11_0.originCurrPageData = {}
	arg_11_0.firstEnter = true
	arg_11_0.isShowTip = idler.new(false)
	arg_11_0.isShowRight = idler.new(false)

	arg_11_0:showMaxMailTip()
	arg_11_0.isShowRight:addListener(function(arg_12_0, arg_12_1, arg_12_2)
		if arg_12_0 then
			local var_12_0 = arg_11_0.rightPanel:x() - 18
			local var_12_1 = arg_11_0.rightPanel:size().width
			local var_12_2 = arg_11_0.left:size().width

			arg_11_0.left:x(var_12_0 - (var_12_1 + var_12_2) / 2)
		else
			arg_11_0.left:x(display.sizeInView.width / 2)
		end

		arg_11_0.rightPanel:visible(arg_12_0)
	end)

	arg_11_0.currReadMailId = idler.new(0)
	arg_11_0.tabDatas = {
		{
			isSelected = true,
			name = gLanguageCsv.recieveMail
		},
		{
			isSelected = false,
			name = gLanguageCsv.sendMail
		}
	}
	arg_11_0.tabDatas = idlers.newWithMap(arg_11_0.tabDatas)

	local var_11_0 = {}

	arg_11_0.firDatas = idlertable.new({})
	arg_11_0.sortDatas = idlertable.new({
		""
	})
	arg_11_0.showTab = idler.new(1)

	arg_11_0.showTab:addListener(function(arg_13_0, arg_13_1, arg_13_2)
		arg_11_0.tabDatas:atproxy(arg_13_1).isSelected = false
		arg_11_0.tabDatas:atproxy(arg_13_0).isSelected = true

		arg_11_0.isShowRight:set(false)

		if arg_13_0 == 2 and arg_11_0.myFriend:read() and itertools.size(arg_11_0.myFriend:read()) ~= 0 then
			idlereasy.when(arg_11_0.myFriend, function(arg_14_0, arg_14_1)
				gGameApp:requestServer("/game/society/friend/search", function(arg_15_0)
					var_11_0[1] = arg_15_0.view.roles

					local var_15_0 = {}

					for iter_15_0, iter_15_1 in pairs(var_11_0[1]) do
						table.insert(var_15_0, clone(iter_15_1).name)
					end

					arg_11_0.selFirId = var_11_0[1][1].id

					arg_11_0.firDatas:set(var_15_0)
					arg_11_0.sortDatas:set(var_15_0)
				end, nil, nil, arg_14_1)
			end):anonyOnly(arg_11_0)
		end
	end)

	arg_11_0.topPageBtns = {
		{
			canReadNum = 0,
			isSelected = false,
			name = gLanguageCsv.nofication
		},
		{
			canReadNum = 0,
			isSelected = false,
			name = gLanguageCsv.system
		}
	}
	arg_11_0.topPageBtns = idlers.newWithMap(arg_11_0.topPageBtns)

	local function var_11_1(arg_16_0, arg_16_1)
		if arg_11_0.unReadState1 then
			arg_11_0:initData(arg_16_0, arg_16_1, false)

			arg_11_0.unReadState1 = false
		else
			arg_11_0:initData(arg_16_0, arg_16_1, true)
		end
	end

	idlereasy.any({
		arg_11_0.mailboxIdler,
		arg_11_0.readMailboxIdler
	}, function(arg_17_0, arg_17_1, arg_17_2)
		var_11_1(arg_17_1, arg_17_2)

		local var_17_0 = itertools.size(arg_17_1) + itertools.size(arg_17_2)
		local var_17_1 = game.MAIL_LIMIT

		arg_11_0.textNum1:text(var_17_0)
		arg_11_0.textNum2:text("/" .. var_17_1)
		arg_11_0.textName:text(gLanguageCsv.mailUpperLimit)
		text.addEffect(arg_11_0.textNum1, {
			color = var_17_0 - var_17_1 >= -5 and ui.COLORS.NORMAL.ALERT_ORANGE or ui.NEWCOLORS.BROWN1
		})
		adapt.oneLinePos(arg_11_0.textName, {
			arg_11_0.textNum1,
			arg_11_0.textNum2
		}, cc.p(2, 0), "left")
	end)

	arg_11_0.btnGetShow = idler.new(true)

	arg_11_0.showPage:addListener(function(arg_18_0, arg_18_1, arg_18_2)
		arg_11_0.topPageBtns:atproxy(arg_18_1).isSelected = false
		arg_11_0.topPageBtns:atproxy(arg_18_1).isRed = true
		arg_11_0.topPageBtns:atproxy(arg_18_0).isSelected = true
		arg_11_0.topPageBtns:atproxy(arg_18_0).isRed = false
		arg_11_0.originCurrPageData = clone(arg_11_0.datas[arg_18_0])

		if arg_11_0.selectedItem and arg_11_0.pageDatas:at(arg_11_0.currReadMailId:read()) then
			arg_11_0.pageDatas:atproxy(arg_11_0.currReadMailId:read()).isSelected = false
		end

		arg_11_0.pageDatas:update(arg_11_0:composeData())
		arg_11_0.currReadMailId:set(0)

		arg_11_0.selectedItem = nil
		arg_11_0.curPage = arg_18_0

		arg_11_0.isShowTip:set(arg_11_0.pageDatas:size() == 0)
	end)

	arg_11_0.isOpen = false
	arg_11_0.selFirIdx = idler.new(1)

	arg_11_0.selFirIdx:addListener(function(arg_19_0, arg_19_1, arg_19_2)
		if arg_11_0.firDatas:proxy()[arg_19_0] then
			arg_11_0.selFirId = arg_11_0.firDatas:proxy()[arg_19_0].id
		end
	end)

	arg_11_0.btnText = idler.new("")

	local var_11_2 = {
		gLanguageCsv.sendFriend,
		gLanguageCsv.guildMember
	}

	arg_11_0.sendType = idler.new(1)

	arg_11_0.sendType:addListener(function(arg_20_0, arg_20_1, arg_20_2)
		if arg_20_0 == 2 then
			gGameUI:showTip(gLanguageCsv.needJoinGuild)

			return
		end

		arg_11_0.btnText:set(var_11_2[arg_20_0])
		arg_11_0.selFirIdx:set(1)

		if var_11_0[arg_20_0] and #var_11_0[arg_20_0] > 0 then
			local var_20_0 = {}

			for iter_20_0, iter_20_1 in pairs(var_11_0[arg_20_0]) do
				table.insert(var_20_0, clone(iter_20_1).name)
			end

			arg_11_0.firDatas:set(var_20_0)
			arg_11_0.sortDatas:set(var_20_0)
		end
	end)

	arg_11_0.canGetCardNum = idler.new(0)
	arg_11_0.rightTitle = idler.new("")
	arg_11_0.textSenderName = idler.new("")
	arg_11_0.textTime = idler.new("")
	arg_11_0.textMailContent = idler.new("")

	arg_11_0.getTextNote:text(gLanguageCsv.getAccessory)
	idlereasy.when(arg_11_0.btnGetShow, function(arg_21_0, arg_21_1)
		cache.setShader(arg_11_0.getReward, false, arg_21_1 and "normal" or "hsl_gray")
		text.addEffect(arg_11_0.getTextNote, {
			outline = {
				size = 1,
				color = arg_21_1 and ui.NEWCOLORS.OUTLINE.YELLOW1 or ui.NEWCOLORS.OUTLINE.GRAY
			}
		})
		arg_11_0.getTextNote:text(arg_21_1 and gLanguageCsv.getAccessory or gLanguageCsv.received)
		arg_11_0.getReward:setTouchEnabled(arg_21_1)
	end)

	local var_11_3 = arg_11_0.timeText:y()

	idlereasy.any({
		arg_11_0.isShowTip,
		arg_11_0.showPage
	}, function(arg_22_0, arg_22_1, arg_22_2)
		arg_11_0.noMailPanel:visible(arg_22_1)
		arg_11_0.getAll:visible(not arg_22_1 and arg_22_2 == 2)
		arg_11_0.deleteAll:visible(not arg_22_1)
	end)

	arg_11_0.params = {}

	arg_11_0.roleLv:addListener(function(arg_23_0, arg_23_1)
		if arg_23_0 == arg_23_1 then
			return
		end

		function arg_11_0.params.cb()
			gGameUI:stackUI("common.upgrade_notice", nil, nil, arg_23_1)
		end
	end, true)
	Dialog.onCreate(arg_11_0)
end

function var_0_0.composeData(arg_25_0)
	local var_25_0 = {}

	for iter_25_0, iter_25_1 in ipairs(arg_25_0.originCurrPageData) do
		var_25_0[iter_25_1.db_id or iter_25_1.id] = iter_25_1
		iter_25_1.index = iter_25_0
	end

	return var_25_0
end

function var_0_0.onSaveMail(arg_26_0, arg_26_1, arg_26_2)
	if arg_26_2.name == "unselected" then
		-- block empty
	elseif arg_26_2.name == "selected" then
		-- block empty
	end
end

function var_0_0.onListPage(arg_27_0, arg_27_1, arg_27_2)
	dataEasy.tryCallFunc(arg_27_0.leftList, "setItemAction", {
		isAction = true
	})
	arg_27_0.showPage:modify(function(arg_28_0)
		return true, arg_27_2 or arg_28_0
	end)
	arg_27_0.isShowRight:set(false)
end

function var_0_0.onChangePage(arg_29_0, arg_29_1, arg_29_2)
	arg_29_0.showTab:set(arg_29_2)
end

function var_0_0.showRightPage(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	arg_30_0.rightTitle:set(arg_30_3.subject)
	arg_30_0.textSenderName:set(arg_30_3.sender)

	local var_30_0 = time.getDate(arg_30_3.time)

	arg_30_0.textTime:set(table.concat({
		var_30_0.year,
		var_30_0.month,
		var_30_0.day
	}, "."))

	local var_30_1 = arg_30_0.rightPanel:get("list")
	local var_30_2

	if itertools.isempty(arg_30_3.attachs) then
		gGameApp:requestServer("/game/role/mail/read", function()
			arg_30_0.unReadState1 = true
		end, arg_30_2.db_id or arg_30_2.id)
		nodetools.invoke(arg_30_0.rightPanel, {
			"list",
			"textOther",
			"btnGet",
			"imgLine2"
		}, "hide")

		var_30_2 = arg_30_0.textLongList

		arg_30_0.textSortList:visible(false)
		arg_30_0.textLongList:visible(true)
		arg_30_0.textTimeNote:y(55)
		arg_30_0.timeText:y(55)
	else
		nodetools.invoke(arg_30_0.rightPanel, {
			"list",
			"textOther",
			"btnGet",
			"imgLine2"
		}, "show")
		var_30_1:removeAllChildren()

		local var_30_3 = {}

		for iter_30_0, iter_30_1 in pairs(arg_30_3.attachs) do
			if string.sub(tostring(iter_30_0), 1, 4) == "type" then
				for iter_30_2, iter_30_3 in pairs(iter_30_1) do
					var_30_3[iter_30_2] = iter_30_3
				end
			else
				var_30_3[iter_30_0] = iter_30_1
			end
		end

		uiEasy.createItemsToList(arg_30_0, var_30_1, var_30_3, {
			scale = 0.8
		})

		var_30_2 = arg_30_0.textSortList

		arg_30_0.textSortList:visible(true)
		arg_30_0.textLongList:visible(false)
		arg_30_0.textTimeNote:y(200)
		arg_30_0.timeText:y(200)
	end

	beauty.textScroll({
		isRich = true,
		list = var_30_2,
		strs = "#C0x8F5E11#" .. arg_30_3.content
	})
	adapt.oneLinePos(arg_30_0.textTimeNote, arg_30_0.timeText, cc.p(0, 0), "left")

	if arg_30_3.attachs and (arg_30_3.attachs.card or arg_30_3.attachs.cards) then
		arg_30_0.canGetCardNum:set(arg_30_3.attachs.card and 1 or #arg_30_3.attachs.cards)
	else
		arg_30_0.canGetCardNum:set(0)
	end
end

function var_0_0.onItemClick(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	arg_32_0.unReadState1 = false

	local var_32_0 = arg_32_0.currReadMailId:read()

	if var_32_0 and var_32_0 ~= 0 and arg_32_0.pageDatas:atproxy(var_32_0) then
		arg_32_0.pageDatas:atproxy(var_32_0).isSelected = false
	end

	arg_32_0.pageDatas:atproxy(arg_32_3.id or arg_32_3.db_id).isSelected = true
	arg_32_0.selectedItem = arg_32_2

	arg_32_0.currReadMailId:set(arg_32_3.db_id or arg_32_3.id)
	arg_32_0.btnGetShow:set(not arg_32_0.pageDatas:atproxy(arg_32_3.id or arg_32_3.db_id).isRead)

	local var_32_1 = false

	for iter_32_0, iter_32_1 in ipairs(arg_32_0.readMailboxIdler:read()) do
		if arg_32_0.currReadMailId:read() == (iter_32_1.id or iter_32_1.db_id) then
			var_32_1 = iter_32_1

			break
		end
	end

	if var_32_1 then
		arg_32_0.isShowRight:set(true)
		arg_32_0:showRightPage(arg_32_2, arg_32_3, var_32_1)
	else
		gGameApp:requestServer("/game/role/mail/get", function(arg_33_0)
			arg_32_0.isShowRight:set(true)
			arg_32_0:showRightPage(arg_32_2, arg_32_3, arg_33_0.view)
		end, arg_32_3.db_id or arg_32_3.id)
	end
end

function var_0_0.onDeleteAllMail(arg_34_0, arg_34_1, arg_34_2)
	arg_34_0.firstEnter = true
	arg_34_0.unReadState1 = false

	idlereasy.do_(function(arg_35_0)
		if #arg_35_0 > 0 then
			gGameApp:requestServer("/game/role/mail/delete", function(arg_36_0)
				arg_34_0.isShowRight:set(false)
			end)
		end
	end, arg_34_0.readMailboxIdler)
end

function var_0_0.onGetAllMail(arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = false
	local var_37_1 = {}

	for iter_37_0, iter_37_1 in arg_37_0.pageDatas:pairs() do
		if not iter_37_1:proxy().isRead then
			var_37_0 = true

			break
		end
	end

	if var_37_0 then
		gGameApp:requestServer("/game/role/mail/read/all", function(arg_38_0)
			arg_37_0.btnGetShow:set(false)

			arg_37_0.isOneKey = true

			arg_37_0:showGainDisplayThenLevel(arg_38_0)
		end)
	else
		gGameUI:showTip(gLanguageCsv.noMail)
	end
end

function var_0_0.onGetReward(arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = arg_39_0.selectedItem

	if arg_39_0.pageDatas:atproxy(arg_39_0.currReadMailId:read()).isRead then
		gGameUI:showTip(gLanguageCsv.noMail)

		return
	end

	if arg_39_0.canGetCardNum:read() > 0 then
		local var_39_1 = false

		idlereasy.do_(function(arg_40_0, arg_40_1)
			if arg_40_1 < #arg_40_0 + arg_39_0.canGetCardNum:read() then
				gGameUI:showTip(gLanguageCsv.cardBagHaveBeenFull)

				var_39_1 = true
			end
		end, arg_39_0.cardDatas, arg_39_0.cardCapacity)

		if var_39_1 then
			return
		end
	end

	arg_39_0.unReadState1 = true
	arg_39_0.datas[arg_39_0.curPage][var_39_0].isRead = true

	arg_39_0.btnGetShow:set(false)

	arg_39_0.originCurrPageData[var_39_0].isRead = true

	gGameApp:requestServer("/game/role/mail/read", function(arg_41_0)
		arg_39_0:showGainDisplayThenLevel(arg_41_0)
	end, arg_39_0.currReadMailId:read())
end

function var_0_0.onSortDatas(arg_42_0, arg_42_1)
	return function(arg_43_0, arg_43_1)
		return arg_43_0.index < arg_43_1.index
	end
end

function var_0_0.showGainDisplayThenLevel(arg_44_0, arg_44_1, arg_44_2)
	if arg_44_2 then
		arraytools.merge_inplace(arg_44_0.params, arg_44_2)
	end

	gGameUI:showGainDisplay(arg_44_1, arg_44_0.params)
end

function var_0_0.onAfterBuild(arg_45_0)
	uiEasy.setBottomMask(arg_45_0.leftList, arg_45_0.maskPanel)
end

function var_0_0.onBtnDetail(arg_46_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_46_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_0.getRuleContext(arg_47_0, arg_47_1)
	local var_47_0 = adaptContext

	return {
		var_47_0.clone(arg_47_1.title, function(arg_48_0)
			arg_48_0:get("text"):text(gLanguageCsv.mailRule)
		end),
		var_47_0.noteText(125401, 125402)
	}
end

function var_0_0.showMaxMailTip(arg_49_0)
	local var_49_0 = dataEasy.isUnlock(gUnlockCsv.mailInfo)

	arg_49_0.btnDetail:visible(var_49_0)

	if var_49_0 and itertools.size(arg_49_0.mailboxIdler:read()) + itertools.size(arg_49_0.readMailboxIdler:read()) >= game.MAIL_LIMIT then
		local var_49_1 = time.getTime()
		local var_49_2 = "mailInfoDate"

		if gCommonConfigCsv.messageIsFull * 24 * 60 * 60 < var_49_1 - userDefault.getForeverLocalKey(var_49_2, 0, {}) then
			gGameUI:showTip(gLanguageCsv.messageIsFull)
			userDefault.setForeverLocalKey(var_49_2, var_49_1)
		end
	end
end

return var_0_0
