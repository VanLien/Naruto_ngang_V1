globals.ObjectExtraModel = class("ObjectExtraModel", ObjectModel)

local var_0_0 = battle.PassiveSkillTypes

function ObjectExtraModel.ctor(arg_1_0, arg_1_1, arg_1_2)
	ObjectModel.ctor(arg_1_0, arg_1_1, arg_1_2)
end

function ObjectExtraModel.init(arg_2_0, arg_2_1)
	arg_2_0.followArgs = arg_2_1.followArgs

	ObjectModel.init(arg_2_0, arg_2_1)
end

function ObjectExtraModel.addObjViewToScene(arg_3_0)
	local var_3_0 = {
		type = battle.SpriteType.Follower,
		offsetPos = cc.p(arg_3_0.followArgs.x or -100, arg_3_0.followArgs.y or 100)
	}

	arg_3_0.view = gRootViewProxy:getProxy("onSceneAddObj", tostring(arg_3_0), readOnlyProxy(arg_3_0, {
		hp = function()
			return arg_3_0:hp(true)
		end,
		mp1 = function()
			return arg_3_0:mp1(true)
		end,
		setHP = function(arg_6_0, arg_6_1)
			return arg_3_0:setHP(nil, arg_6_1)
		end,
		setMP1 = function(arg_7_0, arg_7_1)
			return arg_3_0:setMP1(nil, arg_7_1)
		end
	}), var_3_0)
end

function ObjectExtraModel.delBuffsWithSelf(arg_8_0)
	local var_8_0

	var_8_0 = arg_8_0.force == 1 and 2 or 1

	for iter_8_0, iter_8_1 in arg_8_0.scene.extraHeros:order_pairs() do
		if not iter_8_1:isAlreadyDead() and iter_8_1:isBeInSneer() and iter_8_1:getSneerObj() and iter_8_1:getSneerObj().id == arg_8_0.id then
			for iter_8_2, iter_8_3 in iter_8_1:iterBuffsWithEasyEffectFunc("sneer") do
				if iter_8_3.csvCfg.easyEffectFunc == "sneer" then
					iter_8_3:overClean()
				end
			end
		end
	end
end

function ObjectExtraModel.recordRealDeadHpMaxSum(arg_9_0)
	return
end

function ObjectExtraModel.addAttackerMpOnSelfDead(arg_10_0, arg_10_1)
	return
end
