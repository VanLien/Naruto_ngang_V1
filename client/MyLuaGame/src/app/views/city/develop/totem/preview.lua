local var_0_0 = class("TotemProView", cc.load("mvc").ViewBase)
local var_0_1 = {
	item = gLanguageCsv.textReward,
	desc = gLanguageCsv.rmbDrawRate,
	quality3 = gLanguageCsv.totemPreviewType3,
	quality4 = gLanguageCsv.totemPreviewType4,
	quality5 = gLanguageCsv.totemPreviewType5,
	quality6 = gLanguageCsv.totemPreviewType6,
	quality7 = gLanguageCsv.totemPreviewType6
}
local var_0_2 = {
	rarityUnknow1 = ui.COLORS.QUALITY[3],
	rarityUnknow2 = ui.COLORS.QUALITY[4],
	rarityUnknow3 = ui.COLORS.QUALITY[5],
	rarityUnknow4 = ui.COLORS.QUALITY[7],
	normalItem = ui.COLORS.QUALITY[1]
}

var_0_0.RESOURCE_FILENAME = "totem_preview.json"
var_0_0.RESOURCE_BINDING = {
	["mid.bottom"] = "bottom",
	["mid.proItem"] = "proItem",
	["mid.totemItem"] = "totemItem",
	["mid.innerPanel"] = "innerPanel",
	["mid.list"] = {
		vername = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("datas"),
				item = bindHelper.self("innerPanel"),
				totemItem = bindHelper.self("totemItem"),
				proItem = bindHelper.self("proItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("title"):hide()
					arg_1_1:get("totemList"):hide()

					if arg_1_3.type == "title" then
						local var_1_0 = arg_1_1:get("title"):show()

						arg_1_1:height(var_1_0:height())
						var_1_0:get("txt"):text(var_0_1[arg_1_3.title]):y(var_1_0:height() / 2)
						adapt.oneLineCenter(var_1_0:get("txt"), var_1_0:get("leftBg"), var_1_0:get("rightBg"), cc.p(30, 0))
					else
						local var_1_1 = arg_1_1:get("totemList"):show()
						local var_1_2 = arg_1_0.totemItem

						arg_1_1:height(arg_1_0.totemItem:height())

						if arg_1_3.type == "desc" then
							var_1_2 = arg_1_0.proItem

							var_1_1.height(var_1_1, var_1_2.height(var_1_2))
							var_1_1.setInnerContainerPosition(var_1_1, cc.p(0, 0))
							arg_1_1.height(arg_1_1, var_1_2.height(var_1_2))
						end

						bind.extend(arg_1_0, var_1_1, {
							class = "listview",
							props = {
								data = arg_1_3.items,
								item = var_1_2,
								onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
									if arg_1_3.type == "desc" then
										arg_2_1:get("name"):text(gLanguageCsv[arg_2_3.text])
										arg_2_1:get("num"):text(arg_2_3.val .. "%")
										text.addEffect(arg_2_1:get("num"), {
											color = ui.COLORS.QUALITY[2]
										})
										text.addEffect(arg_2_1:get("name"), {
											color = var_0_2[arg_2_3.text]
										})
									else
										local var_2_0 = dataEasy.getCfgByKey(arg_2_3).quality
										local var_2_1 = cc.Sprite:create("config/item/unknow/bg_" .. var_2_0 .. ".png"):xy(120, 200):scale(2):addTo(arg_2_1)

										bind.extend(arg_2_0, arg_2_1, {
											class = "icon_key",
											props = {
												simpleShow = true,
												data = {
													key = arg_2_3
												},
												onNode = function(arg_3_0)
													arg_3_0:xy(120, 210):scale(1)
												end
											}
										})
										arg_2_1:get("name"):hide()

										local var_2_2, var_2_3 = uiEasy.setIconName(arg_2_3, nil, {
											node = arg_2_1:get("name")
										})
										local var_2_4 = beauty.singleTextLimitWord(dataEasy.getCfgByKey(arg_2_3).name, {
											fontSize = 40
										}, {
											width = arg_2_1:get("name"):width()
										}):addTo(arg_2_1):xy(arg_2_1:get("name"):xy())

										text.addEffect(var_2_4, var_2_3)
									end
								end,
								onAfterBuild = function(arg_4_0)
									if arg_1_3.type == "desc" then
										arg_4_0.setItemAlignCenter(arg_4_0)
									end
								end
							}
						})
					end
				end
			}
		}
	}
}
var_0_0.RESOURCE_STYLES = {
	backGlass = true,
	blackLayer = true,
	clickClose = true
}

function var_0_0.onCreate(arg_5_0)
	arg_5_0.bottom:text(gLanguageCsv.click2Exit)

	arg_5_0.datas = {}

	arg_5_0:initUI()
end

function var_0_0.initUI(arg_6_0)
	arg_6_0.description(arg_6_0)
	arg_6_0.itemId(arg_6_0)
end

function var_0_0.itemId(arg_7_0)
	local var_7_0 = gDrawPreviewCsv[14][1]

	if var_7_0.item and csvSize(var_7_0.item) > 0 then
		local var_7_1 = {}
		local var_7_2 = 0
		local var_7_3 = math.huge

		for iter_7_0, iter_7_1 in ipairs(var_7_0.item) do
			local var_7_4 = dataEasy.getCfgByKey(iter_7_1).quality

			var_7_2 = math.max(var_7_2, var_7_4)
			var_7_3 = math.min(var_7_3, var_7_4)

			if not var_7_1[var_7_4] then
				var_7_1[var_7_4] = {}
			end

			table.insert(var_7_1[var_7_4], {
				num = 0,
				key = iter_7_1
			})
		end

		for iter_7_2 = var_7_2, var_7_3, -1 do
			local var_7_5 = var_7_1[iter_7_2]

			if var_7_5 then
				table.insert(arg_7_0.datas, {
					type = "title",
					title = "quality" .. iter_7_2
				})

				local var_7_6 = {}

				for iter_7_3, iter_7_4 in ipairs(var_7_5) do
					if iter_7_3 % 8 == 1 and iter_7_3 > 8 then
						table.insert(arg_7_0.datas, {
							type = "item",
							items = var_7_6
						})

						var_7_6 = {}
					end

					table.insert(var_7_6, iter_7_4.key)
				end

				if #var_7_6 > 0 then
					table.insert(arg_7_0.datas, {
						type = "item",
						items = var_7_6
					})
				end
			end
		end
	end
end

function var_0_0.description(arg_8_0)
	local var_8_0 = gDrawPreviewCsv[14][1]

	if var_8_0.desc and csvSize(var_8_0.desc) then
		local var_8_1 = {}

		for iter_8_0, iter_8_1 in orderCsvPairs(var_8_0.desc) do
			if not var_8_1[1] then
				var_8_1[1] = {}
			end

			table.insert(var_8_1[1], {
				text = iter_8_1[1],
				val = iter_8_1[2]
			})
		end

		table.insert(arg_8_0.datas, {
			type = "title",
			title = "desc"
		})

		for iter_8_2, iter_8_3 in ipairs(var_8_1) do
			table.insert(arg_8_0.datas, {
				type = "desc",
				items = iter_8_3
			})
		end
	end
end

return var_0_0
