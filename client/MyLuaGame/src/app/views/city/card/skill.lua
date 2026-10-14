local function var_0_0(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = 0

	for iter_1_0 = 1, arg_1_2 do
		if csv.base_attribute.skill_level[arg_1_0 + iter_1_0 - 1] then
			var_1_0 = var_1_0 + csv.base_attribute.skill_level[arg_1_0 + iter_1_0 - 1]["gold" .. arg_1_1]
		end
	end

	return var_1_0
end

local var_0_1 = class("CardSkillView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "card_skill.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	["panel.textNum"] = "skillNum",
	["panel.textNote"] = "textNote",
	["panel.fastUpgradePanel.btnPanel"] = "btnFastUpgrade",
	["panel.btnAdd"] = {
		varname = "addBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSkillAddClick")
			}
		}
	},
	["panel.textFlag"] = {
		varname = "skillMax",
		binds = {
			event = "text",
			idler = bindHelper.self("skillPointState")
		}
	},
	["panel.fastUpgradePanel"] = {
		varname = "fastUpgradePanel",
		binds = {
			event = "click",
			method = bindHelper.self("onFastUpgradeClick")
		}
	},
	["panel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("skillData"),
				item = bindHelper.self("item"),
				cardLv = bindHelper.self("cardLv"),
				star = bindHelper.self("star"),
				cardId = bindHelper.self("cardId"),
				advance = bindHelper.self("advance"),
				zawakeSkills = bindHelper.self("zawakeSkills"),
				canFastUpgrade = bindHelper.self("canFastUpgrade"),
				itemAction = {
					isAction = true
				},
				dataOrderCmp = function(arg_2_0, arg_2_1)
					if arg_2_0.skillPassive ~= arg_2_1.skillPassive then
						return arg_2_0.skillPassive < arg_2_1.skillPassive
					end

					return arg_2_0.skillId < arg_2_1.skillId
				end,
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					arg_3_1:name("item" .. arg_3_0:getIdx(arg_3_2))

					local var_3_0 = csv.skill[arg_3_3.skillId]
					local var_3_1 = arg_3_0.cardLv:read()
					local var_3_2 = arg_3_1:multiget("textLvNum", "textCost", "textName", "imgType", "btnAdd", "imgIcon", "imgBG", "textFastUpgradeNum")

					var_3_2.textLvNum:text(arg_3_3.skillLevel)

					local var_3_3 = var_0_0(arg_3_3.skillLevel, var_3_0.costID, arg_3_3.fastUpgradeNum)
					local var_3_4 = var_3_3 <= arg_3_3.clientGold and ui.NEWCOLORS.WHITE or ui.NEWCOLORS.REDLIGHT

					text.addEffect(var_3_2.textCost, {
						color = var_3_4
					})
					var_3_2.textCost:text(var_3_3)
					uiEasy.setSkillInfoToItems({
						name = var_3_2.textName,
						icon = var_3_2.imgIcon,
						type1 = var_3_2.imgType
					}, arg_3_3.skillId)
					adapt.setTextScaleWithWidth(var_3_2.textName, nil, 300)
					cache.setShader(var_3_2.btnAdd, false, var_3_1 >= arg_3_3.skillLevel + arg_3_3.fastUpgradeNum and "normal" or "hsl_gray")
					var_3_2.btnAdd:onTouch(functools.partial(arg_3_0.clickCell, arg_3_1, arg_3_2, arg_3_3))
					bind.touch(arg_3_0, arg_3_1, {
						methods = {
							ended = functools.partial(arg_3_0.clickCellTip, arg_3_2, arg_3_3)
						}
					})

					local var_3_5 = true
					local var_3_6 = ""
					local var_3_7 = "s%"

					if var_3_0.activeType == 1 then
						var_3_5 = arg_3_0.star:read() >= var_3_0.activeCondition
						var_3_7 = gLanguageCsv.potentialIncreasedStarsUnlocked
						var_3_6 = var_3_0.activeCondition
					elseif var_3_0.activeType == 2 then
						var_3_5 = arg_3_0.advance:read() >= var_3_0.activeCondition
						var_3_7 = gLanguageCsv.skillBreakAdvanceUnlocked
						var_3_6 = uiEasy.setIconName("card", arg_3_0.cardId:read(), {
							space = true,
							node = arg_3_1:get("textTip"),
							name = ui.QUALITY_COLOR_TEXT,
							advance = var_3_0.activeCondition
						})
						var_3_6 = ui.QUALITYCOLOR[dataEasy.getQuality(var_3_0.activeCondition)] .. gLanguageCsv.symbolSquareBracketLeft .. var_3_6 .. gLanguageCsv.symbolSquareBracketRight
					end

					var_3_2.textFastUpgradeNum:text(string.format(gLanguageCsv.upLevelNumber, arg_3_3.fastUpgradeNum)):visible(arg_3_0.canFastUpgrade:read() and var_3_5)
					arg_3_1:removeChildByName("activeCondition")
					rich.createWithWidth(string.format(var_3_7, var_3_6), 40, nil, 800):anchorPoint(0, 1):xy(205, 95):visible(not var_3_5):addTo(arg_3_1, 2, "activeCondition")
					arg_3_1:get("imgMask"):visible(not var_3_5)
					arg_3_1:get("imgCostIcon"):visible(var_3_5)
					arg_3_1:get("textCost"):visible(var_3_5)
					arg_3_1:get("btnAdd"):visible(var_3_5)
					var_3_2.imgBG:z(0)
					arg_3_1:removeChildByName("zawakeBg")
					var_3_2.imgIcon:removeChildByName("zawakeUp")

					if dataEasy.isZawakeSkill(arg_3_3.skillId, arg_3_0.zawakeSkills:read()) then
						ccui.ImageView:create("city/zawake/panel_z1.png"):alignCenter(arg_3_1:size()):addTo(arg_3_1, 1, "zawakeBg")
						ccui.ImageView:create("city/drawcard/draw/txt_up.png"):scale(1.2):align(cc.p(1, 1), 200, 190):addTo(var_3_2.imgIcon, 1, "zawakeUp")

						local var_3_8 = csv.skill[arg_3_3.skillId].zawakeEffect[1]

						var_3_2.textName:text(csv.skill[var_3_8].skillName .. var_3_2.textName:text())
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemAddClick"),
				clickCellTip = bindHelper.self("onItemTipClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_4_0, arg_4_1)
	arg_4_0.selectDbId = arg_4_1()

	arg_4_0:initModel()
	arg_4_0:enableSchedule()

	arg_4_0.skillData = idlers.new()
	arg_4_0.skillPointState = idler.new("")
	arg_4_0.skillList = {}
	arg_4_0.tmpSkillPoint = idler.new(0)
	arg_4_0.refreshPoint = idler.new(true)
	arg_4_0.serverSkillPoint = idler.new(0)

	local var_4_0 = userDefault.getForeverLocalKey("skillFastUpgrade", false)

	arg_4_0.btnFastUpgrade:get("checkBox"):setSelectedState(var_4_0)

	arg_4_0.canFastUpgrade = idler.new(false)

	dataEasy.getListenUnlock(gUnlockCsv.fastUpgrade, function(arg_5_0)
		arg_4_0.canFastUpgrade:set(var_4_0 and arg_5_0)
		arg_4_0.fastUpgradePanel:visible(arg_5_0)
	end)
	idlereasy.any({
		arg_4_0.cardId,
		arg_4_0.skinId,
		arg_4_0.zawakeSkills
	}, function(arg_6_0, arg_6_1, arg_6_2)
		local var_6_0 = {}
		local var_6_1 = dataEasy.getCardSkillList(arg_6_1, arg_6_2)

		if not var_6_1 then
			return
		end

		arg_4_0.skillList = var_6_1

		for iter_6_0, iter_6_1 in csvPairs(arg_4_0.skillList) do
			local var_6_2 = 1

			if csv.skill[iter_6_1].skillType2 == battle.MainSkillType.PassiveSkill then
				var_6_2 = 2
			end

			local var_6_3 = arg_4_0.skills:read()[iter_6_1] or 1

			var_6_0[iter_6_1] = {
				skillId = iter_6_1,
				skillLevel = var_6_3,
				skillPassive = var_6_2,
				clientGold = arg_4_0.gold:read(),
				fastUpgradeNum = arg_4_0:getFastUpgradeNum(var_6_3)
			}
		end

		arg_4_0:unSchedule("skillLvUp")
		arg_4_0.skillData:update(var_6_0)
		arg_4_0.tmpSkillPoint:set(0)
	end)
	idlereasy.any({
		arg_4_0.skills,
		arg_4_0.cardLv
	}, function(arg_7_0, arg_7_1)
		for iter_7_0, iter_7_1 in csvPairs(arg_4_0.skillList) do
			arg_4_0.skillData:at(iter_7_1):modify(function(arg_8_0)
				arg_8_0.skillLevel = arg_7_1[iter_7_1] or 1
				arg_8_0.fastUpgradeNum = arg_4_0:getFastUpgradeNum(arg_8_0.skillLevel)
			end, true)
		end
	end)

	arg_4_0.clientGold = idler.new(0)

	idlereasy.when(arg_4_0.gold, function(arg_9_0, arg_9_1)
		arg_4_0.clientGold:set(arg_9_1)
	end)
	idlereasy.when(arg_4_0.clientGold, function(arg_10_0, arg_10_1)
		for iter_10_0, iter_10_1 in csvPairs(arg_4_0.skillList) do
			arg_4_0.skillData:at(iter_10_1):modify(function(arg_11_0)
				arg_11_0.clientGold = arg_10_1
			end, true)
		end
	end)

	local var_4_1 = 0

	idlereasy.when(arg_4_0.vipLevel, function(arg_12_0, arg_12_1)
		var_4_1 = gVipCsv[arg_12_1].skillPointRecoverTime
	end)

	local var_4_2 = 0

	idlereasy.when(arg_4_0.roleLv, function(arg_13_0, arg_13_1)
		var_4_2 = dataEasy.getSkillPointMax(arg_13_1)
	end)

	local var_4_3

	idlereasy.any({
		arg_4_0.skillPointLast,
		arg_4_0.skillPoint,
		arg_4_0.tmpSkillPoint,
		arg_4_0.refreshPoint
	}, function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
		var_4_3 = math.max(time.getTime() - math.ceil(arg_14_1), 0)

		for iter_14_0 = 0, var_4_2 do
			if arg_14_2 >= var_4_2 then
				var_4_3 = var_4_1

				break
			end

			if var_4_3 >= var_4_1 then
				var_4_3 = var_4_3 - var_4_1
				arg_14_2 = arg_14_2 + 1
			else
				var_4_3 = var_4_1 - var_4_3

				arg_4_0.skillPointState:set("(" .. time.getCutDown(var_4_3).min_sec_clock .. ")")

				break
			end
		end

		arg_4_0.serverSkillPoint:set(arg_14_2 - arg_14_3)
	end)

	arg_4_0.timeStart = idler.new(true)

	idlereasy.when(arg_4_0.timeStart, function(arg_15_0, arg_15_1)
		if arg_15_1 then
			arg_4_0:schedule(function()
				arg_4_0.refreshPoint:set(not arg_4_0.refreshPoint:read())
			end, 1, 0, "CardSkillView")
		else
			arg_4_0:unSchedule("CardSkillView")
			arg_4_0.skillPointState:set("(MAX)")
		end
	end)
	idlereasy.any({
		arg_4_0.serverSkillPoint,
		arg_4_0.canFastUpgrade
	}, function(arg_17_0, arg_17_1)
		local var_17_0 = arg_17_1 < var_4_2

		arg_4_0.timeStart:set(var_17_0)
		arg_4_0.addBtn:visible(false)
		arg_4_0.skillNum:text(arg_17_1)

		if arg_17_1 >= gCommonConfigCsv.skillPointLimitMax then
			arg_4_0.skillPointState:set("(" .. gLanguageCsv.alreadyMax .. ")")
		elseif arg_17_1 >= var_4_2 then
			arg_4_0.skillPointState:set("(MAX)")
		end

		adapt.oneLinePos(arg_4_0.textNote, {
			arg_4_0.skillNum,
			arg_4_0.skillMax
		}, cc.p(20, 0), "left")

		for iter_17_0, iter_17_1 in csvPairs(arg_4_0.skillList) do
			arg_4_0.skillData:at(iter_17_1):modify(function(arg_18_0)
				arg_18_0.fastUpgradeNum = arg_4_0:getFastUpgradeNum(arg_18_0.skillLevel)
			end, true)
		end
	end)
end

function var_0_1.initModel(arg_19_0)
	arg_19_0.items = gGameModel.role:getIdler("items")
	arg_19_0.skillPointLast = gGameModel.role:getIdler("skill_point_last_recover_time")
	arg_19_0.skillPoint = gGameModel.role:getIdler("skill_point")
	arg_19_0.roleLv = gGameModel.role:getIdler("level")
	arg_19_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_19_0.gold = gGameModel.role:getIdler("gold")

	idlereasy.when(arg_19_0.selectDbId, function(arg_20_0, arg_20_1)
		local var_20_0 = gGameModel.cards:find(arg_20_1)

		arg_19_0.cardId = idlereasy.assign(var_20_0:getIdler("card_id"), arg_19_0.cardId)
		arg_19_0.skinId = idlereasy.assign(var_20_0:getIdler("skin_id"), arg_19_0.skinId)
		arg_19_0.cardLv = idlereasy.assign(var_20_0:getIdler("level"), arg_19_0.cardLv)
		arg_19_0.skills = idlereasy.assign(var_20_0:getIdler("skills"), arg_19_0.skills)
		arg_19_0.star = idlereasy.assign(var_20_0:getIdler("star"), arg_19_0.star)
		arg_19_0.advance = idlereasy.assign(var_20_0:getIdler("advance"), arg_19_0.advance)
		arg_19_0.zawakeSkills = idlereasy.assign(var_20_0:getIdler("zawake_skills"), arg_19_0.advance)

		dataEasy.tryCallFunc(arg_19_0.list, "setItemAction", {
			isAction = true
		})
	end)
end

function var_0_1.onFastUpgradeClick(arg_21_0)
	local var_21_0 = userDefault.getForeverLocalKey("skillFastUpgrade", false)

	arg_21_0.btnFastUpgrade:get("checkBox"):setSelectedState(not var_21_0)
	userDefault.setForeverLocalKey("skillFastUpgrade", not var_21_0)
	arg_21_0.canFastUpgrade:set(not var_21_0)
end

function var_0_1.getFastUpgradeNum(arg_22_0, arg_22_1)
	if not arg_22_0.canFastUpgrade:read() then
		return 1
	end

	local var_22_0 = arg_22_0.cardLv:read()

	if var_22_0 <= arg_22_1 then
		return 5
	end

	local var_22_1 = arg_22_0.serverSkillPoint:read()

	if var_22_1 == 0 then
		return 1
	end

	return math.min(var_22_0 - arg_22_1, math.min(var_22_1, 5))
end

function var_0_1.onItemAddClick(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	if arg_23_5.name == "began" then
		arg_23_0.tmpSkillPoint:set(0)

		local var_23_0 = 0.4
		local var_23_1 = 0.6

		arg_23_0.notMoved = true
		arg_23_0.touchBeganPos = clone(arg_23_5)

		arg_23_0:enableSchedule():schedule(function(arg_24_0)
			if var_23_0 <= 0 and not gGameUI:isConnecting() then
				var_23_1 = var_23_1 <= 0.2 and 0.2 or var_23_1 - 0.2
				var_23_0 = var_23_1
				arg_23_4.skillLevel = arg_23_0.skillData:atproxy(arg_23_3).skillLevel
				arg_23_4.fastUpgradeNum = arg_23_0.skillData:atproxy(arg_23_3).fastUpgradeNum

				if arg_23_0:canLevelUp(arg_23_4, false) then
					local var_24_0 = arg_23_4.fastUpgradeNum

					arg_23_0.tmpSkillPoint:modify(function(arg_25_0)
						return true, arg_25_0 + var_24_0
					end)

					local var_24_1 = var_0_0(arg_23_4.skillLevel, csv.skill[arg_23_4.skillId].costID, var_24_0)

					arg_23_0.clientGold:modify(function(arg_26_0)
						return true, arg_26_0 - var_24_1
					end)

					local var_24_2 = arg_23_0.skillData:atproxy(arg_23_3).skillLevel + var_24_0

					arg_23_0.skillData:atproxy(arg_23_3).skillLevel = var_24_2
					arg_23_0.skillData:atproxy(arg_23_3).fastUpgradeNum = arg_23_0:getFastUpgradeNum(var_24_2)

					if arg_23_0.serverSkillPoint:read() + arg_23_0.tmpSkillPoint:read() >= dataEasy.getSkillPointMax(arg_23_0.roleLv:read()) and arg_23_0.serverSkillPoint:read() < dataEasy.getSkillPointMax(arg_23_0.roleLv:read()) then
						local var_24_3 = arg_23_0.tmpSkillPoint:read()

						gGameApp:requestServer("/game/card/skill/level/up", function(arg_27_0)
							arg_23_0.tmpSkillPoint:modify(function(arg_28_0)
								return true, arg_28_0 - var_24_3
							end)
						end, arg_23_0.selectDbId, arg_23_4.skillId, var_24_3)
					end

					for iter_24_0 = 1, var_24_0 do
						arg_23_0:upgradeFloatingWord(arg_23_2, arg_23_4.skillId)
					end

					local var_24_4 = arg_23_2:get("imgIcon"):getContentSize()

					audio.playEffectWithWeekBGM("circle.mp3")
					widget.addAnimationByKey(arg_23_2:get("imgIcon"), "effect/jineng.skel", nil, "effect", 555):xy(var_24_4.width / 2, var_24_4.height / 2):scale(0.5)
				end
			end

			var_23_0 = var_23_0 - arg_24_0
		end, 0.1, 0, "skillLvUp")
	elseif arg_23_5.name == "moved" then
		local var_23_2 = arg_23_5
		local var_23_3 = math.abs(var_23_2.x - arg_23_0.touchBeganPos.x)
		local var_23_4 = math.abs(var_23_2.y - arg_23_0.touchBeganPos.y)

		if var_23_3 >= ui.TOUCH_MOVE_CANCAE_THRESHOLD or var_23_4 >= ui.TOUCH_MOVE_CANCAE_THRESHOLD then
			arg_23_0.notMoved = false

			arg_23_0:unSchedule("skillLvUp")
		end
	elseif arg_23_5.name == "ended" or arg_23_5.name == "cancelled" then
		arg_23_0:unSchedule("skillLvUp")
		arg_23_0:canLevelUp(arg_23_4, true)

		if gGameUI:isConnecting() then
			return
		end

		if arg_23_0.tmpSkillPoint:read() > 0 then
			gGameApp:requestServer("/game/card/skill/level/up", function(arg_29_0)
				arg_23_0.tmpSkillPoint:set(0)
			end, arg_23_0.selectDbId, arg_23_4.skillId, arg_23_0.tmpSkillPoint)
		elseif arg_23_0.notMoved then
			if not arg_23_0:canLevelUp(arg_23_4, false) then
				return
			end

			gGameApp:requestServer("/game/card/skill/level/up", function(arg_30_0)
				arg_23_0.tmpSkillPoint:set(0)
			end, arg_23_0.selectDbId, arg_23_4.skillId, arg_23_4.fastUpgradeNum)

			for iter_23_0 = 1, arg_23_4.fastUpgradeNum do
				arg_23_0:upgradeFloatingWord(arg_23_2, arg_23_4.skillId)
			end

			local var_23_5 = arg_23_2:get("imgIcon"):getContentSize()

			audio.playEffectWithWeekBGM("circle.mp3")
			widget.addAnimationByKey(arg_23_2:get("imgIcon"), "effect/jineng.skel", nil, "effect", 555):xy(var_23_5.width / 2, var_23_5.height / 2):scale(0.5)
		end
	end
end

function var_0_1.canLevelUp(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = var_0_0(arg_31_1.skillLevel, csv.skill[arg_31_1.skillId].costID, arg_31_1.fastUpgradeNum)

	if arg_31_1.skillLevel + arg_31_1.fastUpgradeNum > arg_31_0.cardLv:read() then
		arg_31_0:showTip(gLanguageCsv.spriteLevelNotEnough, arg_31_2)

		return false
	end

	if arg_31_0.serverSkillPoint:read() < arg_31_1.fastUpgradeNum then
		arg_31_0:onSkillAddClick(arg_31_2)

		return false
	end

	if var_31_0 > arg_31_0.clientGold:read() then
		arg_31_0:showTip(gLanguageCsv.skillLevelGoldNotEnough, arg_31_2)

		return false
	end

	return true
end

function var_0_1.showTip(arg_32_0, arg_32_1, arg_32_2)
	if arg_32_2 then
		gGameUI:showTip(arg_32_1)
	end
end

function var_0_1.upgradeFloatingWord(arg_33_0, arg_33_1, arg_33_2)
	arg_33_0.floatingWordData = arg_33_0.floatingWordData or {}

	local var_33_0 = arg_33_0.floatingWordData
	local var_33_1 = string.split(csv.skill[arg_33_2].upLvDesc, "|")

	for iter_33_0, iter_33_1 in pairs(var_33_1) do
		if not var_33_0[arg_33_2] then
			var_33_0[arg_33_2] = {}
		end

		table.insert(var_33_0[arg_33_2], iter_33_1)
	end

	if not arg_33_0.oldselectDbId then
		arg_33_0.oldselectDbId = arg_33_0.selectDbId:read()
	end

	if not arg_33_0.skillId then
		arg_33_0.skillId = arg_33_2
	end

	if arg_33_0.skillId ~= arg_33_2 then
		arg_33_0.skillId = arg_33_2
		arg_33_0.floatingWordIndex = false
	end

	if not arg_33_0.floatingWordIndex then
		arg_33_0.floatingWordIndex = true

		local var_33_2 = 0

		arg_33_0:enableSchedule():schedule(function(arg_34_0)
			if next(var_33_0[arg_33_2]) == nil then
				if not tolua.isnull(arg_33_1) then
					for iter_34_0 = 1, 4 do
						local var_34_0 = arg_33_1:get("num" .. iter_34_0)

						if var_34_0 then
							var_34_0:hide()
						end
					end
				end

				arg_33_0:unSchedule("upgradeFloatingWord" .. arg_33_2)

				arg_33_0.floatingWordIndex = false
			elseif arg_33_0.oldselectDbId ~= arg_33_0.selectDbId:read() then
				arg_33_0.oldselectDbId = arg_33_0.selectDbId:read()

				for iter_34_1, iter_34_2 in pairs(var_33_0) do
					var_33_0[iter_34_1] = {}
				end
			else
				if tolua.isnull(arg_33_1) then
					var_33_0[arg_33_2] = {}

					return
				end

				var_33_2 = var_33_2 < 4 and var_33_2 + 1 or 1

				local var_34_1 = arg_33_1:get("num" .. var_33_2)

				if not var_34_1 then
					var_34_1 = cc.Label:createWithTTF(var_33_0[arg_33_2][1], ui.FONT_PATH, 50):align(cc.p(0, 0.5), 300, 80):addTo(arg_33_1, 4000, "num" .. var_33_2)

					text.addEffect(var_34_1, {
						color = cc.c4b(92, 153, 113, 255)
					})
				end

				var_34_1:text(var_33_0[arg_33_2][1]):xy(300, 80):show():opacity(255)
				transition.executeSequence(var_34_1):moveBy(0.4, 0, 100):fadeOut(0.3):done()
				table.remove(var_33_0[arg_33_2], 1)
			end
		end, 0.2, 0.2, "upgradeFloatingWord" .. arg_33_2)
	end
end

function var_0_1.onSkillAddClick(arg_35_0, arg_35_1)
	if not arg_35_1 then
		return
	end

	gGameUI:stackUI("city.card.skill_buypoint", nil, nil, arg_35_0:createHandler("getBuyInfoCb"))
end

function var_0_1.getBuyInfoCb(arg_36_0)
	if arg_36_0.serverSkillPoint:read() >= dataEasy.getSkillPointMax(arg_36_0.roleLv:read()) then
		gGameUI:showTip(gLanguageCsv.skillPointBuyNoNeed)

		return
	end

	gGameApp:requestServer("/game/role/skill/point/buy", function(arg_37_0)
		gGameUI:showTip(gLanguageCsv.hasBuy)
	end)
end

function var_0_1.onItemTipClick(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	gGameUI:stackUI("common.skill_detail", nil, {
		clickClose = true,
		dispatchNodes = arg_38_1
	}, {
		skillId = arg_38_3.skillId,
		skillLevel = arg_38_3.skillLevel,
		cardId = arg_38_0.cardId:read(),
		star = arg_38_0.star:read(),
		isZawake = dataEasy.isZawakeSkill(arg_38_3.skillId, arg_38_0.zawakeSkills:read())
	})
end

return var_0_1
