local var_0_0 = class("TrainerView", cc.load("mvc").ViewBase)
local var_0_1 = {
	OPEN = 1,
	NOT_OPEN = 0
}
local var_0_2 = ""
local var_0_3 = {
	game.PRIVILEGE_TYPE.FirstRMBDrawCardHalf,
	game.PRIVILEGE_TYPE.BattleSkip,
	game.PRIVILEGE_TYPE.ExpItemCostFallRate,
	game.PRIVILEGE_TYPE.TrainerAttrSkills,
	game.PRIVILEGE_TYPE.GateSaoDangTimes,
	game.PRIVILEGE_TYPE.DrawItemFreeTimes,
	game.PRIVILEGE_TYPE.FirstRMBDrawItemHalf
}
local var_0_4 = {
	game.PRIVILEGE_TYPE.StaminaMax,
	game.PRIVILEGE_TYPE.StaminaBuyTimes,
	game.PRIVILEGE_TYPE.LianjinBuyTimes,
	game.PRIVILEGE_TYPE.DailyTaskExpRate,
	game.PRIVILEGE_TYPE.HuodongTypeGoldTimes,
	game.PRIVILEGE_TYPE.HuodongTypeExpTimes,
	game.PRIVILEGE_TYPE.ExpItemCostFallRate
}

var_0_0.ADD_SHOW = var_0_4
var_0_0.ARROW_NOT_SHOW = var_0_3
var_0_0.RESOURCE_FILENAME = "trainer_view.json"
var_0_0.RESOURCE_BINDING = {
	sliderBg = "sliderBg",
	Panel_sjhd = "awardPanel",
	exp = "exp",
	panel = "panel",
	["centerTip.arrow"] = "centerArrow",
	["centerTip.txt"] = "centerTxt",
	num = "coinNum",
	txt1 = "coinTxt",
	icon = "coinIcon",
	["centerTip.num"] = "centerNum",
	item2 = "item2",
	totalExp = "totalExp",
	item = "item",
	mask = "mask",
	txt = "txt",
	["centerTip.bg"] = "centerBg",
	["Panel_sjhd.List"] = "awardList",
	topList = {
		varname = "topList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("topData"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("panel")

					var_1_0:visible(arg_1_3.isNil ~= true)

					if not arg_1_3.originY then
						arg_1_3.originY = var_1_0:y()
					end

					local var_1_1 = var_1_0:multiget("icon", "btnBox", "lock", "btnUp", "lockPanel", "bg")

					if arg_1_3.isBig then
						var_1_0:scale(1.2)
						var_1_0:setCascadeOpacityEnabled(true)
						var_1_0:setOpacity(255)
						var_1_0:y(arg_1_3.originY)
					else
						var_1_0:scale(1.1)
						var_1_0:setCascadeOpacityEnabled(true)
						var_1_0:setOpacity(230)
						var_1_0:y(arg_1_3.originY - 30)
					end

					if not arg_1_3.isNil then
						var_1_1.icon:hide()

						local var_1_2 = var_1_0:size()

						var_1_1.bg:texture("config/trainer/trainer_" .. arg_1_3.id .. ".png")

						if arg_1_3.level then
							local var_1_3 = arg_1_3.level == arg_1_3.id and not arg_1_3.isGet

							var_1_1.btnBox:visible(var_1_3)
							var_1_1.btnBox:get("icon"):texture(arg_1_3.isGet and "common/icon/icon_box1_open.png" or "common/icon/icon_box1.png")

							if var_1_1.btnBox:get("spine") then
								var_1_1.btnBox:get("spine"):removeFromParent()
							end

							if var_1_3 then
								widget.addAnimationByKey(var_1_1.btnBox, "effect/jiedianjiangli.skel", "spine", "effect_loop", -1):scale(0.5):xy(var_1_1.btnBox:size().width / 2, 80)
							end

							uiEasy.addVibrateToNode(arg_1_0, var_1_1.btnBox, var_1_3, arg_1_1:getName() .. arg_1_2 .. "vibrate")
							text.addEffect(var_1_1.btnBox:get("txt"), {
								outline = {
									color = ui.NEWCOLORS.OUTLINE.BLACK
								}
							})

							if not arg_1_3.unLock then
								cache.setShader(var_1_1.bg, false, arg_1_3.level < arg_1_3.id and "hsl_gray" or "normal")
								var_1_1.lock:visible(arg_1_3.level < arg_1_3.id)
							else
								itertools.invoke({
									var_1_1.lock
								}, "hide")

								local var_1_4 = widget.addAnimation(var_1_1.lockPanel, "xunlianshi1/xunblianshi1.skel", "jiesuo", 100):xy(var_1_1.lockPanel:size().width / 2, var_1_1.lockPanel:size().height / 2)
							end
						end
					end

					if arg_1_3.isUp == true and arg_1_3.upShow then
						arg_1_3.spine = widget.addAnimation(arg_1_1, "xunlianshi1/xunblianshi1.skel", "jinjieup_loop", 100):xy(340, 200)

						local var_1_5 = cc.Label:createWithTTF(var_0_2, ui.FONT_PATH, 45, cc.size(0, 0), cc.TEXT_ALIGNMENT_CENTER)

						var_1_5:setTextColor(ui.COLORS.NORMAL.WHITE)
						var_1_5:align(cc.p(0.5, 0.5), 0, 0):addTo(arg_1_3.spine, 1):xy(-45, 25)
					elseif arg_1_3.spine then
						arg_1_3.spine:removeSelf()

						arg_1_3.spine = nil
					end

					if arg_1_3.isUp == true and arg_1_3.upShow and arg_1_3.upTouchEnabled then
						var_1_1.btnUp:setTouchEnabled(true)
					else
						var_1_1.btnUp:setTouchEnabled(false)
					end

					bind.touch(arg_1_0, var_1_1.btnUp, {
						methods = {
							ended = functools.partial(arg_1_0.clickUp, arg_1_3)
						}
					})
					bind.touch(arg_1_0, var_1_1.btnBox, {
						methods = {
							ended = functools.partial(arg_1_0.clickBox, arg_1_3)
						}
					})
				end,
				preloadCenter = bindHelper.self("topCenter")
			},
			handlers = {
				clickUp = bindHelper.self("onItemUpClick"),
				clickBox = bindHelper.self("onItemBoxClick")
			}
		}
	},
	btnLeft = {
		varname = "btnLeft",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onLeftClick")
				}
			}
		}
	},
	btnRight = {
		varname = "btnRight",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onRightClick")
				}
			}
		}
	},
	btnAttr = {
		varname = "btnAttr",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onAttrClick")
				}
			}
		}
	},
	["btnAttr.txt"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			}
		}
	},
	["btnNext.txt"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			}
		}
	},
	["btnNext.txt1"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			}
		}
	},
	btnNext = {
		varname = "btnNext",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onAttrNextClick")
				}
			}
		}
	},
	slider = {
		varname = "slider",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				maskImg = "common/icon/mask_bar_red.png",
				data = bindHelper.self("barPoint")
			}
		}
	},
	btnDetail = {
		varname = "coinDetail",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onCoinDetail")
				}
			}
		}
	},
	Button_tqb = {
		varname = "btnTqb",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onGainTqb")
				}
			}
		}
	},
	bottomList = {
		varname = "bottomList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("bottomData"),
				item = bindHelper.self("item2"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = csv.trainer.skills[arg_2_3.id]
					local var_2_1 = arg_2_1:multiget("icon", "name", "desc", "desc1", "lv", "btnUp", "flag")

					var_2_1.name:text(var_2_0.name)
					var_2_1.icon:texture(var_2_0.icon):scale(1.5)
					var_2_1.desc:text(var_2_0.desc1 .. ":")
					var_2_1.desc1:text(var_2_0.desc2)

					if matchLanguage({
						"cn",
						"tw",
						"kr"
					}) then
						adapt.oneLinePos(var_2_1.desc, var_2_1.desc1)
					elseif matchLanguage({
						"en"
					}) then
						adapt.oneLinePos(var_2_1.desc, var_2_1.desc1, cc.p(-5, 0))
						adapt.oneLinePos(var_2_1.desc1, var_2_1.desc, cc.p(0, 0), "right")
					end

					if arg_2_3.level then
						var_2_1.lv:text("Lv" .. arg_2_3.level .. "/Lv" .. var_2_0.levelMax)

						local var_2_2 = arg_2_3.state == var_0_1.NOT_OPEN

						var_2_1.flag:texture(var_2_2 and "city/develop/train/img_wks.png" or "city/develop/train/ima_ymj.png")
						var_2_1.btnUp:visible(not var_2_2 and arg_2_3.level < var_2_0.levelMax)
						var_2_1.flag:visible(var_2_2 and arg_2_3.level < var_2_0.levelMax)

						local var_2_3 = math.min(arg_2_3.level == 0 and 1 or arg_2_3.level, var_2_0.levelMax)
						local var_2_4 = var_2_0.nums[var_2_3]
						local var_2_5 = string.find(tostring(var_2_4), ".", 1, true) ~= nil

						if var_2_5 then
							var_2_4 = var_2_4 * 100
						end

						var_2_1.desc1:text(string.format(var_2_0.desc2, var_2_4) .. (var_2_5 and "%" or ""))
					end

					text.addEffect(var_2_1.btnUp:get("txt"), {
						outline = {
							size = 3,
							color = ui.NEWCOLORS.OUTLINE.YELLOW
						}
					})
					bind.touch(arg_2_0, var_2_1.btnUp, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_3)
						}
					})
				end,
				onAfterBuild = function(arg_3_0)
					arg_3_0:setTouchEnabled(#arg_3_0.data > 3)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onBottomItemClick")
			}
		}
	},
	btnjlyl = {
		varname = "btnjlyl",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onBtnJlyl")
				}
			}
		}
	}
}

function var_0_0.onCreate(arg_4_0)
	arg_4_0:initModel()
	gGameUI.topuiManager:createView("default", arg_4_0, {
		onClose = arg_4_0:createHandler("onClose")
	}):init({
		subTitle = "Trainer",
		title = "common/txt/txt_bt_renzheshouce.png"
	})

	local var_4_0 = {}

	table.insert(var_4_0, {
		isNil = true
	})

	for iter_4_0, iter_4_1 in orderCsvPairs(csv.trainer.trainer_level) do
		table.insert(var_4_0, {
			cfg = iter_4_1,
			id = iter_4_0,
			upShow = iter_4_0 ~= csvSize(csv.trainer.trainer_level)
		})
	end

	local var_4_1 = widget.addAnimation(arg_4_0.panel, "xunlianshi1/xunblianshi1.skel", "jinjiedown_loop", 100):xy(arg_4_0.panel:size().width / 2, arg_4_0.panel:size().height / 2)

	arg_4_0.barPoint = idler.new(0)

	table.insert(var_4_0, {
		isNil = true
	})

	arg_4_0.topCenter = idler.new(arg_4_0.trainerLevel:read() + 1)
	arg_4_0.topData = idlers.newWithMap(var_4_0)
	arg_4_0.bottomData = idlers.newWithMap({})

	local var_4_2

	local function var_4_3(arg_5_0, arg_5_1)
		if arg_5_1 == ccui.TouchEventType.began then
			var_4_2 = arg_5_0:getTouchBeganPosition().x
		elseif arg_5_1 == ccui.TouchEventType.ended then
			local var_5_0 = arg_5_0:getTouchEndPosition().x

			if math.abs(var_5_0 - var_4_2) > 5 then
				if var_5_0 > var_4_2 then
					arg_4_0.topCenter:set(arg_4_0.topCenter:read() > 2 and arg_4_0.topCenter:read() - 1 or 2)
				else
					arg_4_0.topCenter:set(arg_4_0.topCenter:read() <= arg_4_0.topData:size() - 2 and arg_4_0.topCenter:read() + 1 or arg_4_0.topData:size() - 1)
				end
			end
		end
	end

	idlereasy.any({
		arg_4_0.topCenter,
		arg_4_0.trainerLevel
	}, function(arg_6_0, arg_6_1, arg_6_2)
		local var_6_0 = {}

		for iter_6_0, iter_6_1 in ipairs(arg_4_0.topData:atproxy(arg_6_1).cfg.skills) do
			table.insert(var_6_0, {
				id = iter_6_1,
				level = arg_4_0.trainerSkills:read()[iter_6_1] or 0,
				state = arg_6_1 <= arg_6_2 + 1 and var_0_1.OPEN or var_0_1.NOT_OPEN
			})
		end

		local var_6_1 = dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.TrainerAttrSkills)

		arg_4_0.btnNext:get("lock"):visible(var_6_1 == 0)
		arg_4_0.btnNext:visible(csv.trainer.trainer_level[arg_6_2].isShowNext == 1)
		var_4_1:visible(arg_6_2 >= arg_4_0.topData:atproxy(arg_6_1).id)
		arg_4_0.bottomData:update(var_6_0)
	end)
	idlereasy.when(arg_4_0.trainerSkills, function(arg_7_0, arg_7_1)
		local var_7_0 = {}

		for iter_7_0, iter_7_1 in ipairs(arg_4_0.topData:atproxy(arg_4_0.topCenter:read()).cfg.skills) do
			arg_4_0.bottomData:atproxy(iter_7_0).level = arg_7_1[iter_7_1] or 0
		end
	end)
	arg_4_0.topCenter:addListener(function(arg_8_0, arg_8_1)
		arg_4_0.topData:atproxy(arg_8_1).upTouchEnabled = false
		arg_4_0.topData:atproxy(arg_8_0).upTouchEnabled = true
	end)

	arg_4_0.oldLevel = 0

	idlereasy.any({
		arg_4_0.topCenter,
		arg_4_0.trainerLevel
	}, function(arg_9_0, arg_9_1, arg_9_2)
		arg_4_0.btnLeft:visible(arg_9_1 ~= 2)
		arg_4_0.btnRight:visible(arg_9_1 ~= arg_4_0.topData:size() - 1)
		arg_4_0.topList:jumpToItem(arg_9_1, cc.p(1, 0), cc.p(1, 0))

		for iter_9_0, iter_9_1 in arg_4_0.topData:pairs() do
			iter_9_1:proxy().isBig = iter_9_0 == arg_9_1
		end

		local var_9_0, var_9_1 = csvNext(arg_4_0.topData:atproxy(arg_9_1).cfg.privilege)

		if not string.find(tostring(var_9_1), ".", 1, true) then
			arg_4_0.centerNum:text((itertools.first(var_0_4, var_9_0) ~= nil and "+" or "") .. var_9_1)
		else
			arg_4_0.centerNum:text((itertools.first(var_0_4, var_9_0) ~= nil and var_9_0 ~= game.PRIVILEGE_TYPE.ExpItemCostFallRate and "+" or "") .. var_9_1 * 100 .. "%")
		end

		local var_9_2 = ""

		if var_9_0 == game.PRIVILEGE_TYPE.BattleSkip then
			local var_9_3 = gLanguageCsv[game.SCENE_TYPE_STRING_TABLE[var_9_1]]

			var_9_2 = string.format(gLanguageCsv["trainerPrivilege" .. var_9_0], var_9_3)
		elseif var_9_0 == game.PRIVILEGE_TYPE.GateSaoDangTimes or var_9_0 == game.PRIVILEGE_TYPE.DrawItemFreeTimes then
			var_9_2 = string.format(gLanguageCsv["trainerPrivilege" .. var_9_0], var_9_1)
		else
			var_9_2 = gLanguageCsv["trainerPrivilege" .. var_9_0]
		end

		arg_4_0.centerTxt:text(var_9_2)

		var_0_2 = var_9_2

		local var_9_4 = 0

		if var_9_0 ~= 1 then
			var_9_4 = var_9_4 + arg_4_0.centerNum:size().width
		end

		if itertools.first(var_0_3, var_9_0) then
			arg_4_0.centerArrow:hide()

			if var_9_0 == game.PRIVILEGE_TYPE.ExpItemCostFallRate then
				arg_4_0.centerNum:show()
			else
				arg_4_0.centerNum:hide()
			end
		else
			arg_4_0.centerArrow:show()
			arg_4_0.centerNum:show()

			var_9_4 = var_9_4 + arg_4_0.centerArrow:getBoundingBox().width
		end

		local var_9_5 = var_9_4 + arg_4_0.centerTxt:size().width
		local var_9_6 = arg_4_0.centerBg:size()
		local var_9_7 = arg_4_0.centerBg:x()
		local var_9_8 = arg_4_0.centerBg:y()

		arg_4_0.centerTxt:xy(var_9_7 - (var_9_5 - 100) / 2 - 20, var_9_8)
		adapt.oneLinePos(arg_4_0.centerTxt, {
			arg_4_0.centerNum,
			arg_4_0.centerArrow
		})
		arg_4_0.bottomList:jumpToLeft()

		if arg_9_1 == arg_9_2 + 1 then
			local var_9_9 = csvSize(csv.trainer.trainer_level)
			local var_9_10 = math.min(arg_9_2 + 1, var_9_9)

			if csv.trainer.trainer_level[var_9_10].needExp <= arg_4_0.trainerLevelExp:read() or var_9_9 == arg_9_2 then
				arg_4_0.totalExp:hide()
			else
				arg_4_0.totalExp:show()
			end

			itertools.invoke({
				arg_4_0.sliderBg,
				arg_4_0.slider,
				arg_4_0.exp,
				arg_4_0.txt
			}, "show")
		else
			itertools.invoke({
				arg_4_0.sliderBg,
				arg_4_0.slider,
				arg_4_0.exp,
				arg_4_0.totalExp,
				arg_4_0.txt
			}, "hide")
		end

		adapt.oneLinePos(arg_4_0.exp, arg_4_0.totalExp)
	end)
	idlereasy.any({
		arg_4_0.trainerLevel,
		arg_4_0.trainerLevelExp,
		arg_4_0.trainerGiftTimes
	}, function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
		local var_10_0 = csvSize(csv.trainer.trainer_level)
		local var_10_1 = math.min(arg_10_1 + 1, var_10_0)
		local var_10_2 = csv.trainer.trainer_level[var_10_1].needExp

		if arg_10_1 == var_10_0 then
			arg_4_0.barPoint:set(100)
			arg_4_0.exp:text(gLanguageCsv.advanceMax)
			arg_4_0.totalExp:hide()
		elseif var_10_2 <= arg_10_2 then
			arg_4_0.exp:text(gLanguageCsv.advanceAdd)
			arg_4_0.totalExp:hide()
			arg_4_0.barPoint:set(100)
			arg_4_0.topCenter:set(arg_10_1 + 1)
		else
			arg_4_0.barPoint:set(arg_10_2 / var_10_2 * 100)
			arg_4_0.totalExp:show()
			arg_4_0.exp:text(arg_10_2)
			arg_4_0.totalExp:text("/" .. var_10_2)
		end

		for iter_10_0, iter_10_1 in arg_4_0.topData:pairs() do
			iter_10_1:proxy().level = arg_10_1

			if iter_10_1:proxy().id == arg_10_1 then
				iter_10_1:proxy().isUp = var_10_2 <= arg_10_2
			else
				iter_10_1:proxy().isUp = false
			end

			iter_10_1:proxy().isGet = arg_10_3 > 0
		end

		if arg_4_0.oldLevel ~= 0 then
			if arg_4_0.topCenter:read() == arg_10_1 + 1 and arg_4_0.oldLevel + 1 == arg_10_1 then
				itertools.invoke({
					arg_4_0.sliderBg,
					arg_4_0.slider,
					arg_4_0.exp,
					arg_4_0.txt
				}, "show")
			else
				itertools.invoke({
					arg_4_0.sliderBg,
					arg_4_0.slider,
					arg_4_0.exp,
					arg_4_0.totalExp,
					arg_4_0.txt
				}, "hide")
			end
		end

		if arg_10_1 == var_10_0 then
			arg_4_0.awardPanel:hide()
		else
			arg_4_0.awardList:show()

			local var_10_3 = csv.trainer.trainer_level[var_10_1].firstAward

			uiEasy.createItemsToList(arg_4_0, arg_4_0.awardList, var_10_3, {
				scale = 1
			})
		end

		adapt.oneLinePos(arg_4_0.exp, arg_4_0.totalExp)
	end)
	arg_4_0.mask:addTouchEventListener(function(arg_11_0, arg_11_1)
		var_4_3(arg_11_0, arg_11_1)
	end)
	idlereasy.when(arg_4_0.items, function(arg_12_0, arg_12_1)
		arg_4_0.coinNum:text(arg_12_1[453] or 0)
		adapt.oneLinePos(arg_4_0.coinIcon, {
			arg_4_0.coinTxt,
			arg_4_0.coinNum,
			arg_4_0.coinDetail
		}, cc.p(15, 0))
	end)

	local var_4_4 = userDefault.getCurrDayKey("trainerBoxShow", false)

	if not userDefault.getForeverLocalKey("trainerFirstEnter", false) and arg_4_0.trainerLevel:read() ~= 1 then
		performWithDelay(arg_4_0, function()
			gGameUI:stackUI("city.develop.trainer.success", nil, nil, 0, arg_4_0:createHandler("topCenter"))
			userDefault.setForeverLocalKey("trainerFirstEnter", true)
		end, 0.01)

		return
	end

	if not var_4_4 and arg_4_0.trainerGiftTimes:read() == 0 then
		performWithDelay(arg_4_0, function()
			arg_4_0:onItemBoxClick(nil, arg_4_0.topData:atproxy(arg_4_0.trainerLevel:read() + 1))
		end, 0.01)
	end
end

function var_0_0.initModel(arg_15_0)
	arg_15_0.trainerLevel = gGameModel.role:getIdler("trainer_level")
	arg_15_0.trainerLevelExp = gGameModel.role:getIdler("trainer_level_exp")
	arg_15_0.trainerSumExp = gGameModel.role:getIdler("trainer_sum_exp")
	arg_15_0.trainerSkills = gGameModel.role:getIdler("trainer_skills")
	arg_15_0.trainerAttrSkills = gGameModel.role:getIdler("trainer_attr_skills")
	arg_15_0.items = gGameModel.role:getIdler("items")
	arg_15_0.trainerGiftTimes = gGameModel.daily_record:getIdler("trainer_gift_times")
end

function var_0_0.onLeftClick(arg_16_0)
	arg_16_0.topCenter:modify(function(arg_17_0)
		return true, arg_17_0 - 1
	end)
end

function var_0_0.onRightClick(arg_18_0)
	arg_18_0.topCenter:modify(function(arg_19_0)
		return true, arg_19_0 + 1
	end)
end

function var_0_0.onBottomItemClick(arg_20_0, arg_20_1, arg_20_2)
	gGameUI:stackUI("city.develop.trainer.skill_upgrade", nil, nil, arg_20_2)
end

function var_0_0.onAttrNextClick(arg_21_0)
	if dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.TrainerAttrSkills) == 0 then
		local var_21_0

		for iter_21_0 = 1, csvSize(csv.trainer.trainer_level) do
			local var_21_1, var_21_2 = csvNext(csv.trainer.trainer_level[iter_21_0].privilege)

			if var_21_1 == game.PRIVILEGE_TYPE.TrainerAttrSkills then
				var_21_0 = iter_21_0

				break
			end
		end

		gGameUI:showTip(string.format(gLanguageCsv.trainerUnlockSkill, csv.trainer.trainer_level[var_21_0].name))

		return
	end

	gGameUI:stackUI("city.develop.trainer.attr_skills")
end

function var_0_0.onAttrClick(arg_22_0)
	gGameUI:stackUI("city.develop.trainer.attr", nil, nil, arg_22_0:createHandler("sendParams"))
end

function var_0_0.sendParams(arg_23_0)
	return arg_23_0.topData:atproxy(arg_23_0.trainerLevel:read() + 1)
end

function var_0_0.onItemUpClick(arg_24_0, arg_24_1, arg_24_2)
	arg_24_0.oldLevel = arg_24_2.level
	arg_24_0.topData:atproxy(arg_24_0.oldLevel + 1).unLock = false

	gGameApp:requestServer("/game/trainer/advance", function(arg_25_0)
		local var_25_0 = arg_24_0.oldLevel + 2

		arg_24_0.topData:atproxy(var_25_0).unLock = true

		performWithDelay(arg_24_0, function()
			gGameUI:stackUI("city.develop.trainer.success", nil, nil, arg_24_0.oldLevel, arg_24_0:createHandler("topCenter"))

			arg_24_0.topData:atproxy(var_25_0).unLock = false
		end, 1)
	end)
end

function var_0_0.onItemBoxClick(arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = {
		clearFast = true,
		content = "",
		data = arg_27_2.cfg.dailyAward,
		title = gLanguageCsv.dailyReward,
		state = arg_27_0.trainerGiftTimes:read() > 0 and 0 or 1,
		btnText = arg_27_0.trainerGiftTimes:read() == 0 and gLanguageCsv.spaceReceive or gLanguageCsv.received,
		cb = function()
			gGameApp:requestServer("/game/trainer/daily/award", function(arg_29_0)
				userDefault.setCurrDayKey("trainerBoxShow", true)
				gGameUI:showGainDisplay(arg_29_0)
			end)
		end
	}

	gGameUI:showBoxDetail(var_27_0)
end

function var_0_0.onBtnJlyl(arg_30_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_30_0:createHandler("getAwardContext"), {
		width = 1000
	})
end

function var_0_0.onCoinDetail(arg_31_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_31_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_0.onGainTqb(arg_32_0)
	gGameUI:stackUI("city.activity.view", nil, {
		full = true
	}, unpack({
		"award",
		13
	}))
end

function var_0_0.getRuleContext(arg_33_0, arg_33_1)
	local var_33_0 = adaptContext

	return {
		var_33_0.clone(arg_33_1.title, function(arg_34_0)
			arg_34_0:get("text"):text(string.format(gLanguageCsv.brackets, gLanguageCsv.trainerCoin))
		end),
		var_33_0.noteText(66001, 66004)
	}
end

function var_0_0.getAwardContext(arg_35_0, arg_35_1)
	local var_35_0 = adaptContext

	return {
		var_35_0.clone(arg_35_1.title, function(arg_36_0)
			arg_36_0:get("text"):text(string.format(gLanguageCsv.brackets, gLanguageCsv.trainerCoin))
		end),
		var_35_0.noteText(125705, 125716)
	}
end

return var_0_0
