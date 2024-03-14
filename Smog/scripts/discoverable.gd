class_name Discoverable
extends Interactable

enum {
	TEXT,
	DIALOGUE,
	IMAGE
}

@export_enum("office1", "mailroom", "messhall", "factory_floor1", "factory_floor2", "washroom", "storage", "office2")
var room: String = "office1"
@export var key: String

var display_name: String
var text: String
var type: int
var texture: Texture2D
var texture_path: String
var image: Texture2D
var image_path: String
var has_image: bool
var seen: bool

@onready var sprite: Sprite2D = $Sprite2D


func _init(new_name := "Empty Discoverable", new_text := "Empty Text", new_type := Discoverable.TEXT, new_texture: String = "", new_image: String = "") -> void:
	display_name = new_name
	text = new_text
	type = new_type
	texture_path = new_texture
	image_path = new_image
	has_image = type == Discoverable.IMAGE
	seen = false
	
	if texture_path == "":
		texture = PlaceholderTexture2D.new()
		texture.size = Vector2(16, 16)
	
	interact_label = display_name
	interact_type = InteractType.DISCOVERABLE
	is_single_use = false


func _ready() -> void:
	if texture_path != "":
		texture = ResourceLoader.load_threaded_get(texture_path)
	if has_image:
		image = ResourceLoader.load_threaded_get(image_path)
	sprite.texture = texture


func _interact() -> void:
	pass
