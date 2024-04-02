extends Spatial

export var present = false
var block_scene = preload("res://block.tscn")
var stairs_scene = preload("res://stairs.tscn")
var gate_scene = preload("res://gate.tscn")
var orb_scene = preload("res://orb.tscn")
var portal_scene = preload("res://portal.tscn")
var blocks = {}
var orbs = []
var moving_blocks = []
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
			if present:
				block_name = "orb"
			else:
				block_name = null
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
