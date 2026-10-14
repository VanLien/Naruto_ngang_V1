local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("ActivityPosterView", Dialog)

var_0_1.RESOURCE_FILENAME = "activity_poster.json"
var_0_1.RESOURCE_BINDING = {
	["leftPanel.checkBox"] = "checkBox",
	["timeNode.activityTime"] = "activityTime",
	btnClose = {
		varname = "btnClose",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	leftPanel = {
		binds = {
			event = "click",
			method = bindHelper.self("onCheckBox")
		}
	}
}

function var_0_1.onCreate(arg_1_0, arg_1_1)
	arg_1_0.cb = arg_1_1.cb
	arg_1_0.state = arg_1_1.state()

	idlereasy.when(arg_1_0.state, function(arg_2_0, arg_2_1)
		arg_1_0.checkBox:setSelectedState(arg_2_1)
	end)

	local var_1_0 = arg_1_0:getResourceNode()
	local var_1_1 = ccui.ImageView:create(arg_1_1.cfg.clientParam.res):alignCenter(var_1_0:size()):scale(2):addTo(var_1_0):setTouchEnabled(true)

	bind.touch(arg_1_0, var_1_1, {
		methods = {
			ended = function()
				arg_1_0:onClick(var_1_1, arg_1_1)
			end
		}
	})

	local var_1_2 = arg_1_1.cfg.clientParam.showId
	local var_1_3 = arg_1_1.cfg.clientParam.countInfo

	if arg_1_1.cfg.clientParam.showId then
		arg_1_0.activityTime:show()

		local var_1_4 = string.split(time.getActivityOpenDate(arg_1_1.cfg.clientParam.showId), "-")

		arg_1_0.activityTime:text(var_1_4[2])

		if var_1_3 then
			local var_1_5 = var_1_3.rotation or 0
			local var_1_6 = var_1_3.posX or arg_1_0.activityTime:x()
			local var_1_7 = var_1_3.posY or arg_1_0.activityTime:y()

			arg_1_0.activityTime:setRotation(var_1_5)
			arg_1_0.activityTime:x(var_1_6)
			arg_1_0.activityTime:y(var_1_7)
		end
	else
		arg_1_0.activityTime:hide()
	end

	if arg_1_1.cfg.clientParam.closeButton then
		arg_1_0.btnClose:loadTextureNormal(arg_1_1.cfg.clientParam.closeButton)
	end

	arg_1_0.redHintRefresh = idler.new(true)

	Dialog.onCreate(arg_1_0, {
		blackType = 1,
		blackOpacity = 204
	})
end

function var_0_1.onReFreshRedHint(arg_4_0)
	if not tolua.isnull(arg_4_0) then
		arg_4_0.redHintRefresh:modify(function(arg_5_0)
			return true, not arg_5_0
		end)
	end
end

function var_0_1.onClick(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_2.cfg.clientParam.showId

	if var_6_0 then
		local var_6_1 = arg_6_2.cfg.clientParam.showName

		if var_6_1 == "city.activity.limit_sprite" then
			gGameApp:requestServer("/game/yy/limit/box/get", function(arg_7_0)
				gGameUI:stackUI(var_6_1, nil, {
					full = true
				}, var_6_0, arg_7_0.view, arg_6_0:createHandler("onReFreshRedHint"))
			end, var_6_0)
		else
			gGameUI:stackUI(var_6_1, nil, {
				full = true
			}, var_6_0)
		end
	end
end

function var_0_1.onCheckBox(arg_8_0)
	arg_8_0.state:modify(function(arg_9_0)
		return true, not arg_9_0
	end)
end

function var_0_1.onClose(arg_10_0)
	arg_10_0:addCallbackOnExit(arg_10_0.cb)
	var_0_0.onClose(arg_10_0)
end

return var_0_1
