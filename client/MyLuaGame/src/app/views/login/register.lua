-- @desc หน้าสมัครสมาชิก (Register)
-- ใช้ HTTP API register.php พร้อม MD5 password
-- สมัครสำเร็จ → callback กลับไป LoginView ให้ auto-login

if not string.trim then
	function string.trim(s)
		return (s:gsub("^%s*(.-)%s*$", "%1"))
	end
end

-- API URL สำหรับ register (ต้องตรงกับ login_view.lua)
local REGISTER_API_URL = "http://180.93.98.5/gameAPI/register.php"

local RegisterView = class("RegisterView", Dialog)

RegisterView.BTN_TYPE = BTN_TYPE
RegisterView.BTN_DATA = BTN_DATA

RegisterView.RESOURCE_FILENAME = "register.json"
RegisterView.RESOURCE_BINDING = {
	["bg"] = "bg",
	["titleBg"] = "titleBg",
	["title"] = "title",
	["top.txtAccount"] = "txtAccount",
	["middle.txtPassword"] = "txtPassword",
	["bottom.txtPasswordAgain"] = "txtPasswordAgain",
	["okbtn"] = {
		varname = "okBtn",
		binds = {
			event = "click",
			method = bindHelper.self("onBtnClick"),
		},
	},
	["cancelBtn"] = {
		varname = "cancelBtn",
		binds = {
			event = "click",
			method = bindHelper.self("onClose"),
		},
	},
}

function RegisterView:onCreate(cb)
	Dialog.onCreate(self, {clickClose = false})
	self.cb = cb
end

function RegisterView:onBtnClick()
	-- ======== ตรวจสอบ Account ========
	local userName = self.txtAccount:getString()
	userName = string.trim(userName)
	if userName == "" then
		gGameUI:showTip("Vui lòng nhập tài khoản")
		return
	end

	local userNameLen = string.len(userName)
	if userNameLen < 6 or userNameLen > 20 then
		gGameUI:showTip("Phải có độ dài từ 6 đến 20 ký tự")
		return
	end

	-- ======== ตรวจสอบ Password ========
	local userPsd = self.txtPassword:getString()
	userPsd = string.trim(userPsd)
	if userPsd == "" then
		gGameUI:showTip("Vui lòng nhập mật khẩu")
		return
	end

	local userPsdLen = string.len(userPsd)
	if userPsdLen < 6 or userPsdLen > 20 then
		gGameUI:showTip("Phải có độ dài từ 6 đến 20 ký tự")
		return
	end

	-- ======== ตรวจสอบ Confirm Password ========
	local userPsdAgain = self.txtPasswordAgain:getString()
	userPsdAgain = string.trim(userPsdAgain)

	if userPsdAgain ~= userPsd then
		gGameUI:showTip("Mật khẩu nhập lại không khớp")
		return
	end

	-- ======== ส่ง HTTP API Register ========
	gGameUI:showConnecting()

	require "3rd.MD5"
	local md5Password = md5(userPsd)

	local url = REGISTER_API_URL
	local finalparams = string.format("username=%s&password=%s", userName, md5Password)

	gGameApp.net:sendHttpRequest("POST", url,
		finalparams,
		cc.XMLHTTPREQUEST_RESPONSE_STRING,
		function(xhr)
			gGameUI:hideConnecting()

			if xhr.status == 200 then
				local response = xhr.response
				print("Register API response:", response)

				local ok, obj = pcall(json.decode, response)
				local isSuccess = ok and obj and (obj.status == "0" or obj.status == 0)
				print("Register isSuccess:", isSuccess)
				if isSuccess then
					gGameUI:showTip("Đăng ký thành công")
					if self.cb ~= nil then
						self.cb(self, userName, userPsd)
						self:onClose()
					end
				else
					local errMsg = (ok and obj and obj.msg) or "Đăng ký thất bại"
					gGameUI:showTip(errMsg)
				end
			else
				gGameUI:showTip("Lỗi kết nối với máy chủ")
			end
		end
	)
end

return RegisterView