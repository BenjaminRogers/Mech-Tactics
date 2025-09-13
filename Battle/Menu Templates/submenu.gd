extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func add_button(button: Button, text: String):
	button.text = text
	%VBoxContainer.add_child(button)
func focus_first_element():
	if %VBoxContainer.get_child_count() > 0:
		%VBoxContainer.get_child(0).grab_focus()
