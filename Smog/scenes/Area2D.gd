extends Area2D

signal trainShown

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("mouse_entered", _showTrain)

func _showTrain() -> void:
	print("Train shown")
	emit_signal("trainShown")
