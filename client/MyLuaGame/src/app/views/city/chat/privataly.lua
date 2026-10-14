local var_0_0 = 50
local var_0_1 = class("ChatPrivatalyView", Dialog)
local var_0_2 = cc.load("mvc").ViewBase

local function var_0_3(arg_1_0)
	local var_1_0 = time.getDate(arg_1_0)
	local var_1_1 = string.format("%02d:%02d", var_1_0.hour, var_1_0.min)

	if time.getTime() - arg_1_0 > 604800 then
		return string.formatex(gLanguageCsv.timeMonthDay, {
			month = var_1_0.month,
			day = var_1_0.day
		}) .. " " .. var_1_1
	elseif var_1_0.day ~= time.getDate(time.getTime()).day then
		local var_1_2 = var_1_0.wday == 1 and 7 or var_1_0.wday - 1

		return gLanguageCsv["weekday" .. var_1_2] .. " " .. var_1_1
	else
		return var_1_1
	end
end

var_0_1.RESOURCE_FILENAME = "chat_privataly.json"
var_0_1.RESOURCE_BINDING = {
	["bottomPanel.textInput"] = "textInput",
	item = "item",
	tipsText = "tipsText",
	["leftPanel.item"] = "leftItem",
	["leftPanel.sliderBg"] = "sliderBg",
	tipsBg = "tipsBg",
	leftPanel = "leftPanel",
	title = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLUE
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
	},
	["bottomPanel.btnSend"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSendClick")
			}
		}
	},
	["bottomPanel.btnSend.txt"] = {
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
	["bottomPanel.btnPicture"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPicClick")
			}
		}
	},
	["leftPanel.list"] = {
		varname = "leftList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = -20,
				asyncPreload = 6,
				data = bindHelper.self("personInfo"),
				item = bindHelper.self("leftItem"),
				barBg = bindHelper.self("sliderBg"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("selected", "name", "level", "lv", "btnDelete", "icon", "itemNode")

					var_2_0.itemNode:setEnabled(not arg_2_3.select)
					var_2_0.selected:visible(arg_2_3.select == true)
					var_2_0.icon:visible(arg_2_3.select == true)

					if arg_2_3.select == true then
						itertools.invoke({
							var_2_0.name,
							var_2_0.level,
							var_2_0.lv
						}, "setTextColor", ui.NEWCOLORS.ORANGE)
						itertools.invoke({
							var_2_0.name,
							var_2_0.level,
							var_2_0.lv
						}, "enableOutline", ui.NEWCOLORS.WHITE, 3)
					else
						itertools.invoke({
							var_2_0.name,
							var_2_0.level,
							var_2_0.lv
						}, "setTextColor", ui.COLORS.NORMAL.WHITE)
						itertools.invoke({
							var_2_0.name,
							var_2_0.level,
							var_2_0.lv
						}, "disableEffect")
					end

					adapt.oneLinePos(var_2_0.lv, var_2_0.level, cc.p(5, 0), "left")
					var_2_0.level:text(arg_2_3.role.level)
					var_2_0.name:text(arg_2_3.role.name)
					bind.extend(arg_2_0, var_2_0.itemNode, {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_2_3.role.logo,
							frameId = arg_2_3.role.frame or 1,
							onNode = function(arg_3_0)
								arg_3_0:x(110):scale(0.8):z(6)
							end
						}
					})
					var_2_0.icon:onTouch(functools.partial(arg_2_0.iconClick, arg_2_2, arg_2_3))
					var_2_0.itemNode:onTouch(functools.partial(arg_2_0.itemClick, arg_2_2, arg_2_3))
				end,
				onBeforeBuild = function(arg_4_0)
					local var_4_0, var_4_1 = arg_4_0:xy()
					local var_4_2 = arg_4_0:size()
					local var_4_3, var_4_4 = arg_4_0.barBg:xy()
					local var_4_5 = arg_4_0.barBg:size()

					arg_4_0:setScrollBarEnabled(true)
					arg_4_0:setScrollBarColor(cc.c3b(249, 225, 130))
					arg_4_0:setScrollBarOpacity(255)
					arg_4_0:setScrollBarWidth(13)
					arg_4_0:setScrollBarAutoHideEnabled(false)
					arg_4_0:setScrollBarPositionFromCorner(cc.p(var_4_5.width - 4, (var_4_2.height - var_4_5.height) / 2 + 10))
				end
			},
			handlers = {
				itemClick = bindHelper.self("onChangePerson"),
				delClick = bindHelper.self("onDeletePerson"),
				iconClick = bindHelper.self("playerInfo")
			}
		}
	},
	list = {
		varname = "rightList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = -10,
				preloadBottom = true,
				asyncPreload = 5,
				backupCached = false,
				data = bindHelper.self("chatContents"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					local var_5_0 = arg_5_3.isMine and "mine" or "other"

					itertools.invoke({
						arg_5_1:get("mine"),
						arg_5_1:get("other")
					}, "hide")

					local var_5_1 = arg_5_1:get(var_5_0):visible(true)
					local var_5_2 = var_5_1:y()
					local var_5_3 = var_5_1:multiget("imgEmoji", "imgTextBG", "txtContent")

					bind.extend(arg_5_0, var_5_1, {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_5_3.role.logo,
							frameId = arg_5_3.role.frame,
							onNode = function(arg_6_0)
								arg_6_0:xy(arg_5_3.isMine and 1210 or 100, 90):scale(0.8)
							end
						}
					})

					local var_5_4 = string.match(arg_5_3.msg, "%[(%w+)%]")
					local var_5_5 = 0
					local var_5_6 = arg_5_1:size()
					local var_5_7

					var_5_3.imgEmoji:visible(gEmojiCsv[var_5_4] ~= nil)

					if gEmojiCsv[var_5_4] then
						var_5_3.imgEmoji:texture(gEmojiCsv[var_5_4].resource)

						local var_5_8 = var_5_3.imgEmoji:size().height
						local var_5_9 = var_5_3.imgEmoji:getBoundingBox()

						var_5_3.imgTextBG:visible(false)
						arg_5_1:size(arg_5_1:size().width, var_5_9.height + 86)

						var_5_7 = var_5_1:size().height - var_5_9.height - 86
					elseif itertools.first(game.MESSAGE_SHOW_TYPE[arg_5_3.type], 4) then
						var_5_1:removeChildByName("richtext")

						local var_5_10, var_5_11 = var_5_3.txtContent:xy()
						local var_5_12

						var_5_12 = arg_5_3.isMine and -25 or 57

						local var_5_13 = rich.createWithWidth(arg_5_3.msg, 40, nil, 550, nil, cc.p(0, 0))

						var_5_13:anchorPoint(arg_5_3.isMine and 1 or 0, 1):xy(var_5_10, var_5_11 + 5):addTo(var_5_1, 5, "richtext")
						var_5_3.imgTextBG:size(var_5_13:size().width + 80, var_5_13:size().height + 50)
						arg_5_1:size(arg_5_1:size().width, var_5_13:size().height + 178)

						var_5_7 = var_5_1:size().height - var_5_13:size().height - 178

						uiEasy.setUrlHandler(var_5_13, arg_5_3)
					else
						local var_5_14, var_5_15 = var_5_1:get("txtContent"):xy()
						local var_5_16 = cc.Label:createWithTTF(arg_5_3.msg, ui.FONT_PATH, 40)

						var_5_16:anchorPoint(arg_5_3.isMine and 1 or 0, 1):xy(var_5_14, var_5_15 + 5):addTo(var_5_1, 5)
						var_5_16:setMaxLineWidth(700)
						var_5_16:setTextColor(ui.COLORS.NORMAL.DEFAULT)

						local var_5_17 = var_5_16:size().height
						local var_5_18 = var_5_16:size()

						var_5_3.imgTextBG:size(cc.size(var_5_18.width + 105, var_5_17 + 60))
						arg_5_1:size(arg_5_1:size().width, var_5_17 + 134)

						var_5_7 = var_5_1:size().height - var_5_17 - 134
					end

					if arg_5_3.showTime == true then
						arg_5_1:get("txtTime"):text(var_0_3(arg_5_3.time))
						arg_5_1:get("imgTime"):width(arg_5_1:get("txtTime"):width() / 2 + 20)
						arg_5_1:get("imgTime"):y(arg_5_1:height() + 58)
						arg_5_1:get("txtTime"):y(arg_5_1:height() + 58)
						arg_5_1:size(arg_5_1:size().width, arg_5_1:size().height + 116)
					else
						arg_5_1:get("txtTime"):hide()
						arg_5_1:get("imgTime"):hide()
						arg_5_1:size(arg_5_1:size().width, arg_5_1:size().height)
					end

					var_5_1:y(var_5_2 - var_5_7)
				end
			},
			handlers = {
				itemClick = bindHelper.self("onShowInfoClick")
			}
		}
	}
}

function var_0_1.uiInit(arg_7_0)
	arg_7_0.textInput:setPlaceHolderColor(ui.COLORS.DISABLED.WHITE)
	arg_7_0.textInput:setTextColor(ui.COLORS.NORMAL.WHITE)
	blacklist:addListener(arg_7_0.textInput, "*", function(arg_8_0)
		arg_7_0.textInput:text(string.utf8limit(arg_8_0, var_0_0, true))
	end)
	uiEasy.addTabListClipping(arg_7_0.leftList, arg_7_0.leftPanel, {
		offsetX = 14
	})
	arg_7_0.tipsText:text(gLanguageCsv.preventFraudChatTips)

	if dataEasy.isUnlock(gUnlockCsv.preventFraud) then
		arg_7_0.rightList:height(735)
		arg_7_0.tipsText:show()
		arg_7_0.tipsBg:show()
	else
		arg_7_0.rightList:height(812)
		arg_7_0.tipsText:hide()
		arg_7_0.tipsBg:hide()
	end
end

function var_0_1.initModel(arg_9_0)
	arg_9_0.myFriend = gGameModel.society:getIdler("friends")
	arg_9_0.friendMessage = gGameModel.messages:getIdler("private")
	arg_9_0.id = gGameModel.role:getIdler("id")
	arg_9_0.logo = gGameModel.role:getIdler("logo")
	arg_9_0.delectData = idler.new(true)
end

function var_0_1.onCreate(arg_10_0, arg_10_1)
	arg_10_0:uiInit()
	arg_10_0:initModel()

	local var_10_0 = arg_10_0.friendMessage:read()
	local var_10_1 = itertools.size(var_10_0)

	if var_10_1 ~= 0 then
		local var_10_2 = var_10_0[var_10_1].id

		gGameModel.forever_dispatch:getIdlerOrigin("chatPrivatalyLastId"):set(var_10_2)
	end

	arg_10_0.curSelIdx = 1
	arg_10_0.curSelId = 0
	arg_10_0.state = arg_10_1 and true or false
	arg_10_0.personData = arg_10_1
	arg_10_0.personId = arg_10_1 and arg_10_1.role.id
	arg_10_0.changeInfo = false
	arg_10_0.chatContents = idlertable.new({})
	arg_10_0.personInfo = idlers.newWithMap({})

	idlereasy.any({
		arg_10_0.friendMessage,
		arg_10_0.delectData
	}, function(arg_11_0, arg_11_1)
		local var_11_0 = {}

		if not itertools.isempty(arg_11_1) then
			for iter_11_0, iter_11_1 in ipairs(arg_11_1) do
				local var_11_1 = table.deepcopy(iter_11_1, true)
				local var_11_2

				if iter_11_1.isMine then
					if not var_11_1.args then
						var_11_1.args = {
							id = arg_10_0.id:read(),
							logo = arg_10_0.logo:read()
						}
					end

					var_11_2 = var_11_1.args.id
				else
					var_11_2 = var_11_1.role.id
				end

				var_11_0[var_11_2] = var_11_0[var_11_2] or {}

				table.insert(var_11_0[var_11_2], var_11_1)

				if iter_11_1.args and var_11_2 == arg_10_0.personId then
					arg_10_0.changeInfo = true
				end
			end
		end

		local var_11_3 = {}
		local var_11_4 = false

		for iter_11_2, iter_11_3 in pairs(var_11_0) do
			local var_11_5 = #iter_11_3
			local var_11_6 = iter_11_3[var_11_5].isMine and iter_11_3[var_11_5].args or iter_11_3[var_11_5].role

			if arg_10_0.personData and iter_11_2 == arg_10_0.personData.role.id then
				var_11_4 = true
				arg_10_0.curSelId = arg_10_0.personData.role.id
				var_11_6.name = arg_10_0.personData.role.name
				var_11_6.id = arg_10_0.personData.role.id

				if itertools.isempty(arg_11_1) then
					var_11_6 = arg_10_0.personData.role
				end
			end

			table.insert(var_11_3, {
				id = iter_11_2,
				role = var_11_6,
				content = iter_11_3
			})
		end

		table.sort(var_11_3, function(arg_12_0, arg_12_1)
			if arg_10_0.personData then
				if arg_12_0.role.id == arg_10_0.personData.role.id then
					return true
				elseif arg_12_1.role.id == arg_10_0.personData.role.id then
					return false
				end
			end

			local var_12_0 = arg_12_0.content
			local var_12_1 = arg_12_1.content

			return var_12_0[#var_12_0].id >= var_12_1[#var_12_1].id
		end)

		if not var_11_4 and arg_10_0.personData then
			table.insert(var_11_3, 1, {
				id = arg_10_0.personData.role.id,
				role = arg_10_0.personData.role,
				content = {}
			})

			local var_11_7 = true
		end

		arg_10_0.isShowDelBtn = idler.new(false)

		arg_10_0.isShowDelBtn:addListener(function(arg_13_0, arg_13_1, arg_13_2)
			if not arg_10_0.delBtn then
				return
			end

			arg_10_0.delBtn:visible(arg_13_0)

			if not arg_13_0 then
				arg_10_0.delBtn = nil
			end
		end)

		local var_11_8 = idlers.newWithMap(var_11_3)

		for iter_11_4, iter_11_5 in arg_10_0.personInfo:ipairs() do
			arg_10_0.personInfo:remove(iter_11_4)
		end

		for iter_11_6, iter_11_7 in var_11_8:ipairs() do
			arg_10_0.personInfo:add(iter_11_6, iter_11_7)
		end

		if arg_10_0.curSelId == 0 then
			arg_10_0.curSelId = var_11_3[1].id
			arg_10_0.curSelIdx = 1
		else
			for iter_11_8, iter_11_9 in ipairs(var_11_3) do
				if iter_11_9.id == arg_10_0.curSelId then
					arg_10_0.curSelIdx = iter_11_8
				end
			end
		end

		arg_10_0.curSelIdx = math.min(arg_10_0.curSelIdx, #var_11_3)

		for iter_11_10, iter_11_11 in ipairs(var_11_3) do
			for iter_11_12, iter_11_13 in ipairs(iter_11_11.content) do
				if iter_11_12 == 1 then
					var_11_3[iter_11_10].content[iter_11_12].showTime = true
				elseif iter_11_13.time - var_11_3[iter_11_10].content[iter_11_12 - 1].time > 300 or var_11_3[iter_11_10].content[iter_11_12 - 1].time - iter_11_13.time > 0 then
					var_11_3[iter_11_10].content[iter_11_12].showTime = true
				else
					var_11_3[iter_11_10].content[iter_11_12].showTime = false
				end
			end
		end

		if not itertools.isempty(arg_11_1) then
			arg_10_0.chatContents:set(var_11_3[arg_10_0.curSelIdx].content)

			arg_10_0.personInfo:atproxy(arg_10_0.curSelIdx).select = true
		end
	end)

	local var_10_3 = gCommonConfigCsv.antiFraudPosterAppearsCD * 60 * 60
	local var_10_4 = userDefault.getForeverLocalKey("chatPosterTime", 0)

	if time.getTime() > var_10_3 + var_10_4 and dataEasy.isUnlock(gUnlockCsv.preventFraud) then
		gGameUI:stackUI("city.chat.poster")
		userDefault.setForeverLocalKey("chatPosterTime", time.getTime())
	end

	Dialog.onCreate(arg_10_0)
end

function var_0_1.onShowInfoClick(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	local var_14_0 = arg_14_4.target
	local var_14_1, var_14_2 = var_14_0:xy()
	local var_14_3 = var_14_0:getParent():convertToWorldSpace(cc.p(var_14_1, var_14_2))

	gGameUI:stackUI("city.chat.personal_info", nil, nil, var_14_3, arg_14_3)
end

function var_0_1.onDeletePerson(arg_15_0, arg_15_1, arg_15_2)
	return
end

function var_0_1.playerInfo(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	if arg_16_4.name == "ended" then
		local var_16_0 = arg_16_4.target
		local var_16_1, var_16_2 = var_16_0:xy()
		local var_16_3 = var_16_0:getParent():convertToWorldSpace(cc.p(var_16_1 - 450, var_16_2 + 200))

		gGameUI:stackUI("city.chat.personal_info", nil, nil, var_16_3, arg_16_3, {
			params = true,
			state = arg_16_0.state,
			cb = function(arg_17_0, arg_17_1)
				if arg_17_0 then
					if not arg_17_1 or arg_16_0.changeInfo then
						arg_16_0.personData = nil

						arg_16_0.delectData:set(false)

						arg_16_0.state = false
					end
				elseif not arg_17_1 then
					Dialog.onClose(arg_16_0)
				elseif arg_17_1 and arg_16_0.state then
					if arg_16_0.changeInfo then
						Dialog.onClose(arg_16_0)
					end
				elseif arg_17_1 and not arg_16_0.state then
					Dialog.onClose(arg_16_0)
				end
			end
		})
	end
end

local var_0_4
local var_0_5

function var_0_1.onChangePerson(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	local var_18_0 = arg_18_4.target

	if arg_18_4.name == "began" then
		var_0_4 = var_18_0:getTouchBeganPosition()

		if flag then
			node:scale(2)
		end
	elseif arg_18_4.name == "ended" then
		var_0_5 = var_18_0:getTouchEndPosition()

		local var_18_1 = var_0_5.x - var_0_4.x

		if var_18_1 < 0 and -var_18_1 > 150 then
			arg_18_0.isShowDelBtn:set(false)

			arg_18_0.delBtn = var_18_0:get("btnDelete")

			arg_18_0.isShowDelBtn:set(true)
		else
			arg_18_0.isShowDelBtn:set(false)

			if arg_18_2 == arg_18_0.curSelIdx then
				return
			end

			arg_18_0.personInfo:atproxy(arg_18_0.curSelIdx).select = false
			arg_18_0.personInfo:atproxy(arg_18_2).select = true
			arg_18_0.curSelIdx = arg_18_2
			arg_18_0.curSelId = arg_18_3.role.id

			dataEasy.tryCallFunc(arg_18_0.rightList, "setItemAction", {
				isAction = true
			})
			arg_18_0.chatContents:set(arg_18_3.content)
			arg_18_0.rightList:jumpToBottom()
		end
	end
end

function var_0_1.onPicClick(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0.personInfo:atproxy(arg_19_0.curSelIdx).role
	local var_19_1 = {
		id = var_19_0.id,
		level = var_19_0.level,
		logo = var_19_0.logo,
		name = var_19_0.name,
		vip = var_19_0.vip,
		frame = var_19_0.frame
	}

	gGameUI:stackUI("city.chat.emoji", nil, nil, var_19_1, "role", arg_19_0.rightList)
end

function var_0_1.onSendClick(arg_20_0, arg_20_1, arg_20_2)
	if not dataEasy.isUnlock(gUnlockCsv.roleChat) then
		gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.roleChat))

		return
	end

	local var_20_0 = arg_20_0.personInfo:atproxy(arg_20_0.curSelIdx).role
	local var_20_1 = {
		id = var_20_0.id,
		level = var_20_0.level,
		logo = var_20_0.logo,
		name = var_20_0.name,
		vip = var_20_0.vip,
		frame = var_20_0.frame
	}

	if arg_20_0.textInput:text() and arg_20_0.textInput:text() ~= "" then
		gGameApp:requestServer("/game/chat", function(arg_21_0)
			arg_20_0.textInput:text("")
			arg_20_0.rightList:jumpToBottom()
		end, arg_20_0.textInput:text(), "role", var_20_1)
	else
		gGameUI:showTip(gLanguageCsv.canNotEmpty)
	end
end

return var_0_1
