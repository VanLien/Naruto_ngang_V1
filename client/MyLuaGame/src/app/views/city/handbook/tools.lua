return {
	setAttrPanel = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		local var_1_0 = arg_1_0:multiget("imgAttr", "textName", "textNum")

		var_1_0.imgAttr:texture(arg_1_1)
		var_1_0.textName:text(arg_1_2)
		var_1_0.textNum:text("+" .. arg_1_3)
		adapt.oneLinePos(var_1_0.imgAttr, var_1_0.textName, cc.p(25, 0))
		adapt.oneLinePos(var_1_0.textName, var_1_0.textNum, cc.p(15, 0))
	end,
	getStarAttrData = function(arg_2_0)
		local var_2_0 = gPokedexDevelop[arg_2_0][1].attrType1
		local var_2_1 = game.ATTRDEF_TABLE[var_2_0]
		local var_2_2 = gLanguageCsv["attr" .. string.caption(var_2_1)]
		local var_2_3 = ui.ATTR_LOGO[game.ATTRDEF_TABLE[var_2_0]]
		local var_2_4 = "0%"
		local var_2_5, var_2_6, var_2_7 = dataEasy.getCardMaxStar(arg_2_0)

		if var_2_5 > 0 then
			var_2_4 = gPokedexDevelop[arg_2_0][var_2_5].attrValue1
		end

		return var_2_3, var_2_2, var_2_4
	end
}
