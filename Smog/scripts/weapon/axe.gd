extends Weapon

func _ready():
	weapon_name = "axe"
	## This sets the damage value of the axe melee weapon.
	damage = 50

#func _on_MeleeWeapon_body_entered(area):
	#if area.is_in_group("enemy"):
		# Deal damage to the enemy
		#area.take_damage(damage)


func _on_body_entered(body):
	if body.has_method("_take_damage"):
		body._take_damage(damage)
