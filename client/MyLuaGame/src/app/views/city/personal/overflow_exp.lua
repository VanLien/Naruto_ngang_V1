local var_0_0 = class("OverflowExpView", Dialog)

var_0_0.RESOURCE_FILENAME = "personal_overflow_experience.json"
var_0_0.RESOURCE_BINDING = {
	item = "item",
	centre = "centre",
	["up.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["item.dhBtn.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["up.title2"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	["up.title1"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				data = bindHelper.self("tableDat"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				dataOrderCmp = function(arg_1_0, arg_1_1)
					local var_1_0 = false
					local var_1_1 = false

					if arg_1_0.sum_exp and arg_1_0.sum_exp[arg_1_0.k] and arg_1_0.limit - arg_1_0.sum_exp[arg_1_0.k] == 0 then
						var_1_0 = true
					end

					if arg_1_1.sum_exp and arg_1_1.sum_exp[arg_1_1.k] and arg_1_1.limit - arg_1_1.sum_exp[arg_1_1.k] == 0 then
						var_1_1 = true
					end

					if var_1_0 then
						return false
					elseif var_1_1 then
						return true
					else
						return arg_1_0.sort < arg_1_1.sort
					end
				end,
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("expNumber", "icon", "dhNumber", "dh", "dhBtn", "list")

					var_2_0.expNumber:text(arg_2_3.needExp)
					var_2_0.icon:hide()
					uiEasy.createItemsToList(arg_2_0, var_2_0.list, arg_2_3.award)

					local var_2_1 = false

					local function var_2_2()
						var_2_0.dhNumber:setTextColor(ui.COLORS.NORMAL.DEFAULT)
						uiEasy.setBtnShader(var_2_0.dhBtn, var_2_0.dhBtn:get("textNote"), 2)
						text.deleteAllEffect(var_2_0.dhBtn:get("textNote"))
					end

					if arg_2_3.limit == 0 then
						var_2_0.dhNumber:visible(false)
						var_2_0.dh:visible(false)
						var_2_0.dhBtn:y(122)
					else
						if arg_2_3.sum_exp and arg_2_3.sum_exp[arg_2_2] then
							local var_2_3 = arg_2_3.limit - arg_2_3.sum_exp[arg_2_2]

							var_2_3 = var_2_3 < 0 and 0 or var_2_3

							var_2_0.dhNumber:text(var_2_3 .. "/" .. arg_2_3.limit)

							if var_2_3 == 0 then
								var_2_2()

								var_2_1 = true
							end
						else
							var_2_0.dhNumber:text(arg_2_3.limit .. "/" .. arg_2_3.limit)
						end

						var_2_0.dh:x(var_2_0.dhNumber:x() - var_2_0.dhNumber:width() - 10)
					end

					if arg_2_3.role_exp:read() < arg_2_3.needExp and not var_2_1 then
						var_2_2()
					end

					bind.touch(arg_2_0, var_2_0.dhBtn, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("btnClick")
			}
		}
	},
	["centre.title3"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "overflow_exp")
		}
	}
}

function var_0_0.onCreate(arg_4_0)
	arg_4_0:initModel()
	arg_4_0.item:visible(false)
	arg_4_0.list:setScrollBarEnabled(false)

	local var_4_0 = arg_4_0:filtrateData()

	arg_4_0.tableDat = idlers.newWithMap(var_4_0)

	adapt.oneLineCenterPos(cc.p(540, 31), {
		arg_4_0.centre:get("title"),
		arg_4_0.centre:get("icon"),
		arg_4_0.centre:get("title4"),
		arg_4_0.centre:get("title2"),
		arg_4_0.centre:get("icon2"),
		arg_4_0.centre:get("title5"),
		arg_4_0.centre:get("title3")
	}, cc.p(6, 0))
	Dialog.onCreate(arg_4_0)
end

function var_0_0.filtrateData(arg_5_0)
	local var_5_0 = {}

	for iter_5_0, iter_5_1 in ipairs(csv.overflow_exp_exchange) do
		table.insert(var_5_0, {
			needExp = iter_5_1.needExp,
			limit = iter_5_1.limit,
			sort = iter_5_1.sort,
			award = iter_5_1.award,
			sum_exp = arg_5_0.sum_exp:read(),
			role_exp = arg_5_0.role_exp,
			k = iter_5_0
		})
	end

	return var_5_0
end

function var_0_0.initModel(arg_6_0)
	arg_6_0.sum_exp = gGameModel.role:getIdler("overflow_exp_exchanges")
	arg_6_0.role_exp = gGameModel.role:getIdler("overflow_exp")
end

function var_0_0.btnClick(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0, var_7_1 = csvNext(arg_7_3.award)
	local var_7_2 = arg_7_3.limit

	if arg_7_3.sum_exp and arg_7_3.sum_exp[arg_7_2] then
		var_7_2 = arg_7_3.limit - arg_7_3.sum_exp[arg_7_2]
		var_7_2 = var_7_2 < 0 and 0 or var_7_2
	end

	local var_7_3 = var_7_2 ~= 0 and var_7_2 or nil

	arg_7_0.csvId = arg_7_2
	arg_7_0.award = arg_7_3.award

	gGameUI:stackUI("common.buy_info", nil, nil, {
		overflow_exp = arg_7_3.needExp
	}, {
		id = var_7_0,
		num = var_7_1
	}, {
		contentType = "num",
		maxNum = var_7_3
	}, arg_7_0:createHandler("updateDate"))
end

function var_0_0.updateDate(arg_8_0, arg_8_1)
	gGameApp:requestServer("/game/role/overflow_exp_exchange", function(arg_9_0)
		local function var_9_0()
			local var_10_0 = arg_8_0:filtrateData()

			dataEasy.tryCallFunc(arg_8_0.list, "updatePreloadCenterIndex")
			arg_8_0.tableDat:update(var_10_0)
		end

		gGameUI:showGainDisplay(arg_9_0.view, {
			raw = true,
			var_9_0()
		})
	end, arg_8_0.csvId, arg_8_1)
end

return var_0_0
