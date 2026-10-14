local var_0_0 = {
	mine = 1,
	enemy = 2
}
local var_0_1 = {
	forever = 3,
	rare = 2,
	normal = 1
}
local var_0_2 = {
	"activity/brave_challenge/box_yztz_18.png",
	"activity/brave_challenge/box_yztz_17.png",
	"activity/brave_challenge/box_yztz_21.png"
}
local var_0_3 = 8

local function var_0_4(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_1:size(1900, 100)
	arg_1_1:get("list"):hide()
	arg_1_1:get("noItem"):hide()
	arg_1_1:get("title"):y(50):show()

	local var_1_0 = arg_1_1:get("title.txt")
	local var_1_1 = arg_1_1:get("title.bg")

	if arg_1_3.data == var_0_1.rare then
		var_1_0:text(gLanguageCsv.braveChallengeRareBadge)
		var_1_1:texture("activity/brave_challenge/box_yztz_13.png")
		text.addEffect(var_1_0, {
			color = cc.c3b(253, 252, 159)
		})
		text.addEffect(var_1_0, {
			outline = {
				size = 4,
				color = cc.c4b(244, 144, 15, 255)
			}
		})
	else
		var_1_0:text(gLanguageCsv.braveChallengeNormalBadge)
		var_1_1:texture("activity/brave_challenge/box_yztz_14.png")
		text.addEffect(var_1_0, {
			color = cc.c3b(255, 251, 232)
		})
	end
end

local function var_0_5(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_1:size(1900, 230)
	arg_2_1:get("list"):hide()
	arg_2_1:get("title"):hide()
	arg_2_1:get("noItem"):y(115):show()
end

local function var_0_6(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_1:get("title"):hide()
	arg_3_1:get("noItem"):hide()

	local var_3_0 = arg_3_1:get("list"):y(0)
	local var_3_1 = arg_3_0.spriteItem

	arg_3_1:size(cc.size(1900, 230))
	bind.extend(arg_3_0, var_3_0, {
		class = "listview",
		props = {
			data = arg_3_3,
			item = var_3_1,
			onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				local var_4_0 = arg_4_1:multiget("select", "icon", "bg")

				var_4_0.bg:texture(var_0_2[arg_4_3.rarity])
				var_4_0.icon:texture(arg_4_3.res)
				var_4_0.select:visible(arg_4_3.select)
				bind.touch(arg_4_0, arg_4_1, {
					methods = {
						ended = functools.partial(arg_3_0.itemClick, arg_4_0, arg_4_1, arg_4_3)
					}
				})
			end
		}
	})
	arg_3_1:get("list"):setItemAlignCenter()
end

local var_0_7 = cc.load("mvc").ViewBase
local var_0_8 = class("BraveChallengeBadgeView", var_0_7)

var_0_8.RESOURCE_FILENAME = "activity_brave_challenge_badge.json"
var_0_8.RESOURCE_BINDING = {
	noItem = "noItem",
	item = "item",
	titile = "titile",
	tip = "tip",
	iconPanel = "spriteItem",
	imgBg = {
		binds = {
			event = "click",
			method = bindHelper.self("onClose")
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("showDatas"),
				item = bindHelper.self("item"),
				spriteItem = bindHelper.self("spriteItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					if arg_5_3.type == "title" then
						var_0_4(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					elseif arg_5_3.type == "noItem" then
						var_0_5(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					else
						var_0_6(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					end
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	}
}
var_0_8.RESOURCE_STYLES = {
	clickClose = true,
	blackLayer = true
}

function var_0_8.onCreate(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0.showDatas = {}

	if arg_6_2 == var_0_0.mine then
		arg_6_0.titile:texture("activity/brave_challenge/txt_yztz_5.png")
	elseif arg_6_2 == var_0_0.enemy then
		arg_6_0.titile:texture("activity/brave_challenge/txt_yztz_4.png")
	end

	arg_6_0.tip:text(gLanguageCsv.braveChallengeBadgeTip)
	arg_6_0:initPanel(arg_6_1)
end

function var_0_8.initPanel(arg_7_0, arg_7_1)
	local var_7_0 = csv.brave_challenge.badge
	local var_7_1 = {
		[var_0_1.rare] = {},
		[var_0_1.normal] = {}
	}

	for iter_7_0, iter_7_1 in ipairs(arg_7_1) do
		if var_7_0[iter_7_1] then
			local var_7_2 = var_7_0[iter_7_1].rarity > var_0_1.rare and var_0_1.rare or var_7_0[iter_7_1].rarity

			table.insert(var_7_1[var_7_2], {
				select = false,
				name = var_7_0[iter_7_1].name,
				desc = var_7_0[iter_7_1].desc,
				res = var_7_0[iter_7_1].iconResPath,
				rarity = var_7_0[iter_7_1].rarity
			})
		end
	end

	local var_7_3 = 1

	for iter_7_2 = itertools.size(var_7_1), 1, -1 do
		local var_7_4 = var_7_1[iter_7_2]

		if itertools.size(var_7_4) == 0 then
			arg_7_0.showDatas[var_7_3] = {
				type = "title",
				data = iter_7_2
			}
			var_7_3 = var_7_3 + 1
			arg_7_0.showDatas[var_7_3] = {
				type = "noItem",
				data = iter_7_2
			}
			var_7_3 = var_7_3 + 1
		else
			arg_7_0.showDatas[var_7_3] = {
				type = "title",
				data = iter_7_2
			}

			local var_7_5 = 0

			table.sort(var_7_4, function(arg_8_0, arg_8_1)
				return arg_8_0.rarity > arg_8_1.rarity
			end)

			for iter_7_3, iter_7_4 in ipairs(var_7_4) do
				local var_7_6 = math.ceil(iter_7_3 / var_0_3)
				local var_7_7 = (iter_7_3 - 1) % var_0_3 + 1

				arg_7_0.showDatas[var_7_6 + var_7_3] = arg_7_0.showDatas[var_7_6 + var_7_3] or {}
				arg_7_0.showDatas[var_7_6 + var_7_3][var_7_7] = iter_7_4
				var_7_5 = var_7_5 + 1
			end

			var_7_3 = math.ceil(var_7_5 / var_0_3) + var_7_3 + 1
		end
	end
end

function var_0_8.onItemClick(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	if gGameUI.itemDetailView then
		gGameUI.itemDetailView:onClose()
	end

	local var_9_0 = "city.activity.brave_challenge.badge_detail"
	local var_9_1 = "vertical"
	local var_9_2 = {
		"baseNode"
	}
	local var_9_3 = tip.create(var_9_0, nil, {
		dir = "right",
		relativeNode = arg_9_3,
		canvasDir = var_9_1,
		childsName = var_9_2
	}, arg_9_4)

	var_9_3:onNodeEvent("exit", functools.partial(gGameUI.unModal, gGameUI, var_9_3))
	gGameUI:doModal(var_9_3)

	gGameUI.itemDetailView = var_9_3
end

return var_0_8
