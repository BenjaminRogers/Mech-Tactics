class_name Unit extends Node3D
const GRID_UNIT = 2
@onready var direction
@onready var animation_player = $PlayerMesh/AnimationPlayer
@onready var mini_stats_window = %MiniStatsWindow
@onready var is_allowed_to_move: bool = true
var mini_stats_window_default_position = Vector2(-274.0, 552.0)
var mini_stats_window_display_position = Vector2(0.0, 552.0)
var evasion_icon = preload("res://Battle/Menu Templates/Sprites/evasion_icon.tscn")
var evasion: int = 0
const EVASION_WEIGHT = 7.5
### Stats ###
@export var movement = 2
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
func update_menus() -> void:
	%HPBar.value = current_health
	%HPNumeric.text = str(current_health, "/", max_health)
	%CTBar.value = charge_time
func toggle_mini_stats_window_visibility() -> void:
	var movement_tween = create_tween()
	movement_tween.set_parallel(true)
	if mini_stats_window.visible:
		mini_stats_window.position = mini_stats_window_display_position
		movement_tween.tween_property(mini_stats_window, "position", mini_stats_window_default_position, .2)
		await movement_tween.finished
		mini_stats_window.visible = false
	elif mini_stats_window.visible == false:
		mini_stats_window.visible = true
		mini_stats_window.position = mini_stats_window_default_position
		movement_tween.tween_property(mini_stats_window, "position", mini_stats_window_display_position, .2)
		await movement_tween.finished

func add_evasion_icons() -> void:
	for i in evasion:
		%EvasionContainer.add_child(evasion_icon.instantiate())
func remove_evasion_icons() -> void:
	if %EvasionContainer.get_child_count() > 0:
		for icon in %EvasionContainer.get_children():
			icon.queue_free()
func calculate_chance_to_hit(weapon: Weapon, target: Unit) -> float:
	var chance_to_hit: float = weapon.accuracy - (target.evasion * EVASION_WEIGHT)
	return chance_to_hit
func _ready() -> void:
	initialize_menu()
func attack_target(weapon: Weapon, target: Unit) -> void:
	var rng = RandomNumberGenerator.new()
	var random_roll = rng.randf_range(0, 100)
	var hit_chance: float = calculate_chance_to_hit(weapon, target)
	await rotate_towards(target.global_position)
	print(str("Hit chance: "), hit_chance)
	print(str("random_roll: "), random_roll)
	if random_roll < hit_chance:
		print("Hit!")
		FloatingText.display_text(weapon.damage, target.get_node("FloatingTextOrigin").global_position)
		target.current_health -= weapon.damage
	else:
		print("Miss!")
		FloatingText.display_text("Missed!", target.get_node("FloatingTextOrigin").global_position)
func move(route: PackedVector3Array) -> void:
	var current_delta = get_process_delta_time()
	for i in range(1, route.size()):
		var next_position: Vector3 = (route[i])
		#position += transform.basis.z * GRID_UNIT #This makes the character move 1 tile forward instantly
		await rotate_towards(next_position)
		var end_position = position + (transform.basis.z * GRID_UNIT)#This makes the character move smoothly 1 grid_unit per second
		
		if next_position.y > end_position.y:
			end_position = end_position + (transform.basis.y * (next_position.y - end_position.y))
		elif next_position.y < end_position.y:
			end_position = end_position - (transform.basis.y * (end_position.y - next_position.y))
		
		var movement_tween = create_tween()
		movement_tween.tween_property(self,"position",end_position,1)#1 is the duration in seconds to move 1 tile. Need to incorporate speed at some point
		%Unit/PlayerMesh/AnimationPlayer.play("freehand_walk")
		await movement_tween.finished
	evasion = (route.size() - 1)
	add_evasion_icons()
	%Unit/PlayerMesh/AnimationPlayer.play("freehand_idle")

###########################################################################################
		#I stole this from the internet I have no idea why this works
func rotate_towards(target_position) -> void:
	var direction = (target_position - global_transform.origin).normalized()
	var target_angle = atan2(direction.x, direction.z)
	var new_rotation_y = rad_to_deg(target_angle)
	if abs(rotation_degrees.y - new_rotation_y) > 1:
		var rotation_tween = create_tween()
		rotation_tween.tween_property(self, "rotation_degrees", Vector3(0, new_rotation_y, 0), .75)
		await rotation_tween.finished
###########################################################################################
func _physics_process(delta: float) -> void:
	pass
	#position = global_transform.origin.move_toward(Vector3(4,0,10),.01) <-- Moves towards point
func _input(event: InputEvent) -> void:
	pass#if event.is_action_pressed("jump_debug"):
		#current_health -= 5
