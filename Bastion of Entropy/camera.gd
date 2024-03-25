extends Camera

var tween = null

var up = false
var down = false

func _process(_delta):
	if tween != null and tween.is_running():
		return
	if Input.is_action_pressed("ui_left"):
		tween = get_tree().create_tween()
		tween.tween_property(self, "rotation_degrees:y", 90, 0.5).as_relative()
	elif Input.is_action_pressed("ui_right"):
		tween = get_tree().create_tween()
		tween.tween_property(self, "rotation_degrees:y", -90, 0.5).as_relative()
	elif Input.is_action_pressed("ui_up"):
		tween = get_tree().create_tween()
		tween.tween_property(self, "translation", -2 * Vector3(sin(rotation.y), 0, cos(rotation.y)), 0.5).as_relative()
	elif Input.is_action_pressed("ui_down"):
		tween = get_tree().create_tween()
		tween.tween_property(self, "translation", 2 * Vector3(sin(rotation.y), 0, cos(rotation.y)), 0.5).as_relative()
