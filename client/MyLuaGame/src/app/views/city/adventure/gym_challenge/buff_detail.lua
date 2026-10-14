local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("GymBuffDetail", var_0_0)

var_0_1.RESOURCE_FILENAME = "gym_buf_detail.json"
var_0_1.RESOURCE_BINDING = {
	imgTextBg = "imgTextBg",
	textNote = "textNote",
	imgIcon = "imgIcon",
	textLv = "textLv",
	textNoteLv = "textNoteLv",
	textCost = "textCost",
	textName = "textName",
	imgCost = "imgCost",
	imgLockBg = "imgLockBg",
	textNoteCost = "textNoteCost",
	textDesc = "textDesc",
	lockPanel = "lockPanel",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["bg.title"] = {
		binds = {
			{
				event = "effect",
				data = {
					color = ui.COLORS.NORMAL.BLACK,
					outline = {
						size = 2,
						color = ui.NEWCOLORS.OUTLINE.WHITE
					}
				}
			}
		}
	},
	btnAct = {
		varname = "btnAct",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onActClick")
			}
		}
	},
	btnDetail = {
		varname = "btnDetail",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDetailClick")
			}
		}
	}
}

local function var_0_2(arg_1_0, arg_1_1)
	local var_1_0 = string.split(arg_1_0, "$")
	local var_1_1 = ""

	for iter_1_0, iter_1_1 in pairs(var_1_0) do
		local var_1_2 = iter_1_1

		if string.find(var_1_2, "skilllevel") then
			local var_1_3 = ""

			if var_1_0[iter_1_0 + 1] and string.find(var_1_0[iter_1_0 + 1], "^%%") then
				var_1_3 = "%"
				var_1_0[iter_1_0 + 1] = string.gsub(var_1_0[iter_1_0 + 1], "^%%", "")
			end

			var_1_2 = eval.doFormula(iter_1_1, {
				skilllevel = arg_1_1,
				math = math
			}, arg_1_0) .. var_1_3
		end

		var_1_1 = var_1_1 .. var_1_2
	end

	return var_1_1
end

function var_0_1.onCreate(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	arg_2_0.id = arg_2_1
	arg_2_0.unlocked = arg_2_2
	arg_2_0.lv = 0

	local var_2_0 = csv.gym.talent_buff[arg_2_1]

	arg_2_0.imgIcon:texture(var_2_0.icon)
	arg_2_0.textName:text(var_2_0.name)

	arg_2_0.gymDatas = gGameModel.role:getIdler("gym_datas")

	idlereasy.when(arg_2_0.gymDatas, function(arg_3_0, arg_3_1)
		local var_3_0 = arg_3_1.gym_talent_trees[var_2_0.treeID]
		local var_3_1 = 0

		if var_3_0 then
			var_3_1 = var_3_0.talent[arg_2_0.id] or 0
		end

		arg_2_0.textLv:text(var_3_1 .. "/" .. var_2_0.levelUp)

		if var_2_0.effectType == 1 then
			local var_3_2 = {}

			for iter_3_0 = 1, math.huge do
				if var_2_0["attrType" .. iter_3_0] and var_2_0["attrType" .. iter_3_0] ~= 0 and var_2_0["attrNum" .. iter_3_0] then
					local var_3_3 = 0

					if var_3_1 == 0 then
						var_3_3 = dataEasy.getAttrValueString(var_2_0["attrType" .. iter_3_0], var_2_0["attrNum" .. iter_3_0][1])
					else
						var_3_3 = dataEasy.getAttrValueString(var_2_0["attrType" .. iter_3_0], var_2_0["attrNum" .. iter_3_0][var_3_1])
					end

					table.insert(var_3_2, var_3_3)
				else
					break
				end
			end

			arg_2_0.textDesc:text(string.format(var_2_0.desc, table.unpack(var_3_2)))
		else
			arg_2_0.textDesc:text(var_0_2(var_2_0.desc, var_3_1 or 0))
		end

		adapt.oneLineCenterPos(cc.p(arg_2_0.imgIcon:x(), 607), {
			arg_2_0.textNoteLv,
			arg_2_0.textLv
		})

		if arg_2_0.unlocked == false then
			arg_2_0.btnAct:get("textNote"):text(gLanguageCsv.notActivatedTip)
			uiEasy.setBtnShader(arg_2_0.btnAct, arg_2_0.btnAct:get("textNote"), 2)
			itertools.invoke({
				arg_2_0.textNoteCost,
				arg_2_0.textCost,
				arg_2_0.imgCost,
				arg_2_0.textNoteLv,
				arg_2_0.textLv
			}, "hide")

			local var_3_4 = csv.gym.talent_buff[arg_2_1]
			local var_3_5 = var_3_4.preTalentIDs
			local var_3_6 = var_3_4.preLevel

			arg_2_0.lockPanel:show()
			arg_2_0.lockPanel:get("textNote3")

			local var_3_7 = string.format("(%d/%d)", arg_2_3, arg_2_4)

			arg_2_0.lockPanel:get("textLevel"):text(var_3_7)
		elseif var_3_1 >= var_2_0.levelUp then
			arg_2_0.btnAct:get("textNote"):text(gLanguageCsv.levelMax)
			uiEasy.setBtnShader(arg_2_0.btnAct, arg_2_0.btnAct:get("textNote"), 2)
			itertools.invoke({
				arg_2_0.textNoteCost,
				arg_2_0.textCost,
				arg_2_0.imgCost,
				arg_2_0.btnDetail
			}, "hide")
			arg_2_0.imgLockBg:hide()
			arg_2_0.lockPanel:hide()
		else
			local var_3_8 = csv.gym.talent_cost[var_3_1]["cost" .. var_2_0.costID].gym_talent_point

			arg_2_0.textCost:text(var_3_8)
			arg_2_0.imgLockBg:hide()
			adapt.oneLineCenterPos(cc.p(arg_2_0.btnAct:x(), arg_2_0.textNoteCost:y()), {
				arg_2_0.textNoteCost,
				arg_2_0.textCost,
				arg_2_0.imgCost
			}, {
				cc.p(10, 0),
				cc.p(10, 0)
			})

			if var_3_1 == 0 then
				arg_2_0.btnAct:get("textNote"):text(gLanguageCsv.spaceActive)
				uiEasy.setBtnShader(arg_2_0.btnAct, arg_2_0.btnAct:get("textNote"), 1)
			else
				arg_2_0.btnAct:get("textNote"):text(gLanguageCsv.spaceUpgrade)
				uiEasy.setBtnShader(arg_2_0.btnAct, arg_2_0.btnAct:get("textNote"), 1)
			end

			text.addEffect(arg_2_0.btnAct:get("textNote"), {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
			arg_2_0.lockPanel:hide()
		end

		arg_2_0.lv = var_3_1
	end)
end

function var_0_1.onActClick(arg_4_0)
	local var_4_0 = csv.gym.talent_buff[arg_4_0.id]

	if csv.gym.talent_cost[arg_4_0.lv]["cost" .. var_4_0.costID].gym_talent_point > arg_4_0.gymDatas:read().gym_talent_point then
		gGameUI:showTip(gLanguageCsv.gymBuffPointNotEnough)

		return
	end

	gGameApp:requestServer("/game/gym/talent/level/up", function(arg_5_0)
		arg_4_0.imgTextBg:show():y(620):stopAllActions():setOpacity(255)
		arg_4_0.imgTextBg:get("imgText"):stopAllActions():setOpacity(255)

		local var_5_0 = 2
		local var_5_1 = 1
		local var_5_2 = 0.5

		if arg_4_0.lv == 0 then
			arg_4_0.imgTextBg:get("imgText"):texture("city/adventure/gym_challenge/txt_jhcg.png")
		else
			arg_4_0.imgTextBg:get("imgText"):texture("city/adventure/gym_challenge/txt_sjcg.png")
		end

		audio.playEffectWithWeekBGM("new_advance_suc.mp3")
		transition.executeSequence(arg_4_0.imgTextBg):moveBy(var_5_2, 0, 100):delay(var_5_0):moveBy(var_5_1, 0, 100):hide():done()
		transition.executeSequence(arg_4_0.imgTextBg):delay(var_5_0 + var_5_2):fadeOut(var_5_1):done()
		transition.executeSequence(arg_4_0.imgTextBg:get("imgText")):delay(var_5_0 + var_5_2):fadeOut(var_5_1):done()
	end, arg_4_0.id)
end

function var_0_1.onDetailClick(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.lv + 1
	local var_6_1 = csv.gym.talent_buff[arg_6_0.id]
	local var_6_2 = "#L10##C0x5B545B#" .. gLanguageCsv.gymBufLvUpEff .. "\n#L0#"

	if var_6_1.effectType == 1 then
		local var_6_3 = {}

		for iter_6_0 = 1, math.huge do
			if var_6_1["attrType" .. iter_6_0] and var_6_1["attrType" .. iter_6_0] ~= 0 and var_6_1["attrNum" .. iter_6_0] then
				local var_6_4 = 0

				if var_6_0 == 0 then
					var_6_4 = dataEasy.getAttrValueString(var_6_1["attrType" .. iter_6_0], var_6_1["attrNum" .. iter_6_0][1])
				else
					var_6_4 = dataEasy.getAttrValueString(var_6_1["attrType" .. iter_6_0], var_6_1["attrNum" .. iter_6_0][var_6_0])
				end

				table.insert(var_6_3, var_6_4)
			else
				break
			end
		end

		var_6_2 = var_6_2 .. string.format(var_6_1.desc, table.unpack(var_6_3))
	elseif var_6_1.effectType == 2 then
		var_6_2 = var_6_2 .. var_0_2(var_6_1.desc, var_6_0 or 0)
	end

	gGameUI:showText(arg_6_1, {
		width = 420,
		content = var_6_2
	})
end

return var_0_1
