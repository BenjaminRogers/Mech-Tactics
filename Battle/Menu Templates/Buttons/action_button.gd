class_name ActionButton extends Button
var label_name: String
var range: int
var damage: int
var action_node: Weapon
var parent_menu: Menu
signal weapon_selected
func setup():
	pressed.connect(_on_pressed)
func _on_pressed():
	parent_menu.cursor.weapon_selected(action_node)
	
