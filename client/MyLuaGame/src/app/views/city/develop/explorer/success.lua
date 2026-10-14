local var_0_0 = 0.08
local var_0_1 = class("ExplorerSuccessView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "explore_success_view.json"
var_0_1.RESOURCE_BINDING = {
	bottomList = "bottomList",
	item = "item",
	topList = "topList",
	pos = "pos",
	txt = "txt",
	leftTxt = "leftTxt",
	rightTxt = "rightTxt",
	bg1 = "bg1",
	arrow = "arrow",
	bg = {
		binds = {
			event = "click",
			method = bindHelper.self("onClose")
		}
	}
}

function var_0_1.playEffect(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0:getResourceNode()
	local var_1_1, var_1_2 = var_1_0:get("title"):getPosition()
	local var_1_3 = widget.addAnimationByKey(var_1_0, "effect/gongxihuode.skel", "effect", string.format("xjiesuan_%szi", arg_1_1), 100):setAnchorPoint(cc.p(0.5, 0.5)):xy(var_1_1, var_1_2)

	var_1_3:addPlay(string.format("xjiesuan_%szi_loop", arg_1_1))
	var_1_3:retain()

	local var_1_4 = CSprite.new("effect/gongxihuode.skel")

	var_1_4:addTo(var_1_0, 99)
	var_1_4:setAnchorPoint(cc.p(0.5, 0.5))
	var_1_4:setPosition(var_1_0:get("title"):getPosition())
	var_1_4:visible(true)
	var_1_4:play("jiesuan_shenglitu")
	var_1_4:addPlay("jiesuan_shenglitu_loop")
	var_1_4:retain()
end

function var_0_1.onCreate(arg_2_0, arg_2_1)
	arg_2_0.topList:setScrollBarEnabled(false)
	arg_2_0.bottomList:setScrollBarEnabled(false)

	arg_2_0.data = arg_2_1()

	if string.find(arg_2_0.data.cfg.res, "skel") then
		widget.addAnimationByKey(arg_2_0.pos, arg_2_0.data.cfg.res, "explorer", "effect_loop", 1011):xy(100, 0):scale(2)
	else
		local var_2_0 = ccui.ImageView:create(arg_2_0.data.cfg.res):alignCenter(arg_2_0.pos:size()):addTo(arg_2_0.pos, 1)
	end

	text.addEffect(arg_2_0.rightTxt, {
		color = ui.COLORS.QUALITY[arg_2_0.data.cfg.quality]
	})

	local var_2_1

	if arg_2_0.data.advance == 1 then
		arg_2_0.leftTxt:text(gLanguageCsv.notActivatedTip)
		arg_2_0.rightTxt:text(arg_2_0.data.cfg.name .. " +1")

		var_2_1 = "xjiesuan_jihuozi"
	else
		text.addEffect(arg_2_0.leftTxt, {
			color = ui.COLORS.QUALITY[arg_2_0.data.cfg.quality]
		})

		var_2_1 = "xjiesuan_shengjizi"

		arg_2_0.leftTxt:text(arg_2_0.data.cfg.name .. string.format(" +%d", arg_2_0.data.advance - 1))
		arg_2_0.rightTxt:text(arg_2_0.data.cfg.name .. string.format(" +%d", arg_2_0.data.advance))
	end

	adapt.oneLinePos(arg_2_0.leftTxt, {
		arg_2_0.arrow,
		arg_2_0.rightTxt
	}, cc.p(10, 0))
	uiEasy.setTitleEffect(arg_2_0:getResourceNode():get("title"), var_2_1)

	local var_2_2 = math.max(1, arg_2_0.data.advance)
	local var_2_3 = {
		verticalSpace = 21
	}

	for iter_2_0, iter_2_1 in pairs(arg_2_0.data.cfg.effect) do
		local var_2_4 = csv.explorer.explorer_effect[iter_2_1]
		local var_2_5

		if var_2_4.skillID then
			local var_2_6 = csv.skill[var_2_4.skillID]
			local var_2_7 = string.format(var_2_4.effectDesc, eval.doMixedFormula(var_2_6.describe, {
				skillLevel = var_2_2,
				math = math
			}, nil))

			var_2_5 = "#C0xFFFFFF#" .. var_2_7
			var_2_5 = string.gsub(var_2_5, "57472e", "FFFFFF")
		elseif var_2_4.attrType1 and var_2_4.attrType2 and var_2_4.attrType3 and var_2_4.attrType4 and var_2_4.attrType5 and var_2_4.attrType6 then
			local var_2_8 = dataEasy.getAttrValueString(var_2_4.attrType1, var_2_4.attrNum1[var_2_2])

			var_2_5 = string.format(var_2_4.effectDesc, var_2_8)
			var_2_5 = string.gsub(var_2_5, "57472e", "FFFFFF")
		else
			local var_2_9 = {}

			for iter_2_2 = 1, 6 do
				if var_2_4["attrType" .. iter_2_2] and var_2_4["attrNum" .. iter_2_2] then
					local var_2_10 = getLanguageAttr(var_2_4["attrType" .. iter_2_2])
					local var_2_11 = dataEasy.getAttrValueString(var_2_4["attrType" .. iter_2_2], var_2_4["attrNum" .. iter_2_2][var_2_2])

					table.insert(var_2_9, var_2_10)
					table.insert(var_2_9, var_2_11)
				end
			end

			var_2_5 = string.format(var_2_4.effectDesc, unpack(var_2_9))
			var_2_5 = string.gsub(var_2_5, "57472e", "FFFFFF")
		end

		table.insert(var_2_3, {
			str = var_2_5
		})
	end

	beauty.textScroll({
		margin = 20,
		align = "left",
		isRich = true,
		list = arg_2_0.topList,
		effect = {
			color = ui.COLORS.NORMAL.WHITE
		},
		strs = var_2_3
	})

	local var_2_12

	for iter_2_3, iter_2_4 in ipairs(arg_2_0.data.cfg.extraEffCod) do
		if iter_2_4 == arg_2_0.data.advance then
			var_2_12 = iter_2_3
		end
	end

	if var_2_12 then
		local var_2_13 = arg_2_0.data.cfg.extraEff[var_2_12]
		local var_2_14 = csv.explorer.explorer_effect[var_2_13]
		local var_2_15 = {}

		if var_2_14.skillID then
			local var_2_16 = csv.skill[var_2_14.skillID]
			local var_2_17 = "#C0xFFFFFF#" .. eval.doMixedFormula(var_2_16.describe, {
				skillLevel = var_2_2,
				math = math
			}, nil)
			local var_2_18 = string.gsub(var_2_17, "57472e", "FFFFFF")

			table.insert(var_2_15, {
				str = "#C0xFFFFFF#" .. var_2_18
			})
		else
			local var_2_19 = {}

			for iter_2_5 = 1, 6 do
				if var_2_14["attrType" .. iter_2_5] and var_2_14["attrNum" .. iter_2_5] then
					local var_2_20 = getLanguageAttr(var_2_14["attrType" .. iter_2_5])
					local var_2_21 = dataEasy.getAttrValueString(var_2_14["attrType" .. iter_2_5], var_2_14["attrNum" .. iter_2_5][var_2_2])

					table.insert(var_2_19, var_2_20)
					table.insert(var_2_19, var_2_21)
				end
			end

			local var_2_22 = string.format(var_2_14.effectDesc, unpack(var_2_19))
			local var_2_23 = string.gsub(var_2_22, "57472e", "FFFFFF")

			table.insert(var_2_15, {
				str = var_2_23
			})
		end

		beauty.textScroll({
			margin = 20,
			align = "left",
			isRich = true,
			list = arg_2_0.bottomList,
			effect = {
				color = ui.COLORS.NORMAL.DEFAULT
			},
			strs = var_2_15
		})
	else
		local var_2_24 = arg_2_0.topList:height()
		local var_2_25 = math.min(arg_2_0.topList:getInnerContainerSize().height, var_2_24 * 2)

		arg_2_0.topList:height(var_2_25)
		arg_2_0.topList:y(arg_2_0.bg1:y() - var_2_25 / 2)
		arg_2_0.bottomList:removeAllChildren()
		arg_2_0.txt:text("")
	end

	uiEasy.setExecuteSequence(arg_2_0.pos)
	uiEasy.setExecuteSequence(arg_2_0.leftTxt)
	uiEasy.setExecuteSequence(arg_2_0.arrow, {
		delayTime = var_0_0
	})
	uiEasy.setExecuteSequence(arg_2_0.rightTxt, {
		delayTime = var_0_0 * 2
	})
	uiEasy.setExecuteSequence(arg_2_0.topList, {
		delayTime = var_0_0 * 3
	})
	uiEasy.setExecuteSequence(arg_2_0.txt, {
		delayTime = var_0_0 * 4
	})
	uiEasy.setExecuteSequence(arg_2_0.bottomList, {
		delayTime = var_0_0 * 5
	})
end

return var_0_1
