extends Spatial

var block_scene = preload("res://block.tscn")
var stairs_scene = preload("res://stairs.tscn")
var tween = null
var moving = false
var blocks = {}

func _ready():
	for x in range(-10, 10):
		for z in range(-10, 10):
			for y in range(-10, 10):
				blocks[Vector3(x, y, z)] = "block"
	blocks[Vector3(0, 0, 0)] = null
	blocks[Vector3(0, 0, 1)] = null
	blocks[Vector3(0, 0, 2)] = null
	blocks[Vector3(0, 0, 3)] = null
	blocks[Vector3(0, 0, 4)] = "stairs180"
	blocks[Vector3(1, 0, 0)] = null
	blocks[Vector3(2, 0, 0)] = null
	blocks[Vector3(3, 0, 0)] = null
	blocks[Vector3(-3, 0, 0)] = null
	blocks[Vector3(-2, 0, 0)] = null
	blocks[Vector3(-1, 0, 0)] = null
	blocks[Vector3(0, 1, 4)] = null
	blocks[Vector3(0, 1, 5)] = null
	blocks[Vector3(0, 1, 6)] = null
	blocks[Vector3(0, 1, 7)] = null
	blocks[Vector3(0, 1, 8)] = null

	
	for block in blocks:
		if blocks[block] == null:
			continue
		if blocks[block] == "block":
			var block_instance = block_scene.instance()
			block_instance.translation = block
			$Blocks.add_child(block_instance)
		elif blocks[block].begins_with("stairs"):
			var stairs_instance = stairs_scene.instance()
			stairs_instance.rotation_degrees.y = int(blocks[block].right(6))
			stairs_instance.translation = Vector3(0, 0, 4)
			$Blocks.add_child(stairs_instance)

func _process(_delta):
	if moving:
		return
	if Input.is_action_pressed("ui_left"):
		moving = true
		tween = get_tree().create_tween()
		tween.tween_property($CameraNode, "rotation_degrees:y", round($CameraNode.rotation_degrees.y + 90), 0.5)
		tween.tween_callback(self, "_stop")
	elif Input.is_action_pressed("ui_right"):
		moving = true
		tween = get_tree().create_tween()
		tween.tween_property($CameraNode, "rotation_degrees:y", round($CameraNode.rotation_degrees.y - 90), 0.5)
		tween.tween_callback(self, "_stop")
	elif Input.is_action_pressed("ui_up"):
		var next_block: Vector3 = $CameraNode.translation - 1 * Vector3(sin($CameraNode.rotation.y), 0, cos($CameraNode.rotation.y)).round()
		print(next_block, $CameraNode.rotation_degrees.y)
		if blocks[next_block + Vector3(0, -1, 0)] == null:
			return
		if blocks[next_block + Vector3(0, -1, 0)] == "stairs" + str(int(round($CameraNode.rotation_degrees.y + 180)) % 360):
			moving = true
			var step1 = $CameraNode.translation - 0.5 * Vector3(sin($CameraNode.rotation.y), 0, cos($CameraNode.rotation.y))
			var step2 = $CameraNode.translation - 1.5 * Vector3(sin($CameraNode.rotation.y), 0, cos($CameraNode.rotation.y)) + Vector3(0, -1, 0)
			var step3 = $CameraNode.translation - 2 * Vector3(sin($CameraNode.rotation.y), 0, cos($CameraNode.rotation.y)).round() + Vector3(0, -1, 0)
			tween = get_tree().create_tween()
			tween.tween_property($CameraNode, "translation", step1, 0.25)
			tween.tween_property($CameraNode, "translation", step2, 0.5)
			tween.tween_property($CameraNode, "translation", step3, 0.25)
			tween.tween_callback(self, "_stop")
		if blocks[next_block] == null:
			moving = true
			tween = get_tree().create_tween()
			tween.tween_property($CameraNode, "translation", next_block, 0.5)
			tween.tween_callback(self, "_stop")
		elif blocks[next_block] == "stairs" + str(int(round($CameraNode.rotation_degrees.y)) % 360):
			moving = true
			var step1 = $CameraNode.translation - 0.5 * Vector3(sin($CameraNode.rotation.y), 0, cos($CameraNode.rotation.y))
			var step2 = $CameraNode.translation - 1.5 * Vector3(sin($CameraNode.rotation.y), 0, cos($CameraNode.rotation.y)) + Vector3(0, 1, 0)
			var step3 = $CameraNode.translation - 2 * Vector3(sin($CameraNode.rotation.y), 0, cos($CameraNode.rotation.y)).round() + Vector3(0, 1, 0)
			tween = get_tree().create_tween()
			tween.tween_property($CameraNode, "translation", step1, 0.25)
			tween.tween_property($CameraNode, "translation", step2, 0.5)
			tween.tween_property($CameraNode, "translation", step3, 0.25)
			tween.tween_callback(self, "_stop")
	elif Input.is_action_pressed("ui_down"):
		var next_block = $CameraNode.translation + 1 * Vector3(sin($CameraNode.rotation.y), 0, cos($CameraNode.rotation.y)).round()
		if blocks[next_block] == "block":
			return
		tween = get_tree().create_tween()
		tween.tween_property($CameraNode, "translation", next_block, 0.5)
	elif Input.is_action_pressed("ui_page_up"):
		tween = get_tree().create_tween()
		tween.tween_property($CameraNode, "translation", Vector3(0, 0.5, 0), 0.5).as_relative()
	elif Input.is_action_pressed("ui_page_down"):
		tween = get_tree().create_tween()
		tween.tween_property($CameraNode, "translation", Vector3(0, -0.5, 0), 0.5).as_relative()

func _stop():
	moving = false
	print("stopped at ", $CameraNode.translation)
