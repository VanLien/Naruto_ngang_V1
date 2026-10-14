local var_0_0 = class("VipDistinguishedView", Dialog)

var_0_0.RESOURCE_FILENAME = "vip_distinguished.json"
var_0_0.RESOURCE_BINDING = {
	text1 = "text1",
	text2 = "text2",
	list = "list",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnSell = {
		varname = "btnSell",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("btnSellClick")
			}
		}
	},
	["btnSell.textNote"] = {
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
	["title.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE1
				}
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0, arg_1_1)
	arg_1_0.roleVip = gGameModel.monthly_record:read("vip")

	local var_1_0 = gGameModel.monthly_record:read("vip_gift")

	arg_1_0.cb = arg_1_1
	arg_1_0.isHas = true

	local var_1_1, var_1_2 = csvNext(var_1_0)

	if var_1_2 and var_1_2 == 0 then
		uiEasy.setBtnShader(arg_1_0.btnSell, false, 2)
		arg_1_0.btnSell:get("textNote"):text(gLanguageCsv.received)
	end

	arg_1_0.text1:text(gLanguageCsv.giftsHint1)
	arg_1_0.text2:text(gLanguageCsv.giftsHint2)

	if matchLanguage({
		"en"
	}) then
		adapt.setTextAdaptWithSize(arg_1_0.text1, {
			margin = -5,
			vertical = "center",
			horizontal = "center",
			maxLine = 2,
			size = cc.size(960, 200)
		})
		arg_1_0.text2:setPositionY(885)
	end

	uiEasy.createItemsToList(arg_1_0, arg_1_0.list, gVipCsv[arg_1_0.roleVip].monthGift, {
		margin = 40,
		onAfterBuild = function(arg_2_0)
			arg_2_0:setItemAlignCenter()
		end
	})
	Dialog.onCreate(arg_1_0)
end

function var_0_0.btnSellClick(arg_3_0)
	gGameApp:requestServer("/game/role/vip/month/gift", function(arg_4_0)
		arg_3_0.isHas = false

		gGameUI:showGainDisplay(arg_4_0.view, {
			raw = false,
			cb = function()
				uiEasy.setBtnShader(arg_3_0.btnSell, false, 2)
				arg_3_0.btnSell:get("textNote"):text(gLanguageCsv.received)
			end
		})
	end)
end

function var_0_0.onClose(arg_6_0)
	if arg_6_0.cb then
		arg_6_0.cb(arg_6_0.isHas)
	end

	Dialog.onClose(arg_6_0)
end

return var_0_0
