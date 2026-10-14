local var_0_0 = {}
local var_0_1 = require("3rd.msgpack")
local var_0_2 = var_0_1.pack
local var_0_3 = var_0_1.unpack
local var_0_4 = "http://192.168.1.96:4455"
local var_0_5 = {
	level = 60,
	advance = 5,
	star = 10,
	card_id = 11
}

local function var_0_6(arg_1_0)
	local var_1_0 = io.open(arg_1_0, "rb")
	local var_1_1 = var_1_0:read("*a")

	var_1_0:close()

	return var_0_3(var_1_1)
end

local function var_0_7(arg_2_0)
	local var_2_0 = {}

	for iter_2_0, iter_2_1 in pairs(arg_2_0) do
		local var_2_1 = false
		local var_2_2 = {}

		if type(iter_2_1) == "table" then
			for iter_2_2, iter_2_3 in pairs(iter_2_1) do
				if iter_2_2 == "__raw" then
					var_2_1 = true

					for iter_2_4, iter_2_5 in pairs(iter_2_3) do
						if type(iter_2_5) == "table" then
							var_2_2[iter_2_4] = var_0_7(iter_2_5)
						else
							var_2_2[iter_2_4] = iter_2_5
						end
					end
				end
			end
		end

		if not var_2_1 then
			var_2_0[iter_2_0] = iter_2_1
		else
			var_2_0[iter_2_0] = var_2_2
		end
	end

	print("###########")
	print_r(var_2_0)

	return var_2_0
end

function var_0_0.requestFight(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0.arenaData or var_0_6("arena_qiangdu.play")
	local var_3_1 = var_0_3(var_3_0[2])

	var_3_1.cards = {}
	var_3_1.card_attrs = {}
	var_3_1.defence_cards = {}
	var_3_1.defence_card_attrs = {}
	var_3_1.rand_seed = math.random(1, 1000000)

	for iter_3_0 = 1, 6 do
		local var_3_2 = arg_3_1[iter_3_0].id

		var_3_1.cards[iter_3_0] = var_3_2
		var_3_1.card_attrs[var_3_2] = arg_3_1[iter_3_0]
	end

	for iter_3_1 = 1, 6 do
		local var_3_3 = arg_3_1[iter_3_1 + 6].id

		var_3_1.defence_cards[iter_3_1] = var_3_3
		var_3_1.defence_card_attrs[var_3_3] = arg_3_1[iter_3_1 + 6]
	end

	var_3_0[2] = var_0_2(var_3_1)

	var_0_0.sendHttpRequest(arg_3_0, "POST", var_0_4 .. "/send_to_agent", var_0_2(var_3_0), cc.XMLHTTPREQUEST_RESPONSE_JSON, function(arg_4_0)
		if arg_4_0.status == 200 then
			local var_4_0 = json.decode(arg_4_0.response)

			return arg_3_3({
				ret = true
			}, var_4_0, arg_3_1, arg_3_2)
		end

		return arg_3_3({
			ret = false
		}, nil, arg_3_1, arg_3_2)
	end)
end

function var_0_0.requestFightSolo(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_0.craftData or var_0_6("craft_qiangdu.play")
	local var_5_1 = var_0_3(var_5_0[2])

	var_5_1.cards = {}
	var_5_1.card_attrs = {}
	var_5_1.defence_cards = {}
	var_5_1.defence_card_attrs = {}
	var_5_1.rand_seed = math.random(1, 1000000)

	for iter_5_0 = 1, 3 do
		local var_5_2 = arg_5_1[1].id

		var_5_1.cards[iter_5_0] = var_5_2
		var_5_1.card_attrs[var_5_2] = arg_5_1[1]
	end

	for iter_5_1 = 1, 3 do
		local var_5_3 = arg_5_1[7].id

		var_5_1.defence_cards[iter_5_1] = var_5_3
		var_5_1.defence_card_attrs[var_5_3] = arg_5_1[7]
	end

	var_5_0[2] = var_0_2(var_5_1)

	var_0_0.sendHttpRequest(arg_5_0, "POST", var_0_4 .. "/send_to_agent", var_0_2(var_5_0), cc.XMLHTTPREQUEST_RESPONSE_JSON, function(arg_6_0)
		if arg_6_0.status == 200 then
			local var_6_0 = json.decode(arg_6_0.response)

			return arg_5_3({
				ret = true
			}, var_6_0, arg_5_1, arg_5_2)
		end

		return arg_5_3({
			ret = false
		}, nil, arg_5_1, arg_5_2)
	end)
end

function var_0_0.fillDataTb(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = {
		"left_front",
		"left_back",
		"right_front",
		"right_back"
	}

	for iter_7_0, iter_7_1 in ipairs(var_7_0) do
		local var_7_1 = arg_7_1[iter_7_1 .. "_tb"]

		arg_7_2[iter_7_1 .. "_tb"] = {}

		for iter_7_2 = 1, #var_7_1 do
			var_0_0.requestCardData(arg_7_0, var_7_1[iter_7_2], function(arg_8_0, arg_8_1)
				arg_7_2[iter_7_1 .. "_tb"][iter_7_2] = arg_8_1
			end)
		end
	end
end

function var_0_0.requestCardData(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = {
		card_id = arg_9_1.cardID,
		advance = arg_9_1.advance,
		star = arg_9_1.star,
		level = arg_9_1.level
	}

	var_0_0.sendHttpRequest(arg_9_0, "POST", var_0_4 .. "/calc_card", var_0_2(var_9_0), cc.XMLHTTPREQUEST_RESPONSE_JSON, function(arg_10_0)
		if arg_10_0.status == 200 then
			local var_10_0 = var_0_3(arg_10_0.response)

			return arg_9_2({
				ret = true
			}, var_10_0)
		end

		return arg_9_2({
			ret = false
		}, nil)
	end)
end

function var_0_0.loadFiles(arg_11_0)
	arg_11_0.arenaData = var_0_6(".\\src\\app\\views\\city\\test\\arena_qiangdu.play")
	arg_11_0.craftData = var_0_6(".\\src\\app\\views\\city\\test\\craft_qiangdu.play")
end

function var_0_0.sendHttpRequest(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	local var_12_0 = cc.XMLHttpRequest:new()

	var_12_0.responseType = arg_12_4
	var_12_0.timeout = 20

	var_12_0:open(arg_12_1, arg_12_2)

	if arg_12_1 == "GET" then
		var_12_0:setRequestHeader("Accept-Encoding", "gzip")
	end

	local function var_12_1(...)
		if string.match(var_12_0:getAllResponseHeaders(), "Content%-Encoding:%s*(gzip)") == "gzip" then
			var_12_0.responseType = cc.XMLHTTPREQUEST_RESPONSE_BLOB
			var_12_0.response = zuncompress(var_12_0.response)
		end

		arg_12_5(var_12_0)
	end

	if arg_12_5 then
		var_12_0:registerScriptHandler(var_12_1)
	end

	if arg_12_3 then
		var_12_0:send(arg_12_3)
	else
		var_12_0:send()
	end
end

return var_0_0
