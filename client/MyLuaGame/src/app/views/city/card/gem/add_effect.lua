local var_0_0 = class("GemAddEffectView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "gem_add_effect.json"
var_0_0.RESOURCE_BINDING = {
	effect = "effect",
	item2 = "item2",
	noItem = "noItem",
	itemList = "itemList",
	harm = "harm",
	suitPanel = "suitPanel",
	suitItem = "suitItem",
	list = "list",
	imgBg = {
		binds = {
			event = "click",
			method = bindHelper.self("onClose")
		}
	},
	resonance = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("btnResonance")
			}
		}
	},
	["resonance.title"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.cardDbid = arg_1_1
	arg_1_0.index = arg_1_2
	arg_1_0.pushSuitNum = 0

	arg_1_0.list:setScrollBarEnabled(false)
	arg_1_0.itemList:setScrollBarEnabled(false)
	arg_1_0.suitPanel:get("suitList"):setScrollBarEnabled(false)

	local function var_1_0(arg_2_0)
		local var_2_0 = arg_1_0.item2:clone():show()

		var_2_0:get("title"):text(arg_2_0)

		local var_2_1 = var_2_0:get("title"):x()

		var_2_0:get("right"):x(var_2_0:get("title"):width() / 2 + 40 + var_2_1)
		var_2_0:get("left"):x(-var_2_0:get("title"):width() / 2 - 40 + var_2_1)
		arg_1_0.list:pushBackCustomItem(var_2_0)
	end

	var_1_0(gLanguageCsv.basicAttribute)
	arg_1_0:onAttrData()
	var_1_0(gLanguageCsv.resonanceAttr)
	arg_1_0:onSuitData()
	var_1_0(gLanguageCsv.indexAttr)
	arg_1_0:onIndexData()
	arg_1_0.list:adaptTouchEnabled()
end

function var_0_0.onAttrData(arg_3_0)
	local var_3_0 = gGameModel.cards:find(arg_3_0.cardDbid):read("gems")
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		local var_3_2 = gGameModel.gems:find(iter_3_1)
		local var_3_3 = csv.gem.gem[var_3_2:read("gem_id")]
		local var_3_4 = var_3_2:read("level")

		for iter_3_2 = 1, math.huge do
			if var_3_3["attrType" .. iter_3_2] and var_3_3["attrType" .. iter_3_2] ~= 0 and var_3_3["attrNum" .. iter_3_2] and var_3_3["attrNum" .. iter_3_2][var_3_4] then
				if not var_3_1[var_3_3["attrType" .. iter_3_2]] then
					var_3_1[var_3_3["attrType" .. iter_3_2]] = {}

					table.insert(var_3_1[var_3_3["attrType" .. iter_3_2]], var_3_3["attrNum" .. iter_3_2][var_3_4])
				else
					table.insert(var_3_1[var_3_3["attrType" .. iter_3_2]], var_3_3["attrNum" .. iter_3_2][var_3_4])
				end
			else
				break
			end
		end
	end

	if csvSize(var_3_1) == 0 then
		local var_3_5 = arg_3_0.noItem:clone():show()

		var_3_5:get("txt"):text(gLanguageCsv.gemNestNotArrt1)
		arg_3_0.list:pushBackCustomItem(var_3_5)
	else
		arg_3_0:onDispose(var_3_1)
	end
end

function var_0_0.onSuitData(arg_4_0)
	local var_4_0 = gGameModel.cards:find(arg_4_0.cardDbid):read("gems")
	local var_4_1 = true
	local var_4_2 = {}

	for iter_4_0, iter_4_1 in pairs(var_4_0) do
		local var_4_3 = gGameModel.gems:find(iter_4_1)
		local var_4_4 = csv.gem.gem[var_4_3:read("gem_id")]

		if var_4_4.suitID then
			var_4_2[var_4_4.suitID] = var_4_2[var_4_4.suitID] or {}

			table.insert(var_4_2[var_4_4.suitID], {
				quality = var_4_4.quality
			})
		end
	end

	local var_4_5 = {}

	for iter_4_2, iter_4_3 in pairs(var_4_2) do
		table.sort(iter_4_3, function(arg_5_0, arg_5_1)
			return arg_5_0.quality > arg_5_1.quality
		end)

		local var_4_6, var_4_7 = next(gGemSuitCsv[iter_4_2])

		for iter_4_4 = 1, #iter_4_3 do
			if var_4_7[iter_4_4] then
				table.insert(var_4_5, {
					suitID = iter_4_2,
					suitNum = iter_4_4,
					quality = iter_4_3[iter_4_4].quality
				})
			end
		end
	end

	local function var_4_8(arg_6_0)
		local var_6_0

		for iter_6_0, iter_6_1 in ipairs(arg_6_0) do
			if iter_6_0 % 3 == 1 then
				var_6_0 = arg_4_0.suitPanel:clone():show()

				arg_4_0.list:pushBackCustomItem(var_6_0)
			end

			local var_6_1 = arg_4_0.suitItem:clone():show()

			var_6_1:get("icon"):texture(ui.GEM_SUIT_ICON[iter_6_1.suitID])
			var_6_1:get("num"):text("x" .. iter_6_1.suitNum .. ":")

			local var_6_2 = 1
			local var_6_3 = gGemSuitCsv[iter_6_1.suitID][iter_6_1.quality][iter_6_1.suitNum]

			var_6_1:get("name"):text(string.format("%s(%s)", var_6_3.suitName, gLanguageCsv[ui.QUALITY_COLOR_TEXT[iter_6_1.quality]]))
			text.addEffect(var_6_1:get("name"), {
				color = ui.COLORS.QUALITY_DARK[iter_6_1.quality]
			})

			for iter_6_2 = 1, math.huge do
				if var_6_3["attrType" .. iter_6_2] and var_6_3["attrType" .. iter_6_2] ~= 0 then
					local var_6_4 = game.ATTRDEF_TABLE[var_6_3["attrType" .. iter_6_2]]
					local var_6_5 = gLanguageCsv["attr" .. string.caption(var_6_4)]

					adapt.setTextAdaptWithSize(var_6_1:get("txt" .. iter_6_2), {
						margin = -5,
						vertical = "center",
						horizontal = "center",
						maxLine = 2,
						str = var_6_5,
						size = cc.size(230, 80)
					})
					adapt.oneLinePos(var_6_1:get("txt" .. iter_6_2), var_6_1:get("num" .. iter_6_2), cc.p(-7, 0))
					var_6_1:get("num" .. iter_6_2):text(" +" .. dataEasy.getAttrValueString(var_6_3["attrType" .. iter_6_2], var_6_3["attrNum" .. iter_6_2]))

					var_6_2 = iter_6_2
				else
					break
				end
			end

			if var_6_2 == 1 then
				for iter_6_3 = 1, 3 do
					var_6_1:get("txt" .. iter_6_3):visible(iter_6_3 <= var_6_2)
					var_6_1:get("num" .. iter_6_3):visible(iter_6_3 <= var_6_2)
				end

				var_6_1:get("txt1"):y(var_6_1:get("txt2"):y())
				var_6_1:get("num1"):y(var_6_1:get("num2"):y())
			elseif var_6_2 == 2 then
				var_6_1:get("txt3"):visible(false)
				var_6_1:get("num3"):visible(false)

				for iter_6_4 = 1, 2 do
					var_6_1:get("txt" .. iter_6_4):y(var_6_1:get("txt" .. iter_6_4):y() - 30)
					var_6_1:get("num" .. iter_6_4):y(var_6_1:get("num" .. iter_6_4):y() - 30)
				end
			end

			var_6_0:get("suitList"):pushBackCustomItem(var_6_1)

			if #arg_6_0 < 3 then
				var_6_0:get("suitList"):setItemAlignCenter()
			end
		end
	end

	if #var_4_5 == 0 then
		local var_4_9 = arg_4_0.noItem:clone():show()

		var_4_9:get("txt"):text(gLanguageCsv.gemNestNotArrt2)
		arg_4_0.list:pushBackCustomItem(var_4_9)
	else
		var_4_8(var_4_5)
	end
end

function var_0_0.onDispose(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = 0
	local var_7_1

	for iter_7_0, iter_7_1 in pairs(arg_7_1) do
		local var_7_2 = 0

		if arg_7_2 then
			iter_7_0 = iter_7_1.key
			var_7_2 = iter_7_1.num
		else
			for iter_7_2, iter_7_3 in pairs(iter_7_1) do
				var_7_2 = var_7_2 + iter_7_3
			end
		end

		if iter_7_0 then
			local var_7_3 = game.ATTRDEF_TABLE[iter_7_0]
			local var_7_4 = var_7_3
			local var_7_5 = "attr" .. var_7_3:gsub("^%l", string.upper)
			local var_7_6 = gLanguageCsv[var_7_5]

			var_7_0 = var_7_0 + 1

			if var_7_0 % 3 == 1 then
				var_7_1 = arg_7_0.itemList:clone():show()

				arg_7_0.list:pushBackCustomItem(var_7_1)
			end

			if game.ATTRDEF_SHOW_NUMBER[iter_7_0] then
				local var_7_7 = arg_7_0.effect:clone():show()

				var_7_7:get("name"):text(var_7_6)
				var_7_7:get("num"):text("+" .. var_7_2)
				var_7_7:get("icon"):texture(ui.ATTR_LOGO[var_7_4])

				if arg_7_3 then
					var_7_7:get("icon"):visible(false)
					text.addEffect(var_7_7:get("num"), {
						color = ui.COLORS.NORMAL.FRIEND_GREEN
					})

					local var_7_8 = var_7_7:get("name"):x() - var_7_7:get("icon"):x() - var_7_7:get("icon"):width() / 2

					var_7_7:get("name"):x(var_7_7:get("icon"):x() - var_7_7:get("icon"):width() / 2)
					var_7_7:get("num"):x(var_7_7:get("name"):x() + var_7_7:get("name"):width() + 30)
				end

				var_7_1:pushBackCustomItem(var_7_7)
			else
				local var_7_9 = arg_7_0.harm:clone():show()

				var_7_9:get("name"):text(var_7_6)
				var_7_9:get("num"):x(var_7_9:get("name"):width() + var_7_9:get("name"):x() + 20)
				var_7_9:get("num"):text("+" .. dataEasy.getAttrValueString(iter_7_0, var_7_2))
				var_7_1:pushBackCustomItem(var_7_9)
			end
		end
	end
end

function var_0_0.onIndexData(arg_8_0)
	local var_8_0 = gGameModel.cards:find(arg_8_0.cardDbid):read("card_id")
	local var_8_1 = csv.cards[var_8_0].gemQualitySeqID
	local var_8_2 = {}
	local var_8_3 = true
	local var_8_4 = true
	local var_8_5 = 0
	local var_8_6 = 0

	for iter_8_0, iter_8_1 in orderCsvPairs(csv.gem.quality_attrs) do
		if var_8_1 == iter_8_1.gemQualitySeqID and iter_8_1.qualityNum <= arg_8_0.index then
			for iter_8_2 = 1, math.huge do
				if iter_8_1["attrType" .. iter_8_2] and iter_8_1["attrType" .. iter_8_2] ~= 0 then
					local var_8_7 = game.ATTRDEF_TABLE[iter_8_1["attrType" .. iter_8_2]]
					local var_8_8 = gLanguageCsv["attr" .. string.caption(var_8_7)]

					if not var_8_2[1] or not var_8_2[2] then
						var_8_2[1] = var_8_2[1] or {}
						var_8_2[2] = var_8_2[2] or {}

						local var_8_9, var_8_10 = dataEasy.parsePercentStr(iter_8_1["attrNum" .. iter_8_2])
						local var_8_11 = var_8_10 == 1 and 1 or 2

						table.insert(var_8_2[var_8_11], {
							key = iter_8_1["attrType" .. iter_8_2],
							num = dataEasy.getAttrValueString(iter_8_1["attrType" .. iter_8_2], iter_8_1["attrNum" .. iter_8_2])
						})
					else
						local var_8_12, var_8_13 = true, true
						local var_8_14 = 0, 0
						local var_8_15, var_8_16 = dataEasy.parsePercentStr(iter_8_1["attrType" .. iter_8_2], iter_8_1["attrNum" .. iter_8_2])
						local var_8_17 = string.find(iter_8_1["attrNum" .. iter_8_2], "%%")

						if var_8_16 == 1 and not var_8_17 then
							for iter_8_3, iter_8_4 in pairs(var_8_2[1]) do
								if iter_8_1["attrType" .. iter_8_2] == iter_8_4.key then
									var_8_12 = false
									var_8_2[1][K2].num = iter_8_4.num + dataEasy.getAttrValueString(iter_8_1["attrType" .. iter_8_2], iter_8_1["attrNum" .. iter_8_2])
								end
							end

							if var_8_12 then
								table.insert(var_8_2[1], {
									key = iter_8_1["attrType" .. iter_8_2],
									num = dataEasy.getAttrValueString(iter_8_1["attrType" .. iter_8_2], iter_8_1["attrNum" .. iter_8_2])
								})
							end
						else
							for iter_8_5, iter_8_6 in pairs(var_8_2[2]) do
								if iter_8_1["attrType" .. iter_8_2] == iter_8_6.key then
									var_8_13 = false

									local var_8_18 = dataEasy.parsePercentStr(iter_8_1["attrNum" .. iter_8_2])
									local var_8_19 = dataEasy.parsePercentStr(iter_8_6.num)

									var_8_2[2][iter_8_5].num = dataEasy.getPercentStr(var_8_19 + var_8_18, 0)
								end
							end

							if var_8_13 then
								table.insert(var_8_2[2], {
									key = iter_8_1["attrType" .. iter_8_2],
									num = dataEasy.getAttrValueString(iter_8_1["attrType" .. iter_8_2], iter_8_1["attrNum" .. iter_8_2])
								})
							end
						end
					end
				else
					break
				end
			end
		end
	end

	if #var_8_2 == 0 then
		local var_8_20 = arg_8_0.noItem:clone():show()

		var_8_20:get("txt"):text(gLanguageCsv.gemNestNotArrt3)
		arg_8_0.list:pushBackCustomItem(var_8_20)
	else
		table.sort(var_8_2[1], function(arg_9_0, arg_9_1)
			return arg_9_0.key < arg_9_1.key
		end)
		table.sort(var_8_2[2], function(arg_10_0, arg_10_1)
			return arg_10_0.key < arg_10_1.key
		end)
		arg_8_0:onDispose(var_8_2[1], true)
		arg_8_0:onDispose(var_8_2[2], true, true)
	end
end

function var_0_0.btnResonance(arg_11_0)
	gGameUI:stackUI("city.card.gem.resonance", nil, nil)
end

return var_0_0
