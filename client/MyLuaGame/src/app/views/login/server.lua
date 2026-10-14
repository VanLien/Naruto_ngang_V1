local var_0_0 = 10
local var_0_1 = {
	"login/tag_hot_server.png",
	"login/tag_new_server.png",
	"login/tag_maintain_server.png"
}
local var_0_2 = {
	"login/logo_red.png",
	"login/logo_green.png",
	"login/logo_gray.png"
}
local var_0_3 = class("LoginServerView", Dialog)

var_0_3.RESOURCE_FILENAME = "login_server.json"
var_0_3.RESOURCE_BINDING = {
	subList = "subList",
	item = "item",
	leftItem = "leftItem",
	bottomPanel = "bottomPanel",
	leftPanel = "leftPanel",
	chooseText = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.RED
				}
			}
		}
	},
	subTitle = {
		varname = "subTitle",
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
	["leftPanel.leftList"] = {
		varname = "leftList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 8,
				padding = 10,
				data = bindHelper.self("areaList"),
				item = bindHelper.self("leftItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("normal")
					local var_1_1 = arg_1_1:get("selected")
					local var_1_2

					if arg_1_3.select then
						var_1_0:hide()

						var_1_2 = var_1_1:show()

						text.addEffect(var_1_2:get("name"), {
							outline = {
								color = ui.NEWCOLORS.OUTLINE.BLACK
							}
						})
					else
						var_1_1:hide()

						var_1_2 = var_1_0:show()
					end

					local var_1_3 = var_1_2:get("name")

					if arg_1_3.isMyServer then
						var_1_3:text(gLanguageCsv.myServer)
					else
						local var_1_4 = SERVER_MAP[arg_1_3.tag] and SERVER_MAP[arg_1_3.tag].name or ""

						var_1_3:text(string.format("%s %d-%d %s", var_1_4, arg_1_3.leftIdx, arg_1_3.leftIdx + arg_1_3.count - 1, gLanguageCsv.serverArea))
					end

					bind.click(arg_1_0, arg_1_1, {
						method = functools.partial(arg_1_0.clickCell, arg_1_2)
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onChooseArea")
			}
		}
	},
	btnClose = {
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
				topPadding = 70,
				columnSize = 2,
				asyncPreload = 12,
				data = bindHelper.self("serverList"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_3.server
					local var_2_1 = arg_2_3.userData

					arg_2_1:get("tag"):texture(var_0_1[var_2_0.status])
					arg_2_1:get("circle"):texture(var_0_2[var_2_0.status])

					if matchLanguage({
						"kr"
					}) then
						arg_2_1:get("name"):text(string.format("%s-%s", getServerArea(var_2_0.key, nil, true), getServerName(var_2_0.key, true)))
					else
						arg_2_1:get("name"):text(string.format("%s\n%s", getServerArea(var_2_0.key, nil, true), getServerName(var_2_0.key, true)))
					end

					if var_2_1 then
						arg_2_1:get("tag"):visible(false)
						bind.extend(arg_2_0, arg_2_1, {
							event = "extend",
							class = "role_logo",
							props = {
								logoId = var_2_1.logo,
								frameId = var_2_1.frame,
								level = math.max(var_2_1.level, 1),
								vip = var_2_1.vip,
								onNode = function(arg_3_0)
									arg_3_0:xy(arg_2_1:width() - 90, arg_2_1:height() / 2):scale(0.66):z(6)
									arg_3_0:get("vip"):xy(160, 20)
								end
							}
						})
					end

					bind.touch(arg_2_0, arg_2_1, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onChooseServer")
			}
		}
	},
	topPanel = {
		varname = "topPanel",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChooseDefaultServer")
			}
		}
	},
	hideIcon = {
		varname = "hideIcon",
		binds = {
			event = "click",
			method = bindHelper.self("onCheckBox")
		}
	},
	hideTip = {
		varname = "hideTip",
		binds = {
			event = "click",
			method = bindHelper.self("onCheckBox")
		}
	}
}

function var_0_3.onCreate(arg_4_0, arg_4_1)
	arg_4_0.listOriginY = arg_4_0.list:y()
	arg_4_0.servers = arg_4_1

	arg_4_0:initModel()
	arg_4_0:initData()

	arg_4_0.serverList = idlereasy.new()
	arg_4_0.showTab = idler.new(1)

	arg_4_0.showTab:addListener(function(arg_5_0, arg_5_1, arg_5_2)
		arg_4_0.areaList:atproxy(arg_5_1).select = false
		arg_4_0.areaList:atproxy(arg_5_0).select = true

		arg_4_0:resetList(arg_5_0)
		arg_4_0.serverList:set(arg_4_0:getServerData(arg_5_0))
	end)
	Dialog.onCreate(arg_4_0)
end

function var_0_3.initModel(arg_6_0)
	arg_6_0.roleInfos = gGameModel.account:read("role_infos")
end

function var_0_3.onChooseArea(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0.showTab:set(arg_7_2)
end

function var_0_3.onChooseServer(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0.setServerInfo(arg_8_2.server)
	arg_8_0:onClose()
end

function var_0_3.onChooseDefaultServer(arg_9_0)
	if arg_9_0.lastChooseServer then
		arg_9_0:onChooseServer(nil, {
			server = arg_9_0.lastChooseServer
		})
	end
end

function var_0_3.initData(arg_10_0)
	arg_10_0.checkStatusVisible = userDefault.getForeverLocalKey("hideLevelStatus", false, {
		rawKey = true
	}) ~= false

	userDefault.setForeverLocalKey("hideLevelStatus", arg_10_0.checkStatusVisible, {
		rawKey = true
	})
	arg_10_0.hideIcon:texture(arg_10_0.checkStatusVisible and "common/icon/radio_selected.png" or "common/icon/radio_normal.png")
	arg_10_0.topPanel:hide()

	arg_10_0.lastChooseServer = nil

	local var_10_0 = userDefault.getForeverLocalKey("serverKey", nil, {
		rawKey = true
	})

	if var_10_0 then
		itertools.first(arg_10_0.servers, function(arg_11_0)
			if arg_11_0.key == var_10_0 then
				arg_10_0.lastChooseServer = arg_11_0

				arg_10_0.topPanel:get("img.circle"):texture(var_0_2[arg_11_0.status])

				local var_11_0 = string.format("%s %s", getServerArea(arg_11_0.key, nil, true), getServerName(arg_11_0.key, true))
				local var_11_1 = string.format(gLanguageCsv.brackets, var_11_0)

				if arg_10_0:getRoleInfo(arg_10_0.roleInfos[arg_11_0.key]) then
					var_11_1 = var_11_1 .. " " .. arg_10_0.roleInfos[arg_11_0.key].name
				end

				arg_10_0.topPanel:get("name"):text(var_11_1)
				adapt.oneLinePos(arg_10_0.topPanel:get("name"), arg_10_0.topPanel:get("img"), nil, "right")
				arg_10_0.topPanel:show()

				return true
			end
		end)
	end

	local var_10_1 = {}

	for iter_10_0, iter_10_1 in ipairs(arg_10_0.servers) do
		if arg_10_0:getRoleInfo(arg_10_0.roleInfos[iter_10_1.key]) then
			table.insert(var_10_1, {
				isMyServer = true
			})

			break
		end
	end

	local var_10_2 = {}
	local var_10_3 = 1
	local var_10_4 = 1
	local var_10_5 = #arg_10_0.servers
	local var_10_6

	while var_10_3 <= var_10_5 do
		local var_10_7 = getServerTag(arg_10_0.servers[var_10_3].key)
		local var_10_8 = 1

		for iter_10_2 = math.min(var_0_0 - 1, var_10_5 - var_10_3), 1, -1 do
			local var_10_9 = getServerTag(arg_10_0.servers[var_10_3 + iter_10_2].key)

			if SERVER_MAP[var_10_7] == SERVER_MAP[var_10_9] then
				var_10_8 = iter_10_2 + 1

				break
			end
		end

		if var_10_7 ~= var_10_6 then
			var_10_6 = var_10_7
			var_10_4 = 1
		end

		table.insert(var_10_2, {
			count = var_10_8,
			leftId = var_10_3,
			leftIdx = var_10_4,
			tag = var_10_7,
			server = arg_10_0.servers[var_10_3]
		})

		var_10_3 = var_10_3 + var_10_8
		var_10_4 = var_10_4 + var_10_8
	end

	for iter_10_3 = #var_10_2, 1, -1 do
		table.insert(var_10_1, var_10_2[iter_10_3])
	end

	arg_10_0.areaList = idlers.newWithMap(var_10_1)
end

function var_0_3.onCheckBox(arg_12_0)
	arg_12_0.checkStatusVisible = not arg_12_0.checkStatusVisible

	local var_12_0 = {}

	userDefault.setForeverLocalKey("hideLevelStatus", arg_12_0.checkStatusVisible, {
		rawKey = true
	})
	arg_12_0.hideIcon:texture(arg_12_0.checkStatusVisible and "common/icon/radio_selected.png" or "common/icon/radio_normal.png")
	arg_12_0.serverList:set(arg_12_0:getServerData(arg_12_0.showTab:read()))
end

function var_0_3.getRoleInfo(arg_13_0, arg_13_1)
	return arg_13_1
end

function var_0_3.resetList(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.areaList:atproxy(arg_14_1)
	local var_14_1 = arg_14_0.listOriginY
	local var_14_2 = 900

	if not arg_14_0.lastChooseServer then
		var_14_2 = var_14_2 + 140
	end

	if not var_14_0.isMyServer then
		var_14_1 = var_14_1 + 60

		arg_14_0.bottomPanel:show()
	else
		var_14_2 = var_14_2 + 60

		arg_14_0.bottomPanel:hide()
	end

	arg_14_0.list:y(var_14_1)
	arg_14_0.list:height(var_14_2)
end

function var_0_3.getServerData(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.areaList:atproxy(arg_15_1)

	arg_15_0.hideIcon:visible(false)
	arg_15_0.hideTip:visible(false)

	if var_15_0.isMyServer then
		arg_15_0.hideIcon:visible(true)
		arg_15_0.hideTip:visible(true)

		local var_15_1 = {}

		for iter_15_0, iter_15_1 in ipairs(arg_15_0.servers) do
			if not arg_15_0:getRoleInfo(arg_15_0.roleInfos[iter_15_1.key]) or arg_15_0.checkStatusVisible and arg_15_0.roleInfos[iter_15_1.key].level <= 1 then
				-- block empty
			else
				table.insert(var_15_1, {
					id = iter_15_0,
					server = iter_15_1,
					userData = arg_15_0.roleInfos[iter_15_1.key]
				})
			end
		end

		table.sort(var_15_1, function(arg_16_0, arg_16_1)
			if arg_16_0.userData.level ~= arg_16_1.userData.level then
				return arg_16_0.userData.level > arg_16_1.userData.level
			end

			if arg_16_0.userData.vip ~= arg_16_1.userData.vip then
				return arg_16_0.userData.vip > arg_16_1.userData.vip
			end

			return arg_16_0.id < arg_16_1.id
		end)

		return var_15_1
	end

	local var_15_2 = {}

	for iter_15_2 = var_15_0.leftId, var_15_0.leftId + var_15_0.count - 1 do
		table.insert(var_15_2, {
			server = arg_15_0.servers[iter_15_2]
		})

		local var_15_3 = arg_15_0.roleInfos[arg_15_0.servers[iter_15_2].key]

		if arg_15_0:getRoleInfo(var_15_3) then
			var_15_2[#var_15_2].userData = var_15_3
		end
	end

	return var_15_2
end

return var_0_3
