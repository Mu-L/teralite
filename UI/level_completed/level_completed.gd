extends Control

const NORMAL_CURSOR := preload("res://UI/cursors/cursor_normal.png")
const YELLOW := Color8(242, 211, 53)

onready var header = $area/header/label
onready var damage = $area/body/damage/Label
onready var damage_comment = $area/body/damage/comment
onready var time = $area/body/time/Label
onready var time_comment = $area/body/time/comment

onready var lvl: String = get_tree().current_scene.name

var perfected := false
var level_completed := false

func _init():
	visible = false
	refs.update_ref("level_completion", self)

func start():
	if level_completed == true:
		return
	
	$AnimationPlayer.play("animation")
	visible = true
	level_completed = true
	
	refs.stopwatch.visible = false
	refs.stopwatch.set_pause(true)
	refs.item_info.visible = false
	refs.item_bar.visible = false
	refs.health_ui.visible = false
	
	if get_tree().current_scene.DISPLAY_NAME == "":
		header.text = "%s completed" % lvl.to_lower()
	else:
		header.text = "%s completed" % get_tree().current_scene.DISPLAY_NAME
	
	if refs.player == null:
		damage.text = damage.text + "? (this is a bug, pls report)"
	else:
		damage.text = damage.text + str(refs.player.damage_taken)
		if refs.player.damage_taken == 0:
			damage.set("custom_colors/font_color", YELLOW)
			damage_comment.set("custom_colors/font_color", YELLOW)
			damage_comment.text = "perfect!"
			perfected = true
	
	var final_time: float = refs.stopwatch.time
	time.text = time.text + global.sec_to_time(final_time)
	
	# PB check
	if global.level_times.has(lvl):
		if final_time < global.level_times[lvl]:
			time.set("custom_colors/font_color", YELLOW)
			time_comment.set("custom_colors/font_color", YELLOW)
			time_comment.text = "personal best!"
	# devtime check
	if lvl in global.DEV_TIMES and final_time < global.DEV_TIMES[lvl]:
		time_comment.set("custom_colors/font_color", Color.cyan)
		time_comment.text = "better than the dev!"
	
	if lvl == "thx": return
	
	if not global.cleared_levels.has(lvl): 
		global.stars += 1
		global.cleared_levels.push_back(lvl)
	if perfected == true:
		global.perfected_levels.push_back(lvl)
	
	var stopwatch = refs.stopwatch
	if stopwatch == null: 
		push_warning("could not find stopwatch")
	elif not lvl in global.level_times or global.level_times[lvl] > stopwatch.time:
		global.level_times[lvl] = stopwatch.time
	
	if not lvl in global.level_deaths:
		global.level_deaths[lvl] = 0
	
	Input.set_custom_mouse_cursor(NORMAL_CURSOR, CURSOR_ARROW, Vector2(0, 0))
	
	$area/footer/proceed.grab_focus()

func _input(_event):
	if Input.is_action_just_pressed("interact") and visible == true:
		_on_proceed_pressed()

# PROBLEM_NOTE: this is bad because it's checked every frame
func _process(delta: float) -> void:
	if level_completed:
		visible = not refs.pause_menu.visible

func _on_proceed_pressed() -> void:
	global.total_time += refs.stopwatch.time
	global.speedrun_time += refs.stopwatch.time
	
	if lvl == "thx":
		if global.last_hub == null:
			global.last_hub = "A"
		refs.transition.exit()
		yield(refs.transition, "finished")
		get_tree().change_scene("res://Levels/%s/%s-Hub.tscn" % [global.last_hub, global.last_hub])
		return
	
	refs.transition.exit()
	yield(refs.transition, "finished")
	if lvl == "Core":
		get_tree().change_scene("res://UI/credits/credits.tscn")
	elif global.last_hub == null or global.last_hub.length() != 1:
			get_tree().change_scene("res://Levels/A/A-Hub.tscn")
	else:
		get_tree().change_scene("res://Levels/%s/%s-Hub.tscn" % [global.last_hub, global.last_hub])

func _on_replay_pressed() -> void:
	get_tree().reload_current_scene()
