extends Spatial

var block_scene = preload("res://block.tscn")
var stairs_scene = preload("res://stairs.tscn")
var tween = null

var blocks = []

func _ready():
	for x in range(-10, 10):
		for z in range(-10, 10):
			for y in range(-10, 10):
				blocks.append(Vector3(x, y, z))
	blocks.erase(Vector3())
	blocks.erase(Vector3(0, 0, 1))
	blocks.erase(Vector3(0, 0, 2))
	blocks.erase(Vector3(0, 0, 3))
	blocks.erase(Vector3(0, 0, 4))
	blocks.erase(Vector3(1, 0, 0))
	blocks.erase(Vector3(2, 0, 0))
	blocks.erase(Vector3(3, 0, 0))
	blocks.erase(Vector3(-3, 0, 0))
	blocks.erase(Vector3(-2, 0, 0))
	blocks.erase(Vector3(-1, 0, 0))
	
	for block in blocks:
		var block_instance = block_scene.instance()
		block_instance.translation = block
		$Blocks.add_child(block_instance)
	var stairs_instance = stairs_scene.instance()
	stairs_instance.translation = Vector3(0, 0, 4)
	$Blocks.add_child(stairs_instance)

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
