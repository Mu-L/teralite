extends ColorRect

var sound_credits := [
	'"slashkut"\n by Abyssmal',
	'"Slash cut"\n by spycrah',
	'"Sword Swipe11"\n by LukeSharples',
	'"Drawing sword from scabbard" by giddster',
	'"Sword Attack"\n by Saviraz',
	'"sword against sword"\n by Fenodyrie',
	'"Medieval metal shield set down on stone floor"\n by ZapSplat',
	'"Heavy metal bar impact, with a clang, cluck, thump 3"\n by ZapSplat',
	'"Ambiance_Wind_Forst_Calm_Loop"\n by Nox Sound',
	'"cave_ambience_with_water_drips"\n by seanmorrissey96',
	'"Rustling Grass 2"\n by morganpurkins',
	'"Footstep_Wood_Heel_1"\n by GiocoSound',
	'"Footsteps Stone (1)"\n by Wdomino',
	'"footstep-carpet"\n by swuing',
	'"A_Step_On_Dirt"\n by MATRIXXX_',
	'"Footsteps on Sand"\n by BrendanSound12',
	'"Get Item 4 8 Bit"\n Mrthenoronha',
	'"armor10"\n pegingrillin',
	'"Ambiance_Wind_Forest_Calm_Loop"\n by Nox Sound',
	'"9mm gunside"\n by cedarstudios',
	'"Pistol Cock"\n by nebulasnails',
	'"AR15 pistol load and chamber"\n by michorvath',
	'"bullet ricochet"\n by aust_paul',
	'"Hit 4 8 Bit"\n by Mrthenoronha',
	'"bow01"\n by Erdie',
	'"Arrow Strike"\n by plantmonkey',
	'"arrow_damage" by braqoon',
	'"Arrow Impact 2" by LiamG_SFX',
	'"Regular Arrow Shot with rattle slow draw"\n by brendan89',
	'"Wooden Creek"\n by Mafon2',
	'"CLICK_143", by Jaszunio15',
	'"Wooden Hover"\n by BenjaminNelan',
	'"Access Denied"\n by suntemple',
	'"Spiketrap"\n by Deathscyp',
	'"Wood Break"\n by Deathscyp',
	'"Retro Video Game Death"\n by SRJA_Gaming',
	'"Healing 2 (Tranquillity)" by SilverIllusionist',
	'"healpop"\n by shyguy014',
	'"Error"\n by Isaac20000',
	'"shine"\n from 20xx.io',
	'"hvyelec"\n by inferno',
	'"Electricity spark (sound design)"\n by ZapSplat',
	'"Enchant"\n by qubodup',
	'"Menu FX 03"\n by by NightFlame',
	'"Wooden Object Take"\n by Kostas17',
	'"Medieval spear swing 2"\n by Still North Media',
	'"Gore, beheading, chopping off head"\n by 344 Audio',
	'"Spear throw and stick into ground with slight\nvibration of the wooden spear pole on impact. Version 1"\n by ZapSplat',
	'"Sharp wooden post, stake, dig into soil, ground 4"\n by ZapSplat',
	'"Axe Swing, hit body against wood, metal clang,\n impact squelch 3"\n by ZapSplat',
	'"Spear thrown and stick into ground with slight\nvibration of wooden spear pole on impact. Version 5"\n by ZapSplat',
	'"Sword, stab through chain mail into flesh,\nsharp metallic scrape (...)"\n by Audio Hero', # shortened
	'"2 x swords hit, impact 1"\n by ZapSplat',
	'"Whoosh Heavy Spear Hammer Large" by EminYILDIRIM',
	'"Knife, swish, swipe, through air, slashing\nmovements 3"\n by ZaplSplat',
	'"Knife, dagger, blade draw, pull from sheeth7"\n by ZapSplat',
	'"Knife, dagger blade draw, pull from sheath"\n by ZapSplat',
	'"Bullet pass, whizz by 2"\n by ZapSplat',
	'"Bullet whizz into person, body with an impact\nand light splat. Version 1"\n by ZapSplat',
	'"Metal hit, impact, sharp flick, tinny 1"\n by ZapSplat',
	'"Horror, knife stab into flesh then pull out,\nvery squelchy 3"\n by ZapSplat',
	'"Bolt Cutter"\n by jameswrowles',
	'"mini crossbow foley"\n by nettimato',
	'"bow02"\n by Erdie',
	'"Medieval crossbow bolt pass by 1" by Still North Media',
	'"Fast swing, whoosh into a metal hit, thud or\nclunk, could be\nsword hitting shield or armor. Version 1"\n by ZapSplat',
	'"PotionDrinkLong"\n by Jamius',
	'"Potion - drink - swallow"\n by vlnpetiteau',
	'"Bottle Shattering"\n by spookymodem',
	'"Soft Wind"\n by Animate_42',
	'"teleport"\n by Leszerk_Szary',
	'"Blowpipe"\n by loudernoises',
	'"Dart strikes dartboard 5"\n by ZapSplat',
	'"Blood Impact"\n by EminYILDIRIM',
	'"Keys17"\n by egolessdub',
	'"Eating an apple"\n by domvoice',
	'"Door_Unlocking"\n by IPaddeh',
	'"Block of unused staples drop on table"\n by ZapSplat',
	'"Breeze block drop on hard ground 4"\n by ZapSplat',
	'"Fabric first aid medical kit with\ncellophane wrapped bandage inside, open velcro 2"\n by ZapSplat',
	'"Fabric first aid medical kit with\ncellophane wrapped bandages inside, handling, movement"\n by ZapSplat',
	'"Explosion 2"\n by LiamG_SFX',
	'"Sniper Scope zoom in 1"\n by Supakid13',
	'"Scope Click - Sniper Rifle (4)"\n by FilmmakersManual',
	'"Scope Click - Sniper Rifle (5)"\n by FilmmakersManual',
	'"Sniper Rifle Firing Shot (4)"\n by FilmmakersManual',
	'"shot and reload"\n by deathnsorrow',
	'"Sniper Rifle - Loading Ammo (3)"\n by FilmmakersManual',
	'"Soft-Notifications - Bell - LowDing.mp3"\n by LegitCheese',
	'"SXP_SHOTGUN_RACK_01"\n by dasBUTCHER84',
	'"Shotgun - Firing (2)"\n by FilmmakersManual',
	'"Shell Hitting Ground (17)"\n by FilmmakersManual',
	'"Winchester, Model 12, shotgun, pump action,\n12 guage, load mag"\n by Still North Media',
	'"Skeleton bones (game)"\n by cribbler',
	'"AK 47 Action"\n by dwightsabeast',
	'"Gun, rifle, single shot, designed"\n by ZapSplat',
	'"AKManipulation"\n by Mittelmorder',
	'"Dissonant Piano Sting 5"\n by nomiqbomi',
	'"close gun"\n by nettimato',
	'"Desert Eagle .50AE shot"\n by vabadus',
	'"CP99 Reload"\n by Kruf',
	'"Anvil Hit 2"\n by michorvath',
	'"Small bones crush and break, could be hand,\nfingers or foot 3"\n by ZapSplat',
	'"Digging, Ice, Hammer, A.wav"\n by InspectorJ',
	'"Double Beep"\n by andersmmg',
	'"Firework rocket launch"\n by ZapSplat',
	'"Very small tin, circular, lid open 2"\n by ZapSplat',
	'"Heavy flame burst."\n by SmartSound',
	'"Syringe squirt liquid out into air. Version 4"\n by ZapSplat',
	'"Syringe squirt liquid out into air, short and fast. Version 2"\n by ZapSplat',
	'"Syringe squirt liquid, short squelch. Version 2"\n by ZapSplat',
	'"Walking on Metal Floor"\n by NachtmahrTV',
	'"Rural Australian bush ambience, summer, midday,\nlots of loud insects, cicada, crickets and birds. Version 1"\n by ZapSplat',
	'"bonfire flames sizzling"\n by florianreichelt',
	'"Ignite, 01-01"\n by InspectorJ',
	'"Cracking, snapping, and clanging (metal can)"\n by Ashley12275',
	'"Wood Crate Destory 2"\n by Bertsz',
	'"Hard Glass Impact"\n by deleted_user_3656686',
	'"Digging in Dirt"\n by Anandthethird',
	'"Poison Spell Magic"\n by qubodup',
	'"hissing snake sound effect"\n by Garuda1982',
	'"blaster shot single 5"\n by MikeE63',
	'"minigun_Overheat"\n by Marregheriti',
	'"Futuristic Woosh sound"\n by Mega-X-stream',
	'"Lightsaber Ignition"\n by pip_',
	'"lightsaber clash"\n by reesewong8',
	'"port"\n by reesewong8',
	'"Light Blaster Weapon"\n by SeanSecret',
	'"Impact_010"\n by AlienXXX',
	'"Teleport"\n by Fupicat',
	'"Game sound, high pitched laser gun fire,\nsingle shot 3"\n by ZapSplat',
	'"SciFi Gun - Plasma Slinger"\n by dpren',
	'"Freq Blip from 24726"\n by Big_D123',
	'"Electricity Sound"\n by NachtmahrTV',
	'"Ominous III"\n by Jerimee',
	'"Magical portal open"\n by alanmcki',
	'"Inside Tornado, Strong Wind, Destruction"\n by PMSFX',
	'"Artblock"\n by Jan125',
	'"Loud Silence" by qubodup',
	'"Tonal_Impact_D" by Renovatio871'
]

onready var animation: AnimationPlayer = $AnimationPlayer
onready var sfx1 := $sound_credits/VBoxContainer_2/name
onready var sfx2 := $sound_credits/VBoxContainer_2/name_2
onready var times := $fin/times

func _ready() -> void:
	times.text = (
		"final run time: " + global.sec_to_time(global.total_time) + "\n" +
		"sum of PRs: " + global.sec_to_time(global.speedrun_time) + "\n"
	)

func start_sound_credits(time: float):
	for i in sound_credits.size()-1:
		if (i / 2.0) != floor(i / 2.0): # is odd
			sfx1.text = sound_credits[i]
		else: # is even
			sfx2.text = sound_credits[i]
		
		yield(get_tree().create_timer(time / sound_credits.size()), "timeout")

func _input(event: InputEvent) -> void:
	if animation.is_playing():
		return
	
	if event is InputEventKey or event is InputEventJoypadButton or event is InputEventMouseButton:
		if event.pressed:
			get_tree().change_scene("res://UI/title_screen/title_screen.tscn")
