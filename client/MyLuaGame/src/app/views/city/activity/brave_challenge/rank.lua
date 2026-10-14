local var_0_0 = class("BraveChallengeRankView", Dialog)

var_0_0.RESOURCE_FILENAME = "activity_brave_challenge_rank.json"
var_0_0.RESOURCE_BINDING = {
	["content.rank.down.rank"] = "myRank",
	content = "content",
	["content.rank.down.fastRound"] = "myFastRound",
	["content.rank.down.name"] = "myName",
	["content.rank.item"] = "rankItem",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["content.rank.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 10,
				padding = 10,
				data = bindHelper.self("rankData"),
				item = bindHelper.self("rankItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("rank", "txtRank", "head", "name", "Lv", "Lv1", "fastRound", "ordMedal", "ordMedalNum", "rareMedal", "rareMedalNum", "imgLineup")

					bind.extend(arg_1_0, var_1_0.head, {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_1_3.logo,
							frameId = arg_1_3.frame,
							onNode = function(arg_2_0)
								arg_2_0:xy(104, 95):z(6):scale(0.9)
							end
						}
					})
					var_1_0.rank:get("txt"):visible(arg_1_2 > 3)
					var_1_0.rank:visible(arg_1_2 <= 10)
					var_1_0.txtRank:visible(arg_1_2 > 10)

					if arg_1_2 == 1 then
						var_1_0.rank:texture("city/rank/icon_jp.png")
					elseif arg_1_2 == 2 then
						var_1_0.rank:texture("city/rank/icon_yp.png")
					elseif arg_1_2 == 3 then
						var_1_0.rank:texture("city/rank/icon_tp.png")
					elseif arg_1_2 >= 4 and arg_1_2 <= 10 then
						var_1_0.rank:texture("common/icon/icon_four.png")
						var_1_0.rank:get("txt"):text(arg_1_2)
					elseif arg_1_2 > 10 then
						var_1_0.txtRank:text(arg_1_2)
					end

					arg_1_1:get("area"):text(getServerArea(arg_1_3.game_key))

					local var_1_1

					var_1_1 = arg_1_3.role == 0 and 4 or arg_1_3.role

					var_1_0.name:text(arg_1_3.name)
					var_1_0.Lv1:text(arg_1_3.level)
					adapt.oneLinePos(var_1_0.Lv, var_1_0.Lv1, cc.p(2, 0), "left")
					var_1_0.fastRound:text(arg_1_3.brave_challenge_rank_info.round)
					var_1_0.ordMedalNum:text(arg_1_3.brave_challenge_rank_info.badge_num)
					adapt.oneLinePos(var_1_0.ordMedal, var_1_0.ordMedalNum, cc.p(2, 0), "left")
					var_1_0.rareMedalNum:text(arg_1_3.brave_challenge_rank_info.rare_badge_num)
					adapt.oneLinePos(var_1_0.rareMedal, var_1_0.rareMedalNum, cc.p(2, 0), "left")
					bind.touch(arg_1_0, var_1_0.imgLineup, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_1, arg_1_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		},
		{
			event = "touch",
			methods = {
				ended = bindHelper.self("btnrightClose")
			}
		},
		varname = "rankList"
	}
}

function var_0_0.onCreate(arg_3_0, arg_3_1)
	arg_3_0.data = arg_3_1

	arg_3_0:resetShowPanel()

	arg_3_0.contentColumnSize = 10

	arg_3_0.rankList:setScrollBarEnabled(false)

	arg_3_0.rankData = idlers.newWithMap(arg_3_0.data.ranking or {})

	local var_3_0 = gGameModel.brave_challenge:read("rank")

	if arg_3_1.rank and arg_3_1.rank ~= 0 then
		arg_3_0.myRank:text(arg_3_1.rank)
	else
		arg_3_0.myRank:text(gLanguageCsv.noRank)
	end

	arg_3_0.myName:text(gGameModel.role:read("name"))

	if var_3_0.round and var_3_0.round ~= 0 then
		arg_3_0.myFastRound:text(var_3_0.round)
	else
		arg_3_0.myFastRound:text("--")
	end

	Dialog.onCreate(arg_3_0)
end

function var_0_0.resetShowPanel(arg_4_0)
	arg_4_0.content:get("noRank"):visible(itertools.size(arg_4_0.data.ranking) == 0)
	arg_4_0.content:get("rank"):visible(itertools.size(arg_4_0.data.ranking) ~= 0)
end

function var_0_0.onItemClick(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if gGameUI.itemDetailView then
		gGameUI.itemDetailView:onClose()
	end

	local var_5_0 = "city.activity.brave_challenge.rank_detail"
	local var_5_1 = "vertical"
	local var_5_2 = {
		"baseNode"
	}
	local var_5_3 = tip.create(var_5_0, nil, {
		dir = "right",
		relativeNode = arg_5_2,
		canvasDir = var_5_1,
		childsName = var_5_2
	}, arg_5_3)

	var_5_3:onNodeEvent("exit", functools.partial(gGameUI.unModal, gGameUI, var_5_3))
	gGameUI:doModal(var_5_3)

	gGameUI.itemDetailView = var_5_3
end

return var_0_0
