local var_0_0 = class("UnionFragDonateRecordView", Dialog)

var_0_0.RESOURCE_FILENAME = "union_frag_donate_record.json"
var_0_0.RESOURCE_BINDING = {
	item = "item",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["title.textNote1"] = {
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
	["title.textNote2"] = {
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
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("unionFragDonateHistorys"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("logo", "textName", "level", "donateTime", "fragPanel", "donateNote")

					bind.extend(arg_1_0, var_1_0.logo, {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_1_3.logo,
							frameId = arg_1_3.frame,
							onNode = function(arg_2_0)
								arg_2_0:scale(0.9)
							end
						}
					})
					var_1_0.textName:text(arg_1_3.name or "")

					local var_1_1 = time.getDate(arg_1_3.time)

					var_1_0.donateTime:text(string.format(gLanguageCsv.fragDonateTime, var_1_1.month, var_1_1.day, var_1_1.hour, var_1_1.min))
					adapt.oneLinePos(var_1_0.donateTime, var_1_0.donateNote, cc.p(5, 0), "left")
					var_1_0.level:text(arg_1_3.level)
					bind.extend(arg_1_0, var_1_0.fragPanel, {
						event = "extend",
						class = "icon_key",
						props = {
							data = {
								num = 1,
								key = arg_1_3.frag
							},
							onNode = function(arg_3_0)
								arg_3_0:scale(1)
							end
						}
					})
				end,
				preloadCenter = bindHelper.self("lastIdx")
			}
		}
	}
}

function var_0_0.onCreate(arg_4_0)
	arg_4_0:initModel()
	Dialog.onCreate(arg_4_0)

	arg_4_0.lastIdx = idler.new(1)

	idlereasy.any({
		arg_4_0.unionFragDonateHistorys
	}, function(arg_5_0, arg_5_1)
		arg_4_0.lastIdx:set(#arg_5_1)
	end)
end

function var_0_0.initModel(arg_6_0)
	arg_6_0.unionFragDonateHistorys = gGameModel.role:getIdler("union_frag_donate_historys")
end

return var_0_0
