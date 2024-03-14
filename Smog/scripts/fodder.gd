class_name EnemyFodder
extends Enemy


var player: Player
var player_chase = false
var draining = false
var drain_tick_rate = 0.5
var drain_tick_progress = drain_tick_rate


func _init() -> void:
	speed = 25
	damage = 5


func _physics_process(delta):
	if health <= 0:
		return
	if player_chase:
		if player:
			velocity = position.direction_to(player.position) * speed
			$AnimatedSprite2D.play("walk")
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("idle")
	if draining:
		drain_tick_progress += delta
		if drain_tick_progress >= drain_tick_rate:
			Sanity.decrease(damage)
			drain_tick_progress -= drain_tick_rate
	move_and_slide()


func _on_detection_area_body_entered(body):
	if not body is Player:
		return
	player_chase = true
	if not player:
		player = body


func _on_detection_area_body_exited(body):
	if not body is Player:
		return
	player_chase = false
	if not player:
		player = body


func _on_hitbox_body_entered(body):
	if not body is Player:
		return
	draining = true
	if not player:
		player = body


func _on_hitbox_body_exited(body):
	if not body is Player:
		return
	draining = false
	drain_tick_progress = drain_tick_rate
	if not player:
		player = body


func die():
	if $AnimatedSprite2D.animation != "death":
		$AnimatedSprite2D.play("death")
		return
	if $AnimatedSprite2D.is_playing():
		return
	super.die()
