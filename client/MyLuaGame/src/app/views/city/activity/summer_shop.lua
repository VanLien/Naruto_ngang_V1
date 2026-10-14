local var_0_0 = require("app.views.city.activity.coupon_shop")
local var_0_1 = class("SummerShopView", var_0_0)

var_0_1.RESOURCE_FILENAME = "summer_shop.json"
var_0_1.RESOURCE_BINDING = var_0_0.RESOURCE_BINDING

function var_0_1.initData(arg_1_0)
	arg_1_0.itemID = 6394
end

function var_0_1.initTitle(arg_2_0)
	gGameUI.topuiManager:createView("title", arg_2_0, {
		onClose = arg_2_0:createHandler("onClose")
	}):init({
		subTitle = "QUALIFIED SHOP",
		title = gLanguageCsv.summerShop
	})
end

return var_0_1
