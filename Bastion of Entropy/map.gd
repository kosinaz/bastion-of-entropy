extends Spatial

var block_scene = preload("res://block.tscn")
var stairs_scene = preload("res://stairs.tscn")
var gate_scene = preload("res://gate.tscn")
var orb_scene = preload("res://orb.tscn")
var portal_scene = preload("res://portal.tscn")
var moving = false
var blocks = {}
var orbs = []
var moving_blocks = []
var time = 0
var time_direction = 1
var flips = 0
var up_is_down = false
var left_is_down = false
var down_is_down = false
var right_is_down = false
var portal = null
var map_data = MapData.new()

func _ready():
	for x in range(-20, 20):
		for z in range(-20, 20):
			for y in range(-20, 20):
				blocks[Vector3(x, y, z)] = null
	var map_data_rows = map_data.map.split("\n")
	for map_data_row in map_data_rows:
		var content = map_data_row.split(" ")
		var block_name = "block"
		if content[3] + content[4] + content[5] == "238238238":
			$Player.translation = Vector3(int(content[0]), int(content[2]), int(content[1]))
			$Player.map_translation = $Player.translation
			block_name = null
		elif content[3] + content[4] + content[5] == "051102":
			block_name = "stairs"
		elif content[3] + content[4] + content[5] == "23800":
			block_name = "gate"
		elif content[3] + content[4] + content[5] == "00238":
			block_name = "orb"
		elif content[3] + content[4] + content[5] == "02380":
			block_name = "portal"
		elif content[3] + content[4] + content[5] == "686868":
			block_name = "moving_block"
		blocks[Vector3(int(content[0]), int(content[2]), int(content[1]))] = block_name
	
	for block in blocks:
		if blocks[block] == null:
			continue
		if blocks[block] == "block":
			var block_instance = block_scene.instance()
			block_instance.translation = block
			$Blocks.add_child(block_instance)
		elif blocks[block].begins_with("gate"):
			var gate_instance = gate_scene.instance()
			if blocks[block + Vector3(0, 0, 1)] == null:
				blocks[block] += "90"
				gate_instance.rotation_degrees.y = 90
			gate_instance.translation = block
			$Blocks.add_child(gate_instance)
		elif blocks[block] == "stairs":
			var stairs_instance = stairs_scene.instance()
			if blocks[block + Vector3(1, 0, 0)] == null:
				blocks[block] += "90"
				stairs_instance.rotation_degrees.y = 90
			elif blocks[block + Vector3(-1, 0, 0)] == null:
				blocks[block] += "270"
				stairs_instance.rotation_degrees.y = 270
			elif blocks[block + Vector3(0, 0, 1)] == null:
				blocks[block] += "0"
				stairs_instance.rotation_degrees.y = 0
			elif blocks[block + Vector3(0, 0, -1)] == null:
				blocks[block] += "180"
				stairs_instance.rotation_degrees.y = 180
			stairs_instance.translation = block
			$Blocks.add_child(stairs_instance)
		elif blocks[block] == "moving_block":
			var block_instance = block_scene.instance()
			block_instance.translation = block
			block_instance.map_translation_initial = block
			block_instance.map_translation = block
			$Blocks.add_child(block_instance)
			moving_blocks.append(block_instance)
		elif blocks[block] == "orb":
			var orb_instance = orb_scene.instance()
			orb_instance.translation = block
			orbs.append(orb_instance)
			$Orbs.add_child(orb_instance)
			blocks[block] = null
		elif blocks[block] == "portal":
			portal = portal_scene.instance()
			portal.translation = block
			add_child(portal)
			blocks[block] = null

func _process(_delta):
	if blocks[$Player.map_translation] != null:
		$Player/GameOverPanel.show()
	if moving:
		return
	elif Input.is_action_just_pressed("ui_select") and flips > 0:
		flip_time()
		return
	elif time_direction == 1 and time > 13:
		if flips == 0:
			$Player/GameOverPanel2.show()
		return
	elif time_direction == -1 and time < 1:
		if flips == 0:
			$Player/GameOverPanel2.show()
		return
	elif Input.is_action_pressed("ui_left") or left_is_down:
		moving = true
		$Player.rotate_left()
	elif Input.is_action_pressed("ui_right") or right_is_down:
		moving = true
		$Player.rotate_right()
	elif Input.is_action_pressed("ui_up") or up_is_down:
		if blocks[$Player.get_forward_down_block()] == null:
			return
		elif blocks[$Player.get_forward_down_block()] == "stairs" + str($Player.get_map_rotation_plus(180)):
			moving = true
			$Player.move_forward_down_forward()
		elif blocks[$Player.get_forward_block()] == null:
			moving = true
			$Player.move_forward()
		elif blocks[$Player.get_forward_block()] == "stairs" + str($Player.get_map_rotation_plus(0)):
			moving = true
			$Player.move_forward_up_forward()
	elif Input.is_action_pressed("ui_down") or down_is_down:
		if blocks[$Player.get_backward_down_block()] == null:
			return
		elif blocks[$Player.get_backward_down_block()] == "stairs" + str($Player.get_map_rotation_plus(0)):
			moving = true
			$Player.move_backward_down_backward()
		elif blocks[$Player.get_backward_block()] == null:
			moving = true
			$Player.move_backward()
		elif blocks[$Player.get_backward_block()] == "stairs" + str($Player.get_map_rotation_plus(180)):
			moving = true
			$Player.move_backward_up_backward()
	if moving:
		time += time_direction
		$"%TimeLabel".text = str(time / 2.0)
		$"%ProgressBar".value = time / 0.14
		if time_direction == 1:
			for block in moving_blocks:
				if time != block.map_translation_initial.y:
					continue
				var total_y = 0
				var current_y = block.translation.y
				while blocks[Vector3(block.translation.x, current_y - 1, block.translation.z)] == null:
					total_y += 1
					current_y -= 1
				if total_y > 0:
					moving = true
					if $Player.map_translation == block.map_translation + Vector3(0, 1, 0):
						$Player.move_down(current_y + 1)
						$Player/GameOverPanel.show()
					block.move_down(current_y)
		else:
			for block in moving_blocks:
				if time != block.map_translation_initial.y - 1:
					continue
				if block.map_translation.y < block.map_translation_initial.y:
					moving = true
					if $Player.map_translation == block.map_translation + Vector3(0, 1, 0):
						$Player.move_up(block.map_translation_initial.y + 1)
					block.move_up()
		for orb in orbs:
			if orb.translation == $Player.map_translation:
				orbs.erase(orb)
				orb.queue_free()
				flips += 3
				$"%Flip".text = " x " + str(flips)
				$"%Flip".disabled = false
				return
		if portal.translation == $Player.map_translation:
			$Player/VictoryPanel.show()

func stop():
	moving = false

func _on_up_button_down():
	up_is_down = true

func _on_left_button_down():
	left_is_down = true

func _on_down_button_down():
	down_is_down = true

func _on_right_button_down():
	right_is_down = true

func _on_up_button_up():
	up_is_down = false

func _on_left_button_up():
	left_is_down = false

func _on_down_button_up():
	down_is_down = false

func _on_right_button_up():
	right_is_down = false

func _on_flip_pressed():
	flip_time()

func flip_time():
	time_direction = -time_direction
	flips -= 1
	$"%Flip".text = " x " + str(flips)
	if flips == 0:
		$"%Flip".disabled = true

func _on_restart_pressed():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
