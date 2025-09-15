class_name Menu extends Control
var action_menu = preload("res://Battle/Menu Templates/empty_submenu.tscn")
var cursor: Node3D
signal action_performed
func _ready() -> void:
	%MoveButton.grab_focus()
	%MoveButton.pressed.connect(get_parent().move_button_up)
	%ActButton.pressed.connect(open_weapon_menu)
	%WaitButton.pressed.connect(get_parent().wait_button_up)
func open_weapon_menu():
	var active_unit = get_parent().active_unit
	var sub_menu = action_menu.instantiate()
	if active_unit.get_node("Weapons").get_child_count() > 0:
		var weapon_array = active_unit.get_node("Weapons").get_children()
		for weapon in weapon_array:
			var weapon_button = ActionButton.new()
			weapon_button.action_node = weapon
			weapon_button.parent_menu = self
			sub_menu.add_button(weapon_button, weapon.string_name)
			sub_menu.position = position
			sub_menu.position.x = position.x + 150
			sub_menu.position.y += 40
			weapon_button.setup()
		add_child(sub_menu)
		sub_menu.focus_first_element()
func disable_move_button() -> void:
	%MoveButton.disabled = true
func _process(delta: float) -> void:
	pass
