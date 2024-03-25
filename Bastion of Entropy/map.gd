extends Spatial

var block_scene = preload("res://block.tscn")
var tween = null

var blocks = [
	Vector3(0, -1, 0),
	Vector3(0, 0, 1),
	Vector3(0, 1, 0),
]

func _ready():
	for block in blocks:
		var block_instance = block_scene.instance()
		block_instance.translation = block
		$Blocks.add_child(block_instance)

func _process(_delta):
	if tween != null and tween.is_running():
		return
	if Input.is_action_pressed("ui_left"):
		tween = get_tree().create_tween()
		tween.tween_property($CameraNode, "rotation_degrees:y", 90, 0.5).as_relative()
	elif Input.is_action_pressed("ui_right"):
		tween = get_tree().create_tween()
		tween.tween_property($CameraNode, "rotation_degrees:y", -90, 0.5).as_relative()
	elif Input.is_action_pressed("ui_up"):
		var next_block: Vector3 = $CameraNode.translation - 1 * Vector3(sin($CameraNode.rotation.y), 0, cos($CameraNode.rotation.y)).round()
		if blocks.has(next_block):
			return
		tween = get_tree().create_tween()
		tween.tween_property($CameraNode, "translation", next_block, 0.5)
	elif Input.is_action_pressed("ui_down"):
		var next_block = $CameraNode.translation + 1 * Vector3(sin($CameraNode.rotation.y), 0, cos($CameraNode.rotation.y)).round()
		if blocks.has(next_block):
			return
		tween = get_tree().create_tween()
		tween.tween_property($CameraNode, "translation", next_block, 0.5)
