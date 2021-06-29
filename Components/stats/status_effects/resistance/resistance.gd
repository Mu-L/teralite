extends Status_Effect

onready var stats: Node = get_parent()

var original_defence: int

func _ready():
	original_defence = stats.DEFENCE
	stats.DEFENCE += round(level)
	stats.armor = stats.DEFENCE
	global.nodes["health_ui"].update()

func depleted():
	stats.DEFENCE -= round(level)
	global.nodes["health_ui"].update()

# PROBLEM_NOTE: i don't think these non-trigger status effects (speed and slowness included)
# work with effects stacking. i should add a stack() function to Status_Effect.gd so this can be
# handled