extends Control

const A_HUB = "res://Levels/A/A_hub.tscn"

onready var header = $area/header/label
onready var time = $area/stats/time/value
onready var health = $area/stats/health/value

onready var lvl = get_tree().current_scene.name

var level_name: String = "Level"

func _init():
	visible = false

func _ready():
	global.nodes["level_completed"] = self

func get_player():
	return get_node_or_null(global.nodes["player"])

func start():
	$AnimationPlayer.play("animation")
	visible = true
	
	global.nodes["stopwatch"].visible = false
	global.nodes["item_info"].visible = false
	global.nodes["item_bar"].visible = false
	global.nodes["health_ui"].visible = false
	
	match lvl:
		"A-1": level_name = "Redwood"
		"A-2": level_name = "Midpoint"
		"A-3": level_name = "Spiral"
		"A-4": level_name = "Brick"
		"A-5": level_name = "Barricade"
		"A-6": level_name = "Sprint"
		"A-7": level_name = "Quickstep"
		"A-8": level_name = "Enterance"
		"A-9": level_name = "Timber"
		"A-10": level_name = "Gauntlet"
		"A-11": level_name = "Army"
		"A-12": level_name = "Ambushed"
		"A-13": level_name = "Caged"
		"A-14": level_name = "Monarch"
		"A-15": level_name = "Duo"
		"A-secret": level_name = "Shadow"
	header.text = "%s Completed" % level_name
	
	if get_player() == null:
		health.text = "0"
	else:
		var p_stats = get_player().components["stats"]
		health.text = str(
			((p_stats.HEALTH + p_stats.BONUS_HEALTH) / (p_stats.MAX_HEALTH + 0.0)) * 100
		) + "%"
	
	var time_value = global.nodes["stopwatch"].time
	var minute = int(floor(time_value / 60))
	var second = int(floor(time_value - (minute * 60)))
	var tenth = stepify(time_value - ((minute*60) + second), 0.1) * 10
	if tenth == 10: tenth = 0 # PROBLEM_NOTE: might be the wrong way to display it but im not sure
	if second < 10: 
		second = str(second)
		second = "0"+second
	time.text = (
		str(minute) +
		":" +
		str(second) +
		"." +
		str(tenth)
		)

func _input(_event):
	if Input.is_action_just_pressed("interact") and visible == true:
		if lvl == "thx":
			get_tree().change_scene_to(load("res://Levels/A/A_hub.tscn"))
			return
		
		if not global.cleared_levels.has(lvl): 
			global.stars += 1
			global.cleared_levels.push_back(str(lvl))
		if (
			not global.perfected_levels.has(lvl) 
			and get_player() != null
			and get_player().perfect == true
			): 
				global.perfected_levels.push_back(str(lvl))
		
		var stopwatch = global.nodes["stopwatch"]
		if stopwatch == null: 
			push_warning("could not find stopwatch")
		else:
			global.level_times[lvl] = stopwatch.time
		
		if not lvl in global.level_deaths:
			global.level_deaths[lvl] = 0
		
		if lvl == "A-14":
			get_tree().change_scene_to_(load("res://Levels/thx.tscn"))
		else:
			match get_tree().current_scene.WORLD:
				"A":
					get_tree().change_scene_to(load("res://Levels/A/A_hub.tscn"))
				_:
					push_error("level has invalid WORLD: '%s'" % get_tree().current_scene.WORLD)
					get_tree().change_scene_to(load("res://Levels/A/A_hub.tscn"))
