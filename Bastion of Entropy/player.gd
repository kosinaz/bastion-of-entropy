extends Spatial

var map_rotation = 0
var map_translation = Vector3(0, 0, 0)
var moving = false

func rotate_left():
	moving = true
	map_rotation += 90
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees:y", map_rotation, 0.5)
	tween.tween_callback(self, "_stop")

func rotate_right():
	moving = true
	map_rotation -= 90
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees:y", map_rotation, 0.5)
	tween.tween_callback(self, "_stop")

func get_map_rotation_plus(degrees):
	var rotation = (map_rotation + degrees) % 360
	if rotation < 0:
		rotation = 360 + rotation
	return rotation

func get_forward_block():
	return map_translation - 1 * Vector3(sin(deg2rad(map_rotation)), 0, cos(deg2rad(map_rotation))).round()

func get_forward_down_block():
	return get_forward_block() + Vector3(0, -1, 0)

func get_forward_down_forward_block():
	return get_forward_down_block() - 1 * Vector3(sin(deg2rad(map_rotation)), 0, cos(deg2rad(map_rotation))).round()
	
func get_forward_up_forward_block():
	return map_translation - 2 * Vector3(sin(deg2rad(map_rotation)), 0, cos(deg2rad(map_rotation))).round() + Vector3(0, 1, 0)

func get_backward_block():
	return map_translation + 1 * Vector3(sin(deg2rad(map_rotation)), 0, cos(deg2rad(map_rotation))).round()

func get_backward_down_block():
	return get_backward_block() + Vector3(0, -1, 0)

func get_backward_down_backward_block():
	return get_backward_down_block() + 1 * Vector3(sin(deg2rad(map_rotation)), 0, cos(deg2rad(map_rotation))).round()
	
func get_backward_up_backward_block():
	return map_translation + 2 * Vector3(sin(deg2rad(map_rotation)), 0, cos(deg2rad(map_rotation))).round() + Vector3(0, 1, 0)

func move_forward_down_forward():
	moving = true
	map_translation = get_forward_down_forward_block()
	var tween_x = get_tree().create_tween()
	tween_x.tween_property(self, "translation:x", map_translation.x, 1)
	tween_x.tween_callback(self, "_stop")
	var tween_y = get_tree().create_tween()
	tween_y.tween_interval(0.3)
	tween_y.tween_property(self, "translation:y", map_translation.y, 0.5)
	var tween_z = get_tree().create_tween()
	tween_z.tween_property(self, "translation:z", map_translation.z, 1)
	
func move_forward():
	moving = true
	map_translation = get_forward_block()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "translation", map_translation, 0.5)
	tween.tween_callback(self, "_stop")

func move_forward_up_forward():
	moving = true
	map_translation = get_forward_up_forward_block()
	var tween_x = get_tree().create_tween()
	tween_x.tween_property(self, "translation:x", map_translation.x, 1)
	tween_x.tween_callback(self, "_stop")
	var tween_y = get_tree().create_tween()
	tween_y.tween_interval(0.3)
	tween_y.tween_property(self, "translation:y", map_translation.y, 0.5)
	var tween_z = get_tree().create_tween()
	tween_z.tween_property(self, "translation:z", map_translation.z, 1)

func move_backward_down_backward():
	moving = true
	map_translation = get_backward_down_backward_block()
	var tween_x = get_tree().create_tween()
	tween_x.tween_property(self, "translation:x", map_translation.x, 1)
	tween_x.tween_callback(self, "_stop")
	var tween_y = get_tree().create_tween()
	tween_y.tween_interval(0.2)
	tween_y.tween_property(self, "translation:y", map_translation.y, 0.5)
	var tween_z = get_tree().create_tween()
	tween_z.tween_property(self, "translation:z", map_translation.z, 1)

func move_backward():
	moving = true
	map_translation = get_backward_block()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "translation", map_translation, 0.5)
	tween.tween_callback(self, "_stop")

func move_backward_up_backward():
	moving = true
	map_translation = get_backward_up_backward_block()
	var tween_x = get_tree().create_tween()
	tween_x.tween_property(self, "translation:x", map_translation.x, 1)
	tween_x.tween_callback(self, "_stop")
	var tween_y = get_tree().create_tween()
	tween_y.tween_interval(0.2)
	tween_y.tween_property(self, "translation:y", map_translation.y, 0.5)
	var tween_z = get_tree().create_tween()
	tween_z.tween_property(self, "translation:z", map_translation.z, 1)

func _stop():
	moving = false
