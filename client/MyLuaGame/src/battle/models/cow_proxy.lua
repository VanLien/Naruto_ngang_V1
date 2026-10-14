globals.cow = {}

local var_0_0 = "__nil_in_begin__"
local var_0_1
local var_0_2
local var_0_3
local var_0_4 = true
local var_0_5 = false
local var_0_6 = false
local var_0_7 = {}
local var_0_8
local var_0_9
local var_0_10
local var_0_11
local var_0_12
local var_0_13
local var_0_14 = {}
local var_0_15 = {}
local var_0_16 = string.caption
local var_0_17 = table.insert
local var_0_18 = table.remove
local var_0_19 = table.sort
local var_0_20 = table.getn
local var_0_21 = table.maxn
local var_0_22 = table.concat
local var_0_23 = table.getraw
local var_0_24 = table.isproxy
local var_0_25 = table.isimmutable
local var_0_26 = string.format
local var_0_27 = lua_type or type
local var_0_28 = lua_pairs or pairs
local var_0_29 = lua_ipairs or ipairs
local var_0_30 = rawget

local function var_0_31()
	return false
end

local function var_0_32(...)
	return
end

if var_0_4 and var_0_5 and device.platform == "windows" then
	local function var_0_33()
		return true
	end

	local function var_0_34(...)
		print("[COW]", ...)
	end
end

local function var_0_35(arg_5_0)
	local var_5_0 = var_0_12[arg_5_0]

	if var_5_0 == nil then
		var_5_0 = {}
		var_0_12[arg_5_0] = var_5_0
	end

	if var_5_0.__isclone then
		return
	end

	return var_5_0
end

local function var_0_36(arg_6_0, arg_6_1)
	if var_0_27(arg_6_0) == "table" then
		return var_0_30(arg_6_0, arg_6_1)
	end

	return arg_6_0[arg_6_1]
end

local function var_0_37(arg_7_0)
	if var_0_27(arg_7_0) == "table" then
		local var_7_0 = var_0_30(arg_7_0, "__cow_raw")

		if var_7_0 ~= nil then
			return var_7_0
		end
	end

	return arg_7_0
end

local function var_0_38(arg_8_0)
	return var_0_36(arg_8_0, "__cow_raw")
end

function var_0_14.insert(arg_9_0, ...)
	local var_9_0 = var_0_38(arg_9_0)

	if var_9_0 then
		arg_9_0:__clone()
	else
		var_9_0 = arg_9_0
	end

	return var_0_17(var_9_0, ...)
end

function var_0_14.remove(arg_10_0, ...)
	local var_10_0 = var_0_38(arg_10_0)

	if var_10_0 then
		arg_10_0:__clone()
	else
		var_10_0 = arg_10_0
	end

	return var_0_18(var_10_0, ...)
end

function var_0_14.sort(arg_11_0, ...)
	local var_11_0 = var_0_38(arg_11_0)

	if var_11_0 then
		arg_11_0:__clone()
	else
		var_11_0 = arg_11_0
	end

	return var_0_19(var_11_0, ...)
end

function var_0_14.concat(arg_12_0, ...)
	return var_0_22(var_0_23(arg_12_0), ...)
end

function var_0_14.getn(arg_13_0)
	return var_0_20(var_0_23(arg_13_0))
end

function var_0_14.maxn(arg_14_0)
	return var_0_21(var_0_23(arg_14_0))
end

local var_0_39 = {}

for iter_0_0, iter_0_1 in var_0_28(table) do
	var_0_39[iter_0_0] = iter_0_1
end

for iter_0_2, iter_0_3 in var_0_28(var_0_14) do
	var_0_39[iter_0_2] = table[iter_0_2]
end

local function var_0_40(arg_15_0)
	return (function(arg_16_0)
		if var_0_27(arg_16_0) ~= "table" then
			return arg_16_0
		elseif var_0_7[arg_16_0] then
			return var_0_7[arg_16_0]
		elseif var_0_38(arg_16_0) then
			return arg_16_0
		end

		var_0_13._clone_t_count = var_0_13._clone_t_count + 1

		local var_16_0 = {
			__isclone = arg_16_0
		}

		var_0_7[arg_16_0] = var_16_0

		for iter_16_0, iter_16_1 in var_0_28(arg_16_0) do
			var_16_0[iter_16_0] = iter_16_1
		end

		return setmetatable(var_16_0, getmetatable(arg_16_0))
	end)(arg_15_0)
end

local function var_0_41(arg_17_0)
	local var_17_0 = var_0_27(arg_17_0)

	if var_17_0 ~= "table" and var_17_0 ~= "userdata" then
		return arg_17_0
	end

	local var_17_1 = var_0_38(arg_17_0)

	if var_17_1 ~= nil then
		return var_0_41(var_17_1)
	end

	local var_17_2 = var_0_36(arg_17_0, "__isclone")

	if var_17_2 ~= nil then
		return var_0_41(var_17_2)
	end

	local var_17_3 = var_0_12[arg_17_0]

	if var_17_3 == nil then
		return arg_17_0
	end

	var_0_12[arg_17_0] = nil
	var_0_13._revert_t_count = var_0_13._revert_t_count + 1

	if var_17_3.__isclone then
		var_0_32("revert by clone", arg_17_0, var_17_3.__isclone)
		assert(arg_17_0 == var_17_3.__isclone, "w clone must with t")

		var_17_3.__isclone = nil

		for iter_17_0, iter_17_1 in var_0_28(arg_17_0) do
			if var_17_3[iter_17_0] == nil then
				arg_17_0[iter_17_0] = nil

				var_0_32("revert.del1", arg_17_0, iter_17_0)
			end
		end
	end

	for iter_17_2, iter_17_3 in var_0_28(var_17_3) do
		if iter_17_3 == var_0_0 then
			arg_17_0[iter_17_2] = nil

			var_0_32("revert.del2", arg_17_0, iter_17_2)
		else
			local var_17_4 = var_0_31() and arg_17_0[iter_17_2]

			arg_17_0[iter_17_2] = var_0_41(iter_17_3)

			if var_0_31() then
				local var_17_5 = var_0_32("revert", arg_17_0, iter_17_2, var_17_4, "->", arg_17_0[iter_17_2])
			end
		end
	end

	return arg_17_0
end

local function var_0_42(arg_18_0, arg_18_1)
	if arg_18_1 == nil then
		return nil
	end

	local var_18_0 = var_0_27(arg_18_1)

	if var_18_0 ~= "table" and var_18_0 ~= "userdata" then
		return arg_18_1
	end

	local var_18_1 = var_0_9[arg_18_1]

	if var_18_1 ~= nil then
		return var_18_1
	end

	if var_0_10[arg_18_1] ~= nil then
		return arg_18_1
	end

	if var_18_0 == "table" then
		if var_0_25(arg_18_1) or var_0_24(arg_18_1) then
			return arg_18_1
		end

		local var_18_2 = var_0_2(arg_18_0, arg_18_1)

		var_0_9[arg_18_1] = var_18_2
		var_0_10[var_18_2] = arg_18_1

		return var_18_2
	elseif var_18_0 == "userdata" then
		return cow.proxyView(arg_18_0, arg_18_1)
	end

	return arg_18_1
end

local function var_0_43(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = var_0_35(arg_19_0)

	if not var_19_0 then
		return
	end

	if var_19_0[arg_19_1] == nil then
		if arg_19_2 == nil then
			arg_19_2 = var_0_0
		end

		var_19_0[arg_19_1] = arg_19_2

		var_0_32("write backup", arg_19_0, arg_19_1, arg_19_2)
	end
end

var_0_15.attribute = {}

function var_0_15.watch_begin(arg_20_0, arg_20_1)
	arg_20_0.__children = {}
	arg_20_0.__operate = {
		setPosition = {
			arg_20_1:getPosition()
		}
	}

	for iter_20_0, iter_20_1 in pairs(var_0_15.attribute) do
		arg_20_0.__operate[iter_20_0] = {
			arg_20_1[iter_20_1](arg_20_1)
		}
	end

	for iter_20_2, iter_20_3 in ipairs(arg_20_1:getChildren()) do
		var_0_17(arg_20_0.__children, {
			is_add = false,
			ref = 1,
			node = iter_20_3,
			getName = function(arg_21_0)
				return arg_21_0.node:getName()
			end
		})
	end

	var_0_12[arg_20_0] = arg_20_1
end

function var_0_15.record_set(arg_22_0)
	var_0_15[arg_22_0] = function(arg_23_0, ...)
		arg_23_0.__operate[arg_22_0] = {
			...
		}
	end
end

function var_0_15.attribute_set(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	arg_24_2 = arg_24_2 or {}
	arg_24_2[1] = arg_24_2[1] or "set" .. var_0_16(arg_24_1)
	arg_24_2[2] = arg_24_2[2] or function(arg_25_0, arg_25_1)
		arg_25_0.__operate[arg_24_2[1]] = {
			arg_25_1
		}
	end
	arg_24_3 = arg_24_3 or {}
	arg_24_3[1] = arg_24_3[1] or "get" .. var_0_16(arg_24_1)
	arg_24_3[2] = arg_24_3[2] or function(arg_26_0)
		return arg_26_0.__operate[arg_24_2[1]][1]
	end
	var_0_15[arg_24_2[1]] = arg_24_2[2]
	var_0_15[arg_24_3[1]] = arg_24_3[2]
	var_0_15.attribute[arg_24_2[1]] = arg_24_3[1]
end

function var_0_15.addChild(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	var_0_17(arg_27_0.__children, {
		is_add = true,
		ref = 1,
		node = arg_27_1,
		z = arg_27_2,
		name = arg_27_3,
		getName = function(arg_28_0)
			local var_28_0 = arg_28_0.name or arg_27_1:getName()

			if var_28_0 == "" then
				return nil
			else
				return var_28_0
			end
		end
	})
end

function var_0_15.removeFromParent(arg_29_0)
	local var_29_0 = arg_29_0:getParent()
	local var_29_1 = var_0_9[var_29_0] or cow.proxyView(var_29_0:getName(), var_29_0)

	var_0_15.removeChildByName(var_29_1, arg_29_0:getName())
end

function var_0_15.getChildByName(arg_30_0, arg_30_1)
	for iter_30_0, iter_30_1 in ipairs(arg_30_0.__children) do
		if iter_30_1:getName() == arg_30_1 then
			return cow.proxyView(arg_30_1, iter_30_1.node)
		end
	end
end

function var_0_15.removeChildByName(arg_31_0, arg_31_1)
	for iter_31_0, iter_31_1 in ipairs(arg_31_0.__children) do
		if iter_31_1:getName() == arg_31_1 then
			iter_31_1.ref = iter_31_1.ref - 1

			break
		end
	end
end

function var_0_15.getChildrenCount(arg_32_0)
	local var_32_0 = 0

	for iter_32_0, iter_32_1 in ipairs(arg_32_0.__children) do
		if iter_32_1.ref > 0 then
			var_32_0 = var_32_0 + 1
		end
	end

	return var_32_0
end

function var_0_15.setPosition(arg_33_0, arg_33_1, arg_33_2)
	if arg_33_2 then
		arg_33_0.__operate.setPosition = {
			arg_33_1,
			arg_33_2
		}
	else
		arg_33_0.__operate.setPosition = {
			arg_33_1
		}
	end
end

function var_0_15.getPosition(arg_34_0)
	return arg_34_0.__operate.setPosition[1], arg_34_0.__operate.setPosition[2]
end

var_0_15:attribute_set("z", {
	"setLocalZOrder"
}, {
	"getLocalZOrder"
})
var_0_15:attribute_set("x", {
	"setPositionX"
}, {
	"getPositionX"
})
var_0_15:attribute_set("y", {
	"setPositionY"
}, {
	"getPositionY"
})
var_0_15:attribute_set("scaleX")
var_0_15:attribute_set("scaleY")
var_0_15:attribute_set("name")
var_0_15:attribute_set("contentSize")
var_0_15:attribute_set("visible", {}, {
	"isVisible"
})
var_0_15.record_set("runAction")
var_0_15.record_set("play")
var_0_15.record_set("setSkin")
var_0_15.record_set("setEnabled")
var_0_15.record_set("setTouchEnabled")
var_0_15.record_set("setAnchorPoint")

function var_0_15.revert(arg_35_0, arg_35_1)
	if arg_35_1 then
		return
	end

	local var_35_0 = var_0_38(arg_35_0)
	local var_35_1

	for iter_35_0, iter_35_1 in ipairs(arg_35_0.__children) do
		local var_35_2 = iter_35_1:getName()

		if iter_35_1.ref <= 0 and not iter_35_1.is_add then
			var_35_0:removeChildByName(var_35_2)
		elseif iter_35_1.ref > 0 and iter_35_1.is_add then
			var_35_0:add(iter_35_1.node, iter_35_1.z, var_35_2)
		end
	end

	for iter_35_2, iter_35_3 in pairs(arg_35_0.__operate) do
		var_35_0[iter_35_2](var_35_0, unpack(iter_35_3))
	end
end

local function var_0_44(arg_36_0, arg_36_1)
	local var_36_0 = {
		__iscdx = true,
		__proxy = true,
		__raw = arg_36_1,
		__cow_raw = arg_36_1,
		__name = arg_36_0,
		__revert = {}
	}

	var_0_15.watch_begin(var_36_0, arg_36_1)

	local var_36_1 = {
		__index = function(arg_37_0, arg_37_1)
			local var_37_0 = arg_36_1[arg_37_1]

			if type(var_37_0) == "function" and cc.Node[arg_37_1] == var_37_0 then
				local var_37_1 = var_37_0

				if arg_37_1 == "addChild" then
					function var_37_0(arg_38_0, arg_38_1, ...)
						return var_37_1(arg_36_1, var_0_38(arg_38_1) or arg_38_1, ...)
					end
				else
					function var_37_0(arg_39_0, ...)
						return var_37_1(arg_36_1, ...)
					end
				end
			end

			if not var_0_6 then
				return var_37_0
			end

			return var_0_15[arg_37_1] or var_0_42(arg_37_1, var_37_0)
		end,
		__newindex = function(arg_40_0, arg_40_1, arg_40_2)
			arg_40_1 = var_0_37(arg_40_1)
			arg_40_2 = var_0_37(arg_40_2)

			local var_40_0

			if var_0_6 then
				var_40_0 = var_0_36(arg_36_1, arg_40_1)
			end

			arg_36_1[arg_40_1] = arg_40_2

			if var_0_6 then
				if var_0_36(arg_36_1, arg_40_1) ~= arg_40_2 then
					var_0_32("cow_cdx_proxy __newindex may be write in meta", arg_36_1, arg_40_1, arg_40_2)
				else
					var_0_43(arg_36_1, arg_40_1, var_40_0)
				end
			end
		end,
		__tostring = function(arg_41_0)
			return var_0_26("cdx_proxy(%s)", tostring(arg_36_1))
		end
	}

	var_0_13._cow_cdx_count = var_0_13._cow_cdx_count + 1

	return setmetatable(var_36_0, var_36_1)
end

local var_0_45 = {
	__index = function(arg_42_0, arg_42_1)
		local var_42_0 = var_0_30(arg_42_0, "__cow_raw")

		if var_42_0 == nil then
			return
		end

		arg_42_1 = var_0_37(arg_42_1)

		local var_42_1 = var_42_0[arg_42_1]

		if not var_0_6 then
			return var_42_1
		end

		return var_0_42(arg_42_1, var_42_1)
	end,
	__newindex = function(arg_43_0, arg_43_1, arg_43_2)
		local var_43_0 = var_0_30(arg_43_0, "__cow_raw")

		arg_43_1 = var_0_37(arg_43_1)
		arg_43_2 = var_0_37(arg_43_2)

		local var_43_1

		if var_0_6 then
			var_43_1 = var_0_30(var_43_0, arg_43_1)
		end

		var_43_0[arg_43_1] = arg_43_2

		if var_0_6 then
			if var_0_30(var_43_0, arg_43_1) ~= arg_43_2 then
				var_0_32("cow_proxy __newindex may be write in meta", var_43_0, arg_43_1, arg_43_2)
			else
				var_0_43(var_43_0, arg_43_1, var_43_1)
			end
		end
	end,
	__pairs = function(arg_44_0)
		local var_44_0 = var_0_30(arg_44_0, "__cow_raw")
		local var_44_1 = var_0_30(arg_44_0, "__name") or "nil"
		local var_44_2, var_44_3, var_44_4 = var_0_28(var_44_0)

		if not var_0_6 then
			return var_44_2, var_44_3, var_44_4
		end

		return function()
			local var_45_0, var_45_1 = var_44_2(var_44_3, var_44_4)

			var_44_4 = var_45_0

			local var_45_2 = lua_tostring(var_45_0)

			return var_0_42(var_0_26("%s_%s", var_44_1, var_45_2), var_45_0), var_0_42(var_0_26("%s[%s]", var_44_1, var_45_2), var_45_1)
		end
	end,
	__ipairs = function(arg_46_0)
		local var_46_0 = var_0_30(arg_46_0, "__cow_raw")
		local var_46_1 = var_0_30(arg_46_0, "__name") or "nil"
		local var_46_2, var_46_3, var_46_4 = var_0_29(var_46_0)

		if not var_0_6 then
			return var_46_2, var_46_3, var_46_4
		end

		return function()
			local var_47_0, var_47_1 = var_46_2(var_46_3, var_46_4)

			var_46_4 = var_47_0

			local var_47_2 = lua_tostring(var_47_0)

			return var_47_0, var_0_42(var_0_26("%s[%s]", var_46_1, var_47_2), var_47_1)
		end
	end,
	__next = function(arg_48_0, arg_48_1)
		local var_48_0 = var_0_30(arg_48_0, "__cow_raw")
		local var_48_1 = var_0_30(arg_48_0, "__name") or "nil"
		local var_48_2, var_48_3 = lua_next(var_48_0, arg_48_1)

		if not var_0_6 then
			return var_48_2, var_48_3
		end

		local var_48_4 = lua_tostring(var_48_2)

		return var_0_42(var_0_26("%s_%s", var_48_1, var_48_4), var_48_2), var_0_42(var_0_26("%s[%s]", var_48_1, var_48_4), var_48_3)
	end,
	__len = function(arg_49_0)
		local var_49_0 = var_0_30(arg_49_0, "__cow_raw")

		return itertools.size(var_49_0)
	end,
	__tostring = function(arg_50_0)
		local var_50_0 = var_0_30(arg_50_0, "__cow_raw")
		local var_50_1 = var_0_30(arg_50_0, "__name") or "nil"

		return var_0_26("cow_proxy(%s %s)", var_50_1, tostring(var_50_0))
	end
}

function var_0_2(arg_51_0, arg_51_1)
	local var_51_0
	local var_51_1
	local var_51_2 = var_0_30(arg_51_1, "__index")
	local var_51_3 = var_0_30(arg_51_1, "__newindex")

	if var_51_2 then
		function var_51_0(arg_52_0, arg_52_1)
			return var_51_2(arg_52_0, arg_52_1)
		end
	end

	if var_51_3 then
		function var_51_1(arg_53_0, arg_53_1, arg_53_2)
			return var_51_3(arg_53_0, arg_53_1, arg_53_2)
		end
	end

	local var_51_4 = {
		__proxy = true,
		__raw = arg_51_1,
		__class = var_0_36(arg_51_1, "__class"),
		__cid = var_0_36(arg_51_1, "__cid"),
		__cname = var_0_36(arg_51_1, "__cname"),
		__cow_raw = arg_51_1,
		__name = arg_51_0,
		__index = var_51_0,
		__newindex = var_51_1,
		__clone = function(arg_54_0)
			if not var_0_6 then
				return
			end

			local var_54_0 = var_0_12[arg_51_1]

			if var_54_0 ~= nil and var_54_0.__isclone then
				return
			end

			local var_54_1 = var_0_40(arg_51_1)

			if var_54_0 then
				for iter_54_0, iter_54_1 in var_0_28(var_54_0) do
					if iter_54_1 == var_0_0 then
						var_54_1[iter_54_0] = nil
					else
						var_54_1[iter_54_0] = iter_54_1
					end
				end
			end

			var_0_12[arg_51_1] = var_54_1
		end
	}

	var_0_32("cow_proxy -------------->", arg_51_0, arg_51_1)

	var_0_13._cow_t_count = var_0_13._cow_t_count + 1

	return setmetatable(var_51_4, var_0_45)
end

function cow.battleModelInit()
	if not var_0_4 then
		return
	end

	var_0_6 = false

	for iter_55_0, iter_55_1 in var_0_28(var_0_14) do
		table[iter_55_0] = iter_55_1
	end
end

function cow.battleModelDestroy()
	if not var_0_4 then
		return
	end

	var_0_6 = false

	for iter_56_0, iter_56_1 in var_0_28(var_0_14) do
		table[iter_56_0] = var_0_39[iter_56_0]
	end

	printDebug("cow.app_data %s", dumps(var_0_13))
	cow.switchCowData(cow.newCowData())
end

function cow.proxyObject(arg_57_0, arg_57_1)
	if arg_57_1 == nil then
		return nil
	end

	if not var_0_4 then
		return arg_57_1
	end

	if var_0_9[arg_57_1] then
		return var_0_9[arg_57_1]
	end

	local var_57_0 = var_0_2(arg_57_0, arg_57_1)

	var_0_9[arg_57_1] = var_57_0
	var_0_10[var_57_0] = arg_57_1

	return var_57_0
end

function cow.proxyView(arg_58_0, arg_58_1)
	if arg_58_1 == nil then
		return nil
	end

	if not var_0_4 then
		return arg_58_1
	end

	if not var_0_6 then
		return arg_58_1
	end

	if var_0_9[arg_58_1] then
		return var_0_9[arg_58_1]
	end

	local var_58_0 = var_0_44(arg_58_0, arg_58_1)

	var_0_9[arg_58_1] = var_58_0
	var_0_10[var_58_0] = arg_58_1

	return var_58_0
end

function cow.proxyWatchBegin()
	if not var_0_4 then
		return
	end

	assert(not var_0_6, "g_watch_begin invalid")

	if var_0_6 then
		cow.proxyWatchEnd(false)
	end

	var_0_6 = true
	var_0_7 = {}

	var_0_32("cow.proxyWatchBegin()")

	return true
end

function cow.proxyWatchEnd(arg_60_0)
	if not var_0_4 then
		return
	end

	if arg_60_0 then
		var_0_13._revert_count = var_0_13._revert_count + 1
	end

	for iter_60_0, iter_60_1 in var_0_28(var_0_12) do
		if var_0_12[iter_60_0] then
			if arg_60_0 then
				var_0_41(iter_60_0)
			end

			if iter_60_0.__iscdx then
				var_0_15.revert(iter_60_0, arg_60_0)

				var_0_9[var_0_38(iter_60_0)], var_0_10[iter_60_0] = nil
				var_0_13._revert_cdx_count = var_0_13._revert_cdx_count + 1
			end

			var_0_12[iter_60_0] = nil
		end
	end

	var_0_6 = false
	var_0_7 = {}

	var_0_32("cow.proxyWatchEnd()")
end

function cow.revert(arg_61_0)
	return var_0_41(arg_61_0)
end

function cow.addGlobalCount(arg_62_0)
	if not var_0_4 then
		return
	end

	var_0_13.enable_count = var_0_13.enable_count + arg_62_0
end

function cow.getGlobalCount()
	return var_0_13.enable_count
end

function cow.newCowData()
	return {
		_proxy = {},
		_proxy_raw = {},
		_proxy_cdx = {},
		_lookup_table = {},
		_write = {},
		_app_data = {
			enable_count = 0,
			_clone_t_count = 0,
			_revert_count = 0,
			_cow_cdx_count = 0,
			_revert_cdx_count = 0,
			_cow_t_count = 0,
			_revert_t_count = 0
		}
	}
end

function cow.switchCowData(arg_65_0)
	local var_65_0 = var_0_8

	var_0_8 = arg_65_0
	var_0_9 = arg_65_0._proxy
	var_0_10 = arg_65_0._proxy_raw
	var_0_11 = arg_65_0._proxy_cdx
	var_0_12 = arg_65_0._write
	var_0_13 = arg_65_0._app_data

	return var_65_0
end

function cow.isproxy(arg_66_0)
	return arg_66_0 and type(arg_66_0) == "table" and var_0_30(arg_66_0, "__cow_raw") ~= nil
end

if var_0_4 then
	cow.switchCowData(cow.newCowData())
	print("cow.isEnable")
end

local var_0_46 = var_0_17
local var_0_47 = var_0_22
local var_0_48 = var_0_19
local var_0_49 = string.rep
local var_0_50 = string.format

require("util.str")

local var_0_51 = string.isobjectid
local var_0_52 = stringz.bintohex

function cow.dumps(arg_67_0, arg_67_1)
	if arg_67_0 == nil then
		return "nil"
	end

	local var_67_0 = {
		[arg_67_0] = "."
	}

	local function var_67_1(arg_68_0, arg_68_1, arg_68_2)
		if not arg_67_1 then
			arg_68_0 = var_0_37(arg_68_0)
		end

		local var_68_0 = {}
		local var_68_1 = {}

		for iter_68_0, iter_68_1 in var_0_28(arg_68_0) do
			var_0_46(var_68_1, iter_68_0)
		end

		var_0_48(var_68_1, function(arg_69_0, arg_69_1)
			if var_0_27(arg_69_0) == var_0_27(arg_69_1) then
				return arg_69_0 < arg_69_1
			end

			arg_69_0 = lua_tostring(arg_69_0)
			arg_69_1 = lua_tostring(arg_69_1)

			return arg_69_0 < arg_69_1
		end)

		for iter_68_2, iter_68_3 in var_0_29(var_68_1) do
			local var_68_2 = arg_68_0[iter_68_3]
			local var_68_3 = lua_tostring(iter_68_3)

			if var_0_51(var_68_3) then
				var_68_3 = "objectid(" .. var_0_52(var_68_3) .. ")"
			end

			if var_67_0[var_68_2] then
				var_0_46(var_68_0, "+" .. var_68_3 .. " {" .. var_67_0[var_68_2] .. "}")
			elseif var_0_27(var_68_2) == "table" then
				local var_68_4 = arg_68_2 .. "." .. var_68_3

				var_67_0[var_68_2] = var_68_4
				var_68_3 = var_68_3 .. var_0_50("(%s)", lua_tostring(var_68_2))

				var_0_46(var_68_0, "+" .. var_68_3 .. var_67_1(var_68_2, arg_68_1 .. (lua_next(var_68_1, iter_68_2) and "|" or " ") .. var_0_49(" ", #var_68_3), var_68_4))
			elseif var_0_27(var_68_2) == "function" then
				var_0_46(var_68_0, "+" .. var_68_3 .. " [" .. lua_tostring(var_68_2) .. "]")
			elseif var_0_27(var_68_2) == "string" and var_0_51(var_68_2) then
				var_0_46(var_68_0, "+" .. var_68_3 .. " [" .. "objectid" .. " " .. var_0_52(var_68_2) .. "]")
			else
				var_0_46(var_68_0, "+" .. var_68_3 .. " [" .. var_0_27(var_68_2) .. " " .. lua_tostring(var_68_2) .. "]")
			end
		end

		local var_68_5 = getmetatable(arg_68_0)

		if var_68_5 then
			local var_68_6 = var_0_50("(meta %s)", lua_tostring(var_68_5))

			if var_67_0[var_68_5] then
				var_0_46(var_68_0, "+" .. var_68_6 .. " {" .. var_67_0[var_68_5] .. "}")
			else
				local var_68_7 = arg_68_2 .. ".meta"

				var_67_0[var_68_5] = var_68_7

				var_0_46(var_68_0, "+" .. var_68_6 .. var_67_1(var_68_5, arg_68_1 .. " " .. var_0_49(" ", #var_68_6), var_68_7))
			end
		end

		return var_0_47(var_68_0, "\n" .. arg_68_1)
	end

	return var_67_1(arg_67_0, "", "")
end

function cow.dumpsToFile(arg_70_0, arg_70_1)
	local var_70_0 = cow.dumps(arg_70_0)
	local var_70_1 = io.open(arg_70_1, "w+")

	var_70_1:write(var_70_0)
	var_70_1:close()
end
