local var_0_0 = {
	gLanguageCsv.breakfast,
	gLanguageCsv.launch,
	gLanguageCsv.dinner,
	gLanguageCsv.supper
}
local var_0_1 = {
	ATE = 3,
	AGAIN_EAT = 4,
	NOT_EAT = 2,
	CAN_EAT = 1
}
local var_0_2 = class("ActivityRegainStaminaView", cc.load("mvc").ViewBase)

var_0_2.RESOURCE_FILENAME = "activity_regain_stamina.json"
var_0_2.RESOURCE_BINDING = {
	item = "item",
	title = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.RED
				}
			}
		}
	},
	["item.timeTxt"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			}
		}
	},
	["item.againPanel.cost"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			}
		}
	},
	list = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("datas"),
				item = bindHelper.self("item"),
				dataOrderCmp = function(arg_1_0, arg_1_1)
					return arg_1_0.cfg.beginTime < arg_1_1.cfg.beginTime
				end,
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_3.cfg
					local var_2_1 = arg_2_0:getIdx(arg_2_2)
					local var_2_2 = nodetools.multiget(arg_2_1, "contentBg", "timeTxt", "btnAte", "img", "againPanel")
					local var_2_3, var_2_4 = time.getHourAndMin(var_2_0.beginTime, true)
					local var_2_5 = var_2_3 + var_2_0.openDuration
					local var_2_6 = var_2_4

					var_2_2.timeTxt:text(string.format("%s%d:%02d-%d:%02d", var_0_0[var_2_1], var_2_3, var_2_4, var_2_5, var_2_6))
					var_2_2.img:texture("activity/regain_stamina/img_plate" .. var_2_1 .. "@.png")
					text.addEffect(var_2_2.btnAte:get("label"), {
						outline = {
							size = 4,
							color = ui.NEWCOLORS.OUTLINE.YELLOW
						}
					})
					nodetools.invoke(arg_2_1, {
						"btnAte",
						"againPanel",
						"ate",
						"imgSelect",
						"contentBg",
						"timeTxt"
					}, "hide")
					bind.touch(arg_2_0, var_2_2.btnAte, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, k, arg_2_3)
						}
					})

					local var_2_7 = var_2_2.contentBg:get("content")

					if var_2_7:get("emm") then
						var_2_7:removeAllChildren()
					end

					if arg_2_3.state == var_0_1.CAN_EAT then
						nodetools.invoke(arg_2_1, {
							"btnAte",
							"timeTxt",
							"imgSelect",
							"contentBg"
						}, "show")
						var_2_2.btnAte:get("label"):text(gLanguageCsv.spaceEat)

						if arg_2_3.privilege ~= 0 then
							var_2_7:text("")

							local var_2_8 = string.format(gLanguageCsv.privilegeCurrTimeEat, var_2_0.paramMap.stamina, arg_2_3.privilege)

							rich.createWithWidth(var_2_8, 40, nil, 400):addTo(var_2_7, 10, "emm"):align(cc.p(0, 1), 0, 115)
						else
							var_2_7:text(string.format(gLanguageCsv.currTimeEat, var_2_0.paramMap.stamina))
						end
					elseif arg_2_3.state == var_0_1.NOT_EAT then
						nodetools.invoke(arg_2_1, {
							"timeTxt",
							"contentBg"
						}, "show")
						var_2_7:text(gLanguageCsv.notCurrTimeEat)
					elseif arg_2_3.state == var_0_1.ATE then
						nodetools.invoke(arg_2_1, {
							"ate"
						}, "show")
						var_2_2.img:texture("activity/regain_stamina/img_empty.png")
					else
						nodetools.invoke(arg_2_1, {
							"btnAte",
							"againPanel",
							"contentBg"
						}, "show")
						var_2_2.btnAte:get("label"):text(gLanguageCsv.spaceAgainEat)
						var_2_2.againPanel:get("cost"):text(arg_2_3.costRmb)
						adapt.oneLineCenterPos(cc.p(100, 25), {
							var_2_2.againPanel:get("cost"),
							var_2_2.againPanel:get("img")
						}, cc.p(15, 0))

						if arg_2_3.privilege ~= 0 then
							var_2_7:text("")

							local var_2_9 = string.format(gLanguageCsv.privilegePastTimeEat, var_2_0.paramMap.stamina, arg_2_3.privilege)

							rich.createWithWidth(var_2_9, 40, nil, 400):addTo(var_2_7, 10, "emm"):align(cc.p(0, 1), 0, 133)
						else
							var_2_7:text(string.format(gLanguageCsv.pastTimeEat, arg_2_3.cfg.paramMap.stamina))
						end
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onBtnClick")
			}
		}
	}
}

function var_0_2.onCreate(arg_3_0, arg_3_1)
	arg_3_0:initModel()

	arg_3_0.costRmb = csv.yunying.yyhuodong[arg_3_1].paramMap.rmb
	arg_3_0.activityId = arg_3_1

	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in orderCsvPairs(csv.yunying.yyhuodong) do
		if iter_3_1.type == game.YYHUODONG_TYPE_ENUM_TABLE.dinnerTime and matchLanguage(iter_3_1.languages) then
			local var_3_2 = var_0_1.CAN_EAT
			local var_3_3 = {
				id = iter_3_0,
				cfg = iter_3_1,
				costRmb = arg_3_0.costRmb
			}

			table.insert(var_3_0, var_3_3)
			table.insert(var_3_1, iter_3_0)
		end
	end

	arg_3_0.datas = idlers.newWithMap(var_3_0)

	idlereasy.any({
		arg_3_0.yyhuodongs,
		arg_3_0.yyOpen,
		arg_3_0.trainerSkills
	}, function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
		local var_4_0 = dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.StaminaGain)

		for iter_4_0 = 1, 4 do
			local var_4_1 = arg_4_1[var_3_1[iter_4_0]] or {}

			arg_3_0.datas:at(iter_4_0):modify(function(arg_5_0)
				arg_5_0.lastday = var_4_1.lastday
				arg_5_0.privilege = var_4_0[iter_4_0] or 0
				arg_5_0.state = arg_3_0:getState(arg_5_0)

				return true, arg_5_0
			end, true)
		end
	end)
	arg_3_0:enableSchedule():schedule(function()
		local var_6_0 = time.getNowDate().hour
		local var_6_1 = time.getNowDate().min
		local var_6_2 = time.getNowDate().sec

		for iter_6_0, iter_6_1 in ipairs(var_3_0) do
			local var_6_3, var_6_4 = time.getHourAndMin(iter_6_1.cfg.beginTime, true)
			local var_6_5, var_6_6 = time.getHourAndMin(iter_6_1.cfg.beginTime + iter_6_1.cfg.openDuration * 100, true)

			var_6_5 = var_6_5 == 24 and 0 or var_6_5

			if (var_6_0 == var_6_3 and var_6_4 == var_6_1 or var_6_0 == var_6_5 and var_6_6 == var_6_1) and var_6_2 == 5 then
				gGameApp:requestServer("/game/yy/active/get")
			end
		end
	end, 1, 0, "refresh")
end

function var_0_2.initModel(arg_7_0)
	arg_7_0.yyOpen = gGameModel.role:getIdler("yy_open")
	arg_7_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_7_0.createTime = gGameModel.role:read("created_time")
	arg_7_0.rmb = gGameModel.role:getIdler("rmb")
	arg_7_0.trainerSkills = gGameModel.role:getIdler("trainer_skills")
end

function var_0_2.getState(arg_8_0, arg_8_1)
	local var_8_0 = csv.yunying.yyhuodong[arg_8_0.activityId]
	local var_8_1, var_8_2 = time.getHourAndMin(var_8_0.beginTime, true)
	local var_8_3 = {
		hour = var_8_1,
		min = var_8_2
	}

	if arg_8_1.lastday and tostring(arg_8_1.lastday) == time.getTodayStrInClock(var_8_1, var_8_2) then
		return var_0_1.ATE
	end

	local var_8_4 = arg_8_1.cfg
	local var_8_5, var_8_6 = time.getHourAndMin(var_8_4.beginTime, true)
	local var_8_7 = time.getCmpKey({
		hour = var_8_5,
		min = var_8_6
	}, var_8_3)
	local var_8_8 = time.getCmpKey({
		hour = var_8_5 + var_8_4.openDuration,
		min = var_8_6
	}, var_8_3)
	local var_8_9 = time.getCmpKey(time.getNowDate(), var_8_3)

	if var_8_9 < var_8_7 then
		return var_0_1.NOT_EAT
	end

	if var_8_7 <= var_8_9 and var_8_9 < var_8_8 then
		return var_0_1.CAN_EAT
	end

	return var_0_1.AGAIN_EAT
end

function var_0_2.onBtnClick(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if arg_9_3.state == var_0_1.CAN_EAT then
		gGameApp:requestServer("/game/yy/award/get", function(arg_10_0)
			gGameUI:showGainDisplay(arg_10_0)
		end, arg_9_3.id)
	elseif arg_9_3.state == var_0_1.AGAIN_EAT then
		if arg_9_0.rmb:read() < arg_9_0.costRmb then
			uiEasy.showDialog("rmb")
		else
			gGameUI:showDialog({
				isRich = true,
				clearFast = true,
				btnType = 2,
				title = "",
				content = string.format(gLanguageCsv.staminaAaginGet, arg_9_3.costRmb),
				cb = function()
					gGameApp:requestServer("/game/yy/award/get", function(arg_12_0)
						gGameUI:showGainDisplay(arg_12_0)
					end, arg_9_3.id)
				end
			})
		end
	end
end

return var_0_2
