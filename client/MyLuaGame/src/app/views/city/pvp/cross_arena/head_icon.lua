local var_0_0 = class("CrossArenaHeadIconView", Dialog)

var_0_0.RESOURCE_FILENAME = "cross_arena_head_icon.json"
var_0_0.RESOURCE_BINDING = {
	innerList = "innerList",
	item = "item",
	["title.textTitle2"] = "textTitle2",
	["title.textTitle1"] = "textTitle1",
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
				columnSize = 7,
				asyncPreload = 28,
				data = bindHelper.self("icons"),
				item = bindHelper.self("innerList"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("isUse"):visible(arg_1_3.isUse)
					arg_1_1:get("imgSel"):visible(arg_1_3.isSel)

					local var_1_0 = csv.unit[arg_1_3.unitID]

					arg_1_1:get("imgTouxiang"):texture(var_1_0.cardIcon)
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

function var_0_0.onCreate(arg_2_0, arg_2_1)
	arg_2_0:initModel()

	arg_2_0.curSleInfo = {
		row = 1,
		col = 1
	}
	arg_2_0.changeSpineCB = arg_2_1
	arg_2_0.icons = idlers.new()

	local var_2_0 = {}
	local var_2_1 = 0

	for iter_2_0, iter_2_1 in ipairs(gHandbookArrayCsv) do
		if arg_2_0.pokedex:read()[iter_2_1.cardID] then
			var_2_1 = var_2_1 + 1

			local var_2_2 = iter_2_1.cardID == arg_2_0.role:read().display
			local var_2_3 = {}
			local var_2_4 = csv.cards[iter_2_1.cardID]

			var_2_3.isSel = var_2_2
			var_2_3.isUse = var_2_2
			var_2_3.unitID = var_2_4.unitID
			var_2_3.id = iter_2_1.cardID

			table.insert(var_2_0, var_2_3)

			if var_2_2 then
				local var_2_5 = var_2_1 % 7 == 0 and 7 or var_2_1 % 7

				arg_2_0.curSleInfo = {
					row = math.ceil(var_2_1 / 7),
					col = var_2_5
				}
			end
		end
	end

	for iter_2_2, iter_2_3 in pairs(arg_2_0.skins:read()) do
		if iter_2_3 == 0 then
			var_2_1 = var_2_1 + 1

			local var_2_6 = iter_2_2 + game.SKIN_ADD_NUM
			local var_2_7 = gSkinCsv[iter_2_2]
			local var_2_8 = var_2_6 == arg_2_0.role:read().display
			local var_2_9 = {
				isSel = var_2_8,
				isUse = var_2_8,
				unitID = dataEasy.getUnitId(nil, iter_2_2),
				id = var_2_6
			}

			table.insert(var_2_0, var_2_9)

			if var_2_8 then
				local var_2_10 = var_2_1 % 7 == 0 and 7 or var_2_1 % 7

				arg_2_0.curSleInfo = {
					row = math.ceil(var_2_1 / 7),
					col = var_2_10
				}
			end
		end
	end

	arg_2_0.icons:update(var_2_0)
	adapt.oneLinePos(arg_2_0.textTitle1, arg_2_0.textTitle2, nil, "left")
	Dialog.onCreate(arg_2_0)
end

function var_0_0.initModel(arg_3_0)
	arg_3_0.pokedex = gGameModel.role:getIdler("pokedex")
	arg_3_0.skins = gGameModel.role:getIdler("skins")
	arg_3_0.role = gGameModel.cross_arena:getIdler("role")
end

function var_0_0.onItemClick(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	gGameApp:requestServer("/game/cross/arena/display", function(arg_5_0)
		local var_5_0 = arg_4_1:getIdx(arg_4_2)
		local var_5_1 = mathEasy.getIndex(arg_4_0.curSleInfo.row, arg_4_0.curSleInfo.col, 7)

		arg_4_0.icons:atproxy(var_5_1).isSel = false
		arg_4_0.icons:atproxy(var_5_1).isUse = false
		arg_4_0.icons:atproxy(var_5_0.k).isSel = true
		arg_4_0.icons:atproxy(var_5_0.k).isUse = true
		arg_4_0.curSleInfo = var_5_0

		if arg_4_0.changeSpineCB then
			arg_4_0.changeSpineCB(arg_4_3.id)
		end
	end, arg_4_3.id)
end

return var_0_0
