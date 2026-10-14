local var_0_0 = class("UnionRedPackDetailView", Dialog)

var_0_0.RESOURCE_FILENAME = "union_redpack_info.json"
var_0_0.RESOURCE_BINDING = {
	item = "item",
	imgBG = "imgBG",
	info = "infoPanel",
	imgInnerBg = "imgInnerBg",
	["title.textTitle1"] = {
		binds = {
			{
				event = "text",
				idler = bindHelper.self("sendName")
			},
			{
				event = "visible",
				idler = bindHelper.self("showName")
			}
		}
	},
	["title.textTitle2"] = {
		varname = "textTitle2",
		binds = {
			event = "text",
			idler = bindHelper.self("desc")
		}
	},
	tetxTip = {
		varname = "tetxTip",
		binds = {
			event = "visible",
			idler = bindHelper.self("showTip")
		}
	},
	["info.tetxNum1"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("getNum")
		}
	},
	["info.tetxNum2"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("allNUm")
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("packDatas"),
				item = bindHelper.self("item"),
				topRoleName = bindHelper.self("topRoleName"),
				info = bindHelper.self("info"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("textName"):text(arg_1_3.name)
					arg_1_1:get("textNum"):text(arg_1_3.val)
					arg_1_1:get("imgFlag"):visible(arg_1_3.name == arg_1_0.topRoleName)

					local var_1_0 = dataEasy.getIconResByKey(arg_1_0.info.key)

					arg_1_1:get("imgIcon"):texture(var_1_0)
					adapt.oneLinePos(arg_1_1:get("imgIcon"), arg_1_1:get("textNum"), cc.p(5, 0), "right")
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_2_0, arg_2_1, arg_2_2)
	if (arg_2_1.showType or 1) == 2 then
		arg_2_0.imgBG:texture("city/union/redpack/img_hb2_h@.png")
		arg_2_0.imgInnerBg:texture("city/union/redpack/box_d2.png")
	end

	arg_2_0.info = arg_2_1
	arg_2_0.sendName = idler.new(string.format(gLanguageCsv.redpackSender, arg_2_1.role_name))
	arg_2_0.desc = idler.new(arg_2_1.text)
	arg_2_0.showTip = idler.new(arg_2_1.used_count == arg_2_1.total_count)

	local var_2_0 = false

	if string.len(arg_2_1.role_name or "") > 0 then
		var_2_0 = true
	end

	local var_2_1 = 80

	if var_2_0 then
		local var_2_2 = 26
	end

	arg_2_0.showName = idler.new(var_2_0)
	arg_2_0.getNum = idler.new(string.format("%d/%d", arg_2_1.used_count, arg_2_1.total_count))
	arg_2_0.allNUm = idler.new(string.format("%d/%d", arg_2_1.used_val, arg_2_1.total_val))

	arg_2_0.infoPanel:get("tetxNum1"):text(arg_2_0.getNum:read())
	arg_2_0.infoPanel:get("tetxNum2"):text(arg_2_0.allNUm:read())
	adapt.oneLinePos(arg_2_0.infoPanel:get("tetxNote1"), {
		arg_2_0.infoPanel:get("tetxNum1"),
		arg_2_0.infoPanel:get("tetxNote2"),
		arg_2_0.infoPanel:get("tetxNum2")
	})

	arg_2_0.packDatas = idlers.newWithMap(arg_2_2)
	arg_2_0.topRoleName = arg_2_1.top_role_name

	if not arg_2_0.topRoleName then
		local var_2_3 = 0

		for iter_2_0, iter_2_1 in ipairs(arg_2_1.members) do
			if arg_2_2[iter_2_1] and var_2_3 < arg_2_2[iter_2_1].val then
				var_2_3 = arg_2_2[iter_2_1].val
				arg_2_0.topRoleName = arg_2_2[iter_2_1].name
			end
		end
	end

	idlereasy.when(arg_2_0.showTip, function(arg_3_0, arg_3_1)
		local var_3_0 = 800

		if arg_3_1 then
			local var_3_1 = 766
		end
	end)
	Dialog.onCreate(arg_2_0)
end

return var_0_0
