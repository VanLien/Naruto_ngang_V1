local function var_0_0(arg_1_0, arg_1_1)
	local var_1_0 = csv.fragments[arg_1_1.fragId]

	arg_1_0.fragName:text(var_1_0.name)
	text.addEffect(arg_1_0.fragName, {
		color = ui.COLORS.QUALITY[var_1_0.quality]
	})
end

local var_0_1 = class("UnionFragDonateView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "union_frag_donate.json"
var_0_1.RESOURCE_BINDING = {
	bar = "bar",
	item = "item",
	empty = "empty",
	boxPercent = "boxPercent",
	effectPanel = "effectPanel",
	donateTimes = "donateTimes",
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("fragDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("logo", "vipIcon", "textName", "level", "fragIcon", "fragName", "haveNum", "bar", "textPercent", "btnDonate", "iconTxt", "textMe")

					bind.extend(arg_2_0, var_2_0.logo, {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_2_3.memberData.logo,
							frameId = arg_2_3.memberData.frame,
							onNode = function(arg_3_0)
								arg_3_0:scale(0.9)
							end
						}
					})
					var_2_0.vipIcon:texture(ui.VIP_ICON[arg_2_3.memberData.vip]):visible(arg_2_3.memberData.vip > 0)
					var_2_0.textName:text(arg_2_3.memberData.name)
					adapt.oneLinePos(var_2_0.textName, var_2_0.vipIcon, cc.p(5, 0))
					var_2_0.level:text(arg_2_3.memberData.level)
					var_0_0(var_2_0, arg_2_3)
					bind.extend(arg_2_0, var_2_0.fragIcon, {
						event = "extend",
						class = "icon_key",
						props = {
							data = {
								key = arg_2_3.fragId
							},
							onNode = function(arg_4_0)
								arg_4_0:scale(1)
							end
						}
					})
					var_2_0.haveNum:text(arg_2_3.haveNum)
					var_2_0.bar:percent(cc.clampf(arg_2_3.current / arg_2_3.totalmax * 100, 0, 100))
					var_2_0.textPercent:text(arg_2_3.current .. "/" .. arg_2_3.totalmax)
					var_2_0.btnDonate:visible(arg_2_3.isMe == 2 and arg_2_3.canDotane)
					var_2_0.iconTxt:visible(arg_2_3.isMe == 2 and not arg_2_3.canDotane)
					var_2_0.textMe:visible(arg_2_3.isMe == 1)
					uiEasy.setBtnShader(var_2_0.btnDonate, var_2_0.btnDonate:get("title"), arg_2_3.haveNum > 0 and 1 or 2)

					if arg_2_3.haveNum > 0 then
						text.addEffect(var_2_0.btnDonate:get("title"), {
							outline = {
								size = 1,
								color = ui.NEWCOLORS.OUTLINE.YELLOW1
							}
						})
					else
						text.deleteAllEffect(var_2_0.btnDonate:get("title"))
					end

					bind.touch(arg_2_0, var_2_0.btnDonate, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	},
	btnWish = {
		varname = "btnWish",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnWish")
			}
		}
	},
	["btnWish.title"] = {
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
	btnRecord = {
		varname = "btnRecord",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnRecord")
			}
		}
	},
	["btnRecord.title"] = {
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
	boxIcon = {
		varname = "boxIcon",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAwardBtn")
			}
		}
	},
	btnRule = {
		varname = "btnRule",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnRule")
			}
		}
	},
	["btnRule.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	}
}
var_0_1.RESOURCE_STYLES = {
	full = true
}

function var_0_1.onCreate(arg_5_0)
	arg_5_0:initModel()
	gGameUI.topuiManager:createView("union", arg_5_0, {
		onClose = arg_5_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = "common/txt/txt_bt_zuzhi.png"
	})

	arg_5_0.fragDatas = idlers.new({})

	idlereasy.any({
		arg_5_0.fragDonate,
		arg_5_0.members
	}, function(arg_6_0, arg_6_1, arg_6_2)
		local var_6_0 = {}

		for iter_6_0, iter_6_1 in pairs(arg_6_1) do
			if arg_6_2[iter_6_0] and iter_6_1.frag_id then
				local var_6_1 = itertools.count(iter_6_1.history, arg_5_0.id:read())

				table.insert(var_6_0, {
					roleId = iter_6_0,
					memberData = arg_6_2[iter_6_0],
					haveNum = arg_5_0.frags:read()[iter_6_1.frag_id] or 0,
					fragId = iter_6_1.frag_id,
					current = iter_6_1.current,
					totalmax = iter_6_1.totalmax,
					history = iter_6_1.history,
					isMe = iter_6_0 == arg_5_0.id:read() and 1 or 2,
					canDotane = var_6_1 < gCommonConfigCsv.unionFragDonateSingleMaxTimes
				})
			end
		end

		arg_5_0.empty:visible(itertools.size(var_6_0) == 0)
		table.sort(var_6_0, function(arg_7_0, arg_7_1)
			return arg_7_0.isMe < arg_7_1.isMe
		end)
		dataEasy.tryCallFunc(arg_5_0.list, "updatePreloadCenterIndex")
		arg_5_0.fragDatas:update(var_6_0)
	end)
	widget.addAnimation(arg_5_0.effectPanel, "effect/jiedianjiangli.skel", "effect_loop", 1, 0):scale(0.5):xy(100, 80)
	idlereasy.any({
		arg_5_0.unionFragDonatePoint,
		arg_5_0.unionFragDonateAwards
	}, function(arg_8_0, arg_8_1, arg_8_2)
		local var_8_0 = csv.union.union_frag_donate_award
		local var_8_1

		arg_5_0.awardCsvId = 0
		arg_5_0.isLastBox = false

		arg_5_0.effectPanel:hide()

		for iter_8_0 = 1, csvSize(var_8_0) do
			local var_8_2 = var_8_0[iter_8_0]

			arg_5_0.award = var_8_2.award

			if not arg_8_2[iter_8_0] then
				var_8_1 = var_8_2.point

				break
			end

			var_8_1 = var_8_2.point

			if arg_8_2[iter_8_0] == 1 then
				arg_5_0.effectPanel:show()

				arg_5_0.awardCsvId = iter_8_0

				break
			end

			arg_5_0.isLastBox = iter_8_0 == csvSize(var_8_0)
		end

		arg_5_0.targetNum = var_8_1

		arg_5_0.boxPercent:text(arg_8_1 .. "/" .. var_8_1)
		arg_5_0.bar:percent(cc.clampf(arg_8_1 / var_8_1 * 100, 0, 100))
	end)
	idlereasy.when(arg_5_0.unionFragDonateTimes, function(arg_9_0, arg_9_1)
		local var_9_0 = math.max(gCommonConfigCsv.unionFragDonateTimes - arg_9_1, 0)

		arg_5_0.donateTimes:text(var_9_0 .. "/" .. gCommonConfigCsv.unionFragDonateTimes)
	end)
end

function var_0_1.initModel(arg_10_0)
	arg_10_0.frags = gGameModel.role:getIdler("frags")
	arg_10_0.id = gGameModel.role:getIdler("id")
	arg_10_0.unionFragDonatePoint = gGameModel.role:getIdler("union_frag_donate_point")
	arg_10_0.unionFragDonateAwards = gGameModel.role:getIdler("union_frag_donate_awards")

	local var_10_0 = gGameModel.union

	arg_10_0.unionId = var_10_0:getIdler("id")
	arg_10_0.unionLv = var_10_0:getIdler("level")
	arg_10_0.members = var_10_0:getIdler("members")
	arg_10_0.fragDonate = var_10_0:getIdler("frag_donate")

	local var_10_1 = gGameModel.daily_record

	arg_10_0.unionFragDonateTimes = var_10_1:getIdler("union_frag_donate_times")
	arg_10_0.unionFragDonateStartTimes = var_10_1:getIdler("union_frag_donate_start_times")
	arg_10_0.unionFragDonateHistorys = gGameModel.role:getIdler("union_frag_donate_historys")
end

function var_0_1.onBtnWish(arg_11_0)
	if arg_11_0.unionFragDonateStartTimes:read() >= 1 then
		gGameUI:showTip(gLanguageCsv.pleaseComeBackTomorrow)

		return
	end

	gGameUI:stackUI("city.union.frag_donate.wish")
end

function var_0_1.onBtnRecord(arg_12_0)
	if itertools.size(arg_12_0.unionFragDonateHistorys:read()) <= 0 then
		gGameUI:showTip(gLanguageCsv.notRecod)

		return
	end

	gGameUI:stackUI("city.union.frag_donate.record")
end

function var_0_1.onItemClick(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if arg_13_0.unionFragDonateTimes:read() >= gCommonConfigCsv.unionFragDonateTimes then
		gGameUI:showTip(gLanguageCsv.fragDonateTimesNotEnough)

		return
	end

	if arg_13_3.haveNum <= 0 then
		gGameUI:showTip(gLanguageCsv.fragDonateFragNotEnough)

		return
	end

	local var_13_0 = csv.fragments[arg_13_3.fragId]
	local var_13_1 = csv.union.union_frag_donate[var_13_0.quality]
	local var_13_2 = string.format(gLanguageCsv.getEnthusiastsRanAndPoints, var_13_1.point)

	for iter_13_0, iter_13_1 in csvMapPairs(var_13_1.award) do
		var_13_2 = string.format("%s%s#I%s-54-54#", var_13_2, iter_13_1, dataEasy.getIconResByKey(iter_13_0))
	end

	local function var_13_3()
		gGameApp:requestServer("/game/union/frag/donate", function(arg_15_0)
			gGameUI:showTip(var_13_2)
		end, arg_13_3.roleId, arg_13_3.fragId)
	end

	local var_13_4 = dataEasy.getCfgByKey(arg_13_3.fragId)

	if var_13_4 and var_13_4.quality >= 5 then
		gGameUI:showDialog({
			isRich = true,
			btnType = 2,
			strs = {
				string.format(gLanguageCsv.presenterCard, var_13_4.name)
			},
			cb = var_13_3
		})
	else
		var_13_3()
	end
end

function var_0_1.onAwardBtn(arg_16_0)
	if arg_16_0.awardCsvId ~= 0 then
		gGameApp:requestServer("/game/union/frag/donate/award", function(arg_17_0)
			gGameUI:showGainDisplay(arg_17_0)
		end, arg_16_0.awardCsvId)
	else
		gGameUI:showBoxDetail({
			data = arg_16_0.award,
			content = arg_16_0.isLastBox and "" or string.format(gLanguageCsv.enthusiastsRanGetPoints, arg_16_0.targetNum),
			state = arg_16_0.isLastBox and 2 or 1
		})
	end
end

function var_0_1.onBtnRule(arg_18_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_18_0:createHandler("getRuleContext"), {
		width = 1500
	})
end

function var_0_1.getRuleContext(arg_19_0, arg_19_1)
	local var_19_0 = adaptContext

	return {
		var_19_0.clone(arg_19_1.title, function(arg_20_0)
			return
		end),
		var_19_0.noteText(112),
		var_19_0.noteText(45001, 45010)
	}
end

return var_0_1
