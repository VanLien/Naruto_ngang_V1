local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = 50
local var_0_2 = {
	news = {
		icon = "city/chat/box_xtd.png",
		name = gLanguageCsv.system
	},
	world = {
		icon = "city/chat/box_sjd.png",
		name = gLanguageCsv.world
	},
	union = {
		icon = "city/chat/box_ghd.png",
		name = gLanguageCsv.guild
	},
	team = {
		icon = "city/chat/box_zdd.png",
		name = gLanguageCsv.formTeam
	},
	huodong = {
		icon = "city/chat/box_hdd.png",
		name = gLanguageCsv.activity
	},
	private = {
		icon = "city/chat/box_zdd.png",
		name = gLanguageCsv.privateChat
	}
}

local function var_0_3(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_3.isMine and "mine" or "other"
	local var_1_1 = arg_1_1:get(var_1_0):visible(true)
	local var_1_2 = var_1_1:y()
	local var_1_3 = var_1_1:multiget("txtName", "txtFlag", "vip", "imgEmoji", "imgTextBG", "imgFlagBG", "rolePanel", "title")

	var_1_3.txtFlag:text(var_0_2[arg_1_3.channel].name)

	if arg_1_3.role then
		var_1_3.txtName:text(arg_1_3.role.name)

		if arg_1_3.role.vip > 0 then
			var_1_3.vip:texture(ui.VIP_ICON[arg_1_3.role.vip]):show()
		else
			var_1_3.vip:hide()
		end

		bind.extend(arg_1_0, var_1_3.rolePanel, {
			event = "extend",
			class = "role_logo",
			props = {
				vip = false,
				logoId = arg_1_3.role.logo,
				frameId = arg_1_3.role.frame,
				level = arg_1_3.role.level,
				onNodeClick = function(arg_2_0)
					functools.partial(arg_1_0.itemClick, arg_1_2, arg_1_3, arg_1_1)(arg_2_0)
				end
			}
		})

		if arg_1_3.role.title and arg_1_3.role.title > 0 then
			bind.extend(arg_1_0, var_1_3.title, {
				event = "extend",
				class = "role_title",
				props = {
					data = arg_1_3.role.title,
					onNode = function(arg_3_0)
						var_1_3.title:size(arg_3_0:size())
						arg_3_0:alignCenter(var_1_3.title:size())
					end
				}
			})
		else
			var_1_3.title:hide()
		end

		if arg_1_3.isMine then
			adapt.oneLinePos(var_1_3.txtFlag, {
				var_1_3.vip,
				var_1_3.txtName,
				var_1_3.title
			}, {
				cc.p(30, 0),
				cc.p(10, 0)
			}, "right")
		else
			adapt.oneLinePos(var_1_3.txtFlag, {
				var_1_3.vip,
				var_1_3.title,
				var_1_3.txtName
			}, {
				cc.p(30, 0),
				cc.p(10, 0)
			}, "left")
		end
	end

	return var_1_1, var_1_2
end

local var_0_4 = class("ChatView", var_0_0)

var_0_4.RESOURCE_FILENAME = "chat.json"
var_0_4.RESOURCE_BINDING = {
	btn = "btn",
	topView = "topView",
	["chatPanel.bottomPanel.textInput"] = "textInput",
	item = "item",
	chatPanel = "chatPanel",
	["chatPanel.bottomPanel"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("bottomShow")
		}
	},
	["chatPanel.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["chatPanel.closePanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["chatPanel.bottomPanel.btnSend"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSendClick")
			}
		}
	},
	["chatPanel.bottomPanel.btnSend.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["chatPanel.bottomPanel.btnPicture"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPictureClick")
			}
		}
	},
	["btn.selected.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["chatPanel.btnList"] = {
		varname = "btnList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("btnsInfo"),
				item = bindHelper.self("btn"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:get("normal")
					local var_4_1 = arg_4_1:get("selected")
					local var_4_2

					if arg_4_3.select then
						var_4_0:hide()

						var_4_2 = var_4_1:show()
					else
						var_4_1:hide()

						var_4_2 = var_4_0:show()
					end

					local var_4_3 = var_4_2:size().height - 20

					var_4_2:get("txt"):text(arg_4_3.name):scale(0.65)
					bind.touch(arg_4_0, arg_4_1, {
						methods = {
							ended = functools.partial(arg_4_0.itemClick, arg_4_2)
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onChangePage")
			}
		}
	},
	["chatPanel.list"] = {
		varname = "contentList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				preloadBottom = true,
				asyncPreload = 9,
				data = bindHelper.self("contents"),
				item = bindHelper.self("item"),
				isRefresh = bindHelper.self("isRefresh"),
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					arg_5_0.initItem(arg_5_1, arg_5_2, arg_5_3)
				end,
				onAfterBuild = function(arg_6_0)
					idlereasy.if_(arg_6_0.isRefresh, function(arg_7_0, arg_7_1)
						arg_6_0:jumpToBottom()
					end):anonyOnly(arg_6_0)
				end
			},
			handlers = {
				itemClick = bindHelper.self("onShowInfo"),
				initItem = bindHelper.self("onInitItem")
			}
		}
	}
}

function var_0_4.onInitItem(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = arg_8_2:size()
	local var_8_1 = 0
	local var_8_2
	local var_8_3 = arg_8_2:multiget("mine", "system", "other", "txtTime", "imgTime")
	local var_8_4

	itertools.invoke({
		var_8_3.mine,
		var_8_3.system,
		var_8_3.other
	}, "hide")

	if itertools.first(game.MESSAGE_SHOW_TYPE[arg_8_4.type], 1) then
		var_8_2 = var_8_3.system:visible(true)

		var_8_2:removeChildByName("_text_")

		var_8_4 = var_8_2:y()

		local var_8_5 = var_8_2:multiget("imgTextBG", "txtFlag", "txtContent", "imgFlagBG", "imgTextBG")

		var_8_5.txtFlag:text(var_0_2[arg_8_4.channel].name)
		var_8_5.imgFlagBG:texture(var_0_2[arg_8_4.channel].icon)
		var_8_5.txtContent:removeAllChildren()

		local var_8_6 = rich.createWithWidth(arg_8_4.msg, 40, nil, 800, nil, cc.p(0, 0))

		var_8_6:anchorPoint(0, 1):xy(10, 40):addTo(var_8_5.txtContent, 2):name("_text_")
		var_8_5.imgTextBG:size(var_8_6:size().width + 80, var_8_6:size().height + 50)
		arg_8_2:size(arg_8_2:size().width, var_8_6:size().height + 56)

		var_8_1 = var_8_2:size().height - var_8_6:size().height - 66

		uiEasy.setUrlHandler(var_8_6, arg_8_4)
	elseif itertools.first(game.MESSAGE_SHOW_TYPE[arg_8_4.type], 2) then
		var_8_2, var_8_4 = var_0_3(arg_8_1, arg_8_2, arg_8_3, arg_8_4)

		var_8_2:removeChildByName("_text_")

		local var_8_7 = arg_8_4.isMine and -30 or 0
		local var_8_8 = var_8_2:multiget("txtName", "txtFlag", "vip", "imgEmoji", "imgTextBG", "imgFlagBG", "rolePanel", "title")
		local var_8_9 = string.match(arg_8_4.msg, "%[(%w+)%]")
		local var_8_10 = 0

		var_8_8.imgFlagBG:texture(var_0_2[arg_8_4.channel].icon)
		var_8_8.imgEmoji:visible(gEmojiCsv[var_8_9] ~= nil)

		if gEmojiCsv[var_8_9] then
			var_8_8.imgEmoji:texture(gEmojiCsv[var_8_9].resource):scale(1.5)
			var_8_8.imgTextBG:visible(false)

			local var_8_11 = var_8_8.imgEmoji:size().height
			local var_8_12 = var_8_8.imgEmoji:getBoundingBox()

			var_8_8.imgTextBG:size(var_8_12.width + 50, var_8_12.height + 30)
			var_8_8.imgEmoji:y(var_8_8.imgTextBG:y() - var_8_8.imgTextBG:height() / 2)
			arg_8_2:size(arg_8_2:size().width, var_8_12.height + 136)

			var_8_1 = var_8_2:size().height - var_8_12.height - 146
		else
			local var_8_13, var_8_14 = var_8_2:get("txtContent"):xy()
			local var_8_15 = cc.Label:createWithTTF(arg_8_4.msg, ui.FONT_PATH, 40)

			var_8_15:anchorPoint(arg_8_4.isMine and 1 or 0, 1):xy(var_8_13, var_8_14 + 5):addTo(var_8_2, 5):name("_text_")
			var_8_15:setMaxLineWidth(550)
			var_8_15:setTextColor(ui.COLORS.NORMAL.DEFAULT)

			local var_8_16 = var_8_15:size().height
			local var_8_17 = var_8_15:size()

			var_8_8.imgTextBG:size(cc.size(var_8_17.width + 105, var_8_16 + 60))
			arg_8_2:size(arg_8_2:size().width, var_8_16 + 178)

			var_8_1 = var_8_2:size().height - var_8_16 - 178
		end

		var_8_2:x(var_8_2:x() + var_8_7)
	elseif itertools.first(game.MESSAGE_SHOW_TYPE[arg_8_4.type], 4) then
		var_8_2, var_8_4 = var_0_3(arg_8_1, arg_8_2, arg_8_3, arg_8_4)

		var_8_2:removeChildByName("_text_")

		local var_8_18 = var_8_2:multiget("txtContent", "imgTextBG", "imgEmoji")

		var_8_18.imgEmoji:visible(false)

		local var_8_19, var_8_20 = var_8_18.imgTextBG:xy()
		local var_8_21 = arg_8_4.isMine and -25 or 57
		local var_8_22 = rich.createWithWidth(arg_8_4.msg, 40, nil, 550, nil, cc.p(0, 0))

		var_8_22:anchorPoint(arg_8_4.isMine and 1 or 0, 1):xy(var_8_19 + var_8_21, var_8_20 - 25):addTo(var_8_2, 3, "_text_")
		var_8_18.imgTextBG:size(var_8_22:size().width + 80, var_8_22:size().height + 50)
		arg_8_2:size(arg_8_2:size().width, var_8_22:size().height + 178)

		var_8_1 = var_8_2:size().height - var_8_22:size().height - 178

		uiEasy.setUrlHandler(var_8_22, arg_8_4)
	end

	if arg_8_4.showTime == true then
		var_8_3.txtTime:text(arg_8_0:timestampToStr(arg_8_4.time))
		var_8_3.imgTime:width(var_8_3.txtTime:width() / 2 + 20)
		var_8_3.imgTime:y(arg_8_2:height() + 58)
		var_8_3.txtTime:y(arg_8_2:height() + 58)
		arg_8_2:size(arg_8_2:size().width, arg_8_2:size().height + 116)
	else
		var_8_3.txtTime:hide()
		var_8_3.imgTime:hide()
		arg_8_2:size(arg_8_2:size().width, arg_8_2:size().height)
	end

	var_8_2:y(var_8_4 - var_8_1)
end

function var_0_4.playAction(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if not arg_9_0.chatPanelPosX then
		local var_9_0 = adapt.dockWithScreen(nil, "left", "up")

		arg_9_0.chatPanelPosX = arg_9_0.chatPanel:x() - 114 + var_9_0

		arg_9_0.chatPanel:x(arg_9_0.chatPanelPosX)
	end

	local var_9_1 = arg_9_1 and arg_9_0.chatPanelPosX + arg_9_0.chatPanel:size().width or arg_9_0.chatPanelPosX

	arg_9_2 = arg_9_2 or 0.3
	arg_9_0.isPlayAction = true

	transition.executeSequence(arg_9_0.chatPanel, true):func(function()
		arg_9_0.topView:visible(true)
	end):moveTo(arg_9_2, var_9_1):func(function()
		arg_9_0.isPlayAction = false

		arg_9_0.topView:visible(false)

		if not arg_9_1 then
			var_0_0.onClose(arg_9_0)
		end

		if arg_9_3 then
			arg_9_3()
		end
	end):done()
end

function var_0_4.initModel(arg_12_0)
	arg_12_0.id = gGameModel.role:getIdler("id")
	arg_12_0.unionId = gGameModel.role:getIdler("union_db_id")
	arg_12_0.chatMsgIdler = {
		gGameModel.messages:getIdler("news"),
		gGameModel.messages:getIdler("world"),
		gGameModel.messages:getIdler("union"),
		gGameModel.messages:getIdler("team")
	}
end

function var_0_4.onCreate(arg_13_0, arg_13_1)
	arg_13_1 = arg_13_1 or 2

	arg_13_0:initModel()
	blacklist:addListener(arg_13_0.textInput, "*", function(arg_14_0)
		arg_13_0.textInput:text(string.utf8limit(arg_14_0, var_0_1, true))
	end)

	arg_13_0.bottomShow = idler.new(true)

	arg_13_0.textInput:setPlaceHolderColor(ui.COLORS.DISABLED.WHITE)
	arg_13_0.textInput:setTextColor(ui.COLORS.NORMAL.WHITE)

	arg_13_0.btnsInfo = {
		{
			tag = "news",
			showBottom = false,
			name = gLanguageCsv.system,
			text = gLanguageCsv.currChannelNotTalk
		},
		{
			tag = "world",
			showBottom = true,
			name = gLanguageCsv.world
		},
		{
			tag = "union",
			showBottom = false,
			name = gLanguageCsv.guild,
			text = gLanguageCsv.notGuildNotUse
		}
	}
	arg_13_1 = arg_13_1 > #arg_13_0.btnsInfo and 2 or arg_13_1
	arg_13_0.btnsInfo = idlers.newWithMap(arg_13_0.btnsInfo)

	idlereasy.when(arg_13_0.unionId, function(arg_15_0, arg_15_1)
		if arg_15_1 then
			arg_13_0.btnsInfo:atproxy(3).showBottom = true
		else
			arg_13_0.btnsInfo:atproxy(3).showBottom = false
		end
	end)

	local var_13_0 = arg_13_0.contentList:y()
	local var_13_1 = arg_13_0.contentList:size()

	arg_13_0.contents = idlers.newWithMap({})
	arg_13_0.showTab = idler.new(arg_13_1)
	arg_13_0.isRefresh = idler.new(false)

	arg_13_0.showTab:addListener(function(arg_16_0, arg_16_1, arg_16_2)
		arg_13_0.btnsInfo:atproxy(arg_16_1).select = false
		arg_13_0.btnsInfo:atproxy(arg_16_0).select = true

		arg_13_0.bottomShow:set(arg_13_0.btnsInfo:atproxy(arg_16_0).showBottom)

		if arg_13_0.btnsInfo:atproxy(arg_16_0).showBottom then
			arg_13_0.contentList:y(var_13_0 + 130)
			arg_13_0.contentList:size(var_13_1.width, var_13_1.height - 130)
		else
			arg_13_0.contentList:y(var_13_0)
			arg_13_0.contentList:size(var_13_1.width, var_13_1.height)
		end

		arg_13_0.firstEnter = true

		idlereasy.when(arg_13_0.chatMsgIdler[arg_16_0], function(arg_17_0, arg_17_1)
			if arg_16_0 == arg_13_0.showTab:read() then
				dataEasy.tryCallFunc(arg_13_0.contentList, "updatePreloadCenterIndex")

				for iter_17_0, iter_17_1 in ipairs(arg_17_1) do
					if iter_17_0 == 1 then
						arg_17_1[iter_17_0].showTime = true
					elseif iter_17_1.time - arg_17_1[iter_17_0 - 1].time > 300 or arg_17_1[iter_17_0 - 1].time - iter_17_1.time > 0 then
						arg_17_1[iter_17_0].showTime = true
					else
						arg_17_1[iter_17_0].showTime = false
					end
				end

				arg_13_0.contentList:refreshView()

				local var_17_0 = arg_13_0.contentList:getScrolledPercentVertical()

				arg_13_0.contents:update(arg_17_1)

				if not arg_13_0.firstEnter then
					arg_13_0.contentList:enableAsyncload()
					arg_13_0.isRefresh:set(true)
					arg_13_0.contentList:quickFor("sync")

					if var_17_0 > 99 then
						arg_13_0.contentList:jumpToBottom()
					end
				end
			end
		end):anonyOnly(arg_13_0, "chat" .. arg_13_0.btnsInfo:atproxy(arg_16_0).tag)

		arg_13_0.firstEnter = false
	end)
	arg_13_0:playAction(true)
end

function var_0_4.onPictureClick(arg_18_0, arg_18_1, arg_18_2)
	if not arg_18_0.isPlayAction then
		local var_18_0 = arg_18_0.btnsInfo:atproxy(arg_18_0.showTab).tag

		gGameUI:stackUI("city.chat.emoji", nil, nil, nil, var_18_0, arg_18_0.contentList)
	end
end

function var_0_4.onShowInfo(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	if not arg_19_3.isMine then
		local var_19_0, var_19_1 = arg_19_4:xy()
		local var_19_2 = arg_19_4:getParent():convertToWorldSpace(cc.p(var_19_0, var_19_1))

		gGameUI:stackUI("city.chat.personal_info", nil, nil, var_19_2, arg_19_3)
	end
end

function var_0_4.onChangePage(arg_20_0, arg_20_1, arg_20_2)
	arg_20_0.showTab:set(arg_20_2)
end

function var_0_4.onSendClick(arg_21_0, arg_21_1, arg_21_2)
	if not dataEasy.isUnlock(gUnlockCsv.worldChat) then
		gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.worldChat))

		return
	end

	local var_21_0 = arg_21_0.textInput:getStringValue()

	if var_21_0 == nil or var_21_0 == "" then
		gGameUI:showTip(gLanguageCsv.canNotEmpty)
	else
		gGameApp:requestServer("/game/chat", function(arg_22_0)
			arg_21_0.contentList:jumpToBottom()
			arg_21_0.textInput:text("")
		end, var_21_0, arg_21_0.btnsInfo:atproxy(arg_21_0.showTab:read()).tag)
	end
end

function var_0_4.onClose(arg_23_0)
	arg_23_0:playAction(false)
end

function var_0_4.timestampToStr(arg_24_0, arg_24_1)
	local var_24_0 = time.getDate(arg_24_1)
	local var_24_1 = string.format("%02d:%02d", var_24_0.hour, var_24_0.min)

	if time.getTime() - arg_24_1 > 604800 then
		return string.formatex(gLanguageCsv.timeMonthDay, {
			month = var_24_0.month,
			day = var_24_0.day
		}) .. " " .. var_24_1
	elseif var_24_0.day ~= time.getDate(time.getTime()).day then
		local var_24_2 = var_24_0.wday == 1 and 7 or var_24_0.wday - 1

		return gLanguageCsv["weekday" .. var_24_2] .. " " .. var_24_1
	else
		return var_24_1
	end
end

return var_0_4
