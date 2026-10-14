local var_0_0 = {
	down = 2,
	up = 1,
	change = 3
}
local var_0_1 = {
	gLanguageCsv.spaceInlay,
	gLanguageCsv.spaceDischarge,
	gLanguageCsv.spaceReplace
}
local var_0_2 = cc.load("mvc").ViewBase
local var_0_3 = class("ChipDetailsView", var_0_2)
local var_0_4 = require("app.views.city.card.chip.tools")

var_0_3.RESOURCE_FILENAME = "chip_details.json"
var_0_3.RESOURCE_BINDING = {
	panel = "panel",
	["panel.btnChange"] = {
		varname = "btnChange",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChangeClick")
			}
		}
	},
	["panel.btnStrength"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onStrengthClick")
			}
		}
	},
	["panel.btnStrength.txt"] = {
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
	["panel.btnChange.txt"] = {
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

function var_0_3.onCreate(arg_1_0, arg_1_1)
	arg_1_0.cb = arg_1_1.cb
	arg_1_0.chipDBID = arg_1_1.dbId
	arg_1_0.cardDBID = arg_1_1.cardDBID
	arg_1_0.plan = arg_1_1.plan
	arg_1_0.subDBID = arg_1_1.subDBID
	arg_1_0.showExp = arg_1_1.showExp
	arg_1_0.dataRefresh = arg_1_1.dataRefresh

	local var_1_0 = gGameModel.chips:find(arg_1_0.chipDBID)
	local var_1_1 = var_1_0:read("chip_id", "card_db_id", "level")

	arg_1_0.chipIdx = csv.chip.chips[var_1_1.chip_id].pos

	arg_1_0.panel:get("btnChange"):hide()
	arg_1_0.panel:get("btnStrength"):hide()
	arg_1_0.panel:get("btnBg"):hide()

	if arg_1_0.cardDBID then
		if arg_1_0.cardDBID == var_1_1.card_db_id then
			arg_1_0.changeType = var_0_0.down
		else
			if not arg_1_0.subDBID then
				arg_1_0.subDBID = gGameModel.cards:find(arg_1_0.cardDBID):read("chip")[arg_1_0.chipIdx]
			end

			if arg_1_0.subDBID then
				arg_1_0.changeType = var_0_0.change
			else
				arg_1_0.changeType = var_0_0.up
			end
		end
	elseif arg_1_0.plan then
		local var_1_2 = arg_1_0.plan:read()

		if arg_1_0.chipDBID == var_1_2[arg_1_0.chipIdx] then
			arg_1_0.changeType = var_0_0.down
		else
			arg_1_0.subDBID = var_1_2[arg_1_0.chipIdx]

			if arg_1_0.subDBID then
				arg_1_0.changeType = var_0_0.change
			else
				arg_1_0.changeType = var_0_0.up
			end
		end
	end

	if arg_1_1.justShow then
		arg_1_0.changeType = nil
	end

	if arg_1_0.changeType then
		arg_1_0.panel:get("btnChange"):show()
		arg_1_0.panel:get("btnStrength"):show()
		arg_1_0.panel:get("btnBg"):show()
		arg_1_0.btnChange:get("txt"):text(var_0_1[arg_1_0.changeType])
	end

	if arg_1_1.pos then
		local var_1_3 = arg_1_1.pos.x

		if arg_1_1.align == "right" then
			var_1_3 = var_1_3 + arg_1_0.panel:width() / 2
		else
			var_1_3 = var_1_3 - arg_1_0.panel:width() / 2
		end

		arg_1_0.panel:x(var_1_3)
	end

	local var_1_4 = true
	local var_1_5 = var_1_0:multigetIdler("level", "now", "locked")

	idlereasy.any(var_1_5, function()
		arg_1_0:setPanel(arg_1_0.panel, arg_1_0.chipDBID)

		if not var_1_4 and arg_1_0.dataRefresh then
			arg_1_0.dataRefresh()
		end
	end)

	var_1_4 = false

	if arg_1_0.subDBID then
		local var_1_6 = arg_1_0.panel:clone():addTo(arg_1_0.panel:parent()):xy(arg_1_0.panel:x() + arg_1_0.panel:width() + 10, arg_1_0.panel:y())

		var_1_6:get("btnChange"):hide()
		var_1_6:get("btnStrength"):hide()
		var_1_6:get("btnBg"):hide()

		local var_1_7 = gGameModel.chips:find(arg_1_0.subDBID):multigetIdler("level", "now", "locked")

		idlereasy.any(var_1_7, function()
			arg_1_0:setPanel(var_1_6, arg_1_0.subDBID)
		end)
	end
end

function var_0_3.onClose(arg_4_0)
	arg_4_0:addCallbackOnExit(arg_4_0.cb)
	var_0_2.onClose(arg_4_0)
end

function var_0_3.onChangeClick(arg_5_0)
	if arg_5_0.cardDBID then
		local var_5_0 = -1

		if arg_5_0.changeType ~= var_0_0.down then
			var_5_0 = arg_5_0.chipDBID
		end

		gGameApp:requestServer("/game/card/chip/change", function(arg_6_0)
			if arg_5_0.changeType == var_0_0.up then
				gGameUI:showTip(gLanguageCsv.inlaySuccess)
			elseif arg_5_0.changeType == var_0_0.down then
				gGameUI:showTip(gLanguageCsv.dischargeSuccess)
			else
				gGameUI:showTip(gLanguageCsv.exchange2Success)
			end

			arg_5_0:onClose()
		end, arg_5_0.cardDBID, {
			[arg_5_0.chipIdx] = var_5_0
		})
	else
		arg_5_0.plan:modify(function(arg_7_0)
			arg_7_0[arg_5_0.chipIdx] = arg_5_0.changeType ~= var_0_0.down and arg_5_0.chipDBID or nil

			return true, arg_7_0
		end)
		print_r(arg_5_0.plan:read())

		if arg_5_0.dataRefresh then
			arg_5_0.dataRefresh()
		end

		arg_5_0:onClose()
	end
end

function var_0_3.setPanel(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_1:multiget("bg", "bg2", "lock", "icon", "name", "level", "noEquip", "equip", "cardName", "gainExpText", "gainExp", "list", "attrItem", "lineItem", "suitItem", "btnBg", "btnChange", "btnStrength")
	local var_8_1 = gGameModel.chips:find(arg_8_2):read("chip_id", "card_db_id", "level", "level_exp", "locked")
	local var_8_2 = csv.chip.chips[var_8_1.chip_id]

	bind.extend(arg_8_0, var_8_0.icon, {
		class = "icon_key",
		props = {
			noListener = true,
			data = {
				key = var_8_1.chip_id,
				dbId = var_8_1.card_db_id
			},
			specialKey = {
				lv = var_8_1.level
			},
			onNode = function(arg_9_0)
				arg_9_0:get("defaultLv"):hide()
			end
		}
	})
	uiEasy.setIconName(var_8_1.chip_id, 0, {
		node = var_8_0.name
	})
	var_8_0.level:text("Lv" .. var_8_1.level)
	var_8_0.noEquip:hide()
	var_8_0.equip:hide()
	var_8_0.cardName:hide()
	var_8_0.lock:texture(var_8_1.locked and "city/card/chip/btn_lock.png" or "city/card/chip/btn_unlock.png")
	bind.touch(arg_8_0, var_8_0.lock, {
		methods = {
			ended = functools.partial(arg_8_0.onLockClick, arg_8_0, arg_8_2)
		}
	})
	var_8_0.gainExpText:hide()
	var_8_0.gainExp:hide()

	if arg_8_0.showExp then
		var_8_0.gainExpText:show()
		var_8_0.gainExp:show()
		adapt.oneLinePos(var_8_0.gainExpText, var_8_0.gainExp)
		var_8_0.gainExp:text(arg_8_0.showExp)
	elseif var_8_1.card_db_id then
		var_8_0.equip:show()
		var_8_0.cardName:show()

		local var_8_3 = gGameModel.cards:find(var_8_1.card_db_id)

		uiEasy.setIconName("card", var_8_3:read("card_id"), {
			space = true,
			node = var_8_0.cardName,
			advance = var_8_3:read("advance")
		})
		adapt.oneLinePos(var_8_0.equip, var_8_0.cardName, cc.p(10, 0), "left")
	else
		var_8_0.noEquip:show()
	end

	var_8_0.list:removeAllChildren()
	var_8_0.list:setScrollBarEnabled(false)

	local var_8_4, var_8_5 = var_0_4.getAttr(arg_8_2, nil, true, true)
	local var_8_6 = false

	for iter_8_0, iter_8_1 in ipairs(var_8_4) do
		local var_8_7 = iter_8_1.key

		if not var_0_4.ignoreAttr(var_8_7) then
			var_8_6 = true

			local var_8_8 = iter_8_1.val
			local var_8_9 = var_8_0.attrItem:clone():show()
			local var_8_10 = var_0_4.getAttrName(var_8_7)

			var_8_9:get("key"):text(var_8_10)
			var_8_9:get("val"):text("+" .. var_8_8)
			var_8_0.list:pushBackCustomItem(var_8_9)
		end
	end

	if var_8_6 then
		local var_8_11 = var_8_0.lineItem:clone():show()

		var_8_0.list:pushBackCustomItem(var_8_11)
	end

	local var_8_12 = false

	for iter_8_2, iter_8_3 in ipairs(var_8_5) do
		local var_8_13 = iter_8_3.key

		if not var_8_13 then
			local var_8_14 = var_8_0.attrItem:clone():show()

			var_8_14:get("key"):text(iter_8_3.name)
			var_8_14:get("val"):text(iter_8_3.val)
			text.addEffect(var_8_14:get("key"), {
				color = ui.NEWCOLORS.GRAY
			})
			text.addEffect(var_8_14:get("val"), {
				color = ui.NEWCOLORS.GRAY
			})
			var_8_0.list:pushBackCustomItem(var_8_14)
		elseif not var_0_4.ignoreAttr(var_8_13) then
			var_8_12 = true

			local var_8_15 = iter_8_3.val
			local var_8_16 = var_8_0.attrItem:clone():show()
			local var_8_17 = var_0_4.getAttrName(var_8_13)

			var_8_16:get("key"):text(var_8_17)
			var_8_16:get("val"):text("+" .. var_8_15)
			var_8_0.list:pushBackCustomItem(var_8_16)
		end
	end

	if var_8_12 then
		local var_8_18 = var_8_0.lineItem:clone():show()

		var_8_0.list:pushBackCustomItem(var_8_18)
	end

	local var_8_19 = {}
	local var_8_20 = var_0_4.getSuitAttrByChip(arg_8_2)

	for iter_8_4, iter_8_5 in ipairs(var_8_20) do
		local var_8_21 = var_0_4.getSuitAttrStr(var_8_2.suitID, iter_8_5)

		table.insert(var_8_19, {
			str = var_8_21
		})
	end

	local var_8_22 = var_8_0.suitItem:clone():show()
	local var_8_23, var_8_24 = beauty.textScroll({
		margin = 10,
		isRich = true,
		list = var_8_22:get("list"),
		strs = var_8_19
	})

	var_8_23:height(var_8_24)
	var_8_23:setTouchEnabled(false)
	var_8_22:height(var_8_24)
	var_8_0.list:pushBackCustomItem(var_8_22)

	local var_8_25 = var_8_0.btnChange:visible() and 0 or 124
	local var_8_26 = cc.clampf(var_8_0.list:getInnerItemSize().height, 420, 590 + var_8_25)
	local var_8_27 = 590 - var_8_26

	var_8_0.list:height(var_8_26):y(180 + var_8_27)
	var_8_0.bg2:height(642 - var_8_27)
	var_8_0.bg:height(1030 - var_8_27 - var_8_25)
	var_8_0.btnBg:y(90 + var_8_27)
	var_8_0.btnChange:y(90 + var_8_27)
	var_8_0.btnStrength:y(90 + var_8_27)

	if dataEasy.isUnlock(gUnlockCsv.chipPlan) then
		arg_8_1:removeChildByName("planNamesBg")
		arg_8_1:removeChildByName("planNames")

		local var_8_28 = {}
		local var_8_29 = gGameModel.role:read("chip_plans")

		for iter_8_6, iter_8_7 in pairs(var_8_29) do
			for iter_8_8, iter_8_9 in pairs(iter_8_7.chips or {}) do
				if iter_8_9 == arg_8_2 then
					table.insert(var_8_28, iter_8_7.name)

					break
				end
			end
		end

		if #var_8_28 > 0 then
			local var_8_30 = 60
			local var_8_31, var_8_32 = beauty.textScroll({
				isRich = true,
				size = cc.size(var_8_0.bg:width() - 2 * var_8_30, 0),
				strs = "#C0xFFFCED##L00100000##LOC0xF13B54#" .. gLanguageCsv.chipUsedInPlans .. " #C0xFFFF66##L00100000##LOC0xF13B54#" .. table.concat(var_8_28, ", ")
			})
			local var_8_33 = math.min(var_8_32, 120)

			var_8_31:setTouchEnabled(var_8_33 < var_8_32)
			var_8_31:height(var_8_33)
			var_8_31:xy(var_8_0.bg:box().x + var_8_30, var_8_0.bg:box().y - var_8_33 - 10):addTo(arg_8_1, 2, "planNames")

			local var_8_34 = ccui.Scale9Sprite:create()

			var_8_34:initWithFile(cc.rect(243, 17, 1, 1), "city/card/chip/bg_red.png")
			var_8_34:size(var_8_0.bg:width() + 140, var_8_33 + 40):anchorPoint(0.5, 1):xy(var_8_0.bg:box().x + var_8_0.bg:width() / 2, var_8_0.bg:box().y + 10):addTo(arg_8_1, 1, "planNamesBg")
		end
	end
end

function var_0_3.onStrengthClick(arg_10_0)
	gGameUI:stackUI("city.card.chip.advance", nil, {
		full = true
	}, arg_10_0.chipDBID)
end

function var_0_3.onLockClick(arg_11_0, arg_11_1)
	gGameApp:requestServer("/game/card/chip/locked/switch", function()
		if gGameModel.chips:find(arg_11_1):read("locked") then
			gGameUI:showTip(gLanguageCsv.chipLocked)
		end
	end, arg_11_1)
end

return var_0_3
