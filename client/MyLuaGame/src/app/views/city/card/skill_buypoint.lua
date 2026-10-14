local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("CardSkillBuyPointView", Dialog)

var_0_1.RESOURCE_FILENAME = "card_skill_buypoint.json"
var_0_1.RESOURCE_BINDING = {
	rmbNum = "rmbNum",
	vip = "vip",
	note2 = "note2",
	bg = "bg",
	note1 = "note1",
	note5 = "note5",
	rmbIcon = "rmbIcon",
	note3 = "note3",
	pointNum = "pointNum",
	note6 = "note6",
	note4 = "note4",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	titleTxt = {
		binds = {
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
	cancelBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	sureBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSureBtnClick")
			}
		}
	},
	surplusNum = {
		varname = "surplusNum",
		binds = {
			event = "text",
			idler = bindHelper.self("surplusNumTxt")
		}
	}
}

function var_0_1.onCreate(arg_1_0, arg_1_1)
	arg_1_0.cb = arg_1_1

	arg_1_0:initModel()

	local var_1_0 = arg_1_0.vipLevel:read()
	local var_1_1 = gVipCsv[var_1_0]
	local var_1_2 = arg_1_0.buySkillPointTimes:read()

	arg_1_0.surplusNumTxt = idler.new(var_1_1.buySkillPointTimes - var_1_2)

	local var_1_3 = gCostCsv.skill_point_buy_cost

	arg_1_0.cost = var_1_3[cc.clampf(var_1_2 + 1, 1, table.length(var_1_3))]

	arg_1_0.rmbNum:text(arg_1_0.cost)
	arg_1_0.pointNum:text(20)

	if var_1_0 == 0 then
		arg_1_0.vip:hide()
		arg_1_0.note1:text(gLanguageCsv.youAreNotVIP)
		adapt.oneLineCenterPos(cc.p(arg_1_0.bg:x(), arg_1_0.note1:y()), {
			arg_1_0.note1,
			arg_1_0.note2,
			arg_1_0.surplusNum,
			arg_1_0.note3
		}, cc.p(15, 0))
	else
		arg_1_0.vip:texture("common/icon/vip/icon_vip" .. var_1_0 .. ".png"):show()
		adapt.oneLineCenterPos(cc.p(arg_1_0.bg:x(), arg_1_0.note1:y()), {
			arg_1_0.note1,
			arg_1_0.vip,
			arg_1_0.note2,
			arg_1_0.surplusNum,
			arg_1_0.note3
		}, cc.p(15, 0))
	end

	arg_1_0.note4:anchorPoint(0, 0.5)
	arg_1_0.note4:x(arg_1_0.note1:x() - arg_1_0.note1:width() * arg_1_0.note1:anchorPoint().x)
	adapt.oneLinePos(arg_1_0.note4, {
		arg_1_0.pointNum,
		arg_1_0.note5,
		arg_1_0.rmbNum,
		arg_1_0.rmbIcon
	}, cc.p(10, 0), "left")
	arg_1_0.note6:x(arg_1_0.bg:x())
	Dialog.onCreate(arg_1_0, {
		clickClose = false
	})
end

function var_0_1.initModel(arg_2_0)
	arg_2_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_2_0.buySkillPointTimes = gGameModel.daily_record:getIdler("buy_skill_point_times")
	arg_2_0.rmb = gGameModel.role:getIdler("rmb")
end

function var_0_1.onSureBtnClick(arg_3_0)
	if arg_3_0.surplusNumTxt:read() <= 0 then
		gGameUI:showTip(gLanguageCsv.insufficientPurchaseTimes)

		return
	end

	if arg_3_0.rmb:read() < arg_3_0.cost then
		gGameUI:showTip(gLanguageCsv.buyRMBNotEnough)

		return
	end

	arg_3_0:addCallbackOnExit(arg_3_0.cb)
	var_0_0.onClose(arg_3_0)
end

return var_0_1
