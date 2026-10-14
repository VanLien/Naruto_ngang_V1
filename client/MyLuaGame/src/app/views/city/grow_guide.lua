local var_0_0 = {
	get = 3,
	doing = 2,
	lock = 1
}
local var_0_1 = {
	reward = 1,
	task = 2
}
local var_0_2 = class("GrowGuideView", Dialog)

var_0_2.RESOURCE_FILENAME = "grow_guide.json"
var_0_2.RESOURCE_BINDING = {
	rightBall = "rightBall",
	["rightCenter.textNote"] = "rightCenterTextNote",
	["rightDown.imgTitleBg"] = "rightDownTitleBg",
	["rightCenter.imgTitleBg"] = "rightCenterTitleBg",
	["rightTop.imgTitleBg"] = "rightTopTitleBg",
	item1 = "item1",
	item = "item",
	rightTop = "rightTop",
	item2 = "item2",
	rightDown = "rightDown",
	rightCenter = "rightCenter",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["title.textTitle"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(188, 124, 10, 255)
				}
			}
		}
	},
	list = {
		varname = "mainlist",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("itemDatas"),
				item = bindHelper.self("item"),
				enterLv = bindHelper.self("enterLv"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = cc.size(1040, 216)
					local var_1_1 = "city/grow_guide/btn_moren2.png"

					if arg_1_3.isSel then
						var_1_1 = "city/grow_guide/btn_moren1.png"
						var_1_0 = cc.size(1062, 240)
					end

					arg_1_1:get("imgBg"):texture(var_1_1)
					arg_1_1:get("imgBg"):size(var_1_0)
					arg_1_1:get("imgIcon"):texture(arg_1_3.cfg.icon)
					arg_1_1:get("textName"):text(arg_1_3.cfg.name)
					arg_1_1:get("textNote"):text(arg_1_3.cfg.desc)
					arg_1_1:removeChildByName("effect")
					arg_1_1:removeChildByName("effect2")

					local var_1_2 = "city/grow_guide/logo_gn.png"
					local var_1_3 = gLanguageCsv.textReward

					if arg_1_3.cfg.type == var_0_1.task then
						var_1_2 = "city/grow_guide/logo_jl.png"
						var_1_3 = gLanguageCsv.task
					end

					arg_1_1:get("type.imgtype"):texture(var_1_2)
					arg_1_1:get("type.textType"):text(var_1_3)
					arg_1_1:get("type.imgtype"):width(arg_1_1:get("type.textType"):width() + 43)
					arg_1_1:get("lock"):visible(arg_1_3.state == var_0_0.lock)
					arg_1_1:get("doing"):hide()
					arg_1_1:get("imgGet"):visible(false)

					local var_1_4 = csv.unlock[gUnlockCsv[arg_1_3.cfg.feature]]

					if arg_1_3.state == var_0_0.lock then
						if (gGameModel.role:read("level") or 0) >= var_1_4.startLevel then
							if arg_1_3.serverDay then
								arg_1_1:get("lock.textState"):text(string.format(gLanguageCsv.unlockServerOpen, arg_1_3.serverDay))
							else
								local var_1_5, var_1_6, var_1_7, var_1_8 = dataEasy.getChapterInfoByGateID(var_1_4.startGate)
								local var_1_9 = string.format(gLanguageCsv.needUnlockGate, var_1_8, var_1_6, var_1_7)

								arg_1_1:get("lock.textState"):text(var_1_9)
							end
						else
							arg_1_1:get("lock.textState"):text(string.format(gLanguageCsv.arrivalLevelOpen, var_1_4.startLevel))
						end
					end

					local var_1_10

					if arg_1_3.state ~= var_0_0.lock and var_1_4.startLevel >= arg_1_0.enterLv:read() + 1 and not arg_1_3.skel then
						var_1_10 = widget.addAnimationByKey(arg_1_1, "effect/hongjiesuo.skel", "effect", "effect", 2):xy(var_1_0.width - 120, var_1_0.height / 2)
						arg_1_3.skel = true
					end

					local var_1_11 = arg_1_1:size()
					local var_1_12 = widget.addAnimationByKey(arg_1_1, "effect/kelingqu.skel", "effect2", "effect_loop", 2):xy(var_1_11.width - 170, var_1_11.height / 2):hide()

					local function var_1_13()
						arg_1_1:get("doing"):visible(arg_1_3.state == var_0_0.doing)

						if arg_1_3.state == var_0_0.get then
							performWithDelay(arg_1_1, function()
								arg_1_1:removeChildByName("effect")
								var_1_12:show()
							end, 0.016666666666666666)
						end
					end

					if var_1_10 then
						var_1_10:setSpriteEventHandler(function(arg_4_0, arg_4_1)
							var_1_13()
						end, sp.EventType.ANIMATION_COMPLETE)
					else
						var_1_13()
					end

					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3)
						}
					})
				end,
				preloadCenter = bindHelper.self("interIdx")
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	},
	["rightTop.rewardPanel"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("isShowReward")
		}
	},
	["rightTop.rewardPanel.list"] = {
		varname = "itemList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("rightItems"),
				item = bindHelper.self("item2"),
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					local var_5_0 = {
						class = "icon_key",
						props = {
							data = {
								key = arg_5_3
							},
							onNode = function(arg_6_0)
								arg_6_0:scale(0.8)
							end
						}
					}

					bind.extend(arg_5_0, arg_5_1, var_5_0)
				end
			}
		}
	},
	["rightDown.list"] = {
		varname = "rewardList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("rightReward"),
				item = bindHelper.self("item1"),
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					local var_7_0 = {
						class = "icon_key",
						props = {
							data = {
								key = arg_7_3.key,
								num = arg_7_3.num
							}
						}
					}

					bind.extend(arg_7_0, arg_7_1, var_7_0)
				end
			}
		}
	},
	btnGet = {
		varname = "btnGet",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onGetReward")
			}
		}
	},
	["rightTop.goTo.textNote1"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 8,
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["rightTop.goTo.textNote2"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 8,
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["rightTop.goTo"] = {
		varname = "gotoPanel",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onJump")
				}
			},
			{
				event = "visible",
				idler = bindHelper.self("needJump")
			}
		}
	},
	["rightTop.textNote"] = {
		varname = "rightTopTextNote",
		binds = {
			event = "text",
			idler = bindHelper.self("textTitle")
		}
	},
	["rightDown.textNote"] = {
		varname = "rightDownTextNote",
		binds = {
			event = "text",
			idler = bindHelper.self("rewardTitle")
		}
	}
}

function var_0_2.onCreate(arg_8_0, arg_8_1)
	arg_8_1 = arg_8_1 or 1

	arg_8_0:initModel()

	arg_8_0.textTitle = idler.new("")
	arg_8_0.rewardTitle = idler.new("")
	arg_8_0.needJump = idler.new(false)
	arg_8_0.interIdx = idler.new(arg_8_1)
	arg_8_0.enterLv = idler.new(userDefault.getForeverLocalKey("entreGrowGuideLv", 0))

	idlereasy.when(arg_8_0.level, function(arg_9_0, arg_9_1)
		userDefault.setForeverLocalKey("entreGrowGuideLv", arg_8_0.level:read())
	end)

	local var_8_0 = ccui.Scale9Sprite:create()

	var_8_0:initWithFile(cc.rect(50, 50, 1, 1), "city/grow_guide/mask_czxd_ball.png")
	var_8_0:size(cc.size(1120, 1120))

	local var_8_1 = cc.ClippingNode:create(var_8_0):setAlphaThreshold(0.1):alignCenter(arg_8_0.rightBall:size()):addTo(arg_8_0.rightBall)

	ccui.ImageView:create("common/bg/bg_icon@.png"):scale(1.8):xy(360, -430):setRotation(-34.72):setOpacity(46):addTo(var_8_1)

	arg_8_0.rightItems = idlers.newWithMap({})
	arg_8_0.rightReward = idlers.newWithMap({})
	arg_8_0.isShowReward = idler.new(false)
	arg_8_0.selIdx = idler.new(arg_8_1)
	arg_8_0.itemDatas = idlers.newWithMap({})

	local var_8_2 = true
	local var_8_3 = {
		arg_8_0.growGuide
	}

	for iter_8_0, iter_8_1 in ipairs(gGrowGuideCsv) do
		table.insert(var_8_3, dataEasy.getListenUnlock(iter_8_1.feature))
	end

	idlereasy.any(var_8_3, function(arg_10_0, arg_10_1, ...)
		local var_10_0 = {
			...
		}

		if not var_8_2 then
			arg_8_0.enterLv:set(userDefault.getForeverLocalKey("entreGrowGuideLv", 0))
		else
			var_8_2 = false
		end

		local var_10_1 = {}

		arg_8_0.count = 0

		local var_10_2 = 0

		for iter_10_0, iter_10_1 in ipairs(gGrowGuideCsv) do
			local var_10_3 = iter_10_1.id

			var_10_2 = var_10_2 + 1

			if not arg_10_1[var_10_3] or arg_10_1[var_10_3][1] ~= 0 then
				arg_8_0.count = arg_8_0.count + 1

				local var_10_4 = {
					cfg = iter_10_1,
					csvId = var_10_3
				}
				local var_10_5 = var_0_0.doing

				if arg_10_1[var_10_3] and arg_10_1[var_10_3][1] == 1 then
					var_10_5 = var_0_0.get
				elseif not var_10_0[var_10_2] then
					var_10_5 = var_0_0.lock
				end

				if iter_10_1.feature == "craft" and var_10_5 ~= var_0_0.lock then
					local var_10_6, var_10_7 = dataEasy.judgeServerOpen("craft")

					if not var_10_6 and var_10_7 then
						var_10_5 = var_0_0.lock
						var_10_4.serverDay = var_10_7
					end
				end

				var_10_4.state = var_10_5

				table.insert(var_10_1, var_10_4)
			end
		end

		table.sort(var_10_1, function(arg_11_0, arg_11_1)
			local var_11_0 = csv.unlock
			local var_11_1 = var_11_0[gUnlockCsv[arg_11_0.cfg.feature]].startLevel
			local var_11_2 = var_11_0[gUnlockCsv[arg_11_1.cfg.feature]].startLevel

			if var_11_1 ~= var_11_2 then
				return var_11_1 < var_11_2
			end

			return arg_11_0.csvId < arg_11_1.csvId
		end)
		dataEasy.tryCallFunc(arg_8_0.mainlist, "updatePreloadCenterIndex")
		arg_8_0.itemDatas:update(var_10_1)

		if arg_8_0.count ~= 0 then
			local var_10_8 = math.min(arg_8_0.count, arg_8_0.selIdx:read())

			arg_8_0.selIdx:set(var_10_8, true)
		end
	end)
	arg_8_0.selIdx:addListener(function(arg_12_0, arg_12_1)
		if arg_8_0.itemDatas:atproxy(arg_12_1) then
			arg_8_0.itemDatas:atproxy(arg_12_1).isSel = false
		end

		arg_8_0.itemDatas:atproxy(arg_12_0).isSel = true

		arg_8_0:initRightPanel(arg_12_0)
	end)

	local var_8_4 = arg_8_0.gotoPanel:size()

	widget.addAnimationByKey(arg_8_0.gotoPanel, "effect/jiantou.skel", "efc1", "effect_loop", 6):xy(var_8_4.width / 2 - 60, var_8_4.height / 2)
	Dialog.onCreate(arg_8_0)
end

function var_0_2.initModel(arg_13_0)
	arg_13_0.growGuide = gGameModel.role:getIdler("grow_guide")
	arg_13_0.level = gGameModel.role:getIdler("level")
end

function var_0_2.initRightPanel(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.itemDatas:atproxy(arg_14_1)

	arg_14_0.needJump:set(var_14_0.state ~= var_0_0.lock and var_14_0.cfg.goTo ~= nil)
	arg_14_0.textTitle:set(var_14_0.cfg.name)
	arg_14_0.rightTopTextNote:text(var_14_0.cfg.name)

	local var_14_1 = arg_14_0.rightTop:getChildByName("clippingNode")

	if not var_14_1 then
		local var_14_2 = ccui.Scale9Sprite:create()

		var_14_2:initWithFile(cc.rect(50, 50, 1, 1), "city/grow_guide/mask_czxd1.png")
		var_14_2:size(cc.size(1058, 488))

		var_14_1 = cc.ClippingNode:create(var_14_2):setAlphaThreshold(0.1):alignCenter(arg_14_0.rightTop:size()):addTo(arg_14_0.rightTop, 2, "clippingNode")
	end

	var_14_1:removeChildByName("logo")
	ccui.ImageView:create(var_14_0.cfg.res):scale(2):addTo(var_14_1, 1, "logo")
	arg_14_0.rightItems:update(var_14_0.cfg.items)
	arg_14_0.isShowReward:set(itertools.size(var_14_0.cfg.items) > 0)

	local var_14_3 = {}

	for iter_14_0, iter_14_1 in csvMapPairs(var_14_0.cfg.award) do
		local var_14_4 = {
			key = iter_14_0,
			num = iter_14_1
		}

		table.insert(var_14_3, var_14_4)
	end

	arg_14_0.rightReward:update(var_14_3)
	arg_14_0.rightCenter:hide()

	local var_14_5 = 360
	local var_14_6 = gLanguageCsv.unLockReward

	if var_14_0.cfg.type == var_0_1.task then
		var_14_6 = gLanguageCsv.taskReward

		local var_14_7 = (arg_14_0.growGuide:read()[var_14_0.csvId] or {})[2] or 0
		local var_14_8 = string.format(var_14_0.cfg.taskDesc .. "(%s/%s)", var_14_7, var_14_0.cfg.taskParam)

		arg_14_0.rightCenter:get("textContent"):text(var_14_8)
		arg_14_0.rightCenter:show()

		var_14_5 = 290
	end

	arg_14_0.rewardTitle:set(var_14_6)
	arg_14_0.rightDown:y(var_14_5)

	local var_14_9 = var_14_0.state == var_0_0.get and "normal" or "hsl_gray"

	cache.setShader(arg_14_0.btnGet, false, var_14_9)

	if var_14_0.state == var_0_0.get then
		text.addEffect(arg_14_0.btnGet:get("Label_83"), {
			outline = {
				size = 4,
				color = ui.NEWCOLORS.OUTLINE.YELLOW
			}
		})
	else
		text.deleteAllEffect(arg_14_0.btnGet:get("Label_83"))
	end

	arg_14_0.rightTopTitleBg:width(arg_14_0.rightTopTextNote:width() / arg_14_0.rightTopTitleBg:scale() + 60)
	arg_14_0.rightCenterTitleBg:width(arg_14_0.rightCenterTextNote:width() / arg_14_0.rightCenterTitleBg:scale() + 60)
	arg_14_0.rightDownTitleBg:width(arg_14_0.rightDownTextNote:width() / arg_14_0.rightDownTitleBg:scale() + 60)
end

function var_0_2.onGetReward(arg_15_0)
	local var_15_0 = arg_15_0.itemDatas:atproxy(arg_15_0.selIdx:read())

	if var_15_0.state ~= var_0_0.get then
		return
	end

	gGameApp:requestServer("/game/role/growguide/award/get", function(arg_16_0)
		if arg_15_0.count == 0 then
			gGameUI:showGainDisplay(arg_16_0, {
				cb = function()
					arg_15_0:onClose()
				end
			})
		else
			gGameUI:showGainDisplay(arg_16_0)
		end
	end, var_15_0.csvId)
end

function var_0_2.onJump(arg_18_0)
	local var_18_0 = arg_18_0.itemDatas:atproxy(arg_18_0.selIdx:read())

	jumpEasy.jumpTo(var_18_0.cfg.goTo)
end

function var_0_2.onItemClick(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	arg_19_0.selIdx:set(arg_19_2)
end

return var_0_2
