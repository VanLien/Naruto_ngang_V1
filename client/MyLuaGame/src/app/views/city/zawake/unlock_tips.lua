local var_0_0 = 380
local var_0_1 = 900
local var_0_2 = cc.load("mvc").ViewBase
local var_0_3 = class("ZawakeUnlockTipsView", var_0_2)

var_0_3.RESOURCE_FILENAME = "zawake_unlock_tips.json"
var_0_3.RESOURCE_BINDING = {
	["panel.title"] = "title",
	item = "item",
	["panel.bg"] = "bg",
	panel = "panel",
	closePanel = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["panel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("listDatas"),
				listHeight = bindHelper.self("listHeight"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = rich.createWithWidth(arg_1_3, 42, nil, 920):anchorPoint(0, 0.5):x(0):addTo(arg_1_1)
					local var_1_1 = var_1_0:size().height + 6

					arg_1_1:height(math.ceil(var_1_1 / 72) * 72)
					var_1_0:y(arg_1_1:height() / 2)
					arg_1_0.listHeight:set(arg_1_0.listHeight:read() + arg_1_1:height())
				end,
				onAfterBuild = function(arg_2_0)
					arg_2_0.afterBuild()
				end
			},
			handlers = {
				afterBuild = bindHelper.self("onAfterBuild")
			}
		}
	}
}

function var_0_3.onCreate(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_1.labelDatas
	local var_3_1 = arg_3_1.align or "center"
	local var_3_2 = arg_3_1.stageID
	local var_3_3 = arg_3_1.pos
	local var_3_4 = arg_3_0.panel:width()
	local var_3_5 = display.sizeInViewRect.width - var_3_4
	local var_3_6 = math.min(display.sizeInViewRect.width / 2 - var_3_4 / 2, var_3_5)

	if var_3_1 == "right" then
		var_3_6 = var_3_5 - 1000
	elseif var_3_1 == "left" then
		var_3_6 = var_3_5 - 700
	end

	if var_3_3 then
		if var_3_1 == "right" then
			var_3_6 = var_3_3.x
		elseif var_3_1 == "left" then
			var_3_6 = var_3_3.x - var_3_4
		end
	end

	arg_3_0.panel:x(var_3_6)

	arg_3_0.listHeight = idler.new(0)
	arg_3_0.listDatas = idlers.newWithMap(var_3_0)

	arg_3_0.title:text(string.format(arg_3_1.title or gLanguageCsv.zawakeStageAwake, gLanguageCsv["symbolRome" .. var_3_2]))
end

function var_0_3.onAfterBuild(arg_4_0)
	local var_4_0 = cc.clampf(arg_4_0.listHeight:read(), var_0_0, var_0_1)

	arg_4_0.list:height(var_4_0)
	arg_4_0.bg:height(var_4_0 + 170)
	arg_4_0.title:y(var_4_0 + 80)
	arg_4_0.panel:y((1260 - var_4_0) / 2)
end

return var_0_3
