globals.ConstSaltNumbers = table.salttable({
	dot05 = 0.05,
	wan = 10000,
	dot96 = 0.96,
	zero = 0,
	dot01 = 0.01,
	neg1 = -1,
	dot1 = 0.1,
	one15 = 1.15,
	one = 1
})

local var_0_0 = {}

globals.battle = var_0_0
var_0_0.SpeedTimeScale = {
	1.1,
	1.6,
	2.5,
	double = 1.6,
	single = 1.1,
	ultAcc = 10,
	triple = 2.5
}

local var_0_1 = {
	{
		x = 956,
		y = 826 - display.fightLower
	},
	{
		x = 792,
		y = 592 - display.fightLower
	},
	{
		x = 640,
		y = 348 - display.fightLower
	},
	{
		x = 600,
		y = 826 - display.fightLower
	},
	{
		x = 430,
		y = 592 - display.fightLower
	},
	{
		x = 244,
		y = 348 - display.fightLower
	},
	[13] = {
		x = display.width / 2,
		y = 826 - display.fightLower
	},
	[14] = {
		x = display.width / 2,
		y = 826 - display.fightLower
	},
	[99] = {
		x = 0,
		y = 9999
	}
}

var_0_0.StandingPos = var_0_1
var_0_0.PauseNoShowStarConditionsGateType = {
	[game.GATE_TYPE.endlessTower] = true,
	[game.GATE_TYPE.test] = true,
	[game.GATE_TYPE.arena] = true,
	[game.GATE_TYPE.crossArena] = true,
	[game.GATE_TYPE.randomTower] = true,
	[game.GATE_TYPE.crossOnlineFight] = true,
	[game.GATE_TYPE.gym] = true,
	[game.GATE_TYPE.gymLeader] = true,
	[game.GATE_TYPE.crossMine] = true,
	[game.GATE_TYPE.crossMineBoss] = true,
	[game.GATE_TYPE.braveChallenge] = true,
	[game.GATE_TYPE.hunting] = true,
	[game.GATE_TYPE.summerChallenge] = true
}
var_0_0.EndSpecialCheck = {
	AllHpRatioCheck = 4,
	FightPoint = 5,
	SoloSpecialRule = 7,
	HpRatioCheck = 2,
	LastWaveTotalDamage = 8,
	EnemyOnlySummonOrAllDead = 10,
	DirectWin = 9,
	TotalHpCheck = 3,
	BothDead = 11,
	ForceNum = 1,
	CumulativeSpeedSum = 6
}
var_0_0.MainSkillType = {
	NormalSkill = 0,
	PassiveSkill = 3,
	BigSkill = 2,
	TagSkill = 99,
	SmallSkill = 1
}
var_0_0.SkillType = {
	NormalSkill = 0,
	PassiveSkill = 3,
	PassiveAdd = 1,
	PassiveAura = 2,
	PassiveCombine = 5,
	PassiveSummon = 4
}
var_0_0.SkillAddBuffType = {
	Before = 1,
	InPlay = 3,
	After = 2
}
var_0_0.SkillFormulaType = {
	resumeHp = 2,
	fix = 3,
	damage = 1
}
var_0_0.SkillSegType = {
	resumeHp = "resumeHp",
	damage = "damage",
	buff = "buff"
}
var_0_0.AttackPosIndex = {
	center = 13,
	selfPos = 14
}
var_0_0.AttackPos = {
	{
		x = var_0_1[1].x + 200,
		y = var_0_1[1].y
	},
	{
		x = var_0_1[2].x + 200,
		y = var_0_1[2].y
	},
	{
		x = var_0_1[3].x + 200,
		y = var_0_1[3].y
	},
	{
		x = var_0_1[4].x + 200,
		y = var_0_1[4].y
	},
	{
		x = var_0_1[5].x + 200,
		y = var_0_1[5].y
	},
	{
		x = var_0_1[6].x + 200,
		y = var_0_1[6].y
	},
	[13] = {
		x = display.width / 2,
		y = var_0_1[2].y
	}
}
var_0_0.ProtectPosIdx = {
	centerRight = 14,
	centerLeft = 13
}
var_0_0.ProtectPos = {
	{
		x = var_0_1[1].x + 150,
		y = var_0_1[1].y
	},
	{
		x = var_0_1[2].x + 150,
		y = var_0_1[2].y
	},
	{
		x = var_0_1[3].x + 150,
		y = var_0_1[3].y
	},
	{
		x = var_0_1[4].x + 150,
		y = var_0_1[4].y
	},
	{
		x = var_0_1[5].x + 150,
		y = var_0_1[5].y
	},
	{
		x = var_0_1[6].x + 150,
		y = var_0_1[6].y
	},
	[13] = {
		x = display.width / 2 - 150,
		y = var_0_1[2].y
	},
	[14] = {
		x = display.width / 2 + 150,
		y = var_0_1[2].y
	}
}
var_0_0.SpriteRes = {
	natureQuan = "effect/xuanzhongkuang.skel",
	fireShield = "effect/xuetiao_loop.skel",
	mainSkill = "effect/dz_ice.skel",
	groundRing = "effect/jiaodixzk.skel",
	natureQuanTxtDi = "battle/logo_gray.png"
}
var_0_0.SpecialObjectId = {
	teamShiled = 13
}
var_0_0.ShowHeadNumberRes = {
	txtBj = "battle/txt/txt_bj.png",
	txtKzDi = "battle/txt/bg_kz_di.png",
	txtSpecialImmune = "battle/txt/txt_tgshmy.png",
	txtSb = "battle/txt/txt_sb.png",
	txtPhysicalImmune = "battle/txt/txt_wgshmy.png",
	txtZlszDi = "battle/txt/bg_zlsz_di.png",
	fontBj = "cross_craft",
	txtFs = "battle/txt/txt_fs.png",
	fontZlsz = "zlsz",
	txtTypeImmune = "battle/txt/txt_my%s.png",
	txtStrong = "battle/txt/txt_xgbq.png",
	txtWeak = "battle/txt/txt_sxsw.png",
	fontKz = "kz",
	txtFullweak = "battle/txt/txt_myxg.png",
	txtBjDi = "battle/txt/bg_bj_di.png",
	txtFj = "battle/txt/txt_fj.png",
	txtXx = "battle/txt/txt_xx.png",
	txtGd = "battle/txt/txt_gd.png",
	txtPtshDi = "battle/txt/bg_ptsh_di.png",
	txtAllImmune = "battle/txt/txt_mysh.png",
	fontPtsh = "bj"
}
var_0_0.MainAreaRes = {
	txtNqz = "battle/txt/txt_nqjl.png",
	fontZsh = "zsh",
	fontZzl = "zzl",
	txtZzl = "battle/txt/txt_zzl.png",
	txtZsh = "battle/txt/txt_zsh.png",
	fontNqz = "font/digital_nqjl.png",
	diZzl = "battle/txt/bg_zzl_di.png",
	waveDiTu = "battle/img_pc.png"
}
var_0_0.StageRes = {
	kaiping = "effect/kaiping.skel",
	daZhaoBJ = "effect/dazhao_bj.skel"
}
var_0_0.SpriteLayerZOrder = {
	ground = 9,
	quan = 14,
	mainSkill = 15,
	qipao = 9500,
	selfSpr = 10,
	lifebar = 12
}
var_0_0.GameLayerZOrder = {
	text = 9999,
	icon = 8000,
	overlay = 8500
}
var_0_0.AssignLayer = {
	stageLayer = 0,
	effectLayer = 4,
	effectLayerLower = 3,
	gameLayer = 2,
	frontStageLayer = 5,
	roleLayer = 1
}
var_0_0.EffectZOrder = {
	dead = 9999,
	none = 0
}
var_0_0.LoopActionMap = {
	stun_loop = true,
	run_loop = true,
	win_loop = true,
	standby_loop = true
}
var_0_0.EffectEventArgFields = {
	sound = {
		"sound"
	},
	shaker = {
		"shaker",
		"segInterval"
	},
	music = {
		"music"
	},
	move = {
		"move"
	},
	show = {
		"show"
	},
	damageSeg = {
		"damageSeg",
		"segInterval"
	},
	hpSeg = {
		"hpSeg",
		"segInterval"
	},
	effect = {
		"effectType",
		"effectRes",
		"effectArgs"
	},
	zOrder = {
		"zOrder"
	},
	follow = {
		"follow"
	},
	jump = {
		"jumpFlag"
	},
	control = {
		"control"
	}
}
var_0_0.FilterDeferListTag = {
	cantJump = 1,
	cantClean = 2,
	none = 0
}
var_0_0.SpriteActionTable = {
	hit = "hit",
	run = "run_loop",
	death = "death",
	hit2 = "hit2",
	attack = "attack",
	charging = "charging",
	standby = "standby_loop"
}
var_0_0.OperateTable = {
	choose = 8,
	helper = 10,
	noAttack = 11,
	autoFight = 6,
	pass = 12,
	fullManual = 14,
	ultAcc = 15,
	story = 7,
	runAway = 13,
	ultAccEnd = 16,
	skill = 1,
	pause = 2,
	attack = 9,
	timeScale = 3,
	passOneWave = 17
}
var_0_0.DefaultModes = {}
var_0_0.PassiveSkillTypes = {
	round = 1,
	beDeathAttack = 5,
	beSpecialDamage = 17,
	roundEnd = 9,
	realDead = 3,
	beDamageIfFullHp = 15,
	cycleRound = 2,
	beWeather = 20,
	beAttack = 6,
	kill = 10,
	beNonNatureDamage = 14,
	beToolsComsumed = 22,
	attack = 8,
	beDamage = 16,
	enter = 7,
	beSpeciaSelfForce = 19,
	teamHpLess = 25,
	roundStartAttack = 23,
	recoverHp = 26,
	hpLess = 18,
	additional = 27,
	dynamicTeamHpLess = 28,
	beNatureDamage = 13,
	fakeDead = 4,
	beStrike = 12,
	create = 0,
	roundStart = 29,
	dynamicHpLess = 24,
	beSpecialNatureDamage = 11,
	beSpeciaBuff = 21
}
var_0_0.PassiveRoundEndFlag = {
	Round = 1,
	SelfBattleTurn = 0
}
var_0_0.SkillAttrsInCsv = {
	"cdRound",
	"skillHit",
	"startRound",
	"skillPower",
	"skillNatureType"
}
var_0_0.ControllBuffType = {
	sleepy = true,
	silence = true,
	stun = true,
	leave = true,
	changeImage = true,
	sneer = true,
	freeze = true
}
var_0_0.RestraintTypeIcon = {
	physical = "battle/txt_mywg.png",
	allimmune = "battle/txt_mysh.png",
	weak = "battle/logo_dk.png",
	strong = "battle/logo_kz.png",
	fullweak = "battle/logo_myxg.png",
	special = "battle/txt_mytg.png"
}
var_0_0.BuffTriggerPoint = {
	onRoundStart = 3,
	onBattleTurnStart = 32,
	onHolderCounterAttack = 23,
	onBuffControlEnd = 22,
	onHolderHpChange = 18,
	onHolderBattleTurnStart = 5,
	onHolderMateKilledBySkill = 16,
	onHolderAttackEnd = 8,
	onBuffOverDispel = 20,
	onHolderMakeTargetRealDeath = 37,
	onBuffOver = 2,
	onHolderShieldBreak = 33,
	onHolderRealDeath = 13,
	onHolderBackStage = 35,
	onHolderAfterHit = 36,
	onHolderKillHandleChooseTarget = 15,
	onHolderBeForeSkillSpellTo = 25,
	onHolderBeforeBeHit = 14,
	onRoundEnd = 4,
	onBuffOverlay = 21,
	onHolderAfterEnter = 38,
	onHolderFinallyBeHit = 10,
	onHolderFakeDeath = 31,
	onHolderLethal = 39,
	onHolderDeath = 12,
	onBuffTrigger = 28,
	onHolderCalcDamageProb = 40,
	onBuffOverNormal = 19,
	onNodeCall = 0,
	onBuffCreate = 1,
	onBuffBeAdd = 29,
	onHolderAfterRefreshTargets = 30,
	onHolderShieldChange = 41,
	onHolderAfterBeHit = 17,
	onHolderKillTarget = 11,
	onHolderToAttack = 24,
	onHolderBeHit = 9,
	onChargeBeInterrupted = 43,
	onHolderBattleTurnEnd = 6,
	onHolderAttackBefore = 7,
	onHolderReborn = 26,
	onHolderMp1Change = 34,
	onHolderHpAdd = 27,
	onHolderMp1Overflow = 44,
	onBattleTurnEnd = 42
}
var_0_0.DamageFrom = {
	rebound = 2,
	skill = 3,
	buff = 1
}
var_0_0.DamageFromExtra = {
	protect = 203,
	allocate = 201,
	link = 202
}
var_0_0.ResumeHpFrom = {
	suckblood = 103,
	skill = 102,
	buff = 101
}
var_0_0.BuffExtraTargetType = {
	skillOwner = 15,
	surroundCasterNoDath = 10,
	holder = 1,
	triggerObject = 20,
	killHolder = 16,
	surroundHolderNoDath = 4,
	casterEnemyForceRandom = 17,
	holderBeAttackFrom = 7,
	casterForce = 11,
	skillAllDamageTargets = 8,
	segProcessTargets = 18,
	caster = 2,
	surroundHolderKill = 19,
	casterEnemyForce = 14,
	lastProcessTargets = 6,
	holderForceNoDeathRandom = 3,
	holderEnemyForce = 13,
	overLayBuffCaster = 12,
	casterForceNoDeathRandom = 9,
	holderForce = 5
}
var_0_0.copyOrTransferSpecType = {
	eachCaster = 100
}
var_0_0.UITag = {
	pvpOpening = 2,
	passCD = 1
}
var_0_0.SkillDamageType = {
	True = 2,
	Physical = 0,
	Special = 1
}
var_0_0.CounterAttackMode = {
	smallSkill = 2,
	bigSkill = 3,
	onlyAttack = 1
}
var_0_0.ValueType = {
	valid = 3,
	overFlow = 2,
	normal = 1
}
var_0_0.DamageProcess = {
	"damageHit",
	"nature",
	"damageAdd",
	"damageDeepen",
	"dmgDelta",
	"natureDelta",
	"gateDelta",
	"reduce",
	"strikeBlock",
	"extraAdd",
	"fatal",
	"behead",
	"damageByHpRate",
	"finalSkillAdd",
	"ultimateAdd",
	"skillPower",
	"buffAdd",
	"randFix",
	"limit",
	"calcInternalDamageFinish",
	"ignoreRoundDamage",
	"immuneAllDamage",
	"immuneDamage",
	"immunePhysicalDamage",
	"immuneSpecialDamage",
	"keepHpUnChanged",
	"groupShield",
	"delayDamage",
	"damageAllocate",
	"damageLink",
	"protection",
	"shield",
	"freeze",
	"finalRate",
	"lockHp",
	"rebound",
	"suckblood",
	"result"
}
var_0_0.DamageProbProcessId = 18
var_0_0.ExtraAttackMode = {
	syncAttack = 3,
	counter = 1,
	assistAttack = 5,
	combo = 2,
	inviteAttack = 4
}
var_0_0.ExtraBattleRoundMode = {
	gemini = 3,
	atOnce = 2,
	reset = 1,
	normal = 0
}
var_0_0.JumpAllDamageProcessId = 9
var_0_0.BuffOverType = {
	dispel = 2,
	clean = 0,
	overlay = 3,
	normal = 1
}
var_0_0.SkillInterruptType = {
	charge = 1
}
var_0_0.OverlaySpecBuff = {
	sleepy = "sleepy",
	delayDamage = "delayDamage",
	atOnceBattleRound = "atOnceBattleRound",
	reborn = "reborn",
	counterAttack = "counterAttack",
	changeBuffLifeRound = "changeBuffLifeRound",
	sneer = "sneer",
	changeSkillNature = "changeSkillNature",
	syncAttack = "syncAttack",
	changeObjNature = "changeObjNature",
	lockHp = "lockHp",
	protection = "protection",
	allocate = "damageAllocate",
	inviteAttack = "inviteAttack",
	immuneDamage = "immuneDamage",
	prophet = "prophet",
	healTodamage = "healTodamage",
	opGameData = "opGameData",
	extraSkillWeightValueFix = "extraSkillWeightValueFix",
	lethalProtect = "lethalProtect",
	keepHp = "keepHpUnChanged",
	transformAttrBuff = "transformAttrBuff",
	freeze = "freeze"
}
var_0_0.ObjectState = {
	dead = 3,
	normal = 2,
	reborn = 5,
	realDead = 4,
	none = 1
}
var_0_0.ObjectLogicState = {
	cantBeAddBuff = 3,
	cantAttack = 2,
	cantBeSelect = 1,
	cantUseSkill = 5,
	cantBeAttack = 4
}
var_0_0.ExRecordEvent = {
	lockHpDamage = 1000,
	copySucessCount = 5,
	unitsDamage = 13,
	roundSyncAttackTime = 12,
	chargeStateBeforeWave = 22,
	spellSkillTotal = 21,
	spellBigSkill = 3,
	score = 17,
	totalHp = 15,
	comboProcessTotalNum = 9,
	spellNormalSkill = 1,
	copyState = 1007,
	killNumber = 16,
	effectHpMax = 1008,
	lockHpTriggerState = 1010,
	momentBuffDamage = 19,
	copyOrTransferBuff = 1004,
	skillEffectLimit = 20,
	lockHpTriggerTime = 1001,
	sucessCount = 1005,
	extraBattleRound = 24,
	campDamage = 14,
	dispelBuffCount = 1003,
	dispelSuccessCount = 4,
	protectTarget = 25,
	possessTarget = 23,
	transferState = 1006,
	effectHp = 1009,
	dispelSuccess = 1002,
	spellSmallSkill = 2,
	roundAttackTime = 18,
	sputtering = 10,
	rebornRound = 7,
	transferSucessCount = 6,
	lostHp = 8,
	keepHpUnChangedTriggerState = 1011,
	penetrate = 11
}
var_0_0.TimeIntervalType = {
	wave = 1,
	battleRound = 3,
	round = 2
}
var_0_0.TimeIntervalType = {
	wave = 1,
	battleRound = 3,
	round = 2
}
var_0_0.FilterObjectType = {
	noAlreadyDead = 1,
	excludeEnvObj = 4,
	noBeSelectHint = 3,
	noRealDeath = 2,
	excludeObjLevel1 = 100
}
var_0_0.CombineSkillType = {
	smallRoundEnd = 2,
	spellBigSkill = 4,
	bigRoundStart = 3,
	smallRoundStart = 1
}
var_0_0.EffectPowerType = {
	triggerPoint = "triggerPoint",
	passiveSkill = "passiveSkill",
	killAddMp1 = "killAddMp1"
}
var_0_0.BuffOverlayType = {
	OverlayDrop = 7,
	Overlay = 2,
	IndeLifeRound = 5,
	CoverLifeRound = 4,
	Coexist = 6,
	CoexistLifeRound = 8,
	Cover = 1,
	CoverValue = 3,
	Normal = 0
}
var_0_0.BuffEffectOverlayType = {
	PopTop = 1,
	SameMode = 2,
	Normal = 0
}
var_0_0.BuffEffectAniType = {
	OverlayCount = 1,
	Normal = 0
}
var_0_0.SneerType = {
	Duel = 1,
	Normal = 0
}
var_0_0.SneerArgType = {
	NoSpread = 0,
	DamageSpread = 1,
	BuffSpread = 2,
	AllSpread = 3
}
var_0_0.lifeRoundType = {
	pureBattleTurn = 3,
	battleTurn = 1,
	round = 2
}
var_0_0.ObjectType = {
	SummonFollow = 2,
	Summon = 1,
	Normal = 0
}
var_0_0.CsvStrToMap = {
	checkRealDeathIter = function(arg_1_0)
		return arg_1_0:isRealDeath()
	end
}
var_0_0.TriggerEnvType = {
	PassiveSkill = 1
}
var_0_0.GuideTriggerPoint = {
	End = 99,
	Fail = 97,
	Wave = 1000,
	Start = 0,
	Win = 98
}
var_0_0.GateAntiMode = {
	Operate = 1,
	Normal = 0
}
var_0_0.SpriteType = {
	Follower = 2,
	Possess = 1,
	Normal = 0
}
