
local lh = {}

function lh.login(cb)
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

function lh.commitRoleInfo(ctype, cb)

	local skey = string.split(gGameApp.serverInfo.key,'.')
	local sid = tonumber(skey[#skey])

  local tmp = {
		ctype = ctype,
		serverName = gGameApp.serverInfo.name,
		serverId = sid,
		roleId = tostring(gGameModel.role:read("uid")),
		roleName = gGameModel.role:read("name"),
		roleLevel = gGameModel.role:read("level"),
		power = gGameModel.role:read("battle_fighting_point"),
		vip = gGameModel.role:read("vip_level"),
		payTotal = gGameModel.role:getIdler("vip_sum"):read(),
		remainCoinNum = gGameModel.role:getIdler("rmb"):read(),
		roleCreateTime = math.round(gGameModel.role:read("created_time")),
	}

	sdk.callPlatformFunc("commitRoleInfo", json.encode(tmp), function(info)
		print("commitRoleInfo ret = ", info)
		-- 没有返回值，不管成功失败
		cb(0, "ok")
	end)
end

function lh.trackEvent(ctype, data)
    if type(data) ~= "table" then
		data = {data = data}
	end
	data.ctype = ctype
	sdk.callPlatformFunc("trackEvent", json.encode(data), function(info)
		print("trackEvent ret = ", info)
	end)
end

function lh.logout(cb)
    sdk.callPlatformFunc("logout", "game", function(info)
		print("logout ret = ", info)
		-- 有回调就是成功
		cb(0, "ok")
	end)
end

function lh.pay(cpOrderId, extInfo, amount, rechargeId, productDesc, cb)
    
	local roleInfo = gGameModel.role

	local tmp = {
		extension = extInfo,
		orderId = cpOrderId,
		partyName = "",
		per_price = amount,
		productDesc = productDesc,
		productId = rechargeId,
		productName = productDesc,
		remainCoinNum = gGameModel.role:getIdler("rmb"):read(),
		roleId = tostring(roleInfo:read("uid")),
		roleLevel = roleInfo:read("level"),
		roleName = roleInfo:read("name"),
		serverName = gGameApp.serverInfo.name,
		totalPrice = amount,
		vip = tostring(roleInfo:read("vip_level"))
	}

	sdk.callPlatformFunc("pay", json.encode(tmp), function(info)
		print("pay ret = ", info)
		if info == "ok" then
			cb(0, info)
		else
			cb(-1, "error")
		end
	end)
end

return lh
