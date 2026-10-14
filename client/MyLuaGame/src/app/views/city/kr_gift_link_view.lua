local var_0_0 = class("GiftLinkView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "kr_gift_link_view.json"
var_0_0.RESOURCE_BINDING = {
	btn = {
		binds = {
			clicksafe = true,
			event = "touch",
			methods = {
				ended = bindHelper.self("oneOpenUrl")
			}
		}
	}
}
var_0_0.RESOURCE_STYLES = {
	full = true
}

function var_0_0.onCreate(arg_1_0)
	gGameUI.topuiManager:createView("default", arg_1_0, {
		onClose = arg_1_0:createHandler("onClose")
	}):init({
		title = ""
	})
end

function var_0_0.oneOpenUrl(arg_2_0)
	local var_2_0 = "https://play.google.com/store/apps/details?id=com.xp.kefu.google"

	cc.Application:getInstance():openURL(var_2_0)
end

return var_0_0
