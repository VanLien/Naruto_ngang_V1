local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("gymBadgeGuardView", var_0_0)

var_0_1.RESOURCE_FILENAME = "gym_badge_guard.json"
var_0_1.RESOURCE_BINDING = {
	subList = "subList",
	item = "item",
	item2 = "item2",
	text2 = "text2",
	text1 = "text1",
	slider = "slider",
	text3 = "text3",
	item1 = "item1",
	["item.btn1.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE
				}
			}
		}
	},
	["item.btn2.txt"] = {
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
	["item.btnPanel.btn.txt"] = {
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
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 3,
				data = bindHelper.self("guardData"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				sliderBg = bindHelper.self("slider"),
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("bgPanel", "textAttr", "icon1", "icon", "rarity", "btn1", "btn2", "add", "txt", "btnPanel")

					arg_1_0:setScrollBarEnabled(false)
					arg_1_1:setTouchEnabled(true)

					local var_1_1 = var_1_0.bgPanel:get("skinAction")

					bind.touch(arg_1_0, var_1_0.bgPanel, {
						methods = {
							ended = functools.partial(arg_1_0.showDetail, arg_1_1, arg_1_0:getIdx(arg_1_2).k, arg_1_3)
						}
					})
					var_1_0.bgPanel:get("add"):hide()
					var_1_0.txt:hide()
					var_1_0.btnPanel:hide()
					var_1_0.bgPanel:removeChildByName("suoEffect")

					if arg_1_3.id ~= 0 then
						var_1_0.textAttr:show()
						var_1_0.rarity:show()
						var_1_0.icon:show()
						var_1_0.btn1:show()
						var_1_0.btn2:show()
						var_1_0.bgPanel:get("bg"):show()
						var_1_0.bgPanel:get("bg1"):hide()
						var_1_0.bgPanel:get("imgCk"):show()

						local var_1_2 = dataEasy.getUnitCsv(arg_1_3.id, arg_1_3.skinId)

						if var_1_1 then
							var_1_1:removeFromParent()
						end

						var_1_1 = widget.addAnimation(var_1_0.bgPanel, var_1_2.unitRes, "standby_loop", 11):scale(1.4):xy(190, 130):name("skinAction")

						var_1_1:setSkin(var_1_2.skin)
						var_1_0.textAttr:text(var_1_2.name)
						var_1_0.rarity:texture(ui.RARITY_ICON[var_1_2.rarity])
						var_1_0.icon:texture(ui.ATTR_ICON[var_1_2.natureType])

						if var_1_2.natureType2 then
							var_1_0.icon1:show()
							var_1_0.icon1:texture(ui.ATTR_ICON[var_1_2.natureType2])
						else
							var_1_0.icon1:hide()
						end

						adapt.oneLineCenterPos(cc.p(300, 133), {
							var_1_0.rarity,
							var_1_0.textAttr,
							var_1_0.icon,
							var_1_0.icon1
						}, cc.p(15, 0))
						bind.touch(arg_1_0, var_1_0.btn1, {
							methods = {
								ended = functools.partial(arg_1_0.chanceSetUp, arg_1_0:getIdx(arg_1_2).k, arg_1_3)
							}
						})
						bind.touch(arg_1_0, var_1_0.btn2, {
							methods = {
								ended = functools.partial(arg_1_0.setUp, arg_1_0:getIdx(arg_1_2).k, arg_1_3)
							}
						})
					else
						var_1_0.textAttr:hide()
						var_1_0.rarity:hide()
						var_1_0.icon:hide()
						var_1_0.icon1:hide()
						var_1_0.btn1:hide()
						var_1_0.btn2:hide()
						var_1_0.bgPanel:get("bg"):hide()
						var_1_0.bgPanel:get("bg1"):show()
						var_1_0.bgPanel:get("imgCk"):hide()

						if var_1_1 then
							var_1_1:hide()
						end

						if arg_1_3.isOpen == true then
							var_1_0.bgPanel:get("add"):show()
							var_1_0.txt:show()
							var_1_0.txt:text(gLanguageCsv.choosePokemon)
						elseif arg_1_3.isFee == true then
							widget.addAnimationByKey(var_1_0.bgPanel, "daoguanhuizhang/jiesuo.skel", "suoEffect", "suo_loop", 1):xy(190, 180):scale(2)
							var_1_0.btnPanel:show()
							bind.touch(arg_1_0, var_1_0.btnPanel:get("btn"), {
								methods = {
									ended = functools.partial(arg_1_0.openLock, arg_1_1, arg_1_0:getIdx(arg_1_2).k, arg_1_3)
								}
							})

							local var_1_3 = ""

							for iter_1_0, iter_1_1 in ipairs(arg_1_3.openCost) do
								if iter_1_1.key == "rmb" then
									if iter_1_1.bool then
										var_1_3 = var_1_3 .. "#C0xFFFFFF#" .. iter_1_1.num .. " #Icommon/icon/icon_diamond.png-56-56# "
									else
										var_1_3 = var_1_3 .. "#C0xF13B54#" .. iter_1_1.num .. " #Icommon/icon/icon_diamond.png-56-56# "
									end
								elseif iter_1_1.key == "gold" then
									if iter_1_1.bool then
										var_1_3 = var_1_3 .. "#C0xFFFFFF#" .. iter_1_1.num .. "# Icommon/icon/icon_gold.png-56-56# "
									else
										var_1_3 = var_1_3 .. "#C0xF13B54#" .. iter_1_1.num .. " #Icommon/icon/icon_gold.png-56-56# "
									end
								elseif iter_1_1.bool then
									var_1_3 = var_1_3 .. "#C0xFFFFFF#" .. iter_1_1.num .. " #I" .. iter_1_1.icon .. "-56-56# "
								else
									var_1_3 = var_1_3 .. "#C0xF13B54#" .. iter_1_1.num .. " #I" .. iter_1_1.icon .. "-56-56# "
								end
							end

							local var_1_4 = rich.createWithWidth("#C0xFFFFFF#" .. var_1_3, 40, nil, 1250):addTo(var_1_0.btnPanel, 10):anchorPoint(cc.p(0, 0.5)):formatText()

							adapt.oneLineCenterPos(cc.p(722, 124), {
								var_1_0.btnPanel:get("text1"),
								var_1_4
							}, cc.p(15, 0))
							arg_1_1:setTouchEnabled(false)
						else
							widget.addAnimationByKey(var_1_0.bgPanel, "daoguanhuizhang/jiesuo.skel", "suoEffect", "suo_loop", 1):xy(190, 180):scale(2)
							var_1_0.txt:show()

							if arg_1_3.isComeOpen then
								var_1_0.txt:text(gLanguageCsv.comingSoon)
							else
								var_1_0.txt:text(string.format(gLanguageCsv.awakeLevelToOpen, arg_1_3.openParam))
							end
						end
					end
				end,
				onAfterBuild = function(arg_2_0)
					if #arg_2_0:getChildren() > 2 then
						arg_2_0.sliderBg:show()

						local var_2_0, var_2_1 = arg_2_0:xy()
						local var_2_2 = arg_2_0:size()
						local var_2_3 = arg_2_0.sliderBg:size()

						arg_2_0.sliderBg:x(var_2_0 + var_2_2.width - 50)
						arg_2_0:setScrollBarEnabled(true)
						arg_2_0:setScrollBarColor(cc.c3b(245, 156, 2))
						arg_2_0:setScrollBarOpacity(255)
						arg_2_0:setScrollBarAutoHideEnabled(false)
						arg_2_0:setScrollBarPositionFromCorner(cc.p(50, (var_2_2.height - var_2_3.height) / 2))
						arg_2_0:setScrollBarWidth(var_2_3.width)
						arg_2_0:refreshView()
					else
						arg_2_0.sliderBg:hide()
						arg_2_0:setScrollBarEnabled(false)
					end
				end
			},
			handlers = {
				chanceSetUp = bindHelper.self("onChanceSetUp"),
				setUp = bindHelper.self("onSetUp"),
				openLock = bindHelper.self("onOpenLock"),
				showDetail = bindHelper.self("onShowDetail")
			}
		}
	},
	list1 = {
		varname = "list1",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("badgeData"),
				item = bindHelper.self("item1"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					arg_3_1:get("icon"):texture(arg_3_3.icon)

					if not arg_3_3.isOpen then
						arg_3_1:get("mask"):show()
					else
						arg_3_1:get("mask"):hide()
					end

					if arg_3_3.isSel then
						arg_3_1:get("redIcon"):show()
					else
						arg_3_1:get("redIcon"):hide()
					end

					bind.touch(arg_3_0, arg_3_1, {
						methods = {
							ended = functools.partial(arg_3_0.chooseBadge, arg_3_2, arg_3_3)
						}
					})
				end,
				preloadCenterIndex = bindHelper.self("curIndex")
			},
			handlers = {
				chooseBadge = bindHelper.self("onChooseBadge")
			}
		}
	},
	list2 = {
		varname = "list2",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("natureData"),
				item = bindHelper.self("item2"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					arg_4_1:get("icon"):texture(ui.ATTR_ICON[arg_4_3])
				end
			},
			handlers = {}
		}
	}
}

function var_0_1.onCreate(arg_5_0, arg_5_1)
	arg_5_0.badgeNumb = idler.new(arg_5_1)
	arg_5_0.badgeData = idlers.new()
	arg_5_0.guardData = idlers.new()
	arg_5_0.natureData = idlers.new()
	arg_5_0.curIndex = arg_5_1

	arg_5_0:initModel()
	gGameUI.topuiManager:createView("default", arg_5_0, {
		onClose = arg_5_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = "common/txt/txt_bt_renzheshouhu.png"
	})

	local var_5_0 = csv.gym_badge.guard
	local var_5_1 = csv.gym_badge.badge
	local var_5_2 = csv.items

	idlereasy.any({
		arg_5_0.rmb,
		arg_5_0.gold,
		arg_5_0.badgeNumb,
		arg_5_0.badges,
		arg_5_0.items
	}, function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
		local var_6_0 = arg_6_4 and arg_6_4[arg_6_3] or {}
		local var_6_1 = var_6_0.guards or {}
		local var_6_2 = var_6_0.awake or 0
		local var_6_3 = var_6_0.positions or {}
		local var_6_4 = {}
		local var_6_5 = var_5_1[arg_6_3].guardIDs

		for iter_6_0, iter_6_1 in ipairs(var_6_5) do
			local var_6_6 = 0
			local var_6_7 = 0
			local var_6_8 = false
			local var_6_9 = false
			local var_6_10 = {}
			local var_6_11 = var_5_0[iter_6_1]
			local var_6_12 = dataEasy.getItemData(var_6_11.openCost)

			if var_6_11.isOpen == true then
				if var_6_1[iter_6_1] then
					local var_6_13 = gGameModel.cards:find(var_6_1[iter_6_1])

					if var_6_13 then
						var_6_6 = var_6_13:read("card_id")
						var_6_7 = var_6_13:read("skin_id")
					end
				end

				if var_6_11.openParam == 0 or var_6_3[iter_6_1] then
					var_6_8 = true
				elseif var_6_11.openCondition == 1 and var_6_2 >= var_6_11.openParam then
					var_6_9 = true

					for iter_6_2, iter_6_3 in ipairs(var_6_12) do
						if iter_6_3.key == "rmb" then
							table.insert(var_6_10, {
								key = iter_6_3.key,
								bool = arg_6_1 >= iter_6_3.num,
								num = iter_6_3.num
							})
						elseif iter_6_3.key == "gold" then
							table.insert(var_6_10, {
								key = iter_6_3.key,
								bool = arg_6_2 >= iter_6_3.num,
								num = iter_6_3.num
							})
						else
							table.insert(var_6_10, {
								key = iter_6_3.key,
								bool = arg_6_5[iter_6_3.key] and arg_6_5[iter_6_3.key] >= iter_6_3.num,
								num = iter_6_3.num,
								icon = var_5_2[iter_6_3.key].icon
							})
						end
					end
				end

				table.insert(var_6_4, {
					isComeOpen = false,
					selectDbId = var_6_1[iter_6_1],
					id = var_6_6,
					skinId = var_6_7,
					isOpen = var_6_8,
					isFee = var_6_9,
					openParam = var_6_11.openParam,
					openCost = var_6_10,
					guardId = iter_6_1
				})
			else
				table.insert(var_6_4, {
					isComeOpen = true,
					id = var_6_6,
					isFee = var_6_9,
					isOpen = var_6_8,
					guardId = iter_6_1
				})
			end
		end

		if #var_6_4 > 6 then
			arg_5_0.slider:show()
		else
			arg_5_0.slider:hide()
		end

		if arg_5_0.guardData:size() ~= #var_6_4 then
			arg_5_0.guardData:update(var_6_4)
		else
			for iter_6_4, iter_6_5 in ipairs(var_6_4) do
				arg_5_0.guardData:at(iter_6_4):set(iter_6_5)
			end
		end
	end)

	local var_5_3 = {}

	idlereasy.when(arg_5_0.badgeNumb, function(arg_7_0, arg_7_1)
		arg_5_0.natureData:update(var_5_1[arg_7_1].nature)

		local var_7_0 = 0

		for iter_7_0, iter_7_1 in pairs(var_5_1[arg_7_1].nature) do
			var_7_0 = var_7_0 + 1
		end

		for iter_7_2, iter_7_3 in ipairs(var_5_1) do
			local var_7_1 = arg_5_0:badgeIsOpen(iter_7_2)

			table.insert(var_5_3, {
				icon = iter_7_3.icon,
				isOpen = var_7_1,
				isSel = iter_7_2 == arg_7_1
			})
		end

		local var_7_2 = arg_5_0.item2:size().width

		arg_5_0.list2:size(var_7_0 * var_7_2, 80)
		adapt.oneLinePos(arg_5_0.text1, {
			arg_5_0.list2,
			arg_5_0.text2,
			arg_5_0.text3
		}, {
			cc.p(5, 0),
			cc.p(0, 0)
		}, "left")
	end)
	arg_5_0.badgeData:update(var_5_3)
end

function var_0_1.initModel(arg_8_0)
	arg_8_0.rmb = gGameModel.role:getIdler("rmb")
	arg_8_0.gold = gGameModel.role:getIdler("gold")
	arg_8_0.badges = gGameModel.role:getIdler("badges")
	arg_8_0.items = gGameModel.role:getIdler("items")
end

function var_0_1.onChanceSetUp(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	gGameApp:requestServer("/game/badge/guard/setup", nil, arg_9_0.badgeNumb:read(), arg_9_3.guardId, -1)
	gGameUI:showTip(gLanguageCsv.alreadyCancelGuard)
end

function var_0_1.onSetUp(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	gGameUI:stackUI("city.develop.gym_badge.guard_choose", nil, nil, {
		setType = 1,
		key = arg_10_3.guardId,
		badgeNumb = arg_10_0.badgeNumb:read()
	})
end

function var_0_1.onShowDetail(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	if arg_11_4.id ~= 0 then
		local var_11_0 = gGameUI:stackUI("city.develop.gym_badge.guard_detail", nil, {
			blackLayer = false,
			clickClose = true,
			dispatchNodes = arg_11_0.list
		}, {
			selectDbId = arg_11_4.selectDbId,
			badgeNumb = arg_11_0.badgeNumb:read()
		})

		tip.adaptView(var_11_0, arg_11_0, {
			canvasDir = "horizontal",
			relativeNode = arg_11_2:get("bgPanel"),
			childsName = {
				"baseNode"
			}
		})
	elseif arg_11_4.isOpen == true then
		gGameUI:stackUI("city.develop.gym_badge.guard_choose", nil, nil, {
			setType = 0,
			key = arg_11_4.guardId,
			badgeNumb = arg_11_0.badgeNumb:read()
		})
	elseif arg_11_4.isFee == false then
		if arg_11_4.isComeOpen then
			gGameUI:showTip(gLanguageCsv.comingSoon)
		else
			gGameUI:showTip(string.format(gLanguageCsv.awakeLevelToOpen, arg_11_4.openParam))
		end
	end
end

function var_0_1.onChooseBadge(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = csv.gym_badge.badge
	local var_12_1 = var_12_0[arg_12_2].preBadgeID
	local var_12_2 = var_12_0[arg_12_2].preBadgeType

	if arg_12_3.isOpen then
		arg_12_0.badgeNumb:set(arg_12_2)

		local var_12_3 = csv.gym_badge.badge

		for iter_12_0, iter_12_1 in ipairs(var_12_3) do
			if iter_12_0 ~= arg_12_2 then
				arg_12_0.badgeData:atproxy(iter_12_0).isSel = false
			else
				arg_12_0.badgeData:atproxy(iter_12_0).isSel = true
			end
		end
	elseif var_12_2 == 1 then
		gGameUI:showTip(string.format(gLanguageCsv.noOpenPleaseToGymView1, var_12_0[var_12_1].name, var_12_0[arg_12_2].preLevel))
	else
		gGameUI:showTip(string.format(gLanguageCsv.noOpenPleaseToGymView2, var_12_0[var_12_1].name, var_12_0[arg_12_2].preLevel))
	end
end

function var_0_1.onOpenLock(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	local var_13_0 = ""

	for iter_13_0, iter_13_1 in ipairs(arg_13_4.openCost) do
		if iter_13_1.key == "rmb" then
			if iter_13_1.bool then
				var_13_0 = var_13_0 .. "#C0x8A5B0C#" .. iter_13_1.num .. " #Icommon/icon/icon_diamond.png-64-64# "
			else
				var_13_0 = var_13_0 .. "#C0xF13B54#" .. iter_13_1.num .. " #Icommon/icon/icon_diamond.png-64-64# "

				uiEasy.showDialog("rmb", nil, {
					dialog = true
				})

				return
			end
		elseif iter_13_1.key == "gold" then
			if iter_13_1.bool then
				var_13_0 = var_13_0 .. "#C0x8A5B0C#" .. iter_13_1.num .. "# Icommon/icon/icon_gold.png-56-56# "
			else
				var_13_0 = var_13_0 .. "#C0xF13B54#" .. iter_13_1.num .. " #Icommon/icon/icon_gold.png-56-56# "

				uiEasy.showDialog("gold", nil, {
					dialog = true
				})

				return
			end
		elseif iter_13_1.bool then
			var_13_0 = var_13_0 .. "#C0x8A5B0C#" .. iter_13_1.num .. " #I" .. iter_13_1.icon .. "-56-56# "
		else
			var_13_0 = var_13_0 .. "#C0xF13B54#" .. iter_13_1.num .. " #I" .. iter_13_1.icon .. "-56-56# "

			gGameUI:showTip(gLanguageCsv.itemNotEnoughtGuard)

			return
		end
	end

	local var_13_1 = "#C0x57472E#" .. gLanguageCsv.consumptionOrNot .. " " .. var_13_0 .. "#C0x57472E#" .. gLanguageCsv.openGuardsText

	gGameUI:showDialog({
		btnType = 2,
		isRich = true,
		content = var_13_1,
		cb = function()
			arg_13_2:get("bgPanel"):removeChildByName("suoEffect")

			local var_14_0 = {
				false
			}

			gGameApp:requestServerCustom("/game/badge/guard/unlock"):params(arg_13_0.badgeNumb:read(), arg_13_4.guardId):onResponse(function()
				widget.addAnimationByKey(arg_13_2, "daoguanhuizhang/jiesuo.skel", "suoEffect", "jiesuo_effect", 2):xy(300, 270):scale(2):play("jiesuo_effect")
				performWithDelay(arg_13_0, function()
					var_14_0[1] = true
				end, 0.8666666666666667)
			end):wait(var_14_0):doit()
		end,
		dialogParams = {
			clickClose = false
		}
	})
end

function var_0_1.badgeIsOpen(arg_17_0, arg_17_1)
	local var_17_0 = csv.gym_badge.badge
	local var_17_1 = var_17_0[arg_17_1].preBadgeID
	local var_17_2 = var_17_0[arg_17_1].preBadgeType

	if var_17_1 then
		local var_17_3 = arg_17_0.badges:read() and arg_17_0.badges:read()[var_17_1] or {}
		local var_17_4 = var_17_3.awake or 0

		if var_17_2 == 1 then
			if var_17_4 < var_17_0[arg_17_1].preLevel then
				return false
			else
				return true
			end
		else
			local var_17_5 = csv.gym_badge.badge[var_17_1].talentIDs[6]
			local var_17_6 = var_17_3.talents

			if (var_17_6 and var_17_6[var_17_5] or 0) < var_17_0[arg_17_1].preLevel then
				return false
			else
				return true
			end
		end
	else
		return true
	end
end

return var_0_1
