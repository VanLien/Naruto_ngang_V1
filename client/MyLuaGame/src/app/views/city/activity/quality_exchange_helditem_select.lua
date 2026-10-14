local var_0_0 = require("app.views.city.card.helditem.tools")
local var_0_1 = class("ActivityQualityExchangeHelditemSelectView", Dialog)

var_0_1.RESOURCE_FILENAME = "activity_quality_exchange_helditem_select.json"
var_0_1.RESOURCE_BINDING = {
	tipPanel = "tipPanel",
	item = "item",
	title = "title",
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
				columnSize = 6,
				asyncPreload = 24,
				data = bindHelper.self("datas"),
				item = bindHelper.self("innerList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_3.inMeteor and 1 or 0

					uiEasy.addTextEffect1(arg_1_1:get("tips"))
					arg_1_1:get("tips"):text(gLanguageCsv.inMeteor):visible(var_1_0 == 1)

					local var_1_1, var_1_2 = uiEasy.setIconName(arg_1_3.csvId, nil, {
						space = true,
						advance = arg_1_3.advance
					})

					arg_1_1:get("name"):hide()
					arg_1_1:removeChildByName("richName")

					local var_1_3 = beauty.singleTextLimitWord(var_1_1, {
						fontSize = 40
					}, {
						width = 240
					}):xy(arg_1_1:get("name"):xy()):addTo(arg_1_1, 10, "richName")

					text.addEffect(var_1_3, var_1_2)
					bind.extend(arg_1_0, arg_1_1:get("icon"), {
						class = "icon_key",
						props = {
							data = {
								key = arg_1_3.csvId,
								num = arg_1_3.num,
								dbId = arg_1_3.dbId
							},
							specialKey = {
								lv = arg_1_3.lv
							},
							onNode = function(arg_2_0)
								arg_2_0:setTouchEnabled(false)
							end
						}
					})
					bind.touch(arg_1_0, arg_1_1:get("icon"), {
						methods = {
							ended = functools.partial(arg_1_0.itemClick, arg_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.qualities = arg_3_1
	arg_3_0.cb = arg_3_2
	arg_3_0.datas = idlers.new()
	arg_3_0.resetHelditem = idler.new()

	local var_3_0 = {}
	local var_3_1 = 0

	idlereasy.any({
		gGameModel.role:getIdler("held_items"),
		arg_3_0.resetHelditem
	}, function(arg_4_0, arg_4_1)
		var_3_0 = {}
		var_3_1 = itertools.size(arg_4_1)

		for iter_4_0, iter_4_1 in pairs(arg_4_1) do
			local var_4_0 = gGameModel.held_items:find(iter_4_1)

			if var_4_0 then
				local var_4_1 = var_4_0:multigetIdler("exist_flag", "card_db_id", "advance", "level", "sum_exp", "held_item_id")

				idlereasy.any(var_4_1, function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
					var_3_0[iter_4_1] = true

					if itertools.size(var_3_0) == var_3_1 then
						arg_3_0.datas:update(arg_3_0:getData())
					end
				end):anonyOnly(arg_3_0, stringz.bintohex(iter_4_1))
			end
		end
	end)
	arg_3_0.tipPanel:visible(itertools.size(arg_3_0.datas) == 0)
	Dialog.onCreate(arg_3_0)
end

function var_0_1.getData(arg_6_0)
	local var_6_0 = dataEasy.getInMeteorHelditemsHash()
	local var_6_1 = gGameModel.role:read("held_items")
	local var_6_2 = {}
	local var_6_3 = {}

	for iter_6_0, iter_6_1 in pairs(var_6_1) do
		local var_6_4 = gGameModel.held_items:find(iter_6_1):read("exist_flag", "card_db_id", "advance", "level", "sum_exp", "held_item_id")

		if var_6_4.exist_flag then
			local var_6_5 = var_6_4.held_item_id
			local var_6_6 = dataEasy.getCfgByKey(var_6_5)

			if arg_6_0.qualities[var_6_6.quality] then
				if not var_6_0[iter_6_1] and var_6_4.sum_exp == 0 and var_6_4.advance == 0 and not var_6_4.card_db_id then
					if not var_6_2[var_6_5] then
						var_6_2[var_6_5] = {
							num = 0,
							cfg = var_6_6,
							dbId = iter_6_1
						}
					end

					var_6_2[var_6_5].num = var_6_2[var_6_5].num + 1
				else
					local var_6_7 = {
						isSpecial = true,
						num = 1,
						cfg = var_6_6,
						csvId = var_6_5,
						dbId = iter_6_1,
						lv = var_6_4.level,
						cardDbID = var_6_4.card_db_id,
						advance = var_6_4.advance,
						inMeteor = var_6_0[iter_6_1]
					}
					local var_6_8, var_6_9 = var_0_0.isExclusive(var_6_7)

					var_6_7.isDress = var_6_8
					var_6_7.isExc = var_6_9

					table.insert(var_6_3, var_6_7)
				end
			end
		end
	end

	for iter_6_2, iter_6_3 in pairs(var_6_2) do
		local var_6_10 = iter_6_3.num
		local var_6_11 = iter_6_3.cfg.stackShow

		for iter_6_4 = 1, math.ceil(var_6_10 / var_6_11) do
			local var_6_12 = {
				advance = 0,
				lv = 1,
				num = math.min(var_6_11, var_6_10),
				cfg = iter_6_3.cfg,
				csvId = iter_6_2,
				dbId = iter_6_3.dbId
			}
			local var_6_13, var_6_14 = var_0_0.isExclusive(var_6_12)

			var_6_12.isDress = var_6_13
			var_6_12.isExc = var_6_14

			table.insert(var_6_3, var_6_12)

			var_6_10 = var_6_10 - var_6_11
		end
	end

	table.sort(var_6_3, dataEasy.sortHelditemCmp)

	return var_6_3
end

function var_0_1.onResetHelditem(arg_7_0, arg_7_1)
	arg_7_0.resetHelditem:notify()
end

function var_0_1.onItemClick(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if arg_8_3.inMeteor then
		gGameUI:showTip(gLanguageCsv.inMeteorites)

		return
	end

	if arg_8_3.isDress then
		gGameUI:showDialog({
			btnType = 2,
			isRich = true,
			cb = function()
				gGameUI:stackUI("city.card.helditem.bag", nil, nil, arg_8_3.cardDbID, arg_8_0:createHandler("onResetHelditem"))
			end,
			content = string.format(gLanguageCsv.qualityExchangeHelditemSelectTip2, ui.QUALITYCOLOR[arg_8_3.cfg.quality], uiEasy.setIconName(arg_8_3.csvId, nil, {
				space = true,
				advance = arg_8_3.advance
			}))
		})

		return
	end

	if arg_8_3.isSpecial then
		gGameUI:showDialog({
			btnType = 2,
			isRich = true,
			cb = function()
				gGameUI:stackUI("city.card.rebirth.view", nil, {
					full = true
				}, 3, nil, nil, {
					heldItemId = arg_8_3.dbId
				})
			end,
			content = string.format(gLanguageCsv.qualityExchangeHelditemSelectTip1, ui.QUALITYCOLOR[arg_8_3.cfg.quality], uiEasy.setIconName(arg_8_3.csvId, nil, {
				space = true,
				advance = arg_8_3.advance
			}))
		})

		return
	end

	if arg_8_0.cb then
		arg_8_0.cb(arg_8_3.dbId)
	end

	arg_8_0:onClose()
end

return var_0_1
