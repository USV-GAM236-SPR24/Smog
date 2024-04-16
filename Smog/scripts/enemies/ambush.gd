extends Enemy


var emerged := false
var grab_area: Area2D
var grabbing := false
var damaged_this_attack := false
var player_speed: int
@onready var puddle_sfx = $Puddle

func _init() -> void:
	health = 1
	damage = 20
	speed = 25


func _ready() -> void:

	sprite = $AnimatedSprite2D
	detection_area = $DetectionArea2D
	grab_area = $GrabArea2D
	nav_agent = $NavigationAgent2D
	death = $Death
	attack = $Atk

	grab_area.body_entered.connect(_on_body_entered_grab)
	grab_area.body_exited.connect(_on_body_exited_grab)
	super._ready()
	sprite.play("puddle")
	$Puddle.play()


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if not emerged:
		return
	if grab_area.get_overlapping_bodies().has(player):
		grabbing = true
		if sprite.animation.begins_with("attack") and sprite.frame == 4:
			if not damaged_this_attack:
				Sanity.decrease(damage)
				damaged_this_attack = true
		else:
			damaged_this_attack = false
		return
	grabbing = false


func update_animation() -> void:
	dirty_animation = false
	if not emerged:
		return
	if grabbing:
		if not player:
			return
		play_attack_animation(position.direction_to(player.position))
		return
	$Walk.play()
	super.update_animation()


func play_attack_animation(direction: Vector2) -> void:
	if not grabbing:
		return
	if sprite.animation.begins_with("attack") and sprite.is_playing():
		return
	if abs(direction.x) >= abs(direction.y):
		sprite.flip_h = false
		if direction.x < 0:
			attack.play()
			sprite.play("attack_left")
		else:
			attack.play()
			sprite.play("attack_right")
		return
	if direction.y < 0:
		attack.play()
		sprite.play("attack_up")
		return
	attack.play()
	sprite.play("attack_down")


func _on_body_entered(body: Node) -> void:
	if not emerged and body is Player:
		player = body
		player_speed = player.speed
		puddle_sfx.stop()
		sprite.play("emerge")
		await sprite.animation_finished
		emerged = true
	super._on_body_entered(body)


func _on_body_entered_grab(body: Node) -> void:
	if not emerged or not body is Player:
		return
	if not player:
		player = body
	grabbing = true
	player.speed = speed


func _on_body_exited_grab(body: Node) -> void:
	if not emerged or not body is Player:
		return
	grabbing = false
	player.speed = player_speed

func die() -> void:
	death_sfx.play()
	grabbing = false
	if player:
		player.speed = player_speed
	super.die()
