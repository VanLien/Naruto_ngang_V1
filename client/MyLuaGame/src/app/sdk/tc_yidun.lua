-- chunkname: @src.app.sdk.tc_yidun

local tc_yidun = require("app.sdk.tc")

function tc_yidun.setRoleInfo()
	local roleId = stringz.bintohex(gGameModel.role:read("id"))
	local accountId = stringz.bintohex(gGameModel.role:read("account_id"))
	local tmp = {
		roleId = roleId,
		roleName = gGameModel.role:read("name"),
		roleAccount = accountId,
		roleServer = gGameApp.serverInfo.name,
		serverId = tostring(gGameModel.role:read("area"))
	}

	sdk.callPlatformFunc("setRoleInfo", json.encode(tmp), function(info)
		print("setRoleInfo ret = ", info)
	end)
end

function tc_yidun.getToken(cb)
	sdk.callPlatformFunc("getToken", "", function(info)
		print("getToken ret = ", info)

		if info == "error" then
			print("获取易盾token 失败")
		else
			cb(info)
		end
	end)
end

function tc_yidun.getTokenAsync(cb)
	sdk.callPlatformFunc("getTokenAsync", "", function(info)
		print("getToken ret = ", info)

		if info == "error" then
			print("获取易盾token 失败")
		else
			cb(info)
		end
	end)
end

function tc_yidun.ioctl(_request, _data, cb)
	local tmp = {
		request = _request,
		data = _data
	}

	sdk.callPlatformFunc("ioctl", json.encode(tmp), function(info)
		print("getToken ret = ", info)

		if info == "error" then
			print("获取易盾token 失败")
		else
			cb(info)
		end
	end)
end

function tc_yidun.safeCommToServer(data, cb)
	sdk.callPlatformFunc("safeCommToServer", data, function(info)
		print("safeCommToServer ret = ", info)
		cb(info)
	end)
end

function tc_yidun.safeCommToServerByte(data, cb)
	sdk.callPlatformFunc("safeCommToServerByte", data, function(info)
		print("safeCommToServerByte ret = ", info)
		cb(info)
	end)
end

function tc_yidun.safeCommFromServer(data, cb)
	sdk.callPlatformFunc("safeCommFromServer", data, function(info)
		print("safeCommFromServer ret = ", info)
		cb(info)
	end)
end

function tc_yidun.safeCommFromServerByte(data, cb)
	sdk.callPlatformFunc("safeCommFromServerByte", data, function(info)
		print("safeCommFromServerByte ret = ", info)
		cb(info)
	end)
end

function tc_yidun.localSaveEncode(data, cb)
	sdk.callPlatformFunc("localSaveEncode", data, function(info)
		print("localSaveEncode ret = ", info)
		cb(info)
	end)
end

function tc_yidun.localSaveDecode(data, cb)
	sdk.callPlatformFunc("localSaveDecode", data, function(info)
		print("localSaveDecode ret = ", info)
		cb(info)
	end)
end

function tc_yidun.localSaveBytesEncode(data, cb)
	sdk.callPlatformFunc("localSaveBytesEncode", data, function(info)
		print("localSaveBytesEncode ret = ", info)
		cb(info)
	end)
end

function tc_yidun.localSaveBytesDecode(data, cb)
	sdk.callPlatformFunc("localSaveBytesDecode", data, function(info)
		print("localSaveBytesDecode ret = ", info)
		cb(info)
	end)
end

function tc_yidun.track()
	sdk.callPlatformFunc("track", "", function(info)
		print("track ret = ", info)
	end)
end

function tc_yidun.registerTouchEvent()
	sdk.callPlatformFunc("registerTouchEvent", "", function(info)
		print("registerTouchEvent ret = ", info)
	end)
end

function tc_yidun.unregisterTouchEvent()
	sdk.callPlatformFunc("unregisterTouchEvent", "", function(info)
		print("unregisterTouchEvent ret = ", info)
	end)
end

return tc_yidun
