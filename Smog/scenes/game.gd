extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.connect("trainShown", train)
	
func train() -> void:
	$Area2D/Sprite2D.visible = !$Area2D/Sprite2D.visible
	$Area2D/trainnoise.play()
	
	
	
