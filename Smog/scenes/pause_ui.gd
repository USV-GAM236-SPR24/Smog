extends CanvasLayer

var main_menu_scene: PackedScene = load("res://scenes/main_menu_ui.tscn")

var is_paused : bool = false

func _input(event): 
	if event.is_action_pressed("escape"):
		if is_paused == true:
			resume_game()
		elif is_paused == false:
			pause_game()

func pause_game():
	is_paused = true
	show()
	get_tree().paused = true

func resume_game():
	is_paused = false
	hide()
	get_tree().paused = false

func _on_resume_pressed():
	resume_game()

func _on_quit_pressed():
	get_tree().quit()

func _on_back_button_pressed():
	resume_game()
	Sanity.fill()
	get_tree().change_scene_to_packed(main_menu_scene)
	
