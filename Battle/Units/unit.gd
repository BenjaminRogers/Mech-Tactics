extends Node3D
const GRID_UNIT = 2
@onready var direction
@onready var animation_player = $PlayerMesh/AnimationPlayer
@onready var mini_stats_window = %MiniStatsWindow
### Stats ###
@export var movement = 5
@export var charge_time = 0
@export var charge_speed = 5
@export var max_health = 100
@export var current_health = 42
###       ###

func show_movement_range():
	pass
func initialize_menu() -> void:
	%HPBar.max_value = max_health
	%HPBar.value = current_health
	%HPNumeric.text = str(current_health, "/", max_health)
	%CTBar.value = charge_time

func toggle_mini_stats_window_visibility() -> void:
	if mini_stats_window.visible:
		mini_stats_window.visible = false
	elif mini_stats_window.visible == false:
		mini_stats_window.visible = true

func _ready() -> void:
	initialize_menu()

func move(route: PackedVector3Array) -> void:
	var current_delta = get_process_delta_time()
	for i in range(1, route.size()):
		var next_position: Vector3 = (route[i])
		var next_position_coordinates = next_position * GRID_UNIT

##########################################################################################
		#I stole this from the internet I have no idea how or why this works
		var direction = (next_position_coordinates - global_transform.origin).normalized()
		var target_angle = atan2(direction.x, direction.z)
		var current_rotation = global_rotation.y
		var new_rotation_y = rad_to_deg(target_angle)
		rotation_degrees.y = new_rotation_y
###########################################################################################
		#position += transform.basis.z * GRID_UNIT #This makes the character move 1 tile forward instantly
		var end_position = position + (transform.basis.z * GRID_UNIT)#This makes the character move smoothly 1 grid_unit per second
		var movement_tween = create_tween()
		movement_tween.tween_property(self,"position",end_position,1)#1 is the duration in seconds to move 1 tile. Need to incorporate speed at some point
		%Unit/PlayerMesh/AnimationPlayer.play("freehand_walk")
		await movement_tween.finished
	%Unit/PlayerMesh/AnimationPlayer.play("freehand_idle")

func _physics_process(delta: float) -> void:
	pass
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump_debug"):
		current_health -= 5
