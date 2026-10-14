local var_0_0 = {
	CAN_NOT_GOTTEN = 2,
	CAN_GOTTEN = 1,
	CAN_GO = 3,
	GOTTEN = 0
}
local var_0_1 = 0
local var_0_2 = require("app.views.city.activity.view")
local var_0_3 = class("ActivityThreeDayWelfareDialog", Dialog)

var_0_3.RESOURCE_FILENAME = "activity_srfl.json"
var_0_3.RESOURCE_BINDING = {
	Item = "item",
	jindu_3 = "jindu3",
	jindu_2 = "jindu2",
	timeLabel_num = "time",
	timeLabel = "timeLabel",
	close = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	label = {
		varname = "label",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	btn_go = {
		varname = "btnGo",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onGo")
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 3,
				data = bindHelper.self("itemsData"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_0.initItem(arg_1_1, arg_1_2, arg_1_3)
				end
			},
			handlers = {
				initItem = bindHelper.self("initItem")
			}
		}
	}
}

function var_0_3.onCreate(arg_2_0, arg_2_1)
	Dialog.onCreate(arg_2_0, {
		blackType = 1
	})

	arg_2_0.activityId = arg_2_1

	arg_2_0:initModel()
	arg_2_0:initUI()
end

function var_0_3.initModel(arg_3_0)
	arg_3_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_3_0.daySum = idler.new(0)
	arg_3_0.itemsData = idlertable.new({})
end

function var_0_3.initUI(arg_4_0)
	local var_4_0 = csv.yunying.yyhuodong[arg_4_0.activityId].huodongID

	arg_4_0.huodongID = var_4_0

	idlereasy.when(arg_4_0.yyhuodongs, function(arg_5_0, arg_5_1)
		local var_5_0 = arg_5_1[arg_4_0.activityId]
		local var_5_1 = var_5_0.stamps or {}
		local var_5_2 = var_5_0.info and var_5_0.info.all or var_0_0.CAN_GOTTEN
		local var_5_3 = gGameModel.role:getYYHuoDongTasksProgress(arg_4_0.activityId) or {}
		local var_5_4 = {}

		var_0_1 = 0

		local var_5_5 = 0

		for iter_5_0, iter_5_1 in orderCsvPairs(csv.yunying.serveropen) do
			if iter_5_1.huodongID == var_4_0 then
				var_5_5 = var_5_5 + 1

				local var_5_6 = var_0_0.CAN_GO

				if not var_5_1[iter_5_0] then
					var_5_6 = var_0_0.CAN_NOT_GOTTEN
				elseif var_5_1[iter_5_0] == 1 then
					var_5_6 = var_0_0.CAN_GOTTEN
				elseif var_5_1[iter_5_0] == 0 then
					var_5_6 = var_0_0.GOTTEN
					var_0_1 = var_0_1 + 1
				end

				var_5_4[iter_5_1.daySum] = {
					award = iter_5_1.award,
					desc = iter_5_1.desc,
					day = iter_5_1.daySum,
					getType = var_5_6,
					task = iter_5_1.taskType,
					progress = var_5_3[iter_5_1.id],
					csvID = iter_5_0
				}
			end
		end

		arg_4_0:updateBtnGo(var_5_2, var_5_5)
		arg_4_0.itemsData:set(var_5_4)
	end)
	var_0_2.setCountdown(arg_4_0, arg_4_0.activityId, arg_4_0.timeLabel, arg_4_0.time, {
		tag = 2,
		labelChangeCb = function()
			adapt.oneLinePos(arg_4_0.timeLabel, arg_4_0.time, cc.p(15, 0))
		end
	})
	arg_4_0:initLeftSprite()
end

function var_0_3.initLeftSprite(arg_7_0)
	return
end

function var_0_3.updateBtnGo(arg_8_0, arg_8_1, arg_8_2)
	if arg_8_1 == var_0_0.CAN_GOTTEN then
		arg_8_0.btnGo:setEnabled(true)
		arg_8_0.label:text(gLanguageCsv.spaceReceive)
		cache.setShader(arg_8_0.btnGo, false, "normal")
	elseif arg_8_1 == var_0_0.CAN_GO or arg_8_1 == var_0_0.CAN_NOT_GOTTEN then
		arg_8_0.label:text(gLanguageCsv.notReach)
		arg_8_0.btnGo:setEnabled(false)
		cache.setShader(arg_8_0.btnGo, false, "hsl_gray")
	elseif arg_8_1 == var_0_0.GOTTEN then
		arg_8_0.label:text(gLanguageCsv.received)
		arg_8_0.btnGo:setEnabled(false)
		cache.setShader(arg_8_0.btnGo, false, "hsl_gray")
	else
		arg_8_0.btnGo:setEnabled(true)
		arg_8_0.label:text(gLanguageCsv.goNow)
		cache.setShader(arg_8_0.btnGo, false, "normal")
	end

	arg_8_0.jindu2:text(var_0_1)
	arg_8_0.jindu3:text("/" .. arg_8_2)
end

function var_0_3.initItem(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = arg_9_2:multiget("day", "name", "box", "btn", "label")

	var_9_0.day:text(string.format(gLanguageCsv.recordPassportDay, arg_9_4.day)):z(50)
	var_9_0.name:text(arg_9_4.desc)
	var_9_0.label:z(1000)

	local var_9_1 = arg_9_4.award

	for iter_9_0, iter_9_1 in pairs(var_9_1) do
		local var_9_2 = var_9_0.box:size()

		bind.extend(arg_9_0, var_9_0.box, {
			class = "icon_key",
			props = {
				data = {
					key = iter_9_0,
					num = iter_9_1
				},
				onNode = function(arg_10_0)
					arg_10_0:xy(var_9_2.width / 2, var_9_2.height / 2)
					arg_10_0:scale(0.7)
				end
			}
		})

		break
	end

	if arg_9_4.getType == var_0_0.CAN_GOTTEN then
		var_9_0.btn:setEnabled(true)
		var_9_0.label:text(gLanguageCsv.spaceReceive)
		cache.setShader(var_9_0.btn, false, "normal")
	elseif arg_9_4.getType == var_0_0.CAN_GO or arg_9_4.getType == var_0_0.CAN_NOT_GOTTEN then
		if arg_9_4.task == game.TARGET_TYPE.LoginDays then
			var_9_0.label:text(gLanguageCsv.notReach)
			var_9_0.btn:setEnabled(false)
			cache.setShader(var_9_0.btn, false, "hsl_gray")
		else
			var_9_0.btn:setEnabled(true)
			var_9_0.label:text(gLanguageCsv.goNow)
			cache.setShader(var_9_0.btn, false, "normal")
		end
	elseif arg_9_4.getType == var_0_0.GOTTEN then
		var_9_0.label:text(gLanguageCsv.received)
		var_9_0.btn:setEnabled(false)
		cache.setShader(var_9_0.btn, false, "hsl_gray")
	else
		var_9_0.btn:setEnabled(true)
		var_9_0.label:text(gLanguageCsv.goNow)
		cache.setShader(var_9_0.btn, false, "normal")
	end

	bind.touch(arg_9_0, var_9_0.btn, {
		methods = {
			ended = functools.partial(arg_9_0.sendGetAward, arg_9_0, arg_9_4)
		}
	})
end

function var_0_3.sendGetAward(arg_11_0, arg_11_1)
	if arg_11_1.getType == var_0_0.CAN_GO or arg_11_1.getType == var_0_0.CAN_NOT_GOTTEN then
		if arg_11_1.task == game.TARGET_TYPE.Gate then
			gGameUI:stackUI("city.gate.view")
		elseif arg_11_1.task == game.TARGET_TYPE.LoginDays then
			-- block empty
		end
	elseif arg_11_1.getType == var_0_0.CAN_GOTTEN then
		gGameApp:requestServer("/game/yy/award/get", function(arg_12_0)
			gGameUI:showGainDisplay(arg_12_0)
		end, arg_11_0.activityId, arg_11_1.csvID)
	end
end

function var_0_3.onGo(arg_13_0)
	if var_0_1 == 3 then
		gGameApp:requestServer("/game/yy/serveropen/all", function(arg_14_0)
			gGameUI:showGainDisplay(arg_14_0)
		end, arg_13_0.activityId)
	else
		gGameUI:showTip(gLanguageCsv.notReachedCannotGet)
	end
end

return var_0_3
