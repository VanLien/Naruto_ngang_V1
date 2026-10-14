-- chunkname: @src.app.sdk.yidun

local yidun = {}

function yidun.setRoleInfo()
	local roleId = stringz.bintohex(gGameModel.role:read("id"))
	local accountId = stringz.bintohex(gGameModel.role:read("account_id"))
	local tmp = {
		roleId = roleId,
		roleName = gGameModel.role:read("name"),
		roleAccount = accountId,
		roleServer = gGameApp.serverInfo.name,
		serverId = tostring(gGameModel.role:read("area"))
	}

	sdk.callPlatformFunc("setRoleInfoYD", json.encode(tmp), function(info)
		print("yidun.setRoleInfoYD ret = ", info)
	end)
end

function yidun.getToken(cb)
	sdk.callPlatformFunc("getTokenYD", "", function(info)
		yidun.token = info

		if info == "error" then
			cb("")
		else
			cb(info)
		end
	end)
end

function yidun.getTokenAsync(cb)
	sdk.callPlatformFunc("getTokenAsyncYD", "", function(info)
		print("yidun.getTokenAsyncYD ret = ", info)

		if info == "error" then
			cb("")
		else
			cb(info)
		end
	end)
end

function yidun.ioctl(_request, _data, cb)
	local tmp = {
		request = _request,
		data = _data
	}

	sdk.callPlatformFunc("ioctlYD", json.encode(tmp), function(info)
		print("yidun.ioctlYD ret = ", info)

		if info == "error" then
			print("查询失败")
		else
			cb(info)
		end
	end)
end

function yidun.safeCommToServer(data, cb)
	sdk.callPlatformFunc("safeCommToServerYD", data, function(info)
		print("yidun.safeCommToServerYD ret = ", info)
		cb(info)
	end)
end

function yidun.safeCommToServerByte(data, cb)
	sdk.callPlatformFunc("safeCommToServerByteYD", data, function(info)
		print("yidun.safeCommToServerByteYD ret = ", info)
		cb(info)
	end)
end

function yidun.safeCommFromServer(data, cb)
	sdk.callPlatformFunc("safeCommFromServerYD", data, function(info)
		print("yidun.safeCommFromServerYD ret = ", info)
		cb(info)
	end)
end

function yidun.safeCommFromServerByte(data, cb)
	sdk.callPlatformFunc("safeCommFromServerByteYD", data, function(info)
		print("yidun.safeCommFromServerByteYD ret = ", info)
		cb(info)
	end)
end

function yidun.localSaveEncode(data, cb)
	sdk.callPlatformFunc("localSaveEncodeYD", data, function(info)
		print("yidun.localSaveEncodeYD ret = ", info)
		cb(info)
	end)
end

function yidun.localSaveDecode(data, cb)
	sdk.callPlatformFunc("localSaveDecodeYD", data, function(info)
		print("yidun.localSaveDecodeYD ret = ", info)
		cb(info)
	end)
end

function yidun.localSaveBytesEncode(data, cb)
	sdk.callPlatformFunc("localSaveBytesEncodeYD", data, function(info)
		print("yidun.localSaveBytesEncodeYD ret = ", info)
		cb(info)
	end)
end

function yidun.localSaveBytesDecode(data, cb)
	sdk.callPlatformFunc("localSaveBytesDecodeYD", data, function(info)
		print("yidun.localSaveBytesDecodeYD ret = ", info)
		cb(info)
	end)
end

function yidun.track()
	sdk.callPlatformFunc("trackYD", "", function(info)
		print("yidun.trackYD ret = ", info)
	end)
end

function yidun.registerTouchEvent()
	sdk.callPlatformFunc("registerTouchEventYD", "", function(info)
		print("yidun.registerTouchEventYD ret = ", info)
	end)
end

function yidun.unregisterTouchEvent()
	sdk.callPlatformFunc("unregisterTouchEventYD", "", function(info)
		print("yidun.unregisterTouchEventYD ret = ", info)
	end)
end

return yidun
