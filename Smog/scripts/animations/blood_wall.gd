extends AnimatedSprite2D


func _enter_tree() -> void:
	animation_finished.connect(idle)


func trigger() -> void:
	if is_playing():
		return
	play("trigger")


func idle() -> void:
	play("idle")


func _on_body_entered(body: Node2D) -> void:
	if is_playing():
		return
	if body is Player:
		trigger()
