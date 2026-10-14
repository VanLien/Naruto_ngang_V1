globals.CStageLayerModel = class("CStageLayerModel")

function CStageLayerModel.ctor(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.battleView = arg_1_1
	arg_1_0.csv = arg_1_2
	arg_1_0.x = 0
	arg_1_0.y = 0
	arg_1_0.xloopCount = 1
	arg_1_0.yloopCount = 1
	arg_1_0.lastAddCount = 0
end

function CStageLayerModel.init(arg_2_0)
	arg_2_0.xtileSize = 1
	arg_2_0.ytileSize = 1
	arg_2_0.x = arg_2_0.csv.x
	arg_2_0.y = arg_2_0.csv.y

	local var_2_0 = math.ceil(CC_DESIGN_RESOLUTION.width / arg_2_0.csv.xlength) + 1
	local var_2_1 = math.ceil(CC_DESIGN_RESOLUTION.height / arg_2_0.csv.ylength) + 1

	if arg_2_0.csv.xloop == 0 then
		arg_2_0.xtileSize = var_2_0
		arg_2_0.xloopCount = -99999999
	elseif arg_2_0.csv.xloop > 2 then
		local var_2_2 = var_2_0 <= arg_2_0.csv.xloop and var_2_0 or arg_2_0.csv.xloop

		arg_2_0.xtileSize = var_2_2
		arg_2_0.xloopCount = var_2_2
	elseif arg_2_0.csv.xloop == 2 then
		arg_2_0.xtileSize = 2
		arg_2_0.xloopCount = 2
	end

	if arg_2_0.csv.yloop == 0 then
		arg_2_0.ytileSize = var_2_1
		arg_2_0.yloopCount = -99999999
	elseif arg_2_0.csv.yloop > 2 then
		local var_2_3 = var_2_1 <= arg_2_0.csv.yloop and var_2_1 or arg_2_0.csv.yloop

		arg_2_0.ytileSize = var_2_3
		arg_2_0.yloopCount = var_2_3
	elseif arg_2_0.csv.yloop == 2 then
		arg_2_0.ytileSize = 2
		arg_2_0.yloopCount = 2
	end

	local var_2_4 = {
		id = tostring(arg_2_0),
		config = arg_2_0.csv,
		x = arg_2_0.x,
		y = arg_2_0.y,
		xtileSize = arg_2_0.xtileSize,
		xlength = arg_2_0.csv.xlength,
		ytileSize = arg_2_0.ytileSize,
		ylength = arg_2_0.csv.ylength
	}

	arg_2_0.battleView:onViewProxyNotify("AddGround", var_2_4)
end

function CStageLayerModel.updateSelf(arg_3_0, arg_3_1)
	local var_3_0 = -arg_3_0.csv.x_speed * arg_3_1 / 1000
	local var_3_1 = -arg_3_0.csv.y_speed * arg_3_1 / 1000

	if var_3_0 == 0 and var_3_1 == 0 then
		return
	end

	arg_3_0.x = arg_3_0.x + var_3_0
	arg_3_0.y = arg_3_0.y + var_3_1

	if arg_3_0.xloopCount < arg_3_0.csv.xloop and -arg_3_0.x >= arg_3_0.csv.xlength then
		arg_3_0.x = arg_3_0.csv.xlength + arg_3_0.x
		arg_3_0.xloopCount = arg_3_0.xloopCount + 1
	elseif arg_3_0.xloopCount < arg_3_0.csv.xloop and arg_3_0.csv.x_speed < 0 and arg_3_0.x >= arg_3_0.csv.xlength then
		arg_3_0.x = arg_3_0.x - arg_3_0.csv.xlength
		arg_3_0.xloopCount = arg_3_0.xloopCount + 1
	end

	if arg_3_0.yloopCount < arg_3_0.csv.yloop and -arg_3_0.y >= arg_3_0.csv.ylength then
		arg_3_0.y = arg_3_0.csv.ylength + arg_3_0.y
		arg_3_0.yloopCount = arg_3_0.yloopCount + 1
	elseif arg_3_0.yloopCount < arg_3_0.csv.yloop and arg_3_0.csv.y_speed < 0 and arg_3_0.y >= arg_3_0.csv.ylength then
		arg_3_0.y = arg_3_0.y - arg_3_0.csv.ylength
		arg_3_0.yloopCount = arg_3_0.yloopCount + 1
	end

	local var_3_2 = {
		id = tostring(arg_3_0),
		config = arg_3_0.csv,
		x = arg_3_0.x,
		y = arg_3_0.y,
		xtileSize = arg_3_0.xtileSize,
		xlength = arg_3_0.csv.xlength,
		ytileSize = arg_3_0.ytileSize,
		ylength = arg_3_0.csv.ylength
	}

	arg_3_0.battleView:onViewProxyNotify("MoveGround", var_3_2)
end
