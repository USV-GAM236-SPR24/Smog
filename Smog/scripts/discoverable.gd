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
@onready var ui: CanvasLayer = $/root/Game/DiscoverableUI


func _init(new_name := "Empty Discoverable", new_text := "Empty Text", new_type := Discoverable.TEXT, new_texture: String = "", new_image: String = "") -> void:
	display_name = new_name
	text = new_text
	type = new_type
	texture_path = new_texture
	image_path = new_image
	seen = false
	has_image = type == Discoverable.IMAGE


func _enter_tree() -> void:
	if key.length() == 0:
		return
	var data: Dictionary = DiscoverableSystem.discoverables[room][key]
	display_name = data.display_name
	text = data.text
	type = data.type
	texture_path = data.texture_path
	has_image = type == Discoverable.IMAGE
	if has_image:
		image_path = data.image_path
	
	if texture_path == "":
		texture = PlaceholderTexture2D.new()
		texture.size = Vector2(16, 16)
	
	interact_label = display_name


func _ready() -> void:
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	if texture_path != "":
		texture = ResourceLoader.load_threaded_get(texture_path)
	if has_image:
		image = ResourceLoader.load_threaded_get(image_path)
	# why is texture null after reloading current scene? look into this. must have something to...
	# ...do with discoverables stuff being an autoload
	if not texture:
		texture = load(texture_path)
	sprite.texture = texture


func _interact() -> void:
	super._interact()
	print(text)
	ui.set_and_enable(self)


func _on_body_entered(body: Node):
	if not body is Player:
		return
	body.all_interactions.insert(0, self)
	body.update_interactions()


func _on_body_exited(body: Node):
	if not body is Player:
		return
	body.all_interactions.erase(self)
	body.update_interactions()
