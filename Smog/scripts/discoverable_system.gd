extends Node


var discoverables := {}


func _init():
	_parse_json()


func _parse_json() -> void:
	var file: FileAccess = FileAccess.open("res://discoverables.json", FileAccess.READ)
	var rooms: Dictionary = JSON.parse_string(file.get_as_text())
	for room_name in rooms:
		var room: Dictionary = rooms[room_name]
		discoverables[room_name] = {}
		for key in room:
			discoverables[room_name][key] = {}
			discoverables[room_name][key].display_name = room[key].display_name
			discoverables[room_name][key].text = room[key].text
			discoverables[room_name][key].type = _string_type(room[key].type)
			discoverables[room_name][key].texture_path = room[key].texture_path
			if room[key].texture_path != "":
				if not ResourceLoader.load_threaded_get_status(room[key].texture_path):
					ResourceLoader.load_threaded_request(room[key].texture_path)
					var status: int = ResourceLoader.load_threaded_get_status(room[key].texture_path)
					#print_debug("%s: %s" % [status, room[key].texture_path])
			if room[key].type != "IMAGE":
				continue
			discoverables[room_name][key].image_path = room[key].image_path
			if room[key].image_path != "":
				if not ResourceLoader.load_threaded_get_status(room[key].image_path):
					ResourceLoader.load_threaded_request(room[key].image_path)
					var status: int = ResourceLoader.load_threaded_get_status(room[key].image_path)
					#print_debug("%s: %s" % [status, room[key].image_path])


func _string_type(typename: String) -> int:
	match typename:
		"TEXT": return Discoverable.TEXT
		"IMAGE": return Discoverable.IMAGE
		"DIALOGUE": return Discoverable.DIALOGUE
	return -1
