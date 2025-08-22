extends Node3D
var flat_ground_tile_scene = preload("res://Battle/Tiles/flat_ground_tile.tscn")
#var short_60_tile = preload()
#preload()
#preload()
var flat_ground_tile
func place_tiles():
		for i in range(%GeometryMeshPlacer.geometry_array.size()):
			if %GeometryMeshPlacer.geometry_array[i].top_layer == true:
				flat_ground_tile = flat_ground_tile_scene.instantiate()
				add_child(flat_ground_tile)
				flat_ground_tile.position = %GeometryMeshPlacer.geometry_array[i].position
			
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
