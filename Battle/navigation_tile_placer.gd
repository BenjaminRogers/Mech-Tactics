extends Node3D
var flat_ground_tile_scene = preload("res://Battle/Tiles/flat_ground_tile.tscn")
var short_60_tile_scene = preload("res://Battle/Tiles/short_60_tile.tscn")
var tall_60_tile_scene = preload("res://Battle/Tiles/tall_60_tile.tscn")

var flat_ground_tile
var short_60_tile
var tall_60_tile
signal navigation_tiles_placed

func place_tiles():
	for i in range(%GeometryMeshPlacer.geometry_array.size()):
		if %GeometryMeshPlacer.geometry_array[i].top_layer == true:
			if %GeometryMeshPlacer.geometry_array[i].type == "Cube":
				flat_ground_tile = flat_ground_tile_scene.instantiate()
				add_child(flat_ground_tile)
				flat_ground_tile.position = %GeometryMeshPlacer.geometry_array[i].position
			if %GeometryMeshPlacer.geometry_array[i].type == "ShortRamp60":
				short_60_tile = short_60_tile_scene.instantiate()
				add_child(short_60_tile)
				short_60_tile.position = %GeometryMeshPlacer.geometry_array[i].position
				short_60_tile.rotation += %GeometryMeshPlacer.geometry_array[i].rotation
			if %GeometryMeshPlacer.geometry_array[i].type == "TallRamp60":
				tall_60_tile = tall_60_tile_scene.instantiate()
				add_child(tall_60_tile)
				tall_60_tile.position = %GeometryMeshPlacer.geometry_array[i].position
				tall_60_tile.rotation += %GeometryMeshPlacer.geometry_array[i].rotation
	print("Tiles placed")
	navigation_tiles_placed.emit()
func _ready() -> void:
	pass

		#if %GeometryGridmap.get_cell_id(cell) == 1:
		#	pass
		#if %GeometryGridmap.get_cell_id(cell) == 1:
		#	pass
		#if %GeometryGridmap.get_cell_id(cell) == 1:
		#	pass	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
