extends CanvasLayer


var game_scene: PackedScene = preload("res://scenes/game.tscn")
var settings_scene: PackedScene = preload("res://scenes/user_settings.tscn")

var _options: Array[String] = ["start", "quit", "settings"]

var _selected_option: String = _options[0]

var _selected_option_index: int = 0:
	get:
		return _selected_option_index
	set(value):
		
		if value >= _options.size():
			_selected_option_index = 0
		elif value < 0:
			_selected_option_index = _options.size() - 1
		else:
			_selected_option_index = value
		
		_selected_option = _options[_selected_option_index]
		

func _enter_tree() -> void:
	%Start.pressed.connect(_on_start_pressed)
	%Quit.pressed.connect(_on_quit_pressed)
	%Settings.pressed.connect(_on_settings_pressed)


func _on_start_pressed():
	get_tree().change_scene_to_packed(game_scene)


func _on_quit_pressed():
	get_tree().quit()


func _on_settings_pressed():
	get_tree().change_scene_to_packed(settings_scene)


func _process(_delta):
	if Input.is_action_just_pressed("ui_settings_up"): #event.is_action_just_pressed("ui_settings_up"):
		_selected_option_index -= 1
		match _selected_option:
			"start": 
				_select_start()
			"quit": 
				_select_quit()
			"settings": 
				_select_settings()
	elif Input.is_action_just_pressed("ui_settings_down"):
		_selected_option_index += 1
		match _selected_option:
			"start": 
				_select_start()
			"quit": 
				_select_quit()
			"settings": 
				_select_settings()
	elif Input.is_action_just_pressed("ui_settings_pad_select"):
		match _selected_option:
			"start": 
				_on_start_pressed()
			"quit": 
				_on_quit_pressed()
			"settings": 
				_on_settings_pressed()


func _select_settings():
	for img in %Settings.get_children():
		img.visible = true
	for img in %Start.get_children():
		img.visible = false
	for img in %Quit.get_children():
		img.visible = false

func _select_start():
	for img in %Start.get_children():
		img.visible = true
	for img in %Quit.get_children():
		img.visible = false
	for img in %Settings.get_children():
		img.visible = false
	
func _select_quit():
	for img in %Quit.get_children():
		img.visible = true
	for img in %Start.get_children():
		img.visible = false
	for img in %Settings.get_children():
		img.visible = false
