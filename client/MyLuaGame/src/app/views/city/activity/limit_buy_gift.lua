local var_0_0 = {
	BOUGHT = 2,
	CANBUY = 1,
	TIMEOUT = 3
}
local var_0_1 = require("app.views.city.activity.view")
local var_0_2 = class("ActivityLimitBuyGiftView", Dialog)

var_0_2.RESOURCE_FILENAME = "activity_limit_buy_gift.json"
var_0_2.RESOURCE_BINDING = {
	["rightPanel.countPanel.countTimeBg"] = "countTimeBg",
	["rightPanel.bg"] = "rightBg",
	["rightPanel.list"] = "rewardList",
	["leftPanel.item"] = "item",
	["rightPanel.lv"] = "lv",
	["rightPanel.countPanel.countTimeNode"] = "countTimeNode",
	["rightPanel.countPanel.countTime"] = "countTime",
	["rightPanel.countPanel"] = "countPanel",
	rightPanel = "rightPanel",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
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
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("btn")

					var_1_0:get("selected"):visible(arg_1_3.select)
					var_1_0:get("normal"):visible(not arg_1_3.select)
					var_1_0:get("name"):text(arg_1_3.cfg.name)

					if arg_1_3.select then
						text.addEffect(var_1_0:get("name"), {
							color = ui.NEWCOLORS.ORANGE,
							outline = {
								size = 3,
								color = ui.NEWCOLORS.OUTLINE.WHITE
							}
						})
					else
						text.deleteAllEffect(var_1_0:get("name"))
						text.addEffect(var_1_0:get("name"), {
							color = ui.COLORS.NORMAL.WHITE
						})
					end

					var_0_2.setCountdown(arg_1_0, var_1_0:get("countTime"), {
						info = arg_1_3,
						tag = arg_1_3.csvId,
						cb = function()
							if arg_1_3.state ~= var_0_0.BOUGHT then
								arg_1_3.state = var_0_0.TIMEOUT
							end
						end
					})
					var_1_0:setTouchEnabled(not arg_1_3.select)
					bind.touch(arg_1_0, var_1_0, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2)
						}
					})
				end,
				onAfterBuild = function(arg_3_0)
					arg_3_0.afterBuild()
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick"),
				afterBuild = bindHelper.self("onAfterBuild")
			}
		}
	},
	["rightPanel.btnBuy"] = {
		varname = "btnBuy",
		binds = {
			clicksafe = true,
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnBuy")
			}
		}
	},
	["rightPanel.btnBuy.price"] = {
		varname = "price",
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
	}
}

function var_0_2.onCreate(arg_4_0)
	arg_4_0:enableSchedule()
	arg_4_0:initModel()

	local var_4_0 = {}

	arg_4_0.datas = var_4_0

	for iter_4_0, iter_4_1 in ipairs(gGameModel.role:read("yy_open")) do
		local var_4_1 = csv.yunying.yyhuodong[iter_4_1]

		if var_4_1.type == game.YYHUODONG_TYPE_ENUM_TABLE.limitBuyGift then
			for iter_4_2, iter_4_3 in orderCsvPairs(csv.yunying.limitbuygift) do
				if iter_4_3.huodongID == var_4_1.huodongID then
					if var_4_0[iter_4_2] then
						printWarn("yyId(%s) yunying.limitbuygift k(%d) is already in yyId(%s)", iter_4_1, iter_4_2, var_4_0[iter_4_2].yyId)
					else
						var_4_0[iter_4_2] = {
							cfg = iter_4_3,
							csvId = iter_4_2,
							yyId = iter_4_1
						}
					end
				end
			end
		end
	end

	arg_4_0.tabDatas = idlers.newWithMap({})
	arg_4_0.clientBuyTimes = idler.new(true)
	arg_4_0.showTab = idler.new(1)

	local var_4_2 = table.deepcopy(arg_4_0.yyhuodongs:read(), true)

	idlereasy.any({
		arg_4_0.yyhuodongs,
		arg_4_0.clientBuyTimes
	}, function(arg_5_0, arg_5_1)
		arg_5_1 = var_4_2

		arg_4_0:unSchedule(9999999)

		local var_5_0 = {}

		for iter_5_0, iter_5_1 in pairs(var_4_0) do
			local var_5_1 = arg_5_1[iter_5_1.yyId]
			local var_5_2 = 1 - (var_5_1.stamps[iter_5_1.csvId] or 1)
			local var_5_3 = dataEasy.getPayClientBuyTimes("directBuyData", iter_5_1.yyId, iter_5_1.csvId, var_5_2)

			if iter_5_1.state then
				iter_5_1.startTime = var_5_1.valinfo[iter_5_1.csvId].time

				if var_5_3 > 0 then
					iter_5_1.state = var_0_0.BOUGHT
				end

				table.insert(var_5_0, iter_5_1)
			elseif var_5_1.valinfo[iter_5_1.csvId] and time.getTime() - var_5_1.valinfo[iter_5_1.csvId].time < iter_5_1.cfg.duration * 60 and var_5_3 == 0 then
				iter_5_1.state = var_0_0.CANBUY
				iter_5_1.startTime = var_5_1.valinfo[iter_5_1.csvId].time

				table.insert(var_5_0, iter_5_1)
			end
		end

		table.sort(var_5_0, function(arg_6_0, arg_6_1)
			if arg_6_0.cfg.sort == arg_6_1.cfg.sort then
				return arg_6_0.csvId < arg_6_1.csvId
			end

			return arg_6_0.cfg.sort < arg_6_1.cfg.sort
		end)
		arg_4_0.tabDatas:update(var_5_0)
		arg_4_0.showTab:notify()
	end)

	local var_4_3, var_4_4 = arg_4_0.rewardList:xy()

	arg_4_0.showTab:addListener(function(arg_7_0, arg_7_1)
		if arg_4_0.tabDatas:size() <= 0 then
			arg_4_0.rightPanel:hide()

			return
		end

		arg_4_0.tabDatas:atproxy(arg_7_1).select = false
		arg_4_0.tabDatas:atproxy(arg_7_0).select = true

		if arg_4_0.tabDatas:atproxy(arg_7_0) then
			arg_4_0.currentInfo = arg_4_0.tabDatas:atproxy(arg_7_0)
		end

		local var_7_0 = 11

		uiEasy.createItemsToList(arg_4_0, arg_4_0.rewardList, arg_4_0.currentInfo.cfg.item, {
			margin = var_7_0,
			onAfterBuild = function()
				arg_4_0.rewardList:setItemAlignCenter()
			end,
			onNode = function(arg_9_0)
				return
			end
		})
		arg_4_0.rightBg:texture(arg_4_0.currentInfo.cfg.bgPath)
		arg_4_0.countTimeBg:texture(arg_4_0.currentInfo.cfg.countPath)
		arg_4_0.countPanel:visible(arg_4_0.currentInfo.state ~= var_0_0.BOUGHT)
		arg_4_0:setCountdown(arg_4_0.countTime, {
			tag = 9999999,
			info = arg_4_0.currentInfo
		})

		if arg_4_0.currentInfo.cfg.targetType1 == 1 then
			arg_4_0.lv:show()
			arg_4_0.lv:text(arg_4_0.currentInfo.cfg.targetArg1_1)
		else
			arg_4_0.lv:hide()
		end

		arg_4_0.btnBuy:setTouchEnabled(arg_4_0.currentInfo.state ~= var_0_0.BOUGHT)
		arg_4_0.btnBuy:get("bgMask"):visible(arg_4_0.currentInfo.state == var_0_0.BOUGHT)
		arg_4_0.btnBuy:get("imgTips"):texture(arg_4_0.currentInfo.state == var_0_0.BOUGHT and "activity/limit_buy_gift/txt_ysq.png" or "activity/limit_buy_gift/txt_ljqg.png")

		local var_7_1 = csv.recharges

		for iter_7_0, iter_7_1 in orderCsvPairs(var_7_1) do
			if iter_7_0 == arg_4_0.currentInfo.cfg.rechargeID then
				arg_4_0.price:text(string.format(gLanguageCsv.symbolMoney, iter_7_1.rmbDisplay)):scale(0.9)
				text.addEffect(arg_4_0.price, {
					color = ui.COLORS.NORMAL.YELLOW,
					outline = {
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				})

				break
			end
		end
	end)
	Dialog.onCreate(arg_4_0, {
		blackType = 1
	})
end

function var_0_2.initModel(arg_10_0)
	arg_10_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
end

function var_0_2.onTabClick(arg_11_0, arg_11_1, arg_11_2)
	arg_11_0.showTab:set(arg_11_2)
end

function var_0_2.checkCountTime(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = time.getTime()

	if not arg_12_1 then
		return false
	end

	if var_12_0 < arg_12_1 then
		return false
	end

	local var_12_1 = arg_12_2 * 60 + arg_12_1 - var_12_0

	if var_12_1 <= 0 then
		return false
	end

	return var_12_1
end

function var_0_2.onBtnBuy(arg_13_0)
	if arg_13_0.currentInfo.state == var_0_0.BOUGHT then
		-- block empty
	elseif arg_13_0.currentInfo.state == var_0_0.TIMEOUT then
		gGameUI:showTip(gLanguageCsv.giftOutOfDate)
	else
		gGameApp:payDirect(arg_13_0, {
			buyTimes = 0,
			rechargeId = arg_13_0.currentInfo.cfg.rechargeID,
			yyID = arg_13_0.currentInfo.yyId,
			csvID = arg_13_0.currentInfo.csvId,
			name = arg_13_0.currentInfo.cfg.name
		}, arg_13_0.clientBuyTimes):serverCb(function()
			local var_14_0 = arg_13_0.datas[arg_13_0.currentInfo.csvId].cfg

			gGameUI:showGainDisplay(var_14_0.item, {
				raw = false
			})
		end):doit(function()
			arg_13_0.datas[arg_13_0.currentInfo.csvId].state = var_0_0.BOUGHT
			arg_13_0.currentInfo.state = var_0_0.BOUGHT

			arg_13_0:unSchedule(9999999)
			arg_13_0.countTime:text(gLanguageCsv.sellout)
			arg_13_0.countPanel:hide()
			arg_13_0.btnBuy:setTouchEnabled(false)
			arg_13_0.btnBuy:get("bgMask"):show()
			arg_13_0.btnBuy:get("imgTips"):texture("activity/limit_buy_gift/txt_ysq.png")
		end)
	end
end

function var_0_2.onAfterBuild(arg_16_0)
	if arg_16_0.tabDatas:size() <= 0 then
		return
	end

	arg_16_0:setCountdown(arg_16_0.countTime, {
		tag = 9999999,
		info = arg_16_0.currentInfo
	})
end

function var_0_2.setCountdown(arg_17_0, arg_17_1, arg_17_2)
	arg_17_0:enableSchedule()

	local var_17_0 = var_0_2:checkCountTime(arg_17_2.info.startTime, arg_17_2.info.cfg.duration)

	arg_17_0:unSchedule(arg_17_2.tag)

	if not var_17_0 or arg_17_2.info.state ~= var_0_0.CANBUY then
		arg_17_1:text(time.getCutDown(0).str)

		if arg_17_2.info.state == var_0_0.BOUGHT then
			arg_17_1:text(gLanguageCsv.sellout)
		end

		if arg_17_2.cb then
			arg_17_2.cb()
		end

		return
	end

	arg_17_0:schedule(function()
		var_17_0 = arg_17_2.info.cfg.duration * 60 + arg_17_2.info.startTime - time.getTime()

		arg_17_1:text(time.getCutDown(var_17_0).str)

		if var_17_0 <= 0 then
			var_0_2.setCountdown(arg_17_0, arg_17_1, arg_17_2)
		end
	end, 1, 0, arg_17_2.tag)
end

return var_0_2
