extends Node3D
const GRID_UNIT = 2
@onready var direction
@onready var animation_player = $PlayerMesh/AnimationPlayer
@onready var new_basis = Basis()
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
func receive_route(route: PackedVector3Array):
	for i in range(1, route.size()):
		var next_position: Vector3 = (route[i])
		var next_position_coordinates = next_position * GRID_UNIT
		position = next_position_coordinates
		await get_tree().create_timer(1).timeout
#func turn_to(next_position):
	#var direction_to_target = (next_position - global_position).normalized()
	#var target_basis = Basis.looking_at(direction_to_target, Vector3.UP)
	#global_transform.basis = target_basis
#func move_forward(next_position):
		#%Player.position.z -= 2
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not %Player.is_on_floor():
		%Player.velocity += %Player.get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump_debug") and %Player.is_on_floor():
		%Player.velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		%Player.velocity.x = direction.x * SPEED
		%Player.velocity.z = direction.z * SPEED
	#else:
		#%Player.velocity.x = move_toward(%Player.velocity.x, 0, SPEED)
		#%Player.velocity.z = move_toward(%Player.velocity.z, 0, SPEED)
	if %Player.velocity:
		%Player/PlayerMesh/AnimationPlayer.play("freehand_walk")
	else:
		%Player/PlayerMesh/AnimationPlayer.play("freehand_idle")
	%Player.move_and_slide()
