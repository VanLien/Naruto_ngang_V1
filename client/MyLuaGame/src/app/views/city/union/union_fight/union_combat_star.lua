local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("UnionCombatStarView", Dialog)
local var_0_2 = 1
local var_0_3 = {}

for iter_0_0, iter_0_1 in pairs(game.NATURE_ENUM_TABLE) do
	var_0_3[iter_0_1] = gLanguageCsv[iter_0_0]
end

local function var_0_4(arg_1_0, arg_1_1)
	if arg_1_1.chairman == arg_1_0 then
		return true
	end

	if arg_1_1.viceChairmans[arg_1_0] then
		return true
	end

	return false
end

var_0_1.RESOURCE_FILENAME = "union_combat_star.json"
var_0_1.RESOURCE_BINDING = {
	starTxt = "starTxt",
	panel = "panel",
	star = "star",
	btnColse = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	txt = {
		varname = "txt",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(59, 51, 59, 255)
				}
			}
		}
	},
	txt2 = {
		varname = "txt2",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(59, 51, 59, 255)
				}
			}
		}
	},
	btn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("btnSave")
			}
		}
	},
	sprite = {
		varname = "targetSprite",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("spriteBtnFunc")
			}
		}
	},
	["sprite.upDown"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("spriteBtnFunc")
			}
		}
	},
	attr = {
		varname = "attr",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("attributeFunc")
			}
		}
	},
	["attr.upDown"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("attributeFunc")
			}
		}
	},
	["add.icon1"] = {
		varname = "add",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("addResult")
			}
		}
	},
	["add.icon2"] = {
		varname = "reduce",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("reduceResult")
			}
		}
	}
}

function var_0_1.onCreate(arg_2_0)
	arg_2_0:initModel()
	arg_2_0.reduce:setOpacity(0)
	arg_2_0.reduce:get("txt"):setOpacity(0)

	arg_2_0.natureDatas = idler.new(0)
	arg_2_0.attrPanel = gGameUI:createView("common.attr_filter", arg_2_0):init({
		btnColse = true,
		isMultiSelect = false,
		selectDatas = arg_2_0:createHandler("natureDatas"),
		panelState = arg_2_0:createHandler("isShowNaturePanel")
	}):anchorPoint(0.5, 0):xy(100, -100):z(20):scale(0.7)

	idlereasy.if_not(arg_2_0.isShowNaturePanel, function()
		arg_2_0.spriteIcon = arg_2_0.natureDatas:read()

		arg_2_0:updateFontChange()
	end)
	idlereasy.when(arg_2_0.isShowNaturePanel, function(arg_4_0, arg_4_1)
		arg_2_0.spriteInfo = arg_4_1 and 1 or 2

		arg_2_0.targetSprite:get("upDown"):rotate(arg_4_1 and 180 or 0)
		arg_2_0.attrPanel:visible(arg_4_1)
	end)

	arg_2_0.attrbutePanel = gGameUI:createView("common.attribute_filter", arg_2_0):init({
		selectDatas = arg_2_0.oneSelfNature,
		panelState = arg_2_0.isShowone
	})

	idlereasy.if_not(arg_2_0.isShowone, function()
		arg_2_0.attrIcon = arg_2_0.oneSelfNature:read()

		arg_2_0:updateFontChange()
	end)
	idlereasy.when(arg_2_0.isShowone, function(arg_6_0, arg_6_1)
		arg_2_0.attrInfo = arg_6_1 and 1 or 2

		arg_2_0.attr:get("upDown"):rotate(arg_6_1 and 180 or 0)
		arg_2_0.attrbutePanel:visible(arg_6_1)
	end)

	arg_2_0.postX1 = arg_2_0.txt:x()
	arg_2_0.postX2 = arg_2_0.txt2:x()

	Dialog.onCreate(arg_2_0)
end

function var_0_1.initModel(arg_7_0)
	local var_7_0 = gGameModel.union_fight:read("union_info").battle_star_num

	var_7_0 = var_7_0 <= 0 and 0 or var_7_0

	arg_7_0.starTxt:text(var_7_0 .. "/" .. var_0_2)
	arg_7_0.star:x(arg_7_0.starTxt:x() - arg_7_0.starTxt:width())

	arg_7_0.dataTab = idlers.new({})
	arg_7_0.spriteInfo = 2
	arg_7_0.attrInfo = 2
	arg_7_0.result = 1
	arg_7_0.upDownText = gLanguageCsv.increase
	arg_7_0.isShowNaturePanel = idler.new(false)
	arg_7_0.oneSelfNature = idler.new(0)
	arg_7_0.isShowone = idler.new(false)
	arg_7_0.roleId = gGameModel.role:read("id")

	local var_7_1 = gGameModel.union

	arg_7_0.chairmanId = var_7_1:read("chairman_db_id")
	arg_7_0.viceChairmans = var_7_1:read("vice_chairmans")
end

function var_0_1.spriteBtnFunc(arg_8_0)
	arg_8_0.spriteInfo = arg_8_0.spriteInfo == 1 and 2 or 1

	arg_8_0.isShowNaturePanel:set(arg_8_0.spriteInfo == 1)
end

function var_0_1.attributeFunc(arg_9_0)
	arg_9_0.attrInfo = arg_9_0.attrInfo == 1 and 2 or 1

	arg_9_0.isShowone:set(arg_9_0.attrInfo == 1)
end

function var_0_1.addResult(arg_10_0)
	arg_10_0.add:setOpacity(255)
	arg_10_0.add:get("txt"):setOpacity(255)
	arg_10_0.reduce:setOpacity(0)
	arg_10_0.reduce:get("txt"):setOpacity(0)

	arg_10_0.result = 1
	arg_10_0.upDownText = gLanguageCsv.increase

	arg_10_0:updateFontChange()
end

function var_0_1.reduceResult(arg_11_0)
	arg_11_0.reduce:setOpacity(255)
	arg_11_0.reduce:get("txt"):setOpacity(255)
	arg_11_0.add:setOpacity(0)
	arg_11_0.add:get("txt"):setOpacity(0)

	arg_11_0.result = -1
	arg_11_0.upDownText = gLanguageCsv.reduce

	arg_11_0:updateFontChange()
end

function var_0_1.updateFontChange(arg_12_0)
	if arg_12_0.spriteIcon and arg_12_0.spriteIcon >= 1 and arg_12_0.attrIcon and arg_12_0.attrIcon >= 1 then
		local var_12_0 = gLanguageCsv.attrSprite
		local var_12_1 = game.ATTRDEF_TABLE[arg_12_0.attrIcon]
		local var_12_2 = gLanguageCsv["attr" .. string.caption(var_12_1)]

		arg_12_0.txt:text(var_0_3[arg_12_0.spriteIcon] .. var_12_0 .. arg_12_0.upDownText .. "10%" .. var_12_2)
		arg_12_0.txt:x(arg_12_0.postX1 - arg_12_0.txt:width() / 2 + arg_12_0.txt2:width() / 2)
		arg_12_0.txt2:x(arg_12_0.postX2 - arg_12_0.txt:width() / 2 + arg_12_0.txt2:width() / 2)
	end
end

function var_0_1.btnSave(arg_13_0)
	local var_13_0 = gGameModel.union_fight:read("union_info").battle_star_num

	if var_13_0 <= 0 then
		gGameUI:showTip(gLanguageCsv.combatStarNot)

		return
	end

	if not arg_13_0.spriteIcon or arg_13_0.spriteIcon <= 0 then
		gGameUI:showTip(gLanguageCsv.addtionSprite)

		return
	end

	if not arg_13_0.attrIcon or arg_13_0.attrIcon <= 0 then
		gGameUI:showTip(gLanguageCsv.addtionAttr)

		return
	end

	local var_13_1 = {
		chairman = arg_13_0.chairmanId
	}
	local var_13_2 = {}

	for iter_13_0, iter_13_1 in ipairs(arg_13_0.viceChairmans) do
		var_13_2[iter_13_1] = true
	end

	var_13_1.viceChairmans = var_13_2

	if not var_0_4(arg_13_0.roleId, var_13_1) then
		gGameUI:showTip(gLanguageCsv.unionOnlyChairman)

		return false
	end

	gGameApp:requestServer("/game/union/fight/battle/star/set", function(arg_14_0)
		var_13_0 = var_13_0 - 1

		arg_13_0.starTxt:text(var_13_0 .. "/" .. var_0_2)
		var_0_0.onClose(arg_13_0)
	end, arg_13_0.spriteIcon, arg_13_0.attrIcon, arg_13_0.result)
end

return var_0_1
