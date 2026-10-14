local var_0_0 = class("CardEquipView", cc.load("mvc").ViewBase)

local function var_0_1(arg_1_0, arg_1_1)
	return cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0.1), cc.MoveTo:create(0.3, cc.p(arg_1_0, arg_1_1 + 10)), cc.DelayTime:create(0.1), cc.MoveTo:create(0.3, cc.p(arg_1_0, arg_1_1))))
end

local var_0_2 = {
	"showStrengthenItem",
	"showStarItem",
	"showAwakeItem",
	"showSignetItem"
}

var_0_0.RESOURCE_FILENAME = "card_equip.json"
var_0_0.RESOURCE_BINDING = {
	item = "item",
	["panel.name"] = "panelName",
	["panel.icon"] = "icon",
	panel = "panel",
	["panel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("equipDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					bind.extend(arg_2_0, arg_2_1, {
						event = "extend",
						class = "equip_icon",
						props = {
							data = arg_2_3,
							selected = arg_2_3.isSel,
							onNode = function(arg_3_0)
								arg_3_0:setTouchEnabled(false)

								local var_3_0 = arg_3_0:get("imgArrow")

								var_3_0:visible(arg_2_3.state == true)

								if not arg_2_3.originY then
									arg_2_3.originX, arg_2_3.originY = var_3_0:xy()
								end

								if arg_2_3.action then
									var_3_0:stopAction(arg_2_3.action)

									arg_2_3.action = nil
								end

								if arg_2_3.state then
									arg_2_3.action = var_0_1(arg_2_3.originX, arg_2_3.originY)

									var_3_0:runAction(arg_2_3.action)
								end

								arg_3_0:xy(10, 10)
							end
						}
					})
					bind.touch(arg_2_0, arg_2_1, {
						methods = {
							ended = function()
								return arg_2_0.clickCell(arg_2_2, arg_2_3)
							end
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onEquipClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_5_0, arg_5_1)
	adapt.centerWithScreen(nil, "right", nil, {
		{
			arg_5_0.panel,
			"pos",
			"center"
		}
	})

	arg_5_1 = arg_5_1 or function()
		return gGameModel.role:read("cards")[1], idler.new(1), idler.new(1), idler.new(2)
	end
	arg_5_0.selectDbId, arg_5_0.selectIndex, arg_5_0.tabKey, arg_5_0.state = arg_5_1()

	arg_5_0:initModel()

	arg_5_0.equipDatas = idlers.newWithMap({})

	idlereasy.any({
		arg_5_0.equips,
		arg_5_0.tabKey,
		arg_5_0.state,
		arg_5_0.items,
		arg_5_0.level
	}, function(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
		arg_5_0.equipDatas:update(clone(arg_7_1))

		arg_5_0.equipDatas:atproxy(arg_5_0.selectIndex:read()).isSel = true

		if arg_7_3 == 2 then
			for iter_7_0 = 1, arg_5_0.equipDatas:size() do
				local var_7_0 = arg_5_0.equipDatas:atproxy(iter_7_0)
				local var_7_1 = csv.equips[var_7_0.equip_id]

				if arg_5_0[var_0_2[arg_7_2]] then
					arg_5_0[var_0_2[arg_7_2]](arg_5_0, var_7_1, var_7_0)
				end
			end
		end

		arg_5_0.selectIndex:notify()
	end):anonyOnly(arg_5_0)
	arg_5_0.selectIndex:addListener(function(arg_8_0, arg_8_1)
		local var_8_0 = arg_5_0.equipDatas:atproxy(arg_8_1)

		if var_8_0 then
			var_8_0.isSel = false
		end

		local var_8_1 = arg_5_0.equipDatas:atproxy(arg_8_0)

		if var_8_1 == nil then
			return
		end

		local var_8_2 = csv.equips[var_8_1.equip_id]
		local var_8_3
		local var_8_4

		if var_8_1.awake ~= 0 then
			var_8_3 = var_8_2.name1 .. gLanguageCsv["symbolRome" .. var_8_1.awake]
			var_8_4 = var_8_2.icon2
		else
			var_8_3 = var_8_2.name0
			var_8_4 = var_8_2.icon
		end

		local var_8_5, var_8_6 = dataEasy.getQuality(var_8_1.advance)

		text.addEffect(arg_5_0.panelName, {
			color = var_8_5 == 1 and ui.COLORS.NORMAL.WHITE or ui.COLORS.QUALITY[var_8_5]
		})

		local var_8_7 = var_8_3 .. var_8_6

		arg_5_0.panelName:text(var_8_7)
		arg_5_0.icon:texture(var_8_4)

		var_8_1.isSel = true
	end)
end

function var_0_0.initModel(arg_9_0)
	idlereasy.when(arg_9_0.selectDbId, function(arg_10_0, arg_10_1)
		local var_10_0 = gGameModel.cards:find(arg_10_1)

		arg_9_0.equips = idlereasy.assign(var_10_0:getIdler("equips"), arg_9_0.equips)

		arg_9_0.selectIndex:notify()
	end)

	arg_9_0.items = gGameModel.role:getIdler("items")
	arg_9_0.level = gGameModel.role:getIdler("level")
end

function var_0_0.showStarItem(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_2.star ~= arg_11_1.starMax
	local var_11_1 = true

	for iter_11_0, iter_11_1 in csvMapPairs(csv.base_attribute.equip_star[arg_11_2.star]["costItemMap" .. arg_11_1.starSeqID]) do
		if iter_11_0 ~= "gold" and iter_11_1 > dataEasy.getNumByKey(iter_11_0) then
			var_11_1 = false

			break
		end
	end

	arg_11_2.state = var_11_1 and var_11_0

	if arg_11_2.star == arg_11_1.starMax and dataEasy.isUnlock(gUnlockCsv.equipAbility) then
		local var_11_2 = arg_11_2.ability or 0
		local var_11_3 = true
		local var_11_4 = var_11_2 ~= arg_11_1.abilityMax

		for iter_11_2, iter_11_3 in csvMapPairs(csv.base_attribute.equip_ability[var_11_2]["costItemMap" .. arg_11_1.abilitySeqID]) do
			if iter_11_3 > dataEasy.getNumByKey(iter_11_2) then
				var_11_3 = false

				break
			end
		end

		arg_11_2.state = var_11_3 and var_11_4
	end
end

function var_0_0.showStrengthenItem(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0.level:read()
	local var_12_1 = arg_12_1.strengthMax[arg_12_2.advance]
	local var_12_2 = arg_12_1.strengthMax[csvSize(arg_12_1.strengthMax)]

	if var_12_1 > arg_12_2.level then
		arg_12_2.state = true
	else
		local var_12_3 = true

		for iter_12_0, iter_12_1 in csvMapPairs(gEquipAdvanceCsv[arg_12_2.equip_id][arg_12_2.advance].costItemMap) do
			if iter_12_1 > dataEasy.getNumByKey(iter_12_0) and var_12_3 then
				var_12_3 = false

				break
			end
		end

		arg_12_2.state = var_12_0 >= arg_12_1.roleLevelMax[arg_12_2.advance] and var_12_3
	end
end

function var_0_0.showAwakeItem(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_2.awake or 0
	local var_13_1 = true
	local var_13_2 = var_13_0 ~= arg_13_1.awakeMax

	for iter_13_0, iter_13_1 in csvMapPairs(csv.base_attribute.equip_awake[var_13_0]["costItemMap" .. arg_13_1.awakeSeqID]) do
		if iter_13_1 > dataEasy.getNumByKey(iter_13_0) then
			var_13_1 = false

			break
		end
	end

	arg_13_2.state = var_13_1 and var_13_2

	if var_13_0 == arg_13_1.awakeMax and dataEasy.isUnlock(gUnlockCsv.equipAwakeAbility) then
		local var_13_3 = arg_13_2.awake_ability or 0
		local var_13_4 = true
		local var_13_5 = var_13_3 ~= arg_13_1.awakeAbilityMax

		for iter_13_2, iter_13_3 in csvMapPairs(csv.base_attribute.equip_awake_ability[var_13_3]["costItemMap" .. arg_13_1.awakeAbilitySeqID]) do
			if iter_13_3 > dataEasy.getNumByKey(iter_13_2) then
				var_13_4 = false

				break
			end
		end

		arg_13_2.state = var_13_4 and var_13_5
	end
end

function var_0_0.showSignetItem(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = true

	if arg_14_2.signet ~= arg_14_1.signetStrengthMax[table.getn(arg_14_1.signetStrengthMax)] then
		for iter_14_0, iter_14_1 in csvMapPairs(csv.base_attribute.equip_signet[arg_14_2.signet]["costItemMap" .. arg_14_1.signetStrengthSeqID]) do
			if iter_14_1 > dataEasy.getNumByKey(iter_14_0) then
				var_14_0 = false

				break
			end
		end
	end

	local var_14_1 = arg_14_2.signet_advance ~= arg_14_1.signetAdvanceMax

	if var_14_1 and arg_14_2.signet == (arg_14_2.signet_advance + 1) * 5 then
		for iter_14_2, iter_14_3 in csvPairs(csv.base_attribute.equip_signet_advance) do
			if iter_14_3.advanceIndex == arg_14_1.advanceIndex and iter_14_3.advanceLevel == arg_14_2.signet_advance + 1 then
				for iter_14_4, iter_14_5 in csvMapPairs(csv.base_attribute.equip_signet_advance_cost[arg_14_2.signet_advance]["costItemMap" .. iter_14_3.advanceSeqID]) do
					if iter_14_5 > dataEasy.getNumByKey(iter_14_4) then
						var_14_0 = false

						break
					end
				end
			end
		end
	end

	arg_14_2.state = var_14_0 and var_14_1
end

function var_0_0.onEquipClick(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	arg_15_0.selectIndex:set(arg_15_2)
end

function var_0_0.getAttrNum(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = csv.equips[arg_16_0.equip_id]

	if not var_16_0["attrStarC" .. arg_16_1] then
		return 0
	end

	local var_16_1 = arg_16_0.star + 1
	local var_16_2 = arg_16_0.advance
	local var_16_3 = arg_16_0.level
	local var_16_4 = arg_16_0.awake or 0
	local var_16_5 = arg_16_0.ability or 0
	local var_16_6 = arg_16_0.signet or 0
	local var_16_7 = arg_16_0.awake_ability or 0

	arg_16_3 = arg_16_3 or {}

	local var_16_8 = var_16_1
	local var_16_9 = var_16_5
	local var_16_10 = var_16_2
	local var_16_11 = var_16_3
	local var_16_12 = var_16_6
	local var_16_13 = var_16_0["attrStarC" .. arg_16_1]
	local var_16_14 = var_16_0["attrNum" .. arg_16_1]
	local var_16_15 = var_16_0["attrStarNum" .. arg_16_1]
	local var_16_16 = var_16_0["attrAdvanceNum" .. arg_16_1]
	local var_16_17 = var_16_0["awakeAttrNum" .. arg_16_1]
	local var_16_18 = var_16_0.abilityAttr
	local var_16_19 = var_16_0["signetAttrNum" .. arg_16_1]
	local var_16_20 = var_16_0["awakeAbilityAttrNum" .. arg_16_1]
	local var_16_21 = var_16_0["attrType" .. arg_16_1]
	local var_16_22 = var_16_13[var_16_1] * (var_16_14[var_16_2] + var_16_15[var_16_1] + var_16_16[var_16_2] * var_16_3)
	local var_16_23
	local var_16_24 = {
		star = function()
			var_16_8 = arg_16_3.star or var_16_1 + 1

			if arg_16_0.star == var_16_0.starMax then
				var_16_23 = 0
			end

			return var_16_22, var_16_23
		end,
		ability = function()
			if var_16_5 ~= var_16_0.abilityMax then
				var_16_23 = var_16_22 * (100 + tonumber(string.sub(var_16_0.abilityAttr[var_16_5 + 1], 1, -2))) / 100
			else
				var_16_23 = 0
			end

			if var_16_5 > 0 then
				var_16_22 = var_16_22 * (100 + tonumber(string.sub(var_16_0.abilityAttr[var_16_5], 1, -2))) / 100
			end

			return var_16_22, var_16_23
		end,
		advance = function()
			var_16_11 = arg_16_3.level or var_16_3
			var_16_10 = arg_16_3.advance or var_16_2 + 1

			if arg_16_0.advance == var_16_0.advanceMax then
				var_16_23 = 0
			end

			return var_16_22, var_16_23
		end,
		strengthen = function()
			var_16_11 = arg_16_3.level or var_16_3 + 1

			if arg_16_0.level == var_16_0.strengthMax[csvSize(var_16_0.strengthMax)] then
				var_16_23 = 0
			end

			return var_16_22, var_16_23
		end,
		awake = function()
			var_16_21 = var_16_0["awakeAttrType" .. arg_16_1]
			var_16_22, var_16_23 = dataEasy.getAttrValueAndNextValue(var_16_21, var_16_17[var_16_4] or 0, var_16_17[var_16_4 + 1])

			return var_16_22, var_16_23
		end,
		signet = function()
			var_16_21 = var_16_0["signetAttrType" .. arg_16_1]
			var_16_22, var_16_23 = dataEasy.getAttrValueAndNextValue(var_16_21, var_16_19[var_16_6] or 0, var_16_19[var_16_6 + 1])

			return var_16_22, var_16_23
		end,
		awakeAbility = function()
			var_16_21 = var_16_0["awakeAbilityAttrType" .. arg_16_1]
			var_16_22, var_16_23 = dataEasy.getAttrValueAndNextValue(var_16_21, var_16_20[var_16_7] or 0, var_16_20[var_16_7 + 1])

			return var_16_22, var_16_23
		end
	}

	if var_16_24[arg_16_2] then
		var_16_22, var_16_23 = var_16_24[arg_16_2]()
	end

	var_16_23 = var_16_23 or var_16_13[var_16_8] * (var_16_14[var_16_10] + var_16_15[var_16_8] + var_16_16[var_16_10] * var_16_11)

	return var_16_21, var_16_22, var_16_23
end

return var_0_0
