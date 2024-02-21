extends TextureProgressBar


func _enter_tree() -> void:
	Sanity.sanity_changed.connect(_on_sanity_changed)


func _on_sanity_changed(_old: int, new: int) -> void:
	value = new


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		Sanity.change(randi_range(0, 100))
