local var_0_0 = class("DailyActivityRankView", Dialog)

var_0_0.RESOURCE_FILENAME = "daily_activity_rank.json"
var_0_0.RESOURCE_BINDING = {
	item = "item",
	empty = "empty",
	["empty.txt2"] = "txtEmpty",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["title.textTitle1"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLACK5
					}
				}
			}
		}
	},
	["title.textTitle2"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLACK5
					}
				}
			}
		}
	},
	["down.textName"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("myName")
		}
	},
	["down.textRank"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("myRank")
		}
	},
	["down.textPoint"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("myScore")
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				data = bindHelper.self("rankDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("imgIcon", "textRank", "head", "textName", "textPoint", "textLv")

					var_1_0.textName:text(arg_1_3.name)
					var_1_0.textLv:text(arg_1_3.level)

					if arg_1_2 < 4 then
						var_1_0.imgIcon:texture(ui.RANK_ICON[arg_1_2])
						var_1_0.textRank:hide()
					else
						var_1_0.imgIcon:hide()
						var_1_0.textRank:text(arg_1_2)
					end

					bind.extend(arg_1_0, var_1_0.head, {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_1_3.logo,
							frameId = arg_1_3.frame,
							onNode = function(arg_2_0)
								arg_2_0:scale(0.9)
							end
						}
					})
					var_1_0.textPoint:text(arg_1_3.score)
					arg_1_1:setTouchEnabled(false)
				end,
				onAfterBuild = function(arg_3_0)
					arg_3_0.afterBuild()
				end
			},
			handlers = {
				afterBuild = bindHelper.self("onAfterBuild")
			}
		}
	}
}

function var_0_0.onCreate(arg_4_0, arg_4_1)
	arg_4_0:initModel()

	if matchLanguage({
		"en",
		"kr"
	}) then
		adapt.setTextAdaptWithSize(arg_4_0.txtEmpty, {
			margin = -8,
			horizontal = "center",
			vertical = "center",
			size = cc.size(450, 200)
		})
		arg_4_0.txtEmpty:xy(arg_4_0.txtEmpty:x() - 10, arg_4_0.txtEmpty:y() - 15)
	end

	arg_4_0.empty:hide()

	arg_4_0.rankDatas = arg_4_1.rank

	if arg_4_1.myrank == 0 then
		arg_4_1.myrank = gLanguageCsv.noRank
	end

	arg_4_0.myRank = idler.new(arg_4_1.myrank)

	if arg_4_1.score ~= 0 then
		arg_4_0.myScore = idler.new(arg_4_1.score)
	end

	Dialog.onCreate(arg_4_0)
end

function var_0_0.initModel(arg_5_0)
	arg_5_0.myName = gGameModel.role:getIdler("name")
end

function var_0_0.onAfterBuild(arg_6_0)
	arg_6_0.empty:visible(itertools.isempty(arg_6_0.rankDatas))
end

return var_0_0
