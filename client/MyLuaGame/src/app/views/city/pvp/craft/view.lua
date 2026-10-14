local var_0_0 = 10
local var_0_1 = 10
local var_0_2 = class("CraftMainView", cc.load("mvc").ViewBase)

var_0_2.RESOURCE_FILENAME = "craft_main.json"
var_0_2.RESOURCE_BINDING = {
	item = "item",
	["top1.down.textLv"] = "top1Lv",
	["top2.down.textLv"] = "top2Lv",
	["top3.down.textLv"] = "top3Lv",
	["down.imgFlag"] = "imgFlag",
	["top3.down.textFightPoint"] = "top3FightPoint",
	["top1.down.textFightPoint"] = "top1FightPoint",
	["top2.down.textFightPoint"] = "top2FightPoint",
	["top2.down.textName"] = "top2Name",
	["top3.down.textName"] = "top3Name",
	["top1.down.textName"] = "top1Name",
	btnMyTeam = {
		varname = "btnMyTeam",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSignup")
			}
		}
	},
	["btns.btnRule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnRule")
			}
		}
	},
	["btns.btnRule.textNote"] = {
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
	["btns.btnRankReward"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnReward")
			}
		}
	},
	["btns.btnRankReward.textNote"] = {
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
	["btns.btnRecord"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnRecord")
			}
		}
	},
	["btns.btnRecord.textNote"] = {
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
	["btns.btnBet"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnBet")
			}
		}
	},
	["btns.btnBet.textNote"] = {
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
	["btns.btnShop"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnShop")
			}
		}
	},
	["btns.btnShop.textNote"] = {
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
	["down.btnOk"] = {
		varname = "btnOk",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSignup")
			}
		}
	},
	["down.btnOk.textNote"] = {
		varname = "btnOkText",
		binds = {
			{
				event = "text",
				idler = bindHelper.self("btnText")
			},
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
	},
	["btnMyTeam.textNote"] = {
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
	["down.btnOk.mask"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("round"),
			method = function(arg_1_0)
				return arg_1_0 == "closed"
			end
		}
	},
	["down.vipShow"] = {
		varname = "vipShow",
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
	["down.textTime"] = {
		varname = "textTime",
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
	["down.textTimeNote"] = {
		varname = "textTimeNote",
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
	special = {
		binds = {
			event = "visible",
			idler = bindHelper.self("hasSpecial")
		}
	},
	["special.list"] = {
		varname = "listview",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("attrDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					for iter_2_0 = 1, 2 do
						arg_2_1:get("icon" .. iter_2_0):hide()
					end

					local var_2_0 = 0

					for iter_2_1, iter_2_2 in ipairs(arg_2_3.natureTypes) do
						arg_2_1:get("icon" .. iter_2_1):texture(ui.ATTR_ICON[iter_2_2])
						arg_2_1:get("icon" .. iter_2_1):show()

						var_2_0 = var_2_0 + 1
					end

					local var_2_1 = game.ATTRDEF_TABLE[arg_2_3.attrType]
					local var_2_2 = "attr" .. string.caption(var_2_1)

					arg_2_1:get("textName"):text(gLanguageCsv[var_2_2])

					local var_2_3 = dataEasy.getAttrValueString(arg_2_3.attrType, arg_2_3.attrNum)

					arg_2_1:get("textVal"):text("+" .. var_2_3)
					text.addEffect(arg_2_1:get("textName"), {
						outline = {
							size = 3,
							color = ui.NEWCOLORS.OUTLINE.BLACK
						}
					})
					text.addEffect(arg_2_1:get("textVal"), {
						outline = {
							size = 3,
							color = ui.NEWCOLORS.OUTLINE.BLACK
						}
					})

					local var_2_4 = var_2_0 == 1 and arg_2_1:get("icon1") or arg_2_1:get("icon2")

					adapt.oneLinePos(var_2_4, {
						arg_2_1:get("textName"),
						arg_2_1:get("textVal")
					}, cc.p(10, 0))
				end
			}
		}
	},
	top1 = {
		varname = "top1",
		binds = {
			event = "click",
			method = bindHelper.defer(function(arg_3_0)
				return arg_3_0:onShowInfo(1)
			end)
		}
	},
	top2 = {
		varname = "top2",
		binds = {
			event = "click",
			method = bindHelper.defer(function(arg_4_0)
				return arg_4_0:onShowInfo(2)
			end)
		}
	},
	top3 = {
		varname = "top3",
		binds = {
			event = "click",
			method = bindHelper.defer(function(arg_5_0)
				return arg_5_0:onShowInfo(3)
			end)
		}
	},
	["top1.down.textFightPointNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["top2.down.textFightPointNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["top3.down.textFightPointNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["top1.down"] = {
		varname = "down1",
		binds = {
			event = "visible",
			idler = bindHelper.self("hasHistoryData")
		}
	},
	["top2.down"] = {
		varname = "down2",
		binds = {
			event = "visible",
			idler = bindHelper.self("hasHistoryData")
		}
	},
	["top3.down"] = {
		varname = "down3",
		binds = {
			event = "visible",
			idler = bindHelper.self("hasHistoryData")
		}
	},
	["top1.noOne"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("hasHistoryData"),
			method = function(arg_6_0)
				return not arg_6_0
			end
		}
	},
	["top2.noOne"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("hasHistoryData"),
			method = function(arg_7_0)
				return not arg_7_0
			end
		}
	},
	["top3.noOne"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("hasHistoryData"),
			method = function(arg_8_0)
				return not arg_8_0
			end
		}
	},
	marqueePanel = {
		varname = "marqueePanel",
		binds = {
			event = "extend",
			class = "marquee"
		}
	}
}

function var_0_2.onCreate(arg_9_0)
	gGameUI.topuiManager:createView("default", arg_9_0, {
		onClose = arg_9_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = "common/txt/txt_bt_renzhedasai.png"
	})

	arg_9_0.topData = {}

	arg_9_0:initModel()

	arg_9_0.attrDatas = idlers.newWithMap({})
	arg_9_0.hasSpecial = idler.new(false)

	local var_9_0 = csv.craft.buffs

	arg_9_0.delta = var_0_1
	arg_9_0.btnText = idler.new(gLanguageCsv.signup)

	adapt.setTextScaleWithWidth(arg_9_0.btnOkText, gLanguageCsv.signup, 380)
	idlereasy.any({
		arg_9_0.isSignup,
		arg_9_0.round,
		arg_9_0.time,
		arg_9_0.buffs
	}, function(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
		if arg_10_2 == "prepare" then
			gGameUI:goBackInStackUI("city.adventure.pvp")
			gGameUI:stackUI("city.pvp.craft.myschedule", nil, {
				full = true
			})

			return
		end

		local var_10_0 = arg_10_1 and arg_10_2 == "signup"

		arg_9_0.btnMyTeam:visible(var_10_0)
		arg_9_0.imgFlag:visible(var_10_0)
		arg_9_0.vipShow:text(string.format(gLanguageCsv.vipSignupShow, csv.craft.base[1].autoSignVIP))
		arg_9_0.vipShow:visible(false)
		arg_9_0.btnOk:visible(not var_10_0)

		local var_10_1 = gLanguageCsv.signTime
		local var_10_2 = string.format("%s-%s", dataEasy.getTimeStrByKey("craft", "signUpStart"), dataEasy.getTimeStrByKey("craft", "signUpEnd"))
		local var_10_3 = cc.p(240, 200)

		if var_10_0 then
			var_10_1 = gLanguageCsv.startTime
			var_10_2 = dataEasy.getTimeStrByKey("craft", "matchStart")
			var_10_3 = cc.p(226, 200)
		end

		arg_9_0.textTime:text(var_10_2)
		adapt.oneLineCenterPos(var_10_3, {
			arg_9_0.textTimeNote,
			arg_9_0.textTime
		}, cc.p(6, 0))

		local var_10_4 = {}
		local var_10_5 = 0

		for iter_10_0, iter_10_1 in ipairs(arg_10_4) do
			var_10_5 = var_10_5 + 1

			local var_10_6 = {}
			local var_10_7 = var_9_0[iter_10_1]

			var_10_6.natureTypes = var_10_7.natureTypes
			var_10_6.attrType = var_10_7.attrType
			var_10_6.attrNum = var_10_7.attrNum

			table.insert(var_10_4, var_10_6)
		end

		arg_9_0.attrDatas:update(var_10_4)
		arg_9_0.hasSpecial:set(var_10_5 > 0)

		local var_10_8 = gLanguageCsv.signup

		if arg_10_2 == "signup" then
			local var_10_9, var_10_10 = dataEasy.getTimeStrByKey("craft", "matchStart", true)
			local var_10_11 = time.getNowDate()

			var_10_11.hour = var_10_9
			var_10_11.min = var_10_10
			var_10_11.second = 0
			arg_9_0.delta = time.getTimestamp(var_10_11) - time.getTime()

			arg_9_0.vipShow:visible(not var_10_0)
		elseif arg_10_2 == "over" or arg_10_2 == "closed" then
			arg_9_0.delta = arg_9_0:getNextStartTime()
			var_10_8 = gLanguageCsv.craftNotOpen
		end

		if matchLanguage({
			"en"
		}) then
			if arg_10_2 == "signup" and not var_10_0 then
				var_10_1 = gLanguageCsv.endSignUpTime
			elseif arg_10_2 == "over" or arg_10_2 == "closed" then
				var_10_1 = gLanguageCsv.startSignUpTime
			end
		end

		arg_9_0.textTimeNote:text(var_10_1)
		arg_9_0.btnText:set(var_10_8)
		adapt.setTextScaleWithWidth(arg_9_0.btnOkText, var_10_8, 380)
	end)
	arg_9_0:enableSchedule():schedule(function()
		arg_9_0.delta = arg_9_0.delta - 1

		if arg_9_0.delta < 0 then
			arg_9_0.delta = var_0_1

			gGameApp:requestServer("/game/craft/battle/main")
		elseif matchLanguage({
			"en"
		}) or arg_9_0.isSignup:read() and arg_9_0.round:read() == "signup" then
			local var_11_0 = time.getCutDown(arg_9_0.delta)

			arg_9_0.textTime:text(var_11_0.str)
			adapt.oneLineCenterPos(cc.p(226, 200), {
				arg_9_0.textTimeNote,
				arg_9_0.textTime
			}, cc.p(6, 0))
		end
	end, 1, 0)
end

function var_0_2.initItem(arg_12_0, arg_12_1, arg_12_2)
	arg_12_1:get("role"):removeChildByName("card")
	arg_12_1:get("role"):removeChildByName("figure")

	local var_12_0 = gRoleFigureCsv
	local var_12_1 = csv.cards
	local var_12_2 = csv.unit
	local var_12_3 = arg_12_2.display.top_card
	local var_12_4 = arg_12_2.display.skin_id
	local var_12_5 = dataEasy.getUnitCsv(var_12_3, var_12_4)
	local var_12_6 = var_12_0[arg_12_2.figure]
	local var_12_7 = arg_12_1:size()

	if string.len(var_12_6.resSpine or "") > 0 then
		widget.addAnimationByKey(arg_12_1:get("role"), var_12_6.resSpine, "figure", "standby_loop", 3):xy(var_12_7.width / 2, 35):scale(0.85)
	end

	if arg_12_2.title > 0 then
		bind.extend(arg_12_0, arg_12_1, {
			event = "extend",
			class = "role_title",
			props = {
				data = arg_12_2.title,
				onNode = function(arg_13_0)
					arg_13_0:xy(var_12_7.width / 2 + 50, var_12_7.height + 50)
					arg_13_0:scale(2)
					arg_13_0:z(3)
				end
			}
		})
	end
end

function var_0_2.initModel(arg_14_0)
	arg_14_0.vip = gGameModel.role:getIdler("vip_level")
	arg_14_0.cards = gGameModel.role:getIdler("cards")
	arg_14_0.hasHistoryData = idler.new(false)
	arg_14_0.isSignup = gGameModel.daily_record:getIdler("craft_sign_up")

	local var_14_0 = gGameModel.craft

	arg_14_0.round = var_14_0:getIdler("round")
	arg_14_0.buffs = var_14_0:getIdler("buffs")
	arg_14_0.signup = var_14_0:read("signup")
	arg_14_0.history = var_14_0:getIdler("history")
	arg_14_0.time = var_14_0:getIdler("time")
	arg_14_0.top8Plays = var_14_0:getIdler("top8_plays")
	arg_14_0.battleMessages = var_14_0:getIdler("battle_messages")

	local var_14_1 = var_14_0:getIdler("yesterday_top8_plays")

	idlereasy.when(var_14_1, function(arg_15_0, arg_15_1)
		if not arg_15_1 then
			return
		end

		local var_15_0 = arg_15_1.champion
		local var_15_1 = arg_15_1.third
		local var_15_2 = false

		if var_15_0 and var_15_1 then
			var_15_2 = true
			arg_14_0.topData = {}

			local var_15_3 = var_15_0.result == "win" and var_15_0.role1 or var_15_0.role2
			local var_15_4 = var_15_0.result == "win" and var_15_0.role2 or var_15_0.role1
			local var_15_5 = var_15_1.result == "win" and var_15_1.role1 or var_15_1.role2

			table.insert(arg_14_0.topData, var_15_3)
			table.insert(arg_14_0.topData, var_15_4)
			table.insert(arg_14_0.topData, var_15_5)

			for iter_15_0, iter_15_1 in ipairs(arg_14_0.topData) do
				arg_14_0["top" .. iter_15_0 .. "Lv"]:text("Lv" .. iter_15_1.level)
				arg_14_0["top" .. iter_15_0 .. "Name"]:text(iter_15_1.name)
				arg_14_0["top" .. iter_15_0 .. "FightPoint"]:text(iter_15_1.display.fighting_point)
				text.addEffect(arg_14_0["top" .. iter_15_0 .. "Lv"], {
					outline = {
						size = 3,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				})
				text.addEffect(arg_14_0["top" .. iter_15_0 .. "Name"], {
					outline = {
						size = 3,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				})
				text.addEffect(arg_14_0["top" .. iter_15_0 .. "FightPoint"], {
					outline = {
						size = 3,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				})
				arg_14_0:initItem(arg_14_0["top" .. iter_15_0], iter_15_1)
			end
		end

		arg_14_0.hasHistoryData:set(var_15_2)
	end)
end

function var_0_2.onShowInfo(arg_16_0, arg_16_1)
	if not arg_16_0.topData[arg_16_1] then
		return
	end

	gGameApp:requestServer("/game/craft/battle/enemy/get", function(arg_17_0)
		gGameUI:stackUI("city.pvp.craft.enemy_embattle", nil, nil, arg_17_0.view, 2)
	end, arg_16_0.topData[arg_16_1].role_db_id, arg_16_0.topData[arg_16_1].record_db_id)
end

function var_0_2.onBtnRule(arg_18_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_18_0:createHandler("getRuleContext"), {
		width = 1500
	})
end

function var_0_2.getRuleContext(arg_19_0, arg_19_1)
	local var_19_0 = adaptContext

	return {
		var_19_0.clone(arg_19_1.title, function(arg_20_0)
			arg_20_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_19_0.noteText(112),
		var_19_0.noteText(39001, 39010),
		var_19_0.noteText(113),
		var_19_0.noteText(40001, 40005),
		var_19_0.noteText(114),
		var_19_0.noteText(41001, 41004),
		var_19_0.noteText(115),
		var_19_0.noteText(42001, 42004)
	}
end

function var_0_2.getNextStartTime(arg_21_0)
	local var_21_0 = arg_21_0.round:read()
	local var_21_1 = 0

	if var_21_0 ~= "closed" and var_21_0 ~= "over" then
		return var_21_1
	end

	local var_21_2 = time.getTime()
	local var_21_3 = time.getDate(var_21_2)
	local var_21_4 = var_21_3.wday == 1 and 7 or var_21_3.wday - 1
	local var_21_5 = csv.craft.base[1]
	local var_21_6 = tonumber(string.format("%02d%02d", var_21_3.hour, var_21_3.min))
	local var_21_7 = itertools.include(var_21_5.openWeekday, var_21_4)
	local var_21_8, var_21_9 = dataEasy.getTimeStrByKey("craft", "signUpStart", true)

	if var_21_7 and var_21_6 < var_21_8 * 100 + var_21_9 then
		var_21_3.hour = var_21_8
		var_21_3.min = 0
		var_21_3.sec = 0
		var_21_1 = time.getTimestamp(var_21_3) - var_21_2
	else
		local var_21_10 = var_21_5.openWeekday[1]

		for iter_21_0, iter_21_1 in ipairs(var_21_5.openWeekday) do
			if var_21_4 < iter_21_1 then
				var_21_10 = iter_21_1

				break
			end
		end

		local var_21_11 = var_21_10 - var_21_4

		if var_21_11 < 0 then
			var_21_11 = var_21_11 + 7 - 1
		end

		local var_21_12 = clone(var_21_3)

		var_21_12.hour = 24
		var_21_12.min = 24
		var_21_12.sec = 24
		var_21_1 = time.getTimestamp(var_21_12) - var_21_2
		var_21_1 = var_21_1 + var_21_11 * 24 * 3600 + var_21_8 * 3600
	end

	return var_21_1
end

function var_0_2.onBtnReward(arg_22_0)
	gGameApp:requestServer("/game/rank", function(arg_23_0)
		gGameUI:stackUI("city.pvp.craft.rank", nil, nil, arg_23_0.view)
	end, "craft", 0, 50)
end

function var_0_2.onBtnRecord(arg_24_0)
	if not arg_24_0.hasHistoryData:read() then
		return
	end

	gGameUI:stackUI("city.pvp.craft.mainschedule_eight", nil, {
		full = true
	}, true)
end

function var_0_2.onBtnBet(arg_25_0)
	gGameApp:requestServer("/game/craft/bet/info", function(arg_26_0)
		gGameUI:stackUI("city.pvp.craft.bet", nil, nil, arg_26_0.view)
	end)
end

function var_0_2.onBtnShop(arg_27_0)
	if not gGameUI:goBackInStackUI("city.shop") then
		gGameApp:requestServer("/game/fixshop/get", function(arg_28_0)
			gGameUI:stackUI("city.shop", nil, {
				full = true
			}, game.SHOP_INIT.CRAFT_SHOP)
		end)
	end
end

function var_0_2.canSignUp(arg_29_0)
	local var_29_0 = false
	local var_29_1 = dataEasy.getInMeteorCardsHash()
	local var_29_2 = arg_29_0.cards:read()

	if itertools.size(var_29_2) < 10 then
		return var_29_0
	end

	local var_29_3 = csv.cards
	local var_29_4 = {}
	local var_29_5 = 0

	for iter_29_0, iter_29_1 in ipairs(var_29_2) do
		local var_29_6 = var_29_3[gGameModel.cards:find(iter_29_1):read("card_id")].cardMarkID

		if not var_29_4[var_29_6] and not var_29_1[iter_29_1] then
			var_29_4[var_29_6] = true
			var_29_5 = var_29_5 + 1
		end

		if var_29_5 >= 10 then
			var_29_0 = true

			break
		end
	end

	return var_29_0
end

function var_0_2.onSignup(arg_30_0)
	local var_30_0 = arg_30_0.round:read()

	if arg_30_0.round:read() == "closed" or arg_30_0.round:read() == "over" then
		local var_30_1 = arg_30_0.time:read()
		local var_30_2 = time.getDate(var_30_1)

		var_30_2.hour = 0
		var_30_2.min = 0
		var_30_2.sec = 0

		local var_30_3 = time.getTimestamp(var_30_2)
		local var_30_4 = time.getTime()
		local var_30_5 = gLanguageCsv.battleIsOver

		if var_30_4 > var_30_3 + 104400 then
			var_30_5 = gLanguageCsv.battleNotOpen
		end

		gGameUI:showTip(var_30_5)

		return
	end

	if not arg_30_0:canSignUp() then
		gGameUI:showTip(gLanguageCsv.cardNotEnough)

		return
	end

	local var_30_6 = csv.craft.base[1]
	local var_30_7 = var_30_6.numMax

	if var_30_6.autoSignVIP > arg_30_0.vip:read() and var_30_7 <= arg_30_0.signup then
		gGameUI:showTip(gLanguageCsv.signupNumIsMax)

		return
	end

	local var_30_8 = false
	local var_30_9 = gGameModel.craft:read("info").cards

	for iter_30_0, iter_30_1 in pairs(var_30_9) do
		if not gGameModel.cards:find(iter_30_1) then
			var_30_8 = true

			break
		end
	end

	if var_30_8 or itertools.size(var_30_9) < var_0_0 then
		local var_30_10 = false
		local var_30_11 = gGameModel.role:read("cards")
		local var_30_12 = {}

		if itertools.size(var_30_11) >= 10 then
			local var_30_13 = {}

			for iter_30_2, iter_30_3 in ipairs(var_30_11) do
				local var_30_14 = gGameModel.cards:find(iter_30_3):read("card_id", "fighting_point")
				local var_30_15 = csv.cards[var_30_14.card_id]
				local var_30_16 = csv.unit[var_30_15.unitID]

				table.insert(var_30_13, {
					id = iter_30_3,
					fighting_point = var_30_14.fighting_point,
					rarity = var_30_16.rarity
				})
			end

			table.sort(var_30_13, function(arg_31_0, arg_31_1)
				if arg_31_0.fighting_point ~= arg_31_1.fighting_point then
					return arg_31_0.fighting_point > arg_31_1.fighting_point
				end

				return arg_31_0.rarity > arg_31_1.rarity
			end)

			local var_30_17 = dataEasy.getInMeteorCardsHash()
			local var_30_18 = {}
			local var_30_19 = 0

			for iter_30_4, iter_30_5 in ipairs(var_30_13) do
				local var_30_20 = iter_30_5.id
				local var_30_21 = gGameModel.cards:find(var_30_20):read("card_id")
				local var_30_22 = csv.cards[var_30_21].cardMarkID

				if not var_30_18[var_30_22] and not var_30_17[var_30_20] then
					var_30_18[var_30_22] = true

					table.insert(var_30_12, var_30_20)

					var_30_19 = var_30_19 + 1
				end

				if var_30_19 >= var_0_0 then
					var_30_10 = true

					break
				end
			end
		end

		if not var_30_10 then
			gGameUI:showTip(gLanguageCsv.cardNotEnough)

			return
		end

		local var_30_23 = gGameModel.daily_record:read("craft_sign_up")
		local var_30_24 = "/game/craft/battle/deploy"
		local var_30_25 = gLanguageCsv.battleResetSuccess

		if not var_30_23 then
			var_30_24 = "/game/craft/signup"
			var_30_25 = gLanguageCsv.signUpSuccess
		end

		gGameApp:requestServer(var_30_24, function(arg_32_0)
			gGameUI:stackUI("city.pvp.craft.embattle", nil, {
				full = true
			})
			gGameUI:showTip(var_30_25)
		end, var_30_12)

		return
	end

	if not gGameModel.daily_record:read("craft_sign_up") then
		gGameApp:requestServer("/game/craft/signup", function(arg_33_0)
			gGameUI:stackUI("city.pvp.craft.embattle", nil, {
				full = true
			})
			gGameUI:showTip(gLanguageCsv.signUpSuccess)
		end, var_30_9)

		return
	end

	gGameUI:stackUI("city.pvp.craft.embattle", nil, {
		full = true
	})
end

return var_0_2
