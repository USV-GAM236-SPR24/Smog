class_name Enemy
extends Entity


var health = 5
var damage = 10


func _process(_delta: float) -> void:
	if health <= 0:
		die()


func _on_shoot():
	health -= Global.player_attack
