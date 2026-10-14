local ViewBase = cc.load("mvc").ViewBase
local ZhenlongForgotPasswordView = class("ZhenlongForgotPasswordView", Dialog);
ZhenlongForgotPasswordView.RESOURCE_FILENAME = "zhenlong_forgot_password_new.json";

local TAG = "ZhenlongForgotPasswordView";
local TLOG = function(...)
    print("====== BEGIN TLOG:",TAG,"======")
    print(...);
	print("====== END TLOG:",TAG,"======")
end
ZhenlongForgotPasswordView.RESOURCE_BINDING = {
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
    ["panelMain.panelPassword.imgUserName"] = "imgUserName",
    ["panelMain.panelUserName.txtUserName"] = "txtUserName",

	["panelMain.panelEmail"] = "panelEmail",   
	["panelMain.panelEmail.imgEmail"] = "imgEmail",	
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
function ZhenlongForgotPasswordView:onCreate()
	TLOG("onCreate");
    
    self.txtUserName:setCursorEnabled(true);
    self.txtEmail:setCursorEnabled(true);

    self.lblNotice:setText("1. Xác nhận email hiện hành của tài khoản\n2. Nhấn xác nhận để hệ thống kiểm tra\n3. Nếu thông tin hợp lệ, hệ thống sẽ gửi một email thông tin đăng nhập đến địa chỉ email hiện hành.")
end
function ZhenlongForgotPasswordView:showDialog(szTitle,szContent,callback)
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
function ZhenlongForgotPasswordView:showTip(szTip)
    gGameUI:showTip(szTip);
end
function ZhenlongForgotPasswordView:onConfirmClick()
    TLOG("onConfirmClick");
    self:doGetPassword(
        function (bRet, szMsg) 
            if (bRet) then
                local userName = string.trim(self.txtUserName:getString() or "");    
                local email = string.trim(self.txtEmail:getString() or "");

                local szTitle = "Lấy lại mật khẩu thành công";
                local szContent = string.format("Yêu cầu lấy lại mật khẩu tài khoản [%s] thành công. HỖ TRỢ LÀNG LÁ đã gửi mail thông tin đăng nhập đến [%s]",userName,email);
                self:showDialog(szTitle,szContent,function ()
                    if (self.zhenlongLoginView) then
                        self.zhenlongLoginView.txtUserName:setText(userName);
                        self.zhenlongLoginView.txtPassword:setText("");
                    end
                    self:onClose();
                end);       
            else
                if (string.trim(szMsg or "") ~= "") then
                    self:showDialog("Lấy lại mật khẩu thất bại",szMsg);
                end        
            end 
        end

    );
   
end
function ZhenlongForgotPasswordView:doGetPassword(callback)
    TLOG("doGetPassword");

   
    local userName = string.trim(self.txtUserName:getString() or "");    
    local email = string.trim(self.txtEmail:getString() or "");
   
    TLOG("userName:",userName,"email:",email)
    
    if (userName == "") then
        callback( false,"Tên tài khoản yêu cầu nhập");
        return
        
    end
    if (email == "") then
        callback( false,"Email yêu cầu nhập");
        return
    end
    local params = string.format("name=%s&email=%s&",userName,email);
    print("param", params)
    gGameApp.net:sendHttpRequest("POST",FORGOT_ACCOUNT_CFG, params,
        cc.XMLHTTPREQUEST_RESPONSE_STRING, function(xhr)
        
            if xhr.status == 200 then
                local res = json.decode(xhr.response)
               --res.message = base64.decode(res.message);
                if (res.code == 0) then
                    --return true,"Đăng ký tài khoản thành công";
                    --self.doRegister(callback(true,"Đăng ký tài khoản thành công"))
                    TLOG(res.code)
                   callback(true,"Vui lòng kiểm tra hộp thư để lấy mã code")
                elseif (res.code == -400) then
                        --return false,"Tài khoản này đã tồn tại";
                        --self.doRegister(callback(false,"Tài khoản này đã tồn tại"))
                        callback(false,"Tài khoản hoặc email không chính xác")
                elseif (res.code == -444) then
                    callback(false,"Mật khẩu mới của bạn là "..res.message)
                elseif (res.code == -333) then
                    callback(false,"Mỗi ngày chỉ sử dụng được tính năng quên mật khẩu một lần!")
                elseif (res.code == -222) then
                    callback(false,"Đã có lỗi xảy ra, vui lòng thử lại bạn nhé!")
                elseif (res.code == -111) then
                    callback(false,"Không thể gửi email, vui lòng liên hệ admin trên fanpage bạn nhé")
                elseif (res.code == -100) then
                    --self.doRegister(callback(false,"Vui lòng nhập đầy đủ chính xác thông tin"))
                    --return false,"Vui lòng nhập đầy đủ chính xác thông tin";
                    local szContent = [[
                        Thông tin tài khoản không chính xác, không thể lấy lại mật khẩu
                        1. Tài khoản không được chứa kí tự đặc biệt.
                        2. Tài khoản từ [4-16][a-Z] kí tự.
                        3. Email phải đúng định dạng.
                    ]]
                    callback(false,szContent)                 
                end
            else
                --self.doRegister(callback(false,"Có lỗi xảy ra, vui lòng đăng kí lại bạn nhé"))
                --return false,"Có lỗi xảy ra, vui lòng đăng kí lại bạn nhé";        
                callback(false,"Có lỗi xảy ra, vui lòng thử lại bạn nhé")
            end
        end)
    -- TODO: API CALL GET PASSWORD (userName,email)
        --return true,"Lấy lại mật khẩu thành công";
    --------------------------------------------------------------------
end
function ZhenlongForgotPasswordView:onCancelClick()
    TLOG("onCancleClick");   
    self:onClose();   
end
function ZhenlongForgotPasswordView:openForZhenlongLoginView(zhenlongLoginView)
    self.zhenlongLoginView = zhenlongLoginView;
    if (self.zhenlongLoginView) then
        self.txtUserName:setText(string.trim(self.zhenlongLoginView.txtUserName:getString() or ""));
        self.zhenlongLoginView.panelMain:hide();
    end
    TLOG(zhenlongLoginView);
end


-- @overide
function ZhenlongForgotPasswordView:onClose()
	TLOG("onClose");
    if (self.zhenlongLoginView) then
        self.zhenlongLoginView.panelMain:show();
    end
	ViewBase.onClose(self);
    
    
end

return ZhenlongForgotPasswordView;