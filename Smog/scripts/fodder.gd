class_name EnemyFodder
extends Enemy


var player_chase = false


func _init() -> void:
	speed = 25


func _physics_process(_delta):
	if player_chase:
		velocity = position.direction_to(get_node("/root/Game/Player").position) * speed
		$AnimatedSprite2D.play("walk")
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("idle")
	move_and_slide()


func _on_detection_area_body_entered(body):
	if body is Player:
		player_chase = true


func _on_detection_area_body_exited(body):
	if body is Player:
		player_chase = false
	

func _on_hitbox_body_entered(body):
	if body is Player:
		Sanity.decrease(damage)
