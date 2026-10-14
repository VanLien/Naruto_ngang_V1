local var_0_0 = {
	gold = gLanguageCsv.goldRedPack,
	rmb = gLanguageCsv.diamondRedPack,
	coin3 = gLanguageCsv.unionCoinRedPack
}
local var_0_1 = {
	PERMANENT = 2,
	DISPOSABLE = 1,
	EVERYDAY = 3
}
local var_0_2 = {
	[3] = gLanguageCsv.send,
	[4] = gLanguageCsv.get
}
local var_0_3 = {
	SYSTEM = 1,
	PLAYER = 0
}

local function var_0_4(arg_1_0, arg_1_1)
	local var_1_0 = csv.union.red_packet
	local var_1_1 = var_1_0[arg_1_0.csv_id].sortVal
	local var_1_2 = var_1_0[arg_1_1.csv_id].sortVal

	if var_1_1 ~= var_1_2 then
		return var_1_2 < var_1_1
	end

	if arg_1_0.csv_id ~= arg_1_1.csv_id then
		return arg_1_0.csv_id < arg_1_1.csv_id
	end

	if arg_1_0.idx and arg_1_1.idx and arg_1_0.idx ~= arg_1_1.idx then
		return arg_1_0.idx < arg_1_1.idx
	end

	return false
end

local function var_0_5(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0:removeAllChildren()
	arg_2_0:show()

	local var_2_0 = arg_2_0:size()

	widget.addAnimationByKey(arg_2_0, "union/hongbao.skel", arg_2_1, arg_2_1, 2):xy(var_2_0.width / 2 + 2, var_2_0.height / 2 + 50):setSpriteEventHandler(function(arg_3_0, arg_3_1)
		arg_2_0:hide()
		arg_2_2()
	end, sp.EventType.ANIMATION_COMPLETE)
end

local function var_0_6(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_3.pageIdx

	arg_4_1:get("title.textTitle2"):visible(var_4_0 == 2)
	arg_4_1:get("info2"):visible(var_4_0 == 2)
	arg_4_1:get("textSchedule"):visible(var_4_0 == 3)
	arg_4_1:get("textScheduleBg"):visible(var_4_0 == 3)
	arg_4_1:get("title.textTitle1"):text(arg_4_3.text)

	if arg_4_3.showType == 2 then
		arg_4_1:get("imgBg"):texture("city/union/redpack/img_hb1_h.png")
		arg_4_1:get("info1.imgBg"):texture("city/union/redpack/box_d_h.png")
		arg_4_1:get("info2.imgBg"):texture("city/union/redpack/box_d_h.png")
		arg_4_1:get("leftTime.imgBg"):texture("common/box/box_d4.png")
		arg_4_1:get("textScheduleBg"):texture("common/box/box_d4.png")
	end

	local var_4_1 = var_0_2[var_4_0]

	arg_4_1:get("imgReceived"):hide()

	if not var_4_1 then
		local var_4_2 = arg_4_3.total_count - arg_4_3.used_count
		local var_4_3 = itertools.include(arg_4_3.members or {}, arg_4_0.id():read())

		var_4_1 = gLanguageCsv.grab

		if var_4_3 or var_4_2 == 0 then
			var_4_1 = gLanguageCsv.show
		end

		if var_4_3 and var_4_0 == 2 then
			arg_4_1:get("imgReceived"):show()
		end
	end

	arg_4_1:get("textState"):text(var_4_1)
	arg_4_1:get("info1.textNum"):text(arg_4_3.total_val)

	local var_4_4 = dataEasy.getIconResByKey(arg_4_3.key)

	arg_4_1:get("info1.imgIcon"):texture(var_4_4)
	arg_4_1:get("leftTime"):visible(var_4_0 == 2)

	local var_4_5 = time.getTime()

	if var_4_0 == 2 then
		arg_4_1:get("title.textTitle2"):text(string.format(gLanguageCsv.redpackSender, arg_4_3.role_name))
		arg_4_1:get("info2.textLeftNum"):text(arg_4_3.total_count - arg_4_3.used_count)
		arg_4_1:get("info2.textAllNum"):text("/" .. arg_4_3.total_count)

		local var_4_6 = arg_4_0:enableSchedule():schedule(function()
			if itertools.size(arg_4_0.playerDatas()[2]) < 1 or arg_4_3.delta <= 0 then
				arg_4_0.tipPanel():hide()

				return false
			end

			local var_5_0 = time.getCutDown(arg_4_3.delta)

			arg_4_1:get("leftTime.textLeftTime"):text(var_5_0.str)
		end, 0.5, 0, "schedulePage2Node" .. arg_4_3.idx)

		table.insert(arg_4_0.schedulePage2NodeTags(), var_4_6)
	elseif var_4_0 == 3 then
		local var_4_7 = arg_4_3.delta
		local var_4_8 = time.getCutDown(var_4_7)

		arg_4_1:get("textSchedule"):text(var_4_8.str)

		local var_4_9 = arg_4_0:enableSchedule():schedule(function()
			if itertools.size(arg_4_0.playerDatas()[3]) < 1 or arg_4_3.delta <= 0 then
				arg_4_0.tipPanel():hide()

				return false
			end

			local var_6_0 = time.getCutDown(arg_4_3.delta)

			arg_4_1:get("textSchedule"):text(var_6_0.str)
		end, 0.5, 0, "scheduleNode" .. arg_4_3.idx)

		table.insert(arg_4_0.scheduleNodeTags(), var_4_9)
	elseif var_4_0 == 4 then
		-- block empty
	end
end

local var_0_7 = class("RedPackView", cc.load("mvc").ViewBase)

var_0_7.RESOURCE_FILENAME = "union_redpack.json"
var_0_7.RESOURCE_BINDING = {
	textTimesMax = "textTimesMax",
	innweList = "innweList",
	["404panel"] = "tipPanel",
	textTimesNum = "textTimesNum",
	leftPanel = "leftPanel",
	item1 = "item1",
	item = "item",
	bg = "bg",
	effectPanel = "effectPanel",
	btnItem = "btnItem",
	textTimesNote = "textTimesNote",
	btnRule = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleClick")
			}
		}
	},
	["btnItem.btnSelect.textNote"] = {
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
	["leftPanel.leftList"] = {
		varname = "listview",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("leftBtns"),
				item = bindHelper.self("btnItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					arg_7_1:setName("tab" .. arg_7_0:getIdx(arg_7_2))

					local var_7_0 = arg_7_1:get("btnSelect")
					local var_7_1 = arg_7_1:get("btnClick")

					var_7_0:visible(arg_7_3.isSel)
					var_7_1:visible(not arg_7_3.isSel)
					var_7_0:get("textNote"):text(arg_7_3.text1)
					var_7_1:get("textNote1"):text(arg_7_3.text1)

					if arg_7_3.redHint then
						function arg_7_3.redHint.props.onNode(arg_8_0)
							arg_8_0:xy(301, 100):scale(0.8)

							if arg_7_3.redHintPos then
								arg_8_0:xy(arg_7_3.redHintPos)
							end
						end

						arg_7_0.state = arg_7_3.isSel ~= true

						bind.extend(arg_7_0, var_7_1, arg_7_3.redHint)
					end

					bind.touch(arg_7_0, arg_7_1:get("btnClick"), {
						methods = {
							ended = functools.partial(arg_7_0.clickCell, arg_7_2, arg_7_3)
						}
					})
					adapt.setTextScaleWithWidth(var_7_0:get("textNote"), nil, 250)
					adapt.setTextScaleWithWidth(var_7_1:get("textNote1"), nil, 250)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onButtonClick")
			}
		}
	},
	["404panel.textTip"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("tips")
		}
	},
	list1 = {
		varname = "list1",
		binds = {
			{
				event = "extend",
				class = "listview",
				props = {
					data = bindHelper.self("dailyDatas"),
					item = bindHelper.self("item"),
					margin = bindHelper.self("list1Margin"),
					onItem = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
						arg_9_1:setName("item" .. arg_9_0:getIdx(arg_9_2))

						local var_9_0 = dataEasy.getIconResByKey(arg_9_3.key)

						arg_9_1:get("imgIcon"):texture(var_9_0)
						arg_9_1:get("textTitle"):text(arg_9_3.text)
						arg_9_1:get("info1.textNum"):text(arg_9_3.total_val)

						local var_9_1 = arg_9_3.total_count - arg_9_3.used_count

						arg_9_1:get("info2.textLeftNum"):text(var_9_1)
						arg_9_1:get("info2.textAllNum"):text("/" .. arg_9_3.total_count)
						arg_9_1:get("info3.textNum"):text(arg_9_3.top_role_name or gLanguageCsv.noOneRob)

						local var_9_2 = ui.COLORS.NORMAL.ALERT_ORANGE

						if var_9_1 > 0 then
							var_9_2 = ui.COLORS.NORMAL.FRIEND_GREEN
						end

						local var_9_3 = itertools.include(arg_9_3.members or {}, arg_9_0.id():read())

						arg_9_1:get("imgReceived"):visible(var_9_3)
						text.addEffect(arg_9_1:get("info2.textLeftNum"), {
							color = var_9_2
						})
						bind.touch(arg_9_0, arg_9_1, {
							methods = {
								ended = functools.partial(arg_9_0.clickCell, arg_9_2, arg_9_3)
							}
						})
						adapt.oneLinePos(arg_9_1:get("info1.textNote"), arg_9_1:get("info1.textNum"), cc.p(10, 0))
						adapt.oneLinePos(arg_9_1:get("info2.textNote"), arg_9_1:get("info2.textLeftNum"), cc.p(10, 0))
						adapt.oneLinePos(arg_9_1:get("info2.textLeftNum"), arg_9_1:get("info2.textAllNum"), cc.p(0, 0))
						adapt.oneLinePos(arg_9_1:get("info3.textNote"), arg_9_1:get("info3.textNum"), cc.p(10, 0))
					end
				},
				handlers = {
					clickCell = bindHelper.self("onItemClick"),
					id = bindHelper.self("id")
				}
			},
			{
				event = "visible",
				idler = bindHelper.self("isDailyPage")
			}
		}
	},
	list2 = {
		varname = "list2",
		binds = {
			{
				event = "visible",
				idler = bindHelper.self("isDailyPage"),
				method = function(arg_10_0)
					return not arg_10_0
				end
			},
			{
				event = "extend",
				class = "tableview",
				props = {
					asyncPreload = 6,
					backupCached = false,
					columnSize = 3,
					data = bindHelper.self("redPackDatas"),
					item = bindHelper.self("innweList"),
					cell = bindHelper.self("item1"),
					xMargin = bindHelper.self("innweListMargin"),
					itemAction = {
						isAction = true
					},
					onCell = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
						var_0_6(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
						bind.touch(arg_11_0, arg_11_1, {
							methods = {
								ended = functools.partial(arg_11_0.onClickCell, arg_11_2, arg_11_3)
							}
						})
					end
				},
				handlers = {
					onClickCell = bindHelper.self("onClickCell"),
					id = bindHelper.self("id"),
					playerDatas = bindHelper.self("playerDatas"),
					tipPanel = bindHelper.self("tipPanel"),
					schedulePage2NodeTags = bindHelper.self("schedulePage2NodeTags"),
					scheduleNodeTags = bindHelper.self("scheduleNodeTags")
				}
			}
		}
	}
}

function var_0_7.onCreate(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = 3
	local var_12_1 = 3

	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_12_0.leftPanel,
			"width"
		},
		{
			arg_12_0.bg,
			"width"
		},
		{
			arg_12_0.list1,
			"width"
		},
		{
			arg_12_0.list2,
			"width"
		},
		{
			arg_12_0.innweList,
			"width"
		},
		{
			arg_12_0.list1,
			"pos",
			"left"
		}
	})

	arg_12_0.list1Margin = (arg_12_0.list1:width() - arg_12_0.item:width() * var_12_0) / 2
	arg_12_0.innweListMargin = (arg_12_0.innweList:width() - arg_12_0.item1:width() * var_12_1) / 2
	arg_12_2 = arg_12_2 or 1
	arg_12_0.redPackets = arg_12_1

	arg_12_0:initModel()
	gGameUI.topuiManager:createView("union", arg_12_0, {
		onClose = arg_12_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = "common/txt/txt_bt_zuzhi.png"
	})

	local var_12_2 = {
		{
			isSel = false,
			text2 = "Everyday",
			text1 = gLanguageCsv.dailyRedPack,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "unionSystemRedPacket",
					state = bindHelper.self("state"),
					onNode = function(arg_13_0)
						arg_13_0:xy(366, 150):z(10)
					end
				}
			}
		},
		{
			isSel = false,
			text2 = "Members",
			text1 = gLanguageCsv.membersRedPack,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "unionMemberRedPacket",
					state = bindHelper.self("state"),
					onNode = function(arg_14_0)
						arg_14_0:xy(366, 150):z(10)
					end
				}
			}
		},
		{
			isSel = false,
			text2 = "Give",
			text1 = gLanguageCsv.sendRedPack,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "unionSendedRedPacket",
					state = bindHelper.self("state"),
					onNode = function(arg_15_0)
						arg_15_0:xy(366, 150):z(10)
					end
				}
			}
		},
		{
			isSel = false,
			text2 = "Acquire",
			text1 = gLanguageCsv.getRedPack
		}
	}

	var_12_2[arg_12_2].isSel = true
	arg_12_0.isResetDatas = true
	arg_12_0.scheduleNodeTags = {}
	arg_12_0.schedulePage2NodeTags = {}
	arg_12_0.scheduleTags = {}
	arg_12_0.schedulePage2Tags = {}
	arg_12_0.leftBtns = idlers.newWithMap(var_12_2)
	arg_12_0.lastPageIdx = idler.new(arg_12_2)

	local var_12_3 = {}
	local var_12_4 = csv.union.union_level[arg_12_0.unionLv:read()]
	local var_12_5 = csv.union.red_packet

	for iter_12_0, iter_12_1 in pairs(arg_12_1 or {}) do
		if iter_12_1.packet_flag == var_0_3.SYSTEM then
			local var_12_6 = iter_12_1.packet_type
			local var_12_7, var_12_8 = csvNext(var_12_4["dailyPacket" .. var_12_6 + 1])

			iter_12_1.key = var_12_7
			iter_12_1.text = var_0_0[var_12_7]

			table.insert(var_12_3, iter_12_1)
		end
	end

	table.sort(var_12_3, function(arg_16_0, arg_16_1)
		return arg_16_0.packet_type < arg_16_1.packet_type
	end)

	arg_12_0.dailyDatas = idlertable.new(var_12_3)
	arg_12_0.redPackDatas = idlers.newWithMap({})
	arg_12_0.isDailyPage = idler.new(arg_12_2 == 1)
	arg_12_0.tips = idler.new("")

	idlereasy.when(arg_12_0.lastPageIdx, function(arg_17_0, arg_17_1)
		local var_17_0 = arg_17_0:read() or arg_17_1

		arg_12_0.leftBtns:atproxy(var_17_0).isSel = false
		arg_12_0.leftBtns:atproxy(arg_17_1).isSel = true

		if arg_17_1 ~= 1 then
			arg_12_0.list2:jumpToTop()
			arg_12_0:unNodeSchedule()

			if arg_12_0.isResetDatas then
				arg_12_0:refreshDatas()
			end

			arg_12_0.redPackDatas:update(arg_12_0.playerDatas[arg_12_0.lastPageIdx:read()])
		end

		if arg_17_1 == 3 then
			gGameModel.currday_dispatch:getIdlerOrigin("sendedRedPacket"):set(true)
		end

		local var_17_1 = arg_12_0.redPackDatas:size()

		arg_12_0.tipPanel:visible(var_17_1 < 1 and arg_17_1 ~= 1)

		local var_17_2 = arg_17_1 == 3 and gLanguageCsv.sendRedPackTip or gLanguageCsv.notHasRedPack

		arg_12_0.tips:set(var_17_2)

		return true, arg_17_1
	end)
	idlereasy.when(arg_12_0.unionRedpackets, function(arg_18_0, arg_18_1)
		arg_12_0:refreshDatas(arg_18_1)
	end)
	idlereasy.when(arg_12_0.redPackDatas, function(arg_19_0, arg_19_1)
		local var_19_0 = arg_12_0.lastPageIdx:read()

		arg_12_0.tipPanel:visible(var_19_0 ~= 1 and itertools.size(arg_19_1) <= 0)
	end)
	idlereasy.any({
		arg_12_0.redPacketRobCount,
		arg_12_0.lastPageIdx
	}, function(arg_20_0, arg_20_1, arg_20_2)
		itertools.invoke({
			arg_12_0.textTimesNum,
			arg_12_0.textTimesMax,
			arg_12_0.textTimesNote
		}, arg_20_2 == 2 and "show" or "hide")

		local var_20_0 = gCommonConfigCsv.unionRobRedpacketDailyLimit
		local var_20_1 = cc.clampf(var_20_0 - arg_20_1, 0, var_20_0)

		arg_12_0.textTimesNum:text(var_20_1)
		arg_12_0.textTimesMax:text("/" .. var_20_0)

		local var_20_2 = ui.NEWCOLORS.GREEN2

		if var_20_1 <= 0 then
			var_20_2 = ui.COLORS.NORMAL.ALERT_ORANGE
		end

		text.addEffect(arg_12_0.textTimesNum, {
			color = var_20_2
		})
		adapt.oneLinePos(arg_12_0.textTimesNote, {
			arg_12_0.textTimesNum,
			arg_12_0.textTimesMax
		})
	end)
end

function var_0_7.initModel(arg_21_0)
	arg_21_0.unionLv = gGameModel.union:getIdler("level")
	arg_21_0.id = gGameModel.role:getIdler("id")
	arg_21_0.unionRedpackets = gGameModel.role:getIdler("union_redpackets")
	arg_21_0.unionRedpacketTimes = gGameModel.role:getIdler("union_redpacket_times")

	local var_21_0 = gGameModel.daily_record

	arg_21_0.redPacketDaily = var_21_0:getIdler("redPacket_daily")
	arg_21_0.redPacketRobCount = var_21_0:getIdler("redPacket_rob_count")
end

function var_0_7.isUseRedPacket(arg_22_0, arg_22_1)
	local var_22_0 = csv.union.red_packet[arg_22_1]

	if var_22_0.type == var_0_1.PERMANENT then
		return true
	end

	local var_22_1 = arg_22_0.unionRedpacketTimes:read()

	if var_22_0.type == var_0_1.DISPOSABLE then
		if var_22_1[arg_22_1] then
			return false
		end

		return true
	end

	if var_22_0.type == var_0_1.EVERYDAY then
		return not itertools.include(arg_22_0.redPacketDaily:read(), arg_22_1)
	end
end

function var_0_7.refreshDatas(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0.lastPageIdx:read()

	if var_23_0 ~= 1 then
		arg_23_0:unNodeSchedule()
	end

	arg_23_1 = arg_23_1 or arg_23_0.unionRedpackets:read()

	local var_23_1 = csv.union.red_packet

	arg_23_0.playerDatas = {
		[2] = {},
		[3] = {},
		[4] = {}
	}

	local var_23_2 = 0

	for iter_23_0, iter_23_1 in pairs(arg_23_0.redPackets or {}) do
		if iter_23_1.packet_flag == var_0_3.PLAYER then
			local var_23_3 = var_23_1[iter_23_1.csv_id].date
			local var_23_4 = (iter_23_1.created_time or 0) + var_23_3 * 24 * 3600 - time.getTime()

			if var_23_4 > 0 then
				var_23_2 = var_23_2 + 1

				local var_23_5 = var_23_1[iter_23_1.csv_id]
				local var_23_6, var_23_7 = csvNext(var_23_5.totalVal)

				table.insert(arg_23_0.playerDatas[2], {
					pageIdx = 2,
					id = iter_23_1.id,
					csv_id = iter_23_1.csv_id,
					key = var_23_6,
					text = var_23_5.name,
					showType = var_23_5.showType,
					total_val = iter_23_1.total_val,
					used_count = iter_23_1.used_count,
					total_count = var_23_5.totalCount,
					delta = var_23_4,
					idx = var_23_2,
					used_val = iter_23_1.used_val,
					members = iter_23_1.members,
					role_name = iter_23_1.role_name
				})
			end
		end
	end

	local var_23_8 = 0

	for iter_23_2, iter_23_3 in pairs(arg_23_1) do
		local var_23_9 = iter_23_3[1]
		local var_23_10 = var_23_1[var_23_9]
		local var_23_11 = iter_23_3[2] + var_23_10.date * 24 * 3600 - time.getTime()

		if var_23_11 > 0 then
			local var_23_12, var_23_13 = csvNext(var_23_10.totalVal)

			var_23_8 = var_23_8 + 1

			table.insert(arg_23_0.playerDatas[3], {
				pageIdx = 3,
				id = var_23_10.id,
				csv_id = var_23_9,
				key = var_23_12,
				text = var_23_10.name,
				total_val = var_23_13,
				used_count = var_23_10.used_count,
				total_count = var_23_10.totalCount,
				delta = var_23_11,
				idx = var_23_8,
				serIdx = iter_23_2,
				members = var_23_10.members,
				showType = var_23_10.showType
			})
		end
	end

	for iter_23_4, iter_23_5 in orderCsvPairs(csv.union.red_packet) do
		if arg_23_0:isUseRedPacket(iter_23_4) then
			local var_23_14, var_23_15 = csvNext(iter_23_5.totalVal)

			table.insert(arg_23_0.playerDatas[4], {
				pageIdx = 4,
				csv_id = iter_23_4,
				id = iter_23_5.id,
				key = var_23_14,
				text = iter_23_5.name,
				total_val = var_23_15,
				used_count = iter_23_5.used_count,
				total_count = iter_23_5.totalCount,
				members = iter_23_5.members,
				goTo = iter_23_5.goTo,
				tipText = iter_23_5.tipText,
				showType = iter_23_5.showType
			})
		end
	end

	for iter_23_6, iter_23_7 in pairs(arg_23_0.playerDatas) do
		table.sort(iter_23_7, function(arg_24_0, arg_24_1)
			if iter_23_6 == 2 then
				local var_24_0 = arg_24_0.total_count - arg_24_0.used_count
				local var_24_1 = arg_24_1.total_count - arg_24_1.used_count

				if var_24_0 ~= 0 and var_24_1 ~= 0 then
					local var_24_2 = itertools.include(arg_24_0.members, arg_23_0.id:read())
					local var_24_3 = itertools.include(arg_24_1.members, arg_23_0.id:read())

					if var_24_2 ~= var_24_3 then
						return var_24_3 == true
					else
						return var_0_4(arg_24_0, arg_24_1)
					end
				elseif var_24_0 == 0 and var_24_1 == 0 then
					return var_0_4(arg_24_0, arg_24_1)
				else
					return var_24_1 == 0
				end
			else
				return var_0_4(arg_24_0, arg_24_1)
			end
		end)
	end

	arg_23_0:createSchedule()

	if var_23_0 ~= 1 then
		arg_23_0.redPackDatas:update(arg_23_0.playerDatas[var_23_0])
	end

	arg_23_0.isResetDatas = false
end

function var_0_7.unNodeSchedule(arg_25_0)
	for iter_25_0, iter_25_1 in ipairs(arg_25_0.scheduleNodeTags) do
		arg_25_0:unSchedule(iter_25_1)
	end

	arg_25_0.scheduleNodeTags = {}

	for iter_25_2, iter_25_3 in ipairs(arg_25_0.schedulePage2NodeTags) do
		arg_25_0:unSchedule(iter_25_3)
	end

	arg_25_0.schedulePage2NodeTags = {}
end

function var_0_7.createSchedule(arg_26_0)
	for iter_26_0, iter_26_1 in ipairs(arg_26_0.scheduleTags) do
		arg_26_0:unSchedule(iter_26_1)
	end

	for iter_26_2, iter_26_3 in ipairs(arg_26_0.schedulePage2Tags) do
		arg_26_0:unSchedule(iter_26_3)
	end

	local var_26_0 = time.getTime()

	for iter_26_4, iter_26_5 in ipairs(arg_26_0.playerDatas[2]) do
		local var_26_1 = iter_26_5.delta
		local var_26_2 = arg_26_0:enableSchedule():schedule(function()
			var_26_1 = var_26_1 - 1

			if var_26_1 <= 0 then
				arg_26_0.playerDatas[2][iter_26_4] = nil

				dataEasy.tryCallFunc(arg_26_0.list2, "updatePreloadCenterIndex")
				arg_26_0.redPackDatas:update(arg_26_0.playerDatas[2])

				return false
			end

			if not arg_26_0.playerDatas[2][iter_26_4] then
				return false
			end

			arg_26_0.playerDatas[2][iter_26_4].delta = var_26_1
		end, 1, 0, "schedulePage2" .. iter_26_5.idx)

		table.insert(arg_26_0.schedulePage2Tags, var_26_2)
	end

	for iter_26_6, iter_26_7 in ipairs(arg_26_0.playerDatas[3]) do
		local var_26_3 = iter_26_7.delta
		local var_26_4 = arg_26_0:enableSchedule():schedule(function()
			var_26_3 = var_26_3 - 1

			if var_26_3 <= 0 then
				arg_26_0.playerDatas[3][iter_26_6] = nil

				dataEasy.tryCallFunc(arg_26_0.list2, "updatePreloadCenterIndex")
				arg_26_0.redPackDatas:update(arg_26_0.playerDatas[3])

				return false
			end

			if not arg_26_0.playerDatas[3][iter_26_6] then
				return false
			end

			arg_26_0.playerDatas[3][iter_26_6].delta = var_26_3
		end, 1, 0, "schedule" .. iter_26_7.idx)

		table.insert(arg_26_0.scheduleTags, var_26_4)
	end
end

function var_0_7.onButtonClick(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	dataEasy.tryCallFunc(arg_29_0.list2, "setItemAction", {
		isAction = true
	})
	arg_29_0.isDailyPage:set(arg_29_2 == 1)
	arg_29_0.lastPageIdx:set(arg_29_2)
end

function var_0_7.onItemClick(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	if dataEasy.notUseUnionBuild() or not dataEasy.canSystemRedPacket() then
		gGameUI:showTip(gLanguageCsv.cannotUseBuilding)

		return
	end

	if not itertools.include(arg_30_3.members, arg_30_0.id:read()) and arg_30_3.total_count - arg_30_3.used_count ~= 0 then
		gGameApp:requestServer("/game/union/redpacket/rob", function(arg_31_0)
			arg_31_0.view[arg_30_3.id].key = arg_30_3.key
			arg_31_0.view[arg_30_3.id].text = arg_30_3.text

			arg_30_0.dailyDatas:modify(function(arg_32_0)
				arg_32_0[arg_30_2] = arg_31_0.view[arg_30_3.id]

				return true, arg_32_0
			end, true)
			var_0_5(arg_30_0.effectPanel, "da", function()
				gGameUI:showGainDisplay(arg_31_0.award)
			end)
		end, arg_30_3.id)
	else
		gGameApp:requestServer("/game/union/redpacket/detail", function(arg_34_0)
			gGameUI:stackUI("city.union.redpack.detail", nil, nil, arg_30_3, arg_34_0.view)
		end, arg_30_3.id)
	end
end

function var_0_7.onClickCell(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	local var_35_0 = arg_35_0.lastPageIdx:read()

	if (var_35_0 == 2 or var_35_0 == 3) and dataEasy.notUseUnionBuild() then
		gGameUI:showTip(gLanguageCsv.cannotUseBuilding)

		return
	end

	if var_35_0 == 2 then
		if itertools.include(arg_35_3.members, arg_35_0.id:read()) or arg_35_3.total_count - arg_35_3.used_count == 0 then
			gGameApp:requestServer("/game/union/redpacket/detail", function(arg_36_0)
				gGameUI:stackUI("city.union.redpack.detail", nil, nil, arg_35_3, arg_36_0.view)
			end, arg_35_3.id)
		else
			if arg_35_0.redPacketRobCount:read() >= gCommonConfigCsv.unionRobRedpacketDailyLimit then
				gGameUI:showTip(gLanguageCsv.yourHandIsTooFast)

				return
			end

			gGameApp:requestServer("/game/union/redpacket/rob", function(arg_37_0)
				arg_37_0.view[arg_35_3.id].key = arg_35_3.key
				arg_37_0.view[arg_35_3.id].text = arg_35_3.text
				arg_37_0.view[arg_35_3.id].showType = arg_35_3.showType
				arg_37_0.view[arg_35_3.id].idx = arg_35_3.idx
				arg_37_0.view[arg_35_3.id].delta = arg_35_3.delta
				arg_37_0.view[arg_35_3.id].pageIdx = 2

				for iter_37_0, iter_37_1 in ipairs(arg_35_0.schedulePage2NodeTags) do
					arg_35_0:unSchedule(iter_37_1)
				end

				local var_37_0 = arg_35_1:getIdx(arg_35_2)

				arg_35_0.playerDatas[arg_35_0.lastPageIdx:read()][var_37_0.k] = arg_37_0.view[arg_35_3.id]

				for iter_37_2, iter_37_3 in pairs(arg_37_0.view[arg_35_3.id]) do
					arg_35_0.redPackDatas:atproxy(var_37_0.k)[iter_37_2] = iter_37_3
				end

				local var_37_1 = arg_35_3.showType == 2 and "huang" or "hong"

				var_0_5(arg_35_0.effectPanel, var_37_1, function()
					gGameUI:showGainDisplay(arg_37_0.award)
				end)
			end, arg_35_3.id)
		end
	elseif var_35_0 == 3 then
		gGameUI:stackUI("city.union.redpack.send", nil, nil, arg_35_2, arg_35_3, arg_35_0:createHandler("updateRedPacketDatas"))
	elseif var_35_0 == 4 then
		if arg_35_3.goTo then
			local function var_35_1()
				jumpEasy.jumpTo(arg_35_3.goTo)
			end

			if arg_35_3.goTo == "recharge" then
				gGameUI:showDialog({
					btnType = 2,
					clearFast = true,
					content = gLanguageCsv.needRechargeMore,
					cb = var_35_1
				})
			else
				var_35_1()
			end
		else
			gGameUI:showTip(arg_35_3.tipText)
		end
	end
end

function var_0_7.onRuleClick(arg_40_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_40_0:createHandler("getRuleContext"))
end

function var_0_7.getRuleContext(arg_41_0, arg_41_1)
	local var_41_0 = adaptContext

	return {
		var_41_0.clone(arg_41_1.title, function(arg_42_0)
			arg_42_0:get("text"):text(gLanguageCsv.unionRedPacketRule)
		end),
		var_41_0.noteText(104),
		var_41_0.noteText(1001, 1010),
		var_41_0.noteText(105),
		var_41_0.noteText(1011, 1020)
	}
end

function var_0_7.updateRedPacketDatas(arg_43_0, arg_43_1)
	arg_43_0.redPackets = arg_43_1
	arg_43_0.isResetDatas = true

	gGameUI:showTip(gLanguageCsv.redPacketSendSuccess)
end

return var_0_7
