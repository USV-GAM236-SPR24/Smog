class_name Enemy
extends Entity


var health = 5
var damage = 10


func _on_shoot():
	health -= 1
	if health <= 0:
		die()
