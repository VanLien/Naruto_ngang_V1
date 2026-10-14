local var_0_0 = class("GemRebirth", Dialog)

local function var_0_1(arg_1_0, arg_1_1)
	if gGameModel.gems:find(arg_1_1):read("card_db_id") then
		ccui.ImageView:create("city/card/helditem/bag/icon_cd.png"):align(cc.p(0.5, 0.5), 40, 30):addTo(arg_1_0, 9999, "isEquiped"):xy(150, 150)
	end
end

var_0_0.RESOURCE_FILENAME = "rebirth_gem.json"
var_0_0.RESOURCE_BINDING = {
	item = "item",
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
				topPadding = 10,
				leftPadding = 10,
				columnSize = 6,
				data = bindHelper.self("showData"),
				item = bindHelper.self("innerList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					arg_2_1:get("name"):text(arg_2_3.cfg.name)
					arg_2_1:get("name"):color(ui.COLORS.QUALITY[arg_2_3.cfg.quality])
					var_0_1(arg_2_1, arg_2_3.dbid)
					bind.extend(arg_2_0, arg_2_1, {
						class = "icon_key",
						props = {
							noListener = true,
							data = {
								key = arg_2_3.id,
								num = arg_2_3.num,
								dbId = arg_2_3.dbid
							},
							specialKey = {
								leftTopLv = arg_2_3.level
							},
							onNode = function(arg_3_0)
								bind.click(arg_2_0, arg_3_0, {
									method = functools.partial(arg_2_0.itemClick, arg_2_2, arg_2_3)
								})
							end
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	["title.textNote1"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE1
				}
			}
		}
	},
	["title.textNote2"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE1
				}
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

function var_0_0.onCreate(arg_4_0, arg_4_1)
	arg_4_0.item:visible(false)
	arg_4_0.list:setScrollBarEnabled(false)
	arg_4_0.innerList:setScrollBarEnabled(false)

	arg_4_0.showData = idlers.new({})
	arg_4_0.handlers = arg_4_1.handlers

	local var_4_0 = {}
	local var_4_1 = {}

	arg_4_0.showTip = idler.new(false)

	local var_4_2 = gGameModel.role:read("gems")

	for iter_4_0, iter_4_1 in pairs(var_4_2) do
		local var_4_3 = gGameModel.gems:find(iter_4_1)
		local var_4_4 = var_4_3:read("gem_id")
		local var_4_5 = var_4_3:read("level")

		if var_4_5 >= 2 then
			local var_4_6 = {
				num = 1,
				id = var_4_4,
				cfg = dataEasy.getCfgByKey(var_4_4),
				level = var_4_5,
				dbid = iter_4_1,
				cardDbId = var_4_3:read("card_db_id")
			}

			if var_4_5 == 1 then
				if not var_4_1[var_4_4] then
					var_4_6.dbids = {
						iter_4_1
					}
					var_4_1[var_4_4] = var_4_6

					table.insert(var_4_0, var_4_6)
				else
					table.insert(var_4_1[var_4_4].dbids, iter_4_1)

					var_4_1[var_4_4].num = var_4_1[var_4_4].num + 1
				end
			else
				table.insert(var_4_0, var_4_6)
			end
		end
	end

	table.sort(var_4_0, function(arg_5_0, arg_5_1)
		if (arg_5_0.cardDbId == nil or arg_5_1.cardDbId == nil) and arg_5_0.cardDbId ~= arg_5_1.cardDbId then
			return arg_5_0.cardDbId == nil
		end

		if arg_5_0.cfg.quality ~= arg_5_1.cfg.quality then
			return arg_5_0.cfg.quality > arg_5_1.cfg.quality
		end

		if arg_5_0.cfg.suitID ~= arg_5_1.cfg.suitID then
			return arg_5_0.cfg.suitID < arg_5_1.cfg.suitID
		end

		if arg_5_0.cfg.suitNo ~= arg_5_1.cfg.suitNo then
			return arg_5_0.cfg.suitNo < arg_5_1.cfg.suitNo
		end

		return arg_5_0.level > arg_5_1.level
	end)
	arg_4_0.showData:update(var_4_0)
	arg_4_0.showTip:set(#var_4_0 == 0)
	Dialog.onCreate(arg_4_0)
end

function var_0_0.onItemClick(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local function var_6_0()
		if arg_6_0.handlers then
			arg_6_0.handlers(arg_6_3.dbid)
		end

		arg_6_0:onClose()
	end

	local var_6_1 = gGameModel.gems:find(arg_6_3.dbid)

	if var_6_1:read("card_db_id") then
		local var_6_2 = uiEasy.getCardName(var_6_1:read("card_db_id"))
		local var_6_3 = string.format(gLanguageCsv.inlayCard, var_6_2)

		gGameUI:showDialog({
			isRich = true,
			btnType = 2,
			cb = var_6_0,
			content = var_6_3
		})
	else
		var_6_0()
	end
end

return var_0_0
