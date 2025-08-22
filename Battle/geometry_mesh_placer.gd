extends Node3D
@onready var geometry_array: Array[Node3D]
signal geometry_variables_set

func _ready() -> void:
	var top_layer_detector_scene = load("res://Battle/GeometryMeshes/top_layer_detector.tscn")
	var top_layer_detector = top_layer_detector_scene.instantiate()
	geometry_array.resize(get_child_count())
	for i in range(get_child_count()):
		geometry_array[i] = get_child(i)
	add_child(top_layer_detector)
	for i in range(geometry_array.size()):
		top_layer_detector.position = geometry_array[i].position
		top_layer_detector.position.y += 1
		await get_tree().physics_frame
		#await get_tree().create_timer(1).timeout 
		if not top_layer_detector.has_overlapping_bodies():
			geometry_array[i].top_layer = true
	top_layer_detector.queue_free()
	geometry_variables_set.emit()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
