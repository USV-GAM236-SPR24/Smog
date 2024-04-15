extends CanvasLayer

@onready var main_menu: PackedScene = load("res://scenes/main_menu_ui.tscn")
@onready var blue_bar_texture: Texture2D = load("res://art/UI/bluebar_8x4.png")
@onready var white_bar_texture: Texture2D = load("res://art/UI/whitebar_8x4.png")
@onready var binding_change_button_texture: Texture2D = white_bar_texture

@onready var tree: Tree = %Tree

@onready var scrollbar: VScrollBar = tree.get_child(3, true)

var first: bool = true

var current_button_index: int = 0

var KeyBindMenu: TreeItem
var GraphicsMenu: TreeItem

var current_item: TreeItem:
	get:
		return current_item
	set(value):
		current_item = value

var pad_mode: bool = false: 
	get: 
		return pad_mode
	set(value):
		var o_pad_mode: bool = pad_mode
		pad_mode = value
		if pad_mode and first:
			_update_children(KeyBindMenu)
			tree.set_selected(KeyBindMenu, 0)
			current_item = KeyBindMenu
			first = false
		if !pad_mode:
			_update_children(KeyBindMenu)
		if pad_mode and !o_pad_mode and not listening: # if pad mode changing while not listening
			_update_children(KeyBindMenu)
			tree.set_selected(KeyBindMenu, 0)
			current_item = KeyBindMenu
			scrollbar.value = scrollbar.min_value
			
var listening: bool = false:
	get:
		return listening
	set(value):
		listening = value
		#if listening:
			#binding_change_button_texture = blue_bar_texture
		#else:
			#binding_change_button_texture = white_bar_texture
		
var settings: Dictionary = {
	"Keybindings": {
		"up": "W",
		"left": "A",
		"down": "S",
		"right": "D",
		"melee" : "V",
		"shoot" : "Mouse 1",
		"interact" : "E",
		"use_item" : "F",
		"shoot_mode" : "Mouse 2",
		"escape" : "Esc",
		"reload" : "R"
	}
}	


func _input(event: InputEvent) -> void:
	if event.as_text().find("Joypad") != -1:
		if !event is InputEventJoypadMotion:
			pad_mode = true
	else:
		pad_mode = false
	
	if not listening:
		return
	# LISTENING
	
	## protections
	if event is InputEventMouseMotion:
		return
		
	if event is InputEventJoypadMotion:
		if abs(event.axis_value) < 0.3:
			return
	## protections
	
	if (event is InputEventJoypadButton or InputEventMouseButton or InputEventKey) and listening:
		_update_bind(event, _get_bind_from_index(current_button_index))
		listening = false

# NOT LISTENING
func _process(_delta) -> void:
	if listening:
		return
	
	if Input.is_action_just_released("ui_settings_pad_select") and pad_mode:
		var selected = tree.get_selected()
		if selected != null:
			listening = true
			#await get_tree().create_timer(0.1)
			button_one(selected, 0, _get_index_from_bind(_extract_before_hyphen(selected.get_text(0))), 1)
			return
	
	elif Input.is_action_just_pressed("ui_settings_down") and pad_mode:
		tree.deselect_all()
		var down_item
		if current_item != null:
			down_item = current_item.get_next_visible(true)
			
		if down_item == GraphicsMenu.get_next_visible(true):
			current_item = KeyBindMenu
			scrollbar.value = scrollbar.min_value
			
		else:
			current_item = down_item
			scrollbar.value += 35
		
		if current_item != null:
			tree.set_selected(current_item, 0)
			return
		

	elif Input.is_action_just_pressed("ui_settings_up") and pad_mode:
		tree.deselect_all()
		
		var up_item
		if current_item != null:
			up_item = current_item.get_prev_visible(true)
			
		if up_item == null:
			current_item = GraphicsMenu
			scrollbar.value = scrollbar.max_value
			
		else:
			current_item = up_item
			scrollbar.value -= 35
			
		tree.set_selected(current_item, 0)
		return
		
		
	elif Input.is_action_just_pressed("ui_settings_right") and pad_mode:
		if tree.get_selected() == KeyBindMenu or tree.get_selected() == GraphicsMenu:
			current_item.collapsed = false
			scrollbar.value = scrollbar.min_value
			#tree.set_selected(KeyBindMenu, 0)
			return
			
	elif Input.is_action_just_pressed("ui_settings_left") and pad_mode:
		if tree.get_selected() == KeyBindMenu or tree.get_selected() == GraphicsMenu:
			current_item.collapsed = true
			return
			
	elif Input.is_action_just_pressed("ui_settings_pad_back") and pad_mode:
		_load_main_menu()
			
			
func _item_selected():
	
	if current_item == KeyBindMenu:
		scrollbar.value = scrollbar.min_value

func _ready() -> void:
	#_config_save() # USE FOR ONE TIME INITIALIZATION OF settings
	_config_load()
	tree.grab_focus()
	
	var root: TreeItem = tree.create_item()
	root.set_selectable(0, false)
	
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
	_update_all_binds()

func _update_all_binds():
	for binding in settings["Keybindings"]:
		if _get_input_event_from_str(settings["Keybindings"][binding]) != null:
			_update_bind(_get_input_event_from_str(settings["Keybindings"][binding]), binding)


# InputEvent will be assigned as new binding for binding
func _update_bind(input: InputEvent, binding: String) -> void:
	#if input is InputEventMouseButton:
		#print('mouse button lol... ', input.button_index)
		#InputMap.action_erase_events(binding)
		#InputMap.action_add_event(binding, input)
		#
		#settings["Keybindings"][binding] = _get_str_from_input_event(input)
		#_update_children(KeyBindMenu)
		#
		#return
	
	#print('INPUT: ', input)
	for _binding in settings["Keybindings"]:
		if _binding != binding:
			if InputMap.action_has_event(_binding, input):
				return
				#InputMap.action_erase_events(_binding)
				#print('erasing: ', _binding)
	 
	InputMap.action_erase_events(binding)
	InputMap.action_add_event(binding, input)
	
	settings["Keybindings"][binding] = _get_str_from_input_event(input)
	
	_update_children(KeyBindMenu)


func _update_children(t_item: TreeItem):
	
	KeyBindMenu.set_selectable(0, pad_mode)
	GraphicsMenu.set_selectable(0, pad_mode)
	
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
		
	if(!pad_mode):
		KeyBindMenu.deselect(0)
		GraphicsMenu.deselect(0)
		
		
# callback for Tree.button_clicked
func button_one(_item: TreeItem, _column: int, id: int, mouse_button_index: int) -> void:
	current_button_index = id
	print('BUTTON CLICKED ON ITEM: ', _item, ', ID:  ', id)
	listening = true
	
	
func _load_main_menu() -> void:
	get_tree().change_scene_to_packed(main_menu)


# collapse all tree dropdown for given TreeItem and its children
func collapse_all(item: TreeItem = null) -> void:
	if item == null:
		item = tree.get_root()
		
	item.collapsed = true
	
	for child in item.get_children():
		collapse_all(child)

func _get_index_from_bind(bind: String) -> int:
	var binds = ["up", "left", "down", "right", "melee", "shoot", "interact",
				 "use item", "shoot mode", "escape", "reload"]
				
	for j in range(binds.size()):
		if binds[j] == bind:
			return j
		
	return -1
	
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
			4: return "Scroll Up"
			5: return "Scroll Down"
			6: return "Mouse " + str(input.button_index)
			7: return "Mouse " + str(input.button_index)
			8: return "Mouse 4"
			9: return "Mouse 5" 
	
	if input is InputEventJoypadMotion:
		match input.axis:
			JOY_AXIS_LEFT_X:
				if input.axis_value > 0:
					return "LStick Right"
				else:
					return "LStick Left"
			JOY_AXIS_LEFT_Y:
				if input.axis_value > 0:
					return "LStick Down"
				else:
					return "LStick Up"
			JOY_AXIS_RIGHT_X:
				if input.axis_value > 0:
					return "RStick Right"
				else:
					return "RStick Left"
			JOY_AXIS_RIGHT_Y:
				if input.axis_value > 0:
					return "RStick Down"
				else:
					return "RStick Up"
	
	if input is InputEventJoypadButton:
		#print(input)
		match input.button_index:
			0: return "Bottom button"
			1: return "Right button"
			2: return "Left button"
			3: return "Top button"
			4: return "4 button"
			5: return "5 button"
			6: return "6 button"
			7: return "7 button"
			8: return "8 button"
			9: return "9 button"
			10: return "10 button"
			11: return "DPad Up"
			12: return "DPad Down"
			13: return "DPad Left"
			14: return "DPad Right"
			
	if input is InputEventKey:
		match input.keycode:
			KEY_ESCAPE: return "Esc"
			KEY_TAB: return "Tab"
			KEY_BACKTAB: return "Shift Tab"
			KEY_BACKSPACE: return "Backspace"
			KEY_ENTER: return "Enter"
			KEY_LEFT: return "Left Arrow"
			KEY_UP: return "Up Arrow"
			KEY_RIGHT: return "Right Arrow"
			KEY_DOWN: return "Down Arrow"
			KEY_SHIFT: return "Shift"
			KEY_CTRL: return "Ctrl"
			KEY_ALT: return "Alt"
			KEY_CAPSLOCK: return "Caps"
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
			KEY_SPACE: return "Space"
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
			KEY_SEMICOLON: return ";"
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
	
	if input is InputEventJoypadMotion:
		match input.axis:
			5: return "Right Trigger"
			4: return "Left Trigger"
	
	return "err"


func _get_input_event_from_str(string: String) -> InputEvent:
	match string:
		"Mouse 1": return create_mouse_button_event(1)
		"Mouse 2": return create_mouse_button_event(2)
		"Middle Mouse": return create_mouse_button_event(3)
		"Scroll Up": return create_mouse_button_event(4)
		"Scroll Down": return create_mouse_button_event(5)
		"Mouse 4": return create_mouse_button_event(8)
		"Mouse 5": return create_mouse_button_event(9)
		"Mouse 6": return create_mouse_button_event(6)
		"Mouse 7" : return create_mouse_button_event(7)
		
		"LStick Right": return create_joypad_motion_event(JOY_AXIS_LEFT_X, 0.50)
		"LStick Left": return create_joypad_motion_event(JOY_AXIS_LEFT_X, -0.50)
		"LStick Up": return create_joypad_motion_event(JOY_AXIS_LEFT_Y, -0.50)
		"LStick Down": return create_joypad_motion_event(JOY_AXIS_LEFT_Y, 0.50)

		"RStick Right": return create_joypad_motion_event(JOY_AXIS_RIGHT_X, 0.50)
		"RStick Left": return create_joypad_motion_event(JOY_AXIS_RIGHT_X, -0.50)
		"RStick Up": return create_joypad_motion_event(JOY_AXIS_RIGHT_Y, -0.50)
		"RStick Down": return create_joypad_motion_event(JOY_AXIS_RIGHT_Y, 0.50)
		
		"Bottom button": return create_joypad_button_event(0)
		"Right button": return create_joypad_button_event(1)
		"Left button": return create_joypad_button_event(2)
		"Top button": return create_joypad_button_event(3)
		"4 button": return create_joypad_button_event(4)
		"5 button": return create_joypad_button_event(5)
		"6 button": return create_joypad_button_event(6)
		"7 button": return create_joypad_button_event(7)
		"8 button": return create_joypad_button_event(8)
		"9 button": return create_joypad_button_event(9)
		"10 button": return create_joypad_button_event(10)
		"DPad Up": return create_joypad_button_event(11)
		"DPad Down": return create_joypad_button_event(12)
		"DPad Left": return create_joypad_button_event(13)
		"DPad Right": return create_joypad_button_event(14)
		
	
		"Esc": return create_key_event(KEY_ESCAPE)
		"Tab": return create_key_event(KEY_TAB)
		"Shift Tab": return create_key_event(KEY_BACKTAB)
		"Backspace": return create_key_event(KEY_BACKSPACE)
		"Enter": return create_key_event(KEY_ENTER)
		"Left Arrow": return create_key_event(KEY_LEFT)
		"Up Arrow": return create_key_event(KEY_UP)
		"Right Arrow": return create_key_event(KEY_RIGHT)
		"Down Arrow": return create_key_event(KEY_DOWN)
		"Shift": return create_key_event(KEY_SHIFT)
		"Ctrl": return create_key_event(KEY_CTRL)
		"Alt": return create_key_event(KEY_ALT)
		"Caps": return create_key_event(KEY_CAPSLOCK)
		"F1": return create_key_event(KEY_F1)
		"F2": return create_key_event(KEY_F2)
		"F3": return create_key_event(KEY_F3)
		"F4": return create_key_event(KEY_F4)
		"F5": return create_key_event(KEY_F5)
		"F6": return create_key_event(KEY_F6)
		"F7": return create_key_event(KEY_F7)
		"F8": return create_key_event(KEY_F8)
		"F9": return create_key_event(KEY_F9)
		"F10": return create_key_event(KEY_F10)
		"F11": return create_key_event(KEY_F11)
		"F12": return create_key_event(KEY_F12)
		"F13": return create_key_event(KEY_F13)
		"F14": return create_key_event(KEY_F14)
		"F15": return create_key_event(KEY_F15)
		"F16": return create_key_event(KEY_F16)
		"F17": return create_key_event(KEY_F17)
		"F18": return create_key_event(KEY_F18)
		"F19": return create_key_event(KEY_F19)
		"F20": return create_key_event(KEY_F20)
		"F21": return create_key_event(KEY_F21)
		"F22": return create_key_event(KEY_F22)
		"F23": return create_key_event(KEY_F23)
		"F24": return create_key_event(KEY_F24)
		"F25": return create_key_event(KEY_F25)
		"F26": return create_key_event(KEY_F26)
		"F27": return create_key_event(KEY_F27)
		"F28": return create_key_event(KEY_F28)
		"F29": return create_key_event(KEY_F29)
		"F30": return create_key_event(KEY_F30)
		"F31": return create_key_event(KEY_F31)
		"F32": return create_key_event(KEY_F32)
		"F33": return create_key_event(KEY_F33)
		"F34": return create_key_event(KEY_F34)
		"F35": return create_key_event(KEY_F35)
		"Space": return create_key_event(KEY_SPACE)
		"/": return create_key_event(KEY_SLASH)
		"0": return create_key_event(KEY_0)
		"1": return create_key_event(KEY_1)
		"2": return create_key_event(KEY_2)
		"3": return create_key_event(KEY_3)
		"4": return create_key_event(KEY_4)
		"5": return create_key_event(KEY_5)
		"6": return create_key_event(KEY_6)
		"7": return create_key_event(KEY_7)
		"8": return create_key_event(KEY_8)
		"9": return create_key_event(KEY_9)
		";": return create_key_event(KEY_SEMICOLON)
		"A": return create_key_event(KEY_A)
		"B": return create_key_event(KEY_B)
		"C": return create_key_event(KEY_C)
		"D": return create_key_event(KEY_D)
		"E": return create_key_event(KEY_E)
		"F": return create_key_event(KEY_F)
		"G": return create_key_event(KEY_G)
		"H": return create_key_event(KEY_H)
		"I": return create_key_event(KEY_I)
		"J": return create_key_event(KEY_J)
		"K": return create_key_event(KEY_K)
		"L": return create_key_event(KEY_L)
		"M": return create_key_event(KEY_M)
		"N": return create_key_event(KEY_N)
		"O": return create_key_event(KEY_O)
		"P": return create_key_event(KEY_P)
		"Q": return create_key_event(KEY_Q)
		"R": return create_key_event(KEY_R)
		"S": return create_key_event(KEY_S)
		"T": return create_key_event(KEY_T)
		"U": return create_key_event(KEY_U)
		"V": return create_key_event(KEY_V)
		"W": return create_key_event(KEY_W)
		"X": return create_key_event(KEY_X)
		"Y": return create_key_event(KEY_Y)
		"Z": return create_key_event(KEY_Z)
		"[": return create_key_event(KEY_BRACKETLEFT)
		"\\": return create_key_event(KEY_BACKSLASH)
		"]": return create_key_event(KEY_BRACKETRIGHT)
		_: return null


func create_key_event(key_code, pressed=true, echo=false) -> InputEventKey:
	var event = InputEventKey.new()
	event.keycode = key_code
	event.pressed = pressed
	event.echo = echo
	return event


func create_mouse_button_event(button_index, pressed=true) -> InputEventMouseButton:
	var event = InputEventMouseButton.new()
	event.button_index = button_index 
	event.pressed = pressed
	return event


func create_joypad_button_event(button_index, pressed=true) -> InputEventJoypadButton:
	var event = InputEventJoypadButton.new()
	event.button_index = button_index
	event.pressed = pressed
	return event


func create_joypad_motion_event(_axis, _axis_value) -> InputEventJoypadMotion:
	var event = InputEventJoypadMotion.new()
	event.axis = _axis
	event.axis_value = _axis_value
	return event


func _remove_underscores(val: String) -> String:
	if val.find("_") != -1:
		return val.replace("_", " ")
	return val
	
	
func _extract_before_hyphen(text: String) -> String:
	var index = text.find("-")
	if index == -1:
		return text
	return text.substr(0, index - 1)


## CONFIG 
func _exit_tree():
	_config_save()
	
func _config_load() -> void:
	
	var config = ConfigFile.new()
	var err = config.load("user://custom_settings")
	
	if err != OK:
		return
		
	var _settings = config.get_value("user", "settings")
	
	settings = _sort_keybindings(_settings)


func _sort_keybindings(dict: Dictionary) -> Dictionary:
	var order = ["up", "left", "down", "right", "melee", "shoot", "interact",
				 "use_item", "shoot_mode", "item_grab", "escape", "reload"]
	
	var keybindings = dict.get("Keybindings", {})
	
	var sorted_keybindings = {}
	
	for key in order:
		if key in keybindings:
			sorted_keybindings[key] = keybindings[key]
	
	# Update the 'Keybindings' in settings with the sorted dictionary
	dict["Keybindings"] = sorted_keybindings
	
	return dict


func _config_save() -> void:
	var config = ConfigFile.new()
	config.set_value("user", "settings", settings)
	config.save("user://custom_settings")
