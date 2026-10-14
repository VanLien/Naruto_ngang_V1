local var_0_0 = require("app.views.city.activity.grid_walk.tools")
local var_0_1 = class("GridWalkScratch", Dialog)

var_0_1.RESOURCE_FILENAME = "grid_walk_scratch.json"
var_0_1.RESOURCE_BINDING = {
	["imgBG.drawPanel"] = "drawPanel",
	["imgBG.resultPanel.text"] = "text",
	["imgBG.imgGJ"] = "imgGJ",
	["imgBG.resultPanel.text1"] = "text1",
	imgBG = "imgBG",
	["imgBG.resultPanel"] = "resultPanel",
	["imgBG.touchPanel"] = {
		binds = {
			event = "touch",
			scaletype = 0,
			method = bindHelper.self("onScratchClick")
		}
	},
	["imgBG.textNum"] = {
		varname = "textNum",
		binds = {
			{
				event = "text",
				idler = bindHelper.self("num")
			},
			{
				event = "effect",
				data = {
					outline = {
						size = 6,
						color = ui.COLORS.NORMAL.DEFAULT
					}
				}
			}
		}
	},
	["imgBG.icon"] = {
		varname = "icon",
		binds = {
			event = "texture",
			idler = bindHelper.self("img")
		}
	},
	textNote = {
		binds = {
			event = "visible",
			idler = bindHelper.self("opened")
		}
	},
	["imgBG.resultPanel.num"] = {
		varname = "leftNum",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.DEFAULT
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_1_0, arg_1_1)
	arg_1_0.callBack = arg_1_1.callBack

	local var_1_0 = arg_1_1.iconNum
	local var_1_1 = arg_1_1.event
	local var_1_2 = var_1_1.params.outcome + 1
	local var_1_3 = csv.yunying.grid_walk_events[var_1_1.csv_id].params.items[var_1_2]
	local var_1_4 = dataEasy.getNumByKey(var_1_3[1])

	if var_1_3[1] == var_0_0.BADGE_ID then
		arg_1_0.badgeNum = var_1_3[2]
		var_1_4 = math.max(var_1_0 - arg_1_0.badgeNum, 0)
	end

	local var_1_5 = dataEasy.getCfgByKey(var_1_3[1])
	local var_1_6 = var_1_3[2]

	arg_1_0.leftNum:text(var_1_4)
	adapt.oneLinePos(arg_1_0.text, {
		arg_1_0.leftNum,
		arg_1_0.text1
	}, cc.p(10, 0))
	arg_1_0.imgGJ:show()

	arg_1_0.img = idler.new(var_1_5.icon)
	arg_1_0.num = idler.new(-var_1_6)
	arg_1_0.opened = idler.new(false)
	arg_1_0.moveLength = 0
	arg_1_0.lastX = 0
	arg_1_0.lastY = 0
	arg_1_0.showType = 0

	arg_1_0.resultPanel:hide()
	Dialog.onCreate(arg_1_0)
end

function var_0_1.onScratchClick(arg_2_0, arg_2_1, arg_2_2)
	if arg_2_2.name == "began" then
		arg_2_0.lastX = arg_2_2.x
		arg_2_0.lastY = arg_2_2.y
	elseif arg_2_2.name == "moved" then
		arg_2_0.moveLength = arg_2_0.moveLength + math.sqrt(math.pow(arg_2_0.lastX - arg_2_2.x, 2) + math.pow(arg_2_0.lastY - arg_2_2.y, 2))
		arg_2_0.lastX = arg_2_2.x
		arg_2_0.lastY = arg_2_2.y

		if arg_2_0.moveLength > 2000 then
			arg_2_0:showMask(3)
		elseif arg_2_0.moveLength > 1350 then
			arg_2_0:showMask(2)
		elseif arg_2_0.moveLength > 600 then
			arg_2_0:showMask(1)
		end
	elseif arg_2_2.name == "ended" and arg_2_0.moveLength > 2000 then
		performWithDelay(arg_2_0, function()
			arg_2_0.opened:set(true)
			arg_2_0.drawPanel:hide()
			arg_2_0.resultPanel:show()
			arg_2_1:hide()
		end, 0)
	end
end

function var_0_1.showMask(arg_4_0, arg_4_1)
	if arg_4_1 <= arg_4_0.showType then
		return
	end

	arg_4_0.imgGJ:hide()

	arg_4_0.showType = arg_4_1

	arg_4_0.drawPanel:removeAllChildren()

	local var_4_0 = cc.RenderTexture:create(arg_4_0.drawPanel:width(), arg_4_0.drawPanel:height()):addTo(arg_4_0.drawPanel, 5, "bgRender")

	var_4_0:begin()
	ccui.ImageView:create("activity/grid_walk/img_eyk5.png"):xy(arg_4_0.imgGJ:x(), arg_4_0.imgGJ:y()):visit()

	for iter_4_0 = 1, 3 do
		local var_4_1 = ccui.ImageView:create("activity/grid_walk/img_eyk_mask.png"):xy(arg_4_0.imgGJ:x(), arg_4_0.imgGJ:y() - 100 + 50 * iter_4_0)

		var_4_1:setBlendFunc({
			src = GL_DST_ALPHA,
			dst = GL_SRC_ALPHA
		})

		if arg_4_1 == 2 then
			var_4_1:scale(1.1)
		elseif arg_4_1 == 3 then
			var_4_1:scale(1.3)
		end

		var_4_1:visit()

		if arg_4_1 == iter_4_0 then
			break
		end
	end

	var_4_0:endToLua()
end

function var_0_1.onClose(arg_5_0)
	if arg_5_0.opened:read() == true then
		arg_5_0:addCallbackOnExit(functools.partial(arg_5_0.callBack, arg_5_0.badgeNum))
		Dialog.onClose(arg_5_0)
	end
end

return var_0_1
