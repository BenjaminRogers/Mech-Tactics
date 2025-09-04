extends Node3D
var astar = ManhattanAStar3D.new()
@onready var tile_array: Array
var visible_tile_array: Array
const GRID_UNIT = 2
var tile_material_blue = preload("res://Battle/Tiles/Materials/Blue.tres")
var tile_material_green = preload("res://Battle/Tiles/Materials/Green.tres")
var tile_material_red = preload("res://Battle/Tiles/Materials/Red.tres")
var tile_material_white = preload("res://Battle/Tiles/Materials/White.tres")
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


func get_route(start_tile: int, end_tile: int) -> PackedVector3Array:
	var route = astar.get_point_path(start_tile, end_tile)
	print(route)
	return route

func disable_visible_tiles() -> void:
	for tile in visible_tile_array:
		tile.visible = false
	visible_tile_array.clear()
	
func get_movement_range(unit: Node3D) -> void:
	var movement = unit.movement
	var starting_position = unit.global_position
	var starting_position_id = astar.get_closest_point(starting_position)
	var unit_tile_id
	var min_x = unit.global_position.x - movement
	var max_x = unit.global_position.x + movement
	var min_z = unit.global_position.z - movement
	var max_z = unit.global_position.z + movement
	
	for tile in tile_array:
		var tile_static_body = tile.get_child(0).get_child(0)
		var tile_id = astar.get_closest_point(tile.global_position)
		var route = astar.get_point_path(starting_position_id, tile_id)
		var route_length = route.size() - 1
		if route_length <= movement and route.size() != 1:
			var tile_mesh = tile.get_child(0)
			tile_mesh.material_override = tile_material_blue
			tile.visible = true
			visible_tile_array.push_front(tile)
func _ready() -> void:
	pass
#func _process(delta: float) -> void:
	#pass
