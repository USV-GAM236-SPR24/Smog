extends TextureProgressBar


func _enter_tree() -> void:
	Sanity.sanity_changed.connect(_on_sanity_changed)


func update_bar(new: int):
	value = new


func _on_sanity_changed(old: int, new: int) -> void:
	update_bar(new)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		Sanity.change(randi_range(0, 100))
