local var_0_0 = {
	"common/icon/logo_yellow.png",
	"common/icon/logo_blue.png",
	"common/icon/logo_green.png",
	"common/icon/logo_gray.png"
}
local var_0_1 = csv.mimicry.boss
local var_0_2 = class("MimicryRankView", Dialog)

var_0_2.RESOURCE_FILENAME = "mimicry_rank.json"
var_0_2.RESOURCE_BINDING = {
	mark = "mark",
	down = "down",
	item = "item",
	["title.textTitle2"] = "textTitle2",
	["title.textTitle1"] = "textTitle1",
	titlePanel = "titlePanel",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	list = {
		varname = "rankList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 12,
				asyncPreload = 4,
				data = bindHelper.self("rankDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("baseNode.textLv")
					local var_1_1 = arg_1_1:get("baseNode.textName")
					local var_1_2 = arg_1_1:get("baseNode.server")
					local var_1_3 = arg_1_1:get("baseNode.max")
					local var_1_4 = arg_1_1:get("baseNode.nodeLv")

					var_1_1:text(arg_1_3.name)
					var_1_0:text(arg_1_3.level)
					var_1_2:text(string.format(gLanguageCsv.brackets, getServerArea(arg_1_3.game_key, true)))
					var_1_3:text(arg_1_3.score)
					uiEasy.setRankIcon(arg_1_2, arg_1_1:get("baseNode.imgIcon"), arg_1_1:get("baseNode.textRank1"), arg_1_1:get("baseNode.textRank2"))
					adapt.oneLinePos(var_1_1, {
						var_1_4,
						var_1_0
					}, cc.p(3, 0))
					bind.extend(arg_1_0, arg_1_1:get("baseNode.head"), {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_1_3.logo,
							frameId = arg_1_3.frame
						}
					})
					arg_1_1:get("baseNode.bossName"):text(var_0_1[arg_1_3.boss_id] and var_0_1[arg_1_3.boss_id].gateName or "--")
					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	}
}

function var_0_2.onCreate(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0:initModel()

	arg_2_1 = arg_2_1 or {}
	arg_2_0.dataRank = arg_2_1.ranks or {}
	arg_2_0.rankDatas = idlers.newWithMap(arg_2_0.dataRank)

	arg_2_0.mark:visible(#arg_2_0.dataRank == 0)
	arg_2_0.down:visible(#arg_2_0.dataRank ~= 0)
	arg_2_0.titlePanel:visible(#arg_2_0.dataRank ~= 0)
	arg_2_0.rankList:visible(#arg_2_0.dataRank ~= 0)

	local var_2_0 = arg_2_1.rank and arg_2_1.rank ~= 0 and arg_2_1.rank or gLanguageCsv.noRank

	arg_2_0.down:get("textRank"):text(var_2_0)
	arg_2_0.down:get("textName"):text(arg_2_0.roleName)

	local var_2_1 = arg_2_1.boss_id and var_0_1[arg_2_1.boss_id] and var_0_1[arg_2_1.boss_id].gateName or "--"

	arg_2_0.down:get("bossName"):text(var_2_1)
	arg_2_0.down:get("textLv"):text(arg_2_0.level)

	local var_2_2 = arg_2_1.score or ""

	arg_2_0.down:get("maxNum"):text(var_2_2)
	adapt.oneLinePos(arg_2_0.down:get("textName"), {
		arg_2_0.down:get("nodeLV"),
		arg_2_0.down:get("textLv")
	}, cc.p(5, 0))
	adapt.oneLinePos(arg_2_0.textTitle1, arg_2_0.textTitle2, cc.p(2, 0))

	local var_2_3 = csv.mimicry.base[1].rankingRequiredOpenDays
	local var_2_4 = dataEasy.serverOpenDaysLess(var_2_3)
	local var_2_5 = time.getDate(game.SERVER_OPENTIME)
	local var_2_6 = var_2_5.hour

	var_2_5.hour = 0
	var_2_5.min = 0
	var_2_5.sec = 0

	local var_2_7 = time.getTimeTable()
	local var_2_8 = var_2_7.hour

	var_2_7.hour = 0
	var_2_7.min = 0
	var_2_7.sec = 0

	local var_2_9 = time.getTimestamp(var_2_7) - time.getTimestamp(var_2_5)
	local var_2_10 = 86400
	local var_2_11 = math.floor(var_2_9 / var_2_10)

	if var_2_4 then
		arg_2_0.down:get("textRank"):hide()
		arg_2_0.down:get("textName"):hide()
		arg_2_0.down:get("bossName"):hide()
		arg_2_0.down:get("maxNum"):hide()
		arg_2_0.down:get("textLv"):hide()
		arg_2_0.down:get("nodeLV"):text(string.format(gLanguageCsv.mimicryOpenDay, var_2_3 - var_2_11 - 1, var_2_3))

		local var_2_12 = arg_2_0.down:get("nodeLV"):size()

		arg_2_0.down:get("nodeLV"):anchorPoint(0.5, 0.5)
		arg_2_0.down:get("nodeLV"):xy(900, 45)
	end

	if arg_2_2 <= #arg_2_0.dataRank then
		arg_2_0.isCanDown = true
		arg_2_0.offect = arg_2_2 + 1
		arg_2_0.addRankDataCount = 10

		local var_2_13 = arg_2_0.rankList:getInnerContainer()

		performWithDelay(arg_2_0, function()
			arg_2_0.rankList:onScroll(function(arg_4_0)
				if var_2_13:getPositionY() >= -10 and arg_2_0.isCanDown and arg_2_0.rankList:getChildrenCount() == #arg_2_0.dataRank then
					arg_2_0.isCanDown = false

					arg_2_0:sendProtocol()
				end
			end)
		end, 0)
	end

	Dialog.onCreate(arg_2_0)
end

function var_0_2.sendProtocol(arg_5_0)
	gGameApp:requestServer("/game/cross/mimicry/rank", function(arg_6_0)
		if tolua.isnull(arg_5_0) then
			return
		end

		arg_5_0:initData(arg_6_0.view.ranks)
	end, arg_5_0.offect, arg_5_0.addRankDataCount)
end

function var_0_2.initData(arg_7_0, arg_7_1)
	printtable(arg_7_1)

	if not arg_7_1 or #arg_7_1 == 0 then
		return
	end

	for iter_7_0, iter_7_1 in ipairs(arg_7_1) do
		table.insert(arg_7_0.dataRank, iter_7_1)
	end

	arg_7_0.rankDatas:update(arg_7_0.dataRank)

	arg_7_0.offect = arg_7_0.offect + #arg_7_1
	arg_7_0.isCanDown = arg_7_0.addRankDataCount <= #arg_7_1
end

function var_0_2.initModel(arg_8_0)
	arg_8_0.roleId = gGameModel.mimicry:read("role_db_id")
	arg_8_0.roleName = gGameModel.role:read("name")
	arg_8_0.level = gGameModel.role:read("level")
end

function var_0_2.onItemClick(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	gGameUI:stackUI("city.adventure.mimicry.personal_info", nil, nil, arg_9_3)
end

return var_0_2
