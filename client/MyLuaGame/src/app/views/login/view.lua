local var_0_0 = dev.ONLINE_USER_NAME

if dev.LOGIN_ACCOUNT then
	userDefault.setForeverLocalKey("account", dev.LOGIN_ACCOUNT, {
		rawKey = true
	})
end

if dev.LOGIN_SERVER_KEY then
	userDefault.setForeverLocalKey("serverKey", dev.LOGIN_SERVER_KEY, {
		rawKey = true
	})
end

require("battle.app_views.battle.battle_entrance.include")

local var_0_1 = class("LoginView", cc.load("mvc").ViewBase)
local var_0_2 = require("app.views.city.halloween_messages"):getInstance()

var_0_1.RESOURCE_FILENAME = "login.json"
var_0_1.RESOURCE_BINDING = {
	["midPanel.server.bg"] = "serverBg",
	["midPanel.server.currServer"] = "currentServer",
	["leftPanel.btnUser"] = "btnUser",
	leftPanel = "leftPanel",
	["leftPanel.btnProtocol"] = "btnProtocol",
	["leftPanel.btnNotice"] = {
		varname = "btnNotice",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPlacardClick")
			}
		}
	},
	["leftPanel.btnNotice.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["midPanel.btnLogin"] = {
		varname = "btnLogin",
		binds = {
			clicksafe = true,
			event = "touch",
			methods = {
				ended = bindHelper.self("onLoginClick")
			}
		}
	},
	["midPanel.btnRegister"] = {
		varname = "btnRegister",
		binds = {
			clicksafe = true,
			event = "touch",
			methods = {
				ended = bindHelper.self("onRegisterClick")
			}
		}
	},
	["midPanel.btnReturn"] = {
		varname = "btnReturn",
		binds = {
			clicksafe = true,
			event = "touch",
			methods = {
				ended = bindHelper.self("onReturnClick")
			}
		}
	},
	["midPanel.server"] = {
		varname = "loginServer",
		binds = {
			event = "click",
			method = bindHelper.self("onChooseServer")
		}
	},
	["midPanel.server.chooseServer"] = {
		varname = "chooseServer",
		binds = {
			event = "click",
			method = bindHelper.self("onChooseServer")
		}
	},
	["midPanel.server.status"] = {
		varname = "statusColor",
		binds = {
			event = "text",
			idler = bindHelper.self("serverStatus")
		}
	},
	version = {
		binds = {
			{
				event = "text",
				data = APP_VERSION
			},
			{
				event = "effect",
				data = {
					outline = {
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			}
		}
	}
}

local var_0_3 = {}

var_0_3.RESOURCE_FILENAME = "login_input.json"
var_0_3.RESOURCE_BINDING = {
	txtAccount = "txtAccount",
	txtPassword = "txtPassword",
	account = "account",
	password = "password"
}

local var_0_4 = {
	gLanguageCsv.hot,
	gLanguageCsv.fluency,
	gLanguageCsv.preserve
}
local var_0_5 = {
	ui.COLORS.NORMAL.RED,
	cc.c4b(107, 201, 145, 255),
	(cc.c4b(187, 187, 187, 255))
}
local var_0_6 = 0

function var_0_1.onCreate(arg_1_0)
	arg_1_0.userName = nil

	arg_1_0.btnUser:hide()
	arg_1_0.btnProtocol:hide()

	local var_1_0 = "login/login.skel"
	local var_1_1, var_1_2 = dataEasy.isDisplayReplaceHuodong("loginSpine")

	if var_1_1 then
		var_1_0 = var_1_2
	end

	if var_1_0 then
		widget.addAnimation(arg_1_0:getResourceNode(), var_1_0, "login_01", 0):scale(2):xy(display.sizeInView.width / 2, display.sizeInView.height / 2):name("loginSpine"):addPlay("effect_loop")
	end

	arg_1_0.serverStatus = idler.new("serverStatus")

	arg_1_0.currentServer:text("currentServer")

	if APP_CHANNEL == "none" or APP_CHANNEL == "luo" then
		local var_1_3 = gGameUI:getConvertPos(arg_1_0.loginServer)

		arg_1_0.inputWidget = gGameUI:createSimpleView(var_0_3, arg_1_0):init()

		local var_1_4 = arg_1_0.inputWidget:getResourceNode():size()

		arg_1_0.inputWidget:xy(var_1_3.x - var_1_4.width / 2, var_1_3.y - var_1_4.height / 2)

		local var_1_5 = userDefault.getForeverLocalKey("account", "", {
			rawKey = true
		})

		arg_1_0.inputWidget.txtAccount:setText(var_1_5)
		arg_1_0.inputWidget.txtAccount:setPlaceHolderColor(ui.COLORS.DISABLED.GRAY)

		local var_1_6 = userDefault.getForeverLocalKey("pass", "", {
			rawKey = true
		})

		arg_1_0.inputWidget.txtPassword:setText(var_1_6)
		arg_1_0.inputWidget.txtPassword:setPlaceHolderColor(ui.COLORS.DISABLED.GRAY)
		adapt.oneLinePos(arg_1_0.inputWidget.account, arg_1_0.inputWidget.txtAccount, cc.p(15, 0))
		adapt.oneLinePos(arg_1_0.inputWidget.password, arg_1_0.inputWidget.txtPassword, cc.p(15, 0))

		if dev.ONLINE_VERSION_LANGUAGE and var_0_0 then
			arg_1_0.inputWidget.txtAccount:setString(var_0_0)
		end

		arg_1_0.btnReturn:setVisible(false)
	end

	if not dev.IGNORE_POPUP_BOX then
		local var_1_7 = os.date("%Y%m%d", os.time())
		local var_1_8 = userDefault.getForeverLocalKey("placardStatusDay", {}, {
			rawData = true,
			rawKey = true
		})
		local var_1_9 = {
			{
				key = var_1_8[var_1_7],
				cb = function(arg_2_0)
					arg_1_0:showPlacard()
				end
			}
		}

		arg_1_0:managerOpenView(var_1_9, 1)
	end

	audio.playMusic("login.mp3")
	userDefault.setForeverLocalKey("posterLoginShow", false, {
		rawKey = true
	})
	sdk.trackEvent(2)
	arg_1_0:additionForCN()
	arg_1_0:additionForKR()
	arg_1_0:additionForEN()
	var_0_2:clear()
	arg_1_0:testInLogin()
end

function var_0_1.showPrivace(arg_3_0)
	if userDefault.getForeverLocalKey("firstlogin", true, {
		rawKey = true
	}) then
		sdk.callSdkManager("showPrivace", {
			listener = function(arg_4_0)
				if arg_4_0 and tonumber(arg_4_0.ok) == 1 then
					userDefault.setForeverLocalKey("firstlogin", false, {
						rawKey = true
					})
					arg_3_0:autoLogin()
				else
					if arg_4_0 and arg_4_0.ori == "showPrivace" then
						userDefault.setForeverLocalKey("firstlogin", false, {
							rawKey = true
						})
						arg_3_0:autoLogin()

						return
					end

					display.director:endToLua()
				end
			end
		})
	end
end

function var_0_1.autoLogin(arg_5_0)
	if userDefault.getForeverLocalKey("firstlogin", true, {
		rawKey = true
	}) and device.platform ~= "android" then
		arg_5_0:showPrivace()

		return
	end

	sdk.callSdkManager("autoLogin", {
		listener = function(arg_6_0)
			if arg_6_0 and arg_6_0.ori == "autoLogin" then
				return
			end

			if arg_6_0.isSuccess == 0 then
				gGameUI:showTip(gLanguageCsv.sessionError)
			end
		end
	})
end

function var_0_1.showLoginInput(arg_7_0)
	local var_7_0 = gGameUI:getConvertPos(arg_7_0.loginServer)

	arg_7_0.inputWidget = gGameUI:createSimpleView(var_0_3, arg_7_0.midPanel):init()

	local var_7_1 = arg_7_0.inputWidget:getResourceNode():size()

	arg_7_0.inputWidget:xy(var_7_0.x - var_7_1.width / 2, var_7_0.y - var_7_1.height / 2)

	local var_7_2 = userDefault.getForeverLocalKey("account", "", {
		rawKey = true
	})

	arg_7_0.inputWidget.txtAccount:setText(var_7_2)
	arg_7_0.inputWidget.txtAccount:setPlaceHolderColor(ui.COLORS.DISABLED.GRAY)

	local var_7_3 = userDefault.getForeverLocalKey("pass", "", {
		rawKey = true
	})

	arg_7_0.inputWidget.txtPassword:setText(var_7_3)
	arg_7_0.inputWidget.txtPassword:setPlaceHolderColor(ui.COLORS.DISABLED.GRAY)
	adapt.oneLinePos(arg_7_0.inputWidget.account, arg_7_0.inputWidget.txtAccount, cc.p(15, 0))
	adapt.oneLinePos(arg_7_0.inputWidget.password, arg_7_0.inputWidget.txtPassword, cc.p(15, 0))
end

function var_0_1.createSupportLabel(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = label.create(arg_8_2, {
		fontPath = "font/youmi1.ttf",
		fontSize = arg_8_3,
		color = ui.COLORS.NORMAL.WHITE,
		pos = cc.p(arg_8_1:getContentSize().width / 2, -20),
		effect = {
			outline = {
				color = ui.COLORS.OUTLINE.DEFAULT
			}
		}
	}):addTo(arg_8_1)

	bind.touch(arg_8_0, arg_8_1, {
		methods = {
			ended = arg_8_4
		}
	})

	return var_8_0
end

function var_0_1.additionForCN(arg_9_0)
	if not checkLanguage("cn") then
		return
	end

	local var_9_0 = cc.p(arg_9_0.btnNotice:getPosition())

	var_9_0.x = var_9_0.x + 130
	var_9_0.y = var_9_0.y - 20
end

function var_0_1.additionForKR(arg_10_0)
	if not matchLanguage({
		"kr"
	}) then
		return
	end

	local var_10_0 = {
		{
			resPath = "login/icon_grqb.png",
			name = "개인정보"
		},
		{
			resPath = "login/icon_yyzc.png",
			name = "운영정책"
		},
		{
			resPath = "login/icon_yhxy.png",
			name = "이용약관"
		},
		{
			resPath = "login/icon_kfzx.png",
			name = "고객센터"
		}
	}
	local var_10_1 = ccui.Layout:create():setAnchorPoint(cc.p(1, 1)):setPosition(cc.p(display.sizeInView.width, display.sizeInView.height)):size(cc.size(200, 600)):addTo(arg_10_0:getResourceNode())

	adapt.dockWithScreen(var_10_1, "left", "up")

	local var_10_2 = ccui.Button:create(var_10_0[4].resPath):setPosition(cc.p(arg_10_0.btnProtocol:getPosition())):addTo(arg_10_0.leftPanel):scale(0.9)

	arg_10_0:createSupportLabel(var_10_2, var_10_0[4].name, 32, functools.partial(arg_10_0.onAdditionBtnClick, arg_10_0, 4))

	for iter_10_0 = 1, 3 do
		local var_10_3 = ccui.Button:create(var_10_0[iter_10_0].resPath):setPosition(cc.p(100, iter_10_0 * 170)):addTo(var_10_1):scale(0.9)

		arg_10_0:createSupportLabel(var_10_3, var_10_0[iter_10_0].name, 32, functools.partial(arg_10_0.onAdditionBtnClick, arg_10_0, iter_10_0))
	end
end

function var_0_1.additionForEN(arg_11_0)
	if not matchLanguage({
		"en",
		"cn"
	}) then
		return
	end
end

function var_0_1.onAdditionBtnClick(arg_12_0, arg_12_1)
	if matchLanguage({
		"kr"
	}) then
		if arg_12_1 == 4 then
			cc.Application:getInstance():openURL(SUPPORT_URL)
		elseif arg_12_1 == 5 then
			cc.Application:getInstance():openURL(ZALO_URL)
		end
	end
end

function var_0_1.getRuleContext(arg_13_0, arg_13_1)
	local var_13_0 = adaptContext

	return {
		var_13_0.clone(arg_13_1.title, function(arg_14_0)
			arg_14_0:get("text"):text(gLanguageCsv.ageTips)
		end),
		var_13_0.noteText(125701, 125704)
	}
end

function var_0_1.testInLogin(arg_15_0)
	if device.platform == "windows" then
		require("app.views.login.test")(var_0_1)
		arg_15_0:createTestScene()
	end

	if APP_CHANNEL == "none" and false then
		require("app.views.login.test")(var_0_1)
		performWithDelay(arg_15_0, handler(arg_15_0, "showBenchmark"), 4)
	end
end

function var_0_1.onPlacardClick(arg_16_0)
	arg_16_0:showPlacard()
end

function var_0_1.onChooseServer(arg_17_0)
	gGameUI:stackUI("login.server", {
		setServerInfo = arg_17_0:createHandler("setServerInfo")
	}, nil, arg_17_0.servers)
end

function var_0_1.onLoginClick(arg_18_0, arg_18_1, arg_18_2)
	if arg_18_0.serverSelected and arg_18_0.servers then
		sdk.trackEvent(20)

		local var_18_0 = arg_18_0.servers[arg_18_0.serverSelected]

		print("selected server", arg_18_0.serverSelected, dumps(var_18_0))
		gGameApp:requestServerCustom("/login/enter_server"):params(var_18_0):onErrCall(function(arg_19_0)
			if arg_19_0.servers and #arg_19_0.servers > 0 then
				arg_18_0:setServers(arg_19_0.servers)
			end

			if arg_19_0.err == "register_disable" then
				local function var_19_0()
					local var_20_0 = arg_18_0.servers[arg_18_0:selectServerIdx()]

					arg_18_0:setServerInfo(var_20_0)
					gGameUI:showTip(gLanguageCsv.serverAutoChooseNew .. getServerName(var_20_0.key, true))
				end

				gGameUI:showDialog({
					title = gLanguageCsv.tips,
					content = gLanguageCsv.serverRegisterDisable,
					dialogParams = {
						clickClose = false
					},
					cb = var_19_0,
					closeCb = var_19_0
				})
			else
				gGameUI:showDialog({
					title = gLanguageCsv.tips,
					content = gLanguageCsv[arg_19_0.err] or arg_19_0.err,
					dialogParams = {
						clickClose = false
					}
				})
			end
		end):doit(function(arg_21_0)
			gGameApp:setGameServerAddr(var_18_0)
			gGameApp:requestServer("/game/login", function(arg_22_0)
				userDefault.setForeverLocalKey("serverKey", arg_18_0.servers[arg_18_0.serverSelected].key, {
					rawKey = true
				})

				local var_22_0 = userDefault.getForeverLocalKey("fps", 60, {
					rawKey = true
				})

				cc.Director:getInstance():setAnimationInterval(1 / var_22_0)

				if gGameUI.guideManager:checkFinished(1) and gGameUI.guideManager:checkFinished(2) then
					sdk.commitRoleInfo(1, function()
						print("sdk commitRoleInfo and go to city")
					end)
					gGameUI:switchUI("city.view")
				else
					dataEasy.isSkipNewbieBattle(function()
						if not gGameUI.guideManager:checkFinished(-1) then
							gGameApp:requestServer("/game/role/guide/newbie", nil, -1)
						end

						gGameUI:switchUI("new_character.view")
					end, function()
						arg_18_0:newbieBattle()
					end)
				end
			end)
		end)
	else
		sdk.trackEvent(19)

		local var_18_1 = ""
		local var_18_2 = ""

		if APP_CHANNEL == "none" or APP_CHANNEL == "luo" then
			local var_18_3 = arg_18_0.inputWidget.txtAccount:getString()

			if var_18_3 == "" then
				gGameUI:showDialog({
					content = "Vui lòng nhập tài khoản"
				})

				return
			end

			local var_18_4 = arg_18_0.inputWidget.txtPassword:getString()

			if var_18_4 == "" then
				gGameUI:showDialog({
					content = "Vui lòng nhập mật khẩu"
				})

				return
			end

			if not dev.ONLINE_VERSION_LANGUAGE then
				userDefault.setForeverLocalKey("account", var_18_3, {
					rawKey = true
				})
				userDefault.setForeverLocalKey("pass", var_18_4, {
					rawKey = true
				})
			end

			--arg_18_0:onServerLogin(var_18_3, var_18_4)
			arg_18_0:doAPILogin(var_18_3, var_18_4)
		else
			sdk.login(function(arg_26_0, arg_26_1)
				printInfo("LoginView:sdkLogin %s %s", arg_26_0, arg_26_1)

				if arg_26_0 == 0 then
					arg_18_0:onServerLogin(arg_26_1)
				end
			end)
		end
	end
end

-- function var_0_1.onRegisterClick(arg_27_0, arg_27_1, arg_27_2)
-- 	arg_27_0.btnRegister:setVisible(false)
-- 	arg_27_0.btnReturn:setVisible(true)
-- 	arg_27_0.btnLogin:get("login"):setText("Đăng ký")

-- 	arg_27_0.isregister = 1
--end
local LOGIN_API_URL = "http://180.93.98.5/gameAPI/login.php"
local REGISTER_API_URL = "http://180.93.98.5/gameAPI/register.php"

function var_0_1:onRegisterClick(node, event)
	gGameUI:stackUI("login.register", nil, {full = true}, self:createHandler("onRegisterSuccess"))
end

function var_0_1:onRegisterSuccess(registerView, userName, userPass)
	print("Register success callback:", userName, userPass)
	if self.inputWidget then
		self.inputWidget.txtAccount:setText(userName)
		self.inputWidget.txtPassword:setText(userPass)
	end
	self.registerView = registerView

	if not dev.ONLINE_VERSION_LANGUAGE then
		userDefault.setForeverLocalKey("account", userName, {rawKey = true})
		userDefault.setForeverLocalKey("passwd", userPass, {rawKey = true})
	end

	-- auto-login หลัง register สำเร็จ
	--self:doAPILogin(userName, userPass)
end
function var_0_1:doAPILogin(username, password)
	gGameUI:showConnecting()

	-- เข้ารหัส MD5 password
	require "3rd.MD5"
	local md5Password = md5(password)

	local xhr = cc.XMLHttpRequest:new()
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
	xhr:open("POST", LOGIN_API_URL)
	xhr.timeout = 10
	xhr:setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
	xhr:registerScriptHandler(function()
		--if xhr.readyState ~= 4 then return end
		print("---------------------------:")
		gGameUI:hideConnecting()

		if xhr.status == 200 then
			local response = xhr.response
			print("Login API response:", response)

			local ok, result = pcall(json.decode, response)
			print("JSON decode ok:", ok, "result:", result and dumps(result) or "nil")

			-- ตรวจสอบ status == 0 (number) หรือ "0" (string)
			local isSuccess = ok and result and (result.status == 0 or result.status == "0")

			if isSuccess then
				print("Login success:", username)
				userDefault.setForeverLocalKey("account", username, {rawKey = true})
				cc.UserDefault:getInstance():setStringForKey("username", username)
				cc.UserDefault:getInstance():flush()
				sdk.loginInfo = json.encode({channelId = "", userName = username})
				self:onServerLogin(username)
			else
				local errMsg = (ok and result and result.msg) or "Đăng nhập không thành công"
				print("Login failed:", errMsg)
				gGameUI:showTip(errMsg)
			end
		else
			gGameUI:showTip("Lỗi kết nối với máy chủ: " .. tostring(xhr.status))
		end
	end)

	local postData = string.format("username=%s&password=%s", username, md5Password)
	xhr:send(postData)
end
function var_0_1.onReturnClick(arg_28_0, arg_28_1, arg_28_2)
	arg_28_0.btnRegister:setVisible(true)
	arg_28_0.btnReturn:setVisible(false)
	arg_28_0.btnLogin:get("login"):setText("Đăng nhập")

	arg_28_0.isregister = 0
end



local function var_0_7(arg_29_0)
	local var_29_0 = arg_29_0.key

	if APP_CHANNEL == "none" then
		return true
	end

	local var_29_1 = var_29_0:find("game.shenhe.") ~= nil

	if FOR_SHENHE then
		return var_29_1
	end

	return not var_29_1
end

function var_0_1.showServerTip(arg_30_0)
	local var_30_0 = gLanguageCsv.serverOpenTime

	if APP_CHANNEL == "tc_beta" then
		var_30_0 = gLanguageCsv.serverCloseTime
	end

	gGameUI:showDialog({
		title = gLanguageCsv.tips,
		content = var_30_0,
		dialogParams = {
			clickClose = false
		}
	})
end

function var_0_1.setServers(arg_31_0, arg_31_1)
	local var_31_0 = json.decode(arg_31_1)

	collectgarbage()

	arg_31_0.servers = {}
	SERVERS_INFO = {}

	for iter_31_0, iter_31_1 in ipairs(var_31_0) do
		SERVERS_INFO[iter_31_1.key] = iter_31_1

		if var_0_7(iter_31_1) then
			table.insert(arg_31_0.servers, iter_31_1)
		else
			printDebug("the server %s be ignore", dumps(iter_31_1))
		end
	end

	table.sort(arg_31_0.servers, function(arg_32_0, arg_32_1)
		local var_32_0 = string.split(arg_32_0.key, ".")[2]
		local var_32_1 = string.split(arg_32_1.key, ".")[2]
		local var_32_2 = SERVER_MAP[var_32_0] and SERVER_MAP[var_32_0].order or math.huge
		local var_32_3 = SERVER_MAP[var_32_1] and SERVER_MAP[var_32_1].order or math.huge

		if var_32_2 ~= var_32_3 then
			return var_32_2 < var_32_3
		end

		return arg_32_0.id < arg_32_1.id
	end)
end

function var_0_1.selectServerIdx(arg_33_0)
	local var_33_0 = {}

	for iter_33_0, iter_33_1 in ipairs(arg_33_0.servers) do
		if iter_33_1.status == 2 then
			table.insert(var_33_0, iter_33_0)
		end
	end

	if #var_33_0 > 0 then
		return var_33_0[math.random(1, #var_33_0)]
	end

	return #arg_33_0.servers
end

function var_0_1.onServerLogin(arg_34_0, arg_34_1, arg_34_2)
	if arg_34_1 == arg_34_0.userName then
		printWarn("onServerLogin %s too much", arg_34_1)

		return
	end

	arg_34_0.userName = arg_34_1
	local loginData
	if (APP_CHANNEL == "none" or APP_CHANNEL == "luo") then
		loginData = arg_34_1   -- chỉ gửi username dạng string
	else
		local data = json.decode(arg_34_1)
		loginData = {
			username = data.userName,
			password = "",
			token = data.token,
			pid = sdk.getPid()
		}
	end

	gGameApp:requestServerCustom("login"):onErrClose(function()
		arg_34_0.userName = nil
	end):params(loginData):doit(function(arg_36_0)
		if tolua.isnull(arg_34_0) then
			return
		end

		if arg_34_0.setServers then
			arg_34_0:setServers(arg_36_0.servers)
		end

		if #arg_34_0.servers == 0 then
			arg_34_0:showServerTip()

			arg_34_0.userName = nil

			return
		end

		local var_36_0 = userDefault.getForeverLocalKey("serverKey", nil, {
			rawKey = true
		})

		if var_36_0 then
			arg_34_0.serverSelected = itertools.first(arg_34_0.servers, function(arg_37_0)
				return arg_37_0.key == var_36_0
			end)
		else
			arg_34_0.serverSelected = userDefault.getForeverLocalKey("serverId", nil, {
				rawKey = true
			})
		end

		if not arg_34_0.servers[arg_34_0.serverSelected] then
			arg_34_0.serverSelected = arg_34_0:selectServerIdx()
		end

		if dev.ONLINE_VERSION_LANGUAGE then
			local var_36_1 = gGameModel.account:read("role_infos")
			local var_36_2 = 0

			for iter_36_0, iter_36_1 in ipairs(arg_34_0.servers) do
				if var_36_1[iter_36_1.key] and var_36_2 < var_36_1[iter_36_1.key].level then
					var_36_2 = var_36_1[iter_36_1.key].level
					arg_34_0.serverSelected = iter_36_0
				end
			end
		end

		local var_36_3 = arg_34_0.servers[arg_34_0.serverSelected]

		arg_34_0:setServerInfo(arg_34_0.servers[arg_34_0.serverSelected])
		arg_34_0:showLoginServer()
	end)
end

function var_0_1.showPlacard(arg_38_0)
	sdk.trackEvent(17)
	gGameApp:getNotice(function(arg_39_0)
		gGameUI:stackUI("login.placard", nil, nil, arg_39_0.notice)
	end)
end

function var_0_1.showLoginServer(arg_40_0)
	if APP_CHANNEL == "none" or APP_CHANNEL == "luo" then
		arg_40_0.inputWidget:onClose()
		arg_40_0.btnRegister:setVisible(false)
		arg_40_0.btnReturn:setVisible(false)
		arg_40_0.btnLogin:get("login"):setText("Vào game")
	end

	arg_40_0.loginServer:show()
end

function var_0_1.setServerInfo(arg_41_0, arg_41_1)
	arg_41_0.serverStatus:set(var_0_4[arg_41_1.status])
	arg_41_0.currentServer:text(string.format("S%s. %s", getServerId(arg_41_1.key, true), getServerName(arg_41_1.key, true)))
	text.addEffect(arg_41_0.statusColor, {
		color = var_0_5[arg_41_1.status]
	})

	arg_41_0.serverSelected = itertools.first(arg_41_0.servers, function(arg_42_0)
		return arg_42_0.key == arg_41_1.key
	end)

	local var_41_0 = math.max(arg_41_0.currentServer:width() + arg_41_0.statusColor:width() + arg_41_0.chooseServer:width() + 150, 823)

	arg_41_0.serverBg:width(var_41_0)
	adapt.oneLineCenterPos(cc.p(arg_41_0.serverBg:xy()), {
		arg_41_0.statusColor,
		arg_41_0.currentServer,
		arg_41_0.chooseServer
	}, cc.p(50, 0))
end

function var_0_1.newbieBattle(arg_43_0)
	local var_43_0 = {
		roleLevel = 1,
		moduleType = 1,
		sceneID = 1,
		randSeed = 123456,
		roleOut = csvClone(csv.role_out_init),
		names = {
			gLanguageCsv.newbieName1,
			gLanguageCsv.newbieName2
		},
		levels = {
			99,
			99
		},
		logos = {
			52,
			50
		},
		preData = {}
	}

	printInfo("in newbieBattle")
	gGameUI:switchUIAndStash("battle.loading", var_43_0, var_43_0.sceneID, {
		baseMusic = "battle4.mp3"
	}, {}):onLoadOver()
end

function var_0_1.managerOpenView(arg_44_0, arg_44_1, arg_44_2)
	local var_44_0 = arg_44_1[arg_44_2]

	if not var_44_0 then
		return
	end

	if not var_44_0.key then
		var_44_0.cb(arg_44_0:createHandler("managerOpenView", arg_44_1, arg_44_2 + 1))
	else
		arg_44_0:managerOpenView(arg_44_1, arg_44_2 + 1)
	end
end

return var_0_1
