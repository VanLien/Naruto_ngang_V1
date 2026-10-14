local var_0_0 = 0.08
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("CardCommonSuccessView", cc.load("mvc").ViewBase)

var_0_2.RESOURCE_FILENAME = "card_common_success.json"
var_0_2.RESOURCE_BINDING = {
	skillIcon = "skillIcon",
	["centerPanel.name1"] = "name1",
	item = "item",
	skillNote = "skillNote",
	["centerPanel.subList"] = "subList",
	["centerPanel.fight2"] = "fight2",
	skillName = "skillName",
	centerPos = "centerPos",
	centerPanel = "centerPanel",
	["centerPanel.cardImg"] = "cardImg",
	["centerPanel.name2"] = "name2",
	["centerPanel.fight1"] = "fight1",
	["centerPanel.fightBg"] = "fightBg",
	bg = {
		binds = {
			event = "click",
			method = bindHelper.self("onClose")
		}
	},
	["centerPanel.card1"] = {
		varname = "card1",
		binds = {
			event = "extend",
			class = "card_icon",
			props = {
				unitId = bindHelper.self("unitIdOld"),
				advance = bindHelper.self("advanceOld"),
				rarity = bindHelper.self("oldRarity"),
				star = bindHelper.self("starOld")
			}
		}
	},
	["centerPanel.card2"] = {
		varname = "card2",
		binds = {
			event = "extend",
			class = "card_icon",
			props = {
				unitId = bindHelper.self("unitId"),
				advance = bindHelper.self("advance"),
				rarity = bindHelper.self("rarity"),
				star = bindHelper.self("starNew")
			}
		}
	},
	["centerPanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 6,
				columnSize = 2,
				data = bindHelper.self("attrDatas"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("note", "txt1", "txt2", "icon", "iconArrow")

					var_1_0.note:setString(arg_1_3.note)
					var_1_0.txt1:setString(math.floor(arg_1_3.txt1))
					var_1_0.txt2:setString(math.floor(arg_1_3.txt2))
					var_1_0.icon:loadTexture(arg_1_3.icon)

					local var_1_1 = arg_1_0:getIdx(arg_1_2).k
					local var_1_2 = var_0_0 * (3 + var_1_1)

					uiEasy.setExecuteSequence({
						var_1_0.icon,
						var_1_0.note
					}, {
						delayTime = var_1_2
					})
					uiEasy.setExecuteSequence(var_1_0.txt1, {
						delayTime = var_1_2 + var_0_0
					})
					uiEasy.setExecuteSequence(var_1_0.iconArrow, {
						delayTime = var_1_2 + var_0_0 * 2
					})
					uiEasy.setExecuteSequence(var_1_0.txt2, {
						delayTime = var_1_2 + var_0_0 * 3
					})
				end,
				onAfterBuild = function(arg_2_0)
					arg_2_0:adaptTouchEnabled()
				end
			}
		}
	}
}

function var_0_2.onCreate(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	audio.playEffectWithWeekBGM("advance_suc.mp3")

	arg_3_0.selectDbId = arg_3_1

	arg_3_0:initModel()

	arg_3_0.cb = arg_3_3.cb
	arg_3_0.attrDatas = idlers.new({})

	if arg_3_3.attrs then
		local var_3_0 = {}

		for iter_3_0, iter_3_1 in ipairs(game.ATTRDEF_SIMPLE_TABLE) do
			local var_3_1 = {
				note = getLanguageAttr(iter_3_1),
				txt1 = math.floor(arg_3_3.attrs[iter_3_1]),
				txt2 = math.floor(arg_3_0.attrs[iter_3_1]),
				icon = ui.ATTR_LOGO[iter_3_1]
			}

			table.insert(var_3_0, var_3_1)
		end

		arg_3_0.attrDatas:update(var_3_0)
	end

	local var_3_2 = arg_3_0.cardId
	local var_3_3 = arg_3_0.advance
	local var_3_4 = arg_3_0.star

	arg_3_0.unitIdOld = arg_3_0.unitId
	arg_3_0.advanceOld = var_3_3
	arg_3_0.starOld = 0
	arg_3_0.starNew = 0
	arg_3_0.rarity = csv.unit[arg_3_0.unitId].rarity
	arg_3_0.oldRarity = arg_3_0.rarity

	local var_3_5 = "xjiesuan_jinhuazi"

	itertools.invoke({
		arg_3_0.skillNote,
		arg_3_0.skillName,
		arg_3_0.skillIcon
	}, "hide")

	if arg_3_3.advanceOld then
		var_3_5 = "xjiesuan_tupozi"

		local var_3_6 = arg_3_3.advanceOld or var_3_3 - 1

		uiEasy.setIconName("card", var_3_2, {
			space = true,
			node = arg_3_0.name1,
			name = csv.cards[var_3_2].name,
			advance = var_3_6
		})
		uiEasy.setIconName("card", var_3_2, {
			space = true,
			node = arg_3_0.name2,
			name = csv.cards[var_3_2].name,
			advance = var_3_3
		})

		arg_3_0.advanceOld = var_3_6
	elseif arg_3_3.starOld then
		var_3_5 = "xjiesuan_tishengzi"

		uiEasy.setIconName("card", var_3_2, {
			space = true,
			node = arg_3_0.name1,
			name = csv.cards[var_3_2].name,
			advance = var_3_3
		})
		uiEasy.setIconName("card", var_3_2, {
			space = true,
			node = arg_3_0.name2,
			name = csv.cards[var_3_2].name,
			advance = var_3_3
		})

		arg_3_0.starOld = var_3_4 - 1
		arg_3_0.starNew = var_3_4

		for iter_3_2, iter_3_3 in pairs(arg_3_0.skills) do
			if not arg_3_3.skills[iter_3_2] then
				itertools.invoke({
					arg_3_0.skillNote,
					arg_3_0.skillName,
					arg_3_0.skillIcon
				}, "show")

				local var_3_7 = csv.skill[iter_3_2]

				arg_3_0.skillName:text(var_3_7.skillName)

				if var_3_7.skillNatureType then
					arg_3_0.skillIcon:texture(ui.SKILL_TEXT_ICON[var_3_7.skillNatureType])
				else
					arg_3_0.skillIcon:texture("city/card/system/skill/icon_skill_text.png")
				end

				arg_3_0.centerPanel:y(arg_3_0.centerPos:y() + 20)
				adapt.oneLinePos(arg_3_0.skillNote, {
					arg_3_0.skillName,
					arg_3_0.skillIcon
				}, cc.p(10, 0), "left")
				uiEasy.setExecuteSequence(arg_3_0.skillNote, {
					delayTime = var_0_0 * 5
				})
				uiEasy.setExecuteSequence(arg_3_0.skillName, {
					delayTime = var_0_0 * 6
				})
				uiEasy.setExecuteSequence(arg_3_0.skillIcon, {
					delayTime = var_0_0 * 7
				})

				break
			end
		end
	elseif arg_3_3.effortAdvance then
		arg_3_0.name1:text(gLanguageCsv.effortAdvance .. dataEasy.getRomanNumeral(arg_3_3.effortAdvance - 1))
		arg_3_0.name2:text(gLanguageCsv.effortAdvance .. dataEasy.getRomanNumeral(arg_3_3.effortAdvance))
		text.addEffect(arg_3_0.name1, {
			color = ui.COLORS.NORMAL.WHITE
		})
		text.addEffect(arg_3_0.name2, {
			color = ui.COLORS.NORMAL.WHITE
		})

		var_3_5 = "xjiesuan_jinshengzi"

		local var_3_8 = csv.cards[var_3_2]
		local var_3_9 = gCardEffortAdvance[var_3_8.effortSeqID][arg_3_3.effortAdvance].attrEffect

		if not string.find(var_3_9, "%%") then
			var_3_9 = var_3_9 .. "%"
		end

		local var_3_10 = string.format(gLanguageCsv.effortAdvanceActiveTip, var_3_9)
		local var_3_11 = rich.createByStr(var_3_10, 40, nil, nil, cc.p(0, 0.5)):anchorPoint(0, 0.5):xy(300, 150):addTo(arg_3_0.centerPanel, 6)

		uiEasy.setExecuteSequence(var_3_11, {
			delayTime = var_0_0 * 5
		})
	else
		uiEasy.setIconName("card", arg_3_3.cardOld, {
			space = true,
			node = arg_3_0.name1,
			name = csv.cards[arg_3_3.cardOld].name
		})
		uiEasy.setIconName("card", var_3_2, {
			space = true,
			node = arg_3_0.name2,
			name = csv.cards[var_3_2].name
		})

		local var_3_12 = csv.cards[arg_3_3.cardOld]
		local var_3_13 = csv.unit[var_3_12.unitID]

		arg_3_0.unitIdOld = var_3_12.unitID
		arg_3_0.oldRarity = var_3_13.rarity
	end

	uiEasy.setTitleEffect(arg_3_0.centerPos, var_3_5, arg_3_3)
	uiEasy.setExecuteSequence(arg_3_0.name1)
	uiEasy.setExecuteSequence(arg_3_0.card1)
	uiEasy.setExecuteSequence(arg_3_0.cardImg, {
		delayTime = var_0_0
	})
	uiEasy.setExecuteSequence(arg_3_0.name2, {
		delayTime = var_0_0 * 2
	})
	uiEasy.setExecuteSequence(arg_3_0.card2, {
		delayTime = var_0_0 * 2
	})
	uiEasy.setExecuteSequence(arg_3_0.fightBg, {
		delayTime = var_0_0 * 3
	})
	uiEasy.setExecuteSequence(arg_3_0.fight1, {
		delayTime = var_0_0 * 4
	})
	uiEasy.setExecuteSequence(arg_3_0.fight2, {
		delayTime = var_0_0 * 5
	})
	arg_3_0.fight1:text(arg_3_2)
	arg_3_0.fight2:text(arg_3_0.fight)
end

function var_0_2.initModel(arg_4_0)
	local var_4_0 = gGameModel.cards:find(arg_4_0.selectDbId)

	arg_4_0.attrs = var_4_0:read("attrs")
	arg_4_0.advance = var_4_0:read("advance")
	arg_4_0.star = var_4_0:read("star")
	arg_4_0.cardId = var_4_0:read("card_id")
	arg_4_0.skinId = var_4_0:read("skin_id")
	arg_4_0.fight = var_4_0:read("fighting_point")
	arg_4_0.skills = var_4_0:read("skills")
	arg_4_0.unitId = dataEasy.getUnitId(arg_4_0.cardId, arg_4_0.skinId)
end

function var_0_2.onClose(arg_5_0)
	arg_5_0:addCallbackOnExit(arg_5_0.cb)
	var_0_1.onClose(arg_5_0)
end

return var_0_2
