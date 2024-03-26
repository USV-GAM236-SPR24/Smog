extends Enemy


var dirty_animation := false
var emerged := false
var chasing := false
var last_delta: float = 0
var reached_threshold: float = 2
var player: Player

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $DetectionArea2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D


func _init() -> void:
	health = 1
	damage = 20
	speed = 50


func _ready() -> void:
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)
	nav_agent.velocity_computed.connect(_on_velocity_computed)
	sprite.play("puddle")


func _process(_delta: float) -> void:
	if dirty_animation:
		update_animation()


func _physics_process(delta: float) -> void:
	if not player:
		return
	last_delta = delta
	update_agent_target(player)
	if chasing:
		#velocity = position.direction_to(player.position) * speed
		var next_path_position: Vector2 = nav_agent.get_next_path_position()
		var new_velocity: Vector2 = position.direction_to(next_path_position) * speed
		if nav_agent.avoidance_enabled:
			nav_agent.velocity = new_velocity
		else:
			compute_velocity(new_velocity)
		move_and_slide()


func compute_velocity(safe_velocity: Vector2) -> void:
	dirty_animation = true
	velocity = safe_velocity
	var collision: KinematicCollision2D = move_and_collide(velocity * last_delta)
	if collision:
		velocity = velocity.slide(collision.get_normal()).normalized() * speed
		if velocity.y == 0:
			if abs(position.x - player.position.x) < reached_threshold:
				velocity = Vector2.ZERO
		if velocity.x == 0:
			if abs(position.y - player.position.y) < reached_threshold:
				velocity = Vector2.ZERO
	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO


func play_walk_animation(direction: Vector2) -> void:
	if abs(direction.x) >= abs(direction.y):
		sprite.flip_h = false
		sprite.play("walk_side")
		if direction.x < 0:
			sprite.flip_h = true
		return
	if direction.y < 0:
		sprite.play("walk_up")
		return
	sprite.play("walk_down")


func update_animation() -> void:
	if emerged and not chasing:
		if sprite.animation.begins_with("walk"):
			var suffix: String = sprite.animation.substr("walk".length())
			sprite.play("idle" + suffix)
			dirty_animation = false
			return
		sprite.flip_h = false
		sprite.play("idle_down")
	if emerged and chasing:
		play_walk_animation(velocity)
	dirty_animation = false


func update_agent_target(target: Player) -> void:
	nav_agent.set_target_position(target.position)


func _on_body_entered(body: Node) -> void:
	if not body is Player:
		return
	if not player:
		player = body
	if not emerged:
		sprite.play("emerge")
		await sprite.animation_finished
		emerged = true
	chasing = true
	dirty_animation = true


func _on_body_exited(body: Node) -> void:
	if not body is Player:
		return
	if not player:
		player = body
	chasing = false
	dirty_animation = true


func _on_velocity_computed(safe_velocity: Vector2) -> void:
	compute_velocity(safe_velocity)
