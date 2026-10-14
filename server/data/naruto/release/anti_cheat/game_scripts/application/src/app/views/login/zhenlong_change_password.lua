local ViewBase = cc.load("mvc").ViewBase
local ZhenlongChangePasswordView = class("ZhenlongChangePasswordView", Dialog);
ZhenlongChangePasswordView.RESOURCE_FILENAME = "zhenlong_change_password_new.json";

local TAG = "ZhenlongChangePasswordView";
local TLOG = function(...)
    print("====== BEGIN TLOG:",TAG,"======")
    print(...);
	print("====== END TLOG:",TAG,"======")
end
ZhenlongChangePasswordView.RESOURCE_BINDING = {
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
	["panelMain.panelPasswordOld"] = "panelPasswordOld",
	["panelMain.panelPasswordNew"] = "panelPasswordNew",
    ["panelMain.panelPasswordNewConfirm"] = "panelPasswordNewConfirm",
	

    ["panelMain.panelUserName.imgUserName"] = "imgUserName",
	["panelMain.panelPasswordOld.imgPasswordOld"] = "imgPasswordOld",
	["panelMain.panelPasswordNew.imgPasswordNew"] = "imgPasswordNew",
	["panelMain.panelPasswordNewConfirm.imgPasswordNewConfirm"] = "imgPasswordNewConfirm",
	

	["panelMain.panelUserName.txtUserName"] = "txtUserName",
	["panelMain.panelPasswordOld.txtPasswordOld"] = "txtPasswordOld",
	["panelMain.panelPasswordNew.txtPasswordNew"] = "txtPasswordNew",
	["panelMain.panelPasswordNewConfirm.txtPasswordNewConfirm"] = "txtPasswordNewConfirm",
	

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
function ZhenlongChangePasswordView:onCreate()
	TLOG("onCreate");
    
    self.txtUserName:setCursorEnabled(true);
	self.txtPasswordOld:setCursorEnabled(true);
	self.txtPasswordNew:setCursorEnabled(true);
    self.txtPasswordNewConfirm:setCursorEnabled(true);
    

    
end
function ZhenlongChangePasswordView:showDialog(szTitle,szContent,callback)
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
function ZhenlongChangePasswordView:showTip(szTip)
    gGameUI:showTip(szTip);
end
function ZhenlongChangePasswordView:onConfirmClick()
    TLOG("onConfirmClick");
    self:doChangePassword(
        function (bRet, szMsg)
            if (bRet) then
                local userName = string.trim(self.txtUserName:getString() or "");    
                local passwordNew = string.trim(self.txtPasswordNew:getString() or "");        
               

                local szTitle = "Đổi mật khẩu thành công";
                local szContent = string.format("Mật khẩu mới tài khoản [%s] đã được hệ thống cập nhật",userName);
                self:showDialog(szTitle,szContent,function ()
                    if (self.zhenlongLoginView) then
                        self.zhenlongLoginView.txtUserName:setText(userName);
                        self.zhenlongLoginView.txtPassword:setText(passwordNew);
                    end
                    self:onClose();
                end);       
            else
                if (string.trim(szMsg or "") ~= "") then
                    self:showDialog("Đổi mật khẩu thất bại",szMsg);
                end        
            end
        end
    );
    
end
function ZhenlongChangePasswordView:doChangePassword(callback)
    TLOG("doChangePassword");

   
    local userName = string.trim(self.txtUserName:getString() or "");    
    local passwordOld = string.trim(self.txtPasswordOld:getString() or "");
    local passwordNew = string.trim(self.txtPasswordNew:getString() or "");
    local passwordNewConfirm = string.trim(self.txtPasswordNewConfirm:getString() or "");
    
   
    TLOG("userName:",userName,"passwordOld:",passwordOld,"passwordNew:",passwordNew,"passwordNewConfirm:",passwordNewConfirm);
    
    if (userName == "") then
        callback(false,"Tên tài khoản yêu cầu nhập")
        return
        
    end
    if (passwordOld == "") then
        callback(false,"Mật khẩu cũ yêu cầu nhập")
        return
        
    end

    if (passwordNew == "") then
        callback(false,"Mật khẩu mới yêu cầu nhập")
        return
        
    end


    if (passwordNew ~= passwordNewConfirm) then
        callback(false,"Xác nhận mật khẩu mới không khớp")
        return
        
    end
    local params = string.format("name=%s&password=%s&newpassword=%s&",userName,passwordOld,passwordNew);
    print("param", params)
    gGameApp.net:sendHttpRequest("POST", CHANGE_ACCOUNT_CFG, params,
        cc.XMLHTTPREQUEST_RESPONSE_STRING, function(xhr)
         
            
            local res = json.decode(xhr.response)
            if xhr.status == 200 then
               --res.message = base64.decode(res.message);
                if (res.code == 0) then
                    --return true,"Đăng ký tài khoản thành công";
                    --self.doRegister(callback(true,"Đăng ký tài khoản thành công"))
                    TLOG(res.code)
                   callback(true,"Đổi mật khẩu thành công")
                elseif (res.code == -400) then
                        --return false,"Tài khoản này đã tồn tại";
                        --self.doRegister(callback(false,"Tài khoản này đã tồn tại"))
                        callback(false,"Tài khoản hoặc mật khẩu không chính xác")
                elseif (res.code == -100) then
                    --self.doRegister(callback(false,"Vui lòng nhập đầy đủ chính xác thông tin"))
                    --return false,"Vui lòng nhập đầy đủ chính xác thông tin";
                    local szContent = [[
                        Thông tin tài khoản không chính xác, không thể đổi mật khẩu
                        1. Tài khoản không được chứa kí tự đặc biệt.
                        2. Tài khoản từ [4-16][a-Z] kí tự.
                       
                    ]]
                    callback(false,szContent)                 
                end
            else
                --self.doRegister(callback(false,"Có lỗi xảy ra, vui lòng đăng kí lại bạn nhé"))
                --return false,"Có lỗi xảy ra, vui lòng đăng kí lại bạn nhé";
                TLOG(res.code)
                callback(false,"Có lỗi xảy ra, vui lòng thử lại bạn nhé")
            end
        end)
    -- TODO: API CALL REGISTER (userName,passwordOld,passwordNew,passwordNewConfirm)
       -- return true,"Đổi mật khẩu thành công";
    --------------------------------------------------------------------
end
function ZhenlongChangePasswordView:onCancelClick()
    TLOG("onCancleClick");   
    self:onClose();   
end
function ZhenlongChangePasswordView:openForZhenlongLoginView(zhenlongLoginView)
    self.zhenlongLoginView = zhenlongLoginView;
    if (self.zhenlongLoginView) then
        self.txtUserName:setText(string.trim(self.zhenlongLoginView.txtUserName:getString() or ""));
        self.zhenlongLoginView.panelMain:hide();
    end
    TLOG(zhenlongLoginView);
end


-- @overide
function ZhenlongChangePasswordView:onClose()
	TLOG("onClose");
    if (self.zhenlongLoginView) then
        self.zhenlongLoginView.panelMain:show();
    end
	ViewBase.onClose(self);
    
    
end

return ZhenlongChangePasswordView;
