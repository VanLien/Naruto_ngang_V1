local ViewBase = cc.load("mvc").ViewBase
local ZhenlongLoginView = class("ZhenlongLoginView", Dialog);
ZhenlongLoginView.RESOURCE_FILENAME = "zhenlong_login_new.json";

local TAG = "ZhenlongLoginView";
local TLOG = function(...)
    print("====== BEGIN TLOG:",TAG,"======")
    print(...);
	print("====== END TLOG:",TAG,"======")
end
ZhenlongLoginView.RESOURCE_BINDING = {
	["panelMain"] = "panelMain",

	["panelMain.imgTitle"] = "imgTitle",

	["panelMain.btnClose"] = {
		varname = "btnClose",
		binds = {
			event = "click",
			method = bindHelper.self("onClose")
		}
	},
	["panelMain.panelUserName"] = "panelUserName",
	["panelMain.panelPassword"] = "panelPassword",

	["panelMain.panelUserName.txtUserName"] = "txtUserName",
	["panelMain.panelPassword.txtPassword"] = "txtPassword",

	["panelMain.panelUserName.imgUserName"] = "imgUserName",
	["panelMain.panelPassword.imgPassword"] = "imgPassword",

	["panelMain.btnLogin"] = {
		varname = "btnLogin",
		binds = {
			event = "click",
			method = bindHelper.self("onLoginClick")
		}
	},

	["panelMain.btnRegister"] = {
		varname = "btnRegister",
		binds = {
			event = "click",
			method = bindHelper.self("onRegisterClick")
		}
	},

	["panelMain.btnLostPass"] = {
		varname = "btnLostPass",
		binds = {
			event = "click",
			method = bindHelper.self("onLostPassClick")
		}
	},

	["panelMain.btnChangePass"] = {
		varname = "btnChangePass",
		binds = {
			event = "click",
			method = bindHelper.self("onChangePassClick")
		}
	},

	["panelMain.btnGoogle"] = {
		varname = "btnGoogle",
		binds = {
			event = "click",
			method = bindHelper.self("onGoogleClick")
		}
	},

	["panelMain.btnFacebook"] = {
		varname = "btnFacebook",
		binds = {
			event = "click",
			method = bindHelper.self("onFacebookClick")
		}
	},

	["panelMain.btnLogout"] = {
		varname = "btnLogout",
		binds = {
			event = "click",
			method = bindHelper.self("onLogoutClick")
		}
	},

	["panelMain.btnQuickPlay"] = {
		varname = "btnQuickPlay",
		binds = {
			event = "click",
			method = bindHelper.self("onBtnQuickPlay")
		}
	},


}

function ZhenlongLoginView:onBtnQuickPlay()
	-- gGameUI:showTip("Chơi luôn....")


	local targetPlatform = cc.Application:getInstance():getTargetPlatform()
   
    local cb = function(szJson)
         
				if (szJson == "error") then
					gGameUI:showTip("Đăng ký chơi ngay thất bại, vui lòng thử lại sau.")
					return
				end
				if (szJson == "cancel") then
					gGameUI:showTip("Đã hủy đăng nhập")			
					return
				end

				local tbDeviceInfo = json.decode(szJson)
				
				local deviceId = tbDeviceInfo.deviceId
				local phoneNumber = tbDeviceInfo.phoneNumber

				

				deviceId = string.trim(deviceId)
				phoneNumber = string.trim(phoneNumber)
				
				if (deviceId == "") then
					gGameUI:showTip("Đăng nhập thất bại")	
					return
				end

				if (phoneNumber == "") then
					phoneNumber="000000000"
				end


				local email = string.format("%s@quickplay.langla",deviceId)


				--local userName = deviceId
				-- if (string.len(userName)<7) then
				-- 	userName = "000000000000"..userName
				-- end
				-- local startPos = string.len(userName)-5
				-- userName = "qp"..string.sub(userName,startPos)
				local userName = string.format( "qp%s",deviceId)

				local userPassword = deviceId
				

				if (self.loginView) then
					-- userDefault.setForeverLocalKey("account", "", {
					-- 	rawKey = true
					-- })
					-- userDefault.setForeverLocalKey("password", "", {
					-- 	rawKey = true
					-- })

					userDefault.setForeverLocalKey("accountQuick", userName, {
						rawKey = true
					})
					userDefault.setForeverLocalKey("passwordQuick", userPassword, {
						rawKey = true
					})

					self.loginView:onLoginorRegisterQuickClick(userName, email, userPassword, true, function(code, msg)
						if (code <= 0) then
							if (msg ~= nil and msg ~= "") then
								gGameUI:showTip(msg);
							end
						else
							self:onClose()
						end
					end)
				else
					TLOG("loginView is nil, to do nothing")
				end

			end
    
    if (cc.PLATFORM_OS_WINDOWS == targetPlatform) then
		gGameUI:showTip("Tính năng chưa được hỗ trợ trên nền tảng này")
   
    elseif (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        
        sdk.callPlatformFunc("customLogin", "quickPlay", function(szJson)   
                cb(szJson)  
           
        end)  
	elseif (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_MAC == targetPlatform)  then
		gGameUI:showTip("Tính năng chưa được hỗ trợ trên nền tảng này")
	else
		gGameUI:showTip("Tính năng chưa được hỗ trợ trên nền tảng này") 
    end

end
function ZhenlongLoginView:onCreate()
	
	

	self.txtUserName:setCursorEnabled(true);
	self.txtPassword:setCursorEnabled(true);
	self.txtUserName:setText(userDefault.getForeverLocalKey("account", self.txtUserName:getString(), { rawKey = true }));
	self.txtPassword:setText(userDefault.getForeverLocalKey("password", self.txtPassword:getString(), { rawKey = true }));

	
end
function ZhenlongLoginView:onLoginClick()
	if (self.loginView) then
		userDefault.setForeverLocalKey("account", self.txtUserName:getString(), {
			rawKey = true
		})
		userDefault.setForeverLocalKey("password", self.txtPassword:getString(), {
			rawKey = true
		})
		self.loginView:onLoginorRegisterClick(userDefault.getForeverLocalKey("account", "", {
			rawKey = true
		}), "", userDefault.getForeverLocalKey("password", "", {
			rawKey = true
		}), false, function(code, msg)
			if (code <= 0) then
				if (msg ~= nil and msg ~= "") then
					gGameUI:showTip(msg);
				end
			else
				self:onClose()
			end
		end)
	else
		TLOG("loginView is nil, to do nothing")
	end

end

function ZhenlongLoginView:openForLoginView(loginView)
	
	if (loginView == nil) then
		return;
	end
	-- TLOG("Received from view: ", loginView);
	self.loginView = loginView;
end

function ZhenlongLoginView:onLoginorRegisterClick(userName, email, password, isNew,callback)
	if (self.loginView) then
		userDefault.setForeverLocalKey("account", userName, {
			rawKey = true
		})
		userDefault.setForeverLocalKey("password", password, {
			rawKey = true
		})
		self.loginView:onLoginorRegisterClick(userName, email,password , isNew, function(code, msg)
			if (code <= 0) then
				if (msg ~= nil and msg ~= "") then
					if (callback ~= nil) then
						callback(code,msg)
					end
				end
			else
				callback(code,"")
				self:onClose()
			end
		end)
	else
		TLOG("loginView is nil, to do nothing")
	end
	
end
function ZhenlongLoginView:onRegisterClick()
	-- TLOG("onRegisterClick");
	gGameUI:stackUI("login.zhenlong_register"):openForZhenlongLoginView(self,self.loginView);

end

function ZhenlongLoginView:onLostPassClick()
	-- TLOG("onLostPassClick");
	gGameUI:stackUI("login.zhenlong_forgot_password"):openForZhenlongLoginView(self);
end

function ZhenlongLoginView:onChangePassClick()
	-- TLOG("onChangePassClick");
	gGameUI:stackUI("login.zhenlong_change_password"):openForZhenlongLoginView(self);
end
function ZhenlongLoginView:showDialog(szTitle,szContent,callback)
	
	
	gGameUI:showDialog({
		title = szTitle,
		content = szContent,
		align = "left",
		fontSize = 40,
        dialogParams = {clickClose = false},
        cb = callback,
        closeCb = callback
	})
	
end
function ZhenlongLoginView:onGoogleClick()
	
	-- local szTitle = "Thông tin đến bạn"
	-- local szContent = "Tính năng đăng nhập bằng tài khoản Google tạm thời chưa bật. Ngay bây giờ bạn có thể đăng ký một tài khoản của Mega Huyền Thoại để trải nghiệm game."
	-- local callback = nil
	-- gGameUI:showDialog({
	-- 	title = szTitle,
	-- 	content = szContent,
	-- 	align = "left",
	-- 	fontSize = 40,
    --     dialogParams = {clickClose = false},
    --     cb = callback,
    --     closeCb = callback
	-- })

	local targetPlatform = cc.Application:getInstance():getTargetPlatform()
   
    local cb = function(szJson)
         
		
		if (szJson == "error") then
			self:showDialog("Đăng nhập Google","Đăng nhập bằng tài khoản Google thất bại, vui lòng thử lại sau.")
			return
		end
		if (szJson == "cancel") then			
			return
		end

		local tbUser = json.decode(szJson)
		
		local userName = tbUser.userId
		-- if (string.len(userName)<7) then
		-- 	userName = "000000000000"..userName
		-- end
		-- local startPos = string.len(userName)-5
		-- userName = "gg"..string.sub(userName,startPos)
		userName = string.format("gg%s",tbUser.userId)

		local userPassword = tbUser.userSign
		
		if (self.loginView) then
			userDefault.setForeverLocalKey("account", userName, {
				rawKey = true
			})
			userDefault.setForeverLocalKey("password", userPassword, {
				rawKey = true
			})
			self.loginView:onLoginorRegisterClick(userDefault.getForeverLocalKey("account", "", {
				rawKey = true
			}), tbUser.userEmail, userDefault.getForeverLocalKey("password", "", {
				rawKey = true
			}), true, function(code, msg)
				if (code <= 0) then
					if (msg ~= nil and msg ~= "") then
						gGameUI:showTip(msg);
					end
				else
					self:onClose()
				end
			end)
		else
			TLOG("loginView is nil, to do nothing")
		end


    end
    
    if (cc.PLATFORM_OS_WINDOWS == targetPlatform) then

		gGameUI:showTip("Tính năng chưa được hỗ trợ trên nền tảng này")
    elseif (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        
        sdk.callPlatformFunc("firebaseLogin", "googleLogin", function(szJson)   
                cb(szJson)  
           
        end) 
	elseif (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_MAC == targetPlatform)  then
		gGameUI:showTip("Tính năng chưa được hỗ trợ trên nền tảng này")
	else
		gGameUI:showTip("Tính năng chưa được hỗ trợ trên nền tảng này") 
    end
end

function ZhenlongLoginView:onFacebookClick()
	
	-- local szTitle = "Thông tin đến bạn"
	-- local szContent = "Tính năng đăng nhập bằng tài khoản Facebook tạm thời chưa bật. Ngay bây giờ bạn có thể đăng ký một tài khoản của Mega Huyền Thoại để trải nghiệm game."
	-- local callback = nil
	-- gGameUI:showDialog({
		-- title = szTitle,
	-- 	content = szContent,
	-- 	align = "left",
	-- 	fontSize = 40,
    --     dialogParams = {clickClose = false},
    --     cb = callback,
    --     closeCb = callback
	-- })

	local targetPlatform = cc.Application:getInstance():getTargetPlatform()
   
    local cb = function(szJson)
         
		if (szJson == "error") then
			self:showDialog("Đăng nhập Facebook","Đăng nhập bằng tài khoản Facebook thất bại, vui lòng thử lại sau.")
			return
		end
		if (szJson == "cancel") then			
			return
		end

		local tbUser = json.decode(szJson)
		
		local userName = tbUser.userId

		
		-- if (string.len(userName)<7) then
		-- 	userName = "000000000000"..userName
		-- end
		-- local startPos = string.len(userName)-5
		-- userName = "fb"..string.sub(userName,startPos)
		userName = string.format("fb%s",tbUser.userId)

		local userPassword = tbUser.userSign


		local userEmail = tbUser.userEmail
		if (userEmail == nil or userEmail == "") then
			userEmail = tbUser.userId..".fbenone@gmail.com"
		end
		-- begin test
		--userEmail = nil
		-- end test
		if (self.loginView) then
			userDefault.setForeverLocalKey("account", userName, {
				rawKey = true
			})
			userDefault.setForeverLocalKey("password", userPassword, {
				rawKey = true
			})
			self.loginView:onLoginorRegisterClick(userDefault.getForeverLocalKey("account", "", {
				rawKey = true
			}), userEmail, userDefault.getForeverLocalKey("password", "", {
				rawKey = true
			}), true, function(code, msg)
				if (code <= 0) then
					if (msg ~= nil and msg ~= "") then
						gGameUI:showTip(msg);
					end
				else
					self:onClose()
				end
			end)
		else
			TLOG("loginView is nil, to do nothing")
		end
			

    end
    
    if (cc.PLATFORM_OS_WINDOWS == targetPlatform) then
		gGameUI:showTip("Tính năng chưa được hỗ trợ trên nền tảng này")
   
    elseif (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        
        sdk.callPlatformFunc("firebaseLogin", "facebookLogin", function(szJson)   
                cb(szJson)  
           
        end)  

	elseif (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_MAC == targetPlatform)  then
		gGameUI:showTip("Tính năng chưa được hỗ trợ trên nền tảng này")
	else
		gGameUI:showTip("Tính năng chưa được hỗ trợ trên nền tảng này")
    end
end

function ZhenlongLoginView:onLogoutClick()
	
	-- local szTitle = "Thông tin đến bạn"
	-- local szContent = "Ngay bây giờ bạn có thể đăng nhập bằng tài khoản của Mega Huyền Thoại để trải nghiệm game. Chúc các bạn tham gia game vui vẻ!"
	-- local callback = nil
	-- gGameUI:showDialog({
	-- 	title = szTitle,
	-- 	content = szContent,
	-- 	align = "left",
	-- 	fontSize = 40,
    --     dialogParams = {clickClose = false},
    --     cb = callback,
    --     closeCb = callback
	-- })

	local targetPlatform = cc.Application:getInstance():getTargetPlatform()
   
    local cb = function(szJson)
         self:showDialog("logout",szJson)
    end
    
    if (cc.PLATFORM_OS_WINDOWS == targetPlatform) then
		gGameUI:showTip("Tính năng chưa được hỗ trợ trên nền tảng này")
   
    elseif (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        
        sdk.callPlatformFunc("logout", "logout", function(szJson)   
                cb(szJson)  
           
        end)  
	elseif (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_MAC == targetPlatform)  then
		gGameUI:showTip("Tính năng chưa được hỗ trợ trên nền tảng này")
	else
		gGameUI:showTip("Tính năng chưa được hỗ trợ trên nền tảng này")
	end

end
-- @overide
function ZhenlongLoginView:onClose()
	TLOG("onClose");

	ViewBase.onClose(self);
end

return ZhenlongLoginView;
