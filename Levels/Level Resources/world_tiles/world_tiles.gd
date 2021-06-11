extends TileMap
# thanks LukeNaz
# https://stackoverflow.com/questions/53685183/navigation-tilemaps-without-placing-walkable-tiles-manually

export var generate_navigation = true
export(PoolIntArray) var valid_ids = []

# Empty/invisible tile marked as completely walkable. The ID of the tile should correspond
# to the order in which it was created in the tileset editor.
const _full_nav = 0
const _half_nav = 1

onready var nav = $nav

func _on_WorldTiles_tree_entered() -> void:
	global.nodes["world_tiles"] = self
	global.nodes["navigation"] = $nav

func _ready() -> void:
	if generate_navigation == false: 
		nav.queue_free()
		return
	
	# for doing the entire level
	#var bounds_min = Vector2(0, 0)
	#var bounds_max = Vector2(64, 64)
	
	var bounds_min = get_used_rect().position - Vector2(5, 5)
	var bounds_max = get_used_rect().end + Vector2(5, 5)

	# Replace all empty tiles with the provided navigation tile
	for x in range(bounds_min.x, bounds_max.x):
		for y in range(bounds_min.y, bounds_max.y):
			if not get_cell(x, y) in valid_ids:
				nav.set_cell(x, y, _full_nav)
			elif not get_cell(x, y+1) in valid_ids:
				nav.set_cell(x, y, _half_nav)
	
	# Force the navigation mesh to update immediately
	nav.update_dirty_quadrants()
