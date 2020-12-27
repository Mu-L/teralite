extends TileMap

#onready var ysort = $YSort

onready var ysort = get_parent()

onready var data = {}

func set_data():
	pass

func _ready(): # converts tiles to their respective scenes
	set_data()
	if data == {}:
		global.var_debug_msg(self, 2, data)
		return
	
	# replaces the number with the cells of that id
	for i in data.keys().size():
		if data[data.keys()[i]] is int:
			data[data.keys()[i]] = get_used_cells_by_id(data.values()[i])
	
	for i in data.keys().size():
		convertTile(data.values()[i], data.keys()[i])
	
	
	clear() #remove all the tiles

func convertTile(tiles, thingName): # deletes the tile and places the entity
	var tilePos
	for i in range(0, tiles.size()):
		var newEntity = global.aquire(thingName)
		tilePos = map_to_world(tiles[i])
		newEntity.set_position(Vector2(tilePos.x + 8, tilePos.y + 8))
		ysort.call_deferred("add_child", newEntity)
