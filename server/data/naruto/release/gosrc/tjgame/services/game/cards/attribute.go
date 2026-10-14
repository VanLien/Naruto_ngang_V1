package cards

const (
	hp                   = "hp"                   // 1 - HP
	mp1                  = "mp1"                  // 2 - MP1
	initMp1              = "initMp1"              // 3 - 初始MP1
	hpRecover            = "hpRecover"            // 4 - HP回复
	mp1Recover           = "mp1Recover"           // 5 - MP1回复
	mp2Recover           = "mp2Recover"           // 6 - MP2回复
	damage               = "damage"               // 7 - 物理攻击
	specialDamage        = "specialDamage"        // 8 - 特殊攻击
	defence              = "defence"              // 9 - 物理防御力
	specialDefence       = "specialDefence"       // 10 - 特殊防御力
	defenceIgnore        = "defenceIgnore"        // 11 - 物理防御忽视
	specialDefenceIgnore = "specialDefenceIgnore" // 12 - 特殊防御忽视
	speed                = "speed"                // 13 - 先手值
	strike               = "strike"               // 14 - 暴击
	strikeDamage         = "strikeDamage"         // 15 - 暴击伤害
	strikeResistance     = "strikeResistance"     // 16 - 暴击抗性
	block                = "block"                // 17 - 格挡等级
	breakBlock           = "breakBlock"           // 18 - 破格挡等级
	blockPower           = "blockPower"           // 19 - 格挡强度
	dodge                = "dodge"                // 20 - 闪避
	hit                  = "hit"                  // 21 - 命中
	damageAdd            = "damageAdd"            // 22 - 伤害加成
	damageSub            = "damageSub"            // 23 - 伤害减免
	ultimateAdd          = "ultimateAdd"          // 24 - 必杀加成.
	ultimateSub          = "ultimateSub"          // 25 - 必杀抗性
	suckBlood            = "suckBlood"            // 26 - 吸血
	rebound              = "rebound"              // 27 - 反弹
	cure                 = "cure"                 // 28 - 治疗效果
	natureRestraint      = "natureRestraint"      // 29 - 属性克制 X
	damageDeepen         = "damageDeepen"         // 30 - 伤害加深     不同于伤害加成
	damageReduce         = "damageReduce"         // 31 - 伤害降低      不同于伤害减免

	physicalDamageAdd = "physicalDamageAdd" // 32  物理攻击伤害加成
	physicalDamageSub = "physicalDamageSub" // 33  物理攻击伤害减免
	specialDamageAdd  = "specialDamageAdd"  // 34  特殊攻击伤害加成
	specialDamageSub  = "specialDamageSub"  // 35  特殊攻击伤害减免

	// 自然属性伤害加成
	normalDamageAdd      = "normalDamageAdd"      // 36  一般系伤害加成
	fireDamageAdd        = "fireDamageAdd"        // 37  火系伤害加成
	waterDamageAdd       = "waterDamageAdd"       // 38  水系伤害加成
	grassDamageAdd       = "grassDamageAdd"       // 39  草系伤害加成
	electricityDamageAdd = "electricityDamageAdd" // 40  电系伤害加成
	iceDamageAdd         = "iceDamageAdd"         // 41  冰系伤害加成
	combatDamageAdd      = "combatDamageAdd"      // 42  格斗系伤害加成
	poisonDamageAdd      = "poisonDamageAdd"      // 43  毒系伤害加成
	groundDamageAdd      = "groundDamageAdd"      // 44  地面系伤害加成
	flyDamageAdd         = "flyDamageAdd"         // 45  飞行系伤害加成
	superDamageAdd       = "superDamageAdd"       // 46  超能系伤害加成
	wormDamageAdd        = "wormDamageAdd"        // 47  虫系伤害加成
	rockDamageAdd        = "rockDamageAdd"        // 48  岩石系伤害加成
	ghostDamageAdd       = "ghostDamageAdd"       // 49  幽灵系伤害加成
	dragonDamageAdd      = "dragonDamageAdd"      // 50  龙系伤害加成
	evilDamageAdd        = "evilDamageAdd"        // 51  恶系伤害加成
	steelDamageAdd       = "steelDamageAdd"       // 52  钢系伤害加成
	fairyDamageAdd       = "fairyDamageAdd"       // 53  妖精系伤害加成
	normalDamageSub      = "normalDamageSub"      // 54  一般系伤害减免

	// 自然属性伤害减免
	fireDamageSub        = "fireDamageSub"        // 55  火系伤害减免
	waterDamageSub       = "waterDamageSub"       // 56  水系伤害减免
	grassDamageSub       = "grassDamageSub"       // 57  草系伤害减免
	electricityDamageSub = "electricityDamageSub" // 58  电系伤害减免
	iceDamageSub         = "iceDamageSub"         // 59  冰系伤害减免
	combatDamageSub      = "combatDamageSub"      // 60  格斗系伤害减免
	poisonDamageSub      = "poisonDamageSub"      // 61  毒系伤害减免
	groundDamageSub      = "groundDamageSub"      // 62  地面系伤害减免
	flyDamageSub         = "flyDamageSub"         // 63  飞行系伤害减免
	superDamageSub       = "superDamageSub"       // 64  超能系伤害减免
	wormDamageSub        = "wormDamageSub"        // 65  虫系伤害减免
	rockDamageSub        = "rockDamageSub"        // 66  岩石系伤害减免
	ghostDamageSub       = "ghostDamageSub"       // 67  幽灵系伤害减免
	dragonDamageSub      = "dragonDamageSub"      // 68  龙系伤害减免
	evilDamageSub        = "evilDamageSub"        // 69  恶系伤害减免
	steelDamageSub       = "steelDamageSub"       // 70  钢系伤害减免
	fairyDamageSub       = "fairyDamageSub"       // 71  妖精系伤害减免
	normalCure           = "normalCure"           // 72  一般系治疗效果加成

	// 自然属性治疗效果加成
	fireCure        = "fireCure"        // 73  火系治疗效果加成
	waterCure       = "waterCure"       // 74  水系治疗效果加成
	grassCure       = "grassCure"       // 75  草系治疗效果加成
	electricityCure = "electricityCure" // 76  电系治疗效果加成
	iceCure         = "iceCure"         // 77  冰系治疗效果加成
	combatCure      = "combatCure"      // 78  格斗系治疗效果加成
	poisonCure      = "poisonCure"      // 79  毒系治疗效果加成
	groundCure      = "groundCure"      // 80  地面系治疗效果加成
	flyCure         = "flyCure"         // 81  飞行系治疗效果加成
	superCure       = "superCure"       // 82  超能系治疗效果加成
	wormCure        = "wormCure"        // 83  虫系治疗效果加成
	rockCure        = "rockCure"        // 84  岩石系治疗效果加成
	ghostCure       = "ghostCure"       // 85  幽灵系治疗效果加成
	dragonCure      = "dragonCure"      // 86  龙系治疗效果加成
	evilCure        = "evilCure"        // 87  恶系治疗效果加成
	steelCure       = "steelCure"       // 88  钢系治疗效果加成
	fairyCure       = "fairyCure"       // 89  妖精系治疗效果加成

	controlPer    = "controlPer"    // 90  控制率
	immuneControl = "immuneControl" // 91  免疫控制率
	pvpDamageAdd  = "pvpDamageAdd"  // 92  PVP伤害加成
	pvpDamageSub  = "pvpDamageSub"  // 93  PVP伤害减免
)

var AttrsEnum = []string{
	"",
	hp,
	mp1,
	initMp1,
	hpRecover,
	mp1Recover,
	mp2Recover,
	damage,
	specialDamage,
	defence,
	specialDefence,
	defenceIgnore,
	specialDefenceIgnore,
	speed,
	strike,
	strikeDamage,
	strikeResistance,
	block,
	breakBlock,
	blockPower,
	dodge,
	hit,
	damageAdd,
	damageSub,
	ultimateAdd,
	ultimateSub,
	suckBlood,
	rebound,
	cure,
	natureRestraint,
	damageDeepen,
	damageReduce,
	physicalDamageAdd,
	physicalDamageSub,
	specialDamageAdd,
	specialDamageSub,
	normalDamageAdd,
	fireDamageAdd,
	waterDamageAdd,
	grassDamageAdd,
	electricityDamageAdd,
	iceDamageAdd,
	combatDamageAdd,
	poisonDamageAdd,
	groundDamageAdd,
	flyDamageAdd,
	superDamageAdd,
	wormDamageAdd,
	rockDamageAdd,
	ghostDamageAdd,
	dragonDamageAdd,
	evilDamageAdd,
	steelDamageAdd,
	fairyDamageAdd,
	normalDamageSub,
	fireDamageSub,
	waterDamageSub,
	grassDamageSub,
	electricityDamageSub,
	iceDamageSub,
	combatDamageSub,
	poisonDamageSub,
	groundDamageSub,
	flyDamageSub,
	superDamageSub,
	wormDamageSub,
	rockDamageSub,
	ghostDamageSub,
	dragonDamageSub,
	evilDamageSub,
	steelDamageSub,
	fairyDamageSub,
	normalCure,
	fireCure,
	waterCure,
	grassCure,
	electricityCure,
	iceCure,
	combatCure,
	poisonCure,
	groundCure,
	flyCure,
	superCure,
	wormCure,
	rockCure,
	ghostCure,
	dragonCure,
	evilCure,
	steelCure,
	fairyCure,
	controlPer,
	immuneControl,
	pvpDamageAdd,
	pvpDamageSub,
}

// 个体值属性
var NValueAttrs = []string{hp, speed, damage, defence, specialDamage, specialDefence}
