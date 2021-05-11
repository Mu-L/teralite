extends Node

var data = {
	# entities
	"player": "res://Entities/player/player.tscn",
	"spikes": "res://Entities/spikes/spikes.tscn",
	"spikes_offset": "res://Entities/spikes/spikes_offest/spikes_offset.tscn",
	"chaser": "res://Entities/chaser/chaser.tscn",
	"brute_chaser": "res://Entities/chaser/brute_chaser/Brute_Chaser.tscn",
	"gold_chaser": "res://Entities/chaser/gold_chaser/Gold_Chaser.tscn",
	"crate": "res://Entities/crate/Crate.tscn",
	"fire": "res://Entities/fire/fire.tscn",
	"timber_box": "res://Entities/fire/timber_pot/timber_pot.tscn",
	"unlite_timber_box": "res://Entities/fire/timber_pot/unlite_timber_pot/unlite_timber_pot.tscn",
	"specter": "res://Entities/specter/specter.tscn",
	"knight": "res://Entities/knight/knight.tscn",
	"archer": "res://Entities/archer/archer.tscn",
	"rogue": "res://Entities/knight/rogue/rogue.tscn",
	"king": "res://Entities/king/king.tscn",
	"ultra_chaser": "res://Entities/chaser/ultra_chaser/ultra_chaser.tscn",
	"red_spikes": "res://Entities/spikes/red_spikes/red_spikes.tscn",
	"diamond_spikes": "res://Entities/spikes/red_spikes/diamond_spikes/diamond_spikes.tscn",
	
	# items
	"pistol": "res://Entities/Item_Pickups/pistol/pistol.tscn",
	"white_armor": "res://Entities/Item_Pickups/white_armor/white_armor.tscn",
	"sword": "res://Entities/Item_Pickups/sword/sword.tscn",
	"gold_heart": "res://Entities/Item_Pickups/gold_heart/gold_heart.tscn",
	"heart": "res://Entities/Item_Pickups/heart/heart.tscn",
	"star": "res://Entities/Item_Pickups/star/star.tscn",
	"bow": "res://Entities/Item_Pickups/bow/bow.tscn",
	
	# melees
	"slash": "res://Entities/Attacks/Melee/slash/slash.tscn",
	"stab": "res://Entities/Attacks/Melee/stab/stab.tscn",
	
	# projectiles
	"arrow": "res://Entities/Attacks/Projectile/arrow/arrow.tscn",
	"bullet": "res://Entities/Attacks/Projectile/small_bullet/small_bullet.tscn",
	
	# effects
	"hit_effect": "res://Effects/hit_effect/hit_effect.tscn",
	"item_pickup_effect": "res://Effects/item_pickup_effect/item_pickup_effect.tscn",
	"exclaimation": "res://Effects/exclaimation/exclaimation.tscn",
	"question": "res://Effects/question/question.tscn",
	"chaser_death": "res://Effects/death_effects/chaser_death_effect.tscn",
	"brute_chaser_death": "res://Effects/death_effects/brute_chaser_death_effect.tscn",
	"gold_chaser_death": "res://Effects/death_effects/gold_chaser_death_effect.tscn",
	"ultra_chaser_death": "res://Effects/death_effects/ultra_chaser_death_effect.tscn",
	"knight_death":"res://Effects/death_effects/knight_death_effect.tscn",
	"archer_death": "res://Effects/death_effects/archer_death_effect.tscn",
	"rogue_death": "res://Effects/death_effects/rogue_death_effect.tscn",
	"king_death": "res://Effects/death_effects/king_death_effect.tscn",
	
	# props
	"maple_tree1": "res://Props/maple_tree1/maple_tree1.tscn",
	"maple_tree2": "res://Props/maple_tree2/maple_tree2.tscn",
	"maple_tree3": "res://Props/maple_tree3/maple_tree3.tscn",
	"tree_stump": "res://Props/tree_stump/tree_stump.tscn",
	"banner": "res://Props/banner/banner.tscn",
	"flag": "res://Props/flag/flag.tscn",
	"torch": "res://Props/torch/torch.tscn",
	
	# audio
	"sword_clang": "res://Entities/Attacks/Melee/slash/sword_clang.wav",
	"sword_equip": "res://Entities/Attacks/Melee/slash/sword_equip.wav",
	"sword_hit": "res://Entities/Attacks/Melee/slash/sword_hit.wav",
	"sword_kill": "res://Entities/Attacks/Melee/slash/sword_kill.wav",
	"sword_miss": "res://Entities/Attacks/Melee/slash/sword_miss.wav",
	"sword_tint": "res://Entities/Attacks/Melee/slash/sword_tint.wav",
	"arrow_collide": "res://Entities/Attacks/Projectile/arrow/arrow_collide.wav",
	"arrow_hit": "res://Entities/Attacks/Projectile/arrow/arrow_hit.wav",
	"bow_shoot": "res://Entities/Attacks/Projectile/arrow/bow_shoot.wav",
	"pistol_fire": "res://Entities/Attacks/Projectile/small_bullet/pistol_fire.wav",
	"pistol_pickup": "res://Entities/Attacks/Projectile/small_bullet/pistol_pickup.wav",
	"star_pickup": "res://Entities/Item_Pickups/star/star_pickup.wav",
	"armor_pickup": "res://Entities/Item_Pickups/white_armor/armor_pickup.wav",
	"crate_destory": "res://Entities/crate/crate_destory.wav",
	"bow_draw": "res://Entities/player/item_thinkers/bow/bow_draw.wav",
	"pistol_reload": "res://Entities/player/item_thinkers/pistol/pistol_reload.wav",
	"player_death": "res://Entities/player/player_death/player_death.wav",
	"spike_rise": "res://Entities/spikes/spike_rise.wav",
	"damage": "res://Entities/damage.wav",
	"footstep_grass": "res://Entities/footstep_grass.wav",
	"footstep_wood": "res://Entities/footstep_wood.wav",
	"heal": "res://Entities/heal.wav",
	"forest_ambiance": "res://Levels/level/forest_ambiance.wav",
	"menu_pause": "res://UI/pause_menu/menu_pause.wav",
	"menu_unpause": "res://UI/pause_menu/menu_unpause.wav",
	"menu_click": "res://UI/menu_click.wav",
	"menu_hover": "res://UI/menu_hover.wav",
}

func allocate(asset:String) -> void:
	# overwrites paths with the packed scene
	if data.get(asset.to_lower()) is String:
		data[asset.to_lower()] = load(data.get(asset.to_lower()))

func aquire(asset:String):
	allocate(asset)
	return data.get(asset.to_lower())

func aquire_tscn(asset:String) -> PackedScene:
	allocate(asset)
	return data.get(asset.to_lower())

func aquire_entity(asset:String) -> Entity:
	allocate(asset)
	return data.get(asset.to_lower()).instance() as Entity

func aquire_melee(asset:String) -> Melee:
	allocate(asset)
	return data.get(asset.to_lower()).instance() as Melee

func aquire_projectile(asset:String) -> Projectile:
	allocate(asset)
	return data.get(asset.to_lower()).instance() as Projectile

func aquire_effect(asset:String) -> Effect:
	allocate(asset)
	return data.get(asset.to_lower()).instance() as Effect

func aquire_particle(asset:String) -> Particles2D:
	allocate(asset)
	return data.get(asset.to_lower()).instance() as Particles2D

func aquire_wav(asset:String) -> AudioStream:
	allocate(asset)
	return data.get(asset.to_lower()) as AudioStream