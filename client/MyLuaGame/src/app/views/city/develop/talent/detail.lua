local var_0_0 = class("TalentDetailView", Dialog)

var_0_0.RESOURCE_FILENAME = "talent_detail.json"
var_0_0.RESOURCE_BINDING = {
	["upgradePanel.icon2"] = "icon2",
	name = "nodeName",
	descAttr = "descAttr",
	["upgradePanel.num2"] = "num2",
	["upgradePanel.icon1"] = "icon1",
	max = "max",
	desc = "desc",
	static = "static",
	upgradePanel = "upgradePanel",
	["lockPanel.level"] = "lockLevel",
	["lockPanel.condition2"] = "condition2",
	["lockPanel.condition1"] = "condition1",
	icon = "icon",
	lock = "lock",
	level = "Upgradelevel",
	lockPanel = "lockPanel",
	["upgradePanel.num1"] = "num1",
	mask = "mask",
	["upgradePanel.static"] = "upgradeStatic",
	bg1 = "bg1",
	["upgradePanel.btnUpgrade"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onUpgrade")
			}
		}
	},
	["upgradePanel.btnUpgrade.title"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.YELLOW,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	title = {
		varname = "title",
		binds = {
			{
				event = "effect",
				data = {
					color = ui.COLORS.NORMAL.WHITE,
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0, arg_1_1)
	arg_1_0.treeId, arg_1_0.id, arg_1_0.isLock, arg_1_0.talentTree, arg_1_0.ids = arg_1_1()

	arg_1_0:initModel()
	arg_1_0.lock:visible(arg_1_0.isLock)
	arg_1_0.mask:visible(arg_1_0.isLock)
	arg_1_0.lockPanel:visible(arg_1_0.isLock)

	local var_1_0 = csv.talent[arg_1_0.id]

	if arg_1_0.isLock then
		itertools.invoke({
			arg_1_0.upgradePanel,
			arg_1_0.max,
			arg_1_0.Upgradelevel,
			arg_1_0.static
		}, "hide")
		idlereasy.when(arg_1_0.level, function(arg_2_0, arg_2_1)
			local var_2_0 = arg_2_1 >= var_1_0.roleLevel and "C0x01A001" or "C0xF76B45"
			local var_2_1 = string.format(gLanguageCsv.talentDetailRoleLevel, var_2_0, var_1_0.roleLevel)

			rich.createWithWidth(var_2_1, 40, nil, 550):addTo(arg_1_0.condition1, 2):anchorPoint(0, 0)

			local var_2_2 = 0
			local var_2_3 = arg_1_0.talentTree:read()[arg_1_0.treeId]

			if var_2_3 and var_2_3.talent and var_2_3.talent[var_1_0.preTalentID] then
				var_2_2 = var_2_3.talent[var_1_0.preTalentID]
			end

			arg_1_0.condition2:visible(var_1_0.preTalentLevel > 0)
			arg_1_0.lockLevel:visible(var_1_0.preTalentLevel > 0)
			arg_1_0.condition2:text(gLanguageCsv.talentLevelReach)
			arg_1_0.lockLevel:text(string.format("(%d/%d)", var_2_2, var_1_0.preTalentLevel))
			arg_1_0.lockLevel:setTextColor(var_2_2 < var_1_0.preTalentLevel and cc.c4b(252, 53, 0, 255) or cc.c4b(169, 245, 72, 255))
			adapt.oneLinePos(arg_1_0.condition2, arg_1_0.lockLevel, cc.p(5, 0), "left")
			arg_1_0:getDesc(var_1_0, 0)
		end)
	else
		arg_1_0.goldEnough = false
		arg_1_0.talentPointEnough = false

		arg_1_0.upgradePanel:show()
		idlereasy.any({
			arg_1_0.talentTree,
			arg_1_0.talentPoint,
			arg_1_0.gold
		}, function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
			local var_3_0 = arg_3_1[arg_1_0.treeId].talent[arg_1_0.id]

			arg_1_0.max:visible(var_3_0 == var_1_0.levelUp)
			arg_1_0.Upgradelevel:text(var_3_0 .. "/" .. var_1_0.levelUp)
			arg_1_0.upgradePanel:visible(var_3_0 ~= var_1_0.levelUp)
			arg_1_0.Upgradelevel:setTextColor(var_3_0 < var_1_0.levelUp and ui.COLORS.NORMAL.ALERT_ORANGE or ui.NEWCOLORS.BROWN1)
			arg_1_0:getDesc(var_1_0, var_3_0)

			if var_3_0 == var_1_0.levelUp then
				return
			end

			local var_3_1 = csv.talent_cost[var_3_0]
			local var_3_2 = var_3_1["costGold" .. var_1_0.costID]
			local var_3_3 = var_3_1["costTalent" .. var_1_0.costID]

			arg_1_0.num1:text(var_3_2)

			arg_1_0.goldEnough = var_3_2 <= arg_3_3

			arg_1_0.num1:setTextColor(arg_3_3 < var_3_2 and ui.COLORS.NORMAL.ALERT_ORANGE or ui.NEWCOLORS.BROWN1)
			arg_1_0.num2:text(var_3_3)

			arg_1_0.talentPointEnough = var_3_3 <= arg_3_2

			arg_1_0.num2:setTextColor(arg_3_2 < var_3_3 and ui.COLORS.NORMAL.ALERT_ORANGE or ui.NEWCOLORS.BROWN1)
			adapt.oneLineCenterPos(cc.p(arg_1_0.upgradePanel:width() / 2, arg_1_0.upgradePanel:height() / 2), {
				arg_1_0.upgradeStatic,
				arg_1_0.num1,
				arg_1_0.icon1,
				arg_1_0.num2,
				arg_1_0.icon2
			}, cc.p(10, 0))
		end)
	end

	arg_1_0.icon:texture(var_1_0.icon)
	arg_1_0.nodeName:text(var_1_0.name)
	arg_1_0.nodeName:setTextColor(ui.NEWCOLORS.BROWN1)
	Dialog.onCreate(arg_1_0)
end

function var_0_0.onUpgrade(arg_4_0)
	if not arg_4_0.talentPointEnough then
		gGameUI:showTip(gLanguageCsv.talentLevelPointUp)

		return
	end

	if not arg_4_0.goldEnough then
		gGameUI:showTip(gLanguageCsv.goldNotEnough)

		return
	end

	gGameApp:requestServer("/game/talent/levelup_ready", function(arg_5_0)
		arg_4_0.ids[arg_4_0.id] = true

		local var_5_0 = arg_4_0.icon:getContentSize()

		widget.addAnimationByKey(arg_4_0.icon, "effect/jineng.skel", nil, "effect", 555):xy(var_5_0.width / 2, var_5_0.height / 2):scale(0.8)
		audio.playEffectWithWeekBGM("circle.mp3")
	end, arg_4_0.id)
end

function var_0_0.initModel(arg_6_0)
	arg_6_0.talentPoint = gGameModel.role:getIdler("talent_point")
	arg_6_0.gold = gGameModel.role:getIdler("gold")
	arg_6_0.level = gGameModel.role:getIdler("level")
end

function var_0_0.getAttributeNum(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = string.find(arg_7_2, "%%")
	local var_7_1 = ""

	if var_7_0 ~= nil then
		var_7_1 = tonumber(string.sub(arg_7_2, 1, var_7_0 - 1)) * arg_7_3 .. "%"
	else
		var_7_1 = tonumber(arg_7_2) * arg_7_3
	end

	return dataEasy.getAttrValueString(arg_7_1, var_7_1)
end

function var_0_0.getDesc(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_1.attrType1 and arg_8_1.attrNum1 or arg_8_1.damageRelation1[2]
	local var_8_1 = {}
	local var_8_2 = matchLanguage({
		"en",
		"cn"
	}) and " " or ""

	table.insert(var_8_1, arg_8_1.attrAddDesc1 .. var_8_2 .. arg_8_0:getAttributeNum(arg_8_1.attrType1, var_8_0, arg_8_2))

	if arg_8_1.attrNum2 ~= "" then
		table.insert(var_8_1, arg_8_1.attrAddDesc2 .. var_8_2 .. arg_8_0:getAttributeNum(arg_8_1.attrType2, arg_8_1.attrNum2, arg_8_2))
	end

	local var_8_3 = table.concat(var_8_1, "\n")

	arg_8_0.desc:text(var_8_3)
	arg_8_0.desc:setTextColor(ui.COLORS.NORMAL.FRIEND_GREEN)
	arg_8_0.descAttr:text(arg_8_1.attrDesc)
	arg_8_0.descAttr:setTextColor(ui.NEWCOLORS.BROWN1)
end

return var_0_0
