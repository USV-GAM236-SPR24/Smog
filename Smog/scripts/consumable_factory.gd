# autoload: ConsumableFacotry
extends Node


var presets: Dictionary


func _init() -> void:
	var preset_file: FileAccess = FileAccess.open("res://consumable_presets.json", FileAccess.READ)
	var raw_presets: Dictionary = JSON.parse_string(preset_file.get_as_text())
	# parse json into dictionary
	for preset_name in raw_presets:
		presets[preset_name] = {}
		for preset_value in raw_presets[preset_name]:
			# preload textures
			if preset_value == "texture_path":
				var texture_path: String = raw_presets[preset_name].texture_path
				presets[preset_name].texture = load(texture_path)
				continue
			presets[preset_name][preset_value] = raw_presets[preset_name][preset_value]


func create(preset_name: String = "opium") -> Consumable:
	var preset: Dictionary = presets[preset_name]
	var preset_restore_power: int = preset.restore_power
	var preset_texture: Texture2D = preset.texture
	return _create(preset_name, preset_restore_power, preset_texture)


func _create(new_name: String, new_restore_power: int, new_texture: Texture2D) -> Consumable:
	return Consumable.new(new_name, new_restore_power, new_texture)
