extends Camera

func _unhandled_input(event):
	if event.is_action_pressed("ui_up"):
		translation.x -= 2 * sin(rotation.y)
		translation.z -= 2 * cos(rotation.y)
	if event.is_action_pressed("ui_down"):
		translation.x += 2 * sin(rotation.y)
		translation.z += 2 * cos(rotation.y)
	if event.is_action_pressed("ui_left"):
		rotation_degrees.y += 90
	if event.is_action_pressed("ui_right"):
		rotation_degrees.y -= 90
