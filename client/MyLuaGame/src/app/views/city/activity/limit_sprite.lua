local var_0_0 = {
	AWARD = 2,
	RANK = 1
}
local var_0_1 = {
	[1] = 0,
	[10] = 9
}

local function var_0_2(arg_1_0, arg_1_1, arg_1_2)
	if arg_1_1 <= 3 and (not arg_1_2 or arg_1_2 == arg_1_1) then
		arg_1_0:get("text"):hide()
		arg_1_0:get("img"):texture(ui.RANK_ICON[arg_1_1])
	else
		arg_1_0:get("img"):hide()

		if not arg_1_2 or arg_1_1 == arg_1_2 then
			arg_1_0:get("text"):text(arg_1_1)
		else
			arg_1_0:get("text"):hide()
			arg_1_0:get("text1"):text(arg_1_1 .. "~" .. arg_1_2):show()
		end
	end
end

local var_0_3 = class("ActivityLimitSpriteView", Dialog)

var_0_3.RESOURCE_FILENAME = "activity_limit_sprite.json"
var_0_3.RESOURCE_BINDING = {
	["leftPanel.drawTenPanel.btn.costInfo.textNote"] = "costTextNote2",
	["leftPanel.drawTenPanel.textBg"] = "tenTextBg",
	["leftPanel.drawTenPanel.btn.costInfo.textCost"] = "costTen",
	["leftPanel.drawTenPanel.btn.costInfo.img"] = "imgTen",
	["leftPanel.drawOnePanel.btn.costInfo.textCost"] = "costOne",
	["leftPanel.drawOnePanel.btn.costInfo.textNote"] = "costTextNote1",
	["bg.bg"] = "bg",
	["rightPanel.textBg"] = "textTip",
	["bottomPanel.bar"] = "scoreBar",
	["bottomPanel.item"] = "boxItem",
	aniLayer = "aniLayer",
	["leftPanel.spritePanel"] = "spritePanel",
	["leftPanel.drawTenPanel.textBg.text"] = "tenText",
	["rightPanel.rankItem"] = "rankItem",
	["rightPanel.myrank"] = "myrank",
	["rightPanel.scoreItem"] = "scoreItem",
	["leftPanel.drawOnePanel.btn.costInfo.img"] = "imgOne",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["leftPanel.btnRule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowRule")
			}
		}
	},
	["leftPanel.btnRight"] = {
		varname = "btnRight",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRightClick")
			}
		}
	},
	["leftPanel.btnLeft"] = {
		varname = "btnLeft",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onLeftClick")
			}
		}
	},
	["leftPanel.btnHandBook"] = {
		varname = "btnHandBook",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onHandBookClick")
			}
		}
	},
	["leftPanel.drawOnePanel.btn"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onDrawOneClick")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "limitSpritesHasFreeDrawCard",
					listenData = {
						activityId = bindHelper.self("activityId")
					},
					onNode = function(arg_2_0)
						arg_2_0:xy(285, 82):scale(0.75)
					end
				}
			}
		}
	},
	["leftPanel.drawOnePanel.btn.textFree"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("isFree")
		}
	},
	["leftPanel.drawOnePanel.btn.costInfo"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("isFree"),
			method = function(arg_3_0)
				return not arg_3_0
			end
		}
	},
	["leftPanel.drawOnePanel.btn.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLUE2
				}
			}
		}
	},
	["leftPanel.drawTenPanel.btn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDrawTenClick")
			}
		}
	},
	["leftPanel.drawTenPanel.btn.textNote"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						color = ui.NEWCOLORS.OUTLINE.YELLOW1
					}
				}
			}
		}
	},
	["rightPanel.btnAward"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowAwardList")
			}
		}
	},
	["rightPanel.btnRefresh"] = {
		varname = "btnRefresh",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnRankClick")
			}
		}
	},
	["rightPanel.timeTextNote"] = {
		varname = "timeTextNote",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.WHITE5
				}
			}
		}
	},
	["rightPanel.timeText"] = {
		varname = "timeText",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.WHITE5
				}
			}
		}
	},
	["rightPanel.btnRank"] = {
		varname = "btnRank",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnRankClick")
			}
		}
	},
	["rightPanel.btnScore"] = {
		varname = "btnScore",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnAwardClick")
			}
		}
	},
	["rightPanel.rankList"] = {
		varname = "rankList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("rankData"),
				item = bindHelper.self("rankItem"),
				key = bindHelper.self("key"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:multiget("rank", "score", "logo", "lv", "level", "name")
					local var_4_1 = string.format("activity/limit_sprite/rank_bg_%s.png", arg_4_2 > 3 and 4 or arg_4_2)

					var_0_2(var_4_0.rank, arg_4_2)
					var_4_0.score:texture(var_4_1)
					var_4_0.score:get("text"):text(string.format(gLanguageCsv.limitBoxFmt, arg_4_3[arg_4_0.key]))

					local var_4_2 = arg_4_3.role

					var_4_0.level:text(var_4_2.level)
					adapt.setTextScaleWithWidth(var_4_0.name, var_4_2.name, 340)

					local function var_4_3(arg_5_0)
						local var_5_0 = cc.p(arg_5_0.x - 200, arg_5_0.y - 50)

						gGameUI:stackUI("city.chat.personal_info", nil, nil, var_5_0, {
							role = var_4_2
						})
					end

					if var_4_2.id == gGameModel.role:read("id") then
						var_4_3 = nil
					end

					bind.extend(arg_4_0, var_4_0.logo, {
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = var_4_2.logo,
							frameId = var_4_2.frame,
							onNodeClick = var_4_3
						}
					})
					adapt.oneLinePos(var_4_0.logo, {
						var_4_0.lv,
						var_4_0.level,
						var_4_0.name
					}, {
						cc.p(26, 0),
						cc.p(5, 0),
						cc.p(38, 0)
					})
				end
			}
		}
	},
	["rightPanel.awardList"] = {
		varname = "awardList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("awardData"),
				item = bindHelper.self("scoreItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					local var_6_0 = arg_6_3.rankStart + 1
					local var_6_1 = arg_6_1:multiget("rank", "score", "list")

					var_0_2(var_6_1.rank, var_6_0, arg_6_3.rankEnd)

					local var_6_2 = string.format("activity/limit_sprite/score_bg_%s.png", var_6_0 > 3 and 4 or var_6_0)

					var_6_1.score:texture(var_6_2)
					var_6_1.score:get("text"):text(arg_6_3.point)
					var_6_1.list:setGravity(ccui.ListViewGravity.centerVertical)

					local var_6_3 = csvSize(arg_6_3.award) > 4 and 0.55 or 0.6

					uiEasy.createItemsToList(arg_6_0, var_6_1.list, arg_6_3.award, {
						scale = var_6_3
					})
				end
			}
		}
	},
	["bottomPanel.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["bottomPanel.list"] = {
		varname = "boxList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("boxData"),
				item = bindHelper.self("boxItem"),
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					local var_7_0 = arg_7_3.state
					local var_7_1 = "activity/limit_sprite/box_%s_open.png"
					local var_7_2 = "activity/limit_sprite/box_%s.png"
					local var_7_3 = "spine"
					local var_7_4 = string.format(var_7_0 == 0 and var_7_1 or var_7_2, arg_7_3.iconId)
					local var_7_5 = arg_7_1:get("boxImg")

					var_7_5:texture(var_7_4)
					uiEasy.addVibrateToNode(arg_7_0, var_7_5, var_7_0 == 1, "imgBox" .. arg_7_2)

					if var_7_0 == 1 then
						local var_7_6 = widget.addAnimationByKey(arg_7_1, "effect/jiedianjiangli.skel", var_7_3, "effect_loop", 3):scale(0.5):xy(arg_7_1:size().width / 2, arg_7_1:size().height / 2)

						bind.extend(arg_7_0, arg_7_1:get("redArea"), {
							class = "red_hint",
							props = {
								specialTag = "boxRedHint" .. time.getTime(),
								state = var_7_0 == 1,
								onNode = function(arg_8_0)
									arg_8_0:xy(180, 230)
								end
							}
						})
					else
						arg_7_1:removeChildByName(var_7_3)
						arg_7_1:get("redArea"):removeAllChildren()
					end

					arg_7_1:get("textBg.text"):text(string.format(gLanguageCsv.limitBoxFmt, arg_7_3.point))
					bind.touch(arg_7_0, var_7_5, {
						methods = {
							ended = functools.partial(arg_7_0.clickCell, arg_7_3.id, var_7_0, arg_7_3.award, arg_7_3.point)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onBoxClick")
			}
		}
	},
	btn_sxhl = {
		varname = "btnSxhl",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnSxhlClick")
			}
		}
	},
	btn_xdlb = {
		varname = "btnXdlb",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnXdlbClick")
			}
		}
	}
}

function var_0_3.onCreate(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	arg_9_0.closeCb = arg_9_3
	arg_9_0.listPosX, arg_9_0.listPosY = arg_9_0.awardList:xy()
	arg_9_0.listSize = arg_9_0.awardList:size()
	arg_9_0.btnSxhl:hide()
	bind.click(arg_9_0, arg_9_0.aniLayer, {
		method = functools.partial(arg_9_0.onCardSprClick, arg_9_0)
	})
	arg_9_0.aniLayer:hide()

	arg_9_0.activityId = idler.new(arg_9_1)

	arg_9_0:resetTimeLabel()
	arg_9_0:initModel()
	arg_9_0:initData(arg_9_2)
	arg_9_0:initAwardData()
	arg_9_0:initBoxInfo()
	arg_9_0:initSelfInfo()
	dataEasy.getListenUnlock("handbook", function(arg_10_0)
		if not arg_10_0 then
			uiEasy.updateUnlockRes("handbook", arg_9_0.btnHandBook, {
				justRemove = false,
				pos = cc.p(150, 150)
			})
		end
	end)
	Dialog.onCreate(arg_9_0, {
		blackType = 1
	})
end

function var_0_3.initBg(arg_11_0, arg_11_1)
	arg_11_0.bg:texture(arg_11_1 or "activity/limit_sprite/bg_picture.png")
end

function var_0_3.initData(arg_12_0, arg_12_1)
	arg_12_0:resetRankInfo(arg_12_1.rank)
end

function var_0_3.initModel(arg_13_0)
	arg_13_0.cardDatas = gGameModel.role:getIdler("cards")
	arg_13_0.cardCapacity = gGameModel.role:getIdler("card_capacity")
	arg_13_0.rmb = gGameModel.role:getIdler("rmb")
	arg_13_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_13_0.diamondFreeCount = gGameModel.daily_record:getIdler("limit_box_free_counter")
	arg_13_0.isFree = idler.new(false)
	arg_13_0.curListType = idler.new(var_0_0.RANK)
	arg_13_0.rankData = idlertable.new({})
	arg_13_0.awardData = {}
	arg_13_0.spriteId = idler.new(0)
	arg_13_0.curDevelopId = idler.new(0)
	arg_13_0.boxData = idlertable.new({})
	arg_13_0.sprState = idler.new(0)
	arg_13_0.checkCardCapacity = idler.new(0)

	idlereasy.when(arg_13_0.activityId, function(arg_14_0, arg_14_1)
		local var_14_0 = csv.yunying.yyhuodong[arg_14_1]
		local var_14_1 = var_14_0.paramMap
		local var_14_2 = var_14_1.RMB1 or 100
		local var_14_3 = var_14_1.RMB10 or var_14_2 * 10
		local var_14_4 = arg_13_0.rmb:read()

		arg_13_0.checkCardCapacity:set(var_14_1.CheckCardCapacity)

		arg_13_0.cfg = var_14_0
		arg_13_0.oneCost = var_14_2

		arg_13_0.costOne:text(var_14_2)

		arg_13_0.tenCost = var_14_3

		arg_13_0.costTen:text(var_14_3)

		local var_14_5 = game.ITEM_TICKET.spriteCard
		local var_14_6 = dataEasy.getNumByKey(var_14_5)
		local var_14_7 = dataEasy.getIconResByKey(var_14_5)

		arg_13_0.imgOne:texture(var_14_7)
		arg_13_0.imgTen:texture(var_14_7)
		arg_13_0.costOne:text(var_14_6 .. "/1")
		arg_13_0.costTen:text(var_14_6 .. "/10")
		arg_13_0:initBg("activity/limit_sprite/bg_picture" .. (var_14_0.clientParam.bg or "") .. ".png")
		arg_13_0.spriteId:set(var_14_0.clientParam.cardId)
		arg_13_0.btnRefresh:show()

		local var_14_8 = arg_13_0.textTip:size().height
		local var_14_9 = var_14_1.Qualify ~= 0

		if var_14_9 then
			local var_14_10 = arg_13_0.cfg.beginDate
			local var_14_11 = time.getDate(game.SERVER_OPENTIME)

			var_14_11.hour = 0
			var_14_11.min = 0
			var_14_11.sec = 0

			local var_14_12 = time.getNumTimestamp(var_14_10) - time.getTimestamp(var_14_11)
			local var_14_13 = 86400
			local var_14_14 = math.floor(var_14_12 / var_14_13)

			if var_14_14 > var_14_1.QualifyServerOpenDays then
				local var_14_15

				for iter_14_0, iter_14_1 in orderCsvPairs(csv.yunying.limitboxqualify) do
					if var_14_14 < iter_14_1.serverOpenDays then
						break
					end

					var_14_15 = iter_14_1
				end

				if var_14_15 and (var_14_15.fightPointLimit > 0 or var_14_15.vipLimit > 0) then
					arg_13_0.textTip:show()

					local var_14_16 = var_14_1.QualifyTime
					local var_14_17 = math.floor(var_14_16 / 1440) + 1
					local var_14_18, var_14_19 = time.getHourAndMin(var_14_0.beginTime, true)
					local var_14_20 = math.floor((var_14_16 + var_14_18 * 60 + var_14_19) % 1440 / 60)
					local var_14_21 = var_14_16 % 60

					arg_13_0.richText = rich.createWithWidth(string.format(gLanguageCsv.limitTip, var_14_17, string.format("%d:%d", var_14_20, var_14_21), var_14_15.vipLimit, mathEasy.getShortNumber(var_14_15.fightPointLimit, 1)), 31, nil, 850)

					arg_13_0.richText:addTo(arg_13_0.textTip):anchorPoint(0, 0.5):xy(10, arg_13_0.textTip:size().height / 2)
					arg_13_0.awardList:xy(arg_13_0.listPosX, arg_13_0.listPosY - var_14_8)
					arg_13_0.awardList:size(arg_13_0.listSize.width, arg_13_0.listSize.height + var_14_8)
					arg_13_0.rankList:xy(arg_13_0.listPosX, arg_13_0.listPosY)
					arg_13_0.rankList:size(arg_13_0.listSize.width, arg_13_0.listSize.height)
					arg_13_0.myrank:y(arg_13_0.listPosY)
				else
					var_14_9 = false
				end
			end
		end

		if not var_14_9 then
			arg_13_0.awardList:xy(arg_13_0.listPosX, arg_13_0.listPosY - var_14_8)
			arg_13_0.awardList:size(arg_13_0.listSize.width, arg_13_0.listSize.height + var_14_8)
			arg_13_0.textTip:hide()
		end
	end)
	idlereasy.when(gGameModel.role:getIdler("items"), function(arg_15_0, arg_15_1)
		local var_15_0 = arg_15_1[game.ITEM_TICKET.spriteCard] or 0

		arg_13_0.costOne:text(var_15_0 .. "/1")
		arg_13_0.costTen:text(var_15_0 .. "/10")

		if not arg_13_0.oneCost or not arg_13_0.tenCost then
			return
		end

		text.addEffect(arg_13_0.costOne, {
			color = var_15_0 < 1 and ui.COLORS.NORMAL.RED or ui.NEWCOLORS.WHITE
		})
		text.addEffect(arg_13_0.costTen, {
			color = var_15_0 < 10 and ui.COLORS.NORMAL.RED or ui.NEWCOLORS.WHITE
		})
	end)
	idlereasy.any({
		arg_13_0.diamondFreeCount,
		arg_13_0.rmb,
		arg_13_0.activityId
	}, function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
		arg_13_0.isFree:set(arg_13_0.getHuodongEndTime > time.getTime() and arg_16_1 < 1)
	end)

	local function var_13_0(arg_17_0, arg_17_1, arg_17_2)
		local var_17_0 = arg_17_1 and "activity/limit_sprite/btn_1.png" or "activity/limit_sprite/btn_2.png"
		local var_17_1 = arg_17_1 and ui.NEWCOLORS.OUTLINE.BLUE or ui.NEWCOLORS.OUTLINE.BLUE

		arg_17_0:setTouchEnabled(not arg_17_1)
		arg_17_0:texture(var_17_0)
		text.addEffect(arg_17_0:get("text"), {
			outline = {
				size = 3,
				color = var_17_1
			}
		})
		arg_17_2:visible(arg_17_1)
	end

	idlereasy.when(arg_13_0.curListType, function(arg_18_0, arg_18_1)
		var_13_0(arg_13_0.btnRank, arg_18_1 == var_0_0.RANK, arg_13_0.rankList)
		var_13_0(arg_13_0.btnScore, arg_18_1 == var_0_0.AWARD, arg_13_0.awardList)
		arg_13_0.myrank:visible(arg_18_1 == var_0_0.RANK)

		local var_18_0 = arg_18_1 == var_0_0.RANK and cc.size(664, 51) or cc.size(821, 51)
		local var_18_1 = arg_18_1 == var_0_0.RANK and cc.p(512, 132) or cc.p(440, 132)

		arg_13_0.textTip:size(var_18_0)
		arg_13_0.textTip:xy(var_18_1)

		if arg_13_0.richText then
			local var_18_2 = arg_18_1 == var_0_0.RANK and 10 or 90

			arg_13_0.richText:x(var_18_2)
		end

		arg_13_0.btnRefresh:visible(arg_18_1 == var_0_0.RANK)
	end)
	idlereasy.when(arg_13_0.spriteId, function(arg_19_0, arg_19_1)
		local var_19_0 = csv.cards[arg_19_1]
		local var_19_1 = csv.unit[var_19_0.unitID]
		local var_19_2 = var_19_0.cardMarkID

		arg_13_0.markTb = {}

		local var_19_3 = 1

		for iter_19_0, iter_19_1 in pairs(gCardsCsv[var_19_2]) do
			local var_19_4 = arg_13_0.cfg.clientParam

			for iter_19_2, iter_19_3 in pairs(iter_19_1) do
				table.insert(arg_13_0.markTb, iter_19_3)

				if iter_19_3.id == arg_19_1 then
					var_19_3 = #arg_13_0.markTb

					local var_19_5 = string.format(gLanguageCsv.limitTenText, iter_19_3.name)
					local var_19_6 = arg_13_0.cfg.clientParam

					if var_19_6 and var_19_6.key then
						local var_19_7 = var_19_6.key
						local var_19_8 = gLanguageCsv[var_19_7]

						if string.find(var_19_8, "%ps") then
							var_19_8 = string.format(var_19_8, iter_19_3.name)
						end

						arg_13_0.tenTextBg:show()
						arg_13_0.tenText:text(var_19_8)

						local var_19_9 = arg_13_0.tenText:size()
						local var_19_10 = arg_13_0.tenTextBg:size()
						local var_19_11 = 40

						arg_13_0.tenTextBg:size(cc.size(var_19_9.width + var_19_11, var_19_10.height))
						arg_13_0.tenText:x(var_19_9.width / 2 + var_19_11 / 2)
					else
						arg_13_0.tenTextBg:hide()
					end
				end

				if var_19_4.unitId then
					table.insert(arg_13_0.markTb, {
						innateSkillID = csv.unit[var_19_4.unitId].skillList[3],
						unitID = var_19_4.unitId,
						id = arg_19_1
					})
				end
			end
		end

		arg_13_0.curDevelopId:set(var_19_3)
	end)
	idlereasy.when(arg_13_0.curDevelopId, function(arg_20_0, arg_20_1)
		local var_20_0 = arg_13_0.markTb
		local var_20_1 = var_20_0[arg_20_1]
		local var_20_2 = csv.skill[var_20_1.innateSkillID]
		local var_20_3 = var_20_2.spineAction
		local var_20_4 = csv.unit[var_20_1.unitID]
		local var_20_5 = arg_13_0.spritePanel:multiget("rarity", "name", "nature1", "nature2", "sprite")

		var_20_5.name:text(var_20_1.name)
		var_20_5.rarity:texture(ui.RARITY_ICON[var_20_4.rarity])
		var_20_5.nature1:texture(ui.ATTR_ICON[var_20_4.natureType])
		var_20_5.nature2:visible(var_20_4.natureType2 and true or false)

		if var_20_4.natureType2 then
			var_20_5.nature2:texture(ui.ATTR_ICON[var_20_4.natureType2])
		end

		var_20_5.sprite:removeAllChildren()
		widget.addAnimation(var_20_5.sprite, var_20_4.unitRes, battle.SpriteActionTable.standby, 100):scale(var_20_4.scale * 1.1):x(var_20_5.sprite:size().width / 2):setSkin(var_20_4.skin)
		adapt.oneLineCenterPos(cc.p(522, 1060), {
			var_20_5.rarity,
			var_20_5.name,
			var_20_5.nature1,
			var_20_5.nature2
		}, cc.p(30, 0))

		local var_20_6 = 1

		arg_13_0.btnLeft:visible(arg_20_1 > 1)
		arg_13_0.btnRight:visible(arg_20_1 < var_20_6)

		if arg_20_1 > 1 then
			arg_13_0.btnLeft:get("text1"):text(string.format(gLanguageCsv.limitSpriteBtnText, var_20_0[arg_20_1 - 1].develop))
		end

		if arg_20_1 < var_20_6 then
			arg_13_0.btnRight:get("text1"):text(string.format(gLanguageCsv.limitSpriteBtnText, arg_20_1 + 1))
		end

		arg_13_0.btnLeft:get("text2"):text(var_20_0[math.max(arg_20_1 - 1, 1)].name)
		arg_13_0.btnRight:get("text2"):text(var_20_0[math.min(arg_20_1 + 1, var_20_6)].name)
		bind.touch(arg_13_0, var_20_5.sprite, {
			methods = {
				ended = functools.partial(arg_13_0.onCardSprClick, arg_13_0)
			}
		})

		local var_20_7 = {}

		local function var_20_8(arg_21_0)
			if not arg_21_0 then
				return
			end

			local var_21_0 = csv.effect_event[arg_21_0]

			if not var_21_0 then
				return
			end

			if var_21_0.effectRes then
				var_20_7[arg_21_0] = {
					res = var_21_0.effectRes,
					args = var_21_0.effectArgs
				}
			end

			if var_21_0.otherEventIDs then
				for iter_21_0, iter_21_1 in csvPairs(var_21_0.otherEventIDs) do
					var_20_8(gEffectByEventCsv[iter_21_1])
				end
			end
		end

		for iter_20_0, iter_20_1 in csvPairs(var_20_2.skillProcess) do
			local var_20_9 = csv.skill_process[iter_20_1]

			var_20_8(var_20_9.effectEventID)
		end

		local var_20_10 = {
			res = var_20_4.unitRes,
			skin = var_20_4.skin,
			aniName = var_20_3,
			scale = var_20_4.scale,
			offsetPos = cc.p(var_20_2.posC.x, var_20_2.posC.y),
			events = var_20_7,
			sound = var_20_2.sound,
			scaleArgs = var_20_2.cameraNear == 0 and var_20_2.scaleArgs or var_20_2.cameraNear_scaleArgs
		}

		if arg_13_0.cfg.clientParam.unitId then
			var_20_10.scale = 2.3
		end

		arg_13_0.aniArgs = var_20_10
	end)
	idlereasy.when(arg_13_0.sprState, function(arg_22_0, arg_22_1)
		local var_22_0 = false

		local function var_22_1()
			if var_22_0 then
				return
			end

			var_22_0 = true

			arg_13_0.aniLayer:removeAllChildren()
			arg_13_0.aniLayer:hide()
			arg_13_0.spritePanel:show()

			if arg_13_0.musicHandle then
				audio.stopSound(arg_13_0.musicHandle)
			end
		end

		if arg_22_1 == 1 then
			arg_13_0.spritePanel:hide()
			arg_13_0:playAni(var_22_1)
			arg_13_0.aniLayer:show()
		else
			var_22_1()
			arg_13_0.aniLayer:hide()
			arg_13_0.spritePanel:show()
		end
	end)
end

function var_0_3.playAni(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0.aniArgs
	local var_24_1 = cc.p(display.center.x, display.center.y)
	local var_24_2 = widget.addAnimation(arg_24_0.aniLayer, var_24_0.res, var_24_0.aniName, 100):scale(var_24_0.scale * (var_24_0.scaleArgs.scale or 1)):xy(var_24_1):z(1000)

	var_24_2:setSkin(var_24_0.skin)
	var_24_2:setSpriteEventHandler(function(arg_25_0, arg_25_1)
		performWithDelay(arg_24_0, arg_24_1, 0)
	end, sp.EventType.ANIMATION_COMPLETE)

	for iter_24_0, iter_24_1 in pairs(var_24_0.events) do
		local var_24_3 = iter_24_1.args
		local var_24_4 = cc.p(var_24_3.offsetX or 0, var_24_3.offsetY or 0)

		if var_24_3.screenPos then
			if var_24_3.screenPos == 0 then
				var_24_4 = cc.pAdd(var_24_4, display.center)
			elseif var_24_3.screenPos == 1 then
				local var_24_5, var_24_6 = var_24_2:getPosition()
				local var_24_7 = cc.p(var_24_5, var_24_6)

				var_24_4 = cc.pAdd(var_24_4, var_24_7)
			end
		end

		local var_24_8 = var_24_3.zorder or 0

		if var_24_3.addTolayer == 1 then
			var_24_8 = 100 + var_24_8
		end

		widget.addAnimationByKey(arg_24_0.aniLayer, iter_24_1.res, "bgEffect" .. iter_24_0, var_24_3.aniName, var_24_8):xy(var_24_4):scale(3 * var_24_3.scale or 0)
	end

	if var_24_0.sound then
		arg_24_0.musicHandle = audio.playEffectWithWeekBGM(var_24_0.sound.res, var_24_0.sound.loop > 0)
	end
end

function var_0_3.initBoxInfo(arg_26_0)
	local var_26_0 = {}
	local var_26_1 = 0
	local var_26_2 = arg_26_0.cfg.huodongID

	for iter_26_0, iter_26_1 in orderCsvPairs(csv.yunying.limitboxpointaward) do
		if iter_26_1.huodongID == var_26_2 then
			var_26_1 = math.max(iter_26_1.pointRequire, var_26_1)

			table.insert(var_26_0, {
				id = iter_26_0,
				iconId = iter_26_1.boxIcon,
				award = iter_26_1.award,
				point = iter_26_1.pointRequire
			})
		end
	end

	table.sort(var_26_0, function(arg_27_0, arg_27_1)
		return arg_27_0.point > arg_27_1.point
	end)

	local var_26_3 = #var_26_0
	local var_26_4 = arg_26_0.boxItem:size().width
	local var_26_5 = arg_26_0.boxList:size().width / var_26_3 - var_26_4

	arg_26_0.boxList:setItemsMargin(var_26_5)
	arg_26_0.boxData:set(var_26_0)

	arg_26_0.boxCount = var_26_3
	arg_26_0.maxScore = var_26_1

	arg_26_0.scoreBar:setPercent(0)
end

function var_0_3.onBoxClick(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	local var_28_0 = arg_28_0.activityId:read()

	if arg_28_3 == 1 then
		gGameApp:requestServer("/game/yy/limit/box/point", function(arg_29_0)
			gGameUI:showGainDisplay(arg_29_0.view)
		end, var_28_0, arg_28_2)

		return
	end

	local var_28_1 = arg_28_3 == nil and string.format(gLanguageCsv.limitBoxGet, arg_28_5) or ""

	gGameUI:showBoxDetail({
		data = arg_28_4,
		content = var_28_1,
		state = arg_28_3 or 1
	})
end

function var_0_3.resetBoxBar(arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0.boxData:read()
	local var_30_1 = arg_30_0.boxCount
	local var_30_2 = 1 / arg_30_0.boxCount
	local var_30_3 = 0 + var_30_2 * arg_30_1

	if arg_30_1 == 0 then
		var_30_3 = var_30_3 + arg_30_0.boxPoint / var_30_0[var_30_1].point * var_30_2
	elseif arg_30_1 == arg_30_0.boxCount then
		var_30_3 = 1
	else
		local var_30_4 = var_30_0[var_30_1 - arg_30_1 + 1].point
		local var_30_5 = var_30_0[var_30_1 - arg_30_1].point - var_30_4

		var_30_3 = var_30_3 + (arg_30_0.boxPoint - var_30_4) / var_30_5 * var_30_2
	end

	arg_30_0.scoreBar:setPercent(var_30_3 * 100)
end

function var_0_3.resetTimeLabel(arg_31_0)
	local var_31_0 = arg_31_0.activityId:read()
	local var_31_1 = csv.yunying.yyhuodong[var_31_0]
	local var_31_2 = time.getNumTimestamp(var_31_1.beginDate, 21, 30) + 172800

	arg_31_0.getHuodongEndTime = var_31_2

	local var_31_3 = var_31_2 - time.getTime()
	local var_31_4 = arg_31_0.timeText
	local var_31_5 = 1

	local function var_31_6()
		var_31_3 = var_31_2 - time.getTime()

		if var_31_3 <= 0 then
			var_31_4:text(gLanguageCsv.activityOver)
			adapt.oneLinePos(arg_31_0.timeTextNote, arg_31_0.timeText, cc.p(10, 0))

			return false
		end

		local var_32_0 = ""

		if var_31_5 == 2 then
			var_32_0 = time.getCutDown(var_31_3).clock_str
		else
			var_32_0 = time.getCutDown(var_31_3).str
		end

		var_31_4:text(var_32_0)

		if arg_31_0.timeTextNote then
			adapt.oneLinePos(arg_31_0.timeTextNote, arg_31_0.timeText, cc.p(10, 0))
		end

		return true
	end

	var_31_6()

	if var_31_3 > 0 then
		local var_31_7 = 100

		arg_31_0:enableSchedule():unSchedule(var_31_7)
		arg_31_0:schedule(function()
			if not var_31_6() then
				arg_31_0:onBtnRankClick()

				return false
			end
		end, 1, 1, var_31_7)
	end
end

local var_0_4 = {}

var_0_4.yybox = "box_point"
var_0_4.yybox1 = "box_point1"
var_0_4.yybox2 = "box_point2"

function var_0_3.resetRankInfo(arg_34_0, arg_34_1)
	local var_34_0 = clone(arg_34_1)
	local var_34_1 = #arg_34_1
	local var_34_2 = 30

	if var_34_2 < var_34_1 then
		for iter_34_0 = var_34_2 + 1, var_34_1 do
			var_34_0[iter_34_0] = nil
		end
	end

	local var_34_3 = csv.yunying.yyhuodong[arg_34_0.activityId:read()].paramMap

	if var_34_3.rankKey then
		arg_34_0.key = var_0_4[var_34_3.rankKey]
	end

	arg_34_0.rankData:set(var_34_0)
end

function var_0_3.onCardSprClick(arg_35_0)
	if arg_35_0.sprState:read() == 1 then
		arg_35_0.sprState:set(0)
	else
		arg_35_0.sprState:set(1)
	end
end

function var_0_3.onBtnRankClick(arg_36_0)
	gGameApp:requestServer("/game/yy/limit/box/get", function(arg_37_0)
		arg_36_0:resetRankInfo(arg_37_0.view.rank)
		arg_36_0.curListType:set(var_0_0.RANK)
	end, arg_36_0.activityId:read())
end

function var_0_3.onBtnAwardClick(arg_38_0)
	arg_38_0.curListType:set(var_0_0.AWARD)
end

function var_0_3.initAwardData(arg_39_0)
	local var_39_0 = arg_39_0.cfg.huodongID
	local var_39_1 = {}
	local var_39_2 = 0

	for iter_39_0, iter_39_1 in csvPairs(csv.yunying.limitboxrankaward) do
		if iter_39_1.huodongID == var_39_0 then
			table.insert(var_39_1, {
				point = iter_39_1.pointLeast,
				award = iter_39_1.award,
				rankStart = var_39_2,
				rankEnd = iter_39_1.rank,
				desc = desc
			})

			var_39_2 = iter_39_1.rank
		end
	end

	table.sort(var_39_1, function(arg_40_0, arg_40_1)
		return arg_40_0.point > arg_40_1.point
	end)

	arg_39_0.awardData = var_39_1
end

function var_0_3.initSelfInfo(arg_41_0)
	idlereasy.when(arg_41_0.yyhuodongs, function(arg_42_0, arg_42_1)
		local var_42_0 = arg_42_1[arg_41_0.activityId:read()]
		local var_42_1 = arg_41_0.myrank:multiget("rank", "score", "name")
		local var_42_2 = var_42_0.box_point or 0

		arg_41_0.boxPoint = var_42_2

		var_42_1.rank:text(var_42_0.info.rank or gLanguageCsv.craftNoRank)
		var_42_1.score:text(var_42_2)
		var_42_1.name:text(gGameModel.role:read("name"))

		local var_42_3 = var_42_0.stamps or {}
		local var_42_4 = arg_41_0.boxCount or 0
		local var_42_5 = 0

		for iter_42_0 = 1, var_42_4 do
			local var_42_6 = arg_41_0.boxData:proxy()[var_42_4 - iter_42_0 + 1]
			local var_42_7 = var_42_3[var_42_6.id]

			var_42_6.state = var_42_7

			if var_42_7 then
				var_42_5 = math.max(var_42_5, iter_42_0)
			end
		end

		arg_41_0:resetBoxBar(var_42_5)
	end)
end

function var_0_3.onHandBookClick(arg_43_0)
	if not dataEasy.isUnlock("handbook") then
		gGameUI:showTip(dataEasy.getUnlockTip("handbook"))

		return
	end

	local var_43_0 = arg_43_0.curDevelopId:read()

	jumpEasy.jumpTo("handbook", {
		cardId = arg_43_0.markTb[var_43_0].id
	})
end

function var_0_3.onRightClick(arg_44_0)
	local var_44_0 = table.length(arg_44_0.markTb)
	local var_44_1 = arg_44_0.curDevelopId:read()

	arg_44_0.curDevelopId:set(math.min(var_44_1 + 1, var_44_0))
end

function var_0_3.onLeftClick(arg_45_0)
	local var_45_0 = arg_45_0.curDevelopId:read()

	arg_45_0.curDevelopId:set(math.max(var_45_0 - 1, 1))
end

function var_0_3.isEnoughToDraw(arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = arg_46_0.isFree:read()

	if arg_46_2 > 1 then
		var_46_0 = false
	end

	local var_46_1 = dataEasy.getNumByKey(game.ITEM_TICKET.spriteCard)
	local var_46_2 = dataEasy.getCfgByKey(game.ITEM_TICKET.spriteCard)

	if not var_46_0 and var_46_1 < arg_46_2 then
		gGameUI:showDialog({
			content = string.format(gLanguageCsv.limitCardNotEnough, var_46_2.name),
			cb = function()
				arg_46_0:onBtnXdlbClick()
			end,
			closeCb = function()
				return
			end
		})

		return false
	end

	if arg_46_0.cardCapacity:read() - itertools.size(arg_46_0.cardDatas:read()) <= var_0_1[arg_46_2] and csv.yunying.yyhuodong[arg_46_0.activityId:read()].showTips and arg_46_0.checkCardCapacity:read() == 1 then
		gGameUI:showDialog({
			btnType = 2,
			clearFast = true,
			content = gLanguageCsv.cardBagHaveBeenFullDraw,
			cb = function()
				gGameUI:stackUI("city.card.bag", nil, {
					full = true
				})
			end
		})

		return false
	end

	return true
end

function var_0_3.onDrawOneClick(arg_50_0)
	if not arg_50_0:isEnoughToDraw(arg_50_0.oneCost, 1) then
		return
	end

	local var_50_0 = arg_50_0.isFree:read()
	local var_50_1 = arg_50_0.activityId:read()
	local var_50_2 = var_50_0 and "limit_box_free1" or "limit_box_rmb1"
	print("free draw:", var_50_0, var_50_2)
	local function var_50_3()
		gGameApp:requestServer("/game/yy/limit/box/draw", function(arg_52_0)
			arg_50_0:resetRankInfo(arg_52_0.view.rank)
			audio.pauseMusic()
			audio.playEffectWithWeekBGM("drawcard_one.mp3")

			local var_52_0, var_52_1, var_52_2 = dataEasy.getRawTable(arg_52_0)
			local var_52_3 = dataEasy.getItems(var_52_0, var_52_1)
			local var_52_4 = {
				drawType = "limit_sprite",
				times = 1,
				items = var_52_3,
				isFree = var_50_0,
				yyId = var_50_1,
				checkCardCapacity = arg_50_0.checkCardCapacity:read()
			}

			gGameUI:stackUI("city.drawcard.result", nil, nil, var_52_4)
		end, var_50_1, var_50_2)
	end

	if var_50_0 then
		var_50_3()
	else
		dataEasy.sureUsingDiamonds(var_50_3, arg_50_0.oneCost)
	end
end

function var_0_3.onDrawTenClick(arg_53_0)
	if not arg_53_0:isEnoughToDraw(arg_53_0.tenCost, 10) then
		return
	end

	dataEasy.sureUsingDiamonds(function()
		local var_54_0 = arg_53_0.activityId:read()

		gGameApp:requestServer("/game/yy/limit/box/draw", function(arg_55_0)
			arg_53_0:resetRankInfo(arg_55_0.view.rank)
			audio.pauseMusic()
			audio.playEffectWithWeekBGM("drawcard_ten.mp3")

			local var_55_0, var_55_1, var_55_2 = dataEasy.getRawTable(arg_55_0)
			local var_55_3 = dataEasy.getItems(var_55_0, var_55_1)
			local var_55_4 = {
				isFree = false,
				drawType = "limit_sprite",
				times = 10,
				items = var_55_3,
				yyId = var_54_0,
				cb = function(arg_56_0)
					arg_53_0:resetRankInfo(arg_56_0.view.rank)
				end
			}

			gGameUI:stackUI("city.drawcard.result", nil, nil, var_55_4)
		end, var_54_0, "limit_box_rmb10")
	end, arg_53_0.tenCost)
end

function var_0_3.onShowAwardList(arg_57_0)
	gGameUI:stackUI("city.drawcard.preview", nil, {
		clickClose = true,
		blackLayer = true
	}, "limit_sprite", arg_57_0.activityId:read())
end

function var_0_3.onShowRule(arg_58_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_58_0:createHandler("getRuleContext"))
end

function var_0_3.getRuleContext(arg_59_0, arg_59_1)
	local var_59_0 = adaptContext

	return {
		var_59_0.clone(arg_59_1.title, function(arg_60_0)
			arg_60_0:get("text"):text(gLanguageCsv.limitSpriteRuleTitle)
		end),
		var_59_0.noteText(117),
		var_59_0.noteText(64001, 64005),
		var_59_0.noteText(118),
		var_59_0.noteText(65001, 65004)
	}
end

function var_0_3.onClose(arg_61_0)
	local var_61_0 = arg_61_0.closeCb

	Dialog.onClose(arg_61_0)

	if var_61_0 then
		var_61_0()
	end
end

function var_0_3.onBtnSxhlClick(arg_62_0)
	local var_62_0 = arg_62_0.activityId:read()
	local var_62_1 = csv.yunying.yyhuodong[var_62_0]

	gGameUI:stackUI("city.activity.recharge_feedback.stargift", nil, nil, var_62_1.huodongID, var_62_0, arg_62_0.aniArgs)
end

function var_0_3.onBtnXdlbClick(arg_63_0)
	gGameUI:stackUI("city.activity.focus_buy_gift", nil, nil, arg_63_0.activityId:read())
end

return var_0_3
