class_name EnemyFodder
extends Enemy


const anim_scene: PackedScene = preload("res://scenes/animations/blood_wall.tscn")

var player_chase = false
var draining = false
var drain_tick_rate = 0.5
var drain_tick_progress = drain_tick_rate
var death_angle: Vector2

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


func _on_body_entered_drain(body):
	if not body is Player:
		return
	draining = true


func _on_body_exited_drain(body):
	if not body is Player:
		return
	draining = false
	drain_tick_progress = drain_tick_rate


func _take_damage(delta: int = 1):
	await get_tree().create_timer(0.3).timeout
	$AnimatedSprite2D.self_modulate = Color.RED
	await get_tree().create_timer(0.3).timeout
	$AnimatedSprite2D.self_modulate = Color.WHITE
	super._take_damage(delta)


func die():
	if $AnimatedSprite2D.animation != "death":
		var anim_instance = anim_scene.instantiate()
		$AnimatedSprite2D.play("death")

		anim_instance.name = "BloodAnim"
		get_parent().add_child(anim_instance)
		get_parent().move_child(get_parent().get_node("BloodAnim"), 0)
		get_parent().get_node("BloodAnim").position = self.position + Vector2(0, 15) #offset
		get_parent().get_node("BloodAnim").get_node("BloodWallAnimatedSprite")._update_direction(death_angle)

		return

	if $AnimatedSprite2D.is_playing():
		return
	super.die()
