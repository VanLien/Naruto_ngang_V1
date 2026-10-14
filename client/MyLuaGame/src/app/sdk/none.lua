--
-- Copyright (c) 2014 YouMi Information Technology Inc.
-- Copyright (c) 2017 TianJi Information Technology Inc.
--
-- 裸包
-- 裸包相关代码放在这
--

local ButtonNormal = "img/editor/btn_1.png"
local ButtonClick = "img/editor/btn.png"

local none = {}

function none.commitRoleInfo(ctype, cb)
	return cb()
end

function none._payOnline(cpOrderId, extInfo, amount, rechargeId, productDesc, cb)
	local paykey = "Poke123"
	local accountId = stringz.bintohex(gGameModel.role:read("account_id"))
	local params = string.format("accountId=%s&orderStatus=1&orderId=%s&amount=%.2f&game_extra=%s",
		accountId, cpOrderId, amount, extInfo)

	gGameApp.net:sendHttpRequest("POST", "http://180.93.98.5:28081/tjgame/create",
		params,
		cc.XMLHTTPREQUEST_RESPONSE_STRING,
		function(xhr)
			if xhr.status == 200 then
				local codeJson = json.decode(xhr.response)
				if #codeJson.content ~= 8 then
					return
				end

				params = params .. string.format("&code=%s", codeJson.content)
				gGameApp.net:sendHttpRequest("POST", "http://180.93.98.5:28081/tjgame/payment",
					params,
					cc.XMLHTTPREQUEST_RESPONSE_STRING,
					function(xhr)
						if xhr.status == 200 then
							gGameUI:showTip("Pay OK Client"..codeJson.content)
							cb(0)
						else
							print('POST none.pay order Error', APP_CHANNEL, xhr.status, xhr.statusText)
							cb(-1)
						end
					end
				)

			else
				print('POST none.create order Error', APP_CHANNEL, xhr.status, xhr.statusText)
				cb(-1)
			end
		end
	)
end

function none.pay(cpOrderId, extInfo, amount, rechargeId, productDesc, cb)

	--local daibi = gGameModel.role:read("daibi")
	--if (daibi * 300) >= amount then
---		return none._payOnline(cpOrderId, extInfo, amount, rechargeId, productDesc, cb)
	--end

	local strEx1 = string.gsub(extInfo, "%[", "")
	strEx1 = string.gsub(strEx1, "%]", "")
	strEx1 = string.gsub(strEx1, "\"", "")

	local strEx2 = string.split(strEx1, ",")
	local strEx3 = {}
	for i, v in ipairs(strEx2) do
		table.insert(strEx3, v)
	end

	local accountId = stringz.bintohex(gGameModel.role:read("account_id"))
	local paykey = "Poke@123"
	local payparram = string.format("accountId=%s&orderStatus=1&orderId=%s&amount=%.2f&game_extra=%s",
	accountId, cpOrderId, amount, extInfo)
	local params = string.format("accountId=%s&paykey=%s&orderid=%s&amount=%.2f&product=%s&d=%s&e=%s&f=%s&g=%s&h=%s&i=%s&game_extra=%s",
	accountId,paykey,cpOrderId, amount, productDesc,
		strEx3[1], strEx3[2], strEx3[3], strEx3[4], strEx3[5], strEx3[6],extInfo)

	print(payparram)
	local APIPAY = "http://180.93.98.5/"
	local url = APIPAY.."gameAPI/pay.php"
	gGameUI:showDialog({title = "Chú ý", content = "#C0x5b545b#Bạn có mua gói "..productDesc.." này?", fontSize = 60, cb = function()
		gGameApp.net:sendHttpRequest("POST", url,
		params,
		cc.XMLHTTPREQUEST_RESPONSE_STRING,
		function(xhr)
			print("-------xhr.status:", xhr.status)
			print("----------xhr.response:", xhr.response)
			if xhr.status == 200 then
				local codeJson = json.decode(xhr.response)
				if codeJson.code == 1 then
					gGameUI:showDialog({title = "Chú ý", content = "#C0x5b545b#Tài khoản không đủ XU để thanh toán.", fontSize = 60, cb = function()
						cc.Application:getInstance():openURL(APIGame)
						cb(-1)
					end, btnType = 2, btnStr = gLanguageCsv.showVip, isRich = true, clearFast = true, dialogParams = {clickClose = false}})
				end
				if codeJson.code == 2 then
					gGameUI:showTip("Bạn thao tác quá nhanh, vui lòng thử lại sau 5 giây")
					cb(-1)
				end
				if codeJson.code == 3 then
					gGameUI:showTip("Lỗi không xác định ,liên hê GM , xu chưa bị trừ")
					cb(-1)
				end
				if codeJson.code == 0 then
					gGameUI:showTip("Thanh toán thành công")
					cb(0)
				end
			else
				gGameUI:showTip("Lỗi bất thường, vui lòng thử lại")
				print('POST none.pay order Error', APP_CHANNEL, xhr.status, xhr.statusText)
				cb(-1)
			end
		end
	)				
		
	end, btnType = 2, btnStr = gLanguageCsv.showVip, isRich = true, clearFast = true, dialogParams = {clickClose = false}})	
end

function none.logout(cb)
	return cb()
end

-- TEST: 实名认证
-- function none.login(cb)
-- 	print('!!! none.login')
-- 	sdk.getUserTypeAndIdentity()
-- 	return cb()
-- end

-- function none.queryIdentity(cb)
-- 	print('!!! none.queryIdentity')
-- 	return cb(1)
-- end

-- function none.queryUserType(cb)
-- 	print('!!! none.queryUserType')
-- 	return cb(1)
-- end

return none