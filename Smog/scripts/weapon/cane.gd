extends MeleeWeapon



@onready var _player: CharacterBody2D = get_parent()

var direction_data: Dictionary = {
	Vector2.RIGHT: { "rotation": 0, "animation": "cane_right" },
	Vector2.LEFT:  { "rotation": 180, "animation": "cane_left" },
	Vector2.UP:    { "rotation": 270, "animation": "cane_up" },
	Vector2.DOWN:  { "rotation": 90, "animation": "cane_down", "offset": Vector2(0, 6) }
}


func _init() -> void:
	weapon_name = "cane"
	damage = 1

func _update_collision(direction: Vector2) -> void:
	%CollisionPivot.rotation_degrees = direction_data[direction]["rotation"]

func attack(direction: Vector2, sprite: AnimatedSprite2D) -> void:
	if direction_data.has(direction):
		var data = direction_data[direction]
		_update_collision(direction)
		$CaneSFX.play()
		sprite.play(data["animation"])
		if data.has("offset"):
			sprite.offset = data["offset"]
		_call_hit_events(%Collision.get_overlapping_bodies())

func _call_hit_events(bodies: Array) -> void:
	for body in bodies:
		if body.has_method("_take_damage"):
			body._take_damage(damage)
