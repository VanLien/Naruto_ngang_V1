local var_0_0 = class("Double11Scratch", Dialog)

var_0_0.RESOURCE_FILENAME = "double_11_scratch.json"
var_0_0.RESOURCE_BINDING = {
	["imgBG.imgGJ"] = {
		varname = "imgGJ",
		binds = {
			event = "touch",
			scaletype = 0,
			method = bindHelper.self("onScratchClick")
		}
	},
	["imgBG.textNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("num")
		}
	},
	btnClose = {
		binds = {
			{
				event = "touch",
				method = bindHelper.self("onClose")
			},
			{
				event = "visible",
				idler = bindHelper.self("opened")
			}
		}
	},
	textNote = {
		binds = {
			event = "visible",
			idler = bindHelper.self("opened")
		}
	}
}

function var_0_0.onCreate(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.opened = idler.new(false)
	arg_1_0.csvId = arg_1_2
	arg_1_0.num = idler.new(string.format(gLanguageCsv.double11Num, arg_1_3))

	Dialog.onCreate(arg_1_0)

	arg_1_0.activityId = arg_1_1
	arg_1_0.moveLength = 0
	arg_1_0.lastX = 0
	arg_1_0.lastY = 0
end

function var_0_0.onScratchClick(arg_2_0, arg_2_1, arg_2_2)
	if arg_2_2.name == "began" then
		arg_2_0.lastX = arg_2_2.x
		arg_2_0.lastY = arg_2_2.y
	elseif arg_2_2.name == "moved" then
		arg_2_0.moveLength = arg_2_0.moveLength + math.sqrt(math.pow(arg_2_0.lastX - arg_2_2.x, 2) + math.pow(arg_2_0.lastY - arg_2_2.y, 2))
		arg_2_0.lastX = arg_2_2.x
		arg_2_0.lastY = arg_2_2.y

		if arg_2_0.moveLength > 2000 then
			arg_2_1:texture("activity/double_11/img_guakai_3.png")
		elseif arg_2_0.moveLength > 1350 then
			arg_2_1:texture("activity/double_11/img_guakai_2.png")
		elseif arg_2_0.moveLength > 600 then
			arg_2_1:texture("activity/double_11/img_guakai_1.png")
		end
	elseif arg_2_2.name == "ended" and arg_2_0.moveLength > 2000 then
		gGameApp:requestServer("/game/yy/double11/card/open", function(arg_3_0)
			arg_2_0.opened:set(true)
			arg_2_1:hide()
		end, arg_2_0.activityId, arg_2_0.csvId)
	end
end

function var_0_0.onClose(arg_4_0)
	if arg_4_0.opened:read() == true then
		Dialog.onClose(arg_4_0)
	end
end

return var_0_0
