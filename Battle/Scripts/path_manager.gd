extends Node3D
var astar = AStar3D.new()
@onready var tile_array
const GRID_UNIT = 2
#
func create_full_astar_grid():
	tile_array = %NavigationTilePlacer.get_children()
	var tile_id = 0
	for tile in tile_array:
		var tile_position = tile.global_position #Iterates through tiles and creates astar points
		astar.add_point(tile_id, tile_position)
		tile.get_child(0).get_child(0).id = tile_id #Save tile_id as a variable in the tile scene's Staticbody3d node. For debugging. Maybe delete later
		tile_id += 1
	for current_id in astar.get_point_ids(): #Iterates through points and connects each node to its cardinal neighbors
		var current_x = astar.get_point_position(current_id).x
		var current_z = astar.get_point_position(current_id).z
		for neighbor_id in astar.get_point_ids():
			if astar.get_point_position(neighbor_id).x == current_x:
				if abs(astar.get_point_position(neighbor_id).z - current_z) == GRID_UNIT:
					astar.connect_points(current_id, neighbor_id)
					continue
			elif astar.get_point_position(neighbor_id).z == current_z:
				if abs(astar.get_point_position(neighbor_id).x - current_x) == GRID_UNIT:
					astar.connect_points(current_id, neighbor_id)
					continue

	print(astar.get_point_path(0, 19))
	print(astar.get_point_path(0, 10))

#
func get_route(start_tile: int, end_tile: int) -> PackedVector3Array:
	var route = astar.get_point_path(start_tile, end_tile)
	print(route)
	return route
#
func _ready() -> void:
	pass

#func _process(delta: float) -> void:
	#pass
