extends Node2D

const LOS_MASK = 3

onready var idle_timer = $idle_timer
onready var wander_timer = $wander_timer
onready var memory_timer = $memory_timer
onready var action_timer = $action_timer
onready var think_timer = $think_timer
onready var sight = $sight
onready var sshape = $sight/CollisionShape2D
onready var warning = $warning
onready var wshape = $warning/CollisionShape2D

# PROBLEM_NOTE: remove this
onready var debug = $debug

export var IDLE_TIME = 0.8
export var IDLE_OFFSET = 0.4
export var WANDER_TIME = 0.8
export var WANDER_OFFSET = 0.4
export(float, 0, 999) var WANDER_RANGE = 80 # max range from starting pos it can wander from

export var SMART_SLOWDOWN = true # starts slowing down before reaching distination to avoid overshooting
export var EIGHT_WAY_MOVEMENT = false # can only move in eight directions like wasd controls
export(int, 0, 20) var TOLERANCE = 3 # the amount of times it will tolerate friendly fire before starting 
																							  # to infight
export(float, 0.01666, 3.0) var THINK_TIME = 0.05
export(float, 0, 200) var SIGHT_RANGE = 100
export(float, 0, 200) var WARNING_RANGE = 50
export(float, 0, 25.0) var MEMORY_TIME = 4.0

export var AUTO_ACT = true
export(float, 0.2, 10.0) var ACTION_TIME = 1.0
export(float, 0.0, 0.999) var PATIENCE = 0.4
export var ACT_ON_WARNING = false
export(float, 0.0, 1.0) var ACTION_WEIGHTING = 0.2
export(float, 0.0, 1.0) var ACTION_DEWEIGHTING = 0.1
export var AUTO_ACTION_WEIGHTING = false
export var tag_modifiers = {
	"attack": 0.5,
	"defend": 0.5,
	"support": 0.5
}
export(int, 0, 10) var tag_weight = 0

export var general_springs = {
	"friendly": -1,
	"neutral": -1,
	"hostile": 0
}
export var faction_springs = {}
export var entity_springs = {}

var guard_pos = Vector2.ZERO
var guard_path = null
export(int, 1, 99) var MAX_TARGETS = 5
var targets = []
var target_paths = []
var best_position_paths = []
var memory = []
var memory_id = []
var memory_springs = []
var mem_times_queue = []
var memory_paths = []
var actions = []

signal found_target
signal lost_target
signal action(action, target)

func _on_brain_tree_entered() -> void:
	if get_parent() is Entity:
		get_parent().components["brain"] = self

func _ready():
	sshape.shape.radius = SIGHT_RANGE
	wshape.shape.radius = WARNING_RANGE
	guard_pos = global_position
	
	idle_timer.wait_time = IDLE_TIME
	wander_timer.wait_time = WANDER_TIME
	memory_timer.wait_time = MEMORY_TIME
	action_timer.wait_time = ACTION_TIME
	think_timer.wait_time = THINK_TIME
	
	if get_parent().components.has("hurtbox"):
		get_parent().components["hurtbox"].connect("triggered", self, "got_hit")

func _draw():
	return
	for i in memory.size():
		draw_circle(to_local(memory[i]), 2, Color.blue)
		if targets == []:
			if los_check(memory[i]) == true:
				draw_line(position, to_local(memory[i]), Color.lightblue, 1.0)
			else:
				var path = get_tree().current_scene.pathfind(global_position, memory[i])
				if path.size() < 2: path = [position, Vector2.ZERO]
				for x in path.size(): path[x] = to_local(path[x])
				draw_multiline(path, Color.lightblue)
	
	for i in targets.size():
		var target = targets[i]
		if is_target_valid(i) == true:
			var best_distance = 0
			best_distance = get_spring(target)
			
			var best_position = Vector2.ZERO
			var target_to_me = target.global_position.direction_to(global_position).normalized()
			best_position = target.global_position + target_to_me * best_distance
			
			if los_check(best_position) == true:
				draw_line(position, to_local(best_position), Color.red, 1, false)
			else:
				var path = get_tree().current_scene.pathfind(global_position, best_position)
				if path.size() < 2: path = [Vector2.ZERO, Vector2.ZERO]
				for x in path.size(): path[x] = to_local(path[x])
				draw_multiline(path, Color.red, 1, false)
	
	if targets == [] and memory == []:
		draw_circle(to_local(guard_pos), WANDER_RANGE, Color8(255, 255, 0, 50))
		if guard_path == null:
			draw_line(position, to_local(guard_pos), Color.yellow, 1, false)
		else:
			var path = guard_path
			if path.size() < 2: path = [Vector2.ZERO, Vector2.ZERO]
			for i in path.size(): path[i] = to_local(path[i])
			draw_multiline(path, Color.yellow, 1, false)
			draw_circle(path[0], 1.5, Color.yellow)

func _on_idle_timer_timeout() -> void:
	wander_timer.wait_time = clamp(WANDER_TIME + rand_range(-(WANDER_OFFSET), WANDER_OFFSET), 0.01, 999.0)
	if targets != []: return 
	get_parent().input_vector = Vector2(rand_range(-1.0, 1.0),rand_range(-1.0, 1.0)).normalized()
	
	if global_position.distance_to(guard_pos) > WANDER_RANGE: 
		# wander back to guard pos
		if los_check(guard_pos) == true:
			get_parent().input_vector = global_position.direction_to(guard_pos).normalized()
			guard_path = null
		else:
			if guard_path == null or los_check(guard_path[0]) == false:
				guard_path = get_tree().current_scene.pathfind(global_position, guard_pos)
			if guard_path.size() < 2: guard_path = null
			if guard_path != null and global_position.distance_to(guard_path[0]) < 10:
				guard_path.remove(0)
			if guard_path != null and not guard_path.size() < 2:
				get_parent().input_vector = global_position.direction_to(guard_path[0]).normalized()
	else:
		guard_path = null
	wander_timer.start()

func _on_wander_timer_timeout() -> void:
	idle_timer.wait_time = clamp(IDLE_TIME + rand_range(-(IDLE_OFFSET), IDLE_OFFSET), 0.01, 999.0) 
	if targets != []: return
	if not global_position.distance_to(guard_pos) > WANDER_RANGE*1.5: 
		get_parent().input_vector = Vector2.ZERO
	idle_timer.start()

func _on_memory_timer_timeout() -> void:
	memory.pop_back()
	if mem_times_queue != []:
		memory_timer.wait_time = mem_times_queue[0] + 0.01
		mem_times_queue.pop_front()
		memory_timer.start()
	else:
		memory_timer.wait_time = MEMORY_TIME

func _on_action_timer_timeout() -> void: 
	if AUTO_ACT == false:
		action_timer.stop()
		return
	
	if actions == []:
		action_timer.stop()
	elif targets != []:
		act()

func closest_target():
	var target = "no target found from closest_target()"
	var dist = 999
	for i in targets.size():
		if is_target_valid(i):
			if global_position.distance_to(targets[i].global_position) < dist:
				target = targets[i]
				dist = global_position.distance_to(targets[i].global_position)
	return target

func get_spring(target:Entity):
	var spring = -1
	
	if global.get_relation(get_parent(), target) != "":
		spring = general_springs.get(global.get_relation(get_parent(), target))
	if faction_springs.has(target.faction):
		spring = faction_springs.get(target.faction)
	if entity_springs.has(target.truName):
		spring = entity_springs.get(target.truName)
	if get_parent().marked_enemies.has(target):
		spring = general_springs["hostile"]
	
	spring = clamp(spring, -1, SIGHT_RANGE + 8) 
	
	return spring

func is_target_valid(index: int):
	var target = targets[index]
	if target == null:
		return false
	elif get_node_or_null(target_paths[index]) == null:
		return false
	elif target.is_queued_for_deletion() == true:
		return false
	elif los_check(target) == false and not global_position.distance_to(target.global_position) < 5:
		return false
	else:
		return true

func early_slowdown(destination: Vector2):
	if SMART_SLOWDOWN == true and global_position.distance_to(destination) <= 0.01666*get_parent().SLOWDOWN:
		return true
	else:
		return false

func act(warned = false):
	var chosen_action = null
	var target = null
	var highscore = -1
	
	for i in actions.size():
		var action = actions[i]
		var action_score = action.get_score(warned)
		
		if action_score[0] > highscore:
			chosen_action = action.get_name()
			highscore = action_score[0]
			target = action_score[1]
	
	if highscore <= PATIENCE: return
	
	if AUTO_ACTION_WEIGHTING == true: weight_actions(chosen_action)
	
	emit_signal("action", chosen_action, target)
	#print("======")

func weight_actions(chosen_action: String):
	for i in actions.size():
		var action = actions[i]
		if action.get_name() == chosen_action:
			action.weight += ACTION_WEIGHTING
		else:
			action.weight -= ACTION_DEWEIGHTING
		action.weight = clamp(action.weight, 0, 1)

func los_check(target):
	var target_pos = target
	if target is Entity: target_pos = target.global_position
	var ss = get_world_2d().direct_space_state
	
	var vision = ss.intersect_ray(target_pos, global_position, [get_parent()], LOS_MASK)
	if vision == null: return null
	else: vision = ss.intersect_ray(global_position.move_toward(target_pos, 2.5),
	target_pos, [get_parent()], LOS_MASK)
	
	if vision:
		if vision.collider is TileMap: 
			return false
		elif target is Entity and vision.collider == target:
			return true
		elif target is Vector2 and vision.collider.global_position == target:
			return true
		else:
			return false
	else:
		if target is Entity:
			return false
		elif target is Vector2:
			return true

func add_target(tar: Node):
	if not tar is Entity or tar is Melee or tar is Projectile or tar is Item or tar == get_parent(): return
	if get_spring(tar) == -1: return
	
	targets.append(tar)
	target_paths.append(tar.get_path())
	best_position_paths.append(null)
	
	if is_target_valid(targets.size()-1) == false:
		targets.remove(targets.size()-1)
		target_paths.remove(target_paths.size()-1)
		return
	
	idle_timer.stop()
	wander_timer.stop()
	emit_signal("found_target")
	
	var effect = global.aquire("exclaimation")
	get_parent().get_parent().call_deferred("add_child", effect)
	effect.global_position = global_position.move_toward(tar.global_position, 32)

func remove_target(tar):
	if targets == []: return
	
	var target = null
	var target_id = 0
	if tar is int:
		target_id = tar
		target = targets[target_id]
	elif tar is Node:
		target = tar
		target_id = targets.find(target)
	
	if target_id == -1 or target == null: return
	
	if target == tar:
		if get_spring(targets[target_id]) != -1 and MEMORY_TIME > 0:
			if get_node_or_null(target_paths[target_id]) == null: return
			if get_parent().is_queued_for_deletion() == true: return
			add_memory(targets[target_id].global_position, 
			get_spring(targets[target_id]), targets[target_id].get_instance_id())
			
			var effect = global.aquire("question")
			get_parent().get_parent().call_deferred("add_child", effect)
			effect.global_position = global_position.move_toward(targets[target_id].global_position, 32)
		
		targets.remove(target_id)
		target_paths.remove(target_id)
		emit_signal("lost_target")
		
		if targets == []: 
			get_parent().input_vector = Vector2.ZERO
			idle_timer.start()

func add_memory(pos: Vector2, spring: float, id: int):
	if get_parent().is_queued_for_deletion() == true: return
	
	# removes previous memory with matching id
	for i in memory_id.size():
		if memory_id[i] == id: 
			remove_memory(i)
			break
	
	idle_timer.stop()
	wander_timer.stop()
	memory.push_front(pos) # PROBLEM_NOTE: make use .append instead (better preformance
	memory_springs.push_front(spring) # <<<
	memory_paths.push_front(null) # <<<
	memory_id.push_front(id)
	
	if memory_timer.time_left == 0:
		memory_timer.start()
	else:
		mem_times_queue.push_front(MEMORY_TIME - memory_timer.time_left)

func remove_memory(i: int):
	if memory.size()-1 < i: return
	memory.remove(i)
	memory_id.remove(i)
	memory_paths.remove(i)
	memory_springs.remove(i)
	if mem_times_queue != []:
		memory_timer.wait_time = mem_times_queue[0] + 0.01
		mem_times_queue.pop_front()
		memory_timer.start()
	else:
		memory_timer.wait_time = MEMORY_TIME

func got_hit(body):
	var source = body.get_parent()
	if source == self or targets.has(source): return
	if source is Melee or source is Projectile: source = source.SOURCE
	if source == null: return
	if targets.has(source) == true: return
	
	match global.get_relation(get_parent(), source):
		"neutral":
			get_parent().marked_enemies.append(source)
		
		"hostile":
			if los_check(source) == true:
				add_memory(source.global_position, get_spring(source), source.get_instance_id())
				
				var effect = global.aquire("question")
				get_parent().get_parent().call_deferred("add_child", effect)
				effect.global_position = global_position.move_toward(source.global_position, 32)
		
		"friendly":
			TOLERANCE -= 1
			if TOLERANCE <= 0:
				get_parent().marked_enemies.append(source)

func _on_warning_area_entered(area: Area2D) -> void:
	if ACT_ON_WARNING == false:
		warning.queue_free()
		return
	if global.get_relation(get_parent(), area.get_parent()) == "friendly": return
	act(true)

func _on_sight_body_entered(body: Node) -> void:
	if los_check(body) == true:
		add_target(body)

func _on_sight_body_exited(body: Node) -> void:
	remove_target(body)

# PROBLEM_NOTE: i think this is the single most intensive function in the whole game so maybe optimize it
func _on_think_timer_timeout() -> void:
	think_timer.wait_time = THINK_TIME + rand_range(-0.1, 0.1)
	if get_parent().is_physics_processing() == false: return
	
	if round(rand_range(0, 15)) == 1:
		pass
	
	# search get_overlapping_bodies() for new targets
	for i in sight.get_overlapping_bodies().size():
		var body = sight.get_overlapping_bodies()[i]
		if body is Entity and body.get_name() != "WorldTiles" and not targets.has(body):
			if los_check(body) == true:
				add_target(body)
	
	# remove memories
	for i in range(memory.size()-1, -1, -1):
		var this_memory = memory[i]
		
		var best_distance = null
		best_distance = memory_springs[i]
		if best_distance == null:
			global.debug_msg(self, 0, "could not find spring for memory_truNames[i]")
			best_distance = 0
		
		var best_position = Vector2.ZERO
		var target_to_me = this_memory.direction_to(global_position).normalized()
		best_position = this_memory + target_to_me * best_distance
		
		if global_position.distance_to(best_position) < 10 and los_check(best_position) == true:
			remove_memory(i)
	
	var intention = Vector2.ZERO
	var trigger_anti_stuck = true
	
	if targets == []: # no targets
		# for adjusting guard_path
		if memory == []:
			if guard_path != null:
				if guard_path.size() == 0 or los_check(guard_path[0]) == false:
					guard_path = get_tree().current_scene.pathfind(global_position, guard_pos)
				if guard_path.size() != 0 and global_position.distance_to(guard_path[0]) < 10:
					guard_path.remove(0)
				if guard_path.size() != 0:
					get_parent().input_vector = global_position.direction_to(guard_path[0]).normalized()
			
			return
		
		# change intention based on memories
		for i in range(memory.size()-1, -1, -1):
			var this_memory = memory[i]
			
			var best_distance = null
			best_distance = memory_springs[i]
			if best_distance == null:
				global.debug_msg(self, 0, "could not find spring for memory_truNames[i]")
				best_distance = 0
			
			var best_position = Vector2.ZERO
			var target_to_me = this_memory.direction_to(global_position).normalized()
			best_position = this_memory + target_to_me * best_distance
			
			var strength = SIGHT_RANGE / global_position.distance_to(best_position)
			
			if los_check(best_position) == true:
				intention += global_position.direction_to(best_position) * strength
				memory_paths[i] = null
			else:
				var path = memory_paths[i]
				if path == null or los_check(path[0]) == false:
					path = get_tree().current_scene.pathfind(global_position, best_position)
				if path.size() < 1: path = null
				if path != null and global_position.distance_to(path[0]) < 5:
					path.remove(0)
				if path != null and not path.size() < 1:
					intention += global_position.direction_to(path[0]).normalized() * strength
					memory_paths[i] = path
			
			if strength > 0: trigger_anti_stuck = false
	
	else: # has target(s)
		for i in range(targets.size()-1, -1, -1):
			var target = targets[i]
			if is_target_valid(i) == false: 
				remove_target(target)
			elif get_spring(target) != -1:
				var best_distance = 0
				best_distance = get_spring(target)
				
				var best_position = Vector2.ZERO
				var target_to_me = target.global_position.direction_to(global_position).normalized()
				best_position = target.global_position + target_to_me * best_distance
				
				var strength = SIGHT_RANGE / global_position.distance_to(best_position)
				if early_slowdown(best_position) == true: strength = 0 # PROBLEM_NOTE: this causes flicker
				
				if los_check(best_position) == true:
					intention += global_position.direction_to(best_position) * strength
					best_position_paths[i] = null
				else:
					strength *= 0.8
					
					var path = best_position_paths[i]
					if path == null or los_check(path[0]) == false:
						path = get_tree().current_scene.pathfind(global_position, best_position)
					if path.size() < 1: path = null
					if path != null and global_position.distance_to(path[0]) < 5:
						path.remove(0)
					if path != null and not path.size() < 1:
						intention += global_position.direction_to(path[0]).normalized() * strength
						best_position_paths[i] = path
				
				if strength > 0: trigger_anti_stuck = false
	
	debug.global_position = global_position + (intention.normalized() * 16)
	
	if targets == [] and memory == []: return
	
	# anti-stuck
	if intention == Vector2.ZERO and not targets.size() < 2 and trigger_anti_stuck == true: 
		intention = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
	
	intention = intention.normalized()
	
	get_parent().input_vector = intention

func _process(_delta):
	update()
