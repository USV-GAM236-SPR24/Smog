extends Enemy


var draining = false
var drain_tick_rate: float = 2.0
var drain_tick_progress: float = drain_tick_rate
var stun_time: float = 5.0


func _init() -> void:
	health = 5
	damage = 5
	speed = 10


func _ready() -> void:
	sprite = $AnimatedSprite2D
	detection_area = $DetectionArea2D
	nav_agent = $NavigationAgent2D
	super._ready()


func _process(delta: float) -> void:
	super._process(delta)
	if draining:
		drain_tick_progress += delta
		if drain_tick_progress >= drain_tick_rate:
			Sanity.decrease(damage)
			drain_tick_progress -= drain_tick_rate


func _on_body_entered_drain(body):
	if not body is Player:
		return
	draining = true


func _on_body_exited_drain(body):
	if not body is Player:
		return
	draining = false
	drain_tick_progress = drain_tick_rate


func die():
	damage = 0
	speed = 0
	await get_tree().create_timer(stun_time).timeout
	health = 5
	damage = 5
	speed = 10
