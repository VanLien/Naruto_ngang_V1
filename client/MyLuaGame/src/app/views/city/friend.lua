local var_0_0 = {
	BLACK_LIST = 4,
	ADD_FRIEND = 3,
	APPLY_FRIEND = 2,
	MY_FRIEND = 1
}
local var_0_1 = {
	"friendPanel",
	"applyPanel",
	"addPanel",
	"blackPanel"
}
local var_0_2 = {
	"battle_fighting_point",
	"last_time",
	"level"
}
local var_0_3 = {
	gLanguageCsv.whereMyFriend,
	gLanguageCsv.noOneApply,
	[4] = gLanguageCsv.blackListNull
}
local var_0_4 = {
	UNSHOW = 0,
	SHOW_SENIRO = 2,
	SHOW_REUNION = 1
}

local function var_0_5(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = time.getTime()
	local var_1_1 = arg_1_1:multiget("name", "level", "state", "power", "txt2")

	var_1_1.name:text(arg_1_3.name)
	arg_1_1:get("iconBg"):removeAllChildren()

	local var_1_2 = {
		event = "extend",
		class = "role_logo",
		props = {
			vip = false,
			level = false,
			logoId = arg_1_3.logo,
			frameId = arg_1_3.frame,
			onNode = function(arg_2_0)
				arg_2_0:z(6)
			end
		}
	}

	bind.extend(arg_1_0, arg_1_1:get("iconBg"), var_1_2)
	var_1_1.power:text(arg_1_3.battle_fighting_point)
	var_1_1.level:text(arg_1_3.level)

	if arg_1_4 then
		arg_1_1:get("bg"):visible(arg_1_3.select ~= true)
		arg_1_1:get("selected"):visible(arg_1_3.select == true)
	end

	arg_1_3.lastOnline = (var_1_0 - arg_1_3.last_time) / 60

	local var_1_3 = time.getCutDown(var_1_0 - arg_1_3.last_time, nil, true)

	if arg_1_3.lastOnline <= 10 then
		var_1_1.state:text(gLanguageCsv.onLine):setTextColor(cc.c4b(0, 170, 56, 255))
	else
		local var_1_4 = var_1_3.head_date_str

		var_1_1.state:text(gLanguageCsv.offLine .. var_1_4):setTextColor(cc.c4b(154, 151, 149, 255))
	end

	adapt.oneLinePos(var_1_1.name, {
		var_1_1.txt2
	}, cc.p(36, 0), "left")
	adapt.oneLinePos(var_1_1.txt2, {
		var_1_1.level
	}, cc.p(2, 0), "left")
end

local var_0_6 = cc.load("mvc").ViewBase
local var_0_7 = class("FriendView", Dialog)

var_0_7.RESOURCE_FILENAME = "friend.json"
var_0_7.RESOURCE_BINDING = {
	["leftPanel.panel.blackPanel"] = "blackPanel",
	["leftPanel.panel.addPanel"] = "addPanel",
	item2 = "item2",
	["leftPanel.panel.applyPanel"] = "applyPanel",
	["leftPanel.panel.duckPanel"] = "duckPanel",
	item1 = "item1",
	leftItem = "leftItem",
	["leftPanel.panel.addPanel.searchPanel.nameInput"] = "nameInput",
	["leftPanel.panel"] = "leftPanel",
	["leftPanel.panel.duckPanel.txt"] = "iconText",
	["leftPanel.panel.friendPanel"] = "friendPanel",
	rightPanel = "rightPanel",
	["rightPanel.figure"] = {
		binds = {
			event = "extend",
			class = "role_figure",
			props = {
				spine = true,
				data = bindHelper.self("figureId"),
				onSpine = function(arg_3_0)
					arg_3_0:scale(1.5):y(-140):x(408)
				end
			}
		}
	},
	["leftPanel.panel.textFriend"] = {
		varname = "textFriend",
		binds = {
			event = "text",
			idler = bindHelper.self("friendsNum"),
			method = function(arg_4_0)
				return string.format("%s %d/%d", gLanguageCsv.friendLimit, arg_4_0, game.FRIEND_LIMIT)
			end
		}
	},
	["leftPanel.panel.friendPanel.getNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("daily_record", "friend_stamina_gain"),
			method = function(arg_5_0)
				return string.format("%s %d/%d", gLanguageCsv.staminaAlreadyGet, arg_5_0, game.FRIEND_STAMINA_GET_TIMES)
			end
		}
	},
	["leftPanel.panel.topPanel"] = {
		varname = "topPanel",
		binds = {
			event = "extend",
			class = "sort_menus",
			props = {
				width = 330,
				height = 80,
				btnHeight = 90,
				btnType = 2,
				btnWidth = 270,
				data = bindHelper.self("sortTabData"),
				btnClick = bindHelper.self("onSortMenusBtnClick", true),
				showSelected = bindHelper.self("dropAttrTab"),
				onNode = function(arg_6_0)
					arg_6_0:xy(-150, -495):z(20)
				end
			}
		}
	},
	["leftPanel.panel.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["leftPanel.panel.applyPanel.btnRefuse"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAllRefuseClick")
			}
		}
	},
	["leftPanel.panel.applyPanel.btnRefuse.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["leftPanel.panel.applyPanel.btnAgree"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAllAcceptClick")
			}
		}
	},
	["leftPanel.panel.applyPanel.btnAgree.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["leftPanel.panel.addPanel.btnChange"] = {
		varname = "btnChange",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChangeClick")
			}
		}
	},
	["leftPanel.panel.addPanel.btnChange.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["leftPanel.panel.addPanel.btnAdd"] = {
		varname = "btnAllApply",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAllApplyClick")
			}
		}
	},
	["leftPanel.panel.addPanel.btnAdd.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["leftPanel.panel.friendPanel.btnGive"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSendClick")
			}
		}
	},
	["leftPanel.panel.friendPanel.btnGive.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["leftPanel.panel.friendPanel.btnGet"] = {
		varname = "btnGet",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onGetClick")
			}
		}
	},
	["leftPanel.panel.friendPanel.btnGet.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["rightPanel.btnDetail"] = {
		varname = "btnDetail",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDetailClick")
			}
		}
	},
	["rightPanel.btnDetail.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BROWN
				}
			}
		}
	},
	["rightPanel.btnDelete"] = {
		varname = "btnDelete",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDeleteClick")
			}
		}
	},
	["rightPanel.btnDelete.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BROWN
				}
			}
		}
	},
	["rightPanel.btnChat"] = {
		varname = "btnChat",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChatPrivateClick")
			}
		}
	},
	["rightPanel.btnChat.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BROWN
				}
			}
		}
	},
	["rightPanel.btnChallege"] = {
		varname = "btnChallenge",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChallengeClick")
			}
		}
	},
	["rightPanel.btnChallege.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BROWN
				}
			}
		}
	},
	["leftPanel.panel.applyPanel.list"] = {
		varname = "applyList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				dataOrderCmpGen = bindHelper.self("sortItem", true),
				data = bindHelper.self("showdata2"),
				item = bindHelper.self("item2"),
				itemAction = {
					isAction = true,
					alwaysShow = true
				},
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					local var_7_0 = arg_7_1:multiget("btnGet", "btnGive", "btnRefuse", "btnAgree", "selected", "reunionPanel")

					itertools.invoke({
						var_7_0.btnGet,
						var_7_0.btnGive,
						var_7_0.selected
					}, "hide")
					itertools.invoke({
						var_7_0.btnRefuse,
						var_7_0.btnAgree
					}, "show")
					var_0_5(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					bind.touch(arg_7_0, var_7_0.btnRefuse, {
						methods = {
							ended = functools.partial(arg_7_0.clickRefuse, arg_7_2)
						}
					})
					bind.touch(arg_7_0, var_7_0.btnAgree, {
						methods = {
							ended = functools.partial(arg_7_0.clickAccept, arg_7_2)
						}
					})
					arg_7_1:onClick(functools.partial(arg_7_0.clickHead, arg_7_2, arg_7_3, "apply"))
					var_7_0.reunionPanel:visible(arg_7_3.reunionType and arg_7_3.reunionType ~= var_0_4.UNSHOW or false)

					if arg_7_3.reunionType and arg_7_3.reunionType ~= var_0_4.UNSHOW then
						var_7_0.reunionPanel:get("label"):text(gLanguageCsv["reunionType" .. arg_7_3.reunionType])
					end
				end
			},
			handlers = {
				clickRefuse = bindHelper.self("onItemApplyRefuseClick"),
				clickAccept = bindHelper.self("onItemApplyAcceptClick"),
				clickHead = bindHelper.self("onHeadClick")
			}
		}
	},
	["leftPanel.panel.blackPanel.list"] = {
		varname = "blacklists",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				dataOrderCmpGen = bindHelper.self("sortItem", true),
				data = bindHelper.self("showdata4"),
				item = bindHelper.self("item1"),
				itemAction = {
					isAction = true,
					alwaysShow = true
				},
				onItem = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					local var_8_0 = arg_8_1:multiget("btnAdd", "imgApply", "btnBlack", "reunionPanel")

					var_8_0.btnAdd:hide()
					var_8_0.imgApply:hide()
					var_8_0.btnBlack:show()
					var_0_5(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					bind.touch(arg_8_0, var_8_0.btnBlack, {
						methods = {
							ended = functools.partial(arg_8_0.removeBlack, arg_8_2)
						}
					})
					var_8_0.reunionPanel:visible(arg_8_3.reunionType and arg_8_3.reunionType ~= var_0_4.UNSHOW or false)

					if arg_8_3.reunionType and arg_8_3.reunionType ~= var_0_4.UNSHOW then
						var_8_0.reunionPanel:get("label"):text(gLanguageCsv["reunionType" .. arg_8_3.reunionType])
					end
				end
			},
			handlers = {
				removeBlack = bindHelper.self("onRemoveBlackClick")
			}
		}
	},
	["leftPanel.panel.addPanel.list"] = {
		varname = "addList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				data = bindHelper.self("showdata3"),
				item = bindHelper.self("item1"),
				itemAction = {
					isAction = true,
					alwaysShow = true
				},
				onItem = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
					local var_9_0 = arg_9_1:multiget("btnAdd", "imgApply", "btnBlack", "reunionPanel")

					var_9_0.btnBlack:hide()
					var_9_0.imgApply:visible(arg_9_3.alreadyAdd == true)
					var_9_0.btnAdd:visible(arg_9_3.alreadyAdd ~= true)
					var_0_5(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
					bind.touch(arg_9_0, var_9_0.btnAdd, {
						methods = {
							ended = functools.partial(arg_9_0.clickAdd, arg_9_2)
						}
					})
					arg_9_1:onClick(functools.partial(arg_9_0.clickHead, arg_9_2, arg_9_3, ""))
					var_9_0.reunionPanel:visible(arg_9_3.reunionType and arg_9_3.reunionType ~= var_0_4.UNSHOW or false)

					if arg_9_3.reunionType and arg_9_3.reunionType ~= var_0_4.UNSHOW then
						var_9_0.reunionPanel:get("label"):text(gLanguageCsv["reunionType" .. arg_9_3.reunionType])
					end
				end
			},
			handlers = {
				clickAdd = bindHelper.self("onItemAddAddClick"),
				clickHead = bindHelper.self("onHeadClick")
			}
		}
	},
	["leftPanel.panel.addPanel.searchPanel.btnDelete"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSearchDeleteClick")
			}
		}
	},
	["leftPanel.panel.friendPanel.list"] = {
		varname = "friendsList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				dataOrderCmpGen = bindHelper.self("sortItem", true),
				data = bindHelper.self("showdata1"),
				item = bindHelper.self("item2"),
				preloadCenter = bindHelper.self("myShowFriend"),
				itemAction = {
					isAction = true,
					alwaysShow = true
				},
				onItem = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
					var_0_5(arg_10_0, arg_10_1, arg_10_2, arg_10_3, true)

					local var_10_0 = arg_10_1:multiget("btnGet", "btnGive", "btnRefuse", "btnAgree", "selected", "reunionPanel")

					itertools.invoke({
						var_10_0.btnRefuse,
						var_10_0.btnAgree
					}, "hide")
					itertools.invoke({
						var_10_0.btnGet,
						var_10_0.btnGive
					}, "show")
					bind.touch(arg_10_0, var_10_0.btnGet, {
						methods = {
							ended = functools.partial(arg_10_0.clickGet, arg_10_2)
						}
					})
					bind.touch(arg_10_0, var_10_0.btnGive, {
						methods = {
							ended = functools.partial(arg_10_0.clickGive, arg_10_2)
						}
					})
					bind.touch(arg_10_0, arg_10_1, {
						methods = {
							ended = functools.partial(arg_10_0.clickFriend, arg_10_2)
						}
					})
					var_10_0.btnGet:visible(arg_10_3.canGet == true)
					var_10_0.btnGive:visible(arg_10_3.hasGive ~= true)
					var_10_0.reunionPanel:visible(arg_10_3.reunionType and arg_10_3.reunionType ~= var_0_4.UNSHOW or false)

					if arg_10_3.reunionType and arg_10_3.reunionType ~= var_0_4.UNSHOW then
						var_10_0.reunionPanel:get("label"):text(gLanguageCsv["reunionType" .. arg_10_3.reunionType])
					end
				end
			},
			handlers = {
				clickGet = bindHelper.self("onItemFriendGetClick"),
				clickGive = bindHelper.self("onItemFriendGiveClick"),
				clickFriend = bindHelper.self("onItemFriendClick")
			}
		}
	},
	["leftPanel.panel.addPanel.searchPanel.btnSearch"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSearchClick")
			}
		}
	},
	["leftPanel.panel.leftList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				padding = 5,
				data = bindHelper.self("btnsAttr"),
				item = bindHelper.self("leftItem"),
				onItem = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
					local var_11_0 = arg_11_1:get("normal")
					local var_11_1 = arg_11_1:get("selected")

					if arg_11_2 < 3 then
						local var_11_2 = {
							class = "red_hint",
							props = {
								state = arg_11_3.select ~= true,
								specialTag = arg_11_2 == 1 and "friendStaminaRecv" or "friendReqs",
								onNode = function(arg_12_0)
									arg_12_0:xy(56, 265):scale(0.6)
								end
							}
						}

						bind.extend(arg_11_0, var_11_0, var_11_2)
					end

					local var_11_3

					if arg_11_3.select then
						var_11_0:hide()

						var_11_3 = var_11_1:show()

						text.addEffect(var_11_3:get("txt"), {
							outline = {
								size = 1,
								color = ui.NEWCOLORS.OUTLINE.WHITE
							}
						})
					else
						var_11_1:hide()

						var_11_3 = var_11_0:show()
					end

					local var_11_4 = var_11_3:size().height - 20

					adapt.setAutoMultiLine(var_11_3:get("txt"), arg_11_3.name, var_11_4, -5)
					var_11_1:setTouchEnabled(false)
					bind.touch(arg_11_0, var_11_0, {
						methods = {
							ended = functools.partial(arg_11_0.clickCell, arg_11_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onLeftButtonClick")
			}
		}
	}
}

function var_0_7.onCleanup(arg_13_0)
	arg_13_0._showType = arg_13_0.leftButtonTab:read()
	arg_13_0._myShowFriend = arg_13_0.myShowFriend:read()
	arg_13_0._dropAttrTab = arg_13_0.dropAttrTab:read()
	arg_13_0._btnSelectAscOrder = arg_13_0.btnSelectAscOrder:read()
	arg_13_0._data = arg_13_0.datas[arg_13_0._showType]

	var_0_6.onCleanup(arg_13_0)
end

function var_0_7.onCreate(arg_14_0, arg_14_1, arg_14_2)
	arg_14_1 = arg_14_0._showType or arg_14_1

	arg_14_0:initModel()

	arg_14_0.originX = arg_14_0.leftPanel:x()

	arg_14_0.nameInput:setPlaceHolderColor(ui.NEWCOLORS.GRAY3)
	arg_14_0.nameInput:setTextColor(ui.NEWCOLORS.BROWN1)

	arg_14_0.figureId = idler.new()
	arg_14_0.showdata1 = idlers.newWithMap({})
	arg_14_0.showdata2 = idlers.newWithMap({})
	arg_14_0.showdata3 = idlers.newWithMap({})
	arg_14_0.showdata4 = idlers.newWithMap({})

	local var_14_0 = {
		{
			enter = false,
			name = gLanguageCsv.myFriend
		},
		{
			enter = false,
			name = gLanguageCsv.friendApply
		},
		{
			enter = false,
			name = gLanguageCsv.addFriend
		},
		{
			enter = false,
			name = gLanguageCsv.blackList
		}
	}

	var_14_0[arg_14_1].enter = true
	arg_14_0.btnsAttr = idlers.newWithMap(var_14_0)
	arg_14_0.dropAttrTab = idler.new(arg_14_0._dropAttrTab or 1)
	arg_14_0.sortTabData = idlertable.new({
		gLanguageCsv.fighting,
		gLanguageCsv.lastOnline,
		gLanguageCsv.level
	})
	arg_14_0.datas = {}
	arg_14_0.friendsNum = idler.new(itertools.size(arg_14_0.myFriend:read()))
	arg_14_0.resort = idler.new(false)
	arg_14_0.searchState = idler.new(false)
	arg_14_0.btnSelectAscOrder = idler.new(arg_14_0._btnSelectAscOrder or false)

	idlereasy.when(arg_14_0.btnSelectAscOrder, function(arg_15_0, arg_15_1)
		return
	end)

	arg_14_0.myShowFriend = idler.new(0)
	arg_14_0.leftButtonTab = idler.new(arg_14_1)

	arg_14_0:composeData(arg_14_1, arg_14_0._data or arg_14_2)

	arg_14_0.firstEnter = true

	arg_14_0:changeTab(arg_14_1)
	arg_14_0.leftButtonTab:addListener(function(arg_16_0, arg_16_1, arg_16_2)
		arg_14_0.btnsAttr:atproxy(arg_16_1).select = false
		arg_14_0.btnsAttr:atproxy(arg_16_0).select = true

		arg_14_0.myShowFriend:set(0)

		if not arg_14_0.btnsAttr:atproxy(arg_16_0).enter then
			arg_14_0:changeTab(arg_16_0)

			arg_14_0.btnsAttr:atproxy(arg_16_0).enter = true
		else
			arg_14_0:changeTagShow(arg_16_0)

			if arg_16_0 ~= var_0_0.ADD_FRIEND then
				arg_14_0.resort:set(true, true)
			end
		end
	end)
	arg_14_0.myShowFriend:addListener(function(arg_17_0, arg_17_1, arg_17_2)
		if arg_17_1 ~= 0 and arg_14_0.showdata1:atproxy(arg_17_1) then
			arg_14_0.showdata1:atproxy(arg_17_1).select = false
		end

		if arg_17_0 ~= 0 and arg_14_0.showdata1:atproxy(arg_17_0) then
			arg_14_0.showdata1:atproxy(arg_17_0).select = true

			local var_17_0 = arg_14_0.showdata1:atproxy(arg_17_0)

			arg_14_0.figureId:set(var_17_0.figure)
			arg_14_0.rightPanel:show()
			arg_14_0.leftPanel:x(arg_14_0.originX - 395)
		else
			arg_14_0.rightPanel:hide()
			arg_14_0.leftPanel:x(arg_14_0.originX)
		end
	end)

	local var_14_1 = idlereasyArgs.new(arg_14_0, "dropAttrTab", "btnSelectAscOrder")

	idlereasy.any(var_14_1, function(...)
		arg_14_0.resort:set(true, true)
	end)
	idlerflow.if_(arg_14_0.resort):do_(function(arg_19_0)
		if arg_14_0.leftButtonTab:read() == var_0_0.MY_FRIEND then
			dataEasy.tryCallFunc(arg_14_0.friendsList, "filterSortItems", false)
		elseif arg_14_0.leftButtonTab:read() == var_0_0.APPLY_FRIEND then
			dataEasy.tryCallFunc(arg_14_0.applyList, "filterSortItems", false)
		elseif arg_14_0.leftButtonTab:read() == var_0_0.BLACK_LIST then
			dataEasy.tryCallFunc(arg_14_0.blacklists, "filterSortItems", false)
		end

		arg_14_0:onResetRightPanel()
	end, var_14_1)
	arg_14_0.myShowFriend:set(arg_14_0._myShowFriend or 0)
	Dialog.onCreate(arg_14_0)
end

function var_0_7.changeTagShow(arg_20_0, arg_20_1)
	arg_20_0.friendPanel:visible(arg_20_1 == var_0_0.MY_FRIEND)
	arg_20_0.applyPanel:visible(arg_20_1 == var_0_0.APPLY_FRIEND)
	arg_20_0.addPanel:visible(arg_20_1 == var_0_0.ADD_FRIEND)
	arg_20_0.topPanel:visible(arg_20_1 ~= var_0_0.ADD_FRIEND)
	arg_20_0.blackPanel:visible(arg_20_1 == var_0_0.BLACK_LIST)
	arg_20_0.textFriend:visible(arg_20_1 ~= var_0_0.BLACK_LIST)
	arg_20_0.rightPanel:hide()
	arg_20_0.leftPanel:x(arg_20_0.originX)
	idlereasy.do_(function(arg_21_0, arg_21_1, arg_21_2)
		local var_21_0 = arg_20_1 == 1 and #arg_21_0 == 0 or arg_20_1 == 2 and #arg_21_1 == 0 or arg_20_1 == 4 and #arg_21_2 == 0

		if arg_20_1 ~= var_0_0.ADD_FRIEND and var_21_0 then
			arg_20_0.duckPanel:visible(var_21_0)
			arg_20_0.iconText:text(var_0_3[arg_20_1])
			itertools.invoke({
				arg_20_0[var_0_1[arg_20_1]],
				arg_20_0.textFriend,
				arg_20_0.topPanel
			}, "hide")
		else
			arg_20_0.duckPanel:hide()
		end
	end, arg_20_0.myFriend, arg_20_0.friendApply, arg_20_0.blackList)
end

function var_0_7.getReunionType(arg_22_0, arg_22_1)
	local var_22_0 = var_0_4.UNSHOW

	if arg_22_0.reunion and arg_22_0.reunion.role_type == 1 and arg_22_0.reunion.info and arg_22_0.reunion.info.end_time - time.getTime() > 0 and arg_22_0.reunionBindRoleId and arg_22_0.reunionBindRoleId == arg_22_1 then
		var_22_0 = var_0_4.SHOW_SENIRO
	elseif arg_22_0.reunion and arg_22_0.reunion.role_type == 2 and arg_22_0.reunion.info and arg_22_0.reunion.info.end_time - time.getTime() > 0 and arg_22_0.reunion.info.role_id == arg_22_1 then
		var_22_0 = var_0_4.SHOW_REUNION
	end

	return var_22_0
end

function var_0_7.composeData(arg_23_0, arg_23_1, arg_23_2)
	arg_23_2 = arg_23_2 or arg_23_0.datas[arg_23_1]

	for iter_23_0, iter_23_1 in ipairs(arg_23_2) do
		arg_23_2[iter_23_0].reunionType = arg_23_0:getReunionType(iter_23_1.id)
	end

	if arg_23_1 == var_0_0.MY_FRIEND then
		idlereasy.do_(function(arg_24_0, arg_24_1)
			arg_23_0.showdata1:update(arg_23_2)

			local var_24_0 = arraytools.hash(arg_24_0)
			local var_24_1 = arraytools.hash(arg_24_1)

			for iter_24_0, iter_24_1 in ipairs(arg_23_2) do
				arg_23_0.showdata1:atproxy(iter_24_0).canGet = var_24_0[iter_24_1.id]
				arg_23_2[iter_24_0].canGet = var_24_0[iter_24_1.id]
				arg_23_0.showdata1:atproxy(iter_24_0).hasGive = var_24_1[iter_24_1.id]
				arg_23_2[iter_24_0].hasGive = var_24_1[iter_24_1.id]
			end

			arg_23_0.datas[var_0_0.MY_FRIEND] = arg_23_2

			arg_23_0.friendsNum:set(#arg_23_2)
			arg_23_0.resort:set(true, true)
		end, arg_23_0.staminaGet, arg_23_0.sendCount)
	elseif arg_23_1 == var_0_0.APPLY_FRIEND then
		arg_23_0.datas[var_0_0.APPLY_FRIEND] = arg_23_2

		arg_23_0.showdata2:update(arg_23_2)
		arg_23_0.resort:set(true, true)
	elseif arg_23_1 == var_0_0.ADD_FRIEND then
		arg_23_0.datas[var_0_0.ADD_FRIEND] = arg_23_2

		local var_23_0 = userDefault.getCurrDayKey("friendsAddState", {})

		for iter_23_2, iter_23_3 in ipairs(arg_23_2) do
			iter_23_3.alreadyAdd = var_23_0[stringz.bintohex(iter_23_3.id)] ~= nil and var_23_0[stringz.bintohex(iter_23_3.id)]
		end

		arg_23_0.showdata3:update(arg_23_2)
	else
		arg_23_0.datas[var_0_0.BLACK_LIST] = arg_23_2

		arg_23_0.showdata4:update(arg_23_2)
		arg_23_0.resort:set(true, true)
	end

	arg_23_0:changeTagShow(arg_23_0.leftButtonTab:read())
end

function var_0_7.initModel(arg_25_0)
	arg_25_0.myFriend = gGameModel.society:getIdler("friends")
	arg_25_0.friendApply = gGameModel.society:getIdler("friend_reqs")
	arg_25_0.staminaGet = gGameModel.society:getIdler("stamina_recv")
	arg_25_0.staminaCount = gGameModel.daily_record:getIdler("friend_stamina_gain")
	arg_25_0.sendCount = gGameModel.daily_record:getIdler("friend_stamina_send")
	arg_25_0.id = gGameModel.role:getIdler("id")
	arg_25_0.stamina = gGameModel.role:getIdler("stamina")
	arg_25_0.blackList = gGameModel.society:getIdler("black_list")
	arg_25_0.reunion = gGameModel.role:read("reunion")
	arg_25_0.reunionBindRoleId = gGameModel.reunion_record:read("bind_role_db_id")
end

function var_0_7.changeTab(arg_26_0, arg_26_1)
	if arg_26_1 == var_0_0.MY_FRIEND then
		idlereasy.when(arg_26_0.myFriend, function(arg_27_0, arg_27_1)
			if not arg_26_0.firstEnter then
				arg_26_0:sendProtocolCountDown(var_0_0.MY_FRIEND, arg_27_1)
			end

			arg_26_0.friendsNum:set(itertools.size(arg_27_1))

			arg_26_0.firstEnter = false
		end):anonyOnly(arg_26_0)
	elseif arg_26_1 == var_0_0.APPLY_FRIEND then
		idlereasy.when(arg_26_0.friendApply, function(arg_28_0, arg_28_1)
			if not arg_26_0.firstEnter then
				arg_26_0:sendProtocolCountDown(var_0_0.APPLY_FRIEND, arg_28_1)
			end

			arg_26_0.firstEnter = false
		end):anonyOnly(arg_26_0)
	elseif arg_26_1 == var_0_0.ADD_FRIEND then
		if not arg_26_0.btnsAttr:atproxy(arg_26_1).enter then
			if not arg_26_0.firstEnter then
				arg_26_0:sendProtocolCountDown(var_0_0.ADD_FRIEND, val)
			end

			arg_26_0.btnsAttr:atproxy(arg_26_1).enter = true
		end

		arg_26_0.firstEnter = false
	else
		idlereasy.when(arg_26_0.blackList, function(arg_29_0, arg_29_1)
			if not arg_26_0.firstEnter then
				arg_26_0:sendProtocolCountDown(var_0_0.BLACK_LIST, arg_29_1)
			end

			arg_26_0.firstEnter = false
		end):anonyOnly(arg_26_0)
	end
end

function var_0_7.sendProtocolCountDown(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	arg_30_3 = arg_30_3 or function(arg_31_0, arg_31_1)
		arg_30_0:composeData(arg_31_0, arg_31_1)
	end

	var_0_7.sendProtocol(arg_30_1, arg_30_2, arg_30_3)
end

function var_0_7.onAllRefuseClick(arg_32_0)
	idlereasy.do_(function(arg_33_0)
		if #arg_33_0 ~= 0 then
			gGameApp:requestServer("/game/society/friend/reject", function(arg_34_0)
				arg_32_0:composeData(var_0_0.APPLY_FRIEND, {})
				gGameUI:showTip(gLanguageCsv.refuseFriendApply)
			end, nil, true)
		end
	end, arg_32_0.friendApply)
end

function var_0_7.onAllAcceptClick(arg_35_0)
	idlereasy.do_(function(arg_36_0, arg_36_1)
		if #arg_36_0 == game.FRIEND_LIMIT then
			gGameUI:showTip(gLanguageCsv.friendMax)
		elseif #arg_36_1 == 0 then
			gGameUI:showTip(gLanguageCsv.currNoFriendApply)
		else
			gGameApp:requestServer("/game/society/friend/accept", function(arg_37_0)
				if arg_37_0.view and arg_37_0.view.refuseFlag then
					gGameUI:showTip(gLanguageCsv.addSuccessRefuseOther)
				else
					gGameUI:showTip(gLanguageCsv.addFriendSuccessful)
				end
			end, nil, true)
		end
	end, arg_35_0.myFriend, arg_35_0.friendApply)
end

function var_0_7.onChangeClick(arg_38_0)
	gGameApp:requestServer("/game/society/friend/list", function(arg_39_0)
		arg_38_0.searchState:set(false)
		arg_38_0:composeData(var_0_0.ADD_FRIEND, arg_39_0.view.roles)
	end)
end

function var_0_7.onAllApplyClick(arg_40_0)
	idlereasy.do_(function(arg_41_0)
		if #arg_41_0 == game.FRIEND_LIMIT then
			gGameUI:showTip(gLanguageCsv.addFriendLimit)
		else
			local var_41_0 = {}
			local var_41_1 = {}

			for iter_41_0 = 1, arg_40_0.showdata3:size() do
				local var_41_2 = arg_40_0.showdata3:atproxy(iter_41_0)

				table.insert(var_41_0, var_41_2.id)

				var_41_2.alreadyAdd = true
				var_41_1[stringz.bintohex(var_41_2.id)] = true
			end

			gGameApp:requestServer("/game/society/friend/askfor", function(arg_42_0)
				userDefault.setCurrDayKey("friendsAddState", var_41_1)
				gGameUI:showTip(gLanguageCsv.addFriendWait)
			end, var_41_0)
		end
	end, arg_40_0.myFriend)
end

function var_0_7.onSendClick(arg_43_0)
	idlereasy.do_(function(arg_44_0, arg_44_1)
		if #arg_44_0 == #arg_44_1 then
			gGameUI:showTip(gLanguageCsv.noFriendCanGive)
		else
			gGameApp:requestServer("/game/society/friend/stamina/send", function(arg_45_0)
				arg_43_0:composeData(var_0_0.MY_FRIEND)
				gGameUI:showTip(gLanguageCsv.staminaSendSucceful)
			end, nil, true)
		end
	end, arg_43_0.myFriend, arg_43_0.sendCount)
end

function var_0_7.onGetClick(arg_46_0)
	idlereasy.do_(function(arg_47_0, arg_47_1, arg_47_2, arg_47_3)
		if #arg_47_0 == arg_47_1 or #arg_47_2 == 0 then
			gGameUI:showTip(gLanguageCsv.noStaminaCanGet)
		elseif arg_47_1 == game.FRIEND_STAMINA_GET_TIMES then
			gGameUI:showTip(gLanguageCsv.friendStaminaRecvMax)
		elseif arg_47_3 < game.STAMINA_LIMIT then
			gGameApp:requestServer("/game/society/friend/stamina/recv", function(arg_48_0)
				arg_46_0:composeData(var_0_0.MY_FRIEND)
				gGameUI:showTip(gLanguageCsv.staminaGetSuccessful)
			end, nil, true)
		else
			gGameUI:showTip(gLanguageCsv.staminaToLimit)
		end
	end, arg_46_0.myFriend, arg_46_0.staminaCount, arg_46_0.staminaGet, arg_46_0.stamina)
end

function var_0_7.onDetailClick(arg_49_0)
	local var_49_0 = arg_49_0.showdata1:atproxy(arg_49_0.myShowFriend)

	gGameApp:requestServer("/game/role_info", function(arg_50_0)
		gGameUI:stackUI("city.personal.other", nil, nil, arg_50_0.view)
	end, var_49_0.id)
end

function var_0_7.onChatPrivateClick(arg_51_0)
	local var_51_0 = arg_51_0.showdata1:atproxy(arg_51_0.myShowFriend)
	local var_51_1 = {
		isMine = false,
		role = {
			level = var_51_0.level,
			id = var_51_0.id,
			logo = var_51_0.logo,
			name = var_51_0.name,
			vip = var_51_0.vip_level,
			frame = var_51_0.frame
		},
		time = var_51_0.last_time
	}

	gGameUI:stackUI("city.chat.privataly", nil, nil, var_51_1)
end

function var_0_7.onChallengeClick(arg_52_0)
	local var_52_0 = arg_52_0.showdata1:atproxy(arg_52_0.myShowFriend)

	gGameApp:requestServer("/game/society/friend/search", function(arg_53_0)
		local var_53_0 = arg_53_0.view.roles[1]

		if var_53_0 and var_53_0.pvp_record_db_id then
			gGameUI:stackUI("city.card.embattle.base", nil, {
				full = true
			}, {
				fightCb = arg_52_0:createHandler("startFighting", var_53_0.pvp_record_db_id)
			})
		else
			gGameUI:showTip(gLanguageCsv.friendCannotFight)
		end
	end, var_52_0.id)
end

function var_0_7.onResetRightPanel(arg_54_0)
	arg_54_0.myShowFriend:set(0)
end

function var_0_7.onDeleteClick(arg_55_0)
	local var_55_0 = arg_55_0.showdata1:atproxy(arg_55_0.myShowFriend)

	gGameUI:showDialog({
		isRich = true,
		btnType = 2,
		strs = {
			string.format(gLanguageCsv.removeSelectFriend1, var_55_0.name)
		},
		cb = function()
			gGameApp:requestServer("/game/society/friend/delete", function(arg_57_0)
				arg_55_0:onResetRightPanel()
			end, var_55_0.id)
		end
	})
end

function var_0_7.onItemApplyRefuseClick(arg_58_0, arg_58_1, arg_58_2, arg_58_3)
	gGameApp:requestServer("/game/society/friend/reject", function(arg_59_0)
		table.remove(arg_58_0.datas[var_0_0.APPLY_FRIEND], arg_58_2)

		if arg_58_3 ~= true then
			gGameUI:showTip(gLanguageCsv.refuseFriendApply)
		end
	end, arg_58_0.showdata2:atproxy(arg_58_2).id, false)
end

function var_0_7.onItemApplyAcceptClick(arg_60_0, arg_60_1, arg_60_2)
	idlereasy.do_(function(arg_61_0)
		if #arg_61_0 == game.FRIEND_LIMIT then
			gGameUI:showTip(gLanguageCsv.friendMax)
		else
			gGameApp:requestServer("/game/society/friend/accept", function(arg_62_0)
				table.remove(arg_60_0.datas[var_0_0.APPLY_FRIEND], arg_60_2)
				gGameUI:showTip(gLanguageCsv.addFriendSuccessful)
			end, arg_60_0.showdata2:atproxy(arg_60_2).id, false)
		end
	end, arg_60_0.myFriend)
end

function var_0_7.onItemAddAddClick(arg_63_0, arg_63_1, arg_63_2)
	local var_63_0 = arg_63_0.showdata3:atproxy(arg_63_2).id

	idlereasy.do_(function(arg_64_0)
		if #arg_64_0 == game.FRIEND_LIMIT then
			gGameUI:showTip(gLanguageCsv.addFriendLimit)
		else
			gGameApp:requestServer("/game/society/friend/askfor", function(arg_65_0)
				userDefault.setCurrDayKey("friendsAddState", {
					[stringz.bintohex(var_63_0)] = true
				})

				arg_63_0.showdata3:atproxy(arg_63_2).alreadyAdd = true

				gGameUI:showTip(gLanguageCsv.addFriendWait)
			end, {
				var_63_0
			})
		end
	end, arg_63_0.myFriend)
end

function var_0_7.onItemFriendGetClick(arg_66_0, arg_66_1, arg_66_2)
	local var_66_0 = arg_66_0.showdata1:atproxy(arg_66_2)

	idlereasy.do_(function(arg_67_0, arg_67_1)
		if game.FRIEND_STAMINA_GET_TIMES == arg_67_0 then
			gGameUI:showTip(gLanguageCsv.friendStaminaRecvMax)
		elseif arg_67_1 < game.STAMINA_LIMIT then
			gGameApp:requestServer("/game/society/friend/stamina/recv", function(arg_68_0)
				gGameUI:showTip(gLanguageCsv.staminaGetSuccessful)

				arg_66_0.datas[var_0_0.MY_FRIEND][arg_66_2].canGet = false
				var_66_0.canGet = false
			end, var_66_0.id)
		else
			gGameUI:showTip(gLanguageCsv.staminaToLimit)
		end
	end, arg_66_0.staminaCount, arg_66_0.stamina)
end

function var_0_7.onRemoveBlackClick(arg_69_0, arg_69_1, arg_69_2)
	gGameUI:showDialog({
		isRich = true,
		btnType = 2,
		title = "",
		content = string.format(gLanguageCsv.removeSelectBlackListSuccess, arg_69_0.showdata4:atproxy(arg_69_2).name),
		cb = function()
			gGameApp:requestServer("/game/society/blacklist/remove", function(arg_71_0)
				gGameUI:showTip(gLanguageCsv.removeBlackListSuccess)
			end, arg_69_0.showdata4:atproxy(arg_69_2).id)
		end
	})
end

function var_0_7.onItemFriendGiveClick(arg_72_0, arg_72_1, arg_72_2)
	local var_72_0 = arg_72_0.showdata1:atproxy(arg_72_2)

	gGameApp:requestServer("/game/society/friend/stamina/send", function(arg_73_0)
		gGameUI:showTip(gLanguageCsv.staminaSendSucceful)

		arg_72_0.datas[var_0_0.MY_FRIEND][arg_72_2].hasGive = true
		var_72_0.hasGive = true
	end, var_72_0.id)
end

function var_0_7.onItemFriendClick(arg_74_0, arg_74_1, arg_74_2)
	arg_74_0.myShowFriend:set(arg_74_2)
end

function var_0_7.onShowOrderClick(arg_75_0)
	arg_75_0.btnSelectAscOrder:modify(function(arg_76_0)
		return true, not arg_76_0
	end)
end

function var_0_7.onSearchClick(arg_77_0)
	local var_77_0 = arg_77_0.nameInput:getStringValue()

	if var_77_0 == nil or var_77_0 == "" then
		gGameUI:showTip(gLanguageCsv.needNameOrUID)
	else
		gGameApp:requestServer("/game/society/friend/search", function(arg_78_0)
			arg_77_0.searchState:set(true)

			local var_78_0 = table.deepcopy(arg_78_0.view.roles, true)

			for iter_78_0, iter_78_1 in ipairs(var_78_0) do
				var_78_0[iter_78_0].reunionType = arg_77_0:getReunionType(iter_78_1.id)
			end

			arg_77_0.showdata3:update(var_78_0)
		end, nil, tostring(var_77_0), nil, tonumber(var_77_0))
	end
end

function var_0_7.onLeftButtonClick(arg_79_0, arg_79_1, arg_79_2)
	arg_79_0.leftButtonTab:set(arg_79_2)
end

function var_0_7.onSearchDeleteClick(arg_80_0)
	arg_80_0.showdata3:update(arg_80_0.datas[3])
	arg_80_0.nameInput:text("")
end

function var_0_7.initFriendShowType()
	local var_81_0 = gGameModel.society:read("friends")
	local var_81_1 = gGameModel.society:read("stamina_recv")
	local var_81_2 = gGameModel.daily_record:read("friend_stamina_gain")
	local var_81_3 = gGameModel.society:read("friend_reqs")

	if itertools.size(var_81_1) > 0 and var_81_2 < game.FRIEND_STAMINA_GET_TIMES then
		return var_0_0.MY_FRIEND, var_81_0
	end

	local var_81_4 = gGameModel.society:read("friend_reqs")
	local var_81_5 = itertools.size(var_81_4)
	local var_81_6 = itertools.size(var_81_0)

	if var_81_6 < 10 and var_81_5 > 0 then
		return var_0_0.APPLY_FRIEND, var_81_4
	elseif var_81_6 < 20 and var_81_5 == 0 then
		return var_0_0.ADD_FRIEND
	elseif var_81_6 > 40 then
		return var_0_0.MY_FRIEND, var_81_0
	else
		return var_0_0.MY_FRIEND, var_81_0
	end
end

function var_0_7.sendProtocol(arg_82_0, arg_82_1, arg_82_2)
	if arg_82_0 ~= var_0_0.ADD_FRIEND then
		if arg_82_1 and itertools.size(arg_82_1) > 0 then
			return gGameApp:requestServer("/game/society/friend/search", function(arg_83_0)
				arg_82_2(arg_82_0, arg_83_0.view.roles)
			end, nil, nil, arg_82_1)
		else
			arg_82_2(arg_82_0, {})
		end
	else
		return gGameApp:requestServer("/game/society/friend/list", function(arg_84_0)
			arg_82_2(arg_82_0, arg_84_0.view.roles)
		end)
	end
end

function var_0_7.onSortMenusBtnClick(arg_85_0, arg_85_1, arg_85_2, arg_85_3, arg_85_4)
	arg_85_0.dropAttrTab:set(arg_85_3)
end

function var_0_7.sortItem(arg_86_0, arg_86_1)
	local var_86_0 = arg_86_0.dropAttrTab:read()
	local var_86_1 = arg_86_0.btnSelectAscOrder:read()

	return function(arg_87_0, arg_87_1)
		local var_87_0 = arg_87_0[var_0_2[var_86_0]]
		local var_87_1 = arg_87_1[var_0_2[var_86_0]]

		if var_87_0 ~= var_87_1 then
			if var_86_1 then
				return var_87_0 < var_87_1
			else
				return var_87_1 < var_87_0
			end
		end
	end
end

function var_0_7.onHeadClick(arg_88_0, arg_88_1, arg_88_2, arg_88_3, arg_88_4, arg_88_5)
	local var_88_0 = arg_88_5.target
	local var_88_1, var_88_2 = var_88_0:xy()
	local var_88_3 = var_88_0:getParent():convertToWorldSpace(cc.p(var_88_1, var_88_2))

	gGameUI:stackUI("city.chat.personal_info", nil, {
		clickClose = true,
		dispatchNodes = arg_88_1:parent()
	}, var_88_3, {
		role = arg_88_3
	}, {
		speical = "rank",
		disableTouch = true,
		target = arg_88_1.item:get("bg"),
		blackCb = function(arg_89_0)
			if arg_88_4 == "apply" then
				arg_89_0:onClose()
				arg_88_0:onItemApplyRefuseClick(nil, arg_88_2, true)
			end
		end
	})
end

function var_0_7.startFighting(arg_90_0, arg_90_1, arg_90_2)
	battleEntrance.battleRequest("/game/society/friend/fight", gGameModel.role:getIdler("id"), arg_90_1):onStartOK(function(arg_91_0)
		if arg_90_2 then
			arg_90_2:onClose(false)

			arg_90_2 = nil
		end
	end):show()
end

return var_0_7
