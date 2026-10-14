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

var_0_1.RESOURCE_FILENAME = "activity_duanwu_proficiency.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	["title.textTitle1"] = "textTitle1",
	down = "down",
	["title.textTitle2"] = "textTitle2",
	item1 = "item1",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["down.btnGet"] = {
		varname = "getBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_2_0)
					return arg_2_0:onGetBtn()
				end)
			}
		}
	},
	["down.btnGet.textNote"] = {
		varname = "textNote",
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
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
								size = 1,
								color = ui.NEWCOLORS.OUTLINE.YELLOW1
							}
						})
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onitemClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_4_0, arg_4_1)
	arg_4_0.activityID = arg_4_1

	arg_4_0.item:visible(false)
	arg_4_0.item1:visible(false)
	arg_4_0:initModel()

	arg_4_0.pointDatas = idlers.newWithMap({})

	local var_4_0 = csv.yunying.yyhuodong[arg_4_1].huodongID

	idlereasy.when(arg_4_0.yyhuodongs, function(arg_5_0, arg_5_1)
		local var_5_0 = {}
		local var_5_1 = false
		local var_5_2 = 0.5
		local var_5_3 = 0

		if arg_5_1[arg_4_1] and arg_5_1[arg_4_1].info then
			var_5_3 = arg_5_1[arg_4_1].info.counter
		end

		arg_4_0.down:get("num"):text(var_5_3)

		for iter_5_0, iter_5_1 in orderCsvPairs(csv.yunying.bao_zongzi_task) do
			if iter_5_1.huodongID == var_4_0 then
				local var_5_4 = 0.5

				if arg_5_1[arg_4_1] and arg_5_1[arg_4_1].stamps then
					if arg_5_1[arg_4_1].stamps[iter_5_0] == 1 then
						var_5_1 = true
					end

					var_5_4 = arg_5_1[arg_4_1].stamps[iter_5_0]

					if var_5_4 ~= 0 and var_5_4 ~= 1 then
						var_5_4 = 0.5
					end
				end

				var_5_0[iter_5_0] = {
					id = iter_5_0,
					award = iter_5_1.award,
					point = iter_5_1.taskParam,
					canReceive = var_5_4
				}

				dataEasy.tryCallFunc(arg_4_0.list, "updatePreloadCenterIndex")
				arg_4_0.pointDatas:update(var_5_0)
				var_0_0(arg_4_0.getBtn, var_5_1)

				if var_5_1 then
					text.addEffect(arg_4_0.getBtn:get("textNote"), {
						outline = {
							size = 1,
							color = ui.NEWCOLORS.OUTLINE.YELLOW1
						}
					})
				end
			end
		end
	end)
	adapt.oneLinePos(arg_4_0.textTitle1, arg_4_0.textTitle2, nil, "left")
	Dialog.onCreate(arg_4_0)
end

function var_0_1.initModel(arg_6_0)
	arg_6_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
end

function var_0_1.onitemClick(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	gGameApp:requestServer("/game/yy/award/get", function(arg_8_0)
		gGameUI:showGainDisplay(arg_8_0)
	end, arg_7_0.activityID, arg_7_3.id)
end

function var_0_1.onGetBtn(arg_9_0)
	gGameApp:requestServer("/game/yy/award/get/onekey", function(arg_10_0)
		gGameUI:showGainDisplay(arg_10_0)
	end, arg_9_0.activityID)
end

function var_0_1.onSortCards(arg_11_0, arg_11_1)
	return function(arg_12_0, arg_12_1)
		if arg_12_0.canReceive ~= arg_12_1.canReceive then
			return arg_12_0.canReceive > arg_12_1.canReceive
		end

		return arg_12_0.id < arg_12_1.id
	end
end

return var_0_1
