extends CanvasLayer

onready var blocks = $"%MapPresent".blocks
onready var moving_blocks_future = $"%MapFuture".moving_blocks
onready var moving_blocks_present = $"%MapPresent".moving_blocks
onready var moving_blocks_past = $"%MapPast".moving_blocks
onready var orbs = $"%MapPresent".orbs
onready var portal = $"%MapPresent".portal
onready var player_future = $"%MapFuture/Player"
onready var player_present = $"%MapPresent/Player"
onready var player_past = $"%MapPast/Player"
var time = 0
var time_direction = 1
var flips = 0
var up_is_down = false
var left_is_down = false
var down_is_down = false
var right_is_down = false

func _process(_delta):
	for orb in orbs:
		orb.hide()
		orb.show()
	if blocks[player_present.map_translation] != null:
		$GameOverPanel.show()
	if player_past.moving or player_present.moving or player_future.moving:
		return
	if Input.is_action_just_pressed("ui_select") and flips > 0:
		flip_time()
		return
	elif time_direction == 1 and time > 13:
		if flips == 0:
			$GameOverPanel2.show()
		return
	elif time_direction == -1 and time < 1:
		if flips == 0:
			$GameOverPanel2.show()
		return
	elif Input.is_action_pressed("ui_left") or left_is_down:
		player_past.moving = true
		player_present.moving = true
		player_future.moving = true
		player_past.rotate_left()
		player_present.rotate_left()
		player_future.rotate_left()
	elif Input.is_action_pressed("ui_right") or right_is_down:
		player_past.moving = true
		player_present.moving = true
		player_future.moving = true
		player_past.rotate_right()
		player_present.rotate_right()
		player_future.rotate_right()
	elif Input.is_action_pressed("ui_up") or up_is_down:
		if blocks[player_present.get_forward_down_block()] == null:
			return
		elif blocks[player_present.get_forward_down_block()] == "stairs" + str(player_present.get_map_rotation_plus(180)):
			player_past.moving = true
			player_present.moving = true
			player_future.moving = true
			player_past.move_forward_down_forward()
			player_present.move_forward_down_forward()
			player_future.move_forward_down_forward()
		elif blocks[player_present.get_forward_block()] == null:
			player_past.moving = true
			player_present.moving = true
			player_future.moving = true
			player_past.move_forward()
			player_present.move_forward()
			player_future.move_forward()
		elif blocks[player_present.get_forward_block()] == "stairs" + str(player_present.get_map_rotation_plus(0)):
			player_past.moving = true
			player_present.moving = true
			player_future.moving = true
			player_past.move_forward_up_forward()
			player_present.move_forward_up_forward()
			player_future.move_forward_up_forward()
	elif Input.is_action_pressed("ui_down") or down_is_down:
		if blocks[player_present.get_backward_down_block()] == null:
			return
		elif blocks[player_present.get_backward_down_block()] == "stairs" + str(player_present.get_map_rotation_plus(0)):
			player_past.moving = true
			player_present.moving = true
			player_future.moving = true
			player_past.move_backward_down_backward()
			player_present.move_backward_down_backward()
			player_future.move_backward_down_backward()
		elif blocks[player_present.get_backward_block()] == null:
			player_past.moving = true
			player_present.moving = true
			player_future.moving = true
			player_past.move_backward()
			player_present.move_backward()
			player_future.move_backward()
		elif blocks[player_present.get_backward_block()] == "stairs" + str(player_present.get_map_rotation_plus(180)):
			player_past.moving = true
			player_present.moving = true
			player_future.moving = true
			player_past.move_backward_up_backward()
			player_present.move_backward_up_backward()
			player_future.move_backward_up_backward()
	if player_past.moving or player_present.moving or player_future.moving:
		time += time_direction
		$"%TimeLabel".text = str(time / 2.0)
		$"%ProgressBar".value = time / 0.14
		for block in moving_blocks_past:
			move_block(block, 1)
		for block in moving_blocks_present:
			move_block(block, 0)
		for block in moving_blocks_future:
			move_block(block, -1)
		for orb in orbs:
			if orb.translation == player_present.map_translation:
				orbs.erase(orb)
				orb.queue_free()
				flips += 3
				$"%Flip".text = " x " + str(flips)
				$"%Flip".disabled = false
				return
		if portal.translation == player_present.map_translation:
			$VictoryPanel.show()

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
	if time_direction == -1:
		$AudioStreamPlayer2.seek(25.79 - $AudioStreamPlayer.get_playback_position())
		$AudioStreamPlayer.stop()
		$AudioStreamPlayer2.play()
	else:
		$AudioStreamPlayer.seek(25.79 - $AudioStreamPlayer2.get_playback_position())
		$AudioStreamPlayer2.stop()
		$AudioStreamPlayer.play()
	

func move_block(block, relative_time):
	if time_direction == 1:
		if time + relative_time == block.map_translation_initial.y:
			var total_y = 0
			var current_y = block.map_translation.y
			while blocks[Vector3(block.map_translation.x, current_y - 1, block.map_translation.z)] == null:
				total_y += 1
				current_y -= 1
			if total_y > 0:
				player_past.moving = true
				player_present.moving = true
				player_future.moving = true
				if player_present.map_translation == block.map_translation + Vector3(0, 1, 0):
#						$Player.move_down(current_y + 1)
					$GameOverPanel.show()
				block.move_down(current_y)
	else:
		if time + relative_time == block.map_translation_initial.y - 1:
			if block.map_translation.y < block.map_translation_initial.y:
				player_past.moving = true
				player_present.moving = true
				player_future.moving = true
				if player_present.map_translation == block.map_translation + Vector3(0, 1, 0):
					player_past.move_up(block.map_translation_initial.y + 1)
					player_present.move_up(block.map_translation_initial.y + 1)
					player_future.move_up(block.map_translation_initial.y + 1)
				block.move_up()

func _on_restart_pressed():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
