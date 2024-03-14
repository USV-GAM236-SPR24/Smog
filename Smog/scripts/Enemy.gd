class_name Enemy
extends Entity


var health = 5
var damage = 10


func _process(_delta: float) -> void:
	if health <= 0:
		die()


func _take_damage(delta: int = 0):
	print('enemy hit!')
	health -= delta
