local var_0_0 = {
	"city/union/contribute/logo_l.png",
	"city/union/contribute/logo_c.png"
}
local var_0_1 = {
	gLanguageCsv.everyday,
	gLanguageCsv.everyweek
}
local var_0_2 = {
	"city/union/contribute/logo_l1.png",
	"city/union/contribute/logo_z.png"
}
local var_0_3 = {
	gLanguageCsv.personal,
	gLanguageCsv.guild
}
local var_0_4 = {
	"city/union/contribute/img_dt_l.png",
	"city/union/contribute/img_dt_c.png"
}
local var_0_5 = class("UnionContribView", Dialog)

var_0_5.RESOURCE_FILENAME = "union_contribute_main.json"
var_0_5.RESOURCE_BINDING = {
	item = "item",
	maskPanel = "maskPanel",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["title.textNote1"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	["title.textNote2"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	["left.textUnionLvNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("unionLv")
		}
	},
	["left.textUnionExpNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("unionCurLvExp")
		}
	},
	["left.textCount"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("leftCount")
		}
	},
	["left.progress"] = {
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				maskImg = "common/icon/mask_bar_red.png",
				data = bindHelper.self("unionExpPro")
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
	["left.btnContrbute.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["left.btnRule"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onRuleClick")
				}
			},
			{
				event = "visible",
				idler = bindHelper.self("isMaxLv"),
				method = function(arg_1_0)
					return not arg_1_0
				end
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
	["top.bar"] = {
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				maskImg = "common/icon/mask_bar_red.png",
				data = bindHelper.self("weekExpPro")
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("contrubuteDatas"),
				item = bindHelper.self("item"),
				dataOrderCmpGen = bindHelper.self("onSortDatas", true),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = var_0_0[arg_2_3.cfg.type]
					local var_2_1 = var_0_1[arg_2_3.cfg.type]

					arg_2_1:get("imgFlagBg1"):texture(var_2_0)
					arg_2_1:get("textFlag1"):text(var_2_1)

					local var_2_2 = var_0_2[arg_2_3.cfg.userType]
					local var_2_3 = var_0_3[arg_2_3.cfg.userType]

					arg_2_1:get("imgFlagBg2"):texture(var_2_2)
					arg_2_1:get("textFlag2"):text(var_2_3)

					local var_2_4 = var_0_4[arg_2_3.cfg.type]

					arg_2_1:get("imgTypeBg"):texture(var_2_4)
					arg_2_1:get("textProgress"):text(string.format("%s/%s", arg_2_3.info[1], arg_2_3.cfg.targetDisplay))
					arg_2_1:get("textContent"):text(arg_2_3.cfg.desc)
					arg_2_1:get("imgFlagBg1"):width(arg_2_1:get("textFlag1"):width() + 20)
					arg_2_1:get("imgFlagBg2"):width(arg_2_1:get("textFlag2"):width() + 20)
					adapt.oneLinePos(arg_2_1:get("imgFlagBg1"), arg_2_1:get("imgFlagBg2"), cc.p(20, 0))
					arg_2_1:get("textFlag1"):x(arg_2_1:get("imgFlagBg1"):x())
					arg_2_1:get("textFlag2"):x(arg_2_1:get("imgFlagBg2"):x())

					local var_2_5 = ui.COLORS.NORMAL.ALERT_ORANGE

					if arg_2_3.info[1] >= tonumber(arg_2_3.cfg.targetDisplay) then
						var_2_5 = ui.COLORS.NORMAL.FRIEND_GREEN
					end

					text.addEffect(arg_2_1:get("textProgress"), {
						color = var_2_5
					})

					local var_2_6 = 112
					local var_2_7 = false
					local var_2_8 = gLanguageCsv.goTo

					if arg_2_3.state == 1 then
						var_2_8 = gLanguageCsv.commonTextGet
						var_2_6 = 180
						var_2_7 = true

						local var_2_9 = arg_2_1:size()
					elseif arg_2_3.state ~= 2 and arg_2_3.cfg.goToPanel then
						var_2_6 = 180
						var_2_7 = true
					end

					arg_2_1:get("textProgress"):y(var_2_6)
					arg_2_1:get("btnGet"):visible(var_2_7)
					arg_2_1:get("btnGet.textNote"):text(var_2_8)
					text.addEffect(arg_2_1:get("btnGet.textNote"), {
						outline = {
							size = 1,
							color = ui.NEWCOLORS.OUTLINE.WHITE
						}
					})
					arg_2_1:get("textProgress"):visible(arg_2_3.state ~= 2)
					arg_2_1:get("imgDown"):visible(arg_2_3.state == 2)

					local var_2_10 = {}

					for iter_2_0, iter_2_1 in csvMapPairs(arg_2_3.cfg.award) do
						var_2_10[iter_2_0] = iter_2_1
					end

					var_2_10.contrib = arg_2_3.cfg.contrib

					uiEasy.createItemsToList(arg_2_0, arg_2_1:get("listview"), var_2_10, {
						scale = 0.8
					})
					bind.touch(arg_2_0, arg_2_1:get("btnGet"), {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3, arg_2_1)
						}
					})
				end,
				onAfterBuild = function(arg_3_0)
					arg_3_0.afterBuild()
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick"),
				afterBuild = bindHelper.self("onAfterBuild")
			}
		}
	}
}

function var_0_5.onCreate(arg_4_0)
	arg_4_0.list:setName("contribList")
	arg_4_0:initModel()

	local var_4_0 = csv.union.union_level[arg_4_0.unionLv:read()]

	arg_4_0.unionExpPro = idler.new(0)
	arg_4_0.weekExpPro = idler.new(0)
	arg_4_0.unionCurLvExp = idler.new("")
	arg_4_0.leftCount = idler.new("")
	arg_4_0.allCount = idler.new(0)
	arg_4_0.tipNote = idler.new("")
	arg_4_0.textProgress = idler.new("")
	arg_4_0.contrubuteDatas = idlers.newWithMap({})

	idlereasy.any({
		arg_4_0.unionTasks,
		arg_4_0.tasks
	}, function(arg_5_0, arg_5_1, arg_5_2)
		local var_5_0 = {}

		for iter_5_0, iter_5_1 in orderCsvPairs(csv.union.union_task) do
			if matchLanguage(iter_5_1.languages) then
				local var_5_1 = {
					cfg = iter_5_1,
					csvId = iter_5_0
				}
				local var_5_2 = arg_5_1[iter_5_0]

				if var_5_1.cfg.userType == 2 then
					var_5_1.info = var_5_2 or arg_5_2[iter_5_0] or {
						0,
						0
					}

					if var_5_2 and var_5_2[2] == 2 then
						var_5_1.state = 2
					else
						var_5_1.state = arg_5_2[iter_5_0] and arg_5_2[iter_5_0][2] or 0
					end
				else
					var_5_1.info = var_5_2 or {
						0,
						0
					}
					var_5_1.state = var_5_2 and var_5_2[2] or 0
				end

				table.insert(var_5_0, var_5_1)
			end
		end

		dataEasy.tryCallFunc(arg_4_0.list, "updatePreloadCenterIndex")
		arg_4_0.contrubuteDatas:update(var_5_0)
	end)

	local var_4_1 = {
		arg_4_0.unionLv,
		arg_4_0.unionExp,
		arg_4_0.contribCount,
		arg_4_0.weekExp
	}

	idlereasy.any(var_4_1, function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		local var_6_0 = csv.union.union_level
		local var_6_1 = var_6_0[arg_6_1].levelUpContrib
		local var_6_2 = 0

		for iter_6_0 = 1, arg_6_1 - 1 do
			var_6_2 = var_6_2 + var_6_0[iter_6_0].levelUpContrib
		end

		local var_6_3 = arg_6_2 - var_6_2

		arg_4_0.unionCurLvExp:set(string.format("%d/%d", var_6_3, var_6_1))

		local var_6_4 = var_6_3 / var_6_1 * 100

		arg_4_0.unionExpPro:set(var_6_4)

		local var_6_5 = var_6_0[arg_6_1].ContribMax

		arg_4_0.leftCount:set(string.format("%d/%d", var_6_5 - arg_6_3, var_6_5))

		local var_6_6 = var_6_0[arg_6_1].taskExpMax

		arg_4_0.allCount:set(arg_6_4)
		arg_4_0.tipNote:set(string.format(gLanguageCsv.taskUnionExpMax, var_6_6))
		arg_4_0.textProgress:set(string.format("%d/%d", arg_6_4, var_6_6))

		local var_6_7 = arg_6_4 / var_6_6 * 100

		arg_4_0.weekExpPro:set(var_6_7)

		arg_4_0.isMaxLv = idler.new(arg_6_1 >= csvSize(var_6_0))
	end)
	Dialog.onCreate(arg_4_0)
end

function var_0_5.initModel(arg_7_0)
	arg_7_0.unionTasks = gGameModel.role:getIdler("union_contrib_tasks")

	local var_7_0 = gGameModel.union

	arg_7_0.unionLv = var_7_0:getIdler("level")
	arg_7_0.unionDayExp = var_7_0:getIdler("day_contrib")
	arg_7_0.unionExp = var_7_0:getIdler("contrib")
	arg_7_0.weekExp = var_7_0:getIdler("week_task_contrib")
	arg_7_0.tasks = var_7_0:getIdler("contrib_tasks")
	arg_7_0.contribCount = gGameModel.daily_record:getIdler("union_contrib_times")
end

function var_0_5.onItemClick(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	if arg_8_3.state == 0 and arg_8_3.cfg.goToPanel then
		jumpEasy.jumpTo(arg_8_3.goToPanel)
	end

	if arg_8_3.state == 1 then
		gGameApp:requestServer("/game/union/contrib/task", function(arg_9_0)
			gGameUI:showGainDisplay(arg_9_0)
		end, arg_8_3.csvId)
	end
end

function var_0_5.onContrbuteClick(arg_10_0)
	gGameUI:stackUI("city.union.contrib.contrib_info")
end

function var_0_5.onRuleClick(arg_11_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_11_0:createHandler("getRuleContext"), {
		width = 860
	})
end

function var_0_5.getRuleContext(arg_12_0, arg_12_1)
	local var_12_0 = gGameModel.union:read("level")
	local var_12_1 = adaptContext
	local var_12_2 = {
		var_12_1.clone(arg_12_1.title, function(arg_13_0)
			arg_13_0:get("text"):text(gLanguageCsv.levelIntro)
		end),
		string.format(gLanguageCsv.unionLvUpTip, var_12_0 + 1)
	}
	local var_12_3 = csv.union.union_level[var_12_0 + 1]

	for iter_12_0 = 1, math.huge do
		if not var_12_3["notice" .. iter_12_0] or var_12_3["notice" .. iter_12_0] == "" then
			break
		end

		table.insert(var_12_2, string.format("  %d.%s", iter_12_0, var_12_3["notice" .. iter_12_0]))
	end

	return var_12_2
end

function var_0_5.onSortDatas(arg_14_0, arg_14_1)
	return function(arg_15_0, arg_15_1)
		local var_15_0 = arg_15_0.info[2]
		local var_15_1 = arg_15_1.info[2]

		if var_15_0 == var_15_1 then
			return arg_15_0.cfg.sortID < arg_15_1.cfg.sortID
		end

		if var_15_0 == 2 then
			return false
		end

		if var_15_1 == 2 then
			return true
		end

		return var_15_1 < var_15_0
	end
end

function var_0_5.onAfterBuild(arg_16_0)
	uiEasy.setBottomMask(arg_16_0.list, arg_16_0.maskPanel)
end

return var_0_5
