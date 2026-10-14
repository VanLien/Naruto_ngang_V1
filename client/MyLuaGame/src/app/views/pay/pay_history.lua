local var_0_0 = PayHistory or {}
local var_0_1
local var_0_2 = "PayHistory"

local function var_0_3(arg_1_0)
	print(var_0_2, arg_1_0, "TLOG")
end

function var_0_0.getMe(arg_2_0)
	if not var_0_1 then
		var_0_1 = arg_2_0:ctor()
	end

	return var_0_1
end

function var_0_0.ctor(arg_3_0)
	arg_3_0:Init()

	return arg_3_0
end

function var_0_0.Init(arg_4_0)
	arg_4_0.currentUser = ""
	arg_4_0.Data = {}
	arg_4_0.Money = 0
end

function var_0_0.PostInformation(arg_5_0)
	print("PayHistory PostInformation")
end

function var_0_0.setCurrentUser(arg_6_0, arg_6_1)
	arg_6_0.currentUser = arg_6_1
end

function var_0_0.SyncData(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0.currentUser = arg_7_1

	if arg_7_0.currentUser == nil or arg_7_0.currentUser == "" then
		return
	end

	local var_7_0 = string.format("account=%s&", arg_7_0.currentUser)

	print("param", var_7_0)
	gGameApp.net:sendHttpRequest("POST", CARD_HISTORY_CFG, var_7_0, cc.XMLHTTPREQUEST_RESPONSE_STRING, function(arg_8_0)
		if arg_8_0.status == 200 then
			local var_8_0 = json.decode(arg_8_0.response)

			if var_8_0.code == 0 then
				print("request okay")

				arg_7_0.Data = var_8_0.message
				arg_7_0.Money = var_8_0.money

				if arg_7_2 ~= nil then
					arg_7_2(true, var_8_0.message, var_8_0.money)
				end
			else
				print("request okay but not true response")

				arg_7_0.Data = {}

				if arg_7_2 ~= nil then
					arg_7_2(false, {}, 0)
				end
			end
		else
			print("request not okay")

			arg_7_0.Data = {}

			if arg_7_2 ~= nil then
				arg_7_2(false, {}, 0)
			end
		end
	end)
end

function var_0_0.GetHistory(arg_9_0)
	return arg_9_0.Data, arg_9_0.Money
end

return var_0_0
