extends ColorRect

onready var title = preload("res://UI/title_screen/title_screen.tscn")

func _input(event: InputEvent):
	if event is InputEventKey or event is InputEventJoypadButton or event is InputEventMouseButton:
		if event.pressed:
			get_tree().change_scene_to(title)

func _on_movement_animation_finished(_anim_name: String) -> void:
	get_tree().change_scene_to(title)