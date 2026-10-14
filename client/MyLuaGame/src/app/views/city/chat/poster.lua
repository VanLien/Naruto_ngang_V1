local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("ChatPoster", Dialog)

var_0_1.RESOURCE_FILENAME = "chat_poster.json"
var_0_1.RESOURCE_BINDING = {
	pos0 = "pos0",
	pos1 = "pos1",
	pos2 = "pos2",
	btnClose = {
		varname = "btnClose",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	}
}

function var_0_1.onCreate(arg_1_0)
	Dialog.onCreate(arg_1_0, {
		blackType = 1
	})

	local var_1_0 = rich.createByStr("#C0x000000#" .. gLanguageCsv.preventFraudPosterTitle, 70)

	var_1_0:setAnchorPoint(0.5, 0.5)
	var_1_0:formatText()
	var_1_0:addTo(arg_1_0:getResourceNode(), 10):xy(arg_1_0.pos0:xy())

	local var_1_1 = rich.createWithWidth("#C0x57472E#" .. gLanguageCsv.preventFraudPosterDes1, 50, nil, 600)

	var_1_1:setAnchorPoint(0, 0.5)
	var_1_1:formatText()
	var_1_1:addTo(arg_1_0:getResourceNode(), 10):xy(arg_1_0.pos1:xy())

	local var_1_2 = rich.createWithWidth("#C0x57472E#" .. gLanguageCsv.preventFraudPosterDes2, 50, nil, 600)

	var_1_2:formatText()
	var_1_2:setAnchorPoint(0, 0.5)
	var_1_2:addTo(arg_1_0:getResourceNode(), 10):xy(arg_1_0.pos2:xy())
end

return var_0_1
