local var_0_0 = 0.08

local function var_0_1(arg_1_0, arg_1_1)
	local var_1_0 = csv.equips[arg_1_0.equip_id]
	local var_1_1

	if arg_1_0.awake ~= 0 then
		var_1_1 = var_1_0.name1 .. gLanguageCsv["symbolRome" .. arg_1_0.awake]
	else
		var_1_1 = var_1_0.name0
	end

	local var_1_2, var_1_3 = dataEasy.getQuality(arg_1_0.advance)

	arg_1_1:text(var_1_1 .. var_1_3)
	text.addEffect(arg_1_1, {
		color = var_1_2 == 1 and ui.COLORS.NORMAL.WHITE or ui.COLORS.QUALITY[var_1_2]
	})
end

local var_0_2 = cc.load("mvc").ViewBase
local var_0_3 = class("CardEquipSuccessView", var_0_2)
local var_0_4 = require("app.views.city.card.equip.view")

var_0_3.RESOURCE_FILENAME = "card_equip_success.json"
var_0_3.RESOURCE_BINDING = {
	["potentialPanel.rightPos"] = "rightPotentialPos",
	["potentialPanel.leftPos"] = "leftPotentialPos",
	fight2 = "fight2",
	fightBg = "fightBg",
	limitTip = "limitTip",
	potentialPanel = "potentialPanel",
	["starPanel.leftPos"] = "leftPos",
	icon = "icon",
	item1 = "item1",
	fight1 = "fight1",
	centerPos = "centerPos",
	["starPanel.rightPos"] = "rightPos",
	item2 = "item2",
	starPanel = "starPanel",
	item3 = "item3",
	textBD = "textBD",
	equip1 = {
		varname = "equip1",
		binds = {
			event = "extend",
			class = "equip_icon",
			props = {
				data = bindHelper.self("leftData"),
				onNode = function(arg_2_0)
					local var_2_0 = arg_2_0:multiget("star", "txtLv", "txtLvNum", "imgArrow")

					itertools.invoke({
						var_2_0.star,
						var_2_0.txtLv,
						var_2_0.txtLvNum,
						var_2_0.imgArrow
					}, "hide")
				end
			}
		}
	},
	equip2 = {
		varname = "equip2",
		binds = {
			event = "extend",
			class = "equip_icon",
			props = {
				data = bindHelper.self("rightData"),
				onNode = function(arg_3_0)
					local var_3_0 = arg_3_0:multiget("star", "txtLv", "txtLvNum", "imgArrow")

					itertools.invoke({
						var_3_0.star,
						var_3_0.txtLv,
						var_3_0.txtLvNum,
						var_3_0.imgArrow
					}, "hide")
				end
			}
		}
	},
	["potentialPanel.leftPos.textNote"] = {
		varname = "leftPotentialText",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = cc.c3b(179, 68, 48)
				}
			}
		}
	},
	["potentialPanel.rightPos.textNote"] = {
		varname = "righttPotentialText",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = cc.c3b(179, 68, 48)
				}
			}
		}
	},
	bg = {
		binds = {
			event = "click",
			method = bindHelper.self("onClose")
		}
	}
}

function var_0_3.onCreate(arg_4_0, arg_4_1)
	audio.playEffectWithWeekBGM("advance_suc.mp3")

	arg_4_0.leftData = arg_4_1.leftItem
	arg_4_0.rightData = arg_4_1.rightItem
	arg_4_0.cb = arg_4_1.cb

	local var_4_0 = {}
	local var_4_1 = "xjiesuan_tupozi"

	if arg_4_1.type == "star" then
		var_4_1 = "xjiesuan_shengxingzi"

		arg_4_0:setStar(arg_4_0.leftPos, arg_4_0.leftData.star)
		arg_4_0:setStar(arg_4_0.rightPos, arg_4_0.rightData.star)
		uiEasy.setExecuteSequence(arg_4_0.leftPos)
		uiEasy.setExecuteSequence(arg_4_0.rightPos, {
			delayTime = var_0_0 * 2
		})
	end

	if arg_4_1.type == "ability" then
		arg_4_0.leftPotentialText:text(arg_4_0.leftData.ability)
		arg_4_0.righttPotentialText:text(arg_4_0.rightData.ability)
		uiEasy.setExecuteSequence(arg_4_0.leftPotentialPos)
		uiEasy.setExecuteSequence(arg_4_0.rightPotentialPos, {
			delayTime = var_0_0 * 2
		})

		var_4_1 = "xjiesuan_shengxingzi"
	end

	if arg_4_1.type == "awake" then
		var_4_1 = "xjiesuan_juexingzi"
	end

	local var_4_2 = arg_4_0.item3:multiget("name1", "name2")

	var_0_1(arg_4_0.leftData, var_4_2.name1)
	var_0_1(arg_4_0.rightData, var_4_2.name2)

	if arg_4_1.type == "signet" then
		var_4_1 = "xjiesuan_keyinzi"

		var_4_2.name1:text(arg_4_1.leftQuality)
		var_4_2.name2:text(arg_4_1.rightQuality)
	end

	arg_4_0.textBD:visible(false)

	if arg_4_1.type == "signetAdvance" then
		arg_4_0.rightData = arg_4_1.leftItem

		var_4_2.name1:text(arg_4_1.leftQuality)
		var_4_2.name2:text(arg_4_1.rightQuality)

		if arg_4_1.isMax then
			var_4_2.name2:text(arg_4_1.leftQuality)
		end

		if arg_4_1.limitTip ~= 0 then
			arg_4_0.textBD:text(arg_4_1.textBD)
			arg_4_0.limitTip:text("(" .. arg_4_1.limitTip .. ")"):visible(true)
			text.addEffect(arg_4_0.textBD, {
				color = cc.c4b(183, 176, 158, 255)
			})
		else
			arg_4_0.textBD:text(arg_4_1.textBD)
			arg_4_0.limitTip:visible(false)
			text.addEffect(arg_4_0.textBD, {
				color = cc.c4b(96, 196, 86, 255)
			})
		end

		arg_4_0.textBD:visible(true)
	end

	uiEasy.setExecuteSequence(var_4_2.name1)
	uiEasy.setExecuteSequence(var_4_2.name2, {
		delayTime = var_0_0 * 2
	})
	uiEasy.setExecuteSequence(arg_4_0.equip1)
	uiEasy.setExecuteSequence(arg_4_0.equip2, {
		delayTime = var_0_0 * 2
	})
	uiEasy.setExecuteSequence(arg_4_0.icon, {
		delayTime = var_0_0
	})
	uiEasy.setTitleEffect(arg_4_0.centerPos, var_4_1)

	local var_4_3 = gGameModel.cards:find(arg_4_1.cardDbid)

	arg_4_0.fight1:text(arg_4_1.fight)
	arg_4_0.fight2:text(var_4_3:read("fighting_point"))
	uiEasy.setExecuteSequence(arg_4_0.fightBg, {
		delayTime = var_0_0 * 3
	})
	uiEasy.setExecuteSequence(arg_4_0.fight1, {
		delayTime = var_0_0 * 4
	})
	uiEasy.setExecuteSequence(arg_4_0.fight2, {
		delayTime = var_0_0 * 5
	})
	arg_4_0.starPanel:visible(arg_4_1.type == "star")
	arg_4_0.potentialPanel:visible(arg_4_1.type == "ability")
	arg_4_0.leftPotentialPos:visible(arg_4_0.leftData.ability == 0)

	for iter_4_0 = 1, 2 do
		local var_4_4 = arg_4_1.type == "quick" and "advance" or arg_4_1.type
		local var_4_5, var_4_6, var_4_7 = var_0_4.getAttrNum(arg_4_1.leftItem, iter_4_0, var_4_4)

		if arg_4_1.type == "quick" then
			local var_4_8
			local var_4_9

			var_4_9, var_4_7 = var_0_4.getAttrNum(arg_4_1.rightItem, iter_4_0, arg_4_1.type)
		elseif arg_4_1.type == "signetAdvance" and arg_4_1.signetAdvanceData[iter_4_0] then
			var_4_6 = arg_4_1.signetAdvanceData[iter_4_0].num1
			var_4_7 = arg_4_1.signetAdvanceData[iter_4_0].num2
		end

		local var_4_10 = arg_4_0["item" .. iter_4_0]:multiget("note", "name1", "name2", "icon", "arrow")

		if var_4_5 ~= 0 and var_4_7 ~= 0 then
			local var_4_11 = game.ATTRDEF_TABLE[var_4_5]
			local var_4_12 = "attr" .. string.caption(var_4_11)

			var_4_10.note:text(gLanguageCsv[var_4_12] .. ":")

			local var_4_13 = var_4_6
			local var_4_14 = var_4_7

			if type(var_4_13) == "number" then
				var_4_13 = math.round(var_4_6)
			end

			if type(var_4_14) == "number" then
				var_4_14 = math.round(var_4_7)
			end

			var_4_10.name1:text("+" .. var_4_13)
			var_4_10.name2:text("+" .. var_4_14)

			local var_4_15 = var_0_0 * (5 + iter_4_0)

			if ui.ATTR_LOGO[var_4_11] then
				var_4_10.icon:texture(ui.ATTR_LOGO[var_4_11])
				adapt.oneLinePos(var_4_10.note, var_4_10.icon, cc.p(30, 0), "right")
				uiEasy.setExecuteSequence(var_4_10.icon, {
					delayTime = var_4_15
				})
			else
				var_4_10.icon:hide()
			end

			uiEasy.setExecuteSequence(var_4_10.note, {
				delayTime = var_4_15
			})
			uiEasy.setExecuteSequence(var_4_10.name1, {
				delayTime = var_4_15 + var_0_0
			})
			uiEasy.setExecuteSequence(var_4_10.arrow, {
				delayTime = var_4_15 + var_0_0 * 2
			})
			uiEasy.setExecuteSequence(var_4_10.name2, {
				delayTime = var_4_15 + var_0_0 * 3
			})
		else
			itertools.invoke({
				var_4_10.note,
				var_4_10.name1,
				var_4_10.name2,
				var_4_10.icon,
				var_4_10.arrow
			}, "hide")
		end
	end
end

function var_0_3.setStar(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_2 > 0 then
		for iter_5_0 = 1, arg_5_2 do
			ccui.ImageView:create("common/icon/icon_star.png"):xy(99 - 15 * (arg_5_2 + 1 - 2 * iter_5_0), 20):addTo(arg_5_1, 4, "star"):scale(0.5)
		end
	end
end

function var_0_3.onClose(arg_6_0)
	arg_6_0:addCallbackOnExit(arg_6_0.cb)
	var_0_2.onClose(arg_6_0)
end

return var_0_3
