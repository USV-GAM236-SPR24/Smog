class_name Enemy
extends Entity


var health = 100
var damage = 10


func _on_shoot():
	health -= 1


func die():
	super.die()
	queue_free()
