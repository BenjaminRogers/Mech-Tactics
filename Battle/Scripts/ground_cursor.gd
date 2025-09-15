extends Node3D
const GRID_UNIT = 2 #Used to convert from global position to grid position. Each grid coordinate is 2m on center
@onready var hovered_unit: Node3D
var current_grid_position: Vector3
var current_tile_id: int
var active_unit: Unit
var active_unit_tile_id: int
var active_unit_menu_scene = preload("res://Battle/Menu Templates/active_unit_menu.tscn")
var inactive_unit_menu_scene = preload("res://Battle/Menu Templates/inactive_unit_menu.tscn")
var selected_weapon: Weapon
var tile_material_blue = preload("res://Battle/Tiles/Materials/Blue.tres")
var tile_material_green = preload("res://Battle/Tiles/Materials/Green.tres")
var tile_material_red = preload("res://Battle/Tiles/Materials/Red.tres")
var tile_material_white = preload("res://Battle/Tiles/Materials/White.tres")

@onready var active_unit_menu
@onready var inactive_unit_menu
@onready var is_menu_open = false
@onready var is_unit_moving = false
@onready var is_unit_attacking = false

func start_turn() -> void:
	active_unit = %UnitManager.active_unit
	selected_weapon = null
	position = active_unit.global_position
	await get_tree().create_timer(.1).timeout
	active_unit.evasion = 0
	active_unit.remove_evasion_icons()
	unit_hovering()
	active_unit_tile_id = %DownRayCast.get_collider().id
	active_unit.is_allowed_to_move = true
func end_turn() -> void:
	await %UnitManager.calculate_next_active_unit()
	start_turn()
func get_tile_id() -> int:
	if %DownRayCast.is_colliding():
		print(str("selected tile:", %DownRayCast.get_collider().id))
		return %DownRayCast.get_collider().id
	else:
		return -1 #This should never happen
func select_weapon(weapon: Weapon) -> void:
	selected_weapon = weapon
func height_update() -> void:
	var collided_tile
	await get_tree().create_timer(.1).timeout #Need timer to ensure X, Z position is updated before ray cast
	if %UpRayCast.is_colliding():
		collided_tile = %UpRayCast.get_collider()
		print(str("UpRayCast: ", collided_tile))
		position.y = collided_tile.global_position.y
	elif %DownRayCast.is_colliding():
		collided_tile = %DownRayCast.get_collider()
		print(str("DownRayCast: ", collided_tile))
		position.y = collided_tile.global_position.y

#Function in charge of showing the stats of the unit that the cursor is currently overlapping
#Have to call this function every time the cursor moves for any reason (This seems bad)
#Maybe think of something smarter
func unit_hovering():
	await get_tree().create_timer(.1).timeout #Need timer to ensure unit detection area is updated before trying to use it.
	if not hovered_unit: #Case: Cursor moving FROM empty tile
		if %UnitDetectionArea.has_overlapping_bodies(): #TO occupied tile
			hovered_unit = %UnitDetectionArea.get_overlapping_bodies()[0].get_parent()
			hovered_unit.update_menus()
			hovered_unit.toggle_mini_stats_window_visibility()
		else:#TO empty tile
			hovered_unit = null
	elif hovered_unit: #Case: Cursor moving FROM occupied tile
		if %UnitDetectionArea.has_overlapping_bodies(): #TO occupied tile
			hovered_unit.toggle_mini_stats_window_visibility()
			hovered_unit = %UnitDetectionArea.get_overlapping_bodies()[0].get_parent()
			hovered_unit.update_menus()
			hovered_unit.toggle_mini_stats_window_visibility()
		else: #TO empty tile
			hovered_unit.toggle_mini_stats_window_visibility()
			hovered_unit = null
		
		#####Change individual instance tile mesh instance without affecting others#####
		#collided_tile_mesh = collided_tile.get_parent()
		#collided_tile_material = collided_tile_mesh.get_active_material(0).duplicate()
		#collided_tile_material.albedo_color = Color(140, 140, 140, 255)
		#collided_tile_mesh.material_override = collided_tile_material
		##########################################################################################
func weapon_selected(weapon: Weapon):
	selected_weapon = weapon
	%PathManager.get_attack_range(active_unit, selected_weapon)
	is_unit_attacking = true
	close_menu()

func wait_button_up():
	close_menu()
	end_turn()
func move_button_up():
	if active_unit.is_allowed_to_move:
		await get_tree().create_timer(.1).timeout
		current_tile_id = get_tile_id()
		close_menu()
		%PathManager.get_movement_range(active_unit)
		is_unit_moving = true
	else:
		print("No!")

func open_menu() -> void:
	if hovered_unit == active_unit: #Only opens menu if there is a unit selected
		active_unit_menu = active_unit_menu_scene.instantiate()
		add_child(active_unit_menu)
		if not active_unit.is_allowed_to_move:
			active_unit_menu.disable_move_button()
		active_unit_menu.cursor = self
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
	pass
func _physics_process(delta: float) -> void:
	pass
func _input(event: InputEvent) -> void:
	if not is_menu_open:
		if event.is_action_pressed("cursor_left"):
			position.x += GRID_UNIT
			current_grid_position.x += 1
			height_update()
			unit_hovering()
		if event.is_action_pressed("cursor_right"):
			position.x += -GRID_UNIT
			current_grid_position.x += -1
			height_update()
			unit_hovering()
		if event.is_action_pressed("cursor_up"):
			position.z += GRID_UNIT
			current_grid_position.z += 1
			height_update()
			unit_hovering()
		if event.is_action_pressed("cursor_down"):
			position.z += -GRID_UNIT
			current_grid_position.z += -1
			height_update()
			unit_hovering()
		if event.is_action_pressed("print_debug"):
			print(str("var current_grid_position: ", current_grid_position))
			print(str("cursor mesh position: ", global_position))
			print(str("Active unit: ", active_unit))
			print(str("Hovered unit var: ", hovered_unit))
			print(str("tile ID variable:"),%DownRayCast.get_collider().id)
			print(str("movement cost: "), %PathManager.astar._compute_cost(0, 4))
			print(str("Tile Global position:", %DownRayCast.get_collider().global_position))
			
		if event.is_action_pressed("jump_debug"):
			#end_turn()
			#%PathManager.get_movement_range(active_unit)
			#%PathManager.get_attack_range(active_unit, active_unit.get_node("Weapons").get_child(0))
			print(selected_weapon)
		if event.is_action_released("accept"):
			if not hovered_unit and not is_unit_moving:
				position = active_unit.global_position
				unit_hovering()
			if is_unit_moving: 
				current_tile_id = get_tile_id()
				if %DownRayCast.get_collider().get_parent().get_parent().visible == true: #Only moves if the tile is within movement range
					var movement_route = %PathManager.get_route(active_unit_tile_id, current_tile_id)
					%PathManager.disable_visible_tiles()
					is_unit_moving = false
					active_unit.is_allowed_to_move = false
					await active_unit.move(movement_route)
					unit_hovering()
			elif is_unit_attacking:
				if %DownRayCast.get_collider().get_parent().get_parent().visible == true:
					if %UnitDetectionArea.has_overlapping_bodies():
						var target_unit = %UnitDetectionArea.get_overlapping_bodies()[0].get_parent()
						%PathManager.disable_visible_tiles()
						await active_unit.attack_target(selected_weapon, target_unit)
						if target_unit.current_health <= 0:
							await %UnitManager.remove_unit(target_unit)
						is_unit_attacking = false
						end_turn()
			else:
					unit_hovering()
					open_menu()
	if event.is_action_released("cancel"):
		if is_menu_open:
			close_menu()
			is_menu_open = false
		if is_unit_moving:
			%PathManager.disable_visible_tiles()
			is_unit_moving = false
			open_menu()
		if is_unit_attacking:
			%PathManager.disable_visible_tiles()
			is_unit_attacking = false
			open_menu()
	
