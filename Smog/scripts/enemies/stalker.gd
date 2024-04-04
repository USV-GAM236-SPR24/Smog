extends Enemy


var draining := false
var drain_tick_rate: float = 2.0
var drain_tick_progress: float = drain_tick_rate
var stun_time: float = 5.0
var stunned := false

var drain_area: Area2D


func _init() -> void:
	health = 5
	damage = 20
	speed = 5


func _ready() -> void:
	sprite = $AnimatedSprite2D
	detection_area = $DetectionArea2D
	drain_area = $DrainingArea2D
	nav_agent = $NavigationAgent2D
	drain_area.body_entered.connect(_on_body_entered_drain)
	drain_area.body_exited.connect(_on_body_exited_drain)
	super._ready()


func _process(delta: float) -> void:
	if stunned:
		return
	super._process(delta)
	if draining:
		drain_tick_progress += delta
		if drain_tick_progress >= drain_tick_rate:
			Sanity.decrease(damage)
			drain_tick_progress -= drain_tick_rate


func _physics_process(delta: float) -> void:
	if stunned:
		return
	super._physics_process(delta)


func update_animation() -> void:
	dirty_animation = false
	if draining:
		if not player:
			return
		if !$StalkerATK.is_playing():
			$StalkerATK.play()
		play_attack_animation(position.direction_to(player.position))
		return
	super.update_animation()


func play_attack_animation(direction: Vector2) -> void:
	if not draining:
		return
	if sprite.animation.begins_with("attack") and sprite.is_playing():
		await sprite.animation_finished
		return
	if abs(direction.x) >= abs(direction.y):
		sprite.flip_h = false
		if use_flip:
			sprite.play("attack_side")
		else:
			sprite.play("attack_right")
		if direction.x < 0:
			if use_flip:
				sprite.flip_h = true
			else:
				sprite.play("attack_left")
		return
	if direction.y < 0:
		sprite.play("attack_up")
		return
	sprite.play("attack_down")


func _on_body_entered_drain(body):
	if not body is Player:
		return
	draining = true


func _on_body_exited_drain(body):
	if not body is Player:
		return
	draining = false
	drain_tick_progress = 0


func die():
	damage = 0
	speed = 0
	stunned = true
	$StalkerStun.play()
	sprite.play("idle_down")
	sprite.pause()
	await get_tree().create_timer(stun_time).timeout
	sprite.play(sprite.animation)
	stunned = false
	health = 5
	damage = 20
	speed = 5

	
