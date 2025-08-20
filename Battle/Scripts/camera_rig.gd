extends SpringArm3D

@onready var camera: Camera3D = $Camera3D
@export var turn_rate := 150

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spring_length = camera.position.z


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var look_input := Input.get_vector("view_down","view_up","view_right","view_left")
	look_input = look_input * turn_rate * delta
	rotation_degrees.x += look_input.x
	rotation_degrees.y += look_input.y
	rotation_degrees.x = clampf(rotation_degrees.x, -45, 30)
