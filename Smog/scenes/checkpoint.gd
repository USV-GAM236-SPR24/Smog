extends Node2D

@export var checkpoint_name : String


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		SaveSystem.set_var("checkpoint " + checkpoint_name, true)
		SaveSystem.save()
