extends Node3D
const GRID_UNIT = 2
@onready var hovering_unit: PhysicsBody3D
@onready var selected_unit: PhysicsBody3D
var current_coordinates: Vector3
var current_tile_id: int
@onready var selected_tile_id: int = -1
var menu_scene = preload("res://Scenes/unit_menu.tscn")
@onready var menu
@onready var is_menu_open = false
@onready var is_tile_selected = false

signal get_tile_id(position: Vector3)
signal get_route(start_tile: int, end_tile: int)

func unit_hovering(unit_body):
	hovering_unit = unit_body
func move_button_up():
	get_tile_id.emit(current_coordinates)
	selected_tile_id = current_tile_id
	close_menu()
	is_menu_open = false
	is_tile_selected = true
	

func open_menu() -> void:
	if hovering_unit: #Only opens menu if there is a unit selected
		menu = menu_scene.instantiate()
		menu.get_node("PanelContainer/MarginContainer/VBoxContainer/MoveButton").pressed.connect(move_button_up)
		add_child(menu)
		is_menu_open = true
		selected_unit = hovering_unit

func close_menu() -> void:
	if is_instance_valid(menu):
		is_menu_open = false
		menu.queue_free()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
func _process(delta: float) -> void:
	pass
func _input(event: InputEvent) -> void:
	if not is_menu_open:
		if event.is_action_pressed("cursor_left"):
			position.x += GRID_UNIT
			current_coordinates.x += 1
		if event.is_action_pressed("cursor_right"):
			position.x += -GRID_UNIT
			current_coordinates.x += -1
		if event.is_action_pressed("cursor_up"):
			position.z += GRID_UNIT
			current_coordinates.z += 1
		if event.is_action_pressed("cursor_down"):
			position.z += -GRID_UNIT
			current_coordinates.z += -1
		if event.is_action_pressed("print_debug"):
			print(str("var current_coordinates : ", current_coordinates))
			print(str("mesh position : ", global_position))
		if event.is_action_released("accept"):
			if is_tile_selected:
				get_tile_id.emit(current_coordinates)
				get_route.emit(selected_tile_id, current_tile_id)
				is_tile_selected = false
			else:
					open_menu()
	if event.is_action_released("cancel"):
		close_menu()
	
	
