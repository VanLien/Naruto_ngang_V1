local var_0_0 = class("RechargeView", cc.load("mvc").ViewBase)

local function var_0_1(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = rich.createWithWidth("#C0x57472E#" .. arg_1_0, arg_1_1, nil, arg_1_2):align(cc.p(0, 0), 0, 0)
	local var_1_1 = var_1_0:size().height

	return (ccui.Layout:create():size(arg_1_2, var_1_1):add(var_1_0))
end

local function var_0_2(arg_2_0)
	local var_2_0 = gGameModel.monthly_record:read("vip")

	return matchLanguage({
		"en"
	}) and arg_2_0 >= gCommonConfigCsv.rechargeVip and dataEasy.isUnlock(gUnlockCsv.vipDistinguished) or not matchLanguage({
		"en"
	}) and csvSize(gVipCsv[var_2_0].monthGift) >= 1
end

var_0_0.RESOURCE_FILENAME = "recharge.json"
var_0_0.RESOURCE_BINDING = {
	rechargePanel = "rechargePanel",
	["rechargePanel.item"] = "rechargeItem",
	["topPanel.maxPanel"] = "topMaxPanel",
	["privilegePanel.bg"] = "privilegePanelBg",
	["privilegePanel.panel"] = "privilegeItem",
	["privilegePanel.mask"] = "mask",
	["topPanel.normalPanel"] = "topNormalPanel",
	["topPanel.barBg"] = "barBg",
	privilegePanel = "privilegePanel",
	["topPanel.btn"] = {
		varname = "topPanelBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChangeClick")
			}
		}
	},
	["topPanel.btnVip"] = {
		varname = "btnVip",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onVipClick")
				}
			},
			{
				event = "visible",
				idler = bindHelper.self("vipSum"),
				method = function(arg_3_0)
					return var_0_2(arg_3_0)
				end
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "onHonourableVip",
					onNode = function(arg_4_0)
						arg_4_0:xy(170, 170)
					end
				}
			}
		}
	},
	["topPanel.btn.label"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 1,
						color = ui.NEWCOLORS.OUTLINE.YELLOW1
					}
				}
			},
			{
				event = "text",
				idler = bindHelper.self("selectRecharge"),
				method = function(arg_5_0)
					if arg_5_0 then
						return gLanguageCsv.spacePrivilege
					end

					return gLanguageCsv.spaceRecharge
				end
			}
		}
	},
	["topPanel.bar"] = {
		varname = "topBar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				data = bindHelper.self("expProgress")
			}
		}
	},
	["topPanel.barNum"] = {
		varname = "barNum",
		binds = {
			{
				event = "text",
				idler = bindHelper.self("expProgressNum")
			},
			{
				event = "effect",
				data = {
					outline = {
						size = 2,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			}
		}
	},
	["rechargePanel.list"] = {
		varname = "rechargeList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				backupCached = false,
				data = bindHelper.self("rechargeDatas"),
				item = bindHelper.self("rechargeItem"),
				itemAction = {
					isAction = true
				},
				dataOrderCmp = function(arg_6_0, arg_6_1)
					if arg_6_0.sortValue ~= arg_6_1.sortValue then
						return arg_6_0.sortValue > arg_6_1.sortValue
					end

					return arg_6_0.csvId < arg_6_1.csvId
				end,
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					local var_7_0 = arg_7_3.cfg

					arg_7_1:get("icon"):texture(var_7_0.icon)
					arg_7_1:get("price"):text(string.format(gLanguageCsv.symbolMoney, var_7_0.rmbDisplay))
					text.addEffect(arg_7_1:get("price"), {
						outline = {
							size = 1,
							color = ui.NEWCOLORS.OUTLINE.YELLOW1
						}
					})
					arg_7_1:get("gain"):text(var_7_0.rmb)
					text.addEffect(arg_7_1:get("gain"), {
						outline = {
							size = 1,
							color = ui.NEWCOLORS.OUTLINE.WHITE1
						}
					})
					arg_7_1:get("extraInfo"):text(string.format(gLanguageCsv.rechargeFirstExtra, var_7_0.firstPresent))
					arg_7_1:get("extraInfo"):visible(arg_7_3.rechargeBuyTimes == 0 and var_7_0.firstPresent ~= 0)
					arg_7_1:get("doublePanel"):visible(arg_7_3.rechargeBuyTimes == 0 and var_7_0.firstPresent ~= 0)
					bind.touch(arg_7_0, arg_7_1, {
						clicksafe = true,
						methods = {
							ended = functools.partial(arg_7_0.clickCell, arg_7_2, arg_7_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onRechargeClick")
			}
		}
	},
	["privilegePanel.pageView"] = {
		varname = "pageView",
		binds = {
			event = "extend",
			class = "pageview",
			props = {
				data = bindHelper.self("privilegeDatas"),
				item = bindHelper.self("privilegeItem"),
				onItem = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					idlereasy.if_(arg_8_3.show, function()
						local var_9_0 = arg_8_1:get("list")
						local var_9_1 = var_9_0:size()

						var_9_0:setScrollBarEnabled(false)
						var_9_0:setItemsMargin(15)
						var_9_0:removeAllChildren()

						for iter_9_0 = 1, math.huge do
							local var_9_2 = arg_8_3.vipDescCfg["desc" .. iter_9_0]

							if var_9_2 == nil or var_9_2 == "" then
								break
							end

							local var_9_3 = var_0_1(var_9_2, 40, var_9_1.width)

							var_9_0:pushBackCustomItem(var_9_3)
						end

						var_9_0:adaptTouchEnabled()
						arg_8_1:get("name"):text(string.format("V%d %s", arg_8_2, gLanguageCsv.privilege))
						uiEasy.createItemsToList(arg_8_0, arg_8_1:get("propList"), arg_8_3.vipCfg.gift, {
							scale = 1,
							margin = 0
						})
						arg_8_1:get("oldPrice"):text(arg_8_3.vipCfg.oldPrice)
						arg_8_1:get("line"):size(100 + arg_8_1:get("oldPrice"):size().width, arg_8_1:get("line"):size().height)
						arg_8_1:get("price"):text(arg_8_3.vipCfg.newPrice)
						bind.touch(arg_8_0, arg_8_1:get("btn"), {
							methods = {
								ended = functools.partial(arg_8_0.clickCell, arg_8_2, arg_8_3)
							}
						})
						idlereasy.any({
							arg_8_3.hasBuy,
							arg_8_3.vipLevelEnough,
							arg_8_3.roleLevelEnough
						}, function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
							local var_10_0 = arg_8_1:get("btn")
							local var_10_1 = var_10_0:get("label")

							cache.setShader(var_10_0, false, "hsl_gray")
							text.deleteAllEffect(var_10_1)

							if arg_10_1 then
								var_10_1:text(gLanguageCsv.hasBuy)
								var_10_0:setTouchEnabled(false)
							else
								var_10_1:text(gLanguageCsv.spaceBuy)
								var_10_0:setTouchEnabled(true)

								if arg_10_2 and not arg_10_3 then
									var_10_1:text(string.format(gLanguageCsv.lvnCanBuy, arg_8_3.vipCfg.giftLevelLimit))
								elseif arg_10_2 then
									cache.setShader(var_10_0, false, "normal")
									text.addEffect(var_10_1, {
										outline = {
											size = 1,
											color = ui.NEWCOLORS.OUTLINE.YELLOW1
										}
									})
								end
							end
						end):anonyOnly(arg_8_0, arg_8_2)
					end)
				end,
				onAfterBuild = function(arg_11_0)
					arg_11_0.afterBuild()
				end
			},
			handlers = {
				clickCell = bindHelper.self("onPrivilegeGiftBuy"),
				afterBuild = bindHelper.self("onPrivilegeAfterBuild")
			}
		}
	},
	["privilegePanel.leftBtn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPrivilegeLeftBtnClick")
			}
		}
	},
	["privilegePanel.rightBtn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPrivilegeRightBtnClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_12_0, arg_12_1)
	arg_12_0:enableSchedule()

	arg_12_1 = arg_12_1 or {}

	gGameModel.currday_dispatch:getIdlerOrigin("vipGift"):set(true)
	arg_12_0:initModel()
	gGameUI.topuiManager:createView("recharge", arg_12_0, {
		onClose = arg_12_0:createHandler("onClose")
	}):init({
		title = "common/txt/txt_bt_tequan.png"
	})
	arg_12_0.pageView:setTouchEnabled(false)
	arg_12_0.privilegePanel:get("panel.list"):setScrollBarEnabled(false)
	arg_12_0.privilegePanel:get("panel.propList"):setScrollBarEnabled(false)
	arg_12_0:setBarSize()

	arg_12_0.selectRecharge = idler.new(not arg_12_1.showPrivilege and not arg_12_1.privilegeIndex)

	local var_12_0 = {}

	for iter_12_0, iter_12_1 in orderCsvPairs(csv.recharges) do
		if matchLanguage(iter_12_1.languages) and iter_12_1.type == 1 then
			var_12_0[iter_12_0] = {
				rechargeBuyTimes = 0,
				csvId = iter_12_0,
				cfg = iter_12_1
			}
		end
	end

	arg_12_0.rechargeDatas = idlers.newWithMap(var_12_0)

	idlereasy.when(arg_12_0.recharges, function(arg_13_0, arg_13_1)
		for iter_13_0, iter_13_1 in arg_12_0.rechargeDatas:pairs() do
			local var_13_0 = iter_13_1:proxy()

			var_13_0.rechargeBuyTimes = arg_12_0:getRechargeBuyTimes(iter_13_0)
			var_13_0.sortValue = var_13_0.cfg.sortValue
		end

		if arg_12_0.rechargeList.sortItems then
			arg_12_0.rechargeList:sortItems()
		end
	end)

	arg_12_0.expProgress = idler.new(0)
	arg_12_0.expProgressNum = idler.new("")

	if arg_12_1.showPrivilege or arg_12_1.privilegeIndex then
		local var_12_1 = arg_12_0.vipGift:read()
		local var_12_2 = arg_12_0.vipLevel:read()
		local var_12_3 = math.min(var_12_2 + 1, game.VIP_LIMIT)

		for iter_12_2 = var_12_2, 1, -1 do
			if var_12_1[iter_12_2] ~= 0 then
				var_12_3 = iter_12_2

				break
			end
		end

		arg_12_0.showPrivilegeIndex = var_12_3
	else
		arg_12_0.showPrivilegeIndex = arg_12_0.vipLevel:read()
	end

	arg_12_0.showPrivilegeIndex = cc.clampf(arg_12_0.showPrivilegeIndex, 1, game.VIP_LIMIT)
	arg_12_0.privilegeIndex = idler.new(arg_12_0.showPrivilegeIndex)

	local var_12_4 = {}

	for iter_12_3 = 1, game.VIP_LIMIT do
		var_12_4[iter_12_3] = {
			show = idler.new(iter_12_3 == arg_12_0.showPrivilegeIndex),
			vipDescCfg = csv.vip_desc[iter_12_3 + 1],
			vipCfg = gVipCsv[iter_12_3],
			hasBuy = idler.new(false),
			vipLevelEnough = idler.new(false),
			roleLevelEnough = idler.new(false)
		}
	end

	arg_12_0.privilegeDatas = var_12_4

	idlereasy.any({
		arg_12_0.vipLevel,
		arg_12_0.vipSum
	}, function(arg_14_0, arg_14_1, arg_14_2)
		local var_14_0 = math.min(arg_14_1, game.VIP_LIMIT)
		local var_14_1 = var_14_0

		if var_14_0 == game.VIP_LIMIT then
			arg_12_0.topNormalPanel:hide()
			arg_12_0.topMaxPanel:show()
			arg_12_0.topMaxPanel:get("vipIcon"):texture(ui.VIP_ICON[var_14_0])
		else
			var_14_1 = var_14_0 + 1

			arg_12_0.topMaxPanel:hide()
			arg_12_0.topNormalPanel:show()

			local var_14_2 = arg_12_0.topNormalPanel:multiget("label1", "vipIcon1", "label2", "diamondIcon", "num", "label3", "vipIcon2")

			var_14_2.num:text(gVipCsv[var_14_1].upSum - arg_14_2)
			var_14_2.vipIcon2:texture(ui.VIP_ICON[var_14_1])

			if var_14_0 < 1 then
				itertools.invoke({
					var_14_2.label1,
					var_14_2.vipIcon1
				}, "hide")
				var_14_2.label2:x(var_14_2.label1:x())
				adapt.oneLinePos(var_14_2.label2, {
					var_14_2.diamondIcon,
					var_14_2.num,
					var_14_2.label3,
					var_14_2.vipIcon2
				}, cc.p(10, 0))
			else
				itertools.invoke({
					var_14_2.label1,
					var_14_2.vipIcon1
				}, "show")
				var_14_2.vipIcon1:texture(ui.VIP_ICON[var_14_0])
				adapt.oneLinePos(var_14_2.label1, {
					var_14_2.vipIcon1,
					var_14_2.label2,
					var_14_2.diamondIcon,
					var_14_2.num,
					var_14_2.label3,
					var_14_2.vipIcon2
				}, cc.p(10, 0))
			end

			text.addEffect(arg_12_0.topMaxPanel:get("label"), {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.WHITE2
				}
			})
			text.addEffect(var_14_2.label1, {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.WHITE2
				}
			})
			text.addEffect(var_14_2.label2, {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.WHITE2
				}
			})
			text.addEffect(var_14_2.label3, {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.WHITE2
				}
			})
		end

		if var_0_2(arg_14_2) and not userDefault.getForeverLocalKey("rechargeVip", false) and arg_12_0:isShowVipGift() then
			arg_12_0:onVipClick()
			userDefault.setForeverLocalKey("rechargeVip", true)
		end

		arg_12_0:setBarSize()
		arg_12_0.expProgress:set(math.min(100 * arg_14_2 / gVipCsv[var_14_1].upSum, 100))
		arg_12_0.expProgressNum:set(string.format("%d/%d", arg_14_2, gVipCsv[var_14_1].upSum))
	end)
	idlereasy.when(arg_12_0.vipLevel, function(arg_15_0, arg_15_1)
		for iter_15_0, iter_15_1 in ipairs(arg_12_0.privilegeDatas) do
			iter_15_1.vipLevelEnough:set(iter_15_0 <= arg_15_1)
		end
	end)
	idlereasy.when(arg_12_0.roleLevel, function(arg_16_0, arg_16_1)
		for iter_16_0, iter_16_1 in ipairs(arg_12_0.privilegeDatas) do
			iter_16_1.roleLevelEnough:set(arg_16_1 >= iter_16_1.vipCfg.giftLevelLimit)
		end
	end)
	idlereasy.when(arg_12_0.vipGift, function(arg_17_0, arg_17_1)
		for iter_17_0, iter_17_1 in pairs(arg_17_1) do
			local var_17_0 = arg_12_0.privilegeDatas[iter_17_0]

			if var_17_0 then
				var_17_0.hasBuy:set(iter_17_1 == 0 and true or false)
			end
		end
	end)
	idlereasy.when(arg_12_0.selectRecharge, function(arg_18_0, arg_18_1)
		if arg_18_1 == true then
			gGameUI.topuiManager:updateTitle("common/txt/txt_bt_chongzhi.png")
			arg_12_0.rechargePanel:show()
			arg_12_0.privilegePanel:hide()
		else
			gGameUI.topuiManager:updateTitle("common/txt/txt_bt_tequan.png")
			arg_12_0.rechargePanel:hide()
			arg_12_0.privilegePanel:show()
		end
	end)
	idlereasy.when(arg_12_0.privilegeIndex, function(arg_19_0, arg_19_1)
		arg_19_1 = cc.clampf(arg_19_1, 1, game.VIP_LIMIT)

		arg_12_0.privilegePanel:get("leftBtn"):visible(arg_19_1 > 1)
		arg_12_0.privilegePanel:get("rightBtn"):visible(arg_19_1 < game.VIP_LIMIT)
		arg_12_0:showPrivilegePage(arg_19_1)
		arg_12_0.pageView:setCurrentPageIndex(arg_19_1 - 1)
	end)
	arg_12_0:initPrivilegeListener()
	widget.addAnimationByKey(arg_12_0.btnVip, "effect/guizu.skel", "efc1", "effect_loop", 6):alignCenter(arg_12_0.btnVip:size())
	arg_12_0.btnVip:setEnabled(arg_12_0:isShowVipGift())
end

function var_0_0.initModel(arg_20_0)
	arg_20_0.recharges = gGameModel.role:getIdler("recharges")
	arg_20_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_20_0.vipSum = gGameModel.role:getIdler("vip_sum")
	arg_20_0.vipGift = gGameModel.role:getIdler("vip_gift")
	arg_20_0.rmb = gGameModel.role:getIdler("rmb")
	arg_20_0.roleLevel = gGameModel.role:getIdler("level")
end

function var_0_0.initPrivilegeListener(arg_21_0)
	uiEasy.addTouchOneByOne(arg_21_0.mask, {
		ended = function(arg_22_0, arg_22_1, arg_22_2)
			if not arg_21_0.selectRecharge:read() and math.abs(arg_22_1) > 100 and math.abs(arg_22_1) > math.abs(arg_22_2) then
				local var_22_0 = arg_22_1 > 0 and -1 or 1

				arg_21_0.privilegeIndex:modify(function(arg_23_0)
					arg_23_0 = cc.clampf(arg_23_0 + var_22_0, 1, game.VIP_LIMIT)

					return true, arg_23_0
				end)
			end
		end
	})
end

function var_0_0.getRechargeBuyTimes(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0.recharges:read()[arg_24_1]

	if var_24_0 then
		if (var_24_0.reset or 0) > 0 then
			return 0
		end

		return var_24_0.cnt
	end

	return 0
end

function var_0_0.onPrivilegeAfterBuild(arg_25_0, arg_25_1)
	arg_25_1:setCurrentPageIndex(arg_25_0.showPrivilegeIndex - 1)
end

function var_0_0.onChangeClick(arg_26_0)
	arg_26_0.selectRecharge:modify(function(arg_27_0)
		return true, not arg_27_0
	end)
end

function var_0_0.onRechargeClick(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	gGameApp:payCustom(arg_28_0):params({
		yyID = 0,
		rechargeId = arg_28_2,
		csvID = arg_28_3.csvId,
		name = arg_28_3.cfg.name,
		buyTimes = arg_28_3.rechargeBuyTimes
	}):wait(5):doit(function(arg_29_0)
		if arg_29_0 and arg_29_0.ret then
			gGameUI:showGainDisplay(arg_29_0.view, {
				raw = false
			})
		end
	end)
end

function var_0_0.onPrivilegeGiftBuy(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	if not arg_30_3.vipLevelEnough:read() then
		gGameUI:showTip(gLanguageCsv.vipNotEnough)
	elseif not arg_30_3.roleLevelEnough:read() then
		gGameUI:showTip(string.format(gLanguageCsv.lvnCanBuy, arg_30_3.vipCfg.giftLevelLimit))
	else
		local function var_30_0()
			if arg_30_0.rmb:read() < arg_30_3.vipCfg.newPrice then
				gGameUI:showTip(gLanguageCsv.noDiamondGoRecharge)
			else
				gGameApp:requestServer("/game/role/vipgift/buy", function(arg_32_0)
					gGameUI:showGainDisplay(arg_32_0)
				end, arg_30_2)
			end
		end

		if matchLanguage({
			"kr"
		}) then
			dataEasy.sureUsingDiamonds(var_30_0, arg_30_3.vipCfg.newPrice, nil, string.format(gLanguageCsv.sureBuyVipGift, arg_30_2))
		else
			gGameUI:showDialog({
				clearFast = true,
				btnType = 2,
				content = string.format(gLanguageCsv.sureBuyVipGift, arg_30_2),
				cb = var_30_0,
				dialogParams = {
					clickClose = false
				}
			})
		end
	end
end

function var_0_0.onPrivilegeLeftBtnClick(arg_33_0)
	arg_33_0.privilegeIndex:modify(function(arg_34_0)
		return true, arg_34_0 - 1
	end)
end

function var_0_0.onPrivilegeRightBtnClick(arg_35_0)
	arg_35_0.privilegeIndex:modify(function(arg_36_0)
		return true, arg_36_0 + 1
	end)
end

function var_0_0.showPrivilegePage(arg_37_0, arg_37_1)
	if arg_37_1 >= 1 and arg_37_1 <= game.VIP_LIMIT then
		arg_37_0.privilegeDatas[arg_37_1].show:set(true)

		return true
	end
end

function var_0_0.isShowVipGift(arg_38_0)
	local var_38_0 = gGameModel.monthly_record:read("vip")

	return matchLanguage({
		"cn"
	}) or csvSize(gVipCsv[var_38_0].monthGift) >= 1
end

function var_0_0.onVipClick(arg_39_0)
	if matchLanguage({
		"cn"
	}) then
		gGameUI:stackUI("city.recharge_vip")
	else
		gGameUI:stackUI("city.vip_distinguished")
	end
end

function var_0_0.setBarSize(arg_40_0)
	local var_40_0 = arg_40_0.barBg:size().width
	local var_40_1 = arg_40_0.vipSum:read()

	if var_40_1 >= gCommonConfigCsv.rechargeVip and var_0_2(var_40_1) then
		-- block empty
	end

	local var_40_2 = arg_40_0.barBg:x() + var_40_0

	arg_40_0.barBg:width(var_40_0)
	arg_40_0.topBar:setContentSize(var_40_0, arg_40_0.topBar:height())
	arg_40_0.topBar:x(var_40_2)
	arg_40_0.barNum:x(var_40_2)
end

return var_0_0
