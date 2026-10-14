local ViewBase = cc.load("mvc").ViewBase
local ZhenlongRegisterView = class("ZhenlongRegisterView", Dialog);
ZhenlongRegisterView.RESOURCE_FILENAME = "zhenlong_register_new.json";

local TAG = "ZhenlongRegisterView";
local TLOG = function(...)
    print("====== BEGIN TLOG:",TAG,"======")
    print(...);
	print("====== END TLOG:",TAG,"======")
end
ZhenlongRegisterView.RESOURCE_BINDING = {
	["panelMain"] = "panelMain",

	["panelMain.imgTitle"] = "imgTitle",

	["panelMain.btnClose"] = {
		varname = "btnClose",
		binds = {
			event = "click",
			method = bindHelper.self("onCancelClick")
		}
	},
	["panelMain.panelUserName"] = "panelUserName",
	["panelMain.panelPassword"] = "panelPassword",
    ["panelMain.panelPasswordConfirm"] = "panelPasswordConfirm",
	["panelMain.panelEmail"] = "panelEmail",

    ["panelMain.panelUserName.imgUserName"] = "imgUserName",
	["panelMain.panelPassword.imgPassword"] = "imgPassword",
	["panelMain.panelPasswordConfirm.imgPasswordConfirm"] = "imgPasswordConfirm",
	["panelMain.panelEmail.imgEmail"] = "imgEmail",

	["panelMain.panelUserName.txtUserName"] = "txtUserName",
	["panelMain.panelPassword.txtPassword"] = "txtPassword",
	["panelMain.panelPasswordConfirm.txtPasswordConfirm"] = "txtPasswordConfirm",
	["panelMain.panelEmail.txtEmail"] = "txtEmail",
	["panelMain.lblNotice"] = "lblNotice",

	["panelMain.btnConfirm"] = {
		varname = "btnConfirm",
		binds = {
			event = "click",
			method = bindHelper.self("onConfirmClick")
		}
	},
	["panelMain.btnCancel"] = {
		varname = "btnCancel",
		binds = {
			event = "click",
			method = bindHelper.self("onCancelClick")
		}
	},


}
-- @overide
function ZhenlongRegisterView:onCreate()
	TLOG("onCreate");
    
    self.txtUserName:setCursorEnabled(true);
	self.txtPassword:setCursorEnabled(true);
    self.txtPasswordConfirm:setCursorEnabled(true);
    self.txtEmail:setCursorEnabled(true);

    self.lblNotice:setText("Lưu ý: Tên tài khoản hợp lệ từ [4-16] ký tự [a-z,0-9], mật khẩu từ 6 ký tự trở lên. Email hợp lệ yêu cầu phải nhập")
end
function ZhenlongRegisterView:showDialog(szTitle,szContent,callback)
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
function ZhenlongRegisterView:showTip(szTip)
    gGameUI:showTip(szTip);
end
function ZhenlongRegisterView:onConfirmClick()
    TLOG("onConfirmClick");
    self:doRegister(function (bRet,szMsg)
        if (bRet) then
            local userName = string.trim(self.txtUserName:getString() or "");    
            local password = string.trim(self.txtPassword:getString() or "");        
            local email = string.trim(self.txtEmail:getString() or "");
    
            local szTitle = "Đăng ký thành công";
            local szContent = string.format("Tài khoản: %s\nEmail: %s\nChúc bạn trải nghiệm vui vẻ!",userName,email);
            self:showDialog(szTitle,szContent,function ()
                if (self.zhenlongLoginView) then
                    self.zhenlongLoginView.txtUserName:setText(userName);
                    self.zhenlongLoginView.txtPassword:setText(password);
                end
                self:onClose();
            end);       
        else
            if (string.trim(szMsg or "") ~= "") then
                self:showDialog("Đăng ký thất bại",szMsg);
            end        
        end
    end);
   
end
function ZhenlongRegisterView:doRegister(callback)
    TLOG("doRegister");
   

   
    local userName = string.trim(self.txtUserName:getString() or "");    
    local password = string.trim(self.txtPassword:getString() or "");
    local passwordConfirm = string.trim(self.txtPasswordConfirm:getString() or "");
    local email = string.trim(self.txtEmail:getString() or "");
   
    TLOG("userName:",userName,"password:",password,"passwordConfirm:",passwordConfirm,"email:",email)
    
    if (userName == "") then
        callback( false,"Tên tài khoản yêu cầu nhập");
        return;
        
    end
    if (password == "") then
        callback( false,"Mật khẩu yêu cầu nhập");
        return;
    end

    if (password ~= passwordConfirm) then
        callback( false,"Xác nhận mật khẩu không khớp");
        return;
    end

    if (email == "") then
        callback(false,"Email yêu cầu nhập");
        return;
    end


    if (self.zhenlongLoginView.loginView) then
        -- userDefault.setForeverLocalKey("account", userName, {
        -- 	rawKey = true
        -- })
        -- userDefault.setForeverLocalKey("password", password, {
        -- 	rawKey = true
        -- })  

        self.zhenlongLoginView:onLoginorRegisterClick(userName, email, password, true, function(code, msg)
            if (code <= 0) then
                if (msg ~= nil and msg ~= "") then
                    callback(false,msg);
                    -- gGameUI:showTip(msg);
                end
            else
                
                self:onClose()
                
            end
        end)
    else
        TLOG("loginView is nil, to do nothing")
    end

    

   
    -- local params = string.format("account=%s&password=%s&email=%s&channel=%s&language=%s&",userName,password,email,sdk.getChannel(userName),LOCAL_LANGUAGE);
    -- print("param", params)   
    
    -- gGameApp.net:sendHttpRequest("POST", REGISTER_ACCOUNT_CFG, params,
    --     cc.XMLHTTPREQUEST_RESPONSE_STRING, function(xhr)
     
            
    --         local res = json.decode(xhr.response)
    --         if xhr.status == 200 then
              
    --             if (res.code == 0) then
                    
    --                 TLOG(res.code)
    --                callback(true,"Đăng ký tài khoản thành công")
    --             elseif (res.code == -202) then
                    
    --                     callback(false,"Tài khoản này đã tồn tại")
    --             elseif (res.code == -100) then
                   
    --                 TLOG(res.code)
    --                 local szContent = [[
    --                     Thông tin đăng kí không hợp lệ:
    --                     1. Tài khoản không được chứa kí tự đặc biệt.
    --                     2. Tài khoản từ [4-16][a-Z] kí tự.
    --                     3. Mật khẩu  từ [6-32] kí tự.
    --                     4. Email phải đúng định dạng.
    --                 ]]
    --                 callback(false,szContent)
    --             end
    --         else
              
    --             TLOG(res.code)
    --             callback(false,"Có lỗi xảy ra, vui lòng đăng kí lại bạn nhé")
    --         end
    --     end)
  
    --------------------------------------------------------------------
end
function ZhenlongRegisterView:onCancelClick()
    TLOG("onCancleClick");

    if (self.zhenlongLoginView) then
        self.zhenlongLoginView.panelMain:show();
    end

    self:onClose();   
end
function ZhenlongRegisterView:openForZhenlongLoginView(zhenlongLoginView,mainView)
    self.zhenlongLoginView = zhenlongLoginView;
    self.mainView = mainView;
    if (self.zhenlongLoginView) then
        self.zhenlongLoginView.panelMain:hide();
    end
    TLOG(zhenlongLoginView);
end


-- @overide
function ZhenlongRegisterView:onClose()
	TLOG("onClose");
    if (self.zhenlongLoginView) then
        self.zhenlongLoginView.panelMain:show();
    end
	ViewBase.onClose(self);
    
    
end

return ZhenlongRegisterView;