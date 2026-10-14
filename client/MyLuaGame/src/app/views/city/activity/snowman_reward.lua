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

local var_0_1 = class("ActivitySnowmanRewardView", Dialog)

var_0_1.RESOURCE_FILENAME = "activity_snowman_reward.json"
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
				ended = bindHelper.self("onOneKey")
			}
		}
	},
	["down.btnGet.textNote"] = {
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
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("textScore", "btnGet", "icon", "list")

					var_2_0.textScore:text(arg_2_3.level)
					uiEasy.createItemsToList(arg_2_0, var_2_0.list, arg_2_3.award, {
						scale = 0.9
					})
					bind.touch(arg_2_0, var_2_0.btnGet, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3)
						}
					})
					var_2_0.btnGet:get("textNote"):text(arg_2_3.canReceive == 0 and gLanguageCsv.received or gLanguageCsv.spaceReceive)
					var_0_0(var_2_0.btnGet, arg_2_3.canReceive == 1)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onitemClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1)
	arg_3_0:initModel()

	arg_3_0.activityId = arg_3_1

	local var_3_0 = csv.yunying.yyhuodong[arg_3_1].huodongID
	local var_3_1 = {}

	idlereasy.when(arg_3_0.yyhuodongs, function(arg_4_0, arg_4_1)
		local var_4_0 = arg_3_0.yyhuodongs:read()[arg_3_1] or {}

		arg_3_0.yyData = var_4_0

		local var_4_1 = var_4_0.stamps

		arg_3_0.param = var_4_1

		local var_4_2 = false

		for iter_4_0, iter_4_1 in orderCsvPairs(csv.yunying.huodongcloth_level) do
			if iter_4_1.huodongID == var_3_0 and next(iter_4_1.award) ~= nil then
				if var_4_1[iter_4_0] == 1 then
					var_4_2 = true
				end

				var_3_1[iter_4_0] = {
					id = iter_4_0,
					award = iter_4_1.award,
					level = iter_4_1.level,
					canReceive = var_4_1[iter_4_0] or 0.5
				}
			end
		end

		dataEasy.tryCallFunc(arg_3_0.list, "updatePreloadCenterIndex")
		arg_3_0.pointDatas:update(var_3_1)
		var_0_0(arg_3_0.getBtn, var_4_2)
		adapt.oneLinePos(arg_3_0.textTitle1, arg_3_0.textTitle2, nil, "left")
	end)
	Dialog.onCreate(arg_3_0)
end

function var_0_1.initModel(arg_5_0)
	arg_5_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_5_0.pointDatas = idlers.new()
end

function var_0_1.onitemClick(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_0:onGetBtn(arg_6_3.id)
end

function var_0_1.onGetBtn(arg_7_0, arg_7_1)
	gGameApp:requestServer("/game/yy/award/get", function(arg_8_0)
		arg_7_0.pointDatas:atproxy(arg_7_1).canReceive = 0

		gGameUI:showGainDisplay(arg_8_0)
	end, arg_7_0.activityId, arg_7_1)
end

function var_0_1.onOneKey(arg_9_0)
	gGameApp:requestServer("/game/yy/award/get/onekey", function(arg_10_0)
		gGameUI:showGainDisplay(arg_10_0)
	end, arg_9_0.activityId)
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
