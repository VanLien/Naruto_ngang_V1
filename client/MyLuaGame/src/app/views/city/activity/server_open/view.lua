local var_0_0 = require("app.views.city.activity.view")
local var_0_1 = require("app.easy.bind.helper.red_hint")
local var_0_2 = -1
local var_0_3 = {
	vacation = {
		bg = "activity/server_open/summer_vacation/img_sqqtl_2.png",
		iconTop = "activity/server_open/summer_vacation/banner_sqqtl_2.png",
		boxIcon = "activity/server_open/summer_vacation/icon_sqqtl_1.png",
		iconBtn = "activity/server_open/summer_vacation/btn_sqqtl_2x2.png",
		iconBg = "activity/server_open/summer_vacation/img_sqqtl_1.png",
		boxBg = "activity/server_open/summer_vacation/box_sqqtl_1.png",
		boxIconBg = "activity/server_open/summer_vacation/img_sqqtl_3.png",
		hintBg = "activity/server_open/summer_vacation/img_wenzidi.png"
	},
	national = {
		boxIconBg = "activity/server_open/summer_vacation/img_sqqtl_3.png",
		iconTop = "activity/server_open/national_mid_autumnl/banner_khsd_1.png",
		boxIcon = "activity/server_open/national_mid_autumnl/icon_khsd_1.png",
		hintBg = "activity/server_open/summer_vacation/img_wenzidi.png",
		iconBg = "activity/server_open/national_mid_autumnl/img_khsd_1.png",
		boxBg = "activity/server_open/national_mid_autumnl/box_khsd_1.png"
	}
}
local var_0_4 = class("ServerOpenView", Dialog)

var_0_4.RESOURCE_FILENAME = "activity_server_open.json"
var_0_4.RESOURCE_BINDING = {
	item = "item",
	itemDay = "dayItem",
	title = "title",
	box = "box",
	topPanel = "topPanel",
	leftPanel = "leftPanel",
	["leftPanel.icon"] = "leftPanelIcon",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["topPanel.list"] = {
		varname = "topList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("dayData"),
				item = bindHelper.self("dayItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("normal")
					local var_1_1 = arg_1_1:get("selected")
					local var_1_2
					local var_1_3
					local var_1_4 = ui.COLORS.NORMAL.BROWN

					if arg_1_3.selected then
						var_1_0:hide()

						var_1_2 = var_1_1:show()
						var_1_3 = var_1_2:get("txt")

						for iter_1_0, iter_1_1 in pairs(var_0_3) do
							if arg_1_3.clientType == iter_1_0 then
								var_1_1:loadTextureNormal(iter_1_1.iconBtn)
							end
						end
					else
						var_1_4 = ui.COLORS.NORMAL.WHITE

						var_1_1:hide()

						var_1_2 = var_1_0:show()
						var_1_3 = var_1_2:get("txt")
					end

					text.addEffect(var_1_3, {
						color = var_1_4,
						outline = {
							color = arg_1_3.selected and ui.NEWCOLORS.OUTLINE.YELLOW or ui.NEWCOLORS.OUTLINE.BLUE
						}
					})
					arg_1_1:get("lock"):visible(arg_1_3.isLock == true)
					var_1_3:text(arg_1_3.cfg.themeName)

					if not arg_1_3.isLock then
						arg_1_0.state = arg_1_3.selected ~= true

						local var_1_5 = {
							class = "red_hint",
							props = {
								specialTag = "serverOpenDay",
								state = bindHelper.self("state"),
								listenData = {
									originData = bindHelper.parent("originData"),
									id = bindHelper.parent("id")
								},
								func = function(arg_2_0)
									if arg_2_0.originData and arg_2_0.id then
										return var_0_1.serverOpenDay(arg_2_0, arg_1_2)
									end

									return false
								end,
								onNode = function(arg_3_0)
									arg_3_0:xy(275, 115)
								end
							}
						}

						bind.extend(arg_1_0, arg_1_1, var_1_5)
					end

					bind.click(arg_1_0, var_1_2, {
						method = functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3)
					})
				end,
				onAfterBuild = function(arg_4_0)
					arg_4_0.afterBuild()
				end
			},
			handlers = {
				afterBuild = bindHelper.self("onAfterBuild"),
				clickCell = bindHelper.self("onDayClick")
			}
		}
	},
	["topPanel.time"] = {
		varname = "time"
	},
	["topPanel.txt"] = {
		varname = "timeLabel"
	},
	["leftPanel.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = -10,
				data = bindHelper.self("tabData"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					local var_5_0 = arg_5_1:multiget("selected", "name")

					var_5_0.selected:visible(arg_5_3.selected == true)
					var_5_0.name:text(arg_5_3[1].cfg.tabName)

					if arg_5_3.selected then
						text.addEffect(var_5_0.name, {
							color = ui.NEWCOLORS.BLACK
						})
					else
						text.addEffect(var_5_0.name, {
							color = ui.NEWCOLORS.WHITE
						})
					end

					adapt.setTextScaleWithWidth(var_5_0.name, nil, 340)

					arg_5_0.state = arg_5_3.selected ~= true

					local var_5_1 = {
						class = "red_hint",
						props = {
							specialTag = "serverOpenCurrDay",
							state = bindHelper.self("state"),
							onNode = function(arg_6_0)
								arg_6_0:xy(450, 150)
							end,
							listenData = {
								originData = bindHelper.parent("originData"),
								day = bindHelper.parent("showTab"),
								id = bindHelper.parent("id"),
								index = arg_5_2
							}
						}
					}

					bind.extend(arg_5_0, arg_5_1, var_5_1)
					bind.click(arg_5_0, arg_5_1, {
						method = functools.partial(arg_5_0.clickCell, arg_5_2, arg_5_3)
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	["leftPanel.btn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowPlacard")
			}
		}
	}
}

function var_0_4.onCreate(arg_7_0, arg_7_1)
	arg_7_0.clientType = csv.yunying.yyhuodong[arg_7_1].clientParam.type

	for iter_7_0, iter_7_1 in pairs(var_0_3) do
		if arg_7_0.clientType == iter_7_0 then
			arg_7_0.topPanel:get("imgLeft"):texture(iter_7_1.iconTop)
			arg_7_0.topPanel:get("imgLeft"):y(arg_7_0.topPanel:get("imgLeft"):y() + 15)
			arg_7_0.box:texture(iter_7_1.boxBg)
			arg_7_0.title:texture(iter_7_1.iconBg)

			local var_7_0 = arg_7_0:getResourceNode()

			if iter_7_1.bg then
				local var_7_1 = CSprite.new(iter_7_1.bg)

				for iter_7_2 = 1, 4 do
					var_7_0:get("bg" .. iter_7_2):hide()
				end

				var_7_1:addTo(var_7_0, 0)
				var_7_1:scale(2)
				var_7_1:setAnchorPoint(cc.p(0.5, 0.5))
				var_7_1:alignCenter(var_7_0:size())
			end

			arg_7_0.leftPanelIcon:texture(iter_7_1.boxIcon)

			local var_7_2 = CSprite.new(iter_7_1.boxIconBg)

			var_7_2:addTo(arg_7_0.leftPanel, 0)
			var_7_2:setAnchorPoint(cc.p(0.5, 0.5))
			var_7_2:xy(arg_7_0.leftPanelIcon:x(), arg_7_0.leftPanelIcon:y())
			arg_7_0.leftPanelIcon:y(arg_7_0.leftPanelIcon:y() + 20)

			local var_7_3 = CSprite.new(iter_7_1.hintBg)

			var_7_3:addTo(arg_7_0.leftPanel, 1)
			var_7_3:xy(arg_7_0.leftPanelIcon:x(), arg_7_0.leftPanelIcon:y() - arg_7_0.leftPanelIcon:width() / 2 - 40)

			local var_7_4 = cc.Label:createWithTTF(gLanguageCsv.allTargetAward, "font/youmi.ttf", matchLanguage({
				"kr"
			}) and 30 or 26)

			var_7_4:addTo(var_7_3, 1)
			var_7_4:setAnchorPoint(cc.p(0.5, 0.5))

			local var_7_5 = cc.Label:createWithTTF(gLanguageCsv.summerGift, ui.FONT_PATH, matchLanguage({
				"kr",
				"en"
			}) and 30 or 40)

			var_7_5:addTo(var_7_3, 1)
			var_7_5:setAnchorPoint(cc.p(0.5, 0.5))

			if arg_7_0.clientType == "national" then
				arg_7_0.topPanel:get("imgLeft"):xy(arg_7_0.topPanel:get("imgLeft"):x() + 2, arg_7_0.topPanel:get("imgLeft"):y() + 8)
				arg_7_0.title:scale(1)
				arg_7_0.title:xy(arg_7_0.title:x() - 45, arg_7_0.title:y() + 10)
				var_7_4:text(gLanguageCsv.exclusiveReward)
				var_7_5:text(gLanguageCsv.carnivalGift)
				var_7_4:setPosition(-var_7_3:width() / 2 - 80, var_7_3:y() - 35)
				adapt.oneLinePos(var_7_4, var_7_5, cc.p(2, 7))
			else
				arg_7_0.title:scale(2)
				arg_7_0.title:xy(arg_7_0.title:x() + 20, arg_7_0.title:y() - 17)
				var_7_4:setPosition(-var_7_3:width() / 2 - 80, var_7_3:y() - 45)
				adapt.oneLinePos(var_7_4, var_7_5, cc.p(2, 7))
			end

			text.addEffect(var_7_5, {
				color = cc.c3b(255, 230, 65),
				outline = {
					color = cc.c3b(236, 82, 113)
				}
			})
		end
	end

	arg_7_0.dayItem:hide()

	arg_7_0.id = idler.new(arg_7_1)
	arg_7_0.serverOpenItemBuy = gGameModel.currday_dispatch:getIdlerOrigin("serverOpenItemBuy")

	var_0_0.setCountdown(arg_7_0, arg_7_1, arg_7_0.timeLabel, arg_7_0.time, {
		tag = 2,
		labelChangeCb = function()
			adapt.oneLinePos(arg_7_0.timeLabel, arg_7_0.time, cc.p(15, 0))
		end
	})

	local var_7_6 = game.TARGET_TYPE.ItemBuy
	local var_7_7 = csv.yunying.yyhuodong[arg_7_1]
	local var_7_8 = {}
	local var_7_9 = {}

	for iter_7_3, iter_7_4 in orderCsvPairs(csv.yunying.serveropen) do
		if iter_7_4.huodongID == var_7_7.huodongID then
			var_7_8[iter_7_4.themeType] = var_7_8[iter_7_4.themeType] or {}
			var_7_9[iter_7_4.themeType] = {
				cfg = iter_7_4,
				clientType = arg_7_0.clientType
			}
			var_7_8[iter_7_4.themeType][iter_7_4.tabIndex] = var_7_8[iter_7_4.themeType][iter_7_4.tabIndex] or {}

			table.insert(var_7_8[iter_7_4.themeType][iter_7_4.tabIndex], {
				id = iter_7_3,
				cfg = iter_7_4
			})
		end
	end

	arg_7_0.data = var_7_8
	arg_7_0.originData = idlertable.new(var_7_8)

	local var_7_10, var_7_11 = time.getActivityOpenDate(arg_7_1)
	local var_7_12 = time.getTime() - var_7_11
	local var_7_13 = tonumber(math.max(time.getCutDown(var_7_12).day, 0))

	arg_7_0.currDay = idler.new(var_7_13)

	local var_7_14 = itertools.size(var_7_9) - 1

	var_7_13 = var_7_14 < var_7_13 and var_7_14 or var_7_13
	arg_7_0.showTab = idler.new(var_7_13)

	for iter_7_5 = 0, var_7_13 do
		var_7_9[iter_7_5].isLock = false
	end

	for iter_7_6 = var_7_13 + 1, var_7_14 do
		var_7_9[iter_7_6].isLock = true
	end

	arg_7_0.dayData = idlers.newWithMap(var_7_9)
	arg_7_0.tabIndex = idler.new(0)

	arg_7_0.showTab:addListener(function(arg_9_0, arg_9_1)
		arg_7_0.dayData:atproxy(arg_9_1).selected = false
		arg_7_0.dayData:atproxy(arg_9_0).selected = true

		local var_9_0 = clone(var_7_8[arg_9_0])
		local var_9_1 = arg_7_0.tabIndex:read()

		if var_9_1 == -1 then
			for iter_9_0, iter_9_1 in pairs(var_9_0) do
				iter_9_1.selected = false
			end
		else
			for iter_9_2, iter_9_3 in pairs(var_9_0) do
				iter_9_3.selected = var_9_1 == iter_9_2
			end
		end

		if not arg_7_0.tabData then
			arg_7_0.tabData = idlers.newWithMap(var_9_0)
		else
			arg_7_0.tabData:update(var_9_0)
		end

		if var_9_0[var_9_1] and var_9_0[var_9_1][1].cfg.taskType == var_7_6 then
			local var_9_2 = var_9_0[var_9_1][1].id

			arg_7_0.serverOpenItemBuy:modify(function(arg_10_0)
				arg_10_0[var_9_2] = true
			end, true)
		end
	end)

	arg_7_0.subViews = {}

	local var_7_15 = 0
	local var_7_16 = {
		[var_0_2] = {
			viewName = "city.activity.server_open.placard"
		},
		[var_7_6] = {
			viewName = "city.activity.server_open.discount"
		},
		[var_7_15] = {
			viewName = "city.activity.server_open.get"
		}
	}

	arg_7_0.tabIndex:addListener(function(arg_11_0, arg_11_1)
		if arg_11_1 ~= var_0_2 and arg_7_0.tabData:at(arg_11_1) then
			arg_7_0.tabData:atproxy(arg_11_1).selected = false
		end

		for iter_11_0, iter_11_1 in pairs(arg_7_0.subViews) do
			iter_11_1:hide()
		end

		local var_11_0 = var_0_2

		if arg_11_0 ~= var_0_2 then
			local var_11_1 = arg_7_0.tabData:atproxy(arg_11_0)[1].cfg.taskType == var_7_6

			arg_7_0.tabData:atproxy(arg_11_0).selected = true

			if var_11_1 then
				var_11_0 = var_7_6

				local var_11_2 = arg_7_0.tabData:atproxy(arg_11_0)[1].id

				arg_7_0.serverOpenItemBuy:modify(function(arg_12_0)
					arg_12_0[var_11_2] = true
				end, true)
			else
				var_11_0 = var_7_15
			end
		end

		if not arg_7_0.subViews[var_11_0] then
			arg_7_0.subViews[var_11_0] = gGameUI:createView(var_7_16[var_11_0].viewName, arg_7_0:getResourceNode()):init(arg_7_1, var_7_8, arg_7_0:createHandler("sendParams")):x(display.uiOrigin.x)
		else
			arg_7_0.subViews[var_11_0]:show()
		end
	end)
	arg_7_0:countDown(var_7_11)

	if arg_7_0.clientType == "springFestival" then
		var_7_16[var_0_2].viewName = "city.activity.server_open.placard_spring_festival"

		text.addEffect(arg_7_0.timeLabel, {
			outline = {
				size = 3,
				color = ui.COLORS.WHITE
			},
			color = ui.COLORS.NORMAL.RED
		})
		text.addEffect(arg_7_0.time, {
			outline = {
				color = ui.COLORS.NORMAL.RED
			},
			color = ui.COLORS.WHITE
		})
	end

	if arg_7_0.clientType == "mayDay" or arg_7_0.clientType == "vacation" then
		var_7_16[var_0_2].viewName = "city.activity.server_open.placard_may_day"

		local var_7_17 = ui.COLORS.NORMAL.RED

		if arg_7_0.clientType == "vacation" then
			var_7_17 = cc.c3b(0, 151, 242)
		end

		text.addEffect(arg_7_0.timeLabel, {
			outline = {
				size = 3,
				color = ui.COLORS.WHITE
			},
			color = var_7_17
		})
		text.addEffect(arg_7_0.time, {
			outline = {
				color = var_7_17
			},
			color = ui.COLORS.WHITE
		})
	end

	if arg_7_0.clientType == "national" then
		var_7_16[var_0_2].viewName = "city.activity.server_open.placard_national_mid_autumn"

		text.addEffect(arg_7_0.timeLabel, {
			outline = {
				size = 5,
				color = ui.COLORS.WHITE
			},
			color = cc.c3b(208, 98, 15)
		})
		text.addEffect(arg_7_0.time, {
			outline = {
				color = cc.c3b(241, 187, 70)
			},
			color = ui.COLORS.WHITE
		})
	end

	if arg_7_0.clientType == "doubleYearsDay" then
		var_7_16[var_0_2].viewName = "city.activity.server_open.placard_double_years_day"

		text.addEffect(arg_7_0.timeLabel, {
			outline = {
				size = 4,
				color = ui.COLORS.WHITE
			},
			color = cc.c3b(59, 183, 132)
		})
		text.addEffect(arg_7_0.time, {
			outline = {
				color = cc.c3b(59, 183, 132)
			},
			color = ui.COLORS.WHITE
		})
		text.addEffect(arg_7_0.leftPanel:get("iconBg.text2"), {
			outline = {
				size = 4,
				color = cc.c3b(236, 82, 113)
			}
		})
	end

	if arg_7_0.clientType == "anniversary" then
		var_7_16[var_0_2].viewName = "city.activity.server_open.placard_anniversary"

		text.addEffect(arg_7_0.timeLabel, {
			outline = {
				size = 4,
				color = cc.c3b(199, 40, 19)
			},
			color = cc.c3b(245, 239, 217)
		})
		text.addEffect(arg_7_0.time, {
			outline = {
				size = 4,
				color = cc.c3b(77, 94, 67)
			},
			color = cc.c3b(165, 247, 57)
		})
		text.addEffect(arg_7_0.leftPanel:get("iconBg.text2"), {
			outline = {
				size = 4,
				color = cc.c3b(236, 82, 113)
			}
		})
	end

	Dialog.onCreate(arg_7_0, {
		blackType = 1
	})
end

function var_0_4.sendParams(arg_13_0)
	return arg_13_0.currDay, arg_13_0.showTab, arg_13_0.tabIndex
end

function var_0_4.onTabClick(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	arg_14_0.tabIndex:set(arg_14_2, true)
end

function var_0_4.onDayClick(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = arg_15_0.tabIndex:read()

	if not arg_15_0.data[arg_15_2][var_15_0] then
		arg_15_0.tabIndex:set(0, true)
	end

	arg_15_0.showTab:set(arg_15_2, true)
end

function var_0_4.onShowPlacard(arg_16_0)
	arg_16_0.tabIndex:set(var_0_2, true)
end

function var_0_4.countDown(arg_17_0, arg_17_1)
	arg_17_0:unSchedule(1)

	local var_17_0 = time.getTime() - arg_17_1

	arg_17_0:schedule(function()
		var_17_0 = var_17_0 - 1

		if var_17_0 <= 0 then
			return false
		else
			local var_18_0 = tonumber(time.getCutDown(var_17_0).day)

			arg_17_0.currDay:set(var_18_0)

			var_18_0 = var_18_0 > arg_17_0.dayData:size() - 1 and arg_17_0.dayData:size() - 1 or var_18_0

			for iter_18_0 = 0, var_18_0 do
				if arg_17_0.dayData:atproxy(iter_18_0).isLock ~= false then
					arg_17_0.dayData:atproxy(iter_18_0).isLock = false
				end
			end
		end
	end, 1, 1, 1)
end

function var_0_4.onAfterBuild(arg_19_0)
	arg_19_0.topList:jumpToItem(arg_19_0.showTab:read(), cc.p(1, 0), cc.p(1, 0))
end

return var_0_4
