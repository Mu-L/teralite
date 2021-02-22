extends Node2D
class_name Effect

export(NodePath) var sprite = null
export(NodePath) var animation_player = null
export(Animation) var custom_animation
export(float, -64, 64) var effect_speed = 1.0

onready var default_sprite = preload("res://Entities/crate/crate.png")

func _ready():
	if animation_player == null:
		push_warning("animation_player == null")
	elif animation_player:
		animation_player = get_node(animation_player)
		animation_player.playback_speed *= effect_speed
		if custom_animation != null:
			animation_player.play(custom_animation)
	
	if sprite == null:
		push_warning("sprite == null")
	else:
		sprite = get_node_or_null(sprite)
		if sprite == null:
			push_warning("could not find sprite node")
		elif sprite.texture == null:
			push_error("spriter was not given a texture")
			sprite.texture = default_sprite
	
	animation_player.connect("animation_finished", self, "delete_self")

# have to do this because animation_finished has 1 argument and queue_free() only takes 0 arguments
func delete_self(_anim_name: String):
	queue_free()

# old code for the speed change based on duration value:

# if abs(effect_duration) < 1.0:
#	animation_player.playback_speed = 1.0 + abs(effect_duration)
# elif abs(effect_duration) > 1.0:
#	animation_player.playback_speed = 1.0 / abs(effect_duration)
# 
#	if effect_duration < 0: animation_player.playback_speed *= -1
