# autoload: ConsumableFacotry
extends Node


var presets := {
	"opium": {
		"restore_power": 50,
		"texture_path": "res://art/temp/item1.png"
	},
	"alcohol": {
		"restore_power": 50,
		"texture_path": "res://art/temp/item2.png"
	},
	"cigarette": {
		"restore_power": 50,
		"texture_path": "res://art/temp/item3.png"
	}
}


func create(preset_name: String = "opium") -> Consumable:
	var preset_restore_power: int = presets[preset_name]["restore_power"]
	var preset_texture: Texture2D = load(presets[preset_name]["texture_path"])
	return _create(preset_name, preset_restore_power, preset_texture)


func _create(new_name: String, new_restore_power: int, new_texture: Texture2D) -> Consumable:
	return Consumable.new(new_name, new_restore_power, new_texture)
