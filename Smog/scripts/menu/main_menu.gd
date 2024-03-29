extends CanvasLayer


var game_scene: PackedScene = preload("res://scenes/game.tscn")
var settings_scene: PackedScene = preload("res://scenes/user_settings.tscn")

var _selected_option: bool = false

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


func _input(event):
	if event is InputEvent:
		if event.is_action_pressed("up"):
			_selected_option = false
			_select_start()
		elif event.is_action_pressed("down"):
			_selected_option = true
			_select_quit()
		elif event.is_action_pressed("interact"):
			if _selected_option:
				_on_quit_pressed()
				return
			_on_start_pressed()

func _select_start():
	for img in %Start.get_children():
		img.visible = true
	for img in %Quit.get_children():
		img.visible = false
	
func _select_quit():
	for img in %Start.get_children():
		img.visible = false
	for img in %Quit.get_children():
		img.visible = true
