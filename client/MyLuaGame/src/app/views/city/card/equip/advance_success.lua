local var_0_0 = 0.08
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("CardEquipAdvanceSuccessView", var_0_1)
local var_0_3 = {
	"#C0xFFFFFF#",
	"#C0x5C9970#",
	"#C0x3D8A99#",
	"#C0x8A5C99#",
	"#C0xE69900#",
	"#C0xE67422#"
}

var_0_2.RESOURCE_FILENAME = "card_equip_advance_success.json"
var_0_2.RESOURCE_BINDING = {
	centerPos = "centerPos",
	name2 = "name2",
	pos = "pos",
	txt1 = "txt1",
	name1 = "name1",
	cardImg = "cardImg",
	bg = {
		binds = {
			event = "click",
			method = bindHelper.self("onClose")
		}
	},
	equip1 = {
		varname = "equip1",
		binds = {
			event = "extend",
			class = "equip_icon",
			props = {
				data = bindHelper.self("leftData"),
				onNode = function(arg_1_0)
					local var_1_0 = arg_1_0:multiget("star", "txtLv", "txtLvNum", "imgArrow")

					itertools.invoke({
						var_1_0.txtLv,
						var_1_0.txtLvNum,
						var_1_0.imgArrow
					}, "hide")
				end
			}
		}
	},
	equip2 = {
		varname = "equip2",
		binds = {
			event = "extend",
			class = "equip_icon",
			props = {
				data = bindHelper.self("rightData"),
				onNode = function(arg_2_0)
					local var_2_0 = arg_2_0:multiget("star", "txtLv", "txtLvNum", "imgArrow")

					itertools.invoke({
						var_2_0.txtLv,
						var_2_0.txtLvNum,
						var_2_0.imgArrow
					}, "hide")
				end
			}
		}
	}
}

function var_0_2.onCreate(arg_3_0, arg_3_1)
	uiEasy.setTitleEffect(arg_3_0.centerPos, "xjiesuan_juexingzi")

	arg_3_0.leftData = arg_3_1

	local var_3_0 = clone(arg_3_1)

	var_3_0.awake = arg_3_1.awake + 1
	arg_3_0.rightData = var_3_0

	local var_3_1 = csv.equips[arg_3_1.equip_id]
	local var_3_2 = gLanguageCsv.equipAwakeDetail
	local var_3_3 = game.ATTRDEF_TABLE[var_3_1.awakeAttrType1]
	local var_3_4 = "attr" .. string.caption(var_3_3)
	local var_3_5 = arg_3_1.awake or 0
	local var_3_6 = var_3_5 == 0 and var_3_1.name0 or var_3_1.name1 .. gLanguageCsv["symbolRome" .. var_3_5]
	local var_3_7 = var_3_5 + 1
	local var_3_8 = var_3_1.name1 .. gLanguageCsv["symbolRome" .. var_3_7]
	local var_3_9, var_3_10 = dataEasy.getQuality(arg_3_1.advance)

	arg_3_0.name1:text(var_3_6)
	arg_3_0.name2:text(var_3_8)
	text.addEffect(arg_3_0.name1, {
		color = ui.COLORS.QUALITY[var_3_9]
	})
	text.addEffect(arg_3_0.name2, {
		color = ui.COLORS.QUALITY[var_3_9]
	})

	local var_3_11 = string.format(var_3_2, var_0_3[var_3_9], var_3_8, gLanguageCsv[var_3_4], var_3_1.awakeAttrNum1[var_3_7 >= var_3_1.awakeMax and var_3_1.awakeMax or var_3_7 + 1])

	rich.createWithWidth(var_3_11, 40, nil, 1000):anchorPoint(cc.p(0, 0.5)):addTo(arg_3_0.pos):xy(0, 0)
	uiEasy.setExecuteSequence(arg_3_0.name1)
	uiEasy.setExecuteSequence(arg_3_0.equip1)
	uiEasy.setExecuteSequence(arg_3_0.cardImg, {
		delayTime = var_0_0
	})
	uiEasy.setExecuteSequence(arg_3_0.name2, {
		delayTime = var_0_0 * 2
	})
	uiEasy.setExecuteSequence(arg_3_0.equip2, {
		delayTime = var_0_0 * 2
	})
	uiEasy.setExecuteSequence(arg_3_0.pos, {
		delayTime = var_0_0 * 3
	})
	uiEasy.setExecuteSequence(arg_3_0.txt1, {
		delayTime = var_0_0 * 4
	})
end

function var_0_2.setStar(arg_4_0, arg_4_1, arg_4_2)
	for iter_4_0 = 1, arg_4_2 do
		ccui.ImageView:create("common/icon/icon_star.png"):xy(99 - 15 * (arg_4_2 + 1 - 2 * iter_4_0), 20):addTo(arg_4_1, 4, "star"):scale(1)
	end
end

function var_0_2.onClose(arg_5_0)
	arg_5_0:addCallbackOnExit(arg_5_0.cb)
	var_0_1.onClose(arg_5_0)
end

return var_0_2
