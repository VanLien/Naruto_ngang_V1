local var_0_0 = class("SettingFeedBackView", Dialog)

var_0_0.RESOURCE_FILENAME = "setting_feed_back.json"
var_0_0.RESOURCE_BINDING = {
	btnBug = "btnBug",
	textField = "textField",
	btnBattle = "btnBattle",
	btnRecharge = "btnRecharge",
	btnRecommend = "btnRecommend",
	title = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	btnClose = {
		varname = "btnClose",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnCancel = {
		varname = "btnCancel",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnComfirm = {
		varname = "btnComfirm",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onConfirmBtn")
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0)
	arg_1_0.checkState = idler.new("RechargeIssue")
	arg_1_0.btnData = {
		RechargeIssue = arg_1_0.btnRecharge,
		BattleIssue = arg_1_0.btnBattle,
		BugIssue = arg_1_0.btnBug,
		Recommand = arg_1_0.btnRecommend
	}

	arg_1_0.checkState:addListener(function(arg_2_0, arg_2_1)
		for iter_2_0, iter_2_1 in pairs(arg_1_0.btnData) do
			iter_2_1:get("btn"):get("btnImg"):visible(iter_2_0 == arg_2_0)
		end
	end)

	for iter_1_0, iter_1_1 in pairs(arg_1_0.btnData) do
		bind.click(arg_1_0, iter_1_1, {
			method = function()
				arg_1_0.checkState:set(iter_1_0)
			end
		})
	end

	arg_1_0.textField:setPlaceHolderColor(ui.NEWCOLORS.GRAY3)
	arg_1_0.textField:setTextColor(ui.NEWCOLORS.BROWN1)
	Dialog.onCreate(arg_1_0, {
		clickClose = false
	})
end

function var_0_0.onConfirmBtn(arg_4_0)
	if APP_CHANNEL == "none" or APP_CHANNEL == "luo" then
		arg_4_0:onClose()

		return
	end

	local var_4_0 = arg_4_0.textField:getStringValue()

	if string.trim(var_4_0) == "" then
		gGameUI:showTip(gLanguageCsv.canNotEmpty)

		return
	end

	if string.find(FEED_BACK_URL, "dingtalk") then
		arg_4_0:sendToDingDing(var_4_0)
	else
		arg_4_0:sendToCrashPlatform(var_4_0, matchLanguage({
			"kr"
		}))
	end

	arg_4_0:onClose()
end

function var_0_0.sendToCrashPlatform(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = {
		account_id = stringz.bintohex(gGameModel.account:read("id")),
		uid = gGameModel.role:read("uid"),
		game_server = gGameApp.net.gameSession.serverKey,
		role_name = gGameModel.role:read("name"),
		role_id = stringz.bintohex(gGameModel.role:read("id")),
		grade = gGameModel.role:read("level"),
		vip = gGameModel.role:read("vip_level"),
		classify = arg_5_0.checkState:read(),
		issue = arg_5_1
	}

	gGameApp.net:sendHttpRequest("POST", FEED_BACK_URL, json.encode(var_5_0), cc.XMLHTTPREQUEST_RESPONSE_STRING, function(arg_6_0)
		if not arg_5_2 then
			if arg_6_0.status == 200 then
				local var_6_0 = userDefault.getCurrDayKey("feedBackDayCount", 0)

				userDefault.setCurrDayKey("feedBackDayCount", var_6_0 + 1)
				gGameUI:showTip(gLanguageCsv.feedBackSuccess)
			else
				gGameUI:showTip(gLanguageCsv.feedBackFail)
			end
		end
	end)
end

local function var_0_1(arg_7_0)
	local var_7_0 = cc.XMLHttpRequest:new()

	var_7_0.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING

	var_7_0:open("POST", FEED_BACK_URL)
	var_7_0:setRequestHeader("Content-Type", "application/json")

	local function var_7_1(...)
		if var_7_0.status == 200 then
			local var_8_0 = userDefault.getCurrDayKey("feedBackDayCount", 0)

			userDefault.setCurrDayKey("feedBackDayCount", var_8_0 + 1)
		end
	end

	var_7_0:registerScriptHandler(var_7_1)
	var_7_0:send(arg_7_0)
end

function var_0_0.sendToDingDing(arg_9_0, arg_9_1)
	local var_9_0 = string.format("反馈时间: %s\n\n问题类型: %s\n\n区服: %s\n\n角色名: %s\n\n角色ID: %s\n\n等级: %s\n\nvip: %s\n\n问题描述: %s\n\n", os.date(), arg_9_0.checkState:read(), gGameApp.net.gameSession.serverKey, gGameModel.role:read("name"), stringz.bintohex(gGameModel.role:read("id")), gGameModel.role:read("level"), gGameModel.role:read("vip_level"), arg_9_1)
	local var_9_1 = {
		msgtype = "markdown",
		markdown = {
			title = "[口袋KR]" .. arg_9_0.checkState:read(),
			text = var_9_0
		}
	}

	var_0_1(json.encode(var_9_1))
end

return var_0_0
