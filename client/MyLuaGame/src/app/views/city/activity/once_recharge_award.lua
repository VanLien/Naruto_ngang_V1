local var_0_0 = {
	count = 1
}
local var_0_1 = 7
local var_0_2 = {
	get = 1,
	got = 0,
	none = 2
}
local var_0_3 = class("OnceRechargeAwardView", Dialog)

var_0_3.RESOURCE_FILENAME = "activity_once_recharge_award.json"
var_0_3.RESOURCE_BINDING = {
	time = "countTime",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnRules = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRules")
			}
		}
	},
	["btnRules.txtNode"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.YELLOW,
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	tips = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.YELLOW,
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	}
}

function var_0_3.onCreate(arg_1_0, arg_1_1)
	arg_1_0.yyCfg = csv.yunying.yyhuodong[arg_1_1]
	arg_1_0.activityId = arg_1_1

	arg_1_0:enableSchedule()
	arg_1_0:initModel()
	arg_1_0:initRecharge()
	arg_1_0:initCountTime()
	arg_1_0:initSkel()
	Dialog.onCreate(arg_1_0, {
		blackType = 1
	})
end

function var_0_3.initModel(arg_2_0)
	arg_2_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_2_0.yyEndtime = gGameModel.role:getIdler("yy_endtime")
end

function var_0_3.initRecharge(arg_3_0)
	local var_3_0 = csv.yunying.oncerechage

	idlereasy.when(arg_3_0.yyhuodongs, function(arg_4_0, arg_4_1)
		local var_4_0 = (arg_4_1[arg_3_0.activityId] or {}).stamps or {}
		local var_4_1 = {}

		for iter_4_0, iter_4_1 in orderCsvPairs(csv.yunying.oncerechage) do
			if arg_3_0.yyCfg.huodongID == iter_4_1.huodongID then
				local var_4_2 = {
					csvId = iter_4_0,
					cfg = iter_4_1,
					state = var_4_0[iter_4_0] and var_4_0[iter_4_0] or var_0_2.none
				}

				table.insert(var_4_1, var_4_2)
			end
		end

		for iter_4_2 = 1, var_0_1 do
			local var_4_3 = var_4_1[iter_4_2]
			local var_4_4 = arg_3_0:getResourceNode():get("rechargeItem" .. iter_4_2)

			var_4_4:visible(var_4_3 ~= nil)

			local var_4_5 = var_4_4:multiget("txtTitleNode", "rechargeNum", "iconDiamondTtitle", "icon", "txtDescNode", "awardNum", "btnRecharge", "txtGot")

			if var_4_3 then
				var_4_5.rechargeNum:text(var_4_3.cfg.needRmb)
				var_4_5.icon:texture(var_4_3.cfg.icon)

				local var_4_6, var_4_7 = csvNext(var_4_3.cfg.award)

				var_4_5.awardNum:text(var_4_7)
				text.addEffect(var_4_5.btnRecharge:get("txtNode"), {
					color = ui.COLORS.NORMAL.YELLOW,
					outline = {
						size = 1,
						color = ui.NEWCOLORS.OUTLINE.YELLOW1
					}
				})
				bind.touch(arg_3_0, var_4_5.btnRecharge, {
					methods = {
						ended = function()
							arg_3_0:onRechargeClick(var_4_3.state, var_4_3.csvId)
						end
					}
				})
				var_4_5.btnRecharge:get("txtNode"):text(var_4_3.state == var_0_2.none and gLanguageCsv.goRecharge .. "!" or gLanguageCsv.onlineGiftGet)
				var_4_5.btnRecharge:visible(var_4_3.state ~= var_0_2.got)
				var_4_5.txtGot:visible(var_4_3.state == var_0_2.got)
				adapt.oneLineCenterPos(cc.p(213, 490), {
					var_4_5.txtTitleNode,
					var_4_5.rechargeNum,
					var_4_5.iconDiamondTtitle
				}, cc.p(5, 0))
				var_4_4:removeChildByName("rechargeAndGotSkel")

				if var_4_3.state ~= var_0_2.got then
					local var_4_8 = widget.addAnimationByKey(var_4_4, "chongzhifanzuan/chongzhifanzuan.skel", "rechargeAndGotSkel", "effect_kechongzhi_loop", 99)

					var_4_8:anchorPoint(cc.p(0.5, 0.5)):xy(var_4_5.btnRecharge:x(), var_4_5.btnRecharge:y()):scale(2)

					if var_4_3.state == var_0_2.get then
						var_4_8:play("effect_kelingqu_loop")
					end
				end
			end
		end
	end)
end

function var_0_3.onRechargeClick(arg_6_0, arg_6_1, arg_6_2)
	if arg_6_1 == var_0_2.none then
		jumpEasy.jumpTo("recharge")
	elseif arg_6_1 == var_0_2.get then
		gGameApp:requestServer("/game/yy/award/get", function(arg_7_0)
			gGameUI:showGainDisplay(arg_7_0)
		end, arg_6_0.activityId, arg_6_2)
	else
		printWarn("error state")
	end
end

function var_0_3.initCountTime(arg_8_0)
	local var_8_0 = arg_8_0.activityId
	local var_8_1 = var_0_0.count
	local var_8_2 = arg_8_0.yyEndtime:read()

	arg_8_0:unSchedule(var_8_1)

	local var_8_3 = 0

	if var_8_2[var_8_0] then
		var_8_3 = var_8_2[var_8_0] - time.getTime()
	end

	arg_8_0:schedule(function()
		var_8_3 = var_8_3 - 1

		arg_8_0.countTime:text(time.getCutDown(var_8_3, true).str)

		if var_8_3 <= 0 then
			arg_8_0:onClose()

			return false
		end
	end, 1, 0, var_8_1)
end

function var_0_3.initSkel(arg_10_0)
	local var_10_0 = arg_10_0:getResourceNode()

	widget.addAnimationByKey(var_10_0, "chongzhifanzuan/chongzhifanzuan.skel", "bgSkel", "effect_shanguang_loop", 99):anchorPoint(cc.p(0.5, 0.5)):xy(var_10_0:width() / 2, var_10_0:height() / 2):scale(2)
end

function var_0_3.onRules(arg_11_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_11_0:createHandler("getRuleContext"), {
		width = 750
	})
end

function var_0_3.getRuleContext(arg_12_0, arg_12_1)
	local var_12_0 = adaptContext

	return {
		var_12_0.clone(arg_12_1.title, function(arg_13_0)
			arg_13_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_12_0.noteText(71001, 71004)
	}
end

return var_0_3
