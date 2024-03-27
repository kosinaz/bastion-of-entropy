extends Spatial

var block_scene = preload("res://block.tscn")
var stairs_scene = preload("res://stairs.tscn")
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
	blocks[Vector3(-1, 0, 3)] = null
	blocks[Vector3(-2, 0, 3)] = null
	blocks[Vector3(-2, 0, 4)] = null
	blocks[Vector3(-2, 0, 5)] = null
	blocks[Vector3(-1, 0, 5)] = null
	blocks[Vector3(-1, 0, 6)] = null
	blocks[Vector3(-1, 0, 7)] = null
	blocks[Vector3(-1, 0, 8)] = null
	blocks[Vector3(-1, 1, 5)] = null
	blocks[Vector3(-1, 1, 6)] = null
	blocks[Vector3(-1, 1, 7)] = null
	blocks[Vector3(-1, 1, 8)] = null
	blocks[Vector3(-2, 0, 5)] = null
	blocks[Vector3(-2, 0, 6)] = null
	blocks[Vector3(-2, 0, 7)] = null
	blocks[Vector3(-2, 0, 8)] = null
	blocks[Vector3(-2, 1, 5)] = null
	blocks[Vector3(-2, 1, 6)] = null
	blocks[Vector3(-2, 1, 7)] = null
	blocks[Vector3(-2, 1, 8)] = null
	blocks[Vector3(-3, 0, 5)] = null
	blocks[Vector3(-3, 0, 6)] = null
	blocks[Vector3(-3, 0, 7)] = null
	blocks[Vector3(-3, 0, 8)] = null
	blocks[Vector3(-3, 1, 5)] = null
	blocks[Vector3(-3, 1, 6)] = null
	blocks[Vector3(-3, 1, 7)] = null
	blocks[Vector3(-3, 1, 8)] = null
	blocks[Vector3(0, 0, 4)] = "stairs180"
	blocks[Vector3(1, 0, 0)] = null
	blocks[Vector3(2, 0, 0)] = null
	blocks[Vector3(3, 0, 0)] = null
	blocks[Vector3(-3, 0, 0)] = null
	blocks[Vector3(-2, 0, 0)] = null
	blocks[Vector3(-1, 0, 0)] = null
	blocks[Vector3(0, 1, 4)] = null
	blocks[Vector3(0, 1, 5)] = null
	blocks[Vector3(1, 1, 5)] = null
	blocks[Vector3(1, 0, 5)] = "stairs90"
	blocks[Vector3(2, 0, 5)] = null
	blocks[Vector3(2, 0, 4)] = "stairs0"
	blocks[Vector3(2, 1, 4)] = null
	blocks[Vector3(2, 1, 3)] = null
	blocks[Vector3(1, 1, 3)] = null
	blocks[Vector3(1, 0, 3)] = "stairs270"
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
			stairs_instance.translation = block
			$Blocks.add_child(stairs_instance)

func _process(_delta):
	if $Player.moving:
		return
	if Input.is_action_pressed("ui_left"):
		$Player.rotate_left()
	elif Input.is_action_pressed("ui_right"):
		$Player.rotate_right()
	elif Input.is_action_pressed("ui_up"):
		if blocks[$Player.get_forward_down_block()] == null:
			return
		elif blocks[$Player.get_forward_down_block()] == "stairs" + str($Player.get_map_rotation_plus(180)):
			$Player.move_forward_down_forward()
		elif blocks[$Player.get_forward_block()] == null:
			$Player.move_forward()
		elif blocks[$Player.get_forward_block()] == "stairs" + str($Player.get_map_rotation_plus(0)):
			$Player.move_forward_up_forward()
	elif Input.is_action_pressed("ui_down"):
		if blocks[$Player.get_backward_down_block()] == null:
			return
		elif blocks[$Player.get_backward_down_block()] == "stairs" + str($Player.get_map_rotation_plus(0)):
			$Player.move_backward_down_backward()
		elif blocks[$Player.get_backward_block()] == null:
			$Player.move_backward()
		elif blocks[$Player.get_backward_block()] == "stairs" + str($Player.get_map_rotation_plus(180)):
			$Player.move_backward_up_backward()
