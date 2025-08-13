extends GridMap
var used_cell_array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	#print(get_used_cells())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

 
func _on_ground_cursor_get_grid_coordinates(position: Vector3):
	pass
	#print(local_to_map(position))
	#$GroundCursor.grid_coordinates = local_to_map(position) # Replace with function body.
