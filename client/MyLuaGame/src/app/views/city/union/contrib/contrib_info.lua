local var_0_0 = class("UnionContribInfoView", Dialog)

var_0_0.RESOURCE_FILENAME = "union_contribute.json"
var_0_0.RESOURCE_BINDING = {
	item = "item",
	imgBG = "imgBg",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	textProgress1 = {
		binds = {
			event = "text",
			idler = bindHelper.self("unionCurLvExp")
		}
	},
	textProgress2 = {
		binds = {
			event = "text",
			idler = bindHelper.self("todayExp")
		}
	},
	textCount = {
		binds = {
			event = "text",
			idler = bindHelper.self("leftCount")
		}
	},
	bar1 = {
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				maskImg = "common/icon/mask_bar_red.png",
				data = bindHelper.self("unionExpPro")
			}
		}
	},
	bar2 = {
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				maskImg = "common/icon/mask_bar_red.png",
				data = bindHelper.self("todayExpPro")
			}
		}
	},
	["left.btnContrbute"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onContrbuteClick")
			}
		}
	},
	["left.btnRule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleClick")
			}
		}
	},
	["top.textCount"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("allCount")
		}
	},
	["top.textNote"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("tipNote")
		}
	},
	["top.textProgress"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("textProgress")
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("itemDatas"),
				item = bindHelper.self("item"),
				vip = bindHelper.self("vip"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("textTitle", "info1", "info2", "cost", "btnOk")

					var_1_0.textTitle:text(gLanguageCsv[arg_1_3.cfg.title])
					var_1_0.info1:get("textAddNum"):text("+" .. arg_1_3.cfg.contrib)

					local var_1_1, var_1_2 = csvNext(arg_1_3.cfg.award)

					var_1_0.info2:get("textAddNum"):text("+" .. var_1_2)

					local var_1_3, var_1_4 = csvNext(arg_1_3.cfg.cost)
					local var_1_5 = var_1_0.cost:get("textNum")

					var_1_5:text(var_1_4)

					local var_1_6 = dataEasy.getNumByKey(var_1_3)
					local var_1_7 = ui.NEWCOLORS.BROWN1

					if not arg_1_3.isEnough then
						var_1_7 = ui.COLORS.NORMAL.RED
					end

					text.addEffect(var_1_5, {
						color = var_1_7
					})

					local var_1_8 = var_1_0.cost:get("imgIcon")

					var_1_8:texture(dataEasy.getIconResByKey(var_1_3))
					adapt.oneLineCenterPos(cc.p(150, 35), {
						var_1_0.cost:get("textNote"),
						var_1_5,
						var_1_8
					}, cc.p(6, 0))

					local var_1_9 = arg_1_0.vip:read() >= arg_1_3.cfg.vipNeed

					if not var_1_9 then
						var_1_0.btnOk:get("textNote"):text(string.format(gLanguageCsv.vipCanUse, arg_1_3.cfg.vipNeed))

						if matchLanguage({
							"kr"
						}) then
							var_1_0.btnOk:get("textNote"):setFontSize(38)
						end
					end

					cache.setShader(var_1_0.btnOk, false, arg_1_3.canContrubute and var_1_9 and "normal" or "hsl_gray")

					if arg_1_3.canContrubute and var_1_9 then
						text.addEffect(var_1_0.btnOk:get("textNote"), {
							outline = {
								size = 4,
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							}
						})
					else
						text.deleteAllEffect(var_1_0.btnOk:get("textNote"))
						text.addEffect(var_1_0.btnOk:get("textNote"), {
							color = ui.COLORS.DISABLED.WHITE
						})
					end

					bind.touch(arg_1_0, var_1_0.btnOk, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_2_0)
	arg_2_0.list:setName("contribInfoList")
	arg_2_0:initModel()

	arg_2_0.unionExpPro = idler.new(0)
	arg_2_0.todayExpPro = idler.new(0)
	arg_2_0.todayExp = idler.new("")
	arg_2_0.unionCurLvExp = idler.new("")
	arg_2_0.leftCount = idler.new("")

	local var_2_0 = {}

	for iter_2_0, iter_2_1 in orderCsvPairs(csv.union.contrib) do
		local var_2_1 = {
			cfg = iter_2_1,
			csvId = iter_2_0
		}

		var_2_1.canContrubute = true

		local var_2_2, var_2_3 = csvNext(var_2_1.cfg.cost)
		local var_2_4 = dataEasy.getNumByKey(var_2_2)

		if var_2_2 == "gold" then
			var_2_1.isEnough = var_2_3 <= var_2_4
		elseif var_2_2 == "rmb" then
			var_2_1.isEnough = var_2_3 <= var_2_4
		end

		table.insert(var_2_0, var_2_1)
	end

	arg_2_0.itemDatas = idlers.newWithMap(var_2_0)

	local var_2_5 = {
		arg_2_0.unionLv,
		arg_2_0.unionExp,
		arg_2_0.unionDayExp,
		arg_2_0.contribCount
	}

	idlereasy.any(var_2_5, function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		local var_3_0 = csv.union.union_level
		local var_3_1 = var_3_0[arg_3_1].levelUpContrib
		local var_3_2 = 0

		for iter_3_0 = 1, arg_3_1 - 1 do
			var_3_2 = var_3_2 + var_3_0[iter_3_0].levelUpContrib
		end

		local var_3_3 = arg_3_2 - var_3_2

		arg_2_0.unionCurLvExp:set(string.format("%d/%d", var_3_3, var_3_1))

		local var_3_4 = var_3_3 / var_3_1 * 100

		arg_2_0.unionExpPro:set(var_3_4)

		local var_3_5 = var_3_0[arg_3_1].ContribSumMax
		local var_3_6 = arg_3_3 / var_3_5 * 100

		arg_2_0.todayExp:set(string.format("%d/%d", arg_3_3, var_3_5))
		arg_2_0.todayExpPro:set(var_3_6)

		local var_3_7 = var_3_0[arg_3_1].ContribMax
		local var_3_8 = var_3_7 - arg_3_4

		arg_2_0.leftCount:set(string.format("%d/%d", var_3_8, var_3_7))

		if var_3_8 <= 0 then
			for iter_3_1 = 1, 3 do
				arg_2_0.itemDatas:atproxy(iter_3_1).canContrubute = false
			end
		end
	end)
	idlereasy.any({
		arg_2_0.gold,
		arg_2_0.rmb
	}, function(arg_4_0, arg_4_1, arg_4_2)
		for iter_4_0, iter_4_1 in ipairs(var_2_0) do
			local var_4_0, var_4_1 = csvNext(iter_4_1.cfg.cost)

			if var_4_0 == "gold" then
				arg_2_0.itemDatas:atproxy(iter_4_0).isEnough = var_4_1 <= arg_4_1
			elseif var_4_0 == "rmb" then
				arg_2_0.itemDatas:atproxy(iter_4_0).isEnough = var_4_1 <= arg_4_2
			end
		end
	end)

	if arg_2_0.imgBg:get("privilege") then
		arg_2_0.imgBg:get("privilege"):removeSelf()
	end

	uiEasy.setPrivilegeRichText(game.PRIVILEGE_TYPE.UnionContribCoinRate, arg_2_0.imgBg, gLanguageCsv.unionCoin, cc.p(40, 70), false, "#C0x57472e#")
	Dialog.onCreate(arg_2_0)
end

function var_0_0.initModel(arg_5_0)
	local var_5_0 = gGameModel.union

	arg_5_0.vip = gGameModel.role:getIdler("vip_level")
	arg_5_0.unionLv = var_5_0:getIdler("level")
	arg_5_0.unionDayExp = var_5_0:getIdler("day_contrib")
	arg_5_0.unionExp = var_5_0:getIdler("contrib")
	arg_5_0.contribCount = gGameModel.daily_record:getIdler("union_contrib_times")
	arg_5_0.gold = gGameModel.role:getIdler("gold")
	arg_5_0.rmb = gGameModel.role:getIdler("rmb")
end

function var_0_0.onItemClick(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if arg_6_0.vip:read() < arg_6_3.cfg.vipNeed then
		return
	end

	if not arg_6_3.canContrubute then
		gGameUI:showTip(gLanguageCsv.contrubuteCountNotEnough)

		return
	end

	local var_6_0, var_6_1 = csvNext(arg_6_3.cfg.cost)
	local var_6_2 = dataEasy.getNumByKey(var_6_0)

	if not arg_6_3.isEnough then
		uiEasy.showDialog(var_6_0)

		return
	end

	local function var_6_3()
		gGameApp:requestServer("/game/union/contrib", function()
			local var_8_0, var_8_1 = csvNext(arg_6_3.cfg.award)
			local var_8_2 = var_8_1 * (1 + dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.UnionContribCoinRate))

			gGameUI:showTip(string.format(gLanguageCsv.contrubuteSucc, var_8_2))
		end, arg_6_3.csvId)
	end

	if var_6_0 == "rmb" then
		dataEasy.sureUsingDiamonds(var_6_3, var_6_1)
	else
		var_6_3()
	end
end

return var_0_0
