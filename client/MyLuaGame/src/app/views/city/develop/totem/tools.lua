local var_0_0 = {
	dotArrangeType = {
		{
			5
		},
		{
			1,
			9
		},
		{
			1,
			5,
			9
		},
		{
			1,
			3,
			7,
			9
		},
		{
			1,
			3,
			5,
			7,
			9
		},
		{
			1,
			3,
			4,
			5,
			7,
			9
		},
		{
			1,
			3,
			4,
			5,
			6,
			7,
			9
		},
		{
			1,
			3,
			4,
			5,
			6,
			7,
			8,
			9
		},
		{
			1,
			2,
			3,
			4,
			5,
			6,
			7,
			8,
			9
		}
	},
	totemPosition = {
		{
			{
				800,
				550
			}
		},
		{
			{
				350,
				550
			},
			{
				1250,
				550
			}
		},
		{
			{
				800,
				1000
			},
			{
				425,
				250
			},
			{
				1175,
				250
			}
		},
		{
			{
				425,
				850
			},
			{
				1175,
				850
			},
			{
				425,
				250
			},
			{
				1175,
				250
			}
		},
		{
			{
				425,
				850
			},
			{
				1175,
				850
			},
			{
				800,
				550
			},
			{
				425,
				250
			},
			{
				1175,
				250
			}
		},
		{
			{
				475,
				900
			},
			{
				1125,
				900
			},
			{
				350,
				550
			},
			{
				1250,
				550
			},
			{
				475,
				200
			},
			{
				1125,
				200
			}
		},
		{
			{
				475,
				900
			},
			{
				1125,
				900
			},
			{
				350,
				550
			},
			{
				800,
				550
			},
			{
				1250,
				550
			},
			{
				475,
				200
			},
			{
				1125,
				200
			}
		},
		{
			{
				835,
				965
			},
			{
				835,
				760
			},
			{
				620,
				630
			},
			{
				1050,
				630
			},
			{
				380,
				525
			},
			{
				1285,
				525
			},
			{
				620,
				411
			},
			{
				1050,
				411
			}
		},
		{
			{
				835,
				965
			},
			{
				835,
				760
			},
			{
				620,
				630
			},
			{
				1050,
				630
			},
			{
				380,
				525
			},
			{
				1285,
				525
			},
			{
				835,
				525
			},
			{
				620,
				411
			},
			{
				1050,
				411
			}
		}
	},
	panelOffset = {
		{
			60,
			-400
		},
		{
			85,
			-475
		},
		{
			85,
			-510
		}
	},
	panelReflect = {
		1,
		1,
		1,
		1,
		2,
		2,
		2,
		3,
		3
	}
}

local function var_0_1(arg_1_0)
	local var_1_0 = ccui.Layout:create()
	local var_1_1 = ccui.ImageView:create(csv.items[arg_1_0.csvId].icon):scale(arg_1_0.scale or 1)
	local var_1_2 = var_1_1:size()

	var_1_0:size(var_1_2.width, var_1_2.height)
	var_1_1:xy(var_1_2.width / 2, var_1_2.height / 2):addTo(var_1_0, 2, "icon")

	return var_1_0
end

function var_0_0.getTotemMap(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0:removeAllChildren()

	arg_2_2 = arg_2_2 and arg_2_2 or {}

	local var_2_0 = csv.totem.symbol[arg_2_1]
	local var_2_1 = cc.size(800, 400)
	local var_2_2 = ccui.Layout:create():size(var_2_1.width, var_2_1.height):alignCenter(arg_2_0:size()):addTo(arg_2_0, 1, "_panel_")
	local var_2_3 = ccui.ImageView:create("city/develop/totem/img_stone.png"):xy(var_2_1.width / 2, var_2_1.height / 2):scale(arg_2_2.scale or 1):addTo(var_2_2, 2, "bg")
	local var_2_4 = {}

	for iter_2_0, iter_2_1 in pairs(var_2_0.totemGroup1) do
		local var_2_5 = var_0_1({
			csvId = iter_2_1
		})

		var_2_5:addTo(var_2_2, 10, "item" .. iter_2_0):xy(iter_2_0 * 100, iter_2_0 * 110)
		table.insert(var_2_4, var_2_5)
	end

	return var_2_4
end

function var_0_0.refreshData(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0, var_3_1, var_3_2 = require("easy.bind.helper").dataOrIdler(arg_3_1.data)

	if var_3_0 then
		local var_3_3 = var_3_0

		idlereasy.any({
			arg_3_0
		}, function(arg_4_0, arg_4_1)
			local var_4_0 = 1
			local var_4_1, var_4_2 = var_0_0.getBgNode(arg_3_2, arg_4_1, arg_3_1)

			for iter_4_0, iter_4_1 in pairs(var_3_3) do
				local var_4_3 = var_0_0.getOneNode(var_4_1, arg_4_1, var_4_0, arg_3_1)

				if arg_3_1.onItem then
					var_4_3.setTouchEnabled(var_4_3, true)
					arg_3_1.onItem(var_4_3, iter_4_0, iter_4_1)
				end

				var_4_0 = var_4_0 + 1
			end

			if arg_3_1.bgScale then
				var_4_1.scale(var_4_1, arg_3_1.bgScale)
			else
				var_4_1.scale(var_4_1, var_4_2)
			end
		end)

		return
	end

	local var_3_4 = var_3_1 and var_3_1 or var_3_2

	idlereasy.any({
		arg_3_0,
		var_3_4
	}, function(arg_5_0, arg_5_1, arg_5_2)
		local var_5_0 = 1
		local var_5_1, var_5_2 = var_0_0.getBgNode(arg_3_2, arg_5_1, arg_3_1)

		for iter_5_0, iter_5_1 in pairs(arg_5_2) do
			local var_5_3 = var_0_0.getOneNode(var_5_1, arg_5_1, var_5_0, arg_3_1)

			if arg_3_1.onItem then
				var_5_3:setTouchEnabled(true)
				arg_3_1.onItem(var_5_3, iter_5_0, iter_5_1)
			end

			var_5_0 = var_5_0 + 1
		end

		if arg_3_1.bgScale then
			var_5_1:scale(arg_3_1.bgScale)
		else
			var_5_1:scale(var_5_2)
		end
	end)
end

function var_0_0.getBgNode(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:removeAllChildren()

	arg_6_2 = arg_6_2 and arg_6_2 or {}

	local var_6_0 = 1
	local var_6_1 = csv.totem.symbol[arg_6_1]
	local var_6_2 = itertools.size(var_6_1.totemGroup1) or 3
	local var_6_3 = ccui.ImageView:create(string.format("city/develop/totem/img_stone_%d.png", var_0_0.panelReflect[var_6_2])):size()

	if var_6_3.height > 500 then
		var_6_0 = 500 / var_6_3.height
	end

	local var_6_4 = ccui.Layout:create():size(var_6_3.width, var_6_3.height):alignCenter(arg_6_0:size()):addTo(arg_6_0, 1, "_panel_")
	local var_6_5 = itertools.size(var_6_1.totemGroup1)
	local var_6_6 = csv.totem.symbol_group[var_6_1.symbolGroupType].spineAnimation
	local var_6_7 = string.format("%s_%d_hou_loop", var_6_6, var_0_0.panelReflect[var_6_5])
	local var_6_8 = ({
		{
			-12,
			-270
		},
		{
			-8,
			-300
		},
		{
			-10,
			-305
		}
	})[var_0_0.panelReflect[var_6_2]]

	widget.addAnimationByKey(var_6_4, "tuteng/tutengdx.skel", "bgSpine", var_6_7, 5):scale(1):xy(var_6_3.width / 2 + var_6_8[1], var_6_3.height / 2 + var_6_8[2])

	return var_6_4, var_6_0
end

var_0_0.offset = {
	{
		400,
		45
	},
	{
		400,
		45
	},
	{
		400,
		45
	},
	{
		400,
		45
	},
	{
		300,
		0
	},
	{
		300,
		0
	},
	{
		300,
		0
	},
	{
		165,
		-90
	},
	{
		165,
		-90
	}
}

function var_0_0.getOneNode(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = csv.totem.symbol[arg_7_1]
	local var_7_1 = var_0_1({
		csvId = var_7_0.totemGroup1[arg_7_2]
	})
	local var_7_2 = itertools.size(var_7_0.totemGroup1) or 3
	local var_7_3 = var_0_0.offset[var_7_2][1]
	local var_7_4 = var_0_0.offset[var_7_2][2]

	var_7_1:scale(arg_7_3.scale or 1):addTo(arg_7_0, 10, "item" .. arg_7_2):xy((var_0_0.totemPosition[var_7_2][arg_7_2][1] - var_7_3) / 2, (var_0_0.totemPosition[var_7_2][arg_7_2][2] - var_7_4) / 2)

	return var_7_1
end

function var_0_0.initData(arg_8_0, arg_8_1, arg_8_2)
	var_0_0.refreshData(arg_8_1, arg_8_2, arg_8_0)
end

function var_0_0.getActivateTotem(arg_9_0)
	local var_9_0 = csv.totem.symbol
	local var_9_1 = {}

	for iter_9_0, iter_9_1 in pairs(arg_9_0) do
		if var_9_0[iter_9_0] and itertools.size(var_9_0[iter_9_0].totemGroup1) <= itertools.size(iter_9_1) then
			table.insert(var_9_1, iter_9_0)
		end
	end

	return var_9_1
end

function var_0_0.getActivateTotemEnergy(arg_10_0)
	local var_10_0 = var_0_0.getActivateTotem(arg_10_0)
	local var_10_1 = 0

	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		var_10_1 = var_10_1 + csv.totem.symbol[iter_10_1].power
	end

	return var_10_1
end

return var_0_0
