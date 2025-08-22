extends Node3D
const GRID_UNIT = 2
@onready var hovered_unit: Node3D
var current_grid_position: Vector3
var current_tile_id: int
var active_unit: Node3D
@onready var selected_tile_id: int = -1
var active_unit_menu_scene = preload("res://Battle/Menu Templates/active_unit_menu.tscn")
var inactive_unit_menu_scene = preload("res://Battle/Menu Templates/inactive_unit_menu.tscn")
@onready var active_unit_menu
@onready var inactive_unit_menu
@onready var is_menu_open = false
@onready var is_tile_selected = false

func start_turn() -> void:
	active_unit = %UnitManager.active_unit

func end_turn() -> void:
	%UnitManager.calculate_next_active_unit()
	start_turn()

#Function in charge of showing the stats of the unit that the cursor is currently overlapping
#Have to call this function every time the cursor moves for any reason (This seems like a pain in the ass)
#Maybe think of something smarter
func unit_hovering():
	await get_tree().create_timer(.1).timeout #Need timer to ensure unit detection area is updated before trying to use it.
	if not hovered_unit: #Case: Cursor moving FROM empty tile
		if %UnitDetectionArea.has_overlapping_bodies(): #TO occupied tile
			hovered_unit = %UnitDetectionArea.get_overlapping_bodies()[0].get_parent()
			hovered_unit.toggle_mini_stats_window_visibility()
		else:#TO empty tile
			hovered_unit = null
	elif hovered_unit: #Case: Cursor moving FROM occupied tile
		if %UnitDetectionArea.has_overlapping_bodies(): #TO occupied tile
			hovered_unit.toggle_mini_stats_window_visibility()
			hovered_unit = %UnitDetectionArea.get_overlapping_bodies()[0].get_parent()
			hovered_unit.toggle_mini_stats_window_visibility()
		else: #TO empty tile
			hovered_unit.toggle_mini_stats_window_visibility()
			hovered_unit = null
		
func move_button_up():
	current_tile_id = %PathManager.get_tile_id(current_grid_position)
	selected_tile_id = current_tile_id
	close_menu()
	is_menu_open = false
	is_tile_selected = true


func open_menu() -> void:
	if hovered_unit == active_unit: #Only opens menu if there is a unit selected
		active_unit_menu = active_unit_menu_scene.instantiate()
		active_unit_menu.get_node("PanelContainer/MarginContainer/VBoxContainer/MoveButton").pressed.connect(move_button_up)
		add_child(active_unit_menu)
		is_menu_open = true
	else:
		inactive_unit_menu = inactive_unit_menu_scene.instantiate()
		#active_unit_menu.get_node() -> add functionality to status button maybe?
		add_child(inactive_unit_menu)
		is_menu_open = true
func close_menu() -> void:
	if is_instance_valid(active_unit_menu):
		is_menu_open = false
		active_unit_menu.queue_free()
	if is_instance_valid(inactive_unit_menu):
		is_menu_open = false
		inactive_unit_menu.queue_free()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_turn()
func _physics_process(delta: float) -> void:
	pass
func _input(event: InputEvent) -> void:
	if not is_menu_open:
		if event.is_action_pressed("cursor_left"):
			position.x += GRID_UNIT
			current_grid_position.x += 1
			unit_hovering()
		if event.is_action_pressed("cursor_right"):
			position.x += -GRID_UNIT
			current_grid_position.x += -1
			unit_hovering()
		if event.is_action_pressed("cursor_up"):
			position.z += GRID_UNIT
			current_grid_position.z += 1
			unit_hovering()
		if event.is_action_pressed("cursor_down"):
			position.z += -GRID_UNIT
			current_grid_position.z += -1
			unit_hovering()
		if event.is_action_pressed("print_debug"):
			print(str("var current_grid_position: ", current_grid_position))
			print(str("cursor mesh position: ", global_position))
			print(str("Active unit: ", active_unit))
			print(str("Hovered unit var: ", hovered_unit))
			
		if event.is_action_pressed("jump_debug"):
			end_turn()
		if event.is_action_released("accept"):
			if not hovered_unit:
				position = active_unit.position
				unit_hovering()
			if is_tile_selected:
				current_tile_id = %PathManager.get_tile_id(current_grid_position)
				var movement_route = %PathManager.get_route(selected_tile_id, current_tile_id)
				active_unit.move(movement_route)
				is_tile_selected = false
			else:
					open_menu()
	if event.is_action_released("cancel"):
		close_menu()
	
	
