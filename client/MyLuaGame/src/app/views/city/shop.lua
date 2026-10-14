local var_0_0 = require("app.views.city.activity.month_card")
local var_0_1 = {
	9,
	12,
	18,
	21
}
local var_0_2 = 16
local var_0_3 = 4
local var_0_4 = {
	"/game/fixshop/buy",
	"/game/union/shop/buy",
	"/game/frag/shop/buy",
	"/game/pw/shop/buy",
	"/game/explorer/shop/buy",
	"/game/random_tower/shop/buy",
	"/game/craft/shop/buy",
	"/game/equipshop/buy",
	"/game/union/fight/shop/buy",
	"/game/cross/craft/shop/buy",
	"/game/cross/arena/shop/buy",
	"/game/fishing/shop/buy",
	"/game/cross/online/shop/buy",
	nil,
	"/game/cross/mine/shop",
	"/game/hunting/shop",
	nil,
	"/game/totem/shop/buy"
}
local var_0_5 = {
	"/game/fixshop/refresh",
	"/game/union/shop/refresh",
	"/game/frag/shop/refresh",
	nil,
	"/game/explorer/shop/refresh",
	"/game/random_tower/shop/refresh",
	nil,
	nil,
	nil,
	nil,
	nil,
	"/game/fishing/shop/refresh"
}
local var_0_6 = gShopType
local var_0_7 = game.SHOP_GET_PROTOL
local var_0_8 = game.SHOP_INIT
local var_0_9 = {
	[3] = "fragShopRefreshLimit",
	[5] = "explorerShopRefreshLimit",
	[12] = "fishingShopRefreshLimit"
}
local var_0_10 = {
	[3] = "fragShopRefreshLimit"
}

local function var_0_11(arg_1_0)
	local var_1_0 = {
		var_0_8.PVP_SHOP,
		var_0_8.CRAFT_SHOP,
		var_0_8.UNION_FIGHT_SHOP,
		var_0_8.CROSS_CRAFT_SHOP,
		var_0_8.CROSS_ARENA_SHOP,
		var_0_8.ONLINE_FIGHT_SHOP,
		var_0_8.CROSS_MINE_SHOP,
		var_0_8.HUNTING_SHOP
	}

	return itertools.include(var_1_0, arg_1_0)
end

local function var_0_12(arg_2_0, ...)
	if var_0_11(arg_2_0) then
		local var_2_0 = {
			...
		}

		return var_2_0[1], var_2_0[4]
	else
		return ...
	end
end

local function var_0_13(arg_3_0, arg_3_1, arg_3_2)
	arg_3_1:removeChildByName("_lock_res_")

	if not arg_3_0 then
		return
	end

	local var_3_0 = arg_3_1:size()
	local var_3_1 = cc.p(var_3_0.width * 0.5, var_3_0.height * 0.5)

	arg_3_2 = arg_3_2 or {}

	return (ccui.ImageView:create(arg_3_2.res or "common/btn/btn_lock1.png"):xy(arg_3_2.pos or var_3_1):scale(arg_3_2.scale or 0.8):addTo(arg_3_1, arg_3_2.zOrder or 10, "_lock_res_"))
end

local function var_0_14(arg_4_0)
	local var_4_0 = gGameModel.role:read("level")

	return gGameModel.role:read("vip_level") >= arg_4_0.vipStart and var_4_0 >= arg_4_0.levelRange[1] and var_4_0 <= arg_4_0.levelRange[2] or arg_4_0.showUnable
end

local function var_0_15(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = gGameModel.role:read("level")
	local var_5_1 = gGameModel.role:read("vip_level")
	local var_5_2 = {}

	for iter_5_0, iter_5_1 in orderCsvPairs(arg_5_0) do
		local var_5_3 = var_0_14(iter_5_1)

		if matchLanguage(iter_5_1.languages) and var_5_3 then
			local var_5_4, var_5_5 = csvNext(iter_5_1.itemMap)

			table.insert(var_5_2, {
				csvID = iter_5_0,
				type = arg_5_1,
				level = var_5_0,
				vip = var_5_1,
				itemID = var_5_4,
				count = var_5_5
			})
		end

		if arg_5_2 and iter_5_1.beginDate ~= 0 and iter_5_1.endDate ~= 0 then
			arg_5_2[iter_5_0] = iter_5_1
		end
	end

	return var_5_2
end

local function var_0_16(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_1:get("list")
	local var_6_1 = arg_6_1:get("normal")
	local var_6_2 = arg_6_1:get("selected")
	local var_6_3 = 120

	if arg_6_3.select == true then
		local var_6_4 = arg_6_0.childItem:size().width
		local var_6_5 = arg_6_0.childItem:size().height * #arg_6_3.data

		arg_6_1:size(arg_6_1:size().width, var_6_5 + var_6_3)
		var_6_1:hide()
		var_6_2:show()
		var_6_2:y(var_6_5 + var_6_3 / 2)
		var_6_0:size(var_6_4, var_6_5)
		var_6_0:anchorPoint(cc.p(0, 1))
		var_6_0:y(var_6_5)
		bind.extend(arg_6_0, var_6_0, {
			event = "extend",
			class = "listview",
			props = {
				data = arg_6_3.data,
				item = arg_6_0.childItem,
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					idlereasy.when(arg_6_0.showTab, function(arg_8_0, arg_8_1)
						if not tolua.isnull(arg_7_1) then
							local var_8_0 = arg_7_1:get("normal")
							local var_8_1 = arg_7_1:get("selected")
							local var_8_2

							if arg_7_3.tabIndex == arg_8_1 then
								var_8_0:hide()

								var_8_2 = var_8_1:show()
							else
								var_8_1:hide()

								var_8_2 = var_8_0:show()
							end

							var_8_2:scale(1)
							var_8_2:get("txt"):setFontSize(arg_7_3.fontSize or 50)
							var_8_2:get("txt"):text(arg_7_3.name)
							var_8_2:get("txt"):getVirtualRenderer():setLineSpacing(-10)
							var_8_1:setTouchEnabled(false)
							var_0_13(arg_7_3.isLocked and not arg_7_3.select, var_8_0, {
								pos = cc.p(300, 105)
							})
							bind.touch(arg_7_0, var_8_0, {
								methods = {
									ended = functools.partial(arg_6_0.clickChildCell, arg_7_3.tabIndex, arg_7_3)
								}
							})
						end
					end):anonyOnly(arg_6_0, "childItem" .. arg_7_3.tabIndex)
				end
			}
		})
	else
		var_6_0:hide()
		arg_6_1:size(arg_6_1:size().width, 160)
		var_6_1:show()
		var_6_1:y(80)
		var_6_2:hide()
	end
end

local function var_0_17(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = {}

	if dataEasy.isUnlock(gUnlockCsv.fragShopMaxStar) then
		var_9_0.maxStar = true
	end

	arg_9_1:get("limit"):hide()

	if arg_9_3.isLimit and (arg_9_3.type == var_0_8.EQUIP_SHOP or arg_9_3.type == var_0_8.TOTEM_SHOP) then
		arg_9_1:get("limit"):show()

		if not matchLanguage({
			"cn",
			"tw"
		}) then
			arg_9_1:get("limit.textNote"):hide()
			arg_9_1:get("limit.imgBg"):loadTexture("common/icon/sign_purple_en.png")
		end
	end

	local var_9_1 = var_0_0.getPrivilegeAddition("fixShopDiscount") or 0

	arg_9_1:get("discount"):hide()

	if arg_9_3.type == 1 and var_9_1 ~= 0 then
		arg_9_1:get("discount"):show()

		if matchLanguage({
			"cn",
			"tw"
		}) then
			arg_9_1:get("discount.textNote"):text(string.format(gLanguageCsv.discount, (1 - var_9_1) * 10))
		else
			arg_9_1:get("discount.textNote"):text(string.format(gLanguageCsv.discount, tostring(var_9_1 * 100)))
			arg_9_1:get("discount.textNote"):scale(0.8)
		end
	end

	local var_9_2 = arg_9_1:multiget("name", "icon", "num", "recoverPanel", "btnBuy", "maskPanel")
	local var_9_3 = var_9_2.maskPanel:multiget("lockTxt", "lock", "lockCondition", "txt")

	itertools.invoke({
		var_9_3.lockTxt,
		var_9_3.lock,
		var_9_3.lockCondition
	}, "hide")

	local var_9_4 = var_0_6[arg_9_3.type][arg_9_3.csvID]
	local var_9_5 = var_9_2.btnBuy:multiget("txt", "icon")
	local var_9_6 = var_9_4.limitType ~= 0
	local var_9_7 = var_9_4.limitTimes

	var_9_2.recoverPanel:get("recover"):visible(false)

	arg_9_3.shopLimit = arg_9_3.shopLimit or {}

	local var_9_8 = dataEasy.getCfgByKey(arg_9_3.itemID)

	var_9_2.icon:hide()

	if var_9_8 then
		bind.extend(arg_9_0, arg_9_1, {
			class = "icon_key",
			props = {
				simpleShow = true,
				data = {
					key = arg_9_3.itemID
				},
				specialKey = var_9_0,
				onNode = function(arg_10_0)
					arg_10_0:setTouchEnabled(false)
					arg_10_0:xy(var_9_2.icon:xy()):scale(1.5):z(3)
				end
			}
		})

		local var_9_9 = uiEasy.setIconName(arg_9_3.itemID, nil, {
			node = var_9_2.name
		})
		local var_9_10 = arg_9_1:width() - 150

		if matchLanguage({
			"en",
			"kr"
		}) then
			adapt.setTextAdaptWithSize(var_9_2.name, {
				margin = -5,
				vertical = "center",
				horizontal = "center",
				maxLine = 2,
				size = cc.size(arg_9_1:width() - 150, 120)
			})
		else
			adapt.setTextScaleWithWidth(var_9_2.name, var_9_2.name:text(), arg_9_1:width() - 150)
		end

		local var_9_11 = var_9_4.itemCount

		if not var_9_11 or var_9_11 == 0 then
			var_9_11 = arg_9_3.count
		end

		var_9_2.num:text("x" .. mathEasy.getShortNumber(var_9_11))

		local var_9_12, var_9_13 = csvNext(var_9_4.costMap)
		local var_9_14 = dataEasy.getCfgByKey(var_9_12)

		var_9_5.icon:texture(dataEasy.getIconResByKey(var_9_12))

		var_9_13 = arg_9_3.type == 1 and math.ceil((1 - var_9_1) * tonumber(var_9_13)) or var_9_13

		var_9_5.txt:text(var_9_13)

		local var_9_15 = var_9_5.icon:getBoundingBox()
		local var_9_16 = var_9_5.txt:size()

		var_9_5.icon:x(var_9_2.btnBuy:width() / 2 - var_9_15.width - var_9_16.width / 2 + 20)
		adapt.oneLinePos(var_9_5.icon, var_9_5.txt, cc.p(10, 0), "left")
	end

	local var_9_17 = arg_9_3.lockShow
	local var_9_18

	if not var_9_17 and var_9_4 and var_9_4.fishingLevelRange then
		local var_9_19 = gGameModel.fishing:read("level")

		if var_9_19 < var_9_4.fishingLevelRange[1] or var_9_19 > var_9_4.fishingLevelRange[2] then
			var_9_17 = true
			var_9_18 = gLanguageCsv.angling .. string.format(gLanguageCsv.reachLevelCanBuy, var_9_4.fishingLevelRange[1])
		end
	end

	if not var_9_17 and arg_9_3.type == game.SHOP_INIT.ONLINE_FIGHT_SHOP and var_9_4 and var_9_4.topScore then
		local var_9_20 = gGameModel.role:read("cross_online_fight_info")

		if math.max(var_9_20.unlimited_top_score, var_9_20.limited_top_score) < var_9_4.topScore then
			var_9_17 = true
			var_9_18 = string.format(gLanguageCsv.onlineFightShopCanBuy, var_9_4.topScore)
		end
	end

	itertools.invoke({
		var_9_3.lockTxt,
		var_9_3.lock,
		var_9_3.lockCondition
	}, "visible", var_9_17 == true)

	if var_9_17 then
		var_9_2.maskPanel:show()
		var_9_3.txt:hide()
		var_9_2.btnBuy:hide()

		if var_9_18 then
			if matchLanguage({
				"en"
			}) then
				var_9_3.lockCondition:anchorPoint(0.5, 0.4)
			end

			var_9_3.lockCondition:text(var_9_18)
		end

		if arg_9_3.level < var_9_4.levelRange[1] or arg_9_3.level > var_9_4.levelRange[2] then
			var_9_3.lockCondition:text(string.format(gLanguageCsv.reachLevelCanBuy, var_9_4.levelRange[1]))
		end

		if arg_9_3.vip < var_9_4.vipStart then
			var_9_3.lockCondition:text(string.format(gLanguageCsv.reachVipLevelCanBuy, var_9_4.vipStart))
		end

		return
	end

	text.addEffect(var_9_5.txt, {
		outline = {
			size = 4,
			color = ui.NEWCOLORS.OUTLINE.BLACK
		}
	})

	if var_9_6 then
		var_9_2.maskPanel:hide()
		var_9_2.recoverPanel:show()

		if var_9_2.recoverPanel:get("emm") then
			var_9_2.recoverPanel:get("emm"):removeFromParent()
		end

		local var_9_21
		local var_9_22

		if var_9_4.limitType == 1 then
			var_9_22 = var_9_7

			if tonumber(arg_9_3.shopLimit[2]) == tonumber(time.getTodayStr()) then
				var_9_22 = math.max(var_9_7 - (arg_9_3.shopLimit[1] or 0), 0)
			end

			var_9_21 = string.format(gLanguageCsv.currDayBuyLimit, var_9_22, var_9_7)
		elseif var_9_4.limitType == 2 then
			var_9_22 = var_9_7

			if tonumber(arg_9_3.shopLimit[2]) == tonumber(time.getWeekStrInClock()) then
				var_9_22 = math.max(var_9_7 - (arg_9_3.shopLimit[1] or 0), 0)
			end

			var_9_21 = string.format(gLanguageCsv.currWeekBuyLimit, var_9_22, var_9_7)
		elseif var_9_4.limitType == 3 then
			var_9_22 = var_9_7

			if tonumber(arg_9_3.shopLimit[2]) == tonumber(time.getMonthStrInClock()) then
				var_9_22 = math.max(var_9_7 - (arg_9_3.shopLimit[1] or 0), 0)
			end

			var_9_21 = string.format(gLanguageCsv.currMonthBuyLimit, var_9_22, var_9_7)
		else
			var_9_22 = math.max(arg_9_3.shopLimit[1] and var_9_7 - arg_9_3.shopLimit[1] or var_9_7, 0)
			var_9_21 = string.format(gLanguageCsv.foreverBuyLimit, var_9_22, var_9_7)
		end

		var_9_2.maskPanel:visible(var_9_22 == 0)

		local var_9_23 = rich.createByStr(var_9_21, 40)

		var_9_23:formatText()
		var_9_23:addTo(var_9_2.recoverPanel, 10, "emm"):alignCenter(var_9_2.recoverPanel:size()):y(328)
		arg_9_1:setTouchEnabled(true)
		cache.setShader(var_9_2.btnBuy, false, var_9_22 == 0 and "hsl_gray" or "normal")
		cache.setShader(var_9_5.icon, false, var_9_22 == 0 and "hsl_gray" or "normal")

		if var_9_22 == 0 then
			text.deleteAllEffect(var_9_5.txt)
			text.addEffect(var_9_5.txt, {
				color = ui.COLORS.DISABLED.WHITE
			})
		else
			text.addEffect(var_9_5.txt, {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			})
		end
	elseif var_9_4.exchangeLimit then
		var_9_2.maskPanel:hide()

		if var_9_4.exchangeLimit == -1 then
			var_9_2.recoverPanel:hide()
		else
			if var_9_2.recoverPanel:get("emm") then
				var_9_2.recoverPanel:get("emm"):removeFromParent()
			end

			local var_9_24 = arg_9_3.buyTimes or 0
			local var_9_25 = arg_9_3.recoverTimes or var_9_4.exchangeLimit - var_9_24
			local var_9_26 = cc.clampf(var_9_25, 0, var_9_4.exchangeLimit)

			var_9_2.recoverPanel:show()

			local var_9_27 = var_9_25 < var_9_4.exchangeLimit

			var_9_2.recoverPanel:get("recover"):visible(var_9_27)

			local var_9_28 = var_9_26 >= 1 and "#C0x60C456#" or "#C0xF76B45#"
			local var_9_29

			if var_9_27 and arg_9_3.timeStr then
				var_9_29 = string.format(gLanguageCsv.shopBuyLimit, var_9_28, var_9_26, var_9_4.exchangeLimit, arg_9_3.timeStr)
			else
				var_9_29 = string.format(gLanguageCsv.shopBuyLimitNoDay, var_9_28, var_9_26, var_9_4.exchangeLimit)
			end

			local var_9_30 = rich.createByStr(var_9_29, 40)

			var_9_30:formatText()
			var_9_30:addTo(var_9_2.recoverPanel, 10, "emm"):alignCenter(var_9_2.recoverPanel:size()):y(30)
			arg_9_1:setTouchEnabled(var_9_25 >= 1)
		end
	else
		var_9_2.recoverPanel:hide()
		var_9_2.maskPanel:visible(arg_9_3.buyTimes == true)
		cache.setShader(var_9_2.btnBuy, false, arg_9_3.buyTimes and "hsl_gray" or "normal")
		cache.setShader(var_9_5.icon, false, arg_9_3.buyTimes and "hsl_gray" or "normal")

		if arg_9_3.buyTimes then
			text.deleteAllEffect(var_9_5.txt)
			text.addEffect(var_9_5.txt, {
				color = ui.COLORS.DISABLED.WHITE
			})
		else
			text.addEffect(var_9_5.txt, {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			})
		end

		arg_9_1:setTouchEnabled(arg_9_3.buyTimes ~= true)
	end

	bind.touch(arg_9_0, arg_9_1, {
		methods = {
			ended = functools.partial(arg_9_0.itemClick, arg_9_0:getIdx(arg_9_2), arg_9_3)
		}
	})
end

local function var_0_18(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_1:multiget("bg", "btnBuy", "imageAdd", "maskPanel", "txtName")

	nodetools.map({
		var_11_0.imageAdd,
		var_11_0.maskPanel
	}, "visible", false)

	local var_11_1 = var_11_0.bg:size()
	local var_11_2 = 80
	local var_11_3 = ccui.Scale9Sprite:create()

	var_11_3:initWithFile(cc.rect(82, 82, 1, 1), "common/icon/mask_card.png")
	var_11_3:size(var_11_1.width - 39, var_11_1.height - 39):alignCenter(var_11_1)

	local var_11_4 = gSkinCsv[arg_11_3.skinId]
	local var_11_5 = dataEasy.getUnitId(nil, arg_11_3.skinId)
	local var_11_6 = csv.unit[var_11_5]
	local var_11_7 = cc.Sprite:create(var_11_6.cardShow)
	local var_11_8 = var_11_7:size()
	local var_11_9 = cc.p(var_11_6.cardShowPosC.x / var_11_6.cardShowScale, -var_11_6.cardShowPosC.y / var_11_6.cardShowScale)
	local var_11_10 = cc.size(var_11_1.width / var_11_6.cardShowScale, var_11_1.height / var_11_6.cardShowScale)
	local var_11_11 = cc.rect((var_11_8.width - var_11_10.width) / 2 - var_11_9.x, (var_11_8.height - var_11_10.height) / 2 - var_11_9.y, var_11_10.width, var_11_10.height)

	var_11_7:alignCenter(var_11_1):scale(var_11_6.cardShowScale + 0.2):setTextureRect(var_11_11)
	var_11_0.bg:removeChildByName("clipping")
	cc.ClippingNode:create(var_11_3):setAlphaThreshold(0.1):size(var_11_1):alignCenter(var_11_0.bg:size()):add(var_11_7):addTo(var_11_0.bg, 1, "clipping")
	var_11_0.txtName:text(var_11_4.name)
	var_11_0.bg:texture(var_11_4.skinFrameRes)

	local var_11_12 = var_11_0.btnBuy:multiget("txt", "icon")
	local var_11_13, var_11_14 = csvNext(arg_11_3.costMap)
	local var_11_15 = dataEasy.getCfgByKey(var_11_13)

	var_11_12.icon:texture(dataEasy.getIconResByKey(var_11_13))
	var_11_12.txt:text(var_11_14)

	local var_11_16 = var_11_12.icon:getBoundingBox()
	local var_11_17 = var_11_12.txt:size()

	var_11_12.icon:x(var_11_0.btnBuy:width() / 2 - var_11_16.width - var_11_17.width / 2 + 20)
	adapt.oneLinePos(var_11_12.icon, var_11_12.txt, cc.p(10, 0), "left")

	if arg_11_3.isHave then
		var_11_0.maskPanel:visible(true)
		cache.setShader(var_11_0.btnBuy, false, "hsl_gray")
		cache.setShader(var_11_12.icon, false, "hsl_gray")
		var_11_0.bg:texture("city/drawcard/draw/panel_card_gh.png")

		return
	end

	if arg_11_3.extraItem and csvSize(arg_11_3.extraItem) == 1 then
		var_11_0.imageAdd:visible(true)

		local var_11_18, var_11_19 = csvNext(arg_11_3.extraItem)
		local var_11_20 = csv.items[var_11_18]
		local var_11_21 = cc.Sprite:create(var_11_20.icon)

		var_11_21:alignCenter(var_11_21:size()):scale(1.2):xy(cc.p(80, 80)):addTo(var_11_0.imageAdd)
	end

	bind.touch(arg_11_0, arg_11_1, {
		methods = {
			ended = functools.partial(arg_11_0.itemSkinClick, arg_11_2, arg_11_3)
		}
	})
end

local var_0_19 = cc.load("mvc").ViewBase
local var_0_20 = class("ShopView", var_0_19)

var_0_20.RESOURCE_FILENAME = "shop.json"
var_0_20.RESOURCE_BINDING = {
	["leftPanel.item"] = "leftItem",
	item = "item",
	rightPanel = "rightPanel",
	["rightPanel.bottomPanel.icon"] = "fixDiamond",
	["rightPanel.slider"] = "slider",
	["rightPanel.subList"] = "subList",
	["rightPanel.bottomPanel"] = "rightBottomPanel",
	["rightPanel.bottomPanel.icon1"] = "icon1",
	["leftPanel.itemChild"] = "itemChild",
	["leftPanel.itemParent"] = "itemParent",
	["leftPanel.list"] = {
		binds = {
			{
				event = "extend",
				class = "listview",
				props = {
					data = bindHelper.self("leftDatas"),
					item = bindHelper.self("leftItem"),
					preloadCenter = bindHelper.self("showTab"),
					itemAction = {
						isAction = true
					},
					onItem = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
						local var_12_0 = arg_12_1:get("normal")
						local var_12_1 = arg_12_1:get("selected")
						local var_12_2

						if arg_12_3.select then
							var_12_0:hide()

							var_12_2 = var_12_1:show()
						else
							var_12_1:hide()

							var_12_2 = var_12_0:show()

							var_12_2:get("subTxt"):text(arg_12_3.subName)
						end

						local var_12_3 = var_12_2:size().width - 50

						adapt.setTextScaleWithWidth(var_12_2:get("txt"), arg_12_3.name, var_12_3)
						var_12_1:setTouchEnabled(false)
						var_0_13(arg_12_3.isLocked and not arg_12_3.select, var_12_0, {
							pos = cc.p(320, 110)
						})
						bind.touch(arg_12_0, var_12_0, {
							methods = {
								ended = functools.partial(arg_12_0.clickCell, arg_12_2, arg_12_3)
							}
						})
					end
				},
				handlers = {
					clickCell = bindHelper.self("onLeftItemClick")
				}
			},
			{
				event = "visible",
				idler = bindHelper.self("isShopClassity"),
				method = function(arg_13_0)
					return arg_13_0 == false
				end
			}
		}
	},
	["leftPanel.listClassify"] = {
		varname = "leftList",
		binds = {
			{
				class = "listview",
				event = "extend",
				itemAction = {
					isAction = true
				},
				props = {
					data = bindHelper.self("newLeftDatas"),
					item = bindHelper.self("itemParent"),
					childItem = bindHelper.self("itemChild"),
					preloadCenter = bindHelper.self("classifyShowTab"),
					showTab = bindHelper.self("showTab"),
					onItem = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
						var_0_16(arg_14_0, arg_14_1, arg_14_2, arg_14_3)

						if arg_14_3.select == true then
							bind.touch(arg_14_0, arg_14_1:get("selected"), {
								methods = {
									ended = functools.partial(arg_14_0.clickCell, arg_14_2, arg_14_3)
								}
							})
						else
							bind.touch(arg_14_0, arg_14_1:get("normal"), {
								methods = {
									ended = functools.partial(arg_14_0.clickCell, arg_14_2, arg_14_3)
								}
							})
						end

						adapt.setTextScaleWithWidth(arg_14_1:get("selected"):get("txt"), arg_14_3.name, arg_14_1:get("selected"):width() - 20)
						adapt.setTextScaleWithWidth(arg_14_1:get("normal"):get("txt"), arg_14_3.name, arg_14_1:get("normal"):width() - 20)
						arg_14_0:forceDoLayout()
					end
				},
				handlers = {
					clickCell = bindHelper.self("onNewLeftItemClick"),
					clickChildCell = bindHelper.self("onLeftItemClick")
				}
			},
			{
				event = "visible",
				idler = bindHelper.self("isShopClassity")
			}
		}
	},
	["rightPanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				data = bindHelper.self("shopData"),
				columnSize = bindHelper.self("rightColumnSize"),
				sliderBg = bindHelper.self("slider"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				btnIdx = bindHelper.self("showTab"),
				asyncPreload = bindHelper.self("rightAsyncPreload"),
				itemAction = {
					actionTime = 0.2,
					duration = 0.1,
					isAction = true
				},
				onCell = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
					local var_15_0 = arg_15_1:multiget("item1", "item2")
					local var_15_1 = arg_15_3.type == var_0_8.SKIN_SHOP

					var_15_0.item1:visible(not var_15_1)
					var_15_0.item2:visible(var_15_1)

					if var_15_1 then
						var_0_18(arg_15_0, var_15_0.item2, arg_15_2, arg_15_3)
					else
						var_0_17(arg_15_0, var_15_0.item1, arg_15_2, arg_15_3)
					end
				end,
				onBeforeBuild = function(arg_16_0)
					if arg_16_0.sliderBg:visible() then
						arg_16_0.sliderShow = true

						arg_16_0.sliderBg:hide()
					end

					arg_16_0:setTouchEnabled(true)
				end,
				onAfterBuild = function(arg_17_0)
					if arg_17_0.sliderShow then
						arg_17_0.sliderBg:show()

						arg_17_0.sliderShow = false
					end

					arg_17_0.sliderBg:show()
					arg_17_0:setTouchEnabled(true)

					local var_17_0, var_17_1 = arg_17_0:xy()
					local var_17_2 = arg_17_0:size()
					local var_17_3, var_17_4 = arg_17_0.sliderBg:xy()
					local var_17_5 = arg_17_0.sliderBg:size()

					arg_17_0:setScrollBarEnabled(true)
					arg_17_0:setScrollBarColor(cc.c3b(245, 156, 2))
					arg_17_0:setScrollBarOpacity(255)
					arg_17_0:setScrollBarAutoHideEnabled(false)
					arg_17_0:setScrollBarPositionFromCorner(cc.p(25, (var_17_2.height - var_17_5.height) / 2 + 5))
					arg_17_0.sliderBg:x(var_17_0 + var_17_2.width - 25)
					arg_17_0:setScrollBarWidth(var_17_5.width)
					arg_17_0:refreshView()
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick"),
				itemSkinClick = bindHelper.self("onItemSkinClick")
			}
		}
	},
	["rightPanel.bottomPanel.btnRefresh"] = {
		varname = "btnRefresh",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_18_0)
						return arg_18_0:onRefreshClick()
					end)
				}
			}
		}
	},
	["rightPanel.bottomPanel.refreshTime"] = {
		varname = "refreshTime",
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
	["rightPanel.bottomPanel.cost"] = {
		varname = "bottomCost",
		binds = {
			{
				event = "text",
				idler = bindHelper.self("textFixShopRefreshCost")
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
	["rightPanel.bottomPanel.times"] = {
		varname = "textTimes",
		binds = {
			event = "text",
			idler = bindHelper.self("textFixShopRefreshTimes")
		}
	},
	["rightPanel.bottomPanel.num"] = {
		varname = "numTxt",
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
	["rightPanel.bottomPanel.txt"] = {
		varname = "txt",
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
	["rightPanel.bottomPanel.txt2"] = {
		varname = "txt2",
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
	["rightPanel.bottomPanel.txt3"] = {
		varname = "txt3",
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
	["rightPanel.bottomPanel.txt4"] = {
		varname = "txt4",
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
	["rightPanel.bottomPanel.btn.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["rightPanel.bottomPanel.btn"] = {
		varname = "btn",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_19_0)
						return arg_19_0:onRefreshClick(true)
					end)
				}
			}
		}
	}
}

function var_0_20.initIndexModel(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0.rightBottomPanel:getChildren()

	itertools.invoke(var_20_0, "hide")
	arg_20_0.rightBottomPanel:get("refreshTime"):show()

	if var_0_11(arg_20_1) then
		local var_20_1 = {
			[var_0_8.PVP_SHOP] = {
				title = "pvp_shop",
				shop = arg_20_0.pvpShop,
				shopItems = arg_20_0.pvpShopItems
			},
			[var_0_8.CRAFT_SHOP] = {
				title = "craft_shop",
				shop = arg_20_0.craftShop,
				shopItems = arg_20_0.craftShopItems
			},
			[var_0_8.UNION_FIGHT_SHOP] = {
				title = "union_fight_shop",
				shop = arg_20_0.union_shop,
				shopItems = arg_20_0.unionItems
			},
			[var_0_8.CROSS_CRAFT_SHOP] = {
				title = "cross_craft_shop",
				shop = arg_20_0.crossCraftShop,
				shopItems = arg_20_0.crossCraftShopItems
			},
			[var_0_8.CROSS_ARENA_SHOP] = {
				title = "cross_arena_shop",
				shop = arg_20_0.crossArenaShop,
				shopItems = arg_20_0.crossArenaShopItems
			},
			[var_0_8.ONLINE_FIGHT_SHOP] = {
				title = "cross_online_fight_shop",
				shop = arg_20_0.onlineFightShop,
				shopItems = arg_20_0.onlineFightShopItems
			},
			[var_0_8.CROSS_MINE_SHOP] = {
				title = "cross_mine_shop",
				shop = arg_20_0.crossMineShop,
				shopItems = arg_20_0.crossMineShopItems
			},
			[var_0_8.HUNTING_SHOP] = {
				title = "hunting_shop",
				shop = arg_20_0.huntingShop,
				shopItems = arg_20_0.huntingShopItems
			}
		}

		idlereasy.any({
			var_20_1[arg_20_1].shop,
			var_20_1[arg_20_1].shopItems,
			arg_20_0.shopLimit,
			arg_20_0.vipLevel,
			arg_20_0.level
		}, function(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
			local var_21_0 = arg_20_0.showTab:read()

			if var_0_11(var_21_0) then
				local var_21_1 = clone(arg_21_2)
				local var_21_2

				for iter_21_0 = 1, #var_21_1 do
					local var_21_3 = var_21_1[iter_21_0]
					local var_21_4 = var_21_3.csvID

					if var_0_6[var_21_0].sortValue then
						var_21_3.sortValue = var_0_6[var_21_0].sortValue
						var_21_2 = true
					end

					if arg_21_1[var_21_4] then
						local var_21_5 = arg_21_1[var_21_4]

						var_21_3.buyTimes = var_21_5[1]
						var_21_3.lastRecoverTime = var_21_5[2]

						if var_21_3.lastRecoverTime then
							local var_21_6 = var_0_6[var_21_3.type][var_21_3.csvID]
							local var_21_7 = var_21_6.regainHour * 60 * 60

							if not var_21_3.buyTimes then
								local var_21_8 = 0
							end

							local var_21_9 = var_21_6.exchangeLimit - var_21_3.buyTimes

							var_21_3.lastRecoverTime = math.floor(var_21_3.lastRecoverTime)

							local var_21_10 = time.getTime() - var_21_3.lastRecoverTime
							local var_21_11 = math.floor(var_21_10 / var_21_7)
							local var_21_12 = var_21_11 + var_21_9

							if var_21_12 >= var_21_6.exchangeLimit then
								var_21_3.timeStr = nil
							else
								var_21_3.timeStr = time.getCutDown(math.abs(math.floor((var_21_11 + 1) * var_21_7 - var_21_10))).str
							end

							if var_21_3.recoverTimes ~= var_21_12 then
								var_21_3.recoverTimes = var_21_12
							end
						end
					end

					local var_21_13 = var_20_1[var_21_0].title or ""

					if arg_21_3[var_21_13] and arg_21_3[var_21_13][var_21_4] then
						var_21_3.shopLimit = arg_21_3[var_21_13][var_21_4]
					end
				end

				if var_21_2 then
					table.sort(var_21_1, function(arg_22_0, arg_22_1)
						if arg_22_0.sortValue ~= arg_22_1.sortValue then
							return arg_22_0.sortValue < arg_22_1.sortValue
						end

						return arg_22_0.csvID < arg_22_1.csvID
					end)
				end

				dataEasy.tryCallFunc(arg_20_0.list, "updatePreloadCenterIndex")
				arg_20_0.shopData:update(var_21_1)
			end
		end):anonyOnly(arg_20_0)
	elseif arg_20_1 == var_0_8.EQUIP_SHOP then
		gGameApp:requestServer(var_0_7[arg_20_1], function()
			local var_23_0 = arg_20_0.idlerDatas[arg_20_1]
			local var_23_1 = gGameModel[var_23_0.modelType]:getIdler("items")
			local var_23_2 = gGameModel[var_23_0.modelType]:getIdler("buy")

			idlereasy.any({
				var_23_1,
				arg_20_0.showTab,
				var_23_2,
				arg_20_0.shopLimit,
				arg_20_0.vipLevel,
				arg_20_0.level
			}, function(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
				local var_24_0 = arg_24_4.equip_shop or {}
				local var_24_1

				arg_20_0:enableSchedule():schedule(function()
					if arg_24_2 ~= var_0_8.EQUIP_SHOP then
						return
					end

					local var_25_0 = {}
					local var_25_1 = 0
					local var_25_2 = tonumber(time.getTodayStr())

					for iter_25_0, iter_25_1 in orderCsvPairs(csv.equip_shop) do
						local var_25_3 = var_0_14(iter_25_1)

						if matchLanguage(iter_25_1.languages) and iter_25_1.type == 1 and var_25_3 and (iter_25_1.beginDate == 0 and iter_25_1.endDate == 0 or var_25_2 >= iter_25_1.beginDate and var_25_2 <= iter_25_1.endDate) then
							local var_25_4, var_25_5 = csvNext(iter_25_1.itemMap)

							table.insert(var_25_0, {
								shopLimit = var_24_0[iter_25_0] or {},
								index = iter_25_1.position,
								csvID = iter_25_0,
								type = var_0_8.EQUIP_SHOP,
								level = arg_24_6,
								vip = arg_24_5,
								itemID = var_25_4,
								count = var_25_5
							})

							var_25_1 = var_25_1 + 1
						end
					end

					for iter_25_2, iter_25_3 in pairs(arg_24_1) do
						var_25_1 = var_25_1 + 1

						local var_25_6 = iter_25_3[1]
						local var_25_7 = iter_25_3[2]

						table.insert(var_25_0, {
							isLimit = true,
							csvID = var_25_6,
							itemID = var_25_7,
							index = iter_25_2,
							buyTimes = arg_24_3[iter_25_2],
							type = arg_20_1,
							shopLimit = var_24_0[var_25_6] or {},
							vip = arg_24_5,
							level = arg_24_6
						})
					end

					table.sort(var_25_0, function(arg_26_0, arg_26_1)
						return arg_26_0.index < arg_26_1.index
					end)

					if var_24_1 ~= var_25_2 then
						arg_20_0.shopData:update(var_25_0)

						var_24_1 = var_25_2
					end
				end, 1, 0, "equipShop")
			end):anonyOnly(arg_20_0)

			local var_23_3 = arg_20_0.rightBottomPanel:getChildren()

			itertools.invoke(var_23_3, "hide")
			arg_20_0.rightBottomPanel:get("refreshTime"):show()
		end)
	elseif arg_20_1 == var_0_8.TOTEM_SHOP then
		gGameApp:requestServer(var_0_7[arg_20_1], function()
			local var_27_0 = arg_20_0.idlerDatas[arg_20_1]
			local var_27_1 = gGameModel[var_27_0.modelType]:getIdler("items")
			local var_27_2 = gGameModel[var_27_0.modelType]:getIdler("buy")

			idlereasy.any({
				var_27_1,
				arg_20_0.showTab,
				var_27_2,
				arg_20_0.shopLimit,
				arg_20_0.vipLevel,
				arg_20_0.level
			}, function(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6)
				local var_28_0 = arg_28_4.totem_shop or {}
				local var_28_1

				arg_20_0:enableSchedule():schedule(function()
					if arg_28_2 ~= var_0_8.TOTEM_SHOP then
						return
					end

					local var_29_0 = {}
					local var_29_1 = 0
					local var_29_2 = tonumber(time.getTodayStr())

					for iter_29_0, iter_29_1 in orderCsvPairs(csv.totem.shop) do
						local var_29_3 = var_0_14(iter_29_1)

						if matchLanguage(iter_29_1.languages) and iter_29_1.type == 1 and var_29_3 and (iter_29_1.beginDate == 0 and iter_29_1.endDate == 0 or var_29_2 >= iter_29_1.beginDate and var_29_2 <= iter_29_1.endDate) then
							local var_29_4, var_29_5 = csvNext(iter_29_1.itemMap)

							table.insert(var_29_0, {
								shopLimit = var_28_0[iter_29_0] or {},
								index = iter_29_1.position,
								csvID = iter_29_0,
								type = var_0_8.TOTEM_SHOP,
								level = arg_28_6,
								vip = arg_28_5,
								itemID = var_29_4,
								count = var_29_5
							})

							var_29_1 = var_29_1 + 1
						end
					end

					for iter_29_2, iter_29_3 in pairs(arg_28_1) do
						var_29_1 = var_29_1 + 1

						local var_29_6 = iter_29_3[1]
						local var_29_7 = iter_29_3[2]

						table.insert(var_29_0, {
							isLimit = true,
							csvID = var_29_6,
							itemID = var_29_7,
							index = iter_29_2,
							buyTimes = arg_28_3[iter_29_2],
							type = arg_20_1,
							shopLimit = var_28_0[var_29_6] or {},
							vip = arg_28_5,
							level = arg_28_6
						})
					end

					table.sort(var_29_0, function(arg_30_0, arg_30_1)
						return arg_30_0.index < arg_30_1.index
					end)

					if var_28_1 ~= var_29_2 then
						arg_20_0.shopData:update(var_29_0)

						var_28_1 = var_29_2
					end
				end, 1, 0, "totemShop")
			end):anonyOnly(arg_20_0)

			local var_27_3 = arg_20_0.rightBottomPanel:getChildren()

			itertools.invoke(var_27_3, "hide")
			arg_20_0.rightBottomPanel:get("refreshTime"):show()
		end)
	elseif arg_20_1 == var_0_8.SKIN_SHOP then
		idlereasy.any({
			arg_20_0.skins,
			arg_20_0.showTab,
			arg_20_0.vipLevel
		}, function(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
			if arg_31_2 ~= var_0_8.SKIN_SHOP then
				return
			end

			local var_31_0 = {}

			for iter_31_0, iter_31_1 in pairs(gSkinShopCsv) do
				local var_31_1 = csvNext(iter_31_1.itemMap)
				local var_31_2 = csv.items[var_31_1].specialArgsMap.skinID
				local var_31_3 = gSkinCsv[var_31_2]
				local var_31_4 = {
					id = iter_31_0,
					skinId = var_31_2,
					itemId = var_31_1,
					costMap = iter_31_1.costMap,
					litSkinNum = iter_31_1.litSkinNum,
					vipStart = iter_31_1.vipStart,
					startTime = iter_31_1.beginDate,
					endTime = iter_31_1.endDate,
					extraItem = iter_31_1.extraItem,
					isHave = arg_31_1[var_31_2] == 0,
					type = var_0_8.SKIN_SHOP,
					showUnable = iter_31_1.showUnable,
					rank = var_31_3.rank
				}

				var_31_0[#var_31_0 + 1] = var_31_4
			end

			table.sort(var_31_0, function(arg_32_0, arg_32_1)
				local var_32_0 = arg_32_0.isHave and 1 or 0
				local var_32_1 = arg_32_1.isHave and 1 or 0

				return var_32_0 * 100000 + arg_32_0.rank < var_32_1 * 100000 + arg_32_1.rank
			end)
			arg_20_0.shopData:update(var_31_0)
		end):anonyOnly(arg_20_0)
	elseif arg_20_0.pageIdx ~= arg_20_1 and var_0_7[arg_20_1] then
		gGameApp:requestServer(var_0_7[arg_20_1], function()
			arg_20_0:initIdler(arg_20_1)
		end)
	else
		arg_20_0:initIdler(arg_20_1)
	end
end

function var_0_20.initIdler(arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0.idlerDatas[arg_34_1]
	local var_34_1 = gGameModel[var_34_0.modelType]:getIdler("items")
	local var_34_2 = gGameModel[var_34_0.modelType]:getIdler("buy")
	local var_34_3 = itertools.map(game.SHOP_INIT, function(arg_35_0, arg_35_1)
		return arg_35_1, arg_35_0
	end)

	idlereasy.any({
		var_34_1,
		arg_34_0.showTab,
		var_34_2,
		arg_34_0.shopLimit,
		arg_34_0.vipLevel,
		arg_34_0.level,
		arg_34_0.fishLevel
	}, function(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6)
		if arg_36_2 == arg_34_1 then
			local var_36_0 = string.lower(var_34_3[arg_34_1])

			arg_34_0:initData(arg_34_1, arg_36_1, arg_36_3, arg_36_4[var_36_0], arg_36_5, arg_36_6)
		end
	end):anonyOnly(arg_34_0)
	idlereasy.any({
		var_34_0.refreshShopTime,
		arg_34_0.vipLevel,
		arg_34_0.showTab,
		arg_34_0.items
	}, function(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
		for iter_37_0, iter_37_1 in pairs(arg_34_0.idlerDatas) do
			iter_37_1.allNum = gVipCsv[arg_37_2][var_0_9[iter_37_0] or "shopRefreshLimit"]

			if var_0_10[iter_37_0] then
				iter_37_1.allNum = iter_37_1.allNum + (var_0_0.getPrivilegeAddition(var_0_10[iter_37_0]) or 0)
			end
		end

		local var_37_0 = arg_34_0.rightBottomPanel:getChildren()

		itertools.invoke(var_37_0, "hide")

		if arg_37_3 == var_0_8.EQUIP_SHOP or arg_37_3 == var_0_8.ONLINE_FIGHT_SHOP or arg_37_3 == var_0_8.TOTEM_SHOP then
			arg_34_0.rightBottomPanel:get("refreshTime"):show()
		else
			itertools.invoke(var_37_0, "show")

			local var_37_1 = arg_37_1 or 0
			local var_37_2 = var_34_0.allNum
			local var_37_3 = var_37_2 - var_37_1

			if not arg_34_0.shopRefreshLeftTimes then
				arg_34_0.shopRefreshLeftTimes = {}
			end

			arg_34_0.shopRefreshLeftTimes[arg_37_3] = var_37_3

			arg_34_0.textFixShopRefreshTimes:set(var_37_3 .. "/" .. var_37_2)
			arg_34_0.textTimes:text(var_37_3 .. "/" .. var_37_2)
			text.addEffect(arg_34_0.textTimes, {
				color = var_37_3 == 0 and ui.COLORS.NORMAL.ALERT_ORANGE or ui.COLORS.QUALITY[2],
				outline = {
					size = 2,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			})

			local var_37_4 = math.min(var_37_1 + 1, table.length(var_34_0.refreshCost))

			arg_34_0.textFixShopRefreshCost:set(var_34_0.refreshCost[var_37_4])
			arg_34_0.bottomCost:text(var_34_0.refreshCost[var_37_4])
			arg_34_0.fixDiamond:show()

			local var_37_5 = arg_37_4[game.ITEM_TICKET.shopRefresh] or 0

			arg_34_0.numTxt:text("x" .. var_37_5)
			itertools.invoke({
				arg_34_0.btn,
				arg_34_0.numTxt,
				arg_34_0.icon1,
				arg_34_0.txt4
			}, "visible", var_37_5 ~= 0)
			adapt.oneLinePos(arg_34_0.btnRefresh, {
				arg_34_0.txt,
				arg_34_0.textTimes,
				arg_34_0.txt2,
				arg_34_0.bottomCost,
				arg_34_0.fixDiamond,
				arg_34_0.txt3
			}, {
				cc.p(5, 0),
				cc.p(5, 0),
				cc.p(5, 0),
				cc.p(30, 0),
				cc.p(0, 0),
				cc.p(0, 0)
			}, "right")
			adapt.oneLinePos(arg_34_0.refreshTime, {
				arg_34_0.txt4,
				arg_34_0.icon1,
				arg_34_0.numTxt,
				arg_34_0.btn
			}, {
				cc.p(30, 0),
				cc.p(0, 0),
				cc.p(0, 0),
				cc.p(20, 0)
			}, "left")
		end
	end):anonyOnly(arg_34_0)
end

function var_0_20.initData(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5, arg_38_6)
	local var_38_0 = arg_38_3 or {}
	local var_38_1 = {}
	local var_38_2 = arg_38_4 or {}

	arg_38_0.max = arg_38_0.max or {}

	if not var_0_11(arg_38_1) and not arg_38_0.max[arg_38_1] then
		arg_38_0.max[arg_38_1] = {}

		for iter_38_0, iter_38_1 in orderCsvPairs(var_0_6[arg_38_1]) do
			local var_38_3 = csvNext(iter_38_1.itemWeightMap)

			arg_38_0.max[arg_38_1][iter_38_1.position] = {
				pos = false,
				itemID = var_38_3,
				csvID = iter_38_0,
				showUnable = iter_38_1.showUnable,
				type = iter_38_1.type
			}
		end
	end

	for iter_38_2, iter_38_3 in pairs(arg_38_2) do
		arg_38_0.max[arg_38_1][iter_38_2].pos = true

		table.insert(var_38_1, {
			csvID = iter_38_3[1],
			itemID = iter_38_3[2],
			index = iter_38_2,
			buyTimes = var_38_0[iter_38_2],
			type = arg_38_1,
			shopLimit = var_38_2[iter_38_2],
			vip = arg_38_5,
			level = arg_38_6
		})
	end

	if not var_0_11(arg_38_1) and arg_38_0.max[arg_38_1] then
		for iter_38_4, iter_38_5 in pairs(arg_38_0.max[arg_38_1]) do
			if not iter_38_5.pos and iter_38_5.showUnable then
				table.insert(var_38_1, {
					lockShow = true,
					index = iter_38_4,
					type = arg_38_1,
					itemID = iter_38_5.itemID,
					csvID = iter_38_5.csvID,
					vip = arg_38_5,
					level = arg_38_6,
					count = iter_38_5.count
				})
			end
		end
	end

	table.sort(var_38_1, function(arg_39_0, arg_39_1)
		return arg_39_0.index < arg_39_1.index
	end)
	dataEasy.tryCallFunc(arg_38_0.list, "updatePreloadCenterIndex")
	arg_38_0.shopData:update(var_38_1)

	return var_38_1
end

function var_0_20.getTimeShow(arg_40_0)
	local var_40_0 = arg_40_0.showTab:read()

	if var_40_0 == var_0_8.ONLINE_FIGHT_SHOP then
		return math.huge
	end

	if var_40_0 == var_0_8.EQUIP_SHOP then
		local var_40_1 = time.getNumTimestamp(tonumber(arg_40_0.equipShopRefresh), time.getRefreshHour())
		local var_40_2 = time.getTime()

		return var_40_1 + gCommonConfigCsv.equipShopRefreshDays * 24 * 3600 - var_40_2
	end

	if var_40_0 == var_0_8.TOTEM_SHOP then
		local var_40_3 = time.getNumTimestamp(tonumber(arg_40_0.totemShopRefresh), time.getRefreshHour())
		local var_40_4 = time.getTime()

		return var_40_3 + gCommonConfigCsv.totemShopRefreshDays * 24 * 3600 - var_40_4
	end

	local var_40_5 = time.getNowDate()
	local var_40_6 = 0

	for iter_40_0, iter_40_1 in ipairs(var_0_1) do
		if iter_40_1 > var_40_5.hour then
			var_40_6 = iter_40_0

			break
		end
	end

	local var_40_7 = var_40_6 == 0

	var_40_6 = var_40_6 == 0 and 1 or var_40_6

	local var_40_8 = {
		year = var_40_5.year,
		month = var_40_5.month,
		day = var_40_7 and var_40_5.day + 1 or var_40_5.day,
		hour = var_40_0 ~= var_0_8.FISHING_SHOP and var_0_1[var_40_6] or time.getRefreshHour()
	}

	return time.getTimestamp(var_40_8) - time.getTime()
end

function var_0_20.onCreate(arg_41_0, arg_41_1)
	local var_41_0 = arg_41_0.item:size().width
	local var_41_1 = 0

	arg_41_0.rightColumnSize = var_0_3 + var_41_1
	arg_41_0.rightAsyncPreload = arg_41_0.rightColumnSize * 3

	arg_41_0:initModel()

	arg_41_0.specialTime = {}
	arg_41_0.unionTime = {}
	arg_41_0.specialTimeCraft = {}
	arg_41_0.specialTimeCrossCraft = {}
	arg_41_0.specialTimeCrossArena = {}
	arg_41_0.specialTimeCrossMine = {}
	arg_41_0.specialTimeHunting = {}
	arg_41_0.specialTimeOnlineFight = {}
	arg_41_0.shopRefreshLeftTimes = {}
	arg_41_0.pvpShopItems = idlertable.new(var_0_15(csv.pwshop, var_0_8.PVP_SHOP, arg_41_0.specialTime))
	arg_41_0.unionItems = idlertable.new(var_0_15(csv.union_fight.shop, var_0_8.UNION_FIGHT_SHOP, arg_41_0.unionTime))
	arg_41_0.craftShopItems = idlertable.new(var_0_15(csv.craft.shop, var_0_8.CRAFT_SHOP, arg_41_0.specialTimeCraft))
	arg_41_0.crossCraftShopItems = idlertable.new(var_0_15(csv.cross.craft.shop, var_0_8.CROSS_CRAFT_SHOP, arg_41_0.specialTimeCrossCraft))
	arg_41_0.crossArenaShopItems = idlertable.new(var_0_15(csv.cross.arena.shop, var_0_8.CROSS_ARENA_SHOP, arg_41_0.specialTimeCrossArena))
	arg_41_0.onlineFightShopItems = idlertable.new(var_0_15(csv.cross.online_fight.shop, var_0_8.ONLINE_FIGHT_SHOP, arg_41_0.specialTimeOnlineFight))
	arg_41_0.crossMineShopItems = idlertable.new(var_0_15(csv.cross.mine.shop, var_0_8.CROSS_MINE_SHOP, arg_41_0.specialTimeCrossMine))
	arg_41_0.huntingShopItems = idlertable.new(var_0_15(csv.cross.hunting.shop, var_0_8.HUNTING_SHOP, arg_41_0.specialTimeHunting))
	arg_41_0.isShopClassity = dataEasy.getListenShow(gUnlockCsv.shopClassity)
	arg_41_0.shopData = idlers.new()
	arg_41_0.textFixShopRefreshTimes = idler.new("")
	arg_41_0.textFixShopRefreshCost = idler.new(0)
	arg_41_0.textRefreshTimes = idler.new(0)

	local var_41_2 = {
		{
			show = true,
			rightBottomShow = true,
			topui = "default",
			tabIndex = 1,
			subName = "",
			name = gLanguageCsv.spaceHandpick
		},
		{
			unlockKey = "unionShop",
			rightBottomShow = true,
			show = true,
			topui = "union",
			tabIndex = 2,
			subName = "",
			name = gLanguageCsv.spaceGuild,
			isLocked = not arg_41_0.unionId:read()
		},
		{
			unlockKey = "fragmentShop",
			rightBottomShow = true,
			show = true,
			topui = "fragment",
			tabIndex = 3,
			subName = "",
			name = gLanguageCsv.spaceFragment
		},
		{
			unlockKey = "arenaShop",
			show = true,
			topui = "arena",
			tabIndex = 4,
			subName = "",
			name = gLanguageCsv.spacePvp
		},
		{
			unlockKey = "explorer",
			rightBottomShow = true,
			show = true,
			topui = "explorer",
			tabIndex = 5,
			subName = "",
			name = gLanguageCsv.explorer
		},
		{
			unlockKey = "randomTower",
			rightBottomShow = true,
			show = true,
			topui = "random_tower",
			tabIndex = 6,
			subName = "",
			name = gLanguageCsv.randomTower
		},
		{
			unlockKey = "craft",
			show = true,
			topui = "craft",
			tabIndex = 7,
			subName = "",
			name = gLanguageCsv.craft
		},
		{
			unlockKey = "drawEquip",
			rightBottomShow = true,
			show = true,
			topui = "drawcard",
			tabIndex = 8,
			subName = "",
			name = gLanguageCsv.equipShop
		},
		{
			unlockKey = "unionFight",
			show = true,
			topui = "union_combet",
			tabIndex = 9,
			subName = "",
			name = gLanguageCsv.unionCombet,
			isLocked = not arg_41_0.unionId:read()
		},
		{
			unlockKey = "crossCraft",
			show = true,
			topui = "cross_craft",
			tabIndex = 10,
			subName = "CrossCraft",
			name = gLanguageCsv.crossCraft
		},
		{
			unlockKey = "crossArena",
			show = true,
			topui = "cross_arena",
			tabIndex = 11,
			subName = "CrossArena",
			name = gLanguageCsv.crossArena
		},
		{
			unlockKey = "fishing",
			rightBottomShow = true,
			show = true,
			topui = "fishing",
			tabIndex = 12,
			subName = "fishing",
			name = gLanguageCsv.fishing
		},
		{
			unlockKey = "onlineFight",
			rightBottomShow = true,
			show = true,
			topui = "online_fight",
			tabIndex = 13,
			subName = "battleArena",
			name = gLanguageCsv.onlineFight
		},
		{
			unlockKey = "skinShop",
			show = true,
			topui = "card_skin",
			tabIndex = 14,
			subName = "skin",
			name = gLanguageCsv.skin
		},
		[16] = {
			unlockKey = "hunting",
			show = true,
			topui = "hunting",
			tabIndex = 16,
			subName = "",
			name = gLanguageCsv.huntingArea
		},
		[18] = {
			unlockKey = "totem",
			rightBottomShow = true,
			show = true,
			topui = "totem",
			tabIndex = 18,
			subName = "Totem",
			name = gLanguageCsv.totem
		}
	}
	local var_41_3 = {
		[1] = true
	}

	for iter_41_0, iter_41_1 in pairs(var_41_2) do
		if iter_41_1.unlockKey then
			dataEasy.getListenUnlock(iter_41_1.unlockKey, functools.partial(function(arg_42_0, arg_42_1)
				if arg_42_1 and dataEasy.judgeServerOpen(iter_41_1.unlockKey) then
					var_41_3[arg_42_0] = true

					return
				end

				var_41_3[arg_42_0] = false
			end, iter_41_0))
		end
	end

	local var_41_4 = {}

	for iter_41_2, iter_41_3 in pairs(var_41_3) do
		if iter_41_3 == true then
			var_41_4[iter_41_2] = var_41_2[iter_41_2]
		end
	end

	arg_41_0.leftDatas = idlers.new()

	arg_41_0.leftDatas:update(var_41_4)

	local var_41_5 = {}

	for iter_41_4, iter_41_5 in orderCsvPairs(csv.shop) do
		if var_41_2[iter_41_4] then
			var_41_2[iter_41_4].shopType = iter_41_5.group
			var_41_2[iter_41_4].fontSize = iter_41_5.fontSize
		end
	end

	for iter_41_6, iter_41_7 in pairs(var_41_3) do
		if iter_41_7 == true then
			local var_41_6 = var_41_2[iter_41_6].shopType or 1

			var_41_5[var_41_6] = var_41_5[var_41_6] or {
				name = gLanguageCsv["shopTab" .. var_41_6]
			}
			var_41_5[var_41_6].data = var_41_5[var_41_6].data or {}

			table.insert(var_41_5[var_41_6].data, var_41_2[iter_41_6])
		end
	end

	arg_41_0.newLeftDatas = idlers.new()

	arg_41_0.newLeftDatas:update(var_41_5)

	local var_41_7 = 1

	arg_41_0.pageIdx = arg_41_0._pageIdx or arg_41_1 or 1

	if not var_41_3[arg_41_0.pageIdx] then
		arg_41_0.pageIdx = 1
	end

	for iter_41_8, iter_41_9 in pairs(var_41_2) do
		if iter_41_8 == arg_41_0.pageIdx then
			var_41_7 = iter_41_9.shopType or 1

			break
		end
	end

	arg_41_0.classifyShowTab = idler.new(var_41_7)

	arg_41_0.classifyShowTab:addListener(function(arg_43_0, arg_43_1, arg_43_2)
		if arg_43_1 and arg_43_1 ~= 0 then
			arg_41_0.newLeftDatas:atproxy(arg_43_1).select = false
		end

		if arg_43_0 and arg_43_0 ~= 0 then
			arg_41_0.newLeftDatas:atproxy(arg_43_0).select = true
		end

		performWithDelay(arg_41_0, function()
			arg_41_0.leftList:refreshView()

			local var_44_0 = arg_41_0.leftList:size().height
			local var_44_1 = arg_41_0.leftList:getInnerContainerSize().height
			local var_44_2 = arg_41_0.leftList:getInnerContainerPosition()

			if var_44_0 == var_44_1 and var_44_2.y ~= 0 then
				arg_41_0.leftList:jumpToTop()
			end
		end, 0.01)
	end)

	arg_41_0.showTab = idler.new(arg_41_0.pageIdx)
	arg_41_0.textFixShopRefreshTime = idler.new(arg_41_0:getTimeShow())

	arg_41_0.showTab:addListener(function(arg_45_0, arg_45_1, arg_45_2)
		arg_41_0.textFixShopRefreshTime:set(arg_41_0:getTimeShow())
		arg_41_0.rightBottomPanel:visible(arg_41_0.leftDatas:atproxy(arg_45_0).rightBottomShow == true)

		if arg_41_0.leftDatas:atproxy(arg_45_0).show then
			if arg_41_0.topView then
				gGameUI.topuiManager:removeView(arg_41_0.topView)
			end

			arg_41_0.list:show()
			arg_41_0.list:jumpToTop()
			dataEasy.tryCallFunc(arg_41_0.list, "setItemAction", {
				actionTime = 0.2,
				duration = 0.1,
				isAction = true
			})
			arg_41_0:initIndexModel(arg_45_0)

			arg_41_0.topView = gGameUI.topuiManager:createView(arg_41_0.leftDatas:atproxy(arg_45_0).topui, arg_41_0, {
				onClose = arg_41_0:createHandler("onClose")
			}):init({
				subTitle = "SUPERMARKET",
				title = "common/txt/txt_bt_shangcheng.png"
			})

			if arg_41_0.leftDatas:atproxy(arg_45_0).isRefresh then
				arg_41_0.leftDatas:atproxy(arg_45_0).isRefresh = false

				if var_0_7[arg_45_0] then
					gGameApp:requestServer(var_0_7[arg_45_0])
				end
			end
		else
			arg_41_0.list:hide()
		end

		arg_41_0.leftDatas:atproxy(arg_45_1).select = false
		arg_41_0.leftDatas:atproxy(arg_45_0).select = true
	end)
	idlereasy.any({
		arg_41_0.showTab,
		arg_41_0.textFixShopRefreshTime
	}, function(arg_46_0, arg_46_1, arg_46_2)
		local var_46_0

		if arg_46_1 == var_0_8.ONLINE_FIGHT_SHOP then
			var_46_0 = gLanguageCsv.onlineFightShopTip
		elseif arg_46_1 == var_0_8.EQUIP_SHOP or arg_46_1 == var_0_8.TOTEM_SHOP then
			var_46_0 = string.format(gLanguageCsv.limitItemSchedule, time.getCutDown(arg_46_2).str)
		else
			var_46_0 = string.format(gLanguageCsv.nextRefreshTime, time.getCutDown(arg_46_2).str)
		end

		arg_41_0.refreshTime:text(var_46_0)
		adapt.oneLinePos(arg_41_0.refreshTime, {
			arg_41_0.txt4,
			arg_41_0.icon1,
			arg_41_0.numTxt,
			arg_41_0.btn
		}, {
			cc.p(30, 0),
			cc.p(0, 0),
			cc.p(0, 0),
			cc.p(20, 0)
		}, "left")
	end)
	performWithDelay(arg_41_0, function()
		arg_41_0:enableSchedule():schedule(function()
			arg_41_0.textFixShopRefreshTime:modify(function(arg_49_0)
				if arg_49_0 == 0 then
					local var_49_0 = var_0_7[arg_41_0.showTab:read()]

					if var_49_0 then
						gGameApp:requestServer(var_49_0)
					end

					return true, arg_41_0:getTimeShow()
				end

				return true, arg_49_0 - 1
			end)

			local function var_48_0(arg_50_0, arg_50_1, arg_50_2, arg_50_3)
				local var_50_0 = {}

				for iter_50_0, iter_50_1 in pairs(arg_50_0) do
					local var_50_1 = tonumber(iter_50_1.beginDate)
					local var_50_2 = tonumber(iter_50_1.endDate)
					local var_50_3 = tonumber(time.getTodayStr())

					if var_50_3 < var_50_1 or var_50_2 < var_50_3 then
						var_50_0[iter_50_0] = true
						arg_50_0[iter_50_0] = nil
					end
				end

				idlereasy.do_(function(arg_51_0, arg_51_1, arg_51_2)
					if itertools.size(var_50_0) > 0 then
						local var_51_0 = {}

						for iter_51_0 = 1, #arg_51_0 do
							if not var_50_0[arg_51_0.csvID] then
								table.insert(var_51_0, arg_51_0[iter_51_0])
							end
						end

						arg_50_1:set(newVal)
					end

					local var_51_1 = var_0_15(arg_50_2, arg_50_3)

					if not itertools.equal(arg_51_0, var_51_1) then
						arg_50_1:set(t)
					end
				end, arg_50_1, arg_41_0.vipLevel, arg_41_0.level)
			end

			var_48_0(arg_41_0.specialTime, arg_41_0.pvpShopItems, csv.pwshop, var_0_8.PVP_SHOP)
			var_48_0(arg_41_0.unionTime, arg_41_0.unionItems, csv.union_fight.shop, var_0_8.UNION_FIGHT_SHOP)
			var_48_0(arg_41_0.specialTimeCraft, arg_41_0.craftShopItems, csv.craft.shop, var_0_8.CRAFT_SHOP)
			var_48_0(arg_41_0.specialTimeCrossCraft, arg_41_0.crossCraftShopItems, csv.cross.craft.shop, var_0_8.CROSS_CRAFT_SHOP)
			var_48_0(arg_41_0.specialTimeCrossArena, arg_41_0.crossArenaShopItems, csv.cross.arena.shop, var_0_8.CROSS_ARENA_SHOP)
			var_48_0(arg_41_0.specialTimeCrossMine, arg_41_0.crossMineShopItems, csv.cross.mine.shop, var_0_8.CROSS_MINE_SHOP)
			var_48_0(arg_41_0.specialTimeHunting, arg_41_0.huntingShopItems, csv.cross.hunting.shop, var_0_8.HUNTING_SHOP)

			for iter_48_0 = 1, arg_41_0.shopData:size() do
				local var_48_1 = arg_41_0.shopData:atproxy(iter_48_0)

				if var_48_1.lastRecoverTime then
					local var_48_2 = var_0_6[var_48_1.type][var_48_1.csvID]
					local var_48_3 = var_0_6[var_48_1.type][var_48_1.csvID].regainHour * 60 * 60

					if not var_48_1.buyTimes then
						local var_48_4 = 0
					end

					local var_48_5 = var_48_2.exchangeLimit - var_48_1.buyTimes
					local var_48_6 = time.getTime() - var_48_1.lastRecoverTime
					local var_48_7 = math.floor(var_48_6 / var_48_3)
					local var_48_8 = var_48_7 + var_48_5

					if var_48_8 >= var_48_2.exchangeLimit then
						var_48_1.timeStr = nil
					else
						var_48_1.timeStr = time.getCutDown(math.abs(math.floor((var_48_7 + 1) * var_48_3 - var_48_6))).str
					end

					if var_48_1.recoverTimes ~= var_48_8 then
						var_48_1.recoverTimes = var_48_8
					end
				end
			end
		end, 1, 0, "ShopView")
	end, 1)
end

function var_0_20.onCleanup(arg_52_0)
	arg_52_0._pageIdx = arg_52_0.showTab:read()

	var_0_19.onCleanup(arg_52_0)
end

function var_0_20.initModel(arg_53_0)
	arg_53_0.rmb = gGameModel.role:getIdler("rmb")
	arg_53_0.gold = gGameModel.role:getIdler("gold")
	arg_53_0.skins = gGameModel.role:getIdler("skins")
	arg_53_0.equipAwakeFrag = gGameModel.role:getIdler("equip_awake_frag")
	arg_53_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_53_0.pvpShop = gGameModel.role:getIdler("pvp_shop")
	arg_53_0.craftShop = gGameModel.role:getIdler("craft_shop")
	arg_53_0.union_shop = gGameModel.role:getIdler("union_fight_shop")
	arg_53_0.crossCraftShop = gGameModel.role:getIdler("cross_craft_shop")
	arg_53_0.crossArenaShop = gGameModel.role:getIdler("cross_arena_shop")
	arg_53_0.crossMineShop = gGameModel.role:getIdler("cross_mine_shop")
	arg_53_0.huntingShop = gGameModel.role:getIdler("hunting_shop")
	arg_53_0.onlineFightShop = gGameModel.role:getIdler("cross_online_fight_shop")
	arg_53_0.level = gGameModel.role:getIdler("level")
	arg_53_0.shopLimit = gGameModel.role:getIdler("shop_limit")
	arg_53_0.unionId = gGameModel.role:getIdler("union_db_id")
	arg_53_0.items = gGameModel.role:getIdler("items")
	arg_53_0.equipShopRefresh = gGameModel.global_record:read("equip_shop_refresh")
	arg_53_0.totemShopRefresh = gGameModel.global_record:read("totem_shop_refresh")
	arg_53_0.fishLevel = gGameModel.fishing:getIdler("level")

	local var_53_0 = arg_53_0.vipLevel:read()

	arg_53_0.idlerDatas = {
		{
			modelType = "fix_shop",
			refreshShopTime = gGameModel.daily_record:getIdler("fix_shop_refresh_times"),
			refreshCost = gCostCsv.fixshop_refresh_cost,
			allNum = gVipCsv[var_53_0].shopRefreshLimit
		},
		{
			modelType = "union_shop",
			refreshShopTime = gGameModel.daily_record:getIdler("union_shop_refresh_times"),
			refreshCost = gCostCsv.unionshop_refresh_cost,
			allNum = gVipCsv[var_53_0].shopRefreshLimit
		},
		{
			modelType = "frag_shop",
			refreshShopTime = gGameModel.daily_record:getIdler("frag_shop_refresh_times"),
			refreshCost = gCostCsv.fragshop_refresh_cost,
			allNum = gVipCsv[var_53_0].fragShopRefreshLimit + (var_0_0.getPrivilegeAddition("fragShopRefreshLimit") or 0)
		},
		[5] = {
			modelType = "explorer_shop",
			refreshShopTime = gGameModel.daily_record:getIdler("explorer_shop_refresh_times"),
			refreshCost = gCostCsv.explorershop_refresh_cost,
			allNum = gVipCsv[var_53_0].explorerShopRefreshLimit
		},
		[6] = {
			modelType = "random_tower_shop",
			refreshShopTime = gGameModel.daily_record:getIdler("randomTower_shop_refresh_times"),
			refreshCost = gCostCsv.randomTowerShop_refresh_cost,
			allNum = gVipCsv[var_53_0].shopRefreshLimit
		},
		[8] = {
			modelType = "equip_shop",
			allNum = gVipCsv[var_53_0].shopRefreshLimit
		},
		[12] = {
			modelType = "fishing_shop",
			refreshCost = gCostCsv.fishingshop_refresh_cost,
			refreshShopTime = gGameModel.daily_record:getIdler("fishing_shop_refresh_times"),
			allNum = gVipCsv[var_53_0].fishingShopRefreshLimit
		},
		[18] = {
			modelType = "totem_shop",
			allNum = gVipCsv[var_53_0].shopRefreshLimit
		}
	}
end

function var_0_20.onLeftItemClick(arg_54_0, arg_54_1, arg_54_2, arg_54_3)
	if (arg_54_2 == var_0_8.UNION_SHOP or arg_54_2 == var_0_8.UNION_FIGHT_SHOP) and arg_54_3.isLocked then
		gGameUI:showTip(gLanguageCsv.canUsedEnteringGuild)

		return
	end

	arg_54_0.showTab:set(arg_54_2)
end

function var_0_20.onNewLeftItemClick(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
	if not arg_55_3.select then
		arg_55_0.classifyShowTab:set(arg_55_2)

		for iter_55_0, iter_55_1 in pairs(arg_55_3.data) do
			arg_55_0.showTab:set(iter_55_1.tabIndex)

			break
		end
	else
		arg_55_0.classifyShowTab:set(0)
	end
end

function var_0_20.onRefreshClick(arg_56_0, arg_56_1)
	local var_56_0 = arg_56_0.showTab:read()

	if arg_56_1 then
		local var_56_1 = gLanguageCsv.ballRefreshShop

		gGameUI:showDialog({
			btnType = 2,
			isRich = true,
			strs = {
				"#C0x5B545B#" .. var_56_1,
				gLanguageCsv.ballNotCostTime
			},
			cb = function()
				gGameApp:requestServer(var_0_5[var_56_0], function(arg_58_0)
					gGameUI:showTip(gLanguageCsv.refreshSuccessful)
				end, true)
			end,
			dialogParams = {
				clickClose = false
			}
		})

		return
	end

	if arg_56_0.shopRefreshLeftTimes[var_56_0] <= 0 then
		gGameUI:showTip(gLanguageCsv.refreshLimit)

		return
	end

	if arg_56_0.rmb:read() < arg_56_0.textFixShopRefreshCost:read() then
		uiEasy.showDialog("rmb")

		return
	end

	local var_56_2 = string.format(gLanguageCsv.shopRefreshCommonBox, arg_56_0.textFixShopRefreshCost:read())

	gGameUI:showDialog({
		btnType = 2,
		isRich = true,
		strs = "#C0x5B545B#" .. var_56_2,
		cb = function()
			gGameApp:requestServer(var_0_5[var_56_0], function(arg_60_0)
				gGameUI:showTip(gLanguageCsv.refreshSuccessful)
			end, false)
		end,
		dialogParams = {
			clickClose = false
		}
	})
end

function var_0_20.onItemClick(arg_61_0, arg_61_1, arg_61_2, arg_61_3)
	local var_61_0 = arg_61_0.shopData:atproxy(arg_61_2.k)

	arg_61_0.data = var_61_0

	local var_61_1 = var_0_6[arg_61_3.type][var_61_0.csvID]
	local var_61_2 = var_61_1.itemCount

	if not var_61_2 or var_61_2 == 0 then
		var_61_2 = arg_61_3.count
	end

	arg_61_0.num = var_61_2

	local var_61_3 = 1
	local var_61_4
	local var_61_5 = var_61_1.limitTimes
	local var_61_6 = {
		var_0_8.PVP_SHOP,
		var_0_8.CRAFT_SHOP,
		var_0_8.UNION_FIGHT_SHOP,
		var_0_8.CROSS_CRAFT_SHOP,
		var_0_8.CROSS_ARENA_SHOP,
		var_0_8.CROSS_MINE_SHOP,
		var_0_8.HUNTING_SHOP
	}

	if itertools.include(var_61_6, arg_61_0.showTab:read()) then
		var_61_4 = "num"

		if var_61_1.exchangeLimit == -1 then
			var_61_3 = math.huge
		else
			local var_61_7 = arg_61_3.buyTimes or 0
			local var_61_8 = arg_61_3.recoverTimes or var_61_1.exchangeLimit - var_61_7

			var_61_3 = math.min(var_61_8, var_61_1.exchangeLimit)
		end
	end

	if arg_61_0.showTab:read() == var_0_8.EQUIP_SHOP or arg_61_0.showTab:read() == var_0_8.TOTEM_SHOP then
		var_61_4 = "num"

		if var_61_1.type == 1 then
			var_61_3 = math.huge
		else
			var_61_3 = var_61_1.itemCount
		end
	end

	if var_61_1.limitType == 1 then
		var_61_3 = var_61_5

		if tonumber(arg_61_3.shopLimit[2]) == tonumber(time.getTodayStr()) then
			var_61_3 = var_61_5 - (arg_61_3.shopLimit[1] or 0)
		end

		var_61_4 = "num"
	elseif var_61_1.limitType == 2 then
		var_61_3 = var_61_5

		if tonumber(arg_61_3.shopLimit[2]) == tonumber(time.getWeekStrInClock()) then
			var_61_3 = var_61_5 - (arg_61_3.shopLimit[1] or 0)
		end

		var_61_4 = "num"
	elseif var_61_1.limitType == 3 then
		var_61_3 = var_61_5

		if tonumber(arg_61_3.shopLimit[2]) == tonumber(time.getMonthStrInClock()) then
			var_61_3 = var_61_5 - (arg_61_3.shopLimit[1] or 0)
		end

		var_61_4 = "num"
	elseif var_61_1.limitType == 4 then
		var_61_3 = var_61_5 - (arg_61_3.shopLimit[1] or 0)
		var_61_4 = "num"
	end

	local var_61_9 = arg_61_3.type == var_0_8.FIX_SHOP and 1 - (var_0_0.getPrivilegeAddition("fixShopDiscount") or 0) or 1

	gGameUI:stackUI("common.buy_info", nil, nil, var_61_1.costMap, {
		id = var_61_0.itemID,
		num = arg_61_0.num
	}, {
		maxNum = var_61_3,
		discount = var_61_9,
		contentType = var_61_4
	}, arg_61_0:createHandler("showBuyInfo"))
end

function var_0_20.onItemSkinClick(arg_62_0, arg_62_1, arg_62_2, arg_62_3)
	local var_62_0 = gLanguageCsv.skinTip01
	local var_62_1, var_62_2 = csvNext(arg_62_3.costMap)
	local var_62_3 = true
	local var_62_4 = var_62_0 .. string.format("%d#I%s-56-56#", var_62_2, dataEasy.getIconResByKey(var_62_1))

	if var_62_2 > dataEasy.getNumByKey(var_62_1) then
		var_62_3 = false
	end

	local var_62_5 = gSkinCsv[arg_62_3.skinId]
	local var_62_6, var_62_7 = csvNext(arg_62_3.extraItem)
	local var_62_8 = {
		{
			arg_62_3.itemId,
			1
		}
	}

	if var_62_6 then
		var_62_8[#var_62_8 + 1] = {
			var_62_6,
			var_62_7
		}
	end

	if var_62_3 then
		gGameUI:showDialog({
			isRich = true,
			btnType = 2,
			strs = string.format(gLanguageCsv.skinTip02, var_62_4, var_62_5.name),
			cb = function()
				gGameApp:requestServer("/game/card/skin/shop/buy", function(arg_64_0)
					gGameUI:showGainDisplay(var_62_8, {
						raw = false
					})
				end, arg_62_3.id, 1)
			end,
			dialogParams = {
				clickClose = false
			}
		})
	else
		uiEasy.showDialog(var_62_1)
	end
end

function var_0_20.showBuyInfo(arg_65_0, arg_65_1)
	gGameApp:requestServer(var_0_4[arg_65_0.data.type], function(arg_66_0)
		gGameUI:showGainDisplay({
			{
				arg_65_0.data.itemID,
				arg_65_0.num * arg_65_1
			}
		}, {
			raw = false
		})
	end, var_0_12(arg_65_0.data.type, not var_0_11(arg_65_0.data.type) and arg_65_0.data.index or arg_65_0.data.csvID, arg_65_0.data.csvID, arg_65_0.data.itemID, arg_65_1))
end

return var_0_20
