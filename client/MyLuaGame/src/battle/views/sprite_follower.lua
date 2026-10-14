globals.BattleFollowerSprite = class("BattleFollowerSprite", BattleSprite)

function BattleFollowerSprite.updHitPanel(arg_1_0)
	return
end

function BattleFollowerSprite.showHero(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.lifebar:setVisible(arg_2_1 and not arg_2_2.hideLife)
	arg_2_0:setVisible(arg_2_1)
end
