extends Entity

onready var attack_cooldown = $attack_cooldown
onready var sprite = $sprite
onready var brain = $brain
onready var animation = $AnimationPlayer

export(PackedScene) var PROJECTILE
export(float, 0.01, 5.0) var attack_cooldown_time = 0.85

var targit: Entity
var targit_path: NodePath

func _ready():
	attack_cooldown.wait_time = attack_cooldown_time

func attack():
	var pos
	if (
		targit != null and 
		get_node_or_null(targit_path) != null
	): 
		pos = targit.global_position
	else: 
		pos = global_position + (input_vector * 5) + Vector2(rand_range(-0.1, 0.1), rand_range(-0.1, 0.1))
	
	var projectile = PROJECTILE.instance()
	projectile.setup(self, pos)
	refs.ysort.get_ref().add_child(projectile)
	attack_cooldown.start()

func _on_action_lobe_action(action, target: Entity) -> void:
	if attack_cooldown.time_left > 0: return
	targit = target
	targit_path = target.get_path()
	animation.play("attack")
