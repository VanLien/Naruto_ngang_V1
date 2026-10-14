local var_0_0 = 0.08
local var_0_1 = class("ExploreComponentSuccessView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "explore_component_success_view.json"
var_0_1.RESOURCE_BINDING = {
	rightName = "rightName",
	leftName = "leftName",
	item = "item",
	rightTxt = "rightTxt",
	leftTxt = "leftTxt",
	leftPanel = "leftPanel",
	arrow = "arrow",
	rightPanel = "rightPanel",
	bg = {
		binds = {
			event = "click",
			method = bindHelper.self("onClose")
		}
	},
	topList = {
		varname = "listview",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("topData"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("name", "left", "right", "arrow")

					var_1_0.name:text(getLanguageAttr(arg_1_3.attrType))
					var_1_0.left:text(arg_1_3.left)
					var_1_0.right:text("+" .. arg_1_3.right)

					local var_1_1 = var_0_0 * (5 + arg_1_2)

					uiEasy.setExecuteSequence({
						var_1_0.name,
						var_1_0.note
					}, {
						delayTime = var_1_1
					})
					uiEasy.setExecuteSequence(var_1_0.left, {
						delayTime = var_1_1 + var_0_0
					})
					uiEasy.setExecuteSequence(var_1_0.arrow, {
						delayTime = var_1_1 + var_0_0 * 2
					})
					uiEasy.setExecuteSequence(var_1_0.right, {
						delayTime = var_1_1 + var_0_0 * 3
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onColorClick")
			}
		}
	}
}

function var_0_1.playEffect(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_0:getResourceNode()
	local var_2_1, var_2_2 = var_2_0:get("title"):getPosition()
	local var_2_3 = widget.addAnimationByKey(var_2_0, "effect/gongxihuode.skel", "effect", string.format("xjiesuan_%szi", arg_2_1), 100):setAnchorPoint(cc.p(0.5, 0.5)):xy(var_2_1, var_2_2)

	var_2_3:addPlay(string.format("xjiesuan_%szi_loop", arg_2_1))
	var_2_3:retain()

	local var_2_4 = CSprite.new("effect/gongxihuode.skel")

	var_2_4:addTo(var_2_0, 99)
	var_2_4:setAnchorPoint(cc.p(0.5, 0.5))
	var_2_4:setPosition(var_2_0:get("title"):getPosition())
	var_2_4:visible(true)
	var_2_4:play("jiesuan_shenglitu")
	var_2_4:addPlay("jiesuan_shenglitu_loop")
	var_2_4:retain()
end

function var_0_1.onCreate(arg_3_0, arg_3_1)
	local var_3_0 = csv.explorer.component[arg_3_1.id]

	uiEasy.setIconName(var_3_0.itemID, nil, {
		node = arg_3_0.leftName
	})
	uiEasy.setIconName(var_3_0.itemID, nil, {
		node = arg_3_0.rightName
	})

	local var_3_1

	if arg_3_1.level == 1 then
		var_3_1 = "xjiesuan_jihuozi"

		arg_3_0:showPanel(arg_3_1.id, 0, arg_3_0.leftPanel)
		arg_3_0:showPanel(arg_3_1.id, 1, arg_3_0.rightPanel)
		arg_3_0.leftTxt:text(gLanguageCsv.notActivatedTip)
		arg_3_0.rightTxt:text("Lv1")

		local var_3_2 = {}

		for iter_3_0 = 1, 10 do
			if var_3_0["attrNumType" .. iter_3_0] and var_3_0["attrNumType" .. iter_3_0] ~= 0 then
				table.insert(var_3_2, {
					attrType = var_3_0["attrNumType" .. iter_3_0],
					left = "+" .. dataEasy.getAttrValueString(var_3_0["attrNumType" .. iter_3_0], 0),
					right = dataEasy.getAttrValueString(var_3_0["attrNumType" .. iter_3_0], var_3_0["attrNum" .. iter_3_0][1])
				})
			else
				break
			end
		end

		table.sort(var_3_2, function(arg_4_0, arg_4_1)
			return arg_4_0.attrType < arg_4_1.attrType
		end)

		arg_3_0.topData = idlertable.new(var_3_2)
	else
		var_3_1 = "xjiesuan_shengjizi"

		arg_3_0:showPanel(arg_3_1.id, arg_3_1.level - 1, arg_3_0.leftPanel)
		arg_3_0:showPanel(arg_3_1.id, arg_3_1.level, arg_3_0.rightPanel)
		arg_3_0.leftTxt:text("Lv" .. arg_3_1.level - 1)
		arg_3_0.rightTxt:text("Lv" .. arg_3_1.level)

		local var_3_3 = {}

		for iter_3_1 = 1, 10 do
			if var_3_0["attrNumType" .. iter_3_1] and var_3_0["attrNumType" .. iter_3_1] ~= 0 then
				table.insert(var_3_3, {
					attrType = var_3_0["attrNumType" .. iter_3_1],
					left = dataEasy.getAttrValueString(var_3_0["attrNumType" .. iter_3_1], var_3_0["attrNum" .. iter_3_1][arg_3_1.level - 1]),
					right = dataEasy.getAttrValueString(var_3_0["attrNumType" .. iter_3_1], var_3_0["attrNum" .. iter_3_1][arg_3_1.level])
				})
			else
				break
			end
		end

		table.sort(var_3_3, function(arg_5_0, arg_5_1)
			return arg_5_0.attrType < arg_5_1.attrType
		end)

		arg_3_0.topData = idlertable.new(var_3_3)
	end

	uiEasy.setTitleEffect(arg_3_0:getResourceNode():get("title"), var_3_1)
	uiEasy.setExecuteSequence(arg_3_0.leftPanel, {
		delayTime = var_0_0
	})
	uiEasy.setExecuteSequence(arg_3_0.leftName, {
		delayTime = var_0_0 * 2
	})
	uiEasy.setExecuteSequence(arg_3_0.leftTxt, {
		delayTime = var_0_0 * 3
	})
	uiEasy.setExecuteSequence(arg_3_0.arrow, {
		delayTime = var_0_0 * 2
	})
	uiEasy.setExecuteSequence(arg_3_0.rightPanel, {
		delayTime = var_0_0 * 4
	})
	uiEasy.setExecuteSequence(arg_3_0.rightName, {
		delayTime = var_0_0 * 5
	})
	uiEasy.setExecuteSequence(arg_3_0.rightTxt, {
		delayTime = var_0_0 * 6
	})
end

function var_0_1.showPanel(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = csv.explorer.component[arg_6_1]
	local var_6_1 = csv.items[var_6_0.itemID]
	local var_6_2 = string.format("city/card/helditem/panel_icon_%d.png", var_6_1.quality)
	local var_6_3 = arg_6_3:size()

	;(arg_6_3:get("bg") or ccui.ImageView:create():alignCenter(var_6_3):addTo(arg_6_3, 1, "bg")):texture(var_6_2)

	local var_6_4 = arg_6_3:get("icon") or ccui.ImageView:create():alignCenter(var_6_3):scale(2):addTo(arg_6_3, 2, "icon")
	local var_6_5 = arg_6_3:get("iconMask")

	if var_6_5 then
		var_6_5:visible(arg_6_2 == 0)
		var_6_5:texture(var_6_1.icon):scale(2)
	end

	var_6_4:texture(var_6_1.icon)
	arg_6_3:scale(1.2)
end

function var_0_1.onColorClick(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	arg_7_0.bottomData:atproxy(arg_7_2).selected = not arg_7_0.bottomData:atproxy(arg_7_2).selected

	for iter_7_0, iter_7_1 in arg_7_0.data:ipairs() do
		if iter_7_1:proxy().cfg.quality == arg_7_2 then
			arg_7_0.data:atproxy(iter_7_0).selected = arg_7_0.bottomData:atproxy(arg_7_2).selected
			arg_7_0.data:atproxy(iter_7_0).targetNum = arg_7_0.data:atproxy(iter_7_0).num
		end
	end
end

function var_0_1.onDecompose(arg_8_0)
	local var_8_0 = {}

	for iter_8_0, iter_8_1 in arg_8_0.data:ipairs() do
		if arg_8_0.data:atproxy(iter_8_0).targetNum and arg_8_0.data:atproxy(iter_8_0).targetNum > 0 then
			var_8_0[arg_8_0.data:atproxy(iter_8_0).id] = arg_8_0.data:atproxy(iter_8_0).targetNum
		end
	end

	gGameApp:requestServer("/game/explorer/component/decompose", function(arg_9_0)
		arg_8_0.decomposeNum:set(0)
	end, var_8_0)
end

return var_0_1
