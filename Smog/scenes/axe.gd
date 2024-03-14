extends Area2D


## This sets the damage value of the axe melee weapon.
const DAMAGE_AMOUNT = 50

func _ready():
	set_collision_layer_value(2, true) # Set collision layer to 2 (player)
	set_collision_mask_value(1, true) # Collide with enemies

func _on_MeleeWeapon_area_entered(area):
	if area.is_in_group("enemy"):
		# Deal damage to the enemy
		area.take_damage(DAMAGE_AMOUNT)
