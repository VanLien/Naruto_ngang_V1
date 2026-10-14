local var_0_0 = 30
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("BuyFestivalInfoView", Dialog)

var_0_2.RESOURCE_FILENAME = "common_send_text.json"
var_0_2.RESOURCE_BINDING = {
	title = "title",
	num2 = "num2",
	num3 = "num3",
	["buyBtn.text"] = "text",
	input = "input",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	buyBtn = {
		varname = "buyBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBuyItem")
			}
		}
	}
}

function var_0_2.initModel(arg_1_0)
	arg_1_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_1_0.sendredPacket = gGameModel.daily_record:getIdler("huodong_redPacket_send")

	if arg_1_0.activity.type == game.YYHUODONG_TYPE_ENUM_TABLE.huodongCrossRedPacket then
		arg_1_0.sendredPacket = gGameModel.daily_record:getIdler("huodong_cross_redPacket_send")
	end
end

function var_0_2.onCreate(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.cb = arg_2_2

	local var_2_0 = csv.yunying.yyhuodong[arg_2_1]

	arg_2_0.activity = var_2_0

	arg_2_0:initModel()

	if not var_2_0 then
		return false
	end

	arg_2_0.num2:text("x" .. var_2_0.paramMap.totalCount)
	arg_2_0.num3:text(var_2_0.paramMap.totalVal)
	blacklist:addListener(arg_2_0.input, "*", functools.partial(arg_2_0.nameAdapt, arg_2_0))
	arg_2_0.text:text(gLanguageCsv.commonTextOk)
	Dialog.onCreate(arg_2_0)
end

function var_0_2.nameAdapt(arg_3_0, arg_3_1)
	arg_3_1 = arg_3_1 or arg_3_0.input:text()

	arg_3_0.input:text(string.utf8limit(arg_3_1, var_0_0, true))
end

function var_0_2.onBuyItem(arg_4_0)
	arg_4_0:nameAdapt()

	local var_4_0 = gVipCsv[arg_4_0.vipLevel:read()].huodongRedPacketSend

	if arg_4_0.sendredPacket:read() == var_4_0 then
		gGameUI:showTip(gLanguageCsv.redPacketSendLimit)

		return false
	end

	local var_4_1

	if string.len(arg_4_0.input:text()) >= 1 and arg_4_0.input:text() ~= gLanguageCsv.festival then
		var_4_1 = arg_4_0.input:text()
	else
		var_4_1 = gLanguageCsv.festival
	end

	local var_4_2 = "/game/yy/red/packet/send"

	if arg_4_0.activity.type == game.YYHUODONG_TYPE_ENUM_TABLE.huodongCrossRedPacket then
		var_4_2 = "/game/yy/cross/red/packet/send"
	end

	gGameApp:requestServer(var_4_2, function(arg_5_0)
		arg_4_0:addCallbackOnExit(arg_4_0.cb)
		var_0_1.onClose(arg_4_0)
	end, var_4_1)
end

return var_0_2
