local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("UnionApplyView", Dialog)
local var_0_2 = {
	gLanguageCsv.chairman,
	gLanguageCsv.viceChairman,
	gLanguageCsv.member
}
local var_0_3 = {
	CHAIRMAN = 1,
	MEMBER = 3,
	VICE_CHAIRMAN = 2
}

local function var_0_4(arg_1_0, arg_1_1)
	if arg_1_1.chairman == arg_1_0 then
		return var_0_3.CHAIRMAN
	end

	if arg_1_1.viceChairmans[arg_1_0] then
		return var_0_3.VICE_CHAIRMAN
	end

	return var_0_3.MEMBER
end

var_0_1.RESOURCE_FILENAME = "union_apply.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
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
			class = "listview",
			props = {
				data = bindHelper.self("applyDate"),
				item = bindHelper.self("item"),
				dataOrderCmpGen = bindHelper.self("onSortMembers", true),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					bind.extend(arg_2_0, arg_2_1:get("icon"), {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_2_3.logo,
							frameId = arg_2_3.frame,
							onNode = function(arg_3_0)
								arg_3_0:scale(0.8)
							end
						}
					})
					arg_2_1:get("name"):text(arg_2_3.name)
					arg_2_1:get("level"):text(arg_2_3.level)
					arg_2_1:get("wbm"):visible(not arg_2_3.isHas)
					arg_2_1:get("ybm"):visible(arg_2_3.isHas)
					arg_2_1:get("member"):text(var_0_2[arg_2_3.job])

					local var_2_0 = arg_2_2 % 2 == 0 and 153 or 77

					arg_2_1:get("bg"):setOpacity(var_2_0)

					if not arg_2_3.roleId then
						arg_2_1:get("bg"):onClick(functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3))
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("ItemclickBtn")
			}
		}
	}
}

function var_0_1.onCreate(arg_4_0)
	arg_4_0:initModel()
	arg_4_0.item:hide()

	arg_4_0.applyDate = idlers.new({})

	local var_4_0 = {
		chairman = arg_4_0.chairmanId
	}
	local var_4_1 = {}

	for iter_4_0, iter_4_1 in ipairs(arg_4_0.viceChairmans) do
		var_4_1[iter_4_1] = true
	end

	var_4_0.viceChairmans = var_4_1

	local var_4_2 = {}
	local var_4_3 = false

	for iter_4_2, iter_4_3 in csvMapPairs(arg_4_0.members) do
		local var_4_4 = false

		for iter_4_4, iter_4_5 in ipairs(arg_4_0.signRoles) do
			if iter_4_3.id == iter_4_5 then
				var_4_4 = true
			end
		end

		local var_4_5 = false

		if arg_4_0.id == iter_4_3.id then
			var_4_5 = true
		end

		local var_4_6 = var_0_4(iter_4_3.id, var_4_0)

		table.insert(var_4_2, {
			logo = iter_4_3.logo,
			id = iter_4_3.id,
			vip = iter_4_3.vip,
			level = iter_4_3.level,
			frame = iter_4_3.frame,
			contrib = iter_4_3.contrib,
			name = iter_4_3.name,
			isHas = var_4_4,
			job = var_4_6,
			roleId = var_4_5
		})
	end

	arg_4_0.applyDate:update(var_4_2)
	Dialog.onCreate(arg_4_0, {
		clickClose = true
	})
end

function var_0_1.initModel(arg_5_0)
	arg_5_0.signRoles = gGameModel.union_fight:read("union_info").sign_roles
	arg_5_0.members = gGameModel.union:read("members")
	arg_5_0.chairmanId = gGameModel.union:read("chairman_db_id")
	arg_5_0.viceChairmans = gGameModel.union:read("vice_chairmans")
	arg_5_0.id = gGameModel.role:read("id")
end

function var_0_1.ItemclickBtn(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = arg_6_4.target
	local var_6_1, var_6_2 = var_6_0:xy()
	local var_6_3 = var_6_0:getParent():convertToWorldSpace(cc.p(var_6_1, var_6_2))

	gGameUI:stackUI("city.chat.personal_info", nil, {
		clickClose = true,
		dispatchNodes = arg_6_1:parent()
	}, var_6_3, {
		role = arg_6_3
	}, {
		speical = "rank",
		disableTouch = true,
		target = arg_6_1.item:get("bg")
	})
end

function var_0_1.onSortMembers(arg_7_0, arg_7_1)
	return function(arg_8_0, arg_8_1)
		if arg_8_0.job ~= arg_8_1.job then
			return arg_8_0.job < arg_8_1.job
		end

		return arg_8_0.contrib < arg_8_1.contrib
	end
end

return var_0_1
