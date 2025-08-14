extends Node3D
var astar = AStar3D.new()
signal calculated_route(route_array: PackedVector3Array)
func _on_ground_cursor_get_tile_id(coordinates: Vector3) -> void:
	for point in astar.get_point_ids():
		var current_points_position = astar.get_point_position(point)
		if current_points_position == coordinates:
			%GroundCursor.current_tile_id = point
			break

func _on_ground_cursor_get_route(start_tile: int, end_tile: int) -> void:
	var route = astar.get_point_path(start_tile, end_tile)
	calculated_route.emit(route) # Replace with function body.

func _ready() -> void:
	for tile_position in %TileGridMap.get_used_cells(): #Iterates through tiles and creates astar points
		astar.add_point(%TileGridMap.tile_id, tile_position)
		%TileGridMap.tile_id += 1
	for current_id in astar.get_point_ids(): #Iterates through points and connects each node to its cardinal neighbors
		var current_x = astar.get_point_position(current_id).x
		var current_z = astar.get_point_position(current_id).z
		for neighbor_id in astar.get_point_ids():
			if astar.get_point_position(neighbor_id).x == current_x:
				if abs(astar.get_point_position(neighbor_id).z - current_z) == 1:
					astar.connect_points(current_id, neighbor_id)
					continue
			elif astar.get_point_position(neighbor_id).z == current_z:
				if abs(astar.get_point_position(neighbor_id).x - current_x) == 1:
					astar.connect_points(current_id, neighbor_id)
					continue
	print(astar.get_point_path(20, 30))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
