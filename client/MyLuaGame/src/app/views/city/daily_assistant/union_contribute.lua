local var_0_0 = class("UnionContribInfoView", Dialog)

var_0_0.RESOURCE_FILENAME = "daily_assistant_union_contribute.json"
var_0_0.RESOURCE_BINDING = {
	imgBG = "imgBg",
	item = "item",
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
				data = bindHelper.self("itemDatas"),
				item = bindHelper.self("item"),
				vip = bindHelper.self("vip"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("textTitle", "info1", "info2", "cost", "btnOk")

					var_1_0.textTitle:text(gLanguageCsv[arg_1_3.cfg.title])
					var_1_0.info1:get("textAddNum"):text("+" .. arg_1_3.cfg.contrib)

					local var_1_1, var_1_2 = csvNext(arg_1_3.cfg.award)

					var_1_0.info2:get("textAddNum"):text("+" .. var_1_2)

					local var_1_3, var_1_4 = csvNext(arg_1_3.cfg.cost)
					local var_1_5 = var_1_0.cost:get("textNum")

					var_1_5:text(var_1_4)

					local var_1_6 = dataEasy.getNumByKey(var_1_3)
					local var_1_7 = ui.NEWCOLORS.BROWN1

					if not arg_1_3.isEnough then
						var_1_7 = ui.COLORS.NORMAL.RED
					end

					text.addEffect(var_1_5, {
						color = var_1_7
					})

					local var_1_8 = var_1_0.cost:get("imgIcon")

					var_1_8:texture(dataEasy.getIconResByKey(var_1_3))
					adapt.oneLineCenterPos(cc.p(150, 35), {
						var_1_0.cost:get("textNote"),
						var_1_5,
						var_1_8
					}, cc.p(6, 0))

					local var_1_9 = arg_1_0.vip:read() >= arg_1_3.cfg.vipNeed

					if not var_1_9 then
						var_1_0.btnOk:get("textNote"):text(string.format(gLanguageCsv.vipCanUse, arg_1_3.cfg.vipNeed))

						if matchLanguage({
							"kr"
						}) then
							var_1_0.btnOk:get("textNote"):setFontSize(38)
						end
					end

					cache.setShader(var_1_0.btnOk, false, arg_1_3.canContrubute and var_1_9 and "normal" or "hsl_gray")

					if arg_1_3.canContrubute and var_1_9 then
						text.addEffect(var_1_0.btnOk:get("textNote"), {
							outline = {
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							}
						})
					else
						text.deleteAllEffect(var_1_0.btnOk:get("textNote"))
						text.addEffect(var_1_0.btnOk:get("textNote"), {
							color = ui.COLORS.DISABLED.WHITE
						})
					end

					bind.touch(arg_1_0, var_1_0.btnOk, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3)
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

function var_0_0.onCreate(arg_2_0, arg_2_1)
	arg_2_0.callBack = arg_2_1.callBack

	arg_2_0.list:setName("contribInfoList")
	arg_2_0:initModel()

	arg_2_0.unionExpPro = idler.new(0)
	arg_2_0.todayExpPro = idler.new(0)
	arg_2_0.todayExp = idler.new("")
	arg_2_0.unionCurLvExp = idler.new("")
	arg_2_0.leftCount = idler.new("")

	local var_2_0 = {}

	for iter_2_0, iter_2_1 in orderCsvPairs(csv.union.contrib) do
		local var_2_1 = {
			cfg = iter_2_1,
			csvId = iter_2_0
		}

		var_2_1.canContrubute = true

		local var_2_2, var_2_3 = csvNext(var_2_1.cfg.cost)
		local var_2_4 = dataEasy.getNumByKey(var_2_2)

		if var_2_2 == "gold" then
			var_2_1.isEnough = var_2_3 <= var_2_4
		elseif var_2_2 == "rmb" then
			var_2_1.isEnough = var_2_3 <= var_2_4
		end

		table.insert(var_2_0, var_2_1)
	end

	arg_2_0.itemDatas = idlers.newWithMap(var_2_0)

	idlereasy.any({
		arg_2_0.gold,
		arg_2_0.rmb
	}, function(arg_3_0, arg_3_1, arg_3_2)
		for iter_3_0, iter_3_1 in ipairs(var_2_0) do
			local var_3_0, var_3_1 = csvNext(iter_3_1.cfg.cost)

			if var_3_0 == "gold" then
				arg_2_0.itemDatas:atproxy(iter_3_0).isEnough = var_3_1 <= arg_3_1
			elseif var_3_0 == "rmb" then
				arg_2_0.itemDatas:atproxy(iter_3_0).isEnough = var_3_1 <= arg_3_2
			end
		end
	end)

	if arg_2_0.imgBg:get("privilege") then
		arg_2_0.imgBg:get("privilege"):removeSelf()
	end

	Dialog.onCreate(arg_2_0)
end

function var_0_0.initModel(arg_4_0)
	local var_4_0 = gGameModel.union

	arg_4_0.vip = gGameModel.role:getIdler("vip_level")
	arg_4_0.unionLv = var_4_0:getIdler("level")
	arg_4_0.unionDayExp = var_4_0:getIdler("day_contrib")
	arg_4_0.unionExp = var_4_0:getIdler("contrib")
	arg_4_0.contribCount = gGameModel.daily_record:getIdler("union_contrib_times")
	arg_4_0.gold = gGameModel.role:getIdler("gold")
	arg_4_0.rmb = gGameModel.role:getIdler("rmb")
end

function var_0_0.onItemClick(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if arg_5_0.vip:read() < arg_5_3.cfg.vipNeed then
		return
	end

	arg_5_0.callBack(arg_5_3.csvId, function()
		arg_5_0:onClose()
	end)
end

return var_0_0
