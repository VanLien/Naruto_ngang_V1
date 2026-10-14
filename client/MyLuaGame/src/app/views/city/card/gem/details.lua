local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("GemDetailsView", var_0_0)
local var_0_2 = require("app.views.city.card.gem.tools")
local var_0_3 = 2
local var_0_4 = 7

var_0_1.RESOURCE_FILENAME = "gem_details.json"
var_0_1.RESOURCE_BINDING = {
	["panel.list"] = "list",
	["panel.property"] = "property",
	["panel.name"] = "name",
	["panel.icon"] = "icon",
	["panel.txt"] = "txt",
	["panel.panelLab"] = "panelLab",
	["panel.quality"] = "quality",
	["panel.mask"] = "mask",
	["panel.item"] = "item",
	panel = "panel",
	["panel.quile"] = "quile",
	["panel.intensify"] = {
		varname = "intensify",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("intensifyFunc")
			}
		}
	},
	["panel.inlay"] = {
		varname = "inlay",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("inlayFunc")
			}
		}
	},
	["panel.intensify.txt"] = {
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
	["panel.inlay.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_1_0, arg_1_1)
	arg_1_0.slotIdx = arg_1_1.slotIdx

	local var_1_0 = arg_1_0.inlay:get("txt")
	local var_1_1 = gLanguageCsv.spaceDischarge

	arg_1_0.cardID = arg_1_1.cardID

	if arg_1_1.dbid then
		if gGameModel.cards:find(arg_1_0.cardID):read("gems")[arg_1_0.slotIdx] then
			var_1_1 = gLanguageCsv.spaceExchange2
		else
			var_1_1 = gLanguageCsv.spaceInlay
		end
	end

	var_1_0:text(var_1_1)
	arg_1_0.mask:visible(false)

	if arg_1_1.dbid then
		arg_1_0.dbid = arg_1_1.dbid
	else
		arg_1_0.unEquip = true
		arg_1_0.dbid = gGameModel.cards:find(arg_1_0.cardID):read("gems")[arg_1_0.slotIdx]
	end

	arg_1_0.cb = arg_1_1.cb

	local var_1_2 = gGameModel.gems:find(arg_1_0.dbid)

	idlereasy.when(var_1_2:getIdler("level"), function(arg_2_0, arg_2_1)
		arg_1_0:initPanel(arg_1_0.panel, arg_1_0.dbid, arg_2_1)
	end)
	arg_1_0.txt:visible(false)
	arg_1_0.panelLab:visible(false)

	local var_1_3 = arg_1_1.pos
	local var_1_4 = arg_1_1.align
	local var_1_5
	local var_1_6 = arg_1_0.panel:size().width

	if var_1_4 == "left" then
		var_1_5 = var_1_3.x - var_1_6 / 2
	else
		var_1_5 = var_1_3.x + var_1_6 / 2
	end

	local var_1_7 = var_1_5 + 50
	local var_1_8 = arg_1_0:getResourceNode():convertToNodeSpace(cc.p(var_1_7, 0))

	arg_1_0.panel:x(var_1_8.x)

	if arg_1_1.dbid and arg_1_1.slotIdx then
		local var_1_9 = gGameModel.cards:find(arg_1_0.cardID):read("gems")

		if var_1_9[arg_1_0.slotIdx] then
			local var_1_10 = gGameModel.gems:find(var_1_9[arg_1_0.slotIdx])

			arg_1_0:createSmallPanel(arg_1_1, var_1_9[arg_1_0.slotIdx], var_1_10:read("level"))
		end
	end
end

function var_0_1.initPanel(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = gGameModel.gems:find(arg_3_2)
	local var_3_1 = arg_3_1:multiget("list", "quality", "name", "quile", "property", "icon", "panelLab", "txt", "item")

	var_3_1.list:removeAllChildren()
	var_3_1.list:setScrollBarEnabled(false)

	local var_3_2 = {}
	local var_3_3 = var_3_0:read("gem_id")
	local var_3_4 = dataEasy.getCfgByKey(var_3_3)
	local var_3_5 = var_3_4.quality
	local var_3_6 = "qualityNum" .. var_3_5

	var_3_1.quality:text(csv.gem.quality[arg_3_3][var_3_6])
	var_3_1.name:text(var_3_4.name)
	text.addEffect(var_3_1.name, {
		color = ui.COLORS.QUALITY_DARK[var_3_5]
	})

	if not csv.gem.gem[var_3_3] or not csv.gem.gem[var_3_3].gemDescribe then
		var_3_1.property:visible(false)
		var_3_1.quile:y(arg_3_0.property:y())
		var_3_1.quality:y(arg_3_0.property:y())
	else
		var_3_1.property:text(csv.gem.gem[var_3_3].gemDescribe)
	end

	bind.extend(arg_3_0, var_3_1.icon, {
		class = "icon_key",
		props = {
			noListener = true,
			data = {
				key = var_3_3
			},
			specialKey = {
				leftTopLv = arg_3_3
			},
			onNode = function(arg_4_0)
				return
			end
		}
	})

	for iter_3_0 = 1, math.huge do
		if var_3_4["attrType" .. iter_3_0] and var_3_4["attrType" .. iter_3_0] ~= 0 and var_3_4["attrNum" .. iter_3_0] and var_3_4["attrNum" .. iter_3_0][arg_3_3] then
			local var_3_7 = game.ATTRDEF_TABLE[var_3_4["attrType" .. iter_3_0]]
			local var_3_8 = "attr" .. var_3_7:gsub("^%l", string.upper)
			local var_3_9 = var_3_1.txt:clone():show()

			var_3_9:get("txt"):text(gLanguageCsv[var_3_8])
			var_3_9:get("number"):text("+" .. dataEasy.getAttrValueString(var_3_4["attrType" .. iter_3_0], var_3_4["attrNum" .. iter_3_0][arg_3_3]))
			var_3_9:get("number"):x(var_3_9:get("txt"):width() + 10)
			dataEasy.tryCallFunc(var_3_1.list, "updatePreloadCenterIndex")
			var_3_1.list:pushBackCustomItem(var_3_9)
		else
			break
		end
	end

	var_3_1.item:visible(false)

	local var_3_10 = gGameModel.cards:find(arg_3_0.cardID):read("gems")
	local var_3_11 = false
	local var_3_12 = var_3_4.suitID

	if var_3_12 then
		for iter_3_1, iter_3_2 in pairs(var_3_10) do
			if arg_3_2 == iter_3_2 then
				var_3_11 = true
			end
		end

		local var_3_13 = {}

		if var_3_11 then
			local var_3_14 = {}

			for iter_3_3 = var_0_3, var_0_4 do
				var_3_14[iter_3_3] = 0
			end

			for iter_3_4 = 1, 9 do
				local var_3_15 = var_3_10[iter_3_4]

				if var_3_15 then
					local var_3_16 = gGameModel.gems:find(var_3_15)
					local var_3_17 = csv.gem.gem[var_3_16:read("gem_id")]

					if var_3_17.suitID == var_3_12 then
						for iter_3_5 = var_0_3, var_3_17.quality do
							var_3_14[iter_3_5] = var_3_14[iter_3_5] + 1
						end
					end
				end
			end

			for iter_3_6 = 1, 9 do
				for iter_3_7 = var_0_3, var_0_4 do
					if iter_3_6 <= var_3_14[iter_3_7] then
						var_3_13[iter_3_6] = iter_3_7
					end
				end
			end
		end

		local var_3_18 = var_3_1.item:clone():show()

		var_3_1.list:pushBackCustomItem(var_3_18)

		local var_3_19, var_3_20 = next(gGemSuitCsv[var_3_12])

		for iter_3_8 = 1, 9 do
			if var_3_20[iter_3_8] then
				arg_3_0:showText(var_3_1, iter_3_8, var_3_13[iter_3_8], var_3_4)
			end
		end
	end
end

function var_0_1.showText(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_3 or arg_5_4.quality
	local var_5_1 = gGemSuitCsv[arg_5_4.suitID][var_5_0][arg_5_2]

	if var_5_1 == nil then
		return
	end

	local var_5_2 = "#C0x48D81C#"

	if not arg_5_3 then
		var_5_2 = "#C0xB7B09E#"
	end

	local var_5_3 = string.format(gLanguageCsv.numSuit, arg_5_2)
	local var_5_4 = var_5_1.suitName .. string.format("%s(%s)%s", var_5_3, gLanguageCsv[ui.QUALITY_COLOR_TEXT[var_5_0]], gLanguageCsv.symbolColon)
	local var_5_5

	for iter_5_0 = 1, math.huge do
		if var_5_1["attrType" .. iter_5_0] and var_5_1["attrType" .. iter_5_0] ~= 0 then
			local var_5_6 = game.ATTRDEF_TABLE[var_5_1["attrType" .. iter_5_0]]
			local var_5_7 = gLanguageCsv["attr" .. string.caption(var_5_6)]

			if var_5_5 then
				var_5_5 = var_5_5 .. "  " .. var_5_7 .. "+" .. dataEasy.getAttrValueString(var_5_1["attrType" .. iter_5_0], var_5_1["attrNum" .. iter_5_0])
			else
				var_5_5 = var_5_7 .. "+" .. dataEasy.getAttrValueString(var_5_1["attrType" .. iter_5_0], var_5_1["attrNum" .. iter_5_0])
			end
		else
			break
		end
	end

	local var_5_8 = arg_5_1.panelLab:clone():show()
	local var_5_9 = rich.createWithWidth(var_5_2 .. var_5_4 .. var_5_5 .. var_5_2, 40, cc.size(700, 50), 700, 0):anchorPoint(0, 1)

	var_5_8:height(var_5_9:height())
	var_5_9:addTo(var_5_8):y(var_5_9:height()):z(2)
	arg_5_1.list:pushBackCustomItem(var_5_8)
end

function var_0_1.createSmallPanel(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_1.pos
	local var_6_1 = arg_6_1.align == "left" and "right" or "left"
	local var_6_2
	local var_6_3 = arg_6_0.panel:size().width

	if var_6_1 == "left" then
		var_6_2 = var_6_0.x - var_6_3 / 2
	else
		var_6_2 = var_6_0.x + var_6_3 / 2
	end

	local var_6_4 = var_6_2 + 50
	local var_6_5 = arg_6_0:getResourceNode():convertToNodeSpace(cc.p(var_6_4, 0))
	local var_6_6 = arg_6_0.panel:clone():addTo(arg_6_0:getResourceNode(), 100)

	var_6_6:x(var_6_5.x)
	arg_6_0:initPanel(var_6_6, arg_6_2, gGameModel.gems:find(arg_6_2):read("level"))
	var_6_6:get("bg"):height(900)
	var_6_6:get("intensify"):visible(false)
	var_6_6:get("inlay"):visible(false)

	local var_6_7 = var_6_6:size()

	ccui.ImageView:create("city/card/helditem/bag/icon_cd.png"):align(cc.p(0.5, 0.5), 30, var_6_7.height - 40):addTo(var_6_6:get("icon"), 9999, "isEquiped"):xy(150, 150)
end

function var_0_1.intensifyFunc(arg_7_0, ...)
	gGameUI:stackUI("city.card.gem.strengthen", nil, nil, arg_7_0.dbid)
end

function var_0_1.inlayFunc(arg_8_0, ...)
	if arg_8_0.unEquip then
		local var_8_0 = arg_8_0.cardID
		local var_8_1 = arg_8_0.slotIdx

		arg_8_0:onClose()
		var_0_2.unEquipGem(var_8_0, var_8_1)

		return
	end

	local var_8_2 = gGameModel.cards:find(arg_8_0.cardID):read("gems")[arg_8_0.slotIdx]
	local var_8_3 = arg_8_0.cardID
	local var_8_4 = arg_8_0.slotIdx
	local var_8_5 = arg_8_0.dbid

	arg_8_0:onClose()

	if var_8_2 then
		var_0_2.swapGem(var_8_3, var_8_4, var_8_5)
	else
		var_0_2.equipGem(var_8_3, var_8_4, var_8_5)
	end
end

function var_0_1.onCleanup(arg_9_0)
	arg_9_0:addCallbackOnExit(arg_9_0.cb)
	var_0_0.onCleanup(arg_9_0)
end

return var_0_1
