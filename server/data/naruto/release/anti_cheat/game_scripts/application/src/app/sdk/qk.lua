
local qk = {}

function qk.login(cb)
    sdk.callPlatformFunc("login", "", function(info)
		print("login ret = ", info)
		sdk.loginInfo = info
		if info == "error" then
			cb(-1, info)
		elseif info == "cancel" then
			cb(-1, info)
		else
			cb(0, info)
			-- 漂浮球退出监听
			sdk.callPlatformFunc("logout", "assist", function(info)
				print("logout in assist ret = ", info)
				-- 内部保证多次调用无误
				gGameApp:onBackLogin()
			end)
		end
	end)
end

function qk.commitRoleInfo(ctype, cb)
    local tmp = {
		ctype = ctype,
		area_id = tostring(gGameModel.role:read("area")),
		area = gGameApp.serverInfo.name,
		level = tostring(gGameModel.role:read("level")),
		user_name = gGameModel.role:read("name"),
		user_id = tostring(gGameModel.role:read("uid")),
		vip = tostring(gGameModel.role:read("vip_level")),
		created_time = tostring(gGameModel.role:read("created_time")),
	}
	if tmp.upload_type == nil then
		return cb(0, "ok")
	end

	sdk.callPlatformFunc("commitRoleInfo", json.encode(tmp), function(info)
		print("commitRoleInfo ret = ", info)
		-- 没有返回值，不管成功失败
		cb(0, "ok")
	end)
end

function qk.trackEvent(ctype, data)
    if type(data) ~= "table" then
		data = {data = data}
	end
	data.ctype = ctype
	sdk.callPlatformFunc("trackEvent", json.encode(data), function(info)
		print("trackEvent ret = ", info)
	end)
end

function qk.logout(cb)
    sdk.callPlatformFunc("logout", "game", function(info)
		print("logout ret = ", info)
		-- 有回调就是成功
		cb(0, "ok")
	end)
end

function qk.pay(cpOrderId, extInfo, amount, rechargeId, productDesc, cb)
    
	local roleInfo = gGameModel.role


end

return qk
