local var_0_0 = class("TrainSkillUpgrade", Dialog)

var_0_0.RESOURCE_FILENAME = "trainer_skill_upgrade.json"
var_0_0.RESOURCE_BINDING = {
	next = "next",
	arrow = "arrow",
	["center.percent"] = "percent",
	["center.money"] = "money",
	name = "nodeName",
	pos = "pos",
	lv2 = "lv2",
	curr = "curr",
	icon = "icon",
	center = "center",
	max = "max",
	["center.total"] = "total",
	lv1 = "lv1",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	titleTxt = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	btnUp = {
		varname = "btnUp",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onUp")
			}
		}
	},
	["btnUp.txt"] = {
		varname = "txt",
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	}
}

function var_0_0.getStr(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_1.nums[arg_1_2]
	local var_1_1 = string.find(tostring(var_1_0), ".", 1, true) ~= nil

	if var_1_1 then
		var_1_0 = var_1_0 * 100
	end

	return string.format(arg_1_1.desc2, var_1_0) .. (var_1_1 and "%" or "")
end

function var_0_0.onCreate(arg_2_0, arg_2_1)
	arg_2_0:initModel()

	arg_2_0.data = arg_2_1

	local var_2_0 = csv.trainer.skills[arg_2_0.data.id]

	arg_2_0.levelMax = var_2_0.levelMax
	arg_2_0.needId, arg_2_0.needCost = csvNext(var_2_0.upCost)

	arg_2_0.total:text("/" .. arg_2_0.needCost)
	arg_2_0.icon:texture(var_2_0.icon):scale(2)
	arg_2_0.nodeName:text(var_2_0.name)
	idlereasy.when(arg_2_0.trainerSkills, function(arg_3_0, arg_3_1)
		local var_3_0 = arg_3_1[arg_2_0.data.id] or 0

		arg_2_0.level = var_3_0

		arg_2_0.lv1:text("Lv." .. var_3_0)
		arg_2_0.lv2:text("Lv." .. var_3_0 + 1)

		if var_3_0 == var_2_0.levelMax then
			itertools.invoke({
				arg_2_0.total,
				arg_2_0.money,
				arg_2_0.percent,
				arg_2_0.arrow,
				arg_2_0.lv2,
				arg_2_0.btnUp
			}, "hide")
			arg_2_0.curr:text(arg_2_0:getStr(var_2_0, var_3_0))
			arg_2_0.next:text(gLanguageCsv.none)
			arg_2_0.max:show()
		elseif var_3_0 ~= 0 then
			itertools.invoke({
				arg_2_0.total,
				arg_2_0.money,
				arg_2_0.percent,
				arg_2_0.arrow,
				arg_2_0.lv2,
				arg_2_0.btnUp
			}, "show")
			arg_2_0.curr:text(arg_2_0:getStr(var_2_0, var_3_0))
			arg_2_0.max:hide()
			arg_2_0.next:text(arg_2_0:getStr(var_2_0, var_3_0 + 1))
		else
			itertools.invoke({
				arg_2_0.total,
				arg_2_0.money,
				arg_2_0.percent,
				arg_2_0.arrow,
				arg_2_0.lv2,
				arg_2_0.btnUp
			}, "show")
			arg_2_0.curr:text(gLanguageCsv.none)
			arg_2_0.next:text(arg_2_0:getStr(var_2_0, var_3_0 + 1))
			arg_2_0.max:hide()
		end
	end)
	idlereasy.when(arg_2_0.items, function(arg_4_0, arg_4_1)
		local var_4_0 = arg_4_1[arg_2_0.needId] or 0

		arg_2_0.percent:text(var_4_0)

		local var_4_1 = var_4_0 >= arg_2_0.needCost

		text.addEffect(arg_2_0.percent, {
			color = var_4_1 and ui.NEWCOLORS.GREENLIGHT or ui.NEWCOLORS.REDLIGHT
		})

		if var_4_1 then
			text.addEffect(arg_2_0.txt, {
				color = ui.COLORS.NORMAL.YELLOW,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			})
		else
			text.deleteAllEffect(arg_2_0.txt)
		end

		cache.setShader(arg_2_0.btnUp, false, var_4_1 and "normal" or "hsl_gray")
		arg_2_0.btnUp:setTouchEnabled(var_4_1)
		adapt.oneLineCenterPos(cc.p(100, 25), {
			arg_2_0.percent,
			arg_2_0.total,
			arg_2_0.money
		})
	end)
	Dialog.onCreate(arg_2_0)
end

function var_0_0.initModel(arg_5_0)
	arg_5_0.trainerSkills = gGameModel.role:getIdler("trainer_skills")
	arg_5_0.items = gGameModel.role:getIdler("items")
end

function var_0_0.onUp(arg_6_0)
	if arg_6_0.levelMax == arg_6_0.level then
		gGameUI:showTip(gLanguageCsv.levelMax)

		return
	end

	gGameApp:requestServer("/game/trainer/skill/levelup", function(arg_7_0)
		arg_6_0:floatTip()

		local var_7_0 = arg_6_0.icon:getContentSize()

		widget.addAnimationByKey(arg_6_0.icon, "koudai_gonghuixunlian/gonghuixunlian.skel", nil, "fangguang", 555):xy(var_7_0.width / 2, 0):scale(0.45)
		audio.playEffectWithWeekBGM("square.mp3")
	end, arg_6_0.data.id)
end

function var_0_0.floatTip(arg_8_0)
	local var_8_0 = arg_8_0.pos:get("tip") or ccui.ImageView:create("city/develop/train/txt_sjcg.png"):addTo(arg_8_0.pos, 1):alignCenter(arg_8_0.pos:size())

	var_8_0:xy(arg_8_0.pos:size().width / 2, 80):show():opacity(255)
	transition.executeSequence(var_8_0):moveBy(0.4, 0, 100):fadeOut(0.3):done()
end

return var_0_0
