extends Weapon

@onready var animation = $AnimationPlayer

func _ready():
	weapon_name = "axe"
	## This sets the damage value of the axe melee weapon.
	damage = 50

func _attack():
	animation.play("swing")

func _on_body_entered(body):
	if body.has_method("_take_damage"):
		body._take_damage(damage)
