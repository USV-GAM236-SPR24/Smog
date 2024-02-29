class_name EnemyFodder
extends Enemy


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
		velocity = position.direction_to(get_node("/root/Game/Player").position) * speed
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
	if body is Player:
		player_chase = true


func _on_detection_area_body_exited(body):
	if body is Player:
		player_chase = false
	

func _on_hitbox_body_entered(body):
	if body is Player:
		draining = true
		

func _on_hitbox_body_exited(body):
	if body is Player:
		draining = false
		drain_tick_progress = drain_tick_rate


func die():
	if $AnimatedSprite2D.animation != "death":
		$AnimatedSprite2D.play("death")
		return
	if $AnimatedSprite2D.is_playing():
		return
	super.die()
