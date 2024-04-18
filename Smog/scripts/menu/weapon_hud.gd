extends Control


var ammo_full: Texture2D = preload("res://art/UI/ammo_full_trimmed.tres")
var ammo_empty: Texture2D = preload("res://art/UI/ammo_empty_trimmed.tres")

var ammo_amount: int = 10:
	get:
		return ammo_amount
	set(value):
		ammo_amount = value
		_clear_grid()
		_update_grid()


func _ready():
	var icon_base := TextureRect.new()
	icon_base.stretch_mode = TextureRect.STRETCH_KEEP
	icon_base.texture = ammo_empty
	for i in range(ammo_amount):
		var ammo_icon: TextureRect = icon_base.duplicate()
		%Ammo.add_child(ammo_icon)
	_update_grid()


func _clear_grid():
	for ammo_icon in %Ammo.get_children():
		ammo_icon.texture = ammo_empty
		

func _update_grid() -> void:
	
	if not ammo_amount > 0:
		return
	
	for i in range(min(ammo_amount, 10)):
		%Ammo.get_children()[i].texture = ammo_full
