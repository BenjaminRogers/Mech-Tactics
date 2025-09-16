extends Node


func display_text(value, position: Vector3, is_critical: bool = false):
	var text_label = Label3D.new()
	text_label.global_position = position
	text_label.text = str(value)
	
	var color = "#FFF"
	if is_critical:
		color = "#B22"
	
	text_label.modulate = color
	text_label.font_size = 100
	text_label.outline_modulate = "#000"
	text_label.outline_size = 10
	text_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	
	call_deferred("add_child", text_label)
	
	var movement_tween = create_tween()
	movement_tween.set_parallel(true)
	movement_tween.tween_property(text_label, "position:y", text_label.position.y + .5, .25).set_ease(Tween.EASE_OUT)
	movement_tween.tween_property(text_label, "position:y", text_label.position.y, 0.5).set_ease(Tween.EASE_IN).set_delay(.5)

	await movement_tween.finished
	text_label.queue_free()
	
	
