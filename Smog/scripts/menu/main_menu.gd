extends CanvasLayer


var game_scene: PackedScene = preload("res://scenes/game.tscn")


func _enter_tree() -> void:
	%Start.pressed.connect(_on_start_pressed)
	%Quit.pressed.connect(_on_quit_pressed)


func _on_start_pressed():
	get_tree().change_scene_to_packed(game_scene)


func _on_quit_pressed():
	get_tree().quit()
