extends StaticBody2D

class Enemy:

	var health = 100
	var damage = 10

func _on_shoot():
	print("Enemy is aware of the player's presence")
