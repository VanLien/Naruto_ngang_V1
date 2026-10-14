local var_0_0 = {
	vacation = {
		title = "activity/server_open/summer_vacation/txt_sqqtl_1.png",
		bg = "activity/server_open/summer_vacation/img_sqqtl_hb.png",
		icon = "activity/server_open/summer_vacation/icon_sqqtl_2.png"
	}
}
local var_0_1 = class("ServerOpenPlacardView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "activity_server_open_placard.json"
var_0_1.RESOURCE_BINDING = {
	barBg = "barBg",
	num = "num",
	placard = "placard",
	desc = "desc",
	bar = {
		varname = "bar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				maskImg = "activity/server_open/bar_red.png",
				data = bindHelper.self("barPoint")
			}
		}
	}
}

function var_0_1.onCreate(arg_1_0, arg_1_1)
	arg_1_0.activityId = arg_1_1
	arg_1_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_1_0.barPoint = idler.new(0)

	idlereasy.when(arg_1_0.yyhuodongs, function(arg_2_0, arg_2_1)
		local var_2_0 = (arg_2_1[arg_1_0.activityId] or {}).targets or {}
		local var_2_1 = var_2_0.cur or 0

		arg_1_0.num:text(var_2_1 .. "/" .. var_2_0.all)
		arg_1_0.barPoint:set(var_2_1 / var_2_0.all * 100)
	end)

	local var_1_0 = csv.yunying.yyhuodong[arg_1_0.activityId]

	if var_1_0.clientParam.type then
		arg_1_0.clientType = var_1_0.clientParam.type
	end

	if arg_1_0.clientType == "springFestival" and arg_1_0.clientType == "mayDay" then
		bind.extend(arg_1_0, arg_1_0.num, {
			class = "icon_key",
			props = {
				simpleShow = true,
				data = {
					key = var_1_0.paramMap.itemId
				},
				onNode = function(arg_3_0)
					arg_3_0:setTouchEnabled(false)
					arg_3_0:scale(0.8):x(-300)
				end
			}
		})
	end

	arg_1_0:updateData(arg_1_1)

	for iter_1_0, iter_1_1 in pairs(var_0_0) do
		if arg_1_0.clientType == iter_1_0 then
			arg_1_0.placard:texture(iter_1_1.bg)

			local var_1_1 = CSprite.new(iter_1_1.title)
			local var_1_2 = arg_1_0:getResourceNode()

			var_1_1:addTo(var_1_2, 10)
			var_1_1:setAnchorPoint(cc.p(0.5, 0.5))

			local var_1_3 = arg_1_0.desc:x()
			local var_1_4 = arg_1_0.desc:y()

			var_1_1:xy(var_1_3 - 60, var_1_4)
			arg_1_0.desc:hide()

			local var_1_5 = CSprite.new(iter_1_1.icon)

			var_1_5:addTo(var_1_2, 11)
			var_1_5:setAnchorPoint(cc.p(0.5, 0.5))
			var_1_5:xy(arg_1_0.num:x() - 440, arg_1_0.num:y())
			var_1_5:scale(0.8)
			arg_1_0.bar:x(arg_1_0.bar:x() - 60)
			arg_1_0.barBg:x(arg_1_0.barBg:x() - 60)
			arg_1_0.num:x(arg_1_0.num:x() - 60)
		end
	end

	if arg_1_0.clientType == "springFestival" then
		text.addEffect(arg_1_0.num, {
			outline = {
				size = 3,
				color = ui.COLORS.BLACK
			}
		})
		text.addEffect(arg_1_0.desc, {
			outline = {
				size = 3,
				color = ui.COLORS.BLACK
			}
		})
	end

	if arg_1_0.clientType == "mayDay" or arg_1_0.clientType == "vacation" then
		text.addEffect(arg_1_0.num, {
			outline = {
				size = 3,
				color = ui.COLORS.BLACK
			}
		})
		text.addEffect(arg_1_0:getResourceNode():get("desc"), {
			outline = {
				color = ui.COLORS.BLACK
			}
		})
	end

	if arg_1_0.clientType == "national" then
		text.addEffect(arg_1_0.num, {
			outline = {
				size = 3,
				color = ui.COLORS.BLACK
			}
		})
		text.addEffect(arg_1_0:getResourceNode():get("desc"), {
			outline = {
				color = ui.COLORS.BLACK
			}
		})
	end

	if arg_1_0.clientType == "doubleYearsDay" then
		text.addEffect(arg_1_0.num, {
			outline = {
				size = 3,
				color = ui.COLORS.BLACK
			}
		})
		text.addEffect(arg_1_0:getResourceNode():get("desc"), {
			outline = {
				color = ui.COLORS.BLACK
			}
		})
	end

	if arg_1_0.clientType == "anniversary" then
		text.addEffect(arg_1_0.num, {
			outline = {
				size = 3,
				color = ui.COLORS.BLACK
			}
		})
		text.addEffect(arg_1_0:getResourceNode():get("desc"), {
			outline = {
				color = ui.COLORS.BLACK
			}
		})
	end
end

function var_0_1.updateData(arg_4_0, arg_4_1)
	arg_4_0.activityId = arg_4_1
end

return var_0_1
