extends TextureProgressBar


func _enter_tree() -> void:
	Sanity.sanity_changed.connect(_on_sanity_changed)
	value = Sanity.current


func _on_sanity_changed(_old: float, new: float) -> void:
	value = new


func _input(event: InputEvent) -> void:
	if event.is_released():
		return
	if event.is_action("ui_accept"):
		Sanity.change(randi_range(0, 100))
	elif event.is_action("ui_left"):
		Sanity.decrease(step)
	elif event.is_action("ui_right"):
		Sanity.increase(step)
