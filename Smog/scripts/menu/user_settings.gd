extends CanvasLayer

@onready var main_menu: PackedScene = load("res://scenes/main_menu_ui.tscn")
@onready var binding_change_button_texture: Texture2D = load("res://art/UI/whitebar_8x4.png")
@onready var tree: Tree = %Tree

var pad_mode: bool = false: 
	get: 
		return pad_mode
	set(value):
		pad_mode = value
		_update_children(KeyBindMenu)
	
var listening: bool = false:
	get:
		return listening
	set(value):
		listening = value
		var i: int = 0
		for bind in KeyBindMenu.get_children():
			bind.set_button_disabled(0, i, listening)
			
var current_button_index: int = 0

var KeyBindMenu: TreeItem
var GraphicsMenu: TreeItem

var settings: Dictionary = {
	"Keybindings": {
		"up": "W",
		"left": "A",
		"down": "S",
		"right": "D",
		"melee" : "V",
		"interact" : "E",
		"use_item" : "F",
		"shoot_mode" : "Mouse 2",
		"item_grab" : "Joypad B3",
		"escape" : "Esc",
		"reload" : "R"
	}
}


func _ready() -> void:
	tree.grab_focus()
	
	var root: TreeItem = tree.create_item()
	
	tree.button_clicked.connect(button_one)
	tree.item_selected.connect(_item_selected)
	
	KeyBindMenu = tree.create_item(root)
	GraphicsMenu = tree.create_item(root)
	
	KeyBindMenu.set_text(0, "Key bindings")
	GraphicsMenu.set_text(0, "Graphics")

	KeyBindMenu.set_selectable(0, pad_mode)
	GraphicsMenu.set_selectable(0, pad_mode)
	
	KeyBindMenu.set_custom_font_size(0, 10)
	GraphicsMenu.set_custom_font_size(0, 10)
	
	var button_id: int = 0
	for bind in settings["Keybindings"]:
		var binding: TreeItem = tree.create_item(KeyBindMenu)
		binding.set_text(0, _remove_underscores(bind) + " - " + (settings["Keybindings"][bind]))
		binding.set_custom_font_size(0, 6)
		binding.set_selectable(0, pad_mode)
		binding.add_button(0, binding_change_button_texture, button_id)
		button_id += 1
	
	collapse_all(KeyBindMenu)
	
	
#listen for user keybind input if listening and valid input
func _input(event: InputEvent) -> void:
	print(event.as_text())
	if event.as_text().find("Joypad") != -1:
		pad_mode = true
	else:
		pad_mode = false
	
	if event is InputEventMouseMotion or not listening:
		return
	
	if event is InputEventJoypadButton or InputEventMouseButton or InputEventKey or InputEventJoypadMotion:
		_update_binds(event, _get_bind_from_index(current_button_index))
		listening = false
		
		print("DEBUG ------ Listening : ", listening)


# InputEvent will be assigned as new binding for binding
func _update_binds(input: InputEvent, binding: String) -> void:
	if input is InputEventMouseButton:
		print('mouse button lol... ', input.button_index)
		InputMap.action_erase_events(binding)
		InputMap.action_add_event(binding, input)
		
		settings["Keybindings"][binding] = _get_str_from_input_event(input)
		_update_children(KeyBindMenu)
		
		return
	
	print('DEBUG ------ New input set! : ', input.keycode)
	InputMap.action_erase_events(binding)
	InputMap.action_add_event(binding, input)
	
	settings["Keybindings"][binding] = _get_str_from_input_event(input)
	
	_update_children(KeyBindMenu)


func _update_children(t_item: TreeItem):
	
	KeyBindMenu.set_selectable(0, pad_mode)
	GraphicsMenu.set_selectable(0, pad_mode)
	
	if(!pad_mode):
		KeyBindMenu.deselect(0)
		GraphicsMenu.deselect(0)
	
	for child in t_item.get_children():
		t_item.remove_child(child)
		child.free()
	
	var button_id: int = 0
	for bind in settings["Keybindings"]:
		var binding: TreeItem = tree.create_item(KeyBindMenu)
		binding.set_text(0, _remove_underscores(bind) + " - " + settings["Keybindings"][bind])
		binding.set_custom_font_size(0, 6)
		binding.add_button(0, binding_change_button_texture, button_id)
		binding.set_selectable(0, pad_mode)
		button_id += 1
		
		
# callback for Tree.button_clicked
func button_one(_item: TreeItem, _column: int, id: int, mouse_button_index: int) -> void:
	current_button_index = id
	listening = true
	print("DEBUG ------ Listening : ", listening, " on button number: ", id)


func _item_selected():
	print('yo')

func _load_main_menu():
	get_tree().change_scene_to_packed(main_menu)


# collapse all tree dropdown for given TreeItem and its children
func collapse_all(item: TreeItem = null) -> void:
	if item == null:
		item = tree.get_root()
		
	item.collapsed = true
	
	for child in item.get_children():
		collapse_all(child)


func _get_bind_from_index(index: int) -> String:
	var i_to_str : String = "0"
	var i: int = 0
	for bind in settings["Keybindings"]:
		i_to_str = bind
		if i == index:
			return i_to_str
		i += 1 
		
	return i_to_str
	
	
func _get_str_from_input_event(input: InputEvent) -> String:
	
	if input is InputEventMouseButton:
		match input.button_index:
			1: return "Mouse " + str(input.button_index)
			2: return "Mouse " + str(input.button_index)
			3: return "Middle Mouse"
			4: return "Scroll up"
			5: return "Scroll down"
			6: return "Mouse " + str(input.button_index)
			7: return "Mouse " + str(input.button_index)
			8: return "Mouse 4"
			9: return "Mouse 5" 
		
		
	if input is InputEventKey or InputEventJoypadButton:
		match input.keycode:
			KEY_NONE: return ""
			KEY_SPECIAL: return ""
			KEY_ESCAPE: return "Esc"
			KEY_TAB: return "Tab"
			KEY_BACKTAB: return "Shift Tab"
			KEY_BACKSPACE: return "Backspace"
			KEY_ENTER: return "Enter"
			KEY_KP_ENTER: return ""
			KEY_INSERT: return ""
			KEY_DELETE: return ""
			KEY_PAUSE: return ""
			KEY_PRINT: return ""
			KEY_SYSREQ: return ""
			KEY_CLEAR: return ""
			KEY_HOME: return ""
			KEY_END: return ""
			KEY_LEFT: return "Left Arrow"
			KEY_UP: return "Up Arrow"
			KEY_RIGHT: return "Right Arrow"
			KEY_DOWN: return "Down Arrow"
			KEY_PAGEUP: return ""
			KEY_PAGEDOWN: return ""
			KEY_SHIFT: return "Shift"
			KEY_CTRL: return "Ctrl"
			KEY_META: return ""
			KEY_ALT: return "Alt"
			KEY_CAPSLOCK: return "Caps"
			KEY_NUMLOCK: return ""
			KEY_SCROLLLOCK: return ""
			KEY_F1: return "F1"
			KEY_F2: return "F2"
			KEY_F3: return "F3"
			KEY_F4: return "F4"
			KEY_F5: return "F5"
			KEY_F6: return "F6"
			KEY_F7: return "F7"
			KEY_F8: return "F8"
			KEY_F9: return "F9"
			KEY_F10: return "F10"
			KEY_F11: return "F11"
			KEY_F12: return "F12"
			KEY_F13: return "F13"
			KEY_F14: return "F14"
			KEY_F15: return "F15"
			KEY_F16: return "F16"
			KEY_F17: return "F17"
			KEY_F18: return "F18"
			KEY_F19: return "F19"
			KEY_F20: return "F20"
			KEY_F21: return "F21"
			KEY_F22: return "F22"
			KEY_F23: return "F23"
			KEY_F24: return "F24"
			KEY_F25: return "F25"
			KEY_F26: return "F26"
			KEY_F27: return "F27"
			KEY_F28: return "F28"
			KEY_F29: return "F29"
			KEY_F30: return "F30"
			KEY_F31: return "F31"
			KEY_F32: return "F32"
			KEY_F33: return "F33"
			KEY_F34: return "F34"
			KEY_F35: return "F35"
			KEY_KP_MULTIPLY: return ""
			KEY_KP_DIVIDE: return ""
			KEY_KP_SUBTRACT: return ""
			KEY_KP_PERIOD: return ""
			KEY_KP_ADD: return ""
			KEY_KP_0: return ""
			KEY_KP_1: return ""
			KEY_KP_2: return ""
			KEY_KP_3: return ""
			KEY_KP_4: return ""
			KEY_KP_5: return ""
			KEY_KP_6: return ""
			KEY_KP_7: return ""
			KEY_KP_8: return ""
			KEY_KP_9: return ""
			KEY_MENU: return ""
			KEY_HYPER: return ""
			KEY_HELP: return ""
			KEY_BACK: return ""
			KEY_FORWARD: return ""
			KEY_STOP: return ""
			KEY_REFRESH: return ""
			KEY_VOLUMEDOWN: return ""
			KEY_VOLUMEMUTE: return ""
			KEY_VOLUMEUP: return ""
			KEY_MEDIAPLAY: return ""
			KEY_MEDIASTOP: return ""
			KEY_MEDIAPREVIOUS: return ""
			KEY_MEDIANEXT: return ""
			KEY_MEDIARECORD: return ""
			KEY_HOMEPAGE: return ""
			KEY_FAVORITES: return ""
			KEY_SEARCH: return ""
			KEY_STANDBY: return ""
			KEY_OPENURL: return ""
			KEY_LAUNCHMAIL: return ""
			KEY_LAUNCHMEDIA: return ""
			KEY_LAUNCH0: return ""
			KEY_LAUNCH1: return ""
			KEY_LAUNCH2: return ""
			KEY_LAUNCH3: return ""
			KEY_LAUNCH4: return ""
			KEY_LAUNCH5: return ""
			KEY_LAUNCH6: return ""
			KEY_LAUNCH7: return ""
			KEY_LAUNCH8: return ""
			KEY_LAUNCH9: return ""
			KEY_LAUNCHA: return ""
			KEY_LAUNCHB: return ""
			KEY_LAUNCHC: return ""
			KEY_LAUNCHD: return ""
			KEY_LAUNCHE: return ""
			KEY_LAUNCHF: return ""
			KEY_GLOBE: return ""
			KEY_KEYBOARD: return ""
			KEY_JIS_EISU: return ""
			KEY_JIS_KANA: return ""
			KEY_UNKNOWN: return ""
			KEY_SPACE: return "Space"
			KEY_EXCLAM: return ""
			KEY_QUOTEDBL: return ""
			KEY_NUMBERSIGN: return ""
			KEY_DOLLAR: return ""
			KEY_PERCENT: return ""
			KEY_AMPERSAND: return ""
			KEY_APOSTROPHE: return ""
			KEY_PARENLEFT: return ""
			KEY_PARENRIGHT: return ""
			KEY_ASTERISK: return ""
			KEY_PLUS: return ""
			KEY_COMMA: return ""
			KEY_MINUS: return ""
			KEY_PERIOD: return ""
			KEY_SLASH: return "/"
			KEY_0: return "0"
			KEY_1: return "1"
			KEY_2: return "2"
			KEY_3: return "3"
			KEY_4: return "4"
			KEY_5: return "5"
			KEY_6: return "6"
			KEY_7: return "7"
			KEY_8: return "8"
			KEY_9: return "9"
			KEY_COLON: return ""
			KEY_SEMICOLON: return ";"
			KEY_LESS: return ""
			KEY_EQUAL: return ""
			KEY_GREATER: return ""
			KEY_QUESTION: return ""
			KEY_AT: return ""
			KEY_A: return "A"
			KEY_B: return "B"
			KEY_C: return "C"
			KEY_D: return "D"
			KEY_E: return "E"
			KEY_F: return "F"
			KEY_G: return "G"
			KEY_H: return "H"
			KEY_I: return "I"
			KEY_J: return "J"
			KEY_K: return "K"
			KEY_L: return "L"
			KEY_M: return "M"
			KEY_N: return "N"
			KEY_O: return "O"
			KEY_P: return "P"
			KEY_Q: return "Q"
			KEY_R: return "R"
			KEY_S: return "S"
			KEY_T: return "T"
			KEY_U: return "U"
			KEY_V: return "V"
			KEY_W: return "W"
			KEY_X: return "X"
			KEY_Y: return "Y"
			KEY_Z: return "Z"   
			KEY_BRACKETLEFT: return "["
			KEY_BACKSLASH: return "\\"
			KEY_BRACKETRIGHT: return "]"
			KEY_ASCIICIRCUM: return ""
			KEY_UNDERSCORE: return ""
			KEY_QUOTELEFT: return ""
			KEY_BRACELEFT: return ""
			KEY_BAR: return ""
			KEY_BRACERIGHT: return ""
			KEY_ASCIITILDE: return ""
	
	return str(input.keycode)
	

func _remove_underscores(val: String) -> String:
	if val.find("_") != -1:
		return val.replace("_", " ")
	return val
