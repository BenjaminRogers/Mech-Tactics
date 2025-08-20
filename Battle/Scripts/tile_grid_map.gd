extends GridMap
@onready var tile_id = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Generates tile grid on top of geometry grid
	var array1 = %GeometryGridMap.get_used_cells()
	for cell in array1:
		cell.y += 1
		set_cell_item(cell, 0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
