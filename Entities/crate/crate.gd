extends Entity

var navigation: TileMap
var cell_pos

func _ready() -> void:
	navigation = global.nodes["navigation"]
	
	cell_pos = navigation.world_to_map(global_position)
	
	navigation.set_cell(cell_pos.x, cell_pos.y, -1)

func death():
	navigation.set_cell(cell_pos.x, cell_pos.y, 0)
	.death()