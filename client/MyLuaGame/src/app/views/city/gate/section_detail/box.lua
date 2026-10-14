local var_0_0 = class("GateSectionBoxView", Dialog)

var_0_0.RESOURCE_FILENAME = "gate_section_box.json"
var_0_0.RESOURCE_BINDING = {
	["btnGet.textNote"] = "sureBtnTitle",
	item = "itemImg1",
	item1 = "item",
	["leftTop.imgStar"] = "imgStar",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["title.textGateName"] = {
		varname = "textGateName",
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
	["title.textChapter"] = {
		varname = "textChapter",
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
	["leftTop.textStarNum"] = {
		binds = {
			{
				event = "text",
				idler = bindHelper.self("starNum")
			}
		}
	},
	btnGet = {
		varname = "sureBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSureBtn")
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("awardDatas"),
				item = bindHelper.self("item"),
				dataOrderCmp = function(arg_1_0, arg_1_1)
					return dataEasy.sortItemCmp(arg_1_0, arg_1_1)
				end,
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:size()
					local var_2_1 = {
						class = "icon_key",
						props = {
							data = {
								key = arg_2_3.key,
								num = arg_2_3.num
							}
						}
					}

					bind.extend(arg_2_0, arg_2_1, var_2_1)
				end,
				onAfterBuild = function(arg_3_0)
					arg_3_0:adaptTouchEnabled():setItemAlignCenter()
				end
			}
		}
	},
	bar = {
		varname = "bar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				maskImg = "common/icon/mask_bar_red.png",
				data = bindHelper.self("percent")
			}
		}
	}
}

function var_0_0.onCreate(arg_4_0, arg_4_1)
	arg_4_0:initModel()

	arg_4_0.sectionId = arg_4_1

	local var_4_0 = csv.world_map[arg_4_1]

	arg_4_0.titleTxt = var_4_0.name

	local var_4_1 = 0
	local var_4_2 = 0

	for iter_4_0, iter_4_1 in ipairs(var_4_0.starAwardConds) do
		if iter_4_1 > 0 then
			var_4_1 = var_4_1 + 1
			var_4_2 = iter_4_1
		end
	end

	local var_4_3 = arg_4_0.gateStar:read()
	local var_4_4 = 0

	for iter_4_2, iter_4_3 in ipairs(var_4_0.seq) do
		if var_4_3[iter_4_3] then
			var_4_4 = var_4_4 + var_4_3[iter_4_3].star
		end
	end

	arg_4_0.titleCharpter = string.format(gLanguageCsv.getaSectionBoxTitle, tonumber(arg_4_1) % 100 - 10)

	arg_4_0.textGateName:text(arg_4_0.titleTxt)
	arg_4_0.textChapter:text(arg_4_0.titleCharpter)
	adapt.oneLinePos(arg_4_0.textChapter, arg_4_0.textGateName, cc.p(18, 0), "left")
	arg_4_0.imgStar:scale(0.66)

	local var_4_5 = var_4_0.starAwardConds[itertools.size(var_4_0.starAwardConds)]

	arg_4_0.selectIndex = idler.new(1)
	arg_4_0.starNum = idler.new(var_4_4 .. "/" .. var_4_2)
	arg_4_0.percent = idler.new(var_4_4 / var_4_2 * 100)

	for iter_4_4, iter_4_5 in ipairs(var_4_0.starAwardConds) do
		if iter_4_5 > 0 then
			local var_4_6 = arg_4_0.itemImg1:clone():tag(iter_4_4):addTo(arg_4_0.bar, 10, "item" .. iter_4_4):xy(arg_4_0.bar:size().width * iter_4_5 / var_4_5, 100):show()

			var_4_6:get("disableBg"):visible(var_4_4 < iter_4_5)
			var_4_6:get("imgBG"):visible(iter_4_5 <= var_4_4)
			var_4_6:get("disableStar"):scale(0.66):visible(var_4_4 < iter_4_5)
			var_4_6:get("imgStar"):scale(0.66):visible(iter_4_5 <= var_4_4)
			var_4_6:get("textNum"):text(iter_4_5)
			text.addEffect(var_4_6:get("textNum"), {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			})
			bind.touch(node, var_4_6, {
				methods = {
					ended = function()
						arg_4_0.selectIndex:set(iter_4_4)
					end
				}
			})
		end
	end

	idlereasy.when(arg_4_0.mapStar, function(arg_6_0, arg_6_1)
		local var_6_0 = arg_6_1[arg_4_1] and arg_6_1[arg_4_1].star_award or {}
		local var_6_1
		local var_6_2
		local var_6_3

		for iter_6_0, iter_6_1 in ipairs(var_4_0.starAwardConds) do
			if iter_6_1 > 0 then
				var_6_1 = var_6_1 or iter_6_0

				if var_6_0[iter_6_0] == 1 then
					var_6_2 = var_6_2 or iter_6_0
				end

				if var_6_0[iter_6_0] == 0 then
					var_6_3 = var_6_3 or iter_6_0
				end

				arg_4_0.bar:get(iter_6_0, "imgBlack"):visible(var_6_0[iter_6_0] == 2)
				arg_4_0.bar:get(iter_6_0, "imgTick"):visible(var_6_0[iter_6_0] == 2)
			end
		end

		arg_4_0.selectIndex:set(var_6_2 or var_6_3 or var_6_1)
	end)
	idlereasy.any({
		arg_4_0.mapStar,
		arg_4_0.selectIndex
	}, function(arg_7_0, arg_7_1, arg_7_2)
		local var_7_0 = arg_7_1[arg_4_1] and arg_7_1[arg_4_1].star_award or {}

		arg_4_0.sureBtn:setTouchEnabled(var_7_0[arg_7_2] == 1)
		cache.setShader(arg_4_0.sureBtn, false, var_7_0[arg_7_2] == 1 and "normal" or "hsl_gray")
		arg_4_0.sureBtnTitle:text(var_7_0[arg_7_2] == 2 and gLanguageCsv.received or gLanguageCsv.spaceReceive)

		if var_7_0[arg_7_2] == 1 then
			text.addEffect(arg_4_0.sureBtnTitle, {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
		else
			text.deleteAllEffect(arg_4_0.sureBtnTitle)
		end
	end)

	arg_4_0.awardDatas = idlertable.new()

	idlereasy.when(arg_4_0.selectIndex, function(arg_8_0, arg_8_1)
		for iter_8_0, iter_8_1 in ipairs(var_4_0.starAwardConds) do
			if iter_8_1 > 0 then
				arg_4_0.bar:get(iter_8_0, "imgSel"):visible(iter_8_0 == arg_8_1)
			end
		end

		local var_8_0 = {}
		local var_8_1 = dataEasy.getCfgByKey(var_4_0.starAwardIDs[arg_8_1]).specialArgsMap

		for iter_8_2, iter_8_3 in csvMapPairs(var_8_1) do
			table.insert(var_8_0, {
				num = iter_8_3,
				key = iter_8_2
			})
		end

		arg_4_0.awardDatas:set(var_8_0)
	end)
	Dialog.onCreate(arg_4_0)
end

function var_0_0.initModel(arg_9_0)
	arg_9_0.gateStar = gGameModel.role:getIdler("gate_star")
	arg_9_0.mapStar = gGameModel.role:getIdler("map_star")
	arg_9_0.roleLv = gGameModel.role:getIdler("level")
end

function var_0_0.onSureBtn(arg_10_0)
	gGameApp:requestServer("/game/role/map/star_award", function(arg_11_0)
		gGameUI:showGainDisplay(arg_11_0)
	end, arg_10_0.sectionId, arg_10_0.selectIndex)
end

return var_0_0
