local var_0_0 = {
	IDLE = 1,
	MOVE = 2
}
local var_0_1 = class("ChineseNewYearDialog", Dialog)

var_0_1.RESOURCE_FILENAME = "activity_chinese_new_year.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	shade = "shade",
	number2 = "number2",
	text1 = "text1",
	time = "time",
	["bg.bg"] = "bg",
	anima = "anima",
	number1 = "number1",
	["btn.txt"] = "btnName",
	text2 = "text2",
	text = "text",
	close = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	init = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("initDate")
			}
		}
	},
	list = {
		varname = "listview",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				itemSize = 50,
				backupCached = false,
				asyncPreload = 5,
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				dataOrderCmp = function(arg_1_0, arg_1_1)
					if itertools.size(arg_1_0.members) == itertools.size(arg_1_1.members) and itertools.size(arg_1_0.members) == arg_1_0.total_count then
						return arg_1_0.created_time > arg_1_1.created_time
					elseif itertools.size(arg_1_0.members) == arg_1_0.total_count then
						return false
					elseif itertools.size(arg_1_1.members) == arg_1_1.total_count then
						return true
					else
						local var_1_0 = false
						local var_1_1 = false

						if arg_1_0.members[arg_1_0.roleId] then
							var_1_0 = true
						end

						if arg_1_1.members[arg_1_1.roleId] then
							var_1_1 = true
						end

						if var_1_0 and var_1_1 then
							return arg_1_0.created_time > arg_1_1.created_time
						elseif var_1_0 then
							return false
						elseif var_1_1 then
							return true
						elseif itertools.size(arg_1_0.members) == itertools.size(arg_1_1.members) then
							return arg_1_0.created_time > arg_1_1.created_time
						else
							return itertools.size(arg_1_0.members) < itertools.size(arg_1_1.members)
						end
					end
				end,
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					arg_2_1:get("item"):get("anima"):removeAllChildren()
					arg_2_1:get("item"):get("anima"):alignCenter(arg_2_1:get("item"):size())
					arg_2_1:get("item"):get("txt"):text(arg_2_3.message)
					arg_2_1:get("item"):get("icon"):get("name"):text(arg_2_3.role_name)

					if arg_2_3.game_key then
						arg_2_1:get("item"):get("icon"):get("name1"):text(string.format(gLanguageCsv.brackets, getServerArea(arg_2_3.game_key, true)))
					else
						arg_2_1:get("item"):get("icon"):get("name1"):hide()
						arg_2_1:get("item"):get("icon"):get("name"):y(60)
					end

					arg_2_1:get("item"):get("open"):get("text"):text(itertools.size(arg_2_3.members) .. "/" .. arg_2_3.total_count)

					local function var_2_0(arg_3_0)
						widget.addAnimation(arg_3_0:get("item"):get("anima"), "chunjiehongbao/chunjiehongbao.skel", "effect_dailingqu_loop", 5):alignCenter(arg_3_0:size()):scale(2)
					end

					local function var_2_1()
						arg_2_1:get("item"):get("shade"):visible(true)
						arg_2_1:get("item"):get("get"):visible(true)
						arg_2_1:get("item"):get("opendown"):visible(false)
						arg_2_1:get("item"):get("iconBg"):visible(true)
						arg_2_1:get("item"):get("icon"):get("name"):text(gLanguageCsv.clickinfo)
						arg_2_1:get("item"):get("icon"):get("name"):y(60)
						arg_2_1:get("item"):get("icon"):get("name1"):hide()
						arg_2_1:get("item"):get("open"):texture("activity/chinese_new_year/hb_cs_yl.png")
						arg_2_1:get("item"):get("open"):get("text"):alignCenter(arg_2_1:get("item"):get("open"):size())
						arg_2_1:get("item"):get("bg"):texture("activity/chinese_new_year/hb_bg2yl.png")
					end

					if itertools.size(arg_2_3.members) == arg_2_3.total_count then
						var_2_1()
						arg_2_1:get("item"):get("get"):get("text"):text(gLanguageCsv.robcomplete)
						arg_2_1:get("item"):get("get"):get("text"):setTextColor(ui.COLORS.NORMAL.GREEN)
						arg_2_1:get("item"):get("open"):get("text"):setTextColor(ui.COLORS.NORMAL.WARM_YELLOW)
					elseif arg_2_3.members[arg_2_3.roleId] then
						var_2_1()
					else
						arg_2_1:get("item"):get("open"):texture("activity/chinese_new_year/hb_cs.png")
						arg_2_1:get("item"):get("bg"):texture("activity/chinese_new_year/hb_bg1.png")
						arg_2_1:get("item"):get("open"):get("text"):setTextColor(ui.COLORS.NORMAL.GREEN)
						var_2_0(arg_2_1)
					end

					bind.touch(arg_2_0, arg_2_1:get("item"), {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("getPackage")
			}
		}
	},
	btn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("sendRedPackage")
			}
		}
	},
	["init.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = ui.COLORS.NORMAL.CLARET
				}
			}
		}
	}
}

function var_0_1.initModel(arg_5_0)
	arg_5_0.sendredPacket = gGameModel.daily_record:getIdler("huodong_redPacket_send")
	arg_5_0.getredPacket = gGameModel.daily_record:getIdler("huodong_redPacket_rob")

	if arg_5_0.yyCfg.type == game.YYHUODONG_TYPE_ENUM_TABLE.huodongCrossRedPacket then
		arg_5_0.sendredPacket = gGameModel.daily_record:getIdler("huodong_cross_redPacket_send")
		arg_5_0.getredPacket = gGameModel.daily_record:getIdler("huodong_cross_redPacket_rob")
	end

	arg_5_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_5_0.roleId = gGameModel.role:getIdler("id")
	arg_5_0.tabDatas = idlers.newWithMap({})
end

function var_0_1.onCreate(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_0.id = arg_6_1
	arg_6_0.dateTab = arg_6_2
	arg_6_0.str = arg_6_3

	local var_6_0 = csv.yunying.yyhuodong[arg_6_0.id]

	arg_6_0.yyCfg = var_6_0

	arg_6_0:initModel()

	arg_6_0.textPosX = arg_6_0.text1:x()
	arg_6_0.numberPosX = arg_6_0.number1:x()

	arg_6_0.btnName:text(gLanguageCsv.sendRedPack)
	idlereasy.any({
		arg_6_0.sendredPacket,
		arg_6_0.getredPacket
	}, function(arg_7_0, arg_7_1, arg_7_2)
		arg_6_0.getVipNum = gVipCsv[arg_6_0.vipLevel:read()].huodongRedPacketRob
		arg_6_0.sendVipNum = gVipCsv[arg_6_0.vipLevel:read()].huodongRedPacketSend

		local var_7_0 = arg_6_0.sendVipNum - arg_7_1
		local var_7_1 = arg_6_0.getVipNum - arg_7_2

		arg_6_0.number1:text(var_7_0 .. "/" .. arg_6_0.sendVipNum)
		arg_6_0.number2:text(var_7_1 .. "/" .. arg_6_0.getVipNum)

		local var_7_2 = arg_6_0.number2:x() - arg_6_0.number2:width()

		arg_6_0.text2:x(var_7_2)
		arg_6_0.text1:x(arg_6_0.textPosX - arg_6_0.number1:width() / 2)
		arg_6_0.number1:x(arg_6_0.numberPosX - arg_6_0.number1:width() / 2)

		if arg_6_0.sendVipNum == arg_7_1 then
			arg_6_0.number1:setTextColor(ui.COLORS.NORMAL.WARM_YELLOW)
		end

		if arg_6_0.getVipNum == arg_7_2 then
			arg_6_0.number2:setTextColor(ui.COLORS.NORMAL.WARM_YELLOW)
		end
	end)

	arg_6_0.animaBg = widget.addAnimation(arg_6_0.anima, "chunjiehongbao/chunjiehongbao.skel", "effect_loop", 5):alignCenter(arg_6_0.anima:size()):scale(2)

	if arg_6_2 and not arg_6_3 then
		if arg_6_2[1] then
			arg_6_0.tabDatas:update(arg_6_2)
		else
			arg_6_0.bg:visible(true)
		end
	else
		arg_6_0:initDate()
	end

	local var_6_1, var_6_2 = time.getHourAndMin(var_6_0.endTime)
	local var_6_3 = time.getNumTimestamp(var_6_0.endDate, var_6_1, var_6_2)

	local function var_6_4()
		local var_8_0 = time.getCutDown(var_6_3 - time.getTime())

		arg_6_0.time:text(var_8_0.str)

		if var_6_3 - time.getTime() <= 0 then
			arg_6_0.time:visible(false)
			arg_6_0.text:visible(false)
			arg_6_0:onClose()

			return false
		end

		return true
	end

	arg_6_0:enableSchedule()
	arg_6_0:schedule(function(arg_9_0)
		if not var_6_4() then
			return false
		end
	end, 1, 0, 2)
	Dialog.onCreate(arg_6_0)
end

function var_0_1.externalDate(arg_10_0)
	arg_10_0.dateTab = nil

	arg_10_0.shade:visible(false)
	arg_10_0.anima:get("anima"):removeAllChildren()
	arg_10_0:initDate()
end

function var_0_1.initDate(arg_11_0)
	if arg_11_0.dateTab and arg_11_0.dateTab.role_id and not arg_11_0.str then
		arg_11_0.dateTab = nil
	end

	local var_11_0 = "/game/yy/red/packet/list"

	if arg_11_0.yyCfg.type == game.YYHUODONG_TYPE_ENUM_TABLE.huodongCrossRedPacket then
		var_11_0 = "/game/yy/cross/red/packet/list"
	end

	gGameApp:requestServer(var_11_0, function(arg_12_0)
		if itertools.size(arg_12_0.view.packets) >= 1 then
			for iter_12_0, iter_12_1 in pairs(arg_12_0.view.packets) do
				iter_12_1.roleId = arg_11_0.roleId:read()
			end

			arg_11_0.tabDatas:update(clone(arg_12_0.view.packets))
		end

		arg_11_0.bg:visible(itertools.size(arg_12_0.view.packets) < 1)

		if arg_11_0.dateTab and arg_11_0.str then
			arg_11_0.shade:visible(true)
			performWithDelay(arg_11_0, function()
				arg_11_0:resultInfo(arg_11_0.dateTab, var_0_0.MOVE)
			end, 0.6)

			return
		end
	end)
end

function var_0_1.resultInfo(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = {}
	local var_14_1
	local var_14_2 = false
	local var_14_3

	local function var_14_4(arg_15_0)
		if not arg_14_2 or arg_14_2 and arg_14_2 ~= 1 then
			arg_14_0.shade:visible(true)
			widget.addAnimation(arg_14_0.anima:get("anima"), "chunjiehongbao/chunjiehongbao.skel", "effect", 2):alignCenter(arg_14_0.anima:size()):scale(2)

			var_14_2 = true
		end

		var_14_1 = (function(arg_16_0)
			local var_16_0 = 0
			local var_16_1

			if itertools.size(arg_16_0.members) == arg_16_0.total_count then
				for iter_16_0, iter_16_1 in csvMapPairs(arg_16_0.members) do
					if var_16_0 < iter_16_1.val then
						var_16_0 = iter_16_1.val
						var_16_1 = iter_16_1.id
					end
				end

				for iter_16_2, iter_16_3 in csvMapPairs(arg_16_0.members) do
					iter_16_3.lickId = var_16_1
				end
			end

			return arg_16_0
		end)(arg_15_0)
		var_14_0 = clone(var_14_1)

		if var_14_2 then
			for iter_15_0, iter_15_1 in csvMapPairs(var_14_0.members) do
				if arg_14_0.roleId:read() == iter_15_1.id then
					var_14_3 = iter_15_1.val
				end
			end

			performWithDelay(arg_14_0, function()
				gGameUI:showGainDisplay({
					rmb = var_14_3
				}, {
					raw = false,
					cb = function()
						gGameUI:stackUI("city.activity.red_packet_info", nil, nil, var_14_0, arg_14_0:createHandler("externalDate"))
					end
				})
			end, 1.6)
		else
			local var_15_0 = false
			local var_15_1 = false
			local var_15_2 = false
			local var_15_3 = false

			if arg_14_0.getredPacket:read() == arg_14_0.getVipNum then
				var_15_1 = true
			end

			if itertools.size(var_14_0.members) == var_14_0.total_count then
				var_15_2 = true
				var_15_0 = true
			end

			if not var_15_0 then
				for iter_15_2, iter_15_3 in csvMapPairs(var_14_0.members) do
					if arg_14_0.roleId:read() == iter_15_3.id then
						var_15_3 = true
					end
				end
			end

			if var_15_1 then
				gGameUI:showTip(gLanguageCsv.redPacketRoleRobLimit)
			elseif var_15_2 then
				gGameUI:showTip(gLanguageCsv.redPacketNoRemain)
			elseif var_15_3 then
				gGameUI:showTip(gLanguageCsv.redPacketAlreadyRob)
			end

			if itertools.size(var_14_0.members) == var_14_0.total_count or var_15_3 then
				gGameUI:stackUI("city.activity.red_packet_info", nil, nil, var_14_0)
			end
		end
	end

	if arg_14_2 then
		var_14_4(arg_14_1)
	else
		local var_14_5 = "/game/yy/red/packet/rob"

		if arg_14_0.yyCfg.type == game.YYHUODONG_TYPE_ENUM_TABLE.huodongCrossRedPacket then
			var_14_5 = "/game/yy/cross/red/packet/rob"
		end

		gGameApp:requestServer(var_14_5, function(arg_19_0)
			var_14_4(arg_19_0.view.info)
		end, arg_14_1.idx)
	end
end

function var_0_1.getPackage(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = false

	if arg_20_0.getredPacket:read() == arg_20_0.getVipNum then
		var_20_0 = true
	end

	if itertools.size(arg_20_3.members) >= 1 then
		for iter_20_0, iter_20_1 in csvMapPairs(arg_20_3.members) do
			if arg_20_0.roleId:read() == iter_20_1.id then
				var_20_0 = true
			end
		end
	end

	if itertools.size(arg_20_3.members) == arg_20_3.total_count then
		var_20_0 = true
	end

	if not var_20_0 then
		arg_20_0:resultInfo(arg_20_3)
	else
		arg_20_0:resultInfo(arg_20_3, var_0_0.IDLE)
	end
end

function var_0_1.sendRedPackage(arg_21_0)
	gGameUI:stackUI("city.activity.buy_festival_info", nil, nil, arg_21_0.id, arg_21_0:createHandler("initDate"))
end

return var_0_1
