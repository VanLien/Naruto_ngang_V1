local var_0_0 = class("SelectFigureView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "character_select_figure.json"
var_0_0.RESOURCE_BINDING = {
	["leftPanel.select"] = "leftSelect",
	["leftPanel.figure"] = "leftFigure",
	["rightPanel.figure"] = "rightFigure",
	["rightPanel.select"] = "rightSelect",
	input = "input",
	btnRandom = {
		varname = "rightPanel",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRandom")
			}
		}
	},
	["btnSure.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	btnSure = {
		binds = {
			clicksafe = true,
			event = "touch",
			methods = {
				ended = bindHelper.self("onSure")
			}
		}
	}
}
var_0_0.RESOURCE_STYLES = {
	full = true
}

function var_0_0.onCreate(arg_1_0, arg_1_1)
	arg_1_0.cb = arg_1_1

	if not matchLanguage({
		"kr"
	}) then
		arg_1_0:onRandom()
	end

	arg_1_0.input:setPlaceHolderColor(ui.COLORS.DISABLED.WHITE)
	arg_1_0.input:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)

	arg_1_0.figures = csv.newbie_init[1].figures
	arg_1_0.select = idler.new(0)
	arg_1_0.leftFigureCfg = gRoleFigureCsv[arg_1_0.figures[1]]
	arg_1_0.leftSpine = widget.addAnimation(arg_1_0.leftFigure, arg_1_0.leftFigureCfg.resSpine, "standby_loop"):scale(2):xy(arg_1_0.leftFigure:size().width / 2, -530)

	arg_1_0.leftSpine:play("standby_loop")
	blacklist:addListener(arg_1_0.input, nil, functools.partial(arg_1_0.nameAdapt, arg_1_0))
	print("==============check==================")
end

function var_0_0.selectClick(arg_2_0, arg_2_1)
	arg_2_0.select:set(arg_2_1)
end

function var_0_0.onRandom(arg_3_0)
	arg_3_0.input:text(beauty.singleTextLimitWord(randomName(), {
		fontSize = 40
	}, {
		width = 300,
		onlyText = true,
		replaceStr = ""
	}))
end

function var_0_0.nameAdapt(arg_4_0, arg_4_1)
	arg_4_1 = arg_4_1 or arg_4_0.input:text()

	local var_4_0 = beauty.singleTextLimitWord(arg_4_1, {
		fontSize = 40
	}, {
		width = 300,
		onlyText = true,
		replaceStr = ""
	})

	arg_4_0.input:text(var_4_0)
end

function var_0_0.onSure(arg_5_0)
	arg_5_0:nameAdapt()

	local var_5_0 = arg_5_0.input:text()

	if uiEasy.checkText(var_5_0) then
		gGameApp:requestServer("/game/role/newbie/init", function(arg_6_0)
			arg_5_0:addCallbackOnExit(arg_5_0.cb)
			arg_5_0:onClose()
		end, 1, var_5_0, arg_5_0.figures[1])
	end
end

return var_0_0
