extends "res://Entities/chaser/Chaser.gd"

onready var brain = $brain
onready var cooldown = $dash_cooldown

export var dash_cooldown = 1.0
export var dash_power = 5000

func _ready():
	cooldown.wait_time = dash_cooldown

func _on_action_lobe_action(action, target) -> void:
	if cooldown.time_left > 0: return
	
	var dash_direction = Vector2.ZERO
	
	if global_position.distance_to(target.global_position) > 25: 
		dash_direction = global_position.direction_to(target.global_position)
	else:
		# PROBLEM_NOTE: might be a better way to do this
		dash_direction = global_position.direction_to(target.global_position)
		var a = dash_direction.x
		var b = dash_direction.y
		dash_direction = Vector2(b, a)
	
	dash_direction = dash_direction.normalized()
	
	apply_force(dash_direction * dash_power)
	cooldown.start()
