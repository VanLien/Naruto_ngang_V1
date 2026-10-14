local var_0_0 = class("BattleAttrPanelView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "battle_attr_panel.json"
var_0_0.RESOURCE_BINDING = {}

local var_0_1 = {
	"hpMax",
	"damage",
	"defence",
	"specialDamage",
	"specialDefence",
	"speed"
}

function var_0_0.onCreate(arg_1_0, arg_1_1)
	arg_1_0.battleView = arg_1_1

	local var_1_0 = arg_1_0:getResourceNode()

	var_1_0:onTouch(function()
		arg_1_0:onCloseBtnClick()
	end)
	arg_1_0:hide()

	local var_1_1 = var_1_0:get("attrPanel")

	for iter_1_0 = 1, 6 do
		local var_1_2 = nodetools.get(var_1_1, "attr" .. iter_1_0 .. ".attrName")
		local var_1_3 = var_0_1[iter_1_0]
		local var_1_4 = string.upper(string.sub(var_1_3, 1, 1))
		local var_1_5 = string.sub(var_1_3, 2)
		local var_1_6 = "attr" .. var_1_4 .. var_1_5

		if iter_1_0 == 1 then
			var_1_6 = "attrHp"
		end

		var_1_2:text(gLanguageCsv[var_1_6])
	end
end

function var_0_0.showPanel(arg_3_0, arg_3_1)
	if not arg_3_1 then
		return
	end

	arg_3_0:show()

	arg_3_0.curObjSpr = arg_3_1

	local var_3_0 = arg_3_1.unitCfg.cardIcon
	local var_3_1 = arg_3_1.unitCfg.name
	local var_3_2 = arg_3_1.model
	local var_3_3 = var_3_2.isMonster and var_3_2.showLevel or var_3_2.level
	local var_3_4 = ui.ATTR_ICON[arg_3_1.unitCfg.natureType]
	local var_3_5 = ui.ATTR_ICON[arg_3_1.unitCfg.natureType2]
	local var_3_6 = arg_3_0:getResourceNode()

	bind.extend(arg_3_0, var_3_6:get("potraitFrame"), {
		class = "card_icon",
		props = {
			unitId = var_3_2.unitID,
			advance = var_3_2.advance,
			star = var_3_2.star,
			rarity = var_3_2.rarity,
			isBoss = var_3_2.isBoss
		}
	})

	local var_3_7 = var_3_6:get("potraitFrame"):size().width

	var_3_6:get("potraitFrame").panel:anchorPoint(cc.p(0.5, 0.5)):xy(var_3_7 / 2, var_3_7 / 2)
	var_3_6:get("nameText"):text(var_3_1)
	var_3_6:get("level"):text(var_3_3)

	local var_3_8 = var_3_6:get("attrIcon1")
	local var_3_9 = var_3_6:get("attrIcon2")

	var_3_8:texture(var_3_4)

	if var_3_5 then
		var_3_9:show():texture(var_3_5)
	else
		var_3_9:hide()
	end

	arg_3_0:showAttrs()
end

function var_0_0.showAttrs(arg_4_0)
	local var_4_0 = arg_4_0:getResourceNode()
	local var_4_1 = var_4_0:get("attrPanel")
	local var_4_2 = arg_4_0.curObjSpr.model
	local var_4_3 = {
		"common/icon/logo_arrow_green.png",
		"common/icon/logo_arrow_red.png"
	}

	for iter_4_0 = 1, 6 do
		local var_4_4 = var_0_1[iter_4_0]
		local var_4_5 = var_4_2[var_4_4](var_4_2)
		local var_4_6 = var_4_2.attrs.base[var_4_4]
		local var_4_7 = math.floor(var_4_5 / var_4_6 * 100) / 100
		local var_4_8 = var_4_1:get("attr" .. iter_4_0)

		var_4_8:get("rate"):text("x" .. var_4_7)

		if math.abs(var_4_7 - 1) < 1e-05 then
			var_4_8:get("arrow"):hide()
		else
			var_4_8:get("arrow"):show():texture(var_4_7 > 1 and var_4_3[1] or var_4_3[2])
		end
	end

	local var_4_9 = {}

	for iter_4_1 = 1, 2 do
		local var_4_10 = var_4_0:get("item" .. iter_4_1)

		if not var_4_9[iter_4_1] then
			var_4_10:get("item.icon"):hide()
			var_4_10:get("item.count"):hide()
			var_4_10:get("name"):hide()
		end
	end

	local var_4_11 = {}

	for iter_4_2 = 1, 4 do
		local var_4_12 = var_4_0:get("spePanel" .. iter_4_2)

		if not var_4_11[iter_4_2] then
			var_4_12:get("iconItem.icon"):hide()
			var_4_12:get("name"):hide()
		end
	end
end

function var_0_0.onCloseBtnClick(arg_5_0)
	arg_5_0:hide()
end

return var_0_0
