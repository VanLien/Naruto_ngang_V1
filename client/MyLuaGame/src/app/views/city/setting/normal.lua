local var_0_0 = require("app.views.city.setting.view")
local var_0_1 = var_0_0.BTN_TYPE
local var_0_2 = var_0_0.BTN_DATA
local var_0_3 = {
	OPEN = 1,
	CLOSE = 2
}
local var_0_4 = {
	{
		name = gLanguageCsv.settingFPS,
		select1 = gLanguageCsv.settingFPSSelect1,
		select2 = gLanguageCsv.settingFPSSelect2,
		btnType = var_0_1.RADIO,
		initFunc = function()
			return userDefault.getForeverLocalKey("fps", 60, {
				rawKey = true
			}) <= 30 and var_0_3.OPEN or var_0_3.CLOSE
		end,
		func = function(arg_2_0)
			local var_2_0 = arg_2_0 and 30 or 60

			cc.Director:getInstance():setAnimationInterval(1 / var_2_0)
			userDefault.setForeverLocalKey("fps", var_2_0, {
				rawKey = true
			})
		end
	},
	{
		name = gLanguageCsv.settingScreen,
		select1 = gLanguageCsv.settingScreenSelect1,
		select2 = gLanguageCsv.settingScreenSelect2,
		btnType = var_0_1.RADIO,
		initFunc = function()
			return cc.UserDefault:getInstance():getBoolForKey("isNotchScreen", false) and var_0_3.CLOSE or var_0_3.OPEN
		end,
		func = function(arg_4_0)
			if cc.UserDefault:getInstance():getBoolForKey("isNotchScreen", false) ~= arg_4_0 then
				return
			end

			gGameUI:sendMessage("adapterNotchScreen", true)

			local var_4_0 = not arg_4_0

			cc.UserDefault:getInstance():setBoolForKey("isNotchScreen", var_4_0)

			if var_4_0 then
				display.notchSceenSafeArea = display.fullScreenSafeArea
				display.notchSceenDiffX = display.fullScreenDiffX
			else
				display.notchSceenSafeArea = 0
				display.notchSceenDiffX = 0
			end

			gGameUI:sendMessage("adapterNotchScreen", false)
		end
	},
	{
		name = gLanguageCsv.settingVip,
		select1 = gLanguageCsv.settingHide,
		select2 = gLanguageCsv.settingShow,
		btnType = var_0_1.RADIO,
		initFunc = function()
			return not gGameModel.role:read("vip_hide") and var_0_3.CLOSE or var_0_3.OPEN
		end,
		func = function(arg_6_0)
			if gGameModel.role:read("vip_hide") ~= arg_6_0 then
				gGameApp:requestServer("/game/role/vip/display/switch", function(arg_7_0)
					return
				end, arg_6_0)
			end
		end
	}
}

local function var_0_5(arg_8_0, arg_8_1, arg_8_2)
	arg_8_1.text:text(arg_8_2.name)
	arg_8_1.btnPanel1:get("text"):text(arg_8_2.select1)
	arg_8_1.btnPanel2:get("text"):text(arg_8_2.select2)

	local function var_8_0(arg_9_0, arg_9_1)
		local var_9_0 = var_0_2[arg_8_2.btnType]
		local var_9_1 = arg_9_0:get("btn")
		local var_9_2 = var_9_1:get("btnImg")

		var_9_1:texture(var_9_0.resNormal)
		var_9_2:texture(var_9_0.resBtnImg)
		var_9_2:xy(30, 30)

		local var_9_3 = idler.new()

		var_9_3:addListener(function(arg_10_0, arg_10_1)
			local var_10_0 = arg_10_0 == var_0_3.OPEN

			var_9_1:texture(var_10_0 and var_9_0.resSelected or var_9_0.resNormal)

			if var_10_0 then
				var_9_2:xy(100, 30)
			else
				var_9_2:xy(30, 30)
			end

			arg_8_2.func(var_10_0, arg_9_1)
		end, true)

		if arg_8_2.needCallBack(arg_9_1) then
			arg_8_2.initFunc(arg_9_1, function(arg_11_0)
				var_9_3:set(arg_11_0)
			end)
		else
			local var_9_4 = arg_8_2.initFunc()

			var_9_3:set(var_9_4)
		end

		bind.click(arg_8_0, arg_9_0, {
			method = function()
				local var_12_0 = var_9_3:read() == var_0_3.OPEN and var_0_3.CLOSE or var_0_3.OPEN

				var_9_3:set(var_12_0)
			end
		})
	end

	local function var_8_1(arg_13_0, arg_13_1)
		local var_13_0 = var_0_2[arg_8_2.btnType]
		local var_13_1 = arg_13_0:get("btn")
		local var_13_2 = arg_13_1:get("btn")

		var_13_1:texture(var_13_0.resNormal)
		var_13_1:get("btnImg"):texture(var_13_0.resBtnImg)
		var_13_2:texture(var_13_0.resNormal)
		var_13_2:get("btnImg"):texture(var_13_0.resBtnImg)

		local var_13_3 = idler.new()

		var_13_3:addListener(function(arg_14_0, arg_14_1)
			local var_14_0 = arg_14_0 == var_0_3.OPEN

			var_13_1:get("btnImg"):visible(var_14_0)
			var_13_2:get("btnImg"):visible(not var_14_0)
			arg_8_2.func(var_14_0)
		end, true)
		var_13_3:set(arg_8_2.initFunc())

		local function var_13_4()
			var_13_3:set(var_0_3.OPEN)
		end

		local function var_13_5()
			var_13_3:set(var_0_3.CLOSE)
		end

		bind.click(arg_8_0, arg_13_0, {
			method = function()
				var_13_3:set(var_0_3.OPEN)
			end
		})
		bind.click(arg_8_0, arg_13_1, {
			method = function()
				var_13_3:set(var_0_3.CLOSE)
			end
		})
	end

	if arg_8_2.btnType == var_0_1.RADIO then
		var_8_1(arg_8_1.btnPanel1, arg_8_1.btnPanel2)
	else
		var_8_0(arg_8_1.btnPanel1, 1)
		var_8_0(arg_8_1.btnPanel2, 2)
	end
end

local var_0_6 = class("SettingNormalView", cc.load("mvc").ViewBase)

var_0_6.RESOURCE_FILENAME = "setting_normal.json"
var_0_6.RESOURCE_BINDING = {
	["centerPanel.item"] = "listItem",
	versionPanel = "versionPanel",
	["centerPanel.bottomPanel"] = "bottomPanel",
	serverTimePanel = "serverTimePanel",
	centerPanel = "centerPanel",
	["centerPanel.btnList"] = {
		varname = "btnList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				padding = 0,
				data = bindHelper.self("listData"),
				item = bindHelper.self("listItem"),
				margin = bindHelper.self("margin"),
				onItem = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
					local var_19_0 = arg_19_1:multiget("text", "btnPanel1", "btnPanel2")

					var_0_5(arg_19_0, var_19_0, arg_19_3)
				end,
				onAfterBuild = function(arg_20_0)
					if itertools.size(arg_20_0.data) == 1 then
						arg_20_0:setItemAlignCenter()
					end
				end
			}
		}
	},
	["centerPanel.bottomPanel.btnService"] = {
		varname = "btnService",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onService")
			}
		}
	},
	["centerPanel.bottomPanel.btnLogOut"] = {
		varname = "btnLogOut",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onLogOut")
			}
		}
	},
	["centerPanel.bottomPanel.btnRedeemCode"] = {
		varname = "btnRedeemCode",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRedeemCode")
			}
		}
	},
	["centerPanel.bottomPanel.btnNotice"] = {
		varname = "btnNotice",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onNotice")
			}
		}
	},
	["centerPanel.bottomPanel.btnFeedback"] = {
		varname = "btnFeedback",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onFeedback")
			}
		}
	},
	["centerPanel.bottomPanel.btnTcPrivacy"] = {
		varname = "btnTcPrivacy",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onTcPrivacy")
			}
		}
	},
	["centerPanel.bottomPanel.btnTcPermission"] = {
		varname = "btnTcPermission",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onTcPermission")
			}
		}
	},
	["centerPanel.bottomPanel.btnLogOut.text"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 1,
						color = ui.NEWCOLORS.OUTLINE.YELLOW1
					}
				}
			}
		}
	},
	["centerPanel.bottomPanel.btnRedeemCode.text"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 1,
						color = ui.NEWCOLORS.OUTLINE.YELLOW1
					}
				}
			}
		}
	},
	["centerPanel.bottomPanel.btnService.text"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 1,
						color = ui.NEWCOLORS.OUTLINE.YELLOW1
					}
				}
			}
		}
	},
	["centerPanel.bottomPanel.btnNotice.text"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 1,
						color = ui.NEWCOLORS.OUTLINE.YELLOW1
					}
				}
			}
		}
	},
	["centerPanel.bottomPanel.btnFeedback.text"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 1,
						color = ui.NEWCOLORS.OUTLINE.YELLOW1
					}
				}
			}
		}
	},
	["centerPanel.bottomPanel.btnTcPrivacy.text"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 1,
						color = ui.NEWCOLORS.OUTLINE.YELLOW1
					}
				}
			}
		}
	},
	["centerPanel.bottomPanel.btnTcPermission.text"] = {
		binds = {
			{
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
}

function var_0_6.onCreate(arg_21_0)
	arg_21_0.listData = clone(var_0_4)

	arg_21_0.btnService:hide()
	arg_21_0:judgeTc()
	arg_21_0.versionPanel:get("version"):text(APP_VERSION)
	adapt.oneLinePos(arg_21_0.versionPanel:get("version"), arg_21_0.versionPanel:get("text"), nil, "right")
	arg_21_0:enableSchedule():schedule(function()
		local var_22_0 = time.getNowDate()

		if APP_CHANNEL == "none" or APP_CHANNEL == "luo" then
			arg_21_0.serverTimePanel:get("time"):text(string.format("%s/%s/%s %02d:%02d:%02d", var_22_0.year, var_22_0.month, var_22_0.day, var_22_0.hour, var_22_0.min, var_22_0.sec))
		else
			arg_21_0.serverTimePanel:get("time"):text(string.format("%02d:%02d:%02d", var_22_0.hour, var_22_0.min, var_22_0.sec))
		end

		adapt.oneLinePos(arg_21_0.serverTimePanel:get("time"), arg_21_0.serverTimePanel:get("text"), nil, "right")
	end, 1, 0, 1)

	if not dataEasy.isUnlock(gUnlockCsv.vipDisplaySwitch) then
		arg_21_0.listData[3] = nil
	end

	local function var_21_0()
		arg_21_0.listData[2] = nil
	end

	if display.sizeInPixels.width < display.sizeInPixels.height * 2 then
		var_21_0()
	elseif device.platform == "windows" then
		if device.model == "iphone_x" then
			var_21_0()
		end
	elseif display.isNotchSceen ~= 1 then
		var_21_0()
	end

	arg_21_0.margin = ({
		0,
		70,
		30,
		8
	})[itertools.size(arg_21_0.listData)]

	local var_21_1 = 0

	arg_21_0.versionPanel:onClick(function()
		var_21_1 = var_21_1 + 1

		if var_21_1 % 10 == 0 then
			gGameUI:showTip("Copyright (c) 2020 HangZhou TianJi Information Technology Inc.")
		end
	end)
	arg_21_0:setLoginProtocol()
end

function var_0_6.onService(arg_25_0)
	return
end

function var_0_6.setLoginProtocol(arg_26_0)
	if not APP_TAG:find("_qq") then
		return
	end

	local var_26_0 = "http://page.kuyangsh.cn/site/privacy?key=08a412053778cad3de9a8fcddb7e21582d3cfda0"
	local var_26_1 = string.format("#C0x8a5b0c##L00010100##LUL%s#隐私政策和用户协议", var_26_0)
	local var_26_2 = rich.createWithWidth(var_26_1, 36, nil, 1000):setAnchorPoint(cc.p(0, 0.5)):addTo(arg_26_0.bottomPanel, 5, "richText")

	adapt.oneLinePos(arg_26_0.btnNotice, var_26_2, cc.p(100, 40), "left")
end

function var_0_6.onLogOut(arg_27_0)
	sdk.logout(function(arg_28_0)
		print("sdk logout callback", arg_28_0)
	end)
	sdk.commitRoleInfo(5, function()
		print("sdk commitRoleInfo logout")
	end)
	gGameApp:onBackLogin()
end

function var_0_6.onNotice(arg_30_0)
	gGameApp:getNotice(function(arg_31_0)
		gGameUI:stackUI("login.placard", nil, nil, arg_31_0.notice)
	end)
end

function var_0_6.onRedeemCode(arg_32_0)
	gGameUI:stackUI("city.setting.redeem_code")
end

function var_0_6.onFeedback(arg_33_0)
	if userDefault.getCurrDayKey("feedBackDayCount", 0) >= gCommonConfigCsv.feedBackDayCount then
		gGameUI:showTip(gLanguageCsv.feedBackTooMany)
	else
		gGameUI:stackUI("city.setting.feed_back")
	end
end

function var_0_6.judgeTc(arg_34_0)
	local var_34_0 = APP_TAG

	print("SettingNormalView:APP_TAG is ", var_34_0)

	local var_34_1 = string.gsub(var_34_0, "_", " ")
	local var_34_2 = {}

	for iter_34_0 in string.gmatch(var_34_1, "%w+") do
		var_34_2[#var_34_2 + 1] = iter_34_0
	end

	if LOCAL_LANGUAGE == "cn" and var_34_2[1] and tonumber(var_34_2[3]) and var_34_2[1] == "a10054" and tonumber(var_34_2[3]) > 20210329 then
		arg_34_0.btnTcPrivacy:show()
		arg_34_0.btnTcPermission:show()
	else
		arg_34_0.btnTcPrivacy:hide()
		arg_34_0.btnTcPermission:hide()
	end
end

function var_0_6.onTcPrivacy(arg_35_0)
	sdk.openPrivacyProtocols()
end

function var_0_6.onTcPermission(arg_36_0)
	sdk.openPermissionSetting()
end

return var_0_6
