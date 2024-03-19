extends Control

var ammo_amount: int = 10:
	get:
		return ammo_amount
	set(value):
		ammo_amount = value
		_clear_grid()
		_update_grid()


func _ready():
	_update_grid()

func _clear_grid():
	for panel in %GridContainer.get_children():
		panel.queue_free()
		

func _update_grid() -> void:
	
	if not ammo_amount > 0:
		return
	
	%GridContainer.set_columns(ammo_amount)
	
	for i in range(ammo_amount):
		var panel: TextureRect = TextureRect.new()
		panel.texture = load("res://art/UI/whitebar_8x4.png")
		%GridContainer.add_child(panel)
