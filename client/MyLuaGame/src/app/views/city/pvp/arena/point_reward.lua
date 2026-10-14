local function var_0_0(arg_1_0, arg_1_1)
	arg_1_0:setTouchEnabled(arg_1_1)
	cache.setShader(arg_1_0, false, arg_1_1 and "normal" or "hsl_gray")

	if arg_1_1 then
		text.addEffect(arg_1_0:get("textNote"), {
			glow = {
				color = ui.COLORS.GLOW.WHITE
			}
		})
	else
		text.deleteAllEffect(arg_1_0:get("textNote"))
		text.addEffect(arg_1_0:get("textNote"), {
			color = ui.COLORS.DISABLED.WHITE
		})
	end
end

local var_0_1 = class("ArenaPointRewardView", Dialog)

var_0_1.RESOURCE_FILENAME = "arena_point_reward.json"
var_0_1.RESOURCE_BINDING = {
	item1 = "item1",
	item = "item",
	["down.textNote"] = "downTextNote",
	down = "down",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["title.textTitle1"] = {
		varname = "textTitle1",
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
	["title.textTitle2"] = {
		varname = "textTitle2",
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
	["down.btnGet"] = {
		varname = "getBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_2_0)
					return arg_2_0:onGetBtn(-1)
				end)
			}
		}
	},
	["down.btnGet.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["item.btnGet.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
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
				data = bindHelper.self("pointDatas"),
				item = bindHelper.self("item"),
				dataOrderCmpGen = bindHelper.self("onSortCards", true),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:multiget("textScore", "btnGet", "icon", "list")

					var_3_0.textScore:text(arg_3_3.point)

					if next(arg_3_3.award) ~= nil then
						uiEasy.createItemsToList(arg_3_0, var_3_0.list, arg_3_3.award, {
							scale = 0.9
						})
					end

					bind.touch(arg_3_0, var_3_0.btnGet, {
						methods = {
							ended = functools.partial(arg_3_0.clickCell, arg_3_2, arg_3_3)
						}
					})
					var_3_0.btnGet:get("textNote"):text(arg_3_3.canReceive == 0 and gLanguageCsv.received or gLanguageCsv.spaceReceive)
					var_0_0(var_3_0.btnGet, arg_3_3.canReceive == 1)

					if arg_3_3.canReceive == 1 then
						text.addEffect(var_3_0.btnGet:get("textNote"), {
							outline = {
								size = 4,
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							}
						})
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onitemClick")
			}
		}
	},
	["down.textScore"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("resultPoint")
		}
	}
}

function var_0_1.onCreate(arg_4_0)
	arg_4_0.downTextNote:hide()

	local var_4_0, var_4_1 = arg_4_0.downTextNote:xy()
	local var_4_2 = rich.createWithWidth(gLanguageCsv.rankPointRule, 30, nil, 1250):addTo(arg_4_0.down, 10):anchorPoint(cc.p(0, 0.5)):xy(var_4_0 - 13, var_4_1):formatText()

	arg_4_0:initModel()

	arg_4_0.pointDatas = idlers.new()

	idlereasy.when(arg_4_0.resultPointAward, function(arg_5_0, arg_5_1)
		local var_5_0 = {}
		local var_5_1 = false

		for iter_5_0, iter_5_1 in csvPairs(csv.pwpoint_award) do
			if arg_5_1[iter_5_0] == 1 then
				var_5_1 = true
			end

			var_5_0[iter_5_0] = {
				id = iter_5_0,
				award = iter_5_1.award,
				point = iter_5_1.needPoint,
				canReceive = arg_5_1[iter_5_0] or 0.5
			}
		end

		dataEasy.tryCallFunc(arg_4_0.list, "updatePreloadCenterIndex")
		arg_4_0.pointDatas:update(var_5_0)
		var_0_0(arg_4_0.getBtn, var_5_1)

		if var_5_1 then
			text.addEffect(arg_4_0.getBtn:get("textNote"), {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
		end
	end)
	adapt.oneLinePos(arg_4_0.textTitle1, arg_4_0.textTitle2, nil, "left")
	Dialog.onCreate(arg_4_0)
end

function var_0_1.initModel(arg_6_0)
	arg_6_0.resultPointAward = gGameModel.daily_record:getIdler("result_point_award")
	arg_6_0.resultPoint = gGameModel.daily_record:getIdler("pvp_result_point")
end

function var_0_1.onitemClick(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	arg_7_0:onGetBtn(arg_7_3.id)
end

function var_0_1.onGetBtn(arg_8_0, arg_8_1)
	gGameApp:requestServer("/game/pw/battle/point/award", function(arg_9_0)
		gGameUI:showGainDisplay(arg_9_0)
	end, arg_8_1)
end

function var_0_1.onSortCards(arg_10_0, arg_10_1)
	return function(arg_11_0, arg_11_1)
		if arg_11_0.canReceive ~= arg_11_1.canReceive then
			return arg_11_0.canReceive > arg_11_1.canReceive
		end

		return arg_11_0.id > arg_11_1.id
	end
end

return var_0_1
