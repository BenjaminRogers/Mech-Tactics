extends GridMap
const MAP_SIZE_X = 0
const MAP_SIZE_Y = 0
var astar = AStar3D.new()
@onready var tile_id = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass # Replace with function body.
	for tile_position in get_used_cells(): #Iterates through tiles and creates astar points
		astar.add_point(tile_id, tile_position)
		tile_id += 1
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_ground_cursor_get_tile_id(coordinates: Vector3) -> void:
	for point in astar.get_point_ids():
		var current_points_position = astar.get_point_position(point)
		if current_points_position == coordinates:
			%GroundCursor.current_tile_id = point
			break


func _on_ground_cursor_get_route(start_tile: int, end_tile: int) -> void:
	print(astar.get_point_path(start_tile, end_tile)) # Replace with function body.
