local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("CraftEnemyEmbattleView", Dialog)
local var_0_2 = csv.unlock[gUnlockCsv.craft].startLevel
local var_0_3 = {
	[12] = "semifinalsPanel",
	[13] = "championPanel",
	[11] = "finalFourPanel"
}
local var_0_4 = {
	"pre1",
	"pre2",
	"pre3",
	"pre4",
	"pre5",
	"pre6",
	"pre7",
	"pre8",
	"pre9",
	"pre10",
	"final1",
	"final2",
	"final3"
}
local var_0_5 = 10

var_0_1.RESOURCE_FILENAME = "craft_battle_enemy.json"
var_0_1.RESOURCE_BINDING = {
	["prePanel.pre4"] = "pre4",
	["finalPanel.final4"] = "final4",
	["prePanel.pre8"] = "pre8",
	["finalPanel.final7"] = "final7",
	["rolePanel.txtName"] = "roleName",
	["rolePanel.txtState"] = "roleState",
	["prePanel.pre9"] = "pre9",
	["finalPanel.semifinalsPanel"] = "semifinalsPanel",
	["prePanel.pre2"] = "pre2",
	["finalPanel.championPanel"] = "championPanel",
	["rolePanel.txtLv"] = "roleLv",
	["prePanel.pre1"] = "pre1",
	["finalPanel.final1"] = "final1",
	["finalPanel.final8"] = "final8",
	["finalPanel.final2"] = "final2",
	prePanel = "prePanel",
	["finalPanel.final10"] = "final10",
	["prePanel.pre3"] = "pre3",
	["rolePanel.txtRecord"] = "roleRecord",
	finalPanel = "finalPanel",
	imgStar = "imgStar",
	["finalPanel.final9"] = "final9",
	["finalPanel.final3"] = "final3",
	["prePanel.pre10"] = "pre10",
	["finalPanel.finalFourPanel"] = "finalFourPanel",
	["finalPanel.final5"] = "final5",
	["prePanel.pre5"] = "pre5",
	["finalPanel.final6"] = "final6",
	["prePanel.pre7"] = "pre7",
	["prePanel.pre6"] = "pre6",
	["topPanel.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["topPanel.txtNode"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	["topPanel.txtNode2"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	["rolePanel.trainerIcon"] = {
		binds = {
			event = "extend",
			class = "role_logo",
			props = {
				vip = false,
				level = false,
				logoId = bindHelper.self("logoId"),
				frameId = bindHelper.self("frameId"),
				onNode = function(arg_1_0)
					arg_1_0:xy(104, 95):z(6):scale(0.9)
				end
			}
		}
	}
}

local function var_0_6(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	if arg_2_0 then
		if arg_2_0.result == "win" then
			if arg_2_5 then
				arg_2_1, arg_2_2, arg_2_4 = var_0_6(arg_2_5, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
			else
				arg_2_1 = "city/pvp/craft/box_bs.png"
				arg_2_2 = arg_2_3 and gLanguageCsv.stateFighting or gLanguageCsv.beisai
			end
		elseif arg_2_0.result == "fail" then
			if arg_2_4 and not arg_2_5 then
				arg_2_4 = "city/pvp/craft/myteam/txt_jjs.png"
				arg_2_1 = "city/pvp/craft/box_lb.png"
				arg_2_2 = arg_2_3 and gLanguageCsv.stateFighting or gLanguageCsv.beisai
			else
				arg_2_1 = "city/pvp/craft/box_lb.png"
				arg_2_2 = gLanguageCsv.yitaotai
			end
		end
	else
		arg_2_1 = "city/pvp/craft/box_lb.png"
		arg_2_2 = gLanguageCsv.weikaisai
	end

	return arg_2_1, arg_2_2, arg_2_4
end

function var_0_1.onCreate(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_0.logoId = arg_3_1.role_logo
	arg_3_0.frameId = arg_3_1.role_frame

	arg_3_0.roleLv:text(math.max(var_0_2, tonumber(arg_3_1.role_level)))
	arg_3_0.roleName:text(arg_3_1.role_name)

	if not arg_3_1.online then
		arg_3_0.roleState:text(gLanguageCsv.symbolBracketLeft .. gLanguageCsv.offLine .. gLanguageCsv.symbolBracketRight)
		text.addEffect(arg_3_0.roleState, {
			color = ui.NEWCOLORS.GRAY
		})
	end

	adapt.oneLinePos(arg_3_0.roleName, arg_3_0.roleState)

	local var_3_0 = 0
	local var_3_1 = 0

	for iter_3_0, iter_3_1 in pairs(arg_3_1.history) do
		if iter_3_1.result == "win" then
			var_3_0 = var_3_0 + 1
		elseif iter_3_1.result == "fail" then
			var_3_1 = var_3_1 + 1
		end
	end

	arg_3_0.roleRecord:text(string.format(gLanguageCsv.winAndLoseNum, var_3_0, var_3_1))

	if arg_3_2 == 2 then
		local var_3_2 = {}

		for iter_3_2, iter_3_3 in pairs(arg_3_1.history) do
			for iter_3_4 = var_0_5 + 1, #var_0_4 do
				if iter_3_3.round == var_0_4[iter_3_4] then
					var_3_2[iter_3_4] = iter_3_3
				end
			end
		end

		local var_3_3 = "city/pvp/craft/myteam/txt_gjs.png"
		local var_3_4 = "city/pvp/craft/box_lb.png"
		local var_3_5 = gLanguageCsv.weikaisai
		local var_3_6 = {
			final1 = function()
				var_3_4 = "city/pvp/craft/box_bs.png"
				var_3_5 = arg_3_3 and gLanguageCsv.stateFighting or gLanguageCsv.beisai
			end,
			final2 = function()
				var_3_4, var_3_5, var_3_3 = var_0_6(var_3_2[11], var_3_4, var_3_5, arg_3_3)
			end,
			final3 = function()
				var_3_4, var_3_5, var_3_3 = var_0_6(var_3_2[11], var_3_4, var_3_5, arg_3_3, var_3_3, var_3_2[12])
			end
		}

		for iter_3_5 = var_0_5 + 1, #var_0_4 do
			local var_3_7 = arg_3_0[var_0_3[iter_3_5]]:multiget("txtBg", "txtNode", "bg")

			if var_3_2[iter_3_5] then
				var_3_4 = var_3_2[iter_3_5].result == "win" and "city/pvp/craft/box_jj.png" or "city/pvp/craft/box_lb.png"
				var_3_5 = var_3_2[iter_3_5].result == "win" and (var_3_2[iter_3_5].round == "final3" and gLanguageCsv.huosheng or gLanguageCsv.jinji) or gLanguageCsv.xibai

				if var_3_2[12] and var_3_2[12].result == "fail" then
					if iter_3_5 == 12 then
						var_3_5 = gLanguageCsv.xibai
					elseif iter_3_5 == 13 then
						var_3_3 = "city/pvp/craft/myteam/txt_jjs.png"
					end
				end
			else
				var_3_6[var_0_4[iter_3_5]]()
			end

			if var_0_4[iter_3_5] == "final3" then
				var_3_7.bg:texture(var_3_3)
			end

			var_3_7.txtBg:texture(var_3_4)
			var_3_7.txtNode:text(var_3_5)
		end
	end

	arg_3_0.prePanel:visible(arg_3_2 == 1)
	arg_3_0.finalPanel:visible(arg_3_2 == 2)

	local var_3_8 = {}
	local var_3_9 = 0

	local function var_3_10(arg_7_0, arg_7_1)
		if arg_7_1 == 1 then
			for iter_7_0, iter_7_1 in pairs(arg_3_1.history) do
				if iter_7_0 < var_0_5 + 1 then
					table.insert(arg_7_0, iter_7_1.cards[1][1])

					var_3_9 = var_3_9 + 1
				end
			end
		else
			for iter_7_2, iter_7_3 in pairs(arg_3_1.history) do
				if iter_7_2 > var_0_5 then
					for iter_7_4, iter_7_5 in ipairs(iter_7_3.cards) do
						table.insert(arg_7_0, iter_7_5[1])

						var_3_9 = var_3_9 + 1
					end
				end
			end
		end
	end

	if arg_3_2 == 1 then
		var_3_10(var_3_8, 1)

		if var_3_9 < var_0_5 then
			for iter_3_6 = var_3_9 + 1, var_0_5 do
				table.insert(var_3_8, arg_3_1.cards[iter_3_6])
			end
		end
	elseif arg_3_2 == 2 then
		var_3_10(var_3_8, 2)

		if var_3_9 == var_0_5 - 1 then
			local var_3_11 = {}

			var_3_10(var_3_11, 1)

			local var_3_12 = {}

			var_3_10(var_3_12, 2)

			local var_3_13 = {}

			for iter_3_7, iter_3_8 in ipairs(var_3_11) do
				local var_3_14 = true

				for iter_3_9, iter_3_10 in ipairs(var_3_12) do
					if iter_3_10 == iter_3_8 then
						var_3_14 = false

						break
					end
				end

				if var_3_14 then
					table.insert(var_3_13, iter_3_8)
				end
			end

			table.insert(var_3_8, var_3_13[1])
		elseif var_3_9 < var_0_5 - 1 then
			for iter_3_11 = var_3_9 + 1, var_0_5 do
				table.insert(var_3_8, arg_3_1.cards[iter_3_11])
			end
		end
	end

	for iter_3_12 = 1, var_0_5 do
		for iter_3_13, iter_3_14 in pairs(arg_3_1.card_attrs) do
			if iter_3_14.id == var_3_8[iter_3_12] then
				local var_3_15 = arg_3_2 == 1 and arg_3_0["pre" .. iter_3_12] or arg_3_0["final" .. iter_3_12]
				local var_3_16 = var_3_15:multiget("head", "textLv", "textNote", "textFightPoint", "imgAttr1", "imgAttr2", "imgFlag")
				local var_3_17 = csv.cards[iter_3_14.card_id]
				local var_3_18 = csv.unit[var_3_17.unitID]
				local var_3_19 = var_3_18.rarity
				local var_3_20 = dataEasy.getUnitId(iter_3_14.card_id, iter_3_14.skin_id)

				bind.extend(arg_3_0, var_3_16.head, {
					class = "card_icon",
					props = {
						unitId = var_3_20,
						rarity = var_3_19,
						advance = iter_3_14.advance
					}
				})
				var_3_16.textLv:text("Lv" .. iter_3_14.level)
				var_3_16.textFightPoint:text(iter_3_14.fighting_point)

				if arg_3_2 == 1 then
					local var_3_21 = false

					for iter_3_15, iter_3_16 in pairs(arg_3_1.history) do
						if iter_3_16.round == var_0_4[iter_3_12] then
							var_3_21 = iter_3_16
						end
					end

					if var_3_21 then
						var_3_16.imgFlag:texture(var_3_21.result == "win" and "city/pvp/craft/icon_win.png" or "city/pvp/craft/icon_lose.png")
					else
						var_3_16.imgFlag:hide()
					end
				end

				local var_3_22 = var_3_18.natureType

				var_3_16.imgAttr1:texture(ui.ATTR_ICON[var_3_22])

				local var_3_23 = csv.unit[var_3_17.unitID].natureType2

				if var_3_23 then
					var_3_16.imgAttr2:texture(ui.ATTR_ICON[var_3_23])

					local var_3_24 = var_3_16.imgAttr1:y()

					if arg_3_2 == 1 then
						adapt.oneLineCenterPos(cc.p(var_3_15:width() / 2, var_3_16.textLv:y()), {
							var_3_16.textLv,
							var_3_16.imgAttr1,
							var_3_16.imgAttr2
						}, cc.p(5, 0))
					else
						adapt.oneLinePos(var_3_16.textLv, {
							var_3_16.imgAttr1,
							var_3_16.imgAttr2
						}, {
							cc.p(15, 0),
							cc.p(5, 0)
						})
					end

					var_3_16.imgAttr1:y(var_3_24)
					var_3_16.imgAttr2:y(var_3_24)
				else
					var_3_16.imgAttr2:hide()

					local var_3_25 = var_3_16.imgAttr1:y()

					if arg_3_2 == 1 then
						adapt.oneLineCenterPos(cc.p(var_3_15:width() / 2, var_3_16.textLv:y()), {
							var_3_16.textLv,
							var_3_16.imgAttr1
						}, cc.p(15, 0))
					else
						adapt.oneLinePos(var_3_16.textLv, var_3_16.imgAttr1, cc.p(15, 0), "left")
					end

					var_3_16.imgAttr1:y(var_3_25)
				end

				local var_3_26 = iter_3_14.star

				for iter_3_17 = 1, var_3_26 do
					if iter_3_17 < 7 then
						local var_3_27 = math.min(var_3_26, 6)
						local var_3_28 = arg_3_2 == 1 and 160 - 18 * (var_3_27 + 1 - 2 * iter_3_17) or 240 + (iter_3_17 - 1) * 40
						local var_3_29 = arg_3_2 == 1 and 85 or 115
						local var_3_30 = arg_3_0.imgStar:clone():xy(var_3_28, var_3_29):show():addTo(var_3_15, 10, "star" .. iter_3_17)
					else
						local var_3_31 = iter_3_17 % 6 == 0 and 6 or iter_3_17 % 6
						local var_3_32 = var_3_15:getChildByName("star" .. var_3_31)

						if var_3_32 then
							var_3_32:texture("common/icon/icon_star_z.png")
						end
					end
				end

				if arg_3_2 == 1 then
					adapt.oneLineCenterPos(cc.p(var_3_15:width() / 2, var_3_16.textNote:y()), {
						var_3_16.textNote,
						var_3_16.textFightPoint
					}, cc.p(10, 0))

					break
				end

				adapt.oneLinePos(var_3_16.textNote, var_3_16.textFightPoint, cc.p(10, 0))

				break
			end
		end
	end

	Dialog.onCreate(arg_3_0)
end

return var_0_1
