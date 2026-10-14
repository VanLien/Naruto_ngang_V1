package game

var CardAttrDefs = map[int]string{
	1:  "hp",                   // HP
	2:  "mp1",                  // MP1
	3:  "initMp1",              // 初始MP1
	4:  "hpRecover",            // HP回复
	5:  "mp1Recover",           // MP1回复
	6:  "mp2Recover",           // MP2回复
	7:  "damage",               // 物理攻击
	8:  "specialDamage",        // 特殊攻击
	9:  "defence",              // 物理防御力
	10: "specialDefence",       // 特殊防御力
	11: "defenceIgnore",        // 物理防御忽视
	12: "specialDefenceIgnore", // 特殊防御忽视
	13: "speed",                // 先手值
	14: "strike",               // 暴击
	15: "strikeDamage",         // 暴击伤害
	16: "strikeResistance",     // 暴击抗性
	17: "block",                // 格挡等级
	18: "breakBlock",           // 破格挡等级
	19: "blockPower",           // 格挡强度
	20: "dodge",                // 闪避
	21: "hit",                  // 命中
	22: "damageAdd",            // 伤害加成
	23: "damageSub",            // 伤害减免
	24: "ultimateAdd",          // 必杀加成.
	25: "ultimateSub",          // 必杀抗性
	26: "suckBlood",            // 吸血
	27: "rebound",              // 反弹
	28: "cure",                 // 治疗效果
	29: "natureRestraint",      // 属性克制 X
	30: "damageDeepen",         // 伤害加深     不同于伤害加成
	31: "damageReduce",         // 伤害降低      不同于伤害减免
	32: "physicalDamageAdd",    // 物理攻击伤害加成
	33: "physicalDamageSub",    // 物理攻击伤害减免
	34: "specialDamageAdd",     // 特殊攻击伤害加成
	35: "specialDamageSub",     // 特殊攻击伤害减免

	// 自然属性伤害加成
	36: "normalDamageAdd",      //一般系伤害加成
	37: "fireDamageAdd",        //火系伤害加成
	38: "waterDamageAdd",       //水系伤害加成
	39: "grassDamageAdd",       //草系伤害加成
	40: "electricityDamageAdd", //电系伤害加成
	41: "iceDamageAdd",         //冰系伤害加成
	42: "combatDamageAdd",      //格斗系伤害加成
	43: "poisonDamageAdd",      //毒系伤害加成
	44: "groundDamageAdd",      //地面系伤害加成
	45: "flyDamageAdd",         //飞行系伤害加成
	46: "superDamageAdd",       //超能系伤害加成
	47: "wormDamageAdd",        //虫系伤害加成
	48: "rockDamageAdd",        //岩石系伤害加成
	49: "ghostDamageAdd",       //幽灵系伤害加成
	50: "dragonDamageAdd",      //龙系伤害加成
	51: "evilDamageAdd",        //恶系伤害加成
	52: "steelDamageAdd",       //钢系伤害加成
	53: "fairyDamageAdd",       //妖精系伤害加成

	// 自然属性伤害减免
	54: "normalDamageSub",      //一般系伤害减免
	55: "fireDamageSub",        //火系伤害减免
	56: "waterDamageSub",       //水系伤害减免
	57: "grassDamageSub",       //草系伤害减免
	58: "electricityDamageSub", //电系伤害减免
	59: "iceDamageSub",         //冰系伤害减免
	60: "combatDamageSub",      //格斗系伤害减免
	61: "poisonDamageSub",      //毒系伤害减免
	62: "groundDamageSub",      //地面系伤害减免
	63: "flyDamageSub",         //飞行系伤害减免
	64: "superDamageSub",       //超能系伤害减免
	65: "wormDamageSub",        //虫系伤害减免
	66: "rockDamageSub",        //岩石系伤害减免
	67: "ghostDamageSub",       //幽灵系伤害减免
	68: "dragonDamageSub",      //龙系伤害减免
	69: "evilDamageSub",        //恶系伤害减免
	70: "steelDamageSub",       //钢系伤害减免
	71: "fairyDamageSub",       //妖精系伤害减免

	// 自然属性治疗效果加成
	72: "normalCure",      //一般系治疗效果加成
	73: "fireCure",        //火系治疗效果加成
	74: "waterCure",       //水系治疗效果加成
	75: "grassCure",       //草系治疗效果加成
	76: "electricityCure", //电系治疗效果加成
	77: "iceCure",         //冰系治疗效果加成
	78: "combatCure",      //格斗系治疗效果加成
	79: "poisonCure",      //毒系治疗效果加成
	80: "groundCure",      //地面系治疗效果加成
	81: "flyCure",         //飞行系治疗效果加成
	82: "superCure",       //超能系治疗效果加成
	83: "wormCure",        //虫系治疗效果加成
	84: "rockCure",        //岩石系治疗效果加成
	85: "ghostCure",       //幽灵系治疗效果加成
	86: "dragonCure",      //龙系治疗效果加成
	87: "evilCure",        //恶系治疗效果加成
	88: "steelCure",       //钢系治疗效果加成
	89: "fairyCure",       //妖精系治疗效果加成

	90: "controlPer",    //控制率
	91: "immuneControl", //免疫控制率
	92: "pvpDamageAdd",  //PVP伤害加成
	93: "pvpDamageSub",  //PVP伤害减免

	94: "damageHit",   //伤害命中
	95: "damageDodge", //伤害闪避
}
