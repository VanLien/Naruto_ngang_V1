local var_0_0 = {}
local var_0_1 = require("app.views.city.adventure.dispatch_task.view")
local var_0_2 = {
	dispatchTaskRefresh = 5
}

local function var_0_3()
	return {
		{
			key = "shop",
			viewName = "city.shop",
			icon = "city/main/icon_sd.png",
			name = gLanguageCsv.shop,
			styles = {
				full = true
			},
			func = function(arg_2_0)
				gGameApp:requestServer("/game/fixshop/get", function()
					arg_2_0()
				end)
			end
		},
		{
			key = "drawCard",
			viewName = "city.drawcard.view",
			icon = "city/main/icon_nd@.png",
			name = gLanguageCsv.drawCard,
			styles = {
				full = true
			},
			redHint = {
				class = "red_hint",
				props = {
					specialTag = {
						"drawcardDiamondFree",
						"drawcardGoldFree",
						"drawcardEquipFree"
					}
				}
			}
		},
		{
			key = "handbook",
			unlockKey = "handbook",
			viewName = "city.handbook.view",
			icon = "city/main/icon_tj@.png",
			name = gLanguageCsv.handbook,
			styles = {
				full = true
			},
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "handbookAdvance"
				}
			}
		},
		{
			key = "develop",
			viewName = "city.develop.develop",
			icon = "city/main/icon_yc@.png",
			name = gLanguageCsv.develop,
			styles = {
				full = true
			},
			redHint = {
				class = "red_hint",
				props = {
					specialTag = {
						"cityTalent",
						"cityTrainer",
						"explorerTotal",
						"explorerFind",
						"totemGroup",
						"totemFree"
					}
				}
			}
		},
		{
			key = "bag",
			viewName = "city.bag",
			icon = "city/main/icon_bb@.png",
			name = gLanguageCsv.bag,
			styles = {
				full = true
			}
		},
		{
			key = "task",
			actionExpandName = "task",
			viewName = "city.task",
			icon = "city/main/icon_rw.png",
			offx = 255,
			name = gLanguageCsv.task,
			styles = {
				full = true
			},
			redHint = {
				class = "red_hint",
				props = {
					specialTag = {
						"cityTaskDaily",
						"cityTaskMain",
						"achievementTask",
						"achievementBox"
					}
				}
			}
		},
		{
			key = "cardBag",
			viewName = "city.card.bag",
			icon = "city/main/icon_jl@.png",
			name = gLanguageCsv.card,
			styles = {
				full = true
			},
			redHint = {
				class = "red_hint",
				props = {
					specialTag = {
						"bottomFragment",
						"totalCard"
					}
				}
			}
		},
		{
			key = "team",
			viewName = "city.card.embattle.base",
			icon = "city/main/icon_bd@.png",
			name = gLanguageCsv.formation,
			styles = {
				full = true
			}
		}
	}
end

local function var_0_4()
	return {
		{
			key = "totem",
			unlockKey = "totem",
			viewName = "city.develop.totem.view",
			icon = "city/main/icon_zc_tt.png",
			name = gLanguageCsv.totem,
			styles = {
				full = true
			},
			redHint = {
				class = "red_hint",
				props = {
					specialTag = {
						"totemGroup",
						"totemAwardAllGet",
						"totemFree"
					},
					onNode = function(arg_5_0)
						arg_5_0.xy(arg_5_0, 150, 150)
					end
				}
			}
		},
		{
			key = "title_book",
			unlockKey = "title",
			viewName = "city.develop.title_book.view",
			icon = "city/main/icon_chp@.png",
			name = gLanguageCsv.titleBook
		},
		{
			key = "trainer",
			unlockKey = "trainer",
			viewName = "city.develop.trainer.view",
			icon = "city/main/icon_mxzz.png",
			name = gLanguageCsv.training,
			styles = {
				full = true
			},
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "cityTrainer",
					onNode = function(arg_6_0)
						arg_6_0:xy(152, 152)
					end
				}
			}
		},
		{
			icon = "city/main/icon_tf@.png",
			key = "talent",
			viewName = "city.develop.talent.view",
			bg = "city/panel_icon2.png",
			unlockKey = "talent",
			name = gLanguageCsv.talent,
			styles = {
				full = true
			},
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "cityTalent",
					onNode = function(arg_7_0)
						arg_7_0:xy(152, 152)
					end
				}
			}
		},
		{
			unlockKey = "explorer",
			key = "explore",
			viewName = "city.develop.explorer.view",
			icon = "city/main/icon_txq.png",
			name = gLanguageCsv.explorer,
			styles = {
				full = true
			},
			redHint = {
				class = "red_hint",
				props = {
					specialTag = {
						"explorerTotal",
						"explorerFind"
					},
					onNode = function(arg_8_0)
						arg_8_0:xy(152, 152)
					end
				}
			}
		},
		{
			key = "gem",
			unlockKey = "gem",
			viewName = "city.card.gem.view",
			icon = "city/card/gem/icon_fsxq1.png",
			name = gLanguageCsv.gemTitle,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "cityGemFreeExtract",
					onNode = function(arg_9_0)
						arg_9_0:xy(152, 152)
					end
				}
			}
		},
		{
			key = "gymBadge",
			unlockKey = "badge",
			viewName = "city.develop.gym_badge.view",
			icon = "city/develop/gym_badge/icon_hz.png",
			name = gLanguageCsv.badgeTitle,
			styles = {
				full = true
			}
		},
		{
			key = "zawake",
			unlockKey = "zawake",
			viewName = "city.zawake.view",
			icon = "city/zawake/icon_zjx11.png",
			name = gLanguageCsv.zawake,
			styles = {
				full = true
			},
			func = function(arg_10_0)
				local var_10_0 = require("app.views.city.zawake.tools").getFightPointMaxCard()

				if var_10_0 then
					arg_10_0({
						zawakeID = var_10_0
					})
				else
					gGameUI:showTip(gLanguageCsv.noZawakeCard)
				end
			end
		},
		{
			key = "chip",
			unlockKey = "chip",
			viewName = "city.card.chip.bag",
			icon = "city/card/chip/icon_chip.png",
			name = gLanguageCsv.chip,
			styles = {
				full = true
			},
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "cityChipFreeExtract",
					onNode = function(arg_11_0)
						arg_11_0:xy(152, 152)
					end
				}
			}
		},
		{
			key = "meteorite",
			unlockKey = "meteorite",
			viewName = "city.develop.strange_meteor.view",
			icon = "city/main/icon_zc_ys.png",
			name = gLanguageCsv.meteor,
			styles = {
				full = true
			},
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "meteorite",
					onNode = function(arg_12_0)
						arg_12_0.xy(arg_12_0, 150, 150)
					end
				}
			}
		}
	}
end

local function var_0_5()
	return {
		{
			key = "task",
			viewName = "city.task",
			icon = "city/main/icon_rw.png",
			name = gLanguageCsv.task,
			styles = {
				full = true
			},
			redHint = {
				class = "red_hint",
				props = {
					specialTag = {
						"cityTaskDaily",
						"cityTaskMain"
					}
				}
			}
		},
		{
			key = "achievement",
			unlockKey = "achievement",
			viewName = "city.achievement",
			icon = "city/main/icon_cj@.png",
			name = gLanguageCsv.achievement,
			styles = {
				full = true
			},
			redHint = {
				class = "red_hint",
				props = {
					specialTag = {
						"achievementTask",
						"achievementBox"
					}
				}
			}
		}
	}
end

function var_0_0.updateActionBtnsDatas(arg_14_0)
	local var_14_0 = {}

	for iter_14_0, iter_14_1 in ipairs(var_0_3()) do
		local var_14_1 = true

		if iter_14_1.unlockKey then
			var_14_1 = dataEasy.isShow(iter_14_1.unlockKey)
		end

		if var_14_1 then
			table.insert(var_14_0, iter_14_1)
		end
	end

	arg_14_0.actionBtns:update(var_14_0)
end

function var_0_0.setActionBtnsDatasIdler(arg_15_0)
	local var_15_0 = false

	for iter_15_0, iter_15_1 in ipairs(var_0_3()) do
		if iter_15_1.unlockKey then
			dataEasy.getListenShow(iter_15_1.unlockKey, function(arg_16_0)
				if var_15_0 then
					arg_15_0:updateActionBtnsDatas()
				end
			end)
		end
	end

	var_15_0 = true

	arg_15_0:updateActionBtnsDatas()
end

function var_0_0.initActionData(arg_17_0)
	arg_17_0.actionBtns = idlers.newWithMap({})
	arg_17_0.developBtns = idlertable.new({})

	local var_17_0 = {
		"title",
		"trainer",
		"talent",
		"explorer",
		"achievement",
		"gem",
		"mega",
		"badge",
		"zawake",
		"chip",
		"totem",
		"meteorite"
	}
	local var_17_1 = {}

	for iter_17_0, iter_17_1 in ipairs(var_17_0) do
		table.insert(var_17_1, dataEasy.getListenShow(iter_17_1))
	end

	arg_17_0:setActionBtnsDatasIdler()
	idlereasy.any(arraytools.merge({
		{
			arg_17_0.actionExpandName
		},
		var_17_1
	}), function(arg_18_0, arg_18_1, ...)
		local var_18_0 = {
			...
		}
		local var_18_1 = {}

		for iter_18_0, iter_18_1 in ipairs(var_17_0) do
			var_18_1[iter_18_1] = var_18_0[iter_18_0]
		end

		for iter_18_2, iter_18_3 in arg_17_0.developBtns:pairs() do
			if iter_18_3.unlockRes then
				iter_18_3.unlockRes:destroy()
			end
		end

		local var_18_2

		if arg_18_1 == "task" then
			var_18_2 = var_0_5()
		else
			var_18_2 = var_0_4()
		end

		for iter_18_4 = #var_18_2, 1, -1 do
			local var_18_3 = var_18_2[iter_18_4]

			if var_18_3.unlockKey then
				if not var_18_1[var_18_3.unlockKey] then
					table.remove(var_18_2, iter_18_4)
				elseif var_18_3.unlockKey == "totem" then
					var_18_3.specialLock = not dataEasy.isTotemUnlock()
				end
			end
		end

		local var_18_4 = math.max(4, math.ceil(#var_18_2 / 2))

		arg_17_0.developList.columnSize = var_18_4

		local var_18_5, var_18_6 = math.modf(#var_18_2 / var_18_4)

		arg_17_0.developBg:size(175 * (var_18_4 > #var_18_2 and #var_18_2 or var_18_4) + 25, 197 * (var_18_6 == 0 and var_18_5 or var_18_5 + 1))
		arg_17_0.developList:size(200 * var_18_4, 180 * (var_18_6 == 0 and var_18_5 or var_18_5 + 1))
		arg_17_0.listItem:size(200 * #var_18_2, 180)
		arg_17_0.developBg:y(117 + 103 * (var_18_6 == 0 and var_18_5 - 1 or var_18_5))
		arg_17_0.developList:xy(arg_17_0.developBg:x() - arg_17_0.developBg:size().width / 2 + 15, arg_17_0.developBg:y() + 10 + 90 * (var_18_6 == 0 and var_18_5 or var_18_5 + 1))
		arg_17_0.developBtns:set(var_18_2)

		for iter_18_5, iter_18_6 in arg_17_0.actionBtns:ipairs() do
			local var_18_7 = iter_18_6:proxy()

			if var_18_7.key == "task" then
				if not var_18_1.achievement then
					var_18_7.actionExpandName = nil

					break
				end

				var_18_7.actionExpandName = "task"

				break
			end
		end
	end)
	dataEasy.getListenUnlock(gUnlockCsv.dispatchTask, function(arg_19_0)
		if arg_19_0 == true then
			var_0_1.setRefreshTime(arg_17_0, nil, {
				tag = var_0_2.dispatchTaskRefresh,
				cb = function()
					gGameModel.forever_dispatch:getIdlerOrigin("dispatchTasksRedHintRefrseh"):modify(function(arg_21_0)
						return true, not arg_21_0
					end)
				end
			})
		end
	end)
end

return function(arg_22_0)
	for iter_22_0, iter_22_1 in pairs(var_0_0) do
		arg_22_0[iter_22_0] = iter_22_1
	end
end
