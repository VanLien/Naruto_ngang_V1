local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("BossInfoPanel", var_0_0)

var_0_1.RESOURCE_FILENAME = "battle_boss_info.json"
var_0_1.RESOURCE_BINDING = {
	centerPanel = "centerPanel",
	refreshBtnL = {
		varname = "refreshBtnL",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRefreshBtnLClick")
			}
		}
	},
	refreshBtnR = {
		varname = "refreshBtnR",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRefreshBtnRClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.battleView = arg_1_1

	arg_1_0:getResourceNode():onClick(function()
		arg_1_2:stop()
		var_0_0.onClose(arg_1_0)
	end)

	local var_1_0 = arg_1_0.battleView.sceneID
	local var_1_1 = arg_1_0.battleView:getPlayModel().curWave
	local var_1_2 = arg_1_0.battleView._play:getMonsterCsv(var_1_0, var_1_1)

	arg_1_0.bossTb = {}

	for iter_1_0 = 1, 6 do
		local var_1_3 = var_1_2.bossMark[iter_1_0]
		local var_1_4 = var_1_2.monsters[iter_1_0] or 0

		if var_1_3 == 1 and var_1_4 > 0 then
			table.insert(arg_1_0.bossTb, var_1_4)
		end
	end

	arg_1_0.centerPanel:get("attrText"):setString(gLanguageCsv.attribute .. ":")
	arg_1_0.centerPanel:get("rareText"):setString(gLanguageCsv.rarity .. ":")
	arg_1_0.centerPanel:get("descArea1.title"):setString(gLanguageCsv.summary .. ":")
	arg_1_0.centerPanel:get("descArea2.title"):setString(gLanguageCsv.uniqueSkill .. ":")
	arg_1_0.refreshBtnL:hide()

	if table.length(arg_1_0.bossTb) <= 1 then
		arg_1_0.refreshBtnR:hide()
	end

	arg_1_0.curBossIdx = 1

	arg_1_0:showBossInfo(arg_1_0.curBossIdx)
end

function var_0_1.showBossInfo(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0.bossTb[arg_3_1]
	local var_3_1 = csv.unit[var_3_0]

	if not var_3_1 then
		return
	end

	local var_3_2 = arg_3_0:getResourceNode()

	arg_3_0.centerPanel:get("nameText"):setString(var_3_1.name)

	local var_3_3 = ui.ATTR_ICON[var_3_1.natureType]
	local var_3_4 = ui.ATTR_ICON[var_3_1.natureType2]

	arg_3_0.centerPanel:get("attrIcon1"):loadTexture(var_3_3)
	arg_3_0.centerPanel:get("attrIcon2"):setVisible(var_3_4 ~= nil)

	if var_3_4 then
		arg_3_0.centerPanel:get("attrIcon2"):loadTexture(var_3_4)
	end

	arg_3_0.centerPanel:get("rareImg"):loadTexture(ui.RARITY_ICON[var_3_1.rarity])
	arg_3_0.centerPanel:get("potrait"):loadTexture(var_3_1.show)

	local function var_3_5(arg_4_0, arg_4_1)
		arg_4_1 = arg_4_1 or ""

		local var_4_0 = arg_3_0.centerPanel:get("descArea" .. arg_4_0)
		local var_4_1 = var_4_0:get("textArea")
		local var_4_2 = var_4_1:size()
		local var_4_3, var_4_4 = var_4_1:getPosition()
		local var_4_5 = rich.createWithWidth("#C0x5b545b#" .. arg_4_1, 40, deltaSize, var_4_2.width)

		var_4_5:setAnchorPoint(cc.p(0, 1))
		var_4_5:xy(var_4_3, var_4_4)
		var_4_0:add(var_4_5, 3)
	end

	local var_3_6 = csv.cards[var_3_1.cardID].introduction

	var_3_5(1, var_3_6)

	local var_3_7 = var_3_1.skillList
	local var_3_8

	if table.length(var_3_7) ~= 0 then
		var_3_8 = csv.skill[var_3_7[table.length(var_3_7)]].simDesc
	end

	var_3_5(2, var_3_8)
end

function var_0_1.onRefreshBtnLClick(arg_5_0)
	if table.length(arg_5_0.bossTb) == 1 then
		return
	end

	arg_5_0.curBossIdx = arg_5_0.curBossIdx - 1

	if arg_5_0.curBossIdx <= 1 then
		arg_5_0.curBossIdx = 1
	end

	arg_5_0:showBossInfo(arg_5_0.curBossIdx)

	local var_5_0 = arg_5_0:getResourceNode()

	if arg_5_0.curBossIdx == 1 then
		arg_5_0.refreshBtnL:hide()
	end

	arg_5_0.refreshBtnR:show()
end

function var_0_1.onRefreshBtnRClick(arg_6_0)
	if #arg_6_0.bossTb == 1 then
		return
	end

	arg_6_0.curBossIdx = arg_6_0.curBossIdx + 1

	if arg_6_0.curBossIdx >= table.length(arg_6_0.bossTb) then
		arg_6_0.curBossIdx = table.length(arg_6_0.bossTb)
	end

	arg_6_0:showBossInfo(arg_6_0.curBossIdx)

	local var_6_0 = arg_6_0:getResourceNode()

	if arg_6_0.curBossIdx == table.length(arg_6_0.bossTb) then
		arg_6_0.refreshBtnR:hide()
	end

	arg_6_0.refreshBtnL:show()
end

return var_0_1
