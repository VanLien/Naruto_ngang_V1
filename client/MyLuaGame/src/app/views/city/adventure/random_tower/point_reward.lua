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

local var_0_1 = class("RandomTowerPointRewardView", Dialog)

var_0_1.RESOURCE_FILENAME = "random_tower_point_reward.json"
var_0_1.RESOURCE_BINDING = {
	["down.textScore"] = "textScore",
	item = "item",
	["down.list"] = "downList",
	["down.textNote"] = "textNote",
	item1 = "item1",
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
					local var_3_0 = arg_3_1:multiget("textScore", "btnGet", "icon", "list", "imgReceived")

					var_3_0.textScore:text(arg_3_3.point)

					if next(arg_3_3.award) ~= nil then
						uiEasy.createItemsToList(arg_3_0, var_3_0.list, arg_3_3.award, {
							scale = 1
						})
					end

					var_3_0.imgReceived:visible(arg_3_3.canReceive == 0)
					var_3_0.btnGet:visible(arg_3_3.canReceive ~= 0)
					bind.touch(arg_3_0, var_3_0.btnGet, {
						methods = {
							ended = functools.partial(arg_3_0.clickCell, arg_3_2, arg_3_3)
						}
					})
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
	}
}

function var_0_1.onCreate(arg_4_0)
	arg_4_0:initModel()

	arg_4_0.pointDatas = idlers.new()

	local var_4_0 = true
	local var_4_1 = false
	local var_4_2 = {}
	local var_4_3 = {}

	arg_4_0.saveGetAward = userDefault.getForeverLocalKey("saveGetAward", {})

	local var_4_4 = userDefault.getForeverLocalKey("isGetAward", {})

	idlereasy.any({
		arg_4_0.resultPointAward,
		arg_4_0.pointAwardVersion
	}, function(arg_5_0, arg_5_1, arg_5_2)
		local var_5_0 = {}
		local var_5_1 = {}

		var_4_2 = {}

		local var_5_2 = false

		for iter_5_0, iter_5_1 in csvPairs(csv.random_tower.point_award) do
			if iter_5_1.version == arg_5_2 then
				if arg_5_1[iter_5_0] == 1 then
					var_4_1 = true
					var_4_2[iter_5_0] = true
				end

				if arg_5_1[iter_5_0] == 0 then
					for iter_5_2, iter_5_3 in csvMapPairs(iter_5_1.award) do
						if not var_5_1[iter_5_2] then
							var_5_1[iter_5_2] = 0
						end

						var_5_1[iter_5_2] = var_5_1[iter_5_2] + iter_5_3
					end

					var_4_0 = false
				end

				var_5_0[iter_5_0] = {
					id = iter_5_0,
					award = iter_5_1.award,
					point = iter_5_1.needPoint,
					canReceive = arg_5_1[iter_5_0] or 0.5
				}

				if arg_4_0.saveGetAward and arg_4_0.saveGetAward[iter_5_0] then
					var_5_2 = true

					if not var_4_2[iter_5_0] then
						var_4_2[iter_5_0] = false
					end
				end
			end
		end

		if var_5_2 then
			arg_4_0.saveGetAward = var_4_2
		end

		local var_5_3 = false

		if var_4_1 and var_4_0 or var_5_2 then
			var_5_3 = true
		end

		if not var_4_1 then
			arg_4_0.saveGetAward = {}
			var_5_3 = false
		end

		arg_4_0.getBtn:visible(var_5_3)
		uiEasy.createItemsToList(arg_4_0, arg_4_0.downList, var_5_1, {
			scale = 0.8
		})
		arg_4_0.pointDatas:update(var_5_0)
	end)

	local var_4_5 = userDefault.getForeverLocalKey("awardState", {})

	if var_4_5 and var_4_5.isOpen or var_4_4 and var_4_4.isOpen then
		if var_4_1 and var_4_0 then
			gGameUI:showDialog({
				btnType = 2,
				title = gLanguageCsv.tips,
				content = gLanguageCsv.etherIntegral,
				cb = function()
					return
				end
			})
			userDefault.setForeverLocalKey("isGetAward", {
				isOpen = true
			})
		else
			userDefault.setForeverLocalKey("isGetAward", {})
		end

		arg_4_0.saveGetAward = var_4_2
	end

	if var_4_5 and var_4_5.isOpen then
		userDefault.setForeverLocalKey("awardState", {})
	end

	local var_4_6 = arg_4_0.dayPoint:read() + arg_4_0.history_point:read() * 0.08

	arg_4_0.textScore:text(math.floor(var_4_6))
	adapt.oneLinePos(arg_4_0.textScore, arg_4_0.textNote, cc.p(20, 0), "left")
	adapt.oneLinePos(arg_4_0.textTitle1, arg_4_0.textTitle2, nil, "left")
	Dialog.onCreate(arg_4_0)
end

function var_0_1.initModel(arg_7_0)
	arg_7_0.resultPointAward = gGameModel.random_tower:getIdler("point_award")
	arg_7_0.dayPoint = gGameModel.random_tower:getIdler("day_point")
	arg_7_0.history_point = gGameModel.random_tower:getIdler("history_point")
	arg_7_0.pointAwardVersion = gGameModel.random_tower:getIdler("point_award_version")
end

function var_0_1.onitemClick(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	arg_8_0:onGetBtn(arg_8_3.id)
end

function var_0_1.onGetBtn(arg_9_0, arg_9_1)
	local var_9_0 = {
		false
	}

	gGameApp:requestServerCustom("/game/random_tower/point/award"):params(arg_9_1):onErrClose(function(arg_10_0)
		if arg_10_0.err ~= "randomTowerPointAwardVersionChange" then
			return false
		end

		gGameApp:requestServerCustom("/game/random_tower/prepare", function(arg_11_0)
			if arg_11_0.view.updata then
				gGameUI:showDialog({
					btnType = 2,
					title = gLanguageCsv.tips,
					content = gLanguageCsv.randomTowerPointAwardVersionChange,
					cb = function()
						return
					end
				})
			end
		end)
	end):onResponse(function(arg_13_0)
		var_9_0[1] = true
	end):wait(var_9_0):doit(function(arg_14_0)
		gGameUI:showGainDisplay(arg_14_0)
		userDefault.setForeverLocalKey("isGetAward", {})
	end)

	if arg_9_1 == -1 then
		arg_9_0.saveGetAward = {}
	else
		arg_9_0.saveGetAward[arg_9_1] = false
	end
end

function var_0_1.onClose(arg_15_0)
	userDefault.setForeverLocalKey("saveGetAward", arg_15_0.saveGetAward)
	Dialog.onClose(arg_15_0)
end

function var_0_1.onSortCards(arg_16_0, arg_16_1)
	return function(arg_17_0, arg_17_1)
		if arg_17_0.canReceive ~= arg_17_1.canReceive then
			return arg_17_0.canReceive > arg_17_1.canReceive
		end

		return arg_17_0.id < arg_17_1.id
	end
end

return var_0_1
