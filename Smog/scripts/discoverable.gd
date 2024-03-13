class_name Discoverable
extends Node2D


enum {
	TEXT,
	DIALOGUE,
	IMAGE
}

var display_name: String
var text: String
var type: int
var texture: Texture2D
var image: Texture2D
var has_image: bool
var seen: bool

@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D


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


func _ready() -> void:
	sprite.texture = texture
	area.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	#logic
