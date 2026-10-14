local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("MegaChooseCardView", Dialog)

var_0_1.RESOURCE_FILENAME = "card_mega_choose_card.json"
var_0_1.RESOURCE_BINDING = {
	["tipPanel.textTip"] = "textTip",
	["down.textNum"] = "textNum",
	item = "item",
	["down.textNote"] = "textNote",
	innerList = "innerList",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 3,
				asyncPreload = 12,
				data = bindHelper.self("cardDatas"),
				item = bindHelper.self("innerList"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					bind.extend(arg_1_0, arg_1_1:get("head"), {
						class = "card_icon",
						props = {
							unitId = arg_1_3.unitId,
							advance = arg_1_3.advance,
							star = arg_1_3.star,
							rarity = arg_1_3.rarity,
							levelProps = {
								data = arg_1_3.level
							}
						}
					})

					if ui.CARD_USING_TXTS[arg_1_3.battleType] then
						arg_1_1:get("txt"):text(gLanguageCsv[ui.CARD_USING_TXTS[arg_1_3.battleType]]):show()
						arg_1_1:get("imgTick"):visible(false)
						arg_1_1:get("imgMask"):visible(true)
					else
						arg_1_1:get("txt"):hide()
						arg_1_1:get("imgTick"):visible(arg_1_3.isSel)
						arg_1_1:get("imgMask"):visible(arg_1_3.isSel)
					end

					arg_1_1:get("textName"):text(csv.cards[arg_1_3.id].name)
					arg_1_1:get("textFightPoint"):text(arg_1_3.fight)
					uiEasy.addTextEffect1(arg_1_1:get("txt"))
					arg_1_1:get("imgLock"):visible(arg_1_3.lock)
					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_0:getIdx(arg_1_2), arg_1_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onCellClick")
			}
		}
	},
	down = {
		binds = {
			event = "visible",
			idler = bindHelper.self("isShowDown")
		}
	},
	["down.btnOk"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSure")
			}
		}
	},
	tipPanel = {
		binds = {
			event = "visible",
			idler = bindHelper.self("showTip")
		}
	}
}

function var_0_1.onCreate(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.data = arg_2_1
	arg_2_0.cb = arg_2_2
	arg_2_0.cardDatas = idlers.new({})
	arg_2_0.showTip = idler.new(false)

	local var_2_0 = 1
	local var_2_1 = true

	if arg_2_1.key == "main" then
		var_2_1 = false

		if arg_2_1.chooseIdx then
			var_2_0 = csv.card_mega[arg_2_1.megaIndex].costCards.num or 1
		end
	end

	arg_2_0.needNum = idler.new(var_2_0)
	arg_2_0.chooseNum = 0

	idlereasy.when(gGameModel.role:getIdler("cards"), function(arg_3_0, arg_3_1)
		local var_3_0 = {}
		local var_3_1 = dataEasy.inUsingCardsHash()

		for iter_3_0, iter_3_1 in ipairs(arg_3_1) do
			local var_3_2 = gGameModel.cards:find(iter_3_1):read("card_id", "skin_id", "level", "star", "advance", "name", "fighting_point", "locked")
			local var_3_3 = csv.cards[var_3_2.card_id]
			local var_3_4 = var_3_3.unitID
			local var_3_5 = csv.unit[var_3_4]
			local var_3_6 = dataEasy.getUnitId(var_3_2.card_id, var_3_2.skin_id)
			local var_3_7 = var_3_5.rarity
			local var_3_8 = var_3_3.cardMarkID
			local var_3_9 = false
			local var_3_10 = false
			local var_3_11 = var_3_1[iter_3_1]
			local var_3_12 = var_3_2.locked
			local var_3_13 = 0

			if arg_2_1.key == "main" then
				local var_3_14 = csv.card_mega[arg_2_1.megaIndex]

				if arg_2_1.chooseIdx then
					if var_3_3.cardMarkID == var_3_14.costCards.markID and var_3_2.star >= var_3_14.costCards.star or var_3_7 == var_3_14.costCards.rarity and var_3_2.star >= var_3_14.costCards.star then
						var_3_9 = true
					end

					if arg_2_1.subCardData[iter_3_1] then
						var_3_10 = true
					end

					if iter_3_1 == arg_2_1.cardDbid then
						var_3_9 = false
					end
				else
					var_3_11 = nil
					var_3_12 = false

					if var_3_14.card[1] == var_3_2.card_id and var_3_14.card[2] <= var_3_2.star then
						var_3_9 = true
					end

					if iter_3_1 == arg_2_1.cardDbid then
						var_3_10 = true
					end

					if arg_2_1.subCardData[iter_3_1] then
						var_3_9 = false
					end
				end
			else
				local var_3_15 = csv.card_mega_convert[arg_2_1.csvId]

				if var_3_3.cardType ~= 2 then
					for iter_3_2 = 1, math.huge do
						local var_3_16 = var_3_15["needCards" .. iter_3_2]

						if not var_3_16 or csvSize(var_3_16) <= 0 then
							break
						end

						if var_3_7 == var_3_16[1] and (var_3_16[2] == -1 or var_3_5.natureType == var_3_16[2] or var_3_5.natureType2 == var_3_16[2]) then
							var_3_9 = true

							break
						end
					end
				else
					var_3_13 = 1
				end

				if iter_3_1 == arg_2_1.selectId then
					var_3_10 = true
				end

				for iter_3_3, iter_3_4 in csvPairs(var_3_15.needSpecialCards) do
					if iter_3_4 == var_3_2.card_id then
						var_3_9 = true

						break
					end
				end
			end

			if var_2_1 and (var_3_3.megaIndex > 0 or var_3_2.star > var_3_3.star) then
				var_3_9 = false
			end

			if var_3_9 then
				table.insert(var_3_0, {
					dbid = iter_3_1,
					id = var_3_2.card_id,
					unitId = var_3_6,
					fight = var_3_2.fighting_point,
					name = var_3_2.name,
					level = var_3_2.level,
					star = var_3_2.star,
					advance = var_3_2.advance,
					rarity = var_3_7,
					isSel = var_3_10,
					battleType = var_3_11,
					lock = var_3_12,
					mega = var_3_3.megaIndex > 0,
					cardType = var_3_13
				})
			end
		end

		table.sort(var_3_0, function(arg_4_0, arg_4_1)
			local var_4_0 = ui.CARD_USING_TXTS[arg_4_0.battleType] ~= nil
			local var_4_1 = ui.CARD_USING_TXTS[arg_4_1.battleType] ~= nil

			if var_4_0 ~= var_4_1 then
				return var_4_1
			end

			if arg_4_0.cardType ~= arg_4_1.cardType then
				return arg_4_0.cardType > arg_4_1.cardType
			end

			if arg_4_0.id ~= arg_4_1.id then
				return arg_4_0.id < arg_4_1.id
			end

			return arg_4_0.fight < arg_4_1.fight
		end)
		arg_2_0.cardDatas:update(var_3_0)
		arg_2_0.textTip:text(gLanguageCsv.spriteNotNum)
		arg_2_0.showTip:set(#var_3_0 == 0)
		arg_2_0.needNum:notify()
	end)
	idlereasy.when(arg_2_0.needNum, function(arg_5_0, arg_5_1)
		local var_5_0 = 0

		for iter_5_0, iter_5_1 in arg_2_0.cardDatas:ipairs() do
			if iter_5_1:read().isSel then
				var_5_0 = var_5_0 + 1
			end
		end

		arg_2_0.chooseNum = var_5_0

		arg_2_0.textNum:text(var_5_0 .. "/" .. arg_5_1)
	end)
	Dialog.onCreate(arg_2_0, {
		clickClose = true
	})
end

function var_0_1.onChangeData(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0.cardDatas:atproxy(arg_6_1).lock = gGameModel.cards:find(arg_6_2.dbid):read("locked")
end

function var_0_1.onCellClick(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	if arg_7_3.lock then
		gGameUI:showDialog({
			btnType = 2,
			clearFast = true,
			cb = function()
				gGameUI:stackUI("city.card.strengthen", nil, {
					full = true
				}, 1, arg_7_3.dbid, arg_7_0:createHandler("onChangeData", arg_7_2.k, arg_7_3))
			end,
			content = string.format(gLanguageCsv.gotoUnLock, gLanguageCsv.change)
		})

		return true
	end

	if ui.CARD_USING_TXTS[arg_7_3.battleType] then
		gGameUI:showTip(gLanguageCsv[ui.CARD_USING_TXTS[arg_7_3.battleType]])

		return
	end

	local var_7_0 = arg_7_0.cardDatas:atproxy(arg_7_2.k).isSel

	local function var_7_1()
		if not var_7_0 and arg_7_0.chooseNum >= arg_7_0.needNum:read() then
			for iter_9_0, iter_9_1 in arg_7_0.cardDatas:pairs() do
				if iter_9_1:proxy().isSel then
					iter_9_1:proxy().isSel = false

					break
				end
			end
		end

		arg_7_0.cardDatas:atproxy(arg_7_2.k).isSel = not var_7_0

		arg_7_0.needNum:notify()
	end

	if not var_7_0 and (arg_7_0.data.key ~= "main" or arg_7_0.data.chooseIdx) then
		local var_7_2
		local var_7_3 = csv.cards[arg_7_3.id]

		if arg_7_3.mega then
			var_7_2 = gLanguageCsv.megaOk
		elseif arg_7_3.star > var_7_3.star then
			var_7_2 = gLanguageCsv.selectCardMaterialsMega
		elseif arg_7_3.level > 1 or arg_7_3.advance > 1 then
			var_7_2 = gLanguageCsv.selectCardMaterialsMega
		end

		if var_7_2 then
			gGameUI:showDialog({
				fontSize = 50,
				btnType = 2,
				isRich = true,
				title = gLanguageCsv.spaceTips,
				content = var_7_2,
				cb = var_7_1
			})

			return
		end
	end

	var_7_1()
end

function var_0_1.onSure(arg_10_0)
	local var_10_0 = {}

	for iter_10_0, iter_10_1 in arg_10_0.cardDatas:ipairs() do
		if iter_10_1:read().isSel then
			var_10_0[iter_10_1:read().dbid] = true
		end
	end

	if arg_10_0.data.key == "main" then
		if arg_10_0.data.chooseIdx then
			arg_10_0.data.subCardData = var_10_0
		else
			arg_10_0.data.cardDbid = next(var_10_0)
		end
	else
		arg_10_0.data.selectId = next(var_10_0)
	end

	arg_10_0:addCallbackOnExit(arg_10_0.cb)
	var_0_0.onClose(arg_10_0)
end

return var_0_1
