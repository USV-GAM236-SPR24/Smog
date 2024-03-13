class_name Discoverable
extends RefCounted


enum {
	TEXT,
	DIALOGUE,
	IMAGE
}

var display_name: String
var text: String
var type: int
var image: Texture2D
var has_image: bool
var seen: bool


func _init(new_name: String, new_text: String, new_type := Discoverable.TEXT, new_image: Texture2D = null) -> void:
	display_name = new_name
	text = new_text
	type = new_type
	image = new_image
	has_image = new_image == null
	seen = false
