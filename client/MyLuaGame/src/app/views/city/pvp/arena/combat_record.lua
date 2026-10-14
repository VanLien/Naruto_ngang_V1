local function var_0_0(arg_1_0)
	return time.getCutDown(math.max(time.getTime() - arg_1_0, 0), nil, true).short_date_str .. gLanguageCsv.before
end

local var_0_1 = class("ArenaCombatRecordView", Dialog)

var_0_1.RESOURCE_FILENAME = "arena_combat_record.json"
var_0_1.RESOURCE_BINDING = {
	emptyPanel = "emptyPanel",
	item = "item",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["title.textTitle1"] = {
		varname = "textTitle1",
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
	["title.textTitle2"] = {
		varname = "textTitle2",
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
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				data = bindHelper.self("combatDatas"),
				item = bindHelper.self("item"),
				dataOrderCmpGen = bindHelper.self("onSortCards", true),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("head", "textName", "textFightPoint", "btnReplay", "btnShare", "imgFlag", "textTime", "textNum", "imgDownOrUp", "textLv")

					var_2_0.btnShare:visible(dataEasy.isUnlock(gUnlockCsv.battleShare))
					var_2_0.textLv:text(arg_2_3.enemyLevel)
					var_2_0.textName:text(arg_2_3.enemyName)
					var_2_0.textFightPoint:text(arg_2_3.enemyFight)
					var_2_0.imgFlag:texture(arg_2_3.result == "win" and "city/pvp/arena/txt_win.png" or "city/pvp/arena/txt_lose.png")
					var_2_0.textTime:text(var_0_0(arg_2_3.time))
					adapt.setTextScaleWithWidth(var_2_0.textName, nil, 280)
					adapt.setTextScaleWithWidth(var_2_0.textTime, nil, 500)

					if matchLanguage({
						"en"
					}) then
						var_2_0.textTime:x(var_2_0.textTime:x() + 80)
					end

					if arg_2_3.result == "fail" then
						text.addEffect(var_2_0.textNum, {
							color = cc.c4b(185, 35, 49, 255)
						})
					end

					var_2_0.textNum:text(math.abs(arg_2_3.move))
					var_2_0.imgDownOrUp:texture(arg_2_3.result == "win" and "common/icon/logo_arrow_green.png" or "common/icon/logo_arrow_red.png")
					bind.extend(arg_2_0, var_2_0.head, {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_2_3.enemyLogo,
							frameId = arg_2_3.enemyFrame
						}
					})
					bind.touch(arg_2_0, var_2_0.btnReplay, {
						methods = {
							ended = functools.partial(arg_2_0.playbackBtn, arg_2_2, arg_2_3)
						}
					})
					bind.touch(arg_2_0, var_2_0.btnShare, {
						methods = {
							ended = functools.partial(arg_2_0.shareBtn, arg_2_2, arg_2_3)
						}
					})
				end,
				onAfterBuild = function(arg_3_0)
					arg_3_0.afterBuild()
				end
			},
			handlers = {
				afterBuild = bindHelper.self("onAfterBuild"),
				playbackBtn = bindHelper.self("onPlaybackClick"),
				shareBtn = bindHelper.self("onShareClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_4_0)
	arg_4_0:initModel()
	arg_4_0.emptyPanel:hide()

	arg_4_0.combatDatas = arg_4_0.record:read().history

	Dialog.onCreate(arg_4_0)
end

function var_0_1.initModel(arg_5_0)
	arg_5_0.record = gGameModel.arena:getIdler("record")
end

function var_0_1.onPlaybackClick(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = "/game/pw/playrecord/get"

	gGameModel:playRecordBattle(arg_6_3.playRecordID, nil, var_6_0, 0, nil)
end

function var_0_1.onShareClick(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	uiEasy.shareBattleToChat(arg_7_3.playRecordID, arg_7_3.enemyName)
end

function var_0_1.onAfterBuild(arg_8_0)
	arg_8_0.emptyPanel:visible(arg_8_0.list:getChildrenCount() == 0)
end

function var_0_1.onSortCards(arg_9_0, arg_9_1)
	return function(arg_10_0, arg_10_1)
		return arg_10_0.time > arg_10_1.time
	end
end

return var_0_1
