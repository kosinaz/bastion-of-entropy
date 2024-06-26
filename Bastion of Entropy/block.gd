extends Spatial

var map_translation_initial = Vector3(0, -100, 0)
var map_translation = Vector3(0, 0, 0)

func move_down(target_y):
	get_parent().get_parent().blocks[map_translation] = null
	map_translation.y = target_y
	get_parent().get_parent().blocks[map_translation] = "block"
	var tween = get_tree().create_tween()
	tween.tween_property(self, "translation:y", map_translation.y, 0.5)

func move_up():
	get_parent().get_parent().blocks[map_translation] = null
	map_translation.y = map_translation_initial.y
	get_parent().get_parent().blocks[map_translation] = "block"
	var tween = get_tree().create_tween()
	tween.tween_property(self, "translation:y", map_translation.y, 0.5)
