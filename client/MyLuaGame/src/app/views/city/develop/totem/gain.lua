local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("TotemGain", var_0_0)

var_0_1.RESOURCE_FILENAME = "totem_activate.json"

local function var_0_2(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	local var_1_0 = arg_1_1:multiget("text", "img", "txt")
	local var_1_1 = gLanguageCsv["attr" .. string.caption(game.ATTRDEF_TABLE[arg_1_3.type])]
	local var_1_2 = ui.ATTR_LOGO[game.ATTRDEF_TABLE[arg_1_3.type]]
	local var_1_3 = var_1_2 and 150 or 210

	if var_1_2 then
		var_1_0.img:texture(var_1_2)
	else
		var_1_0.img:hide()
	end

	adapt.setTextScaleWithWidth(var_1_0.text, var_1_1, var_1_3)
	adapt.setTextScaleWithWidth(var_1_0.txt, " +" .. dataEasy.getAttrValueString(arg_1_3.type, arg_1_3.num), 110)
	text.addEffect(var_1_0.txt, {
		color = arg_1_4
	})

	if not var_1_2 then
		var_1_0.text:x(var_1_0.img:box().x)
	end

	adapt.oneLinePos(var_1_0.text, var_1_0.txt)
end

local function var_0_3(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = arg_2_1.multiget(arg_2_1, "attr1", "attr2")

	for iter_2_0 = 1, 2 do
		local var_2_1 = arg_2_3[iter_2_0]

		if var_2_1 then
			local var_2_2 = var_2_0["attr" .. iter_2_0]:multiget("text", "img", "txt")
			local var_2_3 = gLanguageCsv["attr" .. string.caption(game.ATTRDEF_TABLE[var_2_1.type])]
			local var_2_4 = ui.ATTR_LOGO[game.ATTRDEF_TABLE[var_2_1.type]]
			local var_2_5 = var_2_4 and 200 or 240

			if var_2_4 then
				var_2_2.img:texture(var_2_4)
			else
				var_2_2.img:hide()
			end

			adapt.setTextScaleWithWidth(var_2_2.text, var_2_3, var_2_5)
			adapt.setTextScaleWithWidth(var_2_2.txt, " +" .. dataEasy.getAttrValueString(var_2_1.type, var_2_1.num), 130)
			text.addEffect(var_2_2.txt, {
				color = arg_2_4
			})

			if not var_2_4 then
				var_2_2.text:x(var_2_2.img:box().x)
			end

			adapt.oneLinePos(var_2_2.text, var_2_2.txt)
		else
			var_2_0["attr" .. iter_2_0]:hide()
		end
	end
end

var_0_1.RESOURCE_BINDING = {
	imgItem = "imgItem",
	["one.attrExTxt"] = "attrExTxt",
	["one.spine"] = "oneSpine",
	["one.attrTxt"] = "oneAttrTxt",
	["one.map"] = "map",
	["multi.spine"] = "multiSpine",
	one = "one",
	["multi.attrItems"] = "attrItems",
	multi = "multi",
	attrs = "attrs",
	["one.imgBG"] = {
		binds = {
			event = "click",
			method = bindHelper.self("onClose")
		}
	},
	["one.attrList"] = {
		varname = "oneAttrList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("oneAttrData"),
				item = bindHelper.self("attrs"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					var_0_3(arg_3_0, arg_3_1, arg_3_2, arg_3_3, cc.c4b(145, 225, 177, 255))
				end
			}
		}
	},
	["one.exAttrList"] = {
		varname = "oneExAttrList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("oneExAttrData"),
				item = bindHelper.self("attrs"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					var_0_3(arg_4_0, arg_4_1, arg_4_2, arg_4_3, cc.c4b(255, 148, 102, 255))
				end
			}
		}
	},
	["one.exAttrImgList"] = {
		varname = "oneExAttrImgList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 10,
				padding = 8,
				data = bindHelper.self("oneExAttrImgData"),
				item = bindHelper.self("imgItem"),
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					arg_5_1:get("imgItem"):texture(ui.ATTR_ICON[arg_5_3])
				end
			}
		}
	},
	["one.txt"] = {
		varname = "oneTxt",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["multi.imgBG"] = {
		binds = {
			event = "click",
			method = bindHelper.self("onClose")
		}
	},
	["multi.attrList"] = {
		varname = "multiAttrList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("multiAttrData"),
				exData = bindHelper.self("haveExData"),
				item = bindHelper.self("attrItems"),
				onAfterBuild = function(arg_6_0)
					arg_6_0.setItemAlignCenter(arg_6_0)
				end,
				itemAction = {
					isAction = true
				},
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					local var_7_0 = arg_7_1.multiget(arg_7_1, "attrList", "imgList", "exAttrList", "txt", "attr", "imgItem", "txt1", "txt2")

					if arg_7_3.isTitle then
						arg_7_1:size(150, 600)
						itertools.invoke({
							var_7_0.attrList,
							var_7_0.imgList,
							var_7_0.exAttrList,
							var_7_0.txt,
							var_7_0.attr,
							var_7_0.imgItem
						}, "hide")
						var_7_0.txt1:text(gLanguageCsv.attribute .. ":")
						var_7_0.txt2:text(gLanguageCsv.totemExAttr)
					else
						var_7_0.txt1:hide()
						var_7_0.txt2:hide()
						var_7_0.txt:text(arg_7_3.title)

						if not itertools.isempty(arg_7_3.attrData) then
							bind.extend(arg_7_0, var_7_0.attrList, {
								class = "listview",
								props = {
									data = arg_7_3.attrData,
									item = var_7_0.attr,
									onItem = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
										var_0_2(arg_8_0, arg_8_1, arg_8_2, arg_8_3, cc.c4b(92, 153, 112, 255))
									end
								}
							})
						else
							var_7_0.attrList:hide()
						end

						if not itertools.isempty(arg_7_3.exAttrImg) then
							bind.extend(arg_7_0, var_7_0.exAttrList, {
								class = "listview",
								props = {
									data = arg_7_3.exAttrData,
									item = var_7_0.attr,
									onItem = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
										var_0_2(arg_9_0, arg_9_1, arg_9_2, arg_9_3, cc.c4b(230, 116, 34, 255))
									end
								}
							})
							bind.extend(arg_7_0, var_7_0.imgList, {
								class = "listview",
								props = {
									data = arg_7_3.exAttrImg,
									item = var_7_0.imgItem,
									onAfterBuild = function(arg_10_0)
										arg_10_0.setItemAlignCenter(arg_10_0)
									end,
									onItem = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
										arg_11_1:get("imgItem"):texture(ui.ATTR_ICON[arg_11_3])
									end
								}
							})
						else
							var_7_0.imgList:hide()
							var_7_0.exAttrList:hide()
						end
					end

					if arg_7_0.exData then
						var_7_0.txt2:show()
					else
						var_7_0.txt2:hide()

						local var_7_1, var_7_2 = var_7_0.txt1:xy()

						var_7_0.txt1:xy(var_7_1, var_7_2 - 150)

						local var_7_3, var_7_4 = var_7_0.txt:xy()

						var_7_0.txt:xy(var_7_3, var_7_4 - 150)

						local var_7_5, var_7_6 = var_7_0.attrList:xy()

						var_7_0.attrList:xy(var_7_5, var_7_6 - 150)
					end
				end
			}
		}
	}
}

function var_0_1.onCreate(arg_12_0, arg_12_1)
	arg_12_0.initModel(arg_12_0)

	arg_12_0.cb = arg_12_1.cb

	local var_12_0 = arg_12_1.csvIds

	if itertools.size(var_12_0) <= 1 then
		local var_12_1 = var_12_0[1] or 101

		arg_12_0.one:show()
		arg_12_0.multi:hide()
		arg_12_0:showGainOne({
			csvId = var_12_1
		})
	else
		arg_12_0.one:hide()
		arg_12_0.multi:show()
		arg_12_0:showGainMulti(arg_12_1)
	end
end

function var_0_1.initModel(arg_13_0)
	arg_13_0.oneAttrData = idlers.new({})
	arg_13_0.oneExAttrData = idlers.new({})
	arg_13_0.oneExAttrImgData = idlers.new({})
	arg_13_0.multiAttrData = idlers.new({})
	arg_13_0.haveExData = false
end

function var_0_1.showGainOne(arg_14_0, arg_14_1)
	arg_14_0.oneTxt:hide()
	arg_14_0.attrExTxt:hide()
	arg_14_0.oneAttrTxt:hide()

	local var_14_0 = widget.addAnimationByKey(arg_14_0.oneSpine, "tuteng/gongxihuode_tt.skel", "bg", "effect", 0):xy(arg_14_0.oneSpine:width() / 2, arg_14_0.oneSpine:height() / 2 - 25):anchorPoint(cc.p(0.5, 0.5)):scale(2)

	performWithDelay(arg_14_0, function()
		var_14_0:play("effect_loop")
	end, 0.55)
	arg_14_0.oneTxt:show()
	arg_14_0.oneAttrTxt:show()

	local var_14_1 = arg_14_1.csvId
	local var_14_2 = csv.totem.symbol[var_14_1]
	local var_14_3 = {}
	local var_14_4 = {}
	local var_14_5 = var_14_2.nature or {}

	for iter_14_0 = 1, math.huge do
		if var_14_2["attrType" .. iter_14_0] and var_14_2["attrType" .. iter_14_0] > 0 then
			table.insert(var_14_3, {
				type = var_14_2["attrType" .. iter_14_0],
				num = var_14_2["attrNum" .. iter_14_0]
			})
		end

		if var_14_2["extraAttrsType" .. iter_14_0] and var_14_2["extraAttrsType" .. iter_14_0] > 0 then
			table.insert(var_14_4, {
				type = var_14_2["extraAttrsType" .. iter_14_0],
				num = var_14_2["extraAttrNum" .. iter_14_0]
			})
		end

		if not var_14_2["extraAttrsType" .. iter_14_0] and not var_14_2["attrType" .. iter_14_0] then
			break
		end
	end

	table.sort(var_14_3, function(arg_16_0, arg_16_1)
		return arg_16_0.type < arg_16_1.type
	end)
	table.sort(var_14_4, function(arg_17_0, arg_17_1)
		return arg_17_0.type < arg_17_1.type
	end)
	arg_14_0.oneAttrData:update(arg_14_0:getOneSle(var_14_3))
	arg_14_0.oneExAttrData:update(arg_14_0:getOneSle(var_14_4))
	arg_14_0.oneExAttrImgData:update(var_14_5)
	arg_14_0.attrExTxt:visible(itertools.size(var_14_5) > 0)
	arg_14_0.oneTxt:text(var_14_2.name)

	local var_14_6 = {
		20,
		12,
		0
	}
	local var_14_7 = require("app.views.city.develop.totem.tools")

	var_14_7.initData(arg_14_0.map, idler.new(var_14_1), {
		scale = 1,
		bgScale = 0.85,
		data = var_14_2.totemGroup1
	})

	local var_14_8, var_14_9 = arg_14_0.map:xy()
	local var_14_10 = var_14_7.panelReflect[math.max(itertools.size(var_14_2.totemGroup1), 1)]

	arg_14_0.map:xy(var_14_8 + var_14_6[var_14_10], var_14_9)

	local var_14_11 = {
		arg_14_0.oneTxt,
		arg_14_0.oneAttrTxt,
		arg_14_0.oneAttrList,
		arg_14_0.map,
		arg_14_0.oneExAttrList,
		arg_14_0.oneExAttrImgList
	}

	if itertools.size(var_14_5) > 0 then
		table.insert(var_14_11, arg_14_0.attrExTxt)
	end

	arg_14_0.playAnimation(arg_14_0, var_14_11)
end

function var_0_1.playAnimation(arg_18_0, arg_18_1)
	local var_18_0 = 1
	local var_18_1 = 0.35
	local var_18_2 = 1
	local var_18_3 = cc.clampf(var_18_0 / (var_18_2 - var_18_0), 0.1, 0.9)

	for iter_18_0, iter_18_1 in pairs(arg_18_1) do
		iter_18_1:show()

		local var_18_4, var_18_5 = iter_18_1:xy()
		local var_18_6 = iter_18_1:scaleX()
		local var_18_7 = iter_18_1:scaleY()

		iter_18_1:x(var_18_4 + var_18_0):scaleY(0)
		transition.executeSequence(iter_18_1):easeBegin("EaseInOut"):moveTo(var_18_1 / 2, var_18_4 + var_18_2, var_18_5):moveTo(var_18_1 / 2, var_18_4, var_18_5):easeEnd():done()
		transition.executeSequence(iter_18_1):scaleYTo(var_18_1 * var_18_3 / 2, var_18_7):scaleTo(var_18_1 / 2, var_18_6, var_18_7):done()
	end
end

function var_0_1.getOneSle(arg_19_0, arg_19_1)
	local var_19_0 = 1
	local var_19_1 = {}

	for iter_19_0, iter_19_1 in pairs(arg_19_1) do
		if var_19_0 % 2 == 1 then
			table.insert(var_19_1, {})
		end

		table.insert(var_19_1[#var_19_1], iter_19_1)

		var_19_0 = var_19_0 + 1
	end

	return var_19_1
end

function var_0_1.showGainMulti(arg_20_0, arg_20_1)
	arg_20_0.playEffect(arg_20_0, "jihuo")

	local var_20_0 = arg_20_1.csvIds

	arg_20_0.haveExData = false

	local var_20_1 = {
		{
			isTitle = true,
			attrDataSize = math.huge,
			exAttrImgSize = math.huge,
			exAttrDataSize = math.huge
		}
	}

	for iter_20_0, iter_20_1 in pairs(var_20_0) do
		local var_20_2 = csv.totem.symbol[iter_20_1]
		local var_20_3 = {}
		local var_20_4 = {}
		local var_20_5 = var_20_2.nature or {}

		for iter_20_2 = 1, 2 do
			if var_20_2["attrType" .. iter_20_2] > 0 then
				table.insert(var_20_3, {
					type = var_20_2["attrType" .. iter_20_2],
					num = var_20_2["attrNum" .. iter_20_2]
				})
			end

			if var_20_2["extraAttrsType" .. iter_20_2] > 0 then
				table.insert(var_20_4, {
					type = var_20_2["extraAttrsType" .. iter_20_2],
					num = var_20_2["extraAttrNum" .. iter_20_2]
				})
			end
		end

		table.sort(var_20_3, function(arg_21_0, arg_21_1)
			return arg_21_0.type < arg_21_1.type
		end)
		table.sort(var_20_4, function(arg_22_0, arg_22_1)
			return arg_22_0.type < arg_22_1.type
		end)

		local var_20_6 = itertools.size(var_20_5)
		local var_20_7 = itertools.size(var_20_4)

		table.insert(var_20_1, {
			attrDataSize = itertools.size(var_20_3),
			exAttrImgSize = var_20_6,
			exAttrDataSize = var_20_7,
			attrData = var_20_3,
			exAttrData = var_20_4,
			exAttrImg = var_20_5,
			title = var_20_2.name
		})

		if not arg_20_0.haveExDat and (var_20_6 > 0 or var_20_7 > 0) then
			arg_20_0.haveExData = true
		end
	end

	if arg_20_1.sort then
		table.sort(var_20_1, function(arg_23_0, arg_23_1)
			if arg_23_0.exAttrDataSize == arg_23_1.exAttrDataSize then
				if arg_23_0.exAttrImgSize == arg_23_1.exAttrImgSize then
					return arg_23_1.attrDataSize < arg_23_0.attrDataSize
				end

				return arg_23_1.exAttrImgSize < arg_23_0.exAttrImgSize
			end

			return arg_23_1.exAttrDataSize < arg_23_0.exAttrDataSize
		end)
	end

	arg_20_0.multiAttrData:update(var_20_1)
end

function var_0_1.playEffect(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0.multi
	local var_24_1, var_24_2 = var_24_0:get("spine"):getPosition()
	local var_24_3 = widget.addAnimationByKey(var_24_0, "level/jiesuanshengli.skel", "effect", string.format("xjiesuan_%szi", arg_24_1), 100):setAnchorPoint(cc.p(0.5, 0.5)):xy(var_24_1, var_24_2)

	var_24_3:addPlay(string.format("xjiesuan_%szi_loop", arg_24_1))
	var_24_3:retain()

	local var_24_4 = CSprite.new("level/jiesuanshengli.skel")

	var_24_4:addTo(var_24_0, 99)
	var_24_4:setAnchorPoint(cc.p(0.5, 0.5))
	var_24_4:setPosition(var_24_0:get("spine"):getPosition())
	var_24_4:visible(true)
	var_24_4:play("jiesuan_shenglitu")
	var_24_4:addPlay("jiesuan_shenglitu_loop")
	var_24_4:retain()
end

function var_0_1.onClose(arg_25_0)
	if arg_25_0.cb then
		arg_25_0.addCallbackOnExit(arg_25_0, arg_25_0.cb)
	end

	var_0_0.onClose(arg_25_0)
end

return var_0_1
