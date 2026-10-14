local var_0_0 = class("PersonalOtherView", Dialog)

var_0_0.RESOURCE_FILENAME = "personal_other.json"
var_0_0.RESOURCE_BINDING = {
	["rightPanel.centerPanel.battleArrayPanel.txt"] = "txt",
	["rightPanel.upPanel.headImg.vip"] = "vip",
	["rightPanel.upPanel.levelPanel.txtContent"] = "levelTxt",
	["rightPanel.upPanel.guildPanel.txtContent"] = "unionTxt",
	["rightPanel.centerPanel.collectPanel.txtContent"] = "collectTxt",
	["rightPanel.upPanel.powerPanel.txtContent"] = "powerTxt",
	["rightPanel.downPanel.text"] = "signTxt",
	["leftPanel.bg"] = "bg",
	["rightPanel.centerPanel.unlockPanel.txtContent"] = "unlockTxt",
	["rightPanel.upPanel.namePanel.txtContent"] = "nameTxt",
	["leftPanel.cardImg"] = {
		binds = {
			event = "extend",
			class = "role_figure",
			props = {
				spine = true,
				data = bindHelper.self("figureId"),
				onNode = function(arg_1_0)
					arg_1_0:z(7)
				end,
				onSpine = function(arg_2_0)
					arg_2_0:scale(1.2):y(0):x(408)
				end
			}
		}
	},
	title = {
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
	title1 = {
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
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["rightPanel.upPanel.headImg"] = {
		varname = "headImg",
		binds = {
			event = "extend",
			class = "role_logo",
			props = {
				level = false,
				logoId = bindHelper.self("logoId"),
				frameId = bindHelper.self("frameId"),
				vip = bindHelper.self("vipLv"),
				onNode = function(arg_3_0)
					arg_3_0:scale(0.9)
				end
			}
		}
	},
	["rightPanel.centerPanel.battleArrayPanel.list"] = {
		varname = "battleArrayList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("battleData"),
				item = bindHelper.self("item"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					bind.extend(arg_4_0, arg_4_1, {
						class = "card_icon",
						props = {
							unitId = arg_4_3.unitId,
							advance = arg_4_3.advance,
							rarity = arg_4_3.rarity,
							star = arg_4_3.star,
							levelProps = {
								data = arg_4_3.level
							},
							onNode = function(arg_5_0)
								arg_5_0:scale(0.9)
							end
						}
					})

					if arg_4_3.unitId > 0 then
						bind.touch(arg_4_0, arg_4_1, {
							methods = {
								ended = functools.partial(arg_4_0.clickCell, arg_4_2, arg_4_3)
							}
						})
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onClickItem")
			}
		}
	},
	["rightPanel.upPanel.titlePanel.panel"] = {
		binds = {
			event = "extend",
			class = "role_title",
			props = {
				data = bindHelper.self("titleId")
			}
		}
	}
}

function var_0_0.onCreate(arg_6_0, arg_6_1)
	arg_6_0.personData = arg_6_1

	arg_6_0.levelTxt:text(arg_6_1.level)
	arg_6_0.unionTxt:text(arg_6_1.union_name ~= "" and arg_6_1.union_name or gLanguageCsv.none)
	arg_6_0.nameTxt:text(arg_6_1.name)

	local var_6_0 = gLanguageCsv.soLazy

	if arg_6_1.level > gCommonConfigCsv.personalSignShowLevel and string.trim(arg_6_1.personal_sign) ~= "" then
		var_6_0 = arg_6_1.personal_sign
	end

	arg_6_0.signTxt:text(var_6_0)
	arg_6_0.powerTxt:text(arg_6_1.battle_fighting_point)
	arg_6_0.collectTxt:text(string.format("%.1f%%", arg_6_1.collect_num * 100 / table.length(gHandbookArrayCsv)))
	arg_6_0.unlockTxt:text(arg_6_1.collect_num)

	arg_6_0.figureId = idler.new(arg_6_1.figure)

	if matchLanguage({
		"cn",
		"tw",
		"kr"
	}) then
		adapt.setAutoMultiLine(arg_6_0.txt, arg_6_0.txt:text(), 300, -10)
	elseif matchLanguage({
		"en"
	}) then
		adapt.setAutoMultiLine(arg_6_0.txt, arg_6_0.txt:text(), 300, -10)
	end

	local var_6_1 = arg_6_0.headImg:size()

	arg_6_0.logoId = idler.new(arg_6_1.logo)
	arg_6_0.frameId = idler.new(arg_6_1.frame)
	arg_6_0.vipLv = idler.new(arg_6_1.vip_level)
	arg_6_0.titleId = idler.new(arg_6_1.title_id)
	arg_6_0.item = ccui.Layout:create():size(180, 180):show():setTouchEnabled(true):retain()

	local var_6_2 = {}

	for iter_6_0, iter_6_1 in ipairs(arg_6_1.cards) do
		local var_6_3 = csv.cards[iter_6_1.card_id == 0 and 11 or iter_6_1.card_id]
		local var_6_4 = csv.unit[var_6_3.unitID]
		local var_6_5 = dataEasy.getUnitId(iter_6_1.card_id, iter_6_1.skin_id)

		table.insert(var_6_2, {
			cardId = iter_6_1.card_id == 0 and 11 or iter_6_1.card_id,
			advance = iter_6_1.advance,
			unitId = var_6_5,
			star = iter_6_1.star,
			level = iter_6_1.level,
			rarity = var_6_4.rarity,
			id = iter_6_1.id
		})
	end

	if #var_6_2 < 6 then
		for iter_6_2 = #var_6_2 + 1, 6 do
			table.insert(var_6_2, {
				unitId = -1
			})
		end
	end

	arg_6_0.battleData = idlertable.new(var_6_2)

	Dialog.onCreate(arg_6_0)
end

function var_0_0.onCleanup(arg_7_0)
	if arg_7_0.item then
		arg_7_0.item:release()

		arg_7_0.item = nil
	end

	Dialog.onCleanup(arg_7_0)
end

function var_0_0.onClickItem(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if arg_8_3.cardId == -1 then
		return
	end

	gGameApp:requestServer("/game/card_info", function(arg_9_0)
		gGameUI:stackUI("city.card.info", nil, nil, arg_9_0.view)
	end, arg_8_3.id)
end

return var_0_0
