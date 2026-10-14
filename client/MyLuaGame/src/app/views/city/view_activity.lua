local var_0_0 = {}
local var_0_1 = require("app.views.city.activity.view")
local var_0_2 = require("app.views.city.online_gift")
local var_0_3 = require("easy.bind.helper")
local var_0_4 = require("app.easy.bind.helper.red_hint")
local var_0_5 = game.YYHUODONG_TYPE_ENUM_TABLE
local var_0_6 = 10000
local var_0_7 = {
	limitBuyGift = 5,
	onlineGift = 4
}
local var_0_8 = 12
local var_0_9 = 8

local function var_0_10()
	return true
end

local function var_0_11()
	return {
		{
			viewName = "city.activity.view",
			independentStyle = "award",
			icon = "city/main/icon_fl@.png",
			sortWeight = -11,
			styles = {
				full = true
			},
			func = function(arg_3_0)
				gGameApp:requestServer("/game/yy/active/get", function(arg_4_0)
					arg_3_0("award")
				end)
			end,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "totalActivityShow",
					listenData = {
						independent = 3
					}
				}
			}
		},
		{
			viewName = "city.activity.view",
			independentStyle = "main",
			icon = "city/main/icon_xshd.png",
			sortWeight = -10,
			styles = {
				full = true
			},
			func = function(arg_5_0)
				gGameApp:requestServer("/game/yy/active/get", function(arg_6_0)
					arg_5_0()
				end)
			end,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "totalActivityShow",
					listenData = {
						independent = 0
					}
				}
			}
		},
		{
			cityTheme = "anniversary",
			viewName = "city.activity.anniversary",
			icon = "city/main/icon_znq.png",
			sortWeight = -8,
			styles = {
				full = true
			},
			func = function(arg_7_0, arg_7_1)
				gGameApp:requestServer("/game/yy/active/get", function(arg_8_0)
					arg_7_0(arg_7_1)
				end)
			end
		},
		{
			cityTheme = "summerOffering",
			viewName = "city.activity.summer_offering",
			icon = "city/main/icon_xrj.png",
			sortWeight = -7,
			styles = {
				full = true
			},
			func = function(arg_9_0, arg_9_1)
				gGameApp:requestServer("/game/yy/active/get", function(arg_10_0)
					arg_9_0(arg_9_1)
				end)
			end
		}
	}
end

local function var_0_12(arg_11_0)
	local function var_11_0(arg_12_0)
		gGameApp:requestServer("/game/yy/active/get", function(arg_13_0)
			arg_12_0(arg_13_0)
		end)
	end

	return {
		[var_0_5.firstRecharge] = {
			viewName = "city.activity.first_recharge",
			sortWeight = -9,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "firstRecharge"
				}
			}
		},
		[var_0_5.serverOpen] = {
			viewName = "city.activity.server_open.view",
			func = var_11_0,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "serverOpen"
				}
			}
		},
		[var_0_5.levelFund] = {
			viewName = "city.activity.fund_gift",
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "activityLevelFund"
				}
			}
		},
		[var_0_5.upStarGift] = {
			viewName = "city.activity.upstargift",
			func = var_11_0,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "upstargift"
				}
			}
		},
		[var_0_5.fightRank] = {
			viewName = "city.activity.activity_fight_rank",
			func = function(arg_14_0, arg_14_1)
				gGameApp:requestServer("/game/yy/fightrank/get", function(arg_15_0)
					arg_14_0(arg_15_0)
				end, arg_14_1[1])
			end
		},
		[var_0_5.luckyCat] = {
			viewName = "city.activity.lucky_cat",
			func = var_11_0,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "luckyCat"
				}
			}
		},
		[var_0_5.rmbgoldReward] = {
			viewName = "city.activity.rmbgold_reward",
			func = var_11_0,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "rmbgoldReward"
				}
			}
		},
		[var_0_5.passport] = {
			viewName = "city.activity.passport.view",
			func = var_11_0,
			styles = {
				full = true
			},
			redHint = {
				class = "red_hint",
				props = {
					specialTag = {
						"passportCurrDay",
						"passportReward",
						"passportTask"
					}
				}
			}
		},
		[var_0_5.playPassport] = {
			viewName = "city.activity.passport.game_view",
			func = var_11_0,
			styles = {
				full = true
			},
			redHint = {
				class = "red_hint",
				props = {
					specialTag = {
						"playPassport"
					}
				}
			}
		},
		[var_0_5.timeLimitBox] = {
			viewName = "city.activity.limit_sprite",
			func = function(arg_16_0, arg_16_1)
				gGameApp:requestServer("/game/yy/limit/box/get", function(arg_17_0)
					arg_16_0(arg_17_0.view, arg_11_0:createHandler("onReFreshRedHint"))
				end, arg_16_1[1])
			end,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = {
						"limitSpritesHasFreeDrawCard",
						"limitSpritesHasBoxAward"
					},
					listenData = {
						refresh = bindHelper.self("redHintRefresh")
					},
					onNode = function(arg_18_0)
						arg_18_0:xy(156, 199)
					end
				}
			}
		},
		[var_0_5.loginWeal] = {
			viewName = "city.activity.recharge_feedback.new_player_welfare",
			func = var_11_0,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "loginWealRedHint"
				}
			}
		},
		[var_0_5.LoginGift] = {
			viewName = "city.activity.recharge_feedback.normal_view",
			icon = "city/main/icon_xshd.png",
			func = var_11_0,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "loginGiftRedHint"
				}
			}
		},
		[var_0_5.rechargeWheel] = {
			viewName = "city.activity.recharge_wheel",
			func = var_11_0,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = {
						"rechargeWheel",
						"rechargeWheelFree"
					}
				}
			}
		},
		[var_0_5.livenessWheel] = {
			viewName = "city.activity.liveness_wheel",
			func = var_11_0,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "livenessWheel"
				}
			}
		},
		[var_0_5.onceRechageAward] = {
			viewName = "city.activity.once_recharge_award",
			func = var_11_0,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "onceRechargeAward"
				}
			}
		},
		[var_0_5.limitBuyGift] = {
			tag = true,
			viewName = "city.activity.limit_buy_gift",
			func = var_11_0,
			timeLabelFunc = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				local var_19_0 = {}

				for iter_19_0, iter_19_1 in ipairs(arg_11_0.yyOpen:read()) do
					local var_19_1 = csv.yunying.yyhuodong[iter_19_1]

					if var_19_1.type == var_0_5.limitBuyGift then
						for iter_19_2, iter_19_3 in orderCsvPairs(csv.yunying.limitbuygift) do
							if iter_19_3.huodongID == var_19_1.huodongID and arg_19_1.valinfo[iter_19_2] and time.getTime() - arg_19_1.valinfo[iter_19_2].time < iter_19_3.duration * 60 then
								local var_19_2 = 1 - (arg_19_1.stamps[iter_19_2] or 1)

								if dataEasy.getPayClientBuyTimes("directBuyData", iter_19_1, iter_19_2, var_19_2) == 0 then
									table.insert(var_19_0, {
										startTime = arg_19_1.valinfo[iter_19_2].time,
										cfg = iter_19_3
									})
								end
							end
						end
					end
				end

				if #var_19_0 > 0 then
					if arg_19_3 then
						arg_11_0:setLimitBuyGiftCountTime(arg_19_3, var_19_0, arg_19_2)
					end

					return true
				end

				return false
			end
		},
		[var_0_5.festival] = {
			viewName = "city.activity.chinese_new_year",
			func = function(arg_20_0)
				gGameApp:requestServer("/game/yy/red/packet/list", function(arg_21_0)
					for iter_21_0, iter_21_1 in pairs(arg_21_0.view.packets) do
						iter_21_1.roleId = arg_11_0.id:read()
					end

					arg_20_0(clone(arg_21_0.view.packets))
				end)
			end,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "festivalRedHint"
				}
			}
		},
		[var_0_5.huodongCrossRedPacket] = {
			viewName = "city.activity.chinese_new_year",
			func = function(arg_22_0)
				gGameApp:requestServer("/game/yy/cross/red/packet/list", function(arg_23_0)
					for iter_23_0, iter_23_1 in pairs(arg_23_0.view.packets) do
						iter_23_1.roleId = arg_11_0.id:read()
					end

					arg_22_0(clone(arg_23_0.view.packets))
				end)
			end,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "crossFestivalRedHint"
				}
			}
		},
		[var_0_5.luckyEgg] = {
			viewName = "city.activity.recharge_feedback.activity_lucky_egg",
			styles = {
				full = true
			},
			func = var_11_0,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = {
						"luckyEggDrawCardFree"
					}
				}
			}
		},
		[var_0_5.directBuyGift] = {
			viewName = "city.activity.direct_buy_gift",
			styles = {
				full = true
			},
			func = var_11_0,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "activityDirectBuyGift"
				}
			}
		},
		[var_0_5.generalTask] = {
			viewName = "city.activity.first_recharge_daily",
			func = var_11_0,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "firstRechargeDaily"
				}
			}
		},
		[var_0_5.weeklyCard] = {
			viewName = "city.activity.view",
			styles = {
				full = true
			},
			func = function(arg_24_0, arg_24_1)
				gGameApp:requestServer("/game/yy/active/get", function(arg_25_0)
					arg_24_0("main")
				end)
			end,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "activityWeeklyCard"
				}
			}
		},
		[var_0_5.worldBoss] = {
			viewName = "city.activity.world_boss.view",
			styles = {
				full = true
			},
			func = function(arg_26_0, arg_26_1)
				gGameApp:requestServer("/game/yy/world/boss/main", function(arg_27_0)
					arg_26_0(arg_27_0)
				end, arg_26_1[1])
			end,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "activityWorldBoss"
				}
			}
		},
		[var_0_5.gemUp] = {
			tag = true,
			viewName = "city.activity.gem_up.view",
			func = var_11_0,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "gemUp"
				}
			}
		},
		[var_0_5.baoZongzi] = {
			tag = true,
			viewName = "city.activity.duan_wu_festival.view",
			func = var_11_0,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "zongZiActivity"
				}
			}
		},
		[var_0_5.qualityExchange] = {
			viewName = "city.activity.quality_exchange_fragment",
			func = var_11_0
		},
		[var_0_5.flipCard] = {
			tag = true,
			viewName = "city.activity.flip_card",
			func = var_11_0,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "flipCardActivity"
				}
			}
		},
		[var_0_5.huoDongBoss] = {
			viewName = "city.activity.activity_boss.view",
			styles = {
				full = true
			},
			func = function(arg_28_0)
				local var_28_0

				for iter_28_0, iter_28_1 in ipairs(arg_11_0.yyOpen:read()) do
					if csv.yunying.yyhuodong[iter_28_1].type == var_0_5.huoDongBoss then
						var_28_0 = iter_28_1

						break
					end
				end

				gGameApp:requestServer("/game/yy/huodongboss/list", function(arg_29_0)
					arg_28_0(arg_29_0)
				end, var_28_0, gCommonConfigCsv.huodongbossMaxNumber)
			end,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "activityBoss"
				}
			}
		},
		[var_0_5.reunion] = {
			viewName = "city.activity.reunion.view",
			styles = {
				full = true
			},
			func = function(arg_30_0)
				local var_30_0 = arg_11_0.reunion:read()

				if var_30_0.info.end_time - time.getTime() < 0 or var_30_0.role_type == 0 then
					arg_11_0.updateActivity:notify()
					gGameUI:showTip(gLanguageCsv.activityOver)

					return
				end

				local var_30_1 = gGameModel.reunion_record:read("bind_role_db_id")
				local var_30_2 = ""

				if var_30_0.role_type == 1 then
					var_30_2 = var_30_1 or ""
				elseif var_30_0.role_type == 2 then
					var_30_2 = var_30_0.info.role_id
				end

				if var_30_2 ~= "" then
					gGameApp:requestServer("/game/role_info", function(arg_31_0)
						local var_31_0 = arg_31_0.view
						local var_31_1 = {
							info = var_31_0
						}

						if var_30_0.role_type == 2 then
							gGameApp:requestServer("/game/yy/reunion/record/get", function(arg_32_0)
								var_31_1 = {
									info = var_31_0,
									reunionRecord = arg_32_0.view.reunion_record
								}

								if arg_30_0 then
									arg_30_0(var_31_1)
								end
							end, var_30_2)
						elseif arg_30_0 then
							arg_30_0(var_31_1)
						end
					end, var_30_2)
				else
					arg_30_0({})
				end
			end,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "reunionActivity"
				}
			}
		},
		[var_0_5.double11] = {
			viewName = "city.activity.double11.view",
			styles = {
				full = true
			},
			func = function(arg_33_0, arg_33_1)
				gGameApp:requestServer("/game/yy/double11/main", function(arg_34_0)
					arg_33_0(arg_34_0)
				end, arg_33_1[1])
			end,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "double11"
				}
			}
		},
		[var_0_5.snowBall] = {
			viewName = "city.activity.snow_ball.view",
			styles = {
				full = true
			},
			func = function(arg_35_0, arg_35_1)
				gGameApp:requestServer("/game/yy/snowball/main", function(arg_36_0)
					arg_35_0(arg_36_0)
				end, arg_35_1[1])
			end,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "snowBall"
				}
			}
		},
		[var_0_5.flipNewYear] = {
			tag = true,
			viewName = "city.activity.new_year_flip_card",
			func = var_11_0,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "flipNewYear"
				}
			}
		},
		[var_0_5.skyScraper] = {
			viewName = "city.activity.sky_scraper.view",
			styles = {
				full = true
			},
			func = var_11_0,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "skyScraper"
				}
			}
		},
		[var_0_5.gridWalk] = {
			viewName = "city.activity.grid_walk.view",
			styles = {
				full = true
			},
			func = function(arg_37_0, arg_37_1)
				gGameApp:requestServer("/game/yy/gridwalk/main", function(arg_38_0)
					cc.SpriteFrameCache:getInstance():addSpriteFrames("activity/grid_walk/gezi.plist")
					arg_37_0()
				end, arg_37_1[1])
			end,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "gridWalkMain"
				}
			}
		},
		[var_0_5.braveChallenge] = {
			viewName = "city.activity.brave_challenge.view",
			styles = {
				full = true
			},
			func = function(arg_39_0, arg_39_1)
				gGameApp:requestServer("/game/yy/brave_challenge/main", function(arg_40_0)
					arg_39_0(1)
				end, arg_39_1[1])
			end,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "braveChallengeAch",
					listenData = {
						sign = game.BRAVE_CHALLENGE_TYPE.anniversary
					}
				}
			}
		},
		[var_0_5.horseRace] = {
			viewName = "city.activity.horse_race.view",
			styles = {
				full = true
			},
			func = function(arg_41_0, arg_41_1)
				gGameApp:requestServer("/game/yy/horse/race/main", function(arg_42_0)
					arg_41_0(arg_42_0)
				end, arg_41_1[1])
			end,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "horseRaceMain"
				}
			}
		},
		[var_0_5.itemBuy2] = {
			viewName = "city.activity.coupon_shop",
			styles = {
				full = true
			},
			func = var_11_0
		},
		[var_0_5.exclusiveLimit] = {
			tag = true,
			viewName = "city.activity.exclusive_limit",
			func = var_11_0,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "exclusiveLimit"
				}
			}
		},
		[var_0_5.dispatch] = {
			viewName = "city.activity.dispatch.view",
			styles = {
				full = true
			},
			func = var_11_0,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "activityDispatch"
				}
			}
		},
		[var_0_5.summerChallenge] = {
			viewName = "city.activity.summer_challenge.view",
			styles = {
				full = true
			},
			func = var_11_0,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "summerChallenge"
				}
			}
		},
		[var_0_5.shavedIce] = {
			viewName = "city.activity.beach_ice.view",
			styles = {
				full = true
			},
			func = var_11_0,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "shavedIce"
				}
			}
		},
		[var_0_5.volleyball] = {
			viewName = "city.activity.volleyball.view",
			styles = {
				full = true
			},
			func = var_11_0,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "volleyball"
				}
			}
		},
		[var_0_5.midAutumnDraw] = {
			viewName = "city.activity.mid_autumn_draw",
			styles = {
				full = true
			},
			func = var_11_0,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "midAutumnDraw"
				}
			}
		},
		[var_0_5.customizeGift] = {
			viewName = "city.activity.customize_gift",
			styles = {
				full = false
			},
			func = var_11_0,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "customizeGift"
				}
			}
		}
	}
end

function var_0_0.initActivityData(arg_43_0)
	local var_43_0 = var_0_12(arg_43_0)
	local var_43_1 = var_0_11()

	arg_43_0.activityExpand = idler.new(false)
	arg_43_0.activityBtns = idlereasy.new({})
	arg_43_0.activityBtns2 = idlereasy.new({})
	arg_43_0.updateActivity = idler.new(0)

	idlereasy.any({
		arg_43_0.yyOpen,
		arg_43_0.yyhuodongs,
		arg_43_0.reunion,
		arg_43_0.updateActivity
	}, function(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
		arg_43_0:dropSate()
		arg_43_0:showMXIcon()

		local var_44_0 = {}
		local var_44_1 = {}
		local var_44_2 = {}
		local var_44_3 = {}
		local var_44_4 = {}
		local var_44_5 = {}
		local var_44_6 = {}
		local var_44_7 = {}

		for iter_44_0, iter_44_1 in ipairs(var_43_1) do
			if not iter_44_1.showTheme and not iter_44_1.cityTheme and (not iter_44_1.independentStyle or var_0_1.isDataExist(iter_44_1.independentStyle)) then
				table.insert(var_44_3, iter_44_1)

				if iter_44_1.redHint then
					local var_44_8 = iter_44_1.redHint.props

					if type(var_44_8.specialTag) == "string" then
						var_44_1 = arraytools.merge_inplace(var_44_1, {
							{
								var_44_8.specialTag
							}
						})
					else
						var_44_1 = arraytools.merge_inplace(var_44_1, {
							var_44_8.specialTag or {}
						})
					end

					var_44_2 = maptools.extend({
						var_44_2,
						var_44_8.listenData or {}
					})

					table.insert(var_44_0, {
						data = var_44_8
					})
				end
			end
		end

		local var_44_9 = {
			[var_0_5.firstRecharge] = false,
			[var_0_5.limitBuyGift] = false,
			[var_0_5.directBuyGift] = {
				double11 = false,
				noraml = false,
				mh = false
			},
			[var_0_5.levelFund] = false
		}

		for iter_44_2, iter_44_3 in ipairs(arg_44_1) do
			local var_44_10 = arg_44_2[iter_44_3] or {}
			local var_44_11 = csv.yunying.yyhuodong[iter_44_3]

			if (function()
				if var_44_11.type == var_0_5.directBuyGift then
					local var_45_0 = var_44_11.clientParam.double11 and "double11" or var_44_11.clientParam.mh and "mh" or "normal"

					if var_44_9[var_44_11.type][var_45_0] == true then
						return false
					end
				end

				if var_44_9[var_44_11.type] == true then
					return false
				end

				if not arg_43_0:isActivityShow(iter_44_3, var_44_10, var_43_0) then
					return false
				end

				return true
			end)() then
				if var_44_9[var_44_11.type] == false then
					var_44_9[var_44_11.type] = true
				end

				if var_44_11.type == var_0_5.directBuyGift then
					local var_44_12 = var_44_11.clientParam.double11 and "double11" or var_44_11.clientParam.mh and "mh" or "normal"

					var_44_9[var_44_11.type][var_44_12] = true
				end

				local var_44_13 = clone(var_43_0[var_44_11.type])

				if var_44_11.type == var_0_5.reunion then
					var_44_13.params = {}
				else
					var_44_13.params = {
						iter_44_3
					}
				end

				var_44_13.icon = var_44_11.icon
				var_44_13.sortWeight = var_44_11.sortWeight

				if var_44_11.type == var_0_5.luckyCat then
					if var_44_11.paramMap.type == "rmb" or var_44_11.paramMap.type == nil then
						var_44_13.viewName = "city.activity.lucky_cat"
					elseif var_44_11.paramMap.type == "gold" then
						var_44_13.viewName = "city.activity.gold_lucky_cat"
						var_44_13.redHint = {
							class = "red_hint",
							props = {
								specialTag = "goldLuckyCat"
							}
						}
					end
				end

				if var_44_11.type == var_0_5.directBuyGift then
					if var_44_11.clientParam.double11 then
						var_44_13.redHint = nil
						var_44_13.viewName = "city.activity.double11.shop"
					else
						var_44_13.viewName = "city.activity.direct_buy_gift"
					end
				end

				if var_44_11.type == var_0_5.itemBuy2 then
					if var_44_11.clientParam.cityTheme == "summerOffering" then
						var_44_13.viewName = "city.activity.summer_shop"
					else
						var_44_13.viewName = "city.activity.coupon_shop"
					end
				end

				if var_44_13.redHint then
					local var_44_14 = var_44_13.redHint.props

					var_44_14.listenData = maptools.extend({
						var_44_14.listenData or {},
						{
							activityId = iter_44_3
						}
					})

					if type(var_44_14.specialTag) == "string" then
						var_44_1 = arraytools.merge_inplace(var_44_1, {
							{
								var_44_14.specialTag
							}
						})
					else
						var_44_1 = arraytools.merge_inplace(var_44_1, {
							var_44_14.specialTag or {}
						})
					end

					var_44_2 = maptools.extend({
						var_44_2,
						var_44_14.listenData or {}
					})

					table.insert(var_44_0, {
						id = iter_44_3,
						data = var_44_14
					})
				end

				if var_44_11.type == var_0_5.LoginGift and var_44_11.clientParam.springFestival then
					var_44_13.viewName = "city.activity.recharge_feedback.spring_festival_view"
				end

				if var_44_11.type == var_0_5.serverOpen then
					if var_44_11.clientParam.type == "springFestival" then
						var_44_13.viewName = "city.activity.server_open.view_spring_festival"
					elseif var_44_11.clientParam.type == "mayDay" or var_44_11.clientParam.type == "vacation" or var_44_11.clientParam.type == "national" then
						var_44_13.viewName = "city.activity.server_open.view_may_day"
					elseif var_44_11.clientParam.type == "doubleYearsDay" then
						var_44_13.viewName = "city.activity.server_open.view_double_years_day"
					elseif var_44_11.clientParam.type == "anniversary" then
						var_44_13.viewName = "city.activity.server_open.view_anniversary"
					elseif var_44_11.clientParam.type == "threeday" then
						var_44_13.viewName = "city.activity.recharge_feedback.three_day_welfare"
					end
				end

				if var_44_11.type == var_0_5.playPassport and var_44_11.paramMap.type == 1 then
					var_44_13.viewName = "city.activity.passport.record_game_view"
					var_44_13.styles = nil
				end

				if var_44_11.type == var_0_5.horseRace then
					var_44_13.redHint = {
						class = "red_hint",
						props = {
							specialTag = "horseRaceMain",
							listenData = {
								activityId = iter_44_3,
								refresh = bindHelper.defer(function()
									return arg_43_0.redHintRefresh
								end)
							}
						}
					}
				end

				if var_44_13.tag and var_44_11.clientParam.showCountTime then
					var_44_13.endTime = arg_43_0.yy_endtime[iter_44_3]
					var_44_13.tag = var_0_6 + iter_44_3
				end

				var_44_13.id = iter_44_3
				var_44_13.independent = var_44_11.independent

				local var_44_15 = var_44_11.clientParam.cityTheme

				if var_44_15 then
					var_44_7[var_44_15] = var_44_7[var_44_15] or {}

					table.insert(var_44_7[var_44_15], var_44_13)
				elseif var_44_11.independent == 2 and itertools.size(var_44_6) < 4 then
					table.insert(var_44_6, var_44_13)
				else
					table.insert(var_44_3, var_44_13)
				end
			end
		end

		for iter_44_4, iter_44_5 in ipairs(var_43_1) do
			if iter_44_5.cityTheme and var_44_7[iter_44_5.cityTheme] then
				local var_44_16 = clone(iter_44_5)

				table.insert(var_44_3, var_44_16)

				var_44_16.params = {
					var_44_7[iter_44_5.cityTheme]
				}

				local var_44_17 = {}
				local var_44_18 = {}
				local var_44_19 = {}

				for iter_44_6, iter_44_7 in ipairs(var_44_7[iter_44_5.cityTheme]) do
					if iter_44_7.redHint then
						local var_44_20 = iter_44_7.redHint.props

						if type(var_44_20.specialTag) == "string" then
							var_44_18 = arraytools.merge_inplace(var_44_18, {
								{
									var_44_20.specialTag
								}
							})
						else
							var_44_18 = arraytools.merge_inplace(var_44_18, {
								var_44_20.specialTag or {}
							})
						end

						var_44_19 = maptools.extend({
							var_44_19,
							var_44_20.listenData or {}
						})

						table.insert(var_44_17, {
							data = var_44_20,
							id = iter_44_7.id
						})
					end
				end

				if not itertools.isempty(var_44_18) then
					var_44_16.redHint = {
						class = "red_hint",
						props = {
							specialTag = var_44_18,
							listenData = var_44_19,
							func = function(arg_47_0)
								local var_47_0 = gGameModel.role:read("yy_open")
								local var_47_1 = arraytools.hash(var_47_0)

								for iter_47_0, iter_47_1 in ipairs(var_44_17) do
									if var_47_1[iter_47_1.id] then
										for iter_47_2, iter_47_3 in pairs(iter_47_1.data.listenData or {}) do
											if not var_0_3.isHelper(iter_47_3) and not var_0_3.isIdler(iter_47_3) then
												arg_47_0[iter_47_2] = iter_47_3
											end
										end

										local var_47_2 = iter_47_1.data.specialTag

										if type(var_47_2) ~= "table" then
											var_47_2 = {
												var_47_2
											}
										end

										for iter_47_4, iter_47_5 in pairs(var_47_2) do
											if (var_0_4[iter_47_5] or var_0_10)(arg_47_0) then
												return true
											end
										end
									end
								end

								return false
							end
						}
					}
				end
			end
		end

		table.sort(var_44_6, function(arg_48_0, arg_48_1)
			if arg_48_0.sortWeight ~= arg_48_1.sortWeight then
				return arg_48_0.sortWeight < arg_48_1.sortWeight
			end

			return arg_48_0.id < arg_48_1.id
		end)
		table.sort(var_44_3, function(arg_49_0, arg_49_1)
			if arg_49_0.sortWeight ~= arg_49_1.sortWeight then
				return arg_49_0.sortWeight < arg_49_1.sortWeight
			end

			return arg_49_0.id < arg_49_1.id
		end)
		arg_43_0:resetShowList(arg_44_2, var_44_6)

		if itertools.size(var_44_3) + itertools.size(var_44_6) + 1 > var_0_9 then
			local var_44_21 = var_0_9 - (itertools.size(var_44_6) + 1)

			for iter_44_8 = 1, var_44_21 do
				table.insert(var_44_4, var_44_3[iter_44_8])
			end

			for iter_44_9 = var_44_21 + 1, itertools.size(var_44_3) do
				table.insert(var_44_5, var_44_3[iter_44_9])
			end
		else
			for iter_44_10 = 1, itertools.size(var_44_3) do
				table.insert(var_44_4, var_44_3[iter_44_10])
			end
		end

		arg_43_0.activityBtns:set(var_44_4)
		arg_43_0.activityBtns2:set(var_44_5)
		bind.extend(arg_43_0, arg_43_0.activityExpandBtn, {
			class = "red_hint",
			props = {
				state = bindHelper.self("activityExpand"),
				specialTag = var_44_1,
				listenData = maptools.extend({
					var_44_2,
					{
						activityId = id
					}
				}),
				func = function(arg_50_0)
					for iter_50_0, iter_50_1 in ipairs(var_44_0) do
						for iter_50_2, iter_50_3 in pairs(iter_50_1.data.listenData or {}) do
							if not var_0_3.isHelper(iter_50_3) and not var_0_3.isIdler(iter_50_3) then
								arg_50_0[iter_50_2] = iter_50_3
							end
						end

						local var_50_0 = iter_50_1.data.specialTag

						if type(var_50_0) ~= "table" then
							var_50_0 = {
								var_50_0
							}
						end

						for iter_50_4, iter_50_5 in pairs(var_50_0) do
							if (var_0_4[iter_50_5] or var_0_10)(arg_50_0) then
								return true
							end
						end
					end

					return false
				end,
				onNode = function(arg_51_0)
					arg_51_0:xy(45, 120)
				end
			}
		})
	end)
	arg_43_0.activityList:setItemsMargin(var_0_8)
	arg_43_0.activityList2:setItemsMargin(var_0_8)

	local var_43_2 = arg_43_0.item:size()
	local var_43_3 = arg_43_0.activityBtns:size()
	local var_43_4 = arg_43_0.activityBtns2:size()
	local var_43_5 = var_43_2.width * var_43_3 + var_0_8 * (var_43_3 - 1)
	local var_43_6 = var_43_2.width * var_43_4 + var_0_8 * (var_43_4 - 1)

	arg_43_0.activityList:x(var_43_5)
	arg_43_0.activityList2:x(var_43_6)

	local var_43_7 = true
	local var_43_8 = 1500

	local function var_43_9()
		local var_52_0 = arg_43_0.activityBtns:size()
		local var_52_1 = arg_43_0.activityPanel:width()
		local var_52_2 = arg_43_0.activityList:x()
		local var_52_3 = var_43_2.width * var_52_0 + var_0_8 * (var_52_0 - 1)

		arg_43_0.activityPanel:size(var_52_3, arg_43_0.activityPanel:height())
		arg_43_0.activityList:size(var_52_3, arg_43_0.activityList:height()):x(var_52_3 - var_52_1 + var_52_2)

		return var_52_3
	end

	local function var_43_10()
		local var_53_0 = arg_43_0.activityBtns2:size()
		local var_53_1 = arg_43_0.activityPanel2:width()
		local var_53_2 = arg_43_0.activityList2:x()
		local var_53_3 = var_43_2.width * var_53_0 + var_0_8 * (var_53_0 - 1)
		local var_53_4 = math.min(var_53_3, var_43_2.width * 10.5 + var_0_8 * 9)

		arg_43_0.activityPanel2:size(var_53_4, arg_43_0.activityPanel2:height())
		arg_43_0.activityList2:size(var_53_4, arg_43_0.activityList2:height()):x(var_53_4 - var_53_1 + var_53_2)

		return var_53_4
	end

	idlereasy.any({
		arg_43_0.activityBtns,
		arg_43_0.activityBtns2
	}, function()
		arg_43_0.activityExpand:notify()
	end)
	idlereasy.if_not(arg_43_0.activityExpand, function()
		var_43_9()
		var_43_10()

		local var_55_0 = math.abs(arg_43_0.activityList:x() - 0) / var_43_8
		local var_55_1 = math.abs(arg_43_0.activityList2:x() - 0) / var_43_8
		local var_55_2 = arg_43_0.activityPanel:x() - arg_43_0.activityPanel:width()

		arg_43_0.activityExpandBtn:setFlippedX(false)

		if var_43_7 then
			var_43_7 = false

			arg_43_0.activityList:x(0)
			arg_43_0.activityList2:x(0)
			arg_43_0.topShowList:xy(var_55_2, arg_43_0.activityPanel:y() + 10)
		else
			transition.executeSequence(arg_43_0.activityList, true):easeBegin("EXPONENTIALOUT"):moveTo(var_55_0, 0):easeEnd():done()
			transition.executeSequence(arg_43_0.activityList2, true):easeBegin("EXPONENTIALOUT"):moveTo(var_55_1, 0):easeEnd():done()
			transition.executeSequence(arg_43_0.topShowList, true):easeBegin("EXPONENTIALOUT"):moveTo(var_55_0, var_55_2):easeEnd():done()
		end
	end)
	idlereasy.if_(arg_43_0.activityExpand, function()
		local var_56_0 = var_43_9()
		local var_56_1 = var_43_10()
		local var_56_2 = math.abs(arg_43_0.activityList:x() - var_56_0) / var_43_8
		local var_56_3 = math.abs(arg_43_0.activityList2:x() - var_56_1) / var_43_8
		local var_56_4 = arg_43_0.activityPanel:x()

		arg_43_0.activityExpandBtn:setFlippedX(true)
		transition.executeSequence(arg_43_0.activityList, true):easeBegin("EXPONENTIALOUT"):moveTo(var_56_2, var_56_0):easeEnd():done()
		transition.executeSequence(arg_43_0.activityList2, true):easeBegin("EXPONENTIALOUT"):moveTo(var_56_3, var_56_1):easeEnd():done()
		transition.executeSequence(arg_43_0.topShowList, true):easeBegin("EXPONENTIALOUT"):moveTo(var_56_2, var_56_4):easeEnd():done()
	end)
	arg_43_0:initOnlineGift()
	arg_43_0:refreshHuodongBoss()
end

function var_0_0.isActivityShow(arg_57_0, arg_57_1, arg_57_2, arg_57_3)
	local var_57_0 = csv.yunying.yyhuodong[arg_57_1]

	if var_57_0.independent ~= 1 and var_57_0.independent ~= 2 and var_57_0.independent ~= 4 and var_57_0.independent ~= 5 then
		return false
	end

	if var_57_0.type == var_0_5.firstRecharge and arg_57_2.stamps and #arg_57_2.stamps == 9 then
		for iter_57_0, iter_57_1 in ipairs(arg_57_2.stamps) do
			if iter_57_1 ~= 2 then
				break
			end

			if iter_57_0 == #arg_57_2.stamps then
				return false
			end
		end
	end

	if var_57_0.type == var_0_5.serverOpen and var_57_0.clientParam.type == "threeday" and arg_57_2 and arg_57_2.info and arg_57_2.info.all == 0 then
		return false
	end

	if not arg_57_3[var_57_0.type] then
		local var_57_1 = itertools.map(var_0_5, function(arg_58_0, arg_58_1)
			return arg_58_1, arg_58_0
		end)

		printWarn("activityInfo 中没有支持 type(%d:%s) 的独立活动", var_57_0.type, var_57_1[var_57_0.type])

		return false
	end

	if var_57_0.type == var_0_5.generalTask and var_57_0.clientParam.type == "threeday" then
		-- block empty
	end

	if var_57_0.type == var_0_5.loginWeal then
		local var_57_2 = 0

		for iter_57_2, iter_57_3 in pairs(arg_57_2.stamps) do
			if iter_57_3 == 0 then
				var_57_2 = var_57_2 + 1
			end
		end

		local var_57_3 = var_57_2 < 7

		if var_57_3 and arg_57_0.autoNewPlayerWealId:read() == 0 then
			arg_57_0.autoNewPlayerWealId:set(arg_57_1)
		end

		return var_57_3
	end

	if var_57_0.type == var_0_5.reunion then
		local var_57_4 = arg_57_0.reunion:read()
		local var_57_5 = time.getTime()

		if var_57_4 and var_57_4.info and var_57_4.info.yyID == arg_57_1 and var_57_4.role_type ~= 0 and var_57_4.info.end_time - time.getTime() > 0 then
			return true
		end

		return false
	end

	if var_57_0.type == var_0_5.weeklyCard then
		if arg_57_2.buy == nil then
			local var_57_6, var_57_7 = time.getHourAndMin(var_57_0.beginTime)
			local var_57_8 = var_57_0.paramMap.buyDay

			if time.getNumTimestamp(var_57_0.beginDate, var_57_6, var_57_7) + var_57_8 * 24 * 60 * 60 - time.getTime() <= 0 then
				return false
			end
		else
			local var_57_9, var_57_10 = time.getHourAndMin(var_57_0.endTime)

			if time.getNumTimestamp(var_57_0.endDate, var_57_9, var_57_10) - time.getTime() <= 0 then
				return false
			end
		end

		return true
	end

	local var_57_11 = arg_57_3[var_57_0.type]

	if var_57_11.timeLabelFunc and not var_57_11.timeLabelFunc(arg_57_1, arg_57_2) then
		return false
	end

	return true
end

function var_0_0.dropSate(arg_59_0)
	local var_59_0, var_59_1, var_59_2 = dataEasy.isDoubleHuodong("gateDrop")
	local var_59_3 = csv.scene_conf

	if var_59_0 then
		var_59_0 = false

		for iter_59_0, iter_59_1 in pairs(var_59_1) do
			local var_59_4 = iter_59_1.start
			local var_59_5 = iter_59_1["end"]

			if var_59_3[var_59_4].gateType == game.GATE_TYPE.normal then
				var_59_0 = true

				break
			end
		end
	end

	if var_59_0 then
		if not arg_59_0.itemPve.spr then
			local var_59_6 = cc.Sprite:create("common/icon/double/label_sb.png")

			var_59_6:addTo(arg_59_0.itemPve, 1, "doubleImg"):xy(30, 230)

			arg_59_0.itemPve.spr = var_59_6
		end
	elseif arg_59_0.itemPve.spr then
		arg_59_0.itemPve:removeChildByName("doubleImg")

		arg_59_0.itemPve.spr = nil
	end
end

function var_0_0.showMXIcon(arg_60_0)
	local var_60_0, var_60_1 = dataEasy.isShowDailyActivityIcon()

	if var_60_0 then
		if arg_60_0.itemAdventure:getChildByName("_icon_") then
			return
		end

		local var_60_2 = ccui.Layout:create():size(arg_60_0.itemAdventure:size()):addTo(arg_60_0.itemAdventure, 1, "_icon_")
		local var_60_3 = var_60_1.paramMap

		ccui.ImageView:create(var_60_3.mxRes):xy(65, 220):addTo(var_60_2, 1, "_maozi_")

		local var_60_4 = ccui.ImageView:create(var_60_3.tipsRes):anchorPoint(0.9, 0):xy(35, 190):addTo(var_60_2, 2, "_tips_")
		local var_60_5 = cc.Sequence:create(cc.ScaleTo:create(0.3, 1.1), cc.ScaleTo:create(0.06, 0.95), cc.ScaleTo:create(0.03, 1), cc.DelayTime:create(2), cc.ScaleTo:create(0.1, 0.01), cc.DelayTime:create(1))
		local var_60_6 = cc.RepeatForever:create(var_60_5)

		var_60_4:runAction(var_60_6)
	else
		local var_60_7 = arg_60_0.itemAdventure:getChildByName("_icon_")

		if var_60_7 then
			var_60_7:removeFromParent()
		end
	end
end

function var_0_0.resetShowList(arg_61_0, arg_61_1, arg_61_2)
	for iter_61_0 = arg_61_0.topShowList:getChildrenCount(), 1, -1 do
		local var_61_0 = arg_61_0.topShowList:getItem(iter_61_0 - 1)

		if var_61_0:name() ~= "onlineGiftPanel" then
			var_61_0:removeFromParent()
		end
	end

	for iter_61_1, iter_61_2 in ipairs(arg_61_2) do
		local var_61_1 = arg_61_0.rightPanel:get("item"):clone():scaleX(-1)

		arg_61_0.topShowList:insertCustomItem(var_61_1, iter_61_1 - 1)

		local var_61_2 = var_61_1:get("labelTime")

		var_61_1:get("icon"):texture(iter_61_2.icon)
		text.addEffect(var_61_2, {
			outline = {
				size = 3,
				color = ui.NEWCOLORS.OUTLINE.BLACK
			}
		})

		if iter_61_2.endTime then
			if iter_61_2.timeLabelFunc then
				iter_61_2.timeLabelFunc(iter_61_2.id, arg_61_1[iter_61_2.id] or {}, nil, var_61_1)
			else
				var_0_0.setCountdown(arg_61_0, var_61_2, {
					endTime = iter_61_2.endTime,
					tag = iter_61_2.tag
				})
			end
		else
			var_61_2:hide()
		end

		if iter_61_2.redHint then
			bind.extend(arg_61_0, var_61_1, iter_61_2.redHint)
		end

		bind.touch(arg_61_0, var_61_1, {
			methods = {
				ended = functools.partial(arg_61_0.onItemClick, arg_61_0, nil, iter_61_2)
			}
		})
	end
end

function var_0_0.initOnlineGift(arg_62_0)
	arg_62_0.onlineGift = gGameModel.daily_record:getIdler("online_gift")
	arg_62_0.onlineGiftState = idler.new(1)

	local function var_62_0(arg_63_0)
		local var_63_0 = "onlineGiftPanel"
		local var_63_1 = arg_62_0.onlineGiftPanelItem

		if arg_63_0 and not arg_62_0.topShowList:getChildByName(var_63_0) then
			local var_63_2 = var_63_1:clone():show():name(var_63_0):scaleX(-1)

			bind.touch(arg_62_0.topShowList, var_63_2, {
				methods = {
					ended = function()
						arg_62_0:onOnlineGift()
					end
				}
			})

			local var_63_3 = arg_62_0.topShowList:getChildrenCount()

			arg_62_0.topShowList:insertCustomItem(var_63_2, var_63_3)

			arg_62_0.onlineGiftPanel = var_63_2
		elseif not arg_63_0 and arg_62_0.onlineGiftPanel then
			arg_62_0.onlineGiftPanel:removeFromParent()

			arg_62_0.onlineGiftPanel = nil
		end
	end

	idlereasy.any({
		arg_62_0.onlineGift,
		arg_62_0.level,
		dataEasy.getListenUnlock(gUnlockCsv.onlineGift)
	}, function(arg_65_0, arg_65_1, arg_65_2, arg_65_3)
		local var_65_0 = csvSize(csv.online_gift)

		arg_65_1.ids = arg_65_1.ids or {}

		local var_65_1 = #arg_65_1.ids

		if var_65_0 <= var_65_1 then
			var_62_0(false)

			return
		end

		if arg_65_3 then
			var_62_0(true)
		else
			return
		end

		if not arg_62_0.onlineGiftPanel then
			return
		end

		local var_65_2 = 1

		for iter_65_0, iter_65_1 in ipairs(csv.online_gift) do
			if iter_65_1.periods * 60 > (arg_65_1.totaltime or 0) then
				var_65_2 = iter_65_0

				break
			end
		end

		if var_65_1 < var_65_2 - 1 then
			arg_62_0.onlineGiftState:set(2, true)
		else
			arg_62_0.onlineGiftState:set(1, true)
			var_0_2.setCountdown(arg_62_0, arg_62_0.onlineGiftPanel:get("labelTime"), {
				data = arg_62_0.onlineGift:read(),
				tag = var_0_7.onlineGift,
				cb = function()
					arg_62_0.onlineGiftState:set(2, true)
				end
			})
		end
	end)
	idlereasy.when(arg_62_0.onlineGiftState, function(arg_67_0, arg_67_1)
		if not arg_62_0.onlineGiftPanel then
			return
		end

		arg_62_0.onlineGiftPanel:get("icon"):setVisible(arg_67_1 == 1)

		if arg_67_1 == 1 then
			text.addEffect(arg_62_0.onlineGiftPanel:get("labelTime"), {
				color = ui.COLORS.NORMAL.WHITE
			})
			text.addEffect(arg_62_0.onlineGiftPanel:get("labelTime"), {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			})

			local var_67_0 = arg_62_0.onlineGiftPanel:get("xiaohupa")

			if var_67_0 then
				var_67_0:removeSelf()
			end
		elseif arg_67_1 == 2 then
			text.addEffect(arg_62_0.onlineGiftPanel:get("labelTime"), {
				color = ui.COLORS.GREEN
			})
			text.addEffect(arg_62_0.onlineGiftPanel:get("labelTime"), {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			})
			arg_62_0.onlineGiftPanel:get("labelTime"):text(gLanguageCsv.onlineGiftGet)

			local var_67_1 = widget.addAnimationByKey(arg_62_0.onlineGiftPanel, "xiaohupa/xiaohupa.skel", "xiaohupa", "effect_loop", 99):anchorPoint(cc.p(0.5, 0.5)):scale(0.85):xy(arg_62_0.onlineGiftPanel:width() / 2, arg_62_0.onlineGiftPanel:height() / 2 - 8)
		end
	end)
end

function var_0_0.onOnlineGift(arg_68_0)
	local var_68_0 = {
		view = arg_68_0,
		uiTime = arg_68_0.onlineGiftPanel:get("labelTime"),
		tag = var_0_7.onlineGift,
		cb = function()
			return
		end
	}

	arg_68_0:stackUI("city.online_gift", nil, nil, var_68_0)
end

function var_0_0.setLimitBuyGiftCountTime(arg_70_0, arg_70_1, arg_70_2, arg_70_3)
	arg_70_0:enableSchedule():schedule(function()
		local var_71_0

		for iter_71_0, iter_71_1 in ipairs(arg_70_2) do
			local var_71_1 = iter_71_1.cfg.duration * 60 - (time.getTime() - iter_71_1.startTime)

			if var_71_1 > 0 then
				if not var_71_0 then
					var_71_0 = var_71_1
				elseif var_71_1 < var_71_0 then
					var_71_0 = var_71_1
				end
			end
		end

		if var_71_0 then
			local var_71_2 = time.getCutDown(var_71_0)
			local var_71_3 = var_71_2.str

			arg_70_1:get("labelTime"):text(var_71_3)
			arg_70_1:get("labelTime"):visible(var_71_2.day == 0)
		else
			if arg_70_3 then
				arg_70_3()
			end

			return false
		end
	end, 1, 0, var_0_7.limitBuyGift)
end

function var_0_0.refreshHuodongBoss(arg_72_0)
	local var_72_0 = userDefault.getForeverLocalKey("activityBossCount", 0)
	local var_72_1 = arg_72_0.yyhuodongs:read()
	local var_72_2

	for iter_72_0, iter_72_1 in ipairs(arg_72_0.yyOpen:read()) do
		if csv.yunying.yyhuodong[iter_72_1].type == var_0_5.huoDongBoss then
			var_72_2 = iter_72_1

			break
		end
	end

	if var_72_1[var_72_2] and var_72_1[var_72_2].info then
		local var_72_3 = var_72_1[var_72_2].info.huodong_boss_count

		if var_72_3 then
			userDefault.setForeverLocalKey("activityBossCount", var_72_3)

			return true
		end
	end
end

function var_0_0.setHorseRaceTimer(arg_73_0)
	local var_73_0 = csv.cross.horse_race.base[1].time
	local var_73_1 = tonumber(time.getTodayStr())
	local var_73_2 = 180
	local var_73_3 = {
		var_73_0[1] * 3600,
		var_73_0[2] * 3600 - var_73_2,
		var_73_0[3] * 3600,
		var_73_0[4] * 3600 - var_73_2
	}

	var_73_3[#var_73_3 + 1] = var_73_3[1] + 86400

	local var_73_4 = time.getNowDate()
	local var_73_5 = var_73_4.hour * 3600 + var_73_4.min * 60 + var_73_4.sec
	local var_73_6 = 1

	for iter_73_0 = 1, #var_73_3 do
		if var_73_5 < var_73_3[iter_73_0] then
			var_73_6 = var_73_3[iter_73_0] - var_73_5 + 1

			break
		end
	end

	performWithDelay(arg_73_0, function()
		arg_73_0:onReFreshRedHint()
	end, var_73_6)
end

return function(arg_75_0)
	for iter_75_0, iter_75_1 in pairs(var_0_0) do
		arg_75_0[iter_75_0] = iter_75_1
	end
end
