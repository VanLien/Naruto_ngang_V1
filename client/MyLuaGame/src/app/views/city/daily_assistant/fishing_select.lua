local var_0_0 = class("FishingSelectView", Dialog)

var_0_0.RESOURCE_FILENAME = "daily_assistant_fishing_select.json"
var_0_0.RESOURCE_BINDING = {
	subList = "subList",
	item = "item",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 2,
				data = bindHelper.self("itemDatas"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("imgSelect", "pos", "maskPanel", "title")

					var_1_0.imgSelect:visible(arg_1_3.selected)
					var_1_0.title:text(arg_1_3.name)

					local var_1_1 = arg_1_3.myLv < arg_1_3.needLv or arg_1_3.lock == 0

					var_1_0.maskPanel:visible(var_1_1)
					var_1_0.pos:removeAllChildren()

					local var_1_2 = ccui.Scale9Sprite:create()

					var_1_2:initWithFile(cc.rect(50, 50, 1, 1), "city/adventure/fishing/mask_dy_bgpre.png")
					var_1_2:size(cc.size(770, 410))

					local var_1_3 = cc.ClippingNode:create(var_1_2):setAlphaThreshold(0.1):addTo(var_1_0.pos, 1, "clippingNode")

					widget.addAnimationByKey(var_1_3, arg_1_3.res, "diaoyuBg", "effect_loop", 1):scale(0.6)
					bind.click(arg_1_0, arg_1_1, {
						method = functools.partial(arg_1_0.itemClick, arg_1_2, arg_1_3)
					})
				end,
				onAfterBuild = function(arg_2_0)
					arg_2_0:setItemAlignCenter()
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	btnBag = {
		varname = "btnBag",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnBagClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_3_0)
	Dialog.onCreate(arg_3_0)
	arg_3_0:initModel()

	local var_3_0 = {}

	for iter_3_0, iter_3_1 in csvPairs(csv.fishing.scene) do
		if iter_3_1.type == 1 then
			var_3_0[iter_3_0] = {
				selected = false,
				sort = 0,
				csvId = iter_3_0,
				name = iter_3_1.name,
				res = iter_3_1.res,
				needLv = iter_3_1.needLv,
				lock = iter_3_1.lock,
				myLv = arg_3_0.fishLevel:read()
			}
		end
	end

	arg_3_0.itemDatas = idlers.newWithMap(var_3_0)
	arg_3_0.selectScene = idler.new((arg_3_0.fishingSelectScene:read() == 0 or arg_3_0.fishingSelectScene:read() == 999) and 1 or arg_3_0.fishingSelectScene:read())

	arg_3_0.selectScene:addListener(function(arg_4_0, arg_4_1)
		if arg_4_0 == nil then
			return
		end

		if arg_4_1 and arg_3_0.itemDatas:atproxy(arg_4_1) then
			arg_3_0.itemDatas:atproxy(arg_4_1).selected = false
		end

		arg_3_0.itemDatas:atproxy(arg_4_0).selected = true

		gGameApp:requestServer("/game/fishing/prepare", function(arg_5_0)
			return
		end, "scene", arg_4_0)
	end)
end

function var_0_0.initBgMask(arg_6_0)
	arg_6_0.mask1 = ccui.Scale9Sprite:create()

	arg_6_0.mask1:initWithFile(cc.rect(50, 50, 1, 1), "city/adventure/fishing/mask_dy_bgpre.png")
	arg_6_0.mask1:size(cc.size(1858, 888))

	local var_6_0 = cc.ClippingNode:create(arg_6_0.mask1):setAlphaThreshold(0.1):addTo(arg_6_0.scenePanel:get("pos"), 1, "clippingNode")
end

function var_0_0.onItemClick(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	if arg_7_3.lock == 0 then
		gGameUI:showTip(gLanguageCsv.pleaseWaitOpen)

		return
	end

	if arg_7_3.myLv < arg_7_3.needLv then
		gGameUI:showTip(string.format(gLanguageCsv.fishingLvNotEnoughEnterScene, arg_7_3.needLv))

		return
	end

	arg_7_0.selectScene:set(arg_7_3.csvId)
end

function var_0_0.onBtnBagClick(arg_8_0)
	gGameUI:stackUI("city.adventure.fishing.bag", nil, nil, 1, arg_8_0.selectScene:read())
end

function var_0_0.initModel(arg_9_0)
	arg_9_0.fishingSelectScene = gGameModel.fishing:getIdler("select_scene")
	arg_9_0.fishLevel = gGameModel.fishing:getIdler("level")
end

return var_0_0
