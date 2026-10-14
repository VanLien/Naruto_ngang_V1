local var_0_0 = {
	gLanguageCsv.skinBuff1,
	gLanguageCsv.skinBuff2
}
local var_0_1 = class("SkinAwardView", Dialog)

var_0_1.RESOURCE_FILENAME = "card_skin_reward.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	itemAttr = "itemAttr",
	heroNode = "heroNode",
	imgLimitBg = "imgLimitBg",
	textName = "txtName",
	labelInfo = "labelInfo",
	panelNature = "panelNature",
	["panelNature.txtBuffObj"] = "txtBuffObj",
	["panelNature.infoList"] = {
		varname = "attrList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("skinNativeDatas"),
				item = bindHelper.self("itemAttr"),
				itemCell = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = {
						class = "listview",
						props = {
							data = arg_1_3,
							item = arg_1_0.itemCell,
							onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
								local var_2_0 = arg_2_1:multiget("title", "num")

								var_2_0.title:text(getLanguageAttr(arg_2_3.attrType))
								var_2_0.num:text("+" .. dataEasy.getAttrValueString(arg_2_3.attrType, arg_2_3.attrValue))
								adapt.oneLinePos(var_2_0.title, var_2_0.num, cc.p(5, 0), "left")

								local var_2_1 = arg_2_1:width()
								local var_2_2 = var_2_0.title:width() + var_2_0.num:width() + 5

								if var_2_1 < var_2_2 then
									arg_2_1:width(var_2_2)
								end
							end
						}
					}

					bind.extend(arg_1_0, arg_1_1, var_1_0)
				end
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.skinID = arg_3_1
	arg_3_0.time = arg_3_2 or 0
	arg_3_0.skinNativeDatas = idlers.new({})
	arg_3_0.skins = gGameModel.role:getIdler("skins")

	arg_3_0:setSkinInfo()

	local var_3_0 = arg_3_0:getResourceNode()

	widget.addAnimationByKey(var_3_0, "effect/pifuhuoqu.skel", "pifuhuoqu", "effect", 1):anchorPoint(cc.p(0.5, 0.5)):scale(2):xy(var_3_0:width() / 2, var_3_0:height() / 2 - 40):addPlay("effect_loop")
	Dialog.onCreate(arg_3_0)
end

function var_0_1.setSkinInfo(arg_4_0)
	local var_4_0 = gSkinCsv[arg_4_0.skinID]
	local var_4_1 = {}
	local var_4_2 = 0
	local var_4_3 = var_4_0.attrAddType

	arg_4_0.txtBuffObj:text(var_0_0[var_4_3])

	local var_4_4 = {}

	for iter_4_0 = 1, 6 do
		if iter_4_0 % 3 == 1 then
			if iter_4_0 > 3 then
				var_4_1[#var_4_1 + 1] = var_4_4
			end

			var_4_4 = {}
		end

		local var_4_5 = var_4_0["attrType" .. iter_4_0]

		if var_4_5 and var_4_5 ~= 0 then
			table.insert(var_4_4, {
				attrType = var_4_5,
				attrValue = var_4_0["attrNum" .. iter_4_0]
			})
		end
	end

	if #var_4_4 > 0 then
		var_4_1[#var_4_1 + 1] = var_4_4
	end

	arg_4_0.skinNativeDatas:update(var_4_1)
	arg_4_0.txtName:text(var_4_0.name)

	local var_4_6 = dataEasy.getUnitId(nil, arg_4_0.skinID)
	local var_4_7 = csv.unit[var_4_6]
	local var_4_8 = arg_4_0.heroNode:getContentSize()

	arg_4_0.cardSprite = widget.addAnimation(arg_4_0.heroNode, var_4_7.unitRes, "standby_loop", 5):xy(var_4_8.width / 2, 0)

	arg_4_0.cardSprite:scale(var_4_7.scaleU * 3)
	arg_4_0.cardSprite:setSkin(var_4_7.skin)

	local var_4_9 = arg_4_0.time ~= 0

	arg_4_0.imgLimitBg:visible(var_4_9)
	arg_4_0.labelInfo:visible(var_4_9)
	arg_4_0.labelInfo:text(string.format(gLanguageCsv.skinTip04, arg_4_0.time))

	if var_4_9 and arg_4_0.skins:read()[arg_4_0.skinID] == 0 then
		gGameUI:showTip(gLanguageCsv.skinTip08)
	end
end

function var_0_1.onClose(arg_5_0)
	arg_5_0:addCallbackOnExit(arg_5_0.cb)
	Dialog.onClose(arg_5_0)
end

return var_0_1
