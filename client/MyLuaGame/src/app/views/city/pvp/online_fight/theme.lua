local var_0_0 = class("OnlineFightThemeView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "online_fight_theme.json"
var_0_0.RESOURCE_BINDING = {
	title = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(50, 18, 6, 255)
				}
			}
		}
	},
	desc = {
		varname = "desc",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(50, 18, 6, 255)
				}
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0)
	local var_1_0 = gGameModel.cross_online_fight:read("theme_id")
	local var_1_1 = csv.cross.online_fight.theme[var_1_0]

	arg_1_0.desc:text(gLanguageCsv.onlineFightTheme .. var_1_1.desc)
end

return var_0_0
