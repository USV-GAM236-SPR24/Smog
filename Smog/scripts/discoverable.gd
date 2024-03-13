class_name Discoverable
extends Interactable


enum {
	TEXT,
	DIALOGUE,
	IMAGE
}

@export var key: String

var display_name: String
var text: String
var type: int
var texture: Texture2D
var image: Texture2D
var has_image: bool
var seen: bool

@onready var sprite: Sprite2D = $Sprite2D


func _init(new_name := "Empty Discoverable", new_text := "Empty Text", new_type := Discoverable.TEXT, new_texture: Texture2D = null, new_image: Texture2D = null) -> void:
	display_name = new_name
	text = new_text
	type = new_type
	texture = new_texture
	image = new_image
	has_image = new_image != null
	seen = false
	
	if texture == null:
		texture = PlaceholderTexture2D.new()
		texture.size = Vector2(16, 16)
	
	interact_label = display_name
	interact_type = InteractType.DISCOVERABLE
	is_single_use = false


func _ready() -> void:
	sprite.texture = texture


func _interact() -> void:
	pass
