local var_0_0 = {
	JUMP = 2,
	NORMAL = 3,
	UNLOCK = 1
}
local var_0_1 = game.SHOP_UNLOCK_KEY
local var_0_2 = require("app.views.common.gain_way").WAY_TITLE
local var_0_3 = cc.load("mvc").ViewBase
local var_0_4 = class("HandbookGainWayView", var_0_3)

var_0_4.RESOURCE_FILENAME = "handbook_from.json"
var_0_4.RESOURCE_BINDING = {
	["panel.tip"] = "tip",
	item = "item",
	["panel.imgBG"] = "imgBG",
	item1 = "item1",
	["panel.head"] = {
		binds = {
			event = "extend",
			class = "card_icon",
			props = {
				cardId = bindHelper.self("cardIdIdler"),
				onNode = function(arg_1_0)
					return
				end
			}
		}
	},
	["panel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("gainWayDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true,
					alwaysShow = true
				},
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					if not arg_2_3.text1 then
						local var_2_0 = string.split(arg_2_3.target, "-")
						local var_2_1 = gLanguageCsv[var_2_0[1]]
						local var_2_2 = (var_0_2[var_2_0[1]] or {})[tonumber(var_2_0[2]) or var_2_0[2]] or ""
						local var_2_3 = tonumber(var_2_0[1])

						if var_2_3 then
							local var_2_4, var_2_5, var_2_6, var_2_7 = dataEasy.getChapterInfoByGateID(var_2_3)

							if var_2_5 == 0 then
								if var_2_4 == 1 then
									var_2_2 = string.format("%s%s", gLanguageCsv.gateStory, gLanguageCsv.gate)
								else
									var_2_2 = string.format("%s%s", gLanguageCsv.gateDifficult, gLanguageCsv.gate)
								end
							else
								var_2_2 = csv.scene_conf[tonumber(var_2_0[1])].sceneName .. " " .. var_2_5 .. "-" .. var_2_6
							end
						elseif var_2_0[1] == "activity" then
							var_2_2 = ""
						end

						arg_2_1:get("textNote1"):text(var_2_1)
						arg_2_1:get("textInfo"):text(var_2_2)
						adapt.oneLinePos(arg_2_1:get("textNote1"), arg_2_1:get("textInfo"), cc.p(15, 0), "left")

						local var_2_8 = arg_2_1:get("btnJump")
						local var_2_9 = var_2_8:get("textNote")

						var_2_8:visible(arg_2_3.state == var_0_0.JUMP)

						if arg_2_3.state ~= var_0_0.JUMP then
							return
						end

						local var_2_10 = jumpEasy.isJumpUnlock(arg_2_3.target, false)

						if var_2_0[1] == "shop" then
							local var_2_11 = tonumber(var_2_0[2]) or 1

							if var_0_1[var_2_11].mustHaveUion == true and gGameModel.role:read("union_db_id") == nil then
								var_2_10 = false
							end
						end

						local var_2_12 = var_2_10 and cc.c4b(255, 252, 237, 255) or ui.COLORS.DISABLED.WHITE
						local var_2_13 = var_2_10 and "normal" or "hsl_gray"
						local var_2_14 = var_2_10 and gLanguageCsv.leaveFor or gLanguageCsv.notOpen

						cache.setShader(var_2_8, false, var_2_13)
						text.deleteAllEffect(var_2_9)
						text.addEffect(var_2_9, {
							color = var_2_12,
							outline = {
								size = 4,
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							}
						})
						var_2_9:text(var_2_14)
						var_2_8:setTouchEnabled(var_2_10)

						if var_2_10 then
							bind.touch(arg_2_0, var_2_8, {
								methods = {
									ended = functools.partial(arg_2_0.clickItem, arg_2_3)
								}
							})
						end
					else
						arg_2_1:get("textNote1"):text(arg_2_3.text1)
						arg_2_1:get("textInfo"):text(arg_2_3.text2)
						text.addEffect(arg_2_1:get("btnJump"):get("textNote"), {
							outline = {
								size = 4,
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							}
						})
						adapt.oneLinePos(arg_2_1:get("textNote1"), arg_2_1:get("textInfo"), cc.p(15, 0), "left")
						bind.touch(arg_2_0, arg_2_1:get("btnJump"), {
							methods = {
								ended = functools.partial(arg_2_0.clickItem, arg_2_3)
							}
						})
					end
				end
			},
			handlers = {
				clickItem = bindHelper.self("onClick")
			}
		}
	},
	["panel.upList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("cardAttrs"),
				item = bindHelper.self("item1"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = ui.ATTR_ICON[arg_3_3]

					arg_3_1:get("imgIcon"):texture(var_3_0)
				end
			}
		}
	},
	["panel.textName"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("textName")
		}
	},
	["panel.tip.textNode"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("tipText")
		}
	}
}

function var_0_4.onCreate(arg_4_0, arg_4_1)
	arg_4_0.cardIdIdler = arg_4_1.selCardId()

	arg_4_0:initModel()

	arg_4_0.isShowTip = idler.new(true)
	arg_4_0.gainWayDatas = idlers.newWithMap({})
	arg_4_0.textName = idler.new("")
	arg_4_0.cardAttrs = idlers.newWithMap({})
	arg_4_0.tipText = idler.new("")

	arg_4_0.list:y(arg_4_0.list:y() - 20)

	local var_4_0 = table.length(gRoleLevelCsv)
	local var_4_1 = {}

	for iter_4_0, iter_4_1 in csvPairs(csv.world_map) do
		local var_4_2 = {}

		if iter_4_1.chapterType and var_4_0 >= iter_4_1.openLevel then
			if not var_4_1[iter_4_1.chapterType] then
				var_4_1[iter_4_1.chapterType] = {}
			end

			var_4_2.sortIndex = iter_4_0

			table.insert(var_4_1[iter_4_1.chapterType], var_4_2)
		end
	end

	for iter_4_2, iter_4_3 in pairs(var_4_1) do
		table.sort(iter_4_3, function(arg_5_0, arg_5_1)
			return arg_5_0.sortIndex < arg_5_1.sortIndex
		end)
	end

	idlereasy.when(arg_4_0.cardIdIdler, function(arg_6_0, arg_6_1)
		local var_6_0 = csv.cards[arg_6_1]
		local var_6_1 = csv.unit[var_6_0.unitID]

		arg_4_0.rarity = var_6_1.rarity

		local var_6_2 = {}

		if var_6_0.megaIndex <= 0 then
			local var_6_3 = csv.fragments[var_6_0.fragID]

			for iter_6_0 = 1, math.huge do
				local var_6_4 = var_6_3["produceGate" .. iter_6_0]

				if not var_6_4 or var_6_4 == "" then
					break
				end

				local var_6_5 = tonumber(var_6_4)
				local var_6_6 = true

				if var_6_5 then
					local var_6_7, var_6_8, var_6_9, var_6_10 = dataEasy.getChapterInfoByGateID(var_6_5)

					var_6_6 = var_4_1[var_6_7][var_6_8] ~= nil
				end

				if string.find(var_6_4, "^shop-") then
					local var_6_11 = tonumber(string.sub(var_6_4, 6)) or 1
					local var_6_12 = var_0_1[var_6_11].unlockKey

					if var_6_12 and not dataEasy.isUnlock(var_6_12) then
						var_6_6 = false
					end

					if not gShopGainMap[var_6_0.fragID] then
						var_6_6 = false
					end
				end

				if string.find(var_6_4, "^drawCard-") and not gDrawPreviewMap[var_6_0.fragID] then
					var_6_6 = false
				end

				if var_6_6 then
					table.insert(var_6_2, {
						target = var_6_4,
						state = var_0_0.JUMP
					})
				end
			end

			arg_4_0.tipText:set(var_6_3.produceDesc)
		else
			table.insert(var_6_2, {
				text1 = gLanguageCsv.megaTitle,
				text2 = gLanguageCsv.megaHouse,
				cardId = arg_6_1,
				target = "cardMega-" .. arg_6_1
			})
		end

		local var_6_13 = #var_6_2 == 0

		arg_4_0.isShowTip:set(var_6_13)
		arg_4_0.gainWayDatas:update(var_6_2)

		local var_6_14 = {}

		table.insert(var_6_14, var_6_1.natureType)

		if var_6_1.natureType2 then
			table.insert(var_6_14, var_6_1.natureType2)
		end

		arg_4_0.cardAttrs:update(var_6_14)
		arg_4_0.textName:set(var_6_0.name or "")
	end)
	idlereasy.when(arg_4_0.isShowTip, function(arg_7_0, arg_7_1)
		arg_4_0.tip:visible(arg_7_1)
		arg_4_0.imgBG:visible(arg_7_1)
	end)
end

function var_0_4.initModel(arg_8_0)
	arg_8_0.gateOpen = gGameModel.role:getIdler("gate_open")
	arg_8_0.cards = gGameModel.role:getIdler("pokedex")
end

function var_0_4.onClick(arg_9_0, arg_9_1, arg_9_2)
	jumpEasy.jumpTo(arg_9_2.target)
end

return var_0_4
