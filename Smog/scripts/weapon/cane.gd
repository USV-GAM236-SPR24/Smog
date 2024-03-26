extends MeleeWeapon

@onready var _player: CharacterBody2D = get_parent()

func _ready():
	weapon_name = "cane"
	## This sets the damage value of the axe melee weapon.
	damage = 1

var direction_data: Dictionary = {
	Vector2.RIGHT: { "rotation": 0, "animation": "poke_right" },
	Vector2.LEFT:  { "rotation": 180, "animation": "poke_left" },
	Vector2.UP:    { "rotation": 270, "animation": "poke_up" },
	Vector2.DOWN:  { "rotation": 90, "animation": "poke_down" }
}

func _update_collision() -> void:
	%CollisionPivot.rotation_degrees = direction_data[_player.last_direction]["rotation"]

func poke() -> void:
	_player._hide(true)

	if direction_data.has(_player.last_direction):
		var data = direction_data[_player.last_direction]
		%AnimationPlayer.play(data["animation"])
		_call_hit_events(%Collision.get_overlapping_bodies())

	#end of animation
	await get_tree().create_timer(0.4).timeout

	_player._hide(false)

func _call_hit_events(bodies: Array) -> void:
	for body: Entity in bodies:
		if body.has_method("take_damage"): #and weapon_name == "axe":
			body.take_damage(damage)
