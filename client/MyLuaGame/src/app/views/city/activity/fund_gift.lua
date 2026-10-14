local var_0_0 = {
	received = 3,
	noReach = 2,
	canReceive = 1
}
local var_0_1 = {
	nightmare = 3,
	hero = 2,
	normal = 1
}
local var_0_2 = {
	[var_0_1.normal] = 10,
	[var_0_1.hero] = 110,
	[var_0_1.nightmare] = 210
}

local function var_0_3(arg_1_0)
	local var_1_0 = 0
	local var_1_1 = 0

	if arg_1_0 % 100 == 0 then
		_type, var_1_0 = dataEasy.getChapterInfoByGateID(arg_1_0)
		var_1_1 = 0
	else
		local var_1_2 = csv.scene_conf[arg_1_0]
		local var_1_3 = csv.world_map[var_1_2.ownerId]

		var_1_0 = var_1_2.ownerId - var_0_2[var_1_3.chapterType] or 0

		for iter_1_0, iter_1_1 in pairs(var_1_3.seq) do
			if arg_1_0 == iter_1_1 then
				var_1_1 = iter_1_0

				break
			end
		end
	end

	return var_1_0, var_1_1
end

local var_0_4 = class("ActivityFundGift", Dialog)

var_0_4.RESOURCE_FILENAME = "activity_jjlb.json"
var_0_4.RESOURCE_BINDING = {
	btnbuy = "buyBtn",
	item = "item",
	img = "img",
	["btnbuy.txt"] = "buyLabel",
	["Left_Panel.item"] = "leftItem",
	close = {
		varname = "close",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["Left_Panel.list"] = {
		varname = "leftPanel",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("leftDatas"),
				item = bindHelper.self("leftItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:get("normal")
					local var_2_1 = arg_2_1:get("selected")
					local var_2_2

					if arg_2_3.select then
						var_2_0:hide()

						var_2_2 = var_2_1:show()

						var_2_2:setTouchEnabled(false)
					else
						var_2_1:hide()

						var_2_2 = var_2_0:show()

						var_2_2:setTouchEnabled(true)
					end

					var_2_2:get("txt"):text(arg_2_3.name)
					bind.touch(arg_2_0, var_2_0, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("datas"),
				item = bindHelper.self("item"),
				level = bindHelper.self("level"),
				endless = bindHelper.self("endless"),
				cid = bindHelper.self("cid"),
				gid = bindHelper.self("gid"),
				itemAction = {
					isAction = true
				},
				dataOrderCmp = function(arg_3_0, arg_3_1)
					if arg_3_0.state ~= arg_3_1.state then
						return arg_3_0.state < arg_3_1.state
					end

					return arg_3_0.csvId < arg_3_1.csvId
				end,
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_3.cfg
					local var_4_1 = arg_4_1:multiget("list", "num", "receivebtn", "received", "desc")

					uiEasy.createItemsToList(arg_4_0, var_4_1.list, var_4_0.award)
					var_4_1.desc:text(var_4_0.desc)
					text.addEffect(var_4_1.num, {
						color = ui.COLORS.NORMAL.FRIEND_GREEN
					})

					if arg_4_3.type == "level" then
						var_4_1.num:text(string.format("%d/%d", arg_4_0.level, var_4_0.needLevel))
					elseif arg_4_3.type == "tower" then
						var_4_1.num:text(string.format("%d/%d", arg_4_0.endless % 100000, var_4_0.needLevel % 100000))
					elseif arg_4_3.type == "line" then
						local var_4_2, var_4_3 = var_0_3(var_4_0.needLevel)

						var_4_1.num:text(arg_4_0.cid .. "-" .. arg_4_0.gid .. "/" .. var_4_2 .. "-" .. var_4_3)
					end

					adapt.oneLinePos(var_4_1.desc, var_4_1.num, cc.p(5, 0), "left")
					var_4_1.receivebtn:visible(arg_4_3.state ~= var_0_0.received)
					var_4_1.received:visible(arg_4_3.state == var_0_0.received)
					var_4_1.receivebtn:setTouchEnabled(false)
					cache.setShader(var_4_1.receivebtn, false, "normal")

					local var_4_4 = var_4_1.receivebtn:get("Label")

					if arg_4_3.state == var_0_0.canReceive then
						var_4_1.receivebtn:setTouchEnabled(true)
						cache.setShader(var_4_1.receivebtn, false, "normal")
						text.addEffect(var_4_4, {
							color = ui.COLORS.NORMAL.BROWN,
							outline = {
								size = 4,
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							}
						})
						bind.touch(arg_4_0, var_4_1.receivebtn, {
							methods = {
								ended = functools.partial(arg_4_0.clickCell, arg_4_2, arg_4_3)
							}
						})
					elseif arg_4_3.state == var_0_0.noReach then
						text.addEffect(var_4_1.num, {
							color = ui.COLORS.NORMAL.ALERT_ORANGE
						})
						cache.setShader(var_4_1.receivebtn, false, "hsl_gray")
						text.deleteAllEffect(var_4_4)
						text.addEffect(var_4_4, {
							color = ui.COLORS.DISABLED.WHITE
						})
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onReceiveClick")
			}
		}
	}
}

function var_0_4.onCreate(arg_5_0, arg_5_1)
	arg_5_0.activityId = arg_5_1

	arg_5_0:initModel()

	local var_5_0 = csv.yunying.yyhuodong[arg_5_1].huodongID

	arg_5_0.datas = idlers.new()

	idlereasy.when(arg_5_0.yyhuodongs, function(arg_6_0, arg_6_1)
		local var_6_0 = {}
		local var_6_1 = csv.yunying.yyhuodong[arg_5_1].type
		local var_6_2 = {}
		local var_6_3 = 1

		for iter_6_0, iter_6_1 in ipairs(gGameModel.role:read("yy_open")) do
			local var_6_4 = csv.yunying.yyhuodong[iter_6_1]

			if var_6_4.type == var_6_1 then
				var_6_4.activityId = iter_6_1
				var_6_0[var_6_4.huodongID] = {
					yyId = iter_6_1,
					type = var_6_4.paramMap.type,
					idx = var_6_3
				}

				table.insert(var_6_2, var_6_4)

				var_6_3 = var_6_3 + 1
			end
		end

		arg_5_0.lefts = var_6_2

		arg_5_0.leftDatas:update(var_6_2)
		arg_5_0.curTab:addListener(function(arg_7_0, arg_7_1, arg_7_2)
			for iter_7_0, iter_7_1 in pairs(arg_5_0.lefts) do
				arg_5_0.leftDatas:atproxy(iter_7_0).select = false
			end

			arg_5_0.leftDatas:atproxy(arg_7_0).select = true
		end)

		local var_6_5 = {}

		for iter_6_2, iter_6_3 in csvPairs(csv.yunying.levelfund) do
			if var_6_0[iter_6_3.huodongID] then
				if not var_6_5[iter_6_3.huodongID] then
					var_6_5[iter_6_3.huodongID] = {}
				end

				local var_6_6 = (arg_6_1[var_6_0[iter_6_3.huodongID].yyId] or {}).stamps or {}
				local var_6_7 = gGameModel.role:getYYHuoDongTasksProgress(var_6_0[iter_6_3.huodongID].yyId) or {}
				local var_6_8 = var_0_0.noReach

				if var_6_6[iter_6_2] == 1 then
					var_6_8 = var_0_0.canReceive
				elseif var_6_6[iter_6_2] == 0 then
					var_6_8 = var_0_0.received
				end

				table.insert(var_6_5[iter_6_3.huodongID], {
					csvId = iter_6_2,
					cfg = iter_6_3,
					state = var_6_8,
					progress = var_6_7[iter_6_2],
					yyId = var_6_0[iter_6_3.huodongID].yyId,
					type = var_6_0[iter_6_3.huodongID].type
				})
			end
		end

		arg_5_0.listDatas = var_6_5

		dataEasy.tryCallFunc(arg_5_0.list, "updatePreloadCenterIndex")
		arg_5_0:onTabClick(nil, arg_5_0.curTab:read())
		arg_5_0:updateRight(var_6_0[var_5_0].idx)
	end)
	arg_5_0.datas:update(arg_5_0.listDatas[var_5_0])
	Dialog.onCreate(arg_5_0)
end

function var_0_4.initModel(arg_8_0)
	arg_8_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_8_0.level = gGameModel.role:read("level")
	arg_8_0.endless = gGameModel.role:read("endless_tower_max_gate")
	arg_8_0.gateStar = gGameModel.role:read("gate_star") or {}

	if next(arg_8_0.gateStar) ~= nil then
		local var_8_0 = {}

		for iter_8_0, iter_8_1 in pairs(arg_8_0.gateStar) do
			if iter_8_0 < 20000 then
				table.insert(var_8_0, iter_8_0)
			end
		end

		table.sort(var_8_0)

		local var_8_1 = var_8_0[#var_8_0]

		arg_8_0.cid, arg_8_0.gid = var_0_3(var_8_1)
	else
		arg_8_0.cid, arg_8_0.gid = 0, 0
	end

	arg_8_0.leftDatas = idlers.new()
	arg_8_0.curTab = idler.new(1)
end

function var_0_4.onTabClick(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0.curTab:set(arg_9_2)

	local var_9_0 = arg_9_0.lefts[arg_9_2].huodongID

	arg_9_0.datas:update(arg_9_0.listDatas[var_9_0])
	arg_9_0:updateRight(arg_9_2)
end

function var_0_4.updateRight(arg_10_0, arg_10_1)
	arg_10_0.img:removeAllChildren()
	arg_10_0.img:texture("activity/jjlb/img_" .. arg_10_1 .. ".png")

	local var_10_0 = arg_10_0.lefts[arg_10_1]
	local var_10_1 = var_10_0.huodongID
	local var_10_2 = 0

	for iter_10_0, iter_10_1 in csvPairs(csv.yunying.levelfund) do
		if iter_10_1.huodongID == var_10_1 and iter_10_1.award[8617] then
			var_10_2 = var_10_2 + iter_10_1.award[8617]
		end
	end

	local var_10_3 = 20
	local var_10_4 = 320
	local var_10_5 = csv.recharges[var_10_0.paramMap.rechargeID]

	rich.createByStr(string.format(gLanguageCsv.FundGiftTitle, var_10_5.rmbDisplay, var_10_2), 40, nil, 150):anchorPoint(0, 0.5):xy(var_10_3, var_10_4 + 50):addTo(arg_10_0.img):z(10):scale(0.5):ignoreContentAdaptWithSize(false):size(650, 300):formatText()

	if tonumber(var_10_0.paramMap.vip) > 0 then
		rich.createByStr(string.format(gLanguageCsv.levelFundTitle2, ui.VIP_ICON[var_10_0.paramMap.vip]), 40):anchorPoint(0, 0.5):xy(var_10_3, var_10_4):addTo(arg_10_0.img):z(10):scale(0.5):ignoreContentAdaptWithSize(false):size(650, 300):formatText()
	end

	local var_10_6 = arg_10_0.yyhuodongs:read()[var_10_0.activityId] or {}
	local var_10_7 = csv.recharges[var_10_0.paramMap.rechargeID]

	if not var_10_6.buy then
		arg_10_0.buyBtn:setTouchEnabled(true)
		cache.setShader(arg_10_0.buyBtn, false, "normal")
		arg_10_0.buyLabel:text(string.format(gLanguageCsv.symbolMoney, var_10_7.rmbDisplay))
		text.addEffect(arg_10_0.buyLabel, {
			color = ui.COLORS.NORMAL.BROWN,
			outline = {
				size = 4,
				color = ui.NEWCOLORS.OUTLINE.YELLOW
			}
		})
		bind.touch(arg_10_0, arg_10_0.buyBtn, {
			methods = {
				ended = function()
					arg_10_0:onBuyBtn(arg_10_1)
				end
			}
		})
	else
		arg_10_0.buyBtn:setTouchEnabled(false)
		cache.setShader(arg_10_0.buyBtn, false, "hsl_gray")
		text.deleteAllEffect(arg_10_0.buyLabel)
		arg_10_0.buyLabel:text(gLanguageCsv.hasBuy)
		text.addEffect(arg_10_0.buyLabel, {
			color = ui.COLORS.DISABLED.WHITE
		})
	end
end

function var_0_4.onBuyBtn(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0.lefts[arg_12_1]

	if gGameModel.role:read("vip_level") < var_12_0.paramMap.vip then
		gGameUI:showDialog({
			clearFast = true,
			isRich = true,
			btnType = 2,
			title = "",
			content = gLanguageCsv.fundVipNotEnough,
			cb = function()
				gGameUI:stackUI("city.recharge", nil)
			end,
			btnStr = gLanguageCsv.showVip,
			dialogParams = {
				clickClose = false
			}
		})

		return
	end

	gGameApp:payDirect(arg_12_0, {
		buyTimes = 0,
		rechargeId = var_12_0.paramMap.rechargeID,
		yyID = var_12_0.activityId,
		name = var_12_0.desc,
		csvID = arg_12_1
	}):serverCb(function(arg_14_0)
		gGameUI:showTip(gLanguageCsv.buySuccess)
	end):doit(function(arg_15_0)
		if arg_15_0 and arg_15_0.ret then
			gGameUI:showTip(gLanguageCsv.buySuccess)
			arg_12_0.buyBtn:setTouchEnabled(false)
			cache.setShader(arg_12_0.buyBtn, false, "hsl_gray")
			arg_12_0.buyLabel:text(gLanguageCsv.hasBuy)
			arg_12_0:onTabClick(nil, arg_12_1)
		end
	end)
end

function var_0_4.onReceiveClick(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	if arg_16_3.state == var_0_0.canReceive then
		gGameApp:requestServer("/game/yy/award/get", function(arg_17_0)
			gGameUI:showGainDisplay(arg_17_0)
		end, arg_16_3.yyId, arg_16_3.csvId)
	elseif arg_16_3.state == var_0_0.noReach then
		gGameUI:showTip(gLanguageCsv.notReachedCannotGet)
	end
end

return var_0_4
