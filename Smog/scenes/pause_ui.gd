extends CanvasLayer

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
	print("game is paused")

func resume_game():
	is_paused = false
	hide()
	get_tree().paused = false
	print("game is resumed")

func _on_resume_pressed():
	resume_game()


func _on_quit_pressed():
	get_tree().quit()
