local var_0_0 = {
	7,
	15,
	28
}
local var_0_1 = {
	CAN_OPEN = 1,
	NOT_OPEN = 2,
	OPENED = 0
}
local var_0_2 = {
	GET = 2,
	NOT_GET = 0,
	CAN_GET = 1
}
local var_0_3 = 5

local function var_0_4(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = csv.signin[arg_1_0].vipDouble

	var_1_0 = var_1_0 ~= 9999 and var_1_0

	if arg_1_1 == 1 and var_1_0 then
		if var_1_0 <= arg_1_2 then
			return var_0_2.CAN_GET
		else
			return var_0_2.NOT_GET
		end
	else
		return var_0_2.GET
	end
end

local var_0_5 = class("SignInView", Dialog)

var_0_5.RESOURCE_FILENAME = "sign_in.json"
var_0_5.RESOURCE_BINDING = {
	itemBox = "itemBox",
	["leftPanel.img"] = "img",
	["centerPanel.subList"] = "subList",
	itemSmall = "itemSmall",
	["leftPanel.txtNum"] = "sumNum",
	["rightPanel.img"] = "imgRight",
	itemBig = "itemBig",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["leftPanel.btnGet"] = {
		varname = "btnGet",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onGetClick")
			}
		}
	},
	["leftPanel.btnGet.txt"] = {
		varname = "btnGetTxt",
		binds = {
			{
				event = "effect",
				data = {
					glow = {
						color = ui.COLORS.GLOW.WHITE
					}
				}
			}
		}
	},
	["rightPanel.btnDetail"] = {
		varname = "btnDetail",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDetailClick")
			}
		}
	},
	["rightPanel.btnAgain"] = {
		varname = "btnRetroactive",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRetroactiveClick")
			}
		}
	},
	["rightPanel.btnAgain.txt"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	},
	["leftPanel.list"] = {
		varname = "tabList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 2,
				data = bindHelper.self("sumDatas"),
				item = bindHelper.self("itemBig"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:size()

					bind.extend(arg_2_0, arg_2_1, {
						class = "icon_key",
						props = {
							data = {
								key = arg_2_3.id,
								num = arg_2_3.num
							},
							onNode = function(arg_3_0)
								arg_3_0:xy(var_2_0.width / 2, var_2_0.height / 2)
								arg_3_0:scale(0.7)
							end
						}
					})
					arg_2_1:removeChildByName("signSpine")

					if arg_2_3.state then
						local var_2_1 = widget.addAnimationByKey(arg_2_1, "effect/wupinguang.skel", "signSpine", "effect_loop", 99):anchorPoint(cc.p(0.5, 0.5)):xy(arg_2_1:width() / 2, arg_2_1:height() / 2):scale(1.8)
					end
				end
			}
		}
	},
	["itemBox.num"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["centerPanel.bottomPanel.list"] = {
		varname = "boxList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("boxData"),
				item = bindHelper.self("itemBox"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					arg_4_1:get("num"):text(arg_4_3.num)

					local var_4_0 = arg_4_1:get("icon")
					local var_4_1 = arg_4_3.state == var_0_1.OPENED
					local var_4_2 = arg_4_3.state == var_0_1.CAN_OPEN

					if var_4_1 then
						var_4_0:x(arg_4_3.x - 12)
					end

					var_4_0:texture("common/icon/icon_signin_box" .. arg_4_2 .. (var_4_1 and "_open.png" or ".png"))

					if var_4_2 then
						local var_4_3 = widget.addAnimation(arg_4_1, "effect/jiedianjiangli.skel", "effect_loop", var_4_0:z() - 1)
						local var_4_4 = var_4_0:size()

						var_4_3:scale(0.3):x(var_4_0:x() - var_4_4.width / 2 + 35):y(var_4_0:y() - 16)

						arg_4_1.effectBox = var_4_3
					elseif not var_4_2 and arg_4_1.effectBox then
						arg_4_1.effectBox:hide()
						arg_4_1.effectBox:removeFromParent()

						arg_4_1.effectBox = nil
					end

					uiEasy.addVibrateToNode(arg_4_0, var_4_0, var_4_2, arg_4_1:getName() .. arg_4_2 .. "vibrate")
					bind.touch(arg_4_0, var_4_0, {
						methods = {
							ended = functools.partial(arg_4_0.clickBox, arg_4_2, var_4_0)
						}
					})
				end
			},
			handlers = {
				clickBox = bindHelper.self("onBoxClick")
			}
		}
	},
	["centerPanel.list"] = {
		varname = "listCenter",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				preloadCenter = 5,
				data = bindHelper.self("showdata"),
				columnSize = var_0_3,
				item = bindHelper.self("subList"),
				cell = bindHelper.self("itemSmall"),
				currDay = bindHelper.self("currDay"),
				numDay = bindHelper.self("numDay"),
				itemAction = bindHelper.self("itemAction"),
				onCell = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					local var_5_0 = arg_5_0:getIdx(arg_5_2)
					local var_5_1 = csv.signin[var_5_0.k].vipDouble ~= 9999 and csv.signin[var_5_0.k].vipDouble
					local var_5_2 = arg_5_1:size()
					local var_5_3 = {
						class = "icon_key",
						props = {
							data = {
								key = arg_5_3.id,
								num = arg_5_3.num
							},
							onNode = function(arg_6_0)
								arg_6_0:xy(var_5_2.width / 2, var_5_2.height / 2 + 25)
								bind.click(arg_5_0, arg_6_0, {
									method = functools.partial(arg_5_0.itemClick, arg_6_0, var_5_0, arg_5_3)
								})
							end
						}
					}

					bind.extend(arg_5_0, arg_5_1, var_5_3)
					arg_5_1:get("mask"):visible(arg_5_3.signIn == true):z(10)
					arg_5_1:get("vipPanel"):visible(var_5_1 ~= false):z(11)
					arg_5_1:get("day"):text(string.format(gLanguageCsv.currDay, var_5_0.k))
					text.addEffect(arg_5_1:get("day"), {
						outline = {
							size = 1,
							color = ui.NEWCOLORS.OUTLINE.BLACK4
						}
					})

					local var_5_4 = arg_5_1:get("doublePanel"):z(11)

					if arg_5_3.vipState and arg_5_3.vipState ~= var_0_2.GET then
						arg_5_1:get("mask", "check"):hide()
						var_5_4:visible(true)
					else
						arg_5_1:get("mask", "check"):show()
						var_5_4:visible(false)
					end

					arg_5_1:get("vipPanel", "vip"):text(string.format(gLanguageCsv.vipDouble, var_5_1 or 0))
					text.addEffect(arg_5_1:get("vipPanel", "vip"), {
						color = ui.COLORS.NORMAL.WHITE,
						shadow = {
							size = 6,
							color = cc.c4b(193, 38, 44, 181),
							offset = cc.size(0, -2)
						}
					})
					bind.click(arg_5_0, var_5_4, {
						method = functools.partial(arg_5_0.vipDoubleClick, var_5_0, arg_5_3)
					})
					arg_5_1:removeChildByName("signSpine")

					if arg_5_3.effect and not arg_5_3.signIn then
						local var_5_5 = widget.addAnimationByKey(arg_5_1, "effect/wupinguang.skel", "signSpine", "effect_loop", 99):anchorPoint(cc.p(0.5, 0.5)):xy(arg_5_1:width() / 2, arg_5_1:height() / 2 + 25):scale(2)
					end
				end,
				onAfterBuild = function(arg_7_0)
					local var_7_0 = arg_7_0.currDay:read()
					local var_7_1

					if var_7_0 ~= tonumber(time.getDate(time.getTime()).day) then
						var_7_1 = arg_7_0.numDay:read() + 1
					else
						var_7_1 = arg_7_0.numDay:read()
					end

					local var_7_2 = math.ceil(#arg_7_0.data / var_0_3)
					local var_7_3 = math.ceil(var_7_1 / var_0_3)

					if var_7_3 >= 2 then
						arg_7_0:jumpToItem(var_7_3 - 2, cc.p(0, 1), cc.p(0, 1))
					end
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick"),
				vipDoubleClick = bindHelper.self("vipDoubleClick")
			}
		}
	},
	["centerPanel.bottomPanel.bar"] = {
		varname = "bar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				data = bindHelper.self("barPoint")
			}
		}
	},
	["centerPanel.bottomPanel.txtNum"] = {
		binds = {
			{
				event = "text",
				idler = bindHelper.self("numDay"),
				method = function(arg_8_0)
					return string.format(gLanguageCsv.day, arg_8_0)
				end
			}
		}
	},
	["rightPanel.freePanel"] = {
		varname = "freePanel",
		binds = {
			{
				event = "visible",
				idler = bindHelper.self("showFreePanel")
			}
		}
	},
	["rightPanel.costPanel"] = {
		varname = "diamondPanel",
		binds = {
			{
				event = "visible",
				idler = bindHelper.self("showDiamondPanel")
			}
		}
	},
	["rightPanel.freePanel.num"] = {
		binds = {
			{
				event = "text",
				idler = bindHelper.self("freeRetroactiveNum")
			},
			{
				event = "effect",
				data = {
					color = ui.NEWCOLORS.BROWN1
				}
			}
		}
	},
	["rightPanel.freePanel.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	}
}

function var_0_5.onCreate(arg_9_0, arg_9_1)
	arg_9_0:initModel()

	local var_9_0 = arg_9_0.itemBox:get("icon"):x()

	arg_9_0.sumDatas = idlertable.new({})
	arg_9_0.btnGetShow = idler.new(false)
	arg_9_0.showFreePanel = idler.new(false)
	arg_9_0.showDiamondPanel = idler.new(false)
	arg_9_0.freeRetroactiveNum = idler.new(0)

	idlereasy.when(arg_9_0.btnGetShow, function(arg_10_0, arg_10_1)
		cache.setShader(arg_9_0.btnGet, false, arg_10_1 and "normal" or "hsl_gray")

		if not arg_10_1 then
			text.deleteAllEffect(arg_9_0.btnGetTxt)
			text.addEffect(arg_9_0.btnGetTxt, {
				color = ui.NEWCOLORS.DISABLED.WHITE
			})
		else
			text.addEffect(arg_9_0.btnGetTxt, {
				color = ui.NEWCOLORS.BROWN
			})
		end

		arg_9_0.btnGet:setTouchEnabled(arg_10_1)
	end)
	idlereasy.any({
		arg_9_0.totalCount,
		arg_9_0.totalCountGift
	}, function(arg_11_0, arg_11_1, arg_11_2)
		arg_9_0.sumNum:text(arg_11_1 .. "/" .. csv.sighingift[arg_11_2[1]].day)
		arg_9_0.img:width(arg_9_0.sumNum:width() + 50)
		arg_9_0.btnGetShow:set(arg_11_2[2] == 1)

		local var_11_0 = {}

		for iter_11_0, iter_11_1 in csvMapPairs(csv.sighingift[arg_11_2[1]].reward) do
			table.insert(var_11_0, {
				state = false,
				id = iter_11_0,
				num = iter_11_1
			})
		end

		if arg_11_2[2] == 1 then
			for iter_11_2, iter_11_3 in ipairs(var_11_0) do
				iter_11_3.state = true
			end
		end

		arg_9_0.sumDatas:set(var_11_0)
	end)

	local var_9_1, var_9_2 = time.getYearMonthDay(arg_9_0.monthData:read(), true)
	local var_9_3 = {
		year = var_9_1,
		month = var_9_2 == 12 and 1 or var_9_2 + 1
	}

	var_9_3.day = 0

	local var_9_4 = os.date("%d", os.time(var_9_3))
	local var_9_5 = {}

	for iter_9_0 = 1, var_9_4 do
		local var_9_6, var_9_7 = mathEasy.getRowCol(iter_9_0, var_0_3)
		local var_9_8, var_9_9 = csvNext(csv.signin[iter_9_0]["month" .. var_9_2])

		var_9_5[iter_9_0] = {
			effect = false,
			id = var_9_8,
			num = var_9_9
		}

		local var_9_10 = csv.signin[iter_9_0].months

		for iter_9_1, iter_9_2 in ipairs(var_9_10) do
			if iter_9_2 == iter_9_1 then
				var_9_5[iter_9_0].effect = true
			end
		end
	end

	arg_9_0.showdata = idlers.newWithMap(var_9_5)
	arg_9_0.boxData = idlertable.new({})
	arg_9_0.tagOrId, arg_9_0.countOrId = csvNext(csv.signin[1000]["month" .. var_9_2])

	if arg_9_0.tagOrId == "card" then
		local var_9_11 = csv.unit[csv.cards[arg_9_0.countOrId].unitID].unitRes
		local var_9_12 = string.gsub(var_9_11, ".skel", "_ui.skel")
		local var_9_13 = widget.addAnimationByKey(arg_9_0.imgRight, var_9_12, "effect", "standby_loop", 1):scale(1)

		var_9_13:y(var_9_13:y() - 400)
	else
		arg_9_0.imgRight:texture(dataEasy.getIconResByKey(arg_9_0.tagOrId))
	end

	local var_9_14 = 0

	for iter_9_3, iter_9_4 in ipairs(gCostCsv.sign_in_buy) do
		if iter_9_4 == 0 then
			var_9_14 = var_9_14 + 1
		else
			break
		end
	end

	arg_9_0.freeTimes = idler.new(var_9_14)

	local var_9_15 = {
		30,
		65,
		100
	}

	arg_9_0.barPoint = idler.new(0)

	idlereasy.when(arg_9_0.numDay, function(arg_12_0, arg_12_1)
		for iter_12_0 = 1, arg_12_1 do
			arg_9_0.showdata:atproxy(iter_12_0).signIn = true
		end

		arg_9_0.barPoint:set(mathEasy.showProgress(var_9_15, var_0_0, arg_12_1))
	end)
	idlereasy.any({
		arg_9_0.vipLevel,
		arg_9_0.signInAwards,
		arg_9_0.numDay,
		arg_9_0.lastSignInAward
	}, function(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
		local var_13_0 = arg_9_0.currDay:read()

		if var_13_0 == tonumber(time.getDate(time.getTime()).day) and arg_13_2 and arg_13_2[var_13_0] then
			for iter_13_0, iter_13_1 in pairs(arg_13_2[var_13_0]) do
				arg_9_0.showdata:atproxy(iter_13_0).vipState = var_0_4(iter_13_0, iter_13_1, arg_13_1)
			end
		end

		return true
	end)
	idlereasy.when(arg_9_0.costTimes, function(arg_14_0, arg_14_1)
		arg_9_0.freeTimes:set(var_9_14 - arg_14_1)
		arg_9_0.freeRetroactiveNum:set(var_9_14 - arg_14_1)

		local var_14_0 = arg_9_0.freePanel:multiget("txt", "num")

		adapt.oneLineCenterPos(cc.p(arg_9_0.freePanel:size().width / 2, var_14_0.txt:y()), {
			var_14_0.txt,
			var_14_0.num
		}, cc.p(6, 0))
		arg_9_0.showDiamondPanel:set(var_9_14 - arg_14_1 <= 0)
		arg_9_0.showFreePanel:set(var_9_14 - arg_14_1 > 0)

		if 3 - arg_14_1 <= 0 then
			local var_14_1 = math.min(arg_14_1 + 1, table.length(gCostCsv.sign_in_buy))
			local var_14_2 = arg_9_0.diamondPanel:multiget("txt", "icon")

			var_14_2.txt:text(gLanguageCsv.cost .. ":" .. gCostCsv.sign_in_buy[var_14_1])
			text.addEffect(var_14_2.txt, {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			})
			adapt.oneLineCenterPos(cc.p(arg_9_0.diamondPanel:size().width / 2, var_14_2.txt:y()), {
				var_14_2.txt,
				var_14_2.icon
			}, cc.p(6, 0))
		end
	end)
	idlereasy.when(arg_9_0.monthGift, function(arg_15_0, arg_15_1)
		local var_15_0 = {}

		for iter_15_0 = 1, 3 do
			local var_15_1 = type(arg_15_1[100 + iter_15_0]) == "number" and arg_15_1[100 + iter_15_0] or var_0_1.NOT_OPEN

			table.insert(var_15_0, {
				id = 100 + iter_15_0,
				state = var_15_1,
				num = var_0_0[iter_15_0],
				x = var_9_0
			})
		end

		arg_9_0.boxData:set(var_15_0)

		return true
	end)
	Dialog.onCreate(arg_9_0, {
		blackType = 1
	})

	if arg_9_0.currDay:read() < time.getNowDate().day then
		gGameApp:requestServer("/game/role/sign_in", function(arg_16_0)
			gGameUI:showGainDisplay(arg_16_0)
		end)
	else
		arg_9_0.itemAction = {
			isAction = true
		}
	end
end

function var_0_5.initModel(arg_17_0)
	arg_17_0.totalCount = gGameModel.role:getIdler("sign_in_count")
	arg_17_0.totalCountGift = gGameModel.role:getIdler("sign_in_gift")
	arg_17_0.monthGift = gGameModel.monthly_record:getIdler("sign_in_gift")
	arg_17_0.monthData = gGameModel.monthly_record:getIdler("month")
	arg_17_0.currDay = gGameModel.monthly_record:getIdler("last_sign_in_day")
	arg_17_0.numDay = gGameModel.monthly_record:getIdler("sign_in")
	arg_17_0.costTimes = gGameModel.monthly_record:getIdler("sign_in_buy_times")
	arg_17_0.rmb = gGameModel.role:getIdler("rmb")
	arg_17_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_17_0.createTime = gGameModel.role:getIdler("created_time")
	arg_17_0.currPos = gGameModel.monthly_record:getIdler("last_sign_in_idx")
	arg_17_0.signInAwards = gGameModel.monthly_record:getIdler("sign_in_awards")
end

function var_0_5.onDetailClick(arg_18_0)
	gGameUI:showItemDetail(arg_18_0.imgRight, {
		key = arg_18_0.tagOrId,
		num = arg_18_0.countOrId
	})
end

function var_0_5.onRetroactiveClick(arg_19_0)
	idlereasy.do_(function(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
		local var_20_0 = time.getDate(arg_20_2)

		var_20_0.hour = 0
		var_20_0.min = 0
		var_20_0.sec = 0

		if arg_20_4 < math.floor((time.getTime() - time.getTimestamp(var_20_0)) / 86400) + 1 then
			if arg_20_0 < arg_20_1 then
				local var_20_1 = math.min(arg_20_3 + 1, table.length(gCostCsv.sign_in_buy))
				local var_20_2 = gCostCsv.sign_in_buy[var_20_1]

				if var_20_2 then
					if var_20_2 > 0 and var_20_2 > arg_19_0.rmb:read() then
						uiEasy.showDialog("rmb")
					else
						local var_20_3 = {
							isRich = true,
							clearFast = true,
							btnType = 2,
							cb = function()
								gGameApp:requestServer("/game/role/sign_in/buy", function(arg_22_0)
									gGameUI:showGainDisplay(arg_22_0)
								end)
							end,
							content = string.format(gLanguageCsv.retroactiveCommonBox, var_20_2),
							dialogParams = {
								clickClose = false
							}
						}

						if var_20_2 <= 0 then
							var_20_3.cb()
						else
							gGameUI:showDialog(var_20_3)
						end
					end
				end
			else
				gGameUI:showTip(gLanguageCsv.presentAtDutyEveryDay)
			end
		else
			gGameUI:showTip(gLanguageCsv.signInDayLessCreateDay)
		end
	end, arg_19_0.numDay, arg_19_0.currDay, arg_19_0.createTime, arg_19_0.costTimes, arg_19_0.totalCount)
end

function var_0_5.onBoxClick(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	if arg_23_0.boxData:proxy()[arg_23_2].state == var_0_1.CAN_OPEN then
		local var_23_0 = {
			false
		}

		gGameApp:requestServerCustom("/game/role/sign_in/month/total_award"):params(arg_23_2 + 100):onResponse(function(arg_24_0)
			uiEasy.setBoxEffect(arg_23_3, 0.5, function()
				var_23_0[1] = true
			end, 20, 10)
		end):wait(var_23_0):doit(function(arg_26_0)
			gGameUI:showGainDisplay(arg_26_0)
		end)
	else
		local var_23_1 = tonumber(string.sub(tostring(arg_23_0.monthData:read()), 5))
		local var_23_2 = {
			data = csv.signin[arg_23_0.boxData:read()[arg_23_2].id]["month" .. var_23_1],
			content = string.format(gLanguageCsv.totalSignInCanGetBox, arg_23_0.boxData:read()[arg_23_2].num),
			state = arg_23_0.boxData:proxy()[arg_23_2].state == var_0_1.OPENED and 0 or 1
		}

		gGameUI:showBoxDetail(var_23_2)
	end
end

function var_0_5.onGetClick(arg_27_0)
	if arg_27_0.totalCountGift:read()[2] == 1 then
		gGameApp:requestServer("/game/role/sign_in/total_award", function(arg_28_0)
			gGameUI:showGainDisplay(arg_28_0)
		end)
	end
end

function var_0_5.onItemClick(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
	idlereasy.do_(function(arg_30_0, arg_30_1)
		if arg_30_0 + 1 == arg_29_3.k and arg_30_1 < tonumber(time.getNowDate().day) then
			gGameApp:requestServer("/game/role/sign_in", function(arg_31_0)
				gGameUI:showGainDisplay(arg_31_0)
			end)
		else
			gGameUI:showItemDetail(arg_29_2, {
				key = arg_29_4.id,
				num = arg_29_4.num
			})
		end
	end, arg_29_0.numDay, arg_29_0.currDay)
end

function var_0_5.vipDoubleClick(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	if arg_32_0.showdata:atproxy(arg_32_2.k).vipState == var_0_2.CAN_GET then
		if arg_32_0.currDay:read() == tonumber(time.getDate(time.getTime()).day) and arg_32_2.k == arg_32_0.currPos:read() then
			gGameApp:requestServer("/game/role/sign_in", function(arg_33_0)
				gGameUI:showGainDisplay(arg_33_0)
			end)
		else
			gGameApp:requestServer("/game/role/sign_in/buy", function(arg_34_0)
				gGameUI:showGainDisplay(arg_34_0)
			end, arg_32_2.k)
		end
	else
		gGameUI:showDialog({
			btnType = 1,
			title = "",
			content = gLanguageCsv.vipNotEnough
		})
	end
end

return var_0_5
