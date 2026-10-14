local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("UpgradeNoticeView", var_0_0)

var_0_1.RESOURCE_FILENAME = "common_upgrade_notice.json"
var_0_1.RESOURCE_BINDING = {
	top = "top",
	["top.limitItem"] = "limitItem",
	["top.revertItem"] = "revertItem",
	item = "noticeItem",
	bgt = "bgt",
	["top.limitItem.textNum"] = "newLimit",
	["top.limitItem.textOldNum"] = "oldLimit",
	["top.revertItem.textNum"] = "staminaGive",
	back = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["top.imgInfo"] = {
		varname = "imgInfo",
		binds = {
			event = "extend",
			class = "text_atlas",
			props = {
				isEqualDist = false,
				pathName = "lv_big",
				align = "center",
				data = bindHelper.self("roleLv"),
				onNode = function(arg_1_0)
					arg_1_0:xy(-385, -310):scale(1.8)
				end
			}
		}
	},
	list = {
		varname = "noticeList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				dataOrderCmpGen = bindHelper.self("onSortCards", true),
				data = bindHelper.self("noticeDatas"),
				item = bindHelper.self("noticeItem"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("imgBG", "imgIconBG", "imgIcon", "lockPanel", "textName", "textDesc", "imgUnLock", "lock", "btnJump")
					local var_2_1 = arg_2_3.isOpened
					local var_2_2 = "common/box/box_jb_00.png"

					if not var_2_1 then
						var_2_2 = "common/box/box_jb_01.png"
					end

					var_2_0.imgBG:texture(var_2_2)
					var_2_0.imgIcon:texture(arg_2_3.icon)
					var_2_0.lockPanel:visible(not var_2_1)
					var_2_0.textName:text(arg_2_3.name)
					var_2_0.textDesc:text(arg_2_3.desc)
					var_2_0.imgUnLock:visible(arg_2_3.isOpened)
					var_2_0.lock:get("textLvNum"):text(arg_2_3.openLv)
					var_2_0.lock:visible(not arg_2_3.isOpened)
					var_2_0.btnJump:visible(arg_2_3.isOpened and string.len(arg_2_3.goToPanel) > 0)
					var_2_0.lockPanel:get("imgBg"):hide()

					local var_2_3 = var_2_1 and cc.c3b(255, 255, 255) or cc.c3b(128, 128, 128)

					var_2_0.imgIconBG:color(var_2_3)
					var_2_0.imgIcon:color(var_2_3)
					text.addEffect(var_2_0.btnJump:get("textNote"), {
						outline = {
							size = 1,
							color = ui.NEWCOLORS.OUTLINE.YELLOW
						}
					})
					bind.touch(arg_2_0, var_2_0.btnJump, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onGoClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1)
	audio.playEffectWithWeekBGM("role_levelup.mp3")
	arg_3_0:initModel()
	sdk.commitRoleInfo(2, function()
		print("commitRoleInfo level up callback")
	end)

	local var_3_0 = arg_3_0.roleLv:read()
	local var_3_1 = gGameModel.role:read("trainer_level")
	local var_3_2 = gRoleLevelCsv[var_3_0].staminaGive

	arg_3_0.oldLimit:text(gRoleLevelCsv[arg_3_1].staminaMax)
	arg_3_0.newLimit:text(gRoleLevelCsv[var_3_0].staminaMax)
	arg_3_0.staminaGive:text(var_3_2)

	local var_3_3 = {}
	local var_3_4 = 0

	for iter_3_0, iter_3_1 in orderCsvPairs(csv.notice) do
		if var_3_0 >= iter_3_1.noticeLv and var_3_0 <= iter_3_1.openLv then
			var_3_4 = var_3_4 + 1

			local var_3_5 = var_3_0 >= iter_3_1.openLv
			local var_3_6 = var_3_0 == iter_3_1.openLv and -1 or iter_3_1.type

			table.insert(var_3_3, {
				csvId = iter_3_0,
				name = iter_3_1.name,
				icon = iter_3_1.icon,
				desc = iter_3_1.desc,
				openLv = iter_3_1.openLv,
				isOpened = var_3_5,
				priority = var_3_6,
				goToPanel = iter_3_1.goToPanel
			})
		end

		if var_3_4 == 3 then
			break
		end
	end

	arg_3_0.noticeDatas = var_3_3

	local var_3_7 = arg_3_0.imgInfo

	widget.addAnimationByKey(var_3_7, "effect/gongxihuode.skel", "jiesuanshengli", "shengji_new", 1):anchorPoint(cc.p(0.5, 0.5)):xy(var_3_7:width() / 2 + 15, -340):addPlay("shengji_new_loop")
end

function var_0_1.initModel(arg_5_0)
	arg_5_0.roleLv = gGameModel.role:getIdler("level")
end

function var_0_1.onGoClick(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	jumpEasy.jumpTo(arg_6_3.goToPanel)
end

function var_0_1.onSortCards(arg_7_0, arg_7_1)
	return function(arg_8_0, arg_8_1)
		if arg_8_0.priority ~= arg_8_1.priority then
			return arg_8_0.priority < arg_8_1.priority
		end

		if arg_8_0.openLv ~= arg_8_1.openLv then
			return arg_8_0.openLv < arg_8_1.openLv
		end

		return arg_8_0.csvId < arg_8_1.csvId
	end
end

return var_0_1
