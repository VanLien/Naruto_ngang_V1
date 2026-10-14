local var_0_0 = require("app.views.city.card.helditem.tools")
local var_0_1 = 450
local var_0_2 = class("StrangeMeteorHeldSelectView", Dialog)

var_0_2.RESOURCE_FILENAME = "strange_meteor_held_select.json"
var_0_2.RESOURCE_BINDING = {
	innweList = "innweList",
	item = "item",
	left = "left",
	["left.title.textNote2"] = "textNote2",
	["left.title.textNote1"] = "textNote1",
	["left.title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["left.btnSure"] = {
		varname = "btnSure",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSureClick")
			}
		}
	},
	["left.noItem"] = {
		varname = "noItem",
		binds = {
			event = "visible",
			idler = bindHelper.self("hasItem")
		}
	},
	["left.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				leftPadding = 10,
				asyncPreload = 25,
				topPadding = 10,
				columnSize = 5,
				data = bindHelper.self("heldItems"),
				item = bindHelper.self("innweList"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true,
					alwaysShow = true
				},
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_3.inMeteor and 1 or 0
					local var_1_1 = arg_1_1:get("tips"):text(gLanguageCsv.inMeteor)

					uiEasy.addTextEffect1(var_1_1)
					var_1_1:visible(var_1_0 == 1)
					arg_1_1:get("imgSel"):visible(arg_1_3.isSel)
					bind.extend(arg_1_0, arg_1_1, {
						class = "icon_key",
						props = {
							noListener = true,
							data = {
								key = arg_1_3.csvId,
								num = arg_1_3.num,
								dbId = arg_1_3.dbId[1]
							},
							grayState = var_1_0,
							specialKey = {
								lv = arg_1_3.lv
							},
							onNode = function(arg_2_0)
								local var_2_0 = arg_1_0:getIdx(arg_1_2)

								bind.click(arg_1_0, arg_2_0, {
									method = functools.partial(arg_1_0.clickCell, var_2_0, arg_1_3)
								})
							end
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	}
}

function var_0_2.onCreate(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0:initModel()

	arg_3_0.pos = arg_3_2
	arg_3_0.index = arg_3_1 or 1
	arg_3_0.hasItem = idler.new(false)
	arg_3_0.heldItems = idlers.newWithMap({})
	arg_3_0.curSelDbId = idler.new()
	arg_3_0.curItemOnCard = idler.new(true)
	arg_3_0.stopActionCb = arg_3_3
	arg_3_0.insetCb = arg_3_4

	arg_3_0:refreshData()
	idlereasy.when(arg_3_0.curSelDbId, function(arg_4_0, arg_4_1)
		if not arg_4_1 then
			arg_3_0.curItemOnCard:set(false)
			uiEasy.setBtnShader(arg_3_0.btnSure, false, 3)
		else
			uiEasy.setBtnShader(arg_3_0.btnSure, false, 1)
		end

		if type(arg_4_1) == "table" then
			arg_4_1 = arg_4_1[1]
		end

		local var_4_0 = gGameModel.held_items:find(arg_4_1)
		local var_4_1 = var_4_0 and var_4_0:read("exist_flag", "card_db_id")

		if var_4_1 and var_4_1.card_db_id then
			arg_3_0.curItemOnCard:set(true)
		else
			arg_3_0.curItemOnCard:set(false)
		end
	end)
	arg_3_0.selIdx:addListener(function(arg_5_0, arg_5_1)
		if arg_5_1 ~= -1 and arg_5_0 ~= arg_5_1 and arg_3_0.heldItems:atproxy(arg_5_1) and arg_3_0.heldItems:atproxy(arg_5_1).isSel ~= false then
			arg_3_0.heldItems:atproxy(arg_5_1).isSel = false
		end

		if not arg_3_0.heldItems:atproxy(arg_5_0) then
			arg_3_0.curSelDbId:set(nil)

			return
		end

		if arg_5_0 ~= arg_5_1 and arg_3_0.heldItems:atproxy(arg_5_0).isSel ~= true then
			arg_3_0.heldItems:atproxy(arg_5_0).isSel = true
		end

		arg_3_0.curSelDbId:set(arg_3_0.heldItems:atproxy(arg_5_0).dbId)

		local var_5_0 = csv.held_item.items
		local var_5_1 = csv.held_item.effect
		local var_5_2 = arg_3_0.heldItems:atproxy(arg_5_0)
		local var_5_3 = var_5_0[var_5_2.csvId]
		local var_5_4 = var_5_2.cardDbID
		local var_5_5 = 1
		local var_5_6 = gLanguageCsv.spaceEquip
		local var_5_7, var_5_8 = var_0_0.isExclusive(var_5_2)
	end)
	adapt.oneLinePos(arg_3_0.textNote1, arg_3_0.textNote2)
	Dialog.onCreate(arg_3_0)
end

function var_0_2.initModel(arg_6_0)
	arg_6_0.myHeldItem = gGameModel.role:getIdler("held_items")
	arg_6_0.cards = gGameModel.role:getIdler("cards")
	arg_6_0.selIdx = idler.new()
end

function var_0_2.refreshData(arg_7_0)
	arg_7_0.tableDatas = {}
	arg_7_0.dataIdx = {}

	local var_7_0 = {}
	local var_7_1 = {}
	local var_7_2 = 0
	local var_7_3 = csv.held_item.items
	local var_7_4 = dataEasy.getInMeteorHelditemsHash()

	for iter_7_0, iter_7_1 in pairs(arg_7_0.myHeldItem:read()) do
		local var_7_5 = gGameModel.held_items:find(iter_7_1)

		if var_7_5 then
			local var_7_6 = var_7_5.read(var_7_5, "exist_flag", "card_db_id", "advance", "level", "sum_exp", "held_item_id")

			if var_7_6.exist_flag then
				local var_7_7 = var_7_3[var_7_6.held_item_id]

				if not var_7_4[iter_7_1] and var_7_6.sum_exp == 0 and var_7_6.advance == 0 and not var_7_6.card_db_id then
					if not var_7_0[var_7_6.held_item_id] then
						var_7_0[var_7_6.held_item_id] = {
							num = 0,
							maxNum = var_7_7.stackShow,
							dbIds = {}
						}
					end

					var_7_0[var_7_6.held_item_id].num = var_7_0[var_7_6.held_item_id].num + 1

					table.insert(var_7_0[var_7_6.held_item_id].dbIds, iter_7_1)
				else
					var_7_2 = var_7_2 + 1

					local var_7_8 = {
						num = 1,
						isSel = false,
						cfg = var_7_7,
						csvId = var_7_6.held_item_id,
						dbId = {
							iter_7_1
						},
						lv = var_7_6.level,
						cardDbID = var_7_6.card_db_id,
						advance = var_7_6.advance
					}
					local var_7_9, var_7_10 = var_0_0.isExclusive(var_7_8)

					var_7_8.isDress = var_7_9
					var_7_8.isExc = var_7_10
					var_7_8.inMeteor = var_7_4[iter_7_1]

					table.insert(var_7_1, var_7_8)

					arg_7_0.dataIdx[iter_7_1] = var_7_2
				end
			end
		end
	end

	for iter_7_2, iter_7_3 in pairs(var_7_0) do
		local var_7_11 = iter_7_3.num
		local var_7_12 = iter_7_3.maxNum

		for iter_7_4 = 1, math.ceil(var_7_11 / var_7_12) do
			var_7_2 = var_7_2 + 1

			local var_7_13 = {
				cfg = var_7_3[iter_7_2],
				csvId = iter_7_2
			}
			local var_7_14 = math.min(var_7_12, var_7_11)

			var_7_13.num = var_7_14

			local var_7_15 = {}

			for iter_7_5 = 1, var_7_14 do
				table.insert(var_7_15, iter_7_3.dbIds[iter_7_5])
			end

			var_7_13.dbId = var_7_15
			var_7_13.isSel = false
			var_7_13.lv = 1
			var_7_13.advance = 0

			local var_7_16, var_7_17 = var_0_0.isExclusive(var_7_13)

			var_7_13.isDress = false
			var_7_13.isExc = var_7_17

			table.insert(var_7_1, var_7_13)

			var_7_11 = var_7_11 - var_7_12
			arg_7_0.dataIdx[iter_7_2] = var_7_2
		end
	end

	table.sort(var_7_1, dataEasy.sortHelditemCmp)

	arg_7_0.tableDatas = var_7_1

	arg_7_0.heldItems:update(arg_7_0.tableDatas)
end

function var_0_2.onSureClick(arg_8_0)
	if not arg_8_0.selIdx:read() then
		gGameUI:showTip(gLanguageCsv.meteorSelectHeldItem)

		return
	end

	local var_8_0 = arg_8_0.heldItems:atproxy(arg_8_0.selIdx)

	local function var_8_1()
		gGameApp:requestServer("/game/meteorite/guard/setup", function(arg_10_0)
			if arg_8_0.insetCb then
				arg_8_0:addCallbackOnExit(functools.partial(arg_8_0.insetCb))
				arg_8_0:onClose()
			else
				arg_8_0:onClose()
			end
		end, arg_8_0.index, 2, arg_8_0.pos, var_8_0.dbId[1])
	end

	local var_8_2 = csv.meteorite.base[arg_8_0.index].helditemCDs[arg_8_0.pos] or 0
	local var_8_3 = math.floor(var_8_2 / 3600)
	local var_8_4 = math.floor((var_8_2 - var_8_3 * 3600) / 60)
	local var_8_5 = math.max(var_8_2 - var_8_3 * 3600 - var_8_4 * 60, 0)
	local var_8_6 = string.format(gLanguageCsv.meteorCDTips, var_8_3, var_8_4, var_8_5)
	local var_8_7 = userDefault.getCurrDayKey("HeldItemUp", "first")

	if var_8_7 == "first" then
		var_8_7 = "true"

		userDefault.setCurrDayKey("HeldItemUp", var_8_7)
	end

	if var_8_7 == "true" then
		gGameUI:showDialog({
			selectType = 2,
			clearFast = true,
			btnType = 1,
			selectKey = "HeldItemUp",
			content = var_8_6,
			cb = var_8_1,
			selectTip = gLanguageCsv.todayNoTip
		})
	else
		var_8_1()
	end
end

function var_0_2.onItemClick(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	if arg_11_3.isDress then
		gGameUI:showTip(gLanguageCsv.meteorHeldItemsInDress)

		return
	end

	if arg_11_3.inMeteor then
		gGameUI:showTip(gLanguageCsv.inMeteorites)

		return
	end

	arg_11_0.selIdx:set(arg_11_2.k, true)

	if arg_11_0.heldItems:atproxy(arg_11_2.k) and arg_11_0.heldItems:atproxy(arg_11_2.k).isSel ~= true then
		arg_11_0.heldItems:atproxy(arg_11_2.k).isSel = true
	end
end

function var_0_2.onClose(arg_12_0)
	if arg_12_0.stopActionCb then
		arg_12_0.addCallbackOnExit(arg_12_0, functools.partial(arg_12_0.stopActionCb))
		Dialog.onClose(arg_12_0)
	else
		Dialog.onClose(arg_12_0)
	end
end

return var_0_2
