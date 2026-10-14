local var_0_0 = class("RechargeVipView", Dialog)

var_0_0.RESOURCE_FILENAME = "recharge_vip.json"
var_0_0.RESOURCE_BINDING = {
	name = "name",
	list = "list",
	animation = "animation",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnGo = {
		varname = "btnGo",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onGoClick")
			}
		}
	},
	icon = {
		varname = "icon",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onIconClick")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "onHonourableVip",
					onNode = function(arg_1_0)
						arg_1_0:xy(70, 65):scale(0.3)
					end
				}
			}
		}
	}
}

function var_0_0.onCreate(arg_2_0)
	Dialog.onCreate(arg_2_0, {
		clickClose = false
	})

	local var_2_0 = arg_2_0.btnGo:size()

	widget.addAnimationByKey(arg_2_0.btnGo, "effect/jiantou.skel", "efc1", "effect_loop", 6):xy(var_2_0.width / 2 - 60 + 20, var_2_0.height / 2)
	uiEasy.createItemsToList(arg_2_0, arg_2_0.list, csv.gift[100].award, {
		margin = 40
	})

	local var_2_1 = gGameModel.monthly_record:read("vip")

	if csvSize(gVipCsv[var_2_1].monthGift) >= 1 then
		arg_2_0:animationUpdata(true)
	else
		arg_2_0:boxState(false)
	end
end

function var_0_0.onGoClick(arg_3_0)
	cc.Application:getInstance():openURL("https://url.cn/5Ucln3U?_type=wpa&qidian=true")
end

function var_0_0.animationUpdata(arg_4_0, arg_4_1)
	if arg_4_1 then
		local var_4_0 = gGameModel.monthly_record:read("vip_gift")
		local var_4_1, var_4_2 = csvNext(var_4_0)

		if not var_4_2 or var_4_2 ~= 0 then
			widget.addAnimation(arg_4_0.animation, "effect/jiedianjiangli.skel", "effect_loop", 1):xy(100, 40):scale(0.7)
			arg_4_0:boxState(true)
		else
			arg_4_0:boxState(false)
		end
	else
		arg_4_0.animation:removeAllChildren()
		arg_4_0:boxState(false)
	end
end

function var_0_0.boxState(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_1 and "config/item/box/icon_fslh_2_5.png" or "city/recharge/icon_vip_gbbz.png"
	local var_5_1 = arg_5_1 and 3 or 1

	arg_5_0.name:visible(arg_5_1)
	arg_5_0.icon:setEnabled(arg_5_1)
	arg_5_0.icon:scale(var_5_1)
	arg_5_0.icon:texture(var_5_0)
end

function var_0_0.onIconClick(arg_6_0)
	gGameUI:stackUI("city.vip_distinguished", nil, nil, arg_6_0:createHandler("animationUpdata"))
end

return var_0_0
