extends CanvasLayer

@onready var binding_change_button_texture: Texture2D = load("res://art/UI/whitebar_8x4.png")
@onready var tree: Tree = %Tree

var listening := false

var settings: Dictionary = {
	"Keybindings": {
		"Move up": "W",
		"Move left": "A",
		"Move down": "S",
		"Move right": "D",
		"Attack" : "V"
	}
}

func _ready() -> void:
	tree.button_clicked.connect(button_one)
	
	var root: TreeItem = tree.create_item()
	var KeyBindMenu: TreeItem = tree.create_item(root)
	var GraphicsMenu: TreeItem = tree.create_item(root)
	
	tree.set_column_custom_minimum_width(0, 15)
	KeyBindMenu.set_text(0, "Keybinds")
	GraphicsMenu.set_text(0, "Graphics")

	KeyBindMenu.set_selectable(0, false)
	GraphicsMenu.set_selectable(0, false)	

	KeyBindMenu.set_custom_font_size(0, 10)
	GraphicsMenu.set_custom_font_size(0, 10)
	
	var button_id: int = 0
	for bind in settings["Keybindings"]:
		var binding: TreeItem = tree.create_item(KeyBindMenu)
		binding.set_text(0, bind + " - " + settings["Keybindings"][bind])
		binding.set_custom_font_size(0, 6)
		binding.set_selectable(0, false)
		binding.add_button(0, binding_change_button_texture, button_id)
		button_id += 1
		
		#var binding_text: TreeItem = tree.create_item(binding)
		#binding_text.set_text(0, settings["Keybindings"][bind])
		#binding_text.set_custom_font_size(0, 6)
	
	collapse_all(KeyBindMenu)
	
	
#listen for user keybind input if listening and valid input
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		return
	
	if listening:
		
		# TODO: Fix weird bug with pad motion registering as JoypadButton
		if event is InputEventJoypadButton or InputEventMouseButton or InputEventKey:
			print('new keybind : ', event)
			listening = false
			print("listening : ", listening)

	
# callback for Tree.button_clicked
func button_one(_item: TreeItem, _column: int, _id: int, _mouse_button_index: int) -> void:
	listening = true
	print("listening : ", listening)
	
	
# collapse all tree dropdown for given TreeItem and its children
func collapse_all(item: TreeItem = null) -> void:
	if item == null:
		item = tree.get_root()

	item.collapsed = true

	for child in item.get_children():
		collapse_all(child)