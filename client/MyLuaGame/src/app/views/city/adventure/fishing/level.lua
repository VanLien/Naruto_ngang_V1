local var_0_0 = class("FishingLevelView", Dialog)

var_0_0.RESOURCE_FILENAME = "fishing_level.json"
var_0_0.RESOURCE_BINDING = {
	["right.now.attr.name"] = "attrName",
	["right.now.fish.name"] = "fishName",
	["left.item"] = "leftItem",
	["left.level"] = "level",
	["right.now.attr.subList"] = "subList",
	["right.now.fish.item"] = "fishItem",
	["right.now.attr.item"] = "attrItem",
	["left.nextLevel"] = "nextLevel",
	["left.level1"] = "level1",
	["right.now.text"] = "text",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["left.list"] = {
		varname = "leftList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("listDatas"),
				item = bindHelper.self("leftItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("name", "num", "bar")

					var_1_0.name:text(arg_1_3.name)
					var_1_0.num:text(arg_1_3.num .. "/" .. arg_1_3.maxNum)
					var_1_0.bar:percent(cc.clampf(100 * (arg_1_3.num / arg_1_3.maxNum), 0, 100))
				end
			}
		}
	},
	["right.now.fish.list"] = {
		varname = "fishList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("fishDatas"),
				item = bindHelper.self("fishItem"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("txt1", "num1")

					var_2_0.txt1:text(arg_2_3.name)

					if arg_2_2 == 1 then
						var_2_0.num1:text("-" .. arg_2_3.num * 100 .. "%")
					elseif arg_2_2 == 3 then
						var_2_0.num1:text("+" .. arg_2_3.num * 100 .. "%")
					else
						var_2_0.num1:text("+" .. arg_2_3.num * 100 .. "%")
					end

					adapt.oneLinePos(var_2_0.txt1, var_2_0.num1, cc.p(15, 0), "left")

					if not arg_2_3.isLock then
						text.addEffect(var_2_0.txt1, {
							color = cc.c4b(183, 176, 158, 255)
						})
						text.addEffect(var_2_0.num1, {
							color = cc.c4b(183, 176, 158, 255)
						})
					end
				end
			}
		}
	},
	["right.now.attr.list"] = {
		varname = "attrList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 2,
				data = bindHelper.self("attrDatas"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("attrItem"),
				onCell = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:multiget("txt1", "num1")

					var_3_0.txt1:text(arg_3_3.name .. ":")
					var_3_0.num1:text(arg_3_3.num)
					adapt.oneLinePos(var_3_0.txt1, var_3_0.num1, cc.p(20, 0), "left")

					if not arg_3_3.isLock then
						text.addEffect(var_3_0.txt1, {
							color = cc.c4b(183, 176, 158, 255)
						})
						text.addEffect(var_3_0.num1, {
							color = cc.c4b(183, 176, 158, 255)
						})
					end
				end
			}
		}
	},
	["right.btnUp"] = {
		varname = "btnUp",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnUp")
			}
		}
	},
	["right.btnNext"] = {
		varname = "btnNext",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnNext")
			}
		}
	}
}

function var_0_0.onCreate(arg_4_0)
	arg_4_0:initModel()

	arg_4_0.fishDatas = idlers.new({})
	arg_4_0.attrDatas = idlers.new({})
	arg_4_0.listDatas = idlers.new({})
	arg_4_0.clientLevel = idler.new(1)

	local var_4_0 = {
		"lowNum",
		"middleNum",
		"highNum",
		"totalNum",
		"targetNum"
	}

	idlereasy.any({
		arg_4_0.fishLevel,
		arg_4_0.fishCounter,
		arg_4_0.targetCounter
	}, function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		local var_5_0 = csv.fishing.level[arg_5_1]
		local var_5_1 = {}
		local var_5_2 = 0
		local var_5_3 = 0
		local var_5_4 = 0
		local var_5_5 = 0
		local var_5_6 = 0
		local var_5_7 = 0

		if arg_5_2 ~= nil then
			if arg_5_2[1] ~= nil then
				var_5_2 = arg_5_2[1] < var_5_0.lowNum and arg_5_2[1] or var_5_0.lowNum
				var_5_5 = arg_5_2[1]
			end

			if arg_5_2[2] ~= nil then
				var_5_3 = arg_5_2[2] < var_5_0.middleNum and arg_5_2[2] or var_5_0.middleNum
				var_5_6 = arg_5_2[2]
			end

			if arg_5_2[3] ~= nil then
				var_5_4 = arg_5_2[3] < var_5_0.highNum and arg_5_2[3] or var_5_0.highNum
				var_5_7 = arg_5_2[3]
			end
		end

		local var_5_8 = {
			gLanguageCsv.lowFishNum,
			gLanguageCsv.middleFishNum,
			gLanguageCsv.highFishNum,
			gLanguageCsv.totalFishNum,
			""
		}
		local var_5_9 = var_5_5 + var_5_6 + var_5_7

		if var_5_9 > var_5_0.totalNum then
			var_5_9 = var_5_0.totalNum
		end

		local var_5_10 = {
			var_5_2,
			var_5_3,
			var_5_4,
			var_5_9,
			arg_5_3
		}

		for iter_5_0, iter_5_1 in ipairs(var_4_0) do
			if iter_5_0 < 5 and var_5_0[iter_5_1] ~= 0 then
				table.insert(var_5_1, {
					name = var_5_8[iter_5_0],
					num = var_5_10[iter_5_0],
					maxNum = var_5_0[iter_5_1]
				})
			end

			if iter_5_0 == 5 and not itertools.isempty(var_5_0[iter_5_1]) then
				local var_5_11, var_5_12 = csvNext(var_5_0[iter_5_1])

				if var_5_11 ~= nil then
					local var_5_13 = csv.fishing.fish[var_5_11]
					local var_5_14 = string.format(gLanguageCsv.targetFishNum, var_5_12, var_5_13.name)

					table.insert(var_5_1, {
						name = var_5_14,
						num = var_5_10[iter_5_0],
						maxNum = var_5_12
					})
				end
			end
		end

		arg_4_0.listDatas:update(var_5_1)
		arg_4_0.clientLevel:set(arg_5_1)
		arg_4_0.level1:text(arg_5_1)
		adapt.oneLinePos(arg_4_0.level, arg_4_0.level1, cc.p(5, 0), "left")

		local var_5_15 = string.format(gLanguageCsv.completeLvUp, arg_5_1 + 1)

		arg_4_0.nextLevel:text(arg_5_1 == table.length(csv.fishing.level) and gLanguageCsv.lvIsMax or var_5_15)
	end)
	idlereasy.any({
		arg_4_0.clientLevel,
		arg_4_0.fishLevel
	}, function(arg_6_0, arg_6_1, arg_6_2)
		arg_4_0:setRightPanel(arg_6_1, arg_6_2)
	end)
	Dialog.onCreate(arg_4_0)
end

function var_0_0.setRightPanel(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = csv.fishing.level[arg_7_1]
	local var_7_1 = {
		{
			name = gLanguageCsv.timeDown,
			num = var_7_0.timeDown,
			isLock = arg_7_1 <= arg_7_0.fishLevel:read()
		},
		{
			name = gLanguageCsv.fasterSpeed,
			num = var_7_0.fasterSpeed,
			isLock = arg_7_1 <= arg_7_0.fishLevel:read()
		},
		{
			name = gLanguageCsv.extraProbability,
			num = var_7_0.extraProbability,
			isLock = arg_7_1 <= arg_7_0.fishLevel:read()
		}
	}

	arg_7_0.fishDatas:update(var_7_1)

	local var_7_2 = {}

	for iter_7_0 = 1, 99 do
		if var_7_0["attrNum" .. iter_7_0] and var_7_0["attrNum" .. iter_7_0] ~= 0 then
			local var_7_3 = var_7_0["attrNum" .. iter_7_0]
			local var_7_4 = getLanguageAttr(var_7_0["attrType" .. iter_7_0])

			if var_7_0["attrType" .. iter_7_0] == 22 or var_7_0["attrType" .. iter_7_0] == 23 then
				var_7_3 = "+" .. var_7_3 / 10000 * 100 .. "%"
			else
				var_7_3 = "+" .. var_7_3
			end

			table.insert(var_7_2, {
				name = var_7_4,
				num = var_7_3,
				isLock = arg_7_1 <= arg_7_0.fishLevel:read()
			})
		end
	end

	arg_7_0.attrDatas:update(var_7_2)

	local var_7_5 = string.format(gLanguageCsv.otherLevelBonuses, arg_7_1)

	arg_7_0.text:text(arg_7_1 ~= arg_7_2 and var_7_5 or gLanguageCsv.nowLevelBonuses)

	local var_7_6 = cc.c4b(183, 176, 158, 255)
	local var_7_7 = cc.c4b(91, 84, 91, 255)

	text.addEffect(arg_7_0.text, {
		color = arg_7_1 > arg_7_0.fishLevel:read() and var_7_6 or var_7_7
	})
	text.addEffect(arg_7_0.attrName, {
		color = arg_7_1 > arg_7_0.fishLevel:read() and var_7_6 or var_7_7
	})
	text.addEffect(arg_7_0.fishName, {
		color = arg_7_1 > arg_7_0.fishLevel:read() and var_7_6 or var_7_7
	})
	arg_7_0.btnNext:setTouchEnabled(arg_7_1 < table.length(csv.fishing.level))
	cache.setShader(arg_7_0.btnNext, false, arg_7_1 < table.length(csv.fishing.level) and "normal" or "hsl_gray")
	arg_7_0.btnUp:setTouchEnabled(arg_7_1 ~= 1)
	cache.setShader(arg_7_0.btnUp, false, arg_7_1 ~= 1 and "normal" or "hsl_gray")
end

function var_0_0.onBtnUp(arg_8_0)
	arg_8_0.clientLevel:set(math.max(arg_8_0.clientLevel:read() - 1, 1))
end

function var_0_0.onBtnNext(arg_9_0)
	arg_9_0.clientLevel:set(math.min(arg_9_0.clientLevel:read() + 1, table.length(csv.fishing.level)))
end

function var_0_0.initModel(arg_10_0)
	arg_10_0.fishLevel = gGameModel.fishing:getIdler("level")
	arg_10_0.fishCounter = gGameModel.fishing:getIdler("fish_counter")
	arg_10_0.targetCounter = gGameModel.fishing:getIdler("target_counter")
end

return var_0_0
