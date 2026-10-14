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

var_0_1.RESOURCE_FILENAME = "horse_race_point_reward.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	["down.textNote"] = "downTextNote",
	["title.textTitle1"] = "textTitle1",
	["down.textPoint"] = "textPoint",
	down = "down",
	["title.textTitle2"] = "textTitle2",
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

					var_2_0.textScore:text(arg_2_3.point)

					if next(arg_2_3.award) ~= nil then
						uiEasy.createItemsToList(arg_2_0, var_2_0.list, arg_2_3.award, {
							scale = 0.9
						})
					end

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
	},
	["down.textScore"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("resultPoint")
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1)
	arg_3_0.activityId = arg_3_1

	arg_3_0:initModel()

	arg_3_0.pointDatas = idlers.new()

	idlereasy.when(arg_3_0.yyhuodongs, function(arg_4_0, arg_4_1)
		local var_4_0 = arg_4_1[arg_3_1]
		local var_4_1 = var_4_0.horse_race.point_award or {}
		local var_4_2 = var_4_0.horse_race.point or 0
		local var_4_3 = {}
		local var_4_4 = false

		for iter_4_0, iter_4_1 in csvPairs(csv.yunying.horse_race_point_award) do
			if var_4_1[iter_4_0] == 1 then
				local var_4_5 = true
			end

			var_4_3[iter_4_0] = {
				id = iter_4_0,
				award = iter_4_1.award,
				point = iter_4_1.point,
				canReceive = var_4_1[iter_4_0] or 0.5
			}
		end

		dataEasy.tryCallFunc(arg_3_0.list, "updatePreloadCenterIndex")
		arg_3_0.pointDatas:update(var_4_3)
		arg_3_0.textPoint:text(string.format(gLanguageCsv.horseRacePoint, var_4_2))
	end)
	adapt.oneLinePos(arg_3_0.textTitle1, arg_3_0.textTitle2, nil, "left")
	Dialog.onCreate(arg_3_0)
end

function var_0_1.initModel(arg_5_0)
	arg_5_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
end

function var_0_1.onitemClick(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_0:onGetBtn(arg_6_3.id)
end

function var_0_1.onGetBtn(arg_7_0, arg_7_1)
	gGameApp:requestServer("/game/yy/horse/race/point/award", function(arg_8_0)
		gGameUI:showGainDisplay(arg_8_0)
	end, arg_7_0.activityId, arg_7_1)
end

function var_0_1.onSortCards(arg_9_0, arg_9_1)
	return function(arg_10_0, arg_10_1)
		if arg_10_0.canReceive ~= arg_10_1.canReceive then
			return arg_10_0.canReceive > arg_10_1.canReceive
		end

		return arg_10_0.id < arg_10_1.id
	end
end

return var_0_1
