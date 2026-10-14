local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("ChipPlanMaskView", var_0_0)

var_0_1.RESOURCE_FILENAME = "chip_plan_mask.json"
var_0_1.RESOURCE_BINDING = {
	panel = "panel",
	maskPanel = "maskPanel"
}

function var_0_1.onCreate(arg_1_0, arg_1_1)
	arg_1_0.params = arg_1_1

	gGameUI.topuiManager:createView("title", arg_1_0, {
		onClose = arg_1_0:createHandler("onMaskClose")
	}):init()
	adapt.dockWithScreen(arg_1_0.panel, "left")
	text.addEffect(arg_1_0.panel:get("tip1"), {
		outline = {
			size = 8,
			color = ui.NEWCOLORS.OUTLINE.BLACK
		}
	})
	text.addEffect(arg_1_0.panel:get("tip2"), {
		outline = {
			size = 8,
			color = ui.NEWCOLORS.OUTLINE.BLACK
		}
	})

	local var_1_0 = arg_1_0.panel:get("bg"):box()
	local var_1_1 = arg_1_0.panel:convertToWorldSpace(cc.p(var_1_0.x, var_1_0.y))
	local var_1_2 = cc.rect(var_1_1.x, var_1_1.y, var_1_0.width, var_1_0.height)
	local var_1_3 = 20
	local var_1_4 = 20
	local var_1_5 = cc.RenderTexture:create(display.sizeInView.width, display.sizeInView.height):addTo(arg_1_0:getResourceNode(), 0, "bgRender")
	local var_1_6 = cc.LayerColor:create(cc.c4b(0, 0, 0, 178), display.sizeInView.width, display.sizeInView.height)
	local var_1_7 = ccui.Scale9Sprite:create()

	var_1_7:initWithFile(cc.rect(80, 80, 1, 1), "other/guide/icon_mask.png")
	var_1_7:anchorPoint(0, 0):size(var_1_2.width - var_1_3 * 2, var_1_2.height - var_1_4 * 2):xy(arg_1_0.panel:box().x + var_1_0.x + var_1_3, arg_1_0.panel:box().y + var_1_0.y + var_1_4)
	var_1_7:setBlendFunc({
		dst = 0,
		src = GL_DST_ALPHA
	})
	var_1_5:begin()
	var_1_6:visit()
	var_1_7:visit()
	var_1_5:endToLua()

	local var_1_8 = arg_1_0.panel:get("img")
	local var_1_9, var_1_10 = var_1_8:xy()
	local var_1_11 = cc.DelayTime:create(1)
	local var_1_12 = cc.Sequence:create(cc.CallFunc:create(function()
		var_1_8:xy(var_1_9 + 100, var_1_10):opacity(0):show()
	end), cc.Spawn:create(cc.FadeIn:create(0.5), cc.RotateTo:create(0.5, 0), cc.MoveTo:create(0.5, cc.p(var_1_9, var_1_10))), cc.DelayTime:create(0.3), cc.CallFunc:create(function()
		var_1_8:hide()
	end), cc.DelayTime:create(0.5))
	local var_1_13 = cc.RepeatForever:create(var_1_12)

	var_1_8:runAction(var_1_13)

	local var_1_14 = arg_1_0.panel:get("bg")

	var_1_14:clone():addTo(arg_1_0.panel):xy(var_1_14:xy()):z(var_1_14:z() - 1)
	var_1_14:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.FadeTo:create(1, 50), cc.FadeTo:create(1, 255))))
	arg_1_0.maskPanel:setTouchEnabled(false)
	uiEasy.addTouchOneByOne(arg_1_0.maskPanel, {
		beforeBegan = function(arg_4_0, arg_4_1, arg_4_2)
			if cc.rectContainsPoint(var_1_2, arg_4_0) then
				return true
			end

			return false
		end
	})
end

function var_0_1.onMaskClose(arg_5_0)
	if arg_5_0.params.onClose then
		arg_5_0.params.onClose()
	else
		arg_5_0:onClose()
	end
end

return var_0_1
