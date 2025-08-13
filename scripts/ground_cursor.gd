extends AnimatableBody3D
const GRID_UNIT = 2
var grid_coordinates: Vector3
signal get_grid_coordinates(position: Vector3)
signal get_tile_coordinates(position: Vector3)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tile_coordinates.emit(position)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		position.x += GRID_UNIT
	if event.is_action_pressed("ui_right"):
		position.x += -GRID_UNIT
	if event.is_action_pressed("ui_up"):
		position.z += GRID_UNIT
	if event.is_action_pressed("ui_down"):
		position.z += -GRID_UNIT
	if event.is_action_pressed("print_debug"):
		get_tile_coordinates.emit(position)
		print(grid_coordinates)
