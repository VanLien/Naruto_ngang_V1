local var_0_0 = {
	"login/tag_hot.png",
	"login/tag_limtime.png",
	"login/tag_new.png"
}
local var_0_1 = game.YYHUODONG_TYPE_ENUM_TABLE
local var_0_2 = {
	main = {
		subTitle = "ACTIVITY",
		topui = "common/txt/txt_bt_xianshihuodong.png",
		tabLine = "activity/a2.png",
		leftBg = "activity/img_tag_d.png",
		tabSelectedBg = "activity/a1.png",
		independent = {
			0,
			4
		},
		tabNormalColor = ui.COLORS.NORMAL.WHITE,
		title = gLanguageCsv.activity
	},
	award = {
		subTitle = "WELFARE",
		topui = "common/txt/txt_bt_fuli.png",
		tabLine = "common/box/box_bq_fgx.png",
		leftBg = "activity/img_tag_d.png",
		tabSelectedBg = "activity/a1.png",
		independent = {
			3,
			5
		},
		tabNormalColor = ui.COLORS.NORMAL.WHITE,
		title = gLanguageCsv.welfare
	}
}
local var_0_3 = {
	[var_0_1.directBuyGift] = {
		specialTag = "activityBuyGift"
	},
	[var_0_1.itemExchange] = {
		specialTag = "activityItemExchange"
	},
	[var_0_1.monthlyCard] = {
		specialTag = "activityMonthlyCard"
	},
	[var_0_1.regainStamina] = {
		specialTag = "activityRegainStamina"
	},
	[var_0_1.generalTask] = {
		specialTag = "activityGeneralTask"
	},
	[var_0_1.rechargeGift] = {
		specialTag = "activityRechargeGift"
	},
	[var_0_1.Retrieve] = {
		specialTag = "activityRetrieve"
	},
	[var_0_1.weeklyCard] = {
		specialTag = "activityWeeklyCard"
	}
}
local var_0_4 = class("ActivityView", cc.load("mvc").ViewBase)

var_0_4.RESOURCE_FILENAME = "activity.json"
var_0_4.RESOURCE_BINDING = {
	["leftPanel.item"] = "tabItem",
	leftPanel = "leftPanel",
	["rightPanel.topPanel"] = "rightTopPanel",
	["leftPanel.bg"] = {
		binds = {
			event = "texture",
			data = bindHelper.self("independentStyle"),
			method = function(arg_1_0)
				return var_0_2[arg_1_0].leftBg
			end
		}
	},
	["leftPanel.list"] = {
		varname = "tabList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 8,
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("tabItem"),
				independentStyle = bindHelper.self("independentStyle"),
				itemAction = {
					isAction = true
				},
				dataOrderCmp = function(arg_2_0, arg_2_1)
					if arg_2_0.sortWeight ~= arg_2_1.sortWeight then
						return arg_2_0.sortWeight < arg_2_1.sortWeight
					end

					return arg_2_0.id < arg_2_1.id
				end,
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = csv.yunying.yyhuodong[arg_3_2]
					local var_3_1 = var_0_2[arg_3_0.independentStyle]

					if matchLanguage({
						"en"
					}) then
						adapt.setTextAdaptWithSize(arg_3_1:get("name"), {
							margin = -8,
							vertical = "center",
							horizontal = "center",
							maxLine = 2,
							str = var_3_0.desc,
							size = cc.size(arg_3_1:width() - 50, 70)
						})
					else
						adapt.setTextScaleWithWidth(arg_3_1:get("name"), var_3_0.desc, arg_3_1:width() - 30)
					end

					local var_3_2 = var_3_0.type

					if var_0_3[var_3_2] then
						local var_3_3 = var_0_3[var_3_2]

						var_3_3.state = not arg_3_3.selected
						var_3_3.listenData = maptools.extend({
							var_3_3.listenData or {},
							{
								activityId = arg_3_2
							}
						})

						bind.extend(arg_3_0, arg_3_1, {
							class = "red_hint",
							props = var_3_3
						})
					end

					arg_3_1:get("selected"):visible(arg_3_3.selected)
					arg_3_1:get("normal"):visible(not arg_3_3.selected)

					if arg_3_3.selected then
						text.addEffect(arg_3_1:get("name"), {
							color = ui.NEWCOLORS.ORANGE,
							outline = {
								size = 3,
								color = ui.NEWCOLORS.OUTLINE.WHITE
							}
						})
					else
						text.deleteAllEffect(arg_3_1:get("name"))
						text.addEffect(arg_3_1:get("name"), {
							color = var_3_1.tabNormalColor
						})
					end

					arg_3_1:get("icon"):hide()

					if var_0_0[var_3_0.icon1] then
						arg_3_1:get("icon"):texture(var_0_0[var_3_0.icon1]):show():scale(0.9)
					end

					bind.click(arg_3_0, arg_3_1, {
						method = functools.partial(arg_3_0.clickCell, arg_3_2, arg_3_3)
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	["rightPanel.topPanel.name"] = {
		varname = "rightTopPanelName",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.WHITE5
					},
					shadow = {
						size = 6,
						color = cc.c4b(0, 0, 0, 255),
						offset = cc.size(0, -6)
					}
				}
			}
		}
	},
	["rightPanel.topPanel.title"] = {
		varname = "rightTopPaneltitle",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 3,
						color = cc.c4b(0, 0, 0, 255)
					}
				}
			}
		}
	},
	["rightPanel.topPanel.iconAll"] = {
		varname = "iconAll",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("oneKeyiconAllBtn")
			}
		}
	}
}

function var_0_4.addTabListClipping(arg_4_0)
	local var_4_0 = arg_4_0.tabList

	var_4_0:retain()
	var_4_0:removeFromParent()

	local var_4_1 = var_4_0:size()
	local var_4_2 = ccui.Scale9Sprite:create()

	var_4_2:initWithFile(cc.rect(200, 49, var_4_1.width, var_4_1.height), "activity/mask_tab_activity.png")
	var_4_2:size(var_4_1):anchorPoint(0, 0):xy(var_4_0:xy())
	cc.ClippingNode:create(var_4_2):setAlphaThreshold(0.1):add(var_4_0):addTo(arg_4_0.leftPanel, var_4_0:z())
	var_4_0:release()
end

function var_0_4.onCreate(arg_5_0, arg_5_1, arg_5_2)
	gGameModel.currday_dispatch:getIdlerOrigin("activityDirectBuyGift"):set(true)

	arg_5_0.independentStyle = arg_5_1 or "main"

	local var_5_0 = var_0_2[arg_5_0.independentStyle]

	arg_5_0.yyOpen = gGameModel.role:read("yy_open")
	arg_5_0.yyEndtime = gGameModel.role:read("yy_endtime")

	gGameUI.topuiManager:createView("default", arg_5_0, {
		onClose = arg_5_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = var_5_0.topui
	})
	arg_5_0:addTabListClipping()

	arg_5_0.viewDatas = {
		[var_0_1.monthlyCard] = {
			viewName = "city.activity.month_card",
			showRightInfo = false
		},
		[var_0_1.itemExchange] = {
			viewName = "city.activity.item_exchange",
			showRightInfo = true
		},
		[var_0_1.generalTask] = {
			viewName = "city.activity.general_task",
			showRightInfo = true
		},
		[var_0_1.itemBuy] = {
			viewName = "city.activity.item_buy",
			showRightInfo = true
		},
		[var_0_1.directBuyGift] = {
			viewName = "city.activity.buy_gift",
			showRightInfo = true
		},
		[var_0_1.clientShow] = {
			viewName = "city.activity.client_show",
			showRightInfo = false
		},
		[var_0_1.regainStamina] = {
			viewName = "city.activity.regain_stamina",
			showRightInfo = false
		},
		[var_0_1.rechargeGift] = {
			viewName = "city.activity.recharge_gift",
			showRightInfo = false
		},
		[var_0_1.Retrieve] = {
			viewName = "city.activity.resource_retrieve",
			showRightInfo = true
		},
		[var_0_1.weeklyCard] = {
			viewName = "city.activity.weekly_card",
			showRightInfo = false
		},
		[var_0_1.qualityExchange] = {
			viewName = "city.activity.quality_exchange_helditem",
			showRightInfo = true
		}
	}
	arg_5_0.subViews = {}
	arg_5_0.activityId = idler.new()
	arg_5_0.tabDatas = idlers.new()

	arg_5_0:onTabData(1, arg_5_2)
	arg_5_0.activityId:addListener(function(arg_6_0, arg_6_1)
		if arg_6_1 then
			arg_5_0.tabDatas:atproxy(arg_6_1).selected = false
		end

		if arg_6_0 then
			arg_5_0.tabDatas:atproxy(arg_6_0).selected = true
		end

		if arg_5_0.subViews[arg_6_1] then
			arg_5_0.subViews[arg_6_1]:hide()
		end

		local var_6_0 = csv.yunying.yyhuodong[arg_6_0]

		if var_6_0 then
			local var_6_1 = arg_5_0.viewDatas[var_6_0.type]

			if var_6_0.type == var_0_1.monthlyCard and var_6_0.clientParam.type == "tq" then
				var_6_1 = {
					viewName = "city.activity.privilege_card",
					showRightInfo = true
				}
			end

			if var_6_1 then
				arg_5_0.rightTopPanel:visible(var_6_1.showRightInfo)

				local var_6_2 = var_6_0.clientParam.topBg or "activity/banner_activity@.png"

				arg_5_0.rightTopPanel:get("bg"):texture(var_6_2)
				arg_5_0.rightTopPanelName:text(var_6_0.desc)

				if not arg_5_0.subViews[arg_6_0] then
					arg_5_0.subViews[arg_6_0] = gGameUI:createView(var_6_1.viewName, arg_5_0):init(arg_6_0, unpack(var_6_1.params or {}))
				else
					arg_5_0.subViews[arg_6_0]:show()

					if arg_5_0.subViews[arg_6_0].onInit then
						arg_5_0.subViews[arg_6_0]:onInit()
					end
				end

				local var_6_3 = false

				if var_6_0.type == 12 or var_6_0.type == 14 then
					var_6_3 = true

					arg_5_0:estimateType(var_6_0.type)
				end

				arg_5_0.iconAll:visible(var_6_3)
			else
				arg_5_0.rightTopPanel:visible(false)
				printWarn("activityType(%d) was not define", var_6_0.type)
			end

			local var_6_4 = arg_5_0.rightTopPanel:get("timeLabel")
			local var_6_5 = arg_5_0.rightTopPanel:get("time")
			local var_6_6 = arg_5_0.rightTopPanel:get("timeBg")
			local var_6_7 = var_6_0.clientParam.isShowCountDown ~= false

			var_6_4:visible(var_6_7)
			var_6_5:visible(var_6_7)
			var_6_6:visible(var_6_7)

			if var_6_7 then
				var_0_4.setCountdown(arg_5_0, arg_6_0, var_6_4, var_6_5, {
					labelChangeCb = function()
						adapt.oneLinePos(var_6_4, var_6_5, cc.p(20, 0))
						arg_5_0.rightTopPanel:get("timeBg"):size(var_6_4:size().width + var_6_5:size().width + 35, 50)
					end
				})
			end

			local var_6_8 = var_6_0.clientParam.isShowTitle ~= false

			arg_5_0.rightTopPanel:get("name"):setVisible(var_6_8)
		end
	end)
	idlereasy.when(gGameModel.role:getIdler("yyhuodongs"), function(arg_8_0, arg_8_1)
		local cfg = csv.yunying.yyhuodong[arg_5_0.activityId:read()]
		if cfg and cfg.type == 14 then
			arg_5_0:estimateType(14)
		end
	end)
end

function var_0_4.onTabClick(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local cfg = csv.yunying.yyhuodong[arg_9_2]
	arg_9_0.rightTopPaneltitle:visible(cfg and cfg.type == 33)
	arg_9_0.activityId:set(arg_9_2)
end

function var_0_4.onTabData(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = {}
	local var_10_1 = {}
	local var_10_2 = false

	for iter_10_0, iter_10_1 in ipairs(arg_10_0.yyOpen) do
		if var_0_4.isShow(iter_10_1, arg_10_0.independentStyle, arg_10_0.yyEndtime) then
			local var_10_3 = csv.yunying.yyhuodong[iter_10_1].sortWeight

			var_10_0[iter_10_1] = {
				selected = false,
				id = iter_10_1,
				sortWeight = var_10_3
			}

			table.insert(var_10_1, var_10_0[iter_10_1])

			if arg_10_2 and arg_10_2 == iter_10_1 then
				var_10_0[iter_10_1].selected = true
				var_10_2 = true
			end
		end
	end

	table.sort(var_10_1, function(arg_11_0, arg_11_1)
		if arg_11_0.sortWeight ~= arg_11_1.sortWeight then
			return arg_11_0.sortWeight < arg_11_1.sortWeight
		end

		return arg_11_0.id < arg_11_1.id
	end)

	if #var_10_1 >= 1 then
		var_10_0[var_10_1[#var_10_1].id].isLast = true
	end

	if not var_10_2 then
		arg_10_1 = math.min(arg_10_1, #var_10_1)

		if arg_10_1 <= 0 then
			arg_10_2 = nil

			printWarn("no open activity!!!")
		else
			local var_10_4 = var_10_0[var_10_1[arg_10_1].id]

			var_10_4.selected = true
			arg_10_2 = var_10_4.id
		end
	else
		for iter_10_2, iter_10_3 in ipairs(var_10_0) do
			if iter_10_3.selected then
				arg_10_1 = iter_10_2

				break
			end
		end
	end

	arg_10_0.tabDatas:update(var_10_0)
	local cfg = arg_10_2 and csv.yunying.yyhuodong[arg_10_2]
	arg_10_0.rightTopPaneltitle:visible(cfg and cfg.type == 33)
	arg_10_0.activityId:set(arg_10_2)
end

function var_0_4.isShow(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = csv.yunying.yyhuodong[arg_12_0]
	local var_12_1 = false

	for iter_12_0, iter_12_1 in ipairs(var_0_2[arg_12_1].independent) do
		if var_12_0.independent == iter_12_1 then
			var_12_1 = true

			break
		end
	end

	if var_12_1 == false then
		return false
	end

	if var_12_0.type == var_0_1.levelFund then
		return false
	end

	if var_12_0.type == var_0_1.dinnerTime then
		return false
	end

	if var_12_0.type == var_0_1.monthlyCard and var_12_0.paramMap.rechargeID ~= 1 and not var_12_0.clientParam.type then
		return false
	end

	arg_12_2 = arg_12_2 or gGameModel.role:read("yy_endtime")

	if not arg_12_2[arg_12_0] or arg_12_2[arg_12_0] - time.getTime() <= 0 then
		return false
	end

	if var_12_0.type == var_0_1.Retrieve then
		local var_12_2 = gGameModel.role:read("yyhuodongs")[arg_12_0]

		if var_12_2 == nil then
			return false
		end

		if var_12_2.lastday ~= tonumber(time.getTodayStrInClock()) then
			return false
		end

		if var_12_2.retrieve_award == nil then
			return true
		end

		local var_12_3 = gGameModel.role:read("level")
		local var_12_4 = csv.yunying.retrieve[var_12_3]
		local var_12_5 = 6
		local var_12_6 = 0

		for iter_12_2, iter_12_3 in pairs(var_12_2.retrieve_award) do
			if iter_12_3.rmb == 1 then
				var_12_6 = var_12_6 + 1
			end
		end

		return var_12_6 < var_12_5
	end

	if var_12_0.type == var_0_1.weeklyCard then
		local var_12_7 = gGameModel.role:read("yyhuodongs")[arg_12_0] or {}
		local var_12_8 = csv.yunying.yyhuodong[arg_12_0]

		if var_12_7.buy == nil then
			local var_12_9, var_12_10 = time.getHourAndMin(var_12_8.beginTime)
			local var_12_11 = var_12_8.paramMap.buyDay

			if time.getNumTimestamp(var_12_8.beginDate, var_12_9, var_12_10) + var_12_11 * 24 * 60 * 60 - time.getTime() <= 0 then
				return false
			end
		else
			local var_12_12, var_12_13 = time.getHourAndMin(var_12_8.endTime)

			if time.getNumTimestamp(var_12_8.endDate, var_12_12, var_12_13) - time.getTime() <= 0 then
				return false
			end
		end
	end

	return true
end

function var_0_4.isDataExist(arg_13_0)
	arg_13_0 = arg_13_0 or "main"

	local var_13_0 = gGameModel.role:read("yy_open")

	for iter_13_0, iter_13_1 in ipairs(var_13_0) do
		if var_0_4.isShow(iter_13_1, arg_13_0) then
			return true
		end
	end

	return false
end

function var_0_4.setCountdown(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	arg_14_4 = arg_14_4 or {}

	local var_14_0 = arg_14_4.tag or 1

	arg_14_0:enableSchedule():unSchedule(var_14_0)

	local var_14_1 = csv.yunying.yyhuodong[arg_14_1]
	local var_14_2 = ""

	if var_14_1.countType == 0 then
		var_14_2 = gLanguageCsv.activityDaily
	end

	local var_14_3 = 0
	local var_14_4 = gGameModel.role:read("yy_endtime")

	if var_14_4[arg_14_1] then
		var_14_3 = var_14_4[arg_14_1] - time.getTime()
	end

	bind.extend(arg_14_0, arg_14_3, {
		class = "cutdown_label",
		props = {
			time = var_14_3,
			tag = var_14_0,
			strFunc = function(arg_15_0)
				return arg_15_0.str .. var_14_2
			end,
			callFunc = function()
				if arg_14_4.labelChangeCb then
					arg_14_4.labelChangeCb()
				end
			end,
			endFunc = function()
				arg_14_2:text(gLanguageCsv.activityOver)

				if arg_14_4.labelChangeCb then
					arg_14_4.labelChangeCb()
				end
			end,
			onNode = function(arg_18_0)
				arg_14_2:text(gLanguageCsv.activityLeftTime)
			end
		}
	})
end

function var_0_4.estimateType(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0.activityId:read()

	if arg_19_1 == 14 then
		local var_19_1 = csv.yunying.yyhuodong[var_19_0].huodongID
		local var_19_2 = (gGameModel.role:read("yyhuodongs")[var_19_0] or {}).stamps or {}
		local var_19_3 = 2

		for iter_19_0, iter_19_1 in csvPairs(csv.yunying.generaltask) do
			if iter_19_1.huodongID == var_19_1 and var_19_2[iter_19_0] == 1 then
				var_19_3 = 1

				break
			end
		end

		uiEasy.setBtnShader(arg_19_0.iconAll, false, var_19_3)
		arg_19_0.iconAll:get("txt"):text(gLanguageCsv.getAwardAll)

		if var_19_3 == 1 then
			text.addEffect(arg_19_0.iconAll:get("txt"), {
				color = color1,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
		else
			text.deleteAllEffect(arg_19_0.iconAll:get("txt"))
		end
	else
		local var_19_4 = userDefault.getForeverLocalKey("activityItemExchange", {})[var_19_0] or {}
		local var_19_5 = false

		if var_19_4 then
			for iter_19_2, iter_19_3 in pairs(var_19_4) do
				if iter_19_3 then
					var_19_5 = true

					break
				end
			end
		end

		uiEasy.setBtnShader(arg_19_0.iconAll, false, 1)

		local var_19_6 = not var_19_5 and gLanguageCsv.notRemind or gLanguageCsv.anewRemind

		arg_19_0.iconAll:get("txt"):text(var_19_6)
		text.addEffect(arg_19_0.iconAll:get("txt"), {
			color = color1,
			outline = {
				size = 4,
				color = ui.NEWCOLORS.OUTLINE.YELLOW
			}
		})

		return var_19_5
	end
end

function var_0_4.oneKeyiconAllBtn(arg_20_0)
	local var_20_0 = arg_20_0.activityId:read()

	if arg_20_0.subViews[var_20_0] and arg_20_0.subViews[var_20_0]:isVisible() then
		local var_20_1 = csv.yunying.yyhuodong[var_20_0].type

		if var_20_1 == 14 then
			gGameApp:requestServer("/game/yy/award/get/onekey", function(arg_21_0)
				gGameUI:showGainDisplay(arg_21_0)
				arg_20_0:estimateType(var_20_1)
			end, var_20_0)
		else
			local var_20_2 = arg_20_0:estimateType(var_20_1)
			local var_20_3 = csv.yunying.yyhuodong[var_20_0].huodongID
			local var_20_4 = userDefault.getForeverLocalKey("activityItemExchange", {})
			local var_20_5 = var_20_4[var_20_0] or {}

			for iter_20_0, iter_20_1 in csvPairs(csv.yunying.itemexchange) do
				if iter_20_1.huodongID == var_20_3 then
					var_20_5[iter_20_0] = not var_20_2 and true or false
				end
			end

			var_20_4[var_20_0] = var_20_5

			gGameModel.forever_dispatch:getIdlerOrigin("activityItemExchange"):set(var_20_4, true)
			arg_20_0.subViews[var_20_0]:remindUpdata()
			arg_20_0:estimateType(var_20_1)
		end
	end
end

return var_0_4
