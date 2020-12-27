extends Entity

onready var activation = $activation
onready var animation = $AnimationPlayer

func _ready():
	$Sprite.frame = 0

func _on_activation_area_entered(_area: Area2D) -> void:
	if animation.is_playing() == true: return
	animation.play("spikes")
	activation.queue_free()
