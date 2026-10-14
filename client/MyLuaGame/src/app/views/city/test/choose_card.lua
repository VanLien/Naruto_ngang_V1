local var_0_0 = require("app.views.city.test.test_define")
local var_0_1 = require("app.views.city.test.test_easy")
local var_0_2 = require("app.views.city.test.test_protocol")
local var_0_3 = require("3rd.msgpack")
local var_0_4 = var_0_3.pack
local var_0_5 = var_0_3.unpack
local var_0_6 = require("editor.fs")
local var_0_7 = require("app.views.city.test.model.prefab")
local var_0_8 = require("app.views.city.test.easy_view")
local var_0_9 = require("app.views.city.test.multi_force")

require("battle.app_views.battle.battle_entrance.include")

local var_0_10 = csv.unit
local var_0_11 = csv.cards
local var_0_12 = csvClone(csv.test_battle)[1] or {}
local var_0_13 = {}

local function var_0_14(arg_1_0)
	print("load", arg_1_0)

	local var_1_0 = io.open(arg_1_0, "rb")
	local var_1_1 = var_1_0:read("*a")

	var_1_0:close()

	return var_0_5(var_1_1)
end

local function var_0_15(arg_2_0)
	local var_2_0 = {}

	for iter_2_0, iter_2_1 in pairs(arg_2_0) do
		local var_2_1 = false
		local var_2_2 = {}

		if type(iter_2_1) == "table" then
			for iter_2_2, iter_2_3 in pairs(iter_2_1) do
				if iter_2_2 == "__raw" then
					var_2_1 = true

					for iter_2_4, iter_2_5 in pairs(iter_2_3) do
						if type(iter_2_5) == "table" then
							var_2_2[iter_2_4] = var_0_15(iter_2_5)
						else
							var_2_2[iter_2_4] = iter_2_5
						end
					end
				end
			end
		end

		if not var_2_1 then
			var_2_0[iter_2_0] = iter_2_1
		else
			var_2_0[iter_2_0] = var_2_2
		end
	end

	print("###########")
	print_r(var_2_0)

	return var_2_0
end

local function var_0_16(arg_3_0, arg_3_1, arg_3_2)
	for iter_3_0 = 1, 2 do
		if iter_3_0 == 2 then
			arg_3_0 = arg_3_0 .. "\tvs\t"
		end

		for iter_3_1 = 1, arg_3_2 do
			arg_3_0 = string.format("%s team%d", arg_3_0, iter_3_1)

			for iter_3_2 = 1, 12 do
				if arg_3_1[iter_3_0][iter_3_1][iter_3_2] then
					arg_3_0 = string.format("%s %s(%d)", arg_3_0, csv.unit[arg_3_1[iter_3_0][iter_3_1][iter_3_2].roleId].name, iter_3_2)
				end
			end
		end
	end

	return arg_3_0
end

local var_0_17 = {
	CrossArena = 5,
	Pve = 8,
	Craft = 4,
	Chaos = 3,
	CrossMine = 6,
	BraveChallenge = 7,
	OneByOne = 2,
	Normal = 1
}
local var_0_18 = {
	"阵容模式",
	"单挑模式",
	"大乱斗模式",
	"竞技场模式",
	"跨服竞技场",
	"跨服商业街",
	"勇者挑战",
	"PVE模式"
}
local var_0_19 = {
	"btnManual|返回主界面",
	"btnFightTest|战斗测试",
	"btnFightView|战斗界面",
	"btnLoadRecord|加载战报",
	"btnBattleMonitor|战斗监控(关闭)",
	"btnShowHistory|战斗记录",
	"btnAddPrefab|添加精灵",
	"btnCleanTeam|清除布阵",
	"btnFullMp|满蓝",
	"btnAttrAdd|属性加成(开启)",
	"btnCloseRandFix|伤害波动(开启)",
	"btnRecordLog|战报Log导出",
	"btnMultiForce|多阵容战斗",
	"btnSyncFight|同步测试",
	"btnRandSeedSwitch|随机种子(关闭)",
	"btnExchangeSeat|交换位置",
	"btnSameSpeedRandFix|同速度随机(关闭)"
}
local var_0_20 = {
	breakBlock = true,
	strikeResistance = true,
	specialDefence = true,
	defenceIgnore = true,
	rebound = true,
	fightPoint = true,
	controlPer = true,
	dodge = true,
	specialDamage = true,
	damageSub = true,
	star = true,
	mp1 = true,
	defence = true,
	damageAdd = true,
	damage = true,
	block = true,
	strike = true,
	blockPower = true,
	speed = true,
	hp = true,
	strikeDamage = true,
	suckBlood = true,
	cure = true
}
local var_0_21 = {
	specialDefence = 3000,
	level = 100,
	mp1Recover = 1,
	natureRestraint = 1,
	mp2 = 1,
	damageDeepen = 1,
	damage = 10000,
	hit = 10000,
	classify = 0,
	specialDefenceIgnore = 1,
	strikeResistance = 1,
	mp2Recover = 1,
	star = 24,
	rebound = 0,
	defence = 3000,
	controlPer = 0,
	hpRecover = 1,
	block = 1,
	strike = 1,
	speed = 14,
	hp = 100000,
	immuneGate = 1,
	fightPoint = 0,
	suckBlood = 0,
	breakBlock = 1,
	damageReduce = 1,
	defenceIgnore = 1,
	ultimateAdd = 0,
	ultimateSub = 0,
	dodge = 1,
	specialDamage = 10000,
	damageSub = 1,
	mp1 = 1000,
	damageAdd = 1,
	gatePer = 1,
	blockPower = 1,
	strikeDamage = 15000,
	cure = 1,
	skills = {},
	passive_skills = {}
}
local var_0_22 = {
	potential = 1,
	decorations_level = 1,
	efforts = 1,
	skill_level = 1,
	decorations_star = 1,
	get_all_runes = 0,
	feel_level = 1,
	breake_through = 1,
	decorations_awake_level = 1,
	get_all_titles = 0,
	character = 0,
	get_all_limit_attribute = 0,
	individual = 1,
	star = 1,
	level = 1
}
local var_0_23 = {
	device = 0,
	talents = 0,
	handbook = 0
}
local var_0_24 = {
	4,
	5,
	6,
	1,
	2,
	3
}
local var_0_25 = {
	true,
	nil,
	true,
	true,
	true,
	true,
	true,
	true,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	true,
	true,
	nil,
	true
}
local var_0_26 = class("TestChooseCardView", cc.load("mvc").ViewBase)

var_0_26.RESOURCE_FILENAME = "test_choose_card.json"
var_0_26.RESOURCE_BINDING = {
	["stage.attrItem"] = "attrItem",
	["stage.fightTypeList"] = "fightTypeList",
	["stage.btnFightTypeSwitch.label"] = "btnFightTypeSwitchLabel",
	["stage.btnItem"] = "btnItem",
	["stage.forcePanel"] = "forcePanel",
	["stage.attrView"] = "attrView",
	["stage.panelSceneID.textSceneID"] = "textSceneID",
	["stage.prefab"] = "prefab",
	["stage.panelSceneID"] = "panelSceneID",
	["stage.gameObject"] = "gameObject",
	["stage.gameObjectView"] = "gameObjects",
	["stage.panelLeftAttrAdd"] = "panelLeftAttrAdd",
	stage = "stage",
	["stage.panelRightAttrAdd.inputAttr"] = "rightInputAttr",
	["stage.btnList"] = "btnList",
	["stage.prefabView"] = "prefabs",
	["stage.recordView"] = "recordView",
	["stage.panelSceneID.gateTypeList"] = "gateTypeList",
	["stage.panelSceneID.btnGateType"] = "btnGateType",
	["stage.panelRightAttrAdd"] = "panelRightAttrAdd",
	["stage.panelLeftAttrAdd.inputAttr"] = "leftInputAttr",
	["stage.btnFightTypeSwitch"] = {
		varname = "btnFightTypeSwitch",
		binds = {
			event = "click",
			method = bindHelper.self("onBtnFightTypeSwitch")
		}
	}
}
var_0_26.RESOURCE_STYLES = {
	full = true
}

function var_0_26.onCreate(arg_4_0, arg_4_1)
	battleEntrance.preloadConfig()

	arg_4_0.testBattle = userDefault.getForeverLocalKey("test_Info", {
		role = {},
		oldData = {}
	}, {
		rawKey = true
	})

	local var_4_0 = {}

	arg_4_0.resources = {}
	arg_4_0.lastClickObj = nil
	var_0_8.stage = arg_4_0.stage
	var_0_8.btnItem = arg_4_0.btnItem
	arg_4_0.dragSpriteNow = cc.Node:create():addTo(arg_4_0.stage, 1000)
	arg_4_0.btnRecordData = {}
	arg_4_0.leftAttrAdd = 1
	arg_4_0.rightAttrAdd = 1
	arg_4_0.gameEnvData = nil
	arg_4_0.drawNode = cc.DrawNode:create()

	arg_4_0.stage:addChild(arg_4_0.drawNode, 2000)

	local var_4_1 = cc.p(arg_4_0.gameObjects:x(), arg_4_0.gameObjects:y())
	local var_4_2 = arg_4_0.gameObjects:size()

	arg_4_0.gameObjectsRect = cc.rect(var_4_1.x, var_4_1.y, var_4_2.width, var_4_2.height)

	arg_4_0:initBtnState()
	arg_4_0:initFightTypeList()
	arg_4_0:initTextAttrAdd()

	for iter_4_0, iter_4_1 in pairs(arg_4_0.testBattle.role) do
		if arg_4_0.testBattle.role[iter_4_0] == "1" then
			arg_4_0:addRes(iter_4_0)
		end
	end

	if arg_4_1 ~= nil then
		arg_4_0.testBattle.oldData = arg_4_1

		userDefault.setForeverLocalKey("test_Info", arg_4_0.testBattle, {
			rawKey = true
		})
	end

	arg_4_0:loadOldData(arg_4_0.testBattle.oldData, var_4_0)
	arg_4_0:checkBtnState()

	arg_4_0.leftForceInfo = {}
	arg_4_0.rightForceInfo = {}

	arg_4_0.prefabs:x(display.sizeInViewRect.x)
	arg_4_0:showRecordView()
end

function var_0_26.initBtnState(arg_5_0)
	for iter_5_0, iter_5_1 in pairs(var_0_19) do
		local var_5_0 = arg_5_0.btnItem:clone()
		local var_5_1 = string.split(iter_5_1, "|")
		local var_5_2 = var_5_1[1]
		local var_5_3 = "on" .. var_5_2:gsub("^%l", string.upper)

		var_5_0:get("label"):setString(var_5_1[2])

		if arg_5_0[var_5_3] then
			var_5_0:addClickEventListener(functools.handler(arg_5_0, arg_5_0[var_5_3]))
		end

		arg_5_0[var_5_2] = var_5_0

		arg_5_0.btnList:pushBackCustomItem(var_5_0)
	end

	arg_5_0:onBtnFullMp(nil, gSceneAttrCorrect[var_0_0.TestSceneID].addMp1)
end

function var_0_26.initFightTypeList(arg_6_0)
	for iter_6_0, iter_6_1 in pairs(var_0_17) do
		local var_6_0 = arg_6_0.btnItem:clone()

		var_6_0:get("label"):setString(var_0_18[iter_6_1])
		var_6_0:addClickEventListener(functools.handler(arg_6_0, arg_6_0.changeFightType, iter_6_1))
		arg_6_0.fightTypeList:pushBackCustomItem(var_6_0)
	end
end

function var_0_26.initTextAttrAdd(arg_7_0)
	arg_7_0.leftInputAttr:setString(arg_7_0.leftAttrAdd)
	arg_7_0.leftInputAttr:addEventListener(function(arg_8_0)
		local var_8_0 = arg_8_0:text()

		arg_7_0.leftAttrAdd = tonumber(var_8_0) or 1
	end)
	arg_7_0.rightInputAttr:setString(arg_7_0.rightAttrAdd)
	arg_7_0.rightInputAttr:addEventListener(function(arg_9_0)
		local var_9_0 = arg_9_0:text()

		arg_7_0.rightAttrAdd = tonumber(var_9_0) or 1
	end)
end

function var_0_26.checkBtnState(arg_10_0)
	arg_10_0:updateBtnState(arg_10_0.btnShowHistory, #var_0_0.historyBattleInfo ~= 0)
	arg_10_0:onBtnAttrAdd(arg_10_0.btnAttrAdd, arg_10_0.btnRecordData.attrAdd)
	arg_10_0:onBtnBattleMonitor(nil, var_0_0.Monitor)
	arg_10_0:onBtnCloseRandFix(nil, var_0_0.closeRandFix)
	arg_10_0:onBtnRandSeedSwitch(nil, var_0_0.randSeedSwitch)
	arg_10_0:onBtnSameSpeedRandFix(nil, var_0_0.sameSpeedRandFix)
end

function var_0_26.loadOldData(arg_11_0, arg_11_1, arg_11_2)
	arg_11_1 = arg_11_1 or {}

	arg_11_0:changeFightType(arg_11_1._fightType or var_0_17.Normal)

	if arg_11_1._resources then
		for iter_11_0, iter_11_1 in pairs(arg_11_1._resources) do
			arg_11_0:addRes(iter_11_1.roleId, iter_11_1.extraData)
		end
	end

	if arg_11_1._scene then
		arg_11_0.gate:parseScene(arg_11_1._scene)
	else
		arg_11_0.gate:parseRecord(arg_11_2)
	end

	if arg_11_0.fightType == var_0_17.Pve then
		arg_11_0.gate:changeGateType(arg_11_1._gameEnvData.gateType or 1)
		arg_11_0.textSceneID:setString(arg_11_1._gameEnvData.sceneID or "")
	end

	arg_11_0.btnRecordData = arg_11_1._btnRecordData or {}
	arg_11_0.gameEnvData = arg_11_1._gameEnvData
end

function var_0_26.updateBtnState(arg_12_0, arg_12_1, arg_12_2)
	arg_12_1:setBright(arg_12_2)
	arg_12_1:setEnabled(arg_12_2)
end

function var_0_26.changeFightType(arg_13_0, arg_13_1)
	if arg_13_0.fightType and arg_13_0.fightType == arg_13_1 then
		return
	end

	local var_13_0 = var_0_18[arg_13_1]

	arg_13_0.btnFightTypeSwitchLabel:setString(var_13_0)

	arg_13_0.fightType = arg_13_1
	arg_13_0.gameEnvData = nil
	arg_13_0.leftAttrAdd, arg_13_0.rightAttrAdd = 1, 1

	arg_13_0:initTextAttrAdd()
	arg_13_0.fightTypeList:hide()
	arg_13_0.panelSceneID:hide()
	arg_13_0.panelLeftAttrAdd:show()
	arg_13_0.panelRightAttrAdd:show()
	arg_13_0.gameObjects:removeAllChildren()
	arg_13_0:updateBtnState(arg_13_0.btnFightView, true)
	arg_13_0:updateBtnState(arg_13_0.btnManual, true)

	if arg_13_1 == var_0_17.Normal then
		arg_13_0.gate = require("app.views.city.test.gate.normal_gate")
	elseif arg_13_1 == var_0_17.OneByOne then
		arg_13_0.gate = require("app.views.city.test.gate.single_gate")

		arg_13_0:updateBtnState(arg_13_0.btnFightView, false)
	elseif arg_13_1 == var_0_17.Chaos then
		arg_13_0.gate = require("app.views.city.test.gate.chaos_gate")
	elseif arg_13_1 == var_0_17.Craft then
		arg_13_0.gate = require("app.views.city.test.gate.craft_gate")
	elseif arg_13_1 == var_0_17.CrossArena then
		arg_13_0.gate = require("app.views.city.test.gate.cross_arena_gate")
	elseif arg_13_1 == var_0_17.CrossMine then
		arg_13_0.gate = require("app.views.city.test.gate.cross_mine_gate")

		local var_13_1 = arg_13_0.gameObjects:size()

		arg_13_0.gameObjects:getInnerContainer():size(3100, var_13_1.height)
	elseif arg_13_1 == var_0_17.BraveChallenge then
		arg_13_0.gate = require("app.views.city.test.gate.brave_challenge_gate")
	elseif arg_13_1 == var_0_17.Pve then
		arg_13_0.panelSceneID:show()
		arg_13_0.panelLeftAttrAdd:hide()
		arg_13_0.panelRightAttrAdd:hide()

		arg_13_0.gate = require("app.views.city.test.gate.pve_gate")
	end

	arg_13_0.gate = arg_13_0.gate.new(arg_13_0)

	arg_13_0.gate:init()
end

local var_0_27 = {
	validDamage = "有效伤害",
	["Rhp/special"] = "特殊治疗",
	totalDamage = "总伤害",
	["Rhp/buff"] = "BUFF治疗",
	["Dmg/link"] = "伤害链接",
	["Rhp/suckblood"] = "吸血治疗",
	firstKill = "首杀回合",
	extraHerosDamage = "召唤物伤害",
	kill = "击杀数",
	beAttack = "受击(暴击/抵御)",
	totalRound = "持续回合",
	["Rhp/skill"] = "技能治疗",
	totalResumeHp = "总治疗",
	["Dmg/skill"] = "技能伤害",
	totalTake = "承受伤害",
	["Dmg/rebound"] = "反伤伤害",
	firstBigSkillRound = "第一次大招回合",
	deadBigRound = "死亡回合",
	["Dmg/buff"] = "BUFF伤害",
	skillTime = "大招次数",
	["Dmg/allocate"] = "伤害分摊",
	onceMaxDamage = "单次最高伤害"
}

function var_0_26.onBtnShowHistory(arg_14_0)
	local var_14_0 = var_0_0.historyBattleInfo[1]
	local var_14_1 = var_0_0.allHistoryBattleInfo
	local var_14_2 = var_0_8.initScrollView(arg_14_0, var_0_8.stage:width(), var_0_8.stage:height() * 2)

	if not var_14_0 then
		return
	end

	local function var_14_3(arg_15_0, arg_15_1)
		arg_15_1 = var_0_27[arg_15_1] or arg_15_1

		local var_15_0 = cc.c4b(255, 255, 255, 255)

		local function var_15_1(arg_16_0)
			if string.find(arg_16_0, "伤害") then
				return cc.c4b(255, 0, 0, 255)
			elseif string.find(arg_16_0, "治疗") then
				return cc.c4b(0, 255, 0, 255)
			elseif string.find(arg_16_0, "名字") or string.find(arg_16_0, "站位") or string.find(arg_16_0, "胜败") then
				return cc.c4b(255, 255, 255, 255)
			else
				return cc.c4b(255, 165, 80, 255)
			end
		end

		if type(arg_15_1) == "string" then
			if arg_15_0 then
				var_15_0 = var_15_1(arg_15_1)
			else
				var_15_0 = cc.c4b(0, 190, 255, 255)
			end
		end

		return ccui.Text:create(arg_15_1, "font/youmi.ttf", 35):addTo(var_14_2.scrollView, 1):setTextColor(var_15_0):anchorPoint(arg_15_0 and cc.p(1, 0.5) or cc.p(1, 0.5))
	end

	local function var_14_4(arg_17_0, arg_17_1)
		if not var_0_27[arg_17_0] then
			return
		end

		local var_17_0 = math.huge
		local var_17_1 = 0

		for iter_17_0, iter_17_1 in pairs(arg_17_1) do
			if iter_17_1[2] then
				var_17_0 = math.min(var_17_0, iter_17_1[2])
				var_17_1 = math.max(var_17_1, iter_17_1[2])
			end
		end

		if arg_17_0 == "firstKill" or arg_17_0 == "firstBigSkillRound" then
			for iter_17_2, iter_17_3 in pairs(arg_17_1) do
				if iter_17_3[2] == var_17_0 and var_17_0 ~= 0 then
					iter_17_3[1]:setTextColor(cc.c4b(255, 255, 0, 255))
				end
			end
		elseif arg_17_0 == "totalRound" then
			for iter_17_4, iter_17_5 in pairs(arg_17_1) do
				if iter_17_5[2] == 20 then
					iter_17_5[1]:setTextColor(cc.c4b(255, 255, 0, 255))
				end
			end
		else
			for iter_17_6, iter_17_7 in pairs(arg_17_1) do
				if iter_17_7[2] == var_17_1 and var_17_1 ~= 0 then
					iter_17_7[1]:setTextColor(cc.c4b(255, 255, 0, 255))
				end
			end
		end
	end

	local var_14_5 = 0
	local var_14_6 = 0
	local var_14_7
	local var_14_8
	local var_14_9
	local var_14_10

	local function var_14_11(arg_18_0, arg_18_1, arg_18_2, ...)
		local var_18_0 = {
			...
		}

		var_14_5 = var_14_5 + 1
		var_14_8 = var_14_2.scrollView:width() / 10 * (var_14_5 - 0.5) + 100
		var_14_9 = var_14_2.scrollView:getInnerContainerSize().height - var_14_6 - 32
		var_14_7 = var_14_3(true, arg_18_0)

		local var_18_1 = {}

		if arg_18_2 then
			var_14_7:xy(var_14_8, var_14_2.scrollView:getInnerContainerSize().height - var_14_6 - 32)

			for iter_18_0 = 1, 12 do
				if iter_18_0 == 7 then
					var_14_9 = var_14_9 - 24
				end

				if var_14_0[iter_18_0] then
					var_14_9 = var_14_9 - 44

					local var_18_2, var_18_3 = arg_18_2(iter_18_0, ...)

					var_14_7 = var_14_3(false, var_18_2 or arg_18_1)

					var_14_7:xy(var_14_8, var_14_9)

					local var_18_4 = var_14_3(false, "_______________")

					var_18_4:setTextColor(cc.c4b(90, 90, 90, 255))
					var_18_4:xy(var_14_8, var_14_9 - 8)
					table.insert(var_18_1, {
						var_14_7,
						var_18_3
					})
				end
			end

			var_14_4(arg_18_0, var_18_1)
		else
			var_14_5 = 0
			var_14_6 = var_14_6 + 600
		end
	end

	local function var_14_12(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
		if #var_14_1 > 1 then
			local var_19_0 = 0

			for iter_19_0, iter_19_1 in ipairs(var_14_1) do
				if arg_19_2 == "all" then
					for iter_19_2, iter_19_3 in pairs(iter_19_1[arg_19_0][arg_19_1]) do
						var_19_0 = var_19_0 + iter_19_3:get(arg_19_3)
					end
				elseif iter_19_1[arg_19_0][arg_19_1][arg_19_2] then
					var_19_0 = var_19_0 + iter_19_1[arg_19_0][arg_19_1][arg_19_2]:get(arg_19_3)
				end
			end

			return math.ceil(var_19_0 / #var_14_1), math.ceil(var_19_0 / #var_14_1)
		else
			if not var_14_0[arg_19_0][arg_19_1][arg_19_2] then
				return 0
			end

			return var_14_0[arg_19_0][arg_19_1][arg_19_2]:get(arg_19_3), var_14_0[arg_19_0][arg_19_1][arg_19_2]:get(arg_19_3)
		end
	end

	local function var_14_13(arg_20_0, arg_20_1, arg_20_2)
		if #var_14_1 > 1 then
			local var_20_0 = 0

			for iter_20_0, iter_20_1 in ipairs(var_14_1) do
				if iter_20_1[arg_20_0][arg_20_1] then
					var_20_0 = var_20_0 + iter_20_1[arg_20_0][arg_20_1]:get(arg_20_2)
				end
			end

			return math.ceil(var_20_0 / #var_14_1), math.ceil(var_20_0 / #var_14_1)
		else
			if not var_14_0[arg_20_0][arg_20_1] then
				return 0
			end

			return var_14_0[arg_20_0][arg_20_1]:get(arg_20_2), var_14_0[arg_20_0][arg_20_1]:get(arg_20_2)
		end
	end

	local function var_14_14(arg_21_0, ...)
		local var_21_0 = #var_14_1

		if var_21_0 > 1 then
			local var_21_1

			for iter_21_0, iter_21_1 in ipairs(var_14_1) do
				local var_21_2 = table.get(iter_21_1[arg_21_0], ...)

				if var_21_2 then
					var_21_1 = (var_21_1 or 0) + var_21_2
				end

				if var_21_0 == iter_21_0 then
					var_21_1 = var_21_1 and math.ceil(var_21_1 / var_21_0)
				end
			end

			return var_21_1, var_21_1
		end

		return table.get(var_14_0[arg_21_0], ...), table.get(var_14_0[arg_21_0], ...)
	end

	local function var_14_15(arg_22_0, ...)
		return table.get(var_14_0[arg_22_0], ...), table.get(var_14_0[arg_22_0], ...)
	end

	local function var_14_16(arg_23_0, ...)
		local var_23_0 = {
			...
		}
		local var_23_1 = #var_14_1

		if var_23_1 > 1 then
			local var_23_2
			local var_23_3
			local var_23_4
			local var_23_5

			for iter_23_0, iter_23_1 in ipairs(var_14_1) do
				local var_23_6 = table.get(iter_23_1[arg_23_0], var_23_0[1]) or 0
				local var_23_7 = table.get(iter_23_1[arg_23_0], var_23_0[2]) or 0
				local var_23_8 = table.get(iter_23_1[arg_23_0], var_23_0[3]) or 0

				var_23_2 = (var_23_2 or 0) + var_23_6
				var_23_3 = (var_23_3 or 0) + var_23_7
				var_23_4 = (var_23_4 or 0) + var_23_8

				if var_23_1 == iter_23_0 and var_23_2 and var_23_3 and var_23_4 then
					var_23_2 = math.ceil(var_23_2 / var_23_1)
					var_23_5 = var_23_2 .. "(" .. math.ceil(var_23_3 / var_23_1) .. "/" .. math.ceil(var_23_4 / var_23_1) .. ")"
				end
			end

			return var_23_5, var_23_2
		end

		return (table.get(var_14_0[arg_23_0], var_23_0[1]) or 0) .. "(" .. (table.get(var_14_0[arg_23_0], var_23_0[2]) or 0) .. "/" .. (table.get(var_14_0[arg_23_0], var_23_0[3]) or 0) .. ")", table.get(var_14_0[arg_23_0], var_23_0[1])
	end

	local var_14_17 = battle.ValueType.normal

	var_14_11("名字", "", var_14_15, "name")
	var_14_11("站位", "", var_14_15, "seat")
	var_14_11("胜败", "", var_14_15, "result")
	var_14_11("Dmg/skill", 0, var_14_12, "totalDamage", battle.DamageFrom.skill, var_14_17)
	var_14_11("Dmg/buff", 0, var_14_12, "totalDamage", battle.DamageFrom.buff, var_14_17)
	var_14_11("Dmg/rebound", 0, var_14_12, "totalDamage", battle.DamageFrom.rebound, var_14_17)
	var_14_11("Dmg/allocate", 0, var_14_12, "totalDamage", battle.DamageFromExtra.allocate, var_14_17)
	var_14_11("Dmg/link", 0, var_14_12, "totalDamage", battle.DamageFromExtra.link, var_14_17)
	var_14_11("extraHerosDamage", 0, var_14_14, "extraHerosDamage")
	var_14_11("validDamage", 0, var_14_13, "_totalDamage", battle.ValueType.valid)
	var_14_11("totalDamage", 0, var_14_13, "_totalDamage", var_14_17)
	var_14_11("lineFeed")
	var_14_11("名字", "", var_14_15, "name")
	var_14_11("totalTake", 0, var_14_12, "totalTakeDamage", "all", var_14_17)
	var_14_11("Rhp/skill", 0, var_14_12, "totalResumeHp", battle.ResumeHpFrom.skill, var_14_17)
	var_14_11("Rhp/buff", 0, var_14_12, "totalResumeHp", battle.ResumeHpFrom.buff, var_14_17)
	var_14_11("Rhp/suckblood", 0, var_14_12, "totalResumeHp", battle.ResumeHpFrom.suckblood, var_14_17)
	var_14_11("Rhp/special", 0, var_14_14, "resumeSpecialHp")
	var_14_11("totalResumeHp", 0, var_14_13, "_totalResumeHp", var_14_17)
	var_14_11("kill", 0, var_14_14, "kill")
	var_14_11("firstKill", 0, var_14_14, "firstKill")
	var_14_11("skillTime", 0, var_14_14, "skillTime", battle.MainSkillType.BigSkill)
	var_14_11("firstBigSkillRound", 20, var_14_14, "firstBigSkillRound")
	var_14_11("lineFeed")
	var_14_11("名字", "", var_14_15, "name")
	var_14_11("deadBigRound", 20, var_14_14, "deadBigRound")
	var_14_11("beAttack", "0(0/0)", var_14_16, "beAttack", "beAttackStrike", "beAttackBlock")
	var_14_11("onceMaxDamage", 0, var_14_14, "onceMaxDamage")
	var_14_11("totalRound", 0, var_14_14, "totalRound")
end

function var_0_26.onBtnCleanTeam(arg_24_0)
	arg_24_0.gate:cleanGameObject()

	arg_24_0.gameEnvData = nil
end

function var_0_26.onBtnBattleMonitor(arg_25_0, arg_25_1, arg_25_2)
	if arg_25_2 == nil then
		arg_25_2 = not var_0_0.Monitor
	end

	if arg_25_2 then
		arg_25_0.btnBattleMonitor:get("label"):text("战斗监控(开启)")
	else
		arg_25_0.btnBattleMonitor:get("label"):text("战斗监控(关闭)")
	end

	var_0_0.Monitor = arg_25_2

	arg_25_0.btnBattleMonitor:setBright(arg_25_2)
	arg_25_0:updateBtnState(arg_25_0.btnRecordLog, arg_25_2)
	print("__TestDefine.Monitor", var_0_0.Monitor)
end

function var_0_26.onBtnFullMp(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = table.getraw(gSceneAttrCorrect)
	local var_26_1 = 1000
	local var_26_2 = ({
		[0] = 400,
		[var_26_1] = 0,
		[400] = var_26_1
	})[var_26_0[var_0_0.TestSceneID].addMp1] or 0
	local var_26_3 = arg_26_2 or var_26_2

	arg_26_0.btnFullMp:get("label"):text(string.format("%d%%怒气", var_26_3 / var_26_1 * 100))

	table.getraw(var_26_0[var_0_0.TestSceneID]).addMp1 = var_26_3
	table.getraw(var_26_0[-var_0_0.TestSceneID]).addMp1 = var_26_3

	var_0_1.log("scene Mp", var_26_3)
end

function var_0_26.onBtnCloseRandFix(arg_27_0, arg_27_1, arg_27_2)
	if arg_27_2 == nil then
		arg_27_2 = not var_0_0.closeRandFix
	end

	if arg_27_2 then
		arg_27_0.btnCloseRandFix:get("label"):text("伤害波动(关闭)")
	else
		arg_27_0.btnCloseRandFix:get("label"):text("伤害波动(开启)")
	end

	var_0_0.closeRandFix = arg_27_2
end

function var_0_26.onBtnSameSpeedRandFix(arg_28_0, arg_28_1, arg_28_2)
	if arg_28_2 == nil then
		arg_28_2 = not var_0_0.sameSpeedRandFix
	end

	if arg_28_2 then
		arg_28_0.btnSameSpeedRandFix:get("label"):text("同速度随机(开启)")
	else
		arg_28_0.btnSameSpeedRandFix:get("label"):text("同速度随机(关闭)")
	end

	arg_28_0.btnSameSpeedRandFix:setBright(arg_28_2)

	var_0_0.Monitor = arg_28_2
	var_0_0.sameSpeedRandFix = arg_28_2
end

function var_0_26.onBtnFightTypeSwitch(arg_29_0)
	local var_29_0 = arg_29_0.fightTypeList:isVisible()

	arg_29_0.fightTypeList:setVisible(not var_29_0)
end

function var_0_26.onBtnManual(arg_30_0)
	arg_30_0:onClose()
end

function var_0_26.onBtnFightView(arg_31_0)
	arg_31_0:createTestSceneData()

	if arg_31_0.fightType == var_0_17.Pve then
		local var_31_0 = arg_31_0.gate:getCurGateType()
		local var_31_1 = arg_31_0.textSceneID:getString()

		if var_31_0 == "" or var_31_1 == "" then
			return
		end

		arg_31_0.gameEnvData.gateType = tonumber(var_31_0)
		arg_31_0.gameEnvData.sceneID = tonumber(var_31_1)
	end

	local var_31_2, var_31_3 = arg_31_0:getFightRoleData()

	if #var_31_2 == 0 then
		return
	end

	arg_31_0.gameEnvData.roleOut = var_31_2[1]
	arg_31_0.gameEnvData.roleOut2 = arg_31_0.fightType == var_0_17.CrossArena and {
		{},
		{}
	} or {}
	arg_31_0.gameEnvData.gateType = var_31_3 or arg_31_0.gameEnvData.gateType

	local var_31_4 = arg_31_0:saveInitData()

	var_0_0.allHistoryBattleInfo = {}
	arg_31_0.gameEnvData.closeRandFix = var_0_0.closeRandFix

	if var_0_0.randSeedSwitch then
		arg_31_0.gameEnvData.randSeed = math.random(1, 1000000)
	end

	local var_31_5 = {
		_data = arg_31_0.gameEnvData,
		_modes = {
			fromRecordFile = true,
			baseMusic = "battle1.mp3",
			isRecord = (arg_31_0.gameEnvData.play_record_id or arg_31_0.gameEnvData.recordResult or arg_31_0.gameEnvData.isFromRecord) and true
		}
	}

	battleEntrance._switchUI(var_31_5, function()
		local var_32_0 = {
			_isTestScene = true,
			_results = {},
			_onResult = function(arg_33_0, arg_33_1)
				performWithDelay(gRootViewProxy:raw(), function()
					gGameUI:switchUI("login.view")
					gGameUI:stackUI("city.test.choose_card", nil, {
						full = true
					}, var_31_4)
				end, 0)
			end
		}

		battleEntrance._localHack.postEndResultToServer(var_32_0)

		gRootViewProxy:raw().showEndView = var_32_0._onResult

		gRootViewProxy:call("backToLogin", var_31_4)
		performWithDelay(gRootViewProxy:raw(), function()
			local var_35_0 = gRootViewProxy:raw()._model.scene.play

			if not var_0_12.gateType and not var_35_0.OperatorArgs then
				var_35_0.OperatorArgs = battlePlay.TestGate.OperatorArgs
			end

			var_35_0:initFightOperatorMode()
		end, 1)
		battleEntrance._localHack.postEndResultToServer(var_32_0)
		battleEntrance._localHack.showEndView(var_32_0)
	end)
end

function var_0_26.onBtnFightTest(arg_36_0)
	arg_36_0:createTestSceneData()

	local var_36_0, var_36_1 = arg_36_0:getFightRoleData()

	if #var_36_0 == 0 then
		return
	end

	arg_36_0.gameEnvData.gateType = var_36_1 or arg_36_0.gameEnvData.gateType

	local var_36_2 = var_0_8.initBaseView(arg_36_0)

	var_0_8.addBtnListToView(var_36_2, {
		"btnClose|关闭",
		"btnStart|开始",
		"btnSendToServer|服务器计算",
		"btnStartLessTime|战斗5秒"
	}, cc.p(arg_36_0.stage:width() / 2, 100), var_0_8.CustomBtnType.Center)
	var_0_8.addInputControl(var_36_2, cc.p(arg_36_0.stage:width() / 2, arg_36_0.stage:height() / 2 + 200), cc.EDITBOX_INPUT_MODE_NUMERIC, "战斗测试次数", 1)
	var_0_8.addInputControl(var_36_2, cc.p(arg_36_0.stage:width() / 2, arg_36_0.stage:height() / 2), cc.EDITBOX_INPUT_MODE_SINGLELINE, "需要记录的buffid", 2)

	local function var_36_3()
		local var_37_0 = var_0_0.historyBattleInfo[1]
		local var_37_1 = var_0_0.allHistoryBattleInfo
		local var_37_2 = table.length(var_37_1)
		local var_37_3 = {}
		local var_37_4 = false

		for iter_37_0, iter_37_1 in ipairs(var_37_1) do
			for iter_37_2, iter_37_3 in pairs(iter_37_1) do
				if iter_37_3.buffTakeEffect then
					var_37_4 = true
					var_37_3[iter_37_3.seat] = var_37_3[iter_37_3.seat] or {}
					var_37_3[iter_37_3.seat].name = iter_37_3.name
					var_37_3[iter_37_3.seat].data = var_37_3[iter_37_3.seat].data or {}

					for iter_37_4, iter_37_5 in pairs(iter_37_3.buffTakeEffect) do
						var_37_3[iter_37_3.seat].data[iter_37_4] = var_37_3[iter_37_3.seat].data[iter_37_4] or 0
						var_37_3[iter_37_3.seat].data[iter_37_4] = var_37_3[iter_37_3.seat].data[iter_37_4] + iter_37_5
					end
				end
			end
		end

		if var_37_4 then
			var_0_8.addTextListView(var_36_2, cc.p(arg_36_0.stage:width() / 2 - 800, arg_36_0.stage:height() / 2 - 500), cc.size(1500, 400))
			var_36_2.listView:show()

			for iter_37_6, iter_37_7 in pairs(var_37_3) do
				local var_37_5 = iter_37_6 .. "号位 " .. iter_37_7.name .. " "

				for iter_37_8, iter_37_9 in pairs(iter_37_7.data) do
					var_37_5 = var_37_5 .. "buffid:" .. iter_37_8 .. " 总次数:" .. iter_37_9 .. "  "
				end

				local var_37_6 = ccui.Text:create(var_37_5, FONT_PATH, 36)

				var_37_6:getVirtualRenderer():setTextColor(cc.c4b(0, 255, 0, 200))
				var_37_6:enableOutline(cc.c4b(0, 0, 0, 255), 3)
				var_36_2.listView:pushBackCustomItem(var_37_6)
			end
		elseif var_36_2.listView then
			var_36_2.listView:hide()
		end
	end

	local var_36_4 = 1

	var_36_2.btnSendToServer:addTouchEventListener(function(arg_38_0, arg_38_1)
		if arg_38_1 == ccui.TouchEventType.ended then
			var_36_4 = var_36_2.editBox[1]:getText()
			var_36_4 = var_36_4 == "" and 100 or tonumber(var_36_4)

			local var_38_0 = string.format("%s_%s_%s", arg_36_0.gameEnvData.sceneID, arg_36_0.gameEnvData.gateType, os.date("%y%m%d-%H%M%S"))

			print("!!!!! choose_card", arg_36_0.gameEnvData.sceneID, arg_36_0.gameEnvData.gateType)

			for iter_38_0, iter_38_1 in pairs(var_36_0) do
				arg_36_0.gameEnvData.roleOut = iter_38_1

				local var_38_1 = var_38_0 .. string.format("_%s", iter_38_0)

				gGameApp.net:sendHttpRequest("POST", "http://localhost:9999/api/client/upload", var_0_4({
					filename = var_38_1 .. ".record",
					record = var_0_4(arg_36_0.gameEnvData),
					count = var_36_4
				}), cc.XMLHTTPREQUEST_RESPONSE_STRING, function(arg_39_0)
					gGameUI:showTip(string.format("发送战报:%s, 次数:%s, 结果:%s", var_38_1, var_36_4, arg_39_0.status))
				end)
			end
		end
	end)
	var_36_2.btnStart:addTouchEventListener(function(arg_40_0, arg_40_1)
		if arg_40_1 == ccui.TouchEventType.began then
			arg_36_0:updateBtnState(var_36_2.btnStart, false)
			arg_36_0:updateBtnState(var_36_2.btnClose, false)
			arg_36_0:updateBtnState(var_36_2.btnStartLessTime, false)
		elseif arg_40_1 == ccui.TouchEventType.ended then
			var_36_4 = var_36_2.editBox[1]:getText()
			var_0_0.buffId = string.split(var_36_2.editBox[2]:getText(), ",")
			var_36_4 = var_36_4 == "" and 1 or tonumber(var_36_4)
			var_0_0.allHistoryBattleInfo = {}
			arg_36_0.battleResultInfo = {}

			for iter_40_0, iter_40_1 in pairs(var_36_0) do
				arg_36_0:runGameLogicByRoleOut(iter_40_1, var_36_4, false)
			end

			print("+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-")

			for iter_40_2, iter_40_3 in ipairs(arg_36_0.battleResultInfo) do
				print(iter_40_3)
			end

			print("+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-")
			arg_36_0:updateBtnState(arg_36_0.btnShowHistory, #var_0_0.historyBattleInfo ~= 0)
			arg_36_0:updateBtnState(var_36_2.btnStart, true)
			arg_36_0:updateBtnState(var_36_2.btnClose, true)
			arg_36_0:updateBtnState(var_36_2.btnStartLessTime, true)
			var_36_3()
		end
	end)
	var_36_2.btnStartLessTime:addTouchEventListener(function(arg_41_0, arg_41_1)
		if arg_41_1 == ccui.TouchEventType.began then
			arg_36_0:updateBtnState(var_36_2.btnStart, false)
			arg_36_0:updateBtnState(var_36_2.btnClose, false)
			arg_36_0:updateBtnState(var_36_2.btnStartLessTime, false)
		elseif arg_41_1 == ccui.TouchEventType.ended then
			var_36_4 = var_36_2.editBox[1]:getText()
			var_36_4 = var_36_4 == "" and 1 or tonumber(var_36_4)
			var_0_0.buffId = string.split(var_36_2.editBox[2]:getText(), ",")
			var_0_0.allHistoryBattleInfo = {}

			for iter_41_0, iter_41_1 in pairs(var_36_0) do
				arg_36_0:runGameLogicByRoleOutLessTime(iter_41_1, var_36_4, false)
			end

			arg_36_0:updateBtnState(arg_36_0.btnShowHistory, #var_0_0.historyBattleInfo ~= 0)
			arg_36_0:updateBtnState(var_36_2.btnStart, true)
			arg_36_0:updateBtnState(var_36_2.btnClose, true)
			arg_36_0:updateBtnState(var_36_2.btnStartLessTime, true)
			var_36_3()
		end
	end)
end

function var_0_26.onBtnAddPrefab(arg_42_0)
	local var_42_0 = var_0_8.initScrollView(arg_42_0, arg_42_0.stage:width() * 10)

	var_0_8.addInputControl(var_42_0, cc.p(arg_42_0.stage:width() / 2 + 500, 100), cc.EDITBOX_INPUT_MODE_ANY, "精灵名称")

	for iter_42_0, iter_42_1 in ipairs(gHandbookArrayCsv) do
		local var_42_1 = var_0_11[iter_42_1.cardID]
		local var_42_2 = var_0_10[var_42_1.unitID]
		local var_42_3 = arg_42_0.prefab:clone()

		var_42_3:get("icon"):texture(var_42_2.iconSimple)

		var_42_3.id = var_42_1.unitID
		var_42_3.name = var_42_2.name
		var_42_3.index = var_42_0.scrollView:getChildrenCount() + 1

		local var_42_4 = cc.p(10, 5)
		local var_42_5 = 6
		local var_42_6 = cc.p(var_42_3:size().width / 2 + var_42_4.x, var_42_3:size().height / 2 + var_42_4.y)

		arg_42_0:addItemToScrollView(var_42_0.scrollView, var_42_3, var_42_4, var_42_6, var_42_5)

		if arg_42_0.resources[var_42_1.unitID] then
			arg_42_0:updateBtnState(var_42_3, false)
		else
			var_42_3:addClickEventListener(function(arg_43_0)
				arg_42_0:addRes(arg_43_0.id)
				arg_42_0:updateBtnState(arg_43_0, false)
				cache.setShader(arg_43_0, false, "hsl_gray")

				arg_42_0.testBattle.role[arg_43_0.id] = "1"

				userDefault.setForeverLocalKey("test_Info", arg_42_0.testBattle, {
					rawKey = true
				})
			end)
		end
	end

	var_42_0.editBox:registerScriptEditBoxHandler(function(arg_44_0, arg_44_1)
		if arg_44_0 == "ended" then
			local var_44_0 = string.gsub(var_42_0.editBox:getText(), "[%w%p]+", "")
			local var_44_1 = 1

			for iter_44_0, iter_44_1 in ipairs(var_42_0.scrollView:getChildren()) do
				iter_44_1:visible(false)

				if string.find(iter_44_1.name, var_44_0, 1) then
					local var_44_2 = iter_44_1.index

					if var_44_1 ~= var_44_2 then
						local var_44_3, var_44_4 = var_42_0.scrollView:getChildren()[var_44_2]:xy()

						var_42_0.scrollView:getChildren()[var_44_2]:xy(var_42_0.scrollView:getChildren()[var_44_1]:xy())
						var_42_0.scrollView:getChildren()[var_44_1]:xy(var_44_3, var_44_4)

						var_42_0.scrollView:getChildren()[var_44_2].index = var_44_1
						var_42_0.scrollView:getChildren()[var_44_1].index = var_44_2
					end

					iter_44_1:visible(true)

					var_44_1 = var_44_1 + 1
				end
			end
		end
	end)
end

function var_0_26.onBtnRecordLog(arg_45_0, arg_45_1)
	local var_45_0 = io.open(var_0_0.ReadRecordFolderPath)

	if not var_45_0 then
		os.execute("mkdir " .. var_0_0.ReadRecordFolderPath)
	else
		var_45_0:close()
	end

	local var_45_1 = var_0_0.ReadRecordFolderPath .. "\\log"
	local var_45_2 = io.open(var_45_1)

	if not var_45_2 then
		os.execute("mkdir " .. var_45_1)
	else
		var_45_2:close()
	end

	arg_45_0:onBtnAttrAdd(nil, false)

	local var_45_3 = userDefault.getForeverLocalKey
	local var_45_4 = 1

	local function var_45_5(arg_46_0)
		if arg_46_0.unitID == 3631 then
			return true
		end

		return false
	end

	function userDefault.getForeverLocalKey(...)
		return true
	end

	local var_45_6 = os.time()
	local var_45_7 = var_0_6.listAllFiles(var_0_0.ReadRecordFolderPath, function(arg_48_0)
		return arg_48_0:match("%.record$")
	end, false)
	local var_45_8 = 0

	for iter_45_0, iter_45_1 in pairs(var_45_7) do
		var_45_8 = var_45_8 + 1
	end

	local var_45_9 = io.open(var_45_1 .. string.format("\\%s.txt", "record"), "a")

	var_45_9:write("单位\t\t站位\t\t伤害(Buff\\反伤\\技能)\t\t治疗(Buff\\技能\\吸血)\t\t击杀\n\n")

	local var_45_10 = var_45_8

	for iter_45_2, iter_45_3 in pairs(var_45_7) do
		local var_45_11 = var_0_14(iter_45_2)
		local var_45_12 = var_0_15(var_45_11)

		if var_45_12.gateType == "cross_craft" or var_45_12.gateType == "craft" then
			arg_45_0:changeFightType(var_0_17.Craft)
		elseif var_45_12.gateType == game.GATE_TYPE.crossArena then
			arg_45_0:changeFightType(var_0_17.CrossArena)
		elseif var_45_12.gateType == game.GATE_TYPE.crossMine then
			arg_45_0:changeFightType(var_0_17.CrossMine)
		end

		arg_45_0.gameEnvData = var_45_12

		arg_45_0:runGameLogicByRoleOut(arg_45_0.gameEnvData.roleOut, var_45_4, function(arg_49_0)
			var_45_9:write(string.format("RunTime: (%d/%d), Seed: %d Result:%s\n", arg_49_0.time, var_45_4, arg_49_0.seed, arg_49_0.result))

			for iter_49_0 = 1, #var_0_0.historyBattleInfo do
				var_45_9:write(string.format("Wave: (%d/%d)\n", iter_49_0, #var_0_0.historyBattleInfo))

				for iter_49_1 = 1, 12 do
					local var_49_0 = var_0_0.historyBattleInfo[iter_49_0][iter_49_1]

					if var_49_0 then
						var_45_9:write(string.format("%s\t\t%d\t\t%d,%d,%d\t\t%d,%d,%d\t\t%d\n", var_49_0.name, var_49_0.id, var_49_0.totalDamage[battle.DamageFrom.buff]:get(1), var_49_0.totalDamage[battle.DamageFrom.rebound]:get(1), var_49_0.totalDamage[battle.DamageFrom.skill]:get(1), var_49_0.totalResumeHp[battle.ResumeHpFrom.buff]:get(1), var_49_0.totalResumeHp[battle.ResumeHpFrom.skill]:get(1), var_49_0.totalResumeHp[battle.ResumeHpFrom.suckblood]:get(1), var_49_0.kill or 0))
					end
				end
			end

			var_45_9:write("\n\n")

			if arg_49_0.time == 10 then
				var_45_9:write(string.format("[INFO] 总战斗测试次数: %d (%d vs %d)", 10, arg_49_0.win, arg_49_0.lose))
			end
		end)

		var_45_10 = var_45_10 - 1

		print("record to log <%d/%d> !!!!!!!!!!!", var_45_10, var_45_8)
	end

	var_45_9:close()

	local var_45_13 = var_0_6.listAllFiles(var_0_0.ReadRecordFolderPath, function(arg_50_0)
		return arg_50_0:match("%.play$")
	end, false)
	local var_45_14 = 0

	for iter_45_4, iter_45_5 in pairs(var_45_13) do
		var_45_14 = var_45_14 + 1
	end

	local var_45_15 = io.open(var_45_1 .. string.format("\\%s.txt", "play"), "a")

	var_45_15:write("单位\t\t站位\t\t伤害(Buff\\反伤\\技能)\t\t治疗(Buff\\技能\\吸血)\t\t击杀\n\n")

	local var_45_16 = var_45_14

	for iter_45_6, iter_45_7 in pairs(var_45_13) do
		local var_45_17 = var_0_14(iter_45_6)
		local var_45_18 = var_45_17[1]

		if type(var_45_17[2]) == "table" then
			var_45_17 = var_45_17[2]
		else
			var_45_17 = var_0_5(var_45_17[2])
		end

		arg_45_0.gameEnvData = arg_45_0:parseBattle(var_45_18, var_45_17)

		arg_45_0:runGameLogicByRoleOut(arg_45_0.gameEnvData.roleOut, var_45_4, function(arg_51_0)
			var_45_15:write(string.format("RunTime: (%d/%d), Seed: %d Result:%s\n", arg_51_0.time, var_45_4, arg_51_0.seed, arg_51_0.result))

			for iter_51_0 = 1, #var_0_0.historyBattleInfo do
				var_45_15:write(string.format("Wave: (%d/%d)\n", iter_51_0, #var_0_0.historyBattleInfo))

				for iter_51_1 = 1, 12 do
					local var_51_0 = var_0_0.historyBattleInfo[iter_51_0][iter_51_1]

					if var_51_0 then
						var_45_15:write(string.format("%s\t\t%d\t\t%d,%d,%d\t\t%d,%d,%d\t\t%d\n", var_51_0.name, var_51_0.seat, var_51_0.totalDamage[battle.DamageFrom.buff]:get(1), var_51_0.totalDamage[battle.DamageFrom.rebound]:get(1), var_51_0.totalDamage[battle.DamageFrom.skill]:get(1), var_51_0.totalResumeHp[battle.ResumeHpFrom.buff]:get(1), var_51_0.totalResumeHp[battle.ResumeHpFrom.skill]:get(1), var_51_0.totalResumeHp[battle.ResumeHpFrom.suckblood]:get(1), var_51_0.kill or 0))
					end
				end
			end

			var_45_15:write("\n\n")

			if arg_51_0.time == 10 then
				var_45_15:write(string.format("[INFO] 总战斗测试次数: %d (%d vs %d)\n\n", 10, arg_51_0.win, arg_51_0.lose))
			end
		end)

		var_45_16 = var_45_16 - 1

		print(string.format("play to log <%d/%d> !!!!!!!!!!!", var_45_16, var_45_14))
	end

	var_45_15:close()
	print("!!!!!!!!!!!!!! cost time", os.time() - var_45_6, "s")

	userDefault.getForeverLocalKey = var_45_3
end

function var_0_26.onBtnSyncFight(arg_52_0, arg_52_1)
	function userDefault.getForeverLocalKey(...)
		return true
	end

	gGameApp.net:doRealtime("192.168.1.96", 1234, function(arg_54_0, arg_54_1)
		if arg_54_0 then
			print_r(arg_54_0)

			local var_54_0 = gGameModel.battle:getData()

			print("!!!!!!!!!!!!!!", gGameModel, dump(var_54_0, nil, 999))

			var_54_0.operateForce = arg_54_0.operate_force

			local var_54_1 = {
				_data = var_54_0,
				_modes = {
					baseMusic = "battle1.mp3"
				}
			}

			battleEntrance._switchUI(var_54_1, function()
				local var_55_0 = {
					_isTestScene = true,
					_results = {},
					_onResult = function(arg_56_0, arg_56_1)
						performWithDelay(gRootViewProxy:raw(), function()
							gGameUI:switchUI("login.view")
							gGameUI:stackUI("city.test.choose_card", nil, {
								full = true
							})
						end, 0)
					end
				}

				battleEntrance._localHack.postEndResultToServer(var_55_0)

				gRootViewProxy:raw().showEndView = var_55_0._onResult

				battleEntrance._localHack.postEndResultToServer(var_55_0)
				battleEntrance._localHack.showEndView(var_55_0)
			end)
		end

		if arg_54_1 then
			gGameUI:showTip(arg_54_1.err)
		end
	end)
end

function var_0_26.onBtnRandSeedSwitch(arg_58_0, arg_58_1, arg_58_2)
	if arg_58_2 == nil then
		arg_58_2 = not var_0_0.randSeedSwitch
	end

	if arg_58_2 then
		arg_58_0.btnRandSeedSwitch:get("label"):text("随机种子(开启)")
	else
		arg_58_0.btnRandSeedSwitch:get("label"):text("随机种子(关闭)")
	end

	print("randSeedSwitch", arg_58_2)

	var_0_0.randSeedSwitch = arg_58_2
end

function var_0_26.onBtnExchangeSeat(arg_59_0, arg_59_1)
	arg_59_0.gate:exchange()
end

function var_0_26.onBtnAttrAdd(arg_60_0, arg_60_1, arg_60_2)
	if arg_60_2 == nil then
		if arg_60_0.btnRecordData.attrAdd == nil then
			arg_60_0.btnRecordData.attrAdd = false
		end

		arg_60_0.btnRecordData.attrAdd = not arg_60_0.btnRecordData.attrAdd
	else
		arg_60_0.btnRecordData.attrAdd = arg_60_2
	end

	if arg_60_0.btnRecordData.attrAdd then
		arg_60_0.btnAttrAdd:get("label"):text("属性加成(开启)")
	else
		arg_60_0.btnAttrAdd:get("label"):text("属性加成(关闭)")
	end

	print("attrAdd", arg_60_0.btnRecordData.attrAdd)
	arg_60_0.btnAttrAdd:setBright(arg_60_0.btnRecordData.attrAdd)
end

function var_0_26.onBtnUdpTest(arg_61_0, arg_61_1)
	local var_61_0 = {
		str = "撒大声地21312dsadas世界"
	}

	print("\n\n---------------------------")

	for iter_61_0, iter_61_1 in pairs(var_61_0) do
		print(iter_61_0, iter_61_1)
	end
end

function var_0_26.onBtnLoadRecord(arg_62_0, arg_62_1, arg_62_2, arg_62_3)
	arg_62_2 = arg_62_2 or "."

	local var_62_0 = var_0_6.listAllFiles(arg_62_2, function(arg_63_0)
		return arg_63_0:match("%.record$")
	end, false)

	local function var_62_1(arg_64_0, arg_64_1)
		local var_64_0 = string.format("%2d %s", arg_64_0, arg_64_1)

		if require("ffi").os == "Windows" then
			var_64_0 = require("editor.win32.ansi2unicode").a2u(var_64_0)
		end

		local var_64_1 = ccui.Text:create(var_64_0, FONT_PATH, arg_62_3 and 48 or 72)

		var_64_1:getVirtualRenderer():setTextColor(cc.c4b(0, 255, 0, 200))
		var_64_1:enableOutline(cc.c4b(0, 0, 0, 255), 3)
		var_64_1:setTouchEnabled(true)

		return var_64_1
	end

	local var_62_2 = arg_62_3 or var_0_8.initListView(arg_62_0)
	local var_62_3 = 1
	local var_62_4 = {}

	for iter_62_0, iter_62_1 in pairs(var_62_0) do
		table.insert(var_62_4, {
			name = iter_62_0,
			time = iter_62_1
		})
	end

	table.sort(var_62_4, function(arg_65_0, arg_65_1)
		return arg_65_0.name < arg_65_1.name
	end)

	for iter_62_2, iter_62_3 in ipairs(var_62_4) do
		local var_62_5 = iter_62_3.name
		local var_62_6 = iter_62_3.time
		local var_62_7 = var_62_1(var_62_3, var_62_5)

		var_62_7:addTouchEventListener(function(arg_66_0, arg_66_1)
			var_62_7:scale((arg_66_1 == ccui.TouchEventType.ended or arg_66_1 == ccui.TouchEventType.canceled) and 1 or 1.05)

			if arg_66_1 == ccui.TouchEventType.ended then
				local var_66_0 = var_0_14(var_62_5)
				local var_66_1 = var_0_15(var_66_0)

				if var_66_1.gateType == game.GATE_TYPE.crossCraft or var_66_1.gateType == game.GATE_TYPE.craft then
					arg_62_0:changeFightType(var_0_17.Craft)
				elseif var_66_1.gateType == game.GATE_TYPE.crossArena then
					arg_62_0:changeFightType(var_0_17.CrossArena)
				elseif var_66_1.gateType == game.GATE_TYPE.crossMine then
					arg_62_0:changeFightType(var_0_17.CrossMine)
				elseif var_0_25[var_66_1.gateType] then
					arg_62_0:changeFightType(var_0_17.Pve)
					arg_62_0.gate:initRecordGateAndSceneID(var_66_1.gateType, var_66_1.sceneID)
				else
					arg_62_0:changeFightType(var_0_17.Normal)
				end

				var_66_1.isFromRecord = true
				arg_62_0.gameEnvData = var_66_1

				arg_62_0:onBtnAttrAdd(nil, false)
				arg_62_0.gate:parseRecord(arg_62_0.gameEnvData.roleOut)
			end
		end)
		var_62_2.listView:pushBackCustomItem(var_62_7)

		var_62_3 = var_62_3 + 1
	end

	local var_62_8 = var_0_6.listAllFiles(arg_62_2, function(arg_67_0)
		return arg_67_0:match("%.play$")
	end, false)
	local var_62_9 = 1
	local var_62_10 = {}

	for iter_62_4, iter_62_5 in pairs(var_62_8) do
		table.insert(var_62_10, {
			name = iter_62_4,
			time = iter_62_5
		})
	end

	table.sort(var_62_10, function(arg_68_0, arg_68_1)
		return arg_68_0.name < arg_68_1.name
	end)

	for iter_62_6, iter_62_7 in ipairs(var_62_10) do
		local var_62_11 = iter_62_7.name
		local var_62_12 = iter_62_7.time
		local var_62_13 = var_62_1(var_62_9, var_62_11)

		var_62_13:addTouchEventListener(function(arg_69_0, arg_69_1)
			if arg_69_1 == ccui.TouchEventType.ended then
				local var_69_0 = var_0_14(var_62_11)
				local var_69_1 = var_69_0[1]

				if type(var_69_0[2]) == "table" then
					var_69_0 = var_69_0[2]
				else
					var_69_0 = var_0_5(var_69_0[2])
				end

				arg_62_0.gameEnvData = arg_62_0:parseBattle(var_69_1, var_69_0)

				arg_62_0:onBtnAttrAdd(nil, false)
				arg_62_0.gate:parseRecord(arg_62_0.gameEnvData.roleOut)
			end
		end)
		var_62_2.listView:pushBackCustomItem(var_62_13)

		var_62_9 = var_62_9 + 1
	end
end

function var_0_26.onBtnMultiForce(arg_70_0)
	local var_70_0 = var_0_8.initForceScrollView(arg_70_0, arg_70_0.stage:width() * 10)
	local var_70_1 = csvClone(csv.test_force)

	arg_70_0.unitTb = {
		left_front_tb = {},
		left_back_tb = {},
		right_front_tb = {},
		right_back_tb = {}
	}

	local var_70_2 = {}

	for iter_70_0, iter_70_1 in pairs(var_70_1) do
		if iter_70_0 <= 100 then
			table.insert(var_70_2, iter_70_1)
		elseif iter_70_0 > 100 and iter_70_0 <= 200 then
			if iter_70_1.priproity > 0 then
				table.insert(arg_70_0.unitTb.left_front_tb, iter_70_1)
			else
				table.insert(arg_70_0.unitTb.left_back_tb, iter_70_1)
			end
		elseif iter_70_0 > 200 then
			if iter_70_1.priproity > 0 then
				table.insert(arg_70_0.unitTb.right_front_tb, iter_70_1)
			else
				table.insert(arg_70_0.unitTb.right_back_tb, iter_70_1)
			end
		end
	end

	arg_70_0:addUnitPanel(var_70_0, arg_70_0.unitTb.left_front_tb, 1)
	arg_70_0:addUnitPanel(var_70_0, arg_70_0.unitTb.left_back_tb, 2)
	arg_70_0:addUnitPanel(var_70_0, arg_70_0.unitTb.right_front_tb, 3)
	arg_70_0:addUnitPanel(var_70_0, arg_70_0.unitTb.right_back_tb, 4)

	arg_70_0.dataTb = {}

	var_0_9.loadFiles(arg_70_0)
	var_0_9.fillDataTb(arg_70_0, arg_70_0.unitTb, arg_70_0.dataTb)
	var_0_8.addBtnListToView(var_70_0, {
		"btnClose|关闭",
		"btnStartForce|6v6开始",
		"btnStartSolo|1v1开始"
	}, cc.p(arg_70_0.stage:width() / 2, 100), var_0_8.CustomBtnType.Center)
	var_70_0.btnStartForce:addTouchEventListener(function(arg_71_0, arg_71_1)
		if arg_71_1 == ccui.TouchEventType.ended then
			local var_71_0 = arg_70_0:getZuheForce(arg_70_0.dataTb.left_front_tb, arg_70_0.dataTb.left_back_tb)
			local var_71_1 = arg_70_0:getZuheForce(arg_70_0.dataTb.right_front_tb, arg_70_0.dataTb.right_back_tb)

			arg_70_0:onForceTest(var_71_0, var_71_1)
		end
	end)
	var_70_0.btnStartSolo:addTouchEventListener(function(arg_72_0, arg_72_1)
		if arg_72_1 == ccui.TouchEventType.ended then
			local var_72_0 = {}
			local var_72_1 = {}

			for iter_72_0, iter_72_1 in ipairs(arg_70_0.dataTb.left_front_tb) do
				table.insert(var_72_0, iter_72_1)
			end

			for iter_72_2, iter_72_3 in ipairs(arg_70_0.dataTb.left_back_tb) do
				table.insert(var_72_0, iter_72_3)
			end

			for iter_72_4, iter_72_5 in ipairs(arg_70_0.dataTb.right_front_tb) do
				table.insert(var_72_1, iter_72_5)
			end

			for iter_72_6, iter_72_7 in ipairs(arg_70_0.dataTb.right_back_tb) do
				table.insert(var_72_1, iter_72_7)
			end

			if table.length(var_72_0) <= 0 or table.length(var_72_1) <= 0 then
				return
			end

			local var_72_2 = {}

			for iter_72_8, iter_72_9 in ipairs(var_72_0) do
				for iter_72_10, iter_72_11 in ipairs(var_72_1) do
					local var_72_3 = {
						iter_72_9,
						[7] = iter_72_11
					}

					table.insert(var_72_2, var_72_3)
				end
			end

			local var_72_4 = 0
			local var_72_5 = 0
			local var_72_6 = socket.gettime()
			local var_72_7 = 1

			while true do
				if var_72_7 > #var_72_2 then
					break
				end

				if socket.gettime() - var_72_6 >= 0.2 then
					var_0_9.requestFightSolo(arg_70_0, var_72_2[var_72_7], var_72_7, function(arg_73_0, arg_73_1, arg_73_2, arg_73_3)
						if arg_73_0.ret then
							local var_73_0 = arg_73_2

							print("----------------------------------------")
							print("第" .. tostring(arg_73_3) .. "场")

							for iter_73_0, iter_73_1 in pairs(var_73_0) do
								if iter_73_0 == 7 then
									print("vs")
								end

								print(var_0_11[iter_73_1.card_id].name .. " ")
							end

							print("\n")
							print("结果:" .. arg_73_1.result[1] .. "\n")
							print("积分:" .. arg_73_1.result[2] .. " vs " .. arg_73_1.result[3])

							if arg_73_1.result[1] == "win" then
								var_72_4 = var_72_4 + 1
							else
								var_72_5 = var_72_5 + 1
							end
						else
							print("----------------------------------------")
							print("第" .. tostring(arg_73_3) .. "场")
							print("结果失败")
						end

						print("\n")
						print("总场次:" .. tostring(var_72_4 + var_72_5) .. " 左胜:" .. tostring(var_72_4) .. " 右胜:" .. tostring(var_72_5))
					end)

					var_72_7 = var_72_7 + 1
					var_72_6 = socket.gettime()
				end
			end
		end
	end)
end

function var_0_26.addGameObject(arg_74_0, arg_74_1)
	arg_74_0.gate:addGameObject(arg_74_1)
end

function var_0_26.addRes(arg_75_0, arg_75_1, arg_75_2)
	if arg_75_1 and not arg_75_0.resources[arg_75_1] then
		local var_75_0 = var_0_7.new(arg_75_0.prefab:clone())
		local var_75_1 = var_75_0.node
		local var_75_2 = cc.p(10, 2)
		local var_75_3 = 3
		local var_75_4 = cc.p(var_75_1:size().width / 2 + var_75_2.x, var_75_1:size().height / 2 + var_75_2.y)

		arg_75_0:addItemToScrollView(arg_75_0.prefabs, var_75_1, var_75_2, var_75_4, var_75_3)
		var_75_1:onTouch(functools.handler(arg_75_0, arg_75_0.dragSprite, var_75_0))
		var_75_1:get("add"):addClickEventListener(functools.handler(arg_75_0, arg_75_0.addGameObject, var_75_0))
		var_75_1:get("del"):addClickEventListener(functools.handler(arg_75_0, arg_75_0.delRes, var_75_0))
		var_75_0:init(arg_75_1, arg_75_2 or clone(var_0_21))

		arg_75_0.resources[arg_75_1] = var_75_0
	end
end

function var_0_26.delRes(arg_76_0, arg_76_1)
	if arg_76_0.lastClickObj and arg_76_0.lastClickObj.id == arg_76_1.id then
		arg_76_0.lastClickObj = nil

		arg_76_0:showAttr()
	end

	arg_76_0:delItemFromScrollView(arg_76_0.prefabs, arg_76_1.node)

	arg_76_0.resources[arg_76_1.roleId] = nil
	arg_76_0.testBattle.role[arg_76_1.roleId] = nil

	userDefault.setForeverLocalKey("test_Info", arg_76_0.testBattle, {
		rawKey = true
	})
	arg_76_1:clean()
end

function var_0_26.delItemFromScrollView(arg_77_0, arg_77_1, arg_77_2)
	if arg_77_0.lastClickObj and arg_77_0.lastClickObj.node:name() == arg_77_2:name() then
		arg_77_0.lastClickObj = nil
	end

	local var_77_0

	for iter_77_0, iter_77_1 in ipairs(arg_77_1:getChildren()) do
		print("delItemFromScrollView", iter_77_1:name())

		if var_77_0 then
			var_77_0 = cc.p(iter_77_1:x(), iter_77_1:y()), iter_77_1:xy(var_77_0.x, var_77_0.y)
		end

		if iter_77_1:name() == arg_77_2:name() then
			print("del sprite ", arg_77_2:name(), iter_77_0)

			var_77_0 = cc.p(iter_77_1:x(), iter_77_1:y())
		end
	end
end

function var_0_26.addItemToScrollView(arg_78_0, arg_78_1, arg_78_2, arg_78_3, arg_78_4, arg_78_5)
	local var_78_0 = arg_78_2:size().width * arg_78_2:scaleX()
	local var_78_1 = arg_78_2:size().height * arg_78_2:scaleY()
	local var_78_2 = 0
	local var_78_3 = 0
	local var_78_4 = arg_78_1:getChildrenCount()

	if arg_78_1 == arg_78_0.gameObjects then
		var_78_4 = arg_78_0.gate:getGameObjectIndex(var_78_4)
	end

	arg_78_1:addChild(arg_78_2)

	local var_78_5 = arg_78_4.x + math.modf(var_78_4 / arg_78_5) * (var_78_0 + arg_78_3.x)
	local var_78_6 = arg_78_1:height() - arg_78_4.y - math.fmod(var_78_4, arg_78_5) * (var_78_1 + arg_78_3.y)

	arg_78_2:xy(var_78_5, var_78_6)

	return arg_78_2
end

function var_0_26.onlyShowSelect(arg_79_0, arg_79_1, arg_79_2)
	if arg_79_2 and arg_79_2.selectShowChild then
		if arg_79_0.lastClickObj and arg_79_0.lastClickObj.id == arg_79_2.id then
			return
		end

		for iter_79_0, iter_79_1 in ipairs(arg_79_2.selectShowChild) do
			arg_79_2.node:get(iter_79_1):visible(true)
		end

		if arg_79_0.lastClickObj and not tolua.isnull(arg_79_0.lastClickObj.node) then
			for iter_79_2, iter_79_3 in ipairs(arg_79_0.lastClickObj.selectShowChild) do
				arg_79_0.lastClickObj.node:get(iter_79_3):visible(false)
			end
		end

		arg_79_0.lastClickObj = arg_79_2

		arg_79_0:showAttr(arg_79_2)

		local var_79_0 = arg_79_2.roleData.passive_skills

		if var_79_0 then
			local var_79_1 = csv.unit[arg_79_2.roleId].name .. "  [upd skill] skillList passive_skills    "

			for iter_79_4, iter_79_5 in pairs(var_79_0) do
				var_79_1 = var_79_1 .. iter_79_4 .. "=" .. iter_79_5 .. ";"
			end
		end
	end
end

function var_0_26.dragSprite(arg_80_0, arg_80_1, arg_80_2)
	local var_80_0

	if arg_80_2.name == "began" then
		arg_80_0.dragSpriteNow.collider = nil

		arg_80_0:onlyShowSelect(arg_80_0.prefabs, arg_80_1)

		local var_80_1 = arg_80_2.target:getTouchBeganPosition()
	elseif arg_80_2.name == "moved" then
		local var_80_2 = arg_80_0.dragSpriteNow:get("icon")
		local var_80_3 = arg_80_2.target:getTouchMovePosition()
		local var_80_4 = arg_80_0.dragSpriteNow.collider and arg_80_0.dragSpriteNow.collider:getRect() or nil

		if not var_80_2 then
			widget.addAnimation(arg_80_0.dragSpriteNow, arg_80_1.unit.unitRes, "standby_loop", 5):name("icon"):anchorPoint(0.5, 1):xy(0, 10):scale(1):setSkin(arg_80_1.unit.skin)
		end

		arg_80_0.dragSpriteNow:xy(var_80_3.x, var_80_3.y)

		if cc.rectContainsPoint(arg_80_0.gameObjectsRect, var_80_3) then
			if var_80_4 and cc.rectContainsPoint(var_80_4, var_80_3) then
				return
			end

			for iter_80_0, iter_80_1 in ipairs(arg_80_0.gate.scene) do
				local var_80_5 = iter_80_1:getRect()

				if cc.rectContainsPoint(iter_80_1:getRect(), var_80_3) then
					arg_80_0.dragSpriteNow.collider = iter_80_1

					arg_80_0.drawNode:clear()
					arg_80_0.drawNode:drawRect(cc.p(var_80_5.x, var_80_5.y), cc.p(var_80_5.x + var_80_5.width, var_80_5.y + var_80_5.height), cc.c4f(1, 0, 0, 1))

					return
				end
			end
		end

		arg_80_0.drawNode:clear()

		arg_80_0.dragSpriteNow.collider = nil
	elseif arg_80_2.name == "ended" or arg_80_2.name == "cancelled" then
		local var_80_6 = arg_80_0.dragSpriteNow:get("icon")
		local var_80_7 = arg_80_2.target:getTouchMovePosition()

		if arg_80_0.dragSpriteNow.collider then
			arg_80_0.dragSpriteNow.collider:init(arg_80_0.dragSpriteNow.collider.index, arg_80_0.dragSpriteNow.collider.seat, arg_80_1)
			arg_80_0.drawNode:clear()

			arg_80_0.dragSpriteNow.collider = nil
		end

		if var_80_6 then
			var_80_6:removeFromParent()
		end
	end
end

function var_0_26.showAttr(arg_81_0, arg_81_1)
	if not arg_81_1 then
		arg_81_0.attrView:removeAllChildren()

		return
	end

	arg_81_0.attrView:removeAllChildren()

	local var_81_0 = arg_81_1:getRoleData()
	local var_81_1 = {}
	local var_81_2 = {}
	local var_81_3

	if var_81_0 then
		for iter_81_0, iter_81_1 in csvMapPairs(var_81_0) do
			if type(iter_81_1) ~= "table" and var_0_20[iter_81_0] then
				local var_81_4 = iter_81_0
				local var_81_5 = var_0_21[iter_81_0]
				local var_81_6 = arg_81_0.attrItem:clone()
				local var_81_7 = var_81_6:get("head"):text(iter_81_0 .. ": ")

				var_81_6:get("edit"):setPlaceHolder(var_81_5):addEventListener(function(arg_82_0, arg_82_1)
					if arg_82_1 == 2 or arg_82_1 == 3 then
						local var_82_0, var_82_1 = string.gsub(arg_82_0:text(), "[^%d]", "")

						if var_82_1 > 0 then
							arg_82_0:text(var_82_0)

							return
						end

						var_82_0 = var_82_0 == "" and var_0_21[var_81_4] or tonumber(var_82_0)

						local var_82_2 = math.max(var_82_0, 0)

						print("[upd Attr]attr value ", var_81_4, var_82_2)

						arg_81_1.roleData[var_81_4] = var_82_2
					end
				end)

				if var_81_5 ~= iter_81_1 then
					var_81_6:get("edit"):text(iter_81_1)
				end

				arg_81_0.attrView:pushBackCustomItem(var_81_6)
				var_81_6:get("edit"):x(var_81_7:width() + var_81_7:x() + 10)
			end
		end

		local var_81_8 = "passive_skills"
		local var_81_9 = var_81_0[var_81_8] or {}
		local var_81_10 = ""
		local var_81_11 = csv.unit[arg_81_1.roleId].name

		for iter_81_2, iter_81_3 in pairs(var_81_9) do
			if var_81_10 == "" then
				var_81_10 = string.format("%s=%s;", iter_81_2, iter_81_3)
			else
				var_81_10 = string.format("%s%s=%s;", var_81_10, iter_81_2, iter_81_3)
			end
		end

		local var_81_12 = arg_81_0.attrItem:clone()
		local var_81_13 = var_81_12:get("head"):text(var_81_8 .. ": ")

		var_81_12:addTouchEventListener(function(arg_83_0, arg_83_1)
			if arg_83_1 == ccui.TouchEventType.ended then
				arg_81_0:createPassiveSkillList(arg_83_0, arg_81_1)
			end
		end)
		var_81_12:get("edit"):setPlaceHolder("1234"):addEventListener(function(arg_84_0, arg_84_1)
			if arg_84_1 == 2 or arg_84_1 == 3 then
				local var_84_0 = arg_84_0:text()

				print(var_81_11 .. "  [upd skill] skillList", var_81_8, var_84_0)

				local var_84_1 = string.split(var_84_0, ";")
				local var_84_2 = {}

				for iter_84_0, iter_84_1 in ipairs(var_84_1) do
					local var_84_3 = string.split(iter_84_1, "=")

					if var_84_3[1] and var_84_3[2] then
						var_84_2[tonumber(var_84_3[1])] = tonumber(var_84_3[2])
					end
				end

				dump(var_84_2)

				arg_81_1.roleData[var_81_8] = var_84_2
			end
		end)

		if var_81_10 ~= "1234" then
			var_81_12:get("edit"):text(var_81_10)
		end

		arg_81_0.attrView:pushBackCustomItem(var_81_12)
		var_81_12:get("edit"):x(var_81_13:width() + var_81_13:x() + 10)

		local var_81_14 = arg_81_0.attrItem:clone()
		local var_81_15 = var_81_14:get("head"):text("name")

		var_81_14:get("edit"):text(arg_81_1.node:name())
		arg_81_0.attrView:pushBackCustomItem(var_81_14)
		var_81_14:get("edit"):x(var_81_15:width() + var_81_15:x() + 10)

		return
	end
end

function var_0_26.createPassiveSkillList(arg_85_0, arg_85_1, arg_85_2)
	local var_85_0 = var_0_8.initBaseView(arg_85_0)
	local var_85_1 = ""
	local var_85_2 = "passive_skills"
	local var_85_3 = arg_85_0.attrView:clone()

	var_85_3:anchorPoint(cc.p(0.5, 0.5))
	var_85_3:x(var_85_0.root:width() / 2)
	var_85_3:y(var_85_0.root:height() / 2)
	var_85_0.root:addChild(var_85_3)

	local function var_85_4()
		arg_85_1:get("edit"):text(var_85_1)

		local var_86_0 = string.split(var_85_1, ";")
		local var_86_1 = {}

		for iter_86_0, iter_86_1 in ipairs(var_86_0) do
			local var_86_2 = string.split(iter_86_1, "=")

			if var_86_2[1] and var_86_2[2] then
				var_86_1[tonumber(var_86_2[1])] = tonumber(var_86_2[2])
			end
		end

		arg_85_2.roleData[var_85_2] = var_86_1
	end

	local function var_85_5()
		local var_87_0 = arg_85_2:getRoleData()[var_85_2] or {}

		var_85_3:removeAllChildren()

		var_85_1 = ""

		for iter_87_0, iter_87_1 in pairs(var_87_0) do
			if var_85_1 == "" then
				var_85_1 = string.format("%s=%s;", iter_87_0, iter_87_1)
			else
				var_85_1 = string.format("%s%s=%s;", var_85_1, iter_87_0, iter_87_1)
			end

			local var_87_1 = ccui.Layout:create():size(500, 60):anchorPoint(cc.p(0, 0.5))
			local var_87_2 = ccui.Text:create(string.format("%s=%s;", iter_87_0, iter_87_1), "font/youmi.ttf", 35):anchorPoint(cc.p(0, 0.5)):addTo(var_87_1):x(0):y(0)
			local var_87_3 = arg_85_0.prefab:get("del"):clone():addTo(var_87_1):anchorPoint(cc.p(0.5, 0.5)):x(400):y(0):setVisible(true):scale(0.5)

			var_85_3:pushBackCustomItem(var_87_1)
			var_87_3:addClickEventListener(function()
				var_85_1 = string.gsub(var_85_1, string.format("%s=%s;", iter_87_0, iter_87_1), "")

				var_85_4()
				var_85_5()
			end)
		end
	end

	var_0_8.addBtnListToView(var_85_0, {
		"btnClose|关闭",
		"btnAdd|添加数据"
	}, cc.p(arg_85_0.stage:width() / 2, 100), var_0_8.CustomBtnType.Center)
	var_85_0.btnAdd:addTouchEventListener(function(arg_89_0, arg_89_1)
		if arg_89_1 == ccui.TouchEventType.ended then
			local var_89_0 = var_85_0.editBox[1]:getText()

			var_85_0.editBox[1]:setText("")

			local var_89_1 = string.split(var_89_0, "=")

			if var_89_1[1] and var_89_1[2] then
				var_85_1 = var_85_1 .. var_89_0 .. ";"
			end

			var_85_4()
			var_85_5()
		end
	end)
	var_0_8.addInputControl(var_85_0, cc.p(arg_85_0.stage:width() / 2, 200), cc.EDITBOX_INPUT_MODE_ANY, "skillId=skillLevel", 1)
	var_85_5()
end

function var_0_26.showRecordView(arg_90_0)
	arg_90_0:onBtnLoadRecord(nil, nil, {
		listView = arg_90_0.recordView
	})
end

function var_0_26.getFightRoleData(arg_91_0)
	local function var_91_0(arg_92_0, arg_92_1)
		return arg_92_0 and arg_92_0 * arg_92_1 or arg_92_1
	end

	local function var_91_1(arg_93_0, arg_93_1)
		arg_93_0 = arg_93_0 or 0

		return arg_93_0 + arg_93_1
	end

	local function var_91_2(arg_94_0, arg_94_1)
		if arg_91_0.btnRecordData.attrAdd then
			if arg_94_1 >= 1 and arg_94_1 <= 3 or arg_94_1 >= 7 and arg_94_1 <= 9 then
				arg_94_0.hp = var_91_0(arg_94_0.hp, 1.1)
				arg_94_0.damageSub = var_91_1(arg_94_0.damageSub, 1000)
			else
				arg_94_0.damageAdd = var_91_1(arg_94_0.damageAdd, 1000)
				arg_94_0.specialDamage = var_91_0(arg_94_0.specialDamage, 1.1)
				arg_94_0.damage = var_91_0(arg_94_0.damage, 1.1)
			end
		end

		local var_94_0

		if arg_94_1 >= 1 and arg_94_1 <= 6 and arg_91_0.leftAttrAdd ~= 1 then
			var_94_0 = arg_91_0.leftAttrAdd
		elseif arg_94_1 >= 7 and arg_94_1 <= 12 and arg_91_0.rightAttrAdd ~= 1 then
			var_94_0 = arg_91_0.rightAttrAdd
		end

		if var_94_0 then
			arg_94_0.hp = var_91_0(arg_94_0.hp, var_94_0)
			arg_94_0.damage = var_91_0(arg_94_0.damage, var_94_0)
			arg_94_0.specialDamage = var_91_0(arg_94_0.specialDamage, var_94_0)
			arg_94_0.defence = var_91_0(arg_94_0.defence, var_94_0)
			arg_94_0.specialDefence = var_91_0(arg_94_0.specialDefence, var_94_0)
		end

		return arg_94_0
	end

	local var_91_3, var_91_4 = arg_91_0.gate:getFightRoleData()

	for iter_91_0, iter_91_1 in ipairs(var_91_3) do
		for iter_91_2, iter_91_3 in pairs(iter_91_1) do
			iter_91_1[iter_91_2] = var_91_2(iter_91_3, iter_91_2)
		end
	end

	return var_91_3, var_91_4
end

function var_0_26.saveInitData(arg_95_0)
	local var_95_0 = {
		_scene = {},
		_resources = {},
		_fightType = arg_95_0.fightType,
		_debug = tjdebug.isenable(),
		_btnRecordData = arg_95_0.btnRecordData,
		_gameEnvData = arg_95_0.gameEnvData
	}

	for iter_95_0, iter_95_1 in pairs(arg_95_0.resources) do
		var_95_0._resources[iter_95_0] = {
			roleId = iter_95_1.roleId,
			extraData = iter_95_1:getRoleData()
		}
	end

	for iter_95_2, iter_95_3 in pairs(arg_95_0.gate.scene) do
		local var_95_1 = iter_95_3:getRoleData()

		if var_95_1 then
			var_95_0._scene[iter_95_2] = {
				index = iter_95_3.index,
				_prefab = {
					roleId = var_95_1.roleId,
					data = var_95_1,
					getRoleData = function(arg_96_0)
						return arg_96_0.data
					end
				}
			}
		end
	end

	return var_95_0
end

local function var_0_28()
	if gGameModel.role.__idlers == nil then
		gGameModel.role:init({
			_db = {
				yy_endtime = 0,
				level_exp = 1,
				name = "test",
				level = 99,
				sum_exp = 1,
				trainer_level = 1,
				id = "1111111",
				vip_level = 15,
				yy_delta = {},
				yyhuodongs = {},
				gate_star = {},
				logos = {},
				pokedex = {},
				figures = {},
				skins = {},
				trainer_skills = {},
				gate_star = {
					[10102] = {
						star = 3
					},
					[10105] = {
						star = 3
					}
				},
				top_cards = {}
			}
		})
	end

	if gGameModel.capture.__idlers == nil then
		gGameModel.capture:init({
			_db = {
				limit_sprites = {}
			}
		})
	end

	if gGameModel.random_tower.__idlers == nil then
		gGameModel.random_tower:init({
			_db = {
				buffs = {},
				skill_used = {}
			}
		})
	end

	gGameModel.hunting = require("app.models.hunting").new(self)

	if gGameModel.hunting.__idlers == nil then
		gGameModel.hunting:init({
			_db = {
				hunting_route = {
					{
						buffs = {}
					},
					{
						buffs = {}
					}
				}
			}
		})
	end
end

function var_0_26.parseBattle(arg_98_0, arg_98_1, arg_98_2)
	local var_98_0

	if arg_98_1 == "craft" then
		arg_98_0:changeFightType(var_0_17.Craft)

		var_98_0 = require("app.models.craft_battle").new(gGameModel):init(arg_98_2)
	elseif arg_98_1 == "arena" then
		arg_98_0:changeFightType(var_0_17.Normal)

		var_98_0 = require("app.models.arena_battle").new(gGameModel):init(arg_98_2)
	elseif arg_98_1 == "gate" then
		arg_98_0:changeFightType(var_0_17.Normal)

		var_98_0 = require("app.models.battle").new(gGameModel):init(arg_98_2)
		var_98_0.result = "fail"
	elseif arg_98_1 == "union_fight" then
		arg_98_0:changeFightType(var_0_17.Normal)

		var_98_0 = require("app.models.union_fight_battle").new(gGameModel):init(arg_98_2)
	elseif arg_98_1 == "cross_craft" or arg_98_1 == "crosscraft" then
		arg_98_0:changeFightType(var_0_17.Craft)

		var_98_0 = require("app.models.cross_craft_battle").new(gGameModel):init(arg_98_2)
	elseif arg_98_1 == "cross_arena" or arg_98_1 == "crossarena" then
		arg_98_0:changeFightType(var_0_17.CrossArena)

		var_98_0 = require("app.models.cross_arena_battle").new(gGameModel):init(arg_98_2)
	elseif arg_98_1 == "cross_mine" or arg_98_1 == "crossmine" then
		arg_98_0:changeFightType(var_0_17.CrossMine)

		var_98_0 = require("app.models.cross_mine_battle").new(gGameModel):init(arg_98_2)
	else
		error(arg_98_1 .. " not defined")
	end

	var_0_28()

	local var_98_1 = var_98_0:getData()

	if var_98_1.preData and var_98_1.preData.cardsInfo then
		var_98_1.preData.cardsInfo = {}
	end

	return var_98_1
end

function var_0_26.runGameLogicByRoleOut(arg_99_0, arg_99_1, arg_99_2, arg_99_3)
	local var_99_0 = 0
	local var_99_1 = 0

	local function var_99_2(...)
		print(...)
	end

	local var_99_3

	arg_99_0.gameEnvData.roleOut = arg_99_1

	local var_99_4 = ""
	local var_99_5 = ""

	if arg_99_0.fightType == var_0_17.CrossArena then
		var_99_4 = var_0_16(var_99_4, arg_99_1, 2)
	elseif arg_99_0.fightType == var_0_17.CrossMine then
		var_99_4 = var_0_16(var_99_4, arg_99_1, 3)
	else
		for iter_99_0 = 1, 12 do
			if iter_99_0 == 7 then
				var_99_4 = var_99_4 .. "  vs  "
				var_99_5 = var_99_5 .. "  vs  "
			end

			if arg_99_1[iter_99_0] then
				if arg_99_0.fightType == var_0_17.BraveChallenge then
					var_99_3 = var_99_3 or arg_99_1[iter_99_0].key
				end

				var_99_4 = string.format("%s %s(%d)", var_99_4, csv.unit[arg_99_1[iter_99_0].roleId].name, arg_99_1[iter_99_0].roleId)
				var_99_5 = string.format("%s %s", var_99_5, arg_99_1[iter_99_0].ex_skills and arg_99_1[iter_99_0].ex_skills[1])
			end
		end
	end

	if var_99_3 then
		print(string.format("\n\n\n\n\n当前正在进行的: csv brave_challenge/monster ID: %d", var_99_3))
		print(var_99_4)
		print(var_99_5)
	end

	for iter_99_1 = 1, arg_99_2 do
		arg_99_0.gameEnvData.closeRandFix = var_0_0.closeRandFix

		local var_99_6

		local function var_99_7()
			return battleEntrance.battleRecord(arg_99_0.gameEnvData, {}, {
				fromRecordFile = true
			}):run()
		end

		if var_99_3 then
			local var_99_8, var_99_9 = xpcall(var_99_7, __G__TRACKBACK__)
			local var_99_10 = var_99_9

			if not var_99_8 then
				print("xpcall game main error", var_99_8, var_99_9)

				local var_99_11 = string.format("%s_%s.record", "braveChallenge", os.date("%y%m%d-%H%M%S"))
				local var_99_12 = io.open(var_99_11, "wb")
				local var_99_13 = var_0_4(arg_99_0.gameEnvData)

				var_99_12:write(var_99_13)
				var_99_12:close()
			end
		end

		local var_99_14 = var_99_7()

		if var_99_14.result == "win" then
			var_99_0 = var_99_0 + 1
		elseif var_99_14.result == "fail" then
			var_99_1 = var_99_1 + 1
		end

		if arg_99_3 then
			arg_99_3({
				time = iter_99_1,
				result = var_99_14.result,
				win = var_99_0,
				lose = var_99_1,
				seed = arg_99_0.gameEnvData.randSeed
			})
		end

		var_99_2(string.format("[INFO] RunTime: (%d/%d), Seed: %d", iter_99_1, arg_99_2, arg_99_0.gameEnvData.randSeed))

		arg_99_0.gameEnvData.randSeed = math.random(1, 100000)

		var_99_2(string.format("[INFO] 当前胜局比:  %d vs %d", var_99_0, var_99_1), var_99_4)
		table.insert(var_0_0.allHistoryBattleInfo, var_0_0.historyBattleInfo[1])
	end

	local var_99_15 = "draw"

	if var_99_1 < var_99_0 then
		var_99_15 = "win"
	elseif var_99_0 < var_99_1 then
		var_99_15 = "fail"
	end

	if var_0_0.historyBattleInfo[1] then
		for iter_99_2, iter_99_3 in pairs(var_0_0.historyBattleInfo[1]) do
			if iter_99_2 > 6 then
				if var_99_15 == "win" then
					iter_99_3.result = "fail"
				elseif var_99_15 == "fail" then
					iter_99_3.result = "win"
				else
					iter_99_3.result = var_99_15
				end
			else
				iter_99_3.result = var_99_15
			end
		end
	end

	table.insert(arg_99_0.battleResultInfo, "[INFO]" .. var_99_4)
	table.insert(arg_99_0.battleResultInfo, string.format("[INFO] 总战斗测试次数: %d (%d vs %d)    胜率: %d%s", arg_99_2, var_99_0, var_99_1, math.floor(100 * var_99_0 / arg_99_2), "%"))
end

function var_0_26.runGameLogicByRoleOutLessTime(arg_102_0, arg_102_1, arg_102_2, arg_102_3)
	local function var_102_0(...)
		print(...)
	end

	arg_102_0.gameEnvData.roleOut = arg_102_1

	local var_102_1 = ""

	if arg_102_0.fightType == var_0_17.CrossArena then
		var_102_1 = var_0_16(var_102_1, arg_102_1, 2)
	elseif arg_102_0.fightType == var_0_17.CrossMine then
		var_102_1 = var_0_16(var_102_1, arg_102_1, 3)
	else
		for iter_102_0 = 1, 12 do
			if iter_102_0 == 7 then
				var_102_1 = var_102_1 .. "\tvs\t"
			end

			if arg_102_1[iter_102_0] then
				var_102_1 = string.format("%s %s(%d)", var_102_1, csv.unit[arg_102_1[iter_102_0].roleId].name, iter_102_0)
			end
		end
	end

	for iter_102_1 = 1, arg_102_2 do
		var_102_0(string.format("[INFO] RunTime: (%d/%d), Seed: %d", iter_102_1, arg_102_2, arg_102_0.gameEnvData.randSeed))

		arg_102_0.gameEnvData.closeRandFix = var_0_0.closeRandFix

		battleEntrance.battleRecord(arg_102_0.gameEnvData, {}, {
			fromRecordFile = true
		}):timeLimit(5):run()

		arg_102_0.gameEnvData.randSeed = math.random(1, 100000)

		table.insert(var_0_0.allHistoryBattleInfo, var_0_0.historyBattleInfo[1])
	end

	var_102_0(var_102_1)
end

function var_0_26.createTestSceneData(arg_104_0)
	var_0_28()

	arg_104_0.gameEnvData = arg_104_0.gameEnvData or {
		roleLevel = 1,
		gateFirst = true,
		moduleType = 1,
		sceneID = var_0_0.TestSceneID,
		randSeed = math.random(1, 1000000),
		talents = {
			{},
			{}
		},
		fightgoVal = {
			0,
			0
		},
		gateType = game.GATE_TYPE.test
	}

	if arg_104_0.fightType == var_0_17.CrossMine and not arg_104_0.gameEnvData.role_key then
		arg_104_0.gameEnvData.role_key = {
			"cn.dev.1"
		}
		arg_104_0.gameEnvData.defence_role_key = {
			"cn.dev.1"
		}
	end
end

function var_0_26.monitorBattleInfo(arg_105_0)
	return
end

function var_0_26.updateMultiForceAttrView(arg_106_0, arg_106_1, arg_106_2)
	arg_106_2:removeAllChildren()

	local var_106_0 = {}
	local var_106_1 = {}

	if arg_106_1.unitInfo then
		local var_106_2 = arg_106_0.attrItem:clone():get("head"):text(arg_106_1.unitInfo.name)
	end

	for iter_106_0, iter_106_1 in pairs(arg_106_1.attrInfo) do
		local var_106_3 = iter_106_0
		local var_106_4 = arg_106_0.attrItem:clone()
		local var_106_5 = var_106_4:get("head"):text(iter_106_0 .. ": ")

		var_106_4:get("edit"):setPlaceHolder(iter_106_1):addEventListener(function(arg_107_0, arg_107_1)
			if arg_107_1 == 2 or arg_107_1 == 3 then
				local var_107_0, var_107_1 = string.gsub(arg_107_0:text(), "[^%d]", "")

				if var_107_1 > 0 then
					arg_107_0:text(var_107_0)

					return
				end

				var_107_0 = var_107_0 == "" and 1 or tonumber(var_107_0)

				local var_107_2 = math.max(var_107_0, 0)

				print("[upd Attr]attr value ", var_106_3, var_107_2)

				attrInfo[var_106_3] = var_107_2
			end
		end)
		var_106_4:setScale(1.5)
		var_106_4:get("edit"):text(iter_106_1)
		arg_106_2:pushBackCustomItem(var_106_4)
		var_106_4:get("edit"):x(var_106_5:width() + var_106_5:x() + 10)
	end
end

function var_0_26.onForceTest(arg_108_0, arg_108_1, arg_108_2)
	local var_108_0 = {}

	for iter_108_0, iter_108_1 in ipairs(arg_108_1) do
		for iter_108_2, iter_108_3 in ipairs(arg_108_2) do
			local var_108_1 = {}

			for iter_108_4, iter_108_5 in ipairs(iter_108_1) do
				table.insert(var_108_1, iter_108_5)
			end

			for iter_108_6, iter_108_7 in ipairs(iter_108_3) do
				table.insert(var_108_1, iter_108_7)
			end

			table.insert(var_108_0, var_108_1)
		end
	end

	local var_108_2 = 0
	local var_108_3 = 0
	local var_108_4 = socket.gettime()
	local var_108_5 = 1

	while true do
		if var_108_5 > #var_108_0 then
			break
		end

		if socket.gettime() - var_108_4 >= 0.2 then
			var_0_9.requestFight(arg_108_0, var_108_0[var_108_5], var_108_5, function(arg_109_0, arg_109_1, arg_109_2, arg_109_3)
				if arg_109_0.ret then
					local var_109_0 = arg_109_2

					print("----------------------------------------")
					print("第" .. tostring(arg_109_3) .. "场")

					for iter_109_0, iter_109_1 in ipairs(var_109_0) do
						if iter_109_0 == 7 then
							print("vs")
						end

						print(var_0_11[iter_109_1.card_id].name .. " ")
					end

					print("\n")
					print("结果:" .. arg_109_1.result .. "\n")

					if arg_109_1.result == "win" then
						var_108_2 = var_108_2 + 1
					elseif arg_109_1.result == "fail" then
						var_108_3 = var_108_3 + 1
					end
				else
					print("----------------------------------------")
					print("第" .. tostring(arg_109_3) .. "场")
					print("结果失败")
				end

				print("\n")
				print("总场次:" .. tostring(var_108_2 + var_108_3) .. " 左胜:" .. tostring(var_108_2) .. " 右胜:" .. tostring(var_108_3))
			end)

			var_108_5 = var_108_5 + 1
			var_108_4 = socket.gettime()
		end
	end
end

function var_0_26.getZuheForce(arg_110_0, arg_110_1, arg_110_2)
	local function var_110_0(arg_111_0, arg_111_1)
		for iter_111_0, iter_111_1 in ipairs(arg_111_0) do
			local var_111_0 = true

			for iter_111_2 = 1, 3 do
				if iter_111_1[iter_111_2].id ~= arg_111_1[iter_111_2].id then
					var_111_0 = false
				end
			end

			if var_111_0 then
				return true
			end
		end

		return false
	end

	local function var_110_1(arg_112_0, arg_112_1)
		if #arg_112_1 == 3 and not var_110_0(arg_112_0, arg_112_1) then
			table.insert(arg_112_0, arg_112_1)

			return
		end

		for iter_112_0 = 1, #arg_112_1 do
			local var_112_0 = clone(arg_112_1)

			table.remove(var_112_0, iter_112_0)
			var_110_1(arg_112_0, var_112_0)
		end
	end

	local var_110_2 = {}

	var_110_1(var_110_2, arg_110_1)

	local var_110_3 = {}

	var_110_1(var_110_3, arg_110_2)

	local var_110_4 = {}

	for iter_110_0, iter_110_1 in ipairs(var_110_2) do
		for iter_110_2, iter_110_3 in ipairs(var_110_3) do
			local var_110_5 = {}

			for iter_110_4, iter_110_5 in ipairs(iter_110_1) do
				table.insert(var_110_5, iter_110_5)
			end

			for iter_110_6, iter_110_7 in ipairs(iter_110_3) do
				table.insert(var_110_5, iter_110_7)
			end

			table.insert(var_110_4, var_110_5)
		end
	end

	return var_110_4
end

function var_0_26.addForcePanel(arg_113_0, arg_113_1, arg_113_2, arg_113_3, arg_113_4)
	arg_113_0.chooseAttr = 1

	for iter_113_0, iter_113_1 in ipairs(arg_113_2) do
		local var_113_0 = {
			roleOut = {}
		}
		local var_113_1 = arg_113_0.forcePanel:clone()
		local var_113_2 = var_113_1:getChildByName("showPanel")

		for iter_113_2 = 1, 6 do
			local var_113_3 = {}
			local var_113_4 = iter_113_1[iter_113_2].unitID
			local var_113_5 = var_0_10[var_113_4]
			local var_113_6 = arg_113_0.prefab:clone()

			var_113_6:get("icon"):texture(var_113_5.iconSimple)
			var_113_6:setScale(0.6)

			var_113_6.id = var_113_4
			var_113_6.name = var_113_5.name
			var_113_6.index = var_113_2:getChildrenCount() + 1

			local var_113_7 = cc.p(10, 5)
			local var_113_8 = 3
			local var_113_9 = cc.p(var_113_6:size().width / 2, var_113_6:size().height / 2 - var_113_7.y * 3)

			arg_113_0:addItemToScrollView(var_113_2, var_113_6, var_113_7, var_113_9, var_113_8)

			var_113_3.unitID = var_113_4
			var_113_3.unitInfo = var_113_5
			var_113_3.attrInfo = {
				star = iter_113_1[iter_113_2].star
			}

			var_113_6:addClickEventListener(function()
				arg_113_0:updateMultiForceAttrView(var_113_3, arg_113_1.attrView)
			end)
			table.insert(var_113_0.roleOut, var_113_3)
		end

		local var_113_10 = cc.p(20, 10)
		local var_113_11 = 3
		local var_113_12 = cc.p(var_113_1:size().width / 2 + var_113_10.x, var_113_1:size().height / 2 + var_113_10.y)

		arg_113_0:addItemToScrollView(arg_113_1.scrollForceView, var_113_1, var_113_10, var_113_12, var_113_11)

		var_113_1.index = arg_113_1.scrollForceView:getChildrenCount() + 1
		var_113_0.index = arg_113_1.scrollForceView:getChildrenCount() + 1
		var_113_0.attrInfo = {
			chooseAttr = arg_113_0.chooseAttr
		}
		var_113_0.panel = var_113_1
		var_113_0.selected = true

		var_113_1:addClickEventListener(function()
			arg_113_0:updateMultiForceAttrView(var_113_0, arg_113_1.attrView)
		end)
		var_113_1:get("forceText"):setString(arg_113_3 and "左" or "右")
		var_113_2:addClickEventListener(function()
			arg_113_0:updateMultiForceAttrView(var_113_0, arg_113_1.attrView)
		end)

		local var_113_13 = var_113_1:get("checkBox")

		var_113_13:setSelectedState(var_113_0.selected)
		var_113_13:addEventListenerCheckBox(function()
			var_113_0.selected = not var_113_0.selected
		end)
		table.insert(arg_113_3 and arg_113_0.leftForceInfo or arg_113_0.rightForceInfo, var_113_0)
	end
end

local var_0_29 = {
	"leftFrontUnitScrollView",
	"leftBackUnitScrollView",
	"rightFrontUnitScrollView",
	"rightBackUnitScrollView"
}
local var_0_30 = {
	"left_front",
	"left_back",
	"right_front",
	"right_back"
}

function var_0_26.addUnitPanel(arg_118_0, arg_118_1, arg_118_2, arg_118_3)
	for iter_118_0, iter_118_1 in ipairs(arg_118_2) do
		local var_118_0 = iter_118_1.cardID
		local var_118_1 = var_0_10[var_0_11[var_118_0].unitID]

		iter_118_1.unitInfo = var_118_1

		local var_118_2 = arg_118_0.prefab:clone()

		var_118_2:get("icon"):texture(var_118_1.iconSimple)
		var_118_2:setScale(0.6)

		var_118_2.index = arg_118_1[var_0_29[arg_118_3]]:getChildrenCount() + 1

		local var_118_3 = cc.p(8, 4)
		local var_118_4 = 5
		local var_118_5 = cc.p(var_118_2:size().width / 2, var_118_2:size().height / 2)

		arg_118_0:addItemToScrollView(arg_118_1[var_0_29[arg_118_3]], var_118_2, var_118_3, var_118_5, var_118_4)
		var_118_2:addClickEventListener(function()
			arg_118_0:updateUnitAttr(arg_118_3, iter_118_1, arg_118_1.attrView, iter_118_0)
		end)
	end
end

function var_0_26.updateUnitAttr(arg_120_0, arg_120_1, arg_120_2, arg_120_3, arg_120_4)
	arg_120_3:removeAllChildren()

	local var_120_0 = {}
	local var_120_1 = {}
	local var_120_2 = arg_120_0.attrItem:clone():get("head"):text(arg_120_2.unitInfo.name)
	local var_120_3 = {
		advance = true,
		star = true,
		level = true
	}

	for iter_120_0, iter_120_1 in pairs(arg_120_2) do
		if var_120_3[iter_120_0] then
			local var_120_4 = iter_120_0
			local var_120_5 = arg_120_0.attrItem:clone()
			local var_120_6 = var_120_5:get("head"):text(iter_120_0 .. ": ")

			var_120_5:get("edit"):setPlaceHolder(iter_120_1):addEventListener(function(arg_121_0, arg_121_1)
				if arg_121_1 == 2 or arg_121_1 == 3 then
					local var_121_0, var_121_1 = string.gsub(arg_121_0:text(), "[^%d]", "")

					if var_121_1 > 0 then
						arg_121_0:text(var_121_0)

						return
					end

					var_121_0 = var_121_0 == "" and 1 or tonumber(var_121_0)

					local var_121_2 = math.max(var_121_0, 0)

					print("[upd Attr]attr value ", var_120_4, var_121_2)

					arg_120_2[iter_120_0] = var_121_2

					var_0_9.requestCardData(arg_120_0, arg_120_2, function(arg_122_0, arg_122_1)
						arg_120_0.dataTb[var_0_30[arg_120_1] .. "_tb"][arg_120_4] = arg_122_1
					end)
				end
			end)
			var_120_5:setScale(1.5)
			var_120_5:get("edit"):text(iter_120_1)
			arg_120_3:pushBackCustomItem(var_120_5)
			var_120_5:get("edit"):x(var_120_6:width() + var_120_6:x() + 10)
		end
	end
end

return var_0_26
