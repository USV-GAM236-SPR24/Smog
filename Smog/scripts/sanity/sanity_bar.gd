extends TextureProgressBar


func _enter_tree() -> void:
	Sanity.sanity_changed.connect(_on_sanity_changed)
	value = Sanity.current


func _on_sanity_changed(_old: float, new: float) -> void:
	value = new


func _input(event: InputEvent) -> void:
	
	if event is InputEventKey:
		match event.keycode: 
			KEY_RIGHT: Sanity.increase(step)
			KEY_LEFT: Sanity.decrease(step)
			KEY_SPACE: Sanity.change(randi_range(0, 100))
			_: return
