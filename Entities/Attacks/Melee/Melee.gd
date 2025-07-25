extends Attack
class_name Melee

export(bool) var HOLDS := false
export(int, 0, 200) var RECOIL := 70
export(bool) var ANIMATION_NEVER_BACKWARDS := false
export(bool) var HIDE_HELD_ITEM := true
export(bool) var REVERSE_HELD_ITEM := true

var recoiled := false

onready var animation: AnimationPlayer = $animation
onready var sprite: Sprite = $entity_sprite

func setup(new_source := Entity.new(), new_target_pos := Vector2.ZERO):
	.setup(new_source, new_target_pos)
	start_pos = SOURCE.global_position + RANGE * DIRECTION
	visible = false

func _ready():
	if SOURCE == null:
		SOURCE = get_node_or_null(SOURCE_PATH)
	
	_physics_process(float())
	
	var held_item = SOURCE.components["held_item"]
	
	# hide held item
	if held_item != null and HIDE_HELD_ITEM == true:
		held_item.visible = false
		held_item.sprite.visible = false
	
	if REVERSE_HELD_ITEM == true:
		if held_item != null and held_item.reversed == true and ANIMATION_NEVER_BACKWARDS == false:
			if held_item.facing_left():
				animation.play("animation")
				sprite.position = Vector2(0, -4)
				sprite.rotation_degrees = 0
			else:
				animation.play("animation_reverse")
				# \/ hack to prevent flicker bug, no idea why the animation doesn't do this
				sprite.position = Vector2(0, 4)
				sprite.rotation_degrees = 180
		else:
			if held_item.facing_left():
				animation.play("animation_reverse")
				sprite.position = Vector2(0, 4)
				sprite.rotation_degrees = 180
			else:
				animation.play("animation")
				# \/ hack to prevent flicker bug, no idea why the animation doesn't do this
				sprite.position = Vector2(0, -4)
				sprite.rotation_degrees = 0
	elif REVERSE_HELD_ITEM == false:
		animation.play("animation")
	
	visible = true

func _physics_process(_delta):
	if get_node_or_null(SOURCE_PATH) != null and SOURCE.is_queued_for_deletion() == false:
		global_position = SOURCE.global_position + RANGE * DIRECTION

func death():
	.death()
	
	# recoil
	if get_node_or_null(SOURCE_PATH) != null and SOURCE.is_queued_for_deletion() == false and recoiled == false:
		SOURCE.apply_force(target_pos.direction_to(SOURCE.global_position).normalized() * RECOIL)
		recoiled = true
	
	if components["hitbox"] != null:
		hitbox.set_deferred("monitoring", false)
		hitbox.set_deferred("monitorable", false)
	if death_free == true:
		queue_free()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if visible == false: return
	if global.get_relation(self, area.get_parent()) == "friendly": return
	if "PENETRATES" in area.get_parent(): return
	
	# recoil
	if get_node_or_null(SOURCE_PATH) != null and SOURCE.is_queued_for_deletion() == false and recoiled == false:
		SOURCE.apply_force(global_position.direction_to(SOURCE.global_position).normalized() * RECOIL)
		recoiled = true

func collided():
	.collided()
	if visible == false:
		return
	
	if get_node_or_null(SOURCE_PATH) != null:
		var spark: Effect = BLOCK_SPARK.instance()
		spark.rotation_degrees = rad2deg(SOURCE.global_position.direction_to(global_position).angle())
		refs.ysort.call_deferred("add_child", spark)
		yield(spark, "ready")
		spark.global_position = global_position.move_toward(target_pos, RANGE)

func _on_Melee_tree_exiting() -> void:
	#animation.stop()
	
	# make held item visible agian
	if get_node_or_null(SOURCE_PATH) != null and SOURCE.is_queued_for_deletion() == false:
		var held_item: Node2D = SOURCE.components["held_item"]
		if held_item != null:
			if REVERSE_HELD_ITEM == true:
				held_item.reversed = not held_item.reversed
				# fixes flashing due to the held_item updating a frame late
				held_item.sprite.flip_v = not held_item.sprite.flip_v
				held_item.sprite.offset *= -1
			
			held_item.visible = true
			held_item.sprite.visible = true

func _on_animation_animation_finished(anim_name: String) -> void:
	queue_free()
