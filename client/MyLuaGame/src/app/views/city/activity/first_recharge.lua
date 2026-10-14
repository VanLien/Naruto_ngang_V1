local var_0_0 = game.YYHUODONG_TYPE_ENUM_TABLE
local var_0_1 = {
	received = 2,
	noReach = 0,
	canReceive = 1
}
local var_0_2 = class("ActivityFirstRecharge", Dialog)

var_0_2.RESOURCE_FILENAME = "activity_first_recharge.json"
var_0_2.RESOURCE_BINDING = {
	page2 = "page2",
	page1 = "page1",
	["page1.mask"] = "mask1",
	["downPanel.item"] = "item",
	cell = "cell",
	["page3.mask"] = "mask3",
	["page2.mask"] = "mask2",
	page3 = "page3",
	pageview = "pageview",
	["page1.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["page2.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["page3.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["downPanel.list"] = {
		varname = "botList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("botDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("normal")
					local var_1_1 = arg_1_1:get("selected")
					local var_1_2

					if arg_1_3.select then
						var_1_0:hide()

						var_1_2 = var_1_1:show()
					else
						var_1_1:hide()

						var_1_2 = var_1_0:show()
					end

					var_1_2:get("txt"):text(string.format("%d" .. gLanguageCsv.firstRechargeGift, arg_1_3[1].pay))
					var_1_1:setTouchEnabled(false)
					bind.touch(arg_1_0, var_1_0, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2)
						}
					})
					adapt.setTextScaleWithWidth(var_1_2:get("txt"), nil, 150)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	btnLeft = {
		varname = "btnLeft",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onIndex")
			}
		}
	},
	btnRight = {
		varname = "btnRight",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onIndexAdd")
			}
		}
	}
}

function var_0_2.onCreate(arg_2_0, arg_2_1, arg_2_2)
	gGameModel.currday_dispatch:getIdlerOrigin("firstRecharge"):set(true)

	arg_2_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")

	local var_2_0 = arg_2_0.yyhuodongs:read()
	local var_2_1 = {}

	for iter_2_0, iter_2_1 in csvPairs(csv.yunying.yyhuodong) do
		if iter_2_1.independent == 1 and iter_2_1.type == var_0_0.firstRecharge then
			local var_2_2 = var_2_0[iter_2_0] or {}

			if var_2_2.flag ~= 2 then
				table.insert(var_2_1, {
					id = iter_2_0,
					name = iter_2_1.clientParam.name,
					state = var_2_2.flag,
					sortWeight = iter_2_1.sortWeight,
					rewards = iter_2_1.paramMap.award
				})
			end
		end
	end

	table.sort(var_2_1, function(arg_3_0, arg_3_1)
		if arg_3_0.sortWeight ~= arg_3_1.sortWeight then
			return arg_3_0.sortWeight < arg_3_1.sortWeight
		end

		return arg_3_0.id < arg_3_1.id
	end)
	arg_2_0.page1:retain()
	arg_2_0.page1:removeFromParent()
	arg_2_0.page2:retain()
	arg_2_0.page2:removeFromParent()
	arg_2_0.page3:retain()
	arg_2_0.page3:removeFromParent()

	arg_2_0.activityIDs = var_2_1
	arg_2_0.isInserPage = false
	arg_2_0.pages = {}
	arg_2_0.states = {
		idler.new(var_0_1.noReach),
		idler.new(var_0_1.noReach),
		idler.new(var_0_1.noReach),
		idler.new(var_0_1.noReach)
	}
	arg_2_0.activityID = arg_2_1

	idlereasy.when(arg_2_0.yyhuodongs, function(arg_4_0, arg_4_1)
		local var_4_0 = (arg_4_1[arg_2_0.activityID] or {}).stamps or {}

		arg_2_0.pageDatas = {}

		for iter_4_0, iter_4_1 in ipairs(arg_2_0.activityIDs) do
			arg_2_0.pageDatas[iter_4_1.id] = {}

			local var_4_1 = csv.yunying.yyhuodong[iter_4_1.id].huodongID

			for iter_4_2, iter_4_3 in orderCsvPairs(csv.yunying.firstcharge) do
				if iter_4_3.huodongID == var_4_1 then
					if not arg_2_0.pageDatas[iter_4_1.id][iter_4_3.page] then
						arg_2_0.pageDatas[iter_4_1.id][iter_4_3.page] = {}
					end

					iter_4_3.stamp = var_4_0[iter_4_2]
					iter_4_3.csvID = iter_4_2

					table.insert(arg_2_0.pageDatas[iter_4_1.id][iter_4_3.page], iter_4_3)
				end
			end
		end

		for iter_4_4, iter_4_5 in ipairs(arg_2_0.pageDatas[arg_2_1]) do
			local var_4_2 = arg_2_0["page" .. iter_4_4]

			if iter_4_5.state ~= 2 then
				if not arg_2_0.isInserPage then
					arg_2_0.pageview:addPage(var_4_2)

					arg_2_0.pages[iter_4_4] = var_4_2
				end

				var_4_2:get("placard"):texture(iter_4_5[1].resBg)
				var_4_2:show()
			else
				var_4_2:hide()
			end
		end

		arg_2_0.isInserPage = true

		arg_2_0:initRewards()
	end)

	arg_2_0.curPage = idler.new(arg_2_2 or 0)

	local var_2_3 = arg_2_0.pageview:getInnerContainer()
	local var_2_4 = var_2_3:size().width
	local var_2_5 = #arg_2_0.pageview:getPages()

	arg_2_0.isEnter = false

	arg_2_0.pageview:onScroll(function(arg_5_0)
		local var_5_0 = var_2_3:getPositionX()
		local var_5_1 = {}

		itertools.invoke({
			arg_2_0.mask1,
			arg_2_0.mask2,
			arg_2_0.mask3,
			arg_2_0.mask4
		}, "show")

		if arg_5_0.name == "AUTOSCROLL_ENDED" then
			for iter_5_0 = 1, var_2_5 do
				local var_5_2 = -var_2_4 * (iter_5_0 - 1)

				if math.abs(var_5_0 - var_5_2) <= 5 then
					arg_2_0.isEnter = true

					itertools.invoke({
						arg_2_0.mask1,
						arg_2_0.mask2,
						arg_2_0.mask3,
						arg_2_0.mask4
					}, "hide")

					if arg_2_0.curPage:read() ~= arg_2_0.pageview:getCurPageIndex() then
						arg_2_0.curPage:set(arg_2_0.pageview:getCurPageIndex())
					end

					return
				end
			end
		end

		if arg_2_0.isEnter or arg_5_0.name == "AUTOSCROLL_BEGAN" then
			arg_2_0.isEnter = false

			itertools.invoke({
				arg_2_0.mask1,
				arg_2_0.mask2,
				arg_2_0.mask3,
				arg_2_0.mask4
			}, "hide")
		end
	end)

	arg_2_0.botDatas = idlers.newWithMap(arg_2_0.pageDatas[arg_2_0.activityID])

	arg_2_0.curPage:addListener(function(arg_6_0, arg_6_1, arg_6_2)
		arg_2_0.btnRight:visible(arg_6_0 < var_2_5 - 1)
		arg_2_0.btnLeft:visible(arg_6_0 > 0)

		arg_2_0.botDatas:atproxy(arg_6_1 + 1).select = false
		arg_2_0.botDatas:atproxy(arg_6_0 + 1).select = true

		arg_2_0.pageview:scrollToPage(arg_6_0)
	end)
	Dialog.onCreate(arg_2_0, {
		blackType = 1
	})
end

local var_0_3 = 55
local var_0_4 = 200
local var_0_5 = 200
local var_0_6 = {
	{
		x = var_0_3,
		y = var_0_4
	},
	{
		x = var_0_3 + var_0_5,
		y = var_0_4
	},
	{
		x = var_0_3,
		y = var_0_4 + var_0_5
	},
	{
		x = var_0_3 + var_0_5,
		y = var_0_4 + var_0_5
	}
}

function var_0_2.initRewards(arg_7_0)
	local var_7_0 = 1

	for iter_7_0, iter_7_1 in pairs(arg_7_0.pageDatas[arg_7_0.activityID]) do
		local var_7_1 = arg_7_0["page" .. iter_7_0]:get("pannel" .. iter_7_0)

		for iter_7_2, iter_7_3 in ipairs(iter_7_1) do
			local var_7_2 = arg_7_0["page" .. iter_7_0]:get("pannel" .. iter_7_2)
			local var_7_3 = 1

			for iter_7_4, iter_7_5 in pairs(iter_7_3.award) do
				local var_7_4 = arg_7_0.cell:clone()

				var_7_4:addTo(var_7_2):xy(var_0_6[var_7_3].x, var_0_6[var_7_3].y):z(10)
				var_7_4:show()
				bind.extend(arg_7_0, var_7_4, {
					class = "icon_key",
					props = {
						data = {
							key = iter_7_4,
							num = iter_7_5
						},
						onNode = function(arg_8_0)
							arg_8_0:scale(1):z(1000)
						end
					}
				})

				var_7_3 = var_7_3 + 1
			end

			local var_7_5 = var_7_2:get("buyBtn")
			local var_7_6 = var_7_5:get("buyBtn")

			bind.touch(arg_7_0, var_7_6, {
				methods = {
					ended = function()
						arg_7_0:onBuy(var_7_5, iter_7_3)
					end
				}
			})

			local var_7_7 = var_7_5:get("label")

			var_7_6:setTouchEnabled(true)

			if not iter_7_3.stamp then
				local var_7_8 = gLanguageCsv.spaceReceive
				local var_7_9 = "hsl_gray"
				local var_7_10 = false

				if iter_7_2 == 1 then
					var_7_8 = gLanguageCsv.spaceBuy
					var_7_9 = "normal"
					var_7_10 = true
				end

				var_7_7:text(var_7_8)
				cache.setShader(var_7_6, false, var_7_9)
				var_7_6:setTouchEnabled(var_7_10)
			elseif iter_7_3.stamp == var_0_1.noReach then
				var_7_7:text(gLanguageCsv.notReach)
				var_7_6:setTouchEnabled(false)
				cache.setShader(var_7_6, false, "hsl_gray")
			elseif iter_7_3.stamp == var_0_1.canReceive then
				var_7_7:text(gLanguageCsv.spaceReceive)
				cache.setShader(var_7_6, false, "normal")
			else
				var_7_7:text(gLanguageCsv.received)
				var_7_6:setTouchEnabled(false)
				cache.setShader(var_7_6, false, "hsl_gray")
			end
		end
	end

	arg_7_0.clientBuyTimes = idler.new(true)
end

function var_0_2.onIndex(arg_10_0)
	local var_10_0

	if itertools.size(arg_10_0.pages) > 1 then
		var_10_0 = arg_10_0.pageview:getCurPageIndex() - 1
	else
		var_10_0 = next(arg_10_0.pages)
	end

	arg_10_0.curPage:set(var_10_0)
end

function var_0_2.onIndexAdd(arg_11_0)
	local var_11_0

	if itertools.size(arg_11_0.pages) > 1 then
		var_11_0 = arg_11_0.pageview:getCurPageIndex() + 1
	else
		var_11_0 = next(arg_11_0.pages)
	end

	arg_11_0.curPage:set(var_11_0)
end

function var_0_2.onBuy(arg_12_0, arg_12_1, arg_12_2)
	if not arg_12_2.stamp then
		local var_12_0 = csv.recharges[arg_12_2.rechargeID]

		gGameApp:payCustom(arg_12_0):params({
			djq = false,
			rechargeId = arg_12_2.rechargeID,
			yyID = arg_12_0.activityID,
			csvID = arg_12_2.csvID,
			name = var_12_0.name
		}):serverCb(function(arg_13_0)
			return
		end):doit(function(arg_14_0)
			if arg_14_0 and arg_14_0.ret then
				gGameUI:showTip(gLanguageCsv.firstChargeBuySuccess)
			end
		end)
	elseif arg_12_2.stamp == var_0_1.canReceive then
		gGameApp:requestServer("/game/yy/award/get", function(arg_15_0)
			gGameUI:showGainDisplay(arg_15_0)
			arg_12_1:get("buyBtn"):setTouchEnabled(false)
			cache.setShader(arg_12_1, false, "hsl_gray")
			arg_12_1:get("label"):text(gLanguageCsv.hasBuy)
		end, arg_12_0.activityID, arg_12_2.csvID)
	end
end

function var_0_2.onTabClick(arg_16_0, arg_16_1, arg_16_2)
	arg_16_0.curPage:set(arg_16_2 - 1)
end

return var_0_2
